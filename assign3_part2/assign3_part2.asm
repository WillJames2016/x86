;Michael
;02/13/17
;CS3140 Assignment 3
;command line to assemble into 32 bit Linux object file: nasm -f elf32 -g assign3_part2.asm
;nasm -f elf32 assign3_part2.asm
;command line to link into 32 bit Linux executable file: ld -o assign3_part1 -m elf_i386 assign3_part2.o
;comand line details to run program: ./assign3_part2
;Enter up to but not exceeding 200 characters at command line. Terminate with end of line return

bits 32							;Tell NASM using 32 bit compiliation

section .data   			;section declaration for initialized

section .bss    			;section declaration for unitialized
offset resd 1

section .text   				;section declaration for Assembly Code	

global main						; Required so linker can find entry point
extern printf
extern exit
	
main:
; Set up stack frame, preserve ebp, ebx, esi, edi
stackUP:
    push ebp		; Set up stack frame
	mov ebp,esp		; Bookmark stack pointer in ebp	
	push ebx		
	push esi
	push edi
	
; Handle argv arguments 	
argv:
	mov ebp, [esp +8] 	; copy value of base argv pointer in  ebp 
	mov eax, 0			; copy zero to eax
	mov [offset], eax	;set argv offset to zero 
	mov ebx, [offset]	; copy offset value of zero into ebx
	mov eax,[ebp + ebx*4] 	; Base + offset - Standardize pointer advancement of ArgV array of pointers
	cmp eax, 0			; check for string terminated by zero					
	je enviro			; jump to enviro after reaching null terminator
	push eax			;parameter to printf
	call printf			; Call printf() to display 
	add esp,8 			; Clean up stack
	mov eax, [offset]	; copy offset value to eax
	inc eax				; increment offset (eax)
	jmp argv			; repeat argv loop
	
; Handle envp arguments	
enviro:
	mov ebp, [esp +12] ; copy value of base of envp pointers, Access environment array pointers 
	mov eax, 0			; copy zero to eax
	mov [offset], eax	; set argv offset to zero 
	mov ebx, [offset]	; copy offset value of zero into ebx
	mov eax,[ebp + ebx*4] 	; Base + offset - Standardize pointer advancement of ArgV array of pointers
	cmp eax, 0			; check for string terminated by zero					
	je stackDOWN		; jump to stackDOWN after reaching null terminator
	push eax			;parameter to printf
	call printf			; Call printf() to display 
	add esp, 12 		; Clean up stack
	mov eax, [offset]	; copy offset value to eax
	inc eax				; increment offset (eax)
	jmp enviro			; repeat enviro loop
	
; Restore saved registers
stackDOWN:
	pop edi			; Restore saved registers
	pop esi
	pop ebx
	mov esp,ebp		; Destroy stack frame before returning
	pop ebp
	xor eax,eax		; return value of zero
	push eax		; parameter to exit
	call exit	
;	ret				; Return control to Caller

	

