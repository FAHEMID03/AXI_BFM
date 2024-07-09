//                              -*- Mode:System Verilog & UVM-*-
// Filename        : axi_master_driver.sv
// Description     : AXI Master Driver
// Author          : SK ABDUL FAHEMID
// Created On      : Tue July  9 13:40:49 2024
// Last Modified By: SK ABDUL FAHEMID
// Last Modified On: Tue July  9 13:40:49 2024
// Update Count    : 0
// Status          : Unknown, Use with caution!

//////////////////////////////////////////////////////////////////////////////////////

//extend master_driver from uvm_driver parameterzied by master_xtn
class master_driver extends uvm_driver #(master_xtn);

// Factory Registration
 `uvm_component_utils(master_driver)

// Declare virtual interface handle with MDRV_MP  as modport
  virtual axi_if.MDRV_MP vif;

 // Declare the mcaster_agent_config handle as "ms_cfg"
   master_agent_config ms_cfg;

//Queues
  master_xtn Q1[$];
  master_xtn Q2[$];
  master_xtn Q3[$];
  master_xtn Q4[$];
  master_xtn Q5[$];
  master_xtn xtn;

  int q_id[$];
  int len[$];

    //semaphore
        semaphore write_addr_sem        = new(1);               // w_address
        semaphore write_data_sem        = new(1);               // w_data
        semaphore write_resp_sem        = new(1);
        semaphore write_sync_sem        = new();

        semaphore read_addr_sem         = new(1);
        semaphore read_data_sem         = new(1);
        semaphore read_resp_sem  = new(1);
        semaphore read_sync_sem  = new(1);
        semaphore sem = new();
        semaphore sem1=new();
        semaphore sem2=new();
        semaphore sem3=new();
        semaphore sem4=new();
   //Methods
   //Standard UVM_methods
        extern function new(string name ="master_driver",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task send_to_dut(master_xtn xtn);
        extern task write_address_channel(master_xtn xtn);
        extern task write_data_channel(master_xtn xtn);
        extern task write_response_channel(master_xtn xtn);
        extern task read_address_channel(master_xtn xtn);
        extern task read_data_channel(master_xtn xtn);
        extern function void report_phase(uvm_phase phase);
endclass


//new constructor
function master_driver::new (string name ="master_driver", uvm_component parent);
           super.new(name, parent);
endfunction : new

//build_phase
function void master_driver::build_phase(uvm_phase phase);
        // call super.build_phase(phase);
          super.build_phase(phase);
      // get the config object using uvm_config_db
          if(!uvm_config_db #(master_agent_config)::get(this,"","master_agent_config",ms_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
        endfunction


//connect_phase
function void master_driver :: connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                vif = ms_cfg.vif;
endfunction


//run() phase method
//in forever loop
//get the sequence item using seq_item_port
//call send_to_dut task
//get the next sequence item using seq_item_port

task master_driver :: run_phase(uvm_phase phase);
        forever
                begin
                $display("MASTER DRIVER");
                        seq_item_port.get_next_item(req);
                        send_to_dut(req);
                        seq_item_port.item_done();
                end
endtask

// task send_to_dut() method

// add task send_to_dut(master_xtn handles as an input argument)

task master_driver :: send_to_dut(master_xtn xtn);
//print
`uvm_info("master_driver",$sformatf("printig from driver \n %s", xtn.sprint()),UVM_LOW)
        Q1.push_back(xtn);
        Q2.push_back(xtn);
        Q3.push_back(xtn);
        Q4.push_back(xtn);
        Q5.push_back(xtn);
        xtn = master_xtn::type_id::create("xtn");
        fork
                begin


                        write_addr_sem.get(1);
        //              write_sync_sem.get(1);
                             // sem.put(1);
                                write_address_channel(Q1.pop_front());

                 //      write_data_sem.put(1); //
          //            write_sync_sem.put(1);
                        write_addr_sem.put(1);
                          sem.put(1);
                end

                begin
                        sem.get(1);
                //       write_sync_sem.get(1);
                        write_data_sem.get(1);
            //           write_sync_sem.get(1);
//                      read_data_sem.get(1);
                              // sem.get(1);
                                write_data_channel(Q2.pop_front());
//                      read_data_sem.put(1);

                        write_data_sem.put(1);
                //      write_resp_sem.put(1);
                //      write_sync_sem.put(1);
                            sem1.put(1);
                end

                begin
                        sem1.get(1); //
                        write_resp_sem.get(1);

//                      read_resp_sem.get(1);
                                write_response_channel(Q3.pop_front());
//                      read_resp_sem.put(1);
                        write_resp_sem.put(1);
                        sem2.put(1);
                end


                begin
        //              write_sync_sem.get(1);
                        sem2.get(1);
                        read_addr_sem.put(1);
                                read_address_channel(Q4.pop_front());
                        read_addr_sem.get(1);
                        sem3.put(1);
                //      write_sync_sem.put(1);
                end

                begin
                       sem3.get(1);
                        read_data_sem.put(1);
                    //                  read_sync_sem.get(1);
                                read_data_channel(Q5.pop_front());
                //      read_sync_sem.put(1);
                        read_data_sem.get(1);
                       sem4.put(1);

                end

        join_any

ms_cfg.drv_sent_cnt++;
endtask

//write_address_channel
task master_driver :: write_address_channel(master_xtn xtn);
 $display("IN write_address channel,driver");
@(vif.mdrv_cb);

                vif.mdrv_cb.awvalid<=1;
          $display("AWVALID SIGNAL");
                vif.mdrv_cb.awid <= xtn.awid;
                vif.mdrv_cb.awaddr <= xtn.awaddr;
                vif.mdrv_cb.awlen <= xtn.awlen;
                vif.mdrv_cb.awsize <= xtn.awsize;
                vif.mdrv_cb.awburst<=xtn.awburst;

                q_id.push_back(xtn.awid);

        @(vif.mdrv_cb);
                wait(vif.mdrv_cb.awready);
                vif.mdrv_cb.awvalid <= 0;

        repeat({$random}%5)
        @(vif.mdrv_cb);

endtask

//write_data_channel
task master_driver :: write_data_channel(master_xtn xtn);
int s;
s = q_id.pop_front();

        @(vif.mdrv_cb);
                repeat(xtn.WVALID_DELAY)
        @(vif.mdrv_cb);

                foreach(xtn.wdata[i])
                                begin
                                vif.mdrv_cb.wvalid<=1;
                                vif.mdrv_cb.wid <=s; //
                                vif.mdrv_cb.wstrb<=xtn.wstrb[i];
                                vif.mdrv_cb.wdata <= {xtn.wdata[i][31:24]*xtn.wstrb[i][3],
                                                      xtn.wdata[i][23:16]*xtn.wstrb[i][2],
                                                      xtn.wdata[i][15:8]*xtn.wstrb[i][1],
                                                      xtn.wdata[i][7:0]*xtn.wstrb[i][0]};

                //              vif.mdrv_cb.wdata<=xtn.wdata[i];  //
                //              vif.mdrv_cb.wstrb <= xtn.wstrb[i];

                                        if(i==xtn.awlen)       //
                                           vif.mdrv_cb.wlast <=1;
                                        else
                                           vif.mdrv_cb.wlast <=0;

                                        @(vif.mdrv_cb);
                                        wait(vif.mdrv_cb.wready)
                                        vif.mdrv_cb.wvalid<=0;
                                        vif.mdrv_cb.wdata <=0;  //
                                        repeat(2)
                                        @(vif.mdrv_cb);
                                end

endtask


//write_response_channel
task master_driver :: write_response_channel(master_xtn xtn);

        @(vif.mdrv_cb);
       //  repeat({$random}%5)@(vif.mdrv_cb); //
                repeat(xtn.BVALID_DELAY)         //
        @(vif.mdrv_cb);
                                vif.mdrv_cb.bready <=1;
                                xtn.bid = vif.mdrv_cb.bid;
                                xtn.bresp = vif.mdrv_cb.bresp;
        @(vif.mdrv_cb);
                        wait(vif.mdrv_cb.bvalid)
                                vif.mdrv_cb.bready <=0;

        @(vif.mdrv_cb);

endtask


//read_address_channel
task master_driver :: read_address_channel(master_xtn xtn);
        `uvm_info("WRITE READ_ADDR_CH",$sformatf("print from driver : %s \n",xtn.sprint),UVM_LOW)
        @(vif.mdrv_cb);
                repeat(xtn.ARVALID_DELAY);
                vif.mdrv_cb.arvalid<=1;

     // @(vif.mdrv_cb); //
                vif.mdrv_cb.arid <= xtn.arid;
                vif.mdrv_cb.araddr <= xtn.araddr;
                vif.mdrv_cb.arlen <= xtn.arlen;
                vif.mdrv_cb.arsize <= xtn.arsize;
                vif.mdrv_cb.arburst<=xtn.arburst;

        @(vif.mdrv_cb);
                wait(vif.mdrv_cb.arready)
                        vif.mdrv_cb.arvalid<=0;
                        len.push_back(xtn.arlen);
endtask


//read_data_channel
task master_driver :: read_data_channel(master_xtn xtn);
int n;
n = len.pop_front();

xtn.rdata = new[n+1];

        @(vif.mdrv_cb);
                repeat(xtn.RVALID_DELAY);
        @(vif.mdrv_cb);

        for(int i=0;i<n+1;i++)
                begin

                                                vif.mdrv_cb.rready<=1'b1;
                                                xtn.rid =       vif.mdrv_cb.rid ;
                                                xtn.rdata[i] = vif.mdrv_cb.rdata ;
                                                xtn.rresp = vif.mdrv_cb.rresp  ;
                                                xtn.rlast = vif.mdrv_cb.rlast ;
                        @(vif.mdrv_cb);
                        wait(vif.mdrv_cb.rvalid)
                                                vif.mdrv_cb.rready <=1;
                        @(vif.mdrv_cb);
                end

endtask


//UVM report_phase
function void master_driver::report_phase(uvm_phase phase);
`uvm_info("MASTER_DRIVER",$sformatf("driver send all data is %0d",ms_cfg.drv_sent_cnt),UVM_MEDIUM)
endfunction


