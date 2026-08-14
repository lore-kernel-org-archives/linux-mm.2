Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D36BC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01CDD6B067C; Fri, 14 Aug 2026 06:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D996B067D; Fri, 14 Aug 2026 06:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71CE6B067E; Fri, 14 Aug 2026 06:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE49A6B067C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:32:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 41E601A0405
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:32:25 +0000 (UTC)
X-FDA: 85099510650.06.0D0E9A8
Received: from mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
	by imf14.hostedemail.com (Postfix) with ESMTP id A2DF010000A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:32:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nESwCP6s;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.225 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786703543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OskVd3c1w4C9fNrLtDbY5/lP4BgxS044kKJ+RLzN0KU=;
	b=yKMpVthCj8rsAXNlgDTG2seEXSQXlczzyf1TaXWLKwP1bTIuQrEGu6zR4qGxJhPwVS/+R/
	LS8ZEUQuAE/LJk4vqTEY8eALH60szvHjN4Hssn0MZSg6pwJDQc3VbZn8Z4w6yOHF2f0vNh
	6ON5gDlqqEeLs9qMS+IU5xn6VX2Jo/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786703543;
	b=NqCShevwFF57rsCwX21jmMkXcPSzybusK1IUVFWn0dJ+yJJ1BNnfooFSkC2LP7/oc0k00V
	g71hjyUhvGSNF2YNhQ2Fskl4FnoqMqEe1uq5JO0ygowfMKb5UE47GWFwLNWw/UjsI3/g34
	jWqiuEn4svjgQdZnKz3w6It+TZmEKt8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nESwCP6s;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.225 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=t+a+FxRNFjwPm5BphqfBB+v6WxiBUG83wt0tKUTht2U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786703541; v=1; x=1787308341;
 b=nESwCP6sWKpUqbYM4jqpBHIccctzN+Rnwbp85cJU/dyDYkpBKJpeYB5IJHHY9RJnPbprfno6
 FkBgqj/wWVTezT+yeQLWieV2DAr3BgVD0zwXNQxsQY10NxX1+iOd6w0melSHKQunKGcKnA2XfAi
 UjXzRE1jSCUXGaby/wxYUOOg=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a02:6b6f:e75b:1900:855:edd6:ce7b:4965] (2a02:6b6f:e75b:1900:855:edd6:ce7b:4965)
	by smtp.migadu.com with ESMTPS id 63a03deb27faceb6;
	Fri, 14 Aug 2026 10:32:10 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <f330dd75-d9b8-4259-a02f-9e3ff4bcdc1e@linux.dev>
Date: Fri, 14 Aug 2026 11:32:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm/vmpressure] ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: kernel test robot <yi1.lai@intel.com>, oe-lkp@lists.linux.dev,
 lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org
References: <202608131743.c6a7dda4-lkp@intel.com> <an34C2N-yqfok2Nn@linux.dev>
 <017721a3-5eae-449e-8b86-75cffb503dd3@linux.dev> <an3-aksL0MZPM3ZJ@linux.dev>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <an3-aksL0MZPM3ZJ@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: iw1uorbpzxskb6wdjhmyd33p78nxqpgi
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2DF010000A
X-HE-Tag: 1786703542-214153
X-HE-Meta: U2FsdGVkX1/kwnB3kHVkB+gGhBrl/lKan9iLx27/+ZC9ELgxHAzSlg7k4j8lhB8MLQaYbi4koDcNzPWMalpkZOq0GGUEY5gj8QrZeyIxONHQujobDEogfRYNJXKIo87anrmAME/LIvBL2i0MYc9nNTxXNqdJ+xNmb7K3lgBb8qkpmVyuD4z4dv88RhbUlfL/eB26Q5p1uJaM90jrbPuLHTRN3ZPqKDqHyCIxLSYPRzvT2Mws9GSZhvYx18R+Uc4FPfvk41sM7YXDX2I5KnNj25t+dG+aXBVTFh5iJyysHjAKshHzSmdrqSBEzhM042z9LWbJ5R52xeCjBKjvXNOtWWq1HnqLi4BKCqfksKcLzD9fJHyrBJFKxjwBrO4lsNiE5tqGJVnP+F6N2np3HXw5Toy3wp5vU4jx0RAfd2T6X+4lm05P9t9yJaFHPjAKEdP7hoIKGHXMaVqJAIwoS+AobmRPyFT03SCP8Ti/3iS7tRy3hBzuMKC0FDf+ZEzrsXNercbeMJ5egKQqR1/58T+TUwsu9eXuOI53X464K59HojzrWnUz16/DIRiunSIGC1S4MgsSrfrVEArb8u5wfqgkPQ8Y0J7895meILW4Saf+qyPNgf//TRSvY/uwI8whzeleWLErMv0tjDtbU6gxVjQsUxsJLuCADFaTsvbTsSCj2m1pB/H7TKS37LmEPlLsKyjcDt/Ssrn3iijQfoDg8ZPZeyCpJx6eK1MkmSr42fD4HkjBDhIaqdfFQbys71UbrwJzm7plMf5KCHQyggTuMwB2+ftE/OPOjSozl68g0MUhqUvNAbaGzRpXoPRfwxPAgM/GdrbduK20ERBzyqVOY0Y0JOaFUT5hWLLKm9AzIiFcP6lmA5338uilXvfnTeWNdEwYwAA/z1gPjgBULVqw20Xx3KhzvX4Fsej7CjYn7csMx/tUtYseHtnOgSX6PX+cTNtNiHH5a+SW7EjDDkwRkcK
 CzVtZWQ5
 skQZyujTATbUDfcAPuQ92Vmm6vB0el8fB+mBtGwFWlHow017TKdAJCTDgSsGpr0Y1XyZkuyViIDXKLyi24LGrV/gka9VseLAXFDczvzGgdGyT5+NdTzOJpWkLxvPu9PuufUaBQ74Wz1QVzEtt39kYFFUo+xCqgwBcD/6ekRZIvQcJBj6IE6HCAmFQLDyTikADJU6r6hvX+bwxgPG8P8mNlKlSt5MrHb/dASOdHUSYCsnF/0MQ8dqkAPMd7dmfN12RjfE/hzrCxLRmxhW+Ele+0Eo1Y+pRYX00V8BKqnfxgG4Nsc9enuZ74NJz3FXPFhwjIXvpW23WpozvRnhr0QoTWZRZan6lDnBYCFZdIiWdP2VxJ3A1sW63lgnP/mhtbgLpB4utwnlAoqfXg2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/08/2026 18:29, Shakeel Butt wrote:
> On Thu, Aug 13, 2026 at 06:14:50PM +0100, Usama Arif wrote:
>>
>>
>> On 13/08/2026 18:01, Shakeel Butt wrote:
>>> On Thu, Aug 13, 2026 at 09:16:22PM +0800, kernel test robot wrote:
>>>>
>>>>
>>>> Hello,
>>>>
>>>> kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:
>>>>
>>>> commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>>>>
>>>> in testcase: stress-ng
>>>> version: stress-ng-x86_64-29ce10a2c-1_20260712
>>>> with following parameters:
>>>>
>>>> 	nr_threads: 100%
>>>> 	testtime: 60s
>>>> 	test: mremap
>>>> 	cpufreq_governor: performance
>>>>
>>>>
>>>>
>>>> config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
>>>> compiler: gcc-14
>>>> test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
>>>>
>>>> (please refer to attached dmesg/kmsg for entire log/backtrace)
>>>>
>>>
>>> Hi there,
>>>
>>> Can you please test the following patch and see if it fixes the regression?
>>>
>>>
>>> From 84c0b05b3bc5cf73ee66ead75aafb1ad684462c3 Mon Sep 17 00:00:00 2001
>>> From: Shakeel Butt <shakeel.butt@linux.dev>
>>> Date: Thu, 13 Aug 2026 09:38:28 -0700
>>> Subject: [PATCH] memcg: keep vmstats_percpu off the memory_events[] cacheline
>>>
>>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>>> ---
>>>  include/linux/memcontrol.h | 10 ++++++----
>>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index e78bc98ab229..e25d5b9a1db8 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -246,8 +246,13 @@ struct mem_cgroup {
>>>  	/* handle for "memory.swap.events" */
>>>  	struct cgroup_file swap_events_file;
>>>  
>>> -	/* memory.stat */
>>> +	/* Read-mostly. */
>>>  	struct memcg_vmstats	*vmstats;
>>> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
>>> +	int			kmemcg_id;
>>> +
>>> +	/* Write-hot from here on; do not let it share with the above. */
>>> +	CACHELINE_PADDING(_pad_);
>>>  
>>>  	/* memory.events */
>>>  	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
>>> @@ -266,9 +271,6 @@ struct mem_cgroup {
>>>  #if BITS_PER_LONG < 64
>>>  	seqlock_t		socket_pressure_seqlock;
>>>  #endif
>>> -	int kmemcg_id;
>>> -
>>> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
>>>  
>>>  #ifdef CONFIG_CGROUP_WRITEBACK
>>>  	struct list_head cgwb_list;
>>
>>
>> I was currently testing this diff, not sure which one would be better.
> 
> I was just checking if false sharing of vmstats_percpu is the cause. If your
> patch does not increase the struct size, we can go with that as a backportable
> fix. I am planning to rearrange fields of struct mem_cgroup more drastically and
> have it more stable as future work as we continuously see these regressions keep
> popping up.
> 


Yes this makes sense. I did not expect such a big change in a benchmark
with my patch, although I feel like the microbenchmark is probably not
that realistic.

I think another issue is that its a 4 socket system.
I only have access to a single socket system, and I see a 4.38% regression.

Do you know if there a way for kernel test robot to test the below patch
on its host?


From b862e84e7bd6a54b1546b7f21a6cf991253def18 Mon Sep 17 00:00:00 2001
From: Usama Arif <usama.arif@linux.dev>
Date: Thu, 13 Aug 2026 11:42:05 -0700
Subject: [PATCH] mm/memcontrol: avoid false sharing between vmstats and events

Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
vmstats_percpu pointer onto the same cacheline.

The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
60-second run on a 176-CPU test system.  Those writes bounce the line
while memcg statistics paths load vmstats_percpu.

Move cgwb_list into the existing alignment gap and cacheline-align
vmstats_percpu.  This separates the pointer from the event counters
without increasing the size of struct mem_cgroup in the tested
configuration.

The blamed commit reduced median mremap throughput by 4.38% on the
test system with one socket. The patched kernel brings the performance
to within 0.5% of the parent which is within the observed boot-to-boot
spread (up to 1.2%).

Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/memcontrol.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e78bc98ab229b..215e2e87f42b2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -268,10 +268,15 @@ struct mem_cgroup {
 #endif
 	int kmemcg_id;
 
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
+#endif
+
+	/* Keep the hot per-CPU stats pointer away from memory event counters. */
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu
+		____cacheline_aligned_in_smp;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
 #endif
-- 
2.53.0-Meta



>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index e78bc98ab229b..215e2e87f42b2 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -268,10 +268,15 @@ struct mem_cgroup {
>>  #endif
>>         int kmemcg_id;
>>
>> -       struct memcg_vmstats_percpu __percpu *vmstats_percpu;
>> -
>>  #ifdef CONFIG_CGROUP_WRITEBACK
>>         struct list_head cgwb_list;
>> +#endif
>> +
>> +       /* Keep the hot per-CPU stats pointer away from memory event counters. */
>> +       struct memcg_vmstats_percpu __percpu *vmstats_percpu
>> +               ____cacheline_aligned_in_smp;
>> +
>> +#ifdef CONFIG_CGROUP_WRITEBACK
>>         struct wb_domain cgwb_domain;
>>         struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
>>  #endif
>>


