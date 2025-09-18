Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1552CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88BA28E0126; Thu, 18 Sep 2025 10:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE808E0112; Thu, 18 Sep 2025 10:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B6C8E0126; Thu, 18 Sep 2025 10:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9588E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:05:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AF4F1A01F9
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:55 +0000 (UTC)
X-FDA: 83902544670.05.FB363F8
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2449F10000F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0r2s05oV;
	spf=pass (imf14.hostedemail.com: domain of 3vxHMaAUKCGACJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3vxHMaAUKCGACJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nuqSkrvcyBiCelh3qy9Lvs4g4xmbG9dFvEFi0HZqJaY=;
	b=NIV2z298q2UQdJxTTZ9gN69hxosh86J6QraOW32jqEECQSLMrf3/JggHc6PCMQ+P/+31Xk
	AJ/KH0H/FWYF3xVXZ9e6x8BpJEa+mEj3BI4xBnBWYom/N4A3X8obN1wnA1tBUnufgJxY/m
	6VPCnkJ5lANX4aelkVO578YoL3GOxBs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0r2s05oV;
	spf=pass (imf14.hostedemail.com: domain of 3vxHMaAUKCGACJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3vxHMaAUKCGACJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204353; a=rsa-sha256;
	cv=none;
	b=SkvEJLgkbpF8IJi0gj/CEMzLHVRWalhVVjPXm/540Yk4aIocMHQRr8pH8jDnpF1QJm/4GX
	9kVg1v2sgHHRsr+ElEVPhISMkWyq2SvORdTKer6XKdwobXZajelCNomcft4SIzAd9yAiys
	Lu01llJ1NNRISIog5efxCSeNoDKkwcE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45dd5c1b67dso5228755e9.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204352; x=1758809152; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nuqSkrvcyBiCelh3qy9Lvs4g4xmbG9dFvEFi0HZqJaY=;
        b=0r2s05oVspQUTzcMrTGnTapm+1KKwqORQh4XEk0u9sgegVzj99lvod3BK0a1lKLEQT
         rrJzQARJ6whcrzjx++jPJOAbj4/IC168Se0Q88qz3RNKH0MFlwZCzieYUxwcYFrH4N3D
         VHwMQmkJT7RCk0ilSAHGoaa+MRbc5iXH2wbf3Cfpu9D+A7co7+sl3VnH9AF1+Y+zqTHN
         OyhhUKWeQ1I42LtD4H3uovs60ERneG6KHIhV+6yjeYZ4xQFp8usXz4LSuDCPiDMln6Cc
         TLi80nhvovdic+IBFM6oHf3Dp6nwYNKkKCp7QV4el2yjuEcAelGqMDvYiSNTpW6GGPcy
         K2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204352; x=1758809152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nuqSkrvcyBiCelh3qy9Lvs4g4xmbG9dFvEFi0HZqJaY=;
        b=teZXeurCMI3BuBcSUgDnMgeS5ypLHya0wH2BTndrulGwjlaIiMDn7CTlCGZH5QBJkD
         aQDbCtvHQ11AtOf1M94hRKwsOzLw7NEwEtqtGESb1jVBkpOXhj/7MkzS/SIKp7PwBYpn
         odu8y4/qZvDxJbb4DYg9lQkH+e2rQx5ORHc/vlFgSnb79tIPEbEN4dRXUD2hGxHkLp0G
         6ydVZGrgV0jh4d4PfxogP9vO28Zi12KZdcL28y7EheCaVt4liv40UpC3RoJiYB38+msy
         ue3gJPHCJMLhcRIuJh4DOEv18gW3DQCV1Pk+ujue/sC7QhY8MnycpEIEVwleDY4TIdnM
         UPEA==
X-Forwarded-Encrypted: i=1; AJvYcCWYDMuxCdy6Uxw5xQHuK5NFVdycdrmq8ihAhiZ6kN/ZXjldjtEySFPVvIm1q/3ROQzqsWT5njj9SQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7zQiaL2T+vCstfuGDX/mlwnvG7AWfb4/UbJzUwiDCGyaaLYTe
	dZbwXf2atc0+ADW5KzC+EHmKNezD3iEzJoXbeXvmuydglfZer/T2kSie8PQAL2NHQLssoosQfNE
	SeQ==
X-Google-Smtp-Source: AGHT+IF435EaYj9QOkVVONM/Z5req1TBTUn68AIXoCLck44xbDbumagGLsryOoXIfDIIAoYxf3pjFWvtTA==
X-Received: from wmqb22.prod.google.com ([2002:a05:600c:4e16:b0:45f:28be:a3aa])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:154a:b0:45d:f897:fbe1
 with SMTP id 5b1f17b1804b1-46208321e5fmr56432605e9.32.1758204351462; Thu, 18
 Sep 2025 07:05:51 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:20 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-10-elver@google.com>
Subject: [PATCH v3 09/35] compiler-capability-analysis: Change __cond_acquires
 to take return value
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2449F10000F
X-Stat-Signature: wyekn7kedxfqfcn758aaptqf3mgaab6t
X-HE-Tag: 1758204352-660274
X-HE-Meta: U2FsdGVkX1+BDR9Gnj6sU/sNjOkpW/FYflTpT5amlEm5OTzkfyLyA3RmsXVEyQpSY/WJtWbhvZwhjpau8JxwJzrUqwV2pkLF6KlboMa/80V23gHAW9mazKUuhnzEsdaWl8aBxrjfJl7cLeJ5VUfkuJU8yrNog/eFUnSFEO4gZURvhopJwzsxrKZoKPV2bd99QmXeYUvhp3NrhugOIZOPkbjOY7515rJaAwW+LaKhrPvOkJyVW2doVFWGUTUxXuyONOcilILxEXK7yxIrXONpmHBaR5MPq3qJOGNwkwR+B0VAk3vi0XK5H3lzB6jPWYu2yHlIeBHF/ktWYnPFdKQ5BZGL7OgxfNN5NsPJmIbVOlplvKsX6O0lGO1VOkcqoSIA5vdDI63XwPOkQqNf2QxZNXlCK0wVOWnqz4KBBMrz1U1j9ELS5dZ+Kd3nAkClVPimqLRzZaGdENoHxESpv2kOnzfMFtzwqHU5WQGjqQLM2oHaT7Bs/aWkOeyvWCGDlTgFXTOYtPkXWtI4ws9aqaMBjq1Vej+ADk+YZumSrIEcfSKiXeOxySq0kqu2YclYMCi1olGz08PpcxZwezx04h+q1uMI2Hne/xH+lRjb89s8RatkyhWlcQufwF+2XJ5iaCQCXMB5RADbrwxugsFO+E1aT5dr5kClDM7GVNPGgjJ7d/6AIkVwRlbm52KUePQz+0dBmBV0jRZq8bfQWVfjuBXb3Op/CZanDVr61/qKJ8Lzw0dI1HPi4p1DUM1rG0yW+D4P2zQ8lxADLITNd0kefnIzD0gcdGWQ+ctYaTdMzLHeM2XDaJ4GyQTudSvx9fc6FQ6PDlQnAZfqPGiTpqSxFBqry4w8G+5ikWbU5YnPzWnUbbzvWtXGpvK7htrM/tflgftn1dJOHO0vgJaGK6m7+5q/t8MjjMcvWsBOHq+oWmL5oYpyijKsb+Gt+mDvI6b2cZlELK8D3SHKJ68WwD3wMOj
 44gMq+EI
 P/WHY8Ov7PCfhww8pjYIIM06bmmcMDUY2u2UFWH0DKPYOTeyLPfB7F5k//yE2N4NhQkigOmAv00hovw6FWJhCEcBuXLk9A9dzOQtC1+4RFS9b19b4SZBSzqIoQXhQITFCb3hQjbMwA7xVAZirPeE+p4FpA3XilTFQyIM5wVPqguhkF8VmnZ0q18QHsmCg7IJUoFFp5RgaVKjbfYQzpL9SVabXwAeiDVUx6TWkdh6/7X2IrQA5qZwGatMAaN5Z1LG/o6NBM7rC0ym8NtAq4/lckKgoVEnsZMxyLkPudEImBujQhALIk8slmRkvgzvJOa/RSMQS7Cl3KLkcrywx3XHmGp/3eiQNqRhKbO3l4ghzhztMwZEmYNNnCKc9L99tSD8xxZanVB5puUcAQPMJD768MBK00Vb7AEy3EHH+gg+Kv/25ArzgZzyz9kqsfvk0cru3xs1ONzLTz0sXU8fxl5oKnm5RO+SA6lRXhQ6mWyY0/slVsq0GeA9jHFiUEtdrCxLYV3cN7zm6AZkC6Thm7W5oAHoobuph9xPzDJH66NoSDamaYFIXEXoCgfKhRLOOqkBACykvoFiO/otZMQZsfzO+vus7Mnry8SHljfkoOz+gbylh4vE+xGCgra/frOqsqqbskxTrRWSIDlcSqBuYSqSsQmuT+TiKHrLD4JWIKXfb1+gKpf6n2au1PlWXj9PjuWlIL5ww
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While Sparse is oblivious to the return value of conditional acquire
functions, Clang's capability analysis needs to know the return value
which indicates successful acquisition.

Add the additional argument, and convert existing uses.

Notably, Clang's interpretation of the value merely relates to the use
in a later conditional branch, i.e. 1 ==> capability acquired in branch
taken if condition non-zero, and 0 ==> capability acquired in branch
taken if condition is zero. Given the precise value does not matter,
introduce symbolic variants to use instead of either 0 or 1, which
should be more intuitive.

No functional change intended.

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* Use symbolic values for __cond_acquires() and __cond_acquires_shared()
  (suggested by Bart).
---
 fs/dlm/lock.c                                |  2 +-
 include/linux/compiler-capability-analysis.h | 31 ++++++++++++++++----
 include/linux/refcount.h                     |  6 ++--
 include/linux/spinlock.h                     |  6 ++--
 include/linux/spinlock_api_smp.h             |  8 ++---
 net/ipv4/tcp_sigpool.c                       |  2 +-
 6 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 6dd3a524cd35..006eb284c8a7 100644
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
diff --git a/include/linux/compiler-capability-analysis.h b/include/linux/compiler-capability-analysis.h
index 6f3f185478bc..ccd312dbbf06 100644
--- a/include/linux/compiler-capability-analysis.h
+++ b/include/linux/compiler-capability-analysis.h
@@ -257,7 +257,7 @@ static inline void _capability_unsafe_alias(void **p) { }
 # define __must_hold(x)		__attribute__((context(x,1,1)))
 # define __must_not_hold(x)
 # define __acquires(x)		__attribute__((context(x,0,1)))
-# define __cond_acquires(x)	__attribute__((context(x,0,-1)))
+# define __cond_acquires(ret, x) __attribute__((context(x,0,-1)))
 # define __releases(x)		__attribute__((context(x,1,0)))
 # define __acquire(x)		__context__(x,1)
 # define __release(x)		__context__(x,-1)
@@ -300,15 +300,32 @@ static inline void _capability_unsafe_alias(void **p) { }
  */
 # define __acquires(x)		__acquires_cap(x)
 
+/*
+ * Clang's analysis does not care precisely about the value, only that it is
+ * either zero or non-zero. So the __cond_acquires() interface might be
+ * misleading if we say that @ret is the value returned if acquired. Instead,
+ * provide symbolic variants which we translate.
+ */
+#define __cond_acquires_impl_true(x, ...)     __try_acquires##__VA_ARGS__##_cap(1, x)
+#define __cond_acquires_impl_false(x, ...)    __try_acquires##__VA_ARGS__##_cap(0, x)
+#define __cond_acquires_impl_nonzero(x, ...)  __try_acquires##__VA_ARGS__##_cap(1, x)
+#define __cond_acquires_impl_0(x, ...)        __try_acquires##__VA_ARGS__##_cap(0, x)
+#define __cond_acquires_impl_nonnull(x, ...)  __try_acquires##__VA_ARGS__##_cap(1, x)
+#define __cond_acquires_impl_NULL(x, ...)     __try_acquires##__VA_ARGS__##_cap(0, x)
+
 /**
  * __cond_acquires() - function attribute, function conditionally
  *                     acquires a capability exclusively
+ * @ret: abstract value returned by function if capability acquired
  * @x: capability instance pointer
  *
  * Function attribute declaring that the function conditionally acquires the
- * given capability instance @x exclusively, but does not release it.
+ * given capability instance @x exclusively, but does not release it. The
+ * function return value @ret denotes when the capability is acquired.
+ *
+ * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires(x)	__try_acquires_cap(1, x)
+# define __cond_acquires(ret, x) __cond_acquires_impl_##ret(x)
 
 /**
  * __releases() - function attribute, function releases a capability exclusively
@@ -375,12 +392,16 @@ static inline void _capability_unsafe_alias(void **p) { }
 /**
  * __cond_acquires_shared() - function attribute, function conditionally
  *                            acquires a capability shared
+ * @ret: abstract value returned by function if capability acquired
  * @x: capability instance pointer
  *
  * Function attribute declaring that the function conditionally acquires the
- * given capability instance @x with shared access, but does not release it.
+ * given capability instance @x with shared access, but does not release it. The
+ * function return value @ret denotes when the capability is acquired.
+ *
+ * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires_shared(x) __try_acquires_shared_cap(1, x)
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
index 7679f39071e9..22295a126c3a 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -362,7 +362,7 @@ static __always_inline void spin_lock_bh(spinlock_t *lock)
 }
 
 static __always_inline int spin_trylock(spinlock_t *lock)
-	__cond_acquires(lock) __no_capability_analysis
+	__cond_acquires(true, lock) __no_capability_analysis
 {
 	return raw_spin_trylock(&lock->rlock);
 }
@@ -422,13 +422,13 @@ static __always_inline void spin_unlock_irqrestore(spinlock_t *lock, unsigned lo
 }
 
 static __always_inline int spin_trylock_bh(spinlock_t *lock)
-	__cond_acquires(lock) __no_capability_analysis
+	__cond_acquires(true, lock) __no_capability_analysis
 {
 	return raw_spin_trylock_bh(&lock->rlock);
 }
 
 static __always_inline int spin_trylock_irq(spinlock_t *lock)
-	__cond_acquires(lock) __no_capability_analysis
+	__cond_acquires(true, lock) __no_capability_analysis
 {
 	return raw_spin_trylock_irq(&lock->rlock);
 }
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index fab02d8bf0c9..a77b76003ebb 100644
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
2.51.0.384.g4c02a37b29-goog


