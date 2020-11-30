
;led 199
;bep data 125 control 127 

#start=thermometer.exe#
#start=LED_Display.exe#

.Model small
.Stack 100h
.Data
    nhietDoMax dB 0
    nhietDoMin dB 0
    thoiGian     dW 0
    soVuaDoc   dW 0
    coso10 dW 10
    dangDoc db 0
    
    tbaoNhapNhietDo dB "Nhap vao 2 gioi han nhiet (0-120 C): $"
    tbaoNhapSai dB "Nhap sai, moi nhap lai: $"
    tbaoNhapSoPhut  dB "Nhap vao thoi gian hen gio tat bep(so phut, max 65535): $"
    newln dB 10,13,'$'
    
    phutTruoc db 0
    giayKetThuc db 0


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
    
doc_so:      
    ;doc 1 ky tu
    mov ah, 1
    int 21h 
    
    ;kiem tra enter
    cmp al, 13
    je ket_thuc_doc_so    ; neu emter, ket thuc nhap
    
    ;kiem tra co phai chu so 0-9 khong
    cmp al, '0'
    jb doc_so ;neu ky tu < '0'
    cmp al, '9'
    ja doc_so ;neu ky tu > '9'

    mov ah, 0
    sub al, 48  
    
    mov bx, ax   
    
    mov ax, soVuaDoc          
    mul coso10  
    add ax, bx
    
    mov soVuaDoc, ax
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
    cmp soVuaDoc, 120
    ja nhap_sai
       
    mov ax, soVuaDoc
    mov nhietDoMin, al
    inc dangDoc
    mov soVuaDoc, 0 
    
    lea dx, newln
    mov ah, 9h
    int 21h
    
    jmp doc_so ; Doc tiep gioi han nhiet do tren
    
    
doc_nhiet_do_max: 
    cmp soVuaDoc, 120
    ja nhap_sai
          
    xor ah, ah             
    mov al, nhietDoMin ; so sanh voi nhiet do min
    cmp soVuaDoc, ax
    jb nhap_sai        ; neu nhiet do max < nhiet do min, nhap lai

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
    
    
; bat dau bat bep    

    mov ax, thoiGian
    out 199, ax
    
    mov ah, 2ch
    int 21h
    mov phutTruoc, cl
    mov giayKetThuc, dh
    
lap:   
  
    ;kiem tra thoi gian
    ; doc thoi gian hien tai
    mov ah, 2ch 
    int 21h
    
    ;so sanh voi moc thoi gian da luu
    cmp phutTruoc, cl
    
    ;neu khac nhau thi so sanh so giay ban dau xem da het 1 phut chua
    jne so_sanh_giay
    
    
    jmp kiem_tra_nhiet_do
                        
giam_so_phut:

    dec thoiGian
    
    ;cap nhap lai moc thoi gian 
    mov phutTruoc, cl 
    
    ;cap nhap so phut con lai ra man hinh led
    mov ax, thoiGian 
    out 199, ax       
    
    cmp thoiGian, 0
    je endmain
    
    jmp kiem_tra_nhiet_do
    
    
so_sanh_giay:
    cmp dh, giayKetThuc     
    ; neu so giay bang nhau thi da qua 1 phut, 
    ; giam thoi gian va cap nhap ra ngoai man hinh LED
    je giam_so_phut
    jmp kiem_tra_nhiet_do                        


kiem_tra_nhiet_do:    
    ;kiem tra nhiet do
    in al, 125

    cmp al, nhietDoMin
    jl  low

    cmp al, nhietDoMax
    jle  lap
    jg   high
    
    jmp lap
    
low:
    mov al, 1
    out 127, al   ; bat bep
    jmp lap

high:
    mov al, 0
    out 127, al   ; tat bep 
    jmp lap 
          

endmain: 
    mov al, 0
    out 127, al
    mov ah, 4ch
    int 21h