global _start

section .bss
    input  resb 4
    output resb 3

section .text
_start:
    ; Read "d d\n"
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 4
    syscall

    ; First digit
    movzx eax, byte [input]
    sub eax, '0'

    ; Second digit
    movzx ebx, byte [input + 2]
    sub ebx, '0'

    ; sum = first + second
    add eax, ebx

    ; Is the answer one digit or two?
    cmp eax, 10
    jl .one_digit

.two_digits:
    ; Maximum answer is 18, so tens digit must be 1
    mov byte [output], '1'

    ; Get ones digit
    sub eax, 10
    add al, '0'
    mov [output + 1], al

    ; newline
    mov byte [output + 2], 10

    ; 3 output bytes: "17\n"
    mov rdx, 3
    jmp .print

.one_digit:
    add al, '0'
    mov [output], al
    mov byte [output + 1], 10

    ; 2 output bytes: "7\n"
    mov rdx, 2

.print:
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    syscall

    ; exit(0)
    mov rax, 60
    mov rdi, 0
    syscall