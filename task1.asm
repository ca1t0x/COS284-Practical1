global _start

section .data
    msg db "Hello, COS284", 10
    len equ $ - msg

section .text
_start:
    ; write(1, msg, len)
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    ; exit(0)
    mov rax, 60
    mov rdi, 0
    syscall