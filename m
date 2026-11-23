Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D960606A334
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=v6NoB6GU
Received: by kanga.kvack.org (Postfix)
	id 9C0C56B05B7; Mon, 23 Nov 2026 05:53:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949A96B05B9; Mon, 23 Nov 2026 05:53:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A7B6B05B8; Mon, 23 Nov 2026 05:53:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53B776B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:53:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D237E40876
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:53:47 +0000 (UTC)
X-FDA: 85466073294.13.D1F9331
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf14.hostedemail.com (Postfix) with ESMTP id 33A25100007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:53:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=v6NoB6GU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795431225;
	b=LkQQK6OyQP+AQSUj1sLbv//oW5w+WCp3oOExdKGkNHfaANf7GT3o6DAEHlQhlIcDTT8Sp1
	6APa47SFUu0I4I9sllBqwpOevj/vFcMetD0JtcZf4BMmKVdcbyPEdVeXyzs0F2ncyVncfU
	jP4PTxA7VvQInxzAU+TVUO35Pu0KtC4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795431225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3VJosOTv7rTl0MIXfVCQbhZsKJYv+HSjoRx7LySLiRY=;
	b=ISpmalqsOMgbT9fASYY6/+C74do+LIDVEGdWfN1kHhoRxtyqhvKHzE3AoMwANFnSQeDy3z
	FBUmcroq+qxODGfZpVgryjtz8REroTy6wy2RguF10JaFQoarBhNBcYUu0kPirG8o175dzv
	+zbxdXUoZHVJKLYjSllDjSuVuJnNQHM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=v6NoB6GU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795431219; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=3VJosOTv7rTl0MIXfVCQbhZsKJYv+HSjoRx7LySLiRY=;
	b=v6NoB6GUFuJhuwky0H/JJPit4YvFHuGdaI5Qek18hMDZtamX63Sc1ypdBU2wlDcODPbRBRxmeYAyCC1e7XWA1jFfaky2sIBii9UfGKn54xjIRYh4pPDrZ80rCwQfXqj6GaNso5O7U1v9C6LwRUjtvBH1IUr8Oj04pHuRc9CKtKM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XFHJh-7_1795431217;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XFHJh-7_1795431217 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 18:53:38 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v5 1/4] mm: list_lru: index per-memcg lists by memory CSS ID
Date: Mon, 23 Nov 2026 18:53:31 +0800
Message-ID: <20261123105334.2524066-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rbyrfa3rhcaxdygmms6ob5kqpmyk6dm1
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 33A25100007
X-HE-Tag: 1795431222-622398
X-HE-Meta: U2FsdGVkX184bnpNxz46835IScwEXCFKlluo/o8m2PuN9gwE8w3hvdD9R0GWr2Zc4aY2HX3/tT+wFEbhbDmqHfhR4YNydELB1bco3IezPl8AWuLJxkkA7t0e/TAk6XqskjajV5S3o3xSkjLPy4kGB7FPSM8+fnuLPcS5FAudNzxCXkfLwyRUS2rr8wyJtO4VTom1yI0x89hG//x5MD20cGZ6OhP6q0dvhegirucaUGjQ/lkGzOmoBlhcH5f2cS1vPlYd6LecOafn94CgWBtlBo2PoY2LVNxy1UhLfSSas2YgiucXuekFRnxisioXvz3okj85Hk1fcBCg3HLr6Vst+EN6rnISsk98dLPNigbbOZ2H9hMrFOGOpynxEDbLK1ffmJW1gEdFfdNlXFxxjBahhjQqoqxhDuY7xAsVt7YXBdwKR9LCig9fRmnPIlgpUTnrG3KzFLu/DbxULNTxTcmfVEUIBfh97CZI0yqj35xpSem3j9Sl8koWSQK1sX17kOH+x+oDrt388PPNO9oJvSpFiiKi3hg9dzslfyDndBNFDjUxxxiicemgEmIzMiaBJNFF/A7rnuLt0NIUZ+hwGjucMALJJ7ISxgbIcJ0N3+r3bOdKa8af4z3+AKAZiL90fCoDLd2xzQ/L22ATCVx18URhtVcxuffdCAGP/AbECdxAVslLho+GQuSdkx0PAOERai7zeQ89erNAPg7DpltdqY4JRQjGCha6ynIDTohBUeImJOFxrabmXk110lg4+GUjHtKyG0mYBP3dMnrDoeLokw3rAYCfhtG3W6LvVB3h6dXezIIeq4S/o1+1Mpvpv6DjpoTGRs5NI7b9Ml1P3FVzmkBzwPLJDIkoRef7WW4maJ5nFP790JOZtp3zy8LBfmI7cpdIeHI7g62YpBmt3hA+VG/PPmq3IqNu8UH8vAzaNcduCfpPOzDakm7DufSwuf1B5XmMrxeQ7zN5DDQR/u6OfXY
 jk0R/xxH
 J+WFJ4AOWNnZNafzyrh72KBvCH8801PheXtqACM2eIRHtLtQPqkSFBbM5/JIcbkJ01OBI1cPNw2oCsWACCh0xaFc1m47wz2gzvPDxhcSDOxFbhDcY3rdb+4BwzoDeQSTeFwKypI1H3h57qeI9sPDMwLtF0Bx5/GiJ4oZCckBbwszvG04vCHUiT661ySekv0Mb/FJLYDHVffOVn+9ydJ1m8DdfiLTv/dDFMKWJk/wQES85yXRuakQzDCSOnsCEMgO/jeDpBQ2UKOnxyNLpDcEi4IIKwqoEcTAUJDQE1A+C6aIuthKgTt/JA+LGO4SEFUGCP2Q0PYrO9g7Nc6wswEk7ugX6JlM7XDWdARN+NML7c4cGbQNiWO9tQeLeQ6quScaAdpn1ImsuQk427QTkCKQC2lViSm1ipk3FrOBYCjMhuf+N+67xZUytQ4yxE+S365i3tgiF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

list_lru uses kmemcg_id, a copy of the private memcg ID, to index its
per-memcg lists. kmemcg_id is only set when kmem accounting is enabled.
Non-slab shrinkers need an index that also works with cgroup.memory=nokmem.

Use memcg->css.id for non-root lists. The ID stays allocated until the
CSS is freed, so disabling and re-enabling the memory controller on the
same cgroup gives the new CSS a distinct index while the old CSS is
still referenced. Reserve index zero for the root, which uses the
per-node list directly.

In list_lru_walk_node(), hold the RCU read lock across both lookups so
the CSS ID cannot be reused between them. css_from_id() can see a CSS
before its online callback succeeds, so check that the CSS is online
before taking a reference. Drop the RCU read lock for the walk and
keep the reference across restarts to recheck the same owner.

Remove kmemcg_id and reparent the lists before the objcgs on memcg
offline, including when kmem accounting is disabled.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
 include/linux/memcontrol.h | 16 --------------
 mm/list_lru.c              | 45 +++++++++++++++++++++++++-------------
 mm/memcontrol.c            | 45 +++++++-------------------------------
 3 files changed, 38 insertions(+), 68 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 980358bc6f49..f0001174180c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -335,8 +335,6 @@ struct mem_cgroup {
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
 	int private_id;
 
-	int kmemcg_id;
-
 	/*
 	 * Should the OOM killer kill all belonging tasks, had it kill one?
 	 */
@@ -1796,15 +1794,6 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
 		__memcg_kmem_uncharge_page(page, order);
 }
 
-/*
- * A helper for accessing memcg's kmem_id, used for getting
- * corresponding LRU lists.
- */
-static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
-{
-	return memcg ? memcg->kmemcg_id : -1;
-}
-
 struct mem_cgroup *mem_cgroup_from_virt(void *p);
 
 static inline void count_objcg_events(struct obj_cgroup *objcg,
@@ -1872,11 +1861,6 @@ static inline bool memcg_kmem_online(void)
 	return false;
 }
 
-static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
-{
-	return -1;
-}
-
 static inline struct mem_cgroup *mem_cgroup_from_virt(void *p)
 {
 	return NULL;
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 651983d0bf8b..b4c879d7ba01 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -41,6 +41,15 @@ static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off,
 static LIST_HEAD(memcg_list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
 
+static inline unsigned long list_lru_memcg_idx(const struct mem_cgroup *memcg)
+{
+	/* Index 0 selects the per-node root list. */
+	if (!memcg || mem_cgroup_is_root(memcg))
+		return 0;
+
+	return memcg->css.id;
+}
+
 static inline bool list_lru_memcg_aware(struct list_lru *lru)
 {
 	return lru->memcg_aware;
@@ -74,9 +83,9 @@ static int lru_shrinker_id(struct list_lru *lru)
 static inline struct list_lru_one *
 list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
 {
-	int idx = memcg_kmem_id(memcg);
+	unsigned long idx = list_lru_memcg_idx(memcg);
 
-	if (list_lru_memcg_aware(lru) && idx >= 0) {
+	if (list_lru_memcg_aware(lru) && idx) {
 		struct list_lru_memcg *mlru = xa_load(&lru->xa, idx);
 
 		/* Lists at a reused index belong to another memcg. */
@@ -425,25 +434,30 @@ unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
 #ifdef CONFIG_MEMCG
 	if (*nr_to_walk > 0 && list_lru_memcg_aware(lru)) {
 		struct list_lru_memcg *mlru;
-		struct mem_cgroup *memcg;
+		struct cgroup_subsys_state *css;
 		unsigned long index;
 
+		/*
+		 * Keep the ID from being reused between the two lookups.
+		 * css_from_id() can see a CSS before ->css_online() succeeds.
+		 */
+		rcu_read_lock();
 		xa_for_each(&lru->xa, index, mlru) {
-			rcu_read_lock();
-			memcg = mem_cgroup_from_private_id(index);
-			if (!memcg || !mem_cgroup_tryget(memcg)) {
-				rcu_read_unlock();
+			css = css_from_id(index, &memory_cgrp_subsys);
+			if (!css || !css_is_online(css) || !css_tryget(css))
 				continue;
-			}
 			rcu_read_unlock();
-			isolated += __list_lru_walk_one(lru, nid, memcg,
+			isolated += __list_lru_walk_one(lru, nid,
+							mem_cgroup_from_css(css),
 							isolate, cb_arg,
 							nr_to_walk, false);
-			mem_cgroup_put(memcg);
+			css_put(css);
 
+			rcu_read_lock();
 			if (*nr_to_walk <= 0)
 				break;
 		}
+		rcu_read_unlock();
 	}
 #endif
 
@@ -526,6 +540,7 @@ static void memcg_reparent_list_lru_one(struct list_lru *lru, int nid,
 
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
+	unsigned long idx = list_lru_memcg_idx(memcg);
 	struct list_lru *lru;
 	int i;
 
@@ -538,7 +553,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		 * allocating a new mlru since CSS_DYING is already set for this
 		 * memcg a rcu grace period ago.
 		 */
-		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
+		mlru = xa_load(&lru->xa, idx);
 		if (!mlru)
 			continue;
 
@@ -553,7 +568,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		for_each_node(i)
 			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
 
-		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
+		xa_erase_irq(&lru->xa, idx);
 
 		/*
 		 * Here all list_lrus corresponding to the cgroup are guaranteed
@@ -568,11 +583,11 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 					    struct list_lru *lru)
 {
+	unsigned long idx = list_lru_memcg_idx(memcg);
 	struct list_lru_memcg *mlru;
 	bool allocated;
-	int idx = memcg->kmemcg_id;
 
-	if (idx < 0)
+	if (!idx)
 		return true;
 
 	rcu_read_lock();
@@ -616,7 +631,7 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
 		}
 		/* Set before the lists are published, and never changed after. */
 		mlru->memcg = pos;
-		xas_set(&xas, pos->kmemcg_id);
+		xas_set(&xas, list_lru_memcg_idx(pos));
 		do {
 			xas_lock_irqsave(&xas, flags);
 			if (!xas_load(&xas) && !css_is_dying(&pos->css)) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..f6c8ee7f6fed 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3839,33 +3839,6 @@ void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
 	obj_cgroup_get_many(folio_objcg(folio), new_refs);
 }
 
-static void memcg_online_kmem(struct mem_cgroup *memcg)
-{
-	if (mem_cgroup_kmem_disabled())
-		return;
-
-	if (unlikely(mem_cgroup_is_root(memcg)))
-		return;
-
-	static_branch_enable(&memcg_kmem_online_key);
-
-	memcg->kmemcg_id = memcg->private_id;
-}
-
-static void memcg_offline_kmem(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup *parent;
-
-	if (mem_cgroup_kmem_disabled())
-		return;
-
-	if (unlikely(mem_cgroup_is_root(memcg)))
-		return;
-
-	parent = parent_mem_cgroup(memcg);
-	memcg_reparent_list_lrus(memcg, parent);
-}
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 #include <trace/events/writeback.h>
@@ -4341,7 +4314,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	seqlock_init(&memcg->socket_pressure_seqlock);
 #endif
 	memcg1_memcg_init(memcg);
-	memcg->kmemcg_id = -1;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
@@ -4415,7 +4387,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	struct obj_cgroup *objcg;
 	int nid;
 
-	memcg_online_kmem(memcg);
+	if (!mem_cgroup_kmem_disabled() && likely(!mem_cgroup_is_root(memcg)))
+		static_branch_enable(&memcg_kmem_online_key);
 
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
@@ -4423,7 +4396,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 * here, when mem_cgroup_iter() can't skip it.
 	 */
 	if (alloc_shrinker_info(memcg))
-		goto offline_kmem;
+		goto reparent_lrus;
 
 	for_each_node(nid) {
 		objcg = obj_cgroup_alloc();
@@ -4481,8 +4454,8 @@ free_objcg:
 		}
 	}
 	free_shrinker_info(memcg);
-offline_kmem:
-	memcg_offline_kmem(memcg);
+reparent_lrus:
+	memcg_reparent_list_lrus(memcg, parent_mem_cgroup(memcg));
 	mem_cgroup_private_id_remove(memcg);
 	return -ENOMEM;
 }
@@ -4500,11 +4473,11 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	zswap_memcg_offline_cleanup(memcg);
 
-	memcg_offline_kmem(memcg);
+	memcg_reparent_list_lrus(memcg, parent_mem_cgroup(memcg));
 	/*
 	 * The reparenting of objcg must be after the reparenting of
-	 * the list_lru in memcg_offline_kmem(), which ensures that
-	 * they will not mistakenly get the parent list_lru.
+	 * the list_lru above, which ensures that they will not
+	 * mistakenly get the parent list_lru.
 	 */
 	memcg_reparent_objcgs(memcg);
 	reparent_shrinker_deferred(memcg);
@@ -5942,8 +5915,6 @@ static void __init memcg_struct_check(void)
 				      private_id_objcg);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      private_id);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
-				      kmemcg_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      oom_group);
 
-- 
2.55.0


