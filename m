Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E3AC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB44D6B009E; Fri, 18 Sep 2026 04:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C956B009F; Fri, 18 Sep 2026 04:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2E56B00A0; Fri, 18 Sep 2026 04:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE5296B009E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:08:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 256B5A5F85
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:08:02 +0000 (UTC)
X-FDA: 85226154804.10.4F78AD8
Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	by imf12.hostedemail.com (Postfix) with ESMTP id DB4F540006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:07:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UnTZtOnD;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789718879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCFABxsMSfE7mS6/0hb3FkS3T+oQJeq64MpOxx1VmVU=;
	b=qxfBc+P6LfADWrZIX2eBKJaT5RbRU/Y50MK6Z9e1fm6ranhx/z2042OAFN2Kq2GCa2EYT9
	Ft4MzBZ66Pnx3u+2np7qJYYOTtu3nwO9vDh8zyX6d+pjzLTMSZxIv9Gzup20DbRbCXfafw
	122mvLalH5IZT4KtErcKX13vAb6c5JI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789718879;
	b=0gy6ljm4tNA5hK+5dRCDn0OMdkHbEJlhhvAcbehxTxNtfE+cOO8ixLjTG1b7zO6YRPdakj
	IP9LPYtDXsIztAPafZSsIACPQ9XnBcBuvoTXFfaaV9lNZFH0P3thm0Uqvfq2cnOSlmGZy6
	AvsnY8xe7JlAdRCMRgKgVwt//O4jmN8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UnTZtOnD;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0UjcZhYfc+O5Atyz9a0Brv7iresSSLj+ffFHoxxhzNc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789718877; v=1; x=1790323677;
 b=UnTZtOnDS7sXafiyiHuPgRKAatUyqam37zWTkSffPRPg9qKHK2h4JKR3fShDRkd5GQcBZLSW
 kiqhzl9AyoqW0ZpRJq/3NYp7+C3KKtnLpN3lkiMl64yXNEP8VA5VsEGlpOJhdCgHsUGjnCZZOlY
 tmjMTEObL20HLs0F6D1lE+r4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id d3874e811b0d27b4;
	Fri, 18 Sep 2026 08:07:57 +0000
X-Mizu-Trace-ID: d3874e811b0d27b4
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
Subject: [RFC PATCH RESEND v5 2/2] mm/vmscan: throttle MGLRU eviction when isolated folios pile up
Date: Fri, 18 Sep 2026 16:07:20 +0800
Message-ID: <3dfcfefe809c4391b425ea3ae73ad86f36fde42a.1789718658.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789718658.git.zhuhui@kylinos.cn>
References: <cover.1789718658.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ujr51xk4iai5bsanostf5okxcify1omt
X-Rspam-User: 
X-Rspamd-Queue-Id: DB4F540006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789718878-63203
X-HE-Meta: U2FsdGVkX1/hAwBRBC17D1Xwug836ijtwPdNM/SQQF+MmlZ8PEqzqtSEFR/vunWkm8Vftp/M2QDWyKe2Hvcxl6FUo18dN9bvOQOZaDmrxJHeiqM7pxT51vVgCs4a/4if19zlC3Ug+eKg0yiI8HnzNcXCNJ943CpNflituVmigGEPP3yrRb9fCF5sPK4n5+YfKuYmMCUWbP2jJ9Vr+1mb0hCx8brSPaNWU1PHEZKSQDvxfcyFMsWusf4S5v2GLhUhpYtzuMQzwumuEB0Rv+/Lau+Ngt3PtqYq7JoKvDyeWjh+p5U5KwLDTM6xSUB4M5uY/jj+6GX2xcGnaG5aDRdKEHBEipe5vXchw3QYby78S/s0c7Q7yl2Iu4De4HEHLEr0QbJGQ6Elvqij63pThbHr/kxdeY07U0JTyS0fdyem2StEfT6bvXY4oMRB8Q5e2SW4B3oSEcM9+6w7DArMXndVLwHd4TR73AlkCHD5wftForC0sT2B/M42ZnmkHIhR1NKpM8fMOQ7EFRAo4uG1xDKJUzEBHsU3oLgpQO971ZCatowVmPtHr4gc4WauITE0CdkO7APlaZAweovWXWlmclBPy7C6vuc6zrvVIydzRafYFcRca1efO4IJ0v4yyho3wgch0yO1FfFET+UmLCl3J0n7S9IG51CYWlmrXHT/Q08cIRUDf0+4NQwPdTjNLADBx3K6piGd/0ogauaSEn526ip+zqOrGueS7C+8A1EpMhb3jcsFv0T5XHEK+wabbdKhlc/ia7V2gyDtXGL4yhCYO2m/FM2SvC/v0kgD/ABt4EhS3h/Jc5/PbVTl7K+UJsYY4cDvx6oP0e4vtWBb+TIrykW57FkuA7TBQ19H2fbJlKXYL09uP+Dq0XLoWq3FTLWiO78UJlEJdfC3BKIUoaRfe2OTwPtxw704qy7WltG4H6gPa/TNCMN/GmeznUaukISqU/zLwe2swg6525zE6busJiN
 8YjcLQoO
 5G14+VFyYsHitI9gafRIX35IkkaHBjqou+9aPk5NEi5YxSqf7fO0hMplxG2fgAJmd4Wcy2SPft+nwQLL8zf03BR6SiVdWPzanF0/Li0HC5CiVmDbDVRMYhzX1V0Sk+jbJnSKVAi4Z9kr57WxbFh6D2ipPk1UDN6z0Mc6gzwox9cYL3MhXdCVicbC0AvfC2f66ELBE
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
2.43.0


