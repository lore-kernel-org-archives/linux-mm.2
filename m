Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BC2107BCE8
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 21:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2376B0088; Fri, 13 Mar 2026 17:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49FDB6B0089; Fri, 13 Mar 2026 17:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3810D6B008A; Fri, 13 Mar 2026 17:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 274066B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:55:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAE401A0348
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 21:55:52 +0000 (UTC)
X-FDA: 84542397744.19.2B73F20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 195F240006
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 21:55:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z97PW/xO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773438951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QePNtwTyjPD8Ns0mwutL0833zBoVDif5yir9TX62kmI=;
	b=a/JJWTgB0QcOKxH+oWFMak7qPp6wyFr7qH8Ak6tvTVtyjMdqudAaI6Fj6JGUDY4aQ+NjCa
	a62C7dEhaVEoHD0d+P3OVI6xhcDNzezcZ5unt8H6plAFNcd6EPtREO8OsTG4ykWH8xqFAt
	FEIqXFyLPHuPV4/5YBfcxMuC/EC5lCw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z97PW/xO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773438951; a=rsa-sha256;
	cv=none;
	b=WSJU5cRbuBSSQpMVqo71IHotU/PxrCZt0b2h+4Xx1hu0Y5sPFoxrjrfDMq5m7JrecMa15Q
	x3oq+KF5996D4ckFKVJw26Mb2DmL86hbzXjwjerSvLOgpKaet3gcxWlmUfep2nTZr8y2Zx
	OjmJi+7B/Uh8xMlZlJ8Hbr/TG3FMkF8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64B646183E;
	Fri, 13 Mar 2026 21:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1D5C19421;
	Fri, 13 Mar 2026 21:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773438950;
	bh=J+1whV0bQAHJPzJi06y0VUL5l09xyZG3WF6bTwRhO70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z97PW/xONIssQ9EuEXuzpdRUODvHcthdXF7z7ZLftu8FXgDfDQ/KfQh3VKNlEBnRX
	 Lck4u9qh8MZwQvrobgbo9CYxv/3PLJFfHC++b4u23AJmVYDiTdJyVqyQ2b17jSkFzS
	 IrZcy4p2nbeil2Oan6TqFq1H+MXtXg+hyh5xLFQBBz41wiqAdfOHy3Z0I+WC2ABocB
	 ojZyNF2RkJfHLSVMHZZpJa/Yx+aV08dURIQYtLRnezmxQ3tJ1yf/qkBac1GFMcEvZX
	 D6Dd2DhMf67mUhauZ93OLmOuZIft3SgHWGAGFLAODJAnAvz7xsMQgM6P2/7anu35xI
	 ZxwW5mvMdhYfA==
Date: Fri, 13 Mar 2026 22:55:47 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras.c@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush
 work
Message-ID: <abSH40oW9qiVDXZS@pavilion.home>
References: <20260302154945.143996316@redhat.com>
 <20260302155105.214878062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260302155105.214878062@redhat.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 195F240006
X-Stat-Signature: ob6es3mhajmxoiryxd3odke87u84zzf5
X-Rspam-User: 
X-HE-Tag: 1773438950-320394
X-HE-Meta: U2FsdGVkX1/eJcOUeSwufRj6iJq18YeKSFtELt1VeJel3leKoE7x1gsIQ1vcEq/MGnCUtlKwCjnVzLJ/xa0dS4LacFiipRC+RllfVfVvx5Ra8Kw654JlRURYsxuSHxk9O6ULNo0nNuWCXv3NAJwH6H7IJ/yK0aTR7BqzM2QNluM3wC/GSBCVgkiY9NcvfkzbLPLEUAlGp4WyGHrxrJBN6Wt8pvHPe45qTAkOKiQP4KBaF6aZCHoOGIMcXTe/4FFfD6YumeO9OCVjwQimw2Cp11gzf3zFO0XLzY982XjSVKusImvwuinkxFZXob0tpBGfNL4PaDsEhjvDK/XDgu8Fd4ZZYLi5NJ7P2KoD76zZ9xR4/DH5zjYopWIXnCZPikGCHwiKT01EsYZ9yTvfr8u1VGYU5K3gWIqOauns751K488XqXKn54dMB0xRQ359fSem135L2u1LHokTMhnmUXUVcxhFGuGNP1avGi7cCqEezaQBD7UgBNBble+TgC+674ic7qgkcDxDahvN+XLOvuSORJVk2hGTX68u1EmgIr+WW8wX5KTghxbZlgEsFxRwXgGPLyh8mDP+mXyqFv5LrA/iV5+LPq3cRrPajr5dJIGSdEhDXRTHhCwp7Oc0zQo/cLt60TzN07YUPX7qpM+fNDtnnc5fs1gvED6ys+qHkFRr2pkBzYvb+cP9UKGQgzVI9R0FFpxcBVn2pDZ57mrUvUpdX7NKrHRa5B0+ImA5TPZzLFXFtsJizA0WcsjQnspjuXd9V5qrSsMxG+z8zw3dnkMSXj1ZxgCn33lrdkJtH6w3e74s1wEXyXqduflwEBb2b3PoGgc7anMokbbuAQearD6I2NpxPt4ytznMnfuOhMP+fNixiiMeT9cyr6qLYNNI22mELU/dkl9unNY25wkd0BklFWRB96zDRfVGJ7h3TPI0LYce+tE6ngxnw2/VQyz9TyZR3ugCF32cGiW/9fR6OaO
 XmMJrLkb
 O11C7z/40vvWlPZAcWotQctaN0EcdzpAxTBEvwNDEwsysk9C8UBlXhon+eQX0AplScEdFZeHoJK5FOFUNsvCGyVKNvCRwulWd0UFlJZODBtUngnn7lGjJhQeYONLXL8oIJnEYhiqyaPacfMlgEI1Ax+jJ0Yhe0BSQ2NzA0RA4FJUK0FgxT7uuBq10gpBLMKcutsgwmOLOh8igJ0Z6vl3KhU1thXe7YkjWySeivglAqUppZzu0N0Umeu5qu0+bP1jH7wbFqm6+V+GdSfiAx7BhxS0eRZ3Gxt53JQjWU582PDefWu0Wo2Rfd+O9J/aPxRkHp6AfMXUwPvgFtwRftq1TXapP9yWbXjzvwuiT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Mar 02, 2026 at 12:49:47PM -0300, Marcelo Tosatti a écrit :
> Some places in the kernel implement a parallel programming strategy
> consisting on local_locks() for most of the work, and some rare remote
> operations are scheduled on target cpu. This keeps cache bouncing low since
> cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> kernels, even though the very few remote operations will be expensive due
> to scheduling overhead.
> 
> On the other hand, for RT workloads this can represent a problem:
> scheduling work on remote cpu that are executing low latency tasks
> is undesired and can introduce unexpected deadline misses.
> 
> It's interesting, though, that local_lock()s in RT kernels become
> spinlock(). We can make use of those to avoid scheduling work on a remote
> cpu by directly updating another cpu's per_cpu structure, while holding
> it's spinlock().
> 
> In order to do that, it's necessary to introduce a new set of functions to
> make it possible to get another cpu's per-cpu "local" lock (qpw_{un,}lock*)
> and also the corresponding queue_percpu_work_on() and flush_percpu_work()
> helpers to run the remote work.
> 
> Users of non-RT kernels but with low latency requirements can select
> similar functionality by using the CONFIG_QPW compile time option.
> 
> On CONFIG_QPW disabled kernels, no changes are expected, as every
> one of the introduced helpers work the exactly same as the current
> implementation:
> qpw_{un,}lock*()        ->  local_{un,}lock*() (ignores cpu parameter)

I find this part of the semantic a bit weird. If we eventually queue
the work, why do we care about doing a local_lock() locally ?

> queue_percpu_work_on()  ->  queue_work_on()
> flush_percpu_work()     ->  flush_work()
> 
> @@ -2840,6 +2840,16 @@ Kernel parameters
>  
>  			The format of <cpu-list> is described above.
>  
> +	qpw=		[KNL,SMP] Select a behavior on per-CPU resource sharing
> +			and remote interference mechanism on a kernel built with
> +			CONFIG_QPW.
> +			Format: { "0" | "1" }
> +			0 - local_lock() + queue_work_on(remote_cpu)
> +			1 - spin_lock() for both local and remote operations
> +
> +			Selecting 1 may be interesting for systems that want
> +			to avoid interruption & context switches from IPIs.

Like Vlastimil suggested, it would be better to just have it off by default
and turn it on only if nohz_full= is passed. Then we can consider introducing
the parameter later if the need arise.

> +#define qpw_lock_init(lock)				\
> +	local_lock_init(lock)
> +
> +#define qpw_trylock_init(lock)				\
> +	local_trylock_init(lock)
> +
> +#define qpw_lock(lock, cpu)				\
> +	local_lock(lock)
> +
> +#define local_qpw_lock(lock)				\
> +	local_lock(lock)

It would be easier to grep if all the APIs start with qpw_* prefix.

qpw_local_lock() ?

> +
> +#define qpw_lock_irqsave(lock, flags, cpu)		\
> +	local_lock_irqsave(lock, flags)
> +
> +#define local_qpw_lock_irqsave(lock, flags)		\
> +	local_lock_irqsave(lock, flags)

ditto?

> +
> +#define qpw_trylock(lock, cpu)				\
> +	local_trylock(lock)
> +
> +#define local_qpw_trylock(lock)				\
> +	local_trylock(lock)

...

> +
> +#define qpw_trylock_irqsave(lock, flags, cpu)		\
> +	local_trylock_irqsave(lock, flags)
> +
> +#define qpw_unlock(lock, cpu)				\
> +	local_unlock(lock)
> +
> +#define local_qpw_unlock(lock)				\
> +	local_unlock(lock)

...

> +
> +#define qpw_unlock_irqrestore(lock, flags, cpu)		\
> +	local_unlock_irqrestore(lock, flags)
> +
> +#define local_qpw_unlock_irqrestore(lock, flags)	\
> +	local_unlock_irqrestore(lock, flags)

...

> +
> +#define qpw_lockdep_assert_held(lock)			\
> +	lockdep_assert_held(lock)
> +
> +#define queue_percpu_work_on(c, wq, qpw)		\
> +	queue_work_on(c, wq, &(qpw)->work)

qpw_queue_work_on() ?

Perhaps even better would be qpw_queue_work_for(), leaving some room for
mystery about where/how the work will be executed :-)

> +
> +#define flush_percpu_work(qpw)				\
> +	flush_work(&(qpw)->work)

qpw_flush_work() ?

> +
> +#define qpw_get_cpu(qpw)	smp_processor_id()
> +
> +#define qpw_is_cpu_remote(cpu)		(false)
> +
> +#define INIT_QPW(qpw, func, c)				\
> +	INIT_WORK(&(qpw)->work, (func))
> +
> @@ -762,6 +762,41 @@ config CPU_ISOLATION
>  
>  	  Say Y if unsure.
>  
> +config QPW
> +	bool "Queue per-CPU Work"
> +	depends on SMP || COMPILE_TEST
> +	default n
> +	help
> +	  Allow changing the behavior on per-CPU resource sharing with cache,
> +	  from the regular local_locks() + queue_work_on(remote_cpu) to using
> +	  per-CPU spinlocks on both local and remote operations.
> +
> +	  This is useful to give user the option on reducing IPIs to CPUs, and
> +	  thus reduce interruptions and context switches. On the other hand, it
> +	  increases generated code and will use atomic operations if spinlocks
> +	  are selected.
> +
> +	  If set, will use the default behavior set in QPW_DEFAULT unless boot
> +	  parameter qpw is passed with a different behavior.
> +
> +	  If unset, will use the local_lock() + queue_work_on() strategy,
> +	  regardless of the boot parameter or QPW_DEFAULT.
> +
> +	  Say N if unsure.

Perhaps that too should just be selected automatically by CONFIG_NO_HZ_FULL and if
the need arise in the future, make it visible to the user?

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

