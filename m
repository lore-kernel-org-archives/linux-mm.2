Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 893B4F44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9CD6B00C7; Fri, 10 Apr 2026 08:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A936B00C9; Fri, 10 Apr 2026 08:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59716B00CA; Fri, 10 Apr 2026 08:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2E086B00C7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82560C1D9D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:36 +0000 (UTC)
X-FDA: 84642554472.19.D80EF0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA57AA001D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UsSMuuI0;
	spf=pass (imf15.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=T5BmJ1FF4HBJvfl1JxkNrWx4X3v6jSPy5n7OMhgiRsc=;
	b=ugDnFlhoO3QumZ0Oe9w+rP7sEE3q90Z6izVfKznS/BdAFxVblHWmcYLJYldaUKoR9NytE1
	PFPmfIqAKaY/aVnSk5EYxPqjkDfgdmAOdi+SVDZLeGVgZFSAfUU/As2IyzTvwHoaSUqp6S
	KnclkrpHqsdUNRUOSkeISJIlHolg1nY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823635; a=rsa-sha256;
	cv=none;
	b=A1bljUBY2iO7LUEzkKjxMCfeY4KJAkN6HMK/bHUTANGGnpXjdVqUeT29zm/hhIcd2W6rD3
	yM1Xzn//SfxF+V2qsnsk790xCTyI8xkqyxuUYv1g/RGlX9/ZDQT9TvLQNGpp9mDZhyzTKk
	TAmN2UCOczt7ho1kLNFZhCkURV9+K/M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UsSMuuI0;
	spf=pass (imf15.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C7C26024D;
	Fri, 10 Apr 2026 12:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59123C2BC87;
	Fri, 10 Apr 2026 12:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823634;
	bh=dDZlZkUBE8Yoz+Mf4b2btSZILqeS3wHEYjrON1rjw6U=;
	h=Date:From:To:Cc:Subject:References:From;
	b=UsSMuuI0fLabe+4dL8zTL2gq7n1Qam6gWMJ4FfKEoBXmYXreb34mK0jfpqexOCcjk
	 URd+7aIYau5Paex32UCyAHBB1baazBC53HlWWmD8jGnelNjcRxfUYPATekVzRrqJDT
	 SM4YYaTAd2jF6zuzF3s9v75IAyeOupGmOZUxJte/r7FKLtBw0S1j/Gfer+oeitcrs9
	 GcWasj5F60hnX72mh29rwAv4UlAzszLEnt4a+71ByOcLxgUh/fQSei1PCaUTQnLPFS
	 AyV/TWXRXX6WJrt/PID7Ovi55s49ArxiVCGwFwMjqqfxuev0KPjerElNRcERH69T8a
	 bfdJGP+BHG9rw==
Date: Fri, 10 Apr 2026 14:20:31 +0200
Message-ID: <20260410120319.263143276@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
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
 Russell King <linux@armlinux.org.uk>,
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
Subject: [patch 25/38] arm64: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: EA57AA001D
X-Stat-Signature: 5xirac9jhrpxtbpu8n1m83okdyeqbnap
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775823634-151423
X-HE-Meta: U2FsdGVkX1+Bm5boG4FMxQ4C4bk00MXozjR5XIFtWXQztgmftuWU6BrhM38cOaBCsWadZgi90eSjPtEGxp6CdAtJ+7dYoVXjiWeIzYRxlmNK0MH0nnS1L8r/OH1jiTRaIasZcwe8sYZOIDHIDBtDWb9CwHvNm5ojK0zg8CH3XE12apA0n87zk0OhqimUhVy8UZLa+xIyzwqZmjA9JzZz5UFtLKAzip1SFYcr8T4mO/RSF+xcsAOrovwVIHoiWGuW7srZjxWThxJWeP8JGPd/HTVNXwnQVZcoTb+DXKcAed8Ogyzivfqggzozg5dm7GiWOdZ6QRuVweeoGlq9AOQcfirpLt5/DxREBbai/xA9A5h8m6neSm1mPfZbZ6IpWd3mFRE+BXXqdnegTImmVIhMj10rh+nBxXh/GMOaiHTzm+/mJ6UaTtdcnJ5m6VTDmjJ3TpQyd3jBSqBMyrWprS6uPZFQ0QoCZGLOLupvpj0U6pFWymcaDt4oWXbuOYA2he4UM+OpFExQmWyyYPgm13tH07k0gchQvOz/Y9eIM+T5a1Ib32f+5z2yECB4+D8Na3DfT20pJ649+nveBc7xDp8QjcuXW+N0GNQvyusf678pzrCOwNGDNeHTK7Ad3aON/Ihm6gBclSma5dMt4wtOGHAbVK55YTwTW1Ch80qXCjg2fmDCvm/RJHC5y0njWiC/5msG50dCCixjtAbSJzXosCJqa7vvU6YWP820z9EVFyK83zmorbuUD0BNQ3FOA27Q8jOVq1P17OzdrHK+FxElFSoeBj70hYsOjoIhdQ7n16iTQUuOAM+uDo0x2TEkpCz/mV2mkWXbbJUznmcjuTviTjoiY26ZDHlSYhk9OADProcdcXlj7Dn6X/8i1pcbAkzpy3OozUsnD9URtfG6IGMfHmHCFM4zzpFYRoGpV67mDfP3dOKuzC5VOmo/YMVvyJjFDNzoSWhDXrl64Un67eeSbOA
 sp7J+lOa
 7WgtLzaDY3+h7WUVjQ7xKsZ4HOJSi1U7t+yI6ChowogNrBSwUa2VjoknTHgKZueojDiMNxdTGkI9xjX0i3cYxptsjOE098RLwfINJ7pG9oH5HLQy4mgG8qVkKRlt4WnzNVd/xwX6T7T6C/DzzDI1ke0f/OWHMHrM8UpslpqZAe7UBmjqrga39GZ55Sp7eG37KKFO/jd88ut2ure1gfJ9dvE9ch2nnbLI9F4yokVo1Q4u3OkbVMuHAlhvcxzg4mz9ZuEjhBiSDG4IgAS+w4o0lC6ks84jsZfFhDWJr8M1i/PZq4C++LtRAEoWK5lPa4DQV12OSc/PiwLiP3CjTx6piuSCu7ZBGXIkokGMoAZ3nLIvDwRl4SCfvuA3zZdqJcYlG5UnTaxXKicCQJf2ntAwG96GQAjmnj9iNHql2fwf6W5eFSSCHp+ch3on8sl9o9aJKdSJb1qedr8KKdxypidPMlVOe1hZ7vGs/mKuo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only remaining usage of get_cycles() is to provide random_get_entropy().

Switch arm64 over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

As a consequence this unearthed a nasty include dependecy hell where random
code including rqspinlock.h relies on a magic include of asm/arch_timer.h.
Including the headers in asm/random.h turned out to be impossible as well.

The only solution for now is to uninline random_get_entropy().  Fix up all
other dependencies on the content of asm/timex.h in those files which
really depend on it.

Remove asm/timex.h as it has no functionality anymore.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/Kconfig                      |    1 +
 arch/arm64/include/asm/io.h             |    5 +++--
 arch/arm64/include/asm/random.h         |   11 +++++++++++
 arch/arm64/include/asm/rqspinlock.h     |    1 +
 arch/arm64/include/asm/timex.h          |   18 ------------------
 arch/arm64/kernel/time.c                |    6 ++++++
 arch/arm64/kernel/topology.c            |    1 +
 arch/arm64/kernel/traps.c               |    1 +
 arch/arm64/kvm/emulate-nested.c         |    1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h |    1 +
 arch/arm64/lib/delay.c                  |    1 +
 drivers/irqchip/irq-apple-aic.c         |    1 +
 12 files changed, 28 insertions(+), 20 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -45,6 +45,7 @@ config ARM64
 	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_HW_PTE_YOUNG
 	select ARCH_HAS_SETUP_DMA_OPS
 	select ARCH_HAS_SET_DIRECT_MAP
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -100,12 +100,13 @@ static __always_inline u64 __raw_readq(c
 ({									\
 	unsigned long tmp;						\
 									\
-	dma_rmb();								\
+	dma_rmb();							\
 									\
 	/*								\
 	 * Create a dummy control dependency from the IO read to any	\
 	 * later instructions. This ensures that a subsequent call to	\
-	 * udelay() will be ordered due to the ISB in get_cycles().	\
+	 * udelay() will be ordered due to the ISB in			\
+	 * arm_timer_read_counter().					\
 	 */								\
 	asm volatile("eor	%0, %1, %1\n"				\
 		     "cbnz	%0, ."					\
--- /dev/null
+++ b/arch/arm64/include/asm/random.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ */
+#ifndef __ASM_RANDOM_H
+#define __ASM_RANDOM_H
+
+/* Out of line to avoid recursive include hell */
+unsigned long random_get_entropy(void);
+
+#endif
--- a/arch/arm64/include/asm/rqspinlock.h
+++ b/arch/arm64/include/asm/rqspinlock.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_RQSPINLOCK_H
 #define _ASM_RQSPINLOCK_H
 
+#include <asm/arch_timer.h>
 #include <asm/barrier.h>
 
 /*
--- a/arch/arm64/include/asm/timex.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2012 ARM Ltd.
- */
-#ifndef __ASM_TIMEX_H
-#define __ASM_TIMEX_H
-
-#include <asm/arch_timer.h>
-
-/*
- * Use the current timer as a cycle counter since this is what we use for
- * the delay loop.
- */
-#define get_cycles()	arch_timer_read_counter()
-
-#include <asm-generic/timex.h>
-
-#endif
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -29,6 +29,7 @@
 
 #include <clocksource/arm_arch_timer.h>
 
+#include <asm/arch_timer.h>
 #include <asm/thread_info.h>
 #include <asm/paravirt.h>
 
@@ -52,6 +53,11 @@ unsigned long profile_pc(struct pt_regs
 }
 EXPORT_SYMBOL(profile_pc);
 
+static unsigned long random_get_entropy(void)
+{
+	return arch_timer_read_counter();
+}
+
 void __init time_init(void)
 {
 	u32 arch_timer_rate;
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -21,6 +21,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/xarray.h>
 
+#include <asm/arch_timer.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/topology.h>
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -30,6 +30,7 @@
 #include <linux/ubsan.h>
 #include <linux/cfi.h>
 
+#include <asm/arch_timer.h>
 #include <asm/atomic.h>
 #include <asm/bug.h>
 #include <asm/cpufeature.h>
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -7,6 +7,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
+#include <asm/arch_timer.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_nested.h>
 
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -18,6 +18,7 @@
 
 #include <kvm/arm_psci.h>
 
+#include <asm/arch_timer.h>
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/extable.h>
--- a/arch/arm64/lib/delay.c
+++ b/arch/arm64/lib/delay.c
@@ -14,6 +14,7 @@
 #include <linux/timex.h>
 
 #include <clocksource/arm_arch_timer.h>
+#include <asm/arch_timer.h>
 
 #define USECS_TO_CYCLES(time_usecs)			\
 	xloops_to_cycles((time_usecs) * 0x10C7UL)
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -55,6 +55,7 @@
 #include <linux/jump_label.h>
 #include <linux/limits.h>
 #include <linux/of_address.h>
+#include <asm/arch_timer.h>
 #include <linux/slab.h>
 #include <asm/apple_m1_pmu.h>
 #include <asm/cputype.h>


