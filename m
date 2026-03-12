Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E45B105A589
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8676B0088; Thu, 12 Mar 2026 07:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952496B0089; Thu, 12 Mar 2026 07:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854B26B008C; Thu, 12 Mar 2026 07:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75B756B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:38:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E58A562A6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:38:33 +0000 (UTC)
X-FDA: 84537213306.26.F7CB9C9
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf13.hostedemail.com (Postfix) with ESMTP id D9D6F2000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:38:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nh5FAB8T;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773315511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bu5mWobvX4U3cXiyaUbCa8xpuOximkgmKYMfG+Fla8Q=;
	b=MCO8qN+gyKJG2etThozT8OP9n8y/DJwBTg/4o11hyYPV9qEhXfLIDE2bezDSiSz/yQHY8+
	XLb+LaVk3J8FevtFkeed8ZYpt85POX3IrLjCQrDqtR3uvy8Afq3Q71qllBAZbI9SzHfhJd
	cmpgVUgt+CpkeTydO/lz9R6W7E+cLnw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773315511; a=rsa-sha256;
	cv=none;
	b=xcxCcEYfPX4fyRh3Fvv/3SY2FI/s1mH9YP1A/cy7XXXZ6nUfOWp3dsGJCoxjMGEhnFLVua
	6mXQMlYoHGFoQw6l5hiXirH0RdkqJNL85p6MKDCMMQDcOBO2vzjEAIzOE5Cnl2QquBo9kA
	AUxtdlGzIS0yrLl2EZTRhkVWPwi06+0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nh5FAB8T;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773315506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bu5mWobvX4U3cXiyaUbCa8xpuOximkgmKYMfG+Fla8Q=;
	b=nh5FAB8TtEr58qotNI9hqlK7o9elx15QlsZorIirz65yTG5vuq0WaNHIlK2GhbLbLCWHtX
	sf3BDhH2e8K6OF6Gp1caUzDVLIe0dEyOheCOGvZgQ+7cbYdGmHgrKHI6D+jwy9LknsU5IW
	MVtrimwww8LH9Hq5JTFun2xbeOedeic=
From: Usama Arif <usama.arif@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] locking: Add contended_release tracepoint
Date: Thu, 12 Mar 2026 04:38:14 -0700
Message-ID: <20260312113815.2107882-1-usama.arif@linux.dev>
In-Reply-To: <cb89caf58885858433711f0ed6238484f5f1a67f.1773164180.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D9D6F2000B
X-Stat-Signature: gyg8fwuwyf9xr67imd938c84cktuoi8x
X-HE-Tag: 1773315509-17494
X-HE-Meta: U2FsdGVkX19h8WGLTCACAoq70XMc3qzxkZ+HmCKInDWYLJFGB/ntMO8gw4IUOgxNvr+hVa1BMeS7Jcjs6Kc1LmbeWKK9XfA/uoy6Ls6L6MJ0NzonlsQnWjcTiGaa1W+mY7RTEmCj53cKwgOTGww12PzMR7SJjobm0BOYcvEgdSJt6IFRg3SzK83d9nggxaul2/YUiltd3k8rc50Fw58t5D2XpIdukifJq+9+8nF6l55W4TQDIsexoy0dCAD1Mx8gqL0EzM62TdViLX9YRFOc1WZ9umNyyMXQJyLB+RRUIQF2/yoeue39Y0Xr7LPGHxZ5gXXocXYVdMZGBi8IZvEuJdjt9DIVUQRHSEOjSY26TejJqYM64oQgGF2m33MNoc1lD4LL7fmqroXPZ2v2AyDChPXmYbLQLvj3EnDVuzKJLsL9OisHeWxNslMn242qLwYOIsaC5/NtXl7NOA+dMS1qABKrH6q/M77//SGMYfwCl/K0P6NOCKUl9xZg7J9NCEHZrYzJHCQZzBqjaowmdpOL2k5c53JlT6BMe5nTsu7AU37hOYC7MetARFT1iOt6A/cVj+zGZuwvv7/OSoB9lWJDbnxLbB7JVkKDqh/AH6OBH8/n6MPthiqU/g/Ok9LudDeGYs3dhZMgUY4bhTnq8vH9E5RMjZE5E+rWBZr1S09M1zTZo90mN8IdnThxYy+NPlBTark2kIx0xNS53KsEH5q1HrpUfsL7LcOmEU/i8dH1rOukG33Or0D1KcF9+Kq3/NzwxIQK6IQGqt1VIqeR0jkouzGJYxpHczLUCcmIGv3nXkUMTNeBS1gWoqyzcR0le/PNtKnYiMpVeaexNEoGrLW+qAYRNwiA1yGPDzQzPPmgoAsjYm1mJhMUH7XcutQR4sQES3gVm+E70WvEPlrwIuVDEtHgFf4fPqWH2dY5zFW+etA2ceIM6+CMgWB4YYK9s6d1/pYky51kDPAQpcCjzkV
 eZxqX8ui
 EJpl/6HkyMOpPM2EPbmqdgDv0CvJ8i1e0zfIG3gMUe5TJOdDEJEiarOBfvOJtqvS3nCCl1Dbk8bqEdXsvpCUO5Lyav3XVF+SrmGHUUNk2BirDt4MWJBN7pgNWVZaYbAuOIOnsm2o/WnWoK2OcB/CZVCoINBqpkXKBhiU6+eva4WQAUhGOW3RBvpGWXLCrXroYxqvFONJV51HJIlBPKWDdISd6iv4sbwsYKArC6KqfXxUCNW9nNI1FPCCVxOr4sm3YBiMWDlVzn7IYwS3+7SFp5p1/owzFWvsCQ9REZ33DrFrEWLpKWRuLAwjYq81D0aUAXcOoVEfAr2MGMOW2VMKPDtrOhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 17:49:39 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

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
> RT-specific rwbase locks. Each call site fires only when there are
> blocked waiters being woken, except percpu_up_write() which always wakes
> via __wake_up().
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  include/trace/events/lock.h   | 17 +++++++++++++++++
>  kernel/locking/mutex.c        |  1 +
>  kernel/locking/percpu-rwsem.c |  3 +++
>  kernel/locking/rtmutex.c      |  1 +
>  kernel/locking/rwbase_rt.c    |  8 +++++++-
>  kernel/locking/rwsem.c        |  9 +++++++--
>  kernel/locking/semaphore.c    |  4 +++-
>  7 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
> index 8e89baa3775f..4f28e41977ec 100644
> --- a/include/trace/events/lock.h
> +++ b/include/trace/events/lock.h
> @@ -138,6 +138,23 @@ TRACE_EVENT(contention_end,
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
> index 427187ff02db..ff9d07f3e900 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -992,6 +992,7 @@ static noinline void __sched __mutex_unlock_slowpath(struct mutex *lock, unsigne
>  	if (waiter) {
>  		next = waiter->task;
>  
> +		trace_contended_release(lock);
>  		debug_mutex_wake_waiter(lock, waiter);
>  		__clear_task_blocked_on(next, lock);
>  		wake_q_add(&wake_q, next);
> diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
> index f3ee7a0d6047..1eee51766aaf 100644
> --- a/kernel/locking/percpu-rwsem.c
> +++ b/kernel/locking/percpu-rwsem.c
> @@ -263,6 +263,8 @@ void percpu_up_write(struct percpu_rw_semaphore *sem)
>  {
>  	rwsem_release(&sem->dep_map, _RET_IP_);
>  
> +	trace_contended_release(sem);
> +

Hello!

I saw that you mentioned in the commmit message that you do this for only
blocked waiters except for percpu_up_write(). We can use
waitqueue_active(&sem->waiters) to check for this over here so that
its consistent with every other call?


>  	/*
>  	 * Signal the writer is done, no fast path yet.
>  	 *
> @@ -297,6 +299,7 @@ void __percpu_up_read(struct percpu_rw_semaphore *sem)
>  	 * writer.
>  	 */
>  	smp_mb(); /* B matches C */
> +	trace_contended_release(sem);

Should we do this after this_cpu_dec(*sem->read_count)?

>  	/*
>  	 * In other words, if they see our decrement (presumably to
>  	 * aggregate zero, as that is the only time it matters) they
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
> index 82e078c0665a..081778934b13 100644
> --- a/kernel/locking/rwbase_rt.c
> +++ b/kernel/locking/rwbase_rt.c
> @@ -162,8 +162,10 @@ static void __sched __rwbase_read_unlock(struct rwbase_rt *rwb,
>  	 * worst case which can happen is a spurious wakeup.
>  	 */
>  	owner = rt_mutex_owner(rtm);
> -	if (owner)
> +	if (owner) {
> +		trace_contended_release(rwb);
>  		rt_mutex_wake_q_add_task(&wqh, owner, state);
> +	}
>  
>  	/* Pairs with the preempt_enable in rt_mutex_wake_up_q() */
>  	preempt_disable();
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
> index ba4cb74de064..cf7d8e75ad7b 100644
> --- a/kernel/locking/rwsem.c
> +++ b/kernel/locking/rwsem.c
> @@ -1390,6 +1390,7 @@ static inline void __up_read(struct rw_semaphore *sem)
>  	if (unlikely((tmp & (RWSEM_LOCK_MASK|RWSEM_FLAG_WAITERS)) ==
>  		      RWSEM_FLAG_WAITERS)) {
>  		clear_nonspinnable(sem);
> +		trace_contended_release(sem);
>  		rwsem_wake(sem);
>  	}
>  	preempt_enable();
> @@ -1413,8 +1414,10 @@ static inline void __up_write(struct rw_semaphore *sem)
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
> @@ -1437,8 +1440,10 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
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
> index 74d41433ba13..d46415095dd6 100644
> --- a/kernel/locking/semaphore.c
> +++ b/kernel/locking/semaphore.c
> @@ -231,8 +231,10 @@ void __sched up(struct semaphore *sem)
>  	else
>  		__up(sem, &wake_q);
>  	raw_spin_unlock_irqrestore(&sem->lock, flags);
> -	if (!wake_q_empty(&wake_q))
> +	if (!wake_q_empty(&wake_q)) {
> +		trace_contended_release(sem);
>  		wake_up_q(&wake_q);
> +	}
>  }
>  EXPORT_SYMBOL(up);
>  
> -- 
> 2.52.0
> 
> 

