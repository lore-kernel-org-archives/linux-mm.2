Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DE8EE20A8
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 14:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3C96B0098; Fri,  6 Feb 2026 09:40:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3603E6B0099; Fri,  6 Feb 2026 09:40:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9D96B009B; Fri,  6 Feb 2026 09:40:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EED1C6B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:40:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A18E21B19AD
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:40:20 +0000 (UTC)
X-FDA: 84414292200.26.67FED02
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id AE2B4140002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:40:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TA2WlOt0;
	spf=pass (imf26.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770388818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=u+vDHDuyg1tZxOCkT1e6XPP9sTvmKQrxuHI3KpZjiIU=;
	b=W5l3bVRW5ZcaX3U76RfVQld/wXr8YENYwcH5RYYqGdtcFgd1pOmRjqClmQVYGf2TGCWkvX
	yy6+q3vr9n2vjxz5xbpFG/PisaROfPllg7fyhhObT7eJDtrlZu8lI5IbxUc8yicS3xJGTl
	QXxN82hq9TKSt90o3yaRluzBQ3sBvtM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TA2WlOt0;
	spf=pass (imf26.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770388818; a=rsa-sha256;
	cv=none;
	b=cGFPVwh7R7E+LqBMGAMXi3fLYMKbhtpm4cf+Op83dm65YPWHeiQPwtaGzgEARBKCH/73DC
	h6l65nAYbLsGBXxpbKZVAt7ag9SMZJyrId+jDHZWBer+zFjmR1waZKvwA55cIcajVD3VaK
	3W8SsRhL0IAZnRpgGbVxELpECy5YCuo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770388818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=u+vDHDuyg1tZxOCkT1e6XPP9sTvmKQrxuHI3KpZjiIU=;
	b=TA2WlOt09YHyv8SUmGWeTohDwzGFxh6Nl54YCj22EF3LYp8ZS3IAHfzaWo6MBfZoia985K
	9qCQYVIZ/ddmZ+glZNTJ7sy73bASuNRxKhEKIYTHOc8fd86Sxo9SlBd+SJk4fLCFoktBRA
	NBDANuN3GgFog8RATe7y/vS0rPCs/Uk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-450--cr5hfH1OYSwaV0E10P2yA-1; Fri,
 06 Feb 2026 09:40:12 -0500
X-MC-Unique: -cr5hfH1OYSwaV0E10P2yA-1
X-Mimecast-MFC-AGG-ID: -cr5hfH1OYSwaV0E10P2yA_1770388810
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B95CA1955F68;
	Fri,  6 Feb 2026 14:40:09 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.22.74.16])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 793AF1800464;
	Fri,  6 Feb 2026 14:40:07 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id B0BD0401E2F84; Fri,  6 Feb 2026 11:39:20 -0300 (-03)
Message-ID: <20260206143741.589656953@redhat.com>
User-Agent: quilt/0.66
Date: Fri, 06 Feb 2026 11:34:33 -0300
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
Subject: [PATCH 3/4] swap: apply new queue_percpu_work_on() interface
References: <20260206143430.021026873@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: U2Gl8lEJ_8f-p1bWJ3kZ4CE8Q8C5OslUMuBJmKOjpTE_1770388810
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: 1x8g3podasjkojcktgaoh4az7ogfrxjd
X-Rspamd-Queue-Id: AE2B4140002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770388818-931898
X-HE-Meta: U2FsdGVkX19a9k7nTmP7Zl0xeV2qdmRdViOPq/Xn9Kis1HiLdSVcGVLnjvPtYu1+KZ3LCHV705p8BjLnu1T+rtSiVnV7zdq6/U0WA7S/hmGheSpDZxIGwyIq7iFs/A/RjLNZQoGMF7W/Cw0Bq02HJjLs9r/5KCAWuLhVRZJ6mc09GFTdAA95bLNgw67J4hBt+r+QNY43VMeB3Y4L7qRGpPa45EkMOHiF97ZayY0zvZOwsh7hcRBFZfWsqSriATn9qCnWAXFylZDhPo/E2+94RpxwlH+xsELMjQJlVMXlwwI+7X4y0+020f/bMvSRQvYRe3us0qG71QKvFSXQsYTI1j6xe8D9vIzOHRGegweur+shfA2JjJXZommctvAmo7KtSxfwSYi+ucq5hnA5pjYmz/9/IKa+V8ibGWZl1UWJogSYeRK9hbSW2zntT6+PypcSwHYmlBqVT8dc++7QT6Nu/z89MK5jAQvHIHv9DPgK02lNTPkW4WRdU9nr6qWQZ2vnd2ITBKtoB84Ek4f6a6xzhPpiwVAbBVKtXY9lLCRFDn82kvTjt1WMDUMAiQlioZ0YoJb/lOlJOMy/oLi8G0DxVq8RCzM48c2Mh08ReWBYq943D9zAN6sduw3Ape/avaImB6ZugAGn131mjoghgbLYtJsnrecJSsf2tniU2PqEL8ykRBihdK/oOSyDRzofg4wNQQfun5un2xBZISQgsgbf2n5qL65FgpOgJkzJ0G6g/b77ref4T7z2Y9B+ZT1cbnm6/Q0H0AZpdcqIlnDYqv5NJYhjdy2gOR2AbFbNzL19oSOY9Kz05kJoEZwgrhBh1Yg7ygQtqcmCZBvJU4GGdZZOBpG9CTcOQx8QmeEGw+gKQU6SS3Cx3edEUUjxyI4diZHSSH7FtQWtCAGsI1jmPNsOIuzf9ul8ybSVzpk9wuqsb83dd2TfPaa1sFj523Sl8xCwy04Y0o1MhytYL+UwLy5
 oJAh0qtv
 T0Aa5O8knVz3ONnWFqHYojTUJmNZrpz0+1PT2TYNKSOsTLCZDc5/YKCCnDDPGTLG3JfpUrYILYJrDK/K4fxwE+7rK2XMl4iinqiEiyvmCZDh296EXQ3XeUmh/4RJd/Q59CN8oEpRgdg1WsDgU+iOdzZNX4XLvtwGrLyWDv7jawPwjrv3aJvavmjOEdglfCBdugJ4AXsws0cNq6zc9O/SZSQ6zIbUU554gIEev41uM44p7IJRhAzVN4LasshSQg1ea8PAJdO7HyVWcPc6JHPCr0lTWS95ldcpIvi6S1k41LgbarvDsiV/nXUgmTkQPMntGvWd/xqXZP7TuCqwry4If0rlnRZZeGS4M75CZWxWBlnmO+rMV2srGrURtKe7vZmWr44ix5tnLmiOhEhYJ83tBg+gSeO2YkFyg1o4cFQWamau9zFo=
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

The change requires allocation of qpw_structs instead of a work_structs,
and changing parameters of a few functions to include the cpu parameter.

This should bring no relevant performance impact on non-RT kernels:
For functions that may be scheduled in a different cpu, the local_*lock's
this_cpu_ptr() becomes a per_cpu_ptr(smp_processor_id()).

Signed-off-by: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 mm/internal.h   |    4 +-
 mm/mlock.c      |   71 ++++++++++++++++++++++++++++++++------------
 mm/page_alloc.c |    2 -
 mm/swap.c       |   90 +++++++++++++++++++++++++++++++-------------------------
 4 files changed, 108 insertions(+), 59 deletions(-)

Index: slab/mm/mlock.c
===================================================================
--- slab.orig/mm/mlock.c
+++ slab/mm/mlock.c
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
@@ -209,18 +208,25 @@ static void mlock_folio_batch(struct fol
 	folios_put(fbatch);
 }
 
-void mlock_drain_local(void)
+void mlock_drain_cpu(int cpu)
 {
 	struct folio_batch *fbatch;
 
-	local_lock(&mlock_fbatch.lock);
-	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
+	qpw_lock(&mlock_fbatch.lock, cpu);
+	fbatch = per_cpu_ptr(&mlock_fbatch.fbatch, cpu);
 	if (folio_batch_count(fbatch))
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	qpw_unlock(&mlock_fbatch.lock, cpu);
 }
 
-void mlock_drain_remote(int cpu)
+void mlock_drain_local(void)
+{
+	migrate_disable();
+	mlock_drain_cpu(smp_processor_id());
+	migrate_enable();
+}
+
+void mlock_drain_offline(int cpu)
 {
 	struct folio_batch *fbatch;
 
@@ -242,9 +248,12 @@ bool need_mlock_drain(int cpu)
 void mlock_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
+	int cpu;
 
-	local_lock(&mlock_fbatch.lock);
-	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
+	migrate_disable();
+	cpu = smp_processor_id();
+	qpw_lock(&mlock_fbatch.lock, cpu);
+	fbatch = per_cpu_ptr(&mlock_fbatch.fbatch, cpu);
 
 	if (!folio_test_set_mlocked(folio)) {
 		int nr_pages = folio_nr_pages(folio);
@@ -257,7 +266,8 @@ void mlock_folio(struct folio *folio)
 	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	qpw_unlock(&mlock_fbatch.lock, cpu);
+	migrate_enable();
 }
 
 /**
@@ -268,9 +278,13 @@ void mlock_new_folio(struct folio *folio
 {
 	struct folio_batch *fbatch;
 	int nr_pages = folio_nr_pages(folio);
+	int cpu;
+
+	migrate_disable();
+	cpu = smp_processor_id();
+	qpw_lock(&mlock_fbatch.lock, cpu);
 
-	local_lock(&mlock_fbatch.lock);
-	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
+	fbatch = per_cpu_ptr(&mlock_fbatch.fbatch, cpu);
 	folio_set_mlocked(folio);
 
 	zone_stat_mod_folio(folio, NR_MLOCK, nr_pages);
@@ -280,7 +294,8 @@ void mlock_new_folio(struct folio *folio
 	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	migrate_enable();
+	qpw_unlock(&mlock_fbatch.lock, cpu);
 }
 
 /**
@@ -290,9 +305,13 @@ void mlock_new_folio(struct folio *folio
 void munlock_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
+	int cpu;
 
-	local_lock(&mlock_fbatch.lock);
-	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
+	migrate_disable();
+	cpu = smp_processor_id();
+	qpw_lock(&mlock_fbatch.lock, cpu);
+
+	fbatch = per_cpu_ptr(&mlock_fbatch.fbatch, cpu);
 	/*
 	 * folio_test_clear_mlocked(folio) must be left to __munlock_folio(),
 	 * which will check whether the folio is multiply mlocked.
@@ -301,7 +320,8 @@ void munlock_folio(struct folio *folio)
 	if (!folio_batch_add(fbatch, folio) ||
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	qpw_unlock(&mlock_fbatch.lock, cpu);
+	migrate_enable();
 }
 
 static inline unsigned int folio_mlock_step(struct folio *folio,
@@ -823,3 +843,18 @@ void user_shm_unlock(size_t size, struct
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
Index: slab/mm/swap.c
===================================================================
--- slab.orig/mm/swap.c
+++ slab/mm/swap.c
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
@@ -183,22 +180,24 @@ static void __folio_batch_add_and_move(s
 		struct folio *folio, move_fn_t move_fn, bool disable_irq)
 {
 	unsigned long flags;
+	int cpu;
 
 	folio_get(folio);
 
+	cpu = smp_processor_id();
 	if (disable_irq)
-		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
+		qpw_lock_irqsave(&cpu_fbatches.lock_irq, flags, cpu);
 	else
-		local_lock(&cpu_fbatches.lock);
+		qpw_lock(&cpu_fbatches.lock, cpu);
 
-	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
+	if (!folio_batch_add(per_cpu_ptr(fbatch, cpu), folio) ||
 			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
-		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
+		folio_batch_move_lru(per_cpu_ptr(fbatch, cpu), move_fn);
 
 	if (disable_irq)
-		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
+		qpw_unlock_irqrestore(&cpu_fbatches.lock_irq, flags, cpu);
 	else
-		local_unlock(&cpu_fbatches.lock);
+		qpw_unlock(&cpu_fbatches.lock, cpu);
 }
 
 #define folio_batch_add_and_move(folio, op)		\
@@ -358,9 +357,10 @@ static void __lru_cache_activate_folio(s
 {
 	struct folio_batch *fbatch;
 	int i;
+	int cpu = smp_processor_id();
 
-	local_lock(&cpu_fbatches.lock);
-	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
+	qpw_lock(&cpu_fbatches.lock, cpu);
+	fbatch = per_cpu_ptr(&cpu_fbatches.lru_add, cpu);
 
 	/*
 	 * Search backwards on the optimistic assumption that the folio being
@@ -381,7 +381,7 @@ static void __lru_cache_activate_folio(s
 		}
 	}
 
-	local_unlock(&cpu_fbatches.lock);
+	qpw_unlock(&cpu_fbatches.lock, cpu);
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -653,9 +653,9 @@ void lru_add_drain_cpu(int cpu)
 		unsigned long flags;
 
 		/* No harm done if a racing interrupt already did this */
-		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
+		qpw_lock_irqsave(&cpu_fbatches.lock_irq, flags, cpu);
 		folio_batch_move_lru(fbatch, lru_move_tail);
-		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
+		qpw_unlock_irqrestore(&cpu_fbatches.lock_irq, flags, cpu);
 	}
 
 	fbatch = &fbatches->lru_deactivate_file;
@@ -733,10 +733,12 @@ void folio_mark_lazyfree(struct folio *f
 
 void lru_add_drain(void)
 {
-	local_lock(&cpu_fbatches.lock);
-	lru_add_drain_cpu(smp_processor_id());
-	local_unlock(&cpu_fbatches.lock);
-	mlock_drain_local();
+	int cpu = smp_processor_id();
+
+	qpw_lock(&cpu_fbatches.lock, cpu);
+	lru_add_drain_cpu(cpu);
+	qpw_unlock(&cpu_fbatches.lock, cpu);
+	mlock_drain_cpu(cpu);
 }
 
 /*
@@ -745,30 +747,32 @@ void lru_add_drain(void)
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
-	lru_add_drain_cpu(smp_processor_id());
+	int cpu = smp_processor_id();
+
+	qpw_lock(&cpu_fbatches.lock, cpu);
+	lru_add_drain_cpu(cpu);
 	drain_local_pages(zone);
-	local_unlock(&cpu_fbatches.lock);
-	mlock_drain_local();
+	qpw_unlock(&cpu_fbatches.lock, cpu);
+	mlock_drain_cpu(cpu);
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
@@ -883,12 +887,12 @@ static inline void __lru_add_drain_all(b
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
 
@@ -900,7 +904,7 @@ static inline void __lru_add_drain_all(b
 	}
 
 	for_each_cpu(cpu, &has_mm_work)
-		flush_work(&per_cpu(lru_add_drain_work, cpu));
+		flush_percpu_work(&per_cpu(lru_add_drain_qpw, cpu));
 
 	for_each_cpu(cpu, &has_bh_work)
 		flush_work(&per_cpu(bh_add_drain_work, cpu));
@@ -950,7 +954,7 @@ void lru_cache_disable(void)
 #ifdef CONFIG_SMP
 	__lru_add_drain_all(true);
 #else
-	lru_add_mm_drain();
+	lru_add_mm_drain(smp_processor_id());
 	invalidate_bh_lrus_cpu();
 #endif
 }
@@ -1124,6 +1128,7 @@ static const struct ctl_table swap_sysct
 void __init swap_setup(void)
 {
 	unsigned long megs = PAGES_TO_MB(totalram_pages());
+	unsigned int cpu;
 
 	/* Use a smaller cluster for small-memory machines */
 	if (megs < 16)
@@ -1136,4 +1141,11 @@ void __init swap_setup(void)
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
Index: slab/mm/internal.h
===================================================================
--- slab.orig/mm/internal.h
+++ slab/mm/internal.h
@@ -1061,10 +1061,12 @@ static inline void munlock_vma_folio(str
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
 
Index: slab/mm/page_alloc.c
===================================================================
--- slab.orig/mm/page_alloc.c
+++ slab/mm/page_alloc.c
@@ -6251,7 +6251,7 @@ static int page_alloc_cpu_dead(unsigned
 	struct zone *zone;
 
 	lru_add_drain_cpu(cpu);
-	mlock_drain_remote(cpu);
+	mlock_drain_offline(cpu);
 	drain_pages(cpu);
 
 	/*



