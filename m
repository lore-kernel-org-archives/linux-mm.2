Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B07FFD88C3
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 22:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152086B0088; Tue, 10 Mar 2026 18:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6606B0089; Tue, 10 Mar 2026 18:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F234B6B008A; Tue, 10 Mar 2026 18:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE4C66B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:14:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B198A140377
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:14:33 +0000 (UTC)
X-FDA: 84531558426.03.88F8F52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3D39D40009
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:14:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H3xEWPdp;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773180872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGmWPq6QSd1QWpK2PfmMRRA2SCr9U/FSWBK3JF5N1cU=;
	b=KEWiBChvXFy70mtf7hZ1HZxj4O8zEo5vJNO9H54SJ1eSwisSdXgLvCCvYVRddTn6PDrr5m
	TMUaTlh8LH+UoSK8/0Nk7NR9S9xt8ky0P4RCfHZu24GJgR6lAdDI7e50YwNo1HVKfAJena
	i2B9cxZBFw7IqGbm+ZYVvPH/rj0ue1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773180872; a=rsa-sha256;
	cv=none;
	b=Xu3Mn1dYsbSBkMh6PsBK7So92DL8GI6Nj4zcMQnZjGgSx9r44pFflaGwBQnE7FGfrdSmRu
	4phYb2JjstJSVfXKgJq5zPkvSpR40QNIt50v3g3CxGpXDjzk9qBfPH8xEpw0w4lYtGxfDH
	t7SVQEHejuIPMPq0B7T2ty7H96G+H8c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H3xEWPdp;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E69F60131;
	Tue, 10 Mar 2026 22:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6610C19423;
	Tue, 10 Mar 2026 22:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773180871;
	bh=2LNNTUmBqtO5SmWcgIzMSfKem41SdrpfZxaik99VIGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H3xEWPdp48GuEXQBuaHPzU5b12T4494AsA+9u3S8buE6SakGwCFJFLDQCPwxiwQTI
	 9HG5eLkD9b5DE5yrFkpAr/IOXDb5MMfXK9rffO4JV+vnpGkC+or4AASmZqK1+xCY5B
	 hHZZvKcowjwvto1MpcywIrH6PUuE07Mq8fcgByTglOQRFcydCKsBNo2BIy8LSjmeL3
	 z9l6XX/Eu6yyiLAXXLnUe5g3TBfiPQX20CTao2vVR6xKKet5FwGbzANKYlxOlwRZrc
	 oiiRBrokQPzAwHNVSPvjDGPkeHmgTudSorj54jgc3pclQkDSdM5ontmjyXmp9UWDjq
	 WO/o4+coy4+3Q==
Date: Tue, 10 Mar 2026 23:14:28 +0100
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
Subject: Re: [PATCH v2 0/5] Introduce QPW for per-cpu operations (v2)
Message-ID: <abCXxGdFUNBp--nP@pavilion.home>
References: <20260302154945.143996316@redhat.com>
 <aam1cHq3_fb-T1HH@localhost.localdomain>
 <abBQ40Zkk76Zej8i@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abBQ40Zkk76Zej8i@tpad>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3D39D40009
X-Stat-Signature: qmwirp9p1y4fheshqjt6xd36dum3ob5m
X-Rspam-User: 
X-HE-Tag: 1773180872-873131
X-HE-Meta: U2FsdGVkX1/ItXXYdjh0/wp1PDzvKO9TfhmLMJj8RIwpfr04YuW6R4hlKm7c4j/eFwqmbKSXosqCZwiVa8lbgY6s9JTB9xMpBgRHVw0qKcefo1wq8cylrLL1wT6+PzyUU5x2ZCWHaQAO9jk7ySelGeXQ+l+b10+aN0rKWhgrBFHe7XwlIaY+pCSgUjBDC61tzLQvTTHnWoV8oZVlX+AV9SGX0VHuPqmb83EXnQHgnZZJUIrNScHC7lZkJGG+u/YVXl1bKkxdZZ5Ko3vjCq4q70zB6qNEi/1/L4o1Dfvcw6U9ni9yvq84SuFpDSKsRQsC5WO9DrJ9o+wzwNoXissfW1ENlzGPUSXkoYIaSk/Yhza/sqOih/xT/3iSNzqYp0J/0VOtY8zU2Je8mgeNID0s7KYbbQwOodaEGA1P2DJzD/HN35mE5Zu2HWW/4U2E0ovlAJOA4fkMP9Q83tZJRXjD6X3QfV4IiPKDlmZghBO3Rb7gpaCjE+g/WIC9+Tmgd3HWPrLbzt9Ml6vvHkYyH6LNEl5YNjzaVXlyHfFDV42nErKuShxZ1MHUrPAHDVFaZpELLudE7Ttoa3qhRzwD6wAHUnc5EHcgmlINvdD1iLTdXZOQOW1nCBLzrwJgeS55sedKFIX8CjL/hJyZI+p4igI1FavaBxapwTf3Z0ORa7kLRPgJEkVJkamWGSnGbnNXeVzq5mrAhJhTpX+Fn7XWrsfMVfIcg/cviiXiZ85VpoKaamcLmGgg7Kn0uJMd2XhltOxpRnLKEYWwEWRjCqqo4SIe8UOCoFuzsGX2HcRJyFIWxvrhNUrh9LtAxayq4+f3lGp4JWjs36K8vQDG6BxXujTp0BzNtCUtOw1o7hglffWWFEw7CsamnS50RQRjJzVSlmmTFTdl5cfPvbQ9jYm1+Eo5rjoCrdD5b3seDMH8/CwcOUsM9Dt50jOjfP8VFYeThN1AydVX+AX9NEKdAaeiPRz
 4yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Mar 10, 2026 at 02:12:03PM -0300, Marcelo Tosatti a écrit :
> Hi Frederic,
> 
> On Thu, Mar 05, 2026 at 05:55:12PM +0100, Frederic Weisbecker wrote:
> > Le Mon, Mar 02, 2026 at 12:49:45PM -0300, Marcelo Tosatti a écrit :
> > > The problem:
> > > Some places in the kernel implement a parallel programming strategy
> > > consisting on local_locks() for most of the work, and some rare remote
> > > operations are scheduled on target cpu. This keeps cache bouncing low since
> > > cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > > kernels, even though the very few remote operations will be expensive due
> > > to scheduling overhead.
> > > 
> > > On the other hand, for RT workloads this can represent a problem: getting
> > > an important workload scheduled out to deal with remote requests is
> > > sure to introduce unexpected deadline misses.
> > > 
> > > The idea:
> > > Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> > > In this case, instead of scheduling work on a remote cpu, it should
> > > be safe to grab that remote cpu's per-cpu spinlock and run the required
> > > work locally. That major cost, which is un/locking in every local function,
> > > already happens in PREEMPT_RT.
> > > 
> > > Also, there is no need to worry about extra cache bouncing:
> > > The cacheline invalidation already happens due to schedule_work_on().
> > > 
> > > This will avoid schedule_work_on(), and thus avoid scheduling-out an
> > > RT workload.
> > > 
> > > Proposed solution:
> > > A new interface called Queue PerCPU Work (QPW), which should replace
> > > Work Queue in the above mentioned use case.
> > > 
> > > If CONFIG_QPW=n this interfaces just wraps the current
> > > local_locks + WorkQueue behavior, so no expected change in runtime.
> > > 
> > > If CONFIG_QPW=y, and qpw kernel boot option =1, 
> > > queue_percpu_work_on(cpu,...) will lock that cpu's per-cpu structure
> > > and perform work on it locally. This is possible because on 
> > > functions that can be used for performing remote work on remote 
> > > per-cpu structures, the local_lock (which is already
> > > a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> > > is able to get the per_cpu spinlock() for the cpu passed as parameter.
> > 
> > So let me summarize what are the possible design solutions, on top of our discussions,
> > so we can compare:
> > 
> > 1) Never queue remotely but always queue locally and execute on userspace
> >    return via task work.
> 
> How can you "queue locally" if the request is visible on a remote CPU?
> 
> That is, the event which triggers the manipulation of data structures 
> which need to be performed by the owner CPU (owner of the data
> structures) is triggered on a remote CPU.
> 
> This is confusing.
> 
> Can you also please give a practical example of such case ?

Right so in the case of LRU batching, it consists in always queue
locally as soon as there is something to do. Then no remote queueing
is necessary. Like here:

https://lwn.net/ml/all/20250703140717.25703-7-frederic@kernel.org/

> 
> >    Pros:
> >          - Simple and easy to maintain.
> > 
> >    Cons:
> >          - Need a case by case handling.
> > 
> > 	 - Might be suitable for full userspace applications but not for
> >            some HPC usecases. In the best world MPI is fully implemented in
> >            userspace but that doesn't appear to be the case.
> > 
> > 2) Queue locally the workqueue right away
> 
> Again, the event which triggers the manipulation of data structures
> by the owner CPU happens on a remote CPU. 
> So how can you queue it locally ?

So that would be the same as above but instead of using task_work(), we
would force queue a workqueue locally. It's more agressive.

> 
> >    or do it remotely (if it's
> >    really necessary) if the isolated CPU is in userspace, otherwise queue
> >    it for execution on return to kernel. The work will be handled by preemption
> >    to a worker or by a workqueue flush on return to userspace.
> > 
> >    Pros:
> >         - The local queue handling is simple.
> > 
> >    Cons:
> >         - The remote queue must synchronize with return to userspace and
> > 	  eventually postpone to return to kernel if the target is in userspace.
> > 	  Also it may need to differentiate IRQs and syscalls.
> > 
> >         - Therefore still involve some case by case handling eventually.
> >    
> >         - Flushing the global workqueues to avoid deadlocks is unadvised as shown
> >           in the comment above flush_scheduled_work(). It even triggers a
> >           warning. Significant efforts have been put to convert all the existing
> > 	  users. It's not impossible to sell in our case because we shouldn't
> > 	  hold a lock upon return to userspace. But that will restore a new
> > 	  dangerous API.
> > 
> >         - Queueing the workqueue / flushing involves a context switch which
> >           induce more noise (eg: tick restart)
> > 	  
> >         - As above, probably not suitable for HPC.
> > 
> > 3) QPW: Handle the work remotely
> > 
> >    Pros:
> >         - Works on all cases, without any surprise.
> > 
> >    Cons:
> >         - Introduce new locking scheme to maintain and debug.
> > 
> >         - Needs case by case handling.
> > 
> > Thoughts?
> 
> Can you please be more verbose, mindful of lesser cognitive powers ? :-)

Arguably verbosity is not my most developed skill :o)

> 
> Note: i also dislike the added layers (and multiple cases) QPW adds.
> 
> But there is precedence with local locks...
> 
> Code would be less complex in case spinlocks were added:
> 
> 01b44456a7aa7c3b24fa9db7d1714b208b8ef3d8 mm/page_alloc: replace local_lock with normal spinlock
> 4b23a68f953628eb4e4b7fe1294ebf93d4b8ceee mm/page_alloc: protect PCP lists with a spinlock
> 
> But people seem to reject that in the basis of performance
> degradation.

And that makes sense. Anyway, we have lockdep to help.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

