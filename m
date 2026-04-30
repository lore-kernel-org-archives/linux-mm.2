Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85310CD13DF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D9C6B00AB; Thu, 30 Apr 2026 16:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0B36B00AA; Thu, 30 Apr 2026 16:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09536B00AC; Thu, 30 Apr 2026 16:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABFF66B00AB
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 61DFE40197
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:07 +0000 (UTC)
X-FDA: 84716346414.21.090CB3A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6A7324000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=cUQ1szzO;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4Zye7STkkMo2HD39nW35YeTAwT+eEQUHaKLcLVr+Lo=;
	b=ZlgNJGrRNzTSH35A6RpwKC0+Nj2HVZf/59xQYqd9FUz6tfcAv13yED4k2HFc3V+CG1Alvk
	j6P+anq+czHPzCNdZBasPp8+KyXkBShOudjSNw0UAe2gAkfaBML9zoCGVvzMxwpmDJvphD
	+vGkIVfV2Pbo6KoRGfz+Cs2vJqf7xQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580585; a=rsa-sha256;
	cv=none;
	b=LZkouP4VoUHlTzaVXuf58HArFaU4uiTdGI6uFGskx2o0y67eT1D2Gpv7ieZc/jFVnYcV+W
	DT3OpFh97q1hdVKPp1fAujy8hPJVkTO6AQp222cSB8pgk/DpXkkccxjo8I2yzYjBj+JSSB
	tbsu25DUl3UwdRrdYVFvC8oTItvqGG0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=cUQ1szzO;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g4Zye7STkkMo2HD39nW35YeTAwT+eEQUHaKLcLVr+Lo=; b=cUQ1szzOqb+QTeaExA6M9yn2gT
	RRRzI/geg9es5l6ZpHo/AlPEIEut0FqTBD8dzmJCLg9LCYtEnWj9muHbUOY9eycfU16B2x2AZQiXF
	3eKW8+bfZXcgC+psAc5SQp4kE41t2HdiTOPoLmQO10Ptmv7mT5oMgttl/+Djj5XULxfoEK5i2CWfP
	o84BGYZBipH4Cw8VBwxbWCVUba2YReTdnKQBsS1ba5jru6c2v2zcjTnVNv5IRro/e3gGrDKThM0bt
	Djtzx6zhPeUSNauFg0Y8hfpy5MuB0eTd8O+I1JsOuZQLDwDLCDaCRoytuAcX2zyV31ETRx87ZrW/x
	FuTb2r3Q==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-40L2;
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
Subject: [RFC PATCH 22/45] mm: page_alloc: adopt partial pageblocks from tainted superpageblocks
Date: Thu, 30 Apr 2026 16:20:51 -0400
Message-ID: <20260430202233.111010-23-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6A7324000B
X-Stat-Signature: a61xiemgjxz31k9uw3cncokwbni7gd7u
X-Rspam-User: 
X-HE-Tag: 1777580585-737626
X-HE-Meta: U2FsdGVkX18H1lit2PRKCZAckUt4YG3oQWaDzQzJSescTwtVLbx56d4aatVAdD9Vq/lu1ufuzS3/rMGspECkBHY9lGhg1pprkXPtCYFPZPF01dfA+T/JEireiMyachTO4XAk66LVA9nR4gZoBqrPjLyLLvnwRKq/U1CT9Xvg/WwZb3cKHlrLfmb3G6vggWEbcBz3SYzT6AZ9jl1kT2FYjQdds0nJR3OnD0IiDloPepeECRmZbjuoghmKC1fb+uCShFJnrCcReg8ZTU6wXvmi7oqWymW80wR3niYpPTj3UfLUUNJXM1sdYa6FaewHAI0t3PQssL09uClPANOuQWRdJREHux6bayjGEetYz9ozSSQurpwGb2uu5Ryl/URFbtNYyhkgyO2krYDyls/jjHleufyN4zWLE62Xscki8qtFwIT8eUGgYP8BaAbDQlY4pQtrde4hQ5Ni75YaiYSkYbIQWc1Ws6FC5twqXpvJfmXzfCGRk1MnLxwdf0qqgklLPaelQ/Dl8tju8Z526JUDVViB3okarm43LIrO09ahrvFMWI6K/IPZLiSPks6+3sXoa02zT5SoyLS+Waaep+PbEoC+e5v1pBu79v8vtvssKSlYkJ1Yuy3o9Y6xgFnOCyKrBlgcOMZQCZwZwtmFtrhtd7dz0lzLmt2ltyNqGKzsDPMkaQ0ybE6Tz725GBV8AFgka4X2CZgPGL1H4WD03vJnscPtEtAevw/6Z8tfw0g+KjEuMO9P9fhWdi6q1nhdzCjOzJ9u451gMg61GHVzWp9LWMCrkyJioS8Kaxot3claEc7JHauRoi3Jpnhdmo1SPwETCMwyq1ciA0av6SxE6dlQHNhpq6nQN34P0qqnW5QiCoz9lEo8Ko5hkYTiOZpAIYOk+8B/BJIBa4SqfecFuIB8HxrIHrov/x/pYbyhoUBmOmz0wgvglx8YaMNsZVYGidHT9ojXYL+3xDoXHDqkQvDh7ZC
 tuJ/Wpyk
 ozvhj5G884zVw7uJ0zMs1XqO/LS8OESfmSbi6k+yr057Bib/G0dERIAr4xiKpDWE2aoOr4WmqhfGHsNMka76s+E1uZ8ra0o3CavD2SfjUjAe1/3P6HtzA0yfFk+1z1No8L411Pi8RwuxPQ8m7HcthTvWptXJMCtMgR5MMVvMrt0mOmJpqe2aQ7mDJO0nOvnRlkuByL0/xt+g1p77uSPh+Fplyh7Yje72d2apPbcvIQlktc6yKCgPOX8PoO+A0TOJtEAjcsqY9JQenxGmtNomebzWdc4UJf167uPB8L297bswMwK8pI3v1RAOpfX1Xt9XhoPjsQKHoPx/fSGJ8uZ6940njR/yTGwvE1mRv5/8IJsZUbbBuWtuSPfHRNND+H4dHqywMfUm0wkjP34NgNS9OI8/paOMYcKZRt4n3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Add Phase 2 to rmqueue_bulk: when refilling PCP for unmovable or
reclaimable allocations, search tainted superpageblocks for partially-free
pageblocks with sub-pageblock buddy entries of the requested migratetype.

Claim ownership of the pageblock and move the found entry to PCP with
PCPBuddy marking.  Pass 0 (the existing owned-block recovery phase)
picks up remaining buddy entries on subsequent refills, so there is no
need to sweep the entire pageblock eagerly.

This concentrates non-movable allocations into already-tainted
superpageblocks, reducing fragmentation spread to clean superpageblocks.

Before claiming ownership, verify the pageblock is not already owned by
another CPU (pbd->cpu == 0).  Without this check, two CPUs could have
PCPBuddy pages from the same pageblock on separate PCP lists protected
by different locks, and the PCP merge pass could corrupt the other
CPU's list.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 114 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 101 insertions(+), 13 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8f925b5a2e5f..4f8105b89e47 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1130,7 +1130,7 @@ static inline void set_buddy_order(struct page *page, unsigned int order)
  * - Set when Phase 0/1 restore or acquire whole pageblocks.
  * - Propagated to split remainders in pcp_rmqueue_smallest().
  * - Set on freed pages from owned blocks routed to the owner PCP.
- * - NOT set for Phase 2/3 fragments or zone-owned frees.
+ * - NOT set for Phase 3 fragments or zone-owned frees.
  * - The merge pass in free_pcppages_bulk() only processes
  *   PagePCPBuddy pages, ensuring it never touches pages on
  *   another CPU's PCP list.
@@ -3840,15 +3840,15 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
  * under a single hold of the lock, for efficiency.  Add them to the
  * freelist of @pcp.
  *
- * When @pcp is non-NULL and @count > 1 (normal pageset), uses a four-phase
+ * When @pcp is non-NULL and @count > 1 (normal pageset), uses a multi-phase
  * approach:
- *   Phase 0: Recover previously owned, partially drained blocks.
- *   Phase 1: Acquire whole pageblocks, claim ownership, set PagePCPBuddy.
- *            These pages are eligible for PCP-level buddy merging.
- *   Phase 2: Grab sub-pageblock fragments of the same migratetype.
- *   Phase 3: Fall back to __rmqueue() with migratetype fallback.
- *   Phase 2/3 pages are cached for batching only -- no ownership claim,
- *   no PagePCPBuddy, no PCP-level merging.
+ *   Phase 0:   Recover previously owned, partially drained blocks.
+ *   Phase 1:   Acquire whole pageblocks, claim ownership, set PagePCPBuddy.
+ *              These pages are eligible for PCP-level buddy merging.
+ *   Phase 2:   Adopt partial pageblocks from tainted SPBs (non-movable only).
+ *              Claims ownership so Pass 0 can recover buddy entries later.
+ *   Phase 3:   Fall back to __rmqueue() with migratetype fallback.
+ *              No ownership claim, no PagePCPBuddy, no PCP-level merging.
  *
  * When @pcp is NULL or @count <= 1 (boot pageset), acquires individual
  * pages of the requested order directly.
@@ -3976,11 +3976,99 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 		goto out;
 
 	/*
-	 * Phase 2 was removed: it swept zone free lists for sub-pageblock
-	 * fragments, which are always empty when superpageblocks are enabled.
-	 * Phase 3's __rmqueue() -> __rmqueue_smallest() properly searches
-	 * per-superpageblock free lists at all orders.
+	 * Phase 2: Adopt partial pageblocks from tainted SPBs.
+	 *
+	 * Phase 1 only grabs whole free pageblocks. When a tainted SPB
+	 * has partially-used pageblocks with free sub-pageblock buddy
+	 * entries, Phase 1 can't use them. Phase 3 can find them via
+	 * __rmqueue_smallest, but without ownership or PCPBuddy marking,
+	 * so they fragment further on drain.
+	 *
+	 * This phase bridges the gap: find a sub-pageblock free entry
+	 * in a tainted SPB and claim ownership of its pageblock. Pass 0
+	 * will pick up remaining buddy entries on subsequent refills.
+	 *
+	 * Only for unmovable/reclaimable — movable should use clean SPBs.
 	 */
+	if (migratetype != MIGRATE_MOVABLE &&
+	    !is_migrate_cma(migratetype)) {
+		enum sb_fullness full;
+
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			struct superpageblock *sb;
+
+			list_for_each_entry(sb,
+				&zone->spb_lists[SB_TAINTED][full], list) {
+				struct page *page;
+				int found_order = -1;
+
+				if (sb->nr_free_pages < pageblock_nr_pages / 4)
+					continue;
+
+				/*
+				 * Find a sub-pageblock free entry for our
+				 * migratetype, starting from the largest order.
+				 */
+				for (o = pageblock_order - 1; o >= order; o--) {
+					struct free_area *area;
+
+					area = &sb->free_area[o];
+					page = get_page_from_free_area(
+						area, migratetype);
+					if (page) {
+						found_order = o;
+						break;
+					}
+				}
+				if (found_order < 0)
+					continue;
+
+				/*
+				 * Check that this pageblock isn't already
+				 * owned by another CPU. If it is, two CPUs
+				 * would have PCPBuddy pages from the same
+				 * pageblock, and the PCP merge pass could
+				 * corrupt the other CPU's PCP list.
+				 */
+				pbd = pfn_to_pageblock(page,
+						       page_to_pfn(page));
+				if (pbd->cpu != 0)
+					continue;
+
+				/*
+				 * Found a free chunk in an unowned pageblock.
+				 * Take it from buddy, claim ownership, and
+				 * set PCPBuddy. Pass 0 will grab remaining
+				 * buddy entries on future refills.
+				 *
+				 * Set PB_has_<migratetype> since we bypass
+				 * page_del_and_expand (which normally does
+				 * PB_has tracking).
+				 */
+				del_page_from_free_list(page, zone,
+							found_order,
+							migratetype);
+				__spb_set_has_type(page, migratetype);
+				set_pcpblock_owner(page, cpu);
+				__SetPagePCPBuddy(page);
+				pcp_enqueue_tail(pcp, page, migratetype,
+						 found_order);
+				refilled += 1 << found_order;
+
+				/*
+				 * Register for Phase 0 recovery so future
+				 * drains from this pageblock can be swept
+				 * back efficiently.
+				 */
+				if (list_empty(&pbd->cpu_node))
+					list_add(&pbd->cpu_node,
+						 &pcp->owned_blocks);
+
+				if (refilled >= pages_needed)
+					goto out;
+			}
+		}
+	}
 
 	/*
 	 * Phase 3: Last resort. Use __rmqueue() which does
-- 
2.52.0


