// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import {AppStorage} from "./libraries/LibAppStorage.sol";
import {LibMeta} from "../shared/libraries/LibMeta.sol";
import {LibDiamond} from "../shared/libraries/LibDiamond.sol";
import {IDiamondCut} from "../shared/interfaces/IDiamondCut.sol";
import {IERC165} from "../shared/interfaces/IERC165.sol";
import {IDiamondLoupe} from "../shared/interfaces/IDiamondLoupe.sol";
import {IERC173} from "../shared/interfaces/IERC173.sol";
import {ILink} from "./interfaces/ILink.sol";

contract InitDiamond {
    AppStorage internal s;

    function init(
        address _dao,
        address _daoTreasury,
        address _pixelCraft,
        address _rarityFarming,
        address _ghstContract,
        bytes32 _chainlinkKeyHash,
        uint256 _chainlinkFee,
        address _vrfCoordinator,
        address _linkAddress,
        uint24 _initialHauntSize,
        uint96 _portalPrice,
        address _childChainManager
    ) external {
        s.dao = _dao;
        s.daoTreasury = _daoTreasury;
        s.rarityFarming = _rarityFarming;
        s.pixelCraft = _pixelCraft;
        s.itemsBaseUri = "https://aavegotchi.com/metadata/items/";
        s.childChainManager = _childChainManager;

        s.domainSeparator = LibMeta.domainSeparator("AavegotchiDiamond", "V1");

        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();

        // adding ERC165 data
        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
        ds.supportedInterfaces[type(IERC173).interfaceId] = true;

        s.ghstContract = _ghstContract;
        s.keyHash = _chainlinkKeyHash;
        s.fee = uint144(_chainlinkFee);
        s.vrfCoordinator = _vrfCoordinator;
        s.link = ILink(_linkAddress);

        uint256 currentHauntId = s.currentHauntId;
        s.haunts[currentHauntId].hauntMaxSize = _initialHauntSize; //10_000;
        s.haunts[currentHauntId].portalPrice = _portalPrice;
        s.listingFeeInWei = 1e17;
    }
}
