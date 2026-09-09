// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
import {Script} from "../lib/forge-std/src/Script.sol";
import {TCH8OZ} from "../src/TCH8OZ.sol";
import {console} from "../lib/forge-std/src/console.sol";

contract TCH80ZScript is Script {
    string public _name = "TechCrush08";
    string public _symbol = "TCH";
    address private protocol = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 public AmountToMint = 1_000_000e18;

    TCH8OZ public tokenTCH;

    function run() public {
        vm.startBroadcast(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        tokenTCH = new TCH8OZ(_name, _symbol, protocol);
        tokenTCH.mint(protocol, AmountToMint);
        console.log("this is the address of my ERC80Z contract", address(tokenTCH));
        vm.stopBroadcast();
    }
}