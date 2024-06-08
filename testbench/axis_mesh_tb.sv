`timescale 1ns / 1ps
`include "parameters.sv"

module axis_mesh_tb();

    logic clk, clk_noc, rst_n;
    integer i, j;

    // -------------------------------------
    // 100MHz Clock
    // -------------------------------------
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    // -------------------------------------
    // 100MHz Clock
    // -------------------------------------
    initial begin
        clk_noc = 0;
        forever begin
            #5 clk_noc = ~clk_noc;
        end
    end

    logic axis_in_tvalid          [ROWS][COLUMNS];
    logic axis_in_tready          [ROWS][COLUMNS];
    logic [31:0] axis_in_tdata    [ROWS][COLUMNS];
    logic axis_in_tlast           [ROWS][COLUMNS];
    logic [3:0] axis_in_tdest     [ROWS][COLUMNS];

    logic axis_out_tvalid         [ROWS][COLUMNS];
    logic axis_out_tready         [ROWS][COLUMNS];
    logic [31:0] axis_out_tdata   [ROWS][COLUMNS];
    logic axis_out_tlast          [ROWS][COLUMNS];
    logic [3:0] axis_out_tdest    [ROWS][COLUMNS];

    initial begin

        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLUMNS; j = j + 1) begin
                axis_in_tvalid  [i][j] = 1'b0;
                axis_out_tready [i][j] = 1'b1;
            end
        end

        rst_n = 1'b0;

        #(40ns);

        rst_n = 1'b1;

        #(110ns);

        // axis_in_tdest[0][0] = 4'h1;
        // axis_in_tlast[0][0] = 1'b1;
        // axis_in_tdata[0][0] = 512'h1;
        // axis_in_tvalid[0][0] = 1'b1;
        // @(negedge clk);
        // axis_in_tdest[0][0] = 4'h2;
        // @(negedge clk);
        // axis_in_tdest[0][0] = 4'h3;
        // @(negedge clk);
        // axis_in_tvalid[0][0] = 1'b0;
        // axis_in_tdest[0][1] = 4'h0;
        // axis_in_tlast[0][1] = 1'b1;
        // axis_in_tdata[0][1] = 512'h1;
        // axis_in_tvalid[0][1] = 1'b1;
        // @(negedge clk);
        // axis_in_tdest[0][1] = 4'h2;
        // @(negedge clk);
        // axis_in_tdest[0][1] = 4'h3;
        // @(negedge clk);
        // axis_in_tvalid[0][1] = 1'b0;

        #(10ns);
        axis_in_tvalid[1][0] = 1'b1;
        axis_in_tdest[1][0] = 4'h1;
        axis_in_tlast[1][0] = 1'b1;
        axis_in_tdata[1][0] = 31'h1;

        #(640ns);
    	$finish;
    end

        axis_mesh #(
        .NUM_ROWS                   (ROWS),
        .NUM_COLS                   (COLUMNS),
        .PIPELINE_LINKS             (1),

        .TDEST_WIDTH                (4),
        .TDATA_WIDTH                (32),
        .SERIALIZATION_FACTOR       (4),
        .CLKCROSS_FACTOR            (1),
        .SINGLE_CLOCK               (1),
        .SERDES_IN_BUFFER_DEPTH     (4),
        .SERDES_OUT_BUFFER_DEPTH    (4),
        .SERDES_EXTRA_SYNC_STAGES   (0),

        .FLIT_BUFFER_DEPTH          (4),
        .ROUTING_TABLE_PREFIX       ("../routing_tables/mesh_2x2/"),
        .ROUTER_PIPELINE_OUTPUT     (1),
        .DISABLE_SELFLOOP    (0),
        .ROUTER_FORCE_MLAB          (0)
    ) dut (
        .clk_noc(clk_noc),
        .clk_usr(clk),
        .rst_n,

        .axis_in_tvalid ,
        .axis_in_tready ,
        .axis_in_tdata  ,
        .axis_in_tlast  ,
        // .axis_in_tid    ,
        .axis_in_tdest  ,

        .axis_out_tvalid,
        .axis_out_tready,
        .axis_out_tdata ,
        .axis_out_tlast ,
        // .axis_out_tid   ,
        .axis_out_tdest
    );

endmodule: axis_mesh_tb
