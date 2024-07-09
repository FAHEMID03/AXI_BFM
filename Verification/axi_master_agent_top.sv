//                              -*- Mode: system verilog and UVM -*-
// Filename        : axi_master_agent_top.sv
// Description     : AXI Master agent TOP
// Author          : SK ABDUL FAHEMID
// Created On      : Tue July  9 17:40:49 2024
// Last Modified By: SK ABDUL FAHEMID
// Last Modified On: Tue July  9 17:40:49 2024
// Update Count    : 0
// Status          : Unknown, Use with caution!

//extend master_agent_top from uvm_env
class master_agent_top extends uvm_env;

//factory registartion
   `uvm_component_utils(master_agent_top)
//create the agent handle
   master_agent agnth;

// methods

//STandard UVM methods
   extern function new(string name="master_agent_top",uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);
   endclass

//Constructor new method
//define constrcutor new method
  function master_agent_top::new(string name="master_agent_top",uvm_component parent);
  super.new(name,parent);
  endfunction

//-------Build() phase method ---------------------//

  function void master_agent_top::build_phase(uvm_phase phase);
  super.build_phase(phase);
//create the instance of master_agent
  agnth = master_agent::type_id::create("agnth",this);
  endfunction

//------------run_phase method ------------------------------//
  //print the topology
  task master_agent_top :: run_phase(uvm_phase phase);
        uvm_top.print_topology();
  endtask
