Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB0AD78792
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B006C6B00C7; Fri, 19 Dec 2025 10:47:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5716B00C9; Fri, 19 Dec 2025 10:47:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB3A6B00CA; Fri, 19 Dec 2025 10:47:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B45F6B00C7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5736D1311B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:21 +0000 (UTC)
X-FDA: 84236649882.21.2C569EE
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 44F2C1C0016
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DMf7VYXf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3hXNFaQUKCNI29J2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3hXNFaQUKCNI29J2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159239; a=rsa-sha256;
	cv=none;
	b=a0sRQDRvJ1KMefGe7hqMJniPxog+aA3PXKAiwaYITJxdhNcovBzH9JEocVZ7N8bELfyETz
	i2uUWGg3arQdlb4o6O559mzVZFtJG9b2OaQXfMPJfJW/zmO2Lh6axYdao3OsRgVKVU4nTt
	Q80dUqh67ScEXbhR1bFMZ7KfHs/GR1Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DMf7VYXf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3hXNFaQUKCNI29J2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3hXNFaQUKCNI29J2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=in59w/Ham4YrnosvYw1tGLvejZ0fwtDhCl3ORoOSt58=;
	b=vD5B9VN/E9+KBg71GoRdHQFmEzHS+3AhhmW/crhg+Gpl/yO3ssUr78F/58U0gLnCsGwbgP
	hD9FdFgsCsrwVrKYOcIwOjgVT0FxFaotavXZQOwNCpR87GH8y3XDqbEGUWxEJRhPejev2K
	OQe3op/W9BA5WYgXxRGoeshvNMU5XJ8=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477a11d9e67so9462665e9.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159238; x=1766764038; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=in59w/Ham4YrnosvYw1tGLvejZ0fwtDhCl3ORoOSt58=;
        b=DMf7VYXf1yOYCTnW9VRaVORW0wuFYk505ik9+czn2CnJGuQ92l45wGxMKwTIsek75q
         rI5pRRKji9lE4F8OmtX2RFQ+a+dQj9HiuHn+eBoR/Y66k5I53GQdr4AVDYgA5oqBetCt
         ZL4bn0x/l13thjm1Lw+oj7S6TRcCDVt8T5zYK9x4crdjSiZbBsm8Aa4MOOd2sgA1F1r7
         eYePn0sZEf9Vgvp9JJ4FJV6ggsv6veXtKDBc8o+D+JNvFVIB/XBl/IrG3gmpaFbKQlv/
         dr5FnNDUiK/Y1i90OcbqPlKzeFumpWfRrJSwQ9AB1ZGZpDD+5YlUAjiZ0VJmdCpwKSfv
         34SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159238; x=1766764038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=in59w/Ham4YrnosvYw1tGLvejZ0fwtDhCl3ORoOSt58=;
        b=BynM7oI7e39hG9kVNiFc6LgXIi0mJoXI0OhOa2UoGwmPkTV3ldL316wzqOoOOrb0LZ
         XdP12fpdLhQEvoJhPZCWLHLHl6FS6otIqAtJxURz6CMAaeI5GKPDkP3nS0txGjhIlaWa
         Sjz4+LVoBJZIM9WRtZ5Vn/h6v29DqBG82YAGTvLszpaw85sFPD2+rq7c/WgYsNNoing6
         +io6n4o20pu/efmHxoM1/KTGPNUfuHSel+EJlymaSF1dx+3+CsxPcVd3xjgH/doRwGdC
         QrnK1zd2WLtyWqWroB2/W+vB5TsS3BSbraXVhNw9F02J3d6OpgEL7913FJZBpMK42Eqe
         aDMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLhu6ECNRyBpOAk8bChCUlfdZF+KoWZWglfWy2IOuwy2oz/JEfyiVbMGu8FvF13lrNZ7BK86qfzw==@kvack.org
X-Gm-Message-State: AOJu0YzFVA96uMkgdD/NkTzDUgHlFbg0DAnKJRTAbvx9aweEcM4rP2tL
	7CnXsOQTpKdtufvy1TukqW7IpBDEOrlFZbTvtAZ7Zgerk8X/Lr1ZHmXmWSi/KK4ICUr0oU2xqAP
	CBA==
X-Google-Smtp-Source: AGHT+IF1j74KEIoGqO8PaQ6QoYF3GZBjGmyEFxYxzCmJ1EHTx1dn4Dy0FqX7qP0sJNQ6OGOk0N3i/DE0JA==
X-Received: from wmsm16.prod.google.com ([2002:a05:600c:3b10:b0:479:3624:3472])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e8e:b0:477:b0b8:4dd0
 with SMTP id 5b1f17b1804b1-47d1957b120mr31632645e9.17.1766159237625; Fri, 19
 Dec 2025 07:47:17 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:17 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-29-elver@google.com>
Subject: [PATCH v5 28/36] kfence: Enable context analysis
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
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 44F2C1C0016
X-Stat-Signature: med8waq7r634pe9pbyg3abfkajti3xxf
X-HE-Tag: 1766159239-164835
X-HE-Meta: U2FsdGVkX1+Xabn/lAOLmOJ6lr4a7AE/oX+sS+K+FsYtN3sDEsWZUYPHIkyMfjFvcUEw9nVA4a11jrK1eTRgg7+YsP0Cb1fm3Hguv479KIvLv2nkCfazbRVL56WuWuSFRAp+8d7te+fWqcft0CuoJKAzMu4G9qXjzkWUWTS8Ch6C5hbRTtuZLLQFBr/2QDjf0V9AQiUkzuWY+7fQ7SE+lNWIRAQeGDD3G4ndqo3zYzYT3QusOELx9w1uhPC/eSIVNWPo7/XnAqibj+1W+1OmU31ibn/L1OyCDo551mp5zpCHQxzliuTa4fiBcArUcpkrPf9+vImESHhKV5JuchuCYWe89g2f3kulaNh+gR9BklQ2ZPqI8cMlqvq6Z6K2lT5wK8RZJ+d1edi1Bes6Elws7ePIchUKY4e681x9Dchhf47dPb4qn6tJQtqkruPV1VjZTConQIfuOJT3Q582BxHfHkhkCP+VXcRH6LxVjuLNuzU2VA5e2VXr/BJkrg+ZyZbr4lBMbBiXX1S80vjZc1RRyHnCbAYEFEyhRdF64xmwtrfxs8zfJ/CUu1JRVdrWaYMSEcJpwDL8DpNexPPTdxhMkJyBpJ/utLjxJT8WQbwu0OPGuwaktdLhyDHqqMNwuh+N+x4wUXzf5kQQrALihINgKmOQeJK02i/iB8yLB9RXLiFbQwx3eshyGGcf7lys+GnE/bMkEGOZp+M+AaP2CqmG7izMPEgcMOefb7hF0xRB9ExpvC3u/URZO8sjBRsTx6lcfdk2/9fW0WcJc93znpFTq7Jk9Hw0d5veBeNO2IId6vnELFkBtLZZz6BYUPmdmkm996BXEuX9aReDG7BXQQnropE9xWDsFvImpZ3TOGj04EPPFPDG9o0mR+34F97Ng07IqAbJ16bgnoPfnn2ta5eBxJVQvdygbW/2VEA71mzOqFSotTFkhGJcSggVr9zZ7b4JVy1UCb8elv0CG6kHf45
 LXNaJL1L
 k9RWOt1EoFenqnceoCqV9F9vmbTLMxDsHgyQzxpd93e50MMpBTcxUYq+2l4Gar5udfM53bGme/Swo//8T2sqdijI1KcTp0h/93UT2DyfxRyXMOFYn+ANALpfYZgY6JbqPwZTK0UaTEYwhnhmMbmDSZtLzTyQAdYx0OU9/7/npOsgq3RqNjXxiqYV+2YO4E+Om3BSoX5yndfT4orAd3sQCcWCJkABZk8eBu28gdAjzQCEdmbe0zeE6q7pdwM/t2WjyjpDDjibXT44LPNUpEL1ylBZefk9QDLEKAKTe/HF7q8zWWMqNCKBrxux1ONlSpeCExcDL5EW1HEz2iyeLKYP5tvdcs2xQ9Q+lt8aasuwN9EGzzJL4Tm9+Gq0XfMCWMNDNrwzAK3v0DtG/eggLN8BjZHvx9xNGAmiNkBctcKkDgvFq+XDiueidDlzjVsnaiaZe/Beo6LmEK3JiJBkptVK91DrrImOFNjW+WL9tN+5KdE68KtTstPftcA0vD9e0u6O+8bazB1nKcELOpQunqxClRqBX9fbqw4s8erhV6jVsI0ug+AWgjPnLrMy07uOD+50SSkQ8bVrTWjTYEsSfj3hFBdN8nMHTg0oVOrReRhy3v7xEulMqXQX7684Fb7zAScAuWPW+0ufaajSZb62wAUX9TMPHT8HSqx6ZBydULRKiqi6M1sgmux3iVjbaAa4u7djX7Ahf
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
index 577a1699c553..ebf442fb2c2b 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -133,8 +133,8 @@ struct kfence_metadata *kfence_metadata __read_mostly;
 static struct kfence_metadata *kfence_metadata_init __read_mostly;
 
 /* Freelist with available objects. */
-static struct list_head kfence_freelist = LIST_HEAD_INIT(kfence_freelist);
-static DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
+DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
+static struct list_head kfence_freelist __guarded_by(&kfence_freelist_lock) = LIST_HEAD_INIT(kfence_freelist);
 
 /*
  * The static key to set up a KFENCE allocation; or if static keys are not used
@@ -254,6 +254,7 @@ static bool kfence_unprotect(unsigned long addr)
 }
 
 static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *meta)
+	__must_hold(&meta->lock)
 {
 	unsigned long offset = (meta - kfence_metadata + 1) * PAGE_SIZE * 2;
 	unsigned long pageaddr = (unsigned long)&__kfence_pool[offset];
@@ -289,6 +290,7 @@ static inline bool kfence_obj_allocated(const struct kfence_metadata *meta)
 static noinline void
 metadata_update_state(struct kfence_metadata *meta, enum kfence_object_state next,
 		      unsigned long *stack_entries, size_t num_stack_entries)
+	__must_hold(&meta->lock)
 {
 	struct kfence_track *track =
 		next == KFENCE_OBJECT_ALLOCATED ? &meta->alloc_track : &meta->free_track;
@@ -486,7 +488,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 	alloc_covered_add(alloc_stack_hash, 1);
 
 	/* Set required slab fields. */
-	slab = virt_to_slab((void *)meta->addr);
+	slab = virt_to_slab(addr);
 	slab->slab_cache = cache;
 	slab->objects = 1;
 
@@ -515,6 +517,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool zombie)
 {
 	struct kcsan_scoped_access assert_page_exclusive;
+	u32 alloc_stack_hash;
 	unsigned long flags;
 	bool init;
 
@@ -547,9 +550,10 @@ static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool z
 	/* Mark the object as freed. */
 	metadata_update_state(meta, KFENCE_OBJECT_FREED, NULL, 0);
 	init = slab_want_init_on_free(meta->cache);
+	alloc_stack_hash = meta->alloc_stack_hash;
 	raw_spin_unlock_irqrestore(&meta->lock, flags);
 
-	alloc_covered_add(meta->alloc_stack_hash, -1);
+	alloc_covered_add(alloc_stack_hash, -1);
 
 	/* Check canary bytes for memory corruption. */
 	check_canary(meta);
@@ -594,6 +598,7 @@ static void rcu_guarded_free(struct rcu_head *h)
  * which partial initialization succeeded.
  */
 static unsigned long kfence_init_pool(void)
+	__context_unsafe(/* constructor */)
 {
 	unsigned long addr, start_pfn;
 	int i;
@@ -1220,6 +1225,7 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 {
 	const int page_index = (addr - (unsigned long)__kfence_pool) / PAGE_SIZE;
 	struct kfence_metadata *to_report = NULL;
+	unsigned long unprotected_page = 0;
 	enum kfence_error_type error_type;
 	unsigned long flags;
 
@@ -1253,9 +1259,8 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 		if (!to_report)
 			goto out;
 
-		raw_spin_lock_irqsave(&to_report->lock, flags);
-		to_report->unprotected_page = addr;
 		error_type = KFENCE_ERROR_OOB;
+		unprotected_page = addr;
 
 		/*
 		 * If the object was freed before we took the look we can still
@@ -1267,7 +1272,6 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 		if (!to_report)
 			goto out;
 
-		raw_spin_lock_irqsave(&to_report->lock, flags);
 		error_type = KFENCE_ERROR_UAF;
 		/*
 		 * We may race with __kfence_alloc(), and it is possible that a
@@ -1279,6 +1283,8 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 
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
2.52.0.322.g1dd061c0dc-goog


