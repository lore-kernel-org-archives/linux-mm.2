Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45EA8D7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AABF96B0098; Fri, 19 Dec 2025 10:45:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83176B0099; Fri, 19 Dec 2025 10:45:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9832B6B009B; Fri, 19 Dec 2025 10:45:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 828726B0098
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:45:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26F9189963
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:48 +0000 (UTC)
X-FDA: 84236645976.07.45F0A70
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id 41D094000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1naN/z6/";
	spf=pass (imf27.hostedemail.com: domain of 3KHNFaQUKCHUXeoXkZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3KHNFaQUKCHUXeoXkZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kb0gLsOvOvTOd9/IwL391pJi9FHpm7GL0bThZeAVvoU=;
	b=fdWJuIZ7VcGonITx0Arbn1kCRqOcguE1lDSKWfhJkf2A7gj5z7ib77EqwOCwlbpy2NYa0l
	G0cRsNZPmd/h8vT4HQ0HIqdFblO7HjO5FYXl1Cjc8GwT0t34AD+i6nHRXmmDNpW6IdoFIp
	Qc6wNEHtu2xvfm9nAGDcUd2VE9l1qfY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1naN/z6/";
	spf=pass (imf27.hostedemail.com: domain of 3KHNFaQUKCHUXeoXkZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3KHNFaQUKCHUXeoXkZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159146; a=rsa-sha256;
	cv=none;
	b=n376Vqfu/ugDBl6kFrtB9MBYNl1Bf48hzTKfHdQ5isjIXR04Hl2UGhxvJJKDSTWcoQODOq
	bQcGQdbN3YdACBlADlAPatFZfOOnkQn8TBdoDzD7J/tafz0qRLIiW2Kna4K8Qj3KMHf4ZD
	qH8G08EZSsb51AGIYV1FckKN3YKaxT0=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477cabba65dso11084965e9.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159145; x=1766763945; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kb0gLsOvOvTOd9/IwL391pJi9FHpm7GL0bThZeAVvoU=;
        b=1naN/z6/bJd70x93wLFDlb8QHex6+I3/rnDls5N89a7y8z8QyybDmM0IlZD0kO3An3
         mdbR1Ml3KK4awnCdsKwFL6oknlhPwX8uNtJbHJUkhRsEUnG2aDNnt0ILQT0IBAQ+HvRC
         9ECIp7d52tcEKfiFKx5r1+6iApKb0Cd/xkiA3jwQV0kJYCvPwonbBuHYWthQyeCL+6rf
         nhGvbYrtm/7mWZnLTdbzjGJYxhHuUzjX20/2PG/s4g6zYcUZ7WplHTAs8zEZTl97PyZm
         6tFYFksDxVnXMpvCsLdbsUgFFj45Yyzm3DShwA64fWmxVuiKidKi72fwbywanm/6lCeq
         HbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159145; x=1766763945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kb0gLsOvOvTOd9/IwL391pJi9FHpm7GL0bThZeAVvoU=;
        b=unDPRjAxLIJ6Hot88qYVP6FPH1HnMY7w1fAptC0ICLU3A4g8kozPzZmHyRBaXYRfHF
         X5yc8/38PVJn1bFInQpBOYmOKsMDbq5PgUHF2KzrtEilXolpnLCH1Zp9scZmBKxCE4hS
         B6P0pnihidD+NSWx5/Dgt8ZuvlL98pd0jN9nkko3EvCndoz+y/DEGW/SPReorAn2Kfk4
         q2kur/mZRszn+69TNdFFOZ8ZpcmmwExQiKtb0OEXHxrEfA8M+0yUX7qeMp0ECtBu3mPw
         HCRVgcz4RPAq67dxazJbCFP1LJ3qkOKe0I1Z3Da4yr9SlgZy2Nw5kX4oqQlfT9Gr9eBU
         xq/g==
X-Forwarded-Encrypted: i=1; AJvYcCUVj21oar0HSS0Udv5S0TyrYWRQTX8Cizd+1WuaXjmEiQ/p2K0RwkgFQ4IoXsi7hizRfjGkdUttIw==@kvack.org
X-Gm-Message-State: AOJu0YwQErp0F1Ky3jAt8lOu1vCN+vEQjgndjovpmIbtZWGD0ODPinuM
	QSXz9cCaKrzjAlTv0YACP6Ve99EPd7TERegDVKUSvBZ1qjutD4iuJwY/znNPHXykADfv8165vJy
	OKg==
X-Google-Smtp-Source: AGHT+IET+LEGDJRWCHLmorOjhXicoZnuOWLnFvU0WuT5JtyAAqi51qU04r6fOHC0UWSg/g7d1u9qxqHVsA==
X-Received: from wmv18.prod.google.com ([2002:a05:600c:26d2:b0:475:dadb:c8f2])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:820d:b0:477:7c7d:d9b7
 with SMTP id 5b1f17b1804b1-47d1958e475mr30951665e9.33.1766159144675; Fri, 19
 Dec 2025 07:45:44 -0800 (PST)
Date: Fri, 19 Dec 2025 16:39:55 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-7-elver@google.com>
Subject: [PATCH v5 06/36] cleanup: Basic compatibility with context analysis
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
X-Rspamd-Server: rspam02
X-Stat-Signature: 88agnpsbebg6cajb3ibp784qia5t7f7m
X-Rspam-User: 
X-Rspamd-Queue-Id: 41D094000E
X-HE-Tag: 1766159146-667040
X-HE-Meta: U2FsdGVkX19QXeCwzK4xNRSuF9eb3wu7jNn27cqa2htAgM3I7n+S8zzuZX1DHRf/s+D3HoQKotC3bLEi+ayarb+jR8KJUKBeofosWHOpdkJ5cnExAD7q9uRHucTRZNJ8CHgXXwWMJIebPYpuU0lhin7rdh2QAUGG9NjTMBzaT9chmpuQcDQ2hFTQcvJBPMw6TKgBY6N3AcYmg5w86ijW+/V2EKRLRP1n/x9YGw2ZENALQ/eRtWCTKCTsdSyfxZb4PKbi99sG5sQhQm43yQg/xcBUhG4wBiAlwmD16zzm9i7s38lk+ahl3aYncKJKnd+ympqnIwLohH5Zr5Wcg9MeUbHupH18JZZPCLNfGlsa1RvMgqeoSdmm74JYHeIsm+La6GuSv83s1STMBlmLxDYWKwK7WfOIqH4wh0CKSPmVZvXegsg0vSlJX7lU0x9h38+ll9Ced5URASIVhlYF/+/88mvlVnQ9fuMEyFjANFNth4UhcsoiTxJEAKqkKvBPZctvnYZkj5OchdzhZh7D/PSknjMIBrrRndnI0gV7sL1v1TJQw7pU0VvFXsV0u0c35nCCff6J/5CPYVFInoxYfas2KQxsRSe3qhnEi/D1jxknVjzavQzt9Pd1dJMmlV3zu00n3cL35kPK+sTdkE2PZL8Lis8zBIztNNYaTxe48dQu60pwhn6362hnK3e6kvdW6kUb3HcD/gl3InU/1Qky5hV5J/Jl28R61OxEvviJIPkDWAEG8lrebA8696nMwJFh4N6n61lWW2hxtQVHBesLeYl46a9+fq9VFr1BQv2LfEovoZklsaIotRWA3qztJd2yNVcsIzj5s+ezGQJFz++p8CB5TDbp0uyrTZW5o+aERFVS1xRhTFY2pVle8fOfZD47xza22nPSUN6YkNUrKtiMYj+/QdLjmwmhD8qypOiCtqEbLZNgVweqAQKIOccs8yIUZM9cvMAGjm2lN/vpuFfCY0B
 NOWbNkLw
 AMFZnZOeXLjIiQ7CkbROD18gbykb7tuDlr4IkSKy0q33GGAsIw7Ogk6W1kTkRKlaRVg910dLHY9LfOp6l4nJDh9miVUEDma7e85YZUeucdR4xBuR/pwrVeKkCvoFgOc1gJiUPz0Rm/gbD29OWloGzA7SoL4oazt85yu33zhwIbR5FC8vPTaWV66cqU888gddA8cJIpAs9ks+fU3HrOAvng2mR3/Em7tFzYXdXzE2SXXWYE7XNAtsn6yKTgsflK7tAhZmLCbzeP/c06R5o3AwuSzWoplgHxRYoIbRc/Gnczkqv7MB9KD3hMSSsy1jbZwKOOCy90i2Z9oW35/n+Y6jTkhRjTP1joj6Sdn1EPwD6YVRlaIGKzyQX+3NrLUXE+AKWksXo6qs8vVVEwhWNv5Hm0xjhKfhWKA3i+HkVOeYqFHX8JQKGSlQcUTzSuiQVxtN9JxNpZ8+aTC9EfBK7LaXbkyZsbwbtY/jo+TTA4CMwiYZm32/HJy9+Cq14bz86sr3BmqLfi1ScTy7rlZvUaIbbgokKuSosLX0zAk1LiLXZglBR5WLAeDwHdpWGBHZRNZ1mQad5WCJr9Mi55b9+tIzoML+f6bi80rFCMSNBJQ4r0focw1enGpfzhIcEcd72jlkHOWhwRN6DY77dSVM5lL6A291eM5T0tSNneHQC9g44XuGEK4SbYG9ECB0dYMIrIOUQoFtoTVo4bAant2Xunx0IRFonBZ1FuXrzBbAa/WLX01o7nNUsIAAbcChehOur3K8Mk73PW0x/lKP/5htUxCSXgZyeXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce basic compatibility with cleanup.h infrastructure.

We need to allow the compiler to see the acquisition and release of the
context lock at the start and end of a scope. However, the current
"cleanup" helpers wrap the lock in a struct passed through separate
helper functions, which hides the lock alias from the compiler (no
inter-procedural analysis).

While Clang supports scoped guards in C++, it's not possible to apply in
C code: https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#scoped-context

However, together with recent improvements to Clang's alias analysis
abilities, idioms such as this work correctly now:

        void spin_unlock_cleanup(spinlock_t **l) __releases(*l) { .. }
        ...
        {
            spinlock_t *lock_scope __cleanup(spin_unlock_cleanup) = &lock;
            spin_lock(&lock);  // lock through &lock
            ... critical section ...
        }  // unlock through lock_scope -[alias]-> &lock (no warnings)

To generalize this pattern and make it work with existing lock guards,
introduce DECLARE_LOCK_GUARD_1_ATTRS() and WITH_LOCK_GUARD_1_ATTRS().

These allow creating an explicit alias to the context lock instance that
is "cleaned" up with a separate cleanup helper. This helper is a dummy
function that does nothing at runtime, but has the release attributes to
tell the compiler what happens at the end of the scope.

Example usage:

  DECLARE_LOCK_GUARD_1_ATTRS(mutex, __acquires(_T), __releases(*(struct mutex **)_T))
  #define class_mutex_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex, _T)

Note: To support the for-loop based scoped helpers, the auxiliary
variable must be a pointer to the "class" type because it is defined in
the same statement as the guard variable. However, we initialize it with
the lock pointer (despite the type mismatch, the compiler's alias
analysis still works as expected). The "_unlock" attribute receives a
pointer to the auxiliary variable (a double pointer to the class type),
and must be cast and dereferenced appropriately.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rework infrastructure to properly release at scope end with reworked
  WITH_LOCK_GUARD_1_ATTRS() and WITH_LOCK_GUARD_1_ATTRS().

v4:
* Rename capability -> context analysis.

v3:
* Add *_ATTRS helpers instead of implicit __assumes_cap (suggested by Peter)
* __assert -> __assume rename
---
 include/linux/cleanup.h | 50 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 8d41b917c77d..ee6df68c2177 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -278,16 +278,21 @@ const volatile void * __must_check_fn(const volatile void *val)
 
 #define DEFINE_CLASS(_name, _type, _exit, _init, _init_args...)		\
 typedef _type class_##_name##_t;					\
+typedef _type lock_##_name##_t;						\
 static __always_inline void class_##_name##_destructor(_type *p)	\
+	__no_context_analysis						\
 { _type _T = *p; _exit; }						\
 static __always_inline _type class_##_name##_constructor(_init_args)	\
+	__no_context_analysis						\
 { _type t = _init; return t; }
 
 #define EXTEND_CLASS(_name, ext, _init, _init_args...)			\
+typedef lock_##_name##_t lock_##_name##ext##_t;			\
 typedef class_##_name##_t class_##_name##ext##_t;			\
 static __always_inline void class_##_name##ext##_destructor(class_##_name##_t *p) \
 { class_##_name##_destructor(p); }					\
 static __always_inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
+	__no_context_analysis \
 { class_##_name##_t t = _init; return t; }
 
 #define CLASS(_name, var)						\
@@ -474,12 +479,14 @@ _label:									\
  */
 
 #define __DEFINE_UNLOCK_GUARD(_name, _type, _unlock, ...)		\
+typedef _type lock_##_name##_t;						\
 typedef struct {							\
 	_type *lock;							\
 	__VA_ARGS__;							\
 } class_##_name##_t;							\
 									\
 static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
+	__no_context_analysis						\
 {									\
 	if (!__GUARD_IS_ERR(_T->lock)) { _unlock; }			\
 }									\
@@ -488,6 +495,7 @@ __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
 
 #define __DEFINE_LOCK_GUARD_1(_name, _type, _lock)			\
 static __always_inline class_##_name##_t class_##_name##_constructor(_type *l) \
+	__no_context_analysis						\
 {									\
 	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
 	_lock;								\
@@ -496,6 +504,7 @@ static __always_inline class_##_name##_t class_##_name##_constructor(_type *l) \
 
 #define __DEFINE_LOCK_GUARD_0(_name, _lock)				\
 static __always_inline class_##_name##_t class_##_name##_constructor(void) \
+	__no_context_analysis						\
 {									\
 	class_##_name##_t _t = { .lock = (void*)1 },			\
 			 *_T __maybe_unused = &_t;			\
@@ -503,6 +512,47 @@ static __always_inline class_##_name##_t class_##_name##_constructor(void) \
 	return _t;							\
 }
 
+#define DECLARE_LOCK_GUARD_0_ATTRS(_name, _lock, _unlock)		\
+static inline class_##_name##_t class_##_name##_constructor(void) _lock;\
+static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock;
+
+/*
+ * To support Context Analysis, we need to allow the compiler to see the
+ * acquisition and release of the context lock. However, the "cleanup" helpers
+ * wrap the lock in a struct passed through separate helper functions, which
+ * hides the lock alias from the compiler (no inter-procedural analysis).
+ *
+ * To make it work, we introduce an explicit alias to the context lock instance
+ * that is "cleaned" up with a separate cleanup helper. This helper is a dummy
+ * function that does nothing at runtime, but has the "_unlock" attribute to
+ * tell the compiler what happens at the end of the scope.
+ *
+ * To generalize the pattern, the WITH_LOCK_GUARD_1_ATTRS() macro should be used
+ * to redefine the constructor, which then also creates the alias variable with
+ * the right "cleanup" attribute, *after* DECLARE_LOCK_GUARD_1_ATTRS() has been
+ * used.
+ *
+ * Example usage:
+ *
+ *   DECLARE_LOCK_GUARD_1_ATTRS(mutex, __acquires(_T), __releases(*(struct mutex **)_T))
+ *   #define class_mutex_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex, _T)
+ *
+ * Note: To support the for-loop based scoped helpers, the auxiliary variable
+ * must be a pointer to the "class" type because it is defined in the same
+ * statement as the guard variable. However, we initialize it with the lock
+ * pointer (despite the type mismatch, the compiler's alias analysis still works
+ * as expected). The "_unlock" attribute receives a pointer to the auxiliary
+ * variable (a double pointer to the class type), and must be cast and
+ * dereferenced appropriately.
+ */
+#define DECLARE_LOCK_GUARD_1_ATTRS(_name, _lock, _unlock)		\
+static inline class_##_name##_t class_##_name##_constructor(lock_##_name##_t *_T) _lock;\
+static __always_inline void __class_##_name##_cleanup_ctx(class_##_name##_t **_T) \
+	__no_context_analysis _unlock { }
+#define WITH_LOCK_GUARD_1_ATTRS(_name, _T)				\
+	class_##_name##_constructor(_T),				\
+	*__UNIQUE_ID(unlock) __cleanup(__class_##_name##_cleanup_ctx) = (void *)(unsigned long)(_T)
+
 #define DEFINE_LOCK_GUARD_1(_name, _type, _lock, _unlock, ...)		\
 __DEFINE_CLASS_IS_CONDITIONAL(_name, false);				\
 __DEFINE_UNLOCK_GUARD(_name, _type, _unlock, __VA_ARGS__)		\
-- 
2.52.0.322.g1dd061c0dc-goog


