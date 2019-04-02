		.globl	_flush_cache

		.text
_flush_cache:	cpusha	bc
		cinva	bc
		rts
