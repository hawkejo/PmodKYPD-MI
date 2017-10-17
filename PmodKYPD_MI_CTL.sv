`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Hawker
// 
// Create Date: 10/17/2017 09:57:41 AM
// Design Name: PmodKYPD Multiple-input Control
// Module Name: PmodKYPD_MI_CTL
// Target Devices: Nexys 4 DDR, Basys 3
// Tool Versions: Vivado 2017.3
// Description: A controller to interface with the PmodKYPD peripheral module
//              by Digilent. This module reads in the data form the PmodKYPD and
//              then asserts a bit representing which key was pressed. Because of
//              this approach, simultaneous button presses are supported in this
//              design.
// Inputs:  clk     - A 100 MHz clock used in the design. Since the individual keys
//                    are run through a debouncer, the clock speed is not reduced
//                    in the design.
//                      WIDTH: [0:0]
// Inouts:  GPIO    - The Pmod I/O pins on the FPGA to which the keypad connects
//                    to. Specifically, the rows [1:4] are pins [10:7] and the
//                    columns [1:4] are pins [4:1]. All pins here are low
//                    asserted.
//                      WIDTH: [7:0]
// Outputs: out     - The output array of individual signals for each button on
//                    the peripheral module. In order to support simultaneous
//                    inputs, each individual button corresponds to a pin on this
//                    device. The signal is respective to the value labelled on
//                    the button (0 is bit 0, 1 is bit 1, F is bit 15, and so
//                    forth). Outputs are high asserted and only 1 button per
//                    row can be pressed at a time.
//                      WIDTH: [15:0]
//
// 
// Dependencies: 100 MHz Clock, PmodKYPD device
// 
// Revision: 1.00
// Revision 1.00 - File completed
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module PmodKYPD_MI_CTL(out, GPIO, clk);
    output reg [15:0] out;
    inout [7:0] GPIO;
    input clk;
    
    reg [15:0] clkCnt;
    wire redClk;
    
    reg [3:0] col;
    wire [3:0] row;
    
    // Interface with the GPIO pins.
    assign GPIO[3:0] = col;
    assign row = GPIO[7:4];
    
    // Start with reducing the clock signal to around 1.k kHz
    initial begin
        clkCnt <= 16'h0000;
    end
    
    always_ff @ (posedge clk)
        clkCnt++;
    
    assign redClk = clkCnt[15];
    
    // Selection logic to determine which column of buttons that we
    // are reading from.
    initial begin
        col <= 4'b0111;
    end
    
    always_ff @ (posedge redClk) begin
        if (col == 4'b0111)
            col <= 4'b1011;
        else if (col == 4'b1011)
            col <= 4'b1101;
        else if (col == 4'b1101)
            col <= 4'b1110;
        else if (col == 4'b1110)
            col <= 4'b0111;
        else
            col <= 4'b0111;  
    end
    
    always_ff @ (posedge redClk) begin
        if (col == 4'b0111) begin       // Read column LL, col 1
            out[1] <= ~row[3];       // 1
            out[4] <= ~row[2];       // 4
            out[7] <= ~row[1];       // 7
            out[0] <= ~row[0];       // 0
        end
        else if (col == 4'b1011) begin  // Read column LC, col 2
            out[2] <= ~row[3];       // 2
            out[5] <= ~row[2];       // 5
            out[8] <= ~row[1];       // 8
            out[15] <= ~row[0];      // F
        end
        else if (col == 4'b1101) begin  // Read column RC, col 3
            out[3] <= ~row[3];       // 3
            out[6] <= ~row[2];       // 6
            out[9] <= ~row[1];       // 9
            out[14] <= ~row[0];      // E
        end
        else if (col == 4'b1110) begin  // Read column RR, col 4
            out[10] <= ~row[3];      // A
            out[11] <= ~row[2];      // B
            out[12] <= ~row[1];      // C
            out[13] <= ~row[0];      // D
        end
    end
    
endmodule
