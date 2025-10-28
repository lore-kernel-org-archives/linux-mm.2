Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B537ECCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2147080152; Tue, 28 Oct 2025 10:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19ECA8013F; Tue, 28 Oct 2025 10:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 065F980152; Tue, 28 Oct 2025 10:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4E6B8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:02:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC53DB9A0E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:52 +0000 (UTC)
X-FDA: 84047688984.13.4B9D24C
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id E7FBFA001C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P1ZV/Rzo";
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660171; a=rsa-sha256;
	cv=none;
	b=3Ty0soGcgr2JzWteL3D9ebIoj7uYVE4OfnPfsrxgLr2AfhoKZ6HLCGomS3cq/E3laCPCLn
	9VU90v7dimOTE7Pt7dzugi+Tehko72e2rlkD5Nk4urYAGD22rxBpyf07cnnjlDKN2H2Air
	WxlmC4V+inA0fVWENATaWJZT3nqRLaE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P1ZV/Rzo";
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJMTup4HmkOG1M/S4B2pqIfmE4VeQgyqIHJuLcuLAMw=;
	b=25/89B9BFtOn4s2nyBH88P60zOtftFFaTSdUHxkQby3JQtB2LskBkDeULRV6JTc9oRHSFK
	yGs4AibZiUGSFskYaBktWDG5cYUVlWgSS37Sy+a7xUNtbpvP3qqUeL6AjfSQKAfcMuVM1G
	8a6VvHmvoJQzmXa2d83phvAQ01+P6YI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AJMTup4HmkOG1M/S4B2pqIfmE4VeQgyqIHJuLcuLAMw=;
	b=P1ZV/Rzo0zukdIZKNWkACft52p0bD9mj8vgl3w2tvfgkoYsM7iiIP2iysPyTViots9XuqC
	noF/6I8rjwF/84+02CM7BpyUGv3CRb/Qox7oaKjHs4FP018QD6ncfhErqR+b/ZbIChrrsd
	p1x2z3bmLs4Qym6k9dPwJf+DKz4vUt0=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 06/26] mm: memcontrol: return root object cgroup for root memory cgroup
Date: Tue, 28 Oct 2025 21:58:19 +0800
Message-ID: <5e9743f291e7ca7b8f052775e993090ed66cfa80.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 93tyww5u8cuo7bc4ke3cz315p4fm5t5p
X-Rspamd-Queue-Id: E7FBFA001C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761660170-558493
X-HE-Meta: U2FsdGVkX18wbLuC6sJqaW/4j7sMLzdKY9nR93TUMBC7h0CVpSXbqFjbfpFf44DUQ/40H+aCB6K10k+DODKs33nlPOs/8N4j6KssyVXDLWC93oGtzkiNHRNL03wkQyFZtwWCuOa43m561YrER4dO7kTClRXX7Xryee9kPgSzEwacT8xamCQIepX2OKrgbz4XKwfblq9bZGFH6id5zwBvysPXhSe0F6uzclFoXfFNLDsNLCi+cLIF6MQYPMExyMUgka5nzpo3z7N7lfJSe+S4YiMAG2Ume+0w4CayifgY0iNb4l626TSmF6fQW2wC6Wa9Ivppx5rnF0snA5krtdWD4rgBAJL9msbUJ9KbIUpxPQ7tAyD7BM4e7SAwEm4ah7JwDE6gb+4rIjYHGHdM6tbML0pjeqeZ/y5Ezr/YeiNdm40PghNL8yX5nCkNlb7CypRkxwbxffZeGuGz68KuimrL1O7WCZjuJ95fw4nLNIg4WUju90BkC4PQS9/TNYoOjQjEtM0lTb53w7NisiozEH0LsagNzJ/0N7t2zS30hgSGu1VMARzrIXvgxmdaBUcejQpcZo1CutGQSEiOFBk53fRXbsZ5iHTfyPPPLX9ehnXRJoE8AX+C1PMSSnKnPaBrmgQCIH+vxhlUuhvMGAkQluc5ohhfbgoc472BbuBRX4+18viYvhmbIdHzdPCtqxoK+Rqnf5mQJXYdBRKDPWIW0zEoJq2c1s1E4ukOVgwgR9pCSdDAwhtzXZc+DyXquFUBvbV5JA7U6ZuELd70XYftkxYAbGWwi+KERiCRqaGPFrvRo8N/zEKNqm8gG9X7S2ReDeRhXow4y5wBGDhcnGZre7Lj+TDI0D4VwmhnAjsg09DDQyw26uAntkAQr4XPhhyswiraQ44ywCu25Gvw+545aFMbfRaC44kDkdodYt6Ufcw8nIvw4bt8EaUwrO+JMTEv5OnAgFIWRQhtVi2qWS/5bbQ
 EuiXhkMn
 e3h4JE6IzY1LS/GowiviSyAczvFcByxR9AR9tRey45gc0zXglx742UMpwHb+Lazq81Q95XIXCvwr+CvhtSl4rxIonpDQ45l+heHqt74HS6hNn1nE11sBRC22PvDFZAyhhV0TBTEyvVTsuMcdc8735NwzfzjdNe0pWXBAoLKBSqxIHC1jAEByHOSVo/7MKDTVbE9x+VfNoKtgliGr6O4tkIwtiNg==
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
 include/linux/memcontrol.h | 29 +++++++++++++++++-------
 mm/memcontrol.c            | 45 ++++++++++++++++++++------------------
 mm/percpu.c                |  2 +-
 3 files changed, 46 insertions(+), 30 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6185d8399a54e..9fdbd4970021d 100644
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
 
@@ -1094,6 +1103,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
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
@@ -1710,8 +1724,7 @@ static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 {
 	struct obj_cgroup *objcg = current_obj_cgroup();
 
-	if (objcg)
-		obj_cgroup_get(objcg);
+	obj_cgroup_get(objcg);
 
 	return objcg;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2afd7f99ca101..d484b632c790f 100644
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
@@ -2642,15 +2644,14 @@ struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
 
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
@@ -2724,18 +2725,17 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
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
@@ -2744,10 +2744,10 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
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
@@ -2761,14 +2761,8 @@ struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
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
@@ -2871,7 +2865,7 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
 	int ret = 0;
 
 	objcg = current_obj_cgroup();
-	if (objcg) {
+	if (!obj_cgroup_is_root(objcg)) {
 		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
 		if (!ret) {
 			obj_cgroup_get(objcg);
@@ -3172,7 +3166,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	 * obj_cgroup_get() is used to get a permanent reference.
 	 */
 	objcg = current_obj_cgroup();
-	if (!objcg)
+	if (obj_cgroup_is_root(objcg))
 		return true;
 
 	/*
@@ -3859,6 +3853,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	if (!objcg)
 		goto free_shrinker;
 
+	if (unlikely(mem_cgroup_is_root(memcg)))
+		root_obj_cgroup = objcg;
+
 	objcg->memcg = memcg;
 	rcu_assign_pointer(memcg->objcg, objcg);
 	obj_cgroup_get(objcg);
@@ -5479,6 +5476,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
+	if (obj_cgroup_is_root(objcg))
+		return;
+
 	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
 
 	/* PF_MEMALLOC context, charging must succeed */
@@ -5506,6 +5506,9 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
+	if (obj_cgroup_is_root(objcg))
+		return;
+
 	obj_cgroup_uncharge(objcg, size);
 
 	rcu_read_lock();
diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e1..78bdffe1fcb57 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1616,7 +1616,7 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 		return true;
 
 	objcg = current_obj_cgroup();
-	if (!objcg)
+	if (obj_cgroup_is_root(objcg))
 		return true;
 
 	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
-- 
2.20.1


