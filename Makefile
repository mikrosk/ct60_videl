CC	= m68k-atari-mint-gcc
CFLAGS	= -m68060 -Wall -O2 -fomit-frame-pointer
ASFLAGS	= -m68060
LDFLAGS	= -m68060

TARGET	= videltst.prg
OBJS	= main.o cache.o videl.o videl2.o

$(TARGET): $(OBJS) pic_boot.S vars.h
	$(CC) $(LDFLAGS) -s -Wl,--mno-fastram -o $@ $(OBJS)

clean:
	rm -rf *~ $(OBJS) $(TARGET)
