Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EFA1C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 683856B0731; Tue, 18 Aug 2026 13:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633EF6B0732; Tue, 18 Aug 2026 13:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521EF6B0733; Tue, 18 Aug 2026 13:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26CCE6B0731
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:51:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A625B1202A2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:51:22 +0000 (UTC)
X-FDA: 85115132004.21.3863891
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9D7BA160009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:51:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QblQwH9h;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787075480;
	b=Zz4Qg3nrzXVK9iEtWRw83jd9ulA2cRYgyJsRY+NZaS+z1fJn3XRAR5EdnivfVR5DBnzACe
	b8LhOIq9tOhGJCTEjlHj1kn84i+b59v1ObXXrqV6gs6b8Fdyveecu6iLR7subDlAW5DFxV
	OYJzDtnowYCuMZJXU06tHqoo3F4n6IM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QblQwH9h;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787075480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8EyHP1G6Ss2vuWPJxbKrE4qIHqkqwOqq05+lpQaLG+A=;
	b=6C3Woh08GDY9chanUrK1xJwAYh0fy5WbH8P4u1cUsXXCkgvdTi873qj/YArmAbQlVehoCl
	p6NmB3Eo7DTzl9AeTe7pnjCVcUm5L2sRXD1x+dViXcreOZvjQ/cg0ZTXoMIMqhAKa7DpHR
	MN2KS/QfLpqUQIg9yFKtaxmYMKJ+FBo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C401043EE8
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC01B1F00A3A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787075479;
	bh=8EyHP1G6Ss2vuWPJxbKrE4qIHqkqwOqq05+lpQaLG+A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QblQwH9hp7wt6FBdH/48nQx+LlqAul/H4cnCXWn/zWF+V8kGI8dkGSh+qcgrNM+Sl
	 5MDmY2mLciaKdcBxxhdaXypHBSAwjvzsYMj/ixfb6bqZshRdm/KL00W/Bm95qot408
	 CaGeJV+OYaw6SLq/YdCpTe6vf8FEawA1BMt6QLrFvHnwhUOctYg2JRAu05Ukb2MZJ7
	 tFXO++QkcSuGiOQUj0i22/tsfCE239TanHjIjVLQ6R3Odb7HWmgR31ZYIX9mMOrrRa
	 /YTYyc3bAWh5ugUrFYs8Tmy0DsBLFcPAJvtYQguodG5b/x8I36ZmsmPhuEGTP1/Dq1
	 OGEoZdprIqyqw==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-934944f2d22so13145385a.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:51:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqqe1w6e8IP57lP8RqKXedFP+3dHRY94dqU0h7701/UJGyu3xJgqUL/DONQNexw90dLC4QE8oE6tA==@kvack.org
X-Gm-Message-State: AOJu0YzZj3u8a+GoOOh4nHPxxx1K49p/4o6VphZoR6UoA7ETQfWn9eie
	7OWbHsLonZiTBjWuAl4sxuMFQu5Gm7kqVS/tHtxRJVA615sVAxn8yJI2wa6aHymhbEC6B8qJCSf
	0uj0ouv54kGTyy7VDt+JQebTRCuK73TE=
X-Received: by 2002:a05:620a:7114:b0:934:9524:2e89 with SMTP id
 af79cd13be357-93704b12e59mr1008752885a.13.1787075478654; Tue, 18 Aug 2026
 10:51:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <anJ45UK0MWvskzlK@google.com> <DKPL6YQLP6NT.1747A5QR1D8VH@linux.dev>
 <aoOsiMyfWbkCbV8F@google.com> <DKS0Q1CR4APM.3JMJWR7UGI30U@linux.dev>
In-Reply-To: <DKS0Q1CR4APM.3JMJWR7UGI30U@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 18 Aug 2026 10:51:03 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN7w9RaaiV7dmv+E5EVJnYs7b=iRbv1F_oQsOTJVva_yg@mail.gmail.com>
X-Gm-Features: AcwNN1UbHto9qs-1psS7FqQsamRQ__ayaKuu8Tcsz_esuXM52QeZPIfqFJnfpeU
Message-ID: <CAO9r8zN7w9RaaiV7dmv+E5EVJnYs7b=iRbv1F_oQsOTJVva_yg@mail.gmail.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED allocations
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9D7BA160009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: yw9d6jbifhqtjrqb9o6iybfpqbbbg6zf
X-HE-Tag: 1787075480-780970
X-HE-Meta: U2FsdGVkX18zthT3yihMn2LdB1myBlTJmBhLTPsdXFYiEjZqrcTwCHfN7GRqVk/y8UJ2PRn+OcPtbtnWiEUx/9lR3h4Kvsx762gJ0DW/GCJHeV54Rnd5f4cG+4uK05ugKvP2zqObQ9e9e6h9tHXwtCMCtlh08pDX1Q878xcfMtysSx4pb6gw6yjU70ATJQ7LYmHbsSVT9q+HodUIZHXX7pglxaeD7vmI/aLJCM5h9rGxZrvnxZTLEOx2e1g3ksSWOYRFmDoJiNAMk9U05O/f6147/trWMGZIpCWk4hf83G45dGaKqbdo6MxfSrRVVDbciG6MuDIWrbI4NnsP0nV33l3uAlxzbeYiuLlO4hOLncMngXRNyU8CvH8Hq4lQvbywOe69z/ZvN7rhP9rgyiEvovLNk6yPe3shu/ktnGGLHdBPIgdXTzwQhrIYIglxaKmxbUXVRd+B9Xr3I5VRhyJwiT2V6vCUIYJqr1lxf4ZauVX8R4gUqmOojfME8kEVtH5abyWrzgXgQVvD+nydHXYVmILsKG/p3KU0mpbryQNAepd1sSyWgIHZaXmOTJE78SfcIi2JTKFHnOQKOQZW9geTS/97iGskYJsXPtzT8bIHGSTnaiauwAtlbajjedFaaWf4aESEVtXXv6ob3hzAtc+NN8w5PcVD7kFH4SRi4lWgKel+UX9dXglsrmSl2z3Z5hA2eyN0jEfyDmRsSWHpcVB7asL9CTcs/KnTqdTVKcbiUCxivsf9oEs4uzTCOb1iPS2x/JeAVgpTIxJ9maUWgACGf/LXQxdBqQ8KMQ6oizFi/2Si13AFPC72ohwjFwtR475U+Gyw+3u9f1Px+arVgfeKwkweN1VW24vC4QsD8je1lOclCWVnH2Wq0+n43qzL7/64cQ8065gmgSTBHhaJMXEpuT1RzvH5mm9PvA2HhwOPr80EmV6s+O+S8SS41/d9g/s6g8WtvD+lmRZUv/LkPNI
 NgSf6gqO
 8g/AoyKfkLfP1zGe2rRTr7DeAdzkKmEgwdAmL0jxmjG/eCTHHo8MzJS06TsSjKYtLjhNpwkJzh0/TsH9+wNdxbMjS3IYA3Nnzrx8WpmTKx+iY84iTJHsZL1QLXYHVw+eDokHuVWf6dnoL4QClT5OLJtu61y1bT4LXYR17IelgEY3qT5WWB1xrI8C/uJD3dlnLiYxDgZzuRKagOc0CJnflUIwtyiOez/MhKp1j32VJ5jJHTp/biGctkKAbl/AHkkbHnCfGeULEvFg1TxWxc1nTO3e2Rtp9Cjh3r2XAKMZnhY5waKIoX0JTKZhlyEbpHKMDjoNc9SL8y6/qp8nB4SzU+oMVNVb2e2pR/XdXqzVmoojWjsRENDaq+cQ3uWNaFtHisj1W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 4:04=E2=80=AFAM Brendan Jackman
<brendan.jackman@linux.dev> wrote:
>
> On Tue Aug 18, 2026 at 2:55 AM CEST, Yosry Ahmed wrote:
> ...
> >> [0]: https://lore.kernel.org/all/20260805-shivank-gmem-migrate-v3-9-00=
d8bdec4e1d@amd.com/
> >>
> >> > I wonder if we still need a fallback case where a pageblock contains=
 a
> >> > mix of mapped and unmapped pages. We need to carefully handle such
> >> > pageblocks:
> >> > - For unmapped allocations, we need to unmap the relevant PTEs and
> >> >   potentially do a TLB shootdown (if they were previously mapped). M=
aybe
> >> >   we should always flush the TLB for simplicity for now.
> >> > - For mapped allocations, we need to map the relevant PTEs. No TLB
> >> >   shootdown should be needed.
> >> >
> >> > Assuming unmapped allocations are always zeroed by the users on allo=
c
> >> > and free, we don't need to worry about zeroing pages either way.
> >> >
> >> > We may want to track the number of unmapped pages in such page block=
s to
> >> > now when it's fully mapped or fully unmapped and change its type, bu=
t
> >> > maybe this can be a followup if needed.
> >>
> >> ... However, yes this might be unavoidable despite what I said above.
> >> This was also DavidH's feeling when I chatted to him a few months back=
.
> >> The hard parts of it are a) the tracking as you hinted at and b) in th=
e
> >> general case that means allocating pagetables.
> >
> > I am considering a simple-ish scheme to avoid per-page tracking and
> > potential TLB shootdowns in the freeing path (which prompted async
> > freeing internally).
> >
> > What if we just always map pages in such tainted/mixed pageblocks when
> > they are freed? If they are already mapped, nothing to do. If unmapped,
> > we map them and zero them. No TLB shootdown required.
> >
> > We also shouldn't ever need to allocate. If the pages were previously
> > unmapped, we should have already allocated any necessary page tables.
> > Right?
>
> Why would we already have allocated them?  In case it wasn't clear, I'm
> talking about breaking down huge mappings here.

If the pageblock is mixed, then the allocation path must have already
split huge mappings and allocated page tables as needed (or the
allocation would have failed). So the freeing path should be
guaranteed to not need to allocate.

Basically what I have in mind is, if you need to make an allocation
and you have to fallback to sharing a pageblock, you split the mapping
(if needed) and map/unmap memory. Now that might fail if you can't
allocate pages tables, or recurse into the allocator trying to share
another pageblock, etc. This can especially happen if you cannot find
a mapped pageblock to begin with.

So it's not very easy/straightforward. But at least all the complexity
should be in the allocation path where failures are tolerable to an
extent and the context is more-or-less known. The freeing path should
be straightforward-ish.

Technically you can still hit the same recursion case today if the
direct map was PUD-mapped, you will need to split the PUD to convert a
pageblock. But it's less likely to be a problem as the page table
allocation is mapped and if you have an intact PUD you probably have
tons of 4K mapped pages.

> > Zeroing on free may still be bad, but not prohibitive, and hopefully
> > this is only a fallback. We'll need to figure out where this fallback
> > fits (e.g. before or after reclaim/compaction).
>
> Yeah zeroing seems tolerable.
>
> >> So yeah I think it's probably doable but I _really_ want to avoid doin=
g
> >> it in this series if we possibly can.
> >
> > Yeah I am trying to figure out whether the issue is theoretical enough
> > that we can do it in a follow up.
>
> I think it's definitely theoretical enough if secretmem is the only
> user. I hope given that guest_memfd usage is gated by a userspace opt-in
> that it's also automatically OK for that too...

Yeah unless we can come up with a very simple solution, I think we can
probably live with this for secretmem.

