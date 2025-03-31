const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("ArbitrageContract", function () {
  // Fixture: Deploys the ArbitrageContract and returns the deployed instance.
  async function deployArbitrageContractFixture() {
    const ArbitrageContract = await ethers.getContractFactory("ArbitrageContract");
    const arbitrageContract = await ArbitrageContract.deploy();
    return { arbitrageContract };
  }

  describe("Deployment", function () {
    it("Should set the correct message on deployment", async function () {
      const { arbitrageContract } = await loadFixture(deployArbitrageContractFixture);
      expect(await arbitrageContract.message()).to.equal("Hello, World!");
    });
  });

  describe("Hello World return value", function () {
    it("Should return 'Hello, World!' from hello()", async function () {
      const { arbitrageContract } = await loadFixture(deployArbitrageContractFixture);
      expect(await arbitrageContract.hello()).to.equal("Hello, World!");
    });
  });
});