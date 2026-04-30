Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE1ECCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90AC6B00D8; Thu, 30 Apr 2026 16:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68176B00D9; Thu, 30 Apr 2026 16:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DAE6B00DB; Thu, 30 Apr 2026 16:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 870C06B00D8
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:31:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35D4E401C1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:31:33 +0000 (UTC)
X-FDA: 84716367666.26.D4D53AC
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf17.hostedemail.com (Postfix) with ESMTP id 77D8040006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:31:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=UgGUw6Bj;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777581091; a=rsa-sha256;
	cv=none;
	b=kHoZQ+LdpPrPWEmNfQoYAMvuzASIzc/E2CVXuBIf8i9kiPUNG5CjEqa6MCGPnFC9aB4MQl
	K7ky/6F2D8YLGV847I9ahcW7v+QXN+L2xguCM3l/V+nrcVgTcjcLBPMIO5NxMUBIrDlGfI
	gPZTdL9tJL8Qe3XCzDNJLALXFGPezsQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=UgGUw6Bj;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777581091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SkLLRBBEJdim0uzr+W128xpCHYKOeU1xiZdF4Xr45I=;
	b=EzZpJ2FZbbHhWKzcNUoxgVL6hb99Hnw7pt8ilSATa4m19u8PDm6/V8+oUGVyvrmfToVMbQ
	JqelTz2SjIqNiz9sogpnvMpvV4gvdlH/6HkBziOHXfk7sf9DrQYnZq/14R9aDDACbstn5X
	mqFnQW4PGkpTT5zqO5tRnCSkHiGzRLU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5SkLLRBBEJdim0uzr+W128xpCHYKOeU1xiZdF4Xr45I=; b=UgGUw6BjMFcx0xglkBfz1I+V91
	/XtQZWF1wBAO9UXo7pCAnme2k9kQp+l2kkzSytN5csrmWTGLbSoXQeVSpEYMzBkf81FjsQ6S90xKg
	Jutzez280+NHQ0UZExgWYLn37N7K3noPCg2jDoij8BAfgysMHL3WjkOvtkYAcaNSTPb+2KsL4baW4
	w9SSaHIQyVXyIAddrmymVD8Nf4EOYALLfAFF0LxkPSC78sdmAUrm8SwN4fdza5NRXdKR8991Pflcb
	EJOAC+KtUinh/CLlgNVszwna8oiG05ZfY0pLyB9jwDkHAxN47eulcUaCwsgjDMjfsqTtMPm6rh4us
	JeYC0djA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-279a;
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
Subject: [RFC PATCH 42/45] mm: page_alloc: cross-MOV borrow within tainted SPBs
Date: Thu, 30 Apr 2026 16:21:11 -0400
Message-ID: <20260430202233.111010-43-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dh1y3oa5xdoz3ww9fjzqrqky1eywj1mg
X-Rspam-User: 
X-Rspamd-Queue-Id: 77D8040006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777581091-214967
X-HE-Meta: U2FsdGVkX1/WJ/6ElR9mnsTV27Odu5K5NBszh3Rb+kboSAsRYbq0Ax8Fw4TbbZwwNFMgX3uu4LzSrs0mGdbO66T/QBEg7cWXFf+9/xN9nKT9ADDrB8AVugUFeX53UYmKUs6VVVLOaObHSBiQyYExicuMs9KDurdNxGj4zFpCCY8D2zVuN8w+ciG65DKj1o9v34BP8UK97bv3dklOsmBSx+iyosd89UyAPof4wuxns85Fw1c8AFPgf6i0zL52mfP8MBF0lbRA4MEn4nyN/Fyq7pQpXrN+HbFLNAEsmaYHA8FBswPZHtSrt+ummM4IZ5WIF6A5z0HtQCpHejwxi0+sS4lBQJxy9bYWKgKDIGm1QV6ApREQnQwT/R9YHll8BsHkP/Qw60jD3JjA2hHT0q+K1hEUeeFvSwrXeBVOS6d7Fi6sOGLAOkXWWMR5y3aVIhFzItWby6Y25dcT5I5RpGH/4ml/RFR8jVQYVqGxh9Z0RWe/weBNAJAFrTykZEOGOMPxw1SpTXMv/l3fdGEDSsu2O6Z9UraTxZjCeySmRGyM0htX8P6qQm8YiqqORlkwRcia4UME260yhK5ZGgDdhnqwiGG1wJsXndB6Cs26azhP3KYxT+VknKpmu9mNVwJ+611/V2UeVu6wACJ5Oh+DNm4B/DW1dIcKh/b2Yr2t4qz1UXZ8/g640FItBornNUqLsCJxOj8Icj8kB0BJVqcK6en9bhXvhVTflDV/wYIgIy78tzCX+fjh4FOqYk3k4aIXduoybfIv+/3L2hEXRQKeN/iUl6Wo+LsEPJTwRqhLQuyFhLMKYEDVAEEzzpa1W+WMySMwC04IebqTaLm8P0GPI6e7iiRGM+Lx4+QDRfSME1prC1mSJmVcvOiRYCl9MWc4R8+41nJF+5clpKhfC9YSxvyX/Rnm07ZIk3ABi24EuQFni2dyH7OI2dK0RrCdGclOQ0Wnr4qEnEcnfC2xyC0wcjW
 jcIPDtQ4
 CoTiHl/F99mP6CRRq0wl/eLzwP6wxBwieVNyXbkgNloeda2/UP/XkqD/NQFjlUSdcm9Hzb/qIbYamEYcrURzdd5ONpS+chHetUcx2BuZYAZnck677ro4XhItu0cZwO/KwvUBJg7820Nw3v2eTekHE4tfY/J9b1QszcKJcZyHZTHurDHlYyBEW/OBWT9gDWy8wcPCGl9bad2vihyj8KM3KtiwE2s/4pQfbiGyHkk1uhsWu15pHOlLY9uw18XReFyDqE4/Ousmjec9qDVzHDE/z14uvm052XRbGxz+tnIa2iCI5WjN+KL6+LFcWIuE6lEeZ7alYFGHatxlzaRoA9V6+yOxK9vcJ3HrBKWqOMQq1IgReo6HjdCASViREwLE+JGeaxV+xAuh/E04BTcF/zb8i8a1myxwB5/MJOzWu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Pass 2c (cross-non-movable borrow) is restricted to UNMOV<->RECL: it
borrows individual buddies from the opposite non-movable migratetype's
free list within a tainted SPB without relabeling the source pageblock.
Movable free pages within tainted SPBs are deliberately excluded
because long-lived non-movable content in a MOV-tagged pageblock
blocks compaction of that pageblock.

Under workloads that mostly free MOVABLE-tagged content into tainted
SPBs (page-cache reclaim, anon LRU shrink), the result is a tainted
SPB with tens to hundreds of thousands of free pages all on the MOV
free list — invisible to non-movable demand. Pass 1 doesn't see them
(they're not on the requesting mt's list), Pass 2/2b can't claim a
whole pageblock when sb->nr_free == 0 (no contiguous free PB to
relabel), and Pass 2c skips MOV. The non-movable alloc falls through
to Pass 3 and taints a fresh clean SPB even though the existing
tainted ones have plenty of unused space.

Add Pass 2d, mirroring Pass 2c semantics but borrowing from the
MOVABLE free list within already-tainted SPBs. The borrowed page is
used for the requesting non-movable mt for the lifetime of the
allocation, then on free returns to the MOVABLE list (no pageblock
relabel; same "borrow" mechanism as 2c).

Tradeoff: the borrowed UNMOV/RECL content blocks compaction of its
source pageblock until the alloc is freed. Restricted to SB_TAINTED
so contamination is bounded to one pageblock inside an already-
tainted SPB. The alternative — Pass 3 tainting a fresh clean SPB —
removes a 1 GiB region from the clean pool, which is strictly worse
for the anti-fragmentation invariant the series is built around.

Skipped for movable allocs (they use Pass 4) and CMA allocs.

Observable as the new SPB_ALLOC_OUTCOME_PASS_2D outcome on the
spb_alloc_walk tracepoint. Expected effect on the live workload:
tainted SPB count growth slows substantially; allocations that were
previously taking the PASS_3 escape now succeed in PASS_2D.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2f5d3ba1c0ef..af499f0a1a48 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3280,6 +3280,79 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				}
 			}
 		}
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
+						if (spb_below_shrink_high_water(sb))
+							queue_spb_slab_shrink(zone);
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
2.52.0


