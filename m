Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C999D1489F
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 06:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA7C6B0092; Thu,  8 Jan 2026 01:03:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98526B0093; Thu,  8 Jan 2026 01:03:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7AE96B0095; Thu,  8 Jan 2026 01:03:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 980DC6B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:03:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E91D41605C3
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:03:39 +0000 (UTC)
X-FDA: 84307754958.10.6456F05
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 31300120004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:03:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OlqG12Cb;
	spf=pass (imf29.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767852218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhIs3vOYMuFLAr6bHtr3A6x3d713FTijP+XCkxgK4yM=;
	b=CRgN4aSsYsktZVjUHjDgSwZGL/qZxosX80I9gy+NVUe+xCRAJxb9tBvoHnWJxXjzo3p/rq
	mTLgYoLovcr7U5/Qm2CIZ8h3tfht31RgoHfuD1KqfJxl1ZcXRfXeAL8a84/efVTi8F5V1k
	CaCyMirQOsGm6S0VgbbKxl6CgB17ixw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OlqG12Cb;
	spf=pass (imf29.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767852218; a=rsa-sha256;
	cv=none;
	b=mfylCKJxKUop6RL66Or/qHhW9hJWCosZTtZwF1ZKdCConbp45zPkKKHATCK/1vTe+rlHp7
	ym0v6XKtPe84xRpfPpvrEcCVR4/uOxoVtKja6q5pWMH+CkT/uu4pnW8WwwPFdwH+hEpUku
	77zg1v5PhKf6KZMHpzNYi6WTnGDEHbY=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a1462573caso140255ad.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 22:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767852217; x=1768457017; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KhIs3vOYMuFLAr6bHtr3A6x3d713FTijP+XCkxgK4yM=;
        b=OlqG12CbIz4xK+iPR6xn7bmrv/Z2bfWkr9NLdDKwpMaDBALDUjj+Y7M+bmpvLUylUV
         IMb1r5lW71CtCTeBy1AKDqLuLgoQ7ubGJSGuySW0DQaBBouWBrsrcl6wCirhMoioZNSh
         0Q/hDlgw50pM6nUhqmmqLnmGnHM4F/4DS7TzGVJsg4Uf1kfoLbiOaPpCCZNgoyeBG2FO
         80spfiBLvb1tYDqlzvQmAOBqfjesI9xFhgiF122DFzmO+07ReJ3cFVbAUwpGYb2U1MsW
         NLBmksi4buv2t7TQzISsBIPHjTmv/45iLjruJYx4gsQW4tD6u7TooPaxzrVXy2Qz24T1
         aZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767852217; x=1768457017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KhIs3vOYMuFLAr6bHtr3A6x3d713FTijP+XCkxgK4yM=;
        b=llza85WWRTPt8Ysbg5fZRDXkuEGhtFSqBfRrY9ugvbPttMHDQHjcXfiwxfVLLkXjHg
         LkfKo3g9NKP9FTYU/qp9zBeu26aHkGfNaWkJ7PogOSxfpMydcjy2pb1IYFoWAZlajRiV
         Omq20Bp9Zj+ImqgZrnBSdXV4nmbjlbn7Z8eF+Rkmb2xWaU5nk0gonzAxCDIT2mUuo2yO
         fqnKufw34fOsNETz0L+PLRgeqErpk0AzIhRP3EA4WU6BhDPlIjw/jklmsLxIke4G5cR8
         QsH/4xrrB+P0k9vX8QVvHKn+TL/KLxTLf8VvA3tkdvYjTzghoo5VtSNH14oVf6mdz2Fw
         WVOg==
X-Gm-Message-State: AOJu0Yz3DX9pJcpgwB0t6sWmoLvr37N2EMmsctjg32HXQtwfOJkp5F8N
	dGrfUgJkyqMsf13VhSr2IkqOMbjI8BSWQPHfeXcCTDJky/TeFw3aIj1yWgMtlDVSoQ==
X-Gm-Gg: AY/fxX6MZiUIOYvnMEUlcBJXJfZVbMmjqUCs0t9Bfp2VJ/38ViLRocrTga5aGHd1cF7
	f6AcsTjodZUfnFR4yRkWk8DVBUatHif2/5C76Yd+TYQCAdisXfPcIpU9nW1FjXRrg8dlWG5Q3cC
	01k6Lge015z1l1UMmh0x3W48FubTVqcEF5Zp+WtKMZ04l3YRHdT2eiLyO78EUcgUiZcZw/xHCwG
	TXVGyvsFzfLDJaGquhZTynK/xW5CBHSa6AFe+vyZiNTv4jSc0vrwgzSMVgyBVqRHQRy7O3/U1ok
	lwx7x43jD/szvyoo3pmFseQiVQIG1pL7gh1shVA1TXHZLFYC+6ylgcX8SXO3kN9ZwsEELB9m9wA
	NaPFQ37NfaMmgftmAbV12qsIdKr55a7xiywW3BectKNufqaprd9Z1VvXV2fQ3Q+Al3x8OhMlfFx
	ETo7fLxlRY1gzn/kfhTUS1ZsKn6vhLAVWNdLc3G7B6ayc3wxafLL+c
X-Received: by 2002:a17:903:fa7:b0:2a0:89b0:71d6 with SMTP id d9443c01a7336-2a3ff1ac431mr982045ad.17.1767852216571;
        Wed, 07 Jan 2026 22:03:36 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81ce8815129sm794721b3a.19.2026.01.07.22.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 22:03:36 -0800 (PST)
Date: Thu, 8 Jan 2026 06:03:30 +0000
From: Bing Jiao <bingjiao@google.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] mm/vmscan: optimize preferred target demotion
 node selection
Message-ID: <aV9IspAnCCM4ukE8@google.com>
References: <20260107072814.2324646-1-bingjiao@google.com>
 <20260107174652.3973445-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107174652.3973445-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 31300120004
X-Stat-Signature: rkkf9c6ez69bwokbrk9fusn5xwrd4sk6
X-Rspam-User: 
X-HE-Tag: 1767852217-49514
X-HE-Meta: U2FsdGVkX18OvbTHPk5xh0LaE/g8kT2AjAJEirZNNsFlSTR92asrA/eupp99xguCjvDYa+YD3QUmN1mQs9iTwyv98nURgirmiQjE7AZAoc7Ne6vEeht5Lo8c2BNAUaniRbGfdqRfe7HtfgDglwtSGoswMCq798l1rG0Okgh8HxVc/DZ8QoOveeZyU7McleBRyqmybbkQlyadDUVR2U5S0Z7DgjQmNPIGt9xABkCC4/pVY2CNngRkEf26tWvzO3gmFVzZO7uSplrF55oiA1grh6BzhbpNh0e/Y0p0cqOn6+Xz3v7Fj586egQy7HxC0j2fEup0LiMNfjsHB6RwDutaqfK1qVonpfgMEMvT5obkBqq3z6pxR8Cm7dPv6/jhjTvSiEzmto6ovS0FwstDm5s9SzYQTtQomkH1f3D/Vw2wS/f6Agkw27tQRWW2eH/hNvUBkCe+xF6XectwOv7nr5sc19M1PrZ350Vv3f/VFJoMo6TtPUk+2KM5CXJtYwl3ChmK0delXbzCGbuZ5yMWVmU5hFtRqgIdJCDReqeYwkx71XRu2ebRWRUGOhhjJD9NhFTv+zgDe98oGao3Q2HpIN8ZuezbBnHBH04V/7kwmzAXWzhB/FBnu+GF5eWLwQhSHQzQhjADkhe9HfBtMG2yjbGEG0ue23Od7KRMcftrtlKqT85iwv6H/uEpTBhxOtuPbK94X0JdDyx3aLoXRZF7Hk2V2tek8fnWULZxWqLdayjNCYa/PN/A3BCrlVwwKs6+dUvqsg0+aIj5PqoCKJW6YkpuQeciFNB8BoDtA49J2vRx6OEZ2A+jEbhY4c7JM0aD6Nxn4qCs3TJ0cxSFkmBmchemummyS14Cv+eqho0g7zeQIHSCnCUa8P6fCMURi1+9ems1b1w7xH+IdLk47wjDEp7EYrHsh8yV6CwdRMB3E+dZay9Y7BB/pPSBeYpTGDeY8r2CvrQBpfnEk5aGCAy/fmL
 ZXjpL3cp
 qKY7Woi3hIJLAM4p87h7GzycumQ6HVdkfZykKzHTvhW+3wtOH3BKQshPuT6GvmouNNOrDs6az98RYYtz/F9g/FG9UgeURU61NYcd/3uSoOkCZ/nZLrM6G4pB/tb6T9GxvxuWLKsADFBKsskaF5mPM4TIqGJO5MLTNRjM6r9izUXXmqceTaJwxY1gHVIebsLh40CBIYc+AXUKkwGBhwRv/jRZ/iz4kwYIKJv3l7L9FTU54uqJotsLD14Pe0oqMz7oQGgyNeWRSjBmRUi5Gjmj97xpxVI1/AaDFNtjawHtHskrCMAZ1qWuZOhmaulFvKw6KQST251iMLj1ZGEltryByfE31HpTQw4Ib3RpNDeZqKbaT7NpQ9Y6xkcHzeg5Y0njH21xozOdL5RbAxgQLWzYxnOCvxeFtm4tJUVUS4KgZuRCD1Kw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 09:46:52AM -0800, Joshua Hahn wrote:

Hi Joshua,

Thanks for your insights and valuable suggestions!

> On Wed,  7 Jan 2026 07:28:12 +0000 Bing Jiao <bingjiao@google.com> wrote:
>
> Hello Bing, thank you for your patch!
>
> I have a few questions about the motivation about this patch.
>
> > In tiered memory systems, the demotion aims to move cold folios to the
> > far-tier nodes. To maintain system performance, the demotion target
> > should ideally be the node with the shortest NUMA distance from the
> > source node.
> >
> > However, the current implementation has two suboptimal behaviors:
> >
> > 1. Unbalanced Fallback: When the primary preferred demotion node is full,
> >    the allocator falls back to other nodes in a way that often skews
> >    toward zones that closer to the primary preferred node rather than
> >    distributing the load evenly across fallback nodes.
>
> I definitely think this is a problem that can exist for some workloads /
> machines, and I agree that there should be some mechanism to manage this
> in the demotion code as well. In the context of tiered memory, it might be
> the case that some far-nodes have more restrited memory bandwidth, so better
> distribution of memory across those nodes definitely sounds like something
> that should at least be considered (even if it might not be the sole factor).
>
> With that said, I think adding some numbers here to motivate this change could
> definitely make the argument more convincing. In particular, I don't think
> I am fully convinced that doing a full random selection from the demotion
> targets makes the most sense. Maybe there are a few more things to consider,
> like the node's capacity, how full it is, bandwidth, etc. For instance,
> weighted interleave auto-tuning makes a weighted selection based on each
> node's bandwidth.

I agree that a detailed evaluation is necessary. When I initially wrote
this patch, I hadn't fully considered a weighted selection. Using
bandwidth as a weight for demotion target selection makes sense,
and node capacity could serve as another useful heuristic.
However, designing and evaluating a proposal that integrates all
these metrics properly will require more time and study.

> At least right now, it seems like we're consistent with how the demotion node
> gets selected when the preferred node is full.
>
> Do your changes lead to a "better" distribution of memory? And does this
> distribution lead to increased performance? I think some numbers here could
> help my understanding and convince others as well : -)

I haven't performed a formal A/B performance test yet. My primary
observation was a significant imbalance in memory pressure: some far
nodes were completely exhausted while others in the same tier remained
half-empty. With this patch, that skewed distribution is mitigated when
nodes reside in the same tier. I agree that providing numbers would
strengthen the proposal. I will work on gathering those numbers later.

> > 2. Suboptimal Target Selection: demote_folio_list() randomly select
> >    a preferred node from the allowed mask, potentially selecting
> >    a very distant node.
>
> Following up, I think it could be helpful to have a unified story about how
> demotion nodes should be selected. In particular, I'm not entirely confident
> if it makes sense to have a "try on the preferred demotion target, and then
> select randomly among all other nodes" story, since these have conflicting
> stories of "prefer close nodes" vs "distribute demotions". To put it explicitly,
> what makes the first demotion target special? Should we just select randomly
> for *all* demotion targets, not just if the preferred node is full?

The "first" target is not particularly special. It is randomly
selected from the tier closest to the source node by
next_demotion_node().

Regarding the strategy, what I am thinking: if far nodes are mostly empty,
preferring the nearest one is optimal. However, as those nodes reach
capacity, consistently targeting the nearest one can create contention
hotspots.

Choosing between "proximity" and "distribution" likely depends on the
current state of the targets. I agree that we need a more comprehensive
study to establish a unified selection policy.

> Sorry if it seems like I am asking too many questions, I just wanted to get
> a better understanding of the motivation behind the patch.
>
> Thank you, and I hope you have a great day!
> Joshua

Thanks for the feedback and suggestions. I realized that my previous
patch ("mm/vmscan: fix demotion targets checks in reclaim/demotion")
is what introduced the "non-preferred node" issue in demote_folio_list().
I am not sure whether it should be in the previous patch series;
but I just posted a refreshed version of Patch 2/2 in the previous series.

Thanks,
Bing


