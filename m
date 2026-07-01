Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4BEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 00:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361166B00A6; Tue, 30 Jun 2026 20:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA826B00A8; Tue, 30 Jun 2026 20:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B45D6B00A9; Tue, 30 Jun 2026 20:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEECA6B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:24:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 644C6140193
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:24:49 +0000 (UTC)
X-FDA: 84938312298.03.931394C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 58105A0009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:24:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AjLSjqyf;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782865487;
	b=pFgdvXNbf5TBjUvqQxOkJDmizH2DZNEIWNIoxbfXGPUAPIzFzwlbsbXrv+EAdm1E3BYAqK
	8xDA/d+irfS2dEaZeL/MsmdsGN2B38Ygtddof0AtMvyoVP0sFfpYYIi4HS3MxVmEk1G2Xi
	0o3MTt1J5sMI6RMrZvxY83ja83zZ8rw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782865487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTs20CSuM/vUDmQtfbId0rl6VyghXk5EqBxIDAfWQSY=;
	b=6zumvblOZIuOoqEqiryroPA9FOGsCs6LJ91q4jUfSqFX6Mut+1JaQ7BWOFDRRONDUMAy0X
	1UGo8aRciM6e4zfjESYWj7nE4L5mVqAu/Rh5w9Utb0C65/e1R+yDsgW1rf/dRm7WDSGB24
	/+KTi8NJ/be9FYIjx9fUM5IqqAIVoew=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AjLSjqyf;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5065B4404E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0016E1F0155A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782865486;
	bh=xTs20CSuM/vUDmQtfbId0rl6VyghXk5EqBxIDAfWQSY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AjLSjqyfopAP4F3P6MxA0n61MZIsCi2dgOhDqP9s10/x0vSgtA3nd+udZr8SFIaom
	 r244g2MCdIJZRY5Dx9HPDmz9aAsJ1rum/uyvox7y2kpnG8xveDGgr0mvxHHs7Ops2R
	 cWlI5YosovpQKOSnB3MY+EQUYTTuCmVnMyAIMFNqwVYs0FcffkXCOH6Iis2xTgofZF
	 PZErwryqzxdjnIDIV7x9zKiVDRiKqeBxdHeCwjHI8g2h3WotpjQPvPW8x2DplZ2hCw
	 5jN35/vlX1FX7VocSPEVx1YuiGljMnV0ymEPqDuMudhODogdNC1nB4xnv0PW3F+s96
	 M/EFFmiDQiv/w==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9204711e831so5736985a.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:24:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+qhShuDPTZP7PJMRii3hjypsUZy0vtlZHzvp7ZADRxCwWxG4QQzkTVC7JtHcIt+ULh71sFVnJaBw==@kvack.org
X-Gm-Message-State: AOJu0YzFoWmiM+COX58ytDbciuTEAPdGmcuFGPN0PHkh89JEcdIp1CcS
	KA1M7ttskotdWRrz5qIvrorPcd4NhCoxD5IUmdK/piSz4COybCwYo1MQDh9tAo1uFh8dYTaqHNX
	W7JSy5wnuZ4tsyT0KT26dRO6POQGBl9s=
X-Received: by 2002:a05:620a:6193:b0:92e:6cd4:5892 with SMTP id
 af79cd13be357-92e6d859ad7mr510785985a.40.1782865485255; Tue, 30 Jun 2026
 17:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
 <e2bd33d5-4de5-49cd-970f-9e80eec91a3b@kernel.org> <CAGsJ_4zuxaqXQgrg_SiGY4gV4t3FQHdeM91dH4Y3-RknE7mg-g@mail.gmail.com>
 <DJMRZRG70UYR.MOB3ASPBCBAB@nvidia.com>
In-Reply-To: <DJMRZRG70UYR.MOB3ASPBCBAB@nvidia.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 1 Jul 2026 08:24:33 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x0D6oX54_BD2jcN5_v8o-TcgMTKbC6dv4QOxCtB_ShNQ@mail.gmail.com>
X-Gm-Features: AVVi8CeBGpmk77eMqTttSo_KxW3HiZzQmkhgUsiW6XCXi8DjH7cK85TxKK_kaqY
Message-ID: <CAGsJ_4x0D6oX54_BD2jcN5_v8o-TcgMTKbC6dv4QOxCtB_ShNQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Introducte Reserved THP
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org, 
	ljs@kernel.org, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, muchun.song@linux.dev, osalvador@suse.de, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	peterx@redhat.com, usama.arif@linux.dev, willy@infradead.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 58105A0009
X-Stat-Signature: q84r1eir4ytbo19knzhixa3ginacurnc
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782865487-998269
X-HE-Meta: U2FsdGVkX1/PXYazB3PhejbxpmFFLf8Xe1Zvr+LksFsdZxrde2c0CuEcAm/xmJFmoCa0DjZtdQ76hMTZz3oLBIqkxEqSOD8IEEHQv0stD311H90PtMurEM5VQu5aCA/Rdba4Ag5MPLkFWy8eWKmL4mqW+k9FhSXRMp8ZmPnKqKqcZMHAKhv8QCG/+LYreuy9a1H3G0qKYF9J6QgH4dnKlxfFal1bS9p32GT+WzAMRtSYavF3eYySuk7Tpk728+XrH4Dx6qs2M8cPDTqLQwYS0tXuIPzEGqd47xKKZjtyUVBxbUqdWCUvXnkMgVTolzo8jJl1EAV+UUovPZTVchmlsN1KSudMA40C3rrt9yJbv7jSj0sLlsrWHt2564191z9Wvu8NikNtdqWBGjYCw9yEF8pZnI3hS5qSB6iaJ2nzxEr5V82k3L/Dz8XO/pXRVyy8VL9rEfu0VWjyVTAj4aFg3BjC6ojtfoRJIpjokqLDKHjhkoe5tkiixA1e/nTTPCpqwKkqGaRRYLyaWwzsBLZen35g6X1H44Q9Ht3SmKvda+GqEufOuyu1k7RpetumqvMhLUio60p2gGL59s43JHcdCUdembkf8mmxdrbFRTe5nl1TiSrWhEOAdHd8JtoF20BRNPvi6NoygWidvXNA/MLINb0itw+/Ng2t4LevWhRE1RDI7j3G952/9ztxd93O6Dqm0gC6vDp6KVxFhrHHsNY/oJcLTz3AfTHpAPoohmTmOYuLIThcfm2Jeh/PYYoc4Vacs63czZw9HDwzf9gFXZpSX8RcokfMvJCIOBLOfjSKsOxDLDipERKUnyF+Qrhkya0H4Plp7P72xj5z+2i43DKFBcV98VDp3wumXs/tTVwXSaTy61IP8zp5cl3bNUhPJl8VEDyML+Z/p7v9o0PRtVXGrEE/18eOCGOX8rMcYYHLDgkXUJkE6Bj00efQARDN5CjseKkhGC0CQ/tOzs7offb
 pb+YaUMd
 nGwtZNPqXQyB0Rpujp2Fw+xc5j78Msx2aPFw/XJVwA/W9eW9XpCoOEZzC4rHh8Q1N2JCyFtRZMZM/qpxXLxwyvHm58//DLllPhJ37OXwxRvVBT3zsXfmlUAu+LbhputHMOnr55iJI8Cmq7yzdkmt5CGmT2w+WO7wrVP/wlO0KyG3T+RzwJq5NdG6QtkPwGQnrG38rQBlPMGMPgtSbbgW3FzmuZSMUPI1Zkz7WfR25tdAUXdndgGcXY77LDypuBB+YpPed5qZQcRq45CFaAgheoKubs+UBq3Lrp5UAIy2IcHgEUUU9X94U87MUkI7lUX0s5OccopQCfRWZe0CU4ErCb4Q4UJPPzf2EBpVdiaYDyvm2Syg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026 at 7:34=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Tue Jun 30, 2026 at 6:59 PM EDT, Barry Song wrote:
> > On Mon, Jun 29, 2026 at 8:20=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > [...]
> >> >
> >> > 2. Implementation
> >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> >
> >> > In 2024, Yu Zhao proposed a similar idea:
> >> >
> >> > Link: https://lore.kernel.org/all/20240229183436.4110845-2-yuzhao@go=
ogle.com/
> >> >
> >> > The idea was to introduce two virt zones: ZONE_NOSPLIT and ZONE_NOME=
RGE to
> >> > guarantee the allocation success rate of THP, achieving an effect si=
milar to
> >> > reservation. However, it seems there was no further progress, perhap=
s because of
> >> > reluctance to introduce more virt zones like ZONE_MOVABLE.
> >> >
> >> > This RFC wants to discuss another implementation:
> >> >
> >> > 1. Introduce a new migratetype: MIGRATE_RESERVED_THP.
> >> > 2. Introduce two new hugetlb-like kernel boot parameters: `thp_reser=
ved_size`
> >> >    and `thp_reserved_nr`. When set, the required memory is marked as
> >> >    MIGRATE_RESERVED_THP and put back into the buddy allocator.
> >>
> >> I'm all for some mechanism to make runtime allocation of large chunks =
of memory
> >> easier, by adding a pool from where multiple consumers (THP, guest_mem=
fd,
> >> hugetlb, whatever) can allocate memory.
> >>
> >> Call me very skeptical of getting the page allocator involved like thi=
s. (I hate it)
> >
> > One thing we've been thinking about for a while is whether we can
> > introduce something at the pageblock level to let memory "remember"
> > which allocation order is preferred within that pageblock.
> >
> > For example, if we ever allocate an order-0 page from pageblock 100,
> > that pageblock would later prefer order-0 allocations. Similarly, if
> > we allocate a large folio from pageblock 200, we would avoid using
> > pageblock 200 for order-0 allocations as long as there is still
> > memory available in pageblock 100 for order-0.
> >
> > Since order-0 allocations are often the main source of fragmentation,
> > if we already have both pagecache and anonymous large folios, we may
> > care more about containing or quarantining order-0 allocations in
> > certain areas, rather than trying to maintain a large-folio pool or
> > similar strategy.
>
> Aren't unmovable pages causing fragmentation? For movable pages,
> regardless of their orders, they can always be migrated if no additional
> pin is present.

Right, unmovable pages cause fragmentation, but movable pages can
also contribute to it. In terms of fragmentation itself, there is no
real difference between them=E2=80=94the only distinction is that movable
pages can be migrated or compacted.

My point is that compaction or direct reclaim may lead to both
allocation latency and increased power consumption, which may
defeat the purpose of using large folios to speed up Android phones.

Right now, order-0 allocations are spread everywhere, so compaction
and fragmentation may be playing a ping-pong game and remain
ineffective overall.
Ideally, we should try to reduce or avoid triggering this kind of migration=
,
compaction, and reclaim.

Our recent experiments using 16KB for both file and anon
show that we still frequently enter direct reclaim due to memory
fragmentation when allocating order-2 pages. In about 89% of
order-2 allocation cases, direct reclaim is triggered even though
there is sufficient free memory above the watermark, but no
contiguous order-2 pages are available.

These movable order-0 allocations, which are spread across every
pageblock, are contributing to the fragmentation.

>
> If we use per-order pageblocks, how to use pageblocks with rarely used
> orders? Allowing lower order to fallback to higher order pageblocks?

Yes. If order-0 finds that all pageblocks associated with order-0
have been exhausted, it can allocate a new pageblock for this purpose,
or in the worst case, fall back to a pageblock associated with a
higher order.

>
> >
> > Chris=E2=80=99s de-fragmentation of swap slots[1] seems to be a big suc=
cess
> > based on my observations, where he provides a similar memory-order
> > preference for swap clusters. There is no reservation mechanism, no
> > sysfs knob, and no need to split swap into two areas=E2=80=94everything
> > just works automatically.
> >
> > I wonder if you would be interested in something similar at the
> > pageblock level. If so, I=E2=80=99d be happy to work on a prototype in
> > August. I=E2=80=99m completely booked in July.
> >
> > [1] https://lore.kernel.org/all/20240730-swap-allocator-v5-0-cb9c148b92=
97@kernel.org/
> >
>
> I feel that swap and page allocation have a fundamental distintion,
> where swap slots are not movable, but pages can. Memory compaction can
> move pages around to make space for high order allocations, but does
> swap support something similar? How will page mobility work in this swap
> slot defragmentation world?
>
> In addition, when swap space is full, or only order-0 swap slots are
> available but higher order folios want to be swapped out, folio swap
> might simply stop (except splitting folios to fill the order-0 slots).
> But for page allocation, some pages can be reclaimed/swapped to make
> space and this adds complexity.

Yes, I agree it adds complexity, but it might significantly help
address the fragmentation issue from a different angle. We used to
focus on migratetypes, but now we could shift perspective and try to
contain order-0 allocations, which are the real source of
fragmentation.

BTW, I haven=E2=80=99t started anything on this yet, because I=E2=80=99m no=
t sure
there is any positive feedback for it :-)

Best Regards
Barry

