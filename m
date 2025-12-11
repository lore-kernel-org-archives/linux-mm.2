Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91330D41C1F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 12:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFABF6B0005; Thu, 11 Dec 2025 07:04:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAC446B0007; Thu, 11 Dec 2025 07:04:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9AC86B0008; Thu, 11 Dec 2025 07:04:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7DB46B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:04:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9338B13534B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:04:53 +0000 (UTC)
X-FDA: 84207058866.17.0101EC7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id A62A120015
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:04:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Cm3yzuQq;
	spf=none (imf03.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765454692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5QYsGE2XyUV8dMJUaGHOZ/s846nES10yHj06SSwiHE=;
	b=4aucdVEBfT9YgJzVmqlcp558UJ5KrXQffGSiLwdm3L4uSCLUP9WcYK4WO+ur3t8QD91IAN
	ufQP62/2IraTXoIg94pct0bGyDDMNOkZYFETcCtUCx99IpIHpaus+xS/parbsLRERZ6mny
	CJMjKxgD6+u/cXuIlHgxyzxBxOnUOEw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765454692; a=rsa-sha256;
	cv=none;
	b=vV+5WYQGy+my3Zkzap5OwSRvoEtR1ToTdHWFppK0tlI/aO9ykLK52tO8Za87OuceOEKqZF
	dNOk7a8yJ5ivCLkG//28o7BZov4rq5qlUXxVlKSt/L4cTIQFscXxNzT11Ttl8fOdZQMSQC
	Je1JFQ1dXaTVZddZLnhuFliwnDzXE9U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Cm3yzuQq;
	spf=none (imf03.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J5QYsGE2XyUV8dMJUaGHOZ/s846nES10yHj06SSwiHE=; b=Cm3yzuQqYooIj2GZtZDWYEC3ZO
	S0fg9hzc4Z19Hv5Bc4P16q2CjNQ573CovUIuUpZEbXu9poIjw8goKrUxsrAu3j7Caix5SEmi3eHJ5
	ty2o3ZeXS3kqUORWQHfUhEXRPllWuKhXfU6FuRy+jNCn3CPiuhwnM6hD6rLf9Bd5pxh4A4qnGsqmd
	YA26rLCiywQY1V7BWRwKwRpg85biCy2lzMbTYkXrqgHkp9M0BmSuJ+nlBxwZvhjzGyyfDW1rDJahM
	onQMIaTpJMWn2CJQspzPC2bN0ZBuwOi8vBCFsSztBk6L098HJ6Am/lBaLXUiYdMTHDu2proPsv+AW
	SRG+MwEw==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTfPW-0000000ECYb-0fah;
	Thu, 11 Dec 2025 12:04:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 803F130301A; Thu, 11 Dec 2025 13:04:41 +0100 (CET)
Date: Thu, 11 Dec 2025 13:04:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v4 02/35] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
Message-ID: <20251211120441.GG3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120145835.3833031-4-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120145835.3833031-4-elver@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A62A120015
X-Stat-Signature: yuq9uedaebhrnhwr7idoz74ya31oubp9
X-Rspam-User: 
X-HE-Tag: 1765454691-772441
X-HE-Meta: U2FsdGVkX191ZygAA5eqewkdwj1+rkDhfl5w3G6csYkRUR8xZahNrDF0EcIRE9pcV87ufu7TPf+FDQPkkI2oXwq56+GthkIFgv13/O0yY2um/IKMFPc+6NjsTWJP06qEHDIjBHOFSQTBbvPnzAtoasN7XbOPqGM3kwI3ji+fOE5AqdFFcmVpU8GspHX6CdAvjeeFk7ELHmFXnUm7Z9MLiEjE8z8G/8beXjbvsqY3PSWQiCpqPMBTiHvZcqZ+UsrX7wqYOjA9gKmgReCIPyGD/Ie3H8CXqVPSM84ryDjcUdYi3cxHL8rmWoyU043y24FRIF6n3zPg4/p1VXlxy6uz87aPAtKBTJn85dk9tF4ED6gNmnZtnzg7RnLUT0HctcsXOuPaAyrbh2PccpfE5X8JRj1HlS4wlK4pktFRjnptQ6kR0DxlbePJ1I5s4mjCd2psWW21ZORWpwfEYBkmAMP4XpxHEfbV28IgCWUW1w7qcunJ4lCxUsr9Ptzp7GCTXfWEPiHYza0GZs6wyqaNqg8fUtdvA4Dmc4Mb/SbJJypHWPYYH+omjNgXPRfXFT+0aeSJSjrK12NxqcyGMVFNXS/Efi2vtfWrJ9Jxv3yYABOrcFuF54ZwifilVkJrT8XiRjSRU2Ccvv/WF371f/to2Dm74LiVMNCtSAEoJJ6wHUSyaI745R/5T2JeXapiKXqb9tdDwS1dyeh6/Sg4d16H3dHz4iBI1VUrPoD6c2avBfZxwfP6bSe/utsT9JHRSSqI5K0XkFcdtQYm5TGS4czV/MO3d5652b7cw2CiIzdobQfi7dC55v9D+476pPsok7AAavjI2/eLGICIyPJfEjUSCiIpBYGfuzhonOGJ6buOFw0o5a1vR+ElVg690+hnBe2DBKchlIoj/aB+WuH0fyQ/2plMSj3s9jW92l9vCYcM5KLOS84aUwBqrzMvQphWtk+7ZRIia8qj5/A5aDGF4nRFfgZ
 MOvsjV5v
 F75vOSn/XNBEeNoTpXJTFh3PSp8uirJHwQls/fvG+4OfB3hsvhABlDou7/3Fj1r3rYwyu40aV7F7uIAPjbrtpeanv/xJfETKGXH9ifd3xkuQEtdVwnEE4dX3FBtibNz7JJy4gQ5kxn33/fot8rCXl1Tx0HEmn8/ojomQYlS9hm3JDhenmhjixwLMJtJdHQWy105UVpnTMzcPDisH/JcjxzefbjmU0ZyQQOO70yU8AEI6rH051T2tIITMrdZLsIe0hZXqjNuiLWeJnXH3x6/u4c3123VOG8bjlLMf4iSLFti8+HcXm23tqGUrufQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 03:49:04PM +0100, Marco Elver wrote:

> +/**
> + * context_guard_struct() - declare or define a context guard struct
> + * @name: struct name
> + *
> + * Helper to declare or define a struct type that is also a context guard.
> + *
> + * .. code-block:: c
> + *
> + *	context_guard_struct(my_handle) {
> + *		int foo;
> + *		long bar;
> + *	};
> + *
> + *	struct some_state {
> + *		...
> + *	};
> + *	// ... declared elsewhere ...
> + *	context_guard_struct(some_state);
> + *
> + * Note: The implementation defines several helper functions that can acquire
> + * and release the context guard.
> + */
> +# define context_guard_struct(name, ...)								\
> +	struct __ctx_guard_type(name) __VA_ARGS__ name;							\
> +	static __always_inline void __acquire_ctx_guard(const struct name *var)				\
> +		__attribute__((overloadable)) __no_context_analysis __acquires_ctx_guard(var) { }	\
> +	static __always_inline void __acquire_shared_ctx_guard(const struct name *var)			\
> +		__attribute__((overloadable)) __no_context_analysis __acquires_shared_ctx_guard(var) { } \
> +	static __always_inline bool __try_acquire_ctx_guard(const struct name *var, bool ret)		\
> +		__attribute__((overloadable)) __no_context_analysis __try_acquires_ctx_guard(1, var)	\
> +	{ return ret; }											\
> +	static __always_inline bool __try_acquire_shared_ctx_guard(const struct name *var, bool ret)	\
> +		__attribute__((overloadable)) __no_context_analysis __try_acquires_shared_ctx_guard(1, var) \
> +	{ return ret; }											\
> +	static __always_inline void __release_ctx_guard(const struct name *var)				\
> +		__attribute__((overloadable)) __no_context_analysis __releases_ctx_guard(var) { }	\
> +	static __always_inline void __release_shared_ctx_guard(const struct name *var)			\
> +		__attribute__((overloadable)) __no_context_analysis __releases_shared_ctx_guard(var) { } \
> +	static __always_inline void __assume_ctx_guard(const struct name *var)				\
> +		__attribute__((overloadable)) __assumes_ctx_guard(var) { }				\
> +	static __always_inline void __assume_shared_ctx_guard(const struct name *var)			\
> +		__attribute__((overloadable)) __assumes_shared_ctx_guard(var) { }			\
> +	struct name

-typedef struct {
+context_guard_struct(rwlock) {
        struct rwbase_rt        rwbase;
        atomic_t                readers;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
        struct lockdep_map      dep_map;
 #endif
-} rwlock_t;
+};
+typedef struct rwlock rwlock_t;


I must say I find the 'guard' naming here somewhat confusing. This is
not a guard, but an actual lock type.

