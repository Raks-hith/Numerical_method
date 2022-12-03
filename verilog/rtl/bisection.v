`default_nettype none
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
