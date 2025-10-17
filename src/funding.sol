// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Donation {
    uint256 targetAmount;
    uint256 totalDonated;
    address creator;
    uint256 timestamp;
    string description;
}

interface IFunding {
    // externals
    function createDonation(uint256 amount, string memory description) external returns (uint256);
    function getDonation(uint256 id) external view returns (Donation memory);
    function getTotalDonated(uint256 id) external view returns (uint256);
    function donate(uint256 id, uint256 amount) external;

    // events
    event DonationCreated(uint256 id, uint256 amount, address creator, uint256 timestamp, string description);
    event DonationMade(uint256 id, address donor, uint256 amount);
}

contract Funding is IFunding {
    // State variables
    uint256 public totalDonations;
    address public owner;
    mapping(uint256 => Donation) private donations; // map of donation id to amount
    mapping(address => bool) private isDonor;
    mapping(address => bool) private isBeneficiary;

    constructor(address _owner) {
        owner = _owner;
    }

    function createDonation(uint256 amount, string memory description) public returns (uint256) {
        checkDonation(amount, description);
        uint256 id = totalDonations;
        totalDonations++;
        donations[id] = Donation({
            targetAmount: amount,
            totalDonated: 0,
            creator: msg.sender,
            timestamp: block.timestamp,
            description: description
        });
        emit DonationCreated(id, amount, msg.sender, block.timestamp, description);

        return id;
    }

    function getDonation(uint256 id) external view returns (Donation memory) {
        return donations[id];
    }

    function donate(uint256 id, uint256 amount) external {
        checkDonation(amount, "donation");
        isDonor[msg.sender] = true;

        uint256 totalAmount = donations[id].totalDonated + amount;
        require(totalAmount <= donations[id].targetAmount);

        emit DonationMade(id, msg.sender, amount);
    }

    function getTotalDonated(uint256 id) external view returns (uint256) {
        return donations[id].totalDonated;
    }

    // Private functions
    function checkDonation(uint256 amount, string memory description) private view {
        require(amount > 0, "Amount must be greater than 0");
        require(bytes(description).length > 0, "Description must be provided");
        require(!isDonor[msg.sender], "You have already donated");
        require(!isBeneficiary[msg.sender], "You cannot donate to yourself");
    }
}

// 0x16279052BFEde721ed2662F41A754966a3E48124
