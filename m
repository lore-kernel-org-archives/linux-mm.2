Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B3DCF8863
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0DA56B0006; Thu, 20 Nov 2025 10:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEB36B000D; Thu, 20 Nov 2025 10:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD8A6B0028; Thu, 20 Nov 2025 10:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1F406B0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:02:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84117B67AF
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:02:48 +0000 (UTC)
X-FDA: 84131302416.09.09D45DA
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8A071140022
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:02:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="cag4H17/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3lC0faQUKCLsfmwfshpphmf.dpnmjovy-nnlwbdl.psh@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3lC0faQUKCLsfmwfshpphmf.dpnmjovy-nnlwbdl.psh@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763650966; a=rsa-sha256;
	cv=none;
	b=BZczrtS+dYnGRHuVX0jPkHcw4SGx/o+lKNlKNN+3b7Qf1YCMECxRv9bUoUq3Z9I7e3OT5Z
	kmCtk8FlfyoNeXeo9Yw3RpSCfi+9GAi6iSjnU3fMbZpn4kHzJ3fTpLcEs5So6qyIBdFgBG
	ttf3iHbl1m2nVp8zvKSaCEidW+jWcss=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="cag4H17/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3lC0faQUKCLsfmwfshpphmf.dpnmjovy-nnlwbdl.psh@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3lC0faQUKCLsfmwfshpphmf.dpnmjovy-nnlwbdl.psh@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763650966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=299yB9vU7jRjUKLu8+l/HXcvl5VmnE8Y+0izxahilbE=;
	b=J4+ryD0tpXG7qMmTL1q+Iz9PHGvVJiNPw/zXz0FXKE9x/sgpj4nroY7bwNuaXG37vCRXkj
	z+28aD56hBunBruEAXKc8TexpDbR2PE9efHJc2nJqkG2UioXv6oAI6rNnGjFsbaTeo10BA
	S8rLP2rjHQ/FVNi7zE9fHszNVwsRtns=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779b432aecso6031375e9.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763650965; x=1764255765; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=299yB9vU7jRjUKLu8+l/HXcvl5VmnE8Y+0izxahilbE=;
        b=cag4H17/oltohs+g5uCYl3NMCIcF2ldIFvK1DZkp0fWFEitlYVJsDPEBZTNT3KmjMI
         k8K75HLLTURwO1mU1IddqOdTU2JS8L2psq828DDZdZVte9ffoQYvzCK/qNJXzb0h9yQJ
         1F87fxMmvNtvg5g/tnduS6mUyzz4qexvjzwIAP7q8IVGK6kSQ5avszb5JQPZcZCE7w8f
         P/UZ2PdsW+PC8g+MdAIY/ydM+kdWDs1KUH+CgBw6IEYkd+S548fdMG60kcex1ZjQwqtQ
         yF4H3/pB+5Ru/8Ya7a5Gv2zCgw3saslAJQGC06JihpTBXma5JkI1VpwEIfvSKBqV1Ijf
         K9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763650965; x=1764255765;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=299yB9vU7jRjUKLu8+l/HXcvl5VmnE8Y+0izxahilbE=;
        b=pWnO7jJzECS7VORgjDZKLDokeLi9DuM1I5V/ASlBFuPlPy/hByXROwPG99iA/Xu94e
         Q5Xka87oM+d3DktW9CGbhBDUPGujeLrVnsmO5J5j95v8h6m96xfk43b0eAWH7mCTrHxd
         4g1MKA0OjX3UvmiaZuIAxTQvRPKEDXiJTeSCuROKg5IifI1Fjzh+IkNUSKDlkf+qXR9v
         lY5oWq9Bmzc28PolWSe7LdepHw6tHEIKu9pxB3JtzF2PTpsS45QnPXpyOf5p5QQke3Uj
         XYgE+op4ERgUPRqk5Gc+O05kjY34cAMobDxkjPYiHpdJwjrUtNJeMj+fYmBWAH4TEALW
         qj4A==
X-Forwarded-Encrypted: i=1; AJvYcCVgqvs9hWW7AwNnR0F606BeRmWEPgcch8YzkqTTWsmoFauNTEqGN68aIEhNTLdvOqocPTrKnUzZhA==@kvack.org
X-Gm-Message-State: AOJu0YyCwE0kPTqVf6vXBhSwbv7iQyokUj7Vld/sTOxl6SEbCfdBxqLT
	dLaEgXsFFBoQ5Q6w7N2XQgCu+CqhPtLJr06riyRF4fiHZWUoQidUwljUoxmCydnbmEMQjAB1yBf
	8bQ==
X-Google-Smtp-Source: AGHT+IFyISfz3EA+x8by8TiaBc8rX6DJ8mSkbxNkvS0Q/9XVzJVRXjpX7J/DtmASShfXFKhrcCebAsbPag==
X-Received: from wmbjj13.prod.google.com ([2002:a05:600c:6a0d:b0:477:9f68:c324])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:35c7:b0:46e:49fb:4776
 with SMTP id 5b1f17b1804b1-477b8954523mr34852375e9.11.1763650964345; Thu, 20
 Nov 2025 07:02:44 -0800 (PST)
Date: Thu, 20 Nov 2025 15:49:02 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120145835.3833031-2-elver@google.com>
Subject: [PATCH v4 00/35] Compiler-Based Context- and Locking-Analysis
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A071140022
X-Stat-Signature: dyu5mokicw38dzo4wmcc4srg6qsrakdg
X-HE-Tag: 1763650966-309538
X-HE-Meta: U2FsdGVkX19I+Hql4xD89Cwf5WwZheJn2ITzaIMk9Foyifp2E0+jHjR0exXwAVYt5L6bcjhR2pBIf6NYYCaVx/lfCVdwOV4NWmetU72GhNDhd94gYcVjfoybscwIb2FlQgGv1ONI6jmO5lv3zphFc9qjNG7FbqDJKC8zkYAfPVvaM09BDdbD9rKlu2v0bub8aqmCUnCx7zT0kmoOImccYtcE+GfP6VK02luPTkmg3al0lL/uRqYhm2pr/g+HpnxZ7psq5GaaeWV9/65XaFY7bLhlvUbfdbN+hExGamP8bu1xZ2F6g0Dv1UDmlNeUu6jo2E+VwbFS5maMxrZWbNHAHIFOINn1pCV0BntN14/6rRvU1+NWMPKkX8P7EZYd1QPx29how8j7FpHCbYSjzgOZ6R9Yac9tMlHdBwXE+HSnSQc2HxIqzDS7InYkxEnzF6oB0gf5RYIoclq+9F/y1O+T2ox8UEIcHPDQ00E2hJBdlaP7vo4RiTBV6GmUQvbHdL8M7Zbv441nyVRfMPNaReM5ilCIdVVjXLfQqhgIWvAaLhJmhuHRrcUVu4CEaCpXyt7+mckFE16IJ+6PAZAtxc93p0Zb1nKuaE+Fcr5K+evlGPm8q7u7kSkIRXzeau1g+Ii96+uOmdyOsRW59vKiAZGLiM41yQJabwTv2Lm7/+X8z6gGVWKWvb9lXTJI3K6NtN2lsrcvi7Q5MsBAstMinmVJocj7yi1IvYFKiwullAaYCPE4uTo0L+dVxuuwchwHHP+jQn0vmQ05k8jNXWgcV0ZJAN6GP+8JZYiqCNPF2SDaZ1/uDGElCCYKKLSYQOsZ6pVoxmb65hYGi2nSAUhZPDJ2OirREglzCN/Q2qrUD4sKxT/gaqfcaSJtREcoYNsZnevo+7NUwEipM2xJSSrcU9N4+/Y431th+M7EJHzLuuzYiti/IDc8SZ7ZfxPWF8eYs30xIlsX7NPz2841qcOhkTF
 6f8bU6ph
 R+XVsNqnCzySVjiD4KQpwKLJNAKQF8ODQJCV9WfWdP4nub2H7rTvi4WYgeBDrl2qLoNkpV0nM+3vOx3PCW+DNeBPMbEgs2a9X5ObuYMXXakoZahFZ2nHdKCBNSfpNapTdHi+c8rEQGYuQ127bwHmopzJUuBef86ydahGzP+0M8KvwIepHvOFq4gRKrQrhaPL1KL9d6J2cckF74Y3Awm5yRo664SeMGEQYM2y3xOPsof0jRWiGo2j0YELgYicczVhfgR/v7htbSb4T2ooDr76+GPALHtmEHcQ7lFe1VbVhRBEaKJC/VGiWfrq2gYYoM0LnTvjbcwTOo/jC+MT1rPYgqONVKf+QNj7NAnIVhh8GXTXFVnyVEwaiaPrNBzw/Hj6JgDy8dQCxkFjNlBn3kKYuzBQXFjO57kTmOU6Ohdju95cM3zdKCCrypdLKGz9slP67RwLsfYTilY2Y1Mxzg/t5wmUbRySyB7DnEK5RCoNA0qZeGiS45MlK9A79YH8kSqlU3L/HPT8G9yESZrZt9s1PvWm+NWCTgmr8yf2ebFyhg2B0DaE+Vxiiue3aQx1wqZ3ch2505zadgUgWj36WMXBjLoHEoNkpLlI8RLd/A1EKZ5qvgHVMYHUlvTjQUuA6OzDAcdK3DP4gbEF4pQ5GEa+Ku+HBPUFfw6qnpSZ2bx03x/n7LKWNmqldBZn2NcE1Kflby5/lujB1pAM7OhnXaXheMk9VCC17rrtVE/StfDwNVJFrZJcFMwlT8YYLCLHrlkHqnQ7EUAzGjFHIsch16OKLZopTyXGy52ux3ezsLniN5xfGTPTOpUPjcGrHycPv9V0jeI9vOZ4yAlUYMlgNheTBqpNBGa8rh7Vfe6KQWGrhhtD0eO5ga8cdh0CcB0cqGVjiWki8z0+tXqwg01nxLru9c53A2gV/T5WrTJHAxFnZC6ZB3TGGc/T4ozcb5cHmtnR9P5hokgEtDEyOTKs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Context Analysis is a language extension, which enables statically
checking that required contexts are active (or inactive) by acquiring
and releasing user-definable "context guards". An obvious application is
lock-safety checking for the kernel's various synchronization primitives
(each of which represents a "context guard"), and checking that locking
rules are not violated.

The feature requires Clang 22 (unreleased) or later. Clang originally
called the feature "Thread Safety Analysis" [1]. This was later changed
and the feature became more flexible, gaining the ability to define
custom "capabilities". Its foundations can be found in "Capability
Systems" [2], used to specify the permissibility of operations to depend
on some "capability" being held (or not held).

Because the feature is not just able to express "capabilities" related
to synchronization primitives, and "capability" is already overloaded in
the kernel, the naming chosen for the kernel departs from Clang's
"Thread Safety" and "capability" nomenclature; we refer to the feature
as "Context Analysis" to avoid confusion. The internal implementation
still makes references to Clang's terminology in a few places, such as
`-Wthread-safety` being the warning option that also still appears in
diagnostic messages.

Additional details can be found in the added kernel-doc documentation.
An LWN article covered v2 of the series: https://lwn.net/Articles/1012990/

 [1] https://clang.llvm.org/docs/ThreadSafetyAnalysis.html
 [2] https://www.cs.cornell.edu/talc/papers/capabilities.pdf

=== Development Approach ===

Prior art exists in the form of Sparse's Context Tracking. Locking
annotations on functions already exist sparsely, so the concept of
analyzing locking rules is not foreign to the kernel's codebase.

However, Clang's analysis is more complete vs. Sparse's, with the
typical trade-offs in static analysis: improved completeness is
sacrificed for more possible false positives or additional annotations
required by the programmer. Numerous options exist to disable or opt out
certain code from analysis.

This series initially aimed to retain compatibility with Sparse, which
can provide tree-wide analysis of a subset of the context analysis
introduced, but it was later decided to drop Sparse compatibility. For
the most part, the new (and old) keywords used for annotations remain
the same, and many of the pre-existing annotations remain valid.

One big question is how to enable this feature, given we end up with a
new dialect of C; two approaches have been considered:

  A. Tree-wide all-or-nothing approach. This approach requires tree-wide
     changes, adding annotations or selective opt-outs. Making more
     primitives context-analysis aware increases churn where maintainers
     are unfamiliar with the feature and the analysis is unable to deal
     with complex code patterns as-is.

Because we can't change the programming language (even if from one C
dialect to another) of the kernel overnight, a different approach might
cause less friction.

  B. A selective, incremental, and much less intrusive approach.
     Maintainers of subsystems opt in their modules or directories into
     context analysis (via Makefile):

       CONTEXT_ANALYSIS_foo.o := y	# foo.o only
       CONTEXT_ANALYSIS := y  		# all TUs

     Most (eventually all) synchronization primitives, and more
     context guards including ones that track "irq disabled",
     "preemption" disabled, etc. could be supported.

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
enables context analysis for the following subsystems:

	* kernel/kcov
	* kernel/kcsan
	* kernel/sched/
	* lib/rhashtable
	* lib/stackdepot
	* mm/kfence
	* security/tomoyo
    	* crypto/

The initial benefits are static detection of violations of locking
rules. As more context guards are supported, we would see more static
checking beyond what regular C can provide, all while remaining easy
(and quick) to use via the Clang compiler.

  Note: The kernel already provides dynamic analysis tools Lockdep and
  KCSAN for lock-safety checking and data-race detection respectively.
  Unlike those, Clang's context analysis is a compile-time static
  analysis with no runtime impact. The static analysis complements
  existing dynamic analysis tools, as it may catch some issues before
  even getting into a running kernel, but is *not* a replacement for
  whole-kernel testing with the dynamic analysis tools enabled!

=== Appendix ===

A Clang version that supports `-Wthread-safety-pointer` and the new
alias-analysis of context-guard pointers is required (from this version
onwards):

	https://github.com/llvm/llvm-project/commit/7ccb5c08f0685d4787f12c3224a72f0650c5865e

The minimum required release version will be Clang 22.

This series is also available at this Git tree:

	https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=ctx-analysis/dev

=== Changelog ===

v4:

  - Rename capability -> context analysis, per Linus's suggestion:
    https://lore.kernel.org/all/CAHk-=wgd-Wcp0GpYaQnU7S9ci+FvFmaNw1gm75mzf0ZWdNLxvw@mail.gmail.com/

  - Minor fixes.

v3: https://lore.kernel.org/all/20250918140451.1289454-1-elver@google.com/

  - Bump min. Clang version to 22+ (unreleased), which now supports:

	* re-entrancy via __attribute__((reentrant_capability));
	* basic form of capability alias analysis - which is the
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
    compiler-context-analysis.h
  compiler-context-analysis: Add infrastructure for Context Analysis
    with Clang
  compiler-context-analysis: Add test stub
  Documentation: Add documentation for Compiler-Based Context Analysis
  checkpatch: Warn about context_unsafe() without comment
  cleanup: Basic compatibility with context analysis
  lockdep: Annotate lockdep assertions for context analysis
  locking/rwlock, spinlock: Support Clang's context analysis
  compiler-context-analysis: Change __cond_acquires to take return value
  locking/mutex: Support Clang's context analysis
  locking/seqlock: Support Clang's context analysis
  bit_spinlock: Include missing <asm/processor.h>
  bit_spinlock: Support Clang's context analysis
  rcu: Support Clang's context analysis
  srcu: Support Clang's context analysis
  kref: Add context-analysis annotations
  locking/rwsem: Support Clang's context analysis
  locking/local_lock: Include missing headers
  locking/local_lock: Support Clang's context analysis
  locking/ww_mutex: Support Clang's context analysis
  debugfs: Make debugfs_cancellation a context guard struct
  compiler-context-analysis: Remove Sparse support
  compiler-context-analysis: Remove __cond_lock() function-like helper
  compiler-context-analysis: Introduce header suppressions
  compiler: Let data_race() imply disabled context analysis
  MAINTAINERS: Add entry for Context Analysis
  kfence: Enable context analysis
  kcov: Enable context analysis
  kcsan: Enable context analysis
  stackdepot: Enable context analysis
  rhashtable: Enable context analysis
  printk: Move locking annotation to printk.c
  security/tomoyo: Enable context analysis
  crypto: Enable context analysis
  sched: Enable context analysis for core.c and fair.c

 Documentation/dev-tools/context-analysis.rst  | 146 +++++
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
 include/linux/compiler-context-analysis.h     | 429 +++++++++++++
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
 include/linux/rcupdate.h                      |  90 +--
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
 include/linux/srcu.h                          |  64 +-
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
 lib/Kconfig.debug                             |  44 ++
 lib/Makefile                                  |   6 +
 lib/dec_and_lock.c                            |   8 +-
 lib/rhashtable.c                              |   5 +-
 lib/stackdepot.c                              |  20 +-
 lib/test_context-analysis.c                   | 596 ++++++++++++++++++
 mm/kfence/Makefile                            |   2 +
 mm/kfence/core.c                              |  20 +-
 mm/kfence/kfence.h                            |  14 +-
 mm/kfence/report.c                            |   4 +-
 mm/memory.c                                   |   4 +-
 mm/pgtable-generic.c                          |  19 +-
 net/ipv4/tcp_sigpool.c                        |   2 +-
 scripts/Makefile.context-analysis             |  11 +
 scripts/Makefile.lib                          |  10 +
 scripts/checkpatch.pl                         |   7 +
 scripts/context-analysis-suppression.txt      |  33 +
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
 99 files changed, 2377 insertions(+), 592 deletions(-)
 create mode 100644 Documentation/dev-tools/context-analysis.rst
 create mode 100644 include/linux/compiler-context-analysis.h
 create mode 100644 lib/test_context-analysis.c
 create mode 100644 scripts/Makefile.context-analysis
 create mode 100644 scripts/context-analysis-suppression.txt

-- 
2.52.0.rc1.455.g30608eb744-goog


