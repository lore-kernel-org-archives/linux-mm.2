Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83CD3CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFCF96B000D; Thu, 20 Nov 2025 10:02:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD306B0028; Thu, 20 Nov 2025 10:02:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75106B002E; Thu, 20 Nov 2025 10:02:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B15B26B000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:02:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 706F012DF38
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:02:51 +0000 (UTC)
X-FDA: 84131302542.16.2C43722
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6C1F310002A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:02:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TUBfRIOz;
	spf=pass (imf05.hostedemail.com: domain of 3ly0faQUKCL4ipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ly0faQUKCL4ipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763650969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xm08Oqaiz0C+41w88sCv4Knf0HeT4Y61beURoEgshc=;
	b=UjAq/TYlhfiROaqc2vdnjodc1RmhDIrSaJivekrZiqV3GSsI3mhdfcDUPWbb8yllGWr1Ir
	kLRzrWIKz12NT71tjXe+V1dNZCjHcYwKoz3UeFbjyJqQoxU9dns14YADCr+IIWYXxeLfx9
	gnFmIc626PZrdNnDg+ozOyDpQVp6zgc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TUBfRIOz;
	spf=pass (imf05.hostedemail.com: domain of 3ly0faQUKCL4ipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ly0faQUKCL4ipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763650969; a=rsa-sha256;
	cv=none;
	b=KMp3xJdGHy22iioB4fS1FdK8S40+x4dEQ0DGH8TYvFts6ifM38C7wB0gA7Z2QXMfo4eJoX
	an4ZcrIoIYYr/YmmZnv5w8KfCE9csQqMn6NhhJaqs2wrWaj35pAACYdBdlNjkJ1CYTsso4
	kczu27fAlCeytouHVpKgRHKeu53ybRg=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47797caba11so4146095e9.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763650968; x=1764255768; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+xm08Oqaiz0C+41w88sCv4Knf0HeT4Y61beURoEgshc=;
        b=TUBfRIOz02aF3hlJ3KSoExiiu3jC1KgnkmYlcCG6860VnTeil0ak+xtoWnB2uM0Duj
         mT1leSHCeQNBt8AiT6ybEyCghWQYhA3KH63wtvgHnwPGx2M5iklug37zJRrHiUMynAcM
         qeyb4M3OS8LRrp+AFC1EMd7EcR+15U1K7WEbYoOWDNbXeKbu8ENBf/iI+H5j7hiZ/6xw
         tGsxqez436zqyn0wL5NeqT/KHlO8PiIURRtlkYyl51+lDVovflRawWphtsjc0PKqPWKM
         LJJBYreg8AMGgKpA/5OLgeIZO/C8WTlcq54944wEFn2aRlFHtUNCkoYbr3brfMb2EhAd
         69cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763650968; x=1764255768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+xm08Oqaiz0C+41w88sCv4Knf0HeT4Y61beURoEgshc=;
        b=I8wIJ2pKspcZqVgtn93h9HhMjC/vJ7tZoZH4R9vO6SeJkjTss1s4i5gkFxykoATrOV
         bvymTBrk6mxKI7l5S9wh1hnFiWHkVhdaE4TWawAQfr9O2gGHW4wwZDZn+z+fdfQI7cCg
         ZrEIN/iDOZXpAaERmT+KKLn3pcr9WYkAsTeKMlr2huIlR71h3pZAvy40twGD6S0Yarj/
         skxzriUCw/TcE6jyZ/VaRxMef0BMt0Jwlft4ifD7TWS/muiN1hI7s0fQK1iah9JO7nOa
         L4o1MCNEkycY7Zrf8QDl5KdxIEdb3pIXMhI18IaB7D0K8rfUdKliVtktWB/inWimu5Jc
         dw4w==
X-Forwarded-Encrypted: i=1; AJvYcCXsSKU4yIOE5qMpzsTsLAYCEA1kkLSFPKIU13UEZCuhe3dIFI30vltTDKAvZT9k+WGL1aFy4EY8Lg==@kvack.org
X-Gm-Message-State: AOJu0Yw4frFfmQCTR2OINkqv9Klo0L47dq8821wtbaKpsneQwraqQhek
	iyircuSoialRz3njEA0L0oms8WfHeGIuuLEcj22XhkBzGDUQtvpxznuMzQNVpqrbjrpF7dMF840
	/xg==
X-Google-Smtp-Source: AGHT+IGUHW8T7PbhGDmbj5YjoSY8aOAhL/hfcFkM7c1fjnxT41/dPSOy7IIJVzHNh1nc5oCgWusA4fLoNQ==
X-Received: from wmbd17.prod.google.com ([2002:a05:600c:58d1:b0:477:76e1:9b4e])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:470a:b0:477:1bb6:17e5
 with SMTP id 5b1f17b1804b1-477b8d8b887mr39140845e9.30.1763650967589; Thu, 20
 Nov 2025 07:02:47 -0800 (PST)
Date: Thu, 20 Nov 2025 15:49:03 +0100
In-Reply-To: <20251120145835.3833031-2-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120145835.3833031-3-elver@google.com>
Subject: [PATCH v4 01/35] compiler_types: Move lock checking attributes to compiler-context-analysis.h
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C1F310002A
X-Stat-Signature: 98nc5cfaqxwnphm57isjbwjq743apm7q
X-Rspam-User: 
X-HE-Tag: 1763650969-933222
X-HE-Meta: U2FsdGVkX1/uhFA0aX1dvaZFmTt3fQyxgjlFthz/FFdaSh2j7znOiG9hJg0BFzxBIwLODifBAEl7T1MYs1OFpLICRokwSImqEw6xnrTottIuDdTFzzZI53GXsgNBGOv9PxfotCWPeA0z5jpAzdOCc8jMHATJzO6VDzZbIGmgUru2RGbh9wdLd+HjQdTOiqUOgOJBpqzib9fmd4gsPVxPdFo9N1AhWZFb5nr2nHKB8152uZMSuqVeGRnKEiQtJ7nwmuq9FxqLZZWiMufhMiw3GzcM/0oilcjkIVTEY3qoD3emMwZPPiLy6oHXTeg8A7Pk62ll2FtXnTig0w32kEBAlP+ghiaKqYd8YPNdGSHC6Ov1iBO2e6TjbNXvJ4kadDgX6zP6XNdr88mV4FdJsvAizLN4COTWpqsWhitKgw9JSu0XzdGrqV2AmeHN8rLL+uQxLufllCFr3SO+WECsiG2BetHg5Jbu9Nwe7MsE9s8j3JXIeVKxaZTM017MbdwwWDZM7m7/iDT4erJEY6sliVD2nfTWPCZhLJ3pZxQbN1ebVWBGGetRYfsRLtHjOWmo7yAR91BC7be/x9MCOb3IB7ndrUCGYS3UsslbwH4Rro9D9jzDeMGH2EqQBImXA4QVVnsmWm178jl9gEjziWU61oRMNoAVAlT0H6nCCGqC9wHsvQ+TWmMn//GkGidOcwJ3UarZASsK2PM6KzN30lAyM8giL3a1iNfHGB9iD/dQa60FvXzjhIyKCtvc8173d/EcAp78RNCOPFWdg7wjtYD4Am+2v03dY3XmCCZQzVh27lqwd33Vs+2+/HLVko33aDMGE95+Fd1wAz+a4QprMLpyINwF8UC8P2M0IXTziyTu8VemPfi5nTWmPwlG4e2dtmjIGxametIz8WC9VkIYuDgWXAR2od4GxABAxUeTfpS3lKOkFUvDB5YI0fK/vR1rqgZNPgb0HgurJnATjE3IzJPaY4w
 Rv9qcD0b
 oFetJLwuKUYI1by2bWJca0qEHUY0P4NDYAIVulNQtuQ4vf7uov0I0J1luleh9yQDFBt/FPUHEyX0PSnqcJIKvjKyK9stA0IkjWH2GSeMct5C3soZnYryvxyDYsbZhBZg40rRYa35MaSOTQZInNtDObe62IhsYPpwB5Mf3Jjm3VtYb5lTcAD239rm3cJLOC6m/FiXtmTYrioq4HA7Xc1Ic2+Xi+mnQzjbhkqkw37B5+csZIw9VAXIZPcklaWnDcFHHoB+M39PLpqf6hf6aB+u3k7xjBKyEpmLvWhCacvinmbRhEALfKxc9TRFUgwfuBN8ImstofFJdQ0YQCIZ5LCjXR/nOZZKSPJQx3Ko++UxUKZnLB4l3iKwJNji3VEG/kUMTxVo2tZVhItdq+uLFJ6qlVhhxWXlB99QmA4L/FdaTtdWga8SMruGmCFPoCpXSL81Tv7L9kY0kkcz661a7HTbuzTT1Su1Upy/6MBoNqUKci/QQGXF/PEZvT2LS2tl655d52AWnF/M7Oxfp5xlqxZ4DHQXfe9pHmB+C7a0ApmSwDHxaE+Zkpt/fitFID+BUeCp+grd0Rrym1YQOfHIh5oF4Z+rVfFI6grYXiwjpjSVp6HQCEXr/YklY1T41ZEjJJlnyQenMZEP0cJPvg3coy4WQbPftR3RtgvH2rtea6z71j69dD0IYEHpwL61UjSr4uhOqukwTpbikcP0WKioKWVtPLah13XRnjbcZERKdJ8zOM/LE6SBbqFSSlNd2Ae2J3+eKg+3fJYJ2CMOKPT2bzlS5yVNDX3QLUVoKQ66ZnebFE/5RaP4=
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
generalizing towards "context analysis".

No functional change intended.

Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
v4:
* Rename capability -> context analysis.
---
 include/linux/compiler-context-analysis.h | 32 +++++++++++++++++++++++
 include/linux/compiler_types.h            | 18 ++-----------
 2 files changed, 34 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/compiler-context-analysis.h

diff --git a/include/linux/compiler-context-analysis.h b/include/linux/compiler-context-analysis.h
new file mode 100644
index 000000000000..f8af63045281
--- /dev/null
+++ b/include/linux/compiler-context-analysis.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Macros and attributes for compiler-based static context analysis.
+ */
+
+#ifndef _LINUX_COMPILER_CONTEXT_ANALYSIS_H
+#define _LINUX_COMPILER_CONTEXT_ANALYSIS_H
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
+#endif /* _LINUX_COMPILER_CONTEXT_ANALYSIS_H */
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 0a1b9598940d..7eb8d8db6c28 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -24,6 +24,8 @@
 # define BTF_TYPE_TAG(value) /* nothing */
 #endif
 
+#include <linux/compiler-context-analysis.h>
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
2.52.0.rc1.455.g30608eb744-goog


