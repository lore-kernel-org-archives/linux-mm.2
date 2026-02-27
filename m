Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0EBFFD9E3D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0FAD6B0088; Fri, 27 Feb 2026 01:06:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7DB6B0089; Fri, 27 Feb 2026 01:06:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1116B008A; Fri, 27 Feb 2026 01:06:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1FDA6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:06:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 86BD31C598
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:06:17 +0000 (UTC)
X-FDA: 84489201594.08.E18197A
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7C6EF18000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:06:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c9XmhPE8;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772172375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kujEh6UjGWsl9lfzHWGZ7znWF6eai55OU5WChJt+xgA=;
	b=aChp2mCHoPHDWv07fnY+Cidd56J6tlIJ1YFacDndZE3ohKS0llrihSYBGbunaaa7WY6TOs
	KEwcwphp/2W2umC/VR/7vnwR51yhskO8gT9e4suIWFKWg1JtvTfr8gQaFV2YMusri/2p20
	O60RF/VW50E4iHzMfd7Y0YDm/QJq54Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772172376; a=rsa-sha256;
	cv=none;
	b=zJMtgVe/bbism8EknQOc/b1rty1hwy0jeR3xiTeYqMN0u3ZEbNf2WJoEuOFCa4ebXcdhTW
	9vLQFVNz3OCHRQLN9VaH8aTNOU5uKG+4sNzgIrg0IIOj2gDlnHyL+fhoCpkkU4u1RmNkQm
	1FVIxaDVYPPSORTZ3EBC9QO/qCLwyC0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c9XmhPE8;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e15c2304-4874-4adc-bbe5-58ba78b3b84f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772172372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kujEh6UjGWsl9lfzHWGZ7znWF6eai55OU5WChJt+xgA=;
	b=c9XmhPE8G1JD2FfjM2TJqqffeBRAuOFYeWGGS5TtF8eJW98q7Z0VB0yO/gK38oKK410h2p
	dOHRSB4h2oafpb7m5ashEPyRz4PXYeXgJE6OOtQCnSVc0IGyce7KNj2GfYo2CH0rHEJLcd
	g3XnACS+JPL9kJ8d8SqU4W2eaM71R2Q=
Date: Fri, 27 Feb 2026 14:05:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
 <aZ-R87JfacQ2gGq1@linux.dev>
 <CAO9r8zPmgytmGHAbueFKXcZWY5SJaEwD3Pqk99ws4XeO2_hnKw@mail.gmail.com>
 <97e296ed-ef73-44b7-ab68-3d79749caa47@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <97e296ed-ef73-44b7-ab68-3d79749caa47@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C6EF18000A
X-Stat-Signature: 69f6spg9w6xgb3yhsaozqdn1jq6ic8ig
X-Rspam-User: 
X-HE-Tag: 1772172375-502468
X-HE-Meta: U2FsdGVkX18kqjlYPkECNdM/fAh5j9Is8q78Q2lRLlNmi8xr94uZrQ0wHDEWjaOHlekYp6Ki52GBrkMF3mWhzs6ajtFEaFysnEHrAfAWD4BhfiEof3SBMU1v5yNlhhPcL24vB7McIJInyubr+BwrE/4jTu6BMl1R4vF1LB3AyFTDH5PHBIevaxmCZ3VIEiZTuiOWST5AxwEezf1cuhb6gPs0CA8Jr03v8kubh17JM7l+NqLLPmtTEIvCjYm6GXiJWuNsq7Za4p9H18E5FslnliNdH/ZL/5vHOVFgqTBVrSMQtzbM/ZQ8PuFk/U1R7Y2j5FIdvtFFvh0lGYyZFBLiaG9lCCueZJONQ0IIAIDY23YpWNz0LI7Zk9NgEPxnyGq0+8p/xr3GITgEPcJFC8K9LrODSXzhtF3wPZzNijGR0bEkC1MYvFc1QZA1x0ZpIV8yNBXMbmYdCGNHLnHS47AAxuKuuNIc/jX+Vk7jHe+P4tyR+GkAtGKlV8nYEalRTPOopXhw9DiRJm2yFAkQSPVEYVTW+3aWSIKF9toCglZ0wM7pUd9XG+LpxFkv8kEu6H6a1rXCR0/z3uzhjrNOcjBgmmzSEQL4sKvE+tcJy9koIDf+Iftn7069+3Xd7dpF0tQ9mu/Z/j/9WNuI+HwUCg77JCF2ApiUzoTsXrF2LzxkrhYCpoC1mjCb3QQLn6TWp5bxUwaiMmObWuDb24dhALE8va9NhqTA1gOqg/67/LvTb+RnvuYaSGgcmfG+pL9+e5dXZJWvC5RjFz/VRWI9LZhtleaDnt9kHB5F1haPx1YCaa8v+H2U1QXBe2HeDSNEZIkVlijisO3gUAIQPW42zBcPRkeXy5lU8zS9zYMItsyf/L7RHHAejsUcf5kozIu1wWvQEA0yD70m/Sld5rPC1H4DcCe0nLU8IQDazmGvdg/xx45v/NZLY6V+juqopxbftD/TGpLl6aHLN6f9hYFtVoD
 L18OgG7b
 /a08mr1pKAcaoOMm7E4Gaej+lbTgQTLhn7+7jhR2AOkC5AoqnHVXrfi6Ln4mGcJN/bTC6g8LPsnDL2LAS5DiyzGi5np72AWxZZc9GqjuJtV0dGiiD4+kJucY6WuHuZIAyVytrJfCXPD07E0S8Pqr3cSCymaEIroLK2f/tNHLhxonc6rZ/robNaiUTY+n6ZdsHQyld
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/27/26 11:11 AM, Qi Zheng wrote:
> Hi Yosry,
> 
> On 2/26/26 11:16 PM, Yosry Ahmed wrote:
>>>> Did you measure the impact of making state_local atomic on the flush
>>>> path? It's a slow path but we've seen pain from it being too slow
>>>> before, because it extends the critical section of the rstat flush
>>>> lock.
>>>
>>> Qi, please measure the impact on flushing and if no impact then no 
>>> need to do
>>> anything as I don't want anymore churn in this series.
>>>
>>>>
>>>> Can we keep this non-atomic and use mod_memcg_lruvec_state() here? It
>>>> will update the stat on the local counter and it will be added to
>>>> state_local in the flush path when needed. We can even force another
>>>> flush in reparent_state_local () after reparenting is completed, if we
>>>> want to avoid leaving a potentially large stat update pending, as it
>>>> can be missed by mem_cgroup_flush_stats_ratelimited().
>>>>
>>>> Same for reparent_memcg_state_local(), we can probably use 
>>>> mod_memcg_state()?
>>>
>>> Yosry, do you mind sending the patch you are thinking about over this 
>>> series?
>>
>> Honestly, I'd rather squash it into this patch if possible. It avoids
>> churn in the history (switch to atomics and back), and is arguably
>> simpler than checking for regressions in the flush path.
>>
>> What I have in mind is the diff below (build tested only). Qi, would
>> you be able to test this? It applies directly on this patch in mm-new:
> 
> Thank you so much for doing this! I'm willing to squash and test.
> 
> And I found some issues with the diff:
> 
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index d82dbfcc28057..404565e80cbf3 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -234,11 +234,18 @@ static inline void reparent_state_local(struct
>> mem_cgroup *memcg, struct mem_cgr
>>          if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>>                  return;
>>
>> +       /*
>> +        * Reparent stats exposed non-hierarchically. Flush @memcg's
>> stats first to
>> +        * read its stats accurately , and conservatively flush 
>> @parent's stats
>> +        * after reparenting to avoid hiding a potentially large stat 
>> update
>> +        * (e.g. from callers of mem_cgroup_flush_stats_ratelimited()).
>> +        */
>>          __mem_cgroup_flush_stats(memcg, true);
>>
>> -       /* The following counts are all non-hierarchical and need to
>> be reparented. */
>>          reparent_memcg1_state_local(memcg, parent);
>>          reparent_memcg1_lruvec_state_local(memcg, parent);
>> +
>> +       __mem_cgroup_flush_stats(parent, true);
>>   }
>>   #else
>>   static inline void reparent_state_local(struct mem_cgroup *memcg,
>> struct mem_cgroup *parent)
>> @@ -442,7 +449,7 @@ struct lruvec_stats {
>>          long state[NR_MEMCG_NODE_STAT_ITEMS];
>>
>>          /* Non-hierarchical (CPU aggregated) state */
>> -       atomic_long_t state_local[NR_MEMCG_NODE_STAT_ITEMS];
>> +       long state_local[NR_MEMCG_NODE_STAT_ITEMS];
>>
>>          /* Pending child counts during tree propagation */
>>          long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
>> @@ -485,7 +492,7 @@ unsigned long lruvec_page_state_local(struct 
>> lruvec *lruvec,
>>                  return 0;
>>
>>          pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
>> -       x = atomic_long_read(&(pn->lruvec_stats->state_local[i]));
>> +       x = READ_ONCE(pn->lruvec_stats->state_local[i]);
>>   #ifdef CONFIG_SMP
>>          if (x < 0)
>>                  x = 0;
>> @@ -493,6 +500,10 @@ unsigned long lruvec_page_state_local(struct
>> lruvec *lruvec,
>>          return x;
>>   }
>>
>> +static void mod_memcg_lruvec_state(struct lruvec *lruvec,
>> +                                  enum node_stat_item idx,
>> +                                  int val);
>> +
>>   #ifdef CONFIG_MEMCG_V1
>>   void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>>                                         struct mem_cgroup *parent, int 
>> idx)
>> @@ -506,12 +517,10 @@ void reparent_memcg_lruvec_state_local(struct
>> mem_cgroup *memcg,
>>          for_each_node(nid) {
>>                  struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg,
>> NODE_DATA(nid));
>>                  struct lruvec *parent_lruvec =
>> mem_cgroup_lruvec(parent, NODE_DATA(nid));
>> -               struct mem_cgroup_per_node *parent_pn;
>>                  unsigned long value =
>> lruvec_page_state_local(child_lruvec, idx);
>>
>> -               parent_pn = container_of(parent_lruvec, struct
>> mem_cgroup_per_node, lruvec);
>> -
>> -               atomic_long_add(value,
>> &(parent_pn->lruvec_stats->state_local[i]));
>> +               mod_memcg_lruvec_state(child_lruvec, idx, -value);
> 
> We can't use mod_memcg_lruvec_state() here, because child memcg has
> already been set CSS_DYING. So in mod_memcg_lruvec_state(), we will
> get parent memcg.
> 
> It seems we need to reimplement a function or add a parameter to
> mod_memcg_lruvec_state() to solve the problem. What do you think?

Since child memcg is about to disappear, perhaps we can just add value
to parent memcg without handling the child memcg. Make sense?

> 
>> +               mod_memcg_lruvec_state(parent_lruvec, idx, value);
>>          }
>>   }
>>   #endif
>> @@ -598,7 +607,7 @@ struct memcg_vmstats {
>>          unsigned long           events[NR_MEMCG_EVENTS];
>>
>>          /* Non-hierarchical (CPU aggregated) page state & events */
>> -       atomic_long_t           state_local[MEMCG_VMSTAT_SIZE];
>> +       long                    state_local[MEMCG_VMSTAT_SIZE];
>>          unsigned long           events_local[NR_MEMCG_EVENTS];
>>
>>          /* Pending child counts during tree propagation */
>> @@ -835,7 +844,7 @@ unsigned long memcg_page_state_local(struct
>> mem_cgroup *memcg, int idx)
>>          if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n",
>> __func__, idx))
>>                  return 0;
>>
>> -       x = atomic_long_read(&(memcg->vmstats->state_local[i]));
>> +       x = READ_ONCE(memcg->vmstats->state_local[i]);
>>   #ifdef CONFIG_SMP
>>          if (x < 0)
>>                  x = 0;
>> @@ -852,7 +861,8 @@ void reparent_memcg_state_local(struct mem_cgroup 
>> *memcg,
>>          if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n",
>> __func__, idx))
>>                  return;
>>
>> -       atomic_long_add(value, &(parent->vmstats->state_local[i]));
>> +       mod_memcg_state(memcg, idx, -value);
> 
> Same as mod_memcg_lruvec_state().
> 
> Thanks,
> Qi
> 
>> +       mod_memcg_state(parent, idx, value);
>>   }
>>   #endif
>>
>> @@ -4174,8 +4184,6 @@ struct aggregate_control {
>>          long *aggregate;
>>          /* pointer to the non-hierarchichal (CPU aggregated) counters */
>>          long *local;
>> -       /* pointer to the atomic non-hierarchichal (CPU aggregated) 
>> counters */
>> -       atomic_long_t *alocal;
>>          /* pointer to the pending child counters during tree 
>> propagation */
>>          long *pending;
>>          /* pointer to the parent's pending counters, could be NULL */
>> @@ -4213,12 +4221,8 @@ static void mem_cgroup_stat_aggregate(struct
>> aggregate_control *ac)
>>                  }
>>
>>                  /* Aggregate counts on this level and propagate 
>> upwards */
>> -               if (delta_cpu) {
>> -                       if (ac->local)
>> -                               ac->local[i] += delta_cpu;
>> -                       else if (ac->alocal)
>> -                               atomic_long_add(delta_cpu, &(ac- 
>> >alocal[i]));
>> -               }
>> +               if (delta_cpu)
>> +                       ac->local[i] += delta_cpu;
>>
>>                  if (delta) {
>>                          ac->aggregate[i] += delta;
>> @@ -4289,8 +4293,7 @@ static void mem_cgroup_css_rstat_flush(struct
>> cgroup_subsys_state *css, int cpu)
>>
>>          ac = (struct aggregate_control) {
>>                  .aggregate = memcg->vmstats->state,
>> -               .local = NULL,
>> -               .alocal = memcg->vmstats->state_local,
>> +               .local = memcg->vmstats->state_local,
>>                  .pending = memcg->vmstats->state_pending,
>>                  .ppending = parent ? parent->vmstats->state_pending : 
>> NULL,
>>                  .cstat = statc->state,
>> @@ -4323,8 +4326,7 @@ static void mem_cgroup_css_rstat_flush(struct
>> cgroup_subsys_state *css, int cpu)
>>
>>                  ac = (struct aggregate_control) {
>>                          .aggregate = lstats->state,
>> -                       .local = NULL,
>> -                       .alocal = lstats->state_local,
>> +                       .local = lstats->state_local,
>>                          .pending = lstats->state_pending,
>>                          .ppending = plstats ? plstats- 
>> >state_pending : NULL,
>>                          .cstat = lstatc->state,
> 


