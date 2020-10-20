; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
    nl db 13,10,'$'
    soPhut dW 5
    gioKetThuc db 0
    phutKetThuc db 0
    giayKetThuc db 0 
    
    phutDaQua dw 0
    phutTruoc db 0
    

ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
    
    ;mov ah, 2ch
;    int 21h
;    mov gioKetThuc, ch
;    mov phutKetThuc, cl
;    mov giayKetThuc, dh
;    
;    xor dh, dh
;    mov dl, 60
;    mov ax, soPhut
;    div dl
;   
;    add gioKetThuc, al 
;    
;    
;    add phutKetThuc, ah
;          
;    xor ah, ah      
;    mov al, phutKetThuc
;    div dl
;    add gioKetThuc, al
;    mov phutKetThuc,ah 
;    
;    
;lap:
;    mov ah, 2ch
;    int 21h
;    
;    cmp ch, gioKetThuc
;    je so_sanh_phut
;    jmp lap
;    
;so_sanh_phut:
;    cmp cl, phutKetThuc
;    je so_sanh_giay
;    jmp lap
;    
;so_sanh_giay:
;    cmp dh, giayKetThuc
;    je exit
;    jmp lap    
    
    
    mov ah, 2ch
    int 21h
    mov phutTruoc, cl
    mov giayKetThuc, dh 
   
lap: 
    int 21h
    cmp phutTruoc, cl
    jne tang_so_phut
    
    mov bx, soPhut
    cmp phutDaQua,bx
    jae so_sanh_giay
    
    jmp lap
    
tang_so_phut:
    inc phutDaQua 
    mov phutTruoc, cl
    jmp lap
    
    
so_sanh_giay:
    cmp dh, giayKetThuc
    je exit
    jmp lap
    
       
  
        
exit:    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
