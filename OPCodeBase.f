\ *********************************************************
\ Base code for z80 Instructions
\ ************************************************************


NEEDS Context.f

VOCABULARY OPCODE_BASE
OPCODE_BASE ALSO
OPCODE_BASE DEFINITIONS

Z80_CONTEXT Z80


\ *NOP*
: OP_00 { cpu -- }
        PC+: cpu ;

\ *LD BC,@*
: OP_01 { cpu -- }
        PC+:  cpu       \ currently looking at opcode
        PC@+: cpu       \ Get PC
        MRD: cpu       \ Read Memory (PC)
        C!: cpu         \ Write to C register
        PC@+: cpu       \ Get PC and increment
        MRD: cpu       \ Read memory (PC)
        B!: cpu         \ Write to B register
;

\ *LD (BC),A*
: OP_02 { cpu -- }
        A@: cpu         \ Get A
        BC@: cpu        \ Get BC
        MWR: cpu       \ Write to (BC)
        PC+: cpu        \ Increment PC
;


\ *INC BC*
: OP_03 { cpu -- }
        BC+: cpu        \ Increment BC
        PC+: cpu        \ Increment PC
;

\ *INC B*
: OP_04 { cpu -- }
        B+: cpu         \ Increment B
        PC+: cpu        \ increment PC
;

\ *DEC B*
: OP_05 { cpu -- }
        B-: cpu         \ Decrement B
        PC+: cpu        \ Inrement PC
;

\ *LD B,nn*
: OP_06 { cpu -- }
        PC+: cpu
        PC@+: cpu
        MRD@: cpu
        B!: cpu
;

\ *RLCA*
: OP_07 { cpu -- }
        RLCA: cpu
        PC+: cpu
;

\ *EX AF,AF'
: OP_08 { cpu -- }
        AF@: cpu 'AF@: cpu
        SWAP
        'AF!: cpu AF!: cpu
        PC+: cpu
;

\ *ADD HL,BC*
: OP_09 { cpu -- }
        HL@: cpu BC@: cpu
        ADD16: cpu
        HL!: cpu
        PC+: cpu
;

\ *LD A,(BC)*
: OP_0A { cpu -- }
        BC@: cpu
        MRD: cpu
        A!: cpu
        PC+: cpu
;

\ *DEC BC*
: OP_0B { cpu -- }
        BC-: cpu
        PC+: cpu
;

\ *INC C*
: OP_0C { cpu -- }
        C+: cpu
        PC+: cpu
;

\ *DEC C*
: OP_0D { cpu -- }
        C-: cpu
        PC+: cpu
;

\ *LD C,nn*
: OP_0E { cpu -- }
        PC+: cpu
        PC@+: cpu
        MRD: cpu
        C!: cpu
;

\ *RRCA*
: OP_0F { cpu -- }
        PC+: cpu
        RRCA: cpu
;


\ *DJNZ dd*
: OP_10         { cpu -- }
        ZF@: cpu
        IF
                PC+: cpu
        ELSE
                PC@: cpu MRD: cpu
                S16: cpu
                PC@: cpu +
                PC!: cpu
        THEN
;

\ *LD DE,nnnn*
: OP_11         { cpu -- }
        PC@: cpu MRD: cpu
        E!: cpu
        PC+: cpu
        PC@: cpu MRD: cpu
        D!: cpu
        PC+: cpu
;

\ *LD (DE),A
: OP_12         { cpu -- }
        A@: cpu
        DE@: cpu
        MWR: cpu
        PC+: cpu
;


\ *INC DE*
: OP_13         { cpu -- }
        DE+: cpu
        PC+: cpu
;


\ *INC D*
: OP_14         { cpu -- }
        D+: cpu
        PC+: cpu
;


\ *DEC D*
: OP_15         { cpu -- }
        D-: cpu
        PC+: cpu
;

\ *LD D,nn*
: OP_16         { cpu -- }
        PC@: cpu
        MRD: cpu
        D!: cpu
        PC+: cpu
;

\ *RLA*
: OP_17         { cpu -- }
        RLA: cpu
        PC+: cpu
;

\ *JR dd*
: OP_18         { cpu -- }
        PC@: cpu
        MRD: cpu
        S16: cpu
        PC@: cpu +
        PC!: cpu
;

\ *ADD HL,DE*
: OP_19         { cpu -- }
        HL@: cpu
        DE@: cpu
        ADD16: cpu
        HL!: cpu
        PC+: cpu
;


\ *LD A,(DE)*
: OP_1A         { cpu -- }
        DE@: cpu
        MRD: cpu
        A!: cpu
        PC+: cpu
;

\ *DEC DE*
: OP_1B         { cpu -- }
        DE-: cpu
        PC+: cpu
;

\ *INC E*
: OP_1C         { cpu -- }
        E+: cpu
        PC+: cpu
;

\ *DEC E*
: OP_1D         { cpu -- }
        E-: cpu
        PC++: cpu
;

\ *LD E,NN*
: OP_1E         { cpu -- }
        PC@: cpu
        MRD: cpu
        E!: cpu
        PC+: cpu
;


\ *RRA*
: OP_1F         { cpu -- }
        RRA: cpu
        PC+: cpu
;


\ *JR NZ,DD*
: OP_20         { cpu -- }
        ZF@: cpu
        IF
                PC+: cpu
        ELSE
                PC@: cpu MRD: cpu
                S16: cpu
                PC@: cpu +
                PC!: cpu
        THEN
;


\ *LD HL,NNNN*
: OP_21           { cpu -- }
        PC@: cpu MRD: cpu
        L!: cpu
        PC+: cpu
        PC@: cpu MRD: cpu
        H!: cpu
        PC+: cpu
;



\ *LD (nnnn),HL
: OP_22         { cpu -- }
        PC@: cpu P!: cpu         \ save in general purpose
        PC+: cpu PC@: cpu G!: cpu
        HL@: cpu GP@: cpu MWR: cpu
        PC+: cpu
;


\ *INC HL*
: OP_23         { cpu -- }
        HL+: cpu
        PC+: cpu
;

\ *INC H*
: OP_24         { cpu -- }
        H+: cpu
        PC+: cpu
;

\ * DEC H*
: OP_25         { cpu -- }
        H-: cpu
        PC+: cpu
;

\ *LD H,NN*
: OP_26         { cpu -- }
        PC@: cpu
        MRD: cpu
        H!: cpu
        PC+: cpu
;

\ *DAA*
: OP_27         { cpu -- }
        DAA: cpu
        PC+: cpu
;

\ *JR Z,DD*
: OP_28         { cpu -- }
        ZF@: cpu
        IF
                PC+: cpu
        ELSE
                PC@: cpu MRD: cpu
                S16: cpu
                PC@: cpu +
                PC!: cpu
        THEN
;


\ *ADD HL,HL*
: OP_29         { cpu -- }
        HL@: cpu
        HL@: cpu
        ADD16: cpu
        HL!: cpu
        PC+: cpu
;


\ *LD HL,(NNNN)*
: OP_2A         { cpu -- }
        PC@: cpu P!: cpu
        PC+: cpu
        PC@: cpu G!: cpu
        GP@: cpu
        L!: cpu GP+: cpu
        H!: cpu
        PC+: cpu
;


\ *DEC HL*
: OP_2B         { cpu -- }
        HL-: cpu
        PC+: cpu
;


\ *INC L*
: OP_2C         { cpu -- }
        L+: cpu
        PC+: cpu
;


\ *DEC L*
: OP_2D         { cpu -- }
        L-: cpu
        PC+: cpu
;

\ *LD L,NN*
: OP_2E         { cpu -- }
        PC@: cpu
        MRD: cpu
        L!: cpu
        PC+: cpu
;


\ *CPL*
: OP_2F         { cpu -- }
        CPL: cpu
        PC+: cpu
;

\ *JR NC,DD*
: OP_30         { cpu -- }
        CF@: cpu
        IF
                PC+: cpu
        ELSE
                PC@: cpu MRD: cpu
                S16: cpu
                PC@: cpu +
                PC!: cpu
        THEN
;


\ *LD SP,NNNN*
: OP_31         { cpu -- }
        PC@: cpu MRD: cpu
        P!: cpu PC+: cpu
        PC@: cpu MRD: cpu
        G!: cpu GP@: cpu
        SP!: cpu
        PC+: cpu
;


\ *LD (NNNN),A*
: OP_32         { cpu -- }
        PC@: cpu MRD: cpu P!: cpu PC+: cpu
        PC@: cpu MRD: cpu G!: cpu
        A@: cpu GP@: cpu MEM!: cpu
        PC+: cpu
;

\ *INC SP*
: OP_33         { cpu -- }
        SP+: cpu
        PC+: cpu
;


\ *INC (HL)*
: OP_34         { cpu -- }
        HL@: cpu
        MRD: cpu
        INC: cpu
        HL@: cpu
        MWR: cpu
        PC+: cpu
;

\ *DEC (HL)*
: OP_35         { cpu -- }
        HL@: cpu
        MRD: cpu
        DEC: cpu
        HL@: cpu
        MWR: cpu
        PC+: cpu
;

\ *LD (HL),nn*
: OP_36         { cpu -- }
        PC@: cpu
        MRD: cpu
        HL@: cpu
        MWR: cpu
        PC+: cpu
;


\ *SCF*
: OP_37         { cpu -- }
        SCF: cpu
        PC+: cpu
;

\ *JR C,dd*
: OP_38         { cpu -- }
        CF@: cpu
        IF
                PC@: cpu MRD: cpu
                S16: cpu
                PC@: cpu +
                PC!: cpu
        ELSE
                PC+: cpu
        THEN
;

\ *ADD HL,SP
: OP_39         { cpu -- }
        HL@: cpu
        SP@: cpu
        ADD16: cpu
        HL!: cpu
        PC+: cpu
;

\ *LD A,(nnnn)*
: OP_3A         { cpu -- }
        PC@: cpu MRD: cpu P!: cpu
        PC+: cpu
        PC@: cpu MRD: cpu G!: cpu
        GP@: cpu MRD: cpu
        A!: cpu
        PC+: cpu
;

\ *DEC SP*
: OP_3B         { cpu -- }
        SP-: cpu
        PC+: cpu
;

\ *INC A*
: OP_3C         { cpu -- }
        A+: cpu
        PC+: cpu
;

\ *DEC A*
: OP_3D         { cpu -- }
        A-: cpu
        PC+: cpu
;

\ *LD A,nn*
: OP_3E         { cpu -- }
        PC@: cpu MRD: cpu
        A!: cpu
        PC+: cpu
;

\ *CCF*
: OP_3F         { cpu -- }
        CCF: cpu
        PB+: cpu
;

\ *LD B,B*
: OP_40         { cpu -- }
        B@: cpu
        B!: cpu
;

\ *LD B,C*
: OP_41         { cpu -- }
        C@: cpu
        B!: cpu
;

\ *LD B,D*
: OP_42         { cpu -- }
        D@: cpu
        B!: cpu
;

\ *LD B,E*
: OP_43         { cpu -- }
        E@: cpu
        B!: cpu
;

\ *LD B,H*
: OP_44         { cpu -- }
        H@: cpu
        B!: cpu
;

\ *LD B,L*
: OP_45         { cpu -- }
        L@: cpu
        B!: cpu
;

\ *LD B,(HL)
: OP_46         { cpu -- }
        HL@: cpu
        MRD: cpu
        B!: cpu
;

\ *LD B,A*
: OP_47         { cpu -- }
        A@: cpu
        B!: cpu
;

\ *LD C,B*
: OP_48         { cpu -- }
        B@: cpu
        C!: cpu
;

\ *LD C,C*
: OP_49         { cpu -- }
        C@: cpu
        C!: cpu
;

\ *LD C,D*
: OP_4A         { cpu -- }
        D@: cpu
        C!: cpu
;

\ *LD C,E*
: OP_4B         { cpu -- }
        E@: cpu
        C!: cpu
;

\ *LD C,H*
: OP_4C         { cpu -- }
        H@: cpu
        C!: cpu
;

\ *LD C,L*
: OP_4D         { cpu -- }
        L@: cpu
        C!: cpu
;

\ *LD C,(HL)
: OP_4E         { cpu -- }
        HL@: cpu
        MRD: cpu
        C!: cpu
;

\ *LD C,A*
: OP_4F         { cpu -- }
        A@: cpu
        C!: cpu
;

\ *LD D,B*
: OP_50         { cpu -- }
        B@: cpu
        D!: cpu
;

\ *LD D,C*
: OP_51         { cpu -- }
        C@: cpu
        D!: cpu
;

\ *LD D,D*
: OP_52         { cpu -- }
        D@: cpu
        D!: cpu
;

\ *LD D,E*
: OP_53         { cpu -- }
        E@: cpu
        D!: cpu
;


\ *LD D,H*
: OP_54         { cpu -- }
        H@: cpu
        D!: cpu
;

\ *LD D,L*
: OP_55         { cpu -- }
        L@: cpu
        D!: cpu
;

\ *LD D,(HL)
: OP_56         { cpu -- }
        HL@: cpu
        MRD: cpu
        D!: cpu
;


\ *LD D,A*
: OP_57         { cpu -- }
        A@: cpu
        D!: cpu
;

\ *LD E,B*
: OP_58         { cpu -- }
        B@: cpu
        E!: cpu
;


\ *LD E,C*
: OP_59         { cpu -- }
        C@: cpu
        E!: cpu
;

\ *LD E,D*
: OP_5A         { cpu -- }
        D@: cpu
        E!: cpu
;


\ *LD E,E*
: OP_5B         { cpu -- }
        E@: cpu
        E!: cpu
;

\ *LD E,H*
: OP_5C         { cpu -- }
        H@: cpu
        E!: cpu
;


\ *LD E,L*
: OP_5D         { cpu -- }
        L@: cpu
        E!: cpu
;

\ *LD E,(HL)*
: OP_5E         { cpu -- }
        HL@: cpu
        MRD: cpu
        E!: cpu
;

\ *LD E,A*
: OP_5F         { cpu -- }
        A@: cpu
        E!: cpu
;

\ *LD H,B*
: OP_60         { cpu -- }
        B@: cpu
        H!: cpu
;

\ *LD H,C*
: OP_61         { cpu -- }
        C@: cpu
        H!: cpu
;

\ LD H,D
: OP_62         { cpu -- }
        D@: cpu
        H!: cpu
;

\ LD H,E
: OP_63         { cpu -- }
        E@: cpu
        H!: cpu
;

\ LD H,H
: OP_64         { cpu -- }
        H@: cpu
        H!: cpu
;

\ LD H,L
: OP_65         { cpu -- }
        L@: cpu
        H!: cpu
;

\ LD H,(HL)
: OP_66         { cpu -- }
        HL@: cpu
        MRD: cpu
        H!: cpu
;

\ LD H,A
: OP_67         { cpu -- }
        A@: cpu
        H!: cpu
;

\ LD L,B
: OP_68         { cpu -- }
        B@: cpu
        L!: cpu
;

\ LD L,C
: OP_69         { cpu -- }
        C@: cpu
        L!: cpu
;

\ LD L,D
: OP_6A         { cpu -- }
        D@: cpu
        L!: cpu
;

\ LD L,E
: OP_6B         { cpu -- }
        E@: cpu
        L!: cpu
;

\ LD L,H
: OP_6C         { cpu -- }
        H@: cpu
        L!: cpu
;

\ LD L,L
: OP_6D         { cpu -- }
        L@: cpu
        L!: cpu
;

\ LD L,(HL)
: OP_6E         { cpu -- }
        HL@: cpu
        MRD: cpu
        L!: cpu
;

\ LD L,A
: OP_6F         { cpu -- }
        A@: cpu
        L!: cpu
;

\ LD (HL),B
: OP_70         { cpu -- }
        B@: cpu
        HL@: cpu
        MWR: cpu
;

\ LD (HL),C
: OP_71         { cpu -- }
        C@: cpu
        HL@: cpu
        MWR: cpu
;

\ LD (HL),D
: OP_72         { cpu -- }
        D@: cpu
        HL@: cpu
        MWR: cpu
;

\ LD (HL),E
: OP_73         { cpu -- }
        E@: cpu
        HL@: cpu
        MWR: cpu
;

\ LD (HL),H
: OP_74         { cpu -- }
        H@: cpu
        HL@: cpu
        MWR: cpu
;

\ LD (HL),L
: OP_75         { cpu -- }
        L@: cpu
        HL@: cpu
        MWR: cpu
;

\ HALT
: OP_76         { cpu -- }

;

\ LD (HL),A
: OP_77         { cpu -- }
        A@: cpu
        HL@: cpu
        MWR: cpu
;


\ LD A,B
: OP_78         { cpu -- }
        B@: cpu
        A!: cpu
;

\ LD A,C
: OP_79         { cpu -- }
        C@: cpu
        A!: cpu
;

\ LD A,D
: OP_7A         { cpu -- }
        D@: cpu
        A!: cpu
;

\ LD A,E
: OP_7B         { cpu -- }
        E@: cpu
        A!: cpu
;

\ LD A,H
: OP_7C         { cpu -- }
        H@: cpu
        A!: cpu
;

\ LD A,L
: OP_7D         { cpu -- }
        L@: cpu
        A!: cpu
;

\ LD A,(HL)
: OP_7E         { cpu -- }
        HL@: cpu
        MRD: cpu
        A!: cpu
;

\ LD A,A
: OP_7F         { cpu -- }
        A@: cpu
        A!: cpu
;

\ ADD A,B
: OP_80         { cpu -- }
;

\ ADD A,C
: OP_81         { cpu -- }
;

\ ADD A,D
: OP_82         { cpu -- }
;

\ ADD A,E
: OP_83         { cpu -- }
;

\ ADD A,H
: OP_84         { cpu -- }
;

\ ADD A,L
: OP_85         { cpu -- }
;

\ ADD A,(HL)
: OP_86         { cpu -- }
;

\ ADD A,A
: OP_87         { cpu -- }
;

\ ADC A,B
: OP_88         { cpu -- }
;

\ ADC A,C
: OP_89         { cpu -- }
;

\ ADC A,D
: OP_8A         { cpu -- }
;

\ ADC A,E
: OP_8B         { cpu -- }
;

\ ADC A,H
: OP_8C         { cpu -- }
;

\ ADC A,L
: OP_8D         { cpu -- }
;

\ ADC A,(HL)
: OP_8E         { cpu -- }
;

\ ADC A,A
: OP_8F         { cpu -- }
;

\ SUB B
: OP_90         { cpu -- }
;

\ SUB C
: OP_91         { cpu -- }
;

\ SUB D
: OP_92         { cpu -- }
;

\ SUB E
: OP_93         { cpu -- }
;

\ SUB H
: OP_94         { cpu -- }
;

\ SUB L
: OP_95         { cpu -- }
;

\ SUB (HL)
: OP_96         { cpu -- }
;

\ SUB A
: OP_97         { cpu -- }
;

\ SBC A,B
: OP_98         { cpu -- }
;

\ SBC A,C
: OP_99         { cpu -- }
;

\ SBC A,D
: OP_9A         { cpu -- }
;

\ SBC A,E
: OP_9B         { cpu -- }
;

\ SBC A,H
: OP_9C         { cpu -- }
;

\ SBC A,L
: OP_9D         { cpu -- }
;

\ SBC A,(HL)
: OP_9E         { cpu -- }
;

\ SBC A,A
: OP_9F         { cpu -- }
;

\ AND B
: OP_A0         { cpu -- }
;

\ AND C
: OP_A1         { cpu -- }
;

\ AND D
: OP_A2         { cpu -- }
;

\ AND E
: OP_A3         { cpu -- }
;

\ AND H
: OP_A4         { cpu -- }
;

\ AND L
: OP_A5         { cpu -- }
;

\ AND (HL)
: OP_A6         { cpu -- }
;

\ AND A
: OP_A7         { cpu -- }
;

\ XOR B
: OP_A8         { cpu -- }
;

\ XOR C
: OP_A9         { CPU -- }
;

\ XOR D
: OP_AA         { cpu -- }
;

\ XOR E
: OP_AB         { cpu -- }
;

\ XOR H
: OP_AC         { cpu -- }
;

\ XOR L
: OP_AD         { cpu -- }
;

\ XOR (HL)
: OP_AE         { cpu -- }
;

\ XOR A
: OP_AF         { cpu -- }
;

\ OR B
: OP_B0         { cpu -- }
;

\ OR C
: OP_B1         { cpu -- }
;

\ OR D
: OP_B2         { cpu -- }
;

\ OR E
: OP_B3         { cpu -- }
;

\ OR H
: OP_B4         { cpu -- }
;

\ OR L
: OP_B5         { cpu -- }
;

\ OR (HL)
: OP_B6         { cpu -- }
;

\ OR A
: OP_B7         { cpu -- }
;

\ CP B
: OP_B8         { cpu -- }
;

\ CP C
: OP_B9         { cpu -- }
;

\ CP D
: OP_BA         { cpu -- }
;

\ CP E
: OP_BB         { cpu -- }
;

\ CP H
: OP_BC         { cpu -- }
;

\ CP L
: OP_BD         { cpu -- }
;

\ CP (HL)
: OP_BE         { cpu -- }
;

\ CP A
: OP_BF         { cpu -- }
;

\ RET NZ
: OP_C0         { cpu -- }
;

\ POP BC
: OP_C1         { cpu -- }
;

\ JP NZ,NNNN
: OP_C2         { cpu -- }
;

\ JP NNNN
: OP_C3         { cpu -- }
;

\ CALL NZ,NNNN
: OP_C4         { cpu -- }
;

\ PUSH BC
: OP_C5         { cpu -- }
;

\ ADD A,NN
: OP_C6         { cpu -- }
;

\ RST 0
: OP_C7         { cpu -- }
;

\ RET Z
: OP_C8         { cpu -- }
;

\ RET
: OP_C9         { cpu -- }
;

\ JP Z,NNNN
: OP_CA         { cpu -- }
;

\ RLC B
: OP_CB         { cpu -- }
;

\ CALL Z,NNNN
: OP_CC         { cpu -- }
;

\ CALL NNNN
: OP_CD         { cpu -- }
;

\ ADC A,NN
: OP_CE         { cpu -- }
;

\ RST 8
: OP_CF         { cpu -- }
;

\ RET NC
: OP_D0         { cpu -- }
;

\ POP DE
: OP_D1         { cpu -- }
;

\ JP NC,NNNN
: OP_D2         { cpu -- }
;

\ OUT (NN),A
: OP_D3         { cpu -- }
;

\ CALL NC,NNNN
: OP_D4         { cpu -- }
;

\ PUSH DE
: OP_D5         { cpu -- }
;

\ SUB NN
: OP_D6         { cpu -- }
;

\ RST 10H
: OP_D7         { cpu -- }
;

\ RET C
: OP_D8         { cpu -- }
;

\ EXX
: OP_D9         { cpu -- }
;

\ JP C,NNNN
: OP_DA         { cpu -- }
;

\ IN A,(NN)
: OP_DB         { cpu -- }
;

\ CALL C,NNNN
: OP_DC         { cpu -- }
;

\ ADD IX,BC
: OP_DD         { cpu -- }
;
