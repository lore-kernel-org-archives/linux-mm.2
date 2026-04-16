Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2518CF8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8886B6B0098; Thu, 16 Apr 2026 05:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8398E6B0099; Thu, 16 Apr 2026 05:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7761A6B009B; Thu, 16 Apr 2026 05:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA956B0098
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:10:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1D041A0834
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:53 +0000 (UTC)
X-FDA: 84663849186.06.21B7BC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0825F40012
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u3vUv6PN;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLXVtFQOz4phd9VhHo+ukCAixUOGfAVgeJTMIQnM7E0=;
	b=iMLd+IEUZil16FjkEfMUid0GSyN/U5PW9jLbS+d+VmNcdGrfVXViFfqMOm2lPFQ19AvXTC
	oqu6rGjaXgxJheVaES8k/NxzAhoG8dI4onqMObCu/O3v7FOJr4VT6ioEeuwJfFiap4OKUL
	wSVaO9GqDnUlITxw0bSBb0cUXtfx+Ck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330652; a=rsa-sha256;
	cv=none;
	b=zs3YOLe/wpl99jEQat60pEXMrR8y0QmH2cfrqnA+MmA1FYAEOVp+4CPtnS34RvmPrvthCS
	9roWMr2Cj0FZhXWTGJai032kvFdpOAfh2CAy8yYaLUj8mLas7+nkcOJLi8/a3NlG7y9wvc
	HnbmbBwD4HHLmWFEhR2GF+oCmU6vX6A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u3vUv6PN;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AC314439F;
	Thu, 16 Apr 2026 09:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26590C2BCB6;
	Thu, 16 Apr 2026 09:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330651;
	bh=KVtcHV6ZDZO1rs/63QPo3Nc9xkoqRGLE5wgjSTGCkzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3vUv6PNEGqBNMbFhjMIOq/G7s+LtiA0lrMsvWv8GNiaqEbyUD1Fd1NmdozSixtAs
	 y8xG2GmF+RePfAnvoGy2hxAouu/b6nKgtTbbZ2eIp1hmJsez9gtEp5K14DhY/MOZ7W
	 QybgOBYVgkfFIXSj3aAlRHKfFMehWHRomQYy5iMBQTZ+eyrRkKDHfxz94+LZKHMlti
	 /p7zExWnGfEOBU8I51QtIbfcncoqXDl4FibuAoBF/TDGt4pdL5hknrHxiyKoutdxz0
	 8+B/iVMKlcjX9yEjg5+ULWTP6CsH+p94YUzD4ateQ8E9+eRRjgoob2shhLyA1dxR23
	 8BWWUpPBT8SvA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/8] mm/slab: introduce deferred submission of rcu sheaves
Date: Thu, 16 Apr 2026 18:10:21 +0900
Message-ID: <20260416091022.36823-8-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260416091022.36823-1-harry@kernel.org>
References: <20260416091022.36823-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0825F40012
X-Rspamd-Server: rspam07
X-Stat-Signature: wzmztj56op55faeubtbmy33m393uhiad
X-Rspam-User: 
X-HE-Tag: 1776330651-922617
X-HE-Meta: U2FsdGVkX1+BThgkdfnyqTPhCzugiV43Be/ma+3w0V6U4BIO1j/8xDKF0Hft7iSyQYVOFTfMC9He453OoeMc1B4/Q6FDyLC1umIbehM7mBuI73PReDST3NuBy1oko0E0ZA0ZBbxW2LPRLhAM89sKvzVCtchjS8c/vObSGxg0CyJpJHASXKBpqzphpMxMTJWt79hz4kMurRtmWdhOsqru+X6skvVmi6Y4nFzxqD2REkVtF6L9Sl/F1szIF0MjtZdzLzt8cUh8//v1pKmJjuYIomcHPVzjE48X3532G/fBeERC89ztiAEiUBQgc5Gf7de4T5KZOpVYPf3MLvEDLcECwDanH2DGwiNzx22zrUioEd4rpjwJt2X2NAjlRzQhz+5qmJylUccGNxDCma6soEOm6Q3IA2/jeywRreaOvQ5F8IFUOP2jH1c40Tpqi9yqk6wElClhUcIKBS3IsslU/Fu76uMJdV/knxRqv9WNFnJ8HwMnkjsuf+fzdhMfuECt161NOSM06GJmr/pEJe7nUvrpNpPyTwsraF7FcxCncPva/yd7NIIuKZpck2XZet3aEWq1NAUvjYVxlIZRrEj9oKnUYsHYw0GyWwVVE9+QLZ2XhUs6qfbdXtJZvUq3v0cQlINrjnJ1mBTqWptVt4bxy2AwPSJ23K0wRHFpgWajL/3t/5yd7d9SScViMqPgUElGxbOf5qLV7WC65x24Cma8DXimOPsFXpBwR6HpdblaW2KtklrLUMXZe5DsP9oYybZgZ6YKKlWRye8NG6bSPNPguooHKO0M166oYPQKw4VvRcfGcz2ZppvdZlkFVotf5Sw/k26iQ9OxsMe9R6KenxiXbUCDn+ugfZsIJBV1Z0hHwxBX/3O74SBjTbVczuyABK99FPc2c/6jwO9L8ibtEwcZAaX2Q0tgQwUPs5DXDiGKK0MwBeKdwBehc2i+01w/LEIJukppAazMImwJSLdDCaXFkg2
 cwgCbf19
 x05t3UwD2ABZXeMr53e52LSL732FNsdu+2gnrHfZIt3QZcQ4M3f5G++B2fN5PxjJsr8G69J4DH1m6IHBPj+KqB9uAI3NX2J9FQRcNE1zh2XmgcTOp0opzq5400sm+8yWNhtu8utK4mgYp+HeXhBdYIahFJHDHzLAuBckkMVWeogWb4wL7zcEYvVt1KbuzdjDC8hpN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of falling back when the rcu sheaf becomes full, implement
deferred submission of rcu sheaves. If kfree_rcu_sheaf() is invoked
by kfree_rcu_nolock() (!allow_spin) and IRQs are disabled, the CPU might
be in the middle of call_rcu() and thus defer call_rcu() with irq_work.

Submit all deferred RCU sheaves to call_rcu() before calling
rcu_barrier() to ensure the promise of kvfree_rcu_barrier().

An alternative approach could be to implement this in the RCU subsystem,
tracking if it's safe to call call_rcu() and allowing falling back to
deferred call_rcu() at the cost of more expensive rcu_barrier() calls.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab.h        |  2 ++
 mm/slab_common.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++--
 mm/slub.c        | 12 ++++--------
 3 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index bdad5f389490..9ba3aad1eeb2 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -411,6 +411,8 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 
 #ifdef CONFIG_KVFREE_RCU_BATCHED
 bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin);
+void rcu_free_sheaf(struct rcu_head *head);
+void submit_rcu_sheaf(struct rcu_head *head, bool allow_spin);
 void flush_all_rcu_sheaves(void);
 void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 #endif
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 347e52f1538c..226009b10c4a 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1314,8 +1314,11 @@ struct kfree_rcu_cpu {
 	// Objects queued on a lockless linked list, used to free objects
 	// in unknown contexts when trylock fails.
 	struct llist_head defer_head;
-
 	struct irq_work defer_free;
+
+	struct llist_head defer_call_rcu_head;
+	struct irq_work defer_call_rcu;
+
 	struct irq_work sched_delayed_monitor;
 	struct irq_work run_page_cache_worker;
 
@@ -1345,11 +1348,14 @@ struct kfree_rcu_cpu {
 static void defer_kfree_rcu_irq_work_fn(struct irq_work *work);
 static void sched_delayed_monitor_irq_work_fn(struct irq_work *work);
 static void run_page_cache_worker_irq_work_fn(struct irq_work *work);
+static void defer_call_rcu_irq_work_fn(struct irq_work *work);
 
 static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
 	.lock = __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
 	.defer_head = LLIST_HEAD_INIT(defer_head),
 	.defer_free = IRQ_WORK_INIT(defer_kfree_rcu_irq_work_fn),
+	.defer_call_rcu_head = LLIST_HEAD_INIT(defer_call_rcu_head),
+	.defer_call_rcu = IRQ_WORK_INIT(defer_call_rcu_irq_work_fn),
 	.sched_delayed_monitor =
 		IRQ_WORK_INIT_LAZY(sched_delayed_monitor_irq_work_fn),
 	.run_page_cache_worker =
@@ -1374,8 +1380,12 @@ void defer_kvfree_rcu_barrier(void)
 {
 	int cpu;
 
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
 		irq_work_sync(&per_cpu_ptr(&krc, cpu)->defer_free);
+#ifdef CONFIG_KVFREE_RCU_BATCHED
+		irq_work_sync(&per_cpu_ptr(&krc, cpu)->defer_call_rcu);
+#endif
+	}
 }
 
 static void *object_start_addr(void *ptr)
@@ -1524,6 +1534,21 @@ static void sched_delayed_monitor_irq_work_fn(struct irq_work *work)
 	schedule_delayed_monitor_work(krcp);
 }
 
+static void defer_call_rcu_irq_work_fn(struct irq_work *work)
+{
+	struct kfree_rcu_cpu *krcp;
+	struct llist_node *llnode, *pos, *t;
+
+	krcp = container_of(work, struct kfree_rcu_cpu, defer_call_rcu);
+
+	if (llist_empty(&krcp->defer_call_rcu_head))
+		return;
+
+	llnode = llist_del_all(&krcp->defer_call_rcu_head);
+	llist_for_each_safe(pos, t, llnode)
+		call_rcu((struct rcu_head *)pos, rcu_free_sheaf);
+}
+
 static __always_inline void
 debug_rcu_bhead_unqueue(struct kvfree_rcu_bulk_data *bhead)
 {
@@ -2187,6 +2212,26 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin)
 }
 EXPORT_SYMBOL_GPL(kvfree_call_rcu_ptr);
 
+static inline void defer_call_rcu(struct rcu_head *head)
+{
+	struct kfree_rcu_cpu *krcp;
+
+	VM_WARN_ON_ONCE(!irqs_disabled());
+
+	krcp = this_cpu_ptr(&krc);
+	if (llist_add((struct llist_node *)head, &krcp->defer_call_rcu_head))
+		irq_work_queue(&krcp->defer_call_rcu);
+}
+
+void submit_rcu_sheaf(struct rcu_head *head, bool allow_spin)
+{
+	/* Might be in the middle of call_rcu(), defer it */
+	if (unlikely(!allow_spin && irqs_disabled()))
+		defer_call_rcu(head);
+	else
+		call_rcu(head, rcu_free_sheaf);
+}
+
 static inline void __kvfree_rcu_barrier(void)
 {
 	struct kfree_rcu_cpu_work *krwp;
diff --git a/mm/slub.c b/mm/slub.c
index 91b8827d65da..1c3451166498 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4152,6 +4152,8 @@ static int slub_cpu_dead(unsigned int cpu)
 			__pcs_flush_all_cpu(s, cpu);
 	}
 	mutex_unlock(&slab_mutex);
+
+	/* pending IRQ work should have been flushed before going offline */
 	return 0;
 }
 
@@ -5847,7 +5849,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
 }
 
 #ifdef CONFIG_KVFREE_RCU_BATCHED
-static void rcu_free_sheaf(struct rcu_head *head)
+void rcu_free_sheaf(struct rcu_head *head)
 {
 	struct slab_sheaf *sheaf;
 	struct node_barn *barn = NULL;
@@ -5999,12 +6001,6 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
 	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
 		rcu_sheaf = NULL;
 	} else {
-		if (unlikely(!allow_spin)) {
-			/* call_rcu() cannot be called in an unknown context */
-			rcu_sheaf->size--;
-			local_unlock(&s->cpu_sheaves->lock);
-			goto fail;
-		}
 		pcs->rcu_free = NULL;
 		rcu_sheaf->node = numa_node_id();
 	}
@@ -6014,7 +6010,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
 	 * flush_all_rcu_sheaves() doesn't miss this sheaf
 	 */
 	if (rcu_sheaf)
-		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
+		submit_rcu_sheaf(&rcu_sheaf->rcu_head, allow_spin);
 
 	local_unlock(&s->cpu_sheaves->lock);
 
-- 
2.43.0


