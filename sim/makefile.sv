#Makefile for UVM Testbench
RTL= ../rtl/axi_if.sv
work= work #library name
SVTB1= ../tb/top.sv
INC = +incdir+../tb +incdir+../test +incdir+../master_agent +incdir+../slave_agent
SVTB2 = ../test/axi_test_pkg.sv
VSIMOPT= -vopt -voptargs=+acc
VSIMCOV= -coverage -sva
VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit mem_cov1;run -all; exit"
VSIMBATCH2= -c -do  " log -r /* ;coverage save -onexit mem_cov2;run -all; exit"
VSIMBATCH3= -c -do  " log -r /* ;coverage save -onexit mem_cov3;run -all; exit"
VSIMBATCH4= -c -do  " log -r /* ;coverage save -onexit mem_cov4;run -all; exit"
VSIMBATCH5= -c -do  " log -r /* ;coverage save -onexit mem_cov5;run -all; exit"

sv_cmp:
        vlib $(work)
        vmap work $(work)
        vlog -work $(work) $(RTL) $(INC) $(SVTB2) $(SVTB1)

run_test:       sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1)  -wlf wave_file1.wlf -l test1.log  -sv_seed random  work.top +UVM_TESTNAME=test1
        vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov1


run_test1:      sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2)  -wlf wave_file2.wlf -l test2.log  -sv_seed random  work.top +UVM_TESTNAME=test2
        vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov2

run_test2:      sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3)  -wlf wave_file3.wlf -l test3.log  -sv_seed random  work.top +UVM_TESTNAME=test3
        vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov3

run_test3:      sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH4)  -wlf wave_file4.wlf -l test4.log  -sv_seed random  work.top +UVM_TESTNAME=test4
        vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov4

run_test4:      sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH5)  -wlf wave_file5.wlf -l test5.log  -sv_seed random  work.top +UVM_TESTNAME=test5
        vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov5

view_wave1:
        vsim -view wave_file1.wlf

view_wave2:
        vsim -view wave_file2.wlf

view_wave3:
        vsim -view wave_file3.wlf

view_wave4:
        vsim -view wave_file4.wlf

report:
        vcover merge mem_cov mem_cov1 mem_cov2 mem_cov3 mem_cov4 mem_cov5
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov

regress: clean run_test run_test1 run_test2 run_test3 run_test4 report

cov:
        firefox covhtmlreport/index.html&



clean:
        rm -rf transcript* *log* work *wlf fcover* covhtml* mem_cov*
        clear
