Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F035E9DE6F
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F4D6B008A; Thu,  9 Apr 2026 05:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F0066B008C; Thu,  9 Apr 2026 05:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5061A6B0092; Thu,  9 Apr 2026 05:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 431806B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:36:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BB4313B765
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:36:36 +0000 (UTC)
X-FDA: 84638512392.12.42B007C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B6F681C0009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:36:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gvazIDQ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775727394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tE9nzrBfSB4NxRkAaBL0g/Ab7PQB430i58OdvoKavbg=;
	b=VcR4ZahInt257YeKcY69vycCLiYzO1bC9Bf+5cbJZ3uo5VboDMSYJbnO9QzZsgX/njZJU0
	fHerHLV6B1kxvpsEMCR2dfmzHhM7qRqyb7N+ZzbZUIuxRv82J/IdqboJcgf9J5ZkA5o9H2
	cXye04C459eQlhq52AO6YKfzLoaJrCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775727394; a=rsa-sha256;
	cv=none;
	b=hLDtL9XVxGafVSEH66WUZn1HNktMvsD/iDSu5mAmqGrNNsGVfDY05deO3Y5vSU9jocWe0y
	uStG4fEOIVnSzlOIofCNdrqBozu7m0YqjBY7mlvKlNJQ9SqgTqKx6f3nW7AJ9ddNnBImDk
	6bKCycgApe1SfvPy8iJwjiSdk5w/RZE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gvazIDQ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93906441C0;
	Thu,  9 Apr 2026 09:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5666C4CEF7;
	Thu,  9 Apr 2026 09:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775727393;
	bh=U0RZzJ1RvS+lKgIqqq906rosP31H3ovBpVd8yaLJNuw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gvazIDQ9nnc67MwDQU1usgufWROXpImnvTQ+UepFJ/vDiSOIPN5lTnz00rClKK1e6
	 mwodZY1o8sEOL3X0uq2QiRpUQ5pEJdTJ5XYjTVFIJpnT6AwrltVn5KwYtEGpisqAZo
	 AyHOna1A8ZBDkWCGQeMZU1IFuNeylv6/3M++pT7RKiMVEkDAmSfSVV4u1YdZEY2nqh
	 w6+LeyGglPXv40/969QoRowJ08PwIBnWJ7kqcazUVLFQ57szrXDse2LcQqtX3hWli2
	 M2XQfY5xLltUZvaMQIpigdRgZ6zx2wEqs80ir9VQIeP7MxFAISv/k2TTWITcSfvftG
	 0+3T397xYx4Zg==
Message-ID: <78a063c5-286d-4eea-8aae-2c0f1d0847e9@kernel.org>
Date: Thu, 9 Apr 2026 11:36:29 +0200
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
 <adZopu5wjXIR5HOR@gmail.com> <adaGcf2hKNGHwVPd@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <adaGcf2hKNGHwVPd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6F681C0009
X-Stat-Signature: 5x6k63ajxpyozg9icuarhbwcfe7wpzgw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775727394-389039
X-HE-Meta: U2FsdGVkX1+EJZqs3mcGSHRJlu7Lxt0e1aB+PbWpmhAr6Va09uH+K/nUmttoSSN9HcOYawpXzEAcLiGVgqMttvbhxBZmUJNS5lrrYaAtAaopmQzyUcufnrPdJ4pdi+WOvnaRdxYEmf48l6qv47V/Y9lJh35plRA/7lmdCWXSdZqM84y9hMXDquQy6/enZ66BVIcS4NWeOBjR5eseJbZjz07nO7gzKvG56tfRynS962pkF00qST1d8fifjQR348rEInp9Q9P97yHI8SQH3zICO6lI9jAVWvJ29cC+7DNoHv/YRogh9YSL3Gx2IRUlWMm9BEZIB9e8iAYAH1NaL8PznyKB+8TkpfSL0Mge5VNqSaJwJTE/S3x99MRM2DMFl6HcI3aq2oI9RBV46spQY69lQXkoLnFLVfIKsnHbHX66ZhqtViodesbdiJ4Y1ImsWyBhYiXCuwpv3IcY0ttnT9scgGjGWS25M2M76wzS2/MvdLThxunzL3jFaQfyQ8PzW4yUwdrTi9hfbh5JDqWEO7o4LQUcDSgNFgCisbmhW34MVSTpGZszWJ1W/e8ZITXRlyNXrt4NYjjmnUkIOihgIvPFWcZmTcq55weFWcg5y4vtQdDnXvRp4mG0iPLhlzCEzaF3mtbKMqI/fimd4vyky10mJuMGUhpR9C3maeK720AO3ohOiRg3qNbtWDFQ4y2Yjl+YUbqlN7UJUTuTZsVN0FUmxPz9djSKWBBxxSgTZw2ytaPusnuSCV+XEomB25o22WpN3v6VWOZ96o7VS7cGcCm+hUyVD/nk3NG9xotAfAeIhU1mK5aB0w6gXJwuTOo2cXJhqjWpSEfDEuzv5iUJRChO0F2bRuxYw8o38xwGjz47eZ0E9p5fQ1wE1m/rEOTMGAQgRldeOQ94aWuRBHM228UxBCQq6pa6UCZB7N5OQQlBWUx676csbJ/0MHzWzKuBa9Pw2FlvEqwSpsw5qdcRuC5
 TCC7Lp8d
 tq02uycdCh2x9VnblzrVZfYCw5BearIJ0majsE/2iAI0cwAz58tcL8WE+ypXO2BoJx1x0gYCdbhMZ9LX6TXsNPQdHn0pKOXHIqEExpc6XFGMKC23R3pPFR7cGQ4pMD3IJ2rlIbRw62lCAhxDMhRMCkdX0jPmCSfltlWDpnBZLYSuSlMryhn0rGdheSeB+aGXCLRg+b1b+23cIaPulPA4SkGIEu2fpYsLbTNklockQjRr6VZiAFh3/O+XtD96XC4mkRwlPdhsPqenfb0BSNSDrs7Wnz6VmY+UHkSkWms4TZzNTJ7t80veRzBfV4nWi/2LaOnamZzLUwjg6XA/hJoFKesk5YvFqIzl+K+4XCNY/ggCCXQw+I6KlBeBKfjnu/llwsnLT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 19:00, Breno Leitao wrote:
> On Wed, Apr 08, 2026 at 08:13:43AM -0700, Breno Leitao wrote:
>> On Wed, Apr 08, 2026 at 12:13:04PM +0200, Vlastimil Babka (SUSE) wrote:
>>
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index 2370c6fb1fcd6..8d53242e7aa66 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -2139,8 +2139,12 @@ static void vmstat_shepherd(struct work_struct *w)
>>                         if (cpu_is_isolated(cpu))
>>                                 continue;
>>
>> -                       if (!delayed_work_pending(dw) && need_update(cpu))
>> +                       if (!delayed_work_pending(dw) && need_update(cpu)) {
>> +                               WARN_ONCE(work_busy(&dw->work) & WORK_BUSY_RUNNING,
>> +                                         "cpu%d: vmstat_update already running, scheduling again\n",
>> +                                         cpu);
>>                                 queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
>> +                       }
>>                 }
>>
>>                 cond_resched();
>>
>> The fix is a one-line change: !delayed_work_pending(dw) → !work_busy(&dw->work)
> 
> In my testing, this race condition occurs more frequently than expected,
> likely due to the timer configurations we've been discussing throughout
> this thread.
> 
> I developed a diagnostic patch to monitor vmstat_update worker scheduling
> frequency, and the results show consistently low values. Avoiding
> rescheduling a worker that is already also reduces the contention on
> stress-ng test case.
> 
> commit d725f0664b70aa5c677215b0fc1abc0117aaf114
> Author: Breno Leitao <leitao@debian.org>
> Date:   Wed Apr 8 09:01:02 2026 -0700
> 
>     mm/vmstat: fix vmstat_shepherd double-scheduling vmstat_update
>     
>     vmstat_shepherd uses delayed_work_pending() to check whether
>     vmstat_update is already scheduled for a given CPU before queuing it.
>     However, delayed_work_pending() only tests WORK_STRUCT_PENDING_BIT,
>     which is cleared the moment a worker thread picks up the work to
>     execute it.
>     
>     This means that while vmstat_update is actively running on a CPU,
>     delayed_work_pending() returns false. If need_update() also returns
>     true at that point (per-cpu counters not yet zeroed mid-flush), the
>     shepherd queues a second invocation with delay=0, causing vmstat_update
>     to run again immediately after finishing.
>     
>     On a 72-CPU system this race is readily observable: before the fix,
>     many CPUs show invocation gaps well below 500 jiffies (the minimum
>     round_jiffies_relative() can produce), with the most extreme cases
>     reaching 0 jiffies—vmstat_update called twice within the same jiffy.
>     
>     Fix this by replacing delayed_work_pending() with work_busy(), which
>     returns non-zero for both WORK_BUSY_PENDING (timer armed or work
>     queued) and WORK_BUSY_RUNNING (work currently executing). The shepherd
>     now correctly skips a CPU in all busy states.
>     
>     After the fix, all sub-jiffy and most sub-100-jiffie gaps disappear.
>     The remaining early invocations have gaps in the 700–999 jiffie range,
>     attributable to round_jiffies_relative() aligning to a nearer
>     jiffie-second boundary rather than to this race.
>     
>     Each spurious vmstat_update invocation has a measurable side effect:
>     refresh_cpu_vm_stats() calls decay_pcp_high() for every zone, which
>     drains idle per-CPU pages back to the buddy allocator via
>     free_pcppages_bulk(), taking the zone spinlock each time. Eliminating
>     the double-scheduling therefore reduces zone lock contention directly.
>     On a 72-CPU stress-ng workload measured with perf lock contention:
>     
>       free_pcppages_bulk contention count:  ~55% reduction
>       free_pcppages_bulk total wait time:   ~57% reduction
>       free_pcppages_bulk max wait time:     ~47% reduction

Great!

>     Note: work_busy() is inherently racy—between the check and the
>     subsequent queue_delayed_work_on() call, vmstat_update can finish
>     execution, leaving the work neither pending nor running. In that
>     narrow window the shepherd can still queue a second invocation.
>     After the fix, this residual race is rare and produces only occasional
>     small gaps, a significant improvement over the systematic
>     double-scheduling seen with delayed_work_pending().
>     
>     Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index d59eff1582547..5489549241b51 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2156,7 +2156,7 @@ static void vmstat_shepherd(struct work_struct *w)
>  			if (cpu_is_isolated(cpu))
>  				continue;
>  
> -			if (!delayed_work_pending(dw) && need_update(cpu))
> +			if (!work_busy(&dw->work) && need_update(cpu))
>  				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
>  		}
>  


