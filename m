Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8694CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282616B00BA; Wed, 20 May 2026 11:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BDD16B00BB; Wed, 20 May 2026 11:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037AA6B00BD; Wed, 20 May 2026 11:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E46A66B00BA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86C1B160AD4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:03 +0000 (UTC)
X-FDA: 84788110806.10.7011EF7
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5559920013
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="l/gkW9W6";
	spf=pass (imf31.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEdP7NoP36KTb44zc6aIOMe8hvnM+eOFVJfuIoIwnjw=;
	b=y8AJvHJkHPKi5s7s2wfN3fX5ypNYHwHWCDQpmS2q5/VvvJWPzE87lilSc8BeAoF6VvROMD
	lYG0rbhK70eH5Kd4+q6KET+v+WbveHUS0lNtP9F4D+klKsZm5L0hX7B6661uhzWfQ6v42d
	55XaYEYFS6UoC790GL3V0bdHUrvtpRE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="l/gkW9W6";
	spf=pass (imf31.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289261; a=rsa-sha256;
	cv=none;
	b=h7D1UKnhIirMZ8NtNJ0aHdl7L4Bp8pBEEgnwk6TXFBxPD8T7Zj7rjqpL/AR/xHWgKmbJIQ
	4mET2Gr4Gyjajz2Lkwm3UydxccGd5qxQ5SwA9oHFBYppNGxiGSOv/9JC9Ywd4kz0jVXyfZ
	HJ1tZDNcrwpaPb6ECoJm1nwfQYF8svA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EEdP7NoP36KTb44zc6aIOMe8hvnM+eOFVJfuIoIwnjw=; b=l/gkW9W67R9khRVnsUcUIkfZFs
	elpeejPCQcer+Dm8sGdBEHkuTlufAtjMCMIP7K+cRckWkcUOlxy9OXxiNKSbu7ZcsxxxV6Gdu7E9X
	zOtup70nJ+gsHbCCr6hV7QuwmcjBr5cZ3tAgbRKi7Jh1jDvgJlPtXECteABmdA4njIKRFaH96nO8b
	ZAEGCIOdQmHqldq4yk3Pl9SF0M/eLBeNl2uuKZVmWt4Qzq5qyr7iE7KlOvcENaltH+N5Y8++kLH8j
	MH9kJW3C7U7fawx9W1pYwwESxsGiCsBvBTSRPJ40XjWO69wHDTUKzT2n7Der0aIkjqgm6pMCBD2YR
	fxwmMWNw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-3LUf;
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
Subject: [RFC PATCH 27/40] mm: page_alloc: cross-migratetype buddy borrow within tainted SPBs
Date: Wed, 20 May 2026 10:59:33 -0400
Message-ID: <20260520150018.2491267-28-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5559920013
X-Stat-Signature: raw8yxbzrrrwrforjszabr5xjpk9tw4o
X-HE-Tag: 1779289260-392596
X-HE-Meta: U2FsdGVkX18uzrvnt5kDy5GmLx0HkeMtIvo0cGCe/sjttTU9IydM45sFw0O+AeuQc0QewmbJ/JKEzJyvfSXMxcQIVdjEWr0Ib7Sk/2gkLrmT0bd71GjKf1p7dnh8F00flz//ZxUz+IWkW/q/MCS+8IAb92kkZkN9ZWzJL654+T9+BaAqrT/PCh20F1A1sDYNMF55+3iPzh9HDuFJMzYM02M9aYDJ7EDt9VPXFS2j5ND+3mRThDME+WIvAWhe00q/LmlyhAH6ncQooauaxQ6ngFuQUqAnT5nWkHRKNbVFZbwxHpoj4zOLVpElLE4kVpAFZemkiTmVd03+YaOf+PyQnpRoCSDrGpbTHi1SsJ/Zr5wyQby1oOHJWJ2JnnQ8QofY+SQ3Z6r7J0KhWLgekUEpy32Zt6yBDzD/DighXqlmjBk39zWGKYLQqqAIAFp2Hwlvwzp047FTy67xfZbah5i6a0gU4iAbDznMeFIaUVJ1rqzuUX8JDlAPTPQW1N6eAcESRy7fQwKp3dUF+ighG+ErVI3eIDPTPRHfRocjNRX/o8+ILTa2w320D2N1uExY8xb3GGQzoD9ddW6UVDs+FDLiNrt3qKPXgZ0KqaAva28a1l+6dhvuS5AVejb1wfVJyEOJUL2WWfDfDr02zaZKuuNrQophBnum0PnnJS14PrdMpSzW9OketCUFDdYvUMyRl0Ci8Pk/HErcssNM6Cug6H4KQcsY2ghepbTl8+ngrolm9kmkw0sRYy1Q/JLr9iaP/NLGVnDO+FiS0ERKpVxxOjJeCjp9k+f0hjacLb+/z5/5aRQ3WqBL8kvE6NYZwUsILsJsd8/DmbR9gWB2acGrGGsg20KvPpheErKWWuuqqENPmcogzq4OVQhUHdHTX/CW7kARejQWBMAzESQQaAaz7iOmhyju4hA7kZkWxCagBIk/3mSIM20sxEGjHJVFksdjwgqSmYQXUrDUOncVvi3QXOi
 33Fcq403
 REC/UUtbMbCbRXBXPLLBSmU5qFYVdEiH8p3SJuGIH2hFya3J8BXg0v67HeljmmLm7HGBKtN1ShoSX9KhXINuYg4ZOswhFjRa00Vm7Al1kPuj8aFxWqFL+RAeUI+NEC+mfO4bcM0U9UsOpNg75FBKsBvn79X4jwhZ5ydR4kkKpmVg+4IWaHFJn7zP7UIvFtlUZ5ZZrg4qlQACblOnixRsONhtNNjY7ziSx+9+1x2jhHRJA0wCXEvjBb9MT6f++dqB4IR47Beo2CZWtM4jzTSlkCJHycIvzUVoQYpFLfnQdUImQqN7n822UOf14reQb07RUpn3WxQLq742eDm2DUEricrlMLtQN9oidJODW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When pages are freed via __free_one_page they're placed on the
per-SPB free_list determined by their pageblock's migratetype, not
the original allocation's migratetype.  Slab-heavy and cache-heavy
workloads both expose structural mismatches that leave non-movable
allocations stranded:

  - RECLAIMABLE pageblocks fill up densely with live slab objects
    (e.g. btrfs_inode caches), leaving very few sub-pageblock free
    fragments on the RECL free list.
  - UNMOVABLE pageblocks accumulate sparse free space from vmalloc
    and raw-alloc churn -- tens of thousands of free pages, all
    on the UNMOV free list.
  - MOVABLE-tagged pageblocks in tainted SPBs absorb freed
    page-cache and anon-LRU pages, accumulating large pools all on
    the MOVABLE free list -- invisible to non-movable demand even
    though the tainted SPB has plenty of unused space.

Add two new passes between Pass 2b and Pass 3 of __rmqueue_smallest,
both restricted to SB_TAINTED (clean SPBs must not be polluted with
cross-type mixing) and both purely transient borrows (no pageblock
relabel; the borrowed page returns to its source list when freed):

  Pass 2c -- cross-non-movable borrow.  UNMOV alloc tries the
  RECL free list; RECL alloc tries the UNMOV free list.  Restricted
  to UNMOV <-> RECL.

  Pass 2d -- cross-MOV borrow.  Non-movable alloc tries the
  MOVABLE free list of a tainted SPB.  Tradeoff: the borrowed
  UNMOV/RECL content blocks compaction of its source pageblock
  until freed; restricted to SB_TAINTED so contamination is bounded
  to one pageblock inside an already-tainted SPB.  The alternative
  -- Pass 3 tainting a fresh clean SPB -- removes a 1 GiB region
  from the clean pool, which is strictly worse for the anti-
  fragmentation invariant the series is built around.

PB_has_<requested_type> is set via __spb_set_has_type so spb_defrag
accounting reflects that the pageblock now hosts our type's
content.  PB_has_<source_type> stays set since other buddies of
that type remain.

Movable allocations don't participate (they have Pass 4) and CMA
is skipped.  Observable as SPB_ALLOC_OUTCOME_PASS_2C and
SPB_ALLOC_OUTCOME_PASS_2D on the spb_alloc_walk tracepoint.

Live measurement on a 250 GB system with btrfs root
(Stage 1 + simplified Stage 2a) at boot+7min: 12 tainted Normal-
zone SPBs grew from 4 baseline despite the existing 11 having
between 825 and 87,062 free pages each, ALL on the UNMOV list
while the workload kept allocating RECL btrfs_inode slab pages.
Pass 2c lets those allocs absorb into the existing UNMOV-listed
free pool rather than creating fresh tainted SPBs; Pass 2d
extends the same idea to the MOV-listed free pool that page-
cache reclaim leaves behind.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 156 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e4ecddb428c3..ce8cd99dd283 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2820,6 +2820,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	struct page *page;
 	int full;
 	struct superpageblock *sb;
+	int opposite_mt;
 	/*
 	 * Category search order: 2 passes.
 	 * Movable: clean first, then tainted (pack into clean SBs).
@@ -2999,6 +3000,161 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				}
 			}
 		}
+
+		/*
+		 * Pass 2c: cross-non-movable borrow within tainted SPBs.
+		 *
+		 * If we're a non-movable alloc and Pass 1/2/2b couldn't find a
+		 * buddy on our migratetype's free list anywhere, but tainted
+		 * SPBs have free buddies on the *opposite* non-movable type's
+		 * free list, take one of those.
+		 *
+		 * Why this happens: when pages are freed, __free_one_page puts
+		 * them on the free_list determined by their pageblock's tag,
+		 * not the original allocation's migratetype. Slab caches tend
+		 * to be dense (RECL pageblocks fill up; few sub-PB fragments),
+		 * while UNMOV pageblocks accumulate sparse free space from
+		 * vmalloc/raw alloc churn. Net effect: tainted SPBs frequently
+		 * have tens of thousands of free pages all on the UNMOV list,
+		 * invisible to RECL allocs (or vice versa). Without this pass,
+		 * the alloc falls through to Pass 3 and taints a fresh clean
+		 * SPB even though the existing tainted ones have plenty of
+		 * unused space.
+		 *
+		 * We do NOT relabel the source pageblock. The buddy is taken
+		 * from @opposite_mt's free list and the splits go back on
+		 * @opposite_mt's list (page_del_and_expand uses the same mt
+		 * for delete and expand). The pageblock tag is unchanged, so
+		 * the page returns to @opposite_mt's list when freed via
+		 * __free_one_page. Effectively a borrow: the alloc takes a
+		 * physical page from a UNMOV-tagged pageblock for a RECL
+		 * use, and the page cycles back to UNMOV's list on free.
+		 *
+		 * We do set PB_has_<migratetype> via __spb_set_has_type so
+		 * spb_defrag accounting reflects that this pageblock now hosts
+		 * our migratetype's content too. PB_has_<opposite_mt> stays
+		 * set since other buddies of that type remain.
+		 *
+		 * Restricted to UNMOV ↔ RECL. Movable allocations don't
+		 * participate (they have their own Pass 4 fallback path).
+		 *
+		 * Restricted to SB_TAINTED to avoid spreading mixing into
+		 * clean SPBs.
+		 */
+		opposite_mt = -1;
+		if (migratetype == MIGRATE_UNMOVABLE)
+			opposite_mt = MIGRATE_RECLAIMABLE;
+		else if (migratetype == MIGRATE_RECLAIMABLE)
+			opposite_mt = MIGRATE_UNMOVABLE;
+
+		if (opposite_mt >= 0) {
+			for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+				list_for_each_entry(sb,
+					&zone->spb_lists[SB_TAINTED][full], list) {
+					int co;
+
+					if (!sb->nr_free_pages)
+						continue;
+					for (co = min_t(int, pageblock_order - 1,
+							NR_PAGE_ORDERS - 1);
+					     co >= (int)order;
+					     --co) {
+						current_order = co;
+						area = &sb->free_area[current_order];
+						page = get_page_from_free_area(
+							area, opposite_mt);
+						if (!page)
+							continue;
+						if (get_pageblock_isolate(page))
+							continue;
+						if (is_migrate_cma(
+						    get_pageblock_migratetype(page)))
+							continue;
+						page_del_and_expand(zone, page,
+							order, current_order,
+							opposite_mt);
+						__spb_set_has_type(page,
+							migratetype);
+						trace_mm_page_alloc_zone_locked(
+							page, order, migratetype,
+							pcp_allowed_order(order) &&
+							migratetype < MIGRATE_PCPTYPES);
+						return page;
+					}
+				}
+			}
+		}
+
+		/*
+		 * Pass 2d: cross-MOV borrow within tainted SPBs.
+		 *
+		 * If Pass 1/2/2b/2c all failed, the next step is Pass 3
+		 * which would taint a fresh clean SPB. Before that, try
+		 * to borrow an individual buddy from a tainted SPB's
+		 * MIGRATE_MOVABLE free list.
+		 *
+		 * Tainted SPBs accumulate large amounts of free space on
+		 * the MOV free list (e.g. reclaimed page-cache pages
+		 * whose pageblock tag is MOVABLE). Pass 1 cannot see
+		 * those for non-movable allocs, Pass 2/2b cannot claim a
+		 * whole pageblock when sb->nr_free == 0, and Pass 2c is
+		 * restricted to UNMOV<->RECL. The result is a tainted
+		 * SPB with tens to hundreds of thousands of free pages
+		 * all unreachable from non-movable demand.
+		 *
+		 * Borrow semantics mirror Pass 2c: take a buddy from the
+		 * MOVABLE free list without relabeling the source
+		 * pageblock. The page is used for the requesting non-
+		 * movable mt for the lifetime of the allocation, then on
+		 * free returns to the MOVABLE list.
+		 *
+		 * Cost: the borrowed UNMOV/RECL content blocks
+		 * compaction of its source pageblock until freed.
+		 * Restricted to SB_TAINTED so the contamination is
+		 * bounded to an already-tainted SPB; the alternative
+		 * (Pass 3) taints a fresh clean SPB and removes a 1 GiB
+		 * region from the clean pool, which is strictly worse.
+		 *
+		 * Skipped for movable allocs (they have Pass 4) and for
+		 * CMA allocs.
+		 */
+		if (!movable && !is_migrate_cma(migratetype)) {
+			for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+				list_for_each_entry(sb,
+					&zone->spb_lists[SB_TAINTED][full], list) {
+					int co;
+
+					if (!sb->nr_free_pages)
+						continue;
+					for (co = min_t(int, pageblock_order - 1,
+							NR_PAGE_ORDERS - 1);
+					     co >= (int)order;
+					     --co) {
+						current_order = co;
+						area = &sb->free_area[current_order];
+						page = get_page_from_free_area(
+							area, MIGRATE_MOVABLE);
+						if (!page)
+							continue;
+						if (get_pageblock_isolate(page))
+							continue;
+						if (is_migrate_cma(
+						    get_pageblock_migratetype(page)))
+							continue;
+						page_del_and_expand(zone, page,
+							order, current_order,
+							MIGRATE_MOVABLE);
+						__spb_set_has_type(page,
+							migratetype);
+						trace_mm_page_alloc_zone_locked(
+							page, order, migratetype,
+							pcp_allowed_order(order) &&
+							migratetype < MIGRATE_PCPTYPES);
+						return page;
+					}
+				}
+			}
+		}
 	}
 
 	/*
-- 
2.54.0


