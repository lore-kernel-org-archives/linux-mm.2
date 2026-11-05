Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD55B606D804
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OmXyoIit
Received: by kanga.kvack.org (Postfix)
	id 5B8EC6B05B3; Thu,  5 Nov 2026 04:22:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A9A6B05B4; Thu,  5 Nov 2026 04:22:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395DF6B05B5; Thu,  5 Nov 2026 04:22:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF9E6B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:22:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 199741C43BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:47 +0000 (UTC)
X-FDA: 85400525574.14.CC91BA4
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf30.hostedemail.com (Postfix) with ESMTP id EDBD780005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OmXyoIit;
	spf=pass (imf30.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793870565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vi8x8kQIttn/cG7icAjrqsgg9Nfk4NMWqLP7ng53iWA=;
	b=LwKIWp31Z9hsVVLPzzvdCRg9u1cvtZr2VbKOTx0JSTHWJA+XYpbjh/30xWeAPPwco2/CWJ
	kc/jukTsWHVQE7RC4o8Nu/IUgO+kcWBMD5a8nvgTedXRYUn2KXnP2qppaxfCOLSUnJexxO
	5P8oZ831jksR+nc7KW+XTNAx1cMX/PM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OmXyoIit;
	spf=pass (imf30.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793870565;
	b=eKGvV5V7H/L0ERq0GMKtagHgZWEaJxFj7bFU+l/tTTIvd2nkzR83ic1jCHbjTX+EtKse+O
	lI4HT5kuWCJc56GFC9rWLXdGTNT/HV6dtVGa+9Siv+sPzRNaQO3UXWFuiFb6zaLmaQZhm0
	TydP0pKSbhL3fwI/u5sf4Bk4UM26X2Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793870561; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Vi8x8kQIttn/cG7icAjrqsgg9Nfk4NMWqLP7ng53iWA=;
	b=OmXyoIit8wU9pUd/UCIWVtvpxtlqNSEuqUnigmurZcHedf38NxbT2FanuEfb+eZG8M9Awh2GGWJXSI0/9FC/QI6QGMiBwRTVCTWLuiSGpINASeoWBqpk9G/xaw3JPE7A5oKn0alOoUPYFht1LW2BPld0XStYUWTczHyq6RgLb5E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XE8K-0S_1793870558;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XE8K-0S_1793870558 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:22:38 +0800
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
Subject: [PATCH v4 RESEND 2/5] mm: memcontrol: drop kmemcg_id and use mem_cgroup_id() for list_lru indexing
Date: Thu,  5 Nov 2026 17:22:30 +0800
Message-ID: <20261105092233.3558950-3-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ci5gb51kfpjo1ch98pcqpm3edzo6rkup
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EDBD780005
X-HE-Tag: 1793870563-907489
X-HE-Meta: U2FsdGVkX1+hyTtNbALpukuS7nZIw1lWBe3o3z99hQcTFusrMd1J+EB/btLLKaooHbD0vGezBAFmqnLeowTzAUNtCtrOllrNs+wJGZJ0zKlUDpzGZA6RSzGU1x91RjnyaO2l8hr3W84N5y+KlJL2e3ZtJPotzUWRNiYBYkhqVEK9uK07pz2zj1RlLq6rTC9nrFgzgj7MKKKF56ZrFBEAXeHfYQMhnAhpNG60EXFOkxzpjl+xH5IHR9BWMruLJd/dtKJz7QJtdRqTkZH7qpREL1BanxdOxhb20TXe1KX1aSn1UXp77LPDMD2965qRUeZLt1uhFJNdppA2Bb1olKnf+Gk0Qh+uVwB1d3Vs0aL28d17PvgsJdXAofICsVsRcFsN7MTrPqXWXFekRrw7z+pQpt9rNfdmCIc/46l0ISh4anPmQJ+kJ9akk3MvPpGzyB0eLRyltzJu+zUmiSsmUysHttT5KFFNvisnswhOOb/5ZGMnvVPziViF+gxbdeXNlvsrFHxiGMmOOxm/0S27gSqhU6iEtgjGMgvUESiX6lTFqXFMnKPLYxEHDjZrDc8X0Rh/lxV+UzxUh7/LkdH7EmCmZWC4JEdAOKpv+yfmy/fZByyDs6C2Xa8b/5UGPojPI8lbz/umNqcmyTXNVZk1ZaXhmMDJMzpNPczImg+VSkR6JWZcpwuN2pqtd7Uc13beoZSSIA6zWW4Arub5I8zuRW6AL/O4BxcSFsOTD0kLAI0zBG0NI3FSy/HbY48tCSTz9z2aCm+4FjwIugM2tVJeHS+IzkksrXe5G+IMWQd/nyjqx+44EmAlHr8BlAO+yP84XqMpZkoz3XuJj0voQazOCX/XFbOOsAVkZet6v790I7Ogf7AYoyrOuDhO3ciYr0oQiYeO2poga6QLayGcV4fkhOF7BZVVABUz4VwafTZx4CYkO0Hj/HAwe23pkijy0UolpFYwwH+ytGok5vA2d+tUoLP
 fPark3Kd
 f1GQAjjjqn8RwBdZRnPY4M9vvDljOxb5zzY5GAdZvMOkYSX+3pEh4rBVAxl3UlNEaM66fNZoScYzBPMRKvMgaFhBUGHBcC+hn/PT1PSfIx5kd72vGxm/z6P9CwONopCHrZ/cbQ7/xsP9fe3iYOkhdaJ2PXR6CEbfNEZblhz/8UQswmX5ax/f8f9xYUILRUY79YziL9liGDNlE5Nrvz6pQVdtIcJ4QvDIzB9gw5473JJKY5cWvhp0JejND7ve3JumVgHvMWVNSi2E9WCLFKmPlr3/EXGPtXKF99BrZlCFFs734NSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kmemcg_id is a copy of the private memcg ID and serves no purpose
other than indexing the per-memcg list_lru xarray.  It is assigned
when kmem accounting goes online, which never happens with
cgroup.memory=nokmem, and the memcgs then all resolve to the
per-node lists.  The next patch needs the index to work under nokmem
as well.

Index the lists with mem_cgroup_id().  The cgroup ID is unique per
memcg and is only recycled once the cgroup is destroyed, long after
offlining has erased the xarray entries, so a recycled ID cannot
resurrect a stale entry.

Also drop the nokmem early return from the offline path, so that the
reparenting covers lrus that stay memcg aware without kmem
accounting.  memcg_online_kmem() and memcg_offline_kmem() are each
down to a single statement now; inline them into the css online and
offline hooks, dropping the root check, as css_offline() is never
called for the root and a memcg that failed css_online() cannot have
list_lru entries.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
 include/linux/memcontrol.h | 16 --------------
 mm/list_lru.c              | 16 ++++++++------
 mm/memcontrol.c            | 45 +++++++-------------------------------
 3 files changed, 17 insertions(+), 60 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 74110a324f9e..dc89d46e3d77 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -328,8 +328,6 @@ struct mem_cgroup {
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
 	int private_id;
 
-	int kmemcg_id;
-
 	/*
 	 * Should the OOM killer kill all belonging tasks, had it kill one?
 	 */
@@ -1820,15 +1818,6 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
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
@@ -1896,11 +1885,6 @@ static inline bool memcg_kmem_online(void)
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
index 61248b88441c..8e9577c5cb19 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -39,9 +39,10 @@ static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off,
 
 static inline unsigned long list_lru_memcg_idx(const struct mem_cgroup *memcg)
 {
-	int idx = memcg_kmem_id(memcg);
+	if (!memcg || mem_cgroup_is_root(memcg))
+		return 0;
 
-	return idx < 0 ? 0 : idx;
+	return mem_cgroup_id(memcg);
 }
 
 #ifdef CONFIG_MEMCG
@@ -548,7 +549,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		 * allocating a new mlru since CSS_DYING is already set for this
 		 * memcg a rcu grace period ago.
 		 */
-		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
+		mlru = xa_load(&lru->xa, list_lru_memcg_idx(memcg));
 		if (!mlru)
 			continue;
 
@@ -563,7 +564,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		for_each_node(i)
 			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
 
-		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
+		xa_erase_irq(&lru->xa, list_lru_memcg_idx(memcg));
 
 		/*
 		 * Here all list_lrus corresponding to the cgroup are guaranteed
@@ -578,9 +579,10 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 					    struct list_lru *lru)
 {
-	int idx = memcg->kmemcg_id;
+	if (!memcg || mem_cgroup_is_root(memcg))
+		return true;
 
-	return idx < 0 || xa_load(&lru->xa, idx);
+	return xa_load(&lru->xa, list_lru_memcg_idx(memcg));
 }
 
 static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
@@ -614,7 +616,7 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
 			if (!mlru)
 				return -ENOMEM;
 		}
-		xas_set(&xas, pos->kmemcg_id);
+		xas_set(&xas, list_lru_memcg_idx(pos));
 		do {
 			xas_lock_irqsave(&xas, flags);
 			if (!xas_load(&xas) && !css_is_dying(&pos->css)) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd6..fcba9eb55659 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3807,33 +3807,6 @@ void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
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
@@ -4309,7 +4282,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	seqlock_init(&memcg->socket_pressure_seqlock);
 #endif
 	memcg1_memcg_init(memcg);
-	memcg->kmemcg_id = -1;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
@@ -4383,7 +4355,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	struct obj_cgroup *objcg;
 	int nid;
 
-	memcg_online_kmem(memcg);
+	if (!mem_cgroup_kmem_disabled() && likely(!mem_cgroup_is_root(memcg)))
+		static_branch_enable(&memcg_kmem_online_key);
 
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
@@ -4391,7 +4364,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 * here, when mem_cgroup_iter() can't skip it.
 	 */
 	if (alloc_shrinker_info(memcg))
-		goto offline_kmem;
+		goto reparent_lrus;
 
 	for_each_node(nid) {
 		objcg = obj_cgroup_alloc();
@@ -4449,8 +4422,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
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
@@ -4466,11 +4439,11 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
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
@@ -5913,8 +5886,6 @@ static void __init memcg_struct_check(void)
 				      private_id_objcg);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      private_id);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
-				      kmemcg_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      oom_group);
 
-- 
2.43.7


