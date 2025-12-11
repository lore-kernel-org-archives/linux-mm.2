Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AE9CD41C36
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 13:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075E26B0007; Thu, 11 Dec 2025 08:13:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41E06B0008; Thu, 11 Dec 2025 08:13:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E097B6B000C; Thu, 11 Dec 2025 08:13:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC7556B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:13:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82E81B6258
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:13:00 +0000 (UTC)
X-FDA: 84207230520.25.8289B5D
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id A37861C0012
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:12:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=COwn0kos;
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765458778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aSAWeLhswH6DwjvXpmjx7xXAiszMCLjSPlHn40Ul7IQ=;
	b=zRp0iOGiFp5fxI1lymezrwBjHRb81V73CWRSvC+4ArBWS8s/8rAKrX4aPPi+oRMuAO0TrI
	AzRgOY+BnFdkNsdC8Ky5oGPz6zSBWROgCOhMnx7jg6ZsznwdWev+kPtIWIv8zmXteJ3RFq
	cc3qlIap2tVo2Mums1ueKJ5le8uTAQU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=COwn0kos;
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765458778; a=rsa-sha256;
	cv=none;
	b=1wBPoueTimL0oJBGRkpFJvej/c1Dw61mNlD95ZvGGg2TNiL2fnmL7XswWR8Kb05bUzLQrT
	1AlabrEr7D2bzOPS3vEASioEji/w9d0yuqjU69Ed9IGhWeCqrGtPHveC2+K5ejKYU4TkAf
	438UFqCs4U7onEnmMsttkq7VnD83MNQ=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2953ad5517dso818085ad.0
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765458777; x=1766063577; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aSAWeLhswH6DwjvXpmjx7xXAiszMCLjSPlHn40Ul7IQ=;
        b=COwn0kosmYURFOSCRmZQ87Upwbg8Avr0JI1WruxBa6JKS206uJRK4fCNGv3Hh+OAUR
         QfO8QdVbGnlnJ5th2zsbKTiAKI4U82c3UJbBA+ZVtUZTdiHwmNne32GkvvkhnF2eeHgu
         RqwlItifrpX5YXZwlqSZbfl45FSCpE1rZrYMHtDGdZcC20Y7zML/x5abT24SyXQPbRKL
         xw5pTQDDh05KylRI/aSMFaGKlBRiIh9XdWmND5P5ye8Chk17ATfyo6tqrL+DDSRaBCI7
         qsnaP1hVSA5b5ERDG7HHY7PCgSy9xqHi/o2VOKweW7Tz+7fVC/FLrw5Kv/ooT/lMKXuE
         GtFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765458777; x=1766063577;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aSAWeLhswH6DwjvXpmjx7xXAiszMCLjSPlHn40Ul7IQ=;
        b=DaCyIr90ettlihjL2w6WfHiDhFgIWxxPReoWmp67ATa6H390vTTgTIU5fT4ClZvxM1
         hFYfynBVuil8kIQwbv7pm6emAZScnThZ36LtGwbsAcrFYl5f/EDtbb+BEslTG7u6MU9i
         H1vIZDsZOplgsBPn4OUSsqbB1453P5IXWPp9pkKHKOGAvcj5fo+JU/KJXseyZITF5KkO
         KN81fa5jWWkRva/2OKVVnmIyMB3RRWV8NoPDQz3Py8KnDqvy99hChblULh0RYn3ZLad6
         AKA9o37GC8B98vgVsZPAJyvulVrbr0xlU84hwbtvO1YgXDYkQ1fHolrEkPtSIuxIKiwf
         BS3A==
X-Forwarded-Encrypted: i=1; AJvYcCVQZWQWzpcmwjCFScuf890old8ptPeWWCItavAPpG+BPDz9dWaTopaXJRNTehFnq23sFlTfg8m8Wg==@kvack.org
X-Gm-Message-State: AOJu0YzZ4+/8/pxsDYI2MPePFoyqxwq1nA8avt+F2YnjdrmxT9UaQhgN
	BY0nhUrVpDatrC3i44tDeR+fefb/Jk4Ji20WRO8JgTi1rNE1GTs2khOifM4gBRw1bH5jaUfXlZ2
	Ex9zsRonlJjokLEWgnMJYbSjfZYYnq2VYrycV7szH
X-Gm-Gg: AY/fxX64O0GlrKTipz3k4SLyqvSihYC3SxofB4l55iGFiCddI2/d2BCoWFe71wreQLK
	5lTbcIgYD3DDoIbhUqXwFf8KQQw5hzHsecJq5+U3CqfqrJka5gJnlYE4+6XgxBaitW2YUo6uFXm
	7qq+9Nzr1R9jzAB0uZWgLbkKrLTPqeZFwzOXHenItuuuoC4BJ7rTiffBIaARNLMhSwWqSioI+oP
	l5zJybDfMO8uwIiqsfHspr9CR/WwNhRp513zL7XfWHxr5rrm6W1EgZM1lPnMA3EijZh1Sz+PyX8
	4dgp2SnTC+7TwrU/CgGAyvLh
X-Google-Smtp-Source: AGHT+IFKUTpUZDJYgmni8n60xNJbrbAVNuDkEgVCtA4vIsV0NrU5sPU9y26HNSVsbHocOOsMdXB5E5HCLF6JNhBBnMQ=
X-Received: by 2002:a05:7022:685:b0:11a:5065:8763 with SMTP id
 a92af1059eb24-11f2966a3c7mr5044765c88.5.1765458776836; Thu, 11 Dec 2025
 05:12:56 -0800 (PST)
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120145835.3833031-4-elver@google.com>
 <20251211120441.GG3911114@noisy.programming.kicks-ass.net>
In-Reply-To: <20251211120441.GG3911114@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Thu, 11 Dec 2025 14:12:19 +0100
X-Gm-Features: AQt7F2ok29a5Gxu0w202jEvGPrWPxaH5LVi0EBv48F585MyX9KePj1tDpUehhNc
Message-ID: <CANpmjNOyDW7-G5Op5nw722ecPEv=Ys5TPbJnVBB1_WGiM2LeWQ@mail.gmail.com>
Subject: Re: [PATCH v4 02/35] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, 
	Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Chris Li <sparse@chrisli.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Dumazet <edumazet@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Johannes Berg <johannes.berg@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xn1dcr7h71cnfskmdpuwxi34x8ny1z75
X-Rspamd-Queue-Id: A37861C0012
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765458778-763652
X-HE-Meta: U2FsdGVkX1977dQyW090qkjlGFHqmfwlFbpwrarNqLS1BCNsSqpueduPCrIyil3XsGPVm2gM6xv3zKrHr5cmPi5AwMJdM2hU/4eLrOZipJFnRSMs7OvqLBcXTlFzTNvDC/UiRV/ktAx00oG9+I0YqIcyNzaSPComhWBJafepsRrcE1Yl8kqZZaws+6U0vyu76VnrzUlq2vxFgvsvHA2mBNMsV/IUjgazyRc1n9x/nquQnvnZwgwfz41qRAYD8hVaY+vsVmojDn7KqMXhNSY0RboECwIY90r5Ffh/z8T20uYgvCO6ZF5qq8cuPMISrWQqTa6/AUFyNh4x106MICrqmEoYEHaYwZ5cslcmJgzuuNhajv9e+Q2yhdq8c4EtfC0utiEfI8NobFJTvvLzn5ZHWKF+OPEArLZHS8MzTwiAJUMUq7gjydhd0BRHbbXtZIutf49JhU340YikjYrNk6wvbMz2QM6bKrX8ygku7zuvZZ1+rUrJaEShCOBjAQvmu5t5L+EGuHerMiOh4FcZaiXJVL8mnJ83aIfbyuwrasSLK4S1V0PkpbJNvpOBteFHjWGWCZdc8UyrFdI0v7uK0AaU6r0QTvmsg9t3RLxUrYCFcM60iEhPePhUEHlpJ11sf5sFI4SjFexR6mhQ3xSK+jibNrQn5VctEkD5Q0yjnewAknrHhIppkfTUecO16OrJ1tCrliURvINtCNyekQw2nAy+V4mYycKZF3RvVIwfg0YXRB0nCDTqputbacAXt5bPT6NFL72OeZDIdy7NWzfB4fq7lEqHabiTDM542xgwQv5IZtchUGlQ6rQDcThdY2ZLm2XyhrzRqdIF0LCfruO3tk5XPlum0ZNTZSpqwFRQCjYOBDo3MjloXbFN+mxWOvpGex+asC2czEWEhuUGNsqyP2KIbJ4ou4VtC59nd5ut2yEstTOJ8MuyP/ZV42JSrkPufgqLUlL2W0Js8AVeiWzbpe1
 ot0PNEIn
 KIIMUfpIWhamTQwL8UCUl7YPuwmQkjp4sHhy3Cvu3hgNqbHIldaL018hkq+vC+kIF2yRHYiFEbIoI5WSWObX5ithi6efPDxXRIqyUzrs+XigOCZbiFVbS6vecn644Z7bYwUNaRhTbUnP1XOdzvuZIhEV8XV9iCr+Iz31jkTeXO5SafXtlGLmnl8dBTzHSFOeHxquZLtDy0LOv95hnxWB44hRIc8YWhJVdp2FvqM+Enqn4MdAmI7qAaLQGbYGmovh6K2uRZMyecYm2PpKup9fKcWnzWZbmQJgJ942IpXko2N/RAe7i7IVlXwJknjQC9/AZmq7rxsth39vAAZo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 at 13:04, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Nov 20, 2025 at 03:49:04PM +0100, Marco Elver wrote:
>
> > +/**
> > + * context_guard_struct() - declare or define a context guard struct
> > + * @name: struct name
> > + *
> > + * Helper to declare or define a struct type that is also a context guard.
> > + *
> > + * .. code-block:: c
> > + *
> > + *   context_guard_struct(my_handle) {
> > + *           int foo;
> > + *           long bar;
> > + *   };
> > + *
> > + *   struct some_state {
> > + *           ...
> > + *   };
> > + *   // ... declared elsewhere ...
> > + *   context_guard_struct(some_state);
> > + *
> > + * Note: The implementation defines several helper functions that can acquire
> > + * and release the context guard.
> > + */
> > +# define context_guard_struct(name, ...)                                                             \
> > +     struct __ctx_guard_type(name) __VA_ARGS__ name;                                                 \
> > +     static __always_inline void __acquire_ctx_guard(const struct name *var)                         \
> > +             __attribute__((overloadable)) __no_context_analysis __acquires_ctx_guard(var) { }       \
> > +     static __always_inline void __acquire_shared_ctx_guard(const struct name *var)                  \
> > +             __attribute__((overloadable)) __no_context_analysis __acquires_shared_ctx_guard(var) { } \
> > +     static __always_inline bool __try_acquire_ctx_guard(const struct name *var, bool ret)           \
> > +             __attribute__((overloadable)) __no_context_analysis __try_acquires_ctx_guard(1, var)    \
> > +     { return ret; }                                                                                 \
> > +     static __always_inline bool __try_acquire_shared_ctx_guard(const struct name *var, bool ret)    \
> > +             __attribute__((overloadable)) __no_context_analysis __try_acquires_shared_ctx_guard(1, var) \
> > +     { return ret; }                                                                                 \
> > +     static __always_inline void __release_ctx_guard(const struct name *var)                         \
> > +             __attribute__((overloadable)) __no_context_analysis __releases_ctx_guard(var) { }       \
> > +     static __always_inline void __release_shared_ctx_guard(const struct name *var)                  \
> > +             __attribute__((overloadable)) __no_context_analysis __releases_shared_ctx_guard(var) { } \
> > +     static __always_inline void __assume_ctx_guard(const struct name *var)                          \
> > +             __attribute__((overloadable)) __assumes_ctx_guard(var) { }                              \
> > +     static __always_inline void __assume_shared_ctx_guard(const struct name *var)                   \
> > +             __attribute__((overloadable)) __assumes_shared_ctx_guard(var) { }                       \
> > +     struct name
>
> -typedef struct {
> +context_guard_struct(rwlock) {
>         struct rwbase_rt        rwbase;
>         atomic_t                readers;
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>         struct lockdep_map      dep_map;
>  #endif
> -} rwlock_t;
> +};
> +typedef struct rwlock rwlock_t;
>
>
> I must say I find the 'guard' naming here somewhat confusing. This is
> not a guard, but an actual lock type.

The switch to "context analysis" required us coming up with a name for
the actual objects (previously: "capability") that "guard" those
contexts.

The reasoning was that these are guards for entering a particular
context. The lock guards the given context, but the context itself !=
lock. Clang's naming of "capability" was a lot clearer in isolation,
but the problem that Linus raised is that "capability" is already
overloaded in the kernel.

The fact it overlaps in naming with the other guard(..) infrastructure
is not entirely coincidental, but I see the confusion.

What's a better name?

context_lock_struct -> and call it "context lock" rather than "context
guard"; it might work also for things like RCU, PREEMPT, BH, etc. that
aren't normal "locks", but could claim they are "context locks".

context_handle_struct -> "context handle" ...

?

