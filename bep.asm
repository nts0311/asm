
;led 199
;bep data 125 control 127

.Model small
.Stack 100h
.Data
    nhietDoMax dB 0
    nhietDoMin dB 0
    thoiGian     dW 0
    soVuaDoc   dW 0
    coso10 dW 10
    dangDoc db 0
    
    tbaoNhapNhietDo dB "Nhap vao 2 gioi han nhiet (0-100 C): $"
    tbaoNhapSai dB "Nhap sai, moi nhap lai: $"
    tbaoNhapSoPhut  dB "Nhap vao thoi gian hen gio tat bep(phut, max 65535): $"
    newln dB 10,13,'$'


.Code
    jmp main
    
    
main:
    mov ax, @Data
    mov ds, ax
    mov es, ax
    
    ;moi nguoi dung nhap vao nhiet do
    lea dx, tbaoNhapNhietDo
    mov ah, 9h
    int 21h
    
    ;Bat dau doc 2 muc nhiet do
      
    jmp doc_so
    
ket_thuc_doc_so:
    cmp dangDoc, 0
    je doc_nhiet_do_min
    cmp dangDoc, 1
    je doc_nhiet_do_max
    jmp doc_thoi_gian
    
nhap_sai: 
    mov ah, 9
    lea dx, newln
    int 21h
    lea dx, tbaoNhapSai
    int 21h
    mov soVuaDoc, 0 
    jmp doc_so         
   
    
doc_nhiet_do_min:
    cmp soVuaDoc, 100
    jae nhap_sai
       
    mov ax, soVuaDoc
    mov nhietDoMin, al
    inc dangDoc
    mov soVuaDoc, 0 
    
    lea dx, newln
    mov ah, 9h
    int 21h
    
    jmp doc_so ; Doc tiep gioi han nhiet do tren
    
    
doc_nhiet_do_max: 
    cmp soVuaDoc, 100
    jae nhap_sai

    mov ax, soVuaDoc
    mov nhietDoMax, al
    inc dangDoc     
    mov soVuaDoc, 0  
    
    lea dx, newln
    mov ah, 9h
    int 21h
    
    lea dx, tbaoNhapSoPhut
    mov ah, 9h
    int 21h
    
    jmp doc_so ; Doc tiep thoi gian


doc_thoi_gian:   
    mov ax, soVuaDoc
    mov thoiGian, ax
    inc dangDoc
    jmp bat_dau_bat_bep
    

    
doc_so:      
    ;doc 1 ky tu
    mov ah, 1
    int 21h 
    
    ;kiem tra enter
    cmp al, 13
    je ket_thuc_doc_so    ; neu emter, ket thuc nhap
    
    ;kiem tra co phai chu so 0-9 khong
    cmp al, 48
    jb doc_so ;neu ky tu < '0'
    cmp al, 57
    ja doc_so ;neu ky tu > '9'

    mov ah, 0
    sub al, 48  
    
    mov bx, ax   
    
    mov ax, soVuaDoc          
    mul coso10  
    add ax, bx
    
    mov soVuaDoc, ax
    jmp doc_so 
    
bat_dau_bat_bep: 

    mov ah, 2ch
    int 21h

        

endmain:
    mov ah, 4ch
    int 21h