/***********************************************************************
 * A SystemVerilog RTL model of an instruction regisgter
 *
 * An error can be injected into the design by invoking compilation with
 * the option:  +define+FORCE_LOAD_ERROR
 *
 **********************************************************************/

module instr_register
import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
(input  logic          clk,
 input  logic          load_en,
 input  logic          reset_n,
 input  operand_t      operand_a,
 input  operand_t      operand_b,
 input  opcode_t       opcode,
 input  address_t      write_pointer,     // se declara semnalele
 input  address_t      read_pointer,
 output instruction_t  instruction_word
);
  timeunit 1ns/1ns;

  instruction_t  iw_reg [0:31];  // an array of instruction_word structures
  result_t result;
  result_t op_result;
  // iw_reg e array -> de 32 de locatii
 // write to the register
  always@(posedge clk, negedge reset_n)   // write into register
    if (!reset_n) begin
      foreach (iw_reg[i])  //foreach-> pentru fiecare elem din arrray
        iw_reg[i] = '{opc:ZERO,default:0};  // reset to all zeros
    end
    else if (load_en) begin //putem incarca date in registru
      iw_reg[write_pointer] = '{opcode,operand_a,operand_b, result}; // write pointer poate lua val intre 0 si 31
    end

  // read from the register
  assign instruction_word = iw_reg[read_pointer];  // continuously read from register
  // la un semnal de output ii asignam o valoare in functie de read pointer si punem pe output

// compile with +define+FORCE_LOAD_ERROR to inject a functional bug for verification to catch
`ifdef FORCE_LOAD_ERROR
initial begin
  force operand_b = operand_a; // cause wrong value to be loaded into operand_b
end
`endif

  always @(posedge clk , negedge reset_n)
    case (opcode)
    ZERO: op_result = 32'sd0;
    PASSA: op_result = operand_a;
    PASSB: op_result = operand_b;
    ADD: op_result = operand_a + operand_b;
    SUB: op_result = operand_a - operand_b;
    MULT: op_result = operand_a * operand_b;
    DIV: op_result = operand_a / operand_b;
    MOD: op_result = operand_a % operand_b;
    default: op_result = 'bx;
  endcase

endmodule: instr_register
