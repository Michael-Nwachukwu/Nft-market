// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Openmarket is ERC721URIStorage, Ownable {

    error PriceMustBeGreaterThanZero();
    error NotOwnerOfNFT();
    error MarketplaceNotApproved();
    error NFTNotForSale();
    error InsufficientPayment();
    error NotSellerOfNFT();

    uint256 private tokenIds;
    uint256 txId;
    
    struct Listing {
        uint256 price;
        address seller;
    }

    struct TxHistory {
        uint256 tokenId;
        uint256 amount;
        address seller;
        address buyer;
    }
    
    mapping(uint256 => Listing) private listings;
    mapping (uint256 => TxHistory) txHistory;
    
    event SuccessfulListing(uint256 indexed tokenId, uint256 price, address indexed seller);
    event NFTSold(uint256 indexed tokenId, uint256 price, address indexed seller, address indexed buyer);
    event ListingCancelled(uint256 indexed tokenId, address indexed seller);

    constructor() ERC721("OpenMarket", "OPM") Ownable(msg.sender) {}
    
    /*
     * @notice Mints a new NFT
     * @dev Creates a new token and assigns it to the caller
     * @param tokenURI The metadata URI for the new token
     * @return The ID of the newly minted NFT
    */
    function mintNft(string memory _tokenURI) public returns (uint256) {
        tokenIds++;
        uint256 newTokenId = tokenIds;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        return newTokenId;
    }
    
    /*
     * @notice Lists an NFT for sale
     * @dev Allows a token owner to list their NFT in the marketplace
     * @param tokenId The ID of the token to be listed
     * @param price The price at which the NFT is being listed
     */
    function listNft(uint256 tokenId, uint256 price) public {
        if (price == 0) revert PriceMustBeGreaterThanZero();
        if (ownerOf(tokenId) != msg.sender) revert NotOwnerOfNFT();
        if (getApproved(tokenId) != address(this)) revert MarketplaceNotApproved();
        
        listings[tokenId] = Listing(price, msg.sender);
        emit SuccessfulListing(tokenId, price, msg.sender);
    }

    /*
     * @notice Allows the seller to cancel their NFT listing
     * @dev Removes the NFT from the listings
     * @param tokenId The ID of the token to be delisted
     */
    function cancelListing(uint256 tokenId) public {
        if (listings[tokenId].seller != msg.sender) revert NotSellerOfNFT();
        delete listings[tokenId];
        emit ListingCancelled(tokenId, msg.sender);
    }
    
    /*
     * @notice Allows a user to purchase a listed NFT
     * @dev Transfers the NFT to the buyer and the payment to the seller
     * @param tokenId The ID of the token being purchased
     */
    function buyNft(uint256 tokenId) public payable {
        Listing memory listing = listings[tokenId];
        if (listing.price == 0) revert NFTNotForSale();
        if (msg.value < listing.price) revert InsufficientPayment();
        
        address seller = listing.seller;
        
        delete listings[tokenId];
        _transfer(seller, msg.sender, tokenId);
        payable(seller).transfer(msg.value);

        uint256 _txId = txId++;
        TxHistory memory history = txHistory[_txId];

        history.tokenId = tokenId;
        history.amount = msg.value;
        history.seller = seller;
        history.buyer = msg.sender;

        txId++;
        
        emit NFTSold(tokenId, listing.price, seller, msg.sender);
    }
    
    /*
     * @notice Retrieves the listing information for a given NFT
     * @dev Returns the price and seller of a listed NFT
     * @param tokenId The ID of the token to query
     * @return The Listing struct containing price and seller information
     */
    function getListing(uint256 tokenId) public view returns (Listing memory) {
        return listings[tokenId];
    }
}