Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD34AF9D0DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 23:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5CD6B0088; Tue, 14 Apr 2026 19:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96466B0089; Tue, 14 Apr 2026 19:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D855E6B0092; Tue, 14 Apr 2026 19:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5D2A6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:09:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57E211602BC
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:09:33 +0000 (UTC)
X-FDA: 84658705026.18.FE77593
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id A640A20013
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:09:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qBelCepT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of "SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776208171; a=rsa-sha256;
	cv=none;
	b=4I0eIEMy7FBUaa2YUIJXZ62bra5HvMQ6GdrrAmAIfEqhfiW02IOi88NFXoNFt4xetY/as8
	qFnwy3oJnPfhIQXXLI7Eq0dLrSKfAbIyVAQSpNbwIefY4+BKL+FruwDh+ldu7PPe9XZv1h
	qw22xfr4zi1ei/stD4Ccap3uDM+IFHM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qBelCepT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of "SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776208171;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cj12voxMKYpLQfRtBzt3M2FVnXHkE0HaRXw+dtrKomc=;
	b=MrrinLoe6RoZbPmcIFDIaWsK57zIKea8mbXbc6Ve7BFa0BpMLyyhQYnLeR6k79UgZ6vS+u
	OMig2HZxCJCT9wtiw5IhyWcFTIxrPCaSyZbkJmIEbX7f7exLu3lK9fT5v3OqnwDUR5sigs
	tlRNcimPNul9FOeUtDf8T6P+DrtqoIU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C17FE600AE;
	Tue, 14 Apr 2026 23:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6918DC19425;
	Tue, 14 Apr 2026 23:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776208170;
	bh=m0W/Ernt03ORrUvvuWlaV+yJl5KaCu8uMNwKRgnc1JU=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=qBelCepTc9lFdVUgh+o5h1aXWx6734PGrt1TsMYUW8hNHRDFGGvbQBnbL7dkpco6k
	 FOWMq2sxkQ//wmRKXPFKM2vXXv6BS3Sv3GEPKQgc9sNlUbSKK0Z3Ea5TZwC/uq1yAx
	 XmarXC3/Ng/MOmZpZtC2AlgJFzmvc9Ns3XgKRXeNVliCghDA1lZzITubKE4U5WMow4
	 aLNVnwqvUSMw7gjHi2mEqYtiDu3lfqxpFZHxsZI966VlBMLNFolgMJDx3pPmVkSeKs
	 jkTzJ9lwTV80UFCo9VCmOvVlg94JahYcn8tZKQTzVofGTAOdvXmkjGvWtz5BmsTKPW
	 7sluvHMU/cwXg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 0224ECE13BF; Tue, 14 Apr 2026 16:09:29 -0700 (PDT)
Date: Tue, 14 Apr 2026 16:09:29 -0700
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
Subject: Re: [PATCH v4 3/5] locking: Add contended_release tracepoint to
 sleepable locks
Message-ID: <2d2a6584-2b75-44e9-953e-e6244ff2abc9@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <cover.1774536681.git.d@ilvokhin.com>
 <d2e5763278812499335b22a013aafb4979e3324b.1774536681.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2e5763278812499335b22a013aafb4979e3324b.1774536681.git.d@ilvokhin.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A640A20013
X-Stat-Signature: xbzik5fcp4r6pitrwgdcw9ksg35qorap
X-Rspam-User: 
X-HE-Tag: 1776208171-907539
X-HE-Meta: U2FsdGVkX19WOvhx9Z5v+BDiNj0GePX7qX/tZIOFmeUdCUB8Rr8oPBAvHC9egFhB0ZNDX10tWOwEhHJYVhUgzkA6qpPUc1XVGhajMDx3Ag0VEbuFk118p/hbwaSkD2Izu3/Lu0KOJxf0jZcP2SZ0RaEOXItYW5vhRZ+XKD6yX2MzinTlWvx+EqVgPB/nbYa4Vlbshm2K0XC80qcHJZVvsm1FrlgJhDYdGa2BZNFUmAMZSlzxnaNUan/o/iwAF/b84sfRFER7liBN1tm8pWPAy1nRtw2fvoHyU5N5A5nRV23uiBlgOSHAcpfoAaelTflzZYa7ryqeWIbizVm2zJw0r2qiH+gbpx70PWu59wefhxTPXjc1Wb0i4U3bBOsG2ZNOlcKphc7hia8BOa2UxLhaO53tv7Eso1z3r4sZZq2DRhBJ0wpDdRjXb15evVwwU1WDLYygJ3EdBmJxi7pP+UcMUbjxs6ZCmrpVsUxusj9iMjlpDt9sl3Q/l65VwC3TXn/0laHTNCHlw/reC/kXqcLlxtRPWvag/Kul+qv4uNQ2iKrV51Gn4VJur9P2N+CFaw0ijh22nyMiWYOF8yGoZ2cJQDAWG3U1bcV9pv8O65oSSjKrsDmlSGTYLAiiLo18SVq0byFOA/ByPuB8BxOsfLnI+WB1JBZOIgxISP22yfSfTHZ0UbZkyGb/J1goE6Daf8Cxll+YW7zn3uoobWbrTfxU0nVrDPSx/PEAsfPdktD58oO04jQyiptzU1ji+UZC8RUamQxDT1zUOdabGpNidR6Qh9/2anRET8BUx1/vVrlgaXWKj3ysCaVjPXxCJPR7UclFbj2qmd175B6CyloRirpBzcJylCFBq/8/Wz8ZfTEVk2T2A6eHjt8eYBM4IMtoWqfedxtkw/2kCUKVg6s8j/GTD4wTNKd5MEUASihNAcCuNcqiv/2bKBd48blT5JUR9gFiXSIAubSxrAVYb9Fap4+
 0CT8R5cv
 HZG2oNFLvItGcCs8ANG7GPXTVRoV4vCHVoXRTkQg9yBfCrCbwnOHMb70ztyuBr4NT6zjN5OU7Jf52njFGs3AfL/lllXZqo9KR8u2rQ7U+y7f7mTFemYqAFqgrlxS9gUiGLxHFSj6AWPgeGmfaVd8/XpijupMyva+XdS3gvgBeS/wbKjM0h6Wpp9DaZ0dl3wv7CHiBVJ1kkR87KKUiMv6ktx/sJLt31peUL/JoFDk5xdCDkSWFtRo7G/VD6qK1NFyc1lSp7uSXh8aPIHP8J94BuASONmiPxgq56HjK3iGlmMldAWqhEM/+s1ykK9VNHbfCZjOi5qUbE8SCp5enjEVb9Xiyla3cSaXKJhIqcPEdavLRn5JEM57E78gyarNKuoXMqVYp8p0NpTFMnTZKtYpAKhMEV5TDjJb54mWUEhxzcrPi+q47cJLk+eZjpGloT2xQOjNJN1/k5GjcpyjEYOGetDJbHszAIFcSh4GdNiW+xmHUKJ8RXP1xlva7xNtO9LPeGvMf6Dbhbfmg/vPNgynLgy1vfbrxIIlOytibs+VkXdi4Fr+Cf/NzQZ+0sFrDTmQL5GoUQP+ZiKx3ph3arKCaaMhQQehbFEf1VP3EK2rqAlQ68Gy2kVNVtByDz5TJenRWY1dBVkCakhwlnXOqR6gTqpcsW7tJxE7WXGIACtbDQ993sg4DkRzulY7QhC+fkqWrK2L+NbxGlQ0Xkl7dhEW29Yclj8Ko+2KZpw7I3yHatDQdein1UDBCUnMw6qhB8f08XzHu04NZVFooh7SJzF98A0gjBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:10:02PM +0000, Dmitry Ilvokhin wrote:
> Add the contended_release trace event. This tracepoint fires on the
> holder side when a contended lock is released, complementing the
> existing contention_begin/contention_end tracepoints which fire on the
> waiter side.
> 
> This enables correlating lock hold time under contention with waiter
> events by lock address.
> 
> Add trace_contended_release() calls to the slowpath unlock paths of
> sleepable locks: mutex, rtmutex, semaphore, rwsem, percpu-rwsem, and
> RT-specific rwbase locks.
> 
> Where possible, trace_contended_release() fires before the lock is
> released and before the waiter is woken. For some lock types, the
> tracepoint fires after the release but before the wake. Making the
> placement consistent across all lock types is not worth the added
> complexity.
> 
> For reader/writer locks, the tracepoint fires for every reader releasing
> while a writer is waiting, not only for the last reader.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Looks plausible:

Acked-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  include/trace/events/lock.h   | 17 +++++++++++++++++
>  kernel/locking/mutex.c        |  4 ++++
>  kernel/locking/percpu-rwsem.c | 11 +++++++++++
>  kernel/locking/rtmutex.c      |  1 +
>  kernel/locking/rwbase_rt.c    |  6 ++++++
>  kernel/locking/rwsem.c        | 10 ++++++++--
>  kernel/locking/semaphore.c    |  4 ++++
>  7 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
> index da978f2afb45..1ded869cd619 100644
> --- a/include/trace/events/lock.h
> +++ b/include/trace/events/lock.h
> @@ -137,6 +137,23 @@ TRACE_EVENT(contention_end,
>  	TP_printk("%p (ret=%d)", __entry->lock_addr, __entry->ret)
>  );
>  
> +TRACE_EVENT(contended_release,
> +
> +	TP_PROTO(void *lock),
> +
> +	TP_ARGS(lock),
> +
> +	TP_STRUCT__entry(
> +		__field(void *, lock_addr)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->lock_addr = lock;
> +	),
> +
> +	TP_printk("%p", __entry->lock_addr)
> +);
> +
>  #endif /* _TRACE_LOCK_H */
>  
>  /* This part must be outside protection */
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index 427187ff02db..6c2c9312eb8f 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -997,6 +997,9 @@ static noinline void __sched __mutex_unlock_slowpath(struct mutex *lock, unsigne
>  		wake_q_add(&wake_q, next);
>  	}
>  
> +	if (trace_contended_release_enabled() && waiter)
> +		trace_contended_release(lock);
> +
>  	if (owner & MUTEX_FLAG_HANDOFF)
>  		__mutex_handoff(lock, next);
>  
> @@ -1194,6 +1197,7 @@ EXPORT_SYMBOL(ww_mutex_lock_interruptible);
>  
>  EXPORT_TRACEPOINT_SYMBOL_GPL(contention_begin);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(contention_end);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(contended_release);
>  
>  /**
>   * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
> diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
> index f3ee7a0d6047..46b5903989b8 100644
> --- a/kernel/locking/percpu-rwsem.c
> +++ b/kernel/locking/percpu-rwsem.c
> @@ -263,6 +263,9 @@ void percpu_up_write(struct percpu_rw_semaphore *sem)
>  {
>  	rwsem_release(&sem->dep_map, _RET_IP_);
>  
> +	if (trace_contended_release_enabled() && wq_has_sleeper(&sem->waiters))
> +		trace_contended_release(sem);
> +
>  	/*
>  	 * Signal the writer is done, no fast path yet.
>  	 *
> @@ -292,6 +295,14 @@ EXPORT_SYMBOL_GPL(percpu_up_write);
>  void __percpu_up_read(struct percpu_rw_semaphore *sem)
>  {
>  	lockdep_assert_preemption_disabled();
> +	/*
> +	 * After percpu_up_write() completes, rcu_sync_is_idle() can still
> +	 * return false during the grace period, forcing readers into this
> +	 * slowpath. Only trace when a writer is actually waiting for
> +	 * readers to drain.
> +	 */
> +	if (trace_contended_release_enabled() && rcuwait_active(&sem->writer))
> +		trace_contended_release(sem);
>  	/*
>  	 * slowpath; reader will only ever wake a single blocked
>  	 * writer.
> diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
> index ccaba6148b61..3db8a840b4e8 100644
> --- a/kernel/locking/rtmutex.c
> +++ b/kernel/locking/rtmutex.c
> @@ -1466,6 +1466,7 @@ static void __sched rt_mutex_slowunlock(struct rt_mutex_base *lock)
>  		raw_spin_lock_irqsave(&lock->wait_lock, flags);
>  	}
>  
> +	trace_contended_release(lock);
>  	/*
>  	 * The wakeup next waiter path does not suffer from the above
>  	 * race. See the comments there.
> diff --git a/kernel/locking/rwbase_rt.c b/kernel/locking/rwbase_rt.c
> index 82e078c0665a..74da5601018f 100644
> --- a/kernel/locking/rwbase_rt.c
> +++ b/kernel/locking/rwbase_rt.c
> @@ -174,6 +174,8 @@ static void __sched __rwbase_read_unlock(struct rwbase_rt *rwb,
>  static __always_inline void rwbase_read_unlock(struct rwbase_rt *rwb,
>  					       unsigned int state)
>  {
> +	if (trace_contended_release_enabled() && rt_mutex_owner(&rwb->rtmutex))
> +		trace_contended_release(rwb);
>  	/*
>  	 * rwb->readers can only hit 0 when a writer is waiting for the
>  	 * active readers to leave the critical section.
> @@ -205,6 +207,8 @@ static inline void rwbase_write_unlock(struct rwbase_rt *rwb)
>  	unsigned long flags;
>  
>  	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
> +	if (trace_contended_release_enabled() && rt_mutex_has_waiters(rtm))
> +		trace_contended_release(rwb);
>  	__rwbase_write_unlock(rwb, WRITER_BIAS, flags);
>  }
>  
> @@ -214,6 +218,8 @@ static inline void rwbase_write_downgrade(struct rwbase_rt *rwb)
>  	unsigned long flags;
>  
>  	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
> +	if (trace_contended_release_enabled() && rt_mutex_has_waiters(rtm))
> +		trace_contended_release(rwb);
>  	/* Release it and account current as reader */
>  	__rwbase_write_unlock(rwb, WRITER_BIAS - 1, flags);
>  }
> diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
> index bf647097369c..602d5fd3c91a 100644
> --- a/kernel/locking/rwsem.c
> +++ b/kernel/locking/rwsem.c
> @@ -1387,6 +1387,8 @@ static inline void __up_read(struct rw_semaphore *sem)
>  	rwsem_clear_reader_owned(sem);
>  	tmp = atomic_long_add_return_release(-RWSEM_READER_BIAS, &sem->count);
>  	DEBUG_RWSEMS_WARN_ON(tmp < 0, sem);
> +	if (trace_contended_release_enabled() && (tmp & RWSEM_FLAG_WAITERS))
> +		trace_contended_release(sem);
>  	if (unlikely((tmp & (RWSEM_LOCK_MASK|RWSEM_FLAG_WAITERS)) ==
>  		      RWSEM_FLAG_WAITERS)) {
>  		clear_nonspinnable(sem);
> @@ -1413,8 +1415,10 @@ static inline void __up_write(struct rw_semaphore *sem)
>  	preempt_disable();
>  	rwsem_clear_owner(sem);
>  	tmp = atomic_long_fetch_add_release(-RWSEM_WRITER_LOCKED, &sem->count);
> -	if (unlikely(tmp & RWSEM_FLAG_WAITERS))
> +	if (unlikely(tmp & RWSEM_FLAG_WAITERS)) {
> +		trace_contended_release(sem);
>  		rwsem_wake(sem);
> +	}
>  	preempt_enable();
>  }
>  
> @@ -1437,8 +1441,10 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
>  	tmp = atomic_long_fetch_add_release(
>  		-RWSEM_WRITER_LOCKED+RWSEM_READER_BIAS, &sem->count);
>  	rwsem_set_reader_owned(sem);
> -	if (tmp & RWSEM_FLAG_WAITERS)
> +	if (tmp & RWSEM_FLAG_WAITERS) {
> +		trace_contended_release(sem);
>  		rwsem_downgrade_wake(sem);
> +	}
>  	preempt_enable();
>  }
>  
> diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
> index 74d41433ba13..35ac3498dca5 100644
> --- a/kernel/locking/semaphore.c
> +++ b/kernel/locking/semaphore.c
> @@ -230,6 +230,10 @@ void __sched up(struct semaphore *sem)
>  		sem->count++;
>  	else
>  		__up(sem, &wake_q);
> +
> +	if (trace_contended_release_enabled() && !wake_q_empty(&wake_q))
> +		trace_contended_release(sem);
> +
>  	raw_spin_unlock_irqrestore(&sem->lock, flags);
>  	if (!wake_q_empty(&wake_q))
>  		wake_up_q(&wake_q);
> -- 
> 2.52.0
> 

