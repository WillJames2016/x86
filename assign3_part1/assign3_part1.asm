;Michael
;02/7/17
;CS3140 Assignment 3
;command line to assemble into 32 bit Linux object file: nasm -f elf32 -g assign3_part1.asm
;nasm -f elf32 assign3_part1.asm
;command line to link into 32 bit Linux executable file: ld -o assign3_part1 -m elf_i386 assign3_part1.o
;comand line details to run program: ./assign3_part1
;Enter up to but not exceeding 200 characters at command line. Terminate with end of line return

bits 32							;Tell NASM using 32 bit compiliation

section .text   				;section declaration for Assembly Code	

global _start					;make _start symbol visible to linker 

_start:

; read a buffer of up to 200 chars from stdin:
read:
        mov eax,3        		;Specify sys_read call
        mov ebx,0        		;Specify 0 (stdin)file descriptor 
        mov ecx,Buff     		;Pass offset of the buffer to read to
        mov edx,BUFFLEN  		;Pass number of bytes to read at one pass
        int 0x80        		;0x80 is EXECUTE sys_read command to fill the buffer
        mov esi,eax     		;Copy sys_read return value
        cmp eax,0     			;If eax=0x0A, sys_read terminates b/c reached EOL from stdin
        jle Done          		;Jump If comparisison value in EAX is Equal to 0

; Set up the registers for the process buffer step:
        mov ecx,esi      		;copying the sys-read from stdin from esi to ecx of bytes read in ecx
        mov ebp,Buff     		;Place address of buffer into ebp
		mov edi, [Buff]	  		;copy value of Buff (200) into esi
		mov [output_ctr],edi	;Copy value of edi (200) into output_ctr 

; Iterate through the buffer and convert ASCII characters to HEX:
Scan:
		
		cmp edi, 1					;compare output_ctr to 1
		je Done
		dec byte [output_ctr]		;decrement output_ctr
		mov edi, [output_ctr]		;Copy updated output_ctr value into edi
		mov dl, [ebp]				;pass pointer to value of Buff [ebp]
		mov [temp], dl  			;temp to hold shifted value
		shr dl, 4					;shift right 4 to keep MSB and eliminate 4 LSB 	
		add dl, 48					;ascii 48(char 0)- 57(char 9) ascii equivalents 
		cmp dl, 57
		jle print1			  		;if dl less than 57 break
		add dl, 7			  		;else add 7, ascii 65(char A)- 70(char F) ascii equivalents	

print1:
		mov [ascii],dl				;pass dl pointer to ascii
		mov ecx,ascii				;copy ascii digit to ecx
		mov eax,4					;Specify sys_write call
		mov ebx,1					;1 is Standard OUT - CONSOLE
		mov edx,1					;print 1 byte
		int 0x80					;Make sys_write kernel call
		mov dl,[ebp] 				;pass pointer to Buff [ebp]
		mov dl, [temp]  			;temp to hold shifted value	
		and dl,0xf					;Keep the 4 LSB
		add dl, 48					;ascii 48(char 0)- 57(char 9) ascii equivalents 
		cmp dl, 57
		jle print2			  		;if dl less than 57 break
		add dl, 7			  		;else add 7, ascii 65(char A)- 70(char F) ascii equivalents	
		
print2:
		mov [ascii],dl				;pass dl pointer to ascii
		mov ecx,ascii				;copy ascii digit to ecx
		mov eax,4					;Specify sys_write call
		mov ebx,1					;1 is Standard OUT - CONSOLE
		mov edx,1					;print 1 byte
		int 0x80					;Make sys_write kernel call
		inc ebp          			;Adjust count of offset to advance to next byte
		mov byte [ascii],32 		;add space
		mov eax,4					;Specify sys_write call
		int 0x80					;Make sys_write kernel call
break:
		cmp byte[temp], 0x0A 		;check if byte read is EOL from stdin
		je Done				  		;If check break out of Scan	
		jmp Scan			  		;repeat Scan loop	

Done:
        mov eax,1        			;Code for Exit Syscall
        int 0x80         			;Make sys_exit kernel call

		section .data   			;section declaration for initialized
BUFFLEN equ 200
		section .bss    			;section declaration for unitialized
Buff: resb BUFFLEN
ascii:	resb 1
temp: resb 1
output_ctr resb 1
