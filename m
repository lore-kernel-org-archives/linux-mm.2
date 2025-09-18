Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 282C0CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D408E011E; Thu, 18 Sep 2025 10:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815A48E0112; Thu, 18 Sep 2025 10:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DDA38E011E; Thu, 18 Sep 2025 10:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 58A278E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:05:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07E9F1601F7
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:33 +0000 (UTC)
X-FDA: 83902543746.28.AE243B8
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id 159854001A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="0Rc/zI9K";
	spf=pass (imf11.hostedemail.com: domain of 3qRHMaAUKCEoqx7q3s00sxq.o0yxuz69-yyw7mow.03s@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3qRHMaAUKCEoqx7q3s00sxq.o0yxuz69-yyw7mow.03s@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sI2tSFnbkFXEHpzRn76LXPg2QDPG5jXGC+/0hf5kEII=;
	b=5cCPr+rgd2/n/dGxoSTrnvv76piPPi+bd38PeNfVhfQnKF1ujBYXnRLTbD+RdMi6Q97jvA
	1g580+0c3zug74tTOjHTtbvrL0Vn2OLZ/rrs8elFr6kK6J48kb8YfqVFcmXgNFgYdfex9+
	97irh/a5vfS/iPS5FNNfXo0kDXNv66c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="0Rc/zI9K";
	spf=pass (imf11.hostedemail.com: domain of 3qRHMaAUKCEoqx7q3s00sxq.o0yxuz69-yyw7mow.03s@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3qRHMaAUKCEoqx7q3s00sxq.o0yxuz69-yyw7mow.03s@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204331; a=rsa-sha256;
	cv=none;
	b=XGmB41GYCjf88gzcn1CwJrCXenTrionGx1pD7qspVd4fOi4gVPSUkcxFw0SsbfyHDd/owV
	tLxFi5aubMyYQLWG2X4wPt1eX7s3hxwxbFyfIs4K2L9TAGHLe+8c71T8W6hn1SglrQjhrC
	zQ8sWvihBHhtx6FfNYaz1FsFiI5OWDk=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45dd56f0000so9866585e9.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204329; x=1758809129; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sI2tSFnbkFXEHpzRn76LXPg2QDPG5jXGC+/0hf5kEII=;
        b=0Rc/zI9KznkFjDOgsCXEImZyRhZu70FtGhtA7gnN8mNztrxADYu8HofUcxbc+Ux1Cg
         d4oEOd1Ek6/NQDERVrGAVyhvD/QknLsAC7BLLleCGYWp+Z0beiIMF5BZyS9B9WrOlM0v
         lQk3EOEzIO/DA0b0+E8Hh9Fz10aDhRP9oBwmsHj3+G7sretpevyXytHcfyzUI+hLDrv/
         GUyCzE95ZEV6hznHHrw8xTNPIeLpYmzmSe1pWQ/hKTdpV7Sfea2dPL3PQFH37mGHIaVL
         FX+xNW8v3TyZJaz7V++MXzLNascfkaRGDKzkRrHZwm+BByrNzM2z8/f6QYMVXSrlQ1AE
         Mrag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204329; x=1758809129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sI2tSFnbkFXEHpzRn76LXPg2QDPG5jXGC+/0hf5kEII=;
        b=F5exWsQ5GKlCpGFV2UEK0yvWusZwoKZmDZi1poEOuXvk1l3k4qGnVWTZmAvOfcddrS
         hpZZwjfwUVc6FjW3F0qE2eBcKDlQkPm4duQ2eUY/p6PIkCP44qXxqWPlRiADJ0DrwtAL
         oSXJmBYsbB+dlVtr3yGaYK1L6w36oYUOCnoOdsB6jSTXs744cqgOU+Y+h4H8WALXqVlf
         jRZrAMJpQSkhozQQtGfQtbquQkv/UJa/kiKcGXCVjUIzyCXYt+RbYDd5ZOwklbCtBId6
         l5BCNZKwQ88ayTtCFaaxzKrEtkdU+1Rzkdjax0r/a3h7IvKRqkAFoUoJWhZp4kviLHUF
         skrA==
X-Forwarded-Encrypted: i=1; AJvYcCXgOB2j0aJ24yPqTeeCRb3gmGSBGRNWGBgxqgqIPMcQ3NWv9hvlKnoEOlpPu2pAFIozJA7EU1M32w==@kvack.org
X-Gm-Message-State: AOJu0YxH+Do8iyG7hq3na4p5/deD/h7nfLZFMCId/V9huEl3ww4Vk0Or
	63ChHRzUZrX7O70ijbR1w/jhI9l4R5ajCM5iwcNeFLEtPGAxsUiauVyu5OrzR+4QbdodncMfOV1
	5Ig==
X-Google-Smtp-Source: AGHT+IFRbToo2Bwf5/5PfOGlLkyE9BQ/OcfapdUErqx3YciffbcOiyjfesgIMrMTUrj6b+h7cxqfj4hCOQ==
X-Received: from wmlv10.prod.google.com ([2002:a05:600c:214a:b0:45b:9c60:76bb])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:b86:b0:455:f59e:fd9b
 with SMTP id 5b1f17b1804b1-46205eb1674mr64702705e9.24.1758204329318; Thu, 18
 Sep 2025 07:05:29 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:12 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-2-elver@google.com>
Subject: [PATCH v3 01/35] compiler_types: Move lock checking attributes to compiler-capability-analysis.h
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
X-Stat-Signature: ztzg48b8nm61dfrw5jyu8p4ac46bbdtq
X-Rspam-User: 
X-Rspamd-Queue-Id: 159854001A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758204330-158506
X-HE-Meta: U2FsdGVkX1/yMnYcw5JrRY4UdLbG4050l7IAR4fJ3QwKn0prKppMpufIbXOyq59wjSLBkyWG+b3Urv01EzXUBfdGfTnGbhiXFW6ycDOPGBZmzDzmdZmUXF58Gvl/3lQoT0S64diGxzjTfijls5AxFBUYj2+49Ehatq4bCGUWhDjJKR8b3De3bBz1l3lhorBoq8CVZEEArpviuZdQEMXvnXm5v02yVqo0v4UZq3PI1gVGgMwLcPe8/u2mGtcvTK2soNtO/MvdTaA0ktxeoFL4KlqCXQF+FQHmFI5LtPZGBOF66Zco6T7IFQm4JjFtxzFobpg5pbjyj7jseWy7aeTWpqNpD7yY1GlttIJjnjhVz+dgjuO3gyUm7mCczGrZUTwqUPAjEFo/DU/sg5kpjIZ99o1HNzRcof3BKgLdpHqWWuhujUv1hrU59QXQ3rdxeakPT6NIiJzHCnB5xNf1MDI9t1a69Jdzve8nXhlsom7KW/83CNd8nWr+XHs3qclI1xeVECkBtekA+qxFkiZXXR+rmMvMLVf1DPRAdNUplyuI9Nm31liIOHP+0RKVPeD0ypIBvkdjowh5YAjSFsRQbDPqzapS8kTXSeStuxdFI7ZKJPyV1E9jT2oG3gmu8Gtv2MplXSYGFZLKb9/7XVwPUbOG5bZIa0xNyWmyKztw0wgIfbLDbXs1eteBEAdx6wkrZzp0FyIdFrdoLGJsyHlf/ZDbMsvb5+b/pfEzrTZNNwh6SSOcYgLtKpIMcvX26M8cvf8342/Zf3UjxKnXfrAaBv3XwYSDuTJMtkN/vd174yLETpS0yt4TITlAdRmZJSGtkvqlTaZ+VY35EdwZrzHdlCznPshNS88IZ29V1nhsfb4pQjMqL9re/hbLQkeu8d9TDqbwlWTXh48FuKYLsrvOLwPF7d4kAC0iNNRue+TJv5/fA5yy4oQzVv5fwh/h5XT/bH2ps3j+GPhZZUbBYeGj5vl
 cuOWx2GO
 LHnp93pEI2b1GO+vk7P2RDBTlRgpMVIo45068hD+8mf8UTEesu+0W/dxdpiiTbYsCEzkIy+0ZM7ITKkda3jtgUv8JOhEWxni03cK8tBBmxO7lPfZt5WeJN0SiPmsBlSMnY/htOi3dZwGdi8bTdc/6J57NdVhTnh7RbJkHDPRB7tFEUin44aw9ylE/ZDmdU7Uma9mcFVy3TSdsmW2xbeT+4+ky6AUJDtfOP4haOciTektxrlBx7uNRGBucRCy5/YJSYvVJjyshkg5CjO7Ii4+6PfjBnuYjmtlp/wfLnUl1PqM8ZnIHfY8SdTluh595UUS86eltsbCb6NWrCtaFO22odqI6KqfOF1VOq/ccaueW/x/SfCyAnWIOoY0vy7Rob+77KUxHbDHZutjBrznjYaNMshqRDl7Oe82o90xsOHFJ4fgd2+IYy4yUg+NGrLY+fwTNI0EM44M6fJfcB6Jyp46b8HnGUwgNhmRkkWy4YqtOoUdSU3UyF3QiXsQOZbte7lIszzzD/4K7yETxGFFJOxCR2SzXzv/g+bfF8qFQ9//c4BpXUseyzPWfGPQR+Pg+heqF7nGhVZOw/p5LodrdTTc/AnFoUerOIhtalUhEC4pilO8i8Kzo0QcxP/j+TswpqSqgcrLKckmcmFC4+sehtnW5bGShHdG3KIRUJ7fZDeGBb/TGDexB49ZwXNGHgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The conditional definition of lock checking macros and attributes is
about to become more complex. Factor them out into their own header for
better readability, and to make it obvious which features are supported
by which mode (currently only Sparse). This is the first step towards
generalizing towards "capability analysis".

No functional change intended.

Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/compiler-capability-analysis.h | 32 ++++++++++++++++++++
 include/linux/compiler_types.h               | 18 ++---------
 2 files changed, 34 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/compiler-capability-analysis.h

diff --git a/include/linux/compiler-capability-analysis.h b/include/linux/compiler-capability-analysis.h
new file mode 100644
index 000000000000..7546ddb83f86
--- /dev/null
+++ b/include/linux/compiler-capability-analysis.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Macros and attributes for compiler-based static capability analysis.
+ */
+
+#ifndef _LINUX_COMPILER_CAPABILITY_ANALYSIS_H
+#define _LINUX_COMPILER_CAPABILITY_ANALYSIS_H
+
+#ifdef __CHECKER__
+
+/* Sparse context/lock checking support. */
+# define __must_hold(x)		__attribute__((context(x,1,1)))
+# define __acquires(x)		__attribute__((context(x,0,1)))
+# define __cond_acquires(x)	__attribute__((context(x,0,-1)))
+# define __releases(x)		__attribute__((context(x,1,0)))
+# define __acquire(x)		__context__(x,1)
+# define __release(x)		__context__(x,-1)
+# define __cond_lock(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)
+
+#else /* !__CHECKER__ */
+
+# define __must_hold(x)
+# define __acquires(x)
+# define __cond_acquires(x)
+# define __releases(x)
+# define __acquire(x)		(void)0
+# define __release(x)		(void)0
+# define __cond_lock(x, c)	(c)
+
+#endif /* __CHECKER__ */
+
+#endif /* _LINUX_COMPILER_CAPABILITY_ANALYSIS_H */
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 16755431fc11..c24e60e75f36 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -24,6 +24,8 @@
 # define BTF_TYPE_TAG(value) /* nothing */
 #endif
 
+#include <linux/compiler-capability-analysis.h>
+
 /* sparse defines __CHECKER__; see Documentation/dev-tools/sparse.rst */
 #ifdef __CHECKER__
 /* address spaces */
@@ -34,14 +36,6 @@
 # define __rcu		__attribute__((noderef, address_space(__rcu)))
 static inline void __chk_user_ptr(const volatile void __user *ptr) { }
 static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
-/* context/locking */
-# define __must_hold(x)	__attribute__((context(x,1,1)))
-# define __acquires(x)	__attribute__((context(x,0,1)))
-# define __cond_acquires(x) __attribute__((context(x,0,-1)))
-# define __releases(x)	__attribute__((context(x,1,0)))
-# define __acquire(x)	__context__(x,1)
-# define __release(x)	__context__(x,-1)
-# define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 /* other */
 # define __force	__attribute__((force))
 # define __nocast	__attribute__((nocast))
@@ -62,14 +56,6 @@ static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
 
 # define __chk_user_ptr(x)	(void)0
 # define __chk_io_ptr(x)	(void)0
-/* context/locking */
-# define __must_hold(x)
-# define __acquires(x)
-# define __cond_acquires(x)
-# define __releases(x)
-# define __acquire(x)	(void)0
-# define __release(x)	(void)0
-# define __cond_lock(x,c) (c)
 /* other */
 # define __force
 # define __nocast
-- 
2.51.0.384.g4c02a37b29-goog


