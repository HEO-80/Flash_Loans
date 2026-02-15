// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "aave-v3-core/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

// Definimos la "ventanilla" de Uniswap para poder hablar con ella
interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

contract FlashLoanBot is FlashLoanSimpleReceiverBase {
    // Direcciones fijas de la Mainnet (La realidad)
    address constant SWAP_ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564; // Uniswap V3
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    ISwapRouter public immutable router;

    constructor(address _addressProvider)
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        // Conectamos con el Router de Uniswap
        router = ISwapRouter(SWAP_ROUTER);
    }

    // --- FUNCIÓN QUE LLAMAS TÚ (Disparador) ---
    function solicitarPrestamo(uint256 cantidad) external {
        // Pedimos DAI prestados
        POOL.flashLoanSimple(address(this), DAI, cantidad, "", 0);
    }

    // --- FUNCIÓN QUE EJECUTA AAVE (La Magia) ---
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        
        // 1. Calcular cuánto debemos devolver al final (Prestamo + 0.09%)
        uint256 totalDeuda = amount + premium;

        // --- ZONA DE TRADING (La Mira Telescópica) ---
        
        // PASO A: Comprar WETH con TODO el DAI prestado
        // Primero aprobamos a Uniswap para que pueda coger nuestros DAI
        IERC20(DAI).approve(address(router), amount);
        
        // Ejecutamos el cambio (DAI -> WETH)
        uint256 wethObtenido = router.exactInputSingle(ISwapRouter.ExactInputSingleParams({
            tokenIn: DAI,
            tokenOut: WETH,
            fee: 3000,              // Comisión del 0.3%
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: amount,
            amountOutMinimum: 0,    // Aceptamos cualquier cantidad (SOLO PARA PRUEBAS)
            sqrtPriceLimitX96: 0
        }));

        // PASO B: Vender los WETH de vuelta a DAI
        // (En el mundo real, aquí venderíamos en OTRO sitio más caro, como SushiSwap)
        // Pero para probar que funciona, vendemos en el mismo sitio.
        
        IERC20(WETH).approve(address(router), wethObtenido);

        uint256 daiFinal = router.exactInputSingle(ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH,
            tokenOut: DAI,
            fee: 3000,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: wethObtenido,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        }));

        // --- FIN DE LA ZONA DE TRADING ---

        // 2. Comprobar si ganamos dinero (Opcional por ahora)
        if (daiFinal < totalDeuda) {
            // Si perdemos dinero, la operación fallaría en la vida real.
            // Pero como inyectaremos dinero falso en el test, dejamos que pase.
        }

        // 3. Autorizar a Aave a cobrar su deuda
        IERC20(asset).approve(address(POOL), totalDeuda);

        return true;
    }
}