Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D50F44851
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607FB6B00D7; Fri, 10 Apr 2026 08:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8756B00D9; Fri, 10 Apr 2026 08:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A686B00DA; Fri, 10 Apr 2026 08:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 347496B00D7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:21:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03F79160511
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:14 +0000 (UTC)
X-FDA: 84642556110.27.125B25C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4BF2B4000C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t+6BdojJ;
	spf=pass (imf12.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=2HK2S+YO7fB4ujSzajjkO7eLLa83jA73mkIKAqkhMZw=;
	b=SFqeZxhrK60AQzh+i4YvRaCtAap8Yq0lBB/C/Hk3nRRBbbIWU4TrCUNGoDSDgSfrU6Z+WK
	MN1Jvh/q208is6RwtXmg02f0gTz5y985nX8ciVJzCGyagZu61ncxXLtXw/uzgXFQ0oxorx
	hGg6s96rXNSbICZTb9g93K8+C78pSB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823673; a=rsa-sha256;
	cv=none;
	b=xUtm31hV70lTDpPGdajeKpoORPHULM1b1feukpwMKIkX/NbBxXFOuFiPPCCQY9yijywtjd
	RAq2TXU7d/F+CKg0WcwEb6MpN2M0uAEUP6JnZ3hJxKiJ5EhpqnsqJb9xZiHWkLvOgX5ZAE
	8p1Wcfq435/ZINbTH3nfrsZmgwEgteU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t+6BdojJ;
	spf=pass (imf12.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E75043A9E;
	Fri, 10 Apr 2026 12:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4B2C2BC87;
	Fri, 10 Apr 2026 12:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823672;
	bh=tpcbJjrROej8+Ep0S4yh9w/0viNOJRSIBsQtj9nrduE=;
	h=Date:From:To:Cc:Subject:References:From;
	b=t+6BdojJde/UDdVdrSTxElEId1Y48xNZSVlMYQlGTL0WHNGFs3HWPQxpINyMlW0Tp
	 I6cN87TfGyJy1fhgMX3eHxGWXyIRGEfK+oj+v7ZqgSkuHT9TIqDSO48kfeefrr2R+6
	 RZvls6BOQPsjm5E39PGBUAxS3ybrYUwTjTmhDryNFYGgOGgmcHGql9J5M/vSFS9Dpm
	 Ps3dk0/gjV2/aMyaPlsNujNJN/7qos+7ycvHmAQEpnPn1tOePEJ6rKipC5ku3IQ4UE
	 ud6vC+9M6N71X0VBW7hJfjso4CmI7VrrHXujC0k5eBTPHkHx5czFPyyVnepx/5Zgc1
	 GRj7R63OiiEsA==
Date: Fri, 10 Apr 2026 14:21:09 +0200
Message-ID: <20260410120319.789114053@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
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
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 33/38] powerpc: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam12
X-Stat-Signature: o6p8mcxqfrni4enzmyhoc3jo1wakhty8
X-Rspamd-Queue-Id: 4BF2B4000C
X-Rspam-User: 
X-HE-Tag: 1775823673-433175
X-HE-Meta: U2FsdGVkX19oZ4+KwEbb4nXP/7pSq0yHD4KvCYt+O/iS7CARsW99Kp8fbDY1RfBhPhIdLlY5fV8VajSgkA0ilUP2mLT6UcYEOxHXqiuQMelsJpUAIpJOAlnejEnKpUCM1kafocVJiXtNRFNnw9rTJMsawazmz5b6Ep+n0nYbToMGhiDC1PTmLs4RgIlkoUz1qUb02wAvc98IPbRIDb3gUcSNYw3lKTxsws/K102/A77NPdkeMUYP9GA6DXyD2HhipEzPYbpOs9ybsqFp1H/8DBy46c/RN3d8eSlUcusOptCXw5gTLsaYZB9hZHEcqrCtdujhpTlMoDdbalciwO8BLHdXrSE2CbgaUf3+gjWOIHEXkS4xShnAKXk24Nc/p+BXRiowJheOAT4TVSS32s9qFzNcyU6eTfpnCdJAptW8LOCgnBDyrZNJWu7d5+Qokiif+DXHKFv9OQRn0dkpR9ntdgBtmZjPNAA2/daVLHNEcgt4qj892nSFwX6DMBvh0Ch0t+UoDBGmBGTBnDCp5pwkPenqY8cQOdFU/W7z6dWzrReOd2Zs1NuvDVLMmHEgKHio6rqVXuLhaBuXZ+cf0z2L7vENDi0wLt/PM0xFR04qFCJebByNhyKtWOrI+UCBD0x7RcvwcBrqN3JFxWJra4XUJ8uVZCmFL242j4DyHnRiLQ58xOhej+QEuhrf6J33cK1CDa29mNRluMyECkaXRJFlD+beG49UwUSlG1IbgnhTGZ7egs7YUFp1fdrsl8Bfog+HpmGn232j5LIpsnfDIatzAYoUZhlCE0m0BI2qOdSfE17I691vZGjxjrSTSJW611GiRRtq5FytW4SQ6GDZtetCx5e7cJqwkrJRx/i3dJiozI1omewRoxJXK5rS4DNqpN+DkooSdGR6F2ZQcZvVJljC2wEIGjnHW8OuhcA419DowOartDVDaforBbC3KlrTG497hmEphLse9gojgqYWk91
 BSFOBFo5
 LJXXVlZkXevvQXkm/Vi8X+gizpShDv/ma3FYN8f3/MLjxFOLWyHSZkQiIBADmoLp9E35G63NhwTANeobUsXBlL9sEj98eqS6YMjBfHtqfEjA4fBKPnzNvLOeSB6Mf9z/2c26Heo3pz7VIEiEdQUuwH9HRPP6EKBlavIUDDp6aEr2B/TZSp9yek55Pk+LjSyezJEjilWfRn2+WoXuOOvWqDndTEGM3KsdqcE7V4sbjOKPN6Za8+sWjjMIcAy9DrF+WxxgGZgBzXHrgdXZDq5eafykWFMgz95M+UfQWEEfA8kMd6mUTUjWv5n5oVljbE0xPsIxVHE4s/mriOtaCgLsl8olOhJ+1zP00Co8i1yUovJg9iunoVLDYoHhKhv898KIO0iPFkPjLZs20zatJKyz7XSQdl7sLLlwNGfJ5sT0+UhZN1B+tvqCnxyS/t708hEDTQ4lYQNu5T5s8v90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining usage of get_cycles() is to provide random_get_entropy().

Switch powerpc over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

Remove asm/timex.h as it has no functionality anymore.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/Kconfig              |    1 +
 arch/powerpc/include/asm/random.h |   13 +++++++++++++
 arch/powerpc/include/asm/timex.h  |   21 ---------------------
 3 files changed, 14 insertions(+), 21 deletions(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -150,6 +150,7 @@ config PPC
 	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX	if (PPC_BOOK3S || PPC_8xx) && !HIBERNATION
--- /dev/null
+++ b/arch/powerpc/include/asm/random.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_RANDOM_H
+#define _ASM_POWERPC_RANDOM_H
+
+#include <asm/cputable.h>
+#include <asm/vdso/timebase.h>
+
+static inline unsigned long random_get_entropy(void)
+{
+	return mftb();
+}
+
+#endif	/* _ASM_POWERPC_RANDOM_H */
--- a/arch/powerpc/include/asm/timex.h
+++ b/arch/powerpc/include/asm/timex.h
@@ -1,21 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_POWERPC_TIMEX_H
-#define _ASM_POWERPC_TIMEX_H
-
-#ifdef __KERNEL__
-
-/*
- * PowerPC architecture timex specifications
- */
-
-#include <asm/cputable.h>
-#include <asm/vdso/timebase.h>
-
-ostatic inline cycles_t get_cycles(void)
-{
-	return mftb();
-}
-#define get_cycles get_cycles
-
-#endif	/* __KERNEL__ */
-#endif	/* _ASM_POWERPC_TIMEX_H */


