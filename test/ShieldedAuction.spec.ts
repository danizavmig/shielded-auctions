import { ShieldedAuction, ShieldedAuction__factory } from "../types";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";
import { ethers, fhevm } from "hardhat";
import { FhevmType } from "@fhevm/hardhat-plugin";
import { expect } from "chai";

describe("ShieldedAuction", function () {
  let auction: ShieldedAuction;
  let deployer: HardhatEthersSigner;
  let alice: HardhatEthersSigner;
  let bob: HardhatEthersSigner;
  let contractAddress: string;

  beforeEach(async () => {
    [deployer, alice, bob] = await ethers.getSigners();
    const factory = (await ethers.getContractFactory("ShieldedAuction")) as ShieldedAuction__factory;
    auction = (await factory.deploy(60)) as ShieldedAuction; // 60 seconds
    contractAddress = await auction.getAddress();
  });

  it("accepts encrypted bids and determines winner", async function () {
    // Encrypt bids
    const encAliceBid = await fhevm.createEncryptedInput(contractAddress, alice.address).add64(10).encrypt();
    const encBobBid = await fhevm.createEncryptedInput(contractAddress, bob.address).add64(15).encrypt();

    await (await auction.connect(alice).bid(encAliceBid.handles[0], encAliceBid.inputProof)).wait();
    await (await auction.connect(bob).bid(encBobBid.handles[0], encBobBid.inputProof)).wait();

    // Fast-forward time
    await ethers.provider.send("evm_increaseTime", [70]);
    await ethers.provider.send("evm_mine");

    await (await auction.connect(deployer).endAuction()).wait();

    const highestBidEnc = await auction.getHighestBid();
    const highestBid = await fhevm.userDecryptEuint(FhevmType.euint64, highestBidEnc, contractAddress, bob);

    expect(highestBid).to.eq(15);
  });
});
