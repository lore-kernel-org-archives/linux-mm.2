Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CEE5CD13DF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C80186B00B3; Thu, 30 Apr 2026 16:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30A06B00B6; Thu, 30 Apr 2026 16:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B447B6B00B3; Thu, 30 Apr 2026 16:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 958926B00B3
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F9B51A0162
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:11 +0000 (UTC)
X-FDA: 84716346582.22.8785020
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf08.hostedemail.com (Postfix) with ESMTP id A06D3160010
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=b6bT0bYt;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZlPRsVlSY0N9sVB5i+i68olf1vAtPnfBLdvrZ3fqu1c=;
	b=ly9PUjXbd17/iOdQzFx7WtG/O5l8cVwCrt7y8Iughlrex9B4uDe0K7LBRRXbQy/LbHPO/i
	vqTYD6as2fCTavvZFQTJ86M+uSxwlsKc4FJUDBJRB1bphvuoHwJq+CU7AX3eKsWrjwA3i/
	4In3w16zCLGvCsz6u50m1BkOWlr1atA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=b6bT0bYt;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580589; a=rsa-sha256;
	cv=none;
	b=gddZa4H6WtWzXX1kBT7VXY+k3TupcioxB5BTfN21VbgMWhhcuM+yjbLzfKBi2Gt6H86dqG
	yN8vLZERAxZUGW/d879cw0dlJDm5nUUnxR+rTU8ZBXv9xoW6/bwLY1tRNCQkXHuqGzzcWa
	PLt4YSIiecxkaYnoQG6SAZnA/zIsfIY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZlPRsVlSY0N9sVB5i+i68olf1vAtPnfBLdvrZ3fqu1c=; b=b6bT0bYtwX5aJnjS8SCgJnR3HJ
	QRksojuSZ+vOEbYj+wvWIXEak6V5ZEYPZj6qDWmFnkKjeKyVB2SQ6aWVZWToHBnFRd/YZzFcw/hhw
	b+OgMxASoFWkKYgfxnKDiru5DTOUZ3hEHPh+c3iLuIXLpv980fr13YVXIEPZlkgbN/ZQpe5mkTgOc
	03qXNvzxhFU71fwLktgYMzovdfOQSX2p32Kl5oMPStTP6K8cxYiLPcbirn30r7R1QyCp4qd56U18q
	4d3e5tpxbUMnpqP0njcHDa+IO4kHbtb7vGpteVQOla37OqnkKqZIi4OC/ZQRMkoAnlUwU9U9NKTSG
	jwcyNQeA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-2MpT;
	Thu, 30 Apr 2026 16:22:40 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 06/45] mm: page_alloc: remove watermark boost mechanism
Date: Thu, 30 Apr 2026 16:20:35 -0400
Message-ID: <20260430202233.111010-7-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A06D3160010
X-Rspamd-Server: rspam06
X-Stat-Signature: gnw4ugzej1k5op53kxejfmqh95haed64
X-HE-Tag: 1777580589-944663
X-HE-Meta: U2FsdGVkX18MYIFTSci9zC59tS1mAdeYesCsNXmPRFIPiUCI60y0wDJr5y3yNjVSrVUBDaJ/V4LklqPEXG2Icm9LW/CW6pA7zbTJ+pqtvtCFB3C+9gC8A1ifN26say6UIT6So24i/BoRV2nugkJ/5v4q+plI/kG5x3Yf7psJRqVQGwMMBx5rK3QXNemDT5/WtWz5eirz8D8l/HPesDhMhW+Kn92SiRJsXvRMVl8JR3rk3BmBwtg91CPRSdg/4m0RMRjTWrGrKae5IyKZHgYc+VOCN3IVGTgYIJ4PF0zvu1NpzreAuBHFLSHe5FM64yeyGrt6YMULjoUYOyoGX9i4a3M8kWEj0fgbW4SzHvm6cJvLv9Z/x3n0XgeWjWmbEXdhPXcZnJUpdJcsEPw7IPHEsvKxn/rzXI4p6bNrvX9oaOA4T0Vfr5QPWTaAwdC5pJnmkZplBcCjT9ChrWxjvskYc++rSE5PYpJOjQ1IIGnIrJj2pARjnUlqaIT62hhFjmND9dErPThukd1PUq0bdzSe5xmIQmEU3Y55r68oLs3ZWhYZkVnXzxmf786O78ToAQHLZvENMqZjcshW5P9RP0rin35uCN5/MMURDxCj+M5BMT/mEeWn6ReJoCnExqNAc5Za+hxjKVsNXxtp0d9wRwlSfrD0Ti50Km+zYyKbDsZJHW22BAzcvN0egp1w5pML+jAPrYh7yKTiw3FfYXHsJLos0kKfiFQwbJANqcORiVVI+UEx299vOP8HwyVnS2SYuEttEgnmF2lPMm/m45itIV0hjZ3UVC/1b0LLfjlfls9v31oumf9vUHqJPsfNdiFmZZ+Odye/EcNltGoqCvwuyq64bbdhh3SCAmkK1Z3dUndY0UrkfpwhuH2qRmJMcTPZTwr9H3YTtz2LSHGQgYTxfaY4odtfRGbzNxjdXsgAt+qBRXCAw/y/nTY7i/gVIdfV84v+VbiRCsEa7DGuxb6RzxU
 AEaLZCs1
 DwFxowauv0IyUk3AokiYIU+EFU/uwFkG5o8fs7ZLyqpayF51auJgQ1MFTj3wi55es2Zp8O32fWJTrxKbsobt9EXg6dwrpUNLIGhfy0wnAjnNXkERMa77Evv/Z6c/9IF6GT865guWtJ9kID/JKXqvlWqCWUs51otOz1MjTlGyAwM5MrcZlkEI7NJzJKczEtQSO/43RQYtIK7VYOQjAEZOJnYxSK9XJm8KEY7B+qkbbPn1EHGjfsSS9Vt5su+vFJA7gdVQD6NZ6V8uLK+RhtXDqqo03dSv0HdVQo9cmLfPG8pBFwyoGqeCPPCcbuYi5lnqmagi9ae+6wtOBvNwu57/qpUtAqBtih2ezWT4v4KSR+oKJAnkmcgEOjLOZ05UIwVUGod1N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

watermark_boost was introduced to react to fragmentation events at the
pageblock granularity: a sub-pageblock cross-type fallback would raise
the zone watermark and wake kswapd, on the theory that reclaiming some
order-0 pages would reduce future fallbacks.

With superpageblocks, anti-fragmentation is enforced at 1 GiB SPB
granularity, and the meaningful signals (CLEAN->TAINT events, empty SPB
count) live there.  Sub-pageblock fallbacks inside an already-tainted
SPB do not change the fragmentation picture, and order-0 reclaim does
not unmix a pageblock or surface a fresh clean SPB.

Worse, the boost is applied in try_to_claim_block() before the success
path is decided.  When option 1 (no UNMOVABLE/RECLAIMABLE pageblock
mixing) rejects a cross-type relabel, the boost has already been
applied and the next rmqueue() will wake kswapd to drain memory back
to high+boost - even when free pages are tens of times the high
watermark.  Real workloads showed bursts of >150 wakeup_kswapd/min,
all order-0, with stack traces consistently arriving from rmqueue()
through the boost-cleanup path.  Free memory at the time was 38x the
high watermark.

Drop the mechanism entirely:

  - boost_watermark() and its callsite in try_to_claim_block()
  - the ZONE_BOOSTED_WATERMARK flag and its set/clear in rmqueue()
  - zone->watermark_boost and the boost addend in wmark_pages()
  - the __GFP_HIGH boost-bypass path in zone_watermark_fast()
  - the watermark_boost_factor sysctl
  - boost-aware logic in balance_pgdat() (nr_boost_reclaim,
    zone_boosts[], pgdat_watermark_boosted, the boost-restart goto,
    no-writeback for boost reclaim, the boost-only kcompactd wakeup)

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 Documentation/admin-guide/sysctl/vm.rst |  21 -----
 Documentation/mm/physical_memory.rst    |  13 +--
 include/linux/mmzone.h                  |   6 +-
 mm/page_alloc.c                         |  82 +----------------
 mm/show_mem.c                           |   2 -
 mm/vmscan.c                             | 115 ++----------------------
 mm/vmstat.c                             |   2 -
 7 files changed, 14 insertions(+), 227 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c..3ddc6115c89a 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -76,7 +76,6 @@ files can be found in mm/swap.c.
 - user_reserve_kbytes
 - vfs_cache_pressure
 - vfs_cache_pressure_denom
-- watermark_boost_factor
 - watermark_scale_factor
 - zone_reclaim_mode
 
@@ -1073,26 +1072,6 @@ vfs_cache_pressure_denom
 Defaults to 100 (minimum allowed value). Requires corresponding
 vfs_cache_pressure setting to take effect.
 
-watermark_boost_factor
-======================
-
-This factor controls the level of reclaim when memory is being fragmented.
-It defines the percentage of the high watermark of a zone that will be
-reclaimed if pages of different mobility are being mixed within pageblocks.
-The intent is that compaction has less work to do in the future and to
-increase the success rate of future high-order allocations such as SLUB
-allocations, THP and hugetlbfs pages.
-
-To make it sensible with respect to the watermark_scale_factor
-parameter, the unit is in fractions of 10,000. The default value of
-15,000 means that up to 150% of the high watermark will be reclaimed in the
-event of a pageblock being mixed due to fragmentation. The level of reclaim
-is determined by the number of fragmentation events that occurred in the
-recent past. If this value is smaller than a pageblock then a pageblocks
-worth of pages will be reclaimed (e.g.  2MB on 64-bit x86). A boost factor
-of 0 will disable the feature.
-
-
 watermark_scale_factor
 ======================
 
diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index b76183545e5b..c4968db6e77c 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -394,11 +394,6 @@ General
   to the distance between two watermarks. The distance itself is calculated
   taking ``vm.watermark_scale_factor`` sysctl into account.
 
-``watermark_boost``
-  The number of pages which are used to boost watermarks to increase reclaim
-  pressure to reduce the likelihood of future fallbacks and wake kswapd now
-  as the node may be balanced overall and kswapd will not wake naturally.
-
 ``nr_reserved_highatomic``
   The number of pages which are reserved for high-order atomic allocations.
 
@@ -527,11 +522,9 @@ General
   Defined only when ``CONFIG_UNACCEPTED_MEMORY`` is enabled.
 
 ``flags``
-  The zone flags. The least three bits are used and defined by
-  ``enum zone_flags``. ``ZONE_BOOSTED_WATERMARK`` (bit 0): zone recently boosted
-  watermarks. Cleared when kswapd is woken. ``ZONE_RECLAIM_ACTIVE`` (bit 1):
-  kswapd may be scanning the zone. ``ZONE_BELOW_HIGH`` (bit 2): zone is below
-  high watermark.
+  The zone flags. The bits are defined by ``enum zone_flags``.
+  ``ZONE_RECLAIM_ACTIVE`` (bit 0): kswapd may be scanning the zone.
+  ``ZONE_BELOW_HIGH`` (bit 1): zone is below high watermark.
 
 ``lock``
   The main lock that protects the internal data structures of the page allocator
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a59260487ab4..5d1869fd2708 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -881,7 +881,6 @@ struct zone {
 
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long _watermark[NR_WMARK];
-	unsigned long watermark_boost;
 
 	unsigned long nr_reserved_highatomic;
 	unsigned long nr_free_highatomic;
@@ -1067,9 +1066,6 @@ enum pgdat_flags {
 };
 
 enum zone_flags {
-	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
-					 * Cleared when kswapd is woken.
-					 */
 	ZONE_RECLAIM_ACTIVE,		/* kswapd may be scanning the zone. */
 	ZONE_BELOW_HIGH,		/* zone is below high watermark. */
 };
@@ -1077,7 +1073,7 @@ enum zone_flags {
 static inline unsigned long wmark_pages(const struct zone *z,
 					enum zone_watermarks w)
 {
-	return z->_watermark[w] + z->watermark_boost;
+	return z->_watermark[w];
 }
 
 static inline unsigned long min_wmark_pages(const struct zone *z)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d98eab3e288e..5cc5edaf8111 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -301,7 +301,6 @@ const char * const migratetype_names[MIGRATE_TYPES] = {
 
 int min_free_kbytes = 1024;
 int user_min_free_kbytes = -1;
-static int watermark_boost_factor __read_mostly = 15000;
 static int watermark_scale_factor = 10;
 int defrag_mode;
 
@@ -2321,43 +2320,6 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
 
 #endif /* CONFIG_MEMORY_ISOLATION */
 
-static inline bool boost_watermark(struct zone *zone)
-{
-	unsigned long max_boost;
-
-	if (!watermark_boost_factor)
-		return false;
-	/*
-	 * Don't bother in zones that are unlikely to produce results.
-	 * On small machines, including kdump capture kernels running
-	 * in a small area, boosting the watermark can cause an out of
-	 * memory situation immediately.
-	 */
-	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
-		return false;
-
-	max_boost = mult_frac(zone->_watermark[WMARK_HIGH],
-			watermark_boost_factor, 10000);
-
-	/*
-	 * high watermark may be uninitialised if fragmentation occurs
-	 * very early in boot so do not boost. We do not fall
-	 * through and boost by pageblock_nr_pages as failing
-	 * allocations that early means that reclaim is not going
-	 * to help and it may even be impossible to reclaim the
-	 * boosted watermark resulting in a hang.
-	 */
-	if (!max_boost)
-		return false;
-
-	max_boost = max(pageblock_nr_pages, max_boost);
-
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
-		max_boost);
-
-	return true;
-}
-
 /*
  * When we are falling back to another migratetype during allocation, should we
  * try to claim an entire block to satisfy further allocations, instead of
@@ -2458,14 +2420,6 @@ try_to_claim_block(struct zone *zone, struct page *page,
 		return page;
 	}
 
-	/*
-	 * Boost watermarks to increase reclaim pressure to reduce the
-	 * likelihood of future fallbacks. Wake kswapd now as the node
-	 * may be balanced overall and kswapd will not wake naturally.
-	 */
-	if (boost_watermark(zone) && (alloc_flags & ALLOC_KSWAPD))
-		set_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
-
 	/* moving whole block can fail due to zone boundary conditions */
 	if (!prep_move_freepages_block(zone, page, &start_pfn, &free_pages,
 				       &movable_pages))
@@ -3723,13 +3677,6 @@ struct page *rmqueue(struct zone *preferred_zone,
 							migratetype);
 
 out:
-	/* Separate test+clear to avoid unnecessary atomics */
-	if ((alloc_flags & ALLOC_KSWAPD) &&
-	    unlikely(test_bit(ZONE_BOOSTED_WATERMARK, &zone->flags))) {
-		clear_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
-		wakeup_kswapd(zone, 0, 0, zone_idx(zone));
-	}
-
 	VM_BUG_ON_PAGE(page && bad_range(zone, page), page);
 	return page;
 }
@@ -4007,24 +3954,8 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 			return true;
 	}
 
-	if (__zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
-					free_pages))
-		return true;
-
-	/*
-	 * Ignore watermark boosting for __GFP_HIGH order-0 allocations
-	 * when checking the min watermark. The min watermark is the
-	 * point where boosting is ignored so that kswapd is woken up
-	 * when below the low watermark.
-	 */
-	if (unlikely(!order && (alloc_flags & ALLOC_MIN_RESERVE) && z->watermark_boost
-		&& ((alloc_flags & ALLOC_WMARK_MASK) == WMARK_MIN))) {
-		mark = z->_watermark[WMARK_MIN];
-		return __zone_watermark_ok(z, order, mark, highest_zoneidx,
-					alloc_flags, free_pages);
-	}
-
-	return false;
+	return __zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
+					free_pages);
 }
 
 #ifdef CONFIG_NUMA
@@ -6824,7 +6755,6 @@ static void __setup_per_zone_wmarks(void)
 			    mult_frac(zone_managed_pages(zone),
 				      watermark_scale_factor, 10000));
 
-		zone->watermark_boost = 0;
 		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_HIGH] = low_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_PROMO] = high_wmark_pages(zone) + tmp;
@@ -7092,14 +7022,6 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
 		.proc_handler	= min_free_kbytes_sysctl_handler,
 		.extra1		= SYSCTL_ZERO,
 	},
-	{
-		.procname	= "watermark_boost_factor",
-		.data		= &watermark_boost_factor,
-		.maxlen		= sizeof(watermark_boost_factor),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
 	{
 		.procname	= "watermark_scale_factor",
 		.data		= &watermark_scale_factor,
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 24078ac3e6bc..bbbbef5baed7 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -298,7 +298,6 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 		printk(KERN_CONT
 			"%s"
 			" free:%lukB"
-			" boost:%lukB"
 			" min:%lukB"
 			" low:%lukB"
 			" high:%lukB"
@@ -321,7 +320,6 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 			"\n",
 			zone->name,
 			K(zone_page_state(zone, NR_FREE_PAGES)),
-			K(zone->watermark_boost),
 			K(min_wmark_pages(zone)),
 			K(low_wmark_pages(zone)),
 			K(high_wmark_pages(zone)),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..879cea20dd57 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6725,30 +6725,6 @@ static void kswapd_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 	} while (memcg);
 }
 
-static bool pgdat_watermark_boosted(pg_data_t *pgdat, int highest_zoneidx)
-{
-	int i;
-	struct zone *zone;
-
-	/*
-	 * Check for watermark boosts top-down as the higher zones
-	 * are more likely to be boosted. Both watermarks and boosts
-	 * should not be checked at the same time as reclaim would
-	 * start prematurely when there is no boosting and a lower
-	 * zone is balanced.
-	 */
-	for (i = highest_zoneidx; i >= 0; i--) {
-		zone = pgdat->node_zones + i;
-		if (!managed_zone(zone))
-			continue;
-
-		if (zone->watermark_boost)
-			return true;
-	}
-
-	return false;
-}
-
 /*
  * Returns true if there is an eligible zone balanced for the request order
  * and highest_zoneidx
@@ -6953,14 +6929,13 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
 	unsigned long pflags;
-	unsigned long nr_boost_reclaim;
-	unsigned long zone_boosts[MAX_NR_ZONES] = { 0, };
-	bool boosted;
 	struct zone *zone;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.order = order,
 		.may_unmap = 1,
+		.may_writepage = 1,
+		.may_swap = 1,
 	};
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
@@ -6969,18 +6944,6 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 
 	count_vm_event(PAGEOUTRUN);
 
-	/*
-	 * Account for the reclaim boost. Note that the zone boost is left in
-	 * place so that parallel allocations that are near the watermark will
-	 * stall or direct reclaim until kswapd is finished.
-	 */
-	nr_boost_reclaim = 0;
-	for_each_managed_zone_pgdat(zone, pgdat, i, highest_zoneidx) {
-		nr_boost_reclaim += zone->watermark_boost;
-		zone_boosts[i] = zone->watermark_boost;
-	}
-	boosted = nr_boost_reclaim;
-
 restart:
 	set_reclaim_active(pgdat, highest_zoneidx);
 	sc.priority = DEF_PRIORITY;
@@ -7015,39 +6978,14 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		}
 
 		/*
-		 * If the pgdat is imbalanced then ignore boosting and preserve
-		 * the watermarks for a later time and restart. Note that the
-		 * zone watermarks will be still reset at the end of balancing
-		 * on the grounds that the normal reclaim should be enough to
-		 * re-evaluate if boosting is required when kswapd next wakes.
+		 * If there are no eligible zones, no work to do. Note that
+		 * sc.reclaim_idx is not used as buffer_heads_over_limit may
+		 * have adjusted it.
 		 */
 		balanced = pgdat_balanced(pgdat, sc.order, highest_zoneidx);
-		if (!balanced && nr_boost_reclaim) {
-			nr_boost_reclaim = 0;
-			goto restart;
-		}
-
-		/*
-		 * If boosting is not active then only reclaim if there are no
-		 * eligible zones. Note that sc.reclaim_idx is not used as
-		 * buffer_heads_over_limit may have adjusted it.
-		 */
-		if (!nr_boost_reclaim && balanced)
+		if (balanced)
 			goto out;
 
-		/* Limit the priority of boosting to avoid reclaim writeback */
-		if (nr_boost_reclaim && sc.priority == DEF_PRIORITY - 2)
-			raise_priority = false;
-
-		/*
-		 * Do not writeback or swap pages for boosted reclaim. The
-		 * intent is to relieve pressure not issue sub-optimal IO
-		 * from reclaim context. If no pages are reclaimed, the
-		 * reclaim will be aborted.
-		 */
-		sc.may_writepage = !nr_boost_reclaim;
-		sc.may_swap = !nr_boost_reclaim;
-
 		/*
 		 * Do some background aging, to give pages a chance to be
 		 * referenced before reclaiming. All pages are rotated
@@ -7091,15 +7029,6 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		 * progress in reclaiming pages
 		 */
 		nr_reclaimed = sc.nr_reclaimed - nr_reclaimed;
-		nr_boost_reclaim -= min(nr_boost_reclaim, nr_reclaimed);
-
-		/*
-		 * If reclaim made no progress for a boost, stop reclaim as
-		 * IO cannot be queued and it could be an infinite loop in
-		 * extreme circumstances.
-		 */
-		if (nr_boost_reclaim && !nr_reclaimed)
-			break;
 
 		if (raise_priority || !nr_reclaimed)
 			sc.priority--;
@@ -7115,12 +7044,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		goto restart;
 	}
 
-	/*
-	 * If the reclaim was boosted, we might still be far from the
-	 * watermark_high at this point. We need to avoid increasing the
-	 * failure count to prevent the kswapd thread from stopping.
-	 */
-	if (!sc.nr_reclaimed && !boosted) {
+	if (!sc.nr_reclaimed) {
 		int fail_cnt = atomic_inc_return(&pgdat->kswapd_failures);
 		/* kswapd context, low overhead to trace every failure */
 		trace_mm_vmscan_kswapd_reclaim_fail(pgdat->node_id, fail_cnt);
@@ -7129,28 +7053,6 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 out:
 	clear_reclaim_active(pgdat, highest_zoneidx);
 
-	/* If reclaim was boosted, account for the reclaim done in this pass */
-	if (boosted) {
-		unsigned long flags;
-
-		for (i = 0; i <= highest_zoneidx; i++) {
-			if (!zone_boosts[i])
-				continue;
-
-			/* Increments are under the zone lock */
-			zone = pgdat->node_zones + i;
-			spin_lock_irqsave(&zone->lock, flags);
-			zone->watermark_boost -= min(zone->watermark_boost, zone_boosts[i]);
-			spin_unlock_irqrestore(&zone->lock, flags);
-		}
-
-		/*
-		 * As there is now likely space, wakeup kcompact to defragment
-		 * pageblocks.
-		 */
-		wakeup_kcompactd(pgdat, pageblock_order, highest_zoneidx);
-	}
-
 	snapshot_refaults(NULL, pgdat);
 	__fs_reclaim_release(_THIS_IP_);
 	psi_memstall_leave(&pflags);
@@ -7384,8 +7286,7 @@ void wakeup_kswapd(struct zone *zone, gfp_t gfp_flags, int order,
 
 	/* Hopeless node, leave it to direct reclaim if possible */
 	if (kswapd_test_hopeless(pgdat) ||
-	    (pgdat_balanced(pgdat, order, highest_zoneidx) &&
-	     !pgdat_watermark_boosted(pgdat, highest_zoneidx))) {
+	    pgdat_balanced(pgdat, order, highest_zoneidx)) {
 		/*
 		 * There may be plenty of free memory available, but it's too
 		 * fragmented for high-order allocations.  Wake up kcompactd
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 7de08ab61b9d..32027b8c0526 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1776,7 +1776,6 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 	}
 	seq_printf(m,
 		   "\n  pages free     %lu"
-		   "\n        boost    %lu"
 		   "\n        min      %lu"
 		   "\n        low      %lu"
 		   "\n        high     %lu"
@@ -1786,7 +1785,6 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   "\n        managed  %lu"
 		   "\n        cma      %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
-		   zone->watermark_boost,
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
-- 
2.52.0


