Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E31E2CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251F56B0088; Thu, 20 Nov 2025 10:11:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229D76B0099; Thu, 20 Nov 2025 10:11:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140366B00A5; Thu, 20 Nov 2025 10:11:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 00DC66B0088
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:11:41 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 806D21A0165
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:11:39 +0000 (UTC)
X-FDA: 84131324718.06.2F54481
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 92BA480023
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:11:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Td5zJm8r;
	spf=pass (imf02.hostedemail.com: domain of 3py8faQUKCNI29J2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--elver.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3py8faQUKCNI29J2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQzgcISd2vbQZXtJWGq+JJNhDcvZ3ay3Xv8naW52gEo=;
	b=qeoJR54zyCM+cLR2SMo3R8un8bdYf2qCjdixSC/D99D8qDERaKdFDDIu6W4PJjpqEdHADC
	ElNARSVNopnlTLM1m8+BTx/m/OrGo9IL6uA72VzcvtPUFQkw3cxF4XXHCDN8oNDZ57nLDR
	ccWpMWz4xVe5MIDBIopSo6NDcctmjVI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Td5zJm8r;
	spf=pass (imf02.hostedemail.com: domain of 3py8faQUKCNI29J2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--elver.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3py8faQUKCNI29J2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651497; a=rsa-sha256;
	cv=none;
	b=SIBIMKmI3A+GUyP3YmSm82VqdNcyQYTY0o5866Y019/q9d4ed0PZjC2jwd3vFOjlXxlLY/
	9rIXsja4gJGBU0S03rM2h5AjrH14y9BVVf1nPdwFpXJlQdiF4Qmo6Zj5YS/uF8ha/9Zd0+
	alSFEvoprTSs7DtsoXm9MjJuL8sjoIA=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b736eca894fso79243966b.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651496; x=1764256296; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aQzgcISd2vbQZXtJWGq+JJNhDcvZ3ay3Xv8naW52gEo=;
        b=Td5zJm8rmNVnJdAWFXXnM7hXUec/Kk2LygCe/zS5/LTngrK4JBlrZ8+O4R3gHRXBoQ
         mS2xtAjMPrKUh7HnGM99+K6JegrUdCzI4MzVgVcGr7fdhojnIuOE27C7QkVu5g0Joz8X
         m1oKmi/0gJsXdyvdavqzEdg4bQkaHHMTWyj6bR0cIleNAMUnvlTcULOj7rxwHwIFvSkT
         fmhPInWgsel2GVfNSK01trXQcshv8UWkCEQJuBmVG3fDxVQ8WQqIKVkcQbZEPobjuXLW
         Qj+GpoYf0xaX2Ywhk5N/bpXz6BaX9ILEFMd6cRNz5XzxBkut2dCw73/jn+7Gao3F7fJ2
         X1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651496; x=1764256296;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aQzgcISd2vbQZXtJWGq+JJNhDcvZ3ay3Xv8naW52gEo=;
        b=n5fzQSSO+JMjHWQTiMpyKaJElOWZr4SpLZVhdBHFu1F1LXuK904/p5rYyH/oy7kyVY
         1yo0O1iF8L1kyjXJO3DSFh/tapKDk12R3pHPFaErUlkwY6V09a4uQPG4I+bRptc4r6ha
         ZtUJQQR6segVWvyJsNk0/ZZZmDNHxHUEwWOHZBYI+aaQBl6ET8Jsq2UM0QIv+zrXYbu7
         XKA2g5ZC5HHD1pNoSUnFyoumzanIxqE38Ajqk1z+ZcQjW5Mo/uirgGjelsIy6zmDdk6B
         bk+RA369SKB5ydzMnuxeKrc/ZRrtoU9hAg4iIkdlC/u4W4FRvvN42sqH6koYbfXGCMzd
         KEcw==
X-Forwarded-Encrypted: i=1; AJvYcCViC+pmEHB/C2VkpnU2j5uBibjiidgCZu9Ze9OKsihJEGLY3obXZEFSfTUuIFqBzTn/tmPJR2lnUg==@kvack.org
X-Gm-Message-State: AOJu0YwPwNAssS2qjTrfyL5sVhvLMtv4lcU6wJtV/iTMXsvBpz/11oSA
	dxzYyZZQMgdxLru2c0wehQwcHXNLEok4Fpidj7prd3URgF6NXhOGREo++QJfyfFlYC9heohvm6n
	+Bw==
X-Google-Smtp-Source: AGHT+IHtFDUbBCcz68B5yl4+E7U+1inKytiJmjNdpXX9LnNqAnRdSUSbK1o8WJIs9ZzP1T0fmeAlZls5iQ==
X-Received: from ejbrp28.prod.google.com ([2002:a17:906:d97c:b0:b72:41e4:7558])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9812:b0:b6d:5b4d:7277
 with SMTP id a640c23a62f3a-b76550b65a3mr361991766b.0.1763651495821; Thu, 20
 Nov 2025 07:11:35 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:31 +0100
In-Reply-To: <20251120145835.3833031-2-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-7-elver@google.com>
Subject: [PATCH v4 06/35] cleanup: Basic compatibility with context analysis
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 92BA480023
X-Stat-Signature: jgnh1cpo9fqd6fag8ggg6azrffo7mam1
X-Rspam-User: 
X-HE-Tag: 1763651497-450713
X-HE-Meta: U2FsdGVkX1+ODqEguK/DQVJVUcfG32ivncEHTcl+x1nHIqV34tc+ZGoIkyG/qyxjUowfvDjxl1xDHkQte2wMnEbL6qZD258kF65C1/aI1RNXs7S50NEJK/hP7nAKoxM8jajXnNq/tmJwLz0vrCxhh/8hW2h5jN3bO1LSBSEGwtb1knjuAOI5frEoY12VxLA+9NZ2miyq9efjc4PypigMBWMQ/qtM4UMMyywL193fEnjiRO76v6B+jCOu6RAoVfaib6bemBuaUm4SCVuYVTb13mS3iiIGGAw3cCKk7zyJtA0UB0tPYx72Y4HKqEouG7/OrYZod+uJcOgdEh36Up2+Tmde5pROlSLzPpSHfzioI4rPzZRy09D8YAuo6uh2BnsWH7AFpVNjnf12Z1ueNdXggTiS6L/q2ekhht7CbhFBwD8DPZ8Qw/1klIg06o1fBDD5XSGBigkzRhS0yI3eyalgpZKXxNmLBdqdMCD8anuDn0dOcVDl8bnGD1BN80XW8kbFG6cKSvmhU//IpYt8N4RwVxugeysjCbixm8UGp20vXfAuW2c6n5X3ZdJo3sJbW+HYRAoTq4wB8+WOFVe7THvRawINVR2kbXO6solu4oahFs+JxYN3d0PIhG2/DqcG8njupaQAF19Uz/gSbT0eF+PCgcuIASRn5ZVgZ+aovCNOHhOflNHRVU4K8+Qzp0K72bSbov/C1tsv6GC4g+VNZy3Hb5mu82OZGkZcB9A3eLGJ7LPPZBExS43JY2JtJ6yUWV1lKQ4GYisaPeYeiRzBzwIeGwDZ5q35hbWIn6/ogdckQl5NMRrDX1KAQp7YD24qF25jExla/Cn9dZxxh9+ds2+kt0S1Yt5dip3pwdGp7Ns1Q8xp3hnWHbh/ifht4SH5jLI8hkpVJdF5au3GskbaGKJXFvu/m0P7A20+bxzcL2JLj8K6BS70u4oy8zuPR0UtyY8tor+lAU1yRmvKLZXFQEw
 tjaQsna3
 E3hGUmKk1Fibhzn8y/SzeTpNMeKRZgS1KU+w7/8t6N75L1gx7AXyQQaKoqd8JUoPHHj70OXvVV1m8jMKhOLs6C6tRNc7ozX2/Z2tKX1SksdVuv24yUWa2BPABXrici1iho4cvQzKgvGWJq8RxlQ/EKXXs0EfLfhxoITway7h+40WPXpEsdYE+al2yv1dxlhyvhP8N7UuGswVcXHtmtDwuDLPErH0Oub5IRJC2d+ShnLXsuv3soPqsTMhcISa+L2a9cAgItT8ybEgbd/dhPq5S5lNSdSW8b/N/VEUjHtYHvItZbr8YAO4tVVNjCkv0YUbajqF3mIgqBTlxuBHxL/qDTucK0uZsX+yIguRyJ/OKpvAiPmbR3B/IRKJzrSKXMa5gILWdi3M4glINwJJskITa6z4aY9EUdc/J9bCRRer6hwtIGVAUDdPM1NzdiGqRUDhr22lzzoLS1wn41USNEsOm9YU0zTl86yOfUArNB3CqDl5FdB46DIXSFVfH/9t4cwdhQOErcLji7umXm+PQRe+APe4KPBefzVWDG4yQk3m6cOurdeSO4VgCxyAoEfzoDSJtD7i1myTKrkhVbI51+x0JzvK5aVL7+LAFemLQ8PmdpD7nbIH8nrnGpRRxQ456oakNfqUnPo7F9ycIvHMItyUZCATnuzgMMDgLoF3pu8M9v08TboazxDL9K7wjkTD4dqE53maYB9CK6uP5i8/eIKQBDQFjF2bbLKf1uiAbrZ+/phIHTlcnJr1xqvNnA/2RCi+371D2LqzuG7Fy8gZp3aVC5OuVfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce basic compatibility with cleanup.h infrastructure: introduce
DECLARE_LOCK_GUARD_*_ATTRS() helpers to add attributes to constructors
and destructors respectively.

Note: Due to the scoped cleanup helpers used for lock guards wrapping
acquire and release around their own constructors/destructors that store
pointers to the passed locks in a separate struct, we currently cannot
accurately annotate *destructors* which lock was released. While it's
possible to annotate the constructor to say which lock was acquired,
that alone would result in false positives claiming the lock was not
released on function return.

Instead, to avoid false positives, we can claim that the constructor
"assumes" that the taken lock is held via __assumes_ctx_guard().

This will ensure we can still benefit from the analysis where scoped
guards are used to protect access to guarded variables, while avoiding
false positives. The only downside are false negatives where we might
accidentally lock the same lock again:

	raw_spin_lock(&my_lock);
	...
	guard(raw_spinlock)(&my_lock);  // no warning

Arguably, lockdep will immediately catch issues like this.

While Clang's analysis supports scoped guards in C++ [1], there's no way
to apply this to C right now. Better support for Linux's scoped guard
design could be added in future if deemed critical.

[1] https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#scoped-context

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v3:
* Add *_ATTRS helpers instead of implicit __assumes_cap (suggested by Peter)
* __assert -> __assume rename
---
 include/linux/cleanup.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 2573585b7f06..4f5e9ea02f54 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -274,16 +274,21 @@ const volatile void * __must_check_fn(const volatile void *val)
 
 #define DEFINE_CLASS(_name, _type, _exit, _init, _init_args...)		\
 typedef _type class_##_name##_t;					\
+typedef _type lock_##_name##_t;						\
 static inline void class_##_name##_destructor(_type *p)			\
+	__no_context_analysis						\
 { _type _T = *p; _exit; }						\
 static inline _type class_##_name##_constructor(_init_args)		\
+	__no_context_analysis						\
 { _type t = _init; return t; }
 
 #define EXTEND_CLASS(_name, ext, _init, _init_args...)			\
+typedef lock_##_name##_t lock_##_name##ext##_t;			\
 typedef class_##_name##_t class_##_name##ext##_t;			\
 static inline void class_##_name##ext##_destructor(class_##_name##_t *p)\
 { class_##_name##_destructor(p); }					\
 static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
+	__no_context_analysis \
 { class_##_name##_t t = _init; return t; }
 
 #define CLASS(_name, var)						\
@@ -461,12 +466,14 @@ _label:									\
  */
 
 #define __DEFINE_UNLOCK_GUARD(_name, _type, _unlock, ...)		\
+typedef _type lock_##_name##_t;						\
 typedef struct {							\
 	_type *lock;							\
 	__VA_ARGS__;							\
 } class_##_name##_t;							\
 									\
 static inline void class_##_name##_destructor(class_##_name##_t *_T)	\
+	__no_context_analysis						\
 {									\
 	if (!__GUARD_IS_ERR(_T->lock)) { _unlock; }			\
 }									\
@@ -475,6 +482,7 @@ __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
 
 #define __DEFINE_LOCK_GUARD_1(_name, _type, _lock)			\
 static inline class_##_name##_t class_##_name##_constructor(_type *l)	\
+	__no_context_analysis 						\
 {									\
 	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
 	_lock;								\
@@ -483,6 +491,7 @@ static inline class_##_name##_t class_##_name##_constructor(_type *l)	\
 
 #define __DEFINE_LOCK_GUARD_0(_name, _lock)				\
 static inline class_##_name##_t class_##_name##_constructor(void)	\
+	__no_context_analysis						\
 {									\
 	class_##_name##_t _t = { .lock = (void*)1 },			\
 			 *_T __maybe_unused = &_t;			\
@@ -490,6 +499,14 @@ static inline class_##_name##_t class_##_name##_constructor(void)	\
 	return _t;							\
 }
 
+#define DECLARE_LOCK_GUARD_0_ATTRS(_name, _lock, _unlock)		\
+static inline class_##_name##_t class_##_name##_constructor(void) _lock;\
+static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock;
+
+#define DECLARE_LOCK_GUARD_1_ATTRS(_name, _lock, _unlock)		\
+static inline class_##_name##_t class_##_name##_constructor(lock_##_name##_t *_T) _lock;\
+static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock;
+
 #define DEFINE_LOCK_GUARD_1(_name, _type, _lock, _unlock, ...)		\
 __DEFINE_CLASS_IS_CONDITIONAL(_name, false);				\
 __DEFINE_UNLOCK_GUARD(_name, _type, _unlock, __VA_ARGS__)		\
-- 
2.52.0.rc1.455.g30608eb744-goog


