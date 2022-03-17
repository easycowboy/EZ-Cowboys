// SPDX-License-Identifier: GPL-3.0//
pragma solidity 0.8.4;

/// @title Easycowboys ///
/// @author Pradhumna Pancholi ///

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract EasyCowboys is Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /// @notice cost: Amount to play for minting a nft//
    uint256 public constant COST = 0.069 ether;
    /// @notice maxSupply: Total number of minitable NFTs ///
    uint256 public constant MAX_SUPPLY = 10000;
    /// @notice maxMint: Amount of NFTs a single wallet can mint//
    uint256 public constant MAX_MINT = 5;
    /// @notice maxMintPerSession:  Amount of NFT's that can be minted per session as this contract allows bulk minting ///
    uint256 public constant MAX_MINT_PER_SESSION = 5;
    /// @notice paused: State of contract. If paused, no new NFTs can be minted.///
    bool public paused = false;
    // base uri//
    string constant BASE_URI =
        "ipfs://QmS5JQA5skLeHsxxxA5H1oid56JFRiEeJ7V2YsncGjMiNQ";
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
    function mint(uint256 _numberOfTokens) external payable {
        // ToDo: make number of tokens 1 by default if nothing is provided - solution : create a new method without any arguent whihc will do the same thing except take 1 as number of tokens. //
        require(paused == false, "Contract is paused");
        // ToDo : need to implemeant t a "totalSupply" tracker with the counter we reomved Enumerable extension is favour of URIStorage
        require(_tokenIds.current() == MAX_SUPPLY, "Max supply reached");
        require(msg.value >= (_numberOfTokens * COST), "Insufficient funds");
        require(
            MAX_MINT_PER_SESSION > _numberOfTokens,
            "You can not mint mmore than 5 tokens per session"
        );
        require(
            MAX_MINT >= (tokenMintedByAddress[msg.sender] + _numberOfTokens),
            "A wallet can not mint more than 5 tokens"
        );
        // Update state tokenMintedByAddress //
        tokenMintedByAddress[msg.sender] += _numberOfTokens;
        for (uint256 i = 0; i < _numberOfTokens; i++) {
            _tokenIds.increment(); // increment counter state
            uint256 tokenId = _tokenIds.current(); // get current state of counter for token id//
            //prepare tokenURI//
            string memory id = Strings.toString(_tokenIds.current());
            string memory tURI = string(
                abi.encodePacked(BASE_URI, "/", id, ".json")
            );
            //mint token//
            _safeMint(msg.sender, tokenId);
            _setTokenURI(tokenId, tURI);
        }
    }

    function pause() external onlyOwner returns (bool) {
        paused = true;
        return paused;
    }

    function resume() external onlyOwner returns (bool) {
        paused = false;
        return paused;
    }

    function totalSupply() external view returns (uint256) {
        return _tokenIds.current();
    }
}
