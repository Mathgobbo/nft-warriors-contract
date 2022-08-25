



// contracts/RpgWarriors.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

//Warrior Library
// Here we have all related to the Warrior abstraction and its utilities
library WarriorsLibrary {
  enum WarriorRaces { HUMAN, DWARF, ELF, ORC}
  enum WarriorClasses { WARRIOR, KNIGHT, THIEF, ARCHER, SORCERER }

  struct Warrior {
    string name;
    string description;
    string image;
    // Atributtes
    WarriorRaces race;
    WarriorClasses class;
    uint256 level;
    uint256 totalExperience;
    uint256 strength;
    uint256 dexteriety;
    uint256 intelligence;
    uint256 faith;
    uint256 healthPoints;
    uint256 mana;
  }

  function _getInitialWarrior(string memory name, string memory description, string memory image, WarriorRaces race, WarriorClasses class) internal pure returns (Warrior memory){
    if(class == WarriorClasses.KNIGHT){
      return Warrior(name,description, image, race, class, 0,0,15,10,9,11,1200,700);
    }
    if(class == WarriorClasses.WARRIOR){
      return Warrior(name,description, image, race, class, 0,0,18,9,6,8,1300,600);
    }
    if(class == WarriorClasses.THIEF){
      return Warrior(name,description, image, race, class, 0,0,13,11,10,6,1000,800);
    }
    if(class == WarriorClasses.SORCERER){
      return Warrior(name,description, image, race, class, 0,0,5,8,14,13,700,1300);
    }
    if(class == WarriorClasses.ARCHER){
      return Warrior(name,description, image, race, class, 0,0,11,13,12,10,900,800);
    }
    
    return Warrior(name,description, image, race, class, 0,0,0,0,0,0,0,0);
  }

  function _raceToString(WarriorRaces race) internal pure returns (string memory) {
    if(race == WarriorRaces.HUMAN) return "HUMAN";
    if(race == WarriorRaces.DWARF) return "DWARF";
    if(race == WarriorRaces.ELF) return "ELF";
    if(race == WarriorRaces.ORC) return "ORC";
    return "";
  }
  
  function _classToString(WarriorClasses wClass) internal pure returns (string memory) {
    if(wClass == WarriorClasses.KNIGHT) return "KNIGHT";
    if(wClass == WarriorClasses.WARRIOR) return "WARRIOR";
    if(wClass == WarriorClasses.SORCERER) return "SORCERER";
    if(wClass == WarriorClasses.ARCHER) return "ARCHER";
    if(wClass == WarriorClasses.THIEF) return "THIEF";
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
      '","attributes": ', _buildAttributes(warrior),
      ' }');  
    return string(abi.encodePacked( "data:application/json;base64,", Base64.encode(dataUri))); 
  }

  function _buildAttributes(Warrior memory warrior) internal pure returns (string memory) {
     return string(abi.encodePacked(
      '[',
      '{"trait_type":"Race", "value":"', _raceToString(warrior.race),'"}',
      ',{"trait_type":"Class", "value":"', _classToString(warrior.class),'"}',
      ',{"trait_type":"Level", "value":', Strings.toString(warrior.level),'}',
      ',{"trait_type":"Total Experience", "value":', Strings.toString(warrior.totalExperience),'}',
      ',{"trait_type":"Health Points", "value":', Strings.toString(warrior.healthPoints),'}',
      ',{"trait_type":"Mana", "value":', Strings.toString(warrior.mana),'}',
      ',{"trait_type":"Strength", "value":', Strings.toString(warrior.strength),'}',
      ',{"trait_type":"Dexteriety", "value":', Strings.toString(warrior.dexteriety),'}',
      ',{"trait_type":"Intelligence", "value":', Strings.toString(warrior.intelligence),'}',
      ',{"trait_type":"Faith", "value":', Strings.toString(warrior.faith),'}',
      ']'));
  }
}
