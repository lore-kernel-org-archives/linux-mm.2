Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B16DC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98966B00DD; Wed, 29 Jul 2026 10:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65FD6B00E0; Wed, 29 Jul 2026 10:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D196B00E1; Wed, 29 Jul 2026 10:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F61B6B00DE
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:17:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1155512061C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:36 +0000 (UTC)
X-FDA: 85041120192.04.4BA7C12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 55BD014000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oS+hQaMG;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785313294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yh8xxI8IwkcJ1dgmcaV/tWyT7/NE7RNTeAYVA+pLPVw=;
	b=PCa7JXuZWjq3JaO6HCfHpzTXNrMEIE2+dwtqXmjbPZIuCKZgOG7kZp8Kh0PR1IoLiJf/qL
	hLeKEXUDTj3hLuSb0HX+YGcV5f5punk1QDGeWc1Qi06U8VGaVSuqMYfa99gysSet+/cZ9y
	zMiRLU3A8RISBbboN+QbvLSnG0yWte8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785313294;
	b=cAxQ3rixk3/Vw8Ap/3z1SnuIYHF+6j4Wa8m5OhhGkbs0Z2bZdXPiNEM19upOj8euqzKGph
	8PNx46nvhQMS6eFPEReCEb7Ld6HKxg6dLeEOT/RtDKBLQlD5cCdcI0b8gbAoGTz4aoegUO
	2s6bq2xosuUejspYS7UfMTI+1yTxiPo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oS+hQaMG;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF19D43CF0;
	Wed, 29 Jul 2026 08:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6381F000E9;
	Wed, 29 Jul 2026 08:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785313293;
	bh=Yh8xxI8IwkcJ1dgmcaV/tWyT7/NE7RNTeAYVA+pLPVw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oS+hQaMG3f6p6s7y/83Mm3dEGgnbZoVpbILKW5IQqB2FRaoafWmSSfqKJ1GbMEdZw
	 uxBQl02M/lJTnRFU+bZMBp2iulIr8apVlUhWl1X6FVTL2ieZDFRlUNMck5LjkF45CS
	 L7ilohbFxfs1L3NkG04/b1MFVGjsjYR5WITomXWwlB30UlvK9yJMJ3gaS3pEcROlZ+
	 gUGD3pdPjcaoZFilBzsCLlZOW1ERpsSjMTjMk0Uh4Mq3sGRH/NMLQ02fGpMqHpGxPP
	 5ACWQqvBYRgFInQOb3z+G9Ni4GTTl9MqR5Ri4xnNilCBYEfOjWu1C9ZNX7cI/NLRjk
	 6h66VScPdLprQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 29 Jul 2026 17:20:14 +0900
Subject: [PATCH v5 6/8] mm/slab: introduce struct kvfree_rcu_head for
 kvfree_rcu batching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-kfree_rcu_nolock-v5-6-a28cdcda9673@kernel.org>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 55BD014000B
X-Stat-Signature: qpdccbppkj4ghxkta7wj67qdaiyxbm3q
X-Rspam-User: 
X-HE-Tag: 1785313294-307469
X-HE-Meta: U2FsdGVkX1+KFUFryNtyqRZaKh7rpo3QyuGy4M1WUJ9R5FMSVyaqpXHGnFBm6W0qdY2Xkv42fiGrx4HWitqxsWTsepT/wOgE3BHCku12j5eGg2FAJwz+FLrmQcDJlhSXLkgopEExdOltT1y1avG+xfW/FTgihzIpUfs5XMsDpvQJzsnVyj39MQkcV9mDgel9irXU5b2/+gEH4bF70FYNvflBsn+dfSOU4BxEYFcm862J98her2aZM0XLrPT6tzEzxv5yDzH1zmVtLRRWOx+WO9q137mTswCuMjHF4FJHnDZTq1vVJ82KkdM3MO69+SvD13rF1o45yVDaTuJuRUah/TUKCwpozGP1uAt8tE9zs9aqV8+HP5Q2Veze79SNoOQNLX6GX+GhoceuDDvMTMD5WYxddm44aSNsvljb55BAsYvIyP5uNV4opwJla8Qvs7ogtNJxvc9gjhv/ZxKo19YzIYAowcDEH3fUYTuv61WtBCvyD35kX/AsN3RV4C8C5WoYl7n6Z59czdi666uNXsgNa02wctdF7FTe+Hva1uNHLRX7JMIc1uagP9q3eIOGQ2tsTRjreTqaao3aNXXAk8E5CZ6ZIZPunmzMdQKAJcPsPrvWC3PVGh31kTK/me51FW+jtpiqRqOB0RgACY0uGX6MZcjK1uiaQVVREafspHH2lYckmrEZYh+CpjV69lsCosiaojfhghN0xlAxgzIJN+Diw9eeCaWWY9efR7pu7tsFSzcG8BPYpYoEBkTe12jXYlUMwjlYYtfOV0vzRVaV23QbBbWYyy3gKv+7B6/6eMx4cnUBoOyzQ+O4uejqqWF1xZ3LaTAYG3BKT1lSrbL2fQPAh2DlXbQrnOQYixh1il7+Y2DoZZu2J8tEE1OZq4kC0kFJPnn7OwcOV9EwqOa4fj1MPvwKYx4+8SGCyNapbxWdmgDXBde/rgsrh5wUYKNUrr8mIM1HviUA0vEtfkpoEbq
 wmvxvfIz
 b5L6lCuTe8DTyS6JZHSSJRsgRT5rJlssdwTV+fl397fHiSFC/og0jXR76BqqGP0mxpZBbJa1YayEr21608Esg9jv8jP6pTmN71jWpsUjLzjLX1kGJlLKsqiYazmt9E/HLy9hUYKRfUUPqhcc+I//HRBshNNZaoOgVISZSMqitnO9Dt1wnNH0vZk2BCWjnyH3RhuOz30YOSu2ln+suFrmd24grImwa6n4cVKvUTYpHJ22M1/CrsbqkAESGBLHKBtLefoZYQqsN3VU15YPMTwTgI+amehgd8U+oCya21rODBMY8n/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

rcu_head is overkill for kvfree_rcu() because the callback
function is always either kfree(), vfree(), or free_large_kmalloc(),
and thus there is no need for a function pointer.

kvfree_rcu batching reuses the field to store the start address
of an object, however, this is not strictly needed because we can
calculate the start address in the slowpath. For the purpose of
kvfree_rcu batching, it is sufficient to implement a linked list using
a single pointer.

Introduce a new struct called kvfree_rcu_head (the name was suggested
by Vlastimil Babka), which is similar to rcu_head but is only a single
pointer to build a linked list, without a function pointer, when
CONFIG_KVFREE_RCU_BATCHED=y.

When kvfree_rcu is not batched, kvfree_rcu_head is the same size
as rcu_head. Note that shrinking struct kvfree_rcu_head on
CONFIG_KVFREE_RCU_BATCHED=n kernels would inevitably require additional
complexity and also some sort of batching (which defeats the purpose of
the config option) because it cannot fall back to call_rcu().

For now there are no user-visible changes to the API. k[v]free_rcu()
simply casts rcu_head to kvfree_rcu_head. While this does not affect
the API, it allows kfree_rcu_nolock() to reuse kvfree_rcu batching
as a fallback when trylock or sheaf allocation fails.

Stop storing the object pointer in rcu_head.func and instead calculate
the object's start address in kvfree_rcu_list(). Factor out the existing
logic to calculate the start address from kvfree_rcu_cb() to
kvmalloc_obj_start_addr(). To avoid losing the KASAN tag, calculate
the offset and subtract it from the address of the kvfree_rcu_head.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 include/linux/rcupdate.h   | 10 ++++++----
 include/linux/types.h      |  8 ++++++++
 include/trace/events/rcu.h |  2 +-
 mm/slab.h                  | 32 ++++++++++++++++++++++++++++++++
 mm/slab_common.c           | 17 ++++++++---------
 mm/slub.c                  | 40 +++++++++-------------------------------
 6 files changed, 64 insertions(+), 45 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 5e95acc33989..ef5bb6981133 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1098,19 +1098,21 @@ static inline void rcu_read_unlock_migrate(void)
 /*
  * In mm/slab_common.c, no suitable header to include here.
  */
-void kvfree_call_rcu(struct rcu_head *head, void *ptr);
+void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr);
 
 /*
  * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
  * comment of kfree_rcu() for details.
  */
-#define kvfree_rcu_arg_2(ptr, rhf)					\
+#define kvfree_rcu_arg_2(ptr, kvrhf)					\
 do {									\
 	typeof (ptr) ___p = (ptr);					\
+	struct kvfree_rcu_head *___head;				\
 									\
 	if (___p) {							\
-		BUILD_BUG_ON(offsetof(typeof(*(ptr)), rhf) >= 4096);	\
-		kvfree_call_rcu(&((___p)->rhf), (void *) (___p));	\
+		BUILD_BUG_ON(offsetof(typeof(*(ptr)), kvrhf) >= 4096);	\
+		___head = (struct kvfree_rcu_head *) &(___p)->kvrhf;	\
+		kvfree_call_rcu(___head, (void *) (___p));		\
 	}								\
 } while (0)
 
diff --git a/include/linux/types.h b/include/linux/types.h
index 93166b0b0617..8b0976669d66 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -255,6 +255,14 @@ struct callback_head {
 } __attribute__((aligned(sizeof(void *))));
 #define rcu_head callback_head
 
+#ifdef CONFIG_KVFREE_RCU_BATCHED
+struct kvfree_rcu_head {
+	struct kvfree_rcu_head *next;
+};
+#else
+#define kvfree_rcu_head rcu_head
+#endif
+
 typedef void (*rcu_callback_t)(struct rcu_head *head);
 typedef void (*call_rcu_func_t)(struct rcu_head *head, rcu_callback_t func);
 
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 5fbdabe3faea..a74027126a2f 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -625,7 +625,7 @@ TRACE_EVENT_RCU(rcu_invoke_callback,
  */
 TRACE_EVENT_RCU(rcu_invoke_kvfree_callback,
 
-	TP_PROTO(const char *rcuname, struct rcu_head *rhp, unsigned long offset),
+	TP_PROTO(const char *rcuname, struct kvfree_rcu_head *rhp, unsigned long offset),
 
 	TP_ARGS(rcuname, rhp, offset),
 
diff --git a/mm/slab.h b/mm/slab.h
index d13a0f6b7a1b..ec72ed95c21b 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -347,6 +347,37 @@ static inline unsigned int obj_to_index(const struct kmem_cache *cache,
 	return __obj_to_index(cache, slab_address(slab), obj);
 }
 
+/*
+ * kvfree_rcu_head offset can be only less than page size.
+ * Calculate the start address while preserving the KASAN tag.
+ */
+static inline void *kvmalloc_obj_start_addr(void *head)
+{
+	unsigned long offset;
+
+	if (unlikely(is_vmalloc_addr(head))) {
+		offset = offset_in_page(head);
+	} else {
+		struct slab *slab = virt_to_slab(head);
+
+		if (!slab) {
+			offset = offset_in_page(head);
+		} else if (is_kfence_address(head)) {
+			offset = head - kfence_object_start(head);
+		} else {
+			struct kmem_cache *s = slab->slab_cache;
+			unsigned int idx = __obj_to_index(s, slab_address(slab), head);
+			void *obj = slab_address(slab) + s->size * idx;
+
+			obj = fixup_red_left(s, obj);
+			obj = kasan_reset_tag(obj);
+			offset = kasan_reset_tag(head) - obj;
+		}
+	}
+
+	return head - offset;
+}
+
 /*
  * State of the slab allocator.
  *
@@ -910,6 +941,7 @@ void __check_heap_object(const void *ptr, unsigned long n,
 			 const struct slab *slab, bool to_user);
 
 void deferred_work_barrier(void);
+void defer_kfree_rcu(struct kvfree_rcu_head *head);
 
 static inline bool slub_debug_orig_size(struct kmem_cache *s)
 {
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 9c2cca9add89..691ce6db4519 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1379,7 +1379,7 @@ struct kvfree_rcu_bulk_data {
 
 struct kfree_rcu_cpu_work {
 	struct rcu_work rcu_work;
-	struct rcu_head *head_free;
+	struct kvfree_rcu_head *head_free;
 	struct rcu_gp_oldstate head_free_gp_snap;
 	struct list_head bulk_head_free[FREE_N_CHANNELS];
 	struct kfree_rcu_cpu *krcp;
@@ -1415,7 +1415,7 @@ struct kfree_rcu_cpu_work {
 struct kfree_rcu_cpu {
 	// Objects queued on a linked list
 	// through their rcu_head structures.
-	struct rcu_head *head;
+	struct kvfree_rcu_head *head;
 	unsigned long head_gp_snap;
 	atomic_t head_count;
 
@@ -1556,12 +1556,12 @@ kvfree_rcu_bulk(struct kfree_rcu_cpu *krcp,
 }
 
 static void
-kvfree_rcu_list(struct rcu_head *head)
+kvfree_rcu_list(struct kvfree_rcu_head *head)
 {
-	struct rcu_head *next;
+	struct kvfree_rcu_head *next;
 
 	for (; head; head = next) {
-		void *ptr = (void *) head->func;
+		void *ptr = kvmalloc_obj_start_addr(head);
 		unsigned long offset = (void *) head - ptr;
 
 		next = head->next;
@@ -1585,7 +1585,7 @@ static void kfree_rcu_work(struct work_struct *work)
 	unsigned long flags;
 	struct kvfree_rcu_bulk_data *bnode, *n;
 	struct list_head bulk_head[FREE_N_CHANNELS];
-	struct rcu_head *head;
+	struct kvfree_rcu_head *head;
 	struct kfree_rcu_cpu *krcp;
 	struct kfree_rcu_cpu_work *krwp;
 	struct rcu_gp_oldstate head_gp_snap;
@@ -1716,7 +1716,7 @@ kvfree_rcu_drain_ready(struct kfree_rcu_cpu *krcp)
 {
 	struct list_head bulk_ready[FREE_N_CHANNELS];
 	struct kvfree_rcu_bulk_data *bnode, *n;
-	struct rcu_head *head_ready = NULL;
+	struct kvfree_rcu_head *head_ready = NULL;
 	unsigned long flags;
 	int i;
 
@@ -1979,7 +1979,7 @@ void __init kfree_rcu_scheduler_running(void)
  * be free'd in workqueue context. This allows us to: batch requests together to
  * reduce the number of grace periods during heavy kfree_rcu()/kvfree_rcu() load.
  */
-void kvfree_call_rcu(struct rcu_head *head, void *ptr)
+void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr)
 {
 	unsigned long flags;
 	struct kfree_rcu_cpu *krcp;
@@ -2017,7 +2017,6 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 			// Inline if kvfree_rcu(one_arg) call.
 			goto unlock_return;
 
-		head->func = ptr;
 		head->next = krcp->head;
 		WRITE_ONCE(krcp->head, head);
 		atomic_inc(&krcp->head_count);
diff --git a/mm/slub.c b/mm/slub.c
index 6c81722afb18..774104267f3c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6720,43 +6720,21 @@ static void free_large_kmalloc(struct page *page, void *object)
  */
 void kvfree_rcu_cb(struct rcu_head *head)
 {
-	void *obj = head;
-	struct page *page;
-	struct slab *slab;
-	struct kmem_cache *s;
-	void *slab_addr;
+	void *obj;
+
+	obj = kvmalloc_obj_start_addr(head);
 
 	if (is_vmalloc_addr(obj)) {
-		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
 		vfree(obj);
-		return;
-	}
-
-	page = virt_to_page(obj);
-	slab = page_slab(page);
-	if (!slab) {
-		/*
-		 * rcu_head offset can be only less than page size so no need to
-		 * consider allocation order
-		 */
-		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
-		free_large_kmalloc(page, obj);
-		return;
-	}
-
-	s = slab->slab_cache;
-	slab_addr = slab_address(slab);
-
-	if (is_kfence_address(obj)) {
-		obj = kfence_object_start(obj);
 	} else {
-		unsigned int idx = __obj_to_index(s, slab_addr, obj);
+		struct page *page = virt_to_page(obj);
+		struct slab *slab = page_slab(page);
 
-		obj = slab_addr + s->size * idx;
-		obj = fixup_red_left(s, obj);
+		if (slab)
+			slab_free(slab->slab_cache, slab, obj, _RET_IP_);
+		else
+			free_large_kmalloc(page, obj);
 	}
-
-	slab_free(s, slab, obj, _RET_IP_);
 }
 
 /**

-- 
2.53.0


