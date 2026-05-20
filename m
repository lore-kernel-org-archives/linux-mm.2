Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 529C8CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651E46B00A8; Wed, 20 May 2026 11:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B45A6B00A9; Wed, 20 May 2026 11:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAF16B00AA; Wed, 20 May 2026 11:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3686F6B00A8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5BACA03A3
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:52 +0000 (UTC)
X-FDA: 84788110344.19.0910A41
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7545C0012
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=VUMd8V68;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KnbjIHq5zc+FyT7SFjp3JWUrqZg3k8IbbEuFyeESKjg=;
	b=DqhQwd0QgXY8jdPR1zhsNnVOEb+HZTJ6WidY+tvjX/ZgpL0Lo6kadtfPF03Pmh6xgRGFMF
	kQbxjPAo9KRbiE34LmtwcIsvPZcZk8Y0CGQIFF1OqHtX2dxx48Yj+cNThEqOcBjLKRzCsA
	reMmqjWOrQ0YNN702nB58ypBcP3iysA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289251; a=rsa-sha256;
	cv=none;
	b=cSX8KjCpazb8GvFDdkGbpjjnsNg7iFrQe0wkjCbthOy4xRl9XVEEK9ZiycRYiHfaB3+u+1
	E6ugbK7XlQRjEI/8dyL5oxY9v8EJ0yAfj6ZU1WAF2Ratmah3Apgr/YldlcCgcAGUkgXZhP
	WTFHz42jjrbUTo/qWVJJ6cdnGJcxPug=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=VUMd8V68;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KnbjIHq5zc+FyT7SFjp3JWUrqZg3k8IbbEuFyeESKjg=; b=VUMd8V68HOoJFocIxrt6TVgYSL
	iMa9qJyEBDFu47Cf7UrNAam9P1eAFW0A/O5Ii4h++vjqKS/huRwYxPgSGxdvsgaYo5SgpvCqEwO1M
	peHVAy2BKixoXayXieZMo31UQNX+9l5U9U6lJ+DCQTqbXaZmjnh+DfzLNjayvRWrF72JeYpHetOwI
	a5BdvuLuiCUZ/JW2eObRBWKYEWdL8+2lwnnDI+VHeAI8qc6ElV8txlEXF9r+QGOcxT3yRSjhZt5sR
	yEv2mewCpFkuwuq+EmHni5qdfZg8Pv1Low/P2wQz4MvyDLG+KbayvuOUj989cRht84WnhoNC9yoOy
	LO/6CEoA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-0YZP;
	Wed, 20 May 2026 11:00:28 -0400
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
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 05/40] mm: page_alloc: remove watermark boost mechanism
Date: Wed, 20 May 2026 10:59:11 -0400
Message-ID: <20260520150018.2491267-6-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E7545C0012
X-Stat-Signature: j1ch8wnhtwmp9eydwy99wdduy4xiowz9
X-Rspam-User: 
X-HE-Tag: 1779289250-120016
X-HE-Meta: U2FsdGVkX18JrWiXCr8pBNK4ZhA+UvJr6dNZBRr2sdy4dbu4n3blZVogU5cMyRAEfHJZRf8pEvZMNus+n0GxHy+VcGIkcgXX0st4evIV+rRwyMod6PgHZM20XiOpNRgesEsgfoijwHLC4CaRhrPWnB/8bgdvqyb4Ozt9aWZvxviBA4cimQhjm9RUrfV08I+xUsrssf4Z2CTkCInzEoiaJ6gQBHbOF41MimET+OCPi3dXuMKBYUXXVcgdnUANf4jN834vopjBQ6alr6TPGSc7k1Jt03YWgT80G50mbmtTRSXnFE2+XZydH7lmsSXYuK9SZpy4AsiyGMP+ZizNcBT7ukKgaP/tdcnsKbEgEQeIQtGSd7Uq1oZAQd2WJbtgi+XxCoGX83LPUWTlwvv9Q52M5HzHHBP5eQgSWicuQsagMJOwLu85qW/U+xSvAoqoJKUC2c0RowycovSqrHDRDm4kdVCfBFGBr97POGqnVczwr29meIZgPb+KRH1NT7/uCv+3VixkjGUEI7V32BgDz6Y/3z3LT3OO3xxY8AgywMIUqKAt5MAcDFN6OcGHPI0+JO3/98hfMonHu80A5my6AS7UVQsVTZr8KO1CLYTR3neb6aSfbm3Qo8/ZRIg+YR+zvyertmNjEQOtS4xTr+rYIRcpxQnQxJFG3ZTQ6903Zefk4ooKSeYJufSMPhviohFUR+P/SuMcLXAi6jzhot291pOQbmgkcgHvtykQaXZ780TWsDYUAOAIhxPMEUMXz05i6uXIwfxVUy0yqXZ00XBOJvf6jwRCFaUGielVC3YPI736pbnioU6x2FmCAnPmezk3pj1u7JrnBGGyNb5LVw2tXwQJpENLA0hcqSnuBewlsajkZ9rHRPkRiTKGy8KL3bZeQPBd0Ix5yHEOzFr8ecTF81dfAoqKdzeoKpohgPlYGyjvc01y1+5NIMYSs5f4SKbpIHgun/JZlpHFcialJvpyXEu
 RLd3pBAh
 4E6IiqHqKSHktG8HVit9v586vdBk8sqi+urbiFhJUV3bBZya2LI8bCz7enzlcrCKML8WtbIYE3Cj9TgLg2mkQpMiZgOj56+iEn5N0tx/kCQTSaLSCBQF+UKDtD6hJHHHI862UpdyvMrmbCDkz9qimpI8rqT3LFqvGQmrVSviZtR72utQgb8Rr8j7OisrRdMPDIfH7yfdo8/r5n3UYY1xHBb3tgFKlbO2oPVKAIz/pSRqLYmtOEoHUiWHMmYRsAU96QvoUH5mBM5oGd74N+ZgAmNdyp0k852Nd3Lzw2gDyo1noNPbsWETEsb1raNrWGMJnXxAW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 732e4dd181b9..13e29b2ebb86 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -978,7 +978,6 @@ struct zone {
 
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long _watermark[NR_WMARK];
-	unsigned long watermark_boost;
 
 	unsigned long nr_reserved_highatomic;
 	unsigned long nr_free_highatomic;
@@ -1167,9 +1166,6 @@ enum pgdat_flags {
 };
 
 enum zone_flags {
-	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
-					 * Cleared when kswapd is woken.
-					 */
 	ZONE_RECLAIM_ACTIVE,		/* kswapd may be scanning the zone. */
 	ZONE_BELOW_HIGH,		/* zone is below high watermark. */
 };
@@ -1177,7 +1173,7 @@ enum zone_flags {
 static inline unsigned long wmark_pages(const struct zone *z,
 					enum zone_watermarks w)
 {
-	return z->_watermark[w] + z->watermark_boost;
+	return z->_watermark[w];
 }
 
 static inline unsigned long min_wmark_pages(const struct zone *z)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 47d314e77151..6e01e58aca54 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -267,7 +267,6 @@ const char * const migratetype_names[MIGRATE_TYPES] = {
 
 int min_free_kbytes = 1024;
 int user_min_free_kbytes = -1;
-static int watermark_boost_factor __read_mostly = 15000;
 static int watermark_scale_factor = 10;
 int defrag_mode;
 
@@ -2340,43 +2339,6 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
 
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
@@ -2477,14 +2439,6 @@ try_to_claim_block(struct zone *zone, struct page *page,
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
@@ -3839,13 +3793,6 @@ struct page *rmqueue(struct zone *preferred_zone,
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
@@ -4123,24 +4070,8 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
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
@@ -6919,7 +6850,6 @@ static void __setup_per_zone_wmarks(void)
 			    mult_frac(zone_managed_pages(zone),
 				      watermark_scale_factor, 10000));
 
-		zone->watermark_boost = 0;
 		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_HIGH] = low_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_PROMO] = high_wmark_pages(zone) + tmp;
@@ -7187,14 +7117,6 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
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
index 43aca5a2ac99..d08f1263480a 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -302,7 +302,6 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 		printk(KERN_CONT
 			"%s"
 			" free:%lukB"
-			" boost:%lukB"
 			" min:%lukB"
 			" low:%lukB"
 			" high:%lukB"
@@ -325,7 +324,6 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 			"\n",
 			zone->name,
 			K(zone_page_state(zone, NR_FREE_PAGES)),
-			K(zone->watermark_boost),
 			K(min_wmark_pages(zone)),
 			K(low_wmark_pages(zone)),
 			K(high_wmark_pages(zone)),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..461e70f9c9f0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6883,30 +6883,6 @@ static void kswapd_age_node(struct pglist_data *pgdat, struct scan_control *sc)
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
@@ -7111,14 +7087,13 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
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
@@ -7127,18 +7102,6 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 
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
@@ -7173,39 +7136,14 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
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
@@ -7249,15 +7187,6 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
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
@@ -7273,12 +7202,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
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
@@ -7287,28 +7211,6 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
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
@@ -7542,8 +7444,7 @@ void wakeup_kswapd(struct zone *zone, gfp_t gfp_flags, int order,
 
 	/* Hopeless node, leave it to direct reclaim if possible */
 	if (kswapd_test_hopeless(pgdat) ||
-	    (pgdat_balanced(pgdat, order, highest_zoneidx) &&
-	     !pgdat_watermark_boosted(pgdat, highest_zoneidx))) {
+	    pgdat_balanced(pgdat, order, highest_zoneidx)) {
 		/*
 		 * There may be plenty of free memory available, but it's too
 		 * fragmented for high-order allocations.  Wake up kcompactd
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..7b48b84287a7 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1769,7 +1769,6 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 	}
 	seq_printf(m,
 		   "\n  pages free     %lu"
-		   "\n        boost    %lu"
 		   "\n        min      %lu"
 		   "\n        low      %lu"
 		   "\n        high     %lu"
@@ -1779,7 +1778,6 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   "\n        managed  %lu"
 		   "\n        cma      %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
-		   zone->watermark_boost,
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
-- 
2.54.0


