Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF924FD375D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20EF46B0005; Wed, 25 Feb 2026 08:32:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BCE76B0088; Wed, 25 Feb 2026 08:32:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BFC56B008A; Wed, 25 Feb 2026 08:32:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E926C6B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:32:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 912401405C9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:32:06 +0000 (UTC)
X-FDA: 84483067452.28.CF72690
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 243EDC0007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:32:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p4sgVw56;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772026325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=efkMVajN2N/IRF7C076bX4bMjtWcB2gLayz3FuAnYog=;
	b=cu0Iz+kPJNNx0fHFaGNuzNjZ/ZvNHaIvqQQPPFc8IZdG6ta0U5CxIJnnSAAi+gHU75nJZb
	T9ByTmuMIB9PZA/v2NiB0uwxWIcVOFQWLEXNuXu2kNwnLa/HTB4kBWaBojstrsy+mZMCrP
	PnADsGhb9k7CEKmLBzGvW6BNY+2s9I4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p4sgVw56;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772026325; a=rsa-sha256;
	cv=none;
	b=dx8jK89CRDucU5DqtA0fupfnUMfHJQOCrFX2iPKDHLyWkwoocszKg6wu3tWa91k1TTniah
	wChTXPpxN9c5zTn/xhFnRBHPBRiSyrmRNsBwr/CmU+OY2xI1ubDb8mdZJ7ewf4DvQCmkJE
	naVdEd084p+swBsFB7R/7lT8h0Y9PzM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=efkMVajN2N/IRF7C076bX4bMjtWcB2gLayz3FuAnYog=; b=p4sgVw56jKhFiBT0NU54IU0xN9
	l8s6oNEoxRsjPSG42mZKlNVuypYcJM4WSP5AB5swbLjl5vPtGYV5aUvSv+l3K4BsqBkt2qhAkOTBT
	I59DDp8pNjJd1hF2J8in0hds/h5u/8In66y0h7+K+aM/ITPX57hp3zKdma20COg0Lg1z8L98f9ENv
	IxWRczBkvII7uM/8NXbikDLlStecRsMyUAjoClg3GC5JQoJz2JxoheOqKUN02JT8H7fHTdtczMELB
	iqGSyEtAai8OaBVo+6khCUWuQh3Z4TvpJhiVLI0WulwVCcVU+Bzf/keaVfKOjlUZwr3qSdH+chUgW
	UUrTAljQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvEza-0000000172N-0p6Q;
	Wed, 25 Feb 2026 13:31:54 +0000
Date: Wed, 25 Feb 2026 13:31:53 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ankur.a.arora@oracle.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Avoid calling folio_page() with an out-of-bounds
 index
Message-ID: <aZ75ydx-FKaFvygT@casper.infradead.org>
References: <20260225092628.11687-1-lizhe.67@bytedance.com>
 <cc08424a-22d9-422c-90dd-54893bda1213@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc08424a-22d9-422c-90dd-54893bda1213@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 243EDC0007
X-Stat-Signature: 8trkew5eh14zwep6a75sdzn1nxttoqux
X-HE-Tag: 1772026323-190472
X-HE-Meta: U2FsdGVkX1/uWtAFXluEVUog79HGOw187sy83+nuun9S/gV01Umf6nrgygHmv6NMaJrNfcXHdXq+4nEtNDqFlriYXh9A75ZkHQ1mXKfkikvzkdmZLcVZ+GSmnDySPnuvlRIZOIdqbDtr1smRpfjKf8jAw9uGWCG19oMs+MuX+y9wgnXhiYYafOn6jnB+6HKjpcUV70iGPb3y02Ub5k3Kw9/seH3QCSOmETNE6leFFiX08lQXTN4dbdG0kJ3AXQj6evtsB10nvOrkJFDbIhgKV747yAT+u1yCvvGLi+BWRPmD1hYLRhZhfsMnSzmDlPVyeIH1HagTcEMQhl+jsrOBkPFywXlOL85L53651Z3MJ82Bd1seTpHsGhMOW0TZ67BST9K8UCRbjlm8HZ2P2hd/8/JKCbS6kpN9jTpPwJVfs3kl3S/SgInlHZ+QdTXuTpAJ3ajGJ0YauXuXpRir+ujvHorAAh+Ct3Hy8ETANg2zfGxJmbQTFoqlh8yMBv4fRfCG9AqFjdqrJLXtU0PyomlpDyxY1Cfwjl2FDelWThLyXS+OMEA/KurDYUvLxO23cZR8maCkr0oNBrDicku+bUbKhYyS5MVHuLNqaUiFiv3woChuA5K8Fx8kbvBnBI3U2+9+fnw3hz9+yaSEm2pySYBgLSz4NOCl24tIvwTg3t0sPm6bVDNsOSmHw7enRIdCX+Sv69PjUm/S+em+WO4gi/vl8+qi3VjOIIHcIxj2EMelBJ3EMP2lph8/+D/LNanUuQIxtL2SkXpUxVIAoXM/13wtd+WkI+NgWsWLh7/TKOp08h9OHR9ox+gEnXtUaaVdcsYd8awNuF6nYriCUOY6MvxZP9nqPB2x/Kauyi8Y8uhiIttjl90zsHIALThHKzyTmq19AfHBQkt/M92pjM99k6gUwDJfa8Ch6onx39/hOGOL9fFXyHzn4CPdmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:35:32PM +0530, Dev Jain wrote:
> On 25/02/26 2:56 pm, Li Zhe wrote:
> > In folio_zero_user(), the page pointer is calculated via folio_page()
> > before checking if the number of pages to be cleared is greater than zero.
> > Furthermore, folio_page() does not verify that the page number lies
> > within folio.
> > 
> > When 'addr_hint' is near the end of a large folio, the range 'r[0]'
> > represents an empty interval. In this scenario, 'nr_pages' will be
> > calculated as 0 and 'r[0].start' can be an index that is out-of-bounds
> > for folio_page(). The code unconditionally calls folio_page() on a wrong
> > index, even though the subsequent clearing logic is correctly skipped.
> > 
> > While this does not cause a functional bug today, calculating a page
> > pointer for an out-of-bounds index is logically unsound and fragile. It
> > could pose a risk for future refactoring or trigger warnings from static
> > analysis tools.
> > 
> > To fix this, move the call to folio_page() inside the 'if (nr_pages > 0)'
> > block. This ensures that the page pointer is only calculated when it is
> > actually needed for a valid, non-empty range of pages, thus making the code
> > more robust and logically correct.
> > 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> 
> Not only the correctness, but even from a perf PoV (folio_zero_user is a
> hot path) it may make sense to initialize the variable only when required.

But now calculating 'addr' and 'page' is dependent on calculating
nr_pages instead of being an independent calculation.  I'd be *VERY*
wary of saying this is a performance win without actually measuring it.
CPUs are far more complex than you seem to realise (which is ironic,
given your employer).

Now, maybe the compiler is smart enough to realise there isn't a real
dependency and it can hoist the calculation out of the 'if'.  But then
what have we achieved with this patch?

Honestly, I think this patch is worthless and would not include it.

> 
> 
> >  mm/memory.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 07778814b4a8..6f8c55d604b5 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -7343,12 +7343,14 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
> >  	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
> >  
> >  	for (i = 0; i < ARRAY_SIZE(r); i++) {
> > -		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
> >  		const long nr_pages = (long)range_len(&r[i]);
> > -		struct page *page = folio_page(folio, r[i].start);
> >  
> > -		if (nr_pages > 0)
> > +		if (nr_pages > 0) {
> > +			const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
> > +			struct page *page = folio_page(folio, r[i].start);
> > +
> >  			clear_contig_highpages(page, addr, nr_pages);
> > +		}
> >  	}
> >  }
> >  
> 
> 

