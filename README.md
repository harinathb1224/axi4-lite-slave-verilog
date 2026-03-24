🧠 AXI4-Lite Slave Interface Design
📌 Overview

This project implements an AXI4-Lite slave interface using Verilog, enabling communication between a processor and peripheral through a standard SoC protocol.

⚙️ Key Features
AXI4-Lite protocol implementation
Read and write transaction support
VALID/READY handshake mechanism
Register-mapped architecture
Self-checking testbench

🏗️ Architecture
Write Address Channel (AW)
Write Data Channel (W)
Write Response Channel (B)
Read Address Channel (AR)
Read Data Channel (R)

🔁 Operation
Write Operation
Address and data sent using VALID/READY handshake
Data stored in internal registers
Read Operation
Data fetched based on address
Returned via read data channel

Wavefroms
![Waveform](waveform/axi_waveform.png)

🧪 Simulation
Verified in Vivado using behavioral simulation
Multiple test cases executed
Correct read/write functionality observed

🛠️ Tools Used
Verilog HDL
Xilinx Vivado

🎯 Key Learnings
AMBA AXI Protocol
SoC communication
Digital design & verification
