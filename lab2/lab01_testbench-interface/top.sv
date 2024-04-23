/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 **********************************************************************/

module top;
  timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // clock variables
  logic clk;          // logic - se determina automat daca e wire sau reg
  logic test_clk;    // separate clk for testbench

  // interconnecting signals
  logic          load_en;   // load_en signal to control when data si written to dut
  logic          reset_n;  // reset activ in 0
  opcode_t       opcode;  // tip de date facut de user
  operand_t      operand_a, operand_b;
  address_t      write_pointer, read_pointer;
  instruction_t  instruction_word;

  // instantiate testbench and connect ports
  instr_register_test test (   // test e instanta (instanta->obiect)
    .clk(test_clk), 
    .load_en(load_en),
    .reset_n(reset_n),
    .operand_a(operand_a),
    .operand_b(operand_b),
    .opcode(opcode),
    .write_pointer(write_pointer),
    .read_pointer(read_pointer),
    .instruction_word(instruction_word)
   );

  // instantiate design and connect ports
  instr_register dut (
    .clk(clk),
    .load_en(load_en),
    .reset_n(reset_n),
    .operand_a(operand_a),
    .operand_b(operand_b),
    .opcode(opcode),
    .write_pointer(write_pointer),
    .read_pointer(read_pointer),
    .instruction_word(instruction_word)
   );

  // clock oscillators / clock generation for DUT
  initial begin   // structura/cuvant cheie
    clk <= 0;
    forever #5  clk = ~clk; // asteapta 5 ns - neaga clock ul, sta in 1 5ns si asa mai departe
    // perioada 10, factor de ump 50%
  end

  // clk generation for tb with a phase offset
  initial begin
    test_clk <=0;
    // offset test_clk edges from clk to prevent races between
    // the testbench and the design
    #4 forever begin   // astepta 4ns - se executa o singura data pt ca e inainte de forever
      #2ns test_clk = 1'b1;   // test_clk in high for 2 ns
      #8ns test_clk = 1'b0;   // test_clk in low for 8ns  
      //80% factor de umplere, perioada 10 (8+2)
    end
  end

endmodule: top
