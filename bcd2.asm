section .data
    nline       db  10,10
    nline_len:  equ $-nline
    
    h2bmsg   db  10,"Enter 4-digit Hex number: "
    h2bmsg_len: equ $-h2bmsg

    bmsg        db  10,13,"Equivalent BCD number is: "
    bmsg_len:   equ $-bmsg

    emsg        db  10,"You entered Invalid Data!!!",10
    emsg_len:   equ $-emsg

section .bss
    buf         resb    6
    buf_len:    equ $-buf

    digitcount  resb    1

    ans     resw    1
    char_ans    resb    4

%macro  print   2
    mov     rax,1       
    mov     rdi,1       
    mov     rsi,%1      
    mov     rdx,%2      
    syscall         
%endmacro

%macro  read   2
    mov     rax,0       
    mov     rdi,0      
    mov     rsi,%1     
    mov     rdx,%2      
    syscall         
%endmacro

%macro  exit    0
    print   nline, nline_len
    mov rax, 60   
    xor rdi, rdi        
    syscall         
%endmacro

section .text
    global _start
_start:
    print   h2bmsg, h2bmsg_len

    call    accept_16
    mov     ax,bx

    mov     rbx,10
back:
    xor     rdx,rdx
    div     rbx    

    push    dx
    inc     byte[digitcount]

    cmp     rax,0h
    jne     back   

    print   bmsg, bmsg_len
print_bcd:
    pop     dx
    add     dl,30h     
    mov [char_ans],dl  
    
    print   char_ans,1  

    dec     byte[digitcount]
    jnz     print_bcd

    exit

accept_16:
    read    buf,5       

    xor     bx,bx
    mov     rcx,4
    mov     rsi,buf
next_digit:
    shl bx,04
    mov al,[rsi]
        cmp     al,"0"     
        jb  error      
        cmp   al,"9"   
        jbe  sub30    

        cmp al,"A"   
        jb   error         
        cmp al,"F"
        jbe   sub37         

        cmp     al,"a"         
        jb error      
        cmp al,"f"
        jbe  sub57         

error:  print   emsg,emsg_len    
        exit

sub57:  sub al,20h         
sub37:  sub   al,07h        
sub30:  sub   al,30h        
    
    add bx,ax       
    inc rsi     
    loop    next_digit
ret
