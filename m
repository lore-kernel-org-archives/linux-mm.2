Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F080F4484C
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6B7B6B00C9; Fri, 10 Apr 2026 08:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1BE46B00CB; Fri, 10 Apr 2026 08:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B616B00CC; Fri, 10 Apr 2026 08:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD0926B00C9
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8179DB9B4E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:41 +0000 (UTC)
X-FDA: 84642554682.05.F2F84D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D7B34160011
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q1INVKXp;
	spf=pass (imf08.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q1INVKXp;
	spf=pass (imf08.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823640; a=rsa-sha256;
	cv=none;
	b=mFCXWXjFL00pl87NJwIASG135mzSQtkNeLJgUjLMFV2aR9LPG71HOTJs+73W6Q2HFKc6RK
	GZXRUalFe6C/7NbGrT4qxdheKm+vd9rO6tUNecW4eO6nJPWWwwlp/XnYTrEte8OUfa2ppR
	JL9zDsu8uXgwSjuWteTm5MdTpTQ+AX8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=cA5fsHKS5zMwzBxci+DP1Qed/9F1OdcNJnHEKWRTFD0=;
	b=p+N2HWaLs1PvF6hsI9M5zhiCrNwidPsoQBGqZ1sXDDdds5BVIfthu+JIN5ZV9JrujXdcCe
	kOyRChIfpk+CU/Mz0+UeUZXJTaxA7UYto0wUPKpiGy64MQGS51ia+HObqnNZA8woJGOaqM
	OYIUmaMhL+JFrzsu/Le40Szltjs5KQA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1605941780;
	Fri, 10 Apr 2026 12:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1D3C2BC9E;
	Fri, 10 Apr 2026 12:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823639;
	bh=xuHY9CZoFUC3Uh1usl17ZiiMpll/sjP+R8Uwlr/gPtE=;
	h=Date:From:To:Cc:Subject:References:From;
	b=q1INVKXpZHtktKQFtR7J0+4UmhxfrqTk44NJDJ9JcHhB06YLNiRtKSdKF4mgJVuJK
	 SbcmSgsMKGBRlcg33rDyUOrFSOUDUDhFVtStbWiiXhg+24Wo0rvXGROWGoPGbTgWpY
	 1QIfeqOqXuPtKqCTAnTH/4z6y5eKaf0+C4alVsAJYiVtcktTob8TzqOeasZ85w0p7X
	 BtZas6qdu0vK0vHim0/6rol7iQm8En5aXNu+7ovbB+IOTj4HSKX+ow5cG7qCECZo1T
	 4BmBLkbX+cyQgBzFeuQcBUbwDEtuOB2nQvII7+MypdiMTP4ticoX+aM+zON4QU+Q9r
	 WXrWSNCF41x9w==
Date: Fri, 10 Apr 2026 14:20:35 +0200
Message-ID: <20260410120319.330598126@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
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
Subject: [patch 26/38] loongarch: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D7B34160011
X-Stat-Signature: aan1hjrpnejr5cbmj7d7xg5wbbpxfe55
X-Rspam-User: 
X-HE-Tag: 1775823639-201244
X-HE-Meta: U2FsdGVkX183LFzW7O3EOQBmPBaqB2jVdhBoV1BLrDXdi5NhwjlMwsniuBNWbF23DpgDwLv78KVya/kRZgF354irtZQNtdHWoe8z9qRjhkWElSD8RKJEVpfVuIjLBfOZU+VKXoPa8JbJVnYuyO/+vv27QDIDAtTpktT53DkvrVb+/JLzYdqKIW33agg1A3juqoaIamZ+Cul/NlK5p+R9o0XpTLfQp/UKN2b6CPLX8iuu9c209rIv6PCjJXDAMX33w33uRTlT4htX7mPrjpww8TEtoOdJg/B4PWwHH0G1ZNjqoz/BQz8KMuxnIjQW9+YjGUBrfnaZuWerxbra1SeGvN097pUQ9ic5ud9p81QwD6dG7oh87xPLBCBtSMpK9xJt/VZm5lBG4K6tTgF2Rh84DpsUDXNJpRK6GL8tqeqFNLjod99QU6nZBP2NjFv55HFtGtwswfKA6O1qOMse5BksUzdbrABW2n8BHPLDGNCnNOdpzxW6m5vdCSkGFrB6UtML1UtW8tlRT4Q/dDlU0bXJK2oxJvgeMehS4qjYRiH1Cw6DH0TOH8c8AJxGTjCDxUK52kaFTjCWsMG74mg7wnYs3meP+3gCcfqv5uEzSqR6GTafFY3UjmpPb0hHPEm9TDK39YfaLcixz93NRb6tcSQZqmgs8p81yWAvfGjlewLPPJI42gqWKw8GldBpKl1NhOTI6iGiWk/awJKGyITR5Reo7zHIugGbKvqP/Ul4nUfJ8gb176o747ZLhcei+qFCyafntsCHillOkv1aI1Xp3lUIzefn9WHKhTV+T5TLrSAgP3rCjkcnnsyGCpZYoNpCpTQHdrA+K8u6dvxPuB+GubD8H//ScxD5zMUd8hl3OBoLPvelrf/LDBdIQ8XP6CT7Ub8AaCb3nf+f6WIWk5943uNjbgFF4hMTOVWFz0Y8DWhldY69MtoSZgcaSSEqX22ZF63Rw5BWEWFnbu7pCHOoNPk
 AphmSpYb
 jOz6wKEATV0yDrpKj+9yDO7c2EFqfSTq6ljXShMUg4eTCjz0vxgPH5d4Oh6B72JwlC+xN2THGMOGeCu+32GGckDEzXg5HzZ+phtqmKtdwkhlazZDdLYMH7hgsdxcmAwUyktc7NEUHwncIWJlML7Znv/pblW4QQMfXT9XvUUOMedwPETj1FyeJYhMbMHt8n/YGQTOIdjlC6VfG6g501kpJkKWxGlhEYKK3iHFYoo1OCP/CKcdsO5oUPxFXlyd0l7hEh2ZbJmcmoBxdpOixBs4NSWAgoUpxPmBqdsjihVqxtZAD+0aoLsQd+tI0z7JFFGOBrupTf35MtIneQULWGWDS2WRonjbYtJNhYV3qCg1kWPv/pNbjPcwdOuIwCI0UFh9YdPDYlVojfo/4dDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining non-architecture usage of get_cycles() is to provide
random_get_entropy().

Switch loongarch over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

Add 'asm/timex.h' includes to the relevant files, so the global include can
be removed once all architectures are converted over.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: loongarch@lists.linux.dev
---
 arch/loongarch/Kconfig              |    1 +
 arch/loongarch/include/asm/random.h |   15 +++++++++++++++
 arch/loongarch/kernel/syscall.c     |    1 +
 arch/loongarch/lib/delay.c          |    2 +-
 4 files changed, 18 insertions(+), 1 deletion(-)

--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -26,6 +26,7 @@ config LOONGARCH
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
--- /dev/null
+++ b/arch/loongarch/include/asm/random.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
+ */
+#ifndef _ASM_RANDOM_H
+#define _ASM_RANDOM_H
+
+#include <asm/timex.h>
+
+static inline unsigned long random_get_entropy(void)
+{
+	return get_cycles();
+}
+
+#endif /*  _ASM_RANDOM_H */
--- a/arch/loongarch/kernel/syscall.c
+++ b/arch/loongarch/kernel/syscall.c
@@ -19,6 +19,7 @@
 #include <asm/loongarch.h>
 #include <asm/signal.h>
 #include <asm/switch_to.h>
+#include <asm/timex.h>
 #include <asm-generic/syscalls.h>
 
 #undef __SYSCALL
--- a/arch/loongarch/lib/delay.c
+++ b/arch/loongarch/lib/delay.c
@@ -5,9 +5,9 @@
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/smp.h>
-#include <linux/timex.h>
 
 #include <asm/processor.h>
+#include <asm/timex.h>
 
 void __delay(unsigned long cycles)
 {


