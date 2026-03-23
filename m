Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1FDF483DD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCAA26B008A; Mon, 23 Mar 2026 14:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B528F6B009D; Mon, 23 Mar 2026 14:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C676B009B; Mon, 23 Mar 2026 14:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE756B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:06:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55B2A8D03E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:24 +0000 (UTC)
X-FDA: 84578107488.16.7B5BE63
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3C2CC4000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Di0v4FD2;
	spf=pass (imf12.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774289182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIMplmnwNNBDeDDwFnU6n7kdo6qPU/KIdyN0enUOUlw=;
	b=N+K9zghL2jdbCK+QHa1uY7B/CrbnQhJoQS24gZJUVEMUayuCz7aRcZbWReXme4b86D3/aw
	6ZXcEyG280VK1+ThYjAT/BYyUpCU+2V/TICpj49sbKEa3697e2iKkrhCx7n/XgY65zH+KA
	AQYrOd4xSYNBNglWLHd3XdkbIz7YcSQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Di0v4FD2;
	spf=pass (imf12.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774289182; a=rsa-sha256;
	cv=none;
	b=o6o3MEaYqO/DDpGCklQWK5cSTCpA59qAMlJp4t9mIFr8IR8HmgttGM1S0V0/YsNMr74gBl
	sJhyO09H+c8W44dhZJpPOop6CPCBhRSrxK8HotFpqt8PvGs1V5wueoVC7y/bKRo2hY9rzp
	/Xz4qhyP7Xeo6FMgnnEcuRw/5qPe4+s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774289181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hIMplmnwNNBDeDDwFnU6n7kdo6qPU/KIdyN0enUOUlw=;
	b=Di0v4FD2zvkjYcr6254H0vTPVSO1OKSyqbSX0Slr8M8JAuSSoKfNukOeBx/zro82bxFD9m
	gIhaVZd86b0MNHpKi2N+kOdI/85N3yQm7AkNkcwmEjYvehhD3+Xvy18XplMit7763XCP5/
	PHR5VDoNrP0dN9HharC7GKR9TG0gMsE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-hcne11SKNN2URATsrr33lw-1; Mon,
 23 Mar 2026 14:06:16 -0400
X-MC-Unique: hcne11SKNN2URATsrr33lw-1
X-Mimecast-MFC-AGG-ID: hcne11SKNN2URATsrr33lw_1774289173
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38D89195609E;
	Mon, 23 Mar 2026 18:06:13 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4183180075B;
	Mon, 23 Mar 2026 18:06:11 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 729D94012CE9D; Mon, 23 Mar 2026 11:36:14 -0300 (-03)
Date: Mon, 23 Mar 2026 11:36:14 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
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
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush
 work
Message-ID: <acFP3tmO4q2DyLZD@tpad>
References: <20260302154945.143996316@redhat.com>
 <20260302155105.214878062@redhat.com>
 <abSH40oW9qiVDXZS@pavilion.home>
 <abb2E3QW7t5Rhxrt@WindFlash>
 <ablYPt92Y63GcIu2@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <ablYPt92Y63GcIu2@localhost.localdomain>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: GAvC757zlXFIybkahG8TnfO44taqYYXYjtbKZNMWvHU_1774289173
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3C2CC4000B
X-Stat-Signature: 1zzmrfsfgtyiai13at6px5k76856oaki
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774289182-182038
X-HE-Meta: U2FsdGVkX19KhkLCTi8oz0fb+83wWlKaIyR8UGKWljxbmiDpYw56RYkpFkQerl/9r4PBmdzGY4dUKRvmuHxSO/b54R3pVPnZ4yWPTuJlkMzXII90Ju+58CXuW0dmQLByQ15kYHf9AiyK+GYp1pvhCMf557w11mbJfuxWHm6ZdPQYKpsjETKp/d8TSLhoG7GZc6F1/km3cTFAVAFIgUN2/xEhjJK7MVaWLHtB9VO9bRXxzwsHb/keMxWed39r+MkaJbT3zLMXm66BWuqGGfJo0j3uTCY3IfeA96OgyCRAmID8oMFddNCvlDlrOH1/wV1721pDzpzDPpjjeDDNj/GfK2ZstOXo31vi//MV4AZ4aQud8Tw6AWRC3ubgPSPX33+P53Q11YDHjDC2A2NDb/ESB7FJpGbdFckA7eiNYEe4ssStOHIsj0vA6teVemJaTlRqEb3b9eoxoP9iAwYLsQlven59vegtVW8/uGzfTZ29t5u5Bzh2SzEdky8W2O6Johw5X3pUX/ik9l4j5xUMHcJ01twXvhU2IXyBq9CAvj1xAiTpIofpC5/2kVGDTyTu5wAGi9RTCYUcfIfLkLU0myQ/2olRpnUbCznIytdlekocUpzz9aJEEik5pAITHkXN8RcYCe5T3x/O7NApJVCHON+jA36qD34CUOqcms7BwsCuGIhthvazBbIO+783109Om98X9X+AOEL9guJ2fo/aMjg5dknJ2dihCwl9hpyT2kBhMScsdGyTdgeIuu7EBgEtZ5uMitIRKrsbjUxkrJq1d//BxG58Gs4Tdhh5VsqNO68fuBuHtP974WB3vSfwcKtNAJDn2fNvvkKQSgBjdNYxpvNWGT3tsPCRFvWlDcLQQYnsLoS1iTIIAVhWva2L3bmv1mu4Tr0RsKjw3AyWOXVTJbkD+48bKXpMKK34j2iKkUlBmTGlg5D7NaC0WC5wNrCeTnR5XGjmBL+h+CUNk3LleZO
 hIlkaQ1E
 6aawt1tG8IEBrxuPgq9gbZg0UnbWSIlBXhBVeuOH1ofMul40dCx9dr4uyzpSxrmffaLofDk+Ex69onNz5Zy3XoDOaxanaPHc3eV4aMNjJf9d3nlimIr+ItC2vNV76yXkhrwmcQwDW68kGNqzkAIP4XLJnTujkRQkwXgEzQtZgkZXDVLYzOcRxjjT/rsX8uQWJQkBgGcS7kyo5JZFcGm5sF6Brf+YOYeEoh18e5AmRorh3LC9AKkB1fL9EPYrVDR4vJ453ZjbvDjhTz3gn/+1cvaCsOoMWsfTiARQ3vGReVH+A52yxkipPZJI6v7s/Ib+yo3gJZAwtTIhWQL6z8UYLsdxupTw0mRzbQimKZqdqhwuq86lNTmBs+xE+Xb4SQCPCYbzUCVo0v+w4P/li+O459kCurM4tpJuSiWyqcZuhFdXBXh4mBA75E3UWoijOgXQIPWTEJg+s1Ob6d3je4WirF7xKptUFgtb8v42qozmtFGS8jO2QPPwv8JAzMVwy4r49awU6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 02:33:50PM +0100, Frederic Weisbecker wrote:
> Le Sun, Mar 15, 2026 at 03:10:27PM -0300, Leonardo Bras a écrit :
> > On Fri, Mar 13, 2026 at 10:55:47PM +0100, Frederic Weisbecker wrote:
> > > I find this part of the semantic a bit weird. If we eventually queue
> > > the work, why do we care about doing a local_lock() locally ?
> > 
> > (Sorry, not sure if I was able to understand the question.)
> > 
> > Local locks make sure a per-cpu procedure happens on the same CPU from 
> > start to end. Using migrate_disable & using per-cpu spinlocks on RT and 
> > doing preempt_disable in non_RT.
> > 
> > Most of the cases happen to have the work done in the local cpu, and just 
> > a few procedures happen to be queued remotely, such as remote cache 
> > draining. 
> > 
> > Even with the new 'local_qpw_lock()' which is faster for cases we are sure 
> > to have local usages, on qpw=0 we have to make qpw_lock() a local_lock as 
> > well, as the cpu receiving the scheduled work needs to make sure to run it 
> > all without moving to a different cpu.
> 
> But queue_work_on() already makes sure the work doesn't move to a different CPU
> (provided hotplug is correctly handled for the work).

commit b01b2141999936ac3e4746b7f76c0f204ae4b445
Author: Ingo Molnar <mingo@kernel.org>
Date:   Wed May 27 22:11:15 2020 +0200

    mm/swap: Use local_lock for protection

    The various struct pagevec per CPU variables are protected by disabling
    either preemption or interrupts across the critical sections. Inside
    these sections spinlocks have to be acquired.

    These spinlocks are regular spinlock_t types which are converted to
    "sleeping" spinlocks on PREEMPT_RT enabled kernels. Obviously sleeping
    locks cannot be acquired in preemption or interrupt disabled sections.

    local locks provide a trivial way to substitute preempt and interrupt
    disable instances. On a non PREEMPT_RT enabled kernel local_lock() maps
    to preempt_disable() and local_lock_irq() to local_irq_disable().

    Create lru_rotate_pvecs containing the pagevec and the locallock.
    Create lru_pvecs containing the remaining pagevecs and the locallock.
    Add lru_add_drain_cpu_zone() which is used from compact_zone() to avoid
    exporting the pvec structure.

    Change the relevant call sites to acquire these locks instead of using
    preempt_disable() / get_cpu() / get_cpu_var() and local_irq_disable() /
    local_irq_save().

    There is neither a functional change nor a change in the generated
    binary code for non PREEMPT_RT enabled non-debug kernels.

    When lockdep is enabled local locks have lockdep maps embedded. These
    allow lockdep to validate the protections, i.e. inappropriate usage of a
    preemption only protected sections would result in a lockdep warning
    while the same problem would not be noticed with a plain
    preempt_disable() based protection.

    local locks also improve readability as they provide a named scope for
    the protections while preempt/interrupt disable are opaque scopeless.

    Finally local locks allow PREEMPT_RT to substitute them with real
    locking primitives to ensure the correctness of operation in a fully
    preemptible kernel.

    [ bigeasy: Adopted to use local_lock ]

> Looks like we are both confused, so let's take a practical example. Suppose
> CPU 0 queues a work to CPU 1 which sets a per-cpu variable named A to the value
> "1". We want to guarantee that further reads of that per-cpu value by CPU 1
> see the new value. With qpw=1, it looks like this:
> 
> CPU 0                                               CPU 1
> -----                                               -----
> 
> qpw_lock(CPU 1)
>    spin_lock(&QPW_CPU1)
> qpw_queue_for(write_A, 1)
>     write_A()
>        A1 = per_cpu_ptr(&A, 1)
>        *A1 = 1
> qpw_unlock(CPU 1)
>     spin_unlock(&QPW_CPU1)
>                                                    read_A()
>                                                        qpw_lock(CPU 1)
>                                                            spin_lock(&QPW_CPU1)
>                                                        r0 = __this_cpu_read(&A)
>                                                        qpw_unlock(CPU 1)
>                                                            spin_unlock(&QPW_CPU1)
>                                                    
> 
> CPU 0 took the spinlock while writing to A, so CPU 1 is guaranteed to further
> observe the new value because it takes the same spinlock (r0 == 1)
> 
> Now look at the qpw=0 case:
>                                   
> CPU 0                                               CPU 1
> -----                                               -----
> 
> qpw_lock(CPU 1)
>    local_lock(&QPW_CPU0)
> qpw_queue_for(write_A, 1)
>     queue_work_on(write_A, CPU 1)
> qpw_unlock(CPU 1)
>     local_unlock(&QPW_CPU0)
>                                                    // workqueue
>                                                    write_A()
>                                                        qpw_lock(CPU 1)
>                                                            local_lock(&QPW_CPU1)
>                                                        A1 = per_cpu_ptr(&A, 1)
>                                                        *A1 = 1
>                                                        qpw_unlock(CPU 1)
>                                                            local_unlock(&QPW_CPU1)
> 
>                                                    read_A()
>                                                        qpw_lock(CPU 1)
>                                                            local_lock(&QPW_CPU1)
>                                                        r0 = __this_cpu_read(&A)
>                                                        qpw_unlock(CPU 1)
>                                                            local_unlock(&QPW_CPU1)
> 
> Here CPU 0 queues the work on CPU 1 which writes and reads the new value
> (r0 == 1). local_lock() / preempt_disable() makes sure the CPU doesn't change.
> 
> But what is the point in doing local_lock(&QPW_CPU0) on CPU 0 ?

To protect certain that structures that are protected by
preempt_disable (non-RT) and migrate_disable (RT).

> > > > 
> > > > @@ -2840,6 +2840,16 @@ Kernel parameters
> > > >  
> > > >  			The format of <cpu-list> is described above.
> > > >  
> > > > +	qpw=		[KNL,SMP] Select a behavior on per-CPU resource sharing
> > > > +			and remote interference mechanism on a kernel built with
> > > > +			CONFIG_QPW.
> > > > +			Format: { "0" | "1" }
> > > > +			0 - local_lock() + queue_work_on(remote_cpu)
> > > > +			1 - spin_lock() for both local and remote operations
> > > > +
> > > > +			Selecting 1 may be interesting for systems that want
> > > > +			to avoid interruption & context switches from IPIs.
> > > 
> > > Like Vlastimil suggested, it would be better to just have it off by default
> > > and turn it on only if nohz_full= is passed. Then we can consider introducing
> > > the parameter later if the need arise.
> > 
> > I agree with having it enabled with isolcpus/nohz_full, but I would 
> > recommend having this option anyway, as the user could disable qpw if 
> > wanted, or enable outside isolcpu scenarios for any reason.
> 
> Do you know any such users? Or suspect a potential usecase? If not we can still
> add that option later. It's probably better than sticking with a useless
> parameter that we'll have to maintain forever.

Someone that does not boot with isolcpus= but uses cgroups for CPU
isolation?

> > > > +#define qpw_lockdep_assert_held(lock)			\
> > > > +	lockdep_assert_held(lock)
> > > > +
> > > > +#define queue_percpu_work_on(c, wq, qpw)		\
> > > > +	queue_work_on(c, wq, &(qpw)->work)
> > > 
> > > qpw_queue_work_on() ?
> > > 
> > > Perhaps even better would be qpw_queue_work_for(), leaving some room for
> > > mystery about where/how the work will be executed :-)
> > > 
> > 
> > QPW comes from Queue PerCPU Work
> > Having it called qpw_queue_work_{on,for}() would be repetitve
> 
> Well, qpw_ just becomes the name of the subsystem and its prefix for APIs.
> For example qpw_lock() doesn't mean that we queue and lock, it only means we lock.
> 
> > But having qpw_on() or qpw_for() would be misleading :) 
> > 
> > That's why I went with queue_percpu_work_on() based on how we have the 
> > original function (queue_work_on) being called.
> 
> That's much more misleading at it doesn't refer to qpw at all and it only
> suggest that it's a queueing a per-cpu workqueue.
> 
> > > Perhaps that too should just be selected automatically by CONFIG_NO_HZ_FULL and if
> > > the need arise in the future, make it visible to the user?
> > > 
> > 
> > I think it would be good to have this, and let whoever is building have the 
> > chance to disable QPW if it doesn't work well for their machines or 
> > workload, without having to add a new boot parameter to continue have 
> > their stuff working as always after a kernel update.
> > 
> > But that is open to discussion :)
> 
> Ok I guess we can stick with the Kconfig at least in the beginning.
> 
> Thanks.
> 
> -- 
> Frederic Weisbecker
> SUSE Labs
> 
> 


