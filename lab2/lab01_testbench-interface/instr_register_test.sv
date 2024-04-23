/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/
// test genereaza
module instr_register_test
  import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
  (input  logic          clk,
   output logic          load_en,
   output logic          reset_n,
   output operand_t      operand_a,
   output operand_t      operand_b,
   output opcode_t       opcode,
   output address_t      write_pointer,
   output address_t      read_pointer,
   input  instruction_t  instruction_word
  );

  timeunit 1ns/1ns; 

  int file_descriptor;
  parameter WR_NR = 20;
  parameter RD_NR = 20;
  parameter SEED_VALUE; 
  int seed_val = SEED_VALUE; // 
  instruction_t  iw_reg_test [31:0];
  instruction_t instruction_word_test;
  result_t local_result = 0;
  static int temp = 0;    // variabila de tip static -> la a 2-a chemare aloca doar a
  int not_passed_tests = 0;
  

  parameter READ_ORDER = 0; // ordinea incremental decremental random
  parameter WRITE_ORDER = 0; // incremental decremental random
  parameter TEST_NAME ="";
   //logic local_result[31:0]; // Moved declaration above the loop

  
  initial begin
    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");

    $display("\nReseting the instruction register...");
    write_pointer  = 5'h00;         // initialize write pointer
    read_pointer   = 5'h1F;         // initialize read pointer
    load_en        = 1'b0;          // initialize load control line
    reset_n       <= 1'b0;          // assert reset_n (active low)
    repeat (2) @(posedge clk) ;     // hold in reset for 2 clock cycles
    reset_n        = 1'b1;          // deassert reset_n (active low)

  
      if (WRITE_ORDER == 0) begin  // definim de unde pleaca temp, aici pleaca de la 0
        temp = 0;
      end else if (WRITE_ORDER == 1) begin
        temp = 31;
      end
    

      $display("\nWriting values to register stack...");
 
    repeat (WR_NR) begin
      
      @(posedge clk) randomize_transaction;             // aici a fost bug, mai intai se dadea load si dupa datele
        load_en = 1'b1;  // enable writing to register
      @(negedge clk) print_transaction;     
    end
    @(posedge clk) load_en = 1'b0;  // turn-off writing to register | load enable in 0

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    for (int i=0; i<RD_NR; i++) begin

      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back

      if (READ_ORDER == 0) begin         // read_order incremental
        read_pointer = i;
      end else if (READ_ORDER == 1) begin
        read_pointer = RD_NR - i;     // read order decremental
      end else begin
        read_pointer = $unsigned($random(seed_val))%32;   // read order random
      end

   // @(posedge clk) read_pointer = i;  
      @(negedge clk) print_results;
      @(posedge clk) check_result;
    end
  
   
    $display("\n***********************************************************");
    $display(  "***  THIS IS A SELF-CHECKING TESTBENCH (YET).  YOU  *******");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");


    
    final_report;  //apelam functia final_report
    not_passed_tests = 0;
    @(posedge clk) ;
    $finish;

  end


  function final_report;

  file_descriptor = $fopen("../reports/regression_transcript/regression_status.txt", "a");
     if (file_descriptor != 0) begin

       if (not_passed_tests != 0) begin
        $fwrite(file_descriptor, "\n**\n");
        $fwrite(file_descriptor, "**                         STATISTICS                      \n");
        $fwrite(file_descriptor, "               TEST NAME: %s                      \n", TEST_NAME);
        $fwrite(file_descriptor, "               READ_ORDER = %0d ,  WRITE_ORDER = %0d    \n",READ_ORDER, WRITE_ORDER);
        $fwrite(file_descriptor, "               TESTS FAILED = %0d  TOTAL TESTS =  %0d   \n",not_passed_tests, (RD_NR));
        $fwrite(file_descriptor, "               STATUS: FAILED                            \n\n");
        $fwrite(file_descriptor, "**\n\n");

       end else begin
        $fwrite(file_descriptor, "\n**\n");
        $fwrite(file_descriptor, "**                          STATISTICS                       \n");
        $fwrite(file_descriptor, "               TEST NAME: %s                      \n", TEST_NAME);
        $fwrite(file_descriptor, "               READ_ORDER = %0d ,  WRITE_ORDER = %0d    \n",READ_ORDER, WRITE_ORDER);
        $fwrite(file_descriptor, "               TESTS FAILED = %0d  TOTAL TESTS =  %0d   *\n",not_passed_tests, (RD_NR));
        $fwrite(file_descriptor, "               STATUS :  PASSED                       \n\n");
        $fwrite(file_descriptor, "**\n\n");

       end
     end
   endfunction: final_report

  function void randomize_transaction;
  // trebuie sa salvam valorile generate
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //

    if (WRITE_ORDER == 0) begin           
          write_pointer = temp++;         // cazul incremental
      end else if (WRITE_ORDER == 1) begin
        write_pointer = temp--;         // cazul decremental
      end else begin
        write_pointer = $unsigned($random(seed_val))%32; //cazul random
      end
  

    operand_a     = $random(seed_val)%16;                 // between -15 and 15
    operand_b    = $unsigned($random(seed_val))%16;            // between 0 and 15
    opcode        = opcode_t'($unsigned($random(seed_val))%9);  // between 0 and 7, cast to opcode_t type | mai face un cast
    // write_pointer = $unsigned(random)
    iw_reg_test[write_pointer] = '{opcode, operand_a, operand_b, 4'b0};
    
  endfunction: randomize_transaction
// ramdomize genereaza un nr pe 32 de biti

  function void print_transaction;
    $display("Writing to register location %0d: ", write_pointer);
    $display("  opcode = %0d (%s)", opcode, opcode.name);
    $display("  operand_a = %0d",   operand_a);
    $display("  operand_b = %0d\n", operand_b);
  endfunction: print_transaction

   function void print_results;
    $display("Read from register location %0d: ", read_pointer);
    $display("  opcode = %0d (%s)", instruction_word.opc, instruction_word.opc.name);
    $display("  operand_a = %0d",   instruction_word.operand_a);
    $display("  operand_b = %0d\n", instruction_word.operand_b);
    $display("  rezultat = %0d\n", instruction_word.rezultat);
  endfunction: print_results

function void check_result; 

    instruction_word_test = iw_reg_test[read_pointer]; // ia valoarea din iw_reg_test la read_pointer

    if(instruction_word_test.operand_a === 'hxx) begin 
                  // daca operand a are val nedeterminata se opreste check result
          return;
      end

    if(instruction_word_test.operand_a !== instruction_word.operand_a)begin
      $display("operand a diferit cu ce s-a generat");
      $display("read_pointer = %0d", read_pointer);
      $display("operand_a = %0d, operand_a = %0d", instruction_word_test.operand_a, instruction_word.operand_a);
    end

    if(instruction_word_test.operand_b !== instruction_word.operand_b)begin
      $display("operand b diferit cu ce s-a generat");
       $display("read_pointer = %0d", read_pointer);
      $display("operand_b = %0d, operand_b = %0d", instruction_word_test.operand_b, instruction_word.operand_b);
    end
    
     $display("operand_a = %0d", instruction_word_test.operand_a);
    $display("operand_b = %0d", instruction_word_test.operand_b);
   $display("opcode = %0d (%s)", opcode , opcode.name);

    case(instruction_word_test.opc)
        ZERO: local_result = 0;
        PASSA: local_result = instruction_word_test.operand_a;
        PASSB: local_result = instruction_word_test.operand_b;
        ADD: local_result = instruction_word_test.operand_a + instruction_word_test.operand_b;
        SUB: local_result = instruction_word_test.operand_a - instruction_word_test.operand_b;
        MULT: local_result = instruction_word_test.operand_a * instruction_word_test.operand_b;
        DIV: if(instruction_word_test.operand_b === 0) local_result = 0; 
        else local_result = instruction_word_test.operand_a / instruction_word_test.operand_b;
        MOD: if(instruction_word_test.operand_b === 0) local_result = 0; 
        else local_result = instruction_word_test.operand_a % instruction_word_test.operand_b;
        POW: if(instruction_word_test.operand_b === 0) local_result = 1; 
        else local_result = instruction_word_test.operand_a ** instruction_word_test.operand_b;

      endcase 

  if(local_result === instruction_word.rezultat) begin
    $display("Rezultate asemanatoare");
    $display("Rezultatul calculat: %0d", instruction_word.rezultat);
    $display("Rezultatul stocat: %0d", local_result);

  end else begin
    
    not_passed_tests = not_passed_tests + 1;
     $display("Rezultate NEASEMANATOARE");
     $display("read_pointer = %0d",read_pointer);
     $display("op_a = %0d", instruction_word.operand_a);
     $display("op_b = %0d", instruction_word.operand_b);
    $display("Rezultatul calculat: %0d", instruction_word.rezultat);
    $display("rezultatul stocat : %0d ", local_result);

  end // Close the loop

endfunction


endmodule: instr_register_test
