// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {Test} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

import {console} from "../../lib/forge-std/src/console.sol";
import {FundFundMe,WithdrawFundMe} from "../../script/Interaction.s.sol";


contract InteractionTest is Test {

    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant STARTINGBALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;
    address OWNER;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
         OWNER = address(this);
        vm.deal(USER, STARTINGBALANCE);

    }

    function testUserCanFundInteraction() public {
    vm.deal(USER, 1e18);
    vm.prank(USER);
    fundMe.fund{value: 0.1 ether}();

    address funder = fundMe.getFunder(0);
    assertEq(funder, USER);
    }

    

}