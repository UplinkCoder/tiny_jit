/**
Copyright: Copyright (c) 2017 Andrey Penechko.
License: $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0).
Authors: Andrey Penechko.
*/
module asmtest.inc;

void testInc()
{
	import asmtest.utils;

	//inc BYTE PTR [reg]
	foreach (Register reg; Register.min..RegisterMax) testCodeGen.incb(memAddrBase(reg));
	assertHexAndReset("FE00FE01FE02FE03FE0424FE4500FE06FE0741FE0041FE0141FE0241FE0341FE042441FE450041FE0641FE07");

	//inc WORD PTR [reg]
	foreach (Register reg; Register.min..RegisterMax) testCodeGen.incw(memAddrBase(reg));
	assertHexAndReset("66FF0066FF0166FF0266FF0366FF042466FF450066FF0666FF076641FF006641FF016641FF026641FF036641FF04246641FF45006641FF066641FF07");

	//inc DWORD PTR [reg]
	foreach (Register reg; Register.min..RegisterMax) testCodeGen.incd(memAddrBase(reg));
	assertHexAndReset("FF00FF01FF02FF03FF0424FF4500FF06FF0741FF0041FF0141FF0241FF0341FF042441FF450041FF0641FF07");

	//inc QWORD PTR [reg]
	foreach (Register reg; Register.min..RegisterMax) testCodeGen.incq(memAddrBase(reg));
	assertHexAndReset("48FF0048FF0148FF0248FF0348FF042448FF450048FF0648FF0749FF0049FF0149FF0249FF0349FF042449FF450049FF0649FF07");

	//inc reg8
	foreach (Register reg; Register.min..RegisterMax) testCodeGen.incb(reg);
	assertHexAndReset("FEC0FEC1FEC2FEC340FEC440FEC540FEC640FEC741FEC041FEC141FEC241FEC341FEC441FEC541FEC641FEC7");

	//inc reg16
	foreach (Register reg; Register.min..RegisterMax) testCodeGen.incw(reg);
	assertHexAndReset("66FFC066FFC166FFC266FFC366FFC466FFC566FFC666FFC76641FFC06641FFC16641FFC26641FFC36641FFC46641FFC56641FFC66641FFC7");

	//inc reg32
	foreach (Register reg; Register.min..RegisterMax) testCodeGen.incd(reg);
	assertHexAndReset("FFC0FFC1FFC2FFC3FFC4FFC5FFC6FFC741FFC041FFC141FFC241FFC341FFC441FFC541FFC641FFC7");

	//inc reg64
	foreach (Register reg; Register.min..RegisterMax) testCodeGen.incq(reg);
	assertHexAndReset("48FFC048FFC148FFC248FFC348FFC448FFC548FFC648FFC749FFC049FFC149FFC249FFC349FFC449FFC549FFC649FFC7");


	// test memory encoding
	testCodeGen.incq(memAddrDisp32(0x11223344));
	assertHexAndReset("48FF042544332211");

	foreach (Register regA; Register.min..RegisterMax) if (regA != Register.SP) testCodeGen.incq(memAddrIndexDisp32(regA, SibScale(0), 0x11223344));
	assertHexAndReset("48FF04054433221148FF040D4433221148FF04154433221148FF041D4433221148FF042D4433221148FF04354433221148FF043D443322114AFF0405443322114AFF040D443322114AFF0415443322114AFF041D443322114AFF0425443322114AFF042D443322114AFF0435443322114AFF043D44332211");

	foreach (Register regA; Register.min..RegisterMax) testCodeGen.incq(memAddrBase(regA));
	assertHexAndReset("48FF0048FF0148FF0248FF0348FF042448FF450048FF0648FF0749FF0049FF0149FF0249FF0349FF042449FF450049FF0649FF07");

	foreach (Register regA; Register.min..RegisterMax) testCodeGen.incq(memAddrBaseDisp32(regA, 0x11223344));
	assertHexAndReset("48FF804433221148FF814433221148FF824433221148FF834433221148FF84244433221148FF854433221148FF864433221148FF874433221149FF804433221149FF814433221149FF824433221149FF834433221149FF84244433221149FF854433221149FF864433221149FF8744332211");

	foreach (Register regA; Register.min..RegisterMax) testCodeGen.incq(memAddrBaseIndex(regA, regA == Register.SP ? Register.AX : regA, SibScale(1)));
	assertHexAndReset("48FF044048FF044948FF045248FF045B48FF044448FF446D0048FF047648FF047F4BFF04404BFF04494BFF04524BFF045B4BFF04644BFF446D004BFF04764BFF047F");

	foreach (Register regA; Register.min..RegisterMax) testCodeGen.incq(memAddrBaseIndexDisp32(regA, regA == Register.SP ? Register.AX : regA, SibScale(2), 0x11223344));
	assertHexAndReset("48FF84804433221148FF84894433221148FF84924433221148FF849B4433221148FF84844433221148FF84AD4433221148FF84B64433221148FF84BF443322114BFF8480443322114BFF8489443322114BFF8492443322114BFF849B443322114BFF84A4443322114BFF84AD443322114BFF84B6443322114BFF84BF44332211");

	foreach (Register regA; Register.min..RegisterMax) testCodeGen.incq(memAddrBaseDisp8(regA, 0xFE));
	assertHexAndReset("48FF40FE48FF41FE48FF42FE48FF43FE48FF4424FE48FF45FE48FF46FE48FF47FE49FF40FE49FF41FE49FF42FE49FF43FE49FF4424FE49FF45FE49FF46FE49FF47FE");

	foreach (Register regA; Register.min..RegisterMax) testCodeGen.incq(memAddrBaseIndexDisp8(regA, regA == Register.SP ? Register.AX : regA, SibScale(3), 0xFE));
	assertHexAndReset("48FF44C0FE48FF44C9FE48FF44D2FE48FF44DBFE48FF44C4FE48FF44EDFE48FF44F6FE48FF44FFFE4BFF44C0FE4BFF44C9FE4BFF44D2FE4BFF44DBFE4BFF44E4FE4BFF44EDFE4BFF44F6FE4BFF44FFFE");
}
