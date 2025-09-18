Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43AD6CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA038E0112; Thu, 18 Sep 2025 10:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272ED8E013A; Thu, 18 Sep 2025 10:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169138E0112; Thu, 18 Sep 2025 10:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 016308E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7694139C3D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:48 +0000 (UTC)
X-FDA: 83902546896.06.30D7325
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id CA93D14000E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pbrsfqPt;
	spf=pass (imf23.hostedemail.com: domain of 39RHMaAUKCJY4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=39RHMaAUKCJY4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAfkPofnq3bpowTJFISAR394BQXpDstNh3Kk+W2FONk=;
	b=YXfg7d3ozA7LqMuM3OLDs83MVmhE6FrTPTqlkXaIGp7HPx0UKO1F8mRKrmu+Ma99aWRsea
	xR5tR/lOYp2IBGUwsWKcrZkddqxZQBSFOxzZFUfGM6vg7MSke62+WDmZAaKDdYEWc8B29g
	PSpbbMmR8QLMV9/4TfYzvDtTsu0ynS4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pbrsfqPt;
	spf=pass (imf23.hostedemail.com: domain of 39RHMaAUKCJY4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=39RHMaAUKCJY4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204406; a=rsa-sha256;
	cv=none;
	b=0vgv7clK+wldQPTfBj/VIPnRMQyl0QtHphmU1558oq0j25gaaGJ5yGc4DXP4TV+Hxc7wDK
	wvar4kpegzoNDe7INwhGdaNEGLwB4yUDCo7cGmvbD4yPjHWLfNY/mF+/LRJ2GgoZCL5Y6V
	Jx6e2tsKTT44sDDhJYkEGy3uQkU3Hbw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45f2b0eba08so6023995e9.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204405; x=1758809205; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bAfkPofnq3bpowTJFISAR394BQXpDstNh3Kk+W2FONk=;
        b=pbrsfqPt1a2P7IjELbLC0Du6a97laKnNuxeVprJ1A9w9c4OMB51wjZOPnRhbK62D6y
         31dWyg3zJLhe2f3p+0O/9M5bFaf+QV5Tl8ar/zybkIWxS88OW+L3U9Zfvn0Dbzn5VhUR
         znVQhm4m7jxDoPPj73XfP9Rbub/avbXFAGBZcRi+VDg9V4fh9hftp5HfPfi//1lQ7Esd
         55yh6iS9cVYa47FTjGxQWfj28m3WpBiGyrjIyPHOTT2moprGtfLEaGLTbWDWUDaiFBwH
         gLVbyy+UVJ9TghIccD9VT6iVm2XIgt8XZ3F84COoPhTPsw9WmK84hNphksLSHE8DTe/g
         20NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204405; x=1758809205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bAfkPofnq3bpowTJFISAR394BQXpDstNh3Kk+W2FONk=;
        b=MLV+GLyXccjQhoX1+/hsZOdardcR+ZmBxikyGhHlUz4wsnvgguwEZg4v7yFzpMJZAP
         meutxphuzaR+dIvHhe4m7uRN+vrjsn49f99VYfa26ETzEiG6jAbrLxCj3tiDIvZ9SCJO
         RNUgJWrL+Ps0Fi2+2DRRvhK8RUyf7/sl6mJiKsPAFG74XcuS69TExa/Xc5ghTEQn2sIa
         9KJofNmmkEO2q4a3GXbAM4O8i7kI/h/0mTIhH8CWYH8kX45EA7tuYDEulGxyJaxYOtZO
         zZJGEG0Bd2M38SvS+1J8ifdpGF30tEOPGLCDvGnlaNqPNvz/9kRfljf8BRDf7ZcF7xrq
         Awog==
X-Forwarded-Encrypted: i=1; AJvYcCWb8R7L9Ib6YmbEF9AoXrirJtdZOQ5b70VdoewW3j/sl8k+Agweg6sgGyTxGXwwBJdxVEhIhtuMQg==@kvack.org
X-Gm-Message-State: AOJu0YzIW0oRXO5VE7d61/YQYQsSAnFVmES4WnUQ6EV2QKaVRfMQmEvt
	G5l1epUtz5N3qgSU0Ci/bJIg0U3rzU1Z6FjcaZY2nxqpCmQVHH27kcM64LEyRiwjAgJzZLz3Y+D
	PCQ==
X-Google-Smtp-Source: AGHT+IHCd+6pMztfopQyMqTVF5ILMdjFqjMumE3Akb/gsh5QUO16zCcVDRf5E/33xR5ffjMWNycUEXU4ag==
X-Received: from wmbfp9.prod.google.com ([2002:a05:600c:6989:b0:45f:27a7:738d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ed1:b0:45d:dae8:b137
 with SMTP id 5b1f17b1804b1-46205cc86damr55535755e9.22.1758204405297; Thu, 18
 Sep 2025 07:06:45 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:40 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-30-elver@google.com>
Subject: [PATCH v3 29/35] kcsan: Enable capability analysis
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
X-Rspamd-Queue-Id: CA93D14000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7q3i3mzgxsw3wjtjhaakfiyu8bw1xopy
X-HE-Tag: 1758204406-392932
X-HE-Meta: U2FsdGVkX1+vfG+oULGwoQUNeTPG83PAZKlH1/SZ07xs9wf1RbEi4/v417IBjhJddebxtfuq3N/T+uIvMM64r10vXcebEzmwSmCYEXXhC/H4pcxIfRCpbIRXbqLCPIHXS7yJXj2LHkiGsPScwsO9TTEBUFaBIofejc1TZeOnwx7jHycY5wIFJ3yb1deX1Y63MIctC/+9A5CHco0mbIZyM0cry/Yj/hU2eX7bRJhSICjViYNUfrBVAHYzIlVzBBZlF1KhyC5awPy+EMXCtvnCIxZF3oHpi4iNkTxeh34JJNv78UpafQmoPbPRgYNLb4JZ7TchoGCzQIJVAQC+yCPIJyugGUNIBTCllvxA1HBiGMWl+76nyIjzlIWaGPtq22pkq4KtzXl4GViDygJJK9vN9ytXusN+CIxXLsCe4pPs1y2IbRvUGj4j/PRWnmA0kny+N+U3efvOIF/0HDT/8c955YraoYRlEBmRvI/geN7DkXh1QimDCBWjf4baikxwoYqi0vpeWJTCEYQxaxco6F9MfgKLvI6YyblqZQMLS9gyy87OfR8gO5zpcvEKga9X/wIQLkOE6tfOegwXxADU7nPOq+nHL7RtGAF/CgY6UCEc+gk7BF9L+F2YZeY/tEII7NQkC7C17lkELTy7Pk2b8ReJWjgzTepudIExoHsKpyKs7WFEvgFxVkLsAuiCaITY42R8K0bgTb/0UrwRY2E/V5sWjaad+zMYvVBGmfmJDej54W8YTZ19LtpWyvsDqkik9/osSPFJ1UgAhI7oCxY5Kj29Y0Jz/mo8mClkuRBR4zxfZknh8EKGnP1KokVpMXOWsEZBO21hMxw3aW/8Sw7n4Om3oFOLS7rKYd9uRsEKYdDhUEnvJkWCfFEmZl5cNGa91m4LLpg6+zNw3/fthsBsrxDUsazQJ+wQRcJ0vF5IJGfQIwI7MII5w1C2mDHuTA91pMsVxigkdDEBESOYlZReqXV
 j1T0vnjm
 oii8lc0eGmkoSFxejx+IBnzY1AJF1cTZVqMueupQCxWWZgq3e5YjkQrcx3ObVAEjebeS1SOPV8u6deyqjRhamOJVKgQ+gSzwsuybbQJx1X6JCBnf1U+JLdqUT/PUtLat1pfYEWHG9bqb3DvJHz1BrM4F4ALEuwg/1kaRYNI9m2pzdhFS86POd2gtvLtcj404k21V5qPIPbZgwT1auVtFOnRu6KG+RrOE73u6zen9lR6w3U+30HhtwIozwfFJxWEktHiWPK9T0Iq+Y1tA/jF3dYFv9dBuDuTgKgeHWHW8ckHJVZSTlTEuR+PO33AZPRfbDnpalvU5NyO3VQixXhG0n/GaGemYIbA76abqcwQllBFcd54cj0TI6T0sX0PbsnG6jGPE+W5htKmnFdBcae36BfNhydMn1O80JIQHFUqjKPI0uACD+GQd+bMTCZaAZrjUz09NmueI6bUrTxCtxect0C82g9FvIJ/SQetns/XMrzdoZam573e2/mWm1H3pnFVR8jfzHOAhTPIrZt4UWtTeWVV3DhmDfgmcbeSeADZTmJN7Yg6CjDryLtYRedh8Mo39tb3Tr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable capability analysis for the KCSAN subsystem.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* New patch.
---
 kernel/kcsan/Makefile |  2 ++
 kernel/kcsan/report.c | 11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/kcsan/Makefile b/kernel/kcsan/Makefile
index a45f3dfc8d14..b088aa01409f 100644
--- a/kernel/kcsan/Makefile
+++ b/kernel/kcsan/Makefile
@@ -1,4 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
+CAPABILITY_ANALYSIS := y
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
2.51.0.384.g4c02a37b29-goog


