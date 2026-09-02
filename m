Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 008CFC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100016B00CA; Wed,  2 Sep 2026 05:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7566B00CE; Wed,  2 Sep 2026 05:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6636B00CA; Wed,  2 Sep 2026 05:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C26686B00CA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:12:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6871A09F1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:12:14 +0000 (UTC)
X-FDA: 85168255788.27.36AD377
Received: from mta1.migadu.com (out-99.mta1.migadu.com [95.215.58.99])
	by imf02.hostedemail.com (Postfix) with ESMTP id A3D9580008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:12:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WQxnb1Qn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.99 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788340332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bve4OHLuwd8kvakx+wRH+4YISbHeix3UbXRjRI/cvdU=;
	b=8jUF71UO4HSXzhSfEiIpvP7nB+P1vnMK9A+JiXCveijIi1M0ZzIwj+R26vzjwAQFu+wpSp
	55I84M27SzJXxHwd+zrJxrzoIKuTRdavML+4+cflRf7bM2E63eRgrK2umcaP0WvsnWs7YF
	16ZedII6nihxOZYoLKX9d+6Kx9/fXwA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WQxnb1Qn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.99 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788340332;
	b=1n9WCtgC/lFRvHzO7YPA95AgVu5cpkFxhzNo6JdXOO7MglAk42dxVlmO+4DdYR0Zy/8IdT
	zJ07A7uue1HcacjXmaT41/gOG7cgcqaEc9eXNhtbY8dNGJaYcI4qTVhMo7Vl+qgzwJ3Net
	+cfI89aD82Lg8YHHhXR0W9W1iuV5w9U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5xV8ztEnZ6jxijrWoSRKEtSvwmLfTtZ6g4O9lPBwyng=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788340331; v=1; x=1788945131;
 b=WQxnb1Qnx41b1x+78xshMEChfC+UXbXVFZqzoTxnOXS1g32YwjaSSjXarwoVgj1WVVtSfQYO
 GwLgkq0aOccwOnrQJaSO785zfcSbXQ91d3kjhYXyDbxjrikgh8fqVdCi5bNkDbs5tUCTzJoFXJn
 OFrccp3ocJGBKkQwwDqyrPWI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fa3c778b352eda0d;
	Wed, 02 Sep 2026 09:12:11 +0000
X-Mizu-Trace-ID: fa3c778b352eda0d
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
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
Subject: [PATCH RESEND mm-stable v5 2/2] mm/vmscan: throttle MGLRU eviction when isolated folios pile up
Date: Wed,  2 Sep 2026 17:11:26 +0800
Message-ID: <b437bf8f3c405fc1ada32b1fd279c13abca2f95f.1788339549.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788339549.git.zhuhui@kylinos.cn>
References: <cover.1788339549.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3D9580008
X-Stat-Signature: zp6otk3azsg9umhkp9iiwobt7pbuemy1
X-Rspam-User: 
X-HE-Tag: 1788340332-906250
X-HE-Meta: U2FsdGVkX19FklGmKUaH5eMlS39xsBKEvkhoV06yyPvD0/xUHHB1/yEmvcSoE6MF+xDRhxmQ81NSG0V6/1ytcODqHdWQ7IkkDYnFBi/fkdVMJrHEXIprD+p/7tRlDacHz/yPUZ7EMZxdF6iFIpY97JpYsg5eNKkgUqr2U8pujl44AtlaVJwFaHBLnVk1HJbwliP2mQ80Ts6Aic8sgaCabSpoDziTxrBuuccb6a+NuzFK/Z5zVeQv31i1j+mxUtmdeI5j4xdmDHRKA9nDncPTkx/rrd5yib/pgw/q4s/7RpFHmfLLqvXFWAo1QmVhl0tSY+OAZgYTIN7aw1/RVU5HodSCgkssjyd0bD0BittvwG82/u89HHVS+quwflKzwzjcALMRnfoJ1BtwiyxhHci7Z8KUvDWAGdEGdCiA9Z4Y96aDse2sz6N2EUxHs6RY6VAn5FiwccaJuLxwdze2Xb8EasKVwWOjtPY9fMjld0fzgSC67d1LC9ZQNUybQfDg9w5LQjV923bUaLiTZRoz4tnbBwFdNjX1zq9I8w3cfFeBj1OuJ0BqaHLVmdfQU3q1EyU7M9Uock6RZkuAriEOd5Vso0ONaMbxv3g5YSkJ3CPqnm1xnwda29IrTVH2zK8qCNv1eW0laYizNaxL0PuRSalB5vB0c4IARrF3VVQYIH4z4rwGMJJWu2oK1ck+QGLj+Ds1amTjUIsBsEabHydPYEUjSGY+uwgCCtFnP3iogvH+wrRPN48m5Fd8exhzlemyY95WcAwhVYAPhUzbN1fqArOC4/1+qg26ZFF+3hks2Dv6wFPLW2+BzZAofa4TcS07jCeO8h4I/NG2snVdoGgheoJyEpkE0MGnkGrabRkqJQaTMrmY5YqIL4ce2FQs9Wn8LqgpCNLKF4xXjSBMHAYVvCkaPaX0lr/GXQF5V/GKv5nPGZ8DK7D7qEWq2BNqZfghhaFBPp5i9bdKMSn30Ogs6Eq
 nilOgv7V
 IcVhn7VEN3e2Ca3itsrU5vlaEUYK/Lb29O9OhLhWsFQHpAYrIjbE/J1VAyVf0Sr1oqDFQASIMtVvYekB2lOCCa/2JChSppNVLFlwuO+2ydOERchS+BQV+3Q712pLOmDT4MDBh8i6PHDzwCUGegaWUGFWsplY0lFD5UuUosqOF0ywq6HqKabpT28y4JDdOteaAgaF9
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
 mm/vmscan.c            | 170 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 158 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..819b6c059116 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -580,6 +580,8 @@ struct lru_gen_folio {
 	/* can be modified without holding the LRU lock */
 	atomic_long_t evicted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
+	/* the number of folios isolated from this lruvec and being reclaimed */
+	atomic_long_t nr_isolated[ANON_AND_FILE];
 	/* whether the multi-gen LRU is enabled */
 	bool enabled;
 	/* the memcg generation this lru_gen_folio belongs to */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3936c553c63b..211839d10909 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4151,25 +4151,34 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
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
@@ -4838,15 +4847,128 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 	return positive_ctrl_err(&sp, &pv);
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
 	int i;
 	int total_scanned = 0;
 	int type = get_type_to_scan(lruvec, swappiness);
 
+	/*
+	 * The preferred type may have been excluded by
+	 * throttle_evictable_types(); start from the other one.
+	 */
+	if (!(allowed & BIT(type)))
+		type = !type;
+
 	for_each_evictable_type(i, swappiness) {
 		int scanned;
 		int tier = get_tier_idx(lruvec, type);
@@ -4863,9 +4985,10 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		/*
 		 * If scanned > 0 and isolated == 0, avoid falling back to the
 		 * other type, as this type remains sufficient. Falling back
-		 * too readily can disrupt the positive_ctrl_err() bias.
+		 * too readily can disrupt the positive_ctrl_err() bias. Only
+		 * fall back to a type that is not throttled.
 		 */
-		if (!scanned)
+		if (!scanned && (allowed & BIT(!type)))
 			type = !type;
 	}
 
@@ -4888,18 +5011,36 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4962,6 +5103,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	atomic_long_sub(nr_isolated, &lruvec->lrugen.nr_isolated[type]);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + type, -nr_isolated);
 
 	if (nr_isolated > total_reclaimed)
-- 
2.53.0


