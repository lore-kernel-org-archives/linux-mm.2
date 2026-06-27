Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08EDAC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB306B00AB; Sat, 27 Jun 2026 03:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64C16B00AC; Sat, 27 Jun 2026 03:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2CAA6B00AD; Sat, 27 Jun 2026 03:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E85C6B00AB
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:25:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14722A06BB
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:25:09 +0000 (UTC)
X-FDA: 84924856338.28.AECF62D
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 676B81C000A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:25:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uQ8NRiTh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782545107;
	b=0JDcVmnl5OTGUlpP9Elx0PHGLyxgONqZtodKndvoa6LaYTN9ccEcjzsgjhZ+ydpHBL0KqD
	urgUdt3co891nCTM9L7NJbk/nI4pKACbU+wPJAKfKzkcaNxZy1mvGimbJ9iDg3BG1dO6PK
	zkST/tP1oynGOrELsUlDWlazvsVoPRE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782545107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFEfRib3F44ymWLf0iR5G5PdO5+z3pdNZ+TLZ3Q7pmE=;
	b=wicov2jZVHHp37C/10MlBmE8K1OZLOZCchPeMQsRKXawSp1iOiGNLGJ+8t023dK5FPV8XM
	qBENmCzDPzolHuSgWWm5hborlNFpXPZXfGYJERMPlMmNsNfmW8bra5cA1DA5USuWAVdEQo
	RryecKbfIs1SGzYnb9vqhP6MyZThuEM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uQ8NRiTh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782545104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dFEfRib3F44ymWLf0iR5G5PdO5+z3pdNZ+TLZ3Q7pmE=;
	b=uQ8NRiThzOrg3CBtTVpQGOuyIhTUgzCqkSSXqyCg4MS8GvRpsx4PjxKyi6CpKTNFf/ABab
	ZFknD4pi0VhMuqcj5Uli2bKR2KySeuBS112lkbO6tIgrzPuom8jP235XR2/9jtoUOZjeJW
	XXwf8W56ZkDjeQeALcvSI3HeLq2tTJU=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	usama.arif@linux.dev,
	willy@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [RFC PATCH 3/8] mm: page_alloc: add a reserved THP allocation primitive
Date: Sat, 27 Jun 2026 15:21:51 +0800
Message-ID: <fd8d159998182ffcff6945c372a61483ed27f636.1782538002.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1782538002.git.zhengqi.arch@bytedance.com>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 676B81C000A
X-Rspam-User: 
X-Stat-Signature: 1akzatfrbgi9gwbtd81bgtr56ax9ygqk
X-HE-Tag: 1782545107-199717
X-HE-Meta: U2FsdGVkX18M4+dvcH8c/79h52lzV0BxzHEmn+JoAQg5KuhBl6bWyiDHfMvPajmMsUXyc3FOvw3ZshxGyf9WzBAE4W7i8RkUkQPFeZDsYrb+G3ZJUWmJFmmu2uGi6/TuWPfVM48ADdYy+yiLHX2+zaHtxY2Re0CdgJu57DtSgsM+KFJBmUcCHr4PKGRSwqdPB1K1nZGI++rRO+JpH4F8bZVCNG6BP2Cq/Jk/qixJAuJR2eF5Q02bKgOVCLZkHLK4pHf6u3Jre1Red8Ff3mI7E3xgJaWOj9VI73P+QQfkdYWawEaMEf4Kz4/BTdCndqEvV4q5/3QIt0T84aGAFuxyx5NQgzcHY/aX5HMI7OY7xc5dv/bkycu0jKOjXkzFsb6jSQykqcD4Q+SJW8mCbz+4ENauYOsM+mEcs8cVfmLOUp2rYLrT9GuuF9IAAqoDvC1h65ENH4Rx5SOXXMKPULOuu/evggoAVO1BzB1eTrwEp4U6Y+zcypz8h7r6IReEB7UH8Qgn0VnmvTR16ZcNxPFW67veG6iWJZjO+QJSa9iJBs8BQy9iuKlu5WWy+qgUp6qt2WcI724rCmm/IiReSDrAoCcKs07uYNXv+Pg8OrCGCl1r/Ku8Mp+FLxj8L6rMD6CdgXJcAGKoNaYAoQkEWBXbhPF8mHblGHdc1OTo1fKqJOlfUt6ksMflLo8wFIKH0aE7oIOKTQ57XDIb8HCQ3m6utXEzW3R3z1LpxO6dxTLQV03S48Q1d7P89C1aiDWsgA+FQoeAF70wKU6unRkttLmQMjjje9wtFdIEextZ8AezMk+jUQk4w5IJb9BWKBFPD7GWRaJVCSkYFJ/Jen8UyuWoK5QAOXJsA9sD+ZOXtaQoUy1bWewkaNTedDSiVViFEvR+itF554xygcmQN+vyfrk0H5dXQzQx6tU6BZcJ5oXdTRRhQXSMZicMybP25WcVT7BExtEK2XnufOQx2D2v3kF
 0GUjKuKF
 XUWMXLBCPsNOr4ZO64Qpbzo4EDZ2SHna1DOR9ogP6r6ZRTmmaI6VzRL+dW1CNyTzVEgEcxPaLqSjasSSKcljVZBwAy6+XLUo9fsWc8i97mF2MqLB21ej58gO/0FXnk/DMwiyuqjTcY33osadxDuE7NfkzTP8e/+5fQe2FW3T0XKGe+WCfPRbaFh5YFqISwQoz41sDsC311PpofBa6l7mo8y6jUtwBI4IDgSsIMvmDmyWXA20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Introduce the __GFP_RESERVED_THP and ALLOC_RESERVED_THP flags to implement
allocation primitives specifically for reserved THP.

Enforce strict isolation in the buddy allocator: allocation requests with
this flag can only be satisfied from MIGRATE_RESERVED_THP pageblocks.
Conversely, normal allocation requests are prohibited from stealing memory
from this migratetype, even in OOM or non-block fallback paths, ensuring
the reserved capacity is strictly dedicated to its target use cases.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/gfp.h             |  3 +++
 include/linux/gfp_types.h       |  8 ++++++--
 include/trace/events/mmflags.h  |  4 ++--
 mm/internal.h                   |  1 +
 mm/page_alloc.c                 | 30 +++++++++++++++++++++++++++---
 tools/include/linux/gfp_types.h |  4 ++--
 tools/perf/builtin-kmem.c       |  1 +
 7 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index cdf95a9f0b87c..2d05929fd8c72 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -30,6 +30,9 @@ static inline int gfp_migratetype(const gfp_t gfp_flags)
 	BUILD_BUG_ON(((___GFP_MOVABLE | ___GFP_RECLAIMABLE) >>
 		      GFP_MOVABLE_SHIFT) != MIGRATE_HIGHATOMIC);
 
+	if (unlikely(gfp_flags & __GFP_RESERVED_THP))
+		return MIGRATE_RESERVED_THP;
+
 	if (unlikely(page_group_by_mobility_disabled))
 		return MIGRATE_UNMOVABLE;
 
diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 54ca0c88bab6e..1f82a9491d357 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -33,7 +33,7 @@ enum {
 	___GFP_IO_BIT,
 	___GFP_FS_BIT,
 	___GFP_ZERO_BIT,
-	___GFP_UNUSED_BIT,	/* 0x200u unused */
+	___GFP_RESERVED_THP_BIT,
 	___GFP_DIRECT_RECLAIM_BIT,
 	___GFP_KSWAPD_RECLAIM_BIT,
 	___GFP_WRITE_BIT,
@@ -69,7 +69,7 @@ enum {
 #define ___GFP_IO		BIT(___GFP_IO_BIT)
 #define ___GFP_FS		BIT(___GFP_FS_BIT)
 #define ___GFP_ZERO		BIT(___GFP_ZERO_BIT)
-/* 0x200u unused */
+#define ___GFP_RESERVED_THP	BIT(___GFP_RESERVED_THP_BIT)
 #define ___GFP_DIRECT_RECLAIM	BIT(___GFP_DIRECT_RECLAIM_BIT)
 #define ___GFP_KSWAPD_RECLAIM	BIT(___GFP_KSWAPD_RECLAIM_BIT)
 #define ___GFP_WRITE		BIT(___GFP_WRITE_BIT)
@@ -141,6 +141,9 @@ enum {
  * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
  * mark_obj_codetag_empty() should be called upon freeing for objects allocated
  * with this flag to indicate that their NULL tags are expected and normal.
+ *
+ * %__GFP_RESERVED_THP is an internal flag for reserved THP faults. It restricts
+ *the allocation to %MIGRATE_RESERVED_THP pageblocks.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
@@ -148,6 +151,7 @@ enum {
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
 #define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
+#define __GFP_RESERVED_THP ((__force gfp_t)___GFP_RESERVED_THP)
 
 /**
  * DOC: Watermark modifiers
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index a6e5a44c9b429..3db40ebd7060b 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -24,6 +24,7 @@
 	TRACE_GFP_EM(IO)			\
 	TRACE_GFP_EM(FS)			\
 	TRACE_GFP_EM(ZERO)			\
+	TRACE_GFP_EM(RESERVED_THP)		\
 	TRACE_GFP_EM(DIRECT_RECLAIM)		\
 	TRACE_GFP_EM(KSWAPD_RECLAIM)		\
 	TRACE_GFP_EM(WRITE)			\
@@ -72,8 +73,7 @@
 
 TRACE_GFP_FLAGS
 
-/* Just in case these are ever used */
-TRACE_DEFINE_ENUM(___GFP_UNUSED_BIT);
+/* Just in case this is ever used */
 TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 
 #define gfpflag_string(flag) {(__force unsigned long)flag, #flag}
diff --git a/mm/internal.h b/mm/internal.h
index a76a1fad2a7fd..3826c88b3804c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1477,6 +1477,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+#define ALLOC_RESERVED_THP	0x1000 /* Allows access to reserved THP pageblocks */
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 23dbbef444f18..660e501bf676b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2460,6 +2460,9 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 {
 	struct page *page;
 
+	if (alloc_flags & ALLOC_RESERVED_THP)
+		return __rmqueue_smallest(zone, order, MIGRATE_RESERVED_THP);
+
 	if (IS_ENABLED(CONFIG_CMA)) {
 		/*
 		 * Balance movable allocations between regular and CMA areas by
@@ -3247,7 +3250,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page && !(alloc_flags & ALLOC_RESERVED_THP) &&
+			    (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
@@ -3417,7 +3421,8 @@ struct page *rmqueue(struct zone *preferred_zone,
 {
 	struct page *page;
 
-	if (likely(pcp_allowed_order(order))) {
+	if (likely(pcp_allowed_order(order)) &&
+	    !(alloc_flags & ALLOC_RESERVED_THP)) {
 		page = rmqueue_pcplist(preferred_zone, zone, order,
 				       migratetype, alloc_flags);
 		if (likely(page))
@@ -3609,7 +3614,8 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
 	if (likely(!(alloc_flags & ALLOC_RESERVES)))
 		unusable_free += READ_ONCE(z->nr_free_highatomic);
 
-	unusable_free += READ_ONCE(z->nr_free_reserved_thp);
+	if (!(alloc_flags & ALLOC_RESERVED_THP))
+		unusable_free += READ_ONCE(z->nr_free_reserved_thp);
 
 #ifdef CONFIG_CMA
 	/* If allocation can't use CMA areas don't use free CMA pages */
@@ -3685,6 +3691,12 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 		if (!area->nr_free)
 			continue;
 
+		if (alloc_flags & ALLOC_RESERVED_THP) {
+			if (!free_area_empty(area, MIGRATE_RESERVED_THP))
+				return true;
+			continue;
+		}
+
 		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
 			if (!free_area_empty(area, mt))
 				return true;
@@ -3919,6 +3931,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 		cond_accept_memory(zone, order, alloc_flags);
 
+		if (alloc_flags & ALLOC_RESERVED_THP)
+			goto try_this_zone;
+
 		/*
 		 * Detect whether the number of free pages is below high
 		 * watermark.  If so, we will decrease pcp->high and free
@@ -5076,6 +5091,15 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	ac->nodemask = nodemask;
 	ac->migratetype = gfp_migratetype(gfp_mask);
 
+	if (gfp_mask & __GFP_RESERVED_THP) {
+		if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
+		    WARN_ON_ONCE_GFP(order != HPAGE_PMD_ORDER, gfp_mask))
+			return false;
+
+		ac->migratetype = MIGRATE_RESERVED_THP;
+		*alloc_flags |= ALLOC_RESERVED_THP;
+	}
+
 	if (cpusets_enabled()) {
 		*alloc_gfp |= __GFP_HARDWALL;
 		/*
diff --git a/tools/include/linux/gfp_types.h b/tools/include/linux/gfp_types.h
index 6c75df30a281d..53a1d22fcf957 100644
--- a/tools/include/linux/gfp_types.h
+++ b/tools/include/linux/gfp_types.h
@@ -33,7 +33,7 @@ enum {
 	___GFP_IO_BIT,
 	___GFP_FS_BIT,
 	___GFP_ZERO_BIT,
-	___GFP_UNUSED_BIT,	/* 0x200u unused */
+	___GFP_RESERVED_THP_BIT,
 	___GFP_DIRECT_RECLAIM_BIT,
 	___GFP_KSWAPD_RECLAIM_BIT,
 	___GFP_WRITE_BIT,
@@ -69,7 +69,7 @@ enum {
 #define ___GFP_IO		BIT(___GFP_IO_BIT)
 #define ___GFP_FS		BIT(___GFP_FS_BIT)
 #define ___GFP_ZERO		BIT(___GFP_ZERO_BIT)
-/* 0x200u unused */
+#define ___GFP_RESERVED_THP	BIT(___GFP_RESERVED_THP_BIT)
 #define ___GFP_DIRECT_RECLAIM	BIT(___GFP_DIRECT_RECLAIM_BIT)
 #define ___GFP_KSWAPD_RECLAIM	BIT(___GFP_KSWAPD_RECLAIM_BIT)
 #define ___GFP_WRITE		BIT(___GFP_WRITE_BIT)
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index e1b2f5bc1ba8d..45732aaf1a525 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -672,6 +672,7 @@ static const struct {
 	{ "__GFP_NORETRY",		"NR" },
 	{ "__GFP_COMP",			"C" },
 	{ "__GFP_ZERO",			"Z" },
+	{ "__GFP_RESERVED_THP",		"RTHP" },
 	{ "__GFP_NOMEMALLOC",		"NMA" },
 	{ "__GFP_MEMALLOC",		"MA" },
 	{ "__GFP_HARDWALL",		"HW" },
-- 
2.54.0


