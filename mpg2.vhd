----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2021 12:54:06 PM
-- Design Name: 
-- Module Name: mpg2 - Behavioral
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

entity mpg2 is
     Port(btn : in STD_LOGIC;
          clk : in STD_LOGIC;
          en : out STD_LOGIC);       
end mpg2;

architecture Behavioral of mpg2 is
signal cnt: std_logic_vector(15 downto 0);
signal Q1:STD_LOGIC;
signal Q2:STD_LOGIC;
signal Q3:STD_LOGIC;

begin

process (clk) 
begin
   if clk='1' and clk'event then
      cnt <= cnt+1;
   end if;
   
end process;


process (clk, cnt)
begin

   if (clk'event and clk='1') then 
       if cnt(15 downto 0) = "1111111111111111" then
		      Q1 <= btn;
      end if; 
   end if;
   
end process;

 

process (clk)
begin

		if (clk'event and clk='1') then 
         Q2 <= Q1;
      end if; 
      
end process;


process (clk)
begin

		if (clk'event and clk='1') then 
         Q3 <= Q2;
      end if; 
      
end process;
					
en <= Q2 and not Q3;


end Behavioral;
