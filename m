Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B45F4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE756B00CF; Fri, 10 Apr 2026 08:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6826B00D1; Fri, 10 Apr 2026 08:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395A56B00D2; Fri, 10 Apr 2026 08:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 269466B00CF
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C38BC8BD0C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:56 +0000 (UTC)
X-FDA: 84642555312.05.F8DF8E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C5356A0017
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OB4z6rme;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=wet7X8fxJTL0AwKIA3Km4njiBeu4Q2oQdaC3YcfBnuE=;
	b=YSgaudfQf8Cv6ELLySswV7ZuPiQyR5kUIZWWPdkCRBhGUwLrkoDofa3nIoF8ttfPUxrmX4
	XRZMj3XyzirTUXlemC8q4Ui9Wgw0UGPDPDaFY81EmVfKoMSQVzxAmK5BrwAasail3TXPLs
	zzIvb1O+abchejHGpw32xNl9qkoBIXg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OB4z6rme;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823655; a=rsa-sha256;
	cv=none;
	b=ACAnDvsYqrqoYrk2v99mIuMj9cw9tdFHAq5SeznLJcqieuD3ZcL0e6lFXga4ucfrRoj2UJ
	fN0vvpwv79gqFfef0qUaA+wrKJ9VojbemCGcAlUZiAUNKdL5qBqNARTDlF1Ahb5FyYH8JR
	hi0RTRMXxh8/IGLJNdChSjD8aOqLkEU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF571438DE;
	Fri, 10 Apr 2026 12:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A6BC2BCAF;
	Fri, 10 Apr 2026 12:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823653;
	bh=JK0/F7Ki9YiLWmMnKZ+Lr+3CWdB1is+mT2jM4Zqadew=;
	h=Date:From:To:Cc:Subject:References:From;
	b=OB4z6rmedzjF/tihT238p7staUYI70l/WLyVpYQgd3G/0qlK9BetgUNbHaxUOTJJk
	 qdDaLQwa1siZvXl47NXTJc0ORYA2dsT704qKM+lVSSRN4sldd+TbcnCJaaKLtMHkff
	 SfKJlNkL5h8guSKmd0Me9uWsWZCYIBa85rKbdrV18Ca38UzELO7GQROVPWzrTHMCfJ
	 QFdBWZuROAjUxl7+DX48sdEQxX7/xngz/AnUC+xaQ7wkdJF1oolh8aMOXz2mAve+hh
	 C3LVdoPqlu6sGEaRdYNI50vZs10DhqwpaJqHFXY4YWja3gycAdllpb8XCooIJE8rT+
	 LUw8ufY+z6WgQ==
Date: Fri, 10 Apr 2026 14:20:50 +0200
Message-ID: <20260410120319.528318344@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
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
Subject: [patch 29/38] nios2: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Stat-Signature: 71apqitootkwpwecznadj7ymg8a5yryr
X-Rspamd-Queue-Id: C5356A0017
X-Rspamd-Server: rspam09
X-HE-Tag: 1775823654-290609
X-HE-Meta: U2FsdGVkX18MrMrAPbPXIThiuhUOlRkNjaalg2OO7DSWV/qrB28C3x48uPSx1OFZDr3idv2fcvxsOdM25/+WwEwmzjRMe79Zkxf9oBd6aSeX8qY8gvCWjY6ZZ6+b7933Xc3fzJh6g9C/GJCG2Zcqj389m2gPtKY0epG94NtQ3WWFBbW3j/9WFcL6gNRP9kpEoBTBc1hN7Je9MDwV+lTUEdhhLF/iqpVnXupr94vYorX12GzN0LM3gqJytdK5SyRLICx7rL0mZkIEzm6FFSjGT/TlpJfslmikyDwIC2PT1gvfMUGWjb9DwrcV/DbGzNaVeJOo4YNf5UQBedUcGaGmzjhmgnZCoWc6lFVJ8bDPvWyKyjapdzwO2ZkIOYTmSv8Z0TynSHeKxTobqklmzN8usrmRj2sv25HtVTiQ/ZnhqP+3pcUvTvNpKHn4Op8DyY/hTIQ6WPXjC3VE8Kz36xKKNueRKKT+nfFd0nlV9AZjWqIvv92QJC7CSHDOdCezs+5Vl0lE4fteWB/0VbmF344zswe9/0st9vlpntuGKro2JutLWBvfYVxHWf5ef5Lom4V88cPuUo/LpAJ3c06TDYWblu4sUqhD3XvH47WLJoODD25YtYIPfy0qaZ4icFa4zc2zxj/VOFcbIL/tDQoDDOd/qhhnMxwlpmqk0zrVYbbYGHu7ebwyg5Ir+/lvwMNKh5FGEH4JrjQfMQlrkBEHvOkIFyjUF44LnCr9qGiJmbkgIteP0Ikardb4lNmSfx3kqZ2KirUh28a2OaIMiA5x+7LH1nXBMdk5KrJmpDcog7Pd29auiiVOUbO+s/W/hTmAA1Zy3HNosRj1n92ZIeKYRevgdb5rxLYDnS/Tcx6YssB5hrjHCzdy7hriCArCjRfxdU2pPhSgSkXzCUNIzBskM2NeUKuDWOxsDHUk1RGP58w/pksPzLk3fuLkvG+wjYTFkwYeJ+ztks5hzuBx362sPmg
 33kq7Czc
 5oLAyuZG0x8V6e6YSOeoDiKAS5gGkvxSl+jEKDnJgOII3GJKb/Gm4QV/0vXb4ceDOSHM2U27sDgfEZW+qMvmErPSZXefEFGHbj2nb2hQRPasCjsmghycPEPwdwRfuWVD+nxisJ/cS1wsEOBkha39nTO5wsHA/xX+6oGLEahQKIoPbqrYGXV9XqqqvdwnDhfLW47HUIhZ2DFdsNu4TBYmL7d7B/v8g5NSrk8Ouz9nd/SmyWT7oxl2MjbQJOLgfM7kEnx2gWJqBsxSLdy2Mpc3AJRztVrOT9cLM3mc/7jGK1oWIldvEdEiTeYDApe6Nk7dF1xZv6szE1nWVTtppFoJwcyIAj/mZKbtXDzN6KWNDxU0MBh9FdW1J8yAlreeI80OqfNZGlsWa9Ka4KCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining non-architecture usage of get_cycles() is to provide
random_get_entropy().

Switch nios2 over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

Add 'asm/timex.h' includes to the relevant files, so the global include can
be removed once all architectures are converted over.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
---
 arch/nios2/Kconfig              |    1 +
 arch/nios2/include/asm/random.h |   14 ++++++++++++++
 arch/nios2/include/asm/timex.h  |    5 +----
 arch/nios2/kernel/time.c        |    4 ++--
 4 files changed, 18 insertions(+), 6 deletions(-)

--- a/arch/nios2/Kconfig
+++ b/arch/nios2/Kconfig
@@ -7,6 +7,7 @@ config NIOS2
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_HAS_DMA_SET_UNCACHED
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_NO_SWAP
 	select COMMON_CLK
 	select TIMER_OF
--- /dev/null
+++ b/arch/nios2/include/asm/random.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_NIOS2_RANDOM_H
+#define _ASM_NIOS2_RANDOM_H
+
+#include <asm/timex.h>
+
+static inline unsigned long random_get_entropy(void)
+{
+	unsigned long c = get_cycles();
+
+	return c ? c : random_get_entropy_fallback();
+}
+
+#endif
--- a/arch/nios2/include/asm/timex.h
+++ b/arch/nios2/include/asm/timex.h
@@ -5,9 +5,6 @@
 #ifndef _ASM_NIOS2_TIMEX_H
 #define _ASM_NIOS2_TIMEX_H
 
-extern cycles_t get_cycles(void);
-#define get_cycles get_cycles
-
-#define random_get_entropy() (((unsigned long)get_cycles()) ?: random_get_entropy_fallback())
+cycles_t get_cycles(void);
 
 #endif
--- a/arch/nios2/kernel/time.c
+++ b/arch/nios2/kernel/time.c
@@ -7,7 +7,6 @@
  * License. See the file "COPYING" in the main directory of this archive
  * for more details.
  */
-
 #include <linux/export.h>
 #include <linux/interrupt.h>
 #include <linux/clockchips.h>
@@ -19,6 +18,8 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
+#include <asm/timex.h>
+
 #define ALTR_TIMER_COMPATIBLE		"altr,timer-1.0"
 
 #define ALTERA_TIMER_STATUS_REG	0
@@ -112,7 +113,6 @@ cycles_t get_cycles(void)
 		return nios2_timer_read(&nios2_cs.cs);
 	return 0;
 }
-EXPORT_SYMBOL(get_cycles);
 
 static void nios2_timer_start(struct nios2_timer *timer)
 {


