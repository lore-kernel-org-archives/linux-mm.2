Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6972BFDEE39
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02386B0099; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5896B009B; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7866B0096; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F82D6B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 018AD8B678
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:35 +0000 (UTC)
X-FDA: 84690542790.17.429DCDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 05BC94000F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2YE4xV0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966213;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9Mbcr0J+NGtaI2IMV1wNtpUclizOKAGUej/HuLwPdo=;
	b=z3vBGCNTopuXDnZ3qLIo4EjMzoln68iFfOW25jo9wkh2l52UDtFa2IpTRBBoY9B7nxkWMq
	qWrWyui3pt7NtR+Gf9xJ+G9q7C0T0FBbGmnEUyjz1KixExar/yxlTp+QPiRl6BrNTymomH
	9sD3UiIZbgHyTDd4u1yZJqH6BiCOnTs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2YE4xV0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966213; a=rsa-sha256;
	cv=none;
	b=JtVuxORocU56A1/SIw99JhGeEoEVnNX1Y5OxCDytu13J00l/+ak+s5SbAAVO7+esQPSg14
	Xv4z2ztct6Kc+6Ydk0s9i41khpr5N+OLYexlfVIqFZiI/eDjiztey394r7AELicPDO0zbQ
	SWB5brO8gKwWjwbbCd1UNoqh/LU68q0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E8A861141;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90F6EC2BCF4;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966211;
	bh=6IKi2rWc+WPWKqgKFt/2w2199Z1fmv4nfi1USnmh4SE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=e2YE4xV0FDAMJyv3E/pN7TLdFatFG+XqB9DZJRUj5iiKmc6rvq5GvqGn3IDJHrTaz
	 btO6mWfiEz9Neeo218KssnK3TpGlxBzJmGN13phg06AicUSf2dlyiepIABqyimOD7S
	 Y8R2s0rYkHu3V3w4yy2e7W4tqg3bn9l36qMPs931u/ik0eVz8BZ34i+ODVmJ67VGYD
	 chOJvG6sRKeNXCStVar6KpU1TpVxUnqWC+RpvHD7ocYB8CXQPj+DN9i/0BNzJPNZ4q
	 3XzrpGKdQ8LjE1M3ujef7KHV2PfPq0a/7xl+x4Gywik8xOknD67iN6MdPlPIc0Vn/+
	 7YdLmCmMs7c2Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85956FDEE33;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:15 +0800
Subject: [PATCH v6 04/14] mm/mglru: restructure the reclaim loop
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-4-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
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
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=6446;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zTJS8bEtP6qc/kBSze97l/RtD6AnJQpsOgfF9tsEBIE=;
 b=LXQmh9e6LJifzIld3GxrjaGzTNXILGR5M0GRW74boJ36+L/gJBtm4Cx1iJ/7PEfIiH5pagxK5
 NNoMrvr6Ca4DS7wEjPKX+/Uw0YJFHl3hCRrPVkWU+LKlye+AoV7e5UC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 05BC94000F
X-Stat-Signature: ohuewywrxohe5ud7i7q3hgw75nq3p39s
X-HE-Tag: 1776966212-174469
X-HE-Meta: U2FsdGVkX1+EsyCcpgnHbOuVd6uM0DMxhkPk9567n9APKS2zCDlVQQ4A4iklKBZNJQbPvxxg7yNvIUAQsA9O33QX3D+FPBbGdPMja/91T+Lr3C9NgZSDlgeIaD/c3XSA9yZ7/zz8bHjOBUPKslYmgah+/K8zl2KYylkytMdQzq5AYyBrPZGMP9i4wopTsdZct0lJ52/m1zjHDBlDRL6wgxK2wCJJbQTmfFldEoZXlbssgNEnv2Pv6603PvQrfbaANsLQqrQt1rcCrwvDqObu/SjdcYD+eBIwW/GciyWWL4NwuklLad9x1SlYsDrYmBjavJj7PYMKqBCFQZnIalZGTm/iOuboHh4UmgnRkywakcTyDmlAFvu8NHA1sqnDZjkxeiVIkm31hBsHQfeIma8IOYz/BQAtTissNiEorWRDWzyLhUZVWA76RqiUrT5ntZ2+Q7Xx1fda5D3P9qtHpWOtzLwkNn/vVJDUydwGYfBYrzfnWcLtqTacZerIEiyJP6H4XyG828SufmBboRyTEYbRZ8BjZbrpY1I5axW37ZmgxriH4B+dny+QR4S/X25UF9hMtr0/ChGLLEP6VrWemH9C+YYtaRj3JDjj29D1b00cATVUCvORBti2U//eggaFhMTPoNAomfW8oKUQ/q7il+kGE9PWcZn7TynUi7vfm1sFJmH0b/8AC7lm3P/0Bz2G2ljL6mfi/7uneRy+2wNP/zzyPZU+YpOgKoD6e6RqSC5KmR9P9oIXWW7s1k1g9TaAF+NhfB3ZqVMD4GdrpGqSWpqnjI1ud8q/Z5Ap7h1Kr6bYy37tk3FPrbQpuxPrMyFnPqH1tpuFuIpNmtX/NTdW9U5IvNw4fMQXFmFBY1qXCV/BuEdvEm5ufiWH1WcgDPBCS6DsX5d9ddc/PXhG7lAVamAoB6xuDSZnefAXzwUZZnZWbPb3u/XrPMpb5ROGFFNT4vGw7MovkyFPuefwPAaN9cP
 t51r2gvb
 hijgqrdRE8kGAj1lGGpaHxjMMYweTNSAqptcX5FwCJ/1DltGsSYTBLxNMsPh8IikhIxCzyx9ku+7q63elm6+zAb1pCYI0+XmGGIbXJ3lH48BCSvZOueDLGNv5+W0iLlPMDC0N+Zw5dzMe80NJsatF9plQ2vW2T06fBMHhJABsc72+k8EV5OUGTxn7lrIf1hoUsSUXH1akxOiI9SdUZMFaW2HYvNh64cgBUr2/A7WcntO3JAPR545UkmLnSpxTK65hd6UzyiNk/kucHI9xvma6IV3EYYRvvMKY4e53vcTiAUOMJ3JRVknAdebAexo5BV4cb/tmtBMwbKJ5Gx/oVuTYTo3MOxpNctOskAZICLLNPxaOpmiypJ9M5TajV2t/7sw9Y/8yHAQy1ofL088SCbmcxkQYe1dL3eiheYgwZbXi9+90gvR5YWWASjVOKwnhnn/ZA9yr6e/jWD2bZisXpVNJzMLehw==
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
Previously, aging was skipped at DEF_PRIORITY even when eviction was
no longer possible, so the reclaimer wasted an iteration until the
priority escalated.  Now aging runs immediately whenever it is needed
to make progress; the DEF_PRIORITY skip only applies when eviction is
still viable. This may avoid wasted iterations that over-reclaim slab
and break reclaim balance in multi-cgroup setups.

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

Overall, the memcg LRU rotation, as described in mmzone.h,
remains the same.

Also apply a minimal batch factor when reclaim is running with higher
priority so small memcg won't be over protected.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 70 ++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3c5a6ae92440..757beb605980 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4913,49 +4913,41 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
+	nr_to_scan = evictable;
 
 	/* try to scrape all its memory if this memcg was deleted */
-	if (nr_to_scan && !mem_cgroup_online(memcg))
+	if (!mem_cgroup_online(memcg))
 		return nr_to_scan;
 
 	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
+	nr_to_scan >>= sc->priority;
 
-	/* try to get away with not aging at the default priority */
-	if (!need_aging || sc->priority == DEF_PRIORITY)
-		return nr_to_scan >> sc->priority;
+	if (!nr_to_scan && sc->priority < DEF_PRIORITY)
+		nr_to_scan = min(evictable, SWAP_CLUSTER_MAX);
 
-	/* stop scanning this lruvec as it's low on cold folios */
-	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
+	return nr_to_scan;
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -4985,31 +4977,44 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
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
 
@@ -5035,8 +5040,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
-	/* whether this lruvec should be rotated */
-	return nr_to_scan < 0;
+	return need_rotate;
 }
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)

-- 
2.54.0



