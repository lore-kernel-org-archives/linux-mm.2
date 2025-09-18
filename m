Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 987C3CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ABF98E0127; Thu, 18 Sep 2025 10:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E448E0112; Thu, 18 Sep 2025 10:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1885F8E0127; Thu, 18 Sep 2025 10:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 026808E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:05:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C4BDF852DE
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:57 +0000 (UTC)
X-FDA: 83902544754.02.6E8C86A
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id E282D1C000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ggYxec0B;
	spf=pass (imf20.hostedemail.com: domain of 3whHMaAUKCGMFMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3whHMaAUKCGMFMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P08xa+RVj+NYVod6vjIgPrZ1iS5A/lHieiP5dR8CwWY=;
	b=uVVhzl2vZ52TH1FoSlS6/QgOrLiy+nrgaDDdoLP2nlQdhEiOoPE7AvNdxL8nK8VzP4tZ8s
	EqbVeCg8BvhAFdpHbxbb9WcAnnwp5riHM/zTyaogrt32qxdWtF/nKbz5wLmuLFSJ3hMr3x
	XEVGE92rwP4BJ+prU4oL/ZpvbmeqAGg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ggYxec0B;
	spf=pass (imf20.hostedemail.com: domain of 3whHMaAUKCGMFMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3whHMaAUKCGMFMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204356; a=rsa-sha256;
	cv=none;
	b=0dkRovQ583zWBdqnwXIjtpCD4bXYdyguYQLtfiouJ/qfqB/rTx/XNlbMKkDQ1BnTOrX6/K
	TxvRoo5x3GrVL/uQV7ORTOtqSroiE24abVyfEBjXLt0hy3VtOkv1utMKKVwQMqumiRj+fi
	iK2LiceDC9ndCt7Qk3jv7psGllBVYcg=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b04145e8615so155976866b.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204354; x=1758809154; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P08xa+RVj+NYVod6vjIgPrZ1iS5A/lHieiP5dR8CwWY=;
        b=ggYxec0BSp9LSM8rn2XwLypa1BvyMZkujN7EdSIbKlEpz51od2CNMBzXbo3Tc5iPVx
         NNejyGoxTxlHREmTjXoSJBQO+TeMvefApBkwrCstdy+H5qYLVScd+DC71z4j6L87zPiV
         7Xsn5VQFP58Srh0IClZdsMu/M4V27BPSKOGCzprv9GRII/z3emepDBO19BreySOwZxy8
         6Wckts9fWC96s9iqVe4iVZ/ufefRVzpLxScI4wCXMB7U1G+L7Sc2cJYmAs/qyQbJBB5k
         OMLSCQepURUVswkz7o0Ixi3y9c722uRdtBj+Ei6iJa2vjyN+8xiEwgjV+QDjsysQSrRz
         brBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204354; x=1758809154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P08xa+RVj+NYVod6vjIgPrZ1iS5A/lHieiP5dR8CwWY=;
        b=QeXL0zbdPxp3Rrzcq103TbQ7+ziZKYTbDtqrKtYQiMTxXcYCB7FBE5rSdjnyaWom6s
         BXu3cnWL7nDP2KGT8heeNKnOaE394SBFaq5GoeCAIuKiGs82X4QBgFTcfeyC0LpPSkRn
         MPdYw3AZUKdaEefFbT5kKKscXGX8RvzVQEHQpRy9+t5pfEcqoBUSgf3qU9QWQxlUoX9/
         AAk0Rw+d8QqRtqE5pZ+YKCYzmbZ5yI8h34pr6mlyZz/6S0OZVLfV5CC4+yek226Wz2nN
         U9rSsE6wtlOMHaflA8e/A+Y+RtjKtSMA/bfWn/5yrGzT/WRi+m96XNUb5JgFKNwxN0IA
         hywg==
X-Forwarded-Encrypted: i=1; AJvYcCU9ytqeFIt9QM8kfQ89dCtwRegCTQzX9O/46tbjMsh+QxjhgepZwkMYI3UFj3WwEniX4eFphvP5jQ==@kvack.org
X-Gm-Message-State: AOJu0Ywsg68X1f7awi+++Zn6xf0GB1UDP9Q2tNyZd5PMJ92Seq56Fj4K
	rZdY6HhoMy9ExNaE7Iu0XDhkaXcImAs68tp72zINee9LeDBBrk0fFNvcTJtrHYoWgko1iCQUVLJ
	Erw==
X-Google-Smtp-Source: AGHT+IHZ+a3x7r6KdORv5r4v9wd2gkoHcaTmO7cGwNrZRZhrY55/kmzK7UzQjJUKer1HTJFogryCh2DgMQ==
X-Received: from ejctp26.prod.google.com ([2002:a17:907:c49a:b0:b0d:2e46:f67])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6e8d:b0:b0d:5e0d:eaa4
 with SMTP id a640c23a62f3a-b1bba003769mr678528666b.16.1758204354138; Thu, 18
 Sep 2025 07:05:54 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:21 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-11-elver@google.com>
Subject: [PATCH v3 10/35] locking/mutex: Support Clang's capability analysis
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
X-Stat-Signature: xgsphzygpr87uq344du8z5jurpfaqc5k
X-Rspam-User: 
X-Rspamd-Queue-Id: E282D1C000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1758204355-1933
X-HE-Meta: U2FsdGVkX1/+ZBwmiJbwQ+4ZdciEkr1c0Ad1fgGDj1JN6BkKcI8fchP5MspnB04Dh+KF1EihiuT6cR1WgMRM6WIRbuEIKsiRKQyJcC4bLkMiBe/UuIrJREt5Vgb8MN/oL2yL2TEfrTL54ayjX0VWbdmmGXRF7D845y3aV3KdRmVfh7lek/MPhQlGUAM2Xj5JFsw5ZjPZ99ne26GgTh+f4YQm+RxkuxzYr6t3nwsEG+PtbWeKJUTg+KtiAobUb2N0A5TZxMsdFp7LxOJJ7Lfj7+lYzuBd7IpGUsl6OrrriPbjCwATE2nDuhktuoVR0qfPYXY9VrNaB6Gi/oIeNjrKFLccJBgrRDs7Bj51BXCrKPSsqfksCaHIifD9QQKnF3fZKzGq62nCoU5zu+o7BkwKuZRWCnE+xuz/Uxac7EvIRbBMWHAIguYXcpTDIxuhtlyXJsqVT3ugQizk8vB7r5cQOpC80yGGfdD0XM5AGw6ggdaTqmJPc0xpC9bpUUUDIhuHS/vrcOjOYJs6igDHeE+VjdXtRWTq0fewGBOfdYvzcjKdGUKykYiculcay2W2YtHKCZbgj5LIa8oRztaudowvrtmQhjsYQLGH0777UMevR98QlrsUDLaPUDwwumGqsOXbCC2wieLgLOLh0Dz1u1yaPPHXgg48l6CigvMYkNuOK9oX0Ep4HG1yu5jm+GsSlRI8XwzuGfDJSQG1GLM+CrfLmX1ahrTH9YBFXRd2EdKXwAJ1uv/vlc/MLh5GOEE+A+XKwQeJ5Vitkn4FV7CBsg/PKyNtVjEK+xf8uJe3AG2WC0ZKFYNQUSvcqHY3ciiOWineu0lpy3ke+yPkK8tD6X+lNQnCHqJEdCTnPePM9CS7wFiv6+fVlcMtuTRe5GjQrXD/nwjPOhE7WmmVP+b6+IkmKrKOmMz04+0NL7UTSHhyQ2EJWgqWIQX8WlrSvPEWErnXkwDFL41A27vs8Ub9Loz
 HK/tGCSp
 FYQ+lqR+LQWc+eEgQcgX3aXJoO47wB97nhs54py3mTdtlckplNUpRIwLlf51H2lXarFvX1cHKdFa6si471pd8CMp7VUQ3tKdRI/fttLt/GhCek2Vlpk0DXTimfH0Y8xpYrWrhOURCH/cYXArv3UJ93xLkHyaW3w0VUR4a5WEtI7koc57f6HIA6z0ZWELkLKShiQ4MRsTf7a97QBoEDk1EHhxO4Fus4j2BLKfiVafUPdIciV7ahnl+TkK0d/nzhMZZVWbh52iZxZWyjfs71Mv/03YoabwnDs7SYwWJanTSnhllz0NEhkGaLuMzjRLDuzcA+TaFyRW1Apex9NZCM6v465yrQ/abSeEquOAz+oW+UBsD1ZjFGtNXuuYrIrEYy2/jeaf/5iR1+FiPsYRB/tVSPOtmo3yVWgrz4PyPiOjEzLYuKLTHlJq/kNs7u6t7XDQEmSQt974wJ5rAU0D8HaU2/AgURNrhQLDV+HJHwsgheuS2E5nBIgdVGvbkr62xLtxwfZWE49KCNM4ZcgFJnYEIXQSkMLUENfwbSRrMc9KFgGC2Xk3gDN9mciqbo1tvfUwz2NqZi650e8HO0vycXdyjDLjg++JNj4NGSI+5+Ev0DlxnvY3FFdWUmWk97YellTcMa9a5YcREPoQFrCs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's capability analysis for mutex.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* __assert -> __assume rename
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/mutex.h                         | 35 +++++-----
 include/linux/mutex_types.h                   |  4 +-
 lib/test_capability-analysis.c                | 64 +++++++++++++++++++
 4 files changed, 87 insertions(+), 18 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 9abd7f62cf4e..89f9c991f7cf 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -81,7 +81,7 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 847b81ca6436..7e4eb778d269 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -62,6 +62,7 @@ do {									\
 	static struct lock_class_key __key;				\
 									\
 	__mutex_init((mutex), #mutex, &__key);				\
+	__assume_cap(mutex);						\
 } while (0)
 
 /**
@@ -157,13 +158,13 @@ static inline int __must_check __devm_mutex_init(struct device *dev, struct mute
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
@@ -186,10 +187,10 @@ do {									\
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
@@ -207,7 +208,7 @@ extern void mutex_lock_io(struct mutex *lock);
  */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
+extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock) __cond_acquires(true, lock);
 
 #define mutex_trylock_nest_lock(lock, nest_lock)		\
 (								\
@@ -217,17 +218,21 @@ extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest
 
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
+DECLARE_LOCK_GUARD_1_ATTRS(mutex, __assumes_cap(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_try, __assumes_cap(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_intr, __assumes_cap(_T), /* */)
 
 extern unsigned long mutex_get_owner(struct mutex *lock);
 
diff --git a/include/linux/mutex_types.h b/include/linux/mutex_types.h
index fdf7f515fde8..e1a5ea12d53c 100644
--- a/include/linux/mutex_types.h
+++ b/include/linux/mutex_types.h
@@ -38,7 +38,7 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-struct mutex {
+struct_with_capability(mutex) {
 	atomic_long_t		owner;
 	raw_spinlock_t		wait_lock;
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
@@ -59,7 +59,7 @@ struct mutex {
  */
 #include <linux/rtmutex.h>
 
-struct mutex {
+struct_with_capability(mutex) {
 	struct rt_mutex_base	rtmutex;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 84060bace61d..286723b47328 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
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
2.51.0.384.g4c02a37b29-goog


