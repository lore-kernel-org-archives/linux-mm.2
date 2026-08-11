Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2336AC5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D406B0098; Tue, 11 Aug 2026 09:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096B26B009D; Tue, 11 Aug 2026 09:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA01C6B00A3; Tue, 11 Aug 2026 09:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B64336B0098
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:34:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D63C40432
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:34:15 +0000 (UTC)
X-FDA: 85089082470.29.EAD9587
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 871A580014
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:34:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BxLWykSJ;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786455253;
	b=7bqlMWgQgombD0oUCL4083cWPAfAyeedAy2ehBhjdM6qctXRnhF6423jW6K6A4CDQn1cSD
	aunZ2jM2IWjyAc+p13SQsC28M2VUwPgAw93FPLDKxjkHABMAB0c3zjxlI4FomOmUvPVcd6
	IgcAaXD4Q03tGLw11pa+6sR3mdEz8EU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BxLWykSJ;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786455253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqIXDqrw8oYOmDkaTwdVQwShIjjzl5wSUAlKKnpj5I4=;
	b=XZ+c9MS2B+vRfZ7pXyv6ensPVl3KCrWtFMb3kkPeu7+bQqZggo6xvaZ1Ym8a8g/DgAK0Dx
	aDny0wR2loT+61DY+M5EV4YbdtF+LzBmUuKMJJAlTiR+VacuUyaqS0+mEraO+8E+0fhcWw
	ZyRTItFZwzBRjJ3jPcl8Dd82njBX12Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F00B840264;
	Tue, 11 Aug 2026 13:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203D91F000E9;
	Tue, 11 Aug 2026 13:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786455251;
	bh=bqIXDqrw8oYOmDkaTwdVQwShIjjzl5wSUAlKKnpj5I4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BxLWykSJ0ZeTjyaJFLJmd3CS4KqDBLMESXbjRfGoUkYaTwm/uJPT6QYVxHtxC2eG7
	 sw8kmor8DZl1HJn+H2GYtgsd3prexT6eAAKYBjBVE1dbXPHZenSZlgdxQmKOKbW20I
	 /e77S2PW8eey2UzfiFcONjEbiK9a1DFpsQtFNbpBFZBMdRzPstjuPA0bJ5F4PH+jPY
	 7NeWxeern/MDmL0U+wOXEgly+js8cZh17BrMODv6OQZAagHfPVWck8bKCueuVef3yC
	 psJU8yuyn2AXpojYzGIT7U3FPDQJcyturjUgIqlgzahJxNO6I5ckR2YTHF2+G8SBQi
	 s2q/EjUJ3pi5A==
Date: Tue, 11 Aug 2026 16:34:02 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	rmikey@meta.com, riel@surriel.com, kernel-team@meta.com,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v5] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <anskyrEVUlnTVEgF@kernel.org>
References: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
 <ann9Kcesyb4T9Z8b@kernel.org>
 <anr59P1ZCAuHxv6x@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anr59P1ZCAuHxv6x@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 871A580014
X-Stat-Signature: 86poapgb4nut55erpfba7z1b7dgbddwg
X-Rspam-User: 
X-HE-Tag: 1786455253-957576
X-HE-Meta: U2FsdGVkX19vAwR/aOPCUVjiRx0SWtVBv1W3LgKuP60HptMZb5rbDM6qs8sg+QqfOTlVw/CB/3c3rcH6/LirF30ndpBRGjWSTqxuVroCwhIAWHrFgmjeGTvm1tclvxfntuvPMCtKyTZHv1TOaMee/XrG1OSpvKfL8Ya7PlxGVE6QFXyihXepAHLXyAj92zCrnFKQ2iesNVyqUueN9hRR4yKWRYC6fVkxNjrzGYnjAeJpI8AnrjjwZDdeGS1CyUnvO/5FSr0agrUjdOy3OF+HWZ5lyFJ5S3zDyJmJJEZwZt33mcRf0IUm+wPRbI2a0RYG1S9/d83IbHD7mhdiiz0YTU9xEUE3zmYzTpgP0hJ54XkbCqFqGOQ48mbrUvniGSJdE7jnMDAFd+nazFU5Ta06GE4YC/v1vL8s2noY/AbcB4VE3ZW/tM1FMoq2yudgpI5jHt0GTyQaZWfLPzbMPn+I3L530/8UuX2okfrguadk/i2tnUPEwYFb+dce1Xf2ivep7//OC3Z+06hfS0sBLoj03ZeT2orAArIVlEVgnL0u+bhYru5ChyaGcwqus+E5+w7L3LTHj+1RPt5bHUg8+HrAdiIOUPLZJzELB6YAuA7mXZAhp2+A5JQ9rb0V+8lbkYDKoz4jrxpVOMKP6Iw1XxT1cmhKQk1b8MbgYQnQDXBjus0Hd78ff0RHt0lJRf61a/QRuNJIoD+co+7T0KDyj9Ypelf2x/TzEpp9COW7jTcsLUC1/ZDGe28MszDuHmx6/TI5vbof+q9Ll7MvRJDAvEfME8kCZI9/iuDk/rgQd4GFl6L8cWUejWPQvnLNwK77rV5iKLsu2cQvIInIyiKMMYeTjDwGWUGddy1uSgJsKRj9zMAd92IBRp8VoH3C4pcsGRAYDuhik2fLvmt2RB0QtQGd4VF+bbB8hUKu4Nz1bLqbgWJrLOdM2jlE+Pg3wrJmCio/3lfUVL+92X5pEyEor9H
 gkJa/0B6
 P1zPZRd56zJimNr9OWH2nIKEAfIy2Jk6WFC6r2i0C6jBRskWB9SwGunS125FuV2M3lkEK2rKGzf990avaqXdRH+4Yk5YoefExjIIUKmK7tpbShXjAlJYCPPlxRkhFQyoq8Khfhrl4HHICv+WCordC9SM5XkLLVBudMMj4fnqeRU9vV3Soc1lB5bWwsXSgkWHxe5R7TmhVt+xtTr0MHGMjnAv7oHejkkSVW5kLzBlGLS1tTr/Rh2IbuCqs5tjhypVp7r67TJNNSZhV+8OtyuIuIPOUFAqza0sZAeZjyiGvBi952IAqQNcBdNA7azXS2vfa2rFwzRSuxUzlRgApR2Hr8xBeJgx94fuv3efN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 04:17:41AM -0700, Breno Leitao wrote:
> On Mon, Aug 10, 2026 at 07:32:41PM +0300, Mike Rapoport wrote:
> > Hi Breno,
> > 
> > On Mon, Aug 10, 2026 at 06:32:04AM -0700, Breno Leitao wrote:
> > > Memory failures (such as unrecoverable ECCs errors) are getting more and
> > > more common. The kernel knows how to handle it while running, marking it
> > > as poisoned (and SIGBUS user tasks).
> > > 
> > > Poisoned memory is removed from the buddy allocator, but, not from
> > > other places. A current problem is that kexec will load new kernel
> > > on top of a bad/poisoned memory, which is undesirable.
> > > 
> > > If the next kernel's image, initrd or purgatory lands on poisoned frame,
> > > the relocation copy writes to the bad memory and the machine checks
> > 
> > What does the machine check here? ;-)
> 
> Not sure I got your question right. Did you mean:

I meant that "and the machine checks during the kexec" reads as machine
checks for something and that something is missing.

"machine check exceptions" would have been clearer :)
 
> 1) that there is no machine check exception when *writing* to poisoned
>    memory, or
> 
> 2) just that "the machine checks" is a lousy way to write it?
> 
> For 1) I think you are right, and I had not thought it through. The MCE
> (or a recurrent multi-bit ECC) would come from consuming the error, so
> a load or an instruction fetch, and a store may well pass silently and
> leave the poison sitting there.
> 
> The read back is what gets us, though. 
> 
> So the sentence should hang on the read, not on the copy. Would
> something like makes more sense?
> 
>         If the next kernel's image, initrd or purgatory lands on a
>         poisoned frame, the relocation copy puts them on memory that is
>         known bad.
> 
>  	  The error is consumed on the first read back, whether
>         that is purgatory checksumming the segments or the new kernel
>         running from them, and that is what we want to avoid.

I wouldn't overload the sentence, just 

	The error happens on the first from a bad page and that's what we
	want to avoid.

looks enough to me.
 
> > > Skip hardware-poisoned frames when placing segments: check them in the
> > > kexec_file hole finder so it lays the next kernel down on good memory,
> > > and reject a poisoned destination in sanity_check_segment_list() for
> > > the kexec_load path, which cannot relocate.
> > > 
> > > The two hole finders walk in opposite directions, so each asks for the
> > > end of the poison it has to clear: the top-down walk for the first
> > > poisoned page in the window, the bottom-up walk for the last. A poisoned
> > > hugetlb folio counts in full, as hugetlb keeps the flag on the folio and
> > > the poisoned subpages on its raw hwpoison list.
> > 
> > I had hard time parsing these two paragraphs. Can you please add more human
> > touch to them?
> 
> Sure, but that would cost more. :-) 
> 
> What about something like:
> 
> 	Skip hardware-poisoned frames that were detected by machine

                                                          ^ memory

> 	failure subssytem earlier when placing kexec segments.

               ^ subsystem
> 
> 	To do so, add a helper that reports the first or the last poisoned page
> 	in a range: memory is walked top-down by locate_mem_hole_top_down() and
> 	bottom-up by locate_mem_hole_bottom_up(), so each direction needs a
> 	different answer to jump clear of the poison.

                          ^ stay

> 	kexec_load() gets its destinations from userspace and cannot move them,
> 	so there sanity_check_segment_list() just rejects
> 	a a segument/memory block that happens to have a posioned page.

        ^ single a 
> 
> 	is_page_hwpoison() also covers hugetlb, where the flag sits on the folio
> 	and the bad subpages on its raw hwpoison list, so a poisoned hugetlb
> 	folio is skipped as a whole.

I don't think we care here about the list of bad subpages:

	is_page_hwpoison() also covers hugetlb, so a poisoned hugetlb
 	folio is skipped as a whole.

> 
> > > +		poison = range_first_hwpoison(temp_start, kbuf->memsz);
> > > +		if (poison != PHYS_ADDR_MAX) {
> > > +			/* we hit a poisoned page */
> > > +			if (poison < kbuf->memsz)
> > > +				return 0;
> > 
> > Won't we break out on the next iteration boundaries check? I.e.
> > 
> > 		if (temp_start < start || temp_start < kbuf->buf_min)
> > 			return 0;
> 
> Kind-of.  Sashiko keeps raising this underflow in the function, on every
> revision since v2.
> 
> It dismisses it on this hunk because of the check, but reports it as
> a real one on the two "temp_start = temp_start - PAGE_SIZE" paths above,
> which do the same subtraction with nothing guarding them. 
> 
> Happy to remove it from here and send that as a separate patch.

Let's make it a separate patch please and drop the if (poison <
kbuf->memsz) here.
 
> > > +	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
> > > +
> > > +		cond_resched();
> > 
> > cond_resched() for every pfn is too much, isn't it?
> 
> It is what the other pfn walkers do: the kpageflags read loop in
> fs/proc/page.c and read_page_owner() in mm/page_owner.c both call it
> once per pfn. 

I think it depends on the pfn walker, some of them cond_resched() once per
"block"
 
> But I honestly don't have a strong opinion here, though, happy to batch
> it if you prefer. Would this one look better?:
> 
> 	if (!(pfn % MAX_ORDER_NR_PAGES))
> 		cond_resched();

Can't say I know the magic number here, but I think it's better to batch.
We had a related discussion with Muchun a short while ago:

https://lore.kernel.org/all/ak97z4tryYAGJgb_@kernel.org/
 
> Thanks for the review,
> --breno

-- 
Sincerely yours,
Mike.

