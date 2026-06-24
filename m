Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2F2ACDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4516B008A; Wed, 24 Jun 2026 09:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3757F6B008C; Wed, 24 Jun 2026 09:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BE66B0092; Wed, 24 Jun 2026 09:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA4046B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:12:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 872AB1A0309
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:12:10 +0000 (UTC)
X-FDA: 84914844420.10.ADE8D80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C99B9A0005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:12:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cRDmLMFL;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782306728;
	b=ATX9OAWzZ9xFVl0Gw2UFJGd/1Ose7PpJI52+/NIfn3PO9DnuaCsr1GeeOiYFv0m3wXddH+
	KM+iV15gRtFwJUHbFETEUo4stN3FpXKsnt0jTW/lCjrKztUyI7TD3D0ZHPx6mi8Pgaiavq
	ucHkZAX1hHUKBeRZz3K7fX9yDm8m2rI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782306728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9Sz4g8DRTMzN+c2HzV4SHb1s9SDfxqT7aAYZmS3o8M=;
	b=6mh/V75qqtOImzUc/vFECVnzRm62TMtVXpW9R5Utywpe6u9A/oyFCg7X4SxO0W1qLN694z
	CeSo70EiNZyxddE10GlnIVVpErdkE9q4zHOMlQVy0J7Hr47q8hg4WJ572Q7px8wJzhO6DC
	65ZTCksrvJR1vR72hrY0HvtBHSETKtU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cRDmLMFL;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD7B5415FD;
	Wed, 24 Jun 2026 13:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65E41F00A3A;
	Wed, 24 Jun 2026 13:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782306727;
	bh=p9Sz4g8DRTMzN+c2HzV4SHb1s9SDfxqT7aAYZmS3o8M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cRDmLMFLdsEEOk1HgcrUPYgfXy2J0WVajmVYeSPtRIhlSocPvOSqdG6Ravz8Njok+
	 zA2dzg2BeNbjfWRyt9krdYrkKwwgRm8t7w4yIe+9/gs9ffVjea0tjeolyLDCCpJJyR
	 DdmL6mUohi8/pFWGRk45vuJ+RbPrHgHRSr1DQ42xn0+8RWhFaWq63XoX/n5UmwzSNq
	 Ilq1lc2i48TkqDQw3h270CSyIUPct9xQCBKaY6Dp+ligFYI+HlZSDXxs1BxjNIPn4Y
	 apVn5JRfBVwqM7vYEgspmeXBG6q5zqHL3KVvsyeQ1AQokTSonVzQLfkfYWxl88GKNE
	 k1Ftt1y5BNVhA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 24 Jun 2026 22:11:38 +0900
Subject: [PATCH RFC 1/4] mm/memcontrol: do not drain objcg stock when
 spinning is not allowed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260624-kmalloc-nolock-fixes-v1-1-fdf4d17351dd@kernel.org>
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
In-Reply-To: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C99B9A0005
X-Stat-Signature: 765s9eewmsfgzju84tztcab95j8ebugj
X-HE-Tag: 1782306728-856722
X-HE-Meta: U2FsdGVkX19lNVt7NTJzWIdrQ73b3a3ZW3PnpN8uOX3EPmar0O2dcABckaOyehH/d9IX8OUuhuqWdX5L3VA9BaRhrTXfqJ3XX30G9KhXaW1uEIzVfokJhlHpKHXkJLJ4+20Zpk3M7gbrD+CbRwlVvftIqn+ey6+mM6DYoqJHQVzXmZbPBB0Gxlr189sikzLXCHgIUpM2Xu6AzNkkTmx7wz3lFhu5YqZanZibTX1ifp6/wycvFs4NxHC6SQthpwZhakq0wnA4DIwynNr2d2JEZvGHkg2MOBIFl0zcEQnMTTMIR499LjL5j8oOKGd1WzVlQnpqU+XSjd4rlcIeZwcjEy1g/kErFZ83cxM3ORrum8Udizbk1KuLmUEfDjLaTDaIdrPZg7VCIgbOg4VlMjtDej0yoX9mn78HyLH4aZmvIg6kJov1LXss4NhQVziHzMz5mjcrg+VOz/jWVSlSvNdGO1Vfe5AC1PhfWNnYia4bbGREwXpfUFWmOZsGOKrF5gyOXIhhqNp0qJOQcWBkpveNnBv/ir8ppeyWX4459QY3FwyyX4Z7zVyRs8sljzx20OZNA3Ycu0SWCZv6P/xDtIQNqulZXE9YGi1eqtTGQTizRvfe9sTZGHhl6n00NuihtAAwC9QcsmcmIQNxAsaGn5jPKjmkrJtjnb9mL26hwn6Cs5YNIylAHARR89+P+yrrcgqFmtLcNZQRf1cQoyRlkJPRJVCFSXtrM3XdYYgyXT81yQWc4JXgbRBkMcnBxBVP9hmvEU3+QxRuf85T0j6DqGhhkvnEgEIaMg7njBR/KNMxlr2KcsGErf55uZc0wuHArxWbhrceGP1rdvfTBNgg0AY1Pf/ks3agxTV8boehuUvjvHVkRsvbD4sqo+hBfXTefFUh12gPTy/7wcQY/BclSh8hu5VfVCV7vZP/XAaVNDvjbbjBOMCTaqpVwIhE33drul25GGwRyG1CZ5VZNoX1WmV
 fj/hUFbg
 I8WFoNgyhhTiSLVg50eq3Bt6UIxnsyfW0yfsfHJ9qJHukNQA0F+BQ/iOlG2IA8XaX2b4w+XXARhfjcJ/zupkAnfHsU5RtM4RBRkZeBTBMgYX+r4GBLrCpheXMsPk963Sea2Tzo/CKicJp2u/zGyDofVZ0FrfSJ/a9/XUkcqhLqIIixYadb9UPug35rxxhiRAOkEmGBYg4NYdpUPSGriXRHBOcnlml2ARU+CqOcpIrX4+bNrlGNG6SfpiKPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kmalloc_nolock() drains objcg stock, the stock might be holding
the last reference to the objcg. Since obj_cgroup_release() is a
callback for percpu refcount and does not know whether spinning is
allowed, it is not safe to invoke obj_cgroup_put().

This was caught by lockdep on PREEMPT_RT because acquiring
a sleeping lock (objcg_lock) violates lock nesting rules:

  kernel: BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
  kernel: in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1267, name: systemd-resolve
  preempt_count: 1, expected: 0
  RCU nest depth: 3, expected: 3
  6 locks held by systemd-resolve/1267:
   #0: ffff888a8165fa20 ((&pcs->lock)){+.+.}-{3:3}, at: kmem_cache_alloc_noprof+0x185/0xa20
   #1: ffffffff9658a4c0 (rcu_read_lock){....}-{1:3}, at: rt_spin_trylock+0x74/0x2a0
   #2: ffff888a81648598 ((lock)#4){+.+.}-{3:3}, at: trylock_stock+0x118/0x380
   #3: ffffffff9658a4c0 (rcu_read_lock){....}-{1:3}, at: rt_spin_trylock+0x74/0x2a0
   #4: ffffffff9658a4c0 (rcu_read_lock){....}-{1:3}, at: percpu_ref_put_many.constprop.0+0x40/0x270
   #5: ffffffff96af11d8 (objcg_lock){+.+.}-{3:3}, at: obj_cgroup_release+0x8a/0x410
  [...]
  Call Trace:
   <TASK>
   dump_stack_lvl+0x8a/0xe0
   dump_stack+0x14/0x1c
   __might_resched.cold+0x233/0x2bb
   rt_spin_lock+0xd3/0x410
   obj_cgroup_release+0x8a/0x410
   percpu_ref_put_many.constprop.0+0x226/0x270
   drain_obj_stock_slot+0x27e/0x8d0
   __refill_obj_stock+0x409/0x6d0
   __memcg_slab_post_alloc_hook+0xa45/0x1500
   __kmalloc_nolock_noprof+0x988/0xc40
   [...]

However, this is illegal in !RT kernels too because the objcg release
callback acquires a spinlock even when spinning is not allowed.

To fix this issue, fall back to atomics when the cached objcg doesn't
match, but it is unsafe to drain because spinning is not allowed.

This is expected to affect performance of kmalloc_nolock() since
it can no longer drain and refill the stock and falls back to a
per-objcg atomic counter (objcg->nr_charged_bytes).

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/memcontrol.c | 34 +++++++++++++++++++++++-----------
 mm/slab.h       |  3 ++-
 mm/slub.c       | 29 +++++++++++++++++++----------
 3 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 29390ba13baa..5bb5e75ef5b0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3316,18 +3316,19 @@ static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 static void __refill_obj_stock(struct obj_cgroup *objcg,
 			       struct obj_stock_pcp *stock,
 			       unsigned int nr_bytes,
-			       bool allow_uncharge)
+			       bool allow_uncharge,
+			       bool allow_spin)
 {
 	unsigned int nr_pages = 0;
 
-	if (!stock) {
-		nr_pages = nr_bytes >> PAGE_SHIFT;
-		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
-		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
-		goto out;
-	}
+	if (!stock)
+		goto fallback;
 
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
+		/* Not safe to drain since objcg release acquires spinlock */
+		if (unlikely(!allow_spin))
+			goto fallback;
+
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
@@ -3346,6 +3347,13 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 out:
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
+	return;
+
+fallback:
+	nr_pages = nr_bytes >> PAGE_SHIFT;
+	nr_bytes = nr_bytes & (PAGE_SIZE - 1);
+	atomic_add(nr_bytes, &objcg->nr_charged_bytes);
+	goto out;
 }
 
 static void refill_obj_stock(struct obj_cgroup *objcg,
@@ -3353,7 +3361,8 @@ static void refill_obj_stock(struct obj_cgroup *objcg,
 			     bool allow_uncharge)
 {
 	struct obj_stock_pcp *stock = trylock_stock();
-	__refill_obj_stock(objcg, stock, nr_bytes, allow_uncharge);
+	__refill_obj_stock(objcg, stock, nr_bytes, allow_uncharge,
+			   /* allow_spin = */ true);
 	unlock_stock(stock);
 }
 
@@ -3428,6 +3437,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 				  size_t size, void **p)
 {
 	size_t obj_size = obj_full_size(s);
+	bool allow_spin = alloc_flags_allow_spinning(slab_alloc_flags);
 	struct obj_cgroup *objcg;
 	struct slab *slab;
 	unsigned long off;
@@ -3497,7 +3507,8 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 				return false;
 			stock = trylock_stock();
 			if (remainder)
-				__refill_obj_stock(objcg, stock, remainder, false);
+				__refill_obj_stock(objcg, stock, remainder, false,
+						   allow_spin);
 		}
 		__account_obj_stock(objcg, stock, obj_size,
 				    slab_pgdat(slab), cache_vmstat_idx(s));
@@ -3516,7 +3527,8 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 }
 
 void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
-			    void **p, int objects, unsigned long obj_exts)
+			    void **p, int objects, unsigned long obj_exts,
+			    bool allow_spin)
 {
 	size_t obj_size = obj_full_size(s);
 
@@ -3535,7 +3547,7 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 		obj_ext->objcg = NULL;
 
 		stock = trylock_stock();
-		__refill_obj_stock(objcg, stock, obj_size, true);
+		__refill_obj_stock(objcg, stock, obj_size, true, allow_spin);
 		__account_obj_stock(objcg, stock, -obj_size,
 				    slab_pgdat(slab), cache_vmstat_idx(s));
 		unlock_stock(stock);
diff --git a/mm/slab.h b/mm/slab.h
index 281a65233795..a6b4ac298d08 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -660,7 +660,8 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 				  gfp_t flags, unsigned int slab_alloc_flags,
 				  size_t size, void **p);
 void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
-			    void **p, int objects, unsigned long obj_exts);
+			    void **p, int objects, unsigned long obj_exts,
+			    bool allow_spin);
 #endif
 
 void kvfree_rcu_cb(struct rcu_head *head);
diff --git a/mm/slub.c b/mm/slub.c
index 917635203f73..32672a92581b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2488,7 +2488,7 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
 
 static __fastpath_inline
 void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
-			  int objects)
+			  int objects, bool allow_spin)
 {
 	unsigned long obj_exts;
 
@@ -2500,7 +2500,7 @@ void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 		return;
 
 	get_slab_obj_exts(obj_exts);
-	__memcg_slab_free_hook(s, slab, p, objects, obj_exts);
+	__memcg_slab_free_hook(s, slab, p, objects, obj_exts, allow_spin);
 	put_slab_obj_exts(obj_exts);
 }
 
@@ -2575,7 +2575,7 @@ static inline bool memcg_slab_post_alloc_hook(struct kmem_cache *s,
 }
 
 static inline void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
-					void **p, int objects)
+					void **p, int objects, bool allow_spin)
 {
 }
 
@@ -2946,11 +2946,12 @@ static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
 	void **p = &sheaf->objects[0];
 	unsigned int i = 0;
 	bool pfmemalloc = false;
+	bool allow_spin = true;
 
 	while (i < sheaf->size) {
 		struct slab *slab = virt_to_slab(p[i]);
 
-		memcg_slab_free_hook(s, slab, p + i, 1);
+		memcg_slab_free_hook(s, slab, p + i, 1, allow_spin);
 		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
 
 		if (unlikely(!slab_free_hook(s, p[i], init, true))) {
@@ -6215,12 +6216,13 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	struct node_barn *barn;
 	void *remote_objects[PCS_BATCH_MAX];
 	unsigned int remote_nr = 0;
+	bool allow_spin = true;
 
 next_remote_batch:
 	while (i < size) {
 		struct slab *slab = virt_to_slab(p[i]);
 
-		memcg_slab_free_hook(s, slab, p + i, 1);
+		memcg_slab_free_hook(s, slab, p + i, 1, allow_spin);
 		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
 
 		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
@@ -6398,13 +6400,16 @@ static __fastpath_inline
 void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	       unsigned long addr)
 {
-	memcg_slab_free_hook(s, slab, &object, 1);
+	bool allow_spin = true;
+
+	memcg_slab_free_hook(s, slab, &object, 1, allow_spin);
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
 	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
 		return;
 
-	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, object, true)))
+	if (likely(can_free_to_pcs(slab)) &&
+			likely(free_to_pcs(s, object, allow_spin)))
 		return;
 
 	__slab_free(s, slab, object, object, 1, addr);
@@ -6429,7 +6434,9 @@ static __fastpath_inline
 void slab_free_bulk(struct kmem_cache *s, struct slab *slab, void *head,
 		    void *tail, void **p, int cnt, unsigned long addr)
 {
-	memcg_slab_free_hook(s, slab, p, cnt);
+	bool allow_spin = true;
+
+	memcg_slab_free_hook(s, slab, p, cnt, allow_spin);
 	alloc_tagging_slab_free_hook(s, slab, p, cnt);
 	/*
 	 * With KASAN enabled slab_free_freelist_hook modifies the freelist
@@ -6734,6 +6741,7 @@ void kfree_nolock(const void *object)
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *x = (void *)object;
+	bool allow_spin = false;
 
 	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return;
@@ -6746,7 +6754,7 @@ void kfree_nolock(const void *object)
 
 	s = slab->slab_cache;
 
-	memcg_slab_free_hook(s, slab, &x, 1);
+	memcg_slab_free_hook(s, slab, &x, 1, allow_spin);
 	alloc_tagging_slab_free_hook(s, slab, &x, 1);
 	/*
 	 * Unlike slab_free() do NOT call the following:
@@ -6776,7 +6784,8 @@ void kfree_nolock(const void *object)
 	 */
 	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
 
-	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, x, false)))
+	if (likely(can_free_to_pcs(slab)) &&
+			likely(free_to_pcs(s, x, allow_spin)))
 		return;
 
 	/*

-- 
2.53.0


