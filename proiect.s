
;firstly i want to explain some abraviations
;IR =  irish
;ES = espresso
;LA = latte
;LAP = lapte
;Ad = admin
;US = user
;bac = back

;keys used in program:
;G = iterrate through menus
;F2 = select option
;0/1/2/3 = sugar level


;defining variables in RAM memeory
.org 1800h

LOGIN_CIRCLE:
	.ds 6

LOGIN_PASS_USER:
	.ds 3

UTIL_NIV_ZAHAR:
	.ds 6

UTIL_SET_MILK:
	.ds 1
	
; keep selected coffee
UTIL_CAFEA_SELECTATA:
	.ds 6
	
; keep milk selection
UTIL_SELECTIE_LAPTE:
	.ds 6
	
; keep espresso selection
ESPRESSO_SELECTION:
	.ds 1

; keep latte selection	
LATTE_SELECTION:
	.ds 1
	
; keeping irish selection
IRISH_SELECTION:
	.ds 1
	
	
; program start
.org 3000h

;initializing selection for milk and each type of coffee with 1(all are enabled)
	ld hl,	UTIL_SET_MILK
	ld (hl),	1
	ld hl,	ESPRESSO_SELECTION
	ld (hl),		1
	ld hl,	LATTE_SELECTION
	ld (hl),		1
	ld hl,	IRISH_SELECTION
	ld (hl),		1
;################################# START SELECT UTIL PART ################################# 
; menu for selecting admin or user
SEL_UTIL_AFIS_ADM:
	ld ix,	SEL_UTIL_ADMIN
	call scan
	cp 12h
	jp z,	LOGIN_INIT
	cp 19h
	jp nz,	SEL_UTIL_AFIS_ADM
	
	
SEL_UTIL_AFIS_USER:
	ld ix,	SEL_UTIL_USER
	call scan
	cp 12h
	jp z,	UTIL_INIT
	cp 19h
	jp nz,	SEL_UTIL_AFIS_USER
	jp SEL_UTIL_AFIS_ADM
	
	
; start login procces for admin	
LOGIN_INIT:
	ld	d,	0

LOGIN_AFISARE_PASS:
	ld ix,	LOGIN_PASS
	call scan
	cp 12h
	jp nz, LOGIN_INIT
	ld 	hl,	LOGIN_CIRCLE
	ld	(hl),	000h
	inc hl
	ld	(hl),	000h
	inc hl
	ld	(hl),	000h
	inc hl
	ld	(hl),	000h
	inc hl
	ld	(hl),	000h
	inc hl
	ld	(hl),	000h
	ld c,	0
	
	
; introducing password 	
LOGIN_CHAR_INPUT:
	ld ix,	LOGIN_CIRCLE
	call scan
	ld	hl,	LOGIN_PASS_USER
	ld	b,	0
	add	hl,	BC
	ld	(hl),	A
	ld hl,	LOGIN_CIRCLE
	ld b,	0
	add	hl,	BC
	ld	(hl),	0bdh	;cerc
	inc c
	ld a,	c
	cp 3
	jp nz,	LOGIN_CHAR_INPUT

; password validation
LOGIN_VALID_PASS:
	call scan
	cp 12h
	jp nz, LOGIN_VALID_PASS
	ld	c,	0
	
	
; verify password for admin	
LOGIN_VERIFY_PASS:
	ld	hl,	LOGIN_PRELOADED_PASS
	ld	b,	0
	add	hl,	BC
	ld	A,	(hl)
	ld	hl,	LOGIN_PASS_USER
	ld	b,	0
	add	hl,	BC
	ld	b,	(hl)
	cp b
	jp nz, LOGIN_FAILED
	inc c
	ld A,	c
	cp 3
	jp nz,	LOGIN_VERIFY_PASS
	jp SEL_ADM_MENU_INIT
	
	
;method for failed login
; if login failed 3 times program jump to start	
LOGIN_FAILED:
	
	inc d
	ld A,	d
	cp 3
	jp nz,	LOGIN_AFISARE_PASS
	jp SEL_UTIL_AFIS_ADM
	
; login procces finished



; i want to note that 0 means option is off / 1 means option is on	

;################################# START ADMIN PART ################################# 
	
; start the menu for admin
SEL_ADM_MENU_INIT:

;menu for admin which include milk , coffee and back
SEL_ADM_MENU_MILK:
	ld ix,	MILK
	call scan
	cp 12h
	jp z,	SEL_ADM_MENU_SELECT_MILK
	cp 19h
	jp nz,	SEL_ADM_MENU_MILK
	
	
SEL_ADM_MENU_COFFE:	
	ld ix,	SEL_ADM_AFIS_CAFEA
	call scan
	cp 12h
	jp z,	SEL_ADM_MENU_SELECT_COFFE
	cp 19h
	jp nz,	SEL_ADM_MENU_COFFE
	

SEL_ADM_MENU_CANCEL:
	ld ix,	CANCEL
	call scan
	cp 12h
	jp z,	SEL_UTIL_AFIS_ADM
	cp 19h
	jp nz,	SEL_ADM_MENU_CANCEL
	jp SEL_ADM_MENU_MILK
	

; menu where admin can select milk on or off	
SEL_ADM_MENU_SELECT_MILK:

MILK_ON:
	ld ix,	ON
	call scan
	cp 12h
	jp z,	SET_MILK_ON
	cp 19h
	jp nz,	MILK_ON
	
	
MILK_OFF:	
	ld ix,	OFF
	call scan
	cp 12h
	jp z,	SET_MILK_OFF
	cp 19h
	jp nz,	MILK_OFF
	jp MILK_ON
	
; blocks of code for setting milk selection
SET_MILK_ON:
	ld hl,	UTIL_SET_MILK
	ld (hl),	1
	jp SEL_ADM_MENU_INIT

SET_MILK_OFF:
	ld hl,	UTIL_SET_MILK
	ld (hl),	0
	jp SEL_ADM_MENU_INIT
	
; menu where admin can set ,on or off,one or more coffee type 
SEL_ADM_MENU_SELECT_COFFE:

SEL_ADM_MENU_ESPRESSO:
	ld ix,	ESPRESSO
	call scan
	cp 12h
	jp z,	SEL_ADM_MENU_SELECT_ESPRESSO
	cp 19h
	jp nz,	SEL_ADM_MENU_ESPRESSO
	
	
SEL_ADM_MENU_LATTE:	
	ld ix,	LATTE
	call scan
	cp 12h
	jp z,	SEL_ADM_MENU_SELECT_LATTE
	cp 19h
	jp nz,	SEL_ADM_MENU_LATTE

SEL_ADM_MENU_IRISH:	
	ld ix,	IRISH
	call scan
	cp 12h
	jp z,	SEL_ADM_MENU_SELECT_IRISH
	cp 19h
	jp nz,	SEL_ADM_MENU_IRISH
	

SEL_ADM_MENU_COFFE_CANCEL:
	ld ix,	CANCEL
	call scan
	cp 12h
	jp z,	SEL_ADM_MENU_INIT
	cp 19h
	jp nz,	SEL_ADM_MENU_COFFE_CANCEL
	jp SEL_ADM_MENU_ESPRESSO
	
; menu with on/off option for each type of coffee	
SEL_ADM_MENU_SELECT_ESPRESSO:

ESPRESSO_ON:
	ld ix,	ON
	call scan
	cp 12h
	jp z,	SET_ESPRESSO_ON
	cp 19h
	jp nz,	ESPRESSO_ON
	
ESPRESSO_OFF:	
	ld ix,	OFF
	call scan
	cp 12h
	jp z,	SET_ESPRESSO_OFF
	cp 19h
	jp nz,	ESPRESSO_OFF
	jp ESPRESSO_ON

SET_ESPRESSO_ON:
	;load block ESPRESSO_SELECTION in hl register for initializing block with 1
	ld hl,	ESPRESSO_SELECTION
	ld (hl),		1
	jp SEL_ADM_MENU_SELECT_COFFE

SET_ESPRESSO_OFF:
	ld hl,	ESPRESSO_SELECTION
	ld (hl),		0
	jp SEL_ADM_MENU_SELECT_COFFE
	
SEL_ADM_MENU_SELECT_LATTE:

LATTE_ON:
	ld ix,	ON
	call scan
	cp 12h
	jp z,	SET_LATTE_ON
	cp 19h
	jp nz,	LATTE_ON
	
LATTE_OFF:	
	ld ix,	OFF
	call scan
	cp 12h
	jp z,	SET_LATTE_OFF
	cp 19h
	jp nz,	LATTE_OFF
	jp LATTE_ON

SET_LATTE_ON:
	ld hl,	LATTE_SELECTION
	ld (hl),		1
	jp SEL_ADM_MENU_SELECT_COFFE

SET_LATTE_OFF:
	ld hl,	LATTE_SELECTION
	ld (hl),		0
	jp SEL_ADM_MENU_SELECT_COFFE

SEL_ADM_MENU_SELECT_IRISH:
IRISH_ON:
	ld ix,	ON
	call scan
	cp 12h
	jp z,	SET_IRISH_ON
	cp 19h
	jp nz,	IRISH_ON
	
IRISH_OFF:	
	ld ix,	OFF
	call scan
	cp 12h
	jp z,	SET_IRISH_OFF
	cp 19h
	jp nz,	IRISH_OFF
	jp IRISH_ON

SET_IRISH_ON:
	ld hl,	IRISH_SELECTION
	ld (hl),		1
	jp SEL_ADM_MENU_SELECT_COFFE

SET_IRISH_OFF:
	ld hl,	IRISH_SELECTION
	ld (hl),		0
	jp SEL_ADM_MENU_SELECT_COFFE
	
	
	
	
	
;################################# START USER PART ################################# 
UTIL_INIT:
	;b register is used to count the number of disabled coffee selections
	
	;initializing block UTIL_CAFEA_SELECTATA with 0 used for print info
	ld hl, UTIL_CAFEA_SELECTATA
	ld (hl), 000h
	inc hl
	ld (hl), 000h

; insert credit - 1 leu :) (cheap..)
UTIL_INSERT_CREDIT:
	ld ix,	CREDIT
	call scan
	cp 1
	jp nz,	UTIL_INSERT_CREDIT
	
	ld b ,	3
	
; verify if each type of coffee is on or off
VERIFY_ESPRESSO:
	ld hl , ESPRESSO_SELECTION
	ld a,	(hl)
	cp 1
	jp nz,	DECREMENT_ESPRESSO
	
UTIL_ESPRESSO:
	ld ix,	ESPRESSO
	call scan
	cp 12h
;next 4 lines are used to keep which coffee was selected
	ld hl, UTIL_CAFEA_SELECTATA
	ld (hl), 0aeh
	inc hl
	ld (hl), 08fh
	jp z,	VERIFY
	cp 19h
	jp nz,	UTIL_ESPRESSO
	
DECREMENT_ESPRESSO:
; decrementing b contor if a coffee is off
	dec b
	
VERIFY_LATTE:
	ld hl , LATTE_SELECTION
	ld a,	(hl)
	cp 1
	jp nz,	DECREMENT_LATTE
	
UTIL_LATTE:
	ld ix,	LATTE
	call scan
	cp 12h
	ld hl, UTIL_CAFEA_SELECTATA
	ld (hl), 03fh
	inc hl
	ld (hl), 085h
	jp z,	VERIFY
	cp 19h
	jp nz,	UTIL_LATTE
	
DECREMENT_LATTE:
	dec b

VERIFY_IRISH:
	ld hl , IRISH_SELECTION
	ld a,	(hl)
	cp 1
	jp nz,	DECREMENT_IRISH
	
UTIL_IRISH:	
	ld ix,	IRISH
	call scan
	cp 12h
	ld hl, UTIL_CAFEA_SELECTATA
	ld (hl), 037h
	inc hl
	ld (hl), 0aeh
	jp z,	VERIFY
	cp 19h
	jp nz,	UTIL_IRISH
	
DECREMENT_IRISH:
	dec b
;comparing b with 0 , if compare return 0 that means every coffee type is off
;and program show an ERROR message
	ld a,	b
	cp 0
	jp z,	UTIL_ERROR

;method for cancel
UTIL_CANCEL:
	ld ix,	CANCEL
	call scan
	cp 12h
	jp z,	SEL_UTIL_AFIS_ADM
	cp 19h
	jp nz,	UTIL_CANCEL
	jp VERIFY_ESPRESSO
	
;initializing block UTIL_SELECTIE_LAPTE with 0	and verify if milk is on or off
VERIFY:
	ld hl, UTIL_SELECTIE_LAPTE
	ld (hl), 000h
	inc hl
	ld (hl), 000h
	ld hl , UTIL_SET_MILK
	ld a,	(hl)
	cp 1
	jp nz, UTIL_SEL_ZAHAR

;menu for selecting milk ( yes or no )
UTIL_SEL_MILK:
	ld ix,	MILK
	call scan
	cp 12h
	jp nz,	UTIL_SEL_MILK
	
MILK_YES:
	ld ix,	DA
	call scan
	cp 12h
	ld hl, UTIL_SELECTIE_LAPTE
	ld (hl), 03fh
	inc hl
	ld (hl), 0b3h
	jp z,	UTIL_SEL_ZAHAR
	cp 19h
	jp nz,	MILK_YES
	
	
MILK_NO:	
	ld ix,	NU
	call scan
	cp 12h
	ld hl, UTIL_SELECTIE_LAPTE
	ld (hl), 0b5h
	inc hl
	ld (hl), 037h
	jp z,	UTIL_SEL_ZAHAR
	cp 19h
	jp nz,	MILK_NO
	jp MILK_YES

;menu for selecting level of suger
;levels are from 0 to 3
;0 means without sugar / 3 means full sugar	
UTIL_SEL_ZAHAR:
	ld ix, SUGAR
	call scan
	cp 12h
	jp nz,	UTIL_SEL_ZAHAR
	
UTIL_AFIS_ZAHAR:
	ld ix, NIVEL_ZAHAR
	call scan
	ld c ,	a
	cp 00h
	jp z,	ZAHAR_NIV_ZERO
	ld a,	c
	cp 01h
	jp z,	ZAHAR_NIV_UNU
	ld a,	c
	cp 02h
	jp z,	ZAHAR_NIV_DOI
	ld a,	c
	cp 03h
	jp z,	ZAHAR_NIV_TREI
	jp UTIL_AFIS_ZAHAR
	
	
ZAHAR_NIV_ZERO:
	ld a, 0
	call hex7
	ld hl,	UTIL_NIV_ZAHAR
	ld (hl),	a
	ld ix , UTIL_NIV_ZAHAR
	call scan
	cp 12h
	jp	z, FINAL
	jp ZAHAR_NIV_ZERO
	
ZAHAR_NIV_UNU:
	ld a, 1
	call hex7
	ld hl,	UTIL_NIV_ZAHAR
	ld (hl),	a
	ld ix , UTIL_NIV_ZAHAR
	call scan
	cp 12h
	jp	z, FINAL
	jp ZAHAR_NIV_UNU
	
ZAHAR_NIV_DOI:
	ld a, 2
	call hex7
	ld hl,	UTIL_NIV_ZAHAR
	ld (hl),	a
	ld ix , UTIL_NIV_ZAHAR
	call scan
	cp 12h
	jp z, FINAL
	jp ZAHAR_NIV_DOI
	
ZAHAR_NIV_TREI:
	ld a, 3
	call hex7
	ld hl,	UTIL_NIV_ZAHAR
	ld (hl),	a
	ld ix , UTIL_NIV_ZAHAR
	call scan
	cp 12h
	jp	z, FINAL
	jp ZAHAR_NIV_TREI
	
	
;block used for generating a sound and return program to start in case every coffee
;type is off
;UTIL_ERROR , ERROR_LOOP , PRINT_ERROR are used for generating a sound and printing
;5 times (discontinous) the "ERROR" message	
UTIL_ERROR:
	ld c,	20
	call tone
	ld	hl,	blank
	push hl
	ld	ix,	ERROR
	ld d,	10
	
ERROR_LOOP:
	ex	(sp), ix
	ld	b, 100

PRINT_ERROR:
	call scan1
	djnz PRINT_ERROR
	dec d
	ld 	a,	d
	cp 0
	jp z,	SEL_UTIL_AFIS_ADM
	jr	ERROR_LOOP

;final part of program
FINAL:
	;generating a sound
	ld ix,	UTIL_LOAD
	ld c,	60
	call tone
LOADING_LOOP:
	ld de,	500
;printing for 5 seconds "LOAD" message
PRINT_LOAD:
	call scan1
	djnz PRINT_LOAD
	jp PRINT_INFO_CAFEA
	jp LOADING_LOOP
	
;print selected coffee
PRINT_INFO_CAFEA:	
	ld ix,	UTIL_CAFEA_SELECTATA
	
INFO_LOOP_CAFEA:
	ld b,	250
	
AFIS_INFO_CAFEA:
	call scan1
	djnz AFIS_INFO_CAFEA
	jp PRINT_INFO_ZAHAR
	jp INFO_LOOP_CAFEA
	
;print selected level of sugar	
PRINT_INFO_ZAHAR:
	ld ix,	UTIL_NIV_ZAHAR
	
INFO_LOOP_ZAHAR:
	ld b,	250
	
AFIS_INFO_ZAHAR:
	call scan1
	djnz AFIS_INFO_ZAHAR
	jp PRINT_INFO_LAPTE
	jp INFO_LOOP_ZAHAR

;print selected option for milk ( yes or no )
;if the milk selection is turned off from admin menu the UTIL_SELECTIE_LAPTE
;will be 0 and nothing appears on screen	
PRINT_INFO_LAPTE:
	ld ix,	UTIL_SELECTIE_LAPTE
	
INFO_LOOP_LAPTE:
	ld b,	250
	
AFIS_INFO_LAPTE:
	call scan1
	djnz AFIS_INFO_LAPTE
	jp SEL_UTIL_AFIS_ADM
	jp INFO_LOOP_LAPTE
	
	
	

	
; constant blocks of code	
SEL_UTIL_ADMIN:
	.db 000h
	.db 000h
	.db 0b3h
	.db 03fh
	.db 000h
	.db 070h
	
SEL_UTIL_USER:
	.db 000h
	.db 000h
	.db 0aeh
	.db 0b5h
	.db 000h
	.db 0dbh
	
LOGIN_PASS:
	.db	000h
	.db	0AEh	;S
	.db	0AEh	;S
	.db	03Fh	;A
	.db	01Fh	;P
	.db	000h

LOGIN_PRELOADED_PASS:
	.db 001h
	.db	002h
	.db	003h
	
MILK:
	.db 000h
	.db 000h
	.db 000h
	.db 01fh
	.db 03fh
	.db 085h
	
SEL_ADM_AFIS_CAFEA:
	.db 000h
	.db 03fh
	.db 08fh
	.db 00fh
	.db 03fh
	.db 08dh	
	
CANCEL:
	.db 000h
	.db 000h
	.db 000h
	.db 08dh
	.db 03fh
	.db 0a7h
ON:
	.db 000h
	.db 000h
	.db 000h
	.db 000h
	.db 037h
	.db 0bdh
OFF:
	.db 000h
	.db 000h
	.db 000h
	.db 00fh
	.db 00fh
	.db 0bdh

ESPRESSO:
	.db 000h
	.db 000h
	.db 000h
	.db 000h
	.db 0aeh
	.db 08fh

LATTE:
	.db 000h
	.db 000h
	.db 000h
	.db 000h
	.db 03fh
	.db 085h
IRISH:
	.db 000h
	.db 000h
	.db 000h
	.db 000h
	.db 037h
	.db 0aeh
DA:
	.db 000h
	.db 000h
	.db 000h
	.db 000h
	.db 03fh
	.db 0b3h
	
NU:
	.db 000h
	.db 000h
	.db 000h
	.db 000h
	.db 0b5h
	.db 037h

SUGAR:
	.db 000h
	.db 000h
	.db 000h
	.db 000h
	.db 0b5h
	.db 0aeh

NIVEL_ZAHAR:
	.db 000h
	.db 000h
	.db 0bah
	.db 09bh
	.db 030h
	.db 0bdh

ERROR:
	.db 000h
	.db 03fh
	.db 0bdh
	.db 03fh
	.db 03fh
	.db 08fh

UTIL_LOAD:
	.db 040h
	.db 040h
	.db 0b3h
	.db 03fh
	.db 0bdh
	.db 085h
	
CREDIT:
	.db 000h
	.db 0b5h
	.db 08fh
	.db 085h
	.db 000h
	.db 070h

blank:
	.db 000h
	.db 000h
	.db 000h
	.db 000h
	.db 000h
	.db 000h

scan	.equ	05feh
scan1	.equ	0624h
hex7	.equ	0689h
tone 	.equ	05e4h
.end
	rst 38h