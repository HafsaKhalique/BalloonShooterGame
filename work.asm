[org 0x0100]

jmp start

game_score: dw 0

oldisr:dd 0

pause_flag: db 0  ; 0 not paused 1paused

sleep:
    push cx
    push ax
    mov cx, 0x0005    
outerloop:
    mov ax, 0xFFFF      
innerloop:
    dec ax
    jnz innerloop
    loop outerloop
    pop ax
    pop cx
    ret



; ============================================
; SOUND EFFECT ROUTINES
; ============================================

; Play a beep sound (for balloon pop)
playPopSound:
    push ax
    push bx
    push cx
    
    ; Set frequency for pop sound (higher pitch)
    mov al, 0B6h
    out 43h, al
    
    mov ax, 2000        ; Frequency divisor (higher = lower pitch)
    out 42h, al
    mov al, ah
    out 42h, al
    
    ; Turn speaker on
    in al, 61h
    or al, 03h
    out 61h, al
    
    ; Short duration
    mov cx, 0x0800
popDelay1:
    loop popDelay1
    
    ; Turn speaker off
    in al, 61h
    and al, 0FCh
    out 61h, al
    
    pop cx
    pop bx
    pop ax
    ret

; Play game start sound (ascending tones)
playStartSound:
    push ax
    push bx
    push cx
    push dx
    
    mov dx, 3           ; Play 3 notes
startSoundLoop:
    mov al, 0B6h
    out 43h, al
    
    mov ax, 4000
    sub ax, dx
    sub ax, dx
    shl ax, 8
    out 42h, al
    mov al, ah
    out 42h, al
    
    in al, 61h
    or al, 03h
    out 61h, al
    
    mov cx, 0x1000
startDelay:
    loop startDelay
    
    in al, 61h
    and al, 0FCh
    out 61h, al
    
    mov cx, 0x0500
startPause:
    loop startPause
    
    dec dx
    jnz startSoundLoop
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Play game over sound (descending tones)
playGameOverSound:
    push ax
    push bx
    push cx
    push dx
    
    mov dx, 5           ; Play 5 descending notes
gameOverLoop:
    mov al, 0B6h
    out 43h, al
    
    mov ax, 1000
    mov bx, dx
    shl bx, 7
    add ax, bx
    out 42h, al
    mov al, ah
    out 42h, al
    
    in al, 61h
    or al, 03h
    out 61h, al
    
    mov cx, 0x2000
gameOverDelay:
    loop gameOverDelay
    
    in al, 61h
    and al, 0FCh
    out 61h, al
    
    mov cx, 0x0300
gameOverPause:
    loop gameOverPause
    
    dec dx
    jnz gameOverLoop
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Play pause sound (two quick beeps)
playPauseSound:
    push ax
    push bx
    push cx
    
    mov bx, 2           ; Play twice
pauseSoundLoop:
    mov al, 0B6h
    out 43h, al
    
    mov ax, 3000
    out 42h, al
    mov al, ah
    out 42h, al
    
    in al, 61h
    or al, 03h
    out 61h, al
    
    mov cx, 0x0600
pauseDelay1:
    loop pauseDelay1
    
    in al, 61h
    and al, 0FCh
    out 61h, al
    
    mov cx, 0x0400
pauseDelay2:
    loop pauseDelay2
    
    dec bx
    jnz pauseSoundLoop
    
    pop cx
    pop bx
    pop ax
    ret

; Play wrong key sound (buzzer)
playWrongSound:
    push ax
    push cx
    
    mov al, 0B6h
    out 43h, al
    
    mov ax, 500         ; Low frequency for error
    out 42h, al
    mov al, ah
    out 42h, al
    
    in al, 61h
    or al, 03h
    out 61h, al
    
    mov cx, 0x1800
wrongDelay:
    loop wrongDelay
    
    in al, 61h
    and al, 0FCh
    out 61h, al
    
    pop cx
    pop ax
    ret

printsparkle:
    push bp
    mov bp, sp
    push es
    
    mov ax, 0xb800
    mov es, ax
    
    ; center of sparkle
    mov al, 80
    mov bl, [bp+8]
    mul bl
    add ax, [bp+6]
    shl ax, 1
    mov di, ax
    mov ax, [bp+4]
    mov word [es:di], ax
    
    ; top of sparkle
    mov al, 80
    mov bl, [bp+8]
    sub bl, 1
    mul bl
    add ax, [bp+6]
    shl ax, 1
    mov di, ax
    mov ax, [bp+4]
    mov word [es:di], ax
    
    ; bottom of sparkle
    mov al, 80
    mov bl, [bp+8]
    add bl, 1
    mul bl
    add ax, [bp+6]
    shl ax, 1
    mov di, ax
    mov ax, [bp+4]
    mov word [es:di], ax
    
    ; left of sparkle
    mov al, 80
    mov bl, [bp+8]
    mul bl
    add ax, [bp+6]
    sub ax, 1
    shl ax, 1
    mov di, ax
    mov ax, [bp+4]
    mov word [es:di], ax
    
    ; right of sparkle
    mov al, 80
    mov bl, [bp+8]
    mul bl
    add ax, [bp+6]
    add ax, 1
    shl ax, 1
    mov di, ax
    mov ax, [bp+4]
    mov word [es:di], ax
    
    pop es
    pop bp
    ret 6


printmoon:
    push bp
    mov bp, sp
    push es
    
    mov ax, 0xb800
    mov es, ax
    mov al, 80
    mov bl, [bp+6]
    
    mul bl
    add ax, [bp+4]
    shl ax, 1
    
    mov di, ax
    mov cx, 2
    mov ax, 0x0FDB 
	
line1:
    mov word [es:di], ax
    add di, 2
    loop line1
	
    mov ax, 0xb800
    mov es, ax
    mov al, 80
    mov bl, [bp+6]
    
    mul bl
    add ax, [bp+4]
    shl ax, 1
    
    mov di, ax
    mov cx, 6
    mov ax, 0x0FDB 
    mov word [es:di], ax
    add di, 156
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 156
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 154
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 158
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
	
    add di, 160
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 162
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 162
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
	
    add di, 2
    mov word [es:di], ax
	
    add di, 2
    mov word [es:di], ax
	
    add di, 2
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
	
	
    ; bigger ring
    mov ax, 0xb800
    mov es, ax
    mov al, 80
    mov bl, [bp+6]
    
    mul bl
    add ax, [bp+4]
    shl ax, 1
    sub ax, 8
    mov di, ax
    mov cx, 6
    mov ax, 0x0FDB 
	
line2:
    mov word [es:di], ax
    add di, 2
    loop line2
	
    mov ax, 0xb800
    mov es, ax
    mov al, 80
    mov bl, [bp+6]
    
    mul bl
    add ax, [bp+4]
    shl ax, 1
    sub ax, 10
    mov di, ax
    
    mov ax, 0x0FDB 
    mov word [es:di], ax
    add di, 156
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 156
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 156
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 154
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 158
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
	
    add di, 160
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 162
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 162
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
	
    add di, 162
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
	
    add di, 2
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
	
    add di, 2
    mov word [es:di], ax
	
    sub di, 158
    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
	
    pop es
    mov sp, bp
    pop bp
    ret 4


printstar:
    push bp
    mov bp, sp
    push es
    push ax
    push bx
    push cx
    push di

    ; row 1
    xor ah, ah
    mov al, [bp+8]     
    mov bx, 80
    mul bx               
    add ax, [bp+6]       
    shl ax, 1            
    add ax, 12
    mov di, ax
    mov ax, 0xb800
    mov es, ax
    mov ax, [bp+4]
    mov word [es:di], ax

    ; row2
    xor ah, ah
    mov al, [bp+8]
    add al, 1
    mov bx, 80
    mul bx
    add ax, [bp+6]
    shl ax, 1
    add ax, 10
    mov di, ax
    mov ax, 0xb800
    mov es, ax
    mov cx, 3
    mov ax, [bp+4]
nextchar1:
    mov word [es:di], ax
    add di, 2
    loop nextchar1

    ; row3
    xor ah, ah
    mov al, [bp+8]
    add al, 2
    mov bx, 80
    mul bx
    add ax, [bp+6]
    shl ax, 1
    add ax, 8
    mov di, ax
    mov ax, 0xb800
    mov es, ax
    mov cx, 5
    mov ax, [bp+4]
nextchar2:
    mov word [es:di], ax
    add di, 2
    loop nextchar2

    ; row 4
    xor ah, ah
    mov al, [bp+8]
    add al, 3
    mov bx, 80
    mul bx
    add ax, [bp+6]
    shl ax, 1
    sub ax, 2
    mov di, ax
    mov ax, 0xb800
    mov es, ax
    mov cx, 15
    mov ax, [bp+4]
nextchar3:
    mov word [es:di], ax
    add di, 2
    loop nextchar3

    ;row 5
    xor ah, ah
    mov al, [bp+8]
    add al, 4
    mov bx, 80
    mul bx
    add ax, [bp+6]
    shl ax, 1
    add ax, 4
    mov di, ax
    mov ax, 0xb800
    mov es, ax
    mov cx, 9
    mov ax, [bp+4]
nextchar4:
    mov word [es:di], ax
    add di, 2
    loop nextchar4

    ;row 6
    xor ah, ah
    mov al, [bp+8]
    add al, 5
    mov bx, 80
    mul bx
    add ax, [bp+6]
    shl ax, 1
    add ax, 6
    mov di, ax
    mov ax, 0xb800
    mov es, ax
    mov cx, 6
    mov ax, [bp+4]
nextchar5:
    mov word [es:di], ax
    add di, 2
    loop nextchar5

    ; row7
    xor ah, ah
    mov al, [bp+8]
    add al, 6
    mov bx, 80
    mul bx
    add ax, [bp+6]
    shl ax, 1
    add ax, 6
    mov di, ax
    mov ax, 0xb800
    mov es, ax
    mov ax, [bp+4]

    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax
    add di, 2

    mov word [es:di], 0x0720
    add di, 2
    mov word [es:di], 0x0720
    add di, 2

    mov word [es:di], ax
    add di, 2
    mov word [es:di], ax

    ;row8
    xor ah, ah
    mov al, [bp+8]
    add al, 7
    mov bx, 80
    mul bx
    add ax, [bp+6]
    shl ax, 1
    add ax, 6
    mov di, ax
    mov ax, 0xb800
    mov es, ax
    mov ax, [bp+4]

    mov word [es:di], ax
    add di, 2

    mov word [es:di], 0x0720
    add di, 2
    mov word [es:di], 0x0720
    add di, 2
    mov word [es:di], 0x0720
    add di, 2
    mov word [es:di], 0x0720
    add di, 2

    mov word [es:di], ax

    pop di
    pop cx
    pop bx
    pop ax
    pop es
    mov sp, bp
    pop bp
    ret 6


printpixeltext:
    push bp
    mov bp, sp
    push es
    push ax
    push di

    mov ax, 0xb800
    mov es, ax

    ; printing top horizontal line of P
    xor ah, ah
    mov al, 8
    mov bx, 80
    mul bx
    add ax, 26
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB
    mov word [es:di+2], 0x0EDB
    mov word [es:di+4], 0x0EDB
    mov word [es:di+6], 0x0EDB
	
	;now we print the right vertical line

    xor ah, ah
    mov al, 9
    mov bx, 80
    mul bx
    add ax, 26 
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB
    mov word [es:di+8], 0x0EDB
	
; bottom horizontal line pf P

    xor ah, ah
    mov al, 10
    mov bx, 80
    mul bx
    add ax, 26
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB
    mov word [es:di+2], 0x0EDB
    mov word [es:di+4], 0x0EDB
    mov word [es:di+6], 0x0EDB
	
; left long vertical line of P

    xor ah, ah
    mov al, 11
    mov bx, 80
    mul bx
    add ax, 26 ; same starting point as p ki horizontal top line
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB

    xor ah, ah
    mov al, 12
    mov bx, 80
    mul bx
    add ax, 26
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB

 ; top horizontal line of O
    xor ah, ah
    mov al, 8
    mov bx, 80
    mul bx
    add ax, 32
    shl ax, 1
    mov di, ax
    mov word [es:di+2], 0x0EDB
    mov word [es:di+4], 0x0EDB
    mov word [es:di+6], 0x0EDB
	
    ; vertical left
    xor ah, ah
    mov al, 9
    mov bx, 80
    mul bx
    add ax, 32
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB
    mov word [es:di+8], 0x0EDB

    xor ah, ah
    mov al, 10
    mov bx, 80
    mul bx
    add ax, 32
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB
    mov word [es:di+8], 0x0EDB

    xor ah, ah
    mov al, 11
    mov bx, 80
    mul bx
    add ax, 32
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB
    mov word [es:di+8], 0x0EDB ; giving spaces fir horizontal lines
    ; bottom horrizontal line
    xor ah, ah
    mov al, 12
    mov bx, 80
    mul bx
    add ax, 32
    shl ax, 1
    mov di, ax
    mov word [es:di+2], 0x0EDB
    mov word [es:di+4], 0x0EDB
    mov word [es:di+6], 0x0EDB

    ; 2nd p, sem method diff location
    xor ah, ah
    mov al, 8
    mov bx, 80
    mul bx
    add ax, 38
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB
    mov word [es:di+2], 0x0EDB
    mov word [es:di+4], 0x0EDB
    mov word [es:di+6], 0x0EDB

    xor ah, ah
    mov al, 9
    mov bx, 80
    mul bx
    add ax, 38
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB
    mov word [es:di+8], 0x0EDB

    xor ah, ah
    mov al, 10
    mov bx, 80
    mul bx
    add ax, 38
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB
    mov word [es:di+2], 0x0EDB
    mov word [es:di+4], 0x0EDB
    mov word [es:di+6], 0x0EDB

    xor ah, ah
    mov al, 11
    mov bx, 80
    mul bx
    add ax, 38
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB

    xor ah, ah
    mov al, 12
    mov bx, 80
    mul bx
    add ax, 38
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0EDB

    ;I 
    xor ah, ah
    mov al, 8
    mov bx, 80
    mul bx
    add ax, 46
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0ADB
    mov word [es:di+2], 0x0ADB
    mov word [es:di+4], 0x0ADB

    xor ah, ah
    mov al, 9
    mov bx, 80
    mul bx
    add ax, 46
    shl ax, 1
    mov di, ax
    mov word [es:di+2], 0x0ADB ; skiping the first di to print vertical from the centre of the horizontal line

    xor ah, ah
    mov al, 10
    mov bx, 80
    mul bx
    add ax, 46
    shl ax, 1
    mov di, ax
    mov word [es:di+2], 0x0ADB

    xor ah, ah
    mov al, 11
    mov bx, 80
    mul bx
    add ax, 46
    shl ax, 1
    mov di, ax
    mov word [es:di+2], 0x0ADB

    xor ah, ah
    mov al, 12
    mov bx, 80
    mul bx
    add ax, 46
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0ADB
    mov word [es:di+2], 0x0ADB
    mov word [es:di+4], 0x0ADB

    ; T 
    xor ah, ah
    mov al, 8
    mov bx, 80
    mul bx
    add ax, 50
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0ADB
    mov word [es:di+2], 0x0ADB
    mov word [es:di+4], 0x0ADB ; centre of the vertical line of T
    mov word [es:di+6], 0x0ADB
    mov word [es:di+8], 0x0ADB

    xor ah, ah
    mov al, 9
    mov bx, 80
    mul bx
    add ax, 50
    shl ax, 1
    mov di, ax
    mov word [es:di+4], 0x0ADB

    xor ah, ah
    mov al, 10
    mov bx, 80
    mul bx
    add ax, 50
    shl ax, 1
    mov di, ax
    mov word [es:di+4], 0x0ADB

    xor ah, ah
    mov al, 11
    mov bx, 80
    mul bx
    add ax, 50
    shl ax, 1
    mov di, ax
    mov word [es:di+4], 0x0ADB

    xor ah, ah
    mov al, 12
    mov bx, 80
    mul bx
    add ax, 50
    shl ax, 1
    mov di, ax
    mov word [es:di+4], 0x0ADB

    pop di
    pop ax
    pop es
    pop bp
    ret

; begin gam ebutton
printstartbutton:
    push bp
    mov bp, sp
    push es
    push ax
    push di

    mov ax, 0xb800
    mov es, ax

    
    xor ah, ah
    mov al, 15
    mov bx, 80
    mul bx
    add ax, 28
    shl ax, 1
    mov di, ax
    mov cx, 24 ; length of horizontal line top
drawbordertop:
    mov word [es:di], 0x4020 
    add di, 2
    loop drawbordertop

    
    mov cx, 3  ; 3 rows forheight
    mov al, 16
	; five rows of the button, 3 for middle rows
drawbuttonrows:
    push ax
    push cx
    xor ah, ah
    mov bx, 80
    mul bx
    add ax, 28
    shl ax, 1
    mov di, ax
    
    ; left border
    mov word [es:di], 0x4020  
    add di, 2
    
    ; filling
    mov cx, 22
fillbuttonrow:
    mov word [es:di], 0x4020  
    add di, 2
    loop fillbuttonrow
    
    ; right border
    mov word [es:di], 0x4020  
    
    pop cx
    pop ax
    inc al
    loop drawbuttonrows

    ;button border bottom
    xor ah, ah
    mov al, 19
    mov bx, 80
    mul bx
    add ax, 28
    shl ax, 1
    mov di, ax
    mov cx, 24
drawborderbottom:
    mov word [es:di], 0x4020  
    add di, 2
    loop drawborderbottom

;begin game 
    xor ah, ah
    mov al, 15
    mov bx, 80
    mul bx
    add ax, 30
    shl ax, 1
    mov di, ax
    ; row 1
    mov word [es:di], 0x4FDB
    mov word [es:di+2], 0x4FDB
    mov word [es:di+4], 0x4FDB
    ; row 2
    add di, 160 ; DI STILL HAS sem column in it at left side
    mov word [es:di], 0x4FDB
    mov word [es:di+4], 0x4FDB ; leaving spaces for hoolow parts
    ; row 3
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+2], 0x4FDB
    mov word [es:di+4], 0x4FDB
    ; row 4
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+4], 0x4FDB
    ; row 5
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+2], 0x4FDB
    mov word [es:di+4], 0x4FDB

    ;  E 
    xor ah, ah
    mov al, 15
    mov bx, 80
    mul bx
    add ax, 34
    shl ax, 1
    mov di, ax
    ; row 1
    mov word [es:di], 0x4FDB
    mov word [es:di+2], 0x4FDB
    mov word [es:di+4], 0x4FDB
    ; row2
    add di, 160
    mov word [es:di], 0x4FDB ; bet 2 horizontal lines there is a distance of 1 pixel for the vertical thingy
    ; row 3
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+2], 0x4FDB
    mov word [es:di+4], 0x4FDB
    ; row 4
    add di, 160
    mov word [es:di], 0x4FDB
    ; row 5
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+2], 0x4FDB
    mov word [es:di+4], 0x4FDB

    ;  G 
    xor ah, ah
    mov al, 15
    mov bx, 80
    mul bx
    add ax, 38
    shl ax, 1
    mov di, ax
    ; row1
    mov word [es:di], 0x4FDB
    mov word [es:di+2], 0x4FDB
    mov word [es:di+4], 0x4FDB
    ; row 2
    add di, 160
    mov word [es:di], 0x4FDB
    ; row3
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+4], 0x4FDB ; gap for g
    ; row 4
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+4], 0x4FDB
    ; row5
    add di, 160
    mov word [es:di+2], 0x4FDB
    mov word [es:di+4], 0x4FDB

    ;  I 
    xor ah, ah
    mov al, 15
    mov bx, 80
    mul bx
    add ax, 42
    shl ax, 1
    mov di, ax
    ; row1
    mov word [es:di], 0x4FDB
    mov word [es:di+2], 0x4FDB
    mov word [es:di+4], 0x4FDB
    ; row 2
    add di, 160
    mov word [es:di+2], 0x4FDB
    ; row3
    add di, 160
    mov word [es:di+2], 0x4FDB
    ; row4
    add di, 160
    mov word [es:di+2], 0x4FDB
    ; row 5
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+2], 0x4FDB
    mov word [es:di+4], 0x4FDB

    ;  N 
    xor ah, ah
    mov al, 15
    mov bx, 80
    mul bx
    add ax, 46
    shl ax, 1
    mov di, ax
    ; row1
    mov word [es:di], 0x4FDB
    mov word [es:di+6], 0x4FDB
    ; row2
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+2], 0x4FDB
    mov word [es:di+6], 0x4FDB
    ; row3
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+4], 0x4FDB
    mov word [es:di+6], 0x4FDB
    ; row4
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+4], 0x4FDB
    mov word [es:di+6], 0x4FDB
    ; row5 
    add di, 160
    mov word [es:di], 0x4FDB
    mov word [es:di+6], 0x4FDB

    pop di
    pop ax
    pop es
    pop bp
    ret



displaystartscreen:
   mov ax, 0xb800
    mov es, ax
    mov di, 0
nextchar:
    mov word [es:di], 0x0720
    add di, 2
    cmp di, 4000
    jne nextchar

    
    call printpixeltext

   
    call printstartbutton

    
    mov ax, 2       
    push ax
    mov ax, 12    
    push ax
    call printmoon

    
    mov ax, 0      
    push ax
    mov ax, 60     
    push ax
    mov ax, 0xD3DB  
    push ax
    call printstar

    
    mov ax, 16      
    push ax
    mov ax, 2       
    push ax
    mov ax, 0xACDB  
    push ax
    call printstar

    
    mov ax, 16     
    push ax
    mov ax, 62    
    push ax
    mov ax, 0xE9DB
    push ax
    call printstar

    
    mov ax, 1
    push ax
    mov ax, 20
    push ax
    mov ax, 0x0EDB
    push ax
    call printsparkle

    
    mov ax, 2
    push ax
    mov ax, 40
    push ax
    mov ax, 0x0BDB
    push ax
    call printsparkle

    
    mov ax, 3
    push ax
    mov ax, 50
    push ax
    mov ax, 0x0DDB
    push ax
    call printsparkle

    
    mov ax, 5
    push ax
    mov ax, 70
    push ax
    mov ax, 0x0FDB
    push ax
    call printsparkle

   
    mov ax, 7
    push ax
    mov ax, 15
    push ax
    mov ax, 0x0ADB
    push ax
    call printsparkle

    
    mov ax, 10
    push ax
    mov ax, 10
    push ax
    mov ax, 0x0EDB
    push ax
    call printsparkle

    
    mov ax, 13
    push ax
    mov ax, 18
    push ax
    mov ax, 0x0BDB
    push ax
    call printsparkle

    
    mov ax, 7
    push ax
    mov ax, 63
    push ax
    mov ax, 0x0DDB
    push ax
    call printsparkle

    
    mov ax, 10
    push ax
    mov ax, 70
    push ax
    mov ax, 0x0FDB
    push ax
    call printsparkle

    
    mov ax, 13
    push ax
    mov ax, 58
    push ax
    mov ax, 0x0CDB
    push ax
    call printsparkle

    
   
    mov ax, 21
    push ax
    mov ax, 20
    push ax
    mov ax, 0x0EDB
    push ax
    call printsparkle

    
    mov ax, 22
    push ax
    mov ax, 40
    push ax
    mov ax, 0x0BDB
    push ax
    call printsparkle

    
    mov ax, 21
    push ax
    mov ax, 55
    push ax
    mov ax, 0x0DDB
    push ax
    call printsparkle

    
    mov ax, 23
    push ax
    mov ax, 15
    push ax
    mov ax, 0x0FDB
    push ax
    call printsparkle

    
    mov ax, 23
    push ax
    mov ax, 65
    push ax
    mov ax, 0x0ADB
    push ax
    call printsparkle

    
    mov ax, 4
    push ax
    mov ax, 22
    push ax
    mov ax, 0x0EDB
    push ax
    call printsparkle

    
    mov ax, 4
    push ax
    mov ax, 58
    push ax
    mov ax, 0x0BDB
    push ax
    call printsparkle

   
    mov ax, 11
    push ax
    mov ax, 5
    push ax
    mov ax, 0x0DDB
    push ax
    call printsparkle

    
    mov ax, 11
    push ax
    mov ax, 75
    push ax
    mov ax, 0x0FDB
    push ax
    call printsparkle

    
    mov ax, 6
    push ax
    mov ax, 77
    push ax
    mov ax, 0x0CDB
    push ax
    call printsparkle

  ret 
; hart positio
heart1_col: dw 80
heart2_col: dw 70
heart3_col: dw 60
heart4_col: dw 50
heart5_col: dw 30
heart6_col: dw 20

; random letters 4 hearts
heart1_letter: dw 0x1F41
heart2_letter: dw 0x1F42
heart3_letter: dw 0x1F43
heart4_letter: dw 0x1F44
heart5_letter: dw 0x1F45
heart6_letter: dw 0x1F46

heart1_draw: db 0 ; 0 means draw, else idc
heart2_draw: db 0 ; 0 means draw, else idc
heart3_draw: db 0 ; 0 means draw, else idc
heart4_draw: db 0 ; 0 means draw, else idc
heart5_draw: db 0 ; 0 means draw, else idc
heart6_draw: db 0 ; 0 means draw, else idc

key_arr: db 'Q',0x10,'W',0x11,'E',0x12,'R',0x13,'T',0x14,'Y',0x15,'U',0x16,'I',0x17,'O',0x18,'P',0x19,'A',0x1E,'S',0x1F,'D',0x20,'F',0x21,'G',0x22,'H',0x23,'J',0x24,'K',0x25,'L',0x26,'Z',0x2C,'X',0x2D,'C',0x2E,'V',0x2F,'B',0x30,'N',0x31,'M',0x32

; Fixed keyboard ISR with proper bounds checking
beginisr:
	push ax 
	push bx 
	push cx 
	push dx 
	push es
	
	in al, 0x60  ; reading scan code from keyboard
	
	test al, 0x80  ; check if key release
	jnz exitkbIsr  ; ignore key releases
	
	; ESC key for pause toggle
	cmp al, 0x01
	je toggle_pause
	
	mov bx, -1 
	
	findKey:
		add bx, 2 
		cmp bx, 53 
		je exitkbIsr 
		
		cmp al, [cs:key_arr+bx]
		jne findKey
	
	dec bx 
	mov al, [cs:key_arr+bx] 
	
	; Check each balloon - FIXED BOUNDS CHECKING
	cmp al, [cs:heart1_letter]
	je ballon1
	
	cmp al, [cs:heart2_letter]
	je ballon2
	
	cmp al, [cs:heart3_letter]
	je ballon3
	
	cmp al, [cs:heart4_letter]
	je ballon4
	
	cmp al, [cs:heart5_letter]
	je ballon5
	
	cmp al, [cs:heart6_letter]
	je ballon6
	
	; If no match, play wrong sound
	call playWrongSound
	jmp exitkbIsr
	
toggle_pause:
	xor byte [cs:pause_flag], 1
	call playPauseSound
	jmp exitkbIsr
	
ballon1:
	; FIXED: Check if balloon is visible (above row 1 and below row 23)
	cmp word [cs:heart1_col], 1
	jl exitkbIsr  ; Too high, ignore
	cmp word [cs:heart1_col], 78
	jg exitkbIsr  ; Too low (off bottom), ignore
	cmp byte [cs:heart1_draw], 1  ; Already popped?
	je exitkbIsr
	mov byte [cs:heart1_draw], 1
	add word [cs:game_score], 10
	call playPopSound
	jmp exitkbIsr
		
ballon2:
	cmp word [cs:heart2_col], 1
	jl exitkbIsr
	cmp word [cs:heart2_col], 78
	jg exitkbIsr
	cmp byte [cs:heart2_draw], 1
	je exitkbIsr
	mov byte [cs:heart2_draw], 1
	add word [cs:game_score], 10
	call playPopSound
	jmp exitkbIsr
		
ballon3:
	cmp word [cs:heart3_col], 1
	jl exitkbIsr
	cmp word [cs:heart3_col], 78
	jg exitkbIsr
	cmp byte [cs:heart3_draw], 1
	je exitkbIsr
	mov byte [cs:heart3_draw], 1
	add word [cs:game_score], 10
	call playPopSound
	jmp exitkbIsr
		
ballon4:
	cmp word [cs:heart4_col], 1
	jl exitkbIsr
	cmp word [cs:heart4_col], 78
	jg exitkbIsr
	cmp byte [cs:heart4_draw], 1
	je exitkbIsr
	mov byte [cs:heart4_draw], 1
	add word [cs:game_score], 10
	call playPopSound
	jmp exitkbIsr
		
ballon5:
	cmp word [cs:heart5_col], 1
	jl exitkbIsr
	cmp word [cs:heart5_col], 78
	jg exitkbIsr
	cmp byte [cs:heart5_draw], 1
	je exitkbIsr
	mov byte [cs:heart5_draw], 1
	add word [cs:game_score], 10
	call playPopSound
	jmp exitkbIsr
		
ballon6:
	cmp word [cs:heart6_col], 1
	jl exitkbIsr
	cmp word [cs:heart6_col], 78
	jg exitkbIsr
	cmp byte [cs:heart6_draw], 1
	je exitkbIsr
	mov byte [cs:heart6_draw], 1
	add word [cs:game_score], 10
	call playPopSound
	jmp exitkbIsr
	
exitkbIsr:
	mov al, 0x20  ; Send EOI to PIC
	out 0x20, al
	
	pop es
	pop dx 
	pop cx 
	pop bx 
	pop ax 
	
	iret


; IMPROVED DELAY - Less CPU intensive, allows interrupts
delay:
    push cx
    push ax
    
    mov cx, 100  ; Reduced loop count
delay_outer:
    mov ax, 0x0500  ; Shorter inner loop
delay_inner:
    dec ax
    jnz delay_inner
    loop delay_outer
    
    pop ax
    pop cx
    ret
oldTimeisr: dd 0

;bg bufer to store the wholebg 
bgbuffer: times 4000 db 0


random_seed: dw 0x1234


exitflag: db 0

;function to generate a random num 0 to 25 a to z

timer: push ax 
 
 ;check if pause or nah if pause then zont touch da timer
 cmp byte [cs:pause_flag], 1
 je timer_skip_update
 
 inc word [cs:tickcount];increment tick count 
 mov ax,[cs:tickcount]
 cmp ax,18;za 18 tic iz 1 sec
 jne prnt
 inc word [cs:seconds]
 cmp word[cs:seconds],120;filhall putting 20 secs temer
 jne reset_tick
 mov byte [cs:exitflag], 1
 call GameOverFunc
reset_tick:
 mov word[cs:tickcount],0
prnt:
 push word [cs:seconds] 
 call _printnum ;print tck count 
 ;call delay;to help with da screen tweaking
 jmp timer_exit
 
timer_skip_update:
 ;wen pause scree print current tem
 push word [cs:seconds] 
 call _printnum
 call delay
 
timer_exit:
 mov al, 0x20 
 out 0x20, al ;eoi to pic
 pop ax 
 iret

 
;number le ga and print keray ga
_printnum: push bp 
 mov bp, sp 
 push es 
 push ax 
 push bx 
 push cx 
 push dx 
 push di 
 mov ax, 0xb800 
 mov es, ax
 mov ax, [bp+4]
 mov bx, 10 ;div by 10 
 mov cx, 0 ;digigt count
_nextdigit: mov dx, 0 ;upper half od dividend = 0
 div bx 
 add dl, 0x30 ;digit to ascii
 push dx ;saving value
 inc cx ;increment count
 cmp ax, 0 ;checking quotient
 jnz _nextdigit ;divide again
 mov al, 80
 mov bl, 0
 mul bl
 add ax, 42
 shl ax, 1
 mov di, ax 
nextpos: pop dx 
 mov dh, 0x1F
 mov [es:di], dx
 add di, 2
 loop nextpos
 pop di 
 pop dx 
 pop cx 
 pop bx 
 pop ax
 pop es 
 pop bp 
 ret 2 
 

printScore:
    push bp
    mov bp, sp
    push es
    push ax
    push bx
    push cx
    push dx
    push di
    
    mov ax, 0xb800
    mov es, ax
    
    mov ax, [bp+4]      
    mov bx, 10          
    mov cx, 0           
    
nextdigit_score:
    mov dx, 0          
    div bx              
    add dl, 0x30        
    push dx             
    inc cx            
    cmp ax, 0           
    jnz nextdigit_score 
    
    ;posiiton to print score
    mov al, 80
    mov bl, 0
    mul bl
    add ax, 13
    shl ax, 1
    mov di, ax
    
    ;clearing pichla score
    mov word [es:di], 0x1F20
    mov word [es:di+2], 0x1F20
    mov word [es:di+4], 0x1F20
    mov word [es:di+6], 0x1F20
    
    ;resetting pos
    mov al, 80
    mov bl, 0
    mul bl
    add ax, 13
    shl ax, 1
    mov di, ax
    
nextpos_score:
    pop dx              
    mov dh, 0x1F       
    mov [es:di], dx    
    add di, 2          
    loop nextpos_score  
    
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp
    ret 2
 seconds: dw 0
 tickcount: dw 0 
random:
    push dx
    mov ax, [random_seed]
    mov dx, 0x8405
    imul dx
    add ax, 1
    mov [random_seed], ax
    xor dx, dx
    mov cx, 26
    div cx
    mov ax, dx
    pop dx
    ret

; random letter
getrandomletter:
    call random
    add al, 65         
    mov ah, 0x00         
    ret


savebackground:
    push bp
    mov bp, sp
    push es
    push ds
    push si
    push di
    
    mov ax, 0xb800
    mov es, ax
    mov ax, cs
    mov ds, ax
    
    mov si, 0           
    mov di, bgbuffer    
    mov cx, 4000        
    
copyloop:
    mov al, [es:si]
    mov [di], al
    inc si
    inc di
    loop copyloop
    
    pop di
    pop si
    pop ds
    pop es
    pop bp
    ret


restorebackground:
    push bp
    mov bp, sp
    push es
    push ds
    push si
    push di
    
    mov ax, cs
    mov ds, ax
    mov ax, 0xb800
    mov es, ax
    
    mov si, bgbuffer    
    mov di, 0           
    mov cx, 4000        
    
restoreloop:
    mov al, [si]
    mov [es:di], al
    inc si
    inc di
    loop restoreloop
    
    pop di
    pop si
    pop ds
    pop es
    pop bp
    ret


printclouds:
    push bp
    mov bp,sp
    push es
    
    mov ax,0xb800
    mov es,ax
    
   
    mov al,80
    mov bl,[bp+6]
    add bl,1
    mul bl
    add ax,[bp+4]
    shl ax,1
    add ax,8
    mov di,ax
    mov cx,6
    mov ax,0x1FDB 
cloudwhite1:
    mov word[es:di],ax
    add di,2
    loop cloudwhite1
    
    ; row 2
    mov al,80
    mov bl,[bp+6]
    add bl,2
    mul bl
    add ax,[bp+4]
    shl ax,1
    add ax,8
    sub ax,4
    mov di,ax
    mov cx,11
    mov ax,0x1FDB 
cloudwhite2:
    mov word[es:di],ax
    add di,2
    loop cloudwhite2
    
    ; row 3
    mov al,80
    mov bl,[bp+6]
    add bl,3
    mul bl
    add ax,[bp+4]
    shl ax,1
    sub ax,2
    mov di,ax
    mov cx,16
    mov ax,0x1FDB 
cloudwhite3:
    mov word[es:di],ax
    add di,2
    loop cloudwhite3
    
    ; row 4
    mov al,80
    mov bl,[bp+6]
    add bl,4
    mul bl
    add ax,[bp+4]
    shl ax,1
    add ax,8
    sub ax,6
    mov di,ax
    mov cx,13
    mov ax,0x1FDB 
cloudwhite4:
    mov word[es:di],ax
    add di,2
    loop cloudwhite4
    
    
    mov al,80
    mov bl,[bp+6]
    mul bl
    add ax,[bp+4]
    shl ax,1
    add ax,8
    mov di,ax
    mov cx,3
    mov ax,0x17DB 
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
cloudgrey1:
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,164
    loop cloudgrey1
    sub di,4
    mov word[es:di],ax
    
    add di,158
    mov word[es:di],ax
    sub di,2
    mov word[es:di],ax
    sub di,2
    mov word[es:di],ax
    sub di,162
    mov word[es:di],ax
    
    add di,158
    mov word[es:di],ax
    sub di,2
    mov word[es:di],ax
    sub di,2
    mov word[es:di],ax
    sub di,162
    mov word[es:di],ax
    sub di,158
    mov word[es:di],ax
    sub di,158
    mov word[es:di],ax
    
    ; left diagonal
    mov al,80
    mov bl,[bp+6]
    mul bl
    add ax,[bp+4]
    shl ax,1
    add ax,8
    mov di,ax
    mov cx,3
    mov ax,0x17DB 
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    sub di,2
cloudgrey2:
    mov word[es:di],ax
    sub di,2
    mov word[es:di],ax
    add di,158
    loop cloudgrey2
    
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,162
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    sub di,158
    mov word[es:di],ax
    add di,162
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    
    pop es
    mov sp,bp
    pop bp
    ret 4


printheart:
    push bp
    mov bp,sp
    push es
    
    mov dx,0
    cmp dx,[bp+6]
    jne normal
    
    mov al,80
    mov bl,[bp+8]
    mul bl
    add ax,[bp+6]
    shl ax,1
    mov di,ax
    
    mov word[es:di],0x1120
    add di,2
    mov ax,0xb800
    mov es,ax
    mov cx,5
    mov ax,[bp+4]
heartrow1a:
    mov word[es:di],ax
    add di,2
    loop heartrow1a

    mov cx,3
    mov ax,0x1120
heartrow1b:
    mov word[es:di],ax
    add di,2
    loop heartrow1b

    mov cx,5
    mov ax,[bp+4]
heartrow1c:
    mov word[es:di],ax
    add di,2
    loop heartrow1c
    
    mov al,80
    mov bl,[bp+8]
    add bl,1
    mul bl
    add ax,[bp+6]
    shl ax,1
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,7
    mov ax,[bp+4]
heartrow2a:
    mov word[es:di],ax
    add di,2
    loop heartrow2a

    mov cx,1
    mov ax,0x1120
heartrow2b:
    mov word[es:di],ax
    add di,2
    loop heartrow2b

    mov cx,8
    mov ax,[bp+4]
heartrow2c:
    mov word[es:di],ax
    add di,2
    loop heartrow2c
    
    mov al,80
    mov bl,[bp+8]
    add bl,2
    mul bl
    add ax,[bp+6]
    shl ax,1
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,17
    mov ax,[bp+4]
heartrow3:
    mov word[es:di],ax
    add di,2
    loop heartrow3
    
    mov al,80
    mov bl,[bp+8]
    add bl,3
    mul bl
    add ax,[bp+6]
    shl ax,1
    add ax,2
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,14
    mov ax,[bp+4]
heartrow4:
    mov word[es:di],ax
    add di,2
    loop heartrow4

    mov al,80
    mov bl,[bp+8]
    add bl,4
    mul bl
    add ax,[bp+6]
    shl ax,1
    add ax,4
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,12
    mov ax,[bp+4]
heartrow5:
    mov word[es:di],ax
    add di,2
    loop heartrow5
    
    mov al,80
    mov bl,[bp+8]
    add bl,5
    mul bl
    add ax,[bp+6]
    add ax,2
    shl ax,1
    add ax,4
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,8
    mov ax,[bp+4]
heartrow6:
    mov word[es:di],ax
    add di,2
    loop heartrow6

    mov al,80
    mov bl,[bp+8]
    add bl,6
    mul bl
    add ax,[bp+6]
    add ax,4
    shl ax,1
    add ax,4
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,4
    mov ax,[bp+4]
heartrow7:
    mov word[es:di],ax
    add di,2
    loop heartrow7
	
	
    jmp printletter
    
normal:
    mov al,80
    mov bl,[bp+8]
    mul bl
    add ax,[bp+6]
    shl ax,1
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,5
    mov ax,[bp+4]
heartnorm1a:
    mov word[es:di],ax
    add di,2
    loop heartnorm1a

    mov cx,3
    mov ax,0x1120
heartnorm1b:
    mov word[es:di],ax
    add di,2
    loop heartnorm1b

    mov cx,5
    mov ax,[bp+4]
heartnorm1c:
    mov word[es:di],ax
    add di,2
    loop heartnorm1c

    mov al,80
    mov bl,[bp+8]
    add bl,1
    mul bl
    add ax,[bp+6]
    sub ax,2
    shl ax,1
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,8
    mov ax,[bp+4]
heartnorm2a:
    mov word[es:di],ax
    add di,2
    loop heartnorm2a

    mov cx,1
    mov ax,0x1120
heartnorm2b:
    mov word[es:di],ax
    add di,2
    loop heartnorm2b

    mov cx,8
    mov ax,[bp+4]
heartnorm2c:
    mov word[es:di],ax
    add di,2
    loop heartnorm2c

    mov al,80
    mov bl,[bp+8]
    add bl,2
    mul bl
    add ax,[bp+6]
    sub ax,2
    shl ax,1
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,18
    mov ax,[bp+4]
heartnorm3:
    mov word[es:di],ax
    add di,2
    loop heartnorm3

    mov al,80
    mov bl,[bp+8]
    add bl,3
    mul bl
    add ax,[bp+6]
    sub ax,1
    shl ax,1
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,15
    mov ax,[bp+4]
heartnorm4:
    mov word[es:di],ax
    add di,2
    loop heartnorm4

    mov al,80
    mov bl,[bp+8]
    add bl,4
    mul bl
    add ax,[bp+6]
    shl ax,1
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,13
    mov ax,[bp+4]
heartnorm5:
    mov word[es:di],ax
    add di,2
    loop heartnorm5

    mov al,80
    mov bl,[bp+8]
    add bl,5
    mul bl
    add ax,[bp+6]
    add ax,2
    shl ax,1
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,8
    mov ax,[bp+4]
heartnorm6:
    mov word[es:di],ax
    add di,2
    loop heartnorm6

    mov al,80
    mov bl,[bp+8]
    add bl,6
    mul bl
    add ax,[bp+6]
    add ax,4
    shl ax,1
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov cx,4
    mov ax,[bp+4]
heartnorm7:
    mov word[es:di],ax
    add di,2
    loop heartnorm7

printletter:
    mov al,80
    mov bl,[bp+8] ; starting row of heart
    add bl,3 ;go down this many rows for printing letter in centre
    mul bl
    add ax,[bp+6]
    add ax,6
    shl ax,1
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov ax,[bp+10]
	
    mov word [es:di],ax
	
	printoutline:
	 mov al,80
    mov bl,[bp+8]
	
    mul bl
    add ax,[bp+6]
    shl ax,1
    mov di,ax
    mov ax,0x00DB      ; black color for outline

    
    mov cx,4
    ; top row
    outline:
    mov word[es:di],ax
    add di,2
    loop outline
	mov word[es:di],ax
    add di,162
	mov word[es:di],ax
	add di,2
	mov word[es:di],ax
	sub di,158
	mov word[es:di],ax
	 mov cx,5
    ; top row
    outline2:
    mov word[es:di],ax
    add di,2
    loop outline2
		mov word[es:di],ax
    add di,162
	mov word[es:di],ax
	add di,2
	mov word[es:di],ax
	add di,162
	mov word[es:di],ax
	add di,158
	mov word[es:di],ax
	add di,158
	mov word[es:di],ax
	add di,158
	mov word[es:di],ax
	
	sub di,2
	mov word[es:di],ax
	sub di,2
	mov word[es:di],ax
	add di,158
	mov word[es:di],ax
	sub di,2
	mov word[es:di],ax
	sub di,2
	mov word[es:di],ax
	add di,158
	mov word[es:di],ax
	sub di,2
	mov word[es:di],ax
	sub di,2
	mov word[es:di],ax
	
	sub di,162
	mov word[es:di],ax
	sub di,2
	mov word[es:di],ax
	sub di,162
	mov word[es:di],ax
	sub di,2
	mov word[es:di],ax
	sub di,162
	mov word[es:di],ax
	sub di,162
	mov word[es:di],ax
	sub di,162
	mov word[es:di],ax
	sub di,158
	mov word[es:di],ax

sub di,2
	mov word[es:di],ax
		sub di,158
	mov word[es:di],ax
	add di,2
	mov word[es:di],ax

done:
    pop es
    mov sp,bp
    pop bp
    ret 8




displaygamescreen:
 mov ax,0xb800
    mov es,ax
    mov di,0
clearscreen:
    mov word[es:di],0x1120     
    add di,2
    cmp di,4000
    jne clearscreen

    
    mov ax,20
    push ax
    mov ax,30
    push ax
    call printclouds

    mov ax,18
    push ax
    mov ax,10
    push ax
    call printclouds

    mov ax,10
    push ax
    mov ax,42
    push ax
    call printclouds

    mov ax,15
    push ax
    mov ax,70
    push ax
    call printclouds

    mov ax,0
    push ax
    mov ax,53
    push ax
    call printclouds

    mov ax,3
    push ax
    mov ax,8
    push ax
    call printclouds

    mov ax,2
    push ax
    mov ax,32
    push ax
    call printclouds

    mov ax,4
    push ax
    mov ax,67
    push ax
    call printclouds
ret


    statusbar:
	
    mov ax,0xb800
    mov es,ax
    ;score label at row 0
    mov al,80
    mov bl,0
    mul bl
    add ax,5
    shl ax,1
    mov di,ax
    mov word[es:di],0x1F53      ; S
    add di,2
    mov word[es:di],0x1F63      ; c
    add di,2
    mov word[es:di],0x1F6F      ; o
    add di,2
    mov word[es:di],0x1F72      ; r
    add di,2
    mov word[es:di],0x1F65      ; e
    add di,2
    mov word[es:di],0x1F3A      ; :
    add di,2
    mov word[es:di],0x1F20      ; space
    add di,2
    mov word[es:di],0x1F30      ; 0

    ; Time label at row 0
    mov al,80
    mov bl,0
    mul bl
    add ax,35
    shl ax,1
    mov di,ax
    mov word[es:di],0x1F54      ; T
    add di,2
    mov word[es:di],0x1F69      ; i
    add di,2
    mov word[es:di],0x1F6D      ; m
    add di,2
    mov word[es:di],0x1F65      ; e
    add di,2
    mov word[es:di],0x1F3A      ; :
    add di,2
    mov word[es:di],0x1F20      ; space
    add di,2
    mov word[es:di],0x1F30      

    ;pause button at row 0
    mov al,80
    mov bl,0
    mul bl
    add ax,62
    shl ax,1
    mov di,ax
    mov word[es:di],0x7020      
    add di,2
    mov word[es:di],0x7050      ; P
    add di,2
    mov word[es:di],0x7061      ; a
    add di,2
    mov word[es:di],0x7075      ; u
    add di,2
    mov word[es:di],0x7073      ; s
    add di,2
    mov word[es:di],0x7065      ; e
    add di,2
    mov word[es:di],0x7020      
;call delay
    push word [cs: game_score]
	call printScore


ret



printthreehearts:
;witihin this func is da infinite animation loop running till exitflag 1 aka 20 sec
    push bp
    mov bp, sp
    
animate_loop:
    ;check if game pause by yk checking da flag 
    cmp byte [cs:pause_flag], 1;if yes paused den show pause screen duhh
    je show_pause_screen
    
    ;otherwise restore bg via buffer
    call restorebackground
    jmp draw_hearts
    
show_pause_screen:
    ;ooper say idher aya agr pause kerni ho toh
    call printgamepaused
    
pause_wait:
    ;infinite loop to yk chill while paused
    cmp byte [cs:pause_flag], 1
    je pause_wait
    
    ;wen pause ends restore bg
    call restorebackground
    
draw_hearts:
    cmp byte [cs:pause_flag], 1
    je animate_loop  ;zont drawballons if pause
    
	cmp byte [heart1_draw], 1
	je go_to_ballon2;esentialy dont draw heart agr pop ho chukka 
    
    ;red heart
    mov ax, [heart1_letter]
    mov ah, 0x4F;blek on red
    push ax
    mov ax, [heart1_col]
    push ax
    mov ax, 10
    push ax
    mov ax, 0x44DB
    push ax;pushing colr of heart and printing func call ya
    call printheart
	
	go_to_ballon2:
	
	cmp byte [heart2_draw], 1;is it popped or nah
	je go_to_ballon3;if pop thenskip drawing dis
    
    ;gren heart
    mov ax, [heart2_letter]
    mov ah, 0x2F;black on green
    push ax
    mov ax, [heart2_col]
    push ax
    mov ax, 12
    push ax
    mov ax, 0x23DB
    push ax
    call printheart
	
	go_to_ballon3:
	
	cmp byte [heart3_draw], 1
	je go_to_balloon4
    
    ;pink heart
    mov ax, [heart3_letter]
    mov ah, 0x5F        ;black on magenta
    push ax
    mov ax, [heart3_col]
    push ax
    mov ax, 60
    push ax
    mov ax, 0x3DDB
    push ax
    call printheart
	
	go_to_balloon4:
	
	cmp byte [heart4_draw], 1
	je go_to_balloon5
    
    ;yelo hart
    mov ax, [heart4_letter]
    mov ah, 0x6F        ;black on yellow
    push ax
    mov ax, [heart4_col]
    push ax
    mov ax, 30
    push ax
    mov ax, 0x6EDB
    push ax
    call printheart
	
	go_to_balloon5:
	
	cmp byte [heart5_draw], 1
	je go_to_balloon6
   
    ;cyan heart
    mov ax, [heart5_letter]
    mov ah, 0x3F        ;bllack on cyan
    push ax
    mov ax, [heart5_col]
    push ax
    mov ax, 50
    push ax
    mov ax, 0x3BDB
    push ax
    call printheart
	
	go_to_balloon6:
	
	cmp byte [heart6_draw], 1
	je all_balloons_checked
    
    ;magenta heart
    mov ax, [heart6_letter]
    mov ah, 0x5F        ;black on magenta
    push ax
    mov ax, [heart6_col]
    push ax
    mov ax, 20
    push ax
    mov ax, 0x5DDB
    push ax
    call printheart
	
	all_balloons_checked:

    call statusbar
    
    ;delay4lesss tweakin
    call delay

move_hearts:
    cmp byte [cs:pause_flag], 1
    je animate_loop  ;zont mov hearts if pause flag on
    
    ;mov heart up
    dec word [heart1_col]
    dec word [heart2_col]
    dec word [heart3_col]
    dec word [heart4_col]
    dec word [heart5_col]
    dec word [heart6_col]
    
    ;check if screen say nikel gya
    cmp word [heart1_col], -18
    jge check_heart2;agr yeh nazr araha aglay ki checking kero
    mov word [heart1_col], 80
    call getrandomletter
    mov [heart1_letter], ax
	mov byte [heart1_draw], 0
    
check_heart2:
    cmp word [heart2_col], -18
    jge check_heart3
    mov word [heart2_col], 80
    call getrandomletter
    mov [heart2_letter], ax
	mov byte  [heart2_draw], 0
    
check_heart3:
    cmp word [heart3_col], -18
    jge check_heart4
    mov word [heart3_col], 80
    call getrandomletter
    mov [heart3_letter], ax
	mov byte  [heart3_draw], 0
    
check_heart4:
    cmp word [heart4_col], -18
    jge check_heart5
    mov word [heart4_col], 80
    call getrandomletter
    mov [heart4_letter], ax
	mov  byte  [heart4_draw], 0
    
check_heart5:
    cmp word [heart5_col], -18
    jge check_heart6
    mov word [heart5_col], 80
    call getrandomletter
    mov [heart5_letter], ax
	mov  byte  [heart5_draw], 0
    
check_heart6:
    cmp word [heart6_col], -18
    jge check_key
    mov word [heart6_col], 80
    call getrandomletter
    mov [heart6_letter], ax
	mov  byte  [heart6_draw], 0
    
check_key:
    ;check exit flag
    cmp byte [exitflag], 1
    je exit_animation
    
    jmp animate_loop
    
exit_animation:
    pop bp
    ret
	
; delay:
    ; push cx
    ; mov cx, 0xFF00
; sleep1: 
    ; loop sleep1
    ; mov cx, 0xFF00
; l7:
    ; loop l7
    ; pop cx
    ; ret
	
	printskull:
    push bp
    mov bp,sp
    push es
    
    mov ax,0xb800
    mov es,ax
    mov al,80
    mov bl,[bp+6]
    
    mul bl
    add ax,[bp+4]
    shl ax,1
    
    mov di,ax
    mov cx,10
    mov ax,0x0FDB 
	
Line1:
    mov word[es:di],ax
    add di,2
    loop Line1
    
    mov ax,0xb800
    mov es,ax
    mov al,80
    mov bl,[bp+6]
    add bl,1
    mul bl
    add ax,[bp+4]
    shl ax,1
    sub ax,2
    mov di,ax
    mov cx,12
    mov ax,0x0FDB 
Line2:
    mov word[es:di],ax
    add di,2
    loop Line2
	
    mov ax,0xb800
    mov es,ax
    mov al,80
    mov bl,[bp+6]
    add bl,2
    mul bl
    add ax,[bp+4]
    shl ax,1
    sub ax,4
    mov di,ax
    mov cx,14
    mov ax,0x0FDB 
line3:
    mov word[es:di],ax
    add di,2
    loop line3
	
    
    mov ax,0xb800
    mov es,ax
    mov al,80
    mov bl,[bp+6]
    add bl,3
    mul bl
    add ax,[bp+4]
    shl ax,1
    sub ax,4
    mov di,ax
	
    mov cx,8
    mov ax,0x0FDB 
	
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],0x0720
    add di,2
	
    mov word[es:di],0x0720
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
	
    mov word[es:di],0x0720
    add di,2
    mov word[es:di],0x0720
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    
    
    mov ax,0xb800
    mov es,ax
    mov al,80
    mov bl,[bp+6]
    add bl,4
    mul bl
    add ax,[bp+4]
    shl ax,1
    sub ax,4
    mov di,ax
	
    mov cx,8
    mov ax,0x0FDB 
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
	
    mov word[es:di],0x0720
    add di,2
    mov word[es:di],0x0720
    add di,2
    mov word[es:di],0x0720
    add di,2
	
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
	
    mov word[es:di],0x0720
    add di,2
    mov word[es:di],0x0720
    add di,2
    mov word[es:di],0x0720
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
	
    
    mov ax,0xb800
    mov es,ax
    mov al,80
    mov bl,[bp+6]
    add bl,5
    mul bl
    add ax,[bp+4]
    shl ax,1
    mov di,ax
    mov cx,10
    mov ax,0x0FDB 
	
line6:
    mov word[es:di],ax
    add di,2
    loop line6
	
   
    mov ax,0xb800
    mov es,ax
    mov al,80
    mov bl,[bp+6]
    add bl,6
    mul bl
    add ax,[bp+4]
    shl ax,1
    mov di,ax
    mov cx,10
    mov ax,0x0FDB 
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],0x0720
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],0x0720
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
	
    pop es
    mov sp,bp
    pop bp
    ret 4
	
printClouds:
    push bp
    mov bp,sp
    push es
    
    mov ax,0xb800
    mov es,ax
    
    
    mov al,80
    mov bl,[bp+6]
    add bl,1
    mul bl
    add ax,[bp+4]
    shl ax,1
    add ax,8
    mov di,ax
    mov cx,6
    mov ax,0x1FDB 
cloudWhite1:
    mov word[es:di],ax
    add di,2
    loop cloudWhite1
    
    ;row 2
    mov al,80
    mov bl,[bp+6]
    add bl,2
    mul bl
    add ax,[bp+4]
    shl ax,1
    add ax,8
    sub ax,4
    mov di,ax
    mov cx,11
    mov ax,0x1FDB 
cloudWhite2:
    mov word[es:di],ax
    add di,2
    loop cloudWhite2
    
    ;row 3
    mov al,80
    mov bl,[bp+6]
    add bl,3
    mul bl
    add ax,[bp+4]
    shl ax,1
    sub ax,2
    mov di,ax
    mov cx,16
    mov ax,0x1FDB 
cloudWhite3:
    mov word[es:di],ax
    add di,2
    loop cloudWhite3
    
    ;row 4
    mov al,80
    mov bl,[bp+6]
    add bl,4
    mul bl
    add ax,[bp+4]
    shl ax,1
    add ax,8
    sub ax,6
    mov di,ax
    mov cx,13
    mov ax,0x1FDB 
cloudWhite4:
    mov word[es:di],ax
    add di,2
    loop cloudWhite4
    
    
    mov al,80
    mov bl,[bp+6]
    mul bl
    add ax,[bp+4]
    shl ax,1
    add ax,8
    mov di,ax
    mov cx,3
    mov ax,0x17DB 
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
cloudGrey1: ; outliningthickness of 2 pixels for outline diagno
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,164
    loop cloudGrey1
    sub di,4
    mov word[es:di],ax
    
    add di,158
    mov word[es:di],ax
    sub di,2
    mov word[es:di],ax
    sub di,2
    mov word[es:di],ax
    sub di,162 ; for going upwards diagnolly 1 pixwl only
    mov word[es:di],ax
    
    add di,158
    mov word[es:di],ax
    sub di,2
    mov word[es:di],ax
    sub di,2
    mov word[es:di],ax
    sub di,162
    mov word[es:di],ax
    sub di,158
    mov word[es:di],ax
    sub di,158
    mov word[es:di],ax
    
    ; left diagonal
    mov al,80
    mov bl,[bp+6]
    mul bl
    add ax,[bp+4]
    shl ax,1
    add ax,8
    mov di,ax
    mov cx,3
    mov ax,0x17DB 
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    sub di,2
cloudGrey2:
    mov word[es:di],ax
    sub di,2
    mov word[es:di],ax
    add di,158
    loop cloudGrey2
    
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    add di,162
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    sub di,158
    mov word[es:di],ax
    add di,162
    mov word[es:di],ax
    add di,2
    mov word[es:di],ax
    
    pop es
    mov sp,bp
    pop bp
    ret 4


printgamepaused:
    push bp
    mov bp,sp
    push es
    
    mov ax,0xb800
    mov es,ax
    
    mov bl,8 ; starting from almost centre of the screen
clearrow:
    mov al,80
    mul bl
    add ax,15
    shl ax,1
    mov di,ax
    mov cx,50 ; creating space to not create it over the clouds, by creating a rectangular
clearcol:
    mov word[es:di],0x1120  
    add di,2
    loop clearcol
    inc bl
    cmp bl,19 ; clearing rows 8to19
    jl clearrow
    
   ;G
    mov al,80
    mov bl,9
    mul bl
    add ax,20
    shl ax,1
    mov di,ax
    mov ax,0x1FDB     
    ;row 1
    mov word[es:di],ax
    mov word[es:di+2],ax
    mov word[es:di+4],ax
    mov word[es:di+6],ax
    mov word[es:di+8],ax
    ; r2
    mov word[es:di+160],ax
    ; r3
    mov word[es:di+320],ax
    mov word[es:di+326],ax
    mov word[es:di+328],ax
    ; r4
    mov word[es:di+480],ax
    mov word[es:di+488],ax
    ; r5
    mov word[es:di+640],ax
    mov word[es:di+642],ax
    mov word[es:di+644],ax
    mov word[es:di+646],ax
    mov word[es:di+648],ax
    
    ; A 
    mov al,80
    mov bl,9
    mul bl
    add ax,27
    shl ax,1
    mov di,ax
    mov ax,0x1FDB    
    ; row 1
    mov word[es:di+2],ax
    mov word[es:di+4],ax
    mov word[es:di+6],ax
    ; row 2
    mov word[es:di+160],ax
    mov word[es:di+168],ax
    ; row 3
    mov word[es:di+320],ax
    mov word[es:di+322],ax
    mov word[es:di+324],ax
    mov word[es:di+326],ax
    mov word[es:di+328],ax
    ; row 4
    mov word[es:di+480],ax
    mov word[es:di+488],ax
    ;row 5
    mov word[es:di+640],ax
    mov word[es:di+648],ax
    
    ; M
    mov al,80
    mov bl,9
    mul bl
    add ax,34
    shl ax,1
    mov di,ax
    mov ax,0x1FDB      
    ; r1
    mov word[es:di],ax
    mov word[es:di+8],ax
    ; r2
    mov word[es:di+160],ax
    mov word[es:di+162],ax
    mov word[es:di+166],ax
    mov word[es:di+168],ax
    ; r3
    mov word[es:di+320],ax
    mov word[es:di+324],ax
    mov word[es:di+328],ax
    ; r4
    mov word[es:di+480],ax
    mov word[es:di+488],ax
    ; r5
    mov word[es:di+640],ax
    mov word[es:di+648],ax
    
    ; E 
    mov al,80
    mov bl,9
    mul bl
    add ax,41
    shl ax,1
    mov di,ax
    mov ax,0x1FDB      
    ; r1
    mov word[es:di],ax
    mov word[es:di+2],ax
    mov word[es:di+4],ax
    mov word[es:di+6],ax
    mov word[es:di+8],ax
    ; r2
    mov word[es:di+160],ax
    ; r3
    mov word[es:di+320],ax
    mov word[es:di+322],ax
    mov word[es:di+324],ax
    mov word[es:di+326],ax
    ; r4
    mov word[es:di+480],ax
    ; r5
    mov word[es:di+640],ax
    mov word[es:di+642],ax
    mov word[es:di+644],ax
    mov word[es:di+646],ax
    mov word[es:di+648],ax
    
    ; paused P
    mov al,80
    mov bl,15
    mul bl
    add ax,20
    shl ax,1
    mov di,ax
    mov ax,0x1FDB      
    ;r1
    mov word[es:di],ax
    mov word[es:di+2],ax
    mov word[es:di+4],ax
    mov word[es:di+6],ax
    ; r2
    mov word[es:di+160],ax
    mov word[es:di+168],ax
    ; r3
    mov word[es:di+320],ax
    mov word[es:di+322],ax
    mov word[es:di+324],ax
    mov word[es:di+326],ax
    ;r4
    mov word[es:di+480],ax
    ;r5
    mov word[es:di+640],ax
    
    ; A 
    mov al,80
    mov bl,15
    mul bl
    add ax,26
    shl ax,1
    mov di,ax
    mov ax,0x1FDB     
    ; R1
    mov word[es:di+2],ax
    mov word[es:di+4],ax
    mov word[es:di+6],ax
    ; r2
    mov word[es:di+160],ax
    mov word[es:di+168],ax
    ; r3
    mov word[es:di+320],ax
    mov word[es:di+322],ax
    mov word[es:di+324],ax
    mov word[es:di+326],ax
    mov word[es:di+328],ax
    ;r4
    mov word[es:di+480],ax
    mov word[es:di+488],ax
    ;r5
    mov word[es:di+640],ax
    mov word[es:di+648],ax
    
    ; U
    mov al,80
    mov bl,15
    mul bl
    add ax,33
    shl ax,1
    mov di,ax
    mov ax,0x1FDB    
    ; r1
    mov word[es:di],ax
    mov word[es:di+8],ax
    ; r2
    mov word[es:di+160],ax
    mov word[es:di+168],ax
    ; r3
    mov word[es:di+320],ax
    mov word[es:di+328],ax
    ; r4
    mov word[es:di+480],ax
    mov word[es:di+488],ax
    ; r5
    mov word[es:di+640],ax
    mov word[es:di+642],ax
    mov word[es:di+644],ax
    mov word[es:di+646],ax
    mov word[es:di+648],ax
    
    ;S 
    mov al,80
    mov bl,15
    mul bl
    add ax,40
    shl ax,1
    mov di,ax
    mov ax,0x1FDB      
    ;r1
    mov word[es:di],ax
    mov word[es:di+2],ax
    mov word[es:di+4],ax
    mov word[es:di+6],ax
    mov word[es:di+8],ax
    ;r2
    mov word[es:di+160],ax
    ;r3
    mov word[es:di+320],ax
    mov word[es:di+322],ax
    mov word[es:di+324],ax
    mov word[es:di+326],ax
    mov word[es:di+328],ax
    ; r4
    mov word[es:di+488],ax
    ; r5
    mov word[es:di+640],ax
    mov word[es:di+642],ax
    mov word[es:di+644],ax
    mov word[es:di+646],ax
    mov word[es:di+648],ax
    
    ; E 
    mov al,80
    mov bl,15
    mul bl
    add ax,47
    shl ax,1
    mov di,ax
    mov ax,0x1FDB      
    ; r1
    mov word[es:di],ax
    mov word[es:di+2],ax
    mov word[es:di+4],ax
    mov word[es:di+6],ax
    mov word[es:di+8],ax
    ; r2
    mov word[es:di+160],ax
    ; r3
    mov word[es:di+320],ax
    mov word[es:di+322],ax
    mov word[es:di+324],ax
    mov word[es:di+326],ax
    ; r4
    mov word[es:di+480],ax
    ; r5
    mov word[es:di+640],ax
    mov word[es:di+642],ax
    mov word[es:di+644],ax
    mov word[es:di+646],ax
    mov word[es:di+648],ax
    
    ; D 
    mov al,80
    mov bl,15
    mul bl
    add ax,54
    shl ax,1
    mov di,ax
    mov ax,0x1FDB      
    ;r1
    mov word[es:di],ax
    mov word[es:di+2],ax
    mov word[es:di+4],ax
    mov word[es:di+6],ax
    ;r2
    mov word[es:di+160],ax
    mov word[es:di+168],ax
    ;r3
    mov word[es:di+320],ax
    mov word[es:di+328],ax
    ;r4
    mov word[es:di+480],ax
    mov word[es:di+488],ax
    ;r5
    mov word[es:di+640],ax
    mov word[es:di+642],ax
    mov word[es:di+644],ax
    mov word[es:di+646],ax
    
    pop es
    mov sp,bp
    pop bp
    ret

	
GamePaueseFunc:
    
    mov ax,0xb800
    mov es,ax
    mov di,0
clearsc:
    mov word[es:di],0x1120      
    add di,2
    cmp di,4000
    jne clearsc

    
    mov ax,18
    push ax
    mov ax,10
    push ax
    call printclouds

    mov ax,15
    push ax
    mov ax,70
    push ax
    call printclouds

    mov ax,3
    push ax
    mov ax,8
    push ax
    call printclouds

    mov ax,4
    push ax
    mov ax,67
    push ax
    call printclouds

    mov ax,20
    push ax
    mov ax,0
    push ax
    call printclouds

    mov ax,18
    push ax
    mov ax,62
    push ax
    call printclouds

    mov ax,1
    push ax
    mov ax,28
    push ax
    call printclouds

    
    call printgamepaused

  ;resume
    mov al,80
    mov bl,23
    mul bl
    add ax,67
    shl ax,1
    mov di,ax
    mov word[es:di],0x2020      
    add di,2
    mov word[es:di],0x2052      ; R
    add di,2
    mov word[es:di],0x2065      ; e
    add di,2
    mov word[es:di],0x2073      ; s
    add di,2
    mov word[es:di],0x2075      ; u
    add di,2
    mov word[es:di],0x206D      ; m
    add di,2
    mov word[es:di],0x2065      ; e
    add di,2
    mov word[es:di],0x2020      

    
    ret


GameOverFunc:
call playGameOverSound
    mov ax,0xb800
    mov es,ax
    mov di,0
Clearscreen:
    mov word[es:di],0x04db
    add di,2
    cmp di,4000
    jne Clearscreen

    ;drawing skulllls
    mov ax,1
    push ax
    mov ax,8
    push ax
    call printskull

    mov ax,1
    push ax
    mov ax,28
    push ax
    call printskull

    mov ax,1
    push ax
    mov ax,48
    push ax
    call printskull

    mov ax,1
    push ax
    mov ax,70
    push ax
    call printskull

    mov ax,18
    push ax
    mov ax,8
    push ax
    call printskull

    mov ax,18
    push ax
    mov ax,28
    push ax
    call printskull

    mov ax,18
    push ax
    mov ax,48
    push ax
    call printskull

    mov ax,18
    push ax
    mov ax,70
    push ax
    call printskull

    mov ax,0xb800
    mov es,ax

    ; G 1st row of game over
    mov al,80
    mov bl,11
    mul bl
    add ax,17
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    mov al,80
    mov bl,12
    mul bl
    add ax,17
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB

    mov al,80
    mov bl,13
    mul bl
    add ax,17
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,4
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    mov al,80
    mov bl,14
    mul bl
    add ax,17
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,6
    mov word[es:di],0x0EDB

    mov al,80
    mov bl,15
    mul bl
    add ax,17
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    ; A, row 1 of text
    mov al,80
    mov bl,11
    mul bl
    add ax,23
    shl ax,1
    mov di,ax
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    mov al,80
    mov bl,12
    mul bl
    add ax,23
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,6
    mov word[es:di],0x0EDB

    mov al,80
    mov bl,13
    mul bl
    add ax,23
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    mov al,80
    mov bl,14
    mul bl
    add ax,23
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,6
    mov word[es:di],0x0EDB

    mov al,80
    mov bl,15
    mul bl
    add ax,23
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,6
    mov word[es:di],0x0EDB

    ; M
    mov al,80
    mov bl,11
    mul bl
    add ax,29
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,10
    mov word[es:di],0x0EDB

    mov al,80
    mov bl,12
    mul bl
    add ax,29
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,6
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    ; row 13
    mov al,80
    mov bl,13
    mul bl
    add ax,29
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,4
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,4
    mov word[es:di],0x0EDB

    ; row 14
    mov al,80
    mov bl,14
    mul bl
    add ax,29
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,6
    mov word[es:di],0x0EDB
    add di,4
    mov word[es:di],0x0EDB

    ; row 15
    mov al,80
    mov bl,15
    mul bl
    add ax,29
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,10
    mov word[es:di],0x0EDB

    ;E
    mov al,80
    mov bl,11
    mul bl
    add ax,37
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    ; row 12
    mov al,80
    mov bl,12
    mul bl
    add ax,37
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB

    ; row 13
    mov al,80
    mov bl,13
    mul bl
    add ax,37
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    ;row 14
    mov al,80
    mov bl,14
    mul bl
    add ax,37
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB

    ; row 15
    mov al,80
    mov bl,15
    mul bl
    add ax,37
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    ;O
    mov al,80
    mov bl,11
    mul bl
    add ax,44
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    ; row 12
    mov al,80
    mov bl,12
    mul bl
    add ax,44
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,6
    mov word[es:di],0x0EDB

    ; row 13
    mov al,80
    mov bl,13
    mul bl
    add ax,44
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,6
    mov word[es:di],0x0EDB

    ; row 14
    mov al,80
    mov bl,14
    mul bl
    add ax,44
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,6
    mov word[es:di],0x0EDB

    ; row 15
    mov al,80
    mov bl,15
    mul bl
    add ax,44
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    ;V
    mov al,80
    mov bl,11
    mul bl
    add ax,50
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,8
    mov word[es:di],0x0EDB

    ; row 12
    mov al,80
    mov bl,12
    mul bl
    add ax,50
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,8
    mov word[es:di],0x0EDB

    ; row 13
    mov al,80
    mov bl,13
    mul bl
    add ax,50
    shl ax,1
    mov di,ax
    add di,2
    mov word[es:di],0x0EDB
    add di,4
    mov word[es:di],0x0EDB

    ; row 14
    mov al,80
    mov bl,14
    mul bl
    add ax,50
    shl ax,1
    mov di,ax
    add di,2
    mov word[es:di],0x0EDB
    add di,4
    mov word[es:di],0x0EDB

    ; row 15
    mov al,80
    mov bl,15
    mul bl
    add ax,50
    shl ax,1
    mov di,ax
    add di,4
    mov word[es:di],0x0EDB

    ;E
    mov al,80
    mov bl,11
    mul bl
    add ax,56
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    ; row 12
    mov al,80
    mov bl,12
    mul bl
    add ax,56
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB

    ; row 13
    mov al,80
    mov bl,13
    mul bl
    add ax,56
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    ; row 14:
    mov al,80
    mov bl,14
    mul bl
    add ax,56
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB

    ; row 15
    mov al,80
    mov bl,15
    mul bl
    add ax,56
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    ;R
    mov al,80
    mov bl,11
    mul bl
    add ax,62
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    ; row 12
    mov al,80
    mov bl,12
    mul bl
    add ax,62
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,6
    mov word[es:di],0x0EDB

    ; row 13
    mov al,80
    mov bl,13
    mul bl
    add ax,62
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB
    add di,2
    mov word[es:di],0x0EDB

    mov al,80
    mov bl,14
    mul bl
    add ax,62
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,4
    mov word[es:di],0x0EDB

    mov al,80
    mov bl,15
    mul bl
    add ax,62
    shl ax,1
    mov di,ax
    mov word[es:di],0x0EDB
    add di,6
    mov word[es:di],0x0EDB

    ;print final score
    mov ax,0xb800
    mov es,ax
    mov al,80
    mov bl,9
    mul bl
    add ax,28
    shl ax,1
    mov di,ax
    
    mov word[es:di],0x0E46      ; F
    add di,2
    mov word[es:di],0x0E69     ; i
    add di,2
    mov word[es:di],0x0E6E     ; n
    add di,2
    mov word[es:di],0x0E61     ; a
    add di,2
    mov word[es:di],0x0E6C     ; l
    add di,2
    mov word[es:di],0x0E20     ; space
    add di,2
    mov word[es:di],0x0E53     ; S
    add di,2
    mov word[es:di],0x0E63     ; c
    add di,2
    mov word[es:di],0x0E6F     ; o
    add di,2
    mov word[es:di],0x0E72     ; r
    add di,2
    mov word[es:di],0x0E65     ; e
    add di,2
    mov word[es:di],0x0E3A     ; :
    add di,2
    mov word[es:di],0x0E20     ; space

    ;printing score
    push bp
    mov bp, sp
    push es
    push ax
    push bx
    push cx
    push dx
    push di

    mov ax, 0xb800
    mov es, ax
    mov ax, [game_score]       
    mov bx, 10                
    mov cx, 0                  

nextdigit_final:
    mov dx, 0                  
    div bx                     
    add dl, 0x30               
    push dx                    
    inc cx                    
    cmp ax, 0                 
    jnz nextdigit_final        

   
    mov al, 80
    mov bl, 9
    mul bl
    add ax, 40
    shl ax, 1
    mov di, ax

    ;clearing pichla score
    mov word [es:di], 0x0E20
    mov word [es:di+2], 0x0E20
    mov word [es:di+4], 0x0E20
    mov word [es:di+6], 0x0E20
    mov word [es:di+8], 0x0E20

    ;resettin gpos
    mov al, 80
    mov bl, 9
    mul bl
    add ax, 42
    shl ax, 1
    mov di, ax

nextpos_final:
    pop dx                    
    mov dh, 0x0E              
    mov [es:di], dx            
    add di, 2                  
    loop nextpos_final         

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp

    ; restart button
    mov ax,0xb800
    mov es,ax
    mov al,80
    mov bl,23
    mul bl
    add ax,60
    shl ax,1
    mov di,ax
    mov word[es:di],0x2020     ; clear with green
    add di,2
    mov word[es:di],0x2052     ; r
    add di,2
    mov word[es:di],0x2065     ; e
    add di,2
    mov word[es:di],0x2073     ; s
    add di,2
    mov word[es:di],0x2074     ; t
    add di,2
    mov word[es:di],0x2061     ; a
    add di,2
    mov word[es:di],0x2072     ; r
    add di,2
    mov word[es:di],0x2074     ; t
    add di,2
    mov word[es:di],0x2020     ; bg green
    ret
	
	cleanup:
    ;restore og timer int handler
	;werna crashing so do unhooka
    cli
    push ds
    xor ax, ax
    mov ds, ax
    mov ax, [cs:oldTimeisr]
    mov [ds:8*4], ax
    mov ax, [cs:oldTimeisr+2]
    mov [ds:8*4+2], ax
    pop ds
    sti
    
    ;unhoki keybord int
	cli
    xor ax,ax
    mov es,ax
    mov ax,[oldisr]
    mov [es:9*4],ax
    mov ax,[oldisr+2]
    mov [es:9*4+2],ax
	sti
	
	ret
    
start:
    call displaystartscreen
    mov ah, 00h
    int 16h;waiting for any keypres
    
    call displaygamescreen
	call playStartSound 
    call savebackground
	
	start2:;added for restratignggggg
    
    ;saving old timer isr
    xor ax, ax 
    mov es, ax
    mov ax, [es:8*4] 
    mov [oldTimeisr], ax
    mov ax, [es:8*4+2] 
    mov [oldTimeisr+2], ax
    
    ;saving keyboard interrupt
    mov ax, [es:9*4] ;offset getting
    mov [oldisr], ax
    mov ax, [es:9*4+2] ;seg getting
    mov [oldisr+2], ax
    
    cli;disabling intesruptsss
    ;hook keyboarddd
    mov word [es:9*4], beginisr
    mov [es:9*4+2], cs
    
    ;hook timerrerereer
    mov word [es:8*4], timer
    mov [es:8*4+2], cs
    sti;reenabling da intsss
	;resetiing stuff cuz new gem may koi seizure nah ho
	mov word [seconds], 0
	mov word [game_score], 0
	mov byte [exitflag], 0
	
	mov word [heart1_col], 80
	mov word [heart2_col], 70
	mov word [heart3_col], 60
	mov word [heart4_col], 50
	mov word [heart5_col], 30
	mov word [heart6_col], 20
	
	mov word [heart1_letter], 0x1F41
	mov word [heart2_letter], 0x1F42
	mov word [heart3_letter], 0x1F43
	mov word [heart4_letter], 0x1F44
	mov word [heart5_letter], 0x1F45
	mov word [heart6_letter], 0x1F46
	
	mov byte [heart2_draw], 0
	mov byte [heart3_draw], 0
	mov byte [heart1_draw], 0
	mov byte [heart4_draw], 0
	mov byte [heart5_draw], 0
	mov byte [heart6_draw], 0
    ;da mainthing yah yah
    call printthreehearts
    
    call cleanup
	
	mov ah, 00
	int 16h;wait for keypress 
	;now compare if da pressed key twinning with r cuz if yes we hv to restart game by jumping start2 per
	cmp al, 'r'
	je start2
	
	mov ax, 0x4C00
    int 21h;
	