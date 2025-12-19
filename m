Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 416B8D7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95946B0089; Fri, 19 Dec 2025 13:39:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A190C6B008A; Fri, 19 Dec 2025 13:39:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ED496B0092; Fri, 19 Dec 2025 13:39:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 788AF6B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:39:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8FA612F68
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:39:17 +0000 (UTC)
X-FDA: 84237083154.18.B6555E7
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	by imf20.hostedemail.com (Postfix) with ESMTP id D87411C0012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:39:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=r7Yag90D;
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf20.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766169556; a=rsa-sha256;
	cv=none;
	b=wqKszsLOYJb7+8CZ37CVD0Ta/DznWETfceVYjNqwUUWGMiDAZh5T1wYCPpTPh2vmOtv8fM
	eN+EJfH1UTZkcXHQrKsMXNzDEBE0BA1T1gJGr7PXPGfo7TtAxWH7ze0sWoeW4TOw7sHBv3
	t3c8hWeHKYTYimdgXrTcA1aIGjgPFXk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=r7Yag90D;
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf20.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766169556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgosp44VAu2P7aU4KenxOvJYazdnvtt9NxyqcaL3Tns=;
	b=Yaew9+dH1MxZ9hwwWiRWZrQ4JLHdwbyZRfjU8yA0VVgalLqviZkctKQPHIcgx/ZoOjC0bI
	MtIEva5zD5Wsj+Lzvz5usoxhVceSrncfqwiFi2i5cuub9c45BnfQqlByW7cLlW5J5NMnwk
	NaxAnxTnvyngRRG7OrDsKYM7YyYbSds=
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dXxC64LYVz1XM0pZ;
	Fri, 19 Dec 2025 18:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766169545; x=1768761546; bh=dgosp44VAu2P7aU4KenxOvJY
	azdnvtt9NxyqcaL3Tns=; b=r7Yag90DdhVFdBZYPtWEBx9cmCCgXFjjEpr00iey
	p+3zXepZk3G3B4Bwu97WCJb1s5MPa26ClqUCvQBDwMVJvuz50WwTPPwUFZe5E46U
	ja5rUuNt4XNe/5D01S3EOF+T3RyTp91P0nuOYG2d6McW7+kHXp4wwJlozgS4PkCd
	qp+p8gQa7mJHDXA26JtCjnOfk8C6CZ67nPnsZoyJqdw/5BjSRx3eJIxixLXL3e4l
	vgETtAqLb8KL5bbR+McXEUlhwtoxeSkETq5HMtJtY0uulq95tLbcxqmBujTNeXEM
	1UW3CESdF+sBn47W7phlV4LPya+8JJCzHNIyZAlMr0OSAg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lv8AghduxMyN; Fri, 19 Dec 2025 18:39:05 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dXxBk4GZrz1XM6Jc;
	Fri, 19 Dec 2025 18:38:54 +0000 (UTC)
Message-ID: <97e832b7-04a9-49cb-973a-bf9870c21c2f@acm.org>
Date: Fri, 19 Dec 2025 10:38:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/36] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-3-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-3-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D87411C0012
X-Stat-Signature: xji9e5a9wmehq9aiu8x1ce6rsy3egrew
X-Rspam-User: 
X-HE-Tag: 1766169555-23789
X-HE-Meta: U2FsdGVkX1+n/xjlM0CETXGJLqBpvYz7tD+z23yGIZtoXCfE2cnejEgPiG6tLGwktJBHk63xmN9e3qUf6fUFyD+lBnZJEv1fTg8WcqNesHU+bImpT298eMt31jIlSvsjsMYrNpQb3/7sqtqtcxehXKN14z7SgYfXAwgKeCOXS4soBVH4EeWL6xQc2KuWtXe5V6kK2/hihPl/ZikxBWEkjD4A7VSMDd8ZCXqWfGctRCEzB4DpScVQoH3glpvlN3fsT3EDqWwbwakOq0KD+HlVPDng/Zur0eb3HSVci63sTMcqtTH3vO8ErVrJ8wVH1CKDOFM6iuZIoXqmZ5nHtOeD3lv45LMB0j1WLVKO7SYSKpZbDZCV+G87e8wbQtX4XBQ2dG8aO5wnfZxM7e8Jo3qe1zWE92zpjw+R2e3kkXUBVLeNkM8pxSnZdufcm7lsknY7qucRctk5GPIrrRY5QfARZwhQzopKCKWp9f2Snuuel9g8MtAlZppJeZwZRAjUeZZJA8yhLSfqNah6ll8JGnRK5BeYmAd0Ln0RjaDl3jn8bifwzBhwUfiHFTMkHQrRxanZHatxK9wyspVbjKCJeaFUBoOkqb3zer0fjEq5Mbh3V6+BZ9QLTY48DjbV/jH7XlWGlxhMSjMDGQjyQpOF0IJZxdABQgatOTx4vHozmARKu/e+SoU8Ek+3H10g4s/VoSONC99wQNkI5430lBgW+IqjQCs453gR2JABFEJKp6/oMAfitnAa+qEmDYmhwlfHou4uR2DPvZm457T0sZ38n4iGIuYaTTsZBQfz3fd95bmgXRlE+DgQkXRnky1J/JMMACQRZRnZpnfH0TJ5OXhS8g6ro6CoVfSlicbgPo2vqgY1ujgd8yfG0cjXVzpUpklX9705BU0C+auJikYZzwMF0KPFaV2lAs+ALGAZSXiRgVPBVtEoQK7i7Wz1phHMHvYYAbQH59872hbYYplqD5+QGQH
 Im6IfF4r
 Qmf0MFUq5aL1Q7OK6I6nuEZdsIbT98DEky+VKfA7r3jwc+DMSmPDej9CGvb5AvnjAFFRnCeljh7x7dvWJS9iQDrQBP1AoQby7tA9WKqbVMaEkYLd0WCgBKpUmjGUcgxbL8Z7b30SpVSJjBbZjSWnYxrNqo39UKwsdK1Tob/5NeApBFbjb3Bu/Ah09LRQ3yRS5FYxcxv1FXRAXftMtc3NviWCIhF7Abh0DhNbTK2VkP95jLsrlVphSeJ+byDHzGrB7eFso0LSo+ZcQm2cM8DWDw04TuK8xZ9HqMlB0AgTD3SI19vX1QE2L6Mu0E5lrt07+baiaHjlGCmJTlCpZvxZxSdlZRLkbY8uVwSsidU0IuyJcRYhXNOqB7Gl9U9RgQPN2iJ0N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:39 AM, Marco Elver wrote:
> +#if defined(WARN_CONTEXT_ANALYSIS)
> +
> +/*
> + * These attributes define new context lock (Clang: capability) types.
> + * Internal only.
> + */

How can macros be "internal only" that are defined in a header file that
will be included by almost all kernel code? Please consider changing
"internal only" into something that is more clear, e.g. "should only be
used in the macro definitions in this header file".

> +/*
> + * The below are used to annotate code being checked. Internal only.
> + */

Same comment here about "internal only".

> +/**
> + * context_lock_struct() - declare or define a context lock struct
> + * @name: struct name
> + *
> + * Helper to declare or define a struct type that is also a context lock.
> + *
> + * .. code-block:: c
> + *
> + *	context_lock_struct(my_handle) {
> + *		int foo;
> + *		long bar;
> + *	};
> + *
> + *	struct some_state {
> + *		...
> + *	};
> + *	// ... declared elsewhere ...
> + *	context_lock_struct(some_state);
> + *
> + * Note: The implementation defines several helper functions that can acquire
> + * and release the context lock.
> + */
> +# define context_lock_struct(name, ...)									\
> +	struct __ctx_lock_type(name) __VA_ARGS__ name;							\
> +	static __always_inline void __acquire_ctx_lock(const struct name *var)				\
> +		__attribute__((overloadable)) __no_context_analysis __acquires_ctx_lock(var) { }	\
> +	static __always_inline void __acquire_shared_ctx_lock(const struct name *var)			\
> +		__attribute__((overloadable)) __no_context_analysis __acquires_shared_ctx_lock(var) { } \
> +	static __always_inline bool __try_acquire_ctx_lock(const struct name *var, bool ret)		\
> +		__attribute__((overloadable)) __no_context_analysis __try_acquires_ctx_lock(1, var)	\
> +	{ return ret; }											\
> +	static __always_inline bool __try_acquire_shared_ctx_lock(const struct name *var, bool ret)	\
> +		__attribute__((overloadable)) __no_context_analysis __try_acquires_shared_ctx_lock(1, var) \
> +	{ return ret; }											\
> +	static __always_inline void __release_ctx_lock(const struct name *var)				\
> +		__attribute__((overloadable)) __no_context_analysis __releases_ctx_lock(var) { }	\
> +	static __always_inline void __release_shared_ctx_lock(const struct name *var)			\
> +		__attribute__((overloadable)) __no_context_analysis __releases_shared_ctx_lock(var) { } \
> +	static __always_inline void __assume_ctx_lock(const struct name *var)				\
> +		__attribute__((overloadable)) __assumes_ctx_lock(var) { }				\
> +	static __always_inline void __assume_shared_ctx_lock(const struct name *var)			\
> +		__attribute__((overloadable)) __assumes_shared_ctx_lock(var) { }			\
> +	struct name

I'm concerned that the context_lock_struct() macro will make code harder
to read. Anyone who encounters the context_lock_struct() macro will have
to look up its definition to learn what it does. I propose to split this
macro into two macros:
* One macro that expands into "__ctx_lock_type(name)".
* A second macro that expands into the rest of the above macro.

In other words, instead of having to write 
context_lock_struct(struct_name, { ... }); developers will have to write

struct context_lock_type struct_name {
     ...;
};
context_struct_helper_functions(struct_name);

My opinion is that the alternative that I'm proposing is easier to read.
Additionally, it doesn't break existing tools that support jumping from
the name of a struct to its definition, e.g. ctags and etags.

> +config WARN_CONTEXT_ANALYSIS_ALL
> +	bool "Enable context analysis for all source files"
> +	depends on WARN_CONTEXT_ANALYSIS
> +	depends on EXPERT && !COMPILE_TEST
> +	help
> +	  Enable tree-wide context analysis. This is likely to produce a
> +	  large number of false positives - enable at your own risk.
> +
> +	  If unsure, say N.

Why !COMPILE_TEST?

Thanks,

Bart.

