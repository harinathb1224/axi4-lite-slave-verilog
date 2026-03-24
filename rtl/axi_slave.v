module axi_lite_slave (
    input wire ACLK,
    input wire ARESETN,

    input wire [3:0] AWADDR,
    input wire AWVALID,
    output reg AWREADY,

    input wire [31:0] WDATA,
    input wire WVALID,
    output reg WREADY,

    output reg [1:0] BRESP,
    output reg BVALID,
    input wire BREADY,

    input wire [3:0] ARADDR,
    input wire ARVALID,
    output reg ARREADY,

    output reg [31:0] RDATA,
    output reg [1:0] RRESP,
    output reg RVALID,
    input wire RREADY
);

    reg [31:0] reg0, reg1, reg2, reg3;

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            AWREADY <= 0;
            WREADY  <= 0;
            BVALID  <= 0;
            BRESP   <= 0;

            ARREADY <= 0;
            RVALID  <= 0;
            RRESP   <= 0;

            reg0 <= 0;
            reg1 <= 0;
            reg2 <= 0;
            reg3 <= 0;
        end
        else begin
            // Write Address
            AWREADY <= (AWVALID) ? 1 : 0;

            // Write Data
            WREADY <= (WVALID) ? 1 : 0;

            // Write Operation
            if (AWVALID && WVALID) begin
                case (AWADDR[3:2])
                    2'b00: reg0 <= WDATA;
                    2'b01: reg1 <= WDATA;
                    2'b10: reg2 <= WDATA;
                    2'b11: reg3 <= WDATA;
                endcase
                BVALID <= 1;
                BRESP  <= 2'b00;
            end
            else if (BREADY) begin
                BVALID <= 0;
            end

            // Read Address
            ARREADY <= (ARVALID) ? 1 : 0;

            // Read Operation
            if (ARVALID) begin
                case (ARADDR[3:2])
                    2'b00: RDATA <= reg0;
                    2'b01: RDATA <= reg1;
                    2'b10: RDATA <= reg2;
                    2'b11: RDATA <= reg3;
                endcase
                RVALID <= 1;
                RRESP  <= 2'b00;
            end
            else if (RREADY) begin
                RVALID <= 0;
            end
        end
    end

endmodule
