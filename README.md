<div align="center">

# ⚡ Flash Loan Agent — Aave V3 Receiver (Solidity)

<img src="https://img.shields.io/badge/Solidity-363636?style=for-the-badge&logo=solidity&logoColor=white"/>
<img src="https://img.shields.io/badge/Aave_V3-B6509E?style=for-the-badge&logo=aave&logoColor=white"/>
<img src="https://img.shields.io/badge/Uniswap_V3-FF007A?style=for-the-badge&logo=uniswap&logoColor=white"/>
<img src="https://img.shields.io/badge/Foundry-FFCB47?style=for-the-badge&logo=ethereum&logoColor=black"/>
<img src="https://img.shields.io/badge/Ethereum-3C3C3D?style=for-the-badge&logo=ethereum&logoColor=white"/>

**Smart Contract para solicitar, recibir y gestionar Flash Loans en Aave V3**

*Operación atómica completa: pedir prestado → arbitrar → devolver → beneficio*
*Todo dentro de un único bloque de transacción.*

**🌍 [English](#-english-version) · 🇪🇸 [Español](#-versión-en-español)**

</div>
---

## 🇪🇸 Versión en Español

### 🏦 ¿Qué es un Flash Loan? La Analogía del Agente Financiero

> **El Agente** *(este contrato)* va al banco central *(Aave)*, pide prestada una suma millonaria **sin dejar ningún aval**, cruza la calle hacia la casa de cambio *(Uniswap)* para ejecutar una operación mercantil, vuelve al banco, devuelve exactamente lo que pidió más una comisión mínima **(0.09%)**, y guarda la ganancia.
>
> **La Regla de Oro:** tiene que hacer absolutamente **todo esto antes de que el reloj avance un solo segundo** (dentro de un único bloque). Si no puede devolver el dinero, el banco viaja en el tiempo y actúa como si nunca hubiera ocurrido *(revert)*.

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
<div align="center">
### ⚙️ Arquitectura del Contrato


![Architecture](05_FlashLoanAgent/img/04_architecture.svg)
</div>

```
        TÚ (EOA)
           │
           │  solicitarPrestamo(token, cantidad)
           ▼
    ┌─────────────────┐
    │  FlashLoanBot   │
    │  (este contrato)│
    └────────┬────────┘
             │  POOL.flashLoanSimple()
             ▼
    ┌─────────────────┐
    │    Aave V3      │◀─── ingresa fondos al contrato
    │   (el banco)    │
    └────────┬────────┘
             │  executeOperation() ← llamado automáticamente por Aave
             ▼
    ┌─────────────────┐
    │  TUS OPERACIONES│  ← arbitraje, liquidaciones, etc.
    │  DE ARBITRAJE   │
    └────────┬────────┘
             │  approve(amount + premium)
             ▼
    ┌─────────────────┐
    │    Aave V3      │◀─── se cobra automáticamente
    │  (cobra + fee)  │
    └─────────────────┘
             │
             ▼
        ✅ Beneficio retenido en el contrato
```
---

### 🔬 Especificaciones Técnicas

| Parámetro | Valor |
|:---|:---|
| Lenguaje | Solidity `^0.8.10` |
| Framework | Foundry |
| Protocolo de préstamo | Aave V3 |
| Protocolo de swap | Uniswap V3 |
| Red objetivo | Ethereum Mainnet |
| Comisión Flash Loan | 0.09% del capital |
| Par por defecto | WETH / DAI |

---

## 🔄 Execution Flow

![Execution Flow](05_FlashLoanAgent/img/05_execution_flow.svg)

---

### 🛠️ Dependencias
```
aave-v3-core
├── FlashLoanSimpleReceiverBase.sol   ← clase base del receptor
├── IPoolAddressesProvider.sol        ← dirección del pool de Aave
└── IERC20.sol                        ← manejo seguro de tokens ERC20

Uniswap V3
└── ISwapRouter                       ← interfaz para exactInputSingle
```

---

### 🏗️ Estructura del Repositorio
```
Flash_Loans/
├── 05_FlashLoanAgent/
│   ├── FlashLoanBot.sol        # Contrato principal
│   ├── foundry.toml            # Configuración de Foundry
│   └── test/                   # Tests en entorno fork
└── README.md
```

---

### 🚀 Despliegue y Pruebas (Fork Environment)

Como el contrato usa las direcciones reales de Aave V3 y Uniswap V3 en Mainnet, las pruebas deben hacerse en un **entorno bifurcado local**.

**1. Instalar Foundry**
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

**2. Levantar nodo local bifurcando Ethereum Mainnet**
```bash
anvil --fork-url https://eth-mainnet.g.alchemy.com/v2/TU_API_KEY
```

**3. Desplegar el contrato**
```bash
forge create FlashLoanBot \
  --constructor-args 0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e \
  --rpc-url http://localhost:8545 \
  --private-key TU_PRIVATE_KEY
```

> `0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e` es la dirección del `PoolAddressesProvider` de Aave V3 en Ethereum Mainnet.

**4. Ejecutar un Flash Loan de prueba**
```bash
cast send TU_CONTRATO \
  "solicitarPrestamo(address,uint256)" \
  0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 \
  1000000000000000000 \
  --rpc-url http://localhost:8545 \
  --private-key TU_PRIVATE_KEY
```

---
### 🗺️ Roadmap

- [x] Receptor base de Flash Loan (Aave V3)
- [x] Integración de interfaz Uniswap V3
- [x] Aprobación automática de devolución con fee
- [ ] Lógica de arbitraje real (WETH → DAI → WETH)
- [x] Tests automatizados con Foundry en fork
- [ ] Cálculo de rentabilidad antes de disparar
- [ ] Integración con el radar off-chain `RealPriceBrain`

---

### ⚖️ Disclaimer

Este proyecto es **exclusivamente para fines educativos e investigación DeFi**.

Los autores no son responsables de pérdidas financieras, incumplimientos regulatorios ni daños derivados del uso de este software. Al usarlo confirmas haber leído y aceptado estos términos.

---

### 🧑‍💻 Autor

**Héctor Oviedo** — Backend Developer & DeFi Researcher

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/hectorob/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/HEO-80)

---

## 🇬🇧 English Version

### 🏦 What is a Flash Loan? The Financial Agent Analogy

> **The Agent** *(this contract)* goes to the central bank *(Aave)*, borrows a massive sum **without any collateral**, crosses the street to the exchange office *(Uniswap)* to execute a trade, returns to the bank, repays exactly what it borrowed plus a minimal fee **(0.09%)**, and keeps the profit.
>
> **The Golden Rule:** it has to do **all of this before the clock advances a single second** (within a single block). If it can't repay, the bank travels back in time and acts as if it never happened *(revert)*.

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
3.  Deploy the contract on your local network by passing the Aave V3 `PoolAddressesProvider` address on Ethereum.<div align="center">

---

## ⚙️ Contract Architecture
<div align="center">


![Architecture](05_FlashLoanAgent/img/04_architecture.svg)

</div>

```
        YOU (EOA)
           │
           │  solicitarPrestamo(token, amount)
           ▼
    ┌─────────────────┐
    │  FlashLoanBot   │
    │  (this contract)│
    └────────┬────────┘
             │  POOL.flashLoanSimple()
             ▼
    ┌─────────────────┐
    │    Aave V3      │◀─── funds deposited into contract
    │   (the bank)    │
    └────────┬────────┘
             │  executeOperation() ← auto-called by Aave
             ▼
    ┌─────────────────┐
    │  YOUR ARBITRAGE │  ← swaps, liquidations, etc.
    │   OPERATIONS    │
    └────────┬────────┘
             │  approve(amount + premium)
             ▼
    ┌─────────────────┐
    │    Aave V3      │◀─── auto-collects repayment
    │  (collects fee) │
    └─────────────────┘
             │
             ▼
        ✅ Profit retained in contract
```
## 🔄 Execution Flow

<div align="center">


![Execution Flow](05_FlashLoanAgent/img/05_execution_flow.svg)

</div>

---

### 🔬 Technical Specifications

| Parameter | Value |
|:---|:---|
| Language | Solidity `^0.8.10` |
| Framework | Foundry |
| Lending Protocol | Aave V3 |
| Swap Protocol | Uniswap V3 |
| Target Network | Ethereum Mainnet |
| Flash Loan Fee | 0.09% of capital |
| Default Pair | WETH / DAI |
---

### 🚀 Deployment & Testing (Fork Environment)

**1. Install Foundry**
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

**2. Fork Ethereum Mainnet locally**
```bash
anvil --fork-url https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY
```

**3. Deploy the contract**
```bash
forge create FlashLoanBot \
  --constructor-args 0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e \
  --rpc-url http://localhost:8545 \
  --private-key YOUR_PRIVATE_KEY
```

**4. Trigger a test Flash Loan**
```bash
cast send YOUR_CONTRACT \
  "solicitarPrestamo(address,uint256)" \
  0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 \
  1000000000000000000 \
  --rpc-url http://localhost:8545 \
  --private-key YOUR_PRIVATE_KEY
```

## 📸 Screenshots

| Setup & Build | Test PASS |
|:---:|:---:|
| ![Build](05_FlashLoanAgent/img/02_Flash_Loan.png) | ![Test](05_FlashLoanAgent/img/03_Flash_Loan_test.png) |

---

### 🗺️ Roadmap

- [x] Base Flash Loan receiver (Aave V3)
- [x] Uniswap V3 interface integration
- [x] Automatic repayment approval with fee
- [ ] Real arbitrage logic (WETH → DAI → WETH)
- [x] Automated Foundry tests on fork
- [ ] Profitability check before triggering
- [ ] Off-chain integration with `RealPriceBrain` radar

---

### ⚖️ Disclaimer

This project is for **educational and DeFi research purposes only**. The authors are not responsible for financial losses, regulatory violations, or any damages from using this software.

---

### 🧑‍💻 Author

**Héctor Oviedo** — Backend Developer & DeFi Researcher

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/hectorob/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/HEO-80)

---

<div align="center">
  <sub>Built with ☕ and DeFi research · <strong>Héctor Oviedo</strong> · Zaragoza, España</sub>
</div>
