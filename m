Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E752E9E31F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0826B008A; Wed, 11 Feb 2026 10:23:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AF66B0089; Wed, 11 Feb 2026 10:23:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD326B0092; Wed, 11 Feb 2026 10:23:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A545F6B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:23:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DF081B39BA
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:23:26 +0000 (UTC)
X-FDA: 84432544812.11.E65578C
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf24.hostedemail.com (Postfix) with ESMTP id 883DD180010
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:23:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=aT4R8grp;
	spf=pass (imf24.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770823404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6WMYOlUnJnbb/yiHFfUdTkuXMu+Nd/JtojMQvn02DE=;
	b=KTXTCRpUqUdLq20YawcO3FivWmbQD4unEV1MAC+hZ0Z4PmLzKof3nmIGmdOI79pkhzjKzD
	5247akfHOrJke+8spMdcZU8EDGq1u9iu4NWLhVYMDwrt2DqqU0B65eDcnZRzw5QMw0g363
	KCZn/yZrab5HFjcNzgziyaj5sLg9HlA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=aT4R8grp;
	spf=pass (imf24.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770823404; a=rsa-sha256;
	cv=none;
	b=xNxoPiV83G9oYwSs2uQtGPnku6KN0pfd6571UKunm7UfUT9q9hV6shrmou30ujwspNZMEM
	fTnqulUgwita+H42LtwxOsPYaPEzNMq8RdTlgFuBYYReBVg5RfXEVxakA9YLcO89jyFX8r
	abAGMCLxvcX+dThbpY2aeggk65mMV3o=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id D61E7B2589;
	Wed, 11 Feb 2026 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1770823403;
	bh=k6WMYOlUnJnbb/yiHFfUdTkuXMu+Nd/JtojMQvn02DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aT4R8grpcDacmY09DJ8xJ2Stf10YvyW+wcrH0WzMJE4EcWzrOJct3JPvnbosUa6NK
	 IAFcY87y7qzLXdeenWP22iYahUNF6GPXFeaJh24Fjmo2RnyYdl9TG8mN2w8iM6qbNS
	 QtcjqL1y/bQU/HRKbwTfu1Dw2/6LoN5Iwuaaq7rM=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH 2/4] mm: convert zone lock users to wrappers
Date: Wed, 11 Feb 2026 15:22:14 +0000
Message-ID: <7d1ee95201a8870445556e61e47161f46ade8b3b.1770821420.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1770821420.git.d@ilvokhin.com>
References: <cover.1770821420.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o8g5bsfnh3n47iimpiis87a3s1qz77y6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 883DD180010
X-HE-Tag: 1770823404-109660
X-HE-Meta: U2FsdGVkX1/gRARUBZ6mJUoh3HJR4BdpDj7MmwqX9ZxCMxKPuCo40HrxXXFbmP2UTJIeznJ7j0NxpkI36q7KrDLlmt8wjptz6XC8BwwR5arG2f74qApwq3gMW7bCsYMkEoNd0vqdBfNV/p3DqRNTwTp5VaB0rqexH9soKA84tdBaAIkEyRSOpsyxFF/OCjxe1o09GeUjSztPMczetpCnFLxNDlZRXMW6G87dwkREWpwYq3Ka5ElXM1iREd/IsZIbbSMIfO+8gvD5P+tCMKR5yKzwVbFb5EqHYgTy6RFcH+h6nYnUc1MIh3+VPnZnoyeOrY49ruSl0txhQ/oh8p+NDWP9kHWHEQG5RAMAY2vvqp0UVFebjl+vPCIrfB1OxvqEVn6l5FUc4egFWbjNrNBVLDqr4Ln1TqDu2ivzNesYoCqE+Ph/J2ZgL2kiMoSLGJ0Tcmkg1v7XSXszJQDwacebnmV7dwE/setQWPQc1TygiSh6qDR5At2Y0/9SCkdYm78YcG96TDZldB1UWPPICLHyvPEnPXHABgwYfxpICFEU+E987+BxRwBCBrBRYtBSemaroYrrhW3MZc7W8sKzAE+oiv7eUrqzPIcP/DHccJWz3IdMWbbMdsWsxOGAN79bOvc+GXsv1iuvXhBwQ46rVV4rtwSsTYKrD+P1URqIzZPa+hSQx2sMRj+fsAf1hywjtclBFKD7APf+pXNNAttWxMj3KyCDm7outL3cAH3YDqolpxxVirxFE+xp5S+xuoUJJdaAKAh+nafVlCya6RUVAJlOJemDS4b3TU3CjZlfEi9WxridIdRWn3Ml7spNyg2IYwZ+JcvJJfi9jvkNbXJqps11cFQuVJD3GC+jmfwU36FNwPzTq+QsWyFnbPzGuHocjjJDZGA3N8F2HLs35pk0NeRYVkYYs+UbIxTtNrtDRCgoQygnPChLu2CD3qI4m0r9L+dc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace direct zone lock acquire/release operations with the
newly introduced wrappers.

The changes are purely mechanical substitutions. No functional change
intended. Locking semantics and ordering remain unchanged.

The compaction path is left unchanged for now and will be
handled separately in the following patch due to additional
non-trivial modifications.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/memory_hotplug.c |  9 +++---
 mm/mm_init.c        |  3 +-
 mm/page_alloc.c     | 73 +++++++++++++++++++++++----------------------
 mm/page_isolation.c | 19 ++++++------
 mm/page_reporting.c | 13 ++++----
 mm/show_mem.c       |  5 ++--
 mm/vmscan.c         |  5 ++--
 mm/vmstat.c         |  9 +++---
 8 files changed, 72 insertions(+), 64 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bc805029da51..cfc0103fa50e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -36,6 +36,7 @@
 #include <linux/rmap.h>
 #include <linux/module.h>
 #include <linux/node.h>
+#include <linux/zone_lock.h>
 
 #include <asm/tlbflush.h>
 
@@ -1190,9 +1191,9 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	 * Fixup the number of isolated pageblocks before marking the sections
 	 * onlining, such that undo_isolate_page_range() works correctly.
 	 */
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	zone->nr_isolate_pageblock += nr_pages / pageblock_nr_pages;
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	/*
 	 * If this zone is not populated, then it is not in zonelist.
@@ -2041,9 +2042,9 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	 * effectively stale; nobody should be touching them. Fixup the number
 	 * of isolated pageblocks, memory onlining will properly revert this.
 	 */
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	zone->nr_isolate_pageblock -= nr_pages / pageblock_nr_pages;
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	lru_cache_enable();
 	zone_pcp_enable(zone);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1a29a719af58..426e5a0256f9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -32,6 +32,7 @@
 #include <linux/vmstat.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
+#include <linux/zone_lock.h>
 #include "internal.h"
 #include "slab.h"
 #include "shuffle.h"
@@ -1425,7 +1426,7 @@ static void __meminit zone_init_internals(struct zone *zone, enum zone_type idx,
 	zone_set_nid(zone, nid);
 	zone->name = zone_names[idx];
 	zone->zone_pgdat = NODE_DATA(nid);
-	spin_lock_init(&zone->lock);
+	zone_lock_init(zone);
 	zone_seqlock_init(zone);
 	zone_pcp_init(zone);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e4104973e22f..2c9fe30da7a1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -54,6 +54,7 @@
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/zone_lock.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
@@ -1494,7 +1495,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 
 	while (count > 0) {
 		struct list_head *list;
@@ -1527,7 +1528,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		} while (count > 0 && !list_empty(list));
 	}
 
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 }
 
 /* Split a multi-block free page into its individual pageblocks. */
@@ -1571,12 +1572,12 @@ static void free_one_page(struct zone *zone, struct page *page,
 	unsigned long flags;
 
 	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
-		if (!spin_trylock_irqsave(&zone->lock, flags)) {
+		if (!zone_trylock_irqsave(zone, flags)) {
 			add_page_to_zone_llist(zone, page, order);
 			return;
 		}
 	} else {
-		spin_lock_irqsave(&zone->lock, flags);
+		zone_lock_irqsave(zone, flags);
 	}
 
 	/* The lock succeeded. Process deferred pages. */
@@ -1594,7 +1595,7 @@ static void free_one_page(struct zone *zone, struct page *page,
 		}
 	}
 	split_large_buddy(zone, page, pfn, order, fpi_flags);
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	__count_vm_events(PGFREE, 1 << order);
 }
@@ -2547,10 +2548,10 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 	int i;
 
 	if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
-		if (!spin_trylock_irqsave(&zone->lock, flags))
+		if (!zone_trylock_irqsave(zone, flags))
 			return 0;
 	} else {
-		spin_lock_irqsave(&zone->lock, flags);
+		zone_lock_irqsave(zone, flags);
 	}
 	for (i = 0; i < count; ++i) {
 		struct page *page = __rmqueue(zone, order, migratetype,
@@ -2570,7 +2571,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		 */
 		list_add_tail(&page->pcp_list, list);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	return i;
 }
@@ -3235,10 +3236,10 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 	do {
 		page = NULL;
 		if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
-			if (!spin_trylock_irqsave(&zone->lock, flags))
+			if (!zone_trylock_irqsave(zone, flags))
 				return NULL;
 		} else {
-			spin_lock_irqsave(&zone->lock, flags);
+			zone_lock_irqsave(zone, flags);
 		}
 		if (alloc_flags & ALLOC_HIGHATOMIC)
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
@@ -3257,11 +3258,11 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
-				spin_unlock_irqrestore(&zone->lock, flags);
+				zone_unlock_irqrestore(zone, flags);
 				return NULL;
 			}
 		}
-		spin_unlock_irqrestore(&zone->lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 	} while (check_new_pages(page, order));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3448,7 +3449,7 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 
 	/* Recheck the nr_reserved_highatomic limit under the lock */
 	if (zone->nr_reserved_highatomic >= max_managed)
@@ -3470,7 +3471,7 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 	}
 
 out_unlock:
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 }
 
 /*
@@ -3503,7 +3504,7 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 					pageblock_nr_pages)
 			continue;
 
-		spin_lock_irqsave(&zone->lock, flags);
+		zone_lock_irqsave(zone, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
 			unsigned long size;
@@ -3551,11 +3552,11 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 			 */
 			WARN_ON_ONCE(ret == -1);
 			if (ret > 0) {
-				spin_unlock_irqrestore(&zone->lock, flags);
+				zone_unlock_irqrestore(zone, flags);
 				return ret;
 			}
 		}
-		spin_unlock_irqrestore(&zone->lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 	}
 
 	return false;
@@ -6435,7 +6436,7 @@ static void __setup_per_zone_wmarks(void)
 	for_each_zone(zone) {
 		u64 tmp;
 
-		spin_lock_irqsave(&zone->lock, flags);
+		zone_lock_irqsave(zone, flags);
 		tmp = (u64)pages_min * zone_managed_pages(zone);
 		tmp = div64_ul(tmp, lowmem_pages);
 		if (is_highmem(zone) || zone_idx(zone) == ZONE_MOVABLE) {
@@ -6476,7 +6477,7 @@ static void __setup_per_zone_wmarks(void)
 		zone->_watermark[WMARK_PROMO] = high_wmark_pages(zone) + tmp;
 		trace_mm_setup_per_zone_wmarks(zone);
 
-		spin_unlock_irqrestore(&zone->lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 	}
 
 	/* update totalreserve_pages */
@@ -7246,7 +7247,7 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 	zonelist = node_zonelist(nid, gfp_mask);
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(gfp_mask), nodemask) {
-		spin_lock_irqsave(&zone->lock, flags);
+		zone_lock_irqsave(zone, flags);
 
 		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
 		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
@@ -7260,18 +7261,18 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 				 * allocation spinning on this lock, it may
 				 * win the race and cause allocation to fail.
 				 */
-				spin_unlock_irqrestore(&zone->lock, flags);
+				zone_unlock_irqrestore(zone, flags);
 				ret = alloc_contig_frozen_range_noprof(pfn,
 							pfn + nr_pages,
 							ACR_FLAGS_NONE,
 							gfp_mask);
 				if (!ret)
 					return pfn_to_page(pfn);
-				spin_lock_irqsave(&zone->lock, flags);
+				zone_lock_irqsave(zone, flags);
 			}
 			pfn += nr_pages;
 		}
-		spin_unlock_irqrestore(&zone->lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 	}
 	/*
 	 * If we failed, retry the search, but treat regions with HugeTLB pages
@@ -7425,7 +7426,7 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	while (pfn < end_pfn) {
 		page = pfn_to_page(pfn);
 		/*
@@ -7455,7 +7456,7 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		del_page_from_free_list(page, zone, order, MIGRATE_ISOLATE);
 		pfn += (1 << order);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	return end_pfn - start_pfn - already_offline;
 }
@@ -7531,7 +7532,7 @@ bool take_page_off_buddy(struct page *page)
 	unsigned int order;
 	bool ret = false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	for (order = 0; order < NR_PAGE_ORDERS; order++) {
 		struct page *page_head = page - (pfn & ((1 << order) - 1));
 		int page_order = buddy_order(page_head);
@@ -7552,7 +7553,7 @@ bool take_page_off_buddy(struct page *page)
 		if (page_count(page_head) > 0)
 			break;
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 	return ret;
 }
 
@@ -7565,7 +7566,7 @@ bool put_page_back_buddy(struct page *page)
 	unsigned long flags;
 	bool ret = false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	if (put_page_testzero(page)) {
 		unsigned long pfn = page_to_pfn(page);
 		int migratetype = get_pfnblock_migratetype(page, pfn);
@@ -7576,7 +7577,7 @@ bool put_page_back_buddy(struct page *page)
 			ret = true;
 		}
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	return ret;
 }
@@ -7625,7 +7626,7 @@ static void __accept_page(struct zone *zone, unsigned long *flags,
 	account_freepages(zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, -MAX_ORDER_NR_PAGES);
 	__ClearPageUnaccepted(page);
-	spin_unlock_irqrestore(&zone->lock, *flags);
+	zone_unlock_irqrestore(zone, *flags);
 
 	accept_memory(page_to_phys(page), PAGE_SIZE << MAX_PAGE_ORDER);
 
@@ -7637,9 +7638,9 @@ void accept_page(struct page *page)
 	struct zone *zone = page_zone(page);
 	unsigned long flags;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	if (!PageUnaccepted(page)) {
-		spin_unlock_irqrestore(&zone->lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 		return;
 	}
 
@@ -7652,11 +7653,11 @@ static bool try_to_accept_memory_one(struct zone *zone)
 	unsigned long flags;
 	struct page *page;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	page = list_first_entry_or_null(&zone->unaccepted_pages,
 					struct page, lru);
 	if (!page) {
-		spin_unlock_irqrestore(&zone->lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 		return false;
 	}
 
@@ -7713,12 +7714,12 @@ static bool __free_unaccepted(struct page *page)
 	if (!lazy_accept)
 		return false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	list_add_tail(&page->lru, &zone->unaccepted_pages);
 	account_freepages(zone, MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, MAX_ORDER_NR_PAGES);
 	__SetPageUnaccepted(page);
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	return true;
 }
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index c48ff5c00244..56a272f38b66 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -10,6 +10,7 @@
 #include <linux/hugetlb.h>
 #include <linux/page_owner.h>
 #include <linux/migrate.h>
+#include <linux/zone_lock.h>
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -173,7 +174,7 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 	if (PageUnaccepted(page))
 		accept_page(page);
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 
 	/*
 	 * We assume the caller intended to SET migrate type to isolate.
@@ -181,7 +182,7 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 	 * set it before us.
 	 */
 	if (is_migrate_isolate_page(page)) {
-		spin_unlock_irqrestore(&zone->lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 		return -EBUSY;
 	}
 
@@ -200,15 +201,15 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 			mode);
 	if (!unmovable) {
 		if (!pageblock_isolate_and_move_free_pages(zone, page)) {
-			spin_unlock_irqrestore(&zone->lock, flags);
+			zone_unlock_irqrestore(zone, flags);
 			return -EBUSY;
 		}
 		zone->nr_isolate_pageblock++;
-		spin_unlock_irqrestore(&zone->lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 		return 0;
 	}
 
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 	if (mode == PB_ISOLATE_MODE_MEM_OFFLINE) {
 		/*
 		 * printk() with zone->lock held will likely trigger a
@@ -229,7 +230,7 @@ static void unset_migratetype_isolate(struct page *page)
 	struct page *buddy;
 
 	zone = page_zone(page);
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	if (!is_migrate_isolate_page(page))
 		goto out;
 
@@ -280,7 +281,7 @@ static void unset_migratetype_isolate(struct page *page)
 	}
 	zone->nr_isolate_pageblock--;
 out:
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 }
 
 static inline struct page *
@@ -641,9 +642,9 @@ int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 
 	/* Check all pages are free or marked as ISOLATED */
 	zone = page_zone(page);
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	pfn = __test_page_isolated_in_pageblock(start_pfn, end_pfn, mode);
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	ret = pfn < end_pfn ? -EBUSY : 0;
 
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 8a03effda749..ac2ac8fd0487 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
+#include <linux/zone_lock.h>
 
 #include "page_reporting.h"
 #include "internal.h"
@@ -161,7 +162,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	if (list_empty(list))
 		return err;
 
-	spin_lock_irq(&zone->lock);
+	zone_lock_irq(zone);
 
 	/*
 	 * Limit how many calls we will be making to the page reporting
@@ -219,7 +220,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 			list_rotate_to_front(&page->lru, list);
 
 		/* release lock before waiting on report processing */
-		spin_unlock_irq(&zone->lock);
+		zone_unlock_irq(zone);
 
 		/* begin processing pages in local list */
 		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
@@ -231,7 +232,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 		budget--;
 
 		/* reacquire zone lock and resume processing */
-		spin_lock_irq(&zone->lock);
+		zone_lock_irq(zone);
 
 		/* flush reported pages from the sg list */
 		page_reporting_drain(prdev, sgl, PAGE_REPORTING_CAPACITY, !err);
@@ -251,7 +252,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	if (!list_entry_is_head(next, list, lru) && !list_is_first(&next->lru, list))
 		list_rotate_to_front(&next->lru, list);
 
-	spin_unlock_irq(&zone->lock);
+	zone_unlock_irq(zone);
 
 	return err;
 }
@@ -296,9 +297,9 @@ page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 		err = prdev->report(prdev, sgl, leftover);
 
 		/* flush any remaining pages out from the last report */
-		spin_lock_irq(&zone->lock);
+		zone_lock_irq(zone);
 		page_reporting_drain(prdev, sgl, leftover, !err);
-		spin_unlock_irq(&zone->lock);
+		zone_unlock_irq(zone);
 	}
 
 	return err;
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 24078ac3e6bc..245beca127af 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -14,6 +14,7 @@
 #include <linux/mmzone.h>
 #include <linux/swap.h>
 #include <linux/vmstat.h>
+#include <linux/zone_lock.h>
 
 #include "internal.h"
 #include "swap.h"
@@ -363,7 +364,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 		show_node(zone);
 		printk(KERN_CONT "%s: ", zone->name);
 
-		spin_lock_irqsave(&zone->lock, flags);
+		zone_lock_irqsave(zone, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &zone->free_area[order];
 			int type;
@@ -377,7 +378,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 					types[order] |= 1 << type;
 			}
 		}
-		spin_unlock_irqrestore(&zone->lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			printk(KERN_CONT "%lu*%lukB ",
 			       nr[order], K(1UL) << order);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 973ffb9813ea..9fe5c41e0e0a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -58,6 +58,7 @@
 #include <linux/random.h>
 #include <linux/mmu_notifier.h>
 #include <linux/parser.h>
+#include <linux/zone_lock.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -7129,9 +7130,9 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 
 			/* Increments are under the zone lock */
 			zone = pgdat->node_zones + i;
-			spin_lock_irqsave(&zone->lock, flags);
+			zone_lock_irqsave(zone, flags);
 			zone->watermark_boost -= min(zone->watermark_boost, zone_boosts[i]);
-			spin_unlock_irqrestore(&zone->lock, flags);
+			zone_unlock_irqrestore(zone, flags);
 		}
 
 		/*
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 99270713e0c1..06b27255a626 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -28,6 +28,7 @@
 #include <linux/mm_inline.h>
 #include <linux/page_owner.h>
 #include <linux/sched/isolation.h>
+#include <linux/zone_lock.h>
 
 #include "internal.h"
 
@@ -1535,10 +1536,10 @@ static void walk_zones_in_node(struct seq_file *m, pg_data_t *pgdat,
 			continue;
 
 		if (!nolock)
-			spin_lock_irqsave(&zone->lock, flags);
+			zone_lock_irqsave(zone, flags);
 		print(m, pgdat, zone);
 		if (!nolock)
-			spin_unlock_irqrestore(&zone->lock, flags);
+			zone_unlock_irqrestore(zone, flags);
 	}
 }
 #endif
@@ -1603,9 +1604,9 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
 				}
 			}
 			seq_printf(m, "%s%6lu ", overflow ? ">" : "", freecount);
-			spin_unlock_irq(&zone->lock);
+			zone_unlock_irq(zone);
 			cond_resched();
-			spin_lock_irq(&zone->lock);
+			zone_lock_irq(zone);
 		}
 		seq_putc(m, '\n');
 	}
-- 
2.47.3


