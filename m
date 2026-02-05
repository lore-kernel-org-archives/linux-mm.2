Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F784EC1EB9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2A06B0089; Thu,  5 Feb 2026 08:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27B026B0092; Thu,  5 Feb 2026 08:44:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179D96B0093; Thu,  5 Feb 2026 08:44:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03C146B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:44:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6EFC140523
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:44:10 +0000 (UTC)
X-FDA: 84410521860.25.623A022
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8FA80C0004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:44:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6eiX6lz;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770299048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L7dMkP1rn9oGjqGCHwb4LO8pLdp4i+03SJ1OqxlQ0tw=;
	b=JqhPqa7etSV+jJvl0BGr5UionvV2V7aYpYa/DjKrFfI2xVs3Yia6OXvD7MV22Qv/TzSHuk
	w5OVwF6SoZrXNNVh1Kx1PL+67TlCDe6sUN+sWh8gP43ZE1A+rMg0Q2Plp5Iqahu6ybYaPJ
	oBEKDlNq2nFoE2YnOghcyu0Cq/eYuUY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6eiX6lz;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770299048; a=rsa-sha256;
	cv=none;
	b=pzC1lfTA019PqlMnAulBvDCAZMiFajXeqnf14wukUIXidMcVOh48jpEQTixYdcHPfCzmnA
	8dMxFELZGx4N/ouvpHEfPg+iQWHFAbZCdGp3qdkAiOa2jEjqvzQC2KgzggF2Z7wUq8yiZJ
	EwxKG+k7HyGp+A6Gahu+wQOkLJz3iLM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 881A34066E;
	Thu,  5 Feb 2026 13:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C666C4CEF7;
	Thu,  5 Feb 2026 13:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770299047;
	bh=zbAqPoMW8uRm4vnv38zuUnwWsFnsj8UNXtCVNmXf7C4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J6eiX6lzbwi3mcjWTLjOR9hgujeNI51sOYc0ooy0Mi4x7K9F8hAUDeeHzKbynrFn9
	 kRGp+YJO1sZleB6zcJVAYCc1dOWZMTP6KVx/17TKAL4r3B7shQy7wMRQ2Kz2kx4pIA
	 UCFlHD1snGZk4Qt5doDftxIBkgzBt8Gnc6m3r5Pz11COTZDAjKNiacUv1NwhCPAU7t
	 uOGg/15FZBbvs5jNQfxXHOIRzO1lvRXi+7EAwXM839tx37Ul+D5NCbibqg9Hj58qoc
	 J32wQHETLbxMyiaAf+aaFU66WP5HRaVGi1KX7PaM9SMZU+KU6fPuNMf3BenMSRl74Y
	 0Ciu0j6Wi5/Mg==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id 86159F4006B;
	Thu,  5 Feb 2026 08:44:05 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Thu, 05 Feb 2026 08:44:05 -0500
X-ME-Sender: <xms:pZ6EaSwZIqcQbi3eSr2YeSyNY4soW7jIrW7KmxqFCodpBsJhmMqIng>
    <xme:pZ6EaR_6UL-HGKaU9kn078cFaH47RcIX-KhAhlp-s0QPg22Tvt0mBeORnm4DgAasp
    a900ohlCLT7uvqL5JOucndpSFZmzDKToYeC13QOxu3CJbz9yRWFf_1A>
X-ME-Received: <xmr:pZ6EafZmGKOvZwxi9DHeE6Y2VFHt1kmMw83NW8vMrNwYQ9lhbGY2CIFNR5dleg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeehgeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeludettdeigfefhffhhfelveeludeuleduvefhgefgueeitedtleffudegfffg
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeehgedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlih
    hnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehmuhgthhhunhdrshho
    nhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrug
    drohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdp
    rhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvh
    grughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:pZ6EaV-6JVghQKxYV_55hxtxUr4iQA-30PgRWCcUY9Xf7uhmyhO0Lg>
    <xmx:pZ6EaZjRTUOTpn-mSaE2tDB2ylLW_8-qfcbK_oEpeURhBS7Ej8EW0g>
    <xmx:pZ6EaVlVwycuCa55s_M8An0K5sVkf5dS5d_JRAvkWPk7p2-WBE0hZQ>
    <xmx:pZ6EaWCl7a_Al3zWzIrd-nfqWzXQPB4PFdHAg5OpAt3vK9Z9oYlT3w>
    <xmx:pZ6EacOAkLoPSQQtH2x-RFqLuZSXT0NwgUCuBq8jTs4nTH97CVjwbWAA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Feb 2026 08:44:03 -0500 (EST)
Date: Thu, 5 Feb 2026 13:43:58 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Subject: Re: [PATCHv6 06/17] LoongArch/mm: Align vmemmap to maximal folio size
Message-ID: <aYSdW2YaJdpgXYos@thinkstation>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-7-kas@kernel.org>
 <2ce0e684-de54-43ec-be7d-c58bbffb3f4e@kernel.org>
 <062900fa-6419-4748-81d1-9128ce6c46d0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <062900fa-6419-4748-81d1-9128ce6c46d0@kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: oz3ez1nciiz96w3uzwu5zxcxtk5dbpsj
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FA80C0004
X-HE-Tag: 1770299048-510585
X-HE-Meta: U2FsdGVkX18+uucjjcBA/VPyN6VyNRIh0+IUo958T85Y7uvwSzPLk4ZUY6s7cfbbN9xqUTX356ydMT3jV4OraKvIvgM25BsLHhKIAw1aZi/8qX1iyOUITCSTEBGTnU3ZDjqE2q/VJ+jV+vwSyQIEkH3xSBIMMWiC42xd8i+rJawvn2qFcU/gGstJpD9xlSFwaHwgkP+MA9sw+PqohvHyFWP2Jz4WqoMKmMuEAtDk3GpSxheffp6SMMMmmUmPGXwisppLlseMFDfD4xC90PSQRdQEx7tgU3LpIz7yOEZMj6aKFmj4F/34he0v3izS3oLN00NEdzzmzaXymPk8hakwC5MkjrkS/nc1Ps8dDtT2Gm/whkpO0EF+7VJs4mECbP09C+irVaGlXypsHmifQIiCIoDKqNegVBtFo9B7SdrwyCmkvADeYw15BXL3u5qVfySNCOYSweslvQbavvlkWGSWBVDUt9iQRJzhxcHmgSvqNG9UWYalD4wIxRRTzkv3aeSIU1ObR/lFjbWE4NSZJkoBBGeswnmLReS5aaNHw3h5vEys9btoJ2BR8Iy0QGbteIWNuQz9ZSxm7bhOzBM0kW5ne233R/vXJPXzU9XWZ2iEGesv2FYEG55owhsLO+Tqb010hUadCUm8dpigYxiBYjpJigIkLxiLlIiyKfmKlM1adWWcIfrkOew9zJlAtMgoZQc8Ynl//MX/IKp7ByMzi59704brnjaEpgplX18we7EoORFyYUFB1dF+5OM3+UcpfEp8uYvfnyh7RwEasOP6JO5HVLS4ilNVgh1F5lkOyxBB0nfHw3Xa0E55lYhtXCx0uAS+lcw38xNtjU7O91UAcQF7rejEFJxPBEOCIZe6a4wXtd20LMA2VvewSn+1yxOAht8wwPQR/kd+LBtoaNVhl0aVtgaJAtHwexkrmSf2IP0ggxO+xeiIplllpwMI+qqSBkSKaXHDhjCEX28TBi7mqos
 W0QP2BCc
 c2ItFWEMt/6M6JFvzMpusDOnC34idkYChY4ldlxcVV4wdHAwUvNMEM55HrNVVJDd4v7ZcwCMXiJvRd8R3ErvJSBxW30CytVWM+5k1X0VWPmoZlJPI18Fn88XMvcVQPcI3JjPupUqSUKFm0FbDutkeeVJJtFGW0Kky66hR7fSeD368+ZOjdG/qPhysfF4ZV/yj5LAk5gD6oDhSbv1WuiD+m9rHnrq73pTntIKubgjrHEex9rR9dD0xrUyds4y1LaQIG1iNP0wrGTs8EZmHk3/QvNKlSjN4TKvWTeAypPUHMd7L838TSQ4x+5te7VrFUQoI9T8bcogliVZxvg0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 01:56:36PM +0100, David Hildenbrand (Arm) wrote:
> On 2/4/26 17:56, David Hildenbrand (arm) wrote:
> > On 2/2/26 16:56, Kiryl Shutsemau wrote:
> > > The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
> > > struct pages of the head page to be naturally aligned with regard to the
> > > folio size.
> > > 
> > > Align vmemmap to MAX_FOLIO_NR_PAGES.
> > > 
> > > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > > ---
> > >   arch/loongarch/include/asm/pgtable.h | 3 ++-
> > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/
> > > include/asm/pgtable.h
> > > index c33b3bcb733e..f9416acb9156 100644
> > > --- a/arch/loongarch/include/asm/pgtable.h
> > > +++ b/arch/loongarch/include/asm/pgtable.h
> > > @@ -113,7 +113,8 @@ extern unsigned long empty_zero_page[PAGE_SIZE /
> > > sizeof(unsigned long)];
> > >        min(PTRS_PER_PGD * PTRS_PER_PUD * PTRS_PER_PMD * PTRS_PER_PTE
> > > * PAGE_SIZE, (1UL << cpu_vabits) / 2) - PMD_SIZE - VMEMMAP_SIZE -
> > > KFENCE_AREA_SIZE)
> > >   #endif
> > > -#define vmemmap        ((struct page *)((VMALLOC_END + PMD_SIZE) &
> > > PMD_MASK))
> > > +#define VMEMMAP_ALIGN    max(PMD_SIZE, MAX_FOLIO_NR_PAGES *
> > > sizeof(struct page))
> > > +#define vmemmap        ((struct page *)(ALIGN(VMALLOC_END,
> > > VMEMMAP_ALIGN)))
> > 
> > 
> > Same comment, the "MAX_FOLIO_NR_PAGES * sizeof(struct page)" is just
> > black magic here
> > and the description of the situation is wrong.
> > 
> > Maybe you want to pull the magic "MAX_FOLIO_NR_PAGES * sizeof(struct
> > page)" into the core and call it
> > 
> > #define MAX_FOLIO_VMEMMAP_ALIGN    (MAX_FOLIO_NR_PAGES * sizeof(struct
> > page))
> > 
> > But then special case it base on (a) HVO being configured in an (b) HVO
> > being possible
> > 
> > #ifdef HUGETLB_PAGE_OPTIMIZE_VMEMMAP && is_power_of_2(sizeof(struct page)
> > /* A very helpful comment explaining the situation. */
> > #define MAX_FOLIO_VMEMMAP_ALIGN    (MAX_FOLIO_NR_PAGES * sizeof(struct
> > page))
> > #else
> > #define MAX_FOLIO_VMEMMAP_ALIGN    0
> > #endif
> > 
> > Something like that.
> > 
> 
> Thinking about this ...
> 
> the vmemmap start is always struct-page-aligned. Otherwise we'd be in
> trouble already.
> 
> Isn't it then sufficient to just align the start to MAX_FOLIO_NR_PAGES?
> 
> Let's assume sizeof(struct page) == 64 and MAX_FOLIO_NR_PAGES = 512 for
> simplicity.
> 
> vmemmap start would be multiples of 512 (0x0010000000).
> 
> 512, 1024, 1536, 2048 ...
> 
> Assume we have an 256-pages folio at 1536+256 = 0x111000000

s/0x/0b/, but okay.

> Assume we have the last page of that folio (0x011111111111), we would just
> get to the start of that folio by AND-ing with ~(256-1).
> 
> Which case am I ignoring?

IIUC, you are ignoring the actual size of struct page. It is not 1 byte :P

The last page of this 256-page folio is at 1536+256 + (64 * 255) which
is 0b100011011000000. There's no mask that you can AND that gets you to
0b11100000000.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

