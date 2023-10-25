// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {BankSimple} from "../src/BankSimple.sol";
import {BankSimpleAttack} from "../src/BankSimpleAttack.sol";

contract BankSimpleTest is Test {
    BankSimple public bank;

    function setUp() public {
        bank = new BankSimple();
    }

    // function test_Deposit() public {
    //     bank.deposit();
    // }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}

contract BankSimpleAttackTest is Test {
    BankSimple public bank;
    BankSimpleAttachk public bankAttack;

    function setUp() public {
        bank = new BankSimple();
        bankAttack = new BankSimpleAttack();
    }

}
