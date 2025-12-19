Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50838D7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B915F6B00A0; Fri, 19 Dec 2025 10:46:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68966B00A1; Fri, 19 Dec 2025 10:46:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A914C6B00A2; Fri, 19 Dec 2025 10:46:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96D7F6B00A0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72A091A02BE
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:03 +0000 (UTC)
X-FDA: 84236646606.17.BE09AEC
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8367B4000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HE5lZlC4;
	spf=pass (imf01.hostedemail.com: domain of 3N3NFaQUKCIQmt3mzowwotm.kwutqv25-uus3iks.wzo@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3N3NFaQUKCIQmt3mzowwotm.kwutqv25-uus3iks.wzo@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lGbYnpIDd95/4deu1O5Gyvn5GxdfmH9SCDxje2/Aqi4=;
	b=DI/pUEGmeBXzasJ+6fhf2PfPaxaBr3O7rhlK00uzHmqBm/49gAEIcc3b4H4g40IYaJ92h/
	GS1d7wsOi+QC1FGPttlS4zIokohk3iqf8vPbcwXBB0g82KyWDav+lsAB57U/dJ3zAS0ygU
	uK9Z5ertS+IvUMbRzpRg+ciWszWGaBQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HE5lZlC4;
	spf=pass (imf01.hostedemail.com: domain of 3N3NFaQUKCIQmt3mzowwotm.kwutqv25-uus3iks.wzo@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3N3NFaQUKCIQmt3mzowwotm.kwutqv25-uus3iks.wzo@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159161; a=rsa-sha256;
	cv=none;
	b=s0ONs+qfTIujhX+zZ8IPZu10h4qDxGCQ5RjfE06FUrZ6ns9yeGxGQeOSM5RG91NQdqBFy8
	UNijYpzXlvBIQeROFj4a0v53rXOA4jYFLePUsM7Sa24WPCkkBVgMdu7RfSylu1PFy6y+GT
	C6fD6N4jtEmfbcyduhUhmpDUbtoAdxE=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477c49f273fso24026235e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159160; x=1766763960; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lGbYnpIDd95/4deu1O5Gyvn5GxdfmH9SCDxje2/Aqi4=;
        b=HE5lZlC4rwBIz1Y226iJQKymWp/sb6YKeO6BqVqe+jeLSvdczV6zRDztINivdbQkF1
         OC4a3yvOKG5U81XXQ6jsGWhv34aFjZUsMEro0IT0AxXbPJMCvwgW7JLHfLO3FfIEb1op
         wlkZuYevLk7uk/ejSKxiO0we1jLh3IyP1XLUon2rd7mJZXYqx0i6EsjQ8sVnFZtP95zV
         +YTafIU/1IUHv4DbOxELZ28Wjc3i1PklOuadjOroQESZ2FfyuI/gU6Vmk0mfan3SGXfR
         NecYvIHn33ccwiZUndSrLK7Yxnk4l2L4+6D/aYpDzF4Cu0qnmaWgZpZJPmnTUPwJ48XU
         ThTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159160; x=1766763960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lGbYnpIDd95/4deu1O5Gyvn5GxdfmH9SCDxje2/Aqi4=;
        b=YejEdZV2BDUbjrm9+bC1fov8KLGo0M2+GpzJHDK8Fo3xx9r34ZurUunQhacbOpFZEh
         2D1vBNxbpB0tl/INHQhzuaMsV8sahmwb0xn1Kr6Q9mp/Nkza+4rQ9AuhnEQB5nwOgMkl
         /BGfkMNRnAvsa6shGh1zeo1DgywhIddETo2TtupcDibUdOoFIZwGbKJtjw5uYz7DRHPe
         9prenAUYVDSTyCnYCkPZutwqiCzk+Sq5/4aGMYnjiaMMmvx4u3s4S2q5NsTwozEkbTo/
         VH+RQU69zIIxI+YFbMZN5Oxioh3AnYNId4oKnwRufoTDvkTL+71AEnn3CkjkrOUgSNmo
         dDZw==
X-Forwarded-Encrypted: i=1; AJvYcCXIoNU4BykCrh7YErtn8LYA2T+0jYqnGR6r8jLbzFQ1YWY2az1hCgZg1B4A97qY6kgQpiVT3nleqw==@kvack.org
X-Gm-Message-State: AOJu0YwHk6Zo00pN9VcCQTd3U9sTVZUEQT1h6rKyBUvTrFf51t1cOQFr
	FLBN41pWC8vbW8rlmmQFb+DUgVQKrVLQ/wxc0QBuPbwibS5U/ivYqZNcB/omvmnKVA+d9+M4XlS
	qdA==
X-Google-Smtp-Source: AGHT+IE1XZ3lv2u7wAuVsmDUYfED9I82A9YF3FTOwvCA/weTpzb3iuyTGf96w55msyALpBkixRUmT0AdYw==
X-Received: from wmma6.prod.google.com ([2002:a05:600c:2246:b0:477:40c1:3e61])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b12:b0:46e:1fb7:a1b3
 with SMTP id 5b1f17b1804b1-47d19595fcfmr36884125e9.23.1766159159900; Fri, 19
 Dec 2025 07:45:59 -0800 (PST)
Date: Fri, 19 Dec 2025 16:39:58 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-10-elver@google.com>
Subject: [PATCH v5 09/36] compiler-context-analysis: Change __cond_acquires to
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
X-Stat-Signature: p5xwyaex9z8w8yrsbqutdfbf4spkx6nb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8367B4000B
X-HE-Tag: 1766159161-160460
X-HE-Meta: U2FsdGVkX1/GcSq/3vCHLfXYp6jt6HH1bbqniokIP84QZSwMSZyvI/fdjeI9Ep4/oJkDbvz8+pZos/nJbPjVqUPaRauReYb8CgSF+89HIKzwMU3dDwkIuh0HefmYLCAraUqKIi5ZATKH0299bAg2rH4BA9jkYNfoiwJkQdiNhVf1kGZYy3AlCgWjWvi9P4NeUbHtbrRMeqVv6uvwqfL/e1r1eYF9rKN1hsPTeWsd9myqQ9xzH6YfPpEaJZu9Yh/lUYUL2aVBDQzgzmidY/2OoOskKdbfMhu9qWMBFrTKtDLT875SOvyz8qY4BHOVw3oxI778tEr/1NeH9o6jBCPdknRdASgCn33mejLDI6B7BwTWw86t4O+Q0mheTQc0NsActulHLx+WIQjNUDPddISk3gs9gyq2Tbbm9U7cA4fwSHrSvdjuKygr9E0P8mCeOQMrEPUK2j8Gi9GQKRfVueC3TNP0XuURL2d100kKpRi8RSBgBojZhlxm71FwCcaCTJKKcp6mkNyZ8t0l+vwe8Y+38x+P6u/1aXMF/NSTo8RMSOyo8jPBWpJlvW41va16/G7vzpnKug0XtM52lu+SCpg2HalqxyQYBNdFjpfy2fxgaV6oHTziEWSZ28QZJ32hh3mJqtW7hVEFSna+wMmET/g0oeKqs9J75IaUr4QOj0qY2n13GeAcGzKslnvTC9TDnjNjUY2WPM5bVwEX4IeLQYa/e7d17u7R7izmhbVP0mEWpiwbJFHa5DmAIiSuQ141hHoZMs7qwj/+dhmIPmbCaQVqBbBzb0npHxhYsooveZSPh/U4DcpQDQkcpkDgZsmYYmjM1d4rsrGPB3v9cQQmfuJhbECGs8F7B7fJhT4TnJBja+SCGIbWMEyMhPyd6tEboz2mOfFCP4dPPehEVht1KmlwuWI7+1/W2BuuTgfsGJkQfiwMNZ/s3J6KVcMYyD+xYwoIa8f8HdNDRosRbyomnBy
 q0zb3fCV
 bBRDAXXvEBj1bg5tv4UGGJ9FtFemJ/yFYFcsYVjtYRwTBCYkB4/6X2t2oO61pvgDSH3w/hx95A35qLvDppaO02kDTyecXva+Lj0x4sFJ4VV/60xOMBe5MwE3jHE9x7BrLCYu5kzOPnO7DwgBnPE5KCHUSB6TBBNJJzJphj3H1SADaAdbZdpEVwvGvmUN12BRWJ1hJTL9B9kKsD0fUhNz40aDhC3AUVBh6rrRTe1uwVkRPE97wYS5efbOvdAfITulq4VeLD4z1r4c8okv2XVkKwq1C4hxa+Ifofr2hN7y3RX413Oq5yUoeziU2fqOXzzrxd9vfHQt35KhA7WMOkTW8pbHsUXNllxFtQqwO4BVIlvxC3DjjXpQIn7CT3ByAq7f+2CYQ5zeLsxjSVjr4y2xH2bMPhYHgql833A5/Ag+O4b7iJdjbv56Jj2uW7VK7ZLqVettZfp8Kiwl5LD91lr+XmUp58+wuKG10rt1ApS6A+kOfFk6d/EzPAkK3QgR15tnF8AzkT8BGtzty72KxQItHZts6JGlTsrpKMzPewK6azvAmYoh3sQIrWsnkI5YcMQEomVuzCNIH+ThenAO5DGbtYpO6MFttoRJNRbBxkwWWUtJzMJ3qhZ/FK0umjHTCb5fBnnLcJjlp+vmtmRF+1f2pkgFlk/RSrjCpBbwr0Mt+EKtrqy8VGxtPba+IUS0A+I3E7a5wSKwmBFLPd2EPfdKtlcyrRvfKfuTcaK6KTByxGJkxG9mzl3GGCtRkxA==
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
in a later conditional branch, i.e. 1 ==> context lock acquired in
branch taken if condition non-zero, and 0 ==> context lock acquired in
branch taken if condition is zero. Given the precise value does not
matter, introduce symbolic variants to use instead of either 0 or 1,
which should be more intuitive.

No functional change intended.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".

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
index afff910d8930..9ad800e27692 100644
--- a/include/linux/compiler-context-analysis.h
+++ b/include/linux/compiler-context-analysis.h
@@ -271,7 +271,7 @@ static inline void _context_unsafe_alias(void **p) { }
 # define __must_hold(x)		__attribute__((context(x,1,1)))
 # define __must_not_hold(x)
 # define __acquires(x)		__attribute__((context(x,0,1)))
-# define __cond_acquires(x)	__attribute__((context(x,0,-1)))
+# define __cond_acquires(ret, x) __attribute__((context(x,0,-1)))
 # define __releases(x)		__attribute__((context(x,1,0)))
 # define __acquire(x)		__context__(x,1)
 # define __release(x)		__context__(x,-1)
@@ -314,15 +314,32 @@ static inline void _context_unsafe_alias(void **p) { }
  */
 # define __acquires(x)		__acquires_ctx_lock(x)
 
+/*
+ * Clang's analysis does not care precisely about the value, only that it is
+ * either zero or non-zero. So the __cond_acquires() interface might be
+ * misleading if we say that @ret is the value returned if acquired. Instead,
+ * provide symbolic variants which we translate.
+ */
+#define __cond_acquires_impl_true(x, ...)     __try_acquires##__VA_ARGS__##_ctx_lock(1, x)
+#define __cond_acquires_impl_false(x, ...)    __try_acquires##__VA_ARGS__##_ctx_lock(0, x)
+#define __cond_acquires_impl_nonzero(x, ...)  __try_acquires##__VA_ARGS__##_ctx_lock(1, x)
+#define __cond_acquires_impl_0(x, ...)        __try_acquires##__VA_ARGS__##_ctx_lock(0, x)
+#define __cond_acquires_impl_nonnull(x, ...)  __try_acquires##__VA_ARGS__##_ctx_lock(1, x)
+#define __cond_acquires_impl_NULL(x, ...)     __try_acquires##__VA_ARGS__##_ctx_lock(0, x)
+
 /**
  * __cond_acquires() - function attribute, function conditionally
  *                     acquires a context lock exclusively
+ * @ret: abstract value returned by function if context lock acquired
  * @x: context lock instance pointer
  *
  * Function attribute declaring that the function conditionally acquires the
- * given context lock instance @x exclusively, but does not release it.
+ * given context lock instance @x exclusively, but does not release it. The
+ * function return value @ret denotes when the context lock is acquired.
+ *
+ * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires(x)	__try_acquires_ctx_lock(1, x)
+# define __cond_acquires(ret, x) __cond_acquires_impl_##ret(x)
 
 /**
  * __releases() - function attribute, function releases a context lock exclusively
@@ -389,12 +406,16 @@ static inline void _context_unsafe_alias(void **p) { }
 /**
  * __cond_acquires_shared() - function attribute, function conditionally
  *                            acquires a context lock shared
+ * @ret: abstract value returned by function if context lock acquired
  * @x: context lock instance pointer
  *
  * Function attribute declaring that the function conditionally acquires the
- * given context lock instance @x with shared access, but does not release it.
+ * given context lock instance @x with shared access, but does not release it. The
+ * function return value @ret denotes when the context lock is acquired.
+ *
+ * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires_shared(x) __try_acquires_shared_ctx_lock(1, x)
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
index 72aabdd4fa3f..7e560c7a7b23 100644
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
2.52.0.322.g1dd061c0dc-goog


