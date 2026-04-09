Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97F4CE9DE7A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02FC36B0088; Thu,  9 Apr 2026 05:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007676B008A; Thu,  9 Apr 2026 05:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86816B008C; Thu,  9 Apr 2026 05:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA0526B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:17:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E99BBA6ED
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:17:53 +0000 (UTC)
X-FDA: 84638465226.01.1EAE8ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E103D40011
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:17:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=umu7HDqG;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775726271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2fuoybGQcpLUwSlo1cJGBzd+6HTCXuyYA3Dr5dT15A=;
	b=q0ig1snTBfZShaEFyYG0XFkyS6SMG+pONn2FoErxJFE2+BZzaFiuV1qmgrYsNSoeNQZVKM
	tF0tsa+xHpaseGjFWKe3EAQsSwAenZI4wHI7of3FkETqlkxfHW3iw0+fjWvvRlcokpAjFZ
	CzO90+4tiOd0gt7M2bw5asFapdPBjfg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=umu7HDqG;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775726271; a=rsa-sha256;
	cv=none;
	b=tEuli44hqiSjnyBrlt8H1ueTa+KOoZbiXEaXxx1NhodmQEx6C3zcUDPOBYAqjbrkZjgfVa
	ueqgwCOiNiu4aa6lCJeIYpruDuzOLzUDRAEJwv8ztr8JvsBUw2vPjQFQHUyk6vgdUelV+U
	hZdPuByh9R9y0a3tz4LGYhqDXNLk0k0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2431B60121;
	Thu,  9 Apr 2026 09:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4A6C4CEF7;
	Thu,  9 Apr 2026 09:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775726270;
	bh=XNDkkO9rVakd2F84eBx8F2rL3w+gmE4vG38aFwtklgM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=umu7HDqG1ovtr6kyo6a/Nwl+cTnsX+PZ6hdE3g31fj14BZuo1yMf1cHDlFjffY2Jt
	 CgGjGMVBmPvJrH9FBEEnm6lz2hX7A7Oc/HqKWzpIxAy4odTF+gHsb4jUHSVkrqYPWI
	 1KJKd68DtIXHZmw0GaLyYuu4FhgDewpLS84kDL1Vv4CTrEWhOYhNLsux2tDS01jygT
	 D2jpv1OawCtJBacTS1DmNSxpGz1uJS4CeZGHCrh7nTDr86JupPIRGZRCVYo0RLMVZb
	 VxmAOaRwC02wUCoQYUqSZC0CW867M6NBaMO/lwPPkAveEKztPMoXic+zOoTZ1kwPcJ
	 lc7ciNwi4vfpw==
Message-ID: <a48a854a-5f8e-4f4b-9da9-ae79ef92e07a@kernel.org>
Date: Thu, 9 Apr 2026 11:17:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kas@kernel.org, shakeel.butt@linux.dev,
 usama.arif@linux.dev, kernel-team@meta.com
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
 <a55afddd-8c6b-4a7a-bfd9-5140013c764c@kernel.org>
 <ac5urCFeEB9oyUiD@gmail.com> <adUhtrhU7c1TJQww@gmail.com>
 <a9129d39-f9dc-4f09-b951-203c8e28b600@kernel.org>
 <adZopu5wjXIR5HOR@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <adZopu5wjXIR5HOR@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E103D40011
X-Stat-Signature: mjskyi6imxcsc1e6yizdgsiiqtohna9n
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775726271-655186
X-HE-Meta: U2FsdGVkX18siHzy7nSm9mYFSpGX/l2pLXUT7jL6/pDZHeZr+YyRQQUrsPoqw1Sc5bo1XCdld05qOmy9cA5zPyraLTnGID6BhnX/0Qjh0OIpSKtGZgnjYj+mZani9PueLWYj7R5RbBO7ZpcQl/fnT1kmzVPNPbj0OE4+io+sEEdaCbDHL7cZXJRF3/RZk0Ezs/o/Am9DISkEy5DQFXFOQ3X9Ny5Luwk8JEzeTPx2iB2XA/8bqlLXvA9C5IDNZIysQiw2N631Y+RRksauUFthUEgiFath4sr8RL/x1nT16/k/yD63XkTnUWNUzYShezxE/Pr20kwE0pGFR/fpqz3QoWcxQKE5Gyt67zAREM6nD+dUhZfApLfnjbUAeqH1ZoxHaN32v/NDQ6abiQAbnhEse4yBe2NFnoWncvlFiMrBm15jorZ/IbN8T1e5J0qTNq4tp91npooQBs1DxAGOrI8BT27zuQftRZaJhXI0kditlnJXIauEAAhT7o3oWCVwxAQFbnCCf0q2LuSL9Op94LPOvHRKjoDrGBMCNse2r4lIJoaxOKbnbi6Mzocly85XKpULxSay/2dRn+OqZmEAzt9QDDDiApKm5FaRXhLqUvZ2TGqIIf78NIAr2NA3NSvf3Lz7aPWAzjDxXmq4Ln74XATZhJsA9/M1pPyFF9yXZEAJFdrfejdYEmvH3q1DAObvhRau7NiXH7/+Ev6/yBVVAxSsPNPV3NCHGk+PqYM8+e1OylkaMoJ1WVNFDOntldvlyLYA+JUWKRw95hHfQvsLOS4XRTi/b5/I6gU/x4ksiz3j3SwHTK66cPH4TlC8T0Lgunu8UaTq5QUHDyjdzKIVWzzaNU8Layqbf+9CoLVZHXXuY0dT6a1Cbx6B+jSzJTXWJiiGPcuKxnCsP0nJeOh3lNoo/TiaGzwSRCV/wz7YjPl3nidqLyS5uzWyh+fcpjQStOuHEP/SxP2t99fHZ9G6gcX
 LHr7G7kG
 YplvK/wpFrnCqZfarO4idJknvsFUXrmvwX1KwIhdHEeaWcWNMOI0azNf0ipRjs841XoQmAUFH1bFwP/iB3ebrmst/PdLy8wOcXY+pl6cSnI0jS7KC4dbWTYA1W4oertb4garCNH7UwPeKnEDiEWhF2NSqfHGutYCtefoJyyGRt+L6Etz+sUYIaHgQh0PWnvDeqRI3P8hYFV3iV4SVsIfMHOrmG1mUkeU0nE/rSl7mIKveKDeQTRhZ2hgnvxCyYJWDnm/+8UiApZjOPfYVvUTiPaEP/HER+hqh5TIRR7IN7yUkh1hbixEwppgGP2jWtemhIhyCCPNkRzgSnC6C5PI/TOohPrZHRLrJPH6zFiN7c3Q5FwPNpgMRUHd7SBlmnSc9L+rF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 17:13, Breno Leitao wrote:
> On Wed, Apr 08, 2026 at 12:13:04PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 4/7/26 17:39, Breno Leitao wrote:
>> > On Thu, Apr 02, 2026 at 06:33:17AM -0700, Breno Leitao wrote:
>> >> 1) The interval duration now varies per CPU. Specifically, vmstat_update()
>> >>    is scheduled at sysctl_stat_interval*2 for the highest CPU with my
>> >>    proposed change, rather than a uniform sysctl_stat_interval across
>> >>    all CPUs. (as you raised in the first email)
>> > However, we certainly don't want scenario (1) where the delay varies per
>> > CPU, resulting in the last CPU having vmstat_update() scheduled every
>> > 2 seconds instead of 1 second.
>>
>> Indeed.
>>
> ....
>>
>> So you have 72 cpus, the vmstat interval is 1s, and what's the CONFIG_HZ?
> 
> Yes, CONFIG_HZ=1000 in my configuration.
> 
>> If it's 1000, it means 13 jiffies per cpu. Would changing the
>> round_jiffies_common() implementation to add 13 jiffies per cpu instead of 3
>> have the same effect?
> 
> That approach would increase the spread in round_jiffies_common(), but
> it brings us back to scenario 1 - each CPU would have a variable
> rescheduling delay, which defeats the purpose of maintaining consistent
> timing.

I think it's not the case and round_jiffies_common() prevents it, more below.

>>
>> Link: https://github.com/leitao/linux/commit/ac200164df1bda45ee8504cc3db5bff5b696245e [1]
>> Link: https://github.com/leitao/linux/commit/baa2ea6ea4c4c2b1df689de6db0a2a6f119e51be [2]
>>
>>
>> commit 41b7aaa1a51f07fc1f0db0614d140fbca78463d3
>> Author: Breno Leitao <leitao@debian.org>
>> Date:   Tue Apr 7 07:56:35 2026 -0700
>>
>>     mm/vmstat: spread per-cpu vmstat work to reduce zone->lock contention
>>
>>     vmstat_shepherd() queues all per-cpu vmstat_update work with zero delay,
>>     and vmstat_update() re-queues itself with round_jiffies_relative(), which
>>     clusters timers near the same second boundary due to the small per-CPU
>>     spread in round_jiffies_common(). On many-CPU systems this causes
>>     thundering-herd contention on zone->lock when multiple CPUs
>>     simultaneously call refresh_cpu_vm_stats() -> decay_pcp_high() ->
>>     free_pcppages_bulk().
>>
>>     Introduce vmstat_spread_delay() to assign each CPU a unique offset
>>     distributed evenly across sysctl_stat_interval. The shepherd uses this
>>     when initially queuing per-cpu work, and vmstat_update re-queues with a
>>     plain sysctl_stat_interval to preserve the spread (round_jiffies_relative
>>     would snap CPUs back to the same boundary).
>>
>>     Signed-off-by: Breno Leitao <leitao@debian.org>
>>
>> I think this approach could have the following problems:
>>
>> - the initially spread delays can drift over time, there's nothing keeping
>> them in sync
>> - not using round_jiffies_relative() means firing at other times than other
>> timers that are using the rounding, so this could be working against the
>> power savings effects of rounding
>> - it's a vmstat-specific workaround for some yet unclear underlying
>> suboptimality that's likely not vmstat specific
> 
> I believe the issue is that vmstat's current use of round_jiffies_relative()
> fundamentally solve a different problem than the one we trying to solve.
> The round_jiffies_relative() mechanism is designed for a different
> purpose, as documented:
> 
>  """
>   By rounding these timers to whole seconds, all such timers will fire
>   at the same time, rather than at various times spread out. The goal
>   of this is to have the CPU wake up less, which saves power.
>  """

This is true, but only in the context of a single CPU, to minimize its
wakeups. What it doesn't say is that every CPU has its "whole second" moment
shifted relatively to others. Which doesn't contradict the above, except
that "whole seconds" without further details can be misleading.

I've finally looked at round_jiffies_common() in detail and after initial
confusion I believe it doesn't introduce different delays for different
cpus. One observation is that in the middle we round "j" to HZ, thus a whole
second value, and then

        /* now that we have rounded, subtract the extra skew again */
        j -= cpu * 3;

so the final jiffies target is slightly different for every cpu. This alone
could indeed shorten delays for higher cpu numbers, so crucially there's also:

        j += cpu * 3;

*before* the rounding step. The rounding can be also down instead of up if
the remainder is less than 1/4s.

So I'm now rather convinced that it works fine. Suppose we have a delayed
work queuing itself every second on cpu C. It will be executed for the
second (since boot) N at jiffies == (N*HZ - 3*C), then this will reschedule
it for the second N+1 at jiffies == ((N+1)*HZ - 3*C) (as long as it's
finished the previous iteration and requeued itself in 1/4 second, otherwise
it will be N+2). So I believe it will maintain the spread among cpus without
drifting over time, and not introduce any variable delay depending on the
cpu id.

> Backing up a bit, let me summarize the problem:
> 
> 1) vmstat_shepherd() starts all vmstat_update workers simultaneously
>    (or nearly so)
> 
> 2) All vmstat_update() workers then reschedule themselves for the next
>    second with only 216ms of variance across 72 cores

My point in suggesting 13 of 3 per cpu was to find out whether the 216ms
spread is really insufficient for vmstat - I would be surprised if it was
the case.

> Upon further reflection, issue (2) wouldn't exist if we simply avoided
> starting all workqueues simultaneously in the first place.

I still doubt it would work without continuously controlling for the drift
(which round_jiffies_common() does). I think it the existence of the shared
lock and initially some random perturbations would eventually result in them
becoming synchronized, like metronomes sitting on the same table.

But thanks to your new findings below this is all hopefully now moot :)

> That said, I created a hacky code to find how often the vmstat_update
> is called, and it is not uncommon to see cases where vmstat_update is
> called a few jiffies after it was called.
> 
> Debugging further, I found a race between vmstat_shepherd() trying to
> schedule vmstat_update() even when it is already running, which happens
> a lot, given they both run at the 
> 
> commit 86e27727b6cc9fbe8bf67818a065105fd30bc7e8 (HEAD -> b4/vmstat)
> Author: Breno Leitao <leitao@debian.org>
> Date:   Wed Apr 8 08:11:01 2026 -0700
> 
>     mm/vmstat: warn when shepherd schedules vmstat_update while it is running
> 
>     vmstat_shepherd checks delayed_work_pending() to decide whether to
>     queue vmstat_update for a CPU. However, delayed_work_pending() only
>     tests the WORK_STRUCT_PENDING_BIT, which is cleared as soon as a
>     worker thread picks up the work for execution.
> 
>     This means that while vmstat_update is actively running on a CPU,
>     delayed_work_pending() returns false, and the shepherd may queue
>     another invocation if need_update() also returns true (which it can,
>     since per-cpu counters are still being flushed mid-execution).
> 
>     Add a WARN_ONCE to make this race visible: fire a warning when the
>     shepherd is about to queue vmstat_update for a CPU where it is
>     currently executing, i.e., work_busy() reports WORK_BUSY_RUNNING
>     but delayed_work_pending() does not prevent the re-queue.
> 
>     Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 2370c6fb1fcd6..8d53242e7aa66 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2139,8 +2139,12 @@ static void vmstat_shepherd(struct work_struct *w)
>                         if (cpu_is_isolated(cpu))
>                                 continue;
> 
> -                       if (!delayed_work_pending(dw) && need_update(cpu))
> +                       if (!delayed_work_pending(dw) && need_update(cpu)) {
> +                               WARN_ONCE(work_busy(&dw->work) & WORK_BUSY_RUNNING,
> +                                         "cpu%d: vmstat_update already running, scheduling again\n",
> +                                         cpu);
>                                 queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
> +                       }
>                 }
> 
>                 cond_resched();
> 
> The fix is a one-line change: !delayed_work_pending(dw) → !work_busy(&dw->work)


