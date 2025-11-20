Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02102CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D5F36B00A9; Thu, 20 Nov 2025 10:12:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5864C6B00AA; Thu, 20 Nov 2025 10:12:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475736B00AB; Thu, 20 Nov 2025 10:12:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3220B6B00A9
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:12:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D73BA1394DF
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:12 +0000 (UTC)
X-FDA: 84131326104.17.F581919
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0B15E20013
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="i/cdBFr4";
	spf=pass (imf03.hostedemail.com: domain of 3yS8faQUKCPQahranckkcha.Ykihejqt-iigrWYg.knc@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3yS8faQUKCPQahranckkcha.Ykihejqt-iigrWYg.knc@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2auqzFTNru84Mc/h4FPy5CTt8CBssizo13Uye4GopmU=;
	b=sOvW/yz/kbAs0AfmQpqo8W6PhgzEn1T1TDtbfHfDbmBllR3/5e6xWjVAgQLEzucsDVNWlu
	e9fcnSt1H6i+9b7BynOvqjdJ3/VYWcRShb/SWHQZOkMkzioc32jZi6fyVezJYsKOj97S/j
	r+1VYsV/8ZXLzARgnmUAZeup1q2Pb4k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="i/cdBFr4";
	spf=pass (imf03.hostedemail.com: domain of 3yS8faQUKCPQahranckkcha.Ykihejqt-iigrWYg.knc@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3yS8faQUKCPQahranckkcha.Ykihejqt-iigrWYg.knc@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651531; a=rsa-sha256;
	cv=none;
	b=rwx0uVdWylUKN5YAE5OxS311n/SQfMv3lDHAzzi09UdfdLq6kbOs/0SQRQeWw6Uvu3Kfyj
	qQYuQSVK3VFLfbvKtjF32rTrJipd9+lNkWP0fr9D7mwMySpPrk4gPxMxgKdPOalkc2lLwF
	Zf3PeImWknpgLGE6t4lUL2LTOw7tn+A=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso6910815e9.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651530; x=1764256330; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2auqzFTNru84Mc/h4FPy5CTt8CBssizo13Uye4GopmU=;
        b=i/cdBFr4BThXzjiqNYdA1KIU4/tTRE9RzJ3k6YbK/aDRDVdLbbVXdaQfJafUGkLSYg
         /39lN3UE8QS04E+RWtjyPTVX3ZZhUgSCAvLkxgJps/bKPmBQpDR5rCFm7102O5JoRoAn
         uFhBYYKozcEfsv1w9nABt+3VWcHI79Gp3bbZF4pUYuKKOko5p2MLQUnsmrj3yYVcUWN8
         rBbzxCdeV3dRc8RMsRSFS5hXvEo1cdAQMHFqcjNSd4BU8xXcfdgSeh9gWN0aZ3wirjfB
         hzjeaEb1j+nVUrjFrSHM4HAU2aMhP7GJ9sxPSVwnBXx0jKx1Wl0J/nAExf8RZWQ7B0K9
         CYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651530; x=1764256330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2auqzFTNru84Mc/h4FPy5CTt8CBssizo13Uye4GopmU=;
        b=VWMEq0avtJW1MN6KstAg1SNkT8PnkV2TQU4TjrgyA8Q7RlJw4+g5EvJpweUy2ZsTyx
         glUiSMro9bGCs8vKd3vFhnt09nr+zLjc5+smVs37oIquxM84gd7cBNSinSYbWYtopCfO
         kMS9DLDSrN7d494xbEUdNOD5bS7XzBeX6KJ0Sjc5lw8Rlazlmw3bJBcUXu7F0lt0eqOd
         COZgD3y4R+YbUfpIVId/rMqBtdplzB9bCFr5zX+jYXz61xqnXNoymnZZwK39TmMNCeGB
         pU4T5NWLm0mRc8UlUQcfeHdfDFzxGKh70ux3MuQTHqpgYyEJptYoANLSG916hnzIW/w5
         kLWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCDTdM22pSW6zrB9rsK5ywdyU3e+g1LUAT4og9G42Az8399qSYnEWUe28A4+Xv0esSSL4Dz4e8fA==@kvack.org
X-Gm-Message-State: AOJu0YxhGwCLxuwFIiz4AvPodL8CUH4m0BGVJ0HRa9/qluDYLVSwlqHO
	kyX6dQD63bC8mMzH4tj5dk3Y+OVUO7PeyvkVY99qwZYtvYQczGqWUS0F9DDnToK07CfMSjWHCUP
	ETw==
X-Google-Smtp-Source: AGHT+IGNF877xZIMkrqSG9e8HXfdE4iPehoBLINvx7tcm99gYUdknonGEyIpqxIrFW9MWM+3ZSJklS+Bgg==
X-Received: from wmoy21.prod.google.com ([2002:a05:600c:17d5:b0:477:a7d1:fd12])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1f0f:b0:46e:53cb:9e7f
 with SMTP id 5b1f17b1804b1-477b8a8bd4fmr35618325e9.18.1763651529324; Thu, 20
 Nov 2025 07:12:09 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:34 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-10-elver@google.com>
Subject: [PATCH v4 09/35] compiler-context-analysis: Change __cond_acquires to
 take return value
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
X-Rspamd-Queue-Id: 0B15E20013
X-Stat-Signature: hindbqcen96y87rtp16egwyd6z1nk83a
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763651530-560855
X-HE-Meta: U2FsdGVkX18j55kVhYr1fNZxf+osbGOj5rRklCLQs32q2Q1SR8/F8uU5P+5HiI+wQP/zCyC01SIG4SFTICjM961/Yx+URm6K5/S5sbPt3IvSj/+f3XcNyMy7G0blAnRMryF8HV9guZ6lGyoZMRWraqsyhq5f/qNjchHx3w9mq3pZeBLkvo5iNTHrcYW5u4ounFRv97m3FbAJOcepDOmd9Hbms9JIaQLObZrC0Fy86PP2zlO9xbZRBgmgLOd6ZZkaNvD+G2fTWtc+pCtmiYtArXOIgo9kaGIM9sTDTYzjLB96h1my6041Tsxul29tw8ylhxAbedcV1D6QQ/vV/IUZjdTQxyAeFqZi5pwkuNV10sRmTjrvYiqlyZFONRauRpHuXdsdRCWuKvTklhza3uvpDVv8w1zY5b6YofYF2lNlzX2KB9ltNi1tvHk0jVgou4Ln3g+2esLGMiMxYb0Bl/N8HVV1sTaGAj87NXPUgaOSoqLKsCQV0c9nL8kTY4cb8qwAP+N1MahUWeBTlZ/u++5tW3hI0GmsJxQJXL4BgVxC4IN4MdplMim68j85QVmm9W4Pw7R1sIleNeGR2NbhzuFxDcAHCzAX6QRpnkwEVRttwBO6gBvGj4h/REwKF3Agm9GQxsZ4efKY14biEegXnyuobapOp66S8HikFtXp4QUj1xywKmJWVGtLRHVOvROk1jHDSnwuPcSpPnS0mmQVVaasRwpOqVDxGUxzGRr5bKwi33UrK0nuj9grI0SSnwCl9siY6qE8NwNzKfNgRSkx9i+UAZhOAAjn49FJk3Ykell8u9HI5CXMRKRDKjc0/EWTBx7T2sd+2odk2nJeNMw9/EJMLKvrWbLT73fyHPDkTqolAekkIzM8s98m05nONjnQFar7M9PTu9Z6NRJQnLLxTW3QFebT7FYY8kYmdtisVSCf/aAVXCEGpXAuPeLM6iLIIybC0KiAtPwsnoht7VsvcKJ
 4EZ80yfA
 eM2trh3yfR3PlHgydpuLRXb3IdqLJZRNQPOHxO29f2E+u+8Hu7zxbfUxwc+XUY6iGi7spp94dfI/bzEMlH+Yfpmghdk8o6K6/GS2zgWllyT967DHhT3DDK2Z8u1BWqTSO6Ehq+PtHqDH3fVsZspZu6BA4lUOVp6OtLgpx9rKsyJ0/b/Nd6KAzNH8o/FDUNRwjRy6EsYRmw1Hb/R8ICMXt9D2F5+kSUg2wOb7nJxhnmXaH6/I3CRdocqFqfPf/nqmLtHKKRZ3lf4b5BEY8VPO2cfKX/MAxGAII7O5OiFk4mkxuSgC3BhtgRR0bB5zPCT51fhWa7YFYkh8MhVmRsL19gvAlDzVSzXTndQAQgPgaL44DaAI1EDmu51Iz1DwTxC6u+Jmg69ON8rwzy0IRZQ2K6leCrTn1VOuhC+KY/womtCXa0HicK3Vrk5slSvl+PZKDN9ei75BnStMDWPFGQOkbEUe+TiX5m5KNYp8be5pTRdFTJ9J+y759JM9zT+6I+DVCcUPW9/6YDskm+qKwZ0ck4VZFU3w+Ippm0ShREVtmAK1/8clBW1pd22qo+BOccj7WwPYm6VCQ2FRUr7ZNLXeIuteYR+88I15P/AUiuaJRJ1x0HK6eSE97nUV0fjAS/B1dFcG7AeWB07VEb+nVX/0n68QJfQrMMQZEjQI9lFlyPe4beQ5yq6J7g+KRu5ifWyfqNFRyhOEFh9XwlReAe2+B2Z/qzW511rOchY9ZBqp8K+ePycGJY4ZW58JEH251eoJJ//i5FBfp2RQqW9nGxgpxebs4ZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While Sparse is oblivious to the return value of conditional acquire
functions, Clang's context analysis needs to know the return value
which indicates successful acquisition.

Add the additional argument, and convert existing uses.

Notably, Clang's interpretation of the value merely relates to the use
in a later conditional branch, i.e. 1 ==> context guard acquired in
branch taken if condition non-zero, and 0 ==> context guard acquired in
branch taken if condition is zero. Given the precise value does not
matter, introduce symbolic variants to use instead of either 0 or 1,
which should be more intuitive.

No functional change intended.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v2:
* Use symbolic values for __cond_acquires() and __cond_acquires_shared()
  (suggested by Bart).
---
 fs/dlm/lock.c                             |  2 +-
 include/linux/compiler-context-analysis.h | 31 +++++++++++++++++++----
 include/linux/refcount.h                  |  6 ++---
 include/linux/spinlock.h                  |  6 ++---
 include/linux/spinlock_api_smp.h          |  8 +++---
 net/ipv4/tcp_sigpool.c                    |  2 +-
 6 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index be938fdf17d9..0ce04be0d3de 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -343,7 +343,7 @@ void dlm_hold_rsb(struct dlm_rsb *r)
 /* TODO move this to lib/refcount.c */
 static __must_check bool
 dlm_refcount_dec_and_write_lock_bh(refcount_t *r, rwlock_t *lock)
-__cond_acquires(lock)
+      __cond_acquires(true, lock)
 {
 	if (refcount_dec_not_one(r))
 		return false;
diff --git a/include/linux/compiler-context-analysis.h b/include/linux/compiler-context-analysis.h
index 8c75e1d0034a..935e59089d75 100644
--- a/include/linux/compiler-context-analysis.h
+++ b/include/linux/compiler-context-analysis.h
@@ -259,7 +259,7 @@ static inline void _context_unsafe_alias(void **p) { }
 # define __must_hold(x)		__attribute__((context(x,1,1)))
 # define __must_not_hold(x)
 # define __acquires(x)		__attribute__((context(x,0,1)))
-# define __cond_acquires(x)	__attribute__((context(x,0,-1)))
+# define __cond_acquires(ret, x) __attribute__((context(x,0,-1)))
 # define __releases(x)		__attribute__((context(x,1,0)))
 # define __acquire(x)		__context__(x,1)
 # define __release(x)		__context__(x,-1)
@@ -302,15 +302,32 @@ static inline void _context_unsafe_alias(void **p) { }
  */
 # define __acquires(x)		__acquires_ctx_guard(x)
 
+/*
+ * Clang's analysis does not care precisely about the value, only that it is
+ * either zero or non-zero. So the __cond_acquires() interface might be
+ * misleading if we say that @ret is the value returned if acquired. Instead,
+ * provide symbolic variants which we translate.
+ */
+#define __cond_acquires_impl_true(x, ...)     __try_acquires##__VA_ARGS__##_ctx_guard(1, x)
+#define __cond_acquires_impl_false(x, ...)    __try_acquires##__VA_ARGS__##_ctx_guard(0, x)
+#define __cond_acquires_impl_nonzero(x, ...)  __try_acquires##__VA_ARGS__##_ctx_guard(1, x)
+#define __cond_acquires_impl_0(x, ...)        __try_acquires##__VA_ARGS__##_ctx_guard(0, x)
+#define __cond_acquires_impl_nonnull(x, ...)  __try_acquires##__VA_ARGS__##_ctx_guard(1, x)
+#define __cond_acquires_impl_NULL(x, ...)     __try_acquires##__VA_ARGS__##_ctx_guard(0, x)
+
 /**
  * __cond_acquires() - function attribute, function conditionally
  *                     acquires a context guard exclusively
+ * @ret: abstract value returned by function if context guard acquired
  * @x: context guard instance pointer
  *
  * Function attribute declaring that the function conditionally acquires the
- * given context guard instance @x exclusively, but does not release it.
+ * given context guard instance @x exclusively, but does not release it. The
+ * function return value @ret denotes when the context guard is acquired.
+ *
+ * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires(x)	__try_acquires_ctx_guard(1, x)
+# define __cond_acquires(ret, x) __cond_acquires_impl_##ret(x)
 
 /**
  * __releases() - function attribute, function releases a context guard exclusively
@@ -377,12 +394,16 @@ static inline void _context_unsafe_alias(void **p) { }
 /**
  * __cond_acquires_shared() - function attribute, function conditionally
  *                            acquires a context guard shared
+ * @ret: abstract value returned by function if context guard acquired
  * @x: context guard instance pointer
  *
  * Function attribute declaring that the function conditionally acquires the
- * given context guard instance @x with shared access, but does not release it.
+ * given context guard instance @x with shared access, but does not release it. The
+ * function return value @ret denotes when the context guard is acquired.
+ *
+ * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires_shared(x) __try_acquires_shared_ctx_guard(1, x)
+# define __cond_acquires_shared(ret, x) __cond_acquires_impl_##ret(x, _shared)
 
 /**
  * __releases_shared() - function attribute, function releases a
diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index 80dc023ac2bf..3da377ffb0c2 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -478,9 +478,9 @@ static inline void refcount_dec(refcount_t *r)
 
 extern __must_check bool refcount_dec_if_one(refcount_t *r);
 extern __must_check bool refcount_dec_not_one(refcount_t *r);
-extern __must_check bool refcount_dec_and_mutex_lock(refcount_t *r, struct mutex *lock) __cond_acquires(lock);
-extern __must_check bool refcount_dec_and_lock(refcount_t *r, spinlock_t *lock) __cond_acquires(lock);
+extern __must_check bool refcount_dec_and_mutex_lock(refcount_t *r, struct mutex *lock) __cond_acquires(true, lock);
+extern __must_check bool refcount_dec_and_lock(refcount_t *r, spinlock_t *lock) __cond_acquires(true, lock);
 extern __must_check bool refcount_dec_and_lock_irqsave(refcount_t *r,
 						       spinlock_t *lock,
-						       unsigned long *flags) __cond_acquires(lock);
+						       unsigned long *flags) __cond_acquires(true, lock);
 #endif /* _LINUX_REFCOUNT_H */
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 2bcb3f0bf00e..274d866a0be3 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -362,7 +362,7 @@ static __always_inline void spin_lock_bh(spinlock_t *lock)
 }
 
 static __always_inline int spin_trylock(spinlock_t *lock)
-	__cond_acquires(lock) __no_context_analysis
+	__cond_acquires(true, lock) __no_context_analysis
 {
 	return raw_spin_trylock(&lock->rlock);
 }
@@ -422,13 +422,13 @@ static __always_inline void spin_unlock_irqrestore(spinlock_t *lock, unsigned lo
 }
 
 static __always_inline int spin_trylock_bh(spinlock_t *lock)
-	__cond_acquires(lock) __no_context_analysis
+	__cond_acquires(true, lock) __no_context_analysis
 {
 	return raw_spin_trylock_bh(&lock->rlock);
 }
 
 static __always_inline int spin_trylock_irq(spinlock_t *lock)
-	__cond_acquires(lock) __no_context_analysis
+	__cond_acquires(true, lock) __no_context_analysis
 {
 	return raw_spin_trylock_irq(&lock->rlock);
 }
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index d19327e04df9..7e7d7d373213 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -34,8 +34,8 @@ unsigned long __lockfunc _raw_spin_lock_irqsave(raw_spinlock_t *lock)
 unsigned long __lockfunc
 _raw_spin_lock_irqsave_nested(raw_spinlock_t *lock, int subclass)
 								__acquires(lock);
-int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock)		__cond_acquires(lock);
-int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock)	__cond_acquires(lock);
+int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock)		__cond_acquires(true, lock);
+int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock)	__cond_acquires(true, lock);
 void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)		__releases(lock);
 void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)	__releases(lock);
 void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)	__releases(lock);
@@ -84,7 +84,7 @@ _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 #endif
 
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
-	__cond_acquires(lock)
+	__cond_acquires(true, lock)
 {
 	preempt_disable();
 	if (do_raw_spin_trylock(lock)) {
@@ -177,7 +177,7 @@ static inline void __raw_spin_unlock_bh(raw_spinlock_t *lock)
 }
 
 static inline int __raw_spin_trylock_bh(raw_spinlock_t *lock)
-	__cond_acquires(lock)
+	__cond_acquires(true, lock)
 {
 	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	if (do_raw_spin_trylock(lock)) {
diff --git a/net/ipv4/tcp_sigpool.c b/net/ipv4/tcp_sigpool.c
index d8a4f192873a..10b2e5970c40 100644
--- a/net/ipv4/tcp_sigpool.c
+++ b/net/ipv4/tcp_sigpool.c
@@ -257,7 +257,7 @@ void tcp_sigpool_get(unsigned int id)
 }
 EXPORT_SYMBOL_GPL(tcp_sigpool_get);
 
-int tcp_sigpool_start(unsigned int id, struct tcp_sigpool *c) __cond_acquires(RCU_BH)
+int tcp_sigpool_start(unsigned int id, struct tcp_sigpool *c) __cond_acquires(0, RCU_BH)
 {
 	struct crypto_ahash *hash;
 
-- 
2.52.0.rc1.455.g30608eb744-goog


