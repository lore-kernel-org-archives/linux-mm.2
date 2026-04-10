Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53855F44851
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC8A6B00DC; Fri, 10 Apr 2026 08:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BACB56B00DD; Fri, 10 Apr 2026 08:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9BD16B00DE; Fri, 10 Apr 2026 08:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 979F26B00DC
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:21:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5AF6A59215
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:29 +0000 (UTC)
X-FDA: 84642556698.02.06D4E2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A85824000D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z5xk9L5P;
	spf=pass (imf11.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=CZnLdubUssxhQoUeG+xENhtvOMtrmC4aQUSEvuRJUnc=;
	b=ww/Kg2kFsM5Uelf5/GAEazXMCrGcTa/EUHC7RfTk+snC/h7YW62mbZvvn2ZkxAgExSXPb/
	6fxhwUHI+DKtTHDMiUTEXfJShjbDl80b2s8SIRSlw/H4XIWBoyUH5FcWl2+F7+p/rwmcwU
	AzqwQZ+vQcQBrZmY9j7Ya3YPtFMGsM4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z5xk9L5P;
	spf=pass (imf11.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823687; a=rsa-sha256;
	cv=none;
	b=rjOkNZSDWezjAyZ17Ru666sk5DuPpbH/2KOMOlru6prp8haHz60y+ZZ1MUUtLFAVihwezq
	8IcHF9xOjjuRsT2a5E1+N3cn62Sw3+Qcx8qlz27GtCf+9bIIghx4kJhkzTSxd1GjaPUx7S
	UTVGMA8gqa7GZCP+IEDFlED/ceO3OJ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C75564366F;
	Fri, 10 Apr 2026 12:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EE3C19425;
	Fri, 10 Apr 2026 12:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823686;
	bh=506UQ2xUMl1Z9eAzOmzEcIl1RJxUk5Zj30ohtcXoKMY=;
	h=Date:From:To:Cc:Subject:References:From;
	b=Z5xk9L5P21mRx0MY/8DBEFXub59mdEbOhszRMhCXrj2F4yR3gtSSMVH5Ys886C70h
	 ecuez10MlaZM3qSzOJIlSqs3GQHIX7r46PbtHbTSey1wj2Xf5OquvDCTW6/Y/BwsaZ
	 HOnECp9mbfgHCsi29AhbrdwXxEeghdlmA/P/QGWQbNRq0XZzEiWDbqYK6jtMl2Fqel
	 J/j1quCkWsAMuIIV68vkZDLkhw3pICkV08QoM7gE4lID3deNtskLbUzyP0Y6rIWxr9
	 E+31Ou3bfkNfr/XyUr2BTZMkGgo/VhX2L0FM/Xl0m04u+cc79US3jzI6GNXqNN3Dgi
	 kUVIHjYrNe9Wg==
Date: Fri, 10 Apr 2026 14:21:23 +0200
Message-ID: <20260410120320.011762129@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org,
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
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org
Subject: [patch 36/38] sparc: Select ARCH_HAS_RANDOM_ENTROPY for SPARC64
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: A85824000D
X-Stat-Signature: jid9p14jid68h6oxg8nj1jau3u8kddu3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775823687-352682
X-HE-Meta: U2FsdGVkX181bh8Sq81KbMMuGDYLqlU7I5xnfkOc10ZKeRuTFMvaaXkJDvGPmnG8T5cYRAh+KC9T7RSp5Vw1yDw+JNT9zHJzLxZWGCuC7EoxXiHCB/hMJ8ZYSoDElNi3nnhbr9/4RO33x0ITvzR8wG8zWXtQsuj8CyuJ1GrO2x8ieuRveXeblLHmbz0uIAzjEIUhmS7TA0t1OLRD+F0SAuDF++F5IfdAxDlf6ByuetNUZRuqS5BpIifzQ8sKvSu1Z2Fy8tCWhaXRRRZ1QJ05dt376PfO7oJq6BybHgm6dAgojAfQE8KET05LQT7u98h8+er/Vh9+KF1/ZbdRp8mxPhs+PKfrwXbfIDLXefijFB6WTwlYjv5RcMypiIxTHiqK81TS0zlGF0YtI4pob9rQGvADhyiVn9EGf0pi5UaaOuAxXVOvivXmCJhlj2Q6KlD6tgSsdO2bsPlEJPlCl+GwMN7wmn2BiNp9hAA6DB6Mum8tI+FWeWdVWeMutceWpYTuY/s5t8PL9dtySBB3UYK8BtkIbR9w5obLhwYun/GTfa8+Efb23tyY6uW+L5zX/5gf0KpOc5vMWt6r7ftf52TqHLNoQ7jdvCLoSmxRJOLtw/k8DJmUt5AoIpn/ZauBmKOkuAn/Jt9Dbikuhd5UrqcOoon7QZPLvC2EwKsK+K79k9DSqYUKrV0plItHwJ085yjlA3q8V9Qvw3X7iZDel2mrlbZZ7A6SCZ7Gk/F1suSIKGB1b2WIpo1P0B4l4+UAiiLQzShKI6ruY8knA8AnU+dD73JgmOHITeMhJITi/qcwI74nGEuzJP1PtcnHscWrlmde0np157X8ncG2rkiDBuPCv6U8crzTuzmGihlI54Bauw8QAw1RGjbUDFMRE5WieQlXy0F04siFLoadF44fHpoZjffUKzl6vsAboAXDU+KPc6YB33TSr54l1VCMBk9pmmxOyWsSA8wWnBoQYRob9CG
 1aCJjv92
 +E3rcC+d6hHbhDfutWZiFMujB2jPAlFD7gOffj5dJuF2Uz1g7/XjP6g9VWU1EANj+hrRRG6JG2y6ii7RpKDURJc2FHdlGnFipeSLhUEu1YQlo/V8G1K4pOkYZWe75Aqd2b7TZyjT0cJHN7kv87UF91sz3ijELR6XoUzO7e6n4Nip9//87ey3vI95rYk+EPShjrIt8Z0DBL3Lsb3ikqyAQljEOfvyn5EFWWol9hx6oEBCBUYx8KlEOCzmuwtHjyhxz3zvKTeGkH7bhVV/5Ky1LIrsacZ5vSB6HH6RxGht+EmkKYlkQ+DJTq8dt7lYg9mdxkRLV/JolKpf2GEGvpn46StFAK88KWF6TRgexE4xcDCn6uY+tFdypTr7/ioGctV86uNhWkUf0QBsh/3WITVeHce9LGPgfC5dfrjKTww0IoOuQva4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining usage of get_cycles() is to provide random_get_entropy().

Switch sparc over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

Remove asm/timex*.h as it has no functionality anymore.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/Kconfig                |    1 +
 arch/sparc/include/asm/random.h   |   15 +++++++++++++++
 arch/sparc/include/asm/timex.h    |    9 ---------
 arch/sparc/include/asm/timex_64.h |   15 ---------------
 arch/sparc/kernel/pcic.c          |    1 -
 arch/sparc/kernel/time_32.c       |    1 -
 arch/sparc/vdso/vclock_gettime.c  |    1 -
 7 files changed, 16 insertions(+), 27 deletions(-)

--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -71,6 +71,7 @@ config SPARC64
 	def_bool 64BIT
 	select ALTERNATE_USER_ADDRESS_SPACE
 	select ARCH_HAS_DELAY_TIMER
+	select ARCH_HAS_RANDOM_ENTROPY
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KRETPROBES
--- /dev/null
+++ b/arch/sparc/include/asm/random.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMsparc_RANDOM_H
+#define _ASMsparc_RANDOM_H
+
+#if defined(__sparc__) && defined(__arch64__)
+
+#include <asm/timer.h>
+
+static inline unsigned long random_get_entropy(void)
+{
+	return tick_ops->get_tick();
+}
+
+#endif
+#endif
--- a/arch/sparc/include/asm/timex.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef ___ASM_SPARC_TIMEX_H
-#define ___ASM_SPARC_TIMEX_H
-#if defined(__sparc__) && defined(__arch64__)
-#include <asm/timex_64.h>
-#else
-#include <asm-generic/timex.h>
-#endif
-#endif
--- a/arch/sparc/include/asm/timex_64.h
+++ b/arch/sparc/include/asm/timex_64.h
@@ -1,15 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * linux/include/asm/timex.h
- *
- * sparc64 architecture timex specifications
- */
-#ifndef _ASMsparc64_TIMEX_H
-#define _ASMsparc64_TIMEX_H
-
-#include <asm/timer.h>
-
-/* Getting on the cycle counter on sparc64. */
-#define get_cycles()	tick_ops->get_tick()
-
-#endif
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -33,7 +33,6 @@
 #include <asm/oplib.h>
 #include <asm/prom.h>
 #include <asm/pcic.h>
-#include <asm/timex.h>
 #include <asm/timer.h>
 #include <linux/uaccess.h>
 #include <asm/irq_regs.h>
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -37,7 +37,6 @@
 
 #include <asm/mc146818rtc.h>
 #include <asm/oplib.h>
-#include <asm/timex.h>
 #include <asm/timer.h>
 #include <asm/irq.h>
 #include <asm/io.h>
--- a/arch/sparc/vdso/vclock_gettime.c
+++ b/arch/sparc/vdso/vclock_gettime.c
@@ -17,7 +17,6 @@
 #include <linux/string.h>
 #include <asm/io.h>
 #include <asm/unistd.h>
-#include <asm/timex.h>
 #include <asm/clocksource.h>
 #include <asm/vvar.h>
 


