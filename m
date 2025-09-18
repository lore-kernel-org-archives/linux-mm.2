Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F7ECAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CE608E0131; Thu, 18 Sep 2025 10:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557D38E0112; Thu, 18 Sep 2025 10:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4483D8E0131; Thu, 18 Sep 2025 10:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3678E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E53D7139AFF
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:24 +0000 (UTC)
X-FDA: 83902545888.29.A393F5C
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id C051220019
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wP+UW0ki;
	spf=pass (imf03.hostedemail.com: domain of 33RHMaAUKCH4gnxgtiqqing.eqonkpwz-oomxcem.qti@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33RHMaAUKCH4gnxgtiqqing.eqonkpwz-oomxcem.qti@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELhsFQQQ03C4hLdoxnucw/8+AkmAKW9zLdfFvUdcDbU=;
	b=lX2s8/FbgCI1dB7g1qJN0g6doT3zVNkRCbpqaj1i8g3J3cSOvAJrZeozvNJKeWP9qZOzOO
	K03j5bHxQ+CFNrQndUDQ2WqAs1wmy/FCfxrxMZr5OBgC+L5P00DSaXOovlEmnhYAbkoL5y
	IM8+yYUWelQgH2JnfJ63wbNOQHKF4Ac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204383; a=rsa-sha256;
	cv=none;
	b=KCTwz9ke2jewdt8Ofeyj1qyRNgEpOdr18ljbuPcPYPCFHSd4WeLjJBjJePBhlvgEFlR9QU
	55resRTEjGZn5vVjqL3MSJFX9jxUsu0yggR0QsVh0Ivq1LaoD/MsZCDhqh0wZmCYMx1QAb
	JfDp6MLAM0kPvpM28xcCG2u8Ymehr6E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wP+UW0ki;
	spf=pass (imf03.hostedemail.com: domain of 33RHMaAUKCH4gnxgtiqqing.eqonkpwz-oomxcem.qti@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33RHMaAUKCH4gnxgtiqqing.eqonkpwz-oomxcem.qti@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45f2c41c819so6664445e9.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204381; x=1758809181; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ELhsFQQQ03C4hLdoxnucw/8+AkmAKW9zLdfFvUdcDbU=;
        b=wP+UW0kidlaU3h8ywH1WiLugdI+AQLj5w/CxC+Rftdc+r+vRv7CSzKn0c59OMuMhUl
         QXoGvC1I7/zGWub0zBJfB4VbhBaGiVsOeAgCBk53KTsrspXDGQznsGJnxCmbguJ4HQMQ
         X6Iyxak9I428LkwWWNzdDVgOG26W5WPSaFZtMAd879BZOcgdv56kIFFzto36bTj9iaGX
         kdnsokprvO0PLlF0JOqg3OO4uw4I7dEpa4rLwf1MQqy2QLrqGbmm4dC/ZhohhT2CboOZ
         Q7GkmJVHxCKWtjRAhvMvMG6E/o7DSaCQuClxpdVxcI5P/OcZ4OTSBCLnqBNJ/MzqyBUH
         zITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204381; x=1758809181;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ELhsFQQQ03C4hLdoxnucw/8+AkmAKW9zLdfFvUdcDbU=;
        b=wBXpeagSGjzWAaImH5Ga99SjVqvDOxK9rt4ECZubC8nksuuwNoAT4VJARP5I5XtCEc
         uhReIqK8kGM12eO2DPNzt5twwVJZW/X2Jyy2jILWtLHd6N1Lj0uk/gJ//ZkvEjtBiiMh
         H5NohcuMukyNG9Rx5lu4FB9+CfNnAacdkO8d8/1uEjfALxjOLbpnqT1yU+Z4tbz7KNk6
         gNJqbJQdgKX1mUundEgu7m0mEemxEKx6idQOJjy/eO98pARBdxPzlvzOYp9EhnUJ+M7D
         t9+fMIR73kBratj9SNSo3UuoC/eYtLNCPgU4QnGENr6UzfWW2m7uTfMjc95ferK/MP6A
         2ffw==
X-Forwarded-Encrypted: i=1; AJvYcCVvb0qZBnrzzA8OD6HlGfnzidX+UJODInHYr2bGtsxQf3zh2SzZdGM7MfMKd8NrND36lcIVwFzslQ==@kvack.org
X-Gm-Message-State: AOJu0YxF3v9Ds83JL76qqOi0AAaUshlKR81qVAvk+QOp7X3psXyUW6CY
	kLBFErwkf/gCgVbmMr6XLVkrrD1YQWgVpYFonsOn049TwKMMRWlhDLbteWq+bu4McYqz8NMIJpV
	ZPA==
X-Google-Smtp-Source: AGHT+IHcd1Qh8kOAFxc/2t8MroiNimpccwG9uYdP8O4l5R/dxiF/pFNNICl8HtyF7NtKGjMQxkNUnXtHWQ==
X-Received: from wmbbi7.prod.google.com ([2002:a05:600c:3d87:b0:45d:d522:48a9])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:2a93:b0:462:cd41:c2f8
 with SMTP id 5b1f17b1804b1-464c6761397mr28424195e9.5.1758204381270; Thu, 18
 Sep 2025 07:06:21 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:31 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-21-elver@google.com>
Subject: [PATCH v3 20/35] locking/ww_mutex: Support Clang's capability analysis
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
X-Stat-Signature: yib47igq3yhnz1m5id9fxu7niyejy77h
X-Rspamd-Queue-Id: C051220019
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758204382-404018
X-HE-Meta: U2FsdGVkX19AAq9TnyScE70ctDVYn28GAzmxbbdnEokPjyLXJmnTYikxblgG1m01H+HYlkJlwjw6mmg/PuEc4YCqoNCxMFvNMTn40uJd15BhzorerC2GMl1SK9x0ZAyuL3mv52eSiVDNJ/xT/Tj1q0BRkyGHoX2vY0kA2YFTK9bYNwg+J+noYTeFkmScU8+7aB9xQegcCu7NIGL7Qr16yT8mmVIBL/O9p9ya3FRazeNcXtA3qR8wh9MMe+4BNolxXO7zQCRvM6ZwqatHRq3KVyTxyXG+Dpg5voLqMmkS0RLgB0pUTWZOt6i8aojCPNjyFJVvXGEM2NnlI/uHMMhJNWg7Xz7IOj/b5+OYCflhzvgLa33FhO4wJWx9bcqlDCWbCNLOPSMJuv2JLP0fEDr0vioBb4Nq7g8b+7hnfCRFEQFMGKa9Kxe8cmzWkVYSDsVRNWfDF6iqYBlTEB2wXWoWDGkGgUxXq82PcBmSSjG8VLVUdtHOaShCU3frI+Sy0vCN1KtggpEhoJV8bGHaERTv08ffTD6PzQtEK2R2KAaB4NKkc6FzZ3yasBrDYtpDAu3XJTELZNPaMw7GuSKKDyvoCjQTD8PVx7vgktcNUUBKU/+dS+8uHVxrHDPPlhwmG7qKKAvgiPSqWnfQtlF2MMJ3Kmd765DHhtUZ7kvCde4kWIm/Eyuj0Sstvn6EI7/0WDUUYTiHz8sPnPOGdFazfl56mG89egLS0Vzypb+XboSOtlA56tp3sEiXJmizZ08tQDwrg6oG40ZmcBvRXd01tSrHddgVipK8QWfpjgbIKikNtYm2HFqdCLvKaWxmoyte4KIORrujWI01nLlaNHwikBePSwI9lqhfmr0RvbQ52AVtB3IDPcVylkA2dqKPKj7Hamm2+dZvMf4X7gZsch6Usl3Ht8JKiAZuSPtI/veNzuuDPa9JVk+iLrtB6mCAwUDGehTheNr2wOkWXz3/8nod1jO
 JzMgrGl7
 WJ2fArPCVyrXFKClh0hhmuGbaoz5odqSOCVYFj0KVvGK1S4RPMzWTKmPIz1NYwCzh2urszDJv93alPN3IoKlQXM+47bwCgDVX+H/wBYr3rGjDytYDkifK0Fk8bMeLSK789O3Ik8y8oDMLBj856MScwCW81qbLB+0aGBoEAWnxxzKcAtsSXrRmQtGVbmG8Z8c048Xsypp8iThMxUubxA3WnmclAKiZssEWTyrp3gN+Oc99wLNT5vJg3jPx8aA1qcbkzFjCRSmpSahE3hUTiDngTLWL3T7uW8wpr8P6+Oh21PfSKrTgPcztyCpM/cxLBpoAoRvJmgSXFQFIv3HZZkbCE9T72riqvO0UjaWc+3rzoYZoFPx7FsxNpiw/ui4+rbdX9vGBBn0WkW/y9l84Lr+v5hlki/H/IsYj4n4whHkTM1MSbAZ3Wywp2ftrN6AvBUDjyygE7Xg2rqPh7WRWqOSDsZ9OfKynOZVQxRcY0HeMX4sFzOtWEhX2Wb/hODPUin3WVARpURpGB37fi8MWkQJ3uFUUv5k8NIYiv5Td5d4vEATg9UiA7nDc1mfmcWl1DTxcTa+ndPkCl5fDWEoSL9YNk2mAUUMkabFUgfUIIBfUfO9YAFvTytm9fpHOwzSIvHnSeP0356bvLP75AYnku615TthpcjTiRvmoLi196IU88w3nydTbpS3jF4/UC+g3bGholpUX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's capability analysis for ww_mutex.

The programming model for ww_mutex is subtly more complex than other
locking primitives when using ww_acquire_ctx. Encoding the respective
pre-conditions for ww_mutex lock/unlock based on ww_acquire_ctx state
using Clang's capability analysis makes incorrect use of the API harder.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* __assert -> __assume rename

v2:
* New patch.
---
 .../dev-tools/capability-analysis.rst         |  3 +-
 include/linux/ww_mutex.h                      | 22 ++++--
 lib/test_capability-analysis.c                | 69 +++++++++++++++++++
 3 files changed, 87 insertions(+), 7 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 9fb964e94920..2b89d346723b 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -82,7 +82,8 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`,
+`ww_mutex`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
index 45ff6f7a872b..549d75aee76a 100644
--- a/include/linux/ww_mutex.h
+++ b/include/linux/ww_mutex.h
@@ -44,7 +44,7 @@ struct ww_class {
 	unsigned int is_wait_die;
 };
 
-struct ww_mutex {
+struct_with_capability(ww_mutex) {
 	struct WW_MUTEX_BASE base;
 	struct ww_acquire_ctx *ctx;
 #ifdef DEBUG_WW_MUTEXES
@@ -52,7 +52,7 @@ struct ww_mutex {
 #endif
 };
 
-struct ww_acquire_ctx {
+struct_with_capability(ww_acquire_ctx) {
 	struct task_struct *task;
 	unsigned long stamp;
 	unsigned int acquired;
@@ -107,6 +107,7 @@ struct ww_acquire_ctx {
  */
 static inline void ww_mutex_init(struct ww_mutex *lock,
 				 struct ww_class *ww_class)
+	__assumes_cap(lock)
 {
 	ww_mutex_base_init(&lock->base, ww_class->mutex_name, &ww_class->mutex_key);
 	lock->ctx = NULL;
@@ -141,6 +142,7 @@ static inline void ww_mutex_init(struct ww_mutex *lock,
  */
 static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
 				   struct ww_class *ww_class)
+	__acquires(ctx) __no_capability_analysis
 {
 	ctx->task = current;
 	ctx->stamp = atomic_long_inc_return_relaxed(&ww_class->stamp);
@@ -179,6 +181,7 @@ static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
  * data structures.
  */
 static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
+	__releases(ctx) __acquires_shared(ctx) __no_capability_analysis
 {
 #ifdef DEBUG_WW_MUTEXES
 	lockdep_assert_held(ctx);
@@ -196,6 +199,7 @@ static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
  * mutexes have been released with ww_mutex_unlock.
  */
 static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
+	__releases_shared(ctx) __no_capability_analysis
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
+	__acquires(lock) __must_hold(ctx) __no_capability_analysis
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
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index e506dadb3933..12fd9716f0a4 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
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
2.51.0.384.g4c02a37b29-goog


