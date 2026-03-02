Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40478D58E48
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 02:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22B06B0089; Sun,  1 Mar 2026 21:30:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5D36B008A; Sun,  1 Mar 2026 21:30:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1EC6B008C; Sun,  1 Mar 2026 21:30:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCB876B0089
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 21:30:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C9331CC99
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 02:30:32 +0000 (UTC)
X-FDA: 84499544304.07.8E5288F
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id A90F1100003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 02:30:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oy5lfPc3;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772418630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZmVkvEA0MEnZ8U+s7EY+/k40UTfgu8GKtx0XwLwjrA=;
	b=MesRoXTKiOO9BsnoXZzz+MyqMMlokXoGLmFBvB9T5HqnD0lQaaeNPVLOoX2d+Douk9na/+
	fzmYNjqfJJe/4CKJWgiJeSqmLNjlVzpDNrVxC8v3mk0zly0isgmIeOR/5MjzRkhkHOkooz
	wrR4TfvqOZqg2MzBPc3OIGjUKEVEzjo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oy5lfPc3;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772418630; a=rsa-sha256;
	cv=none;
	b=3OOvbDFbW+jTbBwp/rLOo65bJjjFprny16DmwUUicuWa4fTqAjg9GixpjGaVNYqf4wtfLf
	4yFgoDy5kAEVX9fyaSlucegqrRFd7kpzWVdUVCv926pPLaWShP+dETHMRfLd9KEuNTg6j3
	esvGJwd4FHcpg8TL1FcjxP53A4p8tqQ=
Message-ID: <953e1e1d-1c76-4703-8d22-5b060d5e5832@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772418626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CZmVkvEA0MEnZ8U+s7EY+/k40UTfgu8GKtx0XwLwjrA=;
	b=Oy5lfPc3zRop4/4ghKao1ZS7ddX7Oskv61dxkNI/s8vhiy+cWdLgCcLOqawPbV/DcqKrdv
	EmJwfvd1XKVJVcykhHNeUYYCNAFGFP992+87AgbCgGkUcGVIKj4CUTz8MZTv36p1GDbnpg
	CF7dVnqh4gFkgcheIajmEBx7d7rSzf0=
Date: Mon, 2 Mar 2026 10:30:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, Yosry Ahmed <yosry@kernel.org>
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <20260228072556.31793-1-qi.zheng@linux.dev>
 <20260228110800.50bfca2a90912142c11e2922@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260228110800.50bfca2a90912142c11e2922@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A90F1100003
X-Stat-Signature: e3yx558rkjd5ajhqsm3ipo5ht78e7w33
X-Rspam-User: 
X-HE-Tag: 1772418628-487195
X-HE-Meta: U2FsdGVkX1+VOG8/aWzN7WatxlwNbj2FlBFVG2xO4Be4QxAKiMTihMeNOihD2gpCspnjVz5YvFg5ZYZapSLX0sKhNFHaUo0fw4zw/kVfKtAm3rCyDaojJi8n7h98uitKwW4+y9zkonRFnj0yET9nnnrrrN9a+yUtcegdwuKSUwjhyovMnlfhLrn9ZwZRdZCL36NYBnruHYlPrwuWfnfkYF2FE+tOwciS72sOSjR6XnIMZz/y8juGk9tyGwg3ElupFc78huba5WhXhP5lvOyv+sDDe6cicLybTL/2ED0kUo76DpOOY1Xx12dIPFwEP4MmYMJ3Xk0mOJGTkyby8xhC2s/xj16xHHxtq8VY998bsUU4Gn4QMALLXorGPDD+I16sis0P2N9/dMfmvzfv1zMECQEC8D0st9KXWxdy357YxxrkX0KBYrEZGqzIp/sVG4rxv4+TkxyWjCmp2QrhuPGeKf+Zyj+Lblr1hGJef1zy21kuaiCkiVieF7nZAjaTpBjGsPCIP//foNHYjxt0lNxOHWPsVt9+UhiDkhwvYKptkKjZ52F/N7wQz1y1rd0vFXiBGj7x2fykLHtNzr7XD0bY0bZz/0hcEGpeo9t/1zlV5Yjzo903OjHmSTlgloRQRLUbb+tCId7N1ApyABfDaUul4r2PJdGXOzEKV2PLpBAO0GL/5VWoJF1daAJ8SGPGhuZIDWrGZKDC9FQu3dzgneSD0jYZFluPn1IK7ISWy4+xUtvHpIpHfMo/Y6R/tWA8jHwaGQPCyK3hxstmwf1O+8cxjWhnbQ2jlZBoOo9JmuTHOYv+fXK+9rtSGfnwJ/Vvxgf2DgY/PvLaeW4g81zdEwR9IvqcVlt3IoQKBPU+83EHVGA3URzC+6b4Vq3cyAeRrXJVBKh59X8cdNrp0nR1qmz9e4KF8qulC77hA5OrHZIZFuzxgdK2FsLsi1fDvJfsQse8+kbKn2OgVrrwh2H3poH
 HAab9ZkW
 bF5AFinD0Ti1DZ2lCDiCbzLRox8liwOI2BtROfWKgXXPsammPx/lDgCvYYx69TEpYBaGtCKjL5xmaq0j+Cxxim06j3TlOHRGtZrLUfYfD3x437S21XoNkzxk+JwbDQOgce00IHWcqz6uJW7onDEL6pDwR/72rPrVqXPaLwysq79eeeO/x1fS+NgtGuMVEyX2Dr7DSCQxjP3rtvtlXP+tV6ZEoWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 3/1/26 3:08 AM, Andrew Morton wrote:
> On Sat, 28 Feb 2026 15:25:56 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
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
> 
> That's a big update (delta patch is below).
> 
> What did it all do?

Oh sorry, I forgot the changlog.

> 
> I've bookmarked these reviewer comments:
> 
> https://lkml.kernel.org/r/CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com
> https://lkml.kernel.org/r/aZ-R87JfacQ2gGq1@linux.dev

Based on Yosry Ahmed's suggestion and diff, the method has been changed
to non-atomic mode, so there is no need to test the perfomance impact of
atomic mode.

> https://lkml.kernel.org/r/aZ-kefGBeT-RzGcG@linux.dev

This redundant declaration has been removed.

Thanks,
Qi

> 
> Were they all addressed in some fashion?
> 
> 
>   include/linux/memcontrol.h |    1
>   mm/memcontrol-v1.h         |    1
>   mm/memcontrol.c            |   89 ++++++++++++++++++++++++++---------
>   3 files changed, 68 insertions(+), 23 deletions(-)
> 
> --- a/include/linux/memcontrol.h~mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update
> +++ a/include/linux/memcontrol.h
> @@ -956,7 +956,6 @@ static inline void mod_memcg_page_state(
>   
>   unsigned long memcg_events(struct mem_cgroup *memcg, int event);
>   unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
> -
>   unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
>   bool memcg_stat_item_valid(int idx);
>   bool memcg_vm_event_item_valid(enum vm_event_item idx);
> --- a/mm/memcontrol.c~mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update
> +++ a/mm/memcontrol.c
> @@ -234,11 +234,19 @@ static inline void reparent_state_local(
>   	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>   		return;
>   
> +	/*
> +	 * Reparent stats exposed non-hierarchically. Flush @memcg's stats first
> +	 * to read its stats accurately , and conservatively flush @parent's
> +	 * stats after reparenting to avoid hiding a potentially large stat
> +	 * update (e.g. from callers of mem_cgroup_flush_stats_ratelimited()).
> +	 */
>   	__mem_cgroup_flush_stats(memcg, true);
>   
>   	/* The following counts are all non-hierarchical and need to be reparented. */
>   	reparent_memcg1_state_local(memcg, parent);
>   	reparent_memcg1_lruvec_state_local(memcg, parent);
> +
> +	__mem_cgroup_flush_stats(parent, true);
>   }
>   #else
>   static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
> @@ -442,7 +450,7 @@ struct lruvec_stats {
>   	long state[NR_MEMCG_NODE_STAT_ITEMS];
>   
>   	/* Non-hierarchical (CPU aggregated) state */
> -	atomic_long_t state_local[NR_MEMCG_NODE_STAT_ITEMS];
> +	long state_local[NR_MEMCG_NODE_STAT_ITEMS];
>   
>   	/* Pending child counts during tree propagation */
>   	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
> @@ -485,7 +493,7 @@ unsigned long lruvec_page_state_local(st
>   		return 0;
>   
>   	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	x = atomic_long_read(&(pn->lruvec_stats->state_local[i]));
> +	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
>   #ifdef CONFIG_SMP
>   	if (x < 0)
>   		x = 0;
> @@ -494,6 +502,9 @@ unsigned long lruvec_page_state_local(st
>   }
>   
>   #ifdef CONFIG_MEMCG_V1
> +static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
> +				     enum node_stat_item idx, int val);
> +
>   void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>   				       struct mem_cgroup *parent, int idx)
>   {
> @@ -506,12 +517,10 @@ void reparent_memcg_lruvec_state_local(s
>   	for_each_node(nid) {
>   		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>   		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
> -		struct mem_cgroup_per_node *parent_pn;
>   		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
>   
> -		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
> -
> -		atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
> +		__mod_memcg_lruvec_state(child_lruvec, idx, -value);
> +		__mod_memcg_lruvec_state(parent_lruvec, idx, value);
>   	}
>   }
>   #endif
> @@ -598,7 +607,7 @@ struct memcg_vmstats {
>   	unsigned long		events[NR_MEMCG_EVENTS];
>   
>   	/* Non-hierarchical (CPU aggregated) page state & events */
> -	atomic_long_t		state_local[MEMCG_VMSTAT_SIZE];
> +	long			state_local[MEMCG_VMSTAT_SIZE];
>   	unsigned long		events_local[NR_MEMCG_EVENTS];
>   
>   	/* Pending child counts during tree propagation */
> @@ -835,7 +844,7 @@ unsigned long memcg_page_state_local(str
>   	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
>   		return 0;
>   
> -	x = atomic_long_read(&(memcg->vmstats->state_local[i]));
> +	x = READ_ONCE(memcg->vmstats->state_local[i]);
>   #ifdef CONFIG_SMP
>   	if (x < 0)
>   		x = 0;
> @@ -843,6 +852,51 @@ unsigned long memcg_page_state_local(str
>   	return x;
>   }
>   
> +static void __mod_memcg_state(struct mem_cgroup *memcg,
> +			      enum memcg_stat_item idx, int val)
> +{
> +	int i = memcg_stats_index(idx);
> +	int cpu;
> +
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	cpu = get_cpu();
> +
> +	this_cpu_add(memcg->vmstats_percpu->state[i], val);
> +	val = memcg_state_val_in_pages(idx, val);
> +	memcg_rstat_updated(memcg, val, cpu);
> +	trace_mod_memcg_state(memcg, idx, val);
> +
> +	put_cpu();
> +}
> +
> +static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
> +				     enum node_stat_item idx, int val)
> +{
> +	struct mem_cgroup_per_node *pn;
> +	struct mem_cgroup *memcg;
> +	int i = memcg_stats_index(idx);
> +	int cpu;
> +
> +	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> +	memcg = pn->memcg;
> +
> +	cpu = get_cpu();
> +
> +	/* Update memcg */
> +	this_cpu_add(memcg->vmstats_percpu->state[i], val);
> +
> +	/* Update lruvec */
> +	this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
> +
> +	val = memcg_state_val_in_pages(idx, val);
> +	memcg_rstat_updated(memcg, val, cpu);
> +	trace_mod_memcg_lruvec_state(memcg, idx, val);
> +
> +	put_cpu();
> +}
> +
>   void reparent_memcg_state_local(struct mem_cgroup *memcg,
>   				struct mem_cgroup *parent, int idx)
>   {
> @@ -852,7 +906,8 @@ void reparent_memcg_state_local(struct m
>   	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
>   		return;
>   
> -	atomic_long_add(value, &(parent->vmstats->state_local[i]));
> +	__mod_memcg_state(memcg, idx, -value);
> +	__mod_memcg_state(parent, idx, value);
>   }
>   #endif
>   
> @@ -4174,8 +4229,6 @@ struct aggregate_control {
>   	long *aggregate;
>   	/* pointer to the non-hierarchichal (CPU aggregated) counters */
>   	long *local;
> -	/* pointer to the atomic non-hierarchichal (CPU aggregated) counters */
> -	atomic_long_t *alocal;
>   	/* pointer to the pending child counters during tree propagation */
>   	long *pending;
>   	/* pointer to the parent's pending counters, could be NULL */
> @@ -4213,12 +4266,8 @@ static void mem_cgroup_stat_aggregate(st
>   		}
>   
>   		/* Aggregate counts on this level and propagate upwards */
> -		if (delta_cpu) {
> -			if (ac->local)
> -				ac->local[i] += delta_cpu;
> -			else if (ac->alocal)
> -				atomic_long_add(delta_cpu, &(ac->alocal[i]));
> -		}
> +		if (delta_cpu)
> +			ac->local[i] += delta_cpu;
>   
>   		if (delta) {
>   			ac->aggregate[i] += delta;
> @@ -4289,8 +4338,7 @@ static void mem_cgroup_css_rstat_flush(s
>   
>   	ac = (struct aggregate_control) {
>   		.aggregate = memcg->vmstats->state,
> -		.local = NULL,
> -		.alocal = memcg->vmstats->state_local,
> +		.local = memcg->vmstats->state_local,
>   		.pending = memcg->vmstats->state_pending,
>   		.ppending = parent ? parent->vmstats->state_pending : NULL,
>   		.cstat = statc->state,
> @@ -4323,8 +4371,7 @@ static void mem_cgroup_css_rstat_flush(s
>   
>   		ac = (struct aggregate_control) {
>   			.aggregate = lstats->state,
> -			.local = NULL,
> -			.alocal = lstats->state_local,
> +			.local = lstats->state_local,
>   			.pending = lstats->state_pending,
>   			.ppending = plstats ? plstats->state_pending : NULL,
>   			.cstat = lstatc->state,
> --- a/mm/memcontrol-v1.h~mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update
> +++ a/mm/memcontrol-v1.h
> @@ -45,7 +45,6 @@ static inline bool do_memsw_account(void
>   
>   unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
>   unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
> -void mod_memcg_page_state_local(struct mem_cgroup *memcg, int idx, unsigned long val);
>   unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
>   bool memcg1_alloc_events(struct mem_cgroup *memcg);
>   void memcg1_free_events(struct mem_cgroup *memcg);
> _
> 


