Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AFCEF44850
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6CA26B00DB; Fri, 10 Apr 2026 08:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D986B00DC; Fri, 10 Apr 2026 08:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33006B00DD; Fri, 10 Apr 2026 08:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2B916B00DB
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:21:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85555140527
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:24 +0000 (UTC)
X-FDA: 84642556488.08.6DFBCFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D3A41C0007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nXK4IjII;
	spf=pass (imf28.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=8zvdRD2p6/HZ8oXsfe5lXlcag4dZNqBBcODU4ow/RYc=;
	b=Y+t0kjiR4wrJ5OGkam77yVYR7cGAyicXrn5QQTRj/NKsLD64+U3KOToPEo4G+i4RNovgCd
	Cnvco3TifZmCYaHK4C5aH2aE/nwm8SNhLs7Usq78bBWKMyV0blCGWUcCLAA1j2i3cL9qxE
	6t3RdJcqbVI53ZihhJAf5VFvRPN8+f4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nXK4IjII;
	spf=pass (imf28.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823683; a=rsa-sha256;
	cv=none;
	b=hq1jTWiQ0arYpvVVvG+22dDA789F/WSmMeUm62+nhAa8Fmst8Z7Xmgo0PPYahi7lN4SePy
	Lk3tb8Tx8VdqGAjhizT8mxnfMog6SFCPUP2pmGvVa8JPZ/L88BycPmZZLN6J7A+2VRg2iz
	ZKdEpdMPFVGLdDBTA7m2fDJ98G6cW2s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0543642A47;
	Fri, 10 Apr 2026 12:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC20C2BCAF;
	Fri, 10 Apr 2026 12:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823681;
	bh=OPcZi/R5r87GvmWT5SIJxVBbPPoFFtvzuT/73U4xw6M=;
	h=Date:From:To:Cc:Subject:References:From;
	b=nXK4IjIIYC4xFxjX1itXAh56E7vQfZ/FFg1BbCs9BTXZuysjAps9x9bTN1xwZq3nZ
	 nGcIQtUczMHcNVAOXl3hUPdL+RNfqdz89/sEUMpghyMK10SkqIQqjoKkLYlZIDgGQg
	 6k/60XarMgLYO/edAAklc4cY8bckLykp1FNwUtHWQrXz6RHvG4M2KbuAE5KrJ4anwq
	 KM/F3nJU8E8F/VqEi0tPDyEpicMuyuDi9K4xS5dK75o3zu+aRbSw7hWtA0AaEaHPPT
	 N9wVjGhL4hXB+rfUE/x4Qggo67acuAQqBh4RtUYL+MOxGvNcfvlrnmgwbgp5vSVReB
	 QZ733oHdFO0vw==
Date: Fri, 10 Apr 2026 14:21:19 +0200
Message-ID: <20260410120319.924028412@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
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
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 35/38] s390: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Queue-Id: D3A41C0007
X-Stat-Signature: xk4bwa65net6efu56g98fp1mbrhd88zk
X-Rspamd-Server: rspam06
X-HE-Tag: 1775823682-118360
X-HE-Meta: U2FsdGVkX1+0p91xORGo6b1Ufwrw9LgKbx78g13CjuexWaw0HR6GcSwcX2YzcUs5yuuJvGl2DyY3woSaYVGzXuF35sXPlgmFhM9pMTdAiXIxk8NM5QqP3N1nQD9lYRQQBBHRyjb1NP1xf5yIvyKZxAEv854g8mAvoh6+kkhRSiVQTYS1vQHQR17+YaWx8mPqENetjziu6lQ4Spq72WV1N/UJcIVk5d0uYfjFnOTyv/WGEv3qrzoHbXOJ6I/cohiUjM4HWZOPUk+HErSurs3Vy+gsLgANgkBN0lYYPVsslSOkna2mqwY4nt58IufHzTnjpzX9enCfEg3OY0MV5p7DN4efUJhmEX4lZ98r+49kvLoNTfG2xzryY0rMyibD8jiZFvMiWfY/VZokw9tM+0/Cd14KguIz7LeskeseDm7acERNbmhm7q33j9ZpYo6O3uIJDwHvHQEikWCmlhcXC56GAWgIMo6Dh8mU86tXEkMLC4Jp4Y/jU5f8wiZWBu/7PVROfQo75CHxILxMclv8+n1KK84/ezEL9Nd4xb0aCRwRtf5lsFUiGGd52sJO6bGkEN6pV5kvbYoV98Mq4ACF8NE0k2ezHYlFoX9RxnBegIFdHFMMF2aIkUpoBVsE3OXaYRhx6wC9zsDiOfz6inGUBmQi69ing8nLWGypzpG5IatA41ENTlXbGUgU0keGJRzQ1JrzuGdxaIjs5JZN95ObpB53xT+tITz28pCCNTc+aaTGfExN0EyoHIeAsF6ARCNsi5RhELw/Cf3DD4gRjiZL5UO1Xvletb+aXQmDNaNL3u8qAZZjEj4Cc41iA3vjbfCnadFtCvpnAtk9pIe4JmKkK9e+V04qAx356dpLB67Pmsz8yOz14BBxNxoXiAuCUpjV6WgS6ibjQtbzzGQ1CoHTcZIsD9PaKf5fm1wDEL0iYXKYopIZisYGcYw32LF23rWWBWpFVVyTdKjJIX4iOPcBeDB
 k2L+5G5d
 qsBxXjkJAH7xkJOTEVW9ve/JU4Ft8f9QXDOIV+AvmeGIQ/jEuoLfY2cX97u4d8sUzxtXRmxKPI2N6aR00DfWCnuTzsgwr8qIuxBs7CAZ1oOqQby06TcjC6IuoJ8oml4cBY1X43wTUheURozcRzEs3E7awlr/HYz74jw4nqxNiATrXL9r9auZX4i7roJFnU8wvKCTyQa38noNU+Dr1OorHRglHHH9AYSUUF5KnfsvmxJbbHRpxfCTsKwG2Kb+ajLwGd1cQmwqVgV9A/UArOiIWy/UlNXbEeiZMh71Fqa1xRZ2Q5sgvDclESzZEUf4HVLjapmL3vTZwk2MjLO+511GByJrFNJobDBfXLi1xRrxLXAJHrYceZHqrRxJkH5zkQpOXkyXzXBCBVqcGS12njZ8P6uWgIatX5ftHnQ60PM7t6sM5OxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining non-architecture usage of get_cycles() is to provide
random_get_entropy().

Switch s390 over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
providing random_get_entropy() in asm/random.h.

Add 'asm/timex.h' includes to the relevant files, so the global include can
be removed once all architectures are converted over.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
---
 arch/s390/Kconfig              |    1 +
 arch/s390/include/asm/random.h |   12 ++++++++++++
 arch/s390/include/asm/timex.h  |    6 ------
 arch/s390/kernel/time.c        |    1 +
 arch/s390/kernel/vtime.c       |    1 +
 5 files changed, 15 insertions(+), 6 deletions(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -108,6 +108,7 @@ config S390
 	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_SCALED_CPUTIME
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_SET_MEMORY
--- /dev/null
+++ b/arch/s390/include/asm/random.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_S390_RANDOM_H
+#define _ASM_S390_RANDOM_H
+
+#include <asm/timex.h>
+
+static inline unsigned long random_get_entropy(void)
+{
+	return (unsigned long)get_tod_clock_monotonic() >> 2;
+}
+
+#endif
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -219,12 +219,6 @@ static inline unsigned long get_tod_cloc
 	return tod;
 }
 
-static inline cycles_t get_cycles(void)
-{
-	return (cycles_t)get_tod_clock_monotonic() >> 2;
-}
-#define get_cycles get_cycles
-
 /**
  * tod_to_ns - convert a TOD format value to nanoseconds
  * @todval: to be converted TOD format value
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -50,6 +50,7 @@
 #include <asm/irq_regs.h>
 #include <asm/vtimer.h>
 #include <asm/stp.h>
+#include <asm/timex.h>
 #include <asm/cio.h>
 #include "entry.h"
 
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -14,6 +14,7 @@
 #include <linux/time.h>
 #include <asm/alternative.h>
 #include <asm/cputime.h>
+#include <asm/timex.h>
 #include <asm/vtimer.h>
 #include <asm/vtime.h>
 #include <asm/cpu_mf.h>


