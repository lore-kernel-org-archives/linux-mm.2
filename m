Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28709C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401466B07D3; Tue, 18 Aug 2026 10:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2986B07D5; Tue, 18 Aug 2026 10:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7E46B07D6; Tue, 18 Aug 2026 10:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 005906B07D3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E6B01C0B5F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:29 +0000 (UTC)
X-FDA: 85114580418.05.8DD1C47
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id A1C041C000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OtW0CLTC;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iTHskaaics2YOb7mV8HW+F0QqHNBq2e6dwMrWUoe7A=;
	b=mrHh9bqcI0cn9AIta4dRf5IytS182LWGpmskKX9OjcL+fDrr22ZcISBNG/mpVjJJV21+RI
	iVFhOwO+E09B6lNow9ztUu1kQ0U6vtZZFSSkpG66cbjQIyvFG5lbZ01Bmv1jLVwnVos4k2
	WCn9t0gx/DHSWpS7BhL+K8e8PyjPolw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OtW0CLTC;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062347;
	b=TK+iVAIDC/d1s6Lm9yb4+A0jLgQoSy/3AhakUCaN7tZn+js4FHtS56qMd2f4N51ogIUc9l
	RJXJZmUtlvRWaqJMtMS/koU8y+7IvaDGcfRIK1YL52NNlxT6x7ssWKMVIlMLTTLpIT94TX
	BBHGfWxL8LMNMoFry2T9+FGpS3yHG9s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5BE019F6;
	Tue, 18 Aug 2026 07:12:22 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2DB773F85F;
	Tue, 18 Aug 2026 07:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062346; bh=UOSa72V7kKY4U1NE8IVeRcWRuq2og9Q1IdwEs06tE+M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OtW0CLTC1Rl3v+mFIeIbmL9SP3PFT6q+Yzw0Yul71S3Dg9s8AEUxGtiWdWJ75Zc7m
	 GjLsxq8urpItPmMec24ABJaiZG/s+rA544vQe6QXzhiDqgDc0FvQx/LjxCz812YO8L
	 7WsIjwCUnEUfPJWmjSH8G4j2HVHqbjFjEBkGOrLk=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:55 +0100
Subject: [PATCH RFC v9 13/25] mm: kpkeys: Introduce early page table
 allocator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-13-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=6609;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=UOSa72V7kKY4U1NE8IVeRcWRuq2og9Q1IdwEs06tE+M=;
 b=jAm+phCdu4Mt53rUVdHDwcVsszaCBzeso2mFftAdJqvKcJ846KaIFHot07GHWpB22/RqDatQT
 kZAYTLS4BwoCWBG0h6rw8zKfTuLp752UziJbRJHktjH/gTeyNNMzMpY
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1C041C000C
X-Stat-Signature: jewmj7x9o4zurbhzjp4wicz77iosgmbw
X-Rspam-User: 
X-HE-Tag: 1787062347-46222
X-HE-Meta: U2FsdGVkX18AxgxYLprzRFcZjM/HZC0LHAPZf5MOljcjGa2m47qW5HgbeW7h9W2hVJrJ9MUPlR73WSnKpyGG3/r9+hYzSWaxyaTQRgyIFl+nyUh2MYaGgnb9mwhfRQF6/OcSrVTd7K9MSSsEJu5pxl0gFwIhHsk+1CxZ2Bda6mjPly1hlO4klPZlV8F/5qOuS+b/QCSvg0Kdsi8ZH3OEidlGUX4I6EZK1Hn8aPRqEYAS5RWE1qAhXpXwEI60Xb5+U3G9rtGB2KwybuvnRALPzrY8H7jEIaN+j8sW51u6gJXMrkcSyBuZLsJi0fufSrIZewNcJCPPohjyW2+RdyL3oyqNE72oxc75udPE5aTjatIqxG0jo3sIQ/t6DibdjTB4q9+CIDAZcH1e/TnueY81W6e7b6QJ5tYZ0trpdcIdHoIuo6ZUocAz9DFr+DLNT6lhKZcXFhUOmvVmbcW1WQTK9+FGs7+DIyISJE55c7dR7LQsTpfVL5VfpC2Rk8DNUT5Wj5qHQigzdaT5kY0KAbM1/YX5Hq1Iz/tLoj6JY8nYpH6UtYYEMTW4mepld5RSRBaQqU/umakqmPWnDB3sUC2fQPoVQgTYi7MqwAuuJK0XkUG/7aaK98AZ2pnu7/UI2yB7OlNxqDTB9ZlalAspIOFv5o6Ew7lTcNaD2SmVoN1Y6YX39OGVo91oLEgEPOwtt9BaM65RSP3t2D7+ZAfhkkpsZaaELQ0rsQ2CtT1+5AOMDho8HRQZIhbWr3chbu5qhmPsXNTXY8pE3UVON8V7yhCDEHSinOQDUUkFEgw9SQqccurlF+XFBel75efnAwMegZkgat6gNoM2CJHj36e/RBVCzvRusBVKrtIv8bjI+akhzlElekdhirh9nY/zzXTToa/4aJCniCHf1O87CgDG60Uvda74s/4wLYHVZXLy8220Ltumhmqr3DbpIZ9rsX5unaiiWdeAi+oDq42cv4z1Wdt
 z4wYZmsv
 QM0R/hufbev8OXTmzgv3jwqd2BukCDm6JdHrtHiB7cSkiJYO/M0giIbVrzLt2xDlzRNtcyyrJKG3zO1TLksaNUx+w+kWPY6MawxH4TBaWviAfdeCDF3GMzqvceto3/Wv+J0Z8NSFenAsOXM63wtteipdelL786B0w+pCZ0gMlrDxZ3UF9THfxFVey1ifVPMdUVxgKur9aaFqXs5/y0XBcx1x4pB4yJFEhR0nbmE5jjQraHv1EWk1zymUOJmIBsFRSPBpHAudshLexP/xObkjVIswMiFJ4FrRCzSBienOF4rN1KaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_pgtables feature aims to protect all page table
pages (PTPs) by mapping them with a privileged pkey. This is primarily
handled by kpkeys_pgtable_alloc(), called from pagetable_alloc().
However, this does not cover PTPs allocated early, before the
buddy allocator is available. These PTPs are allocated by architecture
code, either 1. from static pools or 2. using the memblock allocator,
and should also be protected.

This patch addresses the second category: PTPs allocated via memblock.
Such PTPs are notably used to create the linear map. Protecting them as
soon as they are allocated would require modifying the linear map while
it is being created, which seems at best difficult. Instead, a
simple allocator is introduced, obtaining pages from memblock and
keeping track of all allocated ranges to set their pkey once it is
safe to do so. PTPs allocated at that stage are not freed, so there
is no need to manage a free list.

Since kpkeys_hardened_pgtables currently requires the linear map to
be PTE-mapped, we can directly allocate page by page using memblock,
without intermediate cache. We rely on memblock allocating
contiguous pages to minimise the number of tracked ranges.

The number of PTPs required to create the linear map is proportional to
the amount of available memory, which means it may be large. At such
an early point, the memblock allocator may however only track a
limited number of regions, and we size the tracking array
(allocated_ranges) accordingly. The array may be quite large as a
result (16KB on arm64), but it is discarded once boot has completed.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/kpkeys.h        |   7 +++
 mm/kpkeys_hardened_pgtables.c | 115 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index 288c8853eed6..23526d3f9ab3 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -125,6 +125,8 @@ void kpkeys_pgtable_free(struct page *page, unsigned int order);
  */
 void kpkeys_hardened_pgtables_init(void);
 
+phys_addr_t kpkeys_physmem_pgtable_alloc(void);
+
 #else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 static inline bool kpkeys_hardened_pgtables_enabled(void)
@@ -146,6 +148,11 @@ static inline void kpkeys_pgtable_free(struct page *page, unsigned int order) {}
 
 static inline void kpkeys_hardened_pgtables_init(void) {}
 
+static inline phys_addr_t kpkeys_physmem_pgtable_alloc(void)
+{
+	return 0;
+}
+
 #endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 #endif /* _LINUX_KPKEYS_H */
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index eca798207107..9e1e27c2cc96 100644
--- a/mm/kpkeys_hardened_pgtables.c
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kpkeys.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/set_memory.h>
 
@@ -30,6 +31,9 @@ static int set_pkey_default(struct page *page, unsigned int nr_pages)
 	return ret;
 }
 
+/* pkeys physmem allocator (PPA) - implemented below */
+static void ppa_finalize(void);
+
 struct page *kpkeys_pgtable_alloc(gfp_t gfp, unsigned int order)
 {
 	struct page *page;
@@ -60,4 +64,115 @@ void __init kpkeys_hardened_pgtables_init(void)
 		return;
 
 	static_branch_enable(&kpkeys_hardened_pgtables_key);
+
+	ppa_finalize();
+}
+
+/*
+ * pkeys physmem allocator (PPA): allocator for very early page tables
+ * (especially for creating the linear map), based on memblock. Allocated
+ * ranges are tracked so that their pkey can be set once it is safe to do so.
+ */
+
+/*
+ * We may have to track many ranges when allocating page tables for the linear
+ * map, as their number grows with the amount of available memory. Assuming that
+ * memblock returns contiguous blocks whenever possible, the number of ranges
+ * to track cannot however exceed the number of regions that memblock itself
+ * tracks. memblock_allow_resize() hasn't been called yet at that point, so
+ * that limit is the size of the statically allocated array.
+ */
+#define PHYSMEM_MAX_RANGES	INIT_MEMBLOCK_MEMORY_REGIONS
+
+struct physmem_range {
+	phys_addr_t addr;
+	phys_addr_t size;
+};
+
+struct pkeys_physmem_allocator {
+	struct physmem_range allocated_ranges[PHYSMEM_MAX_RANGES];
+	unsigned int nr_allocated_ranges;
+};
+
+static struct pkeys_physmem_allocator pkeys_physmem_allocator __initdata;
+
+static int __init set_pkey_pgtable_phys(phys_addr_t pa, phys_addr_t size)
+{
+	unsigned long addr = (unsigned long)__va(pa);
+	int ret;
+
+	ret = set_memory_pkey(addr, size / PAGE_SIZE, KPKEYS_PKEY_PGTABLES);
+
+	WARN_ON(ret);
+	return ret;
+}
+
+static bool __init ppa_try_extend_last_range(phys_addr_t addr, phys_addr_t size)
+{
+	struct pkeys_physmem_allocator *ppa = &pkeys_physmem_allocator;
+	struct physmem_range *range;
+
+	if (!ppa->nr_allocated_ranges)
+		return false;
+
+	range = &ppa->allocated_ranges[ppa->nr_allocated_ranges - 1];
+
+	/* Merge the new range into the last range if they are contiguous */
+	if (addr == range->addr + range->size) {
+		range->size += size;
+		return true;
+	} else if (addr + size == range->addr) {
+		range->addr -= size;
+		range->size += size;
+		return true;
+	}
+
+	return false;
+}
+
+static void __init ppa_register_allocated_range(phys_addr_t addr,
+						phys_addr_t size)
+{
+	struct pkeys_physmem_allocator *ppa = &pkeys_physmem_allocator;
+	struct physmem_range *range;
+
+	if (!addr)
+		return;
+
+	if (ppa_try_extend_last_range(addr, size))
+		return;
+
+	/* Could not extend the last range, create a new one */
+	if (WARN_ON(ppa->nr_allocated_ranges >= PHYSMEM_MAX_RANGES))
+		return;
+
+	range = &ppa->allocated_ranges[ppa->nr_allocated_ranges++];
+	range->addr = addr;
+	range->size = size;
+}
+
+static void __init ppa_finalize(void)
+{
+	struct pkeys_physmem_allocator *ppa = &pkeys_physmem_allocator;
+
+	for (unsigned int i = 0; i < ppa->nr_allocated_ranges; i++) {
+		struct physmem_range *range = &ppa->allocated_ranges[i];
+
+		set_pkey_pgtable_phys(range->addr, range->size);
+	}
+}
+
+phys_addr_t __ref kpkeys_physmem_pgtable_alloc(void)
+{
+	size_t size = PAGE_SIZE;
+	phys_addr_t addr;
+
+	addr = memblock_phys_alloc_range(size, size, 0,
+					 MEMBLOCK_ALLOC_NOLEAKTRACE);
+	if (!addr)
+		return addr;
+
+	ppa_register_allocated_range(addr, size);
+
+	return addr;
 }

-- 
2.51.2


