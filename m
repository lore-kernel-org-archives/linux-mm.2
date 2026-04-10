Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E12F44850
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE5516B00C3; Fri, 10 Apr 2026 08:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95396B00C5; Fri, 10 Apr 2026 08:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83D06B00C6; Fri, 10 Apr 2026 08:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A359B6B00C3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 74ABC5888E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:27 +0000 (UTC)
X-FDA: 84642554094.13.E40C2AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7FB3C000E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c0dC5Jtr;
	spf=pass (imf10.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=ckn3790Plbsh2S84qXvQH3wmGMizlSPUdQHepF2eyP4=;
	b=27sLmVLuXpHgXnkagjA4Qwvh4BTAIOF3kRK7FJZd14jxNKQDjjVlA3jY8qt5kL29PAANt0
	vZH7TCxIlfJAwGytG5Nd8tN9eaHlOVgidD6hGC8qWBaVv0R439B6ak+z23lGhf/zg3wwJ5
	+yPdA3iAc2sfipKLDrnOtmL4m6pew1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823625; a=rsa-sha256;
	cv=none;
	b=VlF/et6Bz2ZhsDqHeGDDsBAz5gqeFFEL5CIwWP2I8Ywt4sfM55Bs8t3tkdJG6zLA7H+pQz
	PLwb19WDiijVuYPj+k4KYsqBRk5DpiBY0xTfFMdajxUcRaqgYwVlkEMl5nFOiWBxk2mlgJ
	sLqbfIn846QfbKmhkZH0zU8/+krq7ko=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c0dC5Jtr;
	spf=pass (imf10.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A040C438DE;
	Fri, 10 Apr 2026 12:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8D1C2BCAF;
	Fri, 10 Apr 2026 12:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823624;
	bh=oFanz67wDB6XocOAPDGw4dDZpTIkPCesLmisdDG6nxo=;
	h=Date:From:To:Cc:Subject:References:From;
	b=c0dC5JtrlZ2hDwVhQHVakSSF0GbYurUcyOeInN2NikRGB2GB116TXZbw4nZgMtYST
	 +trrlORaNRGlhOHpfrC+lW1HFBRAEy8GyOUXKZu1wlydXKozlVO6l7tAEsojNrD9kY
	 z8EDy3AU6BDmVg1em2KMGfc38GeNfIIV9PZdmIDh6XXPID1ZvpPfEKL37BFIXkriEy
	 vg9bLTMeocXCte6TCzTTMg21Eh6HrXJDyZdGV1tmWvL/lAElJukNPv/QpJCLNXioOw
	 AQtioNlgi2FcvW/yMQPolJ5GR/97GritVQBv4kElLuN4ah4YH0PTQC3eZtbzxU1vfd
	 IORnVjKLVUNIw==
Date: Fri, 10 Apr 2026 14:20:21 +0200
Message-ID: <20260410120319.131582521@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
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
Subject: [patch 23/38] alpha: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam12
X-Stat-Signature: sryc1y3thod5p7z88ytfbomk8wtaguqa
X-Rspamd-Queue-Id: A7FB3C000E
X-Rspam-User: 
X-HE-Tag: 1775823625-171481
X-HE-Meta: U2FsdGVkX18pPTw00qm2et8adT3IAlkk4Eh4wrp8s7iV+e0vDXX8ipqGpOGztQMn8AMx+jqI3ZYjoBjKbuW18BL3gFzk02kMgcrY0LqkzhBMe9tKLjTc63DEwZxeRubsKfFV+BhUQSj5AkaD1ZNUZ12ohco3zu+z7AVhnzYJ+FjntiEqI7nIAPs9xMcZVE6DQmcD60QTgkYSIA+skqVZPuzulGgno1KFvdq+tepSbP605qDvCrGQSCIUf6MseGOlhOb8OvcgbsOPSPPR9U4wlGRAmWY31ScU0uC9sbMl5Ua+zXBrAyKYHM0jOamwoI41CxUv6yFqleozTY6Cvj2S6uy+b8IvTxHuc2uGL4IAKz2P1QlWyzK5hVqgmAFRZa375V8HrU8WhvuHpe+TCMke8RcuPPYNwKgNdQiAePlzX4Zp55Rxk4ud28eiU6RsDhNKfCqLUaSqtqD4K9e9WpXCHkqR+TMMIZhvFo70POEKZrHGydS+jKDekHQcbf6qtslvXf1OaNVjcZRRA8R3/M8IpSIKjvRrdkIWGT5FWUOWesGW5NfaOgLk7XWBaRBwMHNdhaCf83lQ2w1dUj3Y65LPzkWiItfP4nF/Dvy2Z3Hw9JolATdvJolCgMLtqBXZIw0yqXYCF3ePVShJlo4Q2YoZu+UvNYEUIjTTWYZwUccrOBXbaUsA8XG4GT4EaPVi9Fwj3Vtod32OCotx031Z9SXEQK/LPn3RYxo3fSmcjESptSncGNZgXLPBaAHfOztVXSmroY9yFZSSn+TP+rwaXaZNpiUWdq2REFmgyu0Z/RB/x49a0MiPfqb5+i5iRsQoZHsPUwnYCuBW/lFJied3uVcVeKzzwLvoeYFYc4DC+bf142yLbXdAXkJkZFGjDKk5JnBrtDtC8YRtIFDBLquq09zU7w4vEmFeedt57GvV30Ho/G0oW039Ud/sUycRawQhUVGzrafQMJnv+le2yRT/NCH
 Jkno9Fgv
 hK4TSj6NiDz5pg4rQ/CNBzcyyu79Bn5FjGte+Cy5kpj9L1Xo5TTuGxFWoCiX4l0gYrkfYcvmXUOqZ2lhVU9zWXG2BLyU9asVwVhXJbTLte1AEqOgR5un3vxvz2pAPNl1aiY8P8Qqk9vf6ASQnaWWVnxI6w2N5KRc0cG7/kqhEF6lqBIa8rfOVDaUOmBpcwINAk7IgS8s+gkS+IGJSf+8cei25uORwOlQxL+CMIzq/dzR7e/YlY2RZ2iqbUIk5AaaOmxBAWlvfZVysdZ5Y+J7AVPQI/v8Nw0uSrjdJEzP8FSmjRWH8FDxKiOUv83vX4JRr18LZcRAmh6xSumAMm2wVuNTacJyc86xavhHQugeCS8c47THVYwBQnttSKC/MLNekwFR7NdNP/Vpb5SOMSNY4UlO8t4LRz5wlgQFElZPPz+kh7zQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining usage of get_cycles() is to provide
random_get_entropy().

Switch alpha over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

Remove asm/timex.h as it has no functionality anymore.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/Kconfig              |    1 +
 arch/alpha/include/asm/random.h |   14 ++++++++++++++
 arch/alpha/include/asm/timex.h  |   26 --------------------------
 3 files changed, 15 insertions(+), 26 deletions(-)

--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -5,6 +5,7 @@ config ALPHA
 	select ARCH_32BIT_USTAT_F_TINODE
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DMA_OPS if PCI
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ARCH_MODULE_NEEDS_WEAK_PER_CPU if SMP
--- /dev/null
+++ b/arch/alpha/include/asm/random.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASMALPHA_RANDOM_H
+#define _ASMALPHA_RANDOM_H
+
+/* Use the cycle counter for entropy. */
+static inline unsigned long random_get_entropy(void)
+{
+	unsigned long ret;
+
+	__asm__ __volatile__ ("rpcc %0" : "=r"(ret));
+	return ret;
+}
+
+#endif
--- a/arch/alpha/include/asm/timex.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * linux/include/asm-alpha/timex.h
- *
- * ALPHA architecture timex specifications
- */
-#ifndef _ASMALPHA_TIMEX_H
-#define _ASMALPHA_TIMEX_H
-
-/*
- * Standard way to access the cycle counter.
- * Currently only used on SMP for scheduling.
- *
- * Only the low 32 bits are available as a continuously counting entity. 
- * But this only means we'll force a reschedule every 8 seconds or so,
- * which isn't an evil thing.
- */
-static inline cycles_t get_cycles (void)
-{
-	cycles_t ret;
-	__asm__ __volatile__ ("rpcc %0" : "=r"(ret));
-	return ret;
-}
-#define get_cycles get_cycles
-
-#endif


