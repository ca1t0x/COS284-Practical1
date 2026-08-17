global _start

section .bss
    buffer resb 256

section .text
_start:
    ; read(0, buffer, 256)
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 256
    syscall

    ; rax = number of bytes actually read
    mov rdx, rax

    ; write(1, buffer, number_of_bytes_read)
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    ; exit(0)
    mov rax, 60
    mov rdi, 0
    syscall