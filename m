Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E7E4EA3F0D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 06:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91E86B0005; Tue, 10 Feb 2026 01:48:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3FCF6B0088; Tue, 10 Feb 2026 01:48:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921FE6B0089; Tue, 10 Feb 2026 01:48:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 824436B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:48:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE8881A03D7
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 06:48:58 +0000 (UTC)
X-FDA: 84427619556.24.DAEA4DB
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id CB74F140004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 06:48:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SSaMr9CM;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770706137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gci4PxuqdlVZBIC34roKwVj2Mfy+C8h8ARtkl3i8WIY=;
	b=z1YSjSCq1NarbN/tYuC8D8DmO4TtwnK2ReqHgivUKOJo76bfeMeTtHEnWfhPSw9lgRzSQE
	UR6oQfdm0POn5pBYLUR6tC/co6zcXUV7LDwPp2v9FWAJ3n/w+s3kOv7O77borg9prBVDBu
	nwzsZFJak4NdUoNUDyUvAb6pkrzfu3g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SSaMr9CM;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770706137; a=rsa-sha256;
	cv=none;
	b=xg3AP5IXXP0rMBJgcXaokh4Mb9bOJCx6rp4ucIC1HMSjU9p+8bQt+5lqfb6uKJgXhlDkTR
	zkFfyAxqdMFifpdm3NmVT+U/d5ohuLZHN+wAnYt+eHpTyejY7uhdnlrg7GUhwNypFRMNXZ
	H4hq99MxJH0Bx5y0uiD1niVt1DjK4XA=
Message-ID: <0673b72c-8d7c-4bfb-a8b2-da5ae5bb5f00@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770706134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gci4PxuqdlVZBIC34roKwVj2Mfy+C8h8ARtkl3i8WIY=;
	b=SSaMr9CM00eCMtfnra8fKpSRNM1+c0aPKMj1MD0cAoZblfvnkKQXyvcqoR81FqlGV0N4Xx
	pxfCEDp4XVBfyLkFJD9DX+O9svXp/lTZ2WWei+cAMbVC4zB6+t1YLRR3zPETzg+39VRM8B
	Kls1/747RlPwiw9yujsPbGNpwi60j48=
Date: Tue, 10 Feb 2026 14:47:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 29/31] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <3ca234c643ecb484f17aa88187e0bce8949bdb6b.1770279888.git.zhengqi.arch@bytedance.com>
 <aYabQii_-9EVdgub@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aYabQii_-9EVdgub@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: miu33yrqjsq937zbu1fsd7c4dscezbfc
X-Rspamd-Queue-Id: CB74F140004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770706136-283646
X-HE-Meta: U2FsdGVkX1+2jhAHn92iKtsKnLLpuHT20al/k1kuT4QL4AgcPcG5HQ9m9dMWxTi9vQE66CLMDNaOoSf2IchfEJLOi6MY43USjQiaxSMtQc8P+NMrGLHh7xAQcAVSUBm9pBZ/HxjvYtDh/Gh8cw0e50xH9NsxyFSLeBk8ntcS4lxj3kmrHEJOuYAXL49xfU6b2y/lW0HrfPFzECtd+KJonn/7tRw//E8Tzf/QFixq1wqsV36QlmNoNlu3YdsCju0+iyQM3CvlrEZbMpu8RORmZVxW5CJaNYtVnW95LQsZxQ52WU1UJpdyWQlAiw1kJHuk3B/8KravFrCA175Ql6oJmbQO30703jaHpUZKGCwlTwsQqv84p7Aw52ygAMX8/R4mmGUcz5xa2nz6mBkKrkewKQbBtE/XanEaF+QocyIKr35DHJnV1qs1y2zAY86SdK7WGs+o3k8X0/2dBaKvTxkNXtGD5ICVUcgZjvmXeRJ/HvrRY2XIWq90LR5lBB0PCz5usLh90RoF8+coStjV+oKpcEWpFz9A9qC69php/4hTA6pX5uwec2cibLSRcB9IILGJs87U3E/hzN8jPQmuWgUPFg6/Lm0gRKxqjhE6zgRBVjIyVUaKBjJHRsHdiXmkTDGZ0cdUFcQ3jtJnSWrDLlivt2y6m4uoldl3QMlN5X/YhDNG8ZtDzVrftZMfvXqsUqAMF2NiaNfph8TH629dIlmYURJejxMajLRjn4pZDkF1nReZttQlG4xXiKxlP6l/FhR+lC7f4LasuxgaLJdpncyK3EXy/7cZ4FYhNgBXEfrJ37GhKVxz5bEFZie8UnRk+4CLNLUSMhJoJqEllbImkTKwiS7nm6ffeGlSndcj/9cBhfCezxZhEKvtPInFqP5vra9oQjLR1B7sRHzwAlPsvZcYUyTXg2tfTyWnHuqJ4phSGwc0ptWHcu2GbHzZX8es94jIOp4wylkijmyhP0fcjnB
 DsDuQx4Z
 qZzf46h4L5L3n6C1zV0Y0efZ9m0ISF1DWrLRsLAeBo6snfJRuvG1I/ZV87L4e8qM/Q5GHvlW/Z6rQXbNSUuvbRVMX1P1rdT6IIGTROPLcbdps8HtSkWUKIuYnTKsRz5uNtDqd66D7ij/dx01rim3Y8+KCsJSJWlyhsdUY4t3kb15TZekp4MjC9G1xmlMdyDkYElJsOYQSBTi/U3N8CcvyeDKwtF625WDLUSX3jcb4VsPNhlI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/7/26 10:19 AM, Shakeel Butt wrote:
> On Thu, Feb 05, 2026 at 05:01:48PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> To resolve the dying memcg issue, we need to reparent LRU folios of child
>> memcg to its parent memcg. This could cause problems for non-hierarchical
>> stats.
>>
>> As Yosry Ahmed pointed out:
>>
>> ```
>> In short, if memory is charged to a dying cgroup at the time of
>> reparenting, when the memory gets uncharged the stats updates will occur
>> at the parent. This will update both hierarchical and non-hierarchical
>> stats of the parent, which would corrupt the parent's non-hierarchical
>> stats (because those counters were never incremented when the memory was
>> charged).
>> ```
>>
>> Now we have the following two types of non-hierarchical stats, and they
>> are only used in CONFIG_MEMCG_V1:
>>
>> a. memcg->vmstats->state_local[i]
>> b. pn->lruvec_stats->state_local[i]
>>
>> To ensure that these non-hierarchical stats work properly, we need to
>> reparent these non-hierarchical stats after reparenting LRU folios. To
>> this end, this commit makes the following preparations:
>>
>> 1. implement reparent_state_local() to reparent non-hierarchical stats
>> 2. make css_killed_work_fn() to be called in rcu work, and implement
>>     get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
>>     between mod_memcg_state()/mod_memcg_lruvec_state()
>>     and reparent_state_local()
>> 3. change these non-hierarchical stats to atomic_long_t type to avoid race
>>     between mem_cgroup_stat_aggregate() and reparent_state_local()
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Overall looks good just a couple of comments.
> 
>> ---
>>   include/linux/memcontrol.h |   4 ++
>>   kernel/cgroup/cgroup.c     |   8 +--
>>   mm/memcontrol-v1.c         |  16 ++++++
>>   mm/memcontrol-v1.h         |   3 +
>>   mm/memcontrol.c            | 113 ++++++++++++++++++++++++++++++++++---
>>   5 files changed, 132 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 3970c102fe741..a4f6ab7eb98d6 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -957,12 +957,16 @@ static inline void mod_memcg_page_state(struct page *page,
>>   
>>   unsigned long memcg_events(struct mem_cgroup *memcg, int event);
>>   unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
>> +void reparent_memcg_state_local(struct mem_cgroup *memcg,
>> +				struct mem_cgroup *parent, int idx);
> 
> Put the above in mm/memcontrol-v1.h file.

OK.

> 
>>   unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
>>   bool memcg_stat_item_valid(int idx);
>>   bool memcg_vm_event_item_valid(enum vm_event_item idx);
>>   unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
>>   unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>   				      enum node_stat_item idx);
>> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>> +				       struct mem_cgroup *parent, int idx);
> 
> Put the above in mm/memcontrol-v1.h file.

OK.

> 
>>   
>>   void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>>   void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index 94788bd1fdf0e..dbf94a77018e6 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -6043,8 +6043,8 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
>>    */
>>   static void css_killed_work_fn(struct work_struct *work)
>>   {
>> -	struct cgroup_subsys_state *css =
>> -		container_of(work, struct cgroup_subsys_state, destroy_work);
>> +	struct cgroup_subsys_state *css = container_of(to_rcu_work(work),
>> +				struct cgroup_subsys_state, destroy_rwork);
>>   
>>   	cgroup_lock();
>>   
>> @@ -6065,8 +6065,8 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
>>   		container_of(ref, struct cgroup_subsys_state, refcnt);
>>   
>>   	if (atomic_dec_and_test(&css->online_cnt)) {
>> -		INIT_WORK(&css->destroy_work, css_killed_work_fn);
>> -		queue_work(cgroup_offline_wq, &css->destroy_work);
>> +		INIT_RCU_WORK(&css->destroy_rwork, css_killed_work_fn);
>> +		queue_rcu_work(cgroup_offline_wq, &css->destroy_rwork);
>>   	}
>>   }
>>   
>> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
>> index c6078cd7f7e53..a427bb205763b 100644
>> --- a/mm/memcontrol-v1.c
>> +++ b/mm/memcontrol-v1.c
>> @@ -1887,6 +1887,22 @@ static const unsigned int memcg1_events[] = {
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
>> +	for (i = 0; i < NR_LRU_LISTS; i++)
>> +		reparent_memcg_lruvec_state_local(memcg, parent, i);
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
>> index c9b5dfd822d0a..e7d4e4ff411b6 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -225,6 +225,26 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
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
>>   static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>>   {
>>   	spin_lock_irq(&objcg_lock);
>> @@ -407,7 +427,7 @@ struct lruvec_stats {
>>   	long state[NR_MEMCG_NODE_STAT_ITEMS];
>>   
>>   	/* Non-hierarchical (CPU aggregated) state */
>> -	long state_local[NR_MEMCG_NODE_STAT_ITEMS];
>> +	atomic_long_t state_local[NR_MEMCG_NODE_STAT_ITEMS];
>>   
>>   	/* Pending child counts during tree propagation */
>>   	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
>> @@ -450,7 +470,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>   		return 0;
>>   
>>   	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
>> -	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
>> +	x = atomic_long_read(&(pn->lruvec_stats->state_local[i]));
>>   #ifdef CONFIG_SMP
>>   	if (x < 0)
>>   		x = 0;
>> @@ -458,6 +478,27 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>   	return x;
>>   }
>>   
> 
> Please put the following function under CONFIG_MEMCG_V1. Just move it in
> the same block as reparent_state_local().

OK, will try to do it.

> 
>> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>> +				       struct mem_cgroup *parent, int idx)
>> +{
>> +	int i = memcg_stats_index(idx);
>> +	int nid;
>> +
>> +	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
>> +		return;
>> +
>> +	for_each_node(nid) {
>> +		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>> +		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
>> +		struct mem_cgroup_per_node *parent_pn;
>> +		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
>> +
>> +		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
>> +
>> +		atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
>> +	}
>> +}
>> +
> 
> [...]
> 
>>   
>> +#ifdef CONFIG_MEMCG_V1
>> +/*
>> + * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
>> + * reparenting of non-hierarchical state_locals.
>> + */
>> +static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
>> +{
>> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>> +		return memcg;
>> +
>> +	rcu_read_lock();
>> +
>> +	while (memcg_is_dying(memcg))
>> +		memcg = parent_mem_cgroup(memcg);
>> +
>> +	return memcg;
>> +}
>> +
>> +static inline void get_non_dying_memcg_end(void)
>> +{
>> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>> +		return;
>> +
>> +	rcu_read_unlock();
>> +}
>> +#else
>> +static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
>> +{
>> +	return memcg;
>> +}
>> +
>> +static inline void get_non_dying_memcg_end(void)
>> +{
>> +}
>> +#endif
> 
> Add the usage of these start and end functions in mod_memcg_state() and
> mod_memcg_lruvec_state() in this patch.

Using these two function will change the behavior of mod_memcg_state()
and mod_memcg_lruvec_state(), but LRU folios has not yet been
reparented.

To ensure the patch itself is error-free, I chose to place the usage of
these two function in patch #30.

Thanks,
Qi

> 


