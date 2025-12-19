Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A16CBD7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176846B008A; Fri, 19 Dec 2025 10:45:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158C56B0092; Fri, 19 Dec 2025 10:45:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04DEA6B008C; Fri, 19 Dec 2025 10:45:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA9096B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:45:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D3FAC0489
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:20 +0000 (UTC)
X-FDA: 84236644800.09.A7E9461
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id A1979100015
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j9bRZ1Ns;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3DHNFaQUKCFk5CM5I7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--elver.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3DHNFaQUKCFk5CM5I7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159118; a=rsa-sha256;
	cv=none;
	b=J19lEEGq/bN89XzIIuEjFIkPlkywsdUux1OS52DgO+RgPZEGWOwjAm4AmRbZr592i4HZeI
	LDSUjODJrqakaQuiU99u+xwFIx8gFSr7h/d/XQwEzVif2X/4o9lR4cfAKTy2aqo9cAsR7i
	duNhVC+131DiX0AKSVqSAUY6HyX6GzQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j9bRZ1Ns;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3DHNFaQUKCFk5CM5I7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--elver.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3DHNFaQUKCFk5CM5I7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTTrpDgY6boLD/2fqquzR5fZiR/OECGrXMTsYaAZTdg=;
	b=k3LWyHR10StAoyKwuD5XSSA+dP/BU4QihW2NY4M7df9vzZVy6v+zNpNf6smm6hPjqvSwXl
	odnwuAOAwAyGecUHVszTUECfmonVEIF/o0Txlzn6AM9Jsxg8L3S1HIxvrPqYbtcTUYJp61
	hDx0Y+X6cZdsosuwAoGtGvHNwJfDIIk=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64d01707c32so9129a12.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159117; x=1766763917; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uTTrpDgY6boLD/2fqquzR5fZiR/OECGrXMTsYaAZTdg=;
        b=j9bRZ1NsAA02bA3TaQ2PvVjB8UYPUuQPm8chkbH+AtRTP3P+FaxkLRHecQWGwT2eNo
         KIV/B4WsNi5gAaIxoQ0qoSpacpXqGzBwfj8ZBATDoz3hc522BvmEWMH5SrZmOFmsIrwE
         roz0ZLYa4EjJBiN7reHRrusBHddAxUmrfX5AfeRJBiagNPoaVXLfFMQNhD8RLv3RwJbC
         wuwJxzaoLTfwHWaObJRg6H3QzqK2Od0zef/bzj0j6W4B3puD8nnDq3lnxOTTkGu2i8oe
         FHYdOkDqtVXEtxdvVR0W6fiFVHTSly1wEj8C8QH/z6bAIC39CeODf7Zobh5Yc4pwUrO9
         E1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159117; x=1766763917;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTTrpDgY6boLD/2fqquzR5fZiR/OECGrXMTsYaAZTdg=;
        b=cvjg9YBA8lMNB0MFbeZOOIE9gi28izzzJhLXF6NK1tNbzFulNNPECHYodIVTOYIzCq
         OGQ44wA8RJHq2vHQEGqVEzeL5MGHNs6pORpCo7eNEy1jEbcpFtZUB+paU4CkEkMtx9lw
         8ubnli46D4Qo7t5e+jrvGHrnR6VCQAFIIUtbOH/DG89T+AVr3sx6WqZUFSafmtDOMdu3
         pPRHTT5qem7YDhhTe5UQz3VDyS2e2SIqyLdkLL/v397yDjdE6iP5uA8LQXHQo0f9idj/
         78uj4Mhna0Rw4twDyJ7V19i06RXfMBbB5V+JVWbVdKZn8NnPmS2uOUTsqgxYHJUV0/j1
         MG0w==
X-Forwarded-Encrypted: i=1; AJvYcCVDCBH65A+5mIHbyeds6583cPXdK7c7h7+RXzs1gPMkqpI9c4zpQs9kQhisAfHIl5f2aWqOQuaNEg==@kvack.org
X-Gm-Message-State: AOJu0YwHTHzWPkUdjqcBTgO4Mfm4dxiYzsf99VHuxbiM+dw+sVo9uixN
	76eU/pvkrypl2Dd09hyh4D1pByV3mrFsecAxiTAlpt3Uk88qjavLpAdWAZRvp7jZ9ELtqb8cZhM
	A5w==
X-Google-Smtp-Source: AGHT+IFIQlGi8phgPKpWRTwxqlF14Y73hlUw2TFGVrXDbo950uyglJ5sCcodZJR2/zFCPCPTqrJC0MUdYQ==
X-Received: from edvd12.prod.google.com ([2002:aa7:ce0c:0:b0:64b:5a31:444e])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3582:b0:64c:584c:556c
 with SMTP id 4fb4d7f45d1cf-64c584c586dmr960916a12.30.1766159116689; Fri, 19
 Dec 2025 07:45:16 -0800 (PST)
Date: Fri, 19 Dec 2025 16:39:50 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-2-elver@google.com>
Subject: [PATCH v5 01/36] compiler_types: Move lock checking attributes to compiler-context-analysis.h
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
X-Rspamd-Queue-Id: A1979100015
X-Stat-Signature: ufh4qx8uj41u7ug53nuxc95x4sy4zacf
X-Rspam-User: 
X-HE-Tag: 1766159118-973667
X-HE-Meta: U2FsdGVkX18esj16gddBeKUyH+AIHVuJl6bvTQpu9YQYJL2IDJ5Ng5vBu8tLpALAJdDhv7tLivpA5YZeBwYN833qHchPIaYWwRp7W/cl4qbyZt2AFiJ9RJhSB2hNllDjeNLYrNVBoXHac7XgNArmiyg+HvdrYFfinDU1ovxCzBN81VxHlyc2fs1a9g8KMrsdgM7+HpPIyAROlDwD6fi1yjiL0eePr3aWwgOY1VKm9OjRK+T0OAkpq6a+HADyAEfa6C+hg/o42Ab5Yh3OCArXokBxPKq1EMVgucXiZNe9SJbugr77d8M/SMIvGu5fD6Tatzen6NXqBeDoUeducMmVjxdXc3PC65Kz8P4hlgEVM41xZ3YkazInfd4Z58B+gv8pINzYyxHbJvilEEoCokHZvFsExAc8X/Jmulnv1XhHTaBBlVt/XCy9fT/TlXY3WYbyQta1RPwvKb7VhCzfxs7oX+XvAjUZHbOIaaYALNXh55DOHfgKzKWkebsyJAJjaA8fH6Apq4IH6UehK1bGm9XqSzVhj6FgbcORvDq73nJ+25Dt8yIf9GVwvpHRcu3jkZ45r9WXtGEpcB3teBtIjXeXEFIv/+ujVg7xjQnhh8km7afcZbHUSkWwRcjrc+ysZRBUC5h9/ni1L9ezbcVattm8tlEfKKa3ptmieV/tryIZ2byFLwWPJuc/+vogfYfp8CzE0YAOW+9kj5lm3V7mn1O1pWRo7x4R7e7EmdAE7/POUiZIJt3rpUpJET09bV4fN9L20xqH0wa8F7d9v6tqwA5wqroHDOMg0W2aOghaMQqk02x9U5htG+bdHkW1tEjshpOwSN71J5IU8ecUS3cPev2zxzjX2CKs72HeT36mcAqeymd2pTTgJFw+F3J300XL6ff86CrpvzYPjMDHG2x84y+q58T4yy6x92KZRIR1HpHXYky/yh9NdG3uo5nPI4BBGycEDkEh5Oh4agh5C7+JurC
 4rYHFVMa
 2ZA7lQGGxh2AxWdKZBDrJZ2QVOJZn/wR2HantGALue1MCqdc8592uCcrmT23xjBQoRTm2GHDhWvMeAFXARS3Yi548lylSM4LMkzWBju6/bePR1zexKg/G6KpO+mgkuZjg7piD0/B8MVLQBc/NwkSKYOaBlQuX3BArb6VFY70j9Qhfi3PL6ZTbpopQ7dh+Of5OCp7ESr+A2vce8CDo0sUanfaucBjmRO5SkqFyAKuenwD3PDhcVu6J7WTZFeXxGuidG3Q703eim6JxB12heb2dJElwUOAajlc7LmBAuxDfTbbkJnBatoS13IaaEtoJDaLaD70BBewpjR1QM8ENa7p4y2CPziYxCEDBaTG3JgHdc77T3gpTciPE2lRcaywxh8ZJIadP1X3x0Q7uVROZZ7HlIagdvU01oRM3w5OP3SwlPZzm1wYP87bvwx9pETtnANRP7zfvRggw3R0S4GfRMCAYOTO5iNz+/buiuX6mdfLv2yD/TSwU79HyOoFB/SPZKYtI/QN0pEeWMci+0PxZltoFMveILeaR/6YX3ZjaUXaeEmjLrxUVy/P3nNNDYCkedgU85Ri4cLq2QAvnR8BM7QraPPLIrFGUEgEIquOiKbXqHd0I5tq00nEVLCOEZoDW8xn6rso3lpQ4eMukew+VuqmogSxLP8CPyzmgCUxaB0oBI6t5WwiUzRHRLEA2bsMSe8bBE9zMqM3RFdsL5VCJe7iidMyX+ICo6bz8WaEzjWgDFrfS7UZaSCBbS9Hcdj7RnyV7dreUPfXMgK6Uq9U=
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
index 1280693766b9..ddada1ed88ea 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -41,6 +41,8 @@
 # define BTF_TYPE_TAG(value) /* nothing */
 #endif
 
+#include <linux/compiler-context-analysis.h>
+
 /* sparse defines __CHECKER__; see Documentation/dev-tools/sparse.rst */
 #ifdef __CHECKER__
 /* address spaces */
@@ -51,14 +53,6 @@
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
@@ -79,14 +73,6 @@ static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
 
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
2.52.0.322.g1dd061c0dc-goog


