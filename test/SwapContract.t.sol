// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SwapContract} from "../src/SwapContract.sol";
import {TokenA} from "../src/Token.sol";
import {TokenB} from "../src/Token.sol";

contract CounterTest is Test {
    SwapContract public swapContract;

    function setUp() public {
        // swapContract = new SwapContract(TokenA, TokenB);
    }

    function test_Increment() public {
 
    }

    function testFuzz_SetNumber(uint256 x) public {

    }
}
