// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Funding} from "../src/funding.sol";

contract FundingScript is Script {
    Funding public funding;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        funding = new Funding(0x345b10A79E9fC89F33AEf7a92E621a25cd100876);

        vm.stopBroadcast();
    }
}
