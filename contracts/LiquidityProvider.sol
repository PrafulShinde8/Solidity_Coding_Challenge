// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";

contract LiquidityProvider {
    INonfungiblePositionManager public positionManager;
    IERC20 public dai;
    IERC20 public arb;
    uint256 public tokenId;

    constructor(
        address _positionManager,
        address _dai,
        address _arb
    ) {
        positionManager = INonfungiblePositionManager(_positionManager);
        dai = IERC20(_dai);
        arb = IERC20(_arb);
    }

    function provideLiquidity(uint256 amountDai, uint256 amountArb) external {
        dai.transferFrom(msg.sender, address(this), amountDai);
        arb.transferFrom(msg.sender, address(this), amountArb);

        dai.approve(address(positionManager), amountDai);
        arb.approve(address(positionManager), amountArb);

        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: address(dai),
            token1: address(arb),
            fee: 3000,
            tickLower: -887272,
            tickUpper: 887272,
            amount0Desired: amountDai,
            amount1Desired: amountArb,
            amount0Min: 0,
            amount1Min: 0,
            recipient: address(this),
            deadline: block.timestamp
        });

        (tokenId, , , ) = positionManager.mint(params);
    }

    function getFees() external view returns (uint256 amount0, uint256 amount1) {
        bytes memory data = abi.encodeWithSelector(
            INonfungiblePositionManager.collect.selector,
            INonfungiblePositionManager.CollectParams({
                tokenId: tokenId,
                recipient: address(this),
                amount0Max: type(uint128).max,
                amount1Max: type(uint128).max
            })
        );

        (bool success, bytes memory result) = address(positionManager).staticcall(data);
        require(success, "staticcall failed");

        (amount0, amount1) = abi.decode(result, (uint256, uint256));
    }
}
