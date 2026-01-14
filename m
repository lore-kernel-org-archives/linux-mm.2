Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3633D29FE6
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695256B0088; Wed, 14 Jan 2026 06:33:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63FC46B0089; Wed, 14 Jan 2026 06:33:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56C796B008C; Wed, 14 Jan 2026 06:33:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 455F56B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:33:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBCF4140479
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:18 +0000 (UTC)
X-FDA: 84330358476.25.EE4AC02
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 35997C0013
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XGr9kaTV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390397; a=rsa-sha256;
	cv=none;
	b=FDwC7wCLNdxKBeTQkQJ7iZtK6HYSqp45FN7TY+1n33d6qcZSQO8blVkhY0WqCiRp9XZYPK
	J7UVKNMrLs5coB2cUwybDKn+g3kMIotturxOE1BSjiQ6Vzd+jqVihiLyisV37mfWNAlvld
	MVjTusRUhJQYBCsqxtF3EekHzEESYx0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XGr9kaTV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKPPKCQQxka9bJoLhTvWlSU23RKb3N5VA/3uHlSUrh4=;
	b=HxvEdx+3VP0+JE1A2ssfKHSU1uLVkyEDVfaU2FBzKcsJKhHf43z6YDBttiqFsnTOmHK0+I
	UZD2drnmqKlDncvON85lyx2GZr0UZrbfkQd2RSNmptV0G8vDKrE7HXECe06JPe53TL94cs
	895IN5B+68bSW40PjH+RmHqqcxk/iys=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKPPKCQQxka9bJoLhTvWlSU23RKb3N5VA/3uHlSUrh4=;
	b=XGr9kaTVOF3CouwCXWoEL0FbL45Ca0K44rban2v/DtYfF/m8Bly+gphwoICOLuFPgFQjsS
	kNLiebGPF8eN2RBkQXTIYmJz18lUAwZO0elMzIddNvvXNxnk50o0n97wU5LC2OVLlRkaT7
	olr+xi9nbApWXlqJaB8jK5g+oQOpgkQ=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 07/30] mm: memcontrol: return root object cgroup for root memory cgroup
Date: Wed, 14 Jan 2026 19:32:34 +0800
Message-ID: <e8281b894e778472d3040b4b9027f7d25f0fd1ae.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 35997C0013
X-Stat-Signature: 9cn5arjhp11pukas69wzzmsubch3iif8
X-Rspam-User: 
X-HE-Tag: 1768390396-904000
X-HE-Meta: U2FsdGVkX1+5C7ZKK74WwXtBrOpslyrOSzkKu2W1NV1mijBrt9JRKnRFGX9AI0PdjyyLUW35WQILqs1teyxlPn/v1e6KctwRTEPdvy1RwjKz8zmFPj9fHwlIcbkGD7XNu+Nm0nF25pKL/T/k4PVe9MqO5QFItqR5KfNlcmn0ZKxUbktHkUtWWHlDFaryFNYGJbkYI4zLwUro9PIMA1sLddJY2xB1QWhO9aHQ7T4TIk+MeEaQNX49nUof9tpNFmLzV7Qnh5bFk9hovFLXgEimgEBJLaM6Q3NanvqEoO12AMTvqgymoa2W1YYsp3bZCALaOYl+qJ4ZG9aLTctkAz9EyQ7yrZyfn8o9UxCu6KPZwOykS3kmVm5g8nIjwXMsa8b+3awJUGrJQO/hSv4eRfG2LdzipnWYettaYt9ptLr5Z2WKFvTbbmwKSqk+WRl3UQPJiAI+Pc9ymjV8CeyfbXcfdKchZ+UeMbUKUyl/KH4NQY9a5Q08JcITNBdXwoiPaWK5kjvPeS4Wf/ezmNXFMi8h9UhequpogoisL+ESVGGNjKdd3fBj1G1Q268OVG49Ktw6SaGwygSqVNpzzB/mR8IvwpE8NIcVNOZk+XYeWw1kKgMzHDXBmk7BZ9AXfigOgjN5GKYh2wacnZJEk/aZxM0zoquFEfTbWZYTEOYT9mgQWyohPgD3Ba2LXdLLdqolHyhT8BUFxqgn0avQZvUc0DAz78DIpoj8CyzHcqcKrEeuI5Zdb9GZAWZnsGO4XWQp1ewEL2Qd+ldo+80r764scsblCR8NWxMJYd8m78IBzSDocU962riX5bPbdqDVqbFhkR63TnKKl4vVXQHAG9TC+VvRld1JQyq/fLWC/GHKFAzREh2wVh1WGJpUU+SQGuiP15JARxR16a45am5hkLQyM8ghOTA4rxb7vQmclP6G1riDRSkH6uOhC7vV3KMVKKNFCf0JlzkO8ctc3gc8vZuwnfi
 oJJYR4fZ
 dm+MWvJGA5NIirpu0qcvrECPtLAzgAFcwumEwNZx/pIkZIfBj7pMAAhCmTjqNjmGVHT9NItoyD/zZe0jKI6OJuNIdGu8gCyObmkSp+1vIYWieq5Grh0GWhrRxjENupZsKEsbO7S7zXh3L0J+A2YZJoFxCNOug4dv/lY/kVBjrzQlfvGQ2zdgXva507oo90nf/Cr9UHH2MaBqIwJLMVGlILWbT1lfMM5V9slJg6MEcivafxTWqMeC0URIf9Xk0ki2Nw6/QNc/ypjvD2sn7myGM9uQglA==
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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 26 +++++++++++++++++-----
 mm/memcontrol.c            | 45 ++++++++++++++++++++------------------
 mm/percpu.c                |  2 +-
 3 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6a44e79a8bd23..7b3d8f341ff10 100644
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
@@ -775,23 +781,26 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 
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
 
@@ -1088,6 +1097,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
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
index a9057f24cc48f..982c9f5cf72cb 100644
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
@@ -2668,15 +2670,14 @@ struct mem_cgroup *mem_cgroup_from_virt(void *p)
 
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
@@ -2750,18 +2751,17 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
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
@@ -2770,10 +2770,10 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
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
@@ -2787,14 +2787,8 @@ struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
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
@@ -2897,7 +2891,7 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
 	int ret = 0;
 
 	objcg = current_obj_cgroup();
-	if (objcg) {
+	if (objcg && !obj_cgroup_is_root(objcg)) {
 		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
 		if (!ret) {
 			obj_cgroup_get(objcg);
@@ -3198,7 +3192,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	 * obj_cgroup_get() is used to get a permanent reference.
 	 */
 	objcg = current_obj_cgroup();
-	if (!objcg)
+	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
 	/*
@@ -3868,6 +3862,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	if (!objcg)
 		goto free_shrinker;
 
+	if (unlikely(mem_cgroup_is_root(memcg)))
+		root_obj_cgroup = objcg;
+
 	objcg->memcg = memcg;
 	rcu_assign_pointer(memcg->objcg, objcg);
 	obj_cgroup_get(objcg);
@@ -5496,6 +5493,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
+	if (obj_cgroup_is_root(objcg))
+		return;
+
 	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
 
 	/* PF_MEMALLOC context, charging must succeed */
@@ -5523,6 +5523,9 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
+	if (obj_cgroup_is_root(objcg))
+		return;
+
 	obj_cgroup_uncharge(objcg, size);
 
 	rcu_read_lock();
diff --git a/mm/percpu.c b/mm/percpu.c
index c9f8df6c34c30..1a9328f66a7f7 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1622,7 +1622,7 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 		return true;
 
 	objcg = current_obj_cgroup();
-	if (!objcg)
+	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
 	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
-- 
2.20.1


