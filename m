Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CEE2D1F9D6
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 12:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02386B002C; Thu,  4 Dec 2025 07:46:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CCB6B002F; Thu,  4 Dec 2025 07:46:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3546B002A; Thu,  4 Dec 2025 07:46:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF956B002F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 07:46:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B5F112FE06
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:46:49 +0000 (UTC)
X-FDA: 84181762938.10.CF463E2
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 04F651C0015
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:46:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764852407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uF6JgpdSIisSZTN28ZhacOKQ6MCPv7UFuTXAI5m+FKE=;
	b=cnRwZrseNY6g+0jLUHwRCJ5XSNj/z1yCC2HTSGFi3/3uT7L6XGJQB1Z+F5Uio74iJcFziS
	2SKROgN8QYzdoQqTIF5MuXLQuJwcAHzoCUAbJYHc1XxaqG/nyjtPzgXlMFy4i5i1Cyl7aw
	UJ9O2oLcTUF/0LAHKOrNp0x4/FURLcg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764852407; a=rsa-sha256;
	cv=none;
	b=UBvXNVEnyQYU3pT/1hLx9Hpnm/7XoAkuluNn3m4vV5rlcFGgFWT9qLkPyDWtnq8PNa8A88
	L3JV51YQhGpmKxH77dEdnB3bTTfabQ+CDNy+9/dGHBFgr/SOtiH+sfajOL72RpsWLh+iMb
	nx9pwNJwPdA5u1tjGpf0pe4D+6Mz6vc=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dMZ554PDJzYQthk
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:46:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id A4C6F1A1C15
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:46:38 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgB3VlCRgjFp+BRLAg--.31494S3;
	Thu, 04 Dec 2025 20:46:38 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	yuzhao@google.com,
	zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huawei.com
Subject: [RFC PATCH -next 1/2] mm/mglru: use mem_cgroup_iter for global reclaim
Date: Thu,  4 Dec 2025 12:31:23 +0000
Message-Id: <20251204123124.1822965-2-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251204123124.1822965-1-chenridong@huaweicloud.com>
References: <20251204123124.1822965-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB3VlCRgjFp+BRLAg--.31494S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw1rJFyrtry8Gr1kKw1UGFg_yoWxJF1xpa
	9xJayay3yrJr13Kr4fKr4Dua4rA348trW5JryxKw1xAF13K34rK342kr1xXFW5CFZ5ur17
	JFyYyw1UG3yjvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
	0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0Ft
	C7UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 04F651C0015
X-Rspamd-Server: rspam02
X-Stat-Signature: 7j5b359b8sgys13id8tyx7smufkpqya1
X-Rspam-User: 
X-HE-Tag: 1764852404-825584
X-HE-Meta: U2FsdGVkX1/pRUdvjuSziM8v2htdqsws76SgHmn8+kvhq3pTqkuu7vWz1Nv7NHlWIS6UwiS6u2W3aoubgssSBMZ3egL9vfyGJiY/7hmLve3zElSfUAu8+7KYJTZQO7dmBo0au6e2tYtsJkCI+W079icJH9TbIfo86Gfys+JnPgYSkKQKOK6a0gk7HBmPtQDtvpIgb/DTBrm0lro7EYqA2p3RB+MylF/EXpIMroUISy8CVPVBPlFcW8Oooo+pt/ofyTpjLryEZA55XGcNTMHJIIcHqTK59zFzKwb3Kp16Q9hH1ud6jdn+i3X1tvHn9huTlCWrVAd2jkSNCKFFgVrDZeCjKFuPL8yj5zNDsz1cbvCuStu3kEqM5GvJQlgjOgHYjrya0vF7MzcA0/89PT00PKcN7pFQVvFETHEWYwEsEBeFParboR0nHjsHu6d9tB5o23GNH5irak2VbbxmFIYKywNCdwE1iwNBQgtRzL4QMjc9dZFORP1VdxLVYhJTgSF/jRYobH33jm+OK9Os8vnfpknBf3py9xOWFs2an1keVpyArRIbRfXaWL+5fG5q0Y1JCzvBoO6qWbwZh+KDL1DCf9ZwqMTDYSjGiV+do1r2eup6C6VnuhSpz0h157i8UeruzsvOhTvlcJ+xo2cCy53yF3SD5I/HuxHni0udZ7ANbsi7u1+C3yGd3n6MRCgUBXdVphk9+d6rn5T3dEtbWNrcyDAzLTspknddmsU/4yzAFbFPKYlaGwW/oPR+kyzAEA8VSx0s2JWhv8Z9eHwngj1H5wS8KhNqsvww3DP7l2crtYtN6R56BME/AnbPU6870jqc9JEAFUBpyBMeDpcfTXoMCq/+1EuFa6aFdrGSrn29W+VeymzyjJ3NzQ73hY1N1deqsIC7s+hYEp107XEz2F7re0KyMgdI2K+Cd6hBioP8bqqScD2gACW6hr/7WrQCZt5NikUaOJSEM+8kNxUAijH
 SB48hvYk
 PvSpK6CjDfTOobDbvR0sIS1wWPfMMmNMOZ45f65urF+6Pzm8mPYXHQJ7LPBCDXDxtWSXJM58j+YTG9QpmxGOXt8t8CIYnGnOztICzk4BzHIeOoPhisoljFMaUi/LDJXWF1UMcgQoCUH+jwhW+25OoPHw3Uu1gW3MRtwg8sHxHioIuXpQYiuhlqwpynIX7K5vCrjqrb7iFNy5KyOwRKXO50CeBLKEmlLJ65ZLsYXprlxnaCp5gYvJuwE8EhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The memcg LRU was originally introduced for global reclaim to enhance
scalability. However, its implementation complexity has led to performance
regressions when dealing with a large number of memory cgroups [1].

As suggested by Johannes [1], this patch adopts mem_cgroup_iter with
cookie-based iteration for global reclaim, aligning with the approach
already used in shrink_node_memcgs. This simplification removes the
dedicated memcg LRU tracking while maintaining the core functionality.

It performed a stress test based on Zhao Yu's methodology [2] on a
1 TB, 4-node NUMA system. The results are summarized below:

					memcg LRU    memcg iter
stddev(pgsteal) / mean(pgsteal)            91.2%         75.7%
sum(pgsteal) / sum(requested)             216.4%        230.5%

The new implementation demonstrates a significant improvement in
fairness, reducing the standard deviation relative to the mean by
15.5 percentage points. While the reclaim accuracy shows a slight
increase in overscan (from 85086871 to 90633890, 6.5%).

The primary benefits of this change are:
1. Simplified codebase by removing custom memcg LRU infrastructure
2. Improved fairness in memory reclaim across multiple cgroups
3. Better performance when creating many memory cgroups

[1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
[2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 117 ++++++++++++++++------------------------------------
 1 file changed, 36 insertions(+), 81 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fddd168a9737..70b0e7e5393c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4895,27 +4895,14 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	return nr_to_scan < 0;
 }
 
-static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
+static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool success;
 	unsigned long scanned = sc->nr_scanned;
 	unsigned long reclaimed = sc->nr_reclaimed;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
-	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
-	if (mem_cgroup_below_min(NULL, memcg))
-		return MEMCG_LRU_YOUNG;
-
-	if (mem_cgroup_below_low(NULL, memcg)) {
-		/* see the comment on MEMCG_NR_GENS */
-		if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL)
-			return MEMCG_LRU_TAIL;
-
-		memcg_memory_event(memcg, MEMCG_LOW);
-	}
-
-	success = try_to_shrink_lruvec(lruvec, sc);
+	try_to_shrink_lruvec(lruvec, sc);
 
 	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
 
@@ -4924,86 +4911,55 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 			   sc->nr_reclaimed - reclaimed);
 
 	flush_reclaim_state(sc);
-
-	if (success && mem_cgroup_online(memcg))
-		return MEMCG_LRU_YOUNG;
-
-	if (!success && lruvec_is_sizable(lruvec, sc))
-		return 0;
-
-	/* one retry if offlined or too small */
-	return READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL ?
-	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
 }
 
 static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 {
-	int op;
-	int gen;
-	int bin;
-	int first_bin;
-	struct lruvec *lruvec;
-	struct lru_gen_folio *lrugen;
+	struct mem_cgroup *target = sc->target_mem_cgroup;
+	struct mem_cgroup_reclaim_cookie reclaim = {
+		.pgdat = pgdat,
+	};
+	struct mem_cgroup_reclaim_cookie *cookie = &reclaim;
 	struct mem_cgroup *memcg;
-	struct hlist_nulls_node *pos;
 
-	gen = get_memcg_gen(READ_ONCE(pgdat->memcg_lru.seq));
-	bin = first_bin = get_random_u32_below(MEMCG_NR_BINS);
-restart:
-	op = 0;
-	memcg = NULL;
-
-	rcu_read_lock();
+	if (current_is_kswapd() || sc->memcg_full_walk)
+		cookie = NULL;
 
-	hlist_nulls_for_each_entry_rcu(lrugen, pos, &pgdat->memcg_lru.fifo[gen][bin], list) {
-		if (op) {
-			lru_gen_rotate_memcg(lruvec, op);
-			op = 0;
-		}
+	memcg = mem_cgroup_iter(target, NULL, cookie);
+	while (memcg) {
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-		mem_cgroup_put(memcg);
-		memcg = NULL;
+		cond_resched();
 
-		if (gen != READ_ONCE(lrugen->gen))
-			continue;
+		mem_cgroup_calculate_protection(target, memcg);
 
-		lruvec = container_of(lrugen, struct lruvec, lrugen);
-		memcg = lruvec_memcg(lruvec);
+		if (mem_cgroup_below_min(target, memcg))
+			goto next;
 
-		if (!mem_cgroup_tryget(memcg)) {
-			lru_gen_release_memcg(memcg);
-			memcg = NULL;
-			continue;
+		if (mem_cgroup_below_low(target, memcg)) {
+			if (!sc->memcg_low_reclaim) {
+				sc->memcg_low_skipped = 1;
+				goto next;
+			}
+			memcg_memory_event(memcg, MEMCG_LOW);
 		}
 
-		rcu_read_unlock();
+		shrink_one(lruvec, sc);
 
-		op = shrink_one(lruvec, sc);
-
-		rcu_read_lock();
-
-		if (should_abort_scan(lruvec, sc))
+		if (should_abort_scan(lruvec, sc)) {
+			if (cookie)
+				mem_cgroup_iter_break(target, memcg);
 			break;
-	}
-
-	rcu_read_unlock();
-
-	if (op)
-		lru_gen_rotate_memcg(lruvec, op);
-
-	mem_cgroup_put(memcg);
-
-	if (!is_a_nulls(pos))
-		return;
+		}
 
-	/* restart if raced with lru_gen_rotate_memcg() */
-	if (gen != get_nulls_value(pos))
-		goto restart;
+next:
+		if (cookie && sc->nr_reclaimed >= sc->nr_to_reclaim) {
+			mem_cgroup_iter_break(target, memcg);
+			break;
+		}
 
-	/* try the rest of the bins of the current generation */
-	bin = get_memcg_bin(bin + 1);
-	if (bin != first_bin)
-		goto restart;
+		memcg = mem_cgroup_iter(target, memcg, cookie);
+	}
 }
 
 static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
@@ -5019,8 +4975,7 @@ static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc
 
 	set_mm_walk(NULL, sc->proactive);
 
-	if (try_to_shrink_lruvec(lruvec, sc))
-		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_YOUNG);
+	try_to_shrink_lruvec(lruvec, sc);
 
 	clear_mm_walk();
 
-- 
2.34.1


