Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 840A9F46113
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640836B0005; Mon, 23 Mar 2026 10:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617B26B0088; Mon, 23 Mar 2026 10:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554716B0089; Mon, 23 Mar 2026 10:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 445D66B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:01:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE6358CD9D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:01:01 +0000 (UTC)
X-FDA: 84577489122.12.4EADF64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E1D474001B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:00:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZ0H+ebB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774274460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPfpjo0CdystTKMP1hnmvNgKtkEKjhwBJq1uiXL5b+E=;
	b=JuxqmN6QdpjZ8ygu2l2Whh9HmC8d05+6rbRUwXE8wLMr+aM5rsvRtlk9kER8h/FqYOQCAm
	p0AnoFE7l9x/EMWWkIbm2rtRkrhPFbhEjnMMI2pIUAceOLNSMoB9RHMMNM5RDZaerjDZbz
	GGKgF7+eLAdkQDNEQiq7hOLQXi7mbBY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774274460; a=rsa-sha256;
	cv=none;
	b=e9f7oI60BTOG0El2FpICzXII/A3coYYvTkBI0p2s1AH/Bain0QuqZ82dTDsZpchiUqZ7dx
	FwltMOISzTvn2v8Pe9eyClLb3LyEDn6J9qe1iov+O8nvj5jeA8jSnpX2O0KvQldngpvMF7
	3IBX8BwwT+f+Ahm5pHwnBWyV7eguPAg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZ0H+ebB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF33743D20;
	Mon, 23 Mar 2026 14:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D756BC4CEF7;
	Mon, 23 Mar 2026 14:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774274458;
	bh=GN+aQtFvX93m6F1AZF/qXvzTDG1AkJK4lgDiQPanc1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gZ0H+ebBjC6Z2nvISQYqqvuS/fIt36YPcVPATAf/w3pQwnqfQckBpH3KO4bK6Oxpj
	 H385dEDwruCFbIaqhvFLKIwHeKTCjERKxWzlpCll7bjXWnSRqaTVCflOjkrDCqDPr8
	 cYT/Ql2Fkjo25TvXsYyILHPyupNDaztaM2u9vOGXmp4HKp/hgs3p4GZCbhoFewcDMo
	 RfEbJoXyhXcGI5gtQ8u6b8e2nZ2o5Wn/hMaiLFd44wOt8fuoHcsGMff+vASTcgC7gP
	 LhH0jSnMy/RUaKvlBxWb6Hun+y0qD3cjMWWziO5qaiXBAZwhgnInuguzLenWPLfa3E
	 Nxn//p/JlF00Q==
Date: Mon, 23 Mar 2026 14:00:53 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 01/15] mm/memory_hotplug: fix possible race in
 scan_movable_pages()
Message-ID: <33dedf0c-d394-4f81-ad29-03ca88703e3c@lucifer.local>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
 <20260320-sparsemem_cleanups-v2-1-096addc8800d@kernel.org>
 <5b489c40-bd89-4dff-9669-560b1b28ec69@lucifer.local>
 <4caebf3b-8924-406f-9b92-909cf86ef669@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4caebf3b-8924-406f-9b92-909cf86ef669@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E1D474001B
X-Stat-Signature: fqauw3beh5ipkq8cmjkh1woumj79u8e8
X-Rspam-User: 
X-HE-Tag: 1774274459-361506
X-HE-Meta: U2FsdGVkX19OMa70yG1/tJA298LGLMvgHhxmRmFbIjXMxt5wY6srriSxw4zBsFbTCJ5Ft/VUmMVw4M+5oWf7l+bw2I03xOK9/1qmdClY631vsd85VT2gzm16cHeL5UyZ4sprq+MlZUstKervCmlHxIvLpl+qbfpI7pEm4G9SfJOH4mwa0w1X32bYCCjVpeYvMhN/Sb8Kr2x/cVaTJCN/2Dm6Ha0Smf8D6SrZO7xm/pO4MJI5X03eG50l3HibSvU5Fw7ddDx9gqHcYYuVQKl2uD91gyz8BZMgFLOhfTr5iISFYMfVBYPjcMbgBBqCf4ZGpxShRDPWBsU2YQY0Rh9xjA8S9rzCjAPD30YC7DAaNv04Ss0S4X3N+j0mjXBJm3Jgix2YtA3GoVl8hFI9w4uQQE0ghnB6npvFaLueO1/YoHfgg+mr6kupSXxyJQgOfgMR0M5bNdeHcTRWbEsDEwY5qhjxIOquAwqUU5NzmIFzGmDEXc6mI+ctC3a+tmzmgNm2AjLxzYbVprm8dWNu5Dod/r+0yqlHPi5vpdzhQPXyzmW7XzBq/y+USs9C7rSz1zCIxbCeBScOJUjx4bSJxkxK6ZZgI5ww9ahU6+68JLIb9PybtQfcU8JiNBf5PW0R9lXFxyW1dAVsb9jHs912h1Tz7EWK78m1+Phkql7ayQUhSz7nIzxlg2FaBLy+VaeMykStGs674U6bA57/jgo9ieR4Xq5UVJK10XlGSJKoma1At36UcWcrHpEKbUx136qw99SWThLsKzkoMUEDot+UevAFINYTBX0YnQL2B1OoydVLFe5ohDBo8/PdKZrjK3HUYLTrteiAFXuRqPJeNdxE64oEoegfIZO8q0cM2J+2B5k7nbqxcFhMj2Xc5RTIFJyJc8oecNwawvuCC473ypxZvlsZsWX5vSI8IBILT1g3+R/KM9Q7sJDTBxUjDYoeb8YaVDWJ6OhGE5M6GEDkgMoCnhk
 KtuIpYzy
 mCVklBLtS0xYuca3M/SYz5Kf2wH3N/O9Q6SZWPYeb7pHFRYxyo9to8jEsXto1/W8m3vc3P3P5IaRIN1gu9ucy1UyYypxNpIESq3sDwNOoTZ2x7A7OLIt4wZKAkl8hpHs0Ln/r6q0NI7sFI5ZZNT72NJwDlWMcNgnos8LRr5tsiVMSM8/yEeC0b4bM3Iu5i73LsYQKT9yyH8wBuD1Gfi1C3m3CqaVtVAZ5Da2TiRDjI3Ec/pOyVueaja0xaf6Mgv1Fto6uFW3c+YJA7gEuvTo+8LNRwrFTMJQ1pQ6u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 02:40:16PM +0100, David Hildenbrand (Arm) wrote:
> On 3/23/26 14:26, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Mar 20, 2026 at 11:13:33PM +0100, David Hildenbrand (Arm) wrote:
> >> If a hugetlb folio gets freed while we are in scan_movable_pages(),
> >> folio_nr_pages() could return 0, resulting in or'ing "0 - 1 = -1"
> >> to the PFN, resulting in PFN = -1. We're not holding any locks or
> >> references that would prevent that.
> >>
> >> for_each_valid_pfn() would then search for the next valid PFN, and could
> >> return a PFN that is outside of the range of the original requested
> >> range. do_migrate_page() would then try to migrate quite a big range,
> >> which is certainly undesirable.
> >>
> >> To fix it, simply test for valid folio_nr_pages() values. While at it,
> >> as PageHuge() really just does a page_folio() internally, we can just
> >> use folio_test_hugetlb() on the folio directly.
> >>
> >> scan_movable_pages() is expected to be fast, and we try to avoid taking
> >> locks or grabbing references. We cannot use folio_try_get() as that does
> >> not work for free hugetlb folios. We could grab the hugetlb_lock, but
> >> that just adds complexity.
> >>
> >> The race is unlikely to trigger in practice, so we won't be CCing
> >> stable.
> >>
> >> Fixes: 16540dae959d ("mm/hugetlb: mm/memory_hotplug: use a folio in scan_movable_pages()")
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > Logic looks right to me, though some nits below. With those accounted for:
> >
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >
> >> ---
> >>  mm/memory_hotplug.c | 11 ++++++++---
> >>  1 file changed, 8 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> >> index 86d3faf50453..969cd7ddf68f 100644
> >> --- a/mm/memory_hotplug.c
> >> +++ b/mm/memory_hotplug.c
> >> @@ -1747,6 +1747,7 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
> >>  	unsigned long pfn;
> >>
> >>  	for_each_valid_pfn(pfn, start, end) {
> >> +		unsigned long nr_pages;
> >>  		struct page *page;
> >>  		struct folio *folio;
> >>
> >> @@ -1763,9 +1764,9 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
> >>  		if (PageOffline(page) && page_count(page))
> >>  			return -EBUSY;
> >>
> >> -		if (!PageHuge(page))
> >
> > Yeah interesting to see this is folio_test_hugetlb(page_folio(page)) :))
> >
> > So this is a nice change for sure.
> >
> >> -			continue;
> >>  		folio = page_folio(page);
> >> +		if (!folio_test_hugetlb(folio))
> >> +			continue;
> >>  		/*
> >>  		 * This test is racy as we hold no reference or lock.  The
> >>  		 * hugetlb page could have been free'ed and head is no longer
> >> @@ -1775,7 +1776,11 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
> >>  		 */
> >>  		if (folio_test_hugetlb_migratable(folio))
> >>  			goto found;
> >> -		pfn |= folio_nr_pages(folio) - 1;
> >> +		nr_pages = folio_nr_pages(folio);
> >> +		if (unlikely(nr_pages < 1 || nr_pages > MAX_FOLIO_NR_PAGES ||
> >
> > NIT: since nr_pages is an unsigned long, would this be better as !nr_pages || ...?
>
> It's easier on the brain when spotting that only a given range is
> allowed, without having to remember the exact type of the variable :)

Yeah it's not a big deal!

>
> So I guess it doesn't really make a difference in the end.
>
> >
> >> +			     !is_power_of_2(nr_pages)))
> >
> > Could the latter two conditions ever really happen? I guess some weird tearing
> > or something maybe?
>
> Yes, or when the fields gets reused for something else.
>
> >
> > It would also be nice to maybe separate this out as is_valid_nr_pages() or
> > something, but then again, I suppose given this is a rare case of us
> > checking this under circumstances where the value might not be valid, maybe
> > not worth it.
>
> I had the same thought. But this code is way too special regarding
> raciness that I hope nobody else will really require this ... and if
> they do, they might be doing something wrong :)

Yeah for sure, it does seem unique to this situation, so probably not worth
it!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

