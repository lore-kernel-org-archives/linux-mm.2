Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25074CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE2A6B00CE; Thu, 20 Nov 2025 10:13:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F0C6B00D0; Thu, 20 Nov 2025 10:13:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627276B00D1; Thu, 20 Nov 2025 10:13:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 477786B00CE
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED931B6582
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:39 +0000 (UTC)
X-FDA: 84131329758.15.F18E17E
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0527510001B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="oepXEv7/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3IDAfaQUKCE0t0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3IDAfaQUKCE0t0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651618; a=rsa-sha256;
	cv=none;
	b=Bu4wGFI6VRpgTyjAg2T/KJwXr0o82tITWyxAPr5nU1oDgbE0eKPoMIoSOZj7jrfsWDNcEu
	u/ZfoD/oaYQaDwimRGPOb1ILKYPamEBnstWBMXj8Gi32bG1cYvpAoBbd5mFXzQDrSMYQVl
	5oBgUsuMeG79IiEt5Ghn+VeJsXlWvWY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="oepXEv7/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3IDAfaQUKCE0t0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3IDAfaQUKCE0t0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mqBL95K9iMIYpMB+0uabPzgdi4RlMsfaN5hL0tFWKIQ=;
	b=HvX60doEZS6X0ygrSV2YwXuRN0PhOnLC1rUqZNWtMOgna4QnXRGZdRnprnAbh43Ab0pyWi
	cykhTOnJT84k9nyiLc7woUqJeZ3SFe4ti6no+Q4LpCf9mE/qR+CaImtdZU7/IJdpFV+Qiv
	50jlpIbVt2MGJsTqQacLMIZcyvFHLrc=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-429cceeeb96so567022f8f.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651616; x=1764256416; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mqBL95K9iMIYpMB+0uabPzgdi4RlMsfaN5hL0tFWKIQ=;
        b=oepXEv7/4kBHrdAuDovBy01PgALWSKnrgvtzzF0wdvnqBpnLvAuh5qzwNF4K8AZUGm
         8gyPlJPdL5/QUbI5x13lKj9gyZfTO9CONbMf/mTTab/wQsDm5Qa7qE9a7lAAgH5K0lrJ
         Z19wOhXmfx1zwYKVsY8L7ZVXJHlNoyw+aBchqDyFML5rLCPbCPM41qd2iquEPyuxi7tZ
         lNphjQc2u+dooW6T3XNQXyybeRIA+B/CEdvxIs8LWE08+YqGEAzDv61w6K+wSWNUHrnb
         +FTNAUy9yLz+Vh/9R25akEL+rGroRdzky4FmpxniVWl7jEA3rgRtMELdo1S+amlGvsXP
         bpsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651616; x=1764256416;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mqBL95K9iMIYpMB+0uabPzgdi4RlMsfaN5hL0tFWKIQ=;
        b=EvCu6YQhJNkYU65kYpyyOYaNMXQ+/GMxIFNc56r+zg3r9wl8wSHZU7K8IJLxmvI0mj
         uE4yvA3VGtWFy/32QWcJo+yxsN3kFGfP2Ysd0AlORUGGRjnROuQ9YT61NRmTa7coPef2
         kgRu65ZZLenq2HwogQUmMP3kH11xz6xQd2u4f+bnpkfQM2XP8AlTdEtOSu2avakZmOjJ
         Mq/TzZCvY3+fXi/sjsEOB6G7WqgwKzCVnlJNRr3s4bupLWIPZ9JQ0JVeu1+uLXDqyjVY
         G05leNtapQAA3dWoxHHK/Vw6a36EfR+L6PlEFESSUzMvCLPEpB7uH7d8n2eKz00Fbs0p
         tL2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLVGTCjelGtRst2oH59w10OyPTQpUYlLjRR+KPphc0tR2j74Vrg6PJna/kbs9hrYWGlCuyY0a05Q==@kvack.org
X-Gm-Message-State: AOJu0YxGj8iUX1bvPJM87fGWaIN42E4GwMOFlBjqxHl+hAe0rfhwoSDd
	E6oC8Bdxgnn1Fy+RSybyUO4EzajeeuF3xf6e9j2rmNkS1IKeVx76z6cqoufNAMlJVkvVEkbaCtp
	brA==
X-Google-Smtp-Source: AGHT+IErpwOOAC9GArFSNTJou9QXZQdLdsB5GAFT/ziU0NSYCtEA5y7Y+T/bNl3TzMzM/I9IiVHNJedfXw==
X-Received: from wruc15.prod.google.com ([2002:a5d:4f0f:0:b0:42b:2fcc:57d1])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:240b:b0:429:b2ad:f31e
 with SMTP id ffacd0b85a97d-42cb9a3f384mr3224742f8f.35.1763651616390; Thu, 20
 Nov 2025 07:13:36 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:52 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-28-elver@google.com>
Subject: [PATCH v4 27/35] kfence: Enable context analysis
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0527510001B
X-Rspamd-Server: rspam07
X-Stat-Signature: ymeckngpeo498tpwi3cooi7tfbnhnszc
X-Rspam-User: 
X-HE-Tag: 1763651617-47044
X-HE-Meta: U2FsdGVkX1994GfwMGd//cqMQooOpRMsWl/iJOcULfaFxkJu3uDYKHFwWNbmXlUdV0gm4rs8ACB4BpcHL8GD4mUlKHsQVcpCmFB+rNm27pwzdd3mLd7rgFp9m6W8Y5yekYsZRatk3JyYovJWg0YkqxT/tOsCNlSrMx1MdResdfJZCC1WB3TOq1Ea/GBjuRTPg0/MMAQR9WbRrDa8F91UINd8/kVFXZUVFDhxmOhUBSd13puvq6dyyw4NWCEC84TALZbrfLX4O8JVDZR0STOhTe29CWIuVjh4k9qefSFDH4R3BD+t5K91ZdZmxVOxgBm2k+N+nOwBxb8Y2Kz6RoQaIW4w/yoYmP3t0Oz34gndL8qT141SLbe7u0HYoOrBBThYktsUkx6KL3lrtVuebTjEHaAW8ure1zN87BQvyGIB7j+vdUVree8ZCk4NuVJh2pCvgjoBDj1kxAu7P9SjxRtw1ljKvxiPWt4CiR1iDGC5yJ/OCMbnR4rqj7vpBIP+vJ4aqSXQouhdPaSvmSvllrTVhY1lbLC1hZVGAcdnh/wjXLeGKolxzT7uPMmWWrWSuXbJxdD03v9wI+dlnESxAHYpINaBDe0GwNTlPb5hQTI4OFPRTVEcVg5nodOIiz8ROjZGtEc5MogIxZ3YtF/yqaRx3zhB+Cp68trmbrJhB6PtwjopPlBgQhvfDqWbQ/s2tttxapr5yARf4ixCkm9qJ1wR1vCAVZ3EyNQmMtuN4SgY3fT4evM90Pni8RDv5ohons0MQUsihpyOTMQjPWJVAi3PoInYr1p0zgntz1YXZRCQGLGgtOFXlPCOstLj9RLod+8Jort+5tSvMI3Fqzf15mFDvMA97Abth48Y2rd57b444U+nd76F7Yfq+Fw/PoYicc2nsBMkOgB5rbZoZB6xyr04qJeZY1lipjIFs4EBdLa5DvhIKE2RBwDRtZ3C/eguM2Hf4SXVWtPJiCD3FjUwWE+
 Vlczljua
 f4Wi3xbTfVuCW14CqrnGfBUIMXcdM9VV/iLAudctHjNE271lxwxSsLeYLWfYLCG3rUURlbnM4fnf6MdPty0+DpN5eVZg79f46XG7d70zvGIeUeIHRCpKwbtBKxavGn9RDicHOg+gqpirAQITggGecX6TbsZdsacmc3NAabhYnzNiSOuGUEhJZHsiWOurloINRpgzMs9UnJBdymHb0E476a4ZEtbeylBoMLMIQuMjoDEqMxwCxVrM1OUcnhppk4wH44jZ0PqlCDICqh9o1Y16WCFlaLimf0GDHpCK1UVthjMpcIpghO3r92LWHqEVNlXk0UkHSH+yKSu17zfI5iDU0rX6i//3sAsKILVZ3xrHOTNLvQLLXuAvdcu/0R2K5Pb2jAXyEdBD9rGdHsDVwXuBuLuihENhDAxRz9tFV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable context analysis for the KFENCE subsystem.

Notable, kfence_handle_page_fault() required minor restructure, which
also fixed a subtle race; arguably that function is more readable now.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v2:
* Remove disable/enable_context_analysis() around headers.
* Use __context_unsafe() instead of __no_context_analysis.
---
 mm/kfence/Makefile |  2 ++
 mm/kfence/core.c   | 20 +++++++++++++-------
 mm/kfence/kfence.h | 14 ++++++++------
 mm/kfence/report.c |  4 ++--
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/mm/kfence/Makefile b/mm/kfence/Makefile
index 2de2a58d11a1..a503e83e74d9 100644
--- a/mm/kfence/Makefile
+++ b/mm/kfence/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CONTEXT_ANALYSIS := y
+
 obj-y := core.o report.o
 
 CFLAGS_kfence_test.o := -fno-omit-frame-pointer -fno-optimize-sibling-calls
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 727c20c94ac5..9cf1eb9ff140 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -132,8 +132,8 @@ struct kfence_metadata *kfence_metadata __read_mostly;
 static struct kfence_metadata *kfence_metadata_init __read_mostly;
 
 /* Freelist with available objects. */
-static struct list_head kfence_freelist = LIST_HEAD_INIT(kfence_freelist);
-static DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
+DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
+static struct list_head kfence_freelist __guarded_by(&kfence_freelist_lock) = LIST_HEAD_INIT(kfence_freelist);
 
 /*
  * The static key to set up a KFENCE allocation; or if static keys are not used
@@ -253,6 +253,7 @@ static bool kfence_unprotect(unsigned long addr)
 }
 
 static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *meta)
+	__must_hold(&meta->lock)
 {
 	unsigned long offset = (meta - kfence_metadata + 1) * PAGE_SIZE * 2;
 	unsigned long pageaddr = (unsigned long)&__kfence_pool[offset];
@@ -288,6 +289,7 @@ static inline bool kfence_obj_allocated(const struct kfence_metadata *meta)
 static noinline void
 metadata_update_state(struct kfence_metadata *meta, enum kfence_object_state next,
 		      unsigned long *stack_entries, size_t num_stack_entries)
+	__must_hold(&meta->lock)
 {
 	struct kfence_track *track =
 		next == KFENCE_OBJECT_ALLOCATED ? &meta->alloc_track : &meta->free_track;
@@ -485,7 +487,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 	alloc_covered_add(alloc_stack_hash, 1);
 
 	/* Set required slab fields. */
-	slab = virt_to_slab((void *)meta->addr);
+	slab = virt_to_slab(addr);
 	slab->slab_cache = cache;
 	slab->objects = 1;
 
@@ -514,6 +516,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool zombie)
 {
 	struct kcsan_scoped_access assert_page_exclusive;
+	u32 alloc_stack_hash;
 	unsigned long flags;
 	bool init;
 
@@ -546,9 +549,10 @@ static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool z
 	/* Mark the object as freed. */
 	metadata_update_state(meta, KFENCE_OBJECT_FREED, NULL, 0);
 	init = slab_want_init_on_free(meta->cache);
+	alloc_stack_hash = meta->alloc_stack_hash;
 	raw_spin_unlock_irqrestore(&meta->lock, flags);
 
-	alloc_covered_add(meta->alloc_stack_hash, -1);
+	alloc_covered_add(alloc_stack_hash, -1);
 
 	/* Check canary bytes for memory corruption. */
 	check_canary(meta);
@@ -593,6 +597,7 @@ static void rcu_guarded_free(struct rcu_head *h)
  * which partial initialization succeeded.
  */
 static unsigned long kfence_init_pool(void)
+	__context_unsafe(/* constructor */)
 {
 	unsigned long addr, start_pfn;
 	int i;
@@ -1194,6 +1199,7 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 {
 	const int page_index = (addr - (unsigned long)__kfence_pool) / PAGE_SIZE;
 	struct kfence_metadata *to_report = NULL;
+	unsigned long unprotected_page = 0;
 	enum kfence_error_type error_type;
 	unsigned long flags;
 
@@ -1227,9 +1233,8 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 		if (!to_report)
 			goto out;
 
-		raw_spin_lock_irqsave(&to_report->lock, flags);
-		to_report->unprotected_page = addr;
 		error_type = KFENCE_ERROR_OOB;
+		unprotected_page = addr;
 
 		/*
 		 * If the object was freed before we took the look we can still
@@ -1241,7 +1246,6 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 		if (!to_report)
 			goto out;
 
-		raw_spin_lock_irqsave(&to_report->lock, flags);
 		error_type = KFENCE_ERROR_UAF;
 		/*
 		 * We may race with __kfence_alloc(), and it is possible that a
@@ -1253,6 +1257,8 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 
 out:
 	if (to_report) {
+		raw_spin_lock_irqsave(&to_report->lock, flags);
+		to_report->unprotected_page = unprotected_page;
 		kfence_report_error(addr, is_write, regs, to_report, error_type);
 		raw_spin_unlock_irqrestore(&to_report->lock, flags);
 	} else {
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index dfba5ea06b01..f9caea007246 100644
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -34,6 +34,8 @@
 /* Maximum stack depth for reports. */
 #define KFENCE_STACK_DEPTH 64
 
+extern raw_spinlock_t kfence_freelist_lock;
+
 /* KFENCE object states. */
 enum kfence_object_state {
 	KFENCE_OBJECT_UNUSED,		/* Object is unused. */
@@ -53,7 +55,7 @@ struct kfence_track {
 
 /* KFENCE metadata per guarded allocation. */
 struct kfence_metadata {
-	struct list_head list;		/* Freelist node; access under kfence_freelist_lock. */
+	struct list_head list __guarded_by(&kfence_freelist_lock);	/* Freelist node. */
 	struct rcu_head rcu_head;	/* For delayed freeing. */
 
 	/*
@@ -91,13 +93,13 @@ struct kfence_metadata {
 	 * In case of an invalid access, the page that was unprotected; we
 	 * optimistically only store one address.
 	 */
-	unsigned long unprotected_page;
+	unsigned long unprotected_page __guarded_by(&lock);
 
 	/* Allocation and free stack information. */
-	struct kfence_track alloc_track;
-	struct kfence_track free_track;
+	struct kfence_track alloc_track __guarded_by(&lock);
+	struct kfence_track free_track __guarded_by(&lock);
 	/* For updating alloc_covered on frees. */
-	u32 alloc_stack_hash;
+	u32 alloc_stack_hash __guarded_by(&lock);
 #ifdef CONFIG_MEMCG
 	struct slabobj_ext obj_exts;
 #endif
@@ -141,6 +143,6 @@ enum kfence_error_type {
 void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
 			 const struct kfence_metadata *meta, enum kfence_error_type type);
 
-void kfence_print_object(struct seq_file *seq, const struct kfence_metadata *meta);
+void kfence_print_object(struct seq_file *seq, const struct kfence_metadata *meta) __must_hold(&meta->lock);
 
 #endif /* MM_KFENCE_KFENCE_H */
diff --git a/mm/kfence/report.c b/mm/kfence/report.c
index 10e6802a2edf..787e87c26926 100644
--- a/mm/kfence/report.c
+++ b/mm/kfence/report.c
@@ -106,6 +106,7 @@ static int get_stack_skipnr(const unsigned long stack_entries[], int num_entries
 
 static void kfence_print_stack(struct seq_file *seq, const struct kfence_metadata *meta,
 			       bool show_alloc)
+	__must_hold(&meta->lock)
 {
 	const struct kfence_track *track = show_alloc ? &meta->alloc_track : &meta->free_track;
 	u64 ts_sec = track->ts_nsec;
@@ -207,8 +208,6 @@ void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *r
 	if (WARN_ON(type != KFENCE_ERROR_INVALID && !meta))
 		return;
 
-	if (meta)
-		lockdep_assert_held(&meta->lock);
 	/*
 	 * Because we may generate reports in printk-unfriendly parts of the
 	 * kernel, such as scheduler code, the use of printk() could deadlock.
@@ -263,6 +262,7 @@ void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *r
 	stack_trace_print(stack_entries + skipnr, num_stack_entries - skipnr, 0);
 
 	if (meta) {
+		lockdep_assert_held(&meta->lock);
 		pr_err("\n");
 		kfence_print_object(NULL, meta);
 	}
-- 
2.52.0.rc1.455.g30608eb744-goog


