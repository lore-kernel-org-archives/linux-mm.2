Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE4ACF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89CFE6B00D2; Thu, 20 Nov 2025 10:13:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870E66B00D4; Thu, 20 Nov 2025 10:13:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7872F6B00D5; Thu, 20 Nov 2025 10:13:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6449D6B00D2
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 300491A0165
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:47 +0000 (UTC)
X-FDA: 84131330094.07.E241A28
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 67F8B180016
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ih4TD+tE;
	spf=pass (imf16.hostedemail.com: domain of 3JzAfaQUKCFQ07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3JzAfaQUKCFQ07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9dnEf98rT3yxtmvLOfZj9VjyyDpDqGX8DLsl5ZbgJ0=;
	b=DB3f3rHyuBAlGoOJai6mSpmqNQqnqDZLbQqFWv+f0c5J3BuCVmlRgbr3KaK4euvjRUCTnZ
	Rawsndv6nYKoHttq5id/4/K+bp/7GvUXCoqycQkOJJr6+3eWwPvw6rHVjSoCMlYNLOMf5I
	uWwDWV/06rHbWFpLEEUZgEnbWHCGHaM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ih4TD+tE;
	spf=pass (imf16.hostedemail.com: domain of 3JzAfaQUKCFQ07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3JzAfaQUKCFQ07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651625; a=rsa-sha256;
	cv=none;
	b=GtGgBXgn33mAS/q6LEkYsLqj0AmdZUpGEQnEK1YKllK9jxy/65AqUI5lra7CLJzHIiuhcq
	Vqks5qcrtL5weMb0Ss9G0G/2fLPjRbic7WonPlAh+4ctcKV8YD9nVLONh9z/CGhzwKNOl/
	qU42cJuzGAhmDGuIVESRPS5kM2mz3eQ=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4775d8428e8so7790285e9.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651624; x=1764256424; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P9dnEf98rT3yxtmvLOfZj9VjyyDpDqGX8DLsl5ZbgJ0=;
        b=Ih4TD+tEeA2y1zMwy6hTvV9hKOg80/YoHOLrCfvRDSe1YRd8cN7osWH1/xiJzW7Dpf
         h1jQtT/UMePchBc3OJW1jqir+0x31YIhClAihygLjTD40Vi8kxRBgcnmWES7WK+bl3mE
         mFzyj9Yo23vIxyRx/SrCeZB/QoreQJS0908sCJT5LUZgOijZ75OhzOKRK0aiAcj2wlF6
         fDAKgXT3nu0tS3gQOh1M4FxeIpQbE3iw72k6gaw+potx651L64/imrSTqIYiTleKAj/s
         Yjs2FeFnREERkc44YQ2T+M6Lnlug/t30h5hHPq0EHg69/3z9D7hbfrd0g1le0D6sSQBK
         jVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651624; x=1764256424;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P9dnEf98rT3yxtmvLOfZj9VjyyDpDqGX8DLsl5ZbgJ0=;
        b=b36LKZpQmFseCP+v5GW9lhgwe0MV22js9ILmE/CvMO/q12KXbrn+fhweErLZ7saPLr
         4jypUyq0SkbBcacdH2sEp5usPgHX4XaCXevk7gfFkytVWB9FVPERyhxOOGW5AXQByR3l
         zNGyEM791ahxZAnulApI4VPRJbkiyMoE08LeALVYESoIg8uWgxaxS5kyqXC1pK9wLzNu
         6VVTkXU3rZlFFU/DwGabGF1ICe6wGwZ/dgcDOEiWNeN5P6iLNNQQ8J1ZO7mGxZ7PiqUg
         5/For/VN+l2oWR/iQ6OauN4etXvUTbmCBCwyYqA9qCbpkn1vul5kR/XPNVdol/XOO/aR
         17xA==
X-Forwarded-Encrypted: i=1; AJvYcCW9rwXw8j1DWeMIzQ++T1zfcLDD+MLSW0NyKv6nSJsbSznpXbHhSnWhy4gj09pbhHI2Ww5AL/xXRg==@kvack.org
X-Gm-Message-State: AOJu0YzZF12HvfObSrKmQgF9pg6KQ0Z1hVp+bLOxzEd8p4whFVMu5EVD
	sMgKCWBkrORNWOd/VPr8+LrA7tdYFUszxkC9IqquySMky0aZnqEudWzs7Ub1dgG7BqTv7hDHQws
	qcQ==
X-Google-Smtp-Source: AGHT+IFzrSwtwY7miOmNK7LYeHpXeHuMSiPUb/wnjFTBiV4tGaze/1FaluK98MtjxDYipw+SZftzMsNxWw==
X-Received: from wmpq6.prod.google.com ([2002:a05:600c:3306:b0:477:9976:8214])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:b95:b0:471:21:554a
 with SMTP id 5b1f17b1804b1-477b9dd716fmr25371575e9.13.1763651623805; Thu, 20
 Nov 2025 07:13:43 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:54 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-30-elver@google.com>
Subject: [PATCH v4 29/35] kcsan: Enable context analysis
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
X-Rspamd-Queue-Id: 67F8B180016
X-Stat-Signature: tx9s88us1pfx6n4im4u5jppa59rgo9bn
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763651625-526384
X-HE-Meta: U2FsdGVkX1+C04lJwcumoEyUxYm/P568A6NVzDeyZDbyrBmM+TqXswL2ajoubvDK7vqUMLdzPZxy7D0pArTBULEXs979pcOz60oesqMPV7lcYMuZ2TT8MlKAvuJV/nJePkeJv4XfFV6Y05MK6BffGPdNiWqNfVWX3Z909Ao5HqqwYrsoEaL/inorNRlRE9Ts06EvFIS49F91xmDxQC5GVlTRvK266PAHEGubQDndU8IpEgsy93O18iChk/RFE3Ep9BhJRPG52ZBnyhXtYFRdQIPT/EFgq67jwtxupalOujrfYvdD0FbVekARxir9l8YNmBfPKY+cnzOCff2Xu+wFTYsvnubNjvU6yahsy26GT31VqC7Yo8YotEo1CKAst7w6HrUHl1nJC3eQ81mRbS4ImiQd4oBnpDa8IsODwm0PymfsjyUE6uUNrWKIP2lePEpT8UcJ9PBGzU8rAEfmRlMZi458eEs0iXd2GmQjTn+xeyEPNDeJgeTuoX8CpSZNYkdXBgYAt4d4sgn18FLRQ1w5D3n0ZKYf3ZdVuDcprILBX2q85UF2Wor+pidTHEssJ5AaaGj9MHsg4qDNIDFLdhNMfFVdZSwLUIwJKJfGioZw0KnmOWcVA4QZcKOzMepd24UpGAcy6lsDPOL3IMPnC262OYcTAmnUofivKYs1pO/AQh9sECMqZBEYurtUc+6qvC3oDmqnzFFeRD7u3xZqXTmnC/a1AcdboA4tIUWGJQPdV1RKtbvTntSuaX2z8vho0EudA3OjMS/2WHpaCquKf2VTPGpOj5+mVJ/r9d6KeCxpZvT9e7sG5WFJCAN9PX31Fs/mg+mYUXqDxOw0MkNZQAFCUlsXDCY7WwyunQClZjHgRqwJtZU5lJXUPJ/IyTHRsx8ZgWBHbPWa+qcZjF2yeAewLNQAf2DjV4qZWeCXtRAVgoHRUXr2gMyHZfzLan5IYWqivFUW1fVpDqdMEqFKyE2
 JR3O5jKk
 kMBwBNuEJBfyepbSUuIYk+z7bzwuCfMf/2iCofh3veoI+luRNhPUkx+eUQRMvNZTJE2UE3XTd4Ubiu04q/WABjk1p9RrYd8YmEahmQwy2k9PgbU025edP7FthD1mAnEXg9RwE8sYSsE7MiYAOtt0tyLNdKboNEZ4DxGbKHh3IwtbaMZnw5ji76hL0bnoev2pep+StDcNlVBC/OUJGmzC4Tsn2KKNsG+oUq46OAhqTK+IuW10p3qxUcV4l3Cl1mRhZoZbsYY+jLC2MrJPj5JmuQHoHsUxGYg77/ESK9RZS9enwLjB0UkGf4eLALVSz3IJNNgNSNwveMbNURbiNURceJAZ1OGjpnuSdgpClkRDCFQ6olR2RXZW9VV6LvQ==
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
2.52.0.rc1.455.g30608eb744-goog


