Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 381C4C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08CCA6B008C; Tue, 11 Aug 2026 07:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065636B0092; Tue, 11 Aug 2026 07:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3D66B0093; Tue, 11 Aug 2026 07:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C285A6B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:18:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CDBC1603E1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:18:05 +0000 (UTC)
X-FDA: 85088739330.29.ED873FB
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id AD65840003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:18:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=m8UBuuRT;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5L98aL3Gaq0Oa3J1h7rtYhrwqEXKEC4NPIDmDwKQQE=;
	b=5yd1CdWJmgMe0rFFFh4wpiSk2ICPteHjW1xeiIAMUrfF8y6uOh+S8O13ZXeHDTvZuumsnh
	WWy4TbXsWT6krjeHdmmm0zbQd3UcL885w7ByZgXihn0KmT+ymZIT0+Fm+rVnfJ864mwoZY
	h74fW2Rh6cRh6H4iCj8Lyrp1SOELjs8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=m8UBuuRT;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786447083;
	b=yE1tIMxLnsE8h0XOuIGl+8RPPbpJIn4gJn1ZgRlgPePjbhpssZTQVGKIcZ+yV6NhjgyXvw
	t2l4FtCv5rUCKmNchz4ZBHMACa+STU+9YylNcGG4gMtsJlzzYrXnCY6NVo9itI/gvOXtiC
	6P1iKVWzuozhEn7qOLwKEmVrVQ2MA/c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+5L98aL3Gaq0Oa3J1h7rtYhrwqEXKEC4NPIDmDwKQQE=; b=m8UBuuRTXedkiO3V4fRfUD2kbt
	a/SkK1GFzjp95gHT40ScUNlBcaU814L3AdjJBTbHWkC5gWRRJ2if6KKMEZ8AVvkn5ZT/aGxkWkYf9
	xZG+IqWKsp4MwIqnczBmPDyt/nEiFhJn/JnypNDfJzgtZb8nPJY4XjtmvNgejzOYgqqxaTyZb6SjW
	hji09+ZiQiXSl12vNVnbcHzpU3c/qn65pOo1MFFZ92Z44WWrj6RehLL4/kTBWxkuKsCuy7RCJ0ixU
	b/qcVZvS7oYlFbATBAcJo1AGnoGpsubsaSlT9CKyqACjT5uAZab5EooNN97kq/Bresb6pTXTbGnDD
	/TubT9iw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wtkUN-003Wad-2h;
	Tue, 11 Aug 2026 11:17:48 +0000
Date: Tue, 11 Aug 2026 04:17:41 -0700
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Baoquan He <baoquan.he@linux.dev>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, kernel-team@meta.com, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v5] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <anr59P1ZCAuHxv6x@gmail.com>
References: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
 <ann9Kcesyb4T9Z8b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ann9Kcesyb4T9Z8b@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: q7xu8ta7t84p8uyxy35iiu4sn86mixrn
X-Rspamd-Queue-Id: AD65840003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786447083-600458
X-HE-Meta: U2FsdGVkX19sqpQmJ4Efh2ls0h80nOfHvKz0nnhnuEvRMJHRG5I0xZqEU+bz5xmM4/w3yDHTjrEiG9G6+ieilPMpl1siDtRzrYw8/erHgjXxyAAVqvYY3Xwa2XKVZ+RSHWFqxh9SHqDvFRUAtybO2pNfV84TuAjf0rb4yhy8WdrwGXVedifEh9J3spsrOzS1Yrw1ZH110SEZw9v8HI/Q+N86cWiKD1R2VL7DSCbLY0ugOrJpdxSKnqJTeAi90WtmF8xLea7U+TSSj/aWPmnGUkvwkfJR7i1U4N9nvcg+maT5O0O3nbnwLPBo1t4+kTu96QHtBZ5DlAONpydu5IAXLAXqpJG25hU5+lu1JERFgB99c16MKPoAjrKwHyxkuAejtQ+KjSRS18qnGWeRZ4cpuxMhWF6QgRISRzL95d0T87g7xqQ2Sc/qwEBQ/+wC/B0z0QWXIssQxFjbUXKCOxzX16TLdXMfcxM8GEKYV5ygN/WVZE22oYkpMXZ/XgcBeUmx5ppznrts+bEBNBn1OS1M36HutJyiqptDHYqYdpApZRI6gFK60DoxIJsRvM69VlJxAm7YnsJAa9E86ifwZtmKWm1/BI3Cauxc7OwYU2wHAh/CqTQQaoCCUKHZqdL0YaCvC5jwo4K8rcshhh+UbZk/ZlPU8zX4lOgLy9raPuqe3LDfiyJKICkPnDTlCZE494AqAipkF3BNBfs3k9EYkeRFjf8khOxlkZuGrRDVl1Pw3oxqcFE+Sn7BRFhOdFFLvg+ULFU9mlMcm20BR7nOCallaSnpYrLoiSQaJAozIZvYUaHpSt9qaJUvrWgR4a6dY2cRyF0M4Av5Eg+3FQSXPq4LI/W6KKOXorpgdfMK2rZL+3lhuH/+LmZinW48BrHTbnlBJQiNRUxfG7dko0ggWt5rs6rqDNYmXGqLPB9AqmM950kXu1QSt9lIHrgyiEWxOQvCkmcct3OG7M4GyW27yLj
 cpXHjaqe
 TsaGEmNEN8RKgQplqhJJjzo6MyqGKN3ElhPsI8eVYI9V7HuiiN/EC6PQIFXvnhPyby8kkt8eT351oTvLJmouEKuvSr2e8ZYQls+aXb2829OToYQAVa2xxovq6uxncLWA+cHBvdHz4COm0xQHbBGck6nl3AwhIH7KsBk9fnbCU8wbjtClSiylgm5rxBcsrcDFt36QmG8WsjaN4ZUlASXN7i6BPv55S7U37hwE+DH5MbSmfMLTu+L1oxyCA9IsgZkLk6vakawEvSjpbf8QHGuXeGYTt2gorJ8UlGNk7OaGLT9njPSlCGGQEYqoqTD1OZ+NG4bmNUaLE0dk3mZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 07:32:41PM +0300, Mike Rapoport wrote:
> Hi Breno,
> 
> On Mon, Aug 10, 2026 at 06:32:04AM -0700, Breno Leitao wrote:
> > Memory failures (such as unrecoverable ECCs errors) are getting more and
> > more common. The kernel knows how to handle it while running, marking it
> > as poisoned (and SIGBUS user tasks).
> > 
> > Poisoned memory is removed from the buddy allocator, but, not from
> > other places. A current problem is that kexec will load new kernel
> > on top of a bad/poisoned memory, which is undesirable.
> > 
> > If the next kernel's image, initrd or purgatory lands on poisoned frame,
> > the relocation copy writes to the bad memory and the machine checks
> 
> What does the machine check here? ;-)

Not sure I got your question right. Did you mean:

1) that there is no machine check exception when *writing* to poisoned
   memory, or

2) just that "the machine checks" is a lousy way to write it?

For 1) I think you are right, and I had not thought it through. The MCE
(or a recurrent multi-bit ECC) would come from consuming the error, so
a load or an instruction fetch, and a store may well pass silently and
leave the poison sitting there.

The read back is what gets us, though. 

So the sentence should hang on the read, not on the copy. Would
something like makes more sense?

        If the next kernel's image, initrd or purgatory lands on a
        poisoned frame, the relocation copy puts them on memory that is
        known bad.

	The error is consumed on the first read back, whether
        that is purgatory checksumming the segments or the new kernel
        running from them, and that is what we want to avoid.

> > Skip hardware-poisoned frames when placing segments: check them in the
> > kexec_file hole finder so it lays the next kernel down on good memory,
> > and reject a poisoned destination in sanity_check_segment_list() for
> > the kexec_load path, which cannot relocate.
> > 
> > The two hole finders walk in opposite directions, so each asks for the
> > end of the poison it has to clear: the top-down walk for the first
> > poisoned page in the window, the bottom-up walk for the last. A poisoned
> > hugetlb folio counts in full, as hugetlb keeps the flag on the folio and
> > the poisoned subpages on its raw hwpoison list.
> 
> I had hard time parsing these two paragraphs. Can you please add more human
> touch to them?

Sure, but that would cost more. :-) 

What about something like:

	Skip hardware-poisoned frames that were detected by machine
	failure subssytem earlier when placing kexec segments.

	To do so, add a helper that reports the first or the last poisoned page
	in a range: memory is walked top-down by locate_mem_hole_top_down() and
	bottom-up by locate_mem_hole_bottom_up(), so each direction needs a
	different answer to jump clear of the poison.

	kexec_load() gets its destinations from userspace and cannot move them,
	so there sanity_check_segment_list() just rejects
	a a segument/memory block that happens to have a posioned page.

	is_page_hwpoison() also covers hugetlb, where the flag sits on the folio
	and the bad subpages on its raw hwpoison list, so a poisoned hugetlb
	folio is skipped as a whole.

> > +		poison = range_first_hwpoison(temp_start, kbuf->memsz);
> > +		if (poison != PHYS_ADDR_MAX) {
> > +			/* we hit a poisoned page */
> > +			if (poison < kbuf->memsz)
> > +				return 0;
> 
> Won't we break out on the next iteration boundaries check? I.e.
> 
> 		if (temp_start < start || temp_start < kbuf->buf_min)
> 			return 0;

Kind-of.  Sashiko keeps raising this underflow in the function, on every
revision since v2.

It dismisses it on this hunk because of the check, but reports it as
a real one on the two "temp_start = temp_start - PAGE_SIZE" paths above,
which do the same subtraction with nothing guarding them. 

Happy to remove it from here and send that as a separate patch.

> > +	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
> > +
> > +		cond_resched();
> 
> cond_resched() for every pfn is too much, isn't it?

It is what the other pfn walkers do: the kpageflags read loop in
fs/proc/page.c and read_page_owner() in mm/page_owner.c both call it
once per pfn. 

But I honestly don't have a strong opinion here, though, happy to batch
it if you prefer. Would this one look better?:

	if (!(pfn % MAX_ORDER_NR_PAGES))
		cond_resched();

Thanks for the review,
--breno

