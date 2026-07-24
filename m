Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B2D7C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 12:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD8A6B008A; Fri, 24 Jul 2026 08:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485256B008C; Fri, 24 Jul 2026 08:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2B56B0092; Fri, 24 Jul 2026 08:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02A076B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:32:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 75B1C1A0342
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:32:32 +0000 (UTC)
X-FDA: 85023608544.05.1B0B44B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 647F4100009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:32:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wWDleT+K;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784896351;
	b=6IoOw2BoOZkcfVOwNwxilSF7Vh8LPoiXD3VzYwyjBISQ/00YILTHBd22BbwTC4lhQJcMLi
	oURDJKfkvHh1ZaCWf75+k/uUbBTqxlBSxD4e4TmhgeYGnUULIOz2vTG+bryvJ+MZfM0luI
	ZUCWWR9BzINjSBCNzqewcqe2lf1gW5A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wWDleT+K;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784896351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffuOTgmZJuwKmEXpuYSL7eRuSEjsYAbCNuPmD0+STOY=;
	b=uxm+VXO6KOrYCb98HEumJIu0FqvsGlNyqMFlHIwfffqTXP25z66QWEXJX14A8+8kc1sMHl
	SxAnkeURkzecNsuInqAVlpHfi5Tl6zH1UklQaQsqhkCsAa0GYvr4gzA8mx+NnBEIfmNZKF
	Nxzy8Kf9wh9zIfQW5r83y/l1ANrIbJc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ffuOTgmZJuwKmEXpuYSL7eRuSEjsYAbCNuPmD0+STOY=; b=wWDleT+K/GwFH9pZ9+ycsN9MoM
	hdIMW5V17AcWQUCV6JOzItWaoC+NzT0f/mk3ke7RGQjNJgPRnNexQGChIATLo0N9Dw8rlLJue1IfL
	qSE8+9cAdYJ8r6JxRIY1MduEZ7/U68vzPpI+mXSTzOeTjmsCyib/9mVPnb/TQOstziKPGf8evIDLY
	dTOKKN8Tb5XgFki0a23U87ZBKVAXIUAV7XnRTxgIyFbeu5emqjfCuFUM7BrvtbKdTL/RxfPWFYOwe
	1/d6aYRNq169GZfcJWgjTVO3QN2njOmMwq4baBIAF948dkpz/JDFrWi5XYQUiky+xvEu4TGSgMcrm
	aFT61TYw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnF4h-00000003SWX-0gG5;
	Fri, 24 Jul 2026 12:32:23 +0000
Date: Fri, 24 Jul 2026 13:32:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, stable@vger.kernel.org,
	Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: Re: [PATCH v4 01/14] memory-failure: Fix hardware poison check in
 unpoison_memory() again
Message-ID: <amNbVpvrxRBbuGoi@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-2-willy@infradead.org>
X-Stat-Signature: r3mh377558kk1d1ti585esg55jijdeur
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 647F4100009
X-Rspam-User: 
X-HE-Tag: 1784896349-589545
X-HE-Meta: U2FsdGVkX18r6AEDrn3iNR6uUqvM+zsIT0PDdAwbIBi09ioa8Bg5KlzOyw3vR1bJ9xtBXNYWaoVs5nvxRl7aswRenoosE2Ol17EFRAlLBkbYgubrsvJ27oEeEZxpdQ0i4pmS59RVAaP7wTwd6ECW+FdXGZc7W3Wi+ZDRLMqAwR88/6V2A7BH0IlFFEZvFtS5kcrpHvvqXpoHPecHYKai9YtHrm1Gm6z1V4Dvlfn3xFmUqw9aM1xlLd/ZXmzk2NjF8rGewSAYFpgsJUhjIqq1LcQcE5kZJ9Xpy1cuzPQxl/Wnst4D5j4A3BxS0OGhbCqgH2GAYd0Wqqf6Y0b0qTH6mPc3QkWbUCD0sI7u+DsKTHcDsLu8tNpdiTJmDyrUBagesX0Um91JmGKCtoOnHxUHqaTBQlI2wlVYvZEULNujyWIsaKhvtTEWp7nJxi7rSGW0fd4059wQzoTw3kUIYM8AFy7Ql1SDUNW3NVDpPcXnHBTAZFImF34k5x6wqy2y76LagcB0aiGPyIdnBbUTwInjX6J0HhDwC8qeJPHpprYLUdXmH7ThXI0ten4bFfhi9VHaovMSb9pqprKyWnqv9kcJJGTux8IM96MIDBEoe46YXV7glmTH3AXGMZyWBRxpHxSb3aqXbAzXZ4MYes0U9TK7ji5y3nOAZnCH77GB03GeRZavyOtYPP25q/mB+7t4EiBDkmpDrB0VDmaLSFw1JIrgQDZZ+68Tk6JTeSW7TVwThyPEcucpS9Ey+SzG4d6LwCCq1DpHtCBvoEaBFGZLgAwU2RIE6IYScR9jY6BFNa10T503tMCLaEee9ky4VigL87GjkxceMDWTucGAGHOHGG87ioZVrO2oRGl6ykQlrInemVK2mPFgMsbZbjQmPvtaDAci6s1kHSx4hyY2iwhNTnbjUy/pr2poAlJLEKIcS4twMOP2AIVhY0kTggdT+3ta3L6eRR2aQlQ3yTkIYfyXI90
 KRqHSM7h
 +g1+K6QhZQQTArlUhyN+d3IQ37Z6anlzLjWWu+On0fUJIR7rWUeVetXt54lAaZ/RV9sKwhGR3dUyPSgVJFtgdBoXiroG9KHkh16R0ybaSd+b0y9ssgN5zvWvs4dDht5c27QZaU19j+hU2+dNK3fcwiL0vBccCJCx9Yg/oXC83o9fn76etI9gqNPAWkNbK3HmwV5N6RM5RtCniB4OlKHEOleiJe3hhqkygj56+SxMZK2ddLzTU3qwH6/pfahjHsOf6ujzg1fxIFA6+S/9bY0BM4rK+cyFh+gIByadbrupE4ipXnYd+Mn+iDHNc4fwzkjaAB0IJKJ9kljGaw4kejWkcgEFX+Yc/NUbY5K4j6MihuEwZaFGQ3yb78Xy3QLsuTw1dpNrN57V40X6+JU86ew582a5vcQk+BLWrSTs+epowzkI1VdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko feedback:
> --- Patch [1]: [PATCH v4 01/14] memory-failure: Fix hardware poison check in unpoison_memory() again ---
> commit 5a43cce770d0c716bb5c78ee2c21e1cb711e5331
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> memory-failure: Fix hardware poison check in unpoison_memory() again
> 
> This commit addresses a bug in unpoison_memory() for hugetlb folios. It uses
> is_page_hwpoison() instead of checking the head page, and correctly targets
> the precise page for clearing the HWPoison flag.
> 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 51508a55c4055..944e6e1d49719 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2695,8 +2695,8 @@ int unpoison_memory(unsigned long pfn)
> >  		goto unlock_mutex;
> >  	}
> >  
> > -	if (!PageHWPoison(p)) {
> > -		unpoison_pr_info("%#lx: page was already unpoisoned\n",
> > +	if (!is_page_hwpoison(p)) {
> > +		unpoison_pr_info("%#lx: page is not poisoned\n",
> >  				 pfn, &unpoison_rs);
> >  		goto unlock_mutex;
> >  	}
> 
> This isn't a bug introduced by this patch, but can the speculative folio
> access without stabilization cause a use-after-free and reference leak?
> 
> Looking at unpoison_memory(), if the PFN belongs to a THP tail page and
> the THP is concurrently split, could the folio pointer refer to a stale
> head page?
> 
> unpoison_memory() {
>         ...
>         folio = page_folio(p);
>         ...
>         ghp = get_hwpoison_page(p, MF_UNPOISON);
>         ...
>         folio_put(folio);
> }
> 
> Since get_hwpoison_page() takes a reference on the new order-0 page, does
> calling folio_put() on the stale head page drop the wrong reference and leak
> the reference on the order-0 page?

Uh.  I don't know.  If it does, I didn't make this problem _worse_,
so I'm not going to address it.

> This is a pre-existing issue, but does unpoison_memory() clear the
> PG_hwpoison flag on the wrong page for unsplit THPs?
> 
> For THP tail pages, if get_hwpoison_page() returns 0 because their
> _refcount is 0, does the code fall into the !ghp branch and call
> folio_test_clear_hwpoison(folio)?
> 
> Because PF_HEAD redirects to the head page, this clears the flag on the
> head page. Since THPs set PG_hwpoison on the exact corrupted tail page
> (PF_ANY), does the tail page remain poisoned and fail to restore?

Hm.  Maybe?  This code probably needs to be more careful in general.

> [ ... ]
> 
> > @@ -2748,6 +2748,7 @@ int unpoison_memory(unsigned long pfn)
> >  				folio_put(folio);
> >  				goto unlock_mutex;
> >  			}
> > +			p = &folio->page;
> >  		}
> >  
> >  		folio_put(folio);
> 
> This is a pre-existing issue, but does unpoison_memory() fail to clear
> the per-folio PG_has_hwpoisoned flag when unpoisoning THPs?
> 
> When successfully unpoisoning a THP head page (where get_hwpoison_page
> succeeds), TestClearPageHWPoison() clears the per-page PG_hwpoison flag.
> 
> However, since the per-folio fast-indicator PG_has_hwpoisoned is never
> cleared, will folio_contain_hwpoisoned_page() continue to return true,
> causing the kernel to erroneously treat the unpoisoned THP as poisoned in
> future operations?

Yes, it does fail to clear the has_hwpoisoned flag.  We can have more
than one HWPoison page in a folio, so we either have to leave it set,
or scan all pages in the folio to know that it's safe to clear.

Again, I'm not making this worse for THP in this series, so I'm
not addressing it.  For hugetlb pages, later on I change to use the
has_hwpoisoned flag, and that does get cleared because there's no scan
of page bits involved, just a list of poisoned pages, and it's easy to
check when that's empty.

It's mostly moot because we always try to split large folios that aren't
THP, and that usually succeeds.  So all the large folio has_hwpoisoned
paths are very undertested.

