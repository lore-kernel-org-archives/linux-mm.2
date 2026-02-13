Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F77BEEA849
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 02:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09EB6B0005; Thu, 12 Feb 2026 21:18:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8CCF6B0089; Thu, 12 Feb 2026 21:18:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8EAA6B008A; Thu, 12 Feb 2026 21:18:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CAE1F6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:18:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C330B7E35
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:18:12 +0000 (UTC)
X-FDA: 84437823624.01.67F04CC
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5AFEF180010
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:18:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770949091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pk6RByYlA2+Y84x9+38P8PHRea+gAfTyIP2QkGx9dwM=;
	b=OF8oykSY6FBZjvVrjouhsZocECJNRAnUvJH97B6hqirnekLDxRltZiAjK92HXkoSdBPoAy
	a3Am9vjP8XxvrcFNNDT8d3KvuzmXH7gaTo0NCEUHyVg7P+JnkjLmiocJtWo0uORTQrLB9s
	vO+zlFemFGfOTgJa3sa616bWh4hwRgg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770949091; a=rsa-sha256;
	cv=none;
	b=kKeXKTUpqkuJO0TSVA84liqcWVHKz0uDrWZ4A/8PxJmCFdTRVPIv/0AEmxrejaiEdxVEu1
	Ikgv4z33WD+XX1rGQCRG9WlCa+116uGmDyq7HZrhbhmYTOvQlUwGk/5pHia/fuudyDwdyD
	HXp3E8pq35dIcSPmJQMMcaU4OjCMXt8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 13 Feb 2026 11:18:06 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 13 Feb 2026 11:18:05 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com,
	taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 v2 1/5] mm: swap: introduce swap tier
 infrastructure
Message-ID: <aY6J3Yky6yfcIf36@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <20260126065242.1221862-2-youngjun.park@lge.com>
 <CACePvbVML6ZNJBWU9YSUCWwrbGd2eXMcsWxs6yFssfyBoEk5Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbVML6ZNJBWU9YSUCWwrbGd2eXMcsWxs6yFssfyBoEk5Uw@mail.gmail.com>
X-Rspamd-Queue-Id: 5AFEF180010
X-Stat-Signature: wp8jsmfszfw5fdpirg3egadge7t6u55k
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770949088-875311
X-HE-Meta: U2FsdGVkX18ieRDAovuvvu29NR9RNLR6DSgBRAWeE8/2FWnB8nkZx57kKQn0yJNItei7gPs6hyOuqyZxfCs8mu2dDtLRPkYRuW4BKmb5W6vIcybzD99m2v0LUN5I7UguZNwjiPKHsR+PgnQe33w3/udzIs3fo+8NzhL9qN32H12h2UIjB7sHtolQQKkitxUTDe1cn2p4SbRXBuLNhIAQWlBSoLV4RhpTZPubpkfKvOwO8kP/GvNsN7IPoa95cnR8IxUt8qhLzlDIRE1ARE7M6bf70hJ27671+wcarAdbeJf0c7YC2uiyYwkQEBfVJ8OsnpraL0Gu8vdh+6egqVXp/MeXeqDczHA0vQOGhbjpt3xwigRig651ay4vSQmjCkzbbeK0Td+svXKnoT5v0IBhr4yNYe7iu7jw1JKH7a6xhYmwx1hGAIJAwBP3NNgSoUp3w0+0d1nT7YW/qmQrN4liJ9N5WSfE2xjETLzA3HANvbnGm3JoMdy/t3SKSTUxkbNxd3w35VjWd5n/SMOxydA/bcwSun1jYr+YdRXvicqEbx2yZF01zUwMTjGFZmpQWZOD/HatgpEvAkJbOQ3k2ESsqdEgCaBuVvzYd+mNJzadBprJfefVX4r9x+ypLlDlvR4O/PUiFU+0sdP3B88thimHTqhQZyKVecK0YSBetmm9UhGRfJeD4nZRbHdpwhUonY7VI7VX3asSB45SesugPrf8gLh4laI6fOvu01eQZ9go3jZcfuA5xcxUBJfCV8HcYqSP2f/vkTJf7jYMoamPXPlI9kRLGAfYrfwYE4GTY/DdT2T+ehIMnaw9/xI3RgEt8NrFfLlQKMjVJZ3e5dlTDDpqRoA9T88uXSp+iZxRcj8wZs7leMIXiZ6UWEHurU35FqABGkrehWdDC4om3kbN/YOaRmAsB/KecrWR4pbV7kq0HnNSL+Pq4rLoUROJoG015PwS33/enIVzzbbo9TeCq34
 X6RP0ZYV
 dEfWvRlq8EfoYX3CRVgRJQZWU+k+nX30e7tutEusOFdaqm4VWUGufsUdsbNPbwuniVYGF8wuQLkihC81EQsSmqzYMkgN8dr+C+WG2AqDhxWYgWazCW1WgA3LW5GldO3rvA/+POATU2p39P8RiVjaDuDcWV14LOgHfbvY3fNxdgSqUS6djQLq2iRfPXIP5CF/dDZQiK0f3JHTiZo2yYoEuQRlWJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 01:07:45AM -0800, Chris Li wrote:
> > +
> > +       spin_lock(&swap_lock);
> > +       spin_lock(&swap_tier_lock);
> > +
> > +       p = tmp;
> > +       swap_tiers_save(ctx);
> > +
> > +       while (!ret && (token = strsep(&p, ", \t\n")) != NULL) {
> > +               if (!*token)
> > +                       continue;
> > +
> > +               if (token[0] == '-') {
> > +                       ret = swap_tiers_remove(token + 1);
> > +               } else {
> > +
> > +                       name = strsep(&token, ":");
> > +                       if (!token || kstrtos16(token, 10, &prio)) {
> > +                               ret = -EINVAL;
> > +                               goto out;
> > +                       }
> > +
> > +                       if (name[0] == '+')
> > +                               ret = swap_tiers_add(name + 1, prio);
> > +                       else
> > +                               ret = swap_tiers_modify(name, prio);
> > +               }
> > +
> > +               if (ret)
> > +                       goto restore;
> > +       }
> 
> This function can use some simplification to make the indentation flater.

Agreed. I will refactor this to flatten the indentation.


> > +/*
> > + * struct swap_tier - structure representing a swap tier.
> > + *
> > + * @name: name of the swap_tier.
> > + * @prio: starting value of priority.
> > + * @list: linked list of tiers.
> > +*/
> > +static struct swap_tier {
> > +       char name[MAX_TIERNAME];
> > +       short prio;
> > +       struct list_head list;
> > +} swap_tiers[MAX_SWAPTIER];
> 
> We can have a CONFIG option for the MAX_SWAPTIER. I think the default
> should be a small number like 4.

Sounds good. I will add a CONFIG option for it and ensure it doesn't exceed
MAX_SWAPFILE.


> > +
> > +/*
> > + * XXX: Reverting individual operations becomes complex as the number of
> > + * operations grows. Instead, we save the original state beforehand and
> > + * fully restore it if any operation fails.
> > + */
> > +void swap_tiers_save(struct swap_tier_save_ctx ctx[])
> 
> I really hope we don't have to do the save and restore thing. Is there
> another design we can simplify this?

I have given this a lot of thought.

Since the current interface allows mixing add (+), remove (-), and modify
operations, we must either restore from a saved state or reverse the
successful individual operations upon failure.

I implemented both approaches and concluded that reversing individual
operations is error-prone. Also, it could be slow if there are many
operations.

Another approach could be using a "global clone tier" strategy.
(Because operation globally synchronized)

Therefore, I would like to propose restricting the interface to handle a
single operation at a time. What do you think?

> > @@ -76,7 +77,6 @@ atomic_long_t nr_swap_pages;
> >  EXPORT_SYMBOL_GPL(nr_swap_pages);
> >  /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
> >  long total_swap_pages;
> > -#define DEF_SWAP_PRIO  -1
> >  unsigned long swapfile_maximum_size;
> >  #ifdef CONFIG_MIGRATION
> >  bool swap_migration_ad_supported;
> > @@ -89,7 +89,7 @@ static const char Bad_offset[] = "Bad swap offset entry ";
> >   * all active swap_info_structs
> >   * protected with swap_lock, and ordered by priority.
> >   */
> > -static PLIST_HEAD(swap_active_head);
> > +PLIST_HEAD(swap_active_head);
> 
> One idea is to make each tier have swap_active_head. So different swap
> entry releases on different tiers don't need to be competing on the
> same swap_active_head.
> 
> That will require the swapfile don't jump to another tiers.
>
I agree. With the tier structure, we can limit contention to objects within
the same tier.

I also think swap_avail_list could be optimized in a similar way in the
future.

Youngjun

