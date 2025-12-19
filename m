Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D016E66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A918C6B0088; Fri, 19 Dec 2025 14:00:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69C56B0089; Fri, 19 Dec 2025 14:00:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D0A6B008A; Fri, 19 Dec 2025 14:00:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8567E6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:00:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3AA67C0534
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:00:10 +0000 (UTC)
X-FDA: 84237135780.03.7ECA44B
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 26E15C0013
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:00:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2ccrzagb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of elver@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766170808; a=rsa-sha256;
	cv=none;
	b=PLK3cIRhcwq+z4Ki3HdzyxDkjhZqAoONU1bcgRGSWL/DDQOtYfja6qFB7ZMPYsXYZwlp1T
	0VwBezpQdO+VhAX0QWgZF0OXAP78pzQrefhi3IRXW4UJ4X14vlt3tG686+5gx/xIzKj4FP
	vF1u7GoqNyCZtRZysCV8mhqJbrbC1Vo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2ccrzagb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of elver@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766170808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/odPIAsEqnlw6wHnS+qyMx9or3tLcz+4e0MlLzaxNc=;
	b=aLfT9A3oDOMAvihSUSDIbX9ek5bs3Rfa+exFsuVE0JwzF2vg6UUSMlWKI+wlKrvE9RWTMn
	lXOj8ArZvPJzOkWTBehJL8sbuJCOl+MpdG6KbKv3vJqWQ6tWdc7iKAdZP21gHOw4HM/a3R
	rWJQgTyOIXSemntLMoul/1uSW3jgCr4=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-11b6bc976d6so4672651c88.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766170807; x=1766775607; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D/odPIAsEqnlw6wHnS+qyMx9or3tLcz+4e0MlLzaxNc=;
        b=2ccrzagb11DB5p8SB8wdiDbDbdxfGpm5lHcv2wBgChodWyZOsw3g3qPjmuJgUqYP9T
         knfaP7pSVY88ownSo8XMYpYlEVDpviHFlZavp6aCqJIv1wSuDZNMm1xwRR83zFfpFS9A
         vGKPwGNbee09/ZqndR1qw4cXrQgSo9+8GOAJzUtQiNYWVMKGRbGbTblo/NvWBVGtL/8d
         3YdVdbT8elHMcbfi2Yhh6AGWj+0bHd5kcO5cJj+Ml3YU0dwbb21cmqTJJsqJ9FXvPhTN
         SIW8QEHFOL3mRw/Zu4veZ67p5EwX8MwOH3TGYgdgbVhw/MJwfmRcxiGDa8UWqXFmKFVP
         6+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766170807; x=1766775607;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/odPIAsEqnlw6wHnS+qyMx9or3tLcz+4e0MlLzaxNc=;
        b=vAzw43CtefUbIq/ZYRxeTAercXciIMvaeBUT0UPxqGPtTCyNwTvOi/kaI8+PmrOoJz
         U+qEg/VatMFCUOoQh7ko8+eX++HMdo8lqztL1zBeB+ieVlzA1mSxu/OVo6TqUCn8Dwqi
         G/ZN2AoEtaotLMUJX28GXC2ZgxwxKZckZtQBZAmqMXAbaf3qAlx4yYgVGOw6zCwxkhOp
         Iq5gJNJzOu/D/d5jmtB6IxBd1kkoZlSTofrhr1kcWoBF3KmIG9TBlwKaamZ7fotdE91w
         l+Zlg9hAtWq2UilH3y69qVHtUPRUfeBoZZgPV7utyQEACbB6ai76Bgrgx1kAeiMI9dVl
         KKIg==
X-Forwarded-Encrypted: i=1; AJvYcCWVvvQISOfetaLPBdkDPbjnAoMyBcvzd/fHTSaK7djZMZ8T1SYB2r4p15XZ3eDxlhl5ZesUzF0PZA==@kvack.org
X-Gm-Message-State: AOJu0YxlGyMU4M0monkv6BT3lxx+rTFmMyUvHZ6akf4EcUci/OLRTVHJ
	T1eeKdSUOozzUxRDCsucFww1QuQWzYRvOFehtl0rFSGAjqTJGslRVJWPudFZ9JRGJwbUn6LsgOG
	ee2C2/rchNaKvrwlFjoGLtfYUpSLtFM+jKdZMYy9J
X-Gm-Gg: AY/fxX5zgBWqANEDxnxEWmfRSP7qpNSkPs3iLbvM9yVh+u2v525MGmOMNTUMf7N7Ojo
	mP5buQlGy/xcM4orpDiuRMuyeUaVjkfXB4Tzi1a/a+ZUbuj5dv80WC9rhwttcHvLTroCVI2/IXV
	AmTyXIAZHK79BHLIk9VXO1QzAuxUsL07SsUGAXDrZU/fIADcjDYfjrmx0+Q281kK0NPx2veFsp1
	zRvhGbOVca3C7DTnKlMmlpyjh67cQRuZODszVlILGlKeldFfkALkRD99VuDvfXDGHkkWilw9aL9
	SNpOvzxdQeGxjyMBq6vmlF2sb70=
X-Google-Smtp-Source: AGHT+IGI6fhGlCAK5gIWEv2jikK+I6nNqMuicJ/gn32IfnfyLg/3iMMiK5+5k7SD7xWkO1DmvhdstHNBA0RnTPGiyR4=
X-Received: by 2002:a05:7022:688:b0:119:e569:f86c with SMTP id
 a92af1059eb24-12171a75857mr5077504c88.9.1766170806408; Fri, 19 Dec 2025
 11:00:06 -0800 (PST)
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-3-elver@google.com>
 <97e832b7-04a9-49cb-973a-bf9870c21c2f@acm.org>
In-Reply-To: <97e832b7-04a9-49cb-973a-bf9870c21c2f@acm.org>
From: Marco Elver <elver@google.com>
Date: Fri, 19 Dec 2025 19:59:29 +0100
X-Gm-Features: AQt7F2ouc-8nhWnrDvuFRBnm-IOIeCWwTeXWCxaDLix1ft6mKkghBhqY0U-N9rY
Message-ID: <CANpmjNM=4baTiSWGOiSWLfQV2YqMt6qkdV__uj+QtD4zAY8Weg@mail.gmail.com>
Subject: Re: [PATCH v5 02/36] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
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
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 26E15C0013
X-Stat-Signature: t79ot77icx5ng8cbpkdrngytay7itgus
X-Rspam-User: 
X-HE-Tag: 1766170807-547484
X-HE-Meta: U2FsdGVkX19vwy3pN9qqcaJhDCijc7k7aqlEmjxiUdyIiqTeSySBocYjSfo/p0Y0WLCM+oDt0ox95fKGVFYcL6w0hwBV5+fdILm2V8EzR76jN2fppKei4fB6jdf3zzxnjS0A/98NSf5bWAuyaCKyke9+TKgL0lB8/ZMmZdrnozkJ+/dcztVP4Mk42GOcgKHUKYwGpWshasMLzA1AvQgD8bhUqeFlhPAZW9Kh5OqcY76y6R5F/C6lu7Ych98rjI+YL4OX4RTy8J4ZLxPRQvj272uiC4jU/NFgnC8fRFy/1QoXUppjCtHdpqv66XbhQIgnIVKx86Dz/wFI4sbNuLaiil7nhoCqf4OfWEzZDh6jupGBUxjv7UF0cfy4kBCmFttHtydfpJuAiBk1BoIvEtnGxN32rQyE6BBDlCR2Ou5kl3DFwS7oAWI7pnmGOz9XpgRl/EUg+FPqL9dYfxaTRS4kGQ9M4JXNGJzxXYL9U4FS5pmeh49mnk1rWu/uK63gJTym1dj+j9+49y9uiZYHOVdOjF1eruKD5X2pG2xFgomukWWUjEYIxwBX+ZnVOH0FddLJjLiLWa7tb69qP+eU7p+uUqRvEEqlQqyze+7IWx2gtGbWVzq9J4vD/mv2fcpMZQjBMIGuMvhDI6Xi5gWL+pG2q20chDMGdMFxQwb2laLoHgA7NbeNY8pXiT8PbSeA1P43UkI9QMZFUra5BpWKyRIOK+hSmPMsVk9rkrZ7w1Xh7n/JD++p+PLB6evzFh/sQSTF0Guu6c0yQ6MNVL3sEujmj7HxYSLI4H/QQwXmQjXrA9xxXERPu5QS3hlnqhN6pJZk08AhKKK0EtiXnhOwgeNNUaKfRUHqhjw1r0JHA5i8jyoGeF32NljDhj65CtqDXTbdtF2tY2rlElkxg20YrHZpRr8OVHEJ9PYs/R7Wox7GNtfyIxzHNH3S01HXGk51y/5mwSrHLi/WaezGnntPwOW
 /0gikz2C
 //7S4SxG2uObWcjamV6iW3q+90R3o0ewLaAvLU1kHNOCS97XNLy7Tqo0FQEZQCMYdNpcXFx+ZEpkq03W6bFTHOMaNKNuspMtHrIz2y2vcPZJ8STASMdCOnZfrgWmGNQh6mfGSHj60Yrbqn4fstUTvmMnQPXfRsvPbiDeByd9D9bDGldhneJF7iP8WfXlQqAgg4HgsK0O4iBI6cGLWFsvIJf7f6dQtqlFO9dYRDux1dIYZQRV40GvlSGHIMx9BAWrM7Tf8t3JQRfQwTsCttjXY/AeqrosU8TzdEQLTm4+A9M7kGrhKrxkCRuNepLuhBP6WpK/o4VYzfdhbX2k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 at 19:39, 'Bart Van Assche' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
> On 12/19/25 7:39 AM, Marco Elver wrote:
> > +#if defined(WARN_CONTEXT_ANALYSIS)
> > +
> > +/*
> > + * These attributes define new context lock (Clang: capability) types.
> > + * Internal only.
> > + */
>
> How can macros be "internal only" that are defined in a header file that
> will be included by almost all kernel code? Please consider changing
> "internal only" into something that is more clear, e.g. "should only be
> used in the macro definitions in this header file".

Sure, comment could be improved.

Let's say they aren't for general use by normal code that just enables
the analysis for checking; for that we define the shorter (retaining
previous names already in use) ones below. But some of these
attributes can and are used by implementing support for some of the
synchronization primitives.

> > +/*
> > + * The below are used to annotate code being checked. Internal only.
> > + */
>
> Same comment here about "internal only".

Sure, can be clarified.

> > +/**
> > + * context_lock_struct() - declare or define a context lock struct
> > + * @name: struct name
> > + *
> > + * Helper to declare or define a struct type that is also a context lock.
> > + *
> > + * .. code-block:: c
> > + *
> > + *   context_lock_struct(my_handle) {
> > + *           int foo;
> > + *           long bar;
> > + *   };
> > + *
> > + *   struct some_state {
> > + *           ...
> > + *   };
> > + *   // ... declared elsewhere ...
> > + *   context_lock_struct(some_state);
> > + *
> > + * Note: The implementation defines several helper functions that can acquire
> > + * and release the context lock.
> > + */
> > +# define context_lock_struct(name, ...)                                                                      \
> > +     struct __ctx_lock_type(name) __VA_ARGS__ name;                                                  \
> > +     static __always_inline void __acquire_ctx_lock(const struct name *var)                          \
> > +             __attribute__((overloadable)) __no_context_analysis __acquires_ctx_lock(var) { }        \
> > +     static __always_inline void __acquire_shared_ctx_lock(const struct name *var)                   \
> > +             __attribute__((overloadable)) __no_context_analysis __acquires_shared_ctx_lock(var) { } \
> > +     static __always_inline bool __try_acquire_ctx_lock(const struct name *var, bool ret)            \
> > +             __attribute__((overloadable)) __no_context_analysis __try_acquires_ctx_lock(1, var)     \
> > +     { return ret; }                                                                                 \
> > +     static __always_inline bool __try_acquire_shared_ctx_lock(const struct name *var, bool ret)     \
> > +             __attribute__((overloadable)) __no_context_analysis __try_acquires_shared_ctx_lock(1, var) \
> > +     { return ret; }                                                                                 \
> > +     static __always_inline void __release_ctx_lock(const struct name *var)                          \
> > +             __attribute__((overloadable)) __no_context_analysis __releases_ctx_lock(var) { }        \
> > +     static __always_inline void __release_shared_ctx_lock(const struct name *var)                   \
> > +             __attribute__((overloadable)) __no_context_analysis __releases_shared_ctx_lock(var) { } \
> > +     static __always_inline void __assume_ctx_lock(const struct name *var)                           \
> > +             __attribute__((overloadable)) __assumes_ctx_lock(var) { }                               \
> > +     static __always_inline void __assume_shared_ctx_lock(const struct name *var)                    \
> > +             __attribute__((overloadable)) __assumes_shared_ctx_lock(var) { }                        \
> > +     struct name
>
> I'm concerned that the context_lock_struct() macro will make code harder
> to read. Anyone who encounters the context_lock_struct() macro will have
> to look up its definition to learn what it does. I propose to split this
> macro into two macros:
> * One macro that expands into "__ctx_lock_type(name)".
> * A second macro that expands into the rest of the above macro.
>
> In other words, instead of having to write
> context_lock_struct(struct_name, { ... }); developers will have to write
>
> struct context_lock_type struct_name {
>      ...;
> };
> context_struct_helper_functions(struct_name);

This doesn't necessarily help with not having to look up its
definition to learn what it does.

If this is the common pattern, it will blindly be repeated, and this
adds 1 more line and makes this a bit more verbose. Maybe the helper
functions aren't always needed, but I also think that context lock
types should remain relatively few.  For all synchronization
primitives that were enabled in this series, the helpers are required.

The current usage is simply:

context_lock_struct(name) {
   ... struct goes here ...
};  // note no awkward ) brace

I don't know which way the current kernel style is leaning towards,
but if we take <linux/cleanup.h> as an example, a simple programming
model / API is actually preferred.

> My opinion is that the alternative that I'm proposing is easier to read.
> Additionally, it doesn't break existing tools that support jumping from
> the name of a struct to its definition, e.g. ctags and etags.
>
> > +config WARN_CONTEXT_ANALYSIS_ALL
> > +     bool "Enable context analysis for all source files"
> > +     depends on WARN_CONTEXT_ANALYSIS
> > +     depends on EXPERT && !COMPILE_TEST
> > +     help
> > +       Enable tree-wide context analysis. This is likely to produce a
> > +       large number of false positives - enable at your own risk.
> > +
> > +       If unsure, say N.
>
> Why !COMPILE_TEST?

That's the idiomatic way to prevent this being enabled in allyesconfig
builds, and other compile-only random configs enabling this and then
stumbling over 1000s of warnings.

Thanks,
-- Marco

