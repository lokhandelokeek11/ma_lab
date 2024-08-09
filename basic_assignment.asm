section    .data                                    ;section to define the initial data

first	db	10,"This is my First Program",10,10     ;define the message string with newline
first_len	equ	$-first                             ;calculate the length of the message string

%macro  Print   2                                   ;marco named 'Print' with two arguments
	mov   rax, 1                                    ;print syscall
	mov   rdi, 1                                    ;where to print
	mov   rsi, %1
	mov   rdx, %2
	syscall                                         ;calls to system to print message 
%endmacro

%macro	Exit	0                                   ;macro named 'Exit' with 0 arguments
	mov  rax, 60                                    ;exit after printing with code (60)
	mov  rdi, 0                                     ;exit status code 0 means code is completed successfully
	syscall                                         ;calls to system to exit 
%endmacro 

;---------------------------------------------------------------------
section    .text                                    ;section containing executable code
	global   _start                                 ;declare _start as the entry point
_start:                                             ;entry point
	Print	first, first_len                        ;call the print macro to print the message
	
Exit                                                ;call the exit macro to exit the program

