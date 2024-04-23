
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
 input  address_t      write_pointer,
 input  address_t      read_pointer,
 output instruction_t  instruction_word
);
  timeunit 1ns/1ns;  // set the time and precision

  instruction_t  iw_reg [0:31];  // an array of instruction_word structures
  operand_t operand_rezultat;   

  // write to the register
  always@(posedge clk, negedge reset_n)   // write into register
    if (!reset_n) begin
      foreach (iw_reg[i])  // loop through each element in the reg array
        iw_reg[i] = '{opc:ZERO,default:0};  // reset to all zeros -  initialize all entries to zero
    end
    else if (load_en) begin  // if load_en is 1, allow writing to the register
      // Debug statements displaying the current operation
      $display("FROM DUT:");
      $display("operand_a  = %0d", operand_a);
      $display("operand_b  = %0d", operand_b);
      $display("opcode  = %0d (%s)", opcode, opcode.name);

      case (opcode)
        ZERO: iw_reg[write_pointer] = '{opcode,operand_a,operand_b,0};
        PASSA: iw_reg[write_pointer] = '{opcode,operand_a,operand_b,operand_a};
        PASSB: iw_reg[write_pointer] = '{opcode,operand_a,operand_b,operand_b};
        ADD: iw_reg[write_pointer] = '{opcode,operand_a,operand_b,operand_a + operand_b};
        SUB: iw_reg[write_pointer] = '{opcode,operand_a,operand_b,operand_a - operand_b};
        MULT: iw_reg[write_pointer] = '{opcode,operand_a,operand_b,operand_a * operand_b};  
        DIV:  if(operand_b == 0) iw_reg[write_pointer] = '{opcode,operand_a,operand_b, 0}; else  iw_reg[write_pointer] = '{opcode,operand_a,operand_b, operand_a / operand_b};
        MOD:  if(operand_b == 0) iw_reg[write_pointer] = '{opcode,operand_a,operand_b, 0}; else  iw_reg[write_pointer] = '{opcode,operand_a,operand_b, operand_a % operand_b};
        POW: iw_reg[write_pointer] = '{opcode, operand_a, operand_b, operand_a ** operand_b};
        default:iw_reg[write_pointer] = '{opcode,operand_a,operand_b,'bx};  // handles any undefined opcode -> setting the result to an unknown state
      endcase
      // iw_reg[write_pointer] = '{opcode,operand_a,operand_b,operand_rezultat};
      $display("WRITE_POINTER=%0d",write_pointer);
      $display("rezultat  = %0d", iw_reg[write_pointer].rezultat);
    end

  // read from the register
  assign instruction_word = iw_reg[read_pointer];  // continuously read from register

// compile with +define+FORCE_LOAD_ERROR to inject a functional bug for verification to catch
`ifdef FORCE_LOAD_ERROR
initial begin
  force operand_b = operand_a; // cause wrong value to be loaded into operand_b
end
`endif

  
  
  
endmodule: instr_register