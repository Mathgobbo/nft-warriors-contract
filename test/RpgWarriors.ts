import { ethers } from "hardhat";
import { expect } from "chai";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { RpgWarriors } from "../typechain-types";

describe("RPG Warriors Test", () => {
  let owner: SignerWithAddress, otherAccount: SignerWithAddress, rpgWarriors: RpgWarriors;

  beforeEach(async () => {
    [owner, otherAccount] = await ethers.getSigners();
    const contract = await ethers.getContractFactory("RpgWarriors");
    rpgWarriors = await contract.deploy();
    await rpgWarriors.deployed();
    return { rpgWarriors, owner, otherAccount };
  });

  describe("Deployment", () => {
    it("Should deploy the contract", async () => {
      expect(rpgWarriors.address).not.be.null;
    });
  });

  describe("Warriors", () => {
    it("Should mint an Warrior to Owner", async () => {
      const tx = await rpgWarriors.createWarrior(
        "Legolas",
        "The best Elf Archer",
        "https://ipfs.io/ipfs/QmdkKAztZjFNPevFZQQNiG8eTW1gqecHmD92zeMXkT8vdK",
        2
      );
      await tx.wait();
      expect(await rpgWarriors.ownerOf(1)).to.equal(owner.address);
    });

    it("Should get owner Warrior and add 3000 exp", async () => {
      const tx = await rpgWarriors.createWarrior(
        "Legolas",
        "The best Elf Archer",
        "https://ipfs.io/ipfs/QmdkKAztZjFNPevFZQQNiG8eTW1gqecHmD92zeMXkT8vdK",
        2
      );
      await tx.wait();
      await rpgWarriors.addExperienceToWarrior(1, 3000);
      const warrior = await rpgWarriors.getWarrior(1);

      expect(warrior.name).not.be.equals("") &&
        expect(warrior.description).not.be.equals("") &&
        expect(warrior.image).not.be.equals("") &&
        expect(warrior.level.toNumber()).be.equals(3) &&
        expect(warrior.totalExperience.toNumber()).be.equals(3000);
    });
  });
});
