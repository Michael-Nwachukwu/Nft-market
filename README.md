# NFT Marketplace Smart Contract

This smart contract implements a decentralized NFT marketplace on the Ethereum blockchain. It allows users to mint, list, buy, and manage NFTs (Non-Fungible Tokens) in a secure and transparent manner.

## Features

- Mint new NFTs with custom metadata
- List NFTs for sale at a specified price
- Purchase listed NFTs
- Cancel NFT listings
- View listing information
- Transaction history tracking

## Contract Details

- **Name:** Openmarket
- **Symbol:** OPM
- **Solidity Version:** ^0.8.24
- **License:** MIT

## Dependencies

This contract uses OpenZeppelin libraries:
- `@openzeppelin/contracts/token/ERC721/ERC721.sol`
- `@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol`
- `@openzeppelin/contracts/access/Ownable.sol`

## Main Functions

### `mintNft(string memory _tokenURI) public returns (uint256)`
Mints a new NFT and assigns it to the caller.

### `listNft(uint256 tokenId, uint256 price) public`
Lists an NFT for sale at the specified price.

### `cancelListing(uint256 tokenId) public`
Allows the seller to cancel their NFT listing.

### `buyNft(uint256 tokenId) public payable`
Allows a user to purchase a listed NFT.

### `getListing(uint256 tokenId) public view returns (Listing memory)`
Retrieves the listing information for a given NFT.

## Events

- `SuccessfulListing(uint256 indexed tokenId, uint256 price, address indexed seller)`
- `NFTSold(uint256 indexed tokenId, uint256 price, address indexed seller, address indexed buyer)`
- `ListingCancelled(uint256 indexed tokenId, address indexed seller)`

## Error Handling

The contract uses custom error messages for various scenarios:
- `PriceMustBeGreaterThanZero()`
- `NotOwnerOfNFT()`
- `MarketplaceNotApproved()`
- `NFTNotForSale()`
- `InsufficientPayment()`
- `NotSellerOfNFT()`

## Security Considerations

- The contract inherits from OpenZeppelin's `Ownable` for access control.
- Proper checks are implemented to ensure only authorized actions are performed.
- The contract uses the latest Solidity version (0.8.24) to benefit from built-in overflow protection.

## Deployment

To deploy this contract, you'll need:
1. A development environment set up for Ethereum smart contract deployment (e.g., Hardhat, Truffle)
2. The OpenZeppelin library installed
3. An Ethereum wallet with sufficient ETH for gas fees

## Testing

It's recommended to thoroughly test this contract on a testnet before deploying to the mainnet. Write comprehensive unit tests to cover all functions and edge cases.
