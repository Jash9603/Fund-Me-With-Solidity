
//SPDX-License-Identifier: MIT

// it contain all the things that are needed to interact with the contract
// here we have 2 things. 
// 1. fund
// 2. withdraw

pragma solidity ^0.8.18;
import {Script} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {console} from "../lib/forge-std/src/console.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function FundfundMe(address mostRecentDeployment) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployment)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded contract with %s", SEND_VALUE);

    }
    function run() external view {
        
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        FundFundMe(mostRecentDeployment);
          
    }
    

    
}

contract WithdrawFundMe is Script {
 function Fundwithdrawl(address mostRecentDeployment) public {
       
        FundMe(payable(mostRecentDeployment)).withdraw();
        console.log("Withdrew funds from contract");
      


    }
    function run() external {
        vm.startBroadcast();
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        Fundwithdrawl(mostRecentDeployment);
          vm.stopBroadcast();
    }
}