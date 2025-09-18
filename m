Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A962CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D960B8E012B; Thu, 18 Sep 2025 10:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E058E0112; Thu, 18 Sep 2025 10:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C84678E012B; Thu, 18 Sep 2025 10:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4E5D8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7085556F6B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:08 +0000 (UTC)
X-FDA: 83902545216.30.B7B243A
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 79CB0180014
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="bP5DF7/1";
	spf=pass (imf06.hostedemail.com: domain of 3zBHMaAUKCG0PWgPcRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3zBHMaAUKCG0PWgPcRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBolDvDOcn9D07EK9oOcgseWQJt3GEJTc9gsXdDIsBk=;
	b=zEzNTWPWVWu3eFgTvvaBh2HPe1nBv6nsUC5wNT1JwlPuWhX4REo6p6nFjUg7gGR9CvIzEg
	sGarRZmC+Gd7kaxfIDB62zOnCg+Qdm6pLY2NGZqXCFKTT7oX3do95C8G8Y5wieBfF7euIx
	mZ8OkHGMhy0kox6yZbYB3oSv47sw070=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="bP5DF7/1";
	spf=pass (imf06.hostedemail.com: domain of 3zBHMaAUKCG0PWgPcRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3zBHMaAUKCG0PWgPcRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204366; a=rsa-sha256;
	cv=none;
	b=tfdP1rAlCsXdNUCjp8CUz6fOVnqscfiuW+Z72bk8teJhrQHGiepOclDW3fudYsJU5uDFe6
	MHvZcKMpYa3INivCUwVIcf9pI7fImiMhSwt4uDTyd9Bthyv5twG8IuKIxTZP978BLf26pm
	CUyynw4Tq1IrhnamBcU9sFVm80P0MFM=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45f2b0eba08so6016405e9.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204365; x=1758809165; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mBolDvDOcn9D07EK9oOcgseWQJt3GEJTc9gsXdDIsBk=;
        b=bP5DF7/1VqbsHVJMQsp5rGRgFuU9fWrONT23qz1Bl0veS7IXPxO0iabSMmjQUAtLJg
         2AenbRUvwLIbhlCQ29/Aa34100dkaHx0QmoIstd7GUsIsrwJANQ4N5/nhfkz3TllGV0H
         wpoNiUa3lFXwMND2+t+9QiqSf7xxMqqnGt+IzyNVzvZ104sPRVSmztyv21JZUjOPX7zE
         o0lBsBuAoAEQOqscaPlywDE/cE85OSHUzB28vc1W+WBKGv7Yqqs7qwnjgACWXhlJbAdm
         rB6kck7f32SwV9WMpxrcAgk6X1NMlcy79b/nyObwPEgrDHe2AodHihI+NiJn5GU0kQYY
         B9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204365; x=1758809165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mBolDvDOcn9D07EK9oOcgseWQJt3GEJTc9gsXdDIsBk=;
        b=P5+SpIuFySS0Ram2u6XeoxG13CyoJKZ6rlCwrh8aWwzfesGVYRr3I/9NdeMon0tmza
         CVRMQSsnhQti6PBk9J8f8svpJGt6pstmwyRMUaw+FGIjLbVDGId27bfbdWHqfEB+X2DG
         jxKVAQCxpPvEuQH0t6XB29fXdNMK0gRW5KIKkc046tWz2kbdhXhyYXAqZrbjhzVXLW1Y
         0WR5qdI9w5YChGupON601CCpn9ER0BIR4y7rc/HA2ivMR03FZoS4owrCx3J6ohn2S00a
         A3wDOrgMq0/PDz7L1CYaSt2zjpD0yGl7ErZPzy/sVQy4Krso2N5kB4+2W7UyS0NB02Rf
         CABQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5ntN7r3fz/uKhpT4/SlV7DTRSSuGYhF5gY1Q5mjleWokBRNtRDAOcxlTlzr44Kb83gn+nhgWooA==@kvack.org
X-Gm-Message-State: AOJu0YzmY9aR/gj3W4SrxAsVKQ8027W6wNmP/AkvNqV5KMYNnAgQl8px
	bLdMlwQjK53I2s1jl94YdeAM9vo2a2F5agxFSmDKTfXuAt5kbqIPWKWjsef2RO9E9fymNTIYogV
	fDA==
X-Google-Smtp-Source: AGHT+IFb2AKQsrgy+9U0aOOe79o96Wy9WfjB+UClLxTo6d1GpGlGWiIQriIzMhIBe10f0b/UUl6OL3lZtg==
X-Received: from wmbhh13.prod.google.com ([2002:a05:600c:530d:b0:45d:cf67:3908])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c87:b0:45d:d5c6:482
 with SMTP id 5b1f17b1804b1-46205cc836cmr63930155e9.18.1758204364942; Thu, 18
 Sep 2025 07:06:04 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:25 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-15-elver@google.com>
Subject: [PATCH v3 14/35] rcu: Support Clang's capability analysis
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
X-Stat-Signature: c1kuz6sjrohxyyebkko5afxxjp4jwqwq
X-Rspam-User: 
X-Rspamd-Queue-Id: 79CB0180014
X-Rspamd-Server: rspam04
X-HE-Tag: 1758204366-507383
X-HE-Meta: U2FsdGVkX1/q4dM/SJv5xJVlouPQY5VfKbF240KlOUD2hIs/llxavHCjHRZIa5KnI0oZZ8rSHcFWiEFz6bOIdDaTAm6H7kyKSYqeNOHg/E1S3RpF6wCOh2/RLf3ZtJ+GRd1b09ZJYqLqr/CDxT7NeIhQFR7HIuiVK4xFS/AVt2JjUAnZVLqQen8nivEq9tsHH+4ZN/AdgZjkX1hiAvzril/u96xiTOGUV9liDVq4gaLgdp3pLaW+7/4NdDqhPL/w2pXkNUPKvfCVzrkRkeVBEzNB4FwWpQCFfIXmPhsSLWLbMlgK43F82OxH9F0FDDA/2iuokg4mHMZrMkxqIjLooel79wbI/rrKa9ELI1XbeaFuGNfHfHzToZZcYNPAgWSyT2FDi0NsdC4oYNxEu9U1Xjy4w2Zb12soCzYO1r9JOHj212RVfQ1dXqMG/L5rqEz4ANAXnRlESypEqQEXYUCw7ay7P/UyNdH9HXaNtbiEGeC7XI76KcrUP9hy+YiSQGD4Q07TP+d3NQfDoGPYctALpKKuEXtELWV0THgKyPaSiyFOhbqNoXE2Pmuah/c/unSZNG0PglN1D8idVfRuEPEl4hr0nKto8GjlC2L7aOW8K2LBSK6b07RhSuSH/HNgW0eKw2mr3RoIOsiO575qcxSctzgD51Slk0Nq4HxJILO/aWljO62SRUHOIKuB60eu+ZFsVZLd7zwEBgB+b2ZjdoFR/pPIxpz5jokLGZuN+nFpiRzhWxV5qOnJf64aTBSdGxLQv6O77dw30gDOgVfWz2JZ34ykVQWIGsIwW8R28p3yb8cz5Ga+S8SIwZPzt/OgkqdJNUNIHISiOpAK/lDCqmJ9JAuAL0+MxyDjknX6BjXSPoou/Qtd3McImK8u4IkVl1iI8gRKdp2AiXZD9G1gbLredjUegChT8NgRz1EpTcp/AaF9lDdt36ptszuBx/YWfMjKtqSq7FSX6zIm2a9FWhn
 9+3F1XBr
 m96u832TN9U0W1jPK4jCBADYfgYS5coZPx4SjKje7t4wuV6aBD/7FGtiZFeEP4dMTqMYAxGPHjkY4xNJC1Od/N1gPGpYr6Reec6q1PwCY1ZhJEUu+uwmYe9Z4mvTBc0VlAc41a9dohAVScwWRPZAdkJ/baoRjQtYdQ+iYpQAWGOO6xPckTDB30Mfs+YUEhYJteusUTQ+qdx7b+vysvh/xCo/izSAGtw/GYJPGS3Dn+h5BMu5ILNwDoKZ8kKagCxnB6UKPbcghMXHdXokZKJ+oJc/TCztBdlV8F12LTV09Y+2AV3S1QGLq0af8ZyEsyj9aOqPsls8/Bmvu4HIb7kkXIc3nXiAW6AYFGNhgGMVP9GXRWHSQpynVoz3xQzU2/l3+ngMlYLzdQI8cF0OGIy6I3s2X7U3k0cwl0mVhEWEIvI68fAXnviq89PZNi+m3P1VmX2Qmlz0tClhlfGNFmh/4dM9b4dE3Brmhr0BlVyULsjdUJSiWTaL3p1S1zbKAOAK8rILco3e+jWz6DP/E+JszUXXTqgksIckKJSaDaw3Y3v2Yf+oB55+Ad6M707EgfHN/F8xx3T6Wlwr6vkCnFAuwQavmxdjHEy+gNcXKBOwIfN+Jv3Hy51UxvNbHixwCPVy2NkcT+mCiClGZqmI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Improve the existing annotations to properly support Clang's capability
analysis.

The old annotations distinguished between RCU, RCU_BH, and RCU_SCHED;
however, to more easily be able to express that "hold the RCU read lock"
without caring if the normal, _bh(), or _sched() variant was used we'd
have to remove the distinction of the latter variants: change the _bh()
and _sched() variants to also acquire "RCU".

When (and if) we introduce capabilities to denote more generally that
"IRQ", "BH", "PREEMPT" are disabled, it would make sense to acquire
these capabilities instead of RCU_BH and RCU_SCHED respectively.

The above change also simplified introducing __guarded_by support, where
only the "RCU" capability needs to be held: introduce __rcu_guarded,
where Clang's capability analysis warns if a pointer is dereferenced
without any of the RCU locks held, or updated without the appropriate
helpers.

The primitives rcu_assign_pointer() and friends are wrapped with
capability_unsafe(), which enforces using them to update RCU-protected
pointers marked with __rcu_guarded.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* Properly support reentrancy via new compiler support.

v2:
* Reword commit message and point out reentrancy caveat.
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/rcupdate.h                      | 73 +++++++++++-----
 lib/test_capability-analysis.c                | 85 +++++++++++++++++++
 3 files changed, 136 insertions(+), 24 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 56c6ba7205aa..fdacc7f73da8 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -82,7 +82,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`.
+`bit_spinlock`, RCU.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 120536f4c6eb..8eeece72492c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -31,6 +31,16 @@
 #include <asm/processor.h>
 #include <linux/context_tracking_irq.h>
 
+token_capability(RCU, __reentrant_cap);
+token_capability_instance(RCU, RCU_SCHED);
+token_capability_instance(RCU, RCU_BH);
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
+static inline bool lockdep_assert_rcu_helper(bool c, const struct __capability_RCU *cap)
+	__assumes_shared_cap(RCU) __assumes_shared_cap(cap)
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
+#define lockdep_assert_in_rcu_read_lock() __assume_shared_cap(RCU)
+#define lockdep_assert_in_rcu_read_lock_bh() __assume_shared_cap(RCU_BH)
+#define lockdep_assert_in_rcu_read_lock_sched() __assume_shared_cap(RCU_SCHED)
+#define lockdep_assert_in_rcu_reader() __assume_shared_cap(RCU)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
@@ -506,11 +517,11 @@ static inline bool lockdep_assert_rcu_helper(bool c)
 #endif /* #else #ifdef __CHECKER__ */
 
 #define __unrcu_pointer(p, local)					\
-({									\
+capability_unsafe(							\
 	typeof(*p) *local = (typeof(*p) *__force)(p);			\
 	rcu_check_sparse(p, __rcu);					\
 	((typeof(*p) __force __kernel *)(local)); 			\
-})
+)
 /**
  * unrcu_pointer - mark a pointer as not being RCU protected
  * @p: pointer needing to lose its __rcu property
@@ -586,7 +597,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
  * other macros that it invokes.
  */
 #define rcu_assign_pointer(p, v)					      \
-do {									      \
+capability_unsafe(							      \
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
@@ -835,9 +846,10 @@ do {									      \
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
@@ -865,11 +877,12 @@ static __always_inline void rcu_read_lock(void)
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
 
@@ -888,9 +901,11 @@ static inline void rcu_read_unlock(void)
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
@@ -902,11 +917,13 @@ static inline void rcu_read_lock_bh(void)
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
 
@@ -926,9 +943,11 @@ static inline void rcu_read_unlock_bh(void)
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
@@ -936,9 +955,11 @@ static inline void rcu_read_lock_sched(void)
 
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
@@ -947,18 +968,22 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
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
 
@@ -1001,10 +1026,10 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * ordering guarantees for either the CPU or the compiler.
  */
 #define RCU_INIT_POINTER(p, v) \
-	do { \
+	capability_unsafe( \
 		rcu_check_sparse(p, __rcu); \
 		WRITE_ONCE(p, RCU_INITIALIZER(v)); \
-	} while (0)
+	)
 
 /**
  * RCU_POINTER_INITIALIZER() - statically initialize an RCU protected pointer
@@ -1166,4 +1191,6 @@ DEFINE_LOCK_GUARD_0(rcu,
 	} while (0),
 	rcu_read_unlock())
 
+DECLARE_LOCK_GUARD_0_ATTRS(rcu, __acquires_shared(RCU), __releases_shared(RCU))
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index ad362d5a7916..31c9bc1e2405 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
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
2.51.0.384.g4c02a37b29-goog


