Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871FEFC9EF4
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 11:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517BD6B0005; Sat,  7 Mar 2026 06:08:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C55B6B0089; Sat,  7 Mar 2026 06:08:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D656B008A; Sat,  7 Mar 2026 06:08:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 16EFA6B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 06:08:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A73ED140F9D
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 11:08:35 +0000 (UTC)
X-FDA: 84518993790.28.C1EA22A
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf03.hostedemail.com (Postfix) with ESMTP id AE58320004
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 11:08:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kfzZo6l6;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772881714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQQUq7VI4DGC3acaTy19EaAJ0WQoVtzSXc8kQhaWbHc=;
	b=gJoKp/qWe5A+hlcrq0ej6mUvOkxst35GLOTywcXnu5kCgDpt45tLGZPzF+CpSj7SHYg+qq
	nK5TgFzHt5sOccdEjV5BrXUY3A+DIS3TMtzd3CUpGhS173/hbnks+2GkA2wXK5EltPkW9E
	ippS2UoG0chVCe/zQHp9MeCKCxJjWvI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kfzZo6l6;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772881714; a=rsa-sha256;
	cv=none;
	b=BLqp7d1DR2bSCcHU4v7XzaujWI+8DUmB7Kylb9wHCMYMJvuX27YbFD8ClvmRrZF9tmeWlf
	1hGcW2C/jhkd+xnjA0MG9FK7SoH9jA07P8gGYs8LQXslrWhOTfoGHvax3/7ZPjSaTm2NUV
	PHkfq8VB6mAsJXyY5GTN5XUilOChVB0=
Message-ID: <898e8ca7-efcb-4bd7-8016-871b37be830e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772881711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pQQUq7VI4DGC3acaTy19EaAJ0WQoVtzSXc8kQhaWbHc=;
	b=kfzZo6l69X5HrOvPj6d3TGCxNlYxsoIX97rJXw21pqm85Yy4fSQBuKP2SkSSVprE9sOwEY
	Ksd3u/afuQ+H+OtMWzyqydnVEwLKjMPJAArdwtmHfpUSpAVM1urZuoMKC6+i1hd4pyXMFt
	0gXNx4N5pTuI2BSEQoP7E0x3P03dLHU=
Date: Sat, 7 Mar 2026 14:08:25 +0300
MIME-Version: 1.0
Subject: Re: [PATCH v6 31/33] mm: memcontrol: convert objcg to be per-memcg
 per-node type
Content-Language: en-GB
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
 usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <20260306202931.3878822-1-usama.arif@linux.dev>
 <b77bd438-3420-4569-a461-7b1b7afbc0a3@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <b77bd438-3420-4569-a461-7b1b7afbc0a3@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: AE58320004
X-Rspamd-Server: rspam08
X-Stat-Signature: b1hiwpikcu5yowdpwqb6ocgspwgagohk
X-HE-Tag: 1772881713-923095
X-HE-Meta: U2FsdGVkX19+pNaldZEIat+CRS7Bby8TiFRDSr69oMwn73skLeIoMk7fhZC1kimQLKKZ7W04GIH07nLY0f1JdPSeQJEJPiwp4+3xEOmpOvqHBR9AJtTtT9/zod1wEIdUemTIDw4AsSelC8GSSLYvJvzNgSUI8VAl+Q3WU1I0gKVBerztntn/m/CHgpyO5IQr1OTnsgE9c6lQrDohJKRV+vMswFBnH3nR3Wd4ApyaM7/f7l4RXRT0/8XGt7powiBcD03a1VLDmkq6tJpkauNLBrj+XmGt8y7uAksJM7DcjywaxrlcvxTOEQhEfuH8D21oA7KSioVRd+yPy49TXtdM95e215wbsqQEMdO3PejhcEbZEkEjrJEXxj9K5Q43YuKheE+192/kQ3Pg9zouz6q7NJFc/SjsjbxDDzLbu8tEuxdTJ938GHN2YiTfcoibnI2erMhSycARe5ZQ6bcMG9OkOKcRBkHd+BfcrDznylpdXTFN0JAL+3kvPLQVbz4YdpcWudRhhgobgzFRcE3DQXvdkfBFO8Kww1YyALb/ooIPe+i4KQHlTEiDcKK5lUC+I/OXYXV7JgOYYOaC9kiIKgL6gDcuI2gDXLGe8eCn2FgjLxe1gs/KGepvpkXYe2pzPRnGYV8PmkJicDrODejrU8vgpeDNEjK5JlFqMP02Ju2PQ5JfYKy0PJnrth6ya12/zTx9bjHKazODslRMq7D3hjQSwrDgt8AbArLjbY752ORWKuKEY4OS3NvMUsM09aagmUj6EV6oNN1DS9uYzQPT6ovQfSziJZtHqmMybyAMJzygBZYdnM1IeF4biAzWg7drTHJju8LCxP2kma/cmX8P2Dy5u1c5vJ8yNN8nU5GtkS2M4EZcFshV+Q/YioQsy7w+2eUJ4MI9YOwwAv7rkE84t46iaqs15Dv9uTE0BYnxqC6ok85PyijSfboHe7Ih+E7FrWYeZTznul7sxJeGgYJY95O
 lOGVKT9t
 q6l8jkbX2gOuqPlzAFSKfKUkH/MYSTNp5WXCL4ijQ882Fqn+PeRxCnEfqdy9BWqvniuOjIphcFSDrly/Q2/ze6YGIn38S+FvT+DCsPIWwrK06uOdx7JtPWbLy3BjoHgiz3sJeP2W95nq3FeDo9Q8Mg6hQwXJ6QP27xKzIej9drn81nMAy3HqIw0x3ceDYXT6KS9J3tbS8HZmo5pDpIsO6Roh+vrsRaOVQg7q6meh+AQnpDwhnWI4SY3v3Xg16q2eMdBcnBEDvs/eiy61D2/49PQDSout+PYrYwR5da5b6JLLdfQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/03/2026 08:51, Qi Zheng wrote:
> Hi Usama,
> 
> On 3/7/26 4:29 AM, Usama Arif wrote:
>> On Thu,  5 Mar 2026 19:52:49 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> Convert objcg to be per-memcg per-node type, so that when reparent LRU
>>> folios later, we can hold the lru lock at the node level, thus avoiding
>>> holding too many lru locks at once.
>>>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>>> ---
>>>   include/linux/memcontrol.h | 23 +++++------
>>>   include/linux/sched.h      |  2 +-
>>>   mm/memcontrol.c            | 79 +++++++++++++++++++++++---------------
>>>   3 files changed, 62 insertions(+), 42 deletions(-)
>>>
>>
>> [...]
>>
>>> @@ -4087,7 +4100,13 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>>>       xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
>>>         return 0;
>>> -free_shrinker:
>>> +free_objcg:
>>> +    for_each_node(nid) {
>>> +        struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
>>> +
>>> +        if (pn && pn->orig_objcg)
>>> +            obj_cgroup_put(pn->orig_objcg);
>>
>> Is it possible that you might call obj_cgroup_put twice on the same cgroup?
> 
> Oh, I think you are right. Here pn->orig_objcg was not reset to NULL, so
> obj_cgroup_put() will be called in __mem_cgroup_free() again.
> 
>>
>> If css_create fails, css_free_rwork_fn is queued, which ends up calling
>> mem_cgroup_css_free which calls obj_cgroup_put again?
>>
>> Maybe adding pn->orig_objcg = NULL overhere after obj_cgroup_put
>> is enough to prevent the double put from causing issues?
> 
> Agree.
> 
> Like this?
> 

Yes below looks good! Might be good to add a comment as well why setting
it to NULL.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 992a3f5caa62b..e0795aec4356b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4140,8 +4140,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>         for_each_node(nid) {
>                 struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
> 
> -               if (pn && pn->orig_objcg)
> +               if (pn && pn->orig_objcg) {
>                         obj_cgroup_put(pn->orig_objcg);
> +                       pn->orig_objcg = NULL;
> +               }
>         }
>         free_shrinker_info(memcg);
>  offline_kmem:
> 
> If there are no problems, I will send a fix patch later.
> 
> Thanks,
> Qi
> 
>>
>>> +    }
>>>       free_shrinker_info(memcg);
>>>   offline_kmem:
>>>       memcg_offline_kmem(memcg);
>>> -- 
>>> 2.20.1
>>>
>>>
> 


