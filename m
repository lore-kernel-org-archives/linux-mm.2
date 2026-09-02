Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF384C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECB366B00A1; Wed,  2 Sep 2026 13:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3456B00A9; Wed,  2 Sep 2026 13:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB95A6B00AA; Wed,  2 Sep 2026 13:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0D2C6B00A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:43:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18600140248
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:34 +0000 (UTC)
X-FDA: 85169544348.14.CDA7245
Received: from mta0.migadu.com (out-91.mta0.migadu.com [91.218.175.91])
	by imf19.hostedemail.com (Postfix) with ESMTP id 25EC51A000E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cOv5RiSt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.91 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788371012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGRLKSzvgRrzPK73lhYX9Hp5I7FzZOsof0BTtA+TDBk=;
	b=Qq2bXOORK5o6W2JhRx3bY/mKmyOjYd8BYCSQF/hmwq/t1mXwnjvIcK9zO0rUCajfvWJeZZ
	uaPcq99LcrFSAg3VB3AcP0okkuwiFkffXbYJMpYMoZCzWwlojyS5kgNQwCs413KoYX8gS8
	Ut/Eim4fPHGVxi/jMdUSo7NiPJ8eQ9o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cOv5RiSt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.91 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788371012;
	b=xmfEZ2Zpxag+2uNJ35WpoJz7fAhfN7zQ/rVzNKn9lM9DlZGeZz9bphCgye32Ik8c6ZGHdY
	zWTUa12pNL0WONjJxWDLu7yjP5H8XM5MURXpATmbeRc2KZ3mOhR/tFQweRUaSH07Dmx2il
	maBWkmGEjiQqFAgTIFovHNxSxxQJPS4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gY8UgLTxAlbW8yPVd99WbKZIyXZ2KilM8xZgSO83UMQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371010; v=1; x=1788975810;
 b=cOv5RiStDPkKe3StAuk4Z21LlRkSXwr24de6DyhrY5ooIsuz0FqbGWqy7rbKqcfono59lzMi
 r6hoQfNuDM0ZeKNdGUC+MustQflBSSfSZlRkrFwWKGcoPwSftg4rJA3jAGYc2/RDQJhAJq8du6i
 3dKISJ0MpBQ6on4clJIXrg14=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a5b7fdeee88ee0da;
	Wed, 02 Sep 2026 17:43:30 +0000
X-Mizu-Trace-ID: a5b7fdeee88ee0da
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
Subject: [PATCH v2 4/8] memcg: remove the soft limit rbtree
Date: Wed,  2 Sep 2026 10:43:07 -0700
Message-ID: <20260902174311.1772372-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 95whgznioehw5y81dp8g3ygbjoshpgbq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 25EC51A000E
X-Rspam-User: 
X-HE-Tag: 1788371011-215870
X-HE-Meta: U2FsdGVkX18G5L8nKQ3puQcJDK9/AQzvkKHcjmokF1MMsaXgVt70xpTAtPpY3pzxcx/eX1VaXWOPLr3fQp+UPLMPjHk48zmnRTNqeFC2yK+bE/4p8b+v5F480M2j7EMNtP6Vyu/TjfE+31VDbga4OXlIXGmSUnEXDXoOXVep1kPGvmVQygne1h413/hmjKXwtxMwWXNlwnML3AjwSlEYiX3HM6JV46uQG/IjG33wDqcpLgUOTrhf+/oZNRBtFzjb+q+MoAVkWSpGmHdgSNYCpVNwiYSWgzjN89OTe+ruUlzp92ZSUJ3IbMcuaKsVl0p59VW7HDc3lnHo49aJw8r5mpRcVynxddp/F1Xulrn/7QVkQEdBy4hJul47dzPDbN/K+nEMvEzy1u2nE/H29vKsmmly0QSXyKbzqCpShq/9ys/AnAxBRo7fSEoJFheiprsiYJepWrWbQG0FtRvJtler2wQN6pr67WgqsTuCMY1K5KQ9s0aBWYXqFkf/0YB7UdINa5c/SIIIsS3y5I2pL1iMnl2nJ+abSH38exLNR45OiYR4wzNybvqQ6lyW2FJA2KRuzBpoG4B+A84RD/dwmX831vUZ826yPhLVYu9ueOhpF6no2KTc8XQb05NAR7y3s0EH0ELoo6a2/jIKET4JiM1M7BhehbRAWgm9i0DBKRczzMJFPDZfcZ2j6urMG9SVjvbaboG/bW4pILYP4cVPXRQ0OuCKw1ATC1KunuijjS9c0TjlKUzMaqFKVCtjdhGFLzmKPmFspKyjVE90AreSeUXGUhTlgVvXB7A6sMj/V93lhQHcJAFEDanh28jinM1plx7A18zBijiXOGIkQU2Lp2QCNW/hdjaj/arobU9Bsjz8a9+TlJ6gTCROfaD0bYc2M5aLN48gIjM8ik2tOrocbMvFWYO02MzquaEB30XYiYPm/zwLn5t9+XrMI2fbDStUmkcVFDPaWwzIcRyfZlP0CAj
 A3EowUir
 MgHXnVakPlcBu8/AWF7dJUhMsKrFvD9V+dxFC9D1kajAMlEsP9MkfkpqvDuVQvwgAR9J6skjQmkr9WEU5yVFAurnKu6oj0ScAjV+rRQ7HylgRYxgyDQ4pN/xr6vSw7FdiwQnta1xycJLRSKHgY+9qzViIzNDL9RuFbIwXYcv65tkTtwWMIu44GW5ZmTsoO9Zz0rLJWdyRW7+Zs7yuuDh98A+5DQ1+2N8uzGCZAf9qoyUx2ZFrkqLAWC+9QZsXOCqCaBDwCaJA/7a2C4xkK6mPpNRxo446705Y6OHhUmpOkArnXamO6h9J3mGAMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With soft limit reclaim gone, the per-node rbtree of cgroups in excess
has no readers left. Remove the tree, the helpers maintaining it, and
the subsys_initcall that existed only to allocate it. memcg1_check_events()
no longer needs to feed it, which also drops the last caller of
lru_gen_soft_reclaim().

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memcontrol-v1.c | 176 +--------------------------------------------
 mm/memcontrol-v1.h |   2 -
 mm/memcontrol.c    |   1 -
 3 files changed, 2 insertions(+), 177 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index b38b8d0f7f51..475f998b7643 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -17,23 +17,6 @@
 #include "swap_table.h"
 #include "memcontrol-v1.h"
 
-/*
- * Cgroups above their limits are maintained in a RB-Tree, independent of
- * their hierarchy representation
- */
-
-struct mem_cgroup_tree_per_node {
-	struct rb_root rb_root;
-	struct rb_node *rb_rightmost;
-	spinlock_t lock;
-};
-
-struct mem_cgroup_tree {
-	struct mem_cgroup_tree_per_node *rb_tree_per_node[MAX_NUMNODES];
-};
-
-static struct mem_cgroup_tree soft_limit_tree __read_mostly;
-
 /* for OOM */
 struct mem_cgroup_eventfd_list {
 	struct list_head list;
@@ -99,133 +82,6 @@ static struct lockdep_map memcg_oom_lock_dep_map = {
 
 DEFINE_SPINLOCK(memcg_oom_lock);
 
-static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
-					 struct mem_cgroup_tree_per_node *mctz,
-					 unsigned long new_usage_in_excess)
-{
-	struct rb_node **p = &mctz->rb_root.rb_node;
-	struct rb_node *parent = NULL;
-	struct mem_cgroup_per_node *mz_node;
-	bool rightmost = true;
-
-	if (mz->on_tree)
-		return;
-
-	mz->usage_in_excess = new_usage_in_excess;
-	if (!mz->usage_in_excess)
-		return;
-	while (*p) {
-		parent = *p;
-		mz_node = rb_entry(parent, struct mem_cgroup_per_node,
-					tree_node);
-		if (mz->usage_in_excess < mz_node->usage_in_excess) {
-			p = &(*p)->rb_left;
-			rightmost = false;
-		} else {
-			p = &(*p)->rb_right;
-		}
-	}
-
-	if (rightmost)
-		mctz->rb_rightmost = &mz->tree_node;
-
-	rb_link_node(&mz->tree_node, parent, p);
-	rb_insert_color(&mz->tree_node, &mctz->rb_root);
-	mz->on_tree = true;
-}
-
-static void __mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
-					 struct mem_cgroup_tree_per_node *mctz)
-{
-	if (!mz->on_tree)
-		return;
-
-	if (&mz->tree_node == mctz->rb_rightmost)
-		mctz->rb_rightmost = rb_prev(&mz->tree_node);
-
-	rb_erase(&mz->tree_node, &mctz->rb_root);
-	mz->on_tree = false;
-}
-
-static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
-				       struct mem_cgroup_tree_per_node *mctz)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&mctz->lock, flags);
-	__mem_cgroup_remove_exceeded(mz, mctz);
-	spin_unlock_irqrestore(&mctz->lock, flags);
-}
-
-static unsigned long soft_limit_excess(struct mem_cgroup *memcg)
-{
-	unsigned long nr_pages = page_counter_read(&memcg->memory);
-	unsigned long soft_limit = READ_ONCE(memcg->soft_limit);
-	unsigned long excess = 0;
-
-	if (nr_pages > soft_limit)
-		excess = nr_pages - soft_limit;
-
-	return excess;
-}
-
-static void memcg1_update_tree(struct mem_cgroup *memcg, int nid)
-{
-	unsigned long excess;
-	struct mem_cgroup_per_node *mz;
-	struct mem_cgroup_tree_per_node *mctz;
-
-	if (lru_gen_enabled()) {
-		if (soft_limit_excess(memcg))
-			lru_gen_soft_reclaim(memcg, nid);
-		return;
-	}
-
-	mctz = soft_limit_tree.rb_tree_per_node[nid];
-	if (!mctz)
-		return;
-	/*
-	 * Necessary to update all ancestors when hierarchy is used.
-	 * because their event counter is not touched.
-	 */
-	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		mz = memcg->nodeinfo[nid];
-		excess = soft_limit_excess(memcg);
-		/*
-		 * We have to update the tree if mz is on RB-tree or
-		 * mem is over its softlimit.
-		 */
-		if (excess || mz->on_tree) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&mctz->lock, flags);
-			/* if on-tree, remove it */
-			if (mz->on_tree)
-				__mem_cgroup_remove_exceeded(mz, mctz);
-			/*
-			 * Insert again. mz->usage_in_excess will be updated.
-			 * If excess is 0, no tree ops.
-			 */
-			__mem_cgroup_insert_exceeded(mz, mctz, excess);
-			spin_unlock_irqrestore(&mctz->lock, flags);
-		}
-	}
-}
-
-void memcg1_remove_from_trees(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup_tree_per_node *mctz;
-	struct mem_cgroup_per_node *mz;
-	int nid;
-
-	for_each_node(nid) {
-		mz = memcg->nodeinfo[nid];
-		mctz = soft_limit_tree.rb_tree_per_node[nid];
-		if (mctz)
-			mem_cgroup_remove_exceeded(mz, mctz);
-	}
-}
-
 static u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
 				struct cftype *cft)
 {
@@ -336,7 +192,7 @@ static void mem_cgroup_threshold(struct mem_cgroup *memcg)
 	}
 }
 
-/* Cgroup1: threshold notifications & softlimit tree updates */
+/* Cgroup1: threshold notifications */
 
 /*
  * Per memcg event counter is incremented at every pagein/pageout. With THP,
@@ -405,17 +261,8 @@ static void memcg1_check_events(struct mem_cgroup *memcg, int nid)
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		return;
 
-	/* threshold event is triggered in finer grain than soft limit */
-	if (unlikely(memcg1_event_ratelimit(memcg,
-						MEM_CGROUP_TARGET_THRESH))) {
-		bool do_softlimit;
-
-		do_softlimit = memcg1_event_ratelimit(memcg,
-						MEM_CGROUP_TARGET_SOFTLIMIT);
+	if (unlikely(memcg1_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRESH)))
 		mem_cgroup_threshold(memcg);
-		if (unlikely(do_softlimit))
-			memcg1_update_tree(memcg, nid);
-	}
 }
 
 void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
@@ -2391,22 +2238,3 @@ void memcg1_free_events(struct mem_cgroup *memcg)
 {
 	free_percpu(memcg->events_percpu);
 }
-
-static int __init memcg1_init(void)
-{
-	int node;
-
-	for_each_node(node) {
-		struct mem_cgroup_tree_per_node *rtpn;
-
-		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
-
-		rtpn->rb_root = RB_ROOT;
-		rtpn->rb_rightmost = NULL;
-		spin_lock_init(&rtpn->lock);
-		soft_limit_tree.rb_tree_per_node[node] = rtpn;
-	}
-
-	return 0;
-}
-subsys_initcall(memcg1_init);
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 1e394269c613..fd611e66859a 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -41,7 +41,6 @@ bool memcg1_alloc_events(struct mem_cgroup *memcg);
 void memcg1_free_events(struct mem_cgroup *memcg);
 
 void memcg1_memcg_init(struct mem_cgroup *memcg);
-void memcg1_remove_from_trees(struct mem_cgroup *memcg);
 
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
 {
@@ -98,7 +97,6 @@ static inline bool memcg1_alloc_events(struct mem_cgroup *memcg) { return true;
 static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
 
 static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
-static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bfd0a74fac92..29def0376819 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4429,7 +4429,6 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 
 	vmpressure_cleanup(&memcg->vmpressure);
 	cancel_work_sync(&memcg->high_work);
-	memcg1_remove_from_trees(memcg);
 	free_shrinker_info(memcg);
 	mem_cgroup_free(memcg);
 }
-- 
2.53.0-Meta


