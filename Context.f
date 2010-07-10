\ ***************************************************
\ Context control for Z80
\ ***************************************************


NEEDS MMU.f
NEEDS ALU.f

VOCABULARY CONTEXT_UNIT
CONTEXT_UNIT ALSO
CONTEXT_UNIT DEFINITIONS



:CLASS Z80_CONTEXT <Super OBJECT
        ALU F           \ Keep Flags in here
        0 VALUE A       \ A
        0 VALUE BC      \ B and C Register
        0 VAlUE DE      \ D and E Register
        0 VALUE HL      \ H and L Register
        0 VALUE 'A      \ Alternative A and F Register
        0 VALUE 'BC     \ Alternative B and C Register
        0 VALUE 'DE     \ Alternative D and E Register
        0 VALUE 'HL     \ Alternative H and L Register
        0 VALUE IR      \ I and R Register
        0 VALUE IX      \ IX register
        0 VALUE IY      \ IY Register
        0 VALUE SP      \ SP register
        0 VALUE PC      \ PC register
        0 VALUE IFF1    \ Interrupt Flip Flop 1
        0 VALUE IFF2    \ Interrupt Flip Flop 2
        0 VALUE IEF1    \ Global Interrupt enable 1
        0 VALUE IEF2    \ Global Interrupt enable 2
        0 VALUE IM      \ Interrupt Mode
        0 VALUE IL      \ Interrupt Vector Low Reg
        0 VALUE ITC     \ Interrupt Trap Control
        0 VALUE GP      \ secret general purpose register
        0 VALUE HALTED
        0 VALUE TSTATE  \ t state clock of current last state

        MMU MEMORY



:M RESET:       ( -- )
        RESET: F
        0 TO A
        0 TO BC
        0 TO DE
        0 TO HL
        0 TO 'A
        0 TO 'BC
        0 TO 'DE
        0 TO 'HL
        0 TO IR
        0 TO IX
        0 TO IY
        0 TO SP
        0 TO PC
        0 TO IEF1
        0 TO IEF2
        0 TO IM
        0 TO IL
        0 TO HALTED
        0 TO TSTATE
        RESET: MEMORY
;M

\ **************************************************
\ 16 bit add
:M ADD16:       ( AAAA BBBB -- CCCC )
        ADD16: F ;M

\ ******************************************************
\ Read A Register
:M A@:  ( -- HH )
        A 0xFF AND ;M

\ ********************************************************
\ Write A Register
:M A!:  ( HH -- )
        0xFF AND TO A ;M

\ ********************************************************
\ Read A' register
:M 'A@: ( -- HH )
        'A 0xFF AND ;M

\ ***********************************************************
\ Write A' Register
:M 'A!: ( HH -- )
        0xFF AND TO 'A ;M

\ ****************************************************
\ Read AF
:M AF@: ( -- HHHH )
        F@: F A@: self 8 LSHIFT OR ;M

\ ****************************************************
\ Write AF
:M AF!: ( HHHH -- )
        DUP
        F!: F 8 RSHIFT A!: self ;M

\ ****************************************************
\ Read AF'
:M 'AF@:        ( -- HHHH )
        'F@: F 'A@: self 8 LSHIFT OR ;M

\ ****************************************************
\ Write AF
:M 'AF!: ( HHHH -- )
        DUP
        'F!: F 8 RSHIFT 'A!: self ;M

\ ***************************************************
\ Increment A affects the Flags
:M A+:  ( -- )
        A@: self
        INC: F
        A!: self
;M

\ ********************************************************
\ Decrement A affects the flags
:M A-:  ( -- )
        A@: self
        DEC: F
        A!: self
;M

\ **********************************************************
:M RLCA:        ( -- )
        A@: self
        RLCA: F
        A!: self
;M

\ **********************************************************
:M RRCA:        ( -- )
        A@: self
        RRCA: F
        A!: self
;M

\ ********************************************************
:M RLA:
        A@: self
        RLA: F
        A!: self
;M

\ *****************************************************
\ Set the carry flag
:M SCF:
        1 CF!: F
        0 HF!: F
        0 NF!: F
;M

\ ********************************************************
\ Complement Carry Flag
:M CCF:
        CF@: F
        IF
                0 CF!: F
        ELSE
                1 CF!: F
        THEN
        0 HF!: F
        0 NF!: F
;M

\ *******************************************************
\ Get the status of the carry flag
:M CF@:         ( -- F )
        CF@: F
;M

\ **********************************************************
\ Get the status of Z flag
:M ZF@:          ( -- F )
        ZF@: F
;M

\ ***************************************************
\ Write to B
:M B!:  ( HH -- )
        0xFF AND 8 LSHIFT BC OR TO BC ;M

\ **************************************************
\ Read B
:M B@:  ( -- HH )
        BC 8 RSHIFT 0x00FF AND ;M

\ ***************************************************
\ Increment B affects the Flags
:M B+:  ( -- )
        B@: self
        INC: F
        B!: self ;M

\ ********************************************************
\ Decrement B affects the flags
:M B-:  ( -- )
        B@: self
        DEC: F
        B!: self ;M

\ *****************************************************
\ Write to C
:M C!:  ( HH -- )
        0xFF AND BC OR TO BC ;M

\ *******************************************************
\ Read C
:M C@:  ( -- HH )
        BC 0xFF AND ;M

\ Increment C
:M C+:  ( -- )
        C@: self INC: F C!: self ;M

\ Decrement C
:M C-:  ( -- )
        C@: self DEC: F C!: self ;M

\ ***********************************************************
\ Write BC
:M BC!: ( HHHH -- )
        0xFFFF AND TO BC ;M

\ *******************************************************
\ Read BC
:M BC@: ( -- HHHH )
        BC 0xFFFF AND ;M

\ *********************************************************
\ Increment BC
:M BC+: ( -- )
        BC@: self 1 + BC!: self ;M

\ Decrement BC
:M BC-: ( -- )
        BC@: self 1 - BC!: self ;M




\ ***************************************************
\ Write to D
:M D!:  ( HH -- )
        0xFF AND 8 LSHIFT DE OR TO DE ;M

\ **************************************************
\ Read D
:M D@:  ( -- HH )
        DE 8 RSHIFT 0x00FF AND ;M

\ ***************************************************
\ Increment D affects the Flags
:M D+:  ( -- )
        D@: self
        INC: F
        D!: self ;M

\ ********************************************************
\ Decrement D affects the flags
:M D-:  ( -- )
        D@: self
        DEC: F
        D!: self ;M

\ *****************************************************
\ Write to E
:M E!:  ( HH -- )
        0xFF AND DE OR TO DE ;M

\ *******************************************************
\ Read E
:M E@:  ( -- HH )
        DE 0xFF AND ;M

\ Increment E
:M E+:  ( -- )
        E@: self INC: F E!: self ;M

\ Decrement E
:M E-:  ( -- )
        E@: self DEC: F E!: self ;M




\ ***********************************************************
\ Write HL
:M HL!: ( HHHH -- )
        0xFFFF AND TO HL ;M

\ *******************************************************
\ Read HL
:M HL@: ( -- HHHH )
        HL 0xFFFF AND ;M

\ *********************************************************
\ Increment HL
:M HL+: ( -- )
        HL@: self 1 + HL!: self ;M

\ Decrement HL
:M HL-: ( -- )
        HL@: self 1 - HL!: self ;M

\ ***************************************************
\ Write to H
:M H!:  ( HH -- )
        0xFF AND 8 LSHIFT HL OR TO HL ;M

\ **************************************************
\ Read D
:M H@:  ( -- HH )
        HL 8 RSHIFT 0x00FF AND ;M

\ ***************************************************
\ Increment H affects the Flags
:M H+:  ( -- )
        H@: self
        INC: F
        H!: self ;M

\ ********************************************************
\ Decrement H affects the flags
:M H-:  ( -- )
        H@: self
        DEC: F
        H!: self ;M

\ *****************************************************
\ Write to L
:M L!:  ( HH -- )
        0xFF AND HL OR TO HL ;M

\ *******************************************************
\ Read L
:M L@:  ( -- HH )
        HL 0xFF AND ;M

\ Increment L
:M L+:  ( -- )
        L@: self INC: F L!: self ;M

\ Decrement L
:M L-:  ( -- )
        L@: self DEC: F L!: self ;M

\ ***********************************************************
\ Write HL
:M HL!: ( HHHH -- )
        0xFFFF AND TO HL ;M

\ *******************************************************
\ Read HL
:M HL@: ( -- HHHH )
        HL 0xFFFF AND ;M

\ *********************************************************
\ Increment HL
:M HL+: ( -- )
        HL@: self 1 + HL!: self ;M

\ Decrement HL
:M HL-: ( -- )
        HL@: self 1 - HL!: self ;M



\ ***********************************************************
\ Write SP
:M SP!: ( HHHH -- )
        0xFFFF AND TO SP ;M

\ *******************************************************
\ Read SP
:M SP@: ( -- HHHH )
        SP 0xFFFF AND ;M

\ *********************************************************
\ Increment SP
:M SP+: ( -- )
        SP@: self 1 + SP!: self ;M

\ Decrement SP
:M SP-: ( -- )
        SP@: self 1 - SP!: self ;M


\ *****************************************
\ Write PC
:M PC!: ( HHHH -- )
        0xFFFF AND TO PC ;M

\ ******************************************************
\ Read PC
:M PC@: ( -- HHHH )
        PC 0xFFFF AND ;M

\ ****************************************************************
\ Increment PC
:M PC+:   ( -- )
        1 +TO PC ;M

\ *****************************************************************
\ READ PC the Increment by
:M PC@+:        ( -- HHHH )
        PC@: self PC+: self ;M

\ *****************************************************
\ Read one byte from z80 memory
:M MRD:        ( AAAA -- DD )
        RD: MEMORY ;M

\ **********************************************************
\ Write one byte to memory
:M MWR:        ( DD AAAA -- )
        WR: MEMORY ;M


\ *********************************************************
\ byte into sign 16
:M S16:         ( bb -- dddd )
        SIGN16: F ;M

\ ***************************************************
\ Stuff for gerneral Purpose register
\ Write to G
:M G!:  ( HH -- )
        0xFF AND 8 LSHIFT GP OR TO GP ;M

\ **************************************************
\ Read
:M G@:  ( -- HH )
        GP 8 RSHIFT 0x00FF AND ;M

\ *****************************************************
\ Write to P
:M P!:  ( HH -- )
        0xFF AND GP OR TO GP ;M

\ *******************************************************
\ Read P
:M P@:  ( -- HH )
        GP 0xFF AND ;M

\ ***********************************************************
\ Write GP
:M GP!: ( HHHH -- )
        0xFFFF AND TO GP ;M

\ *******************************************************
\ Read GP
:M GP@: ( -- HHHH )
        GP 0xFFFF AND ;M

\ *********************************************************
\ Increment GP
:M GP+: ( -- )
        GP@: self 1 + GP!: self ;M

\ Decrement GP
:M GP-: ( -- )
        GP@: self 1 - GP!: self ;M


;CLASS
