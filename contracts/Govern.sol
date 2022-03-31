// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "./ERC20.sol";

contract Govern is ERC20 {
    IERC20 constant DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    mapping(address => bool) hasVoted;

    struct Proposal {
        uint256 yesCount;
        uint256 noCount;
        mapping(address => bool) hasVoted;
    }

    uint256 numProposals;
    mapping(uint256 => Proposal) public proposals;

    constructor() ERC20("Govern", "GOV") {}

    function buy(uint256 _amount) external {
        DAI.transferFrom(msg.sender, address(this), _amount);
        _mint(msg.sender, _amount);
    }

    function sell(uint256 _amount) external {
        _burn(msg.sender, _amount);
        DAI.transfer(msg.sender, _amount);
    }

    function vote(uint256 _proposalId, bool _supports) external {
        require(!hasVoted[msg.sender]);
        Proposal storage proposal = proposals[_proposalId];

        if (_supports) {
            proposal.yesCount += balanceOf(msg.sender);
        } else {
            proposal.noCount += balanceOf(msg.sender);
        }

        proposal.hasVoted[msg.sender] = _supports;
    }
}
