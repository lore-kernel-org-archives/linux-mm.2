Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0410ACA5FB6
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18ADA6B017D; Thu, 22 Jan 2026 07:43:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138F56B017E; Thu, 22 Jan 2026 07:43:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0442C6B017F; Thu, 22 Jan 2026 07:43:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E78E76B017D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:43:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CC231AF45A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:43:06 +0000 (UTC)
X-FDA: 84359564772.17.7D245DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A44C5180002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:43:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dHiQCIuW;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769085784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNWwXcdV9Ya6UyS1z9rRdOAQ+E17+4WFUgvX6AUp9po=;
	b=krhKyJ+HkNo5c0B+EA3vv0lo2I78+P2NRnV0ddavahPKT5ywMd04RrxRLrymWjFKbEhC5H
	GxI7hLFFyGARJPRCaHT51xhXEGdNw56ZolVZwaRJrpbBuKLMI9t0M1HrloaqXovcmdXhHA
	Y6dVP/67sdFyiVhOW5RvE7NGGxf0K4E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dHiQCIuW;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769085784; a=rsa-sha256;
	cv=none;
	b=BvLDQqi2/ovSUxqvg/sYI3A0iLCwm45UUbO96UraLNgbiiqxXhj3yiM3xnxJ6gXqcx87J/
	NJR5O4MLALEWsxM3U9W/PcQ5v1taW6P0NbZ/ULL3mWSO/hhlRSr2TPoascS4t8ye9P5/YU
	Z/JtdeddcFlUaj4DPqLNuMuTLsIOurM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9DA8600CB;
	Thu, 22 Jan 2026 12:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B73C4AF0B;
	Thu, 22 Jan 2026 12:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769085783;
	bh=Ztrx9kB3sLLvVxl3F+YuROIMVvnwytTbGDwHp6NrGTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dHiQCIuWOKbaSX2Lbh3uBQRcAO10WYzApvYfHdq5kRLf0mvAncuYOdPIxiVzhZ6Ph
	 96TlwDoUOTqdT3d6vuGGCONI+gYS0Z0DFm+jDrtZ4ImheYeFZc4+i5AFg0EjwsJAFA
	 yHMQBteGRC1M9l5LVewEJxqzUbU32owP6k0lRw/RehJ+2XoAz9Ij6VTRIe8NkL06r9
	 oOkOuRjuonCVdq/C9DFkxMc0/mGLMJt4+1ScHjN29wj6uhJ9zI3UlgmNNuH4BS1T48
	 W6XxYvZ4O0oPJqO1crlREGnlxAQLJVGBZtMGVdpz2SdJ5uLKU88o1l5f7/9zc+nqeI
	 vtf5TJkzJ01Aw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id B9123F40068;
	Thu, 22 Jan 2026 07:43:01 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 22 Jan 2026 07:43:01 -0500
X-ME-Sender: <xms:VRtyacdaf7vmyWJ8ck7gwYWgDmh0FSbz_wuhX8ke4j_HrFos9-Q8DA>
    <xme:VRtyaZmPe6BGVGdHB0QMpMLu-D31O8kg1ZVJuWrNTbsrY93c7sPx4cTGynH9xXagV
    cpXyzl7uuvYbSoK5SYRusJJncW5V4MDq04GQKot_igSUbBlQ5et6gY>
X-ME-Received: <xmr:VRtyaW6gXJN7Do3aN65qSztIC79H0zFsiD0fcNCE-Gop0AKdPGbGIMmdjPpwtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeiudelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtoheprghkph
    hmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:VRtyaZtqZrPYwJbsyLU2hTO4fJos3CvZcAgwzYNKToxvXEx0DNh2Rg>
    <xmx:VRtyaUSR7xynwHWQD72-6a3L2xR6kQb1PFsFdbOlWFRRwB70QSNs9A>
    <xmx:VRtyaegbmQ9CQ7fqfYvTRkdfQKnA1-QdjcxenniXH3bBwxA0Kw2X6A>
    <xmx:VRtyaRYcReUFB_XhL8YiNdUuPBSEq0WGbXwic-9mYv5XGyumqFqBuw>
    <xmx:VRtyaQoUVYE1wmPna4NPKTqbRY_1dxVLJXaqxgEOiHmPZxaQzXOiTD0B>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jan 2026 07:42:59 -0500 (EST)
Date: Thu, 22 Jan 2026 12:42:54 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 07/14] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
Message-ID: <aXIaHZ5kNFelmuJi@thinkstation>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-8-kas@kernel.org>
 <71F051F2-5F3B-40A5-9347-BA2D93F2FF3F@linux.dev>
 <aXIJY5irR0obgdQe@thinkstation>
 <35B81EA5-D719-4FC4-93C5-674DD5BFDA4F@linux.dev>
 <45434FC3-455E-4CE8-9F43-F398D5EC73A9@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45434FC3-455E-4CE8-9F43-F398D5EC73A9@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A44C5180002
X-Stat-Signature: jzqu6pzd9e8qz3eggcqg4e1881ickt7f
X-Rspam-User: 
X-HE-Tag: 1769085784-588346
X-HE-Meta: U2FsdGVkX188efv68FF04YSAaVKf1WSnkYYFNCkKvlbhnjx/94nwqLOxXud1kmUWAgDet2LhPuNr0IgF1VWyJHwgOGansfN1n5TxP2rFKNLMqRHT/U1uyUpRqq11nurlJanT695ZrugerudOXSZmNfF9ywdeerhkx7799/HpC/QwFoJEBo6L8K6JK+ynQEr61lOt022QtzuL4o/YaZvXu2g12e+4aejjyNX91QSIjCg+pwoBFdzmP5GIQAfyIGqiCl2sr5uVVVmgJ5qufJcUyv53vV7MFy62BPO5RY3ismvrj88+iu5PXAwrqFKG5KKn3SSTsLkTFClfo4NK8mCfPlGtC88hZzLPUDzSGVrpIgpTB2hGmMbHhrA0p8zFLca7OEjcagZGUmt49ZLCCeqXolqzTOME90JxGcXqR6AzDetEFIrKzru9kVi7JFMFcUF5EdgpV2YwPPjdx0PxljEpwlCH/r2vjliXMxNupKze5F9RCYNM5c3cZOdY6Cw0+JWjOQgoRw1NpMygYja1g372Xxv2yHYm0uaKoyF7as5dpNwS/5c5sL/iLOigzNDl0A58+oQgSpfYeL3Ynv3sAXv2OQ5ErliMp7Tjtvq5M6+oUjFfCvvjseolD0Fh5g3HyZWT5CmBWmyoyGSqImpAfQwwlloLiXoSwOHMUP7nc2XLcYv9mSulL0YMo1Y4K/zrHOvkIRYmuDK0gIoNa1zaEXdY6YzlFEuTAgIuj5Itzx++oyLcLtGVvMY4scpMRQGgjHH4wOgOew+Z6XsnKCozN6z/jbZP7tL67Jmpze+LDs8Mh9CqaZPwULjyqvnzqXOpfWAxvGLY0AyaC0CMXgbTVImlkOa5zJ9chhoeDZWj7hWNwfYGBFcJbTkUhrbQ5l8M3zNVfqtY1j5VnXpB+6VFligRneS607gh6OhtlIB69yySe1Fk1Fr7h6Vzo8/6JsVFUo3OAyng3NhEsjDu1c4XDdu
 lLTJTQsz
 kyGv4Oh9CQgKG3dnOQS8sh8Xke+ZShp1HpJjSsDPOorf3OUBxdvEB/mjs9ykjq+5hOCindJMYQ+vqyDlIv/+dhGayqnmj7XdeBtULB+EwVEnhZUKc1HDMUhlbJUyT78ztnNuVkjTDfDpWhJJe8ijaLH7kiwTjpCTDUP8xjJzjvw2nsfuWuGXdU1eikFQehjNwHKVjlKQzDhHVRDPhH4duZjQm1DddCsgSTpRxHpvBHebEhdcSurvgwmmt6SUFcT467i1A+8/Kef1QnDG18pe2q24NDQOU+CyU3Q2Zw+qaNskhKSdcQbD5KyuC7RwumDBupbqyw/DiSGaAywpMwlVgMvlTjv3Tr+O9zxkK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 07:42:47PM +0800, Muchun Song wrote:
> 
> 
> > On Jan 22, 2026, at 19:33, Muchun Song <muchun.song@linux.dev> wrote:
> > 
> > 
> > 
> >> On Jan 22, 2026, at 19:28, Kiryl Shutsemau <kas@kernel.org> wrote:
> >> 
> >> On Thu, Jan 22, 2026 at 11:10:26AM +0800, Muchun Song wrote:
> >>> 
> >>> 
> >>>> On Jan 22, 2026, at 00:22, Kiryl Shutsemau <kas@kernel.org> wrote:
> >>>> 
> >>>> If page->compound_info encodes a mask, it is expected that memmap to be
> >>>> naturally aligned to the maximum folio size.
> >>>> 
> >>>> Add a warning if it is not.
> >>>> 
> >>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
> >>>> kernel is still likely to be functional if this strict check fails.
> >>>> 
> >>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> >>>> ---
> >>>> include/linux/mmzone.h | 1 +
> >>>> mm/sparse.c            | 5 +++++
> >>>> 2 files changed, 6 insertions(+)
> >>>> 
> >>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> >>>> index 390ce11b3765..7e4f69b9d760 100644
> >>>> --- a/include/linux/mmzone.h
> >>>> +++ b/include/linux/mmzone.h
> >>>> @@ -91,6 +91,7 @@
> >>>> #endif
> >>>> 
> >>>> #define MAX_FOLIO_NR_PAGES (1UL << MAX_FOLIO_ORDER)
> >>>> +#define MAX_FOLIO_SIZE (PAGE_SIZE << MAX_FOLIO_ORDER)
> >>>> 
> >>>> enum migratetype {
> >>>> MIGRATE_UNMOVABLE,
> >>>> diff --git a/mm/sparse.c b/mm/sparse.c
> >>>> index 17c50a6415c2..5f41a3edcc24 100644
> >>>> --- a/mm/sparse.c
> >>>> +++ b/mm/sparse.c
> >>>> @@ -600,6 +600,11 @@ void __init sparse_init(void)
> >>>> BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
> >>>> memblocks_present();
> >>>> 
> >>>> +  if (compound_info_has_mask()) {
> >>>> +  WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
> >>>> +     MAX_FOLIO_SIZE / sizeof(struct page)));
> >>> 
> >>> I still have concerns about this. If certain architectures or configurations,
> >>> especially when KASLR is enabled, do not meet the requirements during the
> >>> boot stage, only specific folios larger than a certain size might end up with
> >>> incorrect struct page entries as the system runs. How can we detect issues
> >>> arising from either updating the struct page or making incorrect logical
> >>> judgments based on information retrieved from the struct page?
> >>> 
> >>> After all, when we see this warning, we don't know when or if a problem will
> >>> occur in the future. It's like a time bomb in the system, isn't it? Therefore,
> >>> I would like to add a warning check to the memory allocation place, for
> >>> example: 
> >>> 
> >>> WARN_ON(!IS_ALIGNED((unsigned long)&folio->page, folio_size / sizeof(struct page)));
> >> 
> >> I don't think it is needed. Any compound page usage would trigger the
> >> problem. It should happen pretty early.
> > 
> > Why would you think it would be discovered early? If the alignment of struct page
> > can only meet the needs of 4M pages (i.e., the largest pages that buddy can
> > allocate), how can you be sure that there will be a similar path using CMA
> > early on if the system allocates through CMA in the future (after all, CMA
> > is used much less than buddy)?

True.

> Suppose we are more aggressive. If the alignment requirement of struct page
> cannot meet the needs of 2GB pages (which is an uncommon memory allocation
> requirement), then users might not care about such a warning message after
> the system boots. And if there is no allocation of pages greater than or
> equal to 2GB for a period of time in the future, the system will have no
> problems. But once some path allocates pages greater than or equal to 2GB,
> the system will go into chaos. And by that time, the system log may no
> longer have this warning message. Is that not the case?

It is.

I expect the warning to be reported early if we have configurations that
do not satisfy the alignment requirement even in absence of the crash.

Adding a check to the allocation path if way too high price for a
theoretical problem.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

