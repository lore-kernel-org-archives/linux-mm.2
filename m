Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE289FE5202
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BF746B0005; Fri, 24 Apr 2026 07:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370346B008A; Fri, 24 Apr 2026 07:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2868A6B0093; Fri, 24 Apr 2026 07:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 157536B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:31:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC0701A067A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:31:39 +0000 (UTC)
X-FDA: 84693234318.13.294770F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0281E40008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:31:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=YZVOQmjr;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777030298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0B80XTDxYzy7p3UUmlZiEmfVnt3O2bGURNBdOEdktxQ=;
	b=SDmNGEfYN++HDze45/DS8C7y9cDYytUb8dvTxHRCQPluZGSI/ZLHS5SllmVfEGm8v9afSP
	Pbb6eiw7khg46wPKbx7nCYLQhvvIx2yOKy/BlxICQ9aGW40lYicN33TrDzg/HIAbvxh6C+
	nF54xzavj5CU6+mpOGO3cmdKXprqZ+U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=YZVOQmjr;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777030298; a=rsa-sha256;
	cv=none;
	b=uq79njY5pna+CQLGzqJySlimh8SgPRrZhPRivWflcc5r2NjhnwIpvQR3KLe/WWJf0VTm7l
	yVm1tXI7lNDiqSdHquwqhtEVjba+lqQEkWEUL7pUavHrz9vN2/2Mm2rCIllba8VToKkGIr
	DWzgBbhTRJs0hqQkkZAOisUBlQfmRhA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0001640247;
	Fri, 24 Apr 2026 11:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6888EC19425;
	Fri, 24 Apr 2026 11:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777030296;
	bh=BrR2zw70w1S0+ZbZ2nSR3uE0R1clgnO0h3OBi9HvvMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YZVOQmjrmmmNC9cm8eQzWxH23mvsbsvoGqgE92Lv81AlZDJt7jIpq42rbk8JA5MbK
	 baU4Em941TZ3Q64/wk15fy6KHLlNNoqsyJuiPdeY5BUcPTr4Ilvtjc/DmUmHhCAcjw
	 zb882hRQRFfSHK/1KQ8zFadOuEhJnUeWP6CwSpfU=
Date: Fri, 24 Apr 2026 13:31:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-ID: <2026042431-charter-ranging-597c@gregkh>
References: <2026042303-vendor-outright-b9d2@gregkh>
 <a20913f0-476c-4f56-a044-9802bb1c7f1a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a20913f0-476c-4f56-a044-9802bb1c7f1a@kernel.org>
X-Stat-Signature: 7m58zo3h9drfh149xg5pq6ciofrdgwf3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0281E40008
X-HE-Tag: 1777030297-104299
X-HE-Meta: U2FsdGVkX183RNyPFO2eQjwfzhv7jpS13Poa1r28feZ5SCIVE24UzDDtMriDODv3o1VtHdzwCN43jwCHkZkRck2i54RqMO6uhLM47O/EiuXXHIRygYTK6HIMNT7OqKCo1+qidELng7/W0Y2jEIsFONh/5sRN7gu7EZzEXZSrB7Wu1cVf+nmORFI3oXgmNJsqbhzGTLGNabPQMbqeKws//MEAYur1ElJ0uTseSCeJHXgnyULbmmg+rDxgaDtX83OG5UD5xOMVaazTKuGuQBgwjBz8tTY5hgJKBJVQ2DBNBiyU2nSnQGjjExneqf8XpYqO+PGH5lBMYVOxEuZFjKCwQdjjE5qLeXvDz7Yf5yJeOQJq4ZPYd3asJzTi8r1gRGJlIaj7C+sssyjzD0eYS9fmc4BJGmwXph9/MmrwcqToW2d2UhyJZqOGCxPWDJHTVpYHO7/7pxU3A3peTO9XjkWsR/4RfTEhwZiezYWsGQm1v6etX7hbVcSKyZX136IjyfioZSjOeC2U6TKbcD/8OHMGW2mQPmic5ZLP1Kacger5vqqdBycUALhtDWkmwZ4sMvq/VZW/B037kNt1Y4FmlA1FFS2SpSYSpZPKknNx12dbACy/riX550awN+qaH6q9lSHTN+h+1/mDjWnvmcDEVOVNCXUQFDQ8pErTBl+7J03UBGtcn0+ayx6KBea2lXXLQ9cp33WOniN2K7jg1JfGPikIDWS5wqI19vKdhdJ456gUB9iKl34gfExNm1T8pqxlEX435G0CLnkhx7e5Bt+i7fgnWVxXyO1cvqR5sOZZoQHoIAOApbAlWCF13v6aOGtlegYYVP0Zsqt+r9BIAKUi+NLToCbjF9ct2orpL08/T9Gp/bc8AoHfbcKfeCbNsNaaBQ+uozryiLHb+agmMRlBHo4AYJYKqfAQKX+mqHf3S8hsFvm/KcvljUHyMZoZVDpjtHHvxkVhcgNV0L8zlr/awSR
 PbEiHb1H
 a1Awz+7OzMiSWEf+5hfr6T7ZhPt0oBAu7Jx3kJCmDcF2eV489cK0lsa8/NRQZcQKINg924YJTN0ZMiZavfzUqZNKmgqdbqQ1LAK5wyrfjxXVR8l5itQ79vMrX/+ndtvfuKq2iMHfQsYmCjuN9pCvcgFNMa3JLmj0UsbsI5nZX/2wFknvfDDusjLsjNSwh39jOjtWzZyq6DNPUKbe9b+EK/EhmqfGXIeMs26WcdZD41YMC7Wt59gBLYrpzLFQihLHWJvtPmFnifmdYv1QnN1p6MsLesb3reO2fdtEgtELL+rAMPJPJ/6dfsje5OYr5pK5x9ku1zQw9gRe6hrCnz6MFX5/064S//PA0+uyENJOAT70KDvZbOrSNhH6OoSzAlyQnR3ty035NJLZdtKpRR2L7FnbrdTOgrZgkWClpzN4asssodRj7q+74lS+g3G8+4r44H7+QqYR+BAJNpLVQF/i/CQPIjoObh2B8MtUv34oup9NHFf1ksZRo3P4iF+wzZ4lsh4VSIBVTdg/OLaz7Go1sJMl7/yxPoCfZWbYJIEGsBCzztTdwCHKT2dtDYi7Ndr2bkDvXigZk+nn3JB0egbT15emfljrfg4WAZhdMxksN7gbWv/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 05:55:56PM +0200, David Hildenbrand (Arm) wrote:
> On 4/23/26 16:28, Greg Kroah-Hartman wrote:
> > The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
> > get_page() reference for each page regardless of foll_flags:
> > 	if (pages[i])
> > 		get_page(pages[i]);
> > 
> > This is reached from pin_user_pages*() with FOLL_PIN set.
> > unpin_user_page() is shared between MMU and NOMMU configurations and
> > unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
> > GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
> > 
> > This means that pin adds 1, and then unpin will subtract 1024.
> > 
> > If a user maps a page (refcount 1), registers it 1023 times as an
> > io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
> > unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
> > the page is freed and returned to the buddy allocator.  The remaining
> > 1022 unpins write into whatever was reallocated, and the user's VMA
> > still maps the freed page (NOMMU has no MMU to invalidate it).
> > Reallocating the page for an io_uring pbuf_ring then lets userspace
> > corrupt the new owner's data through the stale mapping.
> > 
> > Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
> > for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
> > symmetric.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Reported-by: Anthropic
> > Assisted-by: gkh_clanker_t1000
> 
> Assisted-by: David :(
> 
> (no, I'm not a tool! :) )

True, sorry, I guess people can "assist", I should have added that.

If Andrew's tools automatically pick this up then:

Assisted-by: David Hildenbrand <david@kernel.org>

> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > v2: - drop huge comment
> >     - rework error return value based on David's suggestion (heck,
> >       pretty much the full patch was written by him now)
> >     Link to v1: https://lore.kernel.org/r/2026042334-acutely-unadorned-e05c@gregkh
> > 
> >  mm/gup.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index ad9ded39609c..2f6f95a167af 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
> >  	struct vm_area_struct *vma;
> >  	bool must_unlock = false;
> >  	vm_flags_t vm_flags;
> > +	int ret, err = -EFAULT;
> >  	long i;
> >  
> >  	if (!nr_pages)
> > @@ -2019,8 +2020,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
> >  
> >  		if (pages) {
> >  			pages[i] = virt_to_page((void *)start);
> > -			if (pages[i])
> > -				get_page(pages[i]);
> > +			if (!pages[i])
> > +				break;
> 
> Best to mention that change in the patch description. I really think this is the
> right thing to do (returning NULL in the page array is just very dubious).

Ick, I see Andrew already grabbed this so I'll just leave it for now,
thanks for the help and review!

greg k-h

