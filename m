Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC65ACD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED326B00B2; Thu, 30 Apr 2026 16:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC2E6B00B6; Thu, 30 Apr 2026 16:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924686B00B3; Thu, 30 Apr 2026 16:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79A4C6B00B2
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44C12A0174
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:10 +0000 (UTC)
X-FDA: 84716346540.23.87C018C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9E0071C0004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=VyhSnC7b;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1A9xiCNihLUwlNd60E8mdH6UH8UfgnVbMP2lH0hzrk=;
	b=Ka6b9FPB2hKfEJWaIh6WvUarfa3AHlo1sZ7Qbr4kjB07LzGZrcytoq3EkJn9JFW5GMF6yC
	VhQL03fDGmwQejCXb05Q5BPnpnLlDNDbOzsg5rUNa29qL4M/MC2SXHoh6kYY4+qZCgchVI
	rc+WZlNnhn7uQjv+Jv6SEIz4Bn887+8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=VyhSnC7b;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580588; a=rsa-sha256;
	cv=none;
	b=HdCWJvrP0AeLP9b1cYD1BYXf4ISDS/QYKk6Sbwki2mhvCzCRdYgpxL46GLICKm0ho/gt1F
	VLR9whJS7PwD0MaJbyqJ/3WVprCTp4ExT5xgsrjIx2f1HQAcX7f3lteXbD6cPqclVvrlLH
	ZRx9MSA5mK2cJC0E9isEUPxbpgmYIIQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g1A9xiCNihLUwlNd60E8mdH6UH8UfgnVbMP2lH0hzrk=; b=VyhSnC7bRWnqxcUG9GmBdfkXhq
	HQJTwSkzd/ZHzq3Px+oXd2VjiXrPyjpFiYQVKWwOk3U1ocI8a0MtF4JbdkHOHGzaplAAPveE+Btne
	YlgQ44KHn1f2b6HoB0R8trlU4tHakopjb9qDphVAfs51VTJvMv3mh1rZIXwKVj+aLGIEA/8O0k5Jh
	QJsg6vK9oNkrRA/RWWrjVfAGGHSQpdXho2iTHjabY3iS7aHZzvTXWtS9hQGG6aPgRbfItqTqlWyTe
	bYLw6Tfb/CYdkKpU5giJ5XuIQCnUFMgOX2UVNdWFnJZcdvRFV0zlcNfFP/hu/I6f6n+kE4wd5od1X
	Np0+8C5Q==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-3uj4;
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
Subject: [RFC PATCH 21/45] mm: page_alloc: prefer reclaim over tainting clean superpageblocks
Date: Thu, 30 Apr 2026 16:20:50 -0400
Message-ID: <20260430202233.111010-22-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r69teknuorwd6fbgbf3a5aaygim9op1i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E0071C0004
X-Rspam-User: 
X-HE-Tag: 1777580588-92474
X-HE-Meta: U2FsdGVkX1+k+0boOlLfz2rNFRBldhDrwoX4eA20nV7j8pSz1qVv0GIZ8l1tZdE766Aybx/DZixhxfemmqKkXzV5qI35LMaiYHlCFO9IO8+6DyhttzdU7y71jyshPVmdrEqjyb+AbKNaEMLxFHTRn3KP/KpBwcpFkd8lSq1S42U7lcEHjk3d5uQqngi5K76FgDe2tTm/ZVXLFieuwQ+Rg7C0iOgB5P5uXfNzj4egV7cuBBlVWRtqfORQ/V9Q9oOimHAeldIwhoEwORyZBCSWI+5V4us2KF0SObJo2/gsQ3miL7/ZVX+lKLcdrIgBXwhXbjClLrVZEZg5PPHApvpVxy6F7gjAr9yRt9clFvlOB+yEokHTuQSqrO17jouxBj0pQFkPFCVa9JfNPmfZgNNrmi6nZxC5YMpWHUUndePxAMNIBaPW0wuIwbgpnpbDMV6p2JOSUzVwB2y8VPc6F9UcPqgl5mdNwLaMoi1htFFk6j0ZIsKWQbkI144YqzNdM/NMXFOUstmi5zFw6vKgtk2T3+KUiuZFZyQMewFyZVqjBbefhGjJorNAuGpakp2V5YpjzyTnsDJ5jpGooAn0zXlB5pCS6tm+wOPLYRZIdumXEtkM26kuqINxXNlKlERBtKjTUY8DM9QA9RHtrRsAkWyMMZVZ9tg1l9UOKQS3+zA49697vco3AI5HfueRBLoAqFBNW7TluDKlSIDB7ckOsUR7u7wo1n4aDooTSjtCSn/HO032dLJASZl9WkJFsp3D0H3cqPOqPWGDQV4dH1SHCZ2FdhZl8mwGkXH1uR60T+/pR9xGs3IqvoWTMuxPAgPcpir74KNE3bEz9UlN3mkytInd8tSLa/VmA7C3L7zh+WXREEWB7vw0D3JM8k257E5Ic1AK7Egi6K0a2ZTZ8bRa9ffdpXad8kzoxe7C8LK/8I39H9Y5vuxZCGEPNBOuC3zeh+2zKQr+sRe3VUpTuLSbrOR
 5EX61Uy2
 UbcpqLIyea5fsinvLx3yB7cZs0T4m/QQfUXTjfg/EawGYDRBUm26l9I1qXRdvCYJYn9cCbeRqF5GdUu2vDKlk7yJrO1Frl3jTg5YzFsWetGW1abt4dqVDqRkl2RtXZ7PHQX9rriuDqKBIzd1UkKe0aqdU9nL9yvK0CxmU2qUzRk8enposFXOSRrsvJHR+rBe4nzLQIfTKz4lqE0chhirt6p+UJ3YSmZiETZwVz4rNnp1MhDPn2SNqR7GL2DSZ1MzjU/3oJ8hDkxs7qXIkdQAM5csXQEzNhE4Vw33A8WVNqWQR3/I+pCg8YEdJu186tni6TJSNADHE36OwvE2tFiOYWOQbdOda61jOMWbvqufzJ/1EStL3s7guX9zDky3J7QDxhMFf7j0+hWXAJS3SG4QR8kaK+uBZ8BMA2BD1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

When the allocator needs pages for unmovable or reclaimable allocations
and tainted superpageblocks are exhausted, it currently falls through to
clean superpageblocks immediately, permanently tainting them. This
defeats the purpose of superpageblock anti-fragmentation.

Restructure the allocation fallback cascade to try reclaim and compaction
before tainting clean superpageblocks:

1. Reorder __rmqueue_smallest to search each preferred SPB completely
   before moving to the next source. Within each preferred SPB, try
   whole-pageblock allocations first (for PCP buddy optimization),
   then fall back to sub-pageblock allocations. This ensures that
   sub-pageblock free pages in existing tainted SPBs are used before
   tainting empty or clean SPBs. The pass order is:
   - Preferred SPBs: whole pageblock first, then sub-pageblock
   - Whole pageblock inline claim from tainted SPBs (non-movable only)
   - Whole pageblock from empty SPBs
   - Fallback to non-preferred SPBs

2. In get_page_from_freelist(), only drop ALLOC_NOFRAGMENT immediately
   for allocations that cannot do direct reclaim (atomic). Allocations
   that can reclaim keep ALLOC_NOFRAGMENT set and enter the slowpath,
   where reclaim and compaction can free pages in already-tainted SPBs.

3. Preserve ALLOC_NOFRAGMENT through the slowpath by calling
   alloc_flags_nofragment() after gfp_to_alloc_flags(). Previously
   the slowpath only set NOFRAGMENT for defrag_mode, losing the SPB
   protection that the fastpath established.

4. After reclaim and compaction have both been tried and failed, drop
   ALLOC_NOFRAGMENT unconditionally as a last resort before OOM.
   Previously this was gated on defrag_mode.

Testing shows that with this change, clean superpageblocks maintain
unmov=0 throughout a heavy mixed workload (swap pressure, filesystem
metadata, anonymous memory cycling, compaction, hugepage allocation),
where previously 2-3 additional SPBs would become tainted with 7-8
unmovable pageblocks each.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 74 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 13 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 215b7d6b95d2..8f925b5a2e5f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2764,11 +2764,23 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	 * concentrate non-movable allocations into fewer superpageblocks.
 	 * For movable, prefer clean superpageblocks to keep them homogeneous.
 	 *
-	 * Search empty superpageblocks between the preferred and fallback
-	 * category passes to avoid movable allocations consuming free
-	 * pageblocks in tainted superpageblocks (which unmovable needs for
-	 * future CLAIMs), and vice versa.
+	 * Prefer whole pageblock allocations (>= pageblock_order) over
+	 * sub-pageblock allocations because whole pageblocks enable the
+	 * PCP buddy optimization for fast subsequent allocations.
+	 *
+	 * Search order:
+	 * 1. Preferred SPBs: whole pageblock first, then sub-pageblock
+	 * 2. Whole pageblock inline claim from tainted SPBs (non-movable only)
+	 * 3. Whole pageblock from empty SPBs
+	 * 4. Fallback to non-preferred SPBs
+	 *
+	 * Pass 1 tries whole pageblock first for PCP buddy optimization,
+	 * then falls back to sub-pageblock within the same preferred SPBs.
+	 * This ensures we never taint empty/clean SPBs while preferred
+	 * SPBs still have free pages at any order.
 	 */
+
+	/* Pass 1: preferred SPBs — whole pageblock first, then sub-pageblock */
 	for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
 		enum sb_category cat = cat_order[movable][0];
 
@@ -2776,7 +2788,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 			&zone->spb_lists[cat][full], list) {
 			if (!sb->nr_free_pages)
 				continue;
-			for (current_order = order;
+			/* Try whole pageblock (or larger) first for PCP buddy */
+			for (current_order = max(order, pageblock_order);
 			     current_order < NR_PAGE_ORDERS;
 			     ++current_order) {
 				area = &sb->free_area[current_order];
@@ -2793,15 +2806,34 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					migratetype < MIGRATE_PCPTYPES);
 				return page;
 			}
+			/* Then try sub-pageblock (no PCP buddy) */
+			if (order < pageblock_order) {
+				for (current_order = order;
+				     current_order < pageblock_order;
+				     ++current_order) {
+					area = &sb->free_area[current_order];
+					page = get_page_from_free_area(
+						area, migratetype);
+					if (!page)
+						continue;
+					page_del_and_expand(zone, page,
+						order, current_order,
+						migratetype);
+					trace_mm_page_alloc_zone_locked(
+						page, order, migratetype,
+						pcp_allowed_order(order) &&
+						migratetype < MIGRATE_PCPTYPES);
+					return page;
+				}
+			}
 		}
 	}
 
 	/*
-	 * For non-movable allocations, try to reclaim free pageblocks
-	 * from tainted superpageblocks before looking at empty or clean
-	 * ones. Free pageblocks in tainted SBs have pages on the MOVABLE
-	 * free list (reset by mark_pageblock_free), so the search above
-	 * misses them. Claim them inline to keep non-movable allocations
+	 * Pass 2: for non-movable allocations, try to claim free pageblocks
+	 * from tainted superpageblocks. Free pageblocks in tainted SBs have
+	 * pages on the MOVABLE free list (reset by mark_pageblock_free), so
+	 * pass 1 misses them. Claim them inline to keep non-movable allocations
 	 * concentrated in already-tainted superpageblocks.
 	 *
 	 * Try whole pageblock orders first (preferred for PCP buddy optimization),
@@ -2879,7 +2911,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		}
 	}
 
-	/* Empty superpageblocks: try before falling back to non-preferred category */
+	/* Pass 3: whole pageblock from empty superpageblocks */
 	list_for_each_entry(sb, &zone->spb_empty, list) {
 		if (!sb->nr_free_pages)
 			continue;
@@ -6281,6 +6313,17 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (!zonelist_zone(ac->preferred_zoneref))
 		goto nopage;
 
+	/*
+	 * Preserve ALLOC_NOFRAGMENT through the slowpath so that reclaim
+	 * and compaction are tried before allowing clean superpageblocks
+	 * to be tainted. The fast path sets this via alloc_flags_nofragment()
+	 * but gfp_to_alloc_flags() only sets it for defrag_mode. Re-add it
+	 * here so the slowpath retries with NOFRAGMENT still protecting
+	 * clean SPBs until the last-resort drop below.
+	 */
+	alloc_flags |= alloc_flags_nofragment(
+				zonelist_zone(ac->preferred_zoneref), gfp_mask);
+
 	/*
 	 * Check for insane configurations where the cpuset doesn't contain
 	 * any suitable zone to satisfy the request - e.g. non-movable
@@ -6420,8 +6463,13 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 				&compaction_retries))
 		goto retry;
 
-	/* Reclaim/compaction failed to prevent the fallback */
-	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
+	/*
+	 * Reclaim and compaction have been tried but could not free enough
+	 * pages in already-tainted superpageblocks. Drop NOFRAGMENT as a
+	 * last resort to allow claiming from clean/empty SPBs and stealing
+	 * across migratetype boundaries. This is better than OOM-killing.
+	 */
+	if (alloc_flags & ALLOC_NOFRAGMENT) {
 		alloc_flags &= ~ALLOC_NOFRAGMENT;
 		goto retry;
 	}
-- 
2.52.0


