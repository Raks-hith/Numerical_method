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

input clk, reset , input  [1:0]z01, z02, z03, z04, z11, z12, z13, z14, output reg  [19:0] alpha);

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
reg  [2:0]c[8:0];
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




fa= 20'b0;
fb= 20'b0;
fc= 20'b0;
r= a+b;
if(r[19]==1)
r= {1'b1, r>>1};
else
r= r>>1;

fa = s(c[0],c[1],c[2],c[3],c[4],a);
fb = s(c[0],c[1],c[2],c[3],c[4],b);
fc = s(c[0],c[1],c[2],c[3],c[4],r);

if (abso(fc)>e)
    begin
    if (((fa[19]==1) &&(fc[19]==0))|| ((fa[19]==0) &&(fc[19]==1)))
          b =r;
    else
          a =r;
          r= a+b;
          r= r>>1;
    fc = s(c[0],c[1],c[2],c[3],c[4],r);
   
   
    temp= 201'd32768;
          temp= temp<<15;
        if(r[19]==1)
       
        temp= temp/(-r);
        else
        temp= temp/r;
        alpha= temp[19:0];
       
        z = s(0,z01,z02,z03,z04,r);
        temp= 201'd8192;
        temp= temp<<15;
        
    end
   
end
end


function [19:0] s;
    input [2:0] c0;
    input [2:0] c1;
    input [2:0] c2;
    input [2:0] c3;
    input [2:0] c4;
  
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
