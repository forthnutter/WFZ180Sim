\ ****************************************
\ Z180 Memory Management
\ ****************************************

VOCABULARY MEMORY_UNIT
MEMORY_UNIT ALSO
MEMORY_UNIT DEFINITIONS

1000000 CONSTANT MEMSIZE

:CLASS MMU <Super OBJECT
        BYTE CBAR
        BYTE BBR
        BYTE CBR
        0 VALUE ERROR
        0 VALUE PHYSICAL

:M ClassInit:   ( -- )
        255 TO CBAR
        0 TO BBR
        0 TO CBR
        MEMSIZE ALLOCATE
        0= IF TO PHYSICAL THEN
;M

:M ~:
        PHYSICAL
        0<> IF PHYSICAL FREE THEN
;M

:M PHYREAD:      ( PAAAA -- DD )
        DUP
        MEMSIZE <
        IF PHYSICAL + C@
        ELSE 1 TO ERROR DROP
        THEN
;M

:M PHYWRITE:    ( DD PAAAA -- )
        DUP
        MEMSIZE <
        IF PHYSICAL + C!
        ELSE 2 to ERROR DROP DROP
        THEN
;M


:M LCBAR:     ( -- L )
        CBAR 0x0F AND ;M

:M HCBAR:       ( -- H )
        CBAR 0xF0 AND 4 RSHIFT ;M


:M RD:         ( AAAA -- DD )
        DUP
        12 RSHIFT
        DUP
        LCBAR: Self >=
        IF HCBAR: Self >=
                IF CBR 12 LSHIFT +
                ELSE BBR 12 LSHIFT + THEN
        ELSE DROP 0 12 LSHIFT + THEN
        PHYREAD: Self
;M

:M WR:       ( DD AAAA -- )
        DUP
        12 RSHIFT
        DUP
        LCBAR: Self >=
        IF HCBAR: Self >=
                IF CBR 12 LSHIFT +
                ELSE BBR 12 LSHIFT + THEN
        else DROP 0 12 LSHIFT + THEN
        PHYWRITE: Self
;M

: +NO-WRAP     ( PAAAA -- PZZZZ )
        0 TUCK D+ -1 0 DMIN DROP \ 0x100000 MOD
;


\ *************************************
\ Dump the Physical memory
:M DUMP_PHY: ( a n -- )
        OVER +NO-WRAP DUP ROT
        ?DO
                CR I 8 H.R ."  | "
                I 16 +NO-WRAP OVER UMIN I
                2DUP
                DO
                        I PHYREAD: SELF H.2 SPACE I J 7 + =
                        IF SPACE THEN
                LOOP
                2DUP - 16 OVER - 3 * SWAP
                8 < - SPACES ." |"
                DO
                        I PHYREAD: SELF EMIT.
                LOOP
                ." |" 18 MS 16
        +LOOP
        DROP
;M

:M RESET:

;M

;CLASS


