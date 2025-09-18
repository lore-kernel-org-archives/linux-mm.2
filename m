Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD745CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A868E0121; Thu, 18 Sep 2025 10:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6192C8E0112; Thu, 18 Sep 2025 10:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2318E0121; Thu, 18 Sep 2025 10:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EFC18E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:05:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E79E01A01F0
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:40 +0000 (UTC)
X-FDA: 83902544040.13.9674331
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id F31EF180006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0U1CJbsj;
	spf=pass (imf06.hostedemail.com: domain of 3sRHMaAUKCFIy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3sRHMaAUKCFIy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bj3A6JwSdDEEkQDBIc6+7Le1EULqvByaO8E+vTXCoDc=;
	b=rURfOjeASoXQB7BpEnl40ShNtko4MF+5vnM44ObFIiv0YGefy6gOBUuPoipeBrQtgWVdHc
	bxUAhA6iHZJv73kk039GjfiLwq4stnAy08FOao4Yql4wwe1538cYn35Pc/FceDSGuh4iua
	WFXMcCOjZlzEAOgXsDHThJud1WGWleo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204339; a=rsa-sha256;
	cv=none;
	b=lMEWrUoCkxgsHI9/jhKezR776eTBsNvCMPtdalEiiGZZmnRjjwDHiN+OEFI2mDUq9ZNoRH
	NR6mIcw3xX3EgEUjwR4/Wl7wWSDAH7dzByrUjfJ5RmOacewXpXoJcb0CT7xtp3y+efxEWw
	9gD/+Tmu+fxrGTBpDAqy1RJeehmxK/k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0U1CJbsj;
	spf=pass (imf06.hostedemail.com: domain of 3sRHMaAUKCFIy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3sRHMaAUKCFIy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ebbbd9a430so741272f8f.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204337; x=1758809137; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bj3A6JwSdDEEkQDBIc6+7Le1EULqvByaO8E+vTXCoDc=;
        b=0U1CJbsjUB/BW3IaZz5KkC/zL+6sISAh36fssLnyPQJw/l/4qY9spyjcI88vUFJ8Mm
         o8CzcntBdGOwfat1dXurh9Ew8e+sxuA+NJQErmgZwND2JcGq0g1dqKFl/sueGnIha8rf
         k/9jiGwQ468uwL4BdEA1Kqy/F0dI5uxc17kKI5Q7uaqmXvNjkMmK0cGK9qD0uFysXK9j
         WO2uSKd7+vD7uwvAMAm6tE5gbnSKnHBuxQGVP+GnOYsSuArD45B1p6LwEOkPRTn/H9/j
         gfy0KwD6/yaHupm6me++kB4M+i9NRSL+eWiKSYucFGzZ1yFJD/LuB+JZkwb9hk+iVXA/
         pleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204337; x=1758809137;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bj3A6JwSdDEEkQDBIc6+7Le1EULqvByaO8E+vTXCoDc=;
        b=UJLrW153d8ij7EHJB0zCooVB3E+EKi1UJP8qEC//kIgHLqrum4odFujqKU8Nk/CHsc
         yYbBNby4Vo0UPZBcnQzr/uw3R0thf/mKo6zDDT7aRfXK6em3bTNAIycJfyOEOdCDiHap
         7FE37d+KsxXyGIeVDuaoawFy95xsvS+c75b30CDStBUtGSGXGHmXbPQShPicAygQpL24
         2TVZDaISHnE7ojdnG2sUbzvRj5qECa2D6LKitN390ZtVRBuMBUndSuv8CrRj+IkDo2ua
         /Jy/L3Oc62mtGSOq47vHnCDIVqi52r/QErdiXnyffTW4IvS90+D/0ajNsyWN3uIETtms
         w3kg==
X-Forwarded-Encrypted: i=1; AJvYcCWdtOQ4IMq7fNqIiEiIe3iE1KqJT9cydAJ/2FTHvx6qEQJ50r35cVeupA9aL2LHAXeKI4ZeO8Uugg==@kvack.org
X-Gm-Message-State: AOJu0YxbxenFjyQFP9+IMXdfdtZpBX0NQCvLOGVxVaYldC3bVsKpXuNK
	N7Nl3gIem/lSFLPgCE71e/hyP/dLAtORsBVKsjvS2HjIeEIH2ImnW6INjTneiH4SKrhT6+NHk0Q
	HAw==
X-Google-Smtp-Source: AGHT+IHT5Brsou9B7UeMlIcTu5UHA8gJn1pm6+1NzfMBumyM9LF1Hzj80sUwk3WvPBDRv08Z5EVR42viWQ==
X-Received: from wrum18.prod.google.com ([2002:a5d:6a12:0:b0:3ee:15bb:3d66])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:adf:b19a:0:b0:3ec:dfe5:17d0
 with SMTP id ffacd0b85a97d-3ecdfe51b3emr3102866f8f.9.1758204337306; Thu, 18
 Sep 2025 07:05:37 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:15 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-5-elver@google.com>
Subject: [PATCH v3 04/35] Documentation: Add documentation for Compiler-Based
 Capability Analysis
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F31EF180006
X-Stat-Signature: 33djzsresqmg65g9b77q7s3w6nz5mnwd
X-Rspam-User: 
X-HE-Tag: 1758204338-71302
X-HE-Meta: U2FsdGVkX1+6CmTJqr7GYF5ncXzEBNKgH42eKmGdyU22yoHe3CA8IZWgTH/ppE2zOIrELu7CLIXdAEgRktiJEivc+4SfINymCAxG1TtFwop9C43UX50Xw1z2AJXoqhlFuTevwHj0AsoyPIHE7bxWseQ96JK2PyRp3JSWerGR3rygZ0ZzA7xW5AHdK/OM9B0TH4DddDPwfU9nY0b2oK+b155erZfNaaOezyGYXHHUIKJgQmzW9x7h1I42/WO9OURpmW2MECKllK5HEqDnV/BbqfJTlQM75c0mRCGegJU7tO3TZLKsGppSfP60vmvAvmgBrL6JAQzm4BBk3v0E4gKHddkv2yu6xox2rGpGHQLIZbKkv0W2+ySrtccWlB5Q6ZC/+M5ODxAol1IljRyeMfzuONmIZAAoA7m9xJJdt8kNdljcXHGjNL7kHlgFrZroD8ildRaaIRdZPGnLZS1HYpww7E+MFYOju8VZqP0Q9qcD4WWA2TJnbyh4FNzjdnQ9VXRquWl59u9oyLSGsC0T1J2Y1HGkRlF6S5pLLjsg6DsG3UBPEfqFgvLRnfSBDb4MplzI3uKo70VRM4IPyZtfXfwBqPpMHbJgZlHnj4k0VFAQWpElYMXXDj7MRkYuqkLa1ruGY2/y34DOUaKl2IPeQhv2oGYheglR+OEGu5FhlPjtIxGlqCCaTK2Rzmu2oktxl/TJnpxK08T/uakyVTPTkniNtY4cpre/O1kHECY7mQnnJCL2XwVKr5cBO+q2LPfcbZUmMrkHSkgyLGmKcUn/17rPCQnvUlTHkFfGlwdEhRopnGZWaARroI3XyF0Ikhs/Ykp+9HCniEkWOvZSkhxktH7rPC1J29uM7TQXFFonJAwRL140HsE4bXq3ND3upzHC3kbzYHOfXBQMRb0qIqbAifWYuJqVMv+8IyNNiR0ZvNj8Re0ZwMYy8TbVYBswiTch7/HvWv4kEfhgu0/aKRZHZSE
 I3gGyTMw
 91m+RfVEEOoUQLOZykUFa2nWSYKmk3B5NwmfQRs+hg6wQAKNp0i/HP3Xi1ka3NG/3dNRowtXKbQdokLNYFctMiJF43FkjVuPwcVjZQ5k1lSymjd1bLHAVQ2V3sYoJkrstHxY4O5vVtz8CX+CAWSZxMWU3eEdiWxznjN7oh7jjOw6kMQLpEH33TalKHhup7l69YFWR2ZS8IKwrbXja0LZYvS5CIFLoGzeYh4ziXBFuVskFNaAvgidJlC0Yhl9MViAeh6oiWYK6w5FyjlaHbWbz9AAH3vGQPa0s0ponDza4g9/IL4EmtsWXyA97FBpMMjXNQQ9lmPamPHqhqRSBs3uCnsG2b2HxvTXMJ/6yYV/dndwtyAdKeu8m5QMK9isqa4htw2Gp9oBAmr36/VEv/q+x++xtN+F1GowqD2Eg7c7nBSiV587XKFrOw1tf76Y0h9RfY5u0EhQp4OG6VmsG9L902njfn4pCtAtBbbs+4iYX/T06Od4wHv1NZRBx028Am2DJyTzi5iPKgVRLjehRAjasQvLTNxweIk6CYnazDGIvMIWaJ4Vl6TkBQc7K90rYQjsQSF1KS+Qa5FCvc/CRzCtZcuGouJGS/uaNKsKmys79gJwJ715j62yWOtbPKeAcFwI+0Q/JlfyT6plQ9xjSF9sW6LIrjTBuKYFTTNjne3szRd0F2u5cvz8l41HM6Nt6EZCcOe8GO9uak6IXwntQbMQ01pYe4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adds documentation in Documentation/dev-tools/capability-analysis.rst,
and adds it to the index and cross-references from Sparse's document.

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* Remove cross-reference to Sparse, since we plan to remove Sparse
  support anyway.
* Mention __no_capability_analysis should be avoided.
---
 .../dev-tools/capability-analysis.rst         | 147 ++++++++++++++++++
 Documentation/dev-tools/index.rst             |   1 +
 2 files changed, 148 insertions(+)
 create mode 100644 Documentation/dev-tools/capability-analysis.rst

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
new file mode 100644
index 000000000000..1287f792f6cd
--- /dev/null
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -0,0 +1,147 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. Copyright (C) 2025, Google LLC.
+
+.. _capability-analysis:
+
+Compiler-Based Capability Analysis
+==================================
+
+Capability analysis is a C language extension, which enables statically
+checking that user-definable "capabilities" are acquired and released where
+required. An obvious application is lock-safety checking for the kernel's
+various synchronization primitives (each of which represents a "capability"),
+and checking that locking rules are not violated.
+
+The Clang compiler currently supports the full set of capability analysis
+features. To enable for Clang, configure the kernel with::
+
+    CONFIG_WARN_CAPABILITY_ANALYSIS=y
+
+The feature requires Clang 22 or later.
+
+The analysis is *opt-in by default*, and requires declaring which modules and
+subsystems should be analyzed in the respective `Makefile`::
+
+    CAPABILITY_ANALYSIS_mymodule.o := y
+
+Or for all translation units in the directory::
+
+    CAPABILITY_ANALYSIS := y
+
+It is possible to enable the analysis tree-wide, however, which will result in
+numerous false positive warnings currently and is *not* generally recommended::
+
+    CONFIG_WARN_CAPABILITY_ANALYSIS_ALL=y
+
+Programming Model
+-----------------
+
+The below describes the programming model around using capability-enabled
+types.
+
+.. note::
+   Enabling capability analysis can be seen as enabling a dialect of Linux C with
+   a Capability System. Some valid patterns involving complex control-flow are
+   constrained (such as conditional acquisition and later conditional release
+   in the same function, or returning pointers to capabilities from functions.
+
+Capability analysis is a way to specify permissibility of operations to depend
+on capabilities being held (or not held). Typically we are interested in
+protecting data and code by requiring some capability to be held, for example a
+specific lock. The analysis ensures that the caller cannot perform the
+operation without holding the appropriate capability.
+
+Capabilities are associated with named structs, along with functions that
+operate on capability-enabled struct instances to acquire and release the
+associated capability.
+
+Capabilities can be held either exclusively or shared. This mechanism allows
+assign more precise privileges when holding a capability, typically to
+distinguish where a thread may only read (shared) or also write (exclusive) to
+guarded data.
+
+The set of capabilities that are actually held by a given thread at a given
+point in program execution is a run-time concept. The static analysis works by
+calculating an approximation of that set, called the capability environment.
+The capability environment is calculated for every program point, and describes
+the set of capabilities that are statically known to be held, or not held, at
+that particular point. This environment is a conservative approximation of the
+full set of capabilities that will actually held by a thread at run-time.
+
+More details are also documented `here
+<https://clang.llvm.org/docs/ThreadSafetyAnalysis.html>`_.
+
+.. note::
+   Clang's analysis explicitly does not infer capabilities acquired or released
+   by inline functions. It requires explicit annotations to (a) assert that
+   it's not a bug if a capability is released or acquired, and (b) to retain
+   consistency between inline and non-inline function declarations.
+
+Supported Kernel Primitives
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. Currently the following synchronization primitives are supported:
+
+For capabilities with an initialization function (e.g., `spin_lock_init()`),
+calling this function on the capability instance before initializing any
+guarded members or globals prevents the compiler from issuing warnings about
+unguarded initialization.
+
+Lockdep assertions, such as `lockdep_assert_held()`, inform the compiler's
+capability analysis that the associated synchronization primitive is held after
+the assertion. This avoids false positives in complex control-flow scenarios
+and encourages the use of Lockdep where static analysis is limited. For
+example, this is useful when a function doesn't *always* require a lock, making
+`__must_hold()` inappropriate.
+
+Keywords
+~~~~~~~~
+
+.. kernel-doc:: include/linux/compiler-capability-analysis.h
+   :identifiers: struct_with_capability
+                 token_capability token_capability_instance
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
+                 capability_unsafe
+                 __capability_unsafe
+                 disable_capability_analysis enable_capability_analysis
+
+.. note::
+   The function attribute `__no_capability_analysis` is reserved for internal
+   implementation of capability-enabled primitives, and should be avoided in
+   normal code.
+
+Background
+----------
+
+Clang originally called the feature `Thread Safety Analysis
+<https://clang.llvm.org/docs/ThreadSafetyAnalysis.html>`_, with some
+terminology still using the thread-safety-analysis-only names. This was later
+changed and the feature became more flexible, gaining the ability to define
+custom "capabilities".
+
+Indeed, its foundations can be found in `capability systems
+<https://www.cs.cornell.edu/talc/papers/capabilities.pdf>`_, used to specify
+the permissibility of operations to depend on some capability being held (or
+not held).
+
+Because the feature is not just able to express capabilities related to
+synchronization primitives, the naming chosen for the kernel departs from
+Clang's initial "Thread Safety" nomenclature and refers to the feature as
+"Capability Analysis" to avoid confusion. The implementation still makes
+references to the older terminology in some places, such as `-Wthread-safety`
+being the warning option that also still appears in diagnostic messages.
diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 65c54b27a60b..62ac23f797cd 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -18,6 +18,7 @@ Documentation/process/debugging/index.rst
    :maxdepth: 2
 
    testing-overview
+   capability-analysis
    checkpatch
    clang-format
    coccinelle
-- 
2.51.0.384.g4c02a37b29-goog


