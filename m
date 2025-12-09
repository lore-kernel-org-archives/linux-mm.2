Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D71AFD3B7E2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103C66B0008; Mon,  8 Dec 2025 20:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FC06B000E; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33886B000D; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2C056B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A67114037A
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:41:18 +0000 (UTC)
X-FDA: 84198229836.22.A7F2F51
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3086C1A000C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:41:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765244476; a=rsa-sha256;
	cv=none;
	b=JOWBcedPTHzvM8iIqGQN+6GuPT2OE5x0kmTTcEsDuFt9sxyvZQhfQHFUqaM9U2Kzz8UTWr
	bWadsCAON5BlIRNhPaJaHj2+ObHcEMV5x2c4znB3ikuJqZ9iqov7+IRWjrgMVU0JA1MtcM
	5Ldq+AL5jVozm6K7EOINVrqlJM9nfnA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765244476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0AYVrDV9X4pG5pSR9Ut0632zWuUVDjNhYhGg8hcWmBU=;
	b=l9LHPDM3qNHUEEOlnFR5MPTDi+xmC0rt2L3cXf3cCqIv5CD7eIhKTZjsTYq9SkP0BYEQ38
	szjfhy/OBWsIqS+liG09Tm1CWivxJCeMGK8TLe7Zx1QIMfGzRBkKF2oHE81ahvuyjr725L
	PQRZuqWvmXS6NGg1uv/IvTYwCAKukh8=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dQM4p19dDzYQtjc
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:40:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id C94031A084B
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:41:10 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgBnRlAafjdpkF9fBA--.23909S3;
	Tue, 09 Dec 2025 09:41:10 +0800 (CST)
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
	zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com,
	zhongjinji@honor.com
Subject: [PATCH -next 1/5] mm/mglru: use mem_cgroup_iter for global reclaim
Date: Tue,  9 Dec 2025 01:25:53 +0000
Message-Id: <20251209012557.1949239-2-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251209012557.1949239-1-chenridong@huaweicloud.com>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBnRlAafjdpkF9fBA--.23909S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw1rJFyrtryUKF15Xr1DJrb_yoWxXF1fpF
	ZxJ3yay3yrJr1agF4fKF4Dua4rA3y8Jr45Jryxtw1xAF1fK34Fg342kr1xXFW5uFZ5Zr17
	GFyYyw1UW3yjvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0pRlJPiUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3086C1A000C
X-Stat-Signature: fp64tprwnfa8nf16yzx6z6khx1ssrw3q
X-Rspam-User: 
X-HE-Tag: 1765244474-154869
X-HE-Meta: U2FsdGVkX19oo862aOducZUAzo+n/ILAWCI1cmLrRiDmbzMjkhwnuf02oMl0cLa+2Q/O8JaEtbmUKqSc2VpCAT3g3BGuAJ0PNtRiG0D0ABFmWCdrAJVaprBpbWFgGJkDIHbyBkGWP2F/2guFeAoeO8EPUmctvOw4WccyrBQn9BmveHYgB8VNwxgsaGhZe1XExazfxdESvqgnZisrk4PmKbG7cjmJDutCQd4urZJl5oKNZFCvErGbAcNwhE/U/ZBMQha/P7CuC7D2QEq8EMjL2tcN9WeYPszaiIC7ZpIneSoImhgkMQt4+Sge8js4Bt0NIR+zBiRpFVzw3q3K3gReDx/ym/PT0X3jVngkdpW/zTQusEJ3YZHA36DuorAlIzBnTsHs3hzFSGRUhhE7GOV9+byco4uBn3qluHtr9dT32THgIM5+sTD6s9nokORwLMeDygq+HgMXeqbVy5iGBPoN/Q6Zc2xj49+OmcRsaGyB1KWBD4ZueFhcCoP53p0oNkfAsjTUwWiN8GPeOM3Q1qwKQFIoZhip36iLcDIfqOtB2PCCfKRDXSU5BXW2k1nDGbEqUko1u3X7jYpwe1ctzL3x2B3D8MT4/393atxCNWzp8uibKVmZ6opyihvyNv40J3ryyFzhgWjNihztEygRYZvfWwXtWoueE9vwcTlNK0Dd3cxUMZW+RKtp7PVFJwHiauFTvAXMPf6l1q4uCSKb+WAxkRaz3Spbjj165Ym7UdEq7/WDVAFngYtJC708JH4rD62HnrU/PSwvCI3D8d1PyIdEpSzFaOnHYi7+ILW4hEmgiinRcu7xGgEDdsZChLhAUWgOKkXV9Jecbp6yCXo8b9i7OFJyClwCkQO7LawmSWQQ+aannGZYvAIO6qpG/nQWKnpr4EED5f378ITj9Q5oET7LzXrfz3UGEmlbG0KfkGhlhk2DeAOWgLoOvPhoaI99tzyAvK3VG4cfpjkCl9bNgPx
 cpRwIqFu
 G/43he6GXpuzFsTwo2ELNW5c/tCOol03NLy3GNUaYQ+Wh+JA1U5GtZibXt+MeyR7B1YkfMSPFcRm4lyAlgbOpVj+Y5hwCsQAgdZoANn0D26f9BMF3JpbyKweQ0nkgZ7p6VYrrkT437kZt2qKV4ZOwB6S1WCoO9UZwiKY7wOsb2y8Tub/RhFopUll6YWgttMfkERx2EGMHPWTGi5srDsDAy1ma4jM006KrCbR3GMeggfNRKOtCIJ9oafPurO9QYcr/G9THgdWfFoENN95cwh765i1Db06qJ+/f5bIrRm8f49b4t3WHTSqUhRKpOA==
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

It performed a stress test based on Yu Zhao's methodology [2] on a
1 TB, 4-node NUMA system. The results are summarized below:

	pgsteal:
						memcg LRU    memcg iter
	stddev(pgsteal) / mean(pgsteal)		106.03%		93.20%
	sum(pgsteal) / sum(requested)		98.10%		99.28%

	workingset_refault_anon:
						memcg LRU    memcg iter
	stddev(refault) / mean(refault)		193.97%		134.67%
	sum(refault)				1963229		2027567

The new implementation shows a clear fairness improvement, reducing the
standard deviation relative to the mean by 12.8 percentage points. The
pgsteal ratio is also closer to 100%. Refault counts increased by 3.2%
(from 1,963,229 to 2,027,567).

The primary benefits of this change are:
1. Simplified codebase by removing custom memcg LRU infrastructure
2. Improved fairness in memory reclaim across multiple cgroups
3. Better performance when creating many memory cgroups

[1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
[2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com
Suggested-by: Johannes Weiner <hannes@cmxpchg.org>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Johannes Weiner <hannes@cmxpchg.org>
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


