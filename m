Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4EBDCF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33F216B00AF; Thu, 20 Nov 2025 10:12:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316456B00B1; Thu, 20 Nov 2025 10:12:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C446B00B2; Thu, 20 Nov 2025 10:12:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B15A6B00AF
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:12:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA680B6582
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:35 +0000 (UTC)
X-FDA: 84131327070.30.ED83B54
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id E1F20C000F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Frjv3bii;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 34C8faQUKCA0ry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=34C8faQUKCA0ry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651554; a=rsa-sha256;
	cv=none;
	b=avDVuhbnc3eCGbjQ17RY6UmwhN07O0jHxe+xppOx4d/A83BlRy7hQEvEqiTR2c+DTr+k4u
	LvKSHzU9PdIR1Tumwkpgr61/ABSVEYiRpWHhVx2+fqsdSm7c8Gim7sOVuZvCxImF3lWUSG
	n6s/61JFUXoBONKm3p48x5QFjPHwq3g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Frjv3bii;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 34C8faQUKCA0ry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=34C8faQUKCA0ry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ln7UVfCWiCp9IlXxOO2xIWRuRprEYh3pWr1qQfgYpRY=;
	b=AoHrDozB4Vx2yQ95BnCy5DWMYqN4lt44rVLZVsUttvTBANiVq4t/tI73umd6zNQwLM0mOk
	crXlhacfAC4HLaAsP0kARY9h4r1uBI/SbTJadF3b7UnRorQHn/a84KYd3GzlSOKdn6BmxS
	FlFxoP1PHAIya4pKWOI6hpf1Wq7rr/k=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477563e531cso9819885e9.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651552; x=1764256352; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ln7UVfCWiCp9IlXxOO2xIWRuRprEYh3pWr1qQfgYpRY=;
        b=Frjv3biirYpoLckxwQvZaM/lUdgQ4JIBWn+cRj3c/8f+tWnzQSi/ozddjKlWTw2gCe
         5mYJvAcZ/hQ9tvgEgcajhEaIuJ5O8scoolcCxblcCQveB8WJK4JNiepF/9SRN8g44j3h
         hVD0mMVRI/ifxsWanlvmEoaJvlezJL/HalQFwgqjBHk5QvG6FKrVDxuw/Ojk5uXLT449
         Q29P/xHUZgS9vE4fyyUDToSAL+nAVX06LQEMaPwiZgLRkKC1WU+81eheiI4Kg7VGuwvj
         PrQlPIcrHR4uU+o/P1K7W8LBAZNoA/OVQ4dQ86aS573UDMMHfRmV+tDcTp13TmpABThm
         ZP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651552; x=1764256352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ln7UVfCWiCp9IlXxOO2xIWRuRprEYh3pWr1qQfgYpRY=;
        b=r2RVSV7UXdvrhVuMYOmr3fXdab5QxhU37UMVaJphTIrvDHcjnQUJ52JyBNzMWsa31Q
         wMaTR/8pXCSpuCNr46cilUOwSTi+bdnsCmyPbswgCOMRllrZmHr89WC2k/srzjwmGslh
         JOr+C9BN1kTgh7DZRGNC7P5PvT+5ChvoLEozw8/68lKOWVJNUqxnTwxrme0CNFmPWs5r
         J/w8c61JvOtP1OZoF8j970ixvK8eU5Z8qx75HIaf1lJDngbHpsOheQ6zQUW6fS07yQRK
         42rjJSTcQ7UbGXdLNS6M9CMG/IGlQY01E6PaT+Y0L+tVy/no84Bb7E6eVGn2MqOWjZ74
         gSLg==
X-Forwarded-Encrypted: i=1; AJvYcCUlCd7mTxNE4b2PyGQcmYEMJvTpJGhZKJ+NySCZc4L/frPd//vmVzufuabWsC/rmhD/wNWJPMjjdw==@kvack.org
X-Gm-Message-State: AOJu0YwQCS07GUJNVnFXt51xqck4atSmxRQIK45VolCOjEKIlADnGPwC
	0QPu0UJ4Tw5FpGkPrxQ00Wfn6WbKgnrTB5Et5y6WRY04C55ND5FZ6aV+ztRPrRtcKdS1VtRLfh6
	LAA==
X-Google-Smtp-Source: AGHT+IGEIThrt25p8iFaAeOhASluQ3+/NjEt1IOMSXAcPjrVxIIVxtBuFT8+DlrUkxM3iN/ogjkjO7OQog==
X-Received: from wrs17.prod.google.com ([2002:a05:6000:651:b0:42b:328d:1994])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2c05:b0:42b:4267:83d5
 with SMTP id ffacd0b85a97d-42cb9a11c12mr2935283f8f.8.1763651552168; Thu, 20
 Nov 2025 07:12:32 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:39 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-15-elver@google.com>
Subject: [PATCH v4 14/35] rcu: Support Clang's context analysis
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E1F20C000F
X-Stat-Signature: jc5d6mhxwpmgmxan8khdjc1szfo44rqp
X-HE-Tag: 1763651553-937537
X-HE-Meta: U2FsdGVkX1/zdPch6jxi+UpTS1ZaMO5wZPt2l1/40gOC+reJfZYCtyrHlILCO7uGkS2WE54vZaDTO+bleNIUKKR3pAMCo/tPCF/rrAVUUM+8AMyzbeQIG5sVRv48VJWGiTuSfAjs3Hded0RmR0L5xV0OQTtvULpJv8+baL9KUbdtQRIJ0TjROeMSN0i9RD7aLH0KmxY89bccXaKRDjaWzWqq176T8RNZTa6nF9QaqfKE9VmpFGSPRCbxBdJEhdNlJ/1msAFbSZOMW6izVT0uXbFZAnwLy4M+KZPZAGRSIF2aXDLpubkox2r6sCUrrcA5ryHAQ0Ha1L5TIh6hCE7yrU7vNabjRnWoTOBCqkvZtyjAI36H6pdcBBR7Fd35c43mt0XpGB4vMU7BtdhZ1E+lMtoSAulr/IVQ9p2Xm2cfNHXlCV9LZx9Gx9Ty9zNDt8jUmm73nzaFmTzvEIoU7lYij49LwIUkHc3mtflGdDDcEEnMX96QhdTwgH2hGmyxlmKlYfGZfoXlGEx7IFvTvoc2bTeYFCwa91l+3Q3peqf7eu+vj+bxrlNxsKws9J2Ya4ld5SLJYnUT17G4HqWtutgvsv1kbZuwD/j7+nmqjYg8jeZ0cJlu4ZY/uZt+u/kcKHO+Sc+c0SIEUp7r6NDww+BrHEm8R4kydp0b1imMXGHu2iA6rd+G70IUasmiIjopYNtqkfZ/A+fVS+3qokHF8ENoKd63gvdelApKF0eweBZF0UoLWBNkSWTs2XT9Ka3HNgpViVxs4t13VeJfvjSM+wARV0Q2Edk6bC6oYcAfcmvFSdTMxA/MXNWu2ifOstAIujnOYvb3Hym5vGKbtyrTHEyxSXqIAOO5PgsQsWKSVw5XeBKlO5g4RoSAxNaTvRs1XVFs+upBOC10d5SHjPYkqMeQBv+B8+qe6rxvrKBpL5LDBsnmpYLmfkHwiMlJr0FV0iol2ro30/pVNF5i41JqViw
 ceW3yiIF
 EgPBr5UH0S0DKtWopouB9CnpR1+jbiH0n3vLd0WPKTauVoX8VeuY0eRXqiDc/Lgz4iwYcBxTaXzZ8a9H6qkRXDfV35cxPxk6l8HHzWqtQDpoagPe7E+a98mJ4q9w6jIoMl7ROQNioIun6lZJhet2DP5GpGxxf3eyLb+FIZciykkXVtsAAvBaeo53w6WFMLeLC1e1AB8R9DtXhb+DnZLCS4xPWpCx5zalPnT4D2h2aV2P4z9N+EbIeh+IwDeqespq/RgrrvC5fBwpI/xQj59qu1Dpkp24/RzOffIyY5lABUdbiH2ws/6PT0xe5YHiu6H2SiqDrHTpjf+m8WJdihgR8z4uiTmcA1ai+j4owovcVd3CR9uDgVManWWgs90Pl6U/YoPcYIOqroYEmfb0jJRwCjgi/cRjjJXlznuig5lSYep+rQEvWb+fq89fHMTp7yYg7zu5glRXtX0p2UN1zIP5MUnI8HtIJgajWkWHZQ0bAxwFj6TnUOEQzdfJrK8CP0ROTNPq+lCKiGFveqHqldIzYdWZMH0QXmWHYTlwX0m9rDTkb5A+gHDkImssM5+w0udiM5ESFI8kAqx6kurS4Z3dxVbsQu/Cp7OxG+utkHg1STtVwn5If2rk5MqAZ5PC0JrflUbrsIeK4CAhycbeiQ0QZoCqeurVVdks7dAZQdWC3aKDENw7RHlL21XQevgJcSzKohrsR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Improve the existing annotations to properly support Clang's context
analysis.

The old annotations distinguished between RCU, RCU_BH, and RCU_SCHED;
however, to more easily be able to express that "hold the RCU read lock"
without caring if the normal, _bh(), or _sched() variant was used we'd
have to remove the distinction of the latter variants: change the _bh()
and _sched() variants to also acquire "RCU".

When (and if) we introduce context guards to denote more generally that
"IRQ", "BH", "PREEMPT" contexts are disabled, it would make sense to
acquire these instead of RCU_BH and RCU_SCHED respectively.

The above change also simplified introducing __guarded_by support, where
only the "RCU" context guard needs to be held: introduce __rcu_guarded,
where Clang's context analysis warns if a pointer is dereferenced
without any of the RCU locks held, or updated without the appropriate
helpers.

The primitives rcu_assign_pointer() and friends are wrapped with
context_unsafe(), which enforces using them to update RCU-protected
pointers marked with __rcu_guarded.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* Properly support reentrancy via new compiler support.

v2:
* Reword commit message and point out reentrancy caveat.
---
 Documentation/dev-tools/context-analysis.rst |  2 +-
 include/linux/rcupdate.h                     | 77 ++++++++++++------
 lib/test_context-analysis.c                  | 85 ++++++++++++++++++++
 3 files changed, 139 insertions(+), 25 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index a3d925ce2df4..05164804a92a 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -81,7 +81,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`.
+`bit_spinlock`, RCU.
 
 For context guards with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c5b30054cd01..5cddb9019a99 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -31,6 +31,16 @@
 #include <asm/processor.h>
 #include <linux/context_tracking_irq.h>
 
+token_context_guard(RCU, __reentrant_ctx_guard);
+token_context_guard_instance(RCU, RCU_SCHED);
+token_context_guard_instance(RCU, RCU_BH);
+
+/*
+ * A convenience macro that can be used for RCU-protected globals or struct
+ * members; adds type qualifier __rcu, and also enforces __guarded_by(RCU).
+ */
+#define __rcu_guarded __rcu __guarded_by(RCU)
+
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
 
@@ -425,7 +435,8 @@ static inline void rcu_preempt_sleep_check(void) { }
 
 // See RCU_LOCKDEP_WARN() for an explanation of the double call to
 // debug_lockdep_rcu_enabled().
-static inline bool lockdep_assert_rcu_helper(bool c)
+static inline bool lockdep_assert_rcu_helper(bool c, const struct __ctx_guard_RCU *ctx)
+	__assumes_shared_ctx_guard(RCU) __assumes_shared_ctx_guard(ctx)
 {
 	return debug_lockdep_rcu_enabled() &&
 	       (c || !rcu_is_watching() || !rcu_lockdep_current_cpu_online()) &&
@@ -438,7 +449,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
  * Splats if lockdep is enabled and there is no rcu_read_lock() in effect.
  */
 #define lockdep_assert_in_rcu_read_lock() \
-	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map)))
+	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map), RCU))
 
 /**
  * lockdep_assert_in_rcu_read_lock_bh - WARN if not protected by rcu_read_lock_bh()
@@ -448,7 +459,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
  * actual rcu_read_lock_bh() is required.
  */
 #define lockdep_assert_in_rcu_read_lock_bh() \
-	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_bh_lock_map)))
+	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_bh_lock_map), RCU_BH))
 
 /**
  * lockdep_assert_in_rcu_read_lock_sched - WARN if not protected by rcu_read_lock_sched()
@@ -458,7 +469,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
  * instead an actual rcu_read_lock_sched() is required.
  */
 #define lockdep_assert_in_rcu_read_lock_sched() \
-	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_sched_lock_map)))
+	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_sched_lock_map), RCU_SCHED))
 
 /**
  * lockdep_assert_in_rcu_reader - WARN if not within some type of RCU reader
@@ -476,17 +487,17 @@ static inline bool lockdep_assert_rcu_helper(bool c)
 	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map) &&			\
 					       !lock_is_held(&rcu_bh_lock_map) &&		\
 					       !lock_is_held(&rcu_sched_lock_map) &&		\
-					       preemptible()))
+					       preemptible(), RCU))
 
 #else /* #ifdef CONFIG_PROVE_RCU */
 
 #define RCU_LOCKDEP_WARN(c, s) do { } while (0 && (c))
 #define rcu_sleep_check() do { } while (0)
 
-#define lockdep_assert_in_rcu_read_lock() do { } while (0)
-#define lockdep_assert_in_rcu_read_lock_bh() do { } while (0)
-#define lockdep_assert_in_rcu_read_lock_sched() do { } while (0)
-#define lockdep_assert_in_rcu_reader() do { } while (0)
+#define lockdep_assert_in_rcu_read_lock() __assume_shared_ctx_guard(RCU)
+#define lockdep_assert_in_rcu_read_lock_bh() __assume_shared_ctx_guard(RCU_BH)
+#define lockdep_assert_in_rcu_read_lock_sched() __assume_shared_ctx_guard(RCU_SCHED)
+#define lockdep_assert_in_rcu_reader() __assume_shared_ctx_guard(RCU)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
@@ -506,11 +517,11 @@ static inline bool lockdep_assert_rcu_helper(bool c)
 #endif /* #else #ifdef __CHECKER__ */
 
 #define __unrcu_pointer(p, local)					\
-({									\
+context_unsafe(								\
 	typeof(*p) *local = (typeof(*p) *__force)(p);			\
 	rcu_check_sparse(p, __rcu);					\
-	((typeof(*p) __force __kernel *)(local)); 			\
-})
+	((typeof(*p) __force __kernel *)(local)) 			\
+)
 /**
  * unrcu_pointer - mark a pointer as not being RCU protected
  * @p: pointer needing to lose its __rcu property
@@ -586,7 +597,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
  * other macros that it invokes.
  */
 #define rcu_assign_pointer(p, v)					      \
-do {									      \
+context_unsafe(							      \
 	uintptr_t _r_a_p__v = (uintptr_t)(v);				      \
 	rcu_check_sparse(p, __rcu);					      \
 									      \
@@ -594,7 +605,7 @@ do {									      \
 		WRITE_ONCE((p), (typeof(p))(_r_a_p__v));		      \
 	else								      \
 		smp_store_release(&p, RCU_INITIALIZER((typeof(p))_r_a_p__v)); \
-} while (0)
+)
 
 /**
  * rcu_replace_pointer() - replace an RCU pointer, returning its old value
@@ -861,9 +872,10 @@ do {									      \
  * only when acquiring spinlocks that are subject to priority inheritance.
  */
 static __always_inline void rcu_read_lock(void)
+	__acquires_shared(RCU)
 {
 	__rcu_read_lock();
-	__acquire(RCU);
+	__acquire_shared(RCU);
 	rcu_lock_acquire(&rcu_lock_map);
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_lock() used illegally while idle");
@@ -891,11 +903,12 @@ static __always_inline void rcu_read_lock(void)
  * See rcu_read_lock() for more information.
  */
 static inline void rcu_read_unlock(void)
+	__releases_shared(RCU)
 {
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_unlock() used illegally while idle");
 	rcu_lock_release(&rcu_lock_map); /* Keep acq info for rls diags. */
-	__release(RCU);
+	__release_shared(RCU);
 	__rcu_read_unlock();
 }
 
@@ -914,9 +927,11 @@ static inline void rcu_read_unlock(void)
  * was invoked from some other task.
  */
 static inline void rcu_read_lock_bh(void)
+	__acquires_shared(RCU) __acquires_shared(RCU_BH)
 {
 	local_bh_disable();
-	__acquire(RCU_BH);
+	__acquire_shared(RCU);
+	__acquire_shared(RCU_BH);
 	rcu_lock_acquire(&rcu_bh_lock_map);
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_lock_bh() used illegally while idle");
@@ -928,11 +943,13 @@ static inline void rcu_read_lock_bh(void)
  * See rcu_read_lock_bh() for more information.
  */
 static inline void rcu_read_unlock_bh(void)
+	__releases_shared(RCU) __releases_shared(RCU_BH)
 {
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_unlock_bh() used illegally while idle");
 	rcu_lock_release(&rcu_bh_lock_map);
-	__release(RCU_BH);
+	__release_shared(RCU_BH);
+	__release_shared(RCU);
 	local_bh_enable();
 }
 
@@ -952,9 +969,11 @@ static inline void rcu_read_unlock_bh(void)
  * rcu_read_lock_sched() was invoked from an NMI handler.
  */
 static inline void rcu_read_lock_sched(void)
+	__acquires_shared(RCU) __acquires_shared(RCU_SCHED)
 {
 	preempt_disable();
-	__acquire(RCU_SCHED);
+	__acquire_shared(RCU);
+	__acquire_shared(RCU_SCHED);
 	rcu_lock_acquire(&rcu_sched_lock_map);
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_lock_sched() used illegally while idle");
@@ -962,9 +981,11 @@ static inline void rcu_read_lock_sched(void)
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
 static inline notrace void rcu_read_lock_sched_notrace(void)
+	__acquires_shared(RCU) __acquires_shared(RCU_SCHED)
 {
 	preempt_disable_notrace();
-	__acquire(RCU_SCHED);
+	__acquire_shared(RCU);
+	__acquire_shared(RCU_SCHED);
 }
 
 /**
@@ -973,22 +994,27 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  * See rcu_read_lock_sched() for more information.
  */
 static inline void rcu_read_unlock_sched(void)
+	__releases_shared(RCU) __releases_shared(RCU_SCHED)
 {
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_unlock_sched() used illegally while idle");
 	rcu_lock_release(&rcu_sched_lock_map);
-	__release(RCU_SCHED);
+	__release_shared(RCU_SCHED);
+	__release_shared(RCU);
 	preempt_enable();
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
 static inline notrace void rcu_read_unlock_sched_notrace(void)
+	__releases_shared(RCU) __releases_shared(RCU_SCHED)
 {
-	__release(RCU_SCHED);
+	__release_shared(RCU_SCHED);
+	__release_shared(RCU);
 	preempt_enable_notrace();
 }
 
 static __always_inline void rcu_read_lock_dont_migrate(void)
+	__acquires_shared(RCU)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RCU))
 		migrate_disable();
@@ -996,6 +1022,7 @@ static __always_inline void rcu_read_lock_dont_migrate(void)
 }
 
 static inline void rcu_read_unlock_migrate(void)
+	__releases_shared(RCU)
 {
 	rcu_read_unlock();
 	if (IS_ENABLED(CONFIG_PREEMPT_RCU))
@@ -1041,10 +1068,10 @@ static inline void rcu_read_unlock_migrate(void)
  * ordering guarantees for either the CPU or the compiler.
  */
 #define RCU_INIT_POINTER(p, v) \
-	do { \
+	context_unsafe( \
 		rcu_check_sparse(p, __rcu); \
 		WRITE_ONCE(p, RCU_INITIALIZER(v)); \
-	} while (0)
+	)
 
 /**
  * RCU_POINTER_INITIALIZER() - statically initialize an RCU protected pointer
@@ -1206,4 +1233,6 @@ DEFINE_LOCK_GUARD_0(rcu,
 	} while (0),
 	rcu_read_unlock())
 
+DECLARE_LOCK_GUARD_0_ATTRS(rcu, __acquires_shared(RCU), __releases_shared(RCU))
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 77e599a9281b..f18b7252646d 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -7,6 +7,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
+#include <linux/rcupdate.h>
 #include <linux/seqlock.h>
 #include <linux/spinlock.h>
 
@@ -277,3 +278,87 @@ static void __used test_bit_spin_lock(struct test_bit_spinlock_data *d)
 		bit_spin_unlock(3, &d->bits);
 	}
 }
+
+/*
+ * Test that we can mark a variable guarded by RCU, and we can dereference and
+ * write to the pointer with RCU's primitives.
+ */
+struct test_rcu_data {
+	long __rcu_guarded *data;
+};
+
+static void __used test_rcu_guarded_reader(struct test_rcu_data *d)
+{
+	rcu_read_lock();
+	(void)rcu_dereference(d->data);
+	rcu_read_unlock();
+
+	rcu_read_lock_bh();
+	(void)rcu_dereference(d->data);
+	rcu_read_unlock_bh();
+
+	rcu_read_lock_sched();
+	(void)rcu_dereference(d->data);
+	rcu_read_unlock_sched();
+}
+
+static void __used test_rcu_guard(struct test_rcu_data *d)
+{
+	guard(rcu)();
+	(void)rcu_dereference(d->data);
+}
+
+static void __used test_rcu_guarded_updater(struct test_rcu_data *d)
+{
+	rcu_assign_pointer(d->data, NULL);
+	RCU_INIT_POINTER(d->data, NULL);
+	(void)unrcu_pointer(d->data);
+}
+
+static void wants_rcu_held(void)	__must_hold_shared(RCU)       { }
+static void wants_rcu_held_bh(void)	__must_hold_shared(RCU_BH)    { }
+static void wants_rcu_held_sched(void)	__must_hold_shared(RCU_SCHED) { }
+
+static void __used test_rcu_lock_variants(void)
+{
+	rcu_read_lock();
+	wants_rcu_held();
+	rcu_read_unlock();
+
+	rcu_read_lock_bh();
+	wants_rcu_held_bh();
+	rcu_read_unlock_bh();
+
+	rcu_read_lock_sched();
+	wants_rcu_held_sched();
+	rcu_read_unlock_sched();
+}
+
+static void __used test_rcu_lock_reentrant(void)
+{
+	rcu_read_lock();
+	rcu_read_lock();
+	rcu_read_lock_bh();
+	rcu_read_lock_bh();
+	rcu_read_lock_sched();
+	rcu_read_lock_sched();
+
+	rcu_read_unlock_sched();
+	rcu_read_unlock_sched();
+	rcu_read_unlock_bh();
+	rcu_read_unlock_bh();
+	rcu_read_unlock();
+	rcu_read_unlock();
+}
+
+static void __used test_rcu_assert_variants(void)
+{
+	lockdep_assert_in_rcu_read_lock();
+	wants_rcu_held();
+
+	lockdep_assert_in_rcu_read_lock_bh();
+	wants_rcu_held_bh();
+
+	lockdep_assert_in_rcu_read_lock_sched();
+	wants_rcu_held_sched();
+}
-- 
2.52.0.rc1.455.g30608eb744-goog


