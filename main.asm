INCLUDE Irvine32.inc
comment /* -------------------------------------------------------------------------------------------------------------------
	Hint --> What index Represent For
	instruction_index --> represent which instruction user use [S.T] 0 Means Mov , 1 Means Add ... ect Till 7
	Destenation_index and Source_index [if source is register] --> represent which register user use [S.T] 0 Means Eax , 1 Means Ebx 
	till 7 then from 8 to 11 represent Ax , Bx , ...ect Respectively then from 12 to 19 represent Al , Ah , ..ect Respectively
	20 represent Memory variable

	***Important Tip:
		Every instruction and Register MUST Start with Capital Char AS Eax , Mov [NOT] eax , mov
	--------------------------------------------------------------------------------------------------------------------------------*/
.DATA
	;	-- Line Variales --
	line byte 50 dup(?)
	inst byte 5 dup(?),0
	des byte 8 dup(?),0
	sor byte 32 dup(?),0
	user_variable byte ?

	;	-- constants --
	D_Word_Registers_counter byte 4
	Word_Register_counter byte 3
	byte_Registers_counter byte 3
	Equal_symbol byte " = ",0

	Hint byte "Please Follow Our Instructions :)",0
	Hint_1 byte "- Don't Forget To Put at Each Start a CAPITAL Charachter.",0
	Hint_4 byte "- To Define Variable you Can write [Me]. ",0
	Hint_2 byte "- Write Exit To Finish Coding. ",0
	Hint_3 byte "OK So Now Lets Start Coding ...",0

	output byte '>> ',0
	Neg_zero_Error byte "Can't Negate Zero .",0
	Over_Flow_Error byte "There is overflow Do you wanna continue (Y-N) ?",0
	Source_Not_Found_Error byte "Invalid Source Operand. ",0
	Destenation_Not_Found_Error byte "Invalid Destenation Operand. ",0
	Instruction_Not_Found_Error byte "Invalid Instruction Name. ",0
	Not_Found byte "undefined symbol",0
	Not_same byte "instruction operands must be the same size",0
	same_size byte "both source and destination are same size .. start your instuction from which i have called",0
	
	;	-- instructions and Registers array --
	Instructions_array byte "Mov",0,"Add",0,"Sub",0,"Mul",0,"Div",0,"Neg",0
	Mov_sign_instruction byte "Movzx",0,"Movsx",0
	D_Word_Registers byte "Eax",0,"Ebx",0,"Ecx",0,"Edx",0,"Esi",0,"Edi",0,"Esp",0,"Ebp",0
	Word_Registers byte "Ax",0,"Bx",0,"Cx",0,"Dx",0
	Byte_Registers byte "Al",0,"Ah",0,"Bl",0,"Bh",0,"Cl",0,"Ch",0,"Dl",0,"Dh",0,"Me",0

	Close_Prog byte 'Exit',0
	call_write_int byte "WriteInt",0
	call_dump_regs byte "DumpRegs",0
	call_inst byte 'Call',0
	counter byte 0
	outer_loop_counter dword ?
	inner_loop_counter dword ?
	counter_for_Check_instruction_Proc dword ?
	instruction_index dword ?
	Destenation_index dword ?
	source_index dword ?
	current_value_Dword dword ?
	current_value_Dword_2 dword ?
	current_value_word word ?
	current_value_word_2 word ?
	current_value_byte byte ?
	current_value_byte_2 byte ?
	Converted_number dword ?
	check dword 1
	key Dword 1
	clear byte 32 dup(?)

.code
;	-- check_validation Procedure --
;----------------------------------------
check_validation proc ,dest_num:Dword , sour_num:Dword  ;-------procedure that chack validation of the compination of dource and destination --------
CMP dest_num , 100                                 ;---- if
JE Notfound                                         ;---- destination or source
CMP sour_num , 100                                  ;---- not found 
JE Notfound                                         ;---- in the array

CMP dest_num , 7
jBE check_If_Source_Is_DWORD_too                    ;if you found that distination is 32-bit
CMP dest_num , 11
JBE check_If_Source_Is_WORD_too                     ;if you found that distination is 16-bit
JA check_if_source_Is_byte_too                      ;if you found that distination is 8-bit

check_If_Source_Is_DWORD_too:
CMP sour_num , 7
JBE valid_both_destinasion_and_source                ;check if source also is DWORD
JA NOT_Same_size

check_If_Source_Is_WORD_too:
CMP sour_num , 7
JBE NOT_Same_size
CMP sour_num , 11
JBE valid_both_destinasion_and_source                 ;check if source also is WORD
jA NOT_Same_size

check_If_Source_Is_byte_too:
CMP sour_num , 11
JA valid_both_destinasion_and_source                 ;check if source also is byte
jBE NOT_Same_size
 Notfound:
	 mov edx,offset Not_found
	 call writestring
	 call crlf
	mov key , 0
	jmp Exite											;display "undefined symbol"
	
 NOT_Same_size:
	 mov edx , offset Not_same
	 call writestring                                    ;display "instruction operands must be the same size"
	 mov key , 0
	 call crlf
	jmp Exite

 valid_both_destinasion_and_source:
	mov key , 1
	Exite:
		
	ret
check_validation ENDP
main PROC
	
	Call Hint_Messages
			
		L:
		Call ReIntiallize_Indecies
		mov ecx ,50
		mov edx,offset line
		call readstring
		
		mov esi,offset line
		Push eax
		mov eax,0
		mov dword ptr inst, eax
		pop eax
		mov edi ,offset inst
		mov ecx,eax
		Call Split_Line
		
		CLD
		mov esi, offset inst
		mov edi, offset call_inst
		Mov Ecx, lengthof call_inst
		REPE CMPSb
		JNE search_for_exit
		for_Call_Write_int:
			mov edx, offset output
			Call writeString
			mov esi, offset des
			mov edi, offset call_write_int
			Mov Ecx, lengthof call_write_int
			REPE CMPSb
			JNE for_Call_Dump_Regs
			POPAD
			Call WriteInt
			PUSHAD
			Call Crlf
			JMP iam_finsished
		for_Call_Dump_Regs:
			mov esi, offset des
			mov edi, offset call_dump_regs
			Mov Ecx, lengthof call_dump_regs
			REPE CMPSb
			JNE search_for_exit
			POPAD

			Call DumpRegs
			PUSHAD
			JMP iam_finsished

		search_for_exit:
			mov esi, offset inst
			mov edi, offset Close_Prog
			Mov Ecx, lengthof Close_Prog
			REPE CMPSb
			JNE Continue
			Jmp iam_finsished

		Continue:
			;	-- Get indecies for line parts [ instruction - source - Destenation ] --
			Call Get_instruction_index
			Call Get_Destintion_index
			Call Get_Source_index
			cmp Source_index,100
			JE cont
	;----------------------------------------------------------------------------------------
	invoke check_validation , Destenation_index, Source_index
	Cmp key ,0
	JE L
	;-------------------------------------------------------------------------------------
			;	-- To get 8 Defined registers --
			cont:
			CMP check,1
			JNE Not_First_Time
			First_Time :
				Call Intialize_Registers
				Call Eight_Instructions
				PUSHAD
				DEC check
				JMP L

			Not_First_Time:
				POPAD
				Call Eight_Instructions
				PUSHAD
	jmp L
	iam_finsished:
	exit
main ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------
										;		---- Our Own Procedures --
								;---------------------------------------------------------------
;	--- Over_Flow Procedure ---
Over_Flow Proc
    mov edx, offset Over_Flow_Error
    Call WriteString
    Call Crlf
    Call ReadChar
    Mov Edx,offset output
    Call WriteString
    Call writeChar
    Call Crlf
    CMP AL,'y'
    JNE exit_add
    Mov Edx,offset output
    Call WriteString
    Mov Edx,offset des
    Call WriteString
    Mov Edx, offset Equal_symbol
    Call writeString
    Call WriteDec
    Call Crlf
	exit_add:
    ret
Over_Flow Endp

;-----------------------------------------------------------------------------------------------------------------------------------------
;	-- Hint_Messages Procedure --
Hint_Messages Proc
	Mov Edx, offset Hint
	Call WriteString
	Call Crlf
	Mov Edx, offset Hint_1
	Call WriteString
	Call Crlf
	Mov Edx, offset Hint_4
	Call WriteString
	Call Crlf
	Mov Edx, offset Hint_2
	Call WriteString
	Call Crlf
	Call Crlf
	Mov Edx, offset Hint_3
	Call WriteString
	Call Crlf
	ret
Hint_Messages Endp

;-----------------------------------------------------------------------------------------------------------------------------------------
;		-- Get_instruction_index Procedure --
Get_instruction_index Proc
	mov esi , offset inst
	mov ecx , 5
	Call Get_instruction_Length

	cmp eax , 5								; eax --> hold the return value of procedure	
	JNE to_instruction_Array

	mov edi , offset Mov_sign_instruction
	mov edx , offset inst
	mov outer_loop_counter , 2						; 2 --> Number of elements at Instructions_array
	mov inner_loop_counter , 5						; 5 --> Number of charachters for each element at Instructions_array
	mov counter_for_Check_instruction_Proc , 6		; 6 --> bytes to get next element for array
	mov counter , 6
	Call Check_instruction
	jmp cancel_it_1

	to_instruction_Array :
		mov edi , offset Instructions_array
		mov edx , offset inst
		mov outer_loop_counter , 6						; 6 --> Number of elements at Instructions_array
		mov inner_loop_counter , 3						; 3 --> Number of charachters for each element at Instructions_array
		mov counter_for_Check_instruction_Proc , 4		; 4 --> bytes to get next element for array
		Call Check_instruction

	cancel_it_1: 
		mov instruction_index , eax
	ret
Get_instruction_index Endp

;-------------------------------------------------------------------------------------------------------------------------------------------------
;		-- Get_Destintion_index Procedure --
Get_Destintion_index Proc
	mov esi , offset des
	mov ecx , 3
	Call Get_instruction_Length

	cmp eax , 3							; eax --> hold the return value of procedure
	JE to_Dword_Array
	JNE to_word_Array

	to_Dword_Array :
		mov edi , offset D_Word_Registers
		mov edx , offset des
		mov outer_loop_counter , 8						; 8 --> Number of elements at Instructions_array
		mov inner_loop_counter , 3						; 3 --> Number of charachters for each element at Instructions_array
		mov counter_for_Check_instruction_Proc , 4		; 4 --> bytes to get next element for array
		mov counter , 0
		Call Check_instruction
	Jmp cancel_it_2

	to_word_Array :
		mov esi , offset des
		Call Check_Register			; used to check if it word or byte
		cmp eax , 0

		JNE iam_byte
		mov edi , offset Word_Registers
		mov edx , offset des
		mov outer_loop_counter , 4						; 4 --> Number of elements at Instructions_array
		mov inner_loop_counter , 2						; 2 --> Number of charachters for each element at Instructions_array
		mov counter_for_Check_instruction_Proc , 3		; 3 --> bytes to get next element for array
		mov counter , 8
		Call Check_instruction
		jmp cancel_it_2

		iam_byte:
			mov edi , offset byte_Registers
			mov edx , offset des
			mov outer_loop_counter , 9						; 9 --> Number of elements at Instructions_array
			mov inner_loop_counter , 2						; 2 --> Number of charachters for each element at Instructions_array
			mov counter_for_Check_instruction_Proc , 3		; 3 --> bytes to get next element for array
			mov counter , 12
			Call Check_instruction

	cancel_it_2:
		mov Destenation_index , eax
	ret
Get_Destintion_index Endp

;-------------------------------------------------------------------------------------------------------------------------------------------------
;		-- Get_Source_index Procedure --
Get_Source_index Proc
	Call Check_String
	cmp eax , 0

	JE its_Register_go
	mov esi , offset sor
	mov ecx , 32
	Call Get_instruction_Length
	dec eax
	mov ebx , eax

	Call Convert_String_To_Number
	mov source_index , 100									; 100 -> is a value to stop matching to any register
	jmp go_to_instruction
	its_Register_go:
		mov esi , offset sor
		mov ecx , 3
		Call Get_instruction_Length
		cmp eax , 3											; eax --> hold the return value of procedure
		JE to_Dword_Array_1
		JNE to_word_Array_1
		to_Dword_Array_1 :
			mov edi , offset D_Word_Registers
			mov edx , offset sor
			mov outer_loop_counter , 8						; 8 --> Number of elements at Instructions_array
			mov inner_loop_counter , 3						; 3 --> Number of charachters for each element at Instructions_array
			mov counter_for_Check_instruction_Proc , 4		; 4 --> bytes to get next element for array
			mov counter , 0
			Call Check_instruction
		Jmp cancel_it_3
		to_word_Array_1 :
			mov esi , offset sor
			Call Check_Register
			cmp eax , 0
			JNE iam_byte_1
				mov edi , offset Word_Registers
				mov edx , offset sor
				mov outer_loop_counter , 4						; 4 --> Number of elements at Instructions_array
				mov inner_loop_counter , 2						; 2 --> Number of charachters for each element at Instructions_array
				mov counter_for_Check_instruction_Proc , 3		; 3 --> bytes to get next element for array
				mov counter , 8
				Call Check_instruction
				jmp cancel_it_3

			iam_byte_1:
				mov edi , offset byte_Registers
				mov edx , offset sor
				mov outer_loop_counter , 9						; 4 --> Number of elements at Instructions_array
				mov inner_loop_counter , 2						; 2 --> Number of charachters for each element at Instructions_array
				mov counter_for_Check_instruction_Proc , 3		; 3 --> bytes to get next element for array
				mov counter , 12
				Call Check_instruction
		cancel_it_3:
			mov source_index , eax
	go_to_instruction:
	ret
Get_Source_index Endp

;-------------------------------------------------------------------------------------------------------------------------------------------------
;--	Split_Line Procedure---
Split_Line Proc
push eax
mov eax,0
mov dword ptr des, eax
mov dword ptr sor, eax
pop eax
	L1:
		lodsb
		cmp al,' '
		je L2 
		stosb
	Loop L1
	cmp ecx,0
	je L6
	L2:
		lodsb
		cmp al,' '
		jne opp1 
	Loop L2
	cmp ecx,0
	je L6
	opp1:
		mov edi ,offset des
		stosb
	L3:
		lodsb
		cmp al,' '
		je L4
		cmp al,','
		je L4
		cmp al,';'
		je L6
		stosb
	Loop L3
	cmp ecx,0
	je L6
	L4:
		lodsb
		cmp al,' '
		je nex
		cmp al,','
		jne opp2
		cmp al,';'
		je L6
		nex:
	Loop L4
	cmp ecx,0
	je L6
	opp2:
		mov edi ,offset sor
		stosb
	L5:
		lodsb
		cmp al,' '
		je L6
		cmp al,';'
		je L6
		stosb
	Loop L5
	L6:
	ret
Split_Line Endp

;---------------------------------------------------------------------
; -- Check_instruction Procedure --
Check_instruction Proc
	CLD
	mov ecx , outer_loop_counter			
	to_get_valid_instruction:
		push ecx
		mov esi , edx
		mov ecx, inner_loop_counter			
		push edi
		to_check_chars_The_Same:
			cmpsb
			Jne not_the_same_do_it_again
		Loop to_check_chars_The_Same
		mov al , counter
		Jmp I_finished
		not_the_same_do_it_again:
			pop edi
			pop ecx
			inc counter
			add edi , counter_for_Check_instruction_Proc
	Loop to_get_valid_instruction
	mov eax,100
	cmp eax,100
	JE Exit_it
	I_finished:
	pop edi
	pop ecx
	Exit_it:
	ret
Check_instruction Endp
;----------------------------------------------------

; -- Get_instruction_Length Procedure --
Get_instruction_Length proc
	mov eax , 0
	To_Get_Actual_Length:
		cmp byte ptr [esi] , 0
		JE its_Null 
		inc eax 
		its_Null:
			inc esi
	Loop To_Get_Actual_Length
	ret
Get_instruction_Length Endp

;-------------------------------------------------
; -- Check_Register Procedure --
Check_Register proc
	mov dl , [esi+1]
	cmp dl , "x"
	JE its_Word
	mov eax , 1
	Jmp Cancel
	its_Word:
		mov eax , 0
	Cancel:
	ret
Check_Register Endp

;------------------------------------------------
; -- Intialize_Registers Procedure --
Intialize_Registers proc
	Mov Eax, 1
	Mov Ebx, 1
	Mov Ecx, 1
	Mov Edx, 1
	Mov Esi, 1
	Mov Edi, 1
	Mov user_variable, 1
	ret
Intialize_Registers Endp
;------------------------------------------------
; -- Convert_String_To_Number Procedure --
Convert_String_To_Number PROC
	mov esi , offset sor
	mov ecx , 15
	Call Get_instruction_Length
	dec eax
	mov ebx,eax
	mov edx,offset sor
	mov al,[edx]
	cmp al,'0'
	jb next
	cmp al,'9'
	ja next
	mov al,[edx+ebx-1]
	cmp al,'b'
	je B1
	cmp al,'h'
	je H1
	call Convert_String_To_Dec
	jmp fin
	H1:
	call Convert_String_To_Hex
	jmp fin
	B1:
	call Convert_String_To_Bin
	jmp fin
	next:
	fin:
		ret
Convert_String_To_Number ENDP
;------------------------------------------------
; -- Convert_String_To_Dec Procedure --
Convert_String_To_Dec PROC
	mov esi ,offset sor 
	mov al,[esi]	
	sub al,48
	movzx eax,al
	cmp ebx,1
	jbe finsh
	mov ecx,ebx
	mov ebx,10		
	dec ecx
	L1:
		inc esi					
		mul ebx					
		mov dl,[esi]
		sub dl,48
		movzx edx,dl			
		add eax,edx
	loop L1
	finsh:
		mov Converted_number,eax
	ret
Convert_String_To_Dec ENDP
;------------------------------------------------
; -- Convert_String_To_Bin Procedure --
Convert_String_To_Bin PROC
	mov esi ,offset sor 
	mov al,[esi]	
	sub al,48
	movzx eax,al
	cmp ebx,1
	jbe finsh
	mov ecx,ebx
	mov ebx,2		
	dec ecx
	L1:
		inc esi
		cmp byte ptr [esi],'b'	
		je finsh
		mul ebx					
		mov dl,[esi]
		sub dl,48
		movzx edx,dl			
		add eax,edx
	loop L1
	finsh:
		mov Converted_number,eax
	ret
Convert_String_To_Bin ENDP
;------------------------------------------------
; -- Convert_String_To_Hex Procedure --
Convert_String_To_Hex PROC
	mov esi ,offset sor 
	mov al,[esi]	
	sub al,48
	movzx eax,al
	cmp ebx,1
	jbe finsh
	mov ecx,ebx
	mov ebx,16		
	dec ecx
	L1:
		inc esi
		cmp byte ptr [esi],'h'	
		je finsh
		mul ebx					
		mov dl,[esi]
		cmp dl,'0'
		jb next
		cmp dl,'9'
		ja next
		sub dl,48
		jmp bom
		next:
		sub dl,55
		bom:
		movzx edx,dl			
		add eax,edx
	loop L1
	finsh:
		mov Converted_number,eax
	ret
Convert_String_To_Hex ENDP
;------------------------------------------------
; -- Check_String Procedure --
Check_String Proc
	mov esi , offset sor
	mov al,[esi]
	cmp al,'0'
	Jb its_String
	cmp al,'9'
	Ja its_String
	mov eax , 1
	Jmp Ok_exit_it
	its_String:
		mov eax , 0
	Ok_exit_it:
	ret
Check_String Endp

;--------------------------------------------------
;	---	Display_Dword_Register Proc --
Display_Dword_Register Proc
	Mov Edx,offset output
	Call writeString

	Mov edx , offset des
	Call writeString
	Mov edx , offset Equal_symbol
	Call writeString
	mov eax , current_value_Dword
	Call writeDec
	Call Crlf
	ret
Display_Dword_Register Endp

;--------------------------------------------------
;	---	Display_word_Register Proc --
Display_word_Register Proc
	Mov Edx,offset output
	Call writeString
	Mov edx , offset des
	Call writeString
	Mov edx , offset Equal_symbol
	Call writeString
	mov ax , current_value_word
	Call writeDec
	Call Crlf
	ret
Display_word_Register Endp

;--------------------------------------------------
;	---	ReIntiallize_Indecies Proc --
ReIntiallize_Indecies Proc
	Mov instruction_index,0
	Mov Destenation_index,0
	Mov source_index,0
	Mov Counter,0
	ret
ReIntiallize_Indecies Endp

;--------------------------------------------------
;	---	Display_byte_Register Proc --
Display_byte_Register Proc
	Mov Edx,offset output
	Call writeString
	Mov edx , offset des
	Call writeString
	Mov edx , offset Equal_symbol
	Call writeString
	mov al , current_value_byte
	Call writeDec
	Call Crlf
	ret
Display_byte_Register Endp

;-----------------------------------------------------------------------
		;	--	Mov_instruction	Procedure --
Mov_instruction Proc
;		--------- Eax ---------
	cmp destenation_index,0
	JE its_Eax
	JNE Search_for_another_register
	its_Eax:
		cmp source_index , 1
		JNE Not_Ebx
		Mov Eax , Ebx
		Mov current_value_Dword , Ebx		
		jmp Done
		Not_Ebx:
			cmp source_index , 2
			JNE Not_Ecx
			Mov Eax , Ecx
			Mov current_value_Dword , Ecx				
			jmp Done
		Not_Ecx:
			cmp source_index , 3
			JNE Not_Edx
			Mov Eax , Edx
			Mov current_value_Dword , Edx			
			jmp Done
		Not_Edx:
			cmp source_index , 4
			JNE Not_Esi
			Mov Eax , Esi
			Mov current_value_Dword , Esi			
			jmp Done
		Not_Esi:
			cmp source_index , 5
			JNE Not_Edi
			Mov Eax , Edi
			Mov current_value_Dword , Edi		
			jmp Done
		Not_Edi:
			cmp source_index , 6
			JNE Not_Esp
			Mov Eax , Esp
			Mov current_value_Dword , Esp				
			jmp Done
		Not_Esp:
			cmp source_index , 7
			JNE Non_of_them_1
			Mov Eax , Ebp
			Mov current_value_Dword , Ebp				
			jmp Done
		Non_of_them_1:
			PushAd
			Call Check_String
			cmp eax , 0
			JE enough
			PopAd
			Mov Eax , Converted_number
			Mov current_value_Dword , Eax				
			jmp Done

;		--------- Ebx ---------
	Search_for_another_register:
		cmp destenation_index,1
		JE its_Ebx_1
		JNE Search_for_another_register_1
		its_Ebx_1:
			cmp source_index , 0
			JNE Not_Eax_1
			Mov Ebx , Eax
			Mov current_value_Dword , Eax				
			jmp Done
			Not_Eax_1:
				cmp source_index , 2
				JNE Not_Ecx_1
				Mov Ebx , Ecx
				Mov current_value_Dword , Ecx
				jmp Done
			Not_Ecx_1:
				cmp source_index , 3
				JNE Not_Edx_1
				Mov Ebx , Edx
				Mov current_value_Dword , Edx
				jmp Done
			Not_Edx_1:
				cmp source_index , 4
				JNE Not_Esi_1
				Mov Ebx , Esi
				Mov current_value_Dword , Esi
				jmp Done
			Not_Esi_1:
				cmp source_index , 5
				JNE Not_Edi_1
				Mov Ebx , Edi
				Mov current_value_Dword , Edi
				jmp Done
			Not_Edi_1:
				cmp source_index , 6
				JNE Not_Esp_1
				Mov Ebx , Esp
				Mov current_value_Dword , Esp
				jmp Done
			Not_Esp_1:
				cmp source_index , 7
				JNE Non_of_them_2
				Mov Ebx , Ebp
				Mov current_value_Dword , Ebp
				jmp Done
			Non_of_them_2:
				PushAd
				Call Check_String
				cmp eax , 0
				JE enough
				POPAD
				Mov Ebx , Converted_number
				Mov current_value_Dword , Ebx				
				jmp Done

	;		--------- Ecx ---------
		Search_for_another_register_1:
		cmp destenation_index,2
		JE its_Ecx_2
		JNE Search_for_another_register_2
		its_Ecx_2:
			cmp source_index , 0
			JNE Not_Eax_2
			Mov Ecx , Eax
			Mov current_value_Dword , Eax		
			jmp Done
			Not_Eax_2:
				cmp source_index , 1
				JNE Not_Ebx_2
				Mov Ecx , Ebx
				Mov current_value_Dword , Ebx
				jmp Done
			Not_Ebx_2:
				cmp source_index , 3
				JNE Not_Edx_2
				Mov Ecx , Edx
				Mov current_value_Dword , Edx
				jmp Done
			Not_Edx_2:
				cmp source_index , 4
				JNE Not_Esi_2
				Mov Ecx , Esi
				Mov current_value_Dword , Esi
				jmp Done
			Not_Esi_2:
				cmp source_index , 5
				JNE Not_Edi_2
				Mov Ecx , Edi
				Mov current_value_Dword , Edi
				jmp Done
			Not_Edi_2:
				cmp source_index , 6
				JNE Not_Esp_2
				Mov Ecx , Esp
				Mov current_value_Dword , Esp
				jmp Done
			Not_Esp_2:
				cmp source_index , 7
				JNE Non_of_them_3
				Mov Ecx , Ebp
				Mov current_value_Dword , Ebp
				jmp Done
			Non_of_them_3:
				PUSHAD
				Call Check_String
				cmp eax , 0
				JE enough
				POPAD
				Mov Ecx , Converted_number
				Mov current_value_Dword , Ecx				
				jmp Done

	;		--------- Edx ---------
		Search_for_another_register_2:
		cmp destenation_index,3
		JE its_Edx_3
		JNE Search_for_another_register_3
		its_Edx_3:
			cmp source_index , 0
			JNE Not_Eax_3
			Mov Edx , Eax
			Mov current_value_Dword , Eax
			jmp Done
			Not_Eax_3:
				cmp source_index , 1
				JNE Not_Ebx_3
				Mov Edx , Ebx
				Mov current_value_Dword , Ebx
				jmp Done
			Not_Ebx_3:
				cmp source_index , 2
				JNE Not_Ecx_3
				Mov Edx , Ecx
				Mov current_value_Dword , Ecx
				jmp Done
			Not_Ecx_3:
				cmp source_index , 4
				JNE Not_Esi_3
				Mov Edx , Esi
				Mov current_value_Dword , Esi
				jmp Done
			Not_Esi_3:
				cmp source_index , 5
				JNE Not_Edi_3
				Mov Edx , Edi
				Mov current_value_Dword , Edi
				jmp Done
			Not_Edi_3:
				cmp source_index , 6
				JNE Not_Esp_3
				Mov Edx , Esp
				Mov current_value_Dword , Esp
				jmp Done
			Not_Esp_3:
				cmp source_index , 7
				JNE Non_of_them_4
				Mov Edx , Ebp
				Mov current_value_Dword , Ebp
				jmp Done
			Non_of_them_4:
				PushAd
				Call Check_String
				cmp eax , 0
				JE enough
				PopAd
				Mov Edx , Converted_number
				Mov current_value_Dword , Edx				
				jmp Done
	
	;		--------- Esi ---------
		Search_for_another_register_3:
		cmp destenation_index,4
		JE its_Esi_4
		JNE Search_for_another_register_4
		its_Esi_4:
			cmp source_index , 0
			JNE Not_Eax_4
			Mov Esi , Eax
			Mov current_value_Dword , Eax			
			jmp Done
			Not_Eax_4:
				cmp source_index , 1
				JNE Not_Ebx_4
				Mov Esi , Ebx
				Mov current_value_Dword , Ebx
				jmp Done
			Not_Ebx_4:
				cmp source_index , 2
				JNE Not_Ecx_4
				Mov Esi , Ecx
				Mov current_value_Dword , Ecx
				jmp Done
			Not_Ecx_4:
				cmp source_index , 3
				JNE Not_Edx_4
				Mov Esi , Edx
				Mov current_value_Dword , Edx
				jmp Done
			Not_Edx_4:
				cmp source_index , 5
				JNE Not_Edi_4
				Mov Esi , Edi
				Mov current_value_Dword , Edi
				jmp Done
			Not_Edi_4:
				cmp source_index , 6
				JNE Not_Esp_4
				Mov Esi , Esp
				Mov current_value_Dword , Esp
				jmp Done
			Not_Esp_4:
				cmp source_index , 7
				JNE Non_of_them_5
				Mov Esi , Ebp
				Mov current_value_Dword , Ebp
				jmp Done
			Non_of_them_5:
				PUSHAD
				Call Check_String
				cmp eax , 0
				JE enough
				POPAD
				Mov Esi , Converted_number
				Mov current_value_Dword , Esi				
				jmp Done

	;		--------- Edi ---------
		Search_for_another_register_4:
		cmp destenation_index,5
		JE its_Edi_5
		JNE Search_for_another_register_5
		its_Edi_5:
			cmp source_index , 0
			JNE Not_Eax_5
			Mov Edi , Eax
			Mov current_value_Dword , Eax				
			jmp Done
			Not_Eax_5:
				cmp source_index , 1
				JNE Not_Ebx_5
				Mov Edi , Ebx
				Mov current_value_Dword , Ebx
				jmp Done
			Not_Ebx_5:
				cmp source_index , 2
				JNE Not_Ecx_5
				Mov Edi , Ecx
				Mov current_value_Dword , Ecx
				jmp Done
			Not_Ecx_5:
				cmp source_index , 3
				JNE Not_Edx
				Mov Edi , Edx
				Mov current_value_Dword , Edx
				jmp Done
			Not_Edx_5:
				cmp source_index , 4
				JNE Not_Esi_5
				Mov Edi , Esi
				Mov current_value_Dword , Esi
				jmp Done
			Not_Esi_5:
				cmp source_index , 6
				JNE Not_Esp_5
				Mov Edi , Esp
				Mov current_value_Dword , Esp
				jmp Done
			Not_Esp_5:
				cmp source_index , 7
				JNE Non_of_them_6
				Mov Edi , Ebp
				Mov current_value_Dword , Ebp
				jmp Done
			Non_of_them_6:
				PUSHAD
				Call Check_String
				cmp eax , 0
				JE enough
				POPAD
				Mov Edi , Converted_number
				Mov current_value_Dword , Edi				
				jmp Done

	;		--------- Esp ---------
		Search_for_another_register_5:
		cmp destenation_index,6
		JE its_Esp_6
		JNE Search_for_another_register_6
		its_Esp_6:
			cmp source_index , 0
			JNE Not_Eax_6
			Mov Esp , Eax
			Mov current_value_Dword , Eax
			jmp Done
			Not_Eax_6:
				cmp source_index , 1
				JNE Not_Ebx_6
				Mov Esp , Ebx
				Mov current_value_Dword , Ebx
				jmp Done
			Not_Ebx_6:
				cmp source_index , 2
				JNE Not_Ecx_6
				Mov Esp , Ecx
				Mov current_value_Dword , Ecx
				jmp Done
			Not_Ecx_6:
				cmp source_index , 3
				JNE Not_Edx_6
				Mov Esp , Edx
				Mov current_value_Dword , Edx
				jmp Done
			Not_Edx_6:
				cmp source_index , 4
				JNE Not_Esi_6
				Mov Esp , Esi
				Mov current_value_Dword , Esi
				jmp Done
			Not_Esi_6:
				cmp source_index , 5
				JNE Not_Edi_6
				Mov Esp , Edi
				Mov current_value_Dword , Edi
				jmp Done
			Not_Edi_6:
				cmp source_index , 7
				JNE Non_of_them_7
				Mov Esp , Ebp
				Mov current_value_Dword , Ebp
				jmp Done
			Non_of_them_7:
				PUSHAD
				Call Check_String
				cmp eax , 0
				JE enough
				POPAD
				Mov Esp , Converted_number
				Mov current_value_Dword , Esp				
				jmp Done

	;		--------- Ebp ---------
		Search_for_another_register_6:
		cmp destenation_index,7
		JE its_Ebp
		JNE Serarch_For_word_Register
		its_Ebp:
			cmp source_index , 0
			JNE Not_Eax_7
			Mov Ebp , Eax
			Mov current_value_Dword , Eax
			jmp Done
			Not_Eax_7:
				cmp source_index , 1
				JNE Not_Ebx_7
				Mov Ebp , Ebx
				Mov current_value_Dword , Ebx
				jmp Done
			Not_Ebx_7:
				cmp source_index , 2
				JNE Not_Ecx_7
				Mov Ebp , Ecx
				Mov current_value_Dword , Ecx
				jmp Done
			Not_Ecx_7:
				cmp source_index , 3
				JNE Not_Edx_7
				Mov Ebp , Edx
				Mov current_value_Dword , Edx
				jmp Done
			Not_Edx_7:
				cmp source_index , 4
				JNE Not_Esi_7
				Mov Ebp , Esi
				Mov current_value_Dword , Esi
				jmp Done
			Not_Esi_7:
				cmp source_index , 5
				JNE Not_Edi_7
				Mov Ebp , Edi
				Mov current_value_Dword , Edi
				jmp Done
			Not_Edi_7:
				cmp source_index , 6
				JNE Non_of_them_8
				Mov Ebp , Esi
				Mov current_value_Dword , Esi
				jmp Done
			Non_of_them_8:
				PUSHAD
				Call Check_String
				cmp eax , 0
				JE enough
				POPAD
				Mov Ebp , Converted_number
				Mov current_value_Dword , Ebp				
				jmp Done

;-------------------------------------------
		;	-- word register -- 

	;		--------- Ax ---------
Serarch_For_word_Register:
		cmp destenation_index,8
		JE its_Ax
		JNE Search_for_another_word_register_1
		its_Ax:
			cmp source_index , 9
			JNE Not_Bx
			Mov Ax , Bx
			Mov current_value_word , Bx
			jmp Done_2
			Not_Bx:
				cmp source_index , 10
				JNE Not_Cx
				Mov Ax , Cx
				Mov current_value_word , Cx
				jmp Done_2
			Not_Cx:
				cmp source_index , 11
				JNE Non_of_them_9
				Mov Ax , Dx
				Mov current_value_word , Dx
				jmp Done_2
			Non_of_them_9:
				PUSHAD
				Call Check_String
				cmp eax , 0
				JE enough
				POPAD
				Mov Ax , word ptr [ Converted_number ]
				Mov current_value_word , Ax				
				jmp Done_2

	;		--------- Bx ---------
		Search_for_another_word_register_1:
		cmp destenation_index,9
		JE its_Bx
		JNE Search_for_another_word_register_2
		its_Bx:
			cmp source_index , 8
			JNE Not_Ax
			Mov Bx , Ax
			Mov current_value_word , Ax
			jmp Done_2
			Not_Ax:
				cmp source_index , 10
				JNE Not_Cx_1
				Mov Bx , Cx
				Mov current_value_word , Cx
				jmp Done_2
			Not_Cx_1:
				cmp source_index , 11
				JNE Non_of_them_10
				Mov Bx , Dx
				Mov current_value_word , Dx
				jmp Done_2
			Non_of_them_10:
				PUSHAD
				Call Check_String
				cmp eax , 0
				JE enough
				POPAD
				Mov Bx , word ptr [ Converted_number ]
				Mov current_value_word , Bx				
				jmp Done_2

	;		--------- Cx ---------
		Search_for_another_word_register_2:
		cmp destenation_index,10
		JE its_Cx
		JNE Search_for_another_word_register_3
		its_Cx:
			cmp source_index , 8
			JNE Not_Ax_1
			Mov Cx , Ax
			Mov current_value_word , Ax
			jmp Done_2
			jmp Done
			Not_Ax_1:
				cmp source_index , 9
				JNE Not_Bx_1
				Mov Cx , Bx
				Mov current_value_word , Bx
				jmp Done_2
			Not_Bx_1:
				cmp source_index , 11
				JNE Non_of_them_11
				Mov Cx , Dx
				Mov current_value_word , Dx
				jmp Done_2
			Non_of_them_11:
				PUSHAD
				Call Check_String
				cmp eax , 0
				JE enough
				POPAD
				Mov Cx , word ptr [ Converted_number ]
				Mov current_value_word , Cx				
				jmp Done_2

	;		--------- Dx ---------
		Search_for_another_word_register_3:
		cmp destenation_index,11
		JE its_Dx
		JNE Search_for_another_byte_register
		its_Dx:
			cmp source_index , 8
			JNE Not_Ax_2
			Mov Dx , Ax
			Mov current_value_word , Ax
			jmp Done_2
			Not_Ax_2:
				cmp source_index , 9
				JNE Not_Bx_2
				Mov Dx , Bx
				Mov current_value_word , Bx
				jmp Done_2
			Not_Bx_2:
				cmp source_index , 10
				JNE Non_of_them_12
				Mov Dx , Cx
				Mov current_value_word , Cx
				jmp Done_2
			Non_of_them_12:
				PUSHAD
				Call Check_String
				cmp eax , 0
				JE enough
				POPAD
				Mov Dx , word ptr [ Converted_number ]
				Mov current_value_word , Dx				
				jmp Done_2

;-------------------------------------------
		;	-- byte register -- 

;		-------- Al ----------
	Search_for_another_byte_register:
		cmp destenation_index,12
		JE its_Al
		JNE Search_for_another_byte_register_2
		its_Al:
			cmp source_index , 14
			JNE Not_Bl
			Mov Al , Bl
			Mov current_value_byte , Bl
			jmp Done_3
			Not_Bl:
				cmp source_index , 16
				JNE Not_Cl
				Mov Al , Cl
				Mov current_value_byte , Cl
				jmp Done_3
			Not_Cl:
				cmp source_index , 18
				JNE it_Mem
				Mov Al , Dl
				Mov current_value_byte , Dl
				jmp Done_3
			it_Mem:
				cmp source_index , 20
				JNE Non_of_them_13
				Mov Al , user_variable
				Mov current_value_byte , Al
				jmp Done_3
			Non_of_them_13:
				PUSHAD
				Call Check_String
				cmp eax , 0
				JE enough
				POPAD
				Mov Al , byte ptr [ Converted_number ]
				Mov current_value_byte , Al			
				jmp Done_3

	;		-------- Bl ----------
		Search_for_another_byte_register_2:
			cmp destenation_index,14
			JE its_Bl
			JNE Search_for_another_byte_register_4
			its_Bl:
				cmp source_index , 12
				JNE Not_Al_1
				Mov Bl , Al
				Mov current_value_byte , Al
				jmp Done_3
				Not_Al_1:
					cmp source_index , 16
					JNE Not_Cl_1
					Mov Bl , Cl
					Mov current_value_byte , Cl
					jmp Done_3
				Not_Cl_1:
					cmp source_index , 18
					JNE it_Mem_2
					Mov Bl , Dl
					Mov current_value_byte , Dl
					jmp Done_3
				it_Mem_2:
					cmp source_index , 20
					JNE Non_of_them_15
					Mov Bl , user_variable
					Mov current_value_byte , Bl
					jmp Done_3
				Non_of_them_15:
					PUSHAD
					Call Check_String
					cmp eax , 0
					JE enough
					POPAD
					Mov Bl , byte ptr [ Converted_number ]
					Mov current_value_byte , Bl			
					jmp Done_3

	;		-------- Cl ----------
		Search_for_another_byte_register_4:
			cmp destenation_index,16
			JE its_Cl
			JNE Search_for_another_byte_register_6
			its_Cl:
				cmp source_index , 12
				JNE Not_Al_2
				Mov Cl , Al
				Mov current_value_byte , Al
				jmp Done_3
				Not_Al_2:
					cmp source_index , 14
					JNE Not_Bl_2
					Mov Cl , Bl
					Mov current_value_byte , Bl
					jmp Done_3
				Not_Bl_2:
					cmp source_index , 18
					JNE it_Mem_3
					Mov Cl , Dl
					Mov current_value_byte , Dl
					jmp Done_3
				it_Mem_3:
					cmp source_index , 20
					JNE Non_of_them_17
					Mov Cl , user_variable
					Mov current_value_byte , Cl
					jmp Done_3
				Non_of_them_17:
					PUSHAD
					Call Check_String
					cmp eax , 0
					JE enough
					POPAD
					Mov Cl , byte ptr [ Converted_number ]
					Mov current_value_byte , Cl			
					jmp Done_3

	;		-------- Dl ----------
		Search_for_another_byte_register_6:
			cmp destenation_index,18
			JE its_Dl
			JNE Search_for_another_byte_register_7
			its_Dl:
				cmp source_index , 12
				JNE Not_Al_3
				Mov Dl , Al
				Mov current_value_byte , Al
				jmp Done_3
				Not_Al_3:
					cmp source_index , 14
					JNE Not_Bl_3
					Mov Dl , Bl
					Mov current_value_byte , Bl
					jmp Done_3
				Not_Bl_3:
					cmp source_index , 16
					JNE it_Mem_9
					Mov Dl , Cl
					Mov current_value_byte , Cl
					jmp Done_3
				it_Mem_9:
					cmp source_index , 20
					JNE Non_of_them_19
					Mov Dl , user_variable
					Mov current_value_byte , Dl
					jmp Done_3
				Non_of_them_19:
					PUSHAD
					Call Check_String
					cmp eax , 0
					JE enough
					POPAD
					Mov Dl , byte ptr [ Converted_number ]
					Mov current_value_byte , Dl			
					jmp Done_3

	;		-------- Memory ----------
		Search_for_another_byte_register_7:
			cmp destenation_index,20
			JE its_Mem
			JNE Suitable_Dest_Not_Found
			its_Mem:
				cmp source_index , 12
				JNE Not_Al_45
				Mov user_variable , Al
				Mov current_value_byte , Al
				jmp Done_3
				Not_Al_45:
					cmp source_index , 14
					JNE Not_Bl_46
					Mov user_variable , Bl
					Mov current_value_byte , Bl
					jmp Done_3
				Not_Bl_46:
					cmp source_index , 16
					JNE it_Dl_55
					Mov user_variable , Cl
					Mov current_value_byte , Cl
					jmp Done_3
				it_Dl_55:
					cmp source_index , 18
					JNE Non_of_them_190
					Mov user_variable , Dl
					Mov current_value_byte , Dl
					jmp Done_3
				Non_of_them_190:
					PUSHAD
					Call Check_String
					cmp eax , 0
					JE enough
					Mov Dl , byte ptr [ Converted_number ]
					Mov user_variable , Dl
					Mov current_value_byte , Dl		
					POPAD	
					jmp Done_3

	Suitable_Dest_Not_Found:
		PushAD
		Mov Edx,offset output
		Call writeString
		mov edx,offset Destenation_Not_Found_Error
		Call writeString
		Call crlf
		jmp end_it

	Done:
		;	-- To out The Dword Registers --
		PushAD
		Call Display_Dword_Register
		jmp end_it
	Done_2:
		;	-- To out The word Registers --
		PushAd
		Call Display_word_Register
		jmp end_it
	Done_3:
		;	-- To out The Byte Registers --
		PushAd
		Call Display_byte_Register
		JMP end_it
	enough:
		mov edx,offset output
		Call WriteString
		mov edx,offset Source_Not_Found_Error
		Call writeString
		Call crlf
	end_it:
		PopAD
	ret
Mov_instruction Endp

;---------------------------------------------------------------------------------------------------------------------------
;		-- Add_Instruction Procedure
Add_Instruction Proc
	;		--------- Eax ---------
		cmp destenation_index,0
		JE its_Eax_2
		JNE Search_for_another_register_100
		its_Eax_2:
			cmp source_index , 1
			JNE Not_Ebx_80
			Add Eax , Ebx
			JC enough
			mov current_value_Dword , Eax		
			jmp Done
			Not_Ebx_80:
				cmp source_index , 2
				JNE Not_Ecx_2
				Add Eax , Ecx
				JC enough
				mov current_value_Dword , Eax				
				jmp Done
			Not_Ecx_2:
				cmp source_index , 3
				JNE Not_Edx_50
				Add Eax , Edx
				JC enough
				mov current_value_Dword , Eax			
				jmp Done
			Not_Edx_50:
				cmp source_index , 4
				JNE Not_Esi_30
				Add Eax , Esi
				JC enough
				mov current_value_Dword , Eax			
				jmp Done
			Not_Esi_30:
				cmp source_index , 5
				JNE Not_Edi_20
				Add Eax , Edi
				JC enough
				mov current_value_Dword , Eax		
				jmp Done
			Not_Edi_20:
				cmp source_index , 6
				JNE Not_Esp_40
				Add Eax , Esp
				JC enough
				mov current_value_Dword , Eax				
				jmp Done
			Not_Esp_40:
				cmp source_index , 7
				JNE Non_of_them_30
				Add Eax , Ebp
				JC enough
				mov current_value_Dword , Eax				
				jmp Done
			Non_of_them_30:
				Add Eax , converted_number
				JC enough
				mov current_value_Dword , Eax				
				jmp Done

	;		--------- Ebx ---------
		Search_for_another_register_100:
			cmp destenation_index,1
			JE its_Ebx_3
			JNE Search_for_another_register_20
			its_Ebx_3:
				cmp source_index , 0
				JNE Not_Eax_120
				Add Ebx , Eax
				JC enough
				mov current_value_Dword , Ebx				
				jmp Done
				Not_Eax_120:
					cmp source_index , 2
					JNE Not_Ecx_30
					Add Ebx , Ecx
					JC enough
					mov current_value_Dword , Ebx
					jmp Done
				Not_Ecx_30:
					cmp source_index , 3
					JNE Not_Edx_666
					Add Ebx , Edx
					JC enough
					mov current_value_Dword , Ebx
					jmp Done
				Not_Edx_666:
					cmp source_index , 4
					JNE Not_Esi_65
					Add Ebx , Esi
					JC enough
					mov current_value_Dword , Ebx
					jmp Done
				Not_Esi_65:
					cmp source_index , 5
					JNE Not_Edi_80
					Add Ebx , Edi
					JC enough
					mov current_value_Dword , Ebx
					jmp Done
				Not_Edi_80:
					cmp source_index , 6
					JNE Not_Esp_10
					Add Ebx , Esp
					JC enough
					mov current_value_Dword , Ebx
					jmp Done
				Not_Esp_10:
					cmp source_index , 7
					JNE Non_of_them_40
					Add Ebx , Ebp
					JC enough
					mov current_value_Dword , Ebx
					jmp Done
				Non_of_them_40:
				Add Ebx , converted_number
				JC enough
				mov current_value_Dword , Ebx				
				jmp Done

		;		--------- Ecx ---------
			Search_for_another_register_20:
			cmp destenation_index,2
			JE its_Ecx_4
			JNE Search_for_another_register_30
			its_Ecx_4:
				cmp source_index , 0
				JNE Not_Eax_70
				Add Ecx , Eax
				JC enough
				mov current_value_Dword , Ecx		
				jmp Done
				Not_Eax_70:
					cmp source_index , 1
					JNE Not_Ebx_125
					Add Ecx , Ebx
					JC enough
					mov current_value_Dword , Ecx
					jmp Done
				Not_Ebx_125:
					cmp source_index , 3
					JNE Not_Edx_90
					Add Ecx , Edx
					JC enough
					mov current_value_Dword , Ecx
					jmp Done
				Not_Edx_90:
					cmp source_index , 4
					JNE Not_Esi_4
					Add Ecx , Esi
					JC enough
					mov current_value_Dword , Ecx
					jmp Done
				Not_Esi_4:
					cmp source_index , 5
					JNE Not_Edi_150
					Add Ecx , Edi
					JC enough
					mov current_value_Dword , Ecx
					jmp Done
				Not_Edi_150:
					cmp source_index , 6
					JNE Not_Esp_100
					Add Ecx , Esp
					JC enough
					mov current_value_Dword , Ecx
					jmp Done
				Not_Esp_100:
					cmp source_index , 7
					JNE Non_of_them_366
					Add Ecx , Ebp
					JC enough
					mov current_value_Dword , Ecx
					jmp Done
				Non_of_them_366:
				Add Ecx , converted_number
				JC enough
				mov current_value_Dword , Ecx				
				jmp Done

		;		--------- Edx ---------
			Search_for_another_register_30:
			cmp destenation_index,3
			JE its_Edx_5
			JNE Search_for_another_register_43
			its_Edx_5:
				cmp source_index , 0
				JNE Not_Eax_55
				Add Edx , Eax
				JC enough
				mov current_value_Dword , Edx
				jmp Done
				Not_Eax_55:
					cmp source_index , 1
					JNE Not_Ebx_45
					Add Edx , Ebx
					JC enough
					mov current_value_Dword , Edx
					jmp Done
				Not_Ebx_45:
					cmp source_index , 2
					JNE Not_Ecx_85
					Add Edx , Ecx
					JC enough
					mov current_value_Dword , Edx
					jmp Done
				Not_Ecx_85:
					cmp source_index , 4
					JNE Not_Esi_56
					Add Edx , Esi
					JC enough
					mov current_value_Dword , Edx
					jmp Done
				Not_Esi_56:
					cmp source_index , 5
					JNE Not_Edi_5
					Add Edx , Edi
					JC enough
					mov current_value_Dword , Edx
					jmp Done
				Not_Edi_5:
					cmp source_index , 6
					JNE Not_Esp_75
					Add Edx , Esp
					JC enough
					mov current_value_Dword , Edx
					jmp Done
				Not_Esp_75:
					cmp source_index , 7
					JNE Non_of_them_32
					Add Edx , Ebp
					JC enough
					mov current_value_Dword , Edx
					jmp Done
				Non_of_them_32:
				Add Edx , converted_number
				JC enough
				mov current_value_Dword , Edx				
				jmp Done
	
		;		--------- Esi ---------
			Search_for_another_register_43:
			cmp destenation_index,4
			JE its_Esi_222
			JNE Search_for_another_register_555
			its_Esi_222:
				cmp source_index , 0
				JNE Not_Eax_3355
				Add Esi , Eax
				JC enough
				mov current_value_Dword , Esi			
				jmp Done
				Not_Eax_3355:
					cmp source_index , 1
					JNE Not_Ebx_202
					Add Esi , Ebx
					JC enough
					mov current_value_Dword , Esi
					jmp Done
				Not_Ebx_202:
					cmp source_index , 2
					JNE Not_Ecx_000
					Add Esi , Ecx
					JC enough
					mov current_value_Dword , Esi
					jmp Done
				Not_Ecx_000:
					cmp source_index , 3
					JNE Not_Edx_145
					Add Esi , Edx
					JC enough
					mov current_value_Dword , Esi
					jmp Done
				Not_Edx_145:
					cmp source_index , 5
					JNE Not_Edi_320
					Add Esi , Edi
					JC enough
					mov current_value_Dword , Esi
					jmp Done
				Not_Edi_320:
					cmp source_index , 6
					JNE Not_Esp_6
					Add Esi , Esp
					JC enough
					mov current_value_Dword , Esi
					jmp Done
				Not_Esp_6:
					cmp source_index , 7
					JNE Non_of_them_170
					Add Esi , Ebp
					JC enough
					mov current_value_Dword , Esi
					jmp Done
				Non_of_them_170:
				Add Esi , converted_number
				JC enough
				mov current_value_Dword , Esi				
				jmp Done

		;		--------- Edi ---------
			Search_for_another_register_555:
			cmp destenation_index,5
			JE its_Edi_7
			JNE Search_for_another_register_630
			its_Edi_7:
				cmp source_index , 0
				JNE Not_Eax_136
				Add Edi , Eax
				JC enough
				mov current_value_Dword , Edi				
				jmp Done
				Not_Eax_136:
					cmp source_index , 1
					JNE Not_Ebx_1778
					Add Edi , Ebx
					JC enough
					mov current_value_Dword , Edi
					jmp Done
				Not_Ebx_1778:
					cmp source_index , 2
					JNE Not_Ecx_745
					Add Edi , Ecx
					JC enough
					mov current_value_Dword , Edi
					jmp Done
				Not_Ecx_745:
					cmp source_index , 3
					JNE Not_Edx_138
					Add Edi , Edx
					JC enough
					mov current_value_Dword , Edi
					jmp Done
				Not_Edx_138:
					cmp source_index , 4
					JNE Not_Esi_1335
					Add Edi , Esi
					JC enough
					mov current_value_Dword , Edi
					jmp Done
				Not_Esi_1335:
					cmp source_index , 6
					JNE Not_Esp_7
					Add Edi , Esp
					JC enough
					mov current_value_Dword , Edi
					jmp Done
				Not_Esp_7:
					cmp source_index , 7
					JNE Non_of_them_855
					Add Edi , Ebp
					JC enough
					mov current_value_Dword , Edi
					jmp Done
				Non_of_them_855:
				Add Edi , converted_number
				JC enough
				mov current_value_Dword , Edi			
				jmp Done

		;		--------- Esp ---------
			Search_for_another_register_630:
			cmp destenation_index,6
			JE its_Esp_8
			JNE Search_for_another_register_7
			its_Esp_8:
				cmp source_index , 0
				JNE Not_Eax_8
				Add Esp , Eax
				JC enough
				mov current_value_Dword , Esp
				jmp Done
				Not_Eax_8:
					cmp source_index , 1
					JNE Not_Ebx_8
					Add Esp , Ebx
					JC enough
					mov current_value_Dword , Esp
					jmp Done
				Not_Ebx_8:
					cmp source_index , 2
					JNE Not_Ecx_8
					Add Esp , Ecx
					JC enough
					mov current_value_Dword , Esp
					jmp Done
				Not_Ecx_8:
					cmp source_index , 3
					JNE Not_Edx_8
					Add Esp , Edx
					JC enough
					mov current_value_Dword , Esp
					jmp Done
				Not_Edx_8:
					cmp source_index , 4
					JNE Not_Esi_8
					Add Esp , Esi
					JC enough
					mov current_value_Dword , Esp
					jmp Done
				Not_Esi_8:
					cmp source_index , 5
					JNE Not_Edi_8
					Add Esp , Edi
					JC enough
					mov current_value_Dword , Esp
					jmp Done
				Not_Edi_8:
					cmp source_index , 7
					JNE Non_of_them_933
					Add Esp , Ebp
					JC enough
					mov current_value_Dword , Esp
					jmp Done
				Non_of_them_933:
				Add Esp , converted_number
				JC enough
				mov current_value_Dword , Esp				
				jmp Done

		;		--------- Ebp ---------
			Search_for_another_register_7:
			cmp destenation_index,7
			JE its_Ebp_100
			JNE Serarch_For_word_Register_8
			its_Ebp_100:
				cmp source_index , 0
				JNE Not_Eax_9
				Add Ebp , Eax
				JC enough
				mov current_value_Dword , Ebp
				jmp Done
				Not_Eax_9:
					cmp source_index , 1
					JNE Not_Ebx_9
					Add Ebp , Ebx
					JC enough
					mov current_value_Dword , Ebp
					jmp Done
				Not_Ebx_9:
					cmp source_index , 2
					JNE Not_Ecx_9
					Add Ebp , Ecx
					JC enough
					mov current_value_Dword , Ebp
					jmp Done
				Not_Ecx_9:
					cmp source_index , 3
					JNE Not_Edx_9
					Add Ebp , Edx
					JC enough
					mov current_value_Dword , Ebp
					jmp Done
				Not_Edx_9:
					cmp source_index , 4
					JNE Not_Esi_9
					Add Ebp , Esi
					JC enough
					mov current_value_Dword , Ebp
					jmp Done
				Not_Esi_9:
					cmp source_index , 5
					JNE Not_Edi_9
					Add Ebp , Edi
					JC enough
					mov current_value_Dword , Ebp
					jmp Done
				Not_Edi_9:
					cmp source_index , 6
					JNE Non_of_them_1220
					Add Ebp , Esi
					JC enough
					mov current_value_Dword , Ebp
					jmp Done
				Non_of_them_1220:
				Add Ebp , converted_number
				JC enough
				mov current_value_Dword , Ebp			
				jmp Done

	;-------------------------------------------
			;	-- word register -- 

		;		--------- Ax ---------
	Serarch_For_word_Register_8:
			cmp destenation_index,8
			JE its_Ax_1
			JNE Search_for_another_word_register_9
			its_Ax_1:
				cmp source_index , 9
				JNE Not_Bx_1568
				Add Ax , Bx
				JC enough
				mov current_value_word , Ax
				jmp Done_2
				Not_Bx_1568:
					cmp source_index , 10
					JNE Not_Cx_1036
					Add Ax , Cx
					JC enough
					mov current_value_word , Ax
					jmp Done_2
				Not_Cx_1036:
					cmp source_index , 11
					JNE Non_of_them_110
					Add Ax , Dx
					JC enough
					mov current_value_word , Ax
					jmp Done_2
				Non_of_them_110:
					Add ax , word ptr [converted_number]
					JC enough
					mov current_value_word , Ax			
					jmp Done_2

		;		--------- Bx ---------
			Search_for_another_word_register_9:
			cmp destenation_index,9
			JE its_Bx_2
			JNE Search_for_another_word_register_10
			its_Bx_2:
				cmp source_index , 8
				JNE Not_Ax_2158
				Add Bx , Ax
				JC enough
				mov current_value_word , Bx
				jmp Done_2
				Not_Ax_2158:
					cmp source_index , 10
					JNE Not_Cx_2
					Add Bx , Cx
					JC enough
					mov current_value_word , Bx
					jmp Done_2
				Not_Cx_2:
					cmp source_index , 11
					JNE Non_of_them_1200
					Add Bx , Dx
					JC enough
					mov current_value_word , Bx
					jmp Done_2
				Non_of_them_1200:
					Add bx , word ptr [ converted_number ]
					JC enough
					mov current_value_word , Bx			
					jmp Done_2

		;		--------- Cx ---------
			Search_for_another_word_register_10:
			cmp destenation_index,10
			JE its_Cx_3
			JNE Search_for_another_word_register_11
			its_Cx_3:
				cmp source_index , 8
				JNE Not_Ax_3
				Add Cx , Ax
				JC enough
				mov current_value_word , Cx
				jmp Done_2
				jmp Done
				Not_Ax_3:
					cmp source_index , 9
					JNE Not_Bx_3
					Add Cx , Bx
					JC enough
					mov current_value_word , Cx
					jmp Done_2
				Not_Bx_3:
					cmp source_index , 11
					JNE Non_of_them_1152
					Add Cx , Dx
					JC enough
					mov current_value_word , Cx
					jmp Done_2
				Non_of_them_1152:
					Add cx , word ptr [ converted_number ]
					JC enough
					mov current_value_word , Cx			
					jmp Done_2

		;		--------- Dx ---------
			Search_for_another_word_register_11:
			cmp destenation_index,11
			JE its_Dx_4
			JNE Search_for_another_byte_register_12
			its_Dx_4:
				cmp source_index , 8
				JNE Not_Ax_4
				Add Dx , Ax
				JC enough
				mov current_value_word , Dx
				jmp Done_2
				Not_Ax_4:
					cmp source_index , 9
					JNE Not_Bx_4
					Add Dx , Bx
					JC enough
					mov current_value_word , Dx
					jmp Done_2
				Not_Bx_4:
					cmp source_index , 10
					JNE Non_of_them_1355
					Add Dx , Cx
					JC enough
					mov current_value_word , Dx
					jmp Done_2
				Non_of_them_1355:
					Add dx , word ptr [ converted_number ]
					JC enough
					mov current_value_word , Dx			
					jmp Done_2

	;-------------------------------------------
			;	-- byte register -- 

	;		-------- Al ----------
		Search_for_another_byte_register_12:
			cmp destenation_index,12
			JE its_Al_1
			JNE Search_for_another_byte_register_13
			its_Al_1:
				cmp source_index , 14
				JNE Not_Bl_1
				Add Al , Bl
				JC enough
				mov current_value_byte , Al
				jmp Done_3
				Not_Bl_1:
					cmp source_index , 16
					JNE Not_Cl_111
					Add Al , Cl
					JC enough
					mov current_value_byte , Al
					jmp Done_3
				Not_Cl_111:
					cmp source_index , 18
					JNE it_Mem
					Add Al , Dl
					JC enough
					mov current_value_byte , Al
					jmp Done_3
				it_Mem:
					cmp source_index , 20
					JNE Non_of_them_14
					Add Al , user_variable
					Mov current_value_byte , Al
					jmp Done_3
				Non_of_them_14:
					Add al , byte ptr [ converted_number ]
					JC enough
					mov current_value_byte , Al		
					jmp Done_3

		;		-------- Bl ----------
			Search_for_another_byte_register_13:
				cmp destenation_index,14
				JE its_Bl_2
				JNE Search_for_another_byte_register_14
				its_Bl_2:
					cmp source_index , 12
					JNE Not_Al_266
					Add Bl , Al
					JC enough
					mov current_value_byte , Bl
					jmp Done_3
					Not_Al_266:
						cmp source_index , 16
						JNE Not_Cl_2
						Add Bl , Cl
						JC enough
						mov current_value_byte , Bl
						jmp Done_3
					Not_Cl_2:
						cmp source_index , 18
						JNE it_Mem_1
						Add Bl , Dl
						JC enough
						mov current_value_byte , Bl
						jmp Done_3
					it_Mem_1:
						cmp source_index , 20
						JNE Non_of_them_14
						Add Bl , user_variable
						Mov current_value_byte , Bl
						jmp Done_3
					Non_of_them_155:
						mov Ebx,0
						Add bl , byte ptr [ converted_number ]
						JC enough
						mov current_value_byte , Bl	
						jmp Done_3

		;		-------- Cl ----------
			Search_for_another_byte_register_14:
				cmp destenation_index,16
				JE its_Cl_3
				JNE Search_for_another_byte_register_15
				its_Cl_3:
					cmp source_index , 12
					JNE Not_Al_332
					Add Cl , Al
					JC enough
					mov current_value_byte , Cl
					jmp Done_3
					Not_Al_332:
						cmp source_index , 14
						JNE Not_Bl_113
						Add Cl , Bl
						JC enough
						mov current_value_byte , Cl
						jmp Done_3
					Not_Bl_113:
						cmp source_index , 18
						JNE it_Mem_3
						Add Cl , Dl
						JC enough
						mov current_value_byte , Cl
						jmp Done_3
					it_Mem_3:
						cmp source_index , 20
						JNE Non_of_them_16
						Add Cl , user_variable
						Mov current_value_byte , Cl
						jmp Done_3
					Non_of_them_16:
						Add cl , byte ptr [ converted_number ]
						JC enough
						mov current_value_byte , Cl	
						jmp Done_3

			;		-------- Dl ----------
			Search_for_another_byte_register_15:
				cmp destenation_index,18
				JE its_Dl_4
				JNE Search_for_Mem
				its_Dl_4:
					cmp source_index , 12
					JNE Not_Al_4
					Add Dl , Al
					JC enough
					mov current_value_byte , Dl
					jmp Done_3
					Not_Al_4:
						cmp source_index , 14
						JNE Not_Bl_4
						Add Dl , Bl
						JC enough
						mov current_value_byte , Dl
						jmp Done_3
					Not_Bl_4:
						cmp source_index , 16
						JNE it_Mem_4
						Add Dl , Cl
						JC enough
						mov current_value_byte , Dl
						jmp Done_3
					it_Mem_4:
						cmp source_index , 20
						JNE Non_of_them_1755
						Add Dl , user_variable
						Mov current_value_byte , Dl
						jmp Done_3
					Non_of_them_1755:
						Add dl , byte ptr [ converted_number ]
						JC enough
						mov current_value_byte , Dl	
						jmp Done_3

		;		-------- Memory ----------
		Search_for_Mem:
			cmp destenation_index,20
			JE its_Mem
			JNE Suitable_src_Not_Found
			its_Mem:
				cmp source_index , 12
				JNE Not_Al_45
				Add user_variable , Al
				PUSHAD
				Mov Al,user_variable
				POPAD
				Mov current_value_byte , Al
				jmp Done_3
				Not_Al_45:
					cmp source_index , 14
					JNE Not_Bl_46
					Add user_variable , Bl
					PUSHAD
					Mov Bl,user_variable
					POPAD
					Mov current_value_byte , Bl
					jmp Done_3
				Not_Bl_46:
					cmp source_index , 16
					JNE it_Dl_55
					Add user_variable , Cl
					PUSHAD
					Mov Cl,user_variable
					POPAD
					Mov current_value_byte , Cl
					jmp Done_3
				it_Dl_55:
					cmp source_index , 18
					JNE Non_of_them_190
					Add user_variable , Dl
					PUSHAD
					Mov Dl,user_variable
					POPAD
					Mov current_value_byte , Dl
					jmp Done_3
				Non_of_them_190:
					PUSHAD
					JC enough
					Mov Dl , byte ptr [ Converted_number ]
					Add user_variable , Dl
					Mov Dl , user_variable
					Mov current_value_byte , Dl		
					POPAD	
					jmp Done_3

		Suitable_src_Not_Found:

	Done:
		;	-- To out The Dword Registers --
		PushAD
		Call Display_Dword_Register
		PopAD
		jmp exit_add
	Done_2:
		;	-- To out The word Registers --
		PushAD
		Call Display_word_Register
		PopAD
		jmp exit_add
	Done_3:
		;	-- To out The Byte Registers --
		PushAD
		Call Display_byte_Register
		PopAD
		jmp exit_add
	enough:
		PushAD
		Call Over_Flow
		PopAd
	exit_add:
	ret
Add_Instruction Endp

;---------------------------------------------------------------------------------------------------------------------------
;		-- Sub_Instruction Procedure
Sub_Instruction Proc
	;		--------- Eax ---------
		cmp destenation_index,0
		JE its_Eax_112
		JNE Search_for_another_register_1145
		its_Eax_112:
			cmp source_index , 1
			JNE Not_Ebx_103
			Sub Eax , Ebx
			mov current_value_Dword , Eax		
			jmp Done
			Not_Ebx_103:
				cmp source_index , 2
				JNE Not_Ecx_1205
				Sub Eax , Ecx
				mov current_value_Dword , Eax				
				jmp Done
			Not_Ecx_1205:
				cmp source_index , 3
				JNE Not_Edx_125
				Sub Eax , Edx
				mov current_value_Dword , Eax			
				jmp Done
			Not_Edx_125:
				cmp source_index , 4
				JNE Not_Esi_203
				Sub Eax , Esi
				mov current_value_Dword , Eax			
				jmp Done
			Not_Esi_203:
				cmp source_index , 5
				JNE Not_Edi_2002
				Sub Eax , Edi
				mov current_value_Dword , Eax		
				jmp Done
			Not_Edi_2002:
				cmp source_index , 6
				JNE Not_Esp_2058
				Add Eax , Esp
				Sub current_value_Dword , Eax				
				jmp Done
			Not_Esp_2058:
				cmp source_index , 7
				JNE Non_of_them_256
				Sub Eax , Ebp
				mov current_value_Dword , Eax				
				jmp Done
			Non_of_them_256:
				Sub Eax , converted_number
				mov current_value_Dword , Eax				
				jmp Done

	;		--------- Ebx ---------
		Search_for_another_register_1145:
			cmp destenation_index,1
			JE its_Ebx_650
			JNE Search_for_another_register_2000
			its_Ebx_650:
				cmp source_index , 0
				JNE Not_Eax_1235
				Sub Ebx , Eax
				mov current_value_Dword , Ebx				
				jmp Done
				Not_Eax_1235:
					cmp source_index , 2
					JNE Not_Ecx_365
					Sub Ebx , Ecx
					mov current_value_Dword , Ebx
					jmp Done
				Not_Ecx_365:
					cmp source_index , 3
					JNE Not_Edx_656
					Sub Ebx , Edx
					mov current_value_Dword , Ebx
					jmp Done
				Not_Edx_656:
					cmp source_index , 4
					JNE Not_Esi_6535
					Sub Ebx , Esi
					mov current_value_Dword , Ebx
					jmp Done
				Not_Esi_6535:
					cmp source_index , 5
					JNE Not_Edi_8000
					Sub Ebx , Edi
					mov current_value_Dword , Ebx
					jmp Done
				Not_Edi_8000:
					cmp source_index , 6
					JNE Not_Esp_1035
					Sub Ebx , Esp
					mov current_value_Dword , Ebx
					jmp Done
				Not_Esp_1035:
					cmp source_index , 7
					JNE Non_of_them_4000
					Sub Ebx , Ebp
					mov current_value_Dword , Ebx
					jmp Done
				Non_of_them_4000:
				Sub Ebx , converted_number
				mov current_value_Dword , Ebx				
				jmp Done

		;		--------- Ecx ---------
			Search_for_another_register_2000:
			cmp destenation_index,2
			JE its_Ecx_436
			JNE Search_for_another_register_3000
			its_Ecx_436:
				cmp source_index , 0
				JNE Not_Eax_7002
				Sub Ecx , Eax
				mov current_value_Dword , Ecx		
				jmp Done
				Not_Eax_7002:
					cmp source_index , 1
					JNE Not_Ebx_1250
					Sub Ecx , Ebx
					mov current_value_Dword , Ecx
					jmp Done
				Not_Ebx_1250:
					cmp source_index , 3
					JNE Not_Edx_900
					Sub Ecx , Edx
					mov current_value_Dword , Ecx
					jmp Done
				Not_Edx_900:
					cmp source_index , 4
					JNE Not_Esi_4036
					Sub Ecx , Esi
					mov current_value_Dword , Ecx
					jmp Done
				Not_Esi_4036:
					cmp source_index , 5
					JNE Not_Edi_1500
					Sub Ecx , Edi
					mov current_value_Dword , Ecx
					jmp Done
				Not_Edi_1500:
					cmp source_index , 6
					JNE Not_Esp_1100
					Sub Ecx , Esp
					mov current_value_Dword , Ecx
					jmp Done
				Not_Esp_1100:
					cmp source_index , 7
					JNE Non_of_them_566
					Sub Ecx , Ebp
					mov current_value_Dword , Ecx
					jmp Done
				Non_of_them_566:
				Sub Ecx , converted_number
				mov current_value_Dword , Ecx				
				jmp Done

		;		--------- Edx ---------
			Search_for_another_register_3000:
			cmp destenation_index,3
			JE its_Edx_599
			JNE Search_for_another_register_4300
			its_Edx_599:
				cmp source_index , 0
				JNE Not_Eax_1550
				Sub Edx , Eax
				mov current_value_Dword , Edx
				jmp Done
				Not_Eax_1550:
					cmp source_index , 1
					JNE Not_Ebx_4566
					Sub Edx , Ebx
					mov current_value_Dword , Edx
					jmp Done
				Not_Ebx_4566:
					cmp source_index , 2
					JNE Not_Ecx_855
					Sub Edx , Ecx
					mov current_value_Dword , Edx
					jmp Done
				Not_Ecx_855:
					cmp source_index , 4
					JNE Not_Esi_5026
					Sub Edx , Esi
					mov current_value_Dword , Edx
					jmp Done
				Not_Esi_5026:
					cmp source_index , 5
					JNE Not_Edi_1065
					Sub Edx , Edi
					mov current_value_Dword , Edx
					jmp Done
				Not_Edi_1065:
					cmp source_index , 6
					JNE Not_Esp_755
					Sub Edx , Esp
					mov current_value_Dword , Edx
					jmp Done
				Not_Esp_755:
					cmp source_index , 7
					JNE Non_of_them_3200
					Sub Edx , Ebp
					mov current_value_Dword , Edx
					jmp Done
				Non_of_them_3200:
				Sub Edx , converted_number
				mov current_value_Dword , Edx				
				jmp Done
	
		;		--------- Esi ---------
			Search_for_another_register_4300:
			cmp destenation_index,4
			JE its_Esi_2205
			JNE Search_for_another_register_5025
			its_Esi_2205:
				cmp source_index , 0
				JNE Not_Eax_4455
				Sub Esi , Eax
				mov current_value_Dword , Esi			
				jmp Done
				Not_Eax_4455:
					cmp source_index , 1
					JNE Not_Ebx_2020
					Sub Esi , Ebx
					mov current_value_Dword , Esi
					jmp Done
				Not_Ebx_2020:
					cmp source_index , 2
					JNE Not_Ecx_4700
					Sub Esi , Ecx
					mov current_value_Dword , Esi
					jmp Done
				Not_Ecx_4700:
					cmp source_index , 3
					JNE Not_Edx_1454
					Sub Esi , Edx
					mov current_value_Dword , Esi
					jmp Done
				Not_Edx_1454:
					cmp source_index , 5
					JNE Not_Edi_3620
					Sub Esi , Edi
					mov current_value_Dword , Esi
					jmp Done
				Not_Edi_3620:
					cmp source_index , 6
					JNE Not_Esp_6269
					Sub Esi , Esp
					mov current_value_Dword , Esi
					jmp Done
				Not_Esp_6269:
					cmp source_index , 7
					JNE Non_of_them_1170
					Sub Esi , Ebp
					mov current_value_Dword , Esi
					jmp Done
				Non_of_them_1170:
				Sub Esi , converted_number
				mov current_value_Dword , Esi				
				jmp Done

		;		--------- Edi ---------
			Search_for_another_register_5025:
			cmp destenation_index,5
			JE its_Edi_7689
			JNE Search_for_another_register_6300
			its_Edi_7689:
				cmp source_index , 0
				JNE Not_Eax_1360
				Sub Edi , Eax
				mov current_value_Dword , Edi				
				jmp Done
				Not_Eax_1360:
					cmp source_index , 1
					JNE Not_Ebx_1708
					Sub Edi , Ebx
					mov current_value_Dword , Edi
					jmp Done
				Not_Ebx_1708:
					cmp source_index , 2
					JNE Not_Ecx_7450
					Sub Edi , Ecx
					mov current_value_Dword , Edi
					jmp Done
				Not_Ecx_7450:
					cmp source_index , 3
					JNE Not_Edx_1380
					Sub Edi , Edx
					mov current_value_Dword , Edi
					jmp Done
				Not_Edx_1380:
					cmp source_index , 4
					JNE Not_Esi_13350
					Sub Edi , Esi
					mov current_value_Dword , Edi
					jmp Done
				Not_Esi_13350:
					cmp source_index , 6
					JNE Not_Esp_798
					Sub Edi , Esp
					mov current_value_Dword , Edi
					jmp Done
				Not_Esp_798:
					cmp source_index , 7
					JNE Non_of_them_8550
					Sub Edi , Ebp
					mov current_value_Dword , Edi
					jmp Done
				Non_of_them_8550:
				Sub Edi , converted_number
				mov current_value_Dword , Edi			
				jmp Done

		;		--------- Esp ---------
			Search_for_another_register_6300:
			cmp destenation_index,6
			JE its_Esp_890
			JNE Search_for_another_register_7000
			its_Esp_890:
				cmp source_index , 0
				JNE Not_Eax_860
				Sub Esp , Eax
				mov current_value_Dword , Esp
				jmp Done
				Not_Eax_860:
					cmp source_index , 1
					JNE Not_Ebx_870
					Sub Esp , Ebx
					mov current_value_Dword , Esp
					jmp Done
				Not_Ebx_870:
					cmp source_index , 2
					JNE Not_Ecx_865
					Sub Esp , Ecx
					mov current_value_Dword , Esp
					jmp Done
				Not_Ecx_865:
					cmp source_index , 3
					JNE Not_Edx_837
					Sub Esp , Edx
					mov current_value_Dword , Esp
					jmp Done
				Not_Edx_837:
					cmp source_index , 4
					JNE Not_Esi_899
					Sub Esp , Esi
					mov current_value_Dword , Esp
					jmp Done
				Not_Esi_899:
					cmp source_index , 5
					JNE Not_Edi_844
					Sub Esp , Edi
					mov current_value_Dword , Esp
					jmp Done
				Not_Edi_844:
					cmp source_index , 7
					JNE Non_of_them_9330
					Sub Esp , Ebp
					mov current_value_Dword , Esp
					jmp Done
				Non_of_them_9330:
				Sub Esp , converted_number
				mov current_value_Dword , Esp				
				jmp Done

		;		--------- Ebp ---------
			Search_for_another_register_7000:
			cmp destenation_index,7
			JE its_Ebp_10099
			JNE Serarch_For_word_Register_8000
			its_Ebp_10099:
				cmp source_index , 0
				JNE Not_Eax_9657
				Sub Ebp , Eax
				mov current_value_Dword , Ebp
				jmp Done
				Not_Eax_9657:
					cmp source_index , 1
					JNE Not_Ebx_957
					Sub Ebp , Ebx
					mov current_value_Dword , Ebp
					jmp Done
				Not_Ebx_957:
					cmp source_index , 2
					JNE Not_Ecx_957
					Sub Ebp , Ecx
					mov current_value_Dword , Ebp
					jmp Done
				Not_Ecx_957:
					cmp source_index , 3
					JNE Not_Edx_957
					Sub Ebp , Edx
					mov current_value_Dword , Ebp
					jmp Done
				Not_Edx_957:
					cmp source_index , 4
					JNE Not_Esi_957
					Sub Ebp , Esi
					mov current_value_Dword , Ebp
					jmp Done
				Not_Esi_957:
					cmp source_index , 5
					JNE Not_Edi_957
					Sub Ebp , Edi
					mov current_value_Dword , Ebp
					jmp Done
				Not_Edi_957:
					cmp source_index , 6
					JNE Non_of_them_957
					Sub Ebp , Esi
					mov current_value_Dword , Ebp
					jmp Done
				Non_of_them_957:
				Sub Ebp , converted_number
				mov current_value_Dword , Ebp			
				jmp Done
	;-------------------------------------------
			;	-- word register -- 

		;		--------- Ax ---------
	Serarch_For_word_Register_8000:
			cmp destenation_index,8
			JE its_Ax_190
			JNE Search_for_another_word_register_9000
			its_Ax_190:
				cmp source_index , 9
				JNE Not_Bx_190
				Sub Ax , Bx
				mov current_value_word , Ax
				jmp Done_2
				Not_Bx_190:
					cmp source_index , 10
					JNE Not_Cx_190
					Sub Ax , Cx
					mov current_value_word , Ax
					jmp Done_2
				Not_Cx_190:
					cmp source_index , 11
					JNE Non_of_them_190
					Sub Ax , Dx
					mov current_value_word , Ax
					jmp Done_2
				Non_of_them_190:
					Sub ax , word ptr [ converted_number ]
					mov current_value_word , Ax			
					jmp Done_2

		;		--------- Bx ---------
			Search_for_another_word_register_9000:
			cmp destenation_index,9
			JE its_Bx_99
			JNE Search_for_another_word_register_10000
			its_Bx_99:
				cmp source_index , 8
				JNE Not_Ax_99
				Sub Bx , Ax
				mov current_value_word , Bx
				jmp Done_2
				Not_Ax_99:
					cmp source_index , 10
					JNE Not_Cx_99
					Sub Bx , Cx
					mov current_value_word , Bx
					jmp Done_2
				Not_Cx_99:
					cmp source_index , 11
					JNE Non_of_them_99
					Sub Bx , Dx
					mov current_value_word , Bx
					jmp Done_2
				Non_of_them_99:
					Sub bx , word ptr [ converted_number ]
					mov current_value_word , Bx			
					jmp Done_2

		;		--------- Cx ---------
			Search_for_another_word_register_10000:
			cmp destenation_index,10
			JE its_Cx_620
			JNE Search_for_another_word_register_11000
			its_Cx_620:
				cmp source_index , 8
				JNE Not_Ax_620
				Sub Cx , Ax
				mov current_value_word , Cx
				jmp Done_2
				jmp Done
				Not_Ax_620:
					cmp source_index , 9
					JNE Not_Bx_620
					Sub Cx , Bx
					mov current_value_word , Cx
					jmp Done_2
				Not_Bx_620:
					cmp source_index , 11
					JNE Non_of_them_620
					Sub Cx , Dx
					mov current_value_word , Cx
					jmp Done_2
				Non_of_them_620:
					Sub cx , word ptr [ converted_number ]
					mov current_value_word , Cx			
					jmp Done_2

		;		--------- Dx ---------
			Search_for_another_word_register_11000:
			cmp destenation_index,11
			JE its_Dx_3699
			JNE Search_for_another_byte_register_12000
			its_Dx_3699:
				cmp source_index , 8
				JNE Not_Ax_3699
				Sub Dx , Ax
				mov current_value_word , Dx
				jmp Done_2
				Not_Ax_3699:
					cmp source_index , 9
					JNE Not_Bx_3699
					Sub Dx , Bx
					mov current_value_word , Dx
					jmp Done_2
				Not_Bx_3699:
					cmp source_index , 10
					JNE Non_of_them_3699
					Sub Dx , Cx
					mov current_value_word , Dx
					jmp Done_2
				Non_of_them_3699:
					Sub dx , word ptr [ converted_number ]
					mov current_value_word , Dx			
					jmp Done_2

	;-------------------------------------------
			;	-- byte register -- 

	;		-------- Al ----------
		Search_for_another_byte_register_12000:
			cmp destenation_index,12
			JE its_Al_77
			JNE Search_for_another_byte_register_13000
			its_Al_77:
				cmp source_index , 14
				JNE Not_Bl_77
				Sub Al , Bl
				mov current_value_byte , Al
				jmp Done_3
				Not_Bl_77:
					cmp source_index , 16
					JNE Not_Cl_1110
					Sub Al , Cl
					mov current_value_byte , Al
					jmp Done_3
				Not_Cl_1110:
					cmp source_index , 18
					JNE it_Mem
					Sub Al , Dl
					mov current_value_byte , Al
					jmp Done_3
				it_Mem:
					cmp source_index , 20
					JNE Non_of_them_1410
					Sub Al , user_variable
					Mov current_value_byte , Al
					jmp Done_3
				Non_of_them_1410:
					Sub al , byte ptr [ converted_number ]
					mov current_value_byte , Al		
					jmp Done_3

		;		-------- Bl ----------
			Search_for_another_byte_register_13000:
				cmp destenation_index,14
				JE its_Bl_668
				JNE Search_for_another_byte_register_14000
				its_Bl_668:
					cmp source_index , 12
					JNE Not_Al_668
					Sub Bl , Al
					mov current_value_byte , Bl
					jmp Done_3
					Not_Al_668:
						cmp source_index , 16
						JNE Not_Cl_668
						Sub Bl , Cl
						mov current_value_byte , Bl
						jmp Done_3
					Not_Cl_668:
						cmp source_index , 18
						JNE it_Mem_2
						Sub Bl , Dl
						mov current_value_byte , Bl
						jmp Done_3
					it_Mem_2:
						cmp source_index , 20
						JNE Non_of_them_668
						Sub Bl , user_variable
						Mov current_value_byte , Bl
						jmp Done_3
					Non_of_them_668:
						Sub bl , byte ptr [ converted_number ]
						mov current_value_byte , Bl	
						jmp Done_3

		;		-------- Cl ----------
			Search_for_another_byte_register_14000:
				cmp destenation_index,16
				JE its_Cl_590
				JNE Search_for_another_byte_register_15000
				its_Cl_590:
					cmp source_index , 12
					JNE Not_Al_590
					Sub Cl , Al
					mov current_value_byte , Cl
					jmp Done_3
					Not_Al_590:
						cmp source_index , 14
						JNE Not_Bl_950
						Sub Cl , Bl
						mov current_value_byte , Cl
						jmp Done_3
					Not_Bl_950:
						cmp source_index , 18
						JNE it_Mem_3
						Sub Cl , Dl
						mov current_value_byte , Cl
						jmp Done_3
					it_Mem_3:
						cmp source_index , 20
						JNE Non_of_them_950
						Sub Cl , user_variable
						Mov current_value_byte , Cl
						jmp Done_3
					Non_of_them_950:
						Sub cl , byte ptr [ converted_number ]
						mov current_value_byte , Cl	
						jmp Done_3

			;		-------- Dl ----------
			Search_for_another_byte_register_15000:
				cmp destenation_index,18
				JE its_Dl_632
				JNE Search_for_Memory
				its_Dl_632:
					cmp source_index , 12
					JNE Not_Al_632
					Sub Dl , Al
					mov current_value_byte , Dl
					jmp Done_3
					Not_Al_632:
						cmp source_index , 14
						JNE Not_Bl_632
						Sub Dl , Bl
						mov current_value_byte , Dl
						jmp Done_3
					Not_Bl_632:
						cmp source_index , 16
						JNE it_Mem_4
						Sub Dl , Cl
						mov current_value_byte , Dl
						jmp Done_3
					it_Mem_4:
						cmp source_index , 20
						JNE Non_of_them_632
						Sub Dl , user_variable
						Mov current_value_byte , Dl
						jmp Done_3
					Non_of_them_632:
						Sub dl , byte ptr [ converted_number ]
						mov current_value_byte , Dl	
						jmp Done_3

		;		-------- Memory ----------
		Search_for_Memory:
			cmp destenation_index,20
			JE its_Mem
			JNE I_finished_from_all_registers_2
			its_Mem:
				cmp source_index , 12
				JNE Not_Al_45
				Sub user_variable , Al
				PUSHAD
				Mov Al,user_variable
				POPAD
				Mov current_value_byte , Al
				jmp Done_3
				Not_Al_45:
					cmp source_index , 14
					JNE Not_Bl_46
					Sub user_variable , Bl
					PUSHAD
					Mov Bl,user_variable
					POPAD
					Mov current_value_byte , Bl
					jmp Done_3
				Not_Bl_46:
					cmp source_index , 16
					JNE it_Dl_55
					Sub user_variable , Cl
					PUSHAD
					Mov Cl,user_variable
					POPAD
					Mov current_value_byte , Cl
					jmp Done_3
				it_Dl_55:
					cmp source_index , 18
					JNE Non_of_them_199
					Sub user_variable , Dl
					PUSHAD
					Mov Dl,user_variable
					POPAD
					Mov current_value_byte , Dl
					jmp Done_3
				Non_of_them_199:
					PUSHAD
					JC enough
					Mov Dl , byte ptr [ Converted_number ]
					Sub user_variable , Dl
					Mov Dl , user_variable
					Mov current_value_byte , Dl		
					POPAD	
					jmp Done_3

		I_finished_from_all_registers_2:
			PushAd
			Mov Edx,offset output
			Call writeString
			Mov Edx,offset Destenation_Not_Found_Error
			Call writeString
			Call Crlf
			JMP enough

	Done:
		;	-- To out The Dword Registers --
		PushAD
		Call Display_Dword_Register
		jmp enough
	Done_2:
		;	-- To out The word Registers --
		PushAd
		Call Display_word_Register
		jmp enough
	Done_3:
		;	-- To out The Byte Registers --
		PushAD
		Call Display_byte_Register
	enough:
		PopAd
	ret
Sub_Instruction Endp

;---------------------------------------------------------------------------------------------------------------------------
;		-- Mul_Instruction Procedure
Mul_Instruction Proc
	;		--------- Eax ---------
	cmp destenation_index,0
	JE its_Eax
	JNE Search_for_another_register
	its_Eax:
		Mul Eax
		Mov current_value_Dword , Eax
		Mov current_value_Dword_2 , Edx
		cmp Edx , 0
		jne enough
		jmp Done

;		--------- Ebx ---------
	Search_for_another_register:
		cmp destenation_index,1
		JE its_Ebx_1
		JNE Search_for_another_register_1
		its_Ebx_1:
			Mul Ebx
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done
	;		--------- Ecx ---------
		Search_for_another_register_1:
		cmp destenation_index,2
		JE its_Ecx_2
		JNE Search_for_another_register_2
		its_Ecx_2:
			Mul Ecx
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done

	;		--------- Edx ---------
		Search_for_another_register_2:
		cmp destenation_index,3
		JE its_Edx_3
		JNE Search_for_another_register_3
		its_Edx_3:
			Mul Edx
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done
	
	;		--------- Esi ---------
		Search_for_another_register_3:
		cmp destenation_index,4
		JE its_Esi_4
		JNE Search_for_another_register_4
		its_Esi_4:
			Mul Esi
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done

	;		--------- Edi ---------
		Search_for_another_register_4:
		cmp destenation_index,5
		JE its_Edi_5
		JNE Search_for_another_register_5
		its_Edi_5:
			Mul Edi
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done

	;		--------- Esp ---------
		Search_for_another_register_5:
		cmp destenation_index,6
		JE its_Esp_6
		JNE Search_for_another_register_6
		its_Esp_6:
			Mul Esp
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done

	;		--------- Ebp ---------
		Search_for_another_register_6:
		cmp destenation_index,7
		JE its_Ebp
		JNE Serarch_For_word_Register
		its_Ebp:
			Mul Ebp
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done

;-------------------------------------------
		;	-- word register -- 

	;		--------- Ax ---------
Serarch_For_word_Register:
		cmp destenation_index,8
		JE its_Ax
		JNE Search_for_another_word_register_1
		its_Ax:
			Mul Ax
			Mov current_value_word , Ax
			Mov current_value_word_2 , Dx
			cmp dx , 0
			jne enough
			jmp Done_2

	;		--------- Bx ---------
		Search_for_another_word_register_1:
		cmp destenation_index,9
		JE its_Bx
		JNE Search_for_another_word_register_2
		its_Bx:
			Mul Bx
			Mov current_value_word , Ax
			Mov current_value_word_2 , Dx
			cmp dx , 0
			jne enough
			jmp Done_2

	;		--------- Cx ---------
		Search_for_another_word_register_2:
		cmp destenation_index,10
		JE its_Cx
		JNE Search_for_another_word_register_3
		its_Cx:
			Mul Cx
			Mov current_value_word , Ax
			Mov current_value_word_2 , Dx
			cmp dx , 0
			jne enough
			jmp Done_2
	;		--------- Dx ---------
		Search_for_another_word_register_3:
		cmp destenation_index,11
		JE its_Dx
		JNE Search_for_another_byte_register
		its_Dx:
			Mul Dx
			Mov current_value_word , Ax
			Mov current_value_word_2 , Dx
			cmp dx , 0
			jne enough
			jmp Done_2

;-------------------------------------------
		;	-- byte register -- 

;		-------- Al ----------
	Search_for_another_byte_register:
		cmp destenation_index,12
		JE its_Al
		JNE Search_for_another_byte_register_2
		its_Al:
			Mul Al
			Mov current_value_byte , Al
			Mov current_value_byte_2 , Ah
			cmp Ah , 0
			jne enough
			jmp Done_3

	;		-------- Bl ----------
		Search_for_another_byte_register_2:
			cmp destenation_index,14
			JE its_Bl
			JNE Search_for_another_byte_register_4
			its_Bl:
			Mul Bl
			Mov current_value_byte , Al
			Mov current_value_byte_2 , Ah
			cmp Ah , 0
			jne enough
			jmp Done_3

	;		-------- Cl ----------
		Search_for_another_byte_register_4:
			cmp destenation_index,16
			JE its_Cl
			JNE Search_for_another_byte_register_6
			its_Cl:
				Mul Cl
				Mov current_value_byte , Al
				Mov current_value_byte_2 , Ah
				cmp Ah , 0
				jne enough
				jmp Done_3

		;		-------- Dl ----------
		Search_for_another_byte_register_6:
			cmp destenation_index,18
			JE its_Dl
			JNE Search_for_Memory
			its_Dl:
				Mul Dl
				Mov current_value_byte , Al
				Mov current_value_byte_2 , Ah
				cmp Ah , 0
				jne enough			
				jmp Done_3

		;		-------- Memory ----------
		Search_for_Memory:
			cmp destenation_index,20
			JE its_Mem
			JNE Destenation_Not_Found
			its_Mem:
				Mul user_variable
				Mov current_value_byte , Al
				Mov current_value_byte_2 , Ah
				cmp Ah , 0
				jne enough			
				jmp Done_3

	Destenation_Not_Found:

	Done:
		;	-- To out The Dword Registers --
		PushAD
		Call Display_Dword_Register
		PopAD
		jmp exit_add
	Done_2:
		;	-- To out The word Registers --
		PushAD
		Call Display_word_Register
		PopAD
		jmp exit_add
	Done_3:
		;	-- To out The Byte Registers --
		PushAD
		Call Display_byte_Register
		PopAD
		jmp exit_add
	enough:
	    PushAD
	    Call Over_Flow
	    PopAd
	exit_add :
	ret
Mul_Instruction Endp

;---------------------------------------------------------------------------------------------------------------------------
;		-- Div_Instruction Procedure
Div_Instruction Proc
;		--------- Eax ---------
	cmp destenation_index,0
	JE its_Eax
	JNE Search_for_another_register
	its_Eax:
		cmp Eax,0
		JE Its_Zero
		Div Eax
		Mov current_value_Dword , Eax
		Mov current_value_Dword_2 , Edx
		cmp Edx , 0
		jne enough
		jmp Done

;		--------- Ebx ---------
	Search_for_another_register:
		cmp destenation_index,1
		JE its_Ebx_1
		JNE Search_for_another_register_1
		its_Ebx_1:
			cmp Ebx,0
			JE Its_Zero
			Div Ebx
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done
	;		--------- Ecx ---------
		Search_for_another_register_1:
		cmp destenation_index,2
		JE its_Ecx_2
		JNE Search_for_another_register_2
		its_Ecx_2:
			cmp Ecx,0
			JE Its_Zero
			Div Ecx
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done

	;		--------- Edx ---------
		Search_for_another_register_2:
		cmp destenation_index,3
		JE its_Edx_3
		JNE Search_for_another_register_3
		its_Edx_3:
			cmp Edx,0
			JE Its_Zero
			Div Edx
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done
	
	;		--------- Esi ---------
		Search_for_another_register_3:
		cmp destenation_index,4
		JE its_Esi_4
		JNE Search_for_another_register_4
		its_Esi_4:
			cmp Esi,0
			JE Its_Zero
			Div Esi
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done

	;		--------- Edi ---------
		Search_for_another_register_4:
		cmp destenation_index,5
		JE its_Edi_5
		JNE Search_for_another_register_5
		its_Edi_5:
			cmp Edi,0
			JE Its_Zero
			Div Edi
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done

	;		--------- Esp ---------
		Search_for_another_register_5:
		cmp destenation_index,6
		JE its_Esp_6
		JNE Search_for_another_register_6
		its_Esp_6:
			cmp Esp,0
			JE Its_Zero
			Div Esp
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done

	;		--------- Ebp ---------
		Search_for_another_register_6:
		cmp destenation_index,7
		JE its_Ebp
		JNE Serarch_For_word_Register
		its_Ebp:
			cmp Ebp,0
			JE Its_Zero
			Div Ebp
			Mov current_value_Dword , Eax
			Mov current_value_Dword_2 , Edx
			cmp Edx , 0
			jne enough
			jmp Done

;-------------------------------------------
		;	-- word register -- 

	;		--------- Ax ---------
Serarch_For_word_Register:
		cmp destenation_index,8
		JE its_Ax
		JNE Search_for_another_word_register_1
		its_Ax:
			cmp Ax,0
			JE Its_Zero
			Div Ax
			Mov current_value_word , Ax
			Mov current_value_word_2 , Dx
			cmp Dx , 0
			jne enough
			jmp Done_2

	;		--------- Bx ---------
		Search_for_another_word_register_1:
		cmp destenation_index,9
		JE its_Bx
		JNE Search_for_another_word_register_2
		its_Bx:
			cmp Bx,0
			JE Its_Zero
			Div Bx
			Mov current_value_word , Ax
			Mov current_value_word_2 , Dx
			cmp Dx , 0
			jne enough
			jmp Done_2

	;		--------- Cx ---------
		Search_for_another_word_register_2:
		cmp destenation_index,10
		JE its_Cx
		JNE Search_for_another_word_register_3
		its_Cx:
			cmp Cx,0
			JE Its_Zero
			Div Cx
			Mov current_value_word , Ax
			Mov current_value_word_2 , Dx
			cmp Dx , 0
			jne enough
			jmp Done_2
	;		--------- Dx ---------
		Search_for_another_word_register_3:
		cmp destenation_index,11
		JE its_Dx
		JNE Search_for_another_byte_register
		its_Dx:
			cmp Dx,0
			JE Its_Zero
			Div Dx
			Mov current_value_word , Ax
			Mov current_value_word_2 , Dx
			cmp Dx , 0
			jne enough
			jmp Done_2

;-------------------------------------------
		;	-- byte register -- 

;		-------- Al ----------
	Search_for_another_byte_register:
		cmp destenation_index,12
		JE its_Al
		JNE Search_for_another_byte_register_2
		its_Al:
			cmp Al,0
			JE Its_Zero
			Div Al
			Mov current_value_byte , Al
			Mov current_value_byte_2 , Ah
			cmp Ah , 0
			jne enough
			jmp Done_3

	;		-------- Bl ----------
		Search_for_another_byte_register_2:
			cmp destenation_index,14
			JE its_Bl
			JNE Search_for_another_byte_register_4
			its_Bl:
				cmp Bl,0
				JE Its_Zero
				Div Bl
				Mov current_value_byte , Al
				Mov current_value_byte_2 , Ah
				cmp Ah , 0
				jne enough
				jmp Done_3

	;		-------- Cl ----------
		Search_for_another_byte_register_4:
			cmp destenation_index,16
			JE its_Cl
			JNE Search_for_another_byte_register_6
			its_Cl:
				cmp Cl,0
				JE Its_Zero
				Div Cl
				Mov current_value_byte , Al
				Mov current_value_byte_2 , Ah
				cmp Ah , 0
				jne enough
				jmp Done_3

		;		-------- Dl ----------
		Search_for_another_byte_register_6:
			cmp destenation_index,18
			JE its_Dl
			JNE Search_for_Memory
			its_Dl:
				cmp Dl,0
				JE Its_Zero
				Div Dl
				Mov current_value_byte , Al
				Mov current_value_byte_2 , Ah
				cmp Ah , 0
				jne enough			
				jmp Done_3

		;		-------- Memory ----------
		Search_for_Memory:
			cmp destenation_index,20
			JE its_Mem
			JNE Destenation_Not_Found
			its_Mem:
				Div user_variable
				Mov current_value_byte , Al
				Mov current_value_byte_2 , Ah
				cmp Ah , 0
				jne enough			
				jmp Done_3

	Destenation_Not_Found:

	Its_Zero:

	Done:
		;	-- To out The Dword Registers --
		PushAD
		Call Display_Dword_Register
		PopAD
		jmp exit_add
	Done_2:
		;	-- To out The word Registers --
		PushAD
		Call Display_word_Register
		PopAD
		jmp exit_add
	Done_3:
		;	-- To out The Byte Registers --
		PushAD
		Call Display_byte_Register
		PopAD
		jmp exit_add
	enough:
	   	PushAD
	    Call Over_Flow
	    PopAd
	exit_add :
	ret
Div_Instruction Endp

;---------------------------------------------------------------------------------------------------------------------------
;		-- Neg_Instruction Procedure--		Don't Forget To Make PRoc for prevent using Neg with Numbers
Neg_Instruction Proc
	;		--------- Eax ---------
	cmp destenation_index,0
	JE its_Eax
	JNE Search_for_another_register
	its_Eax:
		Neg Eax
		Mov current_value_Dword , Eax
		jmp Done

;		--------- Ebx ---------
	Search_for_another_register:
		cmp destenation_index,1
		JE its_Ebx_1
		JNE Search_for_another_register_1
		its_Ebx_1:
			Neg Ebx
			Mov current_value_Dword , Ebx				
			jmp Done
	;		--------- Ecx ---------
		Search_for_another_register_1:
		cmp destenation_index,2
		JE its_Ecx_2
		JNE Search_for_another_register_2
		its_Ecx_2:
			Neg Ecx
			Mov current_value_Dword , Ecx
			jmp Done

	;		--------- Edx ---------
		Search_for_another_register_2:
		cmp destenation_index,3
		JE its_Edx_3
		JNE Search_for_another_register_3
		its_Edx_3:
			Neg Edx 
			Mov current_value_Dword , Edx
			jmp Done
	
	;		--------- Esi ---------
		Search_for_another_register_3:
		cmp destenation_index,4
		JE its_Esi_4
		JNE Search_for_another_register_4
		its_Esi_4:
			Neg Esi
			Mov current_value_Dword , Esi			
			jmp Done

	;		--------- Edi ---------
		Search_for_another_register_4:
		cmp destenation_index,5
		JE its_Edi_5
		JNE Search_for_another_register_5
		its_Edi_5:
			Neg Edi
			Mov current_value_Dword , Edi				
			jmp Done

	;		--------- Esp ---------
		Search_for_another_register_5:
		cmp destenation_index,6
		JE its_Esp_6
		JNE Search_for_another_register_6
		its_Esp_6:
			Neg Esp
			Mov current_value_Dword , Esp
			jmp Done

	;		--------- Ebp ---------
		Search_for_another_register_6:
		cmp destenation_index,7
		JE its_Ebp
		JNE Serarch_For_word_Register
		its_Ebp:
			Neg Ebp
			Mov current_value_Dword , Ebp
			jmp Done

;-------------------------------------------
		;	-- word register -- 

	;		--------- Ax ---------
Serarch_For_word_Register:
		cmp destenation_index,8
		JE its_Ax
		JNE Search_for_another_word_register_1
		its_Ax:
			Neg Ax
			Mov current_value_word , Ax
			jmp Done_2

	;		--------- Bx ---------
		Search_for_another_word_register_1:
		cmp destenation_index,9
		JE its_Bx
		JNE Search_for_another_word_register_2
		its_Bx:
			Neg Bx
			Mov current_value_word , Bx
			jmp Done_2

	;		--------- Cx ---------
		Search_for_another_word_register_2:
		cmp destenation_index,10
		JE its_Cx
		JNE Search_for_another_word_register_3
		its_Cx:
			Neg Cx
			Mov current_value_word , Cx
			jmp Done_2
	;		--------- Dx ---------
		Search_for_another_word_register_3:
		cmp destenation_index,11
		JE its_Dx
		JNE Search_for_another_byte_register
		its_Dx:
			Neg Dx
			Mov current_value_word , Dx
			jmp Done_2

;-------------------------------------------
		;	-- byte register -- 

;		-------- Al ----------
	Search_for_another_byte_register:
		cmp destenation_index,12
		JE its_Al
		JNE Search_for_another_byte_register_2
		its_Al:
			Neg Al
			Mov current_value_byte , Al
			jmp Done_3

	;		-------- Bl ----------
		Search_for_another_byte_register_2:
			cmp destenation_index,14
			JE its_Bl
			JNE Search_for_another_byte_register_4
			its_Bl:
				Neg Bl
				Mov current_value_byte , Bl
				jmp Done_3

	;		-------- Cl ----------
		Search_for_another_byte_register_4:
			cmp destenation_index,16
			JE its_Cl
			JNE Search_for_another_byte_register_6
			its_Cl:
				Neg Cl
				Mov current_value_byte , Cl
				jmp Done_3

		;		-------- Dl ----------
		Search_for_another_byte_register_6:
			cmp destenation_index,18
			JE its_Dl
			JNE Search_for_Memory
			its_Dl:
				Neg Dl
				Mov current_value_byte , Dl
				jmp Done_3

		;		-------- Memory ----------
		Search_for_Memory:
			cmp destenation_index,20
			JE its_Mem
			JNE Destenation_Not_Found
			its_Mem:
				Neg user_variable
				PUSHAD
				MOV Al,user_variable
				Mov current_value_byte , Al	
				POPAD	
				jmp Done_3

	Destenation_Not_Found:

	Done:
		;	-- To out The Dword Registers --
		Call Display_Dword_Register
		jmp enough
	Done_2:
		;	-- To out The word Registers --
		Call Display_word_Register
		jmp enough
	Done_3:
		;	-- To out The Byte Registers --
		Call Display_byte_Register
	enough:
	ret
Neg_Instruction Endp

;---------------------------------------------------------------------------------------------------------------------------
;		-- Movzx_Instruction Procedure
Movzx_Instruction Proc
	;		--------- Eax ---------
	cmp destenation_index,0
	JE its_Eax
	JNE Search_for_another_register
	its_Eax:
		cmp source_index , 8
		JNE Not_Ax
		Movzx Eax , Ax
		Mov current_value_Dword , Eax		
		jmp Done
		Not_Ax:
			cmp source_index , 9
			JNE Not_Bx
			Movzx Eax , Bx
			Mov current_value_Dword , Eax				
			jmp Done
		Not_Bx:
			cmp source_index , 10
			JNE Not_Cx
			Movzx Eax , Cx
			Mov current_value_Dword , Eax			
			jmp Done
		Not_Cx:
			cmp source_index , 11
			JNE Not_Dx
			Movzx Eax , Dx
			Mov current_value_Dword , Eax			
			jmp Done
		Not_Dx:
			cmp source_index , 12
			JNE Not_Al
			Movzx Eax , Al
			Mov current_value_Dword , Eax		
			jmp Done
		Not_Al:
			cmp source_index , 14
			JNE Not_Bl
			Movzx Eax , Bl
			Mov current_value_Dword , Eax				
			jmp Done
		Not_Bl:
			cmp source_index , 16
			JNE Not_Cl
			Movzx Eax , Cl
			Mov current_value_Dword , Eax				
			jmp Done
		Not_Cl:
			cmp source_index , 18
			JNE look_for_mem
			Movzx Eax , Dl
			Mov current_value_Dword , Eax				
			jmp Done
		look_for_mem:
			cmp source_index , 20
			JNE source_Not_Found
			Movzx Eax , user_variable
			Mov current_value_Dword , Eax				
			jmp Done

	source_Not_Found:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register:
		;		--------- Ebx ---------
	cmp destenation_index,1
	JE its_Ebx
	JNE Search_for_another_register_1
	its_Ebx:
		cmp source_index , 8
		JNE Not_Ax_1
		Movzx Ebx , Ax
		Mov current_value_Dword , Ebx		
		jmp Done
		Not_Ax_1:
			cmp source_index , 9
			JNE Not_Bx_1
			Movzx Ebx , Bx
			Mov current_value_Dword , Ebx				
			jmp Done
		Not_Bx_1:
			cmp source_index , 10
			JNE Not_Cx_1
			Movzx Ebx , Cx
			Mov current_value_Dword , Ebx			
			jmp Done
		Not_Cx_1:
			cmp source_index , 11
			JNE Not_Dx_1
			Movzx Ebx , Dx
			Mov current_value_Dword , Ebx			
			jmp Done
		Not_Dx_1:
			cmp source_index , 12
			JNE Not_Al_1
			Movzx Ebx , Al
			Mov current_value_Dword , Ebx		
			jmp Done
		Not_Al_1:
			cmp source_index , 14
			JNE Not_Bl_1
			Movzx Ebx , Bl
			Mov current_value_Dword , Ebx				
			jmp Done
		Not_Bl_1:
			cmp source_index , 16
			JNE Not_Cl_1
			Movzx Ebx , Cl
			Mov current_value_Dword , Ebx				
			jmp Done
		Not_Cl_1:
			cmp source_index , 18
			JNE look_for_mem_1
			Movzx Ebx , Dl
			Mov current_value_Dword , Ebx				
			jmp Done
		look_for_mem_1:
			cmp source_index , 20
			JNE source_Not_Found_1
			Movzx Ebx , user_variable
			Mov current_value_Dword , Ebx				
			jmp Done

	source_Not_Found_1:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_1:
		;		--------- Ecx ---------
	cmp destenation_index,2
	JE its_Ecx
	JNE Search_for_another_register_2
	its_Ecx:
		cmp source_index , 8
		JNE Not_Ax_2
		Movzx Ecx , Ax
		Mov current_value_Dword , Ecx		
		jmp Done
		Not_Ax_2:
			cmp source_index , 9
			JNE Not_Bx_2
			Movzx Ecx , Bx
			Mov current_value_Dword , Ecx				
			jmp Done
		Not_Bx_2:
			cmp source_index , 10
			JNE Not_Cx_2
			Movzx Ecx , Cx
			Mov current_value_Dword , Ecx			
			jmp Done
		Not_Cx_2:
			cmp source_index , 11
			JNE Not_Dx_2
			Movzx Ecx , Dx
			Mov current_value_Dword , Ecx			
			jmp Done
		Not_Dx_2:
			cmp source_index , 12
			JNE Not_Al_2
			Movzx Ecx , Al
			Mov current_value_Dword , Ecx		
			jmp Done
		Not_Al_2:
			cmp source_index , 14
			JNE Not_Bl_2
			Movzx Ecx , Bl
			Mov current_value_Dword , Ecx				
			jmp Done
		Not_Bl_2:
			cmp source_index , 16
			JNE Not_Cl_2
			Movzx Ecx , Cl
			Mov current_value_Dword , Ecx				
			jmp Done
		Not_Cl_2:
			cmp source_index , 18
			JNE look_for_mem_2
			Movzx Ecx , Dl
			Mov current_value_Dword , Ecx				
			jmp Done
		look_for_mem_2:
			cmp source_index , 20
			JNE source_Not_Found_2
			Movzx Ecx , user_variable
			Mov current_value_Dword , Ecx				
			jmp Done
	source_Not_Found_2:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_2:
		;		--------- Edx ---------
	cmp destenation_index,3
	JE its_Edx
	JNE Search_for_another_register_3
	its_Edx:
		cmp source_index , 8
		JNE Not_Ax_3
		Movzx Edx , Ax
		Mov current_value_Dword , Edx		
		jmp Done
		Not_Ax_3:
			cmp source_index , 9
			JNE Not_Bx_3
			Movzx Edx , Bx
			Mov current_value_Dword , Edx				
			jmp Done
		Not_Bx_3:
			cmp source_index , 10
			JNE Not_Cx_3
			Movzx Edx , Cx
			Mov current_value_Dword , Edx			
			jmp Done
		Not_Cx_3:
			cmp source_index , 11
			JNE Not_Dx_3
			Movzx Edx , Dx
			Mov current_value_Dword , Edx			
			jmp Done
		Not_Dx_3:
			cmp source_index , 12
			JNE Not_Al_3
			Movzx Edx , Al
			Mov current_value_Dword , Edx		
			jmp Done
		Not_Al_3:
			cmp source_index , 14
			JNE Not_Bl_3
			Movzx Edx , Bl
			Mov current_value_Dword , Edx				
			jmp Done
		Not_Bl_3:
			cmp source_index , 16
			JNE Not_Cl_3
			Movzx Edx , Cl
			Mov current_value_Dword , Edx				
			jmp Done
		Not_Cl_3:
			cmp source_index , 18
			JNE look_for_mem_3
			Movzx Edx , Dl
			Mov current_value_Dword , Edx				
			jmp Done
		look_for_mem_3:
			cmp source_index , 20
			JNE source_Not_Found_3
			Movzx Edx , user_variable
			Mov current_value_Dword , Edx				
			jmp Done
	source_Not_Found_3:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_3:
		;		--------- Ax ---------
	cmp destenation_index,8
	JE its_Ax
	JNE Search_for_another_register_4
	its_Ax:
		cmp source_index , 12
		JNE Not_Al_4
		Movzx Ax , Al
		Mov current_value_word , Ax		
		jmp Done_2
		Not_Al_4:
			cmp source_index , 14
			JNE Not_Bl_4
			Movzx Ax , Bl
			Mov current_value_word , Ax				
			jmp Done_2
		Not_Bl_4:
			cmp source_index , 16
			JNE Not_Cl_4
			Movzx Ax , Cl
			Mov current_value_word , Ax				
			jmp Done_2
		Not_Cl_4:
			cmp source_index , 18
			JNE look_for_mem_4
			Movzx Ax , Dl
			Mov current_value_word , Ax				
			jmp Done_2
		look_for_mem_4:
			cmp source_index , 20
			JNE source_Not_Found_4
			Movzx Ax , user_variable
			Mov current_value_word , Ax				
			jmp Done_2
	source_Not_Found_4:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_4:
		;		--------- Bx ---------
	cmp destenation_index,9
	JE its_Bx
	JNE Search_for_another_register_5
	its_Bx:
		cmp source_index , 12
		JNE Not_Al_5
		Movzx Bx , Al
		Mov current_value_word , Bx		
		jmp Done_2
		Not_Al_5:
			cmp source_index , 14
			JNE Not_Bl_5
			Movzx Bx , Bl
			Mov current_value_word , Bx				
			jmp Done_2
		Not_Bl_5:
			cmp source_index , 16
			JNE Not_Cl_5
			Movzx Bx , Cl
			Mov current_value_word , Bx				
			jmp Done_2
		Not_Cl_5:
			cmp source_index , 18
			JNE look_for_mem_5
			Movzx Bx , Dl
			Mov current_value_word , Bx				
			jmp Done_2
		look_for_mem_5:
			cmp source_index , 20
			JNE source_Not_Found_5
			Movzx Bx , user_variable
			Mov current_value_word , Bx				
			jmp Done_2
	source_Not_Found_5:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_5:
		;		--------- Cx ---------
	cmp destenation_index,10
	JE its_Cx
	JNE Search_for_another_register_6
	its_Cx:
		cmp source_index , 12
		JNE Not_Al_6
		Movzx Cx , Al
		Mov current_value_word , Cx		
		jmp Done_2
		Not_Al_6:
			cmp source_index , 14
			JNE Not_Bl_6
			Movzx Cx , Bl
			Mov current_value_word , Cx				
			jmp Done_2
		Not_Bl_6:
			cmp source_index , 16
			JNE Not_Cl_6
			Movzx Cx , Cl
			Mov current_value_word , Cx				
			jmp Done_2
		Not_Cl_6:
			cmp source_index , 18
			JNE look_for_mem_6
			Movzx Cx , Dl
			Mov current_value_word , Cx				
			jmp Done_2
		look_for_mem_6:
			cmp source_index , 20
			JNE source_Not_Found_6
			Movzx Cx , user_variable
			Mov current_value_word , Cx				
			jmp Done_2
	source_Not_Found_6:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_6:
		;		--------- Dx ---------
	cmp destenation_index,11
	JE its_Dx
	JNE Print_invalid_Detenation_register
	its_Dx:
		cmp source_index , 12
		JNE Not_Al_7
		Movzx Dx , Al
		Mov current_value_word , Dx		
		jmp Done_2
		Not_Al_7:
			cmp source_index , 14
			JNE Not_Bl_7
			Movzx Dx , Bl
			Mov current_value_word , Dx				
			jmp Done_2
		Not_Bl_7:
			cmp source_index , 16
			JNE Not_Cl_7
			Movzx Dx , Cl
			Mov current_value_word , Dx				
			jmp Done_2
		Not_Cl_7:
			cmp source_index , 18
			JNE look_for_mem_7
			Movzx Dx , Dl
			Mov current_value_word , Dx				
			jmp Done_2
		look_for_mem_7:
			cmp source_index , 20
			JNE source_Not_Found_7
			Movzx Dx , user_variable
			Mov current_value_word , Dx				
			jmp Done_2
	source_Not_Found_7:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Print_invalid_Detenation_register:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Destenation_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Done:
		;	-- To out The Dword Registers --
		Call Display_Dword_Register
		jmp enough
	Done_2:
		;	-- To out The word Registers --
		Call Display_word_Register
		jmp enough
	Done_3:
		;	-- To out The Byte Registers --
		Call Display_byte_Register
	enough:
	ret
Movzx_Instruction Endp

;---------------------------------------------------------------------------------------------------------------------------
;		-- Movsx_Instruction Procedure
Movsx_Instruction Proc
	;		--------- Eax ---------
	cmp destenation_index,0
	JE its_Eax
	JNE Search_for_another_register
	its_Eax:
		cmp source_index , 8
		JNE Not_Ax
		Movsx Eax , Ax
		Mov current_value_Dword , Eax		
		jmp Done
		Not_Ax:
			cmp source_index , 9
			JNE Not_Bx
			Movsx Eax , Bx
			Mov current_value_Dword , Eax				
			jmp Done
		Not_Bx:
			cmp source_index , 10
			JNE Not_Cx
			Movsx Eax , Cx
			Mov current_value_Dword , Eax			
			jmp Done
		Not_Cx:
			cmp source_index , 11
			JNE Not_Dx
			Movsx Eax , Dx
			Mov current_value_Dword , Eax			
			jmp Done
		Not_Dx:
			cmp source_index , 12
			JNE Not_Al
			Movsx Eax , Al
			Mov current_value_Dword , Eax		
			jmp Done
		Not_Al:
			cmp source_index , 14
			JNE Not_Bl
			Movsx Eax , Bl
			Mov current_value_Dword , Eax				
			jmp Done
		Not_Bl:
			cmp source_index , 16
			JNE Not_Cl
			Movsx Eax , Cl
			Mov current_value_Dword , Eax				
			jmp Done
		Not_Cl:
			cmp source_index , 18
			JNE look_for_mem
			Movsx Eax , Dl
			Mov current_value_Dword , Eax				
			jmp Done
		look_for_mem:
			cmp source_index , 20
			JNE source_Not_Found
			Movsx Eax , user_variable
			Mov current_value_Dword , Eax				
			jmp Done

	source_Not_Found:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register:
		;		--------- Ebx ---------
	cmp destenation_index,1
	JE its_Ebx
	JNE Search_for_another_register_1
	its_Ebx:
		cmp source_index , 8
		JNE Not_Ax_1
		Movsx Ebx , Ax
		Mov current_value_Dword , Ebx		
		jmp Done
		Not_Ax_1:
			cmp source_index , 9
			JNE Not_Bx_1
			Movsx Ebx , Bx
			Mov current_value_Dword , Ebx				
			jmp Done
		Not_Bx_1:
			cmp source_index , 10
			JNE Not_Cx_1
			Movsx Ebx , Cx
			Mov current_value_Dword , Ebx			
			jmp Done
		Not_Cx_1:
			cmp source_index , 11
			JNE Not_Dx_1
			Movsx Ebx , Dx
			Mov current_value_Dword , Ebx			
			jmp Done
		Not_Dx_1:
			cmp source_index , 12
			JNE Not_Al_1
			Movsx Ebx , Al
			Mov current_value_Dword , Ebx		
			jmp Done
		Not_Al_1:
			cmp source_index , 14
			JNE Not_Bl_1
			Movsx Ebx , Bl
			Mov current_value_Dword , Ebx				
			jmp Done
		Not_Bl_1:
			cmp source_index , 16
			JNE Not_Cl_1
			Movsx Ebx , Cl
			Mov current_value_Dword , Ebx				
			jmp Done
		Not_Cl_1:
			cmp source_index , 18
			JNE look_for_mem_1
			Movsx Ebx , Dl
			Mov current_value_Dword , Ebx				
			jmp Done
		look_for_mem_1:
			cmp source_index , 20
			JNE source_Not_Found_1
			Movsx Ebx , user_variable
			Mov current_value_Dword , Ebx				
			jmp Done

	source_Not_Found_1:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_1:
		;		--------- Ecx ---------
	cmp destenation_index,2
	JE its_Ecx
	JNE Search_for_another_register_2
	its_Ecx:
		cmp source_index , 8
		JNE Not_Ax_2
		Movsx Ecx , Ax
		Mov current_value_Dword , Ecx		
		jmp Done
		Not_Ax_2:
			cmp source_index , 9
			JNE Not_Bx_2
			Movsx Ecx , Bx
			Mov current_value_Dword , Ecx				
			jmp Done
		Not_Bx_2:
			cmp source_index , 10
			JNE Not_Cx_2
			Movsx Ecx , Cx
			Mov current_value_Dword , Ecx			
			jmp Done
		Not_Cx_2:
			cmp source_index , 11
			JNE Not_Dx_2
			Movsx Ecx , Dx
			Mov current_value_Dword , Ecx			
			jmp Done
		Not_Dx_2:
			cmp source_index , 12
			JNE Not_Al_2
			Movsx Ecx , Al
			Mov current_value_Dword , Ecx		
			jmp Done
		Not_Al_2:
			cmp source_index , 14
			JNE Not_Bl_2
			Movsx Ecx , Bl
			Mov current_value_Dword , Ecx				
			jmp Done
		Not_Bl_2:
			cmp source_index , 16
			JNE Not_Cl_2
			Movsx Ecx , Cl
			Mov current_value_Dword , Ecx				
			jmp Done
		Not_Cl_2:
			cmp source_index , 18
			JNE look_for_mem_2
			Movsx Ecx , Dl
			Mov current_value_Dword , Ecx				
			jmp Done
		look_for_mem_2:
			cmp source_index , 20
			JNE source_Not_Found_2
			Movsx Ecx , user_variable
			Mov current_value_Dword , Ecx				
			jmp Done
	source_Not_Found_2:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_2:
		;		--------- Edx ---------
	cmp destenation_index,3
	JE its_Edx
	JNE Search_for_another_register_3
	its_Edx:
		cmp source_index , 8
		JNE Not_Ax_3
		Movsx Edx , Ax
		Mov current_value_Dword , Edx		
		jmp Done
		Not_Ax_3:
			cmp source_index , 9
			JNE Not_Bx_3
			Movsx Edx , Bx
			Mov current_value_Dword , Edx				
			jmp Done
		Not_Bx_3:
			cmp source_index , 10
			JNE Not_Cx_3
			Movsx Edx , Cx
			Mov current_value_Dword , Edx			
			jmp Done
		Not_Cx_3:
			cmp source_index , 11
			JNE Not_Dx_3
			Movsx Edx , Dx
			Mov current_value_Dword , Edx			
			jmp Done
		Not_Dx_3:
			cmp source_index , 12
			JNE Not_Al_3
			Movsx Edx , Al
			Mov current_value_Dword , Edx		
			jmp Done
		Not_Al_3:
			cmp source_index , 14
			JNE Not_Bl_3
			Movsx Edx , Bl
			Mov current_value_Dword , Edx				
			jmp Done
		Not_Bl_3:
			cmp source_index , 16
			JNE Not_Cl_3
			Movsx Edx , Cl
			Mov current_value_Dword , Edx				
			jmp Done
		Not_Cl_3:
			cmp source_index , 18
			JNE look_for_mem_3
			Movsx Edx , Dl
			Mov current_value_Dword , Edx				
			jmp Done
		look_for_mem_3:
			cmp source_index , 20
			JNE source_Not_Found_3
			Movsx Edx , user_variable
			Mov current_value_Dword , Edx				
			jmp Done
	source_Not_Found_3:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_3:
		;		--------- Ax ---------
	cmp destenation_index,8
	JE its_Ax
	JNE Search_for_another_register_4
	its_Ax:
		cmp source_index , 12
		JNE Not_Al_4
		Movsx Ax , Al
		Mov current_value_word , Ax		
		jmp Done_2
		Not_Al_4:
			cmp source_index , 14
			JNE Not_Bl_4
			Movsx Ax , Bl
			Mov current_value_word , Ax				
			jmp Done_2
		Not_Bl_4:
			cmp source_index , 16
			JNE Not_Cl_4
			Movsx Ax , Cl
			Mov current_value_word , Ax				
			jmp Done_2
		Not_Cl_4:
			cmp source_index , 18
			JNE look_for_mem_4
			Movsx Ax , Dl
			Mov current_value_word , Ax				
			jmp Done_2
		look_for_mem_4:
			cmp source_index , 20
			JNE source_Not_Found_4
			Movsx Ax , user_variable
			Mov current_value_word , Ax				
			jmp Done_2
	source_Not_Found_4:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_4:
		;		--------- Bx ---------
	cmp destenation_index,9
	JE its_Bx
	JNE Search_for_another_register_5
	its_Bx:
		cmp source_index , 12
		JNE Not_Al_5
		Movsx Bx , Al
		Mov current_value_word , Bx		
		jmp Done_2
		Not_Al_5:
			cmp source_index , 14
			JNE Not_Bl_5
			Movsx Bx , Bl
			Mov current_value_word , Bx				
			jmp Done_2
		Not_Bl_5:
			cmp source_index , 16
			JNE Not_Cl_5
			Movsx Bx , Cl
			Mov current_value_word , Bx				
			jmp Done_2
		Not_Cl_5:
			cmp source_index , 18
			JNE look_for_mem_5
			Movsx Bx , Dl
			Mov current_value_word , Bx				
			jmp Done_2
		look_for_mem_5:
			cmp source_index , 20
			JNE source_Not_Found_5
			Movsx Bx , user_variable
			Mov current_value_word , Bx				
			jmp Done_2
	source_Not_Found_5:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_5:
		;		--------- Cx ---------
	cmp destenation_index,10
	JE its_Cx
	JNE Search_for_another_register_6
	its_Cx:
		cmp source_index , 12
		JNE Not_Al_6
		Movsx Cx , Al
		Mov current_value_word , Cx		
		jmp Done_2
		Not_Al_6:
			cmp source_index , 14
			JNE Not_Bl_6
			Movsx Cx , Bl
			Mov current_value_word , Cx				
			jmp Done_2
		Not_Bl_6:
			cmp source_index , 16
			JNE Not_Cl_6
			Movsx Cx , Cl
			Mov current_value_word , Cx				
			jmp Done_2
		Not_Cl_6:
			cmp source_index , 18
			JNE look_for_mem_6
			Movsx Cx , Dl
			Mov current_value_word , Cx				
			jmp Done_2
		look_for_mem_6:
			cmp source_index , 20
			JNE source_Not_Found_6
			Movsx Cx , user_variable
			Mov current_value_word , Cx				
			jmp Done_2
	source_Not_Found_6:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Search_for_another_register_6:
		;		--------- Dx ---------
	cmp destenation_index,11
	JE its_Dx
	JNE Print_invalid_Detenation_register
	its_Dx:
		cmp source_index , 12
		JNE Not_Al_7
		Movsx Dx , Al
		Mov current_value_word , Dx		
		jmp Done_2
		Not_Al_7:
			cmp source_index , 14
			JNE Not_Bl_7
			Movsx Dx , Bl
			Mov current_value_word , Dx				
			jmp Done_2
		Not_Bl_7:
			cmp source_index , 16
			JNE Not_Cl_7
			Movsx Dx , Cl
			Mov current_value_word , Dx				
			jmp Done_2
		Not_Cl_7:
			cmp source_index , 18
			JNE look_for_mem_7
			Movsx Dx , Dl
			Mov current_value_word , Dx				
			jmp Done_2
		look_for_mem_7:
			cmp source_index , 20
			JNE source_Not_Found_7
			Movsx Dx , user_variable
			Mov current_value_word , Dx				
			jmp Done_2
	source_Not_Found_7:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Source_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Print_invalid_Detenation_register:
		Mov Edx,offset output
		Call writeString
		mov edx,offset Destenation_Not_Found_Error
		Call WriteString
		Call crlf
		jmp enough

	Done:
		;	-- To out The Dword Registers --
		Call Display_Dword_Register
		jmp enough
	Done_2:
		;	-- To out The word Registers --
		Call Display_word_Register
		jmp enough
	Done_3:
		;	-- To out The Byte Registers --
		Call Display_byte_Register
	enough:
	ret
Movsx_Instruction Endp

;---------------------------------------------------------------------------------------------------------------------------


;----------------------------------------------------------------------------------------------------------------------------------------------------
;	-- Eight_Instructions Procedure --
Eight_Instructions Proc
	; ---- Mov Instruction ---- 
	cmp instruction_index , 0
	JE its_mov_instruction
	JNE search_for_another_instruction
	its_mov_instruction:
		Call Mov_instruction
		jmp tab_ya_syde_shokran_kefaya	
	
	; ---- Add Instruction ----
	search_for_another_instruction:
		cmp instruction_index , 1
		JE its_add_instruction
		JNE search_for_another_instruction_2
		its_add_instruction:
			Call Add_instruction
			jmp tab_ya_syde_shokran_kefaya	

	; ---- Sub Instruction ----
	search_for_another_instruction_2:
		cmp instruction_index , 2
		JE its_Sub_instruction
		JNE search_for_another_instruction_3
		its_Sub_instruction:
			Call Sub_Instruction
			jmp tab_ya_syde_shokran_kefaya	
	
	; ---- Mul Instruction ----
	search_for_another_instruction_3:
		cmp instruction_index , 3
		JE its_Mul_instruction
		JNE search_for_another_instruction_4
		its_Mul_instruction:
			Call Mul_Instruction
			jmp tab_ya_syde_shokran_kefaya	
	
	; ---- Div Instruction ----
	search_for_another_instruction_4:
		cmp instruction_index , 4
		JE its_Div_instruction
		JNE search_for_another_instruction_5
		its_Div_instruction:
			Call Div_Instruction
			jmp tab_ya_syde_shokran_kefaya	
	
	; ---- Neg Instruction ----
	search_for_another_instruction_5:
		cmp instruction_index , 5
		JE its_Neg_instruction
		JNE search_for_another_instruction_6
		its_Neg_instruction:
			Call Neg_Instruction
			jmp tab_ya_syde_shokran_kefaya	

	; ---- Movzx Instruction ----
	search_for_another_instruction_6:
		cmp instruction_index , 6
		JE its_Movzx_instruction
		JNE search_for_another_instruction_7
		its_Movzx_instruction:
			Call Movzx_Instruction
			jmp tab_ya_syde_shokran_kefaya	
	
	; ---- Movsx Instruction ----
	search_for_another_instruction_7:
		cmp instruction_index , 7
		JE its_Movsx_instruction
		JNE No_thing_of_Chosen_instruction
		its_Movsx_instruction:
			Call Movsx_Instruction
			jmp tab_ya_syde_shokran_kefaya	
	
	No_thing_of_Chosen_instruction:
		Mov Edx,offset output
		Call writeString
		mov edx , offset Instruction_Not_Found_Error
		Call writeString
		Call crlf
	tab_ya_syde_shokran_kefaya:
	ret
Eight_Instructions Endp
END main
