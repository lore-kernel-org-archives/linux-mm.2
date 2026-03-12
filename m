Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C1B3FED2CC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 05:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832BD6B0088; Thu, 12 Mar 2026 01:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2116B0089; Thu, 12 Mar 2026 01:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1746B008A; Thu, 12 Mar 2026 01:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE686B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 01:53:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE0E21B8A2A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:53:00 +0000 (UTC)
X-FDA: 84536342520.21.5585B19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 346044000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:52:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=scyQITDV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773294779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LK54H+NxMZpqFTH8w40O2xJzyNnNNOsdO4h/pRU+Ufs=;
	b=q/HZCvePmwZqZhdig0MDhckVYnGv2+VZugYS/9Dwko3kGBi4SbddUeCevZchVOsZ4tBdt/
	Q2ifLZO9Dt60JVCrShYF4SCSeGWtNzav2ey+6OFZg80v8hPkzg50oXnPXO7sSCjPkEeUBF
	ovzWRpUXORHypihymR2S6zzFN77JI0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773294779; a=rsa-sha256;
	cv=none;
	b=uQQubUl4JG6CVaXDB/qAhmTr+EXcDpCtvjNhNPzR6f7YzOQeSqGHwVnL+rHziRRC4iUq3B
	t1+EECIdLIErRYD6Z3QH1iVo0bbyZp0yBF8wZP/OheV9nRyQffpc549LPKaQYpc3eGFxbQ
	TtAdD4LHpf2kYR+siyFx5NUbKFWFzac=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=scyQITDV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7849A60054;
	Thu, 12 Mar 2026 05:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64063C4CEF7;
	Thu, 12 Mar 2026 05:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773294777;
	bh=yHvrihuiEK1Irf0RsLNHHJrheMooZAmzdbPFW+Cj6Vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=scyQITDVXWIpNOqtAgI2myxAqTXxQf3vtM9HtPdlzWGamh2SAIE+aKvlxTj6DoLoN
	 m966f0f2lrgH9pXCeUYXiw5CcFODic4vkh5vIi++GIWSCvDJg/gZYskxO3FllweaE+
	 Rc1rfgagezv4XeuYpMjpfKvhXtFg5hjnvJIkJ6srETyTgJRxxhZDr76hp3okocUZtJ
	 D44wk4sXAlh8VUEWTfL7gWbWxXthk6M8fhrKXY81YxIkAJ7uyKGzVtDHGHXLqM0Rr3
	 2LwMUixUk8BiSHGKJU/i2sYUHzJxpHgWxNKHHHdqjIyC6pGeYI9PuY2aNQXxY/J+kY
	 bXLqnU8gyyjxg==
Date: Thu, 12 Mar 2026 16:52:47 +1100
From: Dave Chinner <dgc@kernel.org>
To: Haifeng Xu <haifeng.xu@shopee.com>
Cc: akpm@linux-foundation.org, david@fromorbit.com,
	roman.gushchin@linux.dev, zhengqi.arch@bytedance.com,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/4] mm: shrinker: optimize the allocation of
 shrinker_info when setting cgroup_memory_nokmem
Message-ID: <abJUr1bIs62nQC9Z@dread>
References: <20260310031250.289851-1-haifeng.xu@shopee.com>
 <20260310031250.289851-4-haifeng.xu@shopee.com>
 <abHpPC8tWwU93C1D@dread>
 <bc08d009-fa43-44d0-880f-a37cc200a3b9@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc08d009-fa43-44d0-880f-a37cc200a3b9@shopee.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 346044000E
X-Stat-Signature: w18bb31q5mw3k5wqrqqe7zpowufbbtoo
X-Rspam-User: 
X-HE-Tag: 1773294779-756256
X-HE-Meta: U2FsdGVkX19ex28ft/22N7rgNzb1SGU2GDjMArSYDG9OqzIxkpYYthz1u8YPVL/Kf14rIDxwruvsL9YO2usQE4uY9nsalmNRsLipHxgYe1fy4/JGX+tI4kkeMzduKXhba5oe/NY/gAabiUnY8KHPiJwlK9/8VqCMWryyDviZ1wZTqh+b8By85zU3VbxxSFDMc4jT782vxfvyaqO5PNPftsrNmm+spMSCgSfKUv+m1n0hL4uTlY7NJdG+kG2vrskkS1TRHggNKwvs/zhSOBTsiY/U/7+4TEqLhaQXLuZ4c3I8LFHgINxRKHWo19ut17zbZ6DG/tEURV+ytbQFUqZ2EY3xBBSvs5n+tV7W9XVJsnnJ28O9bkPBvq+NzcivBAPW/GxL+FjGgM/1qjesI5q1bUrCcR51kFwSpOCwixI1ZoNliduErdRYmOJtLq0atzmvl6i1n/PHcxLczRTSv/xSY/EbRnU03osQhcC/P6TbVk5nvlX6v9r6cRrslTwn2Pdr7Y7iYXmHONPvRFnN0jXMVPBjbLHX+OfVrAd0izpvqTvjIMtXvNqfCjcbf+m1t9jx4Yigg+biexvPSHydUP6XHhHCRd2Swy4sXSCkS/brrbIrh1O9MgG1fLStP4z8BuLpW8Eseobw0HJ2pe161IpJE1FC9PZtUoezzMq+OD6jWlm0+z8bCxvZOJehsF+sBOXoKmb4mgVM+bN/vFuzUEXem+IYpwNg018y+6I+Zyg/kHRYvmaunkICpuPwNUAeDLBKwtZLuJTlQPPT3mB8oUd1k/J6P6eNLz0Ik4qROyPiJDIgfNi8X6H0uTlUycQ1xip6tirwrU9ofrVRaeZkbRtPY0N9YGvAq4bmxU+HiTN7ljns6Su80tiSdA7gf528B6OJiQEndkvLs8Af7XadkjAb9pkom9s0vyCtwtkf9e2O4AmF3ogQnCVZPI/beVVEgv7QTh/51+YJWj3Kvo7UnFM
 O8fHPnzU
 wEfbhsLQuhaqbe1kXwacpXmad0/ck9IuCPsFrqjWUiNeeZKvecvqSKTly8sbYr6WCrWX77j19r2jv1Pz8rzi1AEQx+lxIesZqEAEHHHp3xDSdI/PxHaBjvBNzgAn3DtCJ3Qgn7V7/cuJAvQ3YQgaMB5FEZ7ZqwpH/08Ah/0KZ4oocG/Wru9Oj8CekgBo2XJpXkGKy7TCSOYQDk15ELzBc4NS/66fZjJrZH7Q20kEYm4ZCiTS5XUNSBz68aZHBfrTXRamYR/VTcZwgfm42bYTgbLoo4EDR769lYtTG7aHSGnUEPvi9OxEKJAu5bJzLDVMGHU7vDlaXFS7RRG3WedTEb5Gveg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 12:08:42PM +0800, Haifeng Xu wrote:
> On 2026/3/12 06:14, Dave Chinner wrote:
> > On Tue, Mar 10, 2026 at 11:12:49AM +0800, Haifeng Xu wrote:
> >> @@ -78,15 +79,25 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
> >>  {
> >>  	int nid, ret = 0;
> >>  	int array_size = 0;
> >> +	int alloc_nr_max;
> >> +
> >> +	if (memcg_kmem_online()) {
> >> +		alloc_nr_max = shrinker_nr_max;
> >> +	} else {
> >> +		if (memcg == root_mem_cgroup)
> >> +			alloc_nr_max = shrinker_nr_max;
> >> +		else
> >> +			alloc_nr_max = shrinker_nonslab_nr_max;
> >> +	}
> > 
> > What does this do and why does it exist? Why do we need two
> > different indexes and tracking structures when memcg is disabled?
> > 
> > If I look at this code outside of this commit context, I have -zero-
> > idea of what all this ... complexity does or is needed for.
> > 
> > AFAICT, the code is trying to reduce memcg-aware shrinker
> > registration overhead, yes?
> > 
> > If so, please explain where all the overhead is in the first place -
> > if there's a time saving of hundreds of seconds in your workload,
> > then whatever is causing the overhead is going to show up in CPU
> > profiles. What, exactly, is causing all the registration overhead?
> > 
> > i.e. there are lots of workloads that create large numbers of
> > containers when memcg is actually enabled, so if registration is
> > costly then the right thing to do here is fix the registration
> > overhead problem.
> > 
> > Hacking custom logic into the code to avoid the overhead in your
> > specific special case so you can ignore the problem is not the way
> > we solve problems. We need to solve problems like this in a way that
> > benefits -everyone- regardless of whether they are using memcgs or
> > not.
> > 
> > So, please identify where all the overhead in memcg shrinker
> > registration is, and then we can take steps to improve the
> > registration code -for everyone-.
> > 
> > -Dave.
> 
> When creating containers, we found many threads got stuck and wait shrinker
> lock in our machine with kmem disabled. And we found that the shrinker lock
> was held for a long time when expanding shrinker info. As the number of
> containers increases，the lock holding time can increase from a few milliseconds
> to over one hundred milliseconds.

Ok, but...

> Call stack can be seen as below(based on stable kernel 6.6.102).
> 
> 
> PID: 4462     TASK: ffff8eff5ca0b500  CPU: 79   COMMAND: "runc:[2:INIT]"
>  #0 [ffffc9005b213b10] __schedule at ffffffffa3ad84c0
>  #1 [ffffc9005b213bb8] schedule at ffffffffa3ad8988
>  #2 [ffffc9005b213bd8] schedule_preempt_disabled at ffffffffa3ad8bae
>  #3 [ffffc9005b213be8] rwsem_down_write_slowpath at ffffffffa3adcc5e
>  #4 [ffffc9005b213ca8] down_write at ffffffffa3adcf3c
>  #5 [ffffc9005b213cc0] __prealloc_shrinker at ffffffffa2db3bf0
>  #6 [ffffc9005b213d08] prealloc_shrinker at ffffffffa2db9e0e
>  #7 [ffffc9005b213d18] alloc_super at ffffffffa2ebec49
>  #8 [ffffc9005b213d48] sget_fc at ffffffffa2ebff48

.... this is exactly why you need to show your working, not just
present your solution.

That is, prealloc_shrinker() API no longer exists in TOT. The way
shrinkers are registered and run was significantly changed in ...
2023 by commit c42d50aefd17 ("mm: shrinker: add infrastructure for
dynamically allocating shrinker").

IOWs, the problem problem you are reporting may not even exist on
TOT kernels. Have you tested your problematic workload on a TOT
kernel, and if so, what were the results?

> We use perf tool to record the cpu consuming. I have posted it in the attachment.
> From the Flame Graph, we can see that the clear_page_erms() and memcpy() in 
> expand_one_shrinker_info() are the main sources of overhead.

expand_one_shrinker_info() was somewhat simplified by the above
series, so even if it is still an issue on TOT kernels, it still
likely costs less than on old LTS kernels.

> Therefore, the more shrinkers and memcgs exsit，the process of expanding shrinker
> info takes longer. This is because when expanding shrinker info, we will traverse
> all memcgs an record all shrinkers for them.

Only if the shrinker_info arrays need expanding. This is happening
frequently because the expansion code only expands the shrinker info
arrays by one ID at a time. hence if you create a container that has
half a dozen new filesystems mount in it, the array is being
expanded at least half a dozen times. Maybe multiples of this more,
if the filesystem has multiple memcg-aware shrinkers that it
registers per mount...

IOWs, we need to make the expansion case the rare slow path, not the
common fast path here.

It should be trivial to batch the array expansion (e.g. expand in
multiples of 8/16/32 slots) and then shrinker instantiation overhead
should scale down linearly with increasing expansion batch sizes.

Such an improvement will reduce the memcg aware shrinker
registration overhead on -all- configurations, not just the specific
one you run....

> However, with kmem disabled, memcg slab shrink only call non-slab shrinkers, that's
> to say, we only need to record non-slab shrinker for non-root memcgs. For root
> memcg, we still need to record all shrinkers because global shrink call all shrinkers.

Yes, I know what your patch does - it should be clear that it does
not address the root cause of the problem you are reporting, merely
works around it for your specific use case.

-Dave.
-- 
Dave Chinner
dgc@kernel.org

