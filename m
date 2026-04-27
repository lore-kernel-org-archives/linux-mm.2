Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B204FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A7B6B0092; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4C86B009B; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0346B0092; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 202C16B0095
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1C3012020B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:08 +0000 (UTC)
X-FDA: 84705117336.21.5CE68AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C9FBE1C0008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lPgcfLjP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313226; a=rsa-sha256;
	cv=none;
	b=csJvLnhft2TcVZxBmjXhCXVWs238HVA453QH81ngYmR45Gn0KxXQ64uWMzpmbp/9nz0zrd
	Gjb4Dc16fII7AHupc+65kOErevaB6K9aASko2UeNrjkNjI4ut3CQ7+aSpWewq/lcJjlgoC
	uhE/TwpSefUTvDiPZLSZwFTU/t5YIlc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lPgcfLjP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313226;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxInhldxLubls+z+rj1Sx+FEKMtKrHOq3eI7FSeSJuo=;
	b=lsBGKU3M0fsTnj+ngV30bNXyeegOE5+BEnFWxfGlr0sjSdGSy3iX5hir041+mC6GX/ihCq
	ZCUFjKHvt47UO4rsBeGJYXZsBMqcUAnqviau/OZGw2MHANtCyrhxq16TzBKzf2dVMBYj+E
	VvLle0UZ9B2r8mV7byggsJ4+H/E39bM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D351960154;
	Mon, 27 Apr 2026 18:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6E4CC2BCF5;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313219;
	bh=nCSsnBFCq6QE97j9zl/tHdIeIyGvS/fXh9XcG+jT73Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lPgcfLjPYHeqBf1jKJB6NZym0wlvcZrjo2/L3TKrzchMEmSoWyVpLAIE6GA9LLmWR
	 iQ3UtZLnMfd0wp/Pl2TOzB+jxdvww9E/3W7yNGTuYZ2h99VxqV0Vlyt8orPoS/xkYL
	 yNbkRK2f51g8BOh03vuFMcst9y1Q54Lz9vgfO/OmqHjTIPU73QyZtRuxZvzpGWtwGJ
	 07DshyapH5h6+acQ8FuM/y3vY+LyaL76kkWdb8M/wB9EGfqt/jYVXrkCeSgbwrvW3a
	 0WE5E5cGljZYoiP9H1X5RqNx+d3bPsrhYSCyWP1trqInTmj1Zfi8YxL/MXDTBCUGQA
	 +xYll01PpkTYw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD739FF886B;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:06:55 +0800
Subject: [PATCH v7 04/15] mm/mglru: restructure the reclaim loop
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-4-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=6529;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ua5CZKU4fAwh1GAS55cyyf6f9byuwkTxQPOo0BUpUcY=;
 b=KQ/l2GgwGMdA2ubdQo08aDL2lCBqKfBZhxHNSzDBL6dva3CAPO9X+iqlM1DrYBhmTfOOD36ld
 kv/iOZ0uSorC2oHyy4mdavY/Q3PDOGTx5F4Mlf1t3DhrJhZXAItQcF0
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: asehidaxo8cb5tjqzbxm1rpkg8qwjgme
X-Rspam-User: 
X-Rspamd-Queue-Id: C9FBE1C0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777313226-135700
X-HE-Meta: U2FsdGVkX1/xn80vmaNPTNmhkQfYj36HbnEKBBvMl8kFsi3kGb77ba+iryQA4bfLJqMqd9H2NHXir7dB71o8SRxNY9jax8pMKll4b0QGBzXX8BHD/VO7ShBfeNYJreOhIi346jAJ41r8+Urm31zqewns5tHxrvB/xoJNU3ItWRchqjSrCokFtL/Wb5DlX4MhjpopPFWGbxVC0dBojdfgIX0Io3gtjoycw1iM9WJYjNZ4iG6joOJnUe+PYpBech+pQvrQR9262bMNiKX2PYVCWZj9uRn5ppBE4s2DOUFUEkcxz89UtRMxWSa2i06tXGvWQguqsivcU18KAV+JvmmfHld8dblouhsYcEk5gxQt6iGIQmPPZ3piL8XLr6iOMG0YxucJvR/CCbc4IYIDeSTrIQg8VpOGHA/ba8FBZvrmCpx4lh8jiP8sX8MMb9YPFOATHhRSi5h4NnHzdIRC4Fk8h5QZ16PdiUcryZj6mS+4U/14Ua//0lmm5wRq9Pkd2iXJ5P19o2GjD9YzRVVEIOiiObmWgkrqPwPVwv0yiHhAHkokxD2P35GV+5DHK3aRUiD4NJxm/0ivS0mOiCvcaRd0ggpU5Kk+v2q4CKMggh6cIsxBbL/GBYZdRWLcFCSGxzZ/qShx4uvYySP9yKbKX2fC3IhPmclAv4PM00rJu5L+FdJscDOcyruao/dhI5DMsXpRMOOgSaYIMHb943uK7a5zThEQz+gTG8j6KyclMWsaqvjDdrT0nH6l4Fs813ByxmIo2onFCtqht4ZNmyMYh3Z5uQqzImbkWOHbQJpG2V24wF4Nwj0jIl36HLx2YD2kMzq/qZUOwqUI1mEJwb0cj0VbhFzgyXI14IPK+TnK2GHRf1gscOYqcTDdHWbhDvYoO9v1KFrbGYPGKPTpGl+MltwqBMZonoBvDgfbMsHNCzMp9d/dZnirw2GKv1cKDBMGjFqR3W5s0O05EgRqfLeTVl8
 Xk5rvFrc
 xGfq39pHbuIhW2UdhY7Go0GE8YLl1vo1WnEMDoQz9U+1Qzki+aR7yTb1F+6vRQEXZI559kFzNBtbxpoH8DRF046xgTUjWPtUp7EYIxuRCpfEzOEHQwdpkPPCVKjjKcM6AUL4/8fDBL7xUypLggdgMzo36Q2o14gz/GfeS4NA8YT22ckiq6OeefDlzl0dTILmwVR6qWrKM8rIfBLQ89Ws6s/IsQTSvz2bOIME7X+HCPDAzkGxVEmPzutvuuGlgowIbnRiF0/uTo/qK0nWw/vgZtKRGOLp41+Fa6WcX82X1hmDktPcNMfu8T4RVz/1wBgiJeLcKxXeT9y1ihKvCRFkGYxO9BEa+QXFfWaeS7PzejxB/aK359dt1upXO+XoKhZ1GZVQw66ar9zGhETqGV2Cstbbz7yU+VCiFKFbwxIsgP8I9J3K65GUg4sBsDLynB0PRHjYY0NGT9owqMF/BcxCrfeyAlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current loop will calculate the scan number on each iteration.  The
number of folios to scan is based on the LRU length, with some unclear
behaviors, e.g, the scan number is only shifted by reclaim priority when
aging is not needed or when at the default priority, and it couples the
number calculation with aging and rotation.

Adjust, simplify it, and decouple aging and rotation.  Just calculate the
scan number for once at the beginning of the reclaim, always respect the
reclaim priority, and make the aging and rotation more explicit.

This slightly changes how aging and offline memcg reclaim works:
Previously, aging was skipped at DEF_PRIORITY even when eviction was no
longer possible, so the reclaimer wasted an iteration until the priority
escalated.  Now aging runs immediately whenever it is needed to make
progress; the DEF_PRIORITY skip only applies when eviction is still
viable.  This may avoid wasted iterations that over-reclaim slab and break
reclaim balance in multi-cgroup setups.

Similar for offline memcg.  Previously, offline memcg wouldn't be aged
unless it didn't have any evictable folios.  Now, we might age it if it
has only 3 generations, which should be fine.  On one hand, offline memcg
might still hold long-term folios, and in fact, a long-existing offline
memcg must be pinned by some long-term folios like shmem.  These folios
might be used by other memcg, so aging them as ordinary memcg seems
correct.  Besides, aging enables further reclaim of an offlined memcg,
which will certainly happen if we keep shrinking it.  And offline memcg
might soon be no longer an issue with reparenting.

Overall, the memcg LRU rotation, as described in mmzone.h, remains the
same.

Note that because the scan budget is now pinned at loop entry, tiny
lruvec might skip this reclaim pass, also skipping aging, which could be
beneficial as aging is not helpful since it will still be un-reclaimable
after aging. Reclaim will go on as usual once priority escalates.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 72 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a011733a6392..b247f216f28b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4913,49 +4913,37 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
+	/* try to avoid aging, do gentle reclaim at the default priority */
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
-	unsigned long nr_to_scan;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-	DEFINE_MAX_SEQ(lruvec);
+	unsigned long nr_to_scan, evictable;
 
-	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
-		return -1;
-
-	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
+	evictable = lruvec_evictable_size(lruvec, swappiness);
 
 	/* try to scrape all its memory if this memcg was deleted */
-	if (nr_to_scan && !mem_cgroup_online(memcg))
-		return nr_to_scan;
-
-	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
+	if (!mem_cgroup_online(memcg))
+		return evictable;
 
-	/* try to get away with not aging at the default priority */
-	if (!need_aging || sc->priority == DEF_PRIORITY)
-		return nr_to_scan >> sc->priority;
+	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
+	nr_to_scan >>= sc->priority;
 
-	/* stop scanning this lruvec as it's low on cold folios */
-	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
+	return nr_to_scan;
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -4985,31 +4973,44 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
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
 
-	while (true) {
+	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
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
+			/* stop scanning as it's low on cold folios */
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
 
@@ -5035,8 +5036,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
-	/* whether this lruvec should be rotated */
-	return nr_to_scan < 0;
+	return need_rotate;
 }
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)

-- 
2.54.0



