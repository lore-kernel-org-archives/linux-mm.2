Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60514C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22B16B0098; Wed, 23 Sep 2026 09:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC3C6B009B; Wed, 23 Sep 2026 09:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE4C6B009D; Wed, 23 Sep 2026 09:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71B856B0098
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:56:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12A581207BC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:56:04 +0000 (UTC)
X-FDA: 85245175848.15.513DCEE
Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id DB345A0005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:56:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=nwKBWARd;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790171762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXC2nmOyFn84bCUp7WE6WyZCEN3lbi386wtQ70wZOAo=;
	b=10rxFQb4YgB2shhWjRiC6IRRT5ZrDBQ0ub51GixiO6sEfGO5fPPSCVRGqd2R4i/LuMhNfx
	oma7WGIU8fzrtep6ppcA4b8wV/bNCxTAqxWtr87+S8IPY8qVbgkYv1wDS7QUYazv8/xh81
	PrsX0Gnl5NQCRitxyp9msuBniKRHddc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790171762;
	b=OS0hZekR1VCRNlhWkW22pqOUjAYkVI4TcngFYdjrAS3wnndupQ2mcBv7a/I34lzcXoMkkk
	zQTP82IqBZvsW93X4R+u7uEPEXA7P0HhvTr03YvskWmGVQ030AFqJgMk4fFHj8zz2LLyXe
	5cUshzmhOWZeaVCG/W2ZMoWt35SB5zo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=nwKBWARd;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-91415b09bf9so2542526d6.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790171761; x=1790776561; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fXC2nmOyFn84bCUp7WE6WyZCEN3lbi386wtQ70wZOAo=;
        b=nwKBWARdDktRFHbQJ23XP6+Ovicuh5ABZJ3MgPhGjU943J8JGDI6zfuwz0y8Sqeuhf
         VLWDDG+4oRIhb3bfjURqokvevlhWD1uryoTS8U2GzCOwnSTwSnsBazJIz7WhPeRsGZmZ
         +zJSYuJHq9sqZNjWscSvAvFOb8uBdj0EVF7noLXI8LN0g0qHKyoXD5IoP6oQMEvAnlug
         YGx9oWVAS9AMyl0bNxLhdxobLAcy+zvaEJk7605mfOFulcWXGa8R4l/32BET3EcpRapu
         w6gMD8IgCOaJ0Z+LwafYs2fHQuWvnhiVbxKRZUMxvg9YqhTo+f08/wkWkxrjGhwN+PGt
         8J+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790171761; x=1790776561;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fXC2nmOyFn84bCUp7WE6WyZCEN3lbi386wtQ70wZOAo=;
        b=Zq0BAcRshf1hwwAlEQ29nA5EJbp2mwsmB3bN18GkwyKQAcQk2sYjTNQSDgADwDuDZn
         2kNKNPnV54u2KKWrnVfEFJRS5q/KVtdzELv6Se0jnPNithYVyW2ZUb1dhYhdbbH8BylW
         krhObFpQyJprR/chBcLJGECTdbs6528jkuy/kz6XX23No+t5hcbiM+dEk5BBU3EJPyHS
         OLm6nbrn+dBYviEsOxgOafJPM+Qx4LrPJKAOAQs5fSC7UPlRMGDMX6t1YXZHufo2+e4L
         tSe86ih3aRtoyiGcgWmVbULlWcYgj4+tEbYzhxNSR89GTaV0vYeDwckAPNPZGH7B3euk
         xELA==
X-Forwarded-Encrypted: i=1; AKwUvBxZTZaAJs5oZwPa35oPeiwNLz19ZWFchiHrSpC8vK2J8C0KM97ElInek+gpNctelbDXbe9ch4at7A==@kvack.org
X-Gm-Message-State: AFuF++k1WaJS6B7wA8CTGYiJvK/QAQ1OD2RrpYfhArv2PL/IRuXTlvq+
	E20D7PfubgGRQYr0sRekMjazFfH8YlU16SXtYbs2aGuNLgAz8H6KbM0Yq7xFbvQMyMo=
X-Gm-Gg: AYBFou23ZHM/m+65KJUBg86hbryj5QdszS4YuvrwhL1+IDhSiUxV4fffK7IlH/wmPr2
	WyTTmxM3I3kP8RWeVmkonUTq7VxfE/1zVJ4gRCPMzYl4ro5CJDHGW7p0xqxJvrvWiiGqPzHvbS5
	6XR6eyJq0qOWC1DtQ/2IPewTkyaV/3hsi38SxWbvefkoaGMGb1zG8Tp0evcqPwNMdzXMyqeaAnG
	v4AmlRv7sPaG2xOS0Kd5uDN4juQQr8LcToZyLtSuwXKa1gqbvB1rnrKsuRi3l56a72HxD0ErEc/
	ogBhKjlfew0dgefhi4O5QZ7ydaf93pUj9SpUf0xQ74qFJxYaUuJ0T11ZCvQTNteZGi2D6BXPoZb
	GKcPkqQ8RVdMo5F19HBlxjg5fK61cjYleWCcV8qji4avy/wZp/lticz9Ex80iBGTtzAA0mTOLJk
	Kp5AYwCQXapsmwE9M375uHorf6dgltuLqf8jqlVuHW9xycZNChXRlI8VthgEpuGvbGZHo+XKulU
	S7FP1st
X-Received: by 2002:a05:6214:4a84:b0:910:63b6:fc60 with SMTP id 6a1803df08f44-9140c2bb7e1mr41090286d6.11.1790171759269;
        Wed, 23 Sep 2026 06:55:59 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9140c4640c9sm20563416d6.40.2026.09.23.06.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:55:57 -0700 (PDT)
Date: Wed, 23 Sep 2026 09:55:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arPaalt234UG2qHV@cmpxchg.org>
References: <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F>
 <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
 <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com>
 <arK7gLYD0GJwzKFq@cmpxchg.org>
 <CACePvbW9=HTg69J1JTAUROZui4vD00g4=xbFk8QfL5Xdrg6pAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbW9=HTg69J1JTAUROZui4vD00g4=xbFk8QfL5Xdrg6pAQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: sajssbuyw5ujhsni1spgkm1z7ir9qbdk
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DB345A0005
X-HE-Tag: 1790171761-953391
X-HE-Meta: U2FsdGVkX1+EunmYW/fw3Kxq6fADIOeZrNvzDWxu49XoBuevaJox9THIWpZlysCxbNO2dYsKAVm672Pi16WxwM7FuGV08abs0RbYR2RkVqznBQfJoboRk+bn5BZX9DE7xR5+iFUSa7bl2undCB2rXjAkUyfAmxMMQgGoCBcUaiT1DyzQ/JGTxoWligtfzfMedng5pWHA9UPqCkBLh49b7FPj2uYUaoDpY2RFQMh7vnN1MsNGBeAqaQQgtGN2vi4tFBnoU2hBaxqXutQNmsbigHyzETkEzXwxSVn03I91YFk/eZcKesE4C9HiQitxRGpueEe420YnxwgafAk1XHodIHyBsO/8iROFMuTQRby+GOJkZcyw0B6vrm/FqimBvL0l2tuoh3LlB4R5YWYQabRJ/KMJMHoXlUKoc8NPiMrolb1kiHeLB3hL0X8V6EU2r1K3vbKm4xnFX0xYcJz4Y+zTJt7XGphR8879FWDUpUjQyEUErDVfl8zi1dMnJ4odYcbo4ECEkUGj2nceIJBp83C1EzcZlf4ydA2qHatUepzODy2i053+kyQ4EhcnILCjqoYPMo6UAHk9D3awcJ1Cw86tKb/CPSWOJp926Sr7HQumHdlhTHXr1uSP86wRKCF6allLkd2eKNJZloAxxjop1H1vNrPvSXODLI2bim5PJWI9g3qEquy0M3IKFvQFMiPaXwja2AB5aOLYfFjUVV29sK78etwDLSB/n9LiWdFp1Tph0+YV0q8DlbQUQ42S3Y4nMYbUMqCURurEtSm7DtDslTm2sujLzGafekEy6KOlepCEN6BK1NxAcQ0wK6CPq6HVf7WCnm5Izrpm/SKJOuY4P8RL3zJ5HLwe539jFcqDkvgehaLmbPXPxmHT/9Jb+MEIDbww/Y0Z1yLdIxiQpbTpD2XtUgwVlHd1S/CNCXBEge2FW+9co6Nr22pUPekB4bIcqzTPeGml0Sm1kpbaPvcq6p5
 TwBHQYZv
 Kg4+hJ2wRKVv7A+mOnWeOvO12rRkZmoSg+dSZSumwW/JVM+1m/nme6K70gfM4OfWixqwGyL6diokMHKpzS5b2fiG8YHrYs7OWUTK8eSNdRH9f7dMkXQLhh7uOB1H8Inu4M6rDAGnrrXwOFVePKBclEsEYMCo2UkP9dTuuVCjPkah/gYeVjV6mAsBusT4AY60vSwsBn5SCmP6fU0RJNfBXNAtIjQ5oZRKCZ4kXSpDYqUsCk3dUCdC6ClU36N6ZuQBPQZA/O4v4IPgts/8yRwtHDiMCkKHzHAGt5lHUOM1tU06gREBf4i2vnHOqZtobJWJ3pms2ApI0CxaY7wPf81+m9CsTlu/wD/thK7HeSVwG1rw2UF66Icr09mc7AlE+Qi5qwtU8279UY8A0QkJVZowY3/Lwc8NYOakhpEThKcggIE6OfL5lUxPpQdUvL0zTtqg3aMmP28YpJMDpqWOXX+azvdt0lgrsUegqyyPx5hSUEXWfv+1PRzcIHXrh0ydVg9g1OUhVFOLVaW4ZYqLDQoE60cItv5cQNEedLwcNVeFxyVxiXmd8TpSdF10zfREu9yx5MNx0ivrJ1oePU2XTYb/B13m67Hlx0Ra2VZ+r0BujyltV9Bv0pO/h2h7N150PPB/gkcdrUwI5smb4j84j+PbHJutAAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 09:32:17PM -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 7:31 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Tue, Sep 22, 2026 at 01:14:31PM -0400, Rik van Riel wrote:
> > > On Mon, 2026-09-21 at 06:11 -1000, Chris Li wrote:
> > > > On Mon, Sep 21, 2026 at 2:53 AM Gregory Price <gourry@gourry.net>
> > > > > That should tell you that your model of reasoning about this issue
> > > > > is
> > > > > ill-suited to address the problem.
> > > >
> > > > That is what I'm suspecting. Nobody in a sane mind would want to
> > > > zswap
> > > > 100% of the RAM and maintain reasonable SLO.
> > > >
> > > It could make a lot of sense to have some default
> > > limit upstream, that says the zswap pool is not
> > > allowed to take more than half of memory, because
> > > at that point the compressed content will be
> > > crowding other things out of memory.
> > >
> > > That seems like the kind of limit that is large
> > > enough that very few people will run into it,
> > > while also being small enough to prevent actual
> > > corner case trouble.
> >
> > Just to be sure we're all on the same page:
> >
> > Zswap *backing memory*, the space needed for compressed data, is not
> > the problem. It actually has a limit that defaults to 20% of
> > memory. And there is memory.zswap.max for users to define everybody's
> > fair share of that limited backing storage.
> 
> Just curious, how is the 20% determined?

If you look at the git tree, you'll find it came in with the original
commit that introduced zswap. There was no explanation.

> May I apply the same argument used in this thread: since you haven't
> surveyed all users in the world so you can't determine that 20% is a
> good value. Let's make that 200% for safety.

Yes, thank you:

" the practical usecase for limiting zswap memory to begin with is
  quite unclear to me. Zswap is not a limited resource. It's just
  memory. And you already had the memory for the uncompressed copy. So
  it's a bit strange to me to say "you have compressed your memory
  enough, so now you get sent to disk (or we declare OOM)". What would
  be a reason to limit it? "

- https://lore.kernel.org/linux-mm/20240925192006.GB876370@cmpxchg.org/

This is my whole point. Swap/compression is a low level layer in the
reclaim stack. You're asking it to make a page smaller and it does it.

- It's *reclaim* that determines who and how much gets swapped.

- Cgroups provide configurable memory.low and memory.min residency
  enforcement based on volume.

- MGLRU has the min_ttl setting to configure residency based on
  hotness.

- Many real world environments use some form of pressure-based OOM
  killing to determine when too many pages have become non-resident
  and the workload meets some subjective threshold of "suffering".

There is a whole stack of clever algorithms and configurable QoL
policies that make judgements about residency.

The compression layer has one job: compress the pages I feed you. It's
purely mechanical. It does not need an opinion on which pages are hot,
how much compression is "too much". It's a glaring layering violation.

The reason we keep talking past each other is that you think I'm
arguing for a larger limit. I am not. I'm saying the mechanical
compression layer has no business editorializing what the policy
layers above it have determined.

> > The point of conflict is the pre-compressed side. How many swap
> > entries can vswap hand out. Hard limiting this is the point of
> > conflict. Any given swap entry can refer to several things: a page
> > full of zeroes that has no backing space; a compressed page in zswap
> > that consumes some amount of backing space; a page that was written
> > back from zswap and now consumes physical swapfile space.
> >
> > All mapped by the same address space.
> >
> > I don't see why you would limit this at all. I don't see how you would
> > pick a sane default. And if you limit it and workloads run into it,
> > there are no cgroup controls to manage fair access.
> 
> I am not using a limit to enforce the workload. I am just using the
> limit with a safe margin to set the vmalloc max size for xswap.

And this would carry a lot of weight if we HAD to go with vmalloc.

But there is an alternative proposal based on xarray that does not
have that limitation at all. Neither Nhat nor Boaquan seem to have
been able to find any performance issues with it.

It's YOUR claim that we need to go the vmalloc route. That means it's
YOUR burden to (1) propse an implementation limit that everybody
agrees is safe and (2) why the usability risk of having a limited
implementation is even justified (e.g. performance numbers).

You clearly haven't done either.

> This is similar to the 20% for the compressed pool. I do believe the
> app will suffer if too much of its memory is swapped out. e.g. 100%
> of system RAM.
> 
> > (Despite what has been said in this thread, memory.swap.max is for
> > those entries that compete over physical swapfile space. It must not
> > and can not control vswap space used for all sorts of backends.)
> 
> Doesn't memory.swap.max limit existing zswap? Then that is a
> user-visible behavior change to make zswap don't go through the swap
> counter. That is a change we need to avoid.

No. This has been explained to you repeatedly.

It's for managing fair access to a physical swapfile space because
that's a constrained resource.

After vswap, zswap does not use physical swapfile space anymore. But
other things will, and it's important it keeps working for them.

This "user-visible behavior change" is the whole dang point.

And it's opt-in, so nobody "breaks" through kernel upgrades.

I'm sorry if your setup is abusing this knob for enforcing some sort
of residency. This isn't what it was designed for, and it is clearly
not a generalizable model - most workloads have page cache.

You're in fact asking for it to STOP being usable for managing
physical swapfile space. You're asking to break the broader container
and memory management model as designed so you can continue supporting
what is essentially a case of creative abuse.

This is unreasonable.

