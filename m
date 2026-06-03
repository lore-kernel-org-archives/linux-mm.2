Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9819CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2036B0088; Tue,  2 Jun 2026 23:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862786B008A; Tue,  2 Jun 2026 23:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7514B6B008C; Tue,  2 Jun 2026 23:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 634876B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:03:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F56D1A0208
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:03:12 +0000 (UTC)
X-FDA: 84837105024.01.9BE8FE5
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 254181C0007
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:03:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QBFB3dbi;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780455790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVn12Hvb9FGkLc5N/aP4mYm2YYdVU4vVM0uYVFz4Dq8=;
	b=R37ukE/lsovrXjk8rSjKLO2MhNfWk3ZwK+FtyyOaOfFtLWj3sTXMnA7ZQ5XvcFr8BCrpC/
	123T9kjprpGnYbaGUxSUCoTR+6MOxJOCrcAeQYAM8aNVFVR+ydOebheBBqe0vl3fMLA+7R
	RMALl5N//vxx+wTnx2Wm/ttPKXTxUyk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QBFB3dbi;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780455790;
	b=CCea4msaffTfmBriFiTNm5ji80L1HdKk1zSZpRVA8IuEV9pyZmwGLGWCAgHgqkKNvVPSqV
	FI/x6NBXgd5NR5XY4ZCRwgOXzBCe5GaigFwswJ9eZUnBmmRPdja9FfoHqT/NwFa2ZN6Suf
	1NpYVD3uYWuEjpWHbzl6/V2y5YVj0ko=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8422a92b6d6so103274b3a.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780455789; x=1781060589; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VVn12Hvb9FGkLc5N/aP4mYm2YYdVU4vVM0uYVFz4Dq8=;
        b=QBFB3dbiA5XLCmfkIvXWGzCAwRh84IeDzFCejVzaKSgBs5JCPG/cfnE31BeI63ZKPW
         q/GjDyjINCOtAFHUeltkpxEs5605r2ETayZgw3Y8pAXdEVc4T11PtwkTuN5Udf8Zre5Y
         YwwbVhK+C2QgDoVpLrfPtg10jmeah7ITMOtn188Od8Hrrp4QIl4wqbHTaRG+zExBTPHT
         fDMu2lJ4ycHc94f1vvW4Bh55wCUNNvK6TiOM0hrFEZGf+U7seQRJxBifjVb3UyA6KQQg
         KRXJgt5RmrHUBUnSOAzCLMazRU8X8xRiOVqaZnBuIzWAjiG4lrXYReTcVZM8h/qtGNLL
         nTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780455789; x=1781060589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VVn12Hvb9FGkLc5N/aP4mYm2YYdVU4vVM0uYVFz4Dq8=;
        b=mTH0+JYUbxF8hzMevBU7Wp8GM3a3g9sIkABQHe27Ap0+AcpjyTxvmKPxPidOUycFYR
         fvSZIC7cbhrXcvQai/1ZqJeOgn6V+cYX5cbKHccFlkyqzh+EgOjDJzh22RfNM3pczQs2
         U7sIYFHsoDR1kfk5uY1Wbi0S8V89SHjHThyHKDnm65ajLdvRooX2KmKdq+tnVWklp2DV
         hFUSWXxiAVg3Tt0EZ6FOPqpkwRwjcxap40vJZLXT+RGi7/eAS0QnbXCj9nF0TErmklbi
         4Z7TR1e3v/OSkSuKp8bgqnEdzpvX13OJOVB6Bdy0GEA/qYZTr38TsKHgsYvVFf+tLcot
         QhyA==
X-Forwarded-Encrypted: i=1; AFNElJ/GEw6olBblfE4eWK/qzSiN/QIrUrY5Mg6oh3UztvitQKFSz5LpTMIQU56T7J+gAP8nq66tIya2gg==@kvack.org
X-Gm-Message-State: AOJu0YxzbeKuwqrhSuNEqEpkkOMYy0ZjvwWhKnOhfo9Hjp7WrrDmwj/3
	UmwXhTqTdWqF4z+iREAdFIyzZSyZhA6uzj+bCkMlILet38L3XjUg7TqD
X-Gm-Gg: Acq92OFml2t9GIvmdkE12DMHC6NpboxUJd/9nrcu5c2P3y1+BbH4L7/+HjGYoE72Jq7
	GIgb+R1nfAW2y81kh+ubilsZvVMhMVF2jVEZMsYwJE+6D3QwwxbSJn1fySz9sjjZZPwQ3DnWiHm
	RrRiKpDxbXxBn6K/z2yXY2KKjDuXixNZICOE+8d8/7m/iyDD3idf6E9ihSt0lgFcayl++qCASOE
	jvUTiD9sWOwPnKNItuqq3zBV8PxH1XjcfU0i1OZoyzZmbA0WJNE9kBckzlxetU+1lXq7L1m4YJS
	Qlsqs3QLZVDrI/L1F1CU0mtGdctTNfXcOlFJ/U5ns8WWzmCRcM+7vW8Lyhf0GKBA7WpeZ1AL0gB
	dvezohWvk2evh8BrIyovRu2/BeeB80qvwHzRvgu2hsgy/EzpXhFwIy48gDsR5/Ufhk2A4oWzMlT
	wnS3VTp4yI6eigiATwhuEzG6Tz1qv1lR2rzlPJLjyP0bUSJqylfAv7vNdpjq6xeCZJ
X-Received: by 2002:a05:6a00:f08:b0:837:f111:b70 with SMTP id d2e1a72fcca58-84285975450mr1047918b3a.4.1780455788827;
        Tue, 02 Jun 2026 20:03:08 -0700 (PDT)
Received: from [10.125.192.75] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428235006dsm1357752b3a.13.2026.06.02.20.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 20:03:07 -0700 (PDT)
Message-ID: <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com>
Date: Wed, 3 Jun 2026 11:02:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
 <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
 <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com>
 <ah9i3uhh3PFiS0Uk@google.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <ah9i3uhh3PFiS0Uk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 254181C0007
X-Stat-Signature: in44eoshmkir6odamethwd9qur1q7xyh
X-Rspam-User: 
X-HE-Tag: 1780455789-1110
X-HE-Meta: U2FsdGVkX1/RWE30Rm6cjZy/eAQBE7/rmtYkZvBM83GoqzIv50T2PNQFHwZD2Aiab2tW7nbykcEuu0aFJX3WmAZX4EJXj/tpmC8HhCeRUq47uBQy4jD+jV8czSu2lF+6zP8T0l1pnhFxWc+oMjRBxv8qmhiJuNYvaF0XpOezXxcArRnqKxrxnvNhJRWYmluMbXLDIqCxztqenq1RA2P03cLGOIxHbzb9hjo3GB39D21WQXAN+43crS+BVn2YvxYPmN6fkwa8HKP//fWn8rfexvr5h/alHYEW5xsWKVOuRaABy73RRgYBSF3I/Pb73xGPzPTxO1OEjXAkzZapewAcQSUIoP/VNWkSXeGsnq2ldCDxL1GTTBErZjuNVsyuqB3Fb+2Ca1wy0TAZYPdGpH2CkQKmhWyTRt6LyyzVtFK6wELLLy1c0eC4iP2ZHt5oa6OG9swYQYWe7FkNPEX1KlqSodJ39EeS5wy13QS3ceas60u25BulDxIDGkE7IKQ+9q0N0J6e4629bVD0eZ+E3leybqSj84opyUY2dOQ7gHb/mdWlvMZxT10ugzOZyclptXiwFBiVZWS9AIR8d+ZhY+VTSTOcG/nPGnPd3Eugj2DUYz4I178/zUPxGUHKn70TtMDU3t9iVvPxt6kUFDeRY4ciVttny8AHcRoT6u2WwW9A1GCCNFvuclqxSDTumOWKjE7DuxJ9f0rh4mQuSIWicW2Ycn/EQIPlxrXK1dZO6hSWGlDulJW8q9SgzLNvuivyUbS6youHAMItUlCvKwUqOdoLbkLWTtGDVA/B5ocUsyWCg6dT483215PxkEs+0pclOcDYHQn/2vVU4VD7eGEa9Y3ocnbiO2JjGD8yHC5VEt5LkITJYntV8nrBt5IdOR3kJLa/KQUuE3qE8H8BuAi2z91rITiITXuHRpL8sUsrcCd+OiG43swVOkQXR/0tnewSuXBRKE4/LXjSz7gywcKlBp5
 csRk0T/0
 Z3ZkXrJsQmuvLGei+zZP6O+/7jk/MP3Tp6+6po5NODHPZF86inzcCibrWAZiz4Lt77vjxthToF/GoTG344rFF6lMx/B1Jf0/10Xs5NlSU5dZw2J6kdJpJRugqRlUlkwRrdAJAvLwZ6sYOHiK+Er+CGJKBvUMn49SuRAGdZLfitas+ffbh7SZC7nM57+/FL1TESG6KUl/R7zxD17vWVzPUwz/livAaXlK/gwMbCscBl4V+xe3DNHfj8nU7D+39aP6K/JfSG9BqdMuv/jusj4+g4Ffdbojk2InjkYycacIi0uDQvlPE+pitLGzmSRcUcbv/iig9GoD/D70JjpcB88f9J/STui9pEoZXxjD/GWhfLYKKEAdbTQQLYfjD3yeekyX0e8uj/jVjKMW05U/qA20riuK5xy5tayDldCZdLLFoLw554UOtcM/bA0dwNZ6rAEyUaXaKkAmk0+4q+JIL5xP4To8qaAtwuwNnHaDECPUb/6mPQKn+X2MgnaVh489tguilRrkq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/3 07:19, Yosry Ahmed wrote:
>>>>>> Proactive writeback also wants a similar per-memcg cursor that is
>>>>>> scoped to the specified memcg, so that repeated invocations against
>>>>>> the same memcg make forward progress across its descendant memcgs
>>>>>> instead of restarting from the first child memcg each time.
>>>>>
>>>>> Is this a problem in practice?
>>>>>
>>>>> Is the concern the overhead of scanning memcgs repeatedly, or lack of
>>>>> fairness? I wonder if we should just do writeback in batches from all
>>>>> memcgs, similar to how reclaim does it, then evaluate at the end if we
>>>>> need to start over?
>>>>>
>>>>
>>>> Not using a per-cgroup cursor will cause issues for "repeated small-budget
>>>> calls" cases. For example, repeatedly triggering a 2MB writeback might
>>>> result in only writing back pages from the first few child memcgs every
>>>> time. In the worst-case scenario (where the writeback amount is less than
>>>> WB_BATCH), it might only ever write back from the first child memcg.
>>>
>>> Right, so a fairness concern?
>>>
>>> I wonder if we should just reclaim a batch from each memcg, then check
>>> if we reached the goal, otherwise start over. If the batch size is small
>>> enough that should work?
>>
>> Even with a small batch size, for small writeback requests triggered by
>> user-space (e.g., 2MB, which is batch size * N), it might still repeatedly
>> write back from only the first N child memcgs.
> 
> Yes, I understand, I am asking if this is a problem in practice. For
> this to be a problem we'd need to trigger small writeback requests and
> have many memcgs.
> 
>> This could cause the user-space agent to prematurely give up on zswap
>> writeback.
> 
> Why? The kernel should not return before trying to writeback from all
> memcgs. If we scan the first N child memcgs and did not writeback
> enough, we should keep going, right?
> 

Yes, this issue is not caused by the kernel, but rather by our 
user-space agent itself.

For instance, suppose a parent memcg has two children, memcg1 and 
memcg2, each with 200MB of zswap (100MB inactive). Triggering proactive 
writeback on the parent memcg will exhaust memcg1's inactive zswap 
pages. After that, even though memcg2 still has plenty of inactive zswap 
pages, it will continue to write back memcg1's active zswap pages. 
Writing back active zswap pages causes the user-space agent to 
prematurely abort the writeback because it detects that certain memcg 
metrics have exceeded predefined thresholds.

Of course, real-world scenarios are much more complex, and this kind of 
case is extremely rare in our environment.

That being said, your suggestion of using the global lock for the 
per-memcg cursors makes the writeback fairer and would resolve these 
corner cases.

>>> What if we do something like this (for the global cursor):
>>>
>>> 	do {
>>> 		memcg = xchg(zswap_next_shrink, NULL);
>>> 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
>>> 		/* If the cursor was advanced from under us, try again */
>>> 		if (!try_cmpxchg(zswap_next_shrink, NULL, memcg))
>>> 			continue;
>>> 	} while (..);
>>> 			
>>>
>>
>> Regarding the code above, IIRC, both the global and per-cgroup cursors
>> suffer from race conditions. This race can cause mem_cgroup_iter(NULL, NULL,
>> NULL) to return the root memcg or its descendants, leading zswap to write
>> back pages from the wrong memcg.
> 
> Not the wrong memcg, it will just go back to the first memcg again,
> which should be fine as I mentioned below.
> 
>>
>> Additionally, since mem_cgroup_iter() puts the prev memcg ref and gets the
>> next memcg ref, a try_cmpxchg() failure on CPU1 might also lead to a ref
>> leak for memcg1.
>>
>>
>> 	CPU1                                       CPU2
>> memcg1 = xchg(pos, NULL)
>>                                 memcg2 = xchg(pos, NULL) memcg2 = NULL;
>>
>> memcg1 = mem_cgroup_iter()
>>                         mem_cgroup_iter(NULL, **NULL**, NULL) error memcg
>>                                  try_cmpxchg(pos，NULL，memcg2） succeed
>> try_cmpxchg(pos，NULL，memcg1） **fail**
> 
> Yes, we can probably just take a ref on the memcg before calling
> mem_cgroup_iter(). That being said, I think we can just keep the lock,
> see below.
> 
>>
>> I took a stab at implementing a cmpxchg()-based zswap_mem_cgroup_iter()
>> modeled after mem_cgroup_iter(), and it actually doesn't look that complex
>> after all :)
> 
> I don't think we should re-implement mem_cgroup_iter() here.
> 
> [..]
>>> There is a window where a racing shrinker will see the cursor as NULL
>>> and start over, but that should be fine. We can generalize this for the
>>> per-memcg cursor.
>>>
>>> That being said..
>>>
>>>>
>>>> Currently, this lock is only used in shrink_memcg(), proactive writeback,
>>>> and mem_cgroup_css_offline(). Note that shrink_memcg() only acquires the
>>>> lock of the root cgroup, and mem_cgroup_css_offline() is unlikely to be a
>>>> hot path.
>>>
>>> ..this made me realize it's probably fine to just use a global lock for
>>> now?
>>>
>>> IIUC the only additional contention to the existing lock will be from
>>> userspace proactive writeback, and that shouldn't be a big deal
>>> especially with the critical section being short?
>>>
>>
>> In the current patch implementation, this lock protects the cgroup's own
>> cursor variable. During each writeback, we only acquire the spin_lock of the
>> target cgroup itself; we do not attempt to **spin on any child cgroup's lock
>> while iterating through the descendants**.
> 
> Oh, I did not say anything about the current patch adding contention. I
> am suggesting we just keep using the global lock for the per-memcg
> cursors, if we keep them.
> 
> Right now, without this series, the global lock protects against
> concurrent changes to the global cursor from concurrent shrinkers. After
> the series, the only added contenders are userspace proactive writeback
> threads. Unless you have 10s or 100s of those, it should be fine to keep
> a single global lock, right?
> 

Ah yes, sorry about that, I misunderstood what you meant. Thanks a lot 
for the suggestion and for taking the time to explain it so patiently. 
I'll switch to using the global lock in v4 patch.


> Yes, userspace can affect writeback efficiency, but we can split the
> lock when it actually causes a problem.

Agreed.

> 
>>
>>
>>>>
>>>> So, should we keep the spin_lock or go with the cmpxchg() approach?
>>>> Yosry and Nhat, what are your thoughts on this?
>>>
>>> I think we should experiment with the global lock first. See if you
>>> observe any regressions with workloads that put a lot of pressure on the
>>> lock (a lot of threads in reclaim doing writeback + a few userspace
>>> threads doing proactive writeback). See if the userspace threads
>>> actually cause a meaningful regression.
>>
>> Sorry, it seems there are some implementation issues with the global lock
>> approach.
>>
>> In practice, our user-space agent mostly operates in the following two
>> scenarios:
>>   - Triggering proactive writeback on the same cgroup at different times
>> (sequentially).
>>   - Triggering proactive writeback on different cgroups at the same time
>> (concurrently).
>>
>> In both cases, there is no lock contention. So, the current lock works
>> perfectly fine for us.
> 
> Would using the existing global lock work for your use case? How many
> different cgroups can you end up reclaiming from concurrently?


It should work fine. We typically only have a dozen or so user-space 
agents triggering zswap writeback, and the critical section is very 
short anyway. I will implement this next.


Thanks,
Hao


