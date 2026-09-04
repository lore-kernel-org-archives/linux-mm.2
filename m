Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6085C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72696B0088; Fri,  4 Sep 2026 12:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23A96B008A; Fri,  4 Sep 2026 12:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5FAB6B008C; Fri,  4 Sep 2026 12:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9876B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:46:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CE4740116
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:46:16 +0000 (UTC)
X-FDA: 85176657552.19.FC9313A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 745051C0002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:46:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QcKHemWz;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788540374;
	b=kKDQap1aELtBV5ehw64l2ImCyE0nwi7aBsw6MX88x5LYtrhe11/BolRlmQfig2Lwn0QGGR
	deb8hvqUjBoFscI8TwhxO4j3YzaH1H2XniKL1N7G3n2vYaGZUYsbOk+LzxelssCs70d5yz
	IT2MazCqT91plMBhtVwhzPM18HYeMMw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QcKHemWz;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788540374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=maBinTpgEptRAadbtAeA4Cful7CwIKDPrQsFPR09ghw=;
	b=MA/TQ1sG7a5UlDsrDEo9Kg50td7/HTQR60RfUDZRowNFBRIlTwzHyfLrE+47lSK+pgqdwJ
	U7Jlh/WeFdDbyJYCubrfNpX+vX6ge570zvzt8MP0abJj5XN/TVTAmRbt829RfjBQOZscUZ
	MWGRoqFf7cC3ZTNhpNcZQAA3PfD4NVI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CFA543D4B;
	Fri,  4 Sep 2026 16:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593FC1F00A3E;
	Fri,  4 Sep 2026 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788540373;
	bh=maBinTpgEptRAadbtAeA4Cful7CwIKDPrQsFPR09ghw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QcKHemWzOADUSWpVHigDqdv+C7oRjcVLvRNYL5g4HItAUbk+WUoLjWgsytshoBjig
	 GqwM8XZWmQad9GKDYRlzSXarRQ/7QkXbH19qEkwbRYxc1rwC8HmDr9MH2LjI1uKmTk
	 UTvKNLWoNE+Y1O48PcN5P7TMdilhIkPsfqmUQRSJ86+sKlLQn2RszsGQKEKLDvUVJT
	 pKbzx+ZDbJci7y59/5qa7Jho5MYd6kOey+1sCoTt9mk1LAXtXD0EzDeeD2JDh7sdAX
	 NTe7RoGbwpq1LEq8ogSHtkLdIYCMLKSCkqyQg92+7xzI4FmoaXPBm5ws0vyHhYh9fu
	 GMPx2vDK/ROqA==
Date: Fri, 4 Sep 2026 17:46:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nimrod Oren <noren@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <aprtAqgJyS-gJ77Q@gremlin>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260902162323.GO3004@cmpxchg.org>
 <aphS2TancJAZLND7@gremlin>
 <20260902183752.GP3004@cmpxchg.org>
 <aplzo5Jsb6f1MdaM@gremlin>
 <20260904154346.GB6641@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904154346.GB6641@cmpxchg.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 745051C0002
X-Stat-Signature: itasexsz4so9rua99c5s8utytd3znmdf
X-Rspam-User: 
X-HE-Tag: 1788540374-719664
X-HE-Meta: U2FsdGVkX1+7fP58djRbqpPaUbUuD0PLSNPcE3yX5a7StHSinV6RaHv1YYZQFJ5qpEHdLO14ynqtc5dnNIn5P/Dg2Fppvk2i6oE+V+R9Ra7SIO6S97AmXONAjjH0HTnJIMB7yNNrz0F/CxgpkdT/d4TpvxT4PXe1iL/dyAg7J6k5aZw3qx7RVBvg2IY/+sGUsVHpTGInVCD2z8MwSbOmIL9yRelX+3+hTxXAcpZmg7J/zv1dKlfCoGs2ycTc4kvrSXQJJX6NTSCq0g7bUi83J1aLQlRSCf/m8EIgwZdDWBiB8Gzuei2rFZo6/jLXBiYW1FxP+7RWNWFyCHWH4PO6l1cSO6jOUqInRHF1+Ad/AJIkWGZktDW3cyx1Af7JZdcF407TAXiSgjbvNTvtBrEoFuPM04LdSz4HFOxt1JqrOzVQowlQOUVatl2A6RDX0YLph6ATKfo6q53/jTxA8N6fmiuCgvwz64mO3cEKjGbr9HiTlAGiOLHUDm4X8c04cbSgO+S/Ti2GlvccpNrmPCjbs0pCVo007Tmh0v1R98OihDPcCLwBshaQObWhLDa+3R2MUjOkJRvsaJ2lStKmSyHiANMWZ4HG+lfZErxhIZrqJ+T17WsotSWhitK8uBK1B2lStCkgdNznlTHxH/FqEiznTjN4L5NQp1U7Iu9zUk87fk1QHo52D7jcOaOix/FJMDT2kYStEweQbOJ2Ml6VoGA7OPGZ5WSp35YASAhnLRTiUfxEs38rckP3CwLcavkicI4Mx98pQKJwLwpbwMiRqU+aC6TOz0H+e8JTWMuDei5tGjDMJDGHInxlGcWwhLOUS2uW863/MrPcyig2KmVl2dHAdJqJ8c+mqZsZFwA1VLKiG0h/2i+RlxB/r8rDVhbjtDGWf6Z9Hyg22elmJ7D0Fa80nypMbuffPF3dO/Q3WFZ3CyhoPxejszxLDWp96rs6EDVEyrCs0jo1HPhByH/qL0e
 yNdLByj+
 Lw9PbrketNPDv7fUSgZ1RMpiov1mbkQBXTwN8kvl2LYXD8E5+SHgtxI+SdzJHCHflzwAiag0PpWbqwSwve6BAd33pzT5bCODD/X3DqSx9wb0k/cA7kwU9+eEn64QBOcFcu3+YCHrQBLmM2gh7oGOqI8IYYvCnt0oQ2mu/6NIpaE0TMtP9FtysRF+JZmDLZIExssbFQpuQeEGT/i954J64HocKT85CCOX7WH95LCl3aKt0u39+7fgZn6kgQSvu4ZhjluX955AkruSfsrnNqJSz4YeEpdassC7P6siNEcW5vyXFbYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 11:43:46AM -0400, Johannes Weiner wrote:
> On Thu, Sep 03, 2026 at 04:46:18PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Looking over the sub-thread (correct me if I'm wrong) the issues seem to be:
> >
> > - 512 MB pageblocks become unmoveable quicker than expected
> >
> > - When trying to convert a pageblock in try_to_claim_block() 256 MiB is required
> >   to be of the desired migratetype, and this is difficult to achieve vs. 1 MiB
> >   (yes clearly :)
> >
> > - AI training checkpointing was a problematic workload - big latency spikes and
> >   timeouts. Tonnes of unmoveable memory, order-0 allocations falling back to
> >   MIGRATE_MOVABLE (ugh), exhibiting try_to_claim_block() symptoms above.
> >
> > I hear all of this, and to be clear - this kind of real-world data, at scale, is
> > the kind of thing we should base decisions on more than anything else.
> >
> > Reality > theory every time (and the more you look into the kernel you more you
> > realise it's a tower of heuristics anyway, especially in classical reclaim :)
> >
> > I guess what you're trying to say here is the only way in these circumstances to
> > make headway would be to have more memory reserved.
> >
> > But is that the right conclusion? Aren't you still screwed once those reserves
> > are chomped up?
> >
> > Or are you saying the increased watermark levels gets you effective
> > kcompactd/kswapd sooner?
>
> +1 Exactly! The watermarks sit on top of that reserve. Both background
> reclaim and direct reclaim are thresholded such that there are always
> a few pageblocks worth of free space for the allocator to choose from,
> thus reducing the risk of fallbacks and block poisoning.

Right.

>
> > The TL;DR for me is - you have a workload that's broken already with larger
> > pageblock size - maybe you could test that with/without this patch and see if it
> > really does help?
> >
> > Anyway it seems to me all of this is essentially a (valid!) critique of
> > assumptions backed into the page allocator code.
>
> This part I don't quite follow. Why is the page allocator doing
> anything wrong here?

In this bit of the email we were talking about a function that lives in
page_alloc.c :)

>
> You tell it your largest routine allocation size. It groups smaller
> allocations by their ability to move into buckets of this size,
> coordinates a headroom of buckets for non-violating placements, and
> ensures reclaim kicks in when that headroom depletes.

Yup, but as discussed if something straddles the buckets it's useless (it can
only make guarantees about the buckets themselves), the target everything has in
mind is PMD (since we are bumping the reserves for THP explicitly), and
alignment/size requirements make smaller sizing useless for mTHP.

>
> You're giving it a very large bucket size and are not happy with the
> headroom that commands.

Yup.

>
> [ I'll reply to the other points in your email later. ]

--
Cheers, Lorenzo

