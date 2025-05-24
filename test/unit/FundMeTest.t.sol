// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import "../../lib/forge-std/src/console.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";




contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant STARTINGBALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: STARTINGBALANCE}();
        _;
    }

     function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run(); // ✅ FIXED: call `run` on an instance
        vm.deal(USER, STARTINGBALANCE);
    }


     function testMinimunUsd() public view {
        uint256 MinUsd = fundMe.MINIMUM_USD();
        assertEq(MinUsd,5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

 function testGetVersionIsAccurate() public view{
    uint256 version = fundMe.getVersion();
    uint256 expectedVersion = AggregatorV3Interface(fundMe.getPriceFeed()).version();
    assertEq(version, expectedVersion);
}
    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }
    function testFundUpdatesFundedDataStructure() public funded{

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, 10e18);
        
    }
    function testAddFundersToArray() public funded {

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
      /*  vm.prank(USER);
        fundMe.fund{value: 10e18}();*/
     //   vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdwal() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawlWithMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingIndex = 1;
        for (uint160 i = startingIndex; i < numberOfFunders; i++) {
            //vm prank
            //vm deal
            
            hoax(address(i), STARTINGBALANCE);
            //fund new address
            fundMe.fund{value: STARTINGBALANCE}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        //withdraw

       // uint256 startGas = gasleft();
        //vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //uint256 endGas = gasleft();
        //uint256 gasUsed = (startGas - endGas) * tx.gasprice;
        //console.log("Gas used: ", gasUsed);


        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
        for (uint160 i = startingIndex; i < numberOfFunders; i++) {
            assertEq(fundMe.getAddressToAmountFunded(address(i)), 0);
        }
    }

//cheaper withdrawl 

    function testWithdrawlWithMultipleFundersCheaper() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingIndex = 1;
        for (uint160 i = startingIndex; i < numberOfFunders; i++) {
            //vm prank
            //vm deal
            
            hoax(address(i), STARTINGBALANCE);
            //fund new address
            fundMe.fund{value: STARTINGBALANCE}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

  
        vm.prank(fundMe.getOwner());
        fundMe.cheaperwithdrawl();



        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
        for (uint160 i = startingIndex; i < numberOfFunders; i++) {
            assertEq(fundMe.getAddressToAmountFunded(address(i)), 0);
        }
    }



}