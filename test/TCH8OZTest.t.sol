//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {TCH8OZ} from "../src/TCH8OZ.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract TCH80ZTest is Test {
    string public name = "TECHCRUSH8";
    string public symbol = "TCH8";
    TCH8OZ public newTCH08;

    address public protocol = makeAddr("protocol");
    address public chibuzor = makeAddr("chibuzor");
    address public kelechi = makeAddr("kelechi");

    uint256 amountToMint = 1_000_000e18;

    function setUp() public {
        newTCH08 = new TCH8OZ(name, symbol, protocol);
    }

    function testName() public view {
        string memory expectedName = "TECHCRUSH8";
        assertEq(newTCH08.name(), expectedName);
    }

    function testSymbol() public view {
        string memory expectedSymbol = "TCH8";
        assertEq(newTCH08.symbol(), expectedSymbol);
    }

    function testDecimal() public view {
        uint8 expectedDecimal = 6;
        assertEq(newTCH08.decimals(), expectedDecimal);
    }

    function testMint() public {
        uint256 expectedAmountToMint = 1_000_000e18;
        vm.prank(protocol);
        newTCH08.mint(address(newTCH08), amountToMint);
        uint256 balanceAfterMint = newTCH08.balanceOf(address(newTCH08));
        assertEq(balanceAfterMint, expectedAmountToMint);
    }

    function testTransfer() public {
        vm.startPrank(protocol);
        newTCH08.mint(protocol, amountToMint);
        newTCH08.transfer(chibuzor, 1000);
        vm.stopPrank();

        assertEq(newTCH08.balanceOf(chibuzor), 1000);
        assertEq(newTCH08.balanceOf(protocol), amountToMint - 1000);
    }

    function testTransferFrom() public {
        vm.prank(protocol);
        newTCH08.mint(protocol, amountToMint);

        vm.prank(protocol);
        newTCH08.approve(kelechi, 1000);

        vm.prank(kelechi);
        newTCH08.transferFrom(protocol, chibuzor, 1000);

        assertEq(newTCH08.balanceOf(chibuzor), 1000);
        assertEq(newTCH08.balanceOf(protocol), amountToMint - 1000);
        assertEq(newTCH08.allowance(protocol, kelechi), 0);
    }

    function testBurn() public {
        vm.prank(protocol);
        newTCH08.mint(chibuzor, amountToMint);

        uint256 balanceBeforeBurn = newTCH08.balanceOf(chibuzor);

        vm.prank(protocol);
        newTCH08.burn(chibuzor, 1000);

        uint256 balanceAfterBurn = newTCH08.balanceOf(chibuzor);

        assertEq(balanceAfterBurn, balanceBeforeBurn - 1000);
        assertEq(newTCH08.totalSupply(), amountToMint - 1000);
    }

        function testMintRevertsIfNotProtocol() public {
        // chibuzor is not the protocol, so this call should revert
        vm.prank(chibuzor);
        vm.expectRevert(TCH8OZ.onlyProtocolAddressError.selector);
        newTCH08.mint(chibuzor, amountToMint);
    }

    function testBurnRevertsIfNotProtocol() public {
        // mint legitimately first so there's something to burn
        vm.prank(protocol);
        newTCH08.mint(chibuzor, amountToMint);

        // kelechi is not the protocol, so this call should revert
        vm.prank(kelechi);
        vm.expectRevert(TCH8OZ.onlyProtocolAddressError.selector);
        newTCH08.burn(chibuzor, 1000);
    }
}

// forge test --match-test testTransfer -vvvvvvvvv