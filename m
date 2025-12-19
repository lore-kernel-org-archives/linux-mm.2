Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F067D7879C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95836B00C8; Fri, 19 Dec 2025 11:16:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35BB6B00CA; Fri, 19 Dec 2025 11:16:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43436B00CC; Fri, 19 Dec 2025 11:16:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 900C26B00C8
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:16:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18BFE57767
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:16:54 +0000 (UTC)
X-FDA: 84236724348.26.769388A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 796F61C000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:16:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWFoP8Zs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766161012; a=rsa-sha256;
	cv=none;
	b=k52H8D5x4MnUNiGmR36gsWn7mNqcPRBsM+bYqcp+HO5fa91i91gL1xRqMQYrMVglkDwOuI
	4Q91vUCcF+OacfF8c0NK8rhuK/JsfOmS7Q7MuYJpkTp+ve5gxlypwiIv80qhUb7uZiU1hj
	IlUx2LMys6NI+0zHVN/UAFPY6oQXT+A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWFoP8Zs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766161012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KgJjJXiTV17BhBdBs5ApeNOoNrgTIbF5yg2BLm3kDUk=;
	b=xXntnzvicJYcywN4zi8/1BAPX9jvoxkhHQ5d8TOL3JkMb4agQTLyjxUbBN+VS/gXLn8vjs
	0tOzjRsOwHrRI0NhlZ6wD45tGzz07M57X1t9jdOEUADEnJyEB4y+GyVCJjvLnVRlYg2jJG
	3Q7x8gJ169cc2MVAvrSoQoxmaDmTGWI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A8F1E60165;
	Fri, 19 Dec 2025 16:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5340DC116D0;
	Fri, 19 Dec 2025 16:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766161011;
	bh=n8EL94QbXkjpZrKNco8jY54zTJbVUAiuP3D8k2SB3mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWFoP8ZsYkLEYCvizSOtfAaPNjhLJqzsaF7tHY3aqA7oUXtgJO3ERCYDqUD2Js3e+
	 5R5GQI33x+FNwMdA3E8CZJRT4GQ969i4oVXw80U8LK3ks+idDCR+70rd4jVj2rwHCu
	 kssBP+UXAx1ooEXkfFjs0SmM6fYabVLEw6M6l6N0xvkWoXGdt/rIfFA2d216ZHS3cB
	 FIZAc5TXF6+EHaLenImHZnM9YLo5PcMNwpzayFQHJhxsfFSftTUlPHdETPa3CUsJPF
	 iGSBq0GmTIUzJkVMbAliGgGFOFRDBxBcKxHux2RePNHcYTYv3akMLZY0VVzM6zGNv8
	 fCH3UMvStvSpg==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Matthew Wilcox <willy@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH 3/4] ARM: remove support for highmem on VIVT
Date: Fri, 19 Dec 2025 17:15:58 +0100
Message-Id: <20251219161559.556737-4-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251219161559.556737-1-arnd@kernel.org>
References: <20251219161559.556737-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 796F61C000A
X-Stat-Signature: ntocda5rcrg9thzdawz9smceir4exhoz
X-HE-Tag: 1766161012-715489
X-HE-Meta: U2FsdGVkX1+28HuW5Smz3aElV1lZpBDNXcm49azuweOj5elak5ffkvL4ebSiI46T9GkSefmMKqxQCIaePFbvEQAEd88K/0fdBfurd+mrtHiRBczEKUJY7nsavAJn7EZz1+ljnz3TMC98qmFWt1tehmfJVhlzHSnzm5L2yrKH+peQo39gbVe+Q3WKdvLFqnZ3pEEOlkYtd4IewJ8F1GnyZMh1JtFJWyf5xAtDif0TI4Ads+QBYJOYy3m5HoGHZo9/8M9OZ7RdRXBtU5JQ69IDi61hV8quCfz8h+cRhNYRFX0Rn5OSg9dQNXQ4EXb5HwtmmeDc1doyNoSBuymj33PWiHBkiUk7xZO0v2x3UbVLIFLyo7ZZldB7yaRSgXcKEEpUK0fdWrbOBR+U4E70MD5zJIDz8H2QFyjzihgtFkbWwjl8pn5H49QzX3w4fdLLvZVXLPjgcIN0XjbGyZ9unsOshgB+DM42hBciWQ1DflurnL71UPzWLZaxbUjiNFD0eTUaybJ0sCvDwMc9djVu8E1VTOAYIYYS8XbTpMHI/Nlb+Y3C16IDrDxzS14hprxO98K3v+V4OuH4I2fK4dVoaN0nB8z4f5jUBq7f1s2Ok2G4CcOl30t6GeYIFnge070OAFWtB/Bg5R2kKh7OWgh6rvYhxFAxFN0GEikqBwyZcuMm/vONVNsAUwP5V4FlSYwse7FV7BB3yN4xLrtqWbNzu1IlI1cBoUJaQRv6/jYYlLwmWfhggn8dGCjyHIYw1XZbosFM4K9+R3AMENQf6go/pHqQk09Cp7scMjS62ofpBHe+qLg4sEfhHZFxEflMKVxDdXn7F4ZTw0RmHwDyoxhS++CyMCjzPPNtZjwxL4GGjYBJacnL8mQc+j2W/kfsYhGfLiTiWVAkO/xK7winD5NMrv3U+L7dU39f8sh/ro3etZx99cSzZH5VOvcQIO+iR38lREtrPUh4zQNNt45UPyBUds5
 Vsl7e7pd
 5W7OMDs5v7523UFZAzrAGzVxR9KkrTinuYpKJdTHd3q7kXfPdi/rKrR3hj/inkpY8jtPHM0T8Is7jyXrt9cYPLMyTwVRdf2tDsU36MA7x0deqlOo3iB7cHwq5L5enRCJkIdCnAhH1WmYRPaoDPawQKloH41aNf0GZBGJ5pxZRNj07cX/OPUxpRWByzbv/lmX12CP7OejbVT87hUhqJXd3Bwe2rzdvUr7Be218WExqbI9gkCg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

As Jason Gunthorpe noticed, supporting VIVT caches adds some complications
to highmem that can be avoided these days:

While all ARMv4 and ARMv5 CPUs use virtually indexed caches, they no
longer really need highmem because we have practically discontinued
support for large-memory configurations already.  The only machines I
could find anywhere for memory on ARMv5 are:

 - The Intel IOP platform was used on relatively large memory
   configurations but we dropped kernel support in 2019 and 2022,
   respectively.

 - The Marvell mv78xx0 platform was the initial user of Arm highmem,
   with the DB-78x00-BP supporting 2GB of memory. While the platform
   is still around, the only remaining board file is for
   Buffalo WLX (Terastation Duo), which has only 512MB.

 - The Kirkwood platform supports 2GB, and there are actually boards
   with that configuration that can still work. However, there are
   no known users of the OpenBlocks A7, and the Freebox V6 is already
   using CONFIG_VMSPLIT_2G to avoid enabling highmem.

Remove the Arm specific portions here, making CONFIG_HIGHMEM conditional
on modern caches.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig                    |  1 +
 arch/arm/configs/gemini_defconfig   |  1 -
 arch/arm/configs/multi_v5_defconfig |  1 -
 arch/arm/configs/mvebu_v5_defconfig |  1 -
 arch/arm/include/asm/highmem.h      | 56 ++---------------------------
 arch/arm/mm/cache-feroceon-l2.c     | 31 ++--------------
 arch/arm/mm/cache-xsc3l2.c          | 47 +++---------------------
 arch/arm/mm/dma-mapping.c           | 12 ++-----
 arch/arm/mm/flush.c                 | 19 +++-------
 9 files changed, 16 insertions(+), 153 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 921ea61aa96e..790897a457d4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1204,6 +1204,7 @@ config ARCH_SPARSEMEM_ENABLE
 config HIGHMEM
 	bool "High Memory Support"
 	depends on MMU
+	depends on !CPU_CACHE_VIVT
 	select KMAP_LOCAL
 	select KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
 	help
diff --git a/arch/arm/configs/gemini_defconfig b/arch/arm/configs/gemini_defconfig
index 7b1daec630cb..1bb4f47ea3c8 100644
--- a/arch/arm/configs/gemini_defconfig
+++ b/arch/arm/configs/gemini_defconfig
@@ -12,7 +12,6 @@ CONFIG_ARCH_MULTI_V4=y
 # CONFIG_ARCH_MULTI_V7 is not set
 CONFIG_ARCH_GEMINI=y
 CONFIG_AEABI=y
-CONFIG_HIGHMEM=y
 CONFIG_CMDLINE="console=ttyS0,115200n8"
 CONFIG_PM=y
 CONFIG_PARTITION_ADVANCED=y
diff --git a/arch/arm/configs/multi_v5_defconfig b/arch/arm/configs/multi_v5_defconfig
index 59b020e66a0b..5106fc2d2a00 100644
--- a/arch/arm/configs/multi_v5_defconfig
+++ b/arch/arm/configs/multi_v5_defconfig
@@ -37,7 +37,6 @@ CONFIG_MACH_MSS2_DT=y
 CONFIG_ARCH_SUNXI=y
 CONFIG_ARCH_VERSATILE=y
 CONFIG_AEABI=y
-CONFIG_HIGHMEM=y
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_CPU_FREQ=y
diff --git a/arch/arm/configs/mvebu_v5_defconfig b/arch/arm/configs/mvebu_v5_defconfig
index d1742a7cae6a..ba17bd3237fb 100644
--- a/arch/arm/configs/mvebu_v5_defconfig
+++ b/arch/arm/configs/mvebu_v5_defconfig
@@ -24,7 +24,6 @@ CONFIG_MACH_D2NET_DT=y
 CONFIG_MACH_NET2BIG=y
 CONFIG_MACH_MSS2_DT=y
 CONFIG_AEABI=y
-CONFIG_HIGHMEM=y
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_CPU_FREQ=y
diff --git a/arch/arm/include/asm/highmem.h b/arch/arm/include/asm/highmem.h
index bdb209e002a4..67ed46d1922b 100644
--- a/arch/arm/include/asm/highmem.h
+++ b/arch/arm/include/asm/highmem.h
@@ -11,66 +11,14 @@
 #define PKMAP_NR(virt)		(((virt) - PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)		(PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-#define flush_cache_kmaps() \
-	do { \
-		if (cache_is_vivt()) \
-			flush_cache_all(); \
-	} while (0)
+#define flush_cache_kmaps() do { } while (0)
 
 extern pte_t *pkmap_page_table;
 
-/*
- * The reason for kmap_high_get() is to ensure that the currently kmap'd
- * page usage count does not decrease to zero while we're using its
- * existing virtual mapping in an atomic context.  With a VIVT cache this
- * is essential to do, but with a VIPT cache this is only an optimization
- * so not to pay the price of establishing a second mapping if an existing
- * one can be used.  However, on platforms without hardware TLB maintenance
- * broadcast, we simply cannot use ARCH_NEEDS_KMAP_HIGH_GET at all since
- * the locking involved must also disable IRQs which is incompatible with
- * the IPI mechanism used by global TLB operations.
- */
-#define ARCH_NEEDS_KMAP_HIGH_GET
-#if defined(CONFIG_SMP) && defined(CONFIG_CPU_TLB_V6)
-#undef ARCH_NEEDS_KMAP_HIGH_GET
-#if defined(CONFIG_HIGHMEM) && defined(CONFIG_CPU_CACHE_VIVT)
-#error "The sum of features in your kernel config cannot be supported together"
-#endif
-#endif
-
-/*
- * Needed to be able to broadcast the TLB invalidation for kmap.
- */
-#ifdef CONFIG_ARM_ERRATA_798181
-#undef ARCH_NEEDS_KMAP_HIGH_GET
-#endif
-
-#ifdef ARCH_NEEDS_KMAP_HIGH_GET
-extern void *kmap_high_get(const struct page *page);
-
-static inline void *arch_kmap_local_high_get(const struct page *page)
-{
-	if (IS_ENABLED(CONFIG_DEBUG_HIGHMEM) && !cache_is_vivt())
-		return NULL;
-	return kmap_high_get(page);
-}
-#define arch_kmap_local_high_get arch_kmap_local_high_get
-
-#else /* ARCH_NEEDS_KMAP_HIGH_GET */
-static inline void *kmap_high_get(const struct page *page)
-{
-	return NULL;
-}
-#endif /* !ARCH_NEEDS_KMAP_HIGH_GET */
-
 #define arch_kmap_local_post_map(vaddr, pteval)				\
 	local_flush_tlb_kernel_page(vaddr)
 
-#define arch_kmap_local_pre_unmap(vaddr)				\
-do {									\
-	if (cache_is_vivt())						\
-		__cpuc_flush_dcache_area((void *)vaddr, PAGE_SIZE);	\
-} while (0)
+#define arch_kmap_local_pre_unmap(vaddr) do { } while (0)
 
 #define arch_kmap_local_post_unmap(vaddr)				\
 	local_flush_tlb_kernel_page(vaddr)
diff --git a/arch/arm/mm/cache-feroceon-l2.c b/arch/arm/mm/cache-feroceon-l2.c
index 2bfefb252ffd..1316b6ab295a 100644
--- a/arch/arm/mm/cache-feroceon-l2.c
+++ b/arch/arm/mm/cache-feroceon-l2.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/highmem.h>
 #include <linux/io.h>
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
@@ -38,30 +37,6 @@
  * between which we don't want to be preempted.
  */
 
-static inline unsigned long l2_get_va(unsigned long paddr)
-{
-#ifdef CONFIG_HIGHMEM
-	/*
-	 * Because range ops can't be done on physical addresses,
-	 * we simply install a virtual mapping for it only for the
-	 * TLB lookup to occur, hence no need to flush the untouched
-	 * memory mapping afterwards (note: a cache flush may happen
-	 * in some circumstances depending on the path taken in kunmap_atomic).
-	 */
-	void *vaddr = kmap_atomic_pfn(paddr >> PAGE_SHIFT);
-	return (unsigned long)vaddr + (paddr & ~PAGE_MASK);
-#else
-	return __phys_to_virt(paddr);
-#endif
-}
-
-static inline void l2_put_va(unsigned long vaddr)
-{
-#ifdef CONFIG_HIGHMEM
-	kunmap_atomic((void *)vaddr);
-#endif
-}
-
 static inline void l2_clean_pa(unsigned long addr)
 {
 	__asm__("mcr p15, 1, %0, c15, c9, 3" : : "r" (addr));
@@ -78,14 +53,13 @@ static inline void l2_clean_pa_range(unsigned long start, unsigned long end)
 	 */
 	BUG_ON((start ^ end) >> PAGE_SHIFT);
 
-	va_start = l2_get_va(start);
+	va_start = __phys_to_virt(start);
 	va_end = va_start + (end - start);
 	raw_local_irq_save(flags);
 	__asm__("mcr p15, 1, %0, c15, c9, 4\n\t"
 		"mcr p15, 1, %1, c15, c9, 5"
 		: : "r" (va_start), "r" (va_end));
 	raw_local_irq_restore(flags);
-	l2_put_va(va_start);
 }
 
 static inline void l2_clean_inv_pa(unsigned long addr)
@@ -109,14 +83,13 @@ static inline void l2_inv_pa_range(unsigned long start, unsigned long end)
 	 */
 	BUG_ON((start ^ end) >> PAGE_SHIFT);
 
-	va_start = l2_get_va(start);
+	va_start = __phys_to_virt(start);
 	va_end = va_start + (end - start);
 	raw_local_irq_save(flags);
 	__asm__("mcr p15, 1, %0, c15, c11, 4\n\t"
 		"mcr p15, 1, %1, c15, c11, 5"
 		: : "r" (va_start), "r" (va_end));
 	raw_local_irq_restore(flags);
-	l2_put_va(va_start);
 }
 
 static inline void l2_inv_all(void)
diff --git a/arch/arm/mm/cache-xsc3l2.c b/arch/arm/mm/cache-xsc3l2.c
index d20d7af02d10..477077387039 100644
--- a/arch/arm/mm/cache-xsc3l2.c
+++ b/arch/arm/mm/cache-xsc3l2.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2007 ARM Limited
  */
 #include <linux/init.h>
-#include <linux/highmem.h>
 #include <asm/cp15.h>
 #include <asm/cputype.h>
 #include <asm/cacheflush.h>
@@ -55,34 +54,6 @@ static inline void xsc3_l2_inv_all(void)
 	dsb();
 }
 
-static inline void l2_unmap_va(unsigned long va)
-{
-#ifdef CONFIG_HIGHMEM
-	if (va != -1)
-		kunmap_atomic((void *)va);
-#endif
-}
-
-static inline unsigned long l2_map_va(unsigned long pa, unsigned long prev_va)
-{
-#ifdef CONFIG_HIGHMEM
-	unsigned long va = prev_va & PAGE_MASK;
-	unsigned long pa_offset = pa << (32 - PAGE_SHIFT);
-	if (unlikely(pa_offset < (prev_va << (32 - PAGE_SHIFT)))) {
-		/*
-		 * Switching to a new page.  Because cache ops are
-		 * using virtual addresses only, we must put a mapping
-		 * in place for it.
-		 */
-		l2_unmap_va(prev_va);
-		va = (unsigned long)kmap_atomic_pfn(pa >> PAGE_SHIFT);
-	}
-	return va + (pa_offset >> (32 - PAGE_SHIFT));
-#else
-	return __phys_to_virt(pa);
-#endif
-}
-
 static void xsc3_l2_inv_range(unsigned long start, unsigned long end)
 {
 	unsigned long vaddr;
@@ -92,13 +63,11 @@ static void xsc3_l2_inv_range(unsigned long start, unsigned long end)
 		return;
 	}
 
-	vaddr = -1;  /* to force the first mapping */
-
 	/*
 	 * Clean and invalidate partial first cache line.
 	 */
 	if (start & (CACHE_LINE_SIZE - 1)) {
-		vaddr = l2_map_va(start & ~(CACHE_LINE_SIZE - 1), vaddr);
+		vaddr = __phys_to_virt(start & ~(CACHE_LINE_SIZE - 1));
 		xsc3_l2_clean_mva(vaddr);
 		xsc3_l2_inv_mva(vaddr);
 		start = (start | (CACHE_LINE_SIZE - 1)) + 1;
@@ -108,7 +77,7 @@ static void xsc3_l2_inv_range(unsigned long start, unsigned long end)
 	 * Invalidate all full cache lines between 'start' and 'end'.
 	 */
 	while (start < (end & ~(CACHE_LINE_SIZE - 1))) {
-		vaddr = l2_map_va(start, vaddr);
+		vaddr = __phys_to_virt(start);
 		xsc3_l2_inv_mva(vaddr);
 		start += CACHE_LINE_SIZE;
 	}
@@ -117,13 +86,11 @@ static void xsc3_l2_inv_range(unsigned long start, unsigned long end)
 	 * Clean and invalidate partial last cache line.
 	 */
 	if (start < end) {
-		vaddr = l2_map_va(start, vaddr);
+		vaddr = __phys_to_virt(start);
 		xsc3_l2_clean_mva(vaddr);
 		xsc3_l2_inv_mva(vaddr);
 	}
 
-	l2_unmap_va(vaddr);
-
 	dsb();
 }
 
@@ -135,13 +102,11 @@ static void xsc3_l2_clean_range(unsigned long start, unsigned long end)
 
 	start &= ~(CACHE_LINE_SIZE - 1);
 	while (start < end) {
-		vaddr = l2_map_va(start, vaddr);
+		vaddr = __phys_to_virt(start);
 		xsc3_l2_clean_mva(vaddr);
 		start += CACHE_LINE_SIZE;
 	}
 
-	l2_unmap_va(vaddr);
-
 	dsb();
 }
 
@@ -178,14 +143,12 @@ static void xsc3_l2_flush_range(unsigned long start, unsigned long end)
 
 	start &= ~(CACHE_LINE_SIZE - 1);
 	while (start < end) {
-		vaddr = l2_map_va(start, vaddr);
+		vaddr = __phys_to_virt(start);
 		xsc3_l2_clean_mva(vaddr);
 		xsc3_l2_inv_mva(vaddr);
 		start += CACHE_LINE_SIZE;
 	}
 
-	l2_unmap_va(vaddr);
-
 	dsb();
 }
 
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index a4c765d24692..696f6f1f259e 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -647,18 +647,10 @@ static void dma_cache_maint_page(phys_addr_t phys, size_t size,
 			if (len + offset > PAGE_SIZE)
 				len = PAGE_SIZE - offset;
 
-			if (cache_is_vipt_nonaliasing()) {
-				vaddr = kmap_atomic_pfn(pfn);
+			vaddr = kmap_atomic(phys_to_page(phys));
+			if (vaddr) {
 				op(vaddr + offset, len, dir);
 				kunmap_atomic(vaddr);
-			} else {
-				struct page *page = phys_to_page(phys);
-
-				vaddr = kmap_high_get(page);
-				if (vaddr) {
-					op(vaddr + offset, len, dir);
-					kunmap_high(page);
-				}
 			}
 		} else {
 			phys += offset;
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 19470d938b23..998b75f77364 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -208,21 +208,10 @@ void __flush_dcache_folio(struct address_space *mapping, struct folio *folio)
 					folio_size(folio));
 	} else {
 		unsigned long i;
-		if (cache_is_vipt_nonaliasing()) {
-			for (i = 0; i < folio_nr_pages(folio); i++) {
-				void *addr = kmap_local_folio(folio,
-								i * PAGE_SIZE);
-				__cpuc_flush_dcache_area(addr, PAGE_SIZE);
-				kunmap_local(addr);
-			}
-		} else {
-			for (i = 0; i < folio_nr_pages(folio); i++) {
-				void *addr = kmap_high_get(folio_page(folio, i));
-				if (addr) {
-					__cpuc_flush_dcache_area(addr, PAGE_SIZE);
-					kunmap_high(folio_page(folio, i));
-				}
-			}
+		for (i = 0; i < folio_nr_pages(folio); i++) {
+			void *addr = kmap_local_folio(folio, i * PAGE_SIZE);
+			__cpuc_flush_dcache_area(addr, PAGE_SIZE);
+			kunmap_local(addr);
 		}
 	}
 
-- 
2.39.5


