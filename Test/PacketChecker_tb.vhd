library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PacketChecker_tb is
end PacketChecker_tb;

architecture behavioral of PacketChecker_tb is
    component PacketChecker is
        generic (
            header : std_logic_vector(8 - 1 downto 0) := x"3B"
        );
        port (
            clk : in std_logic;
            rst : in std_logic;

            dataIn     : in std_logic_vector(8 - 1 downto 0);
            dataInRdy  : in std_logic;
            dataOut    : out std_logic_vector(8 - 1 downto 0);
            dataOutRdy : out std_logic;

            wrAddress : out std_logic_vector(16 - 1 downto 0);
            wrData    : out std_logic_vector(32 - 1 downto 0);
            wrEn      : out std_logic;
            rdAddress : out std_logic_vector(16 - 1 downto 0);
            rdData    : in std_logic_vector(32 - 1 downto 0);
            rdRdy     : in std_logic;
            rdEn      : out std_logic;

            error : out std_logic
        );
    end component;

    constant periodCLK : time := 20ns;

    signal clk       : std_logic;
    signal rst       : std_logic := '0';
    signal dataIn    : std_logic_vector(8 - 1 downto 0);
    signal dataInRdy : std_logic := '0';

    signal dataOut    : std_logic_vector(8 - 1 downto 0);
    signal dataOutRdy : std_logic;

    signal wrAddress : std_logic_vector(16 - 1 downto 0);
    signal wrData    : std_logic_vector(32 - 1 downto 0);
    signal wrEn      : std_logic;
    signal rdAddress : std_logic_vector(16 - 1 downto 0);
    signal rdData    : std_logic_vector(32 - 1 downto 0) := x"00000000";
    signal rdRdy     : std_logic                         := '0';
    signal rdEn      : std_logic;

    signal error : std_logic;
begin

    PacketCheckerInst : PacketChecker port map
        (clk, rst, dataIn, dataInRdy, dataOut, dataOutRdy, wrAddress, wrData, wrEn, rdAddress, rdData, rdRdy, rdEn, error);

    process
    begin
        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;
        rst <= '1' after periodCLK/8;
        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        rst <= '0' after periodCLK/8;

        for i in 1 to 10 loop
            clk <= '1';
            wait for periodCLK/2;
            clk <= '0';
            wait for periodCLK/2;
        end loop;

        dataIn    <= x"3B" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        dataIn    <= x"00" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        dataIn    <= x"12" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        dataIn    <= x"24" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        dataIn    <= x"48" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        dataIn    <= x"96" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        dataIn    <= x"44" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        dataIn    <= x"22" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;
        dataIn    <= x"01" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;
        dataIn    <= x"B5" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        for i in 1 to 10 loop
            clk <= '1';
            wait for periodCLK/2;
            clk <= '0';
            wait for periodCLK/2;
        end loop;
        dataIn    <= x"3B" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        dataIn    <= x"FF" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        dataIn    <= x"12" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        dataIn    <= x"24" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        dataIn    <= x"01" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;
        dataIn    <= x"70" after periodCLK/8;
        dataInRdy <= '1' after periodCLK/8;

        for i in 1 to 3 loop
            clk <= '1';
            wait for periodCLK/2;
            clk <= '0';
            wait for periodCLK/2;
        end loop;

        rdData <= x"11223344" after periodCLK/8;
        rdRdy  <= '1' after periodCLK/8;

        clk <= '1';
        wait for periodCLK/2;
        clk <= '0';
        wait for periodCLK/2;

        rdRdy <= '0' after periodCLK/8;

        for i in 1 to 10 loop
            clk <= '1';
            wait for periodCLK/2;
            clk <= '0';
            wait for periodCLK/2;
        end loop;

        wait;
    end process;

end architecture;
