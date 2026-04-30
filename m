Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0461ACD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2A06B00AA; Thu, 30 Apr 2026 16:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049186B00AD; Thu, 30 Apr 2026 16:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE946B00AF; Thu, 30 Apr 2026 16:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B162F6B00AD
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6642A1601EB
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:07 +0000 (UTC)
X-FDA: 84716346414.26.02F33BA
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1509FA0009
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=EkYJ6vhQ;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTtVQekqmYIRquveFhZQyO2hAOIv4Nsoy3Q0tNMXmWI=;
	b=z7Xmxfwfsi/7AAeI4ac7Cp7KHRdy3Bp4/MY/dTbDQHc/KCUnEHrvnum34asegjDSzrMogq
	X2qvg05Q5K00PJ8FB8MhSJyhmzKaCJqT0IXVrSEDdplfnsgpYuK1XPfKQzZlrisOfyqTaA
	NOY/xQCPSowkZcmIg2DFvpaoDQbJgCA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580584; a=rsa-sha256;
	cv=none;
	b=oyZ24Bv+3EKsJ/mG8W3fWNCahM9ciA5KigMrkYLaOzSSYZ7BxoSzpCKuf8HomI8iF/ClzY
	ZC4whotJAOx++5Wo+/gnFkQ+HVvCxYVoQFtbzE58aPWL9aAirCxDyRsQN4SfjYa7FzrRBs
	ZOKdFTb0K4Flxus162dj77w8g87MCes=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=EkYJ6vhQ;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TTtVQekqmYIRquveFhZQyO2hAOIv4Nsoy3Q0tNMXmWI=; b=EkYJ6vhQ1ikJWGTx30iLuB15Lu
	SZiPnH8n/JHTZihRB3OYatOQgxvD/uVjM6brM1J1zJVofWJmGfB+QMUV8Sfg84c8HleZ0QgzpIjua
	zkNqMj6YcNwTJBVFF/+u90FYkuNTP9w0JeYiLH22Y8rjEtyvMBWKlBKwhk7XkqgKNGLu7zHAc4Tw6
	I9XBIuOwVD3uTUzJzmkLJwG+o6LzRy6Hz+L/3VUIiuNQ4mVwKREWxmaZQsrDyjPn+YcDspQTd51I9
	y5okmJbxkIjM0+TdI/NO83uV+F5y8J4zg3D0QNEbGsxbjnF8R5LN3x2rbY+F3VsGsMjP5ifMLjGoT
	tfOgTKhA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-2Cnf;
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
Subject: [RFC PATCH 43/45] mm: page_alloc: trigger defrag from allocator hot path on tainted-SPB pressure
Date: Thu, 30 Apr 2026 16:21:12 -0400
Message-ID: <20260430202233.111010-44-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1509FA0009
X-Stat-Signature: tsmut7wxwt3z1gnk1bcn4usoq78d6m9i
X-Rspam-User: 
X-HE-Tag: 1777580583-475068
X-HE-Meta: U2FsdGVkX1+zOxkthrBR8jvlLjXCIUqI56iMoFkZsxvlJSG9CjajByLlcfpmaFyYsEEUohyCEoTvl47N8GLFI4jZlkCSsy9ogC/VmIjCGUwhPGGWh3OAaKVT5OGWTLKyrsbpjL2ywrb2QcnJCUJeOQ6moFT7qsZtDU9n1wnqvz+o1bEJOJQeiQ1wMByYTu47PxTN90pXkgdg+GZoFqe/3HW5k32EkGhr86AiLeAtn7jiXK1eGdfMhwpA4jXncRws3/5fwqw3xj4towOltCo0PZ7chxDiXuDbwi97uPUzpDSmc8fyohF1f6ishDL7gA71I4j09nUInBkrLtCRGKkGOHuNNseOuZnG7IxEe9w2LC3694n6sLgKZ16IwYRWX4LPDCjU0reHfnYQwbv8QwACcFhSk8JIOcDdExOCx+iMdVo84xW/GsYTUFn6OLeof2Rnqq3eqPl4vJPvgpUcN41c5oeK7ZHm33u/c2jXLBhqyWRV/xz2OE4jNONSshJHbRXr568Jm1KMP44YQgANOltdyu0VWCnEaP2NAf2OiCPgsUVZ5hiar7KyBp8l4eVuOPrNhKaZvpfdKornw3ViXLwzqcsqhFS/5IKHq7BpWCd9WCev5prkA5TnkKaD6kJ4eAIWHF8VX7SzAAhmId6AttOJoGhgWRK38lWTz/QSZamhrukXjBgB3BitIULFDNtAPI7ohVwPnmN++jIMCjPtPxigpS43ZjwHqBEbWZmHdGMcaG/cNTleoQx5rWZEA46W52ZzqYcy5Q5vz1O3ObfRLxwdmtX0Fu2qLz3ULeLtJpymK7TepC1QoBst+xAH6tsTD2EqadWqLCPZ3GYJj32WiU2+nE5qOOvtMBOPQ5DD5s1XjAzsHszLXeApg/MfvoZW/fxozeANnmMOq3mBeVN4RdnCACqrq7oHcy8cxuuw9x1qk2ns4uLu9VWiLPZOWxVuVjb8nL2B3F497fukFrJnd9z
 rRINcDpw
 hwpi9wPE/BfDf4emE1+ROKzZ4rjoMT7FxPdVeLx5kI88m3GgUFydPBkKvCT/KCpUXJG/5QE/mL4sb17CE0eFHlngaxbHuBMKx7kYbUayXkbOPJF3uJ4s6SnxEchhiy4rr7bzZ3vKzU39oHyymu3VQxqhNsjM4KijxQGPxtsnRt7h3AsYtXMZ4y5qcEtIf5AF9TwLeXjQNMltw+lSTKwB2a7xghDZUcCd8bg5+88BdjNQyf7wWo5kqrEpRDh+HQJ4EqNguK92YORUOS4q2MZ/KxOMHHtUKridmTaYILcHCcjL0F3KJB+NDBXoaftjPF8wGqeU6hhies/6M7MG3cIeAagY6UHz1jrzUOqTB1s8OplxCgwA4RDYaGH/E9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

The per-SPB background defrag worker is currently triggered only from
spb_update_list(), which itself only fires when the SPB's category or
fullness bucket changes. Sub-bucket allocations (decrementing free
counters within the same bucket) do not re-evaluate.

drgn dump on a saturated devvm showed several tainted SPBs with
defrag_last_no_progress_jiffies set hundreds-to-thousands of seconds
ago — long after their 5-second SPB_DEFRAG_NOOP_COOLDOWN expired —
yet defrag had never been re-triggered on them. The shape of the
failure: a tainted SPB hits free=0, the worker tried once and made no
progress (movable pages mostly in mixed pageblocks, evacuating them
left the source PB still occupied by unmov/recl content), no-progress
cooldown stamped, no later allocator event crossed a fullness bucket
on that SPB so spb_update_list never re-fired the trigger. The SPB
sat stuck while subsequent non-movable allocs ended up tainting fresh
clean SPBs via PASS_3.

Add two complementary triggers in __rmqueue_smallest:

(1) On every PASS_1/2/2B/2C/2D success that already evaluates
    spb_below_shrink_high_water(sb) (i.e. the same threshold at
    which queue_spb_slab_shrink is fired), additionally call
    spb_maybe_start_defrag(sb). Catches actively-pressured tainted
    SPBs immediately, no extra hot-path predicate evaluation.

(2) Just before the PASS_3 fall-through that risks tainting a fresh
    clean SPB, walk the tainted-SPB list and call
    spb_maybe_start_defrag() on each. Catches SPBs that are stuck
    with no allocator activity to drive (1). Bounded by
    nr_tainted_spbs and only runs on the slow path that is about to
    fragment the clean pool — appropriate to spend a list walk
    here. The cooldown gate inside spb_needs_defrag() no-ops cheaply
    for SPBs not yet eligible.

The cooldown still gates spb_needs_defrag() so neither trigger
storms the worker.

The existing spb_maybe_start_defrag() call inside spb_update_list()
is retained: it remains the trigger for the clean-SPB
within-superpageblock compaction path (spb_defrag_clean), which the
new alloc-path triggers do not cover (they only fire on
SB_TAINTED). Replacing the spb_update_list call entirely would
require a separate clean-SPB-specific trigger in the allocator and
is left for a follow-up.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller

Also factor out the now-repeated tainted-alloc reaction into a helper
spb_react_to_tainted_alloc(sb, zone) and call it from all 8
PASS_1/2/2B/2C/2D success sites in __rmqueue_smallest. Centralizes the
gate (cat == SB_TAINTED && spb_below_shrink_high_water(sb)) and the
shrink+defrag kick in one place, removing duplication and reducing
the per-success-site noise.
---
 mm/page_alloc.c | 73 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 53 insertions(+), 20 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index af499f0a1a48..e15e71d5ac99 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2709,6 +2709,30 @@ static inline bool spb_below_shrink_high_water(const struct superpageblock *sb)
 		(unsigned long)spb_tainted_reserve(sb) * pageblock_nr_pages;
 }
 
+/*
+ * spb_react_to_tainted_alloc - kick reclaim machinery on a tainted-SPB alloc.
+ *
+ * Called from each PASS_1/2/2B/2C/2D success path after a successful
+ * allocation against a tainted SPB. If the SPB is below its shrink
+ * high-water mark, queue the SPB-driven slab shrink and try to start
+ * the per-SPB defrag worker. Both have their own cooldown gates inside,
+ * so this is cheap to call on every such allocation.
+ *
+ * Skips quickly when the SPB is not tainted (e.g. movable allocation
+ * landing on a clean SPB) or when the high-water mark hasn't been
+ * crossed.
+ */
+static inline void spb_react_to_tainted_alloc(struct superpageblock *sb,
+					      struct zone *zone)
+{
+	if (spb_get_category(sb) != SB_TAINTED)
+		return;
+	if (!spb_below_shrink_high_water(sb))
+		return;
+	queue_spb_slab_shrink(zone);
+	spb_maybe_start_defrag(sb);
+}
+
 /*
  * On systems with many superpageblocks, we can afford to "write off"
  * tainted superpageblocks by aggressively packing unmovable/reclaimable
@@ -2969,9 +2993,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 			page = try_alloc_from_sb_pass1(zone, cpu_hint,
 						       order, migratetype);
 			if (page) {
-				if (spb_get_category(cpu_hint) == SB_TAINTED &&
-				    spb_below_shrink_high_water(cpu_hint))
-					queue_spb_slab_shrink(zone);
+				spb_react_to_tainted_alloc(cpu_hint, zone);
 				trace_mm_page_alloc_zone_locked(page, order,
 				    migratetype,
 				    pcp_allowed_order(order) &&
@@ -2984,9 +3006,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 			page = try_alloc_from_sb_pass1(zone, zone_hint,
 						       order, migratetype);
 			if (page) {
-				if (spb_get_category(zone_hint) == SB_TAINTED &&
-				    spb_below_shrink_high_water(zone_hint))
-					queue_spb_slab_shrink(zone);
+				spb_react_to_tainted_alloc(zone_hint, zone);
 				slot->zone = zone;
 				slot->sb = zone_hint;
 				trace_mm_page_alloc_zone_locked(page, order,
@@ -3057,9 +3077,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				page_del_and_expand(zone, page,
 					order, current_order,
 					migratetype);
-				if (cat == SB_TAINTED &&
-				    spb_below_shrink_high_water(sb))
-					queue_spb_slab_shrink(zone);
+				if (cat == SB_TAINTED)
+					spb_react_to_tainted_alloc(sb, zone);
 				trace_mm_page_alloc_zone_locked(
 					page, order, migratetype,
 					pcp_allowed_order(order) &&
@@ -3088,9 +3107,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					page_del_and_expand(zone, page,
 						order, current_order,
 						migratetype);
-					if (cat == SB_TAINTED &&
-					    spb_below_shrink_high_water(sb))
-						queue_spb_slab_shrink(zone);
+					if (cat == SB_TAINTED)
+						spb_react_to_tainted_alloc(sb, zone);
 					trace_mm_page_alloc_zone_locked(
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
@@ -3145,8 +3163,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 					page = claim_whole_block(zone, page,
 						current_order, order,
 						migratetype, MIGRATE_MOVABLE);
-					if (spb_below_shrink_high_water(sb))
-						queue_spb_slab_shrink(zone);
+					spb_react_to_tainted_alloc(sb, zone);
 					trace_mm_page_alloc_zone_locked(
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
@@ -3184,8 +3201,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						0, true);
 					if (!page)
 						continue;
-					if (spb_below_shrink_high_water(sb))
-						queue_spb_slab_shrink(zone);
+					spb_react_to_tainted_alloc(sb, zone);
 					trace_mm_page_alloc_zone_locked(
 						page, order, migratetype,
 						pcp_allowed_order(order) &&
@@ -3269,8 +3285,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 							opposite_mt);
 						__spb_set_has_type(page,
 							migratetype);
-						if (spb_below_shrink_high_water(sb))
-							queue_spb_slab_shrink(zone);
+						spb_react_to_tainted_alloc(sb, zone);
 						trace_mm_page_alloc_zone_locked(
 							page, order, migratetype,
 							pcp_allowed_order(order) &&
@@ -3342,8 +3357,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 							MIGRATE_MOVABLE);
 						__spb_set_has_type(page,
 							migratetype);
-						if (spb_below_shrink_high_water(sb))
-							queue_spb_slab_shrink(zone);
+						spb_react_to_tainted_alloc(sb, zone);
 						trace_mm_page_alloc_zone_locked(
 							page, order, migratetype,
 							pcp_allowed_order(order) &&
@@ -3371,6 +3385,25 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		queue_spb_slab_shrink(zone);
 	}
 
+	/*
+	 * Last-chance defrag trigger before tainting a fresh clean SPB.
+	 * Walk the tainted-SPB list and try to wake the per-SPB defrag
+	 * worker on each. Catches SPBs that are stuck in expired-cooldown
+	 * state because no allocator activity has touched them recently
+	 * (the routine event-driven trigger from spb_update_list only
+	 * fires on bucket transitions, not on every alloc). Once the
+	 * cooldown has expired, spb_maybe_start_defrag() will requeue
+	 * work; otherwise the gate inside spb_needs_defrag() no-ops
+	 * cheaply. Bounded by nr_tainted_spbs and only runs when we are
+	 * already on the slow path of fragmenting the clean pool.
+	 */
+	for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+		list_for_each_entry(sb,
+			&zone->spb_lists[SB_TAINTED][full], list) {
+			spb_maybe_start_defrag(sb);
+		}
+	}
+
 	/* Pass 3: whole pageblock from empty superpageblocks */
 	list_for_each_entry(sb, &zone->spb_empty, list) {
 		if (!sb->nr_free_pages)
-- 
2.52.0


