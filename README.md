# Shielded Auctions — Private Bidding with FHEVM

## 🪄 Introduction
Shielded Auctions is a sealed-bid auction protocol powered by Zama’s Fully Homomorphic Encryption Virtual Machine (FHEVM).  
It enables users to place encrypted bids on-chain, ensuring fairness, confidentiality, and resistance to front-running bots.  

## 🌟 Key Highlights
- 🔒 Bids remain fully encrypted until the reveal phase.  
- 🤖 Prevents bot sniping and mempool monitoring.  
- 🔗 Works for NFTs, fungible tokens, or any digital asset.  
- ⚡ Compatible with Solidity and deployable on EVM chains.  
- 🧪 Includes automated tests for bidding, reveal, and winner logic.  

## 📂 Project Structure
shielded-auctions/  
├── contracts/  
│   └── ShieldedAuction.sol  
├── test/  
│   └── ShieldedAuction.spec.ts  
├── hardhat.config.ts  
├── package.json  
├── .gitignore  
├── LICENSE  
└── README.md  

## 🚀 Setup & Usage
1. Install dependencies  
   npm install  

2. Compile contracts  
   npx hardhat compile  

3. Run the tests  
   npx hardhat test  

## 🎯 Example Scenarios
- Fair NFT drops where bidders remain anonymous until reveal.  
- Token sales without exposing bids in real time.  
- On-chain auctions that resist market manipulation.  

## 📝 License
This project is licensed under the MIT License.  
MIT © 2025 danizamig
