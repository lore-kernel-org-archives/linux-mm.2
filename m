Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A77F9D0FB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 23:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6910B6B0088; Tue, 14 Apr 2026 19:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61BCA6B0089; Tue, 14 Apr 2026 19:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E27E6B0092; Tue, 14 Apr 2026 19:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0C16B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:20:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA75DB7B33
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:20:30 +0000 (UTC)
X-FDA: 84658732620.24.76964F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2326212000F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:20:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dr1H9aPW;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776208829;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgmdXSX7ZdMBUy/JpB7d64z9wvsndv2TobjtqzEocD8=;
	b=Ld6bobGzSS52URQxXjJO7xdcl5ezEoQU7bOaJUDKc5HvRjAY6u8ohBiSQ0Z4bKNos9CiKR
	XBeioH1fqEOcVrF3HGmTOZfunDD1CkGSztwBg0f4VOav4yA/0R6hzeiZdDZU1mMchOY6rD
	W7kF637cl6Tq/STev3Vuzwd6kgF5fDo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776208829; a=rsa-sha256;
	cv=none;
	b=BdiKV2S9+c8D9lb2rkxfivsGcQ5AiUn/6cwTbxuQkCiZhpOq1iHkLquJ0pcGcKm/cBKg2p
	N6cD6yBF978kP3RoGxVq9Y6kw5cxEpGy2Bl+ay/fvQ1z4ijiH9HL6lwdhDzvA5bvV7kZG8
	5676o2ROU3aUmlpMfT8y6bjzscP/kms=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dr1H9aPW;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B7B49600AE;
	Tue, 14 Apr 2026 23:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A8AC19425;
	Tue, 14 Apr 2026 23:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776208827;
	bh=hKC8Rq5NfJNZWW7OdEl3J1osacHazL7oouQZKOMFRnM=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=Dr1H9aPWj8lP+ZM1jtp+jHMcbG37rN6rK6GTAbADb7vRIrIUZcg/cFXZIMoDEgMuB
	 22O5uanPHclLc5ci5ycIRepqK4T1IUjYD110E4S88wp19FND3ZEcXDKNPJALRjNX3f
	 ZU3oQMGHqaRnymhESqVuhgS1xd6nbP5RxFf25yRDyPhd193/F7LUp2q2g3C8OVzJuD
	 T87eAtW28GXdVtUnzm4++bOL/fk/kz+ccBGv5sncSZzIQpW0xxffWjD6Z3eM5F3YkJ
	 nk73mP07aE+kCNZP11DJnXLomg87Yd3/ZPa5ouxuAimKxZaz434j/8wRZGu4equQnR
	 spGbw0Uru4ykA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id C71C8CE13BF; Tue, 14 Apr 2026 16:20:26 -0700 (PDT)
Date: Tue, 14 Apr 2026 16:20:26 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 5/5] locking: Add contended_release tracepoint to
 spinning locks
Message-ID: <8d98d9f4-ccab-4864-b406-d3eb684cab45@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <cover.1774536681.git.d@ilvokhin.com>
 <81eb8e0cd90b31e761e12721dbacb967281f840f.1774536681.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81eb8e0cd90b31e761e12721dbacb967281f840f.1774536681.git.d@ilvokhin.com>
X-Rspamd-Queue-Id: 2326212000F
X-Stat-Signature: y5jzt5krq1ntnqscqhd7qj86en58cx6u
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776208828-393928
X-HE-Meta: U2FsdGVkX18jMSTOcAp1dg4PgVFbc1Z9td6jH1xEmXY3eY7IFplqVzb7sWGHMsNFDhqR2hGS8sRnAeOwE43Vc/asSMCmA928VcrHbw/NoimXHTP+5v4RpFAs3SI0gFngn2ZUJljT7Xj1UtiMyplFPXQdM5F9QqRYdUd6PceKcs6LWqZZLra02D5JDa2qk0UoVtz+7KoMfz+biBI6P5+IQD/zgMtSMTxu4oRJdMcqrZSPWA3c/WlbA+9pJV/fwKJVsIJnrRhcVQhJ65/El5QcJT2Q0dwAofpslCx/m8+Uwj+FOMqHtnBi69lDCuQKuwTPzM067flqdb9afe1QU3Fth9JJIMeD1s6HN3Oe282EVsvrbUpuV5t1Q3I4BqL5p7e6XPrMLdPZYnBXVH43b9izmzMFtBmIpnHs7Rqqms0PfTjWNgRx3PsY7YEuwl9kUfAp6L/Es14p2WWAx77Yk2d4NMuxnidx9ogukj1ThP6qK8Ux/5wjT20wizt8OX4lxu29yNQjHajjzc1XfJ/n3Svl4HsaJlZC3tQ6tlXl3PD2QCWSHbmyscvDWMpWVJHoL5RnUE7zYKPg2wCqSoyMVoI3XkyW6L/jsPeTcvkZ+y0Gh2HU3gyJzkr7FWe1BUFUXx/2G2tWC9451//tlg1obikgoH2dY9Y03u4yoHfAXhdS6BCW7d1FezIvb3Wx1scE0adAyJot4DYQ9BRJyOH4/rh0F2104aPMG8gnSFu0AeXOTBuaIDUlUOU/sOZ9ewGWXRDAz7kRqZwXJSuWsZx4ydRBxQUtqiPIFLwMEONCyE7EQchvqYRVVcdmROqGr46lluaZzv3Bl88QAsRkY1TLq/oqwWc1c4/XpjEGB0BUN3Eo7AKRcVBu12FN3Bc4omDXyUUmUQDlXSAwKY5EdOAx4+clZ4KrwsxG7SWMkqW4MZAbw1xtqvVMza1TEk4hPYf4zbW6GkcvY9GAyV5qhjRV+id
 lUnJ+G1t
 SG/c37QkCI7OOhrnt0+Dhzmp22JOuv1Bp5J872LhsVei1zuJRuwgUsbU92f5jENuU36RXKhuMWEzHVpakngmXR4/Cjvg0DVXXVydjJ9BufzR0WUvZYJ8b3aS97RyPKXEoBOflRAeEhYpC38U12no+Nuo9PpECBFLRKir1r+pRwqFjsWx3fRhM/KbJD58RV+fKbEshXlKt+Jm6+MUnXNihI+svYFqIIFrfMODVe6AnGSxa55MjjJNEXZu3GDeG0s8tvcYfRtma0QZPdLIF7bR9JHW9zU+kUIYfrZmk4kX4yKzCNJMBbC0ATY7PpDnBhXqB6mcmaDyK9u1kuiqXSNTElfi+NhD37+fdThsjnL2JBRCR3vaNZS+oGpXpNI6orYvcf9r6IaJKi+WxeD0wbxbKXktustzAJg36FTXwEpQHVaL8f9zQZwZako8tUvvJwh48GGbMQGTmOsimhsr3yAwqDQWY1umoacsDwGmTv4mWZhQ3RbphTxDf4Iu3RV9G90aaA99PkTodEfXoaC3x8clryKCyMis2HBDOFZx3lwr5SWJfLWFml4MubU0Ja/uQTNj07rMKzzHniOMrul1jDW3k5Ak9uXJ6DRnZ2aJJRT6SQrNmJDBe656C89d/45tIBBh12a1H4ymohutYIojko3Zx2BnCobVGuEqFds8mMJQnwmGkHNH04/bG426ogtWxllDB0x8eMqvi8BIYisz+EURYCOlCvnMed57yVtfnp7hh3/EmlvBB5n2xspziaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:10:04PM +0000, Dmitry Ilvokhin wrote:
> Extend the contended_release tracepoint to queued spinlocks and queued
> rwlocks.
> 
> Use the arch-overridable queued_spin_release(), introduced in the
> previous commit, to ensure the tracepoint works correctly across all
> architectures, including those with custom unlock implementations (e.g.
> x86 paravirt).
> 
> When the tracepoint is disabled, the only addition to the hot path is a
> single NOP instruction (the static branch). When enabled, the contention
> check, trace call, and unlock are combined in an out-of-line function to
> minimize hot path impact, avoiding the compiler needing to preserve the
> lock pointer in a callee-saved register across the trace call.
> 
> Binary size impact (x86_64, defconfig):
>   uninlined unlock (common case): +983 bytes  (+0.00%)
>   inlined unlock (worst case):    +58165 bytes (+0.24%)
> 
> The inlined unlock case could not be achieved through Kconfig options on
> x86_64 as PREEMPT_BUILD unconditionally selects UNINLINE_SPIN_UNLOCK on
> x86_64. The UNINLINE_SPIN_UNLOCK guards were manually inverted to force
> inline the unlock path and estimate the worst case binary size increase.
> 
> Architectures with fully custom qspinlock implementations (e.g.
> PowerPC) are not covered by this change.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  include/asm-generic/qrwlock.h   | 48 +++++++++++++++++++++++++++------
>  include/asm-generic/qspinlock.h | 18 +++++++++++++
>  kernel/locking/qrwlock.c        | 16 +++++++++++
>  kernel/locking/qspinlock.c      |  8 ++++++
>  4 files changed, 82 insertions(+), 8 deletions(-)
> 
> diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
> index 75b8f4601b28..e24dc537fd66 100644
> --- a/include/asm-generic/qrwlock.h
> +++ b/include/asm-generic/qrwlock.h
> @@ -14,6 +14,7 @@
>  #define __ASM_GENERIC_QRWLOCK_H
>  
>  #include <linux/atomic.h>
> +#include <linux/tracepoint-defs.h>
>  #include <asm/barrier.h>
>  #include <asm/processor.h>
>  
> @@ -35,6 +36,10 @@
>   */
>  extern void queued_read_lock_slowpath(struct qrwlock *lock);
>  extern void queued_write_lock_slowpath(struct qrwlock *lock);
> +extern void queued_read_unlock_traced(struct qrwlock *lock);
> +extern void queued_write_unlock_traced(struct qrwlock *lock);
> +
> +DECLARE_TRACEPOINT(contended_release);
>  
>  /**
>   * queued_read_trylock - try to acquire read lock of a queued rwlock
> @@ -102,10 +107,16 @@ static inline void queued_write_lock(struct qrwlock *lock)
>  }
>  
>  /**
> - * queued_read_unlock - release read lock of a queued rwlock
> + * queued_rwlock_is_contended - check if the lock is contended
>   * @lock : Pointer to queued rwlock structure
> + * Return: 1 if lock contended, 0 otherwise
>   */
> -static inline void queued_read_unlock(struct qrwlock *lock)
> +static inline int queued_rwlock_is_contended(struct qrwlock *lock)
> +{
> +	return arch_spin_is_locked(&lock->wait_lock);
> +}
> +
> +static __always_inline void __queued_read_unlock(struct qrwlock *lock)
>  {
>  	/*
>  	 * Atomically decrement the reader count
> @@ -114,22 +125,43 @@ static inline void queued_read_unlock(struct qrwlock *lock)
>  }
>  
>  /**
> - * queued_write_unlock - release write lock of a queued rwlock
> + * queued_read_unlock - release read lock of a queued rwlock
>   * @lock : Pointer to queued rwlock structure
>   */
> -static inline void queued_write_unlock(struct qrwlock *lock)
> +static inline void queued_read_unlock(struct qrwlock *lock)
> +{
> +	/*
> +	 * Trace and unlock are combined in the traced unlock variant so
> +	 * the compiler does not need to preserve the lock pointer across
> +	 * the function call, avoiding callee-saved register save/restore
> +	 * on the hot path.
> +	 */
> +	if (tracepoint_enabled(contended_release)) {
> +		queued_read_unlock_traced(lock);
> +		return;
> +	}
> +
> +	__queued_read_unlock(lock);
> +}

Shouldn't this refactoring be its own separate patch, similar to 4/5?

That would probably clean up this diff a bit.

> +
> +static __always_inline void __queued_write_unlock(struct qrwlock *lock)
>  {
>  	smp_store_release(&lock->wlocked, 0);
>  }
>  
>  /**
> - * queued_rwlock_is_contended - check if the lock is contended
> + * queued_write_unlock - release write lock of a queued rwlock
>   * @lock : Pointer to queued rwlock structure
> - * Return: 1 if lock contended, 0 otherwise
>   */
> -static inline int queued_rwlock_is_contended(struct qrwlock *lock)
> +static inline void queued_write_unlock(struct qrwlock *lock)
>  {
> -	return arch_spin_is_locked(&lock->wait_lock);
> +	/* See comment in queued_read_unlock(). */
> +	if (tracepoint_enabled(contended_release)) {
> +		queued_write_unlock_traced(lock);
> +		return;
> +	}
> +
> +	__queued_write_unlock(lock);

And the same here, so one patch for interposing __queued_read_unlock()
and another for interposing __queued_write_unlock().

>  }
>  
>  /*
> diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
> index df76f34645a0..915a4c2777f6 100644
> --- a/include/asm-generic/qspinlock.h
> +++ b/include/asm-generic/qspinlock.h
> @@ -41,6 +41,7 @@
>  
>  #include <asm-generic/qspinlock_types.h>
>  #include <linux/atomic.h>
> +#include <linux/tracepoint-defs.h>
>  
>  #ifndef queued_spin_is_locked
>  /**
> @@ -129,12 +130,29 @@ static __always_inline void queued_spin_release(struct qspinlock *lock)
>  }
>  #endif
>  
> +DECLARE_TRACEPOINT(contended_release);
> +
> +extern void queued_spin_release_traced(struct qspinlock *lock);
> +
>  /**
>   * queued_spin_unlock - unlock a queued spinlock
>   * @lock : Pointer to queued spinlock structure
> + *
> + * Generic tracing wrapper around the arch-overridable
> + * queued_spin_release().
>   */
>  static __always_inline void queued_spin_unlock(struct qspinlock *lock)
>  {
> +	/*
> +	 * Trace and release are combined in queued_spin_release_traced() so
> +	 * the compiler does not need to preserve the lock pointer across the
> +	 * function call, avoiding callee-saved register save/restore on the
> +	 * hot path.
> +	 */
> +	if (tracepoint_enabled(contended_release)) {
> +		queued_spin_release_traced(lock);
> +		return;
> +	}
>  	queued_spin_release(lock);
>  }
>  
> diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> index d2ef312a8611..5f7a0fc2b27a 100644
> --- a/kernel/locking/qrwlock.c
> +++ b/kernel/locking/qrwlock.c

And is it possible to have one patch for qspinlock and another for qrwlock?
It *looks* like it should be.

							Thanx, Paul

> @@ -90,3 +90,19 @@ void __lockfunc queued_write_lock_slowpath(struct qrwlock *lock)
>  	trace_contention_end(lock, 0);
>  }
>  EXPORT_SYMBOL(queued_write_lock_slowpath);
> +
> +void __lockfunc queued_read_unlock_traced(struct qrwlock *lock)
> +{
> +	if (queued_rwlock_is_contended(lock))
> +		trace_contended_release(lock);
> +	__queued_read_unlock(lock);
> +}
> +EXPORT_SYMBOL(queued_read_unlock_traced);
> +
> +void __lockfunc queued_write_unlock_traced(struct qrwlock *lock)
> +{
> +	if (queued_rwlock_is_contended(lock))
> +		trace_contended_release(lock);
> +	__queued_write_unlock(lock);
> +}
> +EXPORT_SYMBOL(queued_write_unlock_traced);
> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> index af8d122bb649..c72610980ec7 100644
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -104,6 +104,14 @@ static __always_inline u32  __pv_wait_head_or_lock(struct qspinlock *lock,
>  #define queued_spin_lock_slowpath	native_queued_spin_lock_slowpath
>  #endif
>  
> +void __lockfunc queued_spin_release_traced(struct qspinlock *lock)
> +{
> +	if (queued_spin_is_contended(lock))
> +		trace_contended_release(lock);
> +	queued_spin_release(lock);
> +}
> +EXPORT_SYMBOL(queued_spin_release_traced);
> +
>  #endif /* _GEN_PV_LOCK_SLOWPATH */
>  
>  /**
> -- 
> 2.52.0
> 

