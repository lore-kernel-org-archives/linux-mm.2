Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B4DC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8596B009F; Tue, 11 Aug 2026 16:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAFC76B00A0; Tue, 11 Aug 2026 16:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED5A6B00A1; Tue, 11 Aug 2026 16:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2A676B009F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:32:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36FE21401D0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:41 +0000 (UTC)
X-FDA: 85090136922.20.58A0F22
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf08.hostedemail.com (Postfix) with ESMTP id 976F6160004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uN9AUmp6;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480359;
	b=wo4w6XkDtjEr1UPM5PVB5nU8+GLV7oCsrDns5mQYgapRxwOCeEFPU1mI0wob0LEj2MYUMC
	epU3QXJtB3F8vucq9O9ACD9iNdXXWXhkQvuUL2tR1+cFLGXT+sl/lO9jEdGBQp4ZTtCOfH
	laElNnbipTEuKz5vFnXnAZF2j247xEg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uN9AUmp6;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfoSEEh1wmZsAndftJOLrD9wrMxUb9iE4ebdJd4337w=;
	b=Z/ut+UOytyKU5LbbmxH00EtHj3yalTUXyiJ1+ohLAtDxIs0nBzTa8USqnOqR6v5xe3aDst
	nDZWMOQrjytghEFE1RFtu4vwWanox302mKC3q8DzMN+J6UwBoV4RpUlOXU8HWcU+C5ynVz
	j6Ul6DMils3xBerqQgeiw9usKYa9WuY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfoSEEh1wmZsAndftJOLrD9wrMxUb9iE4ebdJd4337w=;
	b=uN9AUmp6oVwQ9Y1xltyPWBsey4c26TsO6lpQJe3mzugLda498cXA4sDAqL0xIPmFpYHhrF
	baUc0Yc7yojMKFA+kP4oF9WjOnBtnr74qoSCWjFglB9iVM+arTO+dlCqlzityWDxbV9BFX
	Hc+5lXXRt8MPFJZqpySkmpMUr20fD6U=
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
Subject: [PATCH 5/9] memcg: remove the soft limit rbtree
Date: Tue, 11 Aug 2026 13:31:59 -0700
Message-ID: <20260811203203.3456029-6-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 976F6160004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8mq69mkqsj3xm464r496cuejqpojd441
X-HE-Tag: 1786480359-537258
X-HE-Meta: U2FsdGVkX1/FbUAPKPr3xfFm7g/Z5ml40b7PiTL/KX7fPE0L7m/bMi6fTzHg4YuqfMjJh8itCLcGALRgwezLX70eKMuKI80SlBIrdqeythNrjEtgRwQ8wPhz6gZehX4XgD2lGaVgNvYUX7gh1SNIZLbcDnb1zNfxtKHM6Ig9DpkzM9gL575l9GFMX3pfSW8+fqTVnqBojg6fQd0UhNw/zqZUfW8jfcNtHLhqs49c6aVbUpGKJoHDtqArDbwxHqdQ80HsihKzn1EQV8DX5hCtKw4/p8vFRXZjpyCYAvZMY0misUZdro2XHj+dyTLJwKCzqD9tKfe+MuX8CEQF0Zku3kg86Ii/w7pVYLAP+oUyXBOTK+KBezwoa2+ofLOUEMWnqUw4xeOBg8z6a7RblJntF6Zs3RSJxWJ6u0BPzWPaQ3S1pTuCxsd1GucbjpZHXvrHZ1eZCv9Fy4aD0LSUMy4OP89w2/+7gb4lbI4wmJxuY3oKf8jceJrBAnCRpDJzfg5xkqAnCem/UsVOhnrhPFF3qL9L0hBxDA8cj6oGwpplNYkmfMIZ7YA1lyUqmx3sRZ5Enw8fqS0G9vlY0Fo3noCWVh7BajSZViZu55UkcNHumITHeAOUSZRz3SSpxCDZQXw7pOjElYeUdkLwo2/ZkCO+5quXYsbrdhuH4y4okowlN13eIk0y9/QVgC/YitvAVE8iy8qfkGanxV4sQ4yt0etqM+2FQ1CO34f3biTGK9ae+i5AaFm0k6CUEtGN2A+wWTrH8lRs+Igttn3JBKvUu3rx1Fs9F82i2r9TrrSprFhCbE9CM7WH6+NzVsy3P4YiohKSmve+Ifh54MfVmS9SRXh+R+MVHudJBPNWrEC1NmhRlGT9mmrRwQUzu0UD7PyHxja88yPud8PfC71VTBIksN8ObvT5g4jk8DxOye6sM8kaBrJevd/F4GQ+ebefNylb5mtNwNAeINepnZsRvlt987d
 xQfraMbb
 PZAyaALxWYaHw+/0YdAEkhNgm2WssenXqYAts4Dcdggoc1EvJ4rUPqFo2wQma2z5BRk2lPHUvhj2TM0i5MFTOD+Thp6RTPYfSm+txZXtECy4+0CxFy0BATCBqIRgHdtKXxXTFRC/7+/iaN3TxaU21VkPrgIYwwdJcbwmttwyWN5/eMaEPM8kDDU3aoIGJZgz9zNlB2oUAG2monSA=
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
index 1d3339520809..b68f1f16ae54 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4394,7 +4394,6 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 
 	vmpressure_cleanup(&memcg->vmpressure);
 	cancel_work_sync(&memcg->high_work);
-	memcg1_remove_from_trees(memcg);
 	free_shrinker_info(memcg);
 	mem_cgroup_free(memcg);
 }
-- 
2.53.0-Meta


