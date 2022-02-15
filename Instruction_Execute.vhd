----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2021 05:48:59 PM
-- Design Name: 
-- Module Name: Instruction_Execute - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruction_Execute is
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
end Instruction_Execute;

architecture Behavioral of Instruction_Execute is



signal alu_in:std_logic_vector(15 downto 0);
signal ALUControl: std_logic_vector(3 downto 0);
signal ALURes_temp:std_logic_vector(15 downto 0);
signal Zero_temp: std_logic;

begin


BranchAddress<=pc+Ext_Imm;

process(ALUSrc, RD2, Ext_Imm)
begin
	case(ALUSrc) is
		when '0'=>
				alu_in<=RD2;			
		when others=>                 ----mux
				alu_in<=Ext_Imm;			
	end case;
end process;


---------ALUCT
process(ALUOp,func)
begin
	case (ALUOp) is
		when "000"=>
				case (Func) is
					when "000"=> ALUControl<="0000";--ADD
					when "001"=> ALUControl<="0001";--SUB
					when "010"=> ALUControl<="0010";--SLL
					when "011"=> ALUControl<="0011";--SRL
					when "100"=> ALUControl<="0100";--AND
					when "101"=> ALUControl<="0101";--OR
					when "110"=> ALUControl<="0110";--MULTU
					when "111"=> ALUControl<="0111";--XOR
					when others=> ALUControl<="1111";--OTHERS
				end case;
				
		when "001"=> ALUControl<="1000";--ADDI
		when "010"=> ALUControl<="1001";--LW
		when "011"=> ALUControl<="1010";--SW
		when "100"=> ALUControl<="1011";--BEQ
		when "101"=> ALUControl<="1100";--ORI
		when "110"=> ALUControl<="1101";--BNE
		when "111"=> ALUControl<="1110";--JUMP
		when others=> ALUControl<="1111";--OTHERS	

	end case;
end process;
	
process(ALUControl,RD1,alu_in,sa)
    begin
        case(ALUControl) is
            when "0000" => ALURes_temp<=RD1+alu_in;--ADD                       
            when "0001" => ALURes_temp<=RD1-alu_in;--SUB                                    
            when "0010" =>                         --SLL
                        case (sa) is
                            when '1' => ALURes_temp<=RD1(14 downto 0) & "0";
                            when others => ALURes_temp<=RD1;    
                        end case;                                   
            when "0011" =>                         --SRL
                        case (sa) is
                            when '1' => ALURes_temp<="0" & RD1(15 downto 1);
                            when others => ALURes_temp<=RD1;
                        end case;                                
            when "0100" => ALURes_temp<=RD1 and alu_in;--AND                                   
            when "0101" => ALURes_temp<=RD1 or alu_in;--OR
            --when "0110" => std_logic_vector(unsigned(RD1) * unsigned(alu_in));--MULTU                                                                                                      
            when "0111" => ALURes_temp<=RD1 xor alu_in;--XOR                       
            when "1000" => ALURes_temp<=RD1 + alu_in;--ADDI                      
            when "1001" => ALURes_temp<=RD1 + alu_in;--LW                       
            when "1010" => ALURes_temp<=RD1 + alu_in;--SW                       
            when "1011" =>
                        if (RD1 = ALURes_temp) then 
                        ALURes_temp<=X"0000";       --BEQ
                        end if;                   
            when "1100" => ALURes_temp<=RD1 or alu_in;--ORI                    
            when "1101" =>
                         if (RD1 /= ALURes_temp) then 
                         ALURes_temp<=X"0000";      --BNE
                         end if;               
            when "1110" => ALURes_temp<=X"0000";--JUMP                      
            when others => ALURes_temp<=X"0000";--OTHERS
        end case;
        
    
        case (ALURes_temp) is
            when X"0000" => Zero_temp<='1';
            when others => Zero_temp<='0';
        end case;    
end process;
    
    Zero<=Zero_temp;
    
    ALURes<=ALURes_temp;
    

end Behavioral;
