Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3294106FD66
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 03:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0684A6B0005; Thu, 12 Mar 2026 23:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0162E6B0088; Thu, 12 Mar 2026 23:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63C96B0089; Thu, 12 Mar 2026 23:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBFA46B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:04:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 600561A06AD
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:04:58 +0000 (UTC)
X-FDA: 84539547876.23.14C7FBB
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 587494000C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:04:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=ZjaS8gCo;
	spf=pass (imf01.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773371096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/N2p3pusCQ/UIw0fOt2x17/Iu7DoCVG910II1IT00xU=;
	b=h/6X8dNJXxyAqXRWwWGaJthdi+7DSAuSUkIklgDki/I6q13OeBFw8jlxuL03KwimKrZkKO
	5nnH8aXK6ooH4qCSao1+M+G27dTfXbBa6GHwaoRj0mZ0qZKFPPbIQ8o/wRjLIvAkyDObF7
	NYUDgkDT+2KZP+ryE78ccP8QV9rBbLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773371096; a=rsa-sha256;
	cv=none;
	b=TA9Q8szd9zvsIwREfLZnFF/xCCd2q1eEOLh+MWmrucPiZRJblFSK+jZADZGi7mF33W48Jd
	ts87ACuyLf3tUZ7Py5ZtXheawEqlgj9ojmrHunP5gpqau0ASozMJbfLjayr3xch3ooXM2/
	nYM7Mz2DxAwZJcRVh0snSiIx+5vMWQE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=ZjaS8gCo;
	spf=pass (imf01.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2aece3546e9so2528145ad.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773371095; x=1773975895; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/N2p3pusCQ/UIw0fOt2x17/Iu7DoCVG910II1IT00xU=;
        b=ZjaS8gCoqte/iCFH825F2YrrYrrCIAFS27QC1LZ2ub+LRZr0sGj8vgxHEapiYLDfP3
         BE1S1sKmKqdJARLbmqqAeJoOEpSWrENXi08U630PEuha4TAPuv6LdjBjG2N5oZWgBovC
         aKLTPNOb2YyrSRUJhUhrtQTyWqpDUzh0DbFsgRFKuVY5rj+6WjYuf1Gydw38BuWxzAPk
         1ykidQhVdmXtplu2VgccR+OqDBifxpHoBVvyjG9LHVL/JKIryBFUl0Mnou+X0E+EsklQ
         tFn11P+Auv+IjjUAiG8hfZbrLJONAdUFO17kR7WPfNg4tQW/FMLT5LKBHzSGou4EaijP
         Dc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773371095; x=1773975895;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/N2p3pusCQ/UIw0fOt2x17/Iu7DoCVG910II1IT00xU=;
        b=qwRVbltfPu2CfPHP8L42+8fJ5aRPOgny/uKse5S3AMItdE+xZqkDYgfElwcSyFoee+
         g6rRnyhF+wnG747PnQAjj6/Ckr5qKDOItVDPI38R7tqsHkhD0Ckry1n+m9V6KGfVHoqj
         FV5EOAEA4Wf9St6n3ETDUiTqKj6IYpk5+fZk55P/DyxhNQtEkR5IaFb39adxVvQLM47u
         ApuITWelTv8Q3x8+cGGxng34UkYuS47mtaNon5RYGUscmttB/MyJGrt5jgB3AFxLFvz1
         O0wKhZrBThepv7sf1N1SGqLdMdT8gRXdniyZWPXTfRG5hccvesDUdoZY+T4MiqyHqFl3
         +32w==
X-Forwarded-Encrypted: i=1; AJvYcCWxFnmprpmN6dyV29Es4qacq9TzyKyDIOKn3iWYm+J6fZQ+0mLb+IhVQZkLKixWIpO9C24BWPCAJg==@kvack.org
X-Gm-Message-State: AOJu0YymP6eEhHhiiu/HDu5DOw9Mg+WnO848QfGY2C1hr5KnirnSJOlr
	ZYqXaRwhPAfrdKOzSIZ4WXbUURgWVbw9G1BAqxtlwDH6C+P/74uxV//dvH5FVB3mrBY=
X-Gm-Gg: ATEYQzz4iVK3cyK+8J+gfrOqnBX49fckGkrvgzg3cyTkaQpuotEDHoe+s9a0RXZgxGH
	GGk5H3ewr1CPNw+T6QZolFTQykJ0ppomcQpsFTbzNt7Fa/77mhoPLyQfx3916E7wHyK0phW+aVF
	ky/x0YQPKWABwH8L4GlPqJWyiIVh9naqElz/NJXVS3yQzK8biXy6+Fs7yjdq+UvSgNxMuVBz50Q
	BI7nMcPupctjxyqlhM2s4SsfnqsYZoyhTQRYcNriEnt24tiqvE2as8l/dsN5T90h/VEZjpXCFJK
	FGSRvjrdDrOsessvXo7EhAF9yULFUkevAEfw94ur8eLfetQ+bSR57F7JjiX6JuY18AmEi3M2Ufm
	qzES2AFX1ZWaol0THfUEud53wx+Q4klfO0ANxn4TZCWhWokoxCR79A9RddlQ6Wod2d4dV2t26P5
	6omp8BUj/+zn0ZJvoys9agUz18Qg/lQy0zWoEUiFHSi/YMTCo=
X-Received: by 2002:a17:902:e890:b0:2ae:72fc:92ea with SMTP id d9443c01a7336-2aeca79859bmr16054295ad.0.1773371094930;
        Thu, 12 Mar 2026 20:04:54 -0700 (PDT)
Received: from [10.54.26.107] ([143.92.118.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece83b35fsm5135065ad.80.2026.03.12.20.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 20:04:54 -0700 (PDT)
Message-ID: <5de96310-fc7b-4685-a129-4237bd0f54b5@shopee.com>
Date: Fri, 13 Mar 2026 11:04:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 3/4] mm: shrinker: optimize the allocation of
 shrinker_info when setting cgroup_memory_nokmem
To: Dave Chinner <dgc@kernel.org>
Cc: akpm@linux-foundation.org, david@fromorbit.com, roman.gushchin@linux.dev,
 zhengqi.arch@bytedance.com, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260310031250.289851-1-haifeng.xu@shopee.com>
 <20260310031250.289851-4-haifeng.xu@shopee.com> <abHpPC8tWwU93C1D@dread>
 <bc08d009-fa43-44d0-880f-a37cc200a3b9@shopee.com> <abJUr1bIs62nQC9Z@dread>
From: Haifeng Xu <haifeng.xu@shopee.com>
In-Reply-To: <abJUr1bIs62nQC9Z@dread>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 587494000C
X-Stat-Signature: tisdxrea3cuasnirz57eyy1xyiiaanqr
X-HE-Tag: 1773371096-985968
X-HE-Meta: U2FsdGVkX18K0LSAG6b6HXCnW8ZCoe0C2bWK1KaYFB9+ODjA3nlz5a9kF3onYq0FgFe/frhHJElCtAy9eVs0Emn74El//VaYPaGbPCl4Qao6lsPRJY0/hqyC6q90rNleWC849Cgs8EbxSo5gvAMb/3Oha7VqziOdAEk2hGqrgXfYTtg7EajZUPNRSlOlgFAg9YA8BYJ/dIzMqxXsYSg58SH3mOzmBT0hwz8K7telrEhAqUQlxiK5iwh5Oo4dXMjTMJEnYYIiJXa5r43L/GLZowIzadm/kle/zwLZQufhSpqgAkvWzYNsmSDBAm/zhOBmIW3aKFGcsbURS7wQTT0bhlXweJmJSYFLYAcsU0E2SvNN8dizXjmYtnvtaUf5QA7xnv5AM0SYZz3SA7VwARK6uLL99gG/3xBYKk+A01LumzJZoQEL59cOWX/G62C5h1PoJhbJo49OKfQpLDZxmrsNtLxw1TRrDoBZ3IasSu0chJ68h7gfbieKtBmuDi32Q7VUws1X8EUtUT5xQZ3680IAGuHeeIl2u3EfQkemcNieGyHI/L64xLLbFAhNDSasL/RpLNxUpFvHH6zDpTJwYa/8FIC6h9IlNzsLGVxIs9gsYyjq2BxYpHy+gfyk3QofrRJvaQdMx81BJXX373JG5RZHzkVbqO6DFMQPhrF9s1DtFBglisKWyIbbN6o7JUf4T/gOPoXmMFErlizPvs+DvV4vsDQdSvrDRxeWg3H3dVGgrfB4f9MwdfvNPYhLHpUH/UoVEC3BAJaaGLonP5miarXOxVPGw9HLaD0PNr30Mhq5CBQvC9QNcVqCO+7+iS1Xkewtvn8mOZMn6baJD9MZHjIZJMG++oZkYaeFlKJYYAM5QrJbIJ8E49WIU7fcOTBu/fZQ4Q0Wltg6O6+JpxmRKjVo3T/wSPdNfrXXdhv8rXpzLrCSlmEnOz0/RAvRpM4C3tm7/bqz1CL2stZEp7MF8UD
 RLkwVJma
 R97FqxAGvyF4cmtOB/LuBICvR9Tm1srUkoy8EW1AMzv4spXm4BWsOC1RS2HwycmpawI91gIeynwNdRKk5hMbhm7l8GAjiMMDdQlGH2OmjzM/m1/6pTci1A+oNJNhievBoa+KHdkyT/t3S7PzC9VJk6oOiANpEeXS38DZxhu/G3KlCvAGfuuXsNuyHsUOBj66+ErhZpz8SC/EIcCKSPP4oKxcXjAVt5dXxbd9vPvmPbYEc+EE3WMYGgQuWgQ27WrNFNdNDyOFKuairoWhZz5avPcsdCtIOatfmmTKgwm5JNQMbyv6psPHb90OtJaHeSpiunB20MNZqfQ7Sy/ubRtOZSY+5K7Qm9x0G1ftOTPBHO19sASkoPGKD7aTnqJmvxC56OONVfFI4W1kyKtM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/12 13:52, Dave Chinner wrote:
> On Thu, Mar 12, 2026 at 12:08:42PM +0800, Haifeng Xu wrote:
>> On 2026/3/12 06:14, Dave Chinner wrote:
>>> On Tue, Mar 10, 2026 at 11:12:49AM +0800, Haifeng Xu wrote:
>>>> @@ -78,15 +79,25 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
>>>>  {
>>>>  	int nid, ret = 0;
>>>>  	int array_size = 0;
>>>> +	int alloc_nr_max;
>>>> +
>>>> +	if (memcg_kmem_online()) {
>>>> +		alloc_nr_max = shrinker_nr_max;
>>>> +	} else {
>>>> +		if (memcg == root_mem_cgroup)
>>>> +			alloc_nr_max = shrinker_nr_max;
>>>> +		else
>>>> +			alloc_nr_max = shrinker_nonslab_nr_max;
>>>> +	}
>>>
>>> What does this do and why does it exist? Why do we need two
>>> different indexes and tracking structures when memcg is disabled?
>>>
>>> If I look at this code outside of this commit context, I have -zero-
>>> idea of what all this ... complexity does or is needed for.
>>>
>>> AFAICT, the code is trying to reduce memcg-aware shrinker
>>> registration overhead, yes?
>>>
>>> If so, please explain where all the overhead is in the first place -
>>> if there's a time saving of hundreds of seconds in your workload,
>>> then whatever is causing the overhead is going to show up in CPU
>>> profiles. What, exactly, is causing all the registration overhead?
>>>
>>> i.e. there are lots of workloads that create large numbers of
>>> containers when memcg is actually enabled, so if registration is
>>> costly then the right thing to do here is fix the registration
>>> overhead problem.
>>>
>>> Hacking custom logic into the code to avoid the overhead in your
>>> specific special case so you can ignore the problem is not the way
>>> we solve problems. We need to solve problems like this in a way that
>>> benefits -everyone- regardless of whether they are using memcgs or
>>> not.
>>>
>>> So, please identify where all the overhead in memcg shrinker
>>> registration is, and then we can take steps to improve the
>>> registration code -for everyone-.
>>>
>>> -Dave.
>>
>> When creating containers, we found many threads got stuck and wait shrinker
>> lock in our machine with kmem disabled. And we found that the shrinker lock
>> was held for a long time when expanding shrinker info. As the number of
>> containers increases，the lock holding time can increase from a few milliseconds
>> to over one hundred milliseconds.
> 
> Ok, but...
> 
>> Call stack can be seen as below(based on stable kernel 6.6.102).
>>
>>
>> PID: 4462     TASK: ffff8eff5ca0b500  CPU: 79   COMMAND: "runc:[2:INIT]"
>>  #0 [ffffc9005b213b10] __schedule at ffffffffa3ad84c0
>>  #1 [ffffc9005b213bb8] schedule at ffffffffa3ad8988
>>  #2 [ffffc9005b213bd8] schedule_preempt_disabled at ffffffffa3ad8bae
>>  #3 [ffffc9005b213be8] rwsem_down_write_slowpath at ffffffffa3adcc5e
>>  #4 [ffffc9005b213ca8] down_write at ffffffffa3adcf3c
>>  #5 [ffffc9005b213cc0] __prealloc_shrinker at ffffffffa2db3bf0
>>  #6 [ffffc9005b213d08] prealloc_shrinker at ffffffffa2db9e0e
>>  #7 [ffffc9005b213d18] alloc_super at ffffffffa2ebec49
>>  #8 [ffffc9005b213d48] sget_fc at ffffffffa2ebff48
> 
> .... this is exactly why you need to show your working, not just
> present your solution.
> 
> That is, prealloc_shrinker() API no longer exists in TOT. The way
> shrinkers are registered and run was significantly changed in ...
> 2023 by commit c42d50aefd17 ("mm: shrinker: add infrastructure for
> dynamically allocating shrinker").
> 
> IOWs, the problem problem you are reporting may not even exist on
> TOT kernels. Have you tested your problematic workload on a TOT
> kernel, and if so, what were the results?
> 
>> We use perf tool to record the cpu consuming. I have posted it in the attachment.
>> From the Flame Graph, we can see that the clear_page_erms() and memcpy() in 
>> expand_one_shrinker_info() are the main sources of overhead.
> 
> expand_one_shrinker_info() was somewhat simplified by the above
> series, so even if it is still an issue on TOT kernels, it still
> likely costs less than on old LTS kernels.
> 

I run tests based on stable kernel 6.12.76 which includes the above patch series.
The lock holding time of each expansion is less than ten milliseconds.

Though still traverse all memcgs, but only expand one unit of map and nr_deferred
every expansion. The original code need to reallocate whole map and nr_deferred.
Thus the size to be allocated in old version is much larger than the new version.

Thanks!

>> Therefore, the more shrinkers and memcgs exsit，the process of expanding shrinker
>> info takes longer. This is because when expanding shrinker info, we will traverse
>> all memcgs an record all shrinkers for them.
> 
> Only if the shrinker_info arrays need expanding. This is happening
> frequently because the expansion code only expands the shrinker info
> arrays by one ID at a time. hence if you create a container that has
> half a dozen new filesystems mount in it, the array is being
> expanded at least half a dozen times. Maybe multiples of this more,
> if the filesystem has multiple memcg-aware shrinkers that it
> registers per mount...
> 
> IOWs, we need to make the expansion case the rare slow path, not the
> common fast path here.
> 
> It should be trivial to batch the array expansion (e.g. expand in
> multiples of 8/16/32 slots) and then shrinker instantiation overhead
> should scale down linearly with increasing expansion batch sizes.
> 
> Such an improvement will reduce the memcg aware shrinker
> registration overhead on -all- configurations, not just the specific
> one you run....
> 
>> However, with kmem disabled, memcg slab shrink only call non-slab shrinkers, that's
>> to say, we only need to record non-slab shrinker for non-root memcgs. For root
>> memcg, we still need to record all shrinkers because global shrink call all shrinkers.
> 
> Yes, I know what your patch does - it should be clear that it does
> not address the root cause of the problem you are reporting, merely
> works around it for your specific use case.
> 
> -Dave.


