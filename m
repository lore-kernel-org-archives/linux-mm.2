Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 532ADC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE396B00F1; Wed, 29 Jul 2026 10:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78C296B00F5; Wed, 29 Jul 2026 10:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B256B00F4; Wed, 29 Jul 2026 10:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CB636B00F1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:19:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2152160652
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:23 +0000 (UTC)
X-FDA: 85041119646.01.E685469
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D1C8C0006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNFxwWHt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785313282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W893krPc0AXQpSx9lYC/hJjwOMLibvVHw5zRQS1r/aU=;
	b=MIOAT22hMABmZBsV94C0bPnzMcVWIupWcqvzuOGll4VkQOUaSFHCTbZyD9GYrSUdl3fTQt
	Rj5wV6IdXPN0jmnaMGi0kpDI7hZ/J6odEN4Cof1mYOZFYlZk+gDgAvP44+oap8D2X1L+wn
	8Jsu5bf6Wm95EXXBiBAkMbCUW8HMJBY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNFxwWHt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785313282;
	b=ZgsYcPrDRtkQ93OXeaZT2Wz+pc4cha72L/WtZO36tEDDqzErUj8IgflVTKVL1h5BxKwMQZ
	uofpThxRzQxQIWqvwFvDg3B3wnGCK5AOESZwW8Nz91mWlGXOLDoiyOsa9iW/Y4pyODkSgv
	0l2lul1FngDG7Ck0+uUrpTcNJKuoiMc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6ADD64334F;
	Wed, 29 Jul 2026 08:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18FC1F00A3A;
	Wed, 29 Jul 2026 08:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785313281;
	bh=W893krPc0AXQpSx9lYC/hJjwOMLibvVHw5zRQS1r/aU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bNFxwWHtjlfTN3xGLbKjn81lza9feeWLZQ+UaRB3QiqrIi/IfVUHZFK8lWBflg72E
	 Q+MQohfUHj2ZL3uxXquQyBDXJ/iVVhkXf9rgxqhihfea9GXLKlNrqw4/0oA+HgVDYT
	 JFcQlAnBH41SOzjZEJrfKKJ8Lhv9fnDVZ9PF7vcSz7rMR8biido6f96epXxVtt3cn+
	 79KahsG+5sGFLemIOvrGRYy3ZlLL6BljB7laCWIxrunOPtx6KpW14vyDbEzXeiJrQh
	 HtZH6rkS5rxATBwVW2DpUmqEI2tASrFuayodrj91MGvDp0iBLvuecg3EaQn+uRbOka
	 GvQH6BMjnP8nQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 29 Jul 2026 17:20:12 +0900
Subject: [PATCH v5 4/8] mm/slab: extend deferred free mechanism to handle
 rcu sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-kfree_rcu_nolock-v5-4-a28cdcda9673@kernel.org>
References: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
In-Reply-To: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>, 
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org, 
 "Harry Yoo (Oracle)" <harry@kernel.org>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D1C8C0006
X-Rspam-User: 
X-Stat-Signature: snwingzejze3kurzpq8b5oq4y9rmd9mi
X-HE-Tag: 1785313281-731449
X-HE-Meta: U2FsdGVkX19p4buz0SgLSFAzItBmLf1LEq8LYmcNRZ1brIFQt6qBufyHwl6u/vayChULX1aGoCR6PIcTiwICqUX4hMHZS/sT1TJ0OBg4Rrtq6YNDq94KoXX63rByPuqBOEWBJ7+UBe7JsN8G5EoEC9/Cs8OHqufmhxMCBcuXfCAfosY+S70VQdfEADgLSmiRX3hecqyCG6I7lANQmdvpOXufxkCkCk8N+lz4ZCg26Bu7/2o62W5FEygcW9YFVemRPFPQ2sLLhrQSPnOma0wiDpdHuw6RPh2E8Hatu/ndE6D1ayO8gdxyQn9kCqNYe9AAFFW9UJGlSloNx7i3hUEj/MMDhPlb5IfQVZ05bC7VQ3X0z0llEmHbxyTLxBJi71HLilqWNzQRmhxYDahnRT/cw23Z6zw5+CDi6htiXKkHihr/2CP0eK0peBiz2UYJeehZPxj2jMJVUVcWQwxzXYEjK4+EMAF/9wlkSPx9NAWin7FOYZwUjG8pS5OOhqNwL/bwKwA1FWGdxCOjUJYWO9pW0g5SAwPK6PQPyJ5FXXeyXA0zIGG2b2hKmthgmGntdMwowJQ/FApLCdMKbiC8vW5sc0698StuQ6jrCmGg+XFpJJLkjkA/HkOJrQ7MqGEFm6Da6qC95HRI6S2BpTpoxQknEDTnb7JZ4I8UF9pZKlXLKxEjRbXhqEcYP9e7BfYS5APVT/mCpN4XjB2asilae8uw+zNBaaup9FPFBKkyGkdOKOpqcRjigu+5piFLDmE0kZjM1VqHC1wMmWFs+YYB0cL7Pl1co8IqPc/VCYJrq4KpG5MduYlRkN+zPwkir7SLKxRb35TPUBJI23X96FRw9cSZf1x4PIFkUd2j3bLtKob5K3Iv8r4z2mLol4w0zSaJKp36k11+KAFn3mz5Gm4JIK6XJx0xvSYuDk9oBNnNAn+EVdbBMfUfpVM88ynR3IEn81vmWCLHLXCX7Mk8+LmI2zj
 EuepakRH
 tLusE0K1tD/r5l9Vbc0uAcdZcKOXD8I+O+oraNo7f/n6KiHN4Q8gHMKjaJ/SRfoE79LFquFURN6XrEVjhbVxHde0qL/jyDAM/ywzEEVFSlq9Ve53rEUo2dXhHjZ2q3zNBhXYyQbveAxYNmNwbpr1w35jkGaFLVjoqHWOi9jtgz0G50dn4QU+tIF1aYyZ+JywtYT8ukY6DcoJAHwN281O/j4gCOzesHL9451ooQBBOEvABTorIWo/bHVUhLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__kfree_rcu_sheaf() cannot invoke call_rcu() when spinning is not
allowed and IRQs are disabled. To relax the limitation, extend the
deferred free fallback so that a full rcu sheaf can be submitted to
call_rcu() via the existing IRQ work.

Since the deferred mechanism does more than deferred freeing of objects,
rename the struct to deferred_percpu_work and adjust names accordingly.

When a sheaf is queued on an IRQ work, it is detached from
pcs->rcu_free but call_rcu() is not invoked until the irq_work runs.
To keep the kvfree_rcu barrier's promise, call irq_work_sync() on each
CPU before calling rcu_barrier().

In the meantime, remove the TODO item as apparently there is no simple
and effective way to achieve that. This is because, unlike sheaves,
kfree_rcu() batches objects from different caches together.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab.h        |  2 +-
 mm/slab_common.c |  7 ++---
 mm/slub.c        | 85 +++++++++++++++++++++++++++++++++-----------------------
 3 files changed, 53 insertions(+), 41 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 7e7f986b49e9..d13a0f6b7a1b 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -909,7 +909,7 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 void __check_heap_object(const void *ptr, unsigned long n,
 			 const struct slab *slab, bool to_user);
 
-void defer_free_barrier(void);
+void deferred_work_barrier(void);
 
 static inline bool slub_debug_orig_size(struct kmem_cache *s)
 {
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 42db62f3e801..d81cc2136c68 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -558,7 +558,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	}
 
 	/* Wait for deferred work from kmalloc/kfree_nolock() */
-	defer_free_barrier();
+	deferred_work_barrier();
 
 	cpus_read_lock();
 	mutex_lock(&slab_mutex);
@@ -2146,13 +2146,10 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 		cpus_read_lock();
 		flush_rcu_sheaves_on_cache(s);
 		cpus_read_unlock();
+		deferred_work_barrier();
 		rcu_barrier();
 	}
 
-	/*
-	 * TODO: Introduce a version of __kvfree_rcu_barrier() that works
-	 * on a specific slab cache.
-	 */
 	__kvfree_rcu_barrier();
 }
 EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
diff --git a/mm/slub.c b/mm/slub.c
index bb0f2975c95b..92c99ff34a2c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -423,6 +423,8 @@ struct slab_sheaf {
 	union {
 		struct rcu_head rcu_head;
 		struct list_head barn_list;
+		/* only used to defer call_rcu() in unknown context */
+		struct llist_node llnode;
 		/* only used for prefilled sheafs */
 		struct {
 			unsigned int capacity;
@@ -4095,6 +4097,20 @@ static void flush_all(struct kmem_cache *s)
 	cpus_read_unlock();
 }
 
+struct deferred_percpu_work {
+	struct llist_head objects;
+	struct llist_head rcu_sheaves;
+	struct irq_work work;
+};
+
+static void deferred_percpu_work_fn(struct irq_work *work);
+
+static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
+	.objects = LLIST_HEAD_INIT(objects),
+	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
+	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
+};
+
 static void flush_rcu_sheaf(struct work_struct *w)
 {
 	struct slub_percpu_sheaves *pcs;
@@ -4166,6 +4182,7 @@ void flush_all_rcu_sheaves(void)
 	mutex_unlock(&slab_mutex);
 	cpus_read_unlock();
 
+	deferred_work_barrier();
 	rcu_barrier();
 }
 
@@ -6157,16 +6174,6 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
 		rcu_sheaf = NULL;
 	} else {
-		/*
-		 * With !allow_spin, we might have interrupted call_rcu()'s
-		 * IRQ-disabled critical section. If IRQs are not disabled,
-		 * we know that's not the case.
-		 */
-		if (unlikely(!allow_spin && irqs_disabled())) {
-			rcu_sheaf->size--;
-			local_unlock(&s->cpu_sheaves->lock);
-			goto fail;
-		}
 		pcs->rcu_free = NULL;
 		rcu_sheaf->node = numa_node_id();
 	}
@@ -6175,8 +6182,22 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	 * we flush before local_unlock to make sure a racing
 	 * flush_all_rcu_sheaves() doesn't miss this sheaf
 	 */
-	if (rcu_sheaf)
-		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
+	if (rcu_sheaf) {
+		/*
+		 * With !allow_spin, we might have interrupted call_rcu()'s
+		 * IRQ-disabled critical section. If IRQs are not disabled,
+		 * we know that's not the case.
+		 */
+		if (unlikely(!allow_spin && irqs_disabled())) {
+			struct deferred_percpu_work *dpw;
+
+			dpw = this_cpu_ptr(&deferred_percpu_work);
+			if (llist_add(&rcu_sheaf->llnode, &dpw->rcu_sheaves))
+				irq_work_queue(&dpw->work);
+		} else {
+			call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
+		}
+	}
 
 	local_unlock(&s->cpu_sheaves->lock);
 
@@ -6375,31 +6396,21 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	}
 }
 
-struct defer_free {
-	struct llist_head objects;
-	struct irq_work work;
-};
-
-static void free_deferred_objects(struct irq_work *work);
-
-static DEFINE_PER_CPU(struct defer_free, defer_free_objects) = {
-	.objects = LLIST_HEAD_INIT(objects),
-	.work = IRQ_WORK_INIT(free_deferred_objects),
-};
-
 /*
  * In PREEMPT_RT irq_work runs in per-cpu kthread, so it's safe
  * to take sleeping spin_locks from __slab_free().
  * In !PREEMPT_RT irq_work will run after local_unlock_irqrestore().
  */
-static void free_deferred_objects(struct irq_work *work)
+static void deferred_percpu_work_fn(struct irq_work *work)
 {
-	struct defer_free *df = container_of(work, struct defer_free, work);
-	struct llist_head *objs = &df->objects;
+	struct deferred_percpu_work *dpw;
+	struct llist_head *objs, *rcu_sheaves;
 	struct llist_node *llnode, *pos, *t;
+	struct slab_sheaf *sheaf, *next;
 
-	if (llist_empty(objs))
-		return;
+	dpw = container_of(work, struct deferred_percpu_work, work);
+	rcu_sheaves = &dpw->rcu_sheaves;
+	objs = &dpw->objects;
 
 	llnode = llist_del_all(objs);
 	llist_for_each_safe(pos, t, llnode) {
@@ -6423,27 +6434,31 @@ static void free_deferred_objects(struct irq_work *work)
 		__slab_free(s, slab, x, x, 1, _THIS_IP_);
 		stat(s, FREE_SLOWPATH);
 	}
+
+	llnode = llist_del_all(rcu_sheaves);
+	llist_for_each_entry_safe(sheaf, next, llnode, llnode)
+		call_rcu(&sheaf->rcu_head, rcu_free_sheaf);
 }
 
 static void defer_free(struct kmem_cache *s, void *head)
 {
-	struct defer_free *df;
+	struct deferred_percpu_work *dpw;
 
 	guard(preempt)();
 
 	head = kasan_reset_tag(head);
 
-	df = this_cpu_ptr(&defer_free_objects);
-	if (llist_add(head + s->offset, &df->objects))
-		irq_work_queue(&df->work);
+	dpw = this_cpu_ptr(&deferred_percpu_work);
+	if (llist_add(head + s->offset, &dpw->objects))
+		irq_work_queue(&dpw->work);
 }
 
-void defer_free_barrier(void)
+void deferred_work_barrier(void)
 {
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		irq_work_sync(&per_cpu_ptr(&defer_free_objects, cpu)->work);
+		irq_work_sync(&per_cpu_ptr(&deferred_percpu_work, cpu)->work);
 }
 
 static __fastpath_inline

-- 
2.53.0


