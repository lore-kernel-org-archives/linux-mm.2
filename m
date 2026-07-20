Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4341FC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3E96B0096; Mon, 20 Jul 2026 08:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DBC6B00A6; Mon, 20 Jul 2026 08:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E036B00A7; Mon, 20 Jul 2026 08:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB726B0096
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:46:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8266C140154
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:46:06 +0000 (UTC)
X-FDA: 85009127532.30.17AB8DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C2500180004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:46:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEWY2lrj;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2r5dY/zdCbyFplpp0JiAH+XUKzLBzbYJJk8npBgjXI=;
	b=tzcTvm7210dg/Y5E8TKG3eL7d0UcgTqNDSGARuvXnHlmQgG2OlBqm0Pqbmu6c7Y2OhEADN
	je3LEfFvihHwGhpnkbxXSvtEgb7nFkXVh9xBAb5bChG8w0W1+fUQERK4LFSZ/1xG4k60GY
	6nsQ3+Tm2ZYumrXN1fLsanPGSGFTnho=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551564;
	b=ZvaWhHOf8FOC0L6+kP18ElH2h7TTzhrqkfRvtfAp6NaH87MizSS1MGrEsbF/VbrWC8T2K0
	kW4ikdEmC3MfE04sOgUWssg+Z83cGdpB8usDE3T6BhusDa6aNX3RN1c3fcMEoxaXWgih6+
	cya6cuc21FFdXEX9dwuMYGibpjrYu3w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEWY2lrj;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 17A1840883;
	Mon, 20 Jul 2026 12:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724DC1F00A3E;
	Mon, 20 Jul 2026 12:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551564;
	bh=U2r5dY/zdCbyFplpp0JiAH+XUKzLBzbYJJk8npBgjXI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EEWY2lrjXo3Hkbn+9x22TcF418OoNqFOV8MhNW/Adjsg41DzPs4zfk7zQbcepY8Z5
	 ngFGVemytDm9/OwBDC6YJMXWt6fDzXM4Vq4ko/SKYPdywr/8aZ0KeYgwYXBUTeGsAE
	 aZ+atV6a2ZISJakGiYzAapPRTfhoWER0VND6hhHXy103AByrKZLppXX60wCkKzkQ8m
	 EsyXXkqjXpd0jPI7476cvxFG2r9Ytaz7jDKrDWIN1s2A53VHsfakTdVQxtwPy/QCuD
	 KYRUWZ1WNGHFlgKHLDIPIcFbG8Vy+H3AfWw9M7/Xm+aiSDtwOH9L98sd157mjlgXRI
	 4boNrLUarPrmQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 20 Jul 2026 21:44:35 +0900
Subject: [PATCH slab/for-next v4 6/8] mm/slab: introduce struct
 kvfree_rcu_head for kvfree_rcu batching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kfree_rcu_nolock-v4-6-964e03c41a4e@kernel.org>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C2500180004
X-Stat-Signature: kipbue4bcu5zmwxhaxqb6c1y3qfefqsj
X-Rspam-User: 
X-HE-Tag: 1784551564-68749
X-HE-Meta: U2FsdGVkX1+/HjJoJiPUpgzLlfSj6EHYMI/aDOS1URo0BxMnIzKhiaRbQ2wFMzZqaOEZwQ8U6QfP+bO7pKqJkk8f+TXKwdTbplnBg3Mj8FiISI+IF4+ieJ8eh6YyH8QGSX8ZdRtfrH0hy+1Bt5Ybx8qb6PafUJ7umf4RJuskb+QVGIeIAvgglRk4VGMy7kdNQYLYtTRF9K4yQbMkwV2P3dDlrCxGdqY80KEsZ6BKloE6KOjHLU979XwXUa1mLm6tSNYBpk0nCXnmAknK6PJ22Bd71GQS3EQRjaAaou+LoNB53qb59PTYNNn9IcvaFmZn3p5TKdYHpgtacCWekCopo+VipZRLM9zGnjYADN5hUGAArxA6+7KxxdiskCiWmVY2yG5RdI6TcxdldHaES373571LT6QF+UPdcbLEuuqmZTGmQEHTF2Gr+/lNgnEakoXk98YOE6IzxzuvTj0pa5N7Bobo0c521hD0Z20wLRzGGA+fhL1T10NoCi0QG1wZhdfiDSxePSbA1Nsdqc4VjqUp7OW/MnfY9wfQA6RcpPKqy5UyXpTnrhjNpwNZoNDQ2k4+L2dc1im35W9qciEeH7w33FpCkgl3zbJ8m+kDdky1MBs0Nr+1P6Lh7pqSjGpHmsPgGk4HKiFYH7ohNs6hnLZX3w9l+gfKqmb9WKAecJpwDZoTkbDb9w6jw55BI1Fht2oKTQ+5Ku4+AMzeWy+nLzNZZnqorWQAqGACYv0K4fjPtI1kgLmmmVml9+CmQDvCSPZftNs1Y9OO9IoVqxIa6t1B12qDHMNEbFXLggjM5JP2q7NIWqrTBBlxxUsAEtZIiYTSg3EP3y4FLAaUdWNn1v1Ieq2y5phU6pX1oLvzUJw4wjBaisYTHMnPNDOuwtt59hQU/qxXCSuGLaFiOtKTF3rX3ZeM/0HX7iWJXsiwDX7oBZ8QZZ4QmoKGxO5wnhDIbAMryMxIi64RS9ynF0qDZpe
 aYK4Qs1u
 FRFhFslhZISxV1K+mLy7R6x6js9oBdT92FpHJakqLhD6CwxO3f9Ctjd2/+0YrofGdQlf6I31l3iCRrmNaDcrgy0VXMvn3begFSSqxoPO1/7jC39+MC8AX0UEPGjDwUWhTeccrN5bRHv4XQMe98tM8tGCGoWct7OpmgSWkUB/qBJbPwcbtOVG1elrZbd+E004hQwgblaiJNR3JnAOFnQkwpV10ua4FsTjwsmjMQBxnpoFhK7EvRCpZjuMI0Et1iH/Hi5+TM6XuT5RXvUBvcyaJ5cErUjUpG3jsG9Roe92XLJEGXuw=
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
kvmalloc_obj_start_addr().

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 include/linux/rcupdate.h   | 10 ++++++----
 include/linux/types.h      |  8 ++++++++
 include/trace/events/rcu.h |  2 +-
 mm/slab.h                  | 28 ++++++++++++++++++++++++++++
 mm/slab_common.c           | 17 ++++++++---------
 mm/slub.c                  | 40 +++++++++-------------------------------
 6 files changed, 60 insertions(+), 45 deletions(-)

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
index fdd293b3efa5..1efeaceb7db3 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -351,6 +351,33 @@ static inline int objs_per_slab(const struct kmem_cache *cache,
 	return slab->objects;
 }
 
+/* kvfree_rcu_head offset can be only less than page size */
+static inline void *kvmalloc_obj_start_addr(void *head)
+{
+	void *obj = head;
+
+	if (unlikely(is_vmalloc_addr(obj))) {
+		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
+	} else {
+		struct page *page = virt_to_page(obj);
+		struct slab *slab = page_slab(page);
+
+		if (!slab) {
+			obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
+		} else if (is_kfence_address(obj)) {
+			obj = kfence_object_start(obj);
+		} else {
+			struct kmem_cache *s = slab->slab_cache;
+			unsigned int idx = __obj_to_index(s, slab_address(slab), obj);
+
+			obj = slab_address(slab) + s->size * idx;
+			obj = fixup_red_left(s, obj);
+		}
+	}
+
+	return obj;
+}
+
 /*
  * State of the slab allocator.
  *
@@ -761,6 +788,7 @@ void __check_heap_object(const void *ptr, unsigned long n,
 			 const struct slab *slab, bool to_user);
 
 void deferred_work_barrier(void);
+void defer_kfree_rcu(struct kvfree_rcu_head *head);
 
 static inline bool slub_debug_orig_size(struct kmem_cache *s)
 {
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8c631bf97cd5..c1c32909fa52 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1346,7 +1346,7 @@ struct kvfree_rcu_bulk_data {
 
 struct kfree_rcu_cpu_work {
 	struct rcu_work rcu_work;
-	struct rcu_head *head_free;
+	struct kvfree_rcu_head *head_free;
 	struct rcu_gp_oldstate head_free_gp_snap;
 	struct list_head bulk_head_free[FREE_N_CHANNELS];
 	struct kfree_rcu_cpu *krcp;
@@ -1382,7 +1382,7 @@ struct kfree_rcu_cpu_work {
 struct kfree_rcu_cpu {
 	// Objects queued on a linked list
 	// through their rcu_head structures.
-	struct rcu_head *head;
+	struct kvfree_rcu_head *head;
 	unsigned long head_gp_snap;
 	atomic_t head_count;
 
@@ -1523,12 +1523,12 @@ kvfree_rcu_bulk(struct kfree_rcu_cpu *krcp,
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
@@ -1552,7 +1552,7 @@ static void kfree_rcu_work(struct work_struct *work)
 	unsigned long flags;
 	struct kvfree_rcu_bulk_data *bnode, *n;
 	struct list_head bulk_head[FREE_N_CHANNELS];
-	struct rcu_head *head;
+	struct kvfree_rcu_head *head;
 	struct kfree_rcu_cpu *krcp;
 	struct kfree_rcu_cpu_work *krwp;
 	struct rcu_gp_oldstate head_gp_snap;
@@ -1683,7 +1683,7 @@ kvfree_rcu_drain_ready(struct kfree_rcu_cpu *krcp)
 {
 	struct list_head bulk_ready[FREE_N_CHANNELS];
 	struct kvfree_rcu_bulk_data *bnode, *n;
-	struct rcu_head *head_ready = NULL;
+	struct kvfree_rcu_head *head_ready = NULL;
 	unsigned long flags;
 	int i;
 
@@ -1946,7 +1946,7 @@ void __init kfree_rcu_scheduler_running(void)
  * be free'd in workqueue context. This allows us to: batch requests together to
  * reduce the number of grace periods during heavy kfree_rcu()/kvfree_rcu() load.
  */
-void kvfree_call_rcu(struct rcu_head *head, void *ptr)
+void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr)
 {
 	unsigned long flags;
 	struct kfree_rcu_cpu *krcp;
@@ -1984,7 +1984,6 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 			// Inline if kvfree_rcu(one_arg) call.
 			goto unlock_return;
 
-		head->func = ptr;
 		head->next = krcp->head;
 		WRITE_ONCE(krcp->head, head);
 		atomic_inc(&krcp->head_count);
diff --git a/mm/slub.c b/mm/slub.c
index deac315d0f23..d0976396d703 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6699,43 +6699,21 @@ static void free_large_kmalloc(struct page *page, void *object)
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


