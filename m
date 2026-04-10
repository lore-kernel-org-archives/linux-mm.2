Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E564F4484C
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6666B0092; Fri, 10 Apr 2026 08:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D563A6B009D; Fri, 10 Apr 2026 08:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45286B009E; Fri, 10 Apr 2026 08:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0ACA6B0092
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:18:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 782F013B0D8
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:18:59 +0000 (UTC)
X-FDA: 84642550398.20.7D6BCCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 393CBA0009
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:18:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LfuXj06c;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=PxjGpSuH6k0aliX5vEQgtYlYC1MRnJEQUQbbGFxwl7s=;
	b=Vk4Z/U6Wmz1g6JxRut0l+17zTh8H2j8Ml8AtVqODg8hxEMJ0tiF2NKoNmeGznI6aU7/UFG
	WD/b4hfI9Jsrp4Pitf+mvRCvJEKkCXQCbbr350f91x7n34wKpq6/jA1A07cQpTTmK/9ybP
	zQuE7O73vt3WlIqFdwwACQp0mNxsl+k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LfuXj06c;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823537; a=rsa-sha256;
	cv=none;
	b=6RBtApSJyVUt2/pNVD5KsNIrPzpMNZZ6AAELesjuDD4t3LCqV/tF5X8/LNC5AYYD3VXmKM
	YHaCgf/kOi9Ohl7KpaA2LhezwhT5wbsogrFgBjWm4wYfT808X7UdxLqNRgEngknw8LZIE2
	FYiJYSnlBGCdVIfJepMPH9jeU6WX2z8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65B6B401DD;
	Fri, 10 Apr 2026 12:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABB2C2BCB0;
	Fri, 10 Apr 2026 12:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823536;
	bh=5QVlF6IfS2lfQjmpis0ghbno4R+SPdTSC+UKXWlrbwM=;
	h=Date:From:To:Subject:References:cc:From;
	b=LfuXj06c5pJdrLIRQZOGGUnvC0/7H7T958xB88dpTHpJCnzTPWKuOvuVXAdy6Ak37
	 q3NsmsuJzmcCS4AtrQC6BBqMKLBV6i7NYvY31kVUwAJ1fUk5DiH1UvcZhqx6Zvfgxu
	 CGnnZL59E7B5pPEKoSA2vv7lFrz68ryBNvlt7/he9gTUf+7cGk/WAoXUpUjNZe0UmE
	 dP1W1cGxClFkhCm5BU3vACeJkyoHuX3oJ0uOmck90IwaQnQkpQKPURmYasy2VBvUvQ
	 oOQV5XFs6UHn87rkBmH0n2LYh6YtwROpX/B/rCdI1TFAoh7Z5miPuEptvyhsFFD5GH
	 nRoQ9tRI1uYXg==
Date: Fri, 10 Apr 2026 14:18:52 +0200
Message-ID: <20260410120317.910770161@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 05/38] treewide: Remove CLOCK_TICK_RATE
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
X-Rspamd-Queue-Id: 393CBA0009
X-Stat-Signature: yuo7hfdm88nq8ojxsbsfmwwzrme55osd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775823537-35070
X-HE-Meta: U2FsdGVkX1+8/YgIob+TEfXLwG/KD3SOSIVpJe4KlEnky4E1OC0j5IgfrXFXroX9guF5fOaRW3MDFDxlC/51gBM8VhGS4/zJgjUUmWQsURybBBh2eN0vkXyLiDJ8fNA7i025SzXxX5KZhRSWYGdLaYTk6H0tzvj9o2wUj4nS79X7O2eqKDDa9esxL5BQDUMeREo5JPebZrKkewNP2KkqdgJ/EqA5CjhGvVVO1wAvsbzf/G/J4naSIWK7D1UabWmj+6h5zpmejXZeIa3FjMZEGnFfMIimdYipYQNPUDpog58PXjR7nxKYKBx0ZD2cIOBxw+FMeZEWYtBCbyjymXgxJ3CFSuQUoNH5BIDwTUrOFmQEfSZz7sFEUcVdQwfr/GbWQAvp2ciDnHWv/PU73E63WC2FHr58guZ3USPvpW5BzKOT8E1zPiI4ANoxKwVm0MxzmNum/bdzvF4o3noaIS6eegLdPY36U7iWc5nl+D549i8YItvvfhLfOtQIn5p1o3XdESomXpy7Yx0M/pw3vbaOY1ZCYaO4tCPct7QrKbTbFmXCk62jDVCCgGIDPIXMWYiyyc/dsNXTaJUzRsmY2hHIhv6jxgsLpcQdrG1tbXCRV+wZxwJKV8SnufoYkMeM6iFToVZWynw6p1fm9KxjY00PqFN3tHIj7tCe8Sivbmv5QxhzM5rJGudk1gTNpt9crtslbfgkSNW36HOpD1r4NDCfVagZSlZEvUl/BrGSDw2kQQcyalX+HrVSElNzmy/Pnxh9Kh5nmqSlhHFHwRheKyv4KqyvasUnXA/dxtUsBTQU2z5dwaplZ0uUtAkR1zuljDVJMN0arVS447YoQRBZZz52HWqLGOmNLRUf48Xwzv9pwuZ5JLlCN/AtC0FdD+Gap03PneHpemGYD3qLjFdHdpResFXfxAYulJDd5OxopVXt9C28PFmwx/HzIGoittaN2MDINZ1Ovg1ws1j8o7zHrlD
 F/1aO1fq
 Fx/Pc6ojRhpK7zWfM0Yp/aAy/SJy2V8sXC3wY5VU4StkrDNgPh7wmdSpWAAB8faV6+PSt4TW8OjcvdwyoVVOy3u/AZlVuVaYHtBhywAG9hdd8dLBIPguPJP6q8dCqU9fpijJwdb9NDPWWERi3OFcf2DfuczJE9A+XraaU08CDuQu9LRV3btctob9KwhLiXokYC/M0v6FfQGpWE4hXXfL59pZdedv6yJxNjxH7t16qXpA8ciurkBkKwlvbeSdYs7gGvTpMDMzmJPMDAukJgNy7VXYFIxcP+wW90jaDd0iYa1iP3des1T1UJb0iiyxLp1tlp5VLgurrZwVsiiSNXMt8lGUhdKbMLm9/4vKe8SKf34jRovOsdVwdgmtbOZCiEoAGFf9q8WNh+NrChGI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This has been scheduled for removal more than a decade ago and the comments
related to it have been dutifully ignored. The last dependencies are gone.

Remove it along with various now empty asm/timex.h files.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
 arch/alpha/include/asm/timex.h      |    4 ----
 arch/arc/include/asm/timex.h        |   15 ---------------
 arch/arm/mach-omap1/Kconfig         |    2 +-
 arch/hexagon/include/asm/timex.h    |    3 ---
 arch/m68k/include/asm/timex.h       |   15 ---------------
 arch/microblaze/include/asm/timex.h |   13 -------------
 arch/mips/include/asm/timex.h       |    8 --------
 arch/openrisc/include/asm/timex.h   |    3 ---
 arch/parisc/include/asm/timex.h     |    2 --
 arch/powerpc/include/asm/timex.h    |    2 --
 arch/s390/include/asm/timex.h       |    2 --
 arch/sh/include/asm/timex.h         |   24 ------------------------
 arch/sparc/include/asm/timex.h      |    2 +-
 arch/sparc/include/asm/timex_32.h   |   14 --------------
 arch/sparc/include/asm/timex_64.h   |    2 --
 arch/um/include/asm/timex.h         |    9 ---------
 arch/x86/include/asm/timex.h        |    3 ---
 17 files changed, 2 insertions(+), 121 deletions(-)

--- a/arch/alpha/include/asm/timex.h
+++ b/arch/alpha/include/asm/timex.h
@@ -7,10 +7,6 @@
 #ifndef _ASMALPHA_TIMEX_H
 #define _ASMALPHA_TIMEX_H
 
-/* With only one or two oddballs, we use the RTC as the ticker, selecting
-   the 32.768kHz reference clock, which nicely divides down to our HZ.  */
-#define CLOCK_TICK_RATE	32768
-
 /*
  * Standard way to access the cycle counter.
  * Currently only used on SMP for scheduling.
--- a/arch/arc/include/asm/timex.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- */
-
-#ifndef _ASM_ARC_TIMEX_H
-#define _ASM_ARC_TIMEX_H
-
-#define CLOCK_TICK_RATE	80000000 /* slated to be removed */
-
-#include <asm-generic/timex.h>
-
-/* XXX: get_cycles() to be implemented with RTSC insn */
-
-#endif /* _ASM_ARC_TIMEX_H */
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -74,7 +74,7 @@ config OMAP_32K_TIMER
 	  currently only available for OMAP16XX, 24XX, 34XX, OMAP4/5 and DRA7XX.
 
 	  On OMAP2PLUS this value is only used for CONFIG_HZ and
-	  CLOCK_TICK_RATE compile time calculation.
+	  timer frequency compile time calculation.
 	  The actual timer selection is done in the board file
 	  through the (DT_)MACHINE_START structure.
 
--- a/arch/hexagon/include/asm/timex.h
+++ b/arch/hexagon/include/asm/timex.h
@@ -9,9 +9,6 @@
 #include <asm-generic/timex.h>
 #include <asm/hexagon_vm.h>
 
-/* Using TCX0 as our clock.  CLOCK_TICK_RATE scheduled to be removed. */
-#define CLOCK_TICK_RATE              19200
-
 #define ARCH_HAS_READ_CURRENT_TIMER
 
 static inline int read_current_timer(unsigned long *timer_val)
--- a/arch/m68k/include/asm/timex.h
+++ b/arch/m68k/include/asm/timex.h
@@ -7,21 +7,6 @@
 #ifndef _ASMm68K_TIMEX_H
 #define _ASMm68K_TIMEX_H
 
-#ifdef CONFIG_COLDFIRE
-/*
- * CLOCK_TICK_RATE should give the underlying frequency of the tick timer
- * to make ntp work best.  For Coldfires, that's the main clock.
- */
-#include <asm/coldfire.h>
-#define CLOCK_TICK_RATE	MCF_CLK
-#else
-/*
- * This default CLOCK_TICK_RATE is probably wrong for many 68k boards
- * Users of those boards will need to check and modify accordingly
- */
-#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
-#endif
-
 typedef unsigned long cycles_t;
 
 static inline cycles_t get_cycles(void)
--- a/arch/microblaze/include/asm/timex.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- */
-
-#ifndef _ASM_MICROBLAZE_TIMEX_H
-#define _ASM_MICROBLAZE_TIMEX_H
-
-#include <asm-generic/timex.h>
-
-#define CLOCK_TICK_RATE 1000 /* Timer input freq. */
-
-#endif /* _ASM_TIMEX_H */
--- a/arch/mips/include/asm/timex.h
+++ b/arch/mips/include/asm/timex.h
@@ -19,14 +19,6 @@
 #include <asm/cpu-type.h>
 
 /*
- * This is the clock rate of the i8253 PIT.  A MIPS system may not have
- * a PIT by the symbol is used all over the kernel including some APIs.
- * So keeping it defined to the number for the PIT is the only sane thing
- * for now.
- */
-#define CLOCK_TICK_RATE 1193182
-
-/*
  * Standard way to access the cycle counter.
  * Currently only used on SMP for scheduling.
  *
--- a/arch/openrisc/include/asm/timex.h
+++ b/arch/openrisc/include/asm/timex.h
@@ -25,9 +25,6 @@ static inline cycles_t get_cycles(void)
 }
 #define get_cycles get_cycles
 
-/* This isn't really used any more */
-#define CLOCK_TICK_RATE 1000
-
 #define ARCH_HAS_READ_CURRENT_TIMER
 
 #endif
--- a/arch/parisc/include/asm/timex.h
+++ b/arch/parisc/include/asm/timex.h
@@ -9,8 +9,6 @@
 
 #include <asm/special_insns.h>
 
-#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
-
 typedef unsigned long cycles_t;
 
 static inline cycles_t get_cycles(void)
--- a/arch/powerpc/include/asm/timex.h
+++ b/arch/powerpc/include/asm/timex.h
@@ -11,8 +11,6 @@
 #include <asm/cputable.h>
 #include <asm/vdso/timebase.h>
 
-#define CLOCK_TICK_RATE	1024000 /* Underlying HZ */
-
 typedef unsigned long cycles_t;
 
 static inline cycles_t get_cycles(void)
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -177,8 +177,6 @@ static inline void local_tick_enable(uns
 	set_clock_comparator(get_lowcore()->clock_comparator);
 }
 
-#define CLOCK_TICK_RATE		1193180 /* Underlying HZ */
-
 typedef unsigned long cycles_t;
 
 static __always_inline unsigned long get_tod_clock(void)
--- a/arch/sh/include/asm/timex.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * linux/include/asm-sh/timex.h
- *
- * sh architecture timex specifications
- */
-#ifndef __ASM_SH_TIMEX_H
-#define __ASM_SH_TIMEX_H
-
-/*
- * Only parts using the legacy CPG code for their clock framework
- * implementation need to define their own Pclk value. If provided, this
- * can be used for accurately setting CLOCK_TICK_RATE, otherwise we
- * simply fall back on the i8253 PIT value.
- */
-#ifdef CONFIG_SH_PCLK_FREQ
-#define CLOCK_TICK_RATE		(CONFIG_SH_PCLK_FREQ / 4) /* Underlying HZ */
-#else
-#define CLOCK_TICK_RATE		1193180
-#endif
-
-#include <asm-generic/timex.h>
-
-#endif /* __ASM_SH_TIMEX_H */
--- a/arch/sparc/include/asm/timex.h
+++ b/arch/sparc/include/asm/timex.h
@@ -4,6 +4,6 @@
 #if defined(__sparc__) && defined(__arch64__)
 #include <asm/timex_64.h>
 #else
-#include <asm/timex_32.h>
+#include <asm-generic/timex.h>
 #endif
 #endif
--- a/arch/sparc/include/asm/timex_32.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * linux/include/asm/timex.h
- *
- * sparc architecture timex specifications
- */
-#ifndef _ASMsparc_TIMEX_H
-#define _ASMsparc_TIMEX_H
-
-#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
-
-#include <asm-generic/timex.h>
-
-#endif
--- a/arch/sparc/include/asm/timex_64.h
+++ b/arch/sparc/include/asm/timex_64.h
@@ -9,8 +9,6 @@
 
 #include <asm/timer.h>
 
-#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
-
 /* Getting on the cycle counter on sparc64. */
 typedef unsigned long cycles_t;
 #define get_cycles()	tick_ops->get_tick()
--- a/arch/um/include/asm/timex.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __UM_TIMEX_H
-#define __UM_TIMEX_H
-
-#define CLOCK_TICK_RATE (HZ)
-
-#include <asm-generic/timex.h>
-
-#endif
--- a/arch/x86/include/asm/timex.h
+++ b/arch/x86/include/asm/timex.h
@@ -14,9 +14,6 @@ static inline unsigned long random_get_e
 }
 #define random_get_entropy random_get_entropy
 
-/* Assume we use the PIT time source for the clock tick */
-#define CLOCK_TICK_RATE		PIT_TICK_RATE
-
 #define ARCH_HAS_READ_CURRENT_TIMER
 
 #endif /* _ASM_X86_TIMEX_H */


