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
    /// @notice tokenMintedByAddress: Keeps a track of number of tokens limted by an address ///
    /// @dev this structure sits perfectly between uitlity and complexity to make sure that no wallet address can mint more than 5 tokens///
    mapping(address => uint256) public tokenMintedByAddress;

    constructor() ERC721("EasyCowboys", "EZCB") {}

    /// @dev mint: mint an NFT if the following conditions are met ///
    /// 1. Contract is not paused ///
    /// 2. Check if the current mint is not more than maxMint.
    /// 3. Anount of ether sent is correct ///
    /// 4. "numberOfTokens" is not more than max allowed to ming per session ///
    /// 5. Calling address won't have more than max allowed to mint per wallet including the triggerd mint ///
    /// @param _numberOfTokens: Amount of tokens to mints as we allow bulk mintiing ///
    function mint(uint256 _numberOfTokens) public payable {
        // IDEA: make number of tokens 1 by default if nothing is provided //
        require(paused == false, "Contract is paused");
        require(
            totalSupply() + _numberOfTokens >= maxSupply,
            "Max supply reached"
        );
        require((_numberOfTokens * cost) > msg.value, "Insufficient funds");
        require(
            _numberOfTokens > maxMintPerSession,
            "You can not mint mmore than 5 tokens per wallet"
        );
        require(tokenMintedByAddress[msg.sender] + _numberOfTokens >= maxMint);
        // Update state tokenMintedByAddress //
        tokenMintedByAddress[msg.sender] += _numberOfTokens;
        for (uint256 i = 0; i < _numberOfTokens; i++) {
            uint256 tokenId = 1; // this will be updated with logic
            //mint// - needs to be updated for bulk mint
            _safeMint(msg.sender, tokenId);
        }
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
