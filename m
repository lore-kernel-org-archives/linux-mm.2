Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C274DCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A166B00B6; Wed, 20 May 2026 11:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1F16B00B7; Wed, 20 May 2026 11:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0E36B00B8; Wed, 20 May 2026 11:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27F156B00B6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B6A3F1A0353
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:00 +0000 (UTC)
X-FDA: 84788110680.09.ADC9C11
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2104BA000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=brf4iceO;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+Uw4FvKv/DMZzRr9dlauNErROj+6HFTPfymYFoRYco=;
	b=Kk/rV6OFz8Y2szNScCwBK/YauQPUIw+oXlzuMg3iJXK7FYsVfc4R8Y6FFX2ADBTtTW51vj
	YKqjoRaMg65aUF3ExFMHJAytCU18PXdUNV+V0IbLaLrWPK5xlX6rwyq40hZY1Vjn9fl0T9
	mbdng7s2hQyQ8bmGK3YruupdJ3aVs74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289259; a=rsa-sha256;
	cv=none;
	b=fAhsHP+fr0K4McCcYCr/lKRpIwj7aUh6li20t43C0AL1x1hy+xtl4Hi4vGbe5QOJGXf20n
	gSgsq6UXTstJ2lHTqZ/51yIDhNQRC51dsB2bObJobi616HNnIYNwWNqc4Bz4Lloq/pJkAS
	Yy4qyehHMkVJSwu1t2trcxCizkW3ktk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=brf4iceO;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=b+Uw4FvKv/DMZzRr9dlauNErROj+6HFTPfymYFoRYco=; b=brf4iceOt3injvroqoR/CYYfuQ
	vOf01R8yUWmIrUsL9n94ZBh7Sou30+aKSgBkeDJK4CxqGuzknTVFC7qZ1i4fjS3Ndt7/O4rOGWkVJ
	/kKtieczn/y2oYDH7CaI9TMtFcHB7MYgh5Y3CQ13gp0H3EayyFlHe97XK1q3opr63DWg8jjqjedDU
	ovDvRidBUfZw24X5uAZbP6vm8VIP8w7RbuSZPaLKzBEdMhFryHNswVtXiMy2nAswVsDWKWUv4UVJs
	N/VnI4mLXMuet4UOGZHxKAoi+iIwnhkS5SmlCPbHXrAFcqTU6/7KPr65AsA25793iOA27TRHlAwYS
	vqIzsAUg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-2SAa;
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
Subject: [RFC PATCH 20/40] mm: page_alloc: prefer reclaim over tainting clean superpageblocks
Date: Wed, 20 May 2026 10:59:26 -0400
Message-ID: <20260520150018.2491267-21-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2104BA000C
X-Rspamd-Server: rspam04
X-Stat-Signature: ufzcrsmb18txm63q48xb87so1kfq5ero
X-HE-Tag: 1779289258-138410
X-HE-Meta: U2FsdGVkX1+D4NPmQAWLv47tFgk7+Mmr4aXRirVynjd5Z7u6Yk2nEaG7Vbx97XF1an8RXbaHU0rJo/ZlJEGx0Oe5rZ/r6wWT2ycB4dcIqqbrkvwJrX8PlEWOZ/RWbmukKUTAvKqaOwh2GMSMytMtW165QxFMazIkeEBgToQHpZueonRA9QQoPQI1sVayZEe//QtePCDY2F/Y+HAIO0GvUGU+CSdHyUfSXHx7foskV8ahy6EGlloH5WWub4n1P7w5xZLBjYl6KXEK2r7/uDbKZrkINPYuLB6HYg3fmM2uxSmrsbdkvC043zJc4h276gi8Z33V6NP1MDsESLdg1SfzB2qTZv//AwSyL1h9Ak3axaGUdHlOt35l06kAsCl+od+Vn4TvEjPIHFlslYIByd3xa6wfXPMbJYLzcdi/gyL9POkfeh7GL3jJOMv1ZpNkgCfrmuyzjOQ9Ofn65smJnS4poNv15Oqx94BCSkx4uBVmg/TZxhN16Sa+8wRm9ymro2A8NcTPNJ7Ihugl3rKAiorTUGvgzfiAlv9yywhnfrFatrjK3FZrp3ywNimmhUgSe5MYNaKNbkEOgOkgfbf11tZLS/12Cmd7xhCnvjo7o1y/MX3F6GZiNo5nwcrzxckZbB0isfS13OyWYGAH8+pWXdqdmwEtRdcvVrluyyEN2NRSZGz07zN6CLb21E7Ko0/uYItLhp4OL9smfb+PGlPcL40evxCDXNzpPUo1WwH0upo8OihbIPdXvp8m8te3jjDOnBdCx2Rfn2Y3P0fR0+YPL5uodCju8EyjwsWNg4hwQPLMccGbkRdoVOnL8Tvpy6n76A974JAje4aC6sMrPPhh3L87iwCd3iugrC8YsomG6oprzJJAI3/ZhNwZ4+s0yArTQ9OOKDmCICEbcBsAYZ1l1k+5C6X5YLrJx4OcKcPfhpc5wXH+nNIeFuMrJs2U1VJ5TwMIt97+0KS8PVildpmfI4y
 P5ff8VPM
 8TErJ5rBOP07fGS1Oi6JdCEDXU6yCex0CCrRHz5bRuLNt57QDqZjR6ctgjh1nxNQhkGpkD5ETWE2ab4IVHxc13v9BAx+MxvVePHcR+knpQfhVGsfTMI+3o62xQd8USTiXamT+jXuRVMKMWxDHZsZKia16/McRI1eGlG4YYtMJDHRgAVs5XvbOpEh07Zs8rxrtAtLUtW7tmu9GJHapbBcVQWfCX1qoupBLTm+r5p0i9/TKOZxGxwqRrq1NBtByxkUT5wv78bHFj8X+Q15e9bP/dreplHkV7Sna01b938PJs/APIgemnbWhRGXSrUmjzxcUb3YY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

2. Preserve ALLOC_NOFRAGMENT through the slowpath by calling
   alloc_flags_nofragment() after gfp_to_alloc_flags(). Previously
   the slowpath only set NOFRAGMENT for defrag_mode, losing the SPB
   protection that the fastpath established.

3. After reclaim and compaction have both been tried and failed, drop
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
index 63151e99bd53..093be0d930c0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2781,11 +2781,23 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
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
+	/* Pass 1: preferred SPBs -- whole pageblock first, then sub-pageblock */
 	for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
 		enum sb_category cat = cat_order[movable][0];
 
@@ -2793,7 +2805,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 			&zone->spb_lists[cat][full], list) {
 			if (!sb->nr_free_pages)
 				continue;
-			for (current_order = order;
+			/* Try whole pageblock (or larger) first for PCP buddy */
+			for (current_order = max(order, pageblock_order);
 			     current_order < NR_PAGE_ORDERS;
 			     ++current_order) {
 				area = &sb->free_area[current_order];
@@ -2810,15 +2823,34 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
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
@@ -2896,7 +2928,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		}
 	}
 
-	/* Empty superpageblocks: try before falling back to non-preferred category */
+	/* Pass 3: whole pageblock from empty superpageblocks */
 	list_for_each_entry(sb, &zone->spb_empty, list) {
 		if (!sb->nr_free_pages)
 			continue;
@@ -6422,6 +6454,17 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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
@@ -6561,8 +6604,13 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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
2.54.0


