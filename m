Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885BCCF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DECF06B00A3; Thu, 20 Nov 2025 10:12:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2CA6B00AF; Thu, 20 Nov 2025 10:12:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8BEE6B00B1; Thu, 20 Nov 2025 10:12:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2E9B6B00A3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:12:31 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E86CB680E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:31 +0000 (UTC)
X-FDA: 84131326902.06.2BB2789
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 93FB140016
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="iJJD/C8c";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 32y8faQUKCAgmt3mzowwotm.kwutqv25-uus3iks.wzo@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=32y8faQUKCAgmt3mzowwotm.kwutqv25-uus3iks.wzo@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651549; a=rsa-sha256;
	cv=none;
	b=zO1WOVZ3jkoaBPRsLyryyYNGEWw6Koaj+pSNwW/9H1KUYCmKeWzPdRAG4cL58J7dce7icq
	6059EOUA46PWuaOakQze4VoT3O4lYjIXNqFVDySUhdP91hLRAK4JjqoB3wPxkvKQbjboEP
	qfWhEzCZkpphyKr5YL7PQJldG8ahBZ8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="iJJD/C8c";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 32y8faQUKCAgmt3mzowwotm.kwutqv25-uus3iks.wzo@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=32y8faQUKCAgmt3mzowwotm.kwutqv25-uus3iks.wzo@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMqqhFVNLAUw4V1kneJBauR05JGQwrZoFZiIsH/esVM=;
	b=OqHQflfN3lStZq27C4sSaVmQQl/JpMqGoj8aPBlCJS4LBnGUWoS7hJf9VaNe3SaTiJu7Zr
	cKIxj9Zd09s3yu4tn+8HlyAZyoH6EFGPPVEAWSbqJelJXAq9tH/iejJLFO7QtWOFwaq4vG
	itIMMCMfAcLv8IPEz5qV1CrdGXtXuY8=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47799717212so7858815e9.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651548; x=1764256348; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IMqqhFVNLAUw4V1kneJBauR05JGQwrZoFZiIsH/esVM=;
        b=iJJD/C8cTzwSmCfsCgq1QVqQYHvywS6jrI8+Bx+hJcoT7x4Oh0tJg2B1scrMZGao5e
         E/zzJMV6awb94W389PJ8llZyCmH6lB62LzfK5q3c7bwahWRYATSam3dk9VonvQmo7RBK
         Zl6QfsGXWjcIf81KJDPZa+vb9yAIgCMLNjmH3HI+yCbqTM+6K/5nX+etkeFW1AIxtzdV
         qs440axXbbXNxZirjFThABRnxWalT955AN4/AhpSxLLTFgTvQKlCmik+LND+VMukH2Ah
         RrlqV05YNSmcGXsrIOxdAhf+s1XIxCU4xLmG3Dj2rXtL98g28p7cWS/pAqwSW9gmIOSY
         XlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651548; x=1764256348;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMqqhFVNLAUw4V1kneJBauR05JGQwrZoFZiIsH/esVM=;
        b=lrSmdNXJhzx/ahx2YYXylD0YQ8bigN9ExBQWISl6Got1VSZatU3W98Xy72gWnxdt8p
         o5r3kRkKNXkV2FJotD0UwBlj1nU5ifykKJRV6SBIUHqhGKJ6VE8doqlRa+i2Xs1SKEuW
         acXRvCdyRYpwD+YZzkG5h0ShDfpAN91oeM5BGiAOp1afnQTOREMEIOEO702jFHN0FIRl
         Rh5fHvRup/P1DEVUkhZD2wHD6/Sewo4lfonF9sJ3rFvob5mbTEU9KWEQOaTy98VsZnbr
         LKxbYvtpcYMJfiqkT3XTGBM06PcfCdY0KafWRT82YSLwbpZoI70mHAujg9vZPN8zXLDH
         xi6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUG+wPBz9Lp6FhUOxlWxWg3Xco4BCdhXGbg4NN0jh7SWiY/vUp7GMtx/wD29+4jguCtZrtjJ5D1WQ==@kvack.org
X-Gm-Message-State: AOJu0Ywd2erz0QXyTgveySNf6w+kjTqLXtetSlNlCHAXepm3UeHULAwA
	SxyxCXyN9mbrXJ3WZ26bKCuLwDJXoQMynIJr+dWYfhAA5QEAYP5Sr6QQjsrQXqsXpUBN5GG0mQC
	8zg==
X-Google-Smtp-Source: AGHT+IF2zd2nCypWW3xVuzIPJvJqZO4w5aeyOpnB4ViuWbndz94zzjGIlhjCu+pGCOqCDC+J6F1KwZFxwQ==
X-Received: from wmbgz10.prod.google.com ([2002:a05:600c:888a:b0:477:afa:d217])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b16:b0:477:632a:fd67
 with SMTP id 5b1f17b1804b1-477b895407bmr35716765e9.12.1763651547909; Thu, 20
 Nov 2025 07:12:27 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:38 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-14-elver@google.com>
Subject: [PATCH v4 13/35] bit_spinlock: Support Clang's context analysis
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 93FB140016
X-Stat-Signature: hh8d6npicsm3egi8urnmae5zcfxj9pim
X-Rspam-User: 
X-HE-Tag: 1763651549-539235
X-HE-Meta: U2FsdGVkX1/PltLqn3axFMiF2a9GrecrFrUumJhhItQVrLIF9L2MoaTPra9cCIY+OSdcVlkWVE23B4sjZFz7lHZwk+APRsX8d5lhvHioEBwV2sR+hhiyvlpUIePr8bvqyOr9zFQ4LzW+xo+CLq6tGBp98+KEAU49dAdWrsObKs9Cck6rC+vDr2zS7C2bUF+yjVBWphUdN3GJjDfK7NqHQqdrqJgsmHXU2tyMp2DfgmRriJq6FxuYSioksXpBUKbsON7/fNCtYAwL41Pzwd9Oa4VNHAz890+kiVhNmXc/manBJ3dTmvs/UxvFkCrcRZ/uSM8CsUVEaPtm8kLJf31ZwLPdENX/NzHyVGqRfW7tq3kRfNiz3CfVth/9P0UG+11m7mB7OV025SsEWLuVguYS8ROYdIA5BAyu98HEV92u+qIWSIQcK2oAOk+TxPpYaR+cQimHiyfqbdLAe7xYMYAuX3KgiTJxoT8w/pfsVEQJj6V/8Ef5V9CSvlPzhC9jHOBDJrGNuexWPo2xrYGZlvVpt02j6YqTB3r9a0MKMT3uog7DktMzyhTA362dn3lSe6wm0F5h7oIXlmw7BtFsGj6T38lSdGpItvFaD+Gf0pVG2E6l9vB/oI3Q/btbvI6/dPax7myjCIT3uPcjb2w151RgFFZK35fb9keBBTtOPQg6qe6a1ANr1qJ8lQDvPw5Ig1m1GpNvNEYU/Y70oAma2Ib3O7YnHzgwgcACGoBMRucos1iVRJbsXu5Y3buSBRbW7Vs2YcURzfiy9s39NS4mDMU01Vn1CAS8824XAjO+++kpwYRW2+Wx7hCnHLr07qVerpwDsLIF5N3/fp4oWIerOsziR9jvDy/6tMrN1ZpP4Ixu1ZgKe3WexKZCIgHuzSb77dzg5Ksrz1/aMdYYyDodk+TCBArORRZjJ5Hml8DNB0xxr1blGA3isJQjcrASQ75r05nGC+P+CO2xFpqAO3Q/vf4
 8uxi/2nU
 5bQR5k/g+tJ3aJnhXkBxfhE0lmY615Q199howxiVDQHsFcTq6ifONpsq17l8nWJU2OrZMdd0VTQtdRlRVfOZ6LjcqQWKVQcWvvIzHVCs2KrbKcP2QuowN99AeO1WJqEP8wR1QWU9ZgscFZQjMwJmTBFPT+RsmZ+e5NCybUVOOwD4OezKp/+Fnxpen5qaFhDWMC4yWVv4M3vpRzXVq2CKpylxrmq4Gp3C2YagB8KukG8yyOdRae2aoEnk+s4Bs0Wm0PUglH8+khoExn0xeRycnOMGotDwSgqtf8ixmS8pDfanD3w2YPnF5SOZGdXmNp4WNW+28fJyEdYtVDAHyXiA5Bq4zsKdH5f0yYI/T9ySsh+9aWdlvLtKT6i8aRgOD3WfwU1wNyb4VjTsiMjbZme3ss+mtRqam8OQvkvhZ0HGBL5zPa9Gw+mk8zj/d0+70wVMVBBIQkMN3e7dURQQ89eWnAHzsGUcE7ZrBdQnx7rtM7hPxAbk6/SciJk1VeNRcL8C/MmDweLyH+i7c15z31VyKq2SnXB70KH1zXtwuZfdpnKjAEVHm7d+LDie1zfXXhSUf9w8fA6TTKKRZ/z8TzhkbQS6DoWIM9cVi6n6gn+mj81CPhCulRfUXhYFFnnk9hIUBaWXv4iL2cZwfeNVs54j/t/i+Pi9kpQEyamDE92PUalwG35d3nZCJ5RuCAZCJkjiPG8LIF9KjxrmZK2ySDuJWHa3MCVp8fo2ToLBX9CG25CsxeyPNpx9/NaW8YlaGLbYvUe7h3SQ5Cmfjqoj9Tv18L4RShQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The annotations for bit_spinlock.h have simply been using "bitlock" as
the token. For Sparse, that was likely sufficient in most cases. But
Clang's context analysis is more precise, and we need to ensure we
can distinguish different bitlocks.

To do so, add a token context, and a macro __bitlock(bitnum, addr)
that is used to construct unique per-bitlock tokens.

Add the appropriate test.

<linux/list_bl.h> is implicitly included through other includes, and
requires 2 annotations to indicate that acquisition (without release)
and release (without prior acquisition) of its bitlock is intended.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.
---
 Documentation/dev-tools/context-analysis.rst |  3 ++-
 include/linux/bit_spinlock.h                 | 22 ++++++++++++++---
 include/linux/list_bl.h                      |  2 ++
 lib/test_context-analysis.c                  | 26 ++++++++++++++++++++
 4 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index 598962f6cb40..a3d925ce2df4 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -80,7 +80,8 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
+`bit_spinlock`.
 
 For context guards with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index 59e345f74b0e..07593d9003d5 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -9,6 +9,16 @@
 
 #include <asm/processor.h>  /* for cpu_relax() */
 
+/*
+ * For static context analysis, we need a unique token for each possible bit
+ * that can be used as a bit_spinlock. The easiest way to do that is to create a
+ * fake context that we can cast to with the __bitlock(bitnum, addr) macro
+ * below, which will give us unique instances for each (bit, addr) pair that the
+ * static analysis can use.
+ */
+context_guard_struct(__context_bitlock) { };
+#define __bitlock(bitnum, addr) (struct __context_bitlock *)(bitnum + (addr))
+
 /*
  *  bit-based spin_lock()
  *
@@ -16,6 +26,7 @@
  * are significantly faster.
  */
 static __always_inline void bit_spin_lock(int bitnum, unsigned long *addr)
+	__acquires(__bitlock(bitnum, addr))
 {
 	/*
 	 * Assuming the lock is uncontended, this never enters
@@ -34,13 +45,14 @@ static __always_inline void bit_spin_lock(int bitnum, unsigned long *addr)
 		preempt_disable();
 	}
 #endif
-	__acquire(bitlock);
+	__acquire(__bitlock(bitnum, addr));
 }
 
 /*
  * Return true if it was acquired
  */
 static __always_inline int bit_spin_trylock(int bitnum, unsigned long *addr)
+	__cond_acquires(true, __bitlock(bitnum, addr))
 {
 	preempt_disable();
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
@@ -49,7 +61,7 @@ static __always_inline int bit_spin_trylock(int bitnum, unsigned long *addr)
 		return 0;
 	}
 #endif
-	__acquire(bitlock);
+	__acquire(__bitlock(bitnum, addr));
 	return 1;
 }
 
@@ -57,6 +69,7 @@ static __always_inline int bit_spin_trylock(int bitnum, unsigned long *addr)
  *  bit-based spin_unlock()
  */
 static __always_inline void bit_spin_unlock(int bitnum, unsigned long *addr)
+	__releases(__bitlock(bitnum, addr))
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
@@ -65,7 +78,7 @@ static __always_inline void bit_spin_unlock(int bitnum, unsigned long *addr)
 	clear_bit_unlock(bitnum, addr);
 #endif
 	preempt_enable();
-	__release(bitlock);
+	__release(__bitlock(bitnum, addr));
 }
 
 /*
@@ -74,6 +87,7 @@ static __always_inline void bit_spin_unlock(int bitnum, unsigned long *addr)
  *  protecting the rest of the flags in the word.
  */
 static __always_inline void __bit_spin_unlock(int bitnum, unsigned long *addr)
+	__releases(__bitlock(bitnum, addr))
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
@@ -82,7 +96,7 @@ static __always_inline void __bit_spin_unlock(int bitnum, unsigned long *addr)
 	__clear_bit_unlock(bitnum, addr);
 #endif
 	preempt_enable();
-	__release(bitlock);
+	__release(__bitlock(bitnum, addr));
 }
 
 /*
diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index ae1b541446c9..df9eebe6afca 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -144,11 +144,13 @@ static inline void hlist_bl_del_init(struct hlist_bl_node *n)
 }
 
 static inline void hlist_bl_lock(struct hlist_bl_head *b)
+	__acquires(__bitlock(0, b))
 {
 	bit_spin_lock(0, (unsigned long *)b);
 }
 
 static inline void hlist_bl_unlock(struct hlist_bl_head *b)
+	__releases(__bitlock(0, b))
 {
 	__bit_spin_unlock(0, (unsigned long *)b);
 }
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 59c6642c582e..77e599a9281b 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -4,6 +4,7 @@
  * positive errors when compiled with Clang's context analysis.
  */
 
+#include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
 #include <linux/seqlock.h>
@@ -251,3 +252,28 @@ static void __used test_seqlock_writer(struct test_seqlock_data *d)
 	d->counter++;
 	write_sequnlock_irqrestore(&d->sl, flags);
 }
+
+struct test_bit_spinlock_data {
+	unsigned long bits;
+	int counter __guarded_by(__bitlock(3, &bits));
+};
+
+static void __used test_bit_spin_lock(struct test_bit_spinlock_data *d)
+{
+	/*
+	 * Note, the analysis seems to have false negatives, because it won't
+	 * precisely recognize the bit of the fake __bitlock() token.
+	 */
+	bit_spin_lock(3, &d->bits);
+	d->counter++;
+	bit_spin_unlock(3, &d->bits);
+
+	bit_spin_lock(3, &d->bits);
+	d->counter++;
+	__bit_spin_unlock(3, &d->bits);
+
+	if (bit_spin_trylock(3, &d->bits)) {
+		d->counter++;
+		bit_spin_unlock(3, &d->bits);
+	}
+}
-- 
2.52.0.rc1.455.g30608eb744-goog


