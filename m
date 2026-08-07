Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E2B9C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 13:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CED6B008A; Fri,  7 Aug 2026 09:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013B06B0092; Fri,  7 Aug 2026 09:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E934B6B0093; Fri,  7 Aug 2026 09:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C17896B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:50:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D2A2140274
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:50:53 +0000 (UTC)
X-FDA: 85074609186.08.80001DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 97650140012
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:50:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oroht8SH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786110651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6heLdTrKkhpyc80UCW2aSDkkttYCK0SQ8+JM1HNgJk=;
	b=OWt3iHuMHzewTNFGNbWnaqJkXnCs8lnk00YDZ380D7D2VM1/g365cEYxPKOIU09qKXZL4P
	4sceKn85VD554tRbMFLJHI8KivbpSdNyH+88wbUsD5JVcvGTganXgsuzl8E/lfbfaMdWOH
	KacnESVvtgy4MeP2XDMW3Rv6/9kK6Vc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oroht8SH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786110651;
	b=wQny/sB0gxOfZ/m6tL1xWyAgY/rTRsvFXeVW/PNnmFinZGpO/ef+PiuBDX44sFIWwTGfKW
	2N9fsjO9t6flS2uWZnG4G0em6lBcKTWVW5vme6dU1fyTQ/ZGftP1OC4bcJXwpVH+F5NOwv
	sZplwm4TKnkUiCA0/FWq0L+muoYIABA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5C0243C02;
	Fri,  7 Aug 2026 13:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AEC1F01558;
	Fri,  7 Aug 2026 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786110650;
	bh=N6heLdTrKkhpyc80UCW2aSDkkttYCK0SQ8+JM1HNgJk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oroht8SHBVezTmTAIeRMFFVdtkT5L7PiN82AxE59EDAH+uMGTOVeqysT+Us04uBTO
	 8uYl+S9Bn9qEz7CfN6vbRvdXj4UIOdwo+2EPIacVW6JpTKVpLN1c+44qGIqSS2iv5H
	 sHF+5Wipg4mVOrsmWLSiXnyqhhBYYOIFmyciRVEuA/itJ/q/qY+l2O1uSeql9PgrdQ
	 UIzGsrnmyS8y/g0Epf8oJI1eA8jfaTqY6+a1qRaHkwvwkZw7XcarCvrA1IJloLxqHv
	 o+eVhWqd/GufTn8hwSVSjYG6AbyRY7qQBiZRi/NfxlK6xlq7OsZFWUiFV8p9tTMpVf
	 u4FXzDxZqFE3A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 07 Aug 2026 15:50:28 +0200
Subject: [PATCH RFC 2/5] mm/slab, kfence: support kfence objects in
 kfree_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-kfree_nolock_kmalloc-v1-2-ba993cbf7a60@kernel.org>
References: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
In-Reply-To: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
To: Harry Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, bpf@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Dmitry Vyukov <dvyukov@google.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 kasan-dev@googlegroups.com, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
 Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-rt-devel@lists.linux.dev, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 97650140012
X-Stat-Signature: ersy7pcreciycrmmhqufj8bn6pmstkas
X-Rspam-User: 
X-HE-Tag: 1786110651-582839
X-HE-Meta: U2FsdGVkX1/mVdFwceXVOn0YcFRZ41VP09ywaI1sDsupqlMVknPJDMZhuz38Dh/N23hXicsp5nn8rvlqURDI6LSn8K6PE7fT7Z3qiDcYL05Qly56RhC8rzZPHkRzg2JKAmrJcuvtVg0n6OrkxA5k14vnSjooH1xq89181tsF8jHQIeeDczSsYOG8kEq3jbqN//x7FSGJQcpM2YLryIOEjBns4DrXMs3AJnb/aBCDDmRHBBbTOpA5KoIQhBpi32ga5XYXyNp9AjEyeEg6058jlJwKxRx2TcEeJ6hiLldxI6qbKbkIPJAkl+C1jIYQdVzaNGCWz0Bq+2tEHyXxKmLn4xqWY67W86aAUZCydy1IQvLBGel3JVRa8c0DBDtBsDRODqrh4aePg9Pczso5hgJa7eiYXA531hG0Zp3wCXWcEyJL1g/uh8x8HK0/Bix1B3iNVkFsgYd8fIO/z+SdH/dEntEq+Z8EjMuBKXNV/i/V20lhhCSMpmN+H0lVytSsGEIdGMeKblVgKK9Tncagd6W9fLNPwPXefA497N17jxAMao1rx1krQW8FzKl1GMD3PLwbw6w/23ikIPli0pgwd8h5ItxmGL5WeAk6xEKyWjJS2UOwpJszuZV82X+UcY3ODQAQ5p2bcNrYAmdbkCk6F46L5SmbSqHBTG7hJrj7KdATiDD9nhGjTQATXqRIDISbWXPTxiLIJObh9ZvH4GvYmpd3bvUkV80jST7y5li9umOEoVfAx8ZRn98Fna1GXb0guC+Ibz8l1NYHT+hRxgV9HBUnjV3UGQwFQcRUnpLMX0nei4pWUcG5GBLd/F1aP1Alo2PGMVN9lgcMgeJXezw5CWOfzdoEHS0fw+AcH34+9N2cKXFT3CpVnaClCIX/4+/k27adJ1Aa6sZOgr1D0bzkBHZwoXcpdCKopOPLBkgHM1QBKYTgx9FbEVqzJNy6QktwsgmtVfRWi9Ia8OjZRuti7sk
 8FTwXgqF
 2LEK7pmvkh3I7xa/r0Hgbaw4uxxlr26+qQ507yoaEsRSKoZZKyVOj9kzIaUxiTd89KLwDa9CQ7gfXKS7jZsZRSSOcd3MRzVxunaKm5QgIjGjeTSw8mCYsv5ty6/ARMnuYG9kiLJkShT7CrZPxV1iwuka4zYUYbNeG7aHDHqyXWJC+7m092ALVcrLlT5va73y699z6UH80kg2acCYrK/kMGzEevmfH1eM7AisV3LouDSvlitNRmVkWxtfGMGrNpDL2EfP+8ujHDEYVZVa0b88voT93smPhtx96TrQqBdxfQFfOBS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KFENCE objects are one of the reasons why kfree_nolock() cannot
currently handle kmalloc() objects. They are however rare so we can
simply defer their freeing to irq_work.

The only complication is where to put the llist node. We cannot use the
freepointer location like in defer_free() because for some caches it may
be outside the object area and KFENCE would detect writes there.

Since KFENCE already solves a similar situation when freeing objects
from SLAB_TYPESAFE_BY_RCU caches with an rcu_head in its internal
metadata, reuse that rcu_head also for the llist node. Introduce
kfence_obj_to_llnode() and kfence_llnode_to_obj() so SLAB can work with
this llist node without being exposed to KFENCE internals.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/kfence.h |  5 +++++
 mm/kfence/core.c       | 14 ++++++++++++++
 mm/kfence/kfence.h     |  5 ++++-
 mm/slub.c              | 39 ++++++++++++++++++++++++++++++++++++---
 4 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index e5822f6e7f27..00721c85258d 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -188,6 +188,9 @@ static __always_inline __must_check bool kfence_free(void *addr)
 	return true;
 }
 
+struct llist_node *kfence_obj_to_llnode(void *addr);
+void *kfence_llnode_to_obj(struct llist_node *llnode);
+
 /**
  * kfence_handle_page_fault() - perform page fault handling for KFENCE pages
  * @addr: faulting address
@@ -235,6 +238,8 @@ static inline size_t kfence_ksize(const void *addr) { return 0; }
 static inline void *kfence_object_start(const void *addr) { return NULL; }
 static inline void __kfence_free(void *addr) { }
 static inline bool __must_check kfence_free(void *addr) { return false; }
+static inline struct llist_node *kfence_obj_to_llnode(void *addr) { return NULL; }
+static inline void *kfence_llnode_to_obj(struct llist_node *llnode) { return NULL; }
 static inline bool __must_check kfence_handle_page_fault(unsigned long addr, bool is_write,
 							 struct pt_regs *regs)
 {
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 6577bd76954e..42519d24687f 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -1271,6 +1271,20 @@ void __kfence_free(void *addr)
 	}
 }
 
+struct llist_node *kfence_obj_to_llnode(void *addr)
+{
+	struct kfence_metadata *meta = addr_to_metadata((unsigned long)addr);
+
+	return &meta->llnode;
+}
+
+void *kfence_llnode_to_obj(struct llist_node *llnode)
+{
+	struct kfence_metadata *meta = container_of(llnode, struct kfence_metadata, llnode);
+
+	return (void *)meta->addr;
+}
+
 bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs *regs)
 {
 	const int page_index = (addr - (unsigned long)__kfence_pool) / PAGE_SIZE;
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index 1f618f9b0d12..0fca1dc2c794 100644
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -58,7 +58,10 @@ struct kfence_track {
 /* KFENCE metadata per guarded allocation. */
 struct kfence_metadata {
 	struct list_head list __guarded_by(&kfence_freelist_lock);	/* Freelist node. */
-	struct rcu_head rcu_head;	/* For delayed freeing. */
+	union {
+		struct rcu_head rcu_head;	/* For delayed freeing. */
+		struct llist_node llnode;	/* For kfree_nolock(). */
+	};
 
 	/*
 	 * Lock protecting below data; to ensure consistency of the below data,
diff --git a/mm/slub.c b/mm/slub.c
index 044db93d64a0..2d7648b96bfa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4050,6 +4050,7 @@ static void flush_all(struct kmem_cache *s)
 
 struct deferred_percpu_work {
 	struct llist_head objects;
+	struct llist_head objects_kfence;
 	struct llist_head objects_by_rcu;
 	struct llist_head rcu_sheaves;
 	struct irq_work work;
@@ -4059,6 +4060,7 @@ static void deferred_percpu_work_fn(struct irq_work *work);
 
 static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
 	.objects = LLIST_HEAD_INIT(objects),
+	.objects_kfence = LLIST_HEAD_INIT(objects_kfence),
 	.objects_by_rcu = LLIST_HEAD_INIT(objects_by_rcu),
 	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
 	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
@@ -6399,6 +6401,13 @@ static void deferred_percpu_work_fn(struct irq_work *work)
 		stat(s, FREE_SLOWPATH);
 	}
 
+	llnode = llist_del_all(&dpw->objects_kfence);
+	llist_for_each_safe(pos, t, llnode) {
+		void *obj = kfence_llnode_to_obj(pos);
+
+		__kfence_free(obj);
+	}
+
 	llnode = llist_del_all(&dpw->objects_by_rcu);
 	llist_for_each_safe(pos, t, llnode) {
 		void *head = pos;
@@ -6431,6 +6440,21 @@ static void defer_free(struct kmem_cache *s, void *obj)
 		irq_work_queue(&dpw->work);
 }
 
+static void defer_free_kfence(void *obj)
+{
+	struct deferred_percpu_work *dpw;
+	struct llist_node *llnode;
+
+	/* kasan_reset_tag() is not necessary, kfence objects are not tagged */
+	llnode = kfence_obj_to_llnode(obj);
+
+	guard(preempt)();
+
+	dpw = this_cpu_ptr(&deferred_percpu_work);
+	if (llist_add(llnode, &dpw->objects_kfence))
+		irq_work_queue(&dpw->work);
+}
+
 void defer_kfree_rcu(struct kvfree_rcu_head *head)
 {
 	struct deferred_percpu_work *dpw;
@@ -6758,10 +6782,13 @@ EXPORT_SYMBOL(kfree);
 /*
  * Can be called while holding raw_spinlock_t or from IRQ and NMI,
  * but ONLY for objects allocated by kmalloc_nolock().
- * Debug checks (like kmemleak and kfence) were skipped on allocation,
- * hence
+ *
+ * In case kmemleak is enabled,
+ *
  * obj = kmalloc(); kfree_nolock(obj);
- * will miss kmemleak/kfence book keeping and will cause false positives.
+ *
+ * will miss kmemleak book keeping and will cause false positives.
+ *
  * large_kmalloc is not supported either.
  */
 void kfree_nolock(const void *object)
@@ -6793,6 +6820,12 @@ void kfree_nolock(const void *object)
 	 * since they take spinlocks or not safe from any context.
 	 */
 	kmsan_slab_free(s, x);
+
+	if (is_kfence_address(x)) {
+		defer_free_kfence(x);
+		return;
+	}
+
 	/*
 	 * If KASAN finds a kernel bug it will do kasan_report_invalid_free()
 	 * which will call raw_spin_lock_irqsave() which is technically

-- 
2.55.0


