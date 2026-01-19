Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E49ED4A5EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 03:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D67F6B00F2; Sun, 18 Jan 2026 22:35:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4840A6B00F3; Sun, 18 Jan 2026 22:35:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3617A6B00F4; Sun, 18 Jan 2026 22:35:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F96F6B00F2
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:35:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FB2EBA50B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:35:06 +0000 (UTC)
X-FDA: 84347297412.16.50A8A71
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id D89E0C0003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:35:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iPpPBLFj;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768793705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2DwTuePUycHQ/sZnpKkhBxd7ANgEf/6qnp7jSSdIz0=;
	b=L1XsgHCymTVIPDvKceLbS72mNZI5syooVRn6KaCMTeT95vXwyZIoPOAYLw7MexXX/hzvV6
	j8cFIZ06zQxtnmXVD0gau0t1SNvKESOrDo1dBCumbNq057CyJIhnX2NcQ0RRIXlwaHkhfu
	yeVI4/s+kekpmglyHqwifdnKZ7YDH9U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768793705; a=rsa-sha256;
	cv=none;
	b=IcUNwyB9H7y2he3T4hy/SMZY4F4JoH+BHmZ2ARWYODUT0Pc2oOPGJP33dcSNyy+8YPOzZg
	Nyn3z3MPnWyS2qsGJuaxnIQ2pSQzHTCGVKpQzBOMD+cAiaQDyU44I7aub1M1AEJrYoLTAU
	ABoQsN7sofm6Vo3TPHO8hn1bDF8Wks4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iPpPBLFj;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <9b9057f8-4c4c-4067-b6ba-0791888c25e8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768793702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A2DwTuePUycHQ/sZnpKkhBxd7ANgEf/6qnp7jSSdIz0=;
	b=iPpPBLFjReNZJL6MQN0s8qLiVxa2/AWyFPmjz8D9Gb1HpGV0B9CiYg2GxYgDkoDu1QUDHl
	FvZzGD9XHP/jh3U68r/UuLZcezwR0fcWjyFUX24Ik9X00TdTOjw7ZPW4LKkx/5kbHk3NSI
	rEL74nvf/6sh8rpkScJFwmMkO7xgF2M=
Date: Mon, 19 Jan 2026 11:34:53 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 28/30] mm: memcontrol: prepare for reparenting
 state_local
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <iu27pt5nqs6myshw57e7dotld33v6lwuyouvquoqc2zmc5loi6@f23auf7hqbdp>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <iu27pt5nqs6myshw57e7dotld33v6lwuyouvquoqc2zmc5loi6@f23auf7hqbdp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D89E0C0003
X-Rspam-User: 
X-Stat-Signature: d4pneiicgqruquf9waw5kq79ph7qf4ci
X-HE-Tag: 1768793704-476920
X-HE-Meta: U2FsdGVkX18UY44584taGJo10LS88urBVoAvUXQNq/TTPDwxkSQy5fgQt6bVVwQp3GS5ulIXjPcXnlpS3EDpjjao9qMnV45wpQ85o86OGBYwrVT3YftYO2moghtY3ovNWXWuIonWz+vvvIgQbDC3hMBpECwXJSybK044j9zd01uDfS9bhzqme6tNcmOt6KohjGlwuM6kK3oowBu/V3++JSWP5DaDkSR1nIgThehOf8tQyyLcAdKGPRJhiBHtzJejvJv7tNYSGg34Nz59CPzTmVP3cGkEPi2diy4CTwVcnxKvUVJN4pkNoY5jPXUuB1HutBKJeoiCH5IXDBIQ+qEHJkF9Ns7ejj1CgoZ6/mVGQCz3Ww0wuZeuzS+cae9wj1GRCwz2yaxr0z4l0WTKxr3F0OaUHfLasKRyZWwxPtGlBKIegSTNl8a/aR0a7Rb2lpG+9qPIbfvvLMEdT3e+M/fu8uUaPNsR7dDdGrNp4PR04Hoa41M/OVNKP38Rmuh4XG7pezVsl6bA/uEr9qTzwvO7sJFFFKt6WMebp/8CgopIjhimWIu11Y3ADj0ys29Hc34wOEWQd1Dcxmdv6TO88nqPV3e6Xj7fkHK8fwM6UoP1YkTSqDKhMGYzPQWuiWja9giUEW4DaXlFm/jh+xoMRBamU4t2O9XH7HKu7lZipsGkYGs6uhimKauAHK0CPGQqKYL+fuhGkft45x4+T65MXTf3O/YequsMicUAo6amSg/Vmyd2nUtM4ExivT249eIgFqclQhF9KNtZomB5RGIBtr3VprH7eMPtBGi+g7pa4yeom4WLI+IOJleEHzFnkYEdkoMvzojuq1xD9tMsB2iLh4uWLG6ss2wZ+E+JOsqt52bvR4QgCfOei8slmC5XgAhmzVBc7eARGV840MFgZXEGptqo3HHo6xf34NX/ghgayhpYo3KvDrtyMySt1ZWjf+NgNhLpTW8lH7aXoqM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/18/26 11:20 AM, Shakeel Butt wrote:
> On Wed, Jan 14, 2026 at 07:32:55PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> To resolve the dying memcg issue, we need to reparent LRU folios of child
>> memcg to its parent memcg. The following counts are all non-hierarchical
>> and need to be reparented to prevent the counts of parent memcg overflow.
>>
>> 1. memcg->vmstats->state_local[i]
>> 2. pn->lruvec_stats->state_local[i]
>>
>> This commit implements the specific function, which will be used during
>> the reparenting process.
> 
> Please add more explanation which was discussed in the email chain at
> https://lore.kernel.org/all/5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5/

OK, will do.

> 
> Also move the upward traversal code in mod_memcg_state() and
> mod_memcg_lruvec_state() you added in later patch to this patch and make
> it under CONFIG_MEMCG_V1.
> 
> Something like:
> 
> #ifdef CONFIG_MEMCG_V1
> 	while (memcg_is_dying(memcg))
> 		memcg = parent_mem_cgroup(memcg);
> #endif

OK, will do.

> 		
> 
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/memcontrol.h |  4 +++
>>   mm/memcontrol-v1.c         | 16 +++++++++++
>>   mm/memcontrol-v1.h         |  3 ++
>>   mm/memcontrol.c            | 56 ++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 79 insertions(+)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 26c3c0e375f58..f84a23f13ffb4 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -963,12 +963,16 @@ static inline void mod_memcg_page_state(struct page *page,
>>   
>>   unsigned long memcg_events(struct mem_cgroup *memcg, int event);
>>   unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
>> +void reparent_memcg_state_local(struct mem_cgroup *memcg,
>> +				struct mem_cgroup *parent, int idx);
>>   unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
>>   bool memcg_stat_item_valid(int idx);
>>   bool memcg_vm_event_item_valid(enum vm_event_item idx);
>>   unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
>>   unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>   				      enum node_stat_item idx);
>> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>> +				       struct mem_cgroup *parent, int idx);
>>   
>>   void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>>   void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
>> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
>> index f0ef650d2317b..800606135e7ba 100644
>> --- a/mm/memcontrol-v1.c
>> +++ b/mm/memcontrol-v1.c
>> @@ -1898,6 +1898,22 @@ static const unsigned int memcg1_events[] = {
>>   	PGMAJFAULT,
>>   };
>>   
>> +void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++)
>> +		reparent_memcg_state_local(memcg, parent, memcg1_stats[i]);
>> +}
>> +
>> +void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++)
>> +		reparent_memcg_lruvec_state_local(memcg, parent, memcg1_stats[i]);
>> +}
>> +
>>   void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>>   {
>>   	unsigned long memory, memsw;
>> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
>> index eb3c3c1056574..45528195d3578 100644
>> --- a/mm/memcontrol-v1.h
>> +++ b/mm/memcontrol-v1.h
>> @@ -41,6 +41,7 @@ static inline bool do_memsw_account(void)
>>   
>>   unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
>>   unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
>> +void mod_memcg_page_state_local(struct mem_cgroup *memcg, int idx, unsigned long val);
>>   unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
>>   bool memcg1_alloc_events(struct mem_cgroup *memcg);
>>   void memcg1_free_events(struct mem_cgroup *memcg);
>> @@ -73,6 +74,8 @@ void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
>>   			   unsigned long nr_memory, int nid);
>>   
>>   void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
>> +void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
>> +void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
>>   
>>   void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
>>   static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 70583394f421f..7aa32b97c9f17 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -225,6 +225,28 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
>>   	return objcg;
>>   }
>>   
>> +#ifdef CONFIG_MEMCG_V1
>> +static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
>> +
>> +static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>> +{
>> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>> +		return;
>> +
>> +	synchronize_rcu();
> 
> Hmm synchrinuze_rcu() is a heavy hammer here. Also you would need rcu
> read lock in mod_memcg_state() & mod_memcg_lruvec_state() for this
> synchronize_rcu().

Since these two functions require memcg or lruvec, they are already
within the critical section of the RCU lock.

> 
> Hmm instead of synchronize_rcu() here, we can use queue_rcu_work() in
> css_killed_ref_fn(). It would be as simple as the following:

It does look much simpler, will do.

Thanks,
Qi

> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index e717208cfb18..549a8e026194 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6046,8 +6046,8 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
>    */
>   static void css_killed_work_fn(struct work_struct *work)
>   {
> -	struct cgroup_subsys_state *css =
> -		container_of(work, struct cgroup_subsys_state, destroy_work);
> +	struct cgroup_subsys_state *css = container_of(to_rcu_work(work),
> +				 struct cgroup_subsys_state, destroy_rwork);
>   
>   	cgroup_lock();
>   
> @@ -6068,8 +6068,8 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
>   		container_of(ref, struct cgroup_subsys_state, refcnt);
>   
>   	if (atomic_dec_and_test(&css->online_cnt)) {
> -		INIT_WORK(&css->destroy_work, css_killed_work_fn);
> -		queue_work(cgroup_offline_wq, &css->destroy_work);
> +		INIT_RCU_WORK(&css->destroy_rwork, css_killed_work_fn);
> +		queue_rcu_work(cgroup_offline_wq, &css->destroy_rwork);
>   	}
>   }
>   
>> +
>> +	__mem_cgroup_flush_stats(memcg, true);
>> +
>> +	/* The following counts are all non-hierarchical and need to be reparented. */
>> +	reparent_memcg1_state_local(memcg, parent);
>> +	reparent_memcg1_lruvec_state_local(memcg, parent);
>> +}
>> +#else
>> +static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>> +{
>> +}
>> +#endif
>> +


