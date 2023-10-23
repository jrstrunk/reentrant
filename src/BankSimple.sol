// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BankSimple {
    mapping(address => uint256) public balances;

    error UnableToWithdrawal();

    function deposit() public payable {
        balances[msg.sender] += msg.value;    
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function withdrawal() public {
        uint256 amount = balances[msg.sender];
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) {
            revert UnableToWithdrawal();
        }
        balances[msg.sender] = 0;
    }
}