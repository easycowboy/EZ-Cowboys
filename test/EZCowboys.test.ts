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
const { expect } = require("chai");

describe("Easy Cowboys Contract", function () {
  let owner: any;
  let contract: any;
  let addr1: any;

  before(async function () {
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
  // Pause - ORDER MATTERS //
  // Reason: we are running test with 'before' and not "beforeEach". This allows to perform test sequentially which helps with composability//
  // With that solution, order matters to avoid cleaning up every action after test//
  describe("Pause", function () {
    it("User can not pause the contract", async function () {
      await expect(contract.connect(addr1).pause()).to.be.revertedWith(
        "Ownable: caller is not the owner"
      );
      expect(await contract.paused()).to.equal(false);
    });
    it("Owner can pause the contract", async function () {
      await contract.pause();
      expect(await contract.paused()).to.equal(true);
    });
    it("User can not mint when contract is paused", async function () {
      await contract.connect(addr1);
      await expect(contract["mint(uint256)"](1)).to.be.revertedWith(
        "Contract is paused"
      );
    });
    it("Owner can not mint when the contract is paused", async function () {
      await contract.connect(owner);
      await expect(contract["mint(uint256)"](1)).to.be.revertedWith(
        "Contract is paused"
      );
    });
    it("User can not resume the contract", async function () {
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
  // //   owner can unpause//
  // it("Owner can unpause the contract", async function () {
  //   await contract.resume();
  //   expect(await contract.paused()).to.equal(false);
  // });
  // it("General user can not pause the contract", async function () {
  //   // await contract.connect(addr1);
  //   // await expectRevert(contract.pause());
  //   await expect(contract.connect(addr1).pause()).to.be.revertedWith(
  //     "Ownable: caller is not the owner"
  //   );
  //   await expect(await contract.paused()).to.equal(false);
  // });
  // it("Can't be minted while paused - general user", async function () {
  //   await contract.connect(owner).pause();
  //   await expect(await contract.paused()).to.equal(true);
  //   await expect(contract.connect(addr1).mint(1)).to.be.revertedWith(
  //     "Contract is paused"
  //   );
  // });
  // it("Can't be minted while paused - owner", async function () {
  //   await contract.connect(owner).pause();
  //   await expect(await contract.paused()).to.equal(true);
  //   await expect(contract.connect(owner).mint(1)).to.be.revertedWith(
  //     "Contract is paused"
  //   );
  // });
  // it("totalSupply returns amount of minted tokens", async function () {
  //   await contract.connect(owner).resume(); // un-pause from previous test's effect//
  //   await contract.connect(addr1).mint(5);
  //   await expect(contract.totalSupply()).to.be.equal(5);
  // });
});
