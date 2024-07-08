//                              -*- Mode: system Verilog -*-
// Filename        : axi_master_agent_config.sv
// Description     : AXI Master Agent Config
// Author          : SK ABDUL FAHEMID
// Created On      : Mon July 08 17:40:49 2024
// Last Modified By: SK ABDUL FAHEMID
// Last Modified On: Mon July 08 17:40:49 2024
// Update Count    : 0
// Status          : Unknown, Use with caution!

///////////////////////////////////////////////////////////////////
//extend master_object_config from the uvm_object
class master_agent_config extends uvm_object;
  //factory registation
  `uvm_object_utils(master_agent_config)
  //declare the virtual interface handle for axi_if as"vif"
virtual axi_if vif;

//data members

uvm_active_passive_enum is_active=UVM_ACTIVE;
//declare the mon_rcvd_cnt as static int and initialize it to zero
static int mon_rcvd_cnt=0;
//declare the drv_sent_cnt as static int and initialize it to zero
static int drv_sent_cnt=0;

//methods

//standard UVM methods
extern function new(string name="master_agent_config");
endclass

//constructor new method
function master_agent_config::new(string name="master_agent_config");
  super.new(name);
 endfunction
