# Shielded Auctions – Confidential Bidding with FHEVM

## Overview
Shielded Auctions is a sealed-bid auction demo built with Zama’s FHEVM.  
It enables confidential bidding where all bids remain encrypted onchain.  
Only the winner and seller can decrypt the final price.

## Features
- Encrypted sealed-bid submissions
- Highest bid determined without revealing values
- Winner and seller can decrypt final price
- Prevents front-running and bid manipulation

## Tech Stack
- Solidity + FHEVM
- Hardhat + TypeScript
- Zama SepoliaConfig for FHE integration

## Tests
- Submit encrypted bids
- Determine encrypted highest bid
- Decrypt final price for winner + seller

## License
MIT
