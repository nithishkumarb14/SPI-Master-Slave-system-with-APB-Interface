`timescale 1ns / 1ps

module spi_wrapper(
input clk,
input reset_n,
input [31:0] PADDR,
input [31:0] PWDATA,
input PSEL,
input PENABLE,
input PWRITE,
input  PREADY,
input [7:0] data_out_master,data_out_slave,
input done,
output logic [31:0] PRDATA,
output logic start_w,
output logic [7:0] data_in_m,data_in_s_1
);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        PRDATA <= 32'b0;
        data_in_m <= 8'b0;
        start_w <= 1'b0;
        data_in_s_1 <= 8'b0;
     end
     
     else begin
     if(done)
         start_w <= 1'b0;
        
        if(PENABLE && PSEL && PREADY) begin
            if(PWRITE) begin
                if(PADDR == 32'd01) 
                    start_w <= PWDATA[0];
                else if(PADDR == 32'd02)
                    data_in_m <= PWDATA[7:0];
                 else if(PADDR == 32'd03)
                    data_in_s_1 <= PWDATA[7:0];
             end
            else begin
             if(!PWRITE) begin 
                 if(PADDR == 32'd04)
                    PRDATA <= data_out_master;
                 else if(PADDR == 32'd05)
                    PRDATA <= data_out_slave;
            end
       end
   end
  end
end
endmodule
