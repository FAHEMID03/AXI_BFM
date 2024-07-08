
//                              -*- Mode: system Verilog -*-
// Filename        : axi_if.sv
// Description     : AXI IF
// Author          : SK ABDUL FAHEMID
// Created On      : Mon July 08 17:40:49 2024
// Last Modified By: SK ABDUL FAHEMID
// Last Modified On: Mon July 08 17:40:49 2024
// Update Count    : 0
// Status          : Unknown, Use with caution!

///////////////////axi_if.sv///////////
`define ADDR_WIDTH 32
`define DATA_WIDTH 32
`define LENGTH 8

interface axi_if(input bit Aclock, bit Aresetn);


                //write address/control channel
                logic [3:0]awid;
                logic
  [`ADDR_WIDTH-1:0]awaddr;
                logic [`LENGTH-1:0]awlen;
                logic [2:0]awsize;
                logic [1:0]awburst;
                logic awvalid;
                logic awready;

//write data channel
                logic [3:0]wid;
                logic [`DATA_WIDTH-1:0]wdata;
                logic [3:0]wstrb;
                logic wlast;
                logic wvalid;
                logic wready;

//write response channel
                logic [3:0]bid;
                logic [1:0]bresp;
                logic bvalid;
                logic bready;

//read address/control channel
                logic [3:0]arid;
                logic [`ADDR_WIDTH-1:0]araddr;
                logic [`LENGTH-1:0]arlen;
                logic [2:0]arsize;
                logic [1:0]arburst;
                logic arvalid;
                logic arready;



//read data channel
                logic [3:0]rid;
                logic [`DATA_WIDTH-1:0]rdata;
                logic [1:0]rresp;
                logic rlast;
                logic rvalid;
                logic rready;

//--------------------master driver clocking block-----------------------

        clocking mdrv_cb @(posedge Aclock);
                        default input #1 output #1;
                        //write address channel signals
                        output awid;
                        output awaddr;
                        output awlen;
                        output awsize;
                        output awburst;
                        output awvalid;
input awready;


//write data channel signals
                        output wid;
                        output wdata;
                        output wstrb;
                        output wlast;
                        output wvalid;
input wready;


//write response channel signals
                        input bid;
                        input bresp;
                        input bvalid;
output bready;


//read address/control channel
                        output arid;
                        output araddr;
                        output arlen;
                        output arsize;
                        output arburst;
                        output arvalid;
input arready;



//read data channel
                        input rid;
                        input rdata;
                        input rresp;
                        input rlast;
                        input rvalid;

                        output rready;

        endclocking



//-------------------master monitor clocking block----------------------

        clocking mmon_cb @(posedge Aclock);
                        default input #1 output #1;
                        //write address channel signals
                        input awid;
                        input awaddr;
                        input awlen;
                        input awsize;
                        input awburst;
                        input awvalid;
                        input awready;
                        //write data channel signals
                        input wid;
                        input wdata;
                        input wstrb;
                        input wlast;
                        input wvalid;
                        input wready;
                        //write response channel signals
                        input bid;
                        input bresp;
                        input bvalid;
                        input bready;
                        //read address/control channel
                        input arid;
                        input araddr;
                        input arlen;
                        input arsize;
                        input arburst;
                        input arvalid;
                        input arready;
                        //read data channel
                        input rid;
                        input rdata;
                        input rresp;
                        input rlast;
                        input rvalid;
                        input rready;

        endclocking



//----------------------slave driver clocking block-----------------------

        clocking sdrv_cb @(posedge Aclock);
                        default input #1 output #1;
                        //write address channel signals
                        input awid;
                        input awaddr;
                        input awlen;
                        input awsize;
                        input awburst;
                        input awvalid;

                        output awready;
                        //write data channel signals
                        input wid;
                        input wdata;
                        input wstrb;
                        input wlast;
                        input wvalid;

                        output wready;
                        //write response channel signals
                        output bid;
                        output bresp;
                        output bvalid;

                        input bready;
                        //read address/control channel
                        input arid;
                        input araddr;
                        input arlen;
                        input arsize;
                        input arburst;
                        input arvalid;

                        output arready;
                        //read data channel
                        output rid;
                        output rdata;
                        output rresp;
                        output rlast;
                        output rvalid;

                        input rready;

        endclocking

//--------------------slave monitor clocking block------------------------

        clocking smon_cb @(posedge Aclock);
                        default input #1 output #1;
                        //write address channel signals
                        input awid;
                        input awaddr;
                        input awlen;
                        input awsize;
                        input awburst;
                        input awvalid;
                        input awready;
                        //write data channel signals
                        input wid;
                        input wdata;
                        input wstrb;
                        input wlast;
                        input wvalid;
                        input wready;
                        //write response channel signals
                        input bid;
                        input bresp;
                        input bvalid;
                        input bready;
                        //read address/control channel
                        input arid;
                        input araddr;
                        input arlen;
                        input arsize;
                        input arburst;
                        input arvalid;
                        input arready;
                        //read data channel
                        input rid;
                        input rdata;
                        input rresp;
                        input rlast;
                        input rvalid;
                        input rready;

        endclocking


        modport MDRV_MP(clocking mdrv_cb);
        modport MMON_MP(clocking mmon_cb);
        modport SDRV_MP(clocking sdrv_cb);
        modport SMON_MP(clocking smon_cb);

endinterface
