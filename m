Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4827DCF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45556B00BD; Thu, 20 Nov 2025 10:13:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D1C6B00BF; Thu, 20 Nov 2025 10:13:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932706B00C0; Thu, 20 Nov 2025 10:13:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7DB6B00BD
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F3D985609
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:08 +0000 (UTC)
X-FDA: 84131328456.23.E6FAEB1
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 680AEA0014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XZWrCJCh;
	spf=pass (imf25.hostedemail.com: domain of 3ADAfaQUKCC0NUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3ADAfaQUKCC0NUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGtcXg38DvnDW7LCtn8VPS4tEIyxPZjVcXoXmWDrgp8=;
	b=t2lX+jmv226QDMeivjzX7Td5ya/B5K42jdrWUj9W0kyslhZF6HgqnmawDDqtHgH5hFAQ2M
	TOEP7DfcnFC7Xf+w4JCCHrTzHloTlIM2LNC+PNQg1oyuRdRGLgNqcFvscplcM8FWHJyGaD
	o99crjG4qNpZ+24Pc/WTD7QKZQAK9OY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XZWrCJCh;
	spf=pass (imf25.hostedemail.com: domain of 3ADAfaQUKCC0NUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3ADAfaQUKCC0NUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651586; a=rsa-sha256;
	cv=none;
	b=xdjtTYnYkw7GjvERtfA1UiQqE5Q+51XRpPZ/yrORI9R/rSh//rY9IOJO31bByasYZ0f9OZ
	vZ0Gm3ZynNb2NToqQe7TFzLuJQuwbQxnpgQLjK0QPtn4PEKjUaEnTMYvyA5/bX35B1IRDr
	/IX0U9jsYc1TNGNaS+hjH0MXarlS7SU=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-429c76c8a1bso1052229f8f.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651585; x=1764256385; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bGtcXg38DvnDW7LCtn8VPS4tEIyxPZjVcXoXmWDrgp8=;
        b=XZWrCJChxTSEwgFYeY7zcggQ9ozQdxdp5nWpEE+frQYj/8tqSxAATNkIvzy3NkLLsb
         fjkmI6c2WeNcJ9Aem2LgcLIP3z8mItOmE/bYZlbAxypDu3K+m/J9YIPSN9lK7K9Ae3QA
         IL/MiyPjoka3mtRTdHE31ZjGc9afe24fQM3e0N2OOTtDih+Wwhzk0e0G+Xqzxofqzres
         z2ugTTpoVRPL+kZ4Aqdsg8+bGntuAzV3Nl8kQv35fw+PYwJ/F1ruSzme4YN2tlkwdTSV
         mbUOmRGX0H3ZQrpdnyxHtpi2ilYjoOpS2hVIeJrWkXNoflv++/MovzbZaho86pTjX60R
         cbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651585; x=1764256385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bGtcXg38DvnDW7LCtn8VPS4tEIyxPZjVcXoXmWDrgp8=;
        b=XPmNi/aCog7QHEWfJeWTVHto6UeQb5z/Er6BcWNoG40Z2ywZJDJ4P1AxeYWJngfZcY
         aDjyNfwwiRjAcWRtwhkKMwOs/gXnkdSasUfBjf7r2fjeiGHotYk/aHbAWiW5jKFhD7Kn
         B0ivNBb3+UAFaurrIrWNC7YQ4rfocJfo4oL1e4BlIbUk65emC4d6FhUNzQ4kuBBy+SND
         EP1sQwXAd4hO3W6KVdWCmMjDTXkKrgEpocgo3yhzd/UBbjnqahIZDvJ3/UVW3zj54p3R
         axLNGZW3MU3Y3SWRHOWdqLrdEJt83QwOox9w9ZZWhOtElEIFQaxAte1vJrNW9LJmUuYw
         dMLQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9hnRl/RzIWfr3PZ0Esgv1zYhWg2IoAh1zvF6ZuGJcV54V0KsW5T2yqpv1RypGBrKd4k8tNrWbVQ==@kvack.org
X-Gm-Message-State: AOJu0Yyq0E4ZxPNn2y8Ko7T8d6pqZ5Zj4J4b1U3YSh4/4ebYQfujxnNv
	Z/GKMClkoiSkg8N20AOQgHHX5dg3t5XikY5QucoCwiy9p8XVeABnZ8NFsvelmtOjzjvHavx0UJd
	3Qw==
X-Google-Smtp-Source: AGHT+IGhcdS9pWCnclB0ZnSa2CT1VpV8SLzu+bKGMl3/AqvfyiDsJLESbsF+yAvo2bmuHOzFOvaMv3LckQ==
X-Received: from wraj7.prod.google.com ([2002:a5d:4527:0:b0:42b:2aa2:e459])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2406:b0:42b:4081:ccb8
 with SMTP id ffacd0b85a97d-42cb9a1d969mr3010427f8f.23.1763651584236; Thu, 20
 Nov 2025 07:13:04 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:44 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-20-elver@google.com>
Subject: [PATCH v4 19/35] locking/local_lock: Support Clang's context analysis
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
X-Rspamd-Queue-Id: 680AEA0014
X-Stat-Signature: 71rmbxdmj41muo5im1sw5smych47p1cm
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763651586-623484
X-HE-Meta: U2FsdGVkX1+HiGLR1iR9FOwuw//813ZjnFJ95Lehyr6xyiYqWA2RAXVPlb6VL4mV6lfKSZfd3M3vGVBD0JhihG59PkCQ3R1itlyWjNqlT9vqqZm++95Qi6GRMksSgSlqzCaeUuXAryA53CHmt+yO49L9KQkfUGJ6g34dQ7/gPt8KQ3CBUvZ358LvPBrYMwNF1s3wE3J8etfvF/B+uFmjcirHeXKGkEWz1B0VkrSDpYOzYvNNGCHwEnLpT30S523+iC+Rv93q0EcXQXIPo3akSA0uUpn7aVSSaPp55tcJBZ9f6SZ1YwiFSBygydIvGvRrzh0+lnxWXca+vp8UyCzYMLHVk9rzwwjaDsy1sr+D15JRWWHoypBljfuBJorF0wG+qlbIDI3pfkszjALaVEjjxTE4q44d6YchjDNLRpVb4jt/oQC5EM9A8MIzzlD/7BqInPi5hMNG6I4ImmZOUbNMkHgKXmehqGc9WWSAcvJwTeF6D1Njkrhumv647ZwhcWRYXsjfzJqiLMHEAJass2k527Lofd/SejeeyhjMMgYUzNQDM/+HNqgkRf/sc3uUTvM8NAaiL3SU3SyNNKC+8jeneotE19dr5ELaVLmGc5vFviCUkKsnP//rat8CYPEiDo4y1rBSjzyvbcpLphqxZ0hsbAYOuJaH3Ntzh31rJH37DpvpfkPgcQV3bPpEYiH52DGDHTMXrtepCdvrF359KHlNdKL7uWJYtTsKXul/XGoge+k6Bj5ufPmO7YpwgNK+7nH2FFzxLMIfx3067eJOh2Cq+i026odDG9qgroe4us+gUosmPFVqEVH/g6TZiEDKsrDMy2Bztpg2jIUISRBFnGV2F9sbWAE26Dl6mBmyoTHOSnoNW56a+GTZ7EeCt3HokThdQp3CtM66oD8p82dySj8YumBGjAIntoN2DhjuKmE/BaNx9KzyJylI1JNmLxkiWUlpX2ydDSRoklKnn0FQXJ7
 +7TQOq+7
 AEbhacDLAes6d+yRZcPl6plpjIWYOhjYjZCocq36CYddWJtikmCEZMgQdwK12/wUZaXAmnmBdXwMsM3Xy5+NvEQZjPOp6CTBg3IBJKKoO42DJexgp/+F3qf8Ri+9OrkoaE5hpNeQNs+IkydoVoVwZRq127togP4vEQBmsvu2N7u2Oto3MIdin1lKNasyemN6lf/58yTnDwhDD2IYp7zqjAxpWtWNr4OQXQJd2JM14Ns+k/Naj6yNRaQnYz7cZfQvRohBQV+165uPm6Fi/zoHuJ+2vgN+Wi1NeOQl8KNpU1YNjmKi8jzzmrBmIJ740bFXin7MFy6eCXIYDSag60fFYlA46By4tAjg985NjH//n3QtGf0pghEBiEzMXD8KD7HwzWv5dWxF7O9e77aFaJqVwKyoJJUODu1Lt/mvACIaHNl/mAYTq7ujSlPIVfC4LUynv+3JcWp/VBE2kduSJUld25hFFrTkfL9bQnLGfx/EjPt+pjSq327aXVMHkWYn0W0/eVu0KTjV+bT5S4V9BQ80TqWxYjyWU2FORPN79pqoeSbUUmugsColrnmatlLstgvzIdtRasVPURnprlUClECPK/+hCuuIT5Xfu1LIOG9+UQ+v0L2pOV4pp4alaQsqzqsXagzu0FRNFnxXpvQdq0gsbYnk/L/9OMPwegGeVbQc0FG+Sma6TfxDxOuvjl7FIHY8JjXiy31Y2oMQe9da5+2Z9m+N/pTBzwbv5d+JbL1IDyVt70U+xdw+FmXpM39XvKJlwS3e56xW8k4wQkKMbMyWAmfweuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's context analysis for local_lock_t and
local_trylock_t.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* __assert -> __assume rename
* Rework __this_cpu_local_lock helper
* Support local_trylock_t
---
 Documentation/dev-tools/context-analysis.rst |  2 +-
 include/linux/local_lock.h                   | 45 ++++++------
 include/linux/local_lock_internal.h          | 71 +++++++++++++++----
 lib/test_context-analysis.c                  | 73 ++++++++++++++++++++
 4 files changed, 156 insertions(+), 35 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index dc7ae4f641f2..8737de63a707 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -81,7 +81,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`.
 
 For context guards with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/local_lock.h b/include/linux/local_lock.h
index 0d91d060e3e9..a83458bebe97 100644
--- a/include/linux/local_lock.h
+++ b/include/linux/local_lock.h
@@ -13,13 +13,13 @@
  * local_lock - Acquire a per CPU local lock
  * @lock:	The lock variable
  */
-#define local_lock(lock)		__local_lock(this_cpu_ptr(lock))
+#define local_lock(lock)		__local_lock(__this_cpu_local_lock(lock))
 
 /**
  * local_lock_irq - Acquire a per CPU local lock and disable interrupts
  * @lock:	The lock variable
  */
-#define local_lock_irq(lock)		__local_lock_irq(this_cpu_ptr(lock))
+#define local_lock_irq(lock)		__local_lock_irq(__this_cpu_local_lock(lock))
 
 /**
  * local_lock_irqsave - Acquire a per CPU local lock, save and disable
@@ -28,19 +28,19 @@
  * @flags:	Storage for interrupt flags
  */
 #define local_lock_irqsave(lock, flags)				\
-	__local_lock_irqsave(this_cpu_ptr(lock), flags)
+	__local_lock_irqsave(__this_cpu_local_lock(lock), flags)
 
 /**
  * local_unlock - Release a per CPU local lock
  * @lock:	The lock variable
  */
-#define local_unlock(lock)		__local_unlock(this_cpu_ptr(lock))
+#define local_unlock(lock)		__local_unlock(__this_cpu_local_lock(lock))
 
 /**
  * local_unlock_irq - Release a per CPU local lock and enable interrupts
  * @lock:	The lock variable
  */
-#define local_unlock_irq(lock)		__local_unlock_irq(this_cpu_ptr(lock))
+#define local_unlock_irq(lock)		__local_unlock_irq(__this_cpu_local_lock(lock))
 
 /**
  * local_unlock_irqrestore - Release a per CPU local lock and restore
@@ -49,7 +49,7 @@
  * @flags:      Interrupt flags to restore
  */
 #define local_unlock_irqrestore(lock, flags)			\
-	__local_unlock_irqrestore(this_cpu_ptr(lock), flags)
+	__local_unlock_irqrestore(__this_cpu_local_lock(lock), flags)
 
 /**
  * local_lock_init - Runtime initialize a lock instance
@@ -64,7 +64,7 @@
  * locking constrains it will _always_ fail to acquire the lock in NMI or
  * HARDIRQ context on PREEMPT_RT.
  */
-#define local_trylock(lock)		__local_trylock(this_cpu_ptr(lock))
+#define local_trylock(lock)		__local_trylock(__this_cpu_local_lock(lock))
 
 #define local_lock_is_locked(lock)	__local_lock_is_locked(lock)
 
@@ -79,27 +79,32 @@
  * HARDIRQ context on PREEMPT_RT.
  */
 #define local_trylock_irqsave(lock, flags)			\
-	__local_trylock_irqsave(this_cpu_ptr(lock), flags)
-
-DEFINE_GUARD(local_lock, local_lock_t __percpu*,
-	     local_lock(_T),
-	     local_unlock(_T))
-DEFINE_GUARD(local_lock_irq, local_lock_t __percpu*,
-	     local_lock_irq(_T),
-	     local_unlock_irq(_T))
+	__local_trylock_irqsave(__this_cpu_local_lock(lock), flags)
+
+DEFINE_LOCK_GUARD_1(local_lock, local_lock_t __percpu,
+		    local_lock(_T->lock),
+		    local_unlock(_T->lock))
+DEFINE_LOCK_GUARD_1(local_lock_irq, local_lock_t __percpu,
+		    local_lock_irq(_T->lock),
+		    local_unlock_irq(_T->lock))
 DEFINE_LOCK_GUARD_1(local_lock_irqsave, local_lock_t __percpu,
 		    local_lock_irqsave(_T->lock, _T->flags),
 		    local_unlock_irqrestore(_T->lock, _T->flags),
 		    unsigned long flags)
 
 #define local_lock_nested_bh(_lock)				\
-	__local_lock_nested_bh(this_cpu_ptr(_lock))
+	__local_lock_nested_bh(__this_cpu_local_lock(_lock))
 
 #define local_unlock_nested_bh(_lock)				\
-	__local_unlock_nested_bh(this_cpu_ptr(_lock))
+	__local_unlock_nested_bh(__this_cpu_local_lock(_lock))
 
-DEFINE_GUARD(local_lock_nested_bh, local_lock_t __percpu*,
-	     local_lock_nested_bh(_T),
-	     local_unlock_nested_bh(_T))
+DEFINE_LOCK_GUARD_1(local_lock_nested_bh, local_lock_t __percpu,
+		    local_lock_nested_bh(_T->lock),
+		    local_unlock_nested_bh(_T->lock))
+
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock, __assumes_ctx_guard(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_irq, __assumes_ctx_guard(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_irqsave, __assumes_ctx_guard(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_nested_bh, __assumes_ctx_guard(_T), /* */)
 
 #endif
diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index 9f6cb32f04b0..17b8135bd2c3 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -10,21 +10,23 @@
 
 #ifndef CONFIG_PREEMPT_RT
 
-typedef struct {
+context_guard_struct(local_lock) {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 	struct task_struct	*owner;
 #endif
-} local_lock_t;
+};
+typedef struct local_lock local_lock_t;
 
 /* local_trylock() and local_trylock_irqsave() only work with local_trylock_t */
-typedef struct {
+context_guard_struct(local_trylock) {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 	struct task_struct	*owner;
 #endif
 	u8		acquired;
-} local_trylock_t;
+};
+typedef struct local_trylock local_trylock_t;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define LOCAL_LOCK_DEBUG_INIT(lockname)		\
@@ -84,9 +86,14 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_PERCPU);			\
 	local_lock_debug_init(lock);				\
+	__assume_ctx_guard(lock);				\
 } while (0)
 
-#define __local_trylock_init(lock) __local_lock_init((local_lock_t *)lock)
+#define __local_trylock_init(lock)				\
+do {								\
+	__local_lock_init((local_lock_t *)lock);		\
+	__assume_ctx_guard(lock);				\
+} while (0)
 
 #define __spinlock_nested_bh_init(lock)				\
 do {								\
@@ -97,6 +104,7 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_NORMAL);			\
 	local_lock_debug_init(lock);				\
+	__assume_ctx_guard(lock);				\
 } while (0)
 
 #define __local_lock_acquire(lock)					\
@@ -119,22 +127,25 @@ do {								\
 	do {							\
 		preempt_disable();				\
 		__local_lock_acquire(lock);			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_lock_irq(lock)					\
 	do {							\
 		local_irq_disable();				\
 		__local_lock_acquire(lock);			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_lock_irqsave(lock, flags)			\
 	do {							\
 		local_irq_save(flags);				\
 		__local_lock_acquire(lock);			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_trylock(lock)					\
-	({							\
+	__try_acquire_ctx_guard(lock, ({				\
 		local_trylock_t *tl;				\
 								\
 		preempt_disable();				\
@@ -148,10 +159,10 @@ do {								\
 				(local_lock_t *)tl);		\
 		}						\
 		!!tl;						\
-	})
+	}))
 
 #define __local_trylock_irqsave(lock, flags)			\
-	({							\
+	__try_acquire_ctx_guard(lock, ({				\
 		local_trylock_t *tl;				\
 								\
 		local_irq_save(flags);				\
@@ -165,7 +176,7 @@ do {								\
 				(local_lock_t *)tl);		\
 		}						\
 		!!tl;						\
-	})
+	}))
 
 /* preemption or migration must be disabled before calling __local_lock_is_locked */
 #define __local_lock_is_locked(lock) READ_ONCE(this_cpu_ptr(lock)->acquired)
@@ -188,18 +199,21 @@ do {								\
 
 #define __local_unlock(lock)					\
 	do {							\
+		__release(lock);				\
 		__local_lock_release(lock);			\
 		preempt_enable();				\
 	} while (0)
 
 #define __local_unlock_irq(lock)				\
 	do {							\
+		__release(lock);				\
 		__local_lock_release(lock);			\
 		local_irq_enable();				\
 	} while (0)
 
 #define __local_unlock_irqrestore(lock, flags)			\
 	do {							\
+		__release(lock);				\
 		__local_lock_release(lock);			\
 		local_irq_restore(flags);			\
 	} while (0)
@@ -208,13 +222,19 @@ do {								\
 	do {							\
 		lockdep_assert_in_softirq();			\
 		local_lock_acquire((lock));			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_unlock_nested_bh(lock)				\
-	local_lock_release((lock))
+	do {							\
+		__release(lock);				\
+		local_lock_release((lock));			\
+	} while (0)
 
 #else /* !CONFIG_PREEMPT_RT */
 
+#include <linux/spinlock.h>
+
 /*
  * On PREEMPT_RT local_lock maps to a per CPU spinlock, which protects the
  * critical section while staying preemptible.
@@ -269,7 +289,7 @@ do {								\
 } while (0)
 
 #define __local_trylock(lock)					\
-	({							\
+	__try_acquire_ctx_guard(lock, context_unsafe(({		\
 		int __locked;					\
 								\
 		if (in_nmi() | in_hardirq()) {			\
@@ -281,17 +301,40 @@ do {								\
 				migrate_enable();		\
 		}						\
 		__locked;					\
-	})
+	})))
 
 #define __local_trylock_irqsave(lock, flags)			\
-	({							\
+	__try_acquire_ctx_guard(lock, ({			\
 		typecheck(unsigned long, flags);		\
 		flags = 0;					\
 		__local_trylock(lock);				\
-	})
+	}))
 
 /* migration must be disabled before calling __local_lock_is_locked */
 #define __local_lock_is_locked(__lock)					\
 	(rt_mutex_owner(&this_cpu_ptr(__lock)->lock) == current)
 
 #endif /* CONFIG_PREEMPT_RT */
+
+#if defined(WARN_CONTEXT_ANALYSIS)
+/*
+ * Because the compiler only knows about the base per-CPU variable, use this
+ * helper function to make the compiler think we lock/unlock the @base variable,
+ * and hide the fact we actually pass the per-CPU instance to lock/unlock
+ * functions.
+ */
+static __always_inline local_lock_t *__this_cpu_local_lock(local_lock_t __percpu *base)
+	__returns_ctx_guard(base) __attribute__((overloadable))
+{
+	return this_cpu_ptr(base);
+}
+#ifndef CONFIG_PREEMPT_RT
+static __always_inline local_trylock_t *__this_cpu_local_lock(local_trylock_t __percpu *base)
+	__returns_ctx_guard(base) __attribute__((overloadable))
+{
+	return this_cpu_ptr(base);
+}
+#endif /* CONFIG_PREEMPT_RT */
+#else  /* WARN_CONTEXT_ANALYSIS */
+#define __this_cpu_local_lock(base) this_cpu_ptr(base)
+#endif /* WARN_CONTEXT_ANALYSIS */
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 2203a57cd40d..74eca21f7aaa 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -6,7 +6,9 @@
 
 #include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
+#include <linux/local_lock.h>
 #include <linux/mutex.h>
+#include <linux/percpu.h>
 #include <linux/rcupdate.h>
 #include <linux/rwsem.h>
 #include <linux/seqlock.h>
@@ -450,3 +452,74 @@ static void __used test_srcu_guard(struct test_srcu_data *d)
 	guard(srcu)(&d->srcu);
 	(void)srcu_dereference(d->data, &d->srcu);
 }
+
+struct test_local_lock_data {
+	local_lock_t lock;
+	int counter __guarded_by(&lock);
+};
+
+static DEFINE_PER_CPU(struct test_local_lock_data, test_local_lock_data) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
+
+static void __used test_local_lock_init(struct test_local_lock_data *d)
+{
+	local_lock_init(&d->lock);
+	d->counter = 0;
+}
+
+static void __used test_local_lock(void)
+{
+	unsigned long flags;
+
+	local_lock(&test_local_lock_data.lock);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock(&test_local_lock_data.lock);
+
+	local_lock_irq(&test_local_lock_data.lock);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock_irq(&test_local_lock_data.lock);
+
+	local_lock_irqsave(&test_local_lock_data.lock, flags);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock_irqrestore(&test_local_lock_data.lock, flags);
+
+	local_lock_nested_bh(&test_local_lock_data.lock);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock_nested_bh(&test_local_lock_data.lock);
+}
+
+static void __used test_local_lock_guard(void)
+{
+	{ guard(local_lock)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+	{ guard(local_lock_irq)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+	{ guard(local_lock_irqsave)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+	{ guard(local_lock_nested_bh)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+}
+
+struct test_local_trylock_data {
+	local_trylock_t lock;
+	int counter __guarded_by(&lock);
+};
+
+static DEFINE_PER_CPU(struct test_local_trylock_data, test_local_trylock_data) = {
+	.lock = INIT_LOCAL_TRYLOCK(lock),
+};
+
+static void __used test_local_trylock_init(struct test_local_trylock_data *d)
+{
+	local_trylock_init(&d->lock);
+	d->counter = 0;
+}
+
+static void __used test_local_trylock(void)
+{
+	local_lock(&test_local_trylock_data.lock);
+	this_cpu_add(test_local_trylock_data.counter, 1);
+	local_unlock(&test_local_trylock_data.lock);
+
+	if (local_trylock(&test_local_trylock_data.lock)) {
+		this_cpu_add(test_local_trylock_data.counter, 1);
+		local_unlock(&test_local_trylock_data.lock);
+	}
+}
-- 
2.52.0.rc1.455.g30608eb744-goog


