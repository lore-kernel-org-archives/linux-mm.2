Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BAACCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E27E8E0133; Thu, 18 Sep 2025 10:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D2C8E0112; Thu, 18 Sep 2025 10:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2E38E0133; Thu, 18 Sep 2025 10:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 639D78E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B715139CEA
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:30 +0000 (UTC)
X-FDA: 83902546140.23.CBE162F
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 256364000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3OLxbmi1;
	spf=pass (imf17.hostedemail.com: domain of 34hHMaAUKCIMls2lynvvnsl.jvtspu14-ttr2hjr.vyn@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=34hHMaAUKCIMls2lynvvnsl.jvtspu14-ttr2hjr.vyn@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3E29rPCnN3EjGw7BZaVdq2KLgeK/DgzeRknIagImVk4=;
	b=ejdGMh4Kstl/Ze+OMjk7TztTHyu6D8ZuF1oAldhz8gfndPZVl0zlSyW00r1Nv0FK9IQyL3
	9PS4ESg+QU9vFly4//TRhIhzvvw/w3FJbq+iuS/PArXrCIJIIvGUEai2h2uP2z+EslXvS5
	iYApUVagIiHwpwXW6SngDiheC+573OE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3OLxbmi1;
	spf=pass (imf17.hostedemail.com: domain of 34hHMaAUKCIMls2lynvvnsl.jvtspu14-ttr2hjr.vyn@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=34hHMaAUKCIMls2lynvvnsl.jvtspu14-ttr2hjr.vyn@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204388; a=rsa-sha256;
	cv=none;
	b=DbVeefcSdAHU//KuHKY5T/HuIEI8HSSyUAtmJierdDlJZCXIvJFm5uGIOYXz2+n7NMDeJ3
	GQkuEhdY1r12BdkjhfTMQfyeg7WwvctmLXBvW0BPEqZIJg07krDLyf1NsWohTcFB0FkzTH
	nivJnM5ZmlM06uUtl9sdTaWsSgbM4VU=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso765917f8f.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204387; x=1758809187; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3E29rPCnN3EjGw7BZaVdq2KLgeK/DgzeRknIagImVk4=;
        b=3OLxbmi1eM/6Z8uR73XfpViQcD/HpHmWbHz9hcqNTELUZTxk9IlCR7X+WBTXbJ6In9
         XG9rh3nAqp8l/2lGCfXED6ow1koe+bQN+H7ZD4I8VHtd2lkRYc60XDm1/3TFOt21UoEI
         1Ugs9vyc+UO3I9SeXD3QSmOXHNJu4f2pqFFmTfLuOUysaCB8MVz265tst4IljvIzvu2S
         r+mLeF74CnAR51uqVsE4R84NyFwuMpmFMKWCmNoyFleDK6fcXmQUXJIUei0T3LYTth6n
         IsDFO3lgJJE8zNfa+1UOMka4EFiPJ9k3qCuK5pBDYAC/RLvvN2Q76ZjXsSBcyHF9NP14
         6rRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204387; x=1758809187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3E29rPCnN3EjGw7BZaVdq2KLgeK/DgzeRknIagImVk4=;
        b=oiejoYx/o1AgKoPnWO8p2OOncT4GNdlQ4++xqamfUE9DiVSGdPCUYx2PE0SU0Nf+Yw
         dNs22mNDWqyhnTDgu9nY3zSMr1vvpNzqoaI2E9oA6zMdMSAdseeV06fvdvaX+smNCV3j
         WYuVFe3Uq67ezGwMRhhAcL1O+o0ixAgZMEndYECLIPOUOnQC6KWEgfvkg+Ho76LCS10F
         Jufq4irb6XwIjkDlI0s3a0jQNcHMIhaIUigajHSpWSsxt5MHN3VqzJXkI5PUi3a2/zwX
         E8sSGStt7PdbiPeb33AZCeJxz1WwcD1u8Id+SrGUDsJ5Pa5GVeZ8ZdLBjO/qPww42TQP
         vKcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIbjduYsBO9UC1DR1LcP3EiMcTGsYgSBBRu9Y0/17rsfuN5WRbtK0GqtQQENxpE+c234ccBkD3Lw==@kvack.org
X-Gm-Message-State: AOJu0Yx8Cpww96UzpUFftlsULFAgWqaD8470+WfplyW30QOYUItKTKTM
	iMhu0AZOaAoCzhmlwmIHsmzF1anxsHaqGimOHE9Cy9F5LTwauG7KhGbIMw4raeQ49oAU5MQjun/
	rDg==
X-Google-Smtp-Source: AGHT+IFHOcMXLGwqrVjcBRy1JE0YXyKuRo6WKOASUxR9vb7h90q+XczVWS1fXy1SoT97a7/Imh/y4s+FnQ==
X-Received: from wmben15.prod.google.com ([2002:a05:600c:828f:b0:45c:b62f:ca0d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1887:b0:3e7:615a:17f6
 with SMTP id ffacd0b85a97d-3ecdf9ec859mr5220873f8f.28.1758204386463; Thu, 18
 Sep 2025 07:06:26 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:33 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-23-elver@google.com>
Subject: [PATCH v3 22/35] compiler-capability-analysis: Remove Sparse support
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
X-Rspamd-Queue-Id: 256364000D
X-Stat-Signature: ukjjsw4et87rdhnufhs9jgcdbboers5y
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758204387-964907
X-HE-Meta: U2FsdGVkX1/WvEXlSa5bq08wwyeznlbmb/BUdci8gvU0eOX51k9Kpluv/25FVr4mDhN+vtjoO1YjViCTAsiidN9svMuVJmRcFVAFMJu49NXLykz52sxWadLVeGimd6UUde0U3uAq+icAzS35ScvO6TjQ5Nlk9WxRWyKsgUYSTPCs1p2zTH2YhG+YsMgYrSDpz/R6khn+qn8uVbEd58Au7Si8gBnpF3GwRm5dI1wUEUbZr9MbnxPBRMZ/4PXoEhpcztUhh8EATWUI6fKhajxklu5wvmr81VBYha8r0bwbmyj0MfNg+5RJxwBHmZFfCF8USNr475dSZnm2LR66kC3SIKWi9o3DYlBXN3qF3pPBYb4uXVtnCKEsiQFKY20keXKVqjaM+u+kxkgtLsgJKvLpzUQ80mdOnArErsUDufqxV5ahox/OuHqBUPh3jWkPjUlLjSl3cJbLJiHM6D01V+eOyle+tgjBJUPGPG/ETLv8V/a27Z5iXfZ1ejoLQrS2Vngg/laND5umz0o9M8iVxsZ9hgSp3lwTiZR4EvzZbeOGrh6chEAbQwc2rPg345Gvg0dYzoWtpboBZtA5bKMbSONSzIyWmPj62Uu4x5eUAXFPYFKaf2IzLJ4rQJ9n424e1RKGTS0NISatpGJqVloky0Vbhn01UAMFZOCtpWYPdBwwVPDWhDEMblBHCWmug1Qt6oIQZrpT2FlW58rSRIRG4xWWIuDDqx2OvEvaU3HkuI+dfowI0VffXOoky95hnf65rpBlTr6MVWR4OD6zvYLOsZbJ6PNFTvzalQQVXKPidP409Dynlt5LswMaR2Bhz4OLL64xL/hmjCbZM/zg6r4GLE2QMdbwUsSx8qhsV2MTYitpZ3i5Q5+hczo/wy9rq/w/LEfzjhe6O8uvoQyBJcW9ScYMo6mCoh/hYLrtJYD8vaALNtb86ix5GpgTk4sUAe5E3JNWb0mO/REmZTB0nKdmjni
 SOwr07QZ
 S5tyZzbD10HClzfFKO8R63strD5/X0T2HfcQ2UdnprdqDiuBCHQLRIIMTUonFPc5SNh1TOWWid8pUBLzN2XuzO/EqzZJfNxbFCT22RzUctZhDGmQdtoQGcdxBYwygyHbqDSFZvawjJJqrApB4G9Xb1y2FWHZjyMbonmT5P0htdfDtZ7KgVGGPZHrZNDgWAGCWFt0tELekAEJdbXwh1zB7stl4IR6G006gZLNBj8EPNAP2dUmb5h/Q/HkbjqcjpeHIfBXPdgGw7jBIOTD5FfC7b5cwAI5IuELYPDAUA0IKDrao5uWeD6ANRQ3ylnKy7gWl6qEc6dhhkJyARhrpJpcnsLX7g7ubNoylU4BvpviubUcSXZHnTnCavvsJdC8CAjp5gonlj4JpwVB6drGXnfwAIncT+MbbEw73+1m8UeBKCA11HxkNPSl3TtBsL5zJiKzITlWzf8+2Ibi+FfPm0Tw2a+WBIGj6tgzEaYd90vQQw5Kic8TBWP2qpVpgU5vO9v2PNo4FQY40kgKkiPPSCNsrPWMZFeixJ6loa2BNUQ1RVeBhYY7/M46C6q5nEWqRqZGA9NiYTi4inwwoC4M4n9rORIjapBlm+/CYvKScp4Tq19SUEaatl8svxGYwLuUQYcz5cD0En3NBfYouRjhH2unf+OEd9OZhdJm94dTJ/YWEosNSEq9a2gu+xHeaShmButYeSd4paGZT0IW+zePkcY0IH4aDBUHr0WeJwFw26uiAXf+XeTA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove Sparse support as discussed at [1].

The kernel codebase is still scattered with numerous places that try to
appease Sparse's context tracking ("annotation for sparse", "fake out
sparse", "work around sparse", etc.). Eventually, as more subsystems
enable Clang's capability analysis, these places will show up and need
adjustment or removal of the workarounds altogether.

Link: https://lore.kernel.org/all/20250207083335.GW7145@noisy.programming.kicks-ass.net/ [1]
Link: https://lore.kernel.org/all/Z6XTKTo_LMj9KmbY@elver.google.com/ [2]
Cc: "Luc Van Oostenryck" <luc.vanoostenryck@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* New patch.
---
 Documentation/dev-tools/sparse.rst           | 19 -----
 include/linux/compiler-capability-analysis.h | 80 ++++++--------------
 include/linux/rcupdate.h                     | 15 +---
 3 files changed, 25 insertions(+), 89 deletions(-)

diff --git a/Documentation/dev-tools/sparse.rst b/Documentation/dev-tools/sparse.rst
index dc791c8d84d1..37b20170835d 100644
--- a/Documentation/dev-tools/sparse.rst
+++ b/Documentation/dev-tools/sparse.rst
@@ -53,25 +53,6 @@ sure that bitwise types don't get mixed up (little-endian vs big-endian
 vs cpu-endian vs whatever), and there the constant "0" really _is_
 special.
 
-Using sparse for lock checking
-------------------------------
-
-The following macros are undefined for gcc and defined during a sparse
-run to use the "context" tracking feature of sparse, applied to
-locking.  These annotations tell sparse when a lock is held, with
-regard to the annotated function's entry and exit.
-
-__must_hold - The specified lock is held on function entry and exit.
-
-__acquires - The specified lock is held on function exit, but not entry.
-
-__releases - The specified lock is held on function entry, but not exit.
-
-If the function enters and exits without the lock held, acquiring and
-releasing the lock inside the function in a balanced way, no
-annotation is needed.  The three annotations above are for cases where
-sparse would otherwise report a context imbalance.
-
 Getting sparse
 --------------
 
diff --git a/include/linux/compiler-capability-analysis.h b/include/linux/compiler-capability-analysis.h
index ccd312dbbf06..6046fca44f17 100644
--- a/include/linux/compiler-capability-analysis.h
+++ b/include/linux/compiler-capability-analysis.h
@@ -248,57 +248,32 @@ static inline void _capability_unsafe_alias(void **p) { }
 	extern const struct __capability_##cap *name
 
 /*
- * Common keywords for static capability analysis. Both Clang's capability
- * analysis and Sparse's context tracking are currently supported.
- */
-#ifdef __CHECKER__
-
-/* Sparse context/lock checking support. */
-# define __must_hold(x)		__attribute__((context(x,1,1)))
-# define __must_not_hold(x)
-# define __acquires(x)		__attribute__((context(x,0,1)))
-# define __cond_acquires(ret, x) __attribute__((context(x,0,-1)))
-# define __releases(x)		__attribute__((context(x,1,0)))
-# define __acquire(x)		__context__(x,1)
-# define __release(x)		__context__(x,-1)
-# define __cond_lock(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)
-/* For Sparse, there's no distinction between exclusive and shared locks. */
-# define __must_hold_shared	__must_hold
-# define __acquires_shared	__acquires
-# define __cond_acquires_shared __cond_acquires
-# define __releases_shared	__releases
-# define __acquire_shared	__acquire
-# define __release_shared	__release
-# define __cond_lock_shared	__cond_acquire
-
-#else /* !__CHECKER__ */
+ * Common keywords for static capability analysis.
+ */
 
 /**
  * __must_hold() - function attribute, caller must hold exclusive capability
- * @x: capability instance pointer
  *
  * Function attribute declaring that the caller must hold the given capability
- * instance @x exclusively.
+ * instance(s) exclusively.
  */
-# define __must_hold(x)		__requires_cap(x)
+#define __must_hold(...)	__requires_cap(__VA_ARGS__)
 
 /**
  * __must_not_hold() - function attribute, caller must not hold capability
- * @x: capability instance pointer
  *
  * Function attribute declaring that the caller must not hold the given
- * capability instance @x.
+ * capability instance(s).
  */
-# define __must_not_hold(x)	__excludes_cap(x)
+#define __must_not_hold(...)	__excludes_cap(__VA_ARGS__)
 
 /**
  * __acquires() - function attribute, function acquires capability exclusively
- * @x: capability instance pointer
  *
  * Function attribute declaring that the function acquires the given
- * capability instance @x exclusively, but does not release it.
+ * capability instance(s) exclusively, but does not release them.
  */
-# define __acquires(x)		__acquires_cap(x)
+#define __acquires(...)		__acquires_cap(__VA_ARGS__)
 
 /*
  * Clang's analysis does not care precisely about the value, only that it is
@@ -325,16 +300,15 @@ static inline void _capability_unsafe_alias(void **p) { }
  *
  * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires(ret, x) __cond_acquires_impl_##ret(x)
+#define __cond_acquires(ret, x) __cond_acquires_impl_##ret(x)
 
 /**
  * __releases() - function attribute, function releases a capability exclusively
- * @x: capability instance pointer
  *
  * Function attribute declaring that the function releases the given capability
- * instance @x exclusively. The capability must be held on entry.
+ * instance(s) exclusively. The capability must be held on entry.
  */
-# define __releases(x)		__releases_cap(x)
+#define __releases(...)		__releases_cap(__VA_ARGS__)
 
 /**
  * __acquire() - function to acquire capability exclusively
@@ -342,7 +316,7 @@ static inline void _capability_unsafe_alias(void **p) { }
  *
  * No-op function that acquires the given capability instance @x exclusively.
  */
-# define __acquire(x)		__acquire_cap(x)
+#define __acquire(x)		__acquire_cap(x)
 
 /**
  * __release() - function to release capability exclusively
@@ -350,7 +324,7 @@ static inline void _capability_unsafe_alias(void **p) { }
  *
  * No-op function that releases the given capability instance @x.
  */
-# define __release(x)		__release_cap(x)
+#define __release(x)		__release_cap(x)
 
 /**
  * __cond_lock() - function that conditionally acquires a capability
@@ -369,31 +343,28 @@ static inline void _capability_unsafe_alias(void **p) { }
  *
  *	#define spin_trylock(l) __cond_lock(&lock, _spin_trylock(&lock))
  */
-# define __cond_lock(x, c)	__try_acquire_cap(x, c)
+#define __cond_lock(x, c)	__try_acquire_cap(x, c)
 
 /**
  * __must_hold_shared() - function attribute, caller must hold shared capability
- * @x: capability instance pointer
  *
  * Function attribute declaring that the caller must hold the given capability
- * instance @x with shared access.
+ * instance(s) with shared access.
  */
-# define __must_hold_shared(x)	__requires_shared_cap(x)
+#define __must_hold_shared(...)	__requires_shared_cap(__VA_ARGS__)
 
 /**
  * __acquires_shared() - function attribute, function acquires capability shared
- * @x: capability instance pointer
  *
  * Function attribute declaring that the function acquires the given
- * capability instance @x with shared access, but does not release it.
+ * capability instance(s) with shared access, but does not release them.
  */
-# define __acquires_shared(x)	__acquires_shared_cap(x)
+#define __acquires_shared(...)	__acquires_shared_cap(__VA_ARGS__)
 
 /**
  * __cond_acquires_shared() - function attribute, function conditionally
  *                            acquires a capability shared
  * @ret: abstract value returned by function if capability acquired
- * @x: capability instance pointer
  *
  * Function attribute declaring that the function conditionally acquires the
  * given capability instance @x with shared access, but does not release it. The
@@ -401,17 +372,16 @@ static inline void _capability_unsafe_alias(void **p) { }
  *
  * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires_shared(ret, x) __cond_acquires_impl_##ret(x, _shared)
+#define __cond_acquires_shared(ret, x) __cond_acquires_impl_##ret(x, _shared)
 
 /**
  * __releases_shared() - function attribute, function releases a
  *                       capability shared
- * @x: capability instance pointer
  *
  * Function attribute declaring that the function releases the given capability
- * instance @x with shared access. The capability must be held on entry.
+ * instance(s) with shared access. The capability must be held on entry.
  */
-# define __releases_shared(x)	__releases_shared_cap(x)
+#define __releases_shared(...)	__releases_shared_cap(__VA_ARGS__)
 
 /**
  * __acquire_shared() - function to acquire capability shared
@@ -420,7 +390,7 @@ static inline void _capability_unsafe_alias(void **p) { }
  * No-op function that acquires the given capability instance @x with shared
  * access.
  */
-# define __acquire_shared(x)	__acquire_shared_cap(x)
+#define __acquire_shared(x)	__acquire_shared_cap(x)
 
 /**
  * __release_shared() - function to release capability shared
@@ -429,7 +399,7 @@ static inline void _capability_unsafe_alias(void **p) { }
  * No-op function that releases the given capability instance @x with shared
  * access.
  */
-# define __release_shared(x)	__release_shared_cap(x)
+#define __release_shared(x)	__release_shared_cap(x)
 
 /**
  * __cond_lock_shared() - function that conditionally acquires a capability
@@ -443,9 +413,7 @@ static inline void _capability_unsafe_alias(void **p) { }
  * access, if the boolean expression @c is true. The result of @c is the return
  * value, to be able to create a capability-enabled interface.
  */
-# define __cond_lock_shared(x, c) __try_acquire_shared_cap(x, c)
-
-#endif /* __CHECKER__ */
+#define __cond_lock_shared(x, c) __try_acquire_shared_cap(x, c)
 
 /**
  * __acquire_ret() - helper to acquire capability of return value
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8eeece72492c..aec28e98d3f2 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1177,20 +1177,7 @@ rcu_head_after_call_rcu(struct rcu_head *rhp, rcu_callback_t f)
 extern int rcu_expedited;
 extern int rcu_normal;
 
-DEFINE_LOCK_GUARD_0(rcu,
-	do {
-		rcu_read_lock();
-		/*
-		 * sparse doesn't call the cleanup function,
-		 * so just release immediately and don't track
-		 * the context. We don't need to anyway, since
-		 * the whole point of the guard is to not need
-		 * the explicit unlock.
-		 */
-		__release(RCU);
-	} while (0),
-	rcu_read_unlock())
-
+DEFINE_LOCK_GUARD_0(rcu, rcu_read_lock(), rcu_read_unlock())
 DECLARE_LOCK_GUARD_0_ATTRS(rcu, __acquires_shared(RCU), __releases_shared(RCU))
 
 #endif /* __LINUX_RCUPDATE_H */
-- 
2.51.0.384.g4c02a37b29-goog


