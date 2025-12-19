Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD95D78792
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946066B00CB; Fri, 19 Dec 2025 10:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9226A6B00CD; Fri, 19 Dec 2025 10:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC826B00CE; Fri, 19 Dec 2025 10:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67D606B00CB
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:29 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26C97896F3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:29 +0000 (UTC)
X-FDA: 84236650218.21.B165499
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 27A6C14000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BUVUq+Xc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3jXNFaQUKCNoAHRANCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3jXNFaQUKCNoAHRANCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159247; a=rsa-sha256;
	cv=none;
	b=X6tUxfkQa43EAB0d+Nkd4pOaf1iE2FUhmEbMV4qkI+7xSp3vOENswU5+3G879Af4fy3x7S
	RLmkdFaGykDeqhvpenyErAcJPZc/ib+k/nwevG8n06BByUjxJFrkC+a/gY9SxqI5Zr886s
	wA7+nEXcnIDQ9qfq9ja3ZpIugcQhiPw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BUVUq+Xc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3jXNFaQUKCNoAHRANCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3jXNFaQUKCNoAHRANCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OO33/jJhJQVIdzyn/h7cV8sb9potmD4v/pwOWqkGaBs=;
	b=b+HjFwm0Qs8yF8ERkLklAF2QjEUfF8fpiMedgSDqqZKYmyJV56cEDeAWmY8Wph+VkvEstR
	6x1s/OT3Hlh1cZEoZCI/ln8IKGnEUemzdcKsDUwckTNgh4Nn0fRc2xqvZa8JvkKeNLAipD
	ZZy4MK6XjCc+xjliFPYK8whT2Vlz6kQ=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430fc83f58dso1056052f8f.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159246; x=1766764046; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OO33/jJhJQVIdzyn/h7cV8sb9potmD4v/pwOWqkGaBs=;
        b=BUVUq+XcoWxzGQ2s3kKzctJ/P8NSV+V//6flRWaRkCNf3ooBS1aV1hJgyxOOY/FyH5
         tiqHiKJveXbjf3LndjHJzDnunTa0uWJY9V+wUVCkmcXZLkcKk0/Di5lLprdxMJcwO877
         vwgRyArLouQ2IsdxrtSYeqIPdOnpg/LBZQYHA2yvfmJrdwBYU0eaDjkhCoYLPBtuU73N
         DqK0QMlccKMxqLqOZs0lqgkMJJfOPwTQNSL7cIeCXiikTdXUFitBrJHTjMT3XqG0mBDP
         7HTdQGiS7/Tkchp7hGqA6nxv5Lvo1u77rUVAj4WQad8EAB2um1uhPmjTEQu37hBYcyxO
         QeCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159246; x=1766764046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OO33/jJhJQVIdzyn/h7cV8sb9potmD4v/pwOWqkGaBs=;
        b=osH3DVgTrBTrTc2p8P/LMJbnObnnBhiCJnIoBeTQnLxF2netF1VQTM3yx4iN0EJHPT
         YGsO+jEeHj4lyM/X52BNufIhuDXG8/CWtcn5f+S5KTfKWTBmbBhlOhiMv1XVU4DXbtWr
         lO/8pJeSsEhDKZ0pZLttvfaIbDM5Kr3vYwoQiEkPJHAQNB8ilVzKxu69UzxJ9Ms9ntGX
         LDTQlFVADHEp3PaDqKSDVgwdrSce3v8kXfBLd9995bFJIg1RARfCEyWcDHAotuB/jlTJ
         nKeNSQagtZ7KIk4SckOhtYapsMxIa0cvTH1BpNjhZEnyprl4UShZXFWyFDRRhTM7YWrZ
         I5WQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkC4oh9qtIDXKjU9Q6AFiOqDlJH3YSrJniM4YTSVAO6hRoRg94jSYrWQEM0Z7jTUCC9EUtR3bu+A==@kvack.org
X-Gm-Message-State: AOJu0YwIIa7sQCxeYsrhTEsmBEKxOyapj6hG+WZRkzZXSIxe/S1yfP4Z
	lRLgGkHdBi4AAlK72v6ttCnGo+K7g8beHe/DVSGjjl1C7V8zH1y15UAnrO1YgwCw2MltWOuYQ3Q
	Nuw==
X-Google-Smtp-Source: AGHT+IFerDd1vd4X97dkJpWHrvPSjwQcqOjMG8Z0RXSvdbWhPjy9O9psZiuBXvn9GzAtKPBtfUrWDqrhqg==
X-Received: from wrbbs1.prod.google.com ([2002:a05:6000:701:b0:42b:2aa2:e459])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2303:b0:429:b9bc:e81a
 with SMTP id ffacd0b85a97d-4324e458883mr2916935f8f.0.1766159245502; Fri, 19
 Dec 2025 07:47:25 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:19 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-31-elver@google.com>
Subject: [PATCH v5 30/36] kcsan: Enable context analysis
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 27A6C14000D
X-Stat-Signature: m99bimmhjmafqztpio3cxgncmr8fw3bi
X-Rspam-User: 
X-HE-Tag: 1766159246-44490
X-HE-Meta: U2FsdGVkX18hSPBJ5zdiSlKYV1+AaWg6pIiWmzNDO+/Xx/446gGO5qU3RVzkg1Mk9Ccza9mBOuyeT/GFwbmn/b9Wt4VdY4TfVQHNulPlRdpwrnZC1oiTVT4KCqF3AAFPPJFV5y5hMLzPd6i7qBoucp2XWPEzqXUX+n99sBnwOtlR91dfJiHDqzT4j4sfaOio/mD1imt2oOi9KxnG3DW8NxyLMvC+nYa/KEs+QWIL/Kh+k1q0I5rODLwLIIs3mMreiHoB8FAyYy1yF4SnOOd42NgxDZVDyF3OPOCOVVS6rJCEwNYILdyvdjwCT3CP7SK3m6abS12uM8l6hMJ3YDf3V/VPRcLYI+vCxv+Ufh+SJrL/oOdhk0YymYz+R+ll2fh1MHcn4HL6R2fuoaFHMqfoRiXJev68au3nYW7SXB13jSkLl25/eGchNzewWklzhaIKbgnCz3QZAeNT7gk487arcdLPL1477ZCvQKLdKFsxYYT6wY4a1kKf0vwYTsSgSjnuqugpm5+z1RslueQQymn9A6eIvO6hT+gMKeQTvOuuMOGgtbTI8HA9bAF3SUXpqOOcfm2b1z6OcoX7F3t5Qq6DKjvYyuFdb342pbXp92LUKjF2G/E0Ncob/CSFCvgkGLS4ZHyJm0hk9ggx4uu95z7c0OM11j9j+KFzo+dSrdftu/pJ3hE+RqIx+yim4Fhw/kKqSgeu2rJDrne1bObKKUazlkHrVXwnrgiryP+INkyx9KoL9fZpTMlEgZy2srKhZBhIpkaisl/xw3lWGnM18UjezTHcbGA8fH0KedKyqhAavN5qS1QqYUz0576tKi/owhEuQlTzqawmOVd0paEhUM4HBtrPbENwXttzU5WFsoNay8NLvIMdTXyfK2LtBQuGx1IIJq6IHcX60ptWKuyy+QWERCenmIYGxbUJNG4aYruovmNZGO/o6jzNGZFB7RhrWHdfm5nhzL0PfQ17hGXfKiC
 m3Un++ND
 Kl897RjnjWx1+vL2Kzxx94pe9zf+CCL/TGG2PxqkS1P/vXnfLvs7xJAL6hSjke958BlFkQ79nGVP/CuXoSRb4/LcuAjXm9IeFUKyoQjRMO56T4872wQRiw932ApSi2lCH/co3AqmVuHony01v1VyjjayT5GfvEIgvMEhLIz6C42A34RN4BlthBd6KegufghuKATsNERVmJ9twtSd05bQ/qsqUVj7tTh7nsrm21tqwvj7sUxs0B+Y/zBhlDjY6zPBPHne8cH2ta2EKsTpZm7vFZmZVn54lIRvjQkOzisSuNW10ReDdltMiyaMtKpo5X8UKVHHgQbd23haV0mupG9ER2eLGrCQtwjx/rGrTIVHmeZKc5Zg53OGdDQE4omsXplslhayTQPC6lFic4FIGfpTuh+aTHWeIKUrCAHa/hjOUfUzNREZwB/XMQ7bSlL6Joi93wNCCFiq5qIgUF89Sx+22PDXuqjl2m/2cLngeikMKE4fuFMrxemYUkZBtbbRmJXwq7lafViicHaeBbV1t0iYR16ZMykgvULJMPKcTKJFw4B0BnNaU1bdAvFM3JB9BUO8+9us7B6rAjDUd6BHkwlQoalTDuyFOC5HqPI0v5n4+360s1Oo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable context analysis for the KCSAN subsystem.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v3:
* New patch.
---
 kernel/kcsan/Makefile |  2 ++
 kernel/kcsan/report.c | 11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/kcsan/Makefile b/kernel/kcsan/Makefile
index a45f3dfc8d14..824f30c93252 100644
--- a/kernel/kcsan/Makefile
+++ b/kernel/kcsan/Makefile
@@ -1,4 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
+CONTEXT_ANALYSIS := y
+
 KCSAN_SANITIZE := n
 KCOV_INSTRUMENT := n
 UBSAN_SANITIZE := n
diff --git a/kernel/kcsan/report.c b/kernel/kcsan/report.c
index e95ce7d7a76e..11a48b78f8d1 100644
--- a/kernel/kcsan/report.c
+++ b/kernel/kcsan/report.c
@@ -116,6 +116,7 @@ static DEFINE_RAW_SPINLOCK(report_lock);
  * been reported since (now - KCSAN_REPORT_ONCE_IN_MS).
  */
 static bool rate_limit_report(unsigned long frame1, unsigned long frame2)
+	__must_hold(&report_lock)
 {
 	struct report_time *use_entry = &report_times[0];
 	unsigned long invalid_before;
@@ -366,6 +367,7 @@ static int sym_strcmp(void *addr1, void *addr2)
 
 static void
 print_stack_trace(unsigned long stack_entries[], int num_entries, unsigned long reordered_to)
+	__must_hold(&report_lock)
 {
 	stack_trace_print(stack_entries, num_entries, 0);
 	if (reordered_to)
@@ -373,6 +375,7 @@ print_stack_trace(unsigned long stack_entries[], int num_entries, unsigned long
 }
 
 static void print_verbose_info(struct task_struct *task)
+	__must_hold(&report_lock)
 {
 	if (!task)
 		return;
@@ -389,6 +392,7 @@ static void print_report(enum kcsan_value_change value_change,
 			 const struct access_info *ai,
 			 struct other_info *other_info,
 			 u64 old, u64 new, u64 mask)
+	__must_hold(&report_lock)
 {
 	unsigned long reordered_to = 0;
 	unsigned long stack_entries[NUM_STACK_ENTRIES] = { 0 };
@@ -496,6 +500,7 @@ static void print_report(enum kcsan_value_change value_change,
 }
 
 static void release_report(unsigned long *flags, struct other_info *other_info)
+	__releases(&report_lock)
 {
 	/*
 	 * Use size to denote valid/invalid, since KCSAN entirely ignores
@@ -507,13 +512,11 @@ static void release_report(unsigned long *flags, struct other_info *other_info)
 
 /*
  * Sets @other_info->task and awaits consumption of @other_info.
- *
- * Precondition: report_lock is held.
- * Postcondition: report_lock is held.
  */
 static void set_other_info_task_blocking(unsigned long *flags,
 					 const struct access_info *ai,
 					 struct other_info *other_info)
+	__must_hold(&report_lock)
 {
 	/*
 	 * We may be instrumenting a code-path where current->state is already
@@ -572,6 +575,7 @@ static void set_other_info_task_blocking(unsigned long *flags,
 static void prepare_report_producer(unsigned long *flags,
 				    const struct access_info *ai,
 				    struct other_info *other_info)
+	__must_not_hold(&report_lock)
 {
 	raw_spin_lock_irqsave(&report_lock, *flags);
 
@@ -603,6 +607,7 @@ static void prepare_report_producer(unsigned long *flags,
 static bool prepare_report_consumer(unsigned long *flags,
 				    const struct access_info *ai,
 				    struct other_info *other_info)
+	__cond_acquires(true, &report_lock)
 {
 
 	raw_spin_lock_irqsave(&report_lock, *flags);
-- 
2.52.0.322.g1dd061c0dc-goog


