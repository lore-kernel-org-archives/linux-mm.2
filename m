Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19601D185E9
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 12:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3016B0088; Thu,  8 Jan 2026 07:32:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECAA46B0089; Thu,  8 Jan 2026 07:32:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC396B0092; Thu,  8 Jan 2026 07:32:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C88FB6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:32:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6770E5A474
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:32:51 +0000 (UTC)
X-FDA: 84308735742.07.DF39196
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7E99B1A0008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:32:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jv5MvU/u";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767875569; a=rsa-sha256;
	cv=none;
	b=V+DKdDPEOIMPwLXRubFS3znKMk61HqRz0ggv6OAWyIBDR2/AG2X4VUZuLA5lHMQEgYr7Hw
	TTOg0AvvTs+3qQzmpMmebzlpMQONYO8d2Sski1PuqOmmRTfU6Xqtg9h1y91Qw4mY/pX5nS
	BOLhic2TOSmXzeg1ayzeDVN/OOYZI9U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jv5MvU/u";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767875569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBzToRd7/4bi2x9T22CPN9HGLJI5Gz+sukDSTPZ/xBk=;
	b=UIL5PiRutY/mjG1pfyO1mHilHhk6CYuxMA0IGRmp7BtbF81a3ZPqw4G9wyHQ4oCp8daLWs
	BfJ7W8pVw82yCfsK0K07DRPynrCdGR0mq3LJMEImPhozEOJ/O3Q6/Zjsiyt3gRHuMMQE2t
	A1tK+DcorT2hYTTH3gw8OWP0AumEbFE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F353260136;
	Thu,  8 Jan 2026 12:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1685AC16AAE;
	Thu,  8 Jan 2026 12:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767875568;
	bh=FQQ56dc+cW125BEbDqO1eWGFQ+p2e8tUVvYZ9ind02g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jv5MvU/uUBOzAWlAc8X6rAhyKlFViFZZ7Y2vkIf2UkFAjawmcKxsB9om7T6J8FzrH
	 2xThXGT9x5frJMDDM5CKdT+bPVx4Ubrh4Z0SYoRT0qS07mOSTo7NANL/yrZYPAn7FZ
	 joIx7Kcv8VKF9gWzjHDLCl+nWKHNscfxYRoY35Q0c6Mf1JxhR8lckDwSzLM2o3bmR5
	 FWEB7+tEDUQeiD0XYF4PgCJfh87oucYVkqyyH6yClr4W0xy3xpRgi2bAEBtTl0tg2b
	 XS0+0zPB6KtnS2qU+PmDhDXKTu00XX/AhI7RbgTxNz8r7w40X8s3Ovs78JX5CQK10v
	 K8zT0pfsN7/Kw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 37F5DF4006C;
	Thu,  8 Jan 2026 07:32:47 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 08 Jan 2026 07:32:47 -0500
X-ME-Sender: <xms:76NfafYCrtt7u_vvwnsjzJra0wcKjhQeeXCFT3uIPdkHRQuVqEwB5g>
    <xme:76NfaZxlxwz9vW1NAS7-6zSNmqpv2eD1sOhoP6XE6bZhhBgzq0vp9E2JTu6mMD4U0
    msiOTv7DKK9227e5bhCJLwg3Bz_kOqDPkbfFHHVVJ5V4WBfUloxCw>
X-ME-Received: <xmr:76NfabVxsbbwOE4B3HM0xkR9S-GoOqj0VwCcjuXKslOu-PxlKchA3X1QFPdUjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddutdehleeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinh
    hfrhgruggvrggurdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhngheslhhinhhu
    gidruggvvhdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhrtghpth
    htoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghkrgesshhu
    shgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvg
    drtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopegs
    hhgvsehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:76NfadZP_XEuzT_LKHTsotPFQev3DwdAw7hOtxpe1N8QhDim20U41g>
    <xmx:76NfaWMthlHKty8RWBnWAVyAlA0aDCXw0p19TOtiosaI94PiSnAhKw>
    <xmx:76NfaRtvkZIwzGpN1et9pbdgypp9iI4EjIROj6xFRLi7371MGiMGuQ>
    <xmx:76Nfac1axLChg0ATyxXGvp34gUg2pz27KkQ-pI9NhiloPz1JJKwfQw>
    <xmx:76NfafUxj_sqjDaRfg0Uk3JnW3ZO8xuXRnmNc9Zw6q3BwSkpqN1q7Ne8>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jan 2026 07:32:46 -0500 (EST)
Date: Thu, 8 Jan 2026 12:32:45 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
Message-ID: <yup3hvfsn4tvfnv32mdf4yoabt4igb2lkvllfac72g3abdkovm@auqdaijzby7d>
References: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
 <CDAEC896-E3EB-4EAB-9F0F-70BC448B3B9A@linux.dev>
 <4f82b8ef-77de-422b-a9a5-691c4eca24a3@kernel.org>
 <glu3noshgeh7ktwwqofk7xcwkvhek2x3hrbdmyyo56gmctdx3t@adsfih557p7g>
 <2ace6fc2-6891-4d6c-98de-c027da03d516@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ace6fc2-6891-4d6c-98de-c027da03d516@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E99B1A0008
X-Stat-Signature: pi441yqo1ca8cfy65bmi3mhxitn6im6k
X-HE-Tag: 1767875569-69049
X-HE-Meta: U2FsdGVkX1/vrOYfWyGwHfdiH62TMdam99VqDqg3JUJeceEKI6g7AqdiwkEeL4s5/wlevgZSx773frsaEzrHVOA/LHlogyXCKynuGjPPlqtDVmU9gp8E0PmeTI777aOfzRfDC27FbOGfFqtbKBBHNfJoEJ2L5Jqek7cO6oGxjwt7XpZw84jWy4IilSVaoljW2koB1E7M6PqXasODTcrLirfam1VGg2lIj7+zCFNm/loCCU1MnWbYLEd4W+1PUp30el6TUBmgaRiTPmh+YH32oZR4bhx9pSHYQb1Rg7oGJh2DEIKsZZQJLRdjNnXoDjWP+JF8LyKlv5joHA1L/LhOC4aIYS4sRJggxcEJF2FVDa6YrhjAgNWkGlEG4oBj4qI5QuypFk7ulZfMbuISwZc8sz7ZJdZH59SoqOCUdSJKP4Jq/TQSrRjkSJcsL0O5LipXs9GQ91jZm/cc/3Q/PX7PDNiP0JBkQmMUgQCcAoG3Vowh3ZKfEmxuHFx65DYBiOGmwsA+8/nWqnmZ4mJlOmc5u4RvC9QwNrivSEZ0wjEZdALLO/pkE1c5V3KSiZuA5hO39P5q6T3WetDLEy6rW3+kfAbfCOxl0cNdo0y8teqIpNWhZh/O6hJXceCAYqj50m2All6hqhgQYfOwdifyh9kMI64HbazIshIzln0tWzyjyvmfJeHn4Gm43IS4hF6Xp+Mjff7fhwl9LijXOBPlP2sWfg4jzMZ5hupn92JQx3NvBRB1zkp7/FSOhM9/P4hKoY+AF31h9lffJIK7br8Jtgm+eU9pGoFxz/Zpo7PXO6W7zaT2rMOAfUUmSFV4lZv1Z/T+mceKwxzGAIxdZ9INuTLC9XDuye6Uy4XbOMxKqdcSdRgGV+kBpPQojX63SE/74kjqb3KDJo9sHoJE/kw1deW0EsAi7neZtZpSaVRzU63+EtBbxuSu1AYsQmaUj72weD4RCD6vQMliHpkulnUTnp8
 jX5OaIgX
 Mi67rTlNdxit7uAUhwEgddMUavhrL/MOuKpWcPMRWp12NYUjG7gHUC+AKhuXTvrtWK02Ka+JyTADchO66w/Ih8wBWtPWx9TWrM/3+/21SNr900/3z/gVgmIhlMF2/+lmCBYk65vH3vz8hlsMfs4DUUX/bD1JluJ2+07U/rpHzag0VDbe7Ew0XfashBsyMB75b8PsdfNAssiIRTWlbnnFJdqczZeQM7GGwSRRToPesSO4gISbU11t5k3MmInGdK1YMm9Oh6Z9DZkt9dXlif7yMYupd+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 12:08:35AM +0100, David Hildenbrand (Red Hat) wrote:
> > > "Then we make page->compound_head point to the dynamically allocated memdesc
> > > rather than the first page. Then we can transition to the above layout. "
> > 
> 
> Sorry for the late reply, it's been a bit crazy over here.
> 
> > I am not sure I understand how it is going to work.
> > 
> 
> I don't recall all the details that Willy shared over the last years while
> working on folios, but I will try to answer as best as I can from the top of
> my head. (there are plenty of resources on the list, on the web, in his
> presentations etc.).
> 
> > 32-byte layout indicates that flags will stay in the statically
> > allocated part, but most (all?) flags are in the head page and we would
> > need a way to redirect from tail to head in the statically allocated
> > pages.
> 
> When working with folios we will never go through the head page flags.
> That's why Willy has incrementally converted most folio code that worked on
> pages to work on folios.
> 
> For example, PageUptodate() does a
> 
> 	folio_test_uptodate(page_folio(page));
> 
> The flags in the 32-byte layout will be used by some non-folio things for
> which we won't allocate memdescs (just yet) (e.g., free pages in the buddy
> and other things that does not require a lot of metadata). Some of these
> flags will be moved into the memdesc pointer in the future as the conversion
> proceeeds.

Okay, makes sense.

> > > The "memdesc" could be a pointer to a "struct folio" that is allocated from
> > > the slab.
> > > 
> > > So in the new memdesc world, all pages part of a folio will point at the
> > > allocated "struct folio", not the head page where "struct folio" currently
> > > overlays "struct page".
> > > 
> > > That would mean that the proposal in this patch set will have to be reverted
> > > again.
> > > 
> > > 
> > > At LPC, Willy said that he wants to have something out there in the first
> > > half of 2026.
> > 
> > Okay, seems ambitious to me.
> 
> When the program was called "2025" I considered it very ambitious :) Now I
> consider it ambitious. I think Willy already shared early versions of the
> "struct slab" split and the "struct ptdesc" split recently on the list.
> 
> > 
> > Last time I asked, we had no idea how much performance would additional
> > indirection cost us. Do we have a clue?
> 
> I raised that in the past, and I think the answer I got was that
> 
> (a) We always had these indirection cost when going from tail page to
>     head page / folio.
> (b) We must convert the code to do as little page_folio() as possible.
>     That's why we saw so much code conversion to stop working on pages
>     and only work on folios.
> 
> There are certainly cases where we cannot currently avoid the indirection,
> like when we traverse a page table and go
> 
> 	pfn -> page -> folio
> 
> and cannot simply go
> 
> 	pfn -> folio
> 
> On the bright side, we'll lose the head-page checks and can simply
> dereference the pointer.
> 
> I don't know whether Willy has more information yet, but I would assume that
> in most cases this will be similar to the performance summary in your cover
> letter: "... has shown either no change or only a slight improvement within
> the noise.", just that it will be "only a slight degradation within the
> noise". :)
> 
> We'll learn I guess, in particular which other page -> folio conversions
> cannot be optimized out by caching the folio.
> 
> 
> For quite some time there will be a magical config option that will switch
> between both layouts. I'd assume that things will get more complicated if we
> suddenly have a "compound_head/folio" pointer and a "compound_info" pointer
> at the same time.
> 
> But it's really Willy who has the concept in mind as he is very likely right
> now busy writing some of that code.
> 
> I'm just the messenger.
> 
> :)
> 
> [I would hope that Willy could share his thoughts]

If you or Willy think that this patch will impede memdesc progress, I am
okay not pushing this patchset upstream.

I was really excited when I found this trick to get rid of fake heads.
But ultimately, it is a clean up. I failed to find a performance win I
hoped for.

Also, I try to understand what 32-byte layout means for fake heads.
_refcount in struct page is going to 0 and refcounting happens on folios.
So I wounder if we can all pages identical (no tail pages per se) and
avoid fake heads this way?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

