Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 241C1C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06C7E6B00A7; Wed,  8 Jul 2026 04:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043E06B00A9; Wed,  8 Jul 2026 04:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3BA6B00AA; Wed,  8 Jul 2026 04:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2D266B00A7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:38:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 474F0A06D4
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:38:55 +0000 (UTC)
X-FDA: 84964959030.12.AE66CBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F3B140002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:38:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQuW8lKu;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783499933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8RJBNwkV593NAki7eRp3qI3mSkpI/7Fgbb1+OQ0jog=;
	b=SxKH6brrk6mWtMEoO/I4wXLKLx9+wL+G0zZFxxPrY4O+/KZ7V21SyLx5Eiw+agfzypLU53
	PWrgMFFFVvv5mZ/nqLZZ7iATlOp+ty3caVvswb1ohh3xkxHTwUDEEpxPZXXh0tyhAStTvN
	9Qj7Fz8qOiZnVS10epDWXDvRpXrfySs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQuW8lKu;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783499933;
	b=oCITIg95XzXYk8Mkee8cfyQL0oCIN4qyBixaYziTOmDEeY8wihtP2IZDBsk6O+wXOT5xL7
	KxsDVPQ2ygY73i/L4rxSCmqinpZnaKnuqmpcqVZ2wwWIH5nzKJJ89iNO/kBxWI4JZpI7xO
	Zqk0HtxmGJf4lzfbqxYgkCDR0e/5Tx0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDB6A405AD;
	Wed,  8 Jul 2026 08:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708781F000E9;
	Wed,  8 Jul 2026 08:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783499932;
	bh=P8RJBNwkV593NAki7eRp3qI3mSkpI/7Fgbb1+OQ0jog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fQuW8lKuHjl7eVqUW7vgi6CiSNyoRA6aWsPWr0+BhawgVvzZ5/KvTt++5fPrF4q/B
	 2O/ECDsfjSvTP4Was+No6lmG1w4QTTNztQW/lP5sZDqhrH6TuEyuc420thK0+R7LRg
	 xfwYc5Gdp2pJ7kZ3LJBB76OkNaYeqmw0i7yhLcVF7OxwXHhn4DeDJPOn9o+cyhExxV
	 YQDMZx1g2u3XPDYqdW3gOlf2qYezEOakYMUFiF8i/RGYNdG/054EI549XwvNjMps88
	 6UjrZxaItnOoW8whBCwTEHfFpLMs8QRPAWOsd/UnoMpsMUz1JLOHwKZTcDKz/A8et2
	 CdaNhBMPb1aaw==
Date: Wed, 8 Jul 2026 09:38:38 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com, ryan.roberts@arm.com, 
	vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	shakeel.butt@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH 0/3] mm: handle device-private PMDs in walk callbacks
Message-ID: <ak4MZGAq30PN7iHn@lucifer>
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <ak0FtLIlTyCo_8lB@lucifer>
 <ak2DwhWUkk7lgeId@parvat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak2DwhWUkk7lgeId@parvat>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F3B140002
X-Stat-Signature: bjnkxw9xc5qmz5gpoz6xnbn4rsry7a36
X-HE-Tag: 1783499933-757259
X-HE-Meta: U2FsdGVkX1/c/gzAFBtELfytQLf1GddjYL4XE61D/AHCxx2/WeMzPXNxzFbmlZ5BTd+AUbwEb1k0UzF3tEecwQXYB7cyQt7H8vdC7T/58HxAvs5FrY90V64aSM62Lvf8TkanSj/ookLo8rQwEzL/pWIScmaOgusW7TSnxgMFpR95Iny3CrDOOX598D0354sCAkxlpTSNZRg6sKfx+hz1zEsFnYHrM2LUunetYelnhxQm5Uxa4A/Uejuevw0IQ+vPuUvzEZwp1pNw+O1Cj6UU8W7HousYYspFkL9jbmws5fqiCVzsTpweDtP0O6yAi2693oegNZEfXgE3gnsKfwm+2Aak9R101vfDVDUdgB6tVGPOoVHF3yc3hWxouKEjxjFBtUaoHcgs3ic+7enGr+Q77qaoJghXuXBNmLxnxy913pMiLIb/z2VhZBjwIWgROyx+RbfadOdIaigxRokkMqemYh64HS0k22z8P9deq9FuhQo7PdYebt700SdFerRPSXvAo2zsZ8EFoKRSWMOKdDevZLgDc9y1Y3+JgVUNGuTqsyjr8zoRDAnBA1S2jqrpWOUfMaXaprlQWvKBQLHMunUzkMlpw68z1UvOaBxMcdMbYeKTrQGkKXRR7sNUmxU3lGYnZTjtRSapyszylJLnOmSsZ4q3aE4seDkO8aoY+NO6maL04/WrUU6e42O+2B4HBx1eTKIke7aiOVlJ8gs6MbmzbgMSUyvsfjm6XqjV9kThqLoTthxwy5PihmaGO0RTRmCgwFk8FlcYbQBOoANtjExFPQvnGJTEHVDeMw3M27WdxR5opaZU5lZy0MncEaCC2iKA2w7ud/16LI8Iit2vLRdaLJxqYoSVmEohKwBfoeO7iapWr5CUisceAFpshWRJ1tmxfW/l24nJFY/dWoEcKSQgexk0cUNDg+gI1b2xWuMEgpjfvttOrJ6K6PIgmUOuK4xDMbs4EUKRF7ZtTJncjzz
 897FXTk4
 C7cgGo1Eu8eYWz2CCxBur93Mp3ev4ikdX8Eg44z72cpFELZcSBv/67ff9UitV9otPY0EL4pTmsR0ABVaP3x8Fju4Yf611jKl4dfi5DXzAiVd7UmAjtQFdclKGpR395SBILwWR8GWznzUHtGFZC9sdjUpwqd97q/b+9nQrzw7kBIyykkmXMOvS4umvkBI5HlNasWVVF4F8YI6QUeJjehWFBaX9ac8IHUCl2xqD9WrULOiXuqxxc/Mb/cGE1YvQpqTee4XWJaRa86+or7icZJDWPGpfUrPFiEYgUQYwCydrkhZgcSol0lTusudqJAPBCUpRtlvMOdo1BXSAlpp9tCNf/alpj6nS/QxS12RLREezsTDFCp+vMFI7vfxRu928GfyJufU2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 08:57:51AM +1000, Balbir Singh wrote:
> On Tue, Jul 07, 2026 at 03:01:56PM +0100, Lorenzo Stoakes wrote:
> > +cc Balbir
> >
> > Thanks for the series!
> >
> > I think Balbir should be cc'd no?
> >
>
> Thanks, my linux-mm monitoring has been largely skimming through the
> list. Explict cc's are always appreciated.

Honestly I don't know how you do it, I gave up on linux-mm a long time ago and
pretty much rely on cc- now (which isn't always perfect ofc... :)

>
> > On Tue, Jul 07, 2026 at 06:45:06AM -0700, Usama Arif wrote:
> > > Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
> > > to PMD operations") a PMD may hold a device-private swap entry whenever
> > > an HMM-based GPU driver migrates an anonymous THP folio to device memory
> > > via migrate_vma_pages().
> > >
> > > pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
> > > for any non-present, non-none huge PMD), so several MM walk callbacks
> > > that used to assume present THP or migration entry are now reachable with
> > > a device-private PMD. The results range from a VM_BUG_ON() firing on debug
> > > kernels, to an oops on a bogus vmemmap dereference, to silently isolating
> > > an unrelated live folio from LRU in the aliasing case.
> > >
> > > The first 2 fixes were reported as pre-existing issues by sashiko in my
> > > PMD swap entry series [1]. Hopefully sashiko won't point these out
> > > in the next PMD swap entry series :)
> >
> > Yeah I don't love these 'existing problem' reports (distracting from other work,
> > add workload, really it feels like that should be a passive reporting mode for
> > sashiko not arbitrarily added to other series), but sending it as a separate
> > series is indeed the right way :)
> >
> > These of course should never block an unrelated series.
> >
> > >
> > > [1] https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
> >
> > Hmm we've had a whole host of issues with device-private PMDs recently.
> >
> > Balbir - would it be possible to audit all of the code paths and proactively see
> > if there's anything else that could hit problems here?
> >
>
> Let me run through this and audit them. My usage of device private PMD
> did not expose them, but I can see a bunch of reports in the link above

Great thanks :)

>
> > >
> > > Usama Arif (3):
> > >   mm/mempolicy: skip device-private PMDs when queueing folios
> > >   mm/madvise: skip device-private PMDs in cold and pageout walks
> > >   mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
> > >
> > >  mm/huge_memory.c | 3 +++
> > >  mm/madvise.c     | 3 +++
> > >  mm/mempolicy.c   | 2 ++
> > >  3 files changed, 8 insertions(+)
> > >
> > > --
> > > 2.53.0-Meta
> > >
> >
>
> Thanks Lorenzo!

You're welcome! :)

>
> Balbir

Cheers, Lorenzo

