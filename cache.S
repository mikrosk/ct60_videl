		.globl	_save_cache
		.globl	_flush_cache
		.globl	_restore_cache

		.text

_save_cache:	movec	cacr,d0
		move.l	d0,old_cacr
		rts

_flush_cache:	cpusha	bc
		cinva	bc
		rts

_restore_cache:	cpusha	bc
		cinva	bc

		move.l	old_cacr,d0
		movec	d0,cacr
		rts

		.bss
old_cacr:	ds.l	1
