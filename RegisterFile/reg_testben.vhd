library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY register_testbench IS
END register_testbench;

architecture r_testbench of register_testbench is
	component registerFile IS
    	PORT (
        	clk        : IN STD_LOGIC;
        	reg_write  : IN STD_LOGIC;
        	read_reg1  : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
       		read_reg2  : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        	write_reg  : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        	write_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        	read_data1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        	read_data2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    	);
	end component;

signal clk: std_logic := '1';
signal reg_w: std_logic := '1';
signal read_r1: std_logic_vector(4 DOWNTO 0) := (others => '0');
signal read_r2: std_logic_vector(4 DOWNTO 0) := (others => '0');
signal write_r: std_logic_vector(4 DOWNTO 0) := (others => '0');
signal w_data: std_logic_vector(31 DOWNTO 0) := (others => '0');
signal r_data1: std_logic_vector(31 DOWNTO 0) := (others => '0');
signal r_data2: std_logic_vector(31 DOWNTO 0) := (others => '0');

begin
	reg_test: registerFile port map(clk, reg_w, read_r1, read_r2, write_r, w_data, r_data1, r_data2);

	process
	begin

		reg_w <= '1';
		read_r1(0) <= '0';
		read_r2(1) <= '1';
		write_r(0) <= '0';
		w_data(0) <= '1';
		wait for 1 ns;
		assert unsigned(r_data1) = 0 report "r_data1 must be 0 as we write in register 0";

		
		reg_w <= '1';
		read_r1(0) <= '1';
		read_r2(1) <= '1';
		write_r(0) <= '1';
		w_data(0) <= '1';
		wait for 1 ns;
		assert unsigned(r_data1) = 1 report "r_data1 must be 1 as we write 1 in register number 1";

		reg_w <= '0';
		read_r1(0) <= '1';
		read_r2(1) <= '1';
		write_r(0) <= '1';
		w_data(1) <= '1';
		wait for 1 ns;
		assert unsigned(r_data1) = 1 report "r_data1 must still 1 not 3 as reg_w = 0";

		reg_w <= '1';
		read_r1(0) <= '1';
		read_r2(1) <= '1';
		write_r(0) <= '0';
		write_r(1) <= '1';
		w_data(1) <= '0';
		w_data(0) <= '1';
		wait for 1 ns;
		assert unsigned(r_data2) = 1 report "r_data2 must be 1 as we write 1 in register number 2";

		reg_w <= '1';
		read_r1(0) <= '1';
		read_r2(1) <= '1';
		write_r(0) <= '0';
		write_r(1) <= '1';
		w_data(0) <= '1';
		w_data(1) <= '1';
		wait for 1 ns;
		assert unsigned(r_data2) = 3 report "r_data2 must be 3 as we write 3 in register number 2";


		reg_w <= '1';
		read_r1(0) <= '1';
		read_r2(1) <= '1';
		write_r(0) <= '1';
		write_r(1) <= '0';
		w_data(0) <= '1';
		w_data(1) <= '1';
		wait for 1 ns;
		assert unsigned(r_data1) = 3 report "r_data1 must be 3 as we write 3 in register number 1";

	end process;

	process
	begin
		while true loop
			clk <= '1';
			wait for 0.5 ns;
			clk <= '0';
			wait for 0.5 ns;
		end loop;
	end process;


end r_testbench;
