Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 987ECCD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1FAC6B00AF; Wed, 20 May 2026 11:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6326B00B1; Wed, 20 May 2026 11:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B686B00B0; Wed, 20 May 2026 11:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99E066B00AE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CFD98C0D7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:57 +0000 (UTC)
X-FDA: 84788110554.21.A591203
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id 90C1B4002D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Sh7iI7xi;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulNo65hNaNqGoC5B35kMqlTnxEKU9cQsEPkam/uQDmc=;
	b=dBRjQLJ89NjbQSsqeGnfxn5J2BvqEEE9D7ZwOWgLReFJ6X+HmDNx+jRUDSHKfqzFAzkKUK
	MxB5kprtEdH1Yt+DuGxmBYY1zpUCAPRh8hSau48z1UUfQPxTsjCym8Zt+P3MjtnUlM2pfb
	ZrnTcBelpUCC7m0noDRGf0zmuCnngpE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Sh7iI7xi;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289255; a=rsa-sha256;
	cv=none;
	b=Wo126QT0rlelrAy4BodU1pTSbGy2W75nPewy+YQLGj/qgkh045UsV7VdzDoUGKTNgnZ3K6
	WOob48aqo0dimLEWUTsl7hiDPtvPlaK8Vz5sMRGe8KrH8p7ZGIskuOFxw5cYQ9hZF81Eb0
	bPJeTv9rfhiBkgOlUn/GwgDTIPsBm8E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ulNo65hNaNqGoC5B35kMqlTnxEKU9cQsEPkam/uQDmc=; b=Sh7iI7xiJxSGjU3a8N4C+J2UcI
	+xW9/Z9it2c/nlh9yunllK2rdjPju5EwaRPLc1hSC6AZVIDZqc7g+B3fMcZrYQSiiYVvmKpcVfaFm
	W0wylpEMNCp9kXqgSUkWDQPLHqikPjArdQmZFu7NQIIUufOiP+JG02RkGxnXCkr9naMgKWlRJxXz1
	fNS1uW0CupLCqKYrQ7m+txfUjm6+08/ji/SgfC7dISGoI8BnnxSDqeclcjw55mNukNcVb1vG3VZV+
	7JDrzfVrOpHeF6cdPoJqDcV0bGNkd+Vx64RLEGS6N4ltPPayrpgrzsbpMcazfe3M8jFvm4COoKlkn
	6Bl9+bqQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPN-0000000024Q-0DQU;
	Wed, 20 May 2026 11:00:29 -0400
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
Subject: [RFC PATCH 35/40] mm: page_alloc: refuse best-effort high-order allocs servable at lower orders
Date: Wed, 20 May 2026 10:59:41 -0400
Message-ID: <20260520150018.2491267-36-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90C1B4002D
X-Stat-Signature: 3pbotj713r48ff39upcaunohpfnmxeq4
X-HE-Tag: 1779289255-3319
X-HE-Meta: U2FsdGVkX1+SwAsJnut239Wp7Fqyl6jyn1YyDr5S512CpcSAjrlMps8d+sMWYAefzw93c2YH0TOo09Lhpn7Rj+rS/Iyp+n6iEF/i59Sq0HivqLZBaReLsR1xgmQR9d8TPgAkZNZYbHaFDMuydF1zDAj+1MYBfCXiVWknyQm7R1oUsQTzQt1TrjEbGGG5SB1jVxUFJuKWnRUlPBuMV6tqMAZEU2f6gF2b03O6wYdWPC4PwSO0TZY5Dh7cd6ylCUs1Z/KfrqwwPCTEVeh8aWoijbwMglyKbcUROU9V63ut7P6dQZ3a+M3+75lugW0hcwPDDF2vF1d84lNpNoCy1vsYKsf6iMKQtqRNmipzh92UOfsVUXcxk0RKyuOUvpljGddZDuPpErurE3Zl9ZOMNqVwPd8JsOjeJuv7rvgsobdsOwKWHzn2atqzVMdIN8ZoQaSE/fMUPtlBtk8YrcleK1MrpiSefo2QQxORDvsIARq5LvyHzXuVHNYg5wKmfREhxYtrtSDDzedtci3q84WJEqUC2trX07wVIzkOimfiHR9nLrato5R9NBO14h1Ikx9gyXNOrxUil4/ed4P6DpZMpkLSHzMTVH7I+hDpUFeUz4Du8Wvp/yF3FyGHKFneN55PeDnIn1jUfqGyHSiFzgVV+fZi7EnNvPrhQGWiNJDPQ9RWHpGnLjEe4aN19OOFpLlrEemryAQaMY+/ABMrnnOq9ZE8KrjJP9bcSMKzKan56UbuXnjhdSlSq5/vpTSTitzITy+rOXw9FyHMV5FqykZmkGS2HkfzOV5yyypSYpWIfWwabjyVjvJ8huC/bPW9xeFvIlw3kfD0QXJondslcOtsFMMbJd9dpqaOnZQIMhWlIfdr7J0xRGeyAcRMK3YM9w2ZAe/a3jsPbTgKRjhYM8LQF8+6pSW0fBO8TfSpdqCw3uuGirMtDD127ayTe5V0EANZYogQ//K+EYe4t3yiCPjJna/
 /paMN7Yh
 UziI6EoZZMQ2GTAFKQqZrc6j8YQOVhZGVJmDkg7Uv5X3k5u7SLy2FZ94auahGPmJ9aJeQthgowSJm8JmsbKvPgji+Kzo8i+bsGvzhUzCmzMEi8vkK096BORFlLOACgCoo5c3knyIbbEsr+prtp0U31cumlX49n0Ke1ztl5f6vNDGbnzEZGi51VrWNPLF1m02uLKAoMjnPpatraVZWYFC4S6henlqfD6W0YzGslet5OvNKd71YsK28L7+VECP4OqDYv3MndtR8/Wc71UAptaiqbvNTCup52lQnoizC4jhflkHtburxjEcjO4t8UMKkFovDGLDz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several common high-order allocation patterns are best-effort: the caller
prefers a single large page for performance but has an order-decrement
fallback (or equivalent retry path) and is happy to accept failure of the
high-order attempt. Examples:

  kvmalloc()              kmalloc attempt has a vmalloc fallback
  vmalloc()               vm_area_alloc_pages decrements order on NULL
  alloc_skb_with_frags()  decrements order on NULL per fragment

The convention these callers share is to strip __GFP_DIRECT_RECLAIM and
set __GFP_NOWARN on the high-order attempt, signaling 'I don't want this
to block on direct reclaim and I'm fine with failure being silent'.

Without further hints, get_page_from_freelist's relax sequence treats
these as atomic allocs that must succeed and escalates: it adds
ALLOC_NOFRAG_TAINTED_OK (allowing PASS_2/2B claim_whole_block to relabel
a MOV pageblock inside a tainted SPB) and then drops ALLOC_NOFRAGMENT
entirely (allowing __rmqueue_claim/_steal to taint a clean SPB). The
caller's order-decrement fallback never runs because the high-order
attempt 'succeeds' by tainting.

The fix at the call sites is to add __GFP_NORETRY (kmalloc_gfp_adjust
already does this for kvmalloc). Generalize: in the relax sequence,
before dropping NOFRAGMENT, detect the 'best-effort high-order with
fallback' pattern by:

   order > 0
   __GFP_NOWARN set
   __GFP_NOFAIL not set
   __GFP_DIRECT_RECLAIM already cleared (the relax-sequence gate above)

If the tainted pool can plausibly serve a smaller (or same) order alloc
on the caller's retry, refuse the current attempt instead of escalating.
'Plausibly serve' means any tainted SPB has either:

  - nr_movable > 0  (MOV content exists; reclaim/migration can free
                     pageblocks at the order the caller's retry needs,
                     including orders >= the requested order -- e.g.
                     four THPs in the SPB can yield an order-7 buddy
                     for an order-7 unmovable alloc once the THPs are
                     migrated), OR
  - a free buddy on the requesting migratetype's own list at an order
    < requested (a smaller PASS_1 retry would succeed directly), OR
  - a free buddy on the opposite non-MOV list at an order < requested
    (PASS_2C borrow at the smaller order would succeed) -- only relevant
    for UNMOV/RECL allocs.

The MOV-content check alone covers the common case cheaply (one counter
read per tainted SPB) and works even when the movable memory exists at
orders larger than the alloc -- which is exactly when the per-order
free_list walk would miss it.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 116d9cc0a493..2791a52b61da 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2708,6 +2708,101 @@ static inline u16 spb_tainted_reserve(const struct superpageblock *sb)
 	return max_t(u16, SPB_TAINTED_RESERVE_MIN, sb->total_pageblocks / 32);
 }
 
+/*
+ * spb_tainted_can_serve_smaller - could a smaller-order @migratetype alloc
+ * be satisfied from any tainted SPB of @zone (now or after evac/reclaim)?
+ *
+ * "Yes" if either:
+ *   - some tainted SPB has nr_movable > 0 (MOV content exists; reclaim or
+ *     compaction/evac can free pageblocks at any order the caller's
+ *     order-decrement fallback might want, including orders >= the original
+ *     requested order -- e.g. four THPs in the SPB can yield an order-7
+ *     buddy for an order-7 unmovable alloc once the THPs are migrated), OR
+ *   - some tainted SPB has a free buddy on the requesting migratetype's
+ *     own list at an order < @order (a smaller PASS_1 retry would
+ *     succeed directly), OR
+ *   - some tainted SPB has a free buddy on the opposite non-MOV list at
+ *     an order < @order (PASS_2C borrow at the smaller order would
+ *     succeed) -- only meaningful for UNMOV/RECL allocs.
+ *
+ * Used by the get_page_from_freelist relax sequence to discriminate
+ * "the caller has an order-decrement fallback that the tainted pool can
+ * eventually serve" from "the alloc must escalate to dropping
+ * ALLOC_NOFRAGMENT and tainting a clean SPB".
+ *
+ * Walks zone->spb_lists[SB_TAINTED][*] under zone->lock: spb_update_list()
+ * mutates these same lists under zone->lock, so a lockless walk would race
+ * with list-cursor reassignment (list_move from a concurrent allocator
+ * caller could splice the cursor onto a different list and turn the walk
+ * into an infinite loop or crash on a corrupted list_head). Sister function
+ * tainted_pool_has_free() takes zone->lock for the same reason; match its
+ * lock discipline. Bounded by the tainted SPB count plus a constant amount
+ * of work per SPB.
+ */
+static bool spb_tainted_can_serve_smaller(struct zone *zone,
+					  unsigned int order,
+					  int migratetype)
+{
+	struct superpageblock *sb;
+	unsigned long flags;
+	bool found = false;
+	int full;
+	unsigned int o;
+	int opposite_mt = -1;
+
+	if (order == 0)
+		return false;
+
+	if (migratetype == MIGRATE_UNMOVABLE)
+		opposite_mt = MIGRATE_RECLAIMABLE;
+	else if (migratetype == MIGRATE_RECLAIMABLE)
+		opposite_mt = MIGRATE_UNMOVABLE;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	for (full = 0; full < __NR_SB_FULLNESS && !found; full++) {
+		list_for_each_entry(sb, &zone->spb_lists[SB_TAINTED][full],
+				    list) {
+			/*
+			 * MOV content can be reclaimed (LRU folios) or
+			 * migrated (compaction / spb_evacuate_for_order),
+			 * making the SPB able to host a smaller (or even
+			 * same-order) non-MOV alloc on the retry. Cheap
+			 * counter check, covers most real cases.
+			 */
+			if (sb->nr_movable > 0) {
+				found = true;
+				break;
+			}
+
+			if (!sb->nr_free_pages)
+				continue;
+
+			/*
+			 * No MOV content but there might be a same-mt or
+			 * opposite-non-MOV buddy at a smaller order that a
+			 * PASS_1 retry / PASS_2C borrow could serve.
+			 */
+			for (o = 0; o < order; o++) {
+				struct free_area *area = &sb->free_area[o];
+
+				if (!list_empty(&area->free_list[migratetype])) {
+					found = true;
+					break;
+				}
+				if (opposite_mt >= 0 &&
+				    !list_empty(&area->free_list[opposite_mt])) {
+					found = true;
+					break;
+				}
+			}
+			if (found)
+				break;
+		}
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+	return found;
+}
+
 /*
  * High-water threshold for proactively kicking the slab shrinker. When a
  * non-movable allocation consumes from a tainted SPB whose total free
@@ -6303,8 +6398,35 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	 */
 	if (no_fallback && !defrag_mode &&
 	    !(gfp_mask & __GFP_DIRECT_RECLAIM)) {
+		struct zone *pref = zonelist_zone(ac->preferred_zoneref);
+
 		if (gfp_mask & __GFP_NORETRY)
 			return NULL;
+
+		/*
+		 * Best-effort high-order callers convention: stripping
+		 * __GFP_DIRECT_RECLAIM, setting __GFP_NOWARN, omitting
+		 * __GFP_NOFAIL, and asking for a high order indicates the
+		 * caller has an order-decrement fallback (kvmalloc's
+		 * vmalloc fallback, vmalloc's order-decrement loop,
+		 * alloc_skb_with_frags's order-decrement loop, ...).
+		 *
+		 * If the tainted-SPB pool already has a free buddy at any
+		 * lower order on a free list a smaller retry could use,
+		 * refuse this attempt so the caller's order-decrement
+		 * uses that sub-pageblock space instead of forcing us to
+		 * drop ALLOC_NOFRAGMENT and taint a clean SPB.
+		 *
+		 * Same intent as adding __GFP_NORETRY at every such
+		 * caller, but applied centrally so we cover both existing
+		 * and future callers without per-call-site fixes.
+		 */
+		if (order > 0 && (gfp_mask & __GFP_NOWARN) &&
+		    !(gfp_mask & __GFP_NOFAIL) &&
+		    spb_tainted_can_serve_smaller(pref, order,
+						  ac->migratetype))
+			return NULL;
+
 		if (!(alloc_flags & ALLOC_NOFRAG_TAINTED_OK)) {
 			alloc_flags |= ALLOC_NOFRAG_TAINTED_OK;
 			goto retry;
-- 
2.54.0


