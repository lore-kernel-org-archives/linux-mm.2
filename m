Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AF3FEE20AB
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 14:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6FDC6B0089; Fri,  6 Feb 2026 09:40:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23C76B0093; Fri,  6 Feb 2026 09:40:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D06E6B0098; Fri,  6 Feb 2026 09:40:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 713D96B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:40:18 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C2911BDF2
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:40:18 +0000 (UTC)
X-FDA: 84414292116.25.D15114F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4A93880005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:40:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FXtib2Wz;
	spf=pass (imf02.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770388816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=CIBbWTksw7DvJ78/DV3io3akwWeED1pL6ZqB6VcV8to=;
	b=TXHN96aF1iGP5LllZqKxh1830+e0r1rCcZe8CtE3Gwc1TemBcvRgeAOisRTggImPQDJn2a
	0KKEbjZZBnnQ4xV9RoZPHT/HBVrHp0HNaW+l7poircjAzeo2ZmUCYbvHr/RXw+fkR9+BOA
	PQ1goZgYHNEhrWY9NxK85QpC1IZGXQs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FXtib2Wz;
	spf=pass (imf02.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770388816; a=rsa-sha256;
	cv=none;
	b=WKOeZawShVXeHpK+ahifGkGBGrPDEb6kOXmadCJShitxY8sUGq/HCTPr3CZCYfNh9Hnh40
	8bug+9kywpymZHugUIgqEQsEaH6cRGhjTSz1dDtX7DzcqaBX5OU2jtkfE9yFoFHANvJpM7
	S8r9OIZx5wuaSawh+PPhrM9KS29JFq8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770388815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=CIBbWTksw7DvJ78/DV3io3akwWeED1pL6ZqB6VcV8to=;
	b=FXtib2WzsLjNOTJnd1PyNINvlC3WuZc5PF3eXbbsHE5pv4rRgGgQqs5jLoQLiqdZOi0dlO
	rEDaBQXWalwfX5vzIr+AdoVi+KlFwkIMGze5yfGtBUIqm1htwB5OwLMVR8KFfxzllDWe14
	2dabqhv6H30Iu5O+2KtBieNZjIBzPj0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-wu1KRp-3McuXwj9pNVbERQ-1; Fri,
 06 Feb 2026 09:40:12 -0500
X-MC-Unique: wu1KRp-3McuXwj9pNVbERQ-1
X-Mimecast-MFC-AGG-ID: wu1KRp-3McuXwj9pNVbERQ_1770388810
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 21DDB18001FC;
	Fri,  6 Feb 2026 14:40:10 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.22.74.16])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F78B1800465;
	Fri,  6 Feb 2026 14:40:07 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id B40B841DF09EC; Fri,  6 Feb 2026 11:39:20 -0300 (-03)
Message-ID: <20260206143741.621816322@redhat.com>
User-Agent: quilt/0.66
Date: Fri, 06 Feb 2026 11:34:34 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
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
 Leonardo Bras <leobras@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 4/4] slub: apply new queue_percpu_work_on() interface
References: <20260206143430.021026873@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: hK_CJb0eUhpC-BbX-ecoOrneNcokJpkXJ3QzBciZKqQ_1770388810
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4A93880005
X-Stat-Signature: szh5wz9o56y689ea88jrz4nz6tnwuxz1
X-Rspam-User: 
X-HE-Tag: 1770388816-5802
X-HE-Meta: U2FsdGVkX1+kNir88P/BpDpHcQ0Kb2CZhx8xtvxDBDWQ04rUAuq7uYSNeZEz4JzuxTOmG3baKYU0OvBQl8dkJRBHZPhvM3BIFHUuGjMIxCXNhqauU/Q7beAR78MeNHtVKbIPVpAjrqP53E5JxCvrd7JS+Uwsx1vGCXXx90bxzk25imc5pEBUBEPi83LVVaEpvDKZ20yrWDKv0/o4psl82DXA7QI3GMyZ4SaV+B5y2Z95GP2rvDqjEJksFOVmP5Z4kd1CkUeDPgV6WY6t/3W6FaquZ2I8PEiS3rn2a6ccHZz3P22s7O8vUVbIQTNE1EsXbPeWd3spX0ZZ0KsOCXvr8a2E0AEBxjqGgjCtOMMptc7o0hLvBmVZHxR7NfjEcNElyIiAh4dLAYKKavj/DMdPzZHK7tD1jFOlOhMJOkbWdTuQ/vb3Qd89cZXAISdGH7k9sHCWytupRY+ONsMuzTANHou161OqLlowjBbkRnJpmSxMzfbVkfb1qVm0yT2D6Yigt/pyfqFhUIWY+/M+2dQ67ViN0PveKEtiRvjAnwPV7qpY6kjvbvCibqzygSv4M/c+ao69WKa+bpl2o4CiNaY5SzQx2JH4yk1lYq8hdQZPDkfxNLT6xPS5eQIgXK340yBnC/vzgGpcnPEwGp6T+MycQLvWM5/FD1zGKf662HIrcZAXniH2pCdLlBLuYrqMVwpmQyeU8ARCvZ2QJbyQcxzK3M5gRPsyDDSFRyZ4cOoW51AY51IQCPqBqp12lL6W/9NViuWxEXsPLCnu6xiwSRxDTnDfUAXZnSSwcGUKTlN9CL0JN0bNMOKsM7OXMJlHr06h8mdXfSDjNFPjCrYTB6razEAm24e67PoCnsZMVIZf03fv4TGmLgucZSQ4fXssKVSOEhPacqq+ZukDQ3jZpE9a4JhomYJwWeL3RNzLc4sa8Hu8idJTIPMq+EsjufYycYx2yMs6jqSQC5Eq7KriXpH
 WKwXZUIk
 +Y+PZeYtc0OoT5cGKAPAREqpYHoEhDIguLI6PDO8TAJCOqhArKgstABWIRPHEalxoT4thoT+bUdSPErZ1wu71brl0Mq1pp6UAj34ZHbzntcNIXZd3pfxuTFXH+V/JVstC5hEyVLCU0J0hAVOArZbXEPnJE7pyFR3VkfPtbBR1fBr4RYBTP5cFF/McLkr64lA4C0Z8NtyafdxBhLd/Peau80WYddTuCKhUVRKfceA9bT3X6QvrahVzkdE0HXZjhC8vutePJ7bvxETiyPkFntbscMuP8v0bbSIEOBXt9lJ8G++ZG8han2lCRP7UbYzA5mQz8SH3r6mdJyFNacO/5yZ5hEvmqlm2Iz6HnavkkzBC9mZaDaRSZ0xK0XOEmzcBWyi90jX7iC0oU694TDJcZHyECfMdIAOa8n16u14eXWA8atKbWgU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new qpw_{un,}lock*() and queue_percpu_work_on()
interface to improve performance & latency on PREEMPT_RT kernels.

For functions that may be scheduled in a different cpu, replace
local_{un,}lock*() by qpw_{un,}lock*(), and replace schedule_work_on() by
queue_percpu_work_on(). The same happens for flush_work() and
flush_percpu_work().

This change requires allocation of qpw_structs instead of a work_structs,
and changing parameters of a few functions to include the cpu parameter.

This should bring no relevant performance impact on non-RT kernels:
For functions that may be scheduled in a different cpu, the local_*lock's
this_cpu_ptr() becomes a per_cpu_ptr(smp_processor_id()).

Signed-off-by: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 mm/slub.c |  218 ++++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 142 insertions(+), 76 deletions(-)

Index: slab/mm/slub.c
===================================================================
--- slab.orig/mm/slub.c
+++ slab/mm/slub.c
@@ -49,6 +49,7 @@
 #include <linux/irq_work.h>
 #include <linux/kprobes.h>
 #include <linux/debugfs.h>
+#include <linux/qpw.h>
 #include <trace/events/kmem.h>
 
 #include "internal.h"
@@ -128,7 +129,7 @@
  *   For debug caches, all allocations are forced to go through a list_lock
  *   protected region to serialize against concurrent validation.
  *
- *   cpu_sheaves->lock (local_trylock)
+ *   cpu_sheaves->lock (qpw_trylock)
  *
  *   This lock protects fastpath operations on the percpu sheaves. On !RT it
  *   only disables preemption and does no atomic operations. As long as the main
@@ -156,7 +157,7 @@
  *   Interrupts are disabled as part of list_lock or barn lock operations, or
  *   around the slab_lock operation, in order to make the slab allocator safe
  *   to use in the context of an irq.
- *   Preemption is disabled as part of local_trylock operations.
+ *   Preemption is disabled as part of qpw_trylock operations.
  *   kmalloc_nolock() and kfree_nolock() are safe in NMI context but see
  *   their limitations.
  *
@@ -417,7 +418,7 @@ struct slab_sheaf {
 };
 
 struct slub_percpu_sheaves {
-	local_trylock_t lock;
+	qpw_trylock_t lock;
 	struct slab_sheaf *main; /* never NULL when unlocked */
 	struct slab_sheaf *spare; /* empty or full, may be NULL */
 	struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
@@ -479,7 +480,7 @@ static nodemask_t slab_nodes;
 static struct workqueue_struct *flushwq;
 
 struct slub_flush_work {
-	struct work_struct work;
+	struct qpw_struct qpw;
 	struct kmem_cache *s;
 	bool skip;
 };
@@ -2826,7 +2827,7 @@ static void __kmem_cache_free_bulk(struc
  *
  * returns true if at least partially flushed
  */
-static bool sheaf_flush_main(struct kmem_cache *s)
+static bool sheaf_flush_main(struct kmem_cache *s, int cpu)
 {
 	struct slub_percpu_sheaves *pcs;
 	unsigned int batch, remaining;
@@ -2835,10 +2836,10 @@ static bool sheaf_flush_main(struct kmem
 	bool ret = false;
 
 next_batch:
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!qpw_trylock(&s->cpu_sheaves->lock, cpu))
 		return ret;
 
-	pcs = this_cpu_ptr(s->cpu_sheaves);
+	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 	sheaf = pcs->main;
 
 	batch = min(PCS_BATCH_MAX, sheaf->size);
@@ -2848,7 +2849,7 @@ next_batch:
 
 	remaining = sheaf->size;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
 
 	__kmem_cache_free_bulk(s, batch, &objects[0]);
 
@@ -2932,13 +2933,13 @@ static void rcu_free_sheaf_nobarn(struct
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
@@ -2946,7 +2947,7 @@ static void pcs_flush_all(struct kmem_ca
 	rcu_free = pcs->rcu_free;
 	pcs->rcu_free = NULL;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
 
 	if (spare) {
 		sheaf_flush_unused(s, spare);
@@ -2956,7 +2957,7 @@ static void pcs_flush_all(struct kmem_ca
 	if (rcu_free)
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
 
-	sheaf_flush_main(s);
+	sheaf_flush_main(s, cpu);
 }
 
 static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
@@ -3881,13 +3882,13 @@ static void flush_cpu_sheaves(struct wor
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
@@ -3904,17 +3905,17 @@ static void flush_all_cpus_locked(struct
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
@@ -3933,17 +3934,18 @@ static void flush_rcu_sheaf(struct work_
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
@@ -3968,14 +3970,14 @@ void flush_rcu_sheaves_on_cache(struct k
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
@@ -4472,22 +4474,24 @@ bool slab_post_alloc_hook(struct kmem_ca
  *
  * Must be called with the cpu_sheaves local lock locked. If successful, returns
  * the pcs pointer and the local lock locked (possibly on a different cpu than
- * initially called). If not successful, returns NULL and the local lock
- * unlocked.
+ * initially called), and migration disabled. If not successful, returns NULL
+ * and the local lock unlocked, with migration enabled.
  */
 static struct slub_percpu_sheaves *
-__pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs, gfp_t gfp)
+__pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs, gfp_t gfp,
+			 int *cpu)
 {
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
 	bool can_alloc;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	qpw_lockdep_assert_held(&s->cpu_sheaves->lock);
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {
-		local_unlock(&s->cpu_sheaves->lock);
+		qpw_unlock(&s->cpu_sheaves->lock, *cpu);
+		migrate_enable();
 		return NULL;
 	}
 
@@ -4498,7 +4502,8 @@ __pcs_replace_empty_main(struct kmem_cac
 
 	barn = get_barn(s);
 	if (!barn) {
-		local_unlock(&s->cpu_sheaves->lock);
+		qpw_unlock(&s->cpu_sheaves->lock, *cpu);
+		migrate_enable();
 		return NULL;
 	}
 
@@ -4524,7 +4529,8 @@ __pcs_replace_empty_main(struct kmem_cac
 		}
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, *cpu);
+	migrate_enable();
 
 	if (!can_alloc)
 		return NULL;
@@ -4550,7 +4556,9 @@ __pcs_replace_empty_main(struct kmem_cac
 	 * we can reach here only when gfpflags_allow_blocking
 	 * so this must not be an irq
 	 */
-	local_lock(&s->cpu_sheaves->lock);
+	migrate_disable();
+	*cpu = smp_processor_id();
+	qpw_lock(&s->cpu_sheaves->lock, *cpu);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	/*
@@ -4593,6 +4601,7 @@ void *alloc_from_pcs(struct kmem_cache *
 	struct slub_percpu_sheaves *pcs;
 	bool node_requested;
 	void *object;
+	int cpu;
 
 #ifdef CONFIG_NUMA
 	if (static_branch_unlikely(&strict_numa) &&
@@ -4627,13 +4636,17 @@ void *alloc_from_pcs(struct kmem_cache *
 		return NULL;
 	}
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	migrate_disable();
+	cpu = smp_processor_id();
+	if (!qpw_trylock(&s->cpu_sheaves->lock, cpu)) {
+		migrate_enable();
 		return NULL;
+	}
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(pcs->main->size == 0)) {
-		pcs = __pcs_replace_empty_main(s, pcs, gfp);
+		pcs = __pcs_replace_empty_main(s, pcs, gfp, &cpu);
 		if (unlikely(!pcs))
 			return NULL;
 	}
@@ -4647,7 +4660,8 @@ void *alloc_from_pcs(struct kmem_cache *
 		 * the current allocation or previous freeing process.
 		 */
 		if (page_to_nid(virt_to_page(object)) != node) {
-			local_unlock(&s->cpu_sheaves->lock);
+			qpw_unlock(&s->cpu_sheaves->lock, cpu);
+			migrate_enable();
 			stat(s, ALLOC_NODE_MISMATCH);
 			return NULL;
 		}
@@ -4655,7 +4669,8 @@ void *alloc_from_pcs(struct kmem_cache *
 
 	pcs->main->size--;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
+	migrate_enable();
 
 	stat(s, ALLOC_FASTPATH);
 
@@ -4670,10 +4685,15 @@ unsigned int alloc_from_pcs_bulk(struct
 	struct slab_sheaf *main;
 	unsigned int allocated = 0;
 	unsigned int batch;
+	int cpu;
 
 next_batch:
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	migrate_disable();
+	cpu = smp_processor_id();
+	if (!qpw_trylock(&s->cpu_sheaves->lock, cpu)) {
+		migrate_enable();
 		return allocated;
+	}
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
@@ -4683,7 +4703,8 @@ next_batch:
 		struct node_barn *barn;
 
 		if (unlikely(!cache_has_sheaves(s))) {
-			local_unlock(&s->cpu_sheaves->lock);
+			qpw_unlock(&s->cpu_sheaves->lock, cpu);
+			migrate_enable();
 			return allocated;
 		}
 
@@ -4694,7 +4715,8 @@ next_batch:
 
 		barn = get_barn(s);
 		if (!barn) {
-			local_unlock(&s->cpu_sheaves->lock);
+			qpw_unlock(&s->cpu_sheaves->lock, cpu);
+			migrate_enable();
 			return allocated;
 		}
 
@@ -4709,7 +4731,8 @@ next_batch:
 
 		stat(s, BARN_GET_FAIL);
 
-		local_unlock(&s->cpu_sheaves->lock);
+		qpw_unlock(&s->cpu_sheaves->lock, cpu);
+		migrate_enable();
 
 		/*
 		 * Once full sheaves in barn are depleted, let the bulk
@@ -4727,7 +4750,8 @@ do_alloc:
 	main->size -= batch;
 	memcpy(p, main->objects + main->size, batch * sizeof(void *));
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
+	migrate_enable();
 
 	stat_add(s, ALLOC_FASTPATH, batch);
 
@@ -4877,6 +4901,7 @@ kmem_cache_prefill_sheaf(struct kmem_cac
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *sheaf = NULL;
 	struct node_barn *barn;
+	int cpu;
 
 	if (unlikely(!size))
 		return NULL;
@@ -4906,7 +4931,9 @@ kmem_cache_prefill_sheaf(struct kmem_cac
 		return sheaf;
 	}
 
-	local_lock(&s->cpu_sheaves->lock);
+	migrate_disable();
+	cpu = smp_processor_id();
+	qpw_lock(&s->cpu_sheaves->lock, cpu);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (pcs->spare) {
@@ -4925,7 +4952,8 @@ kmem_cache_prefill_sheaf(struct kmem_cac
 			stat(s, BARN_GET_FAIL);
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
+	migrate_enable();
 
 
 	if (!sheaf)
@@ -4961,6 +4989,7 @@ void kmem_cache_return_sheaf(struct kmem
 {
 	struct slub_percpu_sheaves *pcs;
 	struct node_barn *barn;
+	int cpu;
 
 	if (unlikely((sheaf->capacity != s->sheaf_capacity)
 		     || sheaf->pfmemalloc)) {
@@ -4969,7 +4998,9 @@ void kmem_cache_return_sheaf(struct kmem
 		return;
 	}
 
-	local_lock(&s->cpu_sheaves->lock);
+	migrate_disable();
+	cpu = smp_processor_id();
+	qpw_lock(&s->cpu_sheaves->lock, cpu);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	barn = get_barn(s);
 
@@ -4979,7 +5010,8 @@ void kmem_cache_return_sheaf(struct kmem
 		stat(s, SHEAF_RETURN_FAST);
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
+	migrate_enable();
 
 	if (!sheaf)
 		return;
@@ -5507,9 +5539,9 @@ slab_empty:
  */
 static void __pcs_install_empty_sheaf(struct kmem_cache *s,
 		struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty,
-		struct node_barn *barn)
+		struct node_barn *barn, int cpu)
 {
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	qpw_lockdep_assert_held(&s->cpu_sheaves->lock);
 
 	/* This is what we expect to find if nobody interrupted us. */
 	if (likely(!pcs->spare)) {
@@ -5546,31 +5578,34 @@ static void __pcs_install_empty_sheaf(st
 /*
  * Replace the full main sheaf with a (at least partially) empty sheaf.
  *
- * Must be called with the cpu_sheaves local lock locked. If successful, returns
- * the pcs pointer and the local lock locked (possibly on a different cpu than
- * initially called). If not successful, returns NULL and the local lock
- * unlocked.
+ * Must be called with the cpu_sheaves local lock locked, and migration counter
+ * increased. If successful, returns the pcs pointer and the local lock locked
+ * (possibly on a different cpu than initially called), with migration counter
+ * increased. If not successful, returns NULL and the local lock unlocked,
+ * and migration counter decreased.
  */
 static struct slub_percpu_sheaves *
 __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
-			bool allow_spin)
+			bool allow_spin, int *cpu)
 {
 	struct slab_sheaf *empty;
 	struct node_barn *barn;
 	bool put_fail;
 
 restart:
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	qpw_lockdep_assert_held(&s->cpu_sheaves->lock);
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {
-		local_unlock(&s->cpu_sheaves->lock);
+		qpw_unlock(&s->cpu_sheaves->lock, *cpu);
+		migrate_enable();
 		return NULL;
 	}
 
 	barn = get_barn(s);
 	if (!barn) {
-		local_unlock(&s->cpu_sheaves->lock);
+		qpw_unlock(&s->cpu_sheaves->lock, *cpu);
+		migrate_enable();
 		return NULL;
 	}
 
@@ -5607,7 +5642,8 @@ restart:
 		stat(s, BARN_PUT_FAIL);
 
 		pcs->spare = NULL;
-		local_unlock(&s->cpu_sheaves->lock);
+		qpw_unlock(&s->cpu_sheaves->lock, *cpu);
+		migrate_enable();
 
 		sheaf_flush_unused(s, to_flush);
 		empty = to_flush;
@@ -5623,7 +5659,8 @@ restart:
 	put_fail = true;
 
 alloc_empty:
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, *cpu);
+	migrate_enable();
 
 	/*
 	 * alloc_empty_sheaf() doesn't support !allow_spin and it's
@@ -5640,11 +5677,17 @@ alloc_empty:
 	if (put_fail)
 		 stat(s, BARN_PUT_FAIL);
 
-	if (!sheaf_flush_main(s))
+	migrate_disable();
+	*cpu = smp_processor_id();
+	if (!sheaf_flush_main(s, *cpu)) {
+		migrate_enable();
 		return NULL;
+	}
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!qpw_trylock(&s->cpu_sheaves->lock, *cpu)) {
+		migrate_enable();
 		return NULL;
+	}
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
@@ -5659,13 +5702,14 @@ alloc_empty:
 	return pcs;
 
 got_empty:
-	if (!local_trylock(&s->cpu_sheaves->lock)) {
+	if (!qpw_trylock(&s->cpu_sheaves->lock, *cpu)) {
+		migrate_enable();
 		barn_put_empty_sheaf(barn, empty);
 		return NULL;
 	}
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
-	__pcs_install_empty_sheaf(s, pcs, empty, barn);
+	__pcs_install_empty_sheaf(s, pcs, empty, barn, *cpu);
 
 	return pcs;
 }
@@ -5678,22 +5722,28 @@ static __fastpath_inline
 bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
 {
 	struct slub_percpu_sheaves *pcs;
+	int cpu;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	migrate_disable();
+	cpu = smp_processor_id();
+	if (!qpw_trylock(&s->cpu_sheaves->lock, cpu)) {
+		migrate_enable();
 		return false;
+	}
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(pcs->main->size == s->sheaf_capacity)) {
 
-		pcs = __pcs_replace_full_main(s, pcs, allow_spin);
+		pcs = __pcs_replace_full_main(s, pcs, allow_spin, &cpu);
 		if (unlikely(!pcs))
 			return false;
 	}
 
 	pcs->main->objects[pcs->main->size++] = object;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
+	migrate_enable();
 
 	stat(s, FREE_FASTPATH);
 
@@ -5777,14 +5827,19 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *rcu_sheaf;
+	int cpu;
 
 	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
 		return false;
 
 	lock_map_acquire_try(&kfree_rcu_sheaf_map);
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	migrate_disable();
+	cpu = smp_processor_id();
+	if (!qpw_trylock(&s->cpu_sheaves->lock, cpu)) {
+		migrate_enable();
 		goto fail;
+	}
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
@@ -5795,7 +5850,8 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 
 		/* Bootstrap or debug cache, fall back */
 		if (unlikely(!cache_has_sheaves(s))) {
-			local_unlock(&s->cpu_sheaves->lock);
+			qpw_unlock(&s->cpu_sheaves->lock, cpu);
+			migrate_enable();
 			goto fail;
 		}
 
@@ -5807,7 +5863,8 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 
 		barn = get_barn(s);
 		if (!barn) {
-			local_unlock(&s->cpu_sheaves->lock);
+			qpw_unlock(&s->cpu_sheaves->lock, cpu);
+			migrate_enable();
 			goto fail;
 		}
 
@@ -5818,15 +5875,18 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 			goto do_free;
 		}
 
-		local_unlock(&s->cpu_sheaves->lock);
+		qpw_unlock(&s->cpu_sheaves->lock, cpu);
+		migrate_enable();
 
 		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
 
 		if (!empty)
 			goto fail;
 
-		if (!local_trylock(&s->cpu_sheaves->lock)) {
+		migrate_disable();
+		if (!qpw_trylock(&s->cpu_sheaves->lock, cpu)) {
 			barn_put_empty_sheaf(barn, empty);
+			migrate_enable();
 			goto fail;
 		}
 
@@ -5862,7 +5922,8 @@ do_free:
 	if (rcu_sheaf)
 		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
+	migrate_enable();
 
 	stat(s, FREE_RCU_SHEAF);
 	lock_map_release(&kfree_rcu_sheaf_map);
@@ -5889,6 +5950,7 @@ static void free_to_pcs_bulk(struct kmem
 	void *remote_objects[PCS_BATCH_MAX];
 	unsigned int remote_nr = 0;
 	int node = numa_mem_id();
+	int cpu;
 
 next_remote_batch:
 	while (i < size) {
@@ -5918,7 +5980,9 @@ next_remote_batch:
 		goto flush_remote;
 
 next_batch:
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	migrate_disable();
+	cpu = smp_processor_id();
+	if (!qpw_trylock(&s->cpu_sheaves->lock, cpu))
 		goto fallback;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -5961,7 +6025,8 @@ do_free:
 	memcpy(main->objects + main->size, p, batch * sizeof(void *));
 	main->size += batch;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
+	migrate_enable();
 
 	stat_add(s, FREE_FASTPATH, batch);
 
@@ -5977,7 +6042,8 @@ do_free:
 	return;
 
 no_empty:
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
+	migrate_enable();
 
 	/*
 	 * if we depleted all empty sheaves in the barn or there are too
@@ -7377,7 +7443,7 @@ static int init_percpu_sheaves(struct km
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-		local_trylock_init(&pcs->lock);
+		qpw_trylock_init(&pcs->lock);
 
 		/*
 		 * Bootstrap sheaf has zero size so fast-path allocation fails.



