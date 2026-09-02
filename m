Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB29C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 04:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902326B0098; Wed,  2 Sep 2026 00:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2726B0099; Wed,  2 Sep 2026 00:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D1D6B009B; Wed,  2 Sep 2026 00:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BCD86B0098
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:31:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3C901C2552
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:31:18 +0000 (UTC)
X-FDA: 85167547836.17.69875F2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 93DE81C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:31:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JhdQnC9v;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788323477;
	b=Mfrm4Iu9KWWziJ36V5vwj0jVU8jxVN+7/wIojqLcO5u3rg/9ff+oQPRgfU1GpFhuLNKlZT
	jMbZ8q+MTlMnnj1dc4xA/ueFibX9BR+DCnMl1TPd5SGsw1+/OOrm4FwfRJrEHLLFtaw7cH
	h07KDXUj8T/4poEYUjS2d5U/36+HI/0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JhdQnC9v;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788323477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2H2GTxiPcSiQy8R7tg1zMANlYUCLbZGZXRXunENnQY=;
	b=Vt7CR92seEugf1bdKwS+YlwlJid/WC+m9IW55V0PFDE+l7lmVYQQWcVtKxMSsW3bDGYJjK
	9jed/eBFEie8+v9msNANHzDZCme0EMsBgRRK2C15e4aqOOz+DJpfoWeTHNPKpzqL0j9Okb
	afH1O6aGZ82fMrBqzfvaNAaW4y5hoyg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D14E61596;
	Tue,  1 Sep 2026 21:31:11 -0700 (PDT)
Received: from [10.164.148.40] (MacBook-Pro-3.blr.arm.com [10.164.148.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2AE93F7D8;
	Tue,  1 Sep 2026 21:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788323475; bh=DvhAqyMZEAE6hMWjH1OG4Gf63XX1X25bMKQ9gvEIbXA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JhdQnC9vUNH9SMsR7ARDISMkwDkTMKASJonQiTuboHjwMjWFrjD9h51kDllYk9Q18
	 fwhcnfBUdXA/VzLfMIOvUSspIIvdBP6zEyS6LhS+lyPtuTq5rxV7uYRRo7basLSanX
	 DOKZCoROL7ed+h9Zi2yItAAwYyffh1MvRaxl+1ys=
Message-ID: <c88d035a-cf81-4431-bc28-bb09878e09d7@arm.com>
Date: Wed, 2 Sep 2026 10:00:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under memory
 pressure
To: Uladzislau Rezki <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <ye.liu@linux.dev>, Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260828091753.299295-1-ye.liu@linux.dev>
 <20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
 <bec5eaef-d084-467f-9bfd-43f7dedc1aa7@arm.com> <apVPTt9Xw8kSgmTU@milan>
 <54bd749f-04f5-4665-bd5f-d485e7197132@arm.com>
 <2e9488bb-feb6-4994-92e3-e5ef0c1ff5ec@linux.dev> <apcAvwXe89M20mGs@milan>
 <apcEh4iuYa6_47TJ@milan>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <apcEh4iuYa6_47TJ@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cdqxckz9hm97w7jebtkxnbb67z9cbaot
X-Rspamd-Queue-Id: 93DE81C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788323476-54972
X-HE-Meta: U2FsdGVkX1/5tmcFJwI3TftrILkNDQaYkAovbqoWrv6KVgssJVPeqpm14dHNiSKr88eVPKS7eeG5Y8loGXXaIq3KQeWsykmGQTYC9+Hiub3zhvyiD2bc/DuNQ2K2EOrbIZGvJcjkKtvLkZodv1K8OHe5lO4+CyOlZfunscGqis+yDyxou27qjFzoNm3Ry9voVGFn0oxADiqYAOA/xWBVid2XP9efRywXnc3WrvtuD+2B4o/IArX2hXqfEClW9OZFgtyCMd1VlfpI/V4I6csMP8zIJNcA7TT9FuiOm0Z/b6h8zjfV927IhjeKn53fzNycDbec7r14kV1Rgo6zosBqxfOqJdeJGa8zPtQBpdkK6ks6uMLuT2Xwpn6PL6FlvN0KA54q3oMzwRfMe1r1ga5jI6cxU26u0CGqwpfYtBUI5Ws7sWc7Tmeq+75q3UTyRWm5yBddC4VeJhHkFanfsq3RtkGaiI2wrPEyfI+fgTjhoqHGII67y9oKiC4GfZ2WOUmyyISkDJTU8hSq3Z4Yu0msVkFZcJXlOUgMRwerRKmUIZcn1yqaBvt+NkYGSU3g3SQyeTNryc87zi+wx/4g3aml1wrAQFlaEQGUS1K37COhFtjC4cp64pmac/2Lq3KhezfssyEwW2DlV1geLD31wtxNQfgbpW2U9Rbr+78e+SYNyyB57rKAUIbRn4Lzzda/EbYr+fn7Kupmd0dwQrWbo6VGzoCvu6r8TdLlI2v1mGzuLXsGgmWcNta91Nd7UvgOM7r4TKGBSqNae/Y2QbYTCGAXSHfs1d5EB4eHXPOeyFUGV4sCBJw4ub57oV5OGQctdZI4JRH9rpvNYxWrNs7iouKCu+1yMiV7FTfEqrtDej3mbFO9vRf83+SgH+kVue82irVhE/+7z6q+sSTBVistQYCPsm8frzArVNENj/qnlfcagVFgd1Ny+yuR19nNB/LUJPZEAza22zzAMiiKeXaMzZI
 lUvg9g0H
 aIYqDULkqTZOnlILgIuib9mykzsCp8YKtm7tJWLE2rKrk04IBhs7IrPUA04hj0DzgcwgWX3ek+XjDw5PzRyKkICck6lIi5BmHVe4jkRF+gdAAZsnlEnaq+pyrmGt1jdGFFVabttkbXkK8l8mp7h3ajxTddvu5BEa6hHI9vLdAYIa5ShOw2kdJKPFU/nrgYuSUxV6he5Ravy7lQxRKIrUpEn7+7SoNpXJ5/yKgLA3Y7i007TZPu0QeNZozE4kKUkuYMlBgjuhKvHziJd38h9tTXp9/+9/KiB7NTcIAmEoSRbbPhu8PiDc+ZH497DsP3OckU1ZkAZQdr+9+LE/eGYaPOU15hb/dVs6uOrtjLxXatvEowhaRtcjPYNgd6hLJRLFFsvGjR/9uearVNXJJCD4gCJMq8Zf+c+0lIsR5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/09/26 10:29 pm, Uladzislau Rezki wrote:
> On Tue, Sep 01, 2026 at 06:43:43PM +0200, Uladzislau Rezki wrote:
>> On Tue, Sep 01, 2026 at 05:07:30PM +0800, Ye Liu wrote:
>>>
>>>
>>> 在 2026/9/1 14:22, Dev Jain 写道:
>>>>
>>>>
>>>> On 31/08/26 3:24 pm, Uladzislau Rezki wrote:
>>>>> On Mon, Aug 31, 2026 at 11:39:14AM +0530, Dev Jain wrote:
>>>>>>
>>>>>>
>>>>>> On 28/08/26 11:35 pm, Andrew Morton wrote:
>>>>>>> On Fri, 28 Aug 2026 17:17:53 +0800 Ye Liu <ye.liu@linux.dev> wrote:
>>>>>>>
>>>>>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>>>>>
>>>>>>>> The vmap_purge_lock mutex can be held for an extended period by
>>>>>>>> __purge_vmap_area_lazy() which calls flush_work() to wait for
>>>>>>>> purge_vmap_node workers while holding the lock.  Under memory
>>>>>>>> pressure, those workers may themselves be blocked in direct
>>>>>>>> reclaim trying to acquire the same lock via the
>>>>>>>> vmap_node_shrink_scan() shrinker callback, creating a circular
>>>>>>>> dependency that deadlocks the entire system.
>>>>>>>>
>>>>>>>> Two places acquire vmap_purge_lock from paths that can be reached
>>>>>>>> during direct reclaim:
>>>>>>>>
>>>>>>>> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
>>>>>>>>    mutex_trylock().  This is a shrinker that only decays the vmap
>>>>>>>>    pool and returns SHRINK_STOP without freeing memory; skipping a
>>>>>>>>    decay cycle when the lock is contended is harmless and prevents
>>>>>>>>    tasks from piling up on the mutex in the direct reclaim path.
>>>>>>>>
>>>>>>>> 2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
>>>>>>>>    mutex_trylock().  This is called from the vmalloc allocation
>>>>>>>>    overflow path; if trylock fails, another thread is already
>>>>>>>>    purging and the allocator's retry will find freed space.  The
>>>>>>>>    notifier chain provides a fallback if the retry still fails.
>>>>>>>>
>>>>>>>> Both trylock failures break the circular dependency: the lock
>>>>>>>> holder's flush_work() can complete because workers are no longer
>>>>>>>> blocked on vmap_purge_lock in the direct reclaim path.
>>>>>>>
>>>>>>> Thanks.  AI review expressed a couple of concerns:
>>>>>>> 	https://sashiko.dev/#/patchset/20260828091753.299295-1-ye.liu@linux.dev
>>>>>>
>>>>>>
>>>>>> Sounds legit to me. Now there is no guarantee of purge being successful, and we
>>>>>> can get a spurious failure.
>>>>>>
>>>>>> How about using a WQ_RECLAIM workqueue:
>>>>>>
>>>>>> vmap_purge_wq = alloc_workqueue("vmap_purge",
>>>>>> 				WQ_MEM_RECLAIM | WQ_PERCPU, 0);
>>>>>>
>>>>>> I see the same pattern in __lru_add_drain_all() and kmem_cache_init_late().
>>>>>>
>>>>> WQ_MEM_RECLAIM makes sense but this is another patch.
>>>>>
>>>>> I copied here AI comment:
>>>>>>
>>>>>> Does replacing this blocking lock with a trylock break synchronization for
>>>>>> the callers?
>>>>>>
>>>>> No it does not. If someone is doing reclaim we do not wait and do not try
>>>>> to do it again thus fail allocation.
>>>>>
>>>>>> When vmalloc space is exhausted, alloc_vmap_area() calls
>>>>>> reclaim_and_purge_vmap_areas() and relies on its blocking behavior to ensure
>>>>>> that free space has actually been reclaimed before looping back to retry:
>>>>>> mm/vmalloc.c:alloc_vmap_area() {
>>>>>>    ...
>>>>>> overflow:
>>>>>> 	if (!purged) {
>>>>>> 		reclaim_and_purge_vmap_areas();
>>>>>> 		purged = 1;
>>>>>> 		goto retry;
>>>>>> 	}
>>>>>>    ...
>>>>>> }
>>>>>> With this patch, if another thread holds vmap_purge_lock, mutex_trylock()
>>>>>> fails and the function returns immediately.
>>>>>>
>>>>> If reclaim is in progress and trylock fails a caller repeats only one
>>>>> time to retry an allocation. There is no any infinite loop.
>>>>>
>>>>>>
>>>>>> The allocator then retries
>>>>>> instantly without waiting for the concurrent purge to complete.
>>>>>> Because the retry fails and purged is already 1, could this cause the
>>>>>> allocation to abort and return a spurious vmalloc allocation failure
>>>>>> (-EBUSY or -ENOMEM)?
>>>>>>
>>>>> vmap space can be fragmented and not avail for 32-bit systems. For
>>>>> 64-bit system it is likely impossible.
>>>>>
>>>>> But, i think we can overt mutex_lock() into mutex_trylock() just only
>>>>> in the:
>>>>>
>>>>> static unsigned long
>>>>> vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>>>>> {
>>>>> 	struct vmap_node *vn;
>>>>>
>>>>> 	guard(mutex)(&vmap_purge_lock);
>>>>> 	for_each_vmap_node(vn)
>>>>> 		decay_va_pool_node(vn, true);
>>>>>
>>>>> 	return SHRINK_STOP;
>>>>> }
>>>>>
>>>>> so the reclaim path is not blocked. It should also address an issue
>>>>> reported by the Ye Liu <ye.liu@linux.dev>.
>>>>
>>>> IIUC you are suggesting mutex_trylock() only in the shrinker path. But
>>>> then, the following is possible no: take purge lock, try to get a
>>>> worker thread, worker thread is stuck in vmalloc -> alloc_vmap_area
>>>> -> reclaim_and_purge_vmap_areas -> take purge lock?
>>>>
>>>>
>>>
>>> Personally, I lean toward the WQ_MEM_RECLAIM workqueue solution. 
>>> After taking a closer look at the code, I noticed a subtle but 
>>> potentially problematic scenario:
>>>
>>> When drain_vmap_area_work acquires vmap_purge_lock and calls into 
>>> __purge_vmap_area_lazy, it may subsequently invoke queue_work/queue_work_on 
>>> on the same CPU's system_wq. If the newly queued work ends up waiting 
>>> for an available worker on that same CPU, while the current worker is
>>> blocked waiting for that very work to complete (via flush_work), 
>>> we could end up with a self-deadlock on a single CPU.
>>>
>>> Theoretically, this seems possible. I suspect the reason we don't 
>>> see widespread reports of such deadlocks is that the nr_purge_helpers 
>>> logic limits the number of asynchronous workers; when resources are tight, 
>>> it falls back to synchronous execution (purge_vmap_node directly), 
>>> which avoids queuing additional work. 
>>>
>>> Using a dedicated workqueue with WQ_MEM_RECLAIM would provide a clean, 
>>> explicit isolation—ensuring forward progress under memory pressure and 
>>> eliminating the risk of interfering with other subsystems' workqueues. 
>>> I believe this approach is more robust in the long run.
>>>
>>> Perhaps like the code below：
>>> the dedicated queue eliminates the self‑deadlock risk, and the trylock 
>>> in the shrinker prevents recursive lock attempts from reclaim contexts.
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index bea9f76ed7e7..68fc1f5acb2f 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -2218,6 +2218,9 @@ static unsigned long lazy_max_pages(void)
>>>   */
>>>  static DEFINE_MUTEX(vmap_purge_lock);
>>>  
>>> +/* Workqueue for lazy vmap purging; WQ_MEM_RECLAIM guarantees progress. */
>>> +static struct workqueue_struct *vmap_purge_wq;
>>> +
>>>  /* for per-CPU blocks */
>>>  static void purge_fragmented_blocks_allcpus(void);
>>>  
>>> @@ -2408,9 +2411,9 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>>>                                 INIT_WORK(&vn->purge_work, purge_vmap_node);
>>>  
>>>                                 if (cpumask_test_cpu(i, cpu_online_mask))
>>> -                                       schedule_work_on(i, &vn->purge_work);
>>> +                                       queue_work_on(i, vmap_purge_wq, &vn->purge_work);
>>>                                 else
>>> -                                       schedule_work(&vn->purge_work);
>>> +                                       queue_work(vmap_purge_wq, &vn->purge_work);
>>>  
>>>                                 nr_purge_helpers--;
>>>                         } else {
>>> @@ -5519,10 +5522,14 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>>>  {
>>>         struct vmap_node *vn;
>>>  
>>> -       guard(mutex)(&vmap_purge_lock);
>>> +       if (!mutex_trylock(&vmap_purge_lock))
>>> +               return SHRINK_STOP;
>>> +
>>>         for_each_vmap_node(vn)
>>>                 decay_va_pool_node(vn, true);
>>>  
>>> +       mutex_unlock(&vmap_purge_lock);
>>> +
>>>         return SHRINK_STOP;
>>>  }
>>>  
>>> @@ -5575,6 +5582,17 @@ void __init vmalloc_init(void)
>>>          * Now we can initialize a free vmap space.
>>>          */
>>>         vmap_init_free_space();
>>> +
>>> +       /*
>>> +        * A dedicated workqueue for lazy vmap purging.  WQ_MEM_RECLAIM
>>> +        * reserves a rescue worker so queued purge work items are executed
>>> +        * even under memory pressure, when workers of the system workqueue
>>> +        * may be stuck in direct reclaim.
>>> +        */
>>> +       vmap_purge_wq = alloc_workqueue("vmap_purge",
>>> +                                       WQ_MEM_RECLAIM | WQ_PERCPU, 0);
>>> +       WARN_ON(!vmap_purge_wq);
>>> +
>>>         vmap_initialized = true;
>>>
>> I agree. We should have it and it should be as separate patch, i.e.
>> split vmap_node_shrink_scan() and dedicated per-cpu WQs per vmap drain.
>>
> And i sent out already the WQ_UNBOUND | WQ_MEM_RECLAIM and separate WQ
> for vmap drain logic. It looks like Andrew/me forgot about it:
> 
> https://lore.kernel.org/all/20260331202352.879718-1-urezki@gmail.com/

Great! Perhaps resend it and we can review it?


> 
> --
> Uladzislau Rezki


