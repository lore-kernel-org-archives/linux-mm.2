Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22335FEDA11
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D85A6B00A8; Tue, 17 Mar 2026 15:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFD56B00AD; Tue, 17 Mar 2026 15:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79FA06B00AE; Tue, 17 Mar 2026 15:11:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65E586B00A8
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:11:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DBEFC1849
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:53 +0000 (UTC)
X-FDA: 84556499706.17.EC247A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1717D140012
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u8RVzOmA;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774711;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkcnOvsMG++crdNeiMpB27QWvGUE1LnOFtiSJVWOkNw=;
	b=jhcPqHcTPgXzHhuJTgl1tiAgUvkxsO02zHDWGw/DVxMz/87HHL2fgzQTsUR+cA1WAo5iOf
	BYTCbjmBUbvkrSVTDmjOkHaL5GuLmA/g2N47lnzLTAbbUha8jouQtRjlkQED7eZJX9kGPH
	4H8uFGputHjrfpNknhYWtrpWqN30Th8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u8RVzOmA;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774711; a=rsa-sha256;
	cv=none;
	b=1HSJAkiiXu15U0WFT8l4hrKjCtv77uBFzIc0A3hDbw5Ro0MdfgbhAn1XyWJeDpzPHdgvL3
	z1nmoxZgHQEgeAaz/wc54erRpgacAjsNDVt8/c6BnTYWpV0dZETFG/uZHAGH2l451LFppE
	WmM9iF/m4mCxydeZBi35hxIh1GjaCcA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4665C4450B;
	Tue, 17 Mar 2026 19:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D66EDC2BCB2;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773774706;
	bh=6qAo9p0pvAkaB9lu02Jrlp6+eUUnzdgMv9MWD/iqd7I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=u8RVzOmAoJ8+AxaX321ioH1GMRWNUk1MIuq4KaOzGy4+Zx6+qsQ6WLF/IrR9cdfVq
	 LgRZp8AI3J4zbqvToXdI1dcGAAufcwEUKnQmNKytQm7lBeGk6P/pVN09a1OUIwW1QB
	 0X/pHoWpmbkZD3DvtBqUFoFQOMtie74jdyvq6BA8rp2LOZmBQ5PXHG+VAbva7WvoPa
	 qufNDa+ZnDunBTW2/ECTK2NLrbZfeUzGwxGTypvVG/Pts6CYN+wnwC7iQRC3ocAacK
	 +ivUH6qyVACiyKR6dAtFfvUfEzO+YLUEQj77nQ4wjLnT6RJPCeo1jOKrJHBDeIYkkJ
	 QtszNI6kVmITA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE800FEDA14;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Mar 2026 03:09:03 +0800
Subject: [PATCH 7/8] mm/mglru: simplify and improve dirty writeback
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260318-mglru-reclaim-v1-7-2c46f9eb0508@tencent.com>
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773774704; l=6525;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=4v8IMSBCol6NW26BtD5Q/L1ClDP1BcPSL9T6s99BSk4=;
 b=ogWGF6m9Kn1C0l8kcePmuURjvWxNqfs0Nq5qylyh8k5Lu9lBZj1aLlqafYXwCtj1m+qUBfcfX
 GlyrobjCyxTBuGGdl87zTSoMBm9jDi7IXnMMfQTqP+yFeDoz9Q+gqi6
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 1717D140012
X-Stat-Signature: d5kzp795wcexnbccnkuua4x5xh7dqz91
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773774710-320134
X-HE-Meta: U2FsdGVkX18VMzjGX7k0JGIRFR18OBrjOuFD70eLcOA9+D26O2vnC6Kcew1nYz5pH6L/ueQLfCdA3BudUHXu7aL8eT0U1cfAW287C5NhQOcR016jCJFanqR6fSsAcGhbA6Ihm70CuNReGfdXIfpTRdpsdLBxRxIBPQP4oEV4rJKL1i6jfeEJBva/qxekQE1WsTxbNG4f7ks9Xx+tfmv1LDOgicPwKBcrxmnkVcZ41kh++QNcSLfrqgAdQJHx8i+ByL3j6Wv7UpuRLkpbrtyPGtIJefVskz+S1MSXfuqR7vyY2PFsJoBRJ38LWUxdH8cvuteU3pGrQo42NeslNeElXKFI8omw/oM0bN5PaD26aPuKfGiQ+AEnFP1fxWDGzLkY5GvCEIsyQP/KK/3SIZ4ywjYhQunoRi97BXV9/8KwVNEaVRshJ5y26maLv0qOpmfFq1hfWSxKTokHBgXm6obB36nTgFnOqPyLBw/GGo3pYBRkKPkxSzxDDuSHRiB7v3xtlQzckfAuc75kEe9KwDUzTuKgoVIuD696efEhZgPt6Qqd54EJ2MnvpkuEvZR8/1I64J7aXNQGV99OlW97PreoO5QNv0N450F8mHPwWdpWLD4oVlpMBMhsnEQAs2neOz9NuZeGmJ9xhLaj/ptFKkNtNF7Y6gEGL48BllRcOFc6OFC5VCkK3VG2IhMUuL1JIcVEFN/bHflYcbgNOfnzJZhMU8+/x2dtGeYn7lyUfElCdsxXmzlQfJ0+NDr8axRVwEPuymkb6tEURPEm+UqOMkKJbtt/AdkjIWaopHLaVQ+Lf/MjWmw1xuUz3RAHYEHtVtwxcXZoM7L6ocNc8cSU5j0QGvowXSqpmhl1Tdl9bpVJAoJOAFfmhQnHBelBMe6mou7Ut8MCKNSyplMG1Izl3bdhiC8bxa0WpXg4aWQar7nr5MObxV1uPJRWBO6qOh/44xh7f5BQAvE2IL1WE5UfZHr
 PG9xnkzn
 kNz95zsGeLenY5FbY0gdObJhAtPWvu0NK83fC4hhuNAgfva+2jsL/HfL2tH8xa5l0pv8esoAMoCJUYuDI9ck+B8dkl+txDA/HYWVd3aznYNA/wmkZduandMVR1x3b3Mz04fdSERVW/4/hGaYj4GEj4g7GqwuAvvfq2GHAKDIxUqMvWENhku5TB9ZnZjfyWzvHI/zRL4CpYr7Hq2h1nH1aksRoMuIeYaFmY0EpELgj4fOmA82mWodA2sWGUCC5K27JAPHtbwhFgcy4wOvjPcjIppU46Ruuc2RFD4ThITSarqKOXcFKCmy1XKFb4QwoMAOjEim1qByu7rdECqmwbXZVMfevG4ezVJ+zkyQd1M/kr/O/KG/HGTpUDEIHQhBjf81mdJz5rD/oDUw5R9aCdGSZoZpXfSbkQ8D1jqRteGkzjeMz0P5h4Btp+DI5HtjGIqU2JQX+t52IfsuLhPu9W5DyKjYGzgY+xgBT2t18aDEYX32DUDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current handling of dirty writeback folios is not working well for
file page heavy workloads: Dirty folios are protected and move to next
gen upon isolation of getting throttled or reactivated upon pageout
(shrink_folio_list).

This might help to reduce the LRU lock contention slightly, but as a
result, the ping-pong effect of folios between head and tail of last two
gens is serious as the shrinker will run into protected dirty writeback
folios more frequently compared to activation. The dirty flush wakeup
condition is also much more passive compared to active/inactive LRU.
Active / inactve LRU wakes the flusher if one batch of folios passed to
shrink_folio_list is unevictable due to under writeback, but MGLRU
instead has to check this after the whole reclaim loop is done, and then
count the isolation protection number compared to the total reclaim
number.

And we previously saw OOM problems with it, too, which were fixed but
still not perfect [1].

So instead, just drop the special handling for dirty writeback, just
re-activate it like active / inactive LRU. And also move the dirty flush
wake up check right after shrink_folio_list. This should improve both
throttling and performance.

Test with YCSB workloadb showed a major performance improvement:

Before this series:
Throughput(ops/sec): 61642.78008938203
AverageLatency(us):  507.11127774145166
pgpgin 158190589
pgpgout 5880616
workingset_refault 7262988

After this commit:
Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
pgpgin 101871227                        (-35.6%, lower is better)
pgpgout 5770028
workingset_refault 3418186              (-52.9%, lower is better)

The refault rate is 50% lower, and throughput is 30% higher, which is a
huge gain. We also observed significant performance gain for other
real-world workloads.

We were concerned that the dirty flush could cause more wear for SSD:
that should not be the problem here, since the wakeup condition is when
the dirty folios have been pushed to the tail of LRU, which indicates
that memory pressure is so high that writeback is blocking the workload
already.

Signed-off-by: Kairui Song <kasong@tencent.com>
Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
---
 mm/vmscan.c | 44 +++++++++++++-------------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b26959d90850..e11d0f1a8b68 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4577,7 +4577,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		       int tier_idx)
 {
 	bool success;
-	bool dirty, writeback;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4627,21 +4626,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		return true;
 	}
 
-	dirty = folio_test_dirty(folio);
-	writeback = folio_test_writeback(folio);
-	if (type == LRU_GEN_FILE && dirty) {
-		sc->nr.file_taken += delta;
-		if (!writeback)
-			sc->nr.unqueued_dirty += delta;
-	}
-
-	/* waiting for writeback */
-	if (writeback || (type == LRU_GEN_FILE && dirty)) {
-		gen = folio_inc_gen(lruvec, folio, true);
-		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
-		return true;
-	}
-
 	return false;
 }
 
@@ -4748,8 +4732,6 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
-	if (type == LRU_GEN_FILE)
-		sc->nr.file_taken += isolated;
 
 	*isolatedp = isolated;
 	return scanned;
@@ -4814,11 +4796,11 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
-			  int *type_scanned, struct list_head *list)
+			  int *type_scanned,
+			  struct list_head *list, int *isolated)
 {
 	int i;
 	int scanned = 0;
-	int isolated = 0;
 	int type = get_type_to_scan(lruvec, swappiness);
 
 	for_each_evictable_type(i, swappiness) {
@@ -4827,8 +4809,8 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		*type_scanned = type;
 
 		scanned += scan_folios(nr_to_scan, lruvec, sc,
-				      type, tier, list, &isolated);
-		if (isolated)
+				      type, tier, list, isolated);
+		if (*isolated)
 			return scanned;
 
 		type = !type;
@@ -4843,6 +4825,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int type;
 	int scanned;
 	int reclaimed;
+	int isolated = 0;
 	LIST_HEAD(list);
 	LIST_HEAD(clean);
 	struct folio *folio;
@@ -4856,7 +4839,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	lruvec_lock_irq(lruvec);
 
-	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
+	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list, &isolated);
 
 	try_to_inc_min_seq(lruvec, swappiness);
 
@@ -4866,12 +4849,18 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		return scanned;
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
+	/*
+	 * If too many file cache in the coldest generation can't be evicted
+	 * due to being dirty, wake up the flusher.
+	 */
+	if (stat.nr_unqueued_dirty == isolated)
+		wakeup_flusher_threads(WB_REASON_VMSCAN);
+
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
 
@@ -5023,13 +5012,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		cond_resched();
 	}
 
-	/*
-	 * If too many file cache in the coldest generation can't be evicted
-	 * due to being dirty, wake up the flusher.
-	 */
-	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
-
 	/* whether this lruvec should be rotated */
 	return need_rotate;
 }

-- 
2.53.0



