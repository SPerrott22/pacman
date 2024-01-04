`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2023 02:54:31 PM
// Design Name: 
// Module Name: Clock
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

// Things to look out for: we don't have the USB-UART stuff set up here yet,
// also, we use = for initializing and also look out for integer overflow.
module Clock(
    // output 4 clock signals
    clkAdj, clkReg, clkFast, clkBlink,
    // Input
    clk

    );
    // 4 clock outputs
    output       reg clkAdj;                // 2 Hz
    output       reg clkReg;                // 1 Hz
    output       reg clkFast;               // 350 Hz --> 500 Hz
    output       reg clkBlink;              // 1.x Hz
    // input
    input        clk;                  // 100MHz == 100 * 10^6 Hz
    
    integer regCounter;
    integer adjCounter;
    integer blinkCounter;
    integer fastCounter; // change to sequential or whatever could be bad
        
    // divide by 350 not 80
    initial begin
        clkReg = 0;
        clkAdj = 0;
        clkFast = 0;
        clkBlink = 0;
     end
       
    always @ (posedge clk)
        begin
            if (regCounter == 50000000) // 100000000
                begin
                    clkReg = ~clkReg;
                    regCounter = 0;
                end
            if (adjCounter == 25000000) // 50000000
                begin
                    clkAdj = ~clkAdj;
                    adjCounter = 0;
                end
            if (blinkCounter == 10000000)
                begin
                    clkBlink = ~clkBlink;
                    blinkCounter = 0;
                end
            if (fastCounter == 200000) // 285714
                begin
                    clkFast = ~clkFast;
                    fastCounter = 0;
                end    
            fastCounter = fastCounter + 1;
            blinkCounter = blinkCounter + 1;
            regCounter = regCounter + 1;
            adjCounter = adjCounter + 1;
        end
 
    
endmodule
