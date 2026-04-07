Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378D3FEEF31
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB0F6B0093; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185C86B0095; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3FE56B0096; Tue,  7 Apr 2026 08:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D85D56B0093
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA49D8C469
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:54 +0000 (UTC)
X-FDA: 84631628508.16.6303290
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CCDD2A0013
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYam8V+H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563493; a=rsa-sha256;
	cv=none;
	b=4hgc704B+KQwt8btqtM79zYcX9W5a+DHh4NY8t508Uz3QLXldojqH07wJOwo27SAEslzcs
	ce1msRwrGj7N67Racfx+NDAItoRJ71fYS+GDND9fk84iSQxP+pRC2DyZBm5CUX91LU2Kx7
	ID01iCrH8MMbFONuzReXuFZg4mb2k6U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYam8V+H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563493;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfQWvh9n13dOshvhyxhz7ISmqJse+v5nz2vZP9rPDAo=;
	b=nCxMhCbK2PCxAVlgDY1+HhIVqFkiiSlePIQQDERzU1gHshrNADjcczmzYK9zBtpUEsXolJ
	VOZZtcPIszSpYT8V7fX3JRHnqKSjhIzfyNeEzwZxkC+IMFIGFdWAOIWr1Do2q6HpZu2m+6
	dS8KtJUmomqz8up+sRU0t67ReS5EDYk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70F8944576;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4DE90C2BCB8;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563491;
	bh=G4p+2Qn3vED8p23cqEC3WbmJz1xGvcxYhBu7z5p/IF0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fYam8V+H9O/q9DJLSJ6Dun3jzVyPXK6gEOQvGjmPuZr7o4HxGTWP3ReKXxgpnuLY8
	 i8+4pmSw2NjAa9CJLFEfwoJk38ZZ2e0EDAE26oVjjMZg2HKI97dxqV7zIcGxIKMHlg
	 pYVuHhF8ei9nejunjAJopX3Pwn2hxWwwXr101oyimktOaZA11TGC2TFs1+dlZBfZ/S
	 qz5afypg44hDTtunxoRNdu9bN/2xmNEon2WMjCyVYJi+ZVsjis2uOwloZ+eU8gLrJI
	 wrhspQxhxRtj7kqc5gi9saaj58RvCH0W3w/2OEMarswV5VT1b/GAjMz/F6XaBuDiVy
	 ksS4wskWn6fpQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4324DFEEF2E;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:33 +0800
Subject: [PATCH v4 04/14] mm/mglru: restructure the reclaim loop
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-4-98cf3dc69519@tencent.com>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
In-Reply-To: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
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
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=6218;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CkjP+pSvRYzYYzCckKVe1578yEEC5AkOtvh061Blbmc=;
 b=f1Tq5V9vysrHnzt6dar2YxzYLJsm6DuzMc92i3FpTbkioxA4dLuwDAHISJ2EVd//Qa+ByQ+0S
 2sEeSRK7JaSBKEshGf/dUslkw8IFkeKAv9JkYAFakx5NxwY8Mb9WTJF
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: ne15eq9cpcmed1pzhung69ofj8tga1wa
X-Rspamd-Queue-Id: CCDD2A0013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775563492-332582
X-HE-Meta: U2FsdGVkX18fEW7Zbhc1MmMPKlh1h0vwcDKnJfCl0Q3GOjyKnAJMlbnjs5x1fSjFGBFLnnomUDVRzM1mc3hg08IIv3f9g3cWPWlSec1wx28uHBsuNz9Fbx3qscwolE7QixTc1s/RqhFEAt9zAJXLPWftXOaXbisxsLrHFzWCEm3Quz9Cn0Q/1pi5zrlq0UfkWH9RHHp4YCwtvxzdNOHDciPD7rjUfKXG97TjBMMNFtpGhW0M4/aM9bnI3bWcgvbXE07XC1q7KIoYO/S+lsgBJrJa1BQrklQ/s4C2ZcFSNTxDf3gVvmOeNOpACBWwclOH5t/gUPvugMzFjPLUvVKeE9FYBrzu+ziVp40P6tS/BhYqxiydUu3cnJTl1PbKBxcvGmkMoUKmcjKT09QSjouSoXLWWRjbd5u7uEdO98QylV+QlaBwMuIoL0V+7ZBHBDvHTde9fi50eU2ccVVKoGseJMKcSKm6Wzl4ZbmMwYlTgL8dhNZWbvMwf/DUWGLEBgGZb+KOt5QVnVE+EkgS5YTXpn75kka+C8WdvbQ6KVRHYA/nQnkvXdv52r2Ub0qs7aLnWoYBX4jQxMyUxTrNIS8np2168nGIWgCDovoTRj8JmY1syP6GgdqyjIeE8OIFDfqf912hByXWKDAEO8gSF96AmF2VuZ55xjsfY3H7egG80qJhVISFXw3Yt3iqs6Tr/RdjNfQt0LQnU0ezN+2+eudO5mz01WZw7ILoxtrD5+rMOHqRJ3Iy7efEqLR1o85ysp8G+RMTxKeAi1vWrD1XBbqQXlLaYCYAv9ejsoZ3QhPZUB81GUglzgYGHJ/UHP6ctyAdYnELpzT3XJr2Xj22mwufP0l44W5/bjvJBKISZlLorMShQi8iSUGkJJZnFjcM8pj/vnKIXDMwyi37uBDKS5bccFf15iIjQPC5W3jScqtnEaEUK8kSWJ1/kgWnl3+mWtPhqNuEoCHN0AMT41LLnmz
 hjRLP4q3
 hMSDwyNqI9/iaI7bqs+8g9fPx58pf4yBwJbTHztFid0KnekGBCyssYw7jxeSxe1eYRRubEwIEqDnJGerFAgpIr0qhLSp3bdArp/aX+Q2ioiBYoes7AU8ffGUwVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current loop will calculate the scan number on each iteration. The
number of folios to scan is based on the LRU length, with some unclear
behaviors, eg, the scan number is only shifted by reclaim priority when
aging is not needed or when at the default priority, and it couples
the number calculation with aging and rotation.

Adjust, simplify it, and decouple aging and rotation. Just calculate the
scan number for once at the beginning of the reclaim, always respect the
reclaim priority, and make the aging and rotation more explicit.

This slightly changes how aging and offline memcg reclaim works:
Previously, aging was always skipped at DEF_PRIORITY even when
eviction was impossible. Now, aging is always triggered when it
is necessary to make progress. The old behavior may waste a reclaim
iteration only to escalate priority, potentially causing over-reclaim
of slab and breaking reclaim balance in multi-cgroup setups.

Similar for offline memcg. Previously, offline memcg wouldn't be
aged unless it didn't have any evictable folios. Now, we might age
it if it has only 3 generations and the reclaim priority is less
than DEF_PRIORITY, which should be fine. On one hand, offline memcg
might still hold long-term folios, and in fact, a long-existing offline
memcg must be pinned by some long-term folios like shmem. These folios
might be used by other memcg, so aging them as ordinary memcg seems
correct. Besides, aging enables further reclaim of an offlined memcg,
which will certainly happen if we keep shrinking it. And offline
memcg might soon be no longer an issue with reparenting.

And while at it, make it clear that unevictable memcg will get rotated
so following reclaim will more likely to skip them, as a optimization.

Overall, the memcg LRU rotation, as described in mmzone.h,
remains the same.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 69 +++++++++++++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 34 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 963362523782..462ca0fa2ba3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4913,49 +4913,36 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     int swappiness, unsigned long *nr_to_scan)
+			     struct scan_control *sc, int swappiness)
 {
 	DEFINE_MIN_SEQ(lruvec);
 
-	*nr_to_scan = 0;
 	/* have to run aging, since eviction is not possible anymore */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
-	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
+	/* try to get away with not aging at the default priority */
+	if (sc->priority == DEF_PRIORITY)
+		return false;
+
 	/* better to run aging even though eviction is still possible */
 	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
 }
 
-/*
- * For future optimizations:
- * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
- *    reclaim.
- */
-static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
+static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
+			   struct mem_cgroup *memcg, int swappiness)
 {
-	bool need_aging;
 	unsigned long nr_to_scan;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-	DEFINE_MAX_SEQ(lruvec);
-
-	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
-		return -1;
-
-	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
 
+	nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
 	/* try to scrape all its memory if this memcg was deleted */
-	if (nr_to_scan && !mem_cgroup_online(memcg))
+	if (!mem_cgroup_online(memcg))
 		return nr_to_scan;
 
 	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
+	nr_to_scan >>= sc->priority;
 
-	/* try to get away with not aging at the default priority */
-	if (!need_aging || sc->priority == DEF_PRIORITY)
-		return nr_to_scan >> sc->priority;
-
-	/* stop scanning this lruvec as it's low on cold folios */
-	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
+	return nr_to_scan;
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -4985,31 +4972,46 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	return true;
 }
 
+/*
+ * For future optimizations:
+ * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
+ *    reclaim.
+ */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
+	bool need_rotate = false;
 	long nr_batch, nr_to_scan;
-	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+
+	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
+	if (!nr_to_scan)
+		need_rotate = true;
 
-	while (true) {
+	while (nr_to_scan > 0) {
 		int delta;
+		DEFINE_MAX_SEQ(lruvec);
 
-		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness);
-		if (nr_to_scan <= 0)
+		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
+			need_rotate = true;
 			break;
+		}
+
+		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
+				need_rotate = true;
+			break;
+		}
 
 		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
-		scanned += delta;
-		if (scanned >= nr_to_scan)
-			break;
-
 		if (should_abort_scan(lruvec, sc))
 			break;
 
+		nr_to_scan -= delta;
 		cond_resched();
 	}
 
@@ -5035,8 +5037,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
-	/* whether this lruvec should be rotated */
-	return nr_to_scan < 0;
+	return need_rotate;
 }
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)

-- 
2.53.0



