Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9AD9C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:04:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB046B009E; Wed, 26 Aug 2026 04:04:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3FC6B00A2; Wed, 26 Aug 2026 04:04:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF02F6B009E; Wed, 26 Aug 2026 04:04:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4ACB6B009E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:04:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3794DA02C8
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:04:33 +0000 (UTC)
X-FDA: 85142683626.30.4E23CE9
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 03B7540008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:04:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WJfksUnk;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787731471;
	b=Cwlc+63Ss6bes0KBMIxVHGT2P/o7zcldhHB6ib3f+eD389W991LmUShP+sj2m9UvgQXxIf
	zwWzzjUc4zgaflqZDjunq2pqeED9XKHJZnNiQIUFS21gwfyEmFSAEgAWrgqHA0IEE4bSr/
	ZhKUtTuroeBN6ET8gIETA4+1AyNkXE0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WJfksUnk;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787731471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wB7gr+OEBdPvQV2wk9lYHYxAzB0Tgui+S11+5Xp/rXE=;
	b=PbVkvDU67BDVa9oWePG3S7xITLfbt2202jU1AOD9hb2Cl42EqUwhtbhPOiiLU0L1IxAJI0
	lvmOr2cgq/t5le9hDz2KT58pD/5lBXSpRq5Uqoi/lrAiYSY/eoFNRmBha6qzvYLVxSY39W
	nMFxq1gSznsGRxmFKoWXjim1Wy7L/6E=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15e592da74so87091266b.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787731469; x=1788336269; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wB7gr+OEBdPvQV2wk9lYHYxAzB0Tgui+S11+5Xp/rXE=;
        b=WJfksUnk0SqyQwXp7A50lY+zyunfJUJjiwsHddXIZLpZpBt1CPhXcnMl0UUC+4N4rA
         Hk1pQ4M+GuBZxjGmm9LbqrnZj8ij/wXNDZuOKinlAb1zW9zwvCfC9LXbEG5VrE6h5lfO
         VLIG7Rmi15MgWTWR3BW2YZhFDCfe/xYaGPsUzejI3VDR8PeK+wvGlopdmX9TLKNWHQDJ
         rS2dj3I30+utePm7RolIH5ZhCXRNQvGi5I5Y0FPRfe2Rcq+igfuvvw3VBiZwgfQUw3gV
         IfvePiocGeRGxPjOL/2653I0ZoMAVTI1Mq3Hp0na+NDh97zCynrA0dXjdN8rpWtKqDdS
         VzKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787731469; x=1788336269;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wB7gr+OEBdPvQV2wk9lYHYxAzB0Tgui+S11+5Xp/rXE=;
        b=WTESpwfhl2W1+RUl9I8o5MUdLLquHX+X9iuyzudaJXo42We3m83UJMxxWDlspSSGJ9
         BtmpmmrZ7L1KwtuZ14pWMESMMV3W5dHWy9NBQZFQo6pi4c/sQvKp+4BdTKluj3vOE90V
         uT+lUmeeNbcEH6MkgrwXtOrxwfNxv1p0LHuxNTaqEDAm3pH3xqbNMdnDvvsR7oR27PcR
         OL4FiwOOIU1Fh9yAVu6DBPWyTDmn2XXRRI3c2UxJ2YZGc2uaOFiU7dAFxrMefpl18e5u
         VFLrUF/mrM59ZCxzvJpUJYsWgpCELsjBLyZHyv8v8dE9uxKGdrDH4QI373m6McQXWPYZ
         xwJA==
X-Forwarded-Encrypted: i=1; AHgh+RowDz0CcU0ZguMuTWa7fIh/YqpsyRrzhEDb7dIAY+DFasRX3JnsaI0gGWd+vSFrNw5goCoKCiGTlw==@kvack.org
X-Gm-Message-State: AFuF++kRP2cBmGCecA2a/CjrizsRJbmUdugrp523sE1h7TRyLb1ZXi8Q
	tAZaVqE9V+ailu+3VnxiCqsXK3elEI+Ks1NlUXWqR/QhPpNyJk9Kv1fsmDRi0HIXdnc=
X-Gm-Gg: AR+sD10UPGQzdouRaBRExteBdqURK8MABF4RyfHIvpD6bNl2b2TuC/Qmfap+jsMH8Di
	QZozzLmKzaUGwsbwtWmrTNkUgRFv4uPnuU0/4WRRBtL76/Yfy4IjhoEPYoTfNwOAFAGCqn/Y5d3
	MQ3FbqIoI4G2+nAJc+DJjSoWrNnz6zC9ieuvs/6CTsDY7+9jyAnTjPB/hO2Yrb/lvju4657c+s3
	tKQxipZw21h03D7oNp8dFkhsag4SG4V9Ia9FdEKT6vMkzChLVPNnEOcA9mUMcDyu5Yt/4jteEm+
	jPsAd9VcDCCnoEiMvH6LAw+WReFiiC6dmnA84aMLymO92KschfNRaiTKSUM32ecaFa4cr8ObNfO
	g2s9AtLfd9FBOqSzaqut6aqm/tVhCOoTyvFGQuLfrYvPtNYraXb8u1HINYsryA3rfaU3IsEAvTk
	D4ePYwV+aXhoYL/JyvSWO/8nwNhgB73xmv7MkmrPMtr1PINyO37YIflYcsZgWaLfQ6aK4m2RY=
X-Received: by 2002:a17:906:f58b:b0:c21:450d:cd88 with SMTP id a640c23a62f3a-c250bbcc64amr476059866b.6.1787731469299;
        Wed, 26 Aug 2026 01:04:29 -0700 (PDT)
Received: from localhost (109-81-80-32.rct.o2.cz. [109.81.80.32])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a88ab65sm356259366b.37.2026.08.26.01.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 01:04:28 -0700 (PDT)
Date: Wed, 26 Aug 2026 10:04:27 +0200
From: Michal Hocko <mhocko@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao6eC2SUIGVz3Qct@tiehlicka>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
 <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao3quaSze8YjPjxZ@tiehlicka>
 <ao3tFg4JLNlbylTR@echanude-thinkpadx1carbongen13.rmtusma.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao3tFg4JLNlbylTR@echanude-thinkpadx1carbongen13.rmtusma.csb>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 03B7540008
X-Stat-Signature: gnszd3z6so8gw3qfg1n8hycqwbgdemw4
X-Rspam-User: 
X-HE-Tag: 1787731470-663698
X-HE-Meta: U2FsdGVkX1+D1sNrfjWPVKnNdLcp7kcU5cwYdUS/u1Qw7OioeKPQbXAjFFOSwx1WNFbBOm6t3M1h3B7mQbBzGX7DfzmzYFbMJUmGg48G22uHN5BS8E38C9DofYkVoy9/3IToe/YFhQXRPrpwitM/rEYmznLiEryp5NZzYUCQj74b5ySTtQ9PKzODVsK0Q0swdwBva4jxg1eNGXXwlimLjPryQp5nL5TaUY8VxMmoUhr5sW5Ap4Is6zWfBpEQUAgjtXzCOGPv7ikHsUCd8tr3Obun7thSrpTkXNRijSsFsJ7QvOA+slp/nPk/MoaC1ZcXP7lmA9PNzUoIrwr3U7FweOC44nOkb5yRUrf5l7rr8vyURwfL9NQlGupAru4cu4zuImn1FF3mJAb6NVyWMY+NHTG8iAgasoXchj6rshEU+t3TUgOnQ+aG/2Nl230naVErQ+V5oiyjRT2dEcoA731ZJIbHP2AhbkocKximW5PaXzy51Y9NKxspLqBKXvl0Oh6CskJNrgTjx/n7OkZ9k9hwNnsUzfEXAJ+0xnOH2qXqOJM6ZSLD1nlqTicQx1Ia34B7d9fVWm/aCu7CpBrvBSd5iA33jp+2JbYDuKdYtY6Bs80Q2nEPT2LMFfk4rO4rzpDnMS8oT/B3+HXJjH9QGM+qM1FAitLxwQd5a61l51rwrTNRFfOpcWwMj7AZgRY/y52RoX9nQpSXvJxeBth5JeK2lzUbzRzDZ5kw5mThBh0Vom/WoREA3bfNhgQTgzp+XTqJv2bHrlZ4BCmJNPzbJvNXedcq7j8EMz3/v5V3jTQumg4V4F5Aju8rR0/fJz0W+LmczbNRInvAZDJj7BD0FCtfLm2DFfxEPTEeU9xSDO9FLpDNyC1iD1ZC0uQON+RLYa6FH+wBMbymiqdn4/LyENDuP2jg5W58ZX330q+XFo1ReRUOPHzupMHtlPHSrg5/9VQoyTe2fcbyrWXdf+1VPuV
 IWqCfbNs
 /xUt3N8THRxk3Hgf7hWf9DKvHJkM8QK3DCJtKxSnH7ansqxezuYk+nFoqoUzT3NPiHz3XO8YvTWPkAD2vcKshxXU1BdTPy1phoUJuRd8YJgxsTOA8PqVag4yNbFCE4UnZnlapB/kw/fYe3Ou6GSqbpG6mh+fywh2Nix3mBH0meRJYPVmcuMg3DlPGtz1qevdM+zVOO9H64XcoROgqNCxkbcQDexpVbSKxT2x1NX5JY7Ajs0YlUKCcNUdBj7yvIUb1mIPULHcvXympOR2toLkthNaZL9npM4ZBliutBf06jTLl77kIrJPKHhzPq7cRrS5svrQrYhIumbLwh5m5mpzxOSMBCG/+R1BK6UGPgVMSdUytQ8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 25-08-26 16:58:51, Eric Chanudet wrote:
> On Tue, Aug 25, 2026 at 09:19:21PM +0200, Michal Hocko wrote:
> > On Tue 25-08-26 14:33:48, Eric Chanudet wrote:
> > > On Tue, Aug 25, 2026 at 04:59:52PM +0200, Michal Hocko wrote:
> > > > On Tue 25-08-26 10:47:53, Eric Chanudet wrote:
> > > > > On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> > > > > > On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> > > > > > > CMA allocations are currently unaccounted for by cgroup memory
> > > > > > > controllers. As system resources, they should fall under memcg, but CMA
> > > > > > > areas partition the available space for different purposes and memcg
> > > > > > > doesn't have a good representation for that.
> > > > > > 
> > > > > > Which CMA usecases are covered by this work? It would be also great to
> > > > > > spend more time describing usecases.
> > > > > 
> > > > > We would like to offer some usage guaranties to userspace processes
> > > > > ending up doing allocations in CMA.
> > > > > 
> > > > > For example, a shared CMA area is described in device-tree for an ARM64
> > > > > platforms. Userspace components could then, for example, allocate from
> > > > > it through the dmabuf heap, or a device or framework-specific ioctl for
> > > > > that matter, to use the buffer with sensors. The dtb may have other CMA
> > > > > areas described additionally that may or may not be used by that
> > > > > component. In this context, we would like the ability to limit one of
> > > > > the userspace component to over-allocate and choke the other(s).
> > > > 
> > > > How exactly is this supposed to work? How is the CMA access controled
> > > > and opted in for accounting. What happens when memcg limits are hit. And
> > > > many more details, please.
> > > > 
> > > 
> > > The administrator opts in by mounting cgroupfs with
> > > memory_cma_accounting. At which point the cma allocator will charge CMA
> > > allocations against memcg and manages a per area counter depending on
> > > what area the allocation was made into.
> > 
> > So each CMA area will have its own counter and limits?
> 
> Yes, in order to enforce a limit per CMA area this series add a page
> counter for each area. Areas are fixed and discovered early so the
> counters are added to struct mem_cgroup and initialized when the cgroup
> is created.
> 
> An admin would then use the cgroupfs entries to assign an area limit to
> a given cgroup, something like the following, using the reserved area
> for example:
>   mount -o remount,memory_cma_accounting /sys/fs/cgroup
>   echo +memory > /sys/fs/cgroup/cgroup.subtree_control
>   mkdir /sys/fs/cgroup/mycg
>   echo 16M > /sys/fs/cgroup/mycg/memory.cma.reserved.max
>   echo 64M > /sys/fs/cgroup/mycg/memory.max

OK, thanks for the clarification. This confirms my initial suspicion but
it is better to have it clearly articulated. I can see several problems
with this approach. First and formost I do not think dealing with all
cmas this way is manageable. This can become a mess very quickly if we
have one limit per cma and too coarse if there is a single one. I also
have my doubts about space allocation control through a simple limit for
something that is effectively a reserved physical space.

I might be proven wrong but unless cma serves objects of a uniform
size then this will simply not work in practice. Hitting ENOSPC without
hitting limits and thus impractical for shared space management.

[...]

> > > It looked consistent to use memcg since movable pages from regular
> > > allocations may end up in available CMA regions until a CMA allocation
> > > needs the space and has them moved. So in an extreme case, hogging the
> > > CMA space of a large enough area could trigger system memory pressure.
> > 
> > I really do not understand what you mean here. 
> 
> Non-CMA allocations can end up in CMA physical regions when necessary
> (ALLOC_CMA flag).

Correct. But those are a subject of migration so any such placement
should not be blocking real CMA allocations.

> Since both CMA allocations and other system
> allocations are represented the same way, with differences only in
> properties, and they can live in the same regions, it sounds reasonable
> to account for both under the same counter.

From the memcg POV we do account physically consumed memory. So yes,
it makes no difference where the memory comes from. We only care about
the overall capacity you can constrain or protect. Generally speaking it
makes sense to charge heavy memory consumers directly triggerable from
the userspace.

That is all memcg can provide you with. Specific requirements for
specific types of memory is a different story. We currently cannot
control per-numa node for example. There is an ongoing work to make
memcg memory tier aware. 

> > > > > memcg
> > > > > looked like a good fit to achieve this, albeit handling the areas, so a
> > > > > cgroup has a quota in a given CMA resource.
> > > > 
> > > > Please expand more on why do you think this fits into the memcg model.
> > > > AFAIU we are talking about a unreclaimable memory and reservations of
> > > > CMA areas.
> > > 
> > > Since memcg already accounts for some unreclaimable memory (kmem,
> > > hugetlb),
> > 
> > hugetlb pages have their own controller
> > 
> > > or induces failure if no reclamation is possible, I did not
> > > see CMA allocations being unreclaimable to be a blocker to track what is
> > > otherwise system memory.
> > 
> > yes, we can have unreclaimable memory charged to memcg, that is not a
> > real problem. We have all sorts of memory consumers that need to be
> > capped charged to the memcg. If dmabufs are another ones then fine, just
> > charge allocated pages from the cma area. It is the "make all cma users
> > memcg aware and have per cma limits" that I am really struggling with.
> 
> CMA is system memory independently from its usage though, and in cases
> with shared CMA areas multiple users can allocate from them. Yet the
> kernel cannot enforce usage limits.

Correct. Those are effectively a shared memory pools without any
control. I do not think memcg is a good method to enfore any usage
limits for that though for reasons mentioned above. Memcg is effective
at capping the overall memory consumption of a workload. Not really
great when it comes to a specific memory pool control.

> > You cannot really assume usecase, requirements, lifetime etc. for an
> > arbitrary cma area. I do not think this is a viable way forward. Focus
> > on your real usecase, which seems to be dmabufs.
> 
> While dmabufs are indeed my main use case, they are quite generic and
> may not always have system memory backing them (device memory). Working
> at the CMA allocator alleviated these disparities.
> 
> > Explain what do you want to achieve and then we can think whether memcg
> > is the right model for that usecase
> 
> Hopefully I expressed this in a better way by now. In short, enforce
> usage limits for concurrent CMA users using shared CMA resources.

Thanks. Yes this is more clear now. And it resembles hugetlb situation
more than memcg. You simply need a memory pool specific access and usage
control. Dispersing that to a global memcg limit seems rather coarse and 
I would say impractical. So it really calls for a per pool control with
an understanding of how the specific pool really works.
-- 
Michal Hocko
SUSE Labs

