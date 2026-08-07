Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07820C5ACAB
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 13:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3826B0096; Fri,  7 Aug 2026 09:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19ACF6B0098; Fri,  7 Aug 2026 09:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7E56B0099; Fri,  7 Aug 2026 09:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5EBD6B0096
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:51:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 670F81203AC
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:51:07 +0000 (UTC)
X-FDA: 85074609774.15.E90E7A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A1CC618000D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:51:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4VSmJSt;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786110665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGBELfa0PNJRa3PvbOBLlp8SGyFGd7t+kM65vGIAZwc=;
	b=Hb0jw1jbpWw+RqF+g9SriUFiA4A5Gxpy2xtYo7IQecaz8m7GmfPaJD9lSZzO7Yx4YOW4be
	WScecnkiLeVskPz3d+2aZfc6e0CEON7VdLnQ+h3U2vg/LCbNyYgfB5ccOGuB7yhtTUTnxL
	0p8qDzarHF4ZbJmiVyoWdSnQLzbmrBw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4VSmJSt;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786110665;
	b=2hy/R/u9KMWSPwYxb84lDo0Um9tcT4B34YFAO15/YviR+bUX8+wEQEoQHzrUXQ4A+Ib8KH
	kiSPhWOA0R1NxmUzmT5ZGHSRTnQYDpPQJMHyWzwCbwZwOt69Vg5LzFsZfqKSZmU2AKwEUL
	tabxdG2ge/KceCGBYk2DvZOEpz2tQjI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB57C43DFA;
	Fri,  7 Aug 2026 13:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7291F00ACF;
	Fri,  7 Aug 2026 13:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786110664;
	bh=UGBELfa0PNJRa3PvbOBLlp8SGyFGd7t+kM65vGIAZwc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=e4VSmJSt73tA02FcE2cwM/eyfhDNj1IybKNAoQq4cuYxrXygc2XXmaK6ICGsSOOuU
	 XmsxUDzNigL3kFl+StJRA1b/0LqYThJmhrHZJYv0q+HgjLVDqkaqaOnqt2eEV3kHAH
	 eS53QQHpPBkK2d5djTzlbNJOR6puKjMDn3qplP1y5aX0E7LA5p/yt3AsewlXAoE+gi
	 0NAmhX9xVb6MpvGI8dK5dxg4I/Vnyr9RRkEgxqW8IOHCUgQL72FE88sJU+4wEbiZDp
	 VMBnUWwtd+bbroav/X3QGzfJXLxMuZKj05+itt98UINUISZpJ6fHQZO4VXRWTIX8zv
	 N0Ng6BuX6uueQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 07 Aug 2026 15:50:30 +0200
Subject: [PATCH RFC 4/5] mm/slab: handle large_kmalloc objects in
 kfree_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-kfree_nolock_kmalloc-v1-4-ba993cbf7a60@kernel.org>
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
X-Stat-Signature: 8zk565h8xjcfwxqafu7dqefmt8dzpcrn
X-Rspamd-Queue-Id: A1CC618000D
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786110665-450488
X-HE-Meta: U2FsdGVkX1/dlZ9r4lqJjJM+wf2F56Zh9M4fT3wVypsLcbFYubs2nHA6twTw5xVeweogEkCAF4DnyV0tGA4DSVnoc4T4dyxnQd0m5bsjf24CzqCfafo1U6oByAmxI1MIKoOPr7q10T6WRJlfrHHj595Q0t/pt1aE3T7ysFcJORLEz8oA89GyNCek9bBTJ8yLOwZa6RowORh0naaDP8LgR9QNWyy4/4AM33TM4k8QLI9joaAItWsuQpckK8CK/5wzdRHGWKdt4a+VMCQcfSvsRNIzqBLcrF2NOlqjFp21Eh+sWzCkjUpBly/ZXtarO0N4jrQExl731K5dlCETAX4TdiS3vFxGjLOm6Ybg1o6uTNsd1Lz5KLlK0A3Iwmm4JBpYjf6TGwAdloHsVVApwJLYxeTNIhL3BAK1rs+sw9FLFqNbX/R4izb/lhukPx5D1egWWDVwm2hIGofQN1QNWESonv/vA+wJo0ftBetzZ2wZlm/1qysOa2XvsirTl0w2zotu6TQS2J8X/elix7oYsNQ5SuKXqSo9WBCMYTg9pElzEBJvz5LhsqJm5qvrXftXrYYwkI+xFA34gDAnQKgxp1Bfy1CtSszFEAfqX13MYNtJRFM4JB/pvb7d1c5zGlHMOkGJPdaVBQ//YwIu3irHq1J6juUe6zN3l68M4A9QUPTIvfnPkoGwNuWI6nrJkg1xW1YSzgV6/EHvtiN2JCtM83cPZNEJqfMz5APd2wEwN2bboGJTBYcX6RBHFLN5xul1KpZ5N5Jz3es4TLmq89pzhk3W5gtdgLlqizQnXt5p6ebt/BPZ/6u55VaSMQTO4sxfwuwQWIpfiYm+6p7mf/RCwitpYbpa1fKuzOL5DfujcwTkUbSFImfM0XHb3oBM+AQeVnynTr8JDelU/K732PVEzSkyOgjfILznV2nqXOT15SwUuI+FfxljdVTpi8DaWzLIAv/3Dolv2yK7nKFnsClGNOz
 1OuXAaWm
 e48anrJJ94bx6sBSDhlRGQcRqUGO1aBy2IvXKRXI4304kWL02HJgFyev1Ari5+AHKLjtiy6EuLwAT/LiOB2JqE6SNbo1dBc7Qk+uWN/9rHFQMBbaKnu6Ppv3RVyGLqLJKDwYWs/LFp2rug80jdKVf2yBpX08TZIpCVgRfWerBimUM+mtLFK7S6u/+R7KiybA+FlzSA0cYYFwh2yWq16KhsvU85Zq/bB71jfoe9lu9+/IHqTWd72D9yd6wuLRIihfKOJSdxx8fd1B0P6liwfyQUBoNpb1N0n7cUzuFdGyE2ddATuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Large kmalloc objects is the only remaining case that kfree_nolock()
cannot handle from kmalloc() allocations. Note kmalloc_nolock() does not
return large kmalloc objects.

Supporting them is however mostly straigtforward. free_large_kmalloc()
calls kmsan and kasan hooks that should be safe and similar to those
called in kfree_nolock(). Freeing the pages can be handled by
free_frozen_pages_nolock().

The only obstacle is kmemleak_free(), which we can solve by deferring
when necessary, the same way as done for small kmalloc objects.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 62 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 423b5bdb910b..3be98faa9f0d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4051,6 +4051,7 @@ static void flush_all(struct kmem_cache *s)
 struct deferred_percpu_work {
 	struct llist_head objects;
 	struct llist_head objects_kfence;
+	struct llist_head objects_large_kmalloc;
 	struct llist_head objects_by_rcu;
 	struct llist_head rcu_sheaves;
 	struct irq_work work;
@@ -4061,6 +4062,7 @@ static void deferred_percpu_work_fn(struct irq_work *work);
 static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
 	.objects = LLIST_HEAD_INIT(objects),
 	.objects_kfence = LLIST_HEAD_INIT(objects_kfence),
+	.objects_large_kmalloc = LLIST_HEAD_INIT(objects_large_kmalloc),
 	.objects_by_rcu = LLIST_HEAD_INIT(objects_by_rcu),
 	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
 	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
@@ -6365,6 +6367,21 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	}
 }
 
+static inline void
+__free_large_kmalloc_page(struct page *page, unsigned int free_flags)
+{
+	unsigned int order = compound_order(page);
+
+	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+			      -(PAGE_SIZE << order));
+	__ClearPageLargeKmalloc(page);
+
+	if (free_flags & SLAB_FREE_NOLOCK)
+		free_frozen_pages_nolock(page, order);
+	else
+		free_frozen_pages(page, order);
+}
+
 /*
  * In PREEMPT_RT irq_work runs in per-cpu kthread, so it's safe
  * to take sleeping spin_locks from __slab_free().
@@ -6417,6 +6434,15 @@ static void deferred_percpu_work_fn(struct irq_work *work)
 		__kfence_free(obj);
 	}
 
+	llnode = llist_del_all(&dpw->objects_large_kmalloc);
+	llist_for_each_safe(pos, t, llnode) {
+		struct page *page = virt_to_page(pos);
+
+		kmemleak_free(pos);
+
+		__free_large_kmalloc_page(page, SLAB_FREE_DEFAULT);
+	}
+
 	llnode = llist_del_all(&dpw->objects_by_rcu);
 	llist_for_each_safe(pos, t, llnode) {
 		void *head = pos;
@@ -6464,6 +6490,24 @@ static void defer_free_kfence(void *obj)
 		irq_work_queue(&dpw->work);
 }
 
+static void defer_free_large_kmalloc(void *obj)
+{
+	struct deferred_percpu_work *dpw;
+	struct llist_node *llnode;
+
+	/*
+	 * we can simply use the first word of the large kmalloc object
+	 * for the llnode, as there's no ctor or TYPESAFE_BY_RCU
+	 */
+	llnode = kasan_reset_tag(obj);
+
+	guard(preempt)();
+
+	dpw = this_cpu_ptr(&deferred_percpu_work);
+	if (llist_add(llnode, &dpw->objects_large_kmalloc))
+		irq_work_queue(&dpw->work);
+}
+
 void defer_kfree_rcu(struct kvfree_rcu_head *head)
 {
 	struct deferred_percpu_work *dpw;
@@ -6712,9 +6756,11 @@ size_t ksize(const void *objp)
 }
 EXPORT_SYMBOL(ksize);
 
-static void free_large_kmalloc(struct page *page, void *object)
+static void free_large_kmalloc(struct page *page, void *object,
+			       unsigned int free_flags)
 {
 	unsigned int order = compound_order(page);
+	bool nolock = free_flags & SLAB_FREE_NOLOCK;
 
 	if (WARN_ON_ONCE(!PageLargeKmalloc(page))) {
 		dump_page(page, "Not a kmalloc allocation");
@@ -6724,14 +6770,16 @@ static void free_large_kmalloc(struct page *page, void *object)
 	if (WARN_ON_ONCE(order == 0))
 		pr_warn_once("object pointer: 0x%p\n", object);
 
-	kmemleak_free(object);
+	if (!nolock)
+		kmemleak_free(object);
+
 	kasan_kfree_large(object);
 	kmsan_kfree_large(object);
 
-	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
-			      -(PAGE_SIZE << order));
-	__ClearPageLargeKmalloc(page);
-	free_frozen_pages(page, order);
+	if (unlikely(nolock && kmemleak_may_need_free(object)))
+		defer_free_large_kmalloc(object);
+	else
+		__free_large_kmalloc_page(page, free_flags);
 }
 
 /*
@@ -6753,7 +6801,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
 		if (slab)
 			slab_free(slab->slab_cache, slab, obj, _RET_IP_);
 		else
-			free_large_kmalloc(page, obj);
+			free_large_kmalloc(page, obj, SLAB_FREE_DEFAULT);
 	}
 }
 
@@ -6779,7 +6827,7 @@ void kfree(const void *object)
 	slab = page_slab(page);
 	if (!slab) {
 		/* kmalloc_nolock() doesn't support large kmalloc */
-		free_large_kmalloc(page, (void *)object);
+		free_large_kmalloc(page, (void *)object, SLAB_FREE_DEFAULT);
 		return;
 	}
 
@@ -6793,10 +6841,11 @@ EXPORT_SYMBOL(kfree);
  * but may defer freeing to irq_work() in some cases.
  *
  * Intended mainly for objects allocated from kmalloc_nolock(), but can handle
- * also kmem_cache_alloc() and kmalloc() objects, except large_kmalloc.
+ * also kmem_cache_alloc() and kmalloc() objects, including large_kmalloc.
  */
 void kfree_nolock(const void *object)
 {
+	struct page *page;
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *x = (void *)object;
@@ -6804,9 +6853,10 @@ void kfree_nolock(const void *object)
 	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return;
 
-	slab = virt_to_slab(object);
+	page = virt_to_page(object);
+	slab = page_slab(page);
 	if (unlikely(!slab)) {
-		WARN_ONCE(1, "large_kmalloc is not supported by kfree_nolock()");
+		free_large_kmalloc(page, (void *)object, SLAB_FREE_NOLOCK);
 		return;
 	}
 
@@ -7167,7 +7217,7 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 	if (!s) {
 		/* Handle kalloc'ed objects */
 		if (!slab) {
-			free_large_kmalloc(page, object);
+			free_large_kmalloc(page, object, SLAB_FREE_DEFAULT);
 			df->slab = NULL;
 			return size;
 		}

-- 
2.55.0


