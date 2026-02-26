Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D5F5FD8FDA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D48B6B00EC; Thu, 26 Feb 2026 12:03:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76AFB6B0179; Thu, 26 Feb 2026 12:03:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF266B0102; Thu, 26 Feb 2026 12:03:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 574BA6B0179
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:03:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28DED160315
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:03:12 +0000 (UTC)
X-FDA: 84487228224.27.55EBB84
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf20.hostedemail.com (Postfix) with ESMTP id E3E2A1C0015
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:03:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=poAd9zN3;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772125390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmqwR2VfW9/BK6pSRwRf4VC4vuaKHxCtIx0Jze1RC2g=;
	b=t0jG0kaINTbAmkVUqF/MgF53pVh3fv6f0BPukOaPkWXn9L1Klq+d14HemgVpDlORD12mCd
	7Tz/pqfqWOZooeJHxLrL/u5Y1RpxMfm1luloqcY3RUSKxLFiqKCA919UJzNgih8BEopa1u
	91pVsTuHziL3FyZNrJmufwXxWRmDrEo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=poAd9zN3;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772125390; a=rsa-sha256;
	cv=none;
	b=gtJB7vQShjSSAbpecj2JUt3l5thSNBe4sbS3zlR4NGUxIGaQRGrNAVW5Pxtmb90RuGxlGT
	46NuNrGjqnLnOgwtYtLA30EM/y0jYXMMuqUmSpsIdjfDA0RLOMsuRWl1SlrwQAbtP3SboM
	AxVvWPT8f6ZhmbV3s50QAsg/HQ9nWlU=
Date: Thu, 26 Feb 2026 09:02:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772125387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QmqwR2VfW9/BK6pSRwRf4VC4vuaKHxCtIx0Jze1RC2g=;
	b=poAd9zN3ZW2O8aPHHsQ5vQ+4Ej/d3mGYgOXpxfrGT5y6HP6geAK0fhG+e8SL8FJZ3DUit9
	ITN3g3TPnlkQmKxepNYwUa4AfJxGQgRjK/9ZBTFJftBO05MgqBZxKg291eypBRs5bnG7xl
	30ZVg+WcpoqKTmS8uxU2OoWyVerD/7o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <aaB7yYSpAaC5uInq@linux.dev>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
 <aZ-R87JfacQ2gGq1@linux.dev>
 <CAO9r8zPmgytmGHAbueFKXcZWY5SJaEwD3Pqk99ws4XeO2_hnKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zPmgytmGHAbueFKXcZWY5SJaEwD3Pqk99ws4XeO2_hnKw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E3E2A1C0015
X-Stat-Signature: iuxfhpdo448gi5w8jspfwiessgdrboxk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1772125389-422076
X-HE-Meta: U2FsdGVkX1/wfYO32FM2jQ1jDpQCvHOBbSC8J8SQymNHXJvsUt0ensPKMlzcqvpvhmiwsWzKsGkffs3fAkRyJ+/vE0jPJeVKA3K8Yx8brq9dw1Sm5srHw/hC4QdMajFAykY0KcK6p1k0LlxhVzQdZnc5UfTlQd6yfxEFmJi8VVMJdftXa5lcnDonSAv6E6KlWaBYQhS6ZIFN1zApP4cXP6nrpy+AkaKZJzuDOCMBrvzSuh8bxUf+huiu5pOCuYdcsWgNS0wxxpsDnOMybGvyabr6DkKrK7xCL+obOE1ZcyWJTRvscRbkHWlclL3Ok+uHj8nQv4NFjONNFAiZ5FpmtxyC0zGjNxu+ftp38Wd3yyqtrGwZKBCM/HGK/uCPwGFXjfOYlUuTz3reqhEzswOKGDvp8H5T+CCUzky7kr9GeUfeQPVm3BcJpa2sbLuRr5+NASo13jjI+UNw11Lq7jVI0chxUEXkIgcZV4I5xFwZUIMDZeAHCS5QIgQP81LOO2aWQ/YvRcZhh0Bikq4H5c9h/5r6QCvIkebcscU/dhCplvCFjV6mjQW92msEIJyqR1+2dTLuEnWuFJIzQzxEEh2cZXB1wPPqadGx62Esj8iKMbxRe9JqXFbp/KWA/nyKbh8Hx8ks65hK8prRVWj69Q+GDYHik35G9nvX3Z30eZSkRmS74w/cj6tH+AyZc2u+6lsAGKpPiJmLjHcwvePq7jYnQJeJmomIFZB3P0EIb1QPmk0eLHHVPpVI45LHS8Arza94vWjCGhDnjpMDi8TFFzo1b44cawX6PV9Q2j37uLE2UWyjKblBUEdpuZd5NP4rHpryx9oLr8yluL8mSoURsFLcHJec+fx1Ev8iaQZt9LhHAfIhNo2W9vblq9VPboOFexlHf2dQTem0IgfQaTbi7JD+SPn4Bjx+xPDomjlBHFVmBEaU/BeQPJypUuDF7wUcFe30+rH3zoksvA6Km5sYFcp
 oZ7jI5XV
 sKHTtAXBCvbDkpxNYKRVSgbkXixPYBJOUuUE59DA5Coz+SezlWqGiPEpHj3h9gk/cFs0p4fJU/Yq37BVrVmZzyuYMd1xSKHVqC+Q81lrZAYPNt1I4JhifvEwhI5I5JrBWAuDjogZEK5JOIzKPuQebwVb8UZO4MKiJAyg8pBY1pznXmlkHSnHPfEFrlKazz274rpUTwz02CzwyiBZejV8poRKrFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 07:16:50AM -0800, Yosry Ahmed wrote:
> > > Did you measure the impact of making state_local atomic on the flush
> > > path? It's a slow path but we've seen pain from it being too slow
> > > before, because it extends the critical section of the rstat flush
> > > lock.
> >
> > Qi, please measure the impact on flushing and if no impact then no need to do
> > anything as I don't want anymore churn in this series.
> >
> > >
> > > Can we keep this non-atomic and use mod_memcg_lruvec_state() here? It
> > > will update the stat on the local counter and it will be added to
> > > state_local in the flush path when needed. We can even force another
> > > flush in reparent_state_local () after reparenting is completed, if we
> > > want to avoid leaving a potentially large stat update pending, as it
> > > can be missed by mem_cgroup_flush_stats_ratelimited().
> > >
> > > Same for reparent_memcg_state_local(), we can probably use mod_memcg_state()?
> >
> > Yosry, do you mind sending the patch you are thinking about over this series?
> 
> Honestly, I'd rather squash it into this patch if possible. It avoids
> churn in the history (switch to atomics and back), and is arguably
> simpler than checking for regressions in the flush path.

Yup, let's squash it into the original patch. Please add your sign-off tag.

> 
> What I have in mind is the diff below (build tested only). Qi, would
> you be able to test this? It applies directly on this patch in mm-new:

Qi, please squash this diff into the patch and test. You might need to change
the subsequent patches. Once you are done with testing, you can post the diffs
for those in reply to those patches and we will ask Andrew to squash into
orinigal ones.

The diff looks good to me though.
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d82dbfcc28057..404565e80cbf3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -234,11 +234,18 @@ static inline void reparent_state_local(struct
> mem_cgroup *memcg, struct mem_cgr
>         if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>                 return;
> 
> +       /*
> +        * Reparent stats exposed non-hierarchically. Flush @memcg's
> stats first to
> +        * read its stats accurately , and conservatively flush @parent's stats
> +        * after reparenting to avoid hiding a potentially large stat update
> +        * (e.g. from callers of mem_cgroup_flush_stats_ratelimited()).
> +        */
>         __mem_cgroup_flush_stats(memcg, true);
> 
> -       /* The following counts are all non-hierarchical and need to
> be reparented. */
>         reparent_memcg1_state_local(memcg, parent);
>         reparent_memcg1_lruvec_state_local(memcg, parent);
> +
> +       __mem_cgroup_flush_stats(parent, true);
>  }
>  #else
>  static inline void reparent_state_local(struct mem_cgroup *memcg,
> struct mem_cgroup *parent)
> @@ -442,7 +449,7 @@ struct lruvec_stats {
>         long state[NR_MEMCG_NODE_STAT_ITEMS];
> 
>         /* Non-hierarchical (CPU aggregated) state */
> -       atomic_long_t state_local[NR_MEMCG_NODE_STAT_ITEMS];
> +       long state_local[NR_MEMCG_NODE_STAT_ITEMS];
> 
>         /* Pending child counts during tree propagation */
>         long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
> @@ -485,7 +492,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>                 return 0;
> 
>         pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -       x = atomic_long_read(&(pn->lruvec_stats->state_local[i]));
> +       x = READ_ONCE(pn->lruvec_stats->state_local[i]);
>  #ifdef CONFIG_SMP
>         if (x < 0)
>                 x = 0;
> @@ -493,6 +500,10 @@ unsigned long lruvec_page_state_local(struct
> lruvec *lruvec,
>         return x;
>  }
> 
> +static void mod_memcg_lruvec_state(struct lruvec *lruvec,
> +                                  enum node_stat_item idx,
> +                                  int val);
> +
>  #ifdef CONFIG_MEMCG_V1
>  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>                                        struct mem_cgroup *parent, int idx)
> @@ -506,12 +517,10 @@ void reparent_memcg_lruvec_state_local(struct
> mem_cgroup *memcg,
>         for_each_node(nid) {
>                 struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg,
> NODE_DATA(nid));
>                 struct lruvec *parent_lruvec =
> mem_cgroup_lruvec(parent, NODE_DATA(nid));
> -               struct mem_cgroup_per_node *parent_pn;
>                 unsigned long value =
> lruvec_page_state_local(child_lruvec, idx);
> 
> -               parent_pn = container_of(parent_lruvec, struct
> mem_cgroup_per_node, lruvec);
> -
> -               atomic_long_add(value,
> &(parent_pn->lruvec_stats->state_local[i]));
> +               mod_memcg_lruvec_state(child_lruvec, idx, -value);
> +               mod_memcg_lruvec_state(parent_lruvec, idx, value);
>         }
>  }
>  #endif
> @@ -598,7 +607,7 @@ struct memcg_vmstats {
>         unsigned long           events[NR_MEMCG_EVENTS];
> 
>         /* Non-hierarchical (CPU aggregated) page state & events */
> -       atomic_long_t           state_local[MEMCG_VMSTAT_SIZE];
> +       long                    state_local[MEMCG_VMSTAT_SIZE];
>         unsigned long           events_local[NR_MEMCG_EVENTS];
> 
>         /* Pending child counts during tree propagation */
> @@ -835,7 +844,7 @@ unsigned long memcg_page_state_local(struct
> mem_cgroup *memcg, int idx)
>         if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n",
> __func__, idx))
>                 return 0;
> 
> -       x = atomic_long_read(&(memcg->vmstats->state_local[i]));
> +       x = READ_ONCE(memcg->vmstats->state_local[i]);
>  #ifdef CONFIG_SMP
>         if (x < 0)
>                 x = 0;
> @@ -852,7 +861,8 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
>         if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n",
> __func__, idx))
>                 return;
> 
> -       atomic_long_add(value, &(parent->vmstats->state_local[i]));
> +       mod_memcg_state(memcg, idx, -value);
> +       mod_memcg_state(parent, idx, value);
>  }
>  #endif
> 
> @@ -4174,8 +4184,6 @@ struct aggregate_control {
>         long *aggregate;
>         /* pointer to the non-hierarchichal (CPU aggregated) counters */
>         long *local;
> -       /* pointer to the atomic non-hierarchichal (CPU aggregated) counters */
> -       atomic_long_t *alocal;
>         /* pointer to the pending child counters during tree propagation */
>         long *pending;
>         /* pointer to the parent's pending counters, could be NULL */
> @@ -4213,12 +4221,8 @@ static void mem_cgroup_stat_aggregate(struct
> aggregate_control *ac)
>                 }
> 
>                 /* Aggregate counts on this level and propagate upwards */
> -               if (delta_cpu) {
> -                       if (ac->local)
> -                               ac->local[i] += delta_cpu;
> -                       else if (ac->alocal)
> -                               atomic_long_add(delta_cpu, &(ac->alocal[i]));
> -               }
> +               if (delta_cpu)
> +                       ac->local[i] += delta_cpu;
> 
>                 if (delta) {
>                         ac->aggregate[i] += delta;
> @@ -4289,8 +4293,7 @@ static void mem_cgroup_css_rstat_flush(struct
> cgroup_subsys_state *css, int cpu)
> 
>         ac = (struct aggregate_control) {
>                 .aggregate = memcg->vmstats->state,
> -               .local = NULL,
> -               .alocal = memcg->vmstats->state_local,
> +               .local = memcg->vmstats->state_local,
>                 .pending = memcg->vmstats->state_pending,
>                 .ppending = parent ? parent->vmstats->state_pending : NULL,
>                 .cstat = statc->state,
> @@ -4323,8 +4326,7 @@ static void mem_cgroup_css_rstat_flush(struct
> cgroup_subsys_state *css, int cpu)
> 
>                 ac = (struct aggregate_control) {
>                         .aggregate = lstats->state,
> -                       .local = NULL,
> -                       .alocal = lstats->state_local,
> +                       .local = lstats->state_local,
>                         .pending = lstats->state_pending,
>                         .ppending = plstats ? plstats->state_pending : NULL,
>                         .cstat = lstatc->state,

