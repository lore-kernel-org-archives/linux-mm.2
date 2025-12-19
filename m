Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78759D7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9B56B00B1; Fri, 19 Dec 2025 10:46:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5BD26B00B3; Fri, 19 Dec 2025 10:46:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF846B00B4; Fri, 19 Dec 2025 10:46:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A99D96B00B1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F0B8160288
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:36 +0000 (UTC)
X-FDA: 84236647992.10.E2D9F6A
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 785F5180004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZmEhI80G;
	spf=pass (imf16.hostedemail.com: domain of 3WHNFaQUKCKUJQaJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3WHNFaQUKCKUJQaJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91/M6Wc5goo40nrJkJ1ulkL+/DliPVncC/51mYdmaQ4=;
	b=EL/S/ku1nw88/Yqujvs+a8uVbs7JXVQKxp5vJVPi5s7w5cRp1QL/bIDJuGDeY1z1H2rDs6
	ww3uuU2iNzAXhqNstyJaFiGpAjlq0HEeMKgtZQReSkvUQcemFQZhlDgA2ukAoZjdelbYHT
	DSAKhxZM0Mz3AY0eC46egq0PbQk+iuA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZmEhI80G;
	spf=pass (imf16.hostedemail.com: domain of 3WHNFaQUKCKUJQaJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3WHNFaQUKCKUJQaJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159194; a=rsa-sha256;
	cv=none;
	b=BHDdvNROmlMXvBqmUKCYV7RmzshKbSnMdNAB9nToonUkhBsfZAWnN0qekQXaUA5kUcgkTy
	JNCOFaVUgCH+oJKO1GZKXV38UPJQFm8mPjHd4fDBHbP92pQy640IsfP+n7lWiCjPsMufVS
	s8I1cUgyWXPEWKSCydpha1xX1IVZvOw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47799717212so18621795e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159193; x=1766763993; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=91/M6Wc5goo40nrJkJ1ulkL+/DliPVncC/51mYdmaQ4=;
        b=ZmEhI80GDGo5aGzXySnmqHjsyfxasewhtBGJGyDyc4CdE5F95I23TShF5ctu3F0r1Q
         3Lx1hFv/rCuH/P9bf+ktka5+nGlmZYhPnYbIce7EonRj8z8mEsVOwVkSghyVT05PM+cw
         4aN1pXx6TcFfR6fhthWVIRjdnu0FPXwt775cZ+WVL7qNqq/S+e2fRZheO0943V1DZo/o
         Kf4OY7Z3EMNRiWaNr/iR9KzKHx0OTFvk26TS3r5lw8trjMxnawhP7Jh0D0+HlnHYqrtj
         W6ku0oW5W6qebF5AfrzEv+e7hVmj9SfvTeNrW/FkzWcg/vqSDgfePNr7iprQPyB4Jeex
         Dmyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159193; x=1766763993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=91/M6Wc5goo40nrJkJ1ulkL+/DliPVncC/51mYdmaQ4=;
        b=HfIa2RSSXNMSXPUghPMeIsDidincb++/94xb7hs6sp5Y09xsqZ4yYzqoJKTH/kCT12
         A1l9LBwq9M1qIQFRVpJEM5IZmmE5LLpJdpHSotTuglKILefRFk3Ytn8YhXCTq/VRcjvy
         SuFHjdMXvShGcR4cRYSb8dTYR6OsXLXJx3W3H00Il2pyZy+wkq7/NVShPgzTEpFEvsbW
         fo0qfGXo/nm2QVl9KKoajM0AaE+UrYype9FmYmODsbg2/CLZiNeOOnUcGMeuectMVjpt
         4I76SAiFpDmZFKz63GTf2CXF+sGajIN4GwUdbO0BVZ/cgx3kvqk6q2EH+StW9Tux4AAB
         DKmg==
X-Forwarded-Encrypted: i=1; AJvYcCVp95QD3OE9nioFnGaOglB0jySVaWmi1JM+aB+0VcecOW3LyHHzBxrJ+vi+49zYg0BJk/6WqKwMtg==@kvack.org
X-Gm-Message-State: AOJu0YxDPexzPvXgMK4giV6MfhQQ/Z1ExCNzBR7ZH6PEkhWu066Kn0Nn
	gflrc8oGnXlWY2TKfVDmzXmpHEDgCTDlg0HO6aH2JLFvKkZsWgkwREisD+5ziYalTurDrzRE+B4
	+gg==
X-Google-Smtp-Source: AGHT+IGE1LgxqdKnUpQTqh6OwtRuQIXkK6E2bbB3uOqTPKnnNib9O3sYIDs/w4CmKbE3kIU0DbcVhMnPBQ==
X-Received: from wmxb4-n2.prod.google.com ([2002:a05:600d:8444:20b0:477:5a4b:d57f])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c28:b0:45d:dc85:c009
 with SMTP id 5b1f17b1804b1-47d1954586amr32388785e9.10.1766159192865; Fri, 19
 Dec 2025 07:46:32 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:06 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-18-elver@google.com>
Subject: [PATCH v5 17/36] locking/rwsem: Support Clang's context analysis
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 785F5180004
X-Stat-Signature: 97dxynh1jpnfdpqf8b9mte8y1rdhymm3
X-Rspam-User: 
X-HE-Tag: 1766159194-703839
X-HE-Meta: U2FsdGVkX19pTkR4leV0sEIh9Df6JadWqanR3UIBtkgpBGoFYoplyZw3aJVNJe8uT0I2VfgPOHSixQZQoLHr0tLo+EImy9c2OnOIwUFvkZ3anzBqEQjpv9DbZmL4CXwEf1mQ1+RH4XogCVF0cPMxe01uic3CWPiKoKIPdsCH7X34LtWJfWMvLchHeRUonQ8CLMw4GjQ8SDXetyQot7jG1QKCeGoRlhZkjPiX2orcPElp9Jtg1vSJCeSLeAMhtyt2uUt0rO0hYLtqTfddDz5v8BYkCf4IhkQgq/pANcUromt6Bhd5bp1rlKUlecqRZZQHSEsWefaE+d3U8OqaRYgk/PEtDjaVKbNdJ4fZ/cKmgBakNvmYRhjXC38sB9FCWVhEC9u2iThHhUIgVqTjRhRfdIJWSYtiqAHaqlcxnH4lEGDAU2cWdoOEUbl4islkeO0EX2X9SveVQPjt8mCdbTOIX7/0QigY367blP6+d8yne41qNlUVgSeOViz1rg5mkv/CndDkFjJ24LTrr1MF1QzT/nIeC50KiSUifCHj5qAzI3nJYz/IlL7d2mRbUEyQLUpuYoW7wKLweluSmrNHYDrprcgqaIQiH/G8MB7yzlxfx1StZbgDy3LdGEj1G6sTnBhmoJzr1TJKDmkFu8YhenFf72C3+7RjbMFhawT//NOxpnZGFeSS/3+436DNMVM3PpurBdE4GK3+dRSKuoENRp0yPlSD/gUCOlusKq+cB6jFbxaaxd95X3hd7VnyBu0WaKYTYh0exM8c38j/QbqTppqnm/qMW784/+GB7snXmDr8WLINnu8KkPOeTh97V5xR+fFuxWTIdeWZzELQ3RUa/tY24SKPpdFtV1OAEAi0XU3+6cE7kP8QpTevMww033X9tYLe/dVJkGkJZY3R6lwI5ksGR3roeNtuYVgVFDz4bu+rGQvcVMv1TkHVz7Micnvb/tmMagxxx7N5hXEunbh2pOp
 x0lxiC38
 aDYzLhQhgmufrw7E2GeS0McEXyMkgbS67Hkp/kuLO8o5+mh05GFzuUeuzS0/eQR+aHzv+WJ5FYsGn8JY5AmcUCoilgsyDJjnjxLc5TAVL6H5NXOrlYdeg4XxkVrEFurh3FvDQEcUjyPYEEPtAInC5sMfTvRlAU3nxwfDSU0pM1/cUdHtop9o0aFoc8G1frkREQC+33A/4hnuO9ecJF8Is27p4fdpKSg3MX6QPoCi3iDOzVu4Buim0DHSNc/VbHe/xD2xRTL4GCH9rZRDouKRbtG5u+t2V/QIc6yGPz2iFY1RTJ8bn8Mp1CM8/qhN2Zy9csZ0SnP5xktIV/RCGpdWYiz6reEfj1FdNYHuBzZtxZbHvt7Kk8QIA/pymSC8fQBMUBkms5rhq1j3u0JS2U3QaLe0QQlfkXzGOBPBCPAVZe5pPn4XoFEJ/cs2TdSb2WjbyeYwIZGjycPJSC6EpPCrfZPrOPsU2bCSaKi4IRHuYQJHFHhkJ1nlq6rQ3GEFVRxK4GJ3I25/FB3KhR5333SfjMU2gbv/knW99Fsr3h8pSAUmZU3l2grPTXF4aT3NIHNcjd/bRezHc+Qu76oOPA0MsIxsqEp+zwVZfNaqr66lHoP7rq24h7FzBYzHtaiHzUltFvEUh9LFDNcd/CblZau84lJWZsJAmk9oRUA25
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's context analysis for rw_semaphore.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".
* Use new cleanup.h helpers to properly support scoped lock guards.

v4:
* Rename capability -> context analysis.

v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* __assert -> __assume rename
---
 Documentation/dev-tools/context-analysis.rst |  2 +-
 include/linux/rwsem.h                        | 76 +++++++++++++-------
 lib/test_context-analysis.c                  | 64 +++++++++++++++++
 3 files changed, 114 insertions(+), 28 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index f7736f1c0767..7b660c3003a0 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -80,7 +80,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU, SRCU (`srcu_struct`).
+`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`.
 
 For context locks with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index f1aaf676a874..8da14a08a4e1 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -45,7 +45,7 @@
  * reduce the chance that they will share the same cacheline causing
  * cacheline bouncing problem.
  */
-struct rw_semaphore {
+context_lock_struct(rw_semaphore) {
 	atomic_long_t count;
 	/*
 	 * Write owner or one of the read owners as well flags regarding
@@ -76,11 +76,13 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 }
 
 static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
+	__assumes_ctx_lock(sem)
 {
 	WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
 }
 
 static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
+	__assumes_ctx_lock(sem)
 {
 	WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
 }
@@ -119,6 +121,7 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	__init_rwsem((sem), #sem, &__key);			\
+	__assume_ctx_lock(sem);					\
 } while (0)
 
 /*
@@ -148,7 +151,7 @@ extern bool is_rwsem_reader_owned(struct rw_semaphore *sem);
 
 #include <linux/rwbase_rt.h>
 
-struct rw_semaphore {
+context_lock_struct(rw_semaphore) {
 	struct rwbase_rt	rwbase;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -172,6 +175,7 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	__init_rwsem((sem), #sem, &__key);			\
+	__assume_ctx_lock(sem);					\
 } while (0)
 
 static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
@@ -180,11 +184,13 @@ static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
 }
 
 static __always_inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
+	__assumes_ctx_lock(sem)
 {
 	WARN_ON(!rwsem_is_locked(sem));
 }
 
 static __always_inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
+	__assumes_ctx_lock(sem)
 {
 	WARN_ON(!rw_base_is_write_locked(&sem->rwbase));
 }
@@ -202,6 +208,7 @@ static __always_inline int rwsem_is_contended(struct rw_semaphore *sem)
  */
 
 static inline void rwsem_assert_held(const struct rw_semaphore *sem)
+	__assumes_ctx_lock(sem)
 {
 	if (IS_ENABLED(CONFIG_LOCKDEP))
 		lockdep_assert_held(sem);
@@ -210,6 +217,7 @@ static inline void rwsem_assert_held(const struct rw_semaphore *sem)
 }
 
 static inline void rwsem_assert_held_write(const struct rw_semaphore *sem)
+	__assumes_ctx_lock(sem)
 {
 	if (IS_ENABLED(CONFIG_LOCKDEP))
 		lockdep_assert_held_write(sem);
@@ -220,48 +228,62 @@ static inline void rwsem_assert_held_write(const struct rw_semaphore *sem)
 /*
  * lock for reading
  */
-extern void down_read(struct rw_semaphore *sem);
-extern int __must_check down_read_interruptible(struct rw_semaphore *sem);
-extern int __must_check down_read_killable(struct rw_semaphore *sem);
+extern void down_read(struct rw_semaphore *sem) __acquires_shared(sem);
+extern int __must_check down_read_interruptible(struct rw_semaphore *sem) __cond_acquires_shared(0, sem);
+extern int __must_check down_read_killable(struct rw_semaphore *sem) __cond_acquires_shared(0, sem);
 
 /*
  * trylock for reading -- returns 1 if successful, 0 if contention
  */
-extern int down_read_trylock(struct rw_semaphore *sem);
+extern int down_read_trylock(struct rw_semaphore *sem) __cond_acquires_shared(true, sem);
 
 /*
  * lock for writing
  */
-extern void down_write(struct rw_semaphore *sem);
-extern int __must_check down_write_killable(struct rw_semaphore *sem);
+extern void down_write(struct rw_semaphore *sem) __acquires(sem);
+extern int __must_check down_write_killable(struct rw_semaphore *sem) __cond_acquires(0, sem);
 
 /*
  * trylock for writing -- returns 1 if successful, 0 if contention
  */
-extern int down_write_trylock(struct rw_semaphore *sem);
+extern int down_write_trylock(struct rw_semaphore *sem) __cond_acquires(true, sem);
 
 /*
  * release a read lock
  */
-extern void up_read(struct rw_semaphore *sem);
+extern void up_read(struct rw_semaphore *sem) __releases_shared(sem);
 
 /*
  * release a write lock
  */
-extern void up_write(struct rw_semaphore *sem);
-
-DEFINE_GUARD(rwsem_read, struct rw_semaphore *, down_read(_T), up_read(_T))
-DEFINE_GUARD_COND(rwsem_read, _try, down_read_trylock(_T))
-DEFINE_GUARD_COND(rwsem_read, _intr, down_read_interruptible(_T), _RET == 0)
-
-DEFINE_GUARD(rwsem_write, struct rw_semaphore *, down_write(_T), up_write(_T))
-DEFINE_GUARD_COND(rwsem_write, _try, down_write_trylock(_T))
-DEFINE_GUARD_COND(rwsem_write, _kill, down_write_killable(_T), _RET == 0)
+extern void up_write(struct rw_semaphore *sem) __releases(sem);
+
+DEFINE_LOCK_GUARD_1(rwsem_read, struct rw_semaphore, down_read(_T->lock), up_read(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(rwsem_read, _try, down_read_trylock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(rwsem_read, _intr, down_read_interruptible(_T->lock), _RET == 0)
+
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_read, __acquires_shared(_T), __releases_shared(*(struct rw_semaphore **)_T))
+#define class_rwsem_read_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rwsem_read, _T)
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_read_try, __acquires_shared(_T), __releases_shared(*(struct rw_semaphore **)_T))
+#define class_rwsem_read_try_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rwsem_read_try, _T)
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_read_intr, __acquires_shared(_T), __releases_shared(*(struct rw_semaphore **)_T))
+#define class_rwsem_read_intr_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rwsem_read_intr, _T)
+
+DEFINE_LOCK_GUARD_1(rwsem_write, struct rw_semaphore, down_write(_T->lock), up_write(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(rwsem_write, _try, down_write_trylock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(rwsem_write, _kill, down_write_killable(_T->lock), _RET == 0)
+
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_write, __acquires(_T), __releases(*(struct rw_semaphore **)_T))
+#define class_rwsem_write_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rwsem_write, _T)
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_write_try, __acquires(_T), __releases(*(struct rw_semaphore **)_T))
+#define class_rwsem_write_try_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rwsem_write_try, _T)
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_write_kill, __acquires(_T), __releases(*(struct rw_semaphore **)_T))
+#define class_rwsem_write_kill_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rwsem_write_kill, _T)
 
 /*
  * downgrade write lock to read lock
  */
-extern void downgrade_write(struct rw_semaphore *sem);
+extern void downgrade_write(struct rw_semaphore *sem) __releases(sem) __acquires_shared(sem);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
@@ -277,11 +299,11 @@ extern void downgrade_write(struct rw_semaphore *sem);
  * lockdep_set_class() at lock initialization time.
  * See Documentation/locking/lockdep-design.rst for more details.)
  */
-extern void down_read_nested(struct rw_semaphore *sem, int subclass);
-extern int __must_check down_read_killable_nested(struct rw_semaphore *sem, int subclass);
-extern void down_write_nested(struct rw_semaphore *sem, int subclass);
-extern int down_write_killable_nested(struct rw_semaphore *sem, int subclass);
-extern void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest_lock);
+extern void down_read_nested(struct rw_semaphore *sem, int subclass) __acquires_shared(sem);
+extern int __must_check down_read_killable_nested(struct rw_semaphore *sem, int subclass) __cond_acquires_shared(0, sem);
+extern void down_write_nested(struct rw_semaphore *sem, int subclass) __acquires(sem);
+extern int down_write_killable_nested(struct rw_semaphore *sem, int subclass) __cond_acquires(0, sem);
+extern void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest_lock) __acquires(sem);
 
 # define down_write_nest_lock(sem, nest_lock)			\
 do {								\
@@ -295,8 +317,8 @@ do {								\
  * [ This API should be avoided as much as possible - the
  *   proper abstraction for this case is completions. ]
  */
-extern void down_read_non_owner(struct rw_semaphore *sem);
-extern void up_read_non_owner(struct rw_semaphore *sem);
+extern void down_read_non_owner(struct rw_semaphore *sem) __acquires_shared(sem);
+extern void up_read_non_owner(struct rw_semaphore *sem) __releases_shared(sem);
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
 # define down_read_killable_nested(sem, subclass)	down_read_killable(sem)
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 39e03790c0f6..1c96c56cf873 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -8,6 +8,7 @@
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/rwsem.h>
 #include <linux/seqlock.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
@@ -262,6 +263,69 @@ static void __used test_seqlock_scoped(struct test_seqlock_data *d)
 	}
 }
 
+struct test_rwsem_data {
+	struct rw_semaphore sem;
+	int counter __guarded_by(&sem);
+};
+
+static void __used test_rwsem_init(struct test_rwsem_data *d)
+{
+	init_rwsem(&d->sem);
+	d->counter = 0;
+}
+
+static void __used test_rwsem_reader(struct test_rwsem_data *d)
+{
+	down_read(&d->sem);
+	(void)d->counter;
+	up_read(&d->sem);
+
+	if (down_read_trylock(&d->sem)) {
+		(void)d->counter;
+		up_read(&d->sem);
+	}
+}
+
+static void __used test_rwsem_writer(struct test_rwsem_data *d)
+{
+	down_write(&d->sem);
+	d->counter++;
+	up_write(&d->sem);
+
+	down_write(&d->sem);
+	d->counter++;
+	downgrade_write(&d->sem);
+	(void)d->counter;
+	up_read(&d->sem);
+
+	if (down_write_trylock(&d->sem)) {
+		d->counter++;
+		up_write(&d->sem);
+	}
+}
+
+static void __used test_rwsem_assert(struct test_rwsem_data *d)
+{
+	rwsem_assert_held_nolockdep(&d->sem);
+	d->counter++;
+}
+
+static void __used test_rwsem_guard(struct test_rwsem_data *d)
+{
+	{ guard(rwsem_read)(&d->sem); (void)d->counter; }
+	{ guard(rwsem_write)(&d->sem); d->counter++; }
+}
+
+static void __used test_rwsem_cond_guard(struct test_rwsem_data *d)
+{
+	scoped_cond_guard(rwsem_read_try, return, &d->sem) {
+		(void)d->counter;
+	}
+	scoped_cond_guard(rwsem_write_try, return, &d->sem) {
+		d->counter++;
+	}
+}
+
 struct test_bit_spinlock_data {
 	unsigned long bits;
 	int counter __guarded_by(__bitlock(3, &bits));
-- 
2.52.0.322.g1dd061c0dc-goog


