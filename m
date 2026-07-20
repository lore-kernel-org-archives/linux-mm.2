Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA23CC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41966B00A3; Mon, 20 Jul 2026 08:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0F16B00A4; Mon, 20 Jul 2026 08:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0D46B00A5; Mon, 20 Jul 2026 08:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B61DB6B00A3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:45:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 463F6160166
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:45:54 +0000 (UTC)
X-FDA: 85009127028.08.721746A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A12B24000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:45:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZFj+X6YN;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ra4Fb4kdhCfFUfu58piVrVDiMeFaEqKjymoRqiTdUjg=;
	b=T18cW8G2oFYXTH5K6IuoUSRjweaayMPcNcdsX0eCA3wNeEhul7+B3Sg+IiLLNIj8QAJc4v
	v8DIU96PxpZtn1odJat45SiYl98OR78YUKQ5DuHHnRGH7q+dT3uKrm5GQjEFMInfUorV4i
	ukhAw2B3l/2UpxIHoZSjz06oRwZ1jkk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZFj+X6YN;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551552;
	b=X0vhaBYX6COoAllviaujAs/xKn7CJkjpO8jvxRO46Ui1pkz5JmDy2/ZTsRrk8u2Fbw/4Yr
	/cO01XMi/ya8dZ3p5KDarYkgOtJUcyEj/xSEdWZFTrbK6AJvDBJHXi0uqTeWMm4PjvfHqK
	vvMHHuM7w+gMx/pguxV2RtL2l+9TlFQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32CE760A94;
	Mon, 20 Jul 2026 12:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0909D1F00A3E;
	Mon, 20 Jul 2026 12:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551551;
	bh=Ra4Fb4kdhCfFUfu58piVrVDiMeFaEqKjymoRqiTdUjg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZFj+X6YNmvcSASRoE+QeBprhXOaKzVYC2OqVlhXlhv6dQ1ZN0TmnjT540pnjBbT7y
	 PfPqWq/JnZ3IbEMSUhjw9rYzuEufryOAzk46N7JDsG4kGg2pfUjhwWbR9Qa810QNb1
	 CiqLX9XqfQvaM9+/uhOEOAFBiAYI9zcrb9czKW0Ny4phm+IaWp8AAKuGLZvBpZm5nE
	 du4DwRjr+IbDnjrcXk0Os6YR7QEc/l5IZqXl+dEeEMZ29iMWXchp/wcPn6hQ0j4P3X
	 qyYO7jdNW5gsa7+kXPYp9JvJyZ9Oq1dEk88i2vCWyVmlZtrvlkGEJxBW9FOsuTr5LZ
	 vvFsJtpotgL8g==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 20 Jul 2026 21:44:33 +0900
Subject: [PATCH slab/for-next v4 4/8] mm/slab: extend deferred free
 mechanism to handle rcu sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kfree_rcu_nolock-v4-4-964e03c41a4e@kernel.org>
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
In-Reply-To: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
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
X-Rspamd-Queue-Id: A12B24000B
X-Rspam-User: 
X-Stat-Signature: xrwfbzn36pgi4pnbcsixeapbudbmtew9
X-Rspamd-Server: rspam04
X-HE-Tag: 1784551552-380978
X-HE-Meta: U2FsdGVkX1/uS/LaeMDqgsIE2dm9j/yFAFIEnLRQHboOwzOKYjqPk9vBqQkwGbsQdz5yx+KWiSTCAmuEcrBvoYVsFScO0Yz2BYdineFb0c3wJMSyoE0d5rxWV9uED7rKzIPENHUxmq5Up4EfPpDi03vZ79TEG8Vxb/dl5tbyTLF4opi1wcU63FaOKiRgtEhXPOR6a8PwKGBFvraKt1yXUpqnGP8XZnGf3vCKDFjlNM83dTIk7F7SsJsMPRuvJ59/cug8/texdJbffdoSmZIiwo9PAzkj4KW4ganl9lx80RF+SsG8hcmDCHALjcsXi7nfQtm7BjXrCyqePtCAlp+tTFS35EaJRr6wCwLxbJlT8LF1+/oHQXlOc8wWsBxIG0FYKv78XrGl0T5JPtTrGccnEEDo6aEB+AqMf8KmgghwNgT3TQ7vXGJPNjCGCnTOMjwBQ7+ZhJW0+CQ+NCN6ajqluaLZSKXX7E0ftVVD0auI6ot5h/mLW+ut9pqbfgWvuCs5mqGadn1iTGaKoJ4vEggy3rIPgaYgdNTX9MoPXWU8KVml+EJckNGrc1GED92yXWkYSdX38GfHWfY81jvQyvTMsqOxlDkvzHTfD+glgwWzdtckpMpzkzC5jC5WrCe26hLI/RqpMg2jx0S7WSbr9zxW9IkWkVXASwSKRWfUNnDIrCs/DxFH4b1cu2bRi3gIDy1f6oXO5di6WAYsD/EpsWsf5E40znoeCHKtzb3uDV/VaB+U19+7vh2lgJVM3xlYhXi59aMNB8KIqYZB6wK3/zK/cUx/njkzf7hG/0LkAWHlvRfnrpPDTqndAvitnlG2suw2gke4+fB5ThTRCpTdgydxErFHHNaXJbe7vwYL0holHfPfcSBty3X+W9hAQ+WKa949H/7SXvmWZvbw7f5YDKuQ7G0isGttfcqEEdu/x6h2C1SWoH87iJja2VWAe5OCGkmvDk1tMWJBj2jxF3/+meq
 SlcvoKLS
 Ggiq351/BFp89NBJ6RLNZWLZiEm05dpyrrYZRLt9ZvEQxAFWOWeTTRvTR/vcpzgc0koBY/qmZ4d33aQ1DTu3IrRDup/URfeiSQ7o3EIVqdx003yLVY3xBlzRrPF8n/e7rdU/IYhzwLtt5hPtnVp7PYVt6ctH3a559uQ7ndXq7O14UkgrqzosvS0vKbo80RHDgnaGCGDs7lGjNL5GoBMjsmIeyivuysCdLNY2HS8MBzyQBzyl6YDBuzyB5Lg==
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
index 85ef2ebc9812..fdd293b3efa5 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -760,7 +760,7 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 void __check_heap_object(const void *ptr, unsigned long n,
 			 const struct slab *slab, bool to_user);
 
-void defer_free_barrier(void);
+void deferred_work_barrier(void);
 
 static inline bool slub_debug_orig_size(struct kmem_cache *s)
 {
diff --git a/mm/slab_common.c b/mm/slab_common.c
index e07b4e6d6679..9c9ae1384f47 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -551,7 +551,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	}
 
 	/* Wait for deferred work from kmalloc/kfree_nolock() */
-	defer_free_barrier();
+	deferred_work_barrier();
 
 	cpus_read_lock();
 	mutex_lock(&slab_mutex);
@@ -2113,13 +2113,10 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
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
index 680fe64aff72..8afa6b47b1f2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -418,6 +418,8 @@ struct slab_sheaf {
 	union {
 		struct rcu_head rcu_head;
 		struct list_head barn_list;
+		/* only used to defer call_rcu() in unknown context */
+		struct llist_node llnode;
 		/* only used for prefilled sheafs */
 		struct {
 			unsigned int capacity;
@@ -4077,6 +4079,20 @@ static void flush_all(struct kmem_cache *s)
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
@@ -4148,6 +4164,7 @@ void flush_all_rcu_sheaves(void)
 	mutex_unlock(&slab_mutex);
 	cpus_read_unlock();
 
+	deferred_work_barrier();
 	rcu_barrier();
 }
 
@@ -6136,16 +6153,6 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
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
@@ -6154,8 +6161,22 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
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
 
@@ -6354,31 +6375,21 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
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
@@ -6402,27 +6413,31 @@ static void free_deferred_objects(struct irq_work *work)
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


