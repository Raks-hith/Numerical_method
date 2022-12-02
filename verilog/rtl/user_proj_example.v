// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;

    // WB MI A
    assign valid = wbs_cyc_i && wbs_stb_i; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata = wbs_dat_i;

    // IO
    assign io_out = count;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = {{(127-BITS){1'b0}}, count};
    // Assuming LA probes [63:32] are for controlling the count register  
    assign la_write = ~la_oenb[63:32] & ~{BITS{valid}};
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

   /* counter #(
        .BITS(BITS)
    ) counter(
        .clk(clk),
        .reset(rst),
        .ready(wbs_ack_o),
        .valid(valid),
        .rdata(rdata),
        .wdata(wbs_dat_i),
        .wstrb(wstrb),
        .la_write(la_write),
        .la_input(la_data_in[63:32]),
        .count(count)
    );*/
    bisection(
      clk, reset, z01, z02, z03, z04, z05, z06, z07, z08,z09,z010, z011, z012, z11, z12, z13, z14, z15, z16, z17, z18, z19, z110, z111, z112, alpha, beta 
    );

endmodule

module bisection(input clk, reset , input  [1:0]z01, z02, z03, z04, z05, z06, z07, z08,z09,z010, z011, z012, z11, z12, z13, z14, z15, z16, z17, z18, z19, z110, z111, z112, output reg  [19:0] alpha, output reg  [19:0] beta);

reg  [200:0]temp;
reg  [19:0] e;
reg  [2:0] x1;
reg  [2:0] x0;
reg  [19:0] a;
reg  [19:0] b;
reg  [19:0] r;
reg  [19:0] fa;
reg  [19:0] fb;
reg  [19:0] fc;
reg  [19:0]z;
//reg  [19:0]y;
reg  [2:0]c[12:0];
always@(posedge clk or posedge reset)
begin
if(reset==1'b1)
begin
a= 20'b00000011110000000000;
b= 20'b00000101000000000000;

end

else
begin

e = 20'b00000000000000000001;
c[0]= 3'b0;
x1= {z11[1], z11};
x0= {z01[1], z01};
c[1]= x1- x0;
x1= {z12[1], z12};
x0= {z02[1], z02};
c[2]= x1- x0;
x1= {z13[1], z13};
x0= {z03[1], z03};
c[3]= x1- x0;
x1= {z14[1], z14};
x0= {z04[1], z04};
c[4]= x1- x0;
x1= {z15[1], z15};
x0= {z05[1], z05};
c[5]= x1- x0;
x1= {z16[1], z16};
x0= {z06[1], z06};
c[6]= x1- x0;
x1= {z17[1], z17};
x0= {z07[1], z07};
c[7]= x1- x0;
x1= {z18[1], z18};
x0= {z08[1], z08};
c[8]= x1- x0;
x1= {z19[1], z19};
x0= {z09[1], z09};
c[9]= x1- x0;
x1= {z110[1], z110};
x0= {z010[1], z010};
c[10]= x1- x0;
x1= {z111[1], z111};
x0= {z011[1], z011};
c[11]= x1- x0;
x1= {z112[1], z112};
x0= {z012[1], z012};
c[12]= x1- x0;


fa= 20'b0;
fb= 20'b0;
fc= 20'b0;
r= a+b;
if(r[19]==1)
r= {1'b1, r>>1};
else
r= r>>1;

fa = s(c[0],c[1],c[2],c[3],c[4],c[5],c[6],c[7],c[8],c[9],c[10],c[11],c[12],a);
fb = s(c[0],c[1],c[2],c[3],c[4],c[5],c[6],c[7],c[8],c[9],c[10],c[11],c[12],b);
fc = s(c[0],c[1],c[2],c[3],c[4],c[5],c[6],c[7],c[8],c[9],c[10],c[11],c[12],r);

if (abso(fc)>e)
    begin
    if (((fa[19]==1) &&(fc[19]==0))|| ((fa[19]==0) &&(fc[19]==1)))
          b =r;
    else
          a =r;
          r= a+b;
          r= r>>1;
    fc = s(c[0],c[1],c[2],c[3],c[4],c[5],c[6],c[7],c[8],c[9],c[10],c[11],c[12],r);
   
   
    temp= 201'd32768;
          temp= temp<<15;
        if(r[19]==1)
       
        temp= temp/(-r);
        else
        temp= temp/r;
        alpha= temp[19:0];
       
        z = s(0,z01,z02,z03,z04,z05,z06,z07,z08,z09,z010,z011,z012,r);
        temp= 201'd8192;
        temp= temp<<15;
        if(z[19]==1)
           
            temp= temp/(-z);
            else
            temp= temp/z;
            beta= temp[19:0];
    end
   
end
end


function [19:0] s;
    input [2:0] c0;
    input [2:0] c1;
    input [2:0] c2;
    input [2:0] c3;
    input [2:0] c4;
    input [2:0] c5;
    input [2:0] c6;
    input [2:0] c7;
    input [2:0] c8;
    input [2:0] c9;
    input [2:0] c10;
    input [2:0] c11;
    input [2:0] c12;
    input [19:0] val;
    reg [19:0] f;
    reg [19:0] y;
    reg [200:0] temp_pow;
    begin
    f=19'b0;
    temp_pow= val;
    y= temp_pow[19:0];
   
    if(c1 ==3'b001);
    else if(c1 ==3'b010)
    y = y<<1;
    else if(c1 ==3'b000)
    y=0;
    else if(c1 ==3'b111)
    y = -y;
    else //if(x == 3'b110)
    begin
    y= -y;
    y= y<<1;
    end
    f= f+y;
   
    //f= c1*temp_pow;

    temp_pow= temp_pow*val;
    temp_pow = temp_pow>>15;
    y= temp_pow[19:0];
    if(c2 ==3'b001);
    else if(c2 ==3'b010)
    y = y<<1;
    else if(c2 ==3'b000)
    y=0;
    else if(c2 ==3'b111)
    y = -y;
    else //if(x == 3'b110)
    begin
    y= -y;
    y= y<<1;
    end
    f= f+y;
    //f= f+ c2*temp_pow;
 
    temp_pow= temp_pow*val;
    temp_pow = temp_pow>>15;
    y= temp_pow[19:0];
    if(c3 ==3'b001);
        else if(c3 ==3'b010)
        y = y<<1;
        else if(c3 ==3'b000)
        y=0;
        else if(c3 ==3'b111)
        y = -y;
        else //if(x == 3'b110)
        begin
        y= -y;
        y= y<<1;
        end
        f= f+y;
    //f= f+ c3*temp_pow;

    temp_pow= temp_pow*val;
    temp_pow = temp_pow>>15;
    y= temp_pow[19:0];
    if(c4 ==3'b001);
        else if(c4 ==3'b010)
        y = y<<1;
        else if(c4 ==3'b000)
        y=0;
        else if(c4 ==3'b111)
        y = -y;
        else //if(x == 3'b110)
        begin
        y= -y;
        y= y<<1;
        end
        f= f+y;
    //f= f+ c4*temp_pow;

    temp_pow= temp_pow*val;
    temp_pow = temp_pow>>15;
    y= temp_pow[19:0];
    if(c5 ==3'b001);
        else if(c5 ==3'b010)
        y = y<<1;
        else if(c5 ==3'b000)
        y=0;
        else if(c5 ==3'b111)
        y = -y;
        else //if(x == 3'b110)
        begin
        y= -y;
        y= y<<1;
        end
        f= f+y;
   // f= f+ c5*temp_pow;
 
    temp_pow= temp_pow*val;
    temp_pow = temp_pow>>15;
    y= temp_pow[19:0];
    if(c6 ==3'b001);
        else if(c6 ==3'b010)
        y = y<<1;
        else if(c6 ==3'b000)
        y=0;
        else if(c6 ==3'b111)
        y = -y;
        else //if(x == 3'b110)
        begin
        y= -y;
        y= y<<1;
        end
        f= f+y;
    //f= f+ c6*temp_pow;

    temp_pow= temp_pow*val;
    temp_pow = temp_pow>>15;
    y= temp_pow[19:0];
    if(c7 ==3'b001);
        else if(c7 ==3'b010)
        y = y<<1;
        else if(c7 ==3'b000)
        y=0;
        else if(c7 ==3'b111)
        y = -y;
        else //if(x == 3'b110)
        begin
        y= -y;
        y= y<<1;
        end
        f= f+y;
    //f= f+ c7*temp_pow;

    temp_pow= temp_pow*val;
    temp_pow = temp_pow>>15;
    y= temp_pow[19:0];
    if(c8 ==3'b001);
        else if(c8 ==3'b010)
        y = y<<1;
        else if(c8 ==3'b000)
        y=0;
        else if(c8 ==3'b111)
        y = -y;
        else //if(x == 3'b110)
        begin
        y= -y;
        y= y<<1;
        end
        f= f+y;
    //f= f+ c8*temp_pow;
   
    temp_pow= temp_pow*val;
    temp_pow = temp_pow>>15;
    y= temp_pow[19:0];
    if(c9 ==3'b001);
        else if(c9 ==3'b010)
        y = y<<1;
        else if(c9 ==3'b000)
        y=0;
        else if(c9 ==3'b111)
        y = -y;
        else //if(x == 3'b110)
        begin
        y= -y;
        y= y<<1;
        end
        f= f+y;
    //f= f+ c9*temp_pow;

    temp_pow= temp_pow*val;
    temp_pow = temp_pow>>15;
    y= temp_pow[19:0];
    if(c10 ==3'b001);
        else if(c10 ==3'b010)
        y = y<<1;
        else if(c10 ==3'b000)
        y=0;
        else if(c10 ==3'b111)
        y = -y;
        else //if(x == 3'b110)
        begin
        y= -y;
        y= y<<1;
        end
        f= f+y;
    //f= f+ c10*temp_pow;

    temp_pow= temp_pow*val;
    temp_pow = temp_pow>>15;
    y= temp_pow[19:0];
    if(c11 ==3'b001);
        else if(c11 ==3'b010)
        y = y<<1;
        else if(c11 ==3'b000)
        y=0;
        else if(c11 ==3'b111)
        y = -y;
        else //if(x == 3'b110)
        begin
        y= -y;
        y= y<<1;
        end
        f= f+y;
    //f= f+ c11*temp_pow;
 
    temp_pow= temp_pow*val;
    temp_pow = temp_pow>>15;
    y= temp_pow[19:0];
    if(c12 ==3'b001);
        else if(c12 ==3'b010)
        y = y<<1;
        else if(c12 ==3'b000)
        y=0;
        else if(c12 ==3'b111)
        y = -y;
        else //if(x == 3'b110)
        begin
        y= -y;
        y= y<<1;
        end
        f= f+y;
    //f= f+ c12*temp_pow;
 
   s= f;
 end      
endfunction

function [19:0] abso;
    input [19:0] fc;
    if (fc[19]==1)
        abso = -(fc);
    else
        abso = fc;
    endfunction



endmodule
`default_nettype wire
