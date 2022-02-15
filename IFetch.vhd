----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2021 07:58:30 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
  Port (   clk : in STD_LOGIC;
           branch_adr : in STD_LOGIC_VECTOR (15 downto 0);
           jump_adr : in STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC; 
           PC_Src : in STD_LOGIC;                   
           jmp : in STD_LOGIC;
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           pc : out STD_LOGIC_VECTOR (15 downto 0) 
       );
end IFetch;

architecture Behavioral of IFetch is
type ROM is array ( 0 to 255 ) of STD_LOGIC_VECTOR(15 downto 0);
signal rom_mem : ROM :=(
    --((3+5)-(12-6)) xor 5
    B"001_000_001_0000011", --addi $1 $0 3 (memoram 3 in reg 1)
    B"001_000_010_0000110", --addi $2 $0 5 (memoram 5 in reg 2)
    B"000_001_010_011_0_000", --add $3 $1 $2 (adunam registrul 1 si 2 si mem in 3)
    B"001_000_001_0001100", --addi $1 $0 12 (memoram 12 in reg 1)
    B"001_000_010_0000110", --addi $2 $0 6 (memoram 6 in reg 2)
    B"0_001_010_100_0_10010", --sub $4 $1 $2 (scadem registrul 1 si 2 si mem in 4)
    B"0_010_100_101_0_10010", --sub $5 $3 $4 (scadem registrul 3 si 4 si mem in 5)
    B"001_000_110_0000110", --addi $6 $0 5 (memoram 5 in reg 6)
    B"000_101_110_110_0_000", --xor $7 $5 $6 (xor intre reg 5 si 6)
    others =>x"1111"
);

signal adresa:INTEGER;
signal RF_in: STD_LOGIC_VECTOR(15 downto 0);
signal RF_add: STD_LOGIC_VECTOR(15 downto 0);
signal mux1: STD_LOGIC_VECTOR(15 downto 0);
signal mux2: STD_LOGIC_VECTOR(15 downto 0);
signal out_sum: STD_LOGIC_VECTOR(15 downto 0);


begin
--Pc
  process(clk)
   begin 
    if rising_edge(clk) then 
        if en = '1' then 
         RF_add<=RF_in;
        end if;
        end if;
    end process;

--add
    out_sum <= RF_add + 1;
    
--PC_Src mux
    process(PC_Src, branch_adr, out_sum)
    begin
        case(PC_Src) is
        when '1' => mux1 <=branch_adr;
        when '0' => mux1 <=out_sum;
        end case;
    end process;
--jump_adr mux
    process(jmp, jump_adr, mux1)
    begin
        case(jmp) is
        when '1' => mux2 <=jump_adr;
        when '0' => mux2 <=mux1;
        end case;
    end process;
  
    RF_in <= mux2;
    adresa<=conv_integer(RF_add);
    instr<=rom_mem(adresa);
    pc<=RF_add;

end Behavioral;
