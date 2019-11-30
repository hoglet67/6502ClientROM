; Enable 65C02 opcodes
CPU           1

L0000   = $0000
L0001   = $0001
L0002   = $0002
L0003   = $0003
L00EE   = $00EE
L00EF   = $00EF
L00F0   = $00F0
L00F1   = $00F1
L00F2   = $00F2
L00F3   = $00F3
L00F4   = $00F4
L00F5   = $00F5
L00F6   = $00F6
L00F7   = $00F7
L00F8   = $00F8
L00F9   = $00F9
L00FA   = $00FA
L00FB   = $00FB
L00FC   = $00FC
L00FD   = $00FD
L00FE   = $00FE
L00FF   = $00FF
L0100   = $0100
L0103   = $0103
L0104   = $0104
L0200   = $0200
BRKVLO  = $0202
BRKVHI  = $0203
IRQ1LO  = $0204
IRQ1HI  = $0205
IRQ2LO  = $0206
IRQ2HI  = $0207
CLIVLO  = $0208
CLIVHI  = $0209
BYTELO  = $020A
BYTEHI  = $020B
WORDLO  = $020C
WORDHI  = $020D
WRCHLO  = $020E
WRCHHI  = $020F
RDCHLO  = $0210
RDCHHI  = $0211
FILELO  = $0212
FILEHI  = $0213
ARGSLO  = $0214
ARGSHI  = $0215
BGETLO  = $0216
BGETHI  = $0217
BPUTLO  = $0218
BPUTHI  = $0219
GBPBLO  = $021A
GBPBHI  = $021B
FINDLO  = $021C
FINDHI  = $021D
EVNTLO  = $0220
EVNTHI  = $0221
L0236   = $0236
L0237   = $0237

        ORG     $F800

.RESET
        LDX     #$00
.LF802
        LDA     LFF00,X
        STA     LFF00,X
        DEX
        BNE     LF802

        LDX     #$36
.LF80D
        LDA     LFF80,X
        STA     L0200,X
        DEX
        BPL     LF80D

        TXS
        LDX     #$F0
.LF819
        LDA     LFDFF,X
        STA     LFDFF,X
        DEX
        BNE     LF819

        LDY     #$00
        STY     L00F8
        LDA     #$F8
        STA     L00F9
.LF82A
        LDA     (L00F8),Y
        STA     (L00F8),Y
        INY
        BNE     LF82A

        INC     L00F9
        LDA     L00F9
        CMP     #$FE
        BNE     LF82A

        LDX     #$10
.LF83B
        LDA     LF859,X
        STA     L0100,X
        DEX
        BPL     LF83B

        LDA     L00EE
        STA     L00F6
        LDA     L00EF
        STA     L00F7
        LDA     #$00
        STA     L00FF
        STA     L00F2
        LDA     #$F8
        STA     L00F3
        JMP     L0100

.LF859
        LDA     R1STATUS
        CLI
.LF85D
        JMP     LF860

LF85E = LF85D+1
LF85F = LF85D+2
.LF860
        JSR     LFE98

        EQUS    $0A,"Acorn TUBE 6502 64K",$0A,$0A,$0D,$00

.LF87B
        NOP
        LDA     #$8D
        STA     LF85E
        LDA     #$F8
        STA     LF85F
        JSR     LF975

        CMP     #$80
        BEQ     LF8B5

.LF88D
        LDA     #$2A
        JSR     OSWRCH

        LDX     #$5D
        LDY     #$F9
        LDA     #$00
        JSR     OSWORD

        BCS     LF8A7

        LDX     #$36
        LDY     #$02
        JSR     OSCLI

        JMP     LF88D

.LF8A7
        LDA     #$7E
        JSR     OSBYTE

        BRK
        EQUB    $11

        EQUS    "Escape"

        EQUB    $00

.LF8B5
        LDA     L00F6
        STA     L00EE
        STA     L00F2
        LDA     L00F7
        STA     L00EF
        STA     L00F3
        LDY     #$07
        LDA     (L00EE),Y
        CLD
        CLC
        ADC     L00EE
        STA     L00FD
        LDA     #$00
        ADC     L00EF
        STA     L00FE
        LDY     #$00
        LDA     (L00FD),Y
        BNE     LF8FA

        INY
        LDA     (L00FD),Y
        CMP     #$28
        BNE     LF8FA

        INY
        LDA     (L00FD),Y
        CMP     #$43
        BNE     LF8FA

        INY
        LDA     (L00FD),Y
        CMP     #$29
        BNE     LF8FA

        LDY     #$06
        LDA     (L00EE),Y
        AND     #$4F
        CMP     #$40
        BCC     LF8FF

        AND     #$0D
        BNE     LF922

.LF8FA
        LDA     #$01
        JMP     (L00F2)

.LF8FF
        LDA     #$45
        STA     BRKVLO
        LDA     #$F9
        STA     BRKVHI
        BRK
        EQUB    $00

        EQUS    "This is not a language"

        EQUB    $00

.LF922
        LDA     #$45
        STA     BRKVLO
        LDA     #$F9
        STA     BRKVHI
        BRK
        EQUB    $00

        EQUS    "I cannot run this code"

        EQUB    $00

.LF945
        LDX     #$FF
        TXS
        JSR     OSNEWL

        LDY     #$01
.LF94D
        LDA     (L00FD),Y
        BEQ     LF957

        JSR     OSWRCH

        INY
        BNE     LF94D

.LF957
        JSR     OSNEWL

        JMP     LF88D

        EQUB    $36,$02,$CA,$20,$FF

.LF962
        BIT     R1STATUS
        NOP
        BVC     LF962

        STA     R1DATA
        RTS

.LF96C
        LDA     #$00
        JSR     LFC4A

.LF971
        JSR     LF975

        ASL     A
.LF975
        BIT     R2STATUS
        BPL     LF975

        LDA     R2DATA
.LF97D
        RTS

.LF97E
        INY
.LF97F
        LDA     (L00F8),Y
        CMP     #$20
        BEQ     LF97E

        RTS

.LF986
        LDX     #$00
        STX     L00F0
        STX     L00F1
.LF98C
        LDA     (L00F8),Y
        CMP     #$30
        BCC     LF9B1

        CMP     #$3A
        BCC     LF9A0

        AND     #$DF
        SBC     #$07
        BCC     LF9B1

        CMP     #$40
        BCS     LF9B1

.LF9A0
        ASL     A
        ASL     A
        ASL     A
        ASL     A
        LDX     #$03
.LF9A6
        ASL     A
        ROL     L00F0
        ROL     L00F1
        DEX
        BPL     LF9A6

        INY
        BNE     LF98C

.LF9B1
        RTS

.LF9B2
        STX     L00F8
        STY     L00F9
.LF9B6
        LDY     #$00
.LF9B8
        BIT     R2STATUS
        BVC     LF9B8

        LDA     (L00F8),Y
        STA     R2DATA
        INY
        CMP     #$0D
        BNE     LF9B8

        LDY     L00F9
        RTS

.LF9CA
        PHA
        STX     L00F8
        STY     L00F9
        LDY     #$00
.LF9D1
        JSR     LF97F

        INY
        CMP     #$2A
        BEQ     LF9D1

        AND     #$DF
        TAX
        LDA     (L00F8),Y
        CPX     #$47
        BEQ     LFA3E

        CPX     #$48
        BNE     LFA2D

        CMP     #$2E
        BEQ     LFA17

        AND     #$DF
        CMP     #$45
        BNE     LFA2D

        INY
        LDA     (L00F8),Y
        CMP     #$2E
        BEQ     LFA17

        AND     #$DF
        CMP     #$4C
        BNE     LFA2D

        INY
        LDA     (L00F8),Y
        CMP     #$2E
        BEQ     LFA17

        AND     #$DF
        CMP     #$50
        BNE     LFA2D

        INY
        LDA     (L00F8),Y
        AND     #$DF
        CMP     #$41
        BCC     LFA17

        CMP     #$5B
        BCC     LFA2D

.LFA17
        JSR     LFE98

        EQUS    $0A,$0D,"6502 TUBE 1.10",$0A,$0D

        EQUB    $EA

.LFA2D
        LDA     #$02
        JSR     LFC4A

        JSR     LF9B6

.LFA35
        JSR     LF975

        CMP     #$80
        BEQ     LFA5C

        PLA
        RTS

.LFA3E
        AND     #$DF
        CMP     #$4F
        BNE     LFA2D

        JSR     LF97E

        JSR     LF986

        JSR     LF97F

        CMP     #$0D
        BNE     LFA2D

        TXA
        BEQ     LFA5C

        LDA     L00F0
        STA     L00F6
        LDA     L00F1
        STA     L00F7
.LFA5C
        LDA     L00EF
        PHA
        LDA     L00EE
        PHA
        JSR     LF8B5

        PLA
        STA     L00EE
        STA     L00F2
        PLA
        STA     L00EF
        STA     L00F3
        PLA
        RTS

.LFA71
        BEQ     LFA35

.LFA73
        CMP     #$80
        BCS     LFA9C

        PHA
        LDA     #$04
.LFA7A
        BIT     R2STATUS
        BVC     LFA7A

        STA     R2DATA
.LFA82
        BIT     R2STATUS
        BVC     LFA82

        STX     R2DATA
        PLA
.LFA8B
        BIT     R2STATUS
        BVC     LFA8B

        STA     R2DATA
.LFA93
        BIT     R2STATUS
        BPL     LFA93

        LDX     R2DATA
        RTS

.LFA9C
        CMP     #$82
        BEQ     LFAFA

        CMP     #$83
        BEQ     LFAF5

        CMP     #$84
        BEQ     LFAF0

        PHA
        LDA     #$06
.LFAAB
        BIT     R2STATUS
        BVC     LFAAB

        STA     R2DATA
.LFAB3
        BIT     R2STATUS
        BVC     LFAB3

        STX     R2DATA
.LFABB
        BIT     R2STATUS
        BVC     LFABB

        STY     R2DATA
        PLA
.LFAC4
        BIT     R2STATUS
        BVC     LFAC4

        STA     R2DATA
        CMP     #$8E
        BEQ     LFA71

        CMP     #$9D
        BEQ     LFAEF

        PHA
.LFAD5
        BIT     R2STATUS
        BPL     LFAD5

        LDA     R2DATA
        ASL     A
        PLA
.LFADF
        BIT     R2STATUS
        BPL     LFADF

        LDY     R2DATA
.LFAE7
        BIT     R2STATUS
        BPL     LFAE7

        LDX     R2DATA
.LFAEF
        RTS

.LFAF0
        LDX     L00F2
        LDY     L00F3
        RTS

.LFAF5
        LDX     #$00
        LDY     #$08
        RTS

.LFAFA
        LDX     #$00
        LDY     #$00
        RTS

.LFAFF
        STX     L00F8
        STY     L00F9
        TAY
        BEQ     LFB77

        PHA
        LDY     #$08
.LFB09
        BIT     R2STATUS
        BVC     LFB09

        STY     R2DATA
.LFB11
        BIT     R2STATUS
        BVC     LFB11

        STA     R2DATA
        TAX
        BPL     LFB24

        LDY     #$00
        LDA     (L00F8),Y
        TAY
        JMP     LFB2D

.LFB24
        LDY     LFCBC,X
        CPX     #$15
        BCC     LFB2D

        LDY     #$10
.LFB2D
        BIT     R2STATUS
        BVC     LFB2D

        STY     R2DATA
        DEY
        BMI     LFB45

.LFB38
        BIT     R2STATUS
        BVC     LFB38

        LDA     (L00F8),Y
        STA     R2DATA
        DEY
        BPL     LFB38

.LFB45
        TXA
        BPL     LFB50

        LDY     #$01
        LDA     (L00F8),Y
        TAY
        JMP     LFB59

.LFB50
        LDY     LFCD0,X
        CPX     #$15
        BCC     LFB59

        LDY     #$10
.LFB59
        BIT     R2STATUS
        BVC     LFB59

        STY     R2DATA
        DEY
        BMI     LFB71

.LFB64
        BIT     R2STATUS
        BPL     LFB64

        LDA     R2DATA
        STA     (L00F8),Y
        DEY
        BPL     LFB64

.LFB71
        LDY     L00F9
        LDX     L00F8
        PLA
        RTS

.LFB77
        LDA     #$0A
        JSR     LFC4A

        LDY     #$04
.LFB7E
        BIT     R2STATUS
        BVC     LFB7E

        LDA     (L00F8),Y
        STA     R2DATA
        DEY
        CPY     #$01
        BNE     LFB7E

        LDA     #$07
        JSR     LFC4A

        LDA     (L00F8),Y
        PHA
        DEY
.LFB96
        BIT     R2STATUS
        BVC     LFB96

        STY     R2DATA
        LDA     (L00F8),Y
        PHA
        LDX     #$FF
        JSR     LF975

        CMP     #$80
        BCS     LFBC7

        PLA
        STA     L00F8
        PLA
        STA     L00F9
        LDY     #$00
.LFBB2
        BIT     R2STATUS
        BPL     LFBB2

        LDA     R2DATA
        STA     (L00F8),Y
        INY
        CMP     #$0D
        BNE     LFBB2

        LDA     #$00
        DEY
        CLC
        INX
        RTS

.LFBC7
        PLA
        PLA
        LDA     #$00
        RTS

.LFBCC
        PHA
        LDA     #$0C
        JSR     LFC4A

.LFBD2
        BIT     R2STATUS
        BVC     LFBD2

        STY     R2DATA
        LDA     L0003,X
        JSR     LFC4A

        LDA     L0002,X
.LFBE1
        JSR     LFC4A

NMI = LFBE1+2
        LDA     L0001,X
        JSR     LFC4A

        LDA     L0000,X
        JSR     LFC4A

        PLA
        JSR     LFC4A

        JSR     LF975

        PHA
        JSR     LF975

        STA     L0003,X
        JSR     LF975

        STA     L0002,X
        JSR     LF975

        STA     L0001,X
        JSR     LF975

        STA     L0000,X
        PLA
        RTS

.LFC0C
        PHA
        LDA     #$12
        JSR     LFC4A

        PLA
        JSR     LFC4A

        CMP     #$00
        BNE     LFC24

        PHA
        TYA
        JSR     LFC4A

        JSR     LF975

        PLA
        RTS

.LFC24
        JSR     LF9B2

        JMP     LF975

.LFC2A
        LDA     #$0E
        JSR     LFC4A

        TYA
        JSR     LFC4A

        JMP     LF971

.LFC36
        PHA
        LDA     #$10
        JSR     LFC4A

        TYA
        JSR     LFC4A

        PLA
        JSR     LFC4A

        PHA
        JSR     LF975

        PLA
        RTS

.LFC4A
        BIT     R2STATUS
        BVC     LFC4A

        STA     R2DATA
        RTS

.LFC53
        STY     L00FB
        STX     L00FA
        PHA
        LDA     #$14
        JSR     LFC4A

        LDY     #$11
.LFC5F
        LDA     (L00FA),Y
        JSR     LFC4A

        DEY
        CPY     #$01
        BNE     LFC5F

        DEY
        LDA     (L00FA),Y
        TAX
        INY
        LDA     (L00FA),Y
        TAY
        JSR     LF9B2

        PLA
        JSR     LFC4A

        JSR     LF975

        PHA
        LDY     #$11
.LFC7E
        JSR     LF975

        STA     (L00FA),Y
        DEY
        CPY     #$01
        BNE     LFC7E

        LDY     L00FB
        LDX     L00FA
        PLA
        RTS

.LFC8E
        STY     L00FB
        STX     L00FA
        PHA
        LDA     #$16
        JSR     LFC4A

        LDY     #$0C
.LFC9A
        LDA     (L00FA),Y
        JSR     LFC4A

        DEY
        BPL     LFC9A

        PLA
        JSR     LFC4A

        LDY     #$0C
.LFCA8
        JSR     LF975

        STA     (L00FA),Y
        DEY
        BPL     LFCA8

        LDY     L00FB
        LDX     L00FA
        JMP     LF971

.LFCB7
        BRK
        EQUB    $FF

        EQUS    "Bad"

.LFCBC
        EQUB    $00,$00,$05,$00,$05,$02,$05,$08
        EQUB    $0E,$04,$01,$01,$05,$00,$01,$20
        EQUB    $10,$0D,$00,$04

.LFCD0
        EQUB    $80,$05,$00,$05,$00,$05,$00,$00
        EQUB    $00,$05,$09,$05,$00,$08,$18,$00
        EQUB    $01,$0D,$80,$04,$80

.IRQ
        STA     L00FC
        PLA
        PHA
        AND     #$10
        BNE     LFCFD

        JMP     (IRQ1LO)

.LFCF0
        BIT     R4STATUS
        BMI     LFD3F

        BIT     R1STATUS
        BMI     LFD18

        JMP     (IRQ2LO)

.LFCFD
        TXA
        PHA
        TSX
        LDA     L0103,X
        CLD
        SEC
        SBC     #$01
        STA     L00FD
        LDA     L0104,X
        SBC     #$00
        STA     L00FE
        PLA
        TAX
        LDA     L00FC
        CLI
        JMP     (BRKVLO)

.LFD18
        LDA     R1DATA
        BMI     LFD39

        TYA
        PHA
        TXA
        PHA
        JSR     LFE80

        TAY
        JSR     LFE80

        TAX
        JSR     LFE80

        JSR     LFD36

        PLA
        TAX
        PLA
        TAY
        LDA     L00FC
        RTI

.LFD36
        JMP     (EVNTLO)

.LFD39
        ASL     A
        STA     L00FF
        LDA     L00FC
        RTI

.LFD3F
        LDA     R4DATA
        BPL     LFD65

        CLI
.LFD45
        BIT     R2STATUS
        BPL     LFD45

        LDA     R2DATA
        LDA     #$00
        STA     L0236
        TAY
        JSR     LF975

        STA     L0237
.LFD59
        INY
        JSR     LF975

        STA     L0237,Y
        BNE     LFD59

        JMP     L0236

.LFD65
        STA     LFFFA
        TYA
        PHA
        LDY     LFFFA
        LDA     LFE70,Y
        STA     LFFFA
        LDA     LFE78,Y
        STA     LFFFB
        LDA     LFE60,Y
        STA     L00F4
        LDA     LFE68,Y
        STA     L00F5
.LFD83
        BIT     R4STATUS
        BPL     LFD83

        LDA     R4DATA
        CPY     #$05
        BEQ     LFDE7

        TYA
        PHA
        LDY     #$01
.LFD93
        BIT     R4STATUS
        BPL     LFD93

        LDA     R4DATA
.LFD9B
        BIT     R4STATUS
        BPL     LFD9B

        LDA     R4DATA
.LFDA3
        BIT     R4STATUS
        BPL     LFDA3

        LDA     R4DATA
        STA     (L00F4),Y
        DEY
.LFDAE
        BIT     R4STATUS
        BPL     LFDAE

        LDA     R4DATA
        STA     (L00F4),Y
        BIT     R3DATA
        BIT     R3DATA
.LFDBE
        BIT     R4STATUS
        BPL     LFDBE

        LDA     R4DATA
        PLA
        CMP     #$06
        BCC     LFDE7

        BNE     LFDEC

        LDY     #$00
.LFDCF
        LDA     R3STATUS
        AND     #$80
        BPL     LFDCF

        LDA     LFFFF,Y
        STA     R3DATA
        INY
        BNE     LFDCF

.LFDDF
        BIT     R3STATUS
        BPL     LFDDF

        STA     R3DATA
.LFDE7
        PLA
        TAY
        LDA     L00FC
        RTI

.LFDEC
        LDY     #$00
.LFDEE
        LDA     R3STATUS
        AND     #$80
        BPL     LFDEE

        LDA     R3DATA
        STA     LFFFF,Y
        INY
        BNE     LFDEE

.LFDFE
        BEQ     LFDE7

LFDFF = LFDFE+1
        PHA
.LFE01
        LDA     LFFFF
LFE02 = LFE01+1
LFE03 = LFE01+2
        STA     R3DATA
        INC     LFE02
        BNE     LFE0F

        INC     LFE03
.LFE0F
        PLA
        RTI

        PHA
        LDA     R3DATA
.LFE15
        STA     LFFFF
LFE16 = LFE15+1
LFE17 = LFE15+2
        INC     LFE16
        BNE     LFE20

        INC     LFE17
.LFE20
        PLA
        RTI

        PHA
        TYA
        PHA
        LDY     #$00
        LDA     (L00F6),Y
        STA     R3DATA
        INC     L00F6
        BNE     LFE32

        INC     L00F7
.LFE32
        LDA     (L00F6),Y
        STA     R3DATA
        INC     L00F6
        BNE     LFE3D

        INC     L00F7
.LFE3D
        PLA
        TAY
        PLA
        RTI

        PHA
        TYA
        PHA
        LDY     #$00
        LDA     R3DATA
        STA     (L00F6),Y
        INC     L00F6
        BNE     LFE51

        INC     L00F7
.LFE51
        LDA     R3DATA
        STA     (L00F6),Y
        INC     L00F6
        BNE     LFE5C

        INC     L00F7
.LFE5C
        PLA
        TAY
        PLA
        RTI

.LFE60
        EQUB    $02,$16,$F6,$F6,$F6,$F6,$D7,$F9

.LFE68
        EQUB    $FE,$FE,$00,$00,$00,$00,$FD,$FD

.LFE70
        EQUB    $00,$11,$22,$41,$B3,$B3,$B3,$B3

.LFE78
        EQUB    $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE

.LFE80
        BIT     R1STATUS
        BMI     LFE94

        BIT     R4STATUS
        BPL     LFE80

        LDA     L00FC
        PHP
        CLI
        PLP
        STA     L00FC
        JMP     LFE80

.LFE94
        LDA     R1DATA
        RTS

.LFE98
        PLA
        STA     L00FA
        PLA
        STA     L00FB
        LDY     #$00
.LFEA0
        INC     L00FA
        BNE     LFEA6

        INC     L00FB
.LFEA6
        LDA     (L00FA),Y
        BMI     LFEB0

        JSR     OSWRCH

        JMP     LFEA0

.LFEB0
        JMP     (L00FA)

.LFEB3
        STA     R3DATA
        RTI

.LUNUSED1

        FOR     N,LUNUSED1,$FEF7
        EQUB    $FF
        NEXT

.R1STATUS
        EQUB    $FF

.R1DATA
        EQUB    $FF

.R2STATUS
        EQUB    $FF

.R2DATA
        EQUB    $FF

.R3STATUS
        EQUB    $FF

.R3DATA
        EQUB    $FF

.R4STATUS
        EQUB    $FF

.R4DATA
        EQUB    $FF


.LFF00

.LUNUSED2
        FOR     N,LUNUSED2,$FF7F
        EQUB    $FF
        NEXT

.LFF80
        EQUW    LFCB7
        EQUW    LF945
        EQUW    LFCF0
        EQUW    LFCB7
        EQUW    LF9CA
        EQUW    LFA73
        EQUW    LFAFF
        EQUW    LF962
        EQUW    LF96C
        EQUW    LFC53
        EQUW    LFBCC
        EQUW    LFC2A
        EQUW    LFC36
        EQUW    LFC8E
        EQUW    LFC0C
        EQUW    LFCB7
        EQUW    LF97D
        EQUW    LFCB7
        EQUW    LFCB7
        EQUW    LFCB7
        EQUW    LFCB7
        EQUW    LFCB7
        EQUW    LFCB7
        EQUW    LFCB7
        EQUW    LF97D
        EQUW    LF97D
        EQUW    LF97D
        EQUW    $8036

        EQUB    $FF

.OSRDRM
        JMP     LFCB7

        JMP     LFCB7

        JMP     LFCB7

        JMP     LFCB7

        JMP     LFCB7

        JMP     LF96C

        JMP     LF962

        JMP     (FINDLO)

        JMP     (GBPBLO)

        JMP     (BPUTLO)

        JMP     (BGETLO)

        JMP     (ARGSLO)

        JMP     (FILELO)

        JMP     (RDCHLO)

        CMP     #$0D
        BNE     OSWRCH

.OSNEWL
        LDA     #$0A
        JSR     OSWRCH

        LDA     #$0D
.OSWRCH
        JMP     (WRCHLO)

.OSWORD
        JMP     (WORDLO)

.OSBYTE
        JMP     (BYTELO)

.OSCLI
        JMP     (CLIVLO)

.LFFFA
        EQUW    LFEB3

        LFFFB   = LFFFA+1
.LFFFC
        EQUW    RESET

        LFFFD   = LFFFC+1
.LFFFE
        EQUW    IRQ

        LFFFF   = LFFFE+1

SAVE "clientrom.bin",$f800,$10000
