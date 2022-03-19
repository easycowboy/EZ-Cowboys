// mint//
// mint more than maxMint = 5//
// pause state //
// mint while paused - with general user//
// mint while paused - with owner address//
// try to mint after max supply is minted//
// total supply  - check state as it's only way to check crucial max supply verification//
// transfer ownership //
// tokenMintedByAddress state//
import { ethers } from "hardhat";
import { Contract } from "ethers";
const { expect } = require("chai");

describe("Easy Cowboys Contract", function () {
  let owner: any;
  let contract: Contract;
  let addr1: any;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    const EasyCowboys = await ethers.getContractFactory("EasyCowboys");
    contract = await EasyCowboys.deploy();
  });
  // Deployment//
  describe("Deployment", function () {
    it("Deploy should assign the role of 'owner' to the deployer", async function () {
      expect(await contract.owner()).to.equal(owner.address);
    });
    it("Total supply is 0 at deployment", async function () {
      const totalSupply = await contract.totalSupply();
      expect(totalSupply).to.equal(0);
    });
    it("Max supply is 10,000 (10k)", async function () {
      const maxSupply = await contract.MAX_SUPPLY();
      expect(maxSupply).to.equal(10000);
    });
    it("Minting cost is set to 0.069 ether", async function () {
      const cost = await contract.COST();
      expect(Number(ethers.utils.formatEther(cost))).to.equal(0.069);
    });
  });
  // Pause   //
  describe("Pause", function () {
    it("User can not pause the contract", async function () {
      await expect(contract.connect(addr1).pause()).to.be.revertedWith(
        "Ownable: caller is not the owner"
      );
      expect(await contract.paused()).to.equal(false);
    });
    it("Owner can pause the contract", async function () {
      await contract.connect(owner).pause();
      expect(await contract.paused()).to.equal(true);
    });
    it("User can not mint when contract is paused", async function () {
      await contract.connect(owner).pause();
      await contract.connect(addr1);
      await expect(
        contract["mint()"]({
          value: ethers.utils.parseEther("0.069"),
        })
      ).to.be.revertedWith("Contract is paused");
      expect(await contract.paused()).to.equal(true);
    });
    it("Owner can not mint when the contract is paused", async function () {
      await contract.connect(owner).pause();
      await expect(contract["mint(uint256)"](1)).to.be.revertedWith(
        "Contract is paused"
      );
      expect(await contract.paused()).to.equal(true);
    });
    it("User can not resume the contract", async function () {
      await contract.connect(owner).pause();
      await expect(contract.connect(addr1).resume()).to.be.revertedWith(
        "Ownable: caller is not the owner"
      );
      expect(await contract.paused()).to.equal(true);
    });
    it("Owner can resume the contract", async function () {
      await contract.resume();
      expect(await contract.paused()).to.equal(false);
    });
  });
  // Mint//
  describe("Minting", function () {
    it("Mints 1 when no argument is passed", async function () {
      await contract.connect(addr1);
      await expect(
        contract["mint()"]({
          value: ethers.utils.parseEther("0.069"),
        })
      ).to.emit(contract, "Transfer");

      expect(await contract.totalSupply()).to.equal(1);
    });
  });
  it("User can not mint more than 5 token per session", async function () {
    await contract.connect(addr1);
    await expect(
      contract["mint(uint256)"](6, {
        value: ethers.utils.parseEther((0.069 * 6).toString()),
      })
    ).to.be.revertedWith("You can not mint more than 5 tokens per session");
  });
  it("User can not mint more than 5 tokens per wallet", async function () {
    await contract.connect(addr1);
    // mint 1 token first//
    await expect(
      contract["mint()"]({ value: ethers.utils.parseEther("0.069") })
    ).to.emit(contract, "Transfer");
    // now, we try to mint 5 more//
    await expect(
      contract["mint(uint256)"](5, {
        value: ethers.utils.parseEther((0.069 * 6).toString()),
      })
    ).to.be.revertedWith("A wallet can not mint more than 5 tokens");
  });
  // can't mint more than 5 per session//
  // insufficient funds//
  // a wallet can not mint more than 5//
  // balanceOf is updated//
  // totalSupply is updated//
  // tokenId is updated// - maybe
  // -------------------------------//
  // owner can mint 100 per session //
  // owner doesn't have to pay//
});
