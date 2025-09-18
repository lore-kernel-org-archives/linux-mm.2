Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0028CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4D88E011D; Thu, 18 Sep 2025 10:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ABEA8E0112; Thu, 18 Sep 2025 10:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2788E011D; Thu, 18 Sep 2025 10:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAD6E8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:05:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4C601DCDDA
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:30 +0000 (UTC)
X-FDA: 83902543620.21.D201418
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B9221C0018
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wSN9aHZU;
	spf=pass (imf21.hostedemail.com: domain of 3phHMaAUKCEcnu4n0pxxpun.lxvurw36-vvt4jlt.x0p@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3phHMaAUKCEcnu4n0pxxpun.lxvurw36-vvt4jlt.x0p@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wxDWT9Jhe5/U9R8flrhyT53CUNqFwMWNSIwpcA9ZCHg=;
	b=iz1MY6+EYgHDTZgDweRMTUua0LVOWxJsHt506OOUXozUb47FtZuHzf73ggAtuMP3y5kG6o
	jn/wFleCw4T3TBt6fxV0kVJpUBzvkAZvD8Z1cqZ8a6FqehuW9w8X84XgmbbQm7/VIJk+qu
	HLIagln51MVi7IZ7P1zfa9wOgCe2vx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204329; a=rsa-sha256;
	cv=none;
	b=AniiHiz2UfL3WihlDJ+PhbsHOIgFCulIejJNMYEj5JSZKMF7CTyDPQUlzsfb/WICdQqGUu
	4eg5Pj3UHT3c5Gs8qvtr6ZH00H6wMfTuaFe4TgsqTiRxpLT2WpjZUDB3YI+3mzynqY3v3A
	SHxM6XbIR1mBd0Hn1BBf1t6kKZPBWWg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wSN9aHZU;
	spf=pass (imf21.hostedemail.com: domain of 3phHMaAUKCEcnu4n0pxxpun.lxvurw36-vvt4jlt.x0p@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3phHMaAUKCEcnu4n0pxxpun.lxvurw36-vvt4jlt.x0p@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ee1317b132so373245f8f.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204327; x=1758809127; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wxDWT9Jhe5/U9R8flrhyT53CUNqFwMWNSIwpcA9ZCHg=;
        b=wSN9aHZUhlq6BUFjXiZZuuxonZjyYmLhx/5I6QfXea5NrKj7iCKEMeWW6YlxRZs9v8
         WFShJwzZwaPhTlw68i1qQMufxOlBSZDLQtcWKnRLslNdjT0J1Cq0D4uccz/MYGAWaJlJ
         T1VTJoVzoTljL073IoFTscn4fRYhdasYZFEFnhqDVVIfN57sH4r4Q8XWVZAqK9M7E8QJ
         aUCpvd3j5/h3VCCDQiyahGdyOCwH68MqjFSd+7a/sO2mcjr2k9l1ielqiLmIpj1VV/mk
         MALYT1w9j4FoblFPCY7/5UmD0vCfoghNow5jEVIYZTyX+BU/NkXVhnNBZk7eaFvVGRO/
         Rm5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204327; x=1758809127;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wxDWT9Jhe5/U9R8flrhyT53CUNqFwMWNSIwpcA9ZCHg=;
        b=jUbKHetxxCCKKLT5iUm9bU1XpGyYtmpnuzcHViQpDTslUPyL5kzg832HRBakmOrpN7
         4Xs+p/FvMLpUF0fvSrDgczd4D4xPF0JWbh1nspIG0mZ2Gm8kYbgqGa5x4InIQ8SGC0Fr
         XO8kLUbxIf8nVxFzEfbc20zhSYZmEv/g/0Ff53ZX55e3VJNVS42Onahbhp3VnCCVJXPo
         vflGl9L4+hQYF6ydXHLeQZxkOW5ogtCvKse+UP7EJ0rnkjsFxt7dT5ljt7y6ElI4fGaZ
         YZb2nCDD1j5qs9Uq/g54X9ej7sS1UKDfjQjwQlRdoUnu5/rVt8fzkBtykkFAQQ8cG8VX
         M38w==
X-Forwarded-Encrypted: i=1; AJvYcCXs6+lCltMlixze8AlACNiUbLDUDzUX4fJcEOLY/o+Hb6n0vqAoPLN+0LrsKQOyZzFFEtH3HyVsdg==@kvack.org
X-Gm-Message-State: AOJu0Yy6r6mEvT0RRZwcHy865TG8lQLP9rRVMOix1Rz8D1FlC04oFd4k
	mjyM7w9IV+hx9ViuNdyyxOiFAD7HIp/F/CWhzvpeUOzSMFUp5ZAFYoXehX4La2Zk5eAj+D6FZaV
	t8A==
X-Google-Smtp-Source: AGHT+IFy9SVTK9lkhhDe0k4MlUcY+fM8F7qwF5+lA1VEUPlhPe12zIpwiGbwOtlWJNddLkgwJGEEi7ziYQ==
X-Received: from wrbcc12.prod.google.com ([2002:a5d:5c0c:0:b0:3ec:e0b7:7699])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2483:b0:3cd:ef83:a9a1
 with SMTP id ffacd0b85a97d-3ecdf9c2666mr5663097f8f.20.1758204326802; Thu, 18
 Sep 2025 07:05:26 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:11 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-1-elver@google.com>
Subject: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
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
X-Stat-Signature: 37kkuyp67o4qfceq5d4e4oq16adyd4r7
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B9221C0018
X-Rspamd-Server: rspam10
X-HE-Tag: 1758204328-31004
X-HE-Meta: U2FsdGVkX1/I+/NHWWLhbrzggPqSwZ2ZmewlCb0nG/85R3P06Gwk/7HdiP9l8ROXv+M7Jf/6cyHusSoTGn29wBSm0Lmu6X6U/4CUYJLn/TdRzmCR8oKpTJNUc+jYyLxRAGQk3CaBjDoT8artu9lNp6XO68/qCxdJCPOjbM2DmM//yKUQkRrDDpMWelazZOMvbNMhVYjEbExL/Y0sCBLM1UY+DmnUQzj004VM+6ozEaw4lO0UeFNEHRLio5MVnA2Kij4Rj+WWEnu28oYk7v75kQUj6FskEWEk2CmZCjY6Zn4l6TIF3de+bLMzclwZj+Ib9EeLijwW3KlGq4TTBah8sVtRKX0DYmwyd25aPDiwEnKXz0j2rzbeGadbmbn9RhyvzXm8c6D+tT5l7j235hwrLCp1dh4uqUCnM8MEwBudVYb2zWlvHroOyeuzIfNXAN1j42S3eE/5+HNG8wMHdOGE6CU66iuvGe+lMe0h2hM2MwJFHl8YXrGbXHH8DdEFR/aUMp2F22b6WlgmVBWqQvkyUwK/YTJWGJ94hl/tgkvsuU8aXc0y0L2TMy4GquSMRxU4sPcI1oA2DxSf/2rQgJ2igzk3Bq9W8NkVle+2BV6bWIEbGFNyzgaiYnyCIPVm1Jvq6LLVtlkuBKjsU9lGexVg6Zu8M//remD64bKI+JT/qSYuwCa2te5Xa8ltS5AwvRfDSQi8JRVRkphsDrcHdF6KhaS4qdchHfW0DhBaOswiSQeIVn4gUqVJgWnvNFy4i4tjt/5rerInKvGKu/0lz1M+G5mZ2V1PEsniRKR4xYUD+Ml28wNkZnb2E/aXtQ5JQ2zZbqGiOC5MfPlKHEDZ0dfm5ZMsEFuSUl8ii3FPkfJFgZjmOfz8t+Ji3NX+fYC/Rkv7YFgJ3WaJoDELhI0te0Eu4AHEXo5jLpU7aesgFf7OGsXiuSPafqVXykdEAaeQ0vuhG5e9+W3RR/rcaE6hMPt
 pNUqD4Gd
 hj+istAXmf6mONR0/ggH8Ywm71UPcT31OO3DENi1flApSOnyl506s6BbDJRHCkcilhHGJQfYBM4OpSemiKXh2UjKOKsn098yUsBftKTvXZAVFxgSQXLUzMhos3OR+YpOOxh9LKq9flvYhLB2gIYQusU5fvE/sQL2oI7IajHOAf40wLEjBj/34Gw8CrBhcSx4HR5G4QG4rWAnxnhW33d2u5ACd66xuS6TNyGxCy2a+qsjcWQyLANK7NYRSbYgH4kuaJqZHipe/42rx4x+GqZM+87ilyR08Agi4cScwYSc6CCyD4MAExp3rWr2bni0qJS1nv58RJG2Iobt/Z01/Yt+/hNn384+70dfDPRNSyc3Km2V1DjE9zG9Zb5REO+gEmYBIrOc+wENGZb/wKpodnW5bI4lsZd3rXPEVF0p96DuLUcfiEaM7khh8wJdF79osclxCIUnXmiHd+JMEPLaqpSy0YWli3c87qy6vqIvqOWReHsvL401d5meIlHn2PN4nhUJuYYHt9K5g6ebGVhL/SsCd/MRGrIn6q7fhlzShGb3t79p3p1puqFvfLU3EQ8WDRk5H3mii7rSZa5AACOdG2OL5E6n6+nenL12hCr/4niEV+t36oJQdU2HPPdfxYuI8O+S5MrnX+p1M6c+4LwT9k4SCqckgBxbx3W62MBpx/2RP/n2SjXRbwAD3XSZ7eKRavBQyX/eksuXkvR46PR6ZIfJnElBizSUqDYUmqOR5DkD/1fFzpfdtB8UNe4kd9NRITL94oCxaetdfbIqNOfSCD/3/q5j8ULHqFOGMzRF3OozM4ecSeClUyFEbnhIobz0vvk3R4pq49o37l7EsyLdVwTIYNVL9rY5yFk6dQf6EKPQbIYBZUv70WOIwjOTFRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Capability analysis is a C language extension, which enables statically
checking that user-definable "capabilities" are acquired and released where
required. An obvious application is lock-safety checking for the kernel's
various synchronization primitives (each of which represents a "capability"),
and checking that locking rules are not violated.

Clang originally called the feature "Thread Safety Analysis" [1], with
some terminology still using the thread-safety-analysis-only names. This
was later changed and the feature became more flexible, gaining the
ability to define custom "capabilities". Its foundations can be found in
"capability systems" [2], used to specify the permissibility of
operations to depend on some capability being held (or not held).

Because the feature is not just able to express capabilities related to
synchronization primitives, the naming chosen for the kernel departs
from Clang's initial "Thread Safety" nomenclature and refers to the
feature as "Capability Analysis" to avoid confusion. The implementation
still makes references to the older terminology in some places, such as
`-Wthread-safety` being the warning enabled option that also still
appears in diagnostic messages.

Enabling capability analysis can be seen as enabling a dialect of Linux
C with a Capability System.

Additional details can be found in the added kernel-doc documentation.
An LWN article covered v2 of the series: https://lwn.net/Articles/1012990/

 [1] https://clang.llvm.org/docs/ThreadSafetyAnalysis.html
 [2] https://www.cs.cornell.edu/talc/papers/capabilities.pdf

=== Development Approach ===

Prior art exists in the form of Sparse's context tracking. Locking
annotations on functions exist, so the concept of analyzing locking rules
is not foreign to the kernel's codebase.

However, Clang's analysis is more complete vs. Sparse's, with the
typical trade-offs in static analysis: improved completeness is
sacrificed for more possible false positives or additional annotations
required by the programmer. Numerous options exist to disable or opt out
certain code from analysis.

This series initially aimed to retain compatibility with Sparse, which
can provide tree-wide analysis of a subset of the capability analysis
introduced, but it was later decided to drop Sparse compatibility. For
the most part, the new (and old) keywords used for annotations remain
the same, and many of the pre-existing annotations remain valid.

One big question is how to enable this feature, given we end up with a
new dialect of C -- 2 approaches have been considered:

  A. Tree-wide all-or-nothing approach. This approach requires tree-wide
     changes, adding annotations or selective opt-outs. Making additional
     primitives capability-enabled increases churn, esp. where maintainers
     are unaware of the feature's existence and how to use it.

Because we can't change the programming language (even if from one C
dialect to another) of the kernel overnight, a different approach might
cause less friction.

  B. A selective, incremental, and much less intrusive approach.
     Maintainers of subsystems opt in their modules or directories into
     "capability analysis" (via Makefile):
  
       CAPABILITY_ANALYSIS_foo.o := y	# foo.o only
       CAPABILITY_ANALYSIS := y  	# all TUs
  
     Most (eventually all) synchronization primitives and more
     capabilities (including ones that could track "irq disabled",
     "preemption" disabled, etc.) could be supported.

The approach taken by this series is B. This ensures that only
subsystems where maintainers are willing to deal with any warnings are
opted-in. Introducing the feature can be done incrementally, without
large tree-wide changes and adding numerous opt-outs and annotations to
the majority of code.

  Note: Bart Van Assche concurrently worked on enabling -Wthread-safety:
  https://lore.kernel.org/all/20250206175114.1974171-1-bvanassche@acm.org/
  Bart's work has shown what it might take to go with approach A
  (tree-wide, restricted to 'mutex' usage). This has shown that the
  analysis finds real issues when applied to enough subsystems!  We hope
  this serves as motivation to eventually enable the analysis in as many
  subsystems as possible, particularly subsystems that are not as easily
  tested by CI systems and test robots.

=== Initial Uses ===

With this initial series, the following synchronization primitives are
supported: `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`,
`seqlock_t`, `bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`,
`local_lock_t`, `ww_mutex`.

To demonstrate use of the feature on real kernel code, the series also
enables capability analysis for the following subsystems:

	* kernel/kcov
	* kernel/kcsan
	* kernel/sched/
	* lib/rhashtable
	* lib/stackdepot
	* mm/kfence
	* security/tomoyo
    	* crypto/

The initial benefits are static detection of violations of locking
rules. As more capabilities are added, we would see more static checking
beyond what regular C can provide, all while remaining easy (read quick)
to use via the Clang compiler.

  Note: The kernel already provides dynamic analysis tools Lockdep and
  KCSAN for lock-safety checking and data-race detection respectively.
  Unlike those, Clang's capability analysis is a compile-time static
  analysis with no runtime impact. The static analysis complements
  existing dynamic analysis tools, as it may catch some issues before
  even getting into a running kernel, but is *not* a replacement for
  whole-kernel testing with the dynamic analysis tools enabled!

=== Appendix ===

A Clang version that supports `-Wthread-safety-pointer` and the new
alias-analysis of capability pointers is required (from this version
onwards):

	https://github.com/llvm/llvm-project/commit/b4c98fcbe1504841203e610c351a3227f36c92a4 [3]

This series is also available at this Git tree:

	https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=cap-analysis/dev

=== Changelog ===

v3:

  - Bump min. Clang version to 22+ (unreleased), which now supports:

	* re-entrancy via __attribute__((reentrant_capability));
	* basic form of capability alias analysis [3] - which is the
	  biggest improvement since v2.

    This was the result of conclusions from this discussion:
    https://lore.kernel.org/all/CANpmjNPquO=W1JAh1FNQb8pMQjgeZAKCPQUAd7qUg=5pjJ6x=Q@mail.gmail.com/

  - Rename __asserts_cap/__assert_cap to __assumes_cap/__assume_cap.

  - Switch to DECLARE_LOCK_GUARD_1_ATTRS().

  - Add __acquire_ret and __acquire_shared_ret helper macros - can be
    used to define function-like macros that return objects which
    contains a held capabilities. Works now because of capability alias
    analysis.

  - Add capability_unsafe_alias() helper, where the analysis rightfully
    points out we're doing strange things with aliases but we don't
    care.

  - Support multi-argument attributes.

  - Enable for kernel/sched/{core,fair}.c, kernel/kcsan.
  - Drop drivers/tty changes (revisit later).

v2: https://lore.kernel.org/all/20250304092417.2873893-1-elver@google.com/

  - Remove Sparse context tracking support - after the introduction of
    Clang support, so that backports can skip removal of Sparse support.

  - Remove __cond_lock() function-like helper.

  - ww_mutex support.

  - -Wthread-safety-addressof was reworked and committed in upstream
    Clang as -Wthread-safety-pointer.

  - Make __cond_acquires() and __cond_acquires_shared() take abstract
    value, since compiler only cares about zero and non-zero.

  - Rename __var_guarded_by to simply __guarded_by. Initially the idea
    was to be explicit about if the variable itself or the pointed-to
    data is guarded, but in the long-term, making this shorter might be
    better.

  - Likewise rename __ref_guarded_by to __pt_guarded_by.

  - Introduce common header warning suppressions - this is a better
    solution than guarding header inclusions with disable_ +
    enable_capability_analysis(). Header suppressions are disabled when
    selecting CONFIG_WARN_CAPABILITY_ANALYSIS_ALL=y. This bumps the
    minimum Clang version required to 20+.

  - Make the data_race() macro imply disabled capability analysis.
    Writing capability_unsafe(data_race(..)) is unnecessarily verbose
    and data_race() on its own already indicates something subtly unsafe
    is happening.  This change was made after analysis of a finding in
    security/tomoyo.

  - Enable analysis in the following subsystems as additional examples
    of larger subsystem. Where it was obvious, the __guarded_by
    attribute was added to lock-guarded variables to improve coverage.

    	* drivers/tty
	* security/tomoyo
    	* crypto/

RFC v1: https://lore.kernel.org/lkml/20250206181711.1902989-1-elver@google.com

Marco Elver (35):
  compiler_types: Move lock checking attributes to
    compiler-capability-analysis.h
  compiler-capability-analysis: Add infrastructure for Clang's
    capability analysis
  compiler-capability-analysis: Add test stub
  Documentation: Add documentation for Compiler-Based Capability
    Analysis
  checkpatch: Warn about capability_unsafe() without comment
  cleanup: Basic compatibility with capability analysis
  lockdep: Annotate lockdep assertions for capability analysis
  locking/rwlock, spinlock: Support Clang's capability analysis
  compiler-capability-analysis: Change __cond_acquires to take return
    value
  locking/mutex: Support Clang's capability analysis
  locking/seqlock: Support Clang's capability analysis
  bit_spinlock: Include missing <asm/processor.h>
  bit_spinlock: Support Clang's capability analysis
  rcu: Support Clang's capability analysis
  srcu: Support Clang's capability analysis
  kref: Add capability-analysis annotations
  locking/rwsem: Support Clang's capability analysis
  locking/local_lock: Include missing headers
  locking/local_lock: Support Clang's capability analysis
  locking/ww_mutex: Support Clang's capability analysis
  debugfs: Make debugfs_cancellation a capability struct
  compiler-capability-analysis: Remove Sparse support
  compiler-capability-analysis: Remove __cond_lock() function-like
    helper
  compiler-capability-analysis: Introduce header suppressions
  compiler: Let data_race() imply disabled capability analysis
  MAINTAINERS: Add entry for Capability Analysis
  kfence: Enable capability analysis
  kcov: Enable capability analysis
  kcsan: Enable capability analysis
  stackdepot: Enable capability analysis
  rhashtable: Enable capability analysis
  printk: Move locking annotation to printk.c
  security/tomoyo: Enable capability analysis
  crypto: Enable capability analysis
  sched: Enable capability analysis for core.c and fair.c

 .../dev-tools/capability-analysis.rst         | 148 +++++
 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/sparse.rst            |  19 -
 Documentation/mm/process_addrs.rst            |   6 +-
 MAINTAINERS                                   |  11 +
 Makefile                                      |   1 +
 crypto/Makefile                               |   2 +
 crypto/acompress.c                            |   6 +-
 crypto/algapi.c                               |   2 +
 crypto/api.c                                  |   1 +
 crypto/crypto_engine.c                        |   2 +-
 crypto/drbg.c                                 |   5 +
 crypto/internal.h                             |   2 +-
 crypto/proc.c                                 |   3 +
 crypto/scompress.c                            |  24 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |   4 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   6 +-
 .../intel/iwlwifi/pcie/gen1_2/internal.h      |   5 +-
 .../intel/iwlwifi/pcie/gen1_2/trans.c         |   4 +-
 fs/dlm/lock.c                                 |   2 +-
 include/crypto/internal/acompress.h           |   7 +-
 include/crypto/internal/engine.h              |   2 +-
 include/linux/bit_spinlock.h                  |  24 +-
 include/linux/cleanup.h                       |  17 +
 include/linux/compiler-capability-analysis.h  | 423 +++++++++++++
 include/linux/compiler.h                      |   2 +
 include/linux/compiler_types.h                |  18 +-
 include/linux/console.h                       |   4 +-
 include/linux/debugfs.h                       |  12 +-
 include/linux/kref.h                          |   2 +
 include/linux/list_bl.h                       |   2 +
 include/linux/local_lock.h                    |  45 +-
 include/linux/local_lock_internal.h           |  73 ++-
 include/linux/lockdep.h                       |  12 +-
 include/linux/mm.h                            |  33 +-
 include/linux/mutex.h                         |  35 +-
 include/linux/mutex_types.h                   |   4 +-
 include/linux/rcupdate.h                      |  86 +--
 include/linux/refcount.h                      |   6 +-
 include/linux/rhashtable.h                    |  14 +-
 include/linux/rwlock.h                        |  22 +-
 include/linux/rwlock_api_smp.h                |  43 +-
 include/linux/rwlock_rt.h                     |  44 +-
 include/linux/rwlock_types.h                  |  10 +-
 include/linux/rwsem.h                         |  66 +-
 include/linux/sched.h                         |   6 +-
 include/linux/sched/signal.h                  |  16 +-
 include/linux/sched/task.h                    |   5 +-
 include/linux/sched/wake_q.h                  |   3 +
 include/linux/seqlock.h                       |  24 +
 include/linux/seqlock_types.h                 |   5 +-
 include/linux/spinlock.h                      |  89 ++-
 include/linux/spinlock_api_smp.h              |  34 +-
 include/linux/spinlock_api_up.h               | 112 +++-
 include/linux/spinlock_rt.h                   |  37 +-
 include/linux/spinlock_types.h                |  10 +-
 include/linux/spinlock_types_raw.h            |   5 +-
 include/linux/srcu.h                          |  60 +-
 include/linux/srcutiny.h                      |   4 +
 include/linux/srcutree.h                      |   6 +-
 include/linux/ww_mutex.h                      |  22 +-
 kernel/Makefile                               |   2 +
 kernel/kcov.c                                 |  36 +-
 kernel/kcsan/Makefile                         |   2 +
 kernel/kcsan/report.c                         |  11 +-
 kernel/printk/printk.c                        |   2 +
 kernel/sched/Makefile                         |   3 +
 kernel/sched/core.c                           |  89 ++-
 kernel/sched/fair.c                           |   9 +-
 kernel/sched/sched.h                          | 110 +++-
 kernel/signal.c                               |   4 +-
 kernel/time/posix-timers.c                    |  13 +-
 lib/Kconfig.debug                             |  45 ++
 lib/Makefile                                  |   6 +
 lib/dec_and_lock.c                            |   8 +-
 lib/rhashtable.c                              |   5 +-
 lib/stackdepot.c                              |  20 +-
 lib/test_capability-analysis.c                | 596 ++++++++++++++++++
 mm/kfence/Makefile                            |   2 +
 mm/kfence/core.c                              |  20 +-
 mm/kfence/kfence.h                            |  14 +-
 mm/kfence/report.c                            |   4 +-
 mm/memory.c                                   |   4 +-
 mm/pgtable-generic.c                          |  19 +-
 net/ipv4/tcp_sigpool.c                        |   2 +-
 scripts/Makefile.capability-analysis          |  11 +
 scripts/Makefile.lib                          |  10 +
 scripts/capability-analysis-suppression.txt   |  33 +
 scripts/checkpatch.pl                         |   8 +
 security/tomoyo/Makefile                      |   2 +
 security/tomoyo/common.c                      |  52 +-
 security/tomoyo/common.h                      |  77 +--
 security/tomoyo/domain.c                      |   1 +
 security/tomoyo/environ.c                     |   1 +
 security/tomoyo/file.c                        |   5 +
 security/tomoyo/gc.c                          |  28 +-
 security/tomoyo/mount.c                       |   2 +
 security/tomoyo/network.c                     |   3 +
 tools/include/linux/compiler_types.h          |   2 -
 99 files changed, 2370 insertions(+), 589 deletions(-)
 create mode 100644 Documentation/dev-tools/capability-analysis.rst
 create mode 100644 include/linux/compiler-capability-analysis.h
 create mode 100644 lib/test_capability-analysis.c
 create mode 100644 scripts/Makefile.capability-analysis
 create mode 100644 scripts/capability-analysis-suppression.txt

-- 
2.51.0.384.g4c02a37b29-goog


