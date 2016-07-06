;Program NCS ROM2 - APATCO Technologies 01/24/2007
;Counts up from 0 to 255 in binary using LED’s connected to 6522 Port ‘A’
;At 2Mhz, should complete 0 to 255 in 33.16 seconds based on a delay loop of 253163 cycles

.ORG $E000 	           ;Assembler directive instructing code to start at memory location $E000 (57344)

Out_B = $8000 		   ;Memory location for ‘Output Port B’ of W65C22 VIA
Out_A = $8001 		   ;Memory location for ‘Output Port A’ of W65C22 VIA
DDR_B=$8002 		   ;Data direction register Port B of W65C22 VIA
DDR_A=$8003 		   ;Data direction register Port A of W65C22 VIA

LDA #$FF		   ;Set data direction to “output” for port “A”
STA DDR_A

LDA #$FF 	           ;Stores 255 in memory address 1024. Ensures writing to memory is working
STA $400

main  	LDA $400	   ;Loads value previously stored in memory location 1024
        INC $400 	   ;Increments value in A register by one. If A contains 255, A will now contain 0
        STA Out_A 	   ;Send value in A register to 6522 port “A” causing LED’s to display value in binary
        JSR delay 	   ;Jump to delay loop so we have time to see the results on the LED’s
        JMP main 	   ;Loop back to main. This causes an infinite loop, so our program will run forever

delay 	LDA #$00	   ;Clears the A register.
        LDX #$C4 	   ;Register X is used for the outer loop, and is set to 196
loopB 	LDY #$FF 	   ;Register Y is used for the inner loop, and is set to 255
loopA	DEY 		   ;Decrements the Y loop counter by 1
    	BNE loopA 	   ;If Y is not equal to 0, branch back to loopA, which decrements Y again
	DEX 		   ;Decrements the X loop counter by 1
	BNE loopB 	   ;If X is not equal to 0, branch back to loopB, which starts LoopA all over again
	RTS		   ;Return from delay subroutine back to main
	.END		   ;Assembler directive indicating the end of the assembly program
