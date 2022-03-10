// SPDX-License-Identifier: GPL-3.0//
pragma solidity 0.8.4;

/// @title Easycowboys ///
/// @author Pradhumna Pancholi ///

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EasyCowboys is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // add cost//
    // add maxSupply//
    //maxmint- amount of NFTs a single wallet can mint//
    // make pausable//
    // base uri//
    //  mapping for address to token id //

    constructor() ERC721("EasyCowboys", "EZCB") {}

    // not paused //
    // owner doesn't have more than max mint allowed includig the triggerd mint //
    // not more than max supply including the triggerd minf//
    // check price //
    function mint(address to, string tokenURI) public returns (uint256) {}

    // return max supply //
    function maxSupply() public view returns uint256 {}
}
