Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C65F4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852076B00DE; Fri, 10 Apr 2026 08:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802EE6B00DF; Fri, 10 Apr 2026 08:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718B16B00E0; Fri, 10 Apr 2026 08:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 601706B00DE
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:21:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A6FA591BA
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:38 +0000 (UTC)
X-FDA: 84642557076.23.7A28D69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8E1384000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDyFrce5;
	spf=pass (imf07.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=Bd2cg6ABy+bDw1GoAexe6DyvKfgKbE4JMcwGjXdm8Fs=;
	b=co+1JfZzO3v0rpCz6L9lHSvasnxGIEMLwTJacFcCsxjTlyhAVfWKu6ZSVYrTnlRoaZYsiL
	I4pu8TXB3SYMtnaWtoWqVCFaCegd2E3+KNH/IgFNgpdV+yIHIlJv9CRQPrQ0zpP9aAzHJy
	QmtGMK/9EvGkmB+SK2TpNj5uvmz15ws=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDyFrce5;
	spf=pass (imf07.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823696; a=rsa-sha256;
	cv=none;
	b=DwKwD4NGbKxr2HDbxQFkow7E2Y2ZZEvzhA1QCExe1aEc++/W7x7U0bKUTwyFBZzyRMJxj8
	lEA9z9XGEGI0oHxruzfrXNKHmuxEpV2OhM0i8RCkN8j++g4m37X8vRi+zAgvkNhjB4dDyv
	fPanUxd+lcRQGoky07k9PVSM7DZtqqA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E64B61334;
	Fri, 10 Apr 2026 12:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AD5C2BC87;
	Fri, 10 Apr 2026 12:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823695;
	bh=pY4Ba+JrP/xTQAmwvt4Sblvq53DUrPINRCnMdCBk5qo=;
	h=Date:From:To:Subject:References:cc:From;
	b=HDyFrce5AOq/EGfeY1UdoV8DNpMgAy18kWHJM1sjAR8gGlb0lGVL/86T8A9JdQ406
	 geoVdL2hWTrXGNOfAnq/kY6NSEK4TpMk9WMO+y1nQNH3tMz9xsxHfqX6syvZMUj1PK
	 bzYUHDgCtqjEJkHt2pwcVZ7pxbRQ83NKHdjXp0R8JD++ws1pIDJb+QbVlpuQaSrK3+
	 elCptYV6iuLAdTbeeR+RbymhnVAR5noANk7G5ygRae6T0lvFrKQfmBeUjBXUKx1VNg
	 KMOPQf2nxfU/JqhQvoUzqUAfK3BjbJR+sYA7dzOFGZqkM+hZZWPxeRIyaCeQdbvVoP
	 M9E/X3gApmxpw==
Date: Fri, 10 Apr 2026 14:21:32 +0200
Message-ID: <20260410120320.163559629@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 38/38] treewide: Remove asm/timex.h includes from generic code
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E1384000B
X-Stat-Signature: pebne7khinr7toq5y8ykwqchjcphmcid
X-Rspamd-Server: rspam06
X-HE-Tag: 1775823696-319324
X-HE-Meta: U2FsdGVkX1/TblSuxWA70SY3yjoY+s8YQumOcCyODgQCJUPWEP2Oz0L12IWxoVTZpFGIXaP1ZyrrR/E2lqaVwZ+COGJqaYnx7tBYMsbjmn8xq77BmQmJ5JHGQpvL3ZHKDqt9d7WpK+zZWri7Uc/nwle2w1Yg7RONBYzJHC0dFoFWpxT/6HAId/29v1vXMKXrew3ulxRoXOOzbqh4c5+2+CwLPV6VNOAj0Mi3uSphm2j2SiVknhx3ZS0/Z2lkyb92C2oxO/kLTtIZAL6f8Ew2sN1hqBO6R2mbErR4mXQeRikBERyNzL+/WUIVDEZsYDJruBlhD5K8Oxxv91LBoKn/3FJ2L1S52POejhw6+yAzp6vjGDr1kmntbi2gVyaZcw5kDHq3yelot0eIw8cF7Fqnntw27b2Ptng4EZSeTSZ9ZUWLzCSF6YOLOaxOYl7ZkepeNtijubIKt7AXrq4X+rbRMTYsUjwSm0WLcRrM8MeUwv0m6YK1Jt4qQ+Rrq8EUCeUuWhxXQNQpkvkhPwvyEKltqRgnNz6JJxUHgAokALvbkTZbeCZJr7y/rRmeUBke9QOe4bqd4cyrpyawyxSukGQPD623E4Zb6M15g0t1uuDzL3oRpKElubycOkraPuEzE5yDUqzZ12w1kVbaTKxNi0iUIaZm0B070DXB1BLaHsIq+UPjVsBmYmJQ938MARHC/+eJsvIHBi27bX10o9wH7c6yNHPzRrU+5Kg71oS29g9Eb+PtEVcXQ11wQFffQyd9zprxliqyHJuiSVfQRgju64dRdbN7XNneSVLEDp8cwR/aCR2E6jW0EiRYfduYuktV4g5fRqWKGDAk8vskEaCIBb+bLinBMu5pBIijdnuv227KzJs7UAcSRo8epgYdUWN94fki0Dv7f5jf8XZThLRHXL2tGkIvqO+AdXLZi+MXrXfwuhAsBjSxEWLUxNwAX/C9rcc0luDlGD79T40p7sjwOHP
 Ckx0n0Hd
 MjyOGRw8ZnSAB/Iubg9yMnG3BVjNI56hO74ag01OvzhxmNQ9+ddztd8N9g3XF2MhW4/kI2Ckak42L0iOzyOVlsmMFP1b5EPKPgo1kl2gtgF5+yBlzM0NP056Qo7QPap/npS5u2r8R/QUdvaEbFoa459RDVYCG3roIWeijfmcehXMtkAXB7gmnuD6LxNV/CpitonlIOghdrW5pqmoMFf/3AI7Mivk0KmDsXghYSh1Ebb0IZEBm8y5EsSSqOTIaciJZ5FiQNuEaGp2XXshA1M6f5JuK+P5xNEoSSCRu+jBcYIsvTz2P4/FOzHoUk2mO8SuSB3HgVFWq5td9m0QVOQ1Nvsyin8+s4tqoDZJF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

asm/timex.h does not provide any functionality for non-architecture code
anymore.

Remove the asm-generic fallback and all references in include and source
files along with the random_get_entropy() #ifdeffery in timex.h.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
 include/asm-generic/Kbuild  |    1 -
 include/asm-generic/timex.h |   15 ---------------
 include/linux/random.h      |    3 +++
 include/linux/timex.h       |   26 --------------------------
 kernel/time/timer.c         |    1 -
 lib/interval_tree_test.c    |    1 -
 lib/rbtree_test.c           |    1 -
 7 files changed, 3 insertions(+), 45 deletions(-)

--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -56,7 +56,6 @@ mandatory-y += shmparam.h
 mandatory-y += simd.h
 mandatory-y += softirq_stack.h
 mandatory-y += switch_to.h
-mandatory-y += timex.h
 mandatory-y += tlbflush.h
 mandatory-y += topology.h
 mandatory-y += trace_clock.h
--- a/include/asm-generic/timex.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __ASM_GENERIC_TIMEX_H
-#define __ASM_GENERIC_TIMEX_H
-
-/*
- * If you have a cycle counter, return the value here.
- */
-#ifndef get_cycles
-static inline cycles_t get_cycles(void)
-{
-	return 0;
-}
-#endif
-
-#endif /* __ASM_GENERIC_TIMEX_H */
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -1,3 +1,4 @@
+
 /* SPDX-License-Identifier: GPL-2.0 */
 
 #ifndef _LINUX_RANDOM_H
@@ -152,6 +153,8 @@ unsigned long random_get_entropy_fallbac
  */
 #ifdef CONFIG_ARCH_HAS_RANDOM_ENTROPY
 #include <asm/random.h>
+#else
+#define random_get_entropy()	random_get_entropy_fallback()
 #endif
 
 #endif /* _LINUX_RANDOM_H */
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -62,32 +62,6 @@
 #include <linux/types.h>
 #include <linux/param.h>
 
-unsigned long random_get_entropy_fallback(void);
-
-#include <asm/timex.h>
-
-#ifndef CONFIG_ARCH_HAS_RANDOM_ENTROPY
-#ifndef random_get_entropy
-/*
- * The random_get_entropy() function is used by the /dev/random driver
- * in order to extract entropy via the relative unpredictability of
- * when an interrupt takes places versus a high speed, fine-grained
- * timing source or cycle counter.  Since it will be occurred on every
- * single interrupt, it must have a very low cost/overhead.
- *
- * By default we use get_cycles() for this purpose, but individual
- * architectures may override this in their asm/timex.h header file.
- * If a given arch does not have get_cycles(), then we fallback to
- * using random_get_entropy_fallback().
- */
-#ifdef get_cycles
-#define random_get_entropy()	((unsigned long)get_cycles())
-#else
-#define random_get_entropy()	random_get_entropy_fallback()
-#endif
-#endif
-#endif
-
 /*
  * SHIFT_PLL is used as a dampening factor to define how much we
  * adjust the frequency correction for a given offset in PLL mode.
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -48,7 +48,6 @@
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/div64.h>
-#include <asm/timex.h>
 #include <asm/io.h>
 
 #include "tick-internal.h"
--- a/lib/interval_tree_test.c
+++ b/lib/interval_tree_test.c
@@ -4,7 +4,6 @@
 #include <linux/interval_tree.h>
 #include <linux/prandom.h>
 #include <linux/slab.h>
-#include <asm/timex.h>
 #include <linux/bitmap.h>
 #include <linux/maple_tree.h>
 
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -4,7 +4,6 @@
 #include <linux/rbtree_augmented.h>
 #include <linux/prandom.h>
 #include <linux/slab.h>
-#include <asm/timex.h>
 
 #define __param(type, name, init, msg)		\
 	static type name = init;		\


