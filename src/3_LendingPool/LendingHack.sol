// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {USDC} from "./USDC.sol";

/**
 * @title LendingPool
 */
contract LendingHack is Ownable {
    /*//////////////////////////////
    //    Add your hack below!    //
    //////////////////////////////*/
    string public constant name = "LendingPool hack";
    USDC public usdc;

    /**
     * @dev Constructor that sets the owner of the contract
     * @param _usdc The address of the USDC contract to use
     * @param _owner The address of the owner of the contract
     */
    constructor(address _owner, address _usdc) {
        _transferOwnership(_owner);
        usdc = USDC(_usdc);
        usdc.transfer(_owner, usdc.balanceOf(address(this)));
    }

    //============================//
}
