Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DE9C98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 05:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093806B0088; Sun, 27 Sep 2026 01:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044BE6B008A; Sun, 27 Sep 2026 01:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E752D6B008C; Sun, 27 Sep 2026 01:51:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B87C56B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 01:51:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3059C1C39CB
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 05:51:10 +0000 (UTC)
X-FDA: 85258469100.12.D289019
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4B30740004
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 05:51:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zJtyTOLx;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790488268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UHrAQJDjpZkXol5VEY6/BSqUifaqAPBbX8o+2SqFxC4=;
	b=VZRV/pdZlyf/iK1ACKA7wnHZUkCWF2JP3Lp4VhzUi8H+gvPwcloyM/o1sMcTNbPmgVA3/x
	Y7SU1HDhqJhx8ukfBYDTEV2AvLriPu7okPHH68U2TGeS86dv9Y9QW6mQD00LNyaOpQ6tPC
	8BTsVNzLreWy6ablN0acq88ccmmNAKY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zJtyTOLx;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790488268;
	b=7erMRncgy3l5l2tfgsfUy9Tr2G01/aNdalMXHg5yKpO/aiTyYSlVNA2hPMSbTj40UikHVv
	NUaXpUYUDgaEY7TMdnfiri92nERMoNz3IzfJ8kBuv2jNJAf7gLIJ2WmIocNQTRvUQy2EbZ
	77Uln9l5AYrvO8T4j1Fa5yoNTO1qdUI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98A77414C9;
	Sun, 27 Sep 2026 05:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AE51F000FF;
	Sun, 27 Sep 2026 05:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790488266;
	bh=UHrAQJDjpZkXol5VEY6/BSqUifaqAPBbX8o+2SqFxC4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zJtyTOLx9AzZW4ceULP1f5wpwRT2S4P6gkxVsut8kjkqSTxNh5x6hLRAGKDAfxlbL
	 DIR4BCawrmMPx/OsYsTVZ+OhvOXxWeI5Rji1wbVfkcaxxSh1vASsLh9BiwnfIegVs+
	 MySOGQKlazDuj2QhwomrLRpDzb1lF597f+vI6jUw=
Date: Sat, 26 Sep 2026 22:51:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org, Muchun Song
 <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Randy Dunlap
 <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v5 00/12] mm: Switch device DAX to section-based vmemmap
 optimization
Message-Id: <20260926225105.a56f29d76b2f496c8dc2dac0@linux-foundation.org>
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4c54yihf7hhsyiucdciwu1kem5ci5pb8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B30740004
X-HE-Tag: 1790488268-62389
X-HE-Meta: U2FsdGVkX1+XiTW387QoU0vRyaMnggTFcMiBFCNeKMZUyb6ya7F5AUhPzIA9DFj5AHY7O6jEhayywHpfPDyxIPpcCj6iE7urG+uVMrJyU5978BF+dYYInHsmloUlg5Zz+uAw6njLc92VrAa4GtRMcuOl0NIT1yiIANlCF5lrzgQB4v0TOwwlKWT6iubVEDg2fCps4T1vCbHNY9T/PdOJ3yo3b3Bifd5g4aPihrMlTDtw03YTyl5AvWpG3N7YWlpAlS9Eo2IA1m5fS52zsmOTvpg9w6PaAiZcjfemxbUkokC581dLZMOMJrcINyCWDlBzK+ywzreqPSdbd+bEC5id4oTl+itrZ9JJrXfvZJSGmTCjsD9BdFY+oTcJlmll4Zf9FPpCGF6uXiQ2APd3izrrD44BvCjCTN+lLChWphlTF580WcvQ75xfz8zkBt2EqXy6v6erAUirK7Uw0qWUZvkQqthnTx7gmR/N5w5GQv0tm/D0QkP4hSJBNMHfDBX+tkOHH6xGfopcF7VzwjRLLmA6I2jcWYNWfJWMhbf25B2uwGW7qXAJmOiWyaCayXUDBRtvZquhbUQdYP81zW1n9bubfhBV7+ulHJCMtvCqUDvWTh/oPz30/pltRrV/tZQcE0mqYdjc/rpQaekuuQCxpD9dfedHxBp1BCuvVqtiMJIO9+8YyZG1GOEZjrNSxVRHM9SUXNaG4BsvNIni7wnSNRtZn5MeqiOgj0gAMPmLyesxgz6d982b6aRffNuook8NdzvmfXZvEYmPWSMSY2K3gqUHOxc4t/E5sCWeXXo+Ad/VfR91tCPDlBRUzv564UQ/Bi9UBdfng8AaMmGFMYe3OEhDP2NNmrFfYbP9yL5jCMJbegvp+0SB2sRWQcYP1lpGKOE4BDX7bYk80tN6dl2dA1dCyTzD/X+WSmEIiLxRLowpNqWIUNPfdHpms2s95sF7WKz40vpk+Hw77i9+NBCTtAW
 X8616f2O
 ITXG4hMvsXkOOgBXtiodhXMVruxold9BGj1fEIxGVVAVNEuJk85S67oeY9TmuRNSUovJBp/t/60BONOJvD0nda+fU72QXncJx/eWQPobwIz25TSp1jpiRIEenFVCg7hsv8aiW1XrcL0iXxi57JyUlkMPEYinamRAiOq3A5/bYGKL+MEkUEf6CtWTAxtdtvwGTbXWC2QaTSbMsSfOAijRU/2im9zrWTwjxXu1hlh+6LUivfEb5BgbvHNaGtz2q2kwAgmNlmsJOb4r4I89RcfWQaQo1KsCNnJmBT25UpH1KP17HVX4K4KMaIs1+3FD/rA8Jgiuv4OXswn5ZA4/aMRxjOYUKKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026 10:54:29 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> After the HugeTLB conversion, optimized vmemmap state is described by
> the memory section and the sparse-vmemmap population path can allocate or
> reuse shared tail vmemmap pages based on that metadata. Device DAX still
> uses the older DAX-specific population model, including a separate tail
> vmemmap page reservation and architecture-specific logic to locate or
> populate reusable tail pages.
> 
> This series makes device DAX use the same section-based model. Device DAX
> records the compound page order from pgmap->vmemmap_shift in section
> metadata before vmemmap population, uses the common per-zone shared tail
> vmemmap page, and drops the extra reserved tail page. The powerpc radix
> path is updated to use the same shared tail-page helper, so the generic
> and powerpc DAX paths follow the same reservation model.

Thanks, I've updated mm-unstable to this version.

Sashiko asked a thing:
	https://sashiko.dev/#/patchset/20260927025441.741633-1-songmuchun@bytedance.com

> v5:
> - Move the shared tail-page factoring before introducing
>   CONFIG_VMEMMAP_OPTIMIZATION
> - Add a new patch to allocate the per-zone shared tail-page array
>   dynamically and fix the RISC-V build failure reported by the kernel
>   test robot
> - Select VMEMMAP_OPTIMIZATION from ZONE_DEVICE instead of DEV_DAX so
>   MSHV_VTL cannot set vmemmap_shift while leaving the optimization
>   disabled (reported by Sashiko)
> - Move the vmemmap optimization macros and MAX_FOLIO_VMEMMAP_ALIGN from
>   mmzone.h to vmemmap-optimization.h

Here's how v5 altered mm.git:


 arch/loongarch/include/asm/pgtable.h |    1 
 arch/riscv/mm/init.c                 |    1 
 include/linux/mm.h                   |    1 
 include/linux/mmzone.h               |   27 +----------------
 include/linux/vmemmap-optimization.h |   29 ++++++++++++++++--
 mm/hugetlb_vmemmap.c                 |    1 
 mm/sparse-vmemmap.c                  |   39 +++++++++++++++++++++----
 7 files changed, 64 insertions(+), 35 deletions(-)

--- a/arch/loongarch/include/asm/pgtable.h~b
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -72,6 +72,7 @@
 
 #include <linux/mm_types.h>
 #include <linux/mmzone.h>
+#include <linux/vmemmap-optimization.h>
 #include <asm/fixmap.h>
 #include <asm/sparsemem.h>
 
--- a/arch/riscv/mm/init.c~b
+++ a/arch/riscv/mm/init.c
@@ -22,6 +22,7 @@
 #include <linux/hugetlb.h>
 #include <linux/kfence.h>
 #include <linux/execmem.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/alternative.h>
 #include <asm/fixmap.h>
--- a/include/linux/mm.h~b
+++ a/include/linux/mm.h
@@ -38,6 +38,7 @@
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kcsan-checks.h>
+#include <linux/vmemmap-optimization.h>
 
 struct mempolicy;
 struct anon_vma;
--- a/include/linux/mmzone.h~b
+++ a/include/linux/mmzone.h
@@ -96,29 +96,6 @@
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
 
-/*
- * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
- * be naturally aligned with regard to the folio size.
- *
- * HVO which is only active if the size of struct page is a power of 2.
- */
-#define MAX_FOLIO_VMEMMAP_ALIGN					\
-	(IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&		\
-	 is_power_of_2(sizeof(struct page)) ?			\
-	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
-
-/* The number of retained vmemmap pages with HVO enabled. */
-#define VMEMMAP_OPTIMIZATION_PAGES		1
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
-	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
-#define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
-
-#define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
-	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
-#define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
-	((__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 &&	\
-	  IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION)) ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
-
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
@@ -1156,8 +1133,8 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
+	struct page **vmemmap_tails;
 #endif
 } ____cacheline_internodealigned_in_smp;
 
--- a/include/linux/vmemmap-optimization.h~b
+++ a/include/linux/vmemmap-optimization.h
@@ -14,6 +14,23 @@
 #include <linux/mmdebug.h>
 #include <linux/mmzone.h>
 
+/*
+ * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
+ * be naturally aligned with regard to the folio size.
+ *
+ * HVO which is only active if the size of struct page is a power of 2.
+ */
+#define MAX_FOLIO_VMEMMAP_ALIGN					\
+	(IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&		\
+	 is_power_of_2(sizeof(struct page)) ?			\
+	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
+
+/* The number of retained vmemmap pages with HVO enabled. */
+#define VMEMMAP_OPTIMIZATION_PAGES		1
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
+	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
+
 #ifdef CONFIG_VMEMMAP_OPTIMIZATION
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
@@ -44,6 +61,8 @@ static inline unsigned int pfn_to_sectio
 {
 	return section_compound_order(__pfn_to_section(pfn));
 }
+
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 #else
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
@@ -64,6 +83,12 @@ static inline unsigned int pfn_to_sectio
 {
 	return 0;
 }
+
+static inline struct page *vmemmap_shared_tail_page(unsigned int order,
+						    struct zone *zone)
+{
+	return NULL;
+}
 #endif /* CONFIG_VMEMMAP_OPTIMIZATION */
 
 static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
@@ -87,8 +112,4 @@ static inline bool vmemmap_optimizable_o
 
 	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
 }
-
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
-#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 #endif /* _LINUX_VMEMMAP_OPTIMIZATION_H */
--- a/mm/hugetlb_vmemmap.c~b
+++ a/mm/hugetlb_vmemmap.c
@@ -19,7 +19,6 @@
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
-#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
--- a/mm/sparse-vmemmap.c~b
+++ a/mm/sparse-vmemmap.c
@@ -167,16 +167,44 @@ static void * __meminit vmemmap_alloc_bl
 	return p;
 }
 
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
+#define VMEMMAP_OPTIMIZATION_NR_ORDERS	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
+
+static __ref struct page **vmemmap_tails_alloc(struct zone *zone)
+{
+	struct page **pages;
+	const size_t size = array_size(VMEMMAP_OPTIMIZATION_NR_ORDERS, sizeof(*pages));
+
+	pages = slab_is_available() ? kzalloc_objs(*pages, VMEMMAP_OPTIMIZATION_NR_ORDERS) :
+		memblock_alloc(size, __alignof__(*pages));
+	if (!pages)
+		return NULL;
+
+	if (cmpxchg(&zone->vmemmap_tails, NULL, pages) != NULL) {
+		if (slab_is_available())
+			kfree(pages);
+		else
+			memblock_free(pages, size);
+		pages = READ_ONCE(zone->vmemmap_tails);
+	}
+
+	return pages;
+}
+
 struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
 	void *addr;
-	struct page *page;
+	struct page *page, **pages;
 	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 
-	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(zone->vmemmap_tails)))
+	if (WARN_ON_ONCE(idx >= VMEMMAP_OPTIMIZATION_NR_ORDERS))
+		return NULL;
+
+	pages = READ_ONCE(zone->vmemmap_tails) ? : vmemmap_tails_alloc(zone);
+	if (!pages)
 		return NULL;
 
-	page = READ_ONCE(zone->vmemmap_tails[idx]);
+	page = READ_ONCE(pages[idx]);
 	if (likely(page))
 		return page;
 
@@ -196,16 +224,17 @@ struct page __ref *vmemmap_shared_tail_p
 	}
 
 	page = virt_to_page(addr);
-	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, page) != NULL) {
+	if (cmpxchg(&pages[idx], NULL, page) != NULL) {
 		if (slab_is_available())
 			__free_page(page);
 		else
 			memblock_free(addr, PAGE_SIZE);
-		page = READ_ONCE(zone->vmemmap_tails[idx]);
+		page = READ_ONCE(pages[idx]);
 	}
 
 	return page;
 }
+#endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 		struct vmem_altmap *altmap, unsigned long flags)
_


