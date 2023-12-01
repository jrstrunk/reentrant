// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {BankSimple} from "../src/BankSimple.sol";
import {BankSimpleAttack} from "../src/BankSimpleAttack.sol";

contract BankSimpleTest is Test {
    BankSimple public bank;
    address public constant bankman = address(0x30);

    error UnableToWithdrawal();
    error InsufficientBalance();

    function setUp() public {
        bank = new BankSimple();
    }

    function testFuzz_Deposit(uint256 x) public {
        hoax(bankman, x);
        bank.deposit{value: x}();

        vm.prank(bankman);
        assertEq(bank.getBalance(), x);
    }

    function test_Withdrawal() public {
        hoax(bankman, 10 ether);
        bank.deposit{value: 9 ether}();

        vm.prank(bankman);
        bank.withdrawal();
    
        vm.prank(bankman);
        assertEq(bank.getBalance(), 0);

        assertEq(bankman.balance, 10 ether);
    }

    function test_UnableToDoubleWithdrawal() public {
        hoax(bankman, 10 ether);
        bank.deposit{value: 9 ether}();

        vm.prank(bankman);
        bank.withdrawal();
    
        vm.prank(bankman);
        assertEq(bank.getBalance(), 0);

        assertEq(bankman.balance, 10 ether);

        vm.prank(bankman);
        vm.expectRevert(InsufficientBalance.selector);
        bank.withdrawal();
    }
}

contract BankSimpleAttackTest is Test {
    BankSimple public bank;
    BankSimpleAttack public bankAttack;

    address public constant bankman = address(0x30);
    address public constant attacker = address(0x31);

    function setUp() public {
        bank = new BankSimple();
        bankAttack = new BankSimpleAttack(address(bank));
    }

    function test_ReentryAttack() public {
        hoax(bankman, 10 ether);
        bank.deposit{value: 10 ether}();

        hoax(attacker, 1 ether);
        bankAttack.deposit{value: 1 ether}();

        vm.prank(address(bankAttack));
        assertEq(bank.getBalance(), 1 ether);

        assertEq(address(bank).balance, 11 ether);

        vm.startPrank(attacker);
        bankAttack.attackWithdrawal();

        assertEq(address(bank).balance, 0);
        assertEq(address(bankAttack).balance, 11 ether);
        vm.stopPrank();
    }

}
