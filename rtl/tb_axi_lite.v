`timescale 1ns/1ps

module tb_axi_lite;

    reg ACLK;
    reg ARESETN;

    reg [3:0] AWADDR;
    reg AWVALID;
    wire AWREADY;

    reg [31:0] WDATA;
    reg WVALID;
    wire WREADY;

    wire [1:0] BRESP;
    wire BVALID;
    reg BREADY;

    reg [3:0] ARADDR;
    reg ARVALID;
    wire ARREADY;

    wire [31:0] RDATA;
    wire [1:0] RRESP;
    wire RVALID;
    reg RREADY;

    reg [31:0] expected_data;

    // DUT
    axi_lite_slave uut (
        .ACLK(ACLK),
        .ARESETN(ARESETN),

        .AWADDR(AWADDR),
        .AWVALID(AWVALID),
        .AWREADY(AWREADY),

        .WDATA(WDATA),
        .WVALID(WVALID),
        .WREADY(WREADY),

        .BRESP(BRESP),
        .BVALID(BVALID),
        .BREADY(BREADY),

        .ARADDR(ARADDR),
        .ARVALID(ARVALID),
        .ARREADY(ARREADY),

        .RDATA(RDATA),
        .RRESP(RRESP),
        .RVALID(RVALID),
        .RREADY(RREADY)
    );

    // Clock
    initial begin
        ACLK = 0;
        forever #5 ACLK = ~ACLK;
    end

    // Reset
    initial begin
        ARESETN = 0;
        #20;
        ARESETN = 1;
    end

    // Init
    initial begin
        AWADDR = 0; AWVALID = 0;
        WDATA  = 0; WVALID  = 0;
        BREADY = 1;

        ARADDR = 0; ARVALID = 0;
        RREADY = 1;
    end

    // WRITE TASK
    task axi_write;
        input [3:0] addr;
        input [31:0] data;
        begin
            @(posedge ACLK);
            AWADDR  <= addr;
            AWVALID <= 1;
            WDATA   <= data;
            WVALID  <= 1;

            wait (AWREADY && WREADY);

            @(posedge ACLK);
            AWVALID <= 0;
            WVALID  <= 0;

            expected_data = data;

            wait (BVALID);
            @(posedge ACLK);
        end
    endtask

    // READ TASK
    task axi_read;
        input [3:0] addr;
        begin
            @(posedge ACLK);
            ARADDR  <= addr;
            ARVALID <= 1;

            wait (ARREADY);
            @(posedge ACLK);
            ARVALID <= 0;

            wait (RVALID);
            @(posedge ACLK);

            if (RDATA == expected_data)
                $display("PASS: addr=%h data=%h", addr, RDATA);
            else
                $display("FAIL: addr=%h expected=%h got=%h", addr, expected_data, RDATA);
        end
    endtask

    // TEST CASES
    initial begin
        #30;

        $display("---- BASIC TEST ----");
        axi_write(4'h0, 32'hDEADBEEF);
        axi_read(4'h0);

        #20;

        $display("---- MULTI REGISTER ----");
        axi_write(4'h4, 32'h12345678);
        axi_read(4'h4);

        #20;

        $display("---- BACK TO BACK ----");
        axi_write(4'h0, 32'h11111111);
        axi_write(4'h0, 32'h22222222);
        axi_read(4'h0);

        #20;

        $display("---- RANDOM TEST ----");
        axi_write(4'h8, $random);
        axi_read(4'h8);

        #50;

        $display("ALL TESTS DONE");
        $finish;
    end

endmodule
