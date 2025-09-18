Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC1BCAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757088E0138; Thu, 18 Sep 2025 10:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70DBF8E0112; Thu, 18 Sep 2025 10:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF2A8E0138; Thu, 18 Sep 2025 10:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4604B8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 125B6B700A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:44 +0000 (UTC)
X-FDA: 83902546728.04.A084234
Received: from mail-lf1-f73.google.com (mail-lf1-f73.google.com [209.85.167.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 222EFA000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="dP3n7/1m";
	spf=pass (imf25.hostedemail.com: domain of 38BHMaAUKCJEz6GzC19916z.x97638FI-775Gvx5.9C1@flex--elver.bounces.google.com designates 209.85.167.73 as permitted sender) smtp.mailfrom=38BHMaAUKCJEz6GzC19916z.x97638FI-775Gvx5.9C1@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AbpPVjMmuER0ts34LQajNdvnhoooPemuy99n7ga7GVE=;
	b=pwGr726RBSRWEvgep9aAhmDpPqO17ns5xAIL78bcCTCJgTH5T2hguz3eJWn9eQ5K9Q7hJZ
	N/5TTSJw/WJAM23/ekK+WuZLA43HohHgNmmJHoj9tRu2+fHcUL7lN0ltkj5Mnr6LgK8VYv
	uouG+K8mkuN7GSFjqjhd5i2yoAb47Bk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="dP3n7/1m";
	spf=pass (imf25.hostedemail.com: domain of 38BHMaAUKCJEz6GzC19916z.x97638FI-775Gvx5.9C1@flex--elver.bounces.google.com designates 209.85.167.73 as permitted sender) smtp.mailfrom=38BHMaAUKCJEz6GzC19916z.x97638FI-775Gvx5.9C1@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204402; a=rsa-sha256;
	cv=none;
	b=62AsGgMKmgITXHDv2ZF5ukBO5IZbKH+gOVZCTA0nFuilEoTGCHBi82/gX1Xxxyp5cAdJjr
	NoCTEMAFsQa3QBwfG68DWDMErai1+hwUL2SVOqtlrXHh+e04Ul349fSv8eO2AUhmcN4LUx
	IC5xyNpAihyiR5rX/LMewFQebWg9YJc=
Received: by mail-lf1-f73.google.com with SMTP id 2adb3069b0e04-55f70a5c9e3so730122e87.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204400; x=1758809200; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AbpPVjMmuER0ts34LQajNdvnhoooPemuy99n7ga7GVE=;
        b=dP3n7/1mRWTej8yIhMSRPmTTXPiC7xJFPtaaYgdoZWxVaGx/mep4nvDDUhmFIKMt7W
         iIPMvUbaTlvla3VBGUgbWKRG1Be0eZssKjftkWW2hjmCgbyvjpDZuM5TvUt4rZ7wH+jw
         jpNer3/dRtQDn3Aq/QET24+yJNlCZcV5brBusUAMUbAmk3zyo58VRfOzbN2akrZcEp71
         ic4it3xxCOtWRHdNDQ1/3Qyq21XekkzguPURSdpJCH3Xmuwcba6ul7RltNdayXnlNi5D
         NdHzNJmdU9gp8RraXW9xtVhykJ2dx8o3Q9hjFGHBdX9q/aFC/qMvd0xNuTJ0UGVwfQer
         wPFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204400; x=1758809200;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AbpPVjMmuER0ts34LQajNdvnhoooPemuy99n7ga7GVE=;
        b=WQrWxQmrNXQPQihSnyiRPF3wegT9azzJW7aVlla8zBXYMfiLFbW9gAMDKcIudpCODU
         zvS5y2N3P0ET4nxqT5wCJ7ZsST1Av8hL0hL2+mV/GpxjsmbnXba/NEopJf2DVu2v9yMm
         tybbi0HBrmHPd5nqhuV1D3zltSbLoqr4n5WOo3wPah+JiDpOZHpzV5ljQitLAp3kCBeG
         eh5FZimNhNgS2tnsI/bMUYGymmcLQiOLIpdtMXbUL/edV0QbnoQomS1gMAx5iwCrH3Sm
         6sGYIyjm2mrv95vxY3tn/gMYNbk0xqZefZfabrN0RG8f34aoosMik17NEOy8r1tBAjUI
         l0qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzac646GCWFGDSvVsqf7/0/Wr9ZhsytE5iLn0K9nIUvBGQJhRiDNHC8Nhy/OZ3ZWaX896MgGPT2w==@kvack.org
X-Gm-Message-State: AOJu0YzKaxZTPr251Rs304e54vi907WeQgRt6j3xx5M++a4lPqve/UuQ
	f5PKyPfRZJjSVoXrTb5tXa4E/Xhktq1IuCXvhrlrhKJumFxTNLOR8V0faSrI8WKqpOkUJvWhCTK
	DGQ==
X-Google-Smtp-Source: AGHT+IEWYcZtiY85Y5TBe4RKI/DknR4t9xSRYv397N/k2+9V5y5Th2sq2ql+LNq1WKRQLl1+RDCJRaV51A==
X-Received: from lfby21.prod.google.com ([2002:a19:6415:0:b0:577:abf1:7dcc])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6512:4041:b0:579:c485:8704
 with SMTP id 2adb3069b0e04-579c4858934mr81687e87.42.1758204400078; Thu, 18
 Sep 2025 07:06:40 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:38 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-28-elver@google.com>
Subject: [PATCH v3 27/35] kfence: Enable capability analysis
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 222EFA000A
X-Rspamd-Server: rspam05
X-Stat-Signature: yxrd3gkoe3j711qu38cig4odgt4ifn9n
X-Rspam-User: 
X-HE-Tag: 1758204401-241320
X-HE-Meta: U2FsdGVkX18AeUC9WmeNbwFepFakXISHjD9RW+0L3XuiZB0DObNXgoyhqJENf4d1irbxIzRHndhlladKH6Yef8Ib+1tIPnnXa+VA41RZZKQ0tsbSkfCFKhQiGwyCEPqHFT8ld0hiaPZQEk14usrco2myjoRF6QrEegqm6pc/EzZtQY6abflMOidMeqfo/NZvOmUypeGNKRLFiPmXNvwKCFYLPVBf/OIsK4thf6mqj5qc55zAkMzVYL1ONxjNiUoJoncJNyb93p4jFgNpPyKSAVoDTKuyYAWSJkogCCHQPjI2U36G0Blmu3XPtukshvloPfItu6jggLv5Op3ZsnvIGaT9SKx9YAP0zUy75u5P6d+lUFrD/aHDlb/PAW8gX/GgUaC7p5M4D92cWWcS3DYUpuabrI+SrOise76P92KZkS+yNkpCjsNhZK/qT38L0FrRX7G8Jd1UrpmV1nlRljSipa4uMhdUiU+0FCbYcKpsWZXlYMFk+s4lpQmTdLXqHFZ1GIzu4mF+LHmceArxWtndCGzQ5GYm6ixDl5hj9puVE9XqYXSWomISYj9M3QfF9qQRfGGVe95r9BmhKVE79p/aBHNKWYo34bNuabdsuglHf3qVF36OaG3Hs0aAAc41zB1qyqgZKd3fMHZQAY69f9PSlDK2e+TBUwt+rSOCnmBe73sVHar/vb4wZ1o5Weqw+zr0ToXIS3Gb/uqHjdQlbt5FkWOhpGrgafljmQPOm13JhIPkLrScxD03NR7F6vT5O50c7FNpwObil9bZZDJwQS3cwoteog7W47nDY+NQfCSPJwCy2BZl4rpSwLp7fp69GP27bfmEztlEZLQ9eCC4H9B2T7fsJJgW0wghW+sSYZBYibxVdToPUSCZhPW/KACmVUwfsW9CegCmUjNNRaewDaAx12Ql1l444yoErriqI98XX3oVCC6iu+XO+lemuleBncERL14JMiEU8SPyAf7h3B2
 ixFeLnqt
 GQ5RX2v0yAya5fnIIcahjE1J4oapTml/qS0ffuY6HOAY7H3LANS6NFTkAmrKDVQGZ1eAz1OjhzyyQQW/DQq/gJo6ZMQ/Pafaw8S6mMuQmGlSWCS2eFwoeUYRRhskY4FVd3hGRqZ1MypMn72nJ8q4AcHsp5VOr+GUX4RIYc5o36pyMUjPo1bV4fCFMO+2ndMoCiukZivTWyo5zbdQiXsEG0Im6DGgx09nzODLbGaTteq3o78Ac6CnpL8ftUsDt68Eku21yMyIBQU73/vRn8Tmmn8fVK+lT/3779r5otdANLxNIsJr1cJxR5w1dNluhkt08kKS2QYCeC+NuB8TTWSjkU3Qk1F/iYrJ+oCiPBymH+q7IrdKMslHvXvYtcz9apyviVMpVoxEHsBvCT5yhK7Ahl4B3ucj3HMUNVedk5Mu+TMRO61fg73X4E2aineBPF1obtGniJYSvQww3UZV5KuPoeopg1KJxT804m2aRcvxwQ/YlJ8aPFk+L0wIMOPdBpSi7noeDbxx80KdCZT7dgwVXVp7j+MfY/REySYg/C5mPcogkfH9883erGwgrVlO166yLFlZapVjEfNEMVqcRlRBL2/4RfaS75wJia6DUG+qG3p6GGXM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable capability analysis for the KFENCE subsystem.

Notable, kfence_handle_page_fault() required minor restructure, which
also fixed a subtle race; arguably that function is more readable now.

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* Remove disable/enable_capability_analysis() around headers.
* Use __capability_unsafe() instead of __no_capability_analysis.
---
 mm/kfence/Makefile |  2 ++
 mm/kfence/core.c   | 20 +++++++++++++-------
 mm/kfence/kfence.h | 14 ++++++++------
 mm/kfence/report.c |  4 ++--
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/mm/kfence/Makefile b/mm/kfence/Makefile
index 2de2a58d11a1..b3640bdc3c69 100644
--- a/mm/kfence/Makefile
+++ b/mm/kfence/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CAPABILITY_ANALYSIS := y
+
 obj-y := core.o report.o
 
 CFLAGS_kfence_test.o := -fno-omit-frame-pointer -fno-optimize-sibling-calls
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 0ed3be100963..53b81eb5f31a 100644
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
+	__capability_unsafe(/* constructor */)
 {
 	unsigned long addr;
 	struct page *pages;
@@ -1192,6 +1197,7 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 {
 	const int page_index = (addr - (unsigned long)__kfence_pool) / PAGE_SIZE;
 	struct kfence_metadata *to_report = NULL;
+	unsigned long unprotected_page = 0;
 	enum kfence_error_type error_type;
 	unsigned long flags;
 
@@ -1225,9 +1231,8 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 		if (!to_report)
 			goto out;
 
-		raw_spin_lock_irqsave(&to_report->lock, flags);
-		to_report->unprotected_page = addr;
 		error_type = KFENCE_ERROR_OOB;
+		unprotected_page = addr;
 
 		/*
 		 * If the object was freed before we took the look we can still
@@ -1239,7 +1244,6 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 		if (!to_report)
 			goto out;
 
-		raw_spin_lock_irqsave(&to_report->lock, flags);
 		error_type = KFENCE_ERROR_UAF;
 		/*
 		 * We may race with __kfence_alloc(), and it is possible that a
@@ -1251,6 +1255,8 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 
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
2.51.0.384.g4c02a37b29-goog


