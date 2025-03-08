global cls          ; void cls();
global out_char     ; void out_char(char bl);
global out_string   ; void out_string(char* si);

global in_char      ; char in_char() return char ax (al);
global in_string    ; void in_string(char[]* si);

global comapre_strs ; int (const char* first_word[] si, const char* last_word[] bx) return cx

global clear_buffer ; void (const char* buf_address[] si, int buf_size bx);

global new_line ; void new_line();

section .text

new_line:
    push ax
    mov ah, 0x0e
    mov al, 0x0a
    int 0x10
    mov al, 0x0d
    int 0x10
    pop ax
    ret

cls:
    push ax
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    pop ax
    ret

out_char:
    push ax
    mov ah, 0x0e
    mov al, bl
    int 0x10
    pop ax
    ret

out_string:
    push ax
    mov ah, 0x0e
    call __out_string_next_char
    pop ax
    ret
__out_string_next_char:
    mov al, [si]
    cmp al, 0
    jz __out_string_if_zero
    int 0x10
    inc si
    jmp __out_string_next_char
__out_string_if_zero:
    ret

in_char:
    push bx
    mov ah, 0
    int 0x16
    mov ah, 0x0e
    mov bh, 0
    mov bl, 0x07
    int 0x10
    pop bx
    ret


comapre_strs:
    push si
    push bx
    push ax
__comapre_strs_comp:
    mov ah, [bx]
    cmp [si], ah
    jne __comapre_strs_first_zero
    inc si
    inc bx
    jmp __comapre_strs_comp
__comapre_strs_first_zero:
    cmp byte [bx], 0
    jne __comapre_strs_not_equal
    mov cx, 1
    pop si
    pop bx
    pop ax
    ret
__comapre_strs_not_equal:
    mov cx, 0
    pop si
    pop bx
    pop ax
    ret


clear_buffer:
    ; si
    ; bx
    push cx
    mov cx, 0
__clear_buffer_loop:
    cmp cx, bx
    je __clear_buffer_end_loop
    mov byte [si], 0
    inc si
    inc cx
    jmp __clear_buffer_loop
__clear_buffer_end_loop:
    pop cx
    ret



in_string:
    push ax
    push cx
    xor cx, cx
__input_string_loop:
    mov ah, 0
    int 0x16
    cmp al, 0x0d
    je __input_string_enter
    cmp al, 0x08
    je __input_string_backspace

    mov [si], al
    inc si
    inc cx

    mov ah, 0x0e
    mov bh, 0
    mov bl, 0x07
    int 0x10
    cmp cx, 255
    je __input_string_enter
    jmp __input_string_loop
__input_string_enter:
    mov ah, 0x0e
    mov al, 0x0d
    mov bh, 0
    mov bl, 0x07
    int 0x10
    mov al, 0xa
    int 0x10

    mov byte [si], 0
    pop cx
    pop ax
    ret
__input_string_backspace:
    cmp cx, 0
    je __input_string_loop
    ; 0x20
    mov ah, 0x0e
    mov al, 0x08
    int 0x10
    mov al, 0x20
    int 0x10
    mov al, 0x08
    int 0x10

    mov byte [si], 0
    dec si
    dec cx
    jmp __input_string_loop
