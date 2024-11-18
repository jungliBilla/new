section .data
 	num1 db 0x03
 	num2 db 0x04
 	result dq 0
 	msg db "Result: ", 0
section .bss
 	result_str resb 20
section .text
 	global _start
_start:
 	movzx rax, byte [num1]
 	movzx rbx, byte [num2]
 	xor rcx, rcx
 	xor rdx, rdx
 	mov rdx, rbx
multiply_loop:
 	test rdx, rdx
 	jz done
 	add rcx, rax
 	dec rdx
 	jmp multiply_loop
done:
 	mov [result], rcx
 	mov rax, rcx
 	mov rdi, result_str
 	call int_to_string
 	mov rax, 1
 	mov rdi, 1
 	mov rsi, msg
 	mov rdx, 8
 	syscall
 	mov rax, 1
 	mov rdi, 1
 	mov rsi, result_str
 	mov rdx, 20
 	syscall
 	mov rax, 60
 	xor rdi, rdi
 	syscall
int_to_string:
	xor rcx, rcx
 	mov rbx, 10
convert_loop:
	xor rdx, rdx
	div rbx
	add dl, '0'
	push rdx
	inc rcx
	test rax, rax
	jnz convert_loop
	mov rsi, rdi
write_digits:
	pop rdx
	mov byte [rsi], dl
	inc rsi
 	loop write_digits
 	mov byte [rsi], 0
 	ret
