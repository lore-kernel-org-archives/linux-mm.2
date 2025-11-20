Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A81C5CF8863
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23CC16B0030; Thu, 20 Nov 2025 10:03:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EDE16B0062; Thu, 20 Nov 2025 10:03:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08EBE6B007B; Thu, 20 Nov 2025 10:03:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E82D36B0030
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:02:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC73612CD73
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:02:59 +0000 (UTC)
X-FDA: 84131302878.18.30DA8C8
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id C7C5A100022
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:02:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gnymHB9f;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3oC0faQUKCMcry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3oC0faQUKCMcry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763650977; a=rsa-sha256;
	cv=none;
	b=txeCj+w5qf/mVjOD0oMcFHqDzrv3c0MxStcR7fK9KBZQjkA/C/9ye9+CcZsGitNQY+CwnA
	4+gSKpLfC1rKXwTttIxWODNV0gY/KWrY9G7CImgUBKqxmJvnL+6MufxGXOEngbvU6w4lmi
	uXwUW/Stnpyccz6Hl/yfJKVcts8qXGQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gnymHB9f;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3oC0faQUKCMcry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3oC0faQUKCMcry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763650977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAJGdoX03+Z7kHA10F2BJAYl/c1vU7j8o14tItuzLUc=;
	b=mV103K9wrxyh/C5EfTNxH/Vidg0I7ujchNmiSvgWKgsZJgI07TrhiW3KxwIGF4c32np8nh
	++qFUI2DKBehbCKItDAzn6KHIkBzQVKPKPsITTIMz+SEoYBMcNcqD/VeGiyLbmskryozCX
	9Qmj/tS1vJsIyYA+tURFZyH1zzBwROI=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47797caba11so4146875e9.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763650976; x=1764255776; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zAJGdoX03+Z7kHA10F2BJAYl/c1vU7j8o14tItuzLUc=;
        b=gnymHB9f6l6n5auFbqCYl0RsWkAGw9kjEFzWxgs6L1f8QeDjKe1fqigGOgRSURb929
         4vLaSgDkZ2xkycuOCTSdTH0VbADtf006GvyDqoMlvB9eB7IfIg173cj78a8aztPFqBqT
         N9PdRtPyE3UWhr3IirN4PsYztl4FNjOCyP6QHCcCEeMprLOHNAPhgHP+dzejTB/dIo74
         yj4AK7KlqTzyRPbbu996IyPhSMZKIL7AO8avsPPbDcPWDRemZTLdE/Alg8tHoViYmmFE
         AVNBHn7cIJOsYYGrelIUhIom3SUNR0NIyBhb1W21liNSW9ahvnUTne87JPMxOOeAKrrV
         FTGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763650976; x=1764255776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zAJGdoX03+Z7kHA10F2BJAYl/c1vU7j8o14tItuzLUc=;
        b=vQiMLt7iwQGybVXHDViyCGZ4/IlwcjzhI7frGwpQ2dKXZ1HRIFmsoaqGfaVr66UIFf
         h60qDyvFAAQO/trW3XjPPF0xvB9NWaQBzKhRfphC7YkZg2aEBZPczE9EnCxy/cg4qKWk
         jXOc8tgPzPEjwUTUTnjpHrI//YnqcGnh0IrWGnEKcFSc3p6b6TYWYvsKuxt4BWVr+TzQ
         myzmKcmr1MuTBD0gVayLcvCdMJDj4Io4mQ+QZLuH5peSzh00FUefmmDOSojo4D23ajUf
         YAL4lfu+ffGLfVS/v/FmY5LIPks6DzWrA2OpAQfimWHADrfbJeC6n3b98+TDsiL8qtiw
         fpBA==
X-Forwarded-Encrypted: i=1; AJvYcCW40hDfXo9z6ZB4xmBTJpW3QuRrEiy2Ix2K08iHf3EUVkPwkfTE+XeehY/dh/ursMPnO9SCMFtIWA==@kvack.org
X-Gm-Message-State: AOJu0Yz4/p/NWSxuJsniPtxgGBtkYm39wMM9ATjZiKCsM+ymt0nUGFwO
	5gU9fQBpromPOQ4zPBts05RyyskmPd4I+QvTDPfrjrZCdfwXW7I7F9dB71MXaSx7lwbYmOtJB9P
	Eog==
X-Google-Smtp-Source: AGHT+IFIYsn75+II8LsVddaa6qNKEfaR+cAEgpbzcwe6Py2Tl/ywj/JLpQudo1QVKMjc586QGSbi0kmLJg==
X-Received: from wmot8.prod.google.com ([2002:a05:600c:4508:b0:477:a4d4:607a])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d05:b0:477:54cd:200a
 with SMTP id 5b1f17b1804b1-477b8a518f4mr26264575e9.6.1763650976118; Thu, 20
 Nov 2025 07:02:56 -0800 (PST)
Date: Thu, 20 Nov 2025 15:49:06 +0100
In-Reply-To: <20251120145835.3833031-2-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120145835.3833031-6-elver@google.com>
Subject: [PATCH v4 04/35] Documentation: Add documentation for Compiler-Based
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
X-Rspamd-Queue-Id: C7C5A100022
X-Rspamd-Server: rspam07
X-Stat-Signature: yjfrht69u3qozw9fxntpai1ipfph49t4
X-Rspam-User: 
X-HE-Tag: 1763650977-201961
X-HE-Meta: U2FsdGVkX1/cZxYqKqtOBp9AAEdjpGC50b15DLC6C/+vuJKD7zHGYBfHv8tu9I147sXgrTFwYnLnFnwo/1wWDey7Y0KnkBqAMCERPlravO0COr1p35/xxS9JWS/25+N6skCQf+w1tD27y7q3Nm+Z5acqO+DfvTW/nBlr3c+T6ZP2lC8epS/CAG5P/enl9YYECwUbBreCGE3I4H2gRz1cceLqqS/WLQAoyb4tOgOlh/dBOXsVc3GakJO6uHe4xZ2smx8AkrWl6xS+OO+6DDI8Sh+Y4yZ4yUSCLn8dIXTd188Ciq/0uH+fn0bwBFzGmE6eRZcp6acNCd7zwmvMQ7sbPmOF8Hw0WnVNka/Zc2O3MCZnSmnnX0cFyl5bnVaRjwirrGBw6h+Z5vUSEPA/q1xszMX2kUaTyLir9OW5Qvvl7W0dA6JAgtbXp6bFcQBDv0k8xpLVKgtMlTQWeeunRfxmP/7lC0dQyfkPWNI8RF9rX+OM63dqROxrWBqkUzIqfhemaB4T066dkmW+LK3yMJomQxPcQY7/3B+x59EZkT4y75A5cw0XIOOOU/tKdLhr7XUc9BoNW8W5GRolMayOAvwtK9ibyjGX5G9mhLC1K0KH51HObmsPR3E8JWIUyoQXu8fnhW7LsoO9RjPvV+OD6gO8fm+UQXTjZjiR52Ar3tNta87AX7U9uveNyL6Gc4fYbXXSs5hneP5JXyxDpqvxlK0ApCtRXLskKeAKtvh2Tox5lmQqW9XiNkiYAh7BfQkEwUJUUMTDhajxEGJ+GpmwZDJ84jWbNsyVHyOi4ONu1a29pq0BP92d6flL9DieILSG7+rM97xxlRP4B+DvfY01GjHZvyRQrvCM6hJczM67oogUWAIQonpDhTmjF3I6SyWG1E6zkDHEbXLfEEhJXBnwDHZf8BHxRjV0ySJCEL54+2M2ZPdaObAUvfKHo6Hvnk28monz4YBCqAmFvd0jqE1hKr6
 LEzdQ+1E
 tbfuy7wtQRZ/H831kkzNeqCeK/VUYXYHlHqCSjNSqn24P76DREgcSARy3CdUcWPfTq9D1AdPyEt48W8i5kU6c7eC3912T/jc6Pqw885RHUU2c3bTFFs8xl8/uEkNF85e/7bSwqRMRw88zPLrl+/hVk2jYw84RhWjHP7wAvqaAyNJXjNhRK5N/ZbrnkKceQh1X6YmlUmaIqcsJ8PKLKIMkcbQ+inNOt4sL5uM0b4a6ldVHyxpRz5rK7qJFzUOl29nOwV3l+bHGesFUoqibWZISAXpUd9hZtdhAVJQt+SA09j3e+hwc7Mzc5BQh+AFiVNq1foI8S7BRt22nuykDlT+KWyHsGumJ7vy4KDJFRAfuwQzbLATTyYrD+jgUeZ6FhIrKpDNFmY2d7CMA16PkbatuBPmUYso9CZuPZ38rl9pGv7WwwC5etM1InIw77d6thbK0UO9cTTk3TWm3fPyhyEQBHJ1AgftHMeOF46ugD64Y9+KhJ1BIhBH3okCd5UYPd3tjcavxYvJuL+X7fQgcEpp6YwTOkK8CGxveqAfVW3KqPL75gtqBJhAim9J10aPPH1UOifwn35HLEatQdiyQgnxDilC/1kA+E7rO4E5Y/MaBLR7l+uZp38nvqLt//Et/qZkm+ESaNCUd3lACmj2QStdYX7EgMm2QEWrLNQpJiFgVjFA451Mz3QZqFtQpvWBfiZ2mPVRr/T9CknjMTkHt1+oDC2qN24ScHcFT3ysuEsdBXnpfmasl8GCXCTH9MxGiOXsEn+tlXKjhDBsinqI=
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
v4:
* Rename capability -> context analysis.

v2:
* Remove cross-reference to Sparse, since we plan to remove Sparse
  support anyway.
* Mention __no_context_analysis should be avoided.
---
 Documentation/dev-tools/context-analysis.rst | 145 +++++++++++++++++++
 Documentation/dev-tools/index.rst            |   1 +
 2 files changed, 146 insertions(+)
 create mode 100644 Documentation/dev-tools/context-analysis.rst

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
new file mode 100644
index 000000000000..a15436e288fd
--- /dev/null
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -0,0 +1,145 @@
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
+user-definable "context guards". An obvious application is lock-safety checking
+for the kernel's various synchronization primitives (each of which represents a
+"context guard"), and checking that locking rules are not violated.
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
+The below describes the programming model around using context guard types.
+
+.. note::
+   Enabling context analysis can be seen as enabling a dialect of Linux C with
+   a Context System. Some valid patterns involving complex control-flow are
+   constrained (such as conditional acquisition and later conditional release
+   in the same function).
+
+Context analysis is a way to specify permissibility of operations to depend on
+context guards being held (or not held). Typically we are interested in
+protecting data and code in a critical section by requiring a specific context
+to be active, for example by holding a specific lock. The analysis ensures that
+callers cannot perform an operation without the required context being active.
+
+Context guards are associated with named structs, along with functions that
+operate on struct instances to acquire and release the associated context
+guard.
+
+Context guards can be held either exclusively or shared. This mechanism allows
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
+   Clang's analysis explicitly does not infer context guards acquired or
+   released by inline functions. It requires explicit annotations to (a) assert
+   that it's not a bug if a context guard is released or acquired, and (b) to
+   retain consistency between inline and non-inline function declarations.
+
+Supported Kernel Primitives
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. Currently the following synchronization primitives are supported:
+
+For context guards with an initialization function (e.g., `spin_lock_init()`),
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
+   :identifiers: context_guard_struct
+                 token_context_guard token_context_guard_instance
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
+   implementation of context guard types, and should be avoided in normal code.
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
2.52.0.rc1.455.g30608eb744-goog


