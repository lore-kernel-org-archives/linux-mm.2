Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6423F483DD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01FD6B009D; Mon, 23 Mar 2026 14:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3ED6B009E; Mon, 23 Mar 2026 14:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1646B00A0; Mon, 23 Mar 2026 14:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A193A6B009D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:06:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62810C3AEA
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:26 +0000 (UTC)
X-FDA: 84578107572.07.B9AA065
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 782A54000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W7fGqCKd;
	spf=pass (imf01.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774289184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=OUxDwIV1fHQiGjXtBvudrJH6Xl2HAj9m2MEmb/6VBik=;
	b=DWenujy9uTjs5J2Gy+2qOZkS255cPLZAw5wOzeBSATEF1dI6tT5SuAR1pfVYo/3VQdvOE2
	7f1XPsanu/yGFl6Df6YtV0lFa+1M0WI3Dn5XLdqmMSwseXXUMPUCsLhWllpZ9u22XNKdQp
	9QnpQ18V8+o4LLdZAJ+YuMkv9y6yZ0w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W7fGqCKd;
	spf=pass (imf01.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774289184; a=rsa-sha256;
	cv=none;
	b=gP2XclIkaD78MwK38oMEg6jFoAk4iNNcKk7fS8VSEu132Y99tvxCDxQI6kfmDcVmWA6m01
	m5Znra/GOYaWiyB8OpGcX+dvh7eTwre1vEtcXbbG6HHN13x2bwhIyGX1V6YeBxaa4MSIGU
	tRusnGh4AwUC2nHEptTiVDOMKDwMhLk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774289183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=OUxDwIV1fHQiGjXtBvudrJH6Xl2HAj9m2MEmb/6VBik=;
	b=W7fGqCKdkcctzBQKQOxEuZdbYttpYmz/pqkBllDl0BPIroqdk+CV4sfjYeOL1sC5H2V1zL
	vd3Pp6JsFpNQgqDVUC2CAKut9NkfcWyk7LBp4hWIWQxbx31bMTBaN3W4hgI4ut1Ak6F4kO
	ljPMz/Bzqnhja1Z8gyY21DdCmUcFTCU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-176-za_8YkeiOmKSVoylm3fkEQ-1; Mon,
 23 Mar 2026 14:06:16 -0400
X-MC-Unique: za_8YkeiOmKSVoylm3fkEQ-1
X-Mimecast-MFC-AGG-ID: za_8YkeiOmKSVoylm3fkEQ_1774289174
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8297219560A2;
	Mon, 23 Mar 2026 18:06:13 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A525F180058C;
	Mon, 23 Mar 2026 18:06:11 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id B403A401F5953; Mon, 23 Mar 2026 15:05:44 -0300 (-03)
Message-ID: <20260323180150.304067458@redhat.com>
User-Agent: quilt/0.69
Date: Mon, 23 Mar 2026 14:55:47 -0300
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
Subject: [PATCH v3 3/4] swap: apply new queue_percpu_work_on() interface
References: <20260323175544.807534301@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 5F64ayb9ZZHO5gHOUsGCclPQ4e85_gdiYXSycA5ceN0_1774289174
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Stat-Signature: mrnbppra9n8dzy1uz1msk188keqehet1
X-Rspamd-Queue-Id: 782A54000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774289184-634978
X-HE-Meta: U2FsdGVkX1+pA3LBTwju6nvlE+bS3mMkp55P8UonRpZBu8160kwQmxDBBqhx9nlHxsTMnS33HyQeJa7hrJ+NzEU4jtQ1/hmfbvSOvdjTf/y4TpxAfn8EKkqB2TfiAc3BXpsjXi+TM7Vk2uZWZr7Mq8kNE8ZlsbwpBVN+9pGrpb8HESkir1janePxHYjU95MDfFbQMtviryvV5amPlpGvuJABXejJG5jQycQ/BMWlfGXgasbtW6qRk58Mpc0APxQBYmtHvt5f/k07tCR0GlK1bs2OQprbmhetEwNw9TU9aNNEuFWJkWIllebIZ1QAhSkYJg4Ls6Hz+FmtkmTZU+SgjxvXPrTddRoebTeRB2dc17VnYllrD05K50Uagmy3UOKefguSNZMc0xIHV1fTJ+17ywyKImolr4gzvpu4Vm6D+LZxw/r9BSPv5ANaypopLaUPTydjFsbM12H6/ULelZ75AAdueDD69LZ3OBEDL4ENR0WQ3RKJvCiS53MQj2iCCZmgzg/njvLuZrmNVScGqCmd6DO4flTV+YsPKAIk2smp8CGqybPOZZhm/liGNB/mP539NYJ/A4eCkD1e4YbxzWX8MzPgzwz57G/h6Nn0BbrzEal35hZQv+d8RvCNpL5nJBxf1c9t4SUwog59CRUF0YzHFo0GUO+EVHgM2SX8qI5BC7K4hZj1ZVbeT05GM6rW0YIactUlHH1LtTry5WCx5/t3EDNsQihoU6Z5Woe6Soco6Eh2FIJQX5vhZmRoKIinNe06nuXwfZprChG1lvXQAMZuQHw6fHCsTToBLPPunuSnR0xsL/ynL+YvDpp422YSHZvJsnohjfaV9qS2fAaCSD15vTXNHLCe/bOiqa6lxQIwYGl1ohvFFTvrB/R2ZO0YLa9yDmR99gtDUnPV7gOJc4OiKLxsXGVBeL0APs3o7SZcamD1nc7qCIYCCDxyv9x/5gydbXF7eTDGfsMT1Liiyyh
 kXl3KB7n
 etqTPPX9+5shSPcJMkwNLZ4L6aYrkNwtRr7ZBICuP9x3Tw2XKOwYiX1Fqrty369thZRBbNvKzvvG+CB/2AmjFU/hxBNg4Xc0x9oGxKkbRvX6sap1Wg9qFhNNcD3Cu1BShVkZpufKH4FBXo7pn9HaWLLy9qpc8+Vh21UK8kdpPUzp/kKHj671xDdiPvarqp006ZkU94kCPYrThXLVkxFEFKFTBLTWjgtnduHZpYtChOYlk+UxZSxKhskBG2XJtcmPm8hQwmPOj8A+uZhfGd1b8LX5FA9AqrNX9R3eAwTusMwYCNiQsg7Yb8aK0R92bntgligwhVQMDp6bXmZSvvvSQhiJIm65lr3rT0ahJTGG9DzGiVRIcoe4KwbCWLyOAtwz++DY04slZq0gZu1rcPEAkRyFPa4wzMSY51sU6tzept6KnMpMn/WxPykNZYH1hRDWtR/15
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



