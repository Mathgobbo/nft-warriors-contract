import { ethers } from "hardhat";
import { expect } from "chai";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { RpgWarriors } from "../typechain-types";

describe("RPG Warriors Test", () => {
  let owner: SignerWithAddress, otherAccount: SignerWithAddress, rpgWarriors: RpgWarriors;

  const mintLegolas = async () => {
    const tx = await rpgWarriors.createWarrior(
      "Legolas",
      "The best Elf Archer",
      "https://ipfs.io/ipfs/QmdkKAztZjFNPevFZQQNiG8eTW1gqecHmD92zeMXkT8vdK",
      2
    );
    await tx.wait();
  };

  beforeEach(async () => {
    [owner, otherAccount] = await ethers.getSigners();
    const contract = await ethers.getContractFactory("RpgWarriors");
    rpgWarriors = await contract.deploy();
    await rpgWarriors.deployed();
    await mintLegolas();
    return { rpgWarriors, owner, otherAccount };
  });

  describe("Deployment", () => {
    it("Should deploy the contract", async () => {
      expect(rpgWarriors.address).not.be.null;
    });
  });

  describe("Warriors", () => {
    it("Should mint an Warrior to Owner", async () => {
      expect(await rpgWarriors.ownerOf(1)).to.equal(owner.address);
    });

    it("Should get owner Warrior and add 3000 exp", async () => {
      await rpgWarriors.addExperienceToWarrior(1, 3000);
      const warrior = await rpgWarriors.getWarrior(1);

      expect(warrior.name).not.be.equals("") &&
        expect(warrior.description).not.be.equals("") &&
        expect(warrior.image).not.be.equals("") &&
        expect(warrior.level.toNumber()).be.equals(3) &&
        expect(warrior.totalExperience.toNumber()).be.equals(3000);
    });

    it("Should not add Exp to other user Warrior", async () => {
      let validationError;
      try {
        await rpgWarriors.connect(otherAccount).addExperienceToWarrior(1, 3000);
      } catch (error) {
        if ((error as Error).message.indexOf("You must be the owner") > -1) validationError = error;
      }
      expect(validationError).not.be.null;
    });
  });
});
