----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2021 12:42:12 PM
-- Design Name: 
-- Module Name: ssd - Behavioral
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

entity ssdisplay is
    Port ( d0 : in std_logic_vector (3 downto 0);
           d1 : in std_logic_vector (3 downto 0);
           d2 : in std_logic_vector (3 downto 0);
           d3 : in std_logic_vector (3 downto 0);
           clk : in std_logic;
           an : out std_logic_vector (3 downto 0);
           cat : out std_logic_vector (6 downto 0));
end ssdisplay;

architecture Behavioral of ssdisplay is

signal auxD: std_logic_vector(3 DOWNTO 0);
signal sel: std_logic_vector(15 DOWNTO 0);

begin

mux41_1: process(sel)
begin
		case sel(15 DOWNTO 14)  is
			when "00"	=> auxD <= d0; 
			when "01"	=> auxD <= d1; 
			when "10"	=> auxD <= d2; 
			when others	=> auxD <= d3; 
		end case;
	end process;

mux41_2: process(sel)
begin
		case sel(15 DOWNTO 14) is
			when "00"	=>  an <= "1110";
			when "01"	=>  an <= "1101";
			when "10"	=>  an <= "1011";
			when others	=>  an <= "0111";
		end case;
	end process;

counter: process(clk)
begin 
    if rising_edge(clk) then
        sel <= sel + 1;
     end if;
     end process;

      
         with auxD select
        cat<= "1111001" when "0001",  
              "0100100" when "0010",   
              "0110000" when "0011",   
              "0011001" when "0100",   
              "0010010" when "0101",  
              "0000010" when "0110",  
              "1111000" when "0111",   
              "0000000" when "1000",   
              "0010000" when "1001",   
              "0001000" when "1010",  
              "0000011" when "1011",  
              "1000110" when "1100",  
              "0100001" when "1101",   
              "0000110" when "1110",   
              "0001110" when "1111",   
              "1000000" when others;   
              
              
      
    

end Behavioral;

