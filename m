Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3ACBCF9C7D
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 18:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBC46B002A; Thu, 20 Nov 2025 13:21:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3516B002B; Thu, 20 Nov 2025 13:21:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D88A6B002C; Thu, 20 Nov 2025 13:21:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9516B002A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:21:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C77E913A7EC
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:21:41 +0000 (UTC)
X-FDA: 84131803602.05.9343B61
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5C1D714000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:21:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=a6INyt91;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.174 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763662899; a=rsa-sha256;
	cv=none;
	b=LhXbSIkI0DcrkQpmePVI3v5IhnZyQkdQM9L9zqwqqoB13W5a9ykdrgiIkrP7NQYBEbVQAX
	zMNMYrRsSd7rr3l/umDcQ7xBaNarFfV3CCDIWCEP0zoxYYjXlwhdoY/v/rdZ8CD293TwZ1
	dH3isYUakDt/r9UK5ecZU7XDLW9PWZY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=a6INyt91;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.174 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763662899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BPfdnrOHpw/8tC+sL0oorkp9gKYtrunKdRWYzTn+GA=;
	b=O3XbnJ8BCqco68QL5DVXjqIDHW8Lc7JejY9ZPcKftfvQwu4R3LfT+6GZK27D+2YY1nDzgt
	JXmlHRfHppIeSqcmfM8jEEL873L5CYxhmg8O9iPQMMOfnrPzEkDxieyg5B9ywUmScqXO4C
	ymswKshdKo2olNXUnEUv2w19ZbbIll8=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-37a875e3418so7625911fa.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763662897; x=1764267697; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+BPfdnrOHpw/8tC+sL0oorkp9gKYtrunKdRWYzTn+GA=;
        b=a6INyt91CQvligK8uczbguuTJ1Q7GyIMv5IrHPTwnYDvP5I7Q596UCSc11qlVp0wDK
         M5uwjPqnjmq6o665skKHgeitM65bUvFpZTZWeOa+t/q/rTKHhQkhu1ZSUWC4exEagw3V
         jldToMJk1N07eX9jrpS97X1uRrvOlktGeu8u0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763662897; x=1764267697;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+BPfdnrOHpw/8tC+sL0oorkp9gKYtrunKdRWYzTn+GA=;
        b=CEMNEZN8QEXgBxFtCwDqKWCGiHgG14wk5n5LEZtdNO6Cu2SOStz+dSjdqnZ3YG6+VS
         Sft97rMyEPjAfVDQV7ZMzkX5yA3pSkLdQWELGf8yDjnGSdKZTEVNertaspJ3uyvHH5Xo
         ZvOlzunfzLKeQqbYeykDyPW/VpdbhS+04P7wG4A8GlolPJrMk1EBCh4vAwhVV0DitGXc
         q6QpD7rpA492Qbu0TEOpKfeqVYz/z4qHqxR3rHbdmeHCJUcSpidYqFM2xWl4mW9bV+JV
         aSbuWQ8YcwFZGkn90w0az47rvYHq8X6TmrnbugTPSIfRBbim2QTLDfZiVT+DGIO+2uCy
         dp6g==
X-Forwarded-Encrypted: i=1; AJvYcCXtcqBp44I8Rdn45GJBQVKSrRv5fyFLJHuinGljxpWlWEEaNb57zEiuh8UW+gNDkncxYIF7zp9HWA==@kvack.org
X-Gm-Message-State: AOJu0Yy7BcXBXCA6hliiVSb6oFLXo0Rs46ldXDWJpyD1JfCke8sPSl3N
	faf6C5OIfdEbcns0rQtnWbDedagZxYp+9E0jlqPuxleycdoyn+D1zas9mh54Jott8GX+BSc+TQj
	uocCJgAGZ1g==
X-Gm-Gg: ASbGnctlC8JcXpE+/WwOwguikyjV5vT80I/+7GgLbY85oNlibbfHlUvwDU0SI1edyuC
	QohBl55qJnjoJI8HNMO2uo4IihCMkDUMXfzPlwdUxjP6Uy/5telECtOz7envlDlq+WBiiNoRtDx
	S4ye3Z75fghkBVoaaX+zDp6aoupv16495PpCt25WhI2YUgGv/qjGdj8eqkqiqOSvPVfmyS+v0bi
	AAO08SLiXeLKFhqEucaKE8yrauQ44NOfH2eBqhYe9J5pWJUeGng749lAbheJMO3fBKx7mb4IHRj
	Re+hq6YMX4SRBwrfn/0RRl3e6D/9i/hpSgiiU1csnbgm9tpKFC6nz/3fS0gyagr3IOtLSveeqZE
	AX0A5C+Zspejx664rVRXQwLpuJQYxZOmxi2DKeGS23u9nXj6M7oHzxyF9nQJZ9mx5IdYSivu9B/
	T4HWghuwFkil4IEHTCFK39z8iXs+cdlo9wiQurrx53ahY+ZaqeTvF6bGf/gMhzrQiu
X-Google-Smtp-Source: AGHT+IGOXKHwP8TxovyTLXkw/7hRi+RpHbOWKL/GFJJob/tVBNfrifOO1Rq6Tpu+JiGx6H7DQiHdUw==
X-Received: by 2002:a2e:8a98:0:b0:37b:ad8b:7680 with SMTP id 38308e7fff4ca-37cc673f43bmr14281551fa.9.1763662896934;
        Thu, 20 Nov 2025 10:21:36 -0800 (PST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37cc6bafbddsm6055141fa.32.2025.11.20.10.21.36
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 10:21:36 -0800 (PST)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-37bb8bef4cdso11133071fa.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:21:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXIiaHWJ2rReET0MJlzZvxbIoTEGOITxIzosnMozKKAzpU/r0rwP4lFhjVG1Fmnc1GaGp9OfP9DCQ==@kvack.org
X-Received: by 2002:a17:907:7f0a:b0:b70:b71a:a5ae with SMTP id
 a640c23a62f3a-b7654fe9b97mr482177966b.44.1763662490181; Thu, 20 Nov 2025
 10:14:50 -0800 (PST)
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120145835.3833031-4-elver@google.com>
In-Reply-To: <20251120145835.3833031-4-elver@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Nov 2025 10:14:34 -0800
X-Gmail-Original-Message-ID: <CAHk-=whyKteNtcLON-gScv6tu8ssvKWdNw-k371ufDrjOv374g@mail.gmail.com>
X-Gm-Features: AWmQ_bk-my8wSL6P8yRhTUREdDraem8VrQQmjD7uS2S9oN6T2mRX46ftlS1ytQU
Message-ID: <CAHk-=whyKteNtcLON-gScv6tu8ssvKWdNw-k371ufDrjOv374g@mail.gmail.com>
Subject: Re: [PATCH v4 02/35] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
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
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5C1D714000A
X-Rspamd-Server: rspam07
X-Stat-Signature: n3enc3mxbo6jua9ea4ufnboranww7rog
X-Rspam-User: 
X-HE-Tag: 1763662899-763650
X-HE-Meta: U2FsdGVkX18Foh3g1XYAa834EMf1LOiT+0o3yoWnTBo8lgFeV57zcMzpCjqd58TdNT6uTyDPBfysn03mNTrVl7sPoa3IN3bmpaV22sm+jBhwU8iauhXm8+rF+VwPKL1uZWjluPpKll5xhoWAgkhrpEUgrYM4eNIeJMtWlKPKPPwEJw37snKzzTe7vq7R/SMe38IE9exq6LIUb9i+RkNEbkLFDPqZIlcXu4RuKwtyuMyToLupxujwpTPz2jjTlf0wsq89ZImu30qe3qx2f/rz+A9J7IqGn8ezwUHNT3tR2DyFUwU3GMRLc8DbEiJ0EpKLq010cNFN+9/XmnJHsi5hOBsuxV2Fz1AN2z9HisKfn0g2VerrVj0mTByTBlB9vXzigpsqRjaY/ZKi3FXzBbOkT0xe74GWOu/6pBe9pqiCVKOrw+uk7SIt6pNuEo5aNFnvXvUoE7gEpfGadU2B2Tp364t4DJHGkXTsuGIq+A0pxNnFuISnBKu6Huf6lyQ+5t95PWVPvBdR3hWYcWGmC5JDiPk9BFAm6PN4oYXx0oRYeE3vEMlfgwNAkPWSuJiH0vGFLi/cHLI6/pd8oFSphZFHUhXRO57IoGMEVvVl/E94wBpTGZCh5Kvnib+H6g0dSaexKpW+HwWG5l5+/ScatKsfESFEGLX6rXTpfXgc2f0PFuhb02aT6ndpDNKgVF7wcs3iuWK+Syf9t5FGfabdSaUiSjp1pSBmXn8aDMCByl6CrqNS54O58//GNt+kUqa/nfwnGMHqWcZOw0jg3HpSlf6wYqID/i10fwEpdbG1xP2dB7a+IOvuuNRfsLnW/HAi325fRlDSTh4379JOOb/9cLWCxy3T1ze9MZx3CgHJukplmdmwlRd9SkE2Gk8wo889S6JiNqfVJG4TjHphrXR+y8+iTF+U+fY9ZdOj4gu0BTfw39paDA7FK6xOwdMmGwtgKDX7mhCkeaDJHaqGjgx4sNY
 vKPSut0I
 tb1WINcadLGHMU7/nrW3SuaZGro6LgW4pcmKrMyx5T8Sa1vcTJYEbQp4MxADzeIVSEUHdOT32cCMAeEtb988KYoXzY3DxvHwZSFXIIICfGUp9XoD0z6PjePy4h3wU+9+fZ4Zg6MJFo9VSMTTM3+M3t+LysP2tQ5zmjR1wB2UaWvOjw7pkH24qezUP5xzUBRI7TrJjG2jaL6o8zlnl7PuFR2CxAZT2yHbj8du4bxkXczmADB2EvSJkQ/01xx/krKv1Q4i6g/Xr956GrZ1+WKsWgFIB+sjZ3bIxcDq15LJd33FWTDr4M6urIYL6gsDagyvw139us8fXU/OMoWNmoHGObj+EqaO8jM//YPZLSlFqXQQ2ms5DrDW3EpW0TeksDrJwu4aJ6Rfj7MfKYxF1IT3L0nzv/rP9GIkczvAB92853OBd4uPhUKvb3Yu2s+SMU48uVIVhwAp123bfm10uxTHkFFm40r4jbfAV2VWoWDqeZNWzc+P88hBwdj/WNbg7UFnZP1WhRkCNKIDWzUnzGsi76xm7h0jYKlhJruz3lhFhdYQOsSBeYC9XHcE37EANqIhFX+nM9L2NGAvAP4iRY2k3ik3O3a3baYRO/o6+CvfocbT6FYjcR5eQKeb3uKd1BfJxP1WVOH12iW3FSOY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 at 07:13, Marco Elver <elver@google.com> wrote:
>
> --- a/include/linux/compiler-context-analysis.h
> +++ b/include/linux/compiler-context-analysis.h
> @@ -6,27 +6,465 @@
>  #ifndef _LINUX_COMPILER_CONTEXT_ANALYSIS_H
>  #define _LINUX_COMPILER_CONTEXT_ANALYSIS_H
>
> +#if defined(WARN_CONTEXT_ANALYSIS)

Note the 400+ added lines to this header...

And then note how the header gets used:

> +++ b/scripts/Makefile.context-analysis
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +context-analysis-cflags := -DWARN_CONTEXT_ANALYSIS             \
> +       -fexperimental-late-parse-attributes -Wthread-safety    \
> +       -Wthread-safety-pointer -Wthread-safety-beta
> +
> +export CFLAGS_CONTEXT_ANALYSIS := $(context-analysis-cflags)

Please let's *not* do it this way, where the header contents basically
get enabled or not based on a compiler flag, but then everybody
includes this 400+ line file whether they need it or not.

Can we please just make the header file *itself* not have any
conditionals, and what happens is that the header file is included (or
not) using a pattern something like

   -include $(srctree)/include/linux/$(context-analysis-header)

instead.

IOW, we'd have three different header files entirely: the "no context
analysis", the "sparse" and the "clang context analysis" header, and
instead of having a "-DWARN_CONTEXT_ANALYSIS" define, we'd just
include the appropriate header automatically.

We already use that "-include" pattern for <linux/kconfig.h> and
<linux/compiler-version.h>. It's probably what we should have done for
<linux/compiler.h> and friends too.

The reason I react to things like this is that I've actually seen just
the parsing of header files being a surprisingly big cost in build
times. People think that optimizations are expensive, and yes, some of
them really are, but when a lot of the code we parse is never actually
*used*, but just hangs out in header files that gets included by
everybody, the parsing overhead tends to be noticeable. There's a
reason why most C compilers end up integrating the C pre-processor: it
avoids parsing and tokenizing things multiple times.

The other reason is that I often use "git grep" for looking up
definitions of things, and when there are multiple definitions of the
same thing, I actually find it much more informative when they are in
two different files than when I see two different definitions (or
declarations) in the same file and then I have to go look at what the
#ifdef condition is. In contrast, when it's something where there are
per-architecture definitions, you *see* that, because the grep results
come from different header files.

I dunno. This is not a huge deal, but I do think that it would seem to
be much simpler and more straightforward to treat this as a kind of "N
different baseline header files" than as "include this one header file
in everything, and then we'll have #ifdef's for the configuration".

Particularly when that config is not even a global config, but a per-file one.

Hmm? Maybe there's some reason why this suggestion is very
inconvenient, but please at least consider it.

              Linus

