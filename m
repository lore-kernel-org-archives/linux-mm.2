Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73096C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9076B00A7; Fri, 18 Sep 2026 05:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80B866B00AB; Fri, 18 Sep 2026 05:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573816B00AC; Fri, 18 Sep 2026 05:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9BF6B00A7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:19:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAB85405CF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:19:02 +0000 (UTC)
X-FDA: 85226333724.12.9C2FA43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id ECFE840007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c2P6OkAx;
	spf=pass (imf17.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723141;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMoAfZb8j3IBJv42ORKY88ptFm00BAlJzFO6l4s5GIs=;
	b=iXZBe/Du3IqRAnUZ5W/9jVTrIBdrOE9ZWTsQv89tKNg5UwG2TiPrqdhX2WcUnBrsJ5j1Gv
	pAF4c+tbK9uPNzo3jliGKK4bfJ+WQfTbSOyO2RQQ3SRs0VWd4oJrXUSRZqZKgATQU198Tz
	k5Vwnl8Rq1WDWnNpqFcxOM0VSO465gw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c2P6OkAx;
	spf=pass (imf17.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723141;
	b=hBVcpKGHtFHuSPLbNTmRdHVYmiNv0fh+0GRPVdcHriV0KUTiRN3HO/85a7IFAUL8a+noED
	06tZOZ78bcyOcoX6rgs6HrhDd1yNKwxGD/5Iv2oV0wBkE65ZIlLCKWUbS/FTYrSHzN5oDy
	mInm6dGMi0ERuBZ3x9pPtMySr2Tew9I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AF4A4401B;
	Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1176FC2BCFB;
	Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789723140;
	bh=XmbfDL9M0mFbLi5nBCzqpZBJCpu57dJ9tHcAICjPrDo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=c2P6OkAxGGitkM1W49ryaLS526ZFKLomW3Fli9ZdLe82gumkcZvN9gYnszcsE9X4Z
	 yLvEH8MFY/hL1znD9HYFkoFZ8cDI29aaXJTcJuwRYV3wU7QelrEKXkDJ77Q/Jnwmjj
	 MMU7srdg5tH0nmTVCPbqBiYf3uCvgMQmGcfc4Wd6W+lKo3/akUUbJZ+wXCSN1bzAjt
	 bEn3TrJeaJspsOgcit5VZ2K2BAcUhSCWvDJyRlkYo0MyYWFMPYFFIrCDbOxsDoh+bG
	 k3zNV+P3xjxEF62hqpkjflBzqEvZu7xcu0/mXbzZAFyZFkZZR5M5P6Ya1fvluSNtF3
	 VV5LbW+xCw5sg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF043C982DE;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 17:18:43 +0800
Subject: [PATCH 4/4] memcg: move memcg private ID refcount to objcg
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-bingfangguo-memcgid-rework-v1-4-5bbf3220d88f@tencent.com>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789723137; l=10676;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=keu0MaglwSdlcO2puvCiM3UcOhloxeWaW6PYrc9Ds0s=;
 b=oIK3782o/9UOuWPIu1qkDEYGy2u9y/iXbfA5xjq7ew8n2P/MgPNrhqH6KsWOMmzQ7qATQmtlO
 Cu0ZIUsnxlEDB+xzPTukA8zoSmpm6oa8o13jF+wpCJd6mTgoris9NLD
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspam-User: 
X-Stat-Signature: qnbdp3b81s1kw1m81f94x9mpfwpatid4
X-Rspamd-Queue-Id: ECFE840007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789723140-352033
X-HE-Meta: U2FsdGVkX19LNqa8rUUN3gW4nDw4uZcjw43a9XKJtlxer60CB0d22bCd6HnzcZrVgMyuvkhMskB1oAY9rfT26gyWoJ3kD/GCOcbngLla2+TY38R0I8qKWkYDfmsVWltfYUYK1ZZA9FsMU1/B481/pQ9rr9yov4MgfDaGX8nNKt1oNC/0nIsEU8he1R4FPAlOGBtCFfpmJ8lhrwGWLLTS5Y7ejQZWrTg4SyljZmi8pyRCQ640g3HlBAaCI7M9j09n0e+Q55X8Grq/esIhA7xAIYxbwXF1adWuJ6VSwPQc2ZVoc3gnu6fUei1Hxj/8wT8vKS7xuEOSiGBnagvH8mhXif7RcIgDw6r0z5GWYRnULBfv34Cs/WQL+2cM7gyxcbimABWEdZtHzH5P01JP/ip3Q+qxreM6T+rTscbINuRFeMMw8PtKqwE0QyBKchTuFFVTFDcNjJrgGZz1DlJPdvm3JyDH+r8ibuAKrxEvpxCAlQ12ryJJ4lfZefBX5RmM6hPCpRlKb8/rpXtCOMnWQIIGr7mqJatqAoAmnWoL4G5KpMXm/BHBQ8HmXnCwIrrTDLoDH6dKTNx5NLL5PWqV4hzMNxKnZAPiz3axD7bYzGgNX7TN1LK5hH+tNL0TZi2ly522cHX3ksnltA9Xz2HI3X2zIfBA43P2ehyUNQuC50RyPENBwr5gSzRkufK3MJoRzXD+1qzM4s4VW0879fR82b40xgzHk6JPW7PdyDaWj4q9fKQ4e2gw7Tu4CFwJC52cHC2JUHUJagqEIGtGMlwN3U3tfN8TMB5CmzAswC2SPPpIQL1jiDufWbOkexzbIHQ5i+EMmGLj8WtbqeJUv54gC/yBTmEqWxqmp/86+ooC/JcFeHzpgBbOP7dCfhmSovNamszR5uS9rLGH48elpPH6Ao6gpB0VxGweJx9ChwkMqNDb58D57AlWH870J9GUI1BTmUNzHuxvZ9jPVCZ/wVdnZKR
 99Xd/lU0
 IQkQakt00qnVtSCgXV4lDR+X4i83NhNU9fO9AuPePdLhFNBmnwHxb/x675IRfU64oSGQY0xCW06oqzhx8ttOFIDA11izDugkHjY9qzIw93UbhiGfrOUFzSLXW7e1JyXX705/pE2GxB8d8iaERiwhjBnvymQ3GNJPfaFx/H0jkPpDJ9vvTn4vcXeuXofBMDsSTCPoO+68aftxva7DkFQHYVsRW7O1wJzr3srEn9dAENmHCVWFHRDz+a5LwB+OtWdRZcJk2ILAd6IOqn/HlNF+ZBHnkMmyh3I4lqhLGXOEygqJ8i4tKBjMvq3Y8tkHqR9X6xceIYHduslMaEovTJC2MboD9nfY5q768bjumafdp9y+ogziUAUUs4AiGEsjPKMHLPE3unb3cRyR150sUw3tXzajMNgbgI+CZZUO0chSW5KtQyzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

The memcg private ID is used by objects that can't afford storing a
whole pointer and can outlive memcgs to track the memcg (notably swap
entries). The current design holds a refcount to the css, preventing the
memcg from being freed.

This patch unbinds the lifetime of memcgid from the memcg so it can be
freed.  The idea is to move the refcount of memcgid to one of the
memcg's objcg. The objcg is stored in the global memcgid xarray instead
and used for retrieving the online memcg from it.  So swapped out pages
no longer pin the dying memcg.

After the change, a memcgid can refer to a non present memcg. To handle
this situation, when trying to get the original memcg from the id,
compare the memcgid passed in with that of the memcg, and return NULL to
indicate its death if they differ. NULL checks are added for
list_lru_walk_node(), workingset_test_recent() and lru_gen_test_recent()
to skip dead memcgs.

In the earlier patch, an extra xarray lookup was introduced in swap
uncharging path.  Now that we have the objcg pointer in the function,
the extra overhead can be removed by using it for putting directly.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 include/linux/memcontrol.h |  9 +++---
 mm/list_lru.c              |  2 +-
 mm/memcontrol.c            | 81 ++++++++++++++++++++++++++++++++++------------
 mm/workingset.c            |  5 ++-
 4 files changed, 71 insertions(+), 26 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7af..3fb18191cfbd1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -180,6 +180,7 @@ struct obj_cgroup {
 	struct percpu_ref refcnt;
 	struct mem_cgroup *memcg;
 	atomic_t nr_charged_bytes;
+	refcount_t private_id_ref;
 	union {
 		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
@@ -225,9 +226,6 @@ struct mem_cgroup {
 	/* vmpressure notifications. Written on every reclaim iteration. */
 	struct vmpressure vmpressure;
 
-	/* Written on every swap charge and uncharge. */
-	refcount_t private_id_ref;
-
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 	/* MEMCG_KMEM for nmi context */
 	atomic_t		kmem_stat;
@@ -324,8 +322,11 @@ struct mem_cgroup {
 	unsigned long zswap_max;
 #endif
 
+	/* The objcg holding private memcg ID. */
+	struct obj_cgroup *private_id_objcg;
+
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
-	int private_id;
+	unsigned short private_id;
 
 	int kmemcg_id;
 
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 8a6dd0a489e12..7edd79113cc56 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -428,7 +428,7 @@ unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
 		xa_for_each(&lru->xa, index, mlru) {
 			rcu_read_lock();
 			memcg = mem_cgroup_from_private_id(index);
-			if (!mem_cgroup_tryget(memcg)) {
+			if (!memcg || !mem_cgroup_tryget(memcg)) {
 				rcu_read_unlock();
 				continue;
 			}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ed44b3e7ac938..22deee8312856 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4074,6 +4074,18 @@ static void memcg_wb_domain_size_changed(struct mem_cgroup *memcg)
 #define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
 static DEFINE_XARRAY_ALLOC1(mem_cgroup_private_ids);
 
+/**
+ * obj_cgroup_from_private_id - look up the objcg holding the memcg id.
+ * @id: the memcg id to look up
+ *
+ * Caller must hold rcu_read_lock().
+ */
+static inline struct obj_cgroup *obj_cgroup_from_private_id(unsigned short id)
+{
+	lockdep_assert_once(rcu_read_lock_held());
+	return xa_load(&mem_cgroup_private_ids, id);
+}
+
 static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 {
 	if (memcg->private_id > 0) {
@@ -4082,34 +4094,43 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 	}
 }
 
-static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
+static void __mem_cgroup_private_id_put(struct obj_cgroup *objcg,
+		unsigned short id, unsigned int n)
 {
-	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
-		mem_cgroup_private_id_remove(memcg);
+	struct obj_cgroup *objcg_free;
 
-		/* Memcg ID pins CSS */
-		css_put(&memcg->css);
+	if (refcount_sub_and_test(n, &objcg->private_id_ref)) {
+		objcg_free = xa_erase(&mem_cgroup_private_ids, id);
+		VM_WARN_ON(objcg_free != objcg);
+
+		/* Memcg ID pins the objcg */
+		obj_cgroup_put(objcg);
 	}
 }
 
 static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
 {
-	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(id);
-	__mem_cgroup_private_id_put(memcg, n);
+	objcg = obj_cgroup_from_private_id(id);
+	__mem_cgroup_private_id_put(objcg, id, n);
 	rcu_read_unlock();
 }
 
 static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
 {
-	__mem_cgroup_private_id_put(memcg, 1);
+	__mem_cgroup_private_id_put(memcg->private_id_objcg, memcg->private_id, 1);
 }
 
 unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n)
 {
-	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
+	struct obj_cgroup *objcg;
+	lockdep_assert_once(rcu_read_lock_held());
+
+	objcg = memcg->private_id_objcg;
+
+	while (!refcount_add_not_zero(n, &objcg->private_id_ref)) {
 		/*
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
@@ -4119,6 +4140,7 @@ unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int
 			break;
 		}
 		memcg = parent_mem_cgroup(memcg);
+		objcg = memcg->private_id_objcg;
 	}
 
 	return mem_cgroup_private_id(memcg);
@@ -4129,11 +4151,24 @@ unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int
  * @id: the memcg id to look up
  *
  * Caller must hold rcu_read_lock().
+ *
+ * @return: the memcg, or NULL if the memcg referred to is already dead.
  */
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 {
+	struct obj_cgroup *objcg;
+	struct mem_cgroup *memcg;
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return xa_load(&mem_cgroup_private_ids, id);
+
+	objcg = obj_cgroup_from_private_id(id);
+	if (!objcg)
+		return NULL;
+
+	memcg = obj_cgroup_memcg(objcg);
+	if (mem_cgroup_private_id(memcg) != id)
+		return NULL;
+
+	return memcg;
 }
 
 struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
@@ -4228,18 +4263,21 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	struct mem_cgroup *memcg;
 	int node, cpu;
 	int __maybe_unused i;
+	unsigned int private_id;
 	long error;
 
 	memcg = kmem_cache_zalloc(memcg_cachep, GFP_KERNEL);
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
 
-	error = xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, NULL,
+	error = xa_alloc(&mem_cgroup_private_ids, &private_id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
 	if (error)
 		goto fail;
 	error = -ENOMEM;
 
+	memcg->private_id = private_id;
+
 	memcg->vmstats = kzalloc_obj(struct memcg_vmstats, GFP_KERNEL_ACCOUNT);
 	if (!memcg->vmstats)
 		goto fail;
@@ -4380,9 +4418,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
 
-	/* Online state pins memcg ID, memcg ID pins CSS */
-	refcount_set(&memcg->private_id_ref, 1);
-	css_get(css);
+	/* CSS pins memcg ID, memcg ID pins obj cgroup */
+	memcg->private_id_objcg = objcg;
+	refcount_set(&memcg->private_id_objcg->private_id_ref, 1);
+	obj_cgroup_get(memcg->private_id_objcg);
 
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
@@ -4394,7 +4433,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
-	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg, GFP_KERNEL);
+	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg->private_id_objcg, GFP_KERNEL);
 
 	return 0;
 free_objcg:
@@ -5832,8 +5871,6 @@ static void __init memcg_struct_check(void)
 				      memory_events_local);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
 				      vmpressure);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
-				      private_id_ref);
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
 				      kmem_stat);
@@ -5878,6 +5915,8 @@ static void __init memcg_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      zswap_writeback);
 #endif
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      private_id_objcg);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      private_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
@@ -6015,10 +6054,12 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
  */
 void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 {
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(id);
+	objcg = obj_cgroup_from_private_id(id);
+	memcg = obj_cgroup_memcg(objcg);
 	if (memcg) {
 		if (!mem_cgroup_private_id_is_root(id)) {
 			if (do_memsw_account())
@@ -6027,7 +6068,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(id, nr_pages);
+		__mem_cgroup_private_id_put(objcg, id, nr_pages);
 	}
 	rcu_read_unlock();
 }
diff --git a/mm/workingset.c b/mm/workingset.c
index 8412f4840ae35..7e4fbc5a786d6 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -281,6 +281,9 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
 
 	memcg = mem_cgroup_from_private_id(memcg_id);
+	if (!memcg)
+		return false;
+
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
@@ -470,7 +473,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * configurations instead.
 	 */
 	eviction_memcg = mem_cgroup_from_private_id(memcgid);
-	if (!mem_cgroup_tryget(eviction_memcg))
+	if (eviction_memcg && !mem_cgroup_tryget(eviction_memcg))
 		eviction_memcg = NULL;
 	rcu_read_unlock();
 

-- 
2.43.7



