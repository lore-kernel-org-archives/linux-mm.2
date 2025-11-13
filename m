Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 485DCCD4F35
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 02:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3F68E0020; Wed, 12 Nov 2025 21:01:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B928E001F; Wed, 12 Nov 2025 21:01:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7FD8E0020; Wed, 12 Nov 2025 21:01:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DDCE8E001F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:01:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEE4312E29B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:01:39 +0000 (UTC)
X-FDA: 84103932318.18.82996F9
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3141C0012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:01:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762999298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulbFeIjMdeHEM952ouEyP8ztwT82uPqA/IHlJd6p1Cc=;
	b=G1anCc55v7xlZWeCIkseXhQCh/qjkP7UcHj0PmFh7mbl7h13ctUez9bxWWJtZQf7DBw8lJ
	tPINFLn8M0FvgOv2gq0TB0NdJoBRXsNSm+haYQgY8UEoTZrUxxTNZrCHVp5Z0NZK0YlmFB
	6p+7ubdgDxFgUDSR5b/BImDzQMgy7BQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762999298; a=rsa-sha256;
	cv=none;
	b=4kP3yK8Pp/QkPITnu/2jeAYm3IY8iopvSbeTdYMrY4RnQuDkzPnGlr0gKULd44A5N85B3r
	H2RzSxeJiHAlyy76ekRUThcxGElOJBiUmU5lk4OMYKxDZEH9KjhNWVzwwAr4jU76+pPAVD
	xisDsQNqeG6sXuxYhKqOKySlhRWZjz4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 13 Nov 2025 11:01:34 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 13 Nov 2025 11:01:34 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com
Subject: Re: [PATCH 2/3] mm: swap: introduce swap tier infrastructure
Message-ID: <aRU7/ibyrPTn93qV@yjaykim-PowerEdge-T330>
References: <20251109124947.1101520-1-youngjun.park@lge.com>
 <20251109124947.1101520-3-youngjun.park@lge.com>
 <CACePvbUvDfZgDx-sXkZ+Oa7DwtKg6b1t=owQ1sRZ_FpFrGxA3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbUvDfZgDx-sXkZ+Oa7DwtKg6b1t=owQ1sRZ_FpFrGxA3g@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A3141C0012
X-Stat-Signature: dh95g49999skg53wztzgqgtttc1595mt
X-Rspam-User: 
X-HE-Tag: 1762999297-998710
X-HE-Meta: U2FsdGVkX1+FEDX3x8g6SMv5jZD3lRL907HdFgnLz8BHatHCG00zIIZp+NPvlMOW1uUQz4rOnxPexrBs/wxFZZkUI0szmtz/5myuDbaiK4eeRNB8xHfAAiyonqv1TA0Iq22o5BOpnyJX7nFTL8KKd+cwvzP0ztfpJcve3BwVH1GiU0qN2o92X8hFOfKdnX4TpKHkMAUrulLQXRjrg5hNQFk9OhnLNY8ZBTmMCwxJtZJ4pdr1AtYvUC8V7mVACXpthX/tTlnfOcIoEeZd3fvpuC1NToucatwmdcIjf6gDLpbwuZIz98oCtRPLp87knMlC24GvS+bzjPRfNgzws/L6oukEO/CuVSH0PfGR0oy1ia9Y2RFoJT+kuySe3v6Dii9NW/tnfH8aO28LWS1ngOLx06jIuRIH30ZUOGYWOincZbioK0Jh/tONvSpN/Wfw16Bvhuftytaxs2J40AHXRffbklPvvL8enUKdSyU+9Pz3RL/6PwrLmHS9/KLD8Uis6Ir7dRRaMjhrQdqeUhnHy427ujnTkryYfZwb8HUK1cWUI2d/2MwAxODsGSAMgmo9ErIlHZlJY5BY1oFsYovUf/BP4wXIL4YGd7bRLgUESqV2hbf4B/AJLbBrOBEx6ZV4re04dKENW3ymbmbkBxOZvW4AvENVrkktqmzh6t7IUt4k+yBmDSQMDlkbpTweM9MPIABXJnqtK49uzzxu3iIDopaEx5/upkCs6XrKig4oyKdxQvdeNZ4+rEQ+Wvjd3zGZjIIUJPQS+WhUWRtt0A66nZGa9UzGWpcKFF6sYWjYCHRvg+ZwWUBpstSnoUtFVNtlsaJhd+lg9X9NEbhUXOi9t32ECKZhkXqW495m4EeikpJpDDPtgDCWB1Eafgm45MjmtU7JveH7GgL03Lk9SDD8GGCW6SKppQcXmTqDIKevVqaEwsnUOqoYw/G3Lx+kXItMpbqB13Z3zP2UevljNT1kR1R
 twRCBx6j
 ptqjHcESQELTwxr3BV87mTBRjX/lm+GkBJMPJIPQ9CqFGEetb0aGW4GCTl9mCyN/eKQn7zSDuGftUybQ2YM0w2JMn3qIiX8qFkyP1yfBVtIi1AQWJl6AUVj6tQcwz/QJdDeEhleaLGZNSUvuTymPb9FCVuVrznNrjd7YSeOpXOhV1DFB+Z+ZSnO0jyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 06:20:22AM -0800, Chris Li wrote:
> First of all, for RFC series, please include RFC in each patch subject as well.
> 
> For the real patch submission, please consider split it into smaller
> chunks and have incremental milestones.
> Only introduce the function needed for each milestone, not define them
> all together then use it in later patches.
> 
> See some feedback as follows.
> 
> This patch is too big, to be continued.
> 
> Chris

Sure, I will take care of it. will make better on real patch submissions.

> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 966f7c1a0128..1224029620ed 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -283,6 +283,10 @@ struct mem_cgroup {
> >         /* per-memcg mm_struct list */
> >         struct lru_gen_mm_list mm_list;
> >  #endif
> > +#ifdef CONFIG_SWAP_TIER
> 
> I think we don't need this CONFIG_SWAP_TIER. Making it part of the
> default swap is fine.
> By default the memory.swap.tiers is empty and matches the previous
> swap behavior. The user doesn't need to do anything if they are not
> using swap tiers. I see no reason to have a separate config option.

Okay I will change it to default kernel option.

> > +       int tiers_onoff;
> > +       int tiers_mask;
> > +#endif
> >
> >  #ifdef CONFIG_MEMCG_V1
> >         /* Legacy consumer-oriented counters */
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 90fa27bb7796..8911eff9d37a 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -271,6 +271,9 @@ struct swap_info_struct {
> >         struct percpu_ref users;        /* indicate and keep swap device valid. */
> >         unsigned long   flags;          /* SWP_USED etc: see above */
> >         signed short    prio;           /* swap priority of this type */
> > +#ifdef CONFIG_SWAP_TIER
> > +       int tier_idx;
> > +#endif
> >         struct plist_node list;         /* entry in swap_active_head */
> >         signed char     type;           /* strange name for an index */
> >         unsigned int    max;            /* extent of the swap_map */
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index e1fb11f36ede..78173ffe65d6 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -163,6 +163,19 @@ endmenu
> >
> >  endif
> >
> > +config SWAP_TIER
> Same, I think we can remove the SWAP_TIER, just turn it on when swap is enabled.

Ack

> > diff --git a/mm/swap.h b/mm/swap.h
> > index d034c13d8dd2..b116282690c8 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -16,6 +16,10 @@ extern int page_cluster;
> >  #define swap_entry_order(order)        0
> >  #endif
> >
> > +#define DEF_SWAP_PRIO  -1
> > +
> > +extern spinlock_t swap_lock;
> > +extern struct plist_head swap_active_head;
> >  extern struct swap_info_struct *swap_info[];
> >
> >  /*
> > diff --git a/mm/swap_tier.c b/mm/swap_tier.c
> > new file mode 100644
> > index 000000000000..4301e3c766b9
> > --- /dev/null
> > +++ b/mm/swap_tier.c
> > @@ -0,0 +1,602 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/swap.h>
> > +#include <linux/rcupdate.h>
> > +#include <linux/memcontrol.h>
> > +#include <linux/plist.h>
> > +#include <linux/sysfs.h>
> > +#include <linux/sort.h>
> > +
> > +#include "swap_tier.h"
> > +
> > +/*
> > + * struct swap_tier - Structure representing a swap tier.
> > + *
> > + * @name:              Name of the swap_tier.
> > + * @prio_st:           Starting value of priority.
> > + * @prio_end:          Ending value of priority.
> > + * @list:              Linked list of active tiers.
> > + * @inactive_list:     Linked list of inactive tiers.
> > + * @kref:              Reference count (held by swap device and memory cgroup).
> > + */
> > +static struct swap_tier {
> > +       char name[MAX_TIERNAME];
> > +       short prio_st;
> > +       short prio_end;
> 
> I see a lot of complexity of the code come from this priority range.
> Having both start and end.
> We should be able to just keep just one of the start and end,  e.g.
> high end of the priority, then keep all tier in a sorted list or
> array. Then use the next tier's priority to indicate the other end of
> the current tier.

After checking my code, I decide to remove st or end.

> > +       union {
> > +               struct plist_node list;
> > +               struct list_head inactive_list;
> > +       };
> 
> Is this the list of swapfiles?
> Why union, how does it indicate which field of the union is valid?

It is swap_tier itself. The 'list' maintains active tiers, and
'inactive_list' maintains inactive tiers. One tier exists on either
'list' or 'inactive_list'. The code ensures that a tier must be on one
of them.

> > +
> > +/* swap_tiers initialization */
> > +void swap_tiers_init(void)
> > +{
> > +       struct swap_tier *tier;
> > +       int idx;
> > +
> > +       BUILD_BUG_ON(BITS_PER_TYPE(int) < MAX_SWAPTIER * 2);
> > +
> > +       for_each_tier(tier, idx) {
> > +               if (idx < SWAP_TIER_RESERVED_CNT) {
> > +                       /* for display fisrt */
> > +                       plist_node_init(&tier->list, -SHRT_MAX);
> > +                       plist_add(&tier->list, &swap_tier_active_list);
> > +                       kref_init(&tier->ref);
> > +               } else {
> > +                       INIT_LIST_HEAD(&tier->inactive_list);
> > +                       list_add_tail(&tier->inactive_list, &swap_tier_inactive_list);
> > +               }
> > +       }
> > +
> > +       strscpy(swap_tiers[SWAP_TIER_DEFAULT].name, DEFAULT_TIER_NAME);
> 
> The default tier is not a real tier. It shouldn't show up in the
> swap_tiers array.
> The default tier is only a wide cast for memory.swap.tiers to select
> tiers to turn on/off swap tiers. It is a wide cast pattern, not an
> actual tier.

Yeah, as I commented in the previous mail, I will change it to a
logical concept.

> > +void swap_tiers_show_memcg(struct seq_file *m, struct mem_cgroup *memcg)
> > +{
> > +       spin_lock(&swap_tier_lock);
> > +       if (memcg->tiers_onoff)
> > +               swap_tier_show_mask(m, memcg->tiers_onoff);
> > +       else
> > +               seq_puts(m, "\n");
> > +       swap_tier_show_mask(m, swap_tier_collect_mask(memcg));
> > +       spin_unlock(&swap_tier_lock);
> > +}
> > +
> > +void swap_tiers_assign(struct swap_info_struct *swp)
> > +{
> > +       struct swap_tier *tier;
> > +
> > +       spin_lock(&swap_tier_lock);
> > +       swp->tier_idx = NULL_TIER;
> > +
> > +       for_each_active_tier(tier) {
> > +               if (swap_tier_is_default(tier))
> > +                       continue;
> > +               if (swap_tier_prio_in_range(tier, swp->prio)) {
> > +                       swp->tier_idx = TIER_IDX(tier);
> > +                       swap_tier_get(tier);
> > +                       break;
> > +               }
> > +       }
> > +       spin_unlock(&swap_tier_lock);
> > +}
> > +
> > +void swap_tiers_release(struct swap_info_struct *swp)
> > +{
> > +       spin_lock(&swap_tier_lock);
> > +       if (swp->tier_idx != NULL_TIER)
> > +               swap_tier_put(&swap_tiers[swp->tier_idx]);
> > +       spin_unlock(&swap_tier_lock);
> > +}
> > +
> > +/* not incremental, but reset. */
> > +int swap_tiers_get_mask(struct tiers_desc *desc, int nr, struct mem_cgroup *memcg)
> 
> Who is using this function? I can't find the user of this function in
> this patch.
> Please introduce this function together with the patch that uses it.
> Don't introduce a function without a user.

swapoff calls swap_tiers_release. I must improve the readability of my
RFC patch series.

> 
> > +{
> > +       struct swap_tier *tier;
> > +       int ret = 0;
> > +       int tiers_mask = 0;
> > +       int tiers_onoff = 0;
> > +       int cnt = 0;
> > +
> > +       for (int i = 0; i < nr; i++) {
> > +               for (int j = i+1; j < nr; j++) {
> > +                       if (!strcmp(desc[i].name, desc[j].name))
> 
> These two nested for loops look suspicious. Again because I don't see

For assuring, unique tier name input.
I will think of making simple.

> the caller, I can't reason what it is doing here.

When a swap tier is designated by the memcg sys interface, it is
called. I will introduce this logic together with the caller
implementation.

Best Regards,
Youngjun Park

