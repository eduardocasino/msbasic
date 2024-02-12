.segment "CODE"

SAVE:
.ifdef KIM_IEC
        beq     TPSAVE
        cmp     #$22                    ; '"'
        bne     LERROR
        jsr     STRTXT
        jsr     SEINIT
        lda     TXTTAB
        ldy     TXTTAB+1
        sta     DSAL
        sty     DSAH
        lda     VARTAB
        ldy     VARTAB+1
        sta     DEAL
        sty     DEAH

        jsr     FREFAC

        jmp     FWRITE
LERROR:
        jmp     SYNERR
TPSAVE:
.endif
        tsx
        stx     INPUTFLG
        lda     #$37
        sta     $F2
        lda     #$FE
        sta     $17F9
        lda     TXTTAB
        ldy     TXTTAB+1
        sta     $17F5
        sty     $17F6
        lda     VARTAB
        ldy     VARTAB+1
        sta     $17F7
        sty     $17F8
        jmp     L1800
        ldx     INPUTFLG
        txs
        lda     #<QT_SAVED
        ldy     #>QT_SAVED
        jmp     STROUT
QT_LOADED:
        .byte   "LOADED"
        .byte   $00
QT_SAVED:
        .byte   "SAVED"
        .byte   $0D,$0A,$00           ; patch v1.2 HO 2021
.ifdef KIM_IEC
DCMD:
        cmp     #$22                    ; '"'
        bne     LERROR
        jsr     STRTXT
        ;lda     #$3B                   ; ";" TODO: Manage disk number
        ;jsr     SYNCHR
        jsr     SEINIT
        jsr     FREFAC                  ; FREFAC returns:
                                        ; A == length
                                        ; X == addr lo
                                        ; Y == addr hi
        jmp     DSKCMD                  ; Which is what DSKCMD expects

DIR:    
        bne     LRET
        jsr     SEINIT
        jmp     DIRLIST

LRET:   rts

VERIFY:
        beq     LERROR

        ldx     #1
        jmp     DOLOAD
.endif
LOAD:
.ifdef KIM_IEC
        beq     TPLOAD

        ldx     #0
DOLOAD:
        stx     VERCK
        cmp     #$22                    ; '"'
        bne     LERROR
        jsr     STRTXT
        jsr     SEINIT
        jsr     FREFAC
        jmp     FREAD       
TPLOAD:
.endif
        lda     TXTTAB
        ldy     TXTTAB+1
        sta     $17F5
        sty     $17F6
        lda     #$FF
        sta     $17F9
        lda     #<L27A6
        ldy     #>L27A6
        sta     GORESTART+1
        sty     GORESTART+2
        jmp     L1873
L27A6:
        ldx     #$FF
        txs
        lda     #<RESTART
        ldy     #>RESTART
        sta     GORESTART+1
        sty     GORESTART+2
        lda     #<QT_LOADED
        ldy     #>QT_LOADED
        jsr     STROUT
        ldx     $17ED
        ldy     $17EE
        txa
        bne     L27C2
        nop
L27C2:
        nop
        stx     VARTAB
        sty     VARTAB+1
        jmp     FIX_LINKS

