Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 765F1C531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 13:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314866B007B; Thu, 23 Jul 2026 09:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECA06B0088; Thu, 23 Jul 2026 09:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228B36B008A; Thu, 23 Jul 2026 09:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5C2E6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:06:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5824816049E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:06:33 +0000 (UTC)
X-FDA: 85020065466.21.CF6087B
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 370F9A001A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:06:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aCG4fDtB;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784811991;
	b=ZuWE4i3ebgpP5AdsxVWATLq4R6Mrd4LqeGG0jP+CRbvhvPqMTomK8HfgSEq5itEf0hcA1s
	tumew64wiYfTcnMZJQ+bK/RWnYzAH5I8v0r3gAkrr1cUJHK5Bu7H/7cVdeP0HOZnrGOJED
	UPuQ/Odn/ZwQzefsI1WKttCXZLCHBgc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aCG4fDtB;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784811991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MGfalNcUUGb9oiqhuCNvSsUVOzxB2Lc/6ZPh2Rebisw=;
	b=DIwz0nsuLE1gdn4LyNJjtutuaayWBV5UmQ1nBdP6JDSmnQZBkZ/FBqaiet/do3k2RW5qls
	57jPI/kBuyN5m8S9HRHf6PJL1ogZ0JeAccYYcQXWM+wPkBy2ajAW8sWEz0KHwTh3ub0gMZ
	FdQA3ffUoFUl5mTuo3EpjRlc+GeN510=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784811986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MGfalNcUUGb9oiqhuCNvSsUVOzxB2Lc/6ZPh2Rebisw=;
	b=aCG4fDtBd6UAAUlJI4VcXesHNuPmOjIK9ENyYlBK85L6PNfcKzazsg+firV76xk99jhzdk
	kpd5JqcodSOF99HLOzVZnj2G9CdMKTNatWWQuJWXEQWhIfVXWaqSDvtBSG3yW1bOHTrXNy
	pW5YRBPgXrbfEvpaNt907qVWGXzDbzI=
From: Ridong <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Yu Zhao <yuzhao@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH] mm/mglru: fix memcg protection for global proactive reclaim
Date: Thu, 23 Jul 2026 21:05:59 +0800
Message-Id: <20260723130559.2343690-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8so4rdndkwejp5r6pjns3iqarkwhsyon
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 370F9A001A
X-Rspam-User: 
X-HE-Tag: 1784811989-908606
X-HE-Meta: U2FsdGVkX1+76JgxcQbqvIcJ3fBrspa0GpGcS0p1YAJGqdnwseXBQaH6DZclcJdHhe5RFXNqjQFlAXIH/incBcSQXvAxCRK4tFmbPqXSNNFyr8cm+k1ffVBgcVJ+26IsKPFlYp4BnfnG9L62rwQsh6ai+dlhLr33OmrR4gduPJzfcKZBaHCxh54iReBkyQKQTVeLxAjpiOk6Ys6etE1r4nneR8XDeeaYhV+3jjk/bcvmbKz3jiZlj+BNp2kD3OzcKTM+j8mGqm71OUI1HG0aYzAl/gmTqh5jEIbpbsiNLHcbldI+lm69cwDIfO7Cg90bKOoA5aYLiP01Bmx5D2opbsTF+Yb8tfAw20SfpSguKdYD9H65j72hffWHyDk7oopSxllxIz6HCuyImismcizS1ra29F0Yz5UMbvXDJcqjGQnGRUBfqfzA3OBAJunhjwkhsOo15+dxEz/u5s5iUcA+Ezo+w7G2sxYtqwHNi9aFoFBgA8fhr3DS5QFc+O4TFTCpVndmAwYBPWAI1TPXJzrg2hq2x+Lnhv5SEdEGposVWwFyghc+6lC3rT/ZJPIjMpVbJ5GCusZ/S0zWAt+ylgVxIc5jh6AYpO2OS8cnr4MgC0YDMiK+7fxT2Dt0ADErvssGKh8VQWA96obR2+SqPvn5JMeH2HsHBrrrjI0AyF9HtghB4Gw5t1K+SDUlKZdGtLNtRgTopITbo96KShCM0EIUvxlAaBz9jllCRk+CV23UGeGJlHsQxBJM2C7ZU8SOhflq0aWB1Ggppc4a3CMaOLJ4kgUnR/K5c08/HPEygC3L2+8yFLqYI9TNDzyLif+HyaXw5sZZTLu5mYsgurMsNSRX8kmVptxaVhfCNDTnD0sxaxDxohdZdQXSzSOEVyVBIJueMfYThp2ZOOxEo0g6k1z1twNBROBrHAuv53ebn723/mfLLDd/BxRZGDJMscZ2OodI7+yQg9224HsTcvDmo6A
 jOl/EVZL
 90gfkywKb2btpTgz4xA7xY25VN8yrVSc03biKa3atxZdgK9//Z7ytAWheNpMlRvQp/m7YXloqcTO1t7vlfOJ0hDVmtLj7hSxVyi2m7Napp0F1kb++20o0zn+AcI7ALf3+yXm73rpvmyAFEs/eZNHIKWd1GOg+hgRPfIYH3Z2qy19PMROENS6v1HCzNogS0WGXIuCHA8WFlzy3hGO5GY39l0JUxBErs8tgGxFv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

memory.min/low is silently bypassed for MGLRU during global proactive
reclaim (writing to the root memory.reclaim). It can be reproduced as
follows:

  # echo 7 > /sys/kernel/mm/lru_gen/enabled
  # cd /sys/fs/cgroup
  # mkdir -p a/b
  # echo 100M > a/memory.min
  # echo +memory > a/cgroup.subtree_control
  # echo 100M > a/b/memory.min
  # echo $$ > a/b/cgroup.procs
  # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
  # cat a/b/memory.current
  222650368
  # echo 500M > memory.reclaim
  -bash: echo: write error: Resource temporarily unavailable
  # cat a/b/memory.current
  6070272

memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
protection. The traditional LRU is not affected.

Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
computes the memcg protection in lru_gen_age_node(), which only runs for
kswapd. Global proactive reclaim reaches shrink_one() through
lru_gen_shrink_node() without any aging step, so emin/elow is not
couputed,

Factor the tree traversal out into update_memcg_protection() and call
it from lru_gen_shrink_node() for the non-kswapd path, so the protection
is computed before shrinking. kswapd keeps computing it in
lru_gen_age_node(), which also needs it for the min_ttl OOM check.

Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 06e103f9781e..dc3549583e97 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4122,6 +4122,16 @@ static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc
 	return time_is_before_jiffies(birth + min_ttl);
 }
 
+static void update_memcg_protection(void)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	do {
+		mem_cgroup_calculate_protection(NULL, memcg);
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+}
+
 /* to protect the working set of the last N jiffies */
 static unsigned long lru_gen_min_ttl __read_mostly;
 
@@ -4135,15 +4145,19 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 
 	set_initial_priority(pgdat, sc);
 
-	memcg = mem_cgroup_iter(NULL, NULL, NULL);
-	do {
-		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	update_memcg_protection();
 
-		mem_cgroup_calculate_protection(NULL, memcg);
+	if (min_ttl) {
+		memcg = mem_cgroup_iter(NULL, NULL, NULL);
+		do {
+			struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-		if (!reclaimable)
-			reclaimable = lruvec_is_reclaimable(lruvec, sc, min_ttl);
-	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+			if (lruvec_is_reclaimable(lruvec, sc, min_ttl)) {
+				reclaimable = true;
+				break;
+			}
+		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+	}
 
 	/*
 	 * The main goal is to OOM kill if every generation from all memcgs is
@@ -5004,7 +5018,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
+	/* update_memcg_protection() computed the protection */
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
@@ -5151,8 +5165,11 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 
 	set_initial_priority(pgdat, sc);
 
+	/* kswapd called update_memcg_protection in lru_gen_age_node */
 	if (current_is_kswapd())
 		sc->nr_reclaimed = 0;
+	else
+		update_memcg_protection();
 
 	if (mem_cgroup_disabled())
 		shrink_one(&pgdat->__lruvec, sc);
-- 
2.34.1


