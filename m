Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C33F4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57AD6B009E; Fri, 10 Apr 2026 08:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08166B009F; Fri, 10 Apr 2026 08:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD01B6B00A0; Fri, 10 Apr 2026 08:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC8496B009E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 574651B7ECA
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:09 +0000 (UTC)
X-FDA: 84642550818.10.2DB4F5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 95E46C0008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RN1rF/li";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823547; a=rsa-sha256;
	cv=none;
	b=hd8DL11ARRImRuRMJNTKe6vg8US1L9jSOWcAWzswzaAlTiy8DLpX2mWrREWKvHQCu1QFrY
	R/crpfJ51orHwns3TscPfgDYCmG9nsgTw30sKdYX8e6YDQAe4XLn+UZx1Us2VWwpeshoWF
	0XqfShng685hXDqvTnb7Co22THe/pCw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RN1rF/li";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=SH5UDza4spQjzd3RSMUyPWLUXEHp2wuekQCGvQe/6zk=;
	b=U0+QLjKo7J5qtQskrHepWDGwyc2VUvTvIsRCj6gNCCU3rF9kTH2LcSGs9p4tI8H+EW2Yph
	cr7ky1eloQI8vZpwlH8VftbtRHhQUSeM/oWY4CoX8szM0S6LW0jKByysoUWsaX4yrmmjeR
	BRtfKkhF4L0NJtuKsAwXq8XiRdx9eXU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 95C4F40B4D;
	Fri, 10 Apr 2026 12:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDE4C2BCB3;
	Fri, 10 Apr 2026 12:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823546;
	bh=e1hr7RxQAtfkXxmpOByj9AnE8rprLs7FfW1VJuycE3U=;
	h=Date:From:To:Subject:References:cc:From;
	b=RN1rF/lik/IDDm6vfArIXRWDzYeJ5FOTg7VZhjC87W8dEFx4XOLkGFYYWGhN5FSAp
	 UgUW5oHG+RoyFDJ2Lb8wy9bLXZ629e0sIZHO26a4htp9GCeP67dTQge4t3eD4oDh93
	 1M2FHKCxNFZC0Fzd0yadwA9xaercjxCXri8tQar5sfr/ENoprWWJO3/MtUJLqRehkg
	 l/QzejVV1juchHtR/6u+RSlRsRj9VAJZETUAE3E4ZTRyX1FMMGjRx2pW1U9TsOYtOg
	 Iiw1IsbQmNZnTrKZs9AZodQQ0gykTA14aWPgbU/9QJFDHI9V1VA1cDQRoqdiQlL5WN
	 Y1nwRLUUSmSZw==
Date: Fri, 10 Apr 2026 14:19:03 +0200
Message-ID: <20260410120318.045532623@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 07/38] treewide: Consolidate cycles_t
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
cc: Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
X-Stat-Signature: cyaoba4whg9wdmohwgq4igbapm3giqp5
X-Rspamd-Queue-Id: 95E46C0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775823547-537305
X-HE-Meta: U2FsdGVkX1+esknaXlDVAPfQQ8GtgbkjGzPcivdK3XG8GnYMNc3tZTyM1vI3ABTa286m8fKMfGL8+d7LwnoQMSJNPV6OGuhaYv2kIqQNV+J9pUzbtNo0uoBisGfW8VFu3PKhI6QlL2vEjOCp25+9p6jmkN2SNGbKAb6O2mUVlVQOGhoRT90XLN+7uTwji1qGLHNPhRkRQOw9MneV/Glq+a7kElwNvfg7bzs5eKDF9mBqhF9eyEUGRKJev2+IwCP4BKNggTm8+RdUkb2Cn7+B+Zf0vuCzMaO4TokPxg1A95gVlw70YF9Q9NWthbOvWEGRH3oXijL08pYgLQir5+g/VX6aMgW+qRNyvE03BACi2jbnHEIavP0jF4GOTdvL/NNarkDlm7HsbjI5ls+eraiH7U144D6VynGm/Zmpjy7hCgFJDHtT1qYf/BTYANMJCeb6GOikZ8R49Y5+9dhZmHKJh3liZV5p5Tadt4aonsFQeYgZ22bEv+WKtok31M98Yx0GKbr3YnaWG4fVVNdNgo8rSCxrLX6hRk7OMOv/dtcSSiEz0m0j86e1SKQP7yCHeBXncKa5uanu1tP8WOZKAk7CCyb50td5Ex+fbLu4ueY7nx6c+6NZqmN0ObigbcLshwMXY+uh2gtcmUxMRvRDWlH6mXFGQucMwgy56rSnjlj9m400cf1gnLXys2mVss6h1KYbYtYr7q0yI7om+n57lH89h6gW1uva0hW0KjA4BihcOxlF9l/YN/fdSd9FGrbKkYrjo60FchkQUfi607Xf317i8C7wo18Nnh1Sr0gf1Ef47mcJLrXQHjZv5paMpR48/7u0qgCFAl5BSQzlf+m7qdpdD0civDAhWpB1WiLH60DJuSUoU0L7KtjMZ1PmJU2TKoIea5D2ZI9RXLz8RH67wfdbc2E6sszpVjLALwhl2U68Mh7SvGmJbrzhNnkZGyfYzmICUt9l6PmuL0Sdez6/W74
 jmKUq8xr
 3qLUCS1JeYaM08BNpKUeL3cPHn2S/eQmDTQV9YGFucz5l6hO+PMAKV62VqCf2X4l6WYF2tZcdN9XlSCLLWearBSaxQjnRCWjzikCbyl1CSoBaJ9+UrpsxZIUjgLe8l7CX1a289X2tDz5z3mKeQJbI7/sonqe4W4nsc9TGYjxg2kDOjdLmI1ixGWUpmDPeidU18SpTH/b9QQAGzIJ8m2Rndj0J6/oqHLVHrGmAA4QXlrU5bVBjmZOkBh82zPq38/3AiipzZGXHsJFstTChaOSziRLeXxTshMCO/Kw9IIYrUxbrACIcHu/+JLbsdmMUZBueTjn6IjSGFxs9FUORpCwemyZ8qSy8aG02Z2umqCo402zaZx6ZvyQP3l3gVj9JQ/LdRsQV4pW+AGlYUR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Most architectures define cycles_t as unsigned long execpt:

 - x86 requires it to be 64-bit independent of the 32-bit/64-bit build.

 - parisc and mips define it as unsigned int

   parisc has no real reason to do so as there are only a few usage sites
   which either expand it to a 64-bit value or utilize only the lower
   32bits.

   mips has no real requirement either.

Move the typedef to types.h and provide a config switch to enforce the
64-bit type for x86.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
 arch/Kconfig                       |    4 ++++
 arch/alpha/include/asm/timex.h     |    3 ---
 arch/arm/include/asm/timex.h       |    1 -
 arch/loongarch/include/asm/timex.h |    2 --
 arch/m68k/include/asm/timex.h      |    2 --
 arch/mips/include/asm/timex.h      |    2 --
 arch/nios2/include/asm/timex.h     |    2 --
 arch/parisc/include/asm/timex.h    |    2 --
 arch/powerpc/include/asm/timex.h   |    4 +---
 arch/riscv/include/asm/timex.h     |    2 --
 arch/s390/include/asm/timex.h      |    2 --
 arch/sparc/include/asm/timex_64.h  |    1 -
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/tsc.h         |    2 --
 include/asm-generic/timex.h        |    1 -
 include/linux/types.h              |    6 ++++++
 16 files changed, 12 insertions(+), 25 deletions(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -360,6 +360,10 @@ config ARCH_HAS_DMA_SET_UNCACHED
 config ARCH_HAS_DMA_CLEAR_UNCACHED
 	bool
 
+# cycles_t is always 64bit wide
+config ARCH_HAS_CYCLES_T_64
+	bool
+
 config ARCH_HAS_CPU_FINALIZE_INIT
 	bool
 
--- a/arch/alpha/include/asm/timex.h
+++ b/arch/alpha/include/asm/timex.h
@@ -15,9 +15,6 @@
  * But this only means we'll force a reschedule every 8 seconds or so,
  * which isn't an evil thing.
  */
-
-typedef unsigned int cycles_t;
-
 static inline cycles_t get_cycles (void)
 {
 	cycles_t ret;
--- a/arch/arm/include/asm/timex.h
+++ b/arch/arm/include/asm/timex.h
@@ -9,7 +9,6 @@
 #ifndef _ASMARM_TIMEX_H
 #define _ASMARM_TIMEX_H
 
-typedef unsigned long cycles_t;
 // Temporary workaround
 bool delay_read_timer(unsigned long *t);
 
--- a/arch/loongarch/include/asm/timex.h
+++ b/arch/loongarch/include/asm/timex.h
@@ -12,8 +12,6 @@
 #include <asm/cpu.h>
 #include <asm/cpu-features.h>
 
-typedef unsigned long cycles_t;
-
 #define get_cycles get_cycles
 
 static inline cycles_t get_cycles(void)
--- a/arch/m68k/include/asm/timex.h
+++ b/arch/m68k/include/asm/timex.h
@@ -7,8 +7,6 @@
 #ifndef _ASMm68K_TIMEX_H
 #define _ASMm68K_TIMEX_H
 
-typedef unsigned long cycles_t;
-
 static inline cycles_t get_cycles(void)
 {
 	return 0;
--- a/arch/mips/include/asm/timex.h
+++ b/arch/mips/include/asm/timex.h
@@ -29,8 +29,6 @@
  * We know that all SMP capable CPUs have cycle counters.
  */
 
-typedef unsigned int cycles_t;
-
 /*
  * On R4000/R4400 an erratum exists such that if the cycle counter is
  * read in the exact moment that it is matching the compare register,
--- a/arch/nios2/include/asm/timex.h
+++ b/arch/nios2/include/asm/timex.h
@@ -5,8 +5,6 @@
 #ifndef _ASM_NIOS2_TIMEX_H
 #define _ASM_NIOS2_TIMEX_H
 
-typedef unsigned long cycles_t;
-
 extern cycles_t get_cycles(void);
 #define get_cycles get_cycles
 
--- a/arch/parisc/include/asm/timex.h
+++ b/arch/parisc/include/asm/timex.h
@@ -9,8 +9,6 @@
 
 #include <asm/special_insns.h>
 
-typedef unsigned long cycles_t;
-
 static inline cycles_t get_cycles(void)
 {
 	return mfctl(16);
--- a/arch/powerpc/include/asm/timex.h
+++ b/arch/powerpc/include/asm/timex.h
@@ -11,9 +11,7 @@
 #include <asm/cputable.h>
 #include <asm/vdso/timebase.h>
 
-typedef unsigned long cycles_t;
-
-static inline cycles_t get_cycles(void)
+ostatic inline cycles_t get_cycles(void)
 {
 	return mftb();
 }
--- a/arch/riscv/include/asm/timex.h
+++ b/arch/riscv/include/asm/timex.h
@@ -8,8 +8,6 @@
 
 #include <asm/csr.h>
 
-typedef unsigned long cycles_t;
-
 #ifdef CONFIG_RISCV_M_MODE
 
 #include <asm/clint.h>
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -177,8 +177,6 @@ static inline void local_tick_enable(uns
 	set_clock_comparator(get_lowcore()->clock_comparator);
 }
 
-typedef unsigned long cycles_t;
-
 static __always_inline unsigned long get_tod_clock(void)
 {
 	union tod_clock clk;
--- a/arch/sparc/include/asm/timex_64.h
+++ b/arch/sparc/include/asm/timex_64.h
@@ -10,7 +10,6 @@
 #include <asm/timer.h>
 
 /* Getting on the cycle counter on sparc64. */
-typedef unsigned long cycles_t;
 #define get_cycles()	tick_ops->get_tick()
 
 #endif
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -79,6 +79,7 @@ config X86
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CPU_PASID		if IOMMU_SVA
 	select ARCH_HAS_CURRENT_STACK_POINTER
+	select ARCH_HAS_CYCLES_T_64
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE	if !X86_PAE
 	select ARCH_HAS_DELAY_TIMER
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -67,8 +67,6 @@ static __always_inline u64 rdtsc_ordered
 /*
  * Standard way to access the cycle counter.
  */
-typedef unsigned long long cycles_t;
-
 extern unsigned int cpu_khz;
 extern unsigned int tsc_khz;
 
--- a/include/asm-generic/timex.h
+++ b/include/asm-generic/timex.h
@@ -5,7 +5,6 @@
 /*
  * If you have a cycle counter, return the value here.
  */
-typedef unsigned long cycles_t;
 #ifndef get_cycles
 static inline cycles_t get_cycles(void)
 {
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -270,5 +270,11 @@ struct rcuwait {
 	struct task_struct __rcu *task;
 };
 
+#ifdef CONFIG_ARCH_HAS_CYCLES_T_64
+typedef unsigned long long	cycles_t;
+#else
+typedef unsigned long		cycles_t;
+#endif
+
 #endif /*  __ASSEMBLY__ */
 #endif /* _LINUX_TYPES_H */


