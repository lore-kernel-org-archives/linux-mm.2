Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94472D7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0292F6B00AA; Fri, 19 Dec 2025 10:46:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02536B00AB; Fri, 19 Dec 2025 10:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED666B00AC; Fri, 19 Dec 2025 10:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CE0766B00AA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5D5D136C2D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:20 +0000 (UTC)
X-FDA: 84236647320.04.88C96B2
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id C03D920016
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Sa5w6nBG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3SXNFaQUKCJY4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SXNFaQUKCJY4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159178; a=rsa-sha256;
	cv=none;
	b=vHzowSFtHuskGIuixKs77TSrTxP6Xp/QR0yFUng2DunTx8uT8PCpdElesnZaSKoDo7YxS2
	X7nzpvr5JQlE7GxVWcbyUEsRa5pLOENnl/YE96RsmYDx7DrVfpQ2Nuamuvo+tIjO5KT0iH
	EBevBgilA8QiW/HkrPkwwzNMzDaV9UA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Sa5w6nBG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3SXNFaQUKCJY4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SXNFaQUKCJY4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxzeiPbUa31+hz0U8Tv6bmU7luRcJmafBg2S0XNVzY0=;
	b=0906Di+dcIWogzocFm8QxmDHtXwUgp8DnMbQHb+hhaQ3SBrkTRveyhDWYyoXJoInpYlaMh
	t9EvhZcKqz6kvIVsC99BJ7dmhXRUgt2wTGVNd21v/UttuEzNlw2LFraejWKouC9ymft3X3
	+pyEgF80xjo0Xr2CmRIdr2exoVHkTCc=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779ecc3cc8so13283745e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159177; x=1766763977; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xxzeiPbUa31+hz0U8Tv6bmU7luRcJmafBg2S0XNVzY0=;
        b=Sa5w6nBGPbvk5xIXN5lUKZGcp5R/hYr8E15jnEVBvWRKHWGVRFqBe2AI6YHDZnLo/P
         pN4Bc9lFJ3Pxk27Kf39um7QbI4mrIa/WkhpzkBJfOFFQKC05DYN/rqZleffhJLYrqwY2
         btkuSMn6wz4ozOsaCtnb0NqaPMJUxXix7lI6ESlwMweaUu09c/ZaKlkjNblOt5NTjVnA
         Mw+YQETSdS2mMdKwOzzKAmRttY6sV3UdNycPEKTnaadOhaM2E9jDB+bqG+d/w3517Nni
         ckGzwDZnd8W2DXsw8+9ofvaDzBF0dTfFOKLWSjXSU7JQ/7e/p4+fKFKdVClgUwjx0Zjx
         lWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159177; x=1766763977;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xxzeiPbUa31+hz0U8Tv6bmU7luRcJmafBg2S0XNVzY0=;
        b=rrMNhQkT/CnvpUSeRcyL1LIMPgFTaCLn0G6vEsN78hx9Q/8WuZmYlhhu+kOyw4IW2k
         Tr5KGF2XnmjZ3lQz7+ulJ7vtyS+da4Iqk/Lnfiv3XZmTDxS28wCRteR9hXje3NrkHTtp
         6LAujuJLzbN+Yuy2BCZ+kOxPbuQw3sGLNR+KrcTxuyzxYP5eVEfBiCiPu3miWCpKyvQ6
         K0vkqF9gAag3q5wgI80iEfhGB7F55ewUHDNAWpul0SFTN2drbRgI8jSzGh+RKicwv2VW
         Gjz7M+bXUVd4zxPdoOQbsThqJgqJIO9ZnwbuSxxeY0H5qy4PsByiIDqF+TvVNGyPtlVl
         m9gg==
X-Forwarded-Encrypted: i=1; AJvYcCXMGPugBsuY6ccpNbe7Qmf2Yu0/m9iRTb/yUUCs/Z6WpTwgnF5qx7PehjlXqTaj9o64opQxxaX96A==@kvack.org
X-Gm-Message-State: AOJu0YxNP8TsgfFqcJk5OmZy69ZKXpYZG+b1slV83ZSqevoog+ByQutF
	NCVHJkHl+x7ApiGLBnWKVtZkiUuSjPAEqaNo3TsU3KES5TXT4a23ygzA8OJsP8R5r9zEfNv1/6j
	wLQ==
X-Google-Smtp-Source: AGHT+IGaGS8VBg9MijqM6Ta4+HbU9bsl4GQbb/p7haK0nKuccuPDjffspfAf6ASbrAdFf7JACzcajKCfOA==
X-Received: from wmbgx16.prod.google.com ([2002:a05:600c:8590:b0:47a:90c7:e279])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:820d:b0:479:3a87:208f
 with SMTP id 5b1f17b1804b1-47d195aa085mr30269305e9.36.1766159177290; Fri, 19
 Dec 2025 07:46:17 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:02 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-14-elver@google.com>
Subject: [PATCH v5 13/36] bit_spinlock: Support Clang's context analysis
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C03D920016
X-Stat-Signature: ddxbon5bainohqrfhxw47rmswhhxtbra
X-Rspam-User: 
X-HE-Tag: 1766159178-480978
X-HE-Meta: U2FsdGVkX1+09co7OBsMtPu4po/A7J6rlvCLpYF9k11BOXPwFlbJVsXUKmu6lmUtXx/GKRXAJeGeA7fgrlgzoyPZAn4Bw0YL1RYh9SSonVv5+ZOM1ZAcUAuFKhhaX+puoit3m2cxDGTnIr120a9jkUE4ZVWsYpYg6KmmQph7/GRsBACfSeiXQqh6u5EfoQeOlGBkq/+XJWa+mMDaLNQORmLytb8SPrlKnrIODKkrPySn+qmo7MsE8N2O05Kr5JKfipACyIekH4cnYryfyttcZ4eac3DlbvMALgsEYVgICemwumwB+2/+AV5bqFwY8LhZWOEqw2ikZqZoc2f+6t7PPAn4hUbR80Gd2nUO5odWxMuQVzArnYOGy9DWYuezgFKpayfZGfp8Hw8kzdS82j0HPu9YNbPrEmF2/QHSJjH83RW+jarOTZoYxLAK7SYYoqIIk/Cy/nZ+MxTLfN6RyYzLy3E47m29xZR64UtU7LJxb4gdOzdKvTG6TspYjRqQlsy6k73FrT/i8wonIfr73xJ0/UfGo/8NeO5qRw1jhJ9kZzT8fSIf6TyHzAqvyoLUCRvBfVp5jBb6hYSWlhtew5Y050PcnxAKw7BIUYNEHUZpiXf5kjo6Bx2ZrA6VWXL924hY+jHlPHo2/r3DFY7jAHjNhTzckNSD0sT7ZgDFO87xJxVbClUBU++9E3j8Z9YB2C8t/D13VdgWxR1wCCH0codGrZ9OtBwPU5WH/EzcVYhVOgPBoIgEomhnfCVo8OEymaTOUgjeUApYwKpwxG3q3LFxWu0q/worlIasrjYcZh0uEfPAXtqttKMczLGIlxWe4cpmejwG8Qji2FoadXAM4AxnL/Lo9WQUDGuwh15DmqsdG1yYFBly5UBpY3jvcQ4X7LPcVChYuSXHZ2ovDl6P43SjNdRbKjvwnHpcOUsdgvwfZQAhJ87mzH/HkPqczdsgrKvrio9Ah8eTXkGFoyOveqi
 ZZqqafAY
 6nOEuPC1eeFIOzEaQnjCfsNPJsyELr1RO9fRxHV+uB/TiopNIDjc+JDfMGdm493aaI+ZS2fVWmVFoZcnaGtDt8AtMDAyW3VCddxcYsfo/0v458Zrui2jGPauLKZMj6H/xjnSY8DrJZrKnjDMNexAZkRyrD1HcARldIBeDxsYLSSn38RybvTgTVyHKa7DQ35XuTDI0jBchMwgDiUQKUWzx7pzNzL4i10J98bYuBvj7wAhC65kO0eoFnFklJSVSldA5qZpJoomtVdWVgGtnSL1ot/RDak5esd6Q6/PD4OknXZ0VDn14WA8FJwJ0a08wfwLDiRptFKEYzr1OKRY3HOOfz/lTIghjDo3EHD2fIdSMbpot4ZOfEx9bQdnflLMhUXWdBu/1vfgIconsObTXQTE/DQFVwqraULHeRy51MPFIZVaCpojSA7poPI2j/lIV4My/VsdbYaWolce7ZME4rRrOT3fWWeIdImu7Qk3gVzDuZObUvKPWYsoLDhQokacjbY8nlTnpUIM3u2IvqIxoqycc9nax0SCixxMXcnVXY3KXCg2nMbmMeW6rz7u4YW61Wh5504EdLDmNXP7lAdPAv8YXeRVaj+OjkGcPyS6Und3r4BAFEgRnBx8c5wbwVPxZrSFSNXpCsiPl/QpgvUTCzbYe4gt/Y/aBfDMenfdqaHb0Hd0j0F6k7XD4kPOS7cIKaPOMCCzwOcOFspTcssg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The annotations for bit_spinlock.h have simply been using "bitlock" as
the token. For Sparse, that was likely sufficient in most cases. But
Clang's context analysis is more precise, and we need to ensure we
can distinguish different bitlocks.

To do so, add a token context, and a macro __bitlock(bitnum, addr)
that is used to construct unique per-bitlock tokens.

Add the appropriate test.

<linux/list_bl.h> is implicitly included through other includes, and
requires 2 annotations to indicate that acquisition (without release)
and release (without prior acquisition) of its bitlock is intended.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".

v4:
* Rename capability -> context analysis.
---
 Documentation/dev-tools/context-analysis.rst |  3 ++-
 include/linux/bit_spinlock.h                 | 22 ++++++++++++++---
 include/linux/list_bl.h                      |  2 ++
 lib/test_context-analysis.c                  | 26 ++++++++++++++++++++
 4 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index 690565910084..b2d69fb4a884 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -79,7 +79,8 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
+`bit_spinlock`.
 
 For context locks with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index 59e345f74b0e..7869a6e59b6a 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -9,6 +9,16 @@
 
 #include <asm/processor.h>  /* for cpu_relax() */
 
+/*
+ * For static context analysis, we need a unique token for each possible bit
+ * that can be used as a bit_spinlock. The easiest way to do that is to create a
+ * fake context that we can cast to with the __bitlock(bitnum, addr) macro
+ * below, which will give us unique instances for each (bit, addr) pair that the
+ * static analysis can use.
+ */
+context_lock_struct(__context_bitlock) { };
+#define __bitlock(bitnum, addr) (struct __context_bitlock *)(bitnum + (addr))
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
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 53abea0008f2..be0c5d462a48 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -4,6 +4,7 @@
  * positive errors when compiled with Clang's context analysis.
  */
 
+#include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
 #include <linux/seqlock.h>
@@ -258,3 +259,28 @@ static void __used test_seqlock_scoped(struct test_seqlock_data *d)
 		(void)d->counter;
 	}
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
2.52.0.322.g1dd061c0dc-goog


