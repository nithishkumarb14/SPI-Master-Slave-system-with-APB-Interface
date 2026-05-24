 `timescale 1ns / 1ps
    
    
    module slave
    (
    input sclk,
    input cs,
    input MOSI,
    input [7:0] tx_data,
    output logic MISO,
    output logic [7:0] rx_data,
    output  done_s
    );
    
    logic [7:0] shift_reg;
    logic [2:0] index,index_checking;
    
    logic done_sending,done_sampling;
    
    logic [2:0] count = 1'b0;
    
    
    assign done_s = done_sending && done_sampling;
    
 
    
   /* always_ff @(*) begin
        if(done_s)
            count <= 1'b0;
        
        if(cs) begin
            shift_reg <= tx_data;
           // cs |=> (shift_reg == tx_data);
            index <= 3'd7;
            index_checking <= 1'b0;
        end
                
        
   end*/
   
   
  /* always_ff @(posedge sclk) begin
        if(done_s)
            count <= 3'b000;
        
        if(count < 3'd5) begin
            shift_reg <= tx_data;
          //  cs |=> (shift_reg == tx_data);
            index <= 3'd7;
            index_checking <= 1'b0;
        end
   end*/
    
  // always_ff @(posedge sclk) begin    
        /*if(count == 1'b0) begin
            shift_reg <= tx_data;
            index <= 3'd7;
            index_checking <= 1'b0;
           // rx_data <= 8'b0;
             count <= 1'b1;
         end*/
     /*    if(count < 5 ) begin
            $display("Initializing the Shift_reg Pos \n");
            count <= count + 1'b1 ;
         end
            
         
         
          if(!cs && count >= 3'd5) begin   
            rx_data[index] <= MOSI;
            index <= index - 1'b1;
            if(index >= 3'b000)
                done_sampling <= 1'b1;
            else
                done_sampling <= 1'b0;
           
         end
    end
    */
    
    
    
always_ff @(posedge sclk) begin    
        /*if(count == 1'b0) begin
            shift_reg <= tx_data;
            index <= 3'd7;
            index_checking <= 1'b0;
           // rx_data <= 8'b0;
             count <= 1'b1;
         end*/
          if(done_s)
            count <= 3'b000;
        
        if(count < 3'd5) begin
           // shift_reg <= tx_data;
          //  cs |=> (shift_reg == tx_data);
            index <= 3'd7;
         //   index_checking <= 1'b0;
            $display("Initializing the Shift_reg Pos \n");
            count <= count + 1'b1 ;
        end

        if(!cs && count >= 3'd5) begin   
            rx_data[index] <= MOSI;
            index <= index - 1'b1;
            if(index >= 3'b000)
                done_sampling <= 1'b1;
            else
                done_sampling <= 1'b0;
           
         end
    end
    
    
    
    
    
    
    
    always_ff @(negedge sclk) begin 
        
  /*  if(count == 1'b0) begin
            shift_reg <= tx_data;
            index <= 3'd7;
            index_checking <= 1'b0;
           // rx_data <= 8'b0;
             count <= 1'b1;
         end */
      /* if(cs) begin
            //shift_reg <= tx_data;
          //  index <= 3'd0;
          index_checking <= 1'b0;
         end*/
         
       /*  if(count < 5 ) begin
            $display("Initializing the Shift_reg Neg \n");
            count <= count + 1'b1 ;
         end*/
         
         if( count <= 3'd5) begin
            shift_reg <= tx_data;
              index_checking <= 1'b0;
          end
         
        if(!cs && count >= 3'd5) begin
            MISO <= shift_reg[7];
            $display("MISO : %b \n",MISO);
           //  $display("shift_reg : %b and time is : %d\n",shift_reg,$time);
            shift_reg <= shift_reg << 1;
           
            if(index_checking <= 8'd6) begin
                index_checking <= index_checking + 1'b1;
                done_sending <= 1'b0;
             end
             
             else if(index_checking >= 3'd7) begin  
                    done_sending <= 1'b1;
                    index_checking <= 1'b0;
            end  
         end     
        
    end
        
            
    
    endmodule
