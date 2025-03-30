library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


ENTITY registerFile IS
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
END registerFile;

ARCHITECTURE registerFileBehavior OF registerFile IS
    -- Register file declaration and intialization
    TYPE reg_array IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL registers : reg_array := (OTHERS => (OTHERS => 'U'));
    
    -- Register 0 is always ZERO
    CONSTANT ZERO_REG : integer := 0;

    -- Copy write data
    SIGNAL write_data_temp: STD_LOGIC_VECTOR (31 DOWNTO 0);

    BEGIN
    reg_file_process1: process (clk)
    BEGIN
	-- Writing in the first half cycle
        if rising_edge(clk) THEN
	    if reg_write = '1' THEN
            -- Don't write to register 0 (always zero)
                if to_integer(unsigned(write_reg)) /= ZERO_REG THEN
		    write_data_temp <= write_data;
                END IF;
            END IF;	
	END IF;
	-- Reading in the second half cycle
	if falling_edge(clk) THEN
	    if (reg_write = '1' and write_reg = read_reg1) then
                read_data1 <= write_data_temp;
            else
                read_data1 <= registers(to_integer(unsigned(read_reg1)));
            end if;
	    if (reg_write = '1' and write_reg = read_reg2) then
                read_data2 <= write_data_temp;
            else
                read_data2 <= registers(to_integer(unsigned(read_reg2)));
            end if;
	END IF;
    END PROCESS;
	
	-- Update register
	registers(to_integer(unsigned(write_reg))) <= write_data_temp when (reg_write = '1');

end registerFileBehavior;
