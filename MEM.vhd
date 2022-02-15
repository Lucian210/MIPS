----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2021 09:59:28 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
  Port (    clk : in std_logic;
            MemWrite : in std_logic;
			ALURes : in std_Logic_vector(15 downto 0);
			RD2 : in std_Logic_vector(15 downto 0);
			MemData : out std_logic_vector(15 downto 0);
			ALUOut : out std_logic_vector(15 downto 0) 
	   );
end MEM;

architecture Behavioral of MEM is

type mem is array (0 to 15) of std_logic_vector(15 downto 0);
signal RAM:mem:=(
		X"0000",
		X"0001",
		X"0002",
		X"0003",
		X"0004",
		X"0005",
		X"0006",
		X"0007",		
		X"0008",		
		X"0009",		
		X"000A",		
		X"000B",		
		X"000C",		
		X"000D",		
		X"000E",		
		X"000F",				
		others =>X"1111");
begin

process(clk) 			
begin
	if(rising_edge(clk)) then		
		if MemWrite='1' then
			RAM(conv_integer(ALURes))<=RD2;			
		end if;
	end if;
	MemData<=RAM(conv_integer(ALURes));
end process;

    ALUOut <= ALURes;


end Behavioral;
