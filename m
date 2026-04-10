Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60DF6F4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF826B00DD; Fri, 10 Apr 2026 08:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C492A6B00DE; Fri, 10 Apr 2026 08:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5EB56B00DF; Fri, 10 Apr 2026 08:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A518A6B00DD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:21:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69A54B99D2
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:33 +0000 (UTC)
X-FDA: 84642556866.23.82B0C4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D0C7240011
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jCHje7Cb;
	spf=pass (imf27.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=g9ALE2yJnCpZX5YqdQYfLWAUyNKeE/FQChcdbmzeb0E=;
	b=GYEN60zHbR5akMugR9UHYg5XgcmxLPvxIU/WrdORJ0ocG9PqMAI2i7J1I+O1FV6HCLrF9S
	7p7NhoeKrx+/NhLDqVP/Y4sp0/FR9Tp6SaywkIm/0VbcaSN2SmI17Sb+B6pI8nBKUs8H4O
	3To+uCFqST29E4Z6htzQvzQOAiFrVpE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823691; a=rsa-sha256;
	cv=none;
	b=ismacvMvbnDsnbD0dMXd+t7Z2hL+6kouIqD2M5XIbQvDgkTVV+3cf4e+NEE9wIAMyCEksG
	Ixoyt4aLnsD01JTg8Fchw9EXv1kZleehLNQ0oK93JeSz6MFrsVTIQtbGfW/LutRiM8wvK/
	BJLHiT77Wm/QCYK2qRAcjMRU1KHhlCM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jCHje7Cb;
	spf=pass (imf27.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D91761119;
	Fri, 10 Apr 2026 12:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A92C19421;
	Fri, 10 Apr 2026 12:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823691;
	bh=Q+IGONPkRqfayguG6Txkx/mXXA1oIi3CJxpKCndboyw=;
	h=Date:From:To:Cc:Subject:References:From;
	b=jCHje7Cbtua5yolIUEErxzzrufBxMW0LYt1Kl8DVF/tR3HVJLQOi/32jC1MsFj4sU
	 FuxQN5MUq6aUGx6W7VIPg9yzFSdqaZMbr1tHN5zCNxM830u3a1p54HzWCg2l8d0SzU
	 xyIH4nNx8yib1hODU1iz6RiEcKM7mp5gg40/5f4Y1z++7yY40Cew7vRxlBQZnDz2BW
	 SRGp9xUTNtuoCzThvYns7ndknYQX1oh8mSimdrkytbEv0fT97jYIikQFCA2/G5YDNs
	 jkUQfDUfGpJwZkehI6Gounl+WGkLz5eknKnsUFvTrSUQCfxc7Qg1pWGasV1G+9O2Ak
	 9A3OklGLFCHng==
Date: Fri, 10 Apr 2026 14:21:28 +0200
Message-ID: <20260410120320.081003009@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org,
 Arnd Bergmann <arnd@arndb.de>,
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
Subject: [patch 37/38] x86: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: D0C7240011
X-Stat-Signature: xwrhhobs5jfhmkocskf7w1y5j69hgoo4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775823691-122789
X-HE-Meta: U2FsdGVkX18pLn8GCMO/6tXTM4XwwWjmDMJDBQtTrZyg+0Oygzh/WHzmVlraFYr/OUExOGO5zNfcxOxPzBLnblvgKYpIfRrQryy/xUBjoyYGnPG6gqmkAOx7HokwgFoJTl4i6PakDeaBgQRxLpNUARmtMxC4fYBGfVrgHaUXkn3yE0rJSr/6faTZNYa6bxLjCnn33Qvw63RuGuOni58lWv79pZlnjXeiDIpZKaTQ1q9HDgfJikY6VTVbf67IuTpWvCrzuj2wHgTgyj7A/WPo1rxPUQxcogD6ewRPyx+EXx82Kz0LBa0R3sLKSkmdXfcI4p7j1LQeyG4F5c84rIYeIjsIzKJqsNLDhyNPgvoBaT/JhRy02GZe862/yHyo3BC1/Lv+7OtGRkrKLS0xglDqjOnHMv05IfLjRv30xK88EmKj8sT7L4ssUIFF69O7GEbyrg70v2tZTmBokEuJ98d4wJXFgMRQS8DCDsWKr/6ev6M4X42m+uQyC+TNgdP84s8in5Qru0vDT0XnK19TuOkAICKNBl3hIWFX17//P/jW63ogv1VoLKNz3cvFD4nD1kzZPUuRNg7uzN+l/0IkiYNKVMogtc0vm7dga0CXG+0x75UTS4d7hsTWvwLVQ9Rtzorjo8RVluFaaFTs7tlkKERVAXZhRvwOpDlUhHErcAriLMOTjXBzt43FIRR3hxhuK0nS1v9T/l4+B3M/EnSbmbsdv6aNNP/jxizOgZLgvIKzy720CwiH19RikO/Tn4X5SrNHvxP2sG9SQJedjr9lGN7lJJnzeHc9YBnu36vRsn4NOBThAnXgOBB3AX7n8qlCDBQa6dwwHgVPu34HhNtB6UO6/QigeGOMb4+Ee4FOEWaLwskZGkK17JRd27qlq8QwYHGAvRmZXauYoV2Rq3g0rWoXqB/XVQLx9xdnREsrYJbevSugPobZK+JE5oIZRc7+ZVQ3KXerFofKQ5YWD0BGfUK
 +fq+H+pD
 zU2wIbj5feUHM51K+Hny6HWUH44S1MrBBCLA+dpEDhGMI6Jeq98Q9lzd1twH+FmQbsETntWCsVA0UrGGYKLumnGNcin8Y4edP7gK6mpYiwJOwrK8soJLq7ktu1o79k3ElQp73CuY4+SkPDnwDGg7yoh9Ydcn3idCRNzH4ldZjJCxq2lMW3gPBg2oKKKh+pkANXTlj4mF8q4OesJLS9SMSKLKbt1lsOYBOKrty+wReICjyOK9KIrG93hguy2ob6P/Fnx5nKovRoDbVRg/mpa79wpMmByFVbbu+YtbZNHbFkkJWSztsMXiCfThibAOzG1hXJw43+DVTkFv36aUhkAkyUHwdQ9zDP6SSxQm9QO0ahh31lD1X5gS4IuSZ3rj0kV4+XNwkwrH8TpofofQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining usage of get_cycles() is to provide random_get_entropy().

Switch x86 over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
providing random_get_entropy() in asm/random.h.

Remove asm/timex.h as it has no functionality anymore.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: x86@kernel.org
---
 arch/x86/Kconfig              |    1 +
 arch/x86/include/asm/random.h |   16 ++++++++++++++++
 arch/x86/include/asm/timex.h  |   17 -----------------
 arch/x86/include/asm/tsc.h    |    9 ---------
 4 files changed, 17 insertions(+), 26 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -101,6 +101,7 @@ config X86
 	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_HW_PTE_YOUNG
 	select ARCH_HAS_NONLEAF_PMD_YOUNG	if PGTABLE_LEVELS > 2
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
--- /dev/null
+++ b/arch/x86/include/asm/random.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_RANDOM_H
+#define _ASM_X86_RANDOM_H
+
+#include <asm/processor.h>
+#include <asm/tsc.h>
+
+static inline unsigned long random_get_entropy(void)
+{
+	if (!IS_ENABLED(CONFIG_X86_TSC) &&
+	    !cpu_feature_enabled(X86_FEATURE_TSC))
+		return random_get_entropy_fallback();
+	return rdtsc();
+}
+
+#endif /* _ASM_X86_RANDOM_H */
--- a/arch/x86/include/asm/timex.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_X86_TIMEX_H
-#define _ASM_X86_TIMEX_H
-
-#include <asm/processor.h>
-#include <asm/tsc.h>
-
-static inline unsigned long random_get_entropy(void)
-{
-	if (!IS_ENABLED(CONFIG_X86_TSC) &&
-	    !cpu_feature_enabled(X86_FEATURE_TSC))
-		return random_get_entropy_fallback();
-	return rdtsc();
-}
-#define random_get_entropy random_get_entropy
-
-#endif /* _ASM_X86_TIMEX_H */
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -72,15 +72,6 @@ extern unsigned int tsc_khz;
 
 extern void disable_TSC(void);
 
-static inline cycles_t get_cycles(void)
-{
-	if (!IS_ENABLED(CONFIG_X86_TSC) &&
-	    !cpu_feature_enabled(X86_FEATURE_TSC))
-		return 0;
-	return rdtsc();
-}
-#define get_cycles get_cycles
-
 extern void tsc_early_init(void);
 extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);


