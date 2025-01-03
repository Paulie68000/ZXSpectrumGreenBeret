; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; Konami's Green Beret, Published by Imagine Software.
;
; Written by Jonathan Smith, 1986
;
; Reverse Engineered by Paul Hughes December 2024
;

	DEVICE ZXSPECTRUM48

	cspectmap

	include "spectrum.asm"

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

CONFIGURE_INPUT			equ 0
START_LEVEL				equ 0
NO_BADDY_COLLISIONS		equ 1

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; Sprite Data structure
;

TYP:							equ	$00		; sprite type index  (0 = inactive)
FLAG:							equ $01		; flags
XSPD:							equ $02		; x movement speed
BASEY:							equ $03		; base Y position prior to jump / climb
DIR:							equ	$04		; direction
CNT1:							equ $05		; general purpose counter 1
CNT2:							equ	$06		; general purpose counter 2
MAPXL:							equ	$07		; map x position (word)
MAPXH:							equ $08		;
ONLADDER:						equ $09		; sprite is on a ladder
XNO:							equ	$0a		; x coord
YNO:							equ	$0b		; y coord
GNO:							equ	$0c		; graphic index
YTMP:							equ	$0d		; temp y pos
PIXADL:							equ	$0e		; screen position (word)
PIXADH:							equ	$0f		;

; Baddy TYPes

T_BADDYGUN:						equ $00			; Running Enemy with Gun (can climb)
T_BADDYRUN:						equ $01			; Running enemy (no climbing)
T_BADDYJUMPER:					equ $02			; Jumping enemy (left)
T_BADDYMORTAR:					equ $03			; Mortar Guy
T_BADDYPARACHUTE:				equ $04			; Parachute Guy
T_BADDYSHOOTING:				equ $05			; Shooting Enemy with Gun
T_BADDYRUNTURN:					equ $06			; Running enemy (no climbing) set with a direction change
T_BADDYKICK:					equ $07			; Jump kick enemy (left)
T_BADDYCOMMANDANT:				equ $08			; Commandant (carries a shooter weapon)
T_BADDYDIE:						equ $09			; Baddy Die
T_BADDYSTOPPED:					equ $0a			; Stopped Enemy (after shooting)
T_DOGRIGHTANDJUMP:				equ $0b			; Dog runs Right and then jumps at player
T_DOGLEFT:						equ $0c			; Dog Left
T_DOGJUMP:						equ $0d			; Jumping Dog
T_BADDYDOGDIE:					equ $0e			; Dog die

; GNO indexes

G_PLAYERWALKRIGHT:				EQU	$00 
G_PLAYERWALKLEFT:				EQU	$01 
G_PLAYERWALKRIGHT2:				EQU	$02 
G_NOTHING:						EQU	$03 
G_PLAYERRIGHTJUMP:				EQU	$04 
G_PLAYERLEFTJUMP:				EQU	$05 
G_PLAYERCLIMB1:					EQU	$06 
G_PLAYERCLIMB2:					EQU	$07 
G_PLAYERLIEDOWNRIGHT:			EQU	$08 
G_PLAYERLIEDOWNLEFT:			EQU	$09 
G_PLAYERSTABRIGHT:				EQU	$0a 
G_PLAYERSTABLEFT:				EQU	$0b 
G_PLAYERLIEDOWNRIGHTSTAB:		EQU	$0c 
G_PLAYERLIEDOWNLEFTSTAB:		EQU	$0d 
G_RUNNINGBADDYRIGHT1:			EQU	$0e 
G_RUNNINGBADDYRIGHT2:			EQU	$0f 
G_RUNNINGBADDYLEFT1:			EQU	$10 
G_RUNNINGBADDYLEFT2:			EQU	$11 
G_SKELETONRIGHT:				EQU	$12 
G_SKELETONLEFT:					EQU	$13 
G_FLAMETHROWER:					EQU	$14 
G_BAZOOKA:						EQU	$15 
G_GUNRUNNERRIGHT:				EQU	$16 
G_GUNRUNNERSHOOTRIGHT:			EQU	$17 
G_GUNRUNNERLEFT:				EQU	$18 
G_GUNRUNNNERSHOOTLEFT:			EQU	$19 
G_MORTARGUYRIGHT:				EQU	$1a 
G_MORTARGUYLEFT:				EQU	$1b 
G_JUMPKICKBADDY:				EQU	$1c 
G_EXPLOSION:					EQU	$1d 
G_COMMANDANTLEFT1:				EQU	$1e 
G_COMMANDANTLEFT2:				EQU	$1f 
G_DOGRIGHT:						EQU	$20 
G_DOGLEFT:						EQU	$21 
G_BADDYCLIMB:					EQU	$22 
G_BADDYLIERIGHT:				EQU	$23 
 
; Sounds

S_JUMP:							EQU	$01
S_FALL:							EQU	$02
S_SHOOTBULLET:					EQU	$03
S_BADDYJUMP:					EQU	$04
S_KICK:							EQU	$05
S_HELICOPTER:					EQU	$06
S_WEAPONLAUNCH:					EQU	$07
S_STAB:							EQU	$08
S_EXPLOSION:					EQU	$09

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; "Sprint" commands
;

AT:			EQU $00
DIRECT:		EQU $01
MODE:		EQU $02
TAB:		EQU $03
REP:		EQU $04
PEN:		EQU $05
CHR:		EQU $06
RSET:		EQU $07
JSR:		EQU $08
JSRS:		EQU $09
CLS:		EQU $0a
CLA:		EQU $0b
EXPD:		EQU $0c
RTN:		EQU $0d
BACKSP:		EQU $0e
LOOP:		EQU $0f			; introduced for Green Beret
NEXT:		EQU $10
TABX:		EQU $11
XTO:		EQU $12
YTO:		EQU $13
EXOFF:		EQU $14

UP:			EQU 0
UP_RI:		EQU 1
RI:			EQU 2
DW_RI:		EQU 3
DW:			EQU 4
DW_LE:		EQU 5
LE:			EQU 6
UP_LE:		EQU 7

S:			EQU 128
B:			EQU 64

EXPN:		EQU 1
NINK:		EQU 255

NORM:		equ 	0
OVER:		equ 	1
ORON:		equ 	2
INVR:		equ 	3
EXPAND:		equ 	4
RESETP:		equ		5

FIN:		equ 	$ff

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;
	org $5B00

JP_WipeLevelOn:
	JP   WipeLevelOn

JP_DecodeMap:
	JP   DecodeMap

JP_Sprint:
	JP   Sprint

JP_FillAttrBlocks:
	JP   FillAttrBlocks

JP_PRChar:
	JP   PRChar

JP_FillAttrBlock:
	JP   FillAttrBlock
	JP   AttrAddr

JP_SetupLevelMap:
	JP   SetupLevelMap

JP_TriggerEOL3Helicopters:
	JP   TriggerEOL3Helicopters

JP_EOL3_Boss:
	JP   EOL3_Boss

JP_UpdatePlayerMovement:
	JP   UpdatePlayerMovement

JP_DoGameEnding:
	JP   DoGameEnding

JP_DrawCaptives:
	JP   DrawCaptives

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

MapAttrColumn:
	db $68
	db $68
	db $68
	db $68

MapAttrColumn2:	
	db $60
	db $60
	db $28
	db $68

MapTileColumn:			; tile numbers for one column of the map
	db $20
	db $20
	db $30
	db $38

	db $2B
	db $49
	db $4F
	db $52

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

LevelData:
	dw Level1Data			; Level 1 Data
	dw Level2Data			; Level 2 Data
	dw Level3Data			; Level 3 Data
	dw Level4Data			; Level 4 Data

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

SpriteTable:
	dw gfx_PlayerWalkRight		; sprite data - Walk right
	db $0C						; height
	db $00						; index into gfx_MaskAddresses
	dw gfx_PlayerWalkLeft		; walk left
	db $0C
	db $01
	dw gfx_PlayerWalkRight2		; walk right 2
	db $0C
	db $02
	dw $0000
	db $00
	db $00
	dw gfx_PlayerRightJump			; right static
	db $0C
	db $03
	dw gfx_PlayerLeftJump			; left static
	db $0C	
	db $04	
	dw gfx_PlayerClimb1				; player climb 1
	db $0C	
	db $05	
	dw gfx_PlayerClimb2				; player climb 2
	db $0C	
	db $06	
	dw gfx_PlayerLieDownRight		; lie down right
	db $06	
	db $07	
	dw gfx_PlayerLieDownLeft		; lie down left
	db $06	
	db $08	
	dw gfx_PlayerStabRight			; stab right
	db $0C	
	db $09	
	dw gfx_PlayerStabLeft			; stab left
	db $0C
	db $0A
	dw gfx_PlayerLieDownStabRight	; lie down right stab
	db $06
	db $15
	dw gfx_PlayerLieDownStabLeft	; lie down left stab
	db $06
	db $16
	dw gfx_RunningBaddyRight1		; running baddy right 1
	db $0C
	db $0B
	dw gfx_RunningBaddyRight2		; running baddy right 2
	db $0C
	db $0C
	dw gfx_RunningBaddyLeft1		; running baddy left 1 (legs open)
	db $0C
	db $0D
	dw gfx_RunningBaddyLeft2		; running baddy left 2 (legs closed)
	db $0C
	db $0E
	dw gfx_SkeletonRight			; skeleton right
	db $0C
	db $0B
	dw gfx_SkeletonLeft				; skeleton left
	db $0C
	db $0D
	dw gfx_FlameThrower				; short flame
	db $04
	db $10
	dw gfx_Bazooka					; bazooka
	db $04
	db $0F
	dw gfx_BaddyGunRunnerRight		; gun runner right
	db $0C
	db $0B
	dw gfx_BaddyGunRunnerRightShoot	; gun runner shoot right
	db $0C
	db $0C
	dw gfx_BaddyGunRunnerLeft		; gun runner left
	db $0C
	db $0D
	dw gfx_BaddyGunRunnerLeftShoot	; gun runner shoot left
	db $0C
	db $0E
	dw gfx_MortarGuyRight			; mortar guy right
	db $0C
	db $11
	dw gfx_MortarGuyLeft			; mortar guy left
	db $0C
	db $12
	dw gfx_BaddyKickLeft			; kick left
	db $0C
	db $13
	dw gfx_ExplosionSmall			; explosion small
	db $0C
	db $14
	dw gfx_CommandantRunLeft1		; commandant left 1
	db $0C
	db $0D
	dw gfx_CommandantRunLeft2		; commandant left 2
	db $0C
	db $0E
	dw gfx_DogRight					; dog right 1
	db $08
	db $18
	dw gfx_DogLeft					; dog left 1
	db $08
	db $19
	dw gfx_BaddyClimb				; baddy climb
	db $0C
	db $17
	dw gfx_BaddyLieRight			; baddy lie right
	db $06
	db $1A

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

HelicopterMovementData:
	db $00			; +0 xdelta
	db $FF			; +1 ydelta
	db $00			; +2 xcount
	db $00			; +3 ycount
	db $06			; +4 dir bits
	db $08			; +5 +- 8 constant

	db $00
	db $FF
	db $00
	db $00
	db $06
	db $0A			; +- 10 constant
	
	db $00
	db $FF
	db $00
	db $00
	db $06
	db $18			; +- 16 constant

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

SoundFXTable:
	dw SFX_1			; jump
	dw SFX_2			; fall
	dw SFX_3			; shoot bullet
	dw SFX_4			; baddy jump
	dw SFX_5			; kick
	dw SFX_6			; helicopter
	dw SFX_7			; weapon launch
	dw SFX_8			; stab sound
	dw SFX_9			; explosion
	dw $0000

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; Level Data - 7 words per level
;

Level1Data:			
	dw L1_LadderData		; Map Ladder Data
	dw L1_MapRow1			; Map Platforms Row 1
	dw L1_MapRow2			; Map Platforms Row 2
	dw L1_MortarTriggers	; MortarTriggers
	dw L1_WeaponTriggers	; WeaponTriggers
	dw L1_MineTriggers		; Mine Triggers
	dw L1_ParachuteTriggers	; Parachute Triggers

Level2Data:
	dw L2_LadderData
	dw L2_MapRow1
	dw L2_MapRow2
	dw L2_MortarTriggers
	dw L2_WeaponTriggers
	dw L2_MineTriggers
	dw L2_ParachuteTriggers

Level3Data:
	dw L3_LadderData
	dw L3_MapRow1
	dw L3_MapRow2
	dw L3_MortarTriggers
	dw L3_WeaponTriggers
	dw L3_MineTriggers
	dw L3_ParachuteTriggers

Level4Data:
	dw L4_LadderData
	dw L4_MapRow1
	dw L4_MapRow2
	dw L4_MortarTriggers
	dw L4_WeaponTriggers
	dw L4_MineTriggers
	dw L4_ParachuteTriggers

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

L1_LadderData:

	db $07,$00,$17,$40,$37,$00,$47,$40,$67,$00,$77,$40,$97,$00,$a7,$40,$c7,$00,$d7,$40,$f7,$00,$07,$41,$cf,$01,$13,$02,$57,$02,$9b,$02
	db $ff,$ff

L2_LadderData:

	db $07,$00,$5f,$00,$b7,$00,$0f,$01,$67,$01,$bf,$01,$df,$41,$ff,$01,$1f,$42,$3f,$02,$bf,$02,$df,$42,$ff,$02,$1f,$43,$3f,$03,$bf,$03
	db $df,$43,$ff,$03,$1f,$44,$5f,$04,$b7,$04,$d7,$44,$f7,$04,$17,$45,$37,$05,$57,$45,$ff,$ff

L3_LadderData:

	db $13,$00,$43,$00,$93,$00,$e3,$00,$33,$01,$83,$01,$d3,$01,$4b,$82,$cb,$82,$4b,$83,$23,$04,$53,$04,$83,$04,$b3,$04,$e3,$04,$13,$05
	db $ff,$ff

L4_LadderData:

	db $07,$00,$1b,$40,$3f,$00,$53,$40,$77,$00,$8b,$40,$af,$00,$c3,$40,$e7,$00,$fb,$40,$1f,$01,$33,$41,$57,$01,$6b,$41,$8f,$01,$a3,$41
	db $c7,$01,$db,$41,$ff,$01,$13,$42,$83,$02,$b3,$02,$e3,$02,$13,$03,$4b,$04,$83,$04,$ef,$05,$2f,$06,$6f,$06,$af,$06,$ff,$ff

L1_MapRow1:
	db $10,$00,$2c,$00,$40,$00,$5c,$00,$70,$00,$8c,$00,$a0,$00,$bc,$00,$ce,$00,$ec,$00,$fe,$00,$1c,$01,$ff,$ff,$ff,$ff

L1_MapRow2:
	db $01,$00,$34,$01,$6e,$01,$a8,$01,$c6,$01,$f4,$01,$0a,$02,$38,$02,$4e,$02,$7c,$02,$92,$02,$c0,$02,$ff,$ff,$ff,$ff

L2_MapRow1:
	db $ba,$01,$5b,$02,$ba,$02,$5b,$03,$ba,$03,$3b,$04,$b2,$04,$73,$05,$ff,$ff,$ff,$ff

L2_MapRow2:
	db $01,$00,$5b,$02,$ba,$02,$5b,$03,$ba,$03,$73,$05,$ff,$ff,$ff,$ff

L3_MapRow1:
	db $22, $02, $AA, $03, $FF, $FF, $FF, $FF

L3_MapRow2:
	db $01, $00, $23, $02, $1A, $04, $3F, $05, $FF, $FF, $FF, $FF

L4_MapRow1:
	db $0a,$00,$2f,$00,$42,$00,$67,$00,$7a,$00,$9f,$00,$b2,$00,$d7,$00,$ea,$00,$0f,$01,$22,$01,$47,$01,$5a,$01,$7f,$01,$92,$01,$b7,$01
	db $ca,$01,$ef,$01,$02,$02,$27,$02,$ff,$ff,$ff,$ff

L4_MapRow2:
	db $02,$00,$2f,$00,$3a,$00,$67,$00,$74,$00,$9f,$00,$aa,$00,$d7,$00,$e2,$00,$0f,$01,$1a,$01,$47,$01,$52,$01,$7f,$01,$8a,$01,$b7,$01
	db $c2,$01,$ef,$01,$fa,$01,$27,$02,$7a,$02,$43,$03,$42,$04,$a7,$04,$ea,$05,$f3,$06

L1_ParachuteTriggers:
	db $FF, $FF, $FF, $FF

L1_MineTriggers:
	db $A8, $00, $D2, $01, $E2, $01, $F2, $01

L2_MineTriggers:
	db $70,$00,$18,$01,$26,$01,$76,$01,$68,$04,$78,$04,$88,$04

L3_MineTriggers:
	db $a6,$00,$c6,$00,$72,$01,$56,$02,$b6,$02,$16,$03,$d0,$03,$68,$04

L4_MineTriggers:
	db $c0,$00,$5e,$01,$70,$01,$a0,$01,$52,$03,$be,$03,$14,$04,$b4,$04,$f4,$04,$34,$05,$74,$05,$b4,$05,$48,$06,$f4,$06

L2_ParachuteTriggers:
	db $5C, $02, $58, $03, $FF, $FF

L3_ParachuteTriggers:
	db $90, $03, $FF, $FF

L4_ParachuteTriggers:
	db $2A, $03, $C6, $03, $FF, $FF

L1_MortarTriggers:
	dw $0116

L2_MortarTriggers:
	dw $0071, $00C6, $0174, $046C

L3_MortarTriggers:
	db $8A, $00, $EE, $00, $70, $01, $D4, $01, $4C, $02

L4_MortarTriggers:
	db $CA, $00, $DA, $01, $3E, $02, $A4, $04, $26, $05, $A6, $05, $2A, $06, $DA, $06

L1_WeaponTriggers:
	db $74,$00,$01,$d4,$00,$01,$ea,$01,$05,$b2,$02,$09,$ff,$ff

L2_WeaponTriggers:
	db $8a,$00,$06,$40,$01,$06,$18,$02,$02,$1c,$03,$02,$ff,$ff

L3_WeaponTriggers:
	db $71,$00,$07,$fa,$00,$07,$68,$01,$07,$c2,$01,$05,$74,$04,$06,$ff,$ff

L4_WeaponTriggers:
	db $84,$00,$03,$fc,$00,$03,$a0,$01,$03,$bc,$02,$06,$b0,$04,$0a,$e4,$05,$07,$ff,$ff

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

SFX_9:
	db $3D
	db $47
	db $51
	db $33
	db $3D
	db $47
	db $29
	db $33
	db $3D
	db $1F
	db $29
	db $33
	db $15
	db $1F
	db $29
	db $0B
	db $15
	db $1F
	db $FF
SFX_1:
	db $FE
	db $C8
	db $FE
	db $C8
	db $9A
	db $64
	db $9A
	db $64
	db $FF
SFX_8:
	db $81
	db $41
	db $21
	db $09
	db $05
	db $FF
SFX_7:
	db $0B
	db $65
	db $15
	db $6F
	db $1F
	db $79
	db $29
	db $83
	db $33
	db $8D
	db $3D
	db $97
	db $FF
SFX_3:
	db $0B
	db $15
	db $29
	db $51
	db $A1
	db $FB
	db $FB
	db $A1
	db $51
	db $29
	db $15
	db $0B
	db $FF
SFX_2:
	db $C8
	db $01
	db $03
	db $05
	db $DC
	db $01
	db $03
	db $05
	db $F0
	db $01
	db $03
	db $05
	db $FF
SFX_4:
	db $C8
	db $BE
	db $AA
	db $96
	db $82
	db $6E
	db $FF
SFX_5:
	dw $111D
	dw $0D19
	dw $0B17
	dw $0B15
	db $FF
SFX_6:
	db $13
	db $0F
	db $0B
	db $07
	db $03
	db $FF

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlayerSpeedDir:			; first byte speed, second byte the direction of travel
	db $00
	db $FF
	db $02
	db $00
	db $FE
	db $01
	db $00
	db $FF

PlayerXYTarget:
	dw $0000

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DoGameEnding:
	LD   B,$64
	CALL WaitBC_2

	INC  (IY+$61)		;FFE3 - Lives
	LD   A,(RandMask)
	SRL  A
	OR   $01
	LD   (RandMask),A
	LD   A,(BaddyCountdownTime)
	SUB  $08
	JR   NC,.NoReset

	LD   A,$01
.NoReset:
	LD   (BaddyCountdownTime),A
	LD   A,(EOLBaddyCountdownTime)
	SUB  $0A
	JR   NC,.NoReset2

	LD   A,$01
.NoReset2:
	LD   (EOLBaddyCountdownTime),A
	CALL Sprint
	db CLA
	db CLS
	db FIN
	CALL DrawCaptives

	CALL Sprint
	db MODE, EXPAND, $02
	db PEN, $45
	db AT, $06, $05
	db "MISSION ACCOMPLISHED"
	db MODE, RESETP
	db PEN, $46
	db AT, $06, $08
	db "PROCEED TO NEXT CAMP"
	db PEN, $FF
	db FIN

	EI  
	LD   B,$00
	CALL WaitBC_2

	CALL Sprint
	db CLA
	db CLS
	db FIN

	LD   B,$00
	JP   WaitBC_2

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdatePlayerMovement:
	LD   DE,PlayerOnLadder
	LD   A,(DE)
	INC  DE
	LD   B,A			; B = PlayerOnLadder value
	LD   A,(isInAir)
	OR   A
	JP   NZ,UpdateJump

	LD   A,(IsStabbing)
	OR   A
	JR   NZ,UpdateStab
	
	LD   A,(PlayerLieDown)
	OR   A
	CALL NZ,UpdateLieDown

	LD   A,(FUDLR)
	LD   C,A
	AND  $1F
	ADD  A,A
	LD   HL,PlayerMoveTable
	CALL AddHLA2
	JP   JPIndex2			; DE = Player X address, B = PlayerOnLadder, C = SFUDLR

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateStab:
	DEC  A
	LD   (IsStabbing),A			; countdown for stabbing time
	RET  NZ

	INC  DE						; stab counter done
	INC  DE
	LD   A,(PlayerLieDown)
	OR   A
	LD   A,(DE)					; PlayerDir
	JR   NZ,LyingStab
	
	CP   $02
	RET  C
	
	SUB  $0A					; 1010 - remove lying down bits
	LD   (DE),A
	RES  4,(IY+$28)				; FUDLR - clear fire bit from input
	JR   UpdatePlayerMovement

LyingStab:
	CP   $0A
	RET  C

	SUB  $04					; remove lying down bit
	LD   (DE),A
	RES  4,(IY+$28)				; FUDLR - remove fire bit from input
	JR   UpdatePlayerMovement

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlayerDown:
	LD   A,B
	OR   A
	JP   NZ,DownOnLadder

LieDown:
	LD   A,(DE)				; PlayerX
	AND  $F8
	LD   (DE),A
	LD   (PlayerLieDown),A	; flag lying down as aligned 8 pixel X position
	INC  DE
	LD   A,(DE)				; PlayerY
	ADD  A,$0C
	LD   (DE),A				; PlayerY
	INC  DE
	LD   A,(DE)				; PlayerDir
	AND  $01
	ADD  A,$08				; Lying Down
	LD   (DE),A
	LD   A,(FUDLR)
	AND  $03
	RET  PE

	ADD  A,$07
	LD   (DE),A
NoAction:
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateLieDown:
	INC  DE
	LD   A,(DE)				; PlayerY
	SUB  $0C
	LD   (DE),A				; -12
	INC  DE
	LD   A,(DE)				; PlayerDir
	SUB  $08				; remove lie down flag from Player Direction
	LD   (DE),A
	XOR  A					; clear lying down flag
	LD   (PlayerLieDown),A
	DEC  DE
	DEC  DE
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlayerDownStab:
	LD   A,B
	OR   A
	JR   Z,DownNotOnLadder
	LD   A,$04
	LD   B,A
	PUSH DE
	CALL JP_CheckOnLadder
	POP  DE
	JR   C,PlayerUpOnLadder

DownNotOnLadder:
	BIT  4,(IY+$25)			; LastFUDLR
	JR   NZ,LieDown

	LD   A,(DE)			; PlayerX
	AND  $F8			; 8 pixel align
	LD   (DE),A			; PlayerX
	LD   (PlayerLieDown),A			; Player is lying down
	INC  DE
	LD   A,(DE)			; PlayerY
	ADD  A,$0C
	LD   (DE),A			; PlayerY + 12
	INC  DE
	LD   A,(DE)			; PlayerDir
	AND  $01			; keep left/rigth direction
	ADD  A,$0C			; add in 1100 - lie down
	LD   (DE),A
	LD   (IY+$22),$02			; isStabbing (for two frames)
	LD   HL,KnifeOffsetsLying
	CALL SetupKnifeLying
	LD   A,S_STAB			;$08
	JP   JP_PlaySound

SetupKnife:
	LD   HL,KnifeOffsets
SetupKnifeLying:
	LD   A,(PlayerDir)			; player facing
	AND  $01
	LD   (KnifeGNO),A
	ADD  A,A
	CALL AddHLA2
	LD   A,(PlayerX)
	ADD  A,(HL)			; adjust x/y pos for small weapon
	INC  HL
	LD   (KnifeXNO),A
	LD   A,(PlayerY)
	ADD  A,(HL)
	LD   (KnifeYNO),A
	RET 

KnifeOffsets:
	db $16, $0A,$F9,$0A

KnifeOffsetsLying:
	db $1E, $06, $F8, $06

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DownOnLadder:
	LD   A,$04
	LD   B,A
	PUSH DE
	CALL JP_CheckOnLadder
	POP  DE
	JR   C,PlayerUpOnLadder
	LD   A,(isSnappedToLadder)
	LD   C,A
	XOR  A
	LD   (isSnappedToLadder),A
	LD   A,C
	OR   A
	RET  NZ

	JP   LieDown

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlayerUp:
	LD   A,B
	OR   A
	JR   Z,NotOnLadder
	LD   A,$FC			; -4 = Y Move Amount
	LD   B,$00			; B = Y Offset
	PUSH DE
	CALL JP_CheckOnLadder
	POP  DE
	JR   NC,NotOnLadder

PlayerUpOnLadder:
	LD   A,(isSnappedToLadder)
	OR   A
	JR   NZ,isSnapped

	LD   A,(DE)			; PlayerX
	LD   (PlayerLadderX),A
	LD   C,A
	AND  $F8
	ADD  A,$04			; snap to a four pixel boundary when on ladder
	CP   C
	LD   A,C
	JR   NC,SnapBack

	ADD  A,$08			; move along 8 pixels to the next character position
SnapBack:
	AND  $F8
	LD   (DE),A			; PlayerX
isSnapped:
	INC  DE
	LD   A,(DE)			; PlayerY
	AND  $FC			; 11111100
	LD   (DE),A
	RRCA
	RRCA
	RRCA
	RRCA
	AND  $01
	ADD  A,$06			; 110 - Top/bot of ladder if bit 4 of Y is set then we're near the ladder top and so 111 is set
	INC  DE
	LD   (DE),A			; PlayerDir
	LD   (isSnappedToLadder),A
	XOR  A
	LD   (isInAir),A
	LD   (IsStabbing),A
	RET 

NotOnLadder:
	XOR  A
	LD   (isSnappedToLadder),A
	BIT  3,(IY+$25)			; LastFUDLR
	RET  NZ
	LD   A,$39
	LD   (JumpYIndex),A
	LD   (isInAir),A
	PUSH DE
	INC  DE			; PlayerY
	LD   A,(DE)
	LD   (JumpStartY),A
	LD   (JumpSnapY),A			; Store start Y pos when about to jump
	INC  DE
	LD   A,(FUDLR)
	LD   (TempFUDLR),A
	AND  $03
	JP   PO,HasDir

	LD   A,(DE)			; PlayerDir
	AND  $01
	INC  A

HasDir:
	ADD  A,$03			; Add jump flag to PlayerDir
	LD   (DE),A
	LD   A,S_JUMP		; $01
	CALL JP_PlaySound
	POP  DE

UpdateJump:
	LD   A,B
	OR   A
	JR   Z,JumpNoLadder

	XOR  A
	LD   B,A
	PUSH DE
	CALL JP_CheckOnLadder
	POP  DE
	JR   C,PlayerUpOnLadder

JumpNoLadder:
	INC  DE
	LD   A,(JumpYIndex)
	ADD  A,$04
	LD   (JumpYIndex),A
	CALL GetSine
	ADD  A,A
	LD   C,A
	LD   A,(JumpStartY)
	ADD  A,$68
	SUB  C
	AND  $FE
	LD   (DE),A
	LD   A,(IsStabbing)
	OR   A
	JR   Z,label_6102
	DEC  A
	LD   (IsStabbing),A
	JR   NZ,label_6123

	INC  DE
	LD   A,(DE)
	CP   $09
	JR   C,label_60FF

	SUB  $06
	LD   (DE),A
label_60FF:
	DEC  DE
	JR   label_6123
label_6102:
	BIT  4,(IY+$25)			; LastFUDLR
	JR   NZ,label_6123

	BIT  4,(IY+$28)			; FUDLR
	JR   Z,label_6123

	LD   (IY+$22),$02			; IY + ISSTABBING
	CALL SetupKnife
	PUSH DE
	INC  DE
	LD   A,(DE)
	AND  $01
	ADD  A,$0A
	LD   (DE),A
	LD   A,S_STAB				; $08
	CALL JP_PlaySound
	POP  DE
label_6123:
	DEC  DE
	LD   A,(TempFUDLR)
	AND  $03
	JR   NZ,HasLR

	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlayerLeftRight:
	LD   A,(isSnappedToLadder)
	OR   A
	RET  NZ
	LD   A,C			; SFUDLR
	AND  $03
HasLR:
	ADD  A,A
	LD   HL,PlayerSpeedDir
	CALL AddHLA2
	LD   A,(DE)			; PlayerX
	ADD  A,(HL)
	INC  HL
	CP   $10			; left edge of play area
	RET  C
	CP   (IY+$3F)			; MaxPlayerX
	RET  NC
	CP   (IY+$36)			; FFB8 - ScrollBoundary
	JR   NC,AtScrollBoundary

	LD   (DE),A			; PlayerX
	LD   A,(isInAir)
	OR   A
	RET  NZ
	
	INC  DE
	INC  DE
	LD   A,(HL)			; Get direction
	OR   A
	RET  M
	
	LD   (DE),A			; Set PlayerDir if +ve direction
	LD   A,$06
	LD   (MoveAmountSinceScrollBoundary),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlayerStab:
	LD   A,(isSnappedToLadder)
	OR   A
	RET  NZ
	BIT  4,(IY+$25)
	RET  NZ
	INC  DE
	INC  DE
	LD   A,(DE)
	AND  $01
	ADD  A,$0A
	LD   (DE),A
	LD   (IY+$22),$02			; IY+ISSTABBING
	CALL SetupKnife
	LD   A,S_STAB				; $08
	JP   JP_PlaySound

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

AtScrollBoundary:
	LD   (IY+$12),$FF			; $ff94 - V_HasScrolled
	LD   B,$02
	LD   A,(MoveAmountSinceScrollBoundary)
	ADD  A,B
	LD   (MoveAmountSinceScrollBoundary),A
	AND  $06
	ADD  A,(IY+$36)			; +ScrollBoundary
	LD   C,A
	LD   A,(isInAir)
	OR   A
	JR   Z,NotInAir

	LD   C,(IY+$36)			; ScrollBoundary
	INC  DE
	INC  DE
	LD   A,(DE)			; PlayerDir
	LD   B,A
	DEC  DE
	DEC  DE

NotInAir:
	LD   A,C
	LD   (DE),A			; PlayerX
	INC  DE
	INC  DE
	LD   A,B
	LD   (DE),A			; PlayerDir
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlayerMoveTable:
	dw NoAction
	dw PlayerLeftRight
	dw PlayerLeftRight
	dw DUF
	dw PlayerDown
	dw PlayerDown
	dw PlayerDown
	dw PlayerDown
	dw PlayerUp
	dw PlayerUp
	dw PlayerUp
	dw PlayerUp
	dw DUF
	dw PlayerLeftRight
	dw PlayerLeftRight
	dw DUF
	dw PlayerStab
	dw PlayerStab
	dw PlayerStab
	dw DUF
	dw PlayerDownStab
	dw PlayerDownStab
	dw PlayerDownStab
	dw PlayerDownStab
	dw PlayerUp
	dw PlayerUp
	dw PlayerUp
	dw PlayerUp
	dw DUF
	dw PlayerStab
	dw PlayerStab
	dw DUF

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

GetSine:			; enters with A = index, returns sin(a) back in A (there are two of these identical functions!)
	LD   HL,SineTable
	ADD  A,L
	LD   L,A
	LD   A,H
	ADC  A,$00
	LD   H,A
	LD   A,(HL)
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TriggerEOL3Helicopters:
	LD   HL,$18C0
	LD   (BossBaddyX),HL
	LD   (data_A120_4),HL
	LD   H,$20
	LD   (BossBaddyX2),HL
	LD   (data_A126_4),HL
	LD   H,$30
	LD   (BossBaddyX3),HL
	LD   (data_A12C_4),HL
	LD   A,$03
	LD   (EOLBaddiesRemaining),A
	LD   B,A
	LD   IX,HelicopterMovementData
	LD   DE,$0006					; 6 bytes each
InitHeliLp:
	LD   (IX+$01),$FF				; set ydelta to -1
	LD   (IX+$04),$06				; set dir bits = 0000 0110
	ADD  IX,DE
	DJNZ InitHeliLp
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

EOL3_Boss:
	LD   A,(EOLBaddiesRemaining)
	OR   A
	RET  Z

	LD   A,(FrameToggle)
	CPL
	LD   (FrameToggle),A
	PUSH IY
	LD   HL,(PlayerX)			; set target as the Player's current position
	LD   (PlayerXYTarget),HL
	LD   IX,HelicopterMovementData
	LD   IY,BossBaddyX
	LD   B,$03			; three helicopters

HeliLoop:
	PUSH BC
	CALL UpdateBossBaddy
	POP  BC
	LD   DE,$0006			; 6 bytes per boss baddy structure
	ADD  IX,DE
	ADD  IY,DE
	DJNZ HeliLoop

	POP  IY
	DEC  (IY+$48)			; ffca - EOLBaddyCountdown
	JR   NZ,NoCountReset

	LD   A,(EOLBaddyCountdownTime)
	LD   (EOLBaddyCountdown),A
NoCountReset:
	LD   A,(PlayingSound)
	OR   A
	RET  NZ

	LD   A,S_HELICOPTER		; $06
	JP   JP_PlaySound

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CollideWithPlayerWeapons:
	LD   A,(IsStabbing)
	OR   A
	JR   Z,NotStabbing

	LD   A,(KnifeXNO)
	LD   L,A
	LD   H,$08
	LD   A,(IY+$00)
	ADD  A,$18
	LD   E,A
	LD   D,H
	CALL HitA2
	JR   C,NotStabbing

	LD   A,(KnifeYNO)
	INC  A
	LD   L,A
	LD   H,$02
	LD   A,(IY+$01)
	ADD  A,$08
	LD   E,A
	LD   D,$10
	CALL HitA2
	JR   NC,StartExplosion

NotStabbing:
	LD   A,(isShooting)
	CP   $04
	RET  NZ

	LD   HL,(GrenadeX)
	PUSH HL
	LD   H,$0A
	LD   A,(IY+$00)
	ADD  A,$08
	LD   E,A
	LD   D,$30
	CALL HitA2
	POP  HL
	RET  C

	LD   L,H
	LD   H,$08
	LD   A,(IY+$01)
	ADD  A,$08
	LD   E,A
	LD   D,$10
	CALL HitA2
	RET  C

StartExplosion:
	PUSH IX
	LD   IX,BaddyData6
	LD   (IX+TYP),$00				; TYP
	LD   (IX+GNO),G_EXPLOSION		; $1D			; GNO
	LD   A,(IY+$00)
	ADD  A,$10
	AND  $F8
	LD   (IX+$0A),A
	LD   A,(IY+$01)
	ADD  A,$04
	LD   (IX+$0B),A
	LD   A,$10
	LD   (ExplosionCounter),A
	LD   A,(EOLBaddiesRemaining)
	DEC  A
	LD   (EOLBaddiesRemaining),A
	JR   NZ,EnemiesRemain

	LD   A,$19						; all EOL enemies are dead - countdown to end of level
	LD   (EOLEndCountdown),A
EnemiesRemain:
	POP  IX
	LD   (IX+$04),$FF				; flag baddy dead in HelicopterMovementData
	LD   DE,$0202
	CALL JP_AddScore
	LD   A,S_EXPLOSION				; $09
	JP   JP_PlaySound

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

BossShoot:
	LD   A,(EOLBaddyCountdown)
	DEC  A
	RET  NZ

	CALL JP_FindSpareBullet
	RET  P

	LD   A,(IX+$04)			; get direction flags
	LD   C,$02
	SRL  A
	JR   C,label_630F
	
	INC  C
label_630F:
	LD   (HL),C				; gno
	INC  L
	LD   A,(IY+$00)			; boss x
	ADD  A,$1C
	LD   (HL),A				; xno
	INC  L
	LD   A,(IY+$01)			; boss y
	ADD  A,$10
	LD   (HL),A				; yno
	LD   A,S_SHOOTBULLET	;$03
	JP   JP_PlaySound

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateBossBaddy:
	LD   A,(IX+$04)			; bit 7 of direction bits = baddy is dead
	OR   A
	RET  M

	CALL BossShoot
	CALL CollideWithPlayerWeapons
	
	LD   DE,(PlayerXYTarget)			; E = xtarget, D = ytarget
	LD   BC,$3868
	LD   (PlayerXYTarget),BC
	LD   C,(IX+$04)			; C = direction bits
	LD   B,(IX+$00)			; B = xdelta
	LD   L,(IY+$00)
	LD   H,(IY+$01)
	CALL UpdateDelta
	LD   (IX+$00),B			; store xdelta
	LD   A,C
	AND  $03
	EX   AF,AF'			; 'AF just xdir bits
	LD   L,H			; L = Boss Baddy Y
	LD   E,D			; E = ytarget
	LD   B,(IX+$01)		; B = ydelta
	SRL  C				; C = move Ydir bits 2,3 to 1,0
	SRL  C
	CALL UpdateDelta
	LD   A,(IX+$03)
	ADD  A,B
	LD   (IX+$03),A		; ycount += ydelta
	LD   A,L			; A = boss baddy y
	CALL C,Move2Pixels
	CP   $18
	CALL C,FlipHeliDirection			; top edge?
	
	CP   $88
	CALL NC,FlipHeliDirection			; bottom edge?
	
	LD   (IY+$01),A			; store boss baddy y
	LD   (IX+$01),B			; store ydelta
	EX   AF,AF'				; AF = just xdir bits
	SLA  C
	SLA  C					; move ydir bits 0,1 back up to 2,3
	ADD  A,C				; add back in original xdir bits to 0,1
	LD   (IX+$04),A
	LD   A,(IX+$02)
	ADD  A,(IX+$00)
	LD   (IX+$02),A			; xcount += xdelta
	RET  NC

	LD   C,(IX+$04)			; C = direction bits
	LD   A,(IY+$00)			; boss baddy x
	CALL Move2Pixels
	CP   $04				; left edge?
	RET  C

	CP   $C2				; right edge?
	RET  NC

	LD   (IY+$00),A			; store boss baddy x
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

FlipHeliDirection:
	PUSH AF
	LD   A,C
	XOR  $03
	LD   C,A
	POP  AF
	LD   B,$FF
	SUB  $02
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Move2Pixels:			; adds +/- 2 to A depending on bit 0 of C
	ADD  A,$02
	BIT  0,C
	RET  NZ

	SUB  $04
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateDelta:			; C = dir bits, L = x or y, E = xtarget or ytarget, B = xdelta or ydelta
	LD   A,L
	CP   E
	LD   A,B
	JR   C,TargetSmaller

	BIT  0,C
	JR   Z,AddConstant

	JR   SubConstant

TargetSmaller:
	BIT  1,C
	JR   Z,AddConstant

SubConstant:
	SUB  (IX+$05)			; subtract IX+5 constant from input delta
	LD   B,A
	RET  NC
	
	LD   B,$01			; delta = +1
	LD   A,C
	XOR  $03
	LD   C,A			; flip direction bits
	RET 

AddConstant:
	ADD  A,(IX+$05)			; add IX+5 constant from input delta
	LD   B,A
	RET  NC
	LD   B,$FF			; delta = -1
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

HitA2:			; why are there two of these?
	LD   A,H
	ADD  A,L
	CP   E
	RET  C
	LD   A,D
	ADD  A,E
	CP   L
	RET

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Sprint:
	EX   (SP),HL
	CALL Print
	EX   (SP),HL
	RET 

Print:
	LD   A,(HL)
	INC  HL
	CP   $FF
	RET  Z

	EXX 
	LD   HL,Print

PrintIntercept:
	PUSH HL
	CP   $20
	JR   NC,PR_Chars
	ADD  A,A
	LD   HL,CONT_TAB			; control code function table
	CALL AddHLA2
	JP   JPIndex2

PR_Chars:
	EXX 
PRChar:
	PUSH HL
	EX   AF,AF'
	LD   DE,(Variables)
	CALL Lowad
	EX   AF,AF'
	CALL ChrAddr
	BIT  1,(IY+$03)			; FF85 - V_Sysflag
	JR   NZ,Expand

	LD   B,$08
PR_LOOP:
	LD   A,(DE)
MODE0:
	NOP 
	LD   (HL),A
	INC  H
	INC  DE
	DJNZ PR_LOOP

	DEC  H
	CALL Colour
MoveOn:
	POP  HL
	LD   A,(V_Direct)
	JP   MOVE_CUR

Expand:
	LD   C,$08
Expand2:
	LD   B,(IY+$08)			; FF8A - V_High
Expand0:
	CALL Colour
	LD   A,(DE)

MODE1:
	NOP 
	LD   (HL),A
	CALL DownLine
	DJNZ Expand0
	INC  DE
	DEC  C
	JR   NZ,Expand2
	JR   MoveOn

Colour:
	LD   A,(V_Attr)
	INC  A
	RET  Z
	PUSH HL
	DEC  A
	EX   AF,AF'
	CALL PixToAttr
	EX   AF,AF'
	LD   (HL),A
	POP  HL
	RET 

Coords:
	EXX 
	CALL DEFromHL2
	LD   (Variables),DE
	RET 

Direction:
	EXX 
	LD   A,(HL)
	INC  HL
	LD   (V_Direct),A
	RET 

PR_MODE:
	EXX 
	LD   A,(HL)
	INC  HL
	EXX 
	CP   $04
	JR   NC,MODESKIP
	LD   HL,MODE_TAB
	CALL AddHLA2
	LD   A,(HL)
	LD   (MODE0),A
	LD   (MODE1),A
	EXX 
	RET 

MODESKIP:
	SUB  $04
	ADD  A,A
	LD   HL,CONT_TAB2
	CALL AddHLA2
	JP   JPIndex2

SET_EXPD:
	EXX 
	LD   A,(HL)
	INC  HL
	LD   (V_High),A
	SET  1,(IY+$03)			;FF85 - V_Sysflag
	RET 

RESET_PRINT:
	EXX 
	PUSH HL
	CALL Sprint
	db MODE, NORM
	db DIRECT, RI
	db PEN, $FF
	db TAB
	db $00
	db $00
	db $00
	db $00
	db CHR
	dw gfx_Charset			;$7D00
	db FIN

	POP  HL
	RES  1,(IY+$03)			; V_Sysflag
	RET 

TABULATE:
	EXX 
	LD   A,(HL)
	LD   (V_TabXPos),A
	INC  HL
	RET 

REPEAT:
	EXX 
	LD   A,(HL)
	INC  HL
	LD   B,(HL)
	INC  HL

REPEATL:
	PUSH AF
	PUSH BC
	PUSH HL
	CALL PRChar
	POP  HL
	POP  BC
	POP  AF
	DJNZ REPEATL
	RET 

PEN_INK:
	EXX 
	LD   A,(HL)
	INC  HL
	LD   (V_Attr),A
	RET 

CHAR_BASE:
	EXX 
	CALL DEFromHL2
	LD   (V_Chars),DE
	RET 

JSR_RUTS:
	EXX 
	PUSH IX
	LD   A,(HL)
	INC  HL
	PUSH HL
	LD   H,(HL)
	LD   L,A
	POP  IX
	INC  IX
	CALL JumpHL
	PUSH IX
	POP  HL
	POP  IX
	RET 

JSR_STRG:
	EXX 
	LD   A,(HL)
	INC  HL
	PUSH HL
	LD   H,(HL)
	LD   L,A
	CALL Print
	POP  HL
	INC  HL
	RET 

CLEARSCR:
	LD   BC,$17FF
	LD   HL,$4000

CLEARMEM:
	LD   E,$01
	LD   D,H
	LD   (HL),L
	LDIR
	EXX 
	RET 

CLEARATTR:
	LD   HL,$5800
	LD   BC,$02FF
	JR   CLEARMEM

CARRIAGERETURN:
	EXX 
	LD   A,(V_TabXPos)
	LD   (V_ScrnX),A
	INC  (IY+$01)		; SCRNY
	RET 

BACKSPC:
	EXX 
	LD   A,(HL)
	INC  HL

MOVE_CUR:
	EXX 
	ADD  A,A
	LD   HL,DIR_TAB
	CALL AddHLA2
	LD   DE,(V_ScrnX)
	LD   A,E
	ADD  A,(HL)
	AND  $1F
	LD   E,A
	INC  HL
	LD   A,D
	ADD  A,(HL)
	LD   D,A
	LD   (V_ScrnX),DE
	EXX 
	RET 

LOOP_IT:
	EXX 
	LD   B,(HL)
	INC  HL
	LD   E,(HL)
	INC  HL
	LD   D,(HL)
	INC  HL
	PUSH HL
	EX   DE,HL
	
NextLoop:
	PUSH BC
	PUSH HL

LOOP_TEST:
	LD   A,(HL)
	INC  HL
	CP   LOOP			;$0F
	JR   Z,HitLoop

	EXX 
	LD   HL,LOOP_TEST
	JP   PrintIntercept

HitLoop:
	POP  HL
	POP  BC
	DJNZ NextLoop
	POP  HL
	RET 

TAB_TO_X:
	EXX 
	LD   A,(V_ScrnX)
	LD   (V_TabXPos),A
	RET 

X_TO_NUM:
	EXX 
	LD   A,(HL)
	INC  HL
	LD   (V_ScrnX),A
	RET 

Y_TO_NUM:
	EXX 
	LD   A,(HL)
	INC  HL
	LD   (V_ScrnY),A
	RET 

ChrAddr:
	LD   DE,(V_Chars)

CalcTileAddr:			; tile num in A, tile base address in DE
	PUSH HL
	LD   L,A
	LD   H,$00
	ADD  HL,HL
	ADD  HL,HL
	ADD  HL,HL
	ADD  HL,DE
	EX   DE,HL
	POP  HL
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Lowad:
	LD   A,D
	RRCA
	RRCA
	RRCA
	AND  $E0
	OR   E
	LD   L,A
	LD   A,D
	AND  $18
	OR   $40
	LD   H,A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

AttrAddr:
	EX   AF,AF'
	LD   A,H
	RRCA
	RRCA
	RRCA
	LD   H,A
	AND  $E0
	OR   L
	LD   L,A
	LD   A,H
	AND  $1F
	OR   $58
	LD   H,A
	EX   AF,AF'
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PixToAttr:
	LD   A,H
	RRCA
	RRCA
	RRCA
	AND  $03
	OR   $58
	LD   H,A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DownLine:
	INC  H
	LD   A,H
	AND  $07
	RET  NZ
	LD   A,L
	ADD  A,$20
	LD   L,A
	RET  C
	LD   A,H
	SUB  $08
	LD   H,A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

FillAttrBlocks:
	CALL HLBCFromIX
	INC  IX
	LD   A,L
	CP   $FF
	RET  Z

	LD   A,(IX+$03)
	PUSH IX
	CALL FillAttrBlock
	POP  IX
	LD   DE,$0004
	ADD  IX,DE
	JR   FillAttrBlocks

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

FillAttrBlock:
	LD   E,L
	LD   D,H
	CALL AttrAddr
	EX   AF,AF'
	LD   A,C
	SUB  E
	LD   C,A
	LD   A,B
	SUB  D
	LD   D,A
	EX   AF,AF'
	INC  C
	INC  D
NextRow:
	PUSH HL
	LD   B,C

FillRow:
	LD   (HL),A
	INC  HL
	DJNZ FillRow

	LD   B,D
	LD   DE,$0020
	POP  HL
	ADD  HL,DE
	LD   D,B
	DEC  D
	JR   NZ,NextRow

	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

WaitBC_2:
	HALT
	DJNZ WaitBC_2
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

AddHLA2:
	ADD  A,L
	LD   L,A
	RET  NC

	INC  H
DUF:
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

HLFromHL2:
	LD   A,(HL)
	INC  HL
	LD   H,(HL)
	LD   L,A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DEFromHL2:
	LD   E,(HL)
	INC  HL
	LD   D,(HL)
	INC  HL
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

JPIndex2:
	LD   A,(HL)
	INC  HL
	LD   H,(HL)
	LD   L,A

JumpHL:
	JP   (HL)

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

HLBCFromIX:
	LD   L,(IX+$00)
	LD   H,(IX+$01)
	LD   C,(IX+$02)
	LD   B,(IX+$03)
	RET 

;	db $DD
;	db $6E
;	db $00
;	db $DD
;	db $66
;	db $01
;	db $DD
;	db $5E
;	db $02
;	db $DD
;	db $56
;	db $03
;	db $C9

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

WipeLevelOn:
	LD   A,(LevelNumber)
	AND  $03
	ADD  A,A
	LD   HL,SkyFloorTiles
	CALL AddHLA2
	LD   A,(HL)
	LD   (SkyTile+1),A
	INC  HL
	LD   A,(HL)
	LD   (GroundTile+1),A
	LD   HL,(MapX)
	LD   DE,$0070
	ADD  HL,DE
	LD   (MapX),HL

StartWipe:
	LD   HL,$5881			; attribute line 1x,4y
	LD   (AttrLineAddr),HL
	LD   HL,BackBuffer+2		; backbuffer to draw into
	LD   B,$1C				; 28 columns

NextColumn:
	PUSH BC
	PUSH HL
	CALL DecodeMapColumn
	POP  HL
	PUSH HL
	CALL DrawMapColumn
	EI  
	HALT
	CALL DrawMapAttrColumn
	CALL JP_DumpBackBuffer
	POP  HL
	POP  BC
	INC  L
	DJNZ NextColumn
	JP   DoColumnDecode

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawMapAttrColumn:
	LD   DE,MapAttrColumn
	LD   BC,$0020			; 32 bytes to next attr line
	LD   HL,(AttrLineAddr)
	INC  HL
	LD   (AttrLineAddr),HL
SkyTile:
	LD   A,$68
	EX   AF,AF'

	LD   A,$09			; sky 9 chars high
SkyLoop:
	EX   AF,AF'
	LD   (HL),A
	ADD  HL,BC
	EX   AF,AF'
	DEC  A
	JR   NZ,SkyLoop

	LD   A,$08			; map 8 chars high
MapLoop:
	EX   AF,AF'
	LD   A,(DE)
	LD   (HL),A
	INC  DE
	ADD  HL,BC
	EX   AF,AF'
	DEC  A
	JR   NZ,MapLoop

GroundTile:
	LD   (HL),$44		; ground 1 tile high, tile number $44
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

SkyFloorTiles:
	db $68, $44
	db $68, $41 
	db $68, $46
	db $70, $05

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DecodeMap:
	LD   A,(ScrollPixelCounter)		; only after we've scrolled 8 pixels
	AND  $07
	RET  NZ

	LD   A,(V_HasScrolled)			; and we've shunted the screen by 1 character
	OR   A
	RET  Z

DoColumnDecode:
	CALL DecodeMapColumn
	LD   HL,BackBuffer+30

DrawMapColumn:
	EXX 
	LD   HL,MapTileColumn
	LD   B,$08					; 8 tiles high

NextTile:
	LD   A,(HL)					; tile number from map column
	INC  HL
	EXX 
	LD   DE,(MapTileAddress)	; de = tile gfx base address
	CALL CalcTileAddr			
	LD   BC,$0020				; 32 bytes to next screen line for the tile
	LD   A,(DE)					; decode 8 bytes of tile
	LD   (HL),A
	ADD  HL,BC
	INC  E
	LD   A,(DE)
	LD   (HL),A
	ADD  HL,BC
	INC  DE
	LD   A,(DE)
	LD   (HL),A
	ADD  HL,BC
	INC  E
	LD   A,(DE)
	LD   (HL),A
	ADD  HL,BC
	INC  DE
	LD   A,(DE)
	LD   (HL),A
	ADD  HL,BC
	INC  E
	LD   A,(DE)
	LD   (HL),A
	ADD  HL,BC
	INC  DE
	LD   A,(DE)
	LD   (HL),A
	ADD  HL,BC
	INC  E
	LD   A,(DE)
	LD   (HL),A
	ADD  HL,BC
	EXX 
	DJNZ NextTile

	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
; decodes 8 tile character values into the column buffer (expanded to 64 pixels high when drawn) 
; also decodes attributes into MapAttrColumn and MapAttrColumn2
;

DecodeMapColumn:			
	LD   IX,WorkingMapDataRow1			; decode4 tiles from WorkingMapDataRow1's four words of data
	LD   BC,MapTileColumn
	CALL Decode4
	LD   IX,WorkingMapDataRow2			; decode4 tiles from WorkingMapDataRow2's four words of data

Decode4:
	LD   (IY+$2E),$04					; $FFB0 - VertTileCount

	LD   L,(IX+$00)		
	LD   H,(IX+$01)		
GetNextTile:		
	LD   A,(HL)		
	INC  HL		
	CP   $20							; tile values < $20 call special decode routines
	JR   C,TileDecode		

	LD   (BC),A		
	INC  BC		
	DEC  (IY+$2E)						; $FFB0 - VertTileCount
	JR   NZ,GetNextTile		

	LD   (IX+$00),L						; Update map addr
	LD   (IX+$01),H		
	RET 		

TileDecode:								; tile number that triggers some specific block decode code
	EXX 
	ADD  A,A
	LD   HL,TileDecodeJumpTable
	CALL AddHLA2
	CALL JPIndex2
	JR   GetNextTile

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TileDecode_1:
	POP  HL
	POP  HL
	JP   JP_InitLevel

TileDecode_2:
	EXX 
	LD   E,(IX+$04)			; attribute decode
	LD   D,(IX+$05)
	PUSH BC
	LDI
	LDI
	LDI
	LDI
	POP  BC
	RET 

TileDecode_3:
	EXX 
	LD   A,(HL)
	EX   AF,AF'
	INC  HL
	EX   DE,HL
	LD   L,(IX+$04)			; attribute decode
	LD   H,(IX+$05)
	LD   A,(VertTileCount)
	DEC  A
	XOR  $03
	CALL AddHLA2
	EX   AF,AF'
	LD   (HL),A				; write attribute 
	EX   DE,HL
	RET 

TileDecode_12:
	EXX 
	LD   A,(HL)				; get attribute 
	INC  HL
	EX   DE,HL
	LD   L,(IX+$04)			; attribute decode
	LD   H,(IX+$05)
	PUSH BC
	LD   B,$04				; decode a run of 4 of the given attribute
.AttrLoop:
	LD   (HL),A
	INC  HL
	DJNZ .AttrLoop
	POP  BC
	EX   DE,HL
	RET 

TileDecode_7:
	POP  HL
	EXX 
	LD   A,$2B			; a run of tile $2B
DecodeRun:
	LD   (BC),A
	INC  BC
	DEC  (IY+$2E)		; $FFB0 - VertTileCount
	JR   NZ,DecodeRun

	LD   (IX+$00),L
	LD   (IX+$01),H
	RET 

TileDecode_10:
	POP  HL
	EXX 
	LD   A,(HL)			; a run of tile A
	INC  HL
	JR   DecodeRun

TileDecode_4:
	EXX 
	LD   A,(HL)			; this byte represents a block of map
	ADD  A,A
	INC  HL
	EX   DE,HL
	CALL TileDecode_6a
	LD   HL,BlockAddressLookup
	CALL AddHLA2
	JP   HLFromHL2			; HL = (HL) and return from caller

TileDecode_5:
	EXX 

TileDecode_5a:
	LD   L,(IX+$02)
	LD   H,(IX+$03)
	DEC  HL
	LD   D,(HL)
	DEC  HL
	LD   E,(HL)
	LD   (IX+$02),L
	LD   (IX+$03),H
	EX   DE,HL
	RET 

TileDecode_6:
	EXX 
	LD   E,(HL)
	INC  HL
	LD   D,(HL)
	INC  HL
	EX   DE,HL

TileDecode_6a:
	PUSH HL
	LD   L,(IX+$02)
	LD   H,(IX+$03)
	LD   (HL),E
	INC  HL
	LD   (HL),D
	INC  HL
	LD   (IX+$02),L
	LD   (IX+$03),H
	POP  HL
	RET 

TileDecode_SetWorkingMapTiles:
	LD   HL,gfx_MapTiles
	LD   A,(WhichTileset)
	CPL
	LD   (WhichTileset),A
	OR   A
	JR   Z,SetTileSet

	LD   HL,gfx_CaptiveMapTiles
SetTileSet:
	LD   (MapTileAddress),HL
	EXX 
	RET 

TileDecode_8:
	EXX 
	LD   A,(HL)
	INC  HL
	EXX 
	LD   L,(IX+$06)
	LD   H,(IX+$07)
	LD   (HL),A
	INC  HL
	LD   (IX+$06),L
	LD   (IX+$07),H
	EXX 
	LD   E,L
	LD   D,H
	JR   TileDecode_6a

TileDecode_9:
	LD   L,(IX+$06)
	LD   H,(IX+$07)
	DEC  HL
	DEC  (HL)
	JR   Z,label_67D7
	EXX 
	CALL TileDecode_5a
	LD   E,L
	LD   D,H
	JR   TileDecode_6a

label_67D7:
	LD   (IX+$06),L
	LD   (IX+$07),H
	CALL TileDecode_5a
	EXX 
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

MODE_TAB:			; used by sprint
	db $00 	;NOP 
	db $AE	;XOR (HL)
	db $B6	;OR (HL)
	db $2F	;CPL

CONT_TAB2:
	dw SET_EXPD
	dw RESET_PRINT

DIR_TAB:
	db $00
	db $FF
	db $01
	db $FF
	db $01
	db $00
	db $01
	db $01
	db $00
	db $01
	db $FF
	db $01
	db $FF
	db $00
	db $FF
	db $FF

CONT_TAB:
	dw Coords
	dw Direction
	dw PR_MODE
	dw TABULATE
	dw REPEAT
	dw PEN_INK
	dw CHAR_BASE
	dw $0000
	dw JSR_RUTS
	dw JSR_STRG
	dw CLEARSCR
	dw CLEARATTR
	dw $0000
	dw CARRIAGERETURN
	dw BACKSPC
	dw LOOP_IT
	dw $0000
	dw TAB_TO_X
	dw X_TO_NUM
	dw Y_TO_NUM
	dw $0000

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TileDecodeJumpTable:
	dw TileDecode_1
	dw TileDecode_2
	dw TileDecode_3
	dw TileDecode_4
	dw TileDecode_5
	dw TileDecode_6
	dw TileDecode_7
	dw TileDecode_8
	dw TileDecode_9
	dw TileDecode_10
	dw TileDecode_SetWorkingMapTiles
	dw TileDecode_12

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; Table of addresses of blocks of tiles to bulid the game map from
;

BlockAddressLookup:
	dw operand_6985
	dw operand_693C
	dw operand_6947
	dw operand_69B8
	dw operand_69D3
	dw operand_697C
	dw operand_692A
	dw operand_692D
	dw operand_6932
	dw operand_6937
	dw operand_69F2
	dw operand_6A70
	dw operand_6A7F
	dw operand_6A93
	dw operand_6AA6
	dw operand_6C63
	dw operand_6AB3
	dw operand_6AF6
	dw operand_6B23
	dw operand_6B39
	dw operand_6B44
	dw operand_6B5B
	dw operand_6B75
	dw operand_6BB5
	dw operand_6C04
	dw operand_6C12
	dw operand_6C21
	dw operand_6C3F
	dw operand_6C2B
	dw operand_6C4C
	dw operand_6C7A
	dw operand_6C8A
	dw data_6890
	dw data_68C2
	dw data_68DB
	dw data_68E4
	dw data_6903
	dw operand_6A20
	dw operand_6A57
	dw operand_6C9B
	dw operand_6CBE
	dw operand_6CFA

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; Game Map data
;

	org $6890

data_6890:
	db $0B
	db $78
	db $75
	db $78
	db $79
	db $78
	db $76
	db $7A
	db $7C
	db $7E
	db $77
	db $7B
	db $7D
	db $7F
	db $3C
	db $3C
	db $3C
	db $3C
	db $3D
	db $3D
	db $3D
	db $3D
	db $76
	db $80
	db $2B
	db $2B
	db $77
	db $81
	db $82
	db $82
	db $76
	db $83
	db $20
	db $20
	db $77
	db $7A
	db $7C
	db $7E
	db $76
	db $7B
	db $7D
	db $7F
	db $77
	db $20
	db $84
	db $20
	db $76
	db $09
	db $20
	db $04

data_68C2:
	db $01
	db $70
	db $70
	db $38
	db $38
	db $20
	db $20
	db $75
	db $78
	db $20
	db $20
	db $76
	db $20
	db $07
	db $03
	db $20
	db $20
	db $77
	db $20
	db $20
	db $20
	db $76
	db $20
	db $08
	db $04

data_68DB:
	db $0B
	db $38
	db $09
	db $78
	db $07
	db $1C
	db $20
	db $08
	db $04

data_68E4:
	db $0B
	db $38
	db $75
	db $09
	db $78
	db $76
	db $09
	db $20
	db $77
	db $86
	db $8A
	db $8A
	db $76
	db $87
	db $8B
	db $8B
	db $77
	db $88
	db $8C
	db $8C
	db $76
	db $89
	db $8D
	db $8D
	db $77
	db $09
	db $20
	db $76
	db $09
	db $20
	db $04

data_6903:
	db $0B
	db $50
	db $09
	db $3C
	db $09
	db $3D
	db $8E
	db $09
	db $85
	db $8F
	db $09
	db $85
	db $90
	db $09
	db $85
	db $91
	db $09
	db $85
	db $07
	db $10
	db $85
	db $08
	db $8E
	db $09
	db $85
	db $8F
	db $09
	db $85
	db $90
	db $09
	db $85
	db $91
	db $09
	db $85
	db $07
	db $08
	db $85
	db $08
	db $04

operand_692A:
	db $09
	db $20
	db $04

operand_692D:
	db $07
	db $08
	db $20
	db $08

label_6931:
	db $04

operand_6932:
	db $07
	db $10
	db $20
	db $08
	db $04

operand_6937:
	db $07
	db $20
	db $20
	db $08
	db $04

operand_693C:
	db $0B
	db $50
	db $09
	db $25
	db $09
	db $26
	db $07
	db $48
	db $EB
	db $08
	db $04

operand_6947:
	db $01
	db $78
	db $38
	db $38
	db $38
	db $EC
	db $EE
	db $EB
	db $EB
	db $09
	db $90
	db $09
	db $91
	db $ED
	db $EF
	db $06
	db $01
	db $78
	db $38
	db $28
	db $28
	db $EC
	db $EE
	db $20
	db $20
	db $ED
	db $EF
	db $20
	db $28
	db $EC
	db $EE
	db $27
	db $29
	db $ED
	db $EF
	db $20
	db $2A
	db $EC
	db $EE
	db $20
	db $28
	db $ED
	db $EF
	db $27
	db $29
	db $EC
	db $EE
	db $20
	db $2A
	db $ED
	db $EF
	db $06
	db $04

operand_697C:
	db $20
	db $4E
	db $4F
	db $50
	db $20
	db $4E
	db $4F
	db $50
	db $04

operand_6985:
	db $0B
	db $68
	db $20
	db $20
	db $2C
	db $32
	db $2C
	db $32
	db $3B
	db $42
	db $2D
	db $33
	db $3C
	db $43
	db $2E
	db $34
	db $3D
	db $44
	db $2F
	db $35
	db $3E
	db $45
	db $F1
	db $36
	db $3F
	db $46
	db $F1
	db $37
	db $40
	db $47
	db $F1
	db $33
	db $3C
	db $43
	db $F1
	db $38
	db $3D
	db $44
	db $30
	db $39
	db $3E
	db $45
	db $31
	db $3A
	db $41
	db $48
	db $20
	db $20
	db $31
	db $3A
	db $04

operand_69B8:
	db $0B
	db $68
	db $20
	db $20
	db $55
	db $5B
	db $20
	db $20
	db $56
	db $5C
	db $51
	db $53
	db $57
	db $5D
	db $52
	db $54
	db $58
	db $5E
	db $20
	db $20
	db $59
	db $5F
	db $20
	db $20
	db $5A
	db $60
	db $04

operand_69D3:
	db $0B
	db $68
	db $20
	db $65
	db $6B
	db $2B
	db $61
	db $66
	db $6C
	db $02
	db $78
	db $4D
	db $62
	db $67
	db $6D
	db $4D
	db $63
	db $68
	db $6E
	db $4D
	db $64
	db $69
	db $6F
	db $4D
	db $20
	db $6A
	db $70
	db $2B
	db $0B
	db $68
	db $04

operand_69F2:
	db $01
	db $68
	db $68
	db $68
	db $78
	db $20
	db $79
	db $7F
	db $84
	db $71
	db $20
	db $80
	db $85
	db $72
	db $20
	db $81
	db $85
	db $73
	db $7A
	db $2B
	db $85
	db $74
	db $7B
	db $2B
	db $85
	db $75
	db $7C
	db $2B
	db $84
	db $76
	db $7D
	db $2B
	db $85
	db $77
	db $20
	db $82
	db $85
	db $78
	db $20
	db $7B
	db $85
	db $20
	db $7E
	db $83
	db $85
	db $04

operand_6A20:
	db $0B
	db $68
	db $20
	db $79
	db $7F
	db $7F
	db $71
	db $09
	db $20
	db $72
	db $09
	db $20
	db $73
	db $20
	db $81
	db $2B
	db $74
	db $20
	db $2B
	db $2B
	db $F4
	db $7A
	db $2B
	db $2B
	db $F4
	db $7B
	db $2B
	db $2B
	db $F4
	db $7C
	db $2B
	db $2B
	db $F4
	db $7D
	db $2B
	db $2B
	db $75
	db $20
	db $2B
	db $2B
	db $76
	db $20
	db $82
	db $2B
	db $77
	db $09
	db $20
	db $78
	db $09
	db $20
	db $20
	db $7E
	db $83
	db $83
	db $04

operand_6A57:
	db $0B
	db $28
	db $F2
	db $09
	db $7F
	db $09
	db $90
	db $09
	db $91
	db $07
	db $08
	db $F3
	db $09
	db $2B
	db $08
	db $F2
	db $09
	db $20
	db $F2
	db $09
	db $20
	db $F2
	db $09
	db $83
	db $04

operand_6A70:
	db $01
	db $38
	db $78
	db $78
	db $78
	db $8F
	db $09
	db $87
	db $07
	db $07
	db $86
	db $09
	db $88
	db $08
	db $04

operand_6A7F:
	db $0B
	db $78
	db $09
	db $87
	db $88
	db $89
	db $8C
	db $88
	db $88
	db $8A
	db $8D
	db $88
	db $88
	db $8B
	db $8E
	db $07
	db $11
	db $88
	db $08
	db $04

operand_6A93:
	db $01
	db $38
	db $78
	db $78
	db $78
	db $8F
	db $09
	db $87
	db $09
	db $90
	db $09
	db $91
	db $07
	db $05
	db $86
	db $09
	db $88
	db $08
	db $04

operand_6AA6:
	db $0B
	db $78
	db $09
	db $87
	db $09
	db $90
	db $09
	db $91
	db $07
	db $14
	db $88
	db $08
	db $04

operand_6AB3:
	db $01
	db $70
	db $70
	db $70
	db $38
	db $20
	db $20
	db $92
	db $99
	db $20
	db $92
	db $96
	db $96
	db $92
	db $96
	db $02
	db $38
	db $96
	db $96
	db $93
	db $02
	db $38
	db $96
	db $96
	db $96
	db $02
	db $38
	db $94
	db $09
	db $96
	db $93
	db $09
	db $96
	db $94
	db $09
	db $97
	db $93
	db $09
	db $98
	db $93
	db $09
	db $96
	db $94
	db $09
	db $96
	db $93
	db $09
	db $96
	db $02
	db $70
	db $95
	db $96
	db $96
	db $96
	db $20
	db $02
	db $70
	db $95
	db $96
	db $96
	db $20
	db $20
	db $02
	db $70
	db $95
	db $9A
	db $04

operand_6AF6:
	db $0B
	db $38
	db $09
	db $99
	db $09
	db $97
	db $09
	db $98
	db $9B
	db $09
	db $A2
	db $9C
	db $A3
	db $AA
	db $B0
	db $9D
	db $A4
	db $AB
	db $B1
	db $9E
	db $A5
	db $AC
	db $B2
	db $9F
	db $A6
	db $AD
	db $B3
	db $9D
	db $A7
	db $AE
	db $B4
	db $A0
	db $A8
	db $AF
	db $B5
	db $A1
	db $09
	db $A9
	db $09
	db $96
	db $09
	db $96
	db $09
	db $9A
	db $04

operand_6B23:
	db $06
	db $0B
	db $38
	db $07
	db $02
	db $B6
	db $B8
	db $B8
	db $B9
	db $08
	db $07
	db $04
	db $B6
	db $B8
	db $B8
	db $B9
	db $08
	db $B7
	db $B8
	db $B8
	db $BA
	db $04

operand_6B39:
	db $06
	db $0B
	db $38
	db $09
	db $BB
	db $09
	db $BC
	db $05
	db $2D
	db $6B
	db $04

operand_6B44:
	db $0B
	db $68
	db $09
	db $20
	db $09
	db $BD
	db $0B
	db $70
	db $09
	db $BE
	db $09
	db $BF
	db $09
	db $C0
	db $09
	db $C1
	db $09
	db $C2
	db $0B
	db $68
	db $09
	db $20
	db $04

operand_6B5B:
	db $06
	db $01
	db $30
	db $38
	db $78
	db $78
	db $F2
	db $09
	db $C3
	db $F2
	db $09
	db $88
	db $F2
	db $09
	db $C4
	db $F2
	db $09
	db $C3
	db $F2
	db $09
	db $88
	db $F2
	db $09
	db $C4
	db $06
	db $04

operand_6B75:
	db $0B
	db $68
	db $20
	db $2C
	db $2E
	db $31
	db $20
	db $2D
	db $2F
	db $32
	db $20
	db $20
	db $30
	db $37
	db $07
	db $02
	db $20
	db $20
	db $30
	db $38
	db $08
	db $20
	db $33
	db $34
	db $35
	db $20
	db $20
	db $30
	db $38
	db $20
	db $20
	db $30
	db $37
	db $07
	db $02
	db $20
	db $20
	db $30
	db $38
	db $08
	db $20
	db $33
	db $34
	db $35
	db $20
	db $20
	db $30
	db $37
	db $20
	db $20
	db $30
	db $39
	db $07
	db $03
	db $20
	db $20
	db $30
	db $20
	db $08
	db $20
	db $20
	db $36
	db $20
	db $04

operand_6BB5:
	db $0B
	db $68
	db $20
	db $20
	db $4C
	db $20
	db $3A
	db $2B
	db $4D
	db $50
	db $01
	db $60
	db $60
	db $28
	db $68
	db $3B
	db $48
	db $4E
	db $51
	db $3C
	db $3C
	db $3C
	db $52
	db $3D
	db $3D
	db $3D
	db $50
	db $3E
	db $48
	db $4E
	db $51
	db $2B
	db $49
	db $4F
	db $52
	db $02
	db $68
	db $35
	db $47
	db $4D
	db $50
	db $40
	db $48
	db $4E
	db $51
	db $41
	db $49
	db $4F
	db $52
	db $07
	db $02
	db $42
	db $3B
	db $53
	db $54
	db $08
	db $43
	db $47
	db $4D
	db $50
	db $44
	db $4A
	db $4E
	db $51
	db $45
	db $4B
	db $4F
	db $52
	db $46
	db $2B
	db $53
	db $54
	db $0B
	db $68
	db $20
	db $20
	db $55
	db $20
	db $04

operand_6C04:
	db $0B
	db $78
	db $07
	db $02
	db $25
	db $27
	db $28
	db $27
	db $26
	db $28
	db $27
	db $28
	db $08
	db $04

operand_6C12:
	db $0B
	db $78
	db $25
	db $27
	db $28
	db $27
	db $09
	db $29
	db $09
	db $2A
	db $26
	db $28
	db $27
	db $28
	db $04

operand_6C21:
	db $07
	db $0F
	db $20
	db $08
	db $21
	db $20
	db $20
	db $21
	db $22
	db $04

operand_6C2B:
	db $20
	db $20
	db $21
	db $2B
	db $21
	db $22
	db $23
	db $02
	db $38
	db $25
	db $21
	db $22
	db $24
	db $26
	db $22
	db $23
	db $24
	db $25
	db $06
	db $04

operand_6C3F:
	db $20
	db $21
	db $22
	db $23
	db $20
	db $20
	db $20
	db $21
	db $07
	db $0C
	db $20
	db $08
	db $04

operand_6C4C:
	db $06
	db $01
	db $68
	db $68
	db $68
	db $38
	db $22
	db $23
	db $24
	db $25
	db $20
	db $21
	db $22
	db $26
	db $21
	db $22
	db $22
	db $25
	db $20
	db $20
	db $21
	db $2B
	db $04

operand_6C63:
	db $06
	db $01
	db $70
	db $70
	db $70
	db $38
	db $22
	db $23
	db $24
	db $25
	db $20
	db $21
	db $22
	db $26
	db $21
	db $22
	db $22
	db $25
	db $20
	db $20
	db $21
	db $2B
	db $04

operand_6C7A:
	db $20
	db $21
	db $22
	db $23
	db $07
	db $02
	db $21
	db $22
	db $23
	db $24
	db $08
	db $20
	db $21
	db $24
	db $24
	db $04

operand_6C8A:
	db $21
	db $22
	db $23
	db $24
	db $20
	db $20
	db $21
	db $23
	db $21
	db $23
	db $24
	db $24
	db $20
	db $21
	db $22
	db $23
	db $04

operand_6C9B:
	db $0B
	db $70
	db $20
	db $92
	db $20
	db $20
	db $20
	db $93
	db $94
	db $20
	db $20
	db $20
	db $95
	db $20
	db $20
	db $20
	db $96
	db $97
	db $20
	db $20
	db $20
	db $98
	db $20
	db $20
	db $20
	db $99
	db $20
	db $20
	db $20
	db $9A
	db $07
	db $24
	db $20
	db $08
	db $04

operand_6CBE:
	db $0B
	db $70
	db $09
	db $20
	db $20
	db $20
	db $20
	db $B0
	db $07
	db $03
	db $20
	db $20
	db $20
	db $B1
	db $08
	db $9B
	db $20
	db $20
	db $B1
	db $9C
	db $A4
	db $20
	db $B1
	db $9D
	db $A5
	db $20
	db $B1
	db $9E
	db $A6
	db $AC
	db $B2
	db $9F
	db $A7
	db $AD
	db $B3
	db $A0
	db $A8
	db $AE
	db $B4
	db $A1
	db $A9
	db $2B
	db $B5
	db $A2
	db $AA
	db $2B
	db $B5
	db $A3
	db $AB
	db $AF
	db $B6
	db $20
	db $20
	db $20
	db $B1
	db $20
	db $20
	db $20
	db $B7
	db $04

operand_6CFA:
	db $0B
	db $68
	db $0A
	db $20
	db $B8
	db $C2
	db $C7
	db $20
	db $B9
	db $C3
	db $C8
	db $07
	db $03
	db $20
	db $BA
	db $C4
	db $C9
	db $08
	db $20
	db $BB
	db $C4
	db $C9
	db $20
	db $BC
	db $C4
	db $C9
	db $20
	db $BD
	db $C4
	db $C9
	db $20
	db $BE
	db $C4
	db $C9
	db $20
	db $BF
	db $C4
	db $C9
	db $20
	db $C0
	db $C5
	db $CA
	db $20
	db $BF
	db $C6
	db $CB
	db $07
	db $02
	db $20
	db $BF
	db $20
	db $20
	db $08
	db $20
	db $C1
	db $20
	db $20
	db $0A
	db $04

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawCaptives:
	LD   HL,CaptivesMap_Row1
	LD   (MapDataRow1),HL
	LD   HL,CaptivesMap_Row2
	CALL SetMapData

	LD   HL,gfx_MapTiles
	LD   (data_7C82),HL
	XOR  A
	LD   (SkyTile+1),A
	LD   (WhichTileset),A
	JP   StartWipe

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

SetupLevelMap:
	LD   A,(LevelNumber)
	AND  $03
	ADD  A,A
	ADD  A,A
	LD   HL,LevelMapData
	CALL AddHLA2
	CALL DEFromHL2
	LD   (MapDataRow1),DE
	CALL HLFromHL2

SetMapData:
	LD   (MapDataRow2),HL

	LD   HL,MapDataRow1
	LD   DE,WorkingMapDataRow1
	LD   BC,$0010
	LDIR
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

; all 8 addresses copied to WorkingMapData

MapDataRow1:				
	dw $0000			; <- set from first word in LevelMapData
	dw Block32_Row1		; 32 byte block
	dw MapAttrColumn
	dw Block8_Row1		; 8 byte block

MapDataRow2:
	dw $0000			; <- set from second word in LevelMapData
	dw Block32_Row2
	dw MapAttrColumn2
	dw Block8_Row2

; lookup tables for levels, two addresses per level

LevelMapData:				
	dw L1Map_Row1		; addr 1 copied into MapDataRow1
	dw L1Map_Row2		; addr 2 copied into MapDataRow2

	dw L2Map_Row1
	dw L2Map_Row2
	
	dw L3Map_Row1
	dw L3Map_Row2
	
	dw L4Map_Row1
	dw L4Map_Row2

WorkingMapDataRow1:				; working data - initialised from MapDataRow1
	dw $0000
	dw $0000
	dw $0000
	dw $0000

WorkingMapDataRow2:				; working data - initialised from MapDataRow2
	dw $0000
	dw $0000
	dw $0000
	dw $0000

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Block32_Row1:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

Block32_Row2:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

Block8_Row1:
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

Block8_Row2:
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

AttrLineAddr:
	dw $589D

L1Map_Row1:
	db $07
	db $06
	db $03
	db $00
	db $08
	db $03
	db $09
	db $03
	db $09
	db $0A
	db $03
	db $1A
	db $03
	db $1F
	db $03
	db $1E
	db $03
	db $1F
	db $03
	db $1B
	db $0A
	db $03
	db $07
	db $0A
	db $07
	db $04
	db $03
	db $16
	db $08
	db $0A
	db $07
	db $04
	db $09
	db $20
	db $03
	db $08
	db $03
	db $03
	db $03
	db $08
	db $08
	db $00

L1Map_Row2:
	db $07
	db $06
	db $03
	db $02
	db $08
	db $01
	db $78
	db $38
	db $38
	db $38
	db $07
	db $0C
	db $EB
	db $08
	db $2B
	db $09
	db $EB
	db $02
	db $68
	db $F0
	db $2B
	db $EB
	db $EB
	db $20
	db $02
	db $68
	db $F0
	db $2B
	db $EB
	db $20
	db $20
	db $02
	db $68
	db $F0
	db $2B
	db $20
	db $20
	db $20
	db $02
	db $68
	db $F0
	db $03
	db $09
	db $03
	db $1C
	db $03
	db $18
	db $03
	db $18
	db $03
	db $18
	db $03
	db $1D
	db $0B
	db $68
	db $03
	db $05
	db $07
	db $04
	db $03
	db $17
	db $08
	db $07
	db $04
	db $03
	db $06
	db $20
	db $49
	db $4A
	db $4A
	db $03
	db $06
	db $03
	db $05
	db $03
	db $04
	db $03
	db $05
	db $03
	db $06
	db $20
	db $4B
	db $4C
	db $4C
	db $08

L2Map_Row1:
	db $07
	db $05
	db $03
	db $25
	db $03
	db $14
	db $08
	db $07
	db $02
	db $07
	db $02
	db $03
	db $12
	db $03
	db $13
	db $08
	db $03
	db $12
	db $0B
	db $68
	db $07
	db $60
	db $20
	db $08
	db $08
	db $07
	db $02
	db $03
	db $12
	db $03
	db $13
	db $08
	db $03
	db $14
	db $03
	db $25
	db $03
	db $14
	db $07
	db $03
	db $03
	db $12
	db $03
	db $13
	db $08
	db $0B
	db $68
	db $0A
	db $07
	db $63
	db $20
	db $08
	db $5F
	db $07
	db $44
	db $20
	db $08
	db $0A
	db $04
	db $00

L2Map_Row2:
	db $07
	db $05
	db $03
	db $26
	db $03
	db $15
	db $08
	db $07
	db $02
	db $07
	db $02
	db $03
	db $13
	db $03
	db $12
	db $08
	db $03
	db $13
	db $03
	db $29
	db $07
	db $24
	db $20
	db $08
	db $08
	db $07
	db $02
	db $03
	db $13
	db $03
	db $12
	db $08
	db $03
	db $15
	db $03
	db $26
	db $03
	db $15
	db $07
	db $03
	db $03
	db $13
	db $03
	db $12
	db $08
	db $01
	db $68
	db $68
	db $28
	db $28
	db $20
	db $20
	db $20
	db $56
	db $20
	db $20
	db $20
	db $57
	db $20
	db $20
	db $20
	db $58
	db $20
	db $20
	db $20
	db $59
	db $07
	db $04
	db $20
	db $20
	db $20
	db $58
	db $08
	db $20
	db $20
	db $20
	db $5A
	db $20
	db $20
	db $20
	db $58
	db $20
	db $20
	db $20
	db $5A
	db $07
	db $03
	db $20
	db $20
	db $20
	db $58
	db $08
	db $20
	db $20
	db $20
	db $5B
	db $20
	db $20
	db $5D
	db $5C
	db $20
	db $5F
	db $5E
	db $2B
	db $20
	db $20
	db $60
	db $2B
	db $5F
	db $5F
	db $61
	db $2B
	db $07
	db $04
	db $20
	db $20
	db $62
	db $2B
	db $08
	db $67
	db $65
	db $63
	db $2B
	db $68
	db $66
	db $64
	db $2B
	db $69
	db $09
	db $2B
	db $69
	db $09
	db $2B
	db $69
	db $02
	db $38
	db $6B
	db $2B
	db $2B
	db $6A
	db $09
	db $2B
	db $20
	db $02
	db $68
	db $6C
	db $6D
	db $2B
	db $20
	db $20
	db $6E
	db $58
	db $20
	db $20
	db $20
	db $58
	db $20
	db $20
	db $20
	db $5A
	db $20
	db $20
	db $20
	db $58
	db $20
	db $20
	db $20
	db $6F
	db $07
	db $03
	db $20
	db $20
	db $20
	db $58
	db $08
	db $20
	db $20
	db $20
	db $70
	db $20
	db $20
	db $20
	db $71
	db $20
	db $20
	db $73
	db $72
	db $20
	db $20
	db $74
	db $2B
	db $00

L3Map_Row1:
	db $01
	db $68
	db $68
	db $68
	db $78
	db $07
	db $02
	db $20
	db $20
	db $20
	db $84
	db $07
	db $04
	db $20
	db $20
	db $20
	db $85
	db $08
	db $08
	db $07
	db $0C
	db $03
	db $0A
	db $08
	db $20
	db $20
	db $20
	db $84
	db $07
	db $05
	db $20
	db $20
	db $20
	db $85
	db $08
	db $06
	db $07
	db $03
	db $03
	db $0B
	db $03
	db $0D
	db $03
	db $0B
	db $03
	db $0B
	db $08
	db $06
	db $0B
	db $68
	db $07
	db $60
	db $20
	db $08
	db $0A
	db $03
	db $1A
	db $07
	db $06
	db $03
	db $1F
	db $03
	db $1E
	db $03
	db $1F
	db $08
	db $0A
	db $06
	db $01
	db $28
	db $28
	db $68
	db $68
	db $C5
	db $C6
	db $CA
	db $CA
	db $C5
	db $C7
	db $CB
	db $CB
	db $C5
	db $C8
	db $CC
	db $CD
	db $C5
	db $C9
	db $CA
	db $CF
	db $C5
	db $C6
	db $CA
	db $D0
	db $C5
	db $C7
	db $CB
	db $D1
	db $C5
	db $C8
	db $CD
	db $D6
	db $C5
	db $C9
	db $CF
	db $D7
	db $C5
	db $C6
	db $D0
	db $D8
	db $C5
	db $C7
	db $D1
	db $D9
	db $07
	db $02
	db $C5
	db $C8
	db $D5
	db $DE
	db $C5
	db $C9
	db $D5
	db $DE
	db $C5
	db $C6
	db $D5
	db $DE
	db $C5
	db $C7
	db $D5
	db $DE
	db $08
	db $C5
	db $C8
	db $D2
	db $DA
	db $C5
	db $C9
	db $D3
	db $DB
	db $C5
	db $C6
	db $D4
	db $DC
	db $C5
	db $C7
	db $CE
	db $DD
	db $C5
	db $C8
	db $CC
	db $D2
	db $C5
	db $C9
	db $CA
	db $D3
	db $C5
	db $C6
	db $CA
	db $D4
	db $C5
	db $C7
	db $CB
	db $CE
	db $C5
	db $C8
	db $CC
	db $CC
	db $C5
	db $C9
	db $CA
	db $CA
	db $00

L3Map_Row2:
	db $0B
	db $50
	db $07
	db $10
	db $EB
	db $08
	db $25
	db $23
	db $25
	db $23
	db $26
	db $24
	db $26
	db $24
	db $07
	db $28
	db $EB
	db $08
	db $07
	db $06
	db $03
	db $01
	db $08
	db $06
	db $07
	db $03
	db $03
	db $0C
	db $03
	db $0E
	db $03
	db $0C
	db $03
	db $0C
	db $08
	db $06
	db $0B
	db $68
	db $07

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

gfx_MapTiles:
	db $60
	db $20
	db $08
	db $03
	db $1C
	db $07
	db $06
	db $03
	db $19
	db $03
	db $18
	db $03
	db $18
	db $08
	db $06
	db $0B
	db $68
	db $E1
	db $E3
	db $E4
	db $E5
	db $E2
	db $E4
	db $E5
	db $20
	db $D6
	db $DF
	db $20
	db $20
	db $D7
	db $09
	db $20
	db $D8
	db $09
	db $20
	db $D9
	db $09
	db $20
	db $DF
	db $09
	db $20
	db $07
	db $38
	db $20
	db $08
	db $E0
	db $09
	db $20
	db $DA
	db $09
	db $20
	db $DB
	db $09
	db $20
	db $DC
	db $09
	db $20
	db $DD
	db $E0
	db $20
	db $20
	db $E6
	db $E8
	db $EA
	db $20
	db $E7
	db $E9
	db $E8
	db $EA

CaptivesMap_Row1:
	db $0B
	db $50
	db $07
	db $78
	db $EB
	db $08

L4Map_Row1:
	db $0B
	db $70
	db $07
	db $0A
	db $03
	db $10
	db $08
	db $0B
	db $70
	db $07
	db $38
	db $20
	db $08
	db $0A
	db $03
	db $1A
	db $07
	db $04
	db $03
	db $1F
	db $03
	db $1E
	db $03
	db $1F
	db $08
	db $03
	db $1B
	db $0A
	db $03
	db $09
	db $0A
	db $03
	db $27
	db $03
	db $09
	db $03
	db $27
	db $0A
	db $03
	db $09
	db $0A
	db $03
	db $1A
	db $07
	db $03
	db $03
	db $1E
	db $03
	db $1F
	db $08
	db $20
	db $20
	db $06
	db $07
	db $0A
	db $03
	db $21
	db $08
	db $06
	db $07
	db $08
	db $03
	db $23
	db $08
	db $06
	db $0B
	db $50
	db $07
	db $DC
	db $85
	db $08
	db $0A
	db $00

CaptivesMap_Row2:
	db $07
	db $06
	db $0B
	db $50
	db $07
	db $10
	db $EB
	db $08
	db $F5
	db $F7
	db $F9
	db $FB
	db $0B
	db $10
	db $F6
	db $F8
	db $FA
	db $FC
	db $08

L4Map_Row2:
	db $0B
	db $70
	db $07
	db $0A
	db $03
	db $11
	db $08
	db $0B
	db $70
	db $03
	db $08
	db $03
	db $05
	db $03
	db $07
	db $03
	db $05
	db $03
	db $08
	db $03
	db $1C
	db $07
	db $04
	db $03
	db $19
	db $03
	db $18
	db $03
	db $18
	db $08
	db $03
	db $0F
	db $0B
	db $70
	db $03
	db $08
	db $03
	db $05
	db $03
	db $07
	db $03
	db $28
	db $03
	db $09
	db $03
	db $28
	db $03
	db $08
	db $03
	db $05
	db $03
	db $07
	db $03
	db $1C
	db $03
	db $19
	db $03
	db $18
	db $03
	db $18
	db $03
	db $20
	db $06
	db $07
	db $0A
	db $03
	db $22
	db $08
	db $06
	db $07
	db $04
	db $03
	db $24
	db $08
	db $07
	db $E0
	db $85
	db $08
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $EF
	db $0E
	db $07
	db $07
	db $F3
	db $02
	db $07
	db $0F
	db $7B
	db $38
	db $70
	db $F0
	db $E7
	db $20
	db $F0
	db $78
	db $5D
	db $DA
	db $5D
	db $DF
	db $40
	db $DF
	db $5F
	db $DA
	db $57
	db $B6
	db $57
	db $F6
	db $07
	db $F6
	db $F7
	db $B6
	db $5D
	db $DA
	db $5D
	db $DF
	db $40
	db $DF
	db $5F
	db $DA
	db $57
	db $B6
	db $57
	db $F6
	db $07
	db $F6
	db $F7
	db $B6
	db $00
	db $00
	db $00
	db $10
	db $10
	db $10
	db $14
	db $D6
	db $01
	db $01
	db $00
	db $7E
	db $57
	db $6B
	db $56
	db $7E
	db $55
	db $7D
	db $FE
	db $54
	db $FF
	db $FF
	db $FE
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $AC
	db $D4
	db $AC
	db $FC
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $01
	db $01
	db $03
	db $03
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $01
	db $02
	db $02
	db $FD
	db $FD
	db $FA
	db $FB
	db $FF
	db $00
	db $FF
	db $80
	db $48
	db $40
	db $28
	db $20
	db $FF
	db $00
	db $FF
	db $01
	db $12
	db $02
	db $14
	db $04
	db $80
	db $80
	db $40
	db $40
	db $A0
	db $A0
	db $50
	db $D0
	db $07
	db $07
	db $0F
	db $0F
	db $1F
	db $1F
	db $3F
	db $3F
	db $FF
	db $FF
	db $FF
	db $FF
	db $F3
	db $F3
	db $E1
	db $E1
	db $F4
	db $F4
	db $E8
	db $EC
	db $D0
	db $D1
	db $A0
	db $B0
	db $1F
	db $55
	db $3A
	db $3D
	db $42
	db $42
	db $81
	db $81
	db $DF
	db $57
	db $DF
	db $40
	db $5F
	db $DA
	db $55
	db $5D
	db $FB
	db $FB
	db $FB
	db $03
	db $FB
	db $1B
	db $3B
	db $3B
	db $FF
	db $EA
	db $F5
	db $EA
	db $D0
	db $D1
	db $A0
	db $B0
	db $F8
	db $AA
	db $44
	db $A4
	db $42
	db $42
	db $81
	db $81
	db $28
	db $28
	db $14
	db $34
	db $0A
	db $8A
	db $05
	db $0D
	db $7F
	db $7F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FE
	db $FE
	db $C1
	db $C1
	db $82
	db $82
	db $05
	db $05
	db $0A
	db $0B
	db $41
	db $45
	db $83
	db $C3
	db $07
	db $17
	db $0F
	db $0F
	db $80
	db $80
	db $C0
	db $C0
	db $E0
	db $E0
	db $F0
	db $F0
	db $D2
	db $D2
	db $5F
	db $40
	db $5F
	db $58
	db $50
	db $50
	db $FB
	db $FB
	db $FB
	db $03
	db $FB
	db $BB
	db $5A
	db $DA
	db $82
	db $A2
	db $41
	db $43
	db $20
	db $28
	db $10
	db $10
	db $FC
	db $FC
	db $F8
	db $F8
	db $F0
	db $F0
	db $E0
	db $E0
	db $14
	db $14
	db $28
	db $2C
	db $50
	db $51
	db $A0
	db $B0
	db $1F
	db $5F
	db $27
	db $27
	db $43
	db $43
	db $81
	db $81
	db $F8
	db $F8
	db $FC
	db $FC
	db $FE
	db $FE
	db $FF
	db $FF
	db $58
	db $5A
	db $5F
	db $40
	db $5F
	db $5E
	db $DF
	db $DF
	db $2A
	db $2A
	db $FA
	db $02
	db $FA
	db $8A
	db $0B
	db $0B
	db $08
	db $0A
	db $04
	db $04
	db $02
	db $02
	db $01
	db $01
	db $00
	db $E8
	db $BC
	db $FC
	db $BC
	db $FC
	db $BC
	db $FE
	db $BE
	db $FE
	db $BE
	db $FE
	db $BE
	db $FE
	db $BE
	db $FE
	db $00
	db $17
	db $3D
	db $3F
	db $3D
	db $3F
	db $3D
	db $7F
	db $7D
	db $7F
	db $7D
	db $7F
	db $7D
	db $7F
	db $7D
	db $7F
	db $FF
	db $81
	db $B5
	db $B5
	db $81
	db $B5
	db $81
	db $FF
	db $22
	db $22
	db $55
	db $77
	db $77
	db $77
	db $55
	db $55
	db $55
	db $55
	db $55
	db $55
	db $55
	db $55
	db $77
	db $55
	db $77
	db $88
	db $FF
	db $3C
	db $24
	db $18
	db $FF
	db $FF
	db $1C
	db $1B
	db $1C
	db $3A
	db $3C
	db $33
	db $3C
	db $3A
	db $38
	db $D8
	db $38
	db $5C
	db $2C
	db $DC
	db $3C
	db $5C
	db $74
	db $6A
	db $74
	db $78
	db $74
	db $E8
	db $F4
	db $FF
	db $0E
	db $5E
	db $2E
	db $1E
	db $2E
	db $13
	db $2F
	db $77
	db $0F
	db $0C
	db $19
	db $18
	db $30
	db $30
	db $6C
	db $73
	db $FF
	db $01
	db $EF
	db $01
	db $01
	db $01
	db $03
	db $03
	db $FC
	db $E9
	db $F5
	db $A9
	db $D0
	db $E8
	db $D0
	db $E0
	db $3B
	db $97
	db $AB
	db $97
	db $03
	db $17
	db $0B
	db $15
	db $FF
	db $00
	db $F7
	db $80
	db $80
	db $80
	db $C0
	db $C0
	db $F0
	db $30
	db $98
	db $18
	db $0C
	db $0C
	db $36
	db $CE
	db $3C
	db $0F
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $C3
	db $33
	db $CF
	db $F3
	db $3E
	db $0F
	db $07
	db $07
	db $54
	db $E8
	db $57
	db $FF
	db $F8
	db $E4
	db $E4
	db $9F
	db $2F
	db $15
	db $EA
	db $FF
	db $1F
	db $27
	db $27
	db $F9
	db $C3
	db $CC
	db $F3
	db $CF
	db $7C
	db $F0
	db $E0
	db $E0
	db $3C
	db $F0
	db $C0
	db $00
	db $00
	db $00
	db $00
	db $00
	db $07
	db $07
	db $0F
	db $0F
	db $1F
	db $3F
	db $3F
	db $7F
	db $FF
	db $7F
	db $FF
	db $FF
	db $FF
	db $7F
	db $FF
	db $BF
	db $FF
	db $FE
	db $FF
	db $FF
	db $FF
	db $FE
	db $FF
	db $FD
	db $E0
	db $E0
	db $F0
	db $F0
	db $F8
	db $FC
	db $FC
	db $FE
	db $00
	db $00
	db $01
	db $02
	db $02
	db $04
	db $04
	db $04
	db $FF
	db $FF
	db $7F
	db $7D
	db $FE
	db $F4
	db $E8
	db $F0
	db $E4
	db $F8
	db $FF
	db $7F
	db $FF
	db $FB
	db $51
	db $51
	db $27
	db $1F
	db $FF
	db $FE
	db $FF
	db $DF
	db $8A
	db $8A
	db $FF
	db $FF
	db $FE
	db $BE
	db $7F
	db $2F
	db $17
	db $0F
	db $00
	db $00
	db $80
	db $40
	db $40
	db $20
	db $20
	db $20
	db $04
	db $04
	db $04
	db $05
	db $06
	db $00
	db $00
	db $00
	db $A0
	db $40
	db $80
	db $00
	db $00
	db $00
	db $00
	db $00
	db $DF
	db $D0
	db $7F
	db $37
	db $15
	db $1D
	db $17
	db $75
	db $FB
	db $0B
	db $FE
	db $EC
	db $A8
	db $B8
	db $E8
	db $AE
	db $05
	db $02
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $20
	db $20
	db $20
	db $A0
	db $60
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $1F
	db $F0
	db $00
	db $00
	db $00
	db $01
	db $0F
	db $F8
	db $80
	db $00
	db $00
	db $00
	db $1F
	db $F0
	db $00
	db $00
	db $00
	db $00
	db $07
	db $FC
	db $80
	db $00
	db $00
	db $00
	db $00
	db $00
	db $B0
	db $DF
	db $41
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $F8
	db $0F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $F6
	db $1F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $F8
	db $1F
	db $0F
	db $7C
	db $C0
	db $80
	db $80
	db $80
	db $80
	db $80
	db $04
	db $08
	db $48
	db $30
	db $88
	db $04
	db $0C
	db $06
	db $0F
	db $00
	db $0D
	db $00
	db $0D
	db $20
	db $40
	db $C0
	db $B0
	db $00
	db $50
	db $00
	db $F0
	db $00
	db $00
	db $00
	db $02
	db $00
	db $00
	db $04
	db $00
	db $28
	db $10
	db $32
	db $E8
	db $1D
	db $03
	db $01
	db $01
	db $01
	db $01
	db $01
	db $80
	db $80
	db $80
	db $80
	db $80
	db $80
	db $80
	db $80
	db $00
	db $00
	db $00
	db $22
	db $41
	db $24
	db $30
	db $18
	db $6F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FE
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $FF
	db $A6
	db $E7
	db $4D
	db $CF
	db $9A
	db $9F
	db $00
	db $FF
	db $AA
	db $FF
	db $55
	db $FF
	db $AA
	db $FF
	db $00
	db $FF
	db $00
	db $AA
	db $55
	db $FF
	db $24
	db $42
	db $81
	db $F1
	db $B2
	db $B4
	db $B8
	db $B8
	db $B4
	db $B2
	db $B1
	db $81
	db $42
	db $24
	db $18
	db $18
	db $24
	db $42
	db $81
	db $FF
	db $80
	db $B6
	db $B6
	db $B6
	db $B6
	db $80
	db $AB
	db $FF
	db $00
	db $DB
	db $DB
	db $DB
	db $DB
	db $00
	db $6B
	db $FF
	db $01
	db $6D
	db $6D
	db $6D
	db $6D
	db $01
	db $D9
	db $80
	db $AF
	db $80
	db $BB
	db $80
	db $BB
	db $80
	db $FF
	db $00
	db $57
	db $00
	db $77
	db $00
	db $7A
	db $00
	db $FF
	db $01
	db $DD
	db $01
	db $F5
	db $01
	db $8D
	db $01
	db $FF
	db $FF
	db $00
	db $AA
	db $55
	db $FF
	db $BC
	db $B2
	db $B1
	db $D1
	db $52
	db $5F
	db $40
	db $5F
	db $54
	db $52
	db $D1
	db $8B
	db $4A
	db $FA
	db $02
	db $FA
	db $2A
	db $4A
	db $8B
	db $01
	db $02
	db $05
	db $0B
	db $17
	db $2F
	db $5F
	db $BF
	db $FF
	db $00
	db $49
	db $95
	db $5D
	db $D7
	db $F7
	db $FF
	db $FF
	db $00
	db $41
	db $B4
	db $7D
	db $DF
	db $FF
	db $FF
	db $80
	db $40
	db $A0
	db $D0
	db $E8
	db $F4
	db $FA
	db $FD
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FF
	db $BF
	db $40
	db $BF
	db $FF
	db $FF
	db $FF
	db $00
	db $FF
	db $FD
	db $02
	db $FD
	db $FF
	db $FF
	db $FF
	db $80
	db $BF
	db $AF
	db $BF
	db $BF
	db $BF
	db $AF
	db $BF
	db $01
	db $FD
	db $F5
	db $FD
	db $FD
	db $FD
	db $F5
	db $FD
	db $80
	db $80
	db $80
	db $FF
	db $FF
	db $F1
	db $F1
	db $F1
	db $00
	db $00
	db $00
	db $FF
	db $FF
	db $3F
	db $0F
	db $03
	db $00
	db $00
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $FF
	db $FF
	db $FE
	db $FE
	db $FE
	db $00
	db $00
	db $00
	db $FF
	db $FF
	db $7F
	db $7F
	db $7F
	db $00
	db $00
	db $00
	db $FF
	db $FF
	db $FC
	db $F0
	db $C0
	db $01
	db $01
	db $01
	db $FF
	db $FF
	db $8F
	db $8F
	db $8F
	db $11
	db $F1
	db $F1
	db $F1
	db $F1
	db $F1
	db $F1
	db $F1
	db $00
	db $10
	db $00
	db $00
	db $C0
	db $30
	db $3C
	db $3F
	db $C0
	db $3F
	db $0F
	db $03
	db $00
	db $00
	db $00
	db $00
	db $02
	db $FE
	db $FE
	db $FE
	db $FE
	db $3E
	db $0E
	db $03
	db $40
	db $7F
	db $7F
	db $7F
	db $7F
	db $7C
	db $70
	db $C0
	db $03
	db $FC
	db $F0
	db $C0
	db $00
	db $00
	db $00
	db $00
	db $00
	db $04
	db $00
	db $00
	db $03
	db $0C
	db $3C
	db $FC
	db $88
	db $8F
	db $8F
	db $8F
	db $8F
	db $8F
	db $8F
	db $8F
	db $E0
	db $7F
	db $7F
	db $7F
	db $7F
	db $7F
	db $7F
	db $FF
	db $C0
	db $F0
	db $FC
	db $FF
	db $FF
	db $FC
	db $F0
	db $C0
	db $2F
	db $70
	db $51
	db $D2
	db $D2
	db $51
	db $70
	db $2F
	db $F4
	db $0E
	db $8A
	db $4B
	db $4B
	db $8A
	db $0E
	db $F4
	db $03
	db $0F
	db $3F
	db $FF
	db $FF
	db $3F
	db $0F
	db $03
	db $07
	db $FE
	db $FE
	db $FE
	db $FE
	db $FE
	db $FE
	db $FF
	db $23
	db $3C
	db $30
	db $C0
	db $00
	db $00
	db $10
	db $00
	db $00
	db $00
	db $00
	db $00
	db $03
	db $0F
	db $3F
	db $FF
	db $03
	db $0E
	db $3E
	db $FE
	db $FE
	db $FE
	db $FE
	db $FE
	db $C0
	db $70
	db $7C
	db $7F
	db $7F
	db $7F
	db $7F
	db $7F
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $F0
	db $FC
	db $FF
	db $C4
	db $3C
	db $0C
	db $03
	db $00
	db $00
	db $04
	db $00
	db $FF
	db $00
	db $BB
	db $BB
	db $BB
	db $00
	db $EE
	db $EE
	db $FF
	db $00
	db $BA
	db $BA
	db $BA
	db $00
	db $EE
	db $EE
	db $EE
	db $EE
	db $EE
	db $EE
	db $EE
	db $EE
	db $EE
	db $EE
	db $EE
	db $EE
	db $EE
	db $00
	db $BB
	db $BB
	db $BB
	db $00
	db $EE
	db $EE
	db $EE
	db $00
	db $BA
	db $BA
	db $BA
	db $00
	db $55
	db $DA
	db $5F
	db $C0
	db $5F
	db $DA
	db $55
	db $DA
	db $5A
	db $AB
	db $FA
	db $03
	db $FA
	db $AB
	db $5A
	db $AB
	db $FF
	db $FF
	db $ED
	db $FF
	db $FD
	db $FF
	db $FE
	db $F7
	db $FF
	db $D4
	db $F9
	db $A8
	db $F6
	db $D8
	db $F4
	db $A8
	db $FF
	db $00
	db $00
	db $20
	db $00
	db $80
	db $00
	db $40
	db $FF
	db $00
	db $00
	db $08
	db $00
	db $01
	db $00
	db $02
	db $FF
	db $2B
	db $9F
	db $15
	db $6F
	db $1B
	db $2F
	db $15
	db $FF
	db $FF
	db $B7
	db $FF
	db $BF
	db $FF
	db $7F
	db $EF
	db $6B
	db $57
	db $6B
	db $57
	db $6B
	db $57
	db $6B
	db $57
	db $D6
	db $EA
	db $D6
	db $EA
	db $D6
	db $EA
	db $D6
	db $EA
	db $FF
	db $9C
	db $80
	db $80
	db $80
	db $80
	db $FF
	db $00
	db $FF
	db $1F
	db $F6
	db $2C
	db $38
	db $30
	db $21
	db $3F
	db $F8
	db $1C
	db $16
	db $33
	db $7F
	db $C9
	db $89
	db $F9
	db $1F
	db $3C
	db $6C
	db $CE
	db $FB
	db $91
	db $90
	db $9F
	db $FF
	db $7C
	db $37
	db $1A
	db $0E
	db $86
	db $C2
	db $FF
	db $AA
	db $55
	db $AA
	db $55
	db $AA
	db $55
	db $AA
	db $55
	db $A9
	db $59
	db $A9
	db $59
	db $A9
	db $59
	db $A9
	db $59
	db $9A
	db $95
	db $9A
	db $95
	db $9A
	db $95
	db $9A
	db $95
	db $9A
	db $95
	db $9A
	db $95
	db $9A
	db $95
	db $9F
	db $F0
	db $A9
	db $59
	db $A9
	db $59
	db $A9
	db $59
	db $F9
	db $0F
	db $AA
	db $55
	db $AA
	db $55
	db $AF
	db $F0
	db $0F
	db $F5
	db $AA
	db $55
	db $AF
	db $F0
	db $0F
	db $F5
	db $AA
	db $55
	db $AF
	db $F0
	db $0F
	db $F5
	db $AA
	db $55
	db $AF
	db $F0
	db $FA
	db $0F
	db $F0
	db $5F
	db $AA
	db $55
	db $FA
	db $0F
	db $AA
	db $55
	db $FA
	db $0F
	db $F0
	db $5F
	db $AA
	db $55
	db $AA
	db $55
	db $AA
	db $55
	db $FA
	db $0F
	db $F0
	db $5F
	db $00
	db $FF
	db $AA
	db $55
	db $AA
	db $FF
	db $00
	db $FF
	db $0F
	db $F5
	db $AA
	db $55
	db $AF
	db $F0
	db $0F
	db $FF
	db $AA
	db $55
	db $AF
	db $F0
	db $0F
	db $FF
	db $FF
	db $F8
	db $AF
	db $F0
	db $0F
	db $FF
	db $FF
	db $F8
	db $80
	db $00
	db $0F
	db $FF
	db $FF
	db $F8
	db $80
	db $00
	db $00
	db $00
	db $F0
	db $FF
	db $FF
	db $1F
	db $01
	db $00
	db $00
	db $00
	db $FA
	db $0F
	db $F0
	db $FF
	db $FF
	db $1F
	db $01
	db $00
	db $AA
	db $55
	db $FA
	db $0F
	db $F0
	db $FF
	db $FF
	db $1F
	db $F0
	db $5F
	db $AA
	db $55
	db $FA
	db $0F
	db $F0
	db $FF
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $F8
	db $80
	db $00
	db $00
	db $00
	db $00
	db $00

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

gfx_CaptiveMapTiles:
	db $FF
	db $1F
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $AA
	db $55
	db $AA
	db $55
	db $AA
	db $55
	db $AA
	db $54
	db $AF
	db $58
	db $AF
	db $4A
	db $95
	db $2A
	db $55
	db $A9
	db $A9
	db $52
	db $A5
	db $4A
	db $95
	db $2A
	db $54
	db $A9
	db $53
	db $A7
	db $4F
	db $9F
	db $3E
	db $7C
	db $F8
	db $F0
	db $E0
	db $C0
	db $80
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FA
	db $1D
	db $F6
	db $53
	db $A9
	db $54
	db $EA
	db $95
	db $AA
	db $55
	db $AA
	db $55
	db $AA
	db $D5
	db $6A
	db $35
	db $CA
	db $E5
	db $F2
	db $F9
	db $7C
	db $3E
	db $1F
	db $0F
	db $9A
	db $4D
	db $A6
	db $53
	db $A9
	db $54
	db $2A
	db $95
	db $07
	db $03
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $10
	db $10
	db $10
	db $FF
	db $01
	db $01
	db $01
	db $FF
	db $00
	db $02
	db $20
	db $00
	db $FF
	db $F0
	db $E1
	db $FF
	db $00
	db $02
	db $20
	db $00
	db $FF
	db $87
	db $C3
	db $C3
	db $87
	db $FF
	db $00
	db $02
	db $20
	db $00
	db $FF
	db $E1
	db $F0
	db $FF
	db $00
	db $02
	db $20
	db $00
	db $FF
	db $80
	db $E0
	db $F8
	db $F0
	db $FC
	db $FE
	db $FE
	db $FF
	db $FF
	db $00
	db $FF
	db $00
	db $08
	db $00
	db $08
	db $00
	db $FF
	db $AA
	db $55
	db $FF
	db $00
	db $00
	db $FF
	db $AA
	db $FF
	db $AA
	db $55
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $10
	db $10
	db $11
	db $FD
	db $01
	db $01
	db $00
	db $FF
	db $10
	db $10
	db $D0
	db $5F
	db $41
	db $41
	db $01
	db $F9
	db $03
	db $02
	db $03
	db $CD
	db $18
	db $10
	db $14
	db $CF
	db $E0
	db $20
	db $E0
	db $59
	db $8C
	db $04
	db $14
	db $D4
	db $0A
	db $07
	db $02
	db $F7
	db $07
	db $0F
	db $0F
	db $15
	db $28
	db $F0
	db $20
	db $F7
	db $F0
	db $F8
	db $78
	db $EF
	db $0E
	db $07
	db $07
	db $F3
	db $02
	db $07
	db $0F
	db $7B
	db $38
	db $70
	db $F0
	db $E7
	db $20
	db $F0
	db $78
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $10
	db $18
	db $30
	db $5A
	db $30
	db $1C
	db $78
	db $14
	db $D8
	db $32
	db $9C
	db $72
	db $98
	db $F2
	db $34
	db $5A
	db $D8
	db $38
	db $52
	db $3F
	db $D2
	db $3C
	db $12
	db $5D
	db $B6
	db $50
	db $2D
	db $72
	db $15
	db $58
	db $77
	db $FB
	db $FF
	db $94
	db $4F
	db $5A
	db $FF
	db $42
	db $D1
	db $64
	db $FF
	db $00
	db $45
	db $9B
	db $FF
	db $84
	db $22
	db $DB
	db $FF
	db $11
	db $00
	db $84
	db $16
	db $41
	db $AD
	db $77
	db $FF
	db $20
	db $84
	db $0A
	db $44
	db $18
	db $65
	db $FF
	db $DF
	db $D9
	db $D8
	db $DF
	db $C0
	db $DF
	db $DF
	db $D9
	db $FB
	db $3B
	db $9B
	db $FB
	db $03
	db $FB
	db $FB
	db $1B
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $07
	db $08
	db $08
	db $08
	db $08
	db $00
	db $00
	db $00
	db $C0
	db $20
	db $1C
	db $0E
	db $07
	db $18
	db $27
	db $20
	db $20
	db $3F
	db $20
	db $3F
	db $18
	db $03
	db $FC
	db $00
	db $00
	db $FF
	db $00
	db $FF
	db $03
	db $FF
	db $00
	db $00
	db $00
	db $FF
	db $00
	db $FF
	db $FF
	db $08
	db $0B
	db $0B
	db $08
	db $07
	db $00
	db $00
	db $00
	db $07
	db $4E
	db $1C
	db $20
	db $C0
	db $00
	db $07
	db $0F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $7E
	db $81
	db $81
	db $81
	db $81
	db $81
	db $81
	db $FF
	db $81
	db $FF
	db $FF
	db $7E
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $00
	db $80
	db $70
	db $0C
	db $02
	db $FE
	db $0C
	db $F0
	db $80
	db $13
	db $17
	db $26
	db $2E
	db $4C
	db $5C
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $00
	db $60
	db $B0
	db $70
	db $E0
	db $1F
	db $3F
	db $7F
	db $7F
	db $FF
	db $FF
	db $7F
	db $7F
	db $AF
	db $AF
	db $A8
	db $AF
	db $AC
	db $AF
	db $A8
	db $AF
	db $CD
	db $CA
	db $CF
	db $D0
	db $D0
	db $CF
	db $CD
	db $CA
	db $53
	db $B3
	db $F3
	db $0B
	db $0B
	db $F3
	db $53
	db $B3
	db $FF
	db $00
	db $00
	db $00
	db $1F
	db $1A
	db $15
	db $1A
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $FF
	db $A0
	db $A0
	db $A0
	db $FF
	db $8B
	db $AB
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $FF
	db $03
	db $FF
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $FF
	db $AF
	db $AF
	db $C0
	db $83
	db $04
	db $0C
	db $1C
	db $FC
	db $AF
	db $AB
	db $00
	db $FF
	db $08
	db $69
	db $28
	db $08
	db $FF
	db $08
	db $00
	db $C0
	db $60
	db $90
	db $48
	db $0C
	db $FF
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $F0
	db $FE
	db $FF
	db $FF
	db $CF
	db $B7
	db $A7
	db $87
	db $CE
	db $FD
	db $FF
	db $50
	db $5E
	db $57
	db $50
	db $FF
	db $00
	db $FF
	db $FF
	db $FD
	db $FD
	db $ED
	db $ED
	db $FD
	db $61
	db $BF
	db $FB
	db $4B
	db $FB
	db $0B
	db $0C
	db $FF
	db $00
	db $FF
	db $FD
	db $FE
	db $FE
	db $FE
	db $3E
	db $DE
	db $6E
	db $B1
	db $07
	db $09
	db $08
	db $08
	db $09
	db $0B
	db $07
	db $03
	db $FB
	db $FF
	db $FF
	db $FE
	db $FC
	db $FD
	db $F8
	db $F9
	db $FF
	db $C3
	db $0A
	db $55
	db $BE
	db $67
	db $DB
	db $A5
	db $DF
	db $FF
	db $FF
	db $7F
	db $BF
	db $7F
	db $3F
	db $5F
	db $4A
	db $C9
	db $0C
	db $05
	db $06
	db $03
	db $01
	db $00
	db $A5
	db $DB
	db $E6
	db $7C
	db $A0
	db $55
	db $EB
	db $7E
	db $32
	db $53
	db $30
	db $60
	db $E0
	db $C0
	db $80
	db $00
	db $83
	db $7D
	db $7D
	db $83
	db $FF
	db $00
	db $55
	db $FF
	db $00
	db $FF
	db $20
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $80
	db $F8
	db $04
	db $54
	db $FC
	db $00
	db $00
	db $00
	db $01
	db $07
	db $1C
	db $71
	db $C7
	db $00
	db $00
	db $3F
	db $E0
	db $07
	db $3F
	db $FF
	db $FF
	db $00
	db $00
	db $FF
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $66
	db $BB
	db $BB
	db $BA
	db $BB
	db $BB
	db $BB
	db $BB
	db $00
	db $00
	db $FF
	db $00
	db $FF
	db $81
	db $1F
	db $3F
	db $30
	db $5B
	db $DE
	db $D8
	db $DB
	db $DA
	db $DD
	db $DA
	db $E0
	db $86
	db $5F
	db $B5
	db $7B
	db $AF
	db $57
	db $BE
	db $00
	db $00
	db $00
	db $00
	db $00
	db $03
	db $0E
	db $38
	db $02
	db $02
	db $07
	db $3C
	db $E0
	db $80
	db $0B
	db $57
	db $02
	db $02
	db $02
	db $02
	db $02
	db $02
	db $02
	db $02
	db $00
	db $00
	db $FF
	db $00
	db $00
	db $9F
	db $FF
	db $FF
	db $02
	db $02
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $FF
	db $00
	db $00
	db $FF
	db $00
	db $7C
	db $83
	db $FF
	db $FF
	db $81
	db $80
	db $FF
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $47
	db $11
	db $FF
	db $12
	db $FF
	db $FF
	db $FF
	db $FF
	db $41
	db $82
	db $81
	db $84
	db $83
	db $84
	db $81
	db $82
	db $FF
	db $07
	db $FF
	db $7F
	db $DB
	db $F1
	db $5B
	db $DF
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0F
	db $30
	db $40
	db $02
	db $02
	db $02
	db $02
	db $02
	db $FF
	db $00
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $9F
	db $F7
	db $FF
	db $F6
	db $EA
	db $EA
	db $EA
	db $F6
	db $FF
	db $EA
	db $C0
	db $C0
	db $E0
	db $E0
	db $F0
	db $F0
	db $F0
	db $F8
	db $FF
	db $00
	db $FF
	db $FC
	db $FC
	db $FC
	db $FE
	db $FE
	db $F8
	db $04
	db $F8
	db $00
	db $00
	db $00
	db $00
	db $00
	db $60
	db $B0
	db $BF
	db $B0
	db $BF
	db $BF
	db $BF
	db $BF
	db $00
	db $00
	db $00
	db $F0
	db $3F
	db $FB
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $B8
	db $FF
	db $0C
	db $08
	db $19
	db $11
	db $37
	db $23
	db $67
	db $CF
	db $00
	db $00
	db $01
	db $01
	db $03
	db $02
	db $06
	db $04
	db $3F
	db $E0
	db $80
	db $05
	db $0F
	db $57
	db $3F
	db $BF
	db $FF
	db $80
	db $E4
	db $CE
	db $FB
	db $F1
	db $80
	db $80
	db $FF
	db $00
	db $0D
	db $8F
	db $DB
	db $70
	db $20
	db $00
	db $FF
	db $00
	db $64
	db $4E
	db $FB
	db $B1
	db $00
	db $00
	db $80
	db $80
	db $80
	db $80
	db $80
	db $80
	db $80
	db $80
	db $9E
	db $80
	db $9E
	db $80
	db $98
	db $80
	db $80
	db $80
	db $00
	db $7F
	db $6B
	db $55
	db $6B
	db $55
	db $6B
	db $7F
	db $00
	db $FC
	db $AC
	db $54
	db $AC
	db $54
	db $AC
	db $FC
	db $6B
	db $55
	db $6B
	db $55
	db $6B
	db $7F
	db $80
	db $FF
	db $AC
	db $54
	db $AC
	db $54
	db $AC
	db $FC
	db $02
	db $FE
	db $3F
	db $3F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $F8
	db $F8
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $00
	db $02
	db $17
	db $0B
	db $01
	db $0A
	db $00
	db $02
	db $FE
	db $82
	db $AA
	db $A2
	db $82
	db $FE
	db $00
	db $00
	db $FF
	db $01
	db $01
	db $01
	db $FF
	db $10
	db $10
	db $10
	db $00
	db $1F
	db $1F
	db $1F
	db $1F
	db $3F
	db $1F
	db $1F
	db $20
	db $EF
	db $7E
	db $7E
	db $7E
	db $7E
	db $7E
	db $7E
	db $20
	db $8F
	db $D5
	db $F5
	db $FD
	db $FD
	db $FD
	db $FD
	db $00
	db $F0
	db $F8
	db $F8
	db $F8
	db $F8
	db $F8
	db $F8
	db $1F
	db $1F
	db $7F
	db $3F
	db $1F
	db $1F
	db $1F
	db $1F
	db $7E
	db $7E
	db $7E
	db $7E
	db $7E
	db $7E
	db $7E
	db $7E
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $FD
	db $F8
	db $F0
	db $F0
	db $F8
	db $F8
	db $F8
	db $FC
	db $FC
	db $EE
	db $86
	db $04
	db $04
	db $8E
	db $FF
	db $FF
	db $FF
	db $18
	db $10
	db $10
	db $10
	db $18
	db $FF
	db $FF
	db $FF
	db $38
	db $10
	db $10
	db $10
	db $30
	db $FF
	db $FF
	db $FF
	db $C6
	db $41
	db $41
	db $41
	db $43
	db $FF
	db $FF
	db $FE
	db $00
	db $00
	db $00
	db $01
	db $02
	db $02
	db $03
	db $01
	db $00
	db $00
	db $00
	db $C0
	db $30
	db $08
	db $84
	db $E6
	db $FF
	db $3C
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $30
	db $CC
	db $33
	db $0C
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $30
	db $CC
	db $33
	db $0F
	db $03
	db $01
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $30
	db $0C
	db $C3
	db $F0
	db $3C
	db $0F
	db $03
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $30
	db $0C
	db $C3
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $3C
	db $13
	db $0C
	db $F0
	db $3C
	db $0F
	db $03
	db $00
	db $00
	db $00
	db $00
	db $C3
	db $30
	db $0C
	db $C3
	db $F0
	db $3C
	db $0F
	db $0B
	db $C0
	db $70
	db $1C
	db $1F
	db $FF
	db $8E
	db $81
	db $CA
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $F0
	db $5F
	db $AF
	db $00
	db $7F
	db $40
	db $40
	db $20
	db $1F
	db $FD
	db $FF
	db $00
	db $FF
	db $00
	db $00
	db $00
	db $FF
	db $55
	db $EA
	db $00
	db $FF
	db $00
	db $00
	db $01
	db $FE
	db $57
	db $AA
	db $00
	db $FC
	db $D4
	db $AC
	db $F4
	db $64
	db $E7
	db $64
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $01
	db $09
	db $08
	db $08
	db $08
	db $07
	db $00
	db $00
	db $00
	db $F5
	db $CE
	db $C7
	db $63
	db $FF
	db $1F
	db $0F
	db $03
	db $58
	db $BA
	db $4F
	db $8F
	db $94
	db $8C
	db $96
	db $8B
	db $01
	db $AB

data_7C82:
	dw $7048
	db $01
	db $01
	db $01
	db $03
	db $FD
	db $B8
	db $58
	db $AF
	db $57
	db $AF
	db $57
	db $AF
	db $57
	db $02
	db $03
	db $C2
	db $E3
	db $E0
	db $F0
	db $F8
	db $E6
	db $65
	db $E6
	db $65
	db $E7
	db $05
	db $07
	db $0F
	db $AB
	db $55
	db $AB
	db $77
	db $DE
	db $FC
	db $F8
	db $F0
	db $95
	db $88
	db $94
	db $88
	db $94
	db $88
	db $94
	db $88
	db $FF
	db $2A
	db $2B
	db $2A
	db $2B
	db $2A
	db $2B
	db $2A
	db $FF
	db $97
	db $8F
	db $97
	db $8B
	db $87
	db $8B
	db $85
	db $E0
	db $C0
	db $C0
	db $FC
	db $FE
	db $FF
	db $FF
	db $FF
	db $18
	db $24
	db $26
	db $43
	db $41
	db $40
	db $80
	db $AB
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $7F
	db $7F
	db $1D
	db $FF
	db $00
	db $00
	db $FF
	db $EB
	db $EB
	db $FF
	db $55
	db $FF
	db $00
	db $00
	db $FF
	db $8B
	db $85
	db $FF
	db $55
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $55
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $FE
	db $FE
	db $58
	db $FF
	db $00
	db $00
	db $FF
	
; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

gfx_Charset:

	db $00,$1e,$13,$11,$f1,$01,$01,$ff,$07,$08,$10,$10,$10,$10,$08,$07,$80,$40,$20,$20,$20,$30,$58,$ac,$00,$00,$00,$00,$00,$7f,$80,$ab
	db $1e,$21,$45,$5f,$df,$fd,$ff,$fd,$fb,$8e,$04,$05,$fb,$04,$ff,$04,$fe,$55,$ab,$55,$ff,$35,$ff,$3f,$00,$00,$ff,$a4,$ff,$c0,$de,$a3
	db $00,$00,$ff,$00,$ff,$00,$00,$00,$00,$00,$ff,$00,$ff,$90,$e0,$a0,$00,$ff,$85,$85,$ff,$ff,$00,$00,$00,$01,$02,$04,$0b,$0f,$07,$07
	db $7f,$c0,$00,$ff,$ff,$e8,$df,$a3,$ff,$00,$00,$ff,$ff,$88,$ff,$e3,$fe,$03,$00,$ff,$ff,$97,$fb,$c5,$00,$80,$40,$20,$d0,$e0,$e0,$e0
	db $03,$03,$01,$00,$00,$00,$00,$00,$c1,$49,$c1,$e3,$5c,$2c,$17,$0c,$d9,$a2,$a8,$82,$d5,$e3,$ff,$88,$83,$93,$81,$c5,$3a,$3c,$e8,$90
	db $c0,$c0,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$6c,$c2,$02,$6c,$80,$86,$6c,$00,$00,$00,$00,$00,$00,$00,$01,$03,$00,$20,$18,$0c,$4c,$e6,$c6,$e6
	db $09,$1c,$3e,$77,$e1,$40,$00,$00,$36,$1e,$1c,$fe,$f3,$01,$00,$00,$00,$00,$00,$00,$00,$60,$8d,$6d,$00,$00,$00,$00,$00,$00,$f6,$f6
	db $00,$00,$00,$00,$00,$7c,$82,$f9,$e1,$6c,$0c,$08,$05,$03,$00,$00,$f0,$06,$06,$02,$f4,$f8,$00,$00,$fe,$7c,$00,$00,$00,$00,$00,$00
	db $e0,$78,$1c,$dc,$7e,$3e,$fe,$7f,$00,$00,$00,$00,$15,$2a,$3f,$15,$00,$00,$00,$00,$3e,$e3,$ff,$3e,$f7,$eb,$a1,$c1,$c1,$82,$8b,$d6
	db $6c,$86,$8a,$82,$a2,$c2,$6c,$00,$70,$d0,$10,$10,$10,$10,$ee,$00,$6c,$c2,$02,$6c,$80,$80,$ee,$00,$6c,$c2,$02,$0c,$02,$c2,$6c,$00
	db $10,$30,$50,$fe,$10,$10,$10,$00,$ec,$86,$80,$ec,$02,$c2,$6c,$00,$6c,$86,$80,$ec,$82,$82,$6c,$00,$6e,$c4,$08,$10,$10,$10,$10,$00
	db $6c,$82,$82,$6c,$82,$82,$6c,$00,$6c,$82,$82,$6e,$02,$c2,$6c,$00,$05,$06,$01,$06,$08,$0a,$11,$11,$f0,$4c,$86,$e2,$71,$71,$99,$99
	db $12,$12,$09,$0c,$03,$00,$00,$00,$69,$69,$91,$b0,$c0,$00,$00,$00,$04,$08,$08,$08,$08,$08,$04,$00,$7c,$86,$86,$1c,$10,$00,$10,$00
	db $40,$20,$20,$20,$20,$20,$40,$00,$6c,$82,$82,$ee,$82,$82,$82,$00,$ec,$82,$82,$ec,$82,$82,$ec,$00,$6c,$86,$80,$80,$80,$86,$6c,$00
	db $ec,$86,$82,$82,$82,$86,$ec,$00,$ec,$86,$80,$e0,$80,$86,$ec,$00,$6e,$c2,$02,$0e,$02,$02,$02,$00,$6c,$86,$80,$80,$8e,$86,$6c,$00
	db $82,$82,$82,$ee,$82,$82,$82,$00,$ee,$10,$10,$10,$10,$10,$ee,$00,$ee,$80,$80,$80,$80,$86,$6c,$00,$82,$82,$84,$e8,$84,$82,$82,$00
	db $80,$80,$80,$80,$80,$86,$ec,$00,$ec,$92,$92,$92,$82,$82,$82,$00,$ec,$82,$82,$82,$82,$82,$82,$00,$6c,$82,$82,$82,$82,$82,$6c,$00
	db $ec,$82,$82,$ec,$80,$80,$80,$00,$6c,$82,$82,$82,$8c,$8e,$66,$00,$ec,$82,$82,$ec,$82,$82,$82,$00,$6c,$86,$80,$6c,$02,$c2,$6c,$00
	db $6c,$d6,$10,$10,$10,$10,$10,$00,$82,$82,$82,$82,$82,$82,$6e,$00,$82,$82,$82,$82,$82,$44,$28,$00,$82,$82,$82,$92,$92,$92,$6e,$00
	db $82,$44,$28,$00,$28,$44,$82,$00,$82,$82,$82,$6e,$02,$c2,$6c,$00,$ee,$04,$08,$00,$20,$40,$ee,$00,$46,$a8,$84,$82,$a2,$4c,$00,$00
	db $66,$88,$44,$22,$22,$cc,$00,$00,$6e,$89,$4e,$28,$28,$c8,$00,$00,$e9,$8d,$cb,$89,$89,$e9,$00,$00,$00,$04,$08,$10,$20,$40,$00,$00


; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; Game Starts here (for setting up input), this memory is then reused as the game's
; backbuffer.
;
;
	org $8000

GameStart:
BackBuffer:

	DI  			
	LD   IY,Variables
	XOR  A
	OUT  ($FE),A
	IM   2
	LD   A,high ISRTable		;$CC $CC00 holds ISR pointer to $FEFE
	LD   I,A
	LD   HL,ISRTable			;$CC00
	LD   DE,ISRTable+1			;$CC01
	LD   BC,$0100
	LD   (HL),$FE
	LDIR

	LD   DE,$6810
	CALL JP_PixAddr
	LD   B,$40
	LD   DE,LineAddresses
NextLineAddr:					; build a 64 high line address table
	LD   A,L
	LD   (DE),A
	INC  DE
	LD   A,H
	LD   (DE),A
	INC  DE
	INC  H
	LD   A,H
	AND  $07
	JR   NZ,Skip

	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,Skip

	LD   A,H
	SUB  $08
	LD   H,A
Skip:
	DJNZ NextLineAddr

	EI  
	LD   SP,$FEFD

	; PH: Clear screen as we have no loading bitmap to draw on!
	CALL JP_Sprint
	db CLA
	db CLS
	db MODE, RESETP
	db FIN

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

	if CONFIGURE_INPUT == 1

	CALL ColourWindow
	CALL JP_Sprint
	db PEN, $78
	db CHR
	dw gfx_Menu-$100						;$8200
	db DIRECT, DW
	db AT, $1D, $09
	db " "
	db REP, $21, $0A
	db DIRECT, LE
	db $22
	db REP, $23, $0E
	db DIRECT, UP
	db $24
	db REP, $25, $0A
	db DIRECT, RI
	db $26
	db REP, $27, $0E
	db MODE, RESETP
	db PEN, $42
	db AT, $10, $0C
	db "PR", TABX, "OGRAM  AND"
	db RTN
	db "GRA", TABX, "PHICS"
	db RTN
	db "BY"
	db PEN, $47
	db AT, $12, $10
	db "N", TABX, "AHTHANOJ"
	db RTN
	db "FFFIM!"
	db FIN

	LD   B,$C8
	CALL WaitBFrames

	CALL GetInputMode
	
	CALL JP_Sprint
	db CLA
	db CLS
	db FIN
	JP   FrontEndDone

GetInputMode:
	CALL ColourWindow
	CALL JP_Sprint
	db AT, $11, $0C
	db TABX
	db "  "
	db PEN, $47
	db "SELECT"
	db RTN,RTN
	db PEN, $46
	db "1 KEYBOARD"
	db RTN
	db PEN, $45
	db "2 KEMPSTON"
	db RTN
	db PEN, $44
	db "3 CURSOR"
	db RTN
	db PEN, $43
	db "4 SINCLAIR"
	db FIN

WaitMenuKey:
	CALL GetMenuKeys
	OR   A
	JR   Z,WaitMenuKey

	CP   $05
	JR   NC,WaitMenuKey
	
	LD   (ControlMethod),A
	DEC  A
	JR   Z,DoRedefine

	DEC  A
	RET  Z

	LD   HL,CursorKeys
	DEC  A
	JR   Z,SetInputKeys

	LD   HL,SinclairKeys

SetInputKeys:
	LD   DE,KeyTab
	LD   BC,$000A
	LDIR
	RET 

DoRedefine:
	CALL ColourWindow

RedefineKeys:
	LD   HL,UserKeys
	LD   DE,UserKeys+1
	LD   BC,$0005
	LD   (HL),$3F
	LDIR

	CALL JP_Sprint
	db AT, $10, $0B
	db PEN, $45
	db " "
	db TABX
	db "SELECT KEY "
	db RTN
	db RTN
	db PEN, $44
	db "UP"
	db RTN
	db "DOWN"
	db RTN
	db "LEFT"
	db RTN
	db "RIGHT"
	db RTN
	db "STAB"
	db RTN
	db "SHOOT"
PrintKeys:
	db DIRECT, DW
	db AT, $1A, $0D
	db PEN, $46
UserKeys:
	db "?"
	db "?"
	db "?"
	db "?"
	db "?"
	db "?"
	db DIRECT, RI
	db PEN, $FF
	db FIN

	LD   B,$06			; six keys to redefine
	LD   HL,RedefinedKeys
	LD   IX,UserKeys

RedefineNextKey:
	PUSH BC
	PUSH HL
	CALL WaitAnyKeyDown
	CALL SelectUniqueKey
	LD   (IX+$00),A
	PUSH BC
	LD   HL,PrintKeys
	CALL JP_Sprint
	db JSRS
	dw PrintKeys
	db FIN

	CALL WaitAnyKeyDown
	POP  BC
	POP  HL
	LD   A,C
	LD   (HL),A
	INC  HL
	LD   A,(KeyPressed)
	OR   $E0
	LD   (HL),A
	INC  HL
	POP  BC
	INC  IX
	DJNZ RedefineNextKey

	LD   B,$32
	CALL WaitBFrames
	CALL WaitAnyKeyDown
	CALL JP_Sprint
	db AT, $10, $0B
	db PEN, $C5
	db "HAPPY? >Y_N@"
	db FIN

WaitKey:
	LD   A,$7F
	IN   A,($FE)
	BIT  3,A
	JP   Z,RedefineKeys

	LD   A,$DF
	IN   A,($FE)
	BIT  4,A
	JR   NZ,WaitKey
	
	LD   HL,RedefinedKeys
	LD   DE,KeyTab+4
	LD   BC,$0008
	LDIR
	LD   DE,KeyTab+2
	LDI
	LDI
	LD   DE,KeyTab
	LDI
	LDI
	RET

ColourWindow:
	LD   HL,$0A0F			; y,x
	LD   BC,$131C			; height, width
	LD   A,$40				; colour
	JP   JP_FillAttrBlock

KeyPressed:
	db $00

SelectUniqueKey:
	HALT
	CALL ScanKeyboard
	JR   NZ,SelectUniqueKey

	LD   A,B
	DEC  A
	LD   B,E
	LD   C,D
	LD   HL,RDPortAscii-5		;data_8285	RdPortAscii - 5
	LD   DE,$0005
UniqueLoop:
	ADD  HL,DE
	DJNZ UniqueLoop

	CALL AddHLA_1
	LD   A,(HL)
	LD   B,$06
	LD   HL,UserKeys
NxtKey:
	CP   (HL)
	JR   Z,SelectUniqueKey
	INC  HL
	DJNZ NxtKey
	RET 

ScanKeyboard:
	LD   DE,$FE08			; D bitmask ($fe), E = 8 rows to read
ReadQuad:
	LD   B,$05			; 5 possible presses per row
ReadRow:
	LD   A,B
	DEC  A
	ADD  A,A
	ADD  A,A
	ADD  A,A
	ADD  A,$47
	LD   (ModBit+1),A
	LD   A,D
	IN   A,($FE)
	LD   (KeyPressed),A

ModBit:
	BIT  0,A
	RET  Z
	DJNZ ReadRow
	SLA  D
	INC  D
	DEC  E
	JR   NZ,ReadQuad
	INC  E
	RET 

WaitAnyKeyDown:
	XOR  A
	IN   A,($FE)
	OR   $E0
	INC  A
	JR   NZ,WaitAnyKeyDown
	RET 

WaitBFrames:
	HALT
	DJNZ WaitBFrames
	RET 

AddHLA_1:
	ADD  A,L
	LD   L,A
	RET  NC
	INC  H
	RET 
	LD   A,(HL)
	INC  HL
	LD   H,(HL)
	LD   L,A
	RET 
	LD   E,(HL)
	INC  HL
	LD   D,(HL)
	INC  HL
	RET 

RDPortAscii:			; 8 rows x 5 bytes of ASCII per row
	db $5D
	db $5C
	db $4D
	db $4E
	db $42
	db $5E
	db $4C
	db $4B
	db $4A
	db $48
	db $50
	db $4F
	db $49
	db $55
	db $59
	db $30
	db $39
	db $38
	db $37
	db $36
	db $31
	db $32
	db $33
	db $34
	db $35
	db $51
	db $57
	db $45
	db $52
	db $54
	db $41
	db $53
	db $44
	db $46
	db $47
	db $5B
	db $5A
	db $58
	db $43
	db $56

RedefinedKeys:
	db $FB
	db $FE
	db $FD
	db $FE
	db $DF
	db $FD
	db $DF
	db $FE
	db $7F
	db $FB
	db $7F
	db $FB

CursorKeys:
	db $EF
	db $FE
	db $EF
	db $F7
	db $EF
	db $EF
	db $F7
	db $EF
	db $EF
	db $FB

SinclairKeys:
	db $EF
	db $FE
	db $EF
	db $FD
	db $EF
	db $FB
	db $EF
	db $EF
	db $EF
	db $F7

MenuKeyTable:			; 10 pairs of values for five keys
	db $EF
	db $FE
	db $F7
	db $FE
	db $F7
	db $FD
	db $F7
	db $FB
	db $F7
	db $F7
	db $F7
	db $EF
	db $EF
	db $EF
	db $EF
	db $F7
	db $EF
	db $FB
	db $EF
	db $FD

GetMenuKeys:
	CALL WaitAnyKeyDown

ScanKeys:
	LD   BC,$0A00
	LD   HL,MenuKeyTable

TestKey:
	LD   A,(HL)
	INC  HL
	IN   A,($FE)
	OR   (HL)
	INC  A
	JR   NZ,GotKey

	INC  HL
	INC  C
	DJNZ TestKey
	JR   ScanKeys

GotKey:
	LD   A,C
	RET 

gfx_Menu:

	db $00,$fe,$02,$fa,$fa,$1a,$da,$5a,$5a,$5a,$5a,$5a,$5a,$5a,$5a,$5a,$5a,$da,$1a,$fa,$fa,$02,$fe,$00,$00,$ff,$00,$ff,$ff,$00,$ff,$00
	db $5a,$5b,$58,$5f,$5f,$40,$7f,$00,$5a,$5a,$5a,$5a,$5a,$5a,$5a,$5a,$00,$7f,$40,$5f,$5f,$58,$5b,$5a,$00,$ff,$00,$ff,$ff,$00,$ff,$00

	else

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

	CALL JP_Sprint
	db CLA
	db CLS
	db FIN
	JP   StabToStart
	
	endif

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

	org $8800

gfx_PlayerWalkRight:
	db $00
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $1D
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $00
	db $00
	db $21
	db $00
	db $00
	db $F1
	db $00
	db $00
	db $00
	db $00
	db $BE
	db $00
	db $01
	db $5D
	db $80
	db $00
	db $00
	db $40
	db $A6
	db $01
	db $01
	db $E0
	db $40
	db $00
	db $00
	db $80
	db $79
	db $01
	db $00
	db $FE
	db $00
	db $00
	db $00
	db $00
	db $88
	db $00
	db $01
	db $FE
	db $00
	db $00
	db $00
	db $80
	db $55
	db $01
	db $01
	db $AA
	db $C0
	db $00
	db $00
	db $40
	db $55
	db $01
	db $01
	db $BE
	db $A0
	db $00
	db $00
	db $60
	db $53
	db $01
	db $02
	db $B1
	db $C0
	db $00
	db $00
	db $E8
	db $60
	db $03
	db $03
	db $C0
	db $F0
	db $00
	db $00
	db $C0
	db $00
	db $07
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $07
	db $00
	db $03
	db $80
	db $00
	db $00
	db $40
	db $07
	db $00
	db $00
	db $0F
	db $C0
	db $00
	db $00
	db $40
	db $08
	db $00
	db $00
	db $3C
	db $40
	db $00
	db $00
	db $80
	db $2F
	db $00
	db $00
	db $57
	db $60
	db $00
	db $00
	db $90
	db $69
	db $00
	db $00
	db $78
	db $10
	db $00
	db $00
	db $60
	db $5E
	db $00
	db $00
	db $3F
	db $80
	db $00
	db $00
	db $00
	db $22
	db $00
	db $00
	db $7F
	db $00
	db $00
	db $00
	db $00
	db $55
	db $00
	db $00
	db $6A
	db $80
	db $00
	db $00
	db $40
	db $55
	db $00
	db $00
	db $EE
	db $A0
	db $00
	db $00
	db $60
	db $5F
	db $01
	db $01
	db $A9
	db $A0
	db $00
	db $00
	db $60
	db $71
	db $07
	db $0F
	db $C0
	db $E6
	db $00
	db $00
	db $7C
	db $00
	db $06
	db $06
	db $00
	db $38
	db $00
	db $00
	db $30
	db $00
	db $03
	db $00
	db $01
	db $C0
	db $00
	db $00
	db $A0
	db $03
	db $00
	db $00
	db $07
	db $E0
	db $00
	db $00
	db $20
	db $04
	db $00
	db $00
	db $0F
	db $20
	db $00
	db $00
	db $C0
	db $0B
	db $00
	db $00
	db $15
	db $CC
	db $00
	db $00
	db $72
	db $1A
	db $00
	db $00
	db $1E
	db $02
	db $00
	db $00
	db $8C
	db $17
	db $00
	db $00
	db $0F
	db $F0
	db $00
	db $00
	db $80
	db $08
	db $00
	db $00
	db $1F
	db $80
	db $00
	db $00
	db $40
	db $15
	db $00
	db $00
	db $1A
	db $A0
	db $00
	db $00
	db $60
	db $35
	db $00
	db $01
	db $EA
	db $B0
	db $00
	db $00
	db $D0
	db $D5
	db $01
	db $01
	db $EB
	db $A8
	db $00
	db $00
	db $D8
	db $1E
	db $01
	db $01
	db $00
	db $E8
	db $00
	db $00
	db $70
	db $00
	db $00
	db $00
	db $00
	db $70
	db $00
	db $00
	db $7C
	db $00
	db $00
	db $00
	db $00
	db $70
	db $00
	db $00
	db $E8
	db $00
	db $00
	db $00
	db $01
	db $F8
	db $00
	db $00
	db $08
	db $01
	db $00
	db $00
	db $03
	db $C8
	db $00
	db $00
	db $F0
	db $02
	db $00
	db $00
	db $05
	db $73
	db $00
	db $80
	db $9C
	db $06
	db $00
	db $00
	db $07
	db $80
	db $80
	db $00
	db $E3
	db $05
	db $00
	db $00
	db $03
	db $FC
	db $00
	db $00
	db $20
	db $02
	db $00
	db $00
	db $07
	db $E0
	db $00
	db $00
	db $60
	db $05
	db $00
	db $00
	db $06
	db $B0
	db $00
	db $00
	db $50
	db $03
	db $00
	db $00
	db $01
	db $B0
	db $00
	db $00
	db $50
	db $0F
	db $00
	db $00
	db $0F
	db $B0
	db $00
	db $00
	db $50
	db $0F
	db $00
	db $00
	db $09
	db $B0
	db $00
	db $00
	db $E0
	db $09
	db $00
	db $00
	db $00
	db $E0
	db $00
	db $00
	db $F8
	db $00
	db $00
gfx_MaskPlayerRight:
	db $FF
	db $E0
	db $FF
	db $FF
	db $FF
	db $7F
	db $C0
	db $FF
	db $FF
	db $80
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $FF
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $FE
	db $FC
	db $00
	db $3F
	db $FF
	db $FF
	db $1F
	db $00
	db $FC
	db $FC
	db $00
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $FC
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $FF
	db $01
	db $FE
	db $FC
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $00
	db $FC
	db $FC
	db $00
	db $1F
	db $FF
	db $FF
	db $1F
	db $00
	db $FC
	db $FC
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FC
	db $F8
	db $04
	db $17
	db $FF
	db $FF
	db $03
	db $0E
	db $F8
	db $F8
	db $1E
	db $07
	db $FF
	db $FF
	db $0F
	db $3E
	db $F0
	db $E0
	db $7F
	db $3F
	db $FF
	db $FF
	db $FF
	db $3F
	db $F0
	db $FF
	db $F8
	db $3F
	db $FF
	db $FF
	db $1F
	db $F0
	db $FF
	db $FF
	db $E0
	db $1F
	db $FF
	db $FF
	db $1F
	db $C0
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $1F
	db $80
	db $FF
	db $FF
	db $00
	db $0F
	db $FF
	db $FF
	db $07
	db $00
	db $FF
	db $FF
	db $00
	db $07
	db $FF
	db $FF
	db $0F
	db $00
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $7F
	db $80
	db $FF
	db $FF
	db $00
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $FF
	db $FF
	db $00
	db $3F
	db $FF
	db $FF
	db $1F
	db $00
	db $FF
	db $FE
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FC
	db $F8
	db $00
	db $0F
	db $FF
	db $FF
	db $09
	db $04
	db $F0
	db $E0
	db $0E
	db $00
	db $FF
	db $FF
	db $01
	db $3F
	db $F0
	db $F0
	db $FF
	db $83
	db $FF
	db $FF
	db $87
	db $7F
	db $F8
	db $FF
	db $FC
	db $1F
	db $FF
	db $FF
	db $0F
	db $F8
	db $FF
	db $FF
	db $F0
	db $0F
	db $FF
	db $FF
	db $0F
	db $F0
	db $FF
	db $FF
	db $E0
	db $0F
	db $FF
	db $FF
	db $13
	db $E0
	db $FF
	db $FF
	db $C0
	db $01
	db $FF
	db $FF
	db $00
	db $C0
	db $FF
	db $FF
	db $C0
	db $00
	db $FF
	db $FF
	db $01
	db $C0
	db $FF
	db $FF
	db $E0
	db $03
	db $FF
	db $FF
	db $0F
	db $E0
	db $FF
	db $FF
	db $C0
	db $3F
	db $FF
	db $FF
	db $1F
	db $C0
	db $FF
	db $FF
	db $C0
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FE
	db $FC
	db $00
	db $07
	db $FF
	db $FF
	db $07
	db $00
	db $FC
	db $FC
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $00
	db $FC
	db $FC
	db $60
	db $03
	db $FF
	db $FF
	db $07
	db $FF
	db $FE
	db $FF
	db $FF
	db $03
	db $FF
	db $FF
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $07
	db $FF
	db $FF
	db $03
	db $FE
	db $FF
	db $FF
	db $FC
	db $03
	db $FF
	db $FF
	db $03
	db $FC
	db $FF
	db $FF
	db $F8
	db $03
	db $FF
	db $FF
	db $04
	db $F8
	db $FF
	db $FF
	db $F0
	db $00
	db $7F
	db $3F
	db $00
	db $F0
	db $FF
	db $FF
	db $F0
	db $00
	db $3F
	db $7F
	db $00
	db $F0
	db $FF
	db $FF
	db $F8
	db $00
	db $FF
	db $FF
	db $03
	db $F8
	db $FF
	db $FF
	db $F0
	db $0F
	db $FF
	db $FF
	db $0F
	db $F0
	db $FF
	db $FF
	db $F0
	db $07
	db $FF
	db $FF
	db $07
	db $F8
	db $FF
	db $FF
	db $F0
	db $07
	db $FF
	db $FF
	db $07
	db $E0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $07
	db $E0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $0F
	db $E0
	db $FF
	db $FF
	db $F6
	db $07
	db $FF
	db $FF
	db $03
	db $FE
	db $FF

gfx_PlayerWalkLeft:
	db $00
	db $38
	db $00
	db $00
	db $00
	db $00
	db $5C
	db $00
	db $00
	db $7E
	db $00
	db $00
	db $00
	db $00
	db $42
	db $00
	db $00
	db $4F
	db $00
	db $00
	db $00
	db $00
	db $3D
	db $00
	db $03
	db $3A
	db $80
	db $00
	db $00
	db $80
	db $E5
	db $04
	db $04
	db $07
	db $80
	db $00
	db $00
	db $80
	db $1E
	db $03
	db $00
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $11
	db $00
	db $00
	db $1F
	db $80
	db $00
	db $00
	db $80
	db $1A
	db $00
	db $00
	db $35
	db $80
	db $00
	db $00
	db $00
	db $2B
	db $00
	db $00
	db $36
	db $00
	db $00
	db $00
	db $C0
	db $2B
	db $00
	db $00
	db $37
	db $C0
	db $00
	db $00
	db $C0
	db $2B
	db $00
	db $00
	db $36
	db $40
	db $00
	db $00
	db $40
	db $1E
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $7C
	db $00
	db $00
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $17
	db $00
	db $00
	db $1F
	db $80
	db $00
	db $00
	db $80
	db $10
	db $00
	db $00
	db $13
	db $C0
	db $00
	db $00
	db $40
	db $0F
	db $00
	db $00
	db $CE
	db $A0
	db $00
	db $00
	db $60
	db $39
	db $01
	db $01
	db $01
	db $E0
	db $00
	db $00
	db $A0
	db $C7
	db $00
	db $00
	db $3F
	db $C0
	db $00
	db $00
	db $40
	db $04
	db $00
	db $00
	db $07
	db $E0
	db $00
	db $00
	db $A0
	db $0A
	db $00
	db $00
	db $15
	db $60
	db $00
	db $00
	db $B0
	db $1A
	db $00
	db $00
	db $35
	db $5E
	db $00
	db $00
	db $AE
	db $2E
	db $00
	db $00
	db $57
	db $5E
	db $00
	db $00
	db $E2
	db $6D
	db $00
	db $00
	db $5C
	db $02
	db $00
	db $00
	db $00
	db $38
	db $00
	db $00
	db $38
	db $00
	db $00
	db $00
	db $00
	db $F8
	db $00
	db $00
	db $07
	db $00
	db $00
	db $00
	db $80
	db $0B
	db $00
	db $00
	db $0F
	db $C0
	db $00
	db $00
	db $40
	db $08
	db $00
	db $00
	db $08
	db $F0
	db $00
	db $00
	db $D0
	db $07
	db $00
	db $00
	db $1B
	db $A8
	db $00
	db $00
	db $58
	db $26
	db $00
	db $00
	db $20
	db $78
	db $00
	db $00
	db $E8
	db $19
	db $00
	db $00
	db $07
	db $F0
	db $00
	db $00
	db $10
	db $01
	db $00
	db $00
	db $03
	db $F8
	db $00
	db $00
	db $A8
	db $02
	db $00
	db $00
	db $05
	db $58
	db $00
	db $00
	db $A8
	db $0A
	db $00
	db $00
	db $15
	db $DC
	db $00
	db $00
	db $EA
	db $1B
	db $00
	db $00
	db $16
	db $56
	db $00
	db $80
	db $3B
	db $1A
	db $00
	db $01
	db $9C
	db $0F
	db $C0
	db $80
	db $01
	db $F8
	db $00
	db $00
	db $70
	db $01
	db $80
	db $00
	db $03
	db $30
	db $00
	db $00
	db $01
	db $C0
	db $00
	db $00
	db $E0
	db $02
	db $00
	db $00
	db $03
	db $F0
	db $00
	db $00
	db $10
	db $02
	db $00
	db $00
	db $02
	db $3C
	db $00
	db $00
	db $F4
	db $01
	db $00
	db $00
	db $06
	db $EA
	db $00
	db $00
	db $96
	db $09
	db $00
	db $00
	db $08
	db $1E
	db $00
	db $00
	db $7A
	db $06
	db $00
	db $00
	db $01
	db $FC
	db $00
	db $00
	db $44
	db $00
	db $00
	db $00
	db $01
	db $FE
	db $00
	db $00
	db $AA
	db $06
	db $00
	db $00
	db $0D
	db $56
	db $00
	db $00
	db $AA
	db $0A
	db $00
	db $00
	db $15
	db $F6
	db $00
	db $00
	db $2A
	db $1B
	db $00
	db $00
	db $0E
	db $35
	db $00
	db $00
	db $1B
	db $5C
	db $00
	db $00
	db $3C
	db $0F
	db $00
	db $80
	db $03
	db $0C
	db $00
	db $00
	db $00
	db $01
	db $C0
	db $80
	db $07
	db $00
	db $00

gfx_MaskPlayerLeft:
	db $FF
	db $83
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $FF
	db $FF
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FF
	db $FF
	db $00
	db $7F
	db $FF
	db $FF
	db $7F
	db $80
	db $FC
	db $F8
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $F0
	db $F0
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $F8
	db $FC
	db $00
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $FF
	db $FF
	db $C0
	db $3F
	db $FF
	db $FF
	db $3F
	db $C0
	db $FF
	db $FF
	db $80
	db $3F
	db $FF
	db $FF
	db $7F
	db $80
	db $FF
	db $FF
	db $80
	db $3F
	db $FF
	db $FF
	db $1F
	db $80
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $1F
	db $80
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $1F
	db $C0
	db $FF
	db $FF
	db $81
	db $BF
	db $FF
	db $FF
	db $FF
	db $01
	db $FF
	db $FF
	db $E0
	db $FF
	db $FF
	db $FF
	db $7F
	db $C0
	db $FF
	db $FF
	db $C0
	db $3F
	db $FF
	db $FF
	db $3F
	db $C0
	db $FF
	db $FF
	db $C0
	db $1F
	db $FF
	db $FF
	db $1F
	db $20
	db $FF
	db $FE
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FC
	db $FC
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FE
	db $FF
	db $00
	db $1F
	db $FF
	db $FF
	db $1F
	db $C0
	db $FF
	db $FF
	db $F0
	db $0F
	db $FF
	db $FF
	db $0F
	db $E0
	db $FF
	db $FF
	db $C0
	db $0F
	db $FF
	db $FF
	db $01
	db $C0
	db $FF
	db $FF
	db $80
	db $00
	db $FF
	db $FF
	db $00
	db $80
	db $FF
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $18
	db $FF
	db $FF
	db $FD
	db $83
	db $FF
	db $FF
	db $03
	db $FF
	db $FF
	db $FF
	db $FF
	db $03
	db $FE
	db $FF
	db $F0
	db $7F
	db $FF
	db $FF
	db $3F
	db $E0
	db $FF
	db $FF
	db $E0
	db $1F
	db $FF
	db $FF
	db $0F
	db $E0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $07
	db $E0
	db $FF
	db $FF
	db $C0
	db $03
	db $FF
	db $FF
	db $03
	db $80
	db $FF
	db $FF
	db $80
	db $03
	db $FF
	db $FF
	db $03
	db $C0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $07
	db $F8
	db $FF
	db $FF
	db $F8
	db $03
	db $FF
	db $FF
	db $03
	db $F8
	db $FF
	db $FF
	db $F0
	db $03
	db $FF
	db $FF
	db $03
	db $E0
	db $FF
	db $FF
	db $C0
	db $01
	db $FF
	db $FF
	db $00
	db $C0
	db $FF
	db $FF
	db $C0
	db $00
	db $7F
	db $3F
	db $80
	db $40
	db $FE
	db $FC
	db $01
	db $C0
	db $1F
	db $3F
	db $F0
	db $03
	db $FE
	db $FF
	db $07
	db $FC
	db $3F
	db $7F
	db $F8
	db $87
	db $FF
	db $FF
	db $FC
	db $1F
	db $FF
	db $FF
	db $0F
	db $F8
	db $FF
	db $FF
	db $F8
	db $07
	db $FF
	db $FF
	db $03
	db $F8
	db $FF
	db $FF
	db $F8
	db $01
	db $FF
	db $FF
	db $01
	db $F8
	db $FF
	db $FF
	db $F0
	db $00
	db $FF
	db $FF
	db $00
	db $E0
	db $FF
	db $FF
	db $E0
	db $00
	db $FF
	db $FF
	db $00
	db $F0
	db $FF
	db $FF
	db $F8
	db $01
	db $FF
	db $FF
	db $01
	db $FE
	db $FF
	db $FF
	db $F8
	db $00
	db $FF
	db $FF
	db $00
	db $F0
	db $FF
	db $FF
	db $E0
	db $00
	db $FF
	db $FF
	db $00
	db $E0
	db $FF
	db $FF
	db $C0
	db $00
	db $FF
	db $FF
	db $00
	db $C0
	db $FF
	db $FF
	db $A0
	db $80
	db $7F
	db $7F
	db $C0
	db $01
	db $FF
	db $FF
	db $81
	db $E0
	db $7F
	db $3F
	db $F0
	db $C1
	db $FF
	db $FF
	db $F3
	db $F8
	db $1F
	db $3F
	db $F0
	db $FF
	db $FF

gfx_PlayerWalkRight2:
	db $00
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $1D
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $00
	db $00
	db $21
	db $00
	db $00
	db $F1
	db $00
	db $00
	db $00
	db $00
	db $BE
	db $00
	db $01
	db $5D
	db $80
	db $00
	db $00
	db $40
	db $A6
	db $01
	db $01
	db $E0
	db $40
	db $00
	db $00
	db $80
	db $79
	db $01
	db $00
	db $FE
	db $00
	db $00
	db $00
	db $00
	db $88
	db $00
	db $01
	db $FE
	db $00
	db $00
	db $00
	db $80
	db $55
	db $01
	db $01
	db $AA
	db $C0
	db $00
	db $00
	db $40
	db $55
	db $01
	db $01
	db $BE
	db $A0
	db $00
	db $00
	db $60
	db $53
	db $01
	db $02
	db $B1
	db $C0
	db $00
	db $00
	db $E8
	db $60
	db $03
	db $03
	db $C0
	db $F0
	db $00
	db $00
	db $C0
	db $00
	db $07
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $07
	db $00
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $1D
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $00
	db $00
	db $21
	db $00
	db $00
	db $F1
	db $00
	db $00
	db $00
	db $00
	db $BE
	db $00
	db $01
	db $5D
	db $80
	db $00
	db $00
	db $40
	db $A6
	db $01
	db $01
	db $E0
	db $40
	db $00
	db $00
	db $80
	db $79
	db $01
	db $00
	db $FE
	db $00
	db $00
	db $00
	db $00
	db $88
	db $00
	db $01
	db $FC
	db $00
	db $00
	db $00
	db $00
	db $54
	db $01
	db $01
	db $AA
	db $00
	db $00
	db $00
	db $00
	db $55
	db $01
	db $03
	db $BA
	db $80
	db $00
	db $00
	db $80
	db $7D
	db $05
	db $06
	db $A6
	db $80
	db $00
	db $00
	db $80
	db $C5
	db $1D
	db $3F
	db $03
	db $98
	db $00
	db $00
	db $F0
	db $01
	db $18
	db $18
	db $00
	db $E0
	db $00
	db $00
	db $C0
	db $00
	db $0C
	db $00
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $3A
	db $00
	db $00
	db $7E
	db $00
	db $00
	db $00
	db $00
	db $42
	db $00
	db $00
	db $F2
	db $00
	db $00
	db $00
	db $00
	db $BC
	db $00
	db $01
	db $5C
	db $C0
	db $00
	db $00
	db $20
	db $A7
	db $01
	db $01
	db $E0
	db $20
	db $00
	db $00
	db $C0
	db $78
	db $01
	db $00
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $88
	db $00
	db $01
	db $F8
	db $00
	db $00
	db $00
	db $00
	db $54
	db $01
	db $01
	db $AA
	db $00
	db $00
	db $00
	db $00
	db $56
	db $03
	db $1E
	db $AB
	db $00
	db $00
	db $00
	db $00
	db $5D
	db $1D
	db $1E
	db $BA
	db $80
	db $00
	db $00
	db $80
	db $ED
	db $11
	db $10
	db $0E
	db $80
	db $00
	db $00
	db $00
	db $07
	db $00
	db $00
	db $07
	db $00
	db $00
	db $00
	db $C0
	db $07
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $3A
	db $00
	db $00
	db $7E
	db $00
	db $00
	db $00
	db $00
	db $42
	db $00
	db $00
	db $F2
	db $00
	db $00
	db $00
	db $00
	db $BC
	db $00
	db $01
	db $5C
	db $C0
	db $00
	db $00
	db $20
	db $A7
	db $01
	db $01
	db $E0
	db $20
	db $00
	db $00
	db $C0
	db $78
	db $01
	db $00
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $88
	db $00
	db $01
	db $F8
	db $00
	db $00
	db $00
	db $00
	db $58
	db $01
	db $01
	db $AC
	db $00
	db $00
	db $00
	db $00
	db $D4
	db $00
	db $00
	db $6C
	db $00
	db $00
	db $00
	db $00
	db $D4
	db $03
	db $03
	db $EC
	db $00
	db $00
	db $00
	db $00
	db $D4
	db $03
	db $02
	db $6C
	db $00
	db $00
	db $00
	db $00
	db $78
	db $02
	db $00
	db $38
	db $00
	db $00
	db $00
	db $00
	db $3E
	db $00

gfx_MaskPlayerRight2:
	db $FF
	db $E0
	db $FF
	db $FF
	db $FF
	db $7F
	db $C0
	db $FF
	db $FF
	db $80
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $FF
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $FE
	db $FC
	db $00
	db $3F
	db $FF
	db $FF
	db $1F
	db $00
	db $FC
	db $FC
	db $00
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $FC
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $FF
	db $01
	db $FE
	db $FC
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $00
	db $FC
	db $FC
	db $00
	db $1F
	db $FF
	db $FF
	db $1F
	db $00
	db $FC
	db $FC
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FC
	db $F8
	db $04
	db $17
	db $FF
	db $FF
	db $03
	db $0E
	db $F8
	db $F8
	db $1E
	db $07
	db $FF
	db $FF
	db $0F
	db $3E
	db $F0
	db $E0
	db $7F
	db $3F
	db $FF
	db $FF
	db $FF
	db $3F
	db $F0
	db $FF
	db $E0
	db $FF
	db $FF
	db $FF
	db $7F
	db $C0
	db $FF
	db $FF
	db $80
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $FF
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $FE
	db $FC
	db $00
	db $3F
	db $FF
	db $FF
	db $1F
	db $00
	db $FC
	db $FC
	db $00
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $FC
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $FF
	db $01
	db $FE
	db $FC
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $FC
	db $FC
	db $00
	db $FF
	db $FF
	db $FF
	db $7F
	db $00
	db $FC
	db $F8
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $F0
	db $E0
	db $00
	db $3F
	db $FF
	db $FF
	db $27
	db $10
	db $C0
	db $80
	db $38
	db $03
	db $FF
	db $FF
	db $07
	db $FC
	db $C0
	db $C3
	db $FE
	db $0F
	db $FF
	db $FF
	db $1F
	db $FE
	db $E1
	db $FF
	db $C1
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $FF
	db $FF
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FF
	db $FE
	db $00
	db $FF
	db $FF
	db $FF
	db $3F
	db $01
	db $FE
	db $FC
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $FC
	db $FC
	db $00
	db $0F
	db $FF
	db $FF
	db $1F
	db $00
	db $FC
	db $FE
	db $00
	db $3F
	db $FF
	db $FF
	db $FF
	db $00
	db $FE
	db $FC
	db $03
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $FC
	db $FC
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $E0
	db $C0
	db $00
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $C0
	db $C0
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $C0
	db $C6
	db $00
	db $3F
	db $FF
	db $FF
	db $7F
	db $F0
	db $EF
	db $FF
	db $F0
	db $3F
	db $FF
	db $FF
	db $1F
	db $F0
	db $FF
	db $FF
	db $C1
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $FF
	db $FF
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FF
	db $FE
	db $00
	db $FF
	db $FF
	db $FF
	db $3F
	db $01
	db $FE
	db $FC
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $FC
	db $FC
	db $00
	db $0F
	db $FF
	db $FF
	db $1F
	db $00
	db $FC
	db $FE
	db $00
	db $3F
	db $FF
	db $FF
	db $FF
	db $00
	db $FE
	db $FC
	db $03
	db $FF
	db $FF
	db $FF
	db $FF
	db $03
	db $FC
	db $FC
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $FE
	db $FC
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $F8
	db $F8
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $F8
	db $F8
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $03
	db $F8
	db $FD
	db $81
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $FF

gfx_PlayerRightJump:
	db $00
	db $03
	db $80
	db $00
	db $00
	db $40
	db $07
	db $00
	db $00
	db $0F
	db $C0
	db $00
	db $00
	db $40
	db $08
	db $00
	db $03
	db $F8
	db $40
	db $00
	db $00
	db $80
	db $D7
	db $04
	db $08
	db $AA
	db $00
	db $00
	db $00
	db $80
	db $D3
	db $0B
	db $09
	db $B2
	db $40
	db $00
	db $00
	db $40
	db $50
	db $0F
	db $01
	db $F9
	db $80
	db $00
	db $00
	db $00
	db $86
	db $00
	db $01
	db $FF
	db $00
	db $00
	db $00
	db $80
	db $5D
	db $01
	db $01
	db $AA
	db $C0
	db $00
	db $00
	db $40
	db $DD
	db $00
	db $03
	db $AE
	db $C0
	db $00
	db $00
	db $80
	db $5D
	db $1F
	db $1E
	db $BF
	db $00
	db $00
	db $00
	db $00
	db $EE
	db $3B
	db $30
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $0C
	db $00
	db $00
	db $07
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $00
	db $00
	db $D0
	db $01
	db $00
	db $00
	db $03
	db $F0
	db $00
	db $00
	db $10
	db $02
	db $00
	db $00
	db $FE
	db $10
	db $00
	db $00
	db $E0
	db $35
	db $01
	db $02
	db $2A
	db $80
	db $00
	db $00
	db $E0
	db $F4
	db $02
	db $02
	db $6C
	db $90
	db $00
	db $00
	db $10
	db $D4
	db $03
	db $00
	db $7E
	db $60
	db $00
	db $00
	db $80
	db $21
	db $00
	db $00
	db $7F
	db $C0
	db $00
	db $00
	db $60
	db $57
	db $00
	db $00
	db $6A
	db $B0
	db $00
	db $00
	db $50
	db $37
	db $00
	db $00
	db $EB
	db $B0
	db $00
	db $00
	db $60
	db $D7
	db $07
	db $07
	db $AF
	db $C0
	db $00
	db $00
	db $80
	db $FB
	db $0E
	db $0C
	db $07
	db $00
	db $00
	db $00
	db $00
	db $03
	db $00
	db $00
	db $01
	db $C0
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $38
	db $00
	db $00
	db $74
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $00
	db $00
	db $84
	db $00
	db $00
	db $00
	db $3F
	db $84
	db $00
	db $00
	db $78
	db $4D
	db $00
	db $00
	db $8A
	db $A0
	db $00
	db $00
	db $38
	db $BD
	db $00
	db $00
	db $9B
	db $24
	db $00
	db $00
	db $04
	db $F5
	db $00
	db $00
	db $1F
	db $98
	db $00
	db $00
	db $60
	db $08
	db $00
	db $00
	db $1F
	db $F0
	db $00
	db $00
	db $D8
	db $15
	db $00
	db $00
	db $1A
	db $AC
	db $00
	db $00
	db $D4
	db $0D
	db $00
	db $00
	db $3A
	db $EC
	db $00
	db $00
	db $D8
	db $F5
	db $01
	db $01
	db $EB
	db $F0
	db $00
	db $00
	db $E0
	db $BE
	db $03
	db $03
	db $01
	db $C0
	db $00
	db $00
	db $C0
	db $00
	db $00
	db $00
	db $00
	db $70
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0E
	db $00
	db $00
	db $1D
	db $00
	db $00
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $21
	db $00
	db $00
	db $00
	db $0F
	db $E1
	db $00
	db $00
	db $5E
	db $13
	db $00
	db $00
	db $22
	db $A8
	db $00
	db $00
	db $4E
	db $2F
	db $00
	db $00
	db $26
	db $C9
	db $00
	db $00
	db $41
	db $3D
	db $00
	db $00
	db $07
	db $E6
	db $00
	db $00
	db $18
	db $02
	db $00
	db $00
	db $07
	db $FC
	db $00
	db $00
	db $76
	db $05
	db $00
	db $00
	db $06
	db $AB
	db $00
	db $00
	db $75
	db $03
	db $00
	db $00
	db $0E
	db $BB
	db $00
	db $00
	db $76
	db $7D
	db $00
	db $00
	db $7A
	db $FC
	db $00
	db $00
	db $B8
	db $EF
	db $00
	db $00
	db $C0
	db $70
	db $00
	db $00
	db $30
	db $00
	db $00
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $00

gfx_MaskPlayerRightStatic:
	db $FF
	db $F8
	db $3F
	db $FF
	db $FF
	db $1F
	db $F0
	db $FF
	db $FF
	db $E0
	db $1F
	db $FF
	db $FF
	db $1F
	db $00
	db $FC
	db $F8
	db $00
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $F0
	db $E0
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $00
	db $E0
	db $E0
	db $00
	db $1F
	db $FF
	db $FF
	db $1F
	db $00
	db $E0
	db $F0
	db $00
	db $3F
	db $FF
	db $FF
	db $7F
	db $00
	db $FE
	db $FC
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $00
	db $FC
	db $FC
	db $00
	db $1F
	db $FF
	db $FF
	db $1F
	db $00
	db $FC
	db $E0
	db $00
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $C0
	db $C0
	db $00
	db $7F
	db $FF
	db $FF
	db $FF
	db $00
	db $80
	db $84
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $E0
	db $CF
	db $FF
	db $F0
	db $7F
	db $FF
	db $FF
	db $FF
	db $F8
	db $FF
	db $FF
	db $FE
	db $0F
	db $FF
	db $FF
	db $07
	db $FC
	db $FF
	db $FF
	db $F8
	db $07
	db $FF
	db $FF
	db $07
	db $00
	db $FF
	db $FE
	db $00
	db $07
	db $FF
	db $FF
	db $0F
	db $00
	db $FC
	db $F8
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $F8
	db $F8
	db $00
	db $07
	db $FF
	db $FF
	db $07
	db $00
	db $F8
	db $FC
	db $00
	db $0F
	db $FF
	db $FF
	db $1F
	db $80
	db $FF
	db $FF
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $FF
	db $FF
	db $00
	db $07
	db $FF
	db $FF
	db $07
	db $00
	db $FF
	db $F8
	db $00
	db $07
	db $FF
	db $FF
	db $0F
	db $00
	db $F0
	db $F0
	db $00
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $E0
	db $E1
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $F8
	db $F3
	db $FF
	db $FC
	db $1F
	db $FF
	db $FF
	db $3F
	db $FE
	db $FF
	db $FF
	db $FF
	db $83
	db $FF
	db $FF
	db $01
	db $FF
	db $FF
	db $FF
	db $FE
	db $01
	db $FF
	db $FF
	db $01
	db $C0
	db $FF
	db $FF
	db $80
	db $01
	db $FF
	db $FF
	db $03
	db $00
	db $FF
	db $FE
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $FE
	db $FE
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $FE
	db $FF
	db $00
	db $03
	db $FF
	db $FF
	db $07
	db $E0
	db $FF
	db $FF
	db $C0
	db $07
	db $FF
	db $FF
	db $03
	db $C0
	db $FF
	db $FF
	db $C0
	db $01
	db $FF
	db $FF
	db $01
	db $C0
	db $FF
	db $FE
	db $00
	db $01
	db $FF
	db $FF
	db $03
	db $00
	db $FC
	db $FC
	db $00
	db $07
	db $FF
	db $FF
	db $0F
	db $00
	db $F8
	db $F8
	db $40
	db $1F
	db $FF
	db $FF
	db $0F
	db $FE
	db $FC
	db $FF
	db $FF
	db $07
	db $FF
	db $FF
	db $8F
	db $FF
	db $FF
	db $FF
	db $FF
	db $E0
	db $FF
	db $7F
	db $C0
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $7F
	db $7F
	db $00
	db $F0
	db $FF
	db $FF
	db $E0
	db $00
	db $7F
	db $FF
	db $00
	db $C0
	db $FF
	db $FF
	db $80
	db $01
	db $FF
	db $FF
	db $00
	db $80
	db $FF
	db $FF
	db $80
	db $00
	db $7F
	db $7F
	db $00
	db $80
	db $FF
	db $FF
	db $C0
	db $00
	db $FF
	db $FF
	db $01
	db $F8
	db $FF
	db $FF
	db $F0
	db $01
	db $FF
	db $FF
	db $00
	db $F0
	db $FF
	db $FF
	db $F0
	db $00
	db $7F
	db $7F
	db $00
	db $F0
	db $FF
	db $FF
	db $80
	db $00
	db $7F
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $01
	db $FF
	db $FF
	db $03
	db $00
	db $FE
	db $FE
	db $10
	db $07
	db $FF
	db $FF
	db $83
	db $3F
	db $FF
	db $FF
	db $FF
	db $C1
	db $FF
	db $FF
	db $E3
	db $FF
	db $FF

gfx_PlayerLeftJump:
	db $01
	db $C0
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $02
	db $03
	db $F0
	db $00
	db $00
	db $00
	db $00
	db $10
	db $02
	db $02
	db $1F
	db $C0
	db $00
	db $00
	db $20
	db $EB
	db $01
	db $00
	db $55
	db $10
	db $00
	db $00
	db $D0
	db $CB
	db $01
	db $02
	db $4D
	db $90
	db $00
	db $00
	db $F0
	db $0A
	db $02
	db $01
	db $9F
	db $80
	db $00
	db $00
	db $00
	db $61
	db $00
	db $00
	db $FF
	db $80
	db $00
	db $00
	db $80
	db $BA
	db $01
	db $03
	db $55
	db $80
	db $00
	db $00
	db $00
	db $BB
	db $02
	db $03
	db $75
	db $C0
	db $00
	db $00
	db $F8
	db $BA
	db $01
	db $00
	db $FD
	db $78
	db $00
	db $00
	db $DC
	db $77
	db $00
	db $00
	db $38
	db $0C
	db $00
	db $00
	db $00
	db $30
	db $00
	db $00
	db $E0
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $70
	db $00
	db $00
	db $00
	db $00
	db $B8
	db $00
	db $00
	db $FC
	db $00
	db $00
	db $00
	db $00
	db $84
	db $00
	db $00
	db $87
	db $F0
	db $00
	db $00
	db $C8
	db $7A
	db $00
	db $00
	db $15
	db $44
	db $00
	db $00
	db $F4
	db $72
	db $00
	db $00
	db $93
	db $64
	db $00
	db $00
	db $BC
	db $82
	db $00
	db $00
	db $67
	db $E0
	db $00
	db $00
	db $40
	db $18
	db $00
	db $00
	db $3F
	db $E0
	db $00
	db $00
	db $A0
	db $6E
	db $00
	db $00
	db $D5
	db $60
	db $00
	db $00
	db $C0
	db $AE
	db $00
	db $00
	db $DD
	db $70
	db $00
	db $00
	db $BE
	db $6E
	db $00
	db $00
	db $3F
	db $5E
	db $00
	db $00
	db $F7
	db $1D
	db $00
	db $00
	db $0E
	db $03
	db $00
	db $00
	db $00
	db $0C
	db $00
	db $00
	db $38
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $2E
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $00
	db $00
	db $21
	db $00
	db $00
	db $21
	db $FC
	db $00
	db $00
	db $B2
	db $1E
	db $00
	db $00
	db $05
	db $51
	db $00
	db $00
	db $BD
	db $1C
	db $00
	db $00
	db $24
	db $D9
	db $00
	db $00
	db $AF
	db $20
	db $00
	db $00
	db $19
	db $F8
	db $00
	db $00
	db $10
	db $06
	db $00
	db $00
	db $0F
	db $F8
	db $00
	db $00
	db $A8
	db $1B
	db $00
	db $00
	db $35
	db $58
	db $00
	db $00
	db $B0
	db $2B
	db $00
	db $00
	db $37
	db $5C
	db $00
	db $80
	db $AF
	db $1B
	db $00
	db $00
	db $0F
	db $D7
	db $80
	db $C0
	db $7D
	db $07
	db $00
	db $00
	db $03
	db $80
	db $C0
	db $00
	db $00
	db $03
	db $00
	db $00
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $07
	db $00
	db $00
	db $00
	db $80
	db $0B
	db $00
	db $00
	db $0F
	db $C0
	db $00
	db $00
	db $40
	db $08
	db $00
	db $00
	db $08
	db $7F
	db $00
	db $80
	db $AC
	db $07
	db $00
	db $00
	db $01
	db $54
	db $40
	db $40
	db $2F
	db $07
	db $00
	db $00
	db $09
	db $36
	db $40
	db $C0
	db $2B
	db $08
	db $00
	db $00
	db $06
	db $7E
	db $00
	db $00
	db $84
	db $01
	db $00
	db $00
	db $03
	db $FE
	db $00
	db $00
	db $EA
	db $06
	db $00
	db $00
	db $0D
	db $56
	db $00
	db $00
	db $EC
	db $0A
	db $00
	db $00
	db $0D
	db $D7
	db $00
	db $E0
	db $EB
	db $06
	db $00
	db $00
	db $03
	db $F5
	db $E0
	db $70
	db $DF
	db $01
	db $00
	db $00
	db $00
	db $E0
	db $30
	db $00
	db $C0
	db $00
	db $00
	db $00
	db $03
	db $80
	db $00
	db $00
	db $00
	db $00
	db $00

gfx_MaskPlayerLeftStatic:
	db $FC
	db $1F
	db $FF
	db $FF
	db $FF
	db $FF
	db $0F
	db $F8
	db $F8
	db $07
	db $FF
	db $FF
	db $FF
	db $3F
	db $00
	db $F8
	db $F8
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $FC
	db $FE
	db $00
	db $07
	db $FF
	db $FF
	db $07
	db $00
	db $FC
	db $F8
	db $00
	db $07
	db $FF
	db $FF
	db $07
	db $00
	db $F8
	db $FC
	db $00
	db $0F
	db $FF
	db $FF
	db $7F
	db $00
	db $FE
	db $FE
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $FC
	db $F8
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $F8
	db $F8
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $FC
	db $FE
	db $00
	db $03
	db $FF
	db $FF
	db $01
	db $00
	db $FF
	db $FF
	db $80
	db $21
	db $FF
	db $FF
	db $F3
	db $07
	db $FF
	db $FE
	db $0F
	db $FF
	db $FF
	db $FF
	db $FF
	db $1F
	db $FF
	db $FF
	db $07
	db $FF
	db $FF
	db $FF
	db $FF
	db $03
	db $FE
	db $FE
	db $01
	db $FF
	db $FF
	db $FF
	db $0F
	db $00
	db $FE
	db $FE
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $FF
	db $FF
	db $80
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $FF
	db $FE
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $FE
	db $FF
	db $00
	db $03
	db $FF
	db $FF
	db $1F
	db $80
	db $FF
	db $FF
	db $80
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FF
	db $FE
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FE
	db $FE
	db $00
	db $01
	db $FF
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $80
	db $00
	db $FF
	db $7F
	db $00
	db $C0
	db $FF
	db $FF
	db $E0
	db $08
	db $7F
	db $FF
	db $FC
	db $C1
	db $FF
	db $FF
	db $83
	db $FF
	db $FF
	db $FF
	db $FF
	db $C7
	db $FF
	db $FF
	db $C1
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $FF
	db $FF
	db $80
	db $7F
	db $FF
	db $FF
	db $03
	db $80
	db $FF
	db $FF
	db $80
	db $01
	db $FF
	db $FF
	db $00
	db $C0
	db $FF
	db $FF
	db $E0
	db $00
	db $7F
	db $7F
	db $00
	db $C0
	db $FF
	db $FF
	db $80
	db $00
	db $7F
	db $7F
	db $00
	db $80
	db $FF
	db $FF
	db $C0
	db $00
	db $FF
	db $FF
	db $07
	db $E0
	db $FF
	db $FF
	db $E0
	db $03
	db $FF
	db $FF
	db $03
	db $C0
	db $FF
	db $FF
	db $80
	db $03
	db $FF
	db $FF
	db $03
	db $80
	db $FF
	db $FF
	db $80
	db $00
	db $7F
	db $3F
	db $00
	db $C0
	db $FF
	db $FF
	db $E0
	db $00
	db $3F
	db $1F
	db $00
	db $F0
	db $FF
	db $FF
	db $F8
	db $02
	db $1F
	db $3F
	db $7F
	db $F0
	db $FF
	db $FF
	db $E0
	db $FF
	db $FF
	db $FF
	db $FF
	db $F1
	db $FF
	db $FF
	db $F0
	db $7F
	db $FF
	db $FF
	db $3F
	db $E0
	db $FF
	db $FF
	db $E0
	db $1F
	db $FF
	db $FF
	db $00
	db $E0
	db $FF
	db $FF
	db $E0
	db $00
	db $7F
	db $3F
	db $00
	db $F0
	db $FF
	db $FF
	db $F8
	db $00
	db $1F
	db $1F
	db $00
	db $F0
	db $FF
	db $FF
	db $E0
	db $00
	db $1F
	db $1F
	db $00
	db $E0
	db $FF
	db $FF
	db $F0
	db $00
	db $3F
	db $FF
	db $01
	db $F8
	db $FF
	db $FF
	db $F8
	db $00
	db $FF
	db $FF
	db $00
	db $F0
	db $FF
	db $FF
	db $E0
	db $00
	db $FF
	db $FF
	db $00
	db $E0
	db $FF
	db $FF
	db $E0
	db $00
	db $1F
	db $0F
	db $00
	db $F0
	db $FF
	db $FF
	db $F8
	db $00
	db $0F
	db $07
	db $00
	db $FC
	db $FF
	db $FF
	db $FE
	db $00
	db $87
	db $CF
	db $1F
	db $FC
	db $FF
	db $FF
	db $F8
	db $3F
	db $FF
	db $FF
	db $7F
	db $FC
	db $FF

gfx_PlayerClimb1:
	db $00
	db $39
	db $80
	db $00
	db $00
	db $40
	db $7E
	db $00
	db $00
	db $7E
	db $40
	db $00
	db $00
	db $20
	db $FB
	db $01
	db $03
	db $55
	db $20
	db $00
	db $00
	db $A0
	db $AA
	db $02
	db $07
	db $57
	db $C0
	db $00
	db $00
	db $00
	db $AA
	db $05
	db $05
	db $FE
	db $00
	db $00
	db $00
	db $00
	db $84
	db $04
	db $06
	db $FE
	db $00
	db $00
	db $00
	db $00
	db $AB
	db $03
	db $00
	db $D5
	db $80
	db $00
	db $00
	db $80
	db $BA
	db $00
	db $00
	db $DD
	db $80
	db $00
	db $00
	db $80
	db $7A
	db $00
	db $00
	db $DD
	db $00
	db $00
	db $00
	db $00
	db $BE
	db $00
	db $00
	db $DE
	db $00
	db $00
	db $00
	db $00
	db $AE
	db $00
	db $00
	db $F0
	db $00
	db $00
	db $00
	db $00
	db $70
	db $00
	db $00
	db $70
	db $00
	db $00
	db $00
	db $00
	db $F0
	db $00

gfx_MaskPlayerClimb1:
	db $FF
	db $80
	db $3F
	db $FF
	db $FF
	db $1F
	db $00
	db $FF
	db $FE
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $FC
	db $F8
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $F8
	db $F0
	db $00
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $F0
	db $F0
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $F0
	db $F0
	db $00
	db $FF
	db $FF
	db $FF
	db $7F
	db $00
	db $F8
	db $FC
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $FE
	db $FE
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $FF
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $FF
	db $00
	db $FE
	db $FE
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FE
	db $FE
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $07
	db $FF
	db $FF
	db $07
	db $FF
	db $FF
	db $FF
	db $FF
	db $07
	db $FE

gfx_PlayerClimb2:
	db $03
	db $38
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $04
	db $04
	db $FC
	db $00
	db $00
	db $00
	db $00
	db $BF
	db $09
	db $09
	db $55
	db $80
	db $00
	db $00
	db $80
	db $AA
	db $0A
	db $07
	db $D5
	db $C0
	db $00
	db $00
	db $40
	db $AB
	db $00
	db $00
	db $FF
	db $40
	db $00
	db $00
	db $40
	db $42
	db $00
	db $00
	db $FE
	db $C0
	db $00
	db $00
	db $80
	db $AB
	db $01
	db $03
	db $56
	db $00
	db $00
	db $00
	db $00
	db $BA
	db $02
	db $03
	db $76
	db $00
	db $00
	db $00
	db $00
	db $BC
	db $02
	db $01
	db $76
	db $00
	db $00
	db $00
	db $00
	db $FA
	db $00
	db $00
	db $F6
	db $00
	db $00
	db $00
	db $00
	db $EA
	db $00
	db $00
	db $1E
	db $00
	db $00
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $1E
	db $00

gfx_MaskPlayerClimb2:
	db $F8
	db $03
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $F0
	db $F0
	db $00
	db $FF
	db $FF
	db $FF
	db $7F
	db $00
	db $E0
	db $E0
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $E0
	db $F0
	db $00
	db $1F
	db $FF
	db $FF
	db $1F
	db $00
	db $F8
	db $FE
	db $00
	db $1F
	db $FF
	db $FF
	db $1F
	db $00
	db $FF
	db $FE
	db $00
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $FC
	db $F8
	db $00
	db $7F
	db $FF
	db $FF
	db $FF
	db $00
	db $F8
	db $F8
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $F8
	db $FC
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FE
	db $FE
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FE
	db $FF
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $C1
	db $FF
	db $FF
	db $C1
	db $FF
	db $FF
	db $FF
	db $FF
	db $C0
	db $FF

gfx_PlayerLieDownRight:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $38
	db $00
	db $00
	db $00
	db $00
	db $4D
	db $D0
	db $F0
	db $47
	db $00
	db $00
	db $07
	db $1E
	db $C6
	db $10
	db $10
	db $C7
	db $F7
	db $1D
	db $7A
	db $AB
	db $47
	db $E0
	db $00
	db $E7
	db $55
	db $FD
	db $EF
	db $AB
	db $E3
	db $00
	db $80
	db $F0
	db $FE
	db $41

gfx_MaskPlayerLieDownRight:
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $C7
	db $1F
	db $0F
	db $82
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $07
	db $07
	db $00
	db $E1
	db $F8
	db $E0
	db $00
	db $00
	db $07
	db $07
	db $00
	db $00
	db $80
	db $00
	db $00
	db $00
	db $0F
	db $1F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $7F
	db $3F
	db $00
	db $00
	db $10

gfx_PlayerLieDownLeft:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $1C
	db $07
	db $0B
	db $B2
	db $00
	db $00
	db $00
	db $00
	db $E2
	db $0F
	db $08
	db $63
	db $78
	db $E0
	db $B8
	db $EF
	db $E3
	db $08
	db $07
	db $E2
	db $D5
	db $5E
	db $BF
	db $AA
	db $E7
	db $00
	db $00
	db $C7
	db $D5
	db $F7
	db $82
	db $7F
	db $0F
	db $01

gfx_MaskPlayerLieDownLeft:
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $F8
	db $E3
	db $FF
	db $FF
	db $FF
	db $FF
	db $41
	db $F0
	db $E0
	db $00
	db $FF
	db $FF
	db $1F
	db $87
	db $00
	db $E0
	db $E0
	db $00
	db $00
	db $07
	db $01
	db $00
	db $00
	db $E0
	db $F0
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $F8
	db $FE
	db $00
	db $00
	db $00
	db $08
	db $00
	db $00
	db $FC

gfx_PlayerLieDownStabRight:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $D0
	db $01
	db $00
	db $00
	db $00
	db $00
	db $03
	db $F0
	db $10
	db $1E
	db $00
	db $00
	db $07
	db $1E
	db $F7
	db $10
	db $E7
	db $AA
	db $F7
	db $1D
	db $7A
	db $AB
	db $55
	db $F9
	db $81
	db $AA
	db $55
	db $FD
	db $EF
	db $AB
	db $DD
	db $01
	db $FE
	db $FF
	db $FE
	db $41

gfx_MaskPlayerLieDownStabRight:
	db $FF
	db $FF
	db $FF
	db $FF
	db $1F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FE
	db $0F
	db $07
	db $FC
	db $FF
	db $FF
	db $FF
	db $FF
	db $E0
	db $07
	db $07
	db $00
	db $E1
	db $F8
	db $E0
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $10

gfx_PlayerLieDownStabLeft:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $07
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $0B
	db $0F
	db $C0
	db $00
	db $00
	db $00
	db $00
	db $78
	db $08
	db $08
	db $EF
	db $78
	db $E0
	db $B8
	db $EF
	db $55
	db $E7
	db $9F
	db $AA
	db $D5
	db $5E
	db $BF
	db $AA
	db $55
	db $81
	db $80
	db $BB
	db $D5
	db $F7
	db $82
	db $7F
	db $FF
	db $7F

gfx_MaskPlayerLieDownStabLeft:
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $F8
	db $F0
	db $7F
	db $FF
	db $FF
	db $FF
	db $FF
	db $3F
	db $E0
	db $E0
	db $07
	db $FF
	db $FF
	db $1F
	db $87
	db $00
	db $E0
	db $00
	db $00
	db $00
	db $07
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $08
	db $00
	db $00
	db $00

gfx_PlayerStabRight:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $01
	db $00
	db $00
	db $03
	db $A0
	db $00
	db $00
	db $E0
	db $07
	db $00
	db $01
	db $FE
	db $20
	db $00
	db $00
	db $20
	db $6B
	db $06
	db $09
	db $D5
	db $C0
	db $00
	db $00
	db $C0
	db $6A
	db $09
	db $06
	db $D5
	db $60
	db $00
	db $00
	db $18
	db $FE
	db $00
	db $00
	db $85
	db $86
	db $00
	db $00
	db $72
	db $F8
	db $01
	db $01
	db $57
	db $0C
	db $00
	db $00
	db $80
	db $AA
	db $02
	db $0F
	db $55
	db $40
	db $00
	db $00
	db $A0
	db $AA
	db $1A
	db $35
	db $7D
	db $60
	db $00
	db $00
	db $A0
	db $C2
	db $2A
	db $35
	db $83
	db $60
	db $00
	db $00
	db $C0
	db $00
	db $7E
	db $E0
	db $00
	db $C0
	db $00
	db $00
	db $F0
	db $00
	db $E0
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $70
	db $00
	db $00
	db $00
	db $00
	db $E8
	db $00
	db $00
	db $F8
	db $01
	db $00
	db $00
	db $7F
	db $88
	db $00
	db $00
	db $C8
	db $9A
	db $01
	db $02
	db $75
	db $70
	db $00
	db $00
	db $B0
	db $5A
	db $02
	db $01
	db $B5
	db $58
	db $00
	db $00
	db $86
	db $3F
	db $00
	db $00
	db $21
	db $61
	db $80
	db $80
	db $1C
	db $7E
	db $00
	db $00
	db $55
	db $C3
	db $00
	db $00
	db $A0
	db $AA
	db $00
	db $03
	db $D5
	db $50
	db $00
	db $00
	db $A8
	db $AA
	db $06
	db $0D
	db $5F
	db $58
	db $00
	db $00
	db $A8
	db $B0
	db $0A
	db $0D
	db $60
	db $D8
	db $00
	db $00
	db $30
	db $80
	db $1F
	db $38
	db $00
	db $30
	db $00
	db $00
	db $3C
	db $00
	db $38
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $3A
	db $00
	db $00
	db $7E
	db $00
	db $00
	db $00
	db $1F
	db $E2
	db $00
	db $00
	db $B2
	db $66
	db $00
	db $00
	db $9D
	db $5C
	db $00
	db $00
	db $AC
	db $96
	db $00
	db $00
	db $6D
	db $56
	db $00
	db $80
	db $E1
	db $0F
	db $00
	db $00
	db $08
	db $58
	db $60
	db $20
	db $87
	db $1F
	db $00
	db $00
	db $15
	db $70
	db $C0
	db $00
	db $A8
	db $2A
	db $00
	db $00
	db $F5
	db $54
	db $00
	db $00
	db $AA
	db $AA
	db $01
	db $03
	db $57
	db $D6
	db $00
	db $00
	db $2A
	db $AC
	db $02
	db $03
	db $58
	db $36
	db $00
	db $00
	db $0C
	db $E0
	db $07
	db $0E
	db $00
	db $0C
	db $00
	db $00
	db $0F
	db $00
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $07
	db $00
	db $00
	db $00
	db $00
	db $0E
	db $80
	db $80
	db $1F
	db $00
	db $00
	db $00
	db $07
	db $F8
	db $80
	db $80
	db $AC
	db $19
	db $00
	db $00
	db $27
	db $57
	db $00
	db $00
	db $AB
	db $25
	db $00
	db $00
	db $1B
	db $55
	db $80
	db $60
	db $F8
	db $03
	db $00
	db $00
	db $02
	db $16
	db $18
	db $C8
	db $E1
	db $07
	db $00
	db $00
	db $05
	db $5C
	db $30
	db $00
	db $AA
	db $0A
	db $00
	db $00
	db $3D
	db $55
	db $00
	db $80
	db $AA
	db $6A
	db $00
	db $00
	db $D5
	db $F5
	db $80
	db $80
	db $0A
	db $AB
	db $00
	db $00
	db $D6
	db $0D
	db $80
	db $00
	db $03
	db $F8
	db $01
	db $03
	db $80
	db $03
	db $00
	db $C0
	db $03
	db $80
	db $03

gfx_MaskPlayerStabRight:
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FE
	db $3F
	db $FF
	db $FF
	db $1F
	db $FC
	db $FF
	db $FF
	db $F8
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FE
	db $F8
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $F0
	db $E0
	db $00
	db $1F
	db $FF
	db $FF
	db $1F
	db $00
	db $E0
	db $F0
	db $00
	db $07
	db $FF
	db $FF
	db $01
	db $00
	db $F8
	db $FE
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $01
	db $FF
	db $FF
	db $33
	db $00
	db $F0
	db $E0
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $C0
	db $80
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $80
	db $80
	db $38
	db $0F
	db $FF
	db $FF
	db $1F
	db $7C
	db $00
	db $01
	db $FE
	db $0F
	db $FF
	db $FF
	db $07
	db $FE
	db $0F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $8F
	db $FF
	db $FF
	db $07
	db $FF
	db $FF
	db $FF
	db $FE
	db $03
	db $FF
	db $FF
	db $03
	db $80
	db $FF
	db $FE
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $00
	db $FC
	db $F8
	db $00
	db $07
	db $FF
	db $FF
	db $07
	db $00
	db $F8
	db $FC
	db $00
	db $01
	db $FF
	db $7F
	db $00
	db $00
	db $FE
	db $FF
	db $80
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $7F
	db $FF
	db $0C
	db $00
	db $FC
	db $F8
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $F0
	db $E0
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $00
	db $E0
	db $E0
	db $0E
	db $03
	db $FF
	db $FF
	db $07
	db $1F
	db $C0
	db $C0
	db $7F
	db $83
	db $FF
	db $FF
	db $81
	db $FF
	db $C3
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $E3
	db $FF
	db $FF
	db $C1
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $FF
	db $FF
	db $00
	db $E0
	db $FF
	db $FF
	db $80
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $FF
	db $FE
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $FE
	db $FF
	db $00
	db $00
	db $7F
	db $1F
	db $00
	db $80
	db $FF
	db $FF
	db $E0
	db $00
	db $0F
	db $0F
	db $00
	db $C0
	db $FF
	db $FF
	db $C0
	db $00
	db $1F
	db $3F
	db $03
	db $00
	db $FF
	db $FE
	db $00
	db $01
	db $FF
	db $FF
	db $00
	db $00
	db $FC
	db $F8
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $F8
	db $F8
	db $03
	db $80
	db $FF
	db $FF
	db $C1
	db $07
	db $F0
	db $F0
	db $1F
	db $E0
	db $FF
	db $7F
	db $E0
	db $FF
	db $F0
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $F8
	db $FF
	db $7F
	db $F0
	db $FF
	db $FF
	db $FF
	db $FF
	db $E0
	db $3F
	db $3F
	db $00
	db $F8
	db $FF
	db $FF
	db $E0
	db $00
	db $3F
	db $3F
	db $00
	db $C0
	db $FF
	db $FF
	db $80
	db $00
	db $7F
	db $7F
	db $00
	db $80
	db $FF
	db $FF
	db $C0
	db $00
	db $1F
	db $07
	db $00
	db $E0
	db $FF
	db $FF
	db $F8
	db $00
	db $03
	db $03
	db $00
	db $F0
	db $FF
	db $FF
	db $F0
	db $00
	db $07
	db $CF
	db $00
	db $C0
	db $FF
	db $FF
	db $80
	db $00
	db $7F
	db $3F
	db $00
	db $00
	db $FF
	db $FE
	db $00
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $FE
	db $FE
	db $00
	db $E0
	db $3F
	db $7F
	db $F0
	db $01
	db $FC
	db $FC
	db $07
	db $F8
	db $3F
	db $1F
	db $F8
	db $3F
	db $FC

gfx_PlayerStabLeft:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $03
	db $05
	db $C0
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $07
	db $04
	db $7F
	db $80
	db $00
	db $00
	db $60
	db $D6
	db $04
	db $03
	db $AB
	db $90
	db $00
	db $00
	db $90
	db $56
	db $03
	db $06
	db $AB
	db $60
	db $00
	db $00
	db $00
	db $7F
	db $18
	db $61
	db $A1
	db $00
	db $00
	db $00
	db $80
	db $1F
	db $4E
	db $30
	db $EA
	db $80
	db $00
	db $00
	db $40
	db $55
	db $01
	db $02
	db $AA
	db $F0
	db $00
	db $00
	db $58
	db $55
	db $05
	db $06
	db $BE
	db $AC
	db $00
	db $00
	db $54
	db $43
	db $05
	db $06
	db $C1
	db $AC
	db $00
	db $00
	db $7E
	db $00
	db $03
	db $03
	db $00
	db $07
	db $00
	db $00
	db $07
	db $00
	db $0F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $00
	db $01
	db $70
	db $00
	db $00
	db $00
	db $00
	db $F8
	db $01
	db $01
	db $1F
	db $E0
	db $00
	db $00
	db $98
	db $35
	db $01
	db $00
	db $EA
	db $E4
	db $00
	db $00
	db $A4
	db $D5
	db $00
	db $01
	db $AA
	db $D8
	db $00
	db $00
	db $C0
	db $1F
	db $06
	db $18
	db $68
	db $40
	db $00
	db $00
	db $E0
	db $87
	db $13
	db $0C
	db $3A
	db $A0
	db $00
	db $00
	db $50
	db $55
	db $00
	db $00
	db $AA
	db $BC
	db $00
	db $00
	db $56
	db $55
	db $01
	db $01
	db $AF
	db $AB
	db $00
	db $00
	db $D5
	db $50
	db $01
	db $01
	db $B0
	db $6B
	db $00
	db $80
	db $1F
	db $C0
	db $00
	db $00
	db $C0
	db $01
	db $C0
	db $C0
	db $01
	db $C0
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $38
	db $00
	db $00
	db $5C
	db $00
	db $00
	db $00
	db $00
	db $7E
	db $00
	db $00
	db $47
	db $F8
	db $00
	db $00
	db $66
	db $4D
	db $00
	db $00
	db $3A
	db $B9
	db $00
	db $00
	db $69
	db $35
	db $00
	db $00
	db $6A
	db $B6
	db $00
	db $00
	db $F0
	db $87
	db $01
	db $06
	db $1A
	db $10
	db $00
	db $00
	db $F8
	db $E1
	db $04
	db $03
	db $0E
	db $A8
	db $00
	db $00
	db $54
	db $15
	db $00
	db $00
	db $2A
	db $AF
	db $00
	db $80
	db $55
	db $55
	db $00
	db $00
	db $6B
	db $EA
	db $C0
	db $40
	db $35
	db $54
	db $00
	db $00
	db $6C
	db $1A
	db $C0
	db $E0
	db $07
	db $30
	db $00
	db $00
	db $30
	db $00
	db $70
	db $70
	db $00
	db $F0
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0E
	db $00
	db $00
	db $17
	db $00
	db $00
	db $00
	db $80
	db $1F
	db $00
	db $00
	db $11
	db $FE
	db $00
	db $80
	db $59
	db $13
	db $00
	db $00
	db $0E
	db $AE
	db $40
	db $40
	db $5A
	db $0D
	db $00
	db $00
	db $1A
	db $AD
	db $80
	db $00
	db $FC
	db $61
	db $00
	db $01
	db $86
	db $84
	db $00
	db $00
	db $7E
	db $38
	db $01
	db $00
	db $C3
	db $AA
	db $00
	db $00
	db $55
	db $05
	db $00
	db $00
	db $0A
	db $AB
	db $C0
	db $60
	db $55
	db $15
	db $00
	db $00
	db $1A
	db $FA
	db $B0
	db $50
	db $0D
	db $15
	db $00
	db $00
	db $1B
	db $06
	db $B0
	db $F8
	db $01
	db $0C
	db $00
	db $00
	db $0C
	db $00
	db $1C
	db $1C
	db $00
	db $3C
	db $00

gfx_MaskPlayerStabLeft:
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FC
	db $7F
	db $FF
	db $FF
	db $FF
	db $FF
	db $3F
	db $F8
	db $F0
	db $1F
	db $FF
	db $FF
	db $FF
	db $7F
	db $00
	db $F0
	db $F0
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $F0
	db $F8
	db $00
	db $07
	db $FF
	db $FF
	db $07
	db $00
	db $F8
	db $E0
	db $00
	db $0F
	db $FF
	db $FF
	db $1F
	db $00
	db $80
	db $00
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $00
	db $00
	db $80
	db $00
	db $3F
	db $FF
	db $FF
	db $0F
	db $00
	db $CC
	db $F8
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $F0
	db $F0
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $F0
	db $F0
	db $1C
	db $01
	db $FF
	db $FF
	db $00
	db $3E
	db $F8
	db $F0
	db $7F
	db $80
	db $7F
	db $7F
	db $F0
	db $7F
	db $E0
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $1F
	db $FF
	db $FF
	db $FF
	db $FF
	db $0F
	db $FE
	db $FC
	db $07
	db $FF
	db $FF
	db $FF
	db $1F
	db $00
	db $FC
	db $FC
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $FC
	db $FE
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $FE
	db $F8
	db $00
	db $03
	db $FF
	db $FF
	db $07
	db $00
	db $E0
	db $C0
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $C0
	db $E0
	db $00
	db $0F
	db $FF
	db $FF
	db $03
	db $00
	db $F3
	db $FE
	db $00
	db $01
	db $FF
	db $FF
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $00
	db $7F
	db $7F
	db $00
	db $00
	db $FC
	db $FC
	db $07
	db $00
	db $7F
	db $3F
	db $80
	db $0F
	db $FE
	db $FC
	db $1F
	db $E0
	db $1F
	db $1F
	db $FC
	db $1F
	db $F8
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $C7
	db $FF
	db $FF
	db $FF
	db $FF
	db $83
	db $FF
	db $FF
	db $01
	db $FF
	db $FF
	db $FF
	db $07
	db $00
	db $FF
	db $FF
	db $00
	db $01
	db $FF
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $80
	db $00
	db $7F
	db $7F
	db $00
	db $80
	db $FF
	db $FE
	db $00
	db $00
	db $FF
	db $FF
	db $01
	db $00
	db $F8
	db $F0
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $F0
	db $F8
	db $00
	db $03
	db $FF
	db $FF
	db $00
	db $C0
	db $FC
	db $FF
	db $80
	db $00
	db $7F
	db $3F
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $1F
	db $1F
	db $00
	db $00
	db $FF
	db $FF
	db $01
	db $C0
	db $1F
	db $0F
	db $E0
	db $83
	db $FF
	db $FF
	db $07
	db $F8
	db $07
	db $07
	db $FF
	db $07
	db $FE
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $F1
	db $FF
	db $FF
	db $FF
	db $FF
	db $E0
	db $FF
	db $FF
	db $C0
	db $7F
	db $FF
	db $FF
	db $01
	db $C0
	db $FF
	db $FF
	db $C0
	db $00
	db $7F
	db $3F
	db $00
	db $C0
	db $FF
	db $FF
	db $E0
	db $00
	db $1F
	db $1F
	db $00
	db $E0
	db $FF
	db $FF
	db $80
	db $00
	db $3F
	db $7F
	db $00
	db $00
	db $FE
	db $FC
	db $00
	db $01
	db $FF
	db $FF
	db $00
	db $00
	db $FC
	db $FE
	db $00
	db $00
	db $FF
	db $3F
	db $00
	db $30
	db $FF
	db $FF
	db $E0
	db $00
	db $1F
	db $0F
	db $00
	db $C0
	db $FF
	db $FF
	db $C0
	db $00
	db $07
	db $07
	db $00
	db $C0
	db $FF
	db $FF
	db $C0
	db $70
	db $07
	db $03
	db $F8
	db $E0
	db $FF
	db $FF
	db $C1
	db $FE
	db $01
	db $C1
	db $FF
	db $81
	db $FF


; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; PAGE $A0
;

	org $a000

PageA0:		
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

PlayerMapX:
	dw $019C
PlayerOnLadder:		; 0 not over ladder, else ladder type number
	db $00
PlayerX:
	db $68
PlayerY:
	db $90
PlayerDir:
	db $02			; Bit 0 0 right 1 left, bit 2 = jump, bit 3 duck, 111 Top of Ladder, 110 Bottom of Ladder
PlayerTempY:		; used to pass structure to background erase like a regular sprite
	db $90
	dw $504D

	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

WeaponX:
	db $6A

WeaponY:
	db $76

WeaponGNO:
	db $14

WeaponYTMP:
	db $76
	dw $4ECD			; PixAddr

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

BaddyData:
	db $01			; TYP
	db $02			; FLAG
	db $00			; XSPD
	db $90			; BASEY
	db $B0			; ???
	db $03			; CNT1
	db $02			; CNT2
	dw $01BF		; MapX
	db $00			; ONLADDER
	db $AC			; XNO
	db $90			; YNO
	db $10			; gno
	db $90			; TEMPY
	dw $5055		; PIXAD

BaddyData2:
	db $01
	db $01
	db $00
	db $90
	db $90
	db $02
	db $02
	db $6E
	db $01
	db $00
	db $0F
	db $90
	db $0F
	db $90
	dw $5041

BaddyData3:
	db $80
	db $02
	db $01
	db $90
	db $B0
	db $03
	db $00
	db $A8
	db $01
	db $00
	db $80
	db $90
	db $13
	db $C8
	dw $5050

BaddyData4:
	db $80
	db $01
	db $01
	db $90
	db $00
	db $04
	db $03
	db $C4
	db $01
	db $00
	db $E6
	db $90
	db $0F
	db $C8
	dw $505C

BaddyData5:
	db $80
	db $01
	db $00
	db $90
	db $00
	db $04
	db $00
	db $6E
	db $01
	db $00
	db $38
	db $90
	db $12
	db $C8
	dw $5047

BaddyData6:			; this slot used by explosions
	db $FF
	db $02
	db $01
	db $00
	db $00
	db $03
	db $01
	db $00
	db $00
	db $00
BaddyData6XNO:
	db $1C
	db $90
	db $1D
	db $C8
	dw $5043

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

gfx_MaskAddresses:
	dw gfx_MaskPlayerRight
	dw gfx_MaskPlayerLeft
	dw gfx_MaskPlayerRight2
	dw gfx_MaskPlayerRightStatic
	dw gfx_MaskPlayerLeftStatic
	dw gfx_MaskPlayerClimb1
	dw gfx_MaskPlayerClimb2
	dw gfx_MaskPlayerLieDownRight
	dw gfx_MaskPlayerLieDownLeft
	dw gfx_MaskPlayerStabRight
	dw gfx_MaskPlayerStabLeft
	dw gfx_MaskRunningBaddyRight1
	dw gfx_MaskRunningBaddyRight2
	dw gfx_MaskRunningBaddyLeft1
	dw gfx_MaskRunningBaddyLeft2
	dw gfx_MaskBazooka
	dw gfx_MaskFlameThrower
	dw gfx_MaskMortarGuyRight
	dw gfx_MaskMortarGuyLeft
	dw gfx_MaskKickLeft
	dw gfx_MaskExplosionSmall
	dw gfx_MaskPlayerLieDownStabRight
	dw gfx_MaskPlayerLieDownStabLeft
	dw gfx_MaskBaddyClimb
	dw gfx_MaskDogRight
	dw gfx_MaskDogLeft
	dw gfx_MaskBaddyLieRight

PreShiftOffs_Weapons:			; pre shift offsets for weapons
	dw $0000
	dw $0020
	dw $0040
	dw $0060

PreShiftOffs_Dogs:			; pre shift offsets for dogs
	dw $0000
	dw $0040
	dw $0080
	dw $00C0

PreShiftOffs_Characters:			; pre shift offsets for characters
	dw $0000
	dw $0060
	dw $00C0
	dw $0120

MissileTopsX:
	db $00
	db $00
	db $00
	
MineXPositions:
	db $00
	db $E6
	db $00

MineMaskAddr:
	dw gfx_MineMask1
	dw gfx_MineMask2
	dw gfx_MineMask3
	dw gfx_MineMask4

MissileTopAddr:
	dw gfx_MissileTop1
	dw gfx_MissileTop2
	dw gfx_MissileTop3
	dw gfx_MissileTop4

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; Bullet structs 7 bytes each
;

BaddyBullets:		
	db $80			; GNO
	db $FD			; XNO
	db $78			; YNO
	db $E0			;
	db $48			;
	db $64			;
	db $CF			;

	db $80
	db $00
	db $18
	db $60
	db $40
	db $54
	db $CF
	
	db $80
	db $00
	db $18
	db $60
	db $40
	db $54
	db $CF
	
	db $80
	db $00
	db $18
	db $60
	db $40
	db $54
	db $CF

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


KnifeXNO:
	db $7E
KnifeYNO:
	db $9A
KnifeGNO:
	db $00
KnifeClear:
	db $9A
	dw $526F

GrenadeX:
	db $28
GrenadeY:
	db $78
GrenadeGNO:
	db $02
GrenadeClear:
	db $00
	dw $0000

MortarBombX:
	db $20
MortarBombY:
	db $A4
	db $04
	db $9E
	dw $5664

SmallWeaponSprites:
	dw gfx_KnifeLeft		; knife left
	dw gfx_KnifeRight		; knife right
	dw gfx_BulletRight		; bullet right
	dw gfx_BulletLeft		; bullet left
	dw gfx_Mortar			; Mortar
	dw gfx_Grenade			; grenade

BossBaddyX:
	db $28
BossBaddyY:
	db $18
data_A120_4:
	db $28
	db $18
data_A122_4:
	dw $0000

BossBaddyX2:
	db $46
	db $34
data_A126_4:
	db $46
	db $34
	dw $0000

BossBaddyX3:
	db $96
	db $30
data_A12C_4:
	db $96
	db $30
	dw $0000

TruckX:
	db $00
	db $80
TruckX2:
	db $00
	db $80
data_A134_4:
	dw $0000

FlameThrowerX:
	db $10
FlameThrowerY:
	db $90
FlameThrowerXNew:
	db $10
FlameThrowerYNew:
	db $90
FlameThrowerSpriteData2:
	dw $0000

SP_Store:
	dw $FEF7
FrameToggle:
	db $00
PlayingSound:
	db $00
PlayingSoundAddr:
	dw $5E91
	db $00

TruckSpriteData:
	dw gfx_Truck
	db $92
	db $CB
	db $00
	db $00

Score:
	db $30
	db $30
	db $33
	db $31
	db $30
	db $30

HighScore:
	db $30
	db $33
	db $30
	db $30
	db $30
	db $30

KeyTab:
	db $7F
	db $FB
	db $7F
	db $FE
	db $FB
	db $FE
	db $FD
	db $FE
	db $DF
	db $FD
	db $DF
	db $FE

MapLadderAddr:
	dw $5C45
MapLandRow1:			; first horizontal map row the player can land on
	dw $5CFD
MapLandRow2:			; second horizontal map row the player can land on
	dw $5D05
ParachuteTriggerAddr:
	dw $5DB5
MortarTriggerAddr:
	dw $5E0D
WeaponTriggerAddr:
	dw $5E35
MineTriggerAddr:
	dw $5DBD

	db $00
	db $00
	db $00
	db $00

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

FrontEndDone:
	JP   StabToStart

JP_PixAddr:
	JP   PixAddr

JP_DumpBackBuffer:
	JP   DumpBackBuffer

JP_InitLevel:
	JP   InitLevel

JP_PlaySound:
	JP   PlaySound

JP_FindSpareBullet:
	JP   FindSpareBullet

JP_AddScore:
	JP   AddScore

JP_CheckOnLadder:
	JP   CheckOnLadder

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

StabToStart:			; start point main game (post the one shot input method selection)
	DI  
	LD   HL,ISR
	LD   (ISRJumpAddr+1),HL

	CALL JP_Sprint
	db MODE, EXPAND, $02
	db PEN, $44
	db AT, $02, $01
	db "STAB TO START"
	db MODE, RESETP
	db FIN

	EI  
WaitStab:
	HALT
	CALL Keys
	BIT  4,(IY+$28)			; FUDLR
	JR   Z,WaitStab

	CALL ResetGame
	
	CALL PlayGame			; play a complete game end to end

	CALL JP_Sprint
	db JSR					; $08
	dw JP_FillAttrBlocks	; $5B09
	db $0A, $07				; x, y
	db $15, $09				; w, h
	db $00					; attr
	db FIN
	db PEN, $07
	db AT, $0B, $08
	db "GAME  OVER"
	db PEN, $FF
	db FIN

	LD   DE,Score
	LD   HL,HighScoreText
	LD   BC,$0006
	PUSH BC
	PUSH DE
	PUSH HL
	CALL StrCmp
	POP  DE
	POP  HL
	POP  BC
	JR   C,StabToStart
	PUSH DE
	LDIR

	LD   HL,$0018
	LD   (Variables),HL
	POP  HL
	CALL PrintHighScore
	JR   StabToStart

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlayGame:
	LD   A,(LevelNumber)
	AND  $03
	ADD  A,A
	ADD  A,A
	LD   C,A
	ADD  A,A
	ADD  A,C
	LD   HL,LevelNames
	CALL AddHLA
	LD   DE,LevelNameText
	LD   BC,$000C
	LDIR
	
	CALL JP_Sprint
	db CLA
	db CLS
	db FIN

	LD   HL,Variables
	LD   DE,Variables+1
	LD   BC,$0057
	LD   (HL),$00
	LDIR

	LD   HL,gfx_MapTiles			; tile graphics
	LD   (MapTileAddress),HL
	CALL JP_DrawCaptives			; draw the firing squad wall

	CALL JP_Sprint
	db MODE, RESETP
	db AT, $0A, $09
	db PEN, $47
LevelNameText:
	db "MISSILE BASE"				; modified
	db AT, $07, $04
	db PEN, $02
	db "RESCUE THE CAPTIVES"
	db FIN

	EI  
	CALL DoAlarm
	CALL ResetVariables
	CALL ResetBaddies
	CALL JP_WipeLevelOn

StartLevel:
	CALL ResetLevel
	CALL InitBaddyBullets
	CALL JP_Sprint
	db AT, $02, $16
	db TABX
	db PEN, $47
	db REP, " ", $10
	db RTN
	db REP, " ", $10
	db PEN, $FF
	db FIN

	CALL MainLoop

	INC  (IY+$5D)			; FFDF - LevelNumber
	LD   A,(isDead)
	OR   A
	JR   NZ,LoseLife

	LD   A,(LevelNumber)
	AND  $03
	CALL Z,JP_DoGameEnding
	
	LD   HL,(StageNumberText)
	LD   A,H
	INC  A
	CP   $3A			; "9"+1
	JR   NZ,label_A2A8
	
	INC  L
	LD   A,$30			; "0"
label_A2A8:
	LD   H,A
	LD   (StageNumberText),HL
	JP   PlayGame

LoseLife:
	DEC  (IY+$5D)			; FFDF - LevelNumber
	EI  
	DEC  (IY+$61)			; FFE3 - Lives
	RET  Z

	CALL DrawLives
	LD   B,$64
	CALL HaltB
	LD   HL,BaddyData
	LD   B,$06
ResetBaddy:
	LD   A,(HL)
	OR   A
	JP   M,NextBaddyReset

	LD   (HL),$80
NextBaddyReset:
	LD   A,$10
	ADD  A,L
	LD   L,A
	DJNZ ResetBaddy

	LD   C,$20						; 32 pixel high clear
	LD   A,(ParachuteGuyTriggered)
	OR   A
	CALL M,ClearScreenBlock

	LD   A,(EndofLevelTrigger)
	OR   A
	JR   Z,StartLevel
	LD   A,(LevelNumber)
	AND  $03
	ADD  A,A
	LD   HL,EOLTriggerFunctions
	CALL AddHLA
	CALL JPIndex
	LD   (IY+$40),$01				; FFC2 - EndOfLevelTrigger
	JP   StartLevel

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; Interrupt routine
;

ISR:
	DI  
	PUSH AF
	LD   A,$FF
	LD   R,A
	POP  AF
	EI  
	RETI

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

HaltB:
	HALT
	DJNZ HaltB
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

LevelNames:
	db "MISSILE BASE"
	db "  HARBOUR   "
	db "   BRIDGE   "
	db "PRISON  CAMP"

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

FlashAndSound:
	LD   HL,$5887		; attr line of text
	LD   B,$14			; 20 chars
FlashLoop:
	LD   A,(HL)
	XOR  $04
	LD   (HL),A
	INC  L
	DJNZ FlashLoop

	LD   HL,$592A
	LD   B,$0C			; 12 chars
label_A345:
	LD   A,(HL)
	INC  A
	AND  $47			; 0100 0111
	LD   (HL),A
	INC  L
	DJNZ label_A345
	
	XOR  A
	LD   R,A
	LD   C,E
	JP   PlayTone

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DoAlarm:
	LD   B,$03			; 3 alarm cycles
AlarmLoop:
	PUSH BC
	LD   E,$FE			; initial pitch
PitchUpLoop:
	CALL FlashAndSound
	LD   A,E
	SUB  $0A			; pitch up
	LD   E,A
	CP   $64
	JR   NC,PitchUpLoop
	
	LD   B,$32
	LD   E,$64
PitchHoldLoop:
	PUSH BC			; hold the tone
	CALL FlashAndSound
	POP  BC
	DJNZ PitchHoldLoop
	
	LD   E,$64
PitchDownLoop:
	CALL FlashAndSound
	LD   A,E
	ADD  A,$06			; pitch down
	LD   E,A
	JR   NC,PitchDownLoop
	
	POP  BC
	DJNZ AlarmLoop
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;


MainLoop:
	CALL UpdateSFX
	LD   A,(V_HasScrolled)
	LD   R,A
	CALL DrawMissileTops
	CALL Delay
	CALL DumpBackBuffer
	CALL DrawSprites
	CALL StageEndAttacks
	CALL TriggerMissileTops
	CALL TriggerMines
	CALL TriggerMortarGuys
	CALL UpdateMortarBomb
	CALL TriggerParachuteGuys
	CALL WeaponTriggers
	CALL CollideWeaponsToMines
	CALL PrintScore
	CALL UpdateWeaponSounds
	CALL JP_DecodeMap
	XOR  A
	LD   (V_HasScrolled),A
	LD   A,(FUDLR)
	LD   (LastFUDLR),A
	CALL Keys
	CALL PlayerCollideToWorld
	CALL PlayerMovement
	LD   A,(V_HasScrolled)
	LD   R,A
	CALL DoScroll
	CALL Baddies
	CALL CalcWeaponOffset
	CALL TryShootWeapon
	CALL UpdateBullets
	CALL IntroduceBaddies
	CALL UpdateExplosion
	CALL UpdateCountersAndLives

	if NO_BADDY_COLLISIONS != 1
		CALL CollideWithPlayer			; collision
	endif

	INC  (IY+$13)						; +$13 FrameCounter
	EI  
	JP   MainLoop

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlayerMovement:
	LD   A,(DeathCounter)
	OR   A
	JP   Z,JP_UpdatePlayerMovement

	DEC  A
	LD   (DeathCounter),A
	JR   NZ,DeathWobble
	
	DEC  A
	LD   (isDead),A
	POP  HL
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DeathWobble:
	BIT  0,(IY+$13)			; FrameCounter
	RET  NZ

	LD   A,(PlayerX)		; wobble player whilst exploding
	XOR  $04
	LD   (PlayerX),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateWeaponSounds:
	LD   A,(PlayingSound)
	OR   A
	JP   NZ,UpdateSFX

	EI  
	XOR  A
	LD   R,A
	LD   A,(FlameThrowerInFlight)
	OR   A
	JR   NZ,FlameThrowerSound

	LD   A,(MortarInFlight)
	OR   A
	JP   Z,UpdateSFX

	LD   A,(MortarBombY)
	SUB  $68
	ADD  A,A
	LD   C,A
	JP   SetNoise

FlameThrowerSound:
	DEC  A
	LD   (FlameThrowerInFlight),A
	AND  $03
	XOR  $03
	INC  A
	LD   C,A
	JP   SetNoise

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ResetGame:
	LD   HL,Score
	LD   DE,Score+1
	LD   BC,$000B
	LD   (HL),$30			; "0"
	LDIR
	LD   A,$33
	LD   (HighScore+1),A
	LD   HL,$3130			; "01"
	LD   (StageNumberText),HL
	
	if START_LEVEL == 0
	XOR  A
	else
	LD	 A, START_LEVEL
	endif
	LD   (LevelNumber),A
	
	LD   (IY+$61),$03			; $FFE3 - Lives
	LD   (IY+$60),$28			; $FFE2 - EOLBaddyCountdownTime
	LD   (IY+$5F),$07			; $FFE1 - RandMask
	LD   (IY+$5E),$14			; $FFE0 - BaddyCountdownTime
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ResetVariables:
	XOR  A
	LD   (TruckX),A
	LD   (TruckX2),A
	LD   HL,Baddy_RunAndGun			; Baddy routine 0
	LD   (BaddyRoutines),HL
	LD   HL,$00A6
	LD   (LevelCountdown),HL
	LD   L,A
	LD   H,A
	LD   (MapX),HL
	LD   (MissileTopsX),HL
	LD   (MissileTopsX+1),HL
	DEC  A
	LD   (RND4),A
	LD   (RND1),A
	LD   (IY+$3F),$C0			; FFC1 - MapPlayerX
	LD   (IY+$36),$68			; FFB0 - ScrollBoundary
	LD   (IY+$39),$24			; FFBB - MortarFireCountdown
	LD   (IY+$15),$01			; FF97 - Unused+1

	LD   A,(LevelNumber)
	AND  $03
	ADD  A,A
	LD   HL,LevelData
	CALL AddHLA
	CALL HLFromHL
								; Setup level data
	CALL DEFromHL				
	LD   (MapLadderAddr),DE	

	CALL DEFromHL
	LD   (MapLandRow1),DE		; platform positions on row 1 of the map

	CALL DEFromHL
	LD   (MapLandRow2),DE		; platform positions on row 2 of the map

	CALL DEFromHL
	LD   (MortarTriggerAddr),DE

	CALL DEFromHL
	LD   (WeaponTriggerAddr),DE

	CALL DEFromHL
	LD   (MineTriggerAddr),DE

	CALL HLFromHL
	LD   (ParachuteTriggerAddr),HL

	CALL JP_Sprint
	db CLA
	db CLS
	db MODE, RESETP
	db JSR
	dw JP_FillAttrBlocks		; $5B09
	db $02, $00					; x, y
	db $1D, $03					; w, h
	db $47						; attr
	db $02, $16
	db $1D, $17
	db $47
	db $00, $03
	db $1F, $03
	db $00
	db FIN
	db PEN, $42
	db AT, $12, $02
	db "STAGE"
	db AT, $02, $00
	db "SCORE"
	db XTO, $12
	db "HIGH"
	db PEN, $FF
	db AT, $1C, $02
StageNumberText:
	db "01"
	db FIN							; fin

	DI  
	CALL DrawLives
	CALL PrintScore
	LD   A,$18
	LD   (V_ScrnX),A
	LD   HL,HighScoreText
	CALL PrintHighScore
	CALL DoDrawFloor
	JP   JP_SetupLevelMap

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

HighScoreText:
	db $30
	db $33
	db $33
	db $30
	db $30
	db $30

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ResetLevel:
	LD   HL,$9040
	LD   (PlayerX),HL
	LD   A,$19
	LD   (EOLBaddyCountdown),A
	LD   (NextBaddyCountdown),A
	XOR  A
	LD   (PlayerDir),A
	LD   (PlayingSound),A
	LD   (isInAir),A
	LD   (isSnappedToLadder),A
	LD   (PlayerLieDown),A
	LD   (isShooting),A
	LD   (isDead),A
	LD   (DeathCounter),A
	LD   (MortarInFlight),A
	LD   (ParachuteGuyTriggered),A
	LD   (EOLEndCountdown),A
	LD   L,A
	LD   H,A
	LD   (MineXPositions),HL
	LD   (MineXPositions+1),HL
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateCountersAndLives:
	LD   A,R
	JP   M,NewLifeCheck

	LD   A,(EndofLevelTrigger)			; only updated if we've moved
	OR   A
	JR   NZ,NewLifeCheck

	LD   HL,(LevelCountdown)
	DEC  HL
	LD   A,H
	OR   L
	JR   NZ,SetCountdown

	LD   A,(EOLBaddyCountdownTime)
	SUB  $02
	JR   NZ,NotDone

	LD   A,(RandMask)
	SRL  A
	OR   $01
	LD   (RandMask),A
	LD   A,$01

NotDone:
	LD   (EOLBaddyCountdownTime),A
	LD   HL,$0042
	JR   SetCountdown

NewLifeCheck:
	LD   HL,$0085
SetCountdown:
	LD   (LevelCountdown),HL
	LD   DE,Score
	LD   HL,HighScore
	LD   B,$06
	CALL StrCmp
	RET  C

	LD   HL,HighScore
	LD   DE,$0701
	CALL AddScoreToHL
	LD   A,(Lives)			; extra life
	INC  A
	LD   (Lives),A
	CP   $07
	RET  NC					; up to a max of 7

DrawLives:
	CALL JP_Sprint
	db PEN, $46
	db AT, $02, $01
	db FIN

	LD   B,(IY+$61)			; FFE3 - Lives

DrawNextLife:
	PUSH BC
	CALL JP_Sprint
	db PEN, $46
	db TABX			
	db $22					; hammer and sickle
	db $23
	db RTN
	db $24					; hammer and sickle
	db $25
	db BACKSP, $00
	db FIN			
	
	POP  BC
	DJNZ DrawNextLife
	
	CALL JP_Sprint
	db PEN, $FF
	db TABX
	db "  "
	db RTN			
	db "  "
	db FIN

	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawDogs:
	ADD  A,L
	LD   L,A
	LD   A,low PreShiftOffs_Dogs		; a0be low - pre shift offsets for dogs
	LD   (PreShiftOffsetMod+1),A
	CALL DrawSprite

	LD   A,low PreShiftOffs_Characters	; a0c6 low - regular preshift offset tables for characters
	LD   (PreShiftOffsetMod+1),A
	JR   DoNext

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawSprites:
	LD   HL,PlayerTempY				;erase the background above the scroll area
	CALL EraseSpriteAboveMap24
	LD   HL,BaddyData+13			;+13 = TEMPY
	CALL EraseSpriteAboveMap24
	LD   HL,BaddyData2+13
	CALL EraseSpriteAboveMap24
	LD   HL,BaddyData3+13
	CALL EraseSpriteAboveMap24

	CALL DrawWeapon
	CALL DrawBullets
	LD   HL,PlayerX
	CALL DrawSprite					; draw player
	LD   A,(MortarInFlight)
	OR   A
	JR   Z,NoMortar

	LD   HL,MortarBombX
	CALL DrawSmallWeapon

NoMortar:
	LD   HL,BaddyData
	LD   B,$05

DrawNextBaddy:
	LD   A,(HL)
	OR   A
	JP   M,BaddyOff
	
	PUSH BC
	PUSH HL
	CP   T_DOGRIGHTANDJUMP		; $0B TYP = DOGRIGHT
	LD   A,$0A			; sprite info +10 bytes into structure
	JR   NC,DrawDogs	; > TYP 11 (DOGS)

	ADD  A,L
	LD   L,A			; HL points to sprite data structure
	CALL DrawSprite

DoNext:
	POP  HL
	POP  BC

BaddyOff:
	LD   A,$10
	ADD  A,L
	LD   L,A
	DJNZ DrawNextBaddy

	LD   HL,BaddyData6XNO+3
	CALL EraseSpriteAboveMap24
	LD   HL,BaddyData6
	LD   A,(HL)
	OR   A
	JP   M,BaddyOff2

	LD   A,$0A			; sprite info +10 bytes into structure
	ADD  A,L
	LD   L,A
	CALL DrawSprite

BaddyOff2:
	CALL DrawMines
	CALL DrawFloor
	LD   HL,BaddyData
	LD   B,$06
DoNextBaddy:
	LD   A,(HL)
	OR   A
	JP   P,BaddyActive

	PUSH HL
	LD   A,$0D			; BaddyStructure + YTMP
	ADD  A,L
	LD   L,A			; Baddystructure + $0D
	LD   (HL),$C8			; YTMP??
	POP  HL

BaddyActive:
	LD   A,$10			; move on 16 bytes in baddy structure
	ADD  A,L
	LD   L,A
	DJNZ DoNextBaddy

	LD   A,(DeathCounter)
	OR   A
	RET  NZ

	LD   A,(PlayerX)
	CP   (IY+$36)			; ScrollBoundary
	RET  C
	LD   A,(ScrollBoundary)
	LD   (PlayerX),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawWeapon:
	LD   A,(isShooting)
	OR   A

WeaponMod:
	CALL NZ,DrawBigWeapon
	LD   A,(HasWeapon)
	OR   A
	JR   Z,SkipWeapon

	CP   $03
	JR   Z,SkipWeapon

	LD   A,low PreShiftOffs_Weapons		;$B6; $a0b6 low byte - WeaponShiftTables
	LD   (PreShiftOffsetMod+1),A
	LD   HL,WeaponYTMP
	CALL EraseSpriteAboveMap8

	LD   HL,WeaponX
	CALL DrawSprite
	
	LD   A,low PreShiftOffs_Characters	;$C6; $a0c6 low byte regular character preshift offset tables
	LD   (PreShiftOffsetMod+1),A

SkipWeapon:
	LD   A,(IsStabbing)
	DEC  A
	JR   Z,NoStab

	DEC  A
	RET  NZ

	LD   HL,KnifeXNO
	JP   DrawSmallWeapon

NoStab:
	LD   HL,KnifeClear
	JP   ClearWeaponBackground

DrawBigWeapon:
	LD   HL,GrenadeClear
	CALL ClearWeaponBackground
	
	LD   HL,GrenadeX
	JP   DrawSmallWeapon

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Keys:
	LD   A,(ControlMethod)
	DEC  A
	JR   Z,KeyRead

	DEC  A
	JR   Z,Kempston

	LD   BC,$0500
	CALL JoyRead

ReadInput:
	LD   B,$06
	LD   HL,JoyTable
JoyIn:
	LD   A,(HL)
	INC  HL
	IN   A,($FE)
	OR   $E0
	INC  A
	JR   NZ,label_A6FC
	DJNZ JoyIn

	LD   A,C
	JR   label_A71D

label_A6FC:
	LD   A,C
	ADD  A,$20
	JR   label_A71D

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Kempston:
	XOR  A
	IN   A,($1F)
	AND  $1F
	LD   C,A
	JR   ReadInput

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

KeyRead:
	LD   BC,$0600
JoyRead:
	LD   HL,KeyTab
KeyIn:
	LD   A,(HL)
	INC  HL
	IN   A,($FE)
	OR   (HL)
	INC  HL
	ADD  A,$01
	CCF
	RL   C
	DJNZ KeyIn

	LD   A,C
label_A71D:
	LD   (FUDLR),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

AddScore:
	LD   HL,Score
AddScoreToHL:
	LD   A,D
	LD   D,$00
	ADD  HL,DE
	ADD  A,(HL)
label_A729:
	LD   B,A
	SUB  $3A
	JR   NC,label_A730

	LD   (HL),B
	RET 

label_A730:
	ADD  A,$30
	LD   (HL),A
	DEC  HL
	LD   A,(HL)
	OR   A
	RET  Z
	INC  A
	JR   label_A729

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PrintScore:
	LD   HL,$0008
	LD   (Variables),HL			; SCRNX
	LD   HL,Score
PrintHighScore:
	LD   BC,$0600
label_A746:
	LD   A,C
	OR   A
	LD   A,(HL)
	JR   NZ,NonZero

	LD   A,(HL)
	CP   $30
	JR   NZ,NonZero

	DEC  C
	LD   A,$20
NonZero:
	INC  C
	PUSH BC
	CALL JP_PRChar
	POP  BC
	INC  HL
	DJNZ label_A746
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawFloor:
	LD   A,R
	RET  P

DoDrawFloor:			; rotate and draw repeating floor pattern
	LD   A,$05			; ground is 5 pixels high
	LD   HL,$51BE
	LD   BC,gfx_Floor
	LD   (SP_Store),SP

FloorLoop:
	EX   AF,AF'
	LD   A,(BC)			; rotate and wrap floor two pixels to the left
	RLCA
	RLCA
	LD   (BC),A
	INC  BC
	LD   SP,HL
	LD   E,A
	LD   D,A
	PUSH DE
	PUSH DE
	PUSH DE
	PUSH DE
	PUSH DE
	PUSH DE
	PUSH DE
	PUSH DE
	PUSH DE
	PUSH DE
	PUSH DE
	PUSH DE
	PUSH DE
	PUSH DE
	INC  H
	EX   AF,AF'
	DEC  A
	JR   NZ,FloorLoop

	LD   SP,(SP_Store)
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;
TempX:
	db $0C
TempY:
	db $90

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawSprite:
	LD   E,(HL)
	INC  L
	LD   D,(HL)
	LD   (TempX),DE		; store X,Y
	INC  L
	LD   C,(HL)			; GNO
	INC  L
	LD   (HL),D
	INC  L
	PUSH HL
	CALL PixAddr
	POP  DE
	EX   DE,HL
	LD   (HL),E			; screen addr of sprite
	INC  L
	LD   (HL),D
	PUSH DE
	LD   A,C			; GNO
	ADD  A,A
	ADD  A,A			; x4
	LD   C,A
	LD   B,$00
	LD   HL,SpriteTable	; base address of sprite lookup table
	ADD  HL,BC
	LD   E,(HL)
	INC  HL
	LD   D,(HL)			; DE = Sprite Data
	INC  HL
	LD   A,(HL)			; sprite height
	INC  HL
	EX   AF,AF'
	LD   A,(HL)			; mask index
	ADD  A,A			; x 2
	ADD  A,low gfx_MaskAddresses	;$80
	LD   L,A
	LD   H,high gfx_MaskAddresses	;$A0
	LD   A,(HL)			; $a080 (gfx_MaskAddresses)
	INC  L
	LD   H,(HL)
	LD   L,A
	PUSH HL				; HL address of sprite mask
	LD   A,(TempX)
	AND  $06			; 0000 0110 - even X from 0..7

PreShiftOffsetMod:
	ADD  A,$C6			; selfmod to Offset tables in Page $A0
	LD   L,A
	LD   H,high PageA0	; PAGE $A0 - $a0c6 / $a0b6 / $a0be
	LD   C,(HL)
	INC  L
	LD   B,(HL)
	LD   L,C			; HL = sprite offset
	LD   H,B
	ADD  HL,DE			; offset + DE (sprite data addr)
	EX   DE,HL
	POP  HL				; hl address of sprite mask
	ADD  HL,BC			; + BC offset
	LD   C,L
	LD   B,H			; bc = mask data
	EX   DE,HL
	POP  DE				; de = screen addr
	LD   (SP_Store),SP
	LD   SP,HL			; SP = sprite data
	EX   DE,HL			; HL=screen addr
	LD   A,(TempY)
	CP   $52			; y < $52 (82) - use sprite OR routine as there's nothing to mask against
	JR   C,SpriteOR

	EX   AF,AF'
DrawNextLine:
	EX   AF,AF'			; 'AF = sprite height
	POP  DE				; 2 bytes of sprite
	LD   A,(BC)			; mask
	AND  (HL)			; and out of screen
	OR   E				; or in sprite
	LD   (HL),A			; store back in screen
	INC  L
	INC  C
	LD   A,(BC)
	AND  (HL)
	OR   D
	LD   (HL),A
	INC  L
	INC  BC

	POP  DE
	LD   A,(BC)
	AND  (HL)
	OR   E
	LD   (HL),A
	INC  L
	INC  C
	LD   A,(BC)
	AND  (HL)
	OR   D
	LD   (HL),A
	INC  H
	INC  BC

	POP  DE
	LD   A,(BC)
	AND  (HL)
	OR   E
	LD   (HL),A
	DEC  L
	INC  C
	LD   A,(BC)
	AND  (HL)
	OR   D
	LD   (HL),A
	DEC  L
	INC  BC

	POP  DE
	LD   A,(BC)
	AND  (HL)
	OR   E
	LD   (HL),A
	DEC  L
	INC  C
	LD   A,(BC)
	AND  (HL)
	OR   D
	LD   (HL),A
	INC  H
	INC  BC

	LD   A,H
	AND  $07
	JR   NZ,SprSkipLine

	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,SprSkipLine
	
	LD   A,H
	SUB  $08
	LD   H,A
SprSkipLine:
	EX   AF,AF'			; retrieve sprite height
	DEC  A
	JR   NZ,DrawNextLine
	
	LD   SP,(SP_Store)
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

SpriteOR:
	EX   AF,AF'
DrawNextLine2:
	EX   AF,AF'
	POP  DE
	LD   A,(HL)
	OR   E
	LD   (HL),A
	INC  L
	LD   A,(HL)
	OR   D
	LD   (HL),A
	INC  L
	POP  DE

	LD   A,(HL)
	OR   E
	LD   (HL),A
	INC  L
	LD   A,(HL)
	OR   D
	LD   (HL),A
	INC  H
	POP  DE

	LD   A,(HL)
	OR   E
	LD   (HL),A
	DEC  L
	LD   A,(HL)
	OR   D
	LD   (HL),A
	DEC  L
	
	POP  DE
	LD   A,(HL)
	OR   E
	LD   (HL),A
	DEC  L
	LD   A,(HL)
	OR   D
	LD   (HL),A
	INC  H
	LD   A,H
	AND  $07
	JR   NZ,SprSkipLine2

	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,SprSkipLine2

	LD   A,H
	SUB  $08
	LD   H,A

SprSkipLine2:
	EX   AF,AF'
	DEC  A
	JR   NZ,DrawNextLine2

	LD   SP,(SP_Store)
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

EraseSpriteAboveMap8:
	LD   A,$68			; 104 top of the map on screen
	SUB  (HL)
	RET  C
	RET  Z

	CP   $08
	JR   C,StartClear	; < 8

	LD   A,$08
	JR   StartClear

EraseSpriteAboveMap24:
	LD   A,$68			; 104 top of the map on screen
	SUB  (HL)
	RET  C
	RET  Z

	CP   $18
	JR   C,StartClear	; < 24

	LD   A,$18
StartClear:
	SRL  A
	LD   B,A			; B lines to clear
	LD   C,$00
	INC  L
	LD   A,(HL)
	INC  L
	LD   H,(HL)
	LD   L,A			; HL address to clear

.ClearLoop:
	LD   (HL),C
	INC  L
	LD   (HL),C
	INC  L
	LD   (HL),C
	INC  L
	LD   (HL),C
	INC  H
	LD   (HL),C
	DEC  L
	LD   (HL),C
	DEC  L
	LD   (HL),C
	DEC  L
	LD   (HL),C
	INC  H
	LD   A,H
	AND  $07
	JR   NZ,.Skip

	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,.Skip

	LD   A,H
	SUB  $08
	LD   H,A

.Skip:
	DJNZ .ClearLoop
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; offsets to each shifted version of a small (16 * 8) weapon graphic
;

SmallWeaponShiftOffsets:			
	db $00
	db $20
	db $40
	db $60

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawSmallWeapon:
	LD   A,(HL)
	LD   E,A
	EX   AF,AF'
	INC  HL
	LD   D,(HL)
	INC  HL
	LD   C,(HL)
	INC  HL
	LD   (HL),D
	INC  HL
	PUSH HL
	CALL PixAddr
	POP  DE
	EX   DE,HL
	LD   (HL),E
	INC  HL
	LD   (HL),D
	PUSH DE
	LD   A,C
	ADD  A,A
	LD   C,A
	LD   B,$00
	LD   HL,SmallWeaponSprites
	ADD  HL,BC
	LD   E,(HL)
	INC  HL
	LD   D,(HL)			; de = sprite data address
	EX   AF,AF'
	AND  $06
	SRL  A
	LD   C,A
	LD   HL,SmallWeaponShiftOffsets
	ADD  HL,BC
	LD   L,(HL)
	LD   H,B
	ADD  HL,DE			; HL = sprite address at correct shift pos
	POP  DE
	LD   (SP_Store),SP
	LD   SP,HL
	EX   DE,HL
	LD   B,$04			; four pixels high

NextSprLine:
	POP  DE
	LD   A,E
	AND  (HL)
	OR   D
	LD   (HL),A
	INC  L

	POP  DE
	LD   A,E
	AND  (HL)
	OR   D
	LD   (HL),A
	INC  H

	POP  DE
	LD   A,E
	AND  (HL)
	OR   D
	LD   (HL),A
	DEC  L

	POP  DE
	LD   A,E
	AND  (HL)
	OR   D
	LD   (HL),A
	INC  H
	LD   A,H
	AND  $07
	JR   NZ,SkipLine

	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,SkipLine
	
	LD   A,H
	SUB  $08
	LD   H,A
SkipLine:
	DJNZ NextSprLine
	LD   SP,(SP_Store)
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ClearWeaponBackground:
	LD   A,$68				;104
	SUB  (HL)
	RET  C
	RET  Z

	CP   $08
	JR   C,NoClampRequired

	LD   A,$08			; clamp to 8 lines

NoClampRequired:
	SRL  A
	LD   B,A
	LD   C,$00
	INC  HL
	LD   A,(HL)
	INC  HL
	LD   H,(HL)
	LD   L,A

ClearLoop:
	LD   (HL),C
	INC  L
	LD   (HL),C
	INC  H
	LD   (HL),C
	DEC  L
	LD   (HL),C
	INC  H
	LD   A,H
	AND  $07
	JR   NZ,NextClearLine

	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,NextClearLine
	
	LD   A,H
	SUB  $08
	LD   H,A
NextClearLine:
	DJNZ ClearLoop
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PixAddr:			; DE =X,Y pixel positions (256x192).  Returns HL as screen address
	LD   A,D
	AND  $C0
	SRL  A
	SRL  A
	SRL  A
	OR   $40
	LD   H,A
	LD   A,D
	AND  $38
	ADD  A,A
	ADD  A,A
	LD   L,A
	LD   A,D
	AND  $07
	OR   H
	LD   H,A
	LD   A,E
	AND  $F8
	SRL  A
	SRL  A
	SRL  A
	OR   L
	LD   L,A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

BytDW:
	INC  H
	LD   A,H
	AND  $07
	RET  NZ
	
	LD   A,L
	ADD  A,$20
	LD   L,A
	RET  C
	
	LD   A,H
	SUB  $08
	LD   H,A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Randomise:
	LD   HL,RND1
	JR   Randomiser

Randomise2:
	LD   HL,RND4

Randomiser:
	LD   C,(HL)
	INC  HL
	LD   A,(HL)
	SRL  C
	SRL  C
	SRL  C
	XOR  C
	INC  HL
	RRA
	RL   (HL)
	DEC  HL
	RL   (HL)
	DEC  HL
	RL   (HL)
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

StrCmp:
	LD   A,(DE)
	CP   (HL)
	RET  NZ
	INC  HL
	INC  DE
	DJNZ StrCmp
	AND  A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

AddHLA:
	ADD  A,L
	LD   L,A
	RET  NC
	INC  H
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

HLFromHL:
	LD   A,(HL)
	INC  HL
	LD   H,(HL)
	LD   L,A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DEFromHL:
	LD   E,(HL)
	INC  HL
	LD   D,(HL)
	INC  HL
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

JPIndex:
	LD   A,(HL)
	INC  HL
	LD   H,(HL)
	LD   L,A
	JP   (HL)

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DumpBackBuffer:
	DI  
	LD   (SP_Store),SP
	LD   HL,BackBuffer-2		;$7FFE	; backbuffer-2
	LD   SP,LineAddresses		;$FF02
	LD   BC,$0700

label_A9C7:
	POP  DE
	INC  L
	INC  HL
	INC  L
	INC  L
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	JP   PE,label_A9C7

	LD   SP,(SP_Store)
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

BitScrollBuffer:
	LD   BC,$0032
WaitABit:
	DEC  BC
	LD   A,B
	OR   C
	JR   NZ,WaitABit

	LD   HL,BackBuffer + ((64 * 32)-1)		;$87FF
	LD   B,$40

BitScrollLeft:
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	RL   (HL)
	DEC  L
	DEC  L
	DEC  HL
	DJNZ BitScrollLeft

	LD   A,(ScrollPixelCounter)
	INC  A
	LD   (ScrollPixelCounter),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlaySound:			; sound number in A
	LD   C,A
	LD   A,(PlayingSound)
	OR   A
	JR   Z,SetupSound
	CP   C
	JR   Z,SetupSound
	RET  NC

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

SetupSound:
	LD   A,C
	LD   (PlayingSound),A
	ADD  A,A
	LD   HL,SoundFXTable-2
	CALL AddHLA
	CALL DEFromHL
	LD   (PlayingSoundAddr),DE
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateSFX:
	EI  
	XOR  A
	LD   R,A
	LD   A,(PlayingSound)
	OR   A
	JR   Z,SoundEnd

	LD   HL,(PlayingSoundAddr)
	LD   C,(HL)
	INC  HL
	LD   A,C
	CP   $FF
	JR   Z,EffectDone
	
	LD   (PlayingSoundAddr),HL
	SRL  A
	JR   C,SetNoise			; bit 0 indicates white noise

PlayTone:
	XOR  A
	OUT  ($FE),A
	LD   B,C
Wait1:
	LD   A,R
	RET  M

	DJNZ Wait1

	LD   A,$10
	OUT  ($FE),A
	LD   B,C
Wait2:
	LD   A,R
	RET  M

	DJNZ Wait2

	JR   PlayTone

EffectDone:
	INC  A
	LD   (PlayingSound),A
SoundEnd:
	LD   A,R
	RET  M

	JR   SoundEnd

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlayNoise:
	XOR  A
	OUT  ($FE),A
	LD   B,(IY+$09)			; RND4
WaitSound1:
	LD   A,R
	RET  M

	DJNZ WaitSound1

	LD   A,$10
	OUT  ($FE),A
WaitMod:
	LD   B,$00
WaitSound2:
	LD   A,R
	RET  M

	DJNZ WaitSound2

	CALL Randomise2
	JR   PlayNoise

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

SetNoise:
	LD   A,(WaitMod+1)
	PUSH AF
	LD   A,C
	LD   (WaitMod+1),A

	CALL PlayNoise

	POP  AF
	LD   (WaitMod+1),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CharScrollBuffer:
	LD   A,(ScrollPixelCounter)
	AND  $07
	RET  NZ

	LD   HL,MapAttrColumn
	EXX 
	LD   HL,ScrollRowTable
	LD   BC,$00D8
	LD   (SP_Store),SP
	LD   SP,HL
Scroll:
	POP  DE
	LD   L,E
	LD   H,D
	INC  HL
	LDI				; shift 26 bytes to the left
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	LDI
	EXX 
	LD   A,(HL)
	INC  HL
	EXX 
	LD   (DE),A
	JP   PE,Scroll

	LD   SP,(SP_Store)
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawHelicopter:
	PUSH HL
	CALL DrawRotorBlades
	POP  HL

DrawSpriteOR:			; HL  = SpriteData structure starting at X byte
	LD   C,(HL)			; C=XNUM
	INC  HL
	LD   B,(HL)			; B=YNUM
	INC  HL
	LD   (XYStore),BC	; store XNUM, YNUM for later
	LD   A,C
	EX   AF,AF'
	PUSH BC
	EXX 
	POP  DE				; 'DE = BC
	EXX 
	LD   E,(HL)			; E=XNUM2
	INC  HL
	LD   D,(HL)			; D=YNUM2
	LD   (TempX),DE
	LD   (HL),B			; YNUM2 = YNUM
	DEC  HL
	LD   (HL),C			; XNUM2 = XNUM
	INC  HL
	INC  HL
	LD   E,(HL)			; DE = XXXSpriteData2
	INC  HL
	LD   D,(HL)			
	LD   (GFXStore),DE	; temp store graphic data addr
	PUSH HL
	EX   AF,AF'
	PUSH AF
	AND  $06
	LD   C,A
	LD   B,$00

SpriteGFXDataMOD:
	LD   HL,$0000			; selfmod
	ADD  HL,BC
	LD   E,(HL)
	INC  HL
	LD   D,(HL)
	POP  AF
	POP  HL
	LD   (HL),D
	DEC  HL
	LD   (HL),E
	EX   DE,HL
	SRL  A
	SRL  A
	SRL  A
	LD   C,A
	LD   A,(TempX)
	SRL  A
	SRL  A
	SRL  A
	SUB  C
	INC  A
	ADD  A,A
	ADD  A,A
	ADD  A,A
	LD   C,A
	PUSH HL
	LD   HL,SpriteInstructionMODs
	ADD  HL,BC
	LD   E,(HL)
	INC  HL
	LD   D,(HL)
	INC  HL
	LD   (Spr_MOD1),DE
	LD   E,(HL)
	INC  HL
	LD   D,(HL)
	INC  HL
	LD   (Spr_MOD2),DE
	LD   A,(HL)
	INC  HL
	EX   AF,AF'
	LD   A,(HL)
	INC  HL
	EXX 
	ADD  A,E
	LD   E,A
	EXX 
	LD   A,(HL)
	INC  HL
	LD   C,(HL)
	POP  HL
	ADD  HL,BC
	PUSH HL
	LD   HL,(GFXStore)
	LD   C,A
	ADD  HL,BC
	PUSH HL
	LD   A,(TempY)
	LD   C,A
	LD   A,(XYStore+1)		;(data_B7E7)
	SUB  C
	ADD  A,$02
	ADD  A,A
	LD   C,A

	LD   HL,SpriteInstructionMODs+24
	ADD  HL,BC
	LD   A,(HL)
	INC  HL
	EXX 
	ADD  A,D
	LD   D,A
	EXX 
	LD   C,(HL)
	INC  HL
	LD   A,(HL)
	POP  HL
	ADD  HL,BC
	LD   (GFXStore),HL
	POP  HL
	LD   C,A
	ADD  HL,BC
	EXX 
	CALL PixAddr
	EXX 
	LD   (SP_Store),SP
	LD   SP,HL
	EXX 
	LD   DE,(GFXStore)
	EX   AF,AF'
	OR   A
	JP   NZ,SpriteHeightMod2

SpriteHeightMod:
	LD   A,$10
SpriteORLoop:
	EX   AF,AF'
	POP  BC
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	INC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	INC  L
	INC  DE
	POP  BC
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	INC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	INC  L
	INC  DE
	POP  BC
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	INC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	INC  L
	INC  DE
	POP  BC
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	INC  H
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	DEC  L
	INC  DE
	POP  BC
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	DEC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	DEC  L
	INC  DE
	POP  BC
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	DEC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	DEC  L
	INC  DE
	POP  BC
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	DEC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	INC  H
	INC  DE
	LD   A,H
	AND  $07
	JR   NZ,.Skip

	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,.Skip

	LD   A,H
	SUB  $08
	LD   H,A
.Skip:
	EX   AF,AF'
	DEC  A
	JR   NZ,SpriteORLoop
	LD   SP,(SP_Store)
	RET 

SpriteHeightMod2:
	LD   A,$10
SpriteORLoop2:
	EX   AF,AF'
	POP  BC
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	INC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	INC  L
	INC  DE
	POP  BC

	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	INC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	INC  L
	INC  DE
	POP  BC

	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	INC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	INC  H
	INC  DE
Spr_MOD1:
	NOP 
	NOP 
	
	POP  BC
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	DEC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	DEC  L
	INC  DE
	
	POP  BC
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	DEC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	DEC  L
	INC  DE
	
	POP  BC
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   C
	LD   (HL),A
	DEC  L
	INC  DE
	LD   A,(DE)
	CPL
	AND  (HL)
	OR   B
	LD   (HL),A
	INC  H
	INC  DE
Spr_MOD2:
	NOP 
	NOP 
	LD   A,H
	AND  $07
	JR   NZ,.Skip

	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,.Skip
	
	LD   A,H
	SUB  $08
	LD   H,A
.Skip:
	EX   AF,AF'
	DEC  A
	JR   NZ,SpriteORLoop2
	LD   SP,(SP_Store)
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawRotorBlades:
	LD   A,(HL)			; XNUM
	LD   E,A			; E=X
	EX   AF,AF'
	INC  HL
	LD   A,(HL)			; YNUM
	ADD  A,$03
	LD   D,A			; D=Y
	INC  HL
	PUSH DE
	LD   E,(HL)
	INC  HL
	LD   A,(HL)
	ADD  A,$03
	LD   D,A
	CALL PixAddr
	XOR  A
	LD   B,$07

ClrBlade:
	LD   (HL),A
	INC  L
	DJNZ ClrBlade
	POP  DE
	LD   A,(FrameToggle)
	OR   A
	RET  Z
	LD   B,A
	LD   A,E
	AND  $07
	SRL  A
	LD   HL,gfx_Blades
	CALL AddHLA
	LD   C,(HL)
	CALL PixAddr
	LD   (HL),C			; left blade edge
	INC  L
	LD   (HL),B			; fill in the blade
	INC  L
	LD   (HL),B
	INC  L
	LD   (HL),B
	INC  L
	LD   (HL),B
	INC  L
	LD   (HL),B
	INC  L
	LD   A,C			; flip left blade edge bits
	CPL
	LD   (HL),A			; right blade edge
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Delay:
	LD   BC,$000A
DelLp:
	DEC  BC
	LD   A,B
	OR   C
	JR   NZ,DelLp
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawMissileTops:
	LD   A,R
	JP   M,DrawTops
	LD   BC,$0A2D			; delay if no missile tops to draw
WaitBC:
	DEC  C
	JR   NZ,WaitBC
	DJNZ WaitBC
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DoScroll:
	LD   A,R
	RET  P

	LD   HL,(MapX)
	INC  HL
	LD   (MapX),HL

	CALL CharScrollBuffer
	JP   BitScrollBuffer

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TriggerMissileTops:
	LD   A,R
	RET  P
	LD   DE,(MapX)
	LD   B,$04			;  four map triggers
	LD   HL,MissileTopPositions

NextTop:
	PUSH BC
	LD   C,(HL)
	INC  HL
	LD   B,(HL)
	INC  HL
	PUSH HL
	LD   L,E
	LD   H,D
	SBC  HL,BC
	POP  HL
	POP  BC
	JR   Z,TriggerMissileTop
	DJNZ NextTop
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TriggerMissileTop:
	LD   HL, MissileTopsX - 1
	LD   DE,MissileTopIndex
	JP   SetPosition

DrawTops:
	CALL BitScrollBuffer
	LD   A,(LevelNumber)
	AND  $03
	RET  NZ
	LD   HL,MissileTopsX
	LD   A,(HL)
	OR   A
	CALL NZ,DrawBlock
	INC  L
	LD   A,(HL)
	OR   A
	CALL NZ,DrawBlock
	INC  L
	LD   A,(HL)
	OR   A
	RET  Z

DrawBlock:
	DEC  (HL)
	DEC  (HL)
	LD   (SP_Store),SP
	EXX 
	LD   C,A
	AND  $06
	ADD  A,low MissileTopAddr		;$DC
	LD   L,A
	LD   H,high MissileTopAddr		;$A0 HL = $A0DC = MissileTopAddr
	LD   A,(HL)
	INC  L
	LD   H,(HL)
	LD   L,A
	LD   SP,HL						; address of block
	LD   HL,$4860					; screen addr
	LD   E,C
	LD   D,$00
	SRL  E
	SRL  E
	SRL  E
	ADD  HL,DE
	LD   C,$02
NextCharacter:
	LD   B,$04
NextTwoRows:							; zig-zag two rows of 3 pixels at a time
	POP  DE
	LD   (HL),E
	INC  L
	LD   (HL),D
	INC  L
	POP  DE
	LD   (HL),E
	INC  H							; down one line
	LD   (HL),D
	DEC  L						
	POP  DE
	LD   (HL),E
	DEC  L
	LD   (HL),D
	INC  H
	DJNZ NextTwoRows
	LD   A,H
	AND  $07
	JR   NZ,.Skip

	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,.Skip
	
	LD   A,H
	SUB  $08
	LD   H,A
.Skip:
	DEC  C
	JR   NZ,NextCharacter
	EXX 
	LD   SP,(SP_Store)
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TriggerMines:
	LD   A,R
	RET  P
	LD   HL,(MineTriggerAddr)
	LD   C,(HL)
	INC  HL
	LD   B,(HL)
	INC  HL
	PUSH HL
	LD   HL,(MapX)
	SBC  HL,BC
	POP  HL
	RET  NZ
	LD   (MineTriggerAddr),HL
	LD   HL,MineXPositions-1			; data_A0D0
	LD   DE,MineIndex
SetPosition:
	LD   A,(DE)
	INC  A
	AND  $03
	JR   NZ,NoReset
	INC  A
NoReset:
	LD   (DE),A
	CALL AddHLA
	LD   (HL),$F0			; X at 240
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawMines:			; draw up to three mines
	LD   HL,MineXPositions
	LD   A,(HL)
	OR   A
	CALL NZ,DrawMine
	INC  L
	LD   A,(HL)
	OR   A
	CALL NZ,DrawMine
	INC  L
	LD   A,(HL)
	OR   A
	RET  Z

DrawMine:
	LD   A,R
	JP   P,NoScrollSkip
	DEC  (HL)
	DEC  (HL)

NoScrollSkip:
	LD   A,(HL)
	EXX 
	LD   C,A
	AND  $06
	ADD  A,low MineMaskAddr		;$D4 lo byte MineMaskAddr
	LD   L,A
	LD   H,high MineMaskAddr	;$A0 $a0d4 MineMaskAddr
	LD   A,(HL)
	INC  L
	LD   H,(HL)
	LD   L,A
	LD   (MaskAddrMOD+1),HL
	LD   DE,$0060
	ADD  HL,DE
	LD   A,(V_FrameCounter)
	AND  $01
	JR   Z,ToggleFrame
	ADD  HL,DE

ToggleFrame:
	LD   (SP_Store),SP
	LD   SP,HL
	LD   HL,$5280
	LD   E,C
	SRL  E
	SRL  E
	SRL  E
	ADD  HL,DE

	LD   A,$03
MaskAddrMOD:
	LD   BC,$0000				; self mod
NextMineLine:
	EX   AF,AF'
	POP  DE
	LD   A,(BC)
	AND  (HL)
	OR   E
	LD   (HL),A
	INC  L
	INC  C
	LD   A,(BC)
	AND  (HL)
	OR   D
	LD   (HL),A
	INC  L
	INC  BC

	POP  DE
	LD   A,(BC)
	AND  (HL)
	OR   E
	LD   (HL),A
	INC  H
	INC  C
	LD   A,(BC)
	AND  (HL)
	OR   D
	LD   (HL),A
	DEC  L
	INC  BC
	
	POP  DE
	LD   A,(BC)
	AND  (HL)
	OR   E
	LD   (HL),A
	DEC  L
	INC  C
	LD   A,(BC)
	AND  (HL)
	OR   D
	LD   (HL),A
	INC  H
	INC  BC
	EX   AF,AF'
	DEC  A
	JR   NZ,NextMineLine
	LD   SP,(SP_Store)
	EXX 
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Stage1EndUpdate:
	LD   A,(PlayingSound)
	OR   A
	LD   A,S_KICK				; $05
	CALL Z,PlaySound
	LD   A,(TruckActive)
	OR   A
	RET  NZ

	LD   HL,gfx_TruckMask
	LD   (data_A134_4),HL
	LD   HL,TruckSpriteData
	LD   (SpriteGFXDataMOD+1),HL
	LD   A,$14
	LD   (SpriteHeightMod+1),A
	LD   HL,TruckX
	CALL DrawSpriteOR

	LD   HL,LittleHelicopterGFXData
	LD   (SpriteGFXDataMOD+1),HL
	LD   A,$10
	LD   (SpriteHeightMod+1),A
	LD   A,(TruckX)
	LD   C,A
	ADD  A,$08
	CP   $E0
	JP   Z,label_AF12
	LD   (TruckX),A
	LD   (TruckX2),A
label_AEE5:
	LD   A,C
	SRL  A
	SRL  A
	SRL  A
	LD   L,A
	CP   $02
	JR   NC,label_AEF3
	LD   L,$02
label_AEF3:
	LD   H,$10
	CP   $1A
	JR   NC,label_AF05
	ADD  A,$04
	LD   C,A
	LD   B,$12
	LD   A,$28
	PUSH HL
	CALL JP_FillAttrBlock
	POP  HL
label_AF05:
	LD   A,L
	CP   $03
	RET  C
	DEC  L
	LD   C,L
	LD   B,$12
	LD   A,$68
	JP   JP_FillAttrBlock
label_AF12:
	LD   E,$D8
	LD   D,$80
	CALL PixAddr
	LD   B,$28
	LD   DE,$831B
label_AF1E:
	PUSH BC
	PUSH HL
	LDI
	LDI
	LDI
	LD   HL,$001D
	ADD  HL,DE
	EX   DE,HL
	POP  HL
	CALL BytDW
	POP  BC
	DJNZ label_AF1E

	LD   (IY+$47),$FF			; FFC9 - TruckActive
	JR   label_AEE5

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

BulletVelocities:			; 3 bytes each
	db $04			; xvel
	db $02			; xvel2
	db $00			; yvel
	db $FC
	db $F8
	db $00
	db $04
	db $02
	db $04
	db $FC
	db $F8
	db $04

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateBullets:
	LD   B,$04
	LD   HL,BaddyBullets
NextBul:
	PUSH BC
	PUSH HL
	CALL UpdateBullet
	POP  HL
	POP  BC
	LD   DE,$0007
	ADD  HL,DE
	DJNZ NextBul
	RET 

UpdateBullet:
	LD   A,(HL)
	OR   A
	RET  M
	INC  HL
	PUSH HL
	LD   HL,BulletVelocities			; velocities for different bullet types
	LD   E,A
	ADD  A,A
	ADD  A,E
	LD   E,A			; a * 3
	LD   D,$00
	ADD  HL,DE
	LD   C,(HL)			; xvel1
	INC  HL
	LD   A,R
	JP   P,NotScroll
	LD   C,(HL)			; xvel2
NotScroll:
	INC  HL
	LD   B,(HL)			; yvel
	POP  HL
	LD   A,(HL)			; xno
	ADD  A,C			; +xvel
	LD   (HL),A			; xno
	INC  HL
	CP   $F8			; off screen?
	JR   NC,KillBullet
	LD   A,(HL)			; yno
	ADD  A,B			; +yvel
	LD   (HL),A			; yno
	CP   $A6			; off screen?
	RET  C

KillBullet:
	DEC  HL
	DEC  HL
	LD   (HL),$80			; mark bullet as not in use
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawBullets:			; draws up to four bullets
	LD   HL,BaddyBullets
	LD   A,(HL)
	OR   A
	CALL P,DrawBullet

	LD   A,$07
	ADD  A,L
	LD   L,A
	LD   A,(HL)
	OR   A
	CALL P,DrawBullet
	
	LD   A,$07
	ADD  A,L
	LD   L,A
	LD   A,(HL)
	OR   A
	CALL P,DrawBullet
	
	LD   A,$07
	ADD  A,L
	LD   L,A
	LD   A,(HL)
	OR   A
	RET  M

DrawBullet:
	PUSH HL
	INC  L
	LD   A,(HL)
	LD   E,A
	EX   AF,AF'
	INC  L
	LD   D,(HL)
	INC  L
	LD   C,L
	LD   B,H
	CALL PixAddr
	EX   DE,HL
	LD   L,C
	LD   H,B
	LD   C,(HL)
	LD   (HL),E
	INC  L
	LD   B,(HL)
	LD   (HL),D
	INC  L
	PUSH DE
	EXX 
	EX   AF,AF'
	AND  $06
	ADD  A,A
	ADD  A,A
	LD   HL,gfx_Bullets
	ADD  A,L
	LD   E,A
	LD   A,H
	ADC  A,$00
	LD   D,A
	POP  HL
	LD   A,D
	EX   AF,AF'
	LD   A,E
	EX   DE,HL
	EXX 
	LD   E,(HL)
	LD   (HL),A
	INC  L
	EX   AF,AF'
	LD   D,(HL)
	LD   (HL),A
	EX   DE,HL
	LD   (SP_Store),SP
	LD   SP,HL
	LD   L,C
	LD   H,B
	POP  DE
	LD   A,E
	CPL
	AND  (HL)
	LD   (HL),A
	INC  L
	LD   A,D
	CPL
	AND  (HL)
	LD   (HL),A
	INC  H
	POP  DE
	LD   A,E
	CPL
	AND  (HL)
	LD   (HL),A
	DEC  L
	LD   A,D
	CPL
	AND  (HL)
	LD   (HL),A
	INC  H
	LD   A,H
	AND  $07
	JR   NZ,BullSkipLine
	
	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,BullSkipLine
	
	LD   A,H
	SUB  $08
	LD   H,A
BullSkipLine:
	POP  DE
	LD   A,E
	CPL
	AND  (HL)
	LD   (HL),A
	INC  L
	LD   A,D
	CPL
	AND  (HL)
	LD   (HL),A
	EXX 
	LD   SP,HL
	EX   DE,HL
	POP  DE
	LD   A,E
	OR   (HL)
	LD   (HL),A
	INC  L
	LD   A,D
	OR   (HL)
	LD   (HL),A
	INC  H
	POP  DE
	LD   A,E
	OR   (HL)
	LD   (HL),A
	DEC  L
	LD   A,D
	OR   (HL)
	LD   (HL),A
	INC  H
	LD   A,H
	AND  $07
	JR   NZ,BullSkipLine2
	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,BullSkipLine2
	LD   A,H
	SUB  $08
	LD   H,A

BullSkipLine2:
	POP  DE
	LD   A,E
	OR   (HL)
	LD   (HL),A
	INC  L
	LD   A,D
	OR   (HL)
	LD   (HL),A
	LD   SP,(SP_Store)
	POP  HL
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

FlameThrowerSpriteData:
	dw gfx_FlameThrowerRight

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

DrawFlameThrower:
	LD   A,(FlameThrowerActive)
	OR   A
	JP   M,label_B07B

	LD   HL,FlameThrowerSpriteData
	LD   (SpriteGFXDataMOD+1),HL
	LD   A,$04
	LD   (SpriteHeightMod+1),A
	LD   (SpriteHeightMod2+1),A
;	XOR  A
;	LD   (ISRTable),A
;	LD   (ISRTable+1),A
	LD   HL,FlameThrowerX
	CALL DrawSpriteOR

;	LD   A,$FE
;	LD   (ISRTable),A
;	LD   (ISRTable+1),A
	LD   HL,LittleHelicopterGFXData
	LD   (SpriteGFXDataMOD+1),HL
	LD   A,$10
	LD   (SpriteHeightMod+1),A
	LD   (SpriteHeightMod2+1),A
	RET 

label_B07B:
	LD   C,A
	LD   DE,(FlameThrowerX)
	LD   A,D
	CP   $68
	JR   NC,label_B0AB

	SRL  C
	JR   NC,label_B08B
	
	LD   E,$10
label_B08B:
	CALL PixAddr
	LD   D,$00
	LD   B,$08
label_B092:
	LD   (HL),D
	INC  L
	LD   (HL),D
	INC  L
	LD   (HL),D
	DEC  L
	DEC  L
	INC  H
	LD   A,H
	AND  $07
	JR   NZ,label_B0A9
	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,label_B0A9
	LD   A,H
	SUB  $08
	LD   H,A
label_B0A9:
	DJNZ label_B092

label_B0AB:
	JP   label_B6E4

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;


Weapon1Image:
	db AT		;$00
	db $02
	db $16
Weapon1
	db TABX		;$11
	db PEN		;$05
	db $42
	db $20
	db $20
	db $2C
	db RTN		;$0D
	db PEN		;$05
	db $45
	db $2D
	db $2E
	db PEN		;$05
	db $72
	db $2F
	db BACKSP	;$0E
	db $01
	db LOOP		;$0F NEW INSTRUCTION
	db $02
	dw Weapon1	;$B0B1
	db PEN		;$05
	db $FF
	db TABX		;$11
	db $20
	db $20
	db $20
	db RTN		;$0D
	db $20
	db $20
	db $20
	db FIN		;$FF

Weapon2Image:
	db AT			;$00
	db $02
	db $16
Weapon2:
	db TABX			;$11
	db PEN			;$05
	db $47
	db $26
	db $27
	db PEN			;$05
	db $46
	db $28
	db RTN			;$0D
	db PEN			;$05
	db $07
	db $29
	db $2A
	db PEN			;$05
	db $47
	db $2B
	db BACKSP		;$0E
	db $01
	db LOOP			;$0F
	db $03
	dw Weapon2		;$B0D3
	db FIN			;$FF

Weapon3Image:
	db AT			;$00
	db $02
	db $16
Weapon3:
	db TABX			;$11
	db PEN			;$05
	db $04
	db $3A
	db $05
	db $44
	db $3B
	db $20
	db RTN			;$0D
	db PEN			;$05
	db $04
	db $3C
	db PEN			;$05
	db $44
	db $3D
	db $20
	db BACKSP		;$0E
	db $01
	db LOOP			;$0F
	db $03
	dw Weapon3		;$B0ED
	db FIN			;$FF

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CheckOnLadder:
	EX   AF,AF'			; Y move amount
	DEC  DE
	LD   A,(DE)			; A = PlayerOnLadder
	INC  DE
	INC  DE
	OR   A
	RET  Z
	ADD  A,A
	LD   HL,LadderRanges - 2	; $B120 - 2 = LadderRanges - 2
	CALL AddHLA
	LD   A,(DE)			; PlayerY
	LD   C,A
	ADD  A,B			; Offset
	CP   (HL)
	RET  NC			; exit if Y > ladder bottom Y
	INC  HL
	CP   (HL)
	CCF
	RET  NC			; exit if Y < ladder top Y
	EX   AF,AF'
	ADD  A,C			; Y Move Amount + PlayerY
	LD   (DE),A			; PlayerY
	SCF			; carry flag = we're on the ladder and have moved
	RET 

LadderRanges:
	db $92
	db $72
	db $72
	db $52
	db $92
	db $52

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

GetSineA:			; returns the sine of value in A
	LD   HL,SineTable
	ADD  A,L
	LD   L,A
	LD   A,H
	ADC  A,$00
	LD   H,A
	LD   A,(HL)
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CalcWeaponOffset:
	LD   A,(HasWeapon)
	LD   HL,FlameThrowerOffsetTable
	DEC  A
	JR   Z,GetOffset
	DEC  A
	RET  NZ
	LD   HL,FlameThrowerOffsetTable+15

GetOffset:
	LD   C,(HL)
	INC  HL
	LD   DE,(PlayerX)
	LD   A,(PlayerDir)
	CALL AddHLA
	LD   A,E			; A = PlayerX
	CP   (IY+$36)			; ScrollBoundary
	JR   C,NoBoundClamp
	LD   A,(ScrollBoundary)

NoBoundClamp:
	ADD  A,(HL)			; PlayerX + table[1+PlayerDir]
	LD   E,A
	INC  HL
	LD   A,D			; PlayerY
	ADD  A,C			; + table[0]
	LD   D,A
	LD   (WeaponX),DE			; Weapon XY relative to player
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

FlameThrowerOffsetTable:
	db $06
	db $02
	db $FE
	db $02
	db $00
	db $02
	db $FE
	db $00
	db $00
	db $0A
	db $FC
	db $02
	db $FE
	db $0A
	db $FC
	
	db $00
	db $02
	db $FC
	db $02
	db $00
	db $02
	db $FC
	db $00
	db $00
	db $0A
	db $FC
	db $00
	db $FE
	db $0A
	db $FC

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

PlayerCollideToWorld:
	LD   A,(PlayerLieDown)
	OR   A
	RET  NZ

	CALL UpdateMapLadders
	CALL UpdateMapLandRows
	LD   A,(DeathCounter)			; make sure we're not in the throws of dying
	OR   A
	RET  NZ

	LD   HL,PlayerX
	LD   A,(isSnappedToLadder)
	OR   A
	JR   Z,NotSnappedToLadder

	LD   A,(PlayerLadderX)
	CALL GetMapXatA
	JP   DetectLadders

NotSnappedToLadder:
	CALL GetMapXForBaddy
	CALL DetectLadders
	LD   DE,(PlayerMapX)
	LD   A,(isInAir)
	OR   A
	JR   NZ,UpdateFall

	LD   A,(PlayerY)
	CALL WhatsUnderMe
	RET  C			; return if Player is stood on something

	LD   A,(PlayerX)
	CP   (IY+$36)			; ScrollBoundary
	JR   C,NoClamp2

	LD   A,(ScrollBoundary)			; clamp position to boundary
NoClamp2:
	LD   (PlayerX),A
	LD   A,(PlayerY)
	LD   (JumpStartY),A
	LD   (JumpSnapY),A
	LD   A,$79			; start of jump - index into sine table
	LD   (JumpYIndex),A
	LD   (isInAir),A
	LD   A,(PlayerDir)
	AND  $01
	ADD  A,$04
	LD   (PlayerDir),A
	LD   A,(FUDLR)
	LD   (TempFUDLR),A
	RET 

UpdateFall:
	LD   A,(JumpYIndex)
	CP   $57
	RET  C

	LD   A,(JumpSnapY)
	LD   C,A
	LD   A,(PlayerY)
	ADD  A,$02
	CP   C
	RET  C

	LD   A,C
	ADD  A,$20			; player sprite 32 pixels high
	LD   (JumpSnapY),A
	LD   A,C
	CALL WhatsUnderMe
	RET  NC

	LD   A,(JumpSnapY)
	SUB  $20
	LD   (PlayerY),A			; snap player to start of jump position
	LD   A,(PlayerDir)
	AND  $01
	LD   (PlayerDir),A			; just leave left/right bit in PlayerDir
	XOR  A
	LD   (isInAir),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; Given a Y position in A, and the MAPX in DE return carry set if there's something below the character
;

WhatsUnderMe:			
	LD   B,$04
	CP   $50
	LD   HL,(MapLandRow1)
	JR   Z,ScanHorizontalRow

	CP   $70
	LD   HL,(MapLandRow2)
	JR   Z,ScanHorizontalRow

	CP   $90
	JR   Z,OnTheFloor
	OR   A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; HL = MapLandRow1/2
; DE = MAPX
; B  = no of spans to scan
;

ScanHorizontalRow:
	LD   C,(HL)
	INC  HL
	LD   A,(HL)
	OR   A
	JP   M,NothingBelow

	CALL CheckSoildSpan
	INC  HL
	INC  HL
	INC  HL
	DJNZ ScanHorizontalRow

NothingBelow:
	OR   A
	RET 

CheckSoildSpan:		; see if our MAPX is within a span of solid tiles
	PUSH HL
	LD   H,A
	LD   L,C
	OR   A
	SBC  HL,DE		; - MAPX
	POP  HL
	RET  NC

	PUSH HL
	INC  HL
	LD   A,(HL)
	INC  HL
	LD   H,(HL)
	LD   L,A
	OR   A
	SBC  HL,DE		; - MAPX
	POP  HL
	RET  C			; drop back to previous caller with the carry set for stood on something

	POP  HL

OnTheFloor:
	SCF				; flag we're stood on terra firma
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateMapLandRows:
	LD   HL,MapLandRow1
	LD   BC,(MapXAtScrollBoundary)
	
	CALL UpdateMapLandRow
	LD   HL,MapLandRow2

UpdateMapLandRow:
	LD   E,(HL)
	INC  HL
	LD   D,(HL)
	EX   DE,HL
	INC  HL
	INC  HL
	LD   A,(HL)
	INC  HL
	PUSH HL
	LD   H,(HL)
	LD   L,A
	OR   A
	SBC  HL,BC
	POP  HL
	RET  NC

	INC  HL
	EX   DE,HL
	LD   (HL),D
	DEC  HL
	LD   (HL),E
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateMapLadders:
	LD   HL,(MapX)
	LD   DE,$0070
	OR   A
	SBC  HL,DE
	LD   (MapXAtScrollBoundary),HL	; Map X at middle of the screen (scroll boundary)
	EX   DE,HL
	LD   HL,(MapLadderAddr)
	LD   A,(HL)
	INC  HL
	PUSH HL
	LD   H,(HL)
	LD   L,A
	LD   A,H
	AND  $3F
	LD   H,A
	LD   A,$06
	CALL AddHLA
	OR   A
	SBC  HL,DE			; - MapXAtScrollBoundary
	POP  HL
	RET  NC
	INC  HL
	LD   (MapLadderAddr),HL
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; HL = Sprite structure offset (+10) to XNO in the structure
;

GetMapXForBaddy:		; fills in MAPXH and MAPXL in structure HL+7, HL+8
	LD   A,(HL)			; XNO
GetMapXatA:
	SRL  A
	LD   DE,(MapXAtScrollBoundary)
	ADD  A,E
	LD   E,A
	LD   A,D
	ADC  A,$00
	LD   D,A
	DEC  HL
	DEC  HL
	LD   (HL),D			; MapXH  BaddyDataN + 8
	DEC  HL
	LD   (HL),E			; MaxpXL  BaddyDataN + 7
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; Enters with 
; HL pointing to Baddy/Player MapX variables
; DE
;
; Exits with Baddy/Player+Onladder set NZ if on a ladder
;

DetectLadders:			
	INC  HL
	INC  HL
	LD   (HL),$00			; PlayerOnLadder
	PUSH DE
	EXX 
	POP  DE
	LD   HL,(MapLadderAddr)
	LD   B,$05
ScanLoop:
	LD   A,(HL)
	INC  HL
	LD   C,(HL)				; $ff = no ladder
	INC  HL
	PUSH HL
	LD   L,A
	INC  A
	LD   A,C
	JR   NZ,label_B2CC		; if first byte non zero

	INC  A
	JR   Z,NoLadder			; if second byte == $ff

	DEC  A

label_B2CC:
	AND  $3F
	LD   H,A
	LD   A,C
	RLCA
	RLCA
	AND  $03
	LD   C,A
	PUSH HL
	OR   A
	SBC  HL,DE
	POP  HL
	JR   NC,NextLine

	LD   A,L
	ADD  A,$06
	LD   L,A
	LD   A,H
	ADC  A,$00
	LD   H,A
	OR   A
	SBC  HL,DE
	JR   C,NextLine

	POP  AF
	LD   A,C
	INC  A
	EXX 
	LD   (HL),A			; Player/Baddy OnLadder (A=ladder type)
	EXX 
	RET 

NextLine:
	POP  HL
	DJNZ ScanLoop
	RET 

NoLadder:
	POP  HL
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

WeaponTriggers:
	LD   A,R
	RET  P
	LD   A,(WeaponTriggerCountdown)		; if countdown is 0
	OR   A
	JR   Z,TryTrigger

	DEC  (IY+$2A)						; $FFAC - decrement WeaponTriggerCountdown
	RET  NZ

	LD   IX,BaddyData					; countdown just hit 0
	LD   (IX+TYP),T_BADDYCOMMANDANT		; TYP = 8 = Commandant (who carries new shooter weapons for you)
	LD   (IX+FLAG),$02					; FLAG
	LD   (IX+CNT2),$01					; CNT2
	LD   (IX+CNT1),$05					; CNT1
	LD   (IX+XNO),$E4					; XNO
	LD   A,(StartY)
	LD   (IX+YNO),A						; YNO
	LD   (IX+GNO),G_COMMANDANTLEFT1;	; $1E					; GNO
	LD   (IX+XSPD),$00					; XSPD
	RET 

TryTrigger:
	LD   DE,(MapX)
	LD   HL,(WeaponTriggerAddr)
	LD   C,(HL)
	INC  HL
	LD   B,(HL)
	INC  HL
	EX   DE,HL
	SBC  HL,BC
	RET  NZ

	EX   DE,HL						; Hit a trigger X position
	LD   A,(HL)						; The Commandant always uses slot1 
	INC  HL
	LD   (WeaponTriggerAddr),HL
	LD   C,A						; bottom two bits trigger a shooter weapon
	AND  $03
	LD   (TriggeredWeapon),A		; flame thrower, rocket launcher, grenades
	LD   A,C
	SRL  A
	SRL  A
	LD   HL,YStarts
	CALL AddHLA
	LD   A,(HL)
	LD   (StartY),A
	LD   (IY+$2A),$38			; $FFAC - WeaponTriggerCountdown
	LD   A,(BaddyData+1)		; FLAG
	OR   $40					; set bit 6 to make this baddy leave, so we can reuse the slot
	LD   (BaddyData+1),A		; FLAG
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

YStarts:
	db $50
	db $70
	db $90

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TriggerParachuteGuys:
	LD   A,(ParachuteGuyTriggered)			; -ve = triggered
	OR   A
	JP   M,UpdateParachuteGuy
	LD   A,R
	RET  P
	LD   A,(ParachuteGuyTriggerCountdown)
	OR   A
	JR   Z,label_B3AE
	DEC  (IY+$24)					; FFA6 - ParachuteGuyTriggerCountdown
	RET  NZ
	LD   HL,$18E0
	LD   (BossBaddyX),HL
	LD   (data_A120_4),HL
	LD   HL,gfx_Balloons1
	LD   (data_A122_4),HL
	LD   IX,BaddyData
	LD   (IX+TYP),T_BADDYPARACHUTE		; TYP
	LD   (IX+XNO),$50					; XNO
	LD   (IX+YNO),$28					; YNO
	LD   (IX+GNO),G_RUNNINGBADDYLEFT2	; $11				; GNO
	XOR  A
	LD   (ParachuteGuySprite),A
	DEC  A
	LD   (ParachuteGuyTriggered),A
	LD   HL,ParachuteGuySprite+1
	LD   (ParachuteGuySpriteAddr),HL
	LD   (IY+$3C),$01			; FFBE - ParachuteGuyFlag
	RET 
label_B3AE:
	LD   DE,(MapX)
	LD   HL,(ParachuteTriggerAddr)
	LD   C,(HL)
	INC  HL
	LD   B,(HL)
	INC  HL
	EX   DE,HL
	SBC  HL,BC
	RET  NZ
	LD   (ParachuteTriggerAddr),DE
	LD   (IY+$24),$38			; FFA6 - ParachuteGuyTriggerCountdown
	LD   A,(BaddyData+1)			; BaddyData+FLAG
	OR   $40			; Set bit 6
	LD   (BaddyData+1),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateParachuteGuy:
	LD   A,(ParachuteGuySprite)
	OR   A
	JR   NZ,SwitchToRunner
	DEC  (IY+$3C)			; FFBE - ParachuteGuyFlag
	JR   NZ,SetBalloons
	LD   HL,(ParachuteGuySpriteAddr)
	LD   A,(HL)
	OR   A
	JP   M,ClearBalloons
	LD   (ParachuteGuyFlag),A
	INC  HL
	LD   A,(HL)
	LD   (ParachuteXOffsetMOD+1),A
	INC  HL
	LD   A,(HL)
	LD   (ParachuteYOffsetMOD+1),A
	INC  HL
	LD   (ParachuteGuySpriteAddr),HL
SetBalloons:
	LD   HL,ParachuteGFXData
	LD   (SpriteGFXDataMOD+1),HL
	LD   HL,BossBaddyY
	LD   A,(HL)
ParachuteYOffsetMOD:
	ADD  A,$00
	LD   (HL),A			; YNO
	DEC  HL
	LD   A,(HL)			; XNO
ParachuteXOffsetMOD:
	ADD  A,$00
	LD   (HL),A			; XNO
	CALL DrawSpriteOR			; draw balloons
	LD   HL,LittleHelicopterGFXData
	LD   (SpriteGFXDataMOD+1),HL
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ClearBalloons:
	LD   C,$18			; 24 pixels high
ClearScreenBlock:
	LD   DE,(BossBaddyX)
	CALL PixAddr
	LD   A,$01
	LD   (ParachuteGuySprite),A
NextRowClr:
	LD   E,L
	LD   B,$07
ClrLoop:
	LD   (HL),$00
	INC  L
	DJNZ ClrLoop
	LD   L,E
	INC  H
	LD   A,H
	AND  $07
	JR   NZ,LineSkip
	LD   A,L
	ADD  A,$20
	LD   L,A
	JR   C,LineSkip
	LD   A,H
	SUB  $08
	LD   H,A
LineSkip:
	DEC  C
	JR   NZ,NextRowClr
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

SwitchToRunner:
	LD   IX,BaddyData
	LD   A,(BossBaddyY)
	ADD  A,$06
	LD   (BossBaddyY),A
	LD   A,(IX+$0B)
	CP   $8C
	RET  C

	LD   (IX+TYP),T_BADDYJUMPER		; TYP - 2 - JumpingEnemy
	LD   (IX+FLAG),$02				; FLAG
	LD   (IX+BASEY),$90				; BASEY
	LD   (IX+CNT2),$07				; CNT2

	XOR  A
	LD   (ParachuteGuyTriggered),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ParachuteGuySpriteAddr:
	dw $0000

ParachuteGuySprite:
	db $00
	db $28
	db $FE
	db $00
	db $08
	db $FE
	db $02
	db $08
	db $02
	db $00
	db $08
	db $00
	db $02
	db $0C
	db $02
	db $02
	db $FF

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TriggerMortarGuys:
	LD   A,R
	RET  P
	LD   A,(MortarGuyTriggerCountdown)
	OR   A
	JR   Z,FindMortarTrigger
	LD   A,(MortarGuyTriggered)
	OR   A
	CALL NZ,FindSlotForMortar
	DEC  (IY+$26)			; FFA8 - MortarGuyTriggerCountdown
	RET  NZ
	LD   A,(MortarGuyTriggered)
	OR   A
	JR   Z,TriggerMortar
	INC  (IY+$26)			; FFA8 - MortarGuyTriggerCountdown
	RET 

MortarToggle2:
	db $00
MortarToggle:
	db $FF

TriggerMortar:
	LD   IX,(MortarSlot)
	LD   (IX+TYP),T_BADDYMORTAR			; TYP = Mortar Guy
	LD   (IX+XNO),$E4			; XNO
	LD   (IX+YNO),$90			; YNO
	LD   A,(MortarToggle)
	CPL
	LD   (MortarToggle),A
	LD   (IX+CNT2),A			; CNT2
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

FindMortarTrigger:
	LD   DE,(MapX)
	LD   HL,(MortarTriggerAddr)
	LD   C,(HL)
	INC  HL
	LD   B,(HL)
	INC  HL
	EX   DE,HL
	SBC  HL,BC
	RET  NZ

	LD   (MortarTriggerAddr),DE			; next mortar trigger position
	LD   A,$32
	LD   (MortarGuyTriggered),A
	LD   (MortarGuyTriggerCountdown),A

FindSlotForMortar:
	CALL FindBaddySlot4or5
	JP   P,NotFound

	XOR  A						; slot found, use it
	LD   (MortarGuyTriggered),A
	LD   (HL),$FF				; HL = BaddyData slot for Mortar Guy
	LD   (MortarSlot),HL
	RET 

NotFound:						; reuse either slot 4 or 5 for a mortar guy
	LD   IX,BaddyData4
	LD   A,(IX+TYP)				; TYP
	CP   T_BADDYMORTAR			; Mortar Guy
	JR   NZ,GotMortarSlot
	
	LD   IX,BaddyData5
GotMortarSlot:
	SET  6,(IX+FLAG)			; Set bit 6 to tell the current baddy to turn around and leave
	XOR  A
	LD   (MortarGuyTriggered),A
	LD   (MortarSlot),IX
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateMortarBomb:
	LD   A,(MortarInFlight)
	OR   A
	RET  Z
	LD   B,A
	LD   A,(MortarYIndex)
	ADD  A,$06
	LD   (MortarYIndex),A
	CALL GetSineA
	LD   C,A
	LD   A,$B0
	SUB  C			; 176 - sin(MortarYIndex)
	AND  $FE
	LD   (MortarBombY),A
	CP   $A2
	JR   NC,BombHitFloor
	LD   A,(MortarBombX)
	DJNZ label_B51A
	ADD  A,$08			; +x dir
label_B51A:
	SUB  $04			; -x dir
	LD   C,A
	LD   A,R
	LD   A,C
	JP   P,NotScrolled
	SUB  $02			; if we've just scrolled, move left 2 pixels
NotScrolled:
	CP   $08
	JR   C,MortarBombOffScreen
	LD   (MortarBombX),A
	RET 

BombHitFloor:
	LD   A,S_EXPLOSION			; $09 boom!
	CALL PlaySound
	LD   IX,BaddyData6			; Baddy6 == an explosion 
	LD   (IX+TYP),$00
	LD   (IX+GNO),G_EXPLOSION	;$1D
	LD   A,(MortarBombX)
	SUB  $08
	AND  $F8
	LD   (IX+XNO),A			; xno
	LD   E,A
	LD   (IX+YNO),$90			; YNO
	LD   (IY+$3E),$08			; FFC0 - ExplosionCounter
	LD   HL,(PlayerX)
	LD   A,L
	ADD  A,$08
	LD   L,A
	LD   D,$90
	LD   C,$18
	LD   B,$10

	if NO_BADDY_COLLISIONS != 1
		CALL TestHitPlayer
	endif

MortarBombOffScreen:
	XOR  A
	LD   (MortarInFlight),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateExplosion:
	LD   A,(ExplosionCounter)
	OR   A
	RET  Z
	DEC  A
	LD   (ExplosionCounter),A
	JR   NZ,StillExploding
	LD   A,$FF
	LD   (BaddyData6),A
	RET 

StillExploding:
	BIT  0,A
	RET  NZ
	LD   A,(BaddyData6XNO)			; XNO
	XOR  $04
	LD   (BaddyData6XNO),A			; XNO
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TryShootWeapon:
	LD   A,(isShooting)
	OR   A
	JR   NZ,UpdateWeapon

	BIT  5,(IY+$25)			; LastFUDLR
	RET  NZ

	BIT  5,(IY+$28)			; SFUDLR (shoot +fudlr)
	RET  Z
	
	LD   A,(isSnappedToLadder)
	OR   A
	RET  NZ
	
	LD   A,(HasWeapon)
	OR   A
	RET  Z
	
	ADD  A,A
	LD   (isShooting),A
	LD   HL,ShootFunctions
	CALL AddHLA
	CALL JPIndex
	
	LD   A,(WeaponCount)
	DEC  A
	LD   HL,$5AC2
	ADD  A,A
	ADD  A,A
	ADD  A,L
	LD   L,A
	XOR  A
	LD   (HL),A			; blank out shooter weapon's attributes
	INC  L
	LD   (HL),A
	INC  L
	LD   (HL),A
	LD   DE,$001E
	ADD  HL,DE
	LD   (HL),A
	INC  L
	LD   (HL),A
	INC  L
	LD   (HL),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateWeapon:
	LD   HL,ShootUpdateFunctions
	CALL AddHLA
	JP   JPIndex

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ShootFlameThrower:
	LD   HL,BossFlameThrowerOffset
	LD   DE,gfx_FlameThrowerRight
	LD   C,$00
	LD   A,(PlayerDir)
	AND  $01
	LD   (FlameThrowerActive),A
	JR   Z,label_B5E6

	LD   DE,gfx_FlameThrowerLeft
	LD   C,$08
	INC  HL

label_B5E6:
	LD   A,(WeaponX)
	LD   (FlameThrowerSpriteData),DE
	LD   (FlameThrowerSpriteData2),DE
	ADD  A,(HL)
	AND  $F8
	INC  HL
	JR   Z,label_B5FB
	CP   $C0
	JR   C,label_B5FC
label_B5FB:
	XOR  A
label_B5FC:
	LD   (FlameThrowerX),A
	ADD  A,C
	LD   (FlameThrowerXNew),A
	LD   A,(WeaponY)
	SUB  $02
	LD   (FlameThrowerY),A
	LD   (FlameThrowerYNew),A
	
	LD   HL,DrawFlameThrower
	LD   (WeaponMod+1),HL
	LD   (IY+$3B),$10			; IY+$3B FlameThrowerInFlight
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ShootRocketLauncher:
	LD   HL,RocketLauncherXYOffsets
	LD   A,(PlayerDir)
	AND  $01
	LD   E,A
	ADD  A,A
	CALL AddHLA
	LD   A,(WeaponX)
	ADD  A,(HL)
	INC  HL
	LD   (GrenadeX),A
	LD   A,(WeaponY)
	LD   (GrenadeY),A
	LD   A,E			; PlayerDir
	ADD  A,$02
	LD   (GrenadeGNO),A
	LD   A,(WeaponX)
	ADD  A,(HL)
	LD   (WeaponX),A
	LD   HL,DrawBigWeapon
	LD   (WeaponMod+1),HL
	LD   A,S_WEAPONLAUNCH	;$07
	JP   PlaySound

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ShootGrenade:
	LD   A,(PlayerX)
	ADD  A,$08
	LD   (GrenadeX),A
	LD   A,(PlayerY)
	LD   (GrenadeY),A
	LD   (GrenadeYStart),A
	LD   (IY+$41),$32			; FFC3 - GrenadeYIndex
	LD   C,$00
	CP   $51
	JR   C,label_B66D
	INC  C
	CP   $71
	JR   C,label_B66D
	INC  C
label_B66D:
	LD   A,(PlayerLieDown)
	OR   A
	LD   A,C
	JR   Z,label_B675
	DEC  A
label_B675:
	LD   (GrenadeStartIndex),A
	LD   A,$05
	LD   (GrenadeGNO),A
	LD   A,(PlayerDir)
	AND  $01
	LD   A,$04
	JR   Z,label_B688
	NEG  
label_B688:
	LD   (GrenadeXVelMOD+1),A
	LD   HL,DrawBigWeapon
	LD   (WeaponMod+1),HL
	LD   A,S_WEAPONLAUNCH		; $07
	JP   PlaySound

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateFlameThrower:
	LD   A,(FlameThrowerActive)
	OR   A
	LD   A,(FlameThrowerX)
	JR   Z,label_B6A9
	SUB  $08
	LD   (FlameThrowerX),A
	CP   $F8
	JR   Z,label_B6B1
	RET 
label_B6A9:
	ADD  A,$08
	LD   (FlameThrowerX),A
	CP   $E0
	RET  NZ
label_B6B1:
	SET  7,(IY+$3A)			; FlameThrowerActive = set bit 7 to disable
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateRocketLauncher:
	LD   A,(GrenadeGNO)
	AND  $01
	LD   A,(GrenadeX)
	JR   NZ,label_B6D3
	ADD  A,$06
	LD   C,A
	LD   A,R
	LD   A,C
	JP   P,label_B6CB
	SUB  $02
label_B6CB:
	LD   (GrenadeX),A
	CP   $F6
	JR   NC,label_B6E4
	RET 
label_B6D3:
	SUB  $06
	LD   C,A
	LD   A,R
	LD   A,C
	JP   P,label_B6DE
	SUB  $02
label_B6DE:
	LD   (GrenadeX),A
	CP   $F0
	RET  C

label_B6E4:
	XOR  A
	LD   (isShooting),A
	LD   A,(WeaponCount)
	DEC  A
	LD   (WeaponCount),A
	RET  NZ
	LD   A,(HasWeapon)
	LD   (IY+$33),$00			; FFB5 - HasWeapon
	CP   $03
	RET  Z
	LD   A,low PreShiftOffs_Weapons		;$B6			; a0b6 - PreShiftOffs_Weapons low
	LD   (PreShiftOffsetMod+1),A
	LD   HL,WeaponYTMP
	CALL EraseSpriteAboveMap8
	LD   A,low PreShiftOffs_Characters	;$C6			; a0c6 - PreShiftOffs_Characters low
	LD   (PreShiftOffsetMod+1),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateGrenade:
	LD   A,(GrenadeYIndex)
	ADD  A,$05
	LD   (GrenadeYIndex),A
	CALL GetSineA
	ADD  A,A
	LD   C,A
	LD   A,(GrenadeYStart)
	ADD  A,$68
	SUB  C
	AND  $FE
	LD   (GrenadeY),A
	SUB  $10
	LD   B,A
	LD   A,(GrenadeX)
	CP   $10
	JR   C,label_B6E4
GrenadeXVelMOD:
	ADD  A,$04			; x +=4
	LD   C,A
	LD   A,R
	LD   A,C
	JP   P,NotScrolled2
	SUB  $02			; just scrolled, move an extra 2 pixels left
NotScrolled2:
	LD   (GrenadeX),A
	SUB  $08
	SRL  A
	LD   HL,(MapXAtScrollBoundary)
	CALL AddHLA
	EX   DE,HL
	LD   A,(GrenadeStartIndex)
	LD   HL,YStarts
	CALL AddHLA
	LD   A,(HL)
	CP   B
	RET  NC
	INC  (IY+$43)			; FFC5 - GrenadeStartIndex
	PUSH HL
	CALL WhatsUnderMe
	POP  HL
	RET  NC
	LD   A,(GrenadeYIndex)
	CP   $78
	RET  C
	LD   (IY+$44),$FF				; isGrenadeExploding
	LD   IX,BaddyData6
	LD   (IX+TYP),$00				; TYP
	LD   (IX+GNO),G_EXPLOSION		; $1D			; GNO
	LD   A,(GrenadeX)
	SUB  $08
	AND  $F8
	LD   (GrenadeExplodeX),A
	LD   (IX+XNO),A			; XNO
	LD   A,(HL)
	LD   (IX+YNO),A			; YNO
	LD   (GrenadeExplodeY),A
label_B785:
	LD   (IY+$3E),$08			; $FFC0 - ExplosionCounter
	
	LD   A,S_EXPLOSION			; $09 BOOM!
	CALL PlaySound
	JP   label_B6E4

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ShootFunctions:
	dw DoNothing
	dw ShootFlameThrower
	dw ShootRocketLauncher

ShootUpdateFunctions:
	dw ShootGrenade
	dw UpdateFlameThrower
	dw UpdateRocketLauncher
	dw UpdateGrenade

BossFlameThrowerOffset:
	dw $D810

RocketLauncherXYOffsets:
	dw $FE18
	dw $02F9

MapXAtScrollBoundary:
	dw $0168

MortarSlot:
	dw $A050

gfx_Blades:			; four edge bytes of the helicopter rotors
	db $FF
	db $3F
	db $0F
	db $03

gfx_Floor:
	db $BD
	db $D3
	db $2B
	db $54
	db $41

LittleHelicopterGFXData:
	dw gfx_LittleHelicopter1
	dw gfx_LittleHelicopter2
	dw gfx_LittleHelicopter3
	dw gfx_LittleHelicopter4

ParachuteGFXData:
	dw gfx_Balloons1
	dw gfx_Balloons2
	dw gfx_Balloons3	;$C510
	dw gfx_Balloons4	;$C5F0

SpriteInstructionMODs:
	db $C1
	db $00
	db $13
	db $13
	db $01
	db $02
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $13
	db $13
	db $C1
	db $00
	db $01
	db $02
	db $00
	db $01

	db $02
	db $00
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0E
	db $00
	db $00

XYStore:
	dw $0000
GFXStore:
	dw $0000

MissileTopPositions:
	dw $02EB
	dw $0327
	dw $0363
	dw $039F

ScrollRowTable:
	dw $59A2
	dw $59C2
	dw $59E2
	dw $5A02
	dw $5A22
	dw $5A42
	dw $5A62
	dw $5A82

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddies:
	LD   IX,BaddyData
	LD   B,$05
BaddyLoop:
	LD   A,(IX+TYP)			; TYP
	OR   A
	JP   M,NextBaddy

	PUSH BC
	CALL UpdateBaddy
	CALL Randomise
	LD   A,(IX+TYP)			; TYP
	OR   A
	JP   M,PopNextBaddy

	CP   T_BADDYDIE			; TYP 9 - BADDYDIE
	JR   Z,PopNextBaddy

	CP   T_BADDYDOGDIE		; TYP 14 - BADDYDOGDIE
	JR   Z,PopNextBaddy
	
	LD   A,(IsStabbing)
	OR   A
	CALL NZ,CollideKnife

	LD   A,(isGrenadeExploding)
	OR   A
	CALL NZ,CollideGrenadeExplosionToBaddy
	
	LD   A,(isShooting)			; non zero = what shooting weapon fired
	OR   A
	JR   Z,PopNextBaddy
	
	LD   HL,CollisionFuncs-2	; label_B8B4+28	- $b8d0 (collisionFuncs) - 2 
	CALL AddHLA
	CALL JPIndex

PopNextBaddy:
	POP  BC

NextBaddy:
	LD   DE,$0010			; move on 16 bytes to next baddy structure
	ADD  IX,DE
	DJNZ BaddyLoop

	XOR  A
	LD   (isGrenadeExploding),A
	DEC  (IY+$39)			; FFBB - MortarFireCountdown
	RET  NZ

	LD   (IY+$39),$24			; FFBB - MortarFireCountdown
	LD   A,(MortarToggle2)			; b941 toggle used by mortar
	CPL
	LD   (MortarToggle2),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CollideFlameThrower:
	LD   HL,(FlameThrowerX)
	PUSH HL
	LD   H,$38
	LD   E,(IX+$0A)			; XNO
	LD   D,$14
	CALL HitA
	POP  HL
	RET  C
	LD   L,H
	LD   H,$08
	LD   E,(IX+$0B)			; YNO
	LD   D,$18
	CALL HitA
	RET  C
	JP   KillBaddy

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CollideGrenade:
	LD   HL,(GrenadeX)
	PUSH HL
	LD   H,$0A
	LD   E,(IX+XNO)			; XNO
	LD   D,$14
	CALL HitA
	POP  HL
	RET  C

	LD   L,H
	LD   H,$08
	LD   E,(IX+YNO)			; YNO
	LD   D,$18
	CALL HitA
	RET  C
	
	LD   A,(IX+TYP)			; TYP
	CP   T_DOGRIGHTANDJUMP			; Dogs
	JP   NC,KillDog

	JP   KillBaddy

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CollideGrenadeExplosionToBaddy:
	LD   A,(GrenadeExplodeX)
	SUB  $20
	JR   NC,label_B8AC

	XOR  A
label_B8AC:
	LD   L,A
	CPL
	CP   $50
	JR   C,label_B8B4
	LD   A,$50
label_B8B4:
	LD   H,A
	LD   E,(IX+$0A)			; XNO
	LD   D,$14
	CALL HitA
	RET  C
	LD   A,(GrenadeExplodeY)
	SUB  $08
	LD   L,A
	LD   H,$18
	LD   E,(IX+$0B)			; YNO
	LD   D,$18
	CALL HitA
	RET  C
	JP   KillBaddy

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CollisionFuncs:
	dw CollideFlameThrower
	dw CollideGrenade
	dw DoNothing

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CollideKnife:
	LD   A,(KnifeXNO)
	LD   L,A
	LD   H,$08
	LD   E,(IX+XNO)			; XNO
	LD   D,$14
	LD   A,(IX+TYP)			; TYP
	CP   T_DOGRIGHTANDJUMP	; $0B
	JP   NC,StabDogs

	CALL HitA
	RET  C

	LD   A,(PlayerLieDown)
	OR   A
	LD   A,(KnifeYNO)
	JR   Z,.NotLyingDown
	
	SUB  $10
.NotLyingDown:
	LD   E,(IX+YNO)			; YNO
	INC  A
	LD   L,A
	LD   H,$02
	LD   D,$10
	CALL HitA
	RET  C

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

KillBaddy:
	LD   A,(IX+TYP)				; TYP
	CP   T_BADDYCOMMANDANT		; Commandant
	JR   Z,KillCommandant

	PUSH AF
	ADD  A,A
	LD   HL,HitPoints
	CALL AddHLA
	LD   D,(HL)
	LD   E,$03
	INC  HL
	PUSH HL
	CALL AddScore
	POP  HL
	LD   D,(HL)
	LD   E,$04
	CALL AddScore
	POP  AF
	CP   T_BADDYPARACHUTE
	JR   NZ,DoKill

	XOR  A						; TYP == 4 (T_BADDYPARACHUTE)
	LD   (ParachuteGuyTriggered),A
	LD   C,$20					; 32 pixel high block
	CALL ClearScreenBlock

DoKill:
	LD   (IX+TYP),T_BADDYDIE	; TYP = Baddy Die
	LD   (IX+CNT2),$04			; CNT2 - how long to die for
	LD   A,(IX+XNO)				; XNO
	AND  $F8					; 11111000
	LD   (IX+XNO),A				; align to an 8 pixel boundary
	LD   A,(IX+YNO)				; YNO
	CP   $92
	JR   C,NoClamp
	LD   (IX+YNO),$90			; Clamp YNO to $90 (144)

NoClamp:
	LD   A,(IX+FLAG)			; FLAGS
	AND  $03
	DEC  A
	ADD  A,G_SKELETONRIGHT		; GNO 18 +
	LD   (IX+GNO),A				; Set GNO
	LD   A,S_STAB				; $08
	JP   PlaySound

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

KillCommandant:
	LD   DE,$0102
	CALL AddScore
	LD   E,(IY+$34)				; FFB6 - isShooting
	LD   A,(TriggeredWeapon)
	LD   (HasWeapon),A			; pickup shooter weapon
	DEC  A
	LD   C,A					; C = WeaponType
	LD   B,G_BAZOOKA			; B = Graphic Num
	LD   A,$04
	JR   NZ,.NotFlameThrower

	DEC  A						; using a Flame Thrower
	DEC  B
.NotFlameThrower:
	INC  E
	DEC  E
	JR   Z,.SetWeapon

	INC  A
.SetWeapon:
	LD   (WeaponCount),A
	LD   A,B
	LD   (WeaponGNO),A
	LD   A,C					; weapon type
	ADD  A,A
	LD   HL,WeaponStrings
	CALL AddHLA
	CALL HLFromHL
	LD   (WeaponStringAddress),HL			; set character codes to draw shooter weapon
	
	CALL JP_Sprint		; Draw the picked up weapons
	db JSRS				; JSR STRG
WeaponStringAddress:
	dw $0000			; mod
	db PEN, $FF			
	db FIN				; FIN
	JR   DoKill			; now kill the commandant baddy

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;


StabDogs:				; Enters with A = TYP
	LD   D,$18
	CP   T_DOGLEFT		; $0C
	JR   Z,isDogLeft

	CALL HitA
	RET  C

	LD   A,(KnifeYNO)
	INC  A
	LD   L,A
	LD   E,(IX+YNO)			; YNO
	LD   H,$02
	LD   D,$10
	CALL HitA
	RET  C

	JR   KillDog

isDogLeft:					; Dogs running left don't jump so can only bit hit when the player is lying down
	LD   A,(PlayerLieDown)
	OR   A
	RET  Z

	CALL HitA				; collide knife with dog when lying down
	RET  C

KillDog:
	LD   DE,$0203
	CALL AddScore
	LD   A,(IX+XNO)				; XNO
	ADD  A,$02
	LD   (IX+XNO),A				; XNO

	LD   A,S_KICK				; $05
	LD   (PlayingSound),A
	LD   (IX+TYP),T_BADDYDOGDIE	; Baddy Dog Die 
	LD   (IX+CNT2),$04			; CNT2
	JP   PlaySound

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

WeaponStrings:
	dw Weapon1Image
	dw Weapon2Image
	dw Weapon3Image

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

HitPoints:
	dw $0002
	dw $0501
	dw $0502
	dw $0003
	dw $0000
	dw $0501
	dw $0501
	dw $0503
	dw $0505
	dw $0000
	dw $0002

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateBaddy:				; enters with A = TYP, IX = Current BaddyData
	LD   HL,$000A
	LD   C,IXL
	LD   B,IXH
	ADD  HL,BC				; HL = BaddyData + 10 (offset to XNO, YNO, GNO etc
	EXX 
	ADD  A,A
	LD   E,A
	LD   D,$00
	LD   A,(IX+FLAG)		; FLAG
	OR   A
	JP   M,BaddyFalling

	LD   HL,BaddyRoutines
	ADD  HL,DE
	CALL JPIndex			; call the update routine for this baddy TYP

	LD   A,(IX+XNO)			; XNO
	CP   $E5
	JR   NC,BaddyOffScreen	;  x is between $05 and $E5
	
	CP   $05
	JR   C,BaddyOffScreen
	
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_Die:
	DEC  (IX+CNT2)			; CNT2
	RET  NZ

BaddyOffScreen:
	LD   A,(IX+TYP)			; TYP
	CP   T_BADDYPARACHUTE
	RET  Z					; return if PARACHUTEGUY
	
	LD   (IX+TYP),$80		; mark TYP as off screen
	CP   T_BADDYRUNTURN		; running away enemy?
	RET  NZ

	LD   (IX+TYP),$FF		; if TYP == 6 (T_BADDYRUNTURN) mark TYP as $FF
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_RunAndGun:
	EXX 
	PUSH HL
	CALL GetMapXForBaddy
	CALL DetectLadders
	POP  DE
	LD   A,(IX+FLAG)			; FLAG
	AND  $0C					; 0000 1100 - Player above / below bits
	JR   NZ,PlayerAboveOrBelow

	BIT  6,(IX+FLAG)			; FLAG - marked for re-use 
	JP   NZ,SetRunningChangeDir	; make bad exit the level so we can reuse the slot

	LD   A,(RND2)
	AND  $7F
	JP   Z,ShootAtPlayer

	INC  DE
	LD   A,(DE)
	DEC  DE					; DE = BADDY XNO
	LD   C,A				; C = BADDY YNO
	LD   A,(PlayerLieDown)
	OR   A
	LD   A,(PlayerY)
	JR   Z,PlayerUpright

	SUB  $0C				; Player Y - 12
PlayerUpright:
	CP   C
	JR   Z,UpdateBaddySprite
	JR   C,PlayerAbove

	SET  2,(IX+FLAG)			; FLAG - Bit2 says we're below the player
	JR   UpdateBaddySprite

PlayerAbove:
	SET  3,(IX+FLAG)			; FLAG - Bit3 says we're above player

UpdateBaddySprite:				; update a baddy moving and falling, but no climb handling here
	LD   E,(IX+MAPXL)			; MAPX lo
	LD   D,(IX+MAPXH)			; MAPX high
	LD   A,(IX+YNO)				; YNO
	CALL WhatsUnderMe
	JP   NC,NothingUnderneath

MoveSprite:
	CALL UpdateSpriteX
	DEC  (IX+CNT2)			; CNT2
	RET  NZ

	LD   A,(IX+CNT1)		; CNT1
	LD   (IX+CNT2),A		; CNT2
	
	LD   A,(IX+GNO)			; GNO animate
	XOR  $01
	LD   (IX+GNO),A			; GNO
	RET 

PlayerAboveOrBelow:			;ie player isn't on the same row as this baddy
	LD   C,$04
	LD   B,C
	SRL  A
	SRL  A
	SRL  A
	JR   C,PlayerBelow

	LD   C,$FC				; -4 we're above
	LD   B,$00

PlayerBelow:
	LD   A,C				; Y Move amount up or down
	CALL CheckOnLadder
	JR   NC,BaddyNotOnLadder

	LD   (IX+GNO),G_BADDYCLIMB	;$22			; GNO

Baddy_MoveLeftWithScroll:
	LD   A,R				; R flags when a scroll has happened
	RET  P

	DEC  (IX+XNO)			; xno - move baddy with the scroll
	DEC  (IX+XNO)			; 
	RET 

BaddyNotOnLadder:
	LD   A,(IX+GNO)			; GNO
	CP   G_BADDYCLIMB		; $22
	JR   NZ,.NotClimbing

	LD   C,$01
	LD   A,(PlayerX)		; see which side of the player the baddy is on
	CP   (IX+XNO)			; XNO
	JR   NC,.SetDirection
	INC  C
.SetDirection:
	LD   (IX+FLAG),C		; FLAG
	LD   A,G_GUNRUNNERRIGHT	; $16
	ADD  A,C				; add on which way baddy should be facing
	LD   (IX+GNO),A			; GNO

.NotClimbing:
	LD   A,(IX+FLAG)		; FLAG
	AND  $F3				; 1111 0011
	LD   (IX+FLAG),A		; clear out the above/below bits - so we're on the same level as the player.

	BIT  6,(IX+FLAG)		; flagged to leg it so we can reuse the slot
	JP   NZ,SetRunningChangeDir

	JR   UpdateBaddySprite

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ShootAtPlayer:
	LD   (IX+TYP),T_BADDYSHOOTING	; TYP - 5 = Shooting enemy with gun
	LD   (IX+CNT2),$0A				; CNT2
	LD   A,(IX+GNO)					; GNO
	OR   $01
	LD   (IX+GNO),A					; GNO
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_Stopped:
	EXX 
	CALL Baddy_MoveLeftWithScroll
	DEC  (IX+CNT2)				; CNT2 - time before resuming run
	RET  NZ

	INC  (IX+CNT2)				; CNT2
	LD   (IX+TYP),T_BADDYGUN	; TYP = Running with Gun
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_Shooting:
	EXX 
	CALL Baddy_MoveLeftWithScroll
	DEC  (IX+CNT2)			; CNT2 - countdown to firing
	RET  NZ

	INC  (IX+CNT2)			; CNT2
	CALL FindSpareBullet
	RET  P
	
	LD   (IX+CNT2),$08				; CNT2
	LD   (IX+TYP),T_BADDYSTOPPED	; Switch to TYP = Stopped Enemy
	LD   A,(IX+GNO)					; GNO
	SRL  A
	AND  $01
	XOR  $01

LaunchBullet:
	LD   (HL),A
	INC  L
	LD   A,(IX+XNO)			; XNO
	ADD  A,$08
	LD   (HL),A
	INC  L
	LD   A,(IX+YNO)			; YNO
	ADD  A,$08
	LD   (HL),A
	LD   A,S_SHOOTBULLET	; $03
	JP   PlaySound

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_Running:
	EXX 
	PUSH HL
	CALL GetMapXForBaddy
	POP  DE
	BIT  6,(IX+FLAG)			; FLAG
	JP   NZ,SetRunningChangeDir
	JP   UpdateBaddySprite

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_Jumping:
	EXX 
	CALL GetMapXForBaddy
	LD   E,(IX+MAPXL)			; MAPX Lo
	LD   D,(IX+MAPXH)			; MAPX High
	LD   A,(IX+BASEY)			; BASEY
	LD   (IX+YNO),A				; YNO
	CALL WhatsUnderMe
	JP   NC,NothingUnderneath
	
	CALL UpdateSpriteX
	LD   A,(IX+CNT2)			; CNT2
	INC  A
	AND  $07
	JR   NZ,StillJumping

	BIT  6,(IX+FLAG)			; done a jump cycle, now check...
	JP   NZ,SetRunningChangeDir

	LD   A,(IX+GNO)			; GNO
	XOR  $01
	LD   (IX+GNO),A			; GNO
	LD   A,S_BADDYJUMP		; $04
	CALL PlaySound
	XOR  A

StillJumping:
	LD   (IX+CNT2),A		; CNT2
	LD   HL,JumpArc
	CALL AddHLA
	LD   A,(IX+BASEY)		; BASEY
	SUB  (HL)
	LD   (IX+YNO),A			; YNO
	LD   A,(IX+XNO)			; XNO
	LD   C,A
	LD   A,(PlayerX)
	CP   C
	RET  NC

	ADD  A,$24
	CP   C
	RET  C

	LD   (IX+TYP),T_BADDYKICK		; TYP_JUMPKICK
	LD   (IX+GNO),G_JUMPKICKBADDY	; $1C			; GNO
	LD   A,(IX+XNO)					; XNO
	SUB  $04						; -4
	LD   (IX+XNO),A					; XNO
	LD   A,(IX+BASEY)				; BASEY
	SUB  $10
	LD   (IX+YNO),A					; YNO
	LD   (IX+CNT2),$10				; CNT2
	LD   A,S_KICK					; $05
	JP   PlaySound

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_Kicking:
	EXX 
	CALL UpdateSpriteX
	DEC  (IX+CNT2)						; CNT2
	RET  NZ								; not finished kicking

	LD   (IX+TYP),T_BADDYJUMPER			; set back to TYP_JUMPINGENEMY
	LD   (IX+GNO),G_RUNNINGBADDYLEFT1	; $10			; GNO
	LD   (IX+CNT2),$07					; CNT2
	LD   A,(IX+BASEY)					; BASEY
	LD   (IX+YNO),A						; YNO
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

JumpArc:
	db $00
	db $02
	db $04
	db $06
	db $06
	db $04
	db $02
	db $00

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_Mortar:
	EXX 
	LD   A,(MortarFireCountdown)
	DEC  A
	JR   NZ,SetMortarGuyDirection

	LD   A,(MortarToggle2)
	CP   (IX+CNT2)			; CNT2
	JR   NZ,SetMortarGuyDirection
	
	LD   HL,$04FE			; L = Xoffset
	LD   A,(IX+GNO)			; GNO - which way MortarGuy is facing
	AND  $01
	JR   NZ,SetXOffset

	LD   L,$10				; L = XOffset
SetXOffset:
	INC  A
	LD   (MortarInFlight),A
	LD   A,(IX+XNO)			; XNO
	ADD  A,L
	LD   (MortarBombX),A
	LD   A,(IX+YNO)			; YNO
	ADD  A,H
	LD   (MortarBombY),A
	LD   (IY+$38),$15

SetMortarGuyDirection:
	LD   C,G_MORTARGUYRIGHT	; $1A		; GNO $1a
	LD   A,(PlayerX)
	CP   (IX+XNO)			; XNO
	JR   NC,SetMortarGuyGFX
	INC  C					; Make it G_MORTARGUYLEFT
SetMortarGuyGFX:
	LD   (IX+GNO),C			; GNO - face the player

	LD   A,R				; scrolled?
	RET  P

	DEC  (IX+XNO)			; if a scroll has happened move this static sprite two pixels to the left
	DEC  (IX+XNO)			; 
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_Parachute:
	EXX 
	LD   A,(BossBaddyX)
	ADD  A,$0E
	LD   (IX+XNO),A			; XNO
	LD   A,(BossBaddyY)
	ADD  A,$20
	LD   (IX+YNO),A			; YNO
	LD   A,(RND3)
	AND  $0F
	RET  NZ

	CALL FindSpareBullet
	RET  P

	LD   A,$03
	JP   LaunchBullet

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_RunningNoClimb:
	EXX 
	PUSH HL
	CALL GetMapXForBaddy
	POP  DE
	JP   UpdateBaddySprite

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_Commandant:
	EXX 
	PUSH HL
	CALL GetMapXForBaddy
	POP  DE
	JP   UpdateBaddySprite

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

SetRunningChangeDir:
	LD   C,$01
	LD   A,(IX+XNO)			; XNO
	OR   A
	JP   M,OnRight

	INC  C
OnRight:
	LD   (IX+FLAG),C		; FLAG
	LD   A,(IX+GNO)			; GNO
	DEC  C
	ADD  A,$02
	AND  $F8				; 1111 1000
	SRL  A
	ADD  A,C
	DEC  A
	ADD  A,A
	LD   (IX+GNO),A					; GNO
	LD   (IX+TYP),T_BADDYRUNTURN	
	LD   (IX+XSPD),$01				; XSPD
	LD   (IX+CNT2),$01				; CNT2
	LD   (IX+CNT1),$01				; CNT1
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateSpriteX:
	LD   A,(IX+FLAG)		; FLAG
	AND  $03
	RET  Z					; not moving

	LD   C,A				; C = FLAG
	LD   A,(IX+XSPD)		; XSPD
	ADD  A,A
	LD   E,A
	LD   D,$00
	LD   HL,MovementSpeeds
	ADD  HL,DE
	DEC  C
	JR   Z,.MovingRight
	
	INC  HL
.MovingRight:
	LD   A,(IX+XNO)			; XNO
	ADD  A,(HL)				; add on speed
	LD   C,A				; C = XNO + XSPD

	LD   A,R				; scrolled?
	JP   P,NoScrollCompensate

	DEC  C					; compensate position if we've scrolled
	DEC  C

NoScrollCompensate:
	LD   (IX+XNO),C			; XNO
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

NothingUnderneath:
	LD   A,(IX+YNO)			; YNO
	LD   (IX+BASEY),A		; BASEY
	LD   (IX+DIR),A
	LD   (IX+CNT2),$79		; CNT2

	SET  7,(IX+FLAG)		; bit 7 = falling

	LD   A,S_FALL			; $02
	CALL PlaySound
	JR   DoFall


BaddyFalling:
	LD   A,(IX+CNT2)		; CNT2
	ADD  A,$04
	LD   (IX+CNT2),A		; CNT2
	CALL GetSineA
	ADD  A,A
	LD   C,A
	LD   A,(IX+BASEY)		; BASEY
	ADD  A,$68
	SUB  C
	AND  $FE
	CP   $92
	JR   NC,Landed

	LD   (IX+YNO),A			; YNO
	EXX 
	CALL GetMapXForBaddy

DoFall:
	CALL UpdateSpriteX
	LD   C,(IX+DIR)			
	LD   A,(IX+YNO)			; YNO
	ADD  A,$02
	CP   C
	RET  C

	LD   A,C
	ADD  A,$20
	LD   (IX+DIR),A			
	LD   A,C
	LD   E,(IX+MAPXL)		; MAPX lo
	LD   D,(IX+MAPXH)		; MAPX high
	CALL WhatsUnderMe
	RET  NC

	LD   A,(IX+DIR)			
	SUB  $20
	LD   (IX+YNO),A			; YNO

Landed:
	RES  7,(IX+FLAG)		; FLAG - clear falling bit 7
	LD   (IX+CNT2),$01		; CNT2
	LD   A,(IX+YNO)			; YNO
	LD   (IX+BASEY),A		; BASEY
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

MovementSpeeds:
	db $03
	db $FE
	db $04
	db $FD

BaddyRoutines:
	dw Baddy_RunAndGun
	dw Baddy_Running
	dw Baddy_Jumping
	dw Baddy_Mortar
	dw Baddy_Parachute
	dw Baddy_Shooting
	dw Baddy_RunningNoClimb
	dw Baddy_Kicking
	dw Baddy_Commandant
	dw Baddy_Die
	dw Baddy_Stopped
	dw Baddy_DogRunRightAndJump
	dw Baddy_DogRunLeft
	dw Baddy_JumpingDog
	dw Baddy_Die

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_DogRunRightAndJump:
	LD   A,(IX+XNO)			; XNO
	ADD  A,$04
	LD   (IX+XNO),A			; XNO
	CP   $E4
	JP   NC,BaddyOffScreen

	LD   C,A				; Dog X
	LD   A,(PlayerX)
	CP   C
	RET  C
	
	SUB  $40				; > 64 pixels away from player
	JR   NC,.CheckDistance
	
	LD   A,$10				; 16 pixels away
.CheckDistance:
	CP   C					
	RET  NC					; Dog > C pixels away
	
	LD   (IX+TYP),T_DOGJUMP		; TYP = JumpingDog
	LD   (IX+CNT2),$3A			; CNT2 - index into sine table for jump
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_DogRunLeft:
	LD   A,(IX+XNO)			; XNO
	SUB  $04
	LD   (IX+XNO),A			; XNO
	JP   C,BaddyOffScreen

	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Baddy_JumpingDog:
	LD   A,(IX+XNO)			; XNO
	ADD  A,$04
	LD   (IX+XNO),A			; XNO
	CP   $E4
	JP   NC,BaddyOffScreen

	LD   A,(IX+CNT2)		; CNT2
	ADD  A,$03
	LD   (IX+CNT2),A		; CNT2
	CALL GetSineA
	LD   C,A
	LD   A,$D0
	SUB  C
	AND  $FE
	LD   (IX+YNO),A			; YNO
	CP   $98
	RET  C
	
	LD   (IX+YNO),$98			; YNO snapped to $98
	LD   (IX+TYP),T_DOGRIGHTANDJUMP	; TYP = dog right
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ResetBaddies:
	LD   HL,BaddyData
	LD   DE,$0010
	LD   B,$06

ResetLp:
	LD   (HL),$80
	ADD  HL,DE
	DJNZ ResetLp
	
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

InitBaddyBullets:
	LD   B,$04
	LD   HL,BaddyBullets+2	; YNO
NextBulletInit:
	PUSH BC
	PUSH HL
	LD   (HL),$18			; YNO
	DEC  HL
	LD   (HL),$00			; XNO
	DEC  HL
	CALL DrawBullet
	LD   (HL),$80			; GNO
	POP  HL
	LD   DE,$0007
	ADD  HL,DE
	POP  BC
	DJNZ NextBulletInit
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

FindSpareBullet:			; A=NZ if found, returns bullet slot in HL
	LD   B,$04
	LD   HL,BaddyBullets
	LD   DE,$0007
	JR   FindSlot

FindBaddySlotFirst3:
	LD   B,$03
	LD   HL,BaddyData
	LD   DE,$0010
	LD   A,(ParachuteGuyTriggerCountdown)
	OR   A
	JR   NZ,TryNextSlot

	LD   A,(WeaponTriggerCountdown)
	OR   A
	JR   NZ,TryNextSlot

	JR   FindSlot

FindBaddySlot4or5:
	LD   B,$02
	LD   HL,BaddyData4
	LD   DE,$0010
	JR   FindSlot

FindBaddySlot:
	LD   B,$05
	LD   HL,BaddyData
	LD   DE,$0010
FindSlot:			; HL = baddy data structure, b = number of structs to search, de = size of structure
	LD   A,(HL)
	INC  A
	JR   Z,TryNextSlot

	DEC  A
	RET  M			; found slot (returns in HL)

TryNextSlot:
	ADD  HL,DE
	DJNZ FindSlot

	XOR  A			; no slot found
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

IntroduceBaddies:
	LD   A,(EndofLevelTrigger)
	OR   A
	JR   Z,NotLevelEnd
	JP   M,EndOfLevel

CheckActiveBaddies:
	LD   HL,BaddyData
	LD   DE,$0010
	LD   B,$06

BaddyActiveLoop:
	LD   A,(HL)
	OR   A
	RET  P								; a baddy is active, we're done

	ADD  HL,DE
	DJNZ BaddyActiveLoop

	LD   (EndofLevelTrigger),A			; no baddies are active
	RET 

NotLevelEnd:
	DEC  (IY+$3D)						; $FFBF- NextBaddyCountdown
	RET  NZ

	LD   A,(BaddyCountdownTime)
	LD   (NextBaddyCountdown),A
	LD   HL,(MapLandRow1)
	PUSH HL
	LD   DE,(MapXAtScrollBoundary)
	INC  DE

	LD   BC,$0100			; C = holds bit mask of each map row edge that is walkable
	PUSH BC
	PUSH DE
	CALL ScanHorizontalRow
	POP  DE
	POP  BC
	RL   C
	LD   HL,(MapLandRow2)
	PUSH BC
	CALL ScanHorizontalRow
	POP  BC
	RL   C
	POP  HL
	LD   DE,(MapX)
	DEC  DE
	LD   B,$04
	PUSH BC
	PUSH DE
	CALL ScanHorizontalRow
	POP  DE
	POP  BC
	RL   C
	LD   HL,(MapLandRow2)
	PUSH BC
	CALL ScanHorizontalRow
	POP  BC
	RL   C
	CALL FindBaddySlotFirst3
	JP   P,TrySlots4and5		; no free slots in the first 3 baddies

	PUSH HL
	POP  IX
	LD   A,(RND3)
	AND  (IY+$5F)			; $FFE1 - RandMask
	JR   NZ,NotJumper

SpawnJumper:
	LD   D,$FF				; D = -ve, Spawn a Jumping baddy
	JR   SpawnRight			; jumping baddies only jump kick to the left, so spawn on the right

NotJumper:
	LD   A,(RND2)
	AND  $01
	LD   D,A				; D = Cannon fodder type 0 or 1

DoSpawn:
	LD   A,(RND1)
	AND  $01
	JR   NZ,SpawnLeft

SpawnRight:
	LD   L,$E4			; L = right side of screen
	LD   B,$02			; B = 0000 0010 = on right
	JR   SetSpawnRow

SpawnLeft:
	SRL  C				; shift out the right side walkable bits
	SRL  C
	LD   L,$06			; L = left side of screen
	LD   B,$01			; B = 0000 0001 = on left

SetSpawnRow:
	LD   A,(PlayerY)	; A = Player's Y pos
	CP   $60
	JR   NC,Row3Walkable

	BIT  1,C
	JR   Z,Row3Walkable
	
	LD   H,$50			; map row 1
	JR   SpawnBaddy

Row3Walkable:
	CP   $80			; map row 3
	JR   NC,SpawnRow4

	BIT  0,C
	JR   Z,SpawnRow4

	LD   H,$70			; map row 2
	JR   SpawnBaddy

SpawnRow4:
	LD   H,$90			; map row 4

SpawnBaddy:				; L = XNO, H = YNO
	LD   (IX+XNO),L			
	LD   (IX+YNO),H			
	
	LD   A,D			; D = -ve = spawn a jumping baddy, else 0 or 1 for spawn type
	OR   A
	JP   M,SetSpawnJumper

	LD   (IX+FLAG),B
	ADD  A,A
	LD   HL,CannonFodderBaddies
	CALL AddHLA
	LD   A,(HL)
	SRL  B
	SRL  B
	ADC  A,$01
	LD   (IX+GNO),A			; GNO
	INC  HL
	LD   A,(HL)
	LD   (IX+TYP),A			; TYP

	LD   A,(RND6)
	AND  $03
	INC  A
	LD   (IX+CNT1),A		; CNT1
	LD   (IX+CNT2),$01		; CNT2
	RET 

SetSpawnJumper:
	LD   (IX+TYP),T_BADDYJUMPER			; TYP 2 - Jumping Enemy
	LD   (IX+FLAG),$02					; FLAG
	LD   (IX+BASEY),H					; BASEY
	LD   (IX+GNO),G_RUNNINGBADDYLEFT1	; $10				; GNO
	LD   (IX+CNT1),$00					; CNT1
	LD   (IX+CNT2),$07					; CNT2

DoNothing:
	RET 

TrySlots4and5:
	CALL FindBaddySlot4or5
	RET  P

	PUSH HL
	POP  IX
	LD   C,$00
	LD   A,(RND1)
	AND  (IY+$5F)			; $FFE1 - RandMask
	JP   Z,SpawnJumper

	LD   D,$01				; Spawn CannonFodder baddy 1 (BaddyRun)
	JP   DoSpawn

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

; two types of baddy to randomly trigger

CannonFodderBaddies:		
	db G_GUNRUNNERRIGHT		; $16				; GNO
	db T_BADDYGUN			; TYP 0 - running enemy with gun
	db G_RUNNINGBADDYRIGHT1	; $0E				; GNO
	db T_BADDYRUN			; TYP 1 = running enemy

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

EndOfLevel:
	LD   A,(EOLEndCountdown)
	OR   A
	JR   Z,DoEndOfLevelBoss

	CALL CheckActiveBaddies
	RET  P
	
	DEC  (IY+$4A)			; ffcc - EOLEndCountdown
	RET  NZ
	POP  HL
	RET 

DoEndOfLevelBoss:
	LD   A,(LevelNumber)
	AND  $03
	ADD  A,A
	LD   HL,EndOfLevelFunctions
	CALL AddHLA
	JP   JPIndex

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

EOL1_Boss:
	LD   A,(TruckActive)
	OR   A
	RET  Z

	DEC  (IY+$3D)						; FFBF - NextBaddyCountdown
	JR   NZ,NoSpawn
	
	LD   A,(BaddyCountdownTime)
	LD   (NextBaddyCountdown),A
	LD   A,$01							; A = $01 spawn running or running with gun baddy
	JR   SpawnEOL1Baddy

NoSpawn:
	DEC  (IY+$48)						; $FFCA - EOLBaddyCountdown
	RET  NZ
	LD   A,(EOLBaddyCountdownTime)		; when 0, spawn a jumping baddy
	LD   (EOLBaddyCountdown),A
	LD   A,$FF							; A = $FF = spawn jumping baddy

SpawnEOL1Baddy:
	EX   AF,AF'
	CALL FindBaddySlot
	RET  P
	PUSH HL
	POP  IX
	LD   A,(RND5)
	AND  $01
	LD   (IX+XSPD),A		; XSPD
	LD   HL,$90E4			; Y/X position
	LD   B,$02
	EX   AF,AF'
	LD   D,A				; d = type of baddy to spawn
	DEC  (IY+$49)			; $FFCB - EOLBaddiesRemaining
	JP   NZ,SpawnBaddy

	LD   (IY+$4A),$19		; $FFCC - EOLEndCountdown
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

EOL2_Boss:
	LD   A,(EOL2BaddyCountdownTime)	; countdown to starting EOL baddy spawns
	OR   A
	JR   Z,.DoEOL2Baddies
	DEC  (IY+$4B)			; FFCD - EOL2BaddyCountdownTime
	RET 

.DoEOL2Baddies:
	DEC  (IY+$3D)			; NextBaddyCountdown
	RET  NZ
	
	INC  (IY+$3D)			; NextBaddyCountdown
	CALL FindBaddySlot
	RET  P
	
	LD   A,(RND4)
	AND  $07
	ADD  A,(IY+$4E)			; $FFD0 - EOLBaseBaddyCountdown
	LD   (NextBaddyCountdown),A
	PUSH HL
	POP  IX
	LD   A,(FrameToggle)
	OR   A
	JR   NZ,.DogSpawnLeft
	
	LD   DE,$200B			; dog running right
	LD   BC,$0108
	JR   .DoDogSpawn

.DogSpawnLeft:
	LD   DE,$210C			; dog running left, GNO and TYP
	LD   BC,$02E4

.DoDogSpawn:
	LD   (IX+TYP),E				; TYP
	LD   (IX+FLAG),B			; FLAG
	LD   (IX+XSPD),$01			; XSPD
	LD   (IX+XNO),C				; XNO
	LD   (IX+YNO),$98			; YNO
	LD   (IX+GNO),D				; GNO
	LD   A,(EOL2SpawnCounter)
	DEC  A
	LD   (EOL2SpawnCounter),A
	JR   Z,.SpawnNextGroup

	CP   $02
	RET  NZ

	PUSH BC								; every 2 dogs spawned we spawn a runner
	CALL FindBaddySlot
	POP  BC
	RET  P
	
	PUSH HL
	POP  IX
	LD   L,C
	LD   H,$90
	LD   D,$01							; spawn running enemy
	JP   SpawnBaddy

.SpawnNextGroup:
	LD   (IY+$4D),$04					; FFCF - EOLSpawnCounter
	LD   A,(EOL2BaddySpawnTime)
	SUB  $04
	LD   (EOL2BaddySpawnTime),A			; Reduce spawn time
	LD   (EOL2BaddyCountdownTime),A		; set the new countdown time from the new spawn time

	LD   A,(FrameToggle)
	CPL
	LD   (FrameToggle),A
	DEC  (IY+$49)						; FFCB - EOLBaddiesRemaining
	RET  NZ

	LD   (IY+$4A),$19					; FFCC - EOLEndCountdown - we're done, start the countdown for EOL.
 	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

EOL4_Boss:
	LD   IX,BaddyData
	LD   A,(IX+TYP)			; TYP
	OR   A
	RET  P					; still alive

	SET  7,(IY+$3A)			; FFBC - FlameThrowerActive
	LD   HL,ELO4_FlameThrowerBoss
	LD   (BaddyRoutines),HL

	DEC  (IY+$49)			; FFCB - EOLBaddiesRemaining
	JR   NZ,.NotOver		; still baddies remaining to spawn
	
	LD   (IY+$4A),$18		; FFCC - EOLEndCountdown - start countdown to the level ending.
	RET 

.NotOver:
	LD   A,(FrameToggle)
	CPL
	LD   (FrameToggle),A
	OR   A
	LD   D,$00
	LD   B,$01				; B = spawn left
	JR   NZ,.SpawnRight

	LD   L,$08
	JR   .DoSpawn

.SpawnRight:
	INC  B
	LD   L,$E4				; XNO to spawn at
.DoSpawn:
	LD   H,$90				; YNO to spawn at
	JP   SpawnBaddy

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

ELO4_FlameThrowerBoss:
	LD   A,(EOLBaddyCountdown)
	OR   A
	JP   NZ,UpdateBossFlameThrower

	CALL MoveSprite
	DEC  (IY+$3D)			; FFBF - NextBaddyCountdown
	RET  NZ

	LD   A,(EOLBaseBaddyCountdown)
	LD   (NextBaddyCountdown),A
	LD   A,(PlayerX)
	LD   C,A
	LD   A,(IX+FLAG)		; FLAG
	SRL  A
	LD   A,(IX+XNO)			; XNO
	JR   C,.MovingRight

	CP   C					
	RET  C					; BaddyX < PlayerX

	JR   .BaddyTryFlameThrower

.MovingRight:
	CP   C
	RET  NC					;BaddyX > PlayerX

	CP   $B0
	RET  NC					; BaddyX > 176

.BaddyTryFlameThrower:
	LD   HL,BossFlameThrowerOffset
	LD   DE,gfx_FlameThrowerRight
	LD   C,$00
	LD   A,(IX+FLAG)					; FLAG
	AND  $03
	DEC  A
	LD   (FlameThrowerActive),A
	JR   Z,.FlameThrowerRight

	LD   DE,gfx_FlameThrowerLeft
	LD   C,$08
	INC  HL

.FlameThrowerRight:
	LD   (FlameThrowerSpriteData),DE
	LD   (FlameThrowerSpriteData2),DE
	LD   A,(IX+XNO)						; XNO
	AND  $F8
	ADD  A,(HL)
	INC  HL
	JR   Z,.ClampFlameThrowerX

	CP   $C0
	JR   C,.NoClamp

.ClampFlameThrowerX:
	XOR  A
.NoClamp:
	LD   (FlameThrowerX),A
	ADD  A,C
	LD   (FlameThrowerXNew),A
	LD   A,(RND4)
	AND  $01
	LD   A,$94
	JR   Z,BossFireFlameThrower		; fire flame thrower standing up

	LD   A,(IX+XNO)					; XNO
	AND  $F8
	BIT  0,(IX+FLAG)				; FLAG
	JR   NZ,.IsMovingRight

	ADD  A,$02
.IsMovingRight:
	LD   (IX+XNO),A					; XNO
	LD   (IX+YNO),$9C				; YNO

	LD   A,(IX+GNO)
	LD   (TempGNO),A
	LD   (IX+GNO),G_BADDYLIERIGHT	; Lie the boss down whilst firing the flame throwe
	LD   A,$A0

BossFireFlameThrower:
	LD   (FlameThrowerY),A
	LD   (FlameThrowerYNew),A
	LD   (EOLBaddyCountdown),A
	LD   (IY+$3B),$10				; FFBD - FlameThrowerInFlight
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Stage4EndUpdate:
	LD   A,(FlameThrowerActive)
	OR   A
	RET  M
	LD   A,(PlayerX)
	ADD  A,$0B
	LD   L,A
	LD   A,(PlayerY)
	ADD  A,$06
	LD   H,A
	LD   DE,(FlameThrowerX)
	LD   A,D
	SUB  $08
	LD   D,A
	LD   BC,$0E38
	if NO_BADDY_COLLISIONS != 1
		CALL TestHitPlayer
	endif
	JP   DrawFlameThrower

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

UpdateBossFlameThrower:
	CALL UpdateFlameThrower
	LD   A,(FlameThrowerActive)
	OR   A
	RET  P

	XOR  A
	LD   (EOLBaddyCountdown),A
	LD   A,(IX+GNO)			; GNO
	CP   G_BADDYLIERIGHT	; $23
	RET  NZ

	LD   (IX+YNO),$90		; YNO	; Stand the Boss back up again
	LD   A,(TempGNO)
	LD   (IX+GNO),A			; GNO
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

EndOfLevelFunctions:
	dw EOL1_Boss
	dw EOL2_Boss
	dw JP_EOL3_Boss
	dw EOL4_Boss

TempGNO:
	db $00

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

InitLevel:
	LD   A,(LevelNumber)
	AND  $03
	LD   C,A
	ADD  A,A
	ADD  A,C			; x3
	LD   HL,LevelInitFuncs
	CALL AddHLA
	LD   A,(HL)
	INC  HL
	LD   (MaxPlayerX),A
	INC  A
	LD   (ScrollBoundary),A
	SRL  A
	LD   (EndofLevelTrigger),A
	JP   JPIndex

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

EOLTriggerFunctions:
	dw EOL1_Start
	dw TriggerEOL2GuardsAndDogs
	dw EOL3_Start
	dw EOL4_Start

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

EOL3_Start:
	LD   DE,$2010
	CALL PixAddr
	LD   C,$48

.NextLine:
	LD   B,$1C
	LD   A,L

.Fill:
	LD   (HL),$00
	INC  L
	DJNZ .Fill
	
	LD   L,A
	CALL BytDW
	DEC  C
	JR   NZ,.NextLine

	JP   JP_TriggerEOL3Helicopters

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TriggerEOL1Truck:
	LD   HL,$8010
	LD   (TruckX),HL
	LD   (TruckX2),HL

EOL1_Start:
	LD   (IY+$49),$12			; FFCB - EOLBaddiesRemaining
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TriggerEOL2GuardsAndDogs:
	XOR  A
	LD   (FrameToggle),A
	INC  A
	LD   (IY+$4C),$1C			; FFCE - EOL2BaddySpawnTime
	LD   (IY+$49),$08			; FFCB - EOLBaddiesRemaining
	LD   (IY+$4D),$04			; FFCF - EOLSpawnCounter
	LD   (IY+$4E),$08			; FFD0 - EOLBaseBaddyCountdown
	LD   (EOL2BaddyCountdownTime),A
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

EOL4_Start:
	XOR  A
	LD   (FrameToggle),A
	LD   (EOLBaddyCountdown),A
	DEC  A
	LD   (FlameThrowerActive),A
	LD   (IY+$49),$04			; FFCB - EOLBaddisRemaining
	LD   (IY+$4E),$0A			; FFD0 - EOLBaseBaddyCountdown
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;
LevelInitFuncs:
	db $A0
	dw TriggerEOL1Truck
	db $D8
	dw TriggerEOL2GuardsAndDogs
	db $D8
	dw JP_TriggerEOL3Helicopters
	db $D8
	dw EOL4_Start

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

HitA:			; H=X1LEN, L=X1, E=X2, D=X2Len
	LD   A,H
	ADD  A,L
	CP   E
	RET  C
	LD   A,D
	ADD  A,E
	CP   L
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CollideWeaponsToMines:
	LD   B,$03
	LD   IX,MineXPositions

NextMine:
	LD   A,(IX+$00)
	OR   A
	JR   Z,MineNotActive

	EX   AF,AF'
	LD   A,(isGrenadeExploding)
	OR   A
	CALL NZ,CollideGrenadeExplosion

	LD   A,(isShooting)
	LD   HL,MineCollisionFuncs
	CALL AddHLA
	CALL JPIndex

MineNotActive:
	INC  IX
	DJNZ NextMine
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CollideMineToFlameThrower:
	LD   A,(FlameThrowerY)
	CP   $98
	RET  C

	EX   AF,AF'
	LD   L,A
	LD   H,$10
	LD   A,(FlameThrowerX)
	LD   E,A
	LD   D,$38
	JR   DoWeaponCol

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CollideMineToGrenade:
	LD   A,(GrenadeY)
	CP   $98
	RET  C

	EX   AF,AF'
	LD   L,A
	LD   H,$10
	LD   A,(GrenadeX)
	LD   E,A
	LD   D,H

DoWeaponCol:
	CALL HitA
	RET  C

	LD   (IX+$00),$00			; Kill mine sprite
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CollideGrenadeExplosion:
	LD   A,(GrenadeExplodeY)
	CP   $88
	RET  C

	EX   AF,AF'
	LD   L,A
	LD   H,$10
	LD   A,(GrenadeExplodeX)
	SUB  $20
	JR   NC,.NoClamp1

	XOR  A
.NoClamp1:
	LD   E,A
	CPL
	CP   $50
	JR   C,.NoClamp2

	LD   A,$50
.NoClamp2:
	LD   D,A
	JR   DoWeaponCol

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

MineCollisionFuncs:
	dw DoNothing
	dw CollideMineToFlameThrower
	dw CollideMineToGrenade
	dw DoNothing

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

StageEndAttacks:
	LD   A,(EndofLevelTrigger)
	OR   A
	RET  P

	LD   A,(LevelNumber)
	AND  $03
	ADD  A,A
	LD   HL,StageEndUpdateFunctions
	CALL AddHLA
	JP   JPIndex

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

Stage3EndUpdate:
	LD   B,$03
	LD   IX,HelicopterMovementData
	LD   HL,BossBaddyX

NextHeli:
	PUSH BC
	PUSH HL
	LD   A,(IX+DIR)			; bit 7 clear in direction flags means helicopter is alive
	OR   A
	CALL P,DrawHelicopter

	POP  HL
	POP  BC
	LD   DE,$0006
	ADD  HL,DE
	ADD  IX,DE
	DJNZ NextHeli

	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

StageEndUpdateFunctions:
	dw Stage1EndUpdate
	dw DoNothing
	dw Stage3EndUpdate
	dw Stage4EndUpdate

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

CollideWithPlayer:			; colliding with stuff!
	LD   B,$05				; 5 to test
	LD   IX,BaddyData
	LD   A,(PlayerX)
	CP   (IY+$36)			; FFB8 - ScrollBoundary
	JR   C,.NotBoundary

	LD   A,(ScrollBoundary)

.NotBoundary:
	ADD  A,$0B
	LD   L,A
	LD   A,(PlayerY)
	ADD  A,$06
	LD   H,A
	LD   A,(PlayerLieDown)
	OR   A
	JR   Z,NextBaddyLoop

	LD   A,L
	ADD  A,$08
	LD   L,A
	LD   A,H
	SUB  $08
	LD   H,A

NextBaddyLoop:
	LD   A,(IX+TYP)			; TYP
	OR   A
	JP   M,NotActive

	CP   T_BADDYDIE
	JR   Z,NotActive
	
	PUSH BC
	PUSH HL
	LD   A,(IX+XNO)			; XNO
	ADD  A,$04
	LD   E,A
	LD   A,(IX+YNO)			; YNO
	ADD  A,$04
	LD   D,A
	LD   BC,$1810
	CALL TestHitPlayer		; collide
	POP  HL
	POP  BC

NotActive:
	LD   DE,$0010			; 16 byte structure
	ADD  IX,DE
	DJNZ NextBaddyLoop

	LD   B,$04				; 4 bullets to test
	LD   IX,BaddyBullets

NextBullCheck:
	LD   A,(IX+$00)
	OR   A
	JP   M,BullNotActive

	PUSH BC
	PUSH HL
	LD   E,(IX+$01)
	LD   A,(IX+$02)
	SUB  $04
	LD   D,A
	LD   BC,$0208
	CALL TestHitPlayer
	POP  HL
	POP  BC

BullNotActive:
	LD   DE,$0007
	ADD  IX,DE
	DJNZ NextBullCheck

	LD   A,(MortarInFlight)
	OR   A
	JR   Z,NoMortarCheck
	
	LD   DE,(MortarBombX)
	LD   C,$0E
	LD   B,C
	CALL TestHitPlayer

NoMortarCheck:
	LD   A,(PlayerY)
	CP   $8C
	RET  C

	LD   IX,MineXPositions
	LD   B,$03			; 3 to test
.NextMine:
	LD   A,(IX+$00)
	OR   A
	JR   Z,.MineNotActive

	ADD  A,$04
	LD   E,A
	LD   D,$08
	LD   A,(PlayerX)
	ADD  A,$08
	LD   L,A
	LD   H,$08
	CALL HitA
	CALL NC,KillPlayer

.MineNotActive:
	INC  IX
	DJNZ .NextMine
	RET 

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

TestHitPlayer:
	PUSH HL
	PUSH DE
	LD   D,C
	LD   H,$01
	CALL HitA
	POP  DE
	POP  HL
	RET  C

	LD   L,H
	LD   E,D
	LD   D,B
	LD   H,$04
	CALL HitA
	RET  C

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

KillPlayer:
	LD   A,(DeathCounter)
	OR   A
	RET  NZ
	LD   (IY+$50),$28			; IY+DeathCounter
	LD   A,$1D
	LD   (PlayerDir),A
	LD   A,(PlayerX)
	AND  $F8
	LD   (PlayerX),A
	LD   A,(PlayerLieDown)
	OR   A
	JR   Z,.NotLying
	LD   A,(PlayerY)
	SUB  $0C
	LD   (PlayerY),A

.NotLying:
	XOR  A
	LD   (HasWeapon),A
	LD   (IsStabbing),A
	LD   A,S_EXPLOSION			; $09 BOOM!
	JP   PlaySound

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

JoyTable:
	db $FE
	db $FD
	db $FB
	db $DF
	db $BF
	db $7F
	db $00
	db $00

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;

	org $c350

gfx_Balloons1:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$e0,$00,$00,$00,$00,$00,$c0,$f3,$f3,$00,$00,$00,$03,$fd,$ef
	db $f0,$00,$00,$00,$00,$d8,$ff,$ff,$06,$00,$00,$3d,$fd,$ef,$ef,$00,$00,$00,$80,$df,$df,$fe,$7e,$00,$00,$7f,$d5,$2a,$ff,$80,$00,$00
	db $c0,$bf,$c7,$78,$ff,$00,$00,$ff,$cc,$0c,$ff,$c0,$00,$00,$c0,$7f,$23,$b1,$ff,$00,$03,$ab,$0a,$d4,$35,$70,$00,$00,$f8,$5e,$11,$a2
	db $de,$07,$07,$f5,$5c,$0e,$ab,$f8,$00,$00,$fc,$97,$00,$40,$fa,$0f,$0f,$e0,$40,$00,$81,$fc,$00,$00,$fc,$73,$00,$80,$f3,$0f,$0a,$e4
	db $00,$00,$09,$d4,$00,$00,$7c,$91,$00,$40,$a2,$0f,$05,$42,$40,$00,$90,$a8,$00,$00,$58,$0a,$00,$00,$94,$06,$03,$0c,$20,$00,$0c,$30
	db $00,$00,$c0,$13,$02,$10,$f2,$00,$00,$01,$00,$02,$20,$00,$00,$00,$00,$22,$00,$10,$10,$00,$00,$08,$88,$04,$04,$00,$00,$00,$00,$88
	db $04,$48,$00,$00,$00,$00,$40,$08,$00,$00,$00,$00,$00,$00,$01,$00,$01,$00,$00,$00,$80,$00,$40,$00,$00,$00,$00,$80,$00,$40,$00,$00

gfx_Balloons2:

	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$78,$00,$00,$00,$00,$00,$f0,$fc,$3c,$00,$00,$00,$00,$ff,$7b
	db $fc,$00,$00,$00,$00,$f6,$ff,$bf,$01,$00,$00,$0f,$7f,$7b,$fb,$c0,$00,$00,$e0,$f7,$b7,$bf,$1f,$00,$00,$1f,$f5,$4a,$bf,$e0,$00,$00
	db $f0,$ef,$31,$de,$3f,$00,$00,$3f,$f3,$03,$3f,$f0,$00,$00,$f0,$df,$48,$ec,$3f,$00,$00,$ea,$c2,$b5,$0d,$5c,$00,$00,$be,$57,$84,$a8
	db $f7,$01,$01,$fd,$57,$03,$aa,$fe,$00,$00,$ff,$25,$00,$90,$fe,$03,$03,$f8,$10,$00,$20,$7f,$00,$00,$ff,$1c,$00,$e0,$fc,$03,$02,$b9
	db $00,$00,$02,$75,$00,$00,$5f,$24,$00,$90,$e8,$03,$01,$50,$90,$00,$24,$2a,$00,$00,$96,$02,$00,$00,$a5,$01,$00,$c3,$08,$00,$03,$0c
	db $00,$00,$f0,$84,$00,$84,$3c,$00,$00,$00,$40,$00,$88,$00,$00,$00,$80,$08,$00,$04,$04,$00,$00,$02,$22,$01,$01,$00,$00,$00,$00,$22
	db $01,$12,$00,$00,$00,$00,$10,$02,$00,$00,$00,$00,$00,$40,$00,$40,$00,$00,$00,$00,$20,$00,$10,$00,$00,$00,$00,$20,$00,$10,$00,$00

gfx_Balloons3:

	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1e,$00,$00,$00,$00,$00,$3c,$3f,$0f,$00,$00,$00,$00,$3f,$de
	db $ff,$00,$00,$00,$80,$fd,$ff,$6f,$00,$00,$00,$03,$df,$de,$fe,$f0,$00,$00,$f8,$fd,$ed,$ef,$07,$00,$00,$07,$fd,$52,$af,$f8,$00,$00
	db $fc,$7b,$8c,$f7,$0f,$00,$00,$0f,$fc,$c0,$cf,$fc,$00,$00,$fc,$37,$12,$fb,$0f,$00,$00,$3a,$b0,$ad,$43,$57,$00,$80,$ef,$15,$21,$ea
	db $7d,$00,$00,$7f,$55,$c0,$ea,$bf,$80,$c0,$7f,$09,$00,$a4,$ff,$00,$00,$fe,$04,$00,$08,$1f,$c0,$c0,$3f,$07,$00,$38,$ff,$00,$00,$ae
	db $40,$00,$00,$9d,$40,$c0,$17,$09,$00,$24,$fa,$00,$00,$54,$24,$00,$09,$0a,$80,$80,$a5,$00,$00,$40,$69,$00,$00,$30,$c2,$00,$00,$c3
	db $00,$00,$3c,$21,$00,$21,$0f,$00,$00,$00,$10,$00,$22,$00,$00,$00,$20,$02,$00,$01,$01,$00,$00,$00,$88,$80,$40,$40,$00,$00,$80,$48
	db $80,$04,$00,$00,$00,$00,$04,$00,$80,$00,$00,$00,$00,$10,$00,$10,$00,$00,$00,$00,$08,$00,$04,$00,$00,$00,$00,$08,$00,$04,$00,$00

gfx_Balloons4:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$80,$00,$00,$00,$00,$cf,$cf,$03,$00,$00,$00,$00,$0f,$f7
	db $bf,$c0,$00,$00,$60,$ff,$ff,$1b,$00,$00,$00,$00,$f7,$f7,$bf,$bc,$00,$00,$7e,$7f,$fb,$fb,$01,$00,$00,$01,$ff,$54,$ab,$fe,$00,$00
	db $ff,$1e,$e3,$fd,$03,$00,$00,$03,$ff,$30,$33,$ff,$00,$00,$ff,$8d,$c4,$fe,$03,$00,$00,$0e,$ac,$2b,$50,$d5,$c0,$e0,$7b,$45,$88,$7a
	db $1f,$00,$00,$1f,$d5,$70,$3a,$af,$e0,$f0,$5f,$02,$00,$e9,$3f,$00,$00,$3f,$81,$00,$02,$07,$f0,$f0,$cf,$01,$00,$ce,$3f,$00,$00,$2b
	db $90,$00,$00,$27,$50,$f0,$45,$02,$00,$89,$3e,$00,$00,$15,$09,$00,$02,$42,$a0,$60,$29,$00,$00,$50,$1a,$00,$00,$0c,$30,$80,$00,$30
	db $c0,$00,$4f,$08,$40,$c8,$03,$00,$00,$00,$04,$00,$08,$80,$00,$00,$88,$00,$40,$40,$00,$00,$00,$00,$22,$20,$10,$10,$00,$00,$20,$12
	db $20,$01,$00,$00,$00,$00,$01,$00,$20,$00,$00,$00,$00,$04,$00,$04,$00,$00,$00,$00,$02,$00,$01,$00,$00,$00,$00,$02,$00,$01,$00,$00


gfx_MissileTop1:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $01
	db $80
	db $00
	db $00
	db $C0
	db $03
	db $02
	db $40
	db $00
	db $00
	db $60
	db $06
	db $07
	db $E0
	db $00
	db $00
	db $60
	db $06
	db $07
	db $E0
	db $00
	db $00
	db $70
	db $0E
	db $0D
	db $30
	db $00
	db $00
	db $70
	db $0E
	db $0C
	db $B0
	db $00
	db $00
	db $70
	db $0E
	db $1C
	db $38
	db $00
	db $00
	db $58
	db $1E
gfx_MissileTop2:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $60
	db $00
	db $00
	db $F0
	db $00
	db $00
	db $90
	db $00
	db $00
	db $98
	db $01
	db $01
	db $F8
	db $00
	db $00
	db $98
	db $01
	db $01
	db $F8
	db $00
	db $00
	db $9C
	db $03
	db $03
	db $4C
	db $00
	db $00
	db $9C
	db $03
	db $03
	db $2C
	db $00
	db $00
	db $9C
	db $03
	db $07
	db $0E
	db $00
	db $00
	db $96
	db $07
gfx_MissileTop3:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $18
	db $00
	db $00
	db $3C
	db $00
	db $00
	db $24
	db $00
	db $00
	db $66
	db $00
	db $00
	db $7E
	db $00
	db $00
	db $66
	db $00
	db $00
	db $7E
	db $00
	db $00
	db $E7
	db $00
	db $00
	db $D3
	db $00
	db $00
	db $E7
	db $00
	db $00
	db $CB
	db $00
	db $00
	db $E7
	db $00
	db $01
	db $C3
	db $80
	db $80
	db $E5
	db $01
gfx_MissileTop4:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $06
	db $00
	db $00
	db $0F
	db $00
	db $00
	db $09
	db $00
	db $80
	db $19
	db $00
	db $00
	db $1F
	db $80
	db $80
	db $19
	db $00
	db $00
	db $1F
	db $80
	db $C0
	db $39
	db $00
	db $00
	db $34
	db $C0
	db $C0
	db $39
	db $00
	db $00
	db $32
	db $C0
	db $C0
	db $39
	db $00
	db $00
	db $70
	db $E0
	db $60
	db $79
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
gfx_MineMask1:
	db $F2
	db $4F
	db $FF
	db $FF
	db $07
	db $E0
	db $E0
	db $07
	db $FF
	db $FF
	db $01
	db $80
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
gfx_MineMask2:
	db $FC
	db $93
	db $FF
	db $FF
	db $01
	db $F8
	db $F8
	db $01
	db $FF
	db $7F
	db $00
	db $E0
	db $C0
	db $00
	db $3F
	db $3F
	db $00
	db $C0
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
gfx_MineMask3:
	db $FF
	db $24
	db $FF
	db $7F
	db $00
	db $FE
	db $FE
	db $00
	db $7F
	db $1F
	db $00
	db $F8
	db $F0
	db $00
	db $0F
	db $0F
	db $00
	db $F0
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
gfx_MineMask4:
	db $FF
	db $C9
	db $3F
	db $1F
	db $80
	db $FF
	db $FF
	db $80
	db $1F
	db $07
	db $00
	db $FE
	db $FC
	db $00
	db $03
	db $03
	db $00
	db $FC
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0D
	db $B0
	db $00
	db $00
	db $50
	db $0A
	db $3F
	db $FC
	db $00
	db $00
	db $0E
	db $70
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $03
	db $6C
	db $00
	db $00
	db $94
	db $02
	db $0F
	db $FF
	db $00
	db $80
	db $03
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $DB
	db $00
	db $00
	db $A5
	db $00
	db $03
	db $FF
	db $C0
	db $E0
	db $00
	db $07
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $36
	db $C0
	db $40
	db $29
	db $00
	db $00
	db $FF
	db $F0
	db $38
	db $C0
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0D
	db $B0
	db $00
	db $00
	db $F0
	db $0F
	db $3F
	db $FC
	db $00
	db $00
	db $FE
	db $7F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $03
	db $6C
	db $00
	db $00
	db $FC
	db $03
	db $0F
	db $FF
	db $00
	db $80
	db $FF
	db $1F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $DB
	db $00
	db $00
	db $FF
	db $00
	db $03
	db $FF
	db $C0
	db $E0
	db $FF
	db $07
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $36
	db $C0
	db $C0
	db $3F
	db $00
	db $00
	db $FF
	db $F0
	db $F8
	db $FF
	db $01
gfx_Truck:
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $C3
	db $C1
	db $C1
	db $C1
	db $C1
	db $82
	db $82
	db $82
	db $82
	db $85
	db $00
	db $00
	db $00
	db $00
	db $C3
	db $C1
	db $C1
	db $C1
	db $C1
	db $82
	db $82
	db $82
	db $82
	db $85
	db $00
	db $00
	db $00
	db $00
	db $C3
	db $C1
	db $C1
	db $C1
	db $C1
	db $82
	db $82
	db $82
	db $82
	db $85
	db $00
	db $00
	db $00
	db $F0
	db $C3
	db $C1
	db $C1
	db $C1
	db $C1
	db $82
	db $82
	db $82
	db $82
	db $85
	db $F8
	db $00
	db $00
	db $8C
	db $C3
	db $C1
	db $C1
	db $C1
	db $C1
	db $82
	db $82
	db $82
	db $82
	db $85
	db $84
	db $00
	db $00
	db $86
	db $C3
	db $C1
	db $C1
	db $C1
	db $C1
	db $82
	db $82
	db $82
	db $82
	db $85
	db $82
	db $04
	db $0C
	db $83
	db $C3
	db $C1
	db $C1
label_C910:
	db $C1
	db $C1
	db $82
	db $82
	db $82
	db $82
	db $85
	db $81
	db $14
	db $8C
	db $81
	db $C3
	db $C1
	db $C1
	db $C1
	db $C1
	db $82
	db $82
	db $82
	db $82
	db $85
	db $FF
	db $84
	db $FC
	db $01
	db $C3
	db $C1
	db $C1
	db $C1
	db $C1
	db $82
	db $82
	db $82
	db $82
	db $85
	db $FE
	db $FE
	db $FE
	db $9E
	db $C3
	db $C1
	db $C1
	db $C1
	db $C1
	db $82
	db $82
	db $82
	db $82
	db $85
	db $BE
	db $FF
	db $FF
	db $FE
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $92
	db $49
	db $24
	db $92
	db $49
	db $81
	db $FF
	db $FF
	db $7F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $18
	db $00
	db $FF
	db $FF
	db $FF
	db $80
	db $0F
	db $E3
	db $3F
	db $FE
	db $2F
	db $3A
	db $FE
	db $23
	db $4F
	db $07
	db $9F
	db $FF
	db $F4
	db $F0
	db $79
	db $1D
	db $C0
	db $F5
	db $2F
	db $DA
	db $01
	db $5C
	db $58
	db $00
	db $DA
	db $2F
	db $F5
	db $80
	db $0D
	db $0E
	db $87
	db $E3
	db $F8
	db $FF
	db $70
	db $38
	db $10
	db $A8
	db $48
	db $00
	db $41
	db $0A
	db $84
	db $44
	db $15
	db $FD
	db $FF
	db $5F
	db $54
	db $11
	db $11
	db $8C
	db $4A
	db $AA
	db $A9
	db $18
	db $C4
	db $44
	db $15
	db $FD
	db $FF
	db $5F
	db $54
	db $11
	db $10
	db $A8
	db $40
	db $00
	db $01
	db $0A
	db $84
	db $08
	db $87
	db $00
	db $00
	db $80
	db $70
	db $08
	db $08
	db $00
	db $80
	db $00
	db $00
	db $80
	db $08
	db $10
	db $40
	db $00
	db $00
	db $00
	db $01
	db $04
	db $03
	db $06
	db $00
	db $00
	db $00
	db $30
	db $60
	db $80
	db $0F
	db $00
	db $00
	db $00
	db $F8
	db $00
gfx_TruckMask:
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $00
	db $00
	db $80
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $00
	db $00
	db $80
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $00
	db $00
	db $80
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $F0
	db $00
	db $00
	db $F8
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FC
	db $00
	db $00
	db $FE
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FE
	db $00
	db $04
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $0E
	db $9E
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $BE
	db $DE
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FE
	db $FE
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $7F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $7F
	db $3F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FE
	db $FE
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $3F
	db $3F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FE
	db $FE
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $3F
	db $3F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FE
	db $FC
	db $FF
	db $01
	db $00
	db $C0
	db $FF
	db $1F
	db $1F
	db $FF
	db $C0
	db $00
	db $01
	db $FF
	db $FC
	db $F8
	db $FF
	db $00
	db $00
	db $80
	db $FF
	db $0F
	db $07
	db $FF
	db $00
	db $00
	db $00
	db $7F
	db $F0
	db $E0
	db $3F
	db $00
	db $00
	db $00
	db $FE
	db $03
SineTable:
	db $00
	db $01
	db $02
	db $04
	db $05
	db $06
	db $07
	db $08
	db $09
	db $0A
	db $0C
	db $0D
	db $0E
	db $0F
	db $10
	db $11
	db $12
	db $14
	db $15
	db $16
	db $17
	db $18
	db $19
	db $1A
	db $1B
	db $1C
	db $1D
	db $1E
	db $1F
	db $20
	db $21
	db $22
	db $23
	db $24
	db $25
	db $26
	db $27
	db $28
	db $29
	db $2A
	db $2B
	db $2C
	db $2D
	db $2D
	db $2E
	db $2F
	db $30
	db $31
	db $31
	db $32
	db $33
	db $34
	db $34
	db $35
	db $36
	db $36
	db $37
	db $38
	db $38
	db $39
	db $39
	db $3A
	db $3A
	db $3B
	db $3B
	db $3C
	db $3C
	db $3D
	db $3D
	db $3E
	db $3E
	db $3E
	db $3F
	db $3F
	db $3F
	db $3F
	db $40
	db $40
	db $40
	db $40
	db $40
	db $41
	db $41
	db $41
	db $41
	db $41
	db $41
	db $41
	db $41
	db $41
	db $41
	db $41
	db $41
	db $41
	db $41
	db $40
	db $40
	db $40
	db $40
	db $40
	db $3F
	db $3F
	db $3F
	db $3E
	db $3E
	db $3E
	db $3D
	db $3D
	db $3D
	db $3C
	db $3C
	db $3B
	db $3B
	db $3A
	db $3A
	db $39
	db $38
	db $38
	db $37
	db $37
	db $36
	db $35
	db $35
	db $34
	db $33
	db $33
	db $32
	db $31
	db $30
	db $30
	db $2F
	db $2E
	db $2D
	db $2C
	db $2B
	db $2A
	db $2A
	db $29
	db $28
	db $27
	db $26
	db $25
	db $24
	db $23
	db $22
	db $21
	db $20
	db $1F
	db $1E
	db $1D
	db $1C
	db $1B
	db $1A
	db $19
	db $17
	db $16
	db $15
	db $14
	db $13
	db $12
	db $11
	db $10
	db $0F
	db $0D
	db $0C
	db $0B
	db $0A
	db $09
	db $08
	db $06
	db $05
	db $04
	db $03
	db $02
	db $01
	db $FF
	db $FE
	db $FD
gfx_FlameThrowerRight:
	db $00
	db $00
	db $00
	db $00
	db $04
	db $62
	db $00
	db $00
	db $98
	db $0A
	db $04
	db $18
	db $00
	db $00
	db $00
	db $00
	db $29
	db $10
	db $50
	db $58
	db $00
	db $00
	db $6C
	db $B1
	db $7E
	db $D4
	db $12
	db $00
	db $00
	db $05
	db $F3
	db $75
	db $76
	db $44
	db $00
	db $00
	db $E8
	db $2C
	db $E7
	db $3A
	db $6B
	db $00
	db $00
	db $E7
	db $9F
	db $DD
	db $DE
	db $B0
	db $00
	db $00
	db $C1
	db $21
	db $60
	db $66
	db $08
	db $00
gfx_FlameThrowerLeft:
	db $00
	db $46
	db $20
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $18
	db $20
	db $50
	db $19
	db $00
	db $00
	db $1A
	db $0A
	db $08
	db $94
	db $00
	db $00
	db $00
	db $48
	db $2B
	db $7E
	db $8D
	db $36
	db $00
	db $00
	db $22
	db $6E
	db $AE
	db $CF
	db $A0
	db $00
	db $00
	db $D6
	db $5C
	db $E7
	db $34
	db $17
	db $00
	db $00
	db $0D
	db $7B
	db $BB
	db $F9
	db $E7
	db $00
	db $00
	db $10
	db $66
	db $06
	db $84

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;
;
;

	org $CC00

ISRTable:

	ds 255, $FE

;	db $00
;	db $00
;	db $00
;	db $00
;	db $00
;	db $00
;	db $04
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $2E
;	db $00
;	db $00
;	db $00
;	db $00
;	db $00
;	db $00
;	db $00
;	db $90
;	db $FF
;	db $FF
;	db $FF
;	db $7F
;	db $FF
;	db $FF
;	db $FD
;	db $80
;	db $00
;	db $00
;	db $00
;	db $00
;	db $C6
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $C0
;	db $00
;	db $00
;	db $F8
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $7F
;	db $7F
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $FE
;	db $00
;	db $00
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $FF
;	db $5F
;	db $FF
;	db $FF
;	db $BF
;	db $FF
;	db $FF
;	db $80
;	db $00
;	db $3F
;	db $BE
;	db $0F
;	db $DF
;	db $CE
;	db $07
;	db $0F
;	db $DF
;	db $CE
;	db $07

	org $cd52

gfx_Bazooka:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $3D
	db $7F
	db $5E
	db $00
	db $00
	db $A5
	db $80
	db $52
	db $7F
	db $FF
	db $FF
	db $00
	db $00
	db $5E
	db $7F
	db $3D
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0F
	db $5F
	db $D7
	db $80
	db $40
	db $29
	db $A0
	db $14
	db $1F
	db $FF
	db $FF
	db $C0
	db $80
	db $D7
	db $5F
	db $0F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $03
	db $D7
	db $F5
	db $E0
	db $50
	db $0A
	db $28
	db $05
	db $07
	db $FF
	db $FF
	db $F0
	db $E0
	db $F5
	db $D7
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $F5
	db $FD
	db $78
	db $94
	db $02
	db $4A
	db $01
	db $01
	db $FF
	db $FF
	db $FC
	db $78
	db $FD
	db $F5
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

gfx_MaskBazooka:
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $A1
	db $80
	db $C2
	db $80
	db $00
	db $00
	db $FF
	db $7F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $7F
	db $FF
	db $00
	db $00
	db $80
	db $C2
	db $80
	db $A1
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $7F
	db $28
	db $A0
	db $F0
	db $E0
	db $00
	db $00
	db $3F
	db $1F
	db $00
	db $00
	db $C0
	db $C0
	db $00
	db $00
	db $1F
	db $3F
	db $00
	db $00
	db $E0
	db $F0
	db $A0
	db $28
	db $7F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $1F
	db $0A
	db $28
	db $FC
	db $F8
	db $00
	db $00
	db $0F
	db $07
	db $00
	db $00
	db $F0
	db $F0
	db $00
	db $00
	db $07
	db $0F
	db $00
	db $00
	db $F8
	db $FC
	db $28
	db $0A
	db $1F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $87
	db $02
	db $0A
	db $FF
	db $FE
	db $00
	db $00
	db $03
	db $01
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $00
	db $01
	db $03
	db $00	;NOP 
	db $00	;NOP 
	db $fe	;CP   $FF
	db $FF
	db $0a	;LD   A,(BC)
	db $02	;LD   (BC),A
	db $87	;ADD  A,A
	db $ff 	;RST  $38
	db $FF
	db $FF
	db $FF

	;org $ce52

gfx_FlameThrower:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $54
	db $00
	db $2A
	db $7F
	db $00
	db $FE
	db $00
	db $00
	db $8A
	db $00
	db $51
	db $7F
	db $00
	db $FE
	db $00
	db $00
	db $54
	db $00
	db $2A
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $15
	db $80
	db $0A
	db $1F
	db $C0
	db $3F
	db $80
	db $80
	db $22
	db $40
	db $14
	db $1F
	db $C0
	db $3F
	db $80
	db $00
	db $15
	db $80
	db $0A
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $40
	db $05
	db $A0
	db $02
	db $07
	db $F0
	db $0F
	db $E0
	db $A0
	db $08
	db $10
	db $05
	db $07
	db $F0
	db $0F
	db $E0
	db $40
	db $05
	db $A0
	db $02
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $50
	db $01
	db $A8
	db $00
	db $01
	db $FC
	db $03
	db $F8
	db $28
	db $02
	db $44
	db $01
	db $01
	db $FC
	db $03
	db $F8
	db $50
	db $01
	db $A8
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

gfx_MaskFlameThrower:
	db $D5
	db $FF
	db $AB
	db $FF
	db $FF
	db $01
	db $00
	db $80
	db $00
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $FF
	db $01
	db $00
	db $80
	db $D5
	db $FF
	db $AB
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $F5
	db $7F
	db $EA
	db $FF
	db $7F
	db $00
	db $00
	db $E0
	db $C0
	db $00
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $C0
	db $C0
	db $00
	db $00
	db $3F
	db $7F
	db $00
	db $00
	db $E0
	db $F5
	db $7F
	db $EA
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FD
	db $5F
	db $FA
	db $BF
	db $1F
	db $00
	db $00
	db $F8
	db $F0
	db $00
	db $00
	db $0F
	db $0F
	db $00
	db $00
	db $F0
	db $F0
	db $00
	db $00
	db $0F
	db $1F
	db $00
	db $00
	db $F8
	db $FD
	db $5F
	db $FA
	db $BF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $57
	db $FE
	db $AF
	db $07
	db $00
	db $00
	db $FE
	db $FC
	db $00
	db $00
	db $03
	db $03
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $00
	db $03
	db $07
	db $00
	db $00
	db $FE
	db $FF
	db $57
	db $FE
	db $AF
	db $FF
	db $FF
	db $FF
	db $FF

gfx_Bullets:
	db $78
	db $00
	db $00
	db $84
	db $78
	db $00
	db $00
	db $00
	db $1E
	db $00
	db $00
	db $21
	db $1E
	db $00
	db $00
	db $00
	db $07
	db $80
	db $40
	db $08
	db $07
	db $80
	db $00
	db $00
	db $01
	db $E0
	db $10
	db $02
	db $01
	db $E0
	db $00
	db $00

gfx_LittleHelicopter1:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $01
	db $C0
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $01
	db $40
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $02
	db $00
	db $00
	db $00
	db $00
	db $03
	db $60
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $5F
	db $01
	db $04
	db $00
	db $00
	db $04
	db $01
	db $70
	db $80
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $61
	db $01
	db $04
	db $00
	db $00
	db $04
	db $FD
	db $63
	db $C0
	db $00
	db $00
	db $00
	db $00
	db $80
	db $64
	db $03
	db $15
	db $00
	db $00
	db $15
	db $FF
	db $5E
	db $80
	db $00
	db $00
	db $00
	db $00
	db $00
	db $5D
	db $FF
	db $05
	db $00
	db $00
	db $04
	db $83
	db $F3
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $E1
	db $42
	db $04
	db $00
	db $00
	db $04
	db $62
	db $E4
	db $C0
	db $00
	db $00
	db $00
	db $00
	db $60
	db $E2
	db $5E
	db $00
	db $00
	db $00
	db $00
	db $53
	db $71
	db $18
	db $00
	db $00
	db $00
	db $00
	db $C4
	db $71
	db $5B
	db $00
	db $00
	db $00
	db $00
	db $51
	db $B9
	db $BF
	db $80
	db $00
	db $00
	db $E0
	db $CB
	db $BF
	db $5B
	db $00
	db $00
	db $00
	db $00
	db $2D
	db $EC
	db $7B
	db $F8
	db $00
	db $00
	db $F8
	db $1D
	db $E4
	db $13
	db $E0
	db $00
	db $03
	db $78
	db $0F
	db $BA
	db $0D
	db $1C
	db $00
	db $00
	db $E4
	db $85
	db $A7
	db $0E
	db $7E
	db $04
	db $04
	db $FF
	db $FD
	db $B7
	db $E6
	db $D0
	db $00
	db $00
	db $68
	db $0B
	db $A9
	db $F3
	db $AD
	db $08
	db $07
	db $FF
	db $82
	db $BA
	db $12
	db $B8
	db $00
	db $00
	db $F8
	db $62
	db $FE
	db $02
	db $C0
	db $00
	db $00
	db $00
	db $01
	db $77
	db $C1
	db $70
	db $00
	db $00
	db $E0
	db $E0
	db $E3
	db $00
	db $00
	db $00

gfx_LittleHelicopter2:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $70
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $50
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $B8
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $D8
	db $00
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $57
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $5C
	db $20
	db $00
	db $00
	db $00
	db $00
	db $70
	db $58
	db $00
	db $00
	db $00
	db $00
	db $01
	db $3F
	db $58
	db $F0
	db $00
	db $00
	db $00
	db $00
	db $20
	db $D9
	db $40
	db $05
	db $00
	db $00
	db $05
	db $7F
	db $D7
	db $A0
	db $00
	db $00
	db $00
	db $00
	db $40
	db $D7
	db $7F
	db $01
	db $00
	db $00
	db $00
	db $20
	db $FC
	db $C0
	db $00
	db $00
	db $00
	db $00
	db $60
	db $B8
	db $10
	db $00
	db $00
	db $00
	db $00
	db $18
	db $B9
	db $30
	db $00
	db $00
	db $00
	db $00
	db $98
	db $B8
	db $17
	db $00
	db $00
	db $00
	db $00
	db $14
	db $DC
	db $46
	db $00
	db $00
	db $00
	db $00
	db $71
	db $DC
	db $16
	db $00
	db $00
	db $00
	db $00
	db $14
	db $6E
	db $6F
	db $E0
	db $00
	db $00
	db $F8
	db $F2
	db $EF
	db $16
	db $00
	db $00
	db $00
	db $00
	db $0B
	db $7B
	db $1E
	db $FE
	db $00
	db $00
	db $7E
	db $07
	db $F9
	db $04
	db $38
	db $00
	db $00
	db $DE
	db $03
	db $EE
	db $83
	db $47
	db $00
	db $00
	db $79
	db $E1
	db $A9
	db $83
	db $1F
	db $01
	db $01
	db $3F
	db $FF
	db $6D
	db $F9
	db $B4
	db $00
	db $00
	db $DA
	db $42
	db $EA
	db $7C
	db $2B
	db $02
	db $01
	db $FF
	db $E0
	db $AE
	db $84
	db $AE
	db $00
	db $00
	db $BE
	db $98
	db $BF
	db $00
	db $30
	db $00
	db $00
	db $00
	db $00
	db $5D
	db $F0
	db $5C
	db $00
	db $00
	db $38
	db $F8
	db $38
	db $00
	db $00
	db $00

gfx_LittleHelicopter3:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $14
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $2E
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $36
	db $00
	db $00
	db $00
	db $00
	db $00
	db $F0
	db $15
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $17
	db $08
	db $00
	db $00
	db $00
	db $00
	db $1C
	db $16
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0F
	db $D6
	db $3C
	db $00
	db $00
	db $00
	db $00
	db $48
	db $36
	db $50
	db $01
	db $00
	db $00
	db $01
	db $5F
	db $F5
	db $E8
	db $00
	db $00
	db $00
	db $00
	db $D0
	db $F5
	db $1F
	db $00
	db $00
	db $00
	db $00
	db $08
	db $3F
	db $30
	db $00
	db $00
	db $00
	db $00
	db $18
	db $2E
	db $04
	db $00
	db $00
	db $00
	db $00
	db $06
	db $2E
	db $4C
	db $00
	db $00
	db $00
	db $00
	db $26
	db $EE
	db $05
	db $00
	db $00
	db $00
	db $00
	db $05
	db $37
	db $11
	db $80
	db $00
	db $00
	db $40
	db $1C
	db $B7
	db $05
	db $00
	db $00
	db $00
	db $00
	db $05
	db $1B
	db $9B
	db $F8
	db $00
	db $00
	db $BE
	db $FC
	db $BB
	db $05
	db $00
	db $00
	db $00
	db $00
	db $02
	db $DE
	db $C7
	db $BF
	db $80
	db $80
	db $DF
	db $41
	db $3E
	db $01
	db $0E
	db $00
	db $00
	db $37
	db $80
	db $FB
	db $A0
	db $D1
	db $C0
	db $40
	db $5E
	db $78
	db $EA
	db $E0
	db $47
	db $00
	db $00
	db $4F
	db $FF
	db $DB
	db $7E
	db $6D
	db $00
	db $80
	db $B6
	db $90
	db $3A
	db $DF
	db $8A
	db $00
	db $00
	db $7F
	db $F8
	db $2B
	db $A1
	db $2B
	db $80
	db $80
	db $2F
	db $E6
	db $2F
	db $00
	db $0C
	db $00
	db $00
	db $00
	db $00
	db $17
	db $7C
	db $17
	db $00
	db $00
	db $0E
	db $3E
	db $0E
	db $00
	db $00
	db $00

gfx_LittleHelicopter4:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $07
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $05
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $0B
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0D
	db $80
	db $00
	db $00
	db $00
	db $00
	db $7C
	db $05
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $05
	db $C2
	db $00
	db $00
	db $00
	db $00
	db $87
	db $05
	db $10
	db $00
	db $00
	db $00
	db $00
	db $13
	db $F5
	db $8F
	db $00
	db $00
	db $00
	db $00
	db $92
	db $0D
	db $54
	db $00
	db $00
	db $00
	db $00
	db $57
	db $FD
	db $7A
	db $00
	db $00
	db $00
	db $00
	db $74
	db $FD
	db $17
	db $00
	db $00
	db $00
	db $00
	db $12
	db $0F
	db $CC
	db $00
	db $00
	db $00
	db $00
	db $86
	db $0B
	db $01
	db $00
	db $00
	db $00
	db $00
	db $01
	db $8B
	db $93
	db $00
	db $00
	db $00
	db $80
	db $89
	db $7B
	db $01
	db $00
	db $00
	db $00
	db $00
	db $01
	db $4D
	db $C4
	db $60
	db $00
	db $00
	db $10
	db $C7
	db $6D
	db $01
	db $00
	db $00
	db $00
	db $00
	db $01
	db $46
	db $E6
	db $FE
	db $00
	db $80
	db $2F
	db $FF
	db $6E
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $B7
	db $B1
	db $EF
	db $E0
	db $E0
	db $77
	db $90
	db $4F
	db $80
	db $03
	db $00
	db $00
	db $0D
	db $E0
	db $3E
	db $E8
	db $34
	db $70
	db $90
	db $17
	db $9E
	db $3A
	db $F8
	db $11
	db $00
	db $00
	db $13
	db $FF
	db $F6
	db $DF
	db $9B
	db $40
	db $A0
	db $2D
	db $A4
	db $CE
	db $B7
	db $22
	db $00
	db $00
	db $1F
	db $FE
	db $0A
	db $E8
	db $4A
	db $E0
	db $E0
	db $8B
	db $F9
	db $0B
	db $00
	db $03
	db $00
	db $00
	db $00
	db $00
	db $05
	db $DF
	db $05
	db $C0
	db $80
	db $83
	db $8F
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

	;org $d300		; ensure we start on a page boundary to ensure low byte register increments don't need to bump the high byte

gfx_KnifeLeft:
	db $FF
	db $00
	db $FF
	db $00
	db $7F
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $3F
	db $80
	db $3F
	db $80
	db $00
	db $00
	db $00
	db $FF
	db $7F
	db $00
	db $FF
	db $00
	db $00
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $1F
	db $00
	db $C0
	db $00
	db $C0
	db $3F
	db $0F
	db $E0
	db $0F
	db $20
	db $C0
	db $00
	db $C0
	db $3F
	db $1F
	db $C0
	db $3F
	db $00
	db $C0
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $07
	db $00
	db $F0
	db $00
	db $F0
	db $0F
	db $03
	db $F8
	db $03
	db $08
	db $F0
	db $00
	db $F0
	db $0F
	db $07
	db $F0
	db $0F
	db $00
	db $F0
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $01
	db $00
	db $FC
	db $00
	db $FC
	db $03
	db $00
	db $FE
	db $00
	db $02
	db $FC
	db $00
	db $FC
	db $03
	db $01
	db $FC
	db $03
	db $00
	db $FC
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00

gfx_KnifeRight:
	db $FF
	db $00
	db $FF
	db $00
	db $3F
	db $00
	db $80
	db $00
	db $00
	db $7F
	db $3F
	db $C0
	db $3F
	db $00
	db $00
	db $40
	db $80
	db $3F
	db $3F
	db $C0
	db $3F
	db $00
	db $C0
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $0F
	db $00
	db $E0
	db $00
	db $C0
	db $1F
	db $0F
	db $F0
	db $0F
	db $00
	db $C0
	db $10
	db $E0
	db $0F
	db $0F
	db $F0
	db $0F
	db $00
	db $F0
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $03
	db $00
	db $F8
	db $00
	db $F0
	db $07
	db $03
	db $FC
	db $03
	db $00
	db $F0
	db $04
	db $F8
	db $03
	db $03
	db $FC
	db $03
	db $00
	db $FC
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $00
	db $00
	db $FE
	db $00
	db $FC
	db $01
	db $00
	db $FF
	db $00
	db $00
	db $FC
	db $01
	db $FE
	db $00
	db $00
	db $FF
	db $00
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00

gfx_Mortar:
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $C7
	db $00
	db $83
	db $38
	db $FF
	db $00
	db $FF
	db $00
	db $01
	db $4C
	db $01
	db $4C
	db $FF
	db $00
	db $FF
	db $00
	db $01
	db $7C
	db $83
	db $38
	db $FF
	db $00
	db $FF
	db $00
	db $C7
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $F1
	db $00
	db $E0
	db $0E
	db $FF
	db $00
	db $7F
	db $00
	db $C0
	db $13
	db $C0
	db $13
	db $7F
	db $00
	db $7F
	db $00
	db $C0
	db $1F
	db $E0
	db $0E
	db $FF
	db $00
	db $FF
	db $00
	db $F1
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $7F
	db $00
	db $FC
	db $00
	db $F8
	db $03
	db $3F
	db $80
	db $1F
	db $C0
	db $F0
	db $04
	db $F0
	db $04
	db $1F
	db $C0
	db $1F
	db $C0
	db $F0
	db $07
	db $F8
	db $03
	db $3F
	db $80
	db $7F
	db $00
	db $FC
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $1F
	db $00
	db $FF
	db $00
	db $FE
	db $00
	db $0F
	db $E0
	db $07
	db $30
	db $FC
	db $01
	db $FC
	db $01
	db $07
	db $30
	db $07
	db $F0
	db $FC
	db $01
	db $FE
	db $00
	db $0F
	db $E0
	db $1F
	db $00
	db $FF
	db $00

gfx_Grenade:
	db $C7
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $83
	db $38
	db $81
	db $34
	db $FF
	db $00
	db $FF
	db $00
	db $00
	db $5A
	db $00
	db $2A
	db $FF
	db $00
	db $FF
	db $00
	db $01
	db $58
	db $87
	db $30
	db $FF
	db $00
	db $FF
	db $00
	db $CF
	db $00
	db $F1
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $E0
	db $0E
	db $E0
	db $0D
	db $7F
	db $00
	db $3F
	db $80
	db $C0
	db $16
	db $C0
	db $0A
	db $3F
	db $80
	db $7F
	db $00
	db $C0
	db $16
	db $E1
	db $0C
	db $FF
	db $00
	db $FF
	db $00
	db $F3
	db $00
	db $FC
	db $00
	db $7F
	db $00
	db $3F
	db $80
	db $F8
	db $03
	db $F8
	db $03
	db $1F
	db $40
	db $0F
	db $A0
	db $F0
	db $05
	db $F0
	db $02
	db $0F
	db $A0
	db $1F
	db $80
	db $F0
	db $05
	db $F8
	db $03
	db $7F
	db $00
	db $FF
	db $00
	db $FC
	db $00
	db $FF
	db $00
	db $1F
	db $00
	db $0F
	db $E0
	db $FE
	db $00
	db $FE
	db $00
	db $07
	db $D0
	db $03
	db $68
	db $FC
	db $01
	db $FC
	db $00
	db $03
	db $A8
	db $07
	db $60
	db $FC
	db $01
	db $FE
	db $00
	db $1F
	db $C0
	db $3F
	db $00
	db $FF
	db $00

gfx_BulletRight:
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $80
	db $00
	db $00
	db $7F
	db $7F
	db $00
	db $3F
	db $80
	db $00
	db $50
	db $00
	db $7F
	db $3F
	db $80
	db $7F
	db $00
	db $00
	db $7F
	db $80
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $3F
	db $00
	db $E0
	db $00
	db $C0
	db $1F
	db $1F
	db $C0
	db $0F
	db $20
	db $C0
	db $14
	db $C0
	db $1F
	db $0F
	db $E0
	db $1F
	db $C0
	db $C0
	db $1F
	db $E0
	db $00
	db $3F
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $0F
	db $00
	db $F8
	db $00
	db $F0
	db $07
	db $07
	db $F0
	db $03
	db $08
	db $F0
	db $05
	db $F0
	db $07
	db $03
	db $F8
	db $07
	db $F0
	db $F0
	db $07
	db $F8
	db $00
	db $0F
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $03
	db $00
	db $FE
	db $00
	db $FC
	db $01
	db $01
	db $FC
	db $00
	db $42
	db $FC
	db $01
	db $FC
	db $01
	db $00
	db $FE
	db $01
	db $FC
	db $FC
	db $01
	db $FE
	db $00
	db $03
	db $00
	db $FF
	db $00
	db $FF
	db $00

gfx_BulletLeft:
	db $FF
	db $00
	db $FF
	db $00
	db $7F
	db $00
	db $C0
	db $00
	db $80
	db $3F
	db $3F
	db $80
	db $3F
	db $80
	db $00
	db $42
	db $00
	db $7F
	db $3F
	db $80
	db $3F
	db $80
	db $80
	db $3F
	db $C0
	db $00
	db $7F
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $1F
	db $00
	db $F0
	db $00
	db $E0
	db $0F
	db $0F
	db $E0
	db $0F
	db $A0
	db $C0
	db $10
	db $C0
	db $1F
	db $0F
	db $E0
	db $0F
	db $E0
	db $E0
	db $0F
	db $F0
	db $00
	db $1F
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $07
	db $00
	db $FC
	db $00
	db $F8
	db $03
	db $03
	db $F8
	db $03
	db $28
	db $F0
	db $04
	db $F0
	db $07
	db $03
	db $F8
	db $03
	db $F8
	db $F8
	db $03
	db $FC
	db $00
	db $07
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $FF
	db $00
	db $01
	db $00
	db $FF
	db $00
	db $FE
	db $00
	db $00
	db $FE
	db $00
	db $0A
	db $FC
	db $01
	db $FC
	db $01
	db $00
	db $FE
	db $00
	db $FE
	db $FE
	db $00
	db $FF
	db $00
	db $01
	db $00
	db $FF
	db $00
	db $FF
	db $00

gfx_RunningBaddyLeft1:
	db $03
	db $E0
	db $00
	db $00
	db $00
	db $00
	db $30
	db $05
	db $05
	db $38
	db $00
	db $00
	db $00
	db $00
	db $E4
	db $06
	db $04
	db $44
	db $00
	db $00
	db $00
	db $00
	db $8C
	db $06
	db $03
	db $14
	db $00
	db $00
	db $00
	db $00
	db $62
	db $01
	db $03
	db $A6
	db $00
	db $00
	db $00
	db $00
	db $F2
	db $04
	db $05
	db $07
	db $00
	db $00
	db $00
	db $00
	db $AF
	db $03
	db $01
	db $FF
	db $80
	db $00
	db $00
	db $80
	db $AF
	db $01
	db $03
	db $5B
	db $C0
	db $00
	db $00
	db $00
	db $AF
	db $02
	db $07
	db $76
	db $F0
	db $00
	db $00
	db $F8
	db $B9
	db $01
	db $02
	db $73
	db $F8
	db $00
	db $00
	db $18
	db $80
	db $07
	db $37
	db $00
	db $08
	db $00
	db $00
	db $08
	db $00
	db $3F
	db $1E
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0E
	db $00
	db $F8
	db $00
	db $00
	db $00
	db $00
	db $4C
	db $01
	db $01
	db $4E
	db $00
	db $00
	db $00
	db $00
	db $B9
	db $01
	db $01
	db $11
	db $00
	db $00
	db $00
	db $00
	db $A3
	db $01
	db $00
	db $C5
	db $00
	db $00
	db $00
	db $80
	db $58
	db $00
	db $00
	db $E9
	db $80
	db $00
	db $00
	db $80
	db $3C
	db $01
	db $01
	db $41
	db $C0
	db $00
	db $00
	db $C0
	db $EB
	db $00
	db $00
	db $7F
	db $E0
	db $00
	db $00
	db $E0
	db $6B
	db $00
	db $00
	db $D6
	db $F0
	db $00
	db $00
	db $C0
	db $AB
	db $00
	db $01
	db $DD
	db $BC
	db $00
	db $00
	db $7E
	db $6E
	db $00
	db $00
	db $9C
	db $FE
	db $00
	db $00
	db $06
	db $E0
	db $01
	db $0D
	db $C0
	db $02
	db $00
	db $00
	db $02
	db $C0
	db $0F
	db $07
	db $80
	db $00
	db $00
	db $00
	db $00
	db $80
	db $03
	db $00
	db $3E
	db $00
	db $00
	db $00
	db $00
	db $53
	db $00
	db $00
	db $53
	db $80
	db $00
	db $00
	db $40
	db $6E
	db $00
	db $00
	db $44
	db $40
	db $00
	db $00
	db $C0
	db $68
	db $00
	db $00
	db $31
	db $40
	db $00
	db $00
	db $20
	db $16
	db $00
	db $00
	db $3A
	db $60
	db $00
	db $00
	db $20
	db $4F
	db $00
	db $00
	db $50
	db $70
	db $00
	db $00
	db $F0
	db $3A
	db $00
	db $00
	db $1F
	db $F8
	db $00
	db $00
	db $F8
	db $1A
	db $00
	db $00
	db $35
	db $BC
	db $00
	db $00
	db $F0
	db $2A
	db $00
	db $00
	db $77
	db $6F
	db $00
	db $80
	db $9F
	db $1B
	db $00
	db $00
	db $27
	db $3F
	db $80
	db $80
	db $01
	db $78
	db $00
	db $03
	db $70
	db $00
	db $80
	db $80
	db $00
	db $F0
	db $03
	db $01
	db $E0
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $00
	db $00
	db $0F
	db $80
	db $00
	db $00
	db $C0
	db $14
	db $00
	db $00
	db $14
	db $E0
	db $00
	db $00
	db $90
	db $1B
	db $00
	db $00
	db $11
	db $10
	db $00
	db $00
	db $30
	db $1A
	db $00
	db $00
	db $0C
	db $50
	db $00
	db $00
	db $88
	db $05
	db $00
	db $00
	db $0E
	db $98
	db $00
	db $00
	db $C8
	db $13
	db $00
	db $00
	db $14
	db $1C
	db $00
	db $00
	db $BC
	db $0E
	db $00
	db $00
	db $07
	db $FE
	db $00
	db $00
	db $BE
	db $06
	db $00
	db $00
	db $0D
	db $6F
	db $00
	db $00
	db $BC
	db $0A
	db $00
	db $00
	db $1D
	db $DB
	db $C0
	db $E0
	db $E7
	db $06
	db $00
	db $00
	db $09
	db $CF
	db $E0
	db $60
	db $00
	db $1E
	db $00
	db $00
	db $DC
	db $00
	db $20
	db $20
	db $00
	db $FC
	db $00
	db $00
	db $78
	db $00
	db $00
	db $00
	db $00
	db $38
	db $00

gfx_MaskRunningBaddyLeft1:
	db $F8
	db $0F
	db $FF
	db $FF
	db $FF
	db $FF
	db $07
	db $F0
	db $F0
	db $03
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $F0
	db $F0
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $F0
	db $F8
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $E0
	db $C0
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $80
	db $C0
	db $00
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $E0
	db $FC
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $FC
	db $F8
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $F8
	db $F0
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $F0
	db $F0
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $08
	db $C0
	db $80
	db $7F
	db $83
	db $FF
	db $FF
	db $C3
	db $7F
	db $80
	db $C0
	db $FF
	db $F7
	db $FF
	db $FF
	db $FF
	db $FF
	db $E0
	db $FE
	db $03
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $FC
	db $FC
	db $00
	db $FF
	db $FF
	db $FF
	db $7F
	db $00
	db $FC
	db $FC
	db $00
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $FC
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $00
	db $F8
	db $F0
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $E0
	db $F0
	db $00
	db $1F
	db $FF
	db $FF
	db $1F
	db $00
	db $F8
	db $FF
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FF
	db $FE
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $FE
	db $FC
	db $00
	db $01
	db $FF
	db $FF
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $02
	db $F0
	db $E0
	db $1F
	db $E0
	db $FF
	db $FF
	db $F0
	db $1F
	db $E0
	db $F0
	db $3F
	db $FD
	db $FF
	db $FF
	db $FF
	db $3F
	db $F8
	db $FF
	db $80
	db $FF
	db $FF
	db $FF
	db $7F
	db $00
	db $FF
	db $FF
	db $00
	db $3F
	db $FF
	db $FF
	db $1F
	db $00
	db $FF
	db $FF
	db $00
	db $1F
	db $FF
	db $FF
	db $1F
	db $00
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $FE
	db $FC
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $F8
	db $FC
	db $00
	db $07
	db $FF
	db $FF
	db $07
	db $00
	db $FE
	db $FF
	db $C0
	db $03
	db $FF
	db $FF
	db $03
	db $C0
	db $FF
	db $FF
	db $80
	db $01
	db $FF
	db $FF
	db $00
	db $80
	db $FF
	db $FF
	db $00
	db $00
	db $7F
	db $3F
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $3F
	db $3F
	db $80
	db $00
	db $FC
	db $F8
	db $07
	db $F8
	db $3F
	db $3F
	db $FC
	db $07
	db $F8
	db $FC
	db $0F
	db $FF
	db $7F
	db $FF
	db $FF
	db $0F
	db $FE
	db $FF
	db $E0
	db $3F
	db $FF
	db $FF
	db $1F
	db $C0
	db $FF
	db $FF
	db $C0
	db $0F
	db $FF
	db $FF
	db $07
	db $C0
	db $FF
	db $FF
	db $C0
	db $07
	db $FF
	db $FF
	db $07
	db $C0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $03
	db $80
	db $FF
	db $FF
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $00
	db $FE
	db $FF
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $80
	db $FF
	db $FF
	db $F0
	db $00
	db $FF
	db $FF
	db $00
	db $F0
	db $FF
	db $FF
	db $E0
	db $00
	db $7F
	db $3F
	db $00
	db $E0
	db $FF
	db $FF
	db $C0
	db $00
	db $1F
	db $0F
	db $00
	db $C0
	db $FF
	db $FF
	db $C0
	db $00
	db $0F
	db $0F
	db $20
	db $00
	db $FF
	db $FE
	db $01
	db $FE
	db $0F
	db $0F
	db $FF
	db $01
	db $FE
	db $FF
	db $03
	db $FF
	db $DF
	db $FF
	db $FF
	db $83
	db $FF

gfx_RunningBaddyLeft2:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $03
	db $05
	db $30
	db $00
	db $00
	db $00
	db $00
	db $28
	db $05
	db $06
	db $C4
	db $00
	db $00
	db $00
	db $00
	db $4E
	db $04
	db $06
	db $8B
	db $00
	db $00
	db $00
	db $80
	db $31
	db $03
	db $00
	db $DC
	db $80
	db $00
	db $00
	db $80
	db $F8
	db $00
	db $0F
	db $79
	db $00
	db $00
	db $00
	db $00
	db $66
	db $12
	db $13
	db $E2
	db $00
	db $00
	db $00
	db $00
	db $B6
	db $0C
	db $00
	db $DF
	db $00
	db $00
	db $00
	db $00
	db $AD
	db $00
	db $00
	db $D7
	db $00
	db $00
	db $00
	db $00
	db $B0
	db $00
	db $00
	db $C7
	db $00
	db $00
	db $00
	db $80
	db $37
	db $00
	db $00
	db $1B
	db $C0
	db $00
	db $00
	db $E0
	db $0C
	db $00
	db $00
	db $0D
	db $C0
	db $00
	db $00
	db $00
	db $1B
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $F8
	db $00
	db $01
	db $4C
	db $00
	db $00
	db $00
	db $00
	db $4A
	db $01
	db $01
	db $B1
	db $00
	db $00
	db $00
	db $80
	db $13
	db $01
	db $01
	db $A2
	db $C0
	db $00
	db $00
	db $60
	db $CC
	db $00
	db $00
	db $37
	db $20
	db $00
	db $00
	db $20
	db $3E
	db $00
	db $03
	db $DE
	db $40
	db $00
	db $00
	db $80
	db $99
	db $04
	db $04
	db $F8
	db $80
	db $00
	db $00
	db $80
	db $2D
	db $03
	db $00
	db $37
	db $C0
	db $00
	db $00
	db $40
	db $2B
	db $00
	db $00
	db $35
	db $C0
	db $00
	db $00
	db $00
	db $2C
	db $00
	db $00
	db $31
	db $C0
	db $00
	db $00
	db $E0
	db $0D
	db $00
	db $00
	db $06
	db $F0
	db $00
	db $00
	db $38
	db $03
	db $00
	db $00
	db $03
	db $70
	db $00
	db $00
	db $C0
	db $06
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $3E
	db $00
	db $00
	db $53
	db $00
	db $00
	db $00
	db $80
	db $52
	db $00
	db $00
	db $6C
	db $40
	db $00
	db $00
	db $E0
	db $44
	db $00
	db $00
	db $68
	db $B0
	db $00
	db $00
	db $18
	db $33
	db $00
	db $00
	db $0D
	db $C8
	db $00
	db $00
	db $88
	db $0F
	db $00
	db $00
	db $F7
	db $90
	db $00
	db $00
	db $60
	db $26
	db $01
	db $01
	db $3E
	db $20
	db $00
	db $00
	db $60
	db $CB
	db $00
	db $00
	db $0D
	db $F0
	db $00
	db $00
	db $D0
	db $0A
	db $00
	db $00
	db $0D
	db $70
	db $00
	db $00
	db $00
	db $0B
	db $00
	db $00
	db $0C
	db $70
	db $00
	db $00
	db $78
	db $03
	db $00
	db $00
	db $01
	db $BC
	db $00
	db $00
	db $CE
	db $00
	db $00
	db $00
	db $00
	db $DC
	db $00
	db $00
	db $B0
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $0F
	db $00
	db $00
	db $14
	db $C0
	db $00
	db $00
	db $A0
	db $14
	db $00
	db $00
	db $1B
	db $10
	db $00
	db $00
	db $38
	db $11
	db $00
	db $00
	db $1A
	db $2C
	db $00
	db $00
	db $C6
	db $0C
	db $00
	db $00
	db $03
	db $72
	db $00
	db $00
	db $E2
	db $03
	db $00
	db $00
	db $3D
	db $E4
	db $00
	db $00
	db $98
	db $49
	db $00
	db $00
	db $4F
	db $88
	db $00
	db $00
	db $D8
	db $32
	db $00
	db $00
	db $03
	db $7C
	db $00
	db $00
	db $B4
	db $02
	db $00
	db $00
	db $03
	db $5C
	db $00
	db $00
	db $C0
	db $02
	db $00
	db $00
	db $03
	db $1C
	db $00
	db $00
	db $DE
	db $00
	db $00
	db $00
	db $00
	db $6F
	db $00
	db $80
	db $33
	db $00
	db $00
	db $00
	db $00
	db $37
	db $00
	db $00
	db $6C
	db $00
	db $00

gfx_MaskRunningBaddyLeft2:
	db $FC
	db $1F
	db $FF
	db $FF
	db $FF
	db $FF
	db $0F
	db $F8
	db $F0
	db $07
	db $FF
	db $FF
	db $FF
	db $FF
	db $03
	db $F0
	db $F0
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $F0
	db $F0
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $00
	db $F8
	db $E0
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $C0
	db $80
	db $00
	db $7F
	db $FF
	db $FF
	db $FF
	db $00
	db $C0
	db $C0
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $E0
	db $F2
	db $00
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $FE
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $FF
	db $00
	db $FE
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $00
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $0F
	db $C0
	db $FF
	db $FF
	db $E0
	db $0F
	db $FF
	db $FF
	db $1F
	db $C0
	db $FF
	db $FF
	db $07
	db $FF
	db $FF
	db $FF
	db $FF
	db $03
	db $FE
	db $FC
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FC
	db $FC
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $00
	db $FC
	db $FC
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $FE
	db $F8
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $F0
	db $E0
	db $00
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $F0
	db $F0
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $F8
	db $FC
	db $80
	db $1F
	db $FF
	db $FF
	db $1F
	db $80
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $3F
	db $80
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $0F
	db $C0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $03
	db $F0
	db $FF
	db $FF
	db $F8
	db $03
	db $FF
	db $FF
	db $07
	db $F0
	db $FF
	db $FF
	db $C1
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $FF
	db $FF
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $00
	db $FF
	db $FF
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $FF
	db $FF
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $80
	db $FF
	db $FE
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $00
	db $FC
	db $F8
	db $00
	db $07
	db $FF
	db $FF
	db $0F
	db $00
	db $FC
	db $FC
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FE
	db $FF
	db $20
	db $07
	db $FF
	db $FF
	db $07
	db $E0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $0F
	db $E0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $03
	db $F0
	db $FF
	db $FF
	db $F8
	db $01
	db $FF
	db $FF
	db $00
	db $FC
	db $FF
	db $FF
	db $FE
	db $00
	db $FF
	db $FF
	db $01
	db $FC
	db $FF
	db $FF
	db $F0
	db $7F
	db $FF
	db $FF
	db $3F
	db $E0
	db $FF
	db $FF
	db $C0
	db $1F
	db $FF
	db $FF
	db $0F
	db $C0
	db $FF
	db $FF
	db $C0
	db $07
	db $FF
	db $FF
	db $03
	db $C0
	db $FF
	db $FF
	db $C0
	db $01
	db $FF
	db $FF
	db $00
	db $E0
	db $FF
	db $FF
	db $80
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $FF
	db $FE
	db $00
	db $01
	db $FF
	db $FF
	db $03
	db $00
	db $FF
	db $FF
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $80
	db $FF
	db $FF
	db $C8
	db $01
	db $FF
	db $FF
	db $01
	db $F8
	db $FF
	db $FF
	db $F8
	db $01
	db $FF
	db $FF
	db $03
	db $F8
	db $FF
	db $FF
	db $F8
	db $01
	db $FF
	db $FF
	db $00
	db $FC
	db $FF
	db $FF
	db $FE
	db $00
	db $7F
	db $3F
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $3F
	db $7F
	db $00
	db $FF
	db $FF

gfx_RunningBaddyRight1:
	db $00
	db $07
	db $C0
	db $00
	db $00
	db $A0
	db $0C
	db $00
	db $00
	db $1C
	db $A0
	db $00
	db $00
	db $60
	db $27
	db $00
	db $00
	db $22
	db $20
	db $00
	db $00
	db $60
	db $31
	db $00
	db $00
	db $28
	db $C0
	db $00
	db $00
	db $80
	db $46
	db $00
	db $00
	db $65
	db $C0
	db $00
	db $00
	db $20
	db $4F
	db $00
	db $00
	db $E0
	db $A0
	db $00
	db $00
	db $C0
	db $F5
	db $00
	db $01
	db $FF
	db $80
	db $00
	db $00
	db $80
	db $F5
	db $01
	db $03
	db $DA
	db $C0
	db $00
	db $00
	db $40
	db $F5
	db $00
	db $0F
	db $6E
	db $E0
	db $00
	db $00
	db $80
	db $9D
	db $1F
	db $1F
	db $CE
	db $40
	db $00
	db $00
	db $E0
	db $01
	db $18
	db $10
	db $00
	db $EC
	db $00
	db $00
	db $FC
	db $00
	db $10
	db $00
	db $00
	db $78
	db $00
	db $00
	db $70
	db $00
	db $00
	db $00
	db $01
	db $F0
	db $00
	db $00
	db $28
	db $03
	db $00
	db $00
	db $07
	db $28
	db $00
	db $00
	db $D8
	db $09
	db $00
	db $00
	db $08
	db $88
	db $00
	db $00
	db $58
	db $0C
	db $00
	db $00
	db $0A
	db $30
	db $00
	db $00
	db $A0
	db $11
	db $00
	db $00
	db $19
	db $70
	db $00
	db $00
	db $C8
	db $13
	db $00
	db $00
	db $38
	db $28
	db $00
	db $00
	db $70
	db $3D
	db $00
	db $00
	db $7F
	db $E0
	db $00
	db $00
	db $60
	db $7D
	db $00
	db $00
	db $F6
	db $B0
	db $00
	db $00
	db $50
	db $3D
	db $00
	db $03
	db $DB
	db $B8
	db $00
	db $00
	db $60
	db $E7
	db $07
	db $07
	db $F3
	db $90
	db $00
	db $00
	db $78
	db $00
	db $06
	db $04
	db $00
	db $3B
	db $00
	db $00
	db $3F
	db $00
	db $04
	db $00
	db $00
	db $1E
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $7C
	db $00
	db $00
	db $CA
	db $00
	db $00
	db $00
	db $01
	db $CA
	db $00
	db $00
	db $76
	db $02
	db $00
	db $00
	db $02
	db $22
	db $00
	db $00
	db $16
	db $03
	db $00
	db $00
	db $02
	db $8C
	db $00
	db $00
	db $68
	db $04
	db $00
	db $00
	db $06
	db $5C
	db $00
	db $00
	db $F2
	db $04
	db $00
	db $00
	db $0E
	db $0A
	db $00
	db $00
	db $5C
	db $0F
	db $00
	db $00
	db $1F
	db $F8
	db $00
	db $00
	db $58
	db $1F
	db $00
	db $00
	db $3D
	db $AC
	db $00
	db $00
	db $54
	db $0F
	db $00
	db $00
	db $F6
	db $EE
	db $00
	db $00
	db $D8
	db $F9
	db $01
	db $01
	db $FC
	db $E4
	db $00
	db $00
	db $1E
	db $80
	db $01
	db $01
	db $00
	db $0E
	db $C0
	db $C0
	db $0F
	db $00
	db $01
	db $00
	db $00
	db $07
	db $80
	db $00
	db $07
	db $00
	db $00
	db $00
	db $00
	db $1F
	db $00
	db $80
	db $32
	db $00
	db $00
	db $00
	db $00
	db $72
	db $80
	db $80
	db $9D
	db $00
	db $00
	db $00
	db $00
	db $88
	db $80
	db $80
	db $C5
	db $00
	db $00
	db $00
	db $00
	db $A3
	db $00
	db $00
	db $1A
	db $01
	db $00
	db $00
	db $01
	db $97
	db $00
	db $80
	db $3C
	db $01
	db $00
	db $00
	db $03
	db $82
	db $80
	db $00
	db $D7
	db $03
	db $00
	db $00
	db $07
	db $FE
	db $00
	db $00
	db $D6
	db $07
	db $00
	db $00
	db $0F
	db $6B
	db $00
	db $00
	db $D5
	db $03
	db $00
	db $00
	db $3D
	db $BB
	db $80
	db $00
	db $76
	db $7E
	db $00
	db $00
	db $7F
	db $39
	db $00
	db $80
	db $07
	db $60
	db $00
	db $00
	db $40
	db $03
	db $B0
	db $F0
	db $03
	db $40
	db $00
	db $00
	db $00
	db $01
	db $E0
	db $C0
	db $01
	db $00
	db $00

gfx_MaskRunningBaddyRight1:
	db $FF
	db $F0
	db $1F
	db $FF
	db $FF
	db $0F
	db $E0
	db $FF
	db $FF
	db $C0
	db $0F
	db $FF
	db $FF
	db $0F
	db $80
	db $FF
	db $FF
	db $80
	db $0F
	db $FF
	db $FF
	db $0F
	db $80
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $07
	db $00
	db $FF
	db $FF
	db $00
	db $03
	db $FF
	db $FF
	db $01
	db $00
	db $FF
	db $FE
	db $00
	db $03
	db $FF
	db $FF
	db $07
	db $00
	db $FE
	db $FC
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $FC
	db $F8
	db $00
	db $1F
	db $FF
	db $FF
	db $1F
	db $00
	db $F0
	db $E0
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $C0
	db $C0
	db $00
	db $0F
	db $FF
	db $FF
	db $03
	db $10
	db $C0
	db $C1
	db $FE
	db $01
	db $FF
	db $FF
	db $01
	db $FE
	db $C3
	db $EF
	db $FF
	db $03
	db $FF
	db $FF
	db $07
	db $FF
	db $FF
	db $FF
	db $FC
	db $07
	db $FF
	db $FF
	db $03
	db $F8
	db $FF
	db $FF
	db $F0
	db $03
	db $FF
	db $FF
	db $03
	db $E0
	db $FF
	db $FF
	db $E0
	db $03
	db $FF
	db $FF
	db $03
	db $E0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $01
	db $C0
	db $FF
	db $FF
	db $C0
	db $00
	db $FF
	db $7F
	db $00
	db $C0
	db $FF
	db $FF
	db $80
	db $00
	db $FF
	db $FF
	db $01
	db $80
	db $FF
	db $FF
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FF
	db $FE
	db $00
	db $07
	db $FF
	db $FF
	db $07
	db $00
	db $FC
	db $F8
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $00
	db $F0
	db $F0
	db $00
	db $03
	db $FF
	db $FF
	db $00
	db $04
	db $F0
	db $F0
	db $7F
	db $80
	db $7F
	db $7F
	db $80
	db $FF
	db $F0
	db $FB
	db $FF
	db $C0
	db $FF
	db $FF
	db $C1
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $FF
	db $FF
	db $00
	db $FE
	db $FF
	db $FF
	db $FC
	db $00
	db $FF
	db $FF
	db $00
	db $F8
	db $FF
	db $FF
	db $F8
	db $00
	db $FF
	db $FF
	db $00
	db $F8
	db $FF
	db $FF
	db $F8
	db $01
	db $FF
	db $7F
	db $00
	db $F0
	db $FF
	db $FF
	db $F0
	db $00
	db $3F
	db $1F
	db $00
	db $F0
	db $FF
	db $FF
	db $E0
	db $00
	db $3F
	db $7F
	db $00
	db $E0
	db $FF
	db $FF
	db $C0
	db $03
	db $FF
	db $FF
	db $03
	db $C0
	db $FF
	db $FF
	db $80
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $FF
	db $FE
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $00
	db $FF
	db $3F
	db $00
	db $01
	db $FC
	db $FC
	db $1F
	db $E0
	db $1F
	db $1F
	db $E0
	db $3F
	db $FC
	db $FE
	db $FF
	db $F0
	db $3F
	db $7F
	db $F0
	db $FF
	db $FF
	db $FF
	db $FF
	db $C0
	db $7F
	db $3F
	db $80
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $3F
	db $3F
	db $00
	db $FE
	db $FF
	db $FF
	db $FE
	db $00
	db $3F
	db $3F
	db $00
	db $FE
	db $FF
	db $FF
	db $FE
	db $00
	db $7F
	db $1F
	db $00
	db $FC
	db $FF
	db $FF
	db $FC
	db $00
	db $0F
	db $07
	db $00
	db $FC
	db $FF
	db $FF
	db $F8
	db $00
	db $0F
	db $1F
	db $00
	db $F8
	db $FF
	db $FF
	db $F0
	db $00
	db $FF
	db $FF
	db $00
	db $F0
	db $FF
	db $FF
	db $E0
	db $00
	db $7F
	db $7F
	db $00
	db $C0
	db $FF
	db $FF
	db $80
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $3F
	db $0F
	db $40
	db $00
	db $FF
	db $FF
	db $07
	db $F8
	db $07
	db $07
	db $F8
	db $0F
	db $FF
	db $FF
	db $BF
	db $FC
	db $0F
	db $1F
	db $FC
	db $FF
	db $FF

gfx_RunningBaddyRight2:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $07
	db $00
	db $00
	db $0C
	db $A0
	db $00
	db $00
	db $A0
	db $14
	db $00
	db $00
	db $23
	db $60
	db $00
	db $00
	db $20
	db $72
	db $00
	db $00
	db $D1
	db $60
	db $00
	db $00
	db $C0
	db $8C
	db $01
	db $01
	db $3B
	db $00
	db $00
	db $00
	db $00
	db $1F
	db $01
	db $00
	db $9E
	db $F0
	db $00
	db $00
	db $48
	db $66
	db $00
	db $00
	db $47
	db $C8
	db $00
	db $00
	db $30
	db $6D
	db $00
	db $00
	db $FB
	db $00
	db $00
	db $00
	db $00
	db $B5
	db $00
	db $00
	db $EB
	db $00
	db $00
	db $00
	db $00
	db $0D
	db $00
	db $00
	db $E3
	db $00
	db $00
	db $00
	db $00
	db $EC
	db $01
	db $03
	db $D8
	db $00
	db $00
	db $00
	db $00
	db $30
	db $07
	db $03
	db $B0
	db $00
	db $00
	db $00
	db $00
	db $D8
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $F0
	db $01
	db $00
	db $00
	db $03
	db $28
	db $00
	db $00
	db $28
	db $05
	db $00
	db $00
	db $08
	db $D8
	db $00
	db $00
	db $88
	db $1C
	db $00
	db $00
	db $34
	db $58
	db $00
	db $00
	db $30
	db $63
	db $00
	db $00
	db $4E
	db $C0
	db $00
	db $00
	db $C0
	db $47
	db $00
	db $00
	db $27
	db $BC
	db $00
	db $00
	db $92
	db $19
	db $00
	db $00
	db $11
	db $F2
	db $00
	db $00
	db $4C
	db $1B
	db $00
	db $00
	db $3E
	db $C0
	db $00
	db $00
	db $40
	db $2D
	db $00
	db $00
	db $3A
	db $C0
	db $00
	db $00
	db $40
	db $03
	db $00
	db $00
	db $38
	db $C0
	db $00
	db $00
	db $00
	db $7B
	db $00
	db $00
	db $F6
	db $00
	db $00
	db $00
	db $00
	db $CC
	db $01
	db $00
	db $EC
	db $00
	db $00
	db $00
	db $00
	db $36
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $7C
	db $00
	db $00
	db $00
	db $00
	db $CA
	db $00
	db $00
	db $4A
	db $01
	db $00
	db $00
	db $02
	db $36
	db $00
	db $00
	db $22
	db $07
	db $00
	db $00
	db $0D
	db $16
	db $00
	db $00
	db $CC
	db $18
	db $00
	db $00
	db $13
	db $B0
	db $00
	db $00
	db $F0
	db $11
	db $00
	db $00
	db $09
	db $EF
	db $00
	db $80
	db $64
	db $06
	db $00
	db $00
	db $04
	db $7C
	db $80
	db $00
	db $D3
	db $06
	db $00
	db $00
	db $0F
	db $B0
	db $00
	db $00
	db $50
	db $0B
	db $00
	db $00
	db $0E
	db $B0
	db $00
	db $00
	db $D0
	db $00
	db $00
	db $00
	db $0E
	db $30
	db $00
	db $00
	db $C0
	db $1E
	db $00
	db $00
	db $3D
	db $80
	db $00
	db $00
	db $00
	db $73
	db $00
	db $00
	db $3B
	db $00
	db $00
	db $00
	db $80
	db $0D
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $1F
	db $00
	db $00
	db $00
	db $00
	db $32
	db $80
	db $80
	db $52
	db $00
	db $00
	db $00
	db $00
	db $8D
	db $80
	db $80
	db $C8
	db $01
	db $00
	db $00
	db $03
	db $45
	db $80
	db $00
	db $33
	db $06
	db $00
	db $00
	db $04
	db $EC
	db $00
	db $00
	db $7C
	db $04
	db $00
	db $00
	db $02
	db $7B
	db $C0
	db $20
	db $99
	db $01
	db $00
	db $00
	db $01
	db $1F
	db $20
	db $C0
	db $B4
	db $01
	db $00
	db $00
	db $03
	db $EC
	db $00
	db $00
	db $D4
	db $02
	db $00
	db $00
	db $03
	db $AC
	db $00
	db $00
	db $34
	db $00
	db $00
	db $00
	db $03
	db $8C
	db $00
	db $00
	db $B0
	db $07
	db $00
	db $00
	db $0F
	db $60
	db $00
	db $00
	db $C0
	db $1C
	db $00
	db $00
	db $0E
	db $C0
	db $00
	db $00
	db $60
	db $03
	db $00

gfx_MaskRunningBaddyRight2:
	db $FF
	db $F8
	db $3F
	db $FF
	db $FF
	db $1F
	db $F0
	db $FF
	db $FF
	db $E0
	db $0F
	db $FF
	db $FF
	db $0F
	db $C0
	db $FF
	db $FF
	db $80
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $FF
	db $FE
	db $00
	db $0F
	db $FF
	db $FF
	db $1F
	db $00
	db $FC
	db $FC
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $FC
	db $FE
	db $00
	db $01
	db $FF
	db $FF
	db $03
	db $00
	db $FF
	db $FF
	db $00
	db $03
	db $FF
	db $FF
	db $07
	db $00
	db $FF
	db $FE
	db $00
	db $4F
	db $FF
	db $FF
	db $7F
	db $00
	db $FE
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $7F
	db $00
	db $FF
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $FF
	db $00
	db $FC
	db $F8
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $03
	db $F0
	db $F0
	db $07
	db $FF
	db $FF
	db $FF
	db $FF
	db $03
	db $F8
	db $FF
	db $FE
	db $0F
	db $FF
	db $FF
	db $07
	db $FC
	db $FF
	db $FF
	db $F8
	db $03
	db $FF
	db $FF
	db $03
	db $F0
	db $FF
	db $FF
	db $E0
	db $03
	db $FF
	db $FF
	db $03
	db $C0
	db $FF
	db $FF
	db $80
	db $03
	db $FF
	db $FF
	db $07
	db $00
	db $FF
	db $FF
	db $00
	db $01
	db $FF
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $80
	db $00
	db $7F
	db $FF
	db $00
	db $C0
	db $FF
	db $FF
	db $C0
	db $00
	db $FF
	db $FF
	db $01
	db $C0
	db $FF
	db $FF
	db $80
	db $13
	db $FF
	db $FF
	db $1F
	db $80
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $1F
	db $C0
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $FF
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $FF
	db $00
	db $FC
	db $FC
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FE
	db $FF
	db $FF
	db $83
	db $FF
	db $FF
	db $01
	db $FF
	db $FF
	db $FF
	db $FE
	db $00
	db $FF
	db $FF
	db $00
	db $FC
	db $FF
	db $FF
	db $F8
	db $00
	db $FF
	db $FF
	db $00
	db $F0
	db $FF
	db $FF
	db $E0
	db $00
	db $FF
	db $FF
	db $01
	db $C0
	db $FF
	db $FF
	db $C0
	db $00
	db $7F
	db $3F
	db $00
	db $C0
	db $FF
	db $FF
	db $E0
	db $00
	db $1F
	db $3F
	db $00
	db $F0
	db $FF
	db $FF
	db $F0
	db $00
	db $3F
	db $7F
	db $00
	db $F0
	db $FF
	db $FF
	db $E0
	db $04
	db $FF
	db $FF
	db $07
	db $E0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $07
	db $F0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $0F
	db $C0
	db $FF
	db $FF
	db $80
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $FF
	db $FF
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $80
	db $FF
	db $FF
	db $FF
	db $E0
	db $FF
	db $7F
	db $C0
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $3F
	db $3F
	db $00
	db $FF
	db $FF
	db $FF
	db $FE
	db $00
	db $3F
	db $3F
	db $00
	db $FC
	db $FF
	db $FF
	db $F8
	db $00
	db $3F
	db $7F
	db $00
	db $F0
	db $FF
	db $FF
	db $F0
	db $00
	db $1F
	db $0F
	db $00
	db $F0
	db $FF
	db $FF
	db $F8
	db $00
	db $07
	db $0F
	db $00
	db $FC
	db $FF
	db $FF
	db $FC
	db $00
	db $0F
	db $1F
	db $00
	db $FC
	db $FF
	db $FF
	db $F8
	db $01
	db $3F
	db $FF
	db $01
	db $F8
	db $FF
	db $FF
	db $F8
	db $01
	db $FF
	db $FF
	db $01
	db $FC
	db $FF
	db $FF
	db $F8
	db $01
	db $FF
	db $FF
	db $03
	db $F0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $0F
	db $C0
	db $FF
	db $FF
	db $C0
	db $1F
	db $FF
	db $FF
	db $0F
	db $E0
	db $FF

gfx_SkeletonLeft:
	db $00
	db $F0
	db $00
	db $00
	db $00
	db $00
	db $18
	db $01
	db $03
	db $88
	db $00
	db $00
	db $00
	db $00
	db $A8
	db $03
	db $02
	db $30
	db $00
	db $00
	db $00
	db $00
	db $30
	db $02
	db $03
	db $D8
	db $00
	db $00
	db $00
	db $00
	db $14
	db $00
	db $08
	db $3C
	db $00
	db $00
	db $00
	db $00
	db $64
	db $3C
	db $1B
	db $9C
	db $00
	db $00
	db $00
	db $00
	db $24
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $24
	db $00
	db $00
	db $6C
	db $00
	db $00
	db $00
	db $00
	db $BA
	db $00
	db $01
	db $45
	db $00
	db $00
	db $00
	db $F8
	db $82
	db $03
	db $02
	db $01
	db $F4
	db $00
	db $00
	db $04
	db $00
	db $06
	db $04
	db $00
	db $04
	db $00
	db $00
	db $02
	db $00
	db $34
	db $1A
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0C

gfx_SkeletonRight:
	db $00
	db $0F
	db $00
	db $00
	db $00
	db $80
	db $18
	db $00
	db $00
	db $11
	db $C0
	db $00
	db $00
	db $C0
	db $15
	db $00
	db $00
	db $0C
	db $40
	db $00
	db $00
	db $40
	db $0C
	db $00
	db $00
	db $1B
	db $C0
	db $00
	db $00
	db $00
	db $28
	db $00
	db $00
	db $3C
	db $10
	db $00
	db $00
	db $3C
	db $26
	db $00
	db $00
	db $39
	db $D8
	db $00
	db $00
	db $00
	db $24
	db $00
	db $00
	db $38
	db $00
	db $00
	db $00
	db $00
	db $24
	db $00
	db $00
	db $36
	db $00
	db $00
	db $00
	db $00
	db $5D
	db $00
	db $00
	db $A2
	db $80
	db $00
	db $00
	db $C0
	db $41
	db $1F
	db $2F
	db $80
	db $40
	db $00
	db $00
	db $60
	db $00
	db $20
	db $20
	db $00
	db $20
	db $00
	db $00
	db $2C
	db $00
	db $40
	db $00
	db $00
	db $58
	db $00
	db $00
	db $30
	db $00
	db $00

gfx_BaddyGunRunnerRight:
	db $00
	db $07
	db $80
	db $00
	db $00
	db $C0
	db $0F
	db $00
	db $00
	db $0A
	db $20
	db $00
	db $00
	db $E0
	db $0F
	db $00
	db $00
	db $1E
	db $20
	db $00
	db $00
	db $20
	db $26
	db $00
	db $00
	db $23
	db $C0
	db $00
	db $00
	db $80
	db $46
	db $00
	db $00
	db $77
	db $F8
	db $00
	db $00
	db $24
	db $4F
	db $00
	db $00
	db $45
	db $B8
	db $00
	db $00
	db $C0
	db $22
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $75
	db $80
	db $00
	db $00
	db $C0
	db $FE
	db $07
	db $0B
	db $9F
	db $C0
	db $00
	db $00
	db $60
	db $7F
	db $0A
	db $0B
	db $E3
	db $A0
	db $00
	db $00
	db $A0
	db $01
	db $0A
	db $04
	db $00
	db $FC
	db $00
	db $00
	db $E4
	db $00
	db $00
	db $00
	db $00
	db $48
	db $00
	db $00
	db $70
	db $00
	db $00
	db $00
	db $01
	db $E0
	db $00
	db $00
	db $F0
	db $03
	db $00
	db $00
	db $02
	db $88
	db $00
	db $00
	db $F8
	db $03
	db $00
	db $00
	db $07
	db $88
	db $00
	db $00
	db $88
	db $09
	db $00
	db $00
	db $08
	db $F0
	db $00
	db $00
	db $A0
	db $11
	db $00
	db $00
	db $1D
	db $FE
	db $00
	db $00
	db $C9
	db $13
	db $00
	db $00
	db $11
	db $6E
	db $00
	db $00
	db $B0
	db $08
	db $00
	db $00
	db $0F
	db $C0
	db $00
	db $00
	db $C0
	db $0F
	db $00
	db $00
	db $1D
	db $60
	db $00
	db $00
	db $B0
	db $FF
	db $01
	db $02
	db $E7
	db $F0
	db $00
	db $00
	db $D8
	db $9F
	db $02
	db $02
	db $F8
	db $E8
	db $00
	db $00
	db $68
	db $80
	db $02
	db $01
	db $00
	db $3F
	db $00
	db $00
	db $39
	db $00
	db $00
	db $00
	db $00
	db $12
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $78
	db $00
	db $00
	db $FC
	db $00
	db $00
	db $00
	db $00
	db $A2
	db $00
	db $00
	db $FE
	db $00
	db $00
	db $00
	db $01
	db $E2
	db $00
	db $00
	db $62
	db $02
	db $00
	db $00
	db $02
	db $3C
	db $00
	db $00
	db $68
	db $04
	db $00
	db $00
	db $07
	db $7F
	db $80
	db $40
	db $F2
	db $04
	db $00
	db $00
	db $04
	db $5B
	db $80
	db $00
	db $2C
	db $02
	db $00
	db $00
	db $03
	db $F0
	db $00
	db $00
	db $F0
	db $03
	db $00
	db $00
	db $07
	db $58
	db $00
	db $00
	db $EC
	db $7F
	db $00
	db $00
	db $B9
	db $FC
	db $00
	db $00
	db $F6
	db $A7
	db $00
	db $00
	db $BE
	db $3A
	db $00
	db $00
	db $1A
	db $A0
	db $00
	db $00
	db $40
	db $0F
	db $C0
	db $40
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $04
	db $80
	db $00
	db $07
	db $00
	db $00
	db $00
	db $00
	db $1E
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $00
	db $00
	db $28
	db $80
	db $80
	db $3F
	db $00
	db $00
	db $00
	db $00
	db $78
	db $80
	db $80
	db $98
	db $00
	db $00
	db $00
	db $00
	db $8F
	db $00
	db $00
	db $1A
	db $01
	db $00
	db $00
	db $01
	db $DF
	db $E0
	db $90
	db $3C
	db $01
	db $00
	db $00
	db $01
	db $16
	db $E0
	db $00
	db $8B
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $00
	db $00
	db $FC
	db $00
	db $00
	db $00
	db $01
	db $D6
	db $00
	db $00
	db $FB
	db $1F
	db $00
	db $00
	db $2E
	db $7F
	db $00
	db $80
	db $FD
	db $29
	db $00
	db $00
	db $2F
	db $8E
	db $80
	db $80
	db $06
	db $28
	db $00
	db $00
	db $10
	db $03
	db $F0
	db $90
	db $03
	db $00
	db $00
	db $00
	db $00
	db $01
	db $20
	db $C0
	db $01
	db $00
	db $00

gfx_BaddyGunRunnerRightShoot:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $07
	db $00
	db $00
	db $0F
	db $C0
	db $00
	db $00
	db $20
	db $0A
	db $00
	db $00
	db $0F
	db $E0
	db $00
	db $00
	db $20
	db $1E
	db $00
	db $00
	db $26
	db $20
	db $00
	db $00
	db $C0
	db $23
	db $00
	db $00
	db $46
	db $80
	db $00
	db $00
	db $F8
	db $77
	db $00
	db $00
	db $4F
	db $24
	db $00
	db $00
	db $B8
	db $45
	db $00
	db $00
	db $22
	db $C0
	db $00
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $2E
	db $00
	db $00
	db $00
	db $00
	db $2F
	db $00
	db $00
	db $6B
	db $00
	db $00
	db $00
	db $00
	db $5B
	db $00
	db $00
	db $B6
	db $00
	db $00
	db $00
	db $00
	db $EE
	db $01
	db $03
	db $DC
	db $00
	db $00
	db $00
	db $00
	db $B8
	db $04
	db $04
	db $50
	db $00
	db $00
	db $00
	db $00
	db $28
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $01
	db $00
	db $00
	db $03
	db $F0
	db $00
	db $00
	db $88
	db $02
	db $00
	db $00
	db $03
	db $F8
	db $00
	db $00
	db $88
	db $07
	db $00
	db $00
	db $09
	db $88
	db $00
	db $00
	db $F0
	db $08
	db $00
	db $00
	db $11
	db $A0
	db $00
	db $00
	db $FE
	db $1D
	db $00
	db $00
	db $13
	db $C9
	db $00
	db $00
	db $6E
	db $11
	db $00
	db $00
	db $08
	db $B0
	db $00
	db $00
	db $C0
	db $0F
	db $00
	db $00
	db $0B
	db $80
	db $00
	db $00
	db $C0
	db $0B
	db $00
	db $00
	db $1A
	db $C0
	db $00
	db $00
	db $C0
	db $16
	db $00
	db $00
	db $2D
	db $80
	db $00
	db $00
	db $80
	db $7B
	db $00
	db $00
	db $F7
	db $00
	db $00
	db $00
	db $00
	db $2E
	db $01
	db $01
	db $14
	db $00
	db $00
	db $00
	db $00
	db $CA
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $78
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $00
	db $00
	db $A2
	db $00
	db $00
	db $00
	db $00
	db $FE
	db $00
	db $00
	db $E2
	db $01
	db $00
	db $00
	db $02
	db $62
	db $00
	db $00
	db $3C
	db $02
	db $00
	db $00
	db $04
	db $68
	db $00
	db $80
	db $7F
	db $07
	db $00
	db $00
	db $04
	db $F2
	db $40
	db $80
	db $5B
	db $04
	db $00
	db $00
	db $02
	db $2C
	db $00
	db $00
	db $F0
	db $03
	db $00
	db $00
	db $02
	db $E0
	db $00
	db $00
	db $F0
	db $02
	db $00
	db $00
	db $06
	db $B0
	db $00
	db $00
	db $B0
	db $05
	db $00
	db $00
	db $0B
	db $60
	db $00
	db $00
	db $E0
	db $1E
	db $00
	db $00
	db $3D
	db $C0
	db $00
	db $00
	db $80
	db $4B
	db $00
	db $00
	db $45
	db $00
	db $00
	db $00
	db $80
	db $32
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $1E
	db $00
	db $00
	db $00
	db $00
	db $3F
	db $00
	db $80
	db $28
	db $00
	db $00
	db $00
	db $00
	db $3F
	db $80
	db $80
	db $78
	db $00
	db $00
	db $00
	db $00
	db $98
	db $80
	db $00
	db $8F
	db $00
	db $00
	db $00
	db $01
	db $1A
	db $00
	db $E0
	db $DF
	db $01
	db $00
	db $00
	db $01
	db $3C
	db $90
	db $E0
	db $16
	db $01
	db $00
	db $00
	db $00
	db $8B
	db $00
	db $00
	db $FC
	db $00
	db $00
	db $00
	db $00
	db $B8
	db $00
	db $00
	db $BC
	db $00
	db $00
	db $00
	db $01
	db $AC
	db $00
	db $00
	db $6C
	db $01
	db $00
	db $00
	db $02
	db $D8
	db $00
	db $00
	db $B8
	db $07
	db $00
	db $00
	db $0F
	db $70
	db $00
	db $00
	db $E0
	db $12
	db $00
	db $00
	db $11
	db $40
	db $00
	db $00
	db $A0
	db $0C
	db $00

gfx_BaddyGunRunnerLeft:
	db $01
	db $E0
	db $00
	db $00
	db $00
	db $00
	db $F0
	db $03
	db $04
	db $50
	db $00
	db $00
	db $00
	db $00
	db $F0
	db $07
	db $04
	db $78
	db $00
	db $00
	db $00
	db $00
	db $64
	db $04
	db $03
	db $C4
	db $00
	db $00
	db $00
	db $00
	db $62
	db $01
	db $1F
	db $EE
	db $00
	db $00
	db $00
	db $00
	db $F2
	db $24
	db $1D
	db $A2
	db $00
	db $00
	db $00
	db $00
	db $44
	db $03
	db $00
	db $FC
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $00
	db $01
	db $AE
	db $00
	db $00
	db $00
	db $E0
	db $7F
	db $03
	db $03
	db $F9
	db $D0
	db $00
	db $00
	db $50
	db $FE
	db $06
	db $05
	db $C7
	db $D0
	db $00
	db $00
	db $50
	db $80
	db $05
	db $3F
	db $00
	db $20
	db $00
	db $00
	db $00
	db $00
	db $27
	db $12
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0E
	db $00
	db $78
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $00
	db $01
	db $14
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $01
	db $01
	db $1E
	db $00
	db $00
	db $00
	db $00
	db $19
	db $01
	db $00
	db $F1
	db $00
	db $00
	db $00
	db $80
	db $58
	db $00
	db $07
	db $FB
	db $80
	db $00
	db $00
	db $80
	db $3C
	db $09
	db $07
	db $68
	db $80
	db $00
	db $00
	db $00
	db $D1
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $6B
	db $80
	db $00
	db $00
	db $F8
	db $DF
	db $00
	db $00
	db $FE
	db $74
	db $00
	db $00
	db $94
	db $BF
	db $01
	db $01
	db $71
	db $F4
	db $00
	db $00
	db $14
	db $60
	db $01
	db $0F
	db $C0
	db $08
	db $00
	db $00
	db $00
	db $C0
	db $09
	db $04
	db $80
	db $00
	db $00
	db $00
	db $00
	db $80
	db $03
	db $00
	db $1E
	db $00
	db $00
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $45
	db $00
	db $00
	db $00
	db $00
	db $7F
	db $00
	db $00
	db $47
	db $80
	db $00
	db $00
	db $40
	db $46
	db $00
	db $00
	db $3C
	db $40
	db $00
	db $00
	db $20
	db $16
	db $00
	db $01
	db $FE
	db $E0
	db $00
	db $00
	db $20
	db $4F
	db $02
	db $01
	db $DA
	db $20
	db $00
	db $00
	db $40
	db $34
	db $00
	db $00
	db $0F
	db $C0
	db $00
	db $00
	db $C0
	db $0F
	db $00
	db $00
	db $1A
	db $E0
	db $00
	db $00
	db $FE
	db $37
	db $00
	db $00
	db $3F
	db $9D
	db $00
	db $00
	db $E5
	db $6F
	db $00
	db $00
	db $5C
	db $7D
	db $00
	db $00
	db $05
	db $58
	db $00
	db $03
	db $F0
	db $02
	db $00
	db $00
	db $00
	db $70
	db $02
	db $01
	db $20
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $00
	db $00
	db $07
	db $80
	db $00
	db $00
	db $C0
	db $0F
	db $00
	db $00
	db $11
	db $40
	db $00
	db $00
	db $C0
	db $1F
	db $00
	db $00
	db $11
	db $E0
	db $00
	db $00
	db $90
	db $11
	db $00
	db $00
	db $0F
	db $10
	db $00
	db $00
	db $88
	db $05
	db $00
	db $00
	db $7F
	db $B8
	db $00
	db $00
	db $C8
	db $93
	db $00
	db $00
	db $76
	db $88
	db $00
	db $00
	db $10
	db $0D
	db $00
	db $00
	db $03
	db $F0
	db $00
	db $00
	db $F0
	db $03
	db $00
	db $00
	db $06
	db $B8
	db $00
	db $80
	db $FF
	db $0D
	db $00
	db $00
	db $0F
	db $E7
	db $40
	db $40
	db $F9
	db $1B
	db $00
	db $00
	db $17
	db $1F
	db $40
	db $40
	db $01
	db $16
	db $00
	db $00
	db $FC
	db $00
	db $80
	db $00
	db $00
	db $9C
	db $00
	db $00
	db $48
	db $00
	db $00
	db $00
	db $00
	db $38
	db $00

gfx_BaddyGunRunnerLeftShoot:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $01
	db $03
	db $F0
	db $00
	db $00
	db $00
	db $00
	db $50
	db $04
	db $07
	db $F0
	db $00
	db $00
	db $00
	db $00
	db $78
	db $04
	db $04
	db $64
	db $00
	db $00
	db $00
	db $00
	db $C4
	db $03
	db $01
	db $62
	db $00
	db $00
	db $00
	db $00
	db $EE
	db $1F
	db $24
	db $F2
	db $00
	db $00
	db $00
	db $00
	db $A2
	db $1D
	db $03
	db $44
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $00
	db $00
	db $74
	db $00
	db $00
	db $00
	db $00
	db $F4
	db $00
	db $00
	db $D6
	db $00
	db $00
	db $00
	db $00
	db $DA
	db $00
	db $00
	db $6D
	db $00
	db $00
	db $00
	db $80
	db $77
	db $00
	db $00
	db $3B
	db $C0
	db $00
	db $00
	db $20
	db $1D
	db $00
	db $00
	db $0A
	db $20
	db $00
	db $00
	db $C0
	db $14
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $78
	db $00
	db $00
	db $FC
	db $00
	db $00
	db $00
	db $00
	db $14
	db $01
	db $01
	db $FC
	db $00
	db $00
	db $00
	db $00
	db $1E
	db $01
	db $01
	db $19
	db $00
	db $00
	db $00
	db $00
	db $F1
	db $00
	db $00
	db $58
	db $80
	db $00
	db $00
	db $80
	db $FB
	db $07
	db $09
	db $3C
	db $80
	db $00
	db $00
	db $80
	db $68
	db $07
	db $00
	db $D1
	db $00
	db $00
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $1D
	db $00
	db $00
	db $00
	db $00
	db $3D
	db $00
	db $00
	db $35
	db $80
	db $00
	db $00
	db $80
	db $36
	db $00
	db $00
	db $1B
	db $40
	db $00
	db $00
	db $E0
	db $1D
	db $00
	db $00
	db $0E
	db $F0
	db $00
	db $00
	db $48
	db $07
	db $00
	db $00
	db $02
	db $88
	db $00
	db $00
	db $30
	db $05
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $1E
	db $00
	db $00
	db $3F
	db $00
	db $00
	db $00
	db $00
	db $45
	db $00
	db $00
	db $7F
	db $00
	db $00
	db $00
	db $80
	db $47
	db $00
	db $00
	db $46
	db $40
	db $00
	db $00
	db $40
	db $3C
	db $00
	db $00
	db $16
	db $20
	db $00
	db $00
	db $E0
	db $FE
	db $01
	db $02
	db $4F
	db $20
	db $00
	db $00
	db $20
	db $DA
	db $01
	db $00
	db $34
	db $40
	db $00
	db $00
	db $C0
	db $0F
	db $00
	db $00
	db $07
	db $40
	db $00
	db $00
	db $40
	db $0F
	db $00
	db $00
	db $0D
	db $60
	db $00
	db $00
	db $A0
	db $0D
	db $00
	db $00
	db $06
	db $D0
	db $00
	db $00
	db $78
	db $07
	db $00
	db $00
	db $03
	db $BC
	db $00
	db $00
	db $D2
	db $01
	db $00
	db $00
	db $00
	db $A2
	db $00
	db $00
	db $4C
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $07
	db $00
	db $00
	db $0F
	db $C0
	db $00
	db $00
	db $40
	db $11
	db $00
	db $00
	db $1F
	db $C0
	db $00
	db $00
	db $E0
	db $11
	db $00
	db $00
	db $11
	db $90
	db $00
	db $00
	db $10
	db $0F
	db $00
	db $00
	db $05
	db $88
	db $00
	db $00
	db $B8
	db $7F
	db $00
	db $00
	db $93
	db $C8
	db $00
	db $00
	db $88
	db $76
	db $00
	db $00
	db $0D
	db $10
	db $00
	db $00
	db $F0
	db $03
	db $00
	db $00
	db $01
	db $D0
	db $00
	db $00
	db $D0
	db $03
	db $00
	db $00
	db $03
	db $58
	db $00
	db $00
	db $68
	db $03
	db $00
	db $00
	db $01
	db $B4
	db $00
	db $00
	db $DE
	db $01
	db $00
	db $00
	db $00
	db $EF
	db $00
	db $80
	db $74
	db $00
	db $00
	db $00
	db $00
	db $28
	db $80
	db $00
	db $53
	db $00
	db $00

gfx_MortarGuyLeft:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $1A
	db $00
	db $00
	db $37
	db $00
	db $00
	db $00
	db $40
	db $3F
	db $00
	db $00
	db $22
	db $20
	db $00
	db $00
	db $70
	db $22
	db $30
	db $48
	db $36
	db $78
	db $00
	db $00
	db $9C
	db $5C
	db $5F
	db $33
	db $E4
	db $EC
	db $00
	db $00
	db $DC
	db $F9
	db $0D
	db $12
	db $0F
	db $98
	db $00
	db $00
	db $70
	db $06
	db $19
	db $0C
	db $80
	db $20
	db $00
	db $00
	db $30
	db $C7
	db $07
	db $03
	db $6F
	db $F0
	db $00
	db $00
	db $A8
	db $D5
	db $03
	db $02
	db $CB
	db $B4
	db $00
	db $00
	db $DC
	db $65
	db $07
	db $0A
	db $32
	db $E8
	db $00
	db $00
	db $68
	db $19
	db $0A
	db $1C
	db $2C
	db $BC
	db $00
	db $00
	db $5A
	db $16
	db $28
	db $28
	db $23
	db $52
	db $00
	db $00
	db $9E
	db $79
	db $30
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $06
	db $00
	db $00
	db $0D
	db $C0
	db $00
	db $00
	db $D0
	db $0F
	db $00
	db $00
	db $08
	db $88
	db $00
	db $00
	db $9C
	db $08
	db $0C
	db $12
	db $0D
	db $9E
	db $00
	db $00
	db $27
	db $D7
	db $17
	db $0C
	db $F9
	db $3B
	db $00
	db $00
	db $77
	db $7E
	db $03
	db $04
	db $83
	db $E6
	db $00
	db $00
	db $9C
	db $41
	db $06
	db $03
	db $20
	db $08
	db $00
	db $00
	db $CC
	db $F1
	db $01
	db $00
	db $DB
	db $FC
	db $00
	db $00
	db $6A
	db $F5
	db $00
	db $00
	db $B2
	db $ED
	db $00
	db $00
	db $77
	db $D9
	db $01
	db $02
	db $8C
	db $BA
	db $00
	db $00
	db $5A
	db $86
	db $02
	db $07
	db $0B
	db $2F
	db $00
	db $80
	db $96
	db $05
	db $0A
	db $0A
	db $08
	db $D4
	db $80
	db $80
	db $67
	db $1E
	db $0C
	db $00
	db $00
	db $00
	db $00
	db $00
	db $A0
	db $01
	db $00
	db $00
	db $03
	db $70
	db $00
	db $00
	db $F4
	db $03
	db $00
	db $00
	db $02
	db $22
	db $00
	db $00
	db $27
	db $02
	db $03
	db $04
	db $83
	db $67
	db $80
	db $C0
	db $C9
	db $F5
	db $05
	db $03
	db $3E
	db $4E
	db $C0
	db $C0
	db $9D
	db $DF
	db $00
	db $01
	db $20
	db $F9
	db $80
	db $00
	db $67
	db $90
	db $01
	db $00
	db $C8
	db $02
	db $00
	db $00
	db $73
	db $7C
	db $00
	db $00
	db $36
	db $FF
	db $00
	db $80
	db $5A
	db $3D
	db $00
	db $00
	db $2C
	db $BB
	db $40
	db $C0
	db $5D
	db $76
	db $00
	db $00
	db $A3
	db $2E
	db $80
	db $80
	db $96
	db $A1
	db $00
	db $01
	db $C2
	db $CB
	db $C0
	db $A0
	db $65
	db $81
	db $02
	db $02
	db $82
	db $35
	db $20
	db $E0
	db $99
	db $07
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $68
	db $00
	db $00
	db $00
	db $00
	db $DC
	db $00
	db $00
	db $FD
	db $00
	db $00
	db $00
	db $00
	db $88
	db $80
	db $C0
	db $89
	db $C0
	db $00
	db $01
	db $20
	db $D9
	db $E0
	db $70
	db $72
	db $7D
	db $01
	db $00
	db $CF
	db $93
	db $B0
	db $70
	db $E7
	db $37
	db $00
	db $00
	db $48
	db $3E
	db $60
	db $C0
	db $19
	db $64
	db $00
	db $00
	db $32
	db $00
	db $80
	db $C0
	db $1C
	db $1F
	db $00
	db $00
	db $0D
	db $BF
	db $C0
	db $A0
	db $56
	db $0F
	db $00
	db $00
	db $0B
	db $2E
	db $D0
	db $70
	db $97
	db $1D
	db $00
	db $00
	db $28
	db $CB
	db $A0
	db $A0
	db $65
	db $28
	db $00
	db $00
	db $70
	db $B2
	db $F0
	db $68
	db $59
	db $A0
	db $00
	db $00
	db $A0
	db $8D
	db $48
	db $78
	db $E6
	db $C1
	db $00

gfx_MaskMortarGuyLeft:
	db $FF
	db $C0
	db $FF
	db $FF
	db $FF
	db $3F
	db $80
	db $FF
	db $FF
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $CF
	db $87
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $00
	db $00
	db $00
	db $01
	db $FF
	db $FF
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $80
	db $80
	db $00
	db $01
	db $FF
	db $FF
	db $03
	db $00
	db $80
	db $C0
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $E0
	db $F0
	db $00
	db $03
	db $FF
	db $FF
	db $01
	db $00
	db $F0
	db $F0
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $E0
	db $C0
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $C0
	db $80
	db $00
	db $00
	db $FF
	db $7F
	db $00
	db $80
	db $01
	db $01
	db $00
	db $00
	db $7F
	db $7F
	db $00
	db $00
	db $02
	db $FF
	db $F0
	db $3F
	db $FF
	db $FF
	db $0F
	db $E0
	db $FF
	db $FF
	db $C0
	db $07
	db $FF
	db $FF
	db $03
	db $C0
	db $F3
	db $E1
	db $C0
	db $01
	db $FF
	db $FF
	db $00
	db $00
	db $C0
	db $80
	db $00
	db $00
	db $7F
	db $3F
	db $00
	db $00
	db $80
	db $C0
	db $00
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $E0
	db $E0
	db $00
	db $00
	db $7F
	db $FF
	db $00
	db $00
	db $E0
	db $F0
	db $00
	db $01
	db $FF
	db $FF
	db $00
	db $00
	db $F8
	db $FC
	db $00
	db $00
	db $FF
	db $7F
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $F8
	db $F0
	db $00
	db $00
	db $7F
	db $7F
	db $00
	db $00
	db $F0
	db $E0
	db $00
	db $00
	db $3F
	db $1F
	db $00
	db $60
	db $C0
	db $C0
	db $40
	db $00
	db $1F
	db $1F
	db $00
	db $80
	db $C0
	db $FF
	db $FC
	db $0F
	db $FF
	db $FF
	db $03
	db $F8
	db $FF
	db $FF
	db $F0
	db $01
	db $FF
	db $FF
	db $00
	db $F0
	db $FC
	db $F8
	db $70
	db $00
	db $7F
	db $3F
	db $00
	db $00
	db $F0
	db $E0
	db $00
	db $00
	db $1F
	db $0F
	db $00
	db $00
	db $E0
	db $F0
	db $00
	db $00
	db $0F
	db $0F
	db $00
	db $00
	db $F8
	db $F8
	db $00
	db $00
	db $1F
	db $3F
	db $00
	db $00
	db $F8
	db $FC
	db $00
	db $00
	db $7F
	db $3F
	db $00
	db $00
	db $FE
	db $FF
	db $00
	db $00
	db $3F
	db $1F
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $0F
	db $0F
	db $00
	db $00
	db $FE
	db $FC
	db $00
	db $00
	db $1F
	db $1F
	db $00
	db $00
	db $FC
	db $F8
	db $00
	db $00
	db $0F
	db $07
	db $00
	db $18
	db $F0
	db $F0
	db $10
	db $00
	db $07
	db $07
	db $00
	db $20
	db $F0
	db $FF
	db $FF
	db $03
	db $FF
	db $FF
	db $00
	db $FE
	db $FF
	db $FF
	db $FC
	db $00
	db $7F
	db $3F
	db $00
	db $3C
	db $FF
	db $FE
	db $1C
	db $00
	db $1F
	db $0F
	db $00
	db $00
	db $FC
	db $F8
	db $00
	db $00
	db $07
	db $03
	db $00
	db $00
	db $F8
	db $FC
	db $00
	db $00
	db $03
	db $03
	db $00
	db $00
	db $FE
	db $FE
	db $00
	db $00
	db $07
	db $0F
	db $00
	db $00
	db $FE
	db $FF
	db $00
	db $00
	db $1F
	db $0F
	db $00
	db $80
	db $FF
	db $FF
	db $C0
	db $00
	db $0F
	db $07
	db $00
	db $C0
	db $FF
	db $FF
	db $C0
	db $00
	db $03
	db $03
	db $00
	db $80
	db $FF
	db $FF
	db $00
	db $00
	db $07
	db $07
	db $00
	db $00
	db $FF
	db $FE
	db $00
	db $00
	db $03
	db $01
	db $00
	db $06
	db $FC
	db $FC
	db $04
	db $00
	db $01
	db $01
	db $00
	db $08
	db $FC

gfx_MortarGuyRight:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $58
	db $00
	db $00
	db $EC
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $02
	db $04
	db $44
	db $00
	db $00
	db $00
	db $0C
	db $44
	db $0E
	db $1E
	db $6C
	db $12
	db $00
	db $00
	db $FA
	db $3A
	db $39
	db $37
	db $27
	db $CC
	db $00
	db $00
	db $B0
	db $9F
	db $3B
	db $19
	db $F0
	db $48
	db $00
	db $00
	db $98
	db $60
	db $0E
	db $04
	db $01
	db $30
	db $00
	db $00
	db $E0
	db $E3
	db $0C
	db $0F
	db $F6
	db $C0
	db $00
	db $00
	db $C0
	db $AB
	db $15
	db $2D
	db $D3
	db $40
	db $00
	db $00
	db $E0
	db $A6
	db $3B
	db $17
	db $4C
	db $50
	db $00
	db $00
	db $50
	db $98
	db $16
	db $3D
	db $34
	db $38
	db $00
	db $00
	db $14
	db $68
	db $5A
	db $4A
	db $C4
	db $14
	db $00
	db $00
	db $0C
	db $9E
	db $79
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $16
	db $00
	db $00
	db $3B
	db $00
	db $00
	db $00
	db $00
	db $BF
	db $00
	db $01
	db $11
	db $00
	db $00
	db $00
	db $03
	db $91
	db $03
	db $07
	db $9B
	db $04
	db $80
	db $80
	db $BE
	db $4E
	db $0E
	db $0D
	db $C9
	db $F3
	db $00
	db $00
	db $EC
	db $E7
	db $0E
	db $06
	db $7C
	db $12
	db $00
	db $00
	db $26
	db $98
	db $03
	db $01
	db $00
	db $4C
	db $00
	db $00
	db $F8
	db $38
	db $03
	db $03
	db $FD
	db $B0
	db $00
	db $00
	db $F0
	db $6A
	db $05
	db $0B
	db $74
	db $D0
	db $00
	db $00
	db $B8
	db $E9
	db $0E
	db $05
	db $D3
	db $14
	db $00
	db $00
	db $14
	db $A6
	db $05
	db $0F
	db $4D
	db $0E
	db $00
	db $00
	db $05
	db $9A
	db $16
	db $12
	db $B1
	db $05
	db $00
	db $00
	db $83
	db $67
	db $1E
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $05
	db $00
	db $00
	db $0E
	db $C0
	db $00
	db $00
	db $C0
	db $2F
	db $00
	db $00
	db $44
	db $40
	db $00
	db $C0
	db $40
	db $E4
	db $00
	db $01
	db $E6
	db $C1
	db $20
	db $A0
	db $AF
	db $93
	db $03
	db $03
	db $72
	db $7C
	db $C0
	db $00
	db $FB
	db $B9
	db $03
	db $01
	db $9F
	db $04
	db $80
	db $80
	db $09
	db $E6
	db $00
	db $00
	db $40
	db $13
	db $00
	db $00
	db $3E
	db $CE
	db $00
	db $00
	db $FF
	db $6C
	db $00
	db $00
	db $BC
	db $5A
	db $01
	db $02
	db $DD
	db $34
	db $00
	db $00
	db $6E
	db $BA
	db $03
	db $01
	db $74
	db $C5
	db $00
	db $00
	db $85
	db $69
	db $01
	db $03
	db $D3
	db $43
	db $80
	db $40
	db $81
	db $A6
	db $05
	db $04
	db $AC
	db $41
	db $40
	db $C0
	db $E0
	db $99
	db $07
	db $00
	db $00
	db $00
	db $00
	db $00
	db $60
	db $01
	db $00
	db $00
	db $03
	db $B0
	db $00
	db $00
	db $F0
	db $0B
	db $00
	db $00
	db $11
	db $10
	db $00
	db $30
	db $10
	db $39
	db $00
	db $00
	db $79
	db $B0
	db $48
	db $E8
	db $EB
	db $E4
	db $00
	db $00
	db $DC
	db $9F
	db $30
	db $C0
	db $7E
	db $EE
	db $00
	db $00
	db $67
	db $C1
	db $20
	db $60
	db $82
	db $39
	db $00
	db $00
	db $10
	db $04
	db $C0
	db $80
	db $8F
	db $33
	db $00
	db $00
	db $3F
	db $DB
	db $00
	db $00
	db $AF
	db $56
	db $00
	db $00
	db $B7
	db $4D
	db $00
	db $80
	db $9B
	db $EE
	db $00
	db $00
	db $5D
	db $31
	db $40
	db $40
	db $61
	db $5A
	db $00
	db $00
	db $F4
	db $D0
	db $E0
	db $50
	db $A0
	db $69
	db $01
	db $01
	db $2B
	db $10
	db $50
	db $30
	db $78
	db $E6
	db $01

gfx_MaskMortarGuyRight:
	db $FF
	db $03
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $FC
	db $F8
	db $00
	db $FF
	db $FF
	db $FF
	db $F3
	db $00
	db $F0
	db $E0
	db $00
	db $E1
	db $FF
	db $FF
	db $00
	db $00
	db $C0
	db $80
	db $00
	db $00
	db $7F
	db $7F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $FF
	db $01
	db $00
	db $00
	db $80
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $C0
	db $E0
	db $00
	db $03
	db $FF
	db $FF
	db $07
	db $00
	db $C0
	db $C0
	db $00
	db $0F
	db $FF
	db $FF
	db $0F
	db $00
	db $80
	db $00
	db $00
	db $0F
	db $FF
	db $FF
	db $07
	db $00
	db $00
	db $80
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $00
	db $80
	db $00
	db $00
	db $01
	db $FF
	db $FF
	db $80
	db $01
	db $00
	db $00
	db $00
	db $80
	db $FF
	db $FF
	db $40
	db $00
	db $00
	db $FF
	db $C0
	db $FF
	db $FF
	db $FF
	db $7F
	db $00
	db $FF
	db $FE
	db $00
	db $3F
	db $FF
	db $FF
	db $3C
	db $00
	db $FC
	db $F8
	db $00
	db $38
	db $7F
	db $3F
	db $00
	db $00
	db $F0
	db $E0
	db $00
	db $00
	db $1F
	db $1F
	db $00
	db $00
	db $C0
	db $C0
	db $00
	db $00
	db $3F
	db $7F
	db $00
	db $00
	db $C0
	db $E0
	db $00
	db $00
	db $7F
	db $7F
	db $00
	db $00
	db $F0
	db $F8
	db $00
	db $00
	db $FF
	db $FF
	db $01
	db $00
	db $F0
	db $F0
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $00
	db $E0
	db $C0
	db $00
	db $03
	db $FF
	db $FF
	db $01
	db $00
	db $C0
	db $E0
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $E0
	db $C0
	db $00
	db $00
	db $7F
	db $3F
	db $60
	db $00
	db $80
	db $80
	db $00
	db $20
	db $3F
	db $3F
	db $10
	db $00
	db $80
	db $FF
	db $F0
	db $3F
	db $FF
	db $FF
	db $1F
	db $C0
	db $FF
	db $FF
	db $80
	db $0F
	db $FF
	db $3F
	db $0F
	db $00
	db $FF
	db $FE
	db $00
	db $0E
	db $1F
	db $0F
	db $00
	db $00
	db $FC
	db $F8
	db $00
	db $00
	db $07
	db $07
	db $00
	db $00
	db $F0
	db $F0
	db $00
	db $00
	db $0F
	db $1F
	db $00
	db $00
	db $F0
	db $F8
	db $00
	db $00
	db $1F
	db $1F
	db $00
	db $00
	db $FC
	db $FE
	db $00
	db $00
	db $3F
	db $7F
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $F8
	db $F0
	db $00
	db $00
	db $FF
	db $7F
	db $00
	db $00
	db $F0
	db $F8
	db $00
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $F8
	db $F0
	db $00
	db $00
	db $1F
	db $0F
	db $18
	db $00
	db $E0
	db $E0
	db $00
	db $08
	db $0F
	db $0F
	db $04
	db $00
	db $E0
	db $FF
	db $FC
	db $0F
	db $FF
	db $FF
	db $07
	db $F0
	db $FF
	db $FF
	db $E0
	db $03
	db $FF
	db $CF
	db $03
	db $C0
	db $FF
	db $FF
	db $80
	db $03
	db $87
	db $03
	db $00
	db $00
	db $FF
	db $FE
	db $00
	db $00
	db $01
	db $01
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $00
	db $03
	db $07
	db $00
	db $00
	db $FC
	db $FE
	db $00
	db $00
	db $07
	db $07
	db $00
	db $00
	db $FF
	db $FF
	db $80
	db $00
	db $0F
	db $1F
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $FE
	db $FC
	db $00
	db $00
	db $3F
	db $1F
	db $00
	db $00
	db $FC
	db $FE
	db $00
	db $00
	db $0F
	db $0F
	db $00
	db $00
	db $FE
	db $FC
	db $00
	db $00
	db $07
	db $03
	db $06
	db $00
	db $F8
	db $F8
	db $00
	db $02
	db $03
	db $03
	db $01
	db $00
	db $F8

gfx_BaddyKickLeft:
	db $00
	db $03
	db $E0
	db $00
	db $00
	db $30
	db $05
	db $00
	db $00
	db $05
	db $38
	db $00
	db $00
	db $E4
	db $06
	db $00
	db $00
	db $04
	db $44
	db $00
	db $00
	db $8C
	db $DE
	db $00
	db $01
	db $23
	db $14
	db $00
	db $00
	db $62
	db $6B
	db $01
	db $00
	db $FF
	db $A6
	db $00
	db $00
	db $F2
	db $02
	db $00
	db $00
	db $07
	db $72
	db $00
	db $00
	db $E2
	db $0D
	db $00
	db $20
	db $3A
	db $C6
	db $00
	db $00
	db $AC
	db $D3
	db $31
	db $3F
	db $DF
	db $1C
	db $00
	db $00
	db $90
	db $DB
	db $1F
	db $1F
	db $2F
	db $FC
	db $00
	db $00
	db $BC
	db $0B
	db $08
	db $00
	db $0F
	db $BE
	db $00
	db $00
	db $C6
	db $01
	db $00
	db $00
	db $00
	db $02
	db $00
	db $00
	db $02
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $F8
	db $00
	db $00
	db $4C
	db $01
	db $00
	db $00
	db $01
	db $4E
	db $00
	db $00
	db $B9
	db $01
	db $00
	db $00
	db $01
	db $11
	db $00
	db $00
	db $A3
	db $37
	db $00
	db $00
	db $48
	db $C5
	db $00
	db $80
	db $D8
	db $5A
	db $00
	db $00
	db $3F
	db $E9
	db $80
	db $80
	db $BC
	db $00
	db $00
	db $00
	db $01
	db $DC
	db $80
	db $80
	db $78
	db $03
	db $00
	db $08
	db $0E
	db $B1
	db $80
	db $00
	db $EB
	db $74
	db $0C
	db $0F
	db $F7
	db $C7
	db $00
	db $00
	db $E4
	db $F6
	db $07
	db $07
	db $CB
	db $FF
	db $00
	db $00
	db $EF
	db $02
	db $02
	db $00
	db $03
	db $EF
	db $80
	db $80
	db $71
	db $00
	db $00
	db $00
	db $00
	db $00
	db $80
	db $80
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $3E
	db $00
	db $00
	db $53
	db $00
	db $00
	db $00
	db $00
	db $53
	db $80
	db $40
	db $6E
	db $00
	db $00
	db $00
	db $00
	db $44
	db $40
	db $C0
	db $E8
	db $0D
	db $00
	db $00
	db $12
	db $31
	db $40
	db $20
	db $B6
	db $16
	db $00
	db $00
	db $0F
	db $FA
	db $60
	db $20
	db $2F
	db $00
	db $00
	db $00
	db $00
	db $77
	db $20
	db $20
	db $DE
	db $00
	db $00
	db $02
	db $03
	db $AC
	db $60
	db $C0
	db $3A
	db $1D
	db $03
	db $03
	db $FD
	db $F1
	db $C0
	db $00
	db $B9
	db $FD
	db $01
	db $01
	db $F2
	db $FF
	db $C0
	db $C0
	db $BB
	db $80
	db $00
	db $00
	db $00
	db $FB
	db $E0
	db $60
	db $1C
	db $00
	db $00
	db $00
	db $00
	db $00
	db $20
	db $20
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0F
	db $80
	db $C0
	db $14
	db $00
	db $00
	db $00
	db $00
	db $14
	db $E0
	db $90
	db $1B
	db $00
	db $00
	db $00
	db $00
	db $11
	db $10
	db $30
	db $7A
	db $03
	db $00
	db $00
	db $04
	db $8C
	db $50
	db $88
	db $AD
	db $05
	db $00
	db $00
	db $03
	db $FE
	db $98
	db $C8
	db $0B
	db $00
	db $00
	db $00
	db $00
	db $1D
	db $C8
	db $88
	db $37
	db $00
	db $00
	db $00
	db $80
	db $EB
	db $18
	db $B0
	db $4E
	db $C7
	db $00
	db $00
	db $FF
	db $7C
	db $70
	db $40
	db $6E
	db $7F
	db $00
	db $00
	db $7C
	db $BF
	db $F0
	db $F0
	db $2E
	db $20
	db $00
	db $00
	db $00
	db $3E
	db $F8
	db $18
	db $07
	db $00
	db $00
	db $00
	db $00
	db $00
	db $08
	db $08
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

gfx_MaskKickLeft:
	db $FF
	db $F8
	db $0F
	db $FF
	db $FF
	db $07
	db $F0
	db $FF
	db $FF
	db $F0
	db $03
	db $FF
	db $FF
	db $01
	db $F0
	db $FF
	db $FF
	db $20
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $FE
	db $FC
	db $00
	db $01
	db $FF
	db $FF
	db $00
	db $00
	db $FC
	db $FE
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $FF
	db $FF
	db $F0
	db $00
	db $FF
	db $FF
	db $00
	db $C0
	db $DF
	db $8E
	db $00
	db $00
	db $FF
	db $FF
	db $01
	db $00
	db $80
	db $80
	db $00
	db $01
	db $FF
	db $FF
	db $03
	db $00
	db $C0
	db $C0
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $C0
	db $E0
	db $F7
	db $E0
	db $00
	db $FF
	db $FF
	db $00
	db $F0
	db $FF
	db $FF
	db $FE
	db $38
	db $FF
	db $FF
	db $F8
	db $FF
	db $FF
	db $FF
	db $FF
	db $FD
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FE
	db $03
	db $FF
	db $FF
	db $01
	db $FC
	db $FF
	db $FF
	db $FC
	db $00
	db $FF
	db $7F
	db $00
	db $FC
	db $FF
	db $FF
	db $C8
	db $00
	db $7F
	db $7F
	db $00
	db $80
	db $FF
	db $FF
	db $00
	db $00
	db $7F
	db $3F
	db $00
	db $00
	db $FF
	db $FF
	db $80
	db $00
	db $3F
	db $3F
	db $00
	db $C0
	db $FF
	db $FF
	db $FC
	db $00
	db $3F
	db $3F
	db $00
	db $F0
	db $F7
	db $E3
	db $80
	db $00
	db $3F
	db $7F
	db $00
	db $00
	db $E0
	db $E0
	db $00
	db $00
	db $7F
	db $FF
	db $00
	db $00
	db $F0
	db $F0
	db $00
	db $00
	db $7F
	db $7F
	db $00
	db $30
	db $F8
	db $FD
	db $F8
	db $00
	db $3F
	db $3F
	db $00
	db $FC
	db $FF
	db $FF
	db $FF
	db $8E
	db $3F
	db $3F
	db $FE
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $7F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $80
	db $FF
	db $7F
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $3F
	db $1F
	db $00
	db $FF
	db $FF
	db $FF
	db $F2
	db $00
	db $1F
	db $1F
	db $00
	db $E0
	db $FF
	db $FF
	db $C0
	db $00
	db $1F
	db $0F
	db $00
	db $C0
	db $FF
	db $FF
	db $E0
	db $00
	db $0F
	db $0F
	db $00
	db $F0
	db $FF
	db $FF
	db $FF
	db $00
	db $0F
	db $0F
	db $00
	db $FC
	db $FD
	db $F8
	db $E0
	db $00
	db $0F
	db $1F
	db $00
	db $00
	db $F8
	db $F8
	db $00
	db $00
	db $1F
	db $3F
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $00
	db $1F
	db $1F
	db $00
	db $0C
	db $FE
	db $FF
	db $7E
	db $00
	db $0F
	db $0F
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $E3
	db $8F
	db $8F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $DF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $E0
	db $3F
	db $1F
	db $C0
	db $FF
	db $FF
	db $FF
	db $FF
	db $C0
	db $0F
	db $07
	db $C0
	db $FF
	db $FF
	db $FF
	db $FC
	db $80
	db $07
	db $07
	db $00
	db $F8
	db $FF
	db $FF
	db $F0
	db $00
	db $07
	db $03
	db $00
	db $F0
	db $FF
	db $FF
	db $F8
	db $00
	db $03
	db $03
	db $00
	db $FC
	db $FF
	db $FF
	db $FF
	db $C0
	db $03
	db $03
	db $00
	db $7F
	db $FF
	db $FE
	db $38
	db $00
	db $03
	db $07
	db $00
	db $00
	db $FE
	db $FE
	db $00
	db $00
	db $07
	db $0F
	db $00
	db $00
	db $FF
	db $FF
	db $00
	db $00
	db $07
	db $07
	db $00
	db $83
	db $FF
	db $FF
	db $DF
	db $80
	db $03
	db $03
	db $C0
	db $FF
	db $FF
	db $FF
	db $FF
	db $F8
	db $E3
	db $E3
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $F7
	db $FF
	db $FF
	db $FF
	db $FF

gfx_BaddyClimb:
	db $00
	db $1C
	db $C0
	db $00
	db $00
	db $20
	db $3F
	db $00
	db $00
	db $3F
	db $20
	db $00
	db $00
	db $90
	db $FD
	db $00
	db $01
	db $81
	db $10
	db $00
	db $00
	db $90
	db $18
	db $01
	db $03
	db $9B
	db $E0
	db $00
	db $00
	db $00
	db $D9
	db $02
	db $02
	db $DB
	db $00
	db $00
	db $00
	db $00
	db $42
	db $02
	db $03
	db $FC
	db $00
	db $00
	db $00
	db $00
	db $BE
	db $01
	db $03
	db $7E
	db $00
	db $00
	db $00
	db $00
	db $FE
	db $02
	db $02
	db $EE
	db $00
	db $00
	db $00
	db $00
	db $CC
	db $02
	db $01
	db $6E
	db $00
	db $00
	db $00
	db $00
	db $9E
	db $00
	db $00
	db $9E
	db $00
	db $00
	db $00
	db $00
	db $3E
	db $01
	db $00
	db $DE
	db $00
	db $00
	db $00
	db $00
	db $12
	db $00
	db $00
	db $12
	db $00
	db $00
	db $00
	db $00
	db $1E
	db $00
	db $00
	db $07
	db $30
	db $00
	db $00
	db $C8
	db $0F
	db $00
	db $00
	db $0F
	db $C8
	db $00
	db $00
	db $64
	db $3F
	db $00
	db $00
	db $60
	db $44
	db $00
	db $00
	db $24
	db $46
	db $00
	db $00
	db $E6
	db $F8
	db $00
	db $00
	db $40
	db $B6
	db $00
	db $00
	db $B6
	db $C0
	db $00
	db $00
	db $80
	db $90
	db $00
	db $00
	db $FF
	db $00
	db $00
	db $00
	db $80
	db $6F
	db $00
	db $00
	db $DF
	db $80
	db $00
	db $00
	db $80
	db $BF
	db $00
	db $00
	db $BB
	db $80
	db $00
	db $00
	db $00
	db $B3
	db $00
	db $00
	db $5B
	db $80
	db $00
	db $00
	db $80
	db $27
	db $00
	db $00
	db $27
	db $80
	db $00
	db $00
	db $80
	db $4F
	db $00
	db $00
	db $37
	db $80
	db $00
	db $00
	db $80
	db $04
	db $00
	db $00
	db $04
	db $80
	db $00
	db $00
	db $80
	db $07
	db $00
	db $00
	db $33
	db $80
	db $00
	db $00
	db $C0
	db $4F
	db $00
	db $00
	db $4F
	db $C0
	db $00
	db $00
	db $F0
	db $9B
	db $00
	db $00
	db $88
	db $18
	db $00
	db $00
	db $88
	db $91
	db $00
	db $00
	db $7D
	db $9C
	db $00
	db $00
	db $B4
	db $09
	db $00
	db $00
	db $0D
	db $B4
	db $00
	db $00
	db $24
	db $04
	db $00
	db $00
	db $03
	db $FC
	db $00
	db $00
	db $D8
	db $07
	db $00
	db $00
	db $07
	db $EC
	db $00
	db $00
	db $F4
	db $07
	db $00
	db $00
	db $07
	db $74
	db $00
	db $00
	db $34
	db $03
	db $00
	db $00
	db $07
	db $68
	db $00
	db $00
	db $90
	db $07
	db $00
	db $00
	db $07
	db $90
	db $00
	db $00
	db $C8
	db $07
	db $00
	db $00
	db $07
	db $B0
	db $00
	db $00
	db $80
	db $04
	db $00
	db $00
	db $04
	db $80
	db $00
	db $00
	db $80
	db $07
	db $00
	db $00
	db $0C
	db $E0
	db $00
	db $00
	db $F0
	db $13
	db $00
	db $00
	db $13
	db $F0
	db $00
	db $00
	db $FC
	db $26
	db $00
	db $00
	db $22
	db $06
	db $00
	db $00
	db $62
	db $24
	db $00
	db $00
	db $1F
	db $67
	db $00
	db $00
	db $6D
	db $02
	db $00
	db $00
	db $03
	db $6D
	db $00
	db $00
	db $09
	db $01
	db $00
	db $00
	db $00
	db $FF
	db $00
	db $00
	db $F6
	db $01
	db $00
	db $00
	db $01
	db $FB
	db $00
	db $00
	db $FD
	db $01
	db $00
	db $00
	db $01
	db $DD
	db $00
	db $00
	db $CD
	db $00
	db $00
	db $00
	db $01
	db $DA
	db $00
	db $00
	db $E4
	db $01
	db $00
	db $00
	db $01
	db $E4
	db $00
	db $00
	db $F2
	db $01
	db $00
	db $00
	db $01
	db $EC
	db $00
	db $00
	db $20
	db $01
	db $00
	db $00
	db $01
	db $20
	db $00
	db $00
	db $E0
	db $01
	db $00

gfx_MaskBaddyClimb:
	db $FF
	db $C0
	db $1F
	db $FF
	db $FF
	db $0F
	db $80
	db $FF
	db $FF
	db $00
	db $0F
	db $FF
	db $FF
	db $07
	db $00
	db $FE
	db $FC
	db $00
	db $07
	db $FF
	db $FF
	db $07
	db $00
	db $FC
	db $F8
	db $00
	db $0F
	db $FF
	db $FF
	db $1F
	db $00
	db $F8
	db $F8
	db $00
	db $7F
	db $FF
	db $FF
	db $FF
	db $00
	db $F8
	db $F8
	db $01
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FC
	db $F8
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $F8
	db $F8
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $01
	db $F8
	db $FC
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FE
	db $FE
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FC
	db $FE
	db $00
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $FF
	db $FF
	db $C0
	db $FF
	db $FF
	db $FF
	db $FF
	db $C0
	db $FF
	db $FF
	db $F0
	db $07
	db $FF
	db $FF
	db $03
	db $E0
	db $FF
	db $FF
	db $C0
	db $03
	db $FF
	db $FF
	db $01
	db $80
	db $FF
	db $FF
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $FF
	db $FE
	db $00
	db $03
	db $FF
	db $FF
	db $07
	db $00
	db $FE
	db $FE
	db $00
	db $1F
	db $FF
	db $FF
	db $3F
	db $00
	db $FE
	db $FE
	db $00
	db $7F
	db $FF
	db $FF
	db $3F
	db $00
	db $FF
	db $FE
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $FE
	db $FE
	db $00
	db $3F
	db $FF
	db $FF
	db $7F
	db $00
	db $FE
	db $FF
	db $00
	db $3F
	db $FF
	db $FF
	db $3F
	db $80
	db $FF
	db $FF
	db $80
	db $3F
	db $FF
	db $FF
	db $3F
	db $00
	db $FF
	db $FF
	db $80
	db $3F
	db $FF
	db $FF
	db $3F
	db $C0
	db $FF
	db $FF
	db $F0
	db $3F
	db $FF
	db $FF
	db $3F
	db $F0
	db $FF
	db $FF
	db $80
	db $3F
	db $FF
	db $FF
	db $1F
	db $00
	db $FF
	db $FF
	db $00
	db $0F
	db $FF
	db $FF
	db $07
	db $00
	db $FE
	db $FE
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $00
	db $FE
	db $FF
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $80
	db $FF
	db $FF
	db $E0
	db $01
	db $FF
	db $FF
	db $01
	db $F0
	db $FF
	db $FF
	db $F8
	db $01
	db $FF
	db $FF
	db $03
	db $F0
	db $FF
	db $FF
	db $F0
	db $01
	db $FF
	db $FF
	db $01
	db $F0
	db $FF
	db $FF
	db $F0
	db $01
	db $FF
	db $FF
	db $01
	db $F8
	db $FF
	db $FF
	db $F0
	db $03
	db $FF
	db $FF
	db $07
	db $F0
	db $FF
	db $FF
	db $F0
	db $07
	db $FF
	db $FF
	db $03
	db $F0
	db $FF
	db $FF
	db $F0
	db $07
	db $FF
	db $FF
	db $0F
	db $F0
	db $FF
	db $FF
	db $F0
	db $3F
	db $FF
	db $FF
	db $3F
	db $F0
	db $FF
	db $FF
	db $E0
	db $0F
	db $FF
	db $FF
	db $07
	db $C0
	db $FF
	db $FF
	db $C0
	db $03
	db $FF
	db $FF
	db $01
	db $80
	db $FF
	db $FF
	db $80
	db $00
	db $FF
	db $FF
	db $00
	db $80
	db $FF
	db $FF
	db $C0
	db $00
	db $7F
	db $7F
	db $00
	db $E0
	db $FF
	db $FF
	db $F8
	db $00
	db $7F
	db $7F
	db $00
	db $FC
	db $FF
	db $FF
	db $FE
	db $00
	db $7F
	db $FF
	db $00
	db $FC
	db $FF
	db $FF
	db $FC
	db $00
	db $7F
	db $7F
	db $00
	db $FC
	db $FF
	db $FF
	db $FC
	db $00
	db $7F
	db $7F
	db $00
	db $FE
	db $FF
	db $FF
	db $FC
	db $00
	db $FF
	db $FF
	db $01
	db $FC
	db $FF
	db $FF
	db $FC
	db $01
	db $FF
	db $FF
	db $00
	db $FC
	db $FF
	db $FF
	db $FC
	db $01
	db $FF
	db $FF
	db $03
	db $FC
	db $FF
	db $FF
	db $FC
	db $0F
	db $FF
	db $FF
	db $0F
	db $FC
	db $FF

gfx_CommandantRunLeft1:
	db $03
	db $80
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $05
	db $05
	db $30
	db $00
	db $00
	db $00
	db $00
	db $F0
	db $07
	db $05
	db $38
	db $00
	db $00
	db $00
	db $00
	db $6C
	db $04
	db $03
	db $C4
	db $00
	db $00
	db $00
	db $00
	db $82
	db $00
	db $0F
	db $99
	db $00
	db $00
	db $00
	db $00
	db $F1
	db $13
	db $13
	db $CB
	db $00
	db $00
	db $00
	db $00
	db $CE
	db $0C
	db $00
	db $F8
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $01
	db $03
	db $5E
	db $00
	db $00
	db $00
	db $80
	db $AB
	db $02
	db $03
	db $55
	db $60
	db $00
	db $00
	db $F0
	db $FA
	db $06
	db $05
	db $CF
	db $F0
	db $00
	db $00
	db $70
	db $80
	db $06
	db $27
	db $80
	db $10
	db $00
	db $00
	db $10
	db $00
	db $3F
	db $1E
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0E
	db $00
	db $E0
	db $00
	db $00
	db $00
	db $00
	db $78
	db $01
	db $01
	db $4C
	db $00
	db $00
	db $00
	db $00
	db $FC
	db $01
	db $01
	db $4E
	db $00
	db $00
	db $00
	db $00
	db $1B
	db $01
	db $00
	db $F1
	db $00
	db $00
	db $00
	db $80
	db $20
	db $00
	db $03
	db $E6
	db $40
	db $00
	db $00
	db $40
	db $FC
	db $04
	db $04
	db $F2
	db $C0
	db $00
	db $00
	db $80
	db $33
	db $03
	db $00
	db $3E
	db $00
	db $00
	db $00
	db $00
	db $7F
	db $00
	db $00
	db $D7
	db $80
	db $00
	db $00
	db $E0
	db $AA
	db $00
	db $00
	db $D5
	db $58
	db $00
	db $00
	db $BC
	db $BE
	db $01
	db $01
	db $73
	db $FC
	db $00
	db $00
	db $1C
	db $A0
	db $01
	db $09
	db $E0
	db $04
	db $00
	db $00
	db $04
	db $C0
	db $0F
	db $07
	db $80
	db $00
	db $00
	db $00
	db $00
	db $80
	db $03
	db $00
	db $38
	db $00
	db $00
	db $00
	db $00
	db $5E
	db $00
	db $00
	db $53
	db $00
	db $00
	db $00
	db $00
	db $7F
	db $00
	db $00
	db $53
	db $80
	db $00
	db $00
	db $C0
	db $46
	db $00
	db $00
	db $3C
	db $40
	db $00
	db $00
	db $20
	db $08
	db $00
	db $00
	db $F9
	db $90
	db $00
	db $00
	db $10
	db $3F
	db $01
	db $01
	db $3C
	db $B0
	db $00
	db $00
	db $E0
	db $CC
	db $00
	db $00
	db $0F
	db $80
	db $00
	db $00
	db $C0
	db $1F
	db $00
	db $00
	db $35
	db $E0
	db $00
	db $00
	db $B8
	db $2A
	db $00
	db $00
	db $35
	db $56
	db $00
	db $00
	db $AF
	db $6F
	db $00
	db $00
	db $5C
	db $FF
	db $00
	db $00
	db $07
	db $68
	db $00
	db $02
	db $78
	db $01
	db $00
	db $00
	db $01
	db $F0
	db $03
	db $01
	db $E0
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $00
	db $00
	db $0E
	db $00
	db $00
	db $00
	db $80
	db $17
	db $00
	db $00
	db $14
	db $C0
	db $00
	db $00
	db $C0
	db $1F
	db $00
	db $00
	db $14
	db $E0
	db $00
	db $00
	db $B0
	db $11
	db $00
	db $00
	db $0F
	db $10
	db $00
	db $00
	db $08
	db $02
	db $00
	db $00
	db $3E
	db $64
	db $00
	db $00
	db $C4
	db $4F
	db $00
	db $00
	db $4F
	db $2C
	db $00
	db $00
	db $38
	db $33
	db $00
	db $00
	db $03
	db $E0
	db $00
	db $00
	db $F0
	db $07
	db $00
	db $00
	db $0D
	db $78
	db $00
	db $00
	db $AE
	db $0A
	db $00
	db $00
	db $0D
	db $55
	db $80
	db $C0
	db $EB
	db $1B
	db $00
	db $00
	db $17
	db $3F
	db $C0
	db $C0
	db $01
	db $1A
	db $00
	db $00
	db $9E
	db $00
	db $40
	db $40
	db $00
	db $FC
	db $00
	db $00
	db $78
	db $00
	db $00
	db $00
	db $00
	db $38
	db $00

gfx_CommandantRunLeft2:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $01
	db $02
	db $F0
	db $00
	db $00
	db $00
	db $00
	db $98
	db $02
	db $03
	db $F8
	db $00
	db $00
	db $00
	db $00
	db $9E
	db $02
	db $02
	db $21
	db $00
	db $00
	db $00
	db $80
	db $C0
	db $01
	db $00
	db $CC
	db $80
	db $00
	db $00
	db $80
	db $E4
	db $01
	db $0F
	db $FC
	db $80
	db $00
	db $00
	db $00
	db $F3
	db $13
	db $12
	db $32
	db $00
	db $00
	db $00
	db $00
	db $3E
	db $0C
	db $00
	db $6E
	db $00
	db $00
	db $00
	db $00
	db $76
	db $00
	db $00
	db $6A
	db $00
	db $00
	db $00
	db $00
	db $76
	db $00
	db $00
	db $7B
	db $00
	db $00
	db $00
	db $80
	db $3D
	db $00
	db $00
	db $1F
	db $80
	db $00
	db $00
	db $C0
	db $0D
	db $00
	db $00
	db $0D
	db $C0
	db $00
	db $00
	db $C0
	db $1B
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $70
	db $00
	db $00
	db $BC
	db $00
	db $00
	db $00
	db $00
	db $A6
	db $00
	db $00
	db $FE
	db $00
	db $00
	db $00
	db $80
	db $A7
	db $00
	db $00
	db $88
	db $40
	db $00
	db $00
	db $20
	db $70
	db $00
	db $00
	db $33
	db $20
	db $00
	db $00
	db $20
	db $79
	db $00
	db $03
	db $FF
	db $20
	db $00
	db $00
	db $C0
	db $FC
	db $04
	db $04
	db $8C
	db $80
	db $00
	db $00
	db $80
	db $0F
	db $03
	db $00
	db $1B
	db $80
	db $00
	db $00
	db $80
	db $1D
	db $00
	db $00
	db $1A
	db $80
	db $00
	db $00
	db $80
	db $1D
	db $00
	db $00
	db $1E
	db $C0
	db $00
	db $00
	db $60
	db $0F
	db $00
	db $00
	db $07
	db $E0
	db $00
	db $00
	db $70
	db $03
	db $00
	db $00
	db $03
	db $70
	db $00
	db $00
	db $F0
	db $06
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $1C
	db $00
	db $00
	db $2F
	db $00
	db $00
	db $00
	db $80
	db $29
	db $00
	db $00
	db $3F
	db $80
	db $00
	db $00
	db $E0
	db $29
	db $00
	db $00
	db $22
	db $10
	db $00
	db $00
	db $08
	db $1C
	db $00
	db $00
	db $0C
	db $C8
	db $00
	db $00
	db $48
	db $1E
	db $00
	db $00
	db $FF
	db $C8
	db $00
	db $00
	db $30
	db $3F
	db $01
	db $01
	db $23
	db $20
	db $00
	db $00
	db $E0
	db $C3
	db $00
	db $00
	db $06
	db $E0
	db $00
	db $00
	db $60
	db $07
	db $00
	db $00
	db $06
	db $A0
	db $00
	db $00
	db $60
	db $07
	db $00
	db $00
	db $07
	db $B0
	db $00
	db $00
	db $D8
	db $03
	db $00
	db $00
	db $01
	db $F8
	db $00
	db $00
	db $DC
	db $00
	db $00
	db $00
	db $00
	db $DC
	db $00
	db $00
	db $BC
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $07
	db $00
	db $00
	db $0B
	db $C0
	db $00
	db $00
	db $60
	db $0A
	db $00
	db $00
	db $0F
	db $E0
	db $00
	db $00
	db $78
	db $0A
	db $00
	db $00
	db $08
	db $84
	db $00
	db $00
	db $02
	db $07
	db $00
	db $00
	db $03
	db $32
	db $00
	db $00
	db $92
	db $07
	db $00
	db $00
	db $3F
	db $F2
	db $00
	db $00
	db $CC
	db $4F
	db $00
	db $00
	db $48
	db $C8
	db $00
	db $00
	db $F8
	db $30
	db $00
	db $00
	db $01
	db $B8
	db $00
	db $00
	db $D8
	db $01
	db $00
	db $00
	db $01
	db $A8
	db $00
	db $00
	db $D8
	db $01
	db $00
	db $00
	db $01
	db $EC
	db $00
	db $00
	db $F6
	db $00
	db $00
	db $00
	db $00
	db $7E
	db $00
	db $00
	db $37
	db $00
	db $00
	db $00
	db $00
	db $37
	db $00
	db $00
	db $6F
	db $00
	db $00

gfx_ExplosionSmall:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $01
	db $00
	db $00
	db $32
	db $10
	db $00
	db $00
	db $08
	db $4C
	db $00
	db $00
	db $86
	db $08
	db $00
	db $00
	db $08
	db $80
	db $00
	db $00
	db $C0
	db $0E
	db $00
	db $00
	db $11
	db $20
	db $01
	db $01
	db $00
	db $91
	db $00
	db $00
	db $21
	db $C1
	db $00
	db $00
	db $43
	db $E1
	db $00
	db $00
	db $E2
	db $E1
	db $00
	db $00
	db $83
	db $F1
	db $00
	db $80
	db $C0
	db $84
	db $00
	db $00
	db $80
	db $80
	db $80
	db $80
	db $88
	db $70
	db $00
	db $00
	db $10
	db $15
	db $00
	db $00
	db $1E
	db $12
	db $00
	db $00
	db $0E
	db $10
	db $00
	db $00
	db $30
	db $03
	db $00
	db $00
	db $01
	db $E0
	db $00
	db $00
	db $00
	db $00
	db $00

gfx_MaskExplosionSmall:
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FE
	db $1F
	db $FF
	db $FF
	db $0F
	db $CC
	db $FF
	db $FF
	db $80
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $FF
	db $FE
	db $00
	db $03
	db $FF
	db $FF
	db $01
	db $00
	db $FE
	db $FE
	db $00
	db $00
	db $FF
	db $7F
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $00
	db $7F
	db $7F
	db $00
	db $00
	db $FE
	db $FF
	db $00
	db $00
	db $7F
	db $FF
	db $00
	db $00
	db $FE
	db $FE
	db $00
	db $00
	db $7F
	db $3F
	db $00
	db $00
	db $FE
	db $FE
	db $00
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $FF
	db $FF
	db $80
	db $00
	db $7F
	db $FF
	db $00
	db $C0
	db $FF
	db $FF
	db $E0
	db $01
	db $FF
	db $FF
	db $07
	db $F0
	db $FF
	db $FF
	db $FC
	db $0F
	db $FF
	db $FF
	db $1F
	db $FE
	db $FF
	db $00
	db $01
	db $8E
	db $00
	db $00
	db $51
	db $62
	db $00
	db $00
	db $9A
	db $20
	db $80
	db $80
	db $20
	db $8F
	db $00
	db $07
	db $89
	db $00
	db $80
	db $F0
	db $80
	db $C8
	db $08
	db $10
	db $00
	db $01
	db $08
	db $04
	db $80
	db $00
	db $10
	db $20
	db $25
	db $C8
	db $04
	db $04
	db $F8
	db $1F
	db $20
	db $20
	db $1F
	db $F8
	db $04
	db $04
	db $FE
	db $3F
	db $20
	db $10
	db $3F
	db $FC
	db $08
	db $30
	db $FE
	db $7F
	db $10
	db $0C
	db $7F
	db $FF
	db $10
	db $08
	db $FC
	db $1F
	db $06
	db $04
	db $0C
	db $18
	db $04
	db $04
	db $08
	db $08
	db $08
	db $08
	db $00
	db $00
	db $04
	db $08
	db $00
	db $00
	db $08
	db $04
	db $41
	db $02
	db $08
	db $10
	db $07
	db $C1
	db $03
	db $00
	db $47
	db $8C
	db $E0
	db $00
	db $F8
	db $38
	db $00
	db $FF
	db $98
	db $20
	db $FF
	db $7F
	db $00
	db $00
	db $FF
	db $FE
	db $00
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $F8
	db $F0
	db $00
	db $00
	db $0F
	db $07
	db $00
	db $00
	db $E0
	db $C0
	db $00
	db $00
	db $03
	db $01
	db $00
	db $00
	db $C0
	db $80
	db $00
	db $00
	db $01
	db $01
	db $00
	db $00
	db $80
	db $80
	db $00
	db $00
	db $01
	db $01
	db $00
	db $00
	db $80
	db $C0
	db $00
	db $00
	db $03
	db $07
	db $00
	db $00
	db $C0
	db $E0
	db $00
	db $00
	db $07
	db $03
	db $00
	db $00
	db $F0
	db $F0
	db $00
	db $00
	db $01
	db $01
	db $00
	db $00
	db $E0
	db $E0
	db $00
	db $00
	db $01
	db $03
	db $00
	db $00
	db $E0
	db $F0
	db $00
	db $00
	db $03
	db $07
	db $00
	db $00
	db $F8
	db $FC
	db $00
	db $00
	db $0F
	db $1F
	db $03
	db $80
	db $FF

gfx_DogRight:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $FF
	db $1F
	db $00
	db $80
	db $F3
	db $00
	db $03
	db $06
	db $00
	db $24
	db $80
	db $C0
	db $19
	db $00
	db $08
	db $08
	db $00
	db $00
	db $40
	db $40
	db $0E
	db $40
	db $10
	db $10
	db $71
	db $1B
	db $80
	db $00
	db $90
	db $8F
	db $11
	db $22
	db $00
	db $D0
	db $00
	db $00
	db $6C
	db $00
	db $2C
	db $48
	db $00
	db $32
	db $00
	db $00
	db $0D
	db $00
	db $50
	db $70
	db $00
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $67
	db $D5
	db $00
	db $01
	db $2F
	db $99
	db $80
	db $80
	db $79
	db $D5
	db $01
	db $02
	db $55
	db $64
	db $40
	db $40
	db $43
	db $55
	db $04
	db $05
	db $B5
	db $60
	db $80
	db $00
	db $E0
	db $0A
	db $06
	db $08
	db $00
	db $30
	db $00
	db $00
	db $38
	db $00
	db $18
	db $30
	db $00
	db $0C
	db $00
	db $00
	db $02
	db $00
	db $20
	db $60
	db $00
	db $03
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $F0
	db $C1
	db $07
	db $00
	db $00
	db $1C
	db $7F
	db $38
	db $48
	db $02
	db $30
	db $00
	db $00
	db $20
	db $01
	db $9C
	db $04
	db $00
	db $20
	db $00
	db $00
	db $20
	db $80
	db $E4
	db $B8
	db $91
	db $20
	db $00
	db $00
	db $11
	db $E3
	db $00
	db $00
	db $44
	db $11
	db $00
	db $00
	db $0C
	db $98
	db $00
	db $00
	db $B0
	db $04
	db $00
	db $00
	db $02
	db $40
	db $00
	db $00
	db $A0
	db $05
	db $00
	db $00
	db $0B
	db $90
	db $00
	db $00
	db $70
	db $06
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $01
	db $54
	db $70
	db $98
	db $AB
	db $06
	db $00
	db $00
	db $0F
	db $FD
	db $9C
	db $44
	db $AA
	db $16
	db $00
	db $00
	db $12
	db $AA
	db $34
	db $08
	db $B4
	db $13
	db $00
	db $00
	db $0A
	db $EC
	db $00
	db $00
	db $58
	db $06
	db $00
	db $00
	db $03
	db $30
	db $00
	db $00
	db $60
	db $01
	db $00
	db $00
	db $00
	db $80
	db $00
	db $00
	db $40
	db $03
	db $00
	db $00
	db $06
	db $20
	db $00
	db $00
	db $20
	db $04
	db $00

gfx_MaskDogRight:
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $E0
	db $00
	db $FF
	db $FC
	db $00
	db $00
	db $7F
	db $3F
	db $00
	db $00
	db $F8
	db $F0
	db $00
	db $00
	db $3F
	db $1F
	db $00
	db $00
	db $E0
	db $E0
	db $00
	db $00
	db $1F
	db $1F
	db $00
	db $00
	db $C0
	db $C0
	db $00
	db $00
	db $3F
	db $7F
	db $04
	db $00
	db $C0
	db $80
	db $70
	db $03
	db $FF
	db $FF
	db $01
	db $FF
	db $81
	db $03
	db $FF
	db $80
	db $FF
	db $7F
	db $C0
	db $FF
	db $07
	db $07
	db $FF
	db $F0
	db $7F
	db $FF
	db $FC
	db $FF
	db $8F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $2A
	db $98
	db $FF
	db $7F
	db $00
	db $00
	db $FE
	db $FC
	db $00
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $FC
	db $F8
	db $00
	db $00
	db $1F
	db $1F
	db $18
	db $00
	db $F0
	db $F0
	db $00
	db $0C
	db $3F
	db $7F
	db $0F
	db $40
	db $F0
	db $E1
	db $F5
	db $07
	db $FF
	db $FF
	db $83
	db $FF
	db $C3
	db $87
	db $FF
	db $C1
	db $FF
	db $FF
	db $F0
	db $FF
	db $8F
	db $0F
	db $FF
	db $F8
	db $7F
	db $FF
	db $FC
	db $FF
	db $9F
	db $FF
	db $F8
	db $3E
	db $0F
	db $07
	db $00
	db $E0
	db $FF
	db $FF
	db $C0
	db $00
	db $03
	db $03
	db $00
	db $80
	db $FF
	db $FF
	db $80
	db $00
	db $01
	db $01
	db $00
	db $80
	db $FF
	db $FF
	db $80
	db $00
	db $01
	db $03
	db $00
	db $80
	db $FF
	db $FF
	db $C0
	db $00
	db $47
	db $FF
	db $00
	db $C0
	db $FF
	db $FF
	db $E0
	db $03
	db $FF
	db $FF
	db $07
	db $F0
	db $FF
	db $FF
	db $F8
	db $0F
	db $FF
	db $FF
	db $0F
	db $F0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $07
	db $F0
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $8F
	db $AB
	db $FE
	db $FF
	db $FF
	db $F8
	db $00
	db $07
	db $03
	db $00
	db $F0
	db $FF
	db $FF
	db $E0
	db $00
	db $03
	db $01
	db $00
	db $C0
	db $FF
	db $FF
	db $C0
	db $00
	db $81
	db $C3
	db $01
	db $C0
	db $FF
	db $FF
	db $E0
	db $01
	db $F7
	db $FF
	db $03
	db $F0
	db $FF
	db $FF
	db $F8
	db $07
	db $FF
	db $FF
	db $0F
	db $FC
	db $FF
	db $FF
	db $FC
	db $1F
	db $FF
	db $FF
	db $1F
	db $F8
	db $FF
	db $FF
	db $F0
	db $8F
	db $FF
	db $FF
	db $8F
	db $F1
	db $FF

gfx_DogLeft:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $E0
	db $83
	db $0F
	db $1C
	db $FE
	db $38
	db $00
	db $00
	db $0C
	db $40
	db $12
	db $39
	db $80
	db $04
	db $00
	db $00
	db $04
	db $00
	db $20
	db $27
	db $01
	db $04
	db $00
	db $00
	db $04
	db $89
	db $1D
	db $00
	db $C7
	db $88
	db $00
	db $00
	db $88
	db $22
	db $00
	db $00
	db $19
	db $30
	db $00
	db $00
	db $20
	db $0D
	db $00
	db $00
	db $02
	db $40
	db $00
	db $00
	db $A0
	db $05
	db $00
	db $00
	db $09
	db $D0
	db $00
	db $00
	db $60
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $0E
	db $2A
	db $80
	db $00
	db $00
	db $60
	db $D5
	db $19
	db $39
	db $BF
	db $F0
	db $00
	db $00
	db $68
	db $55
	db $22
	db $2C
	db $55
	db $48
	db $00
	db $00
	db $C8
	db $2D
	db $10
	db $00
	db $37
	db $50
	db $00
	db $00
	db $60
	db $1A
	db $00
	db $00
	db $0C
	db $C0
	db $00
	db $00
	db $80
	db $06
	db $00
	db $00
	db $01
	db $00
	db $00
	db $00
	db $C0
	db $02
	db $00
	db $00
	db $04
	db $60
	db $00
	db $00
	db $20
	db $04
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $F8
	db $FF
	db $00
	db $C0
	db $00
	db $CF
	db $01
	db $01
	db $24
	db $00
	db $60
	db $10
	db $00
	db $98
	db $03
	db $02
	db $00
	db $00
	db $10
	db $08
	db $02
	db $70
	db $02
	db $01
	db $D8
	db $8E
	db $08
	db $88
	db $F1
	db $09
	db $00
	db $00
	db $0B
	db $00
	db $44
	db $34
	db $00
	db $36
	db $00
	db $00
	db $4C
	db $00
	db $12
	db $0A
	db $00
	db $B0
	db $00
	db $00
	db $C0
	db $00
	db $0E
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $AB
	db $E6
	db $00
	db $01
	db $99
	db $F4
	db $80
	db $80
	db $AB
	db $9E
	db $01
	db $02
	db $26
	db $AA
	db $40
	db $20
	db $AA
	db $C2
	db $02
	db $01
	db $06
	db $AD
	db $A0
	db $60
	db $50
	db $07
	db $00
	db $00
	db $0C
	db $00
	db $10
	db $18
	db $00
	db $1C
	db $00
	db $00
	db $30
	db $00
	db $0C
	db $04
	db $00
	db $40
	db $00
	db $00
	db $C0
	db $00
	db $06
	db $00
	db $00
	db $00
	db $00

gfx_MaskDogLeft:
	db $F0
	db $7C
	db $1F
	db $FF
	db $FF
	db $07
	db $00
	db $E0
	db $C0
	db $00
	db $03
	db $FF
	db $FF
	db $01
	db $00
	db $C0
	db $80
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $80
	db $80
	db $00
	db $01
	db $FF
	db $FF
	db $01
	db $00
	db $C0
	db $E2
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $00
	db $FF
	db $FF
	db $C0
	db $07
	db $FF
	db $FF
	db $0F
	db $E0
	db $FF
	db $FF
	db $F0
	db $1F
	db $FF
	db $FF
	db $0F
	db $F0
	db $FF
	db $FF
	db $E0
	db $07
	db $FF
	db $FF
	db $0F
	db $E0
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $7F
	db $D5
	db $F1
	db $E0
	db $00
	db $1F
	db $FF
	db $FF
	db $0F
	db $00
	db $C0
	db $C0
	db $00
	db $07
	db $FF
	db $FF
	db $03
	db $00
	db $80
	db $81
	db $00
	db $03
	db $FF
	db $FF
	db $03
	db $80
	db $C3
	db $EF
	db $80
	db $07
	db $FF
	db $FF
	db $0F
	db $C0
	db $FF
	db $FF
	db $E0
	db $1F
	db $FF
	db $FF
	db $3F
	db $F0
	db $FF
	db $FF
	db $F8
	db $3F
	db $FF
	db $FF
	db $1F
	db $F8
	db $FF
	db $FF
	db $F1
	db $0F
	db $FF
	db $FF
	db $8F
	db $F1
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $00
	db $07
	db $FF
	db $FE
	db $00
	db $00
	db $3F
	db $1F
	db $00
	db $00
	db $FC
	db $FC
	db $00
	db $00
	db $0F
	db $07
	db $00
	db $00
	db $F8
	db $F8
	db $00
	db $00
	db $07
	db $03
	db $00
	db $00
	db $F8
	db $FC
	db $00
	db $00
	db $03
	db $03
	db $00
	db $20
	db $FE
	db $FF
	db $C0
	db $0E
	db $01
	db $81
	db $FF
	db $80
	db $FF
	db $FF
	db $01
	db $FF
	db $C0
	db $E0
	db $FF
	db $03
	db $FE
	db $FE
	db $0F
	db $FF
	db $E0
	db $F1
	db $FF
	db $3F
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $FF
	db $19
	db $54
	db $FF
	db $7F
	db $00
	db $00
	db $FE
	db $FC
	db $00
	db $00
	db $3F
	db $3F
	db $00
	db $00
	db $FC
	db $F8
	db $00
	db $00
	db $1F
	db $0F
	db $00
	db $18
	db $F8
	db $FC
	db $30
	db $00
	db $0F
	db $0F
	db $02
	db $F0
	db $FE
	db $FF
	db $E0
	db $AF
	db $87
	db $C3
	db $FF
	db $C1
	db $FF
	db $FF
	db $83
	db $FF
	db $E1
	db $F1
	db $FF
	db $0F
	db $FF
	db $FE
	db $1F
	db $FF
	db $F0
	db $F9
	db $FF
	db $3F
	db $FF

gfx_BaddyLieRight:
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $03
	db $00
	db $00
	db $00
	db $00
	db $07
	db $E0
	db $10
	db $05
	db $00
	db $00
	db $00
	db $00
	db $1F
	db $F0
	db $10
	db $3E
	db $00
	db $00
	db $70
	db $00
	db $F3
	db $10
	db $E0
	db $F1
	db $0D
	db $4E
	db $5B
	db $FE
	db $F1
	db $C0
	db $FE
	db $FA
	db $76
	db $BC
	db $97
	db $8E
	db $FC
	db $69
	db $0E
	db $C6
	db $FD
	db $F0

gfx_MaskBaddyLieRight:
	db $FF
	db $FF
	db $FC
	db $3F
	db $1F
	db $F8
	db $FF
	db $FF
	db $FF
	db $FF
	db $F0
	db $0F
	db $07
	db $E0
	db $FF
	db $FF
	db $FF
	db $FF
	db $C0
	db $07
	db $07
	db $00
	db $FF
	db $8F
	db $01
	db $F2
	db $00
	db $07
	db $0F
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $C0
	db $03
	db $07
	db $E0
	db $00
	db $00
	db $00
	db $00
	db $A0
	db $08
	db $0F
	db $F8
	db $00
	db $00
	db $00
	db $00
	db $7C
	db $08
	db $08
	db $CF
	db $00
	db $0E
	db $72
	db $B0
	db $8F
	db $07
	db $03
	db $8F
	db $7F
	db $DA
	db $3D
	db $6E
	db $5F
	db $7F
	db $96
	db $3F
	db $71
	db $E9
	db $0F
	db $BF
	db $63
	db $70
	db $FC
	db $3F
	db $FF
	db $FF
	db $FF
	db $FF
	db $1F
	db $F8
	db $F0
	db $0F
	db $FF
	db $FF
	db $FF
	db $FF
	db $07
	db $E0
	db $E0
	db $03
	db $FF
	db $FF
	db $F1
	db $FF
	db $00
	db $E0
	db $E0
	db $00
	db $4F
	db $80
	db $00
	db $00
	db $00
	db $F0
	db $80
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $C7
	db $5E
	db $F0
	db $5C
	db $5A
	db $DF
	db $F3
	db $19
	db $02
	db $ED
	db $6F
	db $18
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

;	dw $6441
;	dw $57EC
;	dw $6419
;	dw $6512
;	dw $6530
;	dw $50F0
;	dw $6419
;	dw $6441
;	dw $57F1
;	dw $029B
;	dw $5C4F
;	dw $BB43
;	dw $BA87
;	dw $AF4E
;	dw $090C
;	dw $AAD1
;	dw $A38F
;	dw $A28B
;	dw $A1BE			; play a level
;	db $00

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

	org $FEFE
ISRJumpAddr:
	JP   ISR
	db $00

LineAddresses:
	ds 128, $00

; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Variables:
V_ScrnX:
	db $0E			; SCRNX
V_ScrnY:
	db $00			; SCRNY
V_Direct:
	db $02			; DIRECT
V_Sysflag:
	db $00			; SYSFLAG
	db $00			; TABXPOS
V_Attr:
	db $FF			; ATTR
V_Chars:
	dw $7D00			; CHARS
V_High:
	db $00			; HIGH
RND4:
	db $F6
RND5:
	db $45
RND6:
	db $8D
TriggeredWeapon:
	db $01
StartY:
	db $50
V_TabXPos:
	db $02
	db $00
	db $00
	db $00
V_HasScrolled:
	db $00
V_FrameCounter:
	db $71
Unused:
	db $00			; unused
	db $01			; set to 1, never referenced
	db $00			; unused
	db $00			; unused
MineIndex:
	db $02
MissileTopIndex:
	db $00
TempFUDLR:
	db $09
JumpYIndex:			; index into sine table for jump arc
	db $79
isInAir:			; Jumping or falling
	db $00
JumpStartY:			; store pos of jump to offset sine wave from
	db $90
isSnappedToLadder:
	db $00
JumpSnapY:
	db $B0
PlayerLieDown:			; Holds 8 pixel aligned X pos of the player when lying down
	db $00
PlayerLadderX:
	db $2A
IsStabbing:
	db $00			; flags player is stabbing - also a countdown for how long to stab for
ParachuteGuyTriggered:			; $FF means has been triggered
	db $00
ParachuteGuyTriggerCountdown:
	db $00
LastFUDLR:
	db $00
MortarGuyTriggerCountdown:
	db $00
MortarGuyTriggered:
	db $00
FUDLR:
	db $00
	db $00
WeaponTriggerCountdown:
	db $00
MapTileAddress:
	dw $7748
WhichTileset:			; either the captive's wall or the game level
	db $FF
VertTileCount:
	db $00
MapX:					; Map X position at the right edge of the screen
	dw $01D8
ScrollPixelCounter:
	db $D0
MoveAmountSinceScrollBoundary:			; how many 2 pixels steps has the player made since they hit the scroll boundary. Reset to 6 when moving left.
	db $30
HasWeapon:
	db $00
isShooting:			; holds the weapon number (index) that is shooting (eg flame thrower)
	db $00
WeaponCount:			; number of uses of the "shoot" weapon
	db $00
ScrollBoundary:
	db $68
MortarInFlight:
	db $00
MortarYIndex:
	db $A5
MortarFireCountdown:
	db $07
FlameThrowerActive:			; 0, 1 = active firing right, left.  -ve = inactive
	db $00
FlameThrowerInFlight:
	db $00
ParachuteGuyFlag:
	db $00
NextBaddyCountdown:
	db $11
ExplosionCounter:
	db $00
MaxPlayerX:
	db $C0
EndofLevelTrigger:
	db $00
GrenadeYIndex:
	db $00
GrenadeYStart:
	db $00
GrenadeStartIndex:
	db $00
isGrenadeExploding:
	db $00
GrenadeExplodeX:
	db $00
GrenadeExplodeY:
	db $00
TruckActive:
	db $00
EOLBaddyCountdown:
	db $19
EOLBaddiesRemaining:
	db $00
EOLEndCountdown:
	db $00
EOL2BaddyCountdownTime:
	db $00
EOL2BaddySpawnTime:
	db $00
EOL2SpawnCounter:
	db $00
EOLBaseBaddyCountdown:			; starting count for countdown to next baddy (could have random values added to it - to form BaddyCountdown)
	db $00
isDead:
	db $00
DeathCounter:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
LevelCountdown:
	dw $007B
RND1:
	db $76
RND2:
	db $62
RND3:
	db $F6
LevelNumber:
	db $00
BaddyCountdownTime:
	db $14
RandMask:
	db $07
EOLBaddyCountdownTime:
	db $22
Lives:
	db $01
ControlMethod:
	db $01

	SAVESNA "GreenBeret.sna", GameStart
	

