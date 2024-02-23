.segment "CODE"

SAVE:
.ifdef KIM_IEC
        beq     TPSAVE
        cmp     #$22                    ; '"'
        bne     LERROR
        jsr     STRTXT
        jsr     SEINIT
        lda     #FPRNMSG|FPRNERR        ; Print IEC messages and errors
        jsr     SETMSGF
        lda     TXTTAB
        ldy     TXTTAB+1
        jsr     SETSAD
        lda     VARTAB
        ldy     VARTAB+1
        jsr     SETEAD
        jsr     FREFAC
        jsr     FWRITE
        jsr     GETSTAT                 ; Get status into A
        beq     SAVED                   ; No error, print SAVED and exit
        rts
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
SAVED:
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
        lda     #FPRNMSG|FPRNERR        ; Print IEC messages and errors
        jsr     SETMSGF
        jsr     FREFAC                  ; FREFAC returns:
                                        ; A == length
                                        ; X == addr lo
                                        ; Y == addr hi
        jmp     DSKCMD                  ; Which is what DSKCMD expects

DIR:    
        bne     LRET
        jsr     SEINIT
        lda     #FPRNERR                ; Print IEC errors
        jsr     SETMSGF
        jmp     DIRLIST

LRET:   rts

VERIFY:
        beq     LERROR

        tax
        lda     #1
        jmp     DOLOAD
.endif
LOAD:
.ifdef KIM_IEC
        beq     TPLOAD

        tax
        lda     #0
DOLOAD:
        jsr     SETVRCK
        txa
        cmp     #$22                    ; '"'
        bne     LERROR
        jsr     STRTXT
        jsr     SEINIT
        lda     #0                      ; Load starting from addr
        jsr     SETSA                   ; specified by the user
        lda     TXTTAB
        ldy     TXTTAB+1
        jsr     SETMUSS
        lda     #FPRNMSG|FPRNERR        ; Print IEC messages and errors
        jsr     SETMSGF
        jsr     FREFAC
        jsr     FREAD
        jsr     GETSTAT                 ; Get status into A
        and     #~EOI                   ; Mask out End Of Input indicator
        bne     LDERR                   ; Error, go check it
        stx     VARTAB                  ; No error, update program end
        sty     VARTAB+1
        jsr     GETVRCK                 ; Are we verifying?
        beq     LOADED                  ; No, print "LOADED"
        lda     #<QT_VERIFIED           ; Yes, print "VERIFIED"
        ldy     #>QT_VERIFIED
        jmp     MSGOUT
LOADED:
        lda     #<QT_LOADED
        ldy     #>QT_LOADED
MSGOUT:
        jsr     STROUT                  ; Print message and
        lda     #<QT_OK
        ldy     #>QT_OK
        jsr     STROUT
        jmp     FIX_LINKS               ; update pointers
LDERR:
        and     #SPERR                  ; Verify error?
        beq     LRET                    ; No, just return
        lda     #<QT_VERERR             ; Yes, print error and exit
        ldy     #>QT_VERERR
        jmp     STROUT
QT_VERIFIED:
        .byte   "VERIFIED"
        .byte   $00
QT_VERERR:
        .byte   "VERIFY ERR"
        .byte   $00
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
L27C2:
        stx     VARTAB
        sty     VARTAB+1
        jmp     FIX_LINKS

