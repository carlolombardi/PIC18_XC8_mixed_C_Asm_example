#include <xc.inc>

        
    ; LOCAL DATA DECLARATIONS
    ; local banked data (in BANK1) 
    PSECT data_section_name,class=BANK1,space=1
    var1: DS 1;	One byte var
    var2: DS 2;	Two bytes var
    
    
    ; LOCAL DATA DECLARATIONS
    ; local data access area
    PSECT data_section_name2,class=COMRAM,space=1
    var3: DS 1;	One byte var in the acces area
 
    
    
    ; function example with one 8 bit parameter in input and output
    ; unsigned char asm_function(unsigned char par1);
    ; par1 is passed using WREG
    ; function result is returned using WREG
    
    GLOBAL _asm_function; To make the asm fuction visible to the C modules or other asm files
    PSECT code_section_name,class=CODE,reloc=2, delta=1
 

 _asm_function:   
    movwf   var3,a
    banksel(var1)
    movwf   BANKMASK(var1),b
    addlw   5
    return   
    
    
    
    ; function example with one 16 bit parameter in input and output
    ; unsigned short _asm_function_int(unsigned short par2);
    ; par2 is passed using the compiled stack (?_asm_function_int and ?_asm_function_int+1)
    ; function result is returned using the compiled stack (?_asm_function_int and ?_asm_function_int+1
    
    
GLOBAL ?_asm_function_int; // To use the compiled stack to pass parameters bigger tham 1 byte   

GLOBAL _asm_function_int; To make the asm fuction visible to the C modules or other asm files       
 

_asm_function_int:   
    ; Reads parameters passed in the compiled stack
    movf    ?_asm_function_int,w,a
    banksel(var1)
    movwf   BANKMASK(var1),b
    movf    ?_asm_function_int+1,w,a
    banksel(var2)
    movwf   BANKMASK(var2),b
    
    ; Write results in the compiled stack to return data to the caller
    movlw  0x45
    movwf ?_asm_function_int,a ; 
    movlw  0x67
    movwf ?_asm_function_int+1,a; 
    return  
    
    

; function example that uses a 16 bit global variable to pass/return data
; void _asm_function_globalv(void);
; _globalvar is the global variable used to pass/return data    
    
    
GLOBAL _asm_function_globalv; To make the asm fuction visible to the C modules or other asm files       
GLOBAL _globalvar; Variable devlared in the C code
    
_asm_function_globalv:   
    ; Reads parameters passed in the compiled stack
    banksel(_globalvar)
    movf    _globalvar,w,b
    banksel(var1)
    banksel(_globalvar)
    movf    _globalvar+1,w,b
    banksel(var2)
    movwf   BANKMASK(var2),b
    
    ; Write results in the compiled stack to return data to the caller
    banksel(_globalvar)
    movlw  0x56
    movwf   BANKMASK(_globalvar),b 
    movlw  0xfe
    movwf   BANKMASK(_globalvar+1),b 
    return  

