Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16380C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAAD86B0092; Thu,  9 Jul 2026 02:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81976B0093; Thu,  9 Jul 2026 02:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D993B6B0096; Thu,  9 Jul 2026 02:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B365F6B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:42:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3577BC24C5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:42:06 +0000 (UTC)
X-FDA: 84968293452.05.F6CBE07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8A1DE40006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:42:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkwvmExl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783579324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZukdAvgyjL2pEBbFjKm+NCPL41pWAsvWi2bpAddRbQU=;
	b=3ZkH5Eoq93zmz9Yv2Re/R3b8q6jfaZII6FcC0OM7ZP27lGE1WF6nmPIGDzrVT7YuIO9SwE
	hiH+HQwmObIM6XQAExDxjMmjTsVxHQS3elAiimjidfgQ/RkUtYtrAFOCT8To4B1Mg3uJVV
	B+3VWOgls7LwsfbhzRwmqB1kPGKghRw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkwvmExl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783579324;
	b=zBtBs8G8iaKQY5s5Bs1m4ilR7pJGktKQRQtfqiTjcDLFO5/da3A2OX68VHmkl1U45Dm+Lw
	6Wi0LFtU0ZF28s0fhnVi5Tnn8xzhfhfv2PM8rzTuOzSMhZGpg46HWIQ8ST+/i2mgxJzbcP
	YvbRYwsrMvCVDQ3IH4Kc54mRbZ3/LqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB3E06136D;
	Thu,  9 Jul 2026 06:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750251F00A3A;
	Thu,  9 Jul 2026 06:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783579323;
	bh=ZukdAvgyjL2pEBbFjKm+NCPL41pWAsvWi2bpAddRbQU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jkwvmExlCIlmwqHDfQdTssMYJYs7eJXhx2vjUGvheLVqZ0M6tTD3wHbmmHPoPV3yg
	 wn2ypxn41TSRsAxJMR7ELS7mgjc5WeW1fIkZ+ZXcgnCB2JiJDWjoSz+82OCHWJsbE6
	 OOykKKUOWQTNNxzSx9bS5dDGskplbpEoimYPRock03snIyE8g2pjlynT8i+QgU0gwk
	 WgOsrla/9cs/iIFVbMrLpA1A61NOEp6IFDyohumZ77Ayxsh+DY4VBNDCeMIuOh6fCC
	 Vrefwma9eH8/dPljfLLXnkjGgJKtD7R2LbUS20JMKbEtgolHeapFoSJrvAqg+8nVuQ
	 GYdE1ouaz7AOg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 09 Jul 2026 09:41:47 +0300
Subject: [PATCH 1/3] mm: split out mm_init and memblock declarations from
 internal.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-internal-h-v1-1-956d5092782d@kernel.org>
References: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
In-Reply-To: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Alexander Potapenko <glider@google.com>, 
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, 
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, kasan-dev@googlegroups.com, 
 kexec@lists.infradead.org, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16-dev
X-Stat-Signature: dfc14zdx9tr7cju5homstk167b4g96xo
X-Rspamd-Queue-Id: 8A1DE40006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783579324-461568
X-HE-Meta: U2FsdGVkX18jkp2afBhDr++uVdknoGwk50XNPc3DrGx/4VR533vxDlLL2wRB+bqONJL1JTSbN3eka+ZUtROKqvPsAW1oDBMwIYfTNBvyKUCZQksKNH/uvcpYBhKo4G7561qpzriyF2HcHQ136m+7ANufOrTHMnmB6+jhUHx2iXBnMEjXYUQlfxKRm95V/8vbuV3v/inPM5UBbZvBnmqEwUpjhgqViPqHbAnmK43qIY9+gSMCXC9DEu27CHfhYqbaUlgKDsroTwFMFZqLrCQHfSEmEsx4+cDXhWACyuLuL4qyL0hkl3mBv5OHaxE80sJW3PSEVpx+HPRlRlAyv0dsu23CaDeENNyQg9c9KIhcr3Hg3iqsvxcGyzTEL4cfV8oanyYB8EJABK0KRE9o5urc9tVzW4Q3+kt9ANaJznaF3bg64qakTl9KtPlNVv+xJVmudlao7+aU+DJemme/wAdTr+9nVP5NchCXaHhWlWAMN7taOPAvoRcJDe08WebBMF7hyatdzJ4xsV8hB8tgBArwDh35rXVGYo33UTtjk8aqgp8CsY1PHJ90CRuuGmZ/nJ2NYU6M+n6/JaoocK9jTaMkT+uAqz4xZfIUrnj3UKYkthK2OQHHwZdgI2b7CrRdzwy4da+UooX6W0KOcf9yd5vI6nRRLitguBAWRWVY/3sygIsEC7PCTwgzoA2HeeSVQA6gPrbLuUrW8khWw/nQkANP2+d5j7Y/o8yGzKEwUgzl/17iFoUGiODN3qkGEJCbUjJWufoa/7/8m1H6c8FO/45am6dx6GmF+Kgau0gqRJ34fmrz1+/u7EV3przkW4OkvUOjIr5ighG2FVsnN8OsG1jGkpzYtCyezW39/myBwBHZs7X0YEpMfzIQejEHXbWtr9rV2N599fs2eH3+PFFUNxZzeStNruYNise0p4Cl5KS2zJ71VZBogr4ynhg+xR2Lu0GWtHvTv5RNAF29NnJ6nLO
 Lijjrf1D
 inyHoNhCQmBB6SWMmTnCYSmrMcgNagFOWyiCaqp+mQWPbMSmkTkpZtpjwLUwIBOh6nGC1sfdre50Mq3tzf0G4l4cMHnursxnC/2S/bFDVSOcPvP/UfGF4nHFM/GxFaU155M+chyHpu0tMO0wpkAYuKJktoERplhT46Z7umwMl0Y1hqpq/7q6ygerN+JQpN2VjEmilW3p/hcWIKsbndTEmXvHAuY8hBWXGzbs2//e3z3P9FrV5d9LFpukSRFLfi56X61kTYVYfOjtnsBtk9x7VQLtPftVc6WycR85n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/internal.h becomes more and more bloated.

Move declarations for related to mm/mm_init.c and mm/memblock.c to a new
mm/mm_init.h header.

No functional changes.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 MAINTAINERS                        |   1 +
 kernel/liveupdate/kexec_handover.c |   1 +
 mm/cma.c                           |   1 +
 mm/hugetlb.c                       |   1 +
 mm/internal.h                      |  91 ----------------------------
 mm/memblock.c                      |   1 +
 mm/memory_hotplug.c                |   1 +
 mm/mm_init.c                       |   1 +
 mm/mm_init.h                       | 120 +++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c                    |   1 +
 mm/sparse-vmemmap.c                |   1 +
 11 files changed, 129 insertions(+), 91 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 661ac43204d2..537dbfd01362 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16882,6 +16882,7 @@ F:	mm/bootmem_info.c
 F:	mm/memblock.c
 F:	mm/memtest.c
 F:	mm/mm_init.c
+F:	mm/mm_init.h
 F:	mm/rodata_test.c
 F:	tools/testing/memblock/
 
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4834a809985a..fe11cbf1006e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -35,6 +35,7 @@
  * internal APIs.
  */
 #include "../../mm/internal.h"
+#include "../../mm/mm_init.h"
 #include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
diff --git a/mm/cma.c b/mm/cma.c
index 31073738f2ac..a7929c758df1 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -33,6 +33,7 @@
 
 #include "internal.h"
 #include "cma.h"
+#include "mm_init.h"
 
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned int cma_area_count;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c211da6f0911..83d32d59aeab 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -51,6 +51,7 @@
 #include "hugetlb_vmemmap.h"
 #include "hugetlb_cma.h"
 #include "hugetlb_internal.h"
+#include "mm_init.h"
 #include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
diff --git a/mm/internal.h b/mm/internal.h
index 5c94d1bd7b93..c514b17c61b8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -716,9 +716,6 @@ void set_recommended_min_free_kbytes(void);
 
 extern char * const zone_names[MAX_NR_ZONES];
 
-/* perform sanity checks on struct pages being allocated or freed */
-DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
-
 extern int min_free_kbytes;
 extern int defrag_mode;
 
@@ -726,19 +723,9 @@ void setup_per_zone_wmarks(void);
 void calculate_min_free_kbytes(void);
 int __meminit init_per_zone_wmark_min(void);
 
-void set_zone_contiguous(struct zone *zone);
-bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
-			   unsigned long nr_pages);
-
-static inline void clear_zone_contiguous(struct zone *zone)
-{
-	zone->contiguous = false;
-}
-
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
-extern void memblock_free_pages(unsigned long pfn, unsigned int order);
 
 /*
  * This will have no effect, other than possibly generating a warning, if the
@@ -820,14 +807,6 @@ static inline void init_compound_tail(struct page *tail,
 	prep_compound_tail(tail, head, order);
 }
 
-extern void *memmap_alloc(phys_addr_t size, phys_addr_t align,
-			  phys_addr_t min_addr,
-			  int nid, bool exact_nid);
-
-void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
-		unsigned long, enum meminit_context, struct vmem_altmap *, int,
-		bool);
-
 /*
  * mm/sparse.c
  */
@@ -948,9 +927,6 @@ int
 isolate_migratepages_range(struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
 
-/* Free whole pageblock and set its migration type to MIGRATE_CMA. */
-void init_cma_reserved_pageblock(struct page *page);
-
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 
 struct cma;
@@ -958,7 +934,6 @@ struct cma;
 #ifdef CONFIG_CMA
 bool cma_validate_zones(struct cma *cma);
 void *cma_reserve_early(struct cma *cma, unsigned long size);
-void init_cma_pageblock(struct page *page);
 #else
 static inline bool cma_validate_zones(struct cma *cma)
 {
@@ -968,9 +943,6 @@ static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
 {
 	return NULL;
 }
-static inline void init_cma_pageblock(struct page *page)
-{
-}
 #endif
 
 /* mm/util.c */
@@ -1177,63 +1149,6 @@ static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
 }
 #endif /* !CONFIG_MMU */
 
-/* Memory initialisation debug and verification */
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-DECLARE_STATIC_KEY_TRUE(deferred_pages);
-
-static inline bool deferred_pages_enabled(void)
-{
-	return static_branch_unlikely(&deferred_pages);
-}
-
-bool __init deferred_grow_zone(struct zone *zone, unsigned int order);
-#else
-static inline bool deferred_pages_enabled(void)
-{
-	return false;
-}
-#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
-
-void init_deferred_page(unsigned long pfn, int nid);
-
-enum mminit_level {
-	MMINIT_WARNING,
-	MMINIT_VERIFY,
-	MMINIT_TRACE
-};
-
-#ifdef CONFIG_DEBUG_MEMORY_INIT
-
-extern int mminit_loglevel;
-
-#define mminit_dprintk(level, prefix, fmt, arg...) \
-do { \
-	if (level < mminit_loglevel) { \
-		if (level <= MMINIT_WARNING) \
-			pr_warn("mminit::" prefix " " fmt, ##arg);	\
-		else \
-			printk(KERN_DEBUG "mminit::" prefix " " fmt, ##arg); \
-	} \
-} while (0)
-
-extern void mminit_verify_pageflags_layout(void);
-extern void mminit_verify_zonelist(void);
-#else
-
-static inline void mminit_dprintk(enum mminit_level level,
-				const char *prefix, const char *fmt, ...)
-{
-}
-
-static inline void mminit_verify_pageflags_layout(void)
-{
-}
-
-static inline void mminit_verify_zonelist(void)
-{
-}
-#endif /* CONFIG_DEBUG_MEMORY_INIT */
-
 #define NODE_RECLAIM_NOSCAN	-2
 #define NODE_RECLAIM_FULL	-1
 #define NODE_RECLAIM_SOME	0
@@ -1532,9 +1447,6 @@ static inline bool gup_must_unshare(struct vm_area_struct *vma,
 	return !PageAnonExclusive(page);
 }
 
-extern bool mirrored_kernelcore;
-bool memblock_has_mirror(void);
-void memblock_free_all(void);
 
 static __always_inline void vma_set_range(struct vm_area_struct *vma,
 					  unsigned long start, unsigned long end,
@@ -1573,9 +1485,6 @@ static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte
 	return vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte);
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid);
-
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
diff --git a/mm/memblock.c b/mm/memblock.c
index 6349c48154f4..777c69f05400 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -29,6 +29,7 @@
 #include <linux/io.h>
 
 #include "internal.h"
+#include "mm_init.h"
 
 #define INIT_MEMBLOCK_REGIONS			128
 #define INIT_PHYSMEM_REGIONS			4
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 11ab2f7bc7f3..99090f49d2df 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -40,6 +40,7 @@
 #include <asm/tlbflush.h>
 
 #include "internal.h"
+#include "mm_init.h"
 #include "page_alloc.h"
 #include "shuffle.h"
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 537664974ab1..39583c028e34 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -33,6 +33,7 @@
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
 #include "internal.h"
+#include "mm_init.h"
 #include "page_alloc.h"
 #include "slab.h"
 #include "shuffle.h"
diff --git a/mm/mm_init.h b/mm/mm_init.h
new file mode 100644
index 000000000000..118f88c523c9
--- /dev/null
+++ b/mm/mm_init.h
@@ -0,0 +1,120 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * mm_init.h:
+ *
+ * mm/ internal mm_init and memblock declarations
+ */
+
+#ifndef __MM_MM_INIT_H
+#define __MM_MM_INIT_H
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/mmzone.h>
+#include <linux/jump_label.h>
+#include <linux/printk.h>
+
+struct page;
+struct vmem_altmap;
+
+/* perform sanity checks on struct pages being allocated or freed */
+DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
+
+void set_zone_contiguous(struct zone *zone);
+bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
+			   unsigned long nr_pages);
+
+static inline void clear_zone_contiguous(struct zone *zone)
+{
+	zone->contiguous = false;
+}
+
+void memblock_free_pages(unsigned long pfn, unsigned int order);
+
+void *memmap_alloc(phys_addr_t size, phys_addr_t align, phys_addr_t min_addr,
+		int nid, bool exact_nid);
+
+void memmap_init_range(unsigned long size, int nid, unsigned long zone,
+		unsigned long start_pfn, unsigned long zone_end_pfn,
+		enum meminit_context context,
+		struct vmem_altmap *altmap, int migratetype,
+		bool isolate_pageblock)
+
+#if defined CONFIG_COMPACTION || defined CONFIG_CMA
+/* Free whole pageblock and set its migration type to MIGRATE_CMA. */
+void init_cma_reserved_pageblock(struct page *page);
+#endif
+
+#ifdef CONFIG_CMA
+void init_cma_pageblock(struct page *page);
+#else
+static inline void init_cma_pageblock(struct page *page)
+{
+}
+#endif
+
+/* Memory initialisation debug and verification */
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+DECLARE_STATIC_KEY_TRUE(deferred_pages);
+
+static inline bool deferred_pages_enabled(void)
+{
+	return static_branch_unlikely(&deferred_pages);
+}
+
+bool __init deferred_grow_zone(struct zone *zone, unsigned int order);
+#else
+static inline bool deferred_pages_enabled(void)
+{
+	return false;
+}
+#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
+
+void init_deferred_page(unsigned long pfn, int nid);
+
+enum mminit_level {
+	MMINIT_WARNING,
+	MMINIT_VERIFY,
+	MMINIT_TRACE
+};
+
+#ifdef CONFIG_DEBUG_MEMORY_INIT
+
+extern int mminit_loglevel;
+
+#define mminit_dprintk(level, prefix, fmt, arg...) \
+do { \
+	if (level < mminit_loglevel) { \
+		if (level <= MMINIT_WARNING) \
+			pr_warn("mminit::" prefix " " fmt, ##arg);	\
+		else \
+			printk(KERN_DEBUG "mminit::" prefix " " fmt, ##arg); \
+	} \
+} while (0)
+
+void mminit_verify_pageflags_layout(void);
+void mminit_verify_zonelist(void);
+#else
+
+static inline void mminit_dprintk(enum mminit_level level,
+				const char *prefix, const char *fmt, ...)
+{
+}
+
+static inline void mminit_verify_pageflags_layout(void)
+{
+}
+
+static inline void mminit_verify_zonelist(void)
+{
+}
+#endif /* CONFIG_DEBUG_MEMORY_INIT */
+
+extern bool mirrored_kernelcore;
+bool memblock_has_mirror(void);
+void memblock_free_all(void);
+
+void __meminit __init_single_page(struct page *page, unsigned long pfn,
+				unsigned long zone, int nid);
+
+#endif /* __MM_MM_INIT_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a63733dac659..ecb411fcaf81 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -56,6 +56,7 @@
 #include <linux/pgalloc_tag.h>
 #include <asm/div64.h>
 #include "internal.h"
+#include "mm_init.h"
 #include "page_alloc.h"
 #include "shuffle.h"
 #include "page_reporting.h"
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 515a404b66c0..10dd4a9b591b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -41,6 +41,7 @@
 #define VMEMMAP_POPULATE_PAGEREF	0x0001
 
 #include "internal.h"
+#include "mm_init.h"
 
 /*
  * Allocate a block of memory to be used to back the virtual memory map

-- 
2.53.0


