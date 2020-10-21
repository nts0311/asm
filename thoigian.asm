; multi-segment executable file template.

data segment
    ; add your data here!

    soPhut dW 3

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
    
    mov ax, soPhut
    out 199, ax
    
    mov ah, 2ch
    int 21h
    mov phutTruoc, cl
    mov giayKetThuc, dh 
   
lap:
    mov ah, 2ch 
    int 21h
    cmp phutTruoc, cl
    jne giam_so_phut
    
    cmp soPhut,0
    je so_sanh_giay
    
    jmp lap
    
giam_so_phut:
    dec soPhut 
    mov phutTruoc, cl
    mov ax, soPhut
    out 199, ax
    jmp lap
    
    
so_sanh_giay:
    cmp dh, giayKetThuc
    je exit
    jmp lap
    
       
  
        
exit:    
    mov ax, 4c00h 
    int 21h    
ends

end start 
