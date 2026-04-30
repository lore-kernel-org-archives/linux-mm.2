Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3709CD13DF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CDD6B00B6; Thu, 30 Apr 2026 16:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099346B00BC; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF43F6B00B6; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC2486B00BC
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BF6FC0309
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:09 +0000 (UTC)
X-FDA: 84716346498.15.502AA80
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id C97C74000C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=PxiTcEIi;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaDHek0ivxTXx9Tc/FlMyuw1qhdH9eLa9J/Mna+BFx8=;
	b=BeaU8TUCxwt8b4U+0F48OYj66apDBVEQjgq8iAAmLhYcDd+SrGgXOUPlB0RLV+HAozW7tC
	J8cDQ6NbBBlIS+gqlCHER8s5ExGPoyY52UX6Mi89AXhOcvxG6Uf/z5/5DniADHpGxrhQoX
	DywzyZARd2V6sJjbwmDPyfF5H0/lDXs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=PxiTcEIi;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580587; a=rsa-sha256;
	cv=none;
	b=2rfWDgNLhLGzicognbxL+Cp3Oo2fdQpmL81JXA10IrrarRurU7uDmNtjk9bDjWdpUS72wF
	9qdUJ2IAqg0Ked24NK5WDLprPmDgPfT9iRTcfKC61SMSgQMnQbrFBaf8e5FC/Q3YGgYyL0
	4pqQCvOdcarnEsk8gOIEG3mIN+dKKqQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iaDHek0ivxTXx9Tc/FlMyuw1qhdH9eLa9J/Mna+BFx8=; b=PxiTcEIiRpjgsy0mKgg6gyi/VK
	UvLwm91w3kwZLywU5admQ+6MAb55w4tcDg1obsVwf4rZ8xH/aKoSMcY2XMc6GZwXG8yOHjO9cA6x+
	lGp9fFbMKF1CU82fIB+H0JtN9su14N76NA6WN3jx+L1UCS7GOv4TT/rjPxHqhv75aw0expC7CLmrV
	R7TNIUMURgS1rgvSoDqMIjvglASEJkIK0fKZJyzpaVVquE1FmLkYbkXqYAdSA5qz4IVGk2S3rGuxM
	UeCbRsBmgDcrl6XWpnpfxuY7dlv/mw6cEwlkniVSe3UvGIi84H2X26apGYuejvV8NhMOW+Mk4flEp
	zQISuTOw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-1AAw;
	Thu, 30 Apr 2026 16:22:41 -0400
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
Subject: [RFC PATCH 32/45] mm: page_alloc: proactive high-water trigger for SPB slab shrink
Date: Thu, 30 Apr 2026 16:21:01 -0400
Message-ID: <20260430202233.111010-33-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C97C74000C
X-Rspam-User: 
X-Stat-Signature: wpi1ip6mtatu3e3e71jcchd9ichisdpr
X-HE-Tag: 1777580587-948032
X-HE-Meta: U2FsdGVkX1+joX049ahkJfYpXe0f8dKqJ0BMBLSBoYqOsXPwXsUY1mgc9pV+AM3fUm0JUK02b4ftUljbK95eaJ9utCmuuO0N6OH6abnUO5y2hm2p0eanJmRlR9AzhvgQC/q5DkIfevSJMDMRofLr7V3A3/H8MeCpf9kAeVlzfq7ZsdrIuZ8LGaMMACfptqICsoI9JD21BeLjP+P42O/uzwypEUK8rcsjWfRZpX4qGf23ivtz3N58tpjk32YWu/47Mus1jFVnZz6B8/yGGJoZrt5ZEVnzRcFmNYis+UiUcKQhHFzUaNCPhIiuhTO74jr2+lizIb144ExkU9kVdEwtdNsUcFiWryhuKC9cS5164C9aBbpPC5D3NEeDgkbVdcHS8odG35IhHMaogKLVw3YVwBk9tL4HkKHZea3oTwKWEtw8+iwYW//29dPoPQ49zOixO3nPZtwi1yean8V/s3V28Sxb5i8nEZvzGJLNIAJs02A0tJDfCZIAutuomATeKQMkYW6FhxD8P+QSTxKsnzOq96Iv84UGZb0JhY5nlCS0E4Bf6SoAeuAkARU4aXlzIlj5mglkFo1RusdOBQESKFTmxQGYU6RRrW7t3CN2qPPRrBjdWRGktXMm5bmD0ma6rtpX/GpT7Qv/JpbSDCVMtit2PCfLFyLff1oVFNPfDAQFqRm8SIb8LCRPKENfeYMOS4k6BltHQ8SVSjkhv0gq6xONDb9bN/3yqIoVI7jEq9CkX+60MDlaZFYUxToLuOK1fXQJfoxQyFGNDpSWMLp1M/akMbWq8EF7CeO2CClUxt7CUJ2t22hJ4PAoCy0AxeRDr7iC6pqgaB0ADY9KuYsrI5mKQ9sRFVPPljBv09OWs5txvJjpTIDpv6X9zVSbGIpqzIS4NgRb6L9luZSBwY/lSUz2Mrzs5I25zYHAEbIF1oYEhnVVs19ZyzNQ5vM99k6gPhKiKaBv5/djHuWKRxEtMDO
 2tsQavGH
 WhgX8LvmPNmlL8efUq6aXwTi+hqdcDdUg8Mva06pZwXbdNPYzrLX+lV/bxa6Phgbn3Fh8YYEwJeKWO7yNO15eS6QaPN90jNCHwWDKLsDgCQlXc31InBsRKOXZIvzy85SUNgzYDaGqDQONRJk7qz20EtVK4naEJLmnLNZhR9yEeyf0oLwTwTpKWpPPiastzF2RlQNnTkC5FhDZ3u7oMwaK2HKZbXu7DCXWLoGq+UUttdjclYZtw+sdmSr7JyUhCCyQ8DuFdHz0JYvZ+I12OMT4qgItWFexnwB9uRoxWEjjEsWBUju+6l4HkeKzU1KDdxZawWEj+Utqbpdek2pf9oDKObfEYMD0I1FSX1VjaVtfk8AUNFa+YGQpi8asYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

The SPB slab shrinker introduced earlier in the series only fires when
__rmqueue_smallest falls all the way through to Pass 3 (about to taint
a clean SPB) or when __rmqueue_claim is about to taint one. Bare-metal
testing on a 247 GB devvm with btrfs root (rev 398, with Pass 2c) shows
this is too late: at boot+16min only 15 shrinks had fired in 6 minutes
while slab grew from 1.7 GB to 11.7 GB and tainted Normal-zone SPBs
climbed from 4 baseline to 16. The 100ms throttle (max 10 shrinks/sec
per pgdat) further capped the response rate, and the trigger placement
meant slab pressure could keep absorbing into already-tainted SPBs
without ever firing the shrinker until those SPBs were exhausted — at
which point the only remaining option is to taint a fresh clean SPB.

Two changes:

1. Add a proactive high-water trigger on the success paths of
   __rmqueue_smallest's tainted-SPB passes (Pass 1 SB_TAINTED, Pass 2,
   Pass 2b, Pass 2c). When a non-movable allocation consumes from a
   tainted SPB whose nr_free_pages has fallen below spb_tainted_reserve
   worth of pages (reserve_pageblocks * pageblock_nr_pages), queue a
   slab shrink. The predicate compares total free pages rather than
   whole free pageblocks (nr_free): sub-pageblock allocations and
   fragmented free space don't move the pageblock count but do consume
   the SPB's freeable capacity, and we can't assume slab reclaim will
   produce whole pageblocks either. This makes the trigger frequency
   proportional to the rate of non-movable consumption from contended
   tainted SPBs, instead of firing only at the cliff edge.

2. Remove the 100ms time-based throttle from queue_spb_slab_shrink.
   The throttle was redundant with queue_work()'s built-in single-flight
   semantics (returns false if the work is already queued/running) and
   was actively harmful: with the new high-water trigger firing per
   allocation, the natural rate-limiter is the worker's runtime. The
   previously-allocated spb_slab_shrink_last field is removed from
   pglist_data.

queue_work() absorbs the resulting per-alloc burst at near-zero cost
(test-and-set on WORK_STRUCT_PENDING_BIT) when a pass is already in
flight, so unconditional firing on every qualifying allocation is
cheap.

Pass 4 (movable falling back to tainted) does not get the trigger:
movable consumption does not contribute to the slab pressure that taints
fresh SPBs, and Pass 4 already filters out SBs at or below reserve.
Clean-SPB success paths in Pass 1 are also untouched (clean SPBs are
not the source of the pressure).

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |  7 +++---
 mm/page_alloc.c        | 48 ++++++++++++++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index acaff292140f..68892e40cd4e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1573,12 +1573,11 @@ typedef struct pglist_data {
 
 	/*
 	 * SPB-driven slab reclaim: single work item per pgdat (shrink_slab
-	 * is node-scoped, so one work in-flight per node is the max), with
-	 * a 100ms throttle. queue_work() gives us single-flight semantics
-	 * for free.
+	 * is node-scoped, so one work in-flight per node is the max).
+	 * queue_work() gives us single-flight semantics for free — fresh
+	 * triggers no-op while a pass is in progress.
 	 */
 	struct work_struct spb_slab_shrink_work;
-	unsigned long spb_slab_shrink_last;
 #endif
 	/*
 	 * This is a per-node reserve of pages that are not available
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f2db3dd86a84..ff7755ef2b79 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2692,6 +2692,23 @@ static inline u16 spb_tainted_reserve(const struct superpageblock *sb)
 	return max_t(u16, SPB_TAINTED_RESERVE_MIN, sb->total_pageblocks / 32);
 }
 
+/*
+ * High-water threshold for proactively kicking the slab shrinker. When a
+ * non-movable allocation consumes from a tainted SPB whose total free
+ * pages have fallen below spb_tainted_reserve worth of pages, queue a
+ * shrink so we start freeing slab memory before the SPB is exhausted.
+ *
+ * Compared against nr_free_pages rather than nr_free (whole pageblocks):
+ * sub-pageblock allocations and fragmented free space don't move the
+ * pageblock count, but they do consume the SPB's freeable capacity, and
+ * we can't assume slab reclaim will produce whole pageblocks either.
+ */
+static inline bool spb_below_shrink_high_water(const struct superpageblock *sb)
+{
+	return sb->nr_free_pages <
+		(unsigned long)spb_tainted_reserve(sb) * pageblock_nr_pages;
+}
+
 /*
  * On systems with many superpageblocks, we can afford to "write off"
  * tainted superpageblocks by aggressively packing unmovable/reclaimable
@@ -2877,6 +2894,9 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				page_del_and_expand(zone, page,
 					order, current_order,
 					migratetype);
+				if (cat == SB_TAINTED &&
+				    spb_below_shrink_high_water(sb))
+					queue_spb_slab_shrink(zone);
 				trace_mm_page_alloc_zone_locked(
 					page, order, migratetype,
 					pcp_allowed_order(order) &&
@@ -2896,6 +2916,9 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					page_del_and_expand(zone, page,
 						order, current_order,
 						migratetype);
+					if (cat == SB_TAINTED &&
+					    spb_below_shrink_high_water(sb))
+						queue_spb_slab_shrink(zone);
 					trace_mm_page_alloc_zone_locked(
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
@@ -2941,6 +2964,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					page = claim_whole_block(zone, page,
 						current_order, order,
 						migratetype, MIGRATE_MOVABLE);
+					if (spb_below_shrink_high_water(sb))
+						queue_spb_slab_shrink(zone);
 					trace_mm_page_alloc_zone_locked(
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
@@ -2978,6 +3003,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						0, true);
 					if (!page)
 						continue;
+					if (spb_below_shrink_high_water(sb))
+						queue_spb_slab_shrink(zone);
 					trace_mm_page_alloc_zone_locked(
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
@@ -3061,6 +3088,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 							opposite_mt);
 						__spb_set_has_type(page,
 							migratetype);
+						if (spb_below_shrink_high_water(sb))
+							queue_spb_slab_shrink(zone);
 						trace_mm_page_alloc_zone_locked(
 							page, order, migratetype,
 							pcp_allowed_order(order) &&
@@ -9126,9 +9155,9 @@ static void queue_spb_evacuate(struct zone *zone, unsigned int order,
  * tainted SPB is to shrink the slab caches whose pages live there.
  *
  * shrink_slab() is node-scoped, so one work item per pgdat is enough:
- * a single embedded work_struct, gated by a 100ms throttle.
- * queue_work() returns false if the work is already queued/running, so
- * we get single-flight for free.
+ * a single embedded work_struct. queue_work() returns false if the work
+ * is already queued/running, so we get single-flight for free — fresh
+ * triggers no-op until the in-flight pass completes.
  *
  * shrink_slab() itself is location-agnostic — it walks all registered
  * shrinkers and frees objects whose backing pages may live in any
@@ -9189,10 +9218,11 @@ static void spb_slab_shrink_work_fn(struct work_struct *work)
  * queue_spb_slab_shrink - schedule deferred slab shrink for SPB pressure
  * @zone: zone whose tainted-SPB pool is running low
  *
- * Throttled to one enqueue per 100ms per pgdat. queue_work() handles
- * single-flight: if the work is already queued or running, it returns
- * false and the throttle stamp still gets bumped (next call will be
- * no-op until the throttle elapses).
+ * Single-flight via queue_work(): if the work is already queued or
+ * running, it returns false and we no-op. There is no time-based
+ * throttle — the rate at which fresh shrink runs can fire is bounded
+ * by how fast the worker completes (one full pass freeing up to
+ * SPB_SLAB_SHRINK_TARGET_OBJS objects).
  *
  * Callable from any context: page allocator paths hold zone->lock,
  * the SPB evacuate worker does not. queue_work() takes only the
@@ -9212,10 +9242,6 @@ static void queue_spb_slab_shrink(struct zone *zone)
 	if (!pgdat->evacuate_wq)
 		return;
 
-	if (time_before(jiffies, pgdat->spb_slab_shrink_last + HZ / 10))
-		return;
-
-	pgdat->spb_slab_shrink_last = jiffies;
 	if (queue_work(pgdat->evacuate_wq, &pgdat->spb_slab_shrink_work))
 		count_vm_event(SPB_SLAB_SHRINK_QUEUED);
 }
-- 
2.52.0


