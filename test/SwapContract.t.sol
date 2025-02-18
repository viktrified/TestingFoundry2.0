// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SwapContract.sol";
import "../src/Token.sol";

contract SwapContractTest is Test {
    SwapContract swapContract;
    TokenA tokenKWAG;
    TokenB tokenBLT;
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        tokenKWAG = new TokenA();
        tokenBLT = new TokenB();
        swapContract = new SwapContract(address(tokenKWAG), address(tokenBLT));

        tokenKWAG._mint(user1, 100 * 1e18);
        tokenBLT._mint(address(swapContract), 200 * 1e18);
        tokenBLT._mint(user1, 100 * 1e18);
        tokenKWAG._mint(address(swapContract), 200 * 1e18);

        vm.startPrank(user1);
        tokenKWAG.approve(address(swapContract), 100 * 1e18);
        tokenBLT.approve(address(swapContract), 100 * 1e18);
        vm.stopPrank();
    }

    function testOwner() public view {
        assertEq(swapContract.owner(), address(this), "Owner is not the same");
    }

    function testSwapKWAGToBLT() public {
        uint256 amount = 2 * 1e18;
        uint256 userBLTBalanceBefore = tokenBLT.balanceOf(user1);

        vm.prank(user1);
        swapContract.swapToken(amount, address(tokenKWAG));

        uint256 userBLTBalanceAfter = tokenBLT.balanceOf(user1);
        assertEq(
            userBLTBalanceAfter,
            userBLTBalanceBefore + amount * 3,
            "User should receive 3x BLT"
        );
    }

    function testSwapBLTToKWAG() public {
        uint256 amount = 2 * 1e18;
        uint256 userKWAGBalanceBefore = tokenKWAG.balanceOf(user1);

        vm.prank(user1);
        swapContract.swapToken(amount, address(tokenBLT));

        uint256 userKWAGBalanceAfter = tokenKWAG.balanceOf(user1);
        assertEq(
            userKWAGBalanceAfter,
            userKWAGBalanceBefore + amount * 2,
            "User should receive 2x BLT"
        );
    }

    function testIfSwapperHasSwaped() public {
        uint256 amount = 2 * 1e18;

        vm.prank(user1);
        swapContract.swapToken(amount, address(tokenBLT));

        (bool hasSwaped, ) = swapContract.getSwapper(user1);
        assertEq(hasSwaped, true, "User hasn't swapped");
    }

    function testNumberOfSwap() public {
        uint256 amount = 2 * 1e18;

        vm.prank(user1);
        swapContract.swapToken(amount, address(tokenBLT));

        (, uint numberOfSwaps) = swapContract.getSwapper(user1);
        assertEq(numberOfSwaps, 1, "User hasn't swapped");
    }

    function testShouldFailIfInvalidToken() public {
        vm.prank(user1);
        vm.expectRevert(Errors.InvalidToken.selector);

        swapContract.swapToken(2 * 1e18, address(this));
    }

    function testShouldFailIfInsufficientBalance() public {
        vm.prank(user1);
        vm.expectRevert(Errors.InsufficientBalance.selector);

        swapContract.swapToken(2000 * 1e18, address(tokenBLT));
    }

    function testContractBLTBalance() public {
        uint256 amount = 2 * 1e18;

        uint contractBalance = tokenKWAG.balanceOf(address(swapContract));

        vm.prank(address(swapContract));
        tokenKWAG.approve(address(this), type(uint256).max);
        tokenKWAG.transferFrom(address(swapContract), user2, contractBalance);

        vm.prank(user1);
        vm.expectRevert(Errors.InsufficientKWAG.selector);
        swapContract.swapToken(amount, address(tokenBLT));
    }

    function testContractKWAGBalance() public {
        uint256 amount = 2 * 1e18;

        uint contractBalance = tokenBLT.balanceOf(address(swapContract));

        vm.prank(address(swapContract));
        tokenBLT.approve(address(this), type(uint256).max);
        tokenBLT.transferFrom(address(swapContract), user2, contractBalance);

        vm.prank(user1);
        vm.expectRevert(Errors.InsufficientBLT.selector);
        swapContract.swapToken(amount, address(tokenKWAG));
    }

    function testToGetSwapper() public {
        uint256 amount = 2 * 1e18;

        vm.prank(user1);
        swapContract.swapToken(amount, address(tokenBLT));

        (bool hasSwaped, uint numberOfSwaps) = swapContract.getSwapper(user1);
        assertEq(hasSwaped, true, "User hasn't swapped");
        assertEq(numberOfSwaps, 1, "User swap didn't increment");
    }
}
