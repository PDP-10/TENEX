;SORT.CTL		%EDIT=12
;USED TO MAKE SORT.SHR FROM SORT SOURCE FILES
;SUBMIT WITH COMMAND	.SUBMIT SORT
;
;COPYRIGHT 1973, DIGITAL EQUIPMENT CORP., MAYNARD, MASS.
;
;REQUIRED FILES:
;DSKB:[10,7]	PIP.SHR		(LATEST RELEASED VERSIONS)
;		LOADER.SHR
;		MACRO.SHR
;		DIRECT.SHR
;		COMPIL.SHR
;		CREF.SHR
;		JOBDAT.REL
;[SELF]	SORT.CTL
;	SORT.HLP
;	SORT.DOC
;	SORT.MAC
;	LIBOL.REL (LATEST RELEASED VERSION)
;	CBLIO.MAC (FROM LATEST RELEASED LIBOL)
;	CSORT.MAC (FROM LATEST RELEASED LIBOL)
;
;OUTPUT: SORT.SHR
;
;OUTPUT LISTINGS: SORT.LOG, SORT.HLP(3), SORT.DOC(3)
;	SORT.CTL DOES NOT NORMALLY PRODUCE LISTINGS OF THE ASSEMBLED
;	SOURCES.  IF LISTINGS ARE DESIRED, THE USER SHOULD INCLUDE A
;	FILE CALLED LISTEM.MAC IN HIS AREA.  THIS FILE SHOULD BE EMPTY.
;
;COPY FILES FROM [10,7] AND USE PRIVATE SYS:
.RUN DSKB:PIP[10,7]
*/X=DSKB:[10,7]PIP.SHR,LOADER.SHR,MACRO.SHR,DIRECT.SHR
*/X=DSKB:[10,7]COMPIL.SHR,CREF.SHR,JOBDAT.REL
.IF (ERROR) .GOTO TRUBLE
.ASSIGN DSK: SYS:
;
;MAKE A RECORD OF WHAT IS BEING USED
.SET WATCH VERSION
.IF (NOERROR) .GOTO A
.DIRECTORY/CHECKSUM *.SHR
.GOTO A
A:.DIRECTORY/CHECKSUM SORT.*+CBLIO.MAC+JOBDAT.REL+LIBOL.REL
;ASSEMBLE SOURCES
;
.R MACRO
*SORT,SORT/C=SORT
*CBLIOX,CBLIOX/C=TTY:,DSK:CBLIO
*ISAM==0
=^Z
=^Z
*CSORTX,CSORTX/C=TTY:,DSK:CSORT
*TIMING==1
=
=
.IF (ERROR) .GOTO TRUBLE
;
;CREATE LISTINGS IF FILE LISTEM.MAC PRESENT
.TYPE LISTEM.MAC
.IF (ERROR) .GOTO ENDLST
.R CREF
*SORT.LST=SORT
*CBLIOX.LST=CBLIOX
*CSORTX.LST=CSORTX
.IF (ERROR) .GOTO TRUBLE
ENDLST::;CONTINUE
;
;CREATE SORT.SHR
.R LOADER
=SORT.MAP=SORT,CBLIOX,CSORTX,LIBOL/L/M
.IF (ERROR) .GOTO TRUBLE
.SSAVE DSK:SORT
.IF (ERROR) .GOTO TRUBLE
;
;SEE WHAT WE GOT
.DIRECTORY/CHECKSUM SORT.SHR
;
.DEASSIGN SYS:
.QUEUE SORT.HLP/COPIES:3,SORT.DOC/COPIES:3,*.LST
.IF (ERROR) .PLEASE COULDN'T PRINT SORT DOCUMENTATION
;DELETE UNNEEDED FILES
.RUN DSK:PIP
*DSK:/D=CBLIOX.REL,CSORTX.REL,SORT.REL,*.CRF,CREF.SHR
*DSK:/D=LOADER.SHR,MACRO.SHR,DIRECT.SHR,COMPIL.SHR,JOBDAT.REL
*DSK:/D=PIP.SHR
.IF (ERROR) .PLEASE -- ERRORS DELETING SORT FILES
;
;
;TELL OPERATOR HOW WE DID
.PLEASE -- SORT CREATION SUCCESSFUL
.GOTO OK
TRUBLE:.PLEASE -- SORT CREATION NOT SUCCESSFUL!!!
OK::.;END OF SORT.CTL
