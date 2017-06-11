
imprime macro cadena
  mov ax,data
  mov ds,ax
  mov ah,09
  mov dx,offset cadena
  int 21h
endm 

crear macro archivo
  mov ax,data  ; @data se guardar el nombre del archivo del texto creado
  mov ds,ax
  ;crear
  mov ah,3ch
  mov cx,0
  mov dx,offset archivo
  int 21h
  jc salir ;si no se pudo crear
  mov bx,ax
  mov ah,3eh ;cierra el archivo
  int 21h
    
endm 



abrir macro archivo
    ;abrir
    mov ah,3dh
    mov al,0h ;0h solo lectura, 1h solo escritura, 2 lectura y escritura 
    mov dx,offset archivo
    int 21h
    mov ah,42h
    mov al,00h
    mov bx,ax
    mov cx,50
    int 21h
    ;leer archivo
    mov ah,3fh
    ;mov bx,ax
    mov bx,ax
    mov cx,10
    mov dx,offset vec
    ;mov dl,vec[si]
    int 21h
    mov ah,09h
    int 21h
    
    ;Cierre de archivo
    mov ah,3eh
    int 21h
abrir endm

escribir macro archivo
pedir:
  mov ah,01h
  int 21h
  mov vec[si],al
  inc si
  cmp al,0dh
  ja pedir
  jb pedir

editar:
;abrir el archivo
mov ah,3dh
mov al,1h ;Abrimos el archivo en solo escritura.
mov dx,offset archivo
int 21h
jc salir ;Si hubo error

;Escritura de archivo
mov bx,ax ; mover hadfile
mov cx,si ;num de caracteres a grabar
mov dx,offset vec
mov ah,40h
int 21h
imprime msjescr
cmp cx,ax
jne salir ;error salir
mov ah,3eh  ;Cierre de archivo 
int 21h
jmp menu
endm 


.model small

.stack

.data
msj1 db 0ah,0dh, '***** Menu *****', '$'
msj2 db 0ah,0dh, '1.- Compra', '$'
msj3 db 0ah,0dh, '2.- Inventario', '$'
msj4 db 0ah,0dh, '3.- Ventas', '$'
msj5 db 0ah,0dh, '4.- Salir', '$'
msj6 db 0ah,0dh, 'Elegir una opcion ------> : ', '$'
msjcrear db 0ah,0dh, 'Archivo creado con exito', '$'
msjescr db 0ah,0dh, 'Archivo escrito con exito', '$'
msjnom db 0ah,0dh, 'Nombre del archivo: ', '$'
cadena db 'Cadena a Escribir en el archivo','$'  


;MENSAJES COMPRA
msj7 db 0ah,0dh, '***** COMPRA *****', '$'  
msj8 db 0ah,0dh, 'Ingrese una fecha ', '$'  
msj9 db 0ah,0dh, 'Ingrese el nombre del producto ', '$'
msj10 db 0ah,0dh, 'Ingrese el pago $', '$'
msj11 db 0ah,0dh, 'Ingrese la cantidad ', '$'  
 


;nombres de los arhivos de text
nameCompra db 'dbCompra.txt',0 ;nombre archivo y debe terminar en 0
nameInventario db 'dbInventario.txt',0 
nameVenta db 'dbVenta.txt',0 

vec db 50 dup('$')
handle db 0
linea db 10,13,'$'
.code
inicio:

;crea primero los 3 archivos para almacenar la info
crear nameCompra
crear nameInventario
crear nameVenta

menu:
  imprime msj1
  imprime msj2
  imprime msj3
  imprime msj4
  imprime msj5
  imprime msj6
  
  
  mov ah,0dh
  int 21h
 ;comparamos la opcion que se tecleo
  mov ah,01h
  int 21h
  cmp al,31h ; OPCION 1
  je compra
  cmp al,32h ; OPCION 2
  je inventario
  cmp al,33h ; OPCION 3
  je venta
  cmp al,34h ; OPCION 4
  je salir

compra: 
call limpiar 
imprime msj7
imprime msj8
abrir nameCompra 
escribir nameCompra
;seccion de codigo para editar el archivo
 
inventario:

venta:



 



salir:
mov ah,04ch
int 21h    

;limpia la pantalla
limpiar proc
    MOV AX,0600H ; Peticion para limpiar pantalla  
    mov bh,17h 
    ;MOV BH,89H ; Color de letra ==9 "Azul Claro"
    ; Fondo ==8 "Gris"
    MOV CX,0000H ; Se posiciona el cursor en Ren=0 Col=0
    MOV DX,184FH ; Cursor al final de la pantalla Ren=24(18) 
    ; Col=79(4F)
    INT 10H ; INTERRUPCION AL BIOS
    ;------------------------------------------------------------------------------
    MOV AH,02H ; Peticion para colocar el cursor
    MOV BH,00 ; Nunmero de pagina a imprimir
    MOV DH,05 ; Cursor en el renglon 05
    MOV DL,05 ; Cursor en la columna 05
    INT 10H ; Interrupcion al bios
    ;-----------------------------      
    ret
limpiar endp 

end