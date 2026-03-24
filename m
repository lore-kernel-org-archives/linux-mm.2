Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B021F54AD0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02EB06B008C; Tue, 24 Mar 2026 11:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007286B0092; Tue, 24 Mar 2026 11:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F186B0093; Tue, 24 Mar 2026 11:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D59576B008C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:44:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 863D4139F7C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:44:19 +0000 (UTC)
X-FDA: 84581378238.09.D7B82C3
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 81DC240014
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:44:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bf5p8rbn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774367057; a=rsa-sha256;
	cv=none;
	b=BmfiLuuFtyr5vUc5wD8ePXqQhmwpKtannZcqSN+jU0hyxO8iaHW4laq7vIUs0vrAo2Jj7M
	eJxFObu1pt5ey6J34nULWFH5HEU4gjCWCfXJUf+gjk9Yp1E2YlmM6qbJd3zJ6M2vM46sRH
	adLq0oFLF8LbiLKl6XwKTm20T1T6Wqo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bf5p8rbn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774367057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/z+GYpxsMEozZLGaH6wDzqozrpwK3g4rVLvamGwvHc=;
	b=8kYIsZu6W3/+4id73b1MLofGfcIDIcXmbD4Yc/IcHiGSBhIk/cCDB2VRvP6BXmOMaPLZtD
	UbGvW9LN5cJJnjMgKERaw9w/cVq2OLCOLNfPV6EE+cYg46wmlIxi8YYwEsAMDQMZ/U5fud
	o2GLfIPmY/5HmCgbpdyPx7hpuECSnxY=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d7f592b8beso3398601a34.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774367056; x=1774971856; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/z+GYpxsMEozZLGaH6wDzqozrpwK3g4rVLvamGwvHc=;
        b=bf5p8rbnCMkcxIIzowwdtTv0Ki66OzVVyV1NWgL7kKx5l42UDuFLJtWtEw69JwZLh5
         wm9XzRwmFr46FSL9FwbGg8lWMBjzu/zdI3GapByUZuRGxYBf5mpqNQyIJDx2glBXFuIQ
         8E/PVtySx6A3loK/zniGUtT1xvD/LEiu6iRvpPLeIKxdJHLgcLMRcK28ulha81EZa22h
         SymjEK4Mk3TlPu+2tp02LZBvBghb/lgdK+wEb2jF60QJrGkDhO8htlLuo3M83DAcYE4H
         4XuJuDr3/W1LWOC2dXiXi8cr/43T+SqsFQQYcXiyD1YDmqvtNQzUDUL2n0NEa+2hgG6C
         vUng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774367056; x=1774971856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H/z+GYpxsMEozZLGaH6wDzqozrpwK3g4rVLvamGwvHc=;
        b=hKzYYxz5JJu2cE+I5/EE1ooXqz4+n54Aj4iZSbwTaljQFdUO+ncjCjFeS/9/eh9l5d
         KCeNy6P/gFiAb0bkyoEIhPDocdNo/Cujie9CoWmgyjW9NlrJwEvQpUrI/f4xNU0eJxd8
         ugenNWoYDF/o2ujLgqzkPLgNU8LsTkBhcaT/EpWMM+/MPFYCXg0bnOdnvKI/B5feGYkS
         SEndnFBn40lnxjxmY0twB6nmKMzGPJE6duHggeOSSRwwlZchpVKr8xY7gHKY6FZ4UiZC
         FFCfnVLE4n/7Efj7F6i17OvlgifL1p7dwSd1pbLu9Oh6OZDDQHka1HtaztgC6UixHPQp
         33TA==
X-Forwarded-Encrypted: i=1; AJvYcCXLmRY4RfzelSI7EWghSNsm6wtxaJEWqJOk0nb2UnJgIsr2Gsajrl4jW1ruMgemkVW2TIoqDXkP1g==@kvack.org
X-Gm-Message-State: AOJu0YyRMZleqdD7cLlqRaGjBZmrU50X/zFsvngqByOHnfXHVRzImiBE
	xlT9dt+ptmV8IQ9r9QziFNMCpRr2SkED0izbiqXUt3qup9Z39uQGfNOF
X-Gm-Gg: ATEYQzzECO82Xbz+5vzg1Af2SUC4TqontBmlQopjWN43NwMqUh8Xvr2IKIKPUL6kOq0
	bSjiwyZuAP1H511X56TkJDixYkiFLsT9GnXI1FMd8m/SH9VL0jSyY+wg+N2DaKdGf2qvL67e2bb
	Lc4yHQChN8gitv6YaCafAkrHY2uNxjV/EXJiPVDR1nZZP5DVGjfrRFauYFXw5NjH7x1ojfjKgSp
	N9dXx0srBOta0HKG48DL7Oq8eOgNrh8kHXB8UBzFIbwbX/6RSRbpGhsMfRiJj7Jzv4zM74biOfZ
	1Gbt4sB9xV9c5BWUIHhLAQFcecx9UsZqkEQdA0ni9Hyp7KnS7G0HCx/iLIBh2q+jAgsCkWgYGKX
	G0YMabVil7zuOLd5XKybI8cIglZTF7jsmjBgUK6cirTFjtsGWSZUljG6UzNlQETJh1FznWs1oGW
	Plxvj6BGC6/+7Zgluaj/aoig==
X-Received: by 2002:a05:6830:43aa:b0:7d7:d673:c1c with SMTP id 46e09a7af769-7d7eb011282mr10512912a34.33.1774367056385;
        Tue, 24 Mar 2026 08:44:16 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7eadd17d9sm13472356a34.14.2026.03.24.08.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 08:44:15 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC PATCH 6/6] mm/memcontrol: Make memory.high tier-aware
Date: Tue, 24 Mar 2026 08:44:12 -0700
Message-ID: <20260324154414.195150-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <90749965-ebc8-43b2-92e3-baec5f6e3de0@linux.ibm.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 81DC240014
X-Stat-Signature: kqynwn3q3wek5opttodc1q8sqfm9sqqh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774367057-293998
X-HE-Meta: U2FsdGVkX1/+58PpkDvV7wIsblIflX0FppaxrDREG+WM51HcvNAVpB9m0/mCNpCzUA0PMvv9M92i7Z6nz702SC5z5owreL6ZKmjf7xl7OyCHL4qFLmMeqi2QgLtuOJH+CKlLc/LZx8A2UychmNWJGT5PfjCl55jaJXSvtfUYrnn9E1rX9/bG20JHxBPwZpz77MniP6al+IJ2vBoomfZ4cMuo7uNZDF9+iy3Yf/Js5Fe8KIndAw6K1zIai6ovd6QslOY9qHIN54PiA1qyCdekyKppUVajBL4dF5LuJ9wHQfb9dyBnzHRp1j87wElJb7FT6MAAcwV3RKdc/wkaTznmk9wSu2liKqet7WV/IVZugvwbeiM2G4925GuiNaLPNc2ePbH/JfXLnZnZUKpMM1cdkPzQqIn6GrmOaZMuF8yeGddKHcLN3Ho7iHmt++oV/slom9i/f/KfjGSF+755r71tqyAKXSCgxP7FAt2XXxsGfJ5TnizngAYZ5hd5pD6yLba9LeMI148iyK5JlxIVmJF9MpUq8Ka/fro9bhH/5iJK6NaOlmaNgi4oTuaVTsdTIjOuu/L/7Vhg8NQScM9LjAEnWc9QDErQ6jgc1iXUZwQuAxmMNckQEf+/aOFFWLbaGcy/jkkSiNEiu5/bVarejOCHPdqMD+gCtWRhK5TjOFWxCpjK401txecwGQEXZJPkkHIL3HXFdSU9FvT8MgIdOdMpScwuaEf1gAurE7Sy3L+vMikwSCpe5SApn+rXVyyqZgr4asB1F997jELK11iji3mQHjYuJ/ZU3K32eHKAfAZKKZttXpmvqJGZXhIMwXDKaHARluJevVYZoR1QE80OAnqjUuG4KdqplSC3lq8TLB8r7wGs2GZkyv3U5Ou6RyMZsEkCNRRRSLrQHHMFXb/hyhKJZ56AsnJ8tLMnGraM6juyokkTDcyFkpQ+HgDAZUt0ISzjQJ+IQyiBVNjkV+7apCb
 9736blx6
 M7eDWF1UKym7JyvWmiTy1arWkDzu116l7tEjI3aa6Bf7XEG2NYHFuRmYDp+P+cvA7WwCCTlGuBZ+jvC7rAGjnMiHt5DSnZ3Xz02YdGGWvzetLAKMzjqLazzcBq2c5g9xar5Q3ug3mokPCCrgcexrEz6y2fXr50+ouLaz263A/IHhFiXluFPzTWevm91/gdHkYm/F40VNdeS30fQ5RuHL79vIf91Qr0xh0JBROdN1/nihLCdj+rJZ6pZoXmrZjXEtbDKC/bgxHzUtH9Qc51tJwOpYtg4KoUP0+mjfWrzrX1iQUYIRfCkJz4Z3xp9KanG+dRf85YVjEs+yVUUxogbbIkXk6hmztDHiUOVzrX+f6lgLgpHKZGkq6Dok7Eyo6lzOxNBq0eN2/n/b7X2g3CdsgGI5g0dlLxN2EHzi50h05JogMEuFQtbmly3uP/RMTT3EZkcZ8Jlm/okmKqKHyBXFXqARdtUqUl/LhR1g+LGUzuM8272lM+1p81uhbECmh6zbh4L1JeVokyrveEQ+TrmTF58fqiFu7oM80sYcITqhA6Na3I3KfgnS3p+nvVlu4bMwAEBYfl28ItOw/56fiqnkmxpSSCa67FFDNFRAM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 16:21:06 +0530 Donet Tom <donettom@linux.ibm.com> wrote:

> 
> On 2/24/26 4:08 AM, Joshua Hahn wrote:
> > On machines serving multiple workloads whose memory is isolated via the
> > memory cgroup controller, it is currently impossible to enforce a fair
> > distribution of toptier memory among the workloads, as the only
> > enforcable limits have to do with total memory footprint, but not where
> > that memory resides.
> >
> > This makes ensuring a consistent and baseline performance difficult, as
> > each workload's performance is heavily impacted by workload-external
> > factors wuch as which other workloads are co-located in the same host,
> > and the order at which different workloads are started.
> >
> > Extend the existing memory.high protection to be tier-aware in the
> > charging and enforcement to limit toptier-hogging for workloads.
> >
> > Also, add a new nodemask parameter to try_to_free_mem_cgroup_pages,
> > which can be used to selectively reclaim from memory at the
> > memcg-tier interection of a cgroup.
> >
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >   include/linux/swap.h |  3 +-
> >   mm/memcontrol-v1.c   |  6 ++--
> >   mm/memcontrol.c      | 85 +++++++++++++++++++++++++++++++++++++-------
> >   mm/vmscan.c          | 11 +++---
> >   4 files changed, 84 insertions(+), 21 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 0effe3cc50f5..c6037ac7bf6e 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -368,7 +368,8 @@ extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >   						  unsigned long nr_pages,
> >   						  gfp_t gfp_mask,
> >   						  unsigned int reclaim_options,
> > -						  int *swappiness);
> > +						  int *swappiness,
> > +						  nodemask_t *allowed);
> >   extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
> >   						gfp_t gfp_mask, bool noswap,
> >   						pg_data_t *pgdat,
> > diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> > index 0b39ba608109..29630c7f3567 100644
> > --- a/mm/memcontrol-v1.c
> > +++ b/mm/memcontrol-v1.c
> > @@ -1497,7 +1497,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
> >   		}
> >   
> >   		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> > -				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
> > +				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
> > +				NULL, NULL)) {
> >   			ret = -EBUSY;
> >   			break;
> >   		}
> > @@ -1529,7 +1530,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
> >   			return -EINTR;
> >   
> >   		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> > -						  MEMCG_RECLAIM_MAY_SWAP, NULL))
> > +						  MEMCG_RECLAIM_MAY_SWAP,
> > +						  NULL, NULL))
> >   			nr_retries--;
> >   	}
> >   
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 8aa7ae361a73..ebd4a1b73c51 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2184,18 +2184,30 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
> >   
> >   	do {
> >   		unsigned long pflags;
> > -
> > -		if (page_counter_read(&memcg->memory) <=
> > -		    READ_ONCE(memcg->memory.high))
> > +		nodemask_t toptier_nodes, *reclaim_nodes;
> > +		bool mem_high_ok, toptier_high_ok;
> > +
> > +		mt_get_toptier_nodemask(&toptier_nodes, NULL);
> > +		mem_high_ok = page_counter_read(&memcg->memory) <=
> > +			      READ_ONCE(memcg->memory.high);
> > +		toptier_high_ok = !(tier_aware_memcg_limits &&
> > +				    mem_cgroup_toptier_usage(memcg) >
> > +				    page_counter_toptier_high(&memcg->memory));
> > +		if (mem_high_ok && toptier_high_ok)
> >   			continue;
> >   
> > +		if (mem_high_ok && !toptier_high_ok)
> > +			reclaim_nodes = &toptier_nodes;
> > +		else
> > +			reclaim_nodes = NULL;
> 
> 
> IIUC The intent of this patch is to partition cgroup memory such that
> 0 → toptier_high is backed by higher-tier memory, and
> toptier_high → max is backed by lower-tier memory.
> 
> Based on this:
> 
> 1.If top-tier usage exceeds toptier_high, pages should be
>    demoted to the lower tier.
> 
> 2. If lower-tier usage exceeds (max - toptier_high), pages
>    should be swapped out.
> 
> 3. If total memory usage exceeds max, demotion should be
>    avoided and reclaim should directly swap out pages.
> 
> I think we are only handling case (1) in this patch. When
> mem_high_ok && !toptier_high_ok, we are reclaiming pages (demotion first)
> 
> However, if !mem_high_ok, the memcg reclaim path works as if
> there is no memory tiering  in cgroup. This can lead to more demotion
> and may eventually result in OOM.
> 
> Should we also handle cases (2) and (3) in this patch?

Hello Donet! I hope you are doing well.

For the second condition, should pages be swapped out? If a workload
is using 0 toptier memory (extreme case, let's say they haven't set
memory.low) then lower-tier should be able to use all the way up to
max memory.

Maybe you mean if lowtier_usage exceeds (max - toptier_usage) pages
should be swapped out? But if we rearrange this

                lowtier_usage >= max - toptier_usage
lowtier_usage + toptier_usage >= max
                  total_usage >= max

And this is just the memory.max check and is already handled by
existing reclaim semantics : -)

I think case 3 is a bit more nuanced. If we directly swap out from 
high tier and skip demotions, this is introducing a priority inversion
since memory in toptier should be hotter than memory in lowtier, so
we should prefer to swap out the colder memory in lowtier before
swapping out memory in toptier.

The idea was discussed at length at [1]. It also feels like an orthogonal
discussion since the behavior isn't related to toptier high or low
behaviors.

Please let me know what you think. Thank you, I hope you have a great day!
Joshua

[1] https://lore.kernel.org/linux-mm/20260317230720.990329-3-bingjiao@google.com/

