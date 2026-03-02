Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86FF3EA4E26
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3416B009F; Mon,  2 Mar 2026 10:53:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B696B009E; Mon,  2 Mar 2026 10:53:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D186B009F; Mon,  2 Mar 2026 10:53:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5D696B009B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:53:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A2F4B661A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:36 +0000 (UTC)
X-FDA: 84501568032.10.E219887
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id A501C40018
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YZxe6TBg;
	spf=pass (imf11.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=nA4r8tdoDE9581pdteheJGgZx1L1mlw7TfGP6HByoC0=;
	b=Um+LDwMwxtFqFG4+HwFLMbnilI95KGmwPKRH3WnZv6tSvRY6m6zOq6+sYFpQIHOZ4RAcK2
	QP1XlKk6ZxFx4DDA9Qf3yIsYogQbE07xvah3Cxz4tL1Eqg7En8sIPjLhHBw7mFg61jXWHz
	wogcyNAU5hpfVClLWzTqI/g1RFberUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466814; a=rsa-sha256;
	cv=none;
	b=Y3ZsEThZSQLaZUYIbCd9vTGKuIf7eglWt8pebmiRGf4k1s8dL9mg0qOAdQE3ozvla7J4uJ
	9FlrojBYQD6LfVXnmfEfTryEgmx9NpXjBzbnr1R61bfbV4/HpSSWRGZYJZxDxhq1TUohjw
	X2nwjiG/BuWrWKA0laYOU+LoZ43CAA0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YZxe6TBg;
	spf=pass (imf11.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772466813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=nA4r8tdoDE9581pdteheJGgZx1L1mlw7TfGP6HByoC0=;
	b=YZxe6TBgYVJzJTne8vl3XoleBT6NENi12YYb0mPfWv6mHzsU1BW86LTbK6NZ1K0CE1vDXo
	ndJf0CF9PDNJ4JiyCKFblDIPfJsG2lweXhuGYKMzV+WC2zouXAmqleOc7mI7W9CQJSfmRf
	YicRDbarBk8W6aDCz0h6AT6uWk5JqEM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449-OUNtEChCNLK_YYkHVzdt6A-1; Mon,
 02 Mar 2026 10:53:29 -0500
X-MC-Unique: OUNtEChCNLK_YYkHVzdt6A-1
X-Mimecast-MFC-AGG-ID: OUNtEChCNLK_YYkHVzdt6A_1772466807
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 165C21800465;
	Mon,  2 Mar 2026 15:53:27 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.6])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5175A1800576;
	Mon,  2 Mar 2026 15:53:26 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id B1AE14025F126; Mon,  2 Mar 2026 12:53:00 -0300 (-03)
Message-ID: <20260302155105.306721019@redhat.com>
User-Agent: quilt/0.69
Date: Mon, 02 Mar 2026 12:49:50 -0300
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
Subject: [PATCH v2 5/5] slub: apply new queue_percpu_work_on() interface
References: <20260302154945.143996316@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: xnfGBMZQP2PGxP-E2WX_-nkVHb2MvQyH5QXZFsDWFBw_1772466807
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A501C40018
X-Stat-Signature: rkbmzwzu7s6fx3xbhcyzuzx1uth494x9
X-HE-Tag: 1772466814-529657
X-HE-Meta: U2FsdGVkX1+JfVmZnCV3sHEGQKURo1kfNeygOoFcrpmfbgta6ZL+UIK/qk1+EhRzP4b4adLfySW785td312Ps+buDWoBsKXDM3/T0oJQxKj12cI1figzl1XUR+p4UCN3pS6uWdxGYQl1l2GKyr31A0kwrqWEABGYUHDQVBHwriiheXTfuHwBXf2XjEd/NR3ygbDk/NH39mmWROcsBTzKzxnxGXejJSyEvy8WRs7Tn2Cg/0yjBKP7vtl0fc66JXoIL8xwBjxc4uN7P+oLVH+rJvSzYVpZ136ZzVG4eCxBUnBy6EhFAae1Dug/ThuZp+2l/WFhp1LKzUmyCbriNuSQcemtbadn7qSThGuYekMY+at14OnHi0oXWTiEc/00cELF7Kn/Hl/QZqcs98roTP6vufArRjtoREM9d10Xx+Q+crPI88rtEV9de87Blk/guTSaoENyK3qDzDou80ke6jLs3CQnC2M3kBC3apjQApZ/vyZPGnAJzFNrFQoQIsPPUJo9TVe0qNct3CsprN/SiHJjI6s5zmeOFwksPhMEZ+hTf7bC/0tRlWrUAFmvKJm2sCfHgMVM6oG63jVrv4JIMVI8d7BGrI3X4iHH7GAF/C13myDis/Em3DQxLfbgMDMo65Epk5NB/MCeh0mFa3wRVC72pxYIzQHoDFGZG/WP5709u5s+YzqhApAqT7uMwcSGJ8+r5wvciD6gmCk7DG5P/l6kFwAC8N42hYKHiL2ZsL6YjsjvlG+E/AATHTc5N18NajFhI6kgbZb+Qa1mLor5HKi+T4caMxSjw5k4SMuZojd8ilGEGa83XG0Y1HfwVkGL6NcJz9MLjUhypVotwQ4AoaPXaqC2uXaohTRqRn/e3DtDBV1fWGKXtYoPidr81w1nNTni/gtHXa2G7WsmCnAz+vmmsIHFDRme1RwC7CfNxVsQU42HE9YRwOFjR4WLSuSRjnLBicUGZ6rfZDQt2CMLaT7
 92d6ojc0
 ZGUk8SB8ObBw/HW3jK8xQa5nK0y9GgHUVg+GQzKUt8STwO5C9TdETRKzRbypcZdbFdMdWheYATN8fBAm0pS4lHVntd7jzw9G9Ba4TulhoZeLYHJD/aDfWLcM3j0RJHDQ/0DlxKfR55RJeHWOr/izPY1fHz6jBbvGElLzzCMt7EWMx56Xi151QWBRMImrYRQmtMLGYWBIrEXOBnX6D9BXmCuBj+HC/mLknTj/Orzu13iLGDr+o5pImCkZkguaTQcwDCsXX++xR8SQYEMKIJKM1JWwIVPYzoip4C2CMErbg7xc5/tgOXx8WTftRFNPycPhINhnDj5bNkKZ2yqlZe8zwdjRxcLpQeJ3cTh/gbZYGo27rCCG5ixcnHEMqgogSgOJOGg9DYQtEAHSZiYWfqJEq2ax845h+KhHSP1gxGE1WXW2H0t8G9yBBIchfnP4+xkr/6sPL
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
@@ -2849,16 +2850,14 @@ static void __kmem_cache_free_bulk(struc
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
@@ -2868,7 +2867,7 @@ static unsigned int __sheaf_flush_main_b
 
 	remaining = sheaf->size;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
 
 	__kmem_cache_free_bulk(s, batch, &objects[0]);
 
@@ -2877,14 +2876,14 @@ static unsigned int __sheaf_flush_main_b
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
@@ -2898,11 +2897,13 @@ static bool sheaf_try_flush_main(struct
 	bool ret = false;
 
 	do {
-		if (!local_trylock(&s->cpu_sheaves->lock))
+		if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 			return ret;
 
 		ret = true;
-		remaining = __sheaf_flush_main_batch(s);
+
+		lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+		remaining = __sheaf_flush_main_batch(s, smp_processor_id());
 
 	} while (remaining);
 
@@ -2979,13 +2980,13 @@ static void rcu_free_sheaf_nobarn(struct
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
@@ -2993,7 +2994,7 @@ static void pcs_flush_all(struct kmem_ca
 	rcu_free = pcs->rcu_free;
 	pcs->rcu_free = NULL;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	qpw_unlock(&s->cpu_sheaves->lock, cpu);
 
 	if (spare) {
 		sheaf_flush_unused(s, spare);
@@ -3003,7 +3004,7 @@ static void pcs_flush_all(struct kmem_ca
 	if (rcu_free)
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
 
-	sheaf_flush_main(s);
+	sheaf_flush_main(s, cpu);
 }
 
 static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
@@ -3953,13 +3954,13 @@ static void flush_cpu_sheaves(struct wor
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
@@ -3976,17 +3977,17 @@ static void flush_all_cpus_locked(struct
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
@@ -4005,17 +4006,18 @@ static void flush_rcu_sheaf(struct work_
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
@@ -4040,14 +4042,14 @@ void flush_rcu_sheaves_on_cache(struct k
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
@@ -4555,11 +4557,11 @@ __pcs_replace_empty_main(struct kmem_cac
 	struct node_barn *barn;
 	bool can_alloc;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	qpw_lockdep_assert_held(&s->cpu_sheaves->lock);
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {
-		local_unlock(&s->cpu_sheaves->lock);
+		local_qpw_unlock(&s->cpu_sheaves->lock);
 		return NULL;
 	}
 
@@ -4570,7 +4572,7 @@ __pcs_replace_empty_main(struct kmem_cac
 
 	barn = get_barn(s);
 	if (!barn) {
-		local_unlock(&s->cpu_sheaves->lock);
+		local_qpw_unlock(&s->cpu_sheaves->lock);
 		return NULL;
 	}
 
@@ -4596,7 +4598,7 @@ __pcs_replace_empty_main(struct kmem_cac
 		}
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	if (!can_alloc)
 		return NULL;
@@ -4622,7 +4624,7 @@ __pcs_replace_empty_main(struct kmem_cac
 	 * we can reach here only when gfpflags_allow_blocking
 	 * so this must not be an irq
 	 */
-	local_lock(&s->cpu_sheaves->lock);
+	local_qpw_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	/*
@@ -4699,7 +4701,7 @@ void *alloc_from_pcs(struct kmem_cache *
 		return NULL;
 	}
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		return NULL;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -4719,7 +4721,7 @@ void *alloc_from_pcs(struct kmem_cache *
 		 * the current allocation or previous freeing process.
 		 */
 		if (page_to_nid(virt_to_page(object)) != node) {
-			local_unlock(&s->cpu_sheaves->lock);
+			local_qpw_unlock(&s->cpu_sheaves->lock);
 			stat(s, ALLOC_NODE_MISMATCH);
 			return NULL;
 		}
@@ -4727,7 +4729,7 @@ void *alloc_from_pcs(struct kmem_cache *
 
 	pcs->main->size--;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, ALLOC_FASTPATH);
 
@@ -4744,7 +4746,7 @@ unsigned int alloc_from_pcs_bulk(struct
 	unsigned int batch;
 
 next_batch:
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		return allocated;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -4755,7 +4757,7 @@ next_batch:
 		struct node_barn *barn;
 
 		if (unlikely(!cache_has_sheaves(s))) {
-			local_unlock(&s->cpu_sheaves->lock);
+			local_qpw_unlock(&s->cpu_sheaves->lock);
 			return allocated;
 		}
 
@@ -4766,7 +4768,7 @@ next_batch:
 
 		barn = get_barn(s);
 		if (!barn) {
-			local_unlock(&s->cpu_sheaves->lock);
+			local_qpw_unlock(&s->cpu_sheaves->lock);
 			return allocated;
 		}
 
@@ -4781,7 +4783,7 @@ next_batch:
 
 		stat(s, BARN_GET_FAIL);
 
-		local_unlock(&s->cpu_sheaves->lock);
+		local_qpw_unlock(&s->cpu_sheaves->lock);
 
 		/*
 		 * Once full sheaves in barn are depleted, let the bulk
@@ -4799,7 +4801,7 @@ do_alloc:
 	main->size -= batch;
 	memcpy(p, main->objects + main->size, batch * sizeof(void *));
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	stat_add(s, ALLOC_FASTPATH, batch);
 
@@ -4978,7 +4980,7 @@ kmem_cache_prefill_sheaf(struct kmem_cac
 		return sheaf;
 	}
 
-	local_lock(&s->cpu_sheaves->lock);
+	local_qpw_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (pcs->spare) {
@@ -4997,7 +4999,7 @@ kmem_cache_prefill_sheaf(struct kmem_cac
 			stat(s, BARN_GET_FAIL);
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 
 	if (!sheaf)
@@ -5041,7 +5043,7 @@ void kmem_cache_return_sheaf(struct kmem
 		return;
 	}
 
-	local_lock(&s->cpu_sheaves->lock);
+	local_qpw_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	barn = get_barn(s);
 
@@ -5051,7 +5053,7 @@ void kmem_cache_return_sheaf(struct kmem
 		stat(s, SHEAF_RETURN_FAST);
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	if (!sheaf)
 		return;
@@ -5581,7 +5583,7 @@ static void __pcs_install_empty_sheaf(st
 		struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty,
 		struct node_barn *barn)
 {
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	qpw_lockdep_assert_held(&s->cpu_sheaves->lock);
 
 	/* This is what we expect to find if nobody interrupted us. */
 	if (likely(!pcs->spare)) {
@@ -5618,9 +5620,9 @@ static void __pcs_install_empty_sheaf(st
 /*
  * Replace the full main sheaf with a (at least partially) empty sheaf.
  *
- * Must be called with the cpu_sheaves local lock locked. If successful, returns
- * the pcs pointer and the local lock locked (possibly on a different cpu than
- * initially called). If not successful, returns NULL and the local lock
+ * Must be called with the cpu_sheaves qpw lock locked. If successful, returns
+ * the pcs pointer and the qpw lock locked (possibly on a different cpu than
+ * initially called). If not successful, returns NULL and the qpw lock
  * unlocked.
  */
 static struct slub_percpu_sheaves *
@@ -5632,17 +5634,17 @@ __pcs_replace_full_main(struct kmem_cach
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
 
@@ -5679,7 +5681,7 @@ restart:
 		stat(s, BARN_PUT_FAIL);
 
 		pcs->spare = NULL;
-		local_unlock(&s->cpu_sheaves->lock);
+		local_qpw_unlock(&s->cpu_sheaves->lock);
 
 		sheaf_flush_unused(s, to_flush);
 		empty = to_flush;
@@ -5695,7 +5697,7 @@ restart:
 	put_fail = true;
 
 alloc_empty:
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	/*
 	 * alloc_empty_sheaf() doesn't support !allow_spin and it's
@@ -5715,7 +5717,7 @@ alloc_empty:
 	if (!sheaf_try_flush_main(s))
 		return NULL;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		return NULL;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -5731,7 +5733,7 @@ alloc_empty:
 	return pcs;
 
 got_empty:
-	if (!local_trylock(&s->cpu_sheaves->lock)) {
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock)) {
 		barn_put_empty_sheaf(barn, empty);
 		return NULL;
 	}
@@ -5751,7 +5753,7 @@ bool free_to_pcs(struct kmem_cache *s, v
 {
 	struct slub_percpu_sheaves *pcs;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		return false;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -5765,7 +5767,7 @@ bool free_to_pcs(struct kmem_cache *s, v
 
 	pcs->main->objects[pcs->main->size++] = object;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_FASTPATH);
 
@@ -5855,7 +5857,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 
 	lock_map_acquire_try(&kfree_rcu_sheaf_map);
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		goto fail;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -5867,7 +5869,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 
 		/* Bootstrap or debug cache, fall back */
 		if (unlikely(!cache_has_sheaves(s))) {
-			local_unlock(&s->cpu_sheaves->lock);
+			local_qpw_unlock(&s->cpu_sheaves->lock);
 			goto fail;
 		}
 
@@ -5879,7 +5881,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 
 		barn = get_barn(s);
 		if (!barn) {
-			local_unlock(&s->cpu_sheaves->lock);
+			local_qpw_unlock(&s->cpu_sheaves->lock);
 			goto fail;
 		}
 
@@ -5890,14 +5892,14 @@ bool __kfree_rcu_sheaf(struct kmem_cache
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
@@ -5934,7 +5936,7 @@ do_free:
 	if (rcu_sheaf)
 		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_RCU_SHEAF);
 	lock_map_release(&kfree_rcu_sheaf_map);
@@ -5990,7 +5992,7 @@ next_remote_batch:
 		goto flush_remote;
 
 next_batch:
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!local_qpw_trylock(&s->cpu_sheaves->lock))
 		goto fallback;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -6033,7 +6035,7 @@ do_free:
 	memcpy(main->objects + main->size, p, batch * sizeof(void *));
 	main->size += batch;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	stat_add(s, FREE_FASTPATH, batch);
 
@@ -6049,7 +6051,7 @@ do_free:
 	return;
 
 no_empty:
-	local_unlock(&s->cpu_sheaves->lock);
+	local_qpw_unlock(&s->cpu_sheaves->lock);
 
 	/*
 	 * if we depleted all empty sheaves in the barn or there are too
@@ -7454,7 +7456,7 @@ static int init_percpu_sheaves(struct km
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-		local_trylock_init(&pcs->lock);
+		qpw_trylock_init(&pcs->lock);
 
 		/*
 		 * Bootstrap sheaf has zero size so fast-path allocation fails.



