
; Assignment No. : 1
; Assignment Name : Write an ALP to find no. of positive / negative elements from 64-bit array 
;-------------------------------------------------------------------
section .data
    nline db 10,10                                           ; Newline characters
    nline_len equ $-nline                                           ; Length of newline characters

    ano db 10," Assignment No. : 1",10                                           ; Assignment details
        db "Positive / Negative elements from 64-bit array", 10 
    ano_len equ $-ano ; Length of assignment details
    
    arr64 dq -11111111H, 22222222H, -33333333H, 44444444H, 55555555H                                           ; Array of 64-bit integers
    n equ 5                                           ; Number of elements in the array

    pmsg db 10,10,"The no. of Positive elements from 64-bit array : "                                           ; Message for positive count
    pmsg_len equ $-pmsg ; Length of positive count message

    nmsg db 10,10,"The no. of Negative elements from 64-bit array : "                                           ; Message for negative count
    nmsg_len equ $-nmsg                                           ; Length of negative count message

;---------------------------------------------------------------------
section .bss
    p_count resq 1                                           ; Reserve space for positive count
    n_count resq 1                                           ; Reserve space for negative count

    char_ans resb 02                                           ; Buffer for displaying results
;---------------------------------------------------------------------
%macro Print 2
    mov rax, 1                                           ; System call number for sys_write
    mov rdi, 1                                           ; File descriptor 1 (stdout)
    mov rsi, %1                                           ; Address of the message
    mov rdx, %2                                           ; Length of the message
    syscall                                                ; Invoke the system call
%endmacro

%macro Read 2
    mov rax, 0                                                ; System call number for sys_read
    mov rdi, 0                                                ; File descriptor 0 (stdin)
    mov rsi, %1                                                ; Address of the buffer
    mov rdx, %2                                                ; Length of the buffer
    syscall                                                ; Invoke the system call
%endmacro

%macro Exit 0
    mov rax, 60                                                ; System call number for sys_exit
    mov rdi, 0                                                ; Exit code 0
    syscall                                                ; Invoke the system call
%endmacro

;---------------------------------------------------------------------
section .text
    global _start
_start:
    Print ano, ano_len                                          ; Print assignment details

    mov rsi, arr64                                          ; Load address of the array
    mov rcx, n                                          ; Load number of elements

    mov rbx, 0                                          ; Initialize positive count
    mov rdx, 0                                          ; Initialize negative count

next_num:
    mov rax, [rsi]                                          ; Load current number into RAX
    Rol rax, 1                                          ; Rotate left to check sign bit
    jc negative                                          ; Jump if carry (negative number)

positive:
    inc rbx                                          ; Increment positive count
    jmp next                                          ; Jump to next iteration

negative:
    inc rdx                                          ; Increment negative count

next:
    add rsi, 8                                          ; Move to the next number (64-bit = 8 bytes)
    dec rcx                                          ; Decrement counter
    jnz next_num                                          ; Repeat if counter is not zero

    mov [p_count], rbx ; Store positive count
    mov [n_count], rdx ; Store negative count

    Print pmsg, pmsg_len ; Print positive count message
    mov rax, [p_count] ; Load positive count
    call disp64_proc ; Display positive count

    Print nmsg, nmsg_len ; Print negative count message
    mov rax, [n_count] ; Load negative count
    call disp64_proc ; Display negative count

    Print nline, nline_len ; Print newline
    Exit ; Exit the program
;--------------------------------------------------------------------    
disp64_proc:
    mov rbx, 16 ; Divisor for hexadecimal
    mov rcx, 2 ; Number of digits
    mov rsi, char_ans+1      ; Load buffer address

cnt:
    mov rdx, 0 ; Clear RDX
    div rbx ; Divide RAX by 16

    cmp dl, 09h ; Compare remainder
    jbe add30 ; Jump if less than or equal to 9
    add dl, 07h ; Adjust for letters A-F
add30:
    add dl, 30h ; Convert to ASCII
    mov [rsi], dl ; Store character
    dec rsi ; Move to previous byte

    dec rcx ; Decrement digit count
    jnz cnt ; Repeat if not zero
    
    Print char_ans, 2 ; Print result
ret ; Return from procedure
