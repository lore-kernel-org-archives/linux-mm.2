Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34537CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5906B00BF; Thu, 20 Nov 2025 10:13:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD2A6B00C1; Thu, 20 Nov 2025 10:13:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3046B00C2; Thu, 20 Nov 2025 10:13:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB946B00BF
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:12 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F98A12C6C9
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:12 +0000 (UTC)
X-FDA: 84131328624.17.4D3D41E
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 23A14140016
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UL0x+FP8;
	spf=pass (imf23.hostedemail.com: domain of 3BDAfaQUKCDERYiReTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3BDAfaQUKCDERYiReTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkmPbZNSmdMyreEK/bsAoZcLQrwuNTqttZsMG2m8BsQ=;
	b=HOoqwj0V6BVYzXMjJlQuC+WO0bG6639+P6ZgDxF36Ay2SX/6fZttBOA/YPEL+azz4uB5z3
	5H/M+tDs0jM1q31tUC5gbduj/g6riwfhcv97W0k2VCBWn36lsrZjcAHwrgeorUI2AKxrze
	EfwKUHIEHuPz4ohhS7ul5I/cHVpMehY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651590; a=rsa-sha256;
	cv=none;
	b=Ap+fJxr9SBqzmYM+x5HbU6vdci2Q9TpwxVmgSMjYO4XA+VstnonVzhoAMaqX5ekHd48N73
	muLGJvyrBkjQXFvOMKEQmsd7/TlOHiYUMM5Uf80Te8jsTQuQeeVRg1l+6LeVRG1VKskb2P
	lFAqgSQ6DBgg+/2TSzzdPCb5VV9q5co=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UL0x+FP8;
	spf=pass (imf23.hostedemail.com: domain of 3BDAfaQUKCDERYiReTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3BDAfaQUKCDERYiReTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47754e6bddbso6990245e9.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651589; x=1764256389; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dkmPbZNSmdMyreEK/bsAoZcLQrwuNTqttZsMG2m8BsQ=;
        b=UL0x+FP8DfoPfUBB2Z7aR7TkP+E2CsYMxJ46YLwIjtj9RZx1NGmRq+Zzq5iyENxn6t
         gRnC4MRStEA5iaxdDGfcGdlkgh6vsErgEc4r36ZSHY9iiXl4MqneLFYIUqF8tiR9B4Ux
         CGFJzEfg0l8dLyFZSowvoKsMwRvceq1/uJ6x6CU3LclP7nidRnCSus4gtyFIHYwo89G1
         vehDBaypTkTdGTo544bR0115MJ988iBNBqHRzjtvOVk3vERrAfe3SVgp4aOyIe+YGBVS
         8NAn0n31ryHXrlGpewNzfQRt5J2UPf8MSFsXf6SEFUk8G1BwnzVAGKabt+ufeD+9qom7
         627g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651589; x=1764256389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dkmPbZNSmdMyreEK/bsAoZcLQrwuNTqttZsMG2m8BsQ=;
        b=COgxkieEyxGgNbfbFJ5Xm1Th9AO3lUFWy8uQ80N1SphJFdqhWO6Fm0npenk9AF/6L2
         SbM4W/X0jIc8p+K+LIF3Gcjv/Hg44OEdeT5MWGVMH70OhU31dEa0InxuSST07yuH+HQQ
         XgDPR91rPc4yHShTWH3ZC806skvWSZBmsNF7qvS0bpXOI9Ka+fBEXXkZwGTU6jw3wdEP
         8gzxVpNEX/ZpPbto0meES1k117eukfQU+GrihaDFCC/GPs5gw2cKpFYqjvwA+SBiPS3/
         MvS3xtuBP1ZaXqLg+oOZsYttO8Ez5JSqwHmJPBmi1P4EXauuIXRWQ7U0O170SweddhcY
         al8A==
X-Forwarded-Encrypted: i=1; AJvYcCU9em/GP9V8LqYkJOoJmxFyKzKoSmkdxFBYzsULuk68d7pmuN24AgqQjr02dhq12D1DmQXUlG3rYw==@kvack.org
X-Gm-Message-State: AOJu0YwJ528ToNErSBZJAOGaRu9gzFDlZFReirc6b74ZPNl3ikXYwE3F
	Og+sUkBzgUPaUUv7k7jGf5jq9kXAIr58xsEoQPrJLbnkSZpRlw3DgN1SyoN4mbxSZGn9lnnoIp+
	5rg==
X-Google-Smtp-Source: AGHT+IGjVSl0FdI0t6xZXRZ+yy/GRkabtVizenWIxxXTwOEj/5OduqGLfCIaX9FytZisvT/Qka2tQFBDyw==
X-Received: from wmbbd8.prod.google.com ([2002:a05:600c:1f08:b0:470:fd92:351d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1987:b0:45d:d97c:236c
 with SMTP id 5b1f17b1804b1-477b8a8a5damr33381975e9.21.1763651588400; Thu, 20
 Nov 2025 07:13:08 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:45 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-21-elver@google.com>
Subject: [PATCH v4 20/35] locking/ww_mutex: Support Clang's context analysis
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 23A14140016
X-Stat-Signature: n46th8y8kjs56h6fpaicwp87yxf5t6rf
X-HE-Tag: 1763651589-470634
X-HE-Meta: U2FsdGVkX1/O01m0C+vxeviXIDNVqi4Rgo+hOjwL/iZR/rqGcqsyXBpeddy24qeKgjYStnvOTFGaf2NCzYM9hRgJXgsA+bQw1l7YVpxtAMS0UsGIj1Q8yqm6ORkhLPB+2Lq/7wnEJ0GDus8uvCzXy/xB70pr9nalaK1bcZpSu9aR6XUPOWjqqZC6p3+639QXrd+5ETPkuCzeyHrJ0XICWk32Wq7CC5mC4lkssm6Z+0B0P0bYWpKLE9qgTP/KbXlymLQ0epC0+Tie2wVFaNPEs/vt63yOODIl2XFIhQ0S/2AF7UF3ubxUHgtj6hFQuCWRRrTmIhlh2NiBaNosWTTR8eqW7RoAyjyAu4+NqDr3i2qMCbZwtqSfH3UMfL+EHiZpImOIhMt9RUJ5M0eKu6Ji5PWObXudtLnlSgY3E3cl8uPKIzLiAn1IfeWJowR/OWl4gRHJ0SB5z38bqEonRI2ogY6mNuky2tNh0cG3vf1Cwdzf6H2I95Ih+JiZXfDF5TA3ecw7C8U4oN5QgSzEjLpaROGKkK+jhAgLxueotDj1wRlOjl9rIN6psdFreR90RL6a+c1HcqSOrd8V/cNebf7kfJw1LqgoynzHwGIgJ8XUG3Eu7BVoxk5inG2+a6HdimrjhB1TIWUkEVfoL57ryeLgQdQDXxsxNP6M/Qzc1vbIYiUHlt+bj8NbvPBoma90gY9Eomr0MOYvLPdfr+1pfH4bfisXyJyLc9SoNjWKFaWwmUM8MzsKI/ve2tLlLfCO1ZuxKV0PM9yRjNEerONQZMTj7rg0wyW4ud74dskxtrVp/QG0ka3DH/Jd3iWNncBlMkt9cSQtsUFc6oOuQCc9vyno7SfmBjS3cT2SVrHq+JaIrpqlzWpHRrKQouhCCR/aTqqvUM17fmimtmN6Yw7tNBQVY//8EEP9rAzXxWwd9Fd1R+hwbQvHkHLGNz7JwluqvDsukmMl2K8Fkz5+pZk3Qi9
 vfNby1b+
 uD0oQL4uB6XrIHvxIgNnhEwE5d4nKISO1kshLATvhyP9TMRduLLQPAmebCqJUH8N46LzLfJ/v7kzm/AQ5eBoomndOd7f0NjjZA/Nn/B1105ukBBX4+hNyYDLKMU7UoW7JJSU0ebEJxIAP/qxhExkn/QsIiUwYEW4wKR2gGyFiWCwarqsNojZEbCCXDssaQBpN5mNUP0Lk423oFm/fEK0z3sJXlj+joUatrb1opwb057dJVYu8/tj2KOMOZoqQHoYpiBfFY/bj111wJdVW2lVf8kaBXjYRA/4uxgfUR8jP5U2gyZaWDG51s7J0thsQORdnTcYDNyjICF8dYavQho+3avxT7qOqTnp/GmxqHaV2LafKIeC1TvIvuM4kqV26OaIq7F2JCn/GF0glsuwdc8YyWYbmLoxZB84KZCecKCXnTs0TMXcdLOshwEFTSsft+BLftI5Xxe59euhnUrKioUoRcVWUWulokLHa/MsLQOF7tV7HlPN0JZGuhQZsMhxHocMuMPw/SotpwF4VcSDZ4IgJpjqrjoXSNq2tAF7Drx93khER/s//4JjoepCMrJ6/3Jc4DCD+cgJdCyaUyMfN4yljlQNdKxgn0nDC5j+yBTCdQFT9Q40gD9w3vDln1WGkGcsjBc3gy5x0HotALd3QFrNq4ZQ/in1dsku0nWayQ6UEn76a/R191fwTp9kAAkYror6teEsm5p7neJ94X2u0ldAFjXqbop5ecHxuUwqwqxW+hreL+dayhMTZlTkCQo8qW64g53dc1hzpgJMgeRKGCGDHFoFrDA==
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
index 8737de63a707..2936666651f3 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -81,7 +81,8 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`,
+`ww_mutex`.
 
 For context guards with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
index 45ff6f7a872b..f6253e8ba9af 100644
--- a/include/linux/ww_mutex.h
+++ b/include/linux/ww_mutex.h
@@ -44,7 +44,7 @@ struct ww_class {
 	unsigned int is_wait_die;
 };
 
-struct ww_mutex {
+context_guard_struct(ww_mutex) {
 	struct WW_MUTEX_BASE base;
 	struct ww_acquire_ctx *ctx;
 #ifdef DEBUG_WW_MUTEXES
@@ -52,7 +52,7 @@ struct ww_mutex {
 #endif
 };
 
-struct ww_acquire_ctx {
+context_guard_struct(ww_acquire_ctx) {
 	struct task_struct *task;
 	unsigned long stamp;
 	unsigned int acquired;
@@ -107,6 +107,7 @@ struct ww_acquire_ctx {
  */
 static inline void ww_mutex_init(struct ww_mutex *lock,
 				 struct ww_class *ww_class)
+	__assumes_ctx_guard(lock)
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
index 74eca21f7aaa..522769c9586d 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -14,6 +14,7 @@
 #include <linux/seqlock.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
+#include <linux/ww_mutex.h>
 
 /*
  * Test that helper macros work as expected.
@@ -523,3 +524,71 @@ static void __used test_local_trylock(void)
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
2.52.0.rc1.455.g30608eb744-goog


