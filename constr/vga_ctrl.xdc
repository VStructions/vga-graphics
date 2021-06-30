#
#  vga_ctrl.xdc
#
#  Created on: Feb 10, 2021
#      Author: VStructions
#
# ZedBoard Pin Assignments #
############################

#########################
# On-board 100Mhz clock #
#########################
set_property -dict {PACKAGE_PIN Y9 IOSTANDARD LVCMOS33 } [get_ports { clk_100MHz }];

##create_clock -period 10.000 -name clk_100MHz -waveform {0.000 5.000} [get_ports clk_100MHz];
###########################
# On-board Slide Switches #
###########################
set_property -dict { PACKAGE_PIN H22   IOSTANDARD LVCMOS33 } [get_ports { sw2   }];
set_property -dict { PACKAGE_PIN G22   IOSTANDARD LVCMOS33 } [get_ports { sw1   }];
set_property -dict { PACKAGE_PIN F22   IOSTANDARD LVCMOS33 } [get_ports { sw0   }];
set_property -dict { PACKAGE_PIN F21   IOSTANDARD LVCMOS33 } [get_ports { reset }];

############
# VGA Pins #
############ 
set_property -dict { PACKAGE_PIN V20    IOSTANDARD LVCMOS33 } [get_ports { red[3] }];
set_property -dict { PACKAGE_PIN U20    IOSTANDARD LVCMOS33 } [get_ports { red[2] }];
set_property -dict { PACKAGE_PIN V19    IOSTANDARD LVCMOS33 } [get_ports { red[1] }];
set_property -dict { PACKAGE_PIN V18    IOSTANDARD LVCMOS33 } [get_ports { red[0] }];

set_property -dict { PACKAGE_PIN AB22   IOSTANDARD LVCMOS33 } [get_ports { green[3] }];
set_property -dict { PACKAGE_PIN AA22   IOSTANDARD LVCMOS33 } [get_ports { green[2] }];
set_property -dict { PACKAGE_PIN AB21   IOSTANDARD LVCMOS33 } [get_ports { green[1] }];
set_property -dict { PACKAGE_PIN AA21   IOSTANDARD LVCMOS33 } [get_ports { green[0] }];

set_property -dict { PACKAGE_PIN Y21    IOSTANDARD LVCMOS33 } [get_ports { blue[3] }];
set_property -dict { PACKAGE_PIN Y20    IOSTANDARD LVCMOS33 } [get_ports { blue[2] }];
set_property -dict { PACKAGE_PIN AB20   IOSTANDARD LVCMOS33 } [get_ports { blue[1] }];
set_property -dict { PACKAGE_PIN AB19   IOSTANDARD LVCMOS33 } [get_ports { blue[0] }];

set_property -dict { PACKAGE_PIN AA19   IOSTANDARD LVCMOS33 } [get_ports { hsync }];
set_property -dict { PACKAGE_PIN Y19    IOSTANDARD LVCMOS33 } [get_ports { vsync }];
