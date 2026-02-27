Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A980FEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815386B008A; Fri, 27 Feb 2026 11:01:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC206B008C; Fri, 27 Feb 2026 11:01:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7426B0092; Fri, 27 Feb 2026 11:01:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42D066B008A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:01:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 012A713BA26
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:17 +0000 (UTC)
X-FDA: 84490701036.07.C594D05
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf17.hostedemail.com (Postfix) with ESMTP id F00A340006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="OmCP9/DM";
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772208076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/C6nJmlvrDB0ueIgBJj0PZ61C1YT1IHYyYUu5jqK3s=;
	b=RdmhmDutYYvzhb1iRYtCwsUfKjZOmn4h5DaeS+C2EFVXYCXQH9hhPHpu5DRnaULxh/HYpo
	OrtqScywqTY67a2Cdej6mSedOUrkuj4gKKrQEAICrAyinSmlLE8Jxgw6PAUoULqqLfQRV7
	ez3Pz7sBH5xw4eGfK/oU7rA3qZV3JXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772208076; a=rsa-sha256;
	cv=none;
	b=Sgud5VSpwu+73Lr7zVOm+kVBOHXbBfsH8RRtk6a6DhXL3oX3pCZqnHR1jJHUyONTxOvP2F
	fjEKCBA2lvxo63puvrM/dVWag5P5mQGcBK0Bd3rvVKkRYWRCFK0G3EZ5qrJgVadRswMpWr
	a8mEcpj+nep/ZygLnR0P/VS2O1b5B1A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="OmCP9/DM";
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 86B4BB2E42;
	Fri, 27 Feb 2026 16:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772208074;
	bh=H/C6nJmlvrDB0ueIgBJj0PZ61C1YT1IHYyYUu5jqK3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmCP9/DMxndr53NYYC6Aez7arsnd5VK3fq19k00s/VgoEQIermd5lLGBYrfUIK8ry
	 Ay3/yv03kXueNBBmdxDmF6/ktsx/b/kLHBjtfuIOf7a8tJpE2T7cXF6EuEmTtzouNi
	 iJz51x894YOU4yv+YxPPsdQt5oXU3F7WArgkRhaA=
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
Subject: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Date: Fri, 27 Feb 2026 16:00:26 +0000
Message-ID: <d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772206930.git.d@ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iop7gim7kcq1rzdjhqfxc4b8gwx4qcb3
X-Rspam-User: 
X-Rspamd-Queue-Id: F00A340006
X-Rspamd-Server: rspam12
X-HE-Tag: 1772208075-23002
X-HE-Meta: U2FsdGVkX19hy/98JMFQbA2FfbPJo6FcYwdGKLQ5o3BSXMl4dOVEUsLCXwjtXcxArWQXQZhC7pn77YDRfAP0fUHr0/I9jVfh4a1r9Jsbjc9JXaVQoVkqaPBssige7fFZ9CQ8tFV17ppntuyRJ0UPmXJ34yrm7WYknkAKnrHxuo5+7opV/IUiXDriJTlyv0/wW+W0BmQof8DrGddydGiMzwx7D5Urzk8G55auY80C4px0vJ/KutJh6LE61ufEsYO7VGyc0sYdvE/GrFbzvlsFQg3t3FauiEWmhCTC+JuMu2tVNu/F4sD337dQ33diJSUYrtA74FkM5141NUhJLJtTMcjlkx1Umy8aOZWrnGqoPZSbi9DyEKLiIwy4euuMWj+Z1QhAbPsyX7f/5A2pzpif/AndKPg84BPD2tRHzaDwMNGK9xw/RMQ4g/EhkIPflSu86y3sMfGG2tkfFItFS86P6/woAGnHwT/1Itxx9SIXtwBQ+WgyQzEWg+bkLAc7bBOOE5PmwoRg0v47QLsmA+yFax4FlBQxjL1W7A0r8VUweszGEpOBIuObtZd8joRDGn2srJMxN0aTQpcrRPU7LJ9QaO7xXiBy+FHXXFiNpUuK+xkbUvm3THWPCmQLgW76OqgmrSG5+ezy2RcjWWF9FHS2s3GYGr7Obe1oqLI9xQT4mY78syyaB+e/X/SKodEjRmsRecHok8UnPb1kl8LBqIXd7dHrVCKyyqPtls0qeFs0sV9kBkfT8zaTTWoMU283ch4ZhBpuAtgU3YgwU3LAPGYYxzFOsvm8gY/9yXXtUl5sZ1rW8dxkgvsxanyNPDGmueUz/Tkn4hzCQWH0ERveivoXLTQeCpwPZmn28p0NsHgU9Wn22BFO3rd3FvGQJ7flv1no6b2/t6bKEWfXO4sqWBL+VOBWfwsiYFs4QDOCI9DPqyE25KZmMH3ybPO3qwZEBAjjD7s+WiRSgqVaWFZWxDU
 ak67crAs
 pu5Tvhk+sC5TCS921mUGBELtdonmmADQPXoR0bZ0RDVaHXcAdrpPS+SDQ2nEJWqvukFgK6N6/mY60YLQjCszqBmPrRtK7isFVXCLaB2Kmvit1g+r16jZVYYKsxzYjEiclQANqaRG4rwBkTiCSf3XaVc4dJH0Kd1u4ILNTT7+n9hCTn1pcvTFy6SFaii624Ew9htu4lW6BsqVPpn6i2cboIB/nB586s2TcIqUkfuzTgnc/k/HchuITx9Q5vVKmm/alKKIgIGl0HO64mrtGFwkhP1Dbsm1ULu2GGlGBx3UxowVsD28cwh4vzL9YWWR487sZgJd/lt8H9BMLFxZSHebqv32w6HO+UoxezRDhSGpwB+HaSECEBK25QsmpQSa6rwcyexJ40D8NwX/5yKhw3pcO9Ar9JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This intentionally breaks direct users of zone->lock at compile time so
all call sites are converted to the zone lock wrappers. Without the
rename, present and future out-of-tree code could continue using
spin_lock(&zone->lock) and bypass the wrappers and tracing
infrastructure.

No functional change intended.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: SeongJae Park <sj@kernel.org>
---
 include/linux/mmzone.h      |  7 +++++--
 include/linux/mmzone_lock.h | 12 ++++++------
 mm/compaction.c             |  4 ++--
 mm/internal.h               |  2 +-
 mm/page_alloc.c             | 16 ++++++++--------
 mm/page_isolation.c         |  4 ++--
 mm/page_owner.c             |  2 +-
 7 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e51190a55e4..32bca655fce5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1009,8 +1009,11 @@ struct zone {
 	/* zone flags, see below */
 	unsigned long		flags;
 
-	/* Primarily protects free_area */
-	spinlock_t		lock;
+	/*
+	 * Primarily protects free_area. Should be accessed via zone_lock_*
+	 * helpers.
+	 */
+	spinlock_t		_lock;
 
 	/* Pages to be freed when next trylock succeeds */
 	struct llist_head	trylock_free_pages;
diff --git a/include/linux/mmzone_lock.h b/include/linux/mmzone_lock.h
index a1cfba8408d6..62e34d500078 100644
--- a/include/linux/mmzone_lock.h
+++ b/include/linux/mmzone_lock.h
@@ -7,32 +7,32 @@
 
 static inline void zone_lock_init(struct zone *zone)
 {
-	spin_lock_init(&zone->lock);
+	spin_lock_init(&zone->_lock);
 }
 
 #define zone_lock_irqsave(zone, flags)				\
 do {								\
-	spin_lock_irqsave(&(zone)->lock, flags);		\
+	spin_lock_irqsave(&(zone)->_lock, flags);		\
 } while (0)
 
 #define zone_trylock_irqsave(zone, flags)			\
 ({								\
-	spin_trylock_irqsave(&(zone)->lock, flags);		\
+	spin_trylock_irqsave(&(zone)->_lock, flags);		\
 })
 
 static inline void zone_unlock_irqrestore(struct zone *zone, unsigned long flags)
 {
-	spin_unlock_irqrestore(&zone->lock, flags);
+	spin_unlock_irqrestore(&zone->_lock, flags);
 }
 
 static inline void zone_lock_irq(struct zone *zone)
 {
-	spin_lock_irq(&zone->lock);
+	spin_lock_irq(&zone->_lock);
 }
 
 static inline void zone_unlock_irq(struct zone *zone)
 {
-	spin_unlock_irq(&zone->lock);
+	spin_unlock_irq(&zone->_lock);
 }
 
 #endif /* _LINUX_MMZONE_LOCK_H */
diff --git a/mm/compaction.c b/mm/compaction.c
index c68fcc416fc7..ac2a259518b1 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -506,7 +506,7 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
 static bool compact_zone_lock_irqsave(struct zone *zone,
 				      unsigned long *flags,
 				      struct compact_control *cc)
-	__acquires(&zone->lock)
+	__acquires(&zone->_lock)
 {
 	/* Track if the lock is contended in async mode */
 	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
@@ -1402,7 +1402,7 @@ static bool suitable_migration_target(struct compact_control *cc,
 		int order = cc->order > 0 ? cc->order : pageblock_order;
 
 		/*
-		 * We are checking page_order without zone->lock taken. But
+		 * We are checking page_order without zone->_lock taken. But
 		 * the only small danger is that we skip a potentially suitable
 		 * pageblock, so it's not worth to check order for valid range.
 		 */
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..6cb06e21ce15 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -710,7 +710,7 @@ static inline unsigned int buddy_order(struct page *page)
  * (d) a page and its buddy are in the same zone.
  *
  * For recording whether a page is in the buddy system, we set PageBuddy.
- * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
+ * Setting, clearing, and testing PageBuddy is serialized by zone->_lock.
  *
  * For recording page's order, we use page_private(page).
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bcc3fe0368fc..0d078aef8ed6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -815,7 +815,7 @@ compaction_capture(struct capture_control *capc, struct page *page,
 static inline void account_freepages(struct zone *zone, int nr_pages,
 				     int migratetype)
 {
-	lockdep_assert_held(&zone->lock);
+	lockdep_assert_held(&zone->_lock);
 
 	if (is_migrate_isolate(migratetype))
 		return;
@@ -2473,7 +2473,7 @@ enum rmqueue_mode {
 
 /*
  * Do the hard work of removing an element from the buddy allocator.
- * Call me with the zone->lock already held.
+ * Call me with the zone->_lock already held.
  */
 static __always_inline struct page *
 __rmqueue(struct zone *zone, unsigned int order, int migratetype,
@@ -2501,7 +2501,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 	 * fallbacks modes with increasing levels of fragmentation risk.
 	 *
 	 * The fallback logic is expensive and rmqueue_bulk() calls in
-	 * a loop with the zone->lock held, meaning the freelists are
+	 * a loop with the zone->_lock held, meaning the freelists are
 	 * not subject to any outside changes. Remember in *mode where
 	 * we found pay dirt, to save us the search on the next call.
 	 */
@@ -3203,7 +3203,7 @@ void __putback_isolated_page(struct page *page, unsigned int order, int mt)
 	struct zone *zone = page_zone(page);
 
 	/* zone lock should be held when this function is called */
-	lockdep_assert_held(&zone->lock);
+	lockdep_assert_held(&zone->_lock);
 
 	/* Return isolated page to tail of freelist. */
 	__free_one_page(page, page_to_pfn(page), zone, order, mt,
@@ -7086,7 +7086,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	 * pages.  Because of this, we reserve the bigger range and
 	 * once this is done free the pages we are not interested in.
 	 *
-	 * We don't have to hold zone->lock here because the pages are
+	 * We don't have to hold zone->_lock here because the pages are
 	 * isolated thus they won't get removed from buddy.
 	 */
 	outer_start = find_large_buddy(start);
@@ -7655,7 +7655,7 @@ void accept_page(struct page *page)
 		return;
 	}
 
-	/* Unlocks zone->lock */
+	/* Unlocks zone->_lock */
 	__accept_page(zone, &flags, page);
 }
 
@@ -7672,7 +7672,7 @@ static bool try_to_accept_memory_one(struct zone *zone)
 		return false;
 	}
 
-	/* Unlocks zone->lock */
+	/* Unlocks zone->_lock */
 	__accept_page(zone, &flags, page);
 
 	return true;
@@ -7813,7 +7813,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 
 	/*
 	 * Best effort allocation from percpu free list.
-	 * If it's empty attempt to spin_trylock zone->lock.
+	 * If it's empty attempt to spin_trylock zone->_lock.
 	 */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
 
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 91a0836bf1b7..cf731370e7a7 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -212,7 +212,7 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 	zone_unlock_irqrestore(zone, flags);
 	if (mode == PB_ISOLATE_MODE_MEM_OFFLINE) {
 		/*
-		 * printk() with zone->lock held will likely trigger a
+		 * printk() with zone->_lock held will likely trigger a
 		 * lockdep splat, so defer it here.
 		 */
 		dump_page(unmovable, "unmovable page");
@@ -553,7 +553,7 @@ void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
 /*
  * Test all pages in the range is free(means isolated) or not.
  * all pages in [start_pfn...end_pfn) must be in the same zone.
- * zone->lock must be held before call this.
+ * zone->_lock must be held before call this.
  *
  * Returns the last tested pfn.
  */
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be557f..54a4ba63b14f 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -799,7 +799,7 @@ static void init_pages_in_zone(struct zone *zone)
 				continue;
 
 			/*
-			 * To avoid having to grab zone->lock, be a little
+			 * To avoid having to grab zone->_lock, be a little
 			 * careful when reading buddy page order. The only
 			 * danger is that we skip too much and potentially miss
 			 * some early allocated pages, which is better than
-- 
2.47.3


