Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4365D64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451586B0093; Wed, 17 Dec 2025 02:30:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41BAB6B0098; Wed, 17 Dec 2025 02:30:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365576B0099; Wed, 17 Dec 2025 02:30:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 222DE6B0093
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:30:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA4191A0922
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:30:10 +0000 (UTC)
X-FDA: 84228139380.22.5539F6E
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 346A418000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:30:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u3ENEzXx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956609; a=rsa-sha256;
	cv=none;
	b=RHkld3MVtUbSx531h4v1i9lceedTphb1VQlNQb+aV00Qzmuzte9V//dyPR0VhwjKM3U08Y
	JbLIQTLskeuoaS+tbX8UifHpABHLrTlzeIFBsMz4l942F5lJop0vBWu0B6IPFRMTiPMh5O
	kBbnB2hMuESmfNn9YgLz7gN5+eQqCZs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u3ENEzXx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnE9D8GcmnKRbpRKs57u5JAtmYg0S0V4yTV24f2KZzo=;
	b=D0kkGcn94AgMP5Hv9+GYUzXKcmR6znQ6RytH7lejezFV2pGCNFBQ6F8d2hUcBKCRmeJ2zJ
	dF/v/4cgPNOk22L1S+Mj8N4jKQ5tnBmV4HEGBVGEHlkgmUaKRZUr4weNv+6Uot8d2pHEt4
	S356NDTr4jo3zTddhQW7jFZV3kCJd0Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MnE9D8GcmnKRbpRKs57u5JAtmYg0S0V4yTV24f2KZzo=;
	b=u3ENEzXxDb64wtMs933am3zKugIqhdmbD57tRwNjWeyhnsAiReZEVeXYbf/N1PYvNFWTdH
	HkmXFLPyJ+pqHOImJNdVCSRahBZ2ZcwRkABHvQtvTMGJeIj1cNo5P2seUKiPABLUEs84+u
	cFx3aKrJcnFk2RxraqJQm8kATG+0c+o=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 07/28] mm: memcontrol: return root object cgroup for root memory cgroup
Date: Wed, 17 Dec 2025 15:27:31 +0800
Message-ID: <3e454b151f3926dbd67d5df6dc2b129edd927101.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 346A418000C
X-Stat-Signature: kreebu3ptg87bq7cpoma5q3g4csbsub9
X-Rspam-User: 
X-HE-Tag: 1765956608-602528
X-HE-Meta: U2FsdGVkX1/AlnoRWHKv++ulWvHOF2+3QLF72ReS7C8i1222dohGdqPxUJbrdRCogVcK9jRvspK7on60JyFsrCxe3AZ97xYu3Ix162zNzDETIvgHSr+x7+U5P4B8of171RMK1dwIv+aK7NT3+72kc127w0H0hULE5GzkE1OzLcYuF+EdVxwscytgz0mlR3pJZWIO1N1IZCfRsawsYCrkuc3zsW3/vXDbvT86vfQCZUOV2C78A6uGai0xTSWKJuKILBWSO/sawOiWrndKpQyMRIBsg9KD5oFPW/WMg9FTiM886AhwISKjiCbcQG6Xfy8Z9QEvSshpS4YhcHFjGMRMmSgzzBv2WY3FhvgqYC9yRCsQTSmARQPqxEnkKlY492j5L5UKezY+vRQbQe8BMGy/wLCsagBXQlhXID+rVrmRnKABUDApj4B8PS7VclaTF/T0V+jNrHpY91wK4zdN+cwyZtkVnRz8AugwjlHkH3qus+JURl5XPfGpk4EcY0dp6krctCnWXbitF8TbsRIJ0AJKdLjgyjEhNgNYrc4o7FNotAcxa8IWMWk2Dr008on5rbDmcJEiKd+HWHXQNo0n3iL14cH4yfp4TRWbCHqhBIJfABzaS94tX4o0PtZl9XUq9w+BbBBa3qGU9E/Wvswlzha/QHU6azA1mZfyZw7lNzf08FTt/bxYbCO8Io9XqVcV1LkwsB0crC02zAOohszAeEjMrnVnR42V7dCAGAixgGKIr5oR9s01hI0ukRzhS8eVPFkroDAK4RQHRwGs+SqwzgtHgebsh4Fy26g6ukW2/yDlUhRinmKWmXhM93Ld+uRgWAjcV0bLfyThcVs4nn1RuQXE/MnUMSyeq3XspIEGFCdCy5Z3+KLFiZ/vJPUrH5BsB82bzK+GBr2YQ2PxX4cAHNRjuKQkjoEuWMtkEiWOv3FgfaNYCF134MjUxm9Dkq9CZmYdAI8r10Um+h4z//yn1VM
 mSZFI+tx
 MPjEeFkQnvEJUTs9YaNR6uHc15Zl1Ljw0oCwKr4d+OIOfQZpBoUJ2Wg78N1EVY03XZInj49hRQrY5J2tSlGZLtAcJrbBchJDAChN14zOYxDdXhxy673CEe0QFVdFPW66+1z7hDb7nzZUj+iG2ogx1Wj9nFbm39l0jQZlCL3RdbkRgTXD8C1HuI0ZzSbOzfj2lvQdtAJwghV5pab34Z1qre3HbZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

Memory cgroup functions such as get_mem_cgroup_from_folio() and
get_mem_cgroup_from_mm() return a valid memory cgroup pointer,
even for the root memory cgroup. In contrast, the situation for
object cgroups has been different.

Previously, the root object cgroup couldn't be returned because
it didn't exist. Now that a valid root object cgroup exists, for
the sake of consistency, it's necessary to align the behavior of
object-cgroup-related operations with that of memory cgroup APIs.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h | 26 +++++++++++++++++-----
 mm/memcontrol.c            | 45 ++++++++++++++++++++------------------
 mm/percpu.c                |  2 +-
 3 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 288dd6337f80f..776d9be1f446a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -332,6 +332,7 @@ struct mem_cgroup {
 #define MEMCG_CHARGE_BATCH 64U
 
 extern struct mem_cgroup *root_mem_cgroup;
+extern struct obj_cgroup *root_obj_cgroup;
 
 enum page_memcg_data_flags {
 	/* page->memcg_data is a pointer to an slabobj_ext vector */
@@ -549,6 +550,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 	return (memcg == root_mem_cgroup);
 }
 
+static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
+{
+	return objcg == root_obj_cgroup;
+}
+
 static inline bool mem_cgroup_disabled(void)
 {
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
@@ -773,23 +779,26 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 
 static inline bool obj_cgroup_tryget(struct obj_cgroup *objcg)
 {
+	if (obj_cgroup_is_root(objcg))
+		return true;
 	return percpu_ref_tryget(&objcg->refcnt);
 }
 
-static inline void obj_cgroup_get(struct obj_cgroup *objcg)
+static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
+				       unsigned long nr)
 {
-	percpu_ref_get(&objcg->refcnt);
+	if (!obj_cgroup_is_root(objcg))
+		percpu_ref_get_many(&objcg->refcnt, nr);
 }
 
-static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
-				       unsigned long nr)
+static inline void obj_cgroup_get(struct obj_cgroup *objcg)
 {
-	percpu_ref_get_many(&objcg->refcnt, nr);
+	obj_cgroup_get_many(objcg, 1);
 }
 
 static inline void obj_cgroup_put(struct obj_cgroup *objcg)
 {
-	if (objcg)
+	if (objcg && !obj_cgroup_is_root(objcg))
 		percpu_ref_put(&objcg->refcnt);
 }
 
@@ -1084,6 +1093,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 	return true;
 }
 
+static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
+{
+	return true;
+}
+
 static inline bool mem_cgroup_disabled(void)
 {
 	return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 544b3200db12d..21b5aad34cae7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -83,6 +83,8 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
 struct mem_cgroup *root_mem_cgroup __read_mostly;
 EXPORT_SYMBOL(root_mem_cgroup);
 
+struct obj_cgroup *root_obj_cgroup __read_mostly;
+
 /* Active memory cgroup to use from an interrupt context */
 DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
 EXPORT_PER_CPU_SYMBOL_GPL(int_active_memcg);
@@ -2634,15 +2636,14 @@ struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
 
 static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 {
-	struct obj_cgroup *objcg = NULL;
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
+		struct obj_cgroup *objcg = rcu_dereference(memcg->objcg);
 
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
-		objcg = rcu_dereference(memcg->objcg);
 		if (likely(objcg && obj_cgroup_tryget(objcg)))
-			break;
-		objcg = NULL;
+			return objcg;
 	}
-	return objcg;
+
+	return NULL;
 }
 
 static struct obj_cgroup *current_objcg_update(void)
@@ -2716,18 +2717,17 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
 		 * Objcg reference is kept by the task, so it's safe
 		 * to use the objcg by the current task.
 		 */
-		return objcg;
+		return objcg ? : root_obj_cgroup;
 	}
 
 	memcg = this_cpu_read(int_active_memcg);
 	if (unlikely(memcg))
 		goto from_memcg;
 
-	return NULL;
+	return root_obj_cgroup;
 
 from_memcg:
-	objcg = NULL;
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
 		/*
 		 * Memcg pointer is protected by scope (see set_active_memcg())
 		 * and is pinning the corresponding objcg, so objcg can't go
@@ -2736,10 +2736,10 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
 		 */
 		objcg = rcu_dereference_check(memcg->objcg, 1);
 		if (likely(objcg))
-			break;
+			return objcg;
 	}
 
-	return objcg;
+	return root_obj_cgroup;
 }
 
 struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
@@ -2753,14 +2753,8 @@ struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
 		objcg = __folio_objcg(folio);
 		obj_cgroup_get(objcg);
 	} else {
-		struct mem_cgroup *memcg;
-
 		rcu_read_lock();
-		memcg = __folio_memcg(folio);
-		if (memcg)
-			objcg = __get_obj_cgroup_from_memcg(memcg);
-		else
-			objcg = NULL;
+		objcg = __get_obj_cgroup_from_memcg(__folio_memcg(folio));
 		rcu_read_unlock();
 	}
 	return objcg;
@@ -2863,7 +2857,7 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
 	int ret = 0;
 
 	objcg = current_obj_cgroup();
-	if (objcg) {
+	if (objcg && !obj_cgroup_is_root(objcg)) {
 		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
 		if (!ret) {
 			obj_cgroup_get(objcg);
@@ -3164,7 +3158,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	 * obj_cgroup_get() is used to get a permanent reference.
 	 */
 	objcg = current_obj_cgroup();
-	if (!objcg)
+	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
 	/*
@@ -3851,6 +3845,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	if (!objcg)
 		goto free_shrinker;
 
+	if (unlikely(mem_cgroup_is_root(memcg)))
+		root_obj_cgroup = objcg;
+
 	objcg->memcg = memcg;
 	rcu_assign_pointer(memcg->objcg, objcg);
 	obj_cgroup_get(objcg);
@@ -5471,6 +5468,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
+	if (obj_cgroup_is_root(objcg))
+		return;
+
 	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
 
 	/* PF_MEMALLOC context, charging must succeed */
@@ -5498,6 +5498,9 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
+	if (obj_cgroup_is_root(objcg))
+		return;
+
 	obj_cgroup_uncharge(objcg, size);
 
 	rcu_read_lock();
diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e1..5c1a9b77d6b93 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1616,7 +1616,7 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 		return true;
 
 	objcg = current_obj_cgroup();
-	if (!objcg)
+	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
 	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
-- 
2.20.1


