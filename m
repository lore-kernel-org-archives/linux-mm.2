Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 003C0C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7D4F6B00AA; Wed,  2 Sep 2026 13:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55176B00AB; Wed,  2 Sep 2026 13:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B346B00AD; Wed,  2 Sep 2026 13:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFDDB6B00AA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:43:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F99AA374C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:36 +0000 (UTC)
X-FDA: 85169544432.04.4455E16
Received: from mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
	by imf10.hostedemail.com (Postfix) with ESMTP id 38C01C000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g6JYDRmf;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.13 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788371014;
	b=pfmGZpv4EnGIM0siuUAg7S0T90xRbfA9nZeEAXTfLwlN96a5ZYeUSnf7cI92+ywlnQ3Cjk
	k2ismC4Nx78E/44mNxKSj4Ow4QOCP1+IRpCFJ/NOtDa4FcjEPJaRyfG5XPNOOLAo3Zmo0p
	+bms0kYgWfQNaLTm23EUqHpne+Lz95A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788371014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhrKvxgt9aiem6UfEmiohKlvwDzg7obDFE+sZGqqoMM=;
	b=3OfiOFok4By1aLV/sQzrXxhGGqvc5UtolNJAy5aw5t+NkdIDoYZBl3yvgg/bLMOpGE8P1P
	/LoHuvmXKGwtSor3CTr181HHx4vOjnUPURPJdTRcXWY217xe5atFMpRMB1SLYcwk33Ch7T
	Bwo+khKYj4cpzFZ2HpQ5ysZHrI63wCE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g6JYDRmf;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.13 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9AizrKxZG1A7ShaemAVD30+q00uib56tFKexFmDnGGk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371013; v=1; x=1788975813;
 b=g6JYDRmf5diyjSHH+ahaOOJ3ofT/5R6+grTxr2XOt9NtCdNPPKf9t/VIU1L6o3Fqc80fR6QJ
 HpRu1UhE3Pjwnh1Ztlq1LiIwAusVepuHgnCp9XVGDEU3GAmoewYGqPMxHK9mVDLhRWKzFITwKwX
 2RhLEm5tykCZgTCGq9ON25W4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d841d0e1b85067ee;
	Wed, 02 Sep 2026 17:43:32 +0000
X-Mizu-Trace-ID: d841d0e1b85067ee
X-Migadu-Flow: FLOW_OUT
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
	tjmercier@google.com,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] memcg: remove lru_gen_soft_reclaim()
Date: Wed,  2 Sep 2026 10:43:08 -0700
Message-ID: <20260902174311.1772372-6-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 38C01C000B
X-Stat-Signature: mh7hqforexz1ecq84go6a95cy33f9ehi
X-HE-Tag: 1788371013-678373
X-HE-Meta: U2FsdGVkX1+d1BHdBL8UoxQgAD3kvkJJnd5KaCS2ZbQG8QJ46wU728zX32FG8YeTbKZhOKRX0hi1ShHLx0bOJNquWEpdUzKhGm1LkGTdBA0aB+v8ON9uu4xv0TH6GJgA/LNAK8V8NEZQeHJ7WEpqlZDT5tVkgcwDYxaknWC/7Dttyy7pRoNaoDyQ0kKuh9DRSAgCDzJrSH4Px9V4EJD6qK1NZZzNnOg1/VeDhmJ/6FmzEJpr16rcuQZj4NX/XzQ06pdcUVcIv8A5prZQYTvwgEyzrGZwQLIsqXhH+632ohSuZpynFRMLJ62JrK/GhBMZEMz9JxImQ6f9BHQsLPqUzcO4i8RHizP+KeBnUcQa7eVd6Q6eT9gCix0/MCLbVjlLz6yW0SdNJdBdzWTBKiaBOpDNXONla+Q0Ke9ui6nZntdAuMuAfiWA55k6718dpTwrkL82LrsjBr3DOlGC2dId7QP06WEMrL7t+FOoHZCqaiJXu5yK7/dV/zEFB+6nFUxuAEyL5Fte6NqguyPAaNvHkiYNhwGU96iWyq/sL3KGP2gy/wfmltAUExh4FnX5nA6AyV0T5CtC5HQq5lBBfyX0A9OMnrE2c/Jhl7emgLyQPvshqcrpLYYQbo5gqICesUR8gmwaTSuogkzDk1blFBA4jUffyIs0E2N/7jWttKPwqfcAGc4z8lS8DDkB84pEeR4tG/ofTEI2Cz2FOkhXgT+Nh1SP+A+oKPCnN3GNhWkm8pxRE7DhuJIQ8BFkBszOD7LV90XREe4oD1nsd8OSZmPNFyG9mIXjpHOQiIzMrHvasS4C0Kj2UAhVnCQvGKg5P6IvQlFrsu0W3XxjRVw4V9nv3Z4/QeDPnuRCqorp0Hmce4iXYyykd2l7ys1LgA2+W21/Ca8mj3b4X6RX4qpgX8ymSk5ou6vSxfsQ4VV5PPxBlHdAEOlPkzAJddrTqdSjkCgafkHdd85ok3NCgwxpFmu
 VFYTv5DJ
 8rFZsnYozvD7gu7QG/V49Z5pT3G7zgkHzMo4uFsOxtloCCcMvGHjD/jAOdwzsH0T7TeOLOCbJ4ZHp60C65zypBk/bwX5x4kuxCvovgo21w7pMDx08jBKa4b0Yiu9PUHbbPp6z6dsnjrLHogMaQucD4aqwCks68jKbHhGASrkYrJw1HeyqBcVX4AtGnSbJgQn39RjTbZ1FGpCS5FubaSiSYwDGq5Ua1rTgFnYK1jeq/i8O2LVWVc0PpbZ5+2cz92T9x7Qa99ruMZHqnu0tuPpzX5Que6lW/X64bPrXW+wT2S0RXyBsi/f6x9TyNf0179Yrha4W
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
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mmzone.h | 30 +++++++++++-------------------
 mm/vmscan.c            | 16 ++--------------
 2 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 67c84a8a7258..84e237f2c17d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -638,35 +638,32 @@ struct lru_gen_mm_walk {
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
@@ -699,7 +696,6 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg);
 void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
-void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
 void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
 void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
@@ -740,10 +736,6 @@ static inline void lru_gen_release_memcg(struct mem_cgroup *memcg)
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
index d66b5cd167d6..deb087c57007 100644
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


