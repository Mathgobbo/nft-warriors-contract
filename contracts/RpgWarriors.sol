


// contracts/RpgWarriors.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import { WarriorsLibrary } from "./libraries/WarriorsLibrary.sol";

contract RpgWarriors is ERC721Enumerable,ERC721URIStorage  {

  // Variables
  using Counters for Counters.Counter;
  Counters.Counter private _warriorIds;

  mapping (uint256 => WarriorsLibrary.Warrior) warriors;

  // EVENTS
  event NewWarriorMinted (address sender, uint tokenId);
  event WarriorAddedExperience (address sender, uint tokenId);

  constructor() ERC721 ("RpgWarriorsTest", "RPGWT") {}

  function createWarrior(string memory name, string memory description, string memory image, WarriorsLibrary.WarriorRaces race, WarriorsLibrary.WarriorClasses wClass) public {
      _warriorIds.increment();
      uint256 newWarriorId = _warriorIds.current(); 
      
      WarriorsLibrary.Warrior memory warrior = WarriorsLibrary._getInitialWarrior(name, description, image, race, wClass);
      string memory metadata =  WarriorsLibrary._warriorToBase64Metadata(warrior);
    
      _safeMint(msg.sender, newWarriorId);
      _setTokenURI(newWarriorId, metadata);
        warriors[newWarriorId] = warrior;
      
      emit NewWarriorMinted(msg.sender, newWarriorId);
  }

  function getWarrior(uint256 tokenId) public view returns (WarriorsLibrary.Warrior memory) {
    return warriors[tokenId];
  }

  function addExperienceToWarrior(uint256 tokenId, uint256 experienceToAdd) public {
    require(_exists(tokenId), "This token doesnt exists");
    require(ownerOf(tokenId) == msg.sender, "You must be the owner to add experience");
    
    WarriorsLibrary.Warrior memory warrior = warriors[tokenId];

    warrior.totalExperience = warrior.totalExperience + experienceToAdd;
    warrior.level = warrior.totalExperience / 1000;
    string memory metadata =  WarriorsLibrary._warriorToBase64Metadata(warrior);
    
    _setTokenURI(tokenId, metadata);
    warriors[tokenId] = warrior;

    emit WarriorAddedExperience(msg.sender, tokenId);
  }

  //OVERRIDES
  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


} 