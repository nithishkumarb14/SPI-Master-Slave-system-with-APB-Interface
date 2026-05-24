`timescale 1ns / 1ps


module spi_master(
input clk,
input reset,
input start,
input MISO,
input [7:0] tx_data,
output logic sclk,
output logic cs,
output logic MOSI,
output logic [7:0] rx_data,
output logic done
);

logic [6:0] counter;

always_comb begin
    if(curr_state == DONE)
         done = 1'b1;
     else 
         done = 1'b0;
 end

typedef enum logic [1:0] {
    IDLE = 2'b00,
    TRANSFER = 2'b01,
    DONE = 2'b10
} state_t;

state_t curr_state;

logic [7:0] shift_reg;

logic [2:0] count_sync;

logic signed [3:0] index;

always_ff @(posedge clk) begin
    if(!reset) begin
        sclk <= 1'b0;
        cs <= 1'b1;
        MOSI <= 1'b0;
        curr_state <= IDLE;
        rx_data <= 8'b0;
        counter <= 7'b0;
        index <= 4'd7;
        sclk <= 1'b0;
        shift_reg <= 8'b0;
        count_sync <= 3'b000;

     end 
     
     else begin
        case(curr_state)
            IDLE : begin
                if(start) begin
                   shift_reg <= tx_data;
                    curr_state <= TRANSFER;
                    cs <= 1'b0;
                    index <= 4'd7;
                    counter <= 7'd0;
                    sclk <= 1'b0;
                   MOSI <= shift_reg[7];
                   shift_reg <= shift_reg << 1;
                    count_sync <= 3'd0;
                 end
                 else begin
                    curr_state <= IDLE;
                    cs <= 1'b1;
                    MOSI <= 1'b0;
                    index <= 4'd7;
                    counter <= 7'd0;
                     shift_reg <= tx_data;
                     sclk <= 1'b0;

                 end
             end
             
             TRANSFER : begin
                if(counter == 7'd99) begin
                    counter <= 7'b0;
                    sclk <= ~sclk;
                end
                else begin
                    counter <= counter + 1'b1;
                 end
                 
                if(sclk == 1 && counter == 7'd99 && count_sync < 3'd5) begin
                    count_sync <= count_sync + 1'b1;
                  /// shift_reg <= tx_data;
                    // MOSI <= shift_reg[7];
                 end
                    
                 /*  if(sclk == 0 && counter == 7'd99 && count_sync < 3'd5)
                    count_sync <= count_sync + 1'b1; */
                  
                 
                 if(sclk == 1 && counter == 7'd99 && count_sync >=3'd5) begin //sclk going to low . It modify the data of the master
                     MOSI <=  shift_reg[7];
                     shift_reg <= shift_reg << 1;
                 end
                   
                if(sclk == 0 && counter == 7'd99 && count_sync >=3'd5) begin // sclk going to rise . It Samples the slave data
                    if(index >= 4'b0) begin
                        rx_data[index] <= MISO;
                        index <= index - 1'b1;
                        $display("Data Receiving : %b , Rx_data_m : %b and time is : %d\n",MISO,rx_data,$time);
                     end
                      if(index == 4'b0000) begin
                        curr_state <= DONE;
                        index <= 4'sd7;
                     end
                        
                end  
             end    
             
             DONE : begin
                cs <= 1'b1;
                MOSI <= 1'b0;
                index <= 4'd7;
                curr_state <= IDLE;
                count_sync <= 3'd0;
             end
             
             default : curr_state <= IDLE;
              
       endcase
       end
     
end

endmodule
