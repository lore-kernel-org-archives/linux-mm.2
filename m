Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 869B9CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E3E6B0088; Thu, 15 Oct 2026 04:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A79A6B008A; Thu, 15 Oct 2026 04:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648546B0096; Thu, 15 Oct 2026 04:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0796B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:02:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9347120912
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:02:23 +0000 (UTC)
X-FDA: 85324118166.28.0D36458
Received: from mta1.migadu.com (out-119.mta1.migadu.com [95.215.58.119])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4BE8EA0005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:02:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VEg0sEhc;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.119 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792051340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tAj7rWN40kf/ZDFiiwg91YpVhCoua+BUX/YGkmsW2rw=;
	b=VscbwofzoUo2QXgvZ1YMZJLITik1w8p00MTZUwDBjFBr2XWs3QXModGGFwOGf0zGtiAItW
	YcT2lHgmce18Pmn86b5Bg8r1y/82VdmZbOHrQEaXnjEJ0EoFFazNplVJ6iaSBUJDbg+N3P
	yEzO+/1lmiz4GVXlDmOzvqGD9xMldGo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VEg0sEhc;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.119 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792051340;
	b=UehxlSC9zacjXYPwXiOp0TxdNtI8hzJt2Dfsll2qgPShn6QT+sm7HPIRqGjvIkc6t3vFLK
	HTCDVuAueKnULSIm3/wuQhKzFW3XEpVdSOGpoFroO1Kw/1QB2yZmI2bmo9G+pH/vPDNHH3
	1LuYProJCuXM/nQYO3aN7UEwK0KxN48=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OCxGFwZa9J0X5mCj29suMstPAJFR0LqYTe5IlggKadM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792051337; v=1; x=1792656137;
 b=VEg0sEhcs7ORo+UQIhCFSmeG2mpAWCE1pVCS5Tjc9AVPhAz3VC6dSdW7RM0BwLAWY2xW7PbH
 K2suYBhn/grRTwDopa5wBVifWmvAXlvr1RBCDXO9rxbm0k3zqmzrvdXW3Cgn3dIQU50mKcNYShg
 m57WzVgiEZKuushte9I01v68=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 8d35fc81f45d6c6b;
	Thu, 15 Oct 2026 08:02:17 +0000
X-Mizu-Trace-ID: 8d35fc81f45d6c6b
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
Subject: [PATCH mm-unstable v7] mm/vmscan: throttle MGLRU eviction when isolated folios pile up
Date: Thu, 15 Oct 2026 16:01:57 +0800
Message-ID: <20261015080157.269079-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4BE8EA0005
X-Stat-Signature: n39zfphm5dt3n666tohnq6fq1u834qg3
X-HE-Tag: 1792051340-185619
X-HE-Meta: U2FsdGVkX1+fxcEGpexAx0b1Hg6Kxvs22q6/yVXgIjkpbM/T8vFySGF9+O/DqdQ510vyIcueza+1EaXNUM4NbPaJi9SkopfA8Rtxm7NlK8BVJPyOm9EyWbCMmrOdFwD1PAbqq8Na2CvMNW5ZCs8VeH08hT/BYH7Gw+xENpOEtrO4qz4bwaa49PgJKvuCta1bcRnS7OOfrF4W+GzUlH3vQriS2oYaLEMy7+DK/Zf07MK408MNmDj6I3VhdKRwft4k0GlSkelZ8FGIaRW7i/usGGhKK09ZzMFkrAB/zMOWPIhMOra/0WbWgpztWaCj7fIGp1m3EXd2JmY2DKsMl2T0BKfnHgLFBTWA16Bu7+3wb22C2bLN8nI7Ywyf15AYfv2XjhHAHRfodVJ9PN766M9hukaVueBXzSNvu0swaUGec49N79LRQkwcOT3qKOqOu+lVJecTggd6ePFKW+WMRpXl/RA/Z7vefPR3m0YDRSCyaGQULoeOdZxsNwFBXA2SsGYUAwHlji1T/AGN/4PcBhylq+OizlweKQEdMcmmHcS0x4qNfJ+vks61UJ2ViMc3V/INkC1Cb6BjKgOIJVnQz9/yB0XnvuaDM314XLE0drTuyrZMnE+IpJOKYz6zZc8lKnfwt2HEL1lxDPJEwXFXiAYIC4QPl515v1KLbVU0XdF0v3Z1/PKyvI5+zB54cfZxXJNQYDaPABjIldzxgTW3+KfXCQ0X46RyAS1OwWRIkUGQLr11wZDjt9zjAYMzLKlV5KMOWJdHXvbjzfyXjMBYvcKBSmULEE6XZDEOlBWgK8O6kZA9e0cIk8EbpybB28z3ORUHETS3jv5deNq1eU/p7/up91VAEAdaaBVfY+1iT/gvxOf3pXcyh9wlxE4N0Ww6pum5vBStU/epb2qER21GdXgT1n32rhpn5EfEP6zEpsjEBrkwOnVTNvujRa1456LEsi+ykTXCO7seRN/xFgVGqp2
 I3EIHly7
 OrfNfOgJBaUUO8jwOcONYV31iA6/y+JWg9GzMFNX3G4yFQ2PBPxbL9S7MzwHWzA2QZUlItQ5/7BCtrD+qwrQkNhhUnb4i8JrqdLVFIxy/J8WxpqnO7/KCdQIZOUDDm4stVOEls4VNg5Ya8goS4N3HLvlKVqJgvLYea206AXYB/7BjWmZ1xpBuPDUQrfCvqCuHgkuGmS9VQeD7UUjyYt+Ao+B93OkRcTfh/9Kt17xXOxmxdC7fn+iwAErw9m4N+nji5jju
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

An lruvec with no evictable folios at all is not over-isolation:
reclaim stops immediately instead of waiting. Without this, allowed == 0
would conflate "all types are empty" with "all types are over-isolated"
and send the reclaimer to sleep, and since the kswapd exemption lives
inside the per-type check, which empty types bypass, even kswapd would
stall on an empty lruvec.

Like the legacy path, kswapd and !writeback_throttling_sane() reclaim
are exempt, the threshold is raised for GFP_NOIO/GFP_NOFS callers, and
a dying task fakes progress to exit reclaim quickly.

This builds on the recently merged NR_ISOLATED accounting fix for the
MGLRU reclaim path, which makes in-flight isolation visible in
/proc/vmstat; the throttle itself uses a separate per-lruvec counter.
The nr_isolated numbers in the test results below therefore come from
that fix rather than from this patch.

Tested on a 10 CPU / 8GB QEMU guest, cgroup v2, MGLRU enabled (0x0007).
"unpatched" and "patched" are the same tree built without/with this
patch; every configuration is run with identical parameters on both
kernels. Test scripts:
https://gist.github.com/teawater/3ef51251f2e91a5a600e3d26bb477e34

1) Synthetic (mglru_iso_repro.sh, mglru_iso_repro_v2.sh): threads
   write-touching a 48MB anonymous working set inside a 16MB memcg,
   with swap on a dm-delay device (50ms) to slow swap-out and lengthen
   the isolation window.

   64 threads, 60s - neither kernel OOMs at this concurrency; the gain
   shows in reclaim quality:
                          unpatched       patched
     OOM kills            0               0
     total touches        246,499,132,369 301,456,426,692 (+22%)
     scan efficiency      0.0261          0.0194
     mm_vmscan_throttled  0               35,645 (all
                                          VMSCAN_THROTTLE_ISOLATED)
     nr_isolated peak     0               230

   The patched kernel completes ~22% more work in the same 60s: the
   throttle keeps concurrent reclaimers from trampling the same
   generation, so less CPU is burned in reclaim.

   192 threads, 60s - over-isolation becomes fatal without the
   throttle:
                          unpatched       patched
     OOM kills            1 (task killed) 0
     memcg oom events     51              0
     total touches        0 (killed)      682,300,039,725
     mm_vmscan_throttled  0               512,292
     nr_isolated peak     0               335

   The unpatched kernel cannot keep reclaim ahead of allocation and the
   task is OOM-killed; the patched kernel survives the full run and
   keeps reclaim making progress.

2) Real workload (mglru_build_repro.sh): a CI-style build pod -
   repeated from-scratch "make -j20 vmlinux" rounds inside a
   memory-limited cgroup, with the object tree on ext4 over dm-delay
   (10ms) to model slow storage. 20 concurrent compilers charge into
   one memcg and enter direct reclaim at the same time, while dirty
   object files stretch the isolate->shrink->putback window. Each
   kernel runs 1800s per pressure level and the metrics are cumulative
   counters over that window, which smooths run-to-run noise. The
   headline metric is the number of objects actually compiled (a full
   round is ~3,800 objects).

   memory.max = 1024MB (extreme pressure):
                          unpatched       patched
     objects compiled     4,744           7,211 (+52%)
     pgscan_direct        2,901,083,521   2,228,776,807 (-23%)
     scan efficiency      0.195           0.242
     workingset_refault   565,169,241     537,686,479
     mm_vmscan_throttled  0               511,441 (all
                                          VMSCAN_THROTTLE_ISOLATED)
     nr_isolated peak     0               1,152

   memory.max = 1536MB (heavy pressure):
                          unpatched       patched
     objects compiled     18,969          25,124 (+32%)
     pgscan_direct        1,223,905,508   816,812,074 (-33%)
     scan efficiency      0.320           0.338
     workingset_refault   390,048,986     273,442,445 (-30%)
     memcg charge fails   8,344,775       5,868,167 (-30%)
     round wall time      199-391s        182-275s
     mm_vmscan_throttled  0               503,117
     nr_isolated peak     0               1,053

   At both levels -j20 is oversubscribed (20 cc1 processes need ~3GB
   of anon in total), so rounds end with a cc1 being memcg-OOM-killed
   on either kernel. Normalized per completed round the kill rate is
   the same (13.2 vs 13.1 at 1024MB, 5.8 vs 6.1 at 1536MB); the
   patched kernel simply reaches that point sooner because less time
   is burned thrashing, so it cycles through more rounds. This patch
   does not claim to avoid those OOMs - the point is that it performs
   23-33% fewer futile LRU scans and gets 32-52% more build work done
   in the same wall time.

   memory.max = 2048MB (light pressure - no-harm control):
                          unpatched       patched
     rounds completed     6               6
     avg wall time/round  271s            270s
     scan efficiency      0.984           0.978
     mm_vmscan_throttled  0               0
     nr_isolated peak     0               144

   When reclaim keeps up the throttle never fires and both kernels
   perform identically, so the check costs nothing on a system that is
   not over-isolating.

3) Service no-impact (mglru_redis_repro.sh and
   mglru_redis_shards_repro.sh): a redis-server serving a 1KB-value
   dataset larger than its 96MB cgroup, with swap on dm-delay (50ms) -
   first as a single instance (100k keys, 200 clients), then as 8
   shards with AOF persistence on a second dm-delay device sharing one
   cgroup (8 concurrent chargers). The bottleneck here is swap-in I/O
   serialized on redis's single command thread, not isolation
   contention: charge-induced reclaim is a trickle (~400 scans/s vs
   10^5-10^6 scans/s in the build runs), isolation never piles up, and
   the throttle correctly stays dormant on both kernels:

                          unpatched       patched
     single instance      41.6 ops/s      41.2 ops/s
                          (avg 2999ms)    (avg 2999ms)
     8 shards aggregate   333-419 ops/s   310-358 ops/s
                          (mean 376,      (mean 335,
                          4 runs) (*)     4 runs)
     mm_vmscan_throttled  0               0 (all runs)
     nr_isolated peak     0               0

   (*) the aggregate is dominated by a preload-end residency lottery
   (which shards' datasets happen to stay hot) and swings by up to 26%
   between runs of the SAME kernel; with 4 runs per kernel the
   difference between the means is within that noise (Welch t=1.95,
   p~0.11). The throttle never fired in any patched run (the tracepoint
   covers preload as well), so both kernels execute the same reclaim
   path here, and the kernel-side counters agree across all 8 runs:
   steal/scan 0.59-0.63, swap-ins == refaults, zero OOM. These runs
   document the no-impact side: the check is dormant unless isolation
   actually piles up.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changelog:
v7:
Patch 1 was merged into mm-unstable, so this is resent as a single
patch.
According to the comments of Sashiko, Return instead of waiting when the
lruvec has no evictable folios at all: allowed == 0 previously conflated
"all empty" with "all over-isolated" and stalled even kswapd for 20ms.
Move the v6 cover-letter test data into the commit message.
v6:
According to the comments of Barry, add real-world workload tests:
a CI-style kernel build (repeated "make -j20 vmlinux") inside a
memory-limited cgroup with its object tree on dm-delay-backed storage,
measured at three pressure levels (1024/1536/2048MB), plus redis-based
cache service runs (single instance and 8 shards sharing one cgroup)
as no-impact data points. New and updated test scripts are in the
gist. Rebased onto the latest mm-stable; patch 2 is adapted to the
current isolate_folios() type-selection context (is_single_type_
reclaim()), with no semantic change. Re-run the tests and update the
test logs.
v5:
According to the comments of Kairun and feedback from the test scripts,
make the throttle check per lruvec (new nr_isolated counter) and skip
empty types in the allowed mask.
v4:
According to the commens of Baolin and Barry, rework patch 2:
drop the throttle_is_throttled() helper extracted
from shrink_inactive_list() and leave the legacy path untouched.
The new MGLRU-only throttle_evictable_types() only sleeps when all
evictable types are over-isolated - v3 throttled as soon as any of
them was, which unnecessarily blocked the reclaim of the other type
and passes the mask of the remaining types to isolate_folios(),
which restricts both its initial choice and its fallback, so that
isolation never lands on a throttled type.  The v3 gate did not
constrain the type actually isolated, so the fallback could still
pick the over-isolated one.
Re-run the tests and update the test log.
v3:
According to the commens of Baolin, remove the redundant nr_isolated
check before restoring the NR_ISOLATED_* counters in evict_folios().
rename the extracted helper to throttle_is_throttled() to avoid
confusion with the existing wake_throttle_isolated() naming space.
Use for_each_evictable_type() in the MGLRU throttle to check each
evictable type's isolation instead of only the type returned by
get_type_to_scan(), since isolate_folios() may fall back to the
other type.
Re-run the tests and update the test log.
v2:
According to the commens of Kairun, Rebased on mm-unstable.
Split into two patches; patch 2 is new and adds the
too_many_isolated() throttling to the MGLRU eviction path, which v1
did not cover.
Add test infomations.

 include/linux/mmzone.h |   2 +
 mm/vmscan.c            | 184 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 172 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3b96d6c7123b..7759a53326ba 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -564,6 +564,8 @@ struct lru_gen_folio {
 	/* can be modified without holding the LRU lock */
 	atomic_long_t evicted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
+	/* the number of folios isolated from this lruvec and being reclaimed */
+	atomic_long_t nr_isolated[ANON_AND_FILE];
 	/* whether the multi-gen LRU is enabled */
 	bool enabled;
 	/* the memcg generation this lru_gen_folio belongs to */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index daa7e37c2236..36887117d76a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4332,25 +4332,34 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
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
@@ -5012,16 +5021,142 @@ static inline bool is_single_type_reclaim(int swappiness)
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
+	bool has_evictable;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	int i;
+
+	*fatal = false;
+
+	for (;;) {
+		allowed = 0;
+		has_evictable = false;
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
+			has_evictable = true;
+
+			if (!lru_gen_too_many_isolated(lruvec, i, sc))
+				allowed |= BIT(i);
+		}
+
+		/*
+		 * Nothing evictable at all is not over-isolation. Stop
+		 * reclaim instead of waiting, so that nobody - including
+		 * kswapd, which is exempt from the check below - stalls on
+		 * an empty lruvec.
+		 */
+		if (!has_evictable)
+			return 0;
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
@@ -5036,9 +5171,11 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
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
@@ -5072,18 +5209,36 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -5152,6 +5307,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	atomic_long_sub(nr_isolated, &lruvec->lrugen.nr_isolated[type]);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + type, -nr_isolated);
 
 	if (nr_isolated > total_reclaimed)
-- 
2.43.0


