// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TokenA} from "../src/Token.sol";

contract CounterScript is Script {
    TokenA public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new TokenA();

        vm.stopBroadcast();
    }
}

