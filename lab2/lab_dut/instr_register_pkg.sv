/***********************************************************************
 * A SystemVerilog RTL model of an instruction regisgter:
 * User-defined type definitions
 **********************************************************************/
package instr_register_pkg;
  timeunit 1ns/1ns;

  typedef enum logic [3:0] {  // se defineste un tip de data  
  	ZERO,
    PASSA,
    PASSB,
    ADD,                           // operatii matematicec
    SUB,
    MULT,
    DIV,
    MOD
  } opcode_t;

  typedef logic signed [31:0] operand_t;   //signed -> cu semn 32 de biti
  typedef logic signed [61:0] result_t;
  typedef logic [4:0] address_t;  // poate sa ia 2^5 valori
  
  typedef struct {   
    opcode_t  opc;  // operanzi
    operand_t operand_a;
    operand_t operand_b;
    result_t rezultat;
  } instruction_t;

endpackage: instr_register_pkg
