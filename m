Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD79D3E774
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 19:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CABB06B0006; Wed, 10 Dec 2025 14:30:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83CC6B0007; Wed, 10 Dec 2025 14:30:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71BB6B0008; Wed, 10 Dec 2025 14:30:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A55686B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 14:30:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 155AB13B912
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 19:30:18 +0000 (UTC)
X-FDA: 84204552516.16.D2305C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5DC1D20018
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 19:30:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pJrAU1X3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of "SRS0=0X6L=6Q=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=0X6L=6Q=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765395016; a=rsa-sha256;
	cv=none;
	b=dW+T2KncgWLH5tl2MTW+ysDDcx7ehWxh04QOTqeBsBUpbUxrWPmLJR7g8L4DLS70p+Rc6L
	GPuY/94FiqMrSeIgAg+TFOmNftFWdJYu2c2qxK/cTMUZJrY6YGZpx/TQDTbIGcCZTS4lRO
	bNIgTtAJpLYmmh3yi12wAeqA3XqczDM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pJrAU1X3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of "SRS0=0X6L=6Q=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=0X6L=6Q=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765395016;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MgD/MT77kKvzo1IRBH9g0uloGKAYrGS1XSqVo/vq9TE=;
	b=bkUWVJgPB/CwMz1pBrocjDgElJ41umqxeUME7KfnB2oYDHDadLhUlo9H92LjKlP98VwEKr
	6YOmjmqHea8izrnnyytKCc1c0yikLff/Uls6QW6Wd2wKLt0r9eVNs2JhexNtZ/u44Ka/5Z
	giE2Fsehw9jamyppjHaestbwfO324Cg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF32C60053;
	Wed, 10 Dec 2025 19:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34116C4CEF1;
	Wed, 10 Dec 2025 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765395014;
	bh=wKF686z/TTZ0M0cwuNcTeYSd3TG3XU8P9T75njPV6Xk=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=pJrAU1X3dwv9WO/sd8c4TbJnH3ZERsI5Lwa3My/RHkL6gqLQctt28UJ7+Z1rRd8JZ
	 4XeJSVIlLqoRICZl2gN/IoAFAFtcvl+nGhLTOkYmVmHytit/DLzL/guQEXzROMAAiT
	 P6tqNXFYf1AN/PZiR1xTpSwUrS1j1YT0zKg7QvIBNpV24/+zMv3FmjCqUACBmox8j9
	 qFLBrslJvNc5Pt4FFYbmQU2aQzsZoruwJCOVV82lDFlFcIxlDT4YQFr57f8X5LsWKM
	 al3x5A2w+Z1a7nZmJV7hvkIV9SQ0WwA/R1/RCSXHAXSUMdzo5XGGUByxqMF950Jsjk
	 8vGbvPMnwEpVg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id D5BE5CE0C93; Wed, 10 Dec 2025 11:30:11 -0800 (PST)
Date: Wed, 10 Dec 2025 11:30:11 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
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
Subject: Re: [PATCH v4 14/35] rcu: Support Clang's context analysis
Message-ID: <98453e19-7df2-43cb-8f05-87632f360028@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-15-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120151033.3840508-15-elver@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5DC1D20018
X-Stat-Signature: u355csxfoi44y138bpkd4g8qd3hcrx87
X-Rspam-User: 
X-HE-Tag: 1765395016-293246
X-HE-Meta: U2FsdGVkX1/zZ2/if7fLgpigpVpSHOQqmADIGvFUjmYZ6IZhnCtBB2WealGu1riV8DyTxGKer44FZANLI2Kpjs000Su1gaozmUHq0NcUMaqgk7HcFZtw+U9B4Bf4NY+YmhugLOcDEz/cCiD1ImlwgRP40Dj05ZfCzzmXB0fPzb8ZHuv5yT+2gE/4ClxZ1ul7JM3iDKw+SnMdJvfJpqQYomp554BmrCsF0cSLOnfv0KciS2WLw5dAexdHHmExNDIVt88/E+7QqCfaE8/5UjnjGt1qC4V+J/DOM7J7qGCCQlf3Mams9FqfSf3io+2RBeMXuEMqTwWKJYRQ1Skin1kxJQNETi7vBeGCH83tGVGP+h+ASPX30eUKzUANimiFG1HvlTVllKxrhW0ruyCOm+UVfKmm79LjfC/sSLcQVCwsc0JDcvAp7Z4FJUB9OFDbHYgnCesNBxEqZJ/3O7j82m9FM5XNJCKiagZpigVPvV4S/4B3SzMZ74EOSC4ldEvI4QZAZP4Se4KvJwOv9QyiBQ8WqDc+j1zaEYlVbST5Pkp5YHU2Q+X/pdLNYi/MXl1yrHZiqy1dVZPpwmKpgttjdBaFtUq+9U0oXIC+FgAQyat7ydNAiqpwBLkNxKULtJ/I6oYdoFppO/OQFdCcuRt9JibN4L9mZSLs1+hcd4geRkEEDY/+TeB/pVXQ3kQd1C9SyGvk9E0+0ggRA3YkPdYLAQ9GtqyzJQEM9+C2P76OWjPkD1nLBAncqBo1svlDOHfmVqvrT78Wy9ym15Fb7APX/MSKTpZ3qIuDaJpxTaZJzPV0mxE6gWtamQAOUhTIKLg+EEGMl3k0OgOFso/woP3qxLCevmIzM252bOvxpQ3HvUuvm71IWwhbsFjuVppwvn+T5xRR8md3PXX++V518I7HvoYWRPuZR3sHRmXDiWPB4CaDR4fAnJozyOwRSTsG5EUs6zsLlVzJhszC0TkGZ12aAJB
 dwt2WpfA
 7lxK8vb/yyBA95FJtTGt8uj3JxFumnBJVQuDPlrZcNLQD9CngQ3X3k9HyLrmq4OvBbblBbm3GgJGK6xeM3xfw3GbcVi/H6QNMXeLU6kA+GDM9eli1dGo8be0Kbpa+SVJLv8+FiQYbR5hnYf2ZbsucgA/ZvG4LRdcUFHYE2a65fPPyI/EpXgz9UK1K9YONXi5K8uKjpEC17+ymoWurOBagDgrEjbLw7H5zp6DlV3itvtGsj95gV1aiX8SEuNPinpQ61qXml1Fxt3yicxZNOGZf5h2kveysXRwQAJhJJGTwtPrgBYaqGwbPHXuGzin2cwmst3yBoP8Fu07BFqJbExnrcsfhLknWzSqZa1fGSNH4DZ7jQU+jG486Ixi7QS2xmFAxpl9r+4rcIw267mE2czYRMcLV1+0FJC/WmLQC41B5U2vp1K5Go9S/XT/SwRTRV7x5JhhKZEXDO1kNMLY7dPf8+XSEfeuMsP3aotxdw9PgHrOTdVwQWi1AI3XdAPjE2DQzMLHfT3znlHG/+Y9vf2O67GvkJ2kRM8PZehvl3/ZcCRpkWKPusnUfZgwiO4tzbb9D4m7PRTTipfBMJANQ5BHLnwZ2oiuBwsFANmLq/Wl3sOz6h7fynhVgCku3Rxd9XFpVGKdlDn3sm+6y8AMtY8WG+51iBwlkXXgDoeH6lkGxpLXDeRaMHE0z/ISie8sSnE+lWLjiqZ/uDfxlv9Cln7z2+RHh4uFjk/qN+jl5pdFZrBd+FjSe6g4m3+utIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 04:09:39PM +0100, Marco Elver wrote:
> Improve the existing annotations to properly support Clang's context
> analysis.
> 
> The old annotations distinguished between RCU, RCU_BH, and RCU_SCHED;
> however, to more easily be able to express that "hold the RCU read lock"
> without caring if the normal, _bh(), or _sched() variant was used we'd
> have to remove the distinction of the latter variants: change the _bh()
> and _sched() variants to also acquire "RCU".
> 
> When (and if) we introduce context guards to denote more generally that
> "IRQ", "BH", "PREEMPT" contexts are disabled, it would make sense to
> acquire these instead of RCU_BH and RCU_SCHED respectively.
> 
> The above change also simplified introducing __guarded_by support, where
> only the "RCU" context guard needs to be held: introduce __rcu_guarded,
> where Clang's context analysis warns if a pointer is dereferenced
> without any of the RCU locks held, or updated without the appropriate
> helpers.
> 
> The primitives rcu_assign_pointer() and friends are wrapped with
> context_unsafe(), which enforces using them to update RCU-protected
> pointers marked with __rcu_guarded.
> 
> Signed-off-by: Marco Elver <elver@google.com>

Good reminder!  I had lost track of this series.

My big questions here are:

o	What about RCU readers using (say) preempt_disable() instead
	of rcu_read_lock_sched()?

o	What about RCU readers using local_bh_disable() instead of
	rcu_read_lock_sched()?

And keeping in mind that such readers might start in assembly language.

One reasonable approach is to require such readers to use something like
rcu_dereference_all() or rcu_dereference_all_check(), which could then
have special dispensation to instead rely on run-time checks.

Another more powerful approach would be to make this facility also
track preemption, interrupt, NMI, and BH contexts.

Either way could be a significant improvement over what we have now.

Thoughts?

							Thanx, Paul

> ---
> v3:
> * Properly support reentrancy via new compiler support.
> 
> v2:
> * Reword commit message and point out reentrancy caveat.
> ---
>  Documentation/dev-tools/context-analysis.rst |  2 +-
>  include/linux/rcupdate.h                     | 77 ++++++++++++------
>  lib/test_context-analysis.c                  | 85 ++++++++++++++++++++
>  3 files changed, 139 insertions(+), 25 deletions(-)
> 
> diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
> index a3d925ce2df4..05164804a92a 100644
> --- a/Documentation/dev-tools/context-analysis.rst
> +++ b/Documentation/dev-tools/context-analysis.rst
> @@ -81,7 +81,7 @@ Supported Kernel Primitives
>  
>  Currently the following synchronization primitives are supported:
>  `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
> -`bit_spinlock`.
> +`bit_spinlock`, RCU.
>  
>  For context guards with an initialization function (e.g., `spin_lock_init()`),
>  calling this function before initializing any guarded members or globals
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index c5b30054cd01..5cddb9019a99 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -31,6 +31,16 @@
>  #include <asm/processor.h>
>  #include <linux/context_tracking_irq.h>
>  
> +token_context_guard(RCU, __reentrant_ctx_guard);
> +token_context_guard_instance(RCU, RCU_SCHED);
> +token_context_guard_instance(RCU, RCU_BH);
> +
> +/*
> + * A convenience macro that can be used for RCU-protected globals or struct
> + * members; adds type qualifier __rcu, and also enforces __guarded_by(RCU).
> + */
> +#define __rcu_guarded __rcu __guarded_by(RCU)
> +
>  #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
>  #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
>  
> @@ -425,7 +435,8 @@ static inline void rcu_preempt_sleep_check(void) { }
>  
>  // See RCU_LOCKDEP_WARN() for an explanation of the double call to
>  // debug_lockdep_rcu_enabled().
> -static inline bool lockdep_assert_rcu_helper(bool c)
> +static inline bool lockdep_assert_rcu_helper(bool c, const struct __ctx_guard_RCU *ctx)
> +	__assumes_shared_ctx_guard(RCU) __assumes_shared_ctx_guard(ctx)
>  {
>  	return debug_lockdep_rcu_enabled() &&
>  	       (c || !rcu_is_watching() || !rcu_lockdep_current_cpu_online()) &&
> @@ -438,7 +449,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>   * Splats if lockdep is enabled and there is no rcu_read_lock() in effect.
>   */
>  #define lockdep_assert_in_rcu_read_lock() \
> -	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map)))
> +	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map), RCU))
>  
>  /**
>   * lockdep_assert_in_rcu_read_lock_bh - WARN if not protected by rcu_read_lock_bh()
> @@ -448,7 +459,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>   * actual rcu_read_lock_bh() is required.
>   */
>  #define lockdep_assert_in_rcu_read_lock_bh() \
> -	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_bh_lock_map)))
> +	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_bh_lock_map), RCU_BH))
>  
>  /**
>   * lockdep_assert_in_rcu_read_lock_sched - WARN if not protected by rcu_read_lock_sched()
> @@ -458,7 +469,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>   * instead an actual rcu_read_lock_sched() is required.
>   */
>  #define lockdep_assert_in_rcu_read_lock_sched() \
> -	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_sched_lock_map)))
> +	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_sched_lock_map), RCU_SCHED))
>  
>  /**
>   * lockdep_assert_in_rcu_reader - WARN if not within some type of RCU reader
> @@ -476,17 +487,17 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>  	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map) &&			\
>  					       !lock_is_held(&rcu_bh_lock_map) &&		\
>  					       !lock_is_held(&rcu_sched_lock_map) &&		\
> -					       preemptible()))
> +					       preemptible(), RCU))
>  
>  #else /* #ifdef CONFIG_PROVE_RCU */
>  
>  #define RCU_LOCKDEP_WARN(c, s) do { } while (0 && (c))
>  #define rcu_sleep_check() do { } while (0)
>  
> -#define lockdep_assert_in_rcu_read_lock() do { } while (0)
> -#define lockdep_assert_in_rcu_read_lock_bh() do { } while (0)
> -#define lockdep_assert_in_rcu_read_lock_sched() do { } while (0)
> -#define lockdep_assert_in_rcu_reader() do { } while (0)
> +#define lockdep_assert_in_rcu_read_lock() __assume_shared_ctx_guard(RCU)
> +#define lockdep_assert_in_rcu_read_lock_bh() __assume_shared_ctx_guard(RCU_BH)
> +#define lockdep_assert_in_rcu_read_lock_sched() __assume_shared_ctx_guard(RCU_SCHED)
> +#define lockdep_assert_in_rcu_reader() __assume_shared_ctx_guard(RCU)
>  
>  #endif /* #else #ifdef CONFIG_PROVE_RCU */
>  
> @@ -506,11 +517,11 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>  #endif /* #else #ifdef __CHECKER__ */
>  
>  #define __unrcu_pointer(p, local)					\
> -({									\
> +context_unsafe(								\
>  	typeof(*p) *local = (typeof(*p) *__force)(p);			\
>  	rcu_check_sparse(p, __rcu);					\
> -	((typeof(*p) __force __kernel *)(local)); 			\
> -})
> +	((typeof(*p) __force __kernel *)(local)) 			\
> +)
>  /**
>   * unrcu_pointer - mark a pointer as not being RCU protected
>   * @p: pointer needing to lose its __rcu property
> @@ -586,7 +597,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>   * other macros that it invokes.
>   */
>  #define rcu_assign_pointer(p, v)					      \
> -do {									      \
> +context_unsafe(							      \
>  	uintptr_t _r_a_p__v = (uintptr_t)(v);				      \
>  	rcu_check_sparse(p, __rcu);					      \
>  									      \
> @@ -594,7 +605,7 @@ do {									      \
>  		WRITE_ONCE((p), (typeof(p))(_r_a_p__v));		      \
>  	else								      \
>  		smp_store_release(&p, RCU_INITIALIZER((typeof(p))_r_a_p__v)); \
> -} while (0)
> +)
>  
>  /**
>   * rcu_replace_pointer() - replace an RCU pointer, returning its old value
> @@ -861,9 +872,10 @@ do {									      \
>   * only when acquiring spinlocks that are subject to priority inheritance.
>   */
>  static __always_inline void rcu_read_lock(void)
> +	__acquires_shared(RCU)
>  {
>  	__rcu_read_lock();
> -	__acquire(RCU);
> +	__acquire_shared(RCU);
>  	rcu_lock_acquire(&rcu_lock_map);
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_lock() used illegally while idle");
> @@ -891,11 +903,12 @@ static __always_inline void rcu_read_lock(void)
>   * See rcu_read_lock() for more information.
>   */
>  static inline void rcu_read_unlock(void)
> +	__releases_shared(RCU)
>  {
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_unlock() used illegally while idle");
>  	rcu_lock_release(&rcu_lock_map); /* Keep acq info for rls diags. */
> -	__release(RCU);
> +	__release_shared(RCU);
>  	__rcu_read_unlock();
>  }
>  
> @@ -914,9 +927,11 @@ static inline void rcu_read_unlock(void)
>   * was invoked from some other task.
>   */
>  static inline void rcu_read_lock_bh(void)
> +	__acquires_shared(RCU) __acquires_shared(RCU_BH)
>  {
>  	local_bh_disable();
> -	__acquire(RCU_BH);
> +	__acquire_shared(RCU);
> +	__acquire_shared(RCU_BH);
>  	rcu_lock_acquire(&rcu_bh_lock_map);
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_lock_bh() used illegally while idle");
> @@ -928,11 +943,13 @@ static inline void rcu_read_lock_bh(void)
>   * See rcu_read_lock_bh() for more information.
>   */
>  static inline void rcu_read_unlock_bh(void)
> +	__releases_shared(RCU) __releases_shared(RCU_BH)
>  {
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_unlock_bh() used illegally while idle");
>  	rcu_lock_release(&rcu_bh_lock_map);
> -	__release(RCU_BH);
> +	__release_shared(RCU_BH);
> +	__release_shared(RCU);
>  	local_bh_enable();
>  }
>  
> @@ -952,9 +969,11 @@ static inline void rcu_read_unlock_bh(void)
>   * rcu_read_lock_sched() was invoked from an NMI handler.
>   */
>  static inline void rcu_read_lock_sched(void)
> +	__acquires_shared(RCU) __acquires_shared(RCU_SCHED)
>  {
>  	preempt_disable();
> -	__acquire(RCU_SCHED);
> +	__acquire_shared(RCU);
> +	__acquire_shared(RCU_SCHED);
>  	rcu_lock_acquire(&rcu_sched_lock_map);
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_lock_sched() used illegally while idle");
> @@ -962,9 +981,11 @@ static inline void rcu_read_lock_sched(void)
>  
>  /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
>  static inline notrace void rcu_read_lock_sched_notrace(void)
> +	__acquires_shared(RCU) __acquires_shared(RCU_SCHED)
>  {
>  	preempt_disable_notrace();
> -	__acquire(RCU_SCHED);
> +	__acquire_shared(RCU);
> +	__acquire_shared(RCU_SCHED);
>  }
>  
>  /**
> @@ -973,22 +994,27 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
>   * See rcu_read_lock_sched() for more information.
>   */
>  static inline void rcu_read_unlock_sched(void)
> +	__releases_shared(RCU) __releases_shared(RCU_SCHED)
>  {
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_unlock_sched() used illegally while idle");
>  	rcu_lock_release(&rcu_sched_lock_map);
> -	__release(RCU_SCHED);
> +	__release_shared(RCU_SCHED);
> +	__release_shared(RCU);
>  	preempt_enable();
>  }
>  
>  /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
>  static inline notrace void rcu_read_unlock_sched_notrace(void)
> +	__releases_shared(RCU) __releases_shared(RCU_SCHED)
>  {
> -	__release(RCU_SCHED);
> +	__release_shared(RCU_SCHED);
> +	__release_shared(RCU);
>  	preempt_enable_notrace();
>  }
>  
>  static __always_inline void rcu_read_lock_dont_migrate(void)
> +	__acquires_shared(RCU)
>  {
>  	if (IS_ENABLED(CONFIG_PREEMPT_RCU))
>  		migrate_disable();
> @@ -996,6 +1022,7 @@ static __always_inline void rcu_read_lock_dont_migrate(void)
>  }
>  
>  static inline void rcu_read_unlock_migrate(void)
> +	__releases_shared(RCU)
>  {
>  	rcu_read_unlock();
>  	if (IS_ENABLED(CONFIG_PREEMPT_RCU))
> @@ -1041,10 +1068,10 @@ static inline void rcu_read_unlock_migrate(void)
>   * ordering guarantees for either the CPU or the compiler.
>   */
>  #define RCU_INIT_POINTER(p, v) \
> -	do { \
> +	context_unsafe( \
>  		rcu_check_sparse(p, __rcu); \
>  		WRITE_ONCE(p, RCU_INITIALIZER(v)); \
> -	} while (0)
> +	)
>  
>  /**
>   * RCU_POINTER_INITIALIZER() - statically initialize an RCU protected pointer
> @@ -1206,4 +1233,6 @@ DEFINE_LOCK_GUARD_0(rcu,
>  	} while (0),
>  	rcu_read_unlock())
>  
> +DECLARE_LOCK_GUARD_0_ATTRS(rcu, __acquires_shared(RCU), __releases_shared(RCU))
> +
>  #endif /* __LINUX_RCUPDATE_H */
> diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
> index 77e599a9281b..f18b7252646d 100644
> --- a/lib/test_context-analysis.c
> +++ b/lib/test_context-analysis.c
> @@ -7,6 +7,7 @@
>  #include <linux/bit_spinlock.h>
>  #include <linux/build_bug.h>
>  #include <linux/mutex.h>
> +#include <linux/rcupdate.h>
>  #include <linux/seqlock.h>
>  #include <linux/spinlock.h>
>  
> @@ -277,3 +278,87 @@ static void __used test_bit_spin_lock(struct test_bit_spinlock_data *d)
>  		bit_spin_unlock(3, &d->bits);
>  	}
>  }
> +
> +/*
> + * Test that we can mark a variable guarded by RCU, and we can dereference and
> + * write to the pointer with RCU's primitives.
> + */
> +struct test_rcu_data {
> +	long __rcu_guarded *data;
> +};
> +
> +static void __used test_rcu_guarded_reader(struct test_rcu_data *d)
> +{
> +	rcu_read_lock();
> +	(void)rcu_dereference(d->data);
> +	rcu_read_unlock();
> +
> +	rcu_read_lock_bh();
> +	(void)rcu_dereference(d->data);
> +	rcu_read_unlock_bh();
> +
> +	rcu_read_lock_sched();
> +	(void)rcu_dereference(d->data);
> +	rcu_read_unlock_sched();
> +}
> +
> +static void __used test_rcu_guard(struct test_rcu_data *d)
> +{
> +	guard(rcu)();
> +	(void)rcu_dereference(d->data);
> +}
> +
> +static void __used test_rcu_guarded_updater(struct test_rcu_data *d)
> +{
> +	rcu_assign_pointer(d->data, NULL);
> +	RCU_INIT_POINTER(d->data, NULL);
> +	(void)unrcu_pointer(d->data);
> +}
> +
> +static void wants_rcu_held(void)	__must_hold_shared(RCU)       { }
> +static void wants_rcu_held_bh(void)	__must_hold_shared(RCU_BH)    { }
> +static void wants_rcu_held_sched(void)	__must_hold_shared(RCU_SCHED) { }
> +
> +static void __used test_rcu_lock_variants(void)
> +{
> +	rcu_read_lock();
> +	wants_rcu_held();
> +	rcu_read_unlock();
> +
> +	rcu_read_lock_bh();
> +	wants_rcu_held_bh();
> +	rcu_read_unlock_bh();
> +
> +	rcu_read_lock_sched();
> +	wants_rcu_held_sched();
> +	rcu_read_unlock_sched();
> +}
> +
> +static void __used test_rcu_lock_reentrant(void)
> +{
> +	rcu_read_lock();
> +	rcu_read_lock();
> +	rcu_read_lock_bh();
> +	rcu_read_lock_bh();
> +	rcu_read_lock_sched();
> +	rcu_read_lock_sched();
> +
> +	rcu_read_unlock_sched();
> +	rcu_read_unlock_sched();
> +	rcu_read_unlock_bh();
> +	rcu_read_unlock_bh();
> +	rcu_read_unlock();
> +	rcu_read_unlock();
> +}
> +
> +static void __used test_rcu_assert_variants(void)
> +{
> +	lockdep_assert_in_rcu_read_lock();
> +	wants_rcu_held();
> +
> +	lockdep_assert_in_rcu_read_lock_bh();
> +	wants_rcu_held_bh();
> +
> +	lockdep_assert_in_rcu_read_lock_sched();
> +	wants_rcu_held_sched();
> +}
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

