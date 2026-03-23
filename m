Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79EAEF483E0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC426B009B; Mon, 23 Mar 2026 14:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4146B009D; Mon, 23 Mar 2026 14:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D6B6B009E; Mon, 23 Mar 2026 14:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 20A656B009B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:06:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B360E1EF04
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:25 +0000 (UTC)
X-FDA: 84578107530.30.CD8CA18
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id B993E4000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OTKYDaBp;
	spf=pass (imf04.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774289183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=YrIAk0E6kM3k+vwbXDKbJ/1JrV6mbv/RSjoW+CIn3/s=;
	b=Gs2Dqt2+rH8rhBiY0e2ryHe2GODyU6K5GYqs5yAmCA9gDUXlXQ3XTyQuylEI1lFiEW3Eo4
	LsADuV6lBIwNtO5YmslFjEHjErh2gI8fil/YM2Jzw1CISAczvh+DtrPC5cWsgPu75/aI8y
	VBPfsZjsVYvQ73MQwPAF5L+3x2E8PMw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OTKYDaBp;
	spf=pass (imf04.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774289183; a=rsa-sha256;
	cv=none;
	b=G4YiKrWMnG7iD57IGymT149C3r4oZK+RLPEVjgBw0nPYS1YtRvomFKocKC/0V8JTTlbmPk
	+MimbbsGUmU6B1fBhhd48gBWbudAuHaLa0Jj99YwkSpmo/8W753eHi88WkWBDq5Hy9+8WV
	vSgb9hK/WfTpVQMAZlfMC1zZxO1igIE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774289183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=YrIAk0E6kM3k+vwbXDKbJ/1JrV6mbv/RSjoW+CIn3/s=;
	b=OTKYDaBp/f7vAcL0ZMKzghNrb90kfABdca0HaOEnD5lmdetkKCzsMZUVioUjsQbA1UWkF9
	SNJZYmOSg0XlFgY35ZRyctCbmBv5TEPRWTnJDqap2xsuRlyVtgehKsqOZLSCtTGu4X05MP
	XEfuEkviVZnElKF5MXp0LS9LNXnGNX8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-x5YYlQezMc2zsg-1LcjQAg-1; Mon,
 23 Mar 2026 14:06:19 -0400
X-MC-Unique: x5YYlQezMc2zsg-1LcjQAg-1
X-Mimecast-MFC-AGG-ID: x5YYlQezMc2zsg-1LcjQAg_1774289177
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 383B0195608B;
	Mon, 23 Mar 2026 18:06:17 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63D8119560B1;
	Mon, 23 Mar 2026 18:06:16 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id B830F401F595A; Mon, 23 Mar 2026 15:05:44 -0300 (-03)
Message-ID: <20260323180150.335869265@redhat.com>
User-Agent: quilt/0.69
Date: Mon, 23 Mar 2026 14:55:48 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Leonardo Bras <leobras.c@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>,
 Boqun Feun <boqun.feng@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v3 4/4] slub: apply new queue_percpu_work_on() interface
References: <20260323175544.807534301@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 2bWvzJRD9_pNOblu8L2CHcXV3ciElv97cW0FnbyhVAE_1774289177
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: B993E4000F
X-Stat-Signature: 99eo4ggwm8aqb78z61rgdbedf5ey5tn6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774289183-888690
X-HE-Meta: U2FsdGVkX1+dOjUSZvwSTYvqKTZ75OLGtKow/zTioMzNThDc8lXl5L/6svU3AOliKz5dqLJxwLYTjk6nHuMJiPUNpzLZqs7ml1hOXOvhrSvGunbK1C9kX4gyeoBEyLE9PBVqukPOlUHPkeE447VMQCSfAL5g7+7qs1YTyqC2bgvlHcl882Pjtu95gGOgpfk3NLJkg+NpwQFY2POSioJrefI52Xz3T2KdM6vqHasmFXCQ17wgESTCrQw/0xnZcMSrYYj4Njjywnrd3775wQjc3VTUI1HqzT7/oJ0IrARKDl0DtdD6Jj3fxF5zZnU4D00ckgOIbLLKsezGXToRKdTPnLdOKp8Z0xNTPwglTea7mKyEEW8Lcpc5t4OTA85VLD/SyZAqW7CMuzMzVstwV6oqaqiPPqS5Ktln0Bg3zEfStacRnN6Swdci725V/XbDXjxwv9RfZRm0lA+TyaUDLFVgaAo8wtMiqd+9/p5T1WH6w8yFdlhIkQAFm6dGSlffE2P3ECw2JOfoEJUkOIyphuqw9GJtJnGA6z5Q8b3ILTHZLmj6Xll6FVVQcKqDJmfSC8GgKnvE88vpl9IjfAascQAZz0n0IqK7LgvrvTXQFR3mDpl+bDvIyt/0eTCdtv0RPPyuxZn4SPx4hq4l+xg762P2UiAMsm3xUaVSWQeKjZJ2MI1gWEW67nLJR8xcldYg5vI66Srh82XndWuZMEtgZYtHK949dnHTyxlRNqyoniIE61sngpqO4GngfMVu2KFyMjLI/VGhiQlplDZ3i5SHCQc3gDlB9Qdq0i8PJ2yF9w50kfEvE0QCRRa+Y6bJYA8mTqBS5zITAlPBvjlTNERbS/HE4APiPCLHcsLtmPgXYZ748rIrG+AVhQRWXyqphnBKdRs9jY4jC/15P5MQQsJZUF96OtFH0BdpYzb434StlTDxTdO4eUX6T06HgHTogDHaxY2wCchW2mBdRoSCcBeQ8Li
 g4P+89e6
 813mIx029Qmhdo0MuJp8daH6pUWg9xW1ReuEOSqhPUaeT0iN/54BtnIr5XbCA95cOwBFmBxq4diKTriUMCMPQmdbQH/JSL6fXXn7RMzrR3extnrs/ED0EDUhk3ob/uJIalPLvjadr6N93OQREw/FotxSXfDnJ0EBSnR9MnYubz9CKXdgaJUCQJurFCBtzCRVnseefJJZqHgVjLZE91j4rregiidNwKEP5Q3qeyMS2R2stdZBDs1T3PMdiZhkC76wVHXjkEsMZfsi6qCwVZ14ALDwCTOPBNPAvSkTW32xA99BHBb3Z3bl1LpsmOhBy+7voMGCTMzhi4MvMBpZIuwKry3NO1bzjoHIAjmelDoD4m3J05b1/Ju9Y6QLrn8H1zTyhR4DvR0Y+p0Hz94YfbcwoL7gZDl1FHVBwgCDYEku81wajTb0/SOV7m2Bx/ucNA0Sg1aOE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new qpw_{un,}lock*() and queue_percpu_work_on()
interface to improve performance & latency.

For functions that may be scheduled in a different cpu, replace
local_{un,}lock*() by qpw_{un,}lock*(), and replace schedule_work_on() by
queue_percpu_work_on(). The same happens for flush_work() and
flush_percpu_work().

This change requires allocation of qpw_structs instead of a work_structs,
and changing parameters of a few functions to include the cpu parameter.

This should bring no relevant performance impact on non-QPW kernels:
For functions that may be scheduled in a different cpu, the local_*lock's
this_cpu_ptr() becomes a per_cpu_ptr(smp_processor_id()).

Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 mm/slub.c |  146 +++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 74 insertions(+), 72 deletions(-)

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -50,6 +50,7 @@
 #include <linux/irq_work.h>
 #include <linux/kprobes.h>
 #include <linux/debugfs.h>
+#include <linux/qpw.h>
 #include <trace/events/kmem.h>
 
 #include "internal.h"
@@ -129,7 +130,7 @@
  *   For debug caches, all allocations are forced to go through a list_lock
  *   protected region to serialize against concurrent validation.
  *
- *   cpu_sheaves->lock (local_trylock)
+ *   cpu_sheaves->lock (qpw_trylock)
  *
  *   This lock protects fastpath operations on the percpu sheaves. On !RT it
  *   only disables preemption and does no atomic operations. As long as the main
@@ -157,7 +158,7 @@
  *   Interrupts are disabled as part of list_lock or barn lock operations, or
  *   around the slab_lock operation, in order to make the slab allocator safe
  *   to use in the context of an irq.
- *   Preemption is disabled as part of local_trylock operations.
+ *   Preemption is disabled as part of qpw_trylock operations.
  *   kmalloc_nolock() and kfree_nolock() are safe in NMI context but see
  *   their limitations.
  *
@@ -418,7 +419,7 @@ struct slab_sheaf {
 };
 
 struct slub_percpu_sheaves {
-	local_trylock_t lock;
+	qpw_trylock_t lock;
 	struct slab_sheaf *main; /* never NULL when unlocked */
 	struct slab_sheaf *spare; /* empty or full, may be NULL */
 	struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
@@ -480,7 +481,7 @@ static nodemask_t slab_nodes;
 static struct workqueue_struct *flushwq;
 
 struct slub_flush_work {
-	struct work_struct work;
+	struct qpw_struct qpw;
 	struct kmem_cache *s;
 	bool skip;
 };
@@ -2859,16 +2860,14 @@ static void __kmem_cache_free_bulk(struc
  *
  * Returns how many objects are remaining to be flushed
  */
-static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s)
+static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s, int cpu)
 {
 	struct slub_percpu_sheaves *pcs;
 	unsigned int batch, remaining;
 	void *objects[PCS_BATCH_MAX];
 	struct slab_sheaf *sheaf;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
-
-	pcs = this_cpu_ptr(s->cpu_sheaves);
+	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 	sheaf = pcs->main;
 
 	batch = min(PCS_BATCH_MAX, sheaf->size);
@@ -2878,7 +2877,7 @@ static unsigned int __sheaf_flush_main_b
 
 	remaining = sheaf->size;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
 
 	__kmem_cache_free_bulk(s, batch, &objects[0]);
 
@@ -2887,14 +2886,14 @@ static unsigned int __sheaf_flush_main_b
 	return remaining;
 }
 
-static void sheaf_flush_main(struct kmem_cache *s)
+static void sheaf_flush_main(struct kmem_cache *s, int cpu)
 {
 	unsigned int remaining;
 
 	do {
-		local_lock(&s->cpu_sheaves->lock);
+		qpw_lock(&s->cpu_sheaves->lock, cpu);
 
-		remaining = __sheaf_flush_main_batch(s);
+		remaining = __sheaf_flush_main_batch(s, cpu);
 
 	} while (remaining);
 }
@@ -2908,11 +2907,13 @@ static bool sheaf_try_flush_main(struct
 	bool ret = false;
 
 	do {
-		if (!local_trylock(&s->cpu_sheaves->lock))
+		if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 			return ret;
 
 		ret = true;
-		remaining = __sheaf_flush_main_batch(s);
+
+		qpw_lockdep_assert_held(&s->cpu_sheaves->lock);
+		remaining = __sheaf_flush_main_batch(s, smp_processor_id());
 
 	} while (remaining);
 
@@ -2989,13 +2990,13 @@ static void rcu_free_sheaf_nobarn(struct
  * flushing operations are rare so let's keep it simple and flush to slabs
  * directly, skipping the barn
  */
-static void pcs_flush_all(struct kmem_cache *s)
+static void pcs_flush_all(struct kmem_cache *s, int cpu)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *spare, *rcu_free;
 
-	local_lock(&s->cpu_sheaves->lock);
-	pcs = this_cpu_ptr(s->cpu_sheaves);
+	qpw_lock(&s->cpu_sheaves->lock, cpu);
+	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
 	spare = pcs->spare;
 	pcs->spare = NULL;
@@ -3003,7 +3004,7 @@ static void pcs_flush_all(struct kmem_ca
 	rcu_free = pcs->rcu_free;
 	pcs->rcu_free = NULL;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
 
 	if (spare) {
 		sheaf_flush_unused(s, spare);
@@ -3013,7 +3014,7 @@ static void pcs_flush_all(struct kmem_ca
 	if (rcu_free)
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
 
-	sheaf_flush_main(s);
+	sheaf_flush_main(s, cpu);
 }
 
 static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
@@ -3963,13 +3964,13 @@ static void flush_cpu_sheaves(struct wor
 {
 	struct kmem_cache *s;
 	struct slub_flush_work *sfw;
+	int cpu = qpw_get_cpu(w);
 
-	sfw = container_of(w, struct slub_flush_work, work);
-
+	sfw = &per_cpu(slub_flush, cpu);
 	s = sfw->s;
 
 	if (cache_has_sheaves(s))
-		pcs_flush_all(s);
+		pcs_flush_all(s, cpu);
 }
 
 static void flush_all_cpus_locked(struct kmem_cache *s)
@@ -3986,17 +3987,17 @@ static void flush_all_cpus_locked(struct
 			sfw->skip = true;
 			continue;
 		}
-		INIT_WORK(&sfw->work, flush_cpu_sheaves);
+		INIT_QPW(&sfw->qpw, flush_cpu_sheaves, cpu);
 		sfw->skip = false;
 		sfw->s = s;
-		queue_work_on(cpu, flushwq, &sfw->work);
+		queue_percpu_work_on(cpu, flushwq, &sfw->qpw);
 	}
 
 	for_each_online_cpu(cpu) {
 		sfw = &per_cpu(slub_flush, cpu);
 		if (sfw->skip)
 			continue;
-		flush_work(&sfw->work);
+		flush_percpu_work(&sfw->qpw);
 	}
 
 	mutex_unlock(&flush_lock);
@@ -4015,17 +4016,18 @@ static void flush_rcu_sheaf(struct work_
 	struct slab_sheaf *rcu_free;
 	struct slub_flush_work *sfw;
 	struct kmem_cache *s;
+	int cpu = qpw_get_cpu(w);
 
-	sfw = container_of(w, struct slub_flush_work, work);
+	sfw = &per_cpu(slub_flush, cpu);
 	s = sfw->s;
 
-	local_lock(&s->cpu_sheaves->lock);
-	pcs = this_cpu_ptr(s->cpu_sheaves);
+	qpw_lock(&s->cpu_sheaves->lock, cpu);
+	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
 	rcu_free = pcs->rcu_free;
 	pcs->rcu_free = NULL;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
 
 	if (rcu_free)
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
@@ -4050,14 +4052,14 @@ void flush_rcu_sheaves_on_cache(struct k
 		 * sure the __kfree_rcu_sheaf() finished its call_rcu()
 		 */
 
-		INIT_WORK(&sfw->work, flush_rcu_sheaf);
+		INIT_QPW(&sfw->qpw, flush_rcu_sheaf, cpu);
 		sfw->s = s;
-		queue_work_on(cpu, flushwq, &sfw->work);
+		queue_percpu_work_on(cpu, flushwq, &sfw->qpw);
 	}
 
 	for_each_online_cpu(cpu) {
 		sfw = &per_cpu(slub_flush, cpu);
-		flush_work(&sfw->work);
+		flush_percpu_work(&sfw->qpw);
 	}
 
 	mutex_unlock(&flush_lock);
@@ -4565,11 +4567,11 @@ __pcs_replace_empty_main(struct kmem_cac
 	struct node_barn *barn;
 	bool allow_spin;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	qpw_lockdep_assert_held(&s->cpu_sheaves->lock);
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {
-		local_unlock(&s->cpu_sheaves->lock);
+		local_qpw_unlock(&s->cpu_sheaves->lock);
 		return NULL;
 	}
 
@@ -4580,7 +4582,7 @@ __pcs_replace_empty_main(struct kmem_cac
 
 	barn = get_barn(s);
 	if (!barn) {
-		local_unlock(&s->cpu_sheaves->lock);
+		local_qpw_unlock(&s->cpu_sheaves->lock);
 		return NULL;
 	}
 
@@ -4605,7 +4607,7 @@ __pcs_replace_empty_main(struct kmem_cac
 		}
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 	pcs = NULL;
 
 	if (!allow_spin)
@@ -4629,7 +4631,7 @@ __pcs_replace_empty_main(struct kmem_cac
 	if (!full)
 		return NULL;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		goto barn_put;
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
@@ -4708,7 +4710,7 @@ void *alloc_from_pcs(struct kmem_cache *
 		return NULL;
 	}
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		return NULL;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -4728,7 +4730,7 @@ void *alloc_from_pcs(struct kmem_cache *
 		 * the current allocation or previous freeing process.
 		 */
 		if (page_to_nid(virt_to_page(object)) != node) {
-			local_unlock(&s->cpu_sheaves->lock);
+			local_qpw_unlock(&s->cpu_sheaves->lock);
 			stat(s, ALLOC_NODE_MISMATCH);
 			return NULL;
 		}
@@ -4736,7 +4738,7 @@ void *alloc_from_pcs(struct kmem_cache *
 
 	pcs->main->size--;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, ALLOC_FASTPATH);
 
@@ -4753,7 +4755,7 @@ unsigned int alloc_from_pcs_bulk(struct
 	unsigned int batch;
 
 next_batch:
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		return allocated;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -4764,7 +4766,7 @@ next_batch:
 		struct node_barn *barn;
 
 		if (unlikely(!cache_has_sheaves(s))) {
-			local_unlock(&s->cpu_sheaves->lock);
+			local_qpw_unlock(&s->cpu_sheaves->lock);
 			return allocated;
 		}
 
@@ -4775,7 +4777,7 @@ next_batch:
 
 		barn = get_barn(s);
 		if (!barn) {
-			local_unlock(&s->cpu_sheaves->lock);
+			local_qpw_unlock(&s->cpu_sheaves->lock);
 			return allocated;
 		}
 
@@ -4790,7 +4792,7 @@ next_batch:
 
 		stat(s, BARN_GET_FAIL);
 
-		local_unlock(&s->cpu_sheaves->lock);
+		local_qpw_unlock(&s->cpu_sheaves->lock);
 
 		/*
 		 * Once full sheaves in barn are depleted, let the bulk
@@ -4808,7 +4810,7 @@ do_alloc:
 	main->size -= batch;
 	memcpy(p, main->objects + main->size, batch * sizeof(void *));
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	stat_add(s, ALLOC_FASTPATH, batch);
 
@@ -4992,7 +4994,7 @@ kmem_cache_prefill_sheaf(struct kmem_cac
 		return sheaf;
 	}
 
-	local_lock(&s->cpu_sheaves->lock);
+	local_qpw_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (pcs->spare) {
@@ -5011,7 +5013,7 @@ kmem_cache_prefill_sheaf(struct kmem_cac
 			stat(s, BARN_GET_FAIL);
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 
 	if (!sheaf)
@@ -5055,7 +5057,7 @@ void kmem_cache_return_sheaf(struct kmem
 		return;
 	}
 
-	local_lock(&s->cpu_sheaves->lock);
+	local_qpw_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	barn = get_barn(s);
 
@@ -5065,7 +5067,7 @@ void kmem_cache_return_sheaf(struct kmem
 		stat(s, SHEAF_RETURN_FAST);
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	if (!sheaf)
 		return;
@@ -5595,7 +5597,7 @@ static void __pcs_install_empty_sheaf(st
 		struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty,
 		struct node_barn *barn)
 {
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	qpw_lockdep_assert_held(&s->cpu_sheaves->lock);
 
 	/* This is what we expect to find if nobody interrupted us. */
 	if (likely(!pcs->spare)) {
@@ -5646,17 +5648,17 @@ __pcs_replace_full_main(struct kmem_cach
 	bool put_fail;
 
 restart:
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	qpw_lockdep_assert_held(&s->cpu_sheaves->lock);
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {
-		local_unlock(&s->cpu_sheaves->lock);
+		local_qpw_unlock(&s->cpu_sheaves->lock);
 		return NULL;
 	}
 
 	barn = get_barn(s);
 	if (!barn) {
-		local_unlock(&s->cpu_sheaves->lock);
+		local_qpw_unlock(&s->cpu_sheaves->lock);
 		return NULL;
 	}
 
@@ -5693,7 +5695,7 @@ restart:
 		stat(s, BARN_PUT_FAIL);
 
 		pcs->spare = NULL;
-		local_unlock(&s->cpu_sheaves->lock);
+		local_qpw_unlock(&s->cpu_sheaves->lock);
 
 		sheaf_flush_unused(s, to_flush);
 		empty = to_flush;
@@ -5709,7 +5711,7 @@ restart:
 	put_fail = true;
 
 alloc_empty:
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	/*
 	 * alloc_empty_sheaf() doesn't support !allow_spin and it's
@@ -5729,7 +5731,7 @@ alloc_empty:
 	if (!sheaf_try_flush_main(s))
 		return NULL;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		return NULL;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -5745,7 +5747,7 @@ alloc_empty:
 	return pcs;
 
 got_empty:
-	if (!local_trylock(&s->cpu_sheaves->lock)) {
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock)) {
 		barn_put_empty_sheaf(barn, empty);
 		return NULL;
 	}
@@ -5765,7 +5767,7 @@ bool free_to_pcs(struct kmem_cache *s, v
 {
 	struct slub_percpu_sheaves *pcs;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		return false;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -5779,7 +5781,7 @@ bool free_to_pcs(struct kmem_cache *s, v
 
 	pcs->main->objects[pcs->main->size++] = object;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_FASTPATH);
 
@@ -5869,7 +5871,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 
 	lock_map_acquire_try(&kfree_rcu_sheaf_map);
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		goto fail;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -5881,7 +5883,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 
 		/* Bootstrap or debug cache, fall back */
 		if (unlikely(!cache_has_sheaves(s))) {
-			local_unlock(&s->cpu_sheaves->lock);
+			local_qpw_unlock(&s->cpu_sheaves->lock);
 			goto fail;
 		}
 
@@ -5893,7 +5895,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 
 		barn = get_barn(s);
 		if (!barn) {
-			local_unlock(&s->cpu_sheaves->lock);
+			local_qpw_unlock(&s->cpu_sheaves->lock);
 			goto fail;
 		}
 
@@ -5904,14 +5906,14 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 			goto do_free;
 		}
 
-		local_unlock(&s->cpu_sheaves->lock);
+		local_qpw_unlock(&s->cpu_sheaves->lock);
 
 		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
 
 		if (!empty)
 			goto fail;
 
-		if (!local_trylock(&s->cpu_sheaves->lock)) {
+		if (!local_qpw_trylock(&s->cpu_sheaves->lock)) {
 			barn_put_empty_sheaf(barn, empty);
 			goto fail;
 		}
@@ -5942,13 +5944,13 @@ do_free:
 	}
 
 	/*
-	 * we flush before local_unlock to make sure a racing
+	 * we flush before local_qpw_unlock to make sure a racing
 	 * flush_all_rcu_sheaves() doesn't miss this sheaf
 	 */
 	if (rcu_sheaf)
 		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_RCU_SHEAF);
 	lock_map_release(&kfree_rcu_sheaf_map);
@@ -6004,7 +6006,7 @@ next_remote_batch:
 		goto flush_remote;
 
 next_batch:
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		goto fallback;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -6047,7 +6049,7 @@ do_free:
 	memcpy(main->objects + main->size, p, batch * sizeof(void *));
 	main->size += batch;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	stat_add(s, FREE_FASTPATH, batch);
 
@@ -6063,7 +6065,7 @@ do_free:
 	return;
 
 no_empty:
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	/*
 	 * if we depleted all empty sheaves in the barn or there are too
@@ -7468,7 +7470,7 @@ static int init_percpu_sheaves(struct km
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-		local_trylock_init(&pcs->lock);
+		qpw_trylock_init(&pcs->lock);
 
 		/*
 		 * Bootstrap sheaf has zero size so fast-path allocation fails.



