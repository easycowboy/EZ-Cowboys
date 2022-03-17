// mint//
// mint more than maxMint = 5//
// pause state //
// mint while paused - with general user//
// mint while paused - with owner address//
// try to mint after max supply is minted//
// total supply //
// transfer ownership //

import { ethers } from "hardhat";
// const { expectRevert } = require("@openzeppelin/test-helpers");
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
  it("Deploy should assign the role of 'owner' to the deployer", async function () {
    expect(await contract.owner()).to.equal(owner.address);
  });
  it("Owner can pause the contract", async function () {
    await contract.pause();
    expect(await contract.paused()).to.equal(true);
  });
  //   owner can unpause//
  it("Owner can unpause the contract", async function () {
    await contract.resume();
    expect(await contract.paused()).to.equal(false);
  });
  it("General user can not pause the contract", async function () {
    // await contract.connect(addr1);
    // await expectRevert(contract.pause());
    await expect(contract.connect(addr1).pause()).to.be.revertedWith(
      "Ownable: caller is not the owner"
    );
    await expect(await contract.paused()).to.equal(false);
  });
  it("Can't be minted while paused", async function () {
    await contract.connect(owner).pause();
    await expect(await contract.paused()).to.equal(true);
    await expect(contract.connect(addr1).mint(1)).to.be.revertedWith(
      "Contract is paused"
    );
  });
});
