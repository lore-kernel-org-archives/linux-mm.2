Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1659FEFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793026B00CE; Wed, 25 Feb 2026 02:56:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753DB6B00D0; Wed, 25 Feb 2026 02:56:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7BB6B00D1; Wed, 25 Feb 2026 02:56:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 518C86B00CE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:56:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CF4D52538
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:37 +0000 (UTC)
X-FDA: 84482222034.09.85BB7CF
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 80E7D1C0008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=drHrPibu;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jixWNQGM0475MRwNOzwoWJgX/kZHqboFRlWfpwSh0g8=;
	b=eP4WSOaiylj7aVoCL8d5c3WAQHcn9hTa3kjN4Uv2Iz/XaoliPV3VS+ELn6XYhtFDuB/WT+
	urIZiF+x/8xUlJuznEx+wpRP1TXN3ujgE0A72OZURwZRFjc/kEru06r7H8y9VjPvXjvhVB
	Av8NUqvicv7wGaZXTHq2zlIHWQMpP2o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006195; a=rsa-sha256;
	cv=none;
	b=M6xgrp+wPZVtZ5IbUSk69h0pD4soZEc3pGAw5IOvhzg6LIBG5BDoZHkHTulqR7kLcL+a4o
	Ixts4D1pQo452siku4BnIocKSRFJjYOHAFEvJTc2U7Ea5tq104X+sJvdAVmGzTd0xaccxu
	jmzoIywY/kE0X2vxVjN1zwrPUuuSDDg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=drHrPibu;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jixWNQGM0475MRwNOzwoWJgX/kZHqboFRlWfpwSh0g8=;
	b=drHrPibumDAUFllxLTV3P9E60OHJY+2qzmgBzAFsPgMFSIPncuia2a8HZ37i+AxqHd/1xs
	bD5e9Lm9mbDTmIhttB+zsJwRC58WA9sFg/CzEKt35fD1Ckq16XCTgeFL0qwOPWrlgvjvEE
	h61Mi05AsoeXIJnuNXkIXIkfYYs8asA=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 30/32] mm: memcontrol: convert objcg to be per-memcg per-node type
Date: Wed, 25 Feb 2026 15:53:13 +0800
Message-ID: <0f915487ffc653cf6ea19335c21c01aa06004641.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: es96bjwprchwzysihhtg3t6q37tfqkj4
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 80E7D1C0008
X-HE-Tag: 1772006195-229069
X-HE-Meta: U2FsdGVkX1/wbOJgUs6JvimCNhkHkDlllTT+5qYKGy3S24hzsRTeTwoBfiwzo3iwNrm+8g7Tpw2MegXKgvkjjJjFaa5DLAa4qi1UjJsmUuE/V/OgXQVHqzY1pQCz2sUjxt+y8JmHmQMrTeQFJA62rOaakEAOQp6QZimVDPOm42ne4IkBDCjpLpPKumzYSI9Ntiw9n3RwkFEDo6dyI7knEni9Wt8qs17cfyCHPKgAb51iPHvJYFHcDnuGCpgL94PmhqGGWVbVBXA0Qxiq4Q7oVviVRLfFNi59XSEx3DE5oJAk+iVV+5+SVxyUEg6SU35qmlM2qzRd4GB0UpJl2aXC9iZkfEv9QaKhHZt4hM03QKdBghP1+NXKcD7oS/q7YJaEVu8rRqAY0lD+NvxSOkhjZ4BCasx3Q6qNz5K9CaNY7kDQibMQDapTZfV0C/A2UNmmGPdAMfhnk9AlqJvVUHZ3FK/rrcq2drjG2/wcXJlzwhgQR97EjUsAmUlumGI08wtvbdhVpVQBPWQ5/1AxlwoDa5g5TNxWx9N6Fz7efJPJDRHrTDyUG9lwb6PjezWqvdvAHkpkaIHbftKt9y473L2osPwil1LlK0x7CDWULDvlW+mEPXnozTMAWoImnQQK8uj06qlg/VQAHp38YXqPro1zlZdUsXM5TTwJuEsEC+XDp81ucaCehnAXQBhG6mHbn8+DBGMoVRzfJNJpxQc9BPNmcH4SFM5ujeENHbWu0gA1q+V27Yd77zTrtt7qcRu89ruwvAzNaTHPkKJQbcPPVaF0eR77qrXn6OtmY/0DNaSop4x5NoJqJD6kOtKRFlO5lcD1/p4SvsRG5kLgLsuJ2T8gUBFuI+vlYr3HQbIUxBKiF7uFUl3CH/X42lq3DZYDt+aezQkqwU4vtlz0wzUwIhJxiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Convert objcg to be per-memcg per-node type, so that when reparent LRU
folios later, we can hold the lru lock at the node level, thus avoiding
holding too many lru locks at once.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h | 22 ++++++-----
 include/linux/sched.h      |  2 +-
 mm/memcontrol.c            | 75 ++++++++++++++++++++++++--------------
 3 files changed, 61 insertions(+), 38 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 45d911dd903e7..487c66d9e5304 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -116,6 +116,16 @@ struct mem_cgroup_per_node {
 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
+	/*
+	 * objcg is wiped out as a part of the objcg repaprenting process.
+	 * orig_objcg preserves a pointer (and a reference) to the original
+	 * objcg until the end of live of memcg.
+	 */
+	struct obj_cgroup __rcu	*objcg;
+	struct obj_cgroup	*orig_objcg;
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
+
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 	/* slab stats for nmi context */
 	atomic_t		slab_reclaimable;
@@ -180,6 +190,7 @@ struct obj_cgroup {
 		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
 	};
+	bool is_root;
 };
 
 /*
@@ -258,15 +269,6 @@ struct mem_cgroup {
 	seqlock_t		socket_pressure_seqlock;
 #endif
 	int kmemcg_id;
-	/*
-	 * memcg->objcg is wiped out as a part of the objcg repaprenting
-	 * process. memcg->orig_objcg preserves a pointer (and a reference)
-	 * to the original objcg until the end of live of memcg.
-	 */
-	struct obj_cgroup __rcu	*objcg;
-	struct obj_cgroup	*orig_objcg;
-	/* list of inherited objcgs, protected by objcg_lock */
-	struct list_head objcg_list;
 
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
 
@@ -552,7 +554,7 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 
 static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
 {
-	return objcg == root_obj_cgroup;
+	return objcg->is_root;
 }
 
 static inline bool mem_cgroup_disabled(void)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a7b4a980eb2f0..7b63b7b74f414 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1533,7 +1533,7 @@ struct task_struct {
 	/* Used by memcontrol for targeted memcg charge: */
 	struct mem_cgroup		*active_memcg;
 
-	/* Cache for current->cgroups->memcg->objcg lookups: */
+	/* Cache for current->cgroups->memcg->nodeinfo[nid]->objcg lookups: */
 	struct obj_cgroup		*objcg;
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 63210b2222243..edc785438a65b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -210,18 +210,21 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
 }
 
 static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memcg,
-							 struct mem_cgroup *parent)
+							 struct mem_cgroup *parent,
+							 int nid)
 {
 	struct obj_cgroup *objcg, *iter;
+	struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
+	struct mem_cgroup_per_node *parent_pn = parent->nodeinfo[nid];
 
-	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
+	objcg = rcu_replace_pointer(pn->objcg, NULL, true);
 	/* 1) Ready to reparent active objcg. */
-	list_add(&objcg->list, &memcg->objcg_list);
+	list_add(&objcg->list, &pn->objcg_list);
 	/* 2) Reparent active objcg and already reparented objcgs to parent. */
-	list_for_each_entry(iter, &memcg->objcg_list, list)
+	list_for_each_entry(iter, &pn->objcg_list, list)
 		WRITE_ONCE(iter->memcg, parent);
 	/* 3) Move already reparented objcgs to the parent's list */
-	list_splice(&memcg->objcg_list, &parent->objcg_list);
+	list_splice(&pn->objcg_list, &parent_pn->objcg_list);
 
 	return objcg;
 }
@@ -260,14 +263,17 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg;
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+	int nid;
 
-	reparent_locks(memcg, parent);
+	for_each_node(nid) {
+		reparent_locks(memcg, parent);
 
-	objcg = __memcg_reparent_objcgs(memcg, parent);
+		objcg = __memcg_reparent_objcgs(memcg, parent, nid);
 
-	reparent_unlocks(memcg, parent);
+		reparent_unlocks(memcg, parent);
 
-	percpu_ref_kill(&objcg->refcnt);
+		percpu_ref_kill(&objcg->refcnt);
+	}
 }
 
 /*
@@ -2859,8 +2865,10 @@ struct mem_cgroup *mem_cgroup_from_virt(void *p)
 
 static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 {
+	int nid = numa_node_id();
+
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		struct obj_cgroup *objcg = rcu_dereference(memcg->objcg);
+		struct obj_cgroup *objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
 
 		if (likely(objcg && obj_cgroup_tryget(objcg)))
 			return objcg;
@@ -2924,6 +2932,7 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
 {
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	int nid = numa_node_id();
 
 	if (IS_ENABLED(CONFIG_MEMCG_NMI_UNSAFE) && in_nmi())
 		return NULL;
@@ -2940,7 +2949,7 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
 		 * Objcg reference is kept by the task, so it's safe
 		 * to use the objcg by the current task.
 		 */
-		return objcg ? : root_obj_cgroup;
+		return objcg ? : rcu_dereference_check(root_mem_cgroup->nodeinfo[nid]->objcg, 1);
 	}
 
 	memcg = this_cpu_read(int_active_memcg);
@@ -2957,12 +2966,12 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
 		 * away and can be used within the scope without any additional
 		 * protection.
 		 */
-		objcg = rcu_dereference_check(memcg->objcg, 1);
+		objcg = rcu_dereference_check(memcg->nodeinfo[nid]->objcg, 1);
 		if (likely(objcg))
 			return objcg;
 	}
 
-	return root_obj_cgroup;
+	return rcu_dereference_check(root_mem_cgroup->nodeinfo[nid]->objcg, 1);
 }
 
 struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
@@ -3859,6 +3868,8 @@ static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	if (!pn->lruvec_stats_percpu)
 		goto fail;
 
+	INIT_LIST_HEAD(&pn->objcg_list);
+
 	lruvec_init(&pn->lruvec);
 	pn->memcg = memcg;
 
@@ -3873,10 +3884,12 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	int node;
 
-	obj_cgroup_put(memcg->orig_objcg);
+	for_each_node(node) {
+		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
 
-	for_each_node(node)
-		free_mem_cgroup_per_node_info(memcg->nodeinfo[node]);
+		obj_cgroup_put(pn->orig_objcg);
+		free_mem_cgroup_per_node_info(pn);
+	}
 	memcg1_free_events(memcg);
 	kfree(memcg->vmstats);
 	free_percpu(memcg->vmstats_percpu);
@@ -3947,7 +3960,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 #endif
 	memcg1_memcg_init(memcg);
 	memcg->kmemcg_id = -1;
-	INIT_LIST_HEAD(&memcg->objcg_list);
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
@@ -4024,6 +4036,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct obj_cgroup *objcg;
+	int nid;
 
 	memcg_online_kmem(memcg);
 
@@ -4035,17 +4048,19 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
 
-	objcg = obj_cgroup_alloc();
-	if (!objcg)
-		goto free_shrinker;
+	for_each_node(nid) {
+		objcg = obj_cgroup_alloc();
+		if (!objcg)
+			goto free_objcg;
 
-	if (unlikely(mem_cgroup_is_root(memcg)))
-		root_obj_cgroup = objcg;
+		if (unlikely(mem_cgroup_is_root(memcg)))
+			objcg->is_root = true;
 
-	objcg->memcg = memcg;
-	rcu_assign_pointer(memcg->objcg, objcg);
-	obj_cgroup_get(objcg);
-	memcg->orig_objcg = objcg;
+		objcg->memcg = memcg;
+		rcu_assign_pointer(memcg->nodeinfo[nid]->objcg, objcg);
+		obj_cgroup_get(objcg);
+		memcg->nodeinfo[nid]->orig_objcg = objcg;
+	}
 
 	if (unlikely(mem_cgroup_is_root(memcg)) && !mem_cgroup_disabled())
 		queue_delayed_work(system_dfl_wq, &stats_flush_dwork,
@@ -4069,7 +4084,13 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
 
 	return 0;
-free_shrinker:
+free_objcg:
+	for_each_node(nid) {
+		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
+
+		if (pn && pn->orig_objcg)
+			obj_cgroup_put(pn->orig_objcg);
+	}
 	free_shrinker_info(memcg);
 offline_kmem:
 	memcg_offline_kmem(memcg);
-- 
2.20.1


