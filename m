Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E0CDC561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016D26B00A4; Thu,  6 Aug 2026 05:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30FD6B00A5; Thu,  6 Aug 2026 05:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E470A6B00AA; Thu,  6 Aug 2026 05:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B61A46B00A4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:14:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31538A1CC6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:14:05 +0000 (UTC)
X-FDA: 85070282850.13.94B9EA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 89A3D140005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:14:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ahR/JYAq";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786007643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbQN0P9juxp84awMvUOVeJt+czRmTpTGzHczqTVhmjI=;
	b=vcqFn5vmbGZ7L0Z7cwFBnhd4oatGM1dV+oGH76fmqptvVJkAvBTto32hON0lfLDA0yc26W
	ZMJU4xAb+erJ+1yAqd4qPoTDm0s61aOI3CsXRVQOu4qOVuCLaWIHybCOqnpND7VaPlyCHH
	0rdK9/gki6/9rNbYixkg0zOc9qPnuV4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ahR/JYAq";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786007643;
	b=4AS+0aKoC9ElcZcX0G+5SmNyWRJvjizeUSu88q2mC34eOjxuQWO8Pdz6CXShjoyFcyeyNU
	nWp6BFHc4C3ZNz7WmjG6Q7qLin/QCRDuSseNbmApXUbjvnRrV7s+ZQPRXNAFBmW/rAJryG
	RwubL8t7FiYOMD/04knici4E/2aC0mo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC5B04120B;
	Thu,  6 Aug 2026 09:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536751F000E9;
	Thu,  6 Aug 2026 09:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786007642;
	bh=gbQN0P9juxp84awMvUOVeJt+czRmTpTGzHczqTVhmjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ahR/JYAqTsxKULko6tkqNQ2E6tQsxzilFd5mbjlkZ9bCe9jMcvJQBbCax+ukFjdiS
	 FHVNUg/BJYrZ1+athIOIJmRHfasgwhnA08NCjXSHnmeaDeHNfD5KqGgxTQTgcUVpUm
	 AcTVDSwbd7caomvwKfFNoLVCX9bodE0PhtB7ntzEKKsmxShK56Tj0ztIW8HyK5Jvsc
	 b0K/4HSRiW4Z90lQ72x4tVgP3IYh3+OhYmNhjkMMLqyyX8dTw1Wev1zlP6LbLnk0vS
	 t323NiEnfZaa6k0UyLGirhUSeGkRHSNderfEJ0Ye/k3hdThIUIt6FFaV7MvG4P6c4f
	 Vsb7fwccSjcdg==
Date: Thu, 6 Aug 2026 10:13:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, 
	00moses.alexander00@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: avoid skipping pages after splitting
 large folios
Message-ID: <anRPzJiraQUnsHa5@lucifer>
References: <20260806055501.56761-1-cuiyunhui@bytedance.com>
 <699fc1b0-7af8-42ac-9882-c01225379586@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <699fc1b0-7af8-42ac-9882-c01225379586@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 89A3D140005
X-Stat-Signature: cs8cpu9ackxrj39ue6mpdmazf365fdh6
X-HE-Tag: 1786007643-475363
X-HE-Meta: U2FsdGVkX1/wrUxwjuYNXq8qFRRRsSIEKkhqrrzeCJ3IgGm754J0MDMF8OaTogAlfeDWoCdd9TMgLM5SuqFcIf7yfeU6ES3KO+B3GEKNtATn23srb07YIiHyl535mhZq5nwVaM74wX8VMhOdDQGYEWsyCAye7OOPOZvIJu87buIOMlpKzWpyMXQ6fFMgk8YNXfseur9gzCpMNdTiIRRSISjBEbmhb4PNIkeT11uBu8tOl+24YgwwrivN94Kc2+KSu8IX35ydyfGoAqplTQTyRYi5AQcbosl1rWmZ8TbSSYpEQeT6UDPgJbZFmPYV/fn37ulUL5RfQ+QxXMoHC0MzH1x+HEr0AHH8q6BOD45nlmooLy05vtF1RsBXu9WkeTXiV+tCBkjbZI7ZFqETW85xiYvyYcL3kJxFxak8f168Nb5cKom2seY5o9STub1KPokyhfxCE9Sukmt9Ocb00gKaGRnOqxhdFWkTuH32kRo2Vi8opV+2K+N3vVkgaBucI437x2/KfSY5vMjAfRKIqffEGHzzrHSa4Ky/8OL8IZ1IzW8aH6T1Pif8npV0CAbEgsGNlYL9qeuxzq4I7FGGSfHz62iXyeewAJDHIhS1lLfh6Vm4UlsFt1mb5rv/0jepfkAhpvm4lVpJ+4XX96s56DyzZZayrMcDzsS4BS4kF63zna1MF54CS03VzkbB00JhhhXquXqxOjbsKXR8OoA9LTqzFqmV83dR7rgpwY+Y2jRSVLPK5h+MBzIwdPoSGRfyBtb7urHuiI693AU3q1FuyAaVWu+Mv9ADZs36AgYdnOnmcJLInM3AlBFKySNnTkZ2/k1EGBEZcoz2M373ssF22nJLdLng+APgyFO2mVwrNt3Kp0aaiMigdnC383uP5AHoB5Vup4qOIxryPRXFc+2BxphYDqgMrgkXuIGqPaic83tV0pLPPRMc1v/eePHq+qGuX2+tegHGvlAuFcwCome1llT
 82OZ4Hh+
 hsqTt1x2Db+xxdLJsNOxLhXKa9H5ecR0D/9OyV6CTjTWIZWhCw7A/3vaft3lpqiIAvmnMcNtb3TUhKFcYOhV3S6Yi8H1Kkq1OM0iEBfEDtTUmHIYMOQYZkk0W8LlaSp973AdsZeq9XeDkfpzljft8TCjigqJuEN9SIOfL6XCABkI3DkXN4QWqCFfESf1PRJSYWeGZQ5CgEHg3WwrDBMM1rpnR/DDxsu8VnFz6iTzjPy7+YTx1mnZmxZRaHeyN9PKlvfOjU7nNewGjf78gaycMUwmhyI9bENY9Ig5g/z5qDjqPNy71Aq8WhiueBOzXEwstGaq3gDLnLagg/TPpI4jZImrMIeWfGrNNhWcL+Pu6NbcClnimE6aDjQab3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 10:41:06AM +0200, David Hildenbrand (Arm) wrote:
> On 8/6/26 07:55, Yunhui Cui wrote:
> > madvise_inject_error() advances through the requested range using the
> > size of the page returned by get_user_pages_fast(). Saving the size
> > before error injection is required for hugetlb pages because successful
> > soft offlining can dissolve the source huge page.
> >
> > That stride is incorrect for non-hugetlb large folios in system memory.
> > The memory failure handlers split such a folio and handle only the base
> > page for the supplied PFN. Advancing by the pre-split folio size then
> > skips the remaining pages in the requested range while madvise() still
> > reports success.
> >
> > Advance by PAGE_SIZE for non-hugetlb folios in system memory. Retain
> > folio_size() for hugetlb and ZONE_DEVICE folios, as compound Device DAX
> > folios are handled as a whole.
> >
> > Fixes: 19bfbe22f59a ("mm, hugetlb, soft_offline: save compound page order before page migration")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> > ---
> >  mm/madvise.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 5a09cc24f04a0..e9d4c3bbc5290 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -1455,20 +1455,25 @@ static int madvise_inject_error(struct madvise_behavior *madv_behavior)
> >
> >  	for (; start < end; start += size) {
> >  		unsigned long pfn;
> > +		struct folio *folio;
> >  		struct page *page;
> >  		int ret;
> >
> >  		ret = get_user_pages_fast(start, 1, 0, &page);
> >  		if (ret != 1)
> >  			return ret;
> > +		folio = page_folio(page);
> >  		pfn = page_to_pfn(page);
> >
> >  		/*
> > -		 * When soft offlining hugepages, after migrating the page
> > -		 * we dissolve it, therefore in the second loop "page" will
> > -		 * no longer be a compound page.
> > +		 * Non-hugetlb large folios in system memory are split and only
> > +		 * the addressed base page is handled. Hugetlb folios may be
> > +		 * dissolved and ZONE_DEVICE folios may be handled as a whole,
> > +		 * so save their size before error injection.
> >  		 */
> > -		size = page_size(compound_head(page));
> > +		size = PAGE_SIZE;
> > +		if (folio_test_hugetlb(folio) || folio_is_zone_device(folio))
> > +			size = folio_size(folio);
>
>
> We should never ever try deferring "how much has been mapped" from a single PTE.

Inferring? :)

>
> While this currently works for hugetlb, it's just an anti-pattern to throw
> hugetlb checks and similar around.
>
> So this is not the way to fix it.

All of this code is disgusting. Also what about an address range that is
partially inside a folio...? Then presumably the whole folio is discarded? Or
does it figure it out somehow and does the split for the rest of the range?

And what if end < the end of the hugetlb size?

Ugh god I hate all of this, it's so so bad. And hugetlb being the special
snowflake is the cherry on the s*** cake...

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

