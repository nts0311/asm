; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
    nl db 13,10,'$'
    soPhut dW 103
    gioKetThuc db 0
    phutKetThuc db 0
    giayKetThuc db 0
    

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
    
    mov ah, 2ch
    int 21h
    mov gioKetThuc, ch
    mov phutKetThuc, cl
    mov giayKetThuc, dh
    
    xor dh, dh
    mov dl, 60
    mov ax, soPhut
    div dl
   
    add gioKetThuc, al 
    
    
    add phutKetThuc, ah
          
    xor ah, ah      
    mov al, phutKetThuc
    div dl
    add gioKetThuc, al
    mov phutKetThuc,ah
    
    
   
   
   
  
        
exit:    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
