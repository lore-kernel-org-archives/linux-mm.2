Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD080E63F2A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 05:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE946B008A; Mon, 16 Feb 2026 00:35:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3988D6B0093; Mon, 16 Feb 2026 00:35:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246A16B0096; Mon, 16 Feb 2026 00:35:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A154F6B008A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 00:35:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3C5E13C194
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 05:35:04 +0000 (UTC)
X-FDA: 84449206128.25.DDBE35D
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf23.hostedemail.com (Postfix) with ESMTP id C40A814000C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 05:35:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771220103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eAwoEUXrdOG2dRMAy/WheY14kxVCxgBKGDUOdvkTls0=;
	b=eCIOvOs7NkutDAACS7FQeo7R3XMFOmP8l1sS9Z9xWOrFivBOcpfGZXrzK/mU2YAYCDZGcu
	YXhnY6hGVtKmNbihHwXdm7sWDIpASAJN6iVYGA/o6G+AeMfHjXpWt4/TC5oNybQhjnXfUZ
	gNKwoOfcwNiJKSZiEa+CUHUeJVRkFgo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771220103; a=rsa-sha256;
	cv=none;
	b=GFWe4+fmITnKnaP/YRLmjkNnI/NPMBc804Pjn5wrc2Kmug4c9d7j32eGZEAW91kffIA4+f
	M/oYKVhSwB9QR2tigioAe1WNj/+kV41ix30ggRpmpOX0QfwWfH10QRmI2PqbDnevmF11KO
	2/XBm+k0DCRc2I33rAPDI6X261hBcSk=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61G5YjSl337273;
	Sun, 15 Feb 2026 23:34:49 -0600
Message-ID: <9a46df616e371e1680637a41ba2757b7cecf55f6.camel@kernel.crashing.org>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
        Marco Elver
	 <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 16 Feb 2026 16:34:44 +1100
In-Reply-To: <684d84272e7dcd2ead0770843a7e0afc625c87c9.camel@kernel.crashing.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <aYJBBs17B-SQXFqq@kernel.org>
	 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
	 <aYL3zxuTLT8N7C8-@kernel.org>
	 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
	 <aYXDeN0WGQG8-cxe@kernel.org>
	 <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
	 <e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org>
	 <5a44609fe992624573a3ca0a293888bd623e2a06.camel@kernel.crashing.org>
	 <0344bfbeb017cafc0f7bd4433eeacd9bc802d9c9.camel@kernel.crashing.org>
	 <aYtBctm4TlHGnzXV@kernel.org>
	 <684d84272e7dcd2ead0770843a7e0afc625c87c9.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Stat-Signature: b8uuogeeg69im3m9ttyqbw4qci53rkmq
X-Rspamd-Queue-Id: C40A814000C
X-Rspam-User: 
X-HE-Tag: 1771220102-659808
X-HE-Meta: U2FsdGVkX18MjmROLgfGHijCVkaCl7ygbdBmUvZ7Np73xoBrfq2K2upkqX5/QVDwe/IaCto8tkZtuKXb5shdE6XNOP+F+MlRk7vPX6A6xPIOCy099K95IFGh7c1PwIALCM2OZvCjcz8+hCIVRQwNVF5YJwqpQh+P1GRQZUsgtrVI8WHBEJnB+omHRxoQPZzZokxPbv7wcSgMF16M4EsVCc1ZsGhmbosYbF8M/PNdb4gsAYH65Q2KTMbYc2rG+0hnLUNrlINNvFHbmc7w+VQ1EzTsb/739uy2ori5Yk0qSAQbphJGnCQF/JGVoGwb34BUM6+4owoH6IPUXATvjNDWzUSzFktXkDV7PgyKHRm7A/8/+UHBe1sPnR0/EfHT9Op0Gk22CKQ5yuNvw8IEjlPKON5WdQAEXEZQvokUQaXY269B2XXqgjIQ7bDNRBOMSusQkmd1gMapQP3liwqK+cROVmSxBxD6gTSDyyQVfB3WtjHRhzaskccZ4tXnPnN/VVYrkIunAlXpVmLEDpzSEaT9R9ql2UtwABPQ0zigR/XnRRWVHkvZ+B5uidsYS1oe0LECjLJopgnnCetGRSLiQDmWIcmtFODtjvsTjHWbavOxGX2+FzVtlKwLz5hM9eZwdkWW6Y/Y8EDUww9b+A7PBuIuUQLCWO1lmdUPuBfdTN6ZyvQupy3FCUdDYvGri2I8udkQp2+tFJOlKITfXyG/3+QqXVkHtS5kyWSkhuCTYK+5dXIyk5Tqt5FJ0Eht8oKeGeZefLkGRopAi3rDWlIINsR3Wh79jYYWz2zGmM/uF9u1mIrGDbGQxTZ3X1+goSuXU3HDM/kcwq7uML4j3f0a42BPvRjbc9QCw96D2HY0HCVvJeMQLc0QNgT5HZBehn9AxF58mg707QVXGc5zTeLHnPltvgDn31wANvE89C4SneXEDHF9m45q3y9Sxn6wvM/aQHFKSkKh/Jq3vDfB6LnySo9
 d3F7omu2
 dium7ysQZSCFtUU1yGHMXGBu3C6EW7If1igAYINPCnu5PUwQKP3r2an4WkZRl60yZbbLX7GcBaf6oPTEZgoKaClD3IzSMsGahhmKIUfJQx4C5oO2n0FVspWwngUXQFj+JgcsRgONROPqEnW3pjMrQxm7v6CfwWolueY3cp7FjghmZq1o/HX04lG7I5ciazOtKpSWh4WHuUu9ENXM2Br7s9BAV5QxGDuFub8vd57r2c0dQ5EwfnQczXsM8Yks/Cm6fZX1PNpu4QzgpQ8U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-02-11 at 10:23 +1100, Benjamin Herrenschmidt wrote:
> >=20
> > Do you mind sending the entire log?
>=20
> I misplaced it, but give me a few days to dig see if I can find what's go=
ing on.

Here's a log on a t3 instance with you patch plus some printk's of mine
showing the EFI memory reserves and with memblock debug.

This crash is NOT explained by the missing pfn_valid() I mentioned in my
earlier email. I don't know if there could be a zone issue here, it does
look like every page we are trying to free is contained in a e820 "usable"
range here unless I really misread something.

Just in case I accidentally screwed up something last week, I will run
a bunch of tests with both my original and your patch + the missing
pfn_valid(), see if that trips anything.

I will separately look at adding the EFI regions to the memblock.memory,
as I think the very first crash I reported smelled a lot like an unmapped
piece of mem_map.

Cheers,
Ben.


[ec2-user@ip-172-31-29-240 ~]$ sudo dmesg
[    0.000000] Linux version 6.12.68-93.123.amzn2023.x86_64 (mockbuild@ip-1=
0-0-53-120) (gcc (GCC) 11.5.0 20240719 (Red Hat 11.5.0-5), GNU ld version 2=
.41-50.amzn2023.0.5) #1 SMP PREEMPT_DYNAMIC Tue Feb 10 06:40:43 UTC 2026
[    0.000000] Command line: BOOT_IMAGE=3D(hd0,gpt1)/boot/vmlinuz-6.12.68-9=
3.123.amzn2023.x86_64 root=3DUUID=3D7813e2d4-9cdc-416a-a749-25de8a9f36d0 ro=
 console=3Dtty0 console=3DttyS0,115200n8 nvme_core.io_timeout=3D4294967295 =
rd.emergency=3Dpoweroff rd.shell=3D0 selinux=3D1 security=3Dselinux quiet m=
emblock=3Ddebug
[    0.000000] KASLR enabled
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000390cdfff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x00000000390ce000-0x000000003934dfff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000003934e000-0x000000003935dfff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x000000003935e000-0x00000000393ddfff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000393de000-0x000000003d37bfff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000003d37c000-0x000000003d3fffff] reser=
ved
[    0.000000] memblock_reserve: [0x0000000039350040-0x000000003935060f] ef=
i_memblock_x86_reserve_range+0x159/0x1e0
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] APIC: Static calls initialized
[    0.000000] e820: update [mem 0x372be018-0x372c6e57] usable =3D=3D> usab=
le
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009ff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000372be0=
17] usable
[    0.000000] reserve setup_data: [mem 0x00000000372be018-0x00000000372c6e=
57] usable
[    0.000000] reserve setup_data: [mem 0x00000000372c6e58-0x00000000390cdf=
ff] usable
[    0.000000] reserve setup_data: [mem 0x00000000390ce000-0x000000003934df=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x000000003934e000-0x000000003935df=
ff] ACPI data
[    0.000000] reserve setup_data: [mem 0x000000003935e000-0x00000000393ddf=
ff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000393de000-0x000000003d37bf=
ff] usable
[    0.000000] reserve setup_data: [mem 0x000000003d37c000-0x000000003d3fff=
ff] reserved
[    0.000000] efi: EFI v2.7 by EDK II
[    0.000000] efi: SMBIOS=3D0x3926a000 ACPI=3D0x3935d000 ACPI 2.0=3D0x3935=
d014 MEMATTR=3D0x37a43a98=20
[    0.000000] memblock_reserve: [0x0000000037a43a98-0x0000000037a43e37] ef=
i_memattr_init+0x4d/0xa0
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Amazon EC2 t3.micro/, BIOS 1.0 10/16/2017
[    0.000000] DMI: Memory slots populated: 1/1
[    0.000000] Hypervisor detected: KVM
[    0.000000] last_pfn =3D 0x3d37c max_arch_pfn =3D 0x400000000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: using sched offset of 7715848997 cycles
[    0.000003] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles:=
 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000006] tsc: Detected 2499.994 MHz processor
[    0.000088] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000090] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000096] last_pfn =3D 0x3d37c max_arch_pfn =3D 0x400000000
[    0.000123] MTRR map: 4 entries (2 fixed + 2 variable; max 18), built fr=
om 8 variable MTRRs
[    0.000126] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT=
 =20
[    0.006943] memblock_reserve: [0x000000001d400000-0x000000001d40cfff] se=
tup_arch+0x953/0xad0
[    0.006950] memblock_add: [0x0000000000001000-0x000000000009ffff] e820__=
memblock_setup+0x6f/0xb0
[    0.006954] memblock_add: [0x0000000000100000-0x00000000372be017] e820__=
memblock_setup+0x6f/0xb0
[    0.006957] memblock_add: [0x00000000372be018-0x00000000372c6e57] e820__=
memblock_setup+0x6f/0xb0
[    0.006960] memblock_add: [0x00000000372c6e58-0x00000000390cdfff] e820__=
memblock_setup+0x6f/0xb0
[    0.006962] memblock_add: [0x00000000393de000-0x000000003d37bfff] e820__=
memblock_setup+0x6f/0xb0
[    0.006965] MEMBLOCK configuration:
[    0.006965]  memory size =3D 0x000000003d00b000 reserved size =3D 0x0000=
0000049ff7b0
[    0.006966]  memory.cnt  =3D 0x3
[    0.006967]  memory[0x0]	[0x0000000000001000-0x000000000009ffff], 0x0000=
00000009f000 bytes flags: 0x0
[    0.006969]  memory[0x1]	[0x0000000000100000-0x00000000390cdfff], 0x0000=
000038fce000 bytes flags: 0x0
[    0.006970]  memory[0x2]	[0x00000000393de000-0x000000003d37bfff], 0x0000=
000003f9e000 bytes flags: 0x0
[    0.006971]  reserved.cnt  =3D 0x7
[    0.006972]  reserved[0x0]	[0x0000000000000000-0x000000000000ffff], 0x00=
00000000010000 bytes flags: 0x0
[    0.006973]  reserved[0x1]	[0x000000000009f000-0x00000000000fffff], 0x00=
00000000061000 bytes flags: 0x0
[    0.006975]  reserved[0x2]	[0x000000001a000000-0x000000001d40cfff], 0x00=
0000000340d000 bytes flags: 0x0
[    0.006976]  reserved[0x3]	[0x000000003254f000-0x0000000033ac6fff], 0x00=
00000001578000 bytes flags: 0x0
[    0.006977]  reserved[0x4]	[0x00000000372be018-0x00000000372c6e57], 0x00=
00000000008e40 bytes flags: 0x0
[    0.006978]  reserved[0x5]	[0x0000000037a43a98-0x0000000037a43e37], 0x00=
000000000003a0 bytes flags: 0x0
[    0.006979]  reserved[0x6]	[0x0000000039350040-0x000000003935060f], 0x00=
000000000005d0 bytes flags: 0x0
[    0.006981] EFI XX 0x0000000038e73000..00000000390cdfff
[    0.006982] memblock_reserve: [0x0000000038e73000-0x00000000390cdfff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.006985] EFI XX 0x00000000393de000..00000000393defff
[    0.006986] memblock_reserve: [0x00000000393de000-0x00000000393defff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.006988] EFI XX 0x000000003b000000..000000003b1fffff
[    0.006989] memblock_reserve: [0x000000003b000000-0x000000003b1fffff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.006991] EFI XX 0x000000003b2f7000..000000003b316fff
[    0.006992] memblock_reserve: [0x000000003b2f7000-0x000000003b316fff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.006994] EFI XX 0x000000003b317000..000000003b335fff
[    0.006995] memblock_reserve: [0x000000003b317000-0x000000003b335fff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.006997] EFI XX 0x000000003b336000..000000003d36afff
[    0.006998] memblock_reserve: [0x000000003b336000-0x000000003d36afff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.007000] EFI XX 0x000000003d36b000..000000003d37bfff
[    0.007000] memblock_reserve: [0x000000003d36b000-0x000000003d37bfff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.007004] memblock_phys_alloc_range: 28672 bytes align=3D0x1000 from=
=3D0x0000000000000000 max_addr=3D0x0000000000100000 reserve_real_mode+0x53/=
0x90
[    0.007008] memblock_reserve: [0x0000000000098000-0x000000000009efff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007012] memblock_reserve: [0x0000000000000000-0x00000000000fffff] se=
tup_arch+0x636/0xad0
[    0.007014] Using GB pages for direct mapping
[    0.007052] memblock_phys_alloc_range: 2097152 bytes align=3D0x200000 fr=
om=3D0x0000000000100000 max_addr=3D0x000000003d37c000 init_mem_mapping+0x14=
0/0x2c0
[    0.007055] memblock_reserve: [0x000000003ae00000-0x000000003affffff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007058] memblock_phys_free: [0x000000003ae00000-0x000000003affffff] =
init_mem_mapping+0x160/0x2c0
[    0.007261] Secure boot disabled
[    0.007261] RAMDISK: [mem 0x3254f000-0x33ac6fff]
[    0.007271] ACPI: Early table checksum verification disabled
[    0.007275] ACPI: RSDP 0x000000003935D014 000024 (v02 AMAZON)
[    0.007278] ACPI: XSDT 0x000000003935C0E8 00006C (v01 AMAZON AMZNFACP 00=
000001      01000013)
[    0.007283] ACPI: FACP 0x0000000039355000 000114 (v01 AMAZON AMZNFACP 00=
000001 AMZN 00000001)
[    0.007288] ACPI: DSDT 0x0000000039356000 00115A (v01 AMAZON AMZNDSDT 00=
000001 AMZN 00000001)
[    0.007291] ACPI: FACS 0x00000000393D0000 000040
[    0.007294] ACPI: WAET 0x000000003935B000 000028 (v01 AMAZON AMZNWAET 00=
000001 AMZN 00000001)
[    0.007296] ACPI: SLIT 0x000000003935A000 00006C (v01 AMAZON AMZNSLIT 00=
000001 AMZN 00000001)
[    0.007299] ACPI: APIC 0x0000000039359000 000076 (v01 AMAZON AMZNAPIC 00=
000001 AMZN 00000001)
[    0.007301] ACPI: SRAT 0x0000000039358000 0000A0 (v01 AMAZON AMZNSRAT 00=
000001 AMZN 00000001)
[    0.007304] ACPI: HPET 0x0000000039354000 000038 (v01 AMAZON AMZNHPET 00=
000001 AMZN 00000001)
[    0.007306] ACPI: SSDT 0x0000000039353000 000759 (v01 AMAZON AMZNSSDT 00=
000001 AMZN 00000001)
[    0.007309] ACPI: SSDT 0x0000000039352000 00007F (v01 AMAZON AMZNSSDT 00=
000001 AMZN 00000001)
[    0.007312] ACPI: BGRT 0x0000000039351000 000038 (v01 AMAZON AMAZON   00=
000002      01000013)
[    0.007314] ACPI: Reserving FACP table memory at [mem 0x39355000-0x39355=
113]
[    0.007315] memblock_reserve: [0x0000000039355000-0x0000000039355113] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007319] ACPI: Reserving DSDT table memory at [mem 0x39356000-0x39357=
159]
[    0.007320] memblock_reserve: [0x0000000039356000-0x0000000039357159] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007323] ACPI: Reserving FACS table memory at [mem 0x393d0000-0x393d0=
03f]
[    0.007323] memblock_reserve: [0x00000000393d0000-0x00000000393d003f] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007325] ACPI: Reserving WAET table memory at [mem 0x3935b000-0x3935b=
027]
[    0.007326] memblock_reserve: [0x000000003935b000-0x000000003935b027] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007328] ACPI: Reserving SLIT table memory at [mem 0x3935a000-0x3935a=
06b]
[    0.007329] memblock_reserve: [0x000000003935a000-0x000000003935a06b] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007331] ACPI: Reserving APIC table memory at [mem 0x39359000-0x39359=
075]
[    0.007332] memblock_reserve: [0x0000000039359000-0x0000000039359075] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007334] ACPI: Reserving SRAT table memory at [mem 0x39358000-0x39358=
09f]
[    0.007335] memblock_reserve: [0x0000000039358000-0x000000003935809f] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007337] ACPI: Reserving HPET table memory at [mem 0x39354000-0x39354=
037]
[    0.007338] memblock_reserve: [0x0000000039354000-0x0000000039354037] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007340] ACPI: Reserving SSDT table memory at [mem 0x39353000-0x39353=
758]
[    0.007341] memblock_reserve: [0x0000000039353000-0x0000000039353758] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007343] ACPI: Reserving SSDT table memory at [mem 0x39352000-0x39352=
07e]
[    0.007344] memblock_reserve: [0x0000000039352000-0x000000003935207e] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007346] ACPI: Reserving BGRT table memory at [mem 0x39351000-0x39351=
037]
[    0.007346] memblock_reserve: [0x0000000039351000-0x0000000039351037] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007398] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x3fffffff]
[    0.007407] memblock_alloc_try_nid: 1 bytes align=3D0x1000 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 numa_alloc_distance+0x1=
4a/0x200
[    0.007414] memblock_reserve: [0x000000003b2f6000-0x000000003b2f6000] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007421] NUMA: Initialized distance table, cnt=3D1
[    0.007430] memblock_reserve: [0x000000003b2cb680-0x000000003b2f5fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007433] NODE_DATA(0) allocated [mem 0x3b2cb680-0x3b2f5fff]
[    0.007452] MEMBLOCK configuration:
[    0.007452]  memory size =3D 0x000000003d00b000 reserved size =3D 0x0000=
000006f9bdd1
[    0.007453]  memory.cnt  =3D 0x3
[    0.007454]  memory[0x0]	[0x0000000000001000-0x000000000009ffff], 0x0000=
00000009f000 bytes on node 0 flags: 0x0
[    0.007456]  memory[0x1]	[0x0000000000100000-0x00000000390cdfff], 0x0000=
000038fce000 bytes on node 0 flags: 0x0
[    0.007458]  memory[0x2]	[0x00000000393de000-0x000000003d37bfff], 0x0000=
000003f9e000 bytes on node 0 flags: 0x0
[    0.007459]  reserved.cnt  =3D 0x18
[    0.007460]  reserved[0x0]	[0x0000000000000000-0x0000000000000fff], 0x00=
00000000001000 bytes flags: 0x0
[    0.007462]  reserved[0x1]	[0x0000000000001000-0x00000000000fffff], 0x00=
000000000ff000 bytes on node 0 flags: 0x0
[    0.007464]  reserved[0x2]	[0x000000001a000000-0x000000001d40cfff], 0x00=
0000000340d000 bytes on node 0 flags: 0x0
[    0.007465]  reserved[0x3]	[0x000000003254f000-0x0000000033ac6fff], 0x00=
00000001578000 bytes on node 0 flags: 0x0
[    0.007467]  reserved[0x4]	[0x00000000372be018-0x00000000372c6e57], 0x00=
00000000008e40 bytes on node 0 flags: 0x0
[    0.007468]  reserved[0x5]	[0x0000000037a43a98-0x0000000037a43e37], 0x00=
000000000003a0 bytes on node 0 flags: 0x0
[    0.007470]  reserved[0x6]	[0x0000000038e73000-0x00000000390cdfff], 0x00=
0000000025b000 bytes on node 0 flags: 0x0
[    0.007471]  reserved[0x7]	[0x0000000039350040-0x000000003935060f], 0x00=
000000000005d0 bytes on node 0 flags: 0x0
[    0.007473]  reserved[0x8]	[0x0000000039351000-0x0000000039351037], 0x00=
00000000000038 bytes on node 0 flags: 0x0
[    0.007474]  reserved[0x9]	[0x0000000039352000-0x000000003935207e], 0x00=
0000000000007f bytes on node 0 flags: 0x0
[    0.007475]  reserved[0xa]	[0x0000000039353000-0x0000000039353758], 0x00=
00000000000759 bytes on node 0 flags: 0x0
[    0.007477]  reserved[0xb]	[0x0000000039354000-0x0000000039354037], 0x00=
00000000000038 bytes on node 0 flags: 0x0
[    0.007478]  reserved[0xc]	[0x0000000039355000-0x0000000039355113], 0x00=
00000000000114 bytes on node 0 flags: 0x0
[    0.007479]  reserved[0xd]	[0x0000000039356000-0x0000000039357159], 0x00=
0000000000115a bytes on node 0 flags: 0x0
[    0.007480]  reserved[0xe]	[0x0000000039358000-0x000000003935809f], 0x00=
000000000000a0 bytes on node 0 flags: 0x0
[    0.007482]  reserved[0xf]	[0x0000000039359000-0x0000000039359075], 0x00=
00000000000076 bytes on node 0 flags: 0x0
[    0.007483]  reserved[0x10]	[0x000000003935a000-0x000000003935a06b], 0x0=
00000000000006c bytes on node 0 flags: 0x0
[    0.007485]  reserved[0x11]	[0x000000003935b000-0x000000003935b027], 0x0=
000000000000028 bytes on node 0 flags: 0x0
[    0.007487]  reserved[0x12]	[0x00000000393d0000-0x00000000393d003f], 0x0=
000000000000040 bytes on node 0 flags: 0x0
[    0.007488]  reserved[0x13]	[0x00000000393de000-0x00000000393defff], 0x0=
000000000001000 bytes on node 0 flags: 0x0
[    0.007490]  reserved[0x14]	[0x000000003b000000-0x000000003b1fffff], 0x0=
000000000200000 bytes on node 0 flags: 0x0
[    0.007491]  reserved[0x15]	[0x000000003b2cb680-0x000000003b2f5fff], 0x0=
00000000002a980 bytes flags: 0x0
[    0.007492]  reserved[0x16]	[0x000000003b2f6000-0x000000003b2f6000], 0x0=
000000000000001 bytes on node 0 flags: 0x0
[    0.007493]  reserved[0x17]	[0x000000003b2f7000-0x000000003d37bfff], 0x0=
000000002085000 bytes on node 0 flags: 0x0
[    0.007652] memblock_alloc_try_nid: 16384 bytes align=3D0x40 nid=3D-1 fr=
om=3D0x0000000000000000 max_addr=3D0x0000000000000000 memblocks_present+0x1=
d1/0x210
[    0.007655] memblock_reserve: [0x000000003b2c7680-0x000000003b2cb67f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007659] memblock_alloc_try_nid: 4096 bytes align=3D0x40 nid=3D0 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 sparse_index_alloc+0x44=
/0x70
[    0.007663] memblock_reserve: [0x000000003b2c6680-0x000000003b2c767f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007667] memblock_alloc_try_nid: 448 bytes align=3D0x40 nid=3D0 from=
=3D0x0000000038000000 max_addr=3D0x0000000040000000 sparse_init_nid+0x9b/0x=
4e0
[    0.007669] memblock_reserve: [0x000000003b2f6e40-0x000000003b2f6fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007672] memblock_alloc_exact_nid_raw: 16777216 bytes align=3D0x20000=
0 nid=3D0 from=3D0x0000000001000000 max_addr=3D0x0000000000000000 memmap_al=
loc+0x1f/0x60
[    0.007675] memblock_reserve: [0x000000003a000000-0x000000003affffff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.009338] memblock_alloc_try_nid_raw: 4096 bytes align=3D0x1000 nid=3D=
0 from=3D0x0000000001000000 max_addr=3D0x0000000000000000 vmemmap_alloc_blo=
ck_zero.constprop.0+0x11/0x50
[    0.009345] memblock_reserve: [0x000000003b2c5000-0x000000003b2c5fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.009351] memblock_alloc_try_nid_raw: 4096 bytes align=3D0x1000 nid=3D=
0 from=3D0x0000000001000000 max_addr=3D0x0000000000000000 vmemmap_alloc_blo=
ck_zero.constprop.0+0x11/0x50
[    0.009354] memblock_reserve: [0x000000003b2c4000-0x000000003b2c4fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.009360] Zone ranges:
[    0.009361]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.009363]   DMA32    [mem 0x0000000001000000-0x000000003d37bfff]
[    0.009364]   Normal   empty
[    0.009365]   Device   empty
[    0.009366] Movable zone start for each node
[    0.009369] Early memory node ranges
[    0.009369]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.009371]   node   0: [mem 0x0000000000100000-0x00000000390cdfff]
[    0.009372]   node   0: [mem 0x00000000393de000-0x000000003d37bfff]
[    0.009373] Initmem setup node 0 [mem 0x0000000000001000-0x000000003d37b=
fff]
[    0.009378] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.009406] On node 0, zone DMA: 96 pages in unavailable ranges
[    0.009905] On node 0, zone DMA32: 784 pages in unavailable ranges
[    0.009994] On node 0, zone DMA32: 11396 pages in unavailable ranges
[    0.010412] ACPI: PM-Timer IO Port: 0xb008
[    0.010424] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.010480] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-=
23
[    0.010482] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.010484] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.010486] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level=
)
[    0.010487] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level=
)
[    0.010490] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.010491] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.010492] memblock_alloc_try_nid: 73 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 acpi_parse_hpet+0x91/0x=
150
[    0.010498] memblock_reserve: [0x000000003b2f6dc0-0x000000003b2f6e08] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010503] TSC deadline timer available
[    0.010508] CPU topo: Max. logical packages:   1
[    0.010509] CPU topo: Max. logical dies:       1
[    0.010509] CPU topo: Max. dies per package:   1
[    0.010514] CPU topo: Max. threads per core:   2
[    0.010515] CPU topo: Num. cores per package:     1
[    0.010516] CPU topo: Num. threads per package:   2
[    0.010516] CPU topo: Allowing 2 present CPUs plus 0 hotplug CPUs
[    0.010518] memblock_alloc_try_nid: 75 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 io_apic_init_mappings+0=
x41/0x1e0
[    0.010522] memblock_reserve: [0x000000003b2f6d40-0x000000003b2f6d8a] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010539] kvm-guest: APIC: eoi() replaced with kvm_guest_apic_eoi_writ=
e()
[    0.010547] memblock_alloc_try_nid: 640 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 e820__reserve_resources=
+0x2e/0x1f0
[    0.010552] memblock_reserve: [0x000000003b2f6ac0-0x000000003b2f6d3f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010556] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010560] memblock_reserve: [0x000000003b2f6a40-0x000000003b2f6aa7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010563] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010566] memblock_reserve: [0x000000003b2f69c0-0x000000003b2f6a27] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010569] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010572] memblock_reserve: [0x000000003b2f6940-0x000000003b2f69a7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010574] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010577] memblock_reserve: [0x000000003b2f68c0-0x000000003b2f6927] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010580] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010583] memblock_reserve: [0x000000003b2f6840-0x000000003b2f68a7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010585] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010588] memblock_reserve: [0x000000003b2f67c0-0x000000003b2f6827] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010591] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010593] memblock_reserve: [0x000000003b2f6740-0x000000003b2f67a7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010596] memblock_alloc_try_nid: 32 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 register_nosave_region+=
0x53/0xe0
[    0.010601] memblock_reserve: [0x000000003b2f6700-0x000000003b2f671f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010604] PM: hibernation: Registered nosave memory: [mem 0x00000000-0=
x00000fff]
[    0.010605] memblock_alloc_try_nid: 32 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 register_nosave_region+=
0x53/0xe0
[    0.010608] memblock_reserve: [0x000000003b2f66c0-0x000000003b2f66df] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010611] PM: hibernation: Registered nosave memory: [mem 0x000a0000-0=
x000fffff]
[    0.010611] memblock_alloc_try_nid: 32 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 register_nosave_region+=
0x53/0xe0
[    0.010615] memblock_reserve: [0x000000003b2f6680-0x000000003b2f669f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010617] PM: hibernation: Registered nosave memory: [mem 0x390ce000-0=
x393ddfff]
[    0.010619] [mem 0x3d400000-0xffffffff] available for PCI devices
[    0.010621] Booting paravirtualized kernel on KVM
[    0.010623] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 19112604462750000 ns
[    0.015925] memblock_alloc_try_nid: 265 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 setup_command_line+0x71=
/0x230
[    0.015933] memblock_reserve: [0x000000003b2f6540-0x000000003b2f6648] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.015937] memblock_alloc_try_nid: 265 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 setup_command_line+0xa4=
/0x230
[    0.015940] memblock_reserve: [0x000000003b2f6400-0x000000003b2f6508] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.015944] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.015954] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_build_alloc_inf=
o+0x2e1/0x5c0
[    0.015958] memblock_reserve: [0x000000003b2c3000-0x000000003b2c3fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.015961] memblock_alloc_try_nid: 4096 bytes align=3D0x40 nid=3D-1 fro=
m=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_embed_first_chunk=
+0x7a/0x580
[    0.015964] memblock_reserve: [0x000000003b2c2000-0x000000003b2c2fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.015968] memblock_alloc_try_nid: 2097152 bytes align=3D0x200000 nid=
=3D0 from=3D0x0000000001000000 max_addr=3D0x0000000000000000 pcpu_fc_alloc+=
0x101/0x170
[    0.015971] memblock_reserve: [0x0000000039e00000-0x0000000039ffffff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016206] memblock_phys_free: [0x0000000039e41000-0x0000000039efffff] =
pcpu_embed_first_chunk+0x1e6/0x580
[    0.016229] memblock_phys_free: [0x0000000039f41000-0x0000000039ffffff] =
pcpu_embed_first_chunk+0x1e6/0x580
[    0.016231] percpu: Embedded 65 pages/cpu s229376 r8192 d28672 u1048576
[    0.016233] memblock_alloc_try_nid: 8 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_setup_first_chunk+=
0xc3/0x900
[    0.016236] memblock_reserve: [0x000000003b2f63c0-0x000000003b2f63c7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016239] memblock_alloc_try_nid: 8 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_setup_first_chunk+=
0xee/0x900
[    0.016242] memblock_reserve: [0x000000003b2f6380-0x000000003b2f6387] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016244] memblock_alloc_try_nid: 8 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_setup_first_chunk+=
0x120/0x900
[    0.016247] memblock_reserve: [0x000000003b2f6340-0x000000003b2f6347] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016250] memblock_alloc_try_nid: 16 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_setup_first_chunk+=
0x156/0x900
[    0.016253] memblock_reserve: [0x000000003b2f6300-0x000000003b2f630f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016256] pcpu-alloc: s229376 r8192 d28672 u1048576 alloc=3D1*2097152
[    0.016258] pcpu-alloc: [0] 0 1=20
[    0.016261] memblock_alloc_try_nid: 352 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_setup_first_chunk+=
0x707/0x900
[    0.016264] memblock_reserve: [0x000000003b2f6180-0x000000003b2f62df] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016266] memblock_alloc_try_nid: 264 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x76/0x2f0
[    0.016269] memblock_reserve: [0x000000003b2f6040-0x000000003b2f6147] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016272] memblock_alloc_try_nid: 256 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0xee/0x2f0
[    0.016275] memblock_reserve: [0x000000003b2c6580-0x000000003b2c667f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016278] memblock_alloc_try_nid: 264 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x129/0x2f0
[    0.016280] memblock_reserve: [0x000000003b2c6440-0x000000003b2c6547] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016283] memblock_alloc_try_nid: 64 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x15a/0x2f0
[    0.016286] memblock_reserve: [0x000000003b2c6400-0x000000003b2c643f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016289] memblock_alloc_try_nid: 264 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x76/0x2f0
[    0.016291] memblock_reserve: [0x000000003b2c62c0-0x000000003b2c63c7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016294] memblock_alloc_try_nid: 896 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0xee/0x2f0
[    0.016297] memblock_reserve: [0x000000003b2c1c80-0x000000003b2c1fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016300] memblock_alloc_try_nid: 904 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x129/0x2f0
[    0.016303] memblock_reserve: [0x000000003b2c18c0-0x000000003b2c1c47] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016305] memblock_alloc_try_nid: 224 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x15a/0x2f0
[    0.016308] memblock_reserve: [0x000000003b2c61c0-0x000000003b2c629f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016311] memblock_phys_free: [0x000000003b2c3000-0x000000003b2c3fff] =
pcpu_embed_first_chunk+0x26c/0x580
[    0.016314] memblock_phys_free: [0x000000003b2c2000-0x000000003b2c2fff] =
pcpu_embed_first_chunk+0x279/0x580
[    0.016317] memblock_alloc_try_nid: 8 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 alloc_bootmem_cpumask_v=
ar+0x2a/0x60
[    0.016320] memblock_reserve: [0x000000003b2c6180-0x000000003b2c6187] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016323] memblock_alloc_try_nid: 8 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 alloc_bootmem_cpumask_v=
ar+0x2a/0x60
[    0.016325] memblock_reserve: [0x000000003b2c6140-0x000000003b2c6147] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016996] kvm-guest: PV spinlocks enabled
[    0.016997] memblock_alloc_try_nid: 4096 bytes align=3D0x40 nid=3D-1 fro=
m=3D0x0000000000000000 max_addr=3D0x0000000000000000 alloc_large_system_has=
h+0x232/0x2d0
[    0.017000] memblock_reserve: [0x000000003b2c3000-0x000000003b2c3fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017004] PV qspinlock hash table entries: 256 (order: 0, 4096 bytes, =
linear)
[    0.017006] Kernel command line: BOOT_IMAGE=3D(hd0,gpt1)/boot/vmlinuz-6.=
12.68-93.123.amzn2023.x86_64 root=3DUUID=3D7813e2d4-9cdc-416a-a749-25de8a9f=
36d0 ro console=3Dtty0 console=3DttyS0,115200n8 nvme_core.io_timeout=3D4294=
967295 rd.emergency=3Dpoweroff rd.shell=3D0 selinux=3D1 security=3Dselinux =
quiet memblock=3Ddebug
[    0.017133] random: crng init done
[    0.017136] memblock_alloc_try_nid: 1048576 bytes align=3D0x40 nid=3D-1 =
from=3D0x0000000000000000 max_addr=3D0x0000000000000000 alloc_large_system_=
hash+0x232/0x2d0
[    0.017139] memblock_reserve: [0x0000000039d00000-0x0000000039dfffff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017255] Dentry cache hash table entries: 131072 (order: 8, 1048576 b=
ytes, linear)
[    0.017257] memblock_alloc_try_nid: 524288 bytes align=3D0x40 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 alloc_large_system_h=
ash+0x232/0x2d0
[    0.017261] memblock_reserve: [0x000000003b2418c0-0x000000003b2c18bf] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017314] Inode-cache hash table entries: 65536 (order: 7, 524288 byte=
s, linear)
[    0.017318] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017323] memblock_reserve: [0x000000003b2c2000-0x000000003b2c2fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017326] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017328] memblock_reserve: [0x000000003b240000-0x000000003b240fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017331] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017334] memblock_reserve: [0x000000003b23f000-0x000000003b23ffff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017347] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017350] memblock_reserve: [0x000000003b23e000-0x000000003b23efff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017353] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017356] memblock_reserve: [0x000000003b23d000-0x000000003b23dfff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017361] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017364] memblock_reserve: [0x000000003b23c000-0x000000003b23cfff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017388] Fallback order for Node 0: 0=20
[    0.017391] Built 1 zonelists, mobility grouping on.  Total pages: 24986=
7
[    0.017392] Policy zone: DMA32
[    0.017393] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.018640] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.018654] Kernel/User page tables isolation: enabled
[    0.018679] ftrace: allocating 46825 entries in 183 pages
[    0.027381] ftrace: allocated 183 pages with 6 groups
[    0.028278] Dynamic Preempt: none
[    0.028324] rcu: Preemptible hierarchical RCU implementation.
[    0.028325] rcu: 	RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_ids=
=3D2.
[    0.028327] 	Trampoline variant of Tasks RCU enabled.
[    0.028328] 	Rude variant of Tasks RCU enabled.
[    0.028328] 	Tracing variant of Tasks RCU enabled.
[    0.028329] rcu: RCU calculated value of scheduler-enlistment delay is 1=
0 jiffies.
[    0.028330] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.028336] RCU Tasks: Setting shift to 1 and lim to 1 rcu_task_cb_adjus=
t=3D1 rcu_task_cpu_ids=3D2.
[    0.028338] RCU Tasks Rude: Setting shift to 1 and lim to 1 rcu_task_cb_=
adjust=3D1 rcu_task_cpu_ids=3D2.
[    0.028339] RCU Tasks Trace: Setting shift to 1 and lim to 1 rcu_task_cb=
_adjust=3D1 rcu_task_cpu_ids=3D2.
[    0.032427] NR_IRQS: 524544, nr_irqs: 440, preallocated irqs: 16
[    0.032664] rcu: srcu_init: Setting srcu_struct sizes based on contentio=
n.
[    0.032720] Console: colour dummy device 80x25
[    0.032722] printk: legacy console [tty0] enabled
[    0.032818] printk: legacy console [ttyS0] enabled
[    0.032884] ACPI: Core revision 20240827
[    0.033070] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 30580167144 ns
[    0.033089] APIC: Switch to symmetric I/O mode setup
[    0.033518] x2apic enabled
[    0.033960] APIC: Switched APIC routing to: physical x2apic
[    0.035630] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles:=
 0x240933eba6e, max_idle_ns: 440795246008 ns
[    0.035635] Calibrating delay loop (skipped) preset value.. 4999.98 Bogo=
MIPS (lpj=3D24999940)
[    0.036010] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.036015] Last level dTLB entries: 4KB 64, 2MB 32, 4MB 32, 1GB 4
[    0.036019] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user=
 pointer sanitization
[    0.036022] Spectre V2 : Mitigation: Retpolines
[    0.036023] Spectre V2 : Spectre v2 / SpectreRSB: Filling RSB on context=
 switch and VMEXIT
[    0.036024] RETBleed: WARNING: Spectre v2 mitigation leaves CPU vulnerab=
le to RETBleed attacks, data leaks possible!
[    0.045633] RETBleed: Vulnerable
[    0.045633] Speculative Store Bypass: Vulnerable
[    0.045633] MDS: Vulnerable: Clear CPU buffers attempted, no microcode
[    0.045633] MMIO Stale Data: Vulnerable: Clear CPU buffers attempted, no=
 microcode
[    0.045633] GDS: Unknown: Dependent on hypervisor status
[    0.045633] active return thunk: its_return_thunk
[    0.045633] ITS: Mitigation: Aligned branch/return thunks
[    0.045633] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point=
 registers'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registe=
rs'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x020: 'AVX-512 opmask'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x040: 'AVX-512 Hi256'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x080: 'AVX-512 ZMM_Hi256'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x200: 'Protection Keys Us=
er registers'
[    0.045633] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.045633] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.045633] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.045633] x86/fpu: xstate_offset[5]:  960, xstate_sizes[5]:   64
[    0.045633] x86/fpu: xstate_offset[6]: 1024, xstate_sizes[6]:  512
[    0.045633] x86/fpu: xstate_offset[7]: 1536, xstate_sizes[7]: 1024
[    0.045633] x86/fpu: xstate_offset[9]: 2560, xstate_sizes[9]:    8
[    0.045633] x86/fpu: Enabled xstate features 0x2ff, context size is 2568=
 bytes, using 'compacted' format.
[    0.045633] Freeing SMP alternatives memory: 36K
[    0.045633] pid_max: default: 32768 minimum: 301
[    0.045633] memblock_free_late: [0x000000003d36b000-0x000000003d37bfff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b336000-0x000000003d36afff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b317000-0x000000003b335fff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b2f7000-0x000000003b316fff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b000000-0x000000003b1fffff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x00000000393de000-0x00000000393defff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x0000000038e73000-0x00000000390cdfff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] LSM: initializing lsm=3Dlockdown,capability,landlock,yama,sa=
fesetid,selinux,bpf,ima
[    0.045633] landlock: Up and running.
[    0.045633] Yama: becoming mindful.
[    0.045633] SELinux:  Initializing.
[    0.045633] LSM support for eBPF active
[    0.045633] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes,=
 linear)
[    0.045633] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 b=
ytes, linear)
[    0.045633] smpboot: CPU0: Intel(R) Xeon(R) Platinum 8259CL CPU @ 2.50GH=
z (family: 0x6, model: 0x55, stepping: 0x7)
[    0.045633] Performance Events: unsupported p6 CPU model 85 no PMU drive=
r, software events only.
[    0.045633] signal: max sigframe size: 3632
[    0.045633] rcu: Hierarchical SRCU implementation.
[    0.045633] rcu: 	Max phase no-delay instances is 1000.
[    0.045633] Timer migration: 1 hierarchy levels; 8 children per group; 1=
 crossnode level
[    0.045633] smp: Bringing up secondary CPUs ...
[    0.045633] smpboot: x86: Booting SMP configuration:
[    0.045633] .... node  #0, CPUs:      #1
[    0.045633] MDS CPU bug present and SMT on, data leak possible. See http=
s://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more de=
tails.
[    0.045633] MMIO Stale Data CPU bug present and SMT on, data leak possib=
le. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processo=
r_mmio_stale_data.html for more details.
[    0.045633] smp: Brought up 1 node, 2 CPUs
[    0.045633] smpboot: Total of 2 processors activated (9999.97 BogoMIPS)
[    0.045633] node 0 deferred pages initialised in 0ms
[    0.045633] Memory: 900460K/999468K available (16384K kernel code, 9440K=
 rwdata, 11364K rodata, 3740K init, 6440K bss, 94600K reserved, 0K cma-rese=
rved)
[    0.045633] devtmpfs: initialized
[    0.045633] x86/mm: Memory block size: 128MB
[    0.045633] ------------[ cut here ]------------
[    0.045633] page type is 1, passed migratetype is 0 (nr=3D16)
[    0.045633] WARNING: CPU: 1 PID: 2 at mm/page_alloc.c:721 rmqueue_bulk+0=
x82e/0x880
[    0.045633] Modules linked in:
[    0.045633] CPU: 1 UID: 0 PID: 2 Comm: kthreadd Not tainted 6.12.68-93.1=
23.amzn2023.x86_64 #1
[    0.045633] Hardware name: Amazon EC2 t3.micro/, BIOS 1.0 10/16/2017
[    0.045633] RIP: 0010:rmqueue_bulk+0x82e/0x880
[    0.045633] Code: c6 05 be be 13 02 01 e8 b0 b5 ff ff 44 89 e9 8b 14 24 =
48 c7 c7 a8 6d 51 8e 48 89 c6 b8 01 00 00 00 d3 e0 89 c1 e8 32 4f d2 ff <0f=
> 0b 4c 8b 44 24 48 e9 79 fc ff ff 48 c7 c6 e0 77 51 8e 4c 89 e7
[    0.045633] RSP: 0000:ffffd592c002f898 EFLAGS: 00010086
[    0.045633] RAX: 0000000000000000 RBX: ffff8e363b2cbc80 RCX: ffffffff8f1=
f0c68
[    0.045633] RDX: 0000000000000000 RSI: 00000000fffeffff RDI: 00000000000=
00001
[    0.045633] RBP: fffffb9c40e3a408 R08: 0000000000000000 R09: ffffd592c00=
2f740
[    0.045633] R10: ffffd592c002f738 R11: ffffffff8f370ca8 R12: fffffb9c40e=
3a400
[    0.045633] R13: 0000000000000004 R14: 0000000000000003 R15: 00000000000=
38e90
[    0.045633] FS:  0000000000000000(0000) GS:ffff8e3639f00000(0000) knlGS:=
0000000000000000
[    0.045633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.045633] CR2: 0000000000000000 CR3: 000000001bc34001 CR4: 00000000007=
706f0
[    0.045633] PKRU: 55555554
[    0.045633] Call Trace:
[    0.045633]  <TASK>
[    0.045633]  __rmqueue_pcplist+0x233/0x2c0
[    0.045633]  rmqueue.constprop.0+0x4b6/0xe80
[    0.045633]  ? _raw_spin_unlock+0xa/0x30
[    0.045633]  ? rmqueue.constprop.0+0x557/0xe80
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  get_page_from_freelist+0x16e/0x5f0
[    0.045633]  __alloc_pages_noprof+0x18a/0x350
[    0.045633]  alloc_pages_mpol_noprof+0xf2/0x1e0
[    0.045633]  ? shuffle_freelist+0x126/0x1b0
[    0.045633]  allocate_slab+0x2b3/0x410
[    0.045633]  ___slab_alloc+0x396/0x830
[    0.045633]  ? switch_hrtimer_base+0x8e/0x190
[    0.045633]  ? timerqueue_add+0x9b/0xc0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  ? start_dl_timer+0xb0/0x140
[    0.045633]  kmem_cache_alloc_node_noprof+0x271/0x2e0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  dup_task_struct+0x2d/0x1b0
[    0.045633]  copy_process+0x195/0x17e0
[    0.045633]  kernel_clone+0x9a/0x3b0
[    0.045633]  ? psi_task_switch+0x105/0x290
[    0.045633]  kernel_thread+0x6b/0x90
[    0.045633]  ? __pfx_kthread+0x10/0x10
[    0.045633]  kthreadd+0x276/0x2d0
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork+0x30/0x50
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork_asm+0x1a/0x30
[    0.045633]  </TASK>
[    0.045633] ---[ end trace 0000000000000000 ]---
[    0.045633] ------------[ cut here ]------------
[    0.045633] page type is 1, passed migratetype is 0 (nr=3D8)
[    0.045633] WARNING: CPU: 1 PID: 2 at mm/page_alloc.c:686 expand+0x1af/0=
x1e0
[    0.045633] Modules linked in:
[    0.045633] CPU: 1 UID: 0 PID: 2 Comm: kthreadd Tainted: G        W     =
     6.12.68-93.123.amzn2023.x86_64 #1
[    0.045633] Tainted: [W]=3DWARN
[    0.045633] Hardware name: Amazon EC2 t3.micro/, BIOS 1.0 10/16/2017
[    0.045633] RIP: 0010:expand+0x1af/0x1e0
[    0.045633] Code: c6 05 af 06 14 02 01 e8 9f fd ff ff 89 e9 8b 54 24 34 =
48 c7 c7 a8 6d 51 8e 48 89 c6 b8 01 00 00 00 d3 e0 89 c1 e8 21 97 d2 ff <0f=
> 0b e9 e5 fe ff ff 48 c7 c6 e0 6d 51 8e 4c 89 ff e8 eb 23 fc ff
[    0.045633] RSP: 0000:ffffd592c002f828 EFLAGS: 00010082
[    0.045633] RAX: 0000000000000000 RBX: ffff8e363b2cbc80 RCX: ffffffff8f1=
f0c68
[    0.045633] RDX: 0000000000000000 RSI: 00000000fffeffff RDI: 00000000000=
00001
[    0.045633] RBP: 0000000000000003 R08: 0000000000000000 R09: ffffd592c00=
2f6d0
[    0.045633] R10: ffffd592c002f6c8 R11: ffffffff8f370ca8 R12: 00000000000=
00008
[    0.045633] R13: 0000000000038e98 R14: 0000000000000003 R15: fffffb9c40e=
3a600
[    0.045633] FS:  0000000000000000(0000) GS:ffff8e3639f00000(0000) knlGS:=
0000000000000000
[    0.045633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.045633] CR2: 0000000000000000 CR3: 000000001bc34001 CR4: 00000000007=
706f0
[    0.045633] PKRU: 55555554
[    0.045633] Call Trace:
[    0.045633]  <TASK>
[    0.045633]  rmqueue_bulk+0x541/0x880
[    0.045633]  __rmqueue_pcplist+0x233/0x2c0
[    0.045633]  rmqueue.constprop.0+0x4b6/0xe80
[    0.045633]  ? _raw_spin_unlock+0xa/0x30
[    0.045633]  ? rmqueue.constprop.0+0x557/0xe80
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  get_page_from_freelist+0x16e/0x5f0
[    0.045633]  __alloc_pages_noprof+0x18a/0x350
[    0.045633]  alloc_pages_mpol_noprof+0xf2/0x1e0
[    0.045633]  ? shuffle_freelist+0x126/0x1b0
[    0.045633]  allocate_slab+0x2b3/0x410
[    0.045633]  ___slab_alloc+0x396/0x830
[    0.045633]  ? switch_hrtimer_base+0x8e/0x190
[    0.045633]  ? timerqueue_add+0x9b/0xc0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  ? start_dl_timer+0xb0/0x140
[    0.045633]  kmem_cache_alloc_node_noprof+0x271/0x2e0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  dup_task_struct+0x2d/0x1b0
[    0.045633]  copy_process+0x195/0x17e0
[    0.045633]  kernel_clone+0x9a/0x3b0
[    0.045633]  ? psi_task_switch+0x105/0x290
[    0.045633]  kernel_thread+0x6b/0x90
[    0.045633]  ? __pfx_kthread+0x10/0x10
[    0.045633]  kthreadd+0x276/0x2d0
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork+0x30/0x50
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork_asm+0x1a/0x30
[    0.045633]  </TASK>
[    0.045633] ---[ end trace 0000000000000000 ]---
[    0.045633] ACPI: PM: Registering ACPI NVS region [mem 0x3935e000-0x393d=
dfff] (524288 bytes)
[    0.045633] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 19112604462750000 ns
[    0.045633] futex hash table entries: 512 (order: 3, 32768 bytes, linear=
)
[    0.045633] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.045633] DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocat=
ions
[    0.045633] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA pool for atomic=
 allocations
[    0.045633] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA32 pool for atom=
ic allocations
[ec2-user@ip-172-31-29-240 ~]$ sudo dmesg
[    0.000000] Linux version 6.12.68-93.123.amzn2023.x86_64 (mockbuild@ip-1=
0-0-53-120) (gcc (GCC) 11.5.0 20240719 (Red Hat 11.5.0-5), GNU ld version 2=
.41-50.amzn2023.0.5) #1 SMP PREEMPT_DYNAMIC Tue Feb 10 06:40:43 UTC 2026
[    0.000000] Command line: BOOT_IMAGE=3D(hd0,gpt1)/boot/vmlinuz-6.12.68-9=
3.123.amzn2023.x86_64 root=3DUUID=3D7813e2d4-9cdc-416a-a749-25de8a9f36d0 ro=
 console=3Dtty0 console=3DttyS0,115200n8 nvme_core.io_timeout=3D4294967295 =
rd.emergency=3Dpoweroff rd.shell=3D0 selinux=3D1 security=3Dselinux quiet m=
emblock=3Ddebug
[    0.000000] KASLR enabled
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000390cdfff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x00000000390ce000-0x000000003934dfff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000003934e000-0x000000003935dfff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x000000003935e000-0x00000000393ddfff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000393de000-0x000000003d37bfff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000003d37c000-0x000000003d3fffff] reser=
ved
[    0.000000] memblock_reserve: [0x0000000039350040-0x000000003935060f] ef=
i_memblock_x86_reserve_range+0x159/0x1e0
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] APIC: Static calls initialized
[    0.000000] e820: update [mem 0x372be018-0x372c6e57] usable =3D=3D> usab=
le
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009ff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000372be0=
17] usable
[    0.000000] reserve setup_data: [mem 0x00000000372be018-0x00000000372c6e=
57] usable
[    0.000000] reserve setup_data: [mem 0x00000000372c6e58-0x00000000390cdf=
ff] usable
[    0.000000] reserve setup_data: [mem 0x00000000390ce000-0x000000003934df=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x000000003934e000-0x000000003935df=
ff] ACPI data
[    0.000000] reserve setup_data: [mem 0x000000003935e000-0x00000000393ddf=
ff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000393de000-0x000000003d37bf=
ff] usable
[    0.000000] reserve setup_data: [mem 0x000000003d37c000-0x000000003d3fff=
ff] reserved
[    0.000000] efi: EFI v2.7 by EDK II
[    0.000000] efi: SMBIOS=3D0x3926a000 ACPI=3D0x3935d000 ACPI 2.0=3D0x3935=
d014 MEMATTR=3D0x37a43a98=20
[    0.000000] memblock_reserve: [0x0000000037a43a98-0x0000000037a43e37] ef=
i_memattr_init+0x4d/0xa0
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Amazon EC2 t3.micro/, BIOS 1.0 10/16/2017
[    0.000000] DMI: Memory slots populated: 1/1
[    0.000000] Hypervisor detected: KVM
[    0.000000] last_pfn =3D 0x3d37c max_arch_pfn =3D 0x400000000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: using sched offset of 7715848997 cycles
[    0.000003] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles:=
 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000006] tsc: Detected 2499.994 MHz processor
[    0.000088] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000090] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000096] last_pfn =3D 0x3d37c max_arch_pfn =3D 0x400000000
[    0.000123] MTRR map: 4 entries (2 fixed + 2 variable; max 18), built fr=
om 8 variable MTRRs
[    0.000126] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT=
 =20
[    0.006943] memblock_reserve: [0x000000001d400000-0x000000001d40cfff] se=
tup_arch+0x953/0xad0
[    0.006950] memblock_add: [0x0000000000001000-0x000000000009ffff] e820__=
memblock_setup+0x6f/0xb0
[    0.006954] memblock_add: [0x0000000000100000-0x00000000372be017] e820__=
memblock_setup+0x6f/0xb0
[    0.006957] memblock_add: [0x00000000372be018-0x00000000372c6e57] e820__=
memblock_setup+0x6f/0xb0
[    0.006960] memblock_add: [0x00000000372c6e58-0x00000000390cdfff] e820__=
memblock_setup+0x6f/0xb0
[    0.006962] memblock_add: [0x00000000393de000-0x000000003d37bfff] e820__=
memblock_setup+0x6f/0xb0
[    0.006965] MEMBLOCK configuration:
[    0.006965]  memory size =3D 0x000000003d00b000 reserved size =3D 0x0000=
0000049ff7b0
[    0.006966]  memory.cnt  =3D 0x3
[    0.006967]  memory[0x0]	[0x0000000000001000-0x000000000009ffff], 0x0000=
00000009f000 bytes flags: 0x0
[    0.006969]  memory[0x1]	[0x0000000000100000-0x00000000390cdfff], 0x0000=
000038fce000 bytes flags: 0x0
[    0.006970]  memory[0x2]	[0x00000000393de000-0x000000003d37bfff], 0x0000=
000003f9e000 bytes flags: 0x0
[    0.006971]  reserved.cnt  =3D 0x7
[    0.006972]  reserved[0x0]	[0x0000000000000000-0x000000000000ffff], 0x00=
00000000010000 bytes flags: 0x0
[    0.006973]  reserved[0x1]	[0x000000000009f000-0x00000000000fffff], 0x00=
00000000061000 bytes flags: 0x0
[    0.006975]  reserved[0x2]	[0x000000001a000000-0x000000001d40cfff], 0x00=
0000000340d000 bytes flags: 0x0
[    0.006976]  reserved[0x3]	[0x000000003254f000-0x0000000033ac6fff], 0x00=
00000001578000 bytes flags: 0x0
[    0.006977]  reserved[0x4]	[0x00000000372be018-0x00000000372c6e57], 0x00=
00000000008e40 bytes flags: 0x0
[    0.006978]  reserved[0x5]	[0x0000000037a43a98-0x0000000037a43e37], 0x00=
000000000003a0 bytes flags: 0x0
[    0.006979]  reserved[0x6]	[0x0000000039350040-0x000000003935060f], 0x00=
000000000005d0 bytes flags: 0x0
[    0.006981] EFI XX 0x0000000038e73000..00000000390cdfff
[    0.006982] memblock_reserve: [0x0000000038e73000-0x00000000390cdfff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.006985] EFI XX 0x00000000393de000..00000000393defff
[    0.006986] memblock_reserve: [0x00000000393de000-0x00000000393defff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.006988] EFI XX 0x000000003b000000..000000003b1fffff
[    0.006989] memblock_reserve: [0x000000003b000000-0x000000003b1fffff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.006991] EFI XX 0x000000003b2f7000..000000003b316fff
[    0.006992] memblock_reserve: [0x000000003b2f7000-0x000000003b316fff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.006994] EFI XX 0x000000003b317000..000000003b335fff
[    0.006995] memblock_reserve: [0x000000003b317000-0x000000003b335fff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.006997] EFI XX 0x000000003b336000..000000003d36afff
[    0.006998] memblock_reserve: [0x000000003b336000-0x000000003d36afff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.007000] EFI XX 0x000000003d36b000..000000003d37bfff
[    0.007000] memblock_reserve: [0x000000003d36b000-0x000000003d37bfff] ef=
i_reserve_boot_services+0xc1/0x100
[    0.007004] memblock_phys_alloc_range: 28672 bytes align=3D0x1000 from=
=3D0x0000000000000000 max_addr=3D0x0000000000100000 reserve_real_mode+0x53/=
0x90
[    0.007008] memblock_reserve: [0x0000000000098000-0x000000000009efff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007012] memblock_reserve: [0x0000000000000000-0x00000000000fffff] se=
tup_arch+0x636/0xad0
[    0.007014] Using GB pages for direct mapping
[    0.007052] memblock_phys_alloc_range: 2097152 bytes align=3D0x200000 fr=
om=3D0x0000000000100000 max_addr=3D0x000000003d37c000 init_mem_mapping+0x14=
0/0x2c0
[    0.007055] memblock_reserve: [0x000000003ae00000-0x000000003affffff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007058] memblock_phys_free: [0x000000003ae00000-0x000000003affffff] =
init_mem_mapping+0x160/0x2c0
[    0.007261] Secure boot disabled
[    0.007261] RAMDISK: [mem 0x3254f000-0x33ac6fff]
[    0.007271] ACPI: Early table checksum verification disabled
[    0.007275] ACPI: RSDP 0x000000003935D014 000024 (v02 AMAZON)
[    0.007278] ACPI: XSDT 0x000000003935C0E8 00006C (v01 AMAZON AMZNFACP 00=
000001      01000013)
[    0.007283] ACPI: FACP 0x0000000039355000 000114 (v01 AMAZON AMZNFACP 00=
000001 AMZN 00000001)
[    0.007288] ACPI: DSDT 0x0000000039356000 00115A (v01 AMAZON AMZNDSDT 00=
000001 AMZN 00000001)
[    0.007291] ACPI: FACS 0x00000000393D0000 000040
[    0.007294] ACPI: WAET 0x000000003935B000 000028 (v01 AMAZON AMZNWAET 00=
000001 AMZN 00000001)
[    0.007296] ACPI: SLIT 0x000000003935A000 00006C (v01 AMAZON AMZNSLIT 00=
000001 AMZN 00000001)
[    0.007299] ACPI: APIC 0x0000000039359000 000076 (v01 AMAZON AMZNAPIC 00=
000001 AMZN 00000001)
[    0.007301] ACPI: SRAT 0x0000000039358000 0000A0 (v01 AMAZON AMZNSRAT 00=
000001 AMZN 00000001)
[    0.007304] ACPI: HPET 0x0000000039354000 000038 (v01 AMAZON AMZNHPET 00=
000001 AMZN 00000001)
[    0.007306] ACPI: SSDT 0x0000000039353000 000759 (v01 AMAZON AMZNSSDT 00=
000001 AMZN 00000001)
[    0.007309] ACPI: SSDT 0x0000000039352000 00007F (v01 AMAZON AMZNSSDT 00=
000001 AMZN 00000001)
[    0.007312] ACPI: BGRT 0x0000000039351000 000038 (v01 AMAZON AMAZON   00=
000002      01000013)
[    0.007314] ACPI: Reserving FACP table memory at [mem 0x39355000-0x39355=
113]
[    0.007315] memblock_reserve: [0x0000000039355000-0x0000000039355113] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007319] ACPI: Reserving DSDT table memory at [mem 0x39356000-0x39357=
159]
[    0.007320] memblock_reserve: [0x0000000039356000-0x0000000039357159] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007323] ACPI: Reserving FACS table memory at [mem 0x393d0000-0x393d0=
03f]
[    0.007323] memblock_reserve: [0x00000000393d0000-0x00000000393d003f] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007325] ACPI: Reserving WAET table memory at [mem 0x3935b000-0x3935b=
027]
[    0.007326] memblock_reserve: [0x000000003935b000-0x000000003935b027] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007328] ACPI: Reserving SLIT table memory at [mem 0x3935a000-0x3935a=
06b]
[    0.007329] memblock_reserve: [0x000000003935a000-0x000000003935a06b] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007331] ACPI: Reserving APIC table memory at [mem 0x39359000-0x39359=
075]
[    0.007332] memblock_reserve: [0x0000000039359000-0x0000000039359075] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007334] ACPI: Reserving SRAT table memory at [mem 0x39358000-0x39358=
09f]
[    0.007335] memblock_reserve: [0x0000000039358000-0x000000003935809f] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007337] ACPI: Reserving HPET table memory at [mem 0x39354000-0x39354=
037]
[    0.007338] memblock_reserve: [0x0000000039354000-0x0000000039354037] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007340] ACPI: Reserving SSDT table memory at [mem 0x39353000-0x39353=
758]
[    0.007341] memblock_reserve: [0x0000000039353000-0x0000000039353758] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007343] ACPI: Reserving SSDT table memory at [mem 0x39352000-0x39352=
07e]
[    0.007344] memblock_reserve: [0x0000000039352000-0x000000003935207e] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007346] ACPI: Reserving BGRT table memory at [mem 0x39351000-0x39351=
037]
[    0.007346] memblock_reserve: [0x0000000039351000-0x0000000039351037] ac=
pi_reserve_initial_tables+0x46/0x70
[    0.007398] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x3fffffff]
[    0.007407] memblock_alloc_try_nid: 1 bytes align=3D0x1000 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 numa_alloc_distance+0x1=
4a/0x200
[    0.007414] memblock_reserve: [0x000000003b2f6000-0x000000003b2f6000] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007421] NUMA: Initialized distance table, cnt=3D1
[    0.007430] memblock_reserve: [0x000000003b2cb680-0x000000003b2f5fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007433] NODE_DATA(0) allocated [mem 0x3b2cb680-0x3b2f5fff]
[    0.007452] MEMBLOCK configuration:
[    0.007452]  memory size =3D 0x000000003d00b000 reserved size =3D 0x0000=
000006f9bdd1
[    0.007453]  memory.cnt  =3D 0x3
[    0.007454]  memory[0x0]	[0x0000000000001000-0x000000000009ffff], 0x0000=
00000009f000 bytes on node 0 flags: 0x0
[    0.007456]  memory[0x1]	[0x0000000000100000-0x00000000390cdfff], 0x0000=
000038fce000 bytes on node 0 flags: 0x0
[    0.007458]  memory[0x2]	[0x00000000393de000-0x000000003d37bfff], 0x0000=
000003f9e000 bytes on node 0 flags: 0x0
[    0.007459]  reserved.cnt  =3D 0x18
[    0.007460]  reserved[0x0]	[0x0000000000000000-0x0000000000000fff], 0x00=
00000000001000 bytes flags: 0x0
[    0.007462]  reserved[0x1]	[0x0000000000001000-0x00000000000fffff], 0x00=
000000000ff000 bytes on node 0 flags: 0x0
[    0.007464]  reserved[0x2]	[0x000000001a000000-0x000000001d40cfff], 0x00=
0000000340d000 bytes on node 0 flags: 0x0
[    0.007465]  reserved[0x3]	[0x000000003254f000-0x0000000033ac6fff], 0x00=
00000001578000 bytes on node 0 flags: 0x0
[    0.007467]  reserved[0x4]	[0x00000000372be018-0x00000000372c6e57], 0x00=
00000000008e40 bytes on node 0 flags: 0x0
[    0.007468]  reserved[0x5]	[0x0000000037a43a98-0x0000000037a43e37], 0x00=
000000000003a0 bytes on node 0 flags: 0x0
[    0.007470]  reserved[0x6]	[0x0000000038e73000-0x00000000390cdfff], 0x00=
0000000025b000 bytes on node 0 flags: 0x0
[    0.007471]  reserved[0x7]	[0x0000000039350040-0x000000003935060f], 0x00=
000000000005d0 bytes on node 0 flags: 0x0
[    0.007473]  reserved[0x8]	[0x0000000039351000-0x0000000039351037], 0x00=
00000000000038 bytes on node 0 flags: 0x0
[    0.007474]  reserved[0x9]	[0x0000000039352000-0x000000003935207e], 0x00=
0000000000007f bytes on node 0 flags: 0x0
[    0.007475]  reserved[0xa]	[0x0000000039353000-0x0000000039353758], 0x00=
00000000000759 bytes on node 0 flags: 0x0
[    0.007477]  reserved[0xb]	[0x0000000039354000-0x0000000039354037], 0x00=
00000000000038 bytes on node 0 flags: 0x0
[    0.007478]  reserved[0xc]	[0x0000000039355000-0x0000000039355113], 0x00=
00000000000114 bytes on node 0 flags: 0x0
[    0.007479]  reserved[0xd]	[0x0000000039356000-0x0000000039357159], 0x00=
0000000000115a bytes on node 0 flags: 0x0
[    0.007480]  reserved[0xe]	[0x0000000039358000-0x000000003935809f], 0x00=
000000000000a0 bytes on node 0 flags: 0x0
[    0.007482]  reserved[0xf]	[0x0000000039359000-0x0000000039359075], 0x00=
00000000000076 bytes on node 0 flags: 0x0
[    0.007483]  reserved[0x10]	[0x000000003935a000-0x000000003935a06b], 0x0=
00000000000006c bytes on node 0 flags: 0x0
[    0.007485]  reserved[0x11]	[0x000000003935b000-0x000000003935b027], 0x0=
000000000000028 bytes on node 0 flags: 0x0
[    0.007487]  reserved[0x12]	[0x00000000393d0000-0x00000000393d003f], 0x0=
000000000000040 bytes on node 0 flags: 0x0
[    0.007488]  reserved[0x13]	[0x00000000393de000-0x00000000393defff], 0x0=
000000000001000 bytes on node 0 flags: 0x0
[    0.007490]  reserved[0x14]	[0x000000003b000000-0x000000003b1fffff], 0x0=
000000000200000 bytes on node 0 flags: 0x0
[    0.007491]  reserved[0x15]	[0x000000003b2cb680-0x000000003b2f5fff], 0x0=
00000000002a980 bytes flags: 0x0
[    0.007492]  reserved[0x16]	[0x000000003b2f6000-0x000000003b2f6000], 0x0=
000000000000001 bytes on node 0 flags: 0x0
[    0.007493]  reserved[0x17]	[0x000000003b2f7000-0x000000003d37bfff], 0x0=
000000002085000 bytes on node 0 flags: 0x0
[    0.007652] memblock_alloc_try_nid: 16384 bytes align=3D0x40 nid=3D-1 fr=
om=3D0x0000000000000000 max_addr=3D0x0000000000000000 memblocks_present+0x1=
d1/0x210
[    0.007655] memblock_reserve: [0x000000003b2c7680-0x000000003b2cb67f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007659] memblock_alloc_try_nid: 4096 bytes align=3D0x40 nid=3D0 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 sparse_index_alloc+0x44=
/0x70
[    0.007663] memblock_reserve: [0x000000003b2c6680-0x000000003b2c767f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007667] memblock_alloc_try_nid: 448 bytes align=3D0x40 nid=3D0 from=
=3D0x0000000038000000 max_addr=3D0x0000000040000000 sparse_init_nid+0x9b/0x=
4e0
[    0.007669] memblock_reserve: [0x000000003b2f6e40-0x000000003b2f6fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.007672] memblock_alloc_exact_nid_raw: 16777216 bytes align=3D0x20000=
0 nid=3D0 from=3D0x0000000001000000 max_addr=3D0x0000000000000000 memmap_al=
loc+0x1f/0x60
[    0.007675] memblock_reserve: [0x000000003a000000-0x000000003affffff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.009338] memblock_alloc_try_nid_raw: 4096 bytes align=3D0x1000 nid=3D=
0 from=3D0x0000000001000000 max_addr=3D0x0000000000000000 vmemmap_alloc_blo=
ck_zero.constprop.0+0x11/0x50
[    0.009345] memblock_reserve: [0x000000003b2c5000-0x000000003b2c5fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.009351] memblock_alloc_try_nid_raw: 4096 bytes align=3D0x1000 nid=3D=
0 from=3D0x0000000001000000 max_addr=3D0x0000000000000000 vmemmap_alloc_blo=
ck_zero.constprop.0+0x11/0x50
[    0.009354] memblock_reserve: [0x000000003b2c4000-0x000000003b2c4fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.009360] Zone ranges:
[    0.009361]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.009363]   DMA32    [mem 0x0000000001000000-0x000000003d37bfff]
[    0.009364]   Normal   empty
[    0.009365]   Device   empty
[    0.009366] Movable zone start for each node
[    0.009369] Early memory node ranges
[    0.009369]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.009371]   node   0: [mem 0x0000000000100000-0x00000000390cdfff]
[    0.009372]   node   0: [mem 0x00000000393de000-0x000000003d37bfff]
[    0.009373] Initmem setup node 0 [mem 0x0000000000001000-0x000000003d37b=
fff]
[    0.009378] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.009406] On node 0, zone DMA: 96 pages in unavailable ranges
[    0.009905] On node 0, zone DMA32: 784 pages in unavailable ranges
[    0.009994] On node 0, zone DMA32: 11396 pages in unavailable ranges
[    0.010412] ACPI: PM-Timer IO Port: 0xb008
[    0.010424] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.010480] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-=
23
[    0.010482] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.010484] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.010486] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level=
)
[    0.010487] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level=
)
[    0.010490] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.010491] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.010492] memblock_alloc_try_nid: 73 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 acpi_parse_hpet+0x91/0x=
150
[    0.010498] memblock_reserve: [0x000000003b2f6dc0-0x000000003b2f6e08] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010503] TSC deadline timer available
[    0.010508] CPU topo: Max. logical packages:   1
[    0.010509] CPU topo: Max. logical dies:       1
[    0.010509] CPU topo: Max. dies per package:   1
[    0.010514] CPU topo: Max. threads per core:   2
[    0.010515] CPU topo: Num. cores per package:     1
[    0.010516] CPU topo: Num. threads per package:   2
[    0.010516] CPU topo: Allowing 2 present CPUs plus 0 hotplug CPUs
[    0.010518] memblock_alloc_try_nid: 75 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 io_apic_init_mappings+0=
x41/0x1e0
[    0.010522] memblock_reserve: [0x000000003b2f6d40-0x000000003b2f6d8a] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010539] kvm-guest: APIC: eoi() replaced with kvm_guest_apic_eoi_writ=
e()
[    0.010547] memblock_alloc_try_nid: 640 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 e820__reserve_resources=
+0x2e/0x1f0
[    0.010552] memblock_reserve: [0x000000003b2f6ac0-0x000000003b2f6d3f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010556] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010560] memblock_reserve: [0x000000003b2f6a40-0x000000003b2f6aa7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010563] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010566] memblock_reserve: [0x000000003b2f69c0-0x000000003b2f6a27] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010569] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010572] memblock_reserve: [0x000000003b2f6940-0x000000003b2f69a7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010574] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010577] memblock_reserve: [0x000000003b2f68c0-0x000000003b2f6927] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010580] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010583] memblock_reserve: [0x000000003b2f6840-0x000000003b2f68a7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010585] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010588] memblock_reserve: [0x000000003b2f67c0-0x000000003b2f6827] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010591] memblock_alloc_try_nid: 104 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 firmware_map_add_early+=
0x2c/0x60
[    0.010593] memblock_reserve: [0x000000003b2f6740-0x000000003b2f67a7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010596] memblock_alloc_try_nid: 32 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 register_nosave_region+=
0x53/0xe0
[    0.010601] memblock_reserve: [0x000000003b2f6700-0x000000003b2f671f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010604] PM: hibernation: Registered nosave memory: [mem 0x00000000-0=
x00000fff]
[    0.010605] memblock_alloc_try_nid: 32 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 register_nosave_region+=
0x53/0xe0
[    0.010608] memblock_reserve: [0x000000003b2f66c0-0x000000003b2f66df] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010611] PM: hibernation: Registered nosave memory: [mem 0x000a0000-0=
x000fffff]
[    0.010611] memblock_alloc_try_nid: 32 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 register_nosave_region+=
0x53/0xe0
[    0.010615] memblock_reserve: [0x000000003b2f6680-0x000000003b2f669f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.010617] PM: hibernation: Registered nosave memory: [mem 0x390ce000-0=
x393ddfff]
[    0.010619] [mem 0x3d400000-0xffffffff] available for PCI devices
[    0.010621] Booting paravirtualized kernel on KVM
[    0.010623] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 19112604462750000 ns
[    0.015925] memblock_alloc_try_nid: 265 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 setup_command_line+0x71=
/0x230
[    0.015933] memblock_reserve: [0x000000003b2f6540-0x000000003b2f6648] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.015937] memblock_alloc_try_nid: 265 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 setup_command_line+0xa4=
/0x230
[    0.015940] memblock_reserve: [0x000000003b2f6400-0x000000003b2f6508] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.015944] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.015954] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_build_alloc_inf=
o+0x2e1/0x5c0
[    0.015958] memblock_reserve: [0x000000003b2c3000-0x000000003b2c3fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.015961] memblock_alloc_try_nid: 4096 bytes align=3D0x40 nid=3D-1 fro=
m=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_embed_first_chunk=
+0x7a/0x580
[    0.015964] memblock_reserve: [0x000000003b2c2000-0x000000003b2c2fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.015968] memblock_alloc_try_nid: 2097152 bytes align=3D0x200000 nid=
=3D0 from=3D0x0000000001000000 max_addr=3D0x0000000000000000 pcpu_fc_alloc+=
0x101/0x170
[    0.015971] memblock_reserve: [0x0000000039e00000-0x0000000039ffffff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016206] memblock_phys_free: [0x0000000039e41000-0x0000000039efffff] =
pcpu_embed_first_chunk+0x1e6/0x580
[    0.016229] memblock_phys_free: [0x0000000039f41000-0x0000000039ffffff] =
pcpu_embed_first_chunk+0x1e6/0x580
[    0.016231] percpu: Embedded 65 pages/cpu s229376 r8192 d28672 u1048576
[    0.016233] memblock_alloc_try_nid: 8 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_setup_first_chunk+=
0xc3/0x900
[    0.016236] memblock_reserve: [0x000000003b2f63c0-0x000000003b2f63c7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016239] memblock_alloc_try_nid: 8 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_setup_first_chunk+=
0xee/0x900
[    0.016242] memblock_reserve: [0x000000003b2f6380-0x000000003b2f6387] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016244] memblock_alloc_try_nid: 8 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_setup_first_chunk+=
0x120/0x900
[    0.016247] memblock_reserve: [0x000000003b2f6340-0x000000003b2f6347] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016250] memblock_alloc_try_nid: 16 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_setup_first_chunk+=
0x156/0x900
[    0.016253] memblock_reserve: [0x000000003b2f6300-0x000000003b2f630f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016256] pcpu-alloc: s229376 r8192 d28672 u1048576 alloc=3D1*2097152
[    0.016258] pcpu-alloc: [0] 0 1=20
[    0.016261] memblock_alloc_try_nid: 352 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_setup_first_chunk+=
0x707/0x900
[    0.016264] memblock_reserve: [0x000000003b2f6180-0x000000003b2f62df] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016266] memblock_alloc_try_nid: 264 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x76/0x2f0
[    0.016269] memblock_reserve: [0x000000003b2f6040-0x000000003b2f6147] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016272] memblock_alloc_try_nid: 256 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0xee/0x2f0
[    0.016275] memblock_reserve: [0x000000003b2c6580-0x000000003b2c667f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016278] memblock_alloc_try_nid: 264 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x129/0x2f0
[    0.016280] memblock_reserve: [0x000000003b2c6440-0x000000003b2c6547] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016283] memblock_alloc_try_nid: 64 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x15a/0x2f0
[    0.016286] memblock_reserve: [0x000000003b2c6400-0x000000003b2c643f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016289] memblock_alloc_try_nid: 264 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x76/0x2f0
[    0.016291] memblock_reserve: [0x000000003b2c62c0-0x000000003b2c63c7] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016294] memblock_alloc_try_nid: 896 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0xee/0x2f0
[    0.016297] memblock_reserve: [0x000000003b2c1c80-0x000000003b2c1fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016300] memblock_alloc_try_nid: 904 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x129/0x2f0
[    0.016303] memblock_reserve: [0x000000003b2c18c0-0x000000003b2c1c47] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016305] memblock_alloc_try_nid: 224 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 pcpu_alloc_first_chunk+=
0x15a/0x2f0
[    0.016308] memblock_reserve: [0x000000003b2c61c0-0x000000003b2c629f] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016311] memblock_phys_free: [0x000000003b2c3000-0x000000003b2c3fff] =
pcpu_embed_first_chunk+0x26c/0x580
[    0.016314] memblock_phys_free: [0x000000003b2c2000-0x000000003b2c2fff] =
pcpu_embed_first_chunk+0x279/0x580
[    0.016317] memblock_alloc_try_nid: 8 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 alloc_bootmem_cpumask_v=
ar+0x2a/0x60
[    0.016320] memblock_reserve: [0x000000003b2c6180-0x000000003b2c6187] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016323] memblock_alloc_try_nid: 8 bytes align=3D0x40 nid=3D-1 from=
=3D0x0000000000000000 max_addr=3D0x0000000000000000 alloc_bootmem_cpumask_v=
ar+0x2a/0x60
[    0.016325] memblock_reserve: [0x000000003b2c6140-0x000000003b2c6147] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.016996] kvm-guest: PV spinlocks enabled
[    0.016997] memblock_alloc_try_nid: 4096 bytes align=3D0x40 nid=3D-1 fro=
m=3D0x0000000000000000 max_addr=3D0x0000000000000000 alloc_large_system_has=
h+0x232/0x2d0
[    0.017000] memblock_reserve: [0x000000003b2c3000-0x000000003b2c3fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017004] PV qspinlock hash table entries: 256 (order: 0, 4096 bytes, =
linear)
[    0.017006] Kernel command line: BOOT_IMAGE=3D(hd0,gpt1)/boot/vmlinuz-6.=
12.68-93.123.amzn2023.x86_64 root=3DUUID=3D7813e2d4-9cdc-416a-a749-25de8a9f=
36d0 ro console=3Dtty0 console=3DttyS0,115200n8 nvme_core.io_timeout=3D4294=
967295 rd.emergency=3Dpoweroff rd.shell=3D0 selinux=3D1 security=3Dselinux =
quiet memblock=3Ddebug
[    0.017133] random: crng init done
[    0.017136] memblock_alloc_try_nid: 1048576 bytes align=3D0x40 nid=3D-1 =
from=3D0x0000000000000000 max_addr=3D0x0000000000000000 alloc_large_system_=
hash+0x232/0x2d0
[    0.017139] memblock_reserve: [0x0000000039d00000-0x0000000039dfffff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017255] Dentry cache hash table entries: 131072 (order: 8, 1048576 b=
ytes, linear)
[    0.017257] memblock_alloc_try_nid: 524288 bytes align=3D0x40 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 alloc_large_system_h=
ash+0x232/0x2d0
[    0.017261] memblock_reserve: [0x000000003b2418c0-0x000000003b2c18bf] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017314] Inode-cache hash table entries: 65536 (order: 7, 524288 byte=
s, linear)
[    0.017318] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017323] memblock_reserve: [0x000000003b2c2000-0x000000003b2c2fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017326] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017328] memblock_reserve: [0x000000003b240000-0x000000003b240fff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017331] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017334] memblock_reserve: [0x000000003b23f000-0x000000003b23ffff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017347] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017350] memblock_reserve: [0x000000003b23e000-0x000000003b23efff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017353] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017356] memblock_reserve: [0x000000003b23d000-0x000000003b23dfff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017361] memblock_alloc_try_nid: 4096 bytes align=3D0x1000 nid=3D-1 f=
rom=3D0x0000000000000000 max_addr=3D0x0000000000000000 spp_getpage+0x51/0xa=
0
[    0.017364] memblock_reserve: [0x000000003b23c000-0x000000003b23cfff] me=
mblock_alloc_range_nid+0xbf/0x180
[    0.017388] Fallback order for Node 0: 0=20
[    0.017391] Built 1 zonelists, mobility grouping on.  Total pages: 24986=
7
[    0.017392] Policy zone: DMA32
[    0.017393] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.018640] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.018654] Kernel/User page tables isolation: enabled
[    0.018679] ftrace: allocating 46825 entries in 183 pages
[    0.027381] ftrace: allocated 183 pages with 6 groups
[    0.028278] Dynamic Preempt: none
[    0.028324] rcu: Preemptible hierarchical RCU implementation.
[    0.028325] rcu: 	RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_ids=
=3D2.
[    0.028327] 	Trampoline variant of Tasks RCU enabled.
[    0.028328] 	Rude variant of Tasks RCU enabled.
[    0.028328] 	Tracing variant of Tasks RCU enabled.
[    0.028329] rcu: RCU calculated value of scheduler-enlistment delay is 1=
0 jiffies.
[    0.028330] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.028336] RCU Tasks: Setting shift to 1 and lim to 1 rcu_task_cb_adjus=
t=3D1 rcu_task_cpu_ids=3D2.
[    0.028338] RCU Tasks Rude: Setting shift to 1 and lim to 1 rcu_task_cb_=
adjust=3D1 rcu_task_cpu_ids=3D2.
[    0.028339] RCU Tasks Trace: Setting shift to 1 and lim to 1 rcu_task_cb=
_adjust=3D1 rcu_task_cpu_ids=3D2.
[    0.032427] NR_IRQS: 524544, nr_irqs: 440, preallocated irqs: 16
[    0.032664] rcu: srcu_init: Setting srcu_struct sizes based on contentio=
n.
[    0.032720] Console: colour dummy device 80x25
[    0.032722] printk: legacy console [tty0] enabled
[    0.032818] printk: legacy console [ttyS0] enabled
[    0.032884] ACPI: Core revision 20240827
[    0.033070] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 30580167144 ns
[    0.033089] APIC: Switch to symmetric I/O mode setup
[    0.033518] x2apic enabled
[    0.033960] APIC: Switched APIC routing to: physical x2apic
[    0.035630] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles:=
 0x240933eba6e, max_idle_ns: 440795246008 ns
[    0.035635] Calibrating delay loop (skipped) preset value.. 4999.98 Bogo=
MIPS (lpj=3D24999940)
[    0.036010] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.036015] Last level dTLB entries: 4KB 64, 2MB 32, 4MB 32, 1GB 4
[    0.036019] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user=
 pointer sanitization
[    0.036022] Spectre V2 : Mitigation: Retpolines
[    0.036023] Spectre V2 : Spectre v2 / SpectreRSB: Filling RSB on context=
 switch and VMEXIT
[    0.036024] RETBleed: WARNING: Spectre v2 mitigation leaves CPU vulnerab=
le to RETBleed attacks, data leaks possible!
[    0.045633] RETBleed: Vulnerable
[    0.045633] Speculative Store Bypass: Vulnerable
[    0.045633] MDS: Vulnerable: Clear CPU buffers attempted, no microcode
[    0.045633] MMIO Stale Data: Vulnerable: Clear CPU buffers attempted, no=
 microcode
[    0.045633] GDS: Unknown: Dependent on hypervisor status
[    0.045633] active return thunk: its_return_thunk
[    0.045633] ITS: Mitigation: Aligned branch/return thunks
[    0.045633] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point=
 registers'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registe=
rs'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x020: 'AVX-512 opmask'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x040: 'AVX-512 Hi256'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x080: 'AVX-512 ZMM_Hi256'
[    0.045633] x86/fpu: Supporting XSAVE feature 0x200: 'Protection Keys Us=
er registers'
[    0.045633] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.045633] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.045633] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.045633] x86/fpu: xstate_offset[5]:  960, xstate_sizes[5]:   64
[    0.045633] x86/fpu: xstate_offset[6]: 1024, xstate_sizes[6]:  512
[    0.045633] x86/fpu: xstate_offset[7]: 1536, xstate_sizes[7]: 1024
[    0.045633] x86/fpu: xstate_offset[9]: 2560, xstate_sizes[9]:    8
[    0.045633] x86/fpu: Enabled xstate features 0x2ff, context size is 2568=
 bytes, using 'compacted' format.
[    0.045633] Freeing SMP alternatives memory: 36K
[    0.045633] pid_max: default: 32768 minimum: 301
[    0.045633] memblock_free_late: [0x000000003d36b000-0x000000003d37bfff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b336000-0x000000003d36afff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b317000-0x000000003b335fff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b2f7000-0x000000003b316fff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b000000-0x000000003b1fffff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x00000000393de000-0x00000000393defff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x0000000038e73000-0x00000000390cdfff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] LSM: initializing lsm=3Dlockdown,capability,landlock,yama,sa=
fesetid,selinux,bpf,ima
[    0.045633] landlock: Up and running.
[    0.045633] Yama: becoming mindful.
[    0.045633] SELinux:  Initializing.
[    0.045633] LSM support for eBPF active
[    0.045633] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes,=
 linear)
[    0.045633] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 b=
ytes, linear)
[    0.045633] smpboot: CPU0: Intel(R) Xeon(R) Platinum 8259CL CPU @ 2.50GH=
z (family: 0x6, model: 0x55, stepping: 0x7)
[    0.045633] Performance Events: unsupported p6 CPU model 85 no PMU drive=
r, software events only.
[    0.045633] signal: max sigframe size: 3632
[    0.045633] rcu: Hierarchical SRCU implementation.
[    0.045633] rcu: 	Max phase no-delay instances is 1000.
[    0.045633] Timer migration: 1 hierarchy levels; 8 children per group; 1=
 crossnode level
[    0.045633] smp: Bringing up secondary CPUs ...
[    0.045633] smpboot: x86: Booting SMP configuration:
[    0.045633] .... node  #0, CPUs:      #1
[    0.045633] MDS CPU bug present and SMT on, data leak possible. See http=
s://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more de=
tails.
[    0.045633] MMIO Stale Data CPU bug present and SMT on, data leak possib=
le. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processo=
r_mmio_stale_data.html for more details.
[    0.045633] smp: Brought up 1 node, 2 CPUs
[    0.045633] smpboot: Total of 2 processors activated (9999.97 BogoMIPS)
[    0.045633] node 0 deferred pages initialised in 0ms
[    0.045633] Memory: 900460K/999468K available (16384K kernel code, 9440K=
 rwdata, 11364K rodata, 3740K init, 6440K bss, 94600K reserved, 0K cma-rese=
rved)
[    0.045633] devtmpfs: initialized
[    0.045633] x86/mm: Memory block size: 128MB
[    0.045633] ------------[ cut here ]------------
[    0.045633] page type is 1, passed migratetype is 0 (nr=3D16)
[    0.045633] WARNING: CPU: 1 PID: 2 at mm/page_alloc.c:721 rmqueue_bulk+0=
x82e/0x880
[    0.045633] Modules linked in:
[    0.045633] CPU: 1 UID: 0 PID: 2 Comm: kthreadd Not tainted 6.12.68-93.1=
23.amzn2023.x86_64 #1
[    0.045633] Hardware name: Amazon EC2 t3.micro/, BIOS 1.0 10/16/2017
[    0.045633] RIP: 0010:rmqueue_bulk+0x82e/0x880
[    0.045633] Code: c6 05 be be 13 02 01 e8 b0 b5 ff ff 44 89 e9 8b 14 24 =
48 c7 c7 a8 6d 51 8e 48 89 c6 b8 01 00 00 00 d3 e0 89 c1 e8 32 4f d2 ff <0f=
> 0b 4c 8b 44 24 48 e9 79 fc ff ff 48 c7 c6 e0 77 51 8e 4c 89 e7
[    0.045633] RSP: 0000:ffffd592c002f898 EFLAGS: 00010086
[    0.045633] RAX: 0000000000000000 RBX: ffff8e363b2cbc80 RCX: ffffffff8f1=
f0c68
[    0.045633] RDX: 0000000000000000 RSI: 00000000fffeffff RDI: 00000000000=
00001
[    0.045633] RBP: fffffb9c40e3a408 R08: 0000000000000000 R09: ffffd592c00=
2f740
[    0.045633] R10: ffffd592c002f738 R11: ffffffff8f370ca8 R12: fffffb9c40e=
3a400
[    0.045633] R13: 0000000000000004 R14: 0000000000000003 R15: 00000000000=
38e90
[    0.045633] FS:  0000000000000000(0000) GS:ffff8e3639f00000(0000) knlGS:=
0000000000000000
[    0.045633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.045633] CR2: 0000000000000000 CR3: 000000001bc34001 CR4: 00000000007=
706f0
[    0.045633] PKRU: 55555554
[    0.045633] Call Trace:
[    0.045633]  <TASK>
[    0.045633]  __rmqueue_pcplist+0x233/0x2c0
[    0.045633]  rmqueue.constprop.0+0x4b6/0xe80
[    0.045633]  ? _raw_spin_unlock+0xa/0x30
[    0.045633]  ? rmqueue.constprop.0+0x557/0xe80
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  get_page_from_freelist+0x16e/0x5f0
[    0.045633]  __alloc_pages_noprof+0x18a/0x350
[    0.045633]  alloc_pages_mpol_noprof+0xf2/0x1e0
[    0.045633]  ? shuffle_freelist+0x126/0x1b0
[    0.045633]  allocate_slab+0x2b3/0x410
[    0.045633]  ___slab_alloc+0x396/0x830
[    0.045633]  ? switch_hrtimer_base+0x8e/0x190
[    0.045633]  ? timerqueue_add+0x9b/0xc0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  ? start_dl_timer+0xb0/0x140
[    0.045633]  kmem_cache_alloc_node_noprof+0x271/0x2e0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  dup_task_struct+0x2d/0x1b0
[    0.045633]  copy_process+0x195/0x17e0
[    0.045633]  kernel_clone+0x9a/0x3b0
[    0.045633]  ? psi_task_switch+0x105/0x290
[    0.045633]  kernel_thread+0x6b/0x90
[    0.045633]  ? __pfx_kthread+0x10/0x10
[    0.045633]  kthreadd+0x276/0x2d0
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork+0x30/0x50
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork_asm+0x1a/0x30
[    0.045633]  </TASK>
[    0.045633] ---[ end trace 0000000000000000 ]---
[    0.045633] ------------[ cut here ]------------
[    0.045633] page type is 1, passed migratetype is 0 (nr=3D8)
[    0.045633] WARNING: CPU: 1 PID: 2 at mm/page_alloc.c:686 expand+0x1af/0=
x1e0
[    0.045633] Modules linked in:
[    0.045633] CPU: 1 UID: 0 PID: 2 Comm: kthreadd Tainted: G        W     =
     6.12.68-93.123.amzn2023.x86_64 #1
[    0.045633] Tainted: [W]=3DWARN
[    0.045633] Hardware name: Amazon EC2 t3.micro/, BIOS 1.0 10/16/2017
[    0.045633] RIP: 0010:expand+0x1af/0x1e0
[    0.045633] Code: c6 05 af 06 14 02 01 e8 9f fd ff ff 89 e9 8b 54 24 34 =
48 c7 c7 a8 6d 51 8e 48 89 c6 b8 01 00 00 00 d3 e0 89 c1 e8 21 97 d2 ff <0f=
> 0b e9 e5 fe ff ff 48 c7 c6 e0 6d 51 8e 4c 89 ff e8 eb 23 fc ff
[    0.045633] RSP: 0000:ffffd592c002f828 EFLAGS: 00010082
[    0.045633] RAX: 0000000000000000 RBX: ffff8e363b2cbc80 RCX: ffffffff8f1=
f0c68
[    0.045633] RDX: 0000000000000000 RSI: 00000000fffeffff RDI: 00000000000=
00001
[    0.045633] RBP: 0000000000000003 R08: 0000000000000000 R09: ffffd592c00=
2f6d0
[    0.045633] R10: ffffd592c002f6c8 R11: ffffffff8f370ca8 R12: 00000000000=
00008
[    0.045633] R13: 0000000000038e98 R14: 0000000000000003 R15: fffffb9c40e=
3a600
[    0.045633] FS:  0000000000000000(0000) GS:ffff8e3639f00000(0000) knlGS:=
0000000000000000
[    0.045633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.045633] CR2: 0000000000000000 CR3: 000000001bc34001 CR4: 00000000007=
706f0
[    0.045633] PKRU: 55555554
[    0.045633] Call Trace:
[    0.045633]  <TASK>
[    0.045633]  rmqueue_bulk+0x541/0x880
[    0.045633]  __rmqueue_pcplist+0x233/0x2c0
[    0.045633]  rmqueue.constprop.0+0x4b6/0xe80
[    0.045633]  ? _raw_spin_unlock+0xa/0x30
[    0.045633]  ? rmqueue.constprop.0+0x557/0xe80
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  get_page_from_freelist+0x16e/0x5f0
[    0.045633]  __alloc_pages_noprof+0x18a/0x350
[    0.045633]  alloc_pages_mpol_noprof+0xf2/0x1e0
[    0.045633]  ? shuffle_freelist+0x126/0x1b0
[    0.045633]  allocate_slab+0x2b3/0x410
[    0.045633]  ___slab_alloc+0x396/0x830
[    0.045633]  ? switch_hrtimer_base+0x8e/0x190
[    0.045633]  ? timerqueue_add+0x9b/0xc0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  ? start_dl_timer+0xb0/0x140
[    0.045633]  kmem_cache_alloc_node_noprof+0x271/0x2e0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  dup_task_struct+0x2d/0x1b0
[    0.045633]  copy_process+0x195/0x17e0
[    0.045633]  kernel_clone+0x9a/0x3b0
[    0.045633]  ? psi_task_switch+0x105/0x290
[    0.045633]  kernel_thread+0x6b/0x90
[    0.045633]  ? __pfx_kthread+0x10/0x10
[    0.045633]  kthreadd+0x276/0x2d0
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork+0x30/0x50
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork_asm+0x1a/0x30
[    0.045633]  </TASK>
[    0.045633] ---[ end trace 0000000000000000 ]---
[    0.045633] ACPI: PM: Registering ACPI NVS region [mem 0x3935e000-0x393d=
dfff] (524288 bytes)
[    0.045633] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 19112604462750000 ns
[    0.045633] futex hash table entries: 512 (order: 3, 32768 bytes, linear=
)
[    0.045633] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.045633] DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocat=
ions
[    0.045633] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA pool for atomic=
 allocations
[    0.045633] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA32 pool for atom=
ic allocations


