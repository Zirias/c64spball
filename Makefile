C64SYS?=c64
C64AS?=ca65
C64LD?=ld65

C64ASFLAGS?=-t $(C64SYS) -g
C64LDFLAGS?=-Ln spball.lbl -m spball.map -Csrc/spball.cfg

spball_OBJS:=$(addprefix obj/,main.o)
spball_BIN:=spball.prg

all: $(spball_BIN)

$(spball_BIN): $(spball_OBJS)
	$(C64LD) -o$@ $(C64LDFLAGS) $^

obj:
	mkdir obj

obj/%.o: src/%.s src/spball.cfg Makefile | obj
	$(C64AS) $(C64ASFLAGS) -o$@ $<

clean:
	rm -fr obj *.lbl *.map

distclean: clean
	rm -f $(spball_BIN)

.PHONY: all clean distclean

