Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB90CE9A777
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDE0D6B0089; Tue, 24 Mar 2026 07:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E546B008A; Tue, 24 Mar 2026 07:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D016B008C; Tue, 24 Mar 2026 07:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C773C6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:54:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1714613CF43
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:54:23 +0000 (UTC)
X-FDA: 84580798806.09.0DB68ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 56D7512000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:54:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bIil1+D0;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774353261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5Ok9jjqyoj87nwGTsC8cHy0SjZ1xkM4kmzPt7cXVJ8=;
	b=T1svqHPpmB8XemFqRW/snPEwGqFRPMKBUUUJlwzD4QgUqzGVhFGjW+Sii5ga/+RKF9NRNL
	XYbGhB/jwGlMb68672jqi7/eInb4ZW5UVpOGIw2HgD5iTqIQI/rMV7ZuVwAHUKBlf5JVAv
	KgbzUw+fq2ZR9wTShaihk0g9rhIS1aU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bIil1+D0;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774353261; a=rsa-sha256;
	cv=none;
	b=TIepRNTZhYQV7gPwVyG0nkQ5P3yewDIy9aNTzUfJoHK2pBYXWapCtvaeDXsyQZwtXxC4Ae
	bZigN9ybEsLQtKfqC2DbLs1chf49h29MWMqZT6E8+Igh7JAq1BIAMzy2VcCX/bRmsgwIi6
	pWd33SHm/+AQI7X2XNaeqj7oGq8acJc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 481FD43F2D;
	Tue, 24 Mar 2026 11:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9ACC19424;
	Tue, 24 Mar 2026 11:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774353260;
	bh=Tr3Vmb2eq7lSIBl9SEYAnwibaXljX6iPVyzyEPnF7nQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bIil1+D0ujEoY/ObJTXUKsjUfxhuEveQu7yH+IO4xvlpH/g0iD//VowTSWws0funq
	 glxaEosBsuFP135TzvOKllwMhT/XGC5ogdhhbcL66vaPlQ9OjCVugvJQG579yRyGV/
	 8pQH4XPl+jrG5mC9+x5Qb0zBWtp/iQrGWPQk4bTWU8dKtmMoSeMNklAJK9wGquePBK
	 l+/0Ph+8p7T69rqgdG2GlWD/4fPlVrBwn6K22qK22GhMMb8lRZK0IaZ1AEK5RdJI4b
	 FKVLvBAuupoEZIyvKkn9Wh6tZ6lPkCs1beEzASbqe/u0GmKeCSo1+mmBv3HZjwu/Qz
	 bqeh33g8frR+A==
Date: Tue, 24 Mar 2026 12:54:17 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <acJ7aS7Pt3KknN1B@localhost.localdomain>
References: <20260302154945.143996316@redhat.com>
 <20260302155105.214878062@redhat.com>
 <abSH40oW9qiVDXZS@pavilion.home>
 <abb2E3QW7t5Rhxrt@WindFlash>
 <ablYPt92Y63GcIu2@localhost.localdomain>
 <acCZsEOsrv5Ku-mu@WindFlash>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acCZsEOsrv5Ku-mu@WindFlash>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 56D7512000D
X-Stat-Signature: a4x71yfhgrq6onp6pr7ceknr8hsa3zy1
X-Rspam-User: 
X-HE-Tag: 1774353261-836952
X-HE-Meta: U2FsdGVkX18TLvzR4a8pokY4syhy8rMg7dzytEivWza/6CGE7WvNSF4jG3mU5NpqJta2tHNx4woUaGESmQvzN0Xj/FnmNAG3A0x4JtARsG884ZDFeuy4UHY8i0HkGLkS6u2ayR6ZwV/kNnDniu71g5rJ4AtrsSHMup0kGwm8FUxszC+SKZIciUHivHzWO4ReHUVxch9xOGN+8QDJuTEUpk2c6xsf54yRlG9W9Kh7nqS2FFgqGND8dmQ6dyMzbMkjf5pzAFMdhq7UIYiYDM5QzKsQT+eHAQOe+l42678JW4d9SJmwzjc4QHOuyAgTfOjdA7AJbD/pF4IOH7WVI/npSft7PmY/wg0b9idcPWBb+d3BrvuKV2oSJgAY+jDUxPAhxXtW+e3H/FEbd4xEZYhPctHH2ymjCsMQaqegOL1FZrmlOCuKc1XqcI1zpjebnsDlwl8Xw+ZWp8Arv2mxjSrZFAyY1nvSh/hLnl8tD0ao7rGIS5zryA0ztK05ypVh3XrpAQsJRBHBvTvHLKqEm8oM3KaSW1vIfpiqcqCf5y4F1qd7h6F97eUZJAIIhL1glqFcZqJO8lAEH7jPqgbmYosrq3KDZRPD2kt06ymTf1LVbv6zabQ1W3jHfDAgldZlxVmhd/DuyECrrsiprstzEcyQLjY/x3xghlF50Kt8rwSCgB0vfovQdniEKigDGJAyFZ33Z1sLDHcFUonXDIu1lj4naoh3rTfgNVHJovaOkFbwXxQ8rEqdb+WBUxl/OWJIReuQYSMFBdZoo6rOSQP1pgJ4PLQnmTPf3IjH8oc5zHR0dfpyCU319FzPiu/CpluIeUXqJpEseOOOXM7GbsPpGxLlzVMS0Sqkg/QI92T8nlnX+3vA0csk7OHCIJ9c1WqXyWCM30OCSGyxgUnzVUFV8YVIBvKqbZRxzSZ1eEWhvY0AyQymqiNj82QZNHGFxtKCSRoQ6pXlc9yhR2V9u3ZARAG
 7TbOlMHn
 TykKln7jRXDsGKV9OFvaHvOuTrQny/VK8zgHYqBU4/mLB9wXLaL7exsLPLLyT8N26tKq4Zl/8UjSTPy//t/Cg/hz+RN7V8IC3JcvkP0eA4VDZ8P/X0IApkppF8RSPbqmnZqEmohPuIM7g1zYlZ0RplINljO8EXyUhlcZUjnLk4nEZgqT7kaQXLmBIWa+lt6eWyvCOi71M83AB/UQAQlEhLipBMAHh6CIF2hfDiM99UJHXtrk78I0C/K6tfsQ4crUHhc5F6YfmPuT++KjQt+l3zz41XUHUjiezYP024xBTT6z8ZS8nQC9/WpGIEip2bdbOm7Mu0JJCdlufrWaoYfEKU7YDkxTE2+TPh1nqfGluaV6NTKsLxw2KCjG1f8YUOa3bn/wH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Sun, Mar 22, 2026 at 10:38:56PM -0300, Leonardo Bras a écrit :
> On Tue, Mar 17, 2026 at 02:33:50PM +0100, Frederic Weisbecker wrote:
> > Le Sun, Mar 15, 2026 at 03:10:27PM -0300, Leonardo Bras a écrit :
> > > On Fri, Mar 13, 2026 at 10:55:47PM +0100, Frederic Weisbecker wrote:
> > > > I find this part of the semantic a bit weird. If we eventually queue
> > > > the work, why do we care about doing a local_lock() locally ?
> > > 
> > > (Sorry, not sure if I was able to understand the question.)
> > > 
> > > Local locks make sure a per-cpu procedure happens on the same CPU from 
> > > start to end. Using migrate_disable & using per-cpu spinlocks on RT and 
> > > doing preempt_disable in non_RT.
> > > 
> > > Most of the cases happen to have the work done in the local cpu, and just 
> > > a few procedures happen to be queued remotely, such as remote cache 
> > > draining. 
> > > 
> > > Even with the new 'local_qpw_lock()' which is faster for cases we are sure 
> > > to have local usages, on qpw=0 we have to make qpw_lock() a local_lock as 
> > > well, as the cpu receiving the scheduled work needs to make sure to run it 
> > > all without moving to a different cpu.
> > 
> > But queue_work_on() already makes sure the work doesn't move to a different CPU
> > (provided hotplug is correctly handled for the work).
> > 
> > Looks like we are both confused, so let's take a practical example. Suppose
> > CPU 0 queues a work to CPU 1 which sets a per-cpu variable named A to the value
> > "1". We want to guarantee that further reads of that per-cpu value by CPU 1
> > see the new value. With qpw=1, it looks like this:
> > 
> > CPU 0                                               CPU 1
> > -----                                               -----
> > 
> > qpw_lock(CPU 1)
> >    spin_lock(&QPW_CPU1)
> > qpw_queue_for(write_A, 1)
> >     write_A()
> >        A1 = per_cpu_ptr(&A, 1)
> >        *A1 = 1
> > qpw_unlock(CPU 1)
> >     spin_unlock(&QPW_CPU1)
> >                                                    read_A()
> >                                                        qpw_lock(CPU 1)
> >                                                            spin_lock(&QPW_CPU1)
> >                                                        r0 = __this_cpu_read(&A)
> >                                                        qpw_unlock(CPU 1)
> >                                                            spin_unlock(&QPW_CPU1)
> >                                                    
> > 
> > CPU 0 took the spinlock while writing to A, so CPU 1 is guaranteed to further
> > observe the new value because it takes the same spinlock (r0 == 1)
> > 
> 
> Here, if we are in CPU0 we should never take the qpw_lock(CPU1) unless we 
> are inside queue_percpu_work_on().
> 
> Maybe I am not getting your use case :/
> 
> Also, I don't see a case where we would need to call 
> queue_percpu_work_on() inside a qpw_lock(). This could be dangerous as it 
> could be the case in another cpu and cause a deadlock:
> 
> CPU 0 				CPU 1
> qpw_lock(0)			qpw_lock(1)
> ...				...
> queue_percpu_work_on()		queue_percpu_work_on()
> 	qpw_lock(1)			qpw_lock(0)

Ok I just checked the practical usecase in the patchset and it was me not
getting your usecase. The qpw lock is used inside the work itself. And now
that makes sense.

> 
> 
> > Now look at the qpw=0 case:
> >                                   
> > CPU 0                                               CPU 1
> > -----                                               -----
> > 
> > qpw_lock(CPU 1)
> >    local_lock(&QPW_CPU0)
> > qpw_queue_for(write_A, 1)
> >     queue_work_on(write_A, CPU 1)
> > qpw_unlock(CPU 1)
> >     local_unlock(&QPW_CPU0)
> >                                                    // workqueue
> >                                                    write_A()
> >                                                        qpw_lock(CPU 1)
> >                                                            local_lock(&QPW_CPU1)
> >                                                        A1 = per_cpu_ptr(&A, 1)
> >                                                        *A1 = 1
> >                                                        qpw_unlock(CPU 1)
> >                                                            local_unlock(&QPW_CPU1)
> > 
> >                                                    read_A()
> >                                                        qpw_lock(CPU 1)
> >                                                            local_lock(&QPW_CPU1)
> >                                                        r0 = __this_cpu_read(&A)
> >                                                        qpw_unlock(CPU 1)
> >                                                            local_unlock(&QPW_CPU1)
> > 
> > Here CPU 0 queues the work on CPU 1 which writes and reads the new value
> > (r0 == 1). local_lock() / preempt_disable() makes sure the CPU doesn't change.
> > 
> > But what is the point in doing local_lock(&QPW_CPU0) on CPU 0 ?
> 
> I can't see the case where one would need to hold the qpw_lock while 
> calling queue_percpu_work_on(). Holding the qpw_lock() (as is the case of
> local_lock()) should be done only when one is working on data particular to 
> that cpu structures. Queuing work on other CPU while touching this cpu data 
> is unexpected to me.

Yep!

> > > > Like Vlastimil suggested, it would be better to just have it off by default
> > > > and turn it on only if nohz_full= is passed. Then we can consider introducing
> > > > the parameter later if the need arise.
> > > 
> > > I agree with having it enabled with isolcpus/nohz_full, but I would 
> > > recommend having this option anyway, as the user could disable qpw if 
> > > wanted, or enable outside isolcpu scenarios for any reason.
> > 
> > Do you know any such users? Or suspect a potential usecase? If not we can still
> > add that option later. It's probably better than sticking with a useless
> > parameter that we'll have to maintain forever.
> 
> Out of my head, I can think only on HPC scenario where user wants to make 
> use of the regular/RT scheduler for many small workloads, but doesn't like 
> the impact of IPI on those cases.

There are many more IPIs to care about then. I suspect the issue would be more
about the workqueue itself.

> Such systems that explore memory at it's 
> limit will also benefit from those, for example, if cache gets drained 
> remotely very often.
> 
> None of those necessarily will need to or benefit from isolcpus, and may 
> want to just use the kernel scheduler policies.

This sounds like "just in case" usecases that could be dealt with later if
needed. But like Marcelo said, those who want to rely on cpuset isolated
partitions would need to enable that on boot.

> > > QPW comes from Queue PerCPU Work
> > > Having it called qpw_queue_work_{on,for}() would be repetitve
> > 
> > Well, qpw_ just becomes the name of the subsystem and its prefix for APIs.
> > For example qpw_lock() doesn't mean that we queue and lock, it only means we lock.
> > 
> 
> Locks for queue'ing per-cpu work. :D

Right!

> 
> > > But having qpw_on() or qpw_for() would be misleading :) 
> > > 
> > > That's why I went with queue_percpu_work_on() based on how we have the 
> > > original function (queue_work_on) being called.
> > 
> > That's much more misleading at it doesn't refer to qpw at all and it only
> > suggest that it's a queueing a per-cpu workqueue.
> > 
> 
> Humm, maybe qpw_queue_for/on()?
> 
> Or maybe change the name of the API for pw:
> pw_lock()/unlock
> pw_queue();
> pw_flush()
> 
> and so on?
> 
> That way it stays true to what means :)

Would better to keep the same prefix for all APIs :-)

-- 
Frederic Weisbecker
SUSE Labs

