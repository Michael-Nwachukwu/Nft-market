import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const OpenMarketModule = buildModule("OpenMarketModule", (m) => {

  const nftMarket = m.contract("Openmarket");

  return { nftMarket };
});

export default OpenMarketModule;
