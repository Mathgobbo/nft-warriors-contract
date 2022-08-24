import { ethers } from "hardhat";

async function main() {
  const [owner, user1] = await ethers.getSigners();
  const RpgWarriors = await ethers.getContractFactory("RpgWarriors");
  const rpgWarriors = await RpgWarriors.deploy();

  await rpgWarriors.deployed();
  console.log(`RPG WARRIORS deployed at ${rpgWarriors.address}`);

  const warrior1 = await rpgWarriors.createWarrior(
    "Legolas",
    "The best archer",
    "https://ipfs.io/ipfs/QmdkKAztZjFNPevFZQQNiG8eTW1gqecHmD92zeMXkT8vdK",
    2
  );
  console.log("GAS USED FOR CREATE WARRIOR:", (await warrior1.wait()).gasUsed);
  console.log("OWNER BALANCE");
  const ownerBalance = await rpgWarriors.balanceOf(owner.address);

  console.log("OWNER NFT's ID's");
  let index = 0;
  while (index < ownerBalance.toNumber()) {
    let tokenId = await rpgWarriors.tokenOfOwnerByIndex(owner.address, index);

    console.log(`Metadata for the token #${tokenId.toNumber()}: ${await rpgWarriors.tokenURI(tokenId)}`);
    console.log(`Warrior #${tokenId.toNumber()}:`);
    console.log(await rpgWarriors.getWarrior(tokenId));
    console.log("ADDING 2500 exp to legolas");
    await rpgWarriors.addExperienceToWarrior(tokenId, 2500);
    console.log(await rpgWarriors.tokenURI(tokenId));
    console.log(await rpgWarriors.getWarrior(tokenId));
    console.log("ADDING 3000 exp to legolas");
    console.log(await (await (await rpgWarriors.addExperienceToWarrior(tokenId, 3000)).wait()).gasUsed);
    console.log(await rpgWarriors.tokenURI(tokenId));
    console.log(await rpgWarriors.getWarrior(tokenId));

    index++;
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
