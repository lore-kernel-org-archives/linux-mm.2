Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 302E8F4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AFEF6B00C5; Fri, 10 Apr 2026 08:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961476B00C7; Fri, 10 Apr 2026 08:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8500C6B00C8; Fri, 10 Apr 2026 08:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71D566B00C5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FBD459215
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:32 +0000 (UTC)
X-FDA: 84642554304.17.77F09AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7395A120015
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UacNbv5z;
	spf=pass (imf29.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=CLIogZKtxkoQJBct1ivrzjEJ9GwuhZlm0ijU/m5U3Ys=;
	b=h4fPOA3Ahl8nyLaMyP5aNDWdW7kKs+Xu9vdUXiyy0jlu/4eQXd2aqsAaI/YLO/j9Wr4n4n
	LVMj1p8wXAjZ9gVJqteayIIOJzkFowlWdSnUI8qYPWnteC0pBm5nAGxBNeZbfhGy4+Tuse
	yHFJk0Qgi2uknJ+xQGbXsZ9kBBs9oP4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UacNbv5z;
	spf=pass (imf29.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823630; a=rsa-sha256;
	cv=none;
	b=L/wupcpmj7Z6dNEqATwrkBLWkcXvBJgOYG4A7FQ+sqt+vAxz3Jc6PFNr+/b7XB24HD73vO
	88V+fPQMKTqqqAchmRD8ke/gVw2d877eBr3EFc31gEy0xgVYCmO8wVEytqr+PNIFfRJlXt
	G/FuZG9yCNtT9UPr11W7FxEsGTyAKjQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1972441C0;
	Fri, 10 Apr 2026 12:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8258C2BCAF;
	Fri, 10 Apr 2026 12:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823629;
	bh=Xj914OB0ywB5KtjAdUFbVTIri4m7J0/9GAWloccpVyg=;
	h=Date:From:To:Cc:Subject:References:From;
	b=UacNbv5zzA6AzbAlRM4n4U5NaKejyQd8mANj0iWZ5RQiRAJWixjyMgZjbiDhDTyzO
	 ay62PPnTA47MG/rmdeWa/4KfjNAnW4xtTzJ34RAhThlg0KY8nNByGNrsu9zE469dPQ
	 hWtTJvAZ4ZE2brA8ZCckIrkzYMvi5clv/chlzjJ3PYteh92RUSFzhMNQu3+ZTJTDCI
	 kJ6mPTSZ1AZhD1XvkSSEOtM9nEZR/77fxCsYwUjbpiFSE3ESK6EP7pbE6Ao/WrdTRD
	 AlaT3EdsheI/WmWdaf0zz7rbsJUIcktKioLIztC89PcrEqXmxk39mPCnXjzI5yFh8X
	 xNx6W4PqnkQAQ==
Date: Fri, 10 Apr 2026 14:20:26 +0200
Message-ID: <20260410120319.197793115@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
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
Subject: [patch 24/38] ARM: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 7395A120015
X-Stat-Signature: 4brbioacy9rqzd3rey3jsqw3osdms6gd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775823630-298460
X-HE-Meta: U2FsdGVkX18CheJr6wPEHlerjvA7j0aG8u5TCSPIg1/UeDtggOEvu4wUh6ryOWc2YLJVLNu30OE7/B1uW1hB+WqbNFtBDZ3q2CZreNVaRU32lEjoiqD+xAfFgUIo4jR/e79LC0Mw3NI0hq/+HPa5wllRTm0P2bupxJGHkZXIM4ekxcvw9U566Fsovaon8j/y6qMutNxGDvjkF0CBsjWPiqqNrLOgAs4JsKQ7eFpWkAEYy5YTN47TE5aJFKRe0+EzVYic6fsS1u/Aeg2qBUuQ+1CmqvcAVaDzHO6yoqf2fNsPwrIkU0KdNZnMTlfWxmnGgPOyOTZk18HfqcsK/dSXdFOqqIvIO4BytP7G8hIDijnoc4Gbtc0woNhEoQhfpZgkRctW8LIZUu34+WZG+vXj6uen828kdSFa78TMMjCtDM00nxSoirMwGN0ZpOz2tWuMh0t2HK8SmsL3lsePBq7576NggEVGusk+U9nE+cTwo4vUg+GmXCdpCArAd85EU8RxmEoNb5ag2vJA+JpFpKJMxtQ0KAqysuV++pOSAnNhS9c7dcSK/8W5vv2cR+iMPFvA6vtMXn4U8kcl/683bQ21H7l4+/JXJj5p8ExgkxVSlpHfvqpSiLrzTw+TGMeyubCsPiA7E4dNWNDqrEKsmoAb8kcvJkpt3h2MvFUBYczgCtL3NkpLFKmYNEUsx0M2avBpM/T5NdSIcheTdh6Zpiq66uv4YORtHBBDA2an/JF0eXv7ghPNzLCYrlQtBAtq+e/8CDSC/X/pXy7RU87hOrKMCY9VTco/lZCmbkHjjh2UnHdqHoLvae8qcNqooJM7DMEjYPGUjkca7go6NOdQDwyGHRTkApFKtZFNxYM7eggqu59zjVLsk99FM/Mul65TSzhBDivifPvmSAnvSDpj0/h+EO+UmXzCiywEc06ZkranEy1lvlfE2ZDaUOdLuRU7K5dBX6r5KZ6pvVZ3N6sdtN3
 MXppM3aT
 5wWWZLmr+1trRyHS7KJzERyKMkmaxz2iNf6JGlEq+guVi1bwu2gtpANqPzenea655cRDHAxqi+yosPTnHRIDjA7z1m2uw6Yygm3SKqdf9cM836FKgKas/UUHZjWU9SNfZYAEsoleGJlvE2F78yaCs79IrqrTkq0C5N4k9PmfW7EL8dzKefV5d3jzqfD3RqLT11hsjwBFviTbn1L5uYd1bd2BQi6MQEhh76x4YOK8NAyGNF1VpqL0pJGRCRTLA9O7rTZX6T94dpqk9Omhwaq9NHeBRqCqdwPzy2gUrIFqiBNTPLsxd4wvwTpjbb8SySLZZm1J38sjZeWjYfAq9mfiE4n9FfGOMkbhMuW+Y8bC4UqSwDkiWEXa5EZ2RCNMZU/esB2wfGU/JwTq+a6m9H9MSTlipfJOIdmWNcC6gw24C9MLyHf69lG+VfJmkQVl9HoV83f+DdUqe/Ees0A2li8bV44Dl0ZS6aSbB2JPj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining usage of get_cycles() is to provide
random_get_entropy().

Switch ARM over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
providing random_get_entropy() in asm/random.h.

Remove asm/timex.h as it has no functionality anymore.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/Kconfig              |    1 +
 arch/arm/include/asm/random.h |   14 ++++++++++++++
 arch/arm/include/asm/timex.h  |   18 ------------------
 arch/arm/lib/delay.c          |    4 ++--
 4 files changed, 17 insertions(+), 20 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -22,6 +22,7 @@ config ARM
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_SPECIAL if ARM_LPAE
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_SETUP_DMA_OPS
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_STACKWALK
--- /dev/null
+++ b/arch/arm/include/asm/random.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMARM_RANDOM_H
+#define _ASMARM_RANDOM_H
+
+bool delay_read_timer(unsigned long *t);
+
+static inline unsigned long random_get_entropy(void)
+{
+	unsigned long t;
+
+	return delay_read_timer(&t) ? t : random_get_entropy_fallback();
+}
+
+#endif
--- a/arch/arm/include/asm/timex.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- *  arch/arm/include/asm/timex.h
- *
- *  Copyright (C) 1997,1998 Russell King
- *
- *  Architecture Specific TIME specifications
- */
-#ifndef _ASMARM_TIMEX_H
-#define _ASMARM_TIMEX_H
-
-// Temporary workaround
-bool delay_read_timer(unsigned long *t);
-
-#define get_cycles()	({ cycles_t c; delay_read_timer(&c) ? 0 : c; })
-#define random_get_entropy() (((unsigned long)get_cycles()) ?: random_get_entropy_fallback())
-
-#endif
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -42,9 +42,9 @@ static inline u64 cyc_to_ns(u64 cyc, u32
 
 static void __timer_delay(unsigned long cycles)
 {
-	cycles_t start = get_cycles();
+	cycles_t start = delay_timer->read_current_timer();
 
-	while ((get_cycles() - start) < cycles)
+	while ((delay_timer->read_current_timer() - start) < cycles)
 		cpu_relax();
 }
 


