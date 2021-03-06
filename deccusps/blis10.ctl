;FILENAME:	BLIS10.CTL
;DATE:		10 SEPTEMBER 1974
;AUTHOR:	M.G. MANUGIAN/FLD/KR/GJB
;
;COPYRIGHT 1972,1973,1974 DIGITAL EQUIPMENT CORPORATION, MAYNARD, MASS. 01754
;
;QUEUE COMMAND: .SUBMIT BLIS10/OUTPUT:1/TIME:60:00/CORE:59
;
;FUNCTION:	THIS JOB PRODUCES THE PRODUCTION VERSION OF BLIS10.
;
;REQUIREMENTS:	THIS JOB WILL REQUIRE A MAXIMUM OF 3000 DISK BLOCKS
;		AND 59K OF CORE.
;
;INPUT:		REQUIRES THE FOLLOWING FILES ON [1,4]
;
;			SETSRC.SHR
;
;		REQUIRES THE FOLLOWING FILES ON [10,7]
;
;			COMPIL.SHR
;			BLIS10.SHR	IF THESE TWO FILES EXIST ON DSK:,
;			BLIS10.LOW	THEY WILL REMAKE THEMSELVES.
;			MACRO.SHR
;			LINK.SHR
;			LNKSCN.SHR
;			LNKLOD.SHR
;			LNKMAP.SHR
;			LNKXIT.SHR
;			LNK999.SHR
;			LNKERR.SHR
;			JOBDAT.REL
;			DIRECT.SHR
;
;		REQUIRES THE FOLLOWING FILES ON DSK:
;
;			BLIS10.CTL
;			BEGIN.BLI
;			START0.BLI
;			LOADDR.BLI
;			LODECL.BLI
;			LODRIV.BLI
;			LOGTRE.BLI
;			LOLEXA.BLI
;			LOLSTP.BLI
;			LOMACR.BLI
;			LOXREF.BLI
;			START1.BLI
;			H1CNTR.BLI
;			H1DECL.BLI
;			H1GTRE.BLI
;			H1LEXA.BLI
;			H1MACR.BLI
;			H1REQU.BLI
;			H1SYNT.BLI
;			START2.BLI
;			H2ADDR.BLI
;			H2ARIT.BLI
;			H2CNTR.BLI
;			H2GTRE.BLI
;			H2REGI.BLI
;			START3.BLI
;			H3ASSY.BLI
;			H3CCL.BLI
;			H3CNTR.BLI
;			H3DECL.BLI
;			H3LDIN.BLI
;			H3LEXA.BLI
;			H3LSTP.BLI
;			H3REGI.BLI
;			H3XREF.BLI
;			H3DRIV.BLI
;			END.BLI
;			INDEX.SHR
;			BLIS10.ERR	KEEP THIS UP TO DATE
;			LOIO.MAC
;			LOONCE.MAC
;
;OUTPUT:	GENERATES A COMPILER WITHOUT DDT AND SYMBOLS AS WELL
;		AS RELOCATABLE BINARIES.
;
;		SOURCE FILES:
;
;			BLSERR.BLI
;
;		RELOCATABLE BINARIES:
;
;			LOBLI.REL
;			H1BLI.REL
;			H2BLI.REL
;			H3BLI.REL
;			BLSERR.REL
;			LOIO.REL
;			LOONCE.REL
;
;		OBJECT FILES:
;
;			BLIS10.SHR
;			BLIS10.LOW
;
;		AND THE LOADER MAP:
;
;			BLIS10.MAP
;
;ERRORS:	GENERALLY ON AN ERROR CONDITION IT WILL TRY TO
;		DO AS MUCH AS IT POSSIBLY CAN AND WILL NOT ABORT.
.NOERROR
;
.SET WATCH ALL
;
;SET UP FOR USE OF [10,7] SOFTWARE
;
.R SETSRC
*R DSKB
*A DSKD
*A DSKB
*M /LIB:[10,7]
*T
.ASSIGN DSK SYS
;
;NOW DO THE COMPILATIONS
;
.COMPILE LOBLI=START0+BEGIN+LOADDR+LODECL+LODRIV+LOGTRE+LOLEXA+LOLSTP+LOMACR+LOXREF+END
;
.COMPILE H1BLI=START1+BEGIN+H1CNTR+H1DECL+H1GTRE+H1LEXA+H1MACR+H1REQU+H1SYNT+END
;
.COMPILE H2BLI=START2+BEGIN+H2ADDR+H2ARIT+H2CNTR+H2GTRE+H2REGI+END
;
.COMPILE H3BLI=START3+BEGIN+H3ASSY+H3CCL+H3CNTR+H3DECL+H3LDIN+H3LEXA+H3LSTP+H3REGI+H3XREF+H3DRIV+END
;
;NOW COMPILE THE MACRO-10 SOURCES.
;
.COMPILE LOIO,LOONCE
;
; NOW GENERATE THE ERROR TABLE
;
.RUN INDEX
*BLSERR.BLI=BLIS10.ERR
.COMPILE BLSERR
;
;NOW LOAD THE COMPILER
;
.R LINK
*/HASHSIZE:1000
*/FRECOR:10000
*LOIO,LOBLI,H1BLI,H2BLI,BLSERR,H3BLI,LOONCE
*BLIS10/MAP
*/GO
.SSAVE BLIS10
;
;NOW GET CHECKSUMS OF ALL FILES FOR QA
;
.DIR /CHECKSUM
;
;END OF BLIS10.CTL
