all: tmp/kb9v2.hex

tmp/kb9v2.hex: tmp/kb9v2.bin
	srec_cat $< -binary -offset 0x2000 -o $@ -Intel -address_length=2

tmp/kb9v2.bin: tmp/kb9v2.o kb9.cfg
	ld65 -C kb9.cfg $< -o $(basename $@).bin -Ln $(basename $@).lbl

tmp/kb9v2.o: msbasic.s
	ca65 -D kb9iec $< -o $(basename $@).o -l $(basename $@).lst

clean:
	$(RM) tmp/*.o tmp/*.lst tmp/*.bin tmp/*.hex tmp/*.lbl

tmp/kb9v2.o: \
	aim65_extra.s defines_aim65.s error.s iscntc.s message.s print.s \
	aim65_iscntc.s defines_apple.s eval.s kbd_extra.s microtan_extra.s \
	program.s aim65_loadsave.s defines_cbm1.s extra.s kbd_iscntc.s \
	microtan_iscntc.s rnd.s apple_extra.s defines_cbm2.s float.s \
	kbd_loadsave.s microtan_loadsave.s string.s apple_iscntc.s defines_kbd.s \
	flow1.s kim_extra.s misc1.s sym1_iscntc.s apple_loadsave.s defines_kim.s \
	flow2.s kim_iscntc.s misc2.s sym1_loadsave.s array.s defines_microtan.s \
	header.s kim_loadsave.s misc3.s token.s cbm1_patches.s defines_osi.s \
	init.s loadsave.s trig.s cbm_iscntc.s defines.s inline.s macros.s \
	osi_iscntc.s var.s chrget.s defines_sym1.s input.s memory.s poke.s \
	zeropage.s defines_kimiec.s
