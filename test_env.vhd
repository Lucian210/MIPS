----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 01:01:43 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component counter is
    Port ( clk: in std_logic; 
           up_down: in std_logic;
           en: in std_logic;
           semnal: out std_logic_vector(15 downto 0) 
     );
end component;

component mpg2 is
     Port(btn : in STD_LOGIC;
          clk : in STD_LOGIC;
          en : out STD_LOGIC);   
end component;


component ssdisplay is
    Port ( d0 : in STD_LOGIC_VECTOR (3 downto 0);
           d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;           
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component alu is
     Port ( clk : in std_logic;
           enable: in std_logic;
           sw : in std_logic_vector (15 downto 0);
           led : out std_logic_vector (15 downto 0));
end component;


component reg_file is
 Port ( 
        clk: in std_logic;
		ra1: in std_logic_vector (3 downto 0);
		ra2: in std_logic_vector (3 downto 0);
		wa: in std_logic_vector (3 downto 0);
		wd: in std_logic_vector (15 downto 0);
		reg_wr: in std_logic;
		rd1: out std_logic_vector (15 downto 0);
		rd2: out std_logic_vector(15 downto 0));
end component;

component IFetch is
  Port (   clk : in STD_LOGIC;
           branch_adr : in STD_LOGIC_VECTOR (15 downto 0);
           jump_adr : in STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC; 
           PC_Src : in STD_LOGIC;                   
           jmp : in STD_LOGIC;
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           pc : out STD_LOGIC_VECTOR (15 downto 0) 
       );
end component;


component IDecode is
  Port (  
            clk: in std_logic;
			instruction: in std_logic_vector(15 downto 0);
			WriteData: in std_logic_vector(15 downto 0);
			RegWrite: in std_logic;
			RegDst: in std_logic;
			ExtOp: in std_logic;
			ReadData1: out std_logic_vector(15 downto 0);
			ReadData2: out std_logic_vector(15 downto 0);
			Ext_Imm : out std_logic_vector(15 downto 0);
			Func : out std_logic_vector(2 downto 0);
			SA : out std_logic 
		);
end component;

component Instruction_Execute is
  Port (
        pc:in std_logic_vector(15 downto 0);
        RD1: in std_logic_vector(15 downto 0);
        ALUSrc: in std_logic;
        RD2: in std_logic_vector(15 downto 0);
        Ext_Imm: in std_logic_vector(15 downto 0);
        sa: in std_logic;
        func: in std_logic_vector(2 downto 0);
        ALUOp: in std_logic_vector(2 downto 0);
        Zero: out std_logic;
        ALURes: out std_logic_vector(15 downto 0);
        BranchAddress: out std_logic_vector(15 downto 0)  
        );
end component;

component MEM is
  Port (    clk : in std_logic;
            MemWrite : in std_logic;
			ALURes : in std_Logic_vector(15 downto 0);
			RD2 : in std_Logic_vector(15 downto 0);
			MemData : out std_logic_vector(15 downto 0);
			ALUOut : out std_logic_vector(15 downto 0) 
	   );
end component;

component ControlUnit is
  Port (     Instr:in std_logic_vector(2 downto 0);
			 RegDst: out std_logic;
			 ExtOp: out std_logic;
			 ALUSrc: out std_logic;
			 Branch: out std_logic;
			 Jump: out std_logic;
			 ALUOp: out std_logic_vector(2 downto 0);
			 MemWrite: out std_logic;
			 MemtoReg: out std_logic;
			 RegWrite: out std_logic
	   );
end component;


signal en: std_logic;
signal instr: std_logic_vector(15 downto 0);
signal pc: std_logic_vector(15 downto 0);
signal SSD_in: std_logic_vector(15 downto 0);


signal RD1: std_logic_vector(15 downto 0);
signal RD2: std_logic_vector(15 downto 0);
signal Ext_imm: std_logic_vector(15 downto 0);
signal Func: std_logic_vector(2 downto 0);
signal SA: std_logic;
signal WD: std_logic_vector(15 downto 0);
signal RegWrite: std_logic;
signal ExtOp: std_logic;
signal RegDst: std_logic;
signal Branch: std_logic;
signal Jump: std_logic;
signal MemtoReg: std_logic;

signal opcode: std_logic_vector(2 downto 0);
signal PCSrc:std_logic;


signal ALU_Src:std_logic;
signal ALU_Op:std_logic_vector(2 downto 0);
signal Zero_signal:std_logic;
signal ALURes_signal: std_logic_vector(15 downto 0);
signal ALURes_FINAL_signal: std_logic_vector(15 downto 0);
signal BranchAddress_signal: std_logic_vector(15 downto 0);
signal Jump_Adress: std_logic_vector(15 downto 0);


signal MemData: std_logic_vector(15 downto 0);

signal MemWrite: std_logic;
begin

P1: mpg2 port map(btn(0), clk, en);
P2: IFetch port map(clk,BranchAddress_signal, Jump_Adress, en ,sw(1), sw(2),instr, pc);
P3: IDecode port map(clk,instr,WD,RegWrite,RegDst,ExtOp,RD1,RD2,Ext_imm,Func,SA);
P4: Instruction_Execute port map(pc, RD1, ALU_Src, RD2, Ext_imm, SA, Func, ALU_Op, Zero_signal, ALURes_signal, BranchAddress_signal);
P5: MEM port map(clk, MemWrite, ALURes_signal, RD2, ALURes_FINAL_signal, MemData);
P6: ControlUnit port map(instr(15 downto 13), RegDst, ExtOp, ALU_Src, Branch, Jump, ALU_Op, MemWrite, MemtoReg, RegWrite);
P7: ssdisplay port map(SSD_in(15 downto 12), SSD_in(11 downto 8), SSD_in(7 downto 4), SSD_in(3 downto 0), clk, an, cat);
 

---and branch + alu
PCSrc<=Zero_signal and Branch;

---Mux MemtoReg
process(MemtoReg,ALURes_FINAL_signal,MemData)
begin
	case (MemtoReg) is
		when '1' => WD<=MemData;
		when '0' => WD<=ALURes_FINAL_signal;
		when others => WD<=WD;
	end case;
end process;	

 
 ---concatenare pc si instr
Jump_Adress<=pc(15 downto 14) & instr(13 downto 0);

---------------MUX afisare
process(instr,pc,RD1,RD2,Ext_Imm, ALURes_signal, MemData, WD)
begin
	case(sw(7 downto 5)) is
		when "000"=>
				SSD_in<=instr;			
		when "001"=>
				SSD_in<=pc;				
		when "010"=>
				SSD_in<=RD1;				
		when "011"=>
				SSD_in<=RD2;				
		when "100"=>
				SSD_in<=Ext_Imm;			
		when "101"=>
		        SSD_in<=ALURes_signal;    --alu in
        when "110"=>
                SSD_in<=MemData;  --MEM component out
        when "111"=>
                SSD_in<=WD; --write data(reg file)
		when others=>
				SSD_in<=X"0000";
	end case;
end process;


process(RegDst,ExtOp,ALU_Src,Branch,Jump,MemWrite,MemtoReg,RegWrite,sw,ALU_Op)
begin
	if sw(0)='0' then		
		led(7)<=RegDst;
		led(6)<=ExtOp;
		led(5)<=ALU_Src;
		led(4)<=Branch;
		led(3)<=Jump;
		led(2)<=MemWrite;
		led(1)<=MemtoReg;
		led(0)<=RegWrite;
		
	else
		led(2 downto 0)<=ALU_Op(2 downto 0);
		led(7 downto 3)<="00000";
	end if;
end process;	

end Behavioral;
