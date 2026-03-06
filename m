Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC5C3F513EB
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 01:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC5A6B0005; Thu,  5 Mar 2026 20:48:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A9B6B0089; Thu,  5 Mar 2026 20:48:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B58E86B008A; Thu,  5 Mar 2026 20:48:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2C0F6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 20:48:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 461D0160348
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:48:11 +0000 (UTC)
X-FDA: 84513952782.14.7D8E2C4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 142594000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:48:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Rq1SChYI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772761689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDVZujMLsVOozdPPpdT3tG1kjQU04IXYyasKMiVvChM=;
	b=iuiaahK05MZPgDClqBymaond9Ijc9+JGNBiTQJLmJaAQ+mwuPQqYmiNQNp98/q1Sv9x8YZ
	HQuzm6wemmA1mdTZXsYWUSOZIhRqUiCjkRf8Gy+L3wohrcdKJ+j/Y5Wpztwg4TzE9qsWQv
	rEMeJapyu88zT4DDxZ/YYgrBqn8HSyo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Rq1SChYI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772761689; a=rsa-sha256;
	cv=none;
	b=OIcZkpI1mHmobxmmvQmO1yUWYt7lelcwwYzuq8aDaO3p5gRPpbMk58C5qfzutIzRZne0DZ
	25AA4kaRS1x+G2QVGdUw0dC5ZRg++Ivo6ZmG7/aGe1wsyhth72U8zPd/40es8byvStwq3I
	rs1Vu4iGzn2kw+668vM3nuuFIN5LkTY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772761688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDVZujMLsVOozdPPpdT3tG1kjQU04IXYyasKMiVvChM=;
	b=Rq1SChYIM4BXoL2mFGkNh5cZ+sD61BiePnuY3+VYNWfAAoawG4K9zHGh0KlgaKknNYaDTV
	kBbGbFFR2Rcybu2PfsQo3XOBxLq/TrLYrgoLTFTk5r6CmfwF+GXCYnozxOHKvWeoO8qafe
	Z73bO869GyC4R/zJ/WOO/8nxbYxvBvw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-169-vpDx7EICPB-rVh_Y90_q6Q-1; Thu,
 05 Mar 2026 20:48:05 -0500
X-MC-Unique: vpDx7EICPB-rVh_Y90_q6Q-1
X-Mimecast-MFC-AGG-ID: vpDx7EICPB-rVh_Y90_q6Q_1772761683
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A8671800345;
	Fri,  6 Mar 2026 01:48:02 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C5AA1958DC5;
	Fri,  6 Mar 2026 01:47:59 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 24D3E401CA849; Thu,  5 Mar 2026 22:47:00 -0300 (-03)
Date: Thu, 5 Mar 2026 22:47:00 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
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
Message-ID: <aaoyFClXLEYNzzBR@tpad>
References: <20260302154945.143996316@redhat.com>
 <aam1cHq3_fb-T1HH@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <aam1cHq3_fb-T1HH@localhost.localdomain>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: cSD5TtaaF9ydcC6sigFQaQFbqsj8phbUymSqdPzJjBI_1772761683
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 142594000D
X-Stat-Signature: 8j4syz757fkthiibnwcc6bdmhzpexjry
X-Rspam-User: 
X-HE-Tag: 1772761688-487244
X-HE-Meta: U2FsdGVkX1+YP63iuAnfQnGV0XPos6R7qjU+gXOyo+qBc4ogekMl0JQXnnyWP2cOL/E8tS/nvQydmd6dmSVB5a5dYPq79KqyZSgL6HEGf6ff92eR2Xjca3o/uLctWjE6jXG6NAAc5EpjD9R5Jpn5qKYS2EPx/+HgY/gc4qliziKo6KQLxeSHVLr2HKFqdJJWuDGRjg6l+xpAbWZqEZa8gVHpe3twXVL1y3muP3I6tThLYK2JlOI+1MeYC+AU5mykgGBA2y/XhojP5u4oZS4hYMAA4yHPDsDxbQlXIh7hq+idjCmgTdjHWjhnRq8ghXF2EgZoP4WsmZQGbsyiP6HOUpT7hfSUGwi6bzrEfM8UioiEkgnGsSKrtMXx8HPiPq7R5iGgcKOPmsyiC+c94sAnRy+YGJoVKwZlYVkXc6kgtHOF2XLavnaGQRj/pO+pJSr2fWt0teRo5aXERVeWaGVMLkYmJmTn3YrHJC4aK10a+r64dfOP2wpOW7Bdr0iqY4eRnXnvvxCj/XnBVNWGH64ZcbImgXN/q4H3i+bI1KY7aqUDVY9myalpqDhzOzlSB7ho/1LebwVxHGdZt6xpEJ/2p2ohgjGnu2+Bx3+D3IyjnxEFK+Vbp4Dvdg0n8n3+lX43beOlOmp4fxJKPxVcv6E2uU8E9q8eKrxWBKssN0symQDHMjpspuAuniHSC2b7MitvVKhwf9+9dGce/auGtfZdgK+lkd/Ota+CfuSIaPCJVY7yRF9LEsXxMC4dhUe8rbsoZ0tn+8LLZIqW6xERDc8sXLWwAZVhViLXuwiRvTASJXvnaCHSgmR69exGsYkRF/vicUx1QHx0cVdAE258AI3KXA4MJuHgYqq1B6oUX64FLzlaNOj588SS33YP9sB4JdWE+4HPsv7Vq0E58ygaJ+yRMAWzlGiPhdu/sImMWG6f7PuvP6a6DT+Z24Ci6hIBPxViVPS5eX/tNbIMDt2ViHc
 FAT2WTIJ
 61mXQ1NBGsUXKyQi6uIyYUjhsSDa89gZv8GejllhCb4eGKggd160Ek+z5nQ2SyhmEnTqtqbF/mvJLZoqUQIs70OhY1SAJZ5NoeL7ZsRItFLmZfk8xONZmhjWfthlYLv4Np1LqhrQ1PIVcOQ0ebSBpxMkGObP45cLnRe89U+sHom6T/nDa4zIt+etUowtU5+buCczvtQp5GqzvPdTLSrso5R6o7SOPIXalvgoNlOKSSYoxqXXKZxyVEq4FtokG2zjprtm77lPxuL6upZ1tu1eVzqRmSGkSzJSIG+LolSywJ2G9t4D31W2aMMRKy05aRQVpac/VWLVDCrx8QDmmZ7ifNFds/tdjrwkB4HUZyYAFTxIlYIpW64T/39dXSLylBqGvHIpBsKQuNcQWvs2p7lXHUifiqzWf6lwysV+o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 05:55:12PM +0100, Frederic Weisbecker wrote:
> Le Mon, Mar 02, 2026 at 12:49:45PM -0300, Marcelo Tosatti a écrit :
> > The problem:
> > Some places in the kernel implement a parallel programming strategy
> > consisting on local_locks() for most of the work, and some rare remote
> > operations are scheduled on target cpu. This keeps cache bouncing low since
> > cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > kernels, even though the very few remote operations will be expensive due
> > to scheduling overhead.
> > 
> > On the other hand, for RT workloads this can represent a problem: getting
> > an important workload scheduled out to deal with remote requests is
> > sure to introduce unexpected deadline misses.
> > 
> > The idea:
> > Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> > In this case, instead of scheduling work on a remote cpu, it should
> > be safe to grab that remote cpu's per-cpu spinlock and run the required
> > work locally. That major cost, which is un/locking in every local function,
> > already happens in PREEMPT_RT.
> > 
> > Also, there is no need to worry about extra cache bouncing:
> > The cacheline invalidation already happens due to schedule_work_on().
> > 
> > This will avoid schedule_work_on(), and thus avoid scheduling-out an
> > RT workload.
> > 
> > Proposed solution:
> > A new interface called Queue PerCPU Work (QPW), which should replace
> > Work Queue in the above mentioned use case.
> > 
> > If CONFIG_QPW=n this interfaces just wraps the current
> > local_locks + WorkQueue behavior, so no expected change in runtime.
> > 
> > If CONFIG_QPW=y, and qpw kernel boot option =1, 
> > queue_percpu_work_on(cpu,...) will lock that cpu's per-cpu structure
> > and perform work on it locally. This is possible because on 
> > functions that can be used for performing remote work on remote 
> > per-cpu structures, the local_lock (which is already
> > a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> > is able to get the per_cpu spinlock() for the cpu passed as parameter.
> 
> So let me summarize what are the possible design solutions, on top of our discussions,
> so we can compare:

I find this summary difficult to comprehend. The way i see it is:

A certain class of data structures can be manipulated only by each individual CPU (the
per-CPU caches), since they lack proper locks for such data to be
manipulated by remote CPUs.

There are certain operations which require such data to be manipulated,
therefore work is queued to execute on the owner CPUs.

> 
> 1) Never queue remotely but always queue locally and execute on userspace

When you say "queue locally", do you mean to queue the data structure 
manipulation to happen on return to userspace of the owner CPU ?

What if it does not return to userspace ? (or takes a long time to return 
to userspace?).

>    return via task work.
> 
>    Pros:
>          - Simple and easy to maintain.
> 
>    Cons:
>          - Need a case by case handling.
> 
> 	 - Might be suitable for full userspace applications but not for
>            some HPC usecases. In the best world MPI is fully implemented in
>            userspace but that doesn't appear to be the case.
> 
> 2) Queue locally the workqueue right away or do it remotely (if it's
>    really necessary) if the isolated CPU is in userspace, otherwise queue
>    it for execution on return to kernel. The work will be handled by preemption
>    to a worker or by a workqueue flush on return to userspace.
> 
>    Pros:
>         - The local queue handling is simple.
> 
>    Cons:
>         - The remote queue must synchronize with return to userspace and
> 	  eventually postpone to return to kernel if the target is in userspace.
> 	  Also it may need to differentiate IRQs and syscalls.
> 
>         - Therefore still involve some case by case handling eventually.
>    
>         - Flushing the global workqueues to avoid deadlocks is unadvised as shown
>           in the comment above flush_scheduled_work(). It even triggers a
>           warning. Significant efforts have been put to convert all the existing
> 	  users. It's not impossible to sell in our case because we shouldn't
> 	  hold a lock upon return to userspace. But that will restore a new
> 	  dangerous API.
> 
>         - Queueing the workqueue / flushing involves a context switch which
>           induce more noise (eg: tick restart)
> 	  
>         - As above, probably not suitable for HPC.
> 
> 3) QPW: Handle the work remotely
> 
>    Pros:
>         - Works on all cases, without any surprise.
> 
>    Cons:
>         - Introduce new locking scheme to maintain and debug.
> 
>         - Needs case by case handling.
> 
> Thoughts?
> 
> -- 
> Frederic Weisbecker
> SUSE Labs

Its hard for me to parse your concise summary (perhaps it could be more
verbose).

Anyway, one thought is to use some sort of SRCU type protection on the 
per-CPU caches.
But that adds cost as well (compared to non-SRCU), which then seems to
have cost similar to adding per-CPU spinlocks.


