# VGA Controller - Movable Red Triangle

## Project Description
This Verilog module implements a VGA controller that displays a movable red triangle on a 1920x1080 resolution screen at 60Hz. The triangle’s position can be controlled using four input buttons (up, down, left, right) with debounce logic implemented to ensure smooth and accurate movement. The background color is blue. Horizontal and vertical synchronization signals conform to VGA timing standards.

## Features
- VGA 1920x1080 @ 60Hz resolution support  
- Movable red triangle shape  
- Four-button control with debounce logic  
- Blue background  
- Proper horizontal and vertical sync signal generation  

## Inputs
- `clk` — Clock input  
- `rst` — Reset signal  
- `btnU` — Button Up  
- `btnD` — Button Down  
- `btnL` — Button Left  
- `btnR` — Button Right  

## Outputs
- `Hsync` — Horizontal synchronization signal  
- `Vsync` — Vertical synchronization signal  
- `vgaRed` — 4-bit red color output  
- `vgaGreen` — 4-bit green color output  
- `vgaBlue` — 4-bit blue color output  

## Usage
Connect the module inputs to the FPGA board clock, reset, and buttons. Connect the outputs to the VGA interface. Use the buttons to move the red triangle around the screen.




