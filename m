Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4F10C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F116B0095; Thu, 10 Sep 2026 04:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717216B0096; Thu, 10 Sep 2026 04:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDA56B0098; Thu, 10 Sep 2026 04:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE056B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:07:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CB9FC0456
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:07:34 +0000 (UTC)
X-FDA: 85197123228.21.7E963EE
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf02.hostedemail.com (Postfix) with ESMTP id 964FF80003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:07:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jfG1CgoB;
	spf=pass (imf02.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789027652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rY9Nu+B7kXe9cwRRfpxa5psElHxdo5w7y5Ja92igZVY=;
	b=CiFJIkYZuvxokaSiYsOPTDikTyqJ3xB4EKLzR054mFVgxwuwqYkvEA952An/3BQafGFoE4
	E8fi0sBvjCDDF1n78jJcKsqoyHm0BMEc9msnDrN0/aERGy7pUA4zMNcKiPoG+MqHm9HFN2
	81M4uCgyNxI4HI1NHn2oovYaPSIp+uk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jfG1CgoB;
	spf=pass (imf02.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789027652;
	b=G9qO1jA9Vehsi6WDsg7nugXuf181UgYJ/3eVIEQYLjkNAhXGvZKg4upfXDniQFvC5AXBN4
	3NoJqm2k4ScrPFj8G1bWPg7Plb6RDdjeC+FhmALXM0UmJNHK7Om3j3c16I2VMthZWWacZb
	Y7f3zDeZuF6iegXSZWkRAA0em/PEmkI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789027648; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=rY9Nu+B7kXe9cwRRfpxa5psElHxdo5w7y5Ja92igZVY=;
	b=jfG1CgoBb/y375o+WGQZDtpD+6KrBJZ4212FZpYCj2FRZyjs/XKQIOtOTM7BH9TbUE8lMK9dSiwq0z2FnpiKXadNdXl/EeO8sVi66Jn9G9BT+/dYgSao9iXFEzxYLVgqrJN61u2CNLTihwk1R2W+y/guy+BKxZHHsMDYXjGJ4Bc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XAh0I.A_1789027646;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAh0I.A_1789027646 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 16:07:27 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v3 1/4] mm: memcontrol: drop kmemcg_id and use mem_cgroup_id() for list_lru indexing
Date: Thu, 10 Sep 2026 16:07:19 +0800
Message-ID: <20260910080722.3961351-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7b93mcqqg9depp169dakfd9hrt3hs5oc
X-Rspamd-Queue-Id: 964FF80003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789027651-781796
X-HE-Meta: U2FsdGVkX1/3jSkE5iC+OaPvTgl5Xk2+2CP4uLSJplDwX5Zosx1Q9eznZI+fJlwoqRAtlGLnBlvBb78j8bwOA3UJUifB0pLYDDJpX7F16Ct2uIBAg0ZIulgoT4QVygtkN1/9MU+9B7DFXYRpW8u8e2Xdmz6BbB3j+eDEJsEmX6Vem3wILxm9XNmYURbbDrNehkdQhONOw5xdBUOH9X50CUAmLakxau4vTRil6HYd9CKNGYDAM9hWM+3Yszhwkbq9Yfx+Nlj80JrPcaA4oyGAGLPtemQdvvllIbqLekwzyhGeys8xhpbPY7n4+aUTFDCjdzvxvoZpTdemtRdInJcykgWZqkjCHbhA5VsNnBrxM73QEg95ssEUFo+bcGirJygBa5zk1yHqWk5ia1vXERYJGuJ1WVu9sANFyPSPAKbvCG8N+V2Lkye4nQRFPWUnDAiRLi4yxLTMFs5wwIuIuqJ8eEneyHXmh3QcpSJRrz96SlTLaat7oSDg4UpeYAGOTtjEN9khJibVTktlpBhvqnkcY6g0cZCqwczMuT6QJG7ctpR7kaih+2Swvokg3G7e3KhaccnvczDexgqtSbH2KzzFEHLwwa/sbQ7wZx++mIjjwn2OXNhTUOcw6rF85rz8PdbNrVAmOHvr17LSvP5+XHmzBAZZnFe+/+Nbs78ODMIJmfdAMfxvmpM0zZK4vyshPh0IELZUtsG0kgYs8FG1Ltajq+NJ8zfkb3Gj9KnfNguVeZZpVEL7wZc57VPHDtRPvBmTjm8J+8gjLcbeovWvVVYUzwclulHDC8PyVmrb+X5d/+0oMbgsQ1BDdJ0oOdpboTs26xFrX1BeWnY8pOUYt0BN3SiDZKyunO5ZDRuKvT8RtlwEQjUB1wTdftY8uK/sZpCH4BsWD80qIsNBOFfq2sV2Nbc8Eeb308hc3fWouyxr2v5fHzVqMGbudS8fcLfmMeYkD9r4kvc5idoo+Rd+23Q
 8oRL6fop
 My2K1OACaetEWBbXP1fhHGlgIXMUTX41xsHxqOn0ysl/u5yQNid4tWhaE3IbCzqrvtxLHXwfD/39/hfIkCIps9GtmLirY7bNKlt/f8y2mmD4y2FdPjkwrCywO1gmBGQ0rWUQHae4zfQHZmNAMymAhLnfEdVM7BKIFgrZ5rXKaKBYYJOIMogAfbSQqhIvgfE05Jyyeknv02UV1IzKmg71mzfzXfUO0lrDJJd/VATJYGXYsjyD9I98sHn/Cho0hWvYmYOSxnCeCDRk9B8+wLljNv+Rh+XY3k/LU6cV/RDGrbe8jS1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmemcg_id is a copy of the private memcg ID and serves no purpose
other than indexing the per-memcg list_lru xarray.  It is assigned
when kmem accounting goes online, which never happens with
cgroup.memory=nokmem, and the memcgs then all resolve to the
per-node lists.  The next patch needs the index to work under nokmem
as well.

Index the lists with mem_cgroup_id().  The cgroup ID is unique per
memcg and is only recycled once the cgroup is destroyed, long after
offlining has erased the xarray entries, so a recycled ID cannot
resurrect a stale entry.  The lookup now takes memcg pointers and
routes root and NULL to the per-node lists itself.

Also drop the nokmem early return from the offline path, so that the
reparenting covers lrus that stay memcg aware without kmem
accounting.  memcg_online_kmem() and memcg_offline_kmem() are each
down to a single statement now; inline them into the css online and
offline hooks, dropping the root check, as css_offline() is never
called for the root and a memcg that failed css_online() cannot have
list_lru entries.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
 include/linux/memcontrol.h | 15 -------------
 mm/list_lru.c              | 27 ++++++++++++------------
 mm/memcontrol.c            | 43 +++++++-------------------------------
 3 files changed, 22 insertions(+), 63 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fdf4812e1d818..821dc0e32603a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -254,7 +254,6 @@ struct mem_cgroup {
 #if BITS_PER_LONG < 64
 	seqlock_t		socket_pressure_seqlock;
 #endif
-	int kmemcg_id;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
@@ -1774,15 +1773,6 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
 		__memcg_kmem_uncharge_page(page, order);
 }
 
-/*
- * A helper for accessing memcg's kmem_id, used for getting
- * corresponding LRU lists.
- */
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
-{
-	return memcg ? memcg->kmemcg_id : -1;
-}
-
 struct mem_cgroup *mem_cgroup_from_virt(void *p);
 
 static inline void count_objcg_events(struct obj_cgroup *objcg,
@@ -1850,11 +1840,6 @@ static inline bool memcg_kmem_online(void)
 	return false;
 }
 
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
-{
-	return -1;
-}
-
 static inline struct mem_cgroup *mem_cgroup_from_virt(void *p)
 {
 	return NULL;
diff --git a/mm/list_lru.c b/mm/list_lru.c
index a4522ca93ebcb..9241d17de4388 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -72,10 +72,11 @@ static int lru_shrinker_id(struct list_lru *lru)
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
 {
-	if (list_lru_memcg_aware(lru) && idx >= 0) {
-		struct list_lru_memcg *mlru = xa_load(&lru->xa, idx);
+	if (list_lru_memcg_aware(lru) && memcg && !mem_cgroup_is_root(memcg)) {
+		struct list_lru_memcg *mlru =
+			xa_load(&lru->xa, mem_cgroup_id(memcg));
 
 		return mlru ? &mlru->node[nid] : NULL;
 	}
@@ -91,7 +92,7 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 
 	rcu_read_lock();
 again:
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
+	l = list_lru_from_memcg(lru, nid, *memcg);
 	if (likely(l)) {
 		lock_list_lru(l, irq, irq_flags);
 		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
@@ -132,7 +133,7 @@ static inline bool list_lru_memcg_aware(struct list_lru *lru)
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
 {
 	return &lru->node[nid].lru;
 }
@@ -313,7 +314,7 @@ unsigned long list_lru_count_one(struct list_lru *lru,
 	long count;
 
 	rcu_read_lock();
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
+	l = list_lru_from_memcg(lru, nid, memcg);
 	count = l ? READ_ONCE(l->nr_items) : 0;
 	rcu_read_unlock();
 
@@ -502,11 +503,10 @@ static void memcg_reparent_list_lru_one(struct list_lru *lru, int nid,
 					struct list_lru_one *src,
 					struct mem_cgroup *dst_memcg)
 {
-	int dst_idx = dst_memcg->kmemcg_id;
 	struct list_lru_one *dst;
 
 	spin_lock_irq(&src->lock);
-	dst = list_lru_from_memcg_idx(lru, nid, dst_idx);
+	dst = list_lru_from_memcg(lru, nid, dst_memcg);
 	spin_lock_nested(&dst->lock, SINGLE_DEPTH_NESTING);
 
 	list_splice_init(&src->list, &dst->list);
@@ -536,7 +536,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		 * allocating a new mlru since CSS_DYING is already set for this
 		 * memcg a rcu grace period ago.
 		 */
-		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
+		mlru = xa_load(&lru->xa, mem_cgroup_id(memcg));
 		if (!mlru)
 			continue;
 
@@ -551,7 +551,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		for_each_node(i)
 			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
 
-		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
+		xa_erase_irq(&lru->xa, mem_cgroup_id(memcg));
 
 		/*
 		 * Here all list_lrus corresponding to the cgroup are guaranteed
@@ -566,9 +566,10 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 					    struct list_lru *lru)
 {
-	int idx = memcg->kmemcg_id;
+	if (!memcg || mem_cgroup_is_root(memcg))
+		return true;
 
-	return idx < 0 || xa_load(&lru->xa, idx);
+	return xa_load(&lru->xa, mem_cgroup_id(memcg));
 }
 
 static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
@@ -602,7 +603,7 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
 			if (!mlru)
 				return -ENOMEM;
 		}
-		xas_set(&xas, pos->kmemcg_id);
+		xas_set(&xas, mem_cgroup_id(pos));
 		do {
 			xas_lock_irqsave(&xas, flags);
 			if (!xas_load(&xas) && !css_is_dying(&pos->css)) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7ce50bccf1264..aa010608fbff8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3771,33 +3771,6 @@ void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
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
-	memcg->kmemcg_id = memcg->id.id;
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
@@ -4225,7 +4198,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	seqlock_init(&memcg->socket_pressure_seqlock);
 #endif
 	memcg1_memcg_init(memcg);
-	memcg->kmemcg_id = -1;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
@@ -4299,7 +4271,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	struct obj_cgroup *objcg;
 	int nid;
 
-	memcg_online_kmem(memcg);
+	if (!mem_cgroup_kmem_disabled() && likely(!mem_cgroup_is_root(memcg)))
+		static_branch_enable(&memcg_kmem_online_key);
 
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
@@ -4307,7 +4280,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 * here, when mem_cgroup_iter() can't skip it.
 	 */
 	if (alloc_shrinker_info(memcg))
-		goto offline_kmem;
+		goto reparent_lrus;
 
 	for_each_node(nid) {
 		objcg = obj_cgroup_alloc();
@@ -4364,8 +4337,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
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
@@ -4381,11 +4354,11 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
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
-- 
2.43.7


