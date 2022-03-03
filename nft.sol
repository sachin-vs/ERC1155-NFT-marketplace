// SPDX-License-Identifier: GPL-3.0

//1. Minting fungible and non fungible token
//2. Seller - listing his NFT
//3. Buying NFT from seller and reselling it.

pragma solidity ^0.8.3;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract GameTokens is ERC1155 {
    using Counters for Counters.Counter;
    Counters.Counter public itemIds;
    address owner;
    uint256 public constant Shield = 1;
    uint256 public constant Armour = 2;

    constructor() ERC1155("") {}

    function minting() public {
        //Minting NFT by seller
        require(msg.sender != owner);
        _mint(msg.sender, Shield, 1, "");
        _mint(msg.sender, Armour, 1, "");
    }

    struct gameItem {
        uint256 itemId;
        address nftContract;
        address seller;
        uint256 nftId;
        bool sold;
    }
    mapping(uint256 => gameItem) public id_Item;

    function thisId() public view returns (address) {
        return address(this);
    }

    //Returns number of items listed
    function getItemCount() public view returns (uint256) {
        return itemIds.current();
    }

    //Function to list items on markerplace
    function marketItem(uint256 nftId, address seller) public {
        require(balanceOf(seller, nftId) == 1);
        itemIds.increment();
        uint256 itemId = itemIds.current();

        id_Item[itemId] = gameItem(
            itemId,
            address(this),
            msg.sender,
            nftId,
            false
        );
    }

    function check_balance(address _address, uint256 _id)
        public
        view
        returns (uint256)
    {
        return balanceOf(_address, _id);
    }

    //Approve the operator or remove approval from operator
    function approveOperator(address operator, bool approved) public {
        setApprovalForAll(operator, approved);
    }

    //sell NFT, msg.sender should be operator
    function sellItem(
        address from,
        address to,
        uint256 id
    ) public {
        safeTransferFrom(from, to, id, 1, "0x0");
    }
}
