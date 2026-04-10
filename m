Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA2BFF4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6186B00D1; Fri, 10 Apr 2026 08:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A68A6B00D3; Fri, 10 Apr 2026 08:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396106B00D4; Fri, 10 Apr 2026 08:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 222356B00D1
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:21:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9EF4590C7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:00 +0000 (UTC)
X-FDA: 84642555480.20.1CBD8C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3969A180009
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RmyBeAjX;
	spf=pass (imf24.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=55BqTpopgqyhosJe2byyDZjQwi/7tJCuwd4CS33Nh0I=;
	b=cQz15h3ILgje33CT+sBnPD7Vt2i4l86Ko9N9AVyADIjwn2F2KHvZxNu2p/r64/PfsEGAd5
	M1z790IRTP3EMiVSm3Qc4QqtkkejZnQjqcu45ZQ4A/VbCNdlWoAYFlrkEN6dqFmkJLZ+pN
	6xVtjJu1NwJlmBmixSfCCh1HPxF2bAA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823659; a=rsa-sha256;
	cv=none;
	b=fTGFIYgoEhpnVDIhhRjfOy4mGFkawhIWXy/sp9N7yHKLnvERaQCo/Uo0tJ/bBik66pkwe6
	nhDL27U+yo8qxsgLiwquAjSzMNbXH5AaTKjB85oUmzH+JHg4aeRuljDTJ3o2cPH2hApAQc
	x9Z/pnEqxB0d0aKfM6l3eDfCqtg8dOs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RmyBeAjX;
	spf=pass (imf24.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B18E409C7;
	Fri, 10 Apr 2026 12:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82685C19421;
	Fri, 10 Apr 2026 12:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823658;
	bh=Hb2dziS1cUz3f0ZYnY6mq4QP/VKrKM0StdHMUX+1BaE=;
	h=Date:From:To:Cc:Subject:References:From;
	b=RmyBeAjX6h1L2rIRLcz+AgNEdpyqYQZZkX4kYkgxpR9ZJA0/rvdow263wov/8PVOr
	 hb2QUP5GwQZouavgtAcs0bwbkCd8TxgfCVh6LWoo2a7HWknstglzPKB+9aabXFzH1J
	 rP1F6gK8dqeRn0JBTKdTohI1oCqed+5PigWBVmbAA5ah3505CMSHrUL7HPCCN4sGiu
	 NHT4954Kmifvfva6Jx9l4xaRzDUJEaSzZYxXiP8aChKSe2ykT1tpUU6RYxqauW7DoH
	 p3wDa9fQGCdDGL4OtStOnSEjWIThdsFEIiYqSYDvCq0zlNoVlLTrCjuWlgc/BYNO1M
	 jFsY3AL2zO6GQ==
Date: Fri, 10 Apr 2026 14:20:55 +0200
Message-ID: <20260410120319.593798781@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
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
Subject: [patch 30/38] openrisc: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam12
X-Stat-Signature: bqrhfce9f3zx1w8wn87cbu534phdnz3a
X-Rspamd-Queue-Id: 3969A180009
X-Rspam-User: 
X-HE-Tag: 1775823659-387265
X-HE-Meta: U2FsdGVkX18OK8GN1dyB6NrjpmXCacJm7zpmv1b6gX3Y2mHINV2cocOqon2g+aM19rGKSUEMXkFbR6JDJevhaHLu2TkcthlVOT0oKSOTvQi6EDx0436v6piiQknUvpvJFGoIzu0E59/G2+U1hD6VGBIzA/v4LvPemR1LaLcoNxAvJrkbHKwndFTXJuLYR2NmtJ9vxdRdfLPRbY5gAvWdQBmB4YjirSeY20PI/ga4g0C2RSeWvpBpbb6HtJ/knKCEbCgDzVybzt+4DP6Ln+vIz4NTy1JwA3saoBzwDb/tWaZch8NQvam8rhBxO9n5bF+Trcou8ZwxZw5pAQmY3OcE4f0YqD4t0R1KzhhaLCYHl+cyRbgUx12wJ5TAcGbWB7AmnV8jc3t1MqqvFuHptEHshAnMjyet5DHtwoKv4SUccDGPHbDrMZx7FrIZ2f5vNbWYEsgB91AY39hUPPRzsZCt4gWpM877dZ8HjoF4dqS4QP+WRdFnAUnKBwqhB+/+Ho8jKqrnZBFfF+pMkDVQgTMU8sXJx6oLDc4Sg27BW15iiz3T0OYOpxGDnoMmOcmPYN9nT9DhPzLmTUzmCqsXjQjXKS/g1ePd9+hlEbQqaPt+RntMtRg6zp5nURlm+MUSTmVMNz/aVGNszMKf5y7gbIbq1V2WKDrEosoozPnkksQSiIfK3QaBvdeAdz8DmQ+ZFdl50NJlGaqSpXzJv5QtYgmQuLs65VtG9envWJN9bakb+ZuXAVee8o6p6pCHw74qHcbpvO6ylgn0WkfvrrwU+fqpxjc1lENsHHgpzaQ3bLWNeOou6lipu9kWztaJNDea5K4lAZKA/SvtbzxJ44MIBrJ9yTzVT0Lqyi+HOfhmOK52cpzDrQuCocfaErdlx5OKwUGXfOhAptXqha+Tu/Y3hydObm/3kMeZ8W9IdRwJn4DSSDndPo/jT1r/dO/rzQmgGaoorPE6KcBPgKyYNOQ9gF1
 uGKO2s9Z
 5C5FGe7gMh/x5DZQ4RdBOT2eQN9gJWHt6vhJ7wGv72K1wX/MfPQHuuqyQ+BgjpRrA0GAIMvW8EoQH1ow0ccz7+IIaD6ppZ/CDM9WF0+ltFswvNEe7kBxdxh7yeofux/DFAfNZg20uktKsIdW7HzyhNJZO/2+G4kKzc6U9aAwa05PndHObp1DS8f0Fde4et84wSG5MlwZ4xpk4g4vmzveYk+rBbq58vHIDDdKDlqnQS6smLZRMzIyyZnZDmPXLg6ekcFeRNrJwifGYlPxilFFu3UxJEo4F70GEqx3N223Kz931WAWqCVzkK/1x8pdt3i08yEFbJQaGdkPb/oPJ9rVTMLd8YNM+DN5lJa+OSrvMAQhF57Og7Uwey9V7EmLwUeweFbSvfSDf4VT8ERkKmoIhlIaRf8bbIXcnmVSO/X+rmB0QyIG0kK19PLuQIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining non-architecture usage of get_cycles() is to provide
random_get_entropy().

Switch openrisc over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

Add 'asm/timex.h' includes to the relevant files, so the global include can
be removed once all architectures are converted over.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux-openrisc@vger.kernel.org
---
 arch/openrisc/Kconfig              |    1 +
 arch/openrisc/include/asm/random.h |   12 ++++++++++++
 arch/openrisc/include/asm/timex.h  |    5 -----
 arch/openrisc/lib/delay.c          |    1 +
 4 files changed, 14 insertions(+), 5 deletions(-)

--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -10,6 +10,7 @@ config OPENRISC
 	select ARCH_HAS_DELAY_TIMER
 	select ARCH_HAS_DMA_SET_UNCACHED
 	select ARCH_HAS_DMA_CLEAR_UNCACHED
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select GENERIC_BUILTIN_DTB
 	select COMMON_CLK
--- /dev/null
+++ b/arch/openrisc/include/asm/random.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef __ASM_OPENRISC_RANDOM_H
+#define __ASM_OPENRISC_RANDOM_H
+
+#include <asm/timex.h>
+
+static inline unsigned long random_get_entropy(void)
+{
+	return get_cycles();
+}
+
+#endif
--- a/arch/openrisc/include/asm/timex.h
+++ b/arch/openrisc/include/asm/timex.h
@@ -9,13 +9,9 @@
  * OpenRISC implementation:
  * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
  */
-
 #ifndef __ASM_OPENRISC_TIMEX_H
 #define __ASM_OPENRISC_TIMEX_H
 
-#define get_cycles get_cycles
-
-#include <asm-generic/timex.h>
 #include <asm/spr.h>
 #include <asm/spr_defs.h>
 
@@ -23,6 +19,5 @@ static inline cycles_t get_cycles(void)
 {
 	return mfspr(SPR_TTCR);
 }
-#define get_cycles get_cycles
 
 #endif
--- a/arch/openrisc/lib/delay.c
+++ b/arch/openrisc/lib/delay.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 
 #include <asm/param.h>
+#include <asm/timex.h>
 #include <asm/processor.h>
 
 bool delay_read_timer(unsigned long *timer_value)


