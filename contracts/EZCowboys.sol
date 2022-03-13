// SPDX-License-Identifier: GPL-3.0//
pragma solidity 0.8.4;

/// @title Easycowboys ///
/// @author Pradhumna Pancholi ///

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EasyCowboys is Ownable, ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /// @notice cost: Amount to play for minting a nft//
    uint256 public cost = 0.069 ether;
    /// @notice maxSupply: Total number of minitable NFTs ///
    uint256 public maxSupply = 10000;
    /// @notice maxMint: Amount of NFTs a single wallet can mint//
    uint256 public maxMint = 5;
    /// @notice maxMintPerSession:  Amount of NFT's that can be minted per session as this contract allows bulk minting ///
    uint256 public maxMintPerSession = 5;
    /// @notice paused: State of contract. If paused, no new NFTs can be minted.///
    bool public paused = false;

    // base uri//
    // mapping for address to token id //

    constructor() ERC721("EasyCowboys", "EZCB") {}

    /// @dev mint: mint an NFT if the following conditions are met ///
    /// 1. Contract is not paused ///
    /// 2. "numberOfTokens" is not more than max allowed to ming per session ///
    /// 3. Calling address won't have more than max allowed to mint per wallet including the triggerd mint ///
    /// 4. Anount ether sent is correct ///
    /// @param numberOfTokens: Amount of tokens to mints as we allow bulk mintiing ///
    function mint(uint256 numberOfTokens) public payable {
        require(paused == false, "Contract is paused");
        require(msg.value >= (numberOfTokens * cost), "Insufficient funds");
    }

    function pause() public onlyOwner returns (bool) {
        paused = true;
        return paused;
    }

    function resume() public onlyOwner returns (bool) {
        paused = false;
        return paused;
    }
}
