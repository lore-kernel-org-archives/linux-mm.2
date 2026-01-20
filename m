Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5B49D2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F02A6B040E; Tue, 20 Jan 2026 08:57:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51AC16B0414; Tue, 20 Jan 2026 08:57:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4ACA6B0411; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6358C6B0410
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 022D913B4BD
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:57 +0000 (UTC)
X-FDA: 84352495836.20.2590822
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 37450C000C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768917476; a=rsa-sha256;
	cv=none;
	b=vQn171IlqXSTzNM6lNGtW4dOOxumdXVstO0HZQM58sxqGD50GNWUmqBcBqgAra1kVDcV7u
	eiyO1n3PXTHHBiQsmSuTeY4IFwCxuOrq+DFffMc0Fld6fhLIhSGKE2YfKzqtojBpA2pP2T
	GzCQJMstYRMjWj6r9lF1/SAI6nOXAOA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768917476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z3iHDlz4LcjlvXRZNU4d1JRXYNjVPszei2/T0yOjHXk=;
	b=k9VF9QhqDrZsaFB+cC+x6zpQZfKkSQZfiTIaxsQQO2Q3wzaeIizQ1NqxkuvT8ktGD/A7/B
	BSJxkcMyNX4DkGrhhykRKp8FHWxg6cZFgY7OzwXGQuNYeIopLlkq359y/fT2665+WDZ/CV
	j7aHtFMxZ+fW7nzhQp0gh78AQSE6Hj8=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dwTR72bCKzYQvHy
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:57:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 415B440592
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:57:47 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgCnCPnQiW9pwhTxEQ--.10691S7;
	Tue, 20 Jan 2026 21:57:47 +0800 (CST)
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
	skhan@linuxfoundation.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com,
	ryncsn@gmail.com
Subject: [RFC PATCH -next 5/7] mm/mglru: combine shrink_many into shrink_node_memcgs
Date: Tue, 20 Jan 2026 13:42:54 +0000
Message-Id: <20260120134256.2271710-6-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260120134256.2271710-1-chenridong@huaweicloud.com>
References: <20260120134256.2271710-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCPnQiW9pwhTxEQ--.10691S7
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw17Cr4kAw45CF1ruw45ZFb_yoW7ZFyfpa
	9xG3y2ya95JF4Ygws3tF4Du3Wakw48JrWYyry8G3WxCr1agFyrK34jkryfZFW5u3ykurnx
	ZryYvr1UWa1jqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRiF4iUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 37450C000C
X-Stat-Signature: dmuy8ko9pzhnenbg7ahekcbhsa3rrb3m
X-Rspam-User: 
X-HE-Tag: 1768917470-243334
X-HE-Meta: U2FsdGVkX19lEVE0QJv2NlC5bzaN9D96ofD/lCrTwZO2QwrqIuUFqnaM2CGVhkdUb1BSelLKeQJaQ8Do/TiZeEh70qW32o6vWwzZ0myqRdZMLhcVb+VVAGEjHyOwf3gkmiuQQPV25I0oUxU0zb3IOLei3K398ApwQSSbyE7S7M+zLoJlV5ar0nReOI1ZmniomYd2PCrOd9RYIjCSmJAhKkna6M/ZeoxBdXajGZ4FKtrSoO4WPU81qCOxVE1aIG7W+1FmBoLOcJwSlBfY4SW5OBKVsN+8/OqvzG89o0uUMdoU9HBvBjFHUww9VNva4JlUnLIG7OEcYpn31qniMtpCNzvCd/Yx9sjv7YaiQwjAfCUDGyOdT3U7JzAmwHRxFFo/A/A+CiOrfZ0nEqqIQ8rl9T0eTPz8iAkVwdaJZEqGtFP/3/MFWh/1jDqZ88kcDwzcUIx/Vm3m9boaXw2nr/phSRo2LqVJoYI6cx/40lsYA+zbkHU7u48eRCVi3/xtZaotsCRS1wvkp+CNHYAhwFguWhvOvwdL7psRI9+DuFVeM/J/8w/st0WX5uZ0cTKTBKA9VVTgdQllJsfCRpqj8LU73kw/wa6gX6mV2vnIUgZG4BpstDDsJHKUK5JuYcupJYduXVjJ5TdWxveiDiTDTMZICs5Wx17a9x5bmn4QKzKmn2436pPcOev15AbCyd76LuNvjzK+d+Pndz3RELofhsWpItYWK94aM5iSyYhL/XolKhFPNmIEO285kBKEAF6LKFZad9240J3oZWAt7HNx1nq1tS79H0n+wwiP8F1/2KlYxDX5UB6ZcnRUkR/cCPhqOg3kJjTwKmu/uTtjCWoahpR1gU/py6ydxJOC4U/3fzf7psKCQ5JHHJ/cLDq/DwGa//pK2FzPOQG4pJ05UyoFllrKiJjIUgrLow9Mi8YMAnxzednsbOPcwrQcW43eodiCD+C0otDfxLSj2IbsU5L6B7j
 +Qyzt+ax
 fKtoF0+kVvw+5Ybd5rkaP7GM94dU3a3i+cqDAgvKoBquxE6XAF8W4uOWL/J6kSkoXhQvBo4XTjZlomtMwZ9hxCCP90g5nzw4C6Ht/dMy5CIV2fffjt+Q7DkfUBDsqaPxhcg672PmAY+90i6igxZXDQS3MNSbjohQyBNzGy6wKjhzJuLwarhKWKdqRS+EBSwI1aFO0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The memcg LRU was originally introduced to improve scalability during
global reclaim, but it only supports gen lru global reclaim and remains
complex in implementation.

Previous patches have introduced heat-level-based memcg reclaim, which is
significantly simpler. This patch switches gen lru global reclaim to the
heat-level-based reclaim mechanism.

The following results are from a 24-hour test provided by YU Zhao [1]:

Throughput (number of requests)         before     after        Change
Total                                   22879701    25331956      +10%

Tail latency (number of requests)       before     after        Change
[128s, inf)                             19197	    15628	-19%
[64s, 128s)                             4500	    3815	-29%
[32s, 64s)                              14971	    13755	-36%
[16s, 32s)                              46117	    42942	-7%

[1] https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/
Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 101 ++++++++++++----------------------------------------
 1 file changed, 22 insertions(+), 79 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 27c6fdbc9394..f806838c3cea 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4965,76 +4965,6 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
 }
 
-static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
-{
-	int op;
-	int gen;
-	int bin;
-	int first_bin;
-	struct lruvec *lruvec;
-	struct lru_gen_folio *lrugen;
-	struct mem_cgroup *memcg;
-	struct hlist_nulls_node *pos;
-
-	gen = get_memcg_gen(READ_ONCE(pgdat->memcg_lru.seq));
-	bin = first_bin = get_random_u32_below(MEMCG_NR_BINS);
-restart:
-	op = 0;
-	memcg = NULL;
-
-	rcu_read_lock();
-
-	hlist_nulls_for_each_entry_rcu(lrugen, pos, &pgdat->memcg_lru.fifo[gen][bin], list) {
-		if (op) {
-			lru_gen_rotate_memcg(lruvec, op);
-			op = 0;
-		}
-
-		mem_cgroup_put(memcg);
-		memcg = NULL;
-
-		if (gen != READ_ONCE(lrugen->gen))
-			continue;
-
-		lruvec = container_of(lrugen, struct lruvec, lrugen);
-		memcg = lruvec_memcg(lruvec);
-
-		if (!mem_cgroup_tryget(memcg)) {
-			lru_gen_release_memcg(memcg);
-			memcg = NULL;
-			continue;
-		}
-
-		rcu_read_unlock();
-
-		op = shrink_one(lruvec, sc);
-
-		rcu_read_lock();
-
-		if (lru_gen_should_abort_scan(lruvec, sc))
-			break;
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
-
-	/* restart if raced with lru_gen_rotate_memcg() */
-	if (gen != get_nulls_value(pos))
-		goto restart;
-
-	/* try the rest of the bins of the current generation */
-	bin = get_memcg_bin(bin + 1);
-	if (bin != first_bin)
-		goto restart;
-}
-
 static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct blk_plug plug;
@@ -5064,6 +4994,7 @@ static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc
 	blk_finish_plug(&plug);
 }
 
+static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc);
 static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	struct blk_plug plug;
@@ -5093,7 +5024,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	if (mem_cgroup_disabled())
 		shrink_one(&pgdat->__lruvec, sc);
 	else
-		shrink_many(pgdat, sc);
+		shrink_node_memcgs(pgdat, sc);
 
 	if (current_is_kswapd())
 		sc->nr_reclaimed += reclaimed;
@@ -5800,6 +5731,11 @@ static bool lru_gen_should_abort_scan(struct lruvec *lruvec, struct scan_control
 {
 	return false;
 }
+
+static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+{
+	BUILD_BUG();
+}
 #endif /* CONFIG_LRU_GEN */
 
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
@@ -5813,11 +5749,6 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool proportional_reclaim;
 	struct blk_plug plug;
 
-	if (lru_gen_enabled() && !root_reclaim(sc)) {
-		lru_gen_shrink_lruvec(lruvec, sc);
-		return;
-	}
-
 	get_scan_count(lruvec, sc, nr);
 
 	/* Record the original scan target for proportional adjustments later */
@@ -6127,7 +6058,8 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 	 * For kswapd, reliable forward progress is more important
 	 * than a quick return to idle. Always do full walks.
 	 */
-	if (current_is_kswapd() || sc->memcg_full_walk)
+	if ((current_is_kswapd() && lru_gen_enabled())
+	    || sc->memcg_full_walk)
 		partial = NULL;
 
 	for (level = MEMCG_LEVEL_COLD; level < max_level; level++) {
@@ -6178,7 +6110,13 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 			reclaimed = sc->nr_reclaimed;
 			scanned = sc->nr_scanned;
 
-			shrink_lruvec(lruvec, sc);
+			if (lru_gen_enabled()) {
+				if (!lruvec_is_sizable(lruvec, sc))
+					continue;
+				lru_gen_shrink_lruvec(lruvec, sc);
+			} else
+				shrink_lruvec(lruvec, sc);
+
 			if (!memcg || memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B))
 				shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
 					    sc->priority);
@@ -6196,7 +6134,12 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 
 			flush_reclaim_state(sc);
 			/* If partial walks are allowed, bail once goal is reached */
-			if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
+			if (lru_gen_enabled() && root_reclaim(sc)) {
+				if (lru_gen_should_abort_scan(lruvec, sc)) {
+					mem_cgroup_iter_break(target_memcg, memcg);
+					break;
+				}
+			} else if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
 				mem_cgroup_iter_break(target_memcg, memcg);
 				break;
 			}
-- 
2.34.1


