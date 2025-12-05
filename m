Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA9B7D374A6
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 22:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102E76B0304; Fri,  5 Dec 2025 17:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4246B0305; Fri,  5 Dec 2025 17:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C976B0306; Fri,  5 Dec 2025 17:10:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E20C66B0304
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:10:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90C2B14035D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:10:17 +0000 (UTC)
X-FDA: 84186811674.22.2B1782A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A35B2140011
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:10:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r8p6WCFD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764972615; a=rsa-sha256;
	cv=none;
	b=NDFWbf9Onq3LduudNcxD4xDCbd0lROL3Bs8CpXbepfUnPe38xnkUrkuBC2036vT9MA3vFm
	HHVqV6Zx3yh2pee66o2GDUZmlPtB1EfhnhkBduFoH8+scFnD37SUQQss1lVyG7AXhsmEW3
	Em1rHlDvFfgPy1QL0ja4g2p/0jURAtA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r8p6WCFD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764972615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/78CTXbZFLfSKJkBixdI084n0UpqcWSTWKT0znjLAo=;
	b=S4EVpdgbyn7udqCgZr53KTeGpmB9JIeU8sCgO4CpCKZEBnsTmBcCuzxvAGfpZmxnHvPUmG
	60isrCIx0on63zC+ISgjscdKgMEWe5bB0oxefuZmZsixf5Eu7bKhQBOfKK/YwDj1e0jSWb
	kNYXi58g7MU9/78eCvm/4A1egjWChxc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2033D60149;
	Fri,  5 Dec 2025 22:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7EDC4AF09;
	Fri,  5 Dec 2025 22:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764972614;
	bh=lIKjTgPBkbtkNkZzV1zzL4vEwZKkRTteOsvjZIgfEmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r8p6WCFDaD0XZ84Y40DgvY3vCMYQKNgAimUEydRrJcE9QAczXRznmXKq3TLqbMTnU
	 TyHvCB1s4/W98OFiVD7Q3dkuNOlv5JeEmTuLvrFNg01TKH7SAC5rim6DAiC2Y+T6x0
	 np1dqvxkx6fLEW9C7lp9byI2Nw1S6UgRpZmMdH4/SUV3jeABCB6Yxn26u0xAnvoBZ3
	 xiRpk8KcquMzsaojM6wVvMr4bgnPOiFh5X8vqwhaxre/Z4X5NHS3VSOSoPgW3DM6Ro
	 NFD7o4Z9tpWDJ/DPy3UlRlR7heGm9tSaMuFvpYxsX44QlNoVFlKsqMePviwbKKQYgu
	 xZ503Cz36WbkA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8D19EF4006B;
	Fri,  5 Dec 2025 17:10:13 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 05 Dec 2025 17:10:13 -0500
X-ME-Sender: <xms:RVgzaaJdc8RyNAK-Xw-tiVY4O3QG2rzyhNDmTGubO6yVzS-aGdNK-w>
    <xme:RVgzaY_PtrxqgeNtnJJu3ILzPskav7gD9gUNnRgH3QrmHpzhOySxaLe31RDtrCDg_
    DKhrJO8YcAH2oXsbWNJ_t2ILLMMiJROUl8NNogs5qPuAa-eiuuYILI>
X-ME-Received: <xmr:RVgzaTpwss-vif6B3G4HY5c8r7Dyp9fwWRTh10Xa-KitZ2srFwKkn0bmUI9nyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelgeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepfeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgtphhtthhopegrkhhpmh
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuhhn
    rdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhrtghpthht
    oheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghkrgesshhush
    gvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
X-ME-Proxy: <xmx:RVgzaSOwR5lbPABwAXY_OiFWmselEho1L5jrEmxEnpdBMbY3BKv7Gw>
    <xmx:RVgzaVr0uYVHWSA5a4lJtiXj9WegyuOasfVUIt_5YNRfxjmO8O4sag>
    <xmx:RVgzaZhOnLOeqe11i7MJyeMM7duOTLSUkOqMnDwR83gOb90SoHggaw>
    <xmx:RVgzaW1DCjdlHwEHcc7DUmKFMD0KR1oM2llDFCTibQXJZcc9I8g2kw>
    <xmx:RVgzafbr1-n7T7JBITZvqBDnjRqL_EF8Yd5EtbvCUYPZ9dDN3TtUFhZv>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 17:10:12 -0500 (EST)
Date: Fri, 5 Dec 2025 22:10:11 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 01/11] mm: Change the interface of prep_compound_tail()
Message-ID: <gdkhm6ckcrwy6ezetpb6u2m4sfdeqsf4ftg2vb557zipvdepyh@u4f6pyrompd7>
References: <20251205194351.1646318-1-kas@kernel.org>
 <20251205194351.1646318-2-kas@kernel.org>
 <77d1911d-7b67-41c0-933e-b2a0810cf3b4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77d1911d-7b67-41c0-933e-b2a0810cf3b4@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A35B2140011
X-Stat-Signature: skyj16r7wg3gfiwcrkfqwmqd3a9wzdyy
X-Rspam-User: 
X-HE-Tag: 1764972615-430085
X-HE-Meta: U2FsdGVkX18VjRF6YYaEgO+z4udZ+D9w5oA5cp9tRcfwwSHujvsr72yBC+C0IzoH2EP0HNpsp9Aupl+o44zQGFRb+KGWtv8wcRr24wDd+HzacRmPnrhMwdLzIItcCTJ8gTE5aiwLtBVAOoYw02zR5dYNOTT/l/0thFfc87XqLXn6fD/SM0xTPRzcz7tvqnUt4e59KIIjzOB2IbbOltCYl6raMfYDTRxL11rcbhMPmwS8Egh83e4edYYtnKrHeJ3TCduhPT+v+7XfqMsGLmzYtkwYNUNvpdxJABc4ADgPDGAvY87m6NqXfQcLQzLtFMtNAGV+MC9JHkys+htKId87tWUsvzr+H3SSP9ww6hh4APd1DlpbC3Hr/3F7XZncT/dFu9jUiwyfHFgQtlwU9pdKvX68PFQfZjOZxykf76CBlXnbfDrXPjfmGek7L2+0+a22FZcijJpH0s1ydIzwuIYpDOjsL4PY4nQu+vLp1k6cUbDzjJZg5TdP6YTYhtvJu8LqNnNBsggkEpVdWFxFolrdD7m69SL98ejFeQd32OUV5ftTgmfSmCWl0O994Q5V0m3Hv/OTgaqJM4ZfCdDXFKrgMGVKi3v3b0nVqK24bL7Pt5UGq8mMmO7Ga0KF1NSvxh6aSdqfVz2bFwdvYu35zBVVYS4sT8lmPuBGgL9KMyR5IZxJ0RvktM5Z0RDfDc+la1hC7abnqsiLzOEbHaQ6DZ54rleGYPOedh16ybnTDwDnulydiOscWGdnyQ5mfsfgxGtuEI+r+u6FxvwHH8L5jZfH7nYlPUPRIvl8lFMbhkYXVEWzj4Bp2mjIrNviPUlzlzxnCo6v6IHoOyavRquVgTYPVNHu9AvxSVPGOcMRPGm9mLRA1gruFJvA9BgZC5g6+MxfAZ5WJPiEZXh4oQb/CYCG1FBvymxQiqk9aWBNvC/ki0inLGt6viTyI86kNn+117h+GiYoEN7FtVtrnsb5atv
 WDobedpx
 OgNbFbuJ/hTgQKghsfpLz4nZEGhAHUoRteCFIYbEnpJBawTMNZ171otDpnqk7M69FA5YQ2jPtaJbb9FGRCmk97W6L3pgB2EPIYU6umJwdjxVI3kOkg7ZBifOeONpNK5CLxjdF/090UDb3jyj5I4kNSHxGm42+BkD8NnxhlTIHW2kfYO5V+6DQbjJmgaE3wes353L3UZ1OnynCeX/t4XMbeRzHCo5vH8Iw0Ahlqdby8/FwKC6OUqhrdkilc9gMAWxvGgC2HFKUuBX3TtlQ47LpLaguejxCgXt0V8SiF7rnF3H6FcNu9xUsI/1gb1uRvGO1ZT8axqsG5PXWAn5DYf6zMBQ6ChbH+hISzW1Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 09:49:36PM +0000, Usama Arif wrote:
> 
> 
> On 05/12/2025 19:43, Kiryl Shutsemau wrote:
> > Instead of passing down the head page and tail page index, pass the tail
> > and head pages directly, as well as the order of the compound page.
> > 
> > This is a preparation for changing how the head position is encoded in
> > the tail page.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> >  include/linux/page-flags.h |  4 +++-
> >  mm/hugetlb.c               |  8 +++++---
> >  mm/internal.h              | 11 +++++------
> >  mm/mm_init.c               |  2 +-
> >  mm/page_alloc.c            |  2 +-
> >  5 files changed, 15 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 0091ad1986bf..2c1153dd7e0e 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -865,7 +865,9 @@ static inline bool folio_test_large(const struct folio *folio)
> >  	return folio_test_head(folio);
> >  }
> >  
> > -static __always_inline void set_compound_head(struct page *page, struct page *head)
> > +static __always_inline void set_compound_head(struct page *page,
> > +					      struct page *head,
> > +					      unsigned int order)
> 
> I can see that order is used later, I think patch 4, but probably this patch might cause a
> build warning as order is unused? Might be good to integrate that into the later patch?

Is there warning for unused function parameters?

I think it will blow up whole kernel, no?

> Other nit is, do we want const for head here? (Its not there before, but might be good to add).

Sure, can do.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

