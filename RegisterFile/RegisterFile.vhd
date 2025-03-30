library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.NUMERIC_STD.ALL;


entity RegisterFile is
    Port (
        clk       : in STD_LOGIC;
        regWrite  : in STD_LOGIC;
        readReg1  : in STD_LOGIC_VECTOR (4 downto 0);
        readReg2  : in STD_LOGIC_VECTOR (4 downto 0);
        writeReg  : in STD_LOGIC_VECTOR (4 downto 0);
        writeData : in STD_LOGIC_VECTOR (31 downto 0);
        readData1 : out STD_LOGIC_VECTOR (31 downto 0);
        readData2 : out STD_LOGIC_VECTOR (31 downto 0)
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    type reg_array is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
    signal registers : reg_array := (others => (others => '0'));
    signal clk_delayed : STD_LOGIC := '0';
    
    -- Register 0 is hardwired to zero in MIPS architecture
    constant ZERO_REG : integer := 0;

begin
    process (clk)
    begin
        if rising_edge(clk) then
            clk_delayed <= not clk_delayed;
            -- Writing in the first half cycle
            if clk_delayed = '0' then
		if RegWrite = '1' then
                	-- Don't write to register 0 (always zero)
                	if to_integer(unsigned(writeReg)) /= ZERO_REG then
                    		registers(to_integer(unsigned(writeReg))) <= writeData;
                	end if;
            	end if;
                
	    -- Reading in the second half cycle
            else
            -- Read port 1
            	if to_integer(unsigned(readReg1)) = ZERO_REG then
                	readData1 <= (others => '0');
            	else
                	readData1 <= registers(to_integer(unsigned(readReg1)));
            	end if;
            
            -- Read port 2
            	if to_integer(unsigned(readReg2)) = ZERO_REG then
                	readData2 <= (others => '0');
            	else
                	readData2 <= registers(to_integer(unsigned(readReg2)));
            	end if;
            end if;
        end if;
    end process;
end Behavioral;
