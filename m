Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822F7FD9E30
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 03:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC956B0005; Thu, 26 Feb 2026 22:12:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAAB26B0088; Thu, 26 Feb 2026 22:12:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA97A6B0089; Thu, 26 Feb 2026 22:12:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B39626B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:12:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47E3FC1CD0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:12:21 +0000 (UTC)
X-FDA: 84488763282.02.4E4C5FA
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5DB518000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:12:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qp0pBMMa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772161939; a=rsa-sha256;
	cv=none;
	b=78Doyj4723++e4BECMPvaZsbWH43+NgUS8ODTsk0zoEeBWoIE5BnbQvzr8VfiaE1/lx09b
	NfE94w6KAe7EcgzXIBdoaK/MY2ABne6XqaOhG9RQqfz3IzM4xLImn7T/6VHwPxSIXSpRAU
	sa1yQYsk/mQpzDnvyoTsYmsGqU5jtyg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qp0pBMMa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772161939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9eSofGPc3u44KFMUEmfCKwDammC+wOoAF3xzjznUw8=;
	b=6D/O62C5vPgDrq/LNrr+19BclJOk+bnmNNOs4GIJ0+a/YkSV6JfUIPnW6YNMxi+DGCIoi3
	vEuMWtX6aHpXvR+5iMKD3XPkLllu+hBaFBcL7Rznon9uIYmcuunkYxSjPsk5BlhQ1Uj8jV
	Og/l/bsC8KHI/T45Vsnkst2jZvZhs9Q=
Message-ID: <97e296ed-ef73-44b7-ab68-3d79749caa47@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772161936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e9eSofGPc3u44KFMUEmfCKwDammC+wOoAF3xzjznUw8=;
	b=qp0pBMMafWvK4Sxmn6zcim7tiwH0QeBbCp9/CCu+LJR5xWQBGthnSeE9jXEotNJfYPTl2W
	uZtCSCB0UO8mUKkhnD6EczVBh0C2svfSj1nm2Tw5rKtFwyaojmGaqDVPRg7xT0n33lQydx
	kI/BzpUWIfUfu/zYRrRCDDDt0n+taNQ=
Date: Fri, 27 Feb 2026 11:11:57 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAO9r8zPmgytmGHAbueFKXcZWY5SJaEwD3Pqk99ws4XeO2_hnKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5DB518000B
X-Stat-Signature: gnar3c3hp35n17tbpsns83e9n8cj4x3s
X-HE-Tag: 1772161939-668310
X-HE-Meta: U2FsdGVkX191Wt5CmBFjR1p8WG7V9rGqyOfBEBp0WiiMOpSM5aUr02ASyp3QSqkSAvbTnxmhFPFAP9BT0jACbudgZqGJFZQVcx5fHGDJa0ZgFFvQkUluBOk4qMEHe1tkjnXvEAG36nLxUQ8OIwX2/AIUT8Ebkh+lPZ6f1uUSRVzWXI1pTD2TpXKyJfodTMVveZSZthuqPh4BZdoikwQK/MI7rbR2ewDGGJJQBKkRPwBtmijA2HuKIdLM23JurQSXVi2iVsAxntoSBaQaQC4vpqLAM/WhO6UXsqm1ToFAXiNDoQ5io+Oyj+dY2vmcLxBNRKv0i2M0EuzbrjJENVWKECAApS29yPKyYRzD+voSqkvly58cv0QN/6XfGiv7gHbW/XusfciM0bKluRxtOfxbfnymhtzRNpdZ07faw1eKfL5jNeeveXMdHQJoNWujoHe+Iod3qBx2/z/RnF4r/x/CNDN/UkfJF8cIfspKdNgp6+HQQ1loRNFKpLLCCgmKb4eU9EP4EKDT6w71pITv/9ILlN2bSeTVYYSmhYWJTizIIqN5Eo5rjIYEDQmGRldXujZ1ftYEj/7eiWswT9qOM+EH/s/1BXNYGOCDsRbxQg5Ffj4/efIsTVta7v4B/kMNJtV5hAye4JlEh8LAO6PC+e+ATKyRfRYbaeMHXehFcAgHy5vj/HAetwAr9RUzT4HzndNyUpTaPCDM6/vhtpQT87sUKPfkZP0bX35ZVMUVLDAL/tGXEwGdG4yvFvnsivxTyeaJ/76vs7r3JKCOPfHl4ytCS7TXL/D0lsfrCF7c/oEHytx5OhFg/euEDYjnX+3XxWBgadUnqBoIWwpcIAFK30i4peZ2Ym9TdRq/WXXoXDaa0n8XxlLrn4p0ZRcbu4dvJMeCCC3QJkH/mUJbQd3NLMTY4zNg83o+nEmXVXB4Ea7IiXtoRznLwqv0hJy0tcRFW5LdZvNhU9rinjwjgvJDla/
 oJbUJIgG
 seCSI0pqKaT3ZVWM9gRiVLX58jX7K4Zq3Oj2WiwzTmRBRiwrNlUmBpnLfd53eA4X3VGia0HDe9jwIAPkHm51c0fy3Sl3vbGv6+7xwUWu17Vyz5CBFlR0RJ/6211kEv/D7u2ooMo965b6kzVWA1nLYyNg8Y+3pIqrF5DGU9ZQPO95IfQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yosry,

On 2/26/26 11:16 PM, Yosry Ahmed wrote:
>>> Did you measure the impact of making state_local atomic on the flush
>>> path? It's a slow path but we've seen pain from it being too slow
>>> before, because it extends the critical section of the rstat flush
>>> lock.
>>
>> Qi, please measure the impact on flushing and if no impact then no need to do
>> anything as I don't want anymore churn in this series.
>>
>>>
>>> Can we keep this non-atomic and use mod_memcg_lruvec_state() here? It
>>> will update the stat on the local counter and it will be added to
>>> state_local in the flush path when needed. We can even force another
>>> flush in reparent_state_local () after reparenting is completed, if we
>>> want to avoid leaving a potentially large stat update pending, as it
>>> can be missed by mem_cgroup_flush_stats_ratelimited().
>>>
>>> Same for reparent_memcg_state_local(), we can probably use mod_memcg_state()?
>>
>> Yosry, do you mind sending the patch you are thinking about over this series?
> 
> Honestly, I'd rather squash it into this patch if possible. It avoids
> churn in the history (switch to atomics and back), and is arguably
> simpler than checking for regressions in the flush path.
> 
> What I have in mind is the diff below (build tested only). Qi, would
> you be able to test this? It applies directly on this patch in mm-new:

Thank you so much for doing this! I'm willing to squash and test.

And I found some issues with the diff:

> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d82dbfcc28057..404565e80cbf3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -234,11 +234,18 @@ static inline void reparent_state_local(struct
> mem_cgroup *memcg, struct mem_cgr
>          if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>                  return;
> 
> +       /*
> +        * Reparent stats exposed non-hierarchically. Flush @memcg's
> stats first to
> +        * read its stats accurately , and conservatively flush @parent's stats
> +        * after reparenting to avoid hiding a potentially large stat update
> +        * (e.g. from callers of mem_cgroup_flush_stats_ratelimited()).
> +        */
>          __mem_cgroup_flush_stats(memcg, true);
> 
> -       /* The following counts are all non-hierarchical and need to
> be reparented. */
>          reparent_memcg1_state_local(memcg, parent);
>          reparent_memcg1_lruvec_state_local(memcg, parent);
> +
> +       __mem_cgroup_flush_stats(parent, true);
>   }
>   #else
>   static inline void reparent_state_local(struct mem_cgroup *memcg,
> struct mem_cgroup *parent)
> @@ -442,7 +449,7 @@ struct lruvec_stats {
>          long state[NR_MEMCG_NODE_STAT_ITEMS];
> 
>          /* Non-hierarchical (CPU aggregated) state */
> -       atomic_long_t state_local[NR_MEMCG_NODE_STAT_ITEMS];
> +       long state_local[NR_MEMCG_NODE_STAT_ITEMS];
> 
>          /* Pending child counts during tree propagation */
>          long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
> @@ -485,7 +492,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>                  return 0;
> 
>          pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -       x = atomic_long_read(&(pn->lruvec_stats->state_local[i]));
> +       x = READ_ONCE(pn->lruvec_stats->state_local[i]);
>   #ifdef CONFIG_SMP
>          if (x < 0)
>                  x = 0;
> @@ -493,6 +500,10 @@ unsigned long lruvec_page_state_local(struct
> lruvec *lruvec,
>          return x;
>   }
> 
> +static void mod_memcg_lruvec_state(struct lruvec *lruvec,
> +                                  enum node_stat_item idx,
> +                                  int val);
> +
>   #ifdef CONFIG_MEMCG_V1
>   void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>                                         struct mem_cgroup *parent, int idx)
> @@ -506,12 +517,10 @@ void reparent_memcg_lruvec_state_local(struct
> mem_cgroup *memcg,
>          for_each_node(nid) {
>                  struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg,
> NODE_DATA(nid));
>                  struct lruvec *parent_lruvec =
> mem_cgroup_lruvec(parent, NODE_DATA(nid));
> -               struct mem_cgroup_per_node *parent_pn;
>                  unsigned long value =
> lruvec_page_state_local(child_lruvec, idx);
> 
> -               parent_pn = container_of(parent_lruvec, struct
> mem_cgroup_per_node, lruvec);
> -
> -               atomic_long_add(value,
> &(parent_pn->lruvec_stats->state_local[i]));
> +               mod_memcg_lruvec_state(child_lruvec, idx, -value);

We can't use mod_memcg_lruvec_state() here, because child memcg has
already been set CSS_DYING. So in mod_memcg_lruvec_state(), we will
get parent memcg.

It seems we need to reimplement a function or add a parameter to
mod_memcg_lruvec_state() to solve the problem. What do you think?

> +               mod_memcg_lruvec_state(parent_lruvec, idx, value);
>          }
>   }
>   #endif
> @@ -598,7 +607,7 @@ struct memcg_vmstats {
>          unsigned long           events[NR_MEMCG_EVENTS];
> 
>          /* Non-hierarchical (CPU aggregated) page state & events */
> -       atomic_long_t           state_local[MEMCG_VMSTAT_SIZE];
> +       long                    state_local[MEMCG_VMSTAT_SIZE];
>          unsigned long           events_local[NR_MEMCG_EVENTS];
> 
>          /* Pending child counts during tree propagation */
> @@ -835,7 +844,7 @@ unsigned long memcg_page_state_local(struct
> mem_cgroup *memcg, int idx)
>          if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n",
> __func__, idx))
>                  return 0;
> 
> -       x = atomic_long_read(&(memcg->vmstats->state_local[i]));
> +       x = READ_ONCE(memcg->vmstats->state_local[i]);
>   #ifdef CONFIG_SMP
>          if (x < 0)
>                  x = 0;
> @@ -852,7 +861,8 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
>          if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n",
> __func__, idx))
>                  return;
> 
> -       atomic_long_add(value, &(parent->vmstats->state_local[i]));
> +       mod_memcg_state(memcg, idx, -value);

Same as mod_memcg_lruvec_state().

Thanks,
Qi

> +       mod_memcg_state(parent, idx, value);
>   }
>   #endif
> 
> @@ -4174,8 +4184,6 @@ struct aggregate_control {
>          long *aggregate;
>          /* pointer to the non-hierarchichal (CPU aggregated) counters */
>          long *local;
> -       /* pointer to the atomic non-hierarchichal (CPU aggregated) counters */
> -       atomic_long_t *alocal;
>          /* pointer to the pending child counters during tree propagation */
>          long *pending;
>          /* pointer to the parent's pending counters, could be NULL */
> @@ -4213,12 +4221,8 @@ static void mem_cgroup_stat_aggregate(struct
> aggregate_control *ac)
>                  }
> 
>                  /* Aggregate counts on this level and propagate upwards */
> -               if (delta_cpu) {
> -                       if (ac->local)
> -                               ac->local[i] += delta_cpu;
> -                       else if (ac->alocal)
> -                               atomic_long_add(delta_cpu, &(ac->alocal[i]));
> -               }
> +               if (delta_cpu)
> +                       ac->local[i] += delta_cpu;
> 
>                  if (delta) {
>                          ac->aggregate[i] += delta;
> @@ -4289,8 +4293,7 @@ static void mem_cgroup_css_rstat_flush(struct
> cgroup_subsys_state *css, int cpu)
> 
>          ac = (struct aggregate_control) {
>                  .aggregate = memcg->vmstats->state,
> -               .local = NULL,
> -               .alocal = memcg->vmstats->state_local,
> +               .local = memcg->vmstats->state_local,
>                  .pending = memcg->vmstats->state_pending,
>                  .ppending = parent ? parent->vmstats->state_pending : NULL,
>                  .cstat = statc->state,
> @@ -4323,8 +4326,7 @@ static void mem_cgroup_css_rstat_flush(struct
> cgroup_subsys_state *css, int cpu)
> 
>                  ac = (struct aggregate_control) {
>                          .aggregate = lstats->state,
> -                       .local = NULL,
> -                       .alocal = lstats->state_local,
> +                       .local = lstats->state_local,
>                          .pending = lstats->state_pending,
>                          .ppending = plstats ? plstats->state_pending : NULL,
>                          .cstat = lstatc->state,


