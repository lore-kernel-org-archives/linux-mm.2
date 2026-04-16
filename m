Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7073F8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26DBE6B0092; Thu, 16 Apr 2026 05:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F6D6B0093; Thu, 16 Apr 2026 05:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DB26B0095; Thu, 16 Apr 2026 05:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3B926B0092
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:10:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B95EF1B89E8
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:43 +0000 (UTC)
X-FDA: 84663848766.14.F61238B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 254A320008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BltT+P1f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330642; a=rsa-sha256;
	cv=none;
	b=jf3uAVRxmJgQKi4nT8LpgtCsfGL69c8dryYbVt/IyDPa3Q72zd/S/kwCaIuFFjwuARq6PJ
	hMdoY7euxKTV7Hw1cM9184A2DTFJNksOd1g4wyXEzR/eAOUk/FUIdAmZLliF+2s6M2RbPP
	LugSRWeiKt+CWbf/snojaoF0ZajReNw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BltT+P1f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzr1FHGXBmpXmNHBeA5gcG3d5MnqsvdBp1eL/Rto0sc=;
	b=dmQ6fMnXalsCTAkPQIMF/8+ey0mG7pBY7P0xAtiGiOmVrWrmQFzGxNW/BJQ7LIshZNA4Op
	14MKrfqlQLhFh3bkDjb1aZE9+jW0RKt7hj1yvY3fwBmUSD8J6v3w7/gF4C3GkpjuZVgoJT
	/2W4dwX0qf5DRmHbfHo1lyJwyoZXvZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 945F16012B;
	Thu, 16 Apr 2026 09:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EABC2BCB3;
	Thu, 16 Apr 2026 09:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330641;
	bh=1wWCQajAmDNFIPGcLcw1fThpNhEPA03pbQWZsydCisA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BltT+P1fLncrc60+k0VQFixqk/e9eH7Wx2RJksgqPLf+iQoUsYCXOC4QktOYmmSOS
	 TFRQtYoSLSIagpAr5JkLLzYxwxe5WSYQRV8PvYLs+sRI/wph8qBnupjmhkxCoxn+G0
	 Z2y7VDnmow2JsX4tBxBhJnYznhGadxyfz3P4aaotW+HMDIUG0dvsBoKOLfFvRfEASd
	 hQNo1h6CckhzPZqiZtkg3Z9HRTfw3ydckDU3khg2dCMKXznIRZiBDBlN2TOFKvMazq
	 4mjh43GH3HJL8Iz9VgNSFvpHyodI5Af0fJQK9ce87lzpJT3sl1bYATP7QrUvPeBVhp
	 jqi+2akXuoFAw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Date: Thu, 16 Apr 2026 18:10:18 +0900
Message-ID: <20260416091022.36823-5-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260416091022.36823-1-harry@kernel.org>
References: <20260416091022.36823-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: xk3k55u839455hrnibaut85y1wpezibg
X-Rspam-User: 
X-Rspamd-Queue-Id: 254A320008
X-HE-Tag: 1776330642-296910
X-HE-Meta: U2FsdGVkX19w51iIu3GZVv6iAbSdGGCxHo2nQ26xwaQoZSkhVpDAredRLaveRFuBWZJriWmwX58mLYKd6sgNOzSHJifOgEn7OX4UgShEY/SoCyLhHhyEAUajZAeA616zVhYBT2zJrxUlAm0YExtHz2XSPw+N62HVV1JxzyK7/7CJGrdVio/I085+yCsWsTUiBOMnHOWgDWTq/YtRhcI3hUYrN4Ypg/6fep1cYuFpfFT8H70vjR1e5q6z48FsR/k2d0ldgpYga7shmmxHd7IBjxF8Ioj53jgsd5+o2kWaYyONOgVDe5WTp1T2qLfK2u0nM/cwARm7R+EWjDW0b8a2bEzPJQ/aFF9Av3u0O0Ogvd8J+dH4RJ7mMBd/FSUKGVKhrxW2ToVmwPVY4cTIfJD44vh1+PfxhKTG4qaGkqGbP9Ay3uLxcoeWKf918fdU4f5wz5hw7mSm3p5XBUtsatZ6IkZ/8M9qi4oRYAABFdhYZIMESO7jS9PgekV8RhsRCKpXGWWFD0JlWvWBbYThvqX7awD6pXW8/Pnv9219ewEzkWDTJ+OJjN41ARW/nRts4EcEDie3WwiaJtCrcHQKFkfqLbt0e27qDZLSUvMzInYdvO8D/yeVqKViaeOq44FOMTtqodZ30VNt/ws/2jVQ4rUK14yaMDBRnUzVtmTJMLqy3qLlXvfmQEwUlrNRj3vY1dtjaMRFIj+nVjlJfUL9DacHEr4Z+R3QWN6dReOfQHNPUm6+xGQIjZ7aOl7jAGCTjDNa5i/N0b0qpneSXVlCUN5kD1yxjTVzT1dicPz0JkNYwtrOj7DVxaqSv2CNDpQRGE4EtZRauw2DAEVZGG1YR3oC4S3zfB0afx7jKgFgWtIZuOZ4fkua6KnKR/bjgaFM/L1q0esrN7x2V4yPIZc1nQZUl6Z/ZSH2/VPgBuXx66We1cXqhK4xQi/2XF20z5MvPbnG5aPRJNZ+QbydPetmohv
 gk7DYbfR
 QxZi5KR+Uo2em/Kjv2/BUH+vLY7vhzWvklT1IxfvelKB1aeZAkj8NtmyTT75yOEppfsDXjpAvNPNEEwArkcZ2F1LVLHeCFyYLiqNWyVE3S+7235+t1ITuKVb0D7lVT9xZp9B0N1Z7Sd6ZvkNT34lRUhltCxuCobTEBDykKL2tAftecMkHvcaCFi6CNq5yFrOPSiJT3NZHt9e/jAOZEZsOx6veWCZ5YeIeMNfdfYpR+mShPg2Nfv5duKtqG2oLK34qZaUypNNGutHdLM1V/Mg4DX6zG+rlkttWG6md
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, kfree_rcu() cannot be called when the context is unknown,
which might not allow spinning on a lock. In such an unknown
context, even calling call_rcu() is not legal, forcing users to
implement some sort of deferred freeing.

Make users' lives easier by introducing kfree_rcu_nolock() variant.
It passes allow_spin = false to kvfree_call_rcu(), which means spinning
on a lock is not allowed because the context is unknown.

Unlike kfree_rcu(), kfree_rcu_nolock() only supports a 2-argument
variant because, in the worst case where memory allocation fails,
the caller cannot synchronously wait for the grace period to finish.

kfree_rcu_nolock() tries to acquire kfree_rcu_cpu spinlock.
When trylock succeeds, get a cached bnode and use it to store the
pointer. Just like existing kvfree_rcu() with 2-arg variant, fall back
if there's no cached bnode available.

If trylock fails, insert the object to the per-cpu lockless list
and defer freeing using irq_work that calls kvfree_call_rcu() later.
Note that in the most of the cases the context allows spinning,
and thus it is worth trying to acquire the lock.

To ensure rcu sheaves are flushed in flush_rcu_all_sheaves() and
flush_rcu_sheaves_on_cache(), deferred objects must be processed before
calling them. Otherwise, irq work might insert objects to a sheaf and
end up not flushing it. Implement a defer_kvfree_rcu_barrier() and
call it before flushing rcu sheaves.

In case kmemleak or debug objects is enabled, always defer freeing as
those debug features use spinlocks.

Determine whether work items (page cache worker or delayed monitor) need
to be queued under krcp->lock. If so, use irq_work to defer the actual
work submission. The existing logic prevents excessive irq_work
queueing.

For now, the sheaves layer is bypassed if spinning is not allowed.

Without CONFIG_KVFREE_RCU_BATCHED, all frees in the !allow_spin case are
deferred using irq_work. Move kvfree_rcu_barrier[_on_cache]() to
mm/slab_common.c and let them wait for irq_works.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 include/linux/rcupdate.h |  23 ++--
 include/linux/slab.h     |  16 +--
 mm/slab.h                |   1 +
 mm/slab_common.c         | 260 +++++++++++++++++++++++++++++++--------
 mm/slub.c                |   6 +-
 5 files changed, 231 insertions(+), 75 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3ca82500a19f..8776b2a394bb 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1090,8 +1090,9 @@ static inline void rcu_read_unlock_migrate(void)
  * The BUILD_BUG_ON check must not involve any function calls, hence the
  * checks are done in macros here.
  */
-#define kfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
-#define kvfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
+#define kfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf, true)
+#define kfree_rcu_nolock(ptr, rf) kvfree_rcu_arg_2(ptr, rf, false)
+#define kvfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf, true)
 
 /**
  * kfree_rcu_mightsleep() - kfree an object after a grace period.
@@ -1115,35 +1116,35 @@ static inline void rcu_read_unlock_migrate(void)
 
 
 #ifdef CONFIG_KVFREE_RCU_BATCHED
-void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr);
-#define kvfree_call_rcu(head, ptr) \
+void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin);
+#define kvfree_call_rcu(head, ptr, spin) \
 	_Generic((head), \
 		struct rcu_head *: kvfree_call_rcu_ptr,		\
 		struct rcu_ptr *: kvfree_call_rcu_ptr,		\
 		void *: kvfree_call_rcu_ptr			\
-	)((struct rcu_ptr *)(head), (ptr))
+	)((struct rcu_ptr *)(head), (ptr), spin)
 #else
-void kvfree_call_rcu_head(struct rcu_head *head, void *ptr);
+void kvfree_call_rcu_head(struct rcu_head *head, void *ptr, bool allow_spin);
 static_assert(sizeof(struct rcu_head) == sizeof(struct rcu_ptr));
-#define kvfree_call_rcu(head, ptr) \
+#define kvfree_call_rcu(head, ptr, spin) \
 	_Generic((head), \
 		struct rcu_head *: kvfree_call_rcu_head,	\
 		struct rcu_ptr *: kvfree_call_rcu_head,		\
 		void *: kvfree_call_rcu_head			\
-	)((struct rcu_head *)(head), (ptr))
+	)((struct rcu_head *)(head), (ptr), spin)
 #endif
 
 /*
  * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
  * comment of kfree_rcu() for details.
  */
-#define kvfree_rcu_arg_2(ptr, rf)					\
+#define kvfree_rcu_arg_2(ptr, rf, spin)					\
 do {									\
 	typeof (ptr) ___p = (ptr);					\
 									\
 	if (___p) {							\
 		BUILD_BUG_ON(offsetof(typeof(*(ptr)), rf) >= 4096);	\
-		kvfree_call_rcu(&((___p)->rf), (void *) (___p));	\
+		kvfree_call_rcu(&((___p)->rf), (void *) (___p), spin);	\
 	}								\
 } while (0)
 
@@ -1152,7 +1153,7 @@ do {								\
 	typeof(ptr) ___p = (ptr);				\
 								\
 	if (___p)						\
-		kvfree_call_rcu(NULL, (void *) (___p));		\
+		kvfree_call_rcu(NULL, (void *) (___p), true);	\
 } while (0)
 
 /*
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 15a60b501b95..67528f698fe2 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1238,23 +1238,13 @@ extern void kvfree_sensitive(const void *addr, size_t len);
 
 unsigned int kmem_cache_size(struct kmem_cache *s);
 
-#ifndef CONFIG_KVFREE_RCU_BATCHED
-static inline void kvfree_rcu_barrier(void)
-{
-	rcu_barrier();
-}
-
-static inline void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
-{
-	rcu_barrier();
-}
-
-static inline void kfree_rcu_scheduler_running(void) { }
-#else
 void kvfree_rcu_barrier(void);
 
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s);
 
+#ifndef CONFIG_KVFREE_RCU_BATCHED
+static inline void kfree_rcu_scheduler_running(void) { }
+#else
 void kfree_rcu_scheduler_running(void);
 #endif
 
diff --git a/mm/slab.h b/mm/slab.h
index c735e6b4dddb..ae2e990e8dc2 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -412,6 +412,7 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
 void flush_all_rcu_sheaves(void);
 void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
+void defer_kvfree_rcu_barrier(void);
 
 #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
diff --git a/mm/slab_common.c b/mm/slab_common.c
index cddbf3279c13..e840956233dd 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1311,6 +1311,14 @@ struct kfree_rcu_cpu_work {
  * the interactions with the slab allocators.
  */
 struct kfree_rcu_cpu {
+	// Objects queued on a lockless linked list, used to free objects
+	// in unknown contexts when trylock fails.
+	struct llist_head defer_head;
+
+	struct irq_work defer_free;
+	struct irq_work sched_delayed_monitor;
+	struct irq_work run_page_cache_worker;
+
 	// Objects queued on a linked list
 	struct rcu_ptr *head;
 	unsigned long head_gp_snap;
@@ -1333,12 +1341,99 @@ struct kfree_rcu_cpu {
 	struct llist_head bkvcache;
 	int nr_bkv_objs;
 };
+
+static void defer_kfree_rcu_irq_work_fn(struct irq_work *work);
+static void sched_delayed_monitor_irq_work_fn(struct irq_work *work);
+static void run_page_cache_worker_irq_work_fn(struct irq_work *work);
+
+static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
+	.lock = __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
+	.defer_head = LLIST_HEAD_INIT(defer_head),
+	.defer_free = IRQ_WORK_INIT(defer_kfree_rcu_irq_work_fn),
+	.sched_delayed_monitor =
+		IRQ_WORK_INIT_LAZY(sched_delayed_monitor_irq_work_fn),
+	.run_page_cache_worker =
+		IRQ_WORK_INIT_LAZY(run_page_cache_worker_irq_work_fn),
+};
+#else
+struct kfree_rcu_cpu {
+	struct llist_head defer_head;
+	struct irq_work defer_free;
+};
+
+static void defer_kfree_rcu_irq_work_fn(struct irq_work *work);
+
+static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
+	.defer_head = LLIST_HEAD_INIT(defer_head),
+	.defer_free = IRQ_WORK_INIT(defer_kfree_rcu_irq_work_fn),
+};
 #endif
 
-#ifndef CONFIG_KVFREE_RCU_BATCHED
+/* Wait for deferred work from kfree_rcu_nolock() */
+void defer_kvfree_rcu_barrier(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		irq_work_sync(&per_cpu_ptr(&krc, cpu)->defer_free);
+}
+
+static void *object_start_addr(void *ptr)
+{
+	struct slab *slab;
+	void *start;
+
+	if (is_vmalloc_addr(ptr)) {
+		start  = (void *)PAGE_ALIGN_DOWN((unsigned long)ptr);
+	} else {
+		slab = virt_to_slab(ptr);
+		if (!slab)
+			start = (void *)PAGE_ALIGN_DOWN((unsigned long)ptr);
+		else if (is_kfence_address(ptr))
+			start = kfence_object_start(ptr);
+		else
+			start = nearest_obj(slab->slab_cache, slab, ptr);
+	}
 
-void kvfree_call_rcu_head(struct rcu_head *head, void *ptr)
+	return start;
+}
+
+static void defer_kfree_rcu_irq_work_fn(struct irq_work *work)
 {
+	struct kfree_rcu_cpu *krcp;
+	struct llist_head *head;
+	struct llist_node *llnode, *pos, *t;
+
+	krcp = container_of(work, struct kfree_rcu_cpu, defer_free);
+	head = &krcp->defer_head;
+
+	if (llist_empty(head))
+		return;
+
+	llnode = llist_del_all(head);
+	llist_for_each_safe(pos, t, llnode) {
+		void *objp;
+		struct rcu_ptr *rcup = (struct rcu_ptr *)pos;
+
+		objp = object_start_addr(rcup);
+		kvfree_call_rcu(rcup, objp, true);
+	}
+}
+
+#ifndef CONFIG_KVFREE_RCU_BATCHED
+void kvfree_call_rcu_head(struct rcu_head *head, void *ptr, bool allow_spin)
+{
+	if (!allow_spin) {
+		struct kfree_rcu_cpu *krcp;
+
+		guard(preempt)();
+
+		krcp = this_cpu_ptr(&krc);
+		if (llist_add((struct llist_node *)head, &krcp->defer_head))
+			irq_work_queue(&krcp->defer_free);
+		return;
+	}
+
 	if (head) {
 		kasan_record_aux_stack(ptr);
 		call_rcu(head, kvfree_rcu_cb);
@@ -1356,6 +1451,19 @@ void __init kvfree_rcu_init(void)
 {
 }
 
+void kvfree_rcu_barrier(void)
+{
+	defer_kvfree_rcu_barrier();
+	rcu_barrier();
+}
+EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
+
+void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
+{
+	kvfree_rcu_barrier();
+}
+EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
+
 #else /* CONFIG_KVFREE_RCU_BATCHED */
 
 /*
@@ -1405,9 +1513,16 @@ struct kvfree_rcu_bulk_data {
 #define KVFREE_BULK_MAX_ENTR \
 	((PAGE_SIZE - sizeof(struct kvfree_rcu_bulk_data)) / sizeof(void *))
 
-static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
-	.lock = __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
-};
+
+static void schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp);
+
+static void sched_delayed_monitor_irq_work_fn(struct irq_work *work)
+{
+	struct kfree_rcu_cpu *krcp;
+
+	krcp = container_of(work, struct kfree_rcu_cpu, sched_delayed_monitor);
+	schedule_delayed_monitor_work(krcp);
+}
 
 static __always_inline void
 debug_rcu_bhead_unqueue(struct kvfree_rcu_bulk_data *bhead)
@@ -1421,13 +1536,18 @@ debug_rcu_bhead_unqueue(struct kvfree_rcu_bulk_data *bhead)
 }
 
 static inline struct kfree_rcu_cpu *
-krc_this_cpu_lock(unsigned long *flags)
+krc_this_cpu_lock(unsigned long *flags, bool allow_spin)
 {
 	struct kfree_rcu_cpu *krcp;
 
 	local_irq_save(*flags);	// For safely calling this_cpu_ptr().
 	krcp = this_cpu_ptr(&krc);
-	raw_spin_lock(&krcp->lock);
+	if (allow_spin) {
+		raw_spin_lock(&krcp->lock);
+	} else if (!raw_spin_trylock(&krcp->lock)) {
+		local_irq_restore(*flags);
+		return NULL;
+	}
 
 	return krcp;
 }
@@ -1531,20 +1651,8 @@ kvfree_rcu_list(struct rcu_ptr *head)
 	for (; head; head = next) {
 		void *ptr;
 		unsigned long offset;
-		struct slab *slab;
-
-		if (is_vmalloc_addr(head)) {
-			ptr = (void *)PAGE_ALIGN_DOWN((unsigned long)head);
-		} else {
-			slab = virt_to_slab(head);
-			if (!slab)
-				ptr = (void *)PAGE_ALIGN_DOWN((unsigned long)head);
-			else if (is_kfence_address(head))
-				ptr = kfence_object_start(head);
-			else
-				ptr = nearest_obj(slab->slab_cache, slab, head);
-		}
 
+		ptr = object_start_addr(head);
 		offset = (void *)head - ptr;
 		next = head->next;
 		debug_rcu_head_unqueue((struct rcu_head *)ptr);
@@ -1663,18 +1771,26 @@ static int krc_count(struct kfree_rcu_cpu *krcp)
 }
 
 static void
-__schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp)
+__schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp, bool allow_spin)
 {
 	long delay, delay_left;
 
 	delay = krc_count(krcp) >= KVFREE_BULK_MAX_ENTR ? 1:KFREE_DRAIN_JIFFIES;
 	if (delayed_work_pending(&krcp->monitor_work)) {
 		delay_left = krcp->monitor_work.timer.expires - jiffies;
-		if (delay < delay_left)
-			mod_delayed_work(rcu_reclaim_wq, &krcp->monitor_work, delay);
+		if (delay < delay_left) {
+			if (allow_spin)
+				mod_delayed_work(rcu_reclaim_wq, &krcp->monitor_work, delay);
+			else
+				irq_work_queue(&krcp->sched_delayed_monitor);
+		}
 		return;
 	}
-	queue_delayed_work(rcu_reclaim_wq, &krcp->monitor_work, delay);
+
+	if (allow_spin)
+		queue_delayed_work(rcu_reclaim_wq, &krcp->monitor_work, delay);
+	else
+		irq_work_queue(&krcp->sched_delayed_monitor);
 }
 
 static void
@@ -1683,7 +1799,7 @@ schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&krcp->lock, flags);
-	__schedule_delayed_monitor_work(krcp);
+	__schedule_delayed_monitor_work(krcp, true);
 	raw_spin_unlock_irqrestore(&krcp->lock, flags);
 }
 
@@ -1847,25 +1963,25 @@ static void fill_page_cache_func(struct work_struct *work)
 // Returns true if ptr was successfully recorded, else the caller must
 // use a fallback.
 static inline bool
-add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu **krcp,
-	unsigned long *flags, void *ptr, bool can_alloc)
+add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu *krcp,
+	unsigned long *flags, void *ptr, bool can_alloc, bool allow_spin)
 {
 	struct kvfree_rcu_bulk_data *bnode;
 	int idx;
 
-	*krcp = krc_this_cpu_lock(flags);
-	if (unlikely(!(*krcp)->initialized))
+	if (unlikely(!krcp->initialized))
 		return false;
 
 	idx = !!is_vmalloc_addr(ptr);
-	bnode = list_first_entry_or_null(&(*krcp)->bulk_head[idx],
+	bnode = list_first_entry_or_null(&krcp->bulk_head[idx],
 		struct kvfree_rcu_bulk_data, list);
 
 	/* Check if a new block is required. */
 	if (!bnode || bnode->nr_records == KVFREE_BULK_MAX_ENTR) {
-		bnode = get_cached_bnode(*krcp);
+		bnode = get_cached_bnode(krcp);
 		if (!bnode && can_alloc) {
-			krc_this_cpu_unlock(*krcp, *flags);
+			krc_this_cpu_unlock(krcp, *flags);
+			VM_WARN_ON_ONCE(!allow_spin);
 
 			// __GFP_NORETRY - allows a light-weight direct reclaim
 			// what is OK from minimizing of fallback hitting point of
@@ -1880,7 +1996,7 @@ add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu **krcp,
 			// scenarios.
 			bnode = (struct kvfree_rcu_bulk_data *)
 				__get_free_page(GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
-			raw_spin_lock_irqsave(&(*krcp)->lock, *flags);
+			raw_spin_lock_irqsave(&krcp->lock, *flags);
 		}
 
 		if (!bnode)
@@ -1888,14 +2004,14 @@ add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu **krcp,
 
 		// Initialize the new block and attach it.
 		bnode->nr_records = 0;
-		list_add(&bnode->list, &(*krcp)->bulk_head[idx]);
+		list_add(&bnode->list, &krcp->bulk_head[idx]);
 	}
 
 	// Finally insert and update the GP for this page.
 	bnode->nr_records++;
 	bnode->records[bnode->nr_records - 1] = ptr;
 	get_state_synchronize_rcu_full(&bnode->gp_snap);
-	atomic_inc(&(*krcp)->bulk_count[idx]);
+	atomic_inc(&krcp->bulk_count[idx]);
 
 	return true;
 }
@@ -1911,7 +2027,32 @@ schedule_page_work_fn(struct hrtimer *t)
 }
 
 static void
-run_page_cache_worker(struct kfree_rcu_cpu *krcp)
+__run_page_cache_worker(struct kfree_rcu_cpu *krcp)
+{
+	if (atomic_read(&krcp->backoff_page_cache_fill)) {
+		queue_delayed_work(rcu_reclaim_wq,
+			&krcp->page_cache_work,
+				msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
+	} else {
+		hrtimer_setup(&krcp->hrtimer, schedule_page_work_fn, CLOCK_MONOTONIC,
+			      HRTIMER_MODE_REL);
+		hrtimer_start(&krcp->hrtimer, 0, HRTIMER_MODE_REL);
+	}
+}
+
+static void run_page_cache_worker_irq_work_fn(struct irq_work *work)
+{
+	unsigned long flags;
+	struct kfree_rcu_cpu *krcp =
+		container_of(work, struct kfree_rcu_cpu, run_page_cache_worker);
+
+	raw_spin_lock_irqsave(&krcp->lock, flags);
+	__run_page_cache_worker(krcp);
+	raw_spin_unlock_irqrestore(&krcp->lock, flags);
+}
+
+static void
+run_page_cache_worker(struct kfree_rcu_cpu *krcp, bool allow_spin)
 {
 	// If cache disabled, bail out.
 	if (!rcu_min_cached_objs)
@@ -1919,15 +2060,10 @@ run_page_cache_worker(struct kfree_rcu_cpu *krcp)
 
 	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
 			!atomic_xchg(&krcp->work_in_progress, 1)) {
-		if (atomic_read(&krcp->backoff_page_cache_fill)) {
-			queue_delayed_work(rcu_reclaim_wq,
-				&krcp->page_cache_work,
-					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
-		} else {
-			hrtimer_setup(&krcp->hrtimer, schedule_page_work_fn, CLOCK_MONOTONIC,
-				      HRTIMER_MODE_REL);
-			hrtimer_start(&krcp->hrtimer, 0, HRTIMER_MODE_REL);
-		}
+		if (allow_spin)
+			__run_page_cache_worker(krcp);
+		else
+			irq_work_queue(&krcp->run_page_cache_worker);
 	}
 }
 
@@ -1955,7 +2091,7 @@ void __init kfree_rcu_scheduler_running(void)
  * be free'd in workqueue context. This allows us to: batch requests together to
  * reduce the number of grace periods during heavy kfree_rcu()/kvfree_rcu() load.
  */
-void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
+void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin)
 {
 	unsigned long flags;
 	struct kfree_rcu_cpu *krcp;
@@ -1971,7 +2107,12 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
 	if (!head)
 		might_sleep();
 
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+	if (!allow_spin && (IS_ENABLED(CONFIG_DEBUG_OBJECTS_RCU_HEAD) ||
+				IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)))
+		goto defer_free;
+
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
+			(allow_spin && kfree_rcu_sheaf(ptr)))
 		return;
 
 	// Queue the object but don't yet schedule the batch.
@@ -1985,9 +2126,14 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
 	}
 
 	kasan_record_aux_stack(ptr);
-	success = add_ptr_to_bulk_krc_lock(&krcp, &flags, ptr, !head);
+
+	krcp = krc_this_cpu_lock(&flags, allow_spin);
+	if (!krcp)
+		goto defer_free;
+
+	success = add_ptr_to_bulk_krc_lock(krcp, &flags, ptr, !head, allow_spin);
 	if (!success) {
-		run_page_cache_worker(krcp);
+		run_page_cache_worker(krcp, allow_spin);
 
 		if (head == NULL)
 			// Inline if kvfree_rcu(one_arg) call.
@@ -2012,7 +2158,7 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
 
 	// Set timer to drain after KFREE_DRAIN_JIFFIES.
 	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING)
-		__schedule_delayed_monitor_work(krcp);
+		__schedule_delayed_monitor_work(krcp, allow_spin);
 
 unlock_return:
 	krc_this_cpu_unlock(krcp, flags);
@@ -2023,10 +2169,22 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
 	 * CPU can pass the QS state.
 	 */
 	if (!success) {
+		VM_WARN_ON_ONCE(!allow_spin);
 		debug_rcu_head_unqueue((struct rcu_head *) ptr);
 		synchronize_rcu();
 		kvfree(ptr);
 	}
+	return;
+
+defer_free:
+	VM_WARN_ON_ONCE(allow_spin);
+	guard(preempt)();
+
+	krcp = this_cpu_ptr(&krc);
+	if (llist_add((struct llist_node *)head, &krcp->defer_head))
+		irq_work_queue(&krcp->defer_free);
+	return;
+
 }
 EXPORT_SYMBOL_GPL(kvfree_call_rcu_ptr);
 
@@ -2125,6 +2283,8 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
  */
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
+	defer_kvfree_rcu_barrier();
+
 	if (cache_has_sheaves(s)) {
 		flush_rcu_sheaves_on_cache(s);
 		rcu_barrier();
diff --git a/mm/slub.c b/mm/slub.c
index 92362eeb13e5..6f658ec00751 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4018,7 +4018,10 @@ static void flush_rcu_sheaf(struct work_struct *w)
 }
 
 
-/* needed for kvfree_rcu_barrier() */
+/*
+ * Needed for kvfree_rcu_barrier(). The caller should invoke
+ * defer_kvfree_rcu_barrier() before calling this function.
+ */
 void flush_rcu_sheaves_on_cache(struct kmem_cache *s)
 {
 	struct slub_flush_work *sfw;
@@ -4053,6 +4056,7 @@ void flush_all_rcu_sheaves(void)
 {
 	struct kmem_cache *s;
 
+	defer_kvfree_rcu_barrier();
 	cpus_read_lock();
 	mutex_lock(&slab_mutex);
 
-- 
2.43.0


