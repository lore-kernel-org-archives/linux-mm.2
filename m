Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06503C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556A66B0148; Thu, 22 Jan 2026 06:21:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5034E6B0149; Thu, 22 Jan 2026 06:21:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8226B014A; Thu, 22 Jan 2026 06:21:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 296FA6B0148
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:21:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB63A160275
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:21:13 +0000 (UTC)
X-FDA: 84359358426.07.343E42D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BEA76160010
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:21:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J8tDWLDF;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769080871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LkMlLBnVtB58uayg0OjBxpblbKAdejsd+ZAPpjaHleo=;
	b=5h+oWpDKVdeGrjJ+V9CMBXYuPSc3SkThGch/DbHPsqx97Ozx6QHUS0zCFoNVVzZYYLB7Df
	b67+ezNYNykFzd71I8Tz67ebqqArK04A0bCVKJX8Np2DQ593gK6+ab/Swru2/bb07rjZXO
	FJZV2KEnJ9/wABtPIcOxhAi7SIc4TVg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J8tDWLDF;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769080871; a=rsa-sha256;
	cv=none;
	b=oBDZ9UyRSnd6tyqdsA7KTkFfqyR2v0E/KKMSwISMg2gc95c0kB1bPm2gBjqyYpsVwaNIb3
	QBANLGlFtPsvWksr0pyRVmNrAnuacMZ1WF/sRaTLN5wojqV2sC39uLplHEB0rlqOZ/ztuq
	uUJe/rL1p1FiLh69MpDOd94Y2yfkqMY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A99A843F1F;
	Thu, 22 Jan 2026 11:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04515C4AF09;
	Thu, 22 Jan 2026 11:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769080870;
	bh=VVYB42EXsa5dHTnW7jkKj+G3U+OwviE4GOibQcUBCeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J8tDWLDFZJ7a8EY05CViBW55Ec7GfQaMHJ7bQs5Nf29ogSH6AGdHuJRvtIhiBE/PF
	 RcSBwt2nDVNX6xmpEQA1GgWlN/ol7/G/e96zQzlf3LKKG1+ImTjkXCcJoyNB9jKRT9
	 wvuQ6vhVh8hg8eG75dcVoCws7iJpaYfBJhFYVWf8+clgRgFx3wK64PIprO+Xlc/r0b
	 Tb9CuQf/7s23tA4Z/CY0ACY3zzc8iPaGJ+FJm3mRm1Z1kQ0geg4YAaGkej7Hovrnd0
	 R0QTRnQylmOoV+zfB1T9q/twqZzDfNflKA1Wpbsv6ct+fQ554+EzaL6OrC7OvrBo/j
	 vOVZJ23bT0adQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 03631F40068;
	Thu, 22 Jan 2026 06:21:09 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 22 Jan 2026 06:21:09 -0500
X-ME-Sender: <xms:JAhyaSHblGvcUJSLJB_cXK7KFo9tSulKnNYWmc5d1jafjSpJb5mdKw>
    <xme:JAhyaesR7EmfZZCFKnbMePKwmdL6Edw5gMgbTbmgOuXlxrkb8YuwDbiLMWXkNrLxr
    MKwgYfWYLougID0kS4c0QaRI1JGp3EZLwV5cXkdeKMVjH1frENbgf7s>
X-ME-Received: <xmr:JAhyaVjJ8QwrYtsqqWkt92Dc2l6n1-PRQRNKYx2f4RZ895A3FouqpRDL9VcGiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeitddvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeegheduleehveejffdtueehgeduhfeiuedtgeejudekfeffueegveevhfetjeeu
    hfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhp
    vghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppe
    hkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohep
    feekpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopeiiihihsehnvhhiughirgdrtg
    homhdprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopegrkhhp
    mheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuh
    hnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtg
    hpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtohep
    fhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuh
    hsvgdruggv
X-ME-Proxy: <xmx:JAhyaT0SYx4WjkwcZtAqFfwXW9otD6VW8U4thpfdiXFWYVg1tVcA2Q>
    <xmx:JAhyaT59dq4WFuAOYPZHJDGV4ZZYreINFXtMUxF2sIncHtdYHJZlxQ>
    <xmx:JAhyaVoxhpRkVeakoFptGabghnw6mcKLxo3Y-WQSJeSmQjFDB5_UBg>
    <xmx:JAhyaaCpkyAhQeGRQIMdsdR4GUc_ZzBVTOkGm4WGRBLP2jDXuhdZ1A>
    <xmx:JAhyacxTKXwy2b4CVqVOVO1hYX1khOnZAMCpVLulNL2Pw7GIQdK734YW>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jan 2026 06:21:07 -0500 (EST)
Date: Thu, 22 Jan 2026 11:21:00 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 00/14] mm: Eliminate fake head pages from vmemmap
 optimization
Message-ID: <aXIG96srTJw8_2aQ@thinkstation>
References: <20260121162253.2216580-1-kas@kernel.org>
 <bc7b8c62-a8b3-4407-a69f-30b3fd269566@suse.cz>
 <E99A40AF-1535-4FC0-BEE5-6F0F5B3FF840@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E99A40AF-1535-4FC0-BEE5-6F0F5B3FF840@nvidia.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: op7xmxpq9zod9wg1xq56j8wgf934u9t7
X-Rspamd-Queue-Id: BEA76160010
X-Rspam-User: 
X-HE-Tag: 1769080871-797702
X-HE-Meta: U2FsdGVkX1+/t+CxvNPRRHRqS03jNrHA5fgIc0P95xQJghCHDSdC5QV5OJRbESLJDrU2uOqfq1QhL0HEkb8bKvatia5Huxx0hEmiHGJGa9pX+M+NpIqZzLjfJ7PB0cuKMNYVccLVz1nqMTfUQALqKvQDnb9eknMgMDzgWaY5sRAmLem7Yk2bb2muEmZpQJCkX6D0HL49Cfba3hvaUGXvCUDjF4GfoiB6D5PwZ5SkzicEeTmRkvZjNqxnlvHdOu0Z1batzOEGM027HDTm6DwjUteUsmnUafc6Wt9LCrLZB8bbEbfPfGr4hpyBZnCDjyVri6hvAvNoHvgcnhQl/0QTsvxWvATw+Z/mcFkFYYRhMCYWvV5yARk3s5+aWshJIvvi9jXiJFF2gX/41OP5pDewcNs+dZS1+rX2qkEQ1CBrPODyJHmCDFyEUq2QpfDGqnOYDGOmWgKlQiq6a2G0hEI30UeN+BLok+0HVQI5U/OBU1TUWNPq/zlYbEdlwnlwK4BhG/3n3nQdInHdQRfg7pnBJHbVzodVAFjz2P0AxQA1KJxNgdu1+QXKC6ZvnFilrxSekuvG7U4K/zEvyQqYiCuw+4AVOCKaPmnTExZpgGHjuN1BUk0GH2hU8SKE4221LIGhw4oMuOjavg/isgAcTukTRiK7xxVjae44NGv625rYt8ZdCtKoLfXycNnYcjhmxdXLLahGj341ruh3FBxCINvaLRhNEafppOoaVKuMnTAqQD6yVPIPu3upVjXNdSH1EBrFtnEedUBhD+o2rNSikTn3MJmGyqXQVeWRmzkKgy0/3xdjA8vrVG0lO5ja49jTXSvX1/R00reh40Hp1cChNlwaSIDZJvP2wO/Tm8VsYv9/q39LOiFPMJdIyFsp2FapsBr61Eq3dMd5HsnO+CPfdnEjskepNJHVodfRiohM5ICBjTPx5D6Am4AT1iyCqV76LOVc1WDAtznYp+Go8ap27QG
 bW+JuWyb
 HsODN0ur24Zu6N6jnvKMrRx0zTdNBl1BdprI1EZxS/m4uym/nMMkBtfzjhHDBAFNxtvhxl6ASO18CxyipWFX5BosWYrMsvjn/ib6wESJXUz4xJ2tZrBv88K7bc16xukSDMS5R5NcqFmMUecCobqL5Zh6UtUJ49y+cJZMRO8OIT9hi/aKa+ckzTEncpQmamWaXwtxhyUkjpi1lw3ZPXw6fdhWDXbg2ZAilVW678HOKpkHSxnF/hYEZVHPSb5QQkBFlYXxhTVHK6AkUHpLWHlmQRmDeDaqRz4UDkbYFRgq0Xl/vtHHPaJ1LBpzo0uf/5HXhyJGA8+YW6XFovocbsuGEjX0hwaxS0mi8L8mtEk77QpdqXWRvYKTpGT2o1M1jDoh79cNkQWJjGWLVE9dUBCIaaPHSZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 03:31:59PM -0500, Zi Yan wrote:
> On 21 Jan 2026, at 13:44, Vlastimil Babka wrote:
> 
> > On 1/21/26 17:22, Kiryl Shutsemau wrote:
> >> This series removes "fake head pages" from the HugeTLB vmemmap
> >> optimization (HVO) by changing how tail pages encode their relationship
> >> to the head page.
> >>
> >> It simplifies compound_head() and page_ref_add_unless(). Both are in the
> >> hot path.
> >
> > We never got the definitive answer in the previous version discussions
> > whether it's worth to do this now with the upcoming memdesc stuff, right?

Right. Willy shared some details[1] about memdesc plan, but I cannot say
I fully understand what it means for this patchset.

I guess we will find out :P

[1] https://lore.kernel.org/all/aWF3xg-72SV4tmLk@casper.infradead.org

> >> Background
> >> ==========
> >>
> >> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
> >> and remapping the freed virtual addresses to a single physical page.
> >> Previously, all tail page vmemmap entries were remapped to the first
> >> vmemmap page (containing the head struct page), creating "fake heads" -
> >> tail pages that appear to have PG_head set when accessed through the
> >> deduplicated vmemmap.
> >>
> >> This required special handling in compound_head() to detect and work
> >> around fake heads, adding complexity and overhead to a very hot path.
> >
> > So a very stupid question, why did we remap everything to the first page,
> > and not instead create two pages, where the first one would contain the head
> > and the first batch of tails, and the second one would be used for the rest
> > of the tails? I'd expect it wouldn't make the memory savings that much
> > worse, and eliminate most of the issues?
> 
> I think it was using 2 pages before[1]. The benefit of using one page is:
> “
> It further reduces the overhead of struct
> page by 12.5% for a 2MB HugeTLB compared to the previous approach,
> which means 2GB per 1TB HugeTLB (2MB type).
> “
> 
> [1] https://lore.kernel.org/all/20211101031651.75851-1-songmuchun@bytedance.com/T/#u

Yeah, the 12.5%.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

