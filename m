Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA537D7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DDEA6B008C; Fri, 19 Dec 2025 10:46:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 183D46B00A1; Fri, 19 Dec 2025 10:46:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 082B06B00A2; Fri, 19 Dec 2025 10:46:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB6716B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 90C511A0137
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:08 +0000 (UTC)
X-FDA: 84236646816.26.84AECC3
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id B42FC80009
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KowspxuR;
	spf=pass (imf02.hostedemail.com: domain of 3PXNFaQUKCIosz9s5u22uzs.q20zw18B-00y9oqy.25u@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3PXNFaQUKCIosz9s5u22uzs.q20zw18B-00y9oqy.25u@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159166; a=rsa-sha256;
	cv=none;
	b=OL6MNdIP8gPynLortT1bXlybno1jrbPr4dr2j0kGj/seIGhluysTZXjFEVPKJOD/gippXs
	yNBeGRFtnX9MAc3DV+yoZtsDJy94jDqqJMPaHbmM+7OQURRY9NrPSW1w8w31pU7G0PaEyd
	Onp8dmaGzn3tCmEkw3wUp2X3WTEywlY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KowspxuR;
	spf=pass (imf02.hostedemail.com: domain of 3PXNFaQUKCIosz9s5u22uzs.q20zw18B-00y9oqy.25u@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3PXNFaQUKCIosz9s5u22uzs.q20zw18B-00y9oqy.25u@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nto1KcJJjiv3QrSNF53pqHLj6j420z7Hf2YMAu356w=;
	b=EFwmZcgU71mG3rrWG3oLGSJ2aY6YFsEXOVCGUkH5JOvhWha7BndRsOwi/tgJ/3+Ccn9rQ5
	mxw1dSLuO4+1Ty30IDs7priEo8VlWtVGjDNY1vWBjoRa4s6ZziUSNY4jl4gbfAc7Agj1BT
	vEG+H+IbSBYF+3E4EAo4Wj9YPeYyP0M=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47d17fff653so4522345e9.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159165; x=1766763965; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2nto1KcJJjiv3QrSNF53pqHLj6j420z7Hf2YMAu356w=;
        b=KowspxuR8NqCKmrcwvHi5Z+V/g8hIF1447zw+fcfXjbM//qyJOVKnBMsGgD5QdiCvO
         Dp5cfIR1QLUP3tRgpanp3ksWBuECcH9EIjZAf/b2N6i1z9A7+zkhYd0Q0ooh0UE3x+P3
         7tVRUVeZxCy0nqmTnFy47gNXD9e5bmPuxqhHQhd6jhJ+EX3WhyFlZ6abox4Q3lDdTXqp
         6EPTD2Ixhys+vSnSkBvA6iuqPaF107lB4ljjIHc1t9TrGuwLaYB3oemYzSRvPrbRidX3
         3wdUbq1d5kqZzI/hPJl1EjU2IQTlgkT5ct0strGlEuG7djNRecHFWRT5vM875GGBliWZ
         03LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159165; x=1766763965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2nto1KcJJjiv3QrSNF53pqHLj6j420z7Hf2YMAu356w=;
        b=WRVEQ9c48IwYlgloCGMrd74OtcUoxrd2VN2KSNSoHgiOfylS28Pm/ChP5Bzzv9uv23
         SMwGNKeIEaYTG0uPMfjY8Wcaq/aB2lRnCpO8MztHrGM2P7WEU7RcPrWjxqoja0z8xyxZ
         U0nyuXL+hvaNMMHqdgqcx7wvbnaCEfHlFKtNdT2EnJY66m7KPhzKH7oYEd4LT+Hhf85F
         bgf/BULNodhrs4F/9QxdQTzyNtbG3PLV2KxBtRg2LwXAKK93M8NniuaegMCQ6cDKxVkq
         /qUX7JKQil7BQz2mdlShc5P7D4H29brOizSqHWM+y04UbwSCGj29utZzexl+AgEfoFHJ
         thWw==
X-Forwarded-Encrypted: i=1; AJvYcCXSbDLT5gWEOzMqxOEyoZiXxh4/wdzgAMPVGQPkvOzbKYmuMDnySiIg+Mg1CEr3E7NArli639o3hA==@kvack.org
X-Gm-Message-State: AOJu0YzKOaViiyr1qjOhFp61QQ6NxVC6nOpGrA0nYmPo6eo2wiA53F7Q
	wLmdTdP5MUVB4LSx6Gx5Y+PC2Ez9UwK6wNFBIlRTn33zMes/vUx8rv7/WB/5Ctk5llHa4hdn3Dd
	BsA==
X-Google-Smtp-Source: AGHT+IEI4FtTU2uBJwILA8/Yh0TJDO/NsIIewDaTcKmzVNBr5My/fTSLrYYgL2OtjmIxbmTe6FcaJZZhgQ==
X-Received: from wmby2.prod.google.com ([2002:a05:600c:c042:b0:477:165e:7e2a])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ecd:b0:477:1bb6:17e5
 with SMTP id 5b1f17b1804b1-47d19593e32mr28466615e9.30.1766159165093; Fri, 19
 Dec 2025 07:46:05 -0800 (PST)
Date: Fri, 19 Dec 2025 16:39:59 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-11-elver@google.com>
Subject: [PATCH v5 10/36] locking/mutex: Support Clang's context analysis
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
X-Rspamd-Queue-Id: B42FC80009
X-Rspamd-Server: rspam04
X-Stat-Signature: nx4t8xkot8e9u3yzc98x79eo6n7qsdbb
X-HE-Tag: 1766159166-335237
X-HE-Meta: U2FsdGVkX1+xklkdehQYH3NZvoHUvsK/O2lajwMKVUwWcnSyiA3ptf+SaOWwsZ+EJvReEyzYjkilQ96LgYc5+p/D8woDsXr/UuFnSY73H7HM7PDDq8sHT9WwtJnen8yQAYGlA+aR3CwmxJUyHhEcB1eBWgdMD13Knz5uP2qKYvtVJgjBoMdf0Ntq+ZZhZvQAYRrV3DsZ0h0Cg6yege4ocIShM/XrQhPqHS9X5z0Fv52wSuL4eKZqwWeqkGDGPNkgRKbQaaRTA5bnFqep3vkI/Cc9S5h63dgyHAxMk/9pMLciVHlFB5hDPWYCq3uzuJFwyYj0kTY/2Hq8pYqsr0DBo6IggBJgwdM5owJN7n99Znz5ZRzArnjsUfsDEioATQUmxv5Nf2ikryCtq/0kFfjRLnB7TXNTjib0SQq4HWLPV1IPYhbVqT0J5z3jXVSQhES1glF0pF1dRYApJr1UOcqcvfBcocDK7BENGNoEX/WGg1fLH20MX8AqZ6fHAicYO6MyKFle2EjGVWHvJLfxQZG+LLHuVu4q4jk4uv4I/Cr1Fzr/t3F5uPXN215F6drPGPqENnpOZq0zFFhWK/RVBtSw/4ZsH3L11pMprt2gQ2kz0fO5AusZzY1uXQw8fFCvlPV4P7o9ODVYyc4vtKi94iLo9BFA7nm+pjnQmB3gBJTx1eJuDKT+GENCwmH46YyymqV7IpCyaVJSZWQQSSfXkEF0sJKOxfmfYfLrCXjx0l0VObCzrMXJ5Z9EPHIGLgqIp7dQ4zfA15/kguDIBwhB20wJ6sOETkQ3g2tCpK3sdZfxTXbqizNGxB2P5nIE5AfPBrVn6GB/IaHArqlXOO/lHoPs+n2h/wZosnPvhPICQ92pppGDxznzHjXvfmorl00V6/f6YICzi0KO7Qfhz+webfOBslZGFBao2jTbOlF+ZAynEJhvGUupTRa/gcvRkKPhoEcucmCn4x9MagODkakelAy
 brRMiPPv
 EbClr2I7esGr5zthYcRmlzFn0GH9B4GZcQFqkAeJdC2I5Ly8tAqFE6nLlBws/2EfPbNsMR2vF6wMzliG/bo17oecXX0CNL53i5DrzQ7yim1TuasezfE7J8uRLXFScjU784dNNzTAbac/GbnzF+unxYzZRIep75n2JtMJ335EiNT32CGuIU/i42MbiKLEc4J46Ty3+6asHn3tONhPyomsLBq39/BX2wgwstf95Jganu8Umr2/+7zvxteien91kFXadLNfqg50Tg+CCz0IsGsr3GtkzmiBOmEfpJDnYtlpqbYXmYBOkzhr5PB6mXp9RZDbaWv8xQ4lFSiAz8AJp0CHJn3aWsd41YdDk3W6sTSSQgRsAlN8M49FaG0b2OWytt7FUCC+udDq4+XtuoX5GV2RB6zmfqy+9HVdPEYtV5uxih0AHPbhX5JiYDLRm7sn48MCpOLsRxwr6rw7Qa02WiZcpPr27FmQM3UxmG0+Ei70wo+Nrsm/aY/uxQmQ78bMaAUlXZkr1q9E9vlBfuRCpRLe30BljdZdhRKGU2fN/csW+M821WdrcUk5DT6WdEXhZdJl58HaZ9J+PxWVsHQ8gxjtKmvY3XtikSBR1wxNqUJaHzmvcfUEX5DY0SoCKoyJxh87UTtoEs92HjXrL1+07TSvCJLNmedSzTFsoJCVPZtIMTNh4I7Q05PWJhyQXBtd3DMQ2j1gq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's context analysis for mutex.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".

v4:
* Rename capability -> context analysis.

v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* __assert -> __assume rename
---
 Documentation/dev-tools/context-analysis.rst |  2 +-
 include/linux/mutex.h                        | 38 +++++++-----
 include/linux/mutex_types.h                  |  4 +-
 lib/test_context-analysis.c                  | 64 ++++++++++++++++++++
 4 files changed, 90 insertions(+), 18 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index 746a2d275fb2..1864b6cba4d1 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -79,7 +79,7 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`.
 
 For context locks with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index bf535f0118bb..89977c215cbd 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -62,6 +62,7 @@ do {									\
 	static struct lock_class_key __key;				\
 									\
 	__mutex_init((mutex), #mutex, &__key);				\
+	__assume_ctx_lock(mutex);					\
 } while (0)
 
 /**
@@ -182,13 +183,13 @@ static inline int __must_check __devm_mutex_init(struct device *dev, struct mute
  * Also see Documentation/locking/mutex-design.rst.
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
+extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass) __acquires(lock);
 extern void _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
-					unsigned int subclass);
+					unsigned int subclass) __cond_acquires(0, lock);
 extern int __must_check _mutex_lock_killable(struct mutex *lock,
-		unsigned int subclass, struct lockdep_map *nest_lock);
-extern void mutex_lock_io_nested(struct mutex *lock, unsigned int subclass);
+		unsigned int subclass, struct lockdep_map *nest_lock) __cond_acquires(0, lock);
+extern void mutex_lock_io_nested(struct mutex *lock, unsigned int subclass) __acquires(lock);
 
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
@@ -211,10 +212,10 @@ do {									\
 	_mutex_lock_killable(lock, subclass, NULL)
 
 #else
-extern void mutex_lock(struct mutex *lock);
-extern int __must_check mutex_lock_interruptible(struct mutex *lock);
-extern int __must_check mutex_lock_killable(struct mutex *lock);
-extern void mutex_lock_io(struct mutex *lock);
+extern void mutex_lock(struct mutex *lock) __acquires(lock);
+extern int __must_check mutex_lock_interruptible(struct mutex *lock) __cond_acquires(0, lock);
+extern int __must_check mutex_lock_killable(struct mutex *lock) __cond_acquires(0, lock);
+extern void mutex_lock_io(struct mutex *lock) __acquires(lock);
 
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
@@ -232,7 +233,7 @@ extern void mutex_lock_io(struct mutex *lock);
  */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
+extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock) __cond_acquires(true, lock);
 
 #define mutex_trylock_nest_lock(lock, nest_lock)		\
 (								\
@@ -242,17 +243,24 @@ extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest
 
 #define mutex_trylock(lock) _mutex_trylock_nest_lock(lock, NULL)
 #else
-extern int mutex_trylock(struct mutex *lock);
+extern int mutex_trylock(struct mutex *lock) __cond_acquires(true, lock);
 #define mutex_trylock_nest_lock(lock, nest_lock) mutex_trylock(lock)
 #endif
 
-extern void mutex_unlock(struct mutex *lock);
+extern void mutex_unlock(struct mutex *lock) __releases(lock);
 
-extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
+extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock) __cond_acquires(true, lock);
 
-DEFINE_GUARD(mutex, struct mutex *, mutex_lock(_T), mutex_unlock(_T))
-DEFINE_GUARD_COND(mutex, _try, mutex_trylock(_T))
-DEFINE_GUARD_COND(mutex, _intr, mutex_lock_interruptible(_T), _RET == 0)
+DEFINE_LOCK_GUARD_1(mutex, struct mutex, mutex_lock(_T->lock), mutex_unlock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(mutex, _try, mutex_trylock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(mutex, _intr, mutex_lock_interruptible(_T->lock), _RET == 0)
+
+DECLARE_LOCK_GUARD_1_ATTRS(mutex,	__acquires(_T), __releases(*(struct mutex **)_T))
+#define class_mutex_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex, _T)
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_try,	__acquires(_T), __releases(*(struct mutex **)_T))
+#define class_mutex_try_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex_try, _T)
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_intr,	__acquires(_T), __releases(*(struct mutex **)_T))
+#define class_mutex_intr_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex_intr, _T)
 
 extern unsigned long mutex_get_owner(struct mutex *lock);
 
diff --git a/include/linux/mutex_types.h b/include/linux/mutex_types.h
index fdf7f515fde8..80975935ec48 100644
--- a/include/linux/mutex_types.h
+++ b/include/linux/mutex_types.h
@@ -38,7 +38,7 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-struct mutex {
+context_lock_struct(mutex) {
 	atomic_long_t		owner;
 	raw_spinlock_t		wait_lock;
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
@@ -59,7 +59,7 @@ struct mutex {
  */
 #include <linux/rtmutex.h>
 
-struct mutex {
+context_lock_struct(mutex) {
 	struct rt_mutex_base	rtmutex;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 273fa9d34657..2b28d20c5f51 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/build_bug.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 
 /*
@@ -144,3 +145,66 @@ TEST_SPINLOCK_COMMON(read_lock,
 		     read_unlock,
 		     read_trylock,
 		     TEST_OP_RO);
+
+struct test_mutex_data {
+	struct mutex mtx;
+	int counter __guarded_by(&mtx);
+};
+
+static void __used test_mutex_init(struct test_mutex_data *d)
+{
+	mutex_init(&d->mtx);
+	d->counter = 0;
+}
+
+static void __used test_mutex_lock(struct test_mutex_data *d)
+{
+	mutex_lock(&d->mtx);
+	d->counter++;
+	mutex_unlock(&d->mtx);
+	mutex_lock_io(&d->mtx);
+	d->counter++;
+	mutex_unlock(&d->mtx);
+}
+
+static void __used test_mutex_trylock(struct test_mutex_data *d, atomic_t *a)
+{
+	if (!mutex_lock_interruptible(&d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+	if (!mutex_lock_killable(&d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+	if (mutex_trylock(&d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+	if (atomic_dec_and_mutex_lock(a, &d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+}
+
+static void __used test_mutex_assert(struct test_mutex_data *d)
+{
+	lockdep_assert_held(&d->mtx);
+	d->counter++;
+}
+
+static void __used test_mutex_guard(struct test_mutex_data *d)
+{
+	guard(mutex)(&d->mtx);
+	d->counter++;
+}
+
+static void __used test_mutex_cond_guard(struct test_mutex_data *d)
+{
+	scoped_cond_guard(mutex_try, return, &d->mtx) {
+		d->counter++;
+	}
+	scoped_cond_guard(mutex_intr, return, &d->mtx) {
+		d->counter++;
+	}
+}
-- 
2.52.0.322.g1dd061c0dc-goog


