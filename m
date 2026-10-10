Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAF72CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 14:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5016B0088; Sat, 10 Oct 2026 10:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675DB6B008A; Sat, 10 Oct 2026 10:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58B4F6B008C; Sat, 10 Oct 2026 10:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35CC56B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:11:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B705EA0775
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 14:11:24 +0000 (UTC)
X-FDA: 85306904088.11.105AB80
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8B0D918000E
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 14:11:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=TCKkzR2e;
	spf=pass (imf06.hostedemail.com: domain of liuxiang.277@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=liuxiang.277@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791641483;
	b=0c/C/k7nIVecMl1SrRGQrKf6CEjoq8Z2c/saBsOBtY3BtvG7s3yxF5AKgF8y9JaVJY8SE/
	DGmgxvhr9etfrAM4RpEeh5+rw4eH+9tltbMcF7/GC+VpdlJY7V1mGD3VO9AAlLeUUTG38d
	kbm/BGqyOJa2cAgZ3z8+RXvBLHpBkH0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=TCKkzR2e;
	spf=pass (imf06.hostedemail.com: domain of liuxiang.277@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=liuxiang.277@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791641483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gAw1yoBwYrHHnkQw1kW2SvtZr9cN7fK/HvMTNhkkolI=;
	b=d/Aqzg1NNIQzbOnrwov/jNUQOdl3tIagE3/PP6gLeJai+iRcqtcEzTBhepsrHJSKEA1lSq
	JwCBggi/WxwXY9Ej5inNNUcLy6y9VyTMizxx9QkDoFZViOvHXgvsoycULTZRuZXpIfeW+B
	JCwmM+KDle68imh4yqnCEp6wJLPMIY0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791641474; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=gAw1yoBwYrHHnkQw1kW2SvtZr9cN7fK/HvMTNhkkolI=;
 b=TCKkzR2ec0XhBi0BNCn922OyderqdsJwXK7+IhdtG1imTXwtfNbHAJX7XIonnSE54sQUP9
 F2fKYhl6+Xmu2NEde2KiNGAzqKKxLU6xxrWwaC+XP3Wy87fFXdMZoSZd7SHgbCMTciSIA2
 XZAxrE4wqNJZin3EQsLvftDx7bU5vwrG6wzaHm4XNmF/royW8EfJbDhUORZWVI1ryHwAjB
 azCC37lWhXHb/X6b1CsdWfsQpFZDqYmcw08KdN+3m5cA0l8T72bj7z5KUlaw/FqesJ53DZ
 LGqIUsvO4BuhwtvMgWXbWIh1/oW4MqnnFr6FNnmsNAq7LivZamhAqsKOMOiK7Q==
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 7bit
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<kasong@tencent.com>, <mhocko@kernel.org>, <hannes@cmpxchg.org>, 
	<baohua@kernel.org>, <zhangbo56@xiaomi.com>, 
	"Xiang Liu" <liuxiang.277@bytedance.com>
Subject: [RFC PATCH] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache in MGLRU
Date: Sat, 10 Oct 2026 22:10:57 +0800
To: <akpm@linux-foundation.org>
Mime-Version: 1.0
X-Original-From: Xiang Liu <liuxiang.277@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Xiang Liu" <liuxiang.277@bytedance.com>
Message-Id: <20261010141057.599595-1-liuxiang.277@bytedance.com>
X-Lms-Return-Path: <lba+26aca4780+f8d92c+kvack.org+liuxiang.277@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B0D918000E
X-Rspam-User: 
X-Stat-Signature: j1t5mg1mp1uuo8jotccufg4xgrj43cwy
X-HE-Tag: 1791641480-608487
X-HE-Meta: U2FsdGVkX1/0Gi304yAbPfajIGeUtE1IqtkMJDK8z6wFQDQn0yGouX/+ebNpBne23FVwLHiuUZ2D+/jwwobVMjK1e7DnIA3C7TxLPLObN5/m0MxJR8GGlbKmxM0tJ/kN6y3I2thpUwIlCZPH83AcEToAVpUkJqbP0sgOWstBGzm6BnP5E38watzATQqT2SKtA4iD7ZgYz/UIxO29JEP1qgzGolIRexG7CS+yIBmv+eBSswcsMrTQ9IJhdRZPtw1d84r5A2HiuLBX5ig2wWVarnhIhVSjvikEf4r6FZnsukPsnPyJ9XLVHf31SD11Ax5vZsMSCQVzTCHKWhH2lxKUemATUy195Q0ebLV75BC/Fh5lPxvp6Gr/buPBj7N1n1PUXdzVj35pHy9paEDtm/jixy7PNr6J/QS5BBGbwAUv15bQ1m6UcyIg8j4MJSA+HpejKws1z7Z0Cg67CUE9mFgBwV7j0DYKbk8KT/9a8ehhKrPrTork5ilk0x7kGDX3Y2dz+wzRvlgc+sqUZ9vVf/eA1/tWtQdipSfgJdAUJucYrZ5d6y4MUdksvVcrQfrhlGY4ngBfplYf9Q8NI/FssCnlDTooDQmpomEvioJu4bjbs7GwhpYUJml07hrjcQzqoxE2k4/XiJ4a6LVHdk2QO67XCajQnW8tFzzJgZGcCwBbzEAZV+APSK5wOXHG4akmSPdSQxaYZKHbkBwwnnzGrJI3oZwI322y6OPfvUaLOb2Ogp8S7gDpr3Z5Tphn0XbgVT/RQGeNqqNEvNWyXTKAGSuWCsjO0ir8dBdevDPkQtc/M58SdBsYMBXzb4gn9aLW+WhBs/uU+/HWJkxq36nZPF/em5SAOMnv3CGyWy+uA/FMF32N84K4Lap3cYAXCsOIr2uG12gahuxfnvo3c+n9IljgwnAAYVlezwhVbzYOufj2LzVXo/y0hbUGsj1t8YZjTSnM9wK+/ZDu+zGK5R/vSdL
 SEMsWsWu
 2NAqHcPlQUNGbSp2DsOmfezABGfZwKmUuByGrQO+xjk54XSOFfhqPlbhnB/KlUhv9bpKDhfF6mQmmBPY9fvxLpkl3acBFdg0NHFPPGez2exEd9IjKe1FJnKID1D7Jz1NFLTBcmbzhS18ql67uXaDBj2U70Ja/vYo7xHNe9sM0bLzrpEEg1QChMwW3itYxN/wX7HwGqWpFSSpfGCNukbUjmW3cMzhpB4Lz6Oxn2yFpPMeVNoe+0jaHgrL//eq8poKdy5N3u2kyfZB+8xwKr79D5njFd/aIpddlHMMePFKBCrxVbl4duOOIH2VEV8ZhjcIEj3ESr/TJlkUGyKKYyBUFmySgx4+uaKIvTXcJCGRWn7h0BMem33j3mfjsC33k+9h+XIaYWGbBXzJRi1saLggc2OVJFmt17LvpWO428ZNmmrEt+D4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bo Zhang's GFP_NOIO patch [1] addressed anonymous scanning with low
swapcache in the traditional LRU and left MGLRU as a TODO. This patch
addresses that remaining case.

Under GFP_NOIO, anonymous folios requiring swap IO cannot be reclaimed.
When very few anonymous folios are already in swapcache, scanning anon
can spend substantial time isolating and processing folios with little
reclaim progress.

Apply the existing can_reclaim_anon_pages() check to MGLRU.
lruvec_is_sizable() excludes unavailable anon from its size estimate.
In try_to_shrink_lruvec(), file-only scan_swappiness is passed to
get_nr_to_scan(), should_run_aging() and evict_folios().

The tradeoff is synchronous aging. With four anon generations and two
file generations, advancing max_seq can require moving the oldest anon
folios to the next generation. This patch accepts that cost to avoid
low-yield anonymous scanning. It keeps the original swappiness in
try_to_inc_max_seq(), avoiding additional use of the inc_min_seq()
single-type shortcut that advances min_seq without processing the
oldest folios and can cause cold/hot inversions.

Tested against the mm-unstable base-commit below using dm-verity
hash-block reads through dm-bufio, with unchanged NOIO allocation flags.

Allocation time spans alloc_buffer() entry to return with valid buffer
and data. Reclaim time is the time spent in try_to_free_pages() within
that allocation. Eviction and aging are the time spent in evict_folios()
and try_to_inc_max_seq() within that reclaim.

1. NOIO allocations under memory pressure

The workload triggered NOIO reclaim during dm-verity reads, with
generations allowed to evolve naturally. The table reports median
times for successful allocations that entered direct reclaim.

Time (ms, median)            Baseline  Patched
===========================  ========  =======
Successful alloc_buffer()     181.196    0.465
Direct reclaim                181.185    0.131
Eviction within reclaim       179.147    0.091

2. Synchronous-aging cost

Prepared four anon generations and two file generations, with zero
swapcache and pages in the oldest file generation. The tests varied
the oldest anon population to compare baseline eviction with patched
synchronous aging.

Each row reports a successful alloc_buffer() call and its reclaim
costs. Oldest anon is the measured population of the oldest generation.

Kernel    Oldest anon  Allocation   Reclaim  Eviction    Aging
                (MiB)        (ms)      (ms)      (ms)     (ms)
========  ===========  ==========  ========  ========  =======
Baseline     1755.266     131.704   131.699   127.985    1.672
Patched      1840.422      38.316    38.311     0.307   37.785
Baseline     4835.418     681.796   681.766   675.477    4.382
Patched      4813.180      91.161    91.140     0.450   90.407
Baseline     8941.582    1474.245  1474.202  1469.084    0.488
Patched      9012.660     143.748   143.709     1.026  142.341
Baseline    13104.676    1098.372  1098.354  1087.976    2.307
Patched     13046.621     139.450   139.390     1.083  137.954
Baseline    17187.043    2694.909  2694.902  2686.470    0.784
Patched     17124.902     209.240   209.233     0.638  208.270

Across these tested sizes, synchronous aging was substantially cheaper
than baseline eviction, and successful allocation time decreased.

[1]
https://patchew.org/linux/20260908062649.1045883-1-zhangbo56@xiaomi.com/

Signed-off-by: Xiang Liu <liuxiang.277@bytedance.com>
---
 mm/vmscan.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 29b31446fc11..550c16cad9f9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -379,13 +379,6 @@ static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
 	if (!sc || (sc->gfp_mask & __GFP_IO))
 		return false;
 
-	/*
-	 * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() for the
-	 * scanning type, so only apply this to the traditional LRU for now.
-	 */
-	if (lru_gen_enabled())
-		return false;
-
 	if (memcg) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
@@ -4357,6 +4350,13 @@ static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 	unsigned long total;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	int nid = lruvec_pgdat(lruvec)->node_id;
+
+	if (swappiness && !can_reclaim_anon_pages(memcg, nid, sc)) {
+		if (swappiness == SWAPPINESS_ANON_ONLY)
+			return false;
+		swappiness = MIN_SWAPPINESS;
+	}
 
 	total = lruvec_evictable_size(lruvec, swappiness);
 
@@ -5246,8 +5246,14 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	int scan_swappiness = swappiness;
+
+	/* Restrict scanning without changing the policy used for aging. */
+	if (swappiness && swappiness != SWAPPINESS_ANON_ONLY &&
+	    !can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->node_id, sc))
+		scan_swappiness = MIN_SWAPPINESS;
 
-	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
+	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, scan_swappiness);
 	while (nr_to_scan > 0) {
 		int delta;
 		DEFINE_MAX_SEQ(lruvec);
@@ -5257,14 +5263,14 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			break;
 		}
 
-		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+		if (should_run_aging(lruvec, max_seq, sc, scan_swappiness)) {
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
 			should_age = true;
 		}
 
 		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
-		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
+		delta = evict_folios(nr_batch, lruvec, sc, scan_swappiness);
 		if (!delta)
 			break;
 

base-commit: 55ff3dc8fced48c98667c19769c55103a23eabce
-- 
2.20.1

