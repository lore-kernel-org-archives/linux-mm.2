Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC3F2FEDA11
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7FA6B00AA; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FBC6B00A5; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2219E6B00AA; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E80526B00A5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A343F160365
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:50 +0000 (UTC)
X-FDA: 84556499580.05.5C42533
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5359C40012
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rdwCWQ6S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774708;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZNOd4nCjvaQLMPx8qZ2RMMIh7vg/FOU7KlS6/TWn4Y=;
	b=hDC+u6XFZPl35a534616hNHWA5yio/tScxq3PnFc5AvnsvQGvNsYK70DwQC17BT/zldyPv
	8Xgi5AiNtdMEydVhjokRhXA3hL727gp0oTlboEG1hkDrt/IaDgrRSlZevw0eGifoyk8fi8
	g8CrPFOJpr5ON299exGGCrv+xIVQ++I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rdwCWQ6S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774708; a=rsa-sha256;
	cv=none;
	b=hbmh3j3ElZpfwBoo4iNW/F1SyPUTbEXFSsadMJhrkFc014sEC47/tCrnWybExtM4zqeSoJ
	/vMYN63PFqQsdYAgkrvLtKd5ODskZjPI5ZbXiKPNABnfkOwy5JEZ4XD68J5vgi748Kqfsx
	saw4WgBSESQb0QRTla9yVVUu0Nyvjd8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F4020441EB;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F998C2BCB1;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773774706;
	bh=ShTPgda79eI5bfLrqES8xsIPgScfpn3HqsyiI/89JgA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rdwCWQ6SMnoSXLvZaNUJxhBipKDWrbTHnYhCx+3b/IAdD7qSrSnlIQsxl5BFs7Knl
	 mJluiAxmIcIVNOjD5u12od5vDre1VAm0J8NgtlbnegHhYVg0EjH98tdrzHlsx4ao1U
	 iysHiiglDW0Es5uWzQZE1LiE1T+NXnfWhzsFlQu/jtLLsCPIGY3gDQ5+qcOtZ2gl9Q
	 5jngHDtN7a6JgYdFbZjXoJeEnR7IP1J5PMjOj2Yv4uePgEm20TUT7+0bn4TmiNXsJP
	 rAVPd4AZEx8yXqmx1P0cFlVnaUGWMmes7mTj/z+q1v9VKLdpVFMRKWstaEFi6lJq3L
	 MtlpeNNldzcFw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EEDFEDA14;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Mar 2026 03:08:59 +0800
Subject: [PATCH 3/8] mm/mglru: restructure the reclaim loop
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260318-mglru-reclaim-v1-3-2c46f9eb0508@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773774704; l=6507;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=nSc3ZboeAfZqlXa9RRdghawxnkojRfxE+BLKkAiqpPw=;
 b=CEdwqcbP+j24LiaU20jUXH/9jmyPXXacBzgfAGK4Ah8Q1H8lI8SaBAfcoOJoy4eZYHvlkd/lm
 T/afHPPiKjgAhp6fG4PLpL7uzx0drHVKLrCLhHjc1pb34ccpzWklJqu
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5359C40012
X-Stat-Signature: e8cg3wg4u76fgdkyaxutx8kfgh1nme1u
X-Rspam-User: 
X-HE-Tag: 1773774708-607955
X-HE-Meta: U2FsdGVkX19DjKXuWcyQxdZkWxu1xZby0qbA3/ba0fCx3nTve68GA6b8TPiIK0EkRTIRe60Vw0mEq7yVuCCGttFgqbztcQadZ1mhSSKQmGqHDF6lVPb8ZNej1wIcABmkkJUTk2rDdjvoSRfxSfgi+rIjmAbmvKqBjeQRVYC/ztAC9yGLeoHOuQlnKsVcfvf5qjA+eFkHytllLjX62Z+sNiB5Poe6WEaT4SI4jcJLCcPdj/9Ln+j6E3K1wp/KAUQp+kQksLfo4doLKWYItEi68vDGKK/78F2n0XEEMbJTXpxRCzha9ywcVYselHAMT3yduk6jExpat6lo202MsKrNE0q7jdsNIyzB9LbEwNwKIT/1oL1sFuL7RTjVhKYMVUFpbL+puYe1gBkhQAbX5K/xaxqvuuX/0VVkzY91GInQgJjtAU/AGhb3H7Oe39w9PUCbHRSm12vnc1wIez6Sfi7UJvcN+LPpnmvmgBsNQ/mYhf9xUaa7cdE6zkl9Bb5B3a2Goq55h+CKnrwQ1SNeZ1tyhTdKDM5ZAROEbOPIBmmKA+qwepo33Gb5wBcaTDg5E9NxyJR3BPnXiJ6/KYQUSBnCNpuFqRaKERsIs/OPk/nQGNr8HrcDVwAUQVea22vkX9h0cFQPOxTF0eufDun+CGUhbnNtMmKQM9HnlhIkF4Er+G1dxuzN6r5LUmkgXrm5nnGhz3+SFC0R1+lt0zliL4SFX3LJ/18wTABq6if77+0AsODlmPXgbtTGS6KQ6gkRgqtRW9S4VvKvcvm1xzJmsg8bBE+rZM5zcX8RybE8XdxckRHn7+KPffmrveYqllvxcYcVWF1xZ9lV8EOz4cScmv8E9IeMCyNTf4DSztOPF3G8RbrQSB/Hqhvgx2p/5nH5fFk8bQ9cmjYhys/uRaFiqRc17SSQo2E09sLr3e/OpZlWtc51pR3yUPfso1sD1wu4kYjRv8CYefvsvBxYpwtE2wn
 FxV7dcoe
 4I2UpgkxLhIHpfUX/uzVLSRy0tSbab+9vmFpnifGAAmbOgN/59xo8h+WZaMriXbYf7lj5WiZQFlY2Lo2R5+XqmQtYG4hVZVc+BayNGxBiZf1Rnun6UvzZWEVQlg33uck9oXwn4cTFP6NkbQsT9lPAuY1HO4763oAbidN66egqai6HL05ebjkUzVdrZ2GNSktkCSUI6/Vpshm5Corgs7llPRJF8h2z55HYnnyWqPnji3z28FaWkSEkYOJAL9BkDxct77a++i4zDKr2QK+ymala+zBdZA47/O2KrfY+oRSybXIe8F1pk2Zrdjo4WBXm3j7UFpP1HwZjmjRwuIW7UI3O4D2Diw6cKW0WkrOIK+ay1XWeb4S5ZX9QoAOv1NNeW6ZzDO089wCOrwyYRzxgxmaTZQDZBK/6qiRwa8arQ42hf/nVlBc2qOyQy0v83+vZx9IV2oUd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current loop will calculate the scan number on each iteration. The
number of folios to scan is based on the LRU length, with some unclear
behaviors, eg, it only shifts the scan number by reclaim priority at the
default priority, and it couples the number calculation with aging and
rotation.

Adjust, simplify it, and decouple aging and rotation. Just calculate the
scan number for once at the beginning of the reclaim, always respect the
reclaim priority, and make the aging and rotation more explicit.

This slightly changes how offline memcg aging works: previously, offline
memcg wouldn't be aged unless it didn't have any evictable folios. Now,
we might age it if it has only 3 generations and the reclaim priority is
less than DEF_PRIORITY, which should be fine. On one hand, offline memcg
might still hold long-term folios, and in fact, a long-existing offline
memcg must be pinned by some long-term folios like shmem. These folios
might be used by other memcg, so aging them as ordinary memcg doesn't
seem wrong. And besides, aging enables further reclaim of an offlined
memcg, which will certainly happen if we keep shrinking it. And offline
memcg might soon be no longer an issue once reparenting is all ready.

Overall, the memcg LRU rotation, as described in mmzone.h,
remains the same.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 74 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 36 insertions(+), 38 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d48074f9bd87..ed5b5f8dd3c7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4926,49 +4926,35 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
-
-	/* try to get away with not aging at the default priority */
-	if (!need_aging || sc->priority == DEF_PRIORITY)
-		return nr_to_scan >> sc->priority;
-
-	/* stop scanning this lruvec as it's low on cold folios */
-	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
+	/* always respect scan priority */
+	return nr_to_scan >> sc->priority;
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -4998,31 +4984,43 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
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
 
@@ -5034,12 +5032,12 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		wakeup_flusher_threads(WB_REASON_VMSCAN);
 
 	/* whether this lruvec should be rotated */
-	return nr_to_scan < 0;
+	return need_rotate;
 }
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool success;
+	bool need_rotate;
 	unsigned long scanned = sc->nr_scanned;
 	unsigned long reclaimed = sc->nr_reclaimed;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5057,7 +5055,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 		memcg_memory_event(memcg, MEMCG_LOW);
 	}
 
-	success = try_to_shrink_lruvec(lruvec, sc);
+	need_rotate = try_to_shrink_lruvec(lruvec, sc);
 
 	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
 
@@ -5067,10 +5065,10 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 
 	flush_reclaim_state(sc);
 
-	if (success && mem_cgroup_online(memcg))
+	if (need_rotate && mem_cgroup_online(memcg))
 		return MEMCG_LRU_YOUNG;
 
-	if (!success && lruvec_is_sizable(lruvec, sc))
+	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
 		return 0;
 
 	/* one retry if offlined or too small */

-- 
2.53.0



