
module  FFT ( clk, rst, data, data_valid, fft_valid,
 fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8,
 fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0, done);
input clk, rst;
input data_valid;
input  [15:0]data; 
output done ;
output fft_valid;
output reg[31:0] fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8;
output reg[31:0] fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0;

////////////////////////////////////////Don't touch////////////////////////
parameter signed [31:0]WR_0 = 32'h00010000 ;
parameter signed [31:0]WR_1 = 32'h0000EC83 ;
parameter signed [31:0]WR_2 = 32'h0000B504 ;
parameter signed [31:0]WR_3 = 32'h000061F7 ;
parameter signed [31:0]WR_4 = 32'h00000000 ;
parameter signed [31:0]WR_5 = 32'hFFFF9E09 ;
parameter signed [31:0]WR_6 = 32'hFFFF4AFC ;
parameter signed [31:0]WR_7 = 32'hFFFF137D ;
parameter signed [31:0]WI_0 = 32'h00000000 ;
parameter signed [31:0]WI_1 = 32'hFFFF9E09 ;
parameter signed [31:0]WI_2 = 32'hFFFF4AFC ;
parameter signed [31:0]WI_3 = 32'hFFFF137D ;
parameter signed [31:0]WI_4 = 32'hFFFF0000 ;
parameter signed [31:0]WI_5 = 32'hFFFF137D ;
parameter signed [31:0]WI_6 = 32'hFFFF4AFC ;
parameter signed [31:0]WI_7 = 32'hFFFF9E09 ;
///////////////////////////////////////////////////////////////////////////

reg [2:0]cur_st,next_st;
parameter [2:0]IDLE=0,LOAD=1,CAL=2,OUT=3,DONE=4;
reg [2:0]counter_cal;
reg [9:0]counter_load;
reg [15:0] d0[61:0],d1[61:0],d2[61:0],d3[61:0],d4[61:0],d5[61:0],d6[61:0],d7[61:0],d8[61:0],d9[61:0],d10[61:0],d11[61:0],d12[61:0],d13[61:0],d14[61:0],d15[61:0] ;//INPUT DATA
reg [47:0] f0,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15;//FIRST CAL ANSWER
reg [47:0] g0,g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12,g13,g14,g15;//SECOND CAL ANSWER
reg [47:0] h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14,h15;//THIRD CAL ANSWER
reg [47:0] I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,I11,I12,I13,I14,I15;//FORTH CAL ANSWER
wire [5:0]round_data;
reg  [5:0]round_data2;

assign round_data=counter_load[9:4];
assign done=(cur_st==DONE)?1:0;
assign fft_valid=(cur_st==OUT)?1:0;

always @(posedge clk or posedge rst) begin
    if(rst)    
        cur_st<=IDLE;
    else
        cur_st<=next_st;
end

always @(*) begin
    case(cur_st)
        IDLE:next_st=(rst)?IDLE:LOAD;
        LOAD:next_st=(counter_load==992)?CAL:LOAD;
        CAL:next_st=(counter_cal==5)?OUT:CAL;
        OUT:next_st=(round_data2==61)?DONE:CAL;
        DONE:next_st=DONE;
        default:next_st=IDLE;
    endcase
end

always @(posedge clk) begin
    if(rst)
        counter_cal<=0;
    else if(cur_st==CAL)
        counter_cal<=counter_cal+1;
end

always @(posedge clk) begin
    if(rst)
        round_data2<=0;
    else if(cur_st==OUT)
        round_data2<=round_data2+1;
end

always @(posedge clk) begin
    if(cur_st==CAL)begin
        if(counter_cal[2:0]==1)begin
            f0<=fft_a1(d0[round_data2],d8[round_data2]);
            f1<=fft_a1(d1[round_data2],d9[round_data2]);
            f2<=fft_a1(d2[round_data2],d10[round_data2]);
            f3<=fft_a1(d3[round_data2],d11[round_data2]);
            f4<=fft_a1(d4[round_data2],d12[round_data2]);
            f5<=fft_a1(d5[round_data2],d13[round_data2]);
            f6<=fft_a1(d6[round_data2],d14[round_data2]);
            f7<=fft_a1(d7[round_data2],d15[round_data2]);
            f8<=fft_b1(d0[round_data2],d8[round_data2],WR_0,WI_0);
            f9<=fft_b1(d1[round_data2],d9[round_data2],WR_1,WI_1);
            f10<=fft_b1(d2[round_data2],d10[round_data2],WR_2,WI_2);
            f11<=fft_b1(d3[round_data2],d11[round_data2],WR_3,WI_3);
            f12<=fft_b1(d4[round_data2],d12[round_data2],WR_4,WI_4);
            f13<=fft_b1(d5[round_data2],d13[round_data2],WR_5,WI_5);
            f14<=fft_b1(d6[round_data2],d14[round_data2],WR_6,WI_6);
            f15<=fft_b1(d7[round_data2],d15[round_data2],WR_7,WI_7);
        end
        else if(counter_cal[2:0]==2)begin
            g0<=fft_a(f0,f4);
            g1<=fft_a(f1,f5);
            g2<=fft_a(f2,f6);
            g3<=fft_a(f3,f7);
            g4<=fft_b(f0,f4,WR_0,WI_0);
            g5<=fft_b(f1,f5,WR_2,WI_2);
            g6<=fft_b(f2,f6,WR_4,WI_4);
            g7<=fft_b(f3,f7,WR_6,WI_6);
            g8<=fft_a(f8,f12);
            g9<=fft_a(f9,f13);
            g10<=fft_a(f10,f14);
            g11<=fft_a(f11,f15);
            g12<=fft_b(f8,f12,WR_0,WI_0);
            g13<=fft_b(f9,f13,WR_2,WI_2);
            g14<=fft_b(f10,f14,WR_4,WI_4);
            g15<=fft_b(f11,f15,WR_6,WI_6);
        end
        else if(counter_cal[2:0]==3)begin
            h0<=fft_a(g0,g2);
            h1<=fft_a(g1,g3);
            h2<=fft_b(g0,g2,WR_0,WI_0);
            h3<=fft_b(g1,g3,WR_4,WI_4);
            h4<=fft_a(g4,g6);
            h5<=fft_a(g5,g7);
            h6<=fft_b(g4,g6,WR_0,WI_0);
            h7<=fft_b(g5,g7,WR_4,WI_4);
            h8<=fft_a(g8,g10);
            h9<=fft_a(g9,g11);
            h10<=fft_b(g8,g10,WR_0,WI_0);
            h11<=fft_b(g9,g11,WR_4,WI_4);
            h12<=fft_a(g12,g14);
            h13<=fft_a(g13,g15);
            h14<=fft_b(g12,g14,WR_0,WI_0);
            h15<=fft_b(g13,g15,WR_4,WI_4);
        end
        else if (counter_cal[2:0]==4)begin
            I0<=fft_a(h0,h1);
            I8<=fft_b(h0,h1,WR_0,WI_0);
            I4<=fft_a(h2,h3);
            I12<=fft_b(h2,h3,WR_0,WI_0);
            I2<=fft_a(h4,h5);
            I10<=fft_b(h4,h5,WR_0,WI_0);
            I6<=fft_a(h6,h7);
            I14<=fft_b(h6,h7,WR_0,WI_0);
            I1<=fft_a(h8,h9);
            I9<=fft_b(h8,h9,WR_0,WI_0);
            I5<=fft_a(h10,h11);
            I13<=fft_b(h10,h11,WR_0,WI_0);
            I3<=fft_a(h12,h13);
            I11<=fft_b(h12,h13,WR_0,WI_0);
            I7<=fft_a(h14,h15);
            I15<=fft_b(h14,h15,WR_0,WI_0);
        end
    end
end

always @(posedge clk) begin
    if(counter_cal==5)begin
        fft_d0={I0[47:32],I0[23:8]};
        fft_d1={I1[47:32],I1[23:8]};
        fft_d2={I2[47:32],I2[23:8]};
        fft_d3={I3[47:32],I3[23:8]};
        fft_d4={I4[47:32],I4[23:8]};
        fft_d5={I5[47:32],I5[23:8]};
        fft_d6={I6[47:32],I6[23:8]};
        fft_d7={I7[47:32],I7[23:8]};
        fft_d8={I8[47:32],I8[23:8]};
        fft_d9={I9[47:32],I9[23:8]};
        fft_d10={I10[47:32],I10[23:8]};
        fft_d11={I11[47:32],I11[23:8]};
        fft_d12={I12[47:32],I12[23:8]};
        fft_d13={I13[47:32],I13[23:8]};
        fft_d14={I14[47:32],I14[23:8]};
        fft_d15={I15[47:32],I15[23:8]};
    end
end

always @(posedge clk) begin
    if(rst)
        counter_load<=0;
    else if(data_valid)
        counter_load<=counter_load+1;
    else
        counter_load<=0;
end

always @(posedge clk) begin
    if(data_valid)begin//cur_st==LOAD
        case(counter_load[3:0])
        0:d0[round_data]<=data;
        1:d1[round_data]<=data;
        2:d2[round_data]<=data;
        3:d3[round_data]<=data;
        4:d4[round_data]<=data;
        5:d5[round_data]<=data;
        6:d6[round_data]<=data;
        7:d7[round_data]<=data;
        8:d8[round_data]<=data;
        9:d9[round_data]<=data;
        10:d10[round_data]<=data;
        11:d11[round_data]<=data;
        12:d12[round_data]<=data;
        13:d13[round_data]<=data;
        14:d14[round_data]<=data;
        15:d15[round_data]<=data;
        endcase
    end
end

function [47:0]fft_a;
    input signed[47:0]x,y;
    reg signed [23:0]x_real,x_img,y_real,y_img,a_real,a_img;
    begin
        x_real=x[47:24];
        x_img=x[23:0];
        y_real=y[47:24];
        y_img=y[23:0];
        a_real=x_real+y_real;
        a_img=x_img+y_img;
        fft_a={a_real,a_img};
    end
endfunction

function [47:0]fft_a1;
    input signed[15:0]x,y;
    reg signed [15:0]a_real;//?
    begin
        a_real=x+y;
        fft_a1={a_real,32'd0};
    end
endfunction

function [47:0]fft_b;
    input signed[47:0]x,y;
    input signed[31:0]w_real,w_img;
    reg signed [23:0]x_real,x_img,y_real,y_img;
    reg signed[55:0] b_real,b_img;
    begin
        x_real=x[47:24];
        x_img=x[23:0];
        y_real=y[47:24];
        y_img=y[23:0];
        b_real=(x_real-y_real)*w_real+(y_img-x_img)*w_img;
        b_img=(x_real-y_real)*w_img+(x_img-y_img)*w_real;
        fft_b={(b_real[39:16]+b_real[15]),(b_img[39:16]+b_img[15])};
    end
endfunction

function [47:0]fft_b1;
    input signed[15:0]x,y;
    input signed[31:0]w_real,w_img;
    reg signed[47:0] b_real,b_img;
    begin
        b_real=(x-y)*w_real;
        b_img=(x-y)*w_img;
        fft_b1={b_real[31:8],b_img[31:8]};
    end
endfunction

endmodule





