library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mapping is
generic (
    N : natural := 16
);
port (
	clk:  in std_logic;
	rst:  in std_logic;
	en_i: in std_logic;
	dv_o: out std_logic := '0';
	data: in std_logic_vector(3 downto 0);		
	x_o  : out std_logic_vector(N-1 downto 0) := (others => '0');
    y_o  : out std_logic_vector(N-1 downto 0) := (others => '0')
);
end mapping;

architecture mapping_arc of mapping is
begin
	 
	cordic: process(clk, data, en_i) is
	begin
		if rising_edge(clk) then
			if (en_i = '1') then
			dv_o <= '1';
 			case data is
      			when "0000" =>
					x_o <= std_logic_vector(to_signed(16384, N));
					y_o <= std_logic_vector(to_signed(0, N));		
      			when "0001" =>
					x_o <= std_logic_vector(to_signed(15137, N));
					y_o <= std_logic_vector(to_signed(6270, N));
      			when "0010" =>
					x_o <= std_logic_vector(to_signed(11585, N));
					y_o <= std_logic_vector(to_signed(11585, N));
				when "0011" =>
					x_o <= std_logic_vector(to_signed(6270, N));
					y_o <= std_logic_vector(to_signed(15137, N));  
				when "0100" =>
					x_o <= std_logic_vector(to_signed(0, N));
					y_o <= std_logic_vector(to_signed(16384, N));
				when "0101" =>
					x_o <= std_logic_vector(to_signed(-6270, N));
					y_o <= std_logic_vector(to_signed(15137, N));
				when "0110" =>
					x_o <= std_logic_vector(to_signed(-11585, N));
					y_o <= std_logic_vector(to_signed(11585, N));
				when "0111" =>
					x_o <= std_logic_vector(to_signed(-15137, N));
					y_o <= std_logic_vector(to_signed(6270, N));
				when "1000" =>
					x_o <= std_logic_vector(to_signed(-16384, N));
					y_o <= std_logic_vector(to_signed(0, N));
      			when "1001" =>
					x_o <= std_logic_vector(to_signed(-15137, N));
					y_o <= std_logic_vector(to_signed(-6270, N));
      			when "1010" =>
					x_o <= std_logic_vector(to_signed(-11585, N));
					y_o <= std_logic_vector(to_signed(-11585, N));
				when "1011" =>
					x_o <= std_logic_vector(to_signed(-6270, N));
					y_o <= std_logic_vector(to_signed(-15137, N));  
				when "1100" =>
					x_o <= std_logic_vector(to_signed(0, N));
					y_o <= std_logic_vector(to_signed(-16384, N));
				when "1101" =>
					x_o <= std_logic_vector(to_signed(6270, N));
					y_o <= std_logic_vector(to_signed(-15137, N));
				when "1110" =>
					x_o <= std_logic_vector(to_signed(11585, N));
					y_o <= std_logic_vector(to_signed(-11585, N));
				when "1111" =>
					x_o <= std_logic_vector(to_signed(15137, N));
					y_o <= std_logic_vector(to_signed(-6270, N));
				when others =>
					x_o <= std_logic_vector(to_signed(16384, N));
					y_o <= std_logic_vector(to_signed(0, N));
			end case;
			else
				x_o <= std_logic_vector(to_signed(0, N));
				y_o <= std_logic_vector(to_signed(0, N));
				dv_o <= '0';
			end if;
		end if;
	end process;
	
end mapping_arc;