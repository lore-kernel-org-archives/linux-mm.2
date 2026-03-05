Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D26F3D332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79A86B008C; Thu,  5 Mar 2026 11:55:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27786B0093; Thu,  5 Mar 2026 11:55:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C296A6B0095; Thu,  5 Mar 2026 11:55:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFBCC6B008C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:55:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F76F1A0236
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:55:18 +0000 (UTC)
X-FDA: 84512609916.07.FAB5219
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C4C4A4000A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:55:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ez/f2DQi";
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772729716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeNIFUaHKQVi9Uz/+VZZ68NPDm1Q3NASVwE2j/t8rOY=;
	b=gF+fbYNyb5bTvDPyQpVVI0QM/6cIxVsykXGgGF9gc3QJ/z9CnEcCa+6PZll7d94NuEA8wj
	v5Mn6DdiNPPygrbfldeW32vaAsm7p6/6KzSHkV2xI8YwSxrg/5+ek75suFZY46m7fruF6Y
	uTQ+EbItuTe+9f8AiSZ7gIAgiXI5410=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772729716; a=rsa-sha256;
	cv=none;
	b=fBsDTiq5WQwhIYOpqiEIecmLeN9x+UizY3bfayO9wAyAO5BZqOU2cw6c1xJBjEHLVBGoYm
	gpt/mgHKO+kNp26QjHZzEPfXtqSPv4y/DywermXuQfs9mztKqnDXPi8zAdk15cW1GwL4Fv
	dx2hfqjHgKKAEyGZOnh6Emkf2HfGcwg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ez/f2DQi";
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DAC1443745;
	Thu,  5 Mar 2026 16:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AE0C116C6;
	Thu,  5 Mar 2026 16:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772729715;
	bh=O0f6fXd2XUupPHCTsZar0KKgsxOZECJdyOx56kFJbiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ez/f2DQipbyZ1PQOQDTcd8Mgz05PzGsyHW8mo6TULKHgFLKBQby4u61CZQizZWI37
	 3pBghtB01Dv9K7eSfkPqlQ0pITX7u1KFmSupmH1/gpSA/eZNMvkez9n7Zj4Mwj9c00
	 +Z8FarC0VucX7NRcFhyXfuI6zL8C8YYdNmfJmZnt1WCDdH7p/eK8gRClCtX6DVHKOR
	 xK0IVXtVm68D+6AsolJmMJVJ+UHGXe6IlEONg+/5YnxvX7zgu5/1P80dscpfqd4zuU
	 a0QpBgLV7rYIZOWLSUX4Ts8uHm4ylbRis+f9k4Jb79OxVZIIkhF3+Nm09tk9LM+9uR
	 xG5rQL+MmeodA==
Date: Thu, 5 Mar 2026 17:55:12 +0100
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
Message-ID: <aam1cHq3_fb-T1HH@localhost.localdomain>
References: <20260302154945.143996316@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260302154945.143996316@redhat.com>
X-Rspam-User: 
X-Stat-Signature: 9ofksqwh9rmeqzc7rhwayt6p1q5e5nyi
X-Rspamd-Queue-Id: C4C4A4000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1772729716-970005
X-HE-Meta: U2FsdGVkX19jJBxk8vXemxolCkT/7Zaxpu4nq2AEvuVbgnTvjYfgnqzS/eeCbVDEu/RMyeDCv16iHNEGOv4Igv8I+YFj+TSzU90xiaazCes/FcHP/wsDhAkEPUGnmFQUb8Yq10VVreUFuBz94OBEORsJ6UD48bpJUec82Jh6hK9sfc608VT+fVENlgrWtVEpwYPH0gFtP3z1/lEhjJPBMMhMk4hdn/IJWUXh74pHWfx/6B7YzVFePTSwf4AJU0hc2zHrl8LRbd7qigZJUo58OBRd9Kpb3hqWd3D0mnSn59L5EgSzX75SfoTZJ1uUxZS8yAywJsVjvVhyunfgdpVS0V8qd2Oabyv0G0DVZA10X6iVX0/r7u9z91XfV1ZyFOopvHmwxSck9G0rOFDrlcAtDrT5ZzRanlelqFQMCDvKudci9yq5ianQsBjVH83jKZRKvPECswDs1eIu4gWPn8Ri76i+biETpsqZEs9IIOhFL1a/tK3X/ONDivG7v+DjZF0CopfhuevjgbUS2mtyizCjj87AN9HsjrbneFDO/wibzUD05jhnFSfNgrV8XY8UWMIVR611u92504FjGMkTEG4Uyl6AfpwPJeB0CLL8PpCnuT6TjjGhQyXh5HiAAzeAJqzQezEyCWqDEQszhyP6o3NX9p7oCW65DSyD/YrqCNVPr1TLtToQisaLPlgdzHkIor05wBB4EgtU0J0nPZQr6Sp+Tt1uL9f2yKD1XFbOpp2EneWWqE50mKIXsBNS/c3lhX84GgpjKOP7y2gFU0nBL4A+JKBWPncP3BB191MEngIv6zFr+XooAxiciRgvKYWtUpseEA2bHeF/2fv9NjT/tvAxkkxP3MTrzvehLOG2py890kwco29GWu35h5G5lqCPe8PdIyLXeL9LoDYUtlXfrSi307Ea+TDO5YzpN8Pu3dfPfa61SkjaxTcBP8awWrVNpJ4npQcpnizaA9cU0BuAdMO
 RDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Mar 02, 2026 at 12:49:45PM -0300, Marcelo Tosatti a écrit :
> The problem:
> Some places in the kernel implement a parallel programming strategy
> consisting on local_locks() for most of the work, and some rare remote
> operations are scheduled on target cpu. This keeps cache bouncing low since
> cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> kernels, even though the very few remote operations will be expensive due
> to scheduling overhead.
> 
> On the other hand, for RT workloads this can represent a problem: getting
> an important workload scheduled out to deal with remote requests is
> sure to introduce unexpected deadline misses.
> 
> The idea:
> Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> In this case, instead of scheduling work on a remote cpu, it should
> be safe to grab that remote cpu's per-cpu spinlock and run the required
> work locally. That major cost, which is un/locking in every local function,
> already happens in PREEMPT_RT.
> 
> Also, there is no need to worry about extra cache bouncing:
> The cacheline invalidation already happens due to schedule_work_on().
> 
> This will avoid schedule_work_on(), and thus avoid scheduling-out an
> RT workload.
> 
> Proposed solution:
> A new interface called Queue PerCPU Work (QPW), which should replace
> Work Queue in the above mentioned use case.
> 
> If CONFIG_QPW=n this interfaces just wraps the current
> local_locks + WorkQueue behavior, so no expected change in runtime.
> 
> If CONFIG_QPW=y, and qpw kernel boot option =1, 
> queue_percpu_work_on(cpu,...) will lock that cpu's per-cpu structure
> and perform work on it locally. This is possible because on 
> functions that can be used for performing remote work on remote 
> per-cpu structures, the local_lock (which is already
> a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> is able to get the per_cpu spinlock() for the cpu passed as parameter.

So let me summarize what are the possible design solutions, on top of our discussions,
so we can compare:

1) Never queue remotely but always queue locally and execute on userspace
   return via task work.

   Pros:
         - Simple and easy to maintain.

   Cons:
         - Need a case by case handling.

	 - Might be suitable for full userspace applications but not for
           some HPC usecases. In the best world MPI is fully implemented in
           userspace but that doesn't appear to be the case.

2) Queue locally the workqueue right away or do it remotely (if it's
   really necessary) if the isolated CPU is in userspace, otherwise queue
   it for execution on return to kernel. The work will be handled by preemption
   to a worker or by a workqueue flush on return to userspace.

   Pros:
        - The local queue handling is simple.

   Cons:
        - The remote queue must synchronize with return to userspace and
	  eventually postpone to return to kernel if the target is in userspace.
	  Also it may need to differentiate IRQs and syscalls.

        - Therefore still involve some case by case handling eventually.
   
        - Flushing the global workqueues to avoid deadlocks is unadvised as shown
          in the comment above flush_scheduled_work(). It even triggers a
          warning. Significant efforts have been put to convert all the existing
	  users. It's not impossible to sell in our case because we shouldn't
	  hold a lock upon return to userspace. But that will restore a new
	  dangerous API.

        - Queueing the workqueue / flushing involves a context switch which
          induce more noise (eg: tick restart)
	  
        - As above, probably not suitable for HPC.

3) QPW: Handle the work remotely

   Pros:
        - Works on all cases, without any surprise.

   Cons:
        - Introduce new locking scheme to maintain and debug.

        - Needs case by case handling.

Thoughts?

-- 
Frederic Weisbecker
SUSE Labs

