// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { FHE, euint64, externalEuint64 } from "@fhevm/solidity/lib/FHE.sol";
import { SepoliaConfig } from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title ShieldedAuction - Confidential sealed-bid auction using FHEVM
contract ShieldedAuction is SepoliaConfig {
    address public seller;
    uint256 public biddingEnd;
    bool public ended;

    // Store encrypted bids
    mapping(address => euint64) private _bids;
    address[] private _bidders;

    address public highestBidder;
    euint64 private highestBid;

    constructor(uint256 biddingTime) {
        seller = msg.sender;
        biddingEnd = block.timestamp + biddingTime;
        highestBid = FHE.asEuint64(0);
    }

    /// @notice Submit an encrypted bid
    function bid(externalEuint64 encryptedAmount, bytes calldata inputProof) external {
        require(block.timestamp < biddingEnd, "Auction already ended");

        euint64 amount = FHE.fromExternal(encryptedAmount, inputProof);
        _bids[msg.sender] = amount;
        _bidders.push(msg.sender);

        FHE.allowThis(amount);
        FHE.allow(amount, msg.sender);

        // Update highest bid
        bool isHigher = FHE.gt(amount, highestBid);
        highestBid = FHE.select(isHigher, amount, highestBid);
        highestBidder = isHigher ? msg.sender : highestBidder;
    }

    /// @notice End the auction and reveal the winner only
    function endAuction() external {
        require(block.timestamp >= biddingEnd, "Auction not yet ended");
        require(!ended, "Auction already ended");
        require(msg.sender == seller, "Only seller can end auction");

        ended = true;
    }

    /// @notice Get encrypted highest bid (only for winner + seller)
    function getHighestBid() external view returns (euint64) {
        require(ended, "Auction not ended");
        FHE.allow(highestBid, highestBidder);
        FHE.allow(highestBid, seller);
        return highestBid;
    }
}
