Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C40F3D5F4
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 06:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028A16B008C; Sun, 29 Mar 2026 02:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C006B0095; Sun, 29 Mar 2026 02:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A906B0096; Sun, 29 Mar 2026 02:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE1EC6B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 02:48:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 027A058AC2
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 06:48:04 +0000 (UTC)
X-FDA: 84598170930.18.129769D
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 275F54000F
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 06:48:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OCCYLqnT;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774766883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQqiwkS82VX9Ubj17wq6gcqrqBCzX78+3UD7c/Wp8mc=;
	b=W/+ZSxUC3zgTFPLYDNnUpoIVmEg7LjteKx+MclEYOt46vQe8IZHtH47p1Ssn1m6Sbd7QBz
	N4KEa19mSNeaqxSlFKpE3UWqVOUz6q6wekgJuhuGVyNhnz196DwshP+eqqe6bRMNWxHt0V
	hh6qPbxehn3oSnjWOazodvkJaqGCjPE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OCCYLqnT;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774766883; a=rsa-sha256;
	cv=none;
	b=yT9iRsXanxX1G4L/qVdDSBnhSiUhsPMSwvpLw+28iVMK0oEIo04xmLw3nzMCNRuSrCo1Vp
	vm6AGBydAV5lJ/1WDOUQnVafwz6QzIRmuQ8opVFdvqSZMuHiDEDe/2D85fJYwQ67ld8Msh
	X+haGJ1t/wmqzHAU/Rx0Dv4XfL4oIvc=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cd80f56b27so336901685a.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 23:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774766882; x=1775371682; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gQqiwkS82VX9Ubj17wq6gcqrqBCzX78+3UD7c/Wp8mc=;
        b=OCCYLqnTGLC8EczVSY1uJ3+4hXdc6aFtyc0KVaadXcFtCtAh0+y443on9bsZCxv2e9
         mk07dmJZFWMy5NSCZGugh+tOqkG3Xo/J7X9imYJFeW3sh44ew9CGGDfX9WJp2QVR8Qww
         3dvQXR6DsVC/PgMMwmAFNpDUXYWp9XpM1Tq9YehZt/4/OsPL1Ls+MZiAUeAxwdKZUfub
         k4WH17SMr/3HTUtILkEMDD3pHupG1jcZpxyitNN55yp1c9Au19VPOQ4lsZ6clFnXNH/D
         2l4NKvM74K+7JmbybPCB746K7Cq8S+ILk0FT7C8FSSi7CmEk36jKQPCfutGHQDgUt7O+
         5NZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774766882; x=1775371682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gQqiwkS82VX9Ubj17wq6gcqrqBCzX78+3UD7c/Wp8mc=;
        b=LHvAHmmYIjGbdaRGrn0+VE7di0ntKxCBZnppowZqjGo75TxeGm1LE18c7RJW4ScAzZ
         GCzaJjY1IJaxHrQBxlIrErYpCMT8KdT4eI6wqEzSnyyYwFnrhovKTfDF0ZGD5bTOo/IS
         pTa23zmKFQmfoe2v++Ck3KO3pcGXq4gO1wc1TEp0zec02ynZS4v84Fe3rb8cL3IPCgLy
         PxjO2+KqDnPNZieqccCK1F6024GZ95m6SfSvmOU2PF0nnEet/H/ZTCZ1ssXHZCBxzc1J
         fyQN2sR4GXbnYh8ZiRP+lrVGgDspr6IfpR0oM8DNgzri9F+DbZTjO3LuvlVPEC9uAwCg
         nnCg==
X-Gm-Message-State: AOJu0YxteZQqkSzDBD2UVO1bedv7jm6xhVaQXpaLFb53hK82Socb/f5p
	BEtIiWkf/r2Jaar7tWn/sxGCesqkRCcXbS8+Adyn3huLlFbN3dEYGuWvG3cVJ3AHVHGd1w==
X-Gm-Gg: ATEYQzwOBj8R2ken8OQeHI3LkpUk+jgJfHXQCnkbQXIA8Yo2NNqD56zN/uzpwPh+qLK
	Lq3IQMQxAOXO+e5Uo7CMWQceFQXVwsNZLdkdneVXcdhBMPLDtq0IUbNQd6Gnk8AFZKu94RZapa5
	PWjAA4HGlHve3gQtmghqG6+sRDh7tu+GCffo7Fg+/bXHOCaTX3pgN/J15StD9lGDi4tEghN7mlw
	8lofsRPW1zwMaSVuXcHZY1bE70nTcjV3pEFT0pdS/XnR3NuY7QiIe3+xOMem1A8ycZ9yYo5zwRC
	Zdv3/DiHfLAvRbY61KcKhz1KiOGa+FXaV9NOKbE6rb2FnHs8XPw9mKIvR6GL2W27VPc/L44uN3H
	gBFZ2wOfo5KdGa4A6NWk8F8ZSUF+E8QpiVaa0RQj2dSv9TiuifG9kW91yWicVRaFvO4loYzPBhL
	rb/IteDGXCofpJp5zG4B+FXkZoh5XPN4A3VrlfaJn/Bz9NOlKQowrj44PDgxU=
X-Received: by 2002:a05:620a:40d5:b0:8cd:8a55:510d with SMTP id af79cd13be357-8d01c7a368bmr1071941785a.48.1774766881712;
        Sat, 28 Mar 2026 23:48:01 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d02807b0e6sm307384485a.39.2026.03.28.23.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 23:48:00 -0700 (PDT)
Date: Sun, 29 Mar 2026 14:47:50 +0800
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <kasong@tencent.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 04/12] mm/mglru: restructure the reclaim loop
Message-ID: <aciejkdIHyXPNS9Y@KASONG-MC4>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-4-b53a3678513c@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329-mglru-reclaim-v2-4-b53a3678513c@tencent.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 275F54000F
X-Stat-Signature: 3to895yd4cg6so4cgh6b8qe9s6bgoctn
X-Rspamd-Server: rspam06
X-HE-Tag: 1774766882-929007
X-HE-Meta: U2FsdGVkX1+WtH6K4d1hHdp7THYKH6w12d8gzall6wSZtN/5xXijjF7SAJEfHPFyc9ja1/54NvnSfdBU1WDFGeepoCkt0kvOd/e+78VySBNYdGcQrhME118z2JmjLs7PJOUntO7K8YiXM1gh0bLbpHqoDPW6JbJPD1TLIO/Nt8h3HMPCG8n2O162qPErWF1zyA1n10i5hqeprZcbbk5zw6WNUyPVIETZ85MjSScfaoUBeCbnE71mhoI7v2Fwf9Wad7acsF333rr2QhwUq7t3dRn9zL3IIADWqGkBLJDATliqRgXMC1/dW8crT/9erBKm8xwDHG7Ls9my8j/A4cJO6bVtXI3hRP6VK72G1g6dkGIVPx9njGLbVuXzxhrqm6Ksu26yCSKKycPhCXeax6DkYGx+hpI6Cov4TTOkICjv+jaKH5HNtV2igw+RpOlepusd8dkSuMYWXoVsINRHgH25nmCudTFlIqa7eIIcDn+Z6udmysrknVB6L6EZgdtlMZ8xl2rfJzfm1lEd5tCXpbYnPgJFjDQ+tr7myEuSv2xP/5JmLGDBOFNqc2QxLTp/JjI0EJFhXOxKo4t+p6j9RQGhlHB3kAfzsuthp9V4aHNHniGzv80CrhUfI/saNIGggRfpIHU2hV2J6M8T4nLwvLO5+O18nl/JrgVY2+9gRfzWkz4lLH1VtBSh6La3D9AFxouqgnDw2TbyUWB9LD52xSTKs3NBu6CBTc83MDY4DP/silDS5mh3ZBGArrfqYXUiLfFnf98Oh9pYu5H37UZk+58O29ADWUbW44NC8iPP+QbZqJ1RAcZj2simWB6JF04xMD5RpRgV96ABCPIGvfv6/ffNKA7/dqF0EbkG0D68tV/28mEsuOEhS+aosJKBtVSO+MwudyS+cwfIpv8xErKVqrL6gFrIlqIiNlosUjc1CJLpBxUdFxPlJDMuWdBzu69auK4iUyn7QIetb+ekZVYcePE
 tDvFpkhF
 gCEI9YHxcZLuHNKKZh8XVtvkjssRsz+07CPUWWzUt/CPbZiO5WSM9RK5DuPPQT3CRAmpyDwOzmckz0zohl454S8zqPv87AN6/NPc3nt6pnnWxFAPH1IklzD4ESb67lQ/y3NIiS+hjf2Ee1aVO5vkxpT/TD4T9W1RFblQFDWI2pewDAgfwuX90D27KD3lDs4EoMs1qinBQHXRMS4q2Su7n4CtgbXuRLK83BUN3K4ghRkAT8rLvqWnyBMnoI88uVHDvtnhrYIQYSrgWrPLfdjhRMxR80Io5BavCSINB6McK44JqL39xoPTgvfb/1hfUI8Ub/8qI6T9SJqLHYOAHLbL7oN11X3vAwMkvXPxhlXbWd+6UbvkRvcXcabbIqXZ7Nb9qjpHFbdd9PzaKc5UnRjRookbj4fXJeO/vmTpE2+6OpxeHO+YrHuX6XvmHjHPMFhPFqJllc19e4ymLRps2BWO+z1YohbngQsdQyJLzRFbdP0nZaYQH5WVwIIC379I/t0U0ET+OjR74bH2WtT6hVOrrjyaUD4IeXeuAHITcGg0apHKTV9KAi9kP47ryvj0AnighZgbVO0CKukrmwjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

So sashiko provided some review, I'll post it below:

https://sashiko.dev/#/patchset/20260329-mglru-reclaim-v2-0-b53a3678513c%40tencent.com?patch=12986

> From sashiko:
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4913,49 +4913,40 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >  }
> >  
> >  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
> > -			     int swappiness, unsigned long *nr_to_scan)
> > +			     struct scan_control *sc, int swappiness)
> >  {
> >  	DEFINE_MIN_SEQ(lruvec);
> >  
> > -	*nr_to_scan = 0;
> >  	/* have to run aging, since eviction is not possible anymore */
> >  	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
> >  		return true;
> >  
> > -	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
> > +	/* try to get away with not aging at the default priority */
> > +	if (sc->priority == DEF_PRIORITY)
> > +		return false;
> 
> Is this a regression that unconditionally forces aging even at DEF_PRIORITY?
> In the original code, if eviction wasn't possible, it set need_aging to
> true, but the subsequent check against DEF_PRIORITY could still bypass aging
> and allow MGLRU to skip memcgs without cold pages.
> With the new logic, the mandatory aging check precedes the DEF_PRIORITY
> check, returning true immediately. Will this cause try_to_shrink_lruvec()
> to inappropriately force hot pages into older generations on the gentlest
> reclaim pass instead of trying other memcgs first?

Right, this part is a bit confusing indeed, I tried to split it
into two patches but it seem could be more messy that way.

This is more of an intentional change. When eviction is not possible
(fewer than MIN_NR_GENS generations), aging is the only way to make
progress. The old code always skip aging at DEF_PRIORITY.

For single cgroup setup, this is not helpful in anyway, it waste a
reclaim iteration only to come back at a higher priority and age
then. And it causes over reclaim of slab.

For multi cgroup setup, it may seems reasonable that defer the aging
and reclaim other cgroup a good idea, but we will have to proceed
with aging anyway, potentially when all cgroups are run out of
gens, causing a larger jitter, and break reclaim balance.
And the escalated priority also may cause over reclaim.

And right now we still have 3 gens as the buffer.

Testing the multi cgroup setup using JaveScript workload in the
cover letter showed that after this series, multi cgroup reclaim
balance and latency are good, the total throughput seems better.

Testing the reclaim balance of cgroup tree (see below) also
seems better.

I think to avoid the latency of aging, we really need async
aging, not deferred aging. Async aging might be easier to be
integrated here now after this series.

Could add some word on that in the commit message.

> From sashiko:
>
> > -static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
> > +static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
> > +			   struct mem_cgroup *memcg, int swappiness)
> >  {
> > -	bool need_aging;
> >  	unsigned long nr_to_scan;
> > -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> > -	DEFINE_MAX_SEQ(lruvec);
> > -
> > -	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
> > -		return -1;
> > -
> > -	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
> >  
> > +	nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
> >  	/* try to scrape all its memory if this memcg was deleted */
> > -	if (nr_to_scan && !mem_cgroup_online(memcg))
> > +	if (!mem_cgroup_online(memcg))
> >  		return nr_to_scan;
>
> Will this cause a regression resulting in a permanent memory leak for
> offline memcgs that have zero evictable folios?
> If an offline memcg has all its folios in the unevictable youngest
> generation, lruvec_evictable_size() returns 0. The early return here
> then evaluates to 0.
> When try_to_shrink_lruvec() receives 0, its while (nr_to_scan > 0) loop
> is completely bypassed. Since the aging logic was moved inside that loop,
> the offline memcg is never aged, meaning its folios will remain in the
> unevictable youngest generation indefinitely.

Seems hallucination. lruvec_evictable_size returns evictable
folios across gen, not excluding the youngest one since aging
may make then evictable. Perhaps we can add some comment for this,
if it confuses AI, it may confuse human too.

And aging is not out of the loop, it's just moved to a different
place helper.

> From sashiko:
> >
> >  	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
> >  
> > -	/* try to get away with not aging at the default priority */
> > -	if (!need_aging || sc->priority == DEF_PRIORITY)
> > -		return nr_to_scan >> sc->priority;
> > -
> > -	/* stop scanning this lruvec as it's low on cold folios */
> > -	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
> > +	/*
> > +	 * Always respect scan priority, minimally target
> > +	 * SWAP_CLUSTER_MAX pages to keep reclaim moving forwards.
> > +	 */
> > +	nr_to_scan >>= sc->priority;
> > +	return max(nr_to_scan, SWAP_CLUSTER_MAX);
> >  }
>
> Does this regression break proportional reclaim and memory protection
> semantics for small memcgs by forcing a minimum scan size?

Actually this change was inspired by sashiko's review for V1:

https://sashiko.dev/#/patchset/20260318-mglru-reclaim-v1-0-2c46f9eb0508%40tencent.com?patch=2909

Without this, for cgroups smaller than 16M, def priority scan will just
do nothing. It's still OK but to make it more efficient I added a
minimal batch. But now think again, it better be:

if (!nr_to_scan)
	nr_to_scan = min(lruvec_evictable_size, SWAP_CLUSTER_MAX);

Using max() here could get very small cgroups over reclaimed.
I did test V2 using test_memcg_min suggested by af827e090489:

Before:
Proportional reclaim results:
  c[0]     actual=  29069312 (27M)  ideal=  30408704 (29M)  err=4.4%
  c[1]     actual=  23257088 (22M)  ideal=  22020096 (21M)  err=5.6%
  c[2]     actual=   1552384 (1M)  (expected ~0)
  c[3]     actual=         0 (0M)  (expected =0)

After:
Proportional reclaim results:
  c[0]     actual=  31391744 (29M)  ideal=  30408704 (29M)  err=3.2%
  c[1]     actual=  21028864 (20M)  ideal=  22020096 (21M)  err=4.5%
  c[2]     actual=   1515520 (1M)  (expected ~0)
  c[3]     actual=         0 (0M)  (expected =0)

In both case the result is somehow not very stable, I run the test
7 times using the medium stable result, after this series it seems
sometimes the result is even better but likely just noisy. And
didn't see a regression.

The 32 folios minimal batch seems already small enough for
typical usage, but min(evictable_size, SWAP_CLUSTER_MAX) is definitely
better. Will send a V3 to update this.

I think non of the benchmark or test would be effected by this.

