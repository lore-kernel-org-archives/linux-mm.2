Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE4FDCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0D56B00A2; Wed, 14 Oct 2026 09:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78EB6B00A4; Wed, 14 Oct 2026 09:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F636B00A5; Wed, 14 Oct 2026 09:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9423D6B00A2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:27:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E2D7C055A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:27:16 +0000 (UTC)
X-FDA: 85321308072.12.9B257B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 86A4BC0014
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:27:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nIe8xfLj;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791984434;
	b=Pr0WYqMMCvSuhuumDqzrvDdJxMi2q+8Pv9AakaqrhGaXBC6lfSTgBlG15IdIbB5ZAdKC1C
	sW9YkbRIiWOo+OhaOSlMi7O8Wkv/6XTfxD/hbtB5wCKgywQE98riwke7bKmOxVeAuS7TDA
	oquASRFrHjMslUKs1K/1SIe9fxAs7IA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nIe8xfLj;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791984434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Tm/Yqwl2DB6mmlaFYO9FOD6DsPXL83E73jBmWe1les=;
	b=2BY00u15MovP1SMQGH/FMeJn3NPpPbnMUDVgbd234YiLFil13oKzb9+mXI1nOwaru17JDl
	cz85jcSK1yPc4cBRyO9bp5Lzn/hpT08MzBB6l4Sum0awlfCkKGQzKCcexlNnZ411Tm21lv
	FXM7cUxYwipDw1C/5tod8Ut4DGKneuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA9CB4195E;
	Wed, 14 Oct 2026 13:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2F31F00898;
	Wed, 14 Oct 2026 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791984433;
	bh=7Tm/Yqwl2DB6mmlaFYO9FOD6DsPXL83E73jBmWe1les=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nIe8xfLjl1ADs8izT2EKBFqEJME8efDayDsg2tzwTBhwni8S4gwcjoNNavyi2ZgcN
	 lbVBB5Fy0kBQhCofz4oyTOOXj666OcqIU0vXayDeVxQ6XozZpVMApVvOOeLo91jvqR
	 kNBgpUl86oMAsFtOBswIqgPY5odKHHau8FUcMY3dN3pUrs3SiRBp5Jq2vEOKlLHqn+
	 Ud7PmAtIg9cas41d9WmHfE06a0sxn4NsmNynYgvdlL7zqMCJRVQ/E6L9l/neLLtNlF
	 6H3KbySuPjdK8eAkLw+sRE0tOnEU6xPd1blT1PYPwEwSdU7a+4dkYtOH8gRjr9cPk7
	 GqsJS/WDFCFug==
Date: Wed, 14 Oct 2026 14:27:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Ying Huang <huang.ying.caritas@gmail.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix address wraparound when scanning large folio PTEs
Message-ID: <as-BZibPscw4cxsD@gremlin>
References: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
 <as4kvHe9IFZH5qrC@gremlin>
 <9add8400-66c1-47e9-b5af-7a4081ebf3c4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9add8400-66c1-47e9-b5af-7a4081ebf3c4@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 86A4BC0014
X-Stat-Signature: jspneazhc5zxsjtsxm8muck19a1i3icm
X-HE-Tag: 1791984434-405047
X-HE-Meta: U2FsdGVkX199xXVhPp4m2JdYy8zZj7r4+i/cUDl6gm6JfMkyUT1RDPaCyCyY5tGurv63Gd9CW+zKC8OisZlJIOnCFTN6A6A8skdVaU33q0z4zUUZu06g9epAY5dl9ZPrOT3nsx4ChXxvkF1gmsNFkxtEZfEUOhXSY1a03VgInPrFREk1yt6fnG5ADZWKXFFYuD5IpmzZRDY2+hYQJgFW4xw7hS3jvyrd35XydSSrRZX4rjnVjjXBBvQaE7ZFDB/PwG6TObnRRykYj6kIMtB6GWQdMTBzgevzP7Fu75XU+pqSgh39f9Mxrh8Fwlf0XsUsSnTDurUQEEaCfeSMdDVavX4/+0GLqBNDI0WQ/eoBOCH/opzQ7A09rGZmUfXXGUG19/dqiAFLqf2FYcLba4IrcFDbnxUaBUo+YxkQbU0iKxYcjdiebG9oWIWMID/1dZpRo9eG/h5/qEHb4+aL3icw5+qICVuiuyNXcQa2iOPGVF2Q1YJroYuvo+ZhuFk+dFsZU0SLUxvSjQf2rPrEbpjneEILugTyA90K6PPIWFM/9dQfMQnxr/Cqwu+KrgoPrpfD4zI6IOZKU8xdooFrvfC6LqZt1p6rKa/ovA53XvMK94XqAOMGxxP/fpzi0dMLofzQVftQ1qo6aNJV+Ny5l2oqaBVS8UDLfhK9zeJZCBpf7b9Tmke2t0+m0iZ33FiO4h1n2KvVMA0uVa3179cpokBnTO5UwrEehH5iD4N2ZNICYwThzT5US+QP4fMrEG6JwLN0SJp09AsDQ76Wph2q2mrVuMiszA1PCVJlSXo40wPaWi5cs46FbZTC7ic3bCp18Yc9HaPOk0QCWVorNPdPgfU3VsOrQy8P10EgnSP+f+/wQ8jBDydXZJeu+Jdl63Jm4/O73MmbicedT68qrfKT4uEg+nssZboSq6GKpcHp3mv5tQE/5Z7pRgwUDsLt0RdAtbA0dIYSdDFlrebvUtuFRlp
 aSRM/Nvf
 B5GVn03H5b0ge2fMH+rFtY+TFhXEJEQwrB2X94rUY5x96ljBH9epDemm4YDmUOx8tdj3rFF0wQyaldFM9BVvTHvvlmeyGqXOzzWEtSUvHK3lzgDvzeNHSWn86+6KlMJcTdaPifhmMDdsZqRi5X7ILyArsAkJxgUd9ogSsqKLSDN1QiVWjlif11H+I8SVNqll5bxy59A/YphcfmGWGfMmI9N6DwXnXv3YkYqZgvRS79UO0SomgzF5kKYTGHrs0ZsQl/mBMk13ODkC04ScHI+C/K00CP81RmpdS4CLrA+GrPFFk5aMDHlb5mpEB6JdTpZgHwqnbmZilKrrd/F1XI7mlanMQIxoJlEV6sQ48Yk9W0ZQnYG0pNvwxGqD1mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 10:12:06AM +0200, David Hildenbrand (Arm) wrote:
> >> Reported-by: Kyle Zeng <kylebot@openai.com>
> >> Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
> >> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Since I'm convinced the logic itself is correct:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

This cycle is brutal enough not to hold up fixes :>)

> >> diff --git a/mm/memory.c b/mm/memory.c
> >> index 1f5d5f7d39cd2..a3823010aa981 100644
> >> --- a/mm/memory.c
> >> +++ b/mm/memory.c

> >> +/*
> >> + * Get the address range in which a folio might be mapped, assuming its pages
> >> + * are mapped consecutively and the folio page at the given idx is mapped at
> >> + * the given address.
> >> + */
> >
> > I know it's a static function but kdoc here might be nice given the number of
> > params, including 2 output parameters.
>
> I had that, but decided "not worth it for an internal helper".
>
> Is anything here really that confusing to understand in mm/memory.c context? I
> highly doubt it.

I mean I found it pretty confusing :)

But this is a nice to have it's not a big deal.

> >> +static void folio_pte_scan_range(const struct folio *folio,
> >> +		const struct vm_area_struct *vma, unsigned long addr,
> >> +		unsigned long idx, unsigned long *start, unsigned long *end)
> >
> > I don't love the name - to me it implies to me that you're scanning the range.
> >
> > Maybe clamp_folio_pte_range()? I guess though clamp implies it limits an input
> > range.
>
> Ugly.

Yup, fair enough.

>
> >
> > Maybe get_folio_pte_range()?
>
> I can just call it "folio_pte_range()". Slightly similar (but different) to
> "folio_pte_batch()"

OK that works.

> > OTOH, that's pretty ugly... :))
>
>
> Not a fan of these semantics.

Yeah on reflection not so great, I sort of talked myself out of it a bit as I
typed...

>
> >
> >> +{
> >> +	/* Stay within the page table and VMA boundaries. */
> >> +	const unsigned long pmd_start = addr & PMD_MASK;
> >> +	const unsigned long pmd_end = pmd_start + PMD_SIZE;
> >> +	const unsigned long lower = max(pmd_start, vma->vm_start);
> >> +	const unsigned long upper = min(pmd_end - 1, vma->vm_end - 1) + 1;
> >
> > This is trickier :)
> >
> > I guess you're doing this in case either bound is right at wraparound
> > somehow?
> >
> > But then couldn't the +1 push you over the edge?
> >
> > Oh wait no, because then vma->vm_end would have to equal 0, which would
> > fail the other-place enforced invariant that vma->vm_start < vma->vm_end.
> >
> > So it's pmd_end that could overflow, hence the -1, +1 dance.
> >
>
> Yes. It's fairly common, though, to handle clamping of exclusive ends that way.

Right, it took me a while to figure this out though.

It involves an implicit assumption in there too, that _one_ of these values is
known not to overflow.

> > #define pmd_addr_end(addr, end)                                         \
> > ({      unsigned long __boundary = ((addr) + PMD_SIZE) & PMD_MASK;      \
> >         (__boundary - 1 < (end) - 1)? __boundary: (end);                \
> > })
>
> As replied elsewhere, I had that, but decided to open-code as pmd_addr_end() has
> very weird semantics with folded page tables, where we just don't clamp at all.

Hmm how so?

The logic seems, at a glance, equivalent?

>
> I'll sleep over it, but to me using pmd_addr_end() is not particularly better.

I'm not going to block things on that basis as we have a bug to fix here, but I
really had to sit down and take time to understand any of this.

> > 	*end = addr + min(max_remaining_bytes, folio_size(folio) - offset);
> >
>
> Sorry, to push back, but are we overthinking this helper here?
>
> I much rather get this fixed quickly then fine tuning some details in a helper
> with clear semantics that anybody can understand when looking at it for 1 minute?

As above, I tagged it, for the purposes of a fix let's just get this in.

But no, there's not overthinking IMO, it took me a long time to understand what
you were doing here, and there's a lot of implicit understanding in there.

And while I don't claim to be a great genius, I am fairly familiar with mm code,
so that's always to me a gauge on complexity.

Anyway, let's get this in, and we can debate the details upstream at our leisure
:)

--
Cheers, Lorenzo

