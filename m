Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89558D7237B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 12:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBEAE6B04B3; Fri, 23 Jan 2026 07:07:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6BB36B04B4; Fri, 23 Jan 2026 07:07:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78086B04B5; Fri, 23 Jan 2026 07:07:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B693B6B04B3
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:07:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73D67B6E9F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:07:55 +0000 (UTC)
X-FDA: 84363104910.11.E78891E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 36A5D10000B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:07:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFNNf5Pg;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769170073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdQmGBfgLMsecc9gOEcEfGmPUgY6m9SP2lDTiBcYU+Q=;
	b=eKjFxrkIYdIz27Dp6Lr0FXT00ieo+CKp+zEVcYZbK/AtZD4ipUfwyZ/f8ut6sV69qaFIpJ
	3dCGJNBcv0iyvdGwKtJtxa7aBtcRMoGJhvH4anA6uvN03wyD/yJ5FcOEJkw+8nSkEPJqxr
	F93lhMoFn3DruhaALT/R3lfExD4gOb8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFNNf5Pg;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769170073; a=rsa-sha256;
	cv=none;
	b=idGi5cArgkc34QBKj17XpmZ//XlRlf44h3x1C8yIElQ6FSYNTBf5+ya99l5T1f70oowxhb
	caEkX18Zw0XYGGfNRutJ0feFzWIvqMQDWMtT4FY1B4TZRXkdMdZYsWdVSBhRMU7fMI3dwk
	d26cYt2ri2zgfP6brQsrtBpBAnjYkmI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C81A1439B0;
	Fri, 23 Jan 2026 12:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCC2C4AF0B;
	Fri, 23 Jan 2026 12:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769170071;
	bh=3H/odp/t23Ct26qULejLGL9eCx2uigeb9KE7ad9Nqds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jFNNf5PgBvA6BXYYEnsMhlWKfn1lJ/V12WSYZh5tcWeIyR9691i70Lb4zFCdS7TJK
	 DFBHeobW7LBixvxiNKnJ1vEgnp9X2E3t6aubncLuCcs6w/yDGfqMX90nVqlr7MPM5Q
	 FtSq1+u/fDDSup/fxBnnfJ84HYzYOcyF0yuG+Zba/M0rdjJWau+gipY+ziy4DHPC2A
	 7RzZiXUPOdXLCWFQ/ysJgdSozU3kjWnnV1MocjW4jK+oLSDGatgINWefyAYveWlbCK
	 O/YHnCArLpvgoj4xbEmmC4nvOY6AFxMTWzJuLx1GIy8q9+MrUw2nvOy3BuSerJmiyl
	 HYgQbJ1niDhqg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1F11CF4006E;
	Fri, 23 Jan 2026 07:07:50 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 23 Jan 2026 07:07:50 -0500
X-ME-Sender: <xms:lmRzaVIOlB_JV0csn_DGddlprFl-djXl57SIdYFQJqaOSUXjP6yHKA>
    <xme:lmRzacjjvuTRntHvOZ7LYaNiPQXyo5qgDHhkLFNzJwguJhs4PIp4TX-K2R3xZkPq8
    JNGu0tWB0KdA1VohAH7XJUZwCtu2SnWQS6FhUW21tDvVAvSxZL1Gj5W>
X-ME-Received: <xmr:lmRzaXGy_X4xOaXiwJhA1MnRwtUtrJJrhQ-NnwmQ-qJ93uMTCcdv0HgLRMtSoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeltddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeigfdvtdekveejhfehtdduueeuieekjeekvdfggfdtkeegieevjedvgeetvdeh
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhig
    qdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdp
    rhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvh
    grughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:lmRzaeLH7fGtUqXPn84rRWAxcgwO29mKn-NbPpiSQaMlJo1mfcVewg>
    <xmx:lmRzaX8S1OlDMjVb7OvvndvBr36gICH9PPOFEGUsJvmn4MmgzxHcWw>
    <xmx:lmRzaQckY-XiwGUwo4TRAopHVSj1aDco_KO8QhuvpkyYhVRHDk1NNQ>
    <xmx:lmRzaUlrKs7VAJegHzk_vokV1GqFTBj-5ntvyvrg6ot7coW1kldZ7w>
    <xmx:lmRzacGeI-3sB01QJFXGdogSAWv1rweKyFwg4C2SvUHqOTWX_NsaZzx5>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 23 Jan 2026 07:07:49 -0500 (EST)
Date: Fri, 23 Jan 2026 12:07:47 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 07/14] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
Message-ID: <aXNkSpO0WsvPz6h4@thinkstation>
References: <aXIaHZ5kNFelmuJi@thinkstation>
 <554FD2AA-16B5-498B-9F79-296798194DF7@linux.dev>
 <aXJHI8El7QHXQuwT@thinkstation>
 <BFECEA67-90EC-444A-87A3-A220168B1B67@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BFECEA67-90EC-444A-87A3-A220168B1B67@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 36A5D10000B
X-Stat-Signature: sd5mp7bn1e7635sc58zpyq9heb1phgmk
X-Rspam-User: 
X-HE-Tag: 1769170073-793172
X-HE-Meta: U2FsdGVkX18yY1bE2ky+qjp35CdEpz/AA+eydSiXG7vUiIA75ig/9rYM6u3H3ETSMdNemDxcv5ZcofFLdpDnUmeG76AnUlGcXSS8H9FBCKSyIvDppEzwln1ygr06Cu+Q9IyJ8xsgSqPqj9A/amzYgbc7dROjiyfJUiAAn93FXj1stTVbvRhDhZrzQAuO9R8HOoC/xvuBhj1bi3FIN45+PvDGl0FyfTGczkh9BRlro3uFBA11rfO2yuk+m4Q25Gu7QaXMPYd8AgOPY6n++lrcF97z+bHOdsJi/+PSjH2rjlXx1mEC4+yd0ZiSnY+cHdVFPHNEILM8bYIr7JT7wZ+W2qEYcfrmdQvxD0ttal9MKFwCN0iBxNx80m9tmXQPm4AlM6a+i9QbPNQ9rvzEvKC4XzZxRJ8/DqmSuSSKH3pg+G2uMM20aPVgF6bEu+WbFSsuGsOOAT3j9u2vXdiP3tuESxlG1PY9YZhqjda5yPbjUt9InOTg+q12WJltSi8K5SNc03TYqf9nNOadIrjW85WlXj4r1YkFeVxsYXWPuM/uQv8e2uWqnpmzODdySCoYl5i6geqrppOFJgsU+b4eKM/Eqthf59dGeNuzzGpBHVfqfN9yVQXsvPuCCqnMYFDPNu/DojUGo97FSZFhHmctIFH9+UDxWoSlC6KVublsjQt+iDIJb37mblGxTxT/QU/EP8p8zfkoHJLqcoOHPiQtjk3jsuJazplsr9TILJAKMqHQ36l0Gj1LczZ1WIQOjHompQj+hotJu2PjoeJ5LbnSvpIvwkFgdY0W2sqnetpU+YnnLB5GPwRTnNg4+rRE49e3K1JKs3rLsj4mWt+T6ugm+RIc4+UPvBJjdF1gME85IbP8R9/qsSoNNf9ZfHB1GYehxkndS930Y7DIHLzW6HMFaKpSw8pIdjtBD3XmIDeSxFE4o0yE23ssFgy2oP7mFi/qvjx/AMpswobcwIXBdJhFDOA
 NNYSrodl
 0kc2Sk7+H9TN684vB4W7MEpLVOhS97ZKmyAXZaNrZYBsmyU2dg3xQA+SIAX96EaHTloXvginLchKgYztRCa3M6p3kJu4n5WWrD+YuA/Oayq/BKwHMK8GI1gwsfHZswEfI3o8/+htCN796dx0YSBVbs7W4NBVdiS4tMcjyh5TSLp+VcyrJQDS0G+wTPtjUyBLVNsNSJ8cLnicZdCqDva7lQjtQVQipC6cdfgoKDIppi4Bne9voNNAqwI8uRURQCDd9MQQjf+WdVfxVpLWgg0mFk4luPGJBck3H8u1AQrGbHpB0DAfLNWiWRkC8WF3GUuRvTd1OufKz7EQ5IE42Dvh6F1ZKoGVGWKz6L4bkw9oeuyltSBxXD1AtMtWs2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 10:32:28AM +0800, Muchun Song wrote:
> 
> 
> > On Jan 23, 2026, at 01:59, Kiryl Shutsemau <kas@kernel.org> wrote:
> > 
> > On Thu, Jan 22, 2026 at 10:02:24PM +0800, Muchun Song wrote:
> >> 
> >> 
> >>> On Jan 22, 2026, at 20:43, Kiryl Shutsemau <kas@kernel.org> wrote:
> >>> 
> >>> ﻿On Thu, Jan 22, 2026 at 07:42:47PM +0800, Muchun Song wrote:
> >>>> 
> >>>> 
> >>>>>> On Jan 22, 2026, at 19:33, Muchun Song <muchun.song@linux.dev> wrote:
> >>>>> 
> >>>>> 
> >>>>> 
> >>>>>> On Jan 22, 2026, at 19:28, Kiryl Shutsemau <kas@kernel.org> wrote:
> >>>>>> 
> >>>>>> On Thu, Jan 22, 2026 at 11:10:26AM +0800, Muchun Song wrote:
> >>>>>>> 
> >>>>>>> 
> >>>>>>>> On Jan 22, 2026, at 00:22, Kiryl Shutsemau <kas@kernel.org> wrote:
> >>>>>>>> 
> >>>>>>>> If page->compound_info encodes a mask, it is expected that memmap to be
> >>>>>>>> naturally aligned to the maximum folio size.
> >>>>>>>> 
> >>>>>>>> Add a warning if it is not.
> >>>>>>>> 
> >>>>>>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
> >>>>>>>> kernel is still likely to be functional if this strict check fails.
> >>>>>>>> 
> >>>>>>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> >>>>>>>> ---
> >>>>>>>> include/linux/mmzone.h | 1 +
> >>>>>>>> mm/sparse.c            | 5 +++++
> >>>>>>>> 2 files changed, 6 insertions(+)
> >>>>>>>> 
> >>>>>>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> >>>>>>>> index 390ce11b3765..7e4f69b9d760 100644
> >>>>>>>> --- a/include/linux/mmzone.h
> >>>>>>>> +++ b/include/linux/mmzone.h
> >>>>>>>> @@ -91,6 +91,7 @@
> >>>>>>>> #endif
> >>>>>>>> 
> >>>>>>>> #define MAX_FOLIO_NR_PAGES (1UL << MAX_FOLIO_ORDER)
> >>>>>>>> +#define MAX_FOLIO_SIZE (PAGE_SIZE << MAX_FOLIO_ORDER)
> >>>>>>>> 
> >>>>>>>> enum migratetype {
> >>>>>>>> MIGRATE_UNMOVABLE,
> >>>>>>>> diff --git a/mm/sparse.c b/mm/sparse.c
> >>>>>>>> index 17c50a6415c2..5f41a3edcc24 100644
> >>>>>>>> --- a/mm/sparse.c
> >>>>>>>> +++ b/mm/sparse.c
> >>>>>>>> @@ -600,6 +600,11 @@ void __init sparse_init(void)
> >>>>>>>> BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
> >>>>>>>> memblocks_present();
> >>>>>>>> 
> >>>>>>>> +  if (compound_info_has_mask()) {
> >>>>>>>> +  WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
> >>>>>>>> +     MAX_FOLIO_SIZE / sizeof(struct page)));
> >>>>>>> 
> >>>>>>> I still have concerns about this. If certain architectures or configurations,
> >>>>>>> especially when KASLR is enabled, do not meet the requirements during the
> >>>>>>> boot stage, only specific folios larger than a certain size might end up with
> >>>>>>> incorrect struct page entries as the system runs. How can we detect issues
> >>>>>>> arising from either updating the struct page or making incorrect logical
> >>>>>>> judgments based on information retrieved from the struct page?
> >>>>>>> 
> >>>>>>> After all, when we see this warning, we don't know when or if a problem will
> >>>>>>> occur in the future. It's like a time bomb in the system, isn't it? Therefore,
> >>>>>>> I would like to add a warning check to the memory allocation place, for
> >>>>>>> example:
> >>>>>>> 
> >>>>>>> WARN_ON(!IS_ALIGNED((unsigned long)&folio->page, folio_size / sizeof(struct page)));
> >>>>>> 
> >>>>>> I don't think it is needed. Any compound page usage would trigger the
> >>>>>> problem. It should happen pretty early.
> >>>>> 
> >>>>> Why would you think it would be discovered early? If the alignment of struct page
> >>>>> can only meet the needs of 4M pages (i.e., the largest pages that buddy can
> >>>>> allocate), how can you be sure that there will be a similar path using CMA
> >>>>> early on if the system allocates through CMA in the future (after all, CMA
> >>>>> is used much less than buddy)?
> >>> 
> >>> True.
> >>> 
> >>>> Suppose we are more aggressive. If the alignment requirement of struct page
> >>>> cannot meet the needs of 2GB pages (which is an uncommon memory allocation
> >>>> requirement), then users might not care about such a warning message after
> >>>> the system boots. And if there is no allocation of pages greater than or
> >>>> equal to 2GB for a period of time in the future, the system will have no
> >>>> problems. But once some path allocates pages greater than or equal to 2GB,
> >>>> the system will go into chaos. And by that time, the system log may no
> >>>> longer have this warning message. Is that not the case?
> >>> 
> >>> It is.
> >>> 
> >>> I expect the warning to be reported early if we have configurations that
> >>> do not satisfy the alignment requirement even in absence of the crash.
> >> 
> >> If you’re saying the issue was only caught during
> >> testing, keep in mind that with KASLR enabled the
> >> warning is triggered at run-time; you can’t assume it
> >> will never appear in production.
> > 
> > Let's look at what architectures actually do with vmemmap.
> > 
> > On 64-bit machines, we want vmemmap to be naturally aligned to
> > accommodate 16GiB pages.
> > 
> > Assuming 64 byte struct page, it requires 256 MiB alignment for 4K
> > PAGE_SIZE, 64MiB for 16K PAGE_SIZE and 16MiB for 64K PAGE_SIZE.
> > 
> > Only 3 architectures support HVO (select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP):
> > loongarch, riscv and x86. We should make the feature conditional to HVO
> > to limit exposure.
> > 
> > I am not sure why arm64 is not in the club.
> > 
> > x86 aligns vmemmap to 1G - OK.
> > 
> > loongarch aligns vmemmap to PMD_SIZE does not fit us with 4K and 16K
> > PAGE_SIZE. It should be easily fixable. No KALSR.
> > 
> > riscv aligns vmemmap to section size (128MiB) which is not enough.
> > Again, easily fixable.
> > 
> 
> OK. After we fix all problems, I think changing WARN_ON to BUG_ON is fine.

David was explicitly against the BUG_ON() in the patch.

David, is it still the case?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

