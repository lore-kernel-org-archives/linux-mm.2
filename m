Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DADAECAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028348E012A; Thu, 18 Sep 2025 10:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F42268E0112; Thu, 18 Sep 2025 10:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E58398E012A; Thu, 18 Sep 2025 10:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCAD78E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 972B356ECE
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:05 +0000 (UTC)
X-FDA: 83902545090.30.75176C6
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id B9966140014
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2FT8c822;
	spf=pass (imf26.hostedemail.com: domain of 3yhHMaAUKCGsNUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3yhHMaAUKCGsNUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCWUNblN4U9kpWEcSaN4JvbXJbXAoJAUqhw7MiIdu4A=;
	b=noUzIeRB+uTs/9E68tVitw4s25nYvX488wNzitadbwPz6TzPm8VCfcGyP2wXio/Q0Gid9M
	QkNPnHEu96kSyV1kAGRkQtxcligvY0vch5I6WOeHqL4OMALiWt3ukTNj2ej1zE/ykZI1JI
	wx9xteCk9STTb4NrNbDfwrb6yZrYdew=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204363; a=rsa-sha256;
	cv=none;
	b=rYmu/uqAL7BYPCvIEyVXZo6FUzORFr6smqbJbvZ78n30f5W2yJcnFpAZt8IZHR/pie2b4m
	RyCvLNQPE3CQWGMWAe1iVcJFQBqzQxo94CNLr0tErLflwfDxkHnmlQ1dz74kqAbofv7kXA
	zKNohZAYNdxV1OaIPJDyENXNG0xiRqY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2FT8c822;
	spf=pass (imf26.hostedemail.com: domain of 3yhHMaAUKCGsNUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3yhHMaAUKCGsNUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ee13baf21dso516620f8f.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204362; x=1758809162; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DCWUNblN4U9kpWEcSaN4JvbXJbXAoJAUqhw7MiIdu4A=;
        b=2FT8c8226eXfbT9BzGtFt1yg9g5XAbMtrK3arWMCcQLJKQadNTvaxQRDBZcalcElc9
         vWpV1+SNr2OQGKW0L8A2YpiBGrQCdVsH3FlrzNGxBhLTpT9S1cbGBNFioXMfPLqQNvs4
         lUrQmS2KaWklfB/DR5JuWzjRqRVzOylT+g1RuLIMLmuozBDG6v+6d83SYGpsHRbVShvQ
         JIAgyGOdiSk8CBqBynB7KCz6Z0rur74Uy1na5Kli41gLVrLz0CZO6dRRt//GC9xm+ybu
         9mQ3i+hegXuVvHId0WsOPJDxX8eXeFAVwGqkAhADOiTHfnf97SqH3vrvOTHMXm4YEEmB
         A/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204362; x=1758809162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DCWUNblN4U9kpWEcSaN4JvbXJbXAoJAUqhw7MiIdu4A=;
        b=wd2sIgJanEBbL2GVPxUBpgXmOlPURVMMr0+WYtGzIdvV84UpQf2IUqRnu1Qi31E/TY
         xNhDKGUNAuQFHi37C0NTg3sry8spQmfea2ZSQ01NVybVIqnkHo8AStHU+cfYRHncw3Fk
         cOwtVOrQCWtztFlQlgSreVrfZRu3x50RK6ciKAPQcvabqLvoT3rTmUx+xH5KSesXPZV9
         ptawYKmn7wY+108pjG/gp9sWG9zd4xfg0mwcXMsw9S4fvlWvTAZ3NR8XBGsF8joegzLT
         +nT2/Y2E/gmY1DZAnrhXiARgvv/ngCJBZ3bfVH7ajvkbNNkpnYi/jKxKtWV5bNTlGCOH
         8vrA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ3h2H/npNuDEgvro0xGctGLJhXCw9qg6UdeNd8ttkUr7aL54HBO5/X2XAKAj7Sr0EsXuWtNLpxg==@kvack.org
X-Gm-Message-State: AOJu0YxvxsfljJwSMZAJ6lNE+GHqTFbI8ON05fpnXaulOoZ+7sXgdpBT
	T/ZTC866qV70lAQDINwvsX8fdekfJWNEiFp72iC1dAYZichKF/ViAJDnodsY6Uurh4xaWi0pGu5
	idA==
X-Google-Smtp-Source: AGHT+IGAFK8f67wVc7JjdjAkvlmoLrHOsH5U3beSFy9Ow5NcTVtufHzqymZVp3Tv4ibjMmj/rOVtkfQ1Iw==
X-Received: from wrbbs1.prod.google.com ([2002:a05:6000:701:b0:3ec:d97e:c0bb])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:adf:fac7:0:b0:3ec:e285:546b
 with SMTP id ffacd0b85a97d-3ece285566fmr3233104f8f.50.1758204362163; Thu, 18
 Sep 2025 07:06:02 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:24 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-14-elver@google.com>
Subject: [PATCH v3 13/35] bit_spinlock: Support Clang's capability analysis
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
X-Stat-Signature: y3fcqqt6ugju85wjhzis9e8skczutmr6
X-Rspam-User: 
X-Rspamd-Queue-Id: B9966140014
X-Rspamd-Server: rspam10
X-HE-Tag: 1758204363-276281
X-HE-Meta: U2FsdGVkX185pYC7IzErGnwGmeacIjB/rsmWbdCmRm8+rPPlGyl/zXQrQXNP517y2V8UT1PiUrXWtWEpfZ8npuKC/cvwYYYzfv0qBsSL7wZcJAMzXsOL6ngIx6rzt59LL1tBofBiFtgcRA/gIJN3tpT/BeaPb/4LIt2t19K33bdMnTwX/LxPIc57vLYuSWnerHJ0sVQWJZElRpA2Jd/kg2bcmE2oa8IiYQH5CcoGqVyLgR8dPfEMQTJbCgLgnuNxMe07du704ltq1P4JMrZi7ozLLfimAVrgUcLwBPAb0obEZmm9gvnqvuGAau+W3L1NzgqWbKtgztJhLPX9jfSQ3m38wbiue05dbY2iH8oGaDU9IBytNsaMv4mCji5qjth9eNTDtjTNvbBqrsSveaxQvfpGBc6x2mVgSU9D/NHL2dVBaXcmZSLn3H4yPLnwILkkSOgDs1moA+Pa4d9jYSLNpA2CjHunc+ShED+Ga7hFSViwFUvyuabTgOLtumz3FLj1HIhupzEU6hQRjIBI7U6bNme84IfBRyjBAHx/sDXe6U6a5ZJwFQbGY0lWHCK0mMlNdMNS5sDapU6DCXS9qIaDYS0mhvSQtzpfEo62xawS/AaVEOUkU4TKYl/Bu0QBfQGGx6KgoH0OSSUFf4nt+JpXsSDyWW2iWv43gk5L92Qe6FJ817Fp/LifO80KKlxpxoqbYgXjT9gLda0S2RXm4B28hVQtbkoWvNZRnNOvcrFHEZTQKmNlLwhWq6+0biWuRuLt0wlT33Z4QtL55s4Yj1PKh2ZaLTxeZf9fv7x8TGZ5QMksF9dGNUHDyvwdF85M2b9fSCWTAbkcErvuXAWkIZh27RmUO6FaLUmRW1ew35MKa1EQwpAS1PqQ5IFzhQT+z6mc0T/0T8co36//mdv1mfzAMF8t+Zm+W5vnDyB5auXnDeQfNo8zANOy5l7xUzlyeHB/iFJ6wdYQLRjil66dmkQ
 p87Tn8eb
 49KhMtTIj50Ao3Jc4AOT8hMeYL5Osbbol5w1F1A6AmeV2EY0idOyTvhaebkHJ7nGImKgOqk0zSzS2ZNnNGkO81OVYPRh+bDFgZqhS+FtYvY7YTLtbQhP5aJDGnSeR0VslVOuuIVJxSTYunPdnXUByiGVKrXZzfdZDl7DVAdBdX/or5rdvZq1/+QG962XcWYQuMqWzNQRnX7Wc+6CqXC1U9EJpGPumxkBa9veYXSZQHcsgxbcpPHmxzsiIEh24UJB7qitn5JCSsLR3EK3Rg6rIEIVHiBuv6zLX0oSY5cMozBY17EmAXFzkZDubZPNUn9XNY28xRHi0SbB6ME9rs1e+jbIIhHJc0tnWKLoV/2k+1OdMVJdUZc4EIRc6IASpqFNzJNIJGpCoR9YF7Wntrh8789rNyMzo9CxWuXxVq3ZI/0om6auel+kt4iW8kh4UEN7+VEe2dGRIBaxEXE45VU5LiJmHxaJGiyfRPklTI/bIsiOSUarbf/ctN14Goa7cU+DlhYqrFNJVf4lh/I2tQI94lpVV6AZ4z08jBsR1GNyTwBf2ZzWQb+Wh4ElKhmv2iY3c7pzy+ac2SBq8/ba1pKzz/TbfVgkUPxAstqJNKzZ6kQvctfUrGU9Vb+E3gnB0bPWSl60UgQ9lV1/Btxog4MgQ1rXTgF/mD2GUBT4hZZlN/xwHkfbgAKlU65+SD8xgLvYQPOMI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The annotations for bit_spinlock.h have simply been using "bitlock" as
the token. For Sparse, that was likely sufficient in most cases. But
Clang's capability analysis is more precise, and we need to ensure we
can distinguish different bitlocks.

To do so, add a token capability, and a macro __bitlock(bitnum, addr)
that is used to construct unique per-bitlock tokens.

Add the appropriate test.

<linux/list_bl.h> is implicitly included through other includes, and
requires 2 annotations to indicate that acquisition (without release)
and release (without prior acquisition) of its bitlock is intended.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../dev-tools/capability-analysis.rst         |  3 ++-
 include/linux/bit_spinlock.h                  | 22 +++++++++++++---
 include/linux/list_bl.h                       |  2 ++
 lib/test_capability-analysis.c                | 26 +++++++++++++++++++
 4 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 4789de7b019a..56c6ba7205aa 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -81,7 +81,8 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
+`bit_spinlock`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index 59e345f74b0e..ba3a67f39f0c 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -9,6 +9,16 @@
 
 #include <asm/processor.h>  /* for cpu_relax() */
 
+/*
+ * For static capability analysis, we need a unique token for each possible bit
+ * that can be used as a bit_spinlock. The easiest way to do that is to create a
+ * fake capability that we can cast to with the __bitlock(bitnum, addr) macro
+ * below, which will give us unique instances for each (bit, addr) pair that the
+ * static analysis can use.
+ */
+struct_with_capability(__capability_bitlock) { };
+#define __bitlock(bitnum, addr) (struct __capability_bitlock *)(bitnum + (addr))
+
 /*
  *  bit-based spin_lock()
  *
@@ -16,6 +26,7 @@
  * are significantly faster.
  */
 static __always_inline void bit_spin_lock(int bitnum, unsigned long *addr)
+	__acquires(__bitlock(bitnum, addr))
 {
 	/*
 	 * Assuming the lock is uncontended, this never enters
@@ -34,13 +45,14 @@ static __always_inline void bit_spin_lock(int bitnum, unsigned long *addr)
 		preempt_disable();
 	}
 #endif
-	__acquire(bitlock);
+	__acquire(__bitlock(bitnum, addr));
 }
 
 /*
  * Return true if it was acquired
  */
 static __always_inline int bit_spin_trylock(int bitnum, unsigned long *addr)
+	__cond_acquires(true, __bitlock(bitnum, addr))
 {
 	preempt_disable();
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
@@ -49,7 +61,7 @@ static __always_inline int bit_spin_trylock(int bitnum, unsigned long *addr)
 		return 0;
 	}
 #endif
-	__acquire(bitlock);
+	__acquire(__bitlock(bitnum, addr));
 	return 1;
 }
 
@@ -57,6 +69,7 @@ static __always_inline int bit_spin_trylock(int bitnum, unsigned long *addr)
  *  bit-based spin_unlock()
  */
 static __always_inline void bit_spin_unlock(int bitnum, unsigned long *addr)
+	__releases(__bitlock(bitnum, addr))
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
@@ -65,7 +78,7 @@ static __always_inline void bit_spin_unlock(int bitnum, unsigned long *addr)
 	clear_bit_unlock(bitnum, addr);
 #endif
 	preempt_enable();
-	__release(bitlock);
+	__release(__bitlock(bitnum, addr));
 }
 
 /*
@@ -74,6 +87,7 @@ static __always_inline void bit_spin_unlock(int bitnum, unsigned long *addr)
  *  protecting the rest of the flags in the word.
  */
 static __always_inline void __bit_spin_unlock(int bitnum, unsigned long *addr)
+	__releases(__bitlock(bitnum, addr))
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
@@ -82,7 +96,7 @@ static __always_inline void __bit_spin_unlock(int bitnum, unsigned long *addr)
 	__clear_bit_unlock(bitnum, addr);
 #endif
 	preempt_enable();
-	__release(bitlock);
+	__release(__bitlock(bitnum, addr));
 }
 
 /*
diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index ae1b541446c9..df9eebe6afca 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -144,11 +144,13 @@ static inline void hlist_bl_del_init(struct hlist_bl_node *n)
 }
 
 static inline void hlist_bl_lock(struct hlist_bl_head *b)
+	__acquires(__bitlock(0, b))
 {
 	bit_spin_lock(0, (unsigned long *)b);
 }
 
 static inline void hlist_bl_unlock(struct hlist_bl_head *b)
+	__releases(__bitlock(0, b))
 {
 	__bit_spin_unlock(0, (unsigned long *)b);
 }
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 74d287740bb8..ad362d5a7916 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -4,6 +4,7 @@
  * positive errors when compiled with Clang's capability analysis.
  */
 
+#include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
 #include <linux/seqlock.h>
@@ -251,3 +252,28 @@ static void __used test_seqlock_writer(struct test_seqlock_data *d)
 	d->counter++;
 	write_sequnlock_irqrestore(&d->sl, flags);
 }
+
+struct test_bit_spinlock_data {
+	unsigned long bits;
+	int counter __guarded_by(__bitlock(3, &bits));
+};
+
+static void __used test_bit_spin_lock(struct test_bit_spinlock_data *d)
+{
+	/*
+	 * Note, the analysis seems to have false negatives, because it won't
+	 * precisely recognize the bit of the fake __bitlock() token.
+	 */
+	bit_spin_lock(3, &d->bits);
+	d->counter++;
+	bit_spin_unlock(3, &d->bits);
+
+	bit_spin_lock(3, &d->bits);
+	d->counter++;
+	__bit_spin_unlock(3, &d->bits);
+
+	if (bit_spin_trylock(3, &d->bits)) {
+		d->counter++;
+		bit_spin_unlock(3, &d->bits);
+	}
+}
-- 
2.51.0.384.g4c02a37b29-goog


