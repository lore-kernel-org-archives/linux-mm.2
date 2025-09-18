Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55019CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 16:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3338E0149; Thu, 18 Sep 2025 12:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993908E00F6; Thu, 18 Sep 2025 12:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B458E0149; Thu, 18 Sep 2025 12:22:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1918E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:22:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C904C0236
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:22:09 +0000 (UTC)
X-FDA: 83902887978.21.A7CCCFD
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 280CA100009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:22:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pmfhLkj3;
	spf=pass (imf05.hostedemail.com: domain of irogers@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=irogers@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758212527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5MVxy+isNSGzxZ1RNWDgxpSBJ+uufmPyWYytHyGJgFE=;
	b=bZyuxxMoyIC6Em0tMlCiXkwuzZGyBZWDxv1yWTX/uPD8CmwfH2O7IFYtEvqgVVXLUIfWbm
	ps5qWDvuulr9n4RmLyEH8x5AdVeSxUrnHvfe1MjF3lvOcixI0+dcJe1aD2JxwevwdOY8qL
	dFcfta924eXVW3XE39lDXOmIeqPkmmg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pmfhLkj3;
	spf=pass (imf05.hostedemail.com: domain of irogers@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=irogers@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758212527; a=rsa-sha256;
	cv=none;
	b=QZi/18HNP2D45p7asXqyJSJUe1Q8xfZNP6zNC4vQzgK2IIsmKvLiRjWShEhiyeTHA1lLrI
	ROZXbI6eUBcXuTjvR+VKyJ6OQ5htkCZVYppC2xTIHsc0jPSAWo8QY0FNMcS4Lyy5msGEo4
	LRnV3veFfdnseS+5P+DSQIK+C/eglR4=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-267c90c426dso256275ad.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758212526; x=1758817326; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MVxy+isNSGzxZ1RNWDgxpSBJ+uufmPyWYytHyGJgFE=;
        b=pmfhLkj3uUwfpxUY68FHq6TjIn2giJyP7NB7MOmRnctPRysLctFzEvl5vnYOW2/t5A
         DG5bdBHTiXuxC1Mhy2d8bpJiBtVKrkUCOJDEcQdK8vYLPreXGCYo92tzlDYw+v8pvk6Z
         YjdY9V7w5Tqhxt0lSQRxwd27ncdKaSei7RXiVdl3UxuXQQ6nfxjIgqveXIjNYFCOSLAB
         DiZncUoKKssNKHY5b2PZEb3Vyy+H24EmCaBRAD09wXgcR+hSxlIIudOM8FMtpMhiAsQN
         IVhvKjYrvJzgnZtwgvM7I6C4rJzAPwVsZm/zOxr10eqRC8D/Y5MIsycrhIczF8nlWTqx
         XXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758212526; x=1758817326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5MVxy+isNSGzxZ1RNWDgxpSBJ+uufmPyWYytHyGJgFE=;
        b=YPFcMV9X38ZwcebldgNtyfDSaIR1NC2u8cbwxis04zQUdhqhHayE+k5EFaAgetStPo
         bYsRwe6LOiuYfBe0htVJWPDblIfpbKWu4cdO+xlgn0t0um2PYMg1AKjjhQitk4jGhhwk
         UfqcnjUn8ysvnYR0hKr+O9AwnMzgey2r8/YbiT8maxB/4Kf7kGtLa0qTMoYaBBEuO+VG
         kOy+B4i5BeYNR39ThVAfud7YQDy5ESQ/cs/7yTMx95ZDd4/0FKSZQqiQfoMVsAVbfFA/
         0weWi3je9SnlgJIc/unDpWzNipuoaQjgBCzXza8anu1hW5KkulbyUBIY/roF1y8annmP
         Q1EA==
X-Forwarded-Encrypted: i=1; AJvYcCVMx+xxbWzHG+4ARlqXH9H4iO0r75xXUcKCZXvBAhljbTyhDsNtyujaWqoyWHXkYwF+7gq/+iy0WA==@kvack.org
X-Gm-Message-State: AOJu0YwMLTpL8I8obpBPesKkuvqwHKEmBeKjxmxcCAus2r4J1+EhcfY9
	cxTKmVaS8JFnbwZfyJeqzOzLEGesxBt/vx6WVkdaEZ/TnPIh+gsj5hXjLSdDhPh+NnXPu1bv7MJ
	+OEKS6dV9s139VkgMFDYJ97iKWAIe2KccKznX6IkB
X-Gm-Gg: ASbGncsJ7o9pajr6/32Yiw4dydrUomMBYrs1wNZkd7Q/OyPBv7LO5rWKrU7zawL+wbX
	e3Kig07W/MxCC2jVmYsn2/amb2ngb7rpaznj5yYd2m1mAybfvuh06+QdyAQ7P7Uxd2WyHteHm8e
	fGcXfxPoj38AsUmIVQTP0j/Vh0HKPKmB555QtGGuUXxD0Kx4Mo53lK9nN3yHKYxhTVOmoCs7sm5
	YVtLWRNJlZ5TtM4H73PGIeD7xawvFABdtYGPl00TR9AhhBaG25ncfeUjt8fa2w=
X-Google-Smtp-Source: AGHT+IHxGXO+MQMP4X/HxoMphmnj6jFmVCb1ai8uCipAkHFyHD7uKu4n7L234w2XjgKLmDc8UqgxzQ06juIY0O+RCyk=
X-Received: by 2002:a17:902:d2d1:b0:265:e66:6c10 with SMTP id
 d9443c01a7336-26800eb14c1mr10816965ad.4.1758212525092; Thu, 18 Sep 2025
 09:22:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
From: Ian Rogers <irogers@google.com>
Date: Thu, 18 Sep 2025 09:21:53 -0700
X-Gm-Features: AS18NWCdr0R3pX49u8RURP-UvB2JdrfJJnKQCP7CUfy991L56-Il3vjCOTsSBN4
Message-ID: <CAP-5=fXBe0_aAep4PPwvfyHPJevMeLffHwA80jec2WVb2ugeYg@mail.gmail.com>
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jann Horn <jannh@google.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 280CA100009
X-Rspamd-Server: rspam05
X-Stat-Signature: ez5t6pd3tfg119atgs8tu5xmtpbqii6r
X-Rspam-User: 
X-HE-Tag: 1758212526-821506
X-HE-Meta: U2FsdGVkX19Op9Esx8WvJOvkAZ/GarVLlf+9H6QzM26xzv2vgoaB3v3wEFZaqKypjyWHHG86r5H+bRnYHFKnAoAnRA0ADkNaC3yBeN0UCLyQh2DXZ/9/Y+R/KdIbBOu/FTO5yVe0R5mqhrAWHhasXfRNwjAYcZJsrI6ooCRI1dmogzpHgBx1eOCldWtsJJ/rkvp9dGUnyxtofZKgukeJlUMmREX6xDdTNc3+MMP6+j0ES9WmSPtHIv+q5pMGmC6jjTmPf6RyJlTuK9A9BCM6RL8gttfMyIERAE8il/hbTuKs4qDc/0iM4aNHJ4b79qX/l5irX6rdXOx1x7k2WMqVNz1xW7nkqrSZwFGg7qeKKof04NPHqA5Ad6XwyEiDS7fNGZ2CuqfVTcDUk3EmDolGdawCyzsaJaqt0CU4QDg0wTrQAXGMNAWylimlVDc/BSwvEZsY+6TA49RyHqRsSvfSJFRvat0UbF+nb1l1Mn4uhu+hFV5A0tLYoq8/m9ebUGAZhbAyAoo1qH2nSFZRY5q6Wu9a+4llVqxtVE0/MkPKGBXaF/rxPRHUvAYsRJGPRn4ETxHy5p7rirCa8jWXkIwPwFknSMIV2afUHB5Dh1SZrlHr+yxbSR4B2qjGuuzlYRfLcgOqqn6XYulPg1SmvA+2ueu1/pdEI4eopcXN72KHGnlkBe1D+CnEp8T/DnKwSyNKWWhBk+fNZQmhvuu0ow+CFx4JfBHi6dWPoy7d78SVEHGP717Mmskzl0YOdIusLaN1Aibm1L2Wek+DBqGUVt09K4H20T6dJKEUmzb2VZed9gLGRsTDmsyJY5RowtRL1HvNq1MIpYWjhmALgGH4tyvleri643JetUivOW6Pl49SXgowOEdIAQaqvOfXkjEJ1+9mmadEbYMkmL86lnUsMzKCzsVKHYpbiV8+ouWvy4RxC2WRf5UPYc9Ll/M0aBZEiCAfsmphJmXA6/rAFSF77Pv
 e92z83kn
 lcS4P/qnHGbrGzDnmxD3JnvgM0LDUYpMQ2zBVN7F2Jf307x5t8ZCDny0fQUviodZST3rzRoKci7b9hudQgMq8g87+lYmcJCBUJJuhsmXHdExz1c5awZlN5nq1GEQZ//aPURGrVkDPx6LCxJBxIkm17gGVw6h76a+inN+3Zhteu0kCH6NfxSuBZ84MDVGRiRdUCXJ6kYS/MiuInT1OvWEss/Ydah0j5eDkiA9e67NgKYZaoahFoZNauFEuB6i0Qz81LvGrZIPqhh0ISmKVViY8fIBXdlhoh0v3DRBC0b08tgjg0s1fuIlo8RJ+eQdT/bhUlC/aXoFFtUmEvSZuEAs3G5GjKNZ/aQhKHEUvRzu1QnwFMnXVqmOBJavGmIDKz9bNeA/PMna1EoH6pz2yun7VfrhsNK1+gyE93NyP9v5LcW4MAtH0Qr04kHHtvUGbrqd562L4MUGV9XHNxpRZaxpKE+IAg1dyccY4oMOz0LdH8tk7PEPjLxKMqIP5d+lvbpmqkoSswu2DXefvWUjPI7s+uQST/Zq3NjvI0X/fhpgZOuqhT6FZEkMiTQhRXrACnoPiWFDRw/zCu+CBVsNNRepfu7VhOrezmQUyslTbuAdVS11W/F8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 7:05=E2=80=AFAM Marco Elver <elver@google.com> wrot=
e:
>
> Capability analysis is a C language extension, which enables statically
> checking that user-definable "capabilities" are acquired and released whe=
re
> required. An obvious application is lock-safety checking for the kernel's
> various synchronization primitives (each of which represents a "capabilit=
y"),
> and checking that locking rules are not violated.
>
> Clang originally called the feature "Thread Safety Analysis" [1], with
> some terminology still using the thread-safety-analysis-only names. This
> was later changed and the feature became more flexible, gaining the
> ability to define custom "capabilities". Its foundations can be found in
> "capability systems" [2], used to specify the permissibility of
> operations to depend on some capability being held (or not held).
>
> Because the feature is not just able to express capabilities related to
> synchronization primitives, the naming chosen for the kernel departs
> from Clang's initial "Thread Safety" nomenclature and refers to the
> feature as "Capability Analysis" to avoid confusion. The implementation
> still makes references to the older terminology in some places, such as
> `-Wthread-safety` being the warning enabled option that also still
> appears in diagnostic messages.
>
> Enabling capability analysis can be seen as enabling a dialect of Linux
> C with a Capability System.
>
> Additional details can be found in the added kernel-doc documentation.
> An LWN article covered v2 of the series: https://lwn.net/Articles/1012990=
/
>
>  [1] https://clang.llvm.org/docs/ThreadSafetyAnalysis.html
>  [2] https://www.cs.cornell.edu/talc/papers/capabilities.pdf
>
> =3D=3D=3D Development Approach =3D=3D=3D
>
> Prior art exists in the form of Sparse's context tracking. Locking
> annotations on functions exist, so the concept of analyzing locking rules
> is not foreign to the kernel's codebase.
>
> However, Clang's analysis is more complete vs. Sparse's, with the
> typical trade-offs in static analysis: improved completeness is
> sacrificed for more possible false positives or additional annotations
> required by the programmer. Numerous options exist to disable or opt out
> certain code from analysis.
>
> This series initially aimed to retain compatibility with Sparse, which
> can provide tree-wide analysis of a subset of the capability analysis
> introduced, but it was later decided to drop Sparse compatibility. For
> the most part, the new (and old) keywords used for annotations remain
> the same, and many of the pre-existing annotations remain valid.
>
> One big question is how to enable this feature, given we end up with a
> new dialect of C -- 2 approaches have been considered:
>
>   A. Tree-wide all-or-nothing approach. This approach requires tree-wide
>      changes, adding annotations or selective opt-outs. Making additional
>      primitives capability-enabled increases churn, esp. where maintainer=
s
>      are unaware of the feature's existence and how to use it.
>
> Because we can't change the programming language (even if from one C
> dialect to another) of the kernel overnight, a different approach might
> cause less friction.
>
>   B. A selective, incremental, and much less intrusive approach.
>      Maintainers of subsystems opt in their modules or directories into
>      "capability analysis" (via Makefile):
>
>        CAPABILITY_ANALYSIS_foo.o :=3D y   # foo.o only
>        CAPABILITY_ANALYSIS :=3D y         # all TUs
>
>      Most (eventually all) synchronization primitives and more
>      capabilities (including ones that could track "irq disabled",
>      "preemption" disabled, etc.) could be supported.
>
> The approach taken by this series is B. This ensures that only
> subsystems where maintainers are willing to deal with any warnings are
> opted-in. Introducing the feature can be done incrementally, without
> large tree-wide changes and adding numerous opt-outs and annotations to
> the majority of code.
>
>   Note: Bart Van Assche concurrently worked on enabling -Wthread-safety:
>   https://lore.kernel.org/all/20250206175114.1974171-1-bvanassche@acm.org=
/
>   Bart's work has shown what it might take to go with approach A
>   (tree-wide, restricted to 'mutex' usage). This has shown that the
>   analysis finds real issues when applied to enough subsystems!  We hope
>   this serves as motivation to eventually enable the analysis in as many
>   subsystems as possible, particularly subsystems that are not as easily
>   tested by CI systems and test robots.
>
> =3D=3D=3D Initial Uses =3D=3D=3D
>
> With this initial series, the following synchronization primitives are
> supported: `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`,
> `seqlock_t`, `bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`,
> `local_lock_t`, `ww_mutex`.
>
> To demonstrate use of the feature on real kernel code, the series also
> enables capability analysis for the following subsystems:
>
>         * kernel/kcov
>         * kernel/kcsan
>         * kernel/sched/
>         * lib/rhashtable
>         * lib/stackdepot
>         * mm/kfence
>         * security/tomoyo
>         * crypto/
>
> The initial benefits are static detection of violations of locking
> rules. As more capabilities are added, we would see more static checking
> beyond what regular C can provide, all while remaining easy (read quick)
> to use via the Clang compiler.
>
>   Note: The kernel already provides dynamic analysis tools Lockdep and
>   KCSAN for lock-safety checking and data-race detection respectively.
>   Unlike those, Clang's capability analysis is a compile-time static
>   analysis with no runtime impact. The static analysis complements
>   existing dynamic analysis tools, as it may catch some issues before
>   even getting into a running kernel, but is *not* a replacement for
>   whole-kernel testing with the dynamic analysis tools enabled!
>
> =3D=3D=3D Appendix =3D=3D=3D
>
> A Clang version that supports `-Wthread-safety-pointer` and the new
> alias-analysis of capability pointers is required (from this version
> onwards):
>
>         https://github.com/llvm/llvm-project/commit/b4c98fcbe1504841203e6=
10c351a3227f36c92a4 [3]
>
> This series is also available at this Git tree:
>
>         https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/=
log/?h=3Dcap-analysis/dev
>
> =3D=3D=3D Changelog =3D=3D=3D
>
> v3:
>
>   - Bump min. Clang version to 22+ (unreleased), which now supports:
>
>         * re-entrancy via __attribute__((reentrant_capability));
>         * basic form of capability alias analysis [3] - which is the
>           biggest improvement since v2.
>
>     This was the result of conclusions from this discussion:
>     https://lore.kernel.org/all/CANpmjNPquO=3DW1JAh1FNQb8pMQjgeZAKCPQUAd7=
qUg=3D5pjJ6x=3DQ@mail.gmail.com/
>
>   - Rename __asserts_cap/__assert_cap to __assumes_cap/__assume_cap.
>
>   - Switch to DECLARE_LOCK_GUARD_1_ATTRS().
>
>   - Add __acquire_ret and __acquire_shared_ret helper macros - can be
>     used to define function-like macros that return objects which
>     contains a held capabilities. Works now because of capability alias
>     analysis.
>
>   - Add capability_unsafe_alias() helper, where the analysis rightfully
>     points out we're doing strange things with aliases but we don't
>     care.
>
>   - Support multi-argument attributes.
>
>   - Enable for kernel/sched/{core,fair}.c, kernel/kcsan.
>   - Drop drivers/tty changes (revisit later).
>
> v2: https://lore.kernel.org/all/20250304092417.2873893-1-elver@google.com=
/
>
>   - Remove Sparse context tracking support - after the introduction of
>     Clang support, so that backports can skip removal of Sparse support.
>
>   - Remove __cond_lock() function-like helper.
>
>   - ww_mutex support.
>
>   - -Wthread-safety-addressof was reworked and committed in upstream
>     Clang as -Wthread-safety-pointer.
>
>   - Make __cond_acquires() and __cond_acquires_shared() take abstract
>     value, since compiler only cares about zero and non-zero.
>
>   - Rename __var_guarded_by to simply __guarded_by. Initially the idea
>     was to be explicit about if the variable itself or the pointed-to
>     data is guarded, but in the long-term, making this shorter might be
>     better.
>
>   - Likewise rename __ref_guarded_by to __pt_guarded_by.
>
>   - Introduce common header warning suppressions - this is a better
>     solution than guarding header inclusions with disable_ +
>     enable_capability_analysis(). Header suppressions are disabled when
>     selecting CONFIG_WARN_CAPABILITY_ANALYSIS_ALL=3Dy. This bumps the
>     minimum Clang version required to 20+.
>
>   - Make the data_race() macro imply disabled capability analysis.
>     Writing capability_unsafe(data_race(..)) is unnecessarily verbose
>     and data_race() on its own already indicates something subtly unsafe
>     is happening.  This change was made after analysis of a finding in
>     security/tomoyo.
>
>   - Enable analysis in the following subsystems as additional examples
>     of larger subsystem. Where it was obvious, the __guarded_by
>     attribute was added to lock-guarded variables to improve coverage.
>
>         * drivers/tty
>         * security/tomoyo
>         * crypto/
>
> RFC v1: https://lore.kernel.org/lkml/20250206181711.1902989-1-elver@googl=
e.com

Thanks for this and lgtm. Fwiw, there is already thread safety
analysis in tools/perf:
https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/tr=
ee/tools/perf/util/mutex.h?h=3Dperf-tools-next#n43
and we should migrate that code to use this code.

Something that I've wondered about capabilities is to use them for
detecting missing reference count "puts", which feel similar to missed
unlocks. In my experience the sanitizers are weak in this area as in
C++ you can trivially use RAII, however, frustratingly clang's
capability analysis is disabled in C++'s constructors and destructors
(not an issue here :-) and based on my rusty memory). To solve this
for perf (and fix many many bugs) we did a form of runtime RAII:
https://perfwiki.github.io/main/reference-count-checking/
There is likely something better than can be done with the nearly RAII
that is/are cleanups. Trying to make that sane for a data-structure
like an rbtree is hard and maybe rust is just the only solution there.
Anyway, it is great to see thread safety analysis pushed forward.

Thanks,
Ian

> Marco Elver (35):
>   compiler_types: Move lock checking attributes to
>     compiler-capability-analysis.h
>   compiler-capability-analysis: Add infrastructure for Clang's
>     capability analysis
>   compiler-capability-analysis: Add test stub
>   Documentation: Add documentation for Compiler-Based Capability
>     Analysis
>   checkpatch: Warn about capability_unsafe() without comment
>   cleanup: Basic compatibility with capability analysis
>   lockdep: Annotate lockdep assertions for capability analysis
>   locking/rwlock, spinlock: Support Clang's capability analysis
>   compiler-capability-analysis: Change __cond_acquires to take return
>     value
>   locking/mutex: Support Clang's capability analysis
>   locking/seqlock: Support Clang's capability analysis
>   bit_spinlock: Include missing <asm/processor.h>
>   bit_spinlock: Support Clang's capability analysis
>   rcu: Support Clang's capability analysis
>   srcu: Support Clang's capability analysis
>   kref: Add capability-analysis annotations
>   locking/rwsem: Support Clang's capability analysis
>   locking/local_lock: Include missing headers
>   locking/local_lock: Support Clang's capability analysis
>   locking/ww_mutex: Support Clang's capability analysis
>   debugfs: Make debugfs_cancellation a capability struct
>   compiler-capability-analysis: Remove Sparse support
>   compiler-capability-analysis: Remove __cond_lock() function-like
>     helper
>   compiler-capability-analysis: Introduce header suppressions
>   compiler: Let data_race() imply disabled capability analysis
>   MAINTAINERS: Add entry for Capability Analysis
>   kfence: Enable capability analysis
>   kcov: Enable capability analysis
>   kcsan: Enable capability analysis
>   stackdepot: Enable capability analysis
>   rhashtable: Enable capability analysis
>   printk: Move locking annotation to printk.c
>   security/tomoyo: Enable capability analysis
>   crypto: Enable capability analysis
>   sched: Enable capability analysis for core.c and fair.c
>
>  .../dev-tools/capability-analysis.rst         | 148 +++++
>  Documentation/dev-tools/index.rst             |   1 +
>  Documentation/dev-tools/sparse.rst            |  19 -
>  Documentation/mm/process_addrs.rst            |   6 +-
>  MAINTAINERS                                   |  11 +
>  Makefile                                      |   1 +
>  crypto/Makefile                               |   2 +
>  crypto/acompress.c                            |   6 +-
>  crypto/algapi.c                               |   2 +
>  crypto/api.c                                  |   1 +
>  crypto/crypto_engine.c                        |   2 +-
>  crypto/drbg.c                                 |   5 +
>  crypto/internal.h                             |   2 +-
>  crypto/proc.c                                 |   3 +
>  crypto/scompress.c                            |  24 +-
>  .../net/wireless/intel/iwlwifi/iwl-trans.c    |   4 +-
>  .../net/wireless/intel/iwlwifi/iwl-trans.h    |   6 +-
>  .../intel/iwlwifi/pcie/gen1_2/internal.h      |   5 +-
>  .../intel/iwlwifi/pcie/gen1_2/trans.c         |   4 +-
>  fs/dlm/lock.c                                 |   2 +-
>  include/crypto/internal/acompress.h           |   7 +-
>  include/crypto/internal/engine.h              |   2 +-
>  include/linux/bit_spinlock.h                  |  24 +-
>  include/linux/cleanup.h                       |  17 +
>  include/linux/compiler-capability-analysis.h  | 423 +++++++++++++
>  include/linux/compiler.h                      |   2 +
>  include/linux/compiler_types.h                |  18 +-
>  include/linux/console.h                       |   4 +-
>  include/linux/debugfs.h                       |  12 +-
>  include/linux/kref.h                          |   2 +
>  include/linux/list_bl.h                       |   2 +
>  include/linux/local_lock.h                    |  45 +-
>  include/linux/local_lock_internal.h           |  73 ++-
>  include/linux/lockdep.h                       |  12 +-
>  include/linux/mm.h                            |  33 +-
>  include/linux/mutex.h                         |  35 +-
>  include/linux/mutex_types.h                   |   4 +-
>  include/linux/rcupdate.h                      |  86 +--
>  include/linux/refcount.h                      |   6 +-
>  include/linux/rhashtable.h                    |  14 +-
>  include/linux/rwlock.h                        |  22 +-
>  include/linux/rwlock_api_smp.h                |  43 +-
>  include/linux/rwlock_rt.h                     |  44 +-
>  include/linux/rwlock_types.h                  |  10 +-
>  include/linux/rwsem.h                         |  66 +-
>  include/linux/sched.h                         |   6 +-
>  include/linux/sched/signal.h                  |  16 +-
>  include/linux/sched/task.h                    |   5 +-
>  include/linux/sched/wake_q.h                  |   3 +
>  include/linux/seqlock.h                       |  24 +
>  include/linux/seqlock_types.h                 |   5 +-
>  include/linux/spinlock.h                      |  89 ++-
>  include/linux/spinlock_api_smp.h              |  34 +-
>  include/linux/spinlock_api_up.h               | 112 +++-
>  include/linux/spinlock_rt.h                   |  37 +-
>  include/linux/spinlock_types.h                |  10 +-
>  include/linux/spinlock_types_raw.h            |   5 +-
>  include/linux/srcu.h                          |  60 +-
>  include/linux/srcutiny.h                      |   4 +
>  include/linux/srcutree.h                      |   6 +-
>  include/linux/ww_mutex.h                      |  22 +-
>  kernel/Makefile                               |   2 +
>  kernel/kcov.c                                 |  36 +-
>  kernel/kcsan/Makefile                         |   2 +
>  kernel/kcsan/report.c                         |  11 +-
>  kernel/printk/printk.c                        |   2 +
>  kernel/sched/Makefile                         |   3 +
>  kernel/sched/core.c                           |  89 ++-
>  kernel/sched/fair.c                           |   9 +-
>  kernel/sched/sched.h                          | 110 +++-
>  kernel/signal.c                               |   4 +-
>  kernel/time/posix-timers.c                    |  13 +-
>  lib/Kconfig.debug                             |  45 ++
>  lib/Makefile                                  |   6 +
>  lib/dec_and_lock.c                            |   8 +-
>  lib/rhashtable.c                              |   5 +-
>  lib/stackdepot.c                              |  20 +-
>  lib/test_capability-analysis.c                | 596 ++++++++++++++++++
>  mm/kfence/Makefile                            |   2 +
>  mm/kfence/core.c                              |  20 +-
>  mm/kfence/kfence.h                            |  14 +-
>  mm/kfence/report.c                            |   4 +-
>  mm/memory.c                                   |   4 +-
>  mm/pgtable-generic.c                          |  19 +-
>  net/ipv4/tcp_sigpool.c                        |   2 +-
>  scripts/Makefile.capability-analysis          |  11 +
>  scripts/Makefile.lib                          |  10 +
>  scripts/capability-analysis-suppression.txt   |  33 +
>  scripts/checkpatch.pl                         |   8 +
>  security/tomoyo/Makefile                      |   2 +
>  security/tomoyo/common.c                      |  52 +-
>  security/tomoyo/common.h                      |  77 +--
>  security/tomoyo/domain.c                      |   1 +
>  security/tomoyo/environ.c                     |   1 +
>  security/tomoyo/file.c                        |   5 +
>  security/tomoyo/gc.c                          |  28 +-
>  security/tomoyo/mount.c                       |   2 +
>  security/tomoyo/network.c                     |   3 +
>  tools/include/linux/compiler_types.h          |   2 -
>  99 files changed, 2370 insertions(+), 589 deletions(-)
>  create mode 100644 Documentation/dev-tools/capability-analysis.rst
>  create mode 100644 include/linux/compiler-capability-analysis.h
>  create mode 100644 lib/test_capability-analysis.c
>  create mode 100644 scripts/Makefile.capability-analysis
>  create mode 100644 scripts/capability-analysis-suppression.txt
>
> --
> 2.51.0.384.g4c02a37b29-goog
>

