Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A890EA4E24
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 322EF6B0099; Mon,  2 Mar 2026 10:53:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B83C6B009B; Mon,  2 Mar 2026 10:53:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20666B009E; Mon,  2 Mar 2026 10:53:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE4AD6B0099
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:53:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7B201B57AE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:35 +0000 (UTC)
X-FDA: 84501567990.23.21E5622
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id BFE9580009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zzto++Fh;
	spf=pass (imf02.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=OUxDwIV1fHQiGjXtBvudrJH6Xl2HAj9m2MEmb/6VBik=;
	b=JX6I6d6yAl5RmV54ixGtJ7Xuyv2IBKuITMfpJGjpgonJOH9luqI1Ipb0EFwMHax+OtQPeV
	zT713Va6KG/U2s3Fk9W7/76XPLgttf0BN/Nstk2WOBuWS6XnQAmlH9f1IH8eO99P52PMka
	Q+w7bSrkGn4cg8ZKtuhxFsWE1a240cY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zzto++Fh;
	spf=pass (imf02.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466813; a=rsa-sha256;
	cv=none;
	b=Mn4VqBMDT61BauwiitJ4sD8ZwZukLIZlb63P2BG4Y+LFAbHIR5elXmZG+zyFG/ioWZzSwB
	/FNXkuKs8Cp50Kwvo/jyNfXKwgQbHEWEi+PPDnOE/8jdTeI+KHv6appf52+YbnKTbWLjh8
	l7I8dFRaRDvsMqa5M6FEg51/e+O+J9o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772466813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=OUxDwIV1fHQiGjXtBvudrJH6Xl2HAj9m2MEmb/6VBik=;
	b=Zzto++FhYIIly8pk27jQeZIHugo/Gt8XNPfv8OvaYM4aFwj6xTEQRuyFmbi7jVl5OqFdDS
	qHcc1UytypJ0RQ4j/ZOHw+l12DYCf2b2nad8r5aQ6UL3nNM9sDjXLHAlXUL1XbM/EPVKX4
	y6sqoiyvo33CYfgiOZ7zNQZRH5bRdGA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-VXjnp75hNN-bvcAijeasBw-1; Mon,
 02 Mar 2026 10:53:29 -0500
X-MC-Unique: VXjnp75hNN-bvcAijeasBw-1
X-Mimecast-MFC-AGG-ID: VXjnp75hNN-bvcAijeasBw_1772466807
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBFE218004AD;
	Mon,  2 Mar 2026 15:53:26 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2FA8719560A7;
	Mon,  2 Mar 2026 15:53:26 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id A895C4025F125; Mon,  2 Mar 2026 12:53:00 -0300 (-03)
Message-ID: <20260302155105.275396307@redhat.com>
User-Agent: quilt/0.69
Date: Mon, 02 Mar 2026 12:49:49 -0300
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
Subject: [PATCH v2 4/5] swap: apply new queue_percpu_work_on() interface
References: <20260302154945.143996316@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: CNlekVRh9ERdyyJysN_3BKBwMKnc4XSaYovNfnICMrk_1772466807
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: y1uumtk9t7s5ba3apoa6mt3mfinai3o7
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: BFE9580009
X-HE-Tag: 1772466813-739608
X-HE-Meta: U2FsdGVkX1/o1heLISkAg/fZh7kbyvQ/wQlNn+DhiCazV0lauOhxwwK1BeNRJmh7oW/GJhrlB+oZUbP9XyKpUpOjTqa35HPV2S0DuT8CtBZdxNKLOHYY2Ge+xYAbUbVPtbCJ+WH3bvD5ZO1AS8r2qmuqb9Eu6HHSXxW3eve3z3HADXtyF0URjKBVyWPKkNVpVEMn229VeSW4RgJuc1vktSFaKWDr0JA3hgI0Kw+gFMS9seNN85ZuKu6qz8nt4G72t7xeGISibjYlyNvCc0sJV8ANh86lPXos2YZcTk1/OVwlibEVhjTm19BqfzGA4jc/ddhSfsHFt4BjizepW3EgUYH5+CQakBCrT2D/MqGj8ZUAiaJ6uPHgnCJAqz7LfZEJz8yahtHC5+yA1qXsJljC4k8m1hRByL4go6r3sJxQCaEm/UtK3mMatcM7KSLsVG4RK/jTfIT6sb8i2NffR99HGiUUX+dT3UiIwOGBfmGV5DXZKE62YNoDOXkD6JmCk1TKCNdqHQsUrq0iRE2Rrukpg5nGlXwtk8f5LEWrR8awpOsg/f8BNI2o/oLrvvZkwl6u5LtF6diNLts6se5xniU4r241iO0b0ytc36Itwp8NLzC0HcZ+v8rvaLRhvs2oFqG4dL+E7fnVwKUYiwSYH2S3fmoNBfcEx0/f7r6NJgng6CGNQGRtR+GDghXlk41kcve8IsPQ0eoshKTgaql6ErCyE/qptPa17C73VpSl/8zOUucE98Bb4OVBQ13pdo8yju6QhIpFtlloLzNxLjIBIZxuoodFSyFmiBNPPnEb9Gq+TQiR7C4zonVXO+AzmGLHN02xxdD1Nun1V41wcsFfSQspNaastpf7iKcqbxb/S2YWkGIotR+KA90WAVNvQhAMkD9iR8NXKv5w9pMAiFfzBru0oq5RAggUGz0VQAMgTRrRU+EygVcnKoraZ1WVuBbfeEh7PmjPoHaWiSv2OWlBwyO
 +JY0IQLT
 oqqOy+mlsm+mbWTRO+NKr8x4s/e309PLmzrwtld4rD7NpiYZrlS3B/Y6/oTOAoHCirM5G2zegoF0IhFt+qQLnPSRoP7JBqgWHBeGD+nrGCV9cV6P098zZXPnXgzrLe6mQYrhjHmOvq1YlSMemdGOpOpIw3QZa+VTbOSFszCIeoXLw0pMmwNkqCv37sVGgx1RbrwfzH6q5A9pXPKoPfgDCvicBF98mUf9cO2LVKt++68OBLZi/lJTviMUB8zCrFeUHvEZg8qPoLz7ldiA3DaLkRRWTTts6GuU4HDVDl+U8qU4v76IRPlw5/RIlZjB1o5yppHR+lndzb+vNdLSfaLcKmY2JoD4wDSJd8kEdqptufAodA8AtgAJIhuzACQ2pdtP32bW96iZBwlsTGMOcBvsp092rMXM5MQO3/drWb3fgOG1tnYCqFfxXCL7g2WGjjKWey25k
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

The change requires allocation of qpw_structs instead of a work_structs,
and changing parameters of a few functions to include the cpu parameter.

This should bring no relevant performance impact on non-QPW kernels:
For functions that may be scheduled in a different cpu, the local_*lock's
this_cpu_ptr() becomes a per_cpu_ptr(smp_processor_id()).

Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 mm/internal.h   |    4 ++-
 mm/mlock.c      |   51 ++++++++++++++++++++++++++++++-----------
 mm/page_alloc.c |    2 -
 mm/swap.c       |   69 ++++++++++++++++++++++++++++++--------------------------
 4 files changed, 79 insertions(+), 47 deletions(-)

Index: linux/mm/mlock.c
===================================================================
--- linux.orig/mm/mlock.c
+++ linux/mm/mlock.c
@@ -25,17 +25,16 @@
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h>
 #include <linux/secretmem.h>
+#include <linux/qpw.h>
 
 #include "internal.h"
 
 struct mlock_fbatch {
-	local_lock_t lock;
+	qpw_lock_t lock;
 	struct folio_batch fbatch;
 };
 
-static DEFINE_PER_CPU(struct mlock_fbatch, mlock_fbatch) = {
-	.lock = INIT_LOCAL_LOCK(lock),
-};
+static DEFINE_PER_CPU(struct mlock_fbatch, mlock_fbatch);
 
 bool can_do_mlock(void)
 {
@@ -209,18 +208,29 @@ static void mlock_folio_batch(struct fol
 	folios_put(fbatch);
 }
 
+void mlock_drain_cpu(int cpu)
+{
+	struct folio_batch *fbatch;
+
+	qpw_lock(&mlock_fbatch.lock, cpu);
+	fbatch = per_cpu_ptr(&mlock_fbatch.fbatch, cpu);
+	if (folio_batch_count(fbatch))
+		mlock_folio_batch(fbatch);
+	qpw_unlock(&mlock_fbatch.lock, cpu);
+}
+
 void mlock_drain_local(void)
 {
 	struct folio_batch *fbatch;
 
-	local_lock(&mlock_fbatch.lock);
+	local_qpw_lock(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
 	if (folio_batch_count(fbatch))
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	local_qpw_unlock(&mlock_fbatch.lock);
 }
 
-void mlock_drain_remote(int cpu)
+void mlock_drain_offline(int cpu)
 {
 	struct folio_batch *fbatch;
 
@@ -243,7 +253,7 @@ void mlock_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
 
-	local_lock(&mlock_fbatch.lock);
+	local_qpw_lock(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
 
 	if (!folio_test_set_mlocked(folio)) {
@@ -257,7 +267,7 @@ void mlock_folio(struct folio *folio)
 	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	local_qpw_unlock(&mlock_fbatch.lock);
 }
 
 /**
@@ -269,7 +279,7 @@ void mlock_new_folio(struct folio *folio
 	struct folio_batch *fbatch;
 	int nr_pages = folio_nr_pages(folio);
 
-	local_lock(&mlock_fbatch.lock);
+	local_qpw_lock(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
 	folio_set_mlocked(folio);
 
@@ -280,7 +290,7 @@ void mlock_new_folio(struct folio *folio
 	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	local_qpw_unlock(&mlock_fbatch.lock);
 }
 
 /**
@@ -291,7 +301,7 @@ void munlock_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
 
-	local_lock(&mlock_fbatch.lock);
+	local_qpw_lock(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
 	/*
 	 * folio_test_clear_mlocked(folio) must be left to __munlock_folio(),
@@ -301,7 +311,7 @@ void munlock_folio(struct folio *folio)
 	if (!folio_batch_add(fbatch, folio) ||
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	local_qpw_unlock(&mlock_fbatch.lock);
 }
 
 static inline unsigned int folio_mlock_step(struct folio *folio,
@@ -823,3 +833,18 @@ void user_shm_unlock(size_t size, struct
 	spin_unlock(&shmlock_user_lock);
 	put_ucounts(ucounts);
 }
+
+int __init mlock_init(void)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct mlock_fbatch *fbatch = &per_cpu(mlock_fbatch, cpu);
+
+		qpw_lock_init(&fbatch->lock);
+	}
+
+	return 0;
+}
+
+module_init(mlock_init);
Index: linux/mm/swap.c
===================================================================
--- linux.orig/mm/swap.c
+++ linux/mm/swap.c
@@ -35,7 +35,7 @@
 #include <linux/uio.h>
 #include <linux/hugetlb.h>
 #include <linux/page_idle.h>
-#include <linux/local_lock.h>
+#include <linux/qpw.h>
 #include <linux/buffer_head.h>
 
 #include "internal.h"
@@ -52,7 +52,7 @@ struct cpu_fbatches {
 	 * The following folio batches are grouped together because they are protected
 	 * by disabling preemption (and interrupts remain enabled).
 	 */
-	local_lock_t lock;
+	qpw_lock_t lock;
 	struct folio_batch lru_add;
 	struct folio_batch lru_deactivate_file;
 	struct folio_batch lru_deactivate;
@@ -61,14 +61,11 @@ struct cpu_fbatches {
 	struct folio_batch lru_activate;
 #endif
 	/* Protecting the following batches which require disabling interrupts */
-	local_lock_t lock_irq;
+	qpw_lock_t lock_irq;
 	struct folio_batch lru_move_tail;
 };
 
-static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
-	.lock = INIT_LOCAL_LOCK(lock),
-	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
-};
+static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches);
 
 static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
 		unsigned long *flagsp)
@@ -187,18 +184,18 @@ static void __folio_batch_add_and_move(s
 	folio_get(folio);
 
 	if (disable_irq)
-		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
+		local_qpw_lock_irqsave(&cpu_fbatches.lock_irq, flags);
 	else
-		local_lock(&cpu_fbatches.lock);
+		local_qpw_lock(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
 			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
-		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
+		local_qpw_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
 	else
-		local_unlock(&cpu_fbatches.lock);
+		local_qpw_unlock(&cpu_fbatches.lock);
 }
 
 #define folio_batch_add_and_move(folio, op)		\
@@ -359,7 +356,7 @@ static void __lru_cache_activate_folio(s
 	struct folio_batch *fbatch;
 	int i;
 
-	local_lock(&cpu_fbatches.lock);
+	local_qpw_lock(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
 
 	/*
@@ -381,7 +378,7 @@ static void __lru_cache_activate_folio(s
 		}
 	}
 
-	local_unlock(&cpu_fbatches.lock);
+	local_qpw_unlock(&cpu_fbatches.lock);
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -653,9 +650,9 @@ void lru_add_drain_cpu(int cpu)
 		unsigned long flags;
 
 		/* No harm done if a racing interrupt already did this */
-		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
+		qpw_lock_irqsave(&cpu_fbatches.lock_irq, flags, cpu);
 		folio_batch_move_lru(fbatch, lru_move_tail);
-		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
+		qpw_unlock_irqrestore(&cpu_fbatches.lock_irq, flags, cpu);
 	}
 
 	fbatch = &fbatches->lru_deactivate_file;
@@ -733,9 +730,9 @@ void folio_mark_lazyfree(struct folio *f
 
 void lru_add_drain(void)
 {
-	local_lock(&cpu_fbatches.lock);
+	local_qpw_lock(&cpu_fbatches.lock);
 	lru_add_drain_cpu(smp_processor_id());
-	local_unlock(&cpu_fbatches.lock);
+	local_qpw_unlock(&cpu_fbatches.lock);
 	mlock_drain_local();
 }
 
@@ -745,30 +742,30 @@ void lru_add_drain(void)
  * the same cpu. It shouldn't be a problem in !SMP case since
  * the core is only one and the locks will disable preemption.
  */
-static void lru_add_mm_drain(void)
+static void lru_add_mm_drain(int cpu)
 {
-	local_lock(&cpu_fbatches.lock);
-	lru_add_drain_cpu(smp_processor_id());
-	local_unlock(&cpu_fbatches.lock);
-	mlock_drain_local();
+	qpw_lock(&cpu_fbatches.lock, cpu);
+	lru_add_drain_cpu(cpu);
+	qpw_unlock(&cpu_fbatches.lock, cpu);
+	mlock_drain_cpu(cpu);
 }
 
 void lru_add_drain_cpu_zone(struct zone *zone)
 {
-	local_lock(&cpu_fbatches.lock);
+	local_qpw_lock(&cpu_fbatches.lock);
 	lru_add_drain_cpu(smp_processor_id());
 	drain_local_pages(zone);
-	local_unlock(&cpu_fbatches.lock);
+	local_qpw_unlock(&cpu_fbatches.lock);
 	mlock_drain_local();
 }
 
 #ifdef CONFIG_SMP
 
-static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
+static DEFINE_PER_CPU(struct qpw_struct, lru_add_drain_qpw);
 
-static void lru_add_drain_per_cpu(struct work_struct *dummy)
+static void lru_add_drain_per_cpu(struct work_struct *w)
 {
-	lru_add_mm_drain();
+	lru_add_mm_drain(qpw_get_cpu(w));
 }
 
 static DEFINE_PER_CPU(struct work_struct, bh_add_drain_work);
@@ -883,12 +880,12 @@ static inline void __lru_add_drain_all(b
 	cpumask_clear(&has_mm_work);
 	cpumask_clear(&has_bh_work);
 	for_each_online_cpu(cpu) {
-		struct work_struct *mm_work = &per_cpu(lru_add_drain_work, cpu);
+		struct qpw_struct *mm_qpw = &per_cpu(lru_add_drain_qpw, cpu);
 		struct work_struct *bh_work = &per_cpu(bh_add_drain_work, cpu);
 
 		if (cpu_needs_mm_drain(cpu)) {
-			INIT_WORK(mm_work, lru_add_drain_per_cpu);
-			queue_work_on(cpu, mm_percpu_wq, mm_work);
+			INIT_QPW(mm_qpw, lru_add_drain_per_cpu, cpu);
+			queue_percpu_work_on(cpu, mm_percpu_wq, mm_qpw);
 			__cpumask_set_cpu(cpu, &has_mm_work);
 		}
 
@@ -900,7 +897,7 @@ static inline void __lru_add_drain_all(b
 	}
 
 	for_each_cpu(cpu, &has_mm_work)
-		flush_work(&per_cpu(lru_add_drain_work, cpu));
+		flush_percpu_work(&per_cpu(lru_add_drain_qpw, cpu));
 
 	for_each_cpu(cpu, &has_bh_work)
 		flush_work(&per_cpu(bh_add_drain_work, cpu));
@@ -950,7 +947,7 @@ void lru_cache_disable(void)
 #ifdef CONFIG_SMP
 	__lru_add_drain_all(true);
 #else
-	lru_add_mm_drain();
+	lru_add_mm_drain(smp_processor_id());
 	invalidate_bh_lrus_cpu();
 #endif
 }
@@ -1124,6 +1121,7 @@ static const struct ctl_table swap_sysct
 void __init swap_setup(void)
 {
 	unsigned long megs = PAGES_TO_MB(totalram_pages());
+	unsigned int cpu;
 
 	/* Use a smaller cluster for small-memory machines */
 	if (megs < 16)
@@ -1136,4 +1134,11 @@ void __init swap_setup(void)
 	 */
 
 	register_sysctl_init("vm", swap_sysctl_table);
+
+	for_each_possible_cpu(cpu) {
+		struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
+
+		qpw_lock_init(&fbatches->lock);
+		qpw_lock_init(&fbatches->lock_irq);
+	}
 }
Index: linux/mm/internal.h
===================================================================
--- linux.orig/mm/internal.h
+++ linux/mm/internal.h
@@ -1140,10 +1140,12 @@ static inline void munlock_vma_folio(str
 		munlock_folio(folio);
 }
 
+int __init mlock_init(void);
 void mlock_new_folio(struct folio *folio);
 bool need_mlock_drain(int cpu);
 void mlock_drain_local(void);
-void mlock_drain_remote(int cpu);
+void mlock_drain_cpu(int cpu);
+void mlock_drain_offline(int cpu);
 
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c
+++ linux/mm/page_alloc.c
@@ -6285,7 +6285,7 @@ static int page_alloc_cpu_dead(unsigned
 	struct zone *zone;
 
 	lru_add_drain_cpu(cpu);
-	mlock_drain_remote(cpu);
+	mlock_drain_offline(cpu);
 	drain_pages(cpu);
 
 	/*



