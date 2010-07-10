\ ************************************************************
\ Call Back Control
\ ************************************************************

VOCABULARY CONTROL
CONTROL ALSO
CONTROL DEFINITIONS

0       NOSTACK1
        CELL FIELD+ REG         \ Pointer Z80 Register structure
        CELL FIELD+ OP_TSTATE   \ State of Opcode
        CELL FIELD+ TSTATE
        CELL FIELD+ TSTATE_CB_USER_DATA \ DATA to send to call back
        CELL FIELD+ TSTATE_CB           \ CALL BACK Address HERe
        CELL FIELD+ INT_VECTOR_REQ      \ An Interrupt has been requested
        CELL FIELD+ INTREAD_CB          \ Call Back for interrupt
        CELL FIELD+ MREAD_CB            \ Memory Read CAll BAck
        CONSTANT SIZEOFCONTROL


: CREATE_CONTROL ( NAME --- )
        CREATE SIZEOFCONTROL ALLOT ;

\ ***********************************************
\ Init the opcode structure
: INIT_CONTROL { CNT }
        0 CNT TSTATE_CB !
        0 CNT TSTATE_CB_USER_DATA !
        0 CNT TSTATE !
        0 CNT OP_TSTATE !
        0 CNT REG !
;

\ ***************************************************
\ A Sub to Increment the OP Code Structure OP_TSTATE
: OP_TSTATE+ { CNT }
        CNT OP_TSTATE @          \ Get OP_TSTATE
        1 +                     \ Add 1
        CNT OP_TSTATE ! ;

\ *****************************************************
\ A Sub to Increment the OP Code Structure TSTATE
: TSTATE+ { CNT }
        CNT TSTATE @     \ Get the TSTATE
        1 +             \ Add 1
        CNT TSTATE ! ;

: T_WAIT_UNTIL { TS CNT }
        TS CNT OP_TSTATE @       \ Get OP_TSTATE
        ?DO
                CNT OP_TSTATE+   \ increment OP_TSTATE by one
                CNT TSTATE+      \ Increment TSTATE
                CNT TSTATE_CB @  \ Get the Tstate call back
                IF CNT CNT TSTATE_CB @ EXECUTE THEN
        LOOP
;

\ ************************************************************
\ Read One byte PC and then increment pc
: READ_PC+ { CNT }
        CNT INT_VECTOR_REQ @            \ get IVR
        IF
                CNT INTREAD_CB @        \ REG ICB
                IF
                        CNT CNT INTREAD_CB @ EXECUTE
                ELSE 0 THEN
        ELSE
                CNT MREAD_CB @
                IF
                        CNT REG @       \ Get address of Register
                        PC@             \ get contents of PC
                        CNT CNT MREAD_CB EXECUTE
                        CNT REG @ PC+
                ELSE 0 THEN
        THEN
;


