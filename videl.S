		.globl	_save_videl
		.globl	_restore_videl

		.text
_save_videl:	movem.l	d2-d7/a2-a6,-(sp)

		bsr.w	wait_vbl			// avoid flicking

		lea	0xffff9800.w,a0			// save falcon palette
		lea	save_pal,a1			//
		moveq	#128-1,d7			//
save_loop:						//
		move.l	(a0)+,(a1)+			//
		move.l	(a0)+,(a1)+			//
		dbra	d7,save_loop			//

		movem.l	0xffff8240.w,d0-d7		// save st palette
		movem.l	d0-d7,(a1)			//

		lea	save_video,a0
		move.l	0xffff8200.w,(a0)+		// vidhm
		move.w	0xffff820c.w,(a0)+		// vidl

		move.l	0xffff8282.w,(a0)+		// h-regs
		move.l	0xffff8286.w,(a0)+		//
		move.l	0xffff828a.w,(a0)+		//

		move.l	0xffff82a2.w,(a0)+		// v-regs
		move.l	0xffff82a6.w,(a0)+		//
		move.l	0xffff82aa.w,(a0)+		//

		move.w	0xffff82c0.w,(a0)+		// vco
		move.w	0xffff82c2.w,(a0)+		// c_s

		move.l	0xffff820e.w,(a0)+		// offset
		move.w	0xffff820a.w,(a0)+		// sync

		move.b  0xffff8256.w,(a0)+		// p_o

		cmpi.w   #0xb0,0xffff8282.w		// st(e) / falcon test
		sle	(a0)+				// it's a falcon resolution

		move.w	0xffff8266.w,(a0)+		// f_s
		move.w	0xffff8260.w,(a0)+		// st_s

		movem.l	(sp)+,d2-d7/a2-a6
		rts

_restore_videl:	movem.l	d2-d7/a2-a6,-(sp)

		bsr.w	wait_vbl			// avoid flicking

		lea	save_video,a0

		move.l	(a0)+,0xffff8200.w		// videobase_address:h&m
		move.w	(a0)+,0xffff820c.w		// l

		move.l	(a0)+,0xffff8282.w		// h-regs
		move.l	(a0)+,0xffff8286.w		//
		move.l	(a0)+,0xffff828a.w		//

		move.l	(a0)+,0xffff82a2.w		// v-regs
		move.l	(a0)+,0xffff82a6.w		//
		move.l	(a0)+,0xffff82aa.w		//

		move.w	(a0)+,0xffff82c0.w		// vco
		move.w	(a0)+,0xffff82c2.w		// c_s

		move.l	(a0)+,0xffff820e.w		// offset
		move.w	(a0)+,0xffff820a.w		// sync

		move.b  (a0)+,0xffff8256.w		// p_o

		tst.b   (a0)+   			// st(e) compatible mode?
		bne.b   restore_ok			// yes

		move.w  (a0),0xffff8266.w		// falcon-shift

		move.w  0xffff8266.w,-(sp)		// Videl patch
		bsr.w	wait_vbl			// to avoid monochrome
		clr.w   0xffff8266.w			// sync errors
		bsr.w	wait_vbl			// (ripped from
		move.w	(sp)+,0xffff8266.w		// FreeMiNT kernel)

		bra.b	restored

restore_ok:
		//clr.w	0xffff8266.w
		move.w	(a0)+,0xffff8266.w		// falcon-shift
		move.w  (a0),0xffff8260.w		// st-shift
		lea	save_video,a0
		move.w	32(a0),0xffff82c2.w		// c_s
		move.l	34(a0),0xffff820e.w		// offset
restored:

		lea	save_pal,a0			// restore falcon palette
		lea	0xffff9800.w,a1			//
		moveq	#128-1,d7			//
restore_loop:						//
		move.l	(a0)+,(a1)+			//
		move.l	(a0)+,(a1)+			//
		dbra	d7,restore_loop			//

		movem.l	(a0),d0-d7			// restore st palette
		movem.l	d0-d7,0xffff8240.w		//

		movem.l	(sp)+,d2-d7/a2-a6
		rts

wait_vbl:	move.l	a0,-(sp)
		move.w	#0x25,-(sp)			// Vsync()
		trap	#14				//
		addq.l	#2,sp				//
		movea.l	(sp)+,a0
		rts

		.bss
save_pal:	.ds.l	256+16/2			// old colours (falcon+st/e)
save_video:	.ds.b	32+12+2				// videl save
