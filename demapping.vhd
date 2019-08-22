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
	en_i : in std_logic;
	dv_o : out std_logic;
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
	  Xneg : out std_ulogic;
	  x_o  : out std_logic_vector(N-1 downto 0);
	  y_o  : out std_logic_vector(N-1 downto 0);
	  z_o  : out std_logic_vector(N-1 downto 0)
	  );
  end component;

signal z_i: std_logic_vector(N-1 downto 0) := (others =>'0');

-- signal abs_x_i: std_logic_vector(N-1 downto 0) := (others =>'0');

signal x_o: std_logic_vector(N-1 downto 0);
signal y_o: std_logic_vector(N-1 downto 0);
signal z_o: std_logic_vector(N-1 downto 0);
signal zz_o: integer;
signal dv: 	 std_logic;
signal xneg: std_logic;

begin

	zz_o <= to_integer(signed(z_o));
	-- abs_x_i <= std_logic_vector(abs(signed(x_i)));

	comp_cordic: cordic
		generic map (
			N => N
		)
		port map (
			clk => clk,
			rst => rst,
			en_i => en_i,
			x_i => x_i,
			y_i => y_i,
			z_i => z_i,
			dv_o => dv,
			Xneg => xneg,
			x_o => x_o,
			y_o => y_o,
			z_o => z_o
		);

	mux: process(dv, xneg) is
	begin
		if xneg = '0' then
			if rising_edge(dv) then
				if    ((zz_o > -18432) and (zz_o <= -14336)) then  data <= "1100";
				elsif ((zz_o > -14336) and (zz_o <= -10240)) then  data <= "1101";
				elsif ((zz_o > -10240) and (zz_o <= -6144))  then  data <= "1110";
				elsif ((zz_o > -6144)  and (zz_o <= -2048))  then  data <= "1111";
				elsif ((zz_o > -2048)  and (zz_o <= 2048))   then  data <= "0000";
				elsif ((zz_o > 2048)   and (zz_o <= 6144))   then  data <= "0001";
				elsif ((zz_o > 6144)   and (zz_o <= 10240))  then  data <= "0010";
				elsif ((zz_o > 10240)  and (zz_o <= 14336))  then  data <= "0011";
				elsif ((zz_o > 14336)  and (zz_o <= 18432))  then  data <= "0100";
				else 
					data <= "1111";
				end if;
			end if;
		else 
			if rising_edge(dv) then
				if    ((zz_o > -14336) and (zz_o <= -10240)) then  data <= "1011";
				elsif ((zz_o > -10240) and (zz_o <= -6144))  then  data <= "1010";
				elsif ((zz_o > -6144)  and (zz_o <= -2048))  then  data <= "1001";
				elsif ((zz_o > -2048)  and (zz_o <= 2048))   then  data <= "1000";
				elsif ((zz_o > 2048)   and (zz_o <= 6144))   then  data <= "0111";
				elsif ((zz_o > 6144)   and (zz_o <= 10240))  then  data <= "0110";
				elsif ((zz_o > 10240)  and (zz_o <= 14336))  then  data <= "0101";
				else 
					data <= "1111";
				end if;
			end if;
		end if;

	end process;
	
	dv_o <= dv;

end demapping_arc;