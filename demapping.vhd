library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity demapping is
generic (
    N : natural := 16
);
port (
	clk  : in std_logic;
	rst  : in std_logic;
    x_i  : in std_logic_vector(N-1 downto 0);
    y_i  : in std_logic_vector(N-1 downto 0);
	data : out std_logic_vector(3 downto 0)
);
end demapping;

architecture demapping_arc of demapping is

component cordic is
	generic(
	  N : natural := 16; --Ancho de la palabra
	  ITER : natural := 12);--Numero de iteraciones
	port(
	  clk : in std_logic;
	  rst : in std_logic;
	  en_i : in std_logic;
	  x_i  : in std_logic_vector(N-1 downto 0);
	  y_i  : in std_logic_vector(N-1 downto 0);
	  z_i  : in std_logic_vector(N-1 downto 0);
	  dv_o : out std_logic;
	  x_o  : out std_logic_vector(N-1 downto 0);
	  y_o  : out std_logic_vector(N-1 downto 0);
	  z_o  : out std_logic_vector(N-1 downto 0)
	  );
  end component;

signal en:	std_logic := '1';
signal z_i: std_logic_vector(N-1 downto 0) := (others =>'0');

signal x_o: std_logic_vector(N-1 downto 0);
signal y_o: std_logic_vector(N-1 downto 0);
signal z_o: std_logic_vector(N-1 downto 0);
signal zz_o: std_logic_vector(N-1 downto 0) := (others =>'0');	
signal dv: 	std_logic;


begin

	zz_o <= z_o(N-1 downto 3) & "000";

	comp_cordic: cordic
		generic map (
			N => N
		)
		port map (
			clk => clk,
			rst => rst,
			en_i => en,
			x_i => x_i,
			y_i => y_i,
			z_i => z_i,
			dv_o => dv,
			x_o => x_o,
			y_o => y_o,
			z_o => z_o
		);

		mux: process(clk, rst, z_o) is
		begin
			if rising_edge(clk) then
				case to_integer(signed(z_o)) is
					when 0 =>
						data <= "0000";
					when others =>
						data <= "0000";
				end case;
			end if;
		end process;
			
end demapping_arc;


