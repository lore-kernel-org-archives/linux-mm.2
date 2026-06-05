Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28FC0CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F36A6B0088; Fri,  5 Jun 2026 07:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB536B008A; Fri,  5 Jun 2026 07:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6924A6B0092; Fri,  5 Jun 2026 07:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57F376B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:08:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5380120B99
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:08:06 +0000 (UTC)
X-FDA: 84845584572.28.64DB38F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D6094000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:08:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i5js0fVe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780657684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnbIavIpNy2GsJuFnD7e4YPrUBBo/xYEFuZ/czPlhg4=;
	b=1cFN1XluTorsUpscgJootVHUp8JLykpKCzMmxHnMesZpCfHFjcQOESwlVa/hlEp7yLHFYZ
	Ff5cwR7QvkOhSU4LWimZWFMHj+zG5Bx9CKK+Qyo0GOZ496o/sYuLBNDMQMqhNFUdQ04hum
	3V0llwZl4/kxjygbaJ3wNoxlRu+hB14=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i5js0fVe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780657684;
	b=ZVJc15IA2b3ZgJHfzVnV7ph8o8y2PfMaHVIGUvQHSroGTh0l5ULb5zV3NJJTdMjV/unzEY
	7KjkxmdH5mQklUOwblns0aiv5BAu5HbNABkGsrVUQBXlmEKfLXgt6CnI64cdl5gjPkeC+T
	pdgAHiNWg3JKzR/seTArbfsEjFEW1WQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780657683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnbIavIpNy2GsJuFnD7e4YPrUBBo/xYEFuZ/czPlhg4=;
	b=i5js0fVe5D3ioW834OmpknbcZ+1g3Tdsp1R4puUQberkgtmXTSA7zJgWc0M8zAtw5UhO21
	u1XnQW2VfRO/NGwlc7gk+PU+rBSlqQ3OWI7Jir8mopAFcBG5AzT59DZoChkvxzCXjkzmcB
	Som7nGwdFNcWzv/r4h0oZJvaq9HrtUQ=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-e0ThJNBXOUCYhcnkFZjLfg-1; Fri, 05 Jun 2026 07:08:02 -0400
X-MC-Unique: e0ThJNBXOUCYhcnkFZjLfg-1
X-Mimecast-MFC-AGG-ID: e0ThJNBXOUCYhcnkFZjLfg_1780657682
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-660668ea5cdso3305298d50.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 04:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780657682; x=1781262482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RnbIavIpNy2GsJuFnD7e4YPrUBBo/xYEFuZ/czPlhg4=;
        b=Ej3s60MDBbsMqXuWdsjAhTQbwMWXiOrzgdpHJdVGvTsUNGLfZ781WbXQoyn6vTMYh1
         aYhjglIv8RsXJP6mKY/DxJ/1C9EJ0VjaFdERZGBKVyTrM7YSrDXc/lM06DEUJXLNz5wH
         fATINZShYzwo551kktI439FxpSQL9CBN4aa212i/8hbI1coT8eo6UJFDOoBphw0+SjbM
         Po/k1HYYJUG3V0yKkFbCQ8A234sCujOC9a4pzbBj62ul+fYkc6dSTnLI5mS+lLvBG6SC
         VGQIpfrfl6otDI44rl4MpZYe6PTdrJZOtN5rlwSbfnHj4w5+EOPejQuKpeBLYz9HG/VX
         Yxxg==
X-Forwarded-Encrypted: i=1; AFNElJ9TNGD5bhiXpacgZl+Yu2LuO9AZ3Exyh45hI2oG5cnf2swa2S3+Jmibtgn+Qjiy6WCpKUb3tRCPdw==@kvack.org
X-Gm-Message-State: AOJu0YwwBE8yCSVNsrKXsje/l3eIlDAnYSXl7iM8i2aBvWvkHGL5kPbA
	ODWGNMgv39YdKCNH7EqqFhFdMpSgKBKTzvhy+5BzTOq1rksVYJnLJiqyRSYwv55UlheTGz7guQt
	HvXi3XzohK7lKYihdL6BLpJlNerxh1SplQMesarI/EjV0o0Sw/KcDdXS4f8ZEIOwUEBxRaXTn5x
	fGSmiaXFCPBU1+KP78bPpRrZS+0Os=
X-Gm-Gg: Acq92OGixtmYYdjs1okis49WtoZXdgZb03oZqjqX0wmyqH4WQgLNTgjnZ50zbWEP0Yt
	ZrkBqmJTUYm6deieihX+NhGBNqN9vdFrPMN80vcDwTSd8CZANgsXGjbYbJTzOc3aIaev8B/1m0P
	4AtchBeo+JhLr+ZKOjeK+TvcfESZ0G2OhRvk3SMY0uxDlSg8IxoovqncCm3RsifzJkJj7/WiKh4
	1RtKwHeLpDNMqs=
X-Received: by 2002:a53:d015:0:b0:660:e09c:d57 with SMTP id 956f58d0204a3-66106ebcef3mr2499231d50.29.1780657681701;
        Fri, 05 Jun 2026 04:08:01 -0700 (PDT)
X-Received: by 2002:a53:d015:0:b0:660:e09c:d57 with SMTP id
 956f58d0204a3-66106ebcef3mr2499173d50.29.1780657681210; Fri, 05 Jun 2026
 04:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <20260522150009.121603-12-npache@redhat.com>
 <aiGOvIR9sfm91cvT@lucifer> <CAA1CXcBeg5yFvG89xd49mD=LuSouDsXNCkfMF8Xmdgy7-h522g@mail.gmail.com>
In-Reply-To: <CAA1CXcBeg5yFvG89xd49mD=LuSouDsXNCkfMF8Xmdgy7-h522g@mail.gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Fri, 5 Jun 2026 05:08:42 -0600
X-Gm-Features: AVHnY4Liq6tkgSFTN6DYeTe7Br6RZQ4QYy5S_46hYFr7Lp6rnutyZuixTgEsUMA
Message-ID: <CAA1CXcCsHigMV5=+KN8c9Fi+G6OZWkdk6qQ4awzrJS9XzzokrQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, 
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mv0w4hHBLG5q_rz2OLVbq_iKyfVKA7hJYpcofuQoQQg_1780657682
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D6094000C
X-Stat-Signature: q5tiyu4h95armmdi4tpjsyg4f1kncu3s
X-Rspam-User: 
X-HE-Tag: 1780657684-745333
X-HE-Meta: U2FsdGVkX1/PidW5k4OwbMFEPixjzv6vDGB0vTxbhCoDOgMn8dofXs7QjlKP/568MnT1ePhChaG944lv1wgUf1+fCKcIb7TLC4okPxResDD4z+ZPg8XHPZEPRZ7jGNtdp4PWmSwN1hiTdjWQFVDSkyKoUQ1OagNgycfQVHwvJVjokkkm9n8ws0HCPOt7aq6GC/RWiqMt9l4JGXP1o36aaoncw3jwQI+yIifa8Ob+vqqHPnnP4awq4BdKlpZX/CnzzIXKrnc0CluBLLR5bTHsH5r5/fCq1wkr3GKA084RoB6xUc6gpGHZLzny2OgIu9/YfBF9IJXFa2PPsMXFiXGCBD4NMYOBB19IBp4hu96qW4w7G/FrXfb7rXUfW5Jdwk84uiTNtRaPP8PH/luo9X3ut7FVivp8nqoLNhqXSZVZ6uynPD4h7mzrTiPx7lo7MPpyF4ugRMi0ruiBR/UOQbqImruYBa1ciOtsrD0uWfuY9gKR87auhT43/1HjeNzPeICg34DNPtZMREpon555yzDNYYWeoqTQB2+ys3G87NfhyIcyxElpPPKcRKj4gCqaxnEqwmtLKiXelMlDvCKtVeH17S/Smr5/Tu9rvHwdqna1wHnptFNhFgiDQ/HmLpljUjFIQKr2GZoALtZWAVdQyFI3Q6Xcr8UOET1TKCzK+e6e8Ts59BqWx6X+Q4ZuZBechSggUweNq7G1JjuNgUBC0nHIzXVV1JudpRzOblLG5OkYkj16+NP7Y++RWLRfavR/q0cN1LxlOs9DqYaapijwcszFCkZAgAuqeIVGXdhig51BTLl3WPS5XZBbEJ2JATxAGsx8PXHtXHSyVT+GCW8EB1FnTLAG5W+0LQJvExJvvPCEBBYjYUgwGCCpQzQ6UAc6+f0dS5SmsN9Y4Z3X30cfGXwJPGmN3S+GKYdgytpraLAbwQcadCEamcg9xDT8vmi336IFKGHv0hyhBoizgZ9/pt6
 fZeqkEMZ
 hAc/ZObUQ7KKPIiXoifpuiKMPSZkBMfTBnGmfln0uDWPIHqQj25O0QHSWSyYPkbMETPXjf/R3mHlR3yzRaVbbSPk15yXoBy312SYkonEIPVtq2Nc9PRfKv88r9dENBi+F3m7Aw8N+NCNGHnH3Tv8ayXX3GkpOmSNiX8D0AYVZMFRcIG+9aJv3U2rROrkml9kpj/JUVIlsyT+0jo7t9th2K5NUieaw6N451yGQluUogD1L010kNqcDKacA9T1B+PPcPzW2K/QYpw9vWPjPhGwM+Cqql2AYBGCe0MwXtT1D1rGN8kNY1plIYBHVO+4Fu8BsIrECFp6RTa3WUEL2ArLalhrHICt4UMYkjLnIdU9tNWXG9OR/1R5F/ym0oyX8gjIkca3bjmhOq5LLcY4MQwz1X4Ag7OopwygjD5PoGDE0c6PilXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 5, 2026 at 5:07=E2=80=AFAM Nico Pache <npache@redhat.com> wrote=
:
>
> On Thu, Jun 4, 2026 at 8:45=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> w=
rote:
> >
> > On Fri, May 22, 2026 at 09:00:06AM -0600, Nico Pache wrote:
> > > Enable khugepaged to collapse to mTHP orders. This patch implements t=
he
> > > main scanning logic using a bitmap to track occupied pages and a stac=
k
> > > structure that allows us to find optimal collapse sizes.
> > >
> > > Previous to this patch, PMD collapse had 3 main phases, a light weigh=
t
> > > scanning phase (mmap_read_lock) that determines a potential PMD
> > > collapse, an alloc phase (mmap unlocked), then finally heavier collap=
se
> > > phase (mmap_write_lock).
> > >
> > > To enabled mTHP collapse we make the following changes:
> > >
> > > During PMD scan phase, track occupied pages in a bitmap. When mTHP
> > > orders are enabled, we remove the restriction of max_ptes_none during=
 the
> > > scan phase to avoid missing potential mTHP collapse candidates. Once =
we
> > > have scanned the full PMD range and updated the bitmap to track occup=
ied
> > > pages, we use the bitmap to find the optimal mTHP size.
> > >
> > > Implement collapse_scan_bitmap() to perform binary recursion on the b=
itmap
> > > and determine the best eligible order for the collapse. A stack struc=
ture
> > > is used instead of traditional recursion to manage the search. This a=
lso
> > > prevents a traditional recursive approach when the kernel stack struc=
t is
> > > limited. The algorithm recursively splits the bitmap into smaller chu=
nks to
> > > find the highest order mTHPs that satisfy the collapse criteria. We s=
tart
> > > by attempting the PMD order, then moved on the consecutively lower or=
ders
> > > (mTHP collapse). The stack maintains a pair of variables (offset, ord=
er),
> > > indicating the number of PTEs from the start of the PMD, and the orde=
r of
> > > the potential collapse candidate.
> > >
> > > The algorithm for consuming the bitmap works as such:
> > >     1) push (0, HPAGE_PMD_ORDER) onto the stack
> > >     2) pop the stack
> > >     3) check if the number of set bits in that (offset,order) pair
> > >        statisfy the max_ptes_none threshold for that order
> > >     4) if yes, attempt collapse
> > >     5) if no (or collapse fails), push two new stack items representi=
ng
> > >        the left and right halves of the current bitmap range, at the
> > >        next lower order
> > >     6) repeat at step (2) until stack is empty.
> > >
> > > Below is a diagram representing the algorithm and stack items:
> > >
> > >                             offset   mid_offset
> > >                             |        |
> > >                             |        |
> > >                             v        v
> > >           ____________________________________
> > >          |          PTE Page Table            |
> > >          --------------------------------------
> > >                           <-------><------->
> > >                              order-1  order-1
> > >
> > > mTHP collapses reject regions containing swapped out or shared pages.
> > > This is because adding new entries can lead to new none pages, and th=
ese
> > > may lead to constant promotion into a higher order mTHP. A similar
> > > issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collap=
se
> > > introducing at least 2x the number of pages, and on a future scan wil=
l
> > > satisfy the promotion condition once again. This issue is prevented v=
ia
> > > the collapse_max_ptes_none() function which imposes the max_ptes_none
> > > restrictions above.
> > >
> > > We currently only support mTHP collapse for max_ptes_none values of 0
> > > and HPAGE_PMD_NR - 1. resulting in the following behavior:
> > >
> > >     - max_ptes_none=3D0: Never introduce new empty pages during colla=
pse
> > >     - max_ptes_none=3DHPAGE_PMD_NR-1: Always try collapse to the high=
est
> > >       available mTHP order
> > >
> > > Any other max_ptes_none value will emit a warning and default mTHP
> > > collapse to max_ptes_none=3D0. There should be no behavior change for=
 PMD
> > > collapse.
> > >
> > > Once we determine what mTHP sizes fits best in that PMD range a colla=
pse
> > > is attempted. A minimum collapse order of 2 is used as this is the lo=
west
> > > order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
> > >
> > > Currently madv_collapse is not supported and will only attempt PMD
> > > collapse.
> > >
> > > We can also remove the check for is_khugepaged inside the PMD scan as
> > > the collapse_max_ptes_none() function handles this logic now.
> > >
> > > Signed-off-by: Nico Pache <npache@redhat.com>
> > > ---
> > >  mm/khugepaged.c | 181 +++++++++++++++++++++++++++++++++++++++++++++-=
--
> > >  1 file changed, 172 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index 64ceebc9d8a7..d3d7db8be26c 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -99,6 +99,30 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash,=
 MM_SLOTS_HASH_BITS);
> > >
> > >  static struct kmem_cache *mm_slot_cache __ro_after_init;
> > >
> > > +#define KHUGEPAGED_MIN_MTHP_ORDER    2
> > > +/*
> > > + * mthp_collapse() does an iterative DFS over a binary tree, from
> > > + * HPAGE_PMD_ORDER down to KHUGEPAGED_MIN_MTHP_ORDER. The max stack
> > > + * size needed for a DFS on a binary tree is height + 1, where
> > > + * height =3D HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER.
> > > + *
> > > + * ilog2 is used in place of HPAGE_PMD_ORDER because some architectu=
res
> > > + * (e.g. ppc64le) do not define HPAGE_PMD_ORDER until after build ti=
me.
> > > + */
> > > +#define MTHP_STACK_SIZE      (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_M=
IN_MTHP_ORDER + 1)
> > > +
> > > +/*
> > > + * Defines a range of PTE entries in a PTE page table which are bein=
g
> > > + * considered for mTHP collapse.
> > > + *
> > > + * @offset: the offset of the first PTE entry in a PMD range.
> > > + * @order: the order of the PTE entries being considered for collaps=
e.
> > > + */
> > > +struct mthp_range {
> > > +     u16 offset;
> > > +     u8 order;
> > > +};
> > > +
> > >  struct collapse_control {
> > >       bool is_khugepaged;
> > >
> > > @@ -110,6 +134,12 @@ struct collapse_control {
> > >
> > >       /* nodemask for allocation fallback */
> > >       nodemask_t alloc_nmask;
> > > +
> > > +     /* Each bit represents a single occupied (!none/zero) page. */
> > > +     DECLARE_BITMAP(mthp_bitmap, MAX_PTRS_PER_PTE);
> > > +     /* A mask of the current range being considered for mTHP collap=
se. */
> > > +     DECLARE_BITMAP(mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> > > +     struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];
> > >  };
> > >
> > >  /**
> > > @@ -1411,20 +1441,137 @@ static enum scan_result collapse_huge_page(s=
truct mm_struct *mm, unsigned long s
> > >       return result;
> > >  }
> > >
> > > +static void collapse_mthp_stack_push(struct collapse_control *cc, in=
t *stack_size,
> > > +                                  u16 offset, u8 order)
> > > +{
> > > +     const int size =3D *stack_size;
> > > +     struct mthp_range *stack =3D &cc->mthp_bitmap_stack[size];
> > > +
> > > +     VM_WARN_ON_ONCE(size >=3D MTHP_STACK_SIZE);
> > > +     stack->order =3D order;
> > > +     stack->offset =3D offset;
> > > +     (*stack_size)++;
> > > +}
> > > +
> > > +static struct mthp_range collapse_mthp_stack_pop(struct collapse_con=
trol *cc,
> > > +                                              int *stack_size)
> > > +{
> > > +     const int size =3D *stack_size;
> > > +
> > > +     VM_WARN_ON_ONCE(size <=3D 0);
> > > +     (*stack_size)--;
> > > +     return cc->mthp_bitmap_stack[size - 1];
> > > +}
> > > +
> > > +static unsigned int collapse_mthp_count_present(struct collapse_cont=
rol *cc,
> > > +                                             u16 offset, unsigned in=
t nr_ptes)
> > > +{
> > > +     bitmap_zero(cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> > > +     bitmap_set(cc->mthp_bitmap_mask, offset, nr_ptes);
> > > +     return bitmap_weight_and(cc->mthp_bitmap, cc->mthp_bitmap_mask,=
 MAX_PTRS_PER_PTE);
> > > +}
> > > +
> > > +/*
> > > + * mthp_collapse() consumes the bitmap that is generated during
> > > + * collapse_scan_pmd() to determine what regions and mTHP orders fit=
 best.
> > > + *
> > > + * Each bit in cc->mthp_bitmap represents a single occupied (!none/z=
ero) page.
> > > + * A stack structure cc->mthp_bitmap_stack is used to check differen=
t regions
> > > + * of the bitmap for collapse eligibility. The stack maintains a pai=
r of
> > > + * variables (offset, order), indicating the number of PTEs from the=
 start of
> > > + * the PMD, and the order of the potential collapse candidate respec=
tively. We
> > > + * start at the PMD order and check if it is eligible for collapse; =
if not, we
> > > + * add two entries to the stack at a lower order to represent the le=
ft and right
> > > + * halves of the PTE page table we are examining.
> > > + *
> > > + *                         offset       mid_offset
> > > + *                         |         |
> > > + *                         |         |
> > > + *                         v         v
> > > + *      --------------------------------------
> > > + *      |          cc->mthp_bitmap            |
> > > + *      --------------------------------------
> > > + *                         <-------><------->
> > > + *                          order-1  order-1
> > > + *
> > > + * For each of these, we determine how many PTE entries are occupied=
 in the
> > > + * range of PTE entries we propose to collapse, then we compare this=
 to a
> > > + * threshold number of PTE entries which would need to be occupied f=
or a
> > > + * collapse to be permitted at that order (accounting for max_ptes_n=
one).
> > > + *
> > > + * If a collapse is permitted, we attempt to collapse the PTE range =
into a
> > > + * mTHP.
> > > + */
> > > +static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct=
 *vma,
> > > +             unsigned long address, int referenced, int unmapped,
> > > +             struct collapse_control *cc, unsigned long enabled_orde=
rs)
> > > +{
> > > +     unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
> > > +     int collapsed =3D 0, stack_size =3D 0;
> > > +     unsigned long collapse_address;
> > > +     struct mthp_range range;
> > > +     u16 offset;
> > > +     u8 order;
> > > +
> > > +     collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
> > > +
> > > +     while (stack_size) {
> > > +             range =3D collapse_mthp_stack_pop(cc, &stack_size);
> > > +             order =3D range.order;
> > > +             offset =3D range.offset;
> > > +             nr_ptes =3D 1UL << order;
> > > +
> > > +             if (!test_bit(order, &enabled_orders))
> > > +                     goto next_order;
> > > +
> > > +             max_ptes_none =3D collapse_max_ptes_none(cc, vma, order=
);
> > > +
> > > +             nr_occupied_ptes =3D collapse_mthp_count_present(cc, of=
fset,
> > > +                                                            nr_ptes)=
;
> > > +
> > > +             if (nr_occupied_ptes >=3D nr_ptes - max_ptes_none) {
> > > +                     int ret;
> > > +
> > > +                     collapse_address =3D address + offset * PAGE_SI=
ZE;
> > > +                     ret =3D collapse_huge_page(mm, collapse_address=
, referenced,
> > > +                                              unmapped, cc, order);
> > > +                     if (ret =3D=3D SCAN_SUCCEED) {
> > > +                             collapsed +=3D nr_ptes;
> > > +                             continue;
> > > +                     }
> > > +             }
> > > +
> > > +next_order:
> > > +             if ((BIT(order) - 1) & enabled_orders) {
> > > +                     const u8 next_order =3D order - 1;
> > > +                     const u16 mid_offset =3D offset + (nr_ptes / 2)=
;
> > > +
> > > +                     collapse_mthp_stack_push(cc, &stack_size, mid_o=
ffset,
> > > +                                              next_order);
> > > +                     collapse_mthp_stack_push(cc, &stack_size, offse=
t,
> > > +                                              next_order);
> > > +             }
> > > +     }
> > > +     return collapsed;
> > > +}
> > > +
> > >  static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> > >               struct vm_area_struct *vma, unsigned long start_addr,
> > >               bool *lock_dropped, struct collapse_control *cc)
> > >  {
> > > -     const unsigned int max_ptes_none =3D collapse_max_ptes_none(cc,=
 vma, HPAGE_PMD_ORDER);
> > >       const unsigned int max_ptes_shared =3D collapse_max_ptes_shared=
(cc, HPAGE_PMD_ORDER);
> > >       const unsigned int max_ptes_swap =3D collapse_max_ptes_swap(cc,=
 HPAGE_PMD_ORDER);
> > > +     unsigned int max_ptes_none =3D collapse_max_ptes_none(cc, vma, =
HPAGE_PMD_ORDER);
> > > +     enum tva_type tva_flags =3D cc->is_khugepaged ? TVA_KHUGEPAGED =
: TVA_FORCED_COLLAPSE;
> > >       pmd_t *pmd;
> > > -     pte_t *pte, *_pte;
> > > -     int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> > > +     pte_t *pte, *_pte, pteval;
> > > +     int i;
> > > +     int none_or_zero =3D 0, shared =3D 0, nr_collapsed =3D 0, refer=
enced =3D 0;
> > >       enum scan_result result =3D SCAN_FAIL;
> > >       struct page *page =3D NULL;
> > >       struct folio *folio =3D NULL;
> > >       unsigned long addr;
> > > +     unsigned long enabled_orders;
> > >       spinlock_t *ptl;
> > >       int node =3D NUMA_NO_NODE, unmapped =3D 0;
> > >
> > > @@ -1436,8 +1583,19 @@ static enum scan_result collapse_scan_pmd(stru=
ct mm_struct *mm,
> > >               goto out;
> > >       }
> > >
> > > +     bitmap_zero(cc->mthp_bitmap, MAX_PTRS_PER_PTE);
> > >       memset(cc->node_load, 0, sizeof(cc->node_load));
> > >       nodes_clear(cc->alloc_nmask);
> > > +
> > > +     enabled_orders =3D collapse_allowable_orders(vma, vma->vm_flags=
, tva_flags);
> > > +
> > > +     /*
> > > +      * If PMD is the only enabled order, enforce max_ptes_none, oth=
erwise
> > > +      * scan all pages to populate the bitmap for mTHP collapse.
> > > +      */
> > > +     if (enabled_orders !=3D BIT(HPAGE_PMD_ORDER))
> > > +             max_ptes_none =3D KHUGEPAGED_MAX_PTES_LIMIT;
> >
> > Hmm, this is a bit odd, what if the user set max_ptes_none =3D 0?
>
> We'd still want to scan the full PMD to populate the bitmap. That way
> we can find the smaller orders that contain 0 none/zero PTEs.
>
> >
> > I assume we handle the 0/511 thing elsewhere?
>
> Yes in the bitmap weight check and in collapse_huge_page_isolate()
>
> >
> > > +
> > >       pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> > >       if (!pte) {
> > >               cc->progress++;
> > > @@ -1445,11 +1603,13 @@ static enum scan_result collapse_scan_pmd(str=
uct mm_struct *mm,
> > >               goto out;
> > >       }
> > >
> > > -     for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_=
NR;
> > > -          _pte++, addr +=3D PAGE_SIZE) {
> > > +     for (i =3D 0; i < HPAGE_PMD_NR; i++) {
> > > +             _pte =3D pte + i;
> > > +             addr =3D start_addr + i * PAGE_SIZE;
> > > +             pteval =3D ptep_get(_pte);
> > > +
> > >               cc->progress++;
> > >
> > > -             pte_t pteval =3D ptep_get(_pte);
> > >               if (pte_none_or_zero(pteval)) {
> > >                       if (++none_or_zero > max_ptes_none) {
> > >                               result =3D SCAN_EXCEED_NONE_PTE;
> > > @@ -1529,6 +1689,8 @@ static enum scan_result collapse_scan_pmd(struc=
t mm_struct *mm,
> > >                       }
> > >               }
> > >
> > > +             /* Set bit for occupied pages */
> > > +             __set_bit(i, cc->mthp_bitmap);
> > >               /*
> > >                * Record which node the original page is from and save=
 this
> > >                * information to cc->node_load[].
> > > @@ -1587,10 +1749,11 @@ static enum scan_result collapse_scan_pmd(str=
uct mm_struct *mm,
> > >       if (result =3D=3D SCAN_SUCCEED) {
> > >               /* collapse_huge_page expects the lock to be dropped be=
fore calling */
> > >               mmap_read_unlock(mm);
> > > -             result =3D collapse_huge_page(mm, start_addr, reference=
d,
> > > -                                         unmapped, cc, HPAGE_PMD_ORD=
ER);
> > > -             /* collapse_huge_page will return with the mmap_lock re=
leased */
> > > +             nr_collapsed =3D mthp_collapse(mm, vma, start_addr, ref=
erenced,
> > > +                                          unmapped, cc, enabled_orde=
rs);
> >
> > I guess mthp_collapse() also does PMD collapse if only PMD is enabled?
> >
> > It feels like this name is a bit confusing then :)
> >
> > But I guess we can do a follow up to think of a better name possibly.

Yeah, ideally we can clean that up later!

Thank you so much for reviewing and verifying the new algorithm. The
diff i sent was just a draft-- I have already added comments and
cleaned up the code more.

Cheers :)
-- Nico

> >
> > > +             /* mmap_lock was released above, set lock_dropped */
> > >               *lock_dropped =3D true;
> > > +             result =3D nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
> > >       }
> > >  out:
> > >       trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> > > --
> > > 2.54.0
> > >
> >
> > Thanks, Lorenzo
> >


