Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF68ECD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA6D6B00A2; Mon, 15 Jun 2026 07:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2126B00A4; Mon, 15 Jun 2026 07:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1796B00A5; Mon, 15 Jun 2026 07:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 192CD6B00A2
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:07:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D031692F0F
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:07:15 +0000 (UTC)
X-FDA: 84881870430.17.355A124
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 21B561A000B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:07:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GITsWOW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781521634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/ijfUoogm2b+cM5xgTnmLzdDUHT22OxJy5j6X1e9RQ=;
	b=QWYEugBPS5GNtwXhJl8KhSf8r1e0wJSWRg1vzTvudmOJkVgoXCGHiuSzJm8VO1wowCvpiZ
	Eg2aAmUoJg2M7v9SdjcXMyOZ34rIeaQDxzCKUWELolwuuVG3TGj6lcnlufvYcC+btu/JNG
	JnZ0NvbEyJH91x0PdBtxOzPJhcraCpo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GITsWOW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781521634;
	b=CZ8mdbQK/AS1HqG56x6RJUMlPdexJDOpZugIxB9CMwrDvogHw4+yGZKxkx4eLIP+RKDZOG
	0asyyYc1+vtX0/4Rsx13traNfC3XgZ2/JNqHG2oveBCGyAqyK68S/7o0iqp1l3BVHQKp1O
	Ha6Pcf5W3XDLoQ56TcReAPDO+3mZJc0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B169860132;
	Mon, 15 Jun 2026 11:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CDA1F000E9;
	Mon, 15 Jun 2026 11:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781521633;
	bh=o/ijfUoogm2b+cM5xgTnmLzdDUHT22OxJy5j6X1e9RQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GITsWOW5Z+GUrJ29hd5mnyWVcwRgNpK0cKXHhfvpn+jS1rdcIBwgkVI40th8X1OT1
	 Pmlef5x0adbs9WTIBlC0zm6kmZC2nR0GKy5+AeGij5ceNSQz+ElKxuR0246cDNjorO
	 yRArBG3Ajo/Ez18if/6kdRxPilq6HffXPvxak4BEzgR6dPkYvewkcB08T+dNKXHs+2
	 Ymw29lVDR61ttwh4nO/SbZ7WzHAASXbRG/k5TyLgMYRJaeBle/bSNjO2uKTZnYZ/0/
	 mvOW+pJgFZ4zHH1a8E0WiPn1uzho/hecZq9PY+754qLcDBpYsclPbQbR25Dze4ceZW
	 xvtxReIX6elsg==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 15 Jun 2026 20:06:02 +0900
Subject: [PATCH for-next v3 8/9] mm/slab: introduce struct kfree_rcu_head
 and use in kfree_rcu_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-kfree_rcu_nolock-v3-8-70a54f3775bb@kernel.org>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 21B561A000B
X-Stat-Signature: y4444p9s4siiq9a6y8jgxtzmao7o7yx7
X-Rspam-User: 
X-HE-Tag: 1781521633-174361
X-HE-Meta: U2FsdGVkX1/R3088E4N83oLqUcBpF6SjDFdxqriqDXSud/3NR6SrNX/NbhOTfil7Yy+era70qKPhd1/wmDUCWoGhxndUZKGnRrCY7Mwianx8m5OBe7wahPpY4D4xOFmtISttGZol7ICyLKcLJ/Q2/6Q16sYyfsAXxJSLM+0HmRNkMYnuk2XrLI6xjT+bi/1MR8ETv+5TOTN3tCRGKiohKxJuQ8f3mlvAPNsBArReHB09d2CE5ek1pC+lWxUw0e78pVzXn0r2Fo7LH+NX2a5Q0pIw6Yyqa8aR/G+iKWo3II3NQvrfdQFCHrjqtbUk6aFJj/2LyZXehYJ4I5abSYtMGBZGdg2WZbUX2GW1jgNAnDrXeDAxBj0wniLe+FYcSP0DhDEbqLlzgNfcl3SRnTDzPQzPNVLbm0LcWT/PXmVp2DHGpUR1TJN8p1soYuf3LVzztg0S1vnz1bCIUpxb4/G2xeQ+3NWc/WpJq94BMgEgDEQ7YlCCiMlPg89U8PKgPCMukHyj8ItOkd0aLiRbD7+0nyCwCUsXw5hP4NQMxXBtJ9IxXgBo4dVCh64ao5A5rtJj5B8PCCar5gv2WS5WrRkUXSoXFP6IH7xK7WJovdWQvRfx/9bQ5B0EMJ7Cczf7BGAFPthBdFJCLs6eCwnume0hxwPb6KBb93e+pjTnlszPM0rsmZ82EFC7DhHmJ0YF6p3E9mmLuNbp85vR73qxoBI/kPI3i/qN0WupWhfi1xXqmC7mHrLw16tAa2VONa6QqwKSDKJO5PoyPMwjol2mrYMfSuHmxKLBGrSOc0qmF7rFtQId/kJ4mQw4te3n7W8nCHI2L+GW1/0ilaXrT/qVs+vrlQ/teZEu5YeoNhLOz4uubEZLgAbSH2vDI4MCV5a7KfgKhQhKPlvi72KTVQTomlMT1ZHGW/Thd5fp6BpsVg2ACPbO47nOprIpHKFa8MDgUWzWdSk4WultCywZBWNqD4r
 u/iLSbQm
 C3D/KJf+lLmAbQmK6PiaTsC6M+HReIAKH6tioPBa1CmLjPKbIeRQpxYVws30dWUJSxZtxW0EWG+7igVpuLn1MwX0giIeBIwWvVtkdwHKKQswGth2/LLNjlY2gnzmEpTDbaF98uYnJFiP2A0IDcJWl8nwAbVPT2TawRnLqXVECIexCOXClVmg6VlvPop9q3pt0ASbPeb6XP5r9Vvlp869pXPgFsuQoaBjNP173NCCEg30qgYHEMDoCxdNlNCNtwY0lk8r/GtdZQvYF9lr5n9lqcFzEoRpzQBv6jPaL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct rcu_head is overkill for kfree_rcu() because the callback
function is always kfree() and thus there is no need for a function
pointer.

It is enough to implement a linked list using a single pointer.
Introduce a new struct called kfree_rcu_head (the name was suggested
by Vlastimil Babka), which is similar to struct rcu_head but is only
a single pointer. Use it only in kfree_rcu_nolock() for now.

It is intended that in most cases, kfree_rcu_nolock() goes through
sheaves path and the field is not used at all. However, in the worst
case where trylock fails or no empty sheaves are available, maintain
a global list of objects that will later be freed after
synchronize_rcu() in a workqueue. Since the fallback is intended to be
the last resort, it focuses on minimizing complexity and memory usage.

To avoid crashing the kernel in a theoretical case where fallback path
is taken before kmem_cache_init_late(), do not queue the work until
the workqueue is actually allocated.

Factor out the logic that calculates object start address into
object_start_address() from kvfree_rcu_cb() to avoid duplicating it.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 include/linux/rcupdate.h |  2 +-
 include/linux/types.h    |  4 +++
 mm/slab.h                |  2 +-
 mm/slab_common.c         |  2 +-
 mm/slub.c                | 92 ++++++++++++++++++++++++++++++++----------------
 5 files changed, 69 insertions(+), 33 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3025249bfcb5..83e66585001f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1099,7 +1099,7 @@ static inline void rcu_read_unlock_migrate(void)
  * In mm/slab_common.c, no suitable header to include here.
  */
 void kvfree_call_rcu(struct rcu_head *head, void *ptr);
-void kfree_call_rcu_nolock(struct rcu_head *head, void *ptr);
+void kfree_call_rcu_nolock(struct kfree_rcu_head *head, void *ptr);
 
 /*
  * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
diff --git a/include/linux/types.h b/include/linux/types.h
index 93166b0b0617..695f2a71411e 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -255,6 +255,10 @@ struct callback_head {
 } __attribute__((aligned(sizeof(void *))));
 #define rcu_head callback_head
 
+struct kfree_rcu_head {
+	struct kfree_rcu_head *next;
+};
+
 typedef void (*rcu_callback_t)(struct rcu_head *head);
 typedef void (*call_rcu_func_t)(struct rcu_head *head, rcu_callback_t func);
 
diff --git a/mm/slab.h b/mm/slab.h
index a493c5201e96..19a2a819fd13 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -745,7 +745,7 @@ void __check_heap_object(const void *ptr, unsigned long n,
 			 const struct slab *slab, bool to_user);
 
 void deferred_work_barrier(void);
-void defer_kfree_rcu(struct rcu_head *head);
+void defer_kfree_rcu(struct kfree_rcu_head *head);
 
 static inline bool slub_debug_orig_size(struct kmem_cache *s)
 {
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 5a39e6225160..6b80b516c93f 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1263,7 +1263,7 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
 EXPORT_TRACEPOINT_SYMBOL(kfree);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
 
-void kfree_call_rcu_nolock(struct rcu_head *head, void *ptr)
+void kfree_call_rcu_nolock(struct kfree_rcu_head *head, void *ptr)
 {
 	struct slab *slab;
 	struct kmem_cache *s;
diff --git a/mm/slub.c b/mm/slub.c
index 19018a979445..853430c7fbe0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4075,20 +4075,25 @@ static void flush_all(struct kmem_cache *s)
 
 struct deferred_percpu_work {
 	struct llist_head objects;
-	struct llist_head objects_by_rcu;
 	struct llist_head rcu_sheaves;
 	struct irq_work work;
 };
 
 static void deferred_percpu_work_fn(struct irq_work *work);
+static void deferred_irq_work_fn(struct irq_work *work);
+static void deferred_work_fn(struct work_struct *w);
 
 static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
 	.objects = LLIST_HEAD_INIT(objects),
-	.objects_by_rcu = LLIST_HEAD_INIT(objects_by_rcu),
 	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
 	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
 };
 
+static LLIST_HEAD(deferred_free_by_rcu);
+static struct workqueue_struct *deferred_wq;
+static DEFINE_IRQ_WORK(deferred_irq_work, deferred_irq_work_fn);
+static DECLARE_WORK(deferred_work, deferred_work_fn);
+
 static void flush_rcu_sheaf(struct work_struct *w)
 {
 	struct slub_percpu_sheaves *pcs;
@@ -6394,13 +6399,12 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 static void deferred_percpu_work_fn(struct irq_work *work)
 {
 	struct deferred_percpu_work *dpw;
-	struct llist_head *objs, *objs_by_rcu, *rcu_sheaves;
+	struct llist_head *objs, *rcu_sheaves;
 	struct llist_node *llnode, *pos, *t;
 
 	dpw = container_of(work, struct deferred_percpu_work, work);
 	rcu_sheaves = &dpw->rcu_sheaves;
 	objs = &dpw->objects;
-	objs_by_rcu = &dpw->objects_by_rcu;
 
 	llnode = llist_del_all(objs);
 	llist_for_each_safe(pos, t, llnode) {
@@ -6431,12 +6435,50 @@ static void deferred_percpu_work_fn(struct irq_work *work)
 
 		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
 	}
+}
+
+static void deferred_irq_work_fn(struct irq_work *work)
+{
+	if (!deferred_wq)
+		return;
+
+	queue_work(deferred_wq, &deferred_work);
+}
+
+static inline void *object_start_address(void *ptr)
+{
+	void *obj;
+	struct slab *slab = virt_to_slab(ptr);
+	struct kmem_cache *s = slab->slab_cache;
+
+	VM_WARN_ON_ONCE(is_vmalloc_addr(ptr) || !slab);
+
+	if (is_kfence_address(ptr)) {
+		obj = kfence_object_start(ptr);
+	} else {
+		unsigned int idx = __obj_to_index(s, slab_address(slab), ptr);
+
+		obj = slab_address(slab) + s->size * idx;
+		obj = fixup_red_left(s, obj);
+	}
+
+	return obj;
+}
+
+static void deferred_work_fn(struct work_struct *w)
+{
+	struct llist_node *llnode, *pos, *t;
+
+	llnode = llist_del_all(&deferred_free_by_rcu);
+	if (!llnode)
+		return;
+
+	synchronize_rcu();
 
-	llnode = llist_del_all(objs_by_rcu);
 	llist_for_each_safe(pos, t, llnode) {
-		struct rcu_head *head = (struct rcu_head *)pos;
+		void *obj = object_start_address(pos);
 
-		call_rcu(head, kvfree_rcu_cb);
+		kfree(obj);
 	}
 }
 
@@ -6453,15 +6495,10 @@ static void defer_free(struct kmem_cache *s, void *head)
 		irq_work_queue(&dpw->work);
 }
 
-void defer_kfree_rcu(struct rcu_head *head)
+void defer_kfree_rcu(struct kfree_rcu_head *head)
 {
-	struct deferred_percpu_work *dpw;
-
-	guard(preempt)();
-
-	dpw = this_cpu_ptr(&deferred_percpu_work);
-	if (llist_add((struct llist_node *)head, &dpw->objects_by_rcu))
-		irq_work_queue(&dpw->work);
+	if (llist_add((struct llist_node *)head, &deferred_free_by_rcu))
+		irq_work_queue(&deferred_irq_work);
 }
 
 void deferred_work_barrier(void)
@@ -6470,6 +6507,9 @@ void deferred_work_barrier(void)
 
 	for_each_possible_cpu(cpu)
 		irq_work_sync(&per_cpu_ptr(&deferred_percpu_work, cpu)->work);
+
+	irq_work_sync(&deferred_irq_work);
+	flush_work(&deferred_work);
 }
 
 static __fastpath_inline
@@ -6731,8 +6771,6 @@ void kvfree_rcu_cb(struct rcu_head *head)
 	void *obj = head;
 	struct page *page;
 	struct slab *slab;
-	struct kmem_cache *s;
-	void *slab_addr;
 
 	if (is_vmalloc_addr(obj)) {
 		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
@@ -6752,19 +6790,8 @@ void kvfree_rcu_cb(struct rcu_head *head)
 		return;
 	}
 
-	s = slab->slab_cache;
-	slab_addr = slab_address(slab);
-
-	if (is_kfence_address(obj)) {
-		obj = kfence_object_start(obj);
-	} else {
-		unsigned int idx = __obj_to_index(s, slab_addr, obj);
-
-		obj = slab_addr + s->size * idx;
-		obj = fixup_red_left(s, obj);
-	}
-
-	slab_free(s, slab, obj, _RET_IP_);
+	obj = object_start_address(obj);
+	slab_free(slab->slab_cache, slab, obj, _RET_IP_);
 }
 
 /**
@@ -8698,6 +8725,11 @@ void __init kmem_cache_init_late(void)
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
 				  0);
 	WARN_ON(!flushwq);
+
+	deferred_wq = alloc_workqueue("slab_deferred_wq",
+				      WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	WARN_ON(!deferred_wq);
+	queue_work(deferred_wq, &deferred_work);
 #ifdef CONFIG_SLAB_FREELIST_RANDOM
 	prandom_init_once(&slab_rnd_state);
 #endif

-- 
2.53.0


