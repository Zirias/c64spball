.segment "LDADDR"
                .word   $c000

.code

		lda	$d015
		beq	start
stop:
		lda	#>newscreen
		sta	$fc
		lda	#>defscreen
		jsr	cpscreen
		lda	#$97
		sta	$dd00
		lda	#$15
		sta	$d018
		lda	#$0
		sta	$d015
		sta	$d01a
		ldx	#$81
		stx	$dc0d
		ldx	#$31
		stx	$314
		ldx	#$ea
done:		stx	$315
		cli
		ldx	$d6
		jmp	$e9f0

start:
		lda	#>defscreen
		sta	$fc
		lda	#>newscreen
		jsr	cpscreen
		ldx	#$31
		stx	$1
		ldx	#$10
		lda	#$d0
		sta	$fc
cpcharset:	lda	($fb),y
		dec	$1
		sta	($fb),y
		inc	$1
		iny
		bne	cpcharset
		inc	$fc
		dex
		bne	cpcharset
		lda	#$37
		sta	$1
		lda	#$94
		sta	$dd00
		lda	#$35
		sta	$d018
		sta	$d027
		ldx	#$5
		stx	$cff8
		ldx	#$1
		stx	$d015
		stx	$d01a
		stx	$d012
		stx	$fd
		stx	$fe
		ldx	#$18
		stx	$d000
		ldx	#$1b
		stx	$d011
		ldx	#$32
		stx	$d001
		ldx	#$7f
		stx	$dc0d
		ldx	$dc0d
		ldx	$d020
		stx	$fb
		ldx	#<irq
		stx	$314
		ldx	#>irq
		bne	done

cpscreen:
		sta	$fe
		sta	$288
		lda	#$0
		sta	$fb
		sta	$fd
		ldx	#$4
		ldy	#$0
		sei
cps_loop:	lda	($fb),y
		sta	($fd),y
		iny
		bne	cps_loop
		inc	$fc
		inc	$fe
		dex
		bne	cps_loop
		rts

irq:
		ldx	$fb
		stx	$d020
		dec	$d019
		lda	$fd
		beq	toleft
		inc	$d000
		inc	$d000
		bne	rightdone
		inc	$d010
		bne	movey
rightdone:	lda	$d010
		beq	movey
		lda	#$40
		cmp	$d000
		bne	movey
		jsr	flash
		dec	$fd
		beq	movey
toleft:		lda	$d000
		bne	leftstep
		dec	$d010
leftstep:	dec	$d000
		dec	$d000
		lda	$d010
		bne	movey
		lda	#$18
		cmp	$d000
		bne	movey
		jsr	flash
		inc	$fd
movey:		lda	$fe
		beq	toup
		inc	$d001
		inc	$d001
		lda	#$e6
		cmp	$d001
		bne	movedone
		jsr	flash
		dec	$fe
		beq	movedone
toup:		dec	$d001
		dec	$d001
		lda	#$32
		cmp	$d001
		bne	movedone
		jsr	flash
		inc	$fe
movedone:	jmp	$ea31

flash:
		lda	#$1
		sta	$d020
		rts


.segment "SPRITE"

		.byte	$00,$7e,$00
		.byte	$03,$ff,$c0
		.byte	$07,$ff,$e0
		.byte	$1f,$ff,$f8
		.byte	$1f,$ff,$f8
		.byte	$3f,$ff,$fc
		.byte	$7f,$ff,$fe
		.byte	$7f,$ff,$fe
		.byte	$ff,$ff,$ff
		.byte	$ff,$ff,$ff
		.byte	$ff,$ff,$ff
		.byte	$ff,$ff,$ff
		.byte	$7f,$ff,$fe
		.byte	$7f,$ff,$fe
		.byte	$3f,$ff,$fc
		.byte	$1f,$ff,$f8
		.byte	$1f,$ff,$f8
		.byte	$07,$ff,$e0
		.byte	$03,$ff,$c0
		.byte	$00,$7e,$00
		.byte	$00,$00,$00

.segment "DEFSCREEN"

defscreen:	.res	$400

.segment "NEWSCREEN"

newscreen:	.res	$400

