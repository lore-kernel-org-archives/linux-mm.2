Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F8ED7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F266B00AB; Fri, 19 Dec 2025 10:46:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65DBB6B00AD; Fri, 19 Dec 2025 10:46:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589A36B00AE; Fri, 19 Dec 2025 10:46:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 434736B00AB
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F7E81A01E0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:24 +0000 (UTC)
X-FDA: 84236647488.13.96BF03D
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 40F181A001A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=g2aGD1Vx;
	spf=pass (imf19.hostedemail.com: domain of 3THNFaQUKCJk7EO7K9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3THNFaQUKCJk7EO7K9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159182; a=rsa-sha256;
	cv=none;
	b=M91rN6LEAzbasbqkbxvuhCvncDkeFe8V2xMfXERIZBQP0wl1mK4GJkgyMJakhDUNJKwPJe
	lg9YvxUmfkH7QCqW5a6hBl3nx+afOJ/d49KC5ATr4Yrlx97ZLU8KKNe7cG/QZnxY6XtHSg
	2ughcGepDBjgooJUbP0IDBH7RUV8dZk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=g2aGD1Vx;
	spf=pass (imf19.hostedemail.com: domain of 3THNFaQUKCJk7EO7K9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3THNFaQUKCJk7EO7K9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jYEguITBPTs5G6jcojPovTyLNy31gBuOV4hxWkZ9us=;
	b=T/0AjLzjwgUGfa2E46/VZ6vt2YDmsxOA0P671nTqF/vzwv+bicFEekHbqRihUhxDbAjRQ/
	fH2qeGvta9bjsBLW/jLBHoITbqiOs8NjyecXL+iIh2yTtarSkmbvn3HmffLZMQLaaOW0C0
	E3OVjscARTkdLSGX7ZsJXA26gsBYOdk=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47777158a85so24752505e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159181; x=1766763981; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+jYEguITBPTs5G6jcojPovTyLNy31gBuOV4hxWkZ9us=;
        b=g2aGD1Vxs9NMM/pjvDEcyIBewnKag7Jl9Gosr/IWBM8PfLlsIkMwGGC/BjTptN6vJr
         c8mBollOjc2/euMB4uNqk6QJz7yGycVTBeudZJmRgcgc5ThahMnFrJAxvaTog6NRb4yk
         wIZogkhM9J6c1GJK4GOo90mFHrHD8hr7g8Yp1//pqKA1QSIrqG2vJZ9CRMxWG8MhWmWo
         wxisuUywMUpgd87Gp0qSA8Eu68CohZEitFIdYWhxdQpj70diULNExHz4Pmbn1y6Pq7Ph
         Wez30C9M2GotvX6GBqau1iqwK68OgBC+h6QlPQ2K+NOVWcEusIbz315HOl94YWGbtkII
         rjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159181; x=1766763981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+jYEguITBPTs5G6jcojPovTyLNy31gBuOV4hxWkZ9us=;
        b=LKb3PCbZhH8phZ/qscbshRM6m9BakgTAVg5AjxsktLXjVgciYgZrr/O3LS80G1JxqZ
         D+37TBK7fD/uawD434XquX+KH3CceAE+/7z/EZWaQkOPK2adZhMoaJJ6auw3k5KViyCs
         lZQKcArL5FcEJubwzsQtcQh9DO9+l79+TZvMNXX+bisYaO/tLplSau3Ayhj0iUK9+KiD
         fS2FcwSkS1G3y8+CIjtH59wTbPVA33bDLg0b2qYYeRZnmAJhjmX6pORKe45ZOThE4upL
         RfhFHD1xX3BiE3aiguUMcr0dl+9oSnoFfaIT7DGRBYGraSXg+V49TKJMJxtYR8QrdhMN
         7FQA==
X-Forwarded-Encrypted: i=1; AJvYcCXsXyfl0U2CMYnklOiXvKGOsivZEFU/GuD0Tx5PkwKLJdgphWrQ4qeA/p0iCvN7c9KoPVP3TFgruA==@kvack.org
X-Gm-Message-State: AOJu0YwUZon4USvta1TSL6RraH3lzk7mzSDituO62nfIR+v9dXYxyDy1
	NuKiPZSXvwYpMFaPqXkPV2GoABVDijnIiMwfmQ6K7h0SaGkLWTycsN0Ymsp51z422QAycPAC7tA
	3oA==
X-Google-Smtp-Source: AGHT+IEYnGuKvpG1yqXy3gpRoAVKm6+YVd4z93VGj6UWW783o4r2dfscOlxqJjdnEPTLmregJbA3SNUltw==
X-Received: from wma9.prod.google.com ([2002:a05:600c:8909:b0:477:a0cb:7165])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5487:b0:47b:da85:b9f3
 with SMTP id 5b1f17b1804b1-47d195a72c0mr32797025e9.23.1766159180751; Fri, 19
 Dec 2025 07:46:20 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:03 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-15-elver@google.com>
Subject: [PATCH v5 14/36] rcu: Support Clang's context analysis
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
X-Rspamd-Queue-Id: 40F181A001A
X-Rspamd-Server: rspam04
X-Stat-Signature: mmyix1k6f4hsk8paua6dffxqjrzjtw7d
X-HE-Tag: 1766159182-65653
X-HE-Meta: U2FsdGVkX1/iQjBTcGl/gMDeLyPXp9o1Jixc7v2Ebvts9xoUfvqX7Ldv40F6NphFEoqnlnyCmtcJNFLsZQi/ByTC4buQa96bkmi85imge2GGssi4JkyZ0FUxs/1lMb6s4iBqzWkcO1/h7MpWKAqpqDXZSrBgab2qaQg2vhoY2NJigI2Lx9P1cxwIUsP39j5Mn69tfuOmIKfyz+tRK9AMeO+aftvpRSR9KiRyAQG1eHeqetgC0djne976rGyGH6Z3F8jxauoiuH3Q4VJkaiE1s4tPGL4RlWK8+rzXJf+dZq2o2Xsa0lcFJbjc6HH42Np4LX0FHUt/cgiZqTnfMVpjE3ia2F2ssI7lAxg46FeXKVwrneHGPblfdwbf+d4U5KJi3ATcCLopusj/X6oIhBChne6us+tBG40rTRFQN5FmtVSzu9hpB4kzC/JPqybYE80hQrMsys4W08F3s5KSLCtv/2dvQrvVZn8lHOCTfXa5majYki2qpqUB3+1G7/tuyiDWlLWFRUGDGdwNqkhxKYetTKePzP8ZrTp1UDzUK7Ny+VN8cw0d37F/Fv8zEk7bKHyxuFTJQxzDT0v0NVmCPzTa9QgRP75phV6lWnV2sWbH5KcwOwmbgdqZ6Fylbz6s0kAViiy4GDhLfulekrQGZz2VC+6GK5qJmoV1xd0NBH0SnFX58zeKokuaOaFRXtD2kPSk71+YYOc9cWGoxiDhUEKrdvgLS1VF6iaMUilXCVyyfzVAsT53Z5NsSJdg2KABgiYOUbNIdkrUbr6am02U+nHeq96mpXXHOKDgBTB/LPPfuK+Lfk+AvtcpdgVCJvQmly2+FLBxfbfK48nPCYcMcfbn8oEZWlBaNRg5JgknaXNWRr+RDd8jMELEIsxgL5Avp7PgZGkZmWz480gAWubYd7QNhJeBlfCIF7sX5HHd1bpUCk53qQXrh9QVt3mQycaznrGlmTGKWb4+GF3eKwIDl6Q
 aU+4hfQq
 y6fp6+MjFiiCe1AYuMerlhDci8rpN3b4XS4aOAnGFWmtcI2UHeJlbIP45Ao90/ol2rbpeOkC6f9sj+231n0SSwnWiFlr7h4MAVNjnw8Jj3tUnjAkMrvBDAk5G8G2x5Io+3O2NNENQIR7P8VtShjhqwYVYZjr9iot0DHl5I0GBBeo8NoB3nPwwhXWreR2b74zyuzk99q9E3rG0L8bhaQDOceXyWb9L4RF0JCVpWejqyvra1YhF3rbKvDVSVkoYGvDx+5EEMs4l8ZzHeyGyXMotcqHIM4D5Qdq41nWzpfVZ91wGlN39JYSEOX7fTHF6Gt+AwEhZZ+AxU2Bf2+EI4ErPVl4JjVuAZLiWFzgZ2w+rplMfaudcGRntgDd/78Lp63wPkInkFLrYy7TIWCWMc4jSSb4n+uq0uB7HHmRud4NvuIGbvncVMjK8kIp0hcoaqZmhiiKt50byLoK0lUWckY6OfEO38dMzjhZNMphbFRz8UotsHP+OrPaFDmdAoenOvTXI4s35vJ1y16gNii1lA+TUbOPGOgqg70zSoWebnXEr8sbnTsvWAETUn1rfp1dLt1+eUsEXeRPNN2HjQy7qGPd3crzsyarvb/5THL1zAOLcY9+efbATbNeKhRVnMh9XoKdbrej6OaUVSt1HUoG8ZMsRQapusl55KO/jSWwCYLsnKjGgRm/OR4VIsQCM7oITFYmB8Hjz5haBK5/t7ajSB68BKPFj6w==
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

When (and if) we introduce context locks to denote more generally that
"IRQ", "BH", "PREEMPT" contexts are disabled, it would make sense to
acquire these instead of RCU_BH and RCU_SCHED respectively.

The above change also simplified introducing __guarded_by support, where
only the "RCU" context lock needs to be held: introduce __rcu_guarded,
where Clang's context analysis warns if a pointer is dereferenced
without any of the RCU locks held, or updated without the appropriate
helpers.

The primitives rcu_assign_pointer() and friends are wrapped with
context_unsafe(), which enforces using them to update RCU-protected
pointers marked with __rcu_guarded.

Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
---
v5:
* Rename "context guard" -> "context lock".

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
index b2d69fb4a884..3bc72f71fe25 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -80,7 +80,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`.
+`bit_spinlock`, RCU.
 
 For context locks with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c5b30054cd01..50e63eade019 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -31,6 +31,16 @@
 #include <asm/processor.h>
 #include <linux/context_tracking_irq.h>
 
+token_context_lock(RCU, __reentrant_ctx_lock);
+token_context_lock_instance(RCU, RCU_SCHED);
+token_context_lock_instance(RCU, RCU_BH);
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
+static inline bool lockdep_assert_rcu_helper(bool c, const struct __ctx_lock_RCU *ctx)
+	__assumes_shared_ctx_lock(RCU) __assumes_shared_ctx_lock(ctx)
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
+#define lockdep_assert_in_rcu_read_lock() __assume_shared_ctx_lock(RCU)
+#define lockdep_assert_in_rcu_read_lock_bh() __assume_shared_ctx_lock(RCU_BH)
+#define lockdep_assert_in_rcu_read_lock_sched() __assume_shared_ctx_lock(RCU_SCHED)
+#define lockdep_assert_in_rcu_reader() __assume_shared_ctx_lock(RCU)
 
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
+	((typeof(*p) __force __kernel *)(local))			\
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
index be0c5d462a48..559df32fb5f8 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -7,6 +7,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
+#include <linux/rcupdate.h>
 #include <linux/seqlock.h>
 #include <linux/spinlock.h>
 
@@ -284,3 +285,87 @@ static void __used test_bit_spin_lock(struct test_bit_spinlock_data *d)
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
2.52.0.322.g1dd061c0dc-goog


