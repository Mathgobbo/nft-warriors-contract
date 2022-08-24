



// contracts/RpgWarriors.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

//Warrior Library
// Here we have all related to the Warrior abstraction and its utilities
library WarriorsLibrary {
  enum WarriorRaces { HUMAN, DWARF, ELF, ORC}
  
  struct Warrior {
    string name;
    string description;
    string image;
    WarriorRaces race;
    uint256 level;
    uint256 totalExperience;
  }

  function _raceToString(WarriorRaces race) internal pure returns (string memory) {
    if(race == WarriorRaces.HUMAN) return "HUMAN";
    if(race == WarriorRaces.DWARF) return "DWARF";
    if(race == WarriorRaces.ELF) return "ELF";
    if(race == WarriorRaces.ORC) return "ORC";
    return "";
  }
  
  function _warriorToBase64Metadata(Warrior memory warrior) internal pure returns (string memory) {
    bytes memory dataUri = abi.encodePacked(
      '{',
      '"name":"',warrior.name,
      '","description":"',warrior.description, ' | Total exp:', Strings.toString(warrior.totalExperience),
      '","image":"', warrior.image,
      '","race":"',_raceToString(warrior.race),
      '","level":"', Strings.toString(warrior.level),
      '","totalExperience":"', Strings.toString(warrior.totalExperience),
      '","attributes": [',
      '{"trait_type":"race", "value":"', _raceToString(warrior.race),'"}',
      ',{"trait_type":"level", "value":"', Strings.toString(warrior.level),'"}',
      ']'
      ' }');
    return string(abi.encodePacked( "data:application/json;base64,", Base64.encode(dataUri))); 
  }
}
