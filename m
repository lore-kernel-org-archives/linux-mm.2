Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26CA0D7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B60F6B00B7; Fri, 19 Dec 2025 10:46:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873DA6B00B9; Fri, 19 Dec 2025 10:46:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CCAF6B00BA; Fri, 19 Dec 2025 10:46:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB376B00B7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:48 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 213851369ED
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:48 +0000 (UTC)
X-FDA: 84236648496.14.9FA41B9
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3E67614000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I6wYzsuD;
	spf=pass (imf26.hostedemail.com: domain of 3ZHNFaQUKCLEVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3ZHNFaQUKCLEVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8y2ehCZZyqeLeTmnnsrT76N1owOcsxeMFhfj7fOlbU=;
	b=K2haGV/RbGcc/KPmkByD75RTMrFsQJ94W5VALkG1I2ISLDXNSjlHDG8xl3Z1EBc/bgje2x
	ywn6sqYtp/ycderDPZ22ECSla0RAjSaNb96pWk+jiLzQmsVAhxTtOeWKeOEQwuzipk2flS
	N6IrHcsYe09+sQIxqzXTYHjLaggOBWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159206; a=rsa-sha256;
	cv=none;
	b=vBA3f27MEVFPJhLC6G9ioAjZiGvLRMfSJpYCqpn1aoyqSpmFdl75FgVSmlxSc0EdkXcdOH
	zXKTgzKQ/vq/rdyxsBdUCreGx+PL+n972IaDS7r2bzFotdZrKMpstFgb+VUYCdwAlCXgQM
	Aiu4ThnJFc7w38fHo66EmL/hr4BfXQ4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I6wYzsuD;
	spf=pass (imf26.hostedemail.com: domain of 3ZHNFaQUKCLEVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3ZHNFaQUKCLEVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430f5dcd4d3so1042309f8f.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159205; x=1766764005; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P8y2ehCZZyqeLeTmnnsrT76N1owOcsxeMFhfj7fOlbU=;
        b=I6wYzsuDyWhzYbQF0JAMFfWsXs+O19NpTgv/y+jWwfL6vgoJL57BhT2xolEIIzNLFB
         st76RsQiaQwejibOIi9Nmd4W4RCb92mPlHxjX8uE8Z21v3ObCQQ9PiUfbz6mwUqVl6dr
         mjvXo0jjvGFHwNp8Z6hMmV0BFwWMoPQdMBLuRv5QNAT3PTY/l1QJAxABDQefA8h9iAmR
         fXJr57SOph4+8ja4Q1OPFnlkUy2Zu3EQPdZzX/4BHPFEIPLzbKQ5/MsEHHJSXnACMaBy
         hdOWRb+QG4EzXjKEhHBDMvA3551F8blbjMhf9lrFHe5N8jYjG0TTcKyUSkJOVbEnEBNV
         5jsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159205; x=1766764005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P8y2ehCZZyqeLeTmnnsrT76N1owOcsxeMFhfj7fOlbU=;
        b=OhpegtLxcw/vNdJN4aPqrojXIVL79rUveNUDSeUuyFRfHZxLQlF+RXpB9PGQZPYr1Y
         8nGMApsbsddnshj2zVvQXT9dsVfiRT+YW99AD2Dgy6hT4Gu7fRc1E/Svw/OGHj52i3yU
         yHhdFkTm6yKncYPM4hyAXwA87MDSj+LEuAcRCsSw50X62mBffFW4Q/X7a6jpkdUDHg/p
         mkBd64x8xQ5T7xZeTmuCVHIaB1gzwt1SH4/K5PtG9m6h+zS0Jvm9GhlT5RCB426s4afl
         CLQ1VCn/rnz2xh0o8miWXd3jR8rsk4BG99JRvO7CjoVsurw+xDMrqkn+ULL7ZXwEUhD+
         tM8w==
X-Forwarded-Encrypted: i=1; AJvYcCURYSsHv0XoClBtgVPpIECKUK2v7SIGTZoD7I4/rLyS/4dS70hUdxXRP30rRAVB4xlUygZ2RWYzRQ==@kvack.org
X-Gm-Message-State: AOJu0Yxz+hchbskvl3NtJhk9X6JfZgFggoDW3sO+4dJS612M9mMqA6Iq
	5RISer9WqwQAQ94ruD/TVC0DG9YPqX7zTPGlVcMxR5vf38W+rHsPH9NIQUCkwlqah8ADQplBlS4
	W/g==
X-Google-Smtp-Source: AGHT+IFV9RFQsYqi1IuVNzQ0l+6NHAAORu/eNnm8e3NvFhH3K4ABTOt3R4xrfCUaQb2+inwZKUEY8Z2lVg==
X-Received: from wrbay2.prod.google.com ([2002:a5d:6f02:0:b0:430:f3bf:123f])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1789:b0:431:2ff:128f
 with SMTP id ffacd0b85a97d-4324e3ebfbbmr4354092f8f.6.1766159204463; Fri, 19
 Dec 2025 07:46:44 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:09 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-21-elver@google.com>
Subject: [PATCH v5 20/36] locking/ww_mutex: Support Clang's context analysis
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
X-Stat-Signature: d9kyrimj3ari5sc59wa6fhjxd1hxa153
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E67614000E
X-Rspam-User: 
X-HE-Tag: 1766159206-487049
X-HE-Meta: U2FsdGVkX1+KWZlQcT3hSsZICQv0D/W2xMCB5sqw9nx/u75smi1diP9WLJibcpZhoOSztHp3XsDYKTkUaZDzyKGB9yOdaIbpYWawhZFJ9Bc+/wUCP2U8FtVI8CDQvp5d15+LydllhoAWmmM+KDGKWcFnYtH9fOP3JFi3JKWvTNeWyv9Bf3PnQhJoWvK2Y7JLzQNb3H40Mw4UWHIetIeoj36KvzShQVifgsjh6aadfkQKontdVXEfYu2avrVCX5OfBzYERMUbwzZF23l2UyKY24C7/sOq0DE8ErrVcXZjHzoJZHlsOuSYgOUlQW7R37WIFuXDPWOFDm592SehKM+5UvHKavaBUCd08WYSnWOPWGnfx681/1XvHbtF1AJail9bGluVr/zLRXRpfW2eUkq0Nu/ICrlu4VwqYmUl3rh9ftP+M+SBI4lbldRCNCzQjRh4Hv5bQPNl0jcRx5x9iE+EW6jccU6rAnMqBZi5gh4Z2SzqKWPZjHvXNx72gXsoWUhTfrZPDnDN+poSWAw+loOrjeEoUiYkByq/F/lXkUMO3Du1VndovZ2ym/A4m9vmI82kuSAoMW79bDo2B7OMFNjWfPvrkVzEEySt1bu4WPsydHQmLYzTZ76dX8QCrewltW+AI3OMniY4xb6e3qztCdQ5+EhFx3kr1CbPR/bduZrKfGiLOegIomvMBI/KgtteyXCk1+HC5zGHW0evfoyhTUM5W2PbtSCB3g2HxMxTUUd3KQB6ItgqUppyBd0SkS/AnBrcUyCtywZunEIciKzY7yqMKLrqlekvsOMMhULQSYxluxs97nBziqqc0tPi5i/lYxhmOT2XyYhd3+fbGZh54tq/de1RsgIWpZMdlvQ4s2i7z4s1uuwPAcNSiJ4cPSoaPOvNMEp+933VFHuL0ZRnQzOXiAN5wWgd/ynczS2L5/Vh/b8si0njBxisAGjBwam7K8bdS0B3ns47i0S8ymW/Y70
 olno1WD5
 d+dM4UQcrkAzFWoTvJrIMTZ42+HSSK+QvhV3q90c7ufkwbvW5C+ZFa6fRfFd9Ns99nQvXLWh7dPrxXQPWPPwEYaLu4KHOnUH38geOixa5ZU6DPda/giPZTRNWnTv6B5/qgxSq5HfeP02ZSCNsj72KeLGJmH7ls42+rPr2Ju1x9Q3sODu4KyFLpD934+2Bzqr6JGgK6tTHjq+6tdQPCgYBHCj6Kib6sBRaqV4n5RXlbfCHLh6Olr8OuMzaRyzLo1TEJk6b3ZpABCtFOcobqQbAfjH+iznfvFF0WVTop8uwEKIppJHU+s6jQSbJyXK4nOLJ81194uJAt76pae7sG4fJSdK6pJK7BtGF7DS587+whK8Hocvc9+5CZW3oa9yDhsp7YQBV+cLQFKIC1hStbWdhVuW8ID7PXd5P14rjQI/PofWa8bcSwDZXefCPbHb4DnuvwjIBmdrG5c0pDwPmHP3WDxAFLwdXkBPh45/OnbORt6lfM+ZtUOPRtJD+MFhoJKZY0/bU01p7yp6hzZPCoWu2d8ufI/gTpeSn+cvzrFGyleW7+2sENlhNAO549dBwj4IPdq4cQ8WYQGbuS/uRc2FX8CZ5QcJ2VW150nT/8Ck6sZnGwR8I5NAXcyMra40Bq9cBUQALAtTHu1akGQ7Sc5Vl1DGmuP/PbYHeghZ9dgc2OLY+5+PFifdC53HoVvRNw6VrElVc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's context analysis for ww_mutex.

The programming model for ww_mutex is subtly more complex than other
locking primitives when using ww_acquire_ctx. Encoding the respective
pre-conditions for ww_mutex lock/unlock based on ww_acquire_ctx state
using Clang's context analysis makes incorrect use of the API harder.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".

v4:
* Rename capability -> context analysis.

v3:
* __assert -> __assume rename

v2:
* New patch.
---
 Documentation/dev-tools/context-analysis.rst |  3 +-
 include/linux/ww_mutex.h                     | 22 +++++--
 lib/test_context-analysis.c                  | 69 ++++++++++++++++++++
 3 files changed, 87 insertions(+), 7 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index a48b75f45e79..8dd6c0d695aa 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -80,7 +80,8 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`,
+`ww_mutex`.
 
 For context locks with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
index 45ff6f7a872b..58e959ee10e9 100644
--- a/include/linux/ww_mutex.h
+++ b/include/linux/ww_mutex.h
@@ -44,7 +44,7 @@ struct ww_class {
 	unsigned int is_wait_die;
 };
 
-struct ww_mutex {
+context_lock_struct(ww_mutex) {
 	struct WW_MUTEX_BASE base;
 	struct ww_acquire_ctx *ctx;
 #ifdef DEBUG_WW_MUTEXES
@@ -52,7 +52,7 @@ struct ww_mutex {
 #endif
 };
 
-struct ww_acquire_ctx {
+context_lock_struct(ww_acquire_ctx) {
 	struct task_struct *task;
 	unsigned long stamp;
 	unsigned int acquired;
@@ -107,6 +107,7 @@ struct ww_acquire_ctx {
  */
 static inline void ww_mutex_init(struct ww_mutex *lock,
 				 struct ww_class *ww_class)
+	__assumes_ctx_lock(lock)
 {
 	ww_mutex_base_init(&lock->base, ww_class->mutex_name, &ww_class->mutex_key);
 	lock->ctx = NULL;
@@ -141,6 +142,7 @@ static inline void ww_mutex_init(struct ww_mutex *lock,
  */
 static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
 				   struct ww_class *ww_class)
+	__acquires(ctx) __no_context_analysis
 {
 	ctx->task = current;
 	ctx->stamp = atomic_long_inc_return_relaxed(&ww_class->stamp);
@@ -179,6 +181,7 @@ static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
  * data structures.
  */
 static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
+	__releases(ctx) __acquires_shared(ctx) __no_context_analysis
 {
 #ifdef DEBUG_WW_MUTEXES
 	lockdep_assert_held(ctx);
@@ -196,6 +199,7 @@ static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
  * mutexes have been released with ww_mutex_unlock.
  */
 static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
+	__releases_shared(ctx) __no_context_analysis
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	mutex_release(&ctx->first_lock_dep_map, _THIS_IP_);
@@ -245,7 +249,8 @@ static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
  *
  * A mutex acquired with this function must be released with ww_mutex_unlock.
  */
-extern int /* __must_check */ ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx);
+extern int /* __must_check */ ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+	__cond_acquires(0, lock) __must_hold(ctx);
 
 /**
  * ww_mutex_lock_interruptible - acquire the w/w mutex, interruptible
@@ -278,7 +283,8 @@ extern int /* __must_check */ ww_mutex_lock(struct ww_mutex *lock, struct ww_acq
  * A mutex acquired with this function must be released with ww_mutex_unlock.
  */
 extern int __must_check ww_mutex_lock_interruptible(struct ww_mutex *lock,
-						    struct ww_acquire_ctx *ctx);
+						    struct ww_acquire_ctx *ctx)
+	__cond_acquires(0, lock) __must_hold(ctx);
 
 /**
  * ww_mutex_lock_slow - slowpath acquiring of the w/w mutex
@@ -305,6 +311,7 @@ extern int __must_check ww_mutex_lock_interruptible(struct ww_mutex *lock,
  */
 static inline void
 ww_mutex_lock_slow(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+	__acquires(lock) __must_hold(ctx) __no_context_analysis
 {
 	int ret;
 #ifdef DEBUG_WW_MUTEXES
@@ -342,6 +349,7 @@ ww_mutex_lock_slow(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 static inline int __must_check
 ww_mutex_lock_slow_interruptible(struct ww_mutex *lock,
 				 struct ww_acquire_ctx *ctx)
+	__cond_acquires(0, lock) __must_hold(ctx)
 {
 #ifdef DEBUG_WW_MUTEXES
 	DEBUG_LOCKS_WARN_ON(!ctx->contending_lock);
@@ -349,10 +357,11 @@ ww_mutex_lock_slow_interruptible(struct ww_mutex *lock,
 	return ww_mutex_lock_interruptible(lock, ctx);
 }
 
-extern void ww_mutex_unlock(struct ww_mutex *lock);
+extern void ww_mutex_unlock(struct ww_mutex *lock) __releases(lock);
 
 extern int __must_check ww_mutex_trylock(struct ww_mutex *lock,
-					 struct ww_acquire_ctx *ctx);
+					 struct ww_acquire_ctx *ctx)
+	__cond_acquires(true, lock) __must_hold(ctx);
 
 /***
  * ww_mutex_destroy - mark a w/w mutex unusable
@@ -363,6 +372,7 @@ extern int __must_check ww_mutex_trylock(struct ww_mutex *lock,
  * this function is called.
  */
 static inline void ww_mutex_destroy(struct ww_mutex *lock)
+	__must_not_hold(lock)
 {
 #ifndef CONFIG_PREEMPT_RT
 	mutex_destroy(&lock->base);
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 003e64cac540..2dc404456497 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -14,6 +14,7 @@
 #include <linux/seqlock.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
+#include <linux/ww_mutex.h>
 
 /*
  * Test that helper macros work as expected.
@@ -531,3 +532,71 @@ static void __used test_local_trylock(void)
 		local_unlock(&test_local_trylock_data.lock);
 	}
 }
+
+static DEFINE_WD_CLASS(ww_class);
+
+struct test_ww_mutex_data {
+	struct ww_mutex mtx;
+	int counter __guarded_by(&mtx);
+};
+
+static void __used test_ww_mutex_init(struct test_ww_mutex_data *d)
+{
+	ww_mutex_init(&d->mtx, &ww_class);
+	d->counter = 0;
+}
+
+static void __used test_ww_mutex_lock_noctx(struct test_ww_mutex_data *d)
+{
+	if (!ww_mutex_lock(&d->mtx, NULL)) {
+		d->counter++;
+		ww_mutex_unlock(&d->mtx);
+	}
+
+	if (!ww_mutex_lock_interruptible(&d->mtx, NULL)) {
+		d->counter++;
+		ww_mutex_unlock(&d->mtx);
+	}
+
+	if (ww_mutex_trylock(&d->mtx, NULL)) {
+		d->counter++;
+		ww_mutex_unlock(&d->mtx);
+	}
+
+	ww_mutex_lock_slow(&d->mtx, NULL);
+	d->counter++;
+	ww_mutex_unlock(&d->mtx);
+
+	ww_mutex_destroy(&d->mtx);
+}
+
+static void __used test_ww_mutex_lock_ctx(struct test_ww_mutex_data *d)
+{
+	struct ww_acquire_ctx ctx;
+
+	ww_acquire_init(&ctx, &ww_class);
+
+	if (!ww_mutex_lock(&d->mtx, &ctx)) {
+		d->counter++;
+		ww_mutex_unlock(&d->mtx);
+	}
+
+	if (!ww_mutex_lock_interruptible(&d->mtx, &ctx)) {
+		d->counter++;
+		ww_mutex_unlock(&d->mtx);
+	}
+
+	if (ww_mutex_trylock(&d->mtx, &ctx)) {
+		d->counter++;
+		ww_mutex_unlock(&d->mtx);
+	}
+
+	ww_mutex_lock_slow(&d->mtx, &ctx);
+	d->counter++;
+	ww_mutex_unlock(&d->mtx);
+
+	ww_acquire_done(&ctx);
+	ww_acquire_fini(&ctx);
+
+	ww_mutex_destroy(&d->mtx);
+}
-- 
2.52.0.322.g1dd061c0dc-goog


