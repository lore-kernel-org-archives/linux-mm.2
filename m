Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 609C3D625E5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD78D6B03FA; Fri, 23 Jan 2026 01:53:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B987D6B03FC; Fri, 23 Jan 2026 01:53:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12526B03FD; Fri, 23 Jan 2026 01:53:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 913046B03FA
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D0C1C076D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:26 +0000 (UTC)
X-FDA: 84362312412.10.0E6472B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C7431C0005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5LUNr88zjhX+hkWnDoeUdsyPIuhpIM8czLHZWHOSyuc=;
	b=SuOGWOXevvjxwRAD977sjpUJS7MaG8qPkUJVNYJI7y+pHDpYnqD/k1kLuKg4LlEAubXQ3l
	rGwEvBD2i6I7ftdKJtTMlO7k+JB1ru2QUNeeb51q9phQ6O4goDjfEsEvOfTrwpf/xVEln5
	nyenLv03YxRyIi1Ey3/f5JVdn28+k/4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151204; a=rsa-sha256;
	cv=none;
	b=cnA8V8E6p4mxHwsxqtSIjkmw6O96WW1dRy0dLKJnwO2LlOHeHG10PqX/OMD2M0/vzCYZNt
	biP1MjOxIEP+XWj/xT/vcdqeCp/by1Qk16uZvwoeABw+iV+L9G0MeUyXPsEz0tLU9nLhqx
	rIv0X8esOj+a+eQxuqgbnQOzv4BiQ+k=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B6AB33376B;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBC35139EE;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GAx4MdUac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:45 +0100
Subject: [PATCH v4 07/22] slab: introduce percpu sheaves bootstrap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-7-041323d506f7@suse.cz>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2C7431C0005
X-Stat-Signature: jw59e9tndiz4kyk5pkxcn18j7a8ufno4
X-Rspam-User: 
X-HE-Tag: 1769151203-489514
X-HE-Meta: U2FsdGVkX18PIBICVBZnWXOGpGYuHUCD621DutcyVOxHeUi+TdcQ/bUNAVzpLOzkkk7SBKWp6+HTdiE3lWMKaMRw5oYLvGaA2ErElvFGV4YuMcK9NyE8xz/qSvdKbvqiH7vRn7SsTP6TG9o0KWOJV9iIYCreM98FwcmeGt4U/E8DahU1v27IZhnIVtUiPuEpXgehzAqMlDkXKe9yWhBtOBnvkrvurr3kDCLHRcjTNM7Fg7HqXdV/KtauEH+z2c/C3QCMaZ6DtkGbGuPOSZPCc1jJqyQzuOsoFgMtLZQEbijEv+Tn6F+yZGpxYq6F0N8AvBB2RtAqX8ItgWVZDrvpULU1hS4j23mq6Hm+430wcoaLek2wT6WHWCY9V6O8RkYU51zS3326EyC2RETXvnLwSI3rXgf/uixmFTi1/IQDps1Jvnm4dUWn5SF4e8w8Uv4CUQisYQHM1EwsHuTbwBzrlTAbwrwxjqXIzlIwtwtjK3PQLVaBttMZSkAcRJpg8ETkPy+DQ83XnSJrEo8IKnRWbSuMJnh11+qV/Cv0LApFYAzHz1HaDZlO9q3xEERbMJ7833Op1OEHYR3NbeEX1SqqLsMAZzxpnuF4oaMcNWZbWAaBwx5W9t2ALdK2sG9LtRdgAqrvbNk7egzKO8f59AgJF8nBpiLEsxq3TOy52ijAfe+fOZCmCz3A3G6kSXMgfLFhCUoutsJT6DP5BJyBsB8eHMnoLT+99+3Ix2/1CoLq0qINGaLP1foWAs33kdwEE3i26GspBbXXKrxkrNSZyKI7D/yaSAPT/v4lpl03rxESqlxKrsZkk5ZkZAynV7iqfJeFUcG2u7NbjBIYoaoBodI3KtId4UXbh2L1NEQC8X+S7Ujtp8RlKxt7K12jTiUNj6STM8i/JSM56tBaVylJWYjFlmjGmNQjAq67hLvUXxXaNe7DSFUQkiZr/CiCEIvTykT1x3looiY0V9dy8O5RIsK
 QUn10em2
 Zl7xbwjVx4MqSAQvPMvQI0muG/m9qMDCsJsYCftk4S609ne41qMeNujbDWhOE23cZSRPpYwbhV1iJ7FN7t/zC9Lq2n+8zb/x4yx9jxgPpyV8BlG8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Until now, kmem_cache->cpu_sheaves was !NULL only for caches with
sheaves enabled. Since we want to enable them for almost all caches,
it's suboptimal to test the pointer in the fast paths, so instead
allocate it for all caches in do_kmem_cache_create(). Instead of testing
the cpu_sheaves pointer to recognize caches (yet) without sheaves, test
kmem_cache->sheaf_capacity for being 0, where needed, using a new
cache_has_sheaves() helper.

However, for the fast paths sake we also assume that the main sheaf
always exists (pcs->main is !NULL), and during bootstrap we cannot
allocate sheaves yet.

Solve this by introducing a single static bootstrap_sheaf that's
assigned as pcs->main during bootstrap. It has a size of 0, so during
allocations, the fast path will find it's empty. Since the size of 0
matches sheaf_capacity of 0, the freeing fast paths will find it's
"full". In the slow path handlers, we use cache_has_sheaves() to
recognize that the cache doesn't (yet) have real sheaves, and fall back.
Thus sharing the single bootstrap sheaf like this for multiple caches
and cpus is safe.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h        |  12 ++++++
 mm/slab_common.c |   2 +-
 mm/slub.c        | 123 ++++++++++++++++++++++++++++++++++++-------------------
 3 files changed, 95 insertions(+), 42 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index cb48ce5014ba..a20a6af6e0ef 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -277,6 +277,18 @@ struct kmem_cache {
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };
 
+/*
+ * Every cache has !NULL s->cpu_sheaves but they may point to the
+ * bootstrap_sheaf temporarily during init, or permanently for the boot caches
+ * and caches with debugging enabled, or all caches with CONFIG_SLUB_TINY. This
+ * helper distinguishes whether cache has real non-bootstrap sheaves.
+ */
+static inline bool cache_has_sheaves(struct kmem_cache *s)
+{
+	/* Test CONFIG_SLUB_TINY for code elimination purposes */
+	return !IS_ENABLED(CONFIG_SLUB_TINY) && s->sheaf_capacity;
+}
+
 #if defined(CONFIG_SYSFS) && !defined(CONFIG_SLUB_TINY)
 #define SLAB_SUPPORTS_SYSFS 1
 void sysfs_slab_unlink(struct kmem_cache *s);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 5c15a4ce5743..8d0d6b0cb896 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2163,7 +2163,7 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
  */
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
-	if (s->cpu_sheaves) {
+	if (cache_has_sheaves(s)) {
 		flush_rcu_sheaves_on_cache(s);
 		rcu_barrier();
 	}
diff --git a/mm/slub.c b/mm/slub.c
index 594f5fac39b3..41e1bf35707c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2846,12 +2846,23 @@ static void pcs_destroy(struct kmem_cache *s)
 {
 	int cpu;
 
+	/*
+	 * We may be unwinding cache creation that failed before or during the
+	 * allocation of this.
+	 */
+	if (!s->cpu_sheaves)
+		return;
+
+	/* pcs->main can only point to the bootstrap sheaf, nothing to free */
+	if (!cache_has_sheaves(s))
+		goto free_pcs;
+
 	for_each_possible_cpu(cpu) {
 		struct slub_percpu_sheaves *pcs;
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-		/* can happen when unwinding failed create */
+		/* This can happen when unwinding failed cache creation. */
 		if (!pcs->main)
 			continue;
 
@@ -2873,6 +2884,7 @@ static void pcs_destroy(struct kmem_cache *s)
 		}
 	}
 
+free_pcs:
 	free_percpu(s->cpu_sheaves);
 	s->cpu_sheaves = NULL;
 }
@@ -4030,7 +4042,7 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
 {
 	struct slub_percpu_sheaves *pcs;
 
-	if (!s->cpu_sheaves)
+	if (!cache_has_sheaves(s))
 		return false;
 
 	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
@@ -4052,7 +4064,7 @@ static void flush_cpu_slab(struct work_struct *w)
 
 	s = sfw->s;
 
-	if (s->cpu_sheaves)
+	if (cache_has_sheaves(s))
 		pcs_flush_all(s);
 
 	flush_this_cpu_slab(s);
@@ -4157,7 +4169,7 @@ void flush_all_rcu_sheaves(void)
 	mutex_lock(&slab_mutex);
 
 	list_for_each_entry(s, &slab_caches, list) {
-		if (!s->cpu_sheaves)
+		if (!cache_has_sheaves(s))
 			continue;
 		flush_rcu_sheaves_on_cache(s);
 	}
@@ -4179,7 +4191,7 @@ static int slub_cpu_dead(unsigned int cpu)
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
 		__flush_cpu_slab(s, cpu);
-		if (s->cpu_sheaves)
+		if (cache_has_sheaves(s))
 			__pcs_flush_all_cpu(s, cpu);
 	}
 	mutex_unlock(&slab_mutex);
@@ -4979,6 +4991,12 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
+	/* Bootstrap or debug cache, back off */
+	if (unlikely(!cache_has_sheaves(s))) {
+		local_unlock(&s->cpu_sheaves->lock);
+		return NULL;
+	}
+
 	if (pcs->spare && pcs->spare->size > 0) {
 		swap(pcs->main, pcs->spare);
 		return pcs;
@@ -5165,6 +5183,11 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		struct slab_sheaf *full;
 		struct node_barn *barn;
 
+		if (unlikely(!cache_has_sheaves(s))) {
+			local_unlock(&s->cpu_sheaves->lock);
+			return allocated;
+		}
+
 		if (pcs->spare && pcs->spare->size > 0) {
 			swap(pcs->main, pcs->spare);
 			goto do_alloc;
@@ -5244,8 +5267,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	if (s->cpu_sheaves)
-		object = alloc_from_pcs(s, gfpflags, node);
+	object = alloc_from_pcs(s, gfpflags, node);
 
 	if (!object)
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
@@ -5353,18 +5375,10 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 	struct slab_sheaf *sheaf = NULL;
 	struct node_barn *barn;
 
-	if (unlikely(size > s->sheaf_capacity)) {
+	if (unlikely(!size))
+		return NULL;
 
-		/*
-		 * slab_debug disables cpu sheaves intentionally so all
-		 * prefilled sheaves become "oversize" and we give up on
-		 * performance for the debugging. Same with SLUB_TINY.
-		 * Creating a cache without sheaves and then requesting a
-		 * prefilled sheaf is however not expected, so warn.
-		 */
-		WARN_ON_ONCE(s->sheaf_capacity == 0 &&
-			     !IS_ENABLED(CONFIG_SLUB_TINY) &&
-			     !(s->flags & SLAB_DEBUG_FLAGS));
+	if (unlikely(size > s->sheaf_capacity)) {
 
 		sheaf = kzalloc(struct_size(sheaf, objects, size), gfp);
 		if (!sheaf)
@@ -6082,6 +6096,12 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
 restart:
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
+	/* Bootstrap or debug cache, back off */
+	if (unlikely(!cache_has_sheaves(s))) {
+		local_unlock(&s->cpu_sheaves->lock);
+		return NULL;
+	}
+
 	barn = get_barn(s);
 	if (!barn) {
 		local_unlock(&s->cpu_sheaves->lock);
@@ -6295,6 +6315,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 		struct slab_sheaf *empty;
 		struct node_barn *barn;
 
+		/* Bootstrap or debug cache, fall back */
+		if (unlikely(!cache_has_sheaves(s))) {
+			local_unlock(&s->cpu_sheaves->lock);
+			goto fail;
+		}
+
 		if (pcs->spare && pcs->spare->size == 0) {
 			pcs->rcu_free = pcs->spare;
 			pcs->spare = NULL;
@@ -6691,9 +6717,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
 		return;
 
-	if (s->cpu_sheaves && likely(!IS_ENABLED(CONFIG_NUMA) ||
-				     slab_nid(slab) == numa_mem_id())
-			   && likely(!slab_test_pfmemalloc(slab))) {
+	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
+	    && likely(!slab_test_pfmemalloc(slab))) {
 		if (likely(free_to_pcs(s, object)))
 			return;
 	}
@@ -7396,7 +7421,7 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 	 * freeing to sheaves is so incompatible with the detached freelist so
 	 * once we go that way, we have to do everything differently
 	 */
-	if (s && s->cpu_sheaves) {
+	if (s && cache_has_sheaves(s)) {
 		free_to_pcs_bulk(s, size, p);
 		return;
 	}
@@ -7507,8 +7532,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 		size--;
 	}
 
-	if (s->cpu_sheaves)
-		i = alloc_from_pcs_bulk(s, size, p);
+	i = alloc_from_pcs_bulk(s, size, p);
 
 	if (i < size) {
 		/*
@@ -7719,6 +7743,7 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 
 static int init_percpu_sheaves(struct kmem_cache *s)
 {
+	static struct slab_sheaf bootstrap_sheaf = {};
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
@@ -7728,7 +7753,28 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 
 		local_trylock_init(&pcs->lock);
 
-		pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
+		/*
+		 * Bootstrap sheaf has zero size so fast-path allocation fails.
+		 * It has also size == s->sheaf_capacity, so fast-path free
+		 * fails. In the slow paths we recognize the situation by
+		 * checking s->sheaf_capacity. This allows fast paths to assume
+		 * s->cpu_sheaves and pcs->main always exists and are valid.
+		 * It's also safe to share the single static bootstrap_sheaf
+		 * with zero-sized objects array as it's never modified.
+		 *
+		 * Bootstrap_sheaf also has NULL pointer to kmem_cache so we
+		 * recognize it and not attempt to free it when destroying the
+		 * cache.
+		 *
+		 * We keep bootstrap_sheaf for kmem_cache and kmem_cache_node,
+		 * caches with debug enabled, and all caches with SLUB_TINY.
+		 * For kmalloc caches it's used temporarily during the initial
+		 * bootstrap.
+		 */
+		if (!s->sheaf_capacity)
+			pcs->main = &bootstrap_sheaf;
+		else
+			pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
 
 		if (!pcs->main)
 			return -ENOMEM;
@@ -7803,8 +7849,7 @@ static void free_kmem_cache_nodes(struct kmem_cache *s)
 void __kmem_cache_release(struct kmem_cache *s)
 {
 	cache_random_seq_destroy(s);
-	if (s->cpu_sheaves)
-		pcs_destroy(s);
+	pcs_destroy(s);
 #ifdef CONFIG_PREEMPT_RT
 	if (s->cpu_slab)
 		lockdep_unregister_key(&s->lock_key);
@@ -7826,7 +7871,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
 			continue;
 		}
 
-		if (s->cpu_sheaves) {
+		if (cache_has_sheaves(s)) {
 			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
 
 			if (!barn)
@@ -8149,7 +8194,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 	flush_all_cpus_locked(s);
 
 	/* we might have rcu sheaves in flight */
-	if (s->cpu_sheaves)
+	if (cache_has_sheaves(s))
 		rcu_barrier();
 
 	/* Attempt to free all objects */
@@ -8461,7 +8506,7 @@ static int slab_mem_going_online_callback(int nid)
 		if (get_node(s, nid))
 			continue;
 
-		if (s->cpu_sheaves) {
+		if (cache_has_sheaves(s)) {
 			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, nid);
 
 			if (!barn) {
@@ -8669,12 +8714,10 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 
 	set_cpu_partial(s);
 
-	if (s->sheaf_capacity) {
-		s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
-		if (!s->cpu_sheaves) {
-			err = -ENOMEM;
-			goto out;
-		}
+	s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
+	if (!s->cpu_sheaves) {
+		err = -ENOMEM;
+		goto out;
 	}
 
 #ifdef CONFIG_NUMA
@@ -8693,11 +8736,9 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 	if (!alloc_kmem_cache_cpus(s))
 		goto out;
 
-	if (s->cpu_sheaves) {
-		err = init_percpu_sheaves(s);
-		if (err)
-			goto out;
-	}
+	err = init_percpu_sheaves(s);
+	if (err)
+		goto out;
 
 	err = 0;
 

-- 
2.52.0


