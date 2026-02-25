Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 149EAFD3762
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92CF16B008A; Wed, 25 Feb 2026 09:44:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD606B0092; Wed, 25 Feb 2026 09:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706DC6B008A; Wed, 25 Feb 2026 09:44:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50CD66B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:44:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B9568C00E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:44:18 +0000 (UTC)
X-FDA: 84483249396.23.FF8803D
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4632140003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:44:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=RT24pHSb;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772030656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpMgxp62w26pXbqmP5pg7cxR6rT97b8qCYuiGnUvo2I=;
	b=74CH5qSp2SMRDTrr2tRIEN+LyqxTEJuUz2hHzjNKGiNPTAFVM3REq2FCssthL01QB2X6OI
	cmX7KA5tK1vgZSmpFG1u7sEXqNJ9S6sxIF/zV7lezO079D9EKQnZUiQTQk8yMHnllCp8s9
	qP0QQtKtsaNqAIvh9F2139Buwa4e7NA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=RT24pHSb;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772030656; a=rsa-sha256;
	cv=none;
	b=S+agEcAGMEAKmcD7wQ5A0sd1oyh1KSIisV9sYtTII4vf2aDyjjGPpd00aJdGdRPoTKTTCw
	hrfrb7BmE1MyibLk4Cq/zZ6Bw0Uybgivg1FIL0UeSinsrqpXrKyY7RZp6YR3xh892x1wMJ
	p0lsqf5MLnUIPkn204MZPwZe4B7CMPI=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 86254B2C2C;
	Wed, 25 Feb 2026 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772030654;
	bh=qpMgxp62w26pXbqmP5pg7cxR6rT97b8qCYuiGnUvo2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RT24pHSbCJSxkPO8SEL0Vt7nM9Ae9m+3sNq9ZKLkzqpzjh1QmA253oqQ9lzOmAqwK
	 1NAnsTj2oEXrmagae/mpA7JoRe1GBFTUe+VLjJCl8aITTZG1AoxyQ4jXKDqkpsH11+
	 mgLJizFaVL9+VnXL81CH/9qSDGBl6nTZHNBwKzMg=
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
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v2 2/4] mm: convert zone lock users to wrappers
Date: Wed, 25 Feb 2026 14:43:04 +0000
Message-ID: <e5324d64361f86d930d940a5b49235f7996efe53.1772030186.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772030186.git.d@ilvokhin.com>
References: <cover.1772030186.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4632140003
X-Rspamd-Server: rspam02
X-Stat-Signature: zre8fpu15k5qg9nuz3qha1mwmnzrmu7e
X-HE-Tag: 1772030656-618447
X-HE-Meta: U2FsdGVkX18P4SQrkrp5+h9HNfz8WS7G20sVELe09PuTU4KzwuZGERbM0b9cJBgrmBb+Ym1kJafjL87US/p4HWDxCXhFTpkSQ/onA1oSS0wzkti7Dr09HcWrUPtUEouBCEQUWa6nTpCu0ERnYMn80XZk3EMbI6XEH1oxncBDUSF+kx73PTCdYCwkf3tTEhTGGDV5o5zkAS9W5vGg7uUwExw4ezvB2ftC+oQTLkXxjtipFY1glvfBG8Axn7TwcdLER/f/9NzQyC3SWONg3nFGfdKuCUZwxzlP1Q20sCbeU8yOy3sWhNkPFPuObVKaXF79Mj6NsYHxUq/ukQpkrhSk0VDGJbNeKRc/JwUUkc3fKUgQnVB1XlnqfhwdT4CggFlnhq66krGX4f2mdCLlDERGQJ5hUy73gHln3IctCc8HTiSguyiumb3KbJnkTAqPK43qzOHi8XcWUaArZZrCPntSY/aIw9kuFDo0OUZssQMOHJ4faqur5iWbhBsJq1JZ6V/Nqq2c53wtjzbFiMdN+LwM7+Pw0vXryuMU1PdtG6N2xtP16nKozlTdWd72pJqo+wYR4Q4b4NCKDTveZuN7ojVqyvewo9vmR32mVcTVP001xqfGFUzYyxQw6ajQErBkTwZqjDlQjD96TV/fP+s59MpseJ6lmfH/p76p8f+WwUiNBsZKTNtVRunZxOlSb0oulp97/9lzvt1Qr6B4/hD896liywj7hJM0MlPdLSlfLUY+TTKm9ThLq+EOMo2KG2oHROuCjfErxdd0XxbG5X90SwVY+aJKsoFNLK96sNP/Kd3bicLGraUTsxTWwbD0rq6UUhOJUE7USOMf0Qh4nedfSfZPlc3j0zkWROJeXrf7ZU3IkgxLnR4R1Mdc3bSJwBNVM81v61P1mjqCpBSNpMHnyap7W5TFVMcqusrbAczs23dqboucy28ijky1nGCnHWr4qM46s9VCbFAdncvB4Gid2pk
 3UF/x4L7
 ZipAnnQNJ9LqfntGthQateivx2aOAF0s/u2bdbGrrlmJqsO840fglfnLAFLwG/oVASlAKy+3uS66Mx1I7iXTnCqQVQCGNo92I4NVG/++bjajjPepxm70otfbqfmazcwx/A6BbslC8F9BsJ6MSAsAmub9JXVm6vkkas3a1tZv5PkjkorObcX5TbAfYb9X3L2Lu73RG+5/ElTD79Zx9TU425R1/AhyCGKlfMtSNBQL2YJPLYtyvg0ikDAm+e86arZrfbRJOnJLu4Mb0mm8/GjL5mLyxpg==
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
---
 mm/compaction.c     | 25 +++++++++-------
 mm/memory_hotplug.c |  9 +++---
 mm/mm_init.c        |  3 +-
 mm/page_alloc.c     | 73 +++++++++++++++++++++++----------------------
 mm/page_isolation.c | 19 ++++++------
 mm/page_reporting.c | 13 ++++----
 mm/show_mem.c       |  5 ++--
 mm/vmscan.c         |  5 ++--
 mm/vmstat.c         |  9 +++---
 9 files changed, 86 insertions(+), 75 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..47b26187a5df 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -24,6 +24,7 @@
 #include <linux/page_owner.h>
 #include <linux/psi.h>
 #include <linux/cpuset.h>
+#include <linux/zone_lock.h>
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
index 61d983d23f55..6dd37621248b 100644
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
index fcc32737f451..c5d13fe9b79f 100644
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
index f0042d5743af..37e54e16538b 100644
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
index 0fc9373e8251..b369e00e8415 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -58,6 +58,7 @@
 #include <linux/random.h>
 #include <linux/mmu_notifier.h>
 #include <linux/parser.h>
+#include <linux/zone_lock.h>
 
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
index 86b14b0f77b5..299b461a6b4b 100644
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


