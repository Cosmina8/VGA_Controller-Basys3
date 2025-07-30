`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2025 10:17:59 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,
    input reset,
    input btnU,
    input btnD,
    input btnL,
    input btnR,
    output Hsync,
    output Vsync,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue
);

wire clk_148MHz;

 design_1_wrapper design_1_wrapper_i(
        .clk_in1_0(clk),
        .clk_out1_0(clk_148MHz),
        .reset_0(reset)
);
  
vga_controller vga_controller_i (
    .clk(clk_148MHz),
    .rst(reset),
    .btnU(btnU),
    .btnD(btnD),
    .btnL(btnL),
    .btnR(btnR),
    .Hsync(Hsync),
    .Vsync(Vsync),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue)
);        
endmodule
