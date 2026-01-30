Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 002B9D49C66
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 07:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E766B0005; Fri, 30 Jan 2026 02:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110856B0089; Fri, 30 Jan 2026 02:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012116B008A; Fri, 30 Jan 2026 02:22:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E52EB6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 02:22:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92E131A034B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:22:38 +0000 (UTC)
X-FDA: 84387787596.11.4939831
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id BC1F1A0002
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:22:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ktmqdqo8;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769757756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMcRu4QwA2GjVjU5hQW3p3XdUu94fizF7UvrxMPIJbU=;
	b=pHHwA9ShlKw8getW0XQrAFTwjWQxBkW9eh+4Pt4B2F+8KzoAKcL+QHYZbQNPlgHavpSSAS
	JAKWgcil5u6sQ3HALEFVEvTDEtiw1YLe/f7BkHGwg3pm5HpfBFgLjX/9/rjWrEWkP0baBE
	Ct3Ig0uaAXFad7ETaRAJsPm05eVxb4Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769757756; a=rsa-sha256;
	cv=none;
	b=FS9EMMjXsLwG+l9nqxt9UC5DZBLgJjOsEEbjj/oUD+BPmycxwOX2VdlRQ7Jz5Dj+jRX+fj
	Io9eCSYO81SUW8b5ZisTKIXy1a4/oQI499B3h23X6ILcl1NsJWELsdoaQo79NFCuGhfDPc
	aJAcyykbM4+KmiB6Wa4fg0LfMLJatbY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ktmqdqo8;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <4535d53c-68aa-4c3d-b95e-6fbafdb83881@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769757753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DMcRu4QwA2GjVjU5hQW3p3XdUu94fizF7UvrxMPIJbU=;
	b=ktmqdqo8hEUIvmBaLB5kEAOvoWyJMBhFHdYM1Niq9JxZhSbD4k8N9it1RiFmkRH4pg8tme
	WBV6lOxiVdEE4gKY79ZHnJE8JbmRG8lJ7b6x6ffnoo0YlP/LAIo6RJLQ5VrWn3bBQ3mT1S
	39DregSZ+wfBsxMMJldJMaI/oqsQ050=
Date: Fri, 30 Jan 2026 15:22:20 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 28/30] mm: memcontrol: prepare for reparenting
 state_local
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <iu27pt5nqs6myshw57e7dotld33v6lwuyouvquoqc2zmc5loi6@f23auf7hqbdp>
 <9b9057f8-4c4c-4067-b6ba-0791888c25e8@linux.dev> <aXrBiPlpEOOC3cMZ@hyeyoo>
 <6860146b-be12-4d5f-bec1-bbcec1dffbc6@linux.dev> <aXtRWdwwmi7G-Hlg@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aXtRWdwwmi7G-Hlg@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BC1F1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: yi5sbs5dc7rb4j3kxyix7gp5qmj16hds
X-HE-Tag: 1769757755-22385
X-HE-Meta: U2FsdGVkX1+GPD7N0X3PzEVgvtHzjpdrkXCo0h0Nzz2hY4fAkMqPkdsmqb80cvrjcEtf/kQiTZGcRvo/b0KeXUOEbl0p4FzcSMcb4dRY5gXvkrgp1pcZhs23ayFiq+jqtLraxDpLyH5zHLECFQMHzHv+MC4SCv1cAPzkV70+KdB67hVXGln5YqVFT7LX9uIDTLqjCo9nFZbrTewGYVduMM2PMmUVgECfkRZsEhvKY1FJCUJIM+PRhclW0hFOBpqeV1scPAZ6qPzcNyvSJ0mhk1U5ha3jos30OkGFqAqk1T75CD8yx9PF0jjjiNXqJN4YEPDE7/lOHgQSsNjeITa3+x7OpcsrPoH0iDV3rOfza7qrtbtV+bq6uQ7IguJj0SW/+8kwGLDxB1AMZiy5GUdWp4zwBFMwpqhjm04aIeC170zKTPutLSajRwZL7Vm3Lj6te1YNKKvlZTnqF6ja8foRgslzS1U3JWsYEgK17xFSkkaAygu2SkamBErIJIG9QBLyqzABhVhli4JWBzlAYzBzstgdgk+QUID/qVN92xs9PUEA+wKKhV7Gmxa9PwF8hZQGK3fZ6LaWJl/zRvbhrwb8o35jccXobfwncDOpaDaF4Dll+RuQkybk1849thQUEfIy3SkWGV+rj4BqGOl02Rb/RQwTAPkzUzZuL0p6Hdyk/eufbsaavo02pgAlvT285J2V6xd6LAkVYAeIa2pik9TiH6dUdu1wdVhz01b7rKwqpP3uWLyheyRQ6kXj2BUBLc247WRqKCux/5e0GW8DqRvtaXjbeJ/zLeqMmQSypBT43bnvi7EM6TGB4cwoVtr+K82yjjpd8HplKtgQZmlk9xvhrMaIkKjQR8yg6da62ZqhnwdXCPmTsq0NjLmYzzMwhJjPyO3OdnsgMZagi7kifSeAHNdN/s213qD6wIa4/YixC9ceDsYVYkUmTbUOZjsRCS2FLPe4f8gcgORt0JpqwDd
 SkAmWe9b
 6kaQsA+/Im4qid3MFsXLpWAEXCITY8OYj7mc4JtpF4a97Xj8UPk2cbL19ELWvt4HAM4ThMD6UONqOieuKYlQN+2g90dFfhF95z27n0vfgnYWrXQjDr/uGwoAVIDy6h+Hga+VG1315tlnKlh9KhbjDVsWWpQncRtdKwzotGD2m0wAWq0rYwqlvk0mNbTEeCW7FbgW0rEjcZosOiiIZKlSz6dF9euDDPtBChmyXdXcUdN5VH1YtVv21a24Dy5hZNBbb1igNukJq67IM3D4aLsm0z2IbD+xdQacoykh08cuCvL7XTPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/29/26 8:23 PM, Harry Yoo wrote:
> On Thu, Jan 29, 2026 at 04:50:39PM +0800, Qi Zheng wrote:
>>
>>
>> On 1/29/26 10:10 AM, Harry Yoo wrote:
>>> On Mon, Jan 19, 2026 at 11:34:53AM +0800, Qi Zheng wrote:
>>>>
>>>>
>>>> On 1/18/26 11:20 AM, Shakeel Butt wrote:
>>>>> On Wed, Jan 14, 2026 at 07:32:55PM +0800, Qi Zheng wrote:
>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>
>>>>>> To resolve the dying memcg issue, we need to reparent LRU folios of child
>>>>>> memcg to its parent memcg. The following counts are all non-hierarchical
>>>>>> and need to be reparented to prevent the counts of parent memcg overflow.
>>>>>>
>>>>>> 1. memcg->vmstats->state_local[i]
>>>>>> 2. pn->lruvec_stats->state_local[i]
>>>>>>
>>>>>> This commit implements the specific function, which will be used during
>>>>>> the reparenting process.
>>>>>
>>>>> Please add more explanation which was discussed in the email chain at
>>>>> https://lore.kernel.org/all/5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5/
>>>>
>>>> OK, will do.
>>>>
>>>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>>>> index 70583394f421f..7aa32b97c9f17 100644
>>>>>> --- a/mm/memcontrol.c
>>>>>> +++ b/mm/memcontrol.c
>>>>>> @@ -225,6 +225,28 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
>>>>>>     	return objcg;
>>>>>>     }
>>>>>> +#ifdef CONFIG_MEMCG_V1
>>>>>> +static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
>>>>>> +
>>>>>> +static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>>>>>> +{
>>>>>> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>>>>>> +		return;
>>>>>> +
>>>>>> +	synchronize_rcu();
>>>>>
>>>>> Hmm synchrinuze_rcu() is a heavy hammer here. Also you would need rcu
>>>>> read lock in mod_memcg_state() & mod_memcg_lruvec_state() for this
>>>>> synchronize_rcu().
>>>>
>>>> Since these two functions require memcg or lruvec, they are already
>>>> within the critical section of the RCU lock.
>>>
>>> What happens if someone grabbed a refcount and then release the rcu read
>>> lock before percpu refkill and then call mod_memcg[_lruvec]_state()?
>>>
>>> In this case, can we end up reparenting in the middle of non-hierarchical
>>> stat update because they don't have RCU grace period?
>>>
>>> Something like
>>>
>>> T1				T2
>>>
>>> 				- rcu_read_lock()
>>> 				- get memcg refcnt
>>> 				- rcu_read_unlock()
>>>
>>> 				- call mod_memcg_state()
>>> 				- CSS_IS_DYING is not set
>>> - Set CSS_IS_DYING
>>> - Trigger percpu refkill
>>> 				
>>> - Trigger offline_css()
>>>     -> reparent non-hierarchical	- update non-hierarchical stats
>>>        stats
>>> 				- put memcg refcount
>>
>> Good catch, I think you are right.
>>
>> The rcu lock should be added to mod_memcg_state() and
>> mod_memcg_lruvec_state().
> 
> Thanks for confirming!
> 
> Because it's quite confusing, let me ask few more questions...
> 
> Q1. Yosry mentioned [1] [2] that stat updates should be done in the same
> RCU section that is used to grab a refcount of the cgroup.
> 
> But I don't think your work is relying on that. Instead, I guess, it's
> relying on the CSS_DYING check from reader side to determine whether it

Only relying the CSS_DYING check is insufficient. Otherwise, the
following race may occur:

T1				T2

				memcg_is_dying is false
Set CSS_IS_DYING
reparent non-hierarchical	update non-hierarchical stats for child

So IIUC we should add rcu lock, then:

T1				T2

				rcu_read_lock
				memcg_is_dying is false

Set CSS_IS_DYING
				update non-hierarchical stats for child
				rcu_read_unlock

synchronize_rcu or rcu work
--> reparent non-hierarchical


> should update stats of the child or parent memcg, right?
> 
> -> That being said, when rcu_read_lock() is called _after_ stats are
>     reparented, the reader must observe that the CSS_DYING flag is set.
> 
> [1] https://lore.kernel.org/all/utl6esq7jz5e4f7kwgrpwdjc2rm3yi33ljb6xkm5nxzufa4o7s@hblq2piu3vnz
> [2] https://lore.kernel.org/all/ebdhvcwygvnfejai5azhg3sjudsjorwmlcvmzadpkhexoeq3tb@5gj5y2exdhpn
> 
> Q2. When a reader checks CSS_DYING flag, how is the flag change
> guaranteed to be visible to the reader without any lock, memory barrier,
> or atomic ops involved?

The main situation requiring CSS_DYING check is as follow:

T1				T2

Set CSS_IS_DYING

synchronize_rcu or rcu work
--> reparent non-hierarchical
				rcu_read_lock()
				memcg_is_dying is true
				update non-hierarchical stats for parent

Referring to the "Memory-Barrier Guarantees" section in [1], 
synchronize_rcu() can guarantee that T2 can see CSS_IS_DYING. Right?


[1]. 
https://www.kernel.org/doc/Documentation/RCU/Design/Requirements/Requirements.rst

Thanks,
Qi

> 
> As Shakeel mentioned elsewhere, I hope some explanations for correctness
> to be included in the commit message :)
> 
>> I will update to v4 as soon as possible.
> 
> Thanks a lot!
> 
> I'll wait for that and will review carefully to make sure it's correct ;)
> 
>> Thanks,
>> Qi
>>
>>>>> Hmm instead of synchronize_rcu() here, we can use queue_rcu_work() in
>>>>> css_killed_ref_fn(). It would be as simple as the following:
>>>>
>>>> It does look much simpler, will do.
>>>>
>>>> Thanks,
>>>> Qi
> 


