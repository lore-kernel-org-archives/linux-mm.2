Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99337CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0783F6B00A1; Mon, 15 Jun 2026 07:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028266B00A2; Mon, 15 Jun 2026 07:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5A796B00A3; Mon, 15 Jun 2026 07:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D403C6B00A1
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:07:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98A9A1409C5
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:07:09 +0000 (UTC)
X-FDA: 84881870178.08.9C3DF42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id DB72240013
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:07:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XMv8qxXa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781521627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4UEZqgmZLkk1COBgMPnEsRLoFfhBPP6Xjsgpxi9p30=;
	b=qoxYVG+Gx2n26fIfbV2Vb6C6r32UzyCwEf+gJWCaln4ie0fsSAHLOE6YX6eK4skno9jb1M
	CyOAguQCe9Lzx3c6CVljEiA7T1YtgeH4ZbSWubgLsmW1m2VjuRlKVgStol2fGfZ9YpZZZ+
	CKiKhn/RyWqSzygLYmbgBcxUTK5a8Xs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XMv8qxXa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781521627;
	b=MYnwd6X/dCBAcFwsWhuhIFMrURrbIMyoHIol2TKnDtOR9U7ypfc8YiAhkxzc7ZR3qpbUa2
	yYSeeFqYSdut6QZ6RnFJzKRvfcZn23+mRQnxQU17nFW/2/JTfa7GlLCXwNW4fCqsMA0iEq
	YYyUOlvHPzTU+MiyZ5ZhECPH3PDZDwE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 685F86008A;
	Mon, 15 Jun 2026 11:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595581F00A3A;
	Mon, 15 Jun 2026 11:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781521627;
	bh=s4UEZqgmZLkk1COBgMPnEsRLoFfhBPP6Xjsgpxi9p30=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XMv8qxXadaOIsubxpGdBq4VrQCMdoGph28gNuR2kiIDp1l/5aYvluqd2p8MxX/jha
	 PxNi85xPi1drEsQGbyrCpIEUR42DETMbQb6W8RqCQCRudqS07/8ZCAo03bc2VuhdCJ
	 ORLn61CLc1ckWxhLAcnwXX8TdpIVsvTSlSuvSIHLfyi/XQmhcujErWRoS2K9D37a3z
	 pqSvGe7QbkwVwiCIdKPWQD74x7wBO9h88RHqePE7Q1kxBnfaWZV4ug+m1lc4gPaReK
	 fmSyZXioKWI8aZv4UIUPXbulThxSATjeJPi++ChMpOO+Bit8LWnnrEmCEYSCn8w32B
	 vKAtQKonwRE2w==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 15 Jun 2026 20:06:01 +0900
Subject: [PATCH for-next v3 7/9] mm/slab: introduce kfree_rcu_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-kfree_rcu_nolock-v3-7-70a54f3775bb@kernel.org>
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
In-Reply-To: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
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
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: t4atgk8cag1zouspnmyri4qasuny1bhn
X-Rspamd-Queue-Id: DB72240013
X-HE-Tag: 1781521627-564232
X-HE-Meta: U2FsdGVkX19EZtHv1BGtd9h//HEwqjiaqq54qdny6ywVU0c9k/ZNtfSDNTgDOseAr387ZKOGPG1B4GYO+trVSzYbL1qP00C7c4oC02XK8mx8e3V/yC5Spre/c8/F2sdgUn5utRGAduVEVu2z/FI0CNHoRSIFvAAFT2lvioCCpPGcaSDC3VyPBoUsAnhlHZKt19X9uLLAlFXbgTdjxYD1kKA88Pn/JBlfxKc9uTYidmu2xste4UysUU/xTV0n57iaN7NRh8jNaBPYQ7ePRo6bR2Zoa/LzgjvlztK1ZtO7wuDAZIddtVXS8zjZF6TGp473hYUEdyiApn+OAIfFaaIUtEMNn/gFVsym4kmSGIgMZCthmsDiQZDt6DFUTr4xc6ZE+A6B1lWuSecCMap4sDPsHUowgzQtImqWCK8UJCXyw35TsNRqM4TGxHyfAfmTWEhia7bfvagroW8mMQspCx8jysjq3s/h/zcdO0pmB2C99jeEFJZvDUHEBUyGpm90tR6msTuyURrUy9BPhBMBfEItHG2MFOahe5LauGTLyJBrawqLZlutskXAgLAi7nxZZDNTVgT83TfRzX2HElFRZrSY82Kdx6hbSidN1f+v8WQdiAt6kFYFbEGzJPSHSJmiOiSNDDdd3OmTpfuc9mqmxvO7dkws+x0fA9856qqiF2m2RRGpxubZDFkA7rd/CWSUkFGk9MeUoH6lZg3HFUQdGXn6+OExlUfbntwvejU8YipUXKUGIvv/gah7vJZ5IyEaHaN0FNzy5O1DDxeQz8wQcweAiB9swR13MJ+X+glPtHSgXdq2HqF8l//LA5GBe7h7cDxZ6R8F0jkbwmi/65rJxhj+RWfnqQkeTeVL/J+AUec3yIfLUd4sRumsSZ46UX6kvcE29xkqoipIq2JGjApvKpZqgpwF0rvuj7TEno6Ee82tlCoGZeWvnaddWxej/xMYs0yW/0LiYmzKM++gDE0z6YE
 ALCi/yLc
 Y8PMIGeUrc+SDU/cw/79Ev6K8yPmvNItk6Lp4Lt9FKoddQZ+Ks2V5gN6n6r99HtgoeaaEd8DyBxb5xq2P/XHurCC+ZMGYDqOEqZgX5tCEQkOxONYSQRKRmD0uym5iU9k0SCCaltXDQXcwTSpS2jDY5CGwTc6Td7wIG0l/g2lRzTIjmqnJmZYEVfcjLMjXqIP0+U7+WGRSvoPp8dEH/Cs8JNABBJ7ZvQ7F6yfpGESbmxzVIKWiCevkmyNCENmfK1+CGdvYgcdcNX9tklBdd2hU4GR0M+72n52C/KyC
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

Unlike k[v]free_rcu(), kfree_rcu_nolock() does not fall back to
the kvfree_rcu batching when the sheaves path fails, and falls back to
defer_kfree_rcu() instead. In most cases, the sheaves path is expected
to succeed and it's unnecessary to add complexity to the existing
kvfree_rcu batching.

Since defer_kfree_rcu() can be called on caches without sheaves, move
deferred_work_barrier() and rcu_barrier() outside the branch in
kvfree_rcu_barrier_on_cache().

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 include/linux/rcupdate.h | 12 ++++++++++++
 mm/slab.h                |  1 +
 mm/slab_common.c         | 22 ++++++++++++++++++++--
 mm/slub.c                | 23 ++++++++++++++++++++++-
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 5e95acc33989..3025249bfcb5 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1099,6 +1099,7 @@ static inline void rcu_read_unlock_migrate(void)
  * In mm/slab_common.c, no suitable header to include here.
  */
 void kvfree_call_rcu(struct rcu_head *head, void *ptr);
+void kfree_call_rcu_nolock(struct rcu_head *head, void *ptr);
 
 /*
  * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
@@ -1122,6 +1123,17 @@ do {								\
 		kvfree_call_rcu(NULL, (void *) (___p));		\
 } while (0)
 
+/* kfree_rcu_nolock() supports 2-arg variant only */
+#define kfree_rcu_nolock(ptr, krhf)					\
+do {									\
+	typeof (ptr) ___p = (ptr);					\
+									\
+	if (___p) {							\
+		BUILD_BUG_ON(offsetof(typeof(*(ptr)), krhf) >= 4096);	\
+		kfree_call_rcu_nolock(&((___p)->krhf), (void *) (___p));\
+	}								\
+} while (0)
+
 /*
  * Place this after a lock-acquisition primitive to guarantee that
  * an UNLOCK+LOCK pair acts as a full barrier.  This guarantee applies
diff --git a/mm/slab.h b/mm/slab.h
index 961581e35ec8..a493c5201e96 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -745,6 +745,7 @@ void __check_heap_object(const void *ptr, unsigned long n,
 			 const struct slab *slab, bool to_user);
 
 void deferred_work_barrier(void);
+void defer_kfree_rcu(struct rcu_head *head);
 
 static inline bool slub_debug_orig_size(struct kmem_cache *s)
 {
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 807924a94fb0..5a39e6225160 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1263,6 +1263,23 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
 EXPORT_TRACEPOINT_SYMBOL(kfree);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
 
+void kfree_call_rcu_nolock(struct rcu_head *head, void *ptr)
+{
+	struct slab *slab;
+	struct kmem_cache *s;
+
+	VM_WARN_ON_ONCE(is_vmalloc_addr(ptr) || !virt_to_slab(ptr));
+
+	slab = virt_to_slab(ptr);
+	s = slab->slab_cache;
+
+	if (__kfree_rcu_sheaf(s, ptr, /* allow_spin = */ false))
+		return;
+
+	defer_kfree_rcu(head);
+}
+EXPORT_SYMBOL_GPL(kfree_call_rcu_nolock);
+
 #ifndef CONFIG_KVFREE_RCU_BATCHED
 
 void kvfree_call_rcu(struct rcu_head *head, void *ptr)
@@ -2120,10 +2137,11 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
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
index 4850629774b2..19018a979445 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4075,6 +4075,7 @@ static void flush_all(struct kmem_cache *s)
 
 struct deferred_percpu_work {
 	struct llist_head objects;
+	struct llist_head objects_by_rcu;
 	struct llist_head rcu_sheaves;
 	struct irq_work work;
 };
@@ -4083,6 +4084,7 @@ static void deferred_percpu_work_fn(struct irq_work *work);
 
 static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
 	.objects = LLIST_HEAD_INIT(objects),
+	.objects_by_rcu = LLIST_HEAD_INIT(objects_by_rcu),
 	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
 	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
 };
@@ -6392,12 +6394,13 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 static void deferred_percpu_work_fn(struct irq_work *work)
 {
 	struct deferred_percpu_work *dpw;
-	struct llist_head *objs, *rcu_sheaves;
+	struct llist_head *objs, *objs_by_rcu, *rcu_sheaves;
 	struct llist_node *llnode, *pos, *t;
 
 	dpw = container_of(work, struct deferred_percpu_work, work);
 	rcu_sheaves = &dpw->rcu_sheaves;
 	objs = &dpw->objects;
+	objs_by_rcu = &dpw->objects_by_rcu;
 
 	llnode = llist_del_all(objs);
 	llist_for_each_safe(pos, t, llnode) {
@@ -6428,6 +6431,13 @@ static void deferred_percpu_work_fn(struct irq_work *work)
 
 		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
 	}
+
+	llnode = llist_del_all(objs_by_rcu);
+	llist_for_each_safe(pos, t, llnode) {
+		struct rcu_head *head = (struct rcu_head *)pos;
+
+		call_rcu(head, kvfree_rcu_cb);
+	}
 }
 
 static void defer_free(struct kmem_cache *s, void *head)
@@ -6443,6 +6453,17 @@ static void defer_free(struct kmem_cache *s, void *head)
 		irq_work_queue(&dpw->work);
 }
 
+void defer_kfree_rcu(struct rcu_head *head)
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


