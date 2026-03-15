Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C0EF3026D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 18:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71D606B0089; Sun, 15 Mar 2026 14:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4EE6B008C; Sun, 15 Mar 2026 14:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5A66B0093; Sun, 15 Mar 2026 14:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7BF6B0089
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 14:10:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D72F71A0BE1
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:10:53 +0000 (UTC)
X-FDA: 84549088386.07.3F3DC17
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id D182518000F
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:10:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V1h8VGye;
	spf=pass (imf16.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773598251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFfWUXvwHoJE4xSBTFJR2gnf8f2b6YS0PT0BDPveSGA=;
	b=MAm3GmCLSOs7zKLxw9U8ONfhQBvkjW/V5KUdjwZQ8dCkLst1Z5FeNt2/1Fb1j0C+n11PZI
	OQQjr950HtVkzU1XKyxWED0Ng9NOC5CFQdjWgKnTD5BRmsgEAl2YsjSGSYmdAM3nebF1xN
	OKelv2HP2QurLC8G7ABGtr/dNmBfsyo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V1h8VGye;
	spf=pass (imf16.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773598251; a=rsa-sha256;
	cv=none;
	b=eB5tbluE2DqlSbEUA5P9RDFJD2jbLJcdMrUf9KBuFu0oFHR7yvqcDGN5rTnRxnj/7mZvjF
	d+RS4U3EL2Be7wzXie37fb/U0suN67I7yDFqjKaNXLcRDciA0Mx/FUR6tCwkJFzde4kL8U
	9CoIdvXHXpbHTTHlrE1LHv2KTCKL3n0=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-439b6d9c981so2693304f8f.1
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 11:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773598250; x=1774203050; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wFfWUXvwHoJE4xSBTFJR2gnf8f2b6YS0PT0BDPveSGA=;
        b=V1h8VGyeX5bENgxdOgE5fh2v7kg19rb9edqfyOB9ZZ4WBOG9uJWtII31a7IjrStnI+
         KcNuIvHvOBfM8+nsXpi5HO6P+jD2ExSUHa3kSRwZjzyTD0BdP5D79S0mmwqs4iT9IBGo
         C6Rz4z4akgmCjiLekukLMy/5PUFNEHlJ5IPWnGvZf816eCXIgU5ma7ofNZ6kqePl9Wnp
         isAoPUuCCIfTWwao+aywWZwTIKFFFei6adXtOCkAMK3JQwzjKvtVcNDj7iixb7a+KzUL
         12yjftZBWWAV0aAoRm3H1AXSshgLqSiI8VfzKGYOIRslBmW4ZQGFRhRFE9Sy946OPZCj
         VjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773598250; x=1774203050;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wFfWUXvwHoJE4xSBTFJR2gnf8f2b6YS0PT0BDPveSGA=;
        b=EC40Nw6fH91oAUQGZyOW/O3OVy//cwUXC6+Jh2Nzmn8saIzzAV0ABFJ5leacsWchTQ
         w8ZMa/SSfkD11uOgs0yDc4UsBtDKyIE21dWQruiAFvePAGD854dupLVYPSU6XOXnyH9c
         5G4oeXfp0PmLIgNDR7svbUnqPPl7GjRlXZSCGlIutBfaS7IetbTiQ3uxRV+t6174/Wy3
         rlPtqp0hl7YHI4yj+q6+od8rbIM5VIA6OgmpAwFFjDY/ScZogKvzQZkl2LLly45mMqgy
         AApoScv+Y4wPcB8GZDHjkWyndFtlRxXmge7XIYogl+XLy7BJLtgbAoZ934qQfRbu08xe
         7kiw==
X-Forwarded-Encrypted: i=1; AJvYcCUazpVhKvjK3yoqJnrVBZT062q62c+AtSC3z4OIwiSIWg3s9mNFzx006+QdVly0toGL/N/RdPR/sw==@kvack.org
X-Gm-Message-State: AOJu0YywRvCTFlSPQsFDVBjZA1QFGIy9GT/DeahWecF1GjVqF8AsjFmP
	T2QIXSPlwm3V6F2wsXUfgspakmK3mh9D3IwFOyHR4jwpOpfRDpTrOz8ZrzCtEQ==
X-Gm-Gg: ATEYQzzP/SoQU1Qa7711FS9urPeBXnIGVFQpfayj+vBZRHdCCUHn8h3eUerHvA/8NOi
	IlIRjwPUQp1IXsINWaozFqmk6RbtyuOHrh88hscThiw1WJGqvD7VWLvaAISS5BboC0KuOBCbCm7
	/FqhlLdG7my5hN5vd8ud/l36eoZ/1w70vgN9IU+cFfgtDsAHeoXSmPyUqGjFEB+2TsbC82mhRkZ
	CGSCRx50R9GZS6p73ie6cvA01ExeHiwOqf5FenyduT16wjtFeDcjbZfOPBFAbeR/FbZFdnJof0c
	n8AhzslS8FmUqknnr1mFlS4JLe03SwZ3DWvR6oSyDjv312RlE7cAnV/0BfTcV7sQSoTtUj9qNsC
	LafnEQwgmk/Lfshc7PbDGA0GuIh02uH5eMRBxWUggFkxsjhfkVnWc9uchL2NA4ESs2fyCUXBj02
	zg65G5RHwqsC+1ynR9dE/ybie1gLx7zmYRCAs=
X-Received: by 2002:a05:6000:40db:b0:439:b3bc:4608 with SMTP id ffacd0b85a97d-43a04d80c26mr19640290f8f.7.1773598250045;
        Sun, 15 Mar 2026 11:10:50 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe1a76e5sm34632151f8f.12.2026.03.15.11.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 11:10:49 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush work
Date: Sun, 15 Mar 2026 15:10:27 -0300
Message-ID: <abb2E3QW7t5Rhxrt@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <abSH40oW9qiVDXZS@pavilion.home>
References: <20260302154945.143996316@redhat.com> <20260302155105.214878062@redhat.com> <abSH40oW9qiVDXZS@pavilion.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8t5x84cq8rm43q91wo4yz6tg6r9f57mi
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D182518000F
X-HE-Tag: 1773598251-248699
X-HE-Meta: U2FsdGVkX18EbdLvB9VO/kxnz/mn9I9HRAhDDvHj8uUfWl3ZdadDw+o+20UoentBsFShAGXF0vz7g9Or9TQ05LnKy0ZWEejJ68qsHg/zuSyUiTfTlIVX6EMlgi2KMHIPE0z776MAltRDANcjrjoh7Q51gbDdwS+sF/GdH8+HZFUu+U441DEYfJ9pwirbZeYEDo9HYRU6JVXj6Pg8tiEQfIF7Ae7XM+xfxo6MPe9jYRwo+iS+domrJtYaJtl57s7F5H+/du2jpVZV8PHV0+l8vp+Dy/1qzzJ4/5TuAPLsIJFh/If3r7TtTPIowdahq3ya14ijEkFq+bgeFpnagFSY7vuFtIGsDNRn8pG8bXF75hrd7sbS5c6299MOBsyvKXAFjJgXySRP0R+toGtqNuRqsujbrWXYxpCE4xZNFvWlnBO4frCVy2v0ppUITLqxVzQzb/Yfljw/9APTC2+2mX0880d/+TPiXOyl9lNcMK5lKS99F/XpJElygiKThOVGIXS59Ihl5usEyKE7B8BLC/f75ov3c+8EqeHxAcFDJKA8I0vcEeeeGa0dXlLzfjxhvtH9WkV4Dw++mGIijL+6fGZSIecy1k345iDoipRTpqU9lecOdQVBBCpDBKPQL45nQuCyS2lqoOwQetp1X41n8BuPLLWTRphwUtE9uLLrz5jr5Z8NJuY9B3G6piD+an+gmP2dQoxqQI5Wi5ANw5xUIl+SQne6AZgg2lgI6Uw7YwLv0md1vVRp1rEl1eGPe1bL26mCFP6Q46dPwuCBnAvcEosANmqI23aUlp6okgt9KJxyto5kGUDDRfiiYr3JnADqHHjR3Y9AyRML/bZWYC5/L9go0pqFe3rsBG5TspK0N8hD46moM0Cszj5auzpTgJgXQMMQrIjV1mPg/LRh1cNU0y7gckyRVOnYx4cwtVtNE0PhAeasTXPfIWGM/slWz00nqJUfeBf8K5WA1KLjsEsW4fX
 ZeVWHWMa
 RmFM7ZUoQEMyGAzGDe2Il1RwwcjhNIi+vBx0nWfT4VX1s8QTKHsMuHUYiMThngZQRVeQNq+rQRpc5VXI//lFn7mIKNiDLPGQouGdbX99XIhecKc3GLMro2MjhoLCKdpKb4yqmz9RXyDUpNFiC+eEw7mkU8fPTzEB0006c9klsaPjRi08Xt45RS/wsECqRrzdnjv/Itrjz/GKcpo0j4M+e3OEF0jlZ87cjjGnlyi5X/zwkyPTIgdL2CiQPVtqM2DKqhdgxb0gJUtwyNah3B8DNXLhLHwmqBCNuIDr/2j448KVOHMD9IYvPuy7eVmu7qapMxUvqxZt7IScM/sOHJ8Y/+ox7k35OE9RuQ44/yetheZofF7Y3+NVdVd2qiYAq9i06I+Ovec6V7J9GasGFRZBB6i6XWhpeh/efw5W2dAwsqs0qCe3isqmL6pU/QKTkSv8VbliejGPc/8MYlo9b94LT5055y2mQa28bpXt3tlemxVQsxcouG5IxugguSM/hFUGW8VylKUjSeBmSEXaRxeEEaz41FxWpfu+2I7623nv0im5bhOyCf3U0YxbSjhrY9MNNf62YXq+/fxaRhLMWHzMof1UL5jzKoiiRLvzFTpm9YwuGWorUfDw9oiz7uBVh0TUpvxijhsSFSC02kM/Bghpdq6z+KYzmfkaBAxFcODtgf7cdceixwi1KA5+G9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 10:55:47PM +0100, Frederic Weisbecker wrote:
> Le Mon, Mar 02, 2026 at 12:49:47PM -0300, Marcelo Tosatti a écrit :
> > Some places in the kernel implement a parallel programming strategy
> > consisting on local_locks() for most of the work, and some rare remote
> > operations are scheduled on target cpu. This keeps cache bouncing low since
> > cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > kernels, even though the very few remote operations will be expensive due
> > to scheduling overhead.
> > 
> > On the other hand, for RT workloads this can represent a problem:
> > scheduling work on remote cpu that are executing low latency tasks
> > is undesired and can introduce unexpected deadline misses.
> > 
> > It's interesting, though, that local_lock()s in RT kernels become
> > spinlock(). We can make use of those to avoid scheduling work on a remote
> > cpu by directly updating another cpu's per_cpu structure, while holding
> > it's spinlock().
> > 
> > In order to do that, it's necessary to introduce a new set of functions to
> > make it possible to get another cpu's per-cpu "local" lock (qpw_{un,}lock*)
> > and also the corresponding queue_percpu_work_on() and flush_percpu_work()
> > helpers to run the remote work.
> > 
> > Users of non-RT kernels but with low latency requirements can select
> > similar functionality by using the CONFIG_QPW compile time option.
> > 
> > On CONFIG_QPW disabled kernels, no changes are expected, as every
> > one of the introduced helpers work the exactly same as the current
> > implementation:
> > qpw_{un,}lock*()        ->  local_{un,}lock*() (ignores cpu parameter)
> 
> I find this part of the semantic a bit weird. If we eventually queue
> the work, why do we care about doing a local_lock() locally ?

(Sorry, not sure if I was able to understand the question.)

Local locks make sure a per-cpu procedure happens on the same CPU from 
start to end. Using migrate_disable & using per-cpu spinlocks on RT and 
doing preempt_disable in non_RT.

Most of the cases happen to have the work done in the local cpu, and just 
a few procedures happen to be queued remotely, such as remote cache 
draining. 

Even with the new 'local_qpw_lock()' which is faster for cases we are sure 
to have local usages, on qpw=0 we have to make qpw_lock() a local_lock as 
well, as the cpu receiving the scheduled work needs to make sure to run it 
all without moving to a different cpu.

> 
> > queue_percpu_work_on()  ->  queue_work_on()
> > flush_percpu_work()     ->  flush_work()

btw Marcelo, I think we need to do add the local_qpw_lock here as well, or 
change the first line to '{local_,}qpw_{un,}lock*()'

> > 
> > @@ -2840,6 +2840,16 @@ Kernel parameters
> >  
> >  			The format of <cpu-list> is described above.
> >  
> > +	qpw=		[KNL,SMP] Select a behavior on per-CPU resource sharing
> > +			and remote interference mechanism on a kernel built with
> > +			CONFIG_QPW.
> > +			Format: { "0" | "1" }
> > +			0 - local_lock() + queue_work_on(remote_cpu)
> > +			1 - spin_lock() for both local and remote operations
> > +
> > +			Selecting 1 may be interesting for systems that want
> > +			to avoid interruption & context switches from IPIs.
> 
> Like Vlastimil suggested, it would be better to just have it off by default
> and turn it on only if nohz_full= is passed. Then we can consider introducing
> the parameter later if the need arise.

I agree with having it enabled with isolcpus/nohz_full, but I would 
recommend having this option anyway, as the user could disable qpw if 
wanted, or enable outside isolcpu scenarios for any reason.

> 
> > +#define qpw_lock_init(lock)				\
> > +	local_lock_init(lock)
> > +
> > +#define qpw_trylock_init(lock)				\
> > +	local_trylock_init(lock)
> > +
> > +#define qpw_lock(lock, cpu)				\
> > +	local_lock(lock)
> > +
> > +#define local_qpw_lock(lock)				\
> > +	local_lock(lock)
> 
> It would be easier to grep if all the APIs start with qpw_* prefix.
> 
> qpw_local_lock() ?

Sure, not against the change.
And sure, would need to change all versions starting with local_ .

> 
> > +
> > +#define qpw_lock_irqsave(lock, flags, cpu)		\
> > +	local_lock_irqsave(lock, flags)
> > +
> > +#define local_qpw_lock_irqsave(lock, flags)		\
> > +	local_lock_irqsave(lock, flags)
> 
> ditto?
> 
> > +
> > +#define qpw_trylock(lock, cpu)				\
> > +	local_trylock(lock)
> > +
> > +#define local_qpw_trylock(lock)				\
> > +	local_trylock(lock)
> 
> ...
> 
> > +
> > +#define qpw_trylock_irqsave(lock, flags, cpu)		\
> > +	local_trylock_irqsave(lock, flags)
> > +
> > +#define qpw_unlock(lock, cpu)				\
> > +	local_unlock(lock)
> > +
> > +#define local_qpw_unlock(lock)				\
> > +	local_unlock(lock)
> 
> ...
> 
> > +
> > +#define qpw_unlock_irqrestore(lock, flags, cpu)		\
> > +	local_unlock_irqrestore(lock, flags)
> > +
> > +#define local_qpw_unlock_irqrestore(lock, flags)	\
> > +	local_unlock_irqrestore(lock, flags)
> 
> ...
> 
> > +
> > +#define qpw_lockdep_assert_held(lock)			\
> > +	lockdep_assert_held(lock)
> > +
> > +#define queue_percpu_work_on(c, wq, qpw)		\
> > +	queue_work_on(c, wq, &(qpw)->work)
> 
> qpw_queue_work_on() ?
> 
> Perhaps even better would be qpw_queue_work_for(), leaving some room for
> mystery about where/how the work will be executed :-)
> 

QPW comes from Queue PerCPU Work
Having it called qpw_queue_work_{on,for}() would be repetitve
But having qpw_on() or qpw_for() would be misleading :) 

That's why I went with queue_percpu_work_on() based on how we have the 
original function (queue_work_on) being called.

> > +
> > +#define flush_percpu_work(qpw)				\
> > +	flush_work(&(qpw)->work)
> 
> qpw_flush_work() ?

Same as above,
qpw_flush() ?

> 
> > +
> > +#define qpw_get_cpu(qpw)	smp_processor_id()
> > +
> > +#define qpw_is_cpu_remote(cpu)		(false)
> > +
> > +#define INIT_QPW(qpw, func, c)				\
> > +	INIT_WORK(&(qpw)->work, (func))
> > +
> > @@ -762,6 +762,41 @@ config CPU_ISOLATION
> >  
> >  	  Say Y if unsure.
> >  
> > +config QPW
> > +	bool "Queue per-CPU Work"
> > +	depends on SMP || COMPILE_TEST
> > +	default n
> > +	help
> > +	  Allow changing the behavior on per-CPU resource sharing with cache,
> > +	  from the regular local_locks() + queue_work_on(remote_cpu) to using
> > +	  per-CPU spinlocks on both local and remote operations.
> > +
> > +	  This is useful to give user the option on reducing IPIs to CPUs, and
> > +	  thus reduce interruptions and context switches. On the other hand, it
> > +	  increases generated code and will use atomic operations if spinlocks
> > +	  are selected.
> > +
> > +	  If set, will use the default behavior set in QPW_DEFAULT unless boot
> > +	  parameter qpw is passed with a different behavior.
> > +
> > +	  If unset, will use the local_lock() + queue_work_on() strategy,
> > +	  regardless of the boot parameter or QPW_DEFAULT.
> > +
> > +	  Say N if unsure.
> 
> Perhaps that too should just be selected automatically by CONFIG_NO_HZ_FULL and if
> the need arise in the future, make it visible to the user?
> 

I think it would be good to have this, and let whoever is building have the 
chance to disable QPW if it doesn't work well for their machines or 
workload, without having to add a new boot parameter to continue have 
their stuff working as always after a kernel update.

But that is open to discussion :)

Thanks!
Leo

