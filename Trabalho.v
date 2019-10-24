module count99(input clk, input rst, output [6:0] Count, output loop);  reg [6:0] Count;
always @ (posedge clk or negedge rst)
begin
  if (~rst)
	Count <= 0;   // reset register
  else if ( Count == 99 )
	Count <= 0;
  else
	Count <= Count + 1;  // increment register
end
assign loop = (Count == 99);
endmodule

module count59(input clk, input rst, input ud, output [6:0] Count, output loop);  reg [6:0] Count;
  always @ (posedge clk or negedge rst)
begin
  if (~rst)
	Count <= 0;   // reset register
  else if ( Count == 59 & ud )
	Count <= 0;
 else if ( Count == 00 & ~ud)
	Count <= 59;
 else if (ud)
	Count <= Count + 1;  // increment register
  else Count <= Count - 1;
end
assign loop = (Count == 59)&ud | (Count == 00)&~ud;
endmodule

module countc59(input clk, input rst, input ud, output [6:0] Count);  reg [6:0] Count;
  always @ (posedge clk or negedge rst)
begin
  if (~rst)
	Count <= 0;   // reset register
  else if (ud)
	Count <= 0;
  else
	Count <= Count + 1;  // increment register
end
endmodule

module count23(input clk, input rst, input ud, output [6:0] Count);  reg [6:0] Count;
  always @ (posedge clk or negedge rst)
begin
  if (~rst)
	Count <= 0;   // reset register
  else if ( Count == 23 & ud )
	Count <= 0;
 else if ( Count == 00 & ~ud)
	Count <=23;
 else if (ud)
	Count <= Count + 1;  // increment register
  else Count <= Count - 1;
end
endmodule

module statemModo(input clk, reset, h, output r, ah, am, c, aj_h, aj_m);
reg [3:0] state;
parameter r0=4'd0, r1=4'd1, ah0=4'd2, ah1=4'd3, am0=4'd4, am1=4'd5, c0=4'd6, c1=4'd7, aj_h0=4'd8, aj_h1=4'd9, aj_m0=4'd10, aj_m1=4'd11;

assign r = (state == r0 | state == r1);
assign c = (state == c0 | state == c1);  
assign ah = (state == ah0 | state == ah1);
assign am = (state == am0 | state == am1);
assign aj_h = (state == aj_h0 | state == aj_h1);
assign aj_m = (state == aj_m0 | state == aj_m1);

always @(posedge clk or negedge reset)
 	begin
      	if (reset==0)
           	state = r0;
      	else
           	case (state)
                	r0:
                     	if ( h == 1'b1 ) state = r1;
                	r1:
                     	if ( h == 1'b0 ) state = ah0;
                	ah0:
                     	if ( h == 1'b1 ) state = ah1;
                	ah1:
                     	if ( h == 1'b0 ) state = am0;
                	am0:
                     	if ( h == 1'b1 ) state = am1;
                	am1:
                     	if ( h == 1'b0 ) state = c0;
                	c0:
                     	if ( h == 1'b1 ) state = c1;
                	c1:
                     	if ( h == 1'b0 ) state = aj_h0;
                	aj_h0:
                     	if ( h == 1'b1 ) state = aj_h1;
                	aj_h1:
                     	if ( h == 1'b0 ) state = aj_m0;
                	aj_m0:
                     	if ( h == 1'b1 ) state = aj_m1;
                	aj_m1:
                     	if ( h == 1'b0 ) state = r0;
   	 
           	endcase
 	end
endmodule

module statemMais(input clk, reset, h, r, c, t, output al, at,  c_start);
reg [3:0] state;
parameter al0=4'd0, al1=4'd1, ad0=4'd2, ad1=4'd3, at0=4'd4, at1=4'd5, c_start0=4'd6, c_start1=4'd7, c_stop0=4'd8, c_stop1=4'd9;

  assign al = (state == al0 | state == al1) ^(state == at0 | state == at1);
  assign at = (state == at0 | state == at1);
assign c_start = (state == c_start0 | state == c_start1);
 
  always @(posedge clk or negedge reset)
 	begin
   	if (reset==0)
        	state = ad0;
      	else
           	case (state)
                	ad0:
                  	if ( h == 1'b1 & r == 1'b1 & t == 1'b0 & c == 1'b0) state = ad1;
                 	else if (c == 1'b1) state = c_stop0;
                	ad1:
                     	if ( h == 1'b0 & r == 1'b1 & t == 1'b0 & c == 1'b0) state = al0;
                     	else if (c == 1'b1) state = c_stop0;
                	al0:
                  	if ( h == 1'b1 & r == 1'b1 & t == 1'b0 &c == 1'b0) state = al1;
                     	else if(t == 1'b1) state = at0;
                     	else if (c == 1'b1) state = c_stop0;
                	al1:
                   	if ( h == 1'b0 & r == 1'b1 & t == 1'b0 & c == 1'b0) state = ad0;
                     	else if(t == 1'b1) state = at0;
                     	else if (c == 1'b1) state = c_stop0;
                	at0:
                     	if ( h == 1'b1 & r == 1'b1 & t == 1'b1 & c == 1'b0) state = at1;
             	else if(t==1'b0) state = ad0;
                   	else if (c == 1'b1) state = c_stop0;
                	at1:
                  	if ( h == 1'b0 & r == 1'b1 & t == 1'b1 & c == 1'b0) state = ad0;
             	else if(t==1'b0) state = ad0;
                    	else if(c == 1'b1) state = c_stop0;
                	c_start0:
                     	if ( h == 1'b1 & c == 1'b1 ) state = c_start1;
                     	else if(c == 1'b0) state = ad0;
                	c_start1:
                     	if ( h == 1'b0 & c == 1'b1 ) state = c_stop0;
                     	else if(c == 1'b0) state = ad0;
                	c_stop0:
                     	if ( h == 1'b1 & c == 1'b1 ) state = c_stop1;
                     	else if(c == 1'b0) state = ad0;
                	c_stop1:
                     	if ( h == 1'b0 & c == 1'b1 ) state = c_start0;
             	else if(c == 1'b0) state = ad0;
   	 
           	endcase
 	end
endmodule


module relogio(input clk, res, modo, mais, menos, output [6:0] h,m,s, output alarmeon, som);

wire outs, outs1,outs2, routs, routs1, aouts, aouts1;
wire enable, nc_seg;
wire [6:0] sc, sr, sa, mc, mr, ma;
wire [6:0] hr, ha, cs;
wire r, c, ajusteHa, ajusteMa, ajusteHr, ajusteMr;

wire nc_relogioH, nc_relogioM , nc_alarmeH, nc_alarmeM;

assign nc_relogioM = (ajusteMr & mais)?mais:
(ajusteMr & menos)?menos:(~routs);
assign nc_relogioH = (ajusteHr & mais)?mais:
(ajusteHr & menos)?menos:(~routs1);
assign nc_alarmeM = (ajusteMa & mais)?mais:
(ajusteMa & menos)?menos:(~aouts);
assign nc_alarmeH = (ajusteHa & mais)?mais:
(ajusteHa & menos)?menos:(~aouts1);

wire ud = ~menos | mais;
wire zera = (menos)?0:(res)?1:0;
 
assign enable = start & clk;

count99 cent(enable,zera,cs,outs);
count59 seg(~outs,zera,ud,sc,outs1);
countc59 min(~outs1,zera,ud,mc);
 


count59 rseg(clk,res,ud,sr,routs);
count59 rmin(nc_relogioM,res,ud,mr,routs1);
count23 rhor(nc_relogioH,res,ud,hr);

  count59 aseg(1'b0,1'b0,ud,sa,aouts);
count59 amin(nc_alarmeM,res,ud,ma,aouts1);
count23 ahor(nc_alarmeH,res,ud,ha);

assign h = (c)?mc:
   	(ajusteHa | ajusteMa)?ha:hr;
assign m = (c)?sc:
   	(ajusteHa | ajusteMa)?ma:mr;
assign s = (c)?cs:
   	(ajusteHa | ajusteMa)?sa:sr;

wire at;
  wire igual = (hr==ha & mr==ma);
assign som = igual  & at &alarmeon;

 statemModo maq(clk,res,modo,r,ajusteHa,ajusteMa,c,ajusteHr,ajusteMr);
  statemMais maq2(clk,res,mais, r, c, igual, alarmeon, at, start);

endmodule

module top(input clk,res,modo,mais,menos,output[6:0] h,m,s, output alarmeon, som);

  relogio C(clk,res,modo,mais,menos,h,m,s,alarmeon,som);
 
endmodule

