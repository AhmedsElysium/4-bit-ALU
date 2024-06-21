module FullAdderSubtractor(input logic[3:0] A,B, logic S0, 
				output logic [3:0] Y, logic V);
	logic [3:0]compB;
	assign compB[0]=B[0]^S0;	
	assign compB[1]=B[1]^S0;
	assign compB[2]=B[2]^S0;
	assign compB[3]=B[3]^S0;

	logic [3:0] ADD_XOR_1;
	assign ADD_XOR_1[0]=compB[0]^A[0];
	assign ADD_XOR_1[1]=compB[1]^A[1];
	assign ADD_XOR_1[2]=compB[2]^A[2];
	assign ADD_XOR_1[3]=compB[3]^A[3];

	logic [3:0] ADD_AND_1;
	assign ADD_AND_1[0]=compB[0]&A[0];
	assign ADD_AND_1[1]=compB[1]&A[1];
	assign ADD_AND_1[2]=compB[2]&A[2];
	assign ADD_AND_1[3]=compB[3]&A[3];

	logic [3:0] ADD_XOR_2;
	logic [3:0] ADD_AND_2;
	logic [3:0] ADD_OR_1;
	
	assign ADD_XOR_2[0]=ADD_XOR_1[0]^S0;
	assign ADD_AND_2[0]=ADD_XOR_1[0]&S0;
	assign ADD_OR_1[0]=ADD_AND_1[0]|ADD_AND_2[0]; 

	
	assign ADD_XOR_2[1]=ADD_XOR_1[1]^ADD_OR_1[0];
	assign ADD_AND_2[1]=ADD_XOR_1[1]&ADD_OR_1[0];
	assign ADD_OR_1[1]=ADD_AND_1[1]|ADD_AND_2[1]; 
	
	assign ADD_XOR_2[2]=ADD_XOR_1[2]^ADD_OR_1[1];
	assign ADD_AND_2[2]=ADD_XOR_1[2]&ADD_OR_1[1];
	assign ADD_OR_1[2]=ADD_AND_1[2]|ADD_AND_2[2];

	assign ADD_XOR_2[3]=ADD_XOR_1[3]^ADD_OR_1[2];
	assign ADD_AND_2[3]=ADD_XOR_1[3]&ADD_OR_1[2];
	assign ADD_OR_1[3]=ADD_AND_1[3]|ADD_AND_2[3]; 
 
	assign V=ADD_OR_1[3];

	assign Y=ADD_XOR_2;


endmodule

module ALU_AND(input logic [3:0] A,B,
		output logic [3:0] Y);

	assign Y[0]=A[0]&B[0];
	assign Y[1]=A[1]&B[1];
	assign Y[2]=A[2]&B[2];
	assign Y[3]=A[3]&B[3];

endmodule

module ALU_OR(input logic [3:0] A,B,
		output logic [3:0] Y);

	assign Y[0]=A[0]|B[0];
	assign Y[1]=A[1]|B[1];
	assign Y[2]=A[2]|B[2];
	assign Y[3]=A[3]|B[3];

endmodule

module ALU_XOR(input logic [3:0] A,B,
		output logic [3:0] Y);

	assign Y[0]=A[0]^B[0];
	assign Y[1]=A[1]^B[1];
	assign Y[2]=A[2]^B[2];
	assign Y[3]=A[3]^B[3];

endmodule

module ALU_CMP(input logic [3:0] B,
		output logic [3:0] Y);

	assign Y[0]=~B[0];
	assign Y[1]=~B[1];
	assign Y[2]=~B[2];
	assign Y[3]=~B[3];

endmodule

module ALU_ASR(input logic [3:0]B,
		output logic [3:0]Y);
	assign Y[3]=B[3];
	assign Y[2]=B[3];
	assign Y[1]=B[2];
	assign Y[0]=B[1];
endmodule

module ALU_INC(input logic[3:0] B,
		output logic [3:0] Y,logic V);
	logic power;
	assign power=1;
	logic [3:0] ADD_XOR;
	logic [3:0] ADD_AND;

	assign ADD_XOR[0]=B[0]^power;
	assign ADD_AND[0]=B[0]&power;

	assign ADD_XOR[1]=B[1]^ADD_AND[0];
	assign ADD_AND[1]=B[1]&ADD_AND[0];

	assign ADD_XOR[2]=B[2]^ADD_AND[1];
	assign ADD_AND[2]=B[2]&ADD_AND[1];

	assign ADD_XOR[3]=B[3]^ADD_AND[2];
	assign ADD_AND[3]=B[3]&ADD_AND[2];

	assign V=ADD_AND[3];
	assign Y=ADD_XOR;
endmodule

module MUX_1bit(input logic A,B,S,
		output logic Y);
	assign Y=A&~S|B&S;
endmodule

module MUX_4bit(input logic [3:0]A,B,logic S,
		output logic [3:0] Y);

	MUX_1bit bit1(A[0],B[0],S,Y[0]);
	MUX_1bit bit2(A[1],B[1],S,Y[1]);
	MUX_1bit bit3(A[2],B[2],S,Y[2]);
	MUX_1bit bit4(A[3],B[3],S,Y[3]);
endmodule

module MUX_8to1_4bit(input logic [3:0] in1,in2,in3,in4,in5,in6,in7,in8, logic [2:0]S,
			output logic[3:0] Y);

	logic [3:0] out1,out2,out3,out4;

	MUX_4bit mux1(in1,in2,S[0],out1);
	MUX_4bit mux2(in3,in4,S[0],out2);
	MUX_4bit mux3(in5,in6,S[0],out3);
	MUX_4bit mux4(in7,in8,S[0],out4);

	logic [3:0] out5,out6;

	MUX_4bit mux5(out1,out2,S[1],out5);
	MUX_4bit mux6(out3,out4,S[1],out6);

	MUX_4bit mux7(out5,out6,S[2],Y);
endmodule

module ALU(input logic [3:0] A,B, logic [2:0] S, 
	   output logic [3:0] E, logic Z,V);

	logic[3:0] ADDSUB,OR,AND,CMP,XOR,ASR,INC;
	logic V1,V2;

	FullAdderSubtractor adder(A,B, S[0],ADDSUB,V1);
	ALU_AND logic_AND(A,B, AND);
	ALU_OR logic_OR(A,B, OR);
	ALU_XOR logic_XOR(A,B, XOR);
	ALU_CMP logic_CMP(B, CMP);
	ALU_INC arithmetic_INC(B, INC, V2);
	ALU_ASR arithmetic_ASR(B, ASR);
	

	MUX_8to1_4bit FinalMux(ADDSUB,ADDSUB,AND,OR,XOR,CMP,INC,ASR, S, E);
	
	MUX_1bit Vmux(V1,V2,S[2],V);
	assign Z=~(E[0]|E[1]|E[2]|E[3]);
endmodule

		
module TestBench();

	logic [3:0] A,B,E;
	assign A=0101;
	assign B=1101;
	logic [2:0] S;
	logic Z,V;
	
	ALU uut(A,B,S,E,Z,V);
	
	initial 
	begin
	S= 000 ; #100;
	S= 001 ; #100;
	S= 010 ; #100;
	S= 011 ; #100;
	S= 100 ; #100;
	S= 101 ; #100;
	S= 110 ; #100;
	S= 111 ; #100;
	end
endmodule



