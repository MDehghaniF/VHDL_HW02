library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity PacketChecker is
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
end entity;

architecture behavioral of PacketChecker is

	type PC_state is (Head, Command, AddrH, AddrL, d4, d3, d2, d1, SumH, SumL, Proc, RR);
	signal PC_st : PC_state := Head;

	signal Command_tmp : std_logic_vector(8 - 1 downto 0) := x"88";
	signal Addr_H      : std_logic_vector(8 - 1 downto 0) := x"88";
	signal Addr_L      : std_logic_vector(8 - 1 downto 0) := x"88";
	signal D_4         : std_logic_vector(8 - 1 downto 0) := x"88";
	signal D_3         : std_logic_vector(8 - 1 downto 0) := x"88";
	signal D_2         : std_logic_vector(8 - 1 downto 0) := x"88";
	signal D_1         : std_logic_vector(8 - 1 downto 0) := x"88";
	signal Sum_H       : std_logic_vector(8 - 1 downto 0) := x"88";
	signal Sum_L       : std_logic_vector(8 - 1 downto 0) := x"88";

	signal Real_Sum   : std_logic_vector(15 downto 0);
	signal Real_Sum_2 : std_logic_vector(15 downto 0);
	signal Real_Sum_H : std_logic_vector(8 - 1 downto 0);
	signal Real_Sum_L : std_logic_vector(8 - 1 downto 0);

	signal Read_data : std_logic_vector(32 - 1 downto 0);
	signal send_resp : std_logic := '0';
begin
	PacketCheckerInst : process (clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				PC_st       <= Head;
				error       <= '0';
				Addr_H      <= x"00";
				Addr_L      <= x"00";
				D_4         <= x"00";
				D_3         <= x"00";
				D_2         <= x"00";
				D_1         <= x"00";
				Sum_H       <= x"00";
				Sum_L       <= x"00";
				send_resp   <= '0';
				Read_data   <= x"00000000";
				dataOutRdy  <= '0';
				dataOut     <= x"00";
				wrAddress   <= x"0000";
				rdAddress   <= x"0000";
				wrData      <= x"00000000";
				wrEn        <= '0';
				rdEn        <= '0';
				Command_tmp <= x"88";
			else
				case PC_st is
					when Head =>
						if send_resp = '1' then
							dataOutRdy <= '1';
							dataOut    <= x"3B";
							PC_st      <= Command;
						else
							error  <= '0';
							Addr_H <= x"00";
							Addr_L <= x"00";
							D_4    <= x"00";
							D_3    <= x"00";
							D_2    <= x"00";
							D_1    <= x"00";
							Sum_H  <= x"00";
							Sum_L  <= x"00";
							if dataInRdy = '1' then
								if dataIn = x"3B" then
									PC_st <= Command;
								end if;
							end if;
						end if;
					when Command =>
						if send_resp = '1' then
							dataOutRdy <= '1';
							dataOut    <= x"FF";
							PC_st      <= d4;
						else
							if dataInRdy = '1' then
								Command_tmp <= DataIn;
								PC_st       <= AddrH;
							end if;
						end if;
					when AddrH =>
						if dataInRdy = '1' then
							Addr_H <= DataIn;
							PC_st  <= AddrL;
						end if;
					when AddrL =>
						if dataInRdy = '1' then
							Addr_L <= DataIn;
							if Command_tmp = x"00" then
								PC_st <= d4;
							elsif Command_tmp = x"FF" then
								PC_st <= sumH;
							end if;
						end if;
					when d4 =>
						if send_resp = '1' then
							dataOutRdy <= '1';
							dataOut    <= Read_data(32 - 1 downto 32 - 8);
							PC_st      <= d3;
						else
							if dataInRdy = '1' then
								D_4   <= DataIn;
								PC_st <= d3;
							end if;
						end if;
					when d3 =>
						if send_resp = '1' then
							dataOutRdy <= '1';
							dataOut    <= Read_data(32 - 8 - 1 downto 32 - 8 - 8);
							PC_st      <= d2;
						else
							if dataInRdy = '1' then
								D_3   <= DataIn;
								PC_st <= d2;
							end if;
						end if;
					when d2 =>
						if send_resp = '1' then
							dataOutRdy <= '1';
							dataOut    <= Read_data(32 - 16 - 1 downto 32 - 16 - 8);
							PC_st      <= d1;
						else
							if dataInRdy = '1' then
								D_2   <= DataIn;
								PC_st <= d1;
							end if;
						end if;
					when d1 =>
						if send_resp = '1' then
							dataOutRdy <= '1';
							dataOut    <= Read_data(32 - 24 - 1 downto 32 - 24 - 8);
							PC_st      <= SumH;
						else
							if dataInRdy = '1' then
								D_1   <= DataIn;
								PC_st <= SumH;
							end if;
						end if;
					when SumH =>
						if send_resp = '1' then
							dataOutRdy <= '1';
							dataOut    <= Real_Sum_2(16 - 1 downto 8);
							PC_st      <= SumL;
						else
							if dataInRdy = '1' then
								Sum_H <= DataIn;
								if Real_Sum_H = Sum_H then
									PC_st <= SumL;
								else
									error <= '1';
									PC_st <= Head;
								end if;
							end if;
						end if;
					when SumL =>
						if send_resp = '1' then
							dataOutRdy <= '1';
							dataOut    <= Real_Sum_2(16 - 1 downto 8);
							PC_st      <= SumL;
						else
							if dataInRdy = '1' then
								Sum_L <= DataIn;
								if Real_Sum_L = Sum_L then
									PC_st <= Proc;
									if Command_tmp = x"00" then
										wrAddress <= (Addr_H & Addr_L);
										wrData    <= (D_4 & D_3 & D_2 & D_1);
									elsif Command_tmp = x"FF" then
										rdAddress <= (Addr_H & Addr_L);
									end if;
								else
									error <= '1';
									PC_st <= Head;
								end if;
							end if;
						end if;
					when Proc =>
						if Command_tmp = x"00" then
							wrEn  <= '1';
							PC_st <= Head;
						elsif Command_tmp = x"FF" then
							rdEn  <= '1';
							PC_st <= RR;
						end if;
					when RR =>
						if rdRdy = '1' then
							Read_data <= rdData;
							PC_st     <= RR;
						end if;
				end case;
			end if;
		end if;
	end process; -- PacketCheckerInst

	Real_Sum <=
		(x"00" & x"3B") +
		(x"00" & Command_tmp) +
		(x"00" & Addr_H) +
		(x"00" & Addr_L) +
		(x"00" & D_4) +
		(x"00" & D_3) +
		(x"00" & D_2) +
		(x"00" & D_1);
	Real_Sum_H <= Real_Sum(16 - 1 downto 8);
	Real_Sum_L <= Real_Sum(8 - 1 downto 0);

	Real_Sum_2 <=
		(x"00" & Read_data(32 - 1 downto 32 - 8)) +
		(x"00" & Read_data(32 - 8 - 1 downto 32 - 8 - 8)) +
		(x"00" & Read_data(32 - 16 - 1 downto 32 - 16 - 8)) +
		(x"00" & Read_data(32 - 24 - 1 downto 32 - 24 - 8));

end architecture;
