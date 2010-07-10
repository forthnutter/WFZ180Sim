\ ***********************************************************************
\ Z80 Register control
\ ***********************************************************************


VOCABULARY REGISTERS
REGISTERS ALSO
REGISTERS DEFINITIONS


:CLASS CREG <Super OBJECT
        0 VALUE A       \ A
        0 VALUE BC      \ B and C Register
        0 VAlUE DE      \ D and E Register
        0 VALUE HL      \ H and L Register
        0 VALUE A'      \ Alternative A and F Register
        0 VALUE BC'     \ Alternative B and C Register
        0 VALUE DE'     \ Alternative D and E Register
        0 VALUE HL'     \ Alternative H and L Register
        0 VALUE IR      \ I and R Register
        0 VALUE IX      \ IX register
        0 VALUE IY      \ IY Register
        0 VALUE SP      \ SP register
        0 VALUE PC      \ PC register
        0 VALUE IFF1    \ Interrupt Flip Flop 1
        0 VALUE IFF2    \ Interrupt Flip Flop 2
        0 VALUE IM      \ Interrupt Mode


: RESET ( -- )
        0 TO A       \ A and the F register
        0 TO BC      \ B and C Register
        0 TO DE      \ D and E Register
        0 TO HL      \ H and L Register
        0 TO A'     \ Alternative A and F Register
        0 TO BC'     \ Alternative B and C Register
        0 TO DE'     \ Alternative D and E Register
        0 TO HL'     \ Alternative H and L Register
        0 TO IR      \ I and R Register
        0 TO IX      \ IX register
        0 TO IY      \ IY Register
        0 TO SP      \ SP register
        0 TO PC      \ PC register
        0 TO IFF1    \ Interrupt Flip Flop 1
        0 TO IFF2    \ Interrupt Flip Flop 2
        0 TO IM      \ Interrupt Mode
;


:M A@: ( -- A )
        A 255 AND
;M

:M A!: ( N -- )
        255 AND TO A
;M

\ do the alternate A
:M AA@: ( -- A' )
        A' 255 AND
;M

:M AA!:  ( N -- )
        255 AND TO A'
;M

\ ****************************************************
\ Increment BC
:M BC+:         ( -- )
        BC 1 +TO BC
;M

\ Decrement BC
:M BC-:
        BC 1 - TO BC
;M

\ *****************************************************************
\ Read BC REGISTER
:M BC@:   ( -- bc )
        BC 0xFFFF AND
;M

\ ****************************************************************
\ Write BC Register
:M BC!:   ( NN -- )
        0xFFFF AND
        TO BC
;M

\ ***************************************************************
\ Read B Rgister
:M B@:    ( -- B )
        BC 8 RSHIFT
;M

\ ************************************************************
\ Write B Register
:M B!:   ( N -- )
        255 AND         \ MASK of any top bytes
        8 LSHIFT        \ move up
        BC 0x00FF AND   \ Get ridd of the upper byte
        OR              \ z80 ?C N
        TO BC
;M

\ ****************************************************************
\ Read C Register
:M C@: ( -- C )
        BC 0x00FF AND
;M

\ ****************************************************************
\ Write C Register
:M C!: ( N -- )
        255 AND         \ Msk n
        BC 0xFF00 AND   \ mask b
        OR              \ Put it together
        TO BC
;M

\ *****************************************************************
\ Read DE REGISTER
:M DE@:   ( REG -- bc )
        DE @
        0xFFFF AND
;M

\ ****************************************************************
\ Write DE Register
:M DE!:   ( NN REG -- )
        SWAP
        0xFFFF AND
        SWAP
        DE !
;M


\ ****************************************************
\ Increment DE
:M DE+:         ( -- )
        DE 1 +TO DE
;M



\ ***************************************************************
\ Read D Rgister
:M D@:    ( REG -- b )
        DE@: SELF 8 RSHIFT
;M

\ ************************************************************
\ Write D Register
:M D!:    ( N REG -- )
        DUP             \ N z80 z80
        DE@: SELF       \ N z80 DE
        0xFF AND        \ N z80 ?E
        ROT             \ z80 ?E N
        8 LSHIFT        \ z80 ?E N?
        OR              \ z80 NE
        SWAP            \ NE z80
        DE!: SELF
;M

\ ****************************************************************
\ Read E Register
:M E@: ( REG -- C )
        DE@: SELF 0xFF AND
;M

\ ****************************************************************
\ Write E Register
:M E!: ( N REG -- )
        DUP             \ N z80 z80
        DE@: SELF       \ N z80 DE
        0xFF00 AND      \ N z80 D?
        ROT             \ Z80 D? N
        0xFF AND        \ z80 D? N
        OR              \ z80 DN
        SWAP            \ DN z80
        DE!: SELF
;M

\ *****************************************************************
\ Read HL REGISTER
:M HL@:   ( REG -- HL )
        HL @
        0xFFFF AND
;M

\ ****************************************************************
\ Write HL Register
:M HL!:   ( NN REG -- )
        SWAP
        0xFFFF AND
        SWAP
        HL !
;M

\ ***************************************************************
\ Read H Rgister
:M H@:    ( REG -- H )
        HL@: SELF 8 RSHIFT
;M

\ ************************************************************
\ Write H Register
:M H!:    ( N REG -- )
        DUP             \ N z80 z80
        HL@: SELF       \ N z80 HL
        0xFF AND        \ N z80 ?L
        ROT             \ z80 ?L N
        8 LSHIFT        \ z80 ?L N?
        OR              \ z80 NL
        SWAP            \ NL z80
        HL!: SELF
;M           \

\ ****************************************************************
\ Read L Register
:M L@: ( REG -- L )
        HL@: SELF 0xFF AND
;M

\ ****************************************************************
\ Write L Register
:M L!: ( N REG -- )
        DUP             \ N z80 z80
        HL@: SELF       \ N z80 HL
        0xFF00 AND      \ N z80 H?
        ROT             \ Z80 H? N
        0xFF AND        \ z80 H? N
        OR              \ z80 HN
        SWAP            \ HN z80
        HL!: SELF
;M


\ *****************************************************************
\ Read IR REGISTER
: IR@   ( REG -- IR )
        IR @
        0xFFFF AND ;

\ ****************************************************************
\ Write IR Register
: IR!   ( NN REG -- )
        SWAP
        0xFFFF AND
        SWAP
        IR ! ;

\ ***************************************************************
\ Read I Rgister
: I@    ( REG -- I )
        IR@ 8 RSHIFT ;

\ ************************************************************
\ Write I Register
: I!    ( N REG -- )
        DUP             \ N z80 z80
        IR@             \ N z80 IR
        0xFF AND        \ N z80 ?R
        ROT             \ z80 ?R N
        8 LSHIFT        \ z80 ?R N?
        OR              \ z80 NR
        SWAP            \ NR z80
        IR! ;           \

\ ****************************************************************
\ Read R Register
: R@ ( REG -- C )
        IR@ 0xFF AND ;

\ ****************************************************************
\ Write R Register
: R! ( N REG -- )
        DUP             \ N z80 z80
        IR@             \ N z80 IR
        0xFF00 AND      \ N z80 I?
        ROT             \ Z80 I? N
        0xFF AND        \ z80 I? N
        OR              \ z80 IN
        SWAP            \ IN z80
        IR! ;

\ *****************************************************************
\ Read IX REGISTER
: IX@   ( REG -- bc )
        IX @
        0xFFFF AND ;

\ ****************************************************************
\ Write IX Register
: IX!   ( NN REG -- )
        SWAP
        0xFFFF AND
        SWAP
        IX ! ;

\ *****************************************************************
\ Read IY REGISTER
: IY@   ( REG -- bc )
        IY @
        0xFFFF AND ;

\ ****************************************************************
\ Write IY Register
: IY!   ( NN REG -- )
        SWAP
        0xFFFF AND
        SWAP
        IY ! ;

\ *****************************************************************
\ Read SP REGISTER
: SP@   ( REG -- SP )
        SP @
        0xFFFF AND ;

\ ****************************************************************
\ Write SP Register
: SP!   ( NN REG -- )
        SWAP
        0xFFFF AND
        SWAP
        SP ! ;

\ *****************************************************************
\ Read PC REGISTER
:M PC@:   ( -- PC )
        PC 0xFFFF AND ;M

\ ****************************************************************
\ Write PC Register
:M PC!:   ( dddd -- )
        0xFFFF AND
        TO PC
;M

\ ****************************************************************
\ Increment PC
:M PC+:   ( -- )
        1 +TO PC ;M



;CLASS



