Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A4ECD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BFF86B0095; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023746B0098; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8FE96B0095; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD2AF6B0096
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7501712014B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:57 +0000 (UTC)
X-FDA: 84716345994.09.15AF044
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF55440003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LSHH5xXD;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t95jkgjtdoG7RS+EwSENqfqyNRQXMA6tpyzb09QD3W8=;
	b=2vjZA9bMb4lI/2xXMBtyKWqEAkqeIq0iHR4zRQoppjRZm6m6rBgfVANnZyW1Nr+2hQvBNe
	pH/+ww4De2ooyah9FgBCMv6WDpN6zxM71+6pkM9WVx8FrJQk5SeT0Xegu8WWLeq2mfoL4w
	JS+9YiQR8FtorTeab2aV3BJVGaSXATQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580575; a=rsa-sha256;
	cv=none;
	b=sbP5WvwjEMyCOe/ykf6g3bVEafZ0FNqlsrhOhpuOV6F2uqfmTD1M50f5zebm7Npj8m6oTF
	aBIGsCg7TtqEo62G81sxFY892QWzKl2OhUc8fNyw+M94Obwh2xc+uK4klJkeD0H0ZjazgP
	aotpadhg/szSQLttCH4jQ7HCJ2rrWu8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LSHH5xXD;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=t95jkgjtdoG7RS+EwSENqfqyNRQXMA6tpyzb09QD3W8=; b=LSHH5xXDfd1I3pGugNc/LyOD59
	ehFLDdP8ZQgsolVr3SMkMyI3eB0Jhz6emI/seBixVn6fxPzPGPgw5591y9BsX/ALYuHDGoI6h7QoF
	A3S44ifwLjCYmN9pl0GpIJdBf7JPapYhl7LeT1FtFgjv/kFKKa0ojddAbwzL4bPrwMZVsHczYHfUq
	uN3NoC4MRzzRmibPBhO1l6MdsCu8wxxLfTRixQp7ElujI56/TBl/WPyW/qFfqIW66vgD47NNsnabA
	yVjO55EZIOpa3BHwR4i0pysAssjzvs/FRVs4sjDybRQzUZMbkU/0e38wVmHhLrtTfoiI6X1DqwD5H
	J1mUcpyg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-3jZ7;
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
Subject: [RFC PATCH 19/45] mm: page_alloc: prevent atomic allocations from tainting clean SPBs
Date: Thu, 30 Apr 2026 16:20:48 -0400
Message-ID: <20260430202233.111010-20-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF55440003
X-Rspam-User: 
X-Stat-Signature: sigcpu1qqu6ginyrfsmua4uw11sfip36
X-HE-Tag: 1777580575-411275
X-HE-Meta: U2FsdGVkX18BVkMJnuuXtW2874YNH7rOQI6pVog5vU8VejykIKOFMbMZ18mRGje39uOGELSabCogVNG+XATJflUOioy+sKrarKyTLHM87S6n1K+adnf9ihmD982yDH3a28NSABYamyy3xHa2l6QtLROubEQAR7OxElwj1sO6dmFKk7Fo6WBGGiE0Tqx8yZFNT0AA4iZM7q9ruG0uy+GFUrX5VBBUWp42s8cvjFR2wFaaWvllRwP8TrI292H1krCEU62UMyd/rSBhD2NjBsPHjqS2NmzG2pbc+Uy05ijoOy0fRX0xcioA7M+9u/CW0r4QS2X+0HVHM7D5MSWXquIdeDI336FrpDu8Ce6PVFafFe15Bie1LEwtOBYUUwCc0ZwmpnN3rGc0dgR/ZxIz83x7JOT5Sad/tfYq0DuqC27HZVfF/6/hFpPdbePilmaDOWqvCYqCNAjobe9SukMX/RegXNsOAd6u5anX113E2vMTG7BE3/GXqhdb4046hKH2Gg8XtRsq4fQPqNBYRJLTD1+r40RcUFmBZSfFeyVT+Zu3l9roCS/44LdkwSskgEmY+HX9H5qe6BsjSMTykxD3NAUI8n31z0bwf83nozLZQdQHEMz9rh1pFb+x1NznwpPnmBDAlAt2Xz1ifHmeiRWgi2Sd5KfZOVnuQ4LHGzpoFGPWrZkH8TlCRw/Ki92A4+vHRx11C4hFkluoiwpVcGgb6spJMX7MDKI1093oVsiJprGWV0heNJ3iRSv3SojcwJ08tWyvQG/QL57c8eMq4pwSil98+yhOTBBNtriUpeodf3+ASfTRvx61C/IUqA5n48Y05mndwyQNZF2rmAIWF5521/jzt5fmx0laCSZMAT7SRE2GouCZplnvc0A/2a6ZFT3WR0zNbASv8m9jvV4Jv711K5jB6osE9rneY4luKUWHti6V557fDHFIkSsmMewRE//C/mSojLUeeYEGliQ3ozTv+c+
 3W9tWL1e
 azUgyD8FmC8iCW599ycdJZ5Mzm+rsqtX6NdF7txV3Zvegbui+c4oSFB1ZwXKjfX4ACfmvBbn1XftcfVfGDkFJgmmdLeDXORTAL6gExJzhpAm82RZ1G/BIVTnIodjghEnB1g+8oPyYQ9V9ZAYRdUaeHzozZaEjBu9jZiMOcGkg7S7Tnjq/nWceMounJN/CWfksvDZE/EwSalNhe7E7XUc78OwXTshp/i48QLMIMWG+NemxprTO8KlNHhraon8dZ88ZnAj42f9lo+jBUU+8so8drKUiYkPWfSBwA/csAWJPbGzivUAvtbFWI3Msnrs+X9zUfNpuwxYvkSmz5NgG3R1MOUoirQYvC8X51MocmKz2wazwluSXAMrWNdQi/xqtYOPsFNdE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Non-DIRECT_RECLAIM (atomic) allocations that fail with ALLOC_NOFRAGMENT
previously dropped the flag entirely and retried, allowing them to taint
clean superpageblocks. This was the primary source of taint spreading
observed on production systems.

Two changes to keep atomic allocations within tainted SPBs:

1. Extend Pass 2 in __rmqueue_smallest with a sub-pageblock phase (Pass
   2b). The original Pass 2 only finds whole free pageblocks (>= pageblock
   order) in tainted SPBs. Pass 2b searches for sub-pageblock-order free
   blocks and uses try_to_claim_block to claim the pageblock if it has
   enough compatible pages. This finds pages in tainted SPBs that have
   fragmented free space but no whole free pageblocks.

2. Add ALLOC_NOFRAG_TAINTED_OK intermediate flag. Instead of going
   directly from ALLOC_NOFRAGMENT to no protection, atomic allocations
   first try with ALLOC_NOFRAG_TAINTED_OK which allows __rmqueue_steal
   to search tainted SPBs only. Clean/empty SPBs remain protected. Only
   if steal from tainted SPBs also fails is ALLOC_NOFRAGMENT fully
   dropped as a last resort.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/internal.h   |  1 +
 mm/page_alloc.c | 87 +++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 81 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 02f1c7d36b85..f641795688af 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1413,6 +1413,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+#define ALLOC_NOFRAG_TAINTED_OK	0x1000 /* NOFRAGMENT, but allow steal from tainted SPBs */
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8ce96db50c2f..13bc57592cd5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2713,6 +2713,9 @@ static struct page *__rmqueue_from_sb(struct zone *zone, unsigned int order,
  */
 static struct page *claim_whole_block(struct zone *zone, struct page *page,
 		  int current_order, int order, int new_type, int old_type);
+static struct page *try_to_claim_block(struct zone *zone, struct page *page,
+		  int current_order, int order, int start_type,
+		  int block_type, unsigned int alloc_flags);
 
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
@@ -2782,6 +2785,11 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
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
@@ -2814,6 +2822,43 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
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
+						0);
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
@@ -3566,12 +3611,23 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
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
@@ -3581,7 +3637,7 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 		page = __rmqueue_sb_find_fallback(zone, current_order,
 					start_migratetype,
 					&fallback_mt,
-					SB_SEARCH_PREFERRED | SB_SEARCH_FALLBACK);
+					search_cats);
 
 		if (!page)
 			continue;
@@ -3681,8 +3737,10 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
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
@@ -5301,9 +5359,24 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
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
+	 */
+	if (no_fallback && !defrag_mode &&
+	    !(gfp_mask & __GFP_DIRECT_RECLAIM)) {
+		if (!(alloc_flags & ALLOC_NOFRAG_TAINTED_OK)) {
+			alloc_flags |= ALLOC_NOFRAG_TAINTED_OK;
+			goto retry;
+		}
+		alloc_flags &= ~(ALLOC_NOFRAGMENT | ALLOC_NOFRAG_TAINTED_OK);
 		goto retry;
 	}
 
-- 
2.52.0


