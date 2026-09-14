Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B5CC88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E17F6B0096; Mon, 14 Sep 2026 10:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9116B00A1; Mon, 14 Sep 2026 10:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D16D6B00A2; Mon, 14 Sep 2026 10:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 203A46B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:27:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A641EA0100
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:27:35 +0000 (UTC)
X-FDA: 85212596070.22.26E335A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 07491C000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:27:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGxPcdJI;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789396054;
	b=mj2PZ8As++E1PoPLsgZyERFh5+FGgrM7BNXFopPpSVMcY4VUdoY5ymWMgsUNuKyAfaQNaQ
	cpDIJeGjjqgyB5PWLZATpA+7jKg2hsOgz6ZcHDDDz7z3z/JGgOT7FL8dsWa6hThmQmUM/m
	ObcMMPkZ114YMtfezWDFmyDey/LxYvY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGxPcdJI;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789396054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eufZ+ASnYJyxNHhoWXf4wfzOU/TuE1+5JzkzXKdwlfw=;
	b=fcVvcJWJWb2NvmJc+U0sBhNXfCGSlMAwupUodmkKlVCeIUjAmm6jDYm9TonKLBwnDLOUaG
	HxD0SUKEG6wiCU+/eruWQ5N5VV6Pf3JYMZo/T4ZpTxE+VYZO7BgaZLP9ONC9F3VwcMif8E
	NNxogXOZuhE2KAwB67O4bfF7X9wmfJ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 350924324B;
	Mon, 14 Sep 2026 14:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7501E1F00893;
	Mon, 14 Sep 2026 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789396053;
	bh=eufZ+ASnYJyxNHhoWXf4wfzOU/TuE1+5JzkzXKdwlfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EGxPcdJIgOssQEo0tzrSTwkEyUomMpmdg9u3TDfpxTQ2aaKynjVOPP95OoRNaMjK6
	 oz+iwBn8DWpUXme+Rzn6y/SZqjLgbvwRzsAawM2fznuutVD1x65tgqNcNuAXo2s2fx
	 8BJ2lpHKrwO3E7w9ziopxFfvdD7FTXnaMu/BUluyB/YnMLGpZO++qvx3LMdxlIUCax
	 EsqaVnunCK6ujBp040prnEiNo69vamvyVHWW+UfV/KHsuEySwjSYlXiJRoNSKcY8S9
	 y1KtHQIUY8EkkaJZ+rSW4hD6hDy8hP6GYu9gJPMs6O26VrpW/pwVwXEyAThOsPK5RI
	 NKHcn22skIEUQ==
Date: Mon, 14 Sep 2026 15:27:23 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Mark Rutland <mark.rutland@arm.com>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	"David S. Miller" <davem@davemloft.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 27/39] mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
Message-ID: <aqgDqUuxX-7l8j5e@gremlin>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-27-dacf19cce22b@kernel.org>
 <20260909130141.2c5d250d@p-imbrenda>
 <aqFDKJlj76O1hR2R@gremlin>
 <20260909152055.475f053c@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909152055.475f053c@p-imbrenda>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07491C000D
X-Stat-Signature: 55bec83tryepgdujxgzumtmbkd1fhoco
X-Rspam-User: 
X-HE-Tag: 1789396053-390736
X-HE-Meta: U2FsdGVkX19s8D9+cdpviCv7oOccFhcikYTRknRJpfQ8RRR2FDpG9bO3hzt6UVPonMAWWC0C0Av8puSrGF54zDfSNgGmWrVi03tbbreLD10vRqOt+5GYD4YaKYG2AW2FI+1ocI82M65XwcLjHJY/TWQK20/uxM5gI+mTVFcX84IfDj0I9UfgmLmWFcEiJh5emliB+YDDIZMV/87gU/eeqf8SnzxpMPvzf5IQE/mMaIgVHvN5aNdXWvSXHJdLxIukq8Jt00LccZKRIqsq9hCexJHADpR4M6Ss/+Xgl9Ubw7x434DRNfndqhipctXd68b6CvCuigDNTgnJxbJwK46pH8SWQ1NqwrVPysbw7tXw3hGh51j1sq+MdLtzxdOPGKh2w7hkApihwjClVmAEaL3N7ciXYofKcYMkNNeieU8ntj0PrFo6AdT7Mn4nW4BRwvdc9nT8JGrrRGyaEHKv5REuB6zfXi2Snt3qo4Hc9UguvfsHfQ8BSvYYedWdVl+DJ4ik4n6NGB3nfTQ1MTqNMPj9dVzRMdS831WYD4FacHUy3bwy2GmuwqYF+CKMHz/z3d+xiIb6ONvdD+HEynPrdTM0RcSa6NV+KoWdyKSXVCEJNLiX7B9TwiBV3nqpZzMkfTGtDUjAZNbJB83ZcH9RBF+T7zb88oP+igMZv/bwms5OrgHnf0IgXSj8NxESIeSNa3Q8gtsg04oB5j049aJ7eYdKiocMEVuvpIS/8F4o6/sg40BOaMIY7f4KtXqQJrJVSsC2IgeSgZwAdIhcr71ZJ89D58fDSKcO1MkRxGKGg50Ci7onwNkwhqCePFPL6SJQxm3H02bXLWj7lvZuRoSiYpCEYMa4uuMwaiAG3PAp1XaFxrUIjAcp6uNtufHj1FxUl7dQpNLcVy48kPJ8jVXky42sxOmU4OBMzf7aewRN0bNscIiD55YSoCYJ58mn0m7BIw1e3t8fY5LMCh1F8cNbap+
 DebPNqJF
 qkNv9Wi26lSWKmQln3hfQl40bQkwJK61h7kmWyEhoZHAFWwoAhudRCK1kHMFTD08WXCk9l9snx1KwrXh6OS5u5NaPQVTN+TvfToubb9OXWQLo+S5mBoRnMNqPYKf5vWMVB99zXEXCoEVAalOu9Y7w0dVbe+zx0f3Sv9iKzdG2YbJogHOt1/Xdk9xZFWtZRcGJKs3fsLMwat88NTt57ghbiZLFbMVPF3O5U64JCwCoQWAOGiQ8pAX0l6+1nTMqSG5B/W5Ha+VW97Py5b4F88hiQRjt0ZAJon9Silc4B4hRfGRBGCya0u6zh+orkGyKlKr/r3A8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:20:55PM +0200, Claudio Imbrenda wrote:
> On Wed, 9 Sep 2026 12:30:45 +0100
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > On Wed, Sep 09, 2026 at 01:22:07PM +0200, Claudio Imbrenda wrote:
> > > On Tue, 08 Sep 2026 21:01:31 +0100
> > > "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> > >
> > > [please note that I had to prune the CC list quite aggressively because
> > > my SMTP server was not happy]
> >
> > Yeah sorry about that, I already pruned the list a LOT from what b4 wanted, and
> > still ended up with a ton of people (I consider maintainers for stuff I touch
> > the minimum cc, but also added mm reviewers).
>
> yeah I did not mean to fault you, I understand why the list was so
> long. mine was just a courtesy warning in case people reply to this
>
> [...]
>
> > > > @@ -247,7 +247,7 @@ static int __gmap_helper_unshare_zeropages(struct mm_struct *mm)
> > > >  		 * proof to catch unexpected zeropages in other mappings and
> > > >  		 * fail.
> > > >  		 */
> > > > -		if ((vma->vm_flags & VM_PFNMAP) || is_vm_hugetlb_page(vma))
> > > > +		if ((vma->vm_flags & VM_PFNMAP) || vma_is_hugetlb(vma))
> > >
> > > Would it be possible to replace this ^ with !vma_can_gup() ?
> > >
> > > (obviously not in this patch, since vma_can_gup() is only introduced at
> > > the end of the series)
> >
> > Sure, I could squash that into the 'use and apply vma_can_gup()' patch. Will do
> > on next respin!
>
> excellent, thanks!

Actually this isn't quite vma_can_gup(), as that will wrongly exclude VMAs with
VMA_IO_BIT set, and I think VMA_IO_BIT mappings can map the shared zeropage.

Maybe one to reassess on follow up?

>
> >
> > >
> > > >  			continue;
> > > >  		addr = vma->vm_start;
> > > >
> > >
> > > [...]
> >
> > --
> > Cheers, Lorenzo
>

--
Cheers, Lorenzo

