global _start

section .bss
    buffer resb 2

section .text
_start:
    ; Read digit + newline
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 2
    syscall

    ; Convert ASCII digit to integer
    mov al, [buffer]
    sub al, '0'

    ; Compute 9 - n
    mov bl, 9
    sub bl, al

    ; Convert integer back to ASCII
    add bl, '0'

    ; Create output: digit + newline
    mov [buffer], bl
    mov byte [buffer + 1], 10

    ; Write 2 bytes
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 2
    syscall

    ; exit(0)
    mov rax, 60
    mov rdi, 0
    syscall