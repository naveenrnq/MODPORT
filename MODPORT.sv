// Code your testbench here
// or browse Examples
interface add_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] sum;
  logic clk;

  modport DRV (output a,b, input sum,clk); // Clock is an input for driver
endinterface
 
 
class driver;
  
  virtual add_if.DRV aif;  // Getting access to interface
  // remember paraenthesis () is only required in testbench
//at the time of declaration .DRV
  
  task run();
    // We know driver waits for mailbox and then takes out data from mailbox we are trying to do the same
    forever begin
      @(posedge aif.clk);  // as soon as clk arrives
      aif.a <= 3;
      aif.b <= 3;
      $display("[DRV] : Interface Trigger");
    end
  endtask
  
  
endclass
 
 
 
module tb;
  
  add_if aif();
  driver drv;
  
  add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));
 
 
  initial begin
    aif.clk <= 0;  // For triggering interface always use non-blocking
  end
  
  always #10 aif.clk <= ~aif.clk;
 
   initial begin
     drv = new();
     drv.aif = aif;
     drv.run();
     
   end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;  
    #100;
    $finish();
  end
  
endmodule
