Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFDA2CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4207D8E012E; Thu, 18 Sep 2025 10:06:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D27C8E0112; Thu, 18 Sep 2025 10:06:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299908E012E; Thu, 18 Sep 2025 10:06:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 194038E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7F57C01B5
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:16 +0000 (UTC)
X-FDA: 83902545552.23.FCD2087
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 02EB440006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K217kPU6;
	spf=pass (imf04.hostedemail.com: domain of 31RHMaAUKCHYYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=31RHMaAUKCHYYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCChN5JBLfNZD2oPUgHX86ngAxvuyY3UmlRN7HFHi28=;
	b=jHxOyEIDC+3BSnbcPaktKLCcYw+YTlkVDor6eU+nPLSo9KiCkQ7t1JBBbbchxFVv2qnXAC
	GTsqDwC2G/o/RhDVM7jbszrBHfvdAcuU4D6wirmMZJMm75xoYAIAlKMKQer4srTSr+L5v4
	3eR1wQuezBTgWV2OF2Eas0JVmgnEYZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204375; a=rsa-sha256;
	cv=none;
	b=QiddaBRXeZfUpwO7jEy/liaWtynGpODmA+Or0SbOvth8sUlKUWZSD0VofDWroKPlaKAAn0
	ishUwx3zkOBK+Q3Cn/MR8Bf+w5GglSE5/JSs17Sqb+9YB+GJUjHxIIRtuaQaiNFQUha/Zs
	XNMgvvJkVBkp37IKFznBG59cbaMeccE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K217kPU6;
	spf=pass (imf04.hostedemail.com: domain of 31RHMaAUKCHYYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=31RHMaAUKCHYYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45cb604427fso6365945e9.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204373; x=1758809173; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MCChN5JBLfNZD2oPUgHX86ngAxvuyY3UmlRN7HFHi28=;
        b=K217kPU6aBvWdUM7JmuPauH219US9sfpqwYoWaj5YAS14zrFXQxdGe4AjrXbG01tb9
         Ho8/r8GzHEprIra/vB8ewoXKTZ8XcXRWE3Kg19oGeCkWXEFSuJNol6Og/uU0UjcHH+8d
         xq7+LTTvVLSa1z4B+nt1xjFNIqM+id5ThbnzOWaAS5TsOowqFkA+LzhT9rDUiIai+xIP
         x0tIdaNcD2DI2qIHA+pTb+MxvOpx0muJ2RGyDeD/VEkwz1G+sjkzgwtRM74aoDUI3VBJ
         Tfh8iydlBdI4F+MgoN9mMOhN/CIkEi/sJXOz9oqp1KW6yhS9dZIjPqQja/xccCPmSg9a
         cOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204373; x=1758809173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MCChN5JBLfNZD2oPUgHX86ngAxvuyY3UmlRN7HFHi28=;
        b=Jo3HbLib75ekZl0qJngQLLTdzkrT8x1TbqaP0EMu9wSS/ovjar9jhmPkBA/MCE5x0P
         n9xRf2YKjEQL8UakWCUH1UsAsD+9zkZSKEt/ZDiQC35mQ2C/wYJDcqADryjTO799ceDU
         OYj7ga4hhvF4enjTu3rxGq0sIk9DsLJHh5n618S/p9E7eIHMs9Gcu2K0ubGZK/6qosWr
         sFBf9W5Chfrl/mqE0Lv5cVfBDk/83fT6xG/LOkrvgBIL79cGnD6U1NMhDq83DrLwoFDA
         8sqKwnIe5canF4xrCdgqXTSzWKTwwb0Y4tMJUFalZ5dhAefaf3hbZSvFsUt/mRfsbISp
         md/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUc0JB6qyxMOXp+MZTnGS4igyuXajezPyh1AZtfnaaYf3DeR5Hr83xEhXan3dJ74ovtpBLElbeEZQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+gcP4kYbNyGHppIDglCfRQlPzwO2PrDvknnUEp0bAEl1lOSB7
	2RhB6sTc0MGR6qqcyP1yLDod8gXs8VY3T9HsuJGYt15kRUL3xHpZK7OLUTcpTVSkVX9hTTt2ONK
	BdA==
X-Google-Smtp-Source: AGHT+IFywd4jmUzTfq+hVJgQHHlmO5wjtm30W/ijPajLEYScbPyp1aDSfv2uSoivAjyNaLs8ORl1XcY9lg==
X-Received: from wmth19.prod.google.com ([2002:a05:600c:8b73:b0:45f:28ed:6e20])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:548f:b0:45f:2c7c:c1ed
 with SMTP id 5b1f17b1804b1-46201f8b0f7mr54930115e9.2.1758204373378; Thu, 18
 Sep 2025 07:06:13 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:28 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-18-elver@google.com>
Subject: [PATCH v3 17/35] locking/rwsem: Support Clang's capability analysis
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
X-Rspamd-Queue-Id: 02EB440006
X-Stat-Signature: ih17qooj6qsujccmkkyz7p5hrrszatpw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758204374-353088
X-HE-Meta: U2FsdGVkX1+kuMXqS59TbGnZ+wvnWPbqTdiPojLb3e6gshUM6guS60IDFCOiZO0AeshAyb81XkEe7S1Uy8DWuZN43WUDhooLVbYXuSNZc8wAjEHTU8zT7b6wlSZaSOXTTvUOf8711hS4Tp6G4g6xbHzh67M7rz+Sl2zjNaRmVBC7iDyZq2ADtfeSkElNKjsdD7TTJPuFo2Cn27kAGSOiU1z0Hhpk9cvCgFsEcc/PyBkJtGjIwMn9CRp4bbfpm8w/+GRNNxtVVE7noJar8Fy+DEX4Z1wXWfxs/KLW4cOmDAYifg4hmLNr4V4VsMmvzZ6L9R+3X0RsKIbkmMflz/b3wBuEOWrir3mRUEJAzRnjQF4/QRGBAz3JNIC9Z7d0l+OP5XF6y8dF+fSVdpgM2H65MdlmVxiefETGyqtwZgZo+CCWAUuMWXAo9RElhnxaXFSL8jGZxhDfV7q1H2NATXpHftQYLhVKxJwH3xDoPlZnQoFpxaLXCztOvXUmmO8d3UQe0WoF3Hx2i1gI4weZyioYhjRCh/f+YRf5r94y376opJB1K65rdB4JzxxXBwM2JjjMA7b8FKfiQZAAgPrT3+GKxjztfcbclsB/qMQ5Sp0jRUigO49YKEiJbOXTiVVP52RCtp/jgMdwi/mzR6WTrt4eKEhyIWdbN6YG66ec58PaEehaUkWQ8QeFkM9kMSG1W+x3aXRfCxa9ZXioFGJbegICaX3PuiEtstHYK+aDQOAQirJREwbEQaPVwFxeCe9WeS+A9658SqalF3oVc68HW4PK78ywVd3NcwtGkXUghIeSxxZUuGfQqmWjUV378VO5juLsI0U0XvSMUSAeBoGJ5PBUoW5EQmahentgllUD+Fu+QXqOPt/MDz/SHwnnbqD3j3ykCBaUwWT7VIJs0yxu81ak8/TdF/yyD6/s/Hv16s9z3HKVMP9CRIu0i/lMRlaaFd3Fu0KtjLaUMI646++1bGO
 NBc/sqB7
 Yq7xImFOYpf/z9U5QLk1oMAHu+83Ne57vELdYEJ0PCtOcfUbnWatijhUV2+VhC5lEBwCfiwbVG6aUoo07cLR1m+UPFsWv4OlaaZmk06R0uar1qFN6qjntuGGtgye5lbM4Wb6skdLr1LX+nib6kHkJlxt+14zz2PhbahMnY6MEzWp2j71wjiszpG4mKxJqAsfeztftO6xv/FInxrxTXyb3pozVcPWq3sm7fvOS1wgw+GSmTxvhtw5uzS4D4N98diZGhjqjWrXjaQmZJ2/XkUm3tq5ohMzJrs0NWZ0pbJt7nFpnNZhZ667XRLXAbmAZeP+HqQ27RumyfXjPBa54Vch0WcvMx+KuUw9Fb+Mgn+BR3GDl7QYedyZaSk+8qR9QCJPBur1q/r99WYOYeSNCeG8znH4X2EmV1G37lCV/SoMHz4YW8mwIDmAViVs7qWfYMQctlvzPXnpQR967DnbuhyKfrKz9agXyaj7/seRR0/yB4DLhiqpIO70ctGwR7tvheWchBbq7IvCKore9vHfgz60IFNhhBQoK117dMWB4NN8MLzTZyK+gef3UNVAb/8BHL3FQAMp1QFG4KUXaAFphQQ5eKOSuRdxTAxgaVFnl46PWF9G416QbaNaGk6oEgBMW79DzLlEVpNi5SgJOFh4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's capability analysis for rw_semaphore.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* __assert -> __assume rename
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/rwsem.h                         | 66 ++++++++++++-------
 lib/test_capability-analysis.c                | 64 ++++++++++++++++++
 3 files changed, 106 insertions(+), 26 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 779ecb5ec17a..7a4c2238c910 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -82,7 +82,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU, SRCU (`srcu_struct`).
+`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index f1aaf676a874..d2bce28be68b 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -45,7 +45,7 @@
  * reduce the chance that they will share the same cacheline causing
  * cacheline bouncing problem.
  */
-struct rw_semaphore {
+struct_with_capability(rw_semaphore) {
 	atomic_long_t count;
 	/*
 	 * Write owner or one of the read owners as well flags regarding
@@ -76,11 +76,13 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 }
 
 static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
+	__assumes_cap(sem)
 {
 	WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
 }
 
 static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
+	__assumes_cap(sem)
 {
 	WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
 }
@@ -119,6 +121,7 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	__init_rwsem((sem), #sem, &__key);			\
+	__assume_cap(sem);					\
 } while (0)
 
 /*
@@ -148,7 +151,7 @@ extern bool is_rwsem_reader_owned(struct rw_semaphore *sem);
 
 #include <linux/rwbase_rt.h>
 
-struct rw_semaphore {
+struct_with_capability(rw_semaphore) {
 	struct rwbase_rt	rwbase;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -172,6 +175,7 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	__init_rwsem((sem), #sem, &__key);			\
+	__assume_cap(sem);					\
 } while (0)
 
 static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
@@ -180,11 +184,13 @@ static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
 }
 
 static __always_inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
+	__assumes_cap(sem)
 {
 	WARN_ON(!rwsem_is_locked(sem));
 }
 
 static __always_inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
+	__assumes_cap(sem)
 {
 	WARN_ON(!rw_base_is_write_locked(&sem->rwbase));
 }
@@ -202,6 +208,7 @@ static __always_inline int rwsem_is_contended(struct rw_semaphore *sem)
  */
 
 static inline void rwsem_assert_held(const struct rw_semaphore *sem)
+	__assumes_cap(sem)
 {
 	if (IS_ENABLED(CONFIG_LOCKDEP))
 		lockdep_assert_held(sem);
@@ -210,6 +217,7 @@ static inline void rwsem_assert_held(const struct rw_semaphore *sem)
 }
 
 static inline void rwsem_assert_held_write(const struct rw_semaphore *sem)
+	__assumes_cap(sem)
 {
 	if (IS_ENABLED(CONFIG_LOCKDEP))
 		lockdep_assert_held_write(sem);
@@ -220,48 +228,56 @@ static inline void rwsem_assert_held_write(const struct rw_semaphore *sem)
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
+extern void up_write(struct rw_semaphore *sem) __releases(sem);
 
-DEFINE_GUARD(rwsem_read, struct rw_semaphore *, down_read(_T), up_read(_T))
-DEFINE_GUARD_COND(rwsem_read, _try, down_read_trylock(_T))
-DEFINE_GUARD_COND(rwsem_read, _intr, down_read_interruptible(_T), _RET == 0)
+DEFINE_LOCK_GUARD_1(rwsem_read, struct rw_semaphore, down_read(_T->lock), up_read(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(rwsem_read, _try, down_read_trylock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(rwsem_read, _intr, down_read_interruptible(_T->lock), _RET == 0)
 
-DEFINE_GUARD(rwsem_write, struct rw_semaphore *, down_write(_T), up_write(_T))
-DEFINE_GUARD_COND(rwsem_write, _try, down_write_trylock(_T))
-DEFINE_GUARD_COND(rwsem_write, _kill, down_write_killable(_T), _RET == 0)
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_read, __assumes_cap(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_read_try, __assumes_cap(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_read_intr, __assumes_cap(_T), /* */)
+
+DEFINE_LOCK_GUARD_1(rwsem_write, struct rw_semaphore, down_write(_T->lock), up_write(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(rwsem_write, _try, down_write_trylock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(rwsem_write, _kill, down_write_killable(_T->lock), _RET == 0)
+
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_write, __assumes_cap(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_write_try, __assumes_cap(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_write_kill, __assumes_cap(_T), /* */)
 
 /*
  * downgrade write lock to read lock
  */
-extern void downgrade_write(struct rw_semaphore *sem);
+extern void downgrade_write(struct rw_semaphore *sem) __releases(sem) __acquires_shared(sem);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
@@ -277,11 +293,11 @@ extern void downgrade_write(struct rw_semaphore *sem);
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
@@ -295,8 +311,8 @@ do {								\
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
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 5b17fd94f31e..3c6dad0ba065 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -8,6 +8,7 @@
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/rwsem.h>
 #include <linux/seqlock.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
@@ -255,6 +256,69 @@ static void __used test_seqlock_writer(struct test_seqlock_data *d)
 	write_sequnlock_irqrestore(&d->sl, flags);
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
2.51.0.384.g4c02a37b29-goog


