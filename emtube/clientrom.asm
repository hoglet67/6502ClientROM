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
L0103   = $0103
L0104   = $0104
USERVLO = $0200
USERVHI = $0201
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
L0300   = $0300
L03F3   = $03F3
L03F5   = $03F5
L03F9   = $03F9
L03FB   = $03FB
L03FE   = $03FE

        org     $F800
.RESET
        CLD
        LDX     #$35
.LF803
        LDA     LFC0E,X
        STA     USERVLO,X
        DEX
        BPL     LF803

        TXS
        LDX     #$00
        STX     L00FF
        STA     L00F0
        LDX     #$08
        STX     L00F1
        LDX     #$00
        LDY     #$F8
        STX     L00F4
        STY     L00F5
.LF81F
        JSR     LFADD

        JSR     LFAFB

        LDY     #$04
        JSR     LFA29

        TYA
        BEQ     LF830

        JMP     LFA22

.LF830
        JSR     LFBD6

        EQUS    $17,$11,$05,$00,$00,$00,$00,$00,$00,$00,"65*",$17,$11,$05,$00,$00,$00,$00,$00,$00,$00

.LF84A
        NOP
        LDA     #$00
        LDX     #$FB
        LDY     #$FB
        JSR     OSWORD

        BCS     LF860

        LDX     #$36
        LDY     #$02
        JSR     OSCLI

        JMP     LF830

.LF860
        LDA     #$7E
        JSR     OSBYTE

        BRK
        EQUB    $11

        EQUS    "Escape"

        EQUB    $00

.IRQ
        STA     L00FC
        PLA
        PHA
        AND     #$10
        BNE     LF87C

        JMP     (IRQ1LO)

.LF879
        JMP     (IRQ2LO)

.LF87C
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
        LDA     #$00
        STA     L03FE
        PLA
        TAX
        LDA     L00FC
        CLI
        JMP     (BRKVLO)

.LF89C
        LDX     #$FF
        TXS
        INX
        STX     L03FE
        CLI
        JSR     OSNEWL

        LDY     #$01
.LF8A9
        LDA     (L00FD),Y
        BEQ     LF8B3

        JSR     OSWRCH

        INY
        BNE     LF8A9

.LF8B3
        JSR     OSNEWL

        JMP     LF830

.LF8B9
        STX     L00F2
        STY     L00F3
        LDY     #$00
        STY     L03F3
.LF8C2
        LDA     (L00F2),Y
        STA     LFC44,Y
        CMP     #$0D
        BEQ     LF8CF

        INY
        BNE     LF8C2

.LF8CE
        RTS

.LF8CF
        LDX     #$44
        LDY     #$FC
        STX     L00F2
        STY     L00F3
        LDX     #$00
        LDY     #$FF
.LF8DB
        INY
        JSR     LF944

        CMP     #$2A
        BEQ     LF8DB

        CMP     #$0D
        BEQ     LF8CE

        CLC
        TYA
        ADC     L00F2
        STA     L00F2
        BCC     LF8F1

        INC     L00F3
.LF8F1
        LDY     #$00
        LDA     (L00F2),Y
        CMP     #$2E
        BEQ     LF93E

.LF8F9
        TYA
        PHA
        JSR     LF944

.LF8FE
        LDA     LF958,X
        BMI     LF919

        EOR     (L00F2),Y
        AND     #$DF
        BNE     LF90D

        INX
        INY
        BRA     LF8FE

.LF90D
        LDA     (L00F2),Y
        INY
        CMP     #$2E
        BEQ     LF922

.LF914
        PLA
        TAY
        SEC
        BRA     LF924

.LF919
        ASL     A
        BMI     LF922

        LDA     (L00F2),Y
        CMP     #$41
        BCS     LF914

.LF922
        PLA
        CLC
.LF924
        DEX
.LF925
        INX
        LDA     LF958,X
        BPL     LF925

        BCC     LF935

        INX
        LDA     LF958,X
        BNE     LF8F9

        BEQ     LF93E

.LF935
        ASL     A
        AND     #$7F
        TAX
        JSR     LF94F

        BCC     LF943

.LF93E
        LDX     L00F2
        LDY     L00F3
.LF943
        RTS

.LF944
        DEY
.LF945
        INY
        LDA     (L00F2),Y
        CMP     #$20
        BEQ     LF945

        CMP     #$0D
        RTS

.LF94F
        LDA     LF975,X
        PHA
        LDA     LF974,X
        PHA
        RTS

.LF958
        EQUS    "GO"

        EQUB    $C0

        EQUS    "QUIT"

        EQUB    $81

        EQUS    "HELP"

        EQUB    $82

        EQUS    "BASIC"

        EQUB    $83

        EQUS    "OS"

        EQUB    $84

        EQUS    "PAGE"

        EQUB    $C5,$00

.LF974
        EQUW    $F9F1,$FAE7,$FAED,$F97F
        EQUW    $F81E,$F9B7

        LF975   = LF974+1
        JMP     NMI

.LF984
        LDX     #$00
        STX     L00F6
        STX     L00F7
        STX     L03F3
.LF98D
        LDA     (L00F2),Y
        SEC
        SBC     #$30
        BCC     LF9B7

        CMP     #$0A
        BCC     LF9A4

        AND     #$DF
        SBC     #$07
        CMP     #$0A
        BCC     LF9B7

        CMP     #$10
        BCS     LF9B7

.LF9A4
        ASL     A
        ASL     A
        ASL     A
        ASL     A
        LDX     #$03
.LF9AA
        ASL     A
        ROL     L00F6
        ROL     L00F7
        BCS     LF9E6

        DEX
        BPL     LF9AA

        INY
        BNE     LF98D

.LF9B7
        RTS

.LF9B8
        JSR     LF944

        JSR     LF984

        JSR     LF944

        BNE     LF9E6

        TXA
        BEQ     LF9D7

        LDY     L00F7
        LDX     L00F6
        BNE     LF9DB

        CPY     #$08
        BCC     LF9DB

        CPY     #$80
        BCS     LF9DB

.LF9D4
        STY     L00F1
        RTS

.LF9D7
        LDY     #$08
        BRA     LF9D4

.LF9DB
        BRK
        EQUB    $00

        EQUS    "Bad PAGE"

        EQUB    $00

.LF9E6
        BRK
        EQUB    $00

        EQUS    "Bad hex"

        EQUB    $00,$38,$60

.LF9F2
        JSR     LF944

        JSR     LF984

        JSR     LF944

        BNE     LF9E6

        TXA
        BEQ     LFA08

        LDA     L00F6
        STA     L00F4
        LDA     L00F7
        STA     L00F5
.LFA08
        LDA     L00EF
        PHA
        LDA     L00EE
        PHA
        JSR     LFA30

        PLA
        STA     L00EE
        STA     L00F4
        PLA
        STA     L00EF
        STA     L00F5
        CLC
        RTS

.NMI
        LDY     #$04
        JSR     LFA29

.LFA22
        STX     L00F4
        STY     L00F5
        JMP     LFA08

.LFA29
        LDA     #$A3
        LDX     #$F3
        JMP     OSBYTE

.LFA30
        LDA     L00F4
        STA     L00EE
        LDA     L00F5
        STA     L00EF
        LDX     #$00
        STX     L03F5
        STX     L03FE
        LDY     #$07
        LDA     (L00F4),Y
        CLD
        CLC
        ADC     L00F4
        STA     L00FD
        LDA     #$00
        ADC     L00F5
        STA     L00FE
        LDY     #$00
        LDA     (L00FD),Y
        BNE     LFA93

        INY
        LDA     (L00FD),Y
        CMP     #$28
        BNE     LFA93

        INY
        LDA     (L00FD),Y
        CMP     #$43
        BNE     LFA93

        INY
        LDA     (L00FD),Y
        CMP     #$29
        BNE     LFA93

        LDY     #$06
        LDA     (L00F4),Y
        AND     #$4D
        CMP     #$40
        BCC     LFAC1

        AND     #$0D
        BEQ     LFA7D

        CMP     #$01
        BNE     LFAA5

.LFA7D
        PHA
        LDY     #$09
.LFA80
        LDA     (L00F4),Y
        BEQ     LFA8A

        JSR     OSWRCH

        INY
        BNE     LFA80

.LFA8A
        JSR     OSNEWL

        JSR     OSNEWL

        PLA
        BRA     LFA95

.LFA93
        LDA     #$00
.LFA95
        STA     L00F0
        LDY     #$00
        TYA
.LFA9A
        STA     L0300,Y
        DEY
        BNE     LFA9A

        LDA     #$01
        JMP     (L00F4)

.LFAA5
        JSR     LFADD

        BRK
        EQUB    $00

        EQUS    "I cannot run this code"

        EQUB    $00

.LFAC1
        JSR     LFADD

        BRK
        EQUB    $00

        EQUS    "This is not a language"

        EQUB    $00

.LFADD
        LDA     #$9C
        STA     BRKVLO
        LDA     #$F8
        STA     BRKVHI
        RTS

.LFAE8
        LDY     #$05
        JSR     LFA29

.LFAEE
        JSR     LF944

        BNE     LFAF9

        JSR     OSNEWL

        JSR     LFAFB

.LFAF9
        SEC
        RTS

.LFAFB
        JSR     LFBD6

        EQUS    "Acorn 6502 Tube 0.44 (14 Oct 1987)",$0A,$0D

.LFB22
        NOP
        RTS

.LFB24
        CMP     #$82
        BEQ     LFB3F

        CMP     #$83
        BEQ     LFB44

        CMP     #$84
        BEQ     LFB54

        CMP     #$EA
        BEQ     LFB6F

        CMP     #$A3
        BNE     LFB3D

        CPX     #$FE
        BCC     LFB3D

        RTS

        RTS

.LFB3F
        LDX     #$00
        LDY     #$00
        RTS

.LFB44
        LDX     L00F0
        BEQ     LFB4F

        LDA     #$01
        LDX     #$00
        LDY     #$00
        RTS

.LFB4F
        LDX     #$00
        LDY     L00F1
        RTS

.LFB54
        LDX     L00F0
        BEQ     LFB5F

        LDA     #$04
        LDX     #$00
        LDY     #$00
        RTS

.LFB5F
        LDX     L00F4
        LDY     L00F5
        RTS

        LDX     #$00
        LDY     #$80
        RTS

        JMP     LF980

        LDX     #$0F
        RTS

.LFB6F
        LDX     #$FF
        RTS

.LFB72
        CMP     #$05
        BNE     LFB94

        STX     L00F8
        STY     L00F9
        LDX     #$00
        STX     L03F9
        LDY     #$01
        LDA     (L00F8),Y
        STA     L00FB
        LDA     (L00F8,X)
        STA     L00FA
        LDA     (L00FA,X)
        LDY     #$04
        STA     (L00F8),Y
        LDX     L00F8
        LDY     L00F9
        RTS

        RTS

        RTS

        RTS

.LFB9A
        CMP     #$01
        BNE     LFBCA

        CPY     #$00
        BNE     LFBCA

        LDY     #$00
        STY     L03F3
        DEY
.LFBA8
        INY
        LDA     (L00F2),Y
        CMP     #$20
        BCC     LFBB4

        BNE     LFBA8

        JSR     LF944

.LFBB4
        CLC
        TYA
        ADC     L00F2
        STA     L0000,X
        LDA     L00F3
        ADC     #$00
        STA     L0001,X
        LDY     #$FF
        STY     L0002,X
        STY     L0003,X
        INY
        LDA     #$01
        RTS

        RTS

        RTS

        RTS

        RTS

        RTS

        RTS

.LFBD6
        PLA
        STA     L00FA
        PLA
        STA     L00FB
        LDY     #$00
        STY     L03FB
        INY
.LFBE2
        LDA     (L00FA),Y
        CMP     #$EA
        BEQ     LFBEE

        JSR     OSASCI

        INY
        BNE     LFBE2

.LFBEE
        TYA
        CLC
        ADC     L00FA
        TAX
        LDA     #$00
        ADC     L00FB
        PHA
        TXA
        PHA
.LFBFA
        RTS

        EQUB    $36,$02,$CA,$20,$FF

.UNSUPPORTED
        BRK
        EQUB    $00

        EQUS    "Unsupported"

        EQUB    $00

.LFC0E
        EQUW    UNSUPPORTED
        EQUW    LF89C
        EQUW    LF879
        EQUW    UNSUPPORTED
        EQUW    LF8B9
        EQUW    LFB24
        EQUW    LFB72
        EQUW    LFB96
        EQUW    LFB98
        EQUW    LFBD4
        EQUW    LFB9A
        EQUW    LFBCE
        EQUW    LFBD0
        EQUW    LFBCC
        EQUW    LFBD2
        EQUW    UNSUPPORTED
        EQUW    LFBFA
        EQUW    UNSUPPORTED
        EQUW    UNSUPPORTED
        EQUW    UNSUPPORTED
        EQUW    UNSUPPORTED
        EQUW    UNSUPPORTED
        EQUW    UNSUPPORTED
        EQUW    UNSUPPORTED
        EQUW    LFBFA
        EQUW    LFBFA
        EQUW    LFBFA

.LFC44
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $74,$75,$74,$75,$70,$02,$00,$00
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF

        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$36,$0E
        EQUB    $FC

.OSRDRM
        JMP     UNSUPPORTED

        JMP     UNSUPPORTED

        JMP     UNSUPPORTED

        JMP     UNSUPPORTED

        JMP     UNSUPPORTED

        JMP     LFB98

        JMP     LFB96

        JMP     (FINDLO)

        JMP     (GBPBLO)

        JMP     (BPUTLO)

        JMP     (BGETLO)

        JMP     (ARGSLO)

        JMP     (FILELO)

        JMP     (RDCHLO)

.OSASCI
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

        EQUW    NMI
        EQUW    RESET
        EQUW    IRQ

.BeebDisEndAddr
SAVE "clientrom.bin",BeebDisStartAddr,BeebDisEndAddr

