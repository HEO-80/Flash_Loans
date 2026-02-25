# ⚡ Flash Loan Agent - Receptor de Aave V3 (Solidity)

Este repositorio contiene un Smart Contract desarrollado en Solidity diseñado para solicitar, recibir y gestionar préstamos relámpago (Flash Loans) interactuando directamente con el protocolo Aave V3.

## 🛠️ Especificaciones Técnicas

El contrato inteligente (`FlashLoanBot.sol`) opera en la versión `^0.8.10` de Solidity y utiliza el framework Foundry.

La arquitectura del contrato implementa las siguientes características:
1.  **Herencia de Protocolo:** Hereda de `FlashLoanSimpleReceiverBase`, el contrato base oficial de Aave V3. Esto le otorga la capacidad nativa de recibir préstamos delegados a través de la función `executeOperation`.
2.  **Integración de Interfaces:** Define la interfaz `ISwapRouter` para permitir la comunicación cruzada con protocolos de intercambio (específicamente Uniswap V3, utilizando `exactInputSingle`).
3.  **Dependencias Externas:** Importa librerías estándar de `aave-v3-core` para la gestión de direcciones del pool y `openzeppelin` para el manejo seguro de tokens estándar ERC20.
4.  **Configuración de Red (Hardcoded):** Contiene variables constantes con las direcciones reales de la red principal de Ethereum (Mainnet) para el enrutador de Uniswap, WETH y DAI.
5.  **Inicialización:** El constructor requiere la dirección del `PoolAddressesProvider` de Aave en el momento del despliegue para vincularse correctamente al pool de liquidez principal.

---

## 🏦 Arquitectura Conceptual (Cómo entenderlo)

Para comprender el papel de este contrato inteligente dentro de la blockchain, utilizaremos la analogía de un agente financiero exprés:

* **El Agente (Este Contrato en Solidity):** Su única misión es ir al banco central (Aave), pedir una suma millonaria de dinero prestado sin dejar ningún tipo de aval, cruzar la calle hacia la casa de cambio (Uniswap) para ejecutar una operación mercantil, volver al banco, devolver exactamente lo que pidió más una comisión mínima, y guardar la ganancia. 
* **La Regla de Oro (Flash Loan):** La magia técnica reside en que el Agente tiene que hacer absolutamente todo esto antes de que el reloj del banco avance un solo segundo (dentro de un único bloque de transacciones). Si al terminar la operación no tiene el dinero suficiente para devolverle al banco, el banco viaja en el tiempo y hace como si el Agente nunca hubiera pedido el dinero (revirtiendo la transacción completa).

## 🚀 Despliegue y Pruebas (Fork Environment)

Dado que este contrato interactúa con las direcciones reales de Aave V3 y Uniswap V3 en la red principal de Ethereum, las pruebas y el desarrollo deben realizarse en un entorno bifurcado (*fork*).

1.  Asegúrate de tener configurado Foundry en tu entorno.
2.  Para simular o probar este contrato, necesitas levantar un nodo local bifurcando la Mainnet utilizando tu URL de Alchemy:
    ```bash
    anvil --fork-url [https://eth-mainnet.g.alchemy.com/v2/TU_API_KEY](https://eth-mainnet.g.alchemy.com/v2/TU_API_KEY)
    ```
3.  Despliega el contrato en tu red local pasando la dirección del `PoolAddressesProvider` de Aave V3 en Ethereum.

---
---

# ⚡ Flash Loan Agent - Aave V3 Receiver (Solidity) [EN]

This repository contains a Smart Contract developed in Solidity designed to request, receive, and manage Flash Loans by interacting directly with the Aave V3 protocol.

## 🛠️ Technical Specifications

The smart contract (`FlashLoanBot.sol`) operates on Solidity version `^0.8.10` and utilizes the Foundry framework.

The contract architecture implements the following features:
1.  **Protocol Inheritance:** Inherits from `FlashLoanSimpleReceiverBase`, the official base contract of Aave V3. This grants it the native capability to receive delegated loans via the `executeOperation` function.
2.  **Interface Integration:** Defines the `ISwapRouter` interface to allow cross-communication with exchange protocols (specifically Uniswap V3, using `exactInputSingle`).
3.  **External Dependencies:** Imports standard libraries from `aave-v3-core` for pool address management and `openzeppelin` for the secure handling of standard ERC20 tokens.
4.  **Network Configuration (Hardcoded):** Contains constant variables with the real addresses from the Ethereum Mainnet for the Uniswap router, WETH, and DAI.
5.  **Initialization:** The constructor requires the Aave `PoolAddressesProvider` address at the time of deployment to correctly bind to the main liquidity pool.

---

## 🏦 Conceptual Architecture (How to understand it)

To understand the role of this smart contract within the blockchain, we will use the analogy of an express financial agent:

* **The Agent (This Solidity Contract):** Its sole mission is to go to the central bank (Aave), borrow a millionaire sum of money without leaving any collateral, cross the street to the exchange office (Uniswap) to execute a trading operation, return to the bank, repay exactly what it borrowed plus a minimal fee, and keep the profit.
* **The Golden Rule (Flash Loan):** The technical magic lies in the fact that the Agent has to do absolutely all of this before the bank's clock advances a single second (within a single transaction block). If at the end of the operation it does not have enough money to repay the bank, the bank travels back in time and acts as if the Agent never asked for the money (reverting the entire transaction).

## 🚀 Deployment & Testing (Fork Environment)

Since this contract interacts with the real Aave V3 and Uniswap V3 addresses on the Ethereum Mainnet, testing and development must be done in a forked environment.

1.  Ensure you have Foundry configured in your environment.
2.  To simulate or test this contract, you need to spin up a local node forking the Mainnet using your Alchemy URL:
    ```bash
    anvil --fork-url [https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY](https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY)
    ```
3.  Deploy the contract on your local network by passing the Aave V3 `PoolAddressesProvider` address on Ethereum.