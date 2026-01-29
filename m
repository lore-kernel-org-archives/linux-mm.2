Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81FE0D358E5
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 08:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A867A6B0088; Thu, 29 Jan 2026 03:51:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A166B0089; Thu, 29 Jan 2026 03:51:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9163E6B008A; Thu, 29 Jan 2026 03:51:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81DFC6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:51:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F8A9160920
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:51:21 +0000 (UTC)
X-FDA: 84384382362.18.55C8184
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 366A9160004
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:51:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vvxYXiUm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769676679; a=rsa-sha256;
	cv=none;
	b=hZKFvyU6eDVcgoyww9SPGkWEYGoWDyiSSwidK6j+mEq1n5rhYosfb/TceTxQzPXP3OrodT
	t7B6qAWMaHJu/LsCcpOxeHQcgaKfCOUK5XUf9KKOxRYM8PN9P87PR5IcM5yDS5/0nsx3cA
	xySTmDpTR/Hh8qlZieBzIvtnhP5IjeM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vvxYXiUm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769676679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAdXb4bfUsmEDEKXvxCCDPoLM2r4WzvPltJYWV3bwtA=;
	b=H9GsN9NiQkcXQW1tMjI1rxjonXlb5mi+6dXQ+bPr0GBn74Go9r8kwyLvsHQmtUTRSInwLL
	GnbZPkdEO0v3mnYStBhvNaiMMMHW2Ad5s7EnPhFYPOnRqxnmizbamwoW0nn4IawaqWcwkT
	0mMhUDbLBxqFvg/wuKfrUpTwY10M4Tk=
Message-ID: <6860146b-be12-4d5f-bec1-bbcec1dffbc6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769676676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uAdXb4bfUsmEDEKXvxCCDPoLM2r4WzvPltJYWV3bwtA=;
	b=vvxYXiUm1xh5hSI0HndFd1wGYWaZAXe1kxDlslz5niCHLt+NR7Yn1ohQi7vhPZBTvXJ7mV
	1TOrUgLmqGZQW99e0EBT4XQfvagxB0MBQuERtxdBLv5eBFvZmMTRRTrcUfg5c03zZwDx1O
	c0M/oTunUTmd9zvO4CMOmjcmhXbsWRo=
Date: Thu, 29 Jan 2026 16:50:39 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aXrBiPlpEOOC3cMZ@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 366A9160004
X-Stat-Signature: qgif1jhpbj4959pxa4mnk6q53awcqtq6
X-HE-Tag: 1769676678-270942
X-HE-Meta: U2FsdGVkX1+jLdmsiLsBi0rMZs8yyeBc++p47xvrxYxIOKlkI+SWz9KZ0CFvLYaIUxP7frdhXsrB0wThT4EbG71itbnhKoT2MCbHCWAz935elWbNwo11EesG5P7UxijDmPbziIbWgz3nUPdVCTysdeVGnDJqFZtcp1gXDE9Tb8N852AmoVKVy2OsA5FYJGQrMJy7UmHVo2w6IbPqdz7139Wmy2KhwbpuqIvhrOK2eNkDtL4UPjPlEIkNpv3k+++IxIBvoI9Q5+o4yvKZYVOpcLVN/ltd1E2XP7hPN8cOlf0srINV+3D6OqRoMCDuKK3rB6quBYPw+5slTooowHpDGL61jDiTBjdV67u5C05SlthPgQhFDnbNePo/akVkN1O9FLYlR4ylODO+Bc4MKLQwL35UKRrbxtd5s7HJ7ScIpNjA9aK3+MJGcnr2MKyMwhjEjp8iqE2aJUqR9dXBSdvLamSldA3YZ12VNxREvGzCD+cc/DZz7GvLhgu64oVL8Mzjhx3enZWZ9qZjdncTlxlLekmKutYo34Zm7ZBrdmeQH75LqYJ7TgnBTP3xSzL77ZSVTrMtdKZoe5OcM6AjCnx50HNwXw9LgbzhqcwZX0ziAV37yq/DuMYzPJeFISMVrVVk52NgNeD4SNeWXjgela6+u6n/qWKjSkfz7+K2xkGUUTeLZ+hUK8PNXCH35vkBer++bfBLrSbp1ww2K1YSO26JIUZa7VSwg2K18CvIwEU2o0LX0wCYTwWzlFL9RZRgA05U65+oTsaxEiQeQuMtZpOR4h+D2z1VyDIhNVRZgTeF5tH/yZ4fyN4oqEe9Qc2pRrws5g5X5ytt9Mck0Y+nTuq1s6zn/HisqT1ZZxde2Ic6KHunCpwlMkTQlBLfAqB2YTAbNiZXtQMyhQVCFfSCd+wVh5knqrKCVTn9aPUEZrQZdgZMJh5drOEPT6aGJMsSmOIEcofpo4ibcsh7GyE9OSL
 woDIDrmF
 hbXQa0B0/tovYn29vBMds2nFeIA0X+vIR4ZN3gCpsZQeW4VkPGkHi8gMlUJJp2pmQAqrftlPQCC3mmKFGOXUycoSynSXRkEWNR3Er0YoGJqxnh2raq6f27EGKUqe48/CgizhuUlroQxwmJffQI//2qqZ7YKBjSL+JIibEqIQGLRg8QVx3c/g8Vs0d5vP017QEvXJ6ay/OtAa0X+q/CwC9RZwW7H5PqNDhfuXeW1JgqYsy5FImMhpRfRn5xKH4oq1sM4DiZFZkeqJaWqYl2enWfSlAPxZnLdTgrw3GWJS2O+z1hb0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/29/26 10:10 AM, Harry Yoo wrote:
> On Mon, Jan 19, 2026 at 11:34:53AM +0800, Qi Zheng wrote:
>>
>>
>> On 1/18/26 11:20 AM, Shakeel Butt wrote:
>>> On Wed, Jan 14, 2026 at 07:32:55PM +0800, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> To resolve the dying memcg issue, we need to reparent LRU folios of child
>>>> memcg to its parent memcg. The following counts are all non-hierarchical
>>>> and need to be reparented to prevent the counts of parent memcg overflow.
>>>>
>>>> 1. memcg->vmstats->state_local[i]
>>>> 2. pn->lruvec_stats->state_local[i]
>>>>
>>>> This commit implements the specific function, which will be used during
>>>> the reparenting process.
>>>
>>> Please add more explanation which was discussed in the email chain at
>>> https://lore.kernel.org/all/5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5/
>>
>> OK, will do.
>>
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index 70583394f421f..7aa32b97c9f17 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -225,6 +225,28 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
>>>>    	return objcg;
>>>>    }
>>>> +#ifdef CONFIG_MEMCG_V1
>>>> +static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
>>>> +
>>>> +static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>>>> +{
>>>> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>>>> +		return;
>>>> +
>>>> +	synchronize_rcu();
>>>
>>> Hmm synchrinuze_rcu() is a heavy hammer here. Also you would need rcu
>>> read lock in mod_memcg_state() & mod_memcg_lruvec_state() for this
>>> synchronize_rcu().
>>
>> Since these two functions require memcg or lruvec, they are already
>> within the critical section of the RCU lock.
> 
> What happens if someone grabbed a refcount and then release the rcu read
> lock before percpu refkill and then call mod_memcg[_lruvec]_state()?
> 
> In this case, can we end up reparenting in the middle of non-hierarchical
> stat update because they don't have RCU grace period?
> 
> Something like
> 
> T1				T2
> 
> 				- rcu_read_lock()
> 				- get memcg refcnt
> 				- rcu_read_unlock()
> 
> 				- call mod_memcg_state()
> 				- CSS_IS_DYING is not set
> - Set CSS_IS_DYING
> - Trigger percpu refkill
> 				
> - Trigger offline_css()
>    -> reparent non-hierarchical	- update non-hierarchical stats
>       stats
> 				- put memcg refcount

Good catch, I think you are right.

The rcu lock should be added to mod_memcg_state() and
mod_memcg_lruvec_state().

I will update to v4 as soon as possible.

Thanks,
Qi

> 
>>> Hmm instead of synchronize_rcu() here, we can use queue_rcu_work() in
>>> css_killed_ref_fn(). It would be as simple as the following:
>>
>> It does look much simpler, will do.
>>
>> Thanks,
>> Qi
> 


