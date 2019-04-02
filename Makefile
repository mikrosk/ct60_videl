CC	= m68k-atari-mint-gcc
CFLAGS	= -m68030 -Wall -O2 -fomit-frame-pointer
ASFLAGS	= -m68030

TARGET	= videltst.prg
OBJS	= main.o videl2.o

$(TARGET): $(OBJS) pic_boot.S vars.h
	$(CC) -s -Wl,--mno-fastram -o $@ $(OBJS)

clean:
	rm -rf *~ $(OBJS) $(TARGET)
