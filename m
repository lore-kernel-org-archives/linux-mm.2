Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213B3F3D31A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 15:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812A56B0095; Thu,  5 Mar 2026 10:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B2B6B0093; Thu,  5 Mar 2026 10:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CCF6B0089; Thu,  5 Mar 2026 10:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35ECB6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:58:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2F57139322
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:58:51 +0000 (UTC)
X-FDA: 84512467662.19.9AFA469
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf09.hostedemail.com (Postfix) with ESMTP id 259B3140012
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:58:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772726330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=niym03ltfO1eafWxeMpRz9+rItnvYL5kgljS2262XRk=;
	b=pAlz4xmuZUZas0tnkNFysO4RI2mbgV4qWIVGzY3+1YTZAvA6ZArZ1/khV+d6MhVu35ELhL
	xeeK5cTEkejPBOR595ayrx4NES97GSLn+UzlNXBh3Biee/p0obMAiUlVOTrXKmBHGghPE3
	e89mZe15vqxecZb0pVP3N9NakyK4TGU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772726330; a=rsa-sha256;
	cv=none;
	b=tdWifopaL4cfc1kqR2zQgklzLrEdWO+fDkS+OqP8LnZuZMeJUZT49X8jg23tKdWKjXh3Iq
	uJHjAZrck6jw2M8pcfoIpdi58Uq7hsvOtF/9XQ6hjNwXqUX81K0lGkjnlSxkTJ8NuDRhkl
	WpShHVC3YxYHGzyRgaAycHV/wCVQWdw=
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FEE21A01EE;
	Thu,  5 Mar 2026 15:58:48 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 80C301A;
	Thu,  5 Mar 2026 15:58:45 +0000 (UTC)
Date: Thu, 5 Mar 2026 10:59:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph
 Lameter <cl@gentwo.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon
 <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long
 <longman@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH RFC 3/3] locking: Wire up contended_release tracepoint
Message-ID: <20260305105924.7069eb23@gandalf.local.home>
In-Reply-To: <8298e098d3418cb446ef396f119edac58a3414e9.1772642407.git.d@ilvokhin.com>
References: <cover.1772642407.git.d@ilvokhin.com>
	<8298e098d3418cb446ef396f119edac58a3414e9.1772642407.git.d@ilvokhin.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18MWtLS1l3pUKaex0nFw2Vfl7EBIcRPyp4=
X-HE-Meta: U2FsdGVkX1/IZPjkWRcCvIJ192zG9pkiKp9riLkJeEEB12m4PIrK+XsSVGFmyjEBtSKnYXGbmq4fmXU4d9HZMRfHJo+LIXYoI5bQpOxWtm5mYldXLedVkCnRMeKd2JKSibFruN/kJ11iQ0ereZziADPsiwEip059oSTmSJ2lIaiQiYQK6Zmq3gu23WJeiLOjE+ItRBr5udxCP7OYs7U9RIqDLuHIRwXi5niNS9dY8GbU41//fmJnT07YZBdy2hqEPhpIP9sDaPeSsUU9Ceuxkv5oxQ5BU4VS4Ml30I7B4YiOJD2HrZNdkgH7P7FQhLya7SPlJpGpELX/Kmp79ro1/l6DZwheeJOqGeuFzBG+i+cRqSQUA2V9IYK9m1k2MlzR
X-Rspamd-Queue-Id: 259B3140012
X-Stat-Signature: hfiedgw3dg1eqbike9zpzdm3kuksfs8i
X-HE-Tag-Orig: 1772726325-806204
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772726330-440604
X-HE-Meta: U2FsdGVkX1+1TrVe7D+CIfwcByVcC5evFCS1XyHHDAti1NuKSNcie2yF/xP/JnasZO3pRR8bPrTO1uzn3+G9YqV/3AQVZJXlqtNosSCxf+3NaQMTJAgHuqK7RU0FVKjPEiiUQCDLVIAaeGzYITmhGK+7tlsDTCRTDLUNrQenlvchjKNfA2rMwQm6aqRaahOds6KtlUTVzsilk/z6ImhEMeP+9wiKENHVR8hQAozloaB1PO11UCxIZQo9rFJEZelcoH3HZCHpPcfS+KTeGIjcDwUeGLr4zwk65H4fYArYR2vPy4xw4X+pqlhbMSzLZ6EPOFw0I4ju0/L4JvLRPpuZ/EflT3mr8NZJdqm/44Ny3JWhBQ6tZ+XK3C3hL48ViPjr3ZJjB9EiBxuIskoIsTFMTEwToG2YsF8gQpb18ZVS5qvh5Uu97Ot8CaZbYO1hy/X6Ff9KWPagBlvu7W5OA2sQFgnMfnfCRiGLby1UqJx272YXGh8rmv7e+Dgyc8zPmhxQTZn6va+rxB4D+cAswpZxUXY6LJwPUafC8xAMO7IoiAy7pUuJ89fzEsMDh3XbA1c558zPSIbuafYwDuaCKOcFKax4MuRBh56IUcx855MpICh2559mTa1mcOIjbh9rsEB0IWkwl81rBOJt3pRKF7JEbtAVGSuyCj5pxKCw9ehtRYqShL/8ZjnNnswHT8M8OjMEeBbKtOg5V2jmSNJHmi5rNUdNoF8eNn2EBMZv2px8WflriZuGcX7G27vukqkCRnTBRuIXYBPj/qJrXjs/CPfsbdDIYH4VS3Y0Bq/J706oiHoxTMZRE5rRD7M4dLMaG9LDe3DCdWDVtWTBL2pRtVdZ/oUdUG2NXNsf2MyGpSgYS0frpF7w5baLQcXq+REd0n7/v9HfJYm8NT/tfCJike0UWnaYuBlxASTL1TylVzwqdxAYiyn3sYhpqCPALdeNM9VimqzYjJ9ZmS1nMpC7XNT
 cjgGGIIv
 ZxRB638RfJ9T7kT6EoEIusMNEOB8SpdG1af69O6cJngPgFlA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  4 Mar 2026 16:56:17 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> @@ -204,6 +206,8 @@ static inline void rwbase_write_unlock(struct rwbase_rt *rwb)
>  	unsigned long flags;
>  
>  	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
> +	if (rt_mutex_has_waiters(rtm))
> +		trace_contended_release(rwb);

Hmm, if statements should never be used just for tracepoints without a
static branch. The above should be:

	if (trace_contended_release_enabled() && rt_mutex_has_waiters(rtm))
		trace_contended_release(rwb);

The above "trace_contened_release_enabled()" is a static_branch where it
turns the if statement into a nop when the tracepoint is not enabled, and a
jmp when it is.


>  	__rwbase_write_unlock(rwb, WRITER_BIAS, flags);
>  }
>  
> @@ -213,6 +217,8 @@ static inline void rwbase_write_downgrade(struct rwbase_rt *rwb)
>  	unsigned long flags;
>  
>  	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
> +	if (rt_mutex_has_waiters(rtm))
> +		trace_contended_release(rwb);

Same here.

-- Steve

>  	/* Release it and account current as reader */
>  	__rwbase_write_unlock(rwb, WRITER_BIAS - 1, flags);
>  }
> diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
> index 24df4d98f7d2..4e61dc0bb045 100644
> --- a/kernel/locking/rwsem.c
> +++ b/kernel/locking/rwsem.c
> @@ -1360,6 +1360,7 @@ static inline void __up_read(struct rw_semaphore *sem)
>  	if (unlikely((tmp & (RWSEM_LOCK_MASK|RWSEM_FLAG_WAITERS)) ==
>  		      RWSEM_FLAG_WAITERS)) {
>  		clear_nonspinnable(sem);
> +		trace_contended_release(sem);
>  		rwsem_wake(sem);
>  	}
>  	preempt_enable();
> @@ -1383,8 +1384,10 @@ static inline void __up_write(struct rw_semaphore *sem)
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
> @@ -1407,8 +1410,10 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
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
> index 3ef032e22f7e..3cef5ba88f7e 100644
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


