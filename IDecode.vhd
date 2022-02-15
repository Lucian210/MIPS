----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2021 01:08:55 PM
-- Design Name: 
-- Module Name: IDecode - Behavioral
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

entity IDecode is
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
end IDecode;

architecture Behavioral of IDecode is

component reg_file is
 Port ( 
        clk: in std_logic;
		ra1: in std_logic_vector (2 downto 0);
		ra2: in std_logic_vector (2 downto 0);
		wa: in std_logic_vector (2 downto 0);
		wd: in std_logic_vector (15 downto 0);
		reg_wr: in std_logic;
		rd1: out std_logic_vector (15 downto 0);
		rd2: out std_logic_vector(15 downto 0));
end component;

signal write_adress: std_logic_vector(2 downto 0);
signal extend: std_logic_vector(15 downto 0);

signal RA1: std_logic_vector(2 downto 0);
signal RA2: std_logic_vector(2 downto 0);
begin

--mux r/i
process(RegDst,instruction)	
begin
	case (RegDst) is
		when '0' => write_adress<=instruction(9 downto 7);
		when '1'=>write_adress<=instruction(6 downto 4);
		when others=>write_adress<=write_adress;
	end case;
end process;

--ext unit
process(ExtOp,instruction)   
begin
	case (ExtOp) is
		when '1' => 	
				case (instruction(6)) is
					when '0' => extend <= B"000000000" & instruction(6 downto 0);
					when '1' =>  extend <=	B"111111111" & instruction(6 downto 0);
					when others => extend <= extend;
				end case;
		when others => extend <= B"000000000" & instruction(6 downto 0);
	end case;
end process;


Ext_imm <= extend;
SA <= instruction(3);
Func <= instruction(2 downto 0);
RA1 <= instruction(12 downto 10);
RA2 <= instruction(9 downto 7);


RF: reg_file port map(clk, RA1, RA2, write_adress, WriteData, RegWrite, ReadData1, ReadData2);
end Behavioral;
