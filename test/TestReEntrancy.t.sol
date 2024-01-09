// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {EtherStore, Attack} from "../src/ReEntrancy.sol";


contract TestReEntrancy is Test {
    EtherStore etherStore;
    Attack attack;

    address constant public ALICE = address(1);
    address constant public BOB = address(2);
    address constant public EVE = address(3);

    function setUp() public {
    
        // 1. Deploy EtherStore
        etherStore = new EtherStore();

        // 2. Deposit 1 Ether each from Account 1 (Alice) and Account 2 (Bob) into EtherStore
        vm.prank(ALICE);
        vm.deal(ALICE, 1 ether);
        etherStore.deposit{value: 1 ether}();
        vm.stopPrank();

        vm.prank(BOB);
        vm.deal(BOB, 1 ether);
        etherStore.deposit{value: 1 ether}();
        vm.stopPrank();
        
        // 3. Deploy Attack with address of EtherStore
        attack = new Attack(address(etherStore));


    }


    function testAttack() public {

        // 4. Call Attack.attack sending 1 ether (using Account 3 (Eve)).
        console.log("attack balance", attack.getBalance());
        console.log("BOB Balance", BOB.balance);
        console.log("ALICE Balance", ALICE.balance);
        console.log("EVE Balance", EVE.balance);
        
        vm.prank(EVE);
        vm.deal(EVE, 1 ether);
        console.log("EVE Balance", EVE.balance);
        attack.attack{value: 1 ether}();
        

        console.log("attack balance", attack.getBalance()); //The attack contract instance has yoiked 2 ether from the etherstore   
        console.log("BOB Balance", BOB.balance);
        console.log("ALICE Balance", ALICE.balance);
        console.log("EVE Balance", EVE.balance);
        vm.stopPrank();
    }
}