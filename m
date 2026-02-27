Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58AF0FEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9A16B00B5; Fri, 27 Feb 2026 12:57:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A5E6B00B7; Fri, 27 Feb 2026 12:57:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA39A6B00B8; Fri, 27 Feb 2026 12:57:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 946696B00B5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57B458C3C6
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:10 +0000 (UTC)
X-FDA: 84490993020.01.EFF0693
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB4F5C0012
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BihA0agDQ0LEMwYEojFzW2BKrJXLrUawDXqASyPickU=;
	b=WwdSIKfYUvHXyoISJbZ1JztfzS+V0x1ugOqd2tjW6ndIlTm1TlchBe0K6lvTfxwuOStSQu
	aKM1EIPHI+1DhMD6lmrva6aMk5q/2b/HR7d5RJRiWk6k8HQez8Zuz2qc2aL4mAnVzMjM2y
	j8nYA3rVcuELZ2Wjca3D1bmEwO3S/Gg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215029; a=rsa-sha256;
	cv=none;
	b=2+yUF72JbXKUJmMCe1/zoIZr7adaJA9a8T36nCZs4W55qVZWnHQq6XcxrZzYv8wpNp2Vfr
	o9Yi1g4xvqBdVZvoWh9rsq254SDjZ3Lzb9gXvFDWJIrsItbMTOs5oDeb26qjxdv1EB3uKf
	/Six7rfnj8ZvQA0TqZ+huMxf/VqkG7I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF7071516;
	Fri, 27 Feb 2026 09:57:01 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 970503F73B;
	Fri, 27 Feb 2026 09:57:03 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 18/30] mm: kpkeys: Introduce early page table allocator
Date: Fri, 27 Feb 2026 17:55:06 +0000
Message-ID: <20260227175518.3728055-19-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB4F5C0012
X-Stat-Signature: mygs8seexbfs4x7n4kukc5y4i5ukf438
X-HE-Tag: 1772215028-417104
X-HE-Meta: U2FsdGVkX1+RCYkiqAr2aE0mYrVzdxBn7AidIi8ZBkLgoySYRs+xoGaxmjrMZOBCfMAUBkY1bDB5XNZ3HtCwVI4ODAR7/eyqfcxLzfH8lEy+dg0nl5yJDUEvnUbdT+yCZb0GLvpcQP1iiRA1LTQ+Jvks/aEbYrSplH3a6tHfJSI/Ygi57pqDVH/a2uhJGoBaWQFs7RxCaJjTzfZ7o9xRvS2g7TznG5GoVjPpQJbZmZoH55yNi6OvrlBfObvZ53Ao1hFlb2pecWVUqX7ref+z1Oid5nSMW9g3xy7AaRnE7QhuNliMG0VygHWcYv+qorgdIYj6a00jdIRsfWHl5xhqmrzybtM2qzaMdkeOleThXQGf9zR12gexrZ7WDYALYrzbko3dRBfDl6wE5//st+Vhlny/4l7Wnjoi/NsSeosT8oZaUpmddUA8g7IdEF5dkOw0G1vCPG6TuHAgdCZ0VXw/cFtvIMaOhFZkQRKJ+tPf8JaZO5dwu1tddc8l+UE3pco2Mwtginpi13Xm1htJZExld1/jgANUW7VIrQI03wefGCvWR6CAV4vVn20aZTxwE6Ey79dNewv77GVh2/IAvobmOj+5I43ToH8kJcbbDCK2/2GRuGeyv8VoPRs0WmFCIwYAFiGUZT9xQfJyXfuVF0LfTFPncNdmAsMZiBcGLsBrz1htUNIcMl0Lh9KwzMb4l+Lwkmo02/SDrxIENXFVkidOgpVRcoy6zwO/dlKpisdyx8hJMqQxy7cYMiNkWeA8t6qFoHoZOwIl4HBq0WlVDj36sVldyO/05IpDiuNtnW0B1iKSnWcggSjsVcC/+cWcdcaT1/CIq+3vR/EEHF009goobufwQ2kmBNYFJSBpg3hF8XpBoayVtCOw5SG5PX8V6GCd
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
it is being created, which seems at best difficult. Instead, a simple
allocator is introduced, refilling a cache with memblock and keeping
track of all allocated ranges to set their pkey once it is safe to do
so. PTPs allocated at that stage are not freed, so there is no need
to manage a free list.

The refill size/alignment is the same as for the pkeys block allocator.
For systems that use large block mappings, the same rationale applies
(reducing fragmentation of the linear map). This is also used for other
systems, as this reduces the number of calls to memblock, without much
downside.

The number of PTPs required to create the linear map is proportional to
the amount of available memory, which means it may be large. At that
stage the memblock allocator may however only track a limited number of
regions, and we size our own tracking array (full_ranges) accordingly.
The array may be quite large as a result (16KB on arm64), but it is
discarded once boot has completed (__initdata).

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---

The full_ranges array will end up mostly empty on most systems, but
relying on INIT_MEMBLOCK_MEMORY_REGIONS seemed to be the only way to
guarantee that we can track all ranges regardless of the size and layout
of physical memory.

An alternative would be to rebuild the ranges by walking the kernel page
tables in init_late(), but that's arguably at least as complex
(requiring stop_machine()).

---
 include/linux/kpkeys.h        |   7 ++
 mm/kpkeys_hardened_pgtables.c | 165 ++++++++++++++++++++++++++++++++++
 2 files changed, 172 insertions(+)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index 8cfeb6e5af56..73b456ecec65 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -139,6 +139,8 @@ void kpkeys_hardened_pgtables_init(void);
  */
 void kpkeys_hardened_pgtables_init_late(void);
 
+phys_addr_t kpkeys_physmem_pgtable_alloc(void);
+
 #else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 static inline bool kpkeys_hardened_pgtables_enabled(void)
@@ -167,6 +169,11 @@ static inline void kpkeys_hardened_pgtables_init(void) {}
 
 static inline void kpkeys_hardened_pgtables_init_late(void) {}
 
+static inline phys_addr_t kpkeys_physmem_pgtable_alloc(void)
+{
+	return 0;
+}
+
 #endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 #endif /* _LINUX_KPKEYS_H */
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index dcc5e6da7c85..1b649812f474 100644
--- a/mm/kpkeys_hardened_pgtables.c
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -3,6 +3,7 @@
 #include <linux/list.h>
 #include <linux/highmem.h>
 #include <linux/kpkeys.h>
+#include <linux/memblock.h>
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
@@ -41,6 +42,9 @@ static bool pba_ready_for_direct_map_split(void);
 static void pba_init(void);
 static void pba_init_late(void);
 
+/* pkeys physmem allocator (PPA) - implemented below */
+static void ppa_finalize(void);
+
 /* Trivial allocator in case the linear map is PTE-mapped (no block mapping) */
 static struct page *noblock_pgtable_alloc(gfp_t gfp)
 {
@@ -113,8 +117,14 @@ void __init kpkeys_hardened_pgtables_init_late(void)
 	if (!arch_kpkeys_enabled())
 		return;
 
+	/*
+	 * Called first to avoid relying on pba_early_region for splitting
+	 * the linear map in the subsequent calls.
+	 */
 	if (pba_enabled())
 		pba_init_late();
+
+	ppa_finalize();
 }
 
 /*
@@ -751,3 +761,158 @@ static int __init pba_init_shrinker(void)
 	return 0;
 }
 late_initcall(pba_init_shrinker);
+
+/*
+ * pkeys physmem allocator (PPA): block-based allocator for very early page
+ * tables (especially for creating the linear map), based on memblock. Blocks
+ * are tracked so that their pkey can be set once it is safe to do so.
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
+/*
+ * We allocate ranges with the same size and alignment as the maximum refill
+ * size for the regular block allocator, with the same rationale (minimising
+ * spliting and optimising TLB usage).
+ */
+#define PHYSMEM_REFILL_SIZE	(PAGE_SIZE << refill_orders[0])
+
+struct physmem_range {
+	phys_addr_t addr;
+	phys_addr_t size;
+};
+
+struct pkeys_physmem_allocator {
+	struct physmem_range free_range;
+
+	struct physmem_range full_ranges[PHYSMEM_MAX_RANGES];
+	unsigned int nr_full_ranges;
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
+	pr_debug("%s: addr=%pa, size=%pa\n", __func__, &addr, &size);
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
+	if (!ppa->nr_full_ranges)
+		return false;
+
+	range = &ppa->full_ranges[ppa->nr_full_ranges - 1];
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
+static void __init ppa_register_full_range(phys_addr_t addr)
+{
+	struct pkeys_physmem_allocator *ppa = &pkeys_physmem_allocator;
+	struct physmem_range *range;
+
+	if (!addr)
+		return;
+
+	if (ppa_try_extend_last_range(addr, PHYSMEM_REFILL_SIZE))
+		return;
+
+	/* Could not extend the last range, create a new one */
+	if (WARN_ON(ppa->nr_full_ranges >= PHYSMEM_MAX_RANGES))
+		return;
+
+	range = &ppa->full_ranges[ppa->nr_full_ranges++];
+	range->addr = addr;
+	range->size = PHYSMEM_REFILL_SIZE;
+}
+
+static void __init ppa_refill(void)
+{
+	struct pkeys_physmem_allocator *ppa = &pkeys_physmem_allocator;
+	phys_addr_t size = PHYSMEM_REFILL_SIZE;
+	phys_addr_t addr;
+
+	/*
+	 * There should be plenty of contiguous physical memory available so
+	 * early during boot so there should be no need for fallback sizes.
+	 */
+	addr = memblock_phys_alloc_range(size, size, 0,
+					 MEMBLOCK_ALLOC_NOLEAKTRACE);
+	WARN_ON(!addr);
+
+	pr_debug("%s: addr=%pa\n", __func__, &addr);
+
+	ppa->free_range.addr = addr;
+	ppa->free_range.size = (addr ? size : 0);
+}
+
+static void __init ppa_finalize(void)
+{
+	struct pkeys_physmem_allocator *ppa = &pkeys_physmem_allocator;
+
+	if (ppa->free_range.addr) {
+		struct physmem_range *free_range = &ppa->free_range;
+
+		/* Protect the range that was allocated, and free the rest */
+		set_pkey_pgtable_phys(free_range->addr + free_range->size,
+				      PHYSMEM_REFILL_SIZE - free_range->size);
+
+		if (free_range->size)
+			memblock_free_late(free_range->addr, free_range->size);
+
+		free_range->addr = 0;
+		free_range->size = 0;
+	}
+
+	for (unsigned int i = 0; i < ppa->nr_full_ranges; i++) {
+		struct physmem_range *range = &ppa->full_ranges[i];
+
+		set_pkey_pgtable_phys(range->addr, range->size);
+	}
+}
+
+phys_addr_t __init kpkeys_physmem_pgtable_alloc(void)
+{
+	struct pkeys_physmem_allocator *ppa = &pkeys_physmem_allocator;
+
+	if (!ppa->free_range.size) {
+		ppa_register_full_range(ppa->free_range.addr);
+		ppa_refill();
+	}
+
+	if (!ppa->free_range.addr)
+		/* Refilling failed - allocate untracked memory */
+		return memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE, 0,
+						 MEMBLOCK_ALLOC_NOLEAKTRACE);
+
+	ppa->free_range.size -= PAGE_SIZE;
+	return ppa->free_range.addr + ppa->free_range.size;
+}
-- 
2.51.2


