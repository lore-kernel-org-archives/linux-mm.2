Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEB6FD4F08
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912E46B0088; Tue, 10 Mar 2026 13:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C116B0089; Tue, 10 Mar 2026 13:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740AC6B008C; Tue, 10 Mar 2026 13:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 601366B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:13:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14FEE1602AD
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:13:53 +0000 (UTC)
X-FDA: 84530800746.20.383E481
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id DC0C4120010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:13:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Muqwupi7;
	spf=pass (imf29.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773162831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXudXV+vIcCe/FaMWV94uAIHSh+hgQuxJ4MUz1MgDPw=;
	b=QNKhcf02o3N+wsexUZWmW1vcytjt3sawvlZ2zQOu/fZ+K7RpSTHxxoz7owJvw3iQGaJXVO
	Vh3DQOY0KxfntQusxs6CJadn41WmRf7pjrRL6cRf7+JF9Bstfd2eaW66UBfC6ORWjs2TcS
	C11YKMb8okziBMOmtWw5I4d5lZG95uc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Muqwupi7;
	spf=pass (imf29.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773162831; a=rsa-sha256;
	cv=none;
	b=IkG7f4VQ6w33xnJRmhBeHiJCUZe/tt1xusXFxMPAXLxT5BHVB+AaEdmR89V5a1DUx9g5Cn
	PVYEv2BhH7N3oyj4hB05VkDt9QnVt07Vhwf81MMyEK+lgJJ+8a8D5LX+Tu2IabdoaDMQAX
	Ie24t4qVBN2K7hBm+7MeaGL51pHDJXU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773162830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sXudXV+vIcCe/FaMWV94uAIHSh+hgQuxJ4MUz1MgDPw=;
	b=Muqwupi7d9Jo7oA/bo572s2O4QsqH4I9jZmZbuqqca7yXA549dXXP07PnPh+wfVrgfYgEk
	R+99pXKlJ3EJrciWKF8YF2FQo2db9cKK+2S8nT7g+DNj/HDI2B2yVQSbJRnaYRN/n+hRJg
	j+oFMxolOpcHxvDwdEnQzkhIuNoyMSU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-7P6qnvrTPXugEWadv_84rA-1; Tue,
 10 Mar 2026 13:13:44 -0400
X-MC-Unique: 7P6qnvrTPXugEWadv_84rA-1
X-Mimecast-MFC-AGG-ID: 7P6qnvrTPXugEWadv_84rA_1773162822
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4BAE18005B9;
	Tue, 10 Mar 2026 17:13:40 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E99B430002D2;
	Tue, 10 Mar 2026 17:13:38 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id CBB5D40205ECE; Tue, 10 Mar 2026 14:12:03 -0300 (-03)
Date: Tue, 10 Mar 2026 14:12:03 -0300
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
Message-ID: <abBQ40Zkk76Zej8i@tpad>
References: <20260302154945.143996316@redhat.com>
 <aam1cHq3_fb-T1HH@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <aam1cHq3_fb-T1HH@localhost.localdomain>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: RAX6PqhNY2LHs4Y2g0FY5QLgdrEYT_xD92v9dJzBtdU_1773162822
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC0C4120010
X-Stat-Signature: eyz3b58cf7kims6gxf5xb6u6ic3cpb57
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773162830-286345
X-HE-Meta: U2FsdGVkX1+H6FdSMpke6VLLBUV4OtnTEOsdB18rtKEU3Nl0UuVydFB9LhMZqADJSFcSdGC2xzqxkmMwbys356srEEVvNWFUJqIe3+XmK2yZZRZwoB8d+7TaXIoC2FIOYf3RGvWOZZzu0581X+6mgjXLMM8bAdl92LH2L4JkpKykYe52iQBUZXTWiia/TC7CAmBx9YIvZ48uq1LHclApzRAhElViDvN6PjX2JeHfKacYbSbWHxth6Te/Npm4SPo8ermAbfQ8yad4AEZ+31SQY5+OLmmsqGpHj/AJoa+kvhXdnMoNePyu+v094mzkvD9lFWdBqCb7CcE2sTlYdHjKlkMgARDCZV7hZKW5Yc06udjhTPXeQKj0sGSrwgXoSSH4STGhiaKpEMQUCwBNgqpXS5FrpPb967uCCvhYhXsMRnVZ0fc/5xySixLRCtL7LrrDS+U9hr+02OSv9nL/3fJfP803vWADG6uHY0ghYCGPsS8JqWFrERDGWqCcrH7yrE8J0gZZoLNISDESs0gW869d1KQyP+apNKZLhDgDl/bJZgiknVP5gyqDsUrGbzdDifnt5M3Kme9ur1hUSeOUKp3d5S5wNz3DwwkEPJcUfh2KiXyL1i1h1t6ynFeWmA5OSP9LZ83M4zzlBwgXYCMki/IQPL3yILygVoGkHoUYJWnlK/SvUko3KEOx0jKlABg13IODCD4sajkIUobijbiBtcRePYCXMooWZhOygDp0Ntmxckz4+Tp+keCIolluztHtztdKq2JwaZAxemKEi2rod1rHAryeTwgdiakMi+KlB6wGhwF5IpkS1BlHZ1KxNnGXyC67rqlBt6LlhNQch1nWxV15GnYAGjMa7R9cf/Uf6XnfhiXFNPxIlpQDkwcGLySyTaLHtUe/8Xby/NvCmzfCaslAFEhY7tmtEUlYHvX7ezCnpvZ4055DwvjF0CPoLuIALjWQQ10RNUh2iZyxlPoTE17
 JwYkuj6b
 a4Yd8xr3eeAsZUPu4IUlNKGt54KPV8RzB+My+WLVqiSiCk1ixWiptv1OFsqeDOzCITuuYmhMMIXFsoDd9g015gizdJvzJ86rMCLACUkU0lSmUB5apVhN4B7UAuM4oRkKXD8j7OSAnAJYPFH0pQn47CMSe9fFxPyNXOeOBBBomZhMnd2DfoGf8NMxXjEEF9vr+r4S0hcyU83LsVDH5oRv+7ySDVkiG37Mz+/21PH8DI9/8+ehBtlce007PaOdQYOoiYy7tgm/TJlcUzRLq9PKjxYDYnLHfnShKgvJaOP6rdpZAMD3TSbnFtrr5FmKEhcWcfoSlii73Zga2cTfYHomZ+y+CX13T+sAUUr14hHOzObB+mUqIZgiCE8vwoA6y5eV2E/RF4f58ceAyzFaS0XELgmNnLKnYHWgFXbGW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Frederic,

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
> 
> 1) Never queue remotely but always queue locally and execute on userspace
>    return via task work.

How can you "queue locally" if the request is visible on a remote CPU?

That is, the event which triggers the manipulation of data structures 
which need to be performed by the owner CPU (owner of the data
structures) is triggered on a remote CPU.

This is confusing.

Can you also please give a practical example of such case ?

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
> 2) Queue locally the workqueue right away

Again, the event which triggers the manipulation of data structures
by the owner CPU happens on a remote CPU. 
So how can you queue it locally ?

>    or do it remotely (if it's
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

Can you please be more verbose, mindful of lesser cognitive powers ? :-) 

Note: i also dislike the added layers (and multiple cases) QPW adds.

But there is precedence with local locks...

Code would be less complex in case spinlocks were added:

01b44456a7aa7c3b24fa9db7d1714b208b8ef3d8 mm/page_alloc: replace local_lock with normal spinlock
4b23a68f953628eb4e4b7fe1294ebf93d4b8ceee mm/page_alloc: protect PCP lists with a spinlock

But people seem to reject that in the basis of performance
degradation.


