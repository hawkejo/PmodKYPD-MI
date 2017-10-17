`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Hawker
// 
// Create Date: 10/17/2017 09:57:41 AM
// Design Name: PmodKYPD Multiple-input test module
// Module Name: main
// Project Name: PmodKYPD Multiple-input
// Target Devices: Nexys 4 DDR, Basys 3
// Tool Versions: Vivado 2017.3
// Description: A test module to demo the interface with the PmodKYPD by Digilent.
//              All this module does is interface with the specified FPGA board.
//				This design is intended for a Basys 3 or Nexys 4 DDR FPGA.
// Input:	clk100MHz	- The 100 MHz clock used in the design for the controller
//							WIDTH: [0:0]
// Inout:	JA			- The data bus used to interface with the PmodKYPD. 4 pins
//						  are being used as input and 4 as output.
//							WIDTH: [7:0]
// output:	led			- The LEDs used to display the output of the keypad.
//							WIDTH: [15:0]
// 
// Dependencies: 100 MHz Clock, PmodKYPD module
// 
// Revision: 1.00
// Revision 1.00 - File completed
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module main(led, JA, clk100MHz);
    output [15:0] led;
    inout [7:0] JA;
    input clk100MHz;
    
    PmodKYPD_MI_CTL kpd0(.clk(clk100MHz), .out(led), .GPIO(JA));
    
endmodule
