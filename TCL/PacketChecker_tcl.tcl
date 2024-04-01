quit -sim
.main clear

set PrefMain(saveLines) 1000000000

cd C:/FPGA/HW02/Sim
cmd /c "if exist work rmdir /S /Q work"
vlib work
vmap work

vcom -2008 ../Source/*.vhd
vcom -2008 ../Test/PacketChecker_tb.vhd

vsim -t 100ps -vopt PacketChecker_tb -voptargs=+acc

config wave -signalnamewidth 1

# add wave -format Logic -radix decimal sim:/PacketChecker_tb/*
add wave -format Logic -radix decimal sim:/PacketChecker_tb/PacketCheckerInst/*


run -all








# do C:/FPGA/HW02/TCL/PacketChecker_tcl.tcl