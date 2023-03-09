// contracts/DSRVNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./base64.sol";
import "hardhat/console.sol";

contract DSRVNFT is ERC721 {
    uint256 private _currentNFTId = 0; // Starts from 1 when incrementing the ID

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {}

    function mintTo(address _to) public {
        uint256 newNFTId = _getNextNFTId();
        _mint(_to, newNFTId);
        console.log("New NFT ID:", newNFTId);
        _incrementCurrentNFTId();
    }
    
    function _getNextNFTId() private view returns (uint256) {
        return _currentNFTId + 1;
    }
    
    function _incrementCurrentNFTId() private {
        _currentNFTId++;
    }

    function tokenURI(uint256 tokenId) override public pure returns (string memory) {
        string[3] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = Strings.toString(tokenId);

        parts[2] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2]));

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Badge #', Strings.toString(tokenId), '", "description": "A concise Hardhat tutorial Badge NFT with on-chain SVG images like look.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
            
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }
}