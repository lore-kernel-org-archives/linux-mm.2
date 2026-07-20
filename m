Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D0A0C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640CB6B00A9; Mon, 20 Jul 2026 08:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F0DA6B00AA; Mon, 20 Jul 2026 08:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF966B00AB; Mon, 20 Jul 2026 08:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD656B00A9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:46:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE228140168
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:46:12 +0000 (UTC)
X-FDA: 85009127784.30.93A0812
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0025CC000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:46:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RX13nvMZ;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tR+P/h2nByeigiwGZHMwdsEAW1PKLC/u8oNgU53PQWs=;
	b=xeCFGPr4L/8yZqMbnbdSD63dv8ZYXv282NE1GwTpe76kthk2A5CFQJRzHg2ku/gaSkL5R+
	oBhPyTt9rOOVkr2My1+k1WG9FDCszZ4BFnHO9fIn3vpTCiLwA+wTG8RwIPI8m9/qY27Nop
	H5iiNLbo9VIXraAtIvM34XjyG4ppFpo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551571;
	b=jhjPNKeMl3kthm6Ys040oZLVUmM4ZbBeiUzAUyJWv06EGFOAXghzdkQp91K/UBjSzwsQC+
	Fx4eH/zUV4ndJgSrOjZDKDnR3EWOLiISinGn51bLJOAL3d0sL5SUjnSFa10QR2bAboLxE8
	uTyQc/iTqpgy6momnaSpEddLya6md9s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RX13nvMZ;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44FE440987;
	Mon, 20 Jul 2026 12:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A73C1F000E9;
	Mon, 20 Jul 2026 12:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551570;
	bh=tR+P/h2nByeigiwGZHMwdsEAW1PKLC/u8oNgU53PQWs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RX13nvMZggBA2+prEs/70znjmQ6xnGVlj01nl2N3late5GXTZ5ldIXKVfpeO6FGOE
	 uq6jE4Bg7233yFmRNr5Ym/MJa6QAdPWAdEZjhnXlyPZdkCs4lvAA5gAD23Z0RnM6/m
	 Nlz8B5WZYRksPbohtdp2ggK6YFe047r9lQmhgkI4eN3xS/o90+1/2tvU/Y7gw5AuUO
	 ZhBgS6EfD+AmWhLkvMDkDJJqnJB7WkKhoDv5sRz4JEg7AeP6AdUdYCtgXynth9HjFw
	 XwJQcb9Gr2ThOYi4o5aQDyO7CfHbABRCDCMUhkifAUdxdiTCcQuJ4zi6m/ruUZ2Egj
	 OLZYyrMO5zOzA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 20 Jul 2026 21:44:36 +0900
Subject: [PATCH slab/for-next v4 7/8] mm/slab: introduce kfree_rcu_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kfree_rcu_nolock-v4-7-964e03c41a4e@kernel.org>
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
X-Rspamd-Queue-Id: 0025CC000B
X-Stat-Signature: qts7s37q5o7817bts8nyhib3w5qbxiqz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784551570-354652
X-HE-Meta: U2FsdGVkX18cxTfGH1iYRWRz17v7AWVzV2licYcq9DnxsbzSkSdp+72938iOAdd1Irfn3BXR94lIzQIFJJmqCi3hftlJlFrVtNNn6nhAnV3nELUT89PaeYdKekHRSiqzMUk7mVICJMUnxjT76KkfQ+Pw1ID7AUBGIJLi494MK+1d11eGbgZyuQLUfpkLkLGpuKIzjhLKqiUm3wHZVeKOJUB3Vjqv1o+xivHta0/3kQ5tnudkmpBfCZAPnyR8hUO53X1TDpnEzz0CimNQqfzS3jEIMKlTHjdYVKavB0BfqBmjWeMh9RL/hGJSfiXGohhtEbgr4UAQ2D/LH6pcsmbV1+coL48gwiEMfPMQwqskD6eHLOJ6wEVqzUxh/uKNpHhFqfN46ZlyKoKjKnw2FbF2JtfpsV/Y1d6lLlni7Ppt6oxT3Fl/IDu/I+rSDJTk2g8BpJ7E+zw2QHQKnEBm759TKMk6nin1+J0x+u2FuS2LWC/y8GhKsEu/uej8iy3Tgqik3BGs+O0wc1oFS9KeEIlYi8P2vk4H6SBiT00h7QiGypvDISPGEVlfsbPFhwgq7ekGS5Z1GB5xtWUOSZLSMIHaOHMT1rxSOJKIhAffCKfZSW4fKCGhD5W97aXsIs8U7/l4/7EWbE7fYgOHfUgxcE7p1SGvgktS4R6hIF5ZVkm709hSEDDv6kv8joTV0ITsKpEvV4HdTSRbNU4tTa2wv1o428x5BHC0wTuni9INCmMIT2UuPIlmNASWUyybCnaLg6rnqmR5oIBP0rKmHz35VGR1Nkaxdr8UgA7QrrdfPLVRs4vLdlsmSY8Xp8HSGCtoJ0E3w/jDIe2p2PaHD/RfbvNPzskVQtkaqah6A0Wi3LnQI+iGZjAu0/StRPJ27ac/HaRaXKzXjS5OVVq5KUEAIBS498m2j8Jb29xO6gxqxn3dGDchfyLVxFAmbvX0qoTdEEO7oA9fArnlGwwC9JQBHKt
 K07ewYYd
 KXcxZc6EjZjSal7Ky/fA75RiCi0Pt0qt/cDHab1/8vZed7Q+fLtmskJKJ7vHdvnqDfzqOC4/DEHO+5+qAsxRKf2fkT/2Trbm86pdYcMUIy7pU3QEKwn4QJtrf2IAszH7u7JAWhu5G0zpKPt1pGibI32vYy+5kwQoVYMSHe1E/e0S4LWXyQKJ2jpe/teqOCDg4d7wKtp7Ro5TEsm4Efx7Mw8yjfn8Z+J1KqUr5tpiopPy/QUX78Z6rWTgKbrAjFZG8AbFt86yEYV/+q1Mg29N38KrMURA+m4g0YOGfTZK1sJUN/m4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, k[v]free_rcu() cannot be called in unknown context since
it could lead to a deadlock when called in the middle of k[v]free_rcu().

Make users' lives easier by introducing kfree_rcu_nolock() variant,
now that kfree_rcu_sheaf() is available on PREEMPT_RT and
__kfree_rcu_sheaf() handles unknown context.

kfree_rcu_nolock() falls back to the kvfree_rcu batching when sheaves
path fails. In most cases, the sheaves path is expected to succeed
and it's unnecessary to add complexity to the existing kvfree_rcu
batching by teaching it how to handle unknown context.

Since defer_kfree_rcu() can be called on caches without sheaves, move
deferred_work_barrier() and rcu_barrier() outside the branch in
kvfree_rcu_barrier_on_cache().

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 include/linux/rcupdate.h | 19 +++++++++++++++++++
 mm/slab_common.c         | 28 ++++++++++++++++++++++++++--
 mm/slub.c                | 24 +++++++++++++++++++++++-
 3 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ef5bb6981133..ce0fd401352e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1099,6 +1099,7 @@ static inline void rcu_read_unlock_migrate(void)
  * In mm/slab_common.c, no suitable header to include here.
  */
 void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr);
+void kfree_call_rcu_nolock(struct kvfree_rcu_head *head, void *ptr);
 
 /*
  * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
@@ -1124,6 +1125,24 @@ do {								\
 		kvfree_call_rcu(NULL, (void *) (___p));		\
 } while (0)
 
+/**
+ * kfree_rcu_nolock() - a version of kfree_rcu() that can be called in any context.
+ * @ptr: pointer to kfree for double-argument invocations.
+ * @kvrhf: the name of the struct kvfree_rcu_head within the type of @ptr.
+ *
+ * Objects that are not allocated via kmalloc_nolock() are not supported.
+ * kfree_rcu_nolock() supports 2-arg variant only.
+ */
+#define kfree_rcu_nolock(ptr, kvrhf)						\
+do {										\
+	typeof (ptr) ___p = (ptr);						\
+										\
+	if (___p) {								\
+		BUILD_BUG_ON(offsetof(typeof(*(ptr)), kvrhf) >= 4096);		\
+		kfree_call_rcu_nolock(&((___p)->kvrhf), (void *) (___p));	\
+	}									\
+} while (0)
+
 /*
  * Place this after a lock-acquisition primitive to guarantee that
  * an UNLOCK+LOCK pair acts as a full barrier.  This guarantee applies
diff --git a/mm/slab_common.c b/mm/slab_common.c
index c1c32909fa52..09c457645e03 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1263,6 +1263,29 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
 EXPORT_TRACEPOINT_SYMBOL(kfree);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
 
+void kfree_call_rcu_nolock(struct kvfree_rcu_head *head, void *ptr)
+{
+	struct slab *slab;
+	struct kmem_cache *s;
+
+	VM_WARN_ON_ONCE(is_vmalloc_addr(ptr) || !virt_to_slab(ptr));
+
+	slab = virt_to_slab(ptr);
+	s = slab->slab_cache;
+
+	if (unlikely(IS_ENABLED(CONFIG_NUMA) && slab_nid(slab) != numa_mem_id()))
+		goto fallback;
+
+	if (unlikely(!__kfree_rcu_sheaf(s, ptr, SLAB_FREE_NOLOCK)))
+		goto fallback;
+
+	return;
+
+fallback:
+	defer_kfree_rcu(head);
+}
+EXPORT_SYMBOL_GPL(kfree_call_rcu_nolock);
+
 #ifndef CONFIG_KVFREE_RCU_BATCHED
 
 void kvfree_call_rcu(struct rcu_head *head, void *ptr)
@@ -2120,10 +2143,11 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 		cpus_read_lock();
 		flush_rcu_sheaves_on_cache(s);
 		cpus_read_unlock();
-		deferred_work_barrier();
-		rcu_barrier();
 	}
 
+	/* kfree_rcu_nolock() might have deferred frees even without sheaves */
+	deferred_work_barrier();
+	rcu_barrier();
 	__kvfree_rcu_barrier();
 }
 EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
diff --git a/mm/slub.c b/mm/slub.c
index d0976396d703..7114451dd5d0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4081,6 +4081,7 @@ static void flush_all(struct kmem_cache *s)
 
 struct deferred_percpu_work {
 	struct llist_head objects;
+	struct llist_head objects_by_rcu;
 	struct llist_head rcu_sheaves;
 	struct irq_work work;
 };
@@ -4089,6 +4090,7 @@ static void deferred_percpu_work_fn(struct irq_work *work);
 
 static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
 	.objects = LLIST_HEAD_INIT(objects),
+	.objects_by_rcu = LLIST_HEAD_INIT(objects_by_rcu),
 	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
 	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
 };
@@ -6386,13 +6388,14 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 static void deferred_percpu_work_fn(struct irq_work *work)
 {
 	struct deferred_percpu_work *dpw;
-	struct llist_head *objs, *rcu_sheaves;
+	struct llist_head *objs, *objs_by_rcu, *rcu_sheaves;
 	struct llist_node *llnode, *pos, *t;
 	struct slab_sheaf *sheaf, *next;
 
 	dpw = container_of(work, struct deferred_percpu_work, work);
 	rcu_sheaves = &dpw->rcu_sheaves;
 	objs = &dpw->objects;
+	objs_by_rcu = &dpw->objects_by_rcu;
 
 	llnode = llist_del_all(objs);
 	llist_for_each_safe(pos, t, llnode) {
@@ -6417,6 +6420,14 @@ static void deferred_percpu_work_fn(struct irq_work *work)
 		stat(s, FREE_SLOWPATH);
 	}
 
+	llnode = llist_del_all(objs_by_rcu);
+	llist_for_each_safe(pos, t, llnode) {
+		void *head = pos;
+		void *objp = kvmalloc_obj_start_addr(head);
+
+		kvfree_call_rcu(head, objp);
+	}
+
 	llnode = llist_del_all(rcu_sheaves);
 	llist_for_each_entry_safe(sheaf, next, llnode, llnode)
 		call_rcu(&sheaf->rcu_head, rcu_free_sheaf);
@@ -6435,6 +6446,17 @@ static void defer_free(struct kmem_cache *s, void *head)
 		irq_work_queue(&dpw->work);
 }
 
+void defer_kfree_rcu(struct kvfree_rcu_head *head)
+{
+	struct deferred_percpu_work *dpw;
+
+	guard(preempt)();
+
+	dpw = this_cpu_ptr(&deferred_percpu_work);
+	if (llist_add((struct llist_node *)head, &dpw->objects_by_rcu))
+		irq_work_queue(&dpw->work);
+}
+
 void deferred_work_barrier(void)
 {
 	int cpu;

-- 
2.53.0


