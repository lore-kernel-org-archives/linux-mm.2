Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C737CC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891606B009B; Wed, 14 Oct 2026 05:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868496B009D; Wed, 14 Oct 2026 05:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4D96B009E; Wed, 14 Oct 2026 05:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 558456B009B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:01:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E907340471
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:01:21 +0000 (UTC)
X-FDA: 85320637962.14.3F472C5
Received: from mta0.migadu.com (out-95.mta0.migadu.com [91.218.175.95])
	by imf17.hostedemail.com (Postfix) with ESMTP id B950A4000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:01:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n9Zi1TdJ;
	spf=pass (imf17.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.95 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791968480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/B25+LLi82p0Sza6LyyArGq5kbraLvrdsSLQbmRQ4g=;
	b=Ab0DyVtxJSdKiiz6axfpqBUf7Emnar2WxWcTHv98Y6AdjPZ9MRNifKNmbvbVRo2ly1bDc+
	mpziZIsSo7M8d4KT0FHE9rujFoamUCorIOuuCxZ46f6Y3p3iwcFACQsWucBFOYeSjCza6+
	+c3eAQVAYEe1OmPnaIg+oRgHhjsTzKA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n9Zi1TdJ;
	spf=pass (imf17.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.95 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791968480;
	b=LC3nrl4klu2TMQHLtn8yefuap5huwYe+MiMDzJI1Jbjk27vKO88PPJ0qyL8PA+Rsrlbx6i
	oUUz2V1U6u9j65ANiOuWD7OjsO8+/quFkmMhjMYV8ZcnvXhJOarnLGmBloX2EA70uY/2as
	GmPCuNN/Au4WFOekpGObgWt+AhyLxWc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3zJjm6DiujVRRMFJWBEXTYsYUWwxY7lpqrEEqgi3VfI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791968475; v=1; x=1792573275;
 b=n9Zi1TdJT42pITaZqc9CCPRDkoCAwu5JB+vUWldT2AVxfrZAj7gXMx6zZi8MLuzAoIqUIIqu
 dsTU9/WTYEC3qwHEVv+/epjf40mWTZZL/CNn4Dhlq7B8jOT/ZvQ2unKya/6r8mVpkRX3Ztntzs5
 3f51CGAXeOb8oJtYaAI4gRV4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a323c927ff3d4d89;
	Wed, 14 Oct 2026 09:01:15 +0000
X-Mizu-Trace-ID: a323c927ff3d4d89
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v6 2/2] mm/vmscan: throttle MGLRU eviction when isolated folios pile up
Date: Wed, 14 Oct 2026 17:00:24 +0800
Message-ID: <2a5d323c1caede0f2e2d2016b99893abe656d372.1791968227.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791968227.git.zhuhui@kylinos.cn>
References: <cover.1791968227.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B950A4000C
X-Rspam-User: 
X-Stat-Signature: nf1mjojgeu1jnmqedxu1ta35roi7hyye
X-HE-Tag: 1791968476-593144
X-HE-Meta: U2FsdGVkX1/AAVANwV4yEgskos9YWXG/wtQGFN+IxKlxC0beCC4AWrkh5oJD7/kSyKKUg0Bhi1hahkVgPfBUF/RKJQW5WGNlbfFCAgXVCuHQOZOHWSrClKRyPHC7u9OaJ1zVusfjwHjzl2brwnq6zTDVktOY8c/7jCU/jTTL1pyk0W91Pq/GzbS3tE2BUI5pa/lWYtCML0epqHaFduHM6QM+An6+9pCSBg4+tIYYq+WzWljIIJmU0P1fv8oFFn+TB7AD9SQNS2oNdtW5QP38bI4lkWafqg7hO4po1SggMwA/X9uwggJmECa5GL2/muy58o9fVGXnC4vSak6aK3GJNmCwz5b7TcrkOMGK8ZFBwSHgE9KRVZSYPR8Qf0ejHwqfLOk03PB1mXWrSZK3CEpjsQZe1Y6tMa7loUzYUdIxVQou7U2wbl+fwVK0Vi/xa9t+Jwr+BcQ7QUd58Cf3fd4UNCBaG72xGGhFnUuTsdu8MlIfXsvkC2tlNzTQV0Tw/tD8u98o2UjzYyg4Lw5Dj9VsPFAtqjDVYIadwYEHoYLS/IHFA7bvh9J7e+fwrXO8BdnYEf0nP424PWv7ej/BrdP//HW9UxJMYs15Ty+zAyRMkEn3D7SH5MysxRfhrMn2w2cJXTiWpUJeExJGoUupHxnJqdb4+umaSxvKKypKsCt5lidqIZ/Vc2ByiIYo9GeX2GXJQ1as222js7aqB57zKeRk27PXWJOOHxkzxNVSxFkXAbaN7SBKYgynkDZTpfSReGRcmd4IYHE8gkynxcpiHjKkKJHu2K+5cn5isp0mbQUQRt/n8KtTJ/11fCDVe6IcIA9odhsqR9Cxef7MHr7Dd6PafEbcwmQ1OwJYsdfDH7KSHCPVTr4F0m/iPgGCPu7nI+pjGVxcNYiASuFM3SMU6O1e5PPMFUb8AMZKE6sVl4ACPtK2WgC7HezFL21ESleBHMkHlcz3YJIYnG3ARzbPNyQ
 fDTCtwmO
 /xiyNIi56eYckkWhyzeb+cOjxNdFokMGt2EcddmeD7271fNHLPHWag0tjrrzvEZjiJggb3XaTdYVX0WKqiWagLu0qpH09AgCPub210NKVQKGVd08yjK6FrTfiU3rD9IzQDj8Q2aFtmvi9vLobsfEZ5jANFQ6T7Zsbe22XNtuesKEfTbqU2c80tz6TmYZRhF41lD68
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

The legacy path throttles direct reclaim via too_many_isolated() when
isolated folios pile up, but MGLRU's evict_folios() isolates folios
without this check, which can lead to unnecessary swapping, thrashing
and OOM.

Add lru_gen_too_many_isolated() and throttle_evictable_types(), called
from evict_folios() before the lruvec lock is taken since throttling
sleeps.

The check is per lruvec rather than node-wide: reclaimers contend per
lruvec, and a node-wide check would let isolation in one memcg throttle
reclaim in another. The threshold is the evictable size of the type
divided by MIN_NR_GENS, approximating one generation.

Since isolate_folios() picks the type from refault feedback and may fall
back to the other one, throttle_evictable_types() collects the types
that are not over-isolated and have evictable folios, and sleeps only
when all of them are over-isolated. The mask is passed to
isolate_folios() to restrict its choice and fallback, so an
over-isolated type never blocks the other, and isolation never lands on
a throttled or empty type.

Like the legacy path, kswapd and !writeback_throttling_sane() reclaim
are exempt, the threshold is raised for GFP_NOIO/GFP_NOFS callers, and
a dying task fakes progress to exit reclaim quickly.

Tested with threads write-touching a 48MB anonymous working set in a
16MB memcg backed by swap delayed 50ms via dm-delay. With 192 threads
the task is OOM-killed without this patch and survives with it. With
64 threads both kernels survive the 60s run, and the patched kernel
completes ~22% more touches (301B vs 246B).

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/mmzone.h |   2 +
 mm/vmscan.c            | 171 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 159 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c070b867e2f3..e8fc002c98c0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -583,6 +583,8 @@ struct lru_gen_folio {
 	/* can be modified without holding the LRU lock */
 	atomic_long_t evicted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
+	/* the number of folios isolated from this lruvec and being reclaimed */
+	atomic_long_t nr_isolated[ANON_AND_FILE];
 	/* whether the multi-gen LRU is enabled */
 	bool enabled;
 	/* the memcg generation this lru_gen_folio belongs to */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3bd604204ec7..2d551a1f91c7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4232,25 +4232,34 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
+static unsigned long lruvec_type_evictable_size(struct lruvec *lruvec, int type)
 {
-	int gen, type, zone;
+	int gen, zone;
 	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	for_each_evictable_type(type, swappiness) {
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
+	for (seq = min_seq[type]; seq <= max_seq; seq++) {
+		gen = lru_gen_from_seq(seq);
+		for (zone = 0; zone < MAX_NR_ZONES; zone++)
+			total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
 	}
 
 	return total;
 }
 
+static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
+{
+	unsigned long total = 0;
+	int type;
+
+	for_each_evictable_type(type, swappiness)
+		total += lruvec_type_evictable_size(lruvec, type);
+
+	return total;
+}
+
 static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long total;
@@ -4913,16 +4922,129 @@ static inline bool is_single_type_reclaim(int swappiness)
 	       swappiness == SWAPPINESS_ANON_ONLY;
 }
 
+/*
+ * The MGLRU counterpart to too_many_isolated().
+ *
+ * too_many_isolated() compares node-wide isolated counts against
+ * node-wide inactive sizes. It predates per-memcg LRU lists, which
+ * moved isolation to per-lruvec granularity. MGLRU reclaimers contend
+ * per lruvec, so this check is per lruvec as well, and isolation in
+ * one memcg does not throttle reclaim in another.
+ *
+ * The legacy threshold, the size of the inactive list, is not usable
+ * here either: in MGLRU the inactive counters are only a compatibility
+ * shim - they jump around when swap runs out or a memcg hits its swap
+ * limit, and proactive aging can inflate them. Compare against the
+ * total number of evictable pages of the type divided by MIN_NR_GENS,
+ * approximating the size of one generation - the same unit the
+ * original MGLRU aging heuristics used.
+ */
+static bool lru_gen_too_many_isolated(struct lruvec *lruvec, int type,
+				      struct scan_control *sc)
+{
+	unsigned long isolated, evictable;
+
+	if (current_is_kswapd())
+		return false;
+
+	if (!writeback_throttling_sane(sc))
+		return false;
+
+	isolated = atomic_long_read(&lruvec->lrugen.nr_isolated[type]);
+	evictable = lruvec_type_evictable_size(lruvec, type);
+
+	/*
+	 * GFP_NOIO/GFP_NOFS callers are allowed to isolate more pages, so
+	 * they won't be blocked by normal direct-reclaimers, forming a
+	 * circular deadlock.
+	 */
+	if (gfp_has_io_fs(sc->gfp_mask))
+		evictable >>= 3;
+
+	return isolated > evictable / MIN_NR_GENS;
+}
+
+/*
+ * Unlike the legacy path, where the LRU list to isolate from is known
+ * before isolation, isolate_folios() picks the type from the refault
+ * feedback and may fall back to the other one. Therefore, instead of
+ * throttling on a single type, collect the evictable types that do not
+ * have too many isolated folios, and only sleep when all of them do.
+ *
+ * Returns the mask of the types isolate_folios() may isolate from, or
+ * 0 if reclaim should stop. Also sets @fatal to tell the caller that
+ * the task received a fatal signal while waiting.
+ */
+static unsigned int throttle_evictable_types(struct lruvec *lruvec,
+					     int swappiness,
+					     struct scan_control *sc,
+					     bool *fatal)
+{
+	unsigned int allowed;
+	bool stalled = false;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	int i;
+
+	*fatal = false;
+
+	for (;;) {
+		allowed = 0;
+		for_each_evictable_type(i, swappiness) {
+			/*
+			 * A type with no evictable folios has nothing to
+			 * isolate. Don't allow it, otherwise reclaim can be
+			 * redirected to it and spin making no progress, e.g.
+			 * when the only type with folios is over-isolated.
+			 */
+			if (!lruvec_type_evictable_size(lruvec, i))
+				continue;
+
+			if (!lru_gen_too_many_isolated(lruvec, i, sc))
+				allowed |= BIT(i);
+		}
+
+		if (allowed) {
+			/* Wake up reclaimers waiting on the isolation to go down. */
+			wake_throttle_isolated(pgdat);
+			return allowed;
+		}
+
+		/*
+		 * All evictable types are over-isolated. Like the legacy
+		 * path, wait once for concurrent reclaimers to put their
+		 * isolated folios back; give up if that makes no progress.
+		 */
+		if (stalled)
+			return 0;
+
+		stalled = true;
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
+
+		/* We are about to die and free our memory. Return now. */
+		if (fatal_signal_pending(current)) {
+			*fatal = true;
+			return 0;
+		}
+	}
+}
+
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
-			  struct list_head *list, int *isolated,
-			  int *isolate_type, int *isolate_scanned)
+			  unsigned int allowed, struct list_head *list,
+			  int *isolated, int *isolate_type, int *isolate_scanned)
 {
 	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
 	int total_scanned = 0, scanned, tier;
 	bool tried = false;
 
+	/*
+	 * The preferred type may have been excluded by
+	 * throttle_evictable_types(); start from the other one.
+	 */
+	if (!(allowed & BIT(type)))
+		type = !type;
+
 retry:
 	tier = get_tier_idx(lruvec, type);
 	scanned = scan_folios(nr_to_scan, lruvec, sc,
@@ -4937,9 +5059,11 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	/*
 	 * We are running out of the current reclaim type. Fall back to
-	 * the other type if allowed.
+	 * the other type if allowed. Only fall back to a type that is
+	 * not throttled.
 	 */
-	if (!scanned && !tried && type_fallback_allowed) {
+	if (!scanned && !tried && type_fallback_allowed &&
+	    (allowed & BIT(!type))) {
 		type = !type;
 		tried = true;
 		type_fallback_allowed = false;
@@ -4973,18 +5097,36 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	unsigned int allowed;
+	bool fatal;
+
+	allowed = throttle_evictable_types(lruvec, swappiness, sc, &fatal);
+	if (!allowed) {
+		/*
+		 * We are about to die and free our memory. Like the legacy
+		 * path, pretend some pages were reclaimed so reclaim
+		 * unwinds quickly instead of looping back into the
+		 * throttle.
+		 */
+		if (fatal)
+			sc->nr_reclaimed += SWAP_CLUSTER_MAX;
+
+		return 0;
+	}
 
 	lruvec_lock_irq(lruvec);
 
 	/* In case folio deletion left empty old gens, flush them */
 	try_to_inc_min_seq(lruvec, swappiness);
 
-	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
+	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, allowed,
 				 &list, &isolated, &type, &type_scanned);
 	nr_isolated = isolated;
-	if (nr_isolated)
+	if (nr_isolated) {
 		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
 				      nr_isolated);
+		atomic_long_add(nr_isolated, &lruvec->lrugen.nr_isolated[type]);
+	}
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -5047,6 +5189,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	atomic_long_sub(nr_isolated, &lruvec->lrugen.nr_isolated[type]);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + type, -nr_isolated);
 
 	if (nr_isolated > total_reclaimed)
-- 
2.43.0


