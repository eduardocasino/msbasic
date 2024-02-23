; Values for the message flag
;
FPRNMSG         = %10000000
FPRNERR         = %01000000

; IEC Error mask
;
SPERR           = $10           ; Second Pass error (verify error)
EOI             = $40           ; End Of Input indicator


; IEC disk functions
;
SEINIT          := $F000
SETSAD          := $F003
SETEAD          := $F006
SETMUSS         := $F009
SETVRCK         := $F00C
GETVRCK         := $F00F
SETFA           := $F012
SETSA           := $F015
GETSTAT         := $F018
SETMSGF         := $F01B
GETMSGF         := $F01E
DSKCMD          := $F021
DIRLIST         := $F024
FREAD           := $F027
FWRITE          := $F02A
