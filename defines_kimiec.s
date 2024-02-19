; Values for the message flag
;
FPRNMSG         = %10000000
FPRNERR         = %01000000

; IEC Error mask
;
SPERR           = $10           ; Second Pass error (verify error)


; IEC disk functions
;
SEINIT          := $F000
SETSAD          := $F003
SETEAD          := $F006
SETMUSS         := $F009
SETVRCK         := $F00C
SETFA           := $F00F
SETSA           := $F012
GETSTAT         := $F015
SETMSGF         := $F018
GETMSGF         := $F01B
DSKCMD          := $F01E
DIRLIST         := $F021
FREAD           := $F024
FWRITE          := $F027
