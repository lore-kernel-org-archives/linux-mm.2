Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4515ECD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA2C6B00D7; Wed, 13 May 2026 11:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81516B00D9; Wed, 13 May 2026 11:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996EF6B00DA; Wed, 13 May 2026 11:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88B8D6B00D7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:41:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 545CE1C0098
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:41:10 +0000 (UTC)
X-FDA: 84762810300.18.A9D0C91
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id 942B21C0012
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:41:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AFJsoUWe8PTW7NkEqBuFHnsqp6la1vOEPHunHY/Ko4Q=;
	b=8DR773DwcQ20sIIx2MPzJcCzcERHGwjVoqOc+itzZy2sm47iG0QY7KB3q+yDZPNkw+XNRz
	yPoeiyxVK4z60BjP3JLfDu9vGy8hrwCV4dygeBfmJc4IpsPMDv5LAK2aEkWRR4x+6RDO2T
	HUU0pIcANWLRkfzaYD9Fm1T95a0w5eg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686868; a=rsa-sha256;
	cv=none;
	b=cUVH8nx7Y+gGmLh8OUR3kf5JsF4r4AlG7hhgCTPr5yhINFQ4XupmhISxttigj2hIKtlLpG
	Zd1wOBBb/5j5Ix4NcP9PoRuG41bBfhiHXJlECTva4hpQObLbnLGGLRCwMIOT82hVQpjfaU
	sPXkmAvtmVSV8bfXYnJrEqXCJlYXCfQ=
Received: from omf05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30AA61C0099;
	Wed, 13 May 2026 15:41:05 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 70F3620018;
	Wed, 13 May 2026 15:40:59 +0000 (UTC)
Date: Wed, 13 May 2026 11:41:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long
 <longman@redhat.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>, Broadcom internal kernel
 review list <bcm-kernel-feedback-list@broadcom.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, virtualization@lists.linux.dev,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, "Paul E.
 McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v6 5/7] locking: Add contended_release tracepoint to
 qspinlock
Message-ID: <20260513114102.50f4ca68@gandalf.local.home>
In-Reply-To: <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
	<5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18mkuP/bq6vr3q95KTV/OT7JouORwDcItM=
X-HE-Meta: U2FsdGVkX18OJHEBOrij1GY8MS3sNjKIeD5DPV0GB4D09g1fBle5KDCGhtreToxizLc5krdFdkETIQWCa5/Hf0PvTLoKCOr5zRyt/jzDf/p3FNCOAhqeRP64XRpaugSerSyM2sv2BlpGQmwShdn04U1ogmRGA89WGF4eP6wKngOVgmT7Ln69KfPv5Rpqf0EA0hyoXySTEuVqSccmmhPMlBxgCxvgaqB8m61aJ3j0VHiZvViunQ318cdNLbJJYF9qfW7SiRuqzbe+P40V73WCi4xweZLJQFmJowvjZCJKGlsahpOOABmLiD/FtqXlvH5lm2EbeOXqqKRVJquH8ZVFaS97/QIwZaZ3hJKzj5kkJZobg0ALrj721lldn38bGC5bsDPlQm8tfvk+YKr4xnbbug==
X-Rspam-User: 
X-Stat-Signature: a8158dwz6ai4zwtco1gqykp7cmhtt7w1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 942B21C0012
X-HE-Tag-Orig: 1778686859-354629
X-HE-Tag: 1778686868-971224
X-HE-Meta: U2FsdGVkX19Dn0ntdmThmGyNyIK3PKm5jCnmCkAKqciVWNiwuq+qgycbLqw8BzMmDKE+hgh8uANVF5UryQzQcps/0jSFCSsmjuGF0GDU+HhQhA6SlWvMNou6J1l9tz990qesscPpQueugurCZZtoF6Xz6L7jJqm6+G87P57kIH1BlpC8tR0TpW/m2S9y6klysFyDfi/rBOXgt6u+vTQulmlILB3zTRFEdZ9ASeW9wZz7rgRgDo1x4sHjmvzK7k2evjzG+EoO3N51rZEq/pjmVsVV7RE+hsPmTcv4RRbYNLeVxRQK7TzFtOlaJYavYXXn0UUSDw9qzuVkvWue2ILVKavZk3naa9rhTlIvGRMMhwGyfBmaWywkC65FbV0xqPMolikqclWS7OJXgaFqPFrXCluXxp8dlYKnvNBTKp9HUqKYZwxIAhYibFVkQpEu1nKZJND8JRRv4AeaQpyKAsw4ZhILXFgdXoI6BuIarZXMKo3b+u8JEh0WVeVt9JlAXTVk25EDv3M0XD/82hwBHOy0tw5VtVbywCGBfdYFKtk1Sz2CUa3S7By9JeiWXb6HjCArjf9HXIAo9AS5lncz9oryR+kz1xiZaw54Ob1Q278AOqSwTi3sqc1ylBE91huPnZwMhh72E8ll4kTgBmid4SjatJCQZqZEYF5CWVUecIOBf3yLletqrfmo9zNvySw2KMdN7sCvv+xY76o0VKAUMp+IKHI3EBk3XrVQomUnNQt6lPVvCOxP4aqCYj9yizO6EdsfYcQEtfUOqbj6HEbhg2Pt1oarIPzqCft9hCr7btyuwSR7Ko/A++1c96ntu9cJmWZg+zB909MS2fkWtg/9cJDtV6ufXc19mzslFIRxwbXHrLizIeGZ2M400u/fuxkjG1xSAT71I4NaNGw00TVJtyGX3p+sNflDvL3DUsflxNNWdaBygfMTd8u5Cql8PP7pt+U0Zn8uzKXmw+LWm4bcFd0
 Z8ZxiruP
 k3HsFyEGVwkxpTnYk4+rAdvgSJRc22GRLL+OpfTk0iXhlEFVvFPtKf/RhdEh31ABukIJu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  5 May 2026 17:09:34 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Use the arch-overridable queued_spin_release(), introduced in the
> previous commit, to ensure the tracepoint works correctly across all

Remove the ", introduced in the previous commit," That's useless in git
change logs.

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
>   uninlined unlock (common case): +680 bytes  (+0.00%)
>   inlined unlock (worst case):    +83659 bytes (+0.21%)
> 
> The inlined unlock case could not be achieved through Kconfig options on
> x86_64 as PREEMPT_BUILD unconditionally selects UNINLINE_SPIN_UNLOCK on
> x86_64. The UNINLINE_SPIN_UNLOCK guards were manually inverted to force
> inline the unlock path and estimate the worst case binary size increase.
> 
> In practice, configurations with UNINLINE_SPIN_UNLOCK=n have already
> opted against binary size optimization, so the inlined worst case is
> unlikely to be a concern.
> 
> Architectures with fully custom qspinlock implementations (e.g.
> PowerPC) are not covered by this change.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Paul E. McKenney <paulmck@kernel.org>
> ---
>  include/asm-generic/qspinlock.h | 18 ++++++++++++++++++
>  kernel/locking/qspinlock.c      |  8 ++++++++
>  2 files changed, 26 insertions(+)
> 
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

Get rid of the "return;". What does it save you? It just makes it that you
need to duplicate the code. Even though it's a one liner, it can cause bugs
in the future if this changes. You could call the function:

  do_trace_queued_spin_release_traced(lock);


> +	}
>  	queued_spin_release(lock);
>  }
>  
> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> index af8d122bb649..649fdca69288 100644
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -104,6 +104,14 @@ static __always_inline u32  __pv_wait_head_or_lock(struct qspinlock *lock,
>  #define queued_spin_lock_slowpath	native_queued_spin_lock_slowpath
>  #endif
>  
> +void __lockfunc queued_spin_release_traced(struct qspinlock *lock)
> +{
> +	if (queued_spin_is_contended(lock))
> +		trace_call__contended_release(lock);
> +	queued_spin_release(lock);

And then remove the duplicate call of "queued_spin_release()" here.

-- Steve

> +}
> +EXPORT_SYMBOL(queued_spin_release_traced);
> +
>  #endif /* _GEN_PV_LOCK_SLOWPATH */
>  
>  /**


