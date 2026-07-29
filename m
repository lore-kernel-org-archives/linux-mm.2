Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 114EBC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C5A6B00DE; Wed, 29 Jul 2026 10:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54066B00DD; Wed, 29 Jul 2026 10:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C616B00DD; Wed, 29 Jul 2026 10:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 641646B00DD
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:17:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1DADD12061B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:42 +0000 (UTC)
X-FDA: 85041120444.10.1D0CB9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 58D7E1C0004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mY7s/rhL";
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785313300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjSBb9mVbLXIx6izzSo3Zj/I/hrxLU57UnbtahM6eqg=;
	b=KFhZ0/8Q6lbqY/pg/Vd+Mcfo1zx2juekx/Z1uJtXsY7FGWgvOCHSmbtNs610kiaiWnahKl
	ZNQ6uDkHxczKJ4U6uIDrUftRYPXOI1DmBUI0Iu0gW0evrSMe/deVgQLmyhY3LlfJftVpdA
	f9ATpUFBI7GV6Cs94tZ2ovuL3fdPVC8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785313300;
	b=JoTfaX6mMg4pprotUADBPUrxfTZgtMwSE1KPgra6QFbfacHhfL4xM/i0I3CLaHOMN34iPK
	qgWnOhDjKaMKN1YAAX0ePiOn0RdmY44Pu2gwS2baa7aktL1wk1F4mQx7NbS+aXKUJxCCAf
	TR0LISTdLS7Ff6VWgN+c+98cHy6GaBc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mY7s/rhL";
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A50DB416A0;
	Wed, 29 Jul 2026 08:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5421F00A3A;
	Wed, 29 Jul 2026 08:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785313299;
	bh=HjSBb9mVbLXIx6izzSo3Zj/I/hrxLU57UnbtahM6eqg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mY7s/rhLzCihs9hLBNtGbfu7njKF4M2YR7eW/RydfLq9zjbt0Ha+EpVpdHmuYu/eB
	 l9eoPBzqNY/gaRpVSYjSJMwMQLEg1fXE/7E+uyhGr9LNT/U6sh5KWDdXzQxlHdXZyJ
	 W4qR014DdqITqxtkYkF/WuRjlSt2E021fh3B7E3lKgKN5KHBMlJ7RKQ5J/aMvXDExy
	 waKrD+a9OgT4X5fEolwM+2qfs4mJgdmQ4SlUMifKTr+LMKRj69KmtWsp7Aat0Tb8sw
	 MBWoR31zAthzvaXzzFZgWGMtFv251Dxv3d5ZRUrvAOb7mi5r5CyJXwU7WHuIy1dzVK
	 gglmWp7YzuMcA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 29 Jul 2026 17:20:15 +0900
Subject: [PATCH v5 7/8] mm/slab: introduce kfree_rcu_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-kfree_rcu_nolock-v5-7-a28cdcda9673@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 58D7E1C0004
X-Stat-Signature: 6n4dzgs39xhainczrpi4gztqkfg8mmxn
X-Rspam-User: 
X-HE-Tag: 1785313300-915976
X-HE-Meta: U2FsdGVkX18ybo77AEsjU2XHdmQQSaVBsM1nZSgpHCFkc2huXdSpyH3JRiaTjY02OdIOlLnhEigWHWAEjZbZ7297U/k+Rex3gqCFKSRgjP+7DNWl4L5aNiYzaNdElqtrfGPbdIgFbSkUCc/cWT7Fy6TRwTWNqkw5BWnXflQTtcULJUEO4UpYxsvAr+gBFEsC3nT1lj/vUsj/mATGjtJtCh165WRiO1kPSQmn0ViYM/+GHFKzm3303WolxKWAeZr5dnrJXAuFGBg9hnIq6/mCLPKLbijClGifmKwKxxULD7CsxQqYCN9qa2chJqBTbLlOpTIxdP5q+3IDFTTY9A6jZHzyP8enaAGpSfrObsKbu7CIkgeR0TfE24G5qTdBgs/b+VMfEVv2/TJ/InaKaDeKkaT3SCpAdACCMKGg/E+pUEUcFcs2JH5vMFS4wh6ceTQIzW3dVkwzwwoZ3qDvs2AJIU0OVB8FhL33VNJbinyqgkMK9lAjcH4Hgo0s1/O1pA1MqMo5pX8PwyYeUI1GNY0xzOzWiDMLg4lP5ZM4h0jo198cpQsqEwkTYjF9kR3/VKlPpq5LCRP8eyt01gYTvuJyewVzaSKTPtoBprvVKvsve0zwsI3Zhhgbuy3V0LH2EwDIX8niTXAdWiVqNYywt0cDQaVC4V7M81kSVLqmGn8oMpinkYM3lgL0PbLqJhT/5uA+PNUh7SrbF9i2zdZGipxZzIE4cdBCVM5guTfKE/6tcG06YkD9oNj6z2DbUbZ2uXCvYFMgy24qO/QvHppcEBSVnOuPxdGPJ1J1cUpwddFlB8HJ/KQ6Zh6HBxIbOC7V2DpLLAjTCCb7TuDvBJ8A0UfSYPqICj97RIO5ofXUjU+mvXWtYoYGWKn9taKSGoEvUzIzHfYlDDod6AydSdKhQHZctmM8Wv4AsMUluZ6orTJ0vg4Ajogd9IJKeLaNNeMjZQWToduSCXrw4Jb89UvwleX
 tv7s0ZVq
 6bC4zJYRMX9coGyiSit+VPkGt7BUKnqstAm3lLtFjuKNTAj+F+K5UhHTkc7xTEP2EpyAI5ZLDsi6k6w+4RA+MfoO68XMOXZPJ0/jW2jBXxcGyijqNzXk6aLJKjPmOz9kBEZiiYDK/q4G7DM5tJvyGsbKGngpRGwtFwRoVcOnnoOsD1O1iHWGZDu7rYXz09we5iqhe2R9OIeONSl8jqlwrA+pf5ViEbpgltx/KL3xxC5hlkEhPBRpHr+YeyY+TRHgXm7jJoZPMes1tKfKKYw4PTPdVulwmLm+suVNOARNEZexulj0=
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

When sheaves path fails, kfree_rcu_nolock() falls back to
defer_kfree_rcu() that uses an irq work to free the object via
kvfree_call_rcu(). In most cases, the sheaves path is expected to
succeed and therefore it's unnecessary to introduce additional
complexity to the existing kvfree_rcu batching by teaching it
how to handle unknown context.

Since defer_kfree_rcu() can be called on caches without sheaves, move
deferred_work_barrier() and rcu_barrier() outside the branch in
kvfree_rcu_barrier_on_cache().

Now that deferred kvfree_rcu objects are submitted to kvfree_call_rcu()
after deferred_work_barrier() and may end up in RCU sheaves,
deferred_work_barrier() must be invoked before
flush_rcu_sheaves_on_cache().

Since the RCU sheaf path has not been used on !KVFREE_RCU_BATCHED
kernels, always fall back when kvfree_rcu() is not batched, for
consistency. kvfree_rcu_barrier{,_on_cache()}() on
!KVFREE_RCU_BATCHED are moved to mm/slab_common.c to invoke
deferred_work_barrier() before rcu_barrier().

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 include/linux/rcupdate.h | 22 ++++++++++++++++++++++
 include/linux/slab.h     | 16 +++-------------
 mm/slab_common.c         | 47 +++++++++++++++++++++++++++++++++++++++++++++--
 mm/slub.c                | 28 ++++++++++++++++++++++++++--
 4 files changed, 96 insertions(+), 17 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ef5bb6981133..aede77bd0387 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1099,6 +1099,7 @@ static inline void rcu_read_unlock_migrate(void)
  * In mm/slab_common.c, no suitable header to include here.
  */
 void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr);
+void kfree_call_rcu_nolock(struct kvfree_rcu_head *head, void *ptr);
 
 /*
  * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
@@ -1124,6 +1125,27 @@ do {								\
 		kvfree_call_rcu(NULL, (void *) (___p));		\
 } while (0)
 
+/**
+ * kfree_rcu_nolock() - a version of kfree_rcu() that can be called in any context.
+ * @ptr: pointer to kfree for double-argument invocations.
+ * @kvrhf: the name of the struct kvfree_rcu_head within the type of @ptr.
+ *
+ * With KVFREE_RCU_BATCHED, kfree_rcu_nolock() tries hard to free objects
+ * without any deferred processing, but may still defer freeing.
+ * Large kmalloc and vmalloc objects are always deferred.
+ *
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
diff --git a/include/linux/slab.h b/include/linux/slab.h
index e1915026e030..cda126def67a 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1430,25 +1430,15 @@ extern void kvfree_sensitive(const void *addr, size_t len);
 unsigned int kmem_cache_size(struct kmem_cache *s);
 
 #ifndef CONFIG_KVFREE_RCU_BATCHED
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
 static inline void kfree_rcu_scheduler_running(void) { }
 #else
+void kfree_rcu_scheduler_running(void);
+#endif
+
 void kvfree_rcu_barrier(void);
 
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s);
 
-void kfree_rcu_scheduler_running(void);
-#endif
-
 /**
  * kmalloc_size_roundup - Report allocation bucket size for the given size
  *
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 691ce6db4519..b8f21eabcccc 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1296,6 +1296,33 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
 EXPORT_TRACEPOINT_SYMBOL(kfree);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
 
+void kfree_call_rcu_nolock(struct kvfree_rcu_head *head, void *ptr)
+{
+	struct slab *slab;
+
+	if (!IS_ENABLED(CONFIG_KVFREE_RCU_BATCHED))
+		goto fallback;
+
+	if (unlikely(is_vmalloc_addr(ptr)))
+		goto fallback;
+
+	slab = virt_to_slab(ptr);
+	if (unlikely(!slab))
+		goto fallback;
+
+	if (unlikely(IS_ENABLED(CONFIG_NUMA) && slab_nid(slab) != numa_mem_id()))
+		goto fallback;
+
+	if (unlikely(!__kfree_rcu_sheaf(slab->slab_cache, ptr, SLAB_FREE_NOLOCK)))
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
@@ -1313,6 +1340,20 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 }
 EXPORT_SYMBOL_GPL(kvfree_call_rcu);
 
+void kvfree_rcu_barrier(void)
+{
+	deferred_work_barrier();
+	rcu_barrier();
+}
+EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
+
+void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
+{
+	deferred_work_barrier();
+	rcu_barrier();
+}
+EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
+
 void __init kvfree_rcu_init(void)
 {
 }
@@ -2149,14 +2190,16 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
  */
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
+	/* kfree_rcu_nolock() might have deferred frees even without sheaves */
+	deferred_work_barrier();
+
 	if (cache_has_sheaves(s)) {
 		cpus_read_lock();
 		flush_rcu_sheaves_on_cache(s);
 		cpus_read_unlock();
-		deferred_work_barrier();
-		rcu_barrier();
 	}
 
+	rcu_barrier();
 	__kvfree_rcu_barrier();
 }
 EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
diff --git a/mm/slub.c b/mm/slub.c
index 774104267f3c..6e5aa38e7569 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4099,6 +4099,7 @@ static void flush_all(struct kmem_cache *s)
 
 struct deferred_percpu_work {
 	struct llist_head objects;
+	struct llist_head objects_by_rcu;
 	struct llist_head rcu_sheaves;
 	struct irq_work work;
 };
@@ -4107,6 +4108,7 @@ static void deferred_percpu_work_fn(struct irq_work *work);
 
 static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
 	.objects = LLIST_HEAD_INIT(objects),
+	.objects_by_rcu = LLIST_HEAD_INIT(objects_by_rcu),
 	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
 	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
 };
@@ -4170,6 +4172,8 @@ void flush_all_rcu_sheaves(void)
 {
 	struct kmem_cache *s;
 
+	deferred_work_barrier();
+
 	cpus_read_lock();
 	mutex_lock(&slab_mutex);
 
@@ -4182,7 +4186,6 @@ void flush_all_rcu_sheaves(void)
 	mutex_unlock(&slab_mutex);
 	cpus_read_unlock();
 
-	deferred_work_barrier();
 	rcu_barrier();
 }
 
@@ -6407,13 +6410,14 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
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
@@ -6438,6 +6442,14 @@ static void deferred_percpu_work_fn(struct irq_work *work)
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
@@ -6456,6 +6468,18 @@ static void defer_free(struct kmem_cache *s, void *head)
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
+/* Must be called before flush_rcu_sheaves_on_cache() */
 void deferred_work_barrier(void)
 {
 	int cpu;

-- 
2.53.0


