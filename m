Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D808B606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BCyW+ugr
Received: by kanga.kvack.org (Postfix)
	id 802206B06D1; Fri, 13 Nov 2026 06:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B736B06D3; Fri, 13 Nov 2026 06:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62CA86B06D4; Fri, 13 Nov 2026 06:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE416B06D1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:26:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A000F1C4160
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:26:55 +0000 (UTC)
X-FDA: 85429868790.16.7A659E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 05D3E40009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:26:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BCyW+ugr;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794569214;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNVDJNW68qYanO+QjhN5fd6AD0pgmTBig6q6k608mqE=;
	b=JbWgMaQ9JxSocu3OkUT+Fn5BmIxkr2aE7E0j2JIr2BmdTD07nYuXWoOrlo4LXvTejH/auR
	6LLbCWCIKp7G+K0LPo2jZ6GyJVji8q9tw++OADlGEO6eNJXJR2iAz0gf+vD1hbIzUrDUGn
	JxRjgY28r6uRRhkVdABJv8z5DfIhQaU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BCyW+ugr;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794569214;
	b=PMmEjKnfE0EkqEZ9oTsOdwPg6szngvdWWq7rYVLqZRKyuRCsv31UcplGXLx7yclo5yeIXI
	B9lRqjs3m+ygCn8Ko62/eTj0YA3sAydil8Ll0HxHdWASACiTiIrDTZu3QUuxzj2ct6PZQc
	PFL81wztMcpH7nRsgIcJWLSjUrNBm5k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84BE262700;
	Fri, 13 Nov 2026 11:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D831F000C9;
	Fri, 13 Nov 2026 11:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794569213;
	bh=RNVDJNW68qYanO+QjhN5fd6AD0pgmTBig6q6k608mqE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BCyW+ugroGbduzPBP17/J3lRg/g+XrUX6DbR3UwqG+P4PrsQyrcyE7tAKxW4INQKj
	 FdT4CVHAEQJGImy4d7QIM209mP4kiPcIIofO/iyyv+dwxPm1rFUFEUPclifWqJfiMY
	 va9bZNC/41j8pMkG7urqxdRvq5lpWOcDZPrx+WSrqUqfCSpMn15KW59uL9NTnUaOq5
	 mU6HX/BLoB0sjxl8gssXdJUJisc9PBR0JiXkqitZPdglePg0QVoAcGy643crUDHGZn
	 byqhLR6uHTSfEK71GDVg+paTKWUWQngPX7RxZqEktD4bn4rst8VpiAlKpHws89k8mk
	 a14s/TD3lhHsQ==
Message-ID: <sashiko-outbox-212719@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/6] arch/*: increase lowmem size to avoid highmem
 use
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arnd Bergmann" <arnd@kernel.org>, linux-mm@kvack.org
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Andrew Morton" <akpm@linux-foundation.org>, "Andreas
 Larsson" <andreas@gaisler.com>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1Mg?=
 =?utf-8?b?R1JPVVAp?= <chleroy@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Linus Walleij" <linus.walleij@linaro.org>,
 =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Malin
 Jonsson" <malin.jonsson@est.tech>, "Richard Weinberger" <richard@nod.at>, "Russell
 King" <linux@armlinux.org.uk>, x86@kernel.org, "Thomas Gleixner" <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, "Madhavan Srinivasan" <maddy@linux.ibm.com>, "Michael
 Ellerman" <mpe@ellerman.id.au>, "Nicholas Piggin" <npiggin@gmail.com>, "Michal
 Simek" <monstr@monstr.eu>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Nishanth Menon" <nm@ti.com>, "Lucas Stach" <l.stach@pengutronix.de>
In-Reply-To: <20261112112528.1116405-6-arnd@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-6-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 11:26:51 +0000
X-Stat-Signature: qba5m7ear5mi3tc669x3do8dybf1zchg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 05D3E40009
X-HE-Tag: 1794569213-948867
X-HE-Meta: U2FsdGVkX181/88chej0F6E/NY1Ab7qQTSSbAZCTbZ85FfDoib+iWuWoVEhSjv4r1mHyMTpr9vBCsYA1Nvo6qRy+JKZ2LzM3s/VcSHJJQGwjqaxW8FDn9JG+JeVATtWPpqvcWB2Vr6U5JiGCUk6JfDgxWRKXyCDZEPHv8zj46Y/qWeEH21b8Wb+vBYbNWH1gWvpkQHwODx9cdTFpLsT7oiTlaWOWti8WQ7jDJyrTU0m/eeW/cikKRwiydzCupQ4dkpm3VLw3Z/0vuUwbJv7cyoW/FDwaIXCOehUUhzNqu/EmWl4F5J2ouRkgy+eltrFWoJk3w1GgD/CLnXwCIHh9zmdq9HU3x6mUuoIXmlDZ1aNj9IjBhK5px95tvAbTm3rLVBELRKNH0ZcV2ciNS2r2kBn9Hq6j2RW7APq4kUN9CRMKDYaO6E0F6CQnMNn15eeOm/NDpdl7rs0W/FHdTq5BjScByNcBlzbc/oMcJZHyFK2H1xeIuFUE9b/sgfD9druY3aSKWLzK2VaY+aD8i9KsKxcOqhjzZRh22DkIVr99NaDO7CmBrcy0D/I7G9LT3GzSrmVyEHjFiq5+WwbfL+p9Cmcn7eXTUcXZWZu6ZabBjw3kyVlQEsTJikGN0n9Cp8zOWmsw0qrACRpGz1QUoL4M4gCPyKQolLnzm6eOGrxwOUYhIcoHJHYjCnhnybBEiTTncn4El4NWaTUoizsHpE9ujTHSnP74Motbw30dDsDj9No+jwwSJODoTlj7Qj4B+bpMM8NFV6lIe413r7DxoYpZbFSyylKm+KYIT0gX+pLxvuyPRQzDhkLBJ7i5/3LOTcsUyJGwtOpaG4IPcNFeSapmJAAvFZa59ITOevcm8a1EWflOdgBbMSKTXzPc6a3hJghhz5aGr+lyJQlW8ync8joCdaynIJ0NVgY/NTDRW6GLfpRFpc5OS0uRs6P7AqvUH1+nx9tUPdVbY8Wedg3ffLV
 8UJZOD9f
 jbb+eUqYwNw7SXGLXON3YLupSi2mQz/Uo2pWTYMcbBVTnrhF2uaCu1zh4V6jhb8hPR1LV3wf1BtnslytFP7kwicESFQO7yqx1dsUVksN4ExI0x8lViRldTfBL6DGPfkiPUeIUQWTASrydYlPIv2V/F2L0I5VVnRrbqSPopMMiX1QdyGh/EVFf+t8uOuckn8ywIEsp9/AYmSHG4EJuOqFqfni1gqkF5UZFfvUxmdHQYXQTPEADWItM7f2OGJC7C6w73qIQ637PDC8CQWOXcm3F1Xx/0JVIP40GsGBEefzK3J2LHTEP1zHJuI/yiAN9MWEt2ig+NuNWhUKGDfHFjDWE0Fz9zEgYLJSbkuJ/hHuOayzG5vAyqth6w2FwW9W/PscstsLCTcMHn/Y9LeqdHjqefkHsY6zVXH4JICCj7vKZ33VIXGwKQ0EGae5aGgjRvYYG/6EBM9lePh6EKGop9YyvJlAMr8jI1MpRo9eZ6nMhoy+YEnaA154ZLrcYjYE5UkWv2mA+9VbOvbKkMFNzmLT8UXg5LL3iTElo8lRjcuHAvk7+P9NEZTjCUyKgtlItM5kCB1yzRpGHCkb9luFyVPn5wzajpAldfCftGDG8L9tCnrt5befdlRDQQBk7BQCYUXnCDPTAZI2UGCHnIkvhI4MPMkjA5O7Raj8rXCx9umn1bG7gS3YCWteVV+2fw+8HglANhwrWrutalts7hHY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 9 potential
issues to consider:
- [High] powerpc: 85xx LOWMEM_CAM_NUM and PAGE_OFFSET cap lowmem at 768
  MiB
- [High] ARM: omap2: dropping HIGHMEM select limits multi_v7 and
  omap2plus to 1 GiB
- [High] KVM: PPC: e500: get_host_mas0() hits kernel TLB with
  PAGE_OFFSET 0x70000000
- [High] powerpc/47x: 2 GiB LOWMEM_SIZE triggers BUG_ON in
  ppc47x_pin_tlb()
- [High] KVM: PPC: BookE: hardcoded 0xc0000000 host IVPR breaks new
  KERNEL_START
- [High] KVM: PPC: Book3S: LOAD_HOST_SEGMENTS leaves kernel SRs 7..11
  unrestored
- [Medium] powerpc/kasan: 32-bit HIGHMEM lowmem overlaps KASAN shadow
  and fixmap
- [Medium] ARM: config: aspeed_g5: dropping HIGHMEM truncates 2 GiB
  AST2600 RAM
- [Medium] ARM: pxa: hardcoded 0xc0000000 dereference in
  pxa3xx_cpu_pm_suspend()
--

commit bedc943a8dd41812a1db37560a98b5754effd200
Author: Arnd Bergmann <arnd@arndb.de>

arch/*: increase lowmem size to avoid highmem use

This commit changes the default 32-bit virtual memory split on ARM, x86,
PowerPC, and MicroBlaze to provide 1 GiB of lowmem without HIGHMEM and up
to 1.75 GiB or 2 GiB of lowmem with HIGHMEM, and drops CONFIG_HIGHMEM from
several platform configs and defconfigs.

> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 93350d2e51b99..fee6b7435b7ca 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1027,7 +1027,8 @@ config BL_SWITCHER_DUMMY_IF
>  choice
>  	prompt "Memory split"
>  	depends on MMU
> -	default VMSPLIT_3G
> +	default VMSPLIT_2G if HIGHMEM || ARM_LPAE
> +	default VMSPLIT_3G_OPT

[Severity: Medium]
Does switching the non-HIGHMEM default to VMSPLIT_3G_OPT (PAGE_OFFSET =3D
0xb0000000) break suspend-to-RAM on PXA3xx?

In pxa_pm_enter() -> pxa3xx_cpu_pm_enter() -> pxa3xx_cpu_pm_suspend(), the
code saves the first word of SDRAM and writes the physical resume address
for the boot ROM using a hardcoded 0xc0000000 virtual address instead of
PAGE_OFFSET:

arch/arm/mach-pxa/pxa3xx.c:pxa3xx_cpu_pm_suspend() {
	volatile unsigned long *p =3D (volatile void *)0xc0000000;
	unsigned long saved_data =3D *p;
...
	*p =3D __pa_symbol(cpu_resume);
}

On PXA3xx boards with 64 MiB or 128 MiB of RAM (such as pxa3xx_defconfig),
0xc0000000 is now in the vmalloc area rather than the start of SDRAM, so
entering PM_SUSPEND_MEM faults or corrupts vmalloc memory.

[ ... ]

> diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspe=
ed_g5_defconfig
> index 45b937419dbda..5c5d831df36ab 100644
> --- a/arch/arm/configs/aspeed_g5_defconfig
> +++ b/arch/arm/configs/aspeed_g5_defconfig
> @@ -27,7 +27,6 @@ CONFIG_SMP=3Dy
>  # CONFIG_ARM_CPU_TOPOLOGY is not set
>  CONFIG_VMSPLIT_2G=3Dy
>  CONFIG_NR_CPUS=3D2
> -CONFIG_HIGHMEM=3Dy

[Severity: Medium]
Does dropping CONFIG_HIGHMEM=3Dy from aspeed_g5_defconfig truncate RAM on
2 GiB AST2600 boards?

Despite its name, aspeed_g5_defconfig also enables CONFIG_MACH_ASPEED_G6=3Dy
and explicitly selects CONFIG_VMSPLIT_2G=3Dy.  Commit 4cdabee7d6d2 ("ARM:
configs: aspeed_g5: Enable AST2600") enabled CONFIG_HIGHMEM=3Dy here because
AST2600 boards (such as aspeed-ast2600-evb.dts) have 2 GiB of RAM, while
CONFIG_VMSPLIT_2G=3Dy without HIGHMEM only maps at most 1.75 GiB of lowmem
after reserving space for vmalloc, ioremap, and fixmap.

[ ... ]

> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index f0f1d7a8640ca..d145e448a6b80 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -135,7 +135,6 @@ config ARCH_OMAP2PLUS_TYPICAL
>  	bool "Typical OMAP configuration"
>  	default y
>  	select AEABI
> -	select HIGHMEM if !CPU_CACHE_VIVT
>  	select I2C
>  	select I2C_OMAP
>  	select MENELAUS if ARCH_OMAP2

[Severity: High]
Does removing this select silently disable CONFIG_HIGHMEM in both
multi_v7_defconfig and omap2plus_defconfig?

Neither defconfig contains an explicit CONFIG_HIGHMEM=3Dy line because both
enable ARCH_OMAP2PLUS_TYPICAL, which previously selected HIGHMEM.  With
this line removed, both defconfigs build with CONFIG_HIGHMEM=3Dn and fall
back to CONFIG_VMSPLIT_3G_OPT=3Dy, limiting all 1.5 GiB to 4 GiB ARMv7
boards booted with multi_v7_defconfig or omap2plus_defconfig to 1 GiB of
RAM.

[ ... ]

> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 2580e27e43287..dfc4f518c6fb4 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig

[ ... ]

> @@ -1193,7 +1194,8 @@ config LOWMEM_SIZE_BOOL
> =20
>  config LOWMEM_SIZE
>  	hex "Maximum low memory size (in bytes)" if LOWMEM_SIZE_BOOL
> -	default "0x30000000"
> +	default "0x80000000" if HIGHMEM
> +	default "0x40000000"

[Severity: High]
On PPC_85xx, doesn't CONFIG_LOWMEM_CAM_NUM still cap lowmem at 768 MiB?

Right below LOWMEM_SIZE, LOWMEM_CAM_NUM still defaults to 3 (or 9/12/15
with STRICT_KERNEL_RWX, where the first 256 MiB uses 7/10/13 smaller CAMs).
Furthermore, because the new PAGE_OFFSET defaults (0xb0000000 and
0x70000000) are only 256 MiB-aligned, calc_cam_sz() bounds each CAM to
1UL << __ffs(virt | phys), which is at most 256 MiB at every 256 MiB
boundary.  As a result, MMU_init() -> adjust_total_lowmem() ->
map_mem_in_cams() still caps __max_low_memory at 3 * 256 MiB =3D 768 MiB:
non-HIGHMEM 85xx builds (including ksi8560_defconfig and stx_gp3_defconfig)
discard RAM above 768 MiB via memblock_enforce_memory_limit(), while
HIGHMEM 85xx builds shrink TASK_SIZE to 1.75 GiB without gaining any
lowmem.

[Severity: High]
Can a 2 GiB LOWMEM_SIZE trigger a boot BUG_ON in ppc47x_pin_tlb() on
PPC_47x systems with more than 1.5 GiB of RAM?

Unlike 85xx, 44x/47x does not call adjust_total_lowmem(), so mmu_mapin_ram()
pins 256 MiB TLB entries in a loop up to lowmem_end_addr (now up to 2 GiB
when HIGHMEM=3Dy, such as in currituck_defconfig).  However, PPC47x hardware
only has 6 bolted TLB slots in ppc47x_find_free_bolted() (5 if
CONFIG_PPC_EARLY_DEBUG_44x=3Dy uses slot 5), covering at most 1.5 GiB (or
1.25 GiB) before ppc47x_pin_tlb() hits BUG_ON(bolted < 0).  In addition,
dropping CONFIG_HIGHMEM=3Dy from arch/powerpc/configs/44x/akebono_defconfig
limits the IBM Akebono PPC476GTR board, which supports multi-gigabyte DDR3
configurations via SWIOTLB, to 1 GiB of RAM.

> @@ -1245,7 +1247,8 @@ config PAGE_OFFSET_BOOL
> =20
>  config PAGE_OFFSET
>  	hex "Virtual address of memory base" if PAGE_OFFSET_BOOL
> -	default "0xc0000000"
> +	default "0x70000000" if HIGHMEM
> +	default "0xb0000000"

[Severity: Medium]
When both CONFIG_HIGHMEM=3Dy and CONFIG_KASAN=3Dy are enabled on 32-bit
PowerPC, does lowmem overlap the KASAN shadow and fixmap regions?

With PAGE_OFFSET at 0x70000000 and LOWMEM_SIZE at 0x80000000, lowmem can
extend up to 0xf0000000.  However, KASAN_SHADOW_OFFSET is fixed at
0xe0000000 in arch/powerpc/Kconfig.debug, which places KASAN_SHADOW_START
at 0xec000000 (with CONFIG_EXECMEM=3Dy) or 0xee000000 (with CONFIG_EXECMEM=
=3Dn)
and places FIXADDR_TOP, PKMAP_BASE, and VMALLOC_END below
KASAN_SHADOW_START, colliding with lowmem on systems with ~1.9 GiB or more
of RAM and triggering a boot BUG_ON in map_kernel_page().

[Severity: High]
With PAGE_OFFSET=3D0x70000000, can get_host_mas0() in the e500 KVM host MMU
match and overwrite a host kernel TLB entry instead of forcing a miss?

arch/powerpc/kvm/e500_mmu_host.c:get_host_mas0() {
	local_irq_save(flags);
	mtspr(SPRN_MAS6, 0);
	mas4 =3D mfspr(SPRN_MAS4);
	mtspr(SPRN_MAS4, mas4 & ~MAS4_TLBSEL_MASK);
	asm volatile("tlbsx 0, %0" : : "b" (eaddr & ~CONFIG_PAGE_OFFSET));
	mas0 =3D mfspr(SPRN_MAS0);
}

get_host_mas0() masks eaddr with ~CONFIG_PAGE_OFFSET to produce a userspace
address (< PAGE_OFFSET) that is guaranteed to miss in PID 0.  When
CONFIG_PAGE_OFFSET is 0x70000000, ~CONFIG_PAGE_OFFSET is 0x8fffffff, so any
guest eaddr >=3D 0x80000000 masks to 0x80000000..0x8fffffff, which lies
inside the host kernel linear mapping (>=3D 0x70000000) and can hit and
overwrite an active host kernel TLB entry in write_host_tlbe().

>  config KERNEL_START_BOOL
>  	bool "Set custom kernel base address"
> @@ -1261,8 +1264,9 @@ config KERNEL_START_BOOL
>  config KERNEL_START
>  	hex "Virtual address of kernel base" if KERNEL_START_BOOL
>  	default PAGE_OFFSET if PAGE_OFFSET_BOOL
> -	default "0xc2000000" if CRASH_DUMP && !NONSTATIC_KERNEL
> -	default "0xc0000000"
> +	default "0x72000000" if HIGHMEM && CRASH_DUMP && !NONSTATIC_KERNEL
> +	default "0xb2000000" if CRASH_DUMP && !NONSTATIC_KERNEL
> +	default PAGE_OFFSET

[Severity: High]
Does changing the default KERNEL_START away from 0xc0000000 break KVM guest
exit on 32-bit Book-E hosts?

On 85xx and 44x, interrupt_base is linked at KERNEL_START (now 0xb0000000
or 0x70000000 by default), but kvmppc_resume_host in
arch/powerpc/kvm/booke_interrupts.S restores the host SPRN_IVPR to a
hardcoded 0xc0000000:

	/* Restore host IVPR before re-enabling interrupts. We cheat and know
	 * that Linux IVPR is always 0xc0000000. */
	lis	r3, 0xc000
	mtspr	SPRN_IVPR, r3

The first host interrupt or exception after guest exit will jump to
0xc0000000 + IVOR offset instead of interrupt_base and crash the host.

> @@ -1298,7 +1302,7 @@ config TASK_SIZE_BOOL
>  config TASK_SIZE
>  	hex "Size of maximum user task space" if TASK_SIZE_BOOL
>  	default "0x80000000" if PPC_8xx
> -	default "0xc0000000"
> +	default PAGE_OFFSET

[Severity: High]
On 32-bit Book3S KVM hosts, does lowering TASK_SIZE and PAGE_OFFSET leave
host kernel segment registers 7..11 (or 11) unrestored on guest exit?

LOAD_GUEST_SEGMENTS in arch/powerpc/kvm/book3s_32_sr.S overwrites all 16
segment registers with guest values, but LOAD_HOST_SEGMENTS only restores
the 4 segment registers 0xc..0xf (0xc0000000..0xffffffff):

arch/powerpc/kvm/book3s_32_sr.S:LOAD_HOST_SEGMENTS {
        li      r0, 4
        mtctr   r0
	LOAD_REG_IMMEDIATE(r3, 0x20000000 | (0x111 * 0xc))
        lis     r4, 0xc000
3:      mtsrin  r3, r4
        addi    r3, r3, 0x111     /* increment VSID */
        addis   r4, r4, 0x1000    /* address of next segment */
        bdnz    3b
}

Because switch_mmu_context() -> update_user_segments() only reloads
0 .. NUM_USER_SEGMENTS - 1 (segments 0..10 when TASK_SIZE is 0xb0000000, or
0..6 when TASK_SIZE is 0x70000000), the host kernel segments covering
0xb0000000..0xbfffffff (or 0x70000000..0xbfffffff, plus any module/execmem
segment below PAGE_OFFSET) retain guest segment register values after
exiting the guest.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112112528.1116=
405-1-arnd@kernel.org?part=3D5

