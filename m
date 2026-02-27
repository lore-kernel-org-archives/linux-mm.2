Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0881FFEFB6C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA706B0092; Fri, 27 Feb 2026 11:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37036B0093; Fri, 27 Feb 2026 11:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD636B0095; Fri, 27 Feb 2026 11:01:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 660A26B0092
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:01:29 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B6C851A0880
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:16 +0000 (UTC)
X-FDA: 84490700952.17.AC23C6B
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id 984D240005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=slTfDf79;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772208074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1aak2CGfWjT2h8Dniqoqnv4ziClhGqVIDe0exTCl1s=;
	b=ytcjPlm1nBASmQDportnN9WV2wvXvR4hZyYUsiITDrBJxzLPJWKN6ospScgfCkZP7JYGK2
	ZBhV9liFyhN/yK7PTrlRI2Q/YDwPNDV3JxJtERWc4cG67fNuGzinqlBq4yV/UxZzZfu/Aq
	fQkKIeZrxwnsMmxpaaSVrThwNUdEbgA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=slTfDf79;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772208074; a=rsa-sha256;
	cv=none;
	b=6ifLoF3F9mkZCqRfka3Z7rc4g58Ws7w1iyr1sa6lcVkWaXyuiJwlXQAmeKsn9xOZGmrM5y
	hfQY5E8Mc3Z6gwkbbsV0JDwWN78nra6w1hArSheYTlvLDOyem/1YMDh7OcssozsLHwKE/k
	3OTEpHHAtxVFkfKjaGD/KfiLF/lxaJc=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 81A03B2E39;
	Fri, 27 Feb 2026 16:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772208072;
	bh=V1aak2CGfWjT2h8Dniqoqnv4ziClhGqVIDe0exTCl1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=slTfDf79Czz/WGUgxeEZ5RO3RiEmaNOvWgoZNv3QBAnUMY/CDIxXPHE/0qgphCpEZ
	 B3lvHoeqrGRvH9DTPEOhJ9SdmOeKtW87+MkfadM5IJx7sj1oDL4mMbarX6xDL5zGZX
	 JCPeLGWAPFT3IWuafT/neD88y+OVV3k7MshUMQC0=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	"linux-cxl@vger.kernel.orgkernel-team"@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>, SeongJae Park <sj@kernel.org>
Subject: [PATCH v4 2/5] mm: convert zone lock users to wrappers
Date: Fri, 27 Feb 2026 16:00:24 +0000
Message-ID: <d26a43ebed2f0f1edb9cfe4fbed16dd31c7a069c.1772206930.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772206930.git.d@ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 984D240005
X-Stat-Signature: 7mzwfqqnnx6sax6kattz8ztqmx7oucud
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772208074-633620
X-HE-Meta: U2FsdGVkX1+BQm2ZF50jHWJ94uMwI9Wk3zSqW3n+IdNhPjHXhAPI3AmSLCandfsj7s1VTvZ6El9PbP6oO6a/JioAcN9aYRrvlmhtFQlQtwJDwBVyqex68lqh7ELy5P7Lb9cNhgVqyb8Ed5qbzBceacXYnatv2CoQbGNDbZvzqGm8L9+Mpf8iSRuHJuW+q5Nn+GKJPxiAQhpLV7vILoElnPQ8AP7D7C/LUF3LHrDM3TClCPiC4UM3d0prak4DEY2Q3nH6ceKWGVUm47+VVLPvzdmAjXNlUMhm8czyGG5BOKuxIQKvEI37GvW84ESCIpKcSYiTM0Dvkt2olTQBAnrxtBy6DGDZZbVgvxLY7nwhaP7XGM9L+scXUDZ9EB4RrPWGt4Mw3aVLCBT17VPeNqYHCrwt+ojbvQiogt8TtnWIZ4giWG/BvtJl72CuB6kogwlbLTLjssTJ6tCCpfo1MQggwI39I7lf2rN68tXVt3PzN2gsAMd5PHIH64/Y+T9CZVbOS38G57hwQwwU1FZJw6PwUqnJNQa0TYaZL0wbJZcko0YoicLqug0aMosl3QKTnBzFbCO8Hnh93Uf9Y6Rtq/8IobfJEEkndLRXqoiXgMJI6czQ9MYnu5sJATT9KLExevCIkZ0BO/iHsGlIO+lyPGLZqpZWCkfnxgOtGkgkAfnPAJpVCzFvmWMtIIPG+1XJkNjfMEitlM0LRHsZ17aDgVosjdV5tZt6tbJvmOfGQ+jBRztDBNyIyWXHX8Puk6KEm1IgNEDLLKFcgWHG99O6auGeduj7yxi12OHr/lb0HBLLVw8+caPwLlm1+9NMXXhpuhvW54DBZnjkeidOlcchfEsQBptl8b8/8p27qm77EPyZ+k5b15ih9pzYPs0A1AHoAkQ1/7Tv4r+k+h2L8svKR7P5jaDCZkjz7W3UM5uHz0pV82HYCS4GxFhf1kzpRFm2VHBZXiEzlB7a7TPC9CglzBW
 tffDHltV
 dptkizMgDEfRsSiNkVltvodf/k+8qhpFf+stJVaby0xS1dlohC7tb1PgDOoxtQ/NnUeWgB/lc7hznm/2mifmEdIWgNTLKA6qutykUxynIl+4oXcMbV09MJBATlPkwWK9A9wEnqfDzeFWJSW2F1x8a5edhjnt033L8h176EnhC20XXl3qSzTWm9kFsgoRPv0S5KxBfbcFClaZcpvhRgWN6A1wVxICDo/386ztiFALrDhZfLYsCZGDxQk4s2PiOtGvYZEhdeN+lcwZU/qBPR/YeKefHrC1dWNIX8YqzAAmuDxJzqI0=
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 kernel/power/snapshot.c |  5 +--
 mm/compaction.c         | 25 +++++++-------
 mm/memory_hotplug.c     |  9 ++---
 mm/mm_init.c            |  3 +-
 mm/page_alloc.c         | 73 +++++++++++++++++++++--------------------
 mm/page_isolation.c     | 19 ++++++-----
 mm/page_reporting.c     | 13 ++++----
 mm/show_mem.c           |  5 +--
 mm/shuffle.c            |  9 ++---
 mm/vmscan.c             |  5 +--
 mm/vmstat.c             |  9 ++---
 11 files changed, 94 insertions(+), 81 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 6e1321837c66..7dcccf378cc2 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -13,6 +13,7 @@
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/mmzone_lock.h>
 #include <linux/suspend.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
@@ -1251,7 +1252,7 @@ static void mark_free_pages(struct zone *zone)
 	if (zone_is_empty(zone))
 		return;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 
 	max_zone_pfn = zone_end_pfn(zone);
 	for_each_valid_pfn(pfn, zone->zone_start_pfn, max_zone_pfn) {
@@ -1284,7 +1285,7 @@ static void mark_free_pages(struct zone *zone)
 			}
 		}
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 }
 
 #ifdef CONFIG_HIGHMEM
diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..fa0e332a8a92 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -24,6 +24,7 @@
 #include <linux/page_owner.h>
 #include <linux/psi.h>
 #include <linux/cpuset.h>
+#include <linux/mmzone_lock.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -530,11 +531,14 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
  * Returns true if compaction should abort due to fatal signal pending.
  * Returns false when compaction can continue.
  */
-static bool compact_unlock_should_abort(spinlock_t *lock,
-		unsigned long flags, bool *locked, struct compact_control *cc)
+
+static bool compact_unlock_should_abort(struct zone *zone,
+					unsigned long flags,
+					bool *locked,
+					struct compact_control *cc)
 {
 	if (*locked) {
-		spin_unlock_irqrestore(lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 		*locked = false;
 	}
 
@@ -582,9 +586,8 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		 * contention, to give chance to IRQs. Abort if fatal signal
 		 * pending.
 		 */
-		if (!(blockpfn % COMPACT_CLUSTER_MAX)
-		    && compact_unlock_should_abort(&cc->zone->lock, flags,
-								&locked, cc))
+		if (!(blockpfn % COMPACT_CLUSTER_MAX) &&
+		    compact_unlock_should_abort(cc->zone, flags, &locked, cc))
 			break;
 
 		nr_scanned++;
@@ -649,7 +652,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 	}
 
 	if (locked)
-		spin_unlock_irqrestore(&cc->zone->lock, flags);
+		zone_unlock_irqrestore(cc->zone, flags);
 
 	/*
 	 * Be careful to not go outside of the pageblock.
@@ -1555,7 +1558,7 @@ static void fast_isolate_freepages(struct compact_control *cc)
 		if (!area->nr_free)
 			continue;
 
-		spin_lock_irqsave(&cc->zone->lock, flags);
+		zone_lock_irqsave(cc->zone, flags);
 		freelist = &area->free_list[MIGRATE_MOVABLE];
 		list_for_each_entry_reverse(freepage, freelist, buddy_list) {
 			unsigned long pfn;
@@ -1614,7 +1617,7 @@ static void fast_isolate_freepages(struct compact_control *cc)
 			}
 		}
 
-		spin_unlock_irqrestore(&cc->zone->lock, flags);
+		zone_unlock_irqrestore(cc->zone, flags);
 
 		/* Skip fast search if enough freepages isolated */
 		if (cc->nr_freepages >= cc->nr_migratepages)
@@ -1988,7 +1991,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 		if (!area->nr_free)
 			continue;
 
-		spin_lock_irqsave(&cc->zone->lock, flags);
+		zone_lock_irqsave(cc->zone, flags);
 		freelist = &area->free_list[MIGRATE_MOVABLE];
 		list_for_each_entry(freepage, freelist, buddy_list) {
 			unsigned long free_pfn;
@@ -2021,7 +2024,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 				break;
 			}
 		}
-		spin_unlock_irqrestore(&cc->zone->lock, flags);
+		zone_unlock_irqrestore(cc->zone, flags);
 	}
 
 	cc->total_migrate_scanned += nr_scanned;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bc805029da51..36564e2fcef8 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -36,6 +36,7 @@
 #include <linux/rmap.h>
 #include <linux/module.h>
 #include <linux/node.h>
+#include <linux/mmzone_lock.h>
 
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
index 61d983d23f55..fe494514ce03 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -32,6 +32,7 @@
 #include <linux/vmstat.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
+#include <linux/mmzone_lock.h>
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
index fcc32737f451..bcc3fe0368fc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -54,6 +54,7 @@
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/mmzone_lock.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
@@ -1500,7 +1501,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 
 	while (count > 0) {
 		struct list_head *list;
@@ -1533,7 +1534,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		} while (count > 0 && !list_empty(list));
 	}
 
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 }
 
 /* Split a multi-block free page into its individual pageblocks. */
@@ -1577,12 +1578,12 @@ static void free_one_page(struct zone *zone, struct page *page,
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
@@ -1600,7 +1601,7 @@ static void free_one_page(struct zone *zone, struct page *page,
 		}
 	}
 	split_large_buddy(zone, page, pfn, order, fpi_flags);
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	__count_vm_events(PGFREE, 1 << order);
 }
@@ -2553,10 +2554,10 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
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
@@ -2576,7 +2577,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		 */
 		list_add_tail(&page->pcp_list, list);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	return i;
 }
@@ -3246,10 +3247,10 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
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
@@ -3268,11 +3269,11 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
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
@@ -3459,7 +3460,7 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 
 	/* Recheck the nr_reserved_highatomic limit under the lock */
 	if (zone->nr_reserved_highatomic >= max_managed)
@@ -3481,7 +3482,7 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 	}
 
 out_unlock:
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 }
 
 /*
@@ -3514,7 +3515,7 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 					pageblock_nr_pages)
 			continue;
 
-		spin_lock_irqsave(&zone->lock, flags);
+		zone_lock_irqsave(zone, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
 			unsigned long size;
@@ -3562,11 +3563,11 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
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
@@ -6446,7 +6447,7 @@ static void __setup_per_zone_wmarks(void)
 	for_each_zone(zone) {
 		u64 tmp;
 
-		spin_lock_irqsave(&zone->lock, flags);
+		zone_lock_irqsave(zone, flags);
 		tmp = (u64)pages_min * zone_managed_pages(zone);
 		tmp = div64_ul(tmp, lowmem_pages);
 		if (is_highmem(zone) || zone_idx(zone) == ZONE_MOVABLE) {
@@ -6487,7 +6488,7 @@ static void __setup_per_zone_wmarks(void)
 		zone->_watermark[WMARK_PROMO] = high_wmark_pages(zone) + tmp;
 		trace_mm_setup_per_zone_wmarks(zone);
 
-		spin_unlock_irqrestore(&zone->lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 	}
 
 	/* update totalreserve_pages */
@@ -7257,7 +7258,7 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 	zonelist = node_zonelist(nid, gfp_mask);
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(gfp_mask), nodemask) {
-		spin_lock_irqsave(&zone->lock, flags);
+		zone_lock_irqsave(zone, flags);
 
 		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
 		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
@@ -7271,18 +7272,18 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
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
@@ -7436,7 +7437,7 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	while (pfn < end_pfn) {
 		page = pfn_to_page(pfn);
 		/*
@@ -7466,7 +7467,7 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		del_page_from_free_list(page, zone, order, MIGRATE_ISOLATE);
 		pfn += (1 << order);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	return end_pfn - start_pfn - already_offline;
 }
@@ -7542,7 +7543,7 @@ bool take_page_off_buddy(struct page *page)
 	unsigned int order;
 	bool ret = false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	for (order = 0; order < NR_PAGE_ORDERS; order++) {
 		struct page *page_head = page - (pfn & ((1 << order) - 1));
 		int page_order = buddy_order(page_head);
@@ -7563,7 +7564,7 @@ bool take_page_off_buddy(struct page *page)
 		if (page_count(page_head) > 0)
 			break;
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 	return ret;
 }
 
@@ -7576,7 +7577,7 @@ bool put_page_back_buddy(struct page *page)
 	unsigned long flags;
 	bool ret = false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	if (put_page_testzero(page)) {
 		unsigned long pfn = page_to_pfn(page);
 		int migratetype = get_pfnblock_migratetype(page, pfn);
@@ -7587,7 +7588,7 @@ bool put_page_back_buddy(struct page *page)
 			ret = true;
 		}
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	zone_unlock_irqrestore(zone, flags);
 
 	return ret;
 }
@@ -7636,7 +7637,7 @@ static void __accept_page(struct zone *zone, unsigned long *flags,
 	account_freepages(zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, -MAX_ORDER_NR_PAGES);
 	__ClearPageUnaccepted(page);
-	spin_unlock_irqrestore(&zone->lock, *flags);
+	zone_unlock_irqrestore(zone, *flags);
 
 	accept_memory(page_to_phys(page), PAGE_SIZE << MAX_PAGE_ORDER);
 
@@ -7648,9 +7649,9 @@ void accept_page(struct page *page)
 	struct zone *zone = page_zone(page);
 	unsigned long flags;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	zone_lock_irqsave(zone, flags);
 	if (!PageUnaccepted(page)) {
-		spin_unlock_irqrestore(&zone->lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 		return;
 	}
 
@@ -7663,11 +7664,11 @@ static bool try_to_accept_memory_one(struct zone *zone)
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
 
@@ -7724,12 +7725,12 @@ static bool __free_unaccepted(struct page *page)
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
index c48ff5c00244..91a0836bf1b7 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -10,6 +10,7 @@
 #include <linux/hugetlb.h>
 #include <linux/page_owner.h>
 #include <linux/migrate.h>
+#include <linux/mmzone_lock.h>
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
index f0042d5743af..43976a9dce3f 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/mm.h>
 #include <linux/mmzone.h>
+#include <linux/mmzone_lock.h>
 #include <linux/page_reporting.h>
 #include <linux/gfp.h>
 #include <linux/export.h>
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
index 24078ac3e6bc..d7d1b6cd6442 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -12,6 +12,7 @@
 #include <linux/hugetlb.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
+#include <linux/mmzone_lock.h>
 #include <linux/swap.h>
 #include <linux/vmstat.h>
 
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
diff --git a/mm/shuffle.c b/mm/shuffle.c
index fb1393b8b3a9..5f6ae3c52842 100644
--- a/mm/shuffle.c
+++ b/mm/shuffle.c
@@ -4,6 +4,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/mmzone.h>
+#include <linux/mmzone_lock.h>
 #include <linux/random.h>
 #include <linux/moduleparam.h>
 #include "internal.h"
@@ -85,7 +86,7 @@ void __meminit __shuffle_zone(struct zone *z)
 	const int order = SHUFFLE_ORDER;
 	const int order_pages = 1 << order;
 
-	spin_lock_irqsave(&z->lock, flags);
+	zone_lock_irqsave(z, flags);
 	start_pfn = ALIGN(start_pfn, order_pages);
 	for (i = start_pfn; i < end_pfn; i += order_pages) {
 		unsigned long j;
@@ -138,12 +139,12 @@ void __meminit __shuffle_zone(struct zone *z)
 
 		/* take it easy on the zone lock */
 		if ((i % (100 * order_pages)) == 0) {
-			spin_unlock_irqrestore(&z->lock, flags);
+			zone_unlock_irqrestore(z, flags);
 			cond_resched();
-			spin_lock_irqsave(&z->lock, flags);
+			zone_lock_irqsave(z, flags);
 		}
 	}
-	spin_unlock_irqrestore(&z->lock, flags);
+	zone_unlock_irqrestore(z, flags);
 }
 
 /*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..44c70e4400e2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -58,6 +58,7 @@
 #include <linux/random.h>
 #include <linux/mmu_notifier.h>
 #include <linux/parser.h>
+#include <linux/mmzone_lock.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -7139,9 +7140,9 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 
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
index 86b14b0f77b5..6608bb489790 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -28,6 +28,7 @@
 #include <linux/mm_inline.h>
 #include <linux/page_owner.h>
 #include <linux/sched/isolation.h>
+#include <linux/mmzone_lock.h>
 
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


