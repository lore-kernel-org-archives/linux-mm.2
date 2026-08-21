Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD29C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5995D6B009F; Fri, 21 Aug 2026 15:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571E06B00A0; Fri, 21 Aug 2026 15:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486D56B00A1; Fri, 21 Aug 2026 15:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 287906B009F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:48:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AB3E4024D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:48:17 +0000 (UTC)
X-FDA: 85126313034.05.C36860F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 87E89C0004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:48:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=n036ESkE;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787341696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2plf99ZSi4RvgrNhakNW0Ew4wlGptknswaCYlfxyes=;
	b=IrRHluxm9+DN+hodSjp7VYYrvCz+JoOu7FI4uomWycf4gJYLiftTb2HXJZ7KJXVzo7dx6H
	MTJbCu/ej6YvhAu36PJjVsBbg7GCEQOHPnyko6Pw3XpVUKLusbFZ01pLSax8G1E9H8NvSR
	I4Lzn0H2Ofp5PBZQTLOzFQPnflICVrc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787341696;
	b=XJP0FL3UJYBqgObWNySRBoUPD0UtLrTQjG5jmkLQR2wzWjnpw1y724aYB0+nC4yipFsq/k
	f9rzFtw7BxhkjQHQcRXoO9TN493exRIjsrZCPFlkMxAe+SQ/x7/ppz4Fob6F5yNUfrv7pq
	3WkUJznm0tKjZRs1JLbW7Lb1eIF5jjE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=n036ESkE;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J2plf99ZSi4RvgrNhakNW0Ew4wlGptknswaCYlfxyes=; b=n036ESkE0ogiUqeh4hgpiPsDTO
	gbhSAkhvHkoztzLBvWgIvd3arQqI7rOwIRfjGFWUicARO45wot1BLEdrRDIteEDhXLVr3PYzEnpK7
	J/9/CVJ5DAF8ump0ILfZcEfNPz3JbRK2tunSdH1+kCgUonPvTPMJe2Aum5KHi+VXAsB7Ws7gC2RrH
	WgvqzN1A7FuMcg+buq84J9O9QzMCepCnLsxg4/3WoQg1n7Gq/KTWL9uSLpNwpZVx7Z6B9hs7b2x2T
	GIWwHOteG5H1ZSDpWdZYY3+KsR/hzQjnUb6n4SpBFS1e/iFVHZFG/FoPMspZtkxvYFeNK32383HG8
	6OpCf/uQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxVDp-00000000LTE-0lyj;
	Fri, 21 Aug 2026 19:48:13 +0000
Date: Fri, 21 Aug 2026 20:48:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org,
	vbabka@kernel.org, jannh@google.com,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/madvise: use folio_trylock() in the cold/pageout PMD
 split
Message-ID: <aoirfBmxkQA-HwJ_@casper.infradead.org>
References: <20260821150912.183976-1-gourry@gourry.net>
 <aoiWZjgcitp0nSk0@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoiWZjgcitp0nSk0@gremlin>
X-Rspam-User: 
X-Stat-Signature: 7e8u57fo3y3ptoz3xusqcz5ug5csm5k6
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87E89C0004
X-HE-Tag: 1787341695-277607
X-HE-Meta: U2FsdGVkX18me6BXtmuoEo8eb3cbfip2ex0UTAyMqTDKEBSpqF9FZFqAJD4H5QmhGAGXZzZBDrTHmVGgCtr516eAks5uYhksb1W21Ppw0kFKB8exFFmTA09nvuY/8LQ+fHKKqDbgHHLfD8G0oxSm9Aws/SxFwk1uB/l4/yQtSNyw59Z0OGKHTO5CDaLCHqEymGTsctjGwH8WMAdHdJ5NdMSJegOiGJMOexrVErdJsCZ1FThzDV6SFR0VRMSpUrQWigh2tHev6POtIyBUTtt5bA5q8tVm+Q13BitJibaesojz/6dD/2xKpuN0Vl+aAbGwY/cBcXxZPScxYt6oXIpAWKF1jtMScH9ubKULi76vDq6yOWXg9lfFqEtcUaapCL2cF9iHwBy3fzHOmkkKeIeogL5noBbAsPD1rqbklVa+NBrn6gIYOvDq1wY//6iEAlF1dr3L36Hc7ltrPlcPQwq4VXnHE+A2BmMdHIlQFdPaY7i1FUzv2LaxSzLr6vF2iUGOGN2Mrrlnmp5bPXnbN3AWftkDymaPDWiC7gd8ATD+D97iWxBfcoEU0Il0ivkBZ1UFxVPFK0l9+2C889q8GDUL+yG4zCs3LWUa5PJG+tCIehOYerxMoz3GLQ7SJOknuKiU7UhQLbzC875WovwXw7t0CZ2+Yh+DOwFmyaDFozUkF3VgT9RiClR3cj8oBqivWnEVqCDrcG9qAyFbjEm6f9PZRgjiVv72//cWQQ0za7mHFpJaA2sbY68QXefcxSK/2Jzv3ptpx+R2K0BS06gXajS2R3PC6gUGlY3WtJ+0yxgC3kvC0Ejk6SeqWaBtyuRQbysQ5eAFr+gH+rwlkoWfVoIWV7k3l7f0u3qFzDxPRcbbbbx7djn9OzU3UkUFmf32r2S19JpABLORSkRDh7f0CddQKxsbmlY+SNWWFQKR3J3Q8+idlXY5BBnKPP/xiNaazAH/0vTT/vqmHvkSnuYQMz2
 98JpjT97
 VB36wHLlc4VzZVfgRaZo/bGv4jOWa/OaCrsy0fgutbDRDCKh52dIBN204siRpeOS9vS2zI5V24a47viiMsMDuu6iePTpbULecnlkBF0iRFfKkWNf81EPOkIzFgH5VHRYDh9n5BPhsQNrnblO6604xuq3PrXol71Qr+sZIRJBZd9A1hePW8aKasY/0XRmJFzsn/vSOErp7NbZI7oH/CAkLLXvlZXcuq0JW5BhuZGoeay5+GnXu49UvoIA3pqIK74t7GhSnuMVKOB6yiQk+zqsGNhIZ2uNx6mgkE+XUZ48hlOOogqHokEaIvmqgZed4muu28uez
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 07:23:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Aug 21, 2026 at 11:09:12AM -0400, Gregory Price wrote:
> > MADV_COLD or MADV_PAGEOUT over part of a PMD splits the THP in
> > madvise_cold_or_pageout_pte_range().  Two threads doing that to
> > the same THP create spurious failures.
> >
> >   CPU0                          CPU1
> >   ----                          ----
> >   folio_get()
> >   spin_unlock(ptl)
> >   folio_lock()
> >                                 folio_get()
> >                                 spin_unlock(ptl)
> >                                 folio_lock()  <- blocks, keeps its ref
> >   split_folio()
> >     folio_expected_ref_count(folio) != folio_ref_count(folio) - 1
> >     -EAGAIN
> 
> Hmm, but doesn't converting to a folio_trylock() introduce entirely new spurious
> failures due to folio lock contention?

For the task running on CPU 1, yes.  But the folio does get split rather
than probably both failing.

> > +++ b/mm/madvise.c
> > @@ -405,9 +405,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> >  		if (next - addr != HPAGE_PMD_SIZE) {
> >  			int err;
> >
> > +			if (!folio_trylock(folio))
> > +				goto huge_unlock;
> 
> Doesn't this violate lock ordering?
> 
> >From rmap.c:
> 
>        folio_lock
> 	  ...
>                  mm->page_table_lock or pte_lock
> 
> So now you hold the ptl lock _before_ you obtain the folio lock?
> 
> I'm not sure if it being a trylock gets us out of that particular situation? And
> I'd be reticent for us to violate it... unless I'm missing something :)

It's a common way of getting out of a lock ordering problem.  Surprised
you've not encountered it as a solution to the Dining Philosophers problem.
We have even weirder solutions to "I want to sleep on the folio lock
but not with a reference held", and such might be appropriate here if
we want to prevent the spurious failure on CPU 1.  See the DROP behavior
in mm/filemap.c.  See folio_put_wait_locked() in mm/filemap.c, not that
it's exported.

We couldn't quite make that work here since the whole point is to _never_
get the refcount on the folio if somebody else has the lock, and once
we've dropped the PTL, the folio might have been split and thus not be
the folio we want any more (indeed it may have been freed, reallocated
and now be a pointer to a tail page instead of a folio).


