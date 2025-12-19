Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F0FD7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A223D6B0093; Fri, 19 Dec 2025 10:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D05F6B0096; Fri, 19 Dec 2025 10:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CFD96B0098; Fri, 19 Dec 2025 10:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BCB86B0093
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:45:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 499871602B6
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:39 +0000 (UTC)
X-FDA: 84236645598.13.A296463
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 63B8D120012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ljsq+SCt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3H3NFaQUKCGwOVfObQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3H3NFaQUKCGwOVfObQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159137; a=rsa-sha256;
	cv=none;
	b=byUIm76n/egMET0W411CHpa+iG8TPBLZzvcUw4GnaBfITzlUAk7canEWArMquyrXTxCzNd
	tRO4SF12kPToP4qIU+0WtlJapvwtI1i3oeesEhdsOPlYZ4UGXW1f9KH4u2z0/WNRVQJQrx
	oXqNN/xWSWXmQYF3BZR89b0ftozRXuI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ljsq+SCt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3H3NFaQUKCGwOVfObQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3H3NFaQUKCGwOVfObQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNypD57EGX2MX8ivTIXP0XbqOR/mFQo2ssZAJ4O2zXU=;
	b=rHuU9v/EoCQaOOA7inUq86wn9uUNLIIdfn6kuj0B/UzozfR4xcb9VH9LDCCf8DL6IRs6bl
	FV4M3lSOUpb9pa1M6XzkVE6m/m12S0quvKjB/6/nor5Ow3I2NGVax0riZ30XGgxqwCA9nO
	1uTEoluasAefciyCBmVVMr9t3RqYnQU=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779da35d27so17886315e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159136; x=1766763936; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wNypD57EGX2MX8ivTIXP0XbqOR/mFQo2ssZAJ4O2zXU=;
        b=ljsq+SCtVq70D3UA+L8VydTAtKDoxwD7Ow+9nYWIRyICaaG2rygDkahv2iykj6DiSQ
         Bx8kJgLcKvHIFqu5yyQlEQttPXtePIyH4HsMFRJTvFZOJmn3Xchm3NjuBq9JEeP1zpU7
         ah54LBjYpK+eOY6e16v/y1TEHwqsgDJBMTYFJIfAKZTLlLKf9popSyTQzDWpRcAtA0Z+
         L3eYzi1ke/hqXhKJ6dzhhMrq+gsvvOumNJJyTpOWsgIhQ9Kz2Bh/cqMK0+CEI2OBAIQ/
         6JSOnluAKfdB/V8YVKC5531DBBuzEJiiKvjDqjmIduhc0ycLEgglEZJuvE8EUSBqdo81
         7N/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159136; x=1766763936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wNypD57EGX2MX8ivTIXP0XbqOR/mFQo2ssZAJ4O2zXU=;
        b=DexBo10adFYR30ZlBoQdkNkJnIW0nJZjQH1nm+ewpa+2oGAmIQ57Drm5kML9Vi20uf
         YnknuCksdxFMNoo6MRZMR5HJZ3b7o8+Ug2r+ruYHG80BiwN6XxiKPCYK2TyMMtKWT1cj
         QeyQOUDFd5X7W8Mu7zZFLSr+QfQ2Dc2BudKQl5gW1W6EQC3s7PSLHMB4XTK8ABvf5Jkx
         xWH4oLbEjTDB+TsW/XTNNoRIif34NyIhsZphkoYSccAFJS+vx9ydmRiJtLhQYPC8O7an
         zqNBEDcpyYOz1BWb5gyub0EEqSNYn3ST/bAhkLz8xbSNxaj18nO/V5OUy0YMIQdA7rWN
         Dxcg==
X-Forwarded-Encrypted: i=1; AJvYcCUF/bMxcFv2rfiMmYkWl7dyQ2cnciMVKOhfnEYPmxwq40PzHO+yQ553S348z1GnfMH6UZBMr+cjIw==@kvack.org
X-Gm-Message-State: AOJu0Yw7ZNG+LQWwFCZkS5sL7MBuoXMz0e6ofiVyxAjmQsOF/KnfmaSm
	OQfCt1THqcPj5riLnZci1MXjjA3S3Ij+kO0hDb/NJhFJvhfHdEHZJMQbfSKNy1lUsYzsLWsU/VO
	W+Q==
X-Google-Smtp-Source: AGHT+IHXXBJOd4wvSdy3ALXfB4Mt0dokW3EvzdUSRwHOp88UE22ws+JWjg7YwUgEMwqGcjEmAiNPIAdtCQ==
X-Received: from wmco28.prod.google.com ([2002:a05:600c:a31c:b0:477:9976:8214])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:828c:b0:479:3a87:2092
 with SMTP id 5b1f17b1804b1-47d19598e86mr23981475e9.36.1766159135626; Fri, 19
 Dec 2025 07:45:35 -0800 (PST)
Date: Fri, 19 Dec 2025 16:39:53 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-5-elver@google.com>
Subject: [PATCH v5 04/36] Documentation: Add documentation for Compiler-Based
 Context Analysis
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
X-Rspamd-Queue-Id: 63B8D120012
X-Stat-Signature: aqa61semugbfxjdhykxx7hetk39gm4mq
X-Rspam-User: 
X-HE-Tag: 1766159137-993039
X-HE-Meta: U2FsdGVkX19SVUHp0vrtFC4MuffQIM7YTD/A8UwnUEgla8GLMvA3irHFrtg1qjlSCJD1BGFpcGeDfXxRxRb5oYy23MY5OzW5qz+0Lu4jLFCacaD6p9f1FYIUedbuZCKFVvsS3Obr2uXM1gPRuTYWvjbf41WdA/6ZxOOXblfh9TrI3HfxmfW4o6tpe92bd13sCVg/DHSuOtCqrmF/M5E2hMzvJX7u2kv6Jmx2+TQk2njF0RCfPdjmYsny/e5hPi1+lrG7DeA89L1Bp0hee5FmLZNizRH4TTYqpYWbTsCSOdtS85IVbAQoWW+9dctcbT2nJVfypRvwNOeA39SpABbvgAiWMTiSa02gy7cvhEjpRLR7/vCGLoyPo/o5ZzA2RW2Gp7wMemFSB99CEa5kDm3CLsdc/txzQhelW9+9OuK3CnFWW6hugXSb+50vsrL+xX7SOhAphTAIJgfvF95kwqawrhWB+qAkalwbpj3iNNpULUPGoUYNrECbhNgiZPGzClDvDvJvsyx7q9gXHziMu6BICreXVNfm4iK78MlDfL9GxRvVEGXY7NfB2eNYm3e6HMBShVm92DPoYBqdybVPT1BusGsV/Ng2DB2w3f7JfMrOXghL8egmL+ClGIma6d5EBcb1CL+vCV/mPIhKiFnYXGLZTsZvGiWAQlvBAedmZYTOHbbuC/QRWffdMRIq9jgsdSIK+YtbFNOHSs8cupJ6lo5TWazvV7lpkoowHrfoEu7IQ7NMhkwU0Jgut6Cy+qY0swYV0p0pWUnbAWojFeZ64ox2Edkz6oipqkR9TUeQ0wFQTImb5gYE/95ChOzlkjJco/r+XsDsEk/GFXn2f92G+3i4qRvry30GNEoj9FPtoGw1dRA2do+MMC+Y3/SleL4wKWJm475SrDobGXM82J//wHhzYCVae5LjRVpumIjVmq6wWVaUORXokMyEpB1wEgWVvmYMBdaNGZSvF201iSdM7cu
 AiwtPgus
 pbZMgrFe0hc33iRAUR4ED4wSWDfpO0LsRMSbr3Ha9w4CtX6HGsk4JIqnCkYEJJZr6QO4mEk7BcDrg7MVrwEFDXuEaQEJgB0Vh++4Or/NIx3rYSeyzcT4OmsvjGlcNbzr31ee9JVJ4JDh3rOfCAu8TOWVWExGOYJDusyM3LrLZgG9uwUrqgxfBV3jk8RuYTVz3n8WdBgtab47JvE8shWZnrRkk4k8LCwHs0CjbGWcWXh8JP41MTem4bb6co7DfkvYnF7+RwgkU3KHzLBTooyl79ubY0uk6+LG4tpoeUMqJ4Re+u6ZS2GxICCs2RW2B/NDRKuJuUsTu8eZS+E5KWgkTjJZzkR0b7zs1wHDUIE7jQydl2XIm8krQ68yqlWN9k0WMZpBohWKrJhZ7LXWNj9fp8sfeRTCtuKPTHii7yTVwZf/sKph2jgFbI/nUmTJ07WXZ0pwsxUm8yH/gsQA8BLNF+XjXP3a+BGY+Z+KVrv8dIL9MkucXEA1QUJaQRF5QcYchjl0F7l4FXK/s0ZxIiXaNYFStexA9yuKO9AvzNQDalVZQSZrfyRTXZKbneyISpThvl+TMFs6T0IrERqByScEoM7BIbAItrLmt2878VQq5YAGHuLOIS5LPQaPPJ3Wa/Izqm2WDJPjhe7opXQp/PSnTL9XeayZ/VBmlLGoUBf/Kfar0uNWb9uwpb49pHwlDYQ0PZfSnY+FWTISSJmOtix+KtvpgzdeQAS1Klz7FyRqHDhaMM4lQ00A8qTrUg2q1xLDFo5gNNbQnd6Mrds3VtyxbJGRgqbKwtrIc4TIGkwVr0ZPgYSE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adds documentation in Documentation/dev-tools/context-analysis.rst, and
adds it to the index.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".

v4:
* Rename capability -> context analysis.

v2:
* Remove cross-reference to Sparse, since we plan to remove Sparse
  support anyway.
* Mention __no_context_analysis should be avoided.
---
 Documentation/dev-tools/context-analysis.rst | 144 +++++++++++++++++++
 Documentation/dev-tools/index.rst            |   1 +
 2 files changed, 145 insertions(+)
 create mode 100644 Documentation/dev-tools/context-analysis.rst

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
new file mode 100644
index 000000000000..47eb547eb716
--- /dev/null
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -0,0 +1,144 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. Copyright (C) 2025, Google LLC.
+
+.. _context-analysis:
+
+Compiler-Based Context Analysis
+===============================
+
+Context Analysis is a language extension, which enables statically checking
+that required contexts are active (or inactive) by acquiring and releasing
+user-definable "context locks". An obvious application is lock-safety checking
+for the kernel's various synchronization primitives (each of which represents a
+"context lock"), and checking that locking rules are not violated.
+
+The Clang compiler currently supports the full set of context analysis
+features. To enable for Clang, configure the kernel with::
+
+    CONFIG_WARN_CONTEXT_ANALYSIS=y
+
+The feature requires Clang 22 or later.
+
+The analysis is *opt-in by default*, and requires declaring which modules and
+subsystems should be analyzed in the respective `Makefile`::
+
+    CONTEXT_ANALYSIS_mymodule.o := y
+
+Or for all translation units in the directory::
+
+    CONTEXT_ANALYSIS := y
+
+It is possible to enable the analysis tree-wide, however, which will result in
+numerous false positive warnings currently and is *not* generally recommended::
+
+    CONFIG_WARN_CONTEXT_ANALYSIS_ALL=y
+
+Programming Model
+-----------------
+
+The below describes the programming model around using context lock types.
+
+.. note::
+   Enabling context analysis can be seen as enabling a dialect of Linux C with
+   a Context System. Some valid patterns involving complex control-flow are
+   constrained (such as conditional acquisition and later conditional release
+   in the same function).
+
+Context analysis is a way to specify permissibility of operations to depend on
+context locks being held (or not held). Typically we are interested in
+protecting data and code in a critical section by requiring a specific context
+to be active, for example by holding a specific lock. The analysis ensures that
+callers cannot perform an operation without the required context being active.
+
+Context locks are associated with named structs, along with functions that
+operate on struct instances to acquire and release the associated context lock.
+
+Context locks can be held either exclusively or shared. This mechanism allows
+assigning more precise privileges when a context is active, typically to
+distinguish where a thread may only read (shared) or also write (exclusive) to
+data guarded within a context.
+
+The set of contexts that are actually active in a given thread at a given point
+in program execution is a run-time concept. The static analysis works by
+calculating an approximation of that set, called the context environment. The
+context environment is calculated for every program point, and describes the
+set of contexts that are statically known to be active, or inactive, at that
+particular point. This environment is a conservative approximation of the full
+set of contexts that will actually be active in a thread at run-time.
+
+More details are also documented `here
+<https://clang.llvm.org/docs/ThreadSafetyAnalysis.html>`_.
+
+.. note::
+   Clang's analysis explicitly does not infer context locks acquired or
+   released by inline functions. It requires explicit annotations to (a) assert
+   that it's not a bug if a context lock is released or acquired, and (b) to
+   retain consistency between inline and non-inline function declarations.
+
+Supported Kernel Primitives
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. Currently the following synchronization primitives are supported:
+
+For context locks with an initialization function (e.g., `spin_lock_init()`),
+calling this function before initializing any guarded members or globals
+prevents the compiler from issuing warnings about unguarded initialization.
+
+Lockdep assertions, such as `lockdep_assert_held()`, inform the compiler's
+context analysis that the associated synchronization primitive is held after
+the assertion. This avoids false positives in complex control-flow scenarios
+and encourages the use of Lockdep where static analysis is limited. For
+example, this is useful when a function doesn't *always* require a lock, making
+`__must_hold()` inappropriate.
+
+Keywords
+~~~~~~~~
+
+.. kernel-doc:: include/linux/compiler-context-analysis.h
+   :identifiers: context_lock_struct
+                 token_context_lock token_context_lock_instance
+                 __guarded_by __pt_guarded_by
+                 __must_hold
+                 __must_not_hold
+                 __acquires
+                 __cond_acquires
+                 __releases
+                 __must_hold_shared
+                 __acquires_shared
+                 __cond_acquires_shared
+                 __releases_shared
+                 __acquire
+                 __release
+                 __cond_lock
+                 __acquire_shared
+                 __release_shared
+                 __cond_lock_shared
+                 __acquire_ret
+                 __acquire_shared_ret
+                 context_unsafe
+                 __context_unsafe
+                 disable_context_analysis enable_context_analysis
+
+.. note::
+   The function attribute `__no_context_analysis` is reserved for internal
+   implementation of context lock types, and should be avoided in normal code.
+
+Background
+----------
+
+Clang originally called the feature `Thread Safety Analysis
+<https://clang.llvm.org/docs/ThreadSafetyAnalysis.html>`_, with some keywords
+and documentation still using the thread-safety-analysis-only terminology. This
+was later changed and the feature became more flexible, gaining the ability to
+define custom "capabilities". Its foundations can be found in `Capability
+Systems <https://www.cs.cornell.edu/talc/papers/capabilities.pdf>`_, used to
+specify the permissibility of operations to depend on some "capability" being
+held (or not held).
+
+Because the feature is not just able to express capabilities related to
+synchronization primitives, and "capability" is already overloaded in the
+kernel, the naming chosen for the kernel departs from Clang's initial "Thread
+Safety" and "capability" nomenclature; we refer to the feature as "Context
+Analysis" to avoid confusion. The internal implementation still makes
+references to Clang's terminology in a few places, such as `-Wthread-safety`
+being the warning option that also still appears in diagnostic messages.
diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 4b8425e348ab..d864b3da4cc7 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -21,6 +21,7 @@ Documentation/process/debugging/index.rst
    checkpatch
    clang-format
    coccinelle
+   context-analysis
    sparse
    kcov
    gcov
-- 
2.52.0.322.g1dd061c0dc-goog


