`timescale 1ns / 1ps

module cpu;
logic clk;
logic reset_n;
logic [31:0] PADDR;
logic [31:0] PWDATA;
logic PSEL;
logic PENABLE,PWRITE;
logic  PREADY;
//logic [7:0] data_out_master,data_out_slave;
logic [31:0] PRDATA;
logic start_w;
logic [7:0] data_in_m,data_in_s_1;

logic MISO;
logic sclk;
logic cs;
logic [7:0] rx_data_m,rx_data_s_1;
logic MOSI;
logic done_m,done_s;


spi_wrapper sw(clk,reset_n,PADDR,PWDATA,PSEL,PENABLE,PWRITE,PREADY,rx_data_m,rx_data_s_1,done_m,PRDATA,start_w,data_in_m,data_in_s_1);
 spi_master sm(clk,reset_n,start_w,MISO,data_in_m,sclk,cs,MOSI,rx_data_m,done_m);
 slave s_1(sclk,cs,MOSI,data_in_s_1,MISO,rx_data_s_1,done_s);

logic [7:0] cpu_read_1,cpu_read_2;

initial begin
    {clk,reset_n,PADDR,PWDATA,PSEL,PENABLE,PWRITE,PRDATA,start_w,data_in_m,data_in_s_1} = 0;
 end
 
 
 always #5 clk = ~clk;
 
 
 initial begin 
    @(negedge clk) 
    reset_n = 0;
    
     @(negedge clk) 
    reset_n = 1;
    
    @(negedge clk) 
    PADDR =32'd02;
    PWRITE = 1'b1;
    PWDATA = 32'd05;
    PSEL = 1'b1;
    PENABLE = 1'b1;
    PREADY = 1'b1;
    
    @(negedge clk) 
    PADDR =32'd03;
    PWRITE = 1'b1;
    PWDATA = 32'd06;
    PSEL = 1'b1;
    PENABLE = 1'b1;
    PREADY = 1'b1;
    
    @(negedge clk) 
    PADDR =32'd01;
    PWRITE = 1'b1;
    PWDATA = 32'd01;
    PSEL = 1'b1;
    PENABLE = 1'b1;
    PREADY = 1'b1;
    
  

    
    @(negedge clk) 
    PADDR =32'd01;
    PWRITE = 1'b0;
    PWDATA = 32'd01;
    PSEL = 1'b1;
    PENABLE = 1'b1;
    PREADY = 1'b1;
    
     @(negedge clk)   // ← Release bus immediately after
PSEL    = 1'b0;
PENABLE = 1'b0;
PWRITE  = 1'b0;
    
   // #600000;
    while(done_m != 1'b1 || done_s != 1'b1) begin
      @(negedge clk);
        $display("Running");
    end
    
    @(negedge clk) 
    PADDR =32'd04;
    PWRITE = 1'b0;
    PSEL = 1'b1;
    PENABLE = 1'b1;
    PREADY = 1'b1;
    
    
     @(negedge clk)
    cpu_read_1 = PRDATA;
    
    @(negedge clk) 
    PADDR =32'd05;
    PWRITE = 1'b0;
    PSEL = 1'b1;
    PENABLE = 1'b1;
    PREADY = 1'b1;
    
    @(negedge clk)
    cpu_read_2 = PRDATA;
    
    
    repeat(2)  @(negedge clk);
    
   //  #600000;
    

end
endmodule




/*logic clk = 1'b0;
logic reset = 1'b1;
logic start = 1'b0;
logic MISO;
logic [7:0] tx_data;
logic [7:0] tx_data_slave;
logic sclk;
logic cs;
logic MOSI;
logic [7:0] rx_data_master,rx_data_slave;

spi_master master(clk,reset,start,MISO,tx_data,sclk,cs,MOSI,rx_data_master);
slave_1 s1(sclk,reset,cs,MOSI,tx_data_slave,MISO,rx_data_slave);


initial begin
    forever begin
        #5 clk = ~clk;
     end
end

initial begin
    @(negedge clk)
    reset = 1'b0;
    tx_data = 8'b1010_0001;
    tx_data_slave = 8'b1000_1010;
    
    @(negedge clk)
    reset = 1'b1;
    start = 1'b0;
    
    @(negedge clk)
    start = 1'b1;
    
    
    @(negedge clk)
    start = 1'b0;
  
    
   #60000;
 end
    

endmodule
*/


