section .bss
    input resb 128
    length resq 1
    len_str resb 20

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    lea rsi, [input]
    mov rdx, 128
    syscall

    lea rdi, [input]
    xor rcx, rcx
len_loop:
    cmp byte [rdi + rcx], 10
    je reverse_string
    cmp byte [rdi + rcx], 0
    je reverse_string
    inc rcx
    jmp len_loop

reverse_string:
    mov [length], rcx
    dec rcx
    lea rsi, [input]
    add rsi, rcx

    lea rdi, [input]
rev_loop:
    cmp rsi, rdi
    jbe print_reversed
    mov al, [rsi]
    mov bl, [rdi]
    mov [rdi], al
    mov [rsi], bl
    inc rdi
    dec rsi
    jmp rev_loop

print_reversed:
    mov rax, 1
    mov rdi, 1
    lea rsi, [input]
    mov rdx, [length]
    inc rdx
    syscall

    mov rax, [length]
    lea rsi, [len_str + 19]
    mov byte [rsi], 0x0A
    dec rsi

len_to_str:
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add dl, '0'
    mov [rsi], dl
    dec rsi
    test rax, rax
    jnz len_to_str

    inc rsi
    mov rax, 1
    mov rdi, 1
    lea rdx, [len_str + 20]
    sub rdx, rsi
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
