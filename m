Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF3F7CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCA36B00EF; Wed, 20 May 2026 11:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F976B00F1; Wed, 20 May 2026 11:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E279E6B00EF; Wed, 20 May 2026 11:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC146B00EF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:11:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F3861A0347
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:11:36 +0000 (UTC)
X-FDA: 84788137392.08.3E5E509
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0046940016
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:11:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=GSdjivBQ;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oR+Qcf2D3se1DFkmwZrR9GIoGiGN/MvwrIeUwpMAxpY=;
	b=wsugQUVqtZIvf34/ZJZFYuxTs+Ch5ZnwemxeMABNlPHPg9hSekQuyAAm2X8ZdLKySQx/cg
	fYXIButvsfqnkLofkSTNM+Om707HkYhPyPE8LGwawNr2j/g05mNZpCjydlqkgT+eHdvAAx
	flPgMAxndpSsRjg4N9NfvCwRUuN//4Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=GSdjivBQ;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289895; a=rsa-sha256;
	cv=none;
	b=FMpL7KeKwbGAYKPGO63IvVS8zNcYZ1dS0nRUF9C5pFPxBlwB0DwBaFuOA3myNBl7df5/j5
	V4NRIx+yCCquvwRJ+pF0lP4YznnBPrXEcldjDHuW8Ep57Bxo8S73AX8XQcWbCIusCce8ZZ
	TWHdQbSTwlVj2BoBWs/yQ1C1orKI2xc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oR+Qcf2D3se1DFkmwZrR9GIoGiGN/MvwrIeUwpMAxpY=; b=GSdjivBQyu9RnwdzSA7o+upiVM
	7ULQxOYtTYARmik6vKgdaNpz1WP4vMNeKWyrgp8OSTWOiCp/hdgH9CHTRrCIFkK9cckQGw/X0oJDd
	Zg2L44EERWJyw2E8DYPhhqvKTSk6zH2qBh07ayFzABtjCTsxp30w4ThUoiFFylNbwnWRqKFjBvI/1
	36h27iLInG1+0UmkzxvQtfYOhE356aAuAS6EsD8pvP6W8jeWz9xC+q6fjH2Ij0Hnk112ZxmaVSc3t
	voNmuqqSe+LlPljZysRA2BznlLjE57GFWqYVMOY06+J+IhBkYpTpYn9uKbhaooHB5lOJspVC12Mjc
	ck2VGXhw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-2CqZ;
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
Subject: [RFC PATCH 18/40] mm: page_alloc: prevent atomic allocations from tainting clean SPBs
Date: Wed, 20 May 2026 10:59:24 -0400
Message-ID: <20260520150018.2491267-19-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0046940016
X-Rspam-User: 
X-Stat-Signature: soddqrm1jhmj3qwabgq4z959tfhna8yz
X-HE-Tag: 1779289894-631239
X-HE-Meta: U2FsdGVkX19NTXProzH3J/h1hgLkl2+gWW4CftBaZxOcvgvWljp+nlCcJXqRG2SVSof6TgnE4PawhloaNaBronQfut8xveAU+RqzmfNe4aP3e+nmEK2dW0d0S6h7asuICvRNPIuisZNQXpsV4/8Dv53E6DlSNspvs1Yh3wIIrUjlIdBud1D/gmeGv2M51bohLRlNLQljTeaJ3lCjvVNYRSzwww+cjauhYmc396BuSCrxe20Ux/Ed9jebe04V3SCW9KwGsH0TmTDmDhNLRB2+9Kfd4GMvYOdNHJUWk4UaGjxIHvruMSl28WWHpHLvQCBrTEw3D6Byif8HaJxQ8NeVz9UGVb9W/QjBx9N3xNCmlDG6mCgaMNPLMDNT0XGkn2DWWBuuaEf+vpAdHUcIdtr/7NB/0MwZV8qkGe1FMcViZXQLNUCXocfsvwtUcXKW9h6o/t/mn85tn1qhNgVqJG7TNPyhk3vWIeAs3Y3w8vhfpxBLsi0Ln1SR55h24wFBcq69KWlLMsG/y3xju4ALQ5HM/K66bz0bDekfw7GcdfNIjitKLGETLfk3vD9sN5Kmkf4r8jSYNF4JvxrvkbdIv8MDdU5DFg4RokYLfuItCow4UrRQ/xhYn4P8m1G4lTTJJbmLrtS0aS+kuOjKtOa2GVGXth2C60irC5FfpNmL482PoLtth+adz4PaXdtYqgh4fl/2ZTKKG1jZGqApiQ4KC/a7y38faIgnRFbIJ5RBATpaFQIcQx8/6y51Nm/+deSyjr7Ph4txJnYJp2bmQtXMYIAfnEyXLvWh3Nh2LSx/KbwLKC2kBp1iRj+awhMjyZDPAp5v9C3iRCQ9KGP+r0RZeRmjOxDT1LAV6H7k0DKuPvw7iFBGN9DHFFiBS+sN6RfHEULMaInqcoFVkv6HX/8bg9Ly84+O9rJlFTePav9aOahmSMTJ5zKIX9ERwOdZchn0RcSXJn3xfsrfF/JXdrJUU5y
 cSlpNO33
 1dAuokztyx0LagJC2WuQrREHEiCBUCCLGxCqSOnDt3GRv6Swn1aQoXg45YaHQG4/jdPIeJudL551NIqHRyNyZ7BwGp50+zjwCmBtYybga2Ku+R38G3htPM+3Ju8+WeEvCdigZnKODCiyJSd2NTpCIuNvHMLz4dSdwK6tw205uJrJJiRSijrzpJlel6EV4EXGHshNgq6u1ikMAefHzHhEiqTXgkJTNsxM2GyB5P9Ri8ZyR8xvgVv2xIU39NFazjdIDhB38K+WLuzuUfwTIJtcvUtJqaA1ZZt06cuHlXkSCDBM5nNkHdZpujhsTrgcTdAtII3ze
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Non-DIRECT_RECLAIM (atomic) allocations that fail with
ALLOC_NOFRAGMENT previously dropped the flag entirely and retried,
allowing them to taint clean superpageblocks.  This was the primary
source of taint spreading observed on production systems.

Stage the relaxation in three steps that keep atomic allocations
inside tainted SPBs as long as possible:

1. Extend Pass 2 in __rmqueue_smallest with a sub-pageblock phase
   (Pass 2b).  Pass 2 only finds whole free pageblocks (>= pageblock
   order) in tainted SPBs.  Pass 2b searches for sub-pageblock-order
   free blocks and uses try_to_claim_block() to claim a pageblock
   that has enough compatible pages.  This finds pages in tainted
   SPBs that have fragmented free space but no whole free pageblocks.

2. Add an ALLOC_NOFRAG_TAINTED_OK intermediate flag.  Instead of
   going directly from ALLOC_NOFRAGMENT to no protection, atomic
   allocations first retry with ALLOC_NOFRAG_TAINTED_OK, which
   allows __rmqueue_steal to search tainted SPBs only.  Clean and
   empty SPBs remain protected.  Only if steal from tainted SPBs
   also fails is ALLOC_NOFRAGMENT fully dropped as a last resort.

3. Bypass the pageblock compatibility threshold inside
   try_to_claim_block() when the call originates from the
   tainted-SPB walk in Pass 2b.  The
   free_pages + alike_pages >= 1 << (pageblock_order - 1) gate was
   designed to prevent the cross-fragment-fallback path from
   spreading mixing into clean SPBs; inside an already-tainted SPB
   the fragmentation has already been accepted, and the threshold
   rejects the typical fragmented-MOVABLE-pageblock case Pass 2b is
   meant to reclaim.  Without the bypass Pass 2b would be largely a
   no-op.

For callers that pass __GFP_NORETRY, the relaxation sequence is
wrong in principle.  The NORETRY contract is "I have a fallback;
don't go to extreme lengths."  Network skb_page_frag_refill, slab
high-order allocations, and similar hot-path callers use NORETRY
exactly so the allocator can return NULL and let their own fallback
(smaller frag, lower-order slab, etc.) take over.  Tainting a clean
superpageblock to satisfy such a request is a lasting cost -- the
SPB stays tainted for the remainder of the workload's lifetime,
blocking 1 GiB hugepage allocation from that region -- that
outlives the single allocation that triggered it.  Skip the
relaxation steps for NORETRY callers and return NULL immediately;
their fallback path absorbs the failure cleanly.

Observed on a 250 GB system running the page-superblock series:
an atomic order-3 alloc from swapper context (PCP refill,
gfp=0x152820 = __GFP_HIGH | __GFP_KSWAPD_RECLAIM | __GFP_NOWARN |
__GFP_NORETRY | __GFP_COMP | __GFP_HARDWALL) tainted a fresh clean
SPB at boot+~90 min despite ALLOC_NOFRAGMENT being set, because
the atomic-retry path stripped the flag.  The caller had a NORETRY
fallback ready; the taint was gratuitous.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/internal.h   |   1 +
 mm/page_alloc.c | 120 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 110 insertions(+), 11 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index c0dbc2e4b7f0..e6d61dbc18d9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1511,6 +1511,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+#define ALLOC_NOFRAG_TAINTED_OK	0x1000 /* NOFRAGMENT, but allow steal from tainted SPBs */
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b6a07bd72c0b..6884f638a97c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2729,6 +2729,10 @@ static struct page *__rmqueue_from_sb(struct zone *zone, unsigned int order,
  */
 static struct page *claim_whole_block(struct zone *zone, struct page *page,
 		  int current_order, int order, int new_type, int old_type);
+static struct page *try_to_claim_block(struct zone *zone, struct page *page,
+		  int current_order, int order, int start_type,
+		  int block_type, unsigned int alloc_flags,
+		  bool from_tainted_spb);
 
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
@@ -2798,6 +2802,11 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	 * free list (reset by mark_pageblock_free), so the search above
 	 * misses them. Claim them inline to keep non-movable allocations
 	 * concentrated in already-tainted superpageblocks.
+	 *
+	 * Try whole pageblock orders first (preferred for PCP buddy optimization),
+	 * then fall back to sub-pageblock orders. Sub-pageblock claiming uses
+	 * try_to_claim_block which checks whether the pageblock has enough
+	 * compatible pages to justify claiming it.
 	 */
 	if (!movable && !is_migrate_cma(migratetype)) {
 		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
@@ -2830,6 +2839,43 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				}
 			}
 		}
+		/* Pass 2b: sub-pageblock orders in tainted SPBs */
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			list_for_each_entry(sb,
+				&zone->spb_lists[SB_TAINTED][full], list) {
+				int co;
+
+				if (!sb->nr_free_pages)
+					continue;
+				for (co = min_t(int, pageblock_order - 1,
+						NR_PAGE_ORDERS - 1);
+				     co >= (int)order;
+				     --co) {
+					current_order = co;
+					area = &sb->free_area[current_order];
+					page = get_page_from_free_area(
+						area, MIGRATE_MOVABLE);
+					if (!page)
+						continue;
+					if (get_pageblock_isolate(page))
+						continue;
+					if (is_migrate_cma(
+					    get_pageblock_migratetype(page)))
+						continue;
+					page = try_to_claim_block(zone, page,
+						current_order, order,
+						migratetype, MIGRATE_MOVABLE,
+						0, true);
+					if (!page)
+						continue;
+					trace_mm_page_alloc_zone_locked(
+						page, order, migratetype,
+						pcp_allowed_order(order) &&
+						migratetype < MIGRATE_PCPTYPES);
+					return page;
+				}
+			}
+		}
 	}
 
 	/* Empty superpageblocks: try before falling back to non-preferred category */
@@ -3298,11 +3344,17 @@ claim_whole_block(struct zone *zone, struct page *page,
  * not, we check the pageblock for constituent pages; if at least half of the
  * pages are free or compatible, we can still claim the whole block, so pages
  * freed in the future will be put on the correct free list.
+ *
+ * @from_tainted_spb: caller has already verified the block lives in a tainted
+ * superpageblock, where SPB-level fragmentation has already been accepted.
+ * Skip the per-pageblock compatibility threshold so we can absorb non-movable
+ * demand into the existing tainted SPB instead of tainting a fresh clean one.
  */
 static struct page *
 try_to_claim_block(struct zone *zone, struct page *page,
 		   int current_order, int order, int start_type,
-		   int block_type, unsigned int alloc_flags)
+		   int block_type, unsigned int alloc_flags,
+		   bool from_tainted_spb)
 {
 	int free_pages, movable_pages, alike_pages;
 	unsigned long start_pfn;
@@ -3362,8 +3414,14 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	/*
 	 * If a sufficient number of pages in the block are either free or of
 	 * compatible migratability as our allocation, claim the whole block.
-	 */
-	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
+	 * The compatibility threshold protects clean MOVABLE pageblocks from
+	 * being relabeled when most of their pages are still in-use movable
+	 * allocations. Inside a tainted SPB the protection is unnecessary:
+	 * fragmentation has already been accepted at the SPB level, and
+	 * relabeling is much cheaper than tainting a fresh clean SPB.
+	 */
+	if (from_tainted_spb ||
+	    free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled) {
 		__move_freepages_block(zone, start_pfn, block_type, start_type);
 		set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
@@ -3565,7 +3623,8 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 
 			page = try_to_claim_block(zone, page, current_order,
 						  order, start_migratetype,
-						  fallback_mt, alloc_flags);
+						  fallback_mt, alloc_flags,
+						  false);
 			if (page) {
 				trace_mm_page_alloc_extfrag(page, order,
 					current_order, start_migratetype,
@@ -3583,12 +3642,23 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
  * the block as its current migratetype, potentially causing fragmentation.
  */
 static __always_inline struct page *
-__rmqueue_steal(struct zone *zone, int order, int start_migratetype)
+__rmqueue_steal(struct zone *zone, int order, int start_migratetype,
+		unsigned int alloc_flags)
 {
 	struct superpageblock *sb;
 	int current_order;
 	struct page *page;
 	int fallback_mt;
+	unsigned int search_cats;
+
+	/*
+	 * When ALLOC_NOFRAG_TAINTED_OK is set, only steal from tainted
+	 * SPBs to avoid tainting clean ones. Otherwise search all categories.
+	 */
+	if (alloc_flags & ALLOC_NOFRAG_TAINTED_OK)
+		search_cats = SB_SEARCH_PREFERRED;
+	else
+		search_cats = SB_SEARCH_PREFERRED | SB_SEARCH_FALLBACK;
 
 	/*
 	 * Search per-superpageblock free lists for fallback migratetypes.
@@ -3598,7 +3668,7 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 		page = __rmqueue_sb_find_fallback(zone, current_order,
 					start_migratetype,
 					&fallback_mt,
-					SB_SEARCH_PREFERRED | SB_SEARCH_FALLBACK);
+					search_cats);
 
 		if (!page)
 			continue;
@@ -3698,8 +3768,10 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 		}
 		fallthrough;
 	case RMQUEUE_STEAL:
-		if (!(alloc_flags & ALLOC_NOFRAGMENT)) {
-			page = __rmqueue_steal(zone, order, migratetype);
+		if (!(alloc_flags & ALLOC_NOFRAGMENT) ||
+		    (alloc_flags & ALLOC_NOFRAG_TAINTED_OK)) {
+			page = __rmqueue_steal(zone, order, migratetype,
+					       alloc_flags);
 			if (page) {
 				*mode = RMQUEUE_STEAL;
 				return page;
@@ -5408,9 +5480,35 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	/*
 	 * It's possible on a UMA machine to get through all zones that are
 	 * fragmented. If avoiding fragmentation, reset and try again.
-	 */
-	if (no_fallback && !defrag_mode) {
-		alloc_flags &= ~ALLOC_NOFRAGMENT;
+	 *
+	 * For allocations that can do direct reclaim, keep NOFRAGMENT set
+	 * and let the slowpath try reclaim and compaction to free pages in
+	 * already-tainted superpageblocks before allowing clean SPBs to be
+	 * tainted.
+	 *
+	 * Atomic allocations cannot reclaim, but try an intermediate step
+	 * first: allow steal/claim from tainted SPBs only. This avoids
+	 * tainting clean SPBs while still finding pages in tainted ones.
+	 * Only drop NOFRAGMENT entirely if that also fails.
+	 *
+	 * Exception: callers that explicitly opted into failure with
+	 * __GFP_NORETRY have a fallback path of their own (a smaller
+	 * order, a different cache, returning NULL from a best-effort
+	 * cache refill, etc.). Tainting a clean superpageblock is a
+	 * lasting cost that outlives this allocation; it is not justified
+	 * to absorb it just to satisfy a caller that already has a
+	 * cheaper escape hatch. Return NULL and let the caller's fallback
+	 * run instead.
+	 */
+	if (no_fallback && !defrag_mode &&
+	    !(gfp_mask & __GFP_DIRECT_RECLAIM)) {
+		if (gfp_mask & __GFP_NORETRY)
+			return NULL;
+		if (!(alloc_flags & ALLOC_NOFRAG_TAINTED_OK)) {
+			alloc_flags |= ALLOC_NOFRAG_TAINTED_OK;
+			goto retry;
+		}
+		alloc_flags &= ~(ALLOC_NOFRAGMENT | ALLOC_NOFRAG_TAINTED_OK);
 		goto retry;
 	}
 
-- 
2.54.0


