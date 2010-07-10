\ ALU.f
\ Arithmatic Logic Unit

VOCABULARY ALU_UNIT
ALU_UNIT ALSO
ALU_UNIT DEFINITIONS

:CLASS ALU <Super OBJECT
        0 VALUE FLAG
        0 VALUE AFLAG



:M NF!: ( b -- )
        0=
        IF
                FLAG 0xFD AND TO FLAG
        ELSE
                FLAG 0x02 OR TO FLAG
        THEN
;M


:M PVF!: ( b -- )
        0=
        IF
                FLAG 0xFB AND TO FLAG
        ELSE
                FLAG 0x04 OR TO FLAG
        THEN
;M

:M HF!: ( b -- )
        0=
        IF
                FLAG 0xEF AND TO FLAG
        ELSE
                FLAG 0x10 OR TO FLAG
        THEN
;M

:M ZF!: ( b -- )
        0=
        IF
                FLAG 0xBF AND TO FLAG
        ELSE
                FLAG 0x40 OR TO FLAG
        THEN
;M



:M ZF@: ( -- f )
        FLAG 5 RSHIFT 0x01 AND
;M


:M SF!: ( b -- )
        0=
        IF
                FLAG 0x7F AND TO FLAG
        ELSE
                FLAG 0x80 OR TO FLAG
        THEN
;M

:M CF!: ( b -- )
        0=
        IF
                FLAG 0xFE AND TO FLAG
        ELSE
                FLAG 0x01 OR TO FLAG
        THEN
;M

:M CF@: ( b -- )
        FLAG 0x01 AND
;M


:M F@: ( -- F )
        FLAG 255 AND
;M

:M F!: ( N -- )
        255 AND TO FLAG
;M

:M 'F@: ( -- F' )
        AFLAG 255 AND
;M

:M 'F!: ( N -- )
        255 AND TO AFLAG
;M


\ **************************************
\ Reset the FLAGS
:M RESET:        ( -- )
        0x48 DUP F!: self 'F!: self
;M

\ ****************************************
\ Used on a data to set the flag
:M TOUCH:       ( a -- )

;M


\ 8 bit increment affects the flag register
:M INC: ( b -- b + 1 )
        1 +
        0 NF!: self   \ N flag is zeroed
        DUP
        128 = PVF!: self
        DUP 15 AND INVERT 16 AND HF!: self
        DUP 0= ZF!: self
        DUP 128 AND SF!: self
;M

\ 8bit Decrement affects the flag register
:M DEC: ( b -- b - 1 )
        DUP 15 AND INVERT 16 AND HF!: self
        1 NF!: self
        1 -
        DUP 128 = PVF!: self
        DUP 0= ZF!: self
        DUP 128 AND SF!: self
;M


\ 8 bit RLCA 8080 version
:M RLCA:        ( A -- a )
        1 LSHIFT
        DUP 0x100 AND CF!: self
        0 NF!: self
        0 HF!: self
        DUP 0x100 AND 8 RSHIFT OR
;M

\ 8 bit RRCA 8080 Version
:M RRCA:        ( A -- a )
        8 LSHIFT
        1 RSHIFT
        DUP 0x80 AND CF!: self
        0 NF!: self 0 HF!: self
        DUP 0x80 AND 16 LSHIFT OR
        8 RSHIFT
;M

\ ***************************************
\ 8 bit RLA Z80 Version
:M RLA:         ( r -- r )
        1 LSHIFT
        CF@: self OR
        DUP 0x100 AND 8 RSHIFT
        CF!: self
        0 NF!: self 0 HF!: self
;M

\ *******************************************
\ 16 bit add
:M ADD16:       ( AA BB -- CC )
        +
        DUP 0x10000 AND CF!: self
        DUP 0x1000 AND HF!: self
;M

\ *********************************************
\ Turn a byte into a signed 16 bit
:M SIGN16:      ( BB -- +/-DDDD )
        DUP
        0x80 AND
        if
                0x7F AND 0x0000 SWAP -
        ELSE
                0x0000 +
        THEN
;M



;CLASS


