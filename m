Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA589F44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CEBC6B00CD; Fri, 10 Apr 2026 08:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47FD86B00CF; Fri, 10 Apr 2026 08:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E4E6B00D0; Fri, 10 Apr 2026 08:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 240946B00CD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F20FF1A04F8
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:50 +0000 (UTC)
X-FDA: 84642555060.21.A859DDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4447740003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2TX+7hq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=3WqzD1BC+z45VcMri6kLvM7P1mn3ZaD16FZdnQ1IdlQ=;
	b=qpl7kKU8eKUJiHLm1utwU6ys2tNoIftuQAWOzVK8E0LnhcPq2m7TvTo6Me23r63wLv5IKg
	B76wK8gFTjhEQvY6kHCUFucNG/8Ao0MEFBkUYdHO/D7bZ13CH/yN06avNoaLAn88i3Yeji
	6dNCI6rIg7x/nvw1CzUknsYCtHiIC5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823649; a=rsa-sha256;
	cv=none;
	b=mH7SpoF3qG4AW6rUmRVYys7mrbZ+SPOPQB2FRGA8GPuUwlLNMWDth1Ftf7fsJ41drgtfoT
	bbzkdZGdYtOoQtKCx3y77Ntgarxha1UenKJPsLMDj9Sg6I814VP4VMt3bt3MJVbuwrc8kG
	Ai2fEQ5DEF4IAYyFU7AXT1Kdc+9UnLs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2TX+7hq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7012141780;
	Fri, 10 Apr 2026 12:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9315FC19425;
	Fri, 10 Apr 2026 12:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823648;
	bh=Rixu9UkxBpBa/pCcYjAm91Mos3e7PJEWty4VuN8Giko=;
	h=Date:From:To:Subject:References:cc:From;
	b=e2TX+7hqQyBiWzo8NI5NRXrCTX+aQLO1om6YbdKnBp1t6r+3gdVVwFgSRp0YguQNn
	 Jlc+qQUu+TDLRhNxs0vDUgKc/64bw4Xr/nrLXGcr9x8N+WxcYYAWKz/hetumLTTXiH
	 IOZQe6vf3JeallzAbQOuDlVku9VS3q2KBCLecHsxJ+DIPpUILukw8IDg9/7PZ2ubbz
	 C8W0nQsdyxy0TL4ubCO16dsYj5itsv1q3iQDjbYKDrJAHUzFBqI36jq5cjES+sc4w7
	 L7ELcmmojjtISrbWTN6OaCnE72An4bb94Nrrp4eO37cDQXx+zCdhzTRuhaN3nbGiT3
	 axWFURoe64Leg==
Date: Fri, 10 Apr 2026 14:20:45 +0200
Message-ID: <20260410120319.462206386@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 28/38] mips: Select ARCH_HAS_RANDOM_ENTROPY
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
X-Rspamd-Queue-Id: 4447740003
X-Stat-Signature: mijpbb86iy89ezppgstdcbgms8kydkqk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775823649-916472
X-HE-Meta: U2FsdGVkX18YeBfEvw1s01UeBxYSbXIm1mENFt4KB2rWTAithNnqynHZ7+xscOdbafm4s5jGJR30tZgRdtpcK13jWjfNS0HqKTbBZio31h8w9SstVjkd4CKheIk1oH6Tnaibz/uta6X5+To+M8XHMOwbgeL4mVwiOonVnYxnS5nh5hkBPpuie960po3zLQ7tCA0LSH56W7z0nC11oPqNjV3odCzb1W3ChzKoyHmq1nc2Q61yn6isom4arjk9syw1YAy/lKwkw2rfKwHH9bqACjDKkSUz4qYGT8I/jLc9B8jQ2M/+Iz8QjQcSnxd9KorOSzBP0iXvyNMKs9bVEaeEvqRK63ycnpS7KDJ8+y2apjEzmpV7w4Y1Nfxk6MyWBBuIYsSIAfBtvFijZftQn0fITMfJ1YzpdNeRdRC/fJ+F7NmrDRA4mZbFelz874YPC+T3t8saPv/1XhewG5rSXDk8cvhyG13nQz0znpyDDFezC3xuItDeKYOQJTEmJxWtBBIhD7MQH1AOkD6bNcTmE95NZ2ZE8cJeOe3cNseOVwkLK0uRFtEOjs//H30/vKo1dw9M/thc1og8MNeicJPReXH9xAZTHCDkhSuVjuuLV8bdwDuAUn3l62fFkzzkvIhES776p0dHdXitoFOoEnI0lHQKw4EGXyQFPff/EnfDF9RlyxluthypNlHIrrMz6Ae9TwFUbzYraJOaOSkoRy706y8V28Ts3O4oth1Osg/Q9c5B38mXGZR4G3udzaus0NdzOCCrYln7+Mi42qsyDQKCDlhk5k28oR7bW7n1SjUQGUXLESYvIHZv2KIEforcJ5LWCfIkmFsJ5bix9bGi2ZqPwsVMSuAD3SAJBNbQxdeusamNyudn5wibUzo98aSigCcK6Q3FmaN0S7yBDpD+1rwDrVLJXIgcGbmw17PlpLspuxzQAw6bnTP5phYzQnxmw+jQwPNurbSVimtC9taWIGS4iW6
 p5F/YNs6
 3NeOw/xdN+hJQTZ4zAsJyeY+CoIwyROwQRDFRbQaN0Voojhvb/YEWlpGOTJivf7f2wwWD4P1h+xvrPyicjwvk2Nj+UnAOUzT8RR3DL8dTkHg195B0SMTZ5OGCOF5u9C1wxbcjNVFnbo7m4kRNJXkoQuNE/1njwQtKBUNz4x2OOEfSKIo+/rXN5C6+matYk59kWsnHw355ygYHxtHUixh53Mza5ybFiP8Ks6vyCLrdkXdE1kR0t77ueI/QMUOOZ6yjXUzutXflYiWHi1mwLijbj6gN8CKJmqRnBQvMBFNePySv0uLSnJJos6nUUbHETRQYyA/RjsM8cbCUcfu9kBpuE5OYoKpAnF1RSdWTKVOaowIcZlYcK8StTrgOijeLiPUJxXRVEsZIFBOEkjqYPMpygP9RPC2WsydMI5oAGyMRTeeHsVCT+kQhtFSHQm3dwf7ZM81cxwMDhGhXvAUibiiGGIYPDlORD/mLL5Rk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining usage of get_cycles() is to provide random_get_entropy().

Switch mips over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

As a consequence this unearthed a nasty include dependency hell because
arbitrary code relies on a magic include of asm/timex.h. Including the
headers in asm/random.h turned out to be impossible as well.

The only solution for now is to uninline random_get_entropy().  Fix up all
other dependencies on the content of asm/timex.h in those files which
really depend on it.

Remove asm/timex.h as it has no functionality anymore.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
 arch/mips/Kconfig              |    1 
 arch/mips/generic/init.c       |    1 
 arch/mips/include/asm/random.h |    7 +++
 arch/mips/include/asm/timex.h  |   92 -----------------------------------------
 arch/mips/kernel/pm-cps.c      |    1 
 arch/mips/kernel/proc.c        |    1 
 arch/mips/kernel/relocate.c    |    1 
 arch/mips/kernel/time.c        |   53 +++++++++++++++++++++++
 arch/mips/lib/dump_tlb.c       |    1 
 arch/mips/mm/cache.c           |    1 
 10 files changed, 66 insertions(+), 93 deletions(-)

--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -19,6 +19,7 @@ config MIPS
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UBSAN
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_KEEP_MEMBLOCK
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF if 64BIT
--- a/arch/mips/generic/init.c
+++ b/arch/mips/generic/init.c
@@ -12,6 +12,7 @@
 #include <linux/of_fdt.h>
 
 #include <asm/bootinfo.h>
+#include <asm/cpu-type.h>
 #include <asm/fw/fw.h>
 #include <asm/irq_cpu.h>
 #include <asm/machine.h>
--- /dev/null
+++ b/arch/mips/include/asm/random.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-v2.0-only */
+#ifndef _ASM_RANDOM_H
+#define _ASM_RANDOM_H
+
+unsigned long random_get_entropy(void);
+
+#endif /*  _ASM_RANDOM_H */
--- a/arch/mips/include/asm/timex.h
+++ /dev/null
@@ -1,92 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1998, 1999, 2003 by Ralf Baechle
- * Copyright (C) 2014 by Maciej W. Rozycki
- */
-#ifndef _ASM_TIMEX_H
-#define _ASM_TIMEX_H
-
-#ifdef __KERNEL__
-
-#include <linux/compiler.h>
-
-#include <asm/cpu.h>
-#include <asm/cpu-features.h>
-#include <asm/mipsregs.h>
-#include <asm/cpu-type.h>
-
-/*
- * Standard way to access the cycle counter.
- * Currently only used on SMP for scheduling.
- *
- * Only the low 32 bits are available as a continuously counting entity.
- * But this only means we'll force a reschedule every 8 seconds or so,
- * which isn't an evil thing.
- *
- * We know that all SMP capable CPUs have cycle counters.
- */
-
-/*
- * On R4000/R4400 an erratum exists such that if the cycle counter is
- * read in the exact moment that it is matching the compare register,
- * no interrupt will be generated.
- *
- * There is a suggested workaround and also the erratum can't strike if
- * the compare interrupt isn't being used as the clock source device.
- * However for now the implementation of this function doesn't get these
- * fine details right.
- */
-static inline int can_use_mips_counter(unsigned int prid)
-{
-	int comp = (prid & PRID_COMP_MASK) != PRID_COMP_LEGACY;
-
-	if (__builtin_constant_p(cpu_has_counter) && !cpu_has_counter)
-		return 0;
-	else if (__builtin_constant_p(cpu_has_mips_r) && cpu_has_mips_r)
-		return 1;
-	else if (likely(!__builtin_constant_p(cpu_has_mips_r) && comp))
-		return 1;
-	/* Make sure we don't peek at cpu_data[0].options in the fast path! */
-	if (!__builtin_constant_p(cpu_has_counter))
-		asm volatile("" : "=m" (cpu_data[0].options));
-	if (likely(cpu_has_counter &&
-		   prid > (PRID_IMP_R4000 | PRID_REV_ENCODE_44(15, 15))))
-		return 1;
-	else
-		return 0;
-}
-
-static inline cycles_t get_cycles(void)
-{
-	if (can_use_mips_counter(read_c0_prid()))
-		return read_c0_count();
-	else
-		return 0;	/* no usable counter */
-}
-#define get_cycles get_cycles
-
-/*
- * Like get_cycles - but where c0_count is not available we desperately
- * use c0_random in an attempt to get at least a little bit of entropy.
- */
-static inline unsigned long random_get_entropy(void)
-{
-	unsigned int c0_random;
-
-	if (can_use_mips_counter(read_c0_prid()))
-		return read_c0_count();
-
-	if (cpu_has_3kex)
-		c0_random = (read_c0_random() >> 8) & 0x3f;
-	else
-		c0_random = read_c0_random() & 0x3f;
-	return (random_get_entropy_fallback() << 6) | (0x3f - c0_random);
-}
-#define random_get_entropy random_get_entropy
-
-#endif /* __KERNEL__ */
-
-#endif /*  _ASM_TIMEX_H */
--- a/arch/mips/kernel/pm-cps.c
+++ b/arch/mips/kernel/pm-cps.c
@@ -13,6 +13,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/cacheflush.h>
 #include <asm/cacheops.h>
+#include <asm/cpu-type.h>
 #include <asm/idle.h>
 #include <asm/mips-cps.h>
 #include <asm/mipsmtregs.h>
--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -11,6 +11,7 @@
 #include <asm/bootinfo.h>
 #include <asm/cpu.h>
 #include <asm/cpu-features.h>
+#include <asm/cpu-type.h>
 #include <asm/idle.h>
 #include <asm/mipsregs.h>
 #include <asm/processor.h>
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -13,7 +13,6 @@
 #include <asm/fw/fw.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
-#include <asm/timex.h>
 #include <linux/elf.h>
 #include <linux/kernel.h>
 #include <linux/libfdt.h>
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
@@ -2,6 +2,7 @@
 /*
  * Copyright 2001 MontaVista Software Inc.
  * Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
+ * Copyright (C) 1998, 1999, 2003 by Ralf Baechle
  * Copyright (c) 2003, 2004  Maciej W. Rozycki
  *
  * Common time service routines for MIPS machines.
@@ -21,9 +22,12 @@
 #include <linux/cpufreq.h>
 #include <linux/delay.h>
 
+#include <asm/cpu.h>
 #include <asm/cpu-features.h>
 #include <asm/cpu-type.h>
 #include <asm/div64.h>
+#include <asm/mipsregs.h>
+#include <asm/random.h>
 #include <asm/time.h>
 
 #ifdef CONFIG_CPU_FREQ
@@ -150,6 +154,55 @@ static __init int cpu_has_mfc0_count_bug
 	return 0;
 }
 
+
+/*
+ * On R4000/R4400 an erratum exists such that if the cycle counter is
+ * read in the exact moment that it is matching the compare register,
+ * no interrupt will be generated.
+ *
+ * There is a suggested workaround and also the erratum can't strike if
+ * the compare interrupt isn't being used as the clock source device.
+ * However for now the implementation of this function doesn't get these
+ * fine details right.
+ */
+static inline int can_use_mips_counter(unsigned int prid)
+{
+	int comp = (prid & PRID_COMP_MASK) != PRID_COMP_LEGACY;
+
+	if (__builtin_constant_p(cpu_has_counter) && !cpu_has_counter)
+		return 0;
+	else if (__builtin_constant_p(cpu_has_mips_r) && cpu_has_mips_r)
+		return 1;
+	else if (likely(!__builtin_constant_p(cpu_has_mips_r) && comp))
+		return 1;
+	/* Make sure we don't peek at cpu_data[0].options in the fast path! */
+	if (!__builtin_constant_p(cpu_has_counter))
+		asm volatile("" : "=m" (cpu_data[0].options));
+	if (likely(cpu_has_counter &&
+		   prid > (PRID_IMP_R4000 | PRID_REV_ENCODE_44(15, 15))))
+		return 1;
+	else
+		return 0;
+}
+
+/*
+ * Like get_cycles - but where c0_count is not available we desperately
+ * use c0_random in an attempt to get at least a little bit of entropy.
+ */
+unsigned long random_get_entropy(void)
+{
+	unsigned int c0_random;
+
+	if (can_use_mips_counter(read_c0_prid()))
+		return read_c0_count();
+
+	if (cpu_has_3kex)
+		c0_random = (read_c0_random() >> 8) & 0x3f;
+	else
+		c0_random = read_c0_random() & 0x3f;
+	return (random_get_entropy_fallback() << 6) | (0x3f - c0_random);
+}
+
 void __init time_init(void)
 {
 	plat_time_init();
--- a/arch/mips/lib/dump_tlb.c
+++ b/arch/mips/lib/dump_tlb.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 
+#include <asm/cpu-type.h>
 #include <asm/hazards.h>
 #include <asm/mipsregs.h>
 #include <asm/mmu_context.h>
--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -22,6 +22,7 @@
 #include <asm/processor.h>
 #include <asm/cpu.h>
 #include <asm/cpu-features.h>
+#include <asm/cpu-type.h>
 #include <asm/setup.h>
 #include <asm/pgtable.h>
 


