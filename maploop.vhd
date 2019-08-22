library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity maploop is
generic (
    N : natural := 16
);
port (
	clk:  in std_logic;
	rst:  in std_logic;
	en_i: in std_logic;
	dv_o: out std_logic := '0';
	data_i: in std_logic_vector(3 downto 0);		
    data_o: out std_logic_vector(3 downto 0)
);
end maploop;

architecture maploop_arc of maploop is

    component mapping is
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
    end component;

    component demapping is
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
    end component;

    signal dv_l: std_logic;
    signal x_l:  std_logic_vector(N-1 downto 0);
    signal y_l: std_logic_vector(N-1 downto 0);

begin

    mapping_a: mapping
    generic map (
        N => N
    )
    port map (
        clk => clk,
        rst => rst,
        en_i => en_i,
        dv_o => dv_l,
        data => data_i,		
        x_o  => x_l, 
        y_o  => y_l
    );

    demapping_b: demapping
    generic map (
        N => N
        )
    port map (
        clk  => clk,
        rst  => rst,
        en_i => dv_l,
        dv_o => dv_o,
        x_i  => x_l,
        y_i  => y_l,
        data => data_o
    );

end maploop_arc;