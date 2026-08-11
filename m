Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE1EC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CEDB6B00A1; Tue, 11 Aug 2026 16:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7456B00A3; Tue, 11 Aug 2026 16:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E625C6B00A4; Tue, 11 Aug 2026 16:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B04B36B00A1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:32:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 296E1160206
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:45 +0000 (UTC)
X-FDA: 85090137090.11.8F602C4
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 884F24000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rqcdEhl9;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480363;
	b=M/OmJZXIMEeYgl6ts6f3DbfETNet26mweX1/TzXF2aBOfzSEBpq9P8Jjt7ndnYFkDcy/vo
	kGIgwSVbSw9vBeFVgm2E1HVgO3QeD7bf3LuvGrF8C9PBWf+LB2cPRmoQ9ezeADIr/Msi+q
	YNusZ/IPcanP+WZr6PlvEXAavPYTOQg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rqcdEhl9;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBoE71wnBwMOfVKAQwpkXO2zfBhsgRR5WTCUnnYK0XI=;
	b=JDbI0dbseIZlMb1Wxa5fRuVuBdje2MqIZBFS6rMr+MdOtVZgbUAU7shhsQSjmyI1O6YfI2
	k6MG+5dhdIjdFlFGxAGNmAhRx4a7gh6lIiGWM5Nvc5xh/VGRx3sj9SOPuo7XyU2392lXs8
	dU+8AkJnIz2ZTtlEvczR8pv1Oi0qExw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RBoE71wnBwMOfVKAQwpkXO2zfBhsgRR5WTCUnnYK0XI=;
	b=rqcdEhl97KNlZGT6AQVoZldHYtPVXRxa52iXODLrzeenxnlhF05ds+4XLpENW7ZnPwYmcu
	bdVbTk10D1q5qehMWWCSl3vwMyvuL85qTD7qEebW4amHgeE0yZhA3S5VqgwC8gYWBHWkf4
	cDLA1UgoMGl3/SBAjSBG+MP6mV/ajA4=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] memcg: remove lru_gen_soft_reclaim()
Date: Tue, 11 Aug 2026 13:32:00 -0700
Message-ID: <20260811203203.3456029-7-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 884F24000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9mfffray49i5965ys4q66qoxxgjufxgk
X-HE-Tag: 1786480363-260321
X-HE-Meta: U2FsdGVkX1+5nWcWO9jACgaGwTJQ0myU89oV+OT+kRb6ykiw3KY61dMphEq6PYVlUoN/AgDFJpzz2SsxZPXypuw2SKwV/9PpE0Ded36Q2D0fK52auGphZzYHphWOV8veA+rzgQalGlvl5CPujmRIvGPjU6vNiViiks0SH0bFZG3LwaCcGzFvILNKO/HlVnbHm93A73vq8O1lXhSeqnNcc4fAHgDhFvzOtBWzkkELMvtVa8tejMEMbo3S6YE3JRk1pVTbtUs9+wwtit+I2O7ThfoCycX5V/RGKqtQUdHoxY0ZsMRjv6J3ovsVh578dg2QaYT3AgoubieMwnvB7y0Dhw8O0trAdlLdEepv/VferIKwC3XGFi8fFGjjkpDcLyUc68YH6MyTHAJVHsHBMRXrFO01RwOYTWUcmcyqjvCMdLRxnH4dY2ziZiOZOUdbyDDoUI1hhn9fLm7vjmoWnkgcd9JZEEA3+9xTHcXmMXqsLdl94ucyC1AIzhM8MivyunoS9D4mShWQaTBHNSCsr8x2KvK+z3UEfsAO0JcKAhYHBUNoqy7fkJPAS5bFJRR3+jEAHgVoRfKJ/NqiB/cpdnJ8r9+g500MQRODB1DN/8J+30LFrFgT5SaSjMvGxHsVmD7wAJCmPvd+jvAr1r9+QjahxWqes8Xlk/C1LsA/Cn7HclPb2MkbzFmPCrqmTGMzwKP6evJcYBwd22oVL0ZcgbM1iyzTJgUJSY9DiF8TKsPLNAz9iZ6REGWbXvRB4cBUhZt+b6vIUXZusUOLEi/k0a2H4qjCsizdnWmQkIqoqv4qfOeutyCSrevBslZ4dT+pKD0m+G0d9gOCScqi5UT/LoPuS1r11Tr5f4ykVN0rIQJo2Lc4VIoRredlgy38y8sTqeGfvh4vDBjJSJj/BTHjnLRCMYDfOuSCt1HNxaUEet8PUQ7JtXIfghz33pd/zmpBk8yhQc/d01KdGiAnDiZzmKi
 2+LWU4k+
 xSGfD39ZXiaMkT8h8Svo5Qkeju680UZ5alzPS3SjMkopNTvx+RaXsJunUTuDn+Qpsp8+AJhdYzHh4ary+x8P9/VQCfcUHCHKZT7dDFL59je7cg/Lz91KZYasd08phq7GXTx9sGbb0HzLzk6e43cRFfWrpvwc3CpYOU7MQRTFLbnaM8J0+xfkzfIuarv8J5l51fviAYF/JEzGT6TlMTtGCbrlxEg2uyTfIicJIOky0q6reVPLO1ZJdlc2PSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The soft limit rbtree was the only caller. Dropping it leaves
MEMCG_LRU_HEAD unreachable, since nothing else ever rotates a memcg with
that op, so remove the op too and update the memcg LRU comment.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/mmzone.h | 30 +++++++++++-------------------
 mm/vmscan.c            | 16 ++--------------
 2 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..01fabd0ece0d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -635,35 +635,32 @@ struct lru_gen_mm_walk {
  * For each node, memcgs are divided into two generations: the old and the
  * young. For each generation, memcgs are randomly sharded into multiple bins
  * to improve scalability. For each bin, the hlist_nulls is virtually divided
- * into three segments: the head, the tail and the default.
+ * into two segments: the tail and the default.
  *
  * An onlining memcg is added to the tail of a random bin in the old generation.
  * The eviction starts at the head of a random bin in the old generation. The
  * per-node memcg generation counter, whose reminder (mod MEMCG_NR_GENS) indexes
  * the old generation, is incremented when all its bins become empty.
  *
- * There are four operations:
- * 1. MEMCG_LRU_HEAD, which moves a memcg to the head of a random bin in its
- *    current generation (old or young) and updates its "seg" to "head";
- * 2. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
+ * There are three operations:
+ * 1. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
  *    current generation (old or young) and updates its "seg" to "tail";
- * 3. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
+ * 2. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
  *    generation, updates its "gen" to "old" and resets its "seg" to "default";
- * 4. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
+ * 3. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
  *    young generation, updates its "gen" to "young" and resets its "seg" to
  *    "default".
  *
  * The events that trigger the above operations are:
- * 1. Exceeding the soft limit, which triggers MEMCG_LRU_HEAD;
- * 2. The first attempt to reclaim a memcg below low, which triggers
+ * 1. The first attempt to reclaim a memcg below low, which triggers
  *    MEMCG_LRU_TAIL;
- * 3. The first attempt to reclaim a memcg offlined or below reclaimable size
+ * 2. The first attempt to reclaim a memcg offlined or below reclaimable size
  *    threshold, which triggers MEMCG_LRU_TAIL;
- * 4. The second attempt to reclaim a memcg offlined or below reclaimable size
+ * 3. The second attempt to reclaim a memcg offlined or below reclaimable size
  *    threshold, which triggers MEMCG_LRU_YOUNG;
- * 5. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
- * 6. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
- * 7. Offlining a memcg, which triggers MEMCG_LRU_OLD.
+ * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
+ * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
+ * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
  *
  * Notes:
  * 1. Memcg LRU only applies to global reclaim, and the round-robin incrementing
@@ -696,7 +693,6 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg);
 void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
-void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
 void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
 void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
@@ -737,10 +733,6 @@ static inline void lru_gen_release_memcg(struct mem_cgroup *memcg)
 {
 }
 
-static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
-{
-}
-
 static inline void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
 {
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 790b50c78a2e..71244cf33d59 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4373,7 +4373,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 /* see the comment on MEMCG_NR_GENS */
 enum {
 	MEMCG_LRU_NOP,
-	MEMCG_LRU_HEAD,
 	MEMCG_LRU_TAIL,
 	MEMCG_LRU_OLD,
 	MEMCG_LRU_YOUNG,
@@ -4395,9 +4394,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	new = old = lruvec->lrugen.gen;
 
 	/* see the comment on MEMCG_NR_GENS */
-	if (op == MEMCG_LRU_HEAD)
-		seg = MEMCG_LRU_HEAD;
-	else if (op == MEMCG_LRU_TAIL)
+	if (op == MEMCG_LRU_TAIL)
 		seg = MEMCG_LRU_TAIL;
 	else if (op == MEMCG_LRU_OLD)
 		new = get_memcg_gen(pgdat->memcg_lru.seq);
@@ -4411,7 +4408,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 
 	hlist_nulls_del_rcu(&lruvec->lrugen.list);
 
-	if (op == MEMCG_LRU_HEAD || op == MEMCG_LRU_OLD)
+	if (op == MEMCG_LRU_OLD)
 		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
 	else
 		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
@@ -4489,15 +4486,6 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
 	}
 }
 
-void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
-{
-	struct lruvec *lruvec = get_lruvec(memcg, nid);
-
-	/* see the comment on MEMCG_NR_GENS */
-	if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_HEAD)
-		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
-}
-
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
 {
 	struct lruvec *lruvec = get_lruvec(memcg, nid);
-- 
2.53.0-Meta


