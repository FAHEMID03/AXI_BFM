//                              -*- Mode: system Verilog -*-
// Filename        : axi_master_agent.sv
// Description     : AXI Master Agent
// Author          : SK ABDUL FAHEMID
// Created On      : Mon July 08 17:40:49 2024
// Last Modified By: SK ABDUL FAHEMID
// Last Modified On: Mon July 08 17:40:49 2024
// Update Count    : 0
// Status          : Unknown, Use with caution!


//extend master_agent from uvm_agent
class master_agent extends uvm_agent;

//factory registartion
`uvm_component_utils(master_agent)

//declare handles of master_driver,master_monitor,master_sequencer
//with handles names as ms_drvh,ms_monh,ms_sequencer
 master_driver ms_drvh;
 master_monitor ms_monh;
 master_sequencer ms_sequencer;

master_agent_config ms_cfg;
//Methods

//Standard UVM methods

extern function new(string name="master_agent",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

///construct new
function master_agent::new(string name="master_agent",uvm_component parent=null);
 super.new(name,parent);
endfunction

///////-----------------build phase------------------------//

 //call parent build_phase
 //create master_monitor instancce
 //if is_active=UVM_ACTIVE, create master_driver & master_sequener instances
function void master_agent::build_phase(uvm_phase phase);
 super.build_phase(phase);
 //get the config object using uvm_config_db
 if(!uvm_config_db #(master_agent_config)::get(this,"","master_agent_config",ms_cfg))
                    `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

    ms_monh=master_monitor::type_id::create("ms_monh",this);
                       if(ms_cfg.is_active==UVM_ACTIVE)
                         begin
                           ms_drvh=master_driver::type_id::create("ms_drvh",this);
                           ms_sequencer=master_sequencer::type_id::create("ms_sequencer",this);
                         end
        endfunction


//------------------------connect phase method--------------------------//
//if is_active=UVM_ACTIVE,
//connect driver(TLM seq_item_port) and sequencer (TLM seq_item_export)
        function void master_agent::connect_phase(uvm_phase phase);
                if(ms_cfg.is_active==UVM_ACTIVE)
                  begin
                    ms_drvh.seq_item_port.connect(ms_sequencer.seq_item_export);
                  end
        endfunction
