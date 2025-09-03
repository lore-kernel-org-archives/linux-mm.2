Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 927DACA100C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 04:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39548E0009; Wed,  3 Sep 2025 00:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB458E0001; Wed,  3 Sep 2025 00:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF1D8E0009; Wed,  3 Sep 2025 00:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD71A8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:46:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B9BF11A211
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:46:13 +0000 (UTC)
X-FDA: 83846702226.28.4C73A36
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7854280006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:46:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MwyoeGeY
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756874771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBIV2Rq6nhfDaht+Xn8FKJDk3X7/E1Il2Cd8F0Qu5yQ=;
	b=HtF3i5ykKDjAufNCKYrmau1R1Tli/25OHDdHO//xvDqIKpwiCmpaUlZf2ubiuaUB/8PUrO
	oJZZD4WCTNRJZLOaN5mcSpmsSDAT5Lf389u4lNAQfMvlQ82GbIL+pBMqeHXTdaX+Vodn3m
	UPYDLDiS1gwTDTr/hx2qWxKx5H/Oru0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MwyoeGeY;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756874771; a=rsa-sha256;
	cv=none;
	b=mnj8NkLSiSpZ6uEEFms/J+fq92j3ncgI3qwuZy3idr2/E0pUV/6Xkne7fsbS+xMQ4WkEsv
	7xpPt8EV1gbm/E2qMQ3BRdh5pi52lP/aObOkcAWgpXyrNRldZw4Mh7oSWK8btvre27gQ5j
	HEIggSx9E2iv04MsHfODpHVxlKIlBWY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YBIV2Rq6nhfDaht+Xn8FKJDk3X7/E1Il2Cd8F0Qu5yQ=; b=MwyoeGeYDysnGGXNZz+O0/g4jV
	z5ER5viBikaFx+wIz5kbIl9PG9kmg2E59NLsrndZUqCnBZeCHPRSSni+epRecdWciLKIuNr/a1FZd
	Wtj3FDf0nzg4Jqw/yu+OYOXratjiSQ/+IOzJIlhCNGFZk7mdqji39t57n+YPbTBkaKb4DwahhwljX
	XBqksxgksdRSvLnd0H8EVeVT8M3RzUjYfMqatCS9Y7zeZPDXziJOuJ6nsSeYW9Yw6F4tKy3WHo2q0
	yCCWTfWQzOR/E25XfdjRs8hNUHlUs/JMA6Zv50+/G69bTe0wckvfPBV51FayrvnVZGKsxBWwSp2tg
	/89rZfdg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utfNp-0000000FFuY-0MbQ;
	Wed, 03 Sep 2025 04:46:09 +0000
Date: Wed, 3 Sep 2025 05:46:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Subject: Re: Where to put page->memdesc initially
Message-ID: <aLfIEKLqpe_xB7mW@casper.infradead.org>
References: <aLc_nckaDc2ePRv7@casper.infradead.org>
 <bfd5161e-c76e-4a0e-bc1a-bf7510868827@redhat.com>
 <aLdcPeb8zrfDwd2p@casper.infradead.org>
 <20250902211514.GQ186519@nvidia.com>
 <aLd8l8v_DL75NU43@casper.infradead.org>
 <20250902235740.GD470103@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902235740.GD470103@nvidia.com>
X-Stat-Signature: ix16npu64ni8sctstdypbmpx8nys8ro8
X-Rspam-User: 
X-Rspamd-Queue-Id: 7854280006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756874771-173993
X-HE-Meta: U2FsdGVkX18Qm0UTGVx7p+8ES2A0mpueW7+21n9OUk79JsE1w6/rCuCwKV7yH5qFHA/bk8qUrIrqJ6cOPAT49gygwY/ohP1c5aRfp5c42myS5TSQ+EEbNHbWcoK1ieDEUkb9UCIj2J8gxR2kgmVDYv2Z8MLeAkKyh0HpYLuL5TDFngXXECrTNwcnnxaJhhjYlVLe7AQTvmiLue9ZVly7XPNw1Of7HQW2bH/YaW8mjtoYYXzClUwctcSuxIwfm1+xcf3sv+4e/ik+HggaC2qn+OhXHiriedZXi4bsOJlkfuxPdMujZB4LHH1sFTYugNcf4O4Ks7TNakGWTeAXVE3Z0QGeDHVN5HeZW0Z7DM4waSH8gq7TilwkxoCvygDKzU9miitJoSPFgPN2RwDxrNyMNOW4SHvN9CGT6Fy7XPtg+sfsFVZLMfQo2dIno1OiSBJTPYNrfxo8344quf5/9mX7hg/Gt+LuEdLYGNAt5CFcm9KTJMFxx5bjTYrEkTjkR7+BBb+6Odcs2vfpAG2Xn7Z40vVYe+EGuozTzKEcr+gXEfjbzV9LzoDgEcJ4V04lFVp+DCEFq7CazouTS+lrf73IQi7sIvI46+IZuvm3syoeXGJksxPGjpiRzG8/FSWnmRXHe5r5pg0zxRM7jUBoD4p7IEb2R81KNbBl9ntqfTSxWiJfKLVAoMmdX/2Yi5QLHqXBxt65H3GuavjgHOMRyuEy/CY76SFLbuDRv0b2Sjw0BvH8zt5Sd8HwriDGttdUgQ3ysAAbjpk1DSPpsVuZrJz4LmPx3mq6rtO24noF7pLCoBrFlrDsXWJ1fv5U+rR1Xynky4ie65p/NeGiYIcyvZVS7uZ+DIKdKrKKWx1l2/b8IqwSTaDY+C0DH0R4ziGnbi/DE/N0Uiy2yWJ856HmMajBSfGRpscPUcuSITiK3FLr/6ghhrcQT38i5KUfGGla4Avn/XSqSrVCsrFA5GklnP7
 JFd6/dfi
 TNNRkaB1J5ZrN6XbBY1HE7Xy55Cx5aPPXsvd3ibsMONgiRdkLdH0UWrYL0rpRuNCR+aLaUtizaUsvBzVvlNgBv933G8VyxYYDyV7SLL3JP7XFOYaGR08VHsk8ao8SLSHXZ3NT/lG3Yo6ZcHwCKChhJ/uaahWkTC7a8DwFwqidbNmUM4Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:57:40PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 03, 2025 at 12:24:07AM +0100, Matthew Wilcox wrote:
> > On Tue, Sep 02, 2025 at 06:15:14PM -0300, Jason Gunthorpe wrote:
> > > On Tue, Sep 02, 2025 at 10:06:05PM +0100, Matthew Wilcox wrote:
> > > 
> > > > I'm concerned by things like compaction that are executing
> > > > asynchronously and might see a page mid-transition.  Or something like
> > > > GUP or lockless pagecache lookup that might get a stale page
> > > > pointer.
> > > 
> > > At least GUP fast obtains a page refcount before touching the rest of
> > > struct page, so I think it can't see those kinds of races since the
> > > page shouldn't be transitioning with a non-zero refcount?
> > 
> > OK, so ...
> > 
> >  - For folios, there's already no such thing as a page refcount (you may
> >    already know this and are just being slightly sloppy while
> >    speaking).  
> 
> I was thinking broadly about the impossible-in-page-tables things like
> slab and ptdesc must continue to have a refcount field, it is just
> fixed to 0, right? But yes, the code all goes through struct folio to
> get there.

Once we switch to memdescs for these things, they no longer need a
refcount field.   By the end of Page2025, plain pages have a refcount,
but folios/slabs/ptdesc/etc set the page->_refcount to 0.  put_page()
moves out of line because it's really complicated; it looks something
like:

void put_page(struct page *page)
{
	memdesc_t memdesc = READ_ONCE(page->memdesc);

	if (memdesc_is_folio(memdesc)) {
		struct folio *folio = memdesc_folio(memdesc);
		folio_put(folio);
	} else if (memdesc_is_slab(memdesc) || memdesc_is_ptdesc(memdesc))
		BUG();
	} else {
		page = compound_head(page);
		if (page_put_testzero(page))
			__free_page(page);
	}
}

... there's probably a bit more to it ...

get_page() probably looks similar.  GUP-fast obviously wouldn't use
get_page() because it needs to be very careful about what it's doing
(and it needs to fail properly if it sees a non-folio page).

> >    you're silently redirected to the folio refcount.
> > 
> >  - That's not going to change with memdescs; for pages which are part of
> >    a memdesc, attempting to acess the page's refcount will redirect to
> >    the folio's refcount.
> 
> My point is that until the refcount memory is moved from struct folio
> to a memdesc allocated struct, you should be able to continue to rely
> on checking a non-zero refcount in the struct folio to stabilize
> reading the memdesc/type.

Definitely once you have a refcuont on a folio, the page->folio
relationship is stable.  page->slab is stabilised if you've allocated
an object from the slab.  page->ptdesc is stabilised if you hold the
PTE lock or the mmap_lock ... we need to write all these things down.

> That seems like it may address some of your concern for this inbetween
> patch if a memdesc pointer and type is guarenteed to be stable when a
> positive refcount is being held.
> 
> Then you'd change things like you describe:
> 
> >  - READ_ONCE(page->memdesc)
> >  - Check that the bottom bits match a folio.  If not, fall back to
> >    GUP-slow (or retry; I forget the details).
> 
> gup-slow sounds right to resolve any races to me.
> 
> >  - tryget the refcount, if fail fall back/retry
> >  - if (READ_ONCE(page->memdesc) != memdesc) { folio_put(); retry/fallback }
> >  - yay, we succeeded.
> 
> It is the same as GUP fast does for the PTE today. So this would now
> recheck the PTE and the memdesc.

Ah, yes, I missed the step where we recheck the PTE.  Thanks.

> This recheck is because GUP fast effectively runs under a
> SLAB_TYPESAFE_BY_RCU type of behavior for the struct folio. I think
> the memdesc would also need to follow a SLAB_TYPESAFE_BY_RCU design as
> well.

I haven't quite figured out if _all_ memdescs need to be TYPESAFE_BY_RCU
or only the ones which either have refcounts or are otherwise
migratable.  Slab should be safe to be not TYPESAFE because if we ever
see a PageSlab, we won't try to dereference the pointer in GUP,
pagecache lookup or migration.  I need to look through David's recent
patches again to understand how migration is going to work (obviously
we won't try to migrate slab pages).

