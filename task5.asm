global _start

section .bss
    input  resb 64
    nums   resq 4
    output resb 32

section .text
_start:
    ; ------------------------------------------------
    ; 1. Read the whole input line
    ; ------------------------------------------------
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 64
    syscall


    ; ------------------------------------------------
    ; 2. Convert the four decimal numbers from ASCII
    ;
    ; rcx = which number we are storing (0..3)
    ; rsi = character index into input
    ; rbx = number currently being constructed
    ; ------------------------------------------------
    xor rcx, rcx
    xor rsi, rsi
    xor rbx, rbx

.parse:
    movzx rax, byte [input + rsi]

    ; Newline means the fourth number has ended
    cmp al, 10
    je .last_number

    ; Space means the current number has ended
    cmp al, ' '
    je .next_number

    ; It is a digit.
    ; Convert ASCII -> integer.
    sub rax, '0'

    ; current = current * 10 + digit
    imul rbx, rbx, 10
    add rbx, rax

    inc rsi
    jmp .parse


.next_number:
    ; Save current number
    mov [nums + rcx*8], rbx

    ; Move to next number
    inc rcx

    ; Reset accumulator
    xor rbx, rbx

    ; Skip the space
    inc rsi

    jmp .parse


.last_number:
    ; Save d
    mov [nums + rcx*8], rbx


    ; ------------------------------------------------
    ; nums[0] = a
    ; nums[1] = b
    ; nums[2] = c
    ; nums[3] = d
    ; ------------------------------------------------


    ; ------------------------------------------------
    ; 3. Compute numerator = a*b + c*d
    ; ------------------------------------------------
    mov rax, [nums]
    imul rax, [nums + 8]       ; a * b
    mov r12, rax               ; keep a*b

    mov rax, [nums + 16]
    imul rax, [nums + 24]      ; c * d

    add r12, rax               ; r12 = a*b + c*d


    ; ------------------------------------------------
    ; 4. Compute denominator = a + d + 1
    ; ------------------------------------------------
    mov rbx, [nums]
    add rbx, [nums + 24]
    inc rbx


    ; ------------------------------------------------
    ; 5. Divide numerator / denominator
    ; ------------------------------------------------
    mov rax, r12

    ; Unsigned division uses rdx:rax.
    ; Our values are non-negative, so high half = 0.
    xor rdx, rdx
    div rbx

    ; rax = quotient = final result
    ; rdx = remainder (not needed)


    ; ------------------------------------------------
    ; 6. Convert result in rax into decimal ASCII
    ;
    ; Build the answer backwards in output.
    ; ------------------------------------------------

    ; Put newline at the end
    lea rdi, [output + 31]
    mov byte [rdi], 10

    ; rcx = output length
    mov rcx, 1

    ; Special case: result = 0
    cmp rax, 0
    jne .convert_digits

    dec rdi
    mov byte [rdi], '0'
    inc rcx
    jmp .print_result


.convert_digits:
    mov rbx, 10

.convert_loop:
    ; Divide number by 10
    xor rdx, rdx
    div rbx

    ; quotient  -> rax
    ; remainder -> rdx
    ;
    ; remainder is the next decimal digit

    add dl, '0'

    ; Move backward through the output buffer
    dec rdi
    mov [rdi], dl
    inc rcx

    ; Continue until quotient becomes zero
    cmp rax, 0
    jne .convert_loop


.print_result:
    ; rdi currently points to first digit
    mov rsi, rdi

    ; rcx contains digit count + newline
    mov rdx, rcx

    mov rax, 1
    mov rdi, 1
    syscall


    ; ------------------------------------------------
    ; 7. exit(0)
    ; ------------------------------------------------
    mov rax, 60
    mov rdi, 0
    syscall