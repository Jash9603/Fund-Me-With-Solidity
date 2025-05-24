// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";



contract HelperConfig is Script{
    // if we are on anvil then we deploy mock 
    // otherwise we grab existing address for live network

    uint8 public constant DECIMALS = 18;
    int256 public constant INITIAL_PRICE = 2000e8; // 2000.00000000
    
    
    struct NetworkConfig{
        address PriceFeed; // eth/usd price feed address
    }
    NetworkConfig public activeNetwork;

    constructor() {
        if(block.chainid == 11155111){
            activeNetwork = getSepholiaEthConfig();
        }else if(block.chainid == 1){
            activeNetwork = getMainnetEthConfig();
        }else{
            activeNetwork = getOrCreateAnvilEthConfig();
        }
    }

    function getSepholiaEthConfig() public pure returns (NetworkConfig memory){
        // price feed address
        NetworkConfig memory sepoliaconfig = NetworkConfig({PriceFeed : 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaconfig;
        
    }
     function getMainnetEthConfig() public pure returns (NetworkConfig memory){
        // price feed address
        NetworkConfig memory ethconfig = NetworkConfig({PriceFeed : 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethconfig;
        
    }
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory){
        if(activeNetwork.PriceFeed != address(0)){
            return activeNetwork;
        }
        // here we need to do 2 things 
        // deploy mock contract on anvil 
        //retrun the mock address

       vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({PriceFeed : address(mockV3Aggregator)});
        return anvilConfig;


        

    }

    

}
