Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 055C8C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 13:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CECC6B008C; Thu,  9 Jul 2026 09:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F646B0092; Thu,  9 Jul 2026 09:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BC196B0093; Thu,  9 Jul 2026 09:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64F496B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:06:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DEB3E40175
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:06:07 +0000 (UTC)
X-FDA: 84969261174.17.FC61996
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 399BEA0003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:06:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AfhJDsXr;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783602366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHoAaqin36BM7n0JyPwQOiJA2k5bERfSNEoUEt4tWaA=;
	b=Lr5Iy6cOl3K6/uv2G06s4kEEutNnC3Irv5kaKvGvQLbuYlkMPk7Z3KBLvDC9Vliat0XVPX
	zBj0mi16YOrVL7oACo3RBvGL6AYi+U7Vo4CdDgsr9rro7m3WKa5upARXiusZvTu4YUZ7gv
	VXyCSMSAuu4QXwtugr/sC3NHrzZryv4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AfhJDsXr;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783602366;
	b=iJz2M+AWmrWyNHRJ8WUxGoVCanKESo8fN4FTorXYOFPy0BVrAPO9NKgtC18/R7nivCvcdO
	PMaU0PKiCDxkQDAaD+f6r8pHlwWaYnWgl6nsisZcwnf9TN9cEfYaBfmph1B5SowoZcaFXR
	Q88DehZJnCTP9vQ/pKQJatSCmhuSCR4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FBC440498;
	Thu,  9 Jul 2026 13:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373911F000E9;
	Thu,  9 Jul 2026 13:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783602365;
	bh=gHoAaqin36BM7n0JyPwQOiJA2k5bERfSNEoUEt4tWaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AfhJDsXr9Jlh7JbWr6kTwPdZ2rinAltVe3gCbsphpBZwQhIWOHoS/OJLKDv0SaM92
	 usoZnqAhNKrNYTsB8hSLGLOr0ZTAR2D6pN8PAXIR72BWQlLNUWYfaaITPLUozVolb5
	 y6Xn4VjC6+jdUuFQQCYvpkGitYNqGB15TRPQ5Z8IjzLHy7dIVyMB6+mxf+yIe0pQIV
	 6w+7TzuKTqWytZekZ4phDVnKW1R9cNpAkyC84VmdpX36o975jUoHhuRahpVHMOaNfa
	 I9I2KXf4OA6tci8sf8im68/NTyxsxsypyy0uGqO8rRbPzxv3RTWsjeBQdr7tD5JITe
	 TCOQkjDEreubA==
Date: Thu, 9 Jul 2026 16:05:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/17] mm/mm_init: skip initializing shared vmemmap tail
 pages
Message-ID: <ak-ctr06UDUlNCJZ@kernel.org>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-5-songmuchun@bytedance.com>
 <ak97z4tryYAGJgb_@kernel.org>
 <2306829C-A66D-41F2-B5F7-1C164A7FF757@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2306829C-A66D-41F2-B5F7-1C164A7FF757@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 399BEA0003
X-Stat-Signature: cau1ikm7xac5cwrb4rti7tre79wjjkwj
X-HE-Tag: 1783602366-501283
X-HE-Meta: U2FsdGVkX1/F950EZXDSCt0gRY1aJFPkH8sDTHlOFYy66gfka9ktfe/2sg2vf+RPqbTqRcLDlhL2lMqxpOdGu+BW1Qo3z4Pswqc7IKQcX2cazdDvazjVWLQ5xKC91RhXVQwzjGSuwYvxqDI7m6RDX31wfbaNviGOgWB8ZeiyKY+UAhwWaasoqkSCb/7d7tnkxDgFnDz2NfYa1w4vKP1SaKZUn5icazXVXAzfwHHEWkNVx2vY8CuK7ydHGJbomhUt5bNvI4uj8kOiKDtgX2u3rM+Wwyid0jSMxT0IUZ1WyacXjOpP9IY2bOjQoa0wuHD+dOslJ9XxAsGmiQGZHC5CkYlEAX09iuYq7HQcDeD6nWnoGXAjNY5iabKHYroPeXFV2UTwtH57jdCWiVXm3Bk7i1P0Eg+cPZyad7qEF2h9Gk9kEezdLv059nWUt12aR+ambo/HxdYRi4nzzqjttrGbzOnGAKin4zssdQEaQvqXBC7d7gSIsttmQDAumKCKbv8yjdfYk8M+FuzdERIp38yph0k+JCIYhWG/h7iGfldsHnB2Dsza3FrD81WR2auOU389kfQdjLthibwOBw7yLJhmeKVfRRsL1N7j+AuULZjsEVrwnePZbJmCmP+J8qmJYwF83fTSjTgRupFy1RFPRACvdq92an9kY5x37okUFDoMDNmX8F2S779TcsBO8MnfVhHHoIaoqte6XTHOC1qHR7DLRBW8wyqcXXcCJGkI/JUvBKf/uArHyIvFULdLdJ9psc9bFhzpciolU4M7+7GjFi15lOhycGbq3YVz02L03YrHKPk6kog6OAR/KN9ErUNbRWuaqOb3uiVdGIh3FnArURuya1z9tZxRJGCmEb84tKHplZ2QFBo85gckwvk9GOcvs+CLdncbfQU7F1pIeS6FtM/0uX95so5KkQwpKIKptiE4U8UdQIL9wyumpQTOjtekjOE5bUC95gQebF0ZjI7NrOu
 F1rhcBY9
 Ox2qsNVNfWV/W2t6e/5lueC6j8G+JuDAPpuKdmkUMvtgdKzjlcua9pHK7Pt4ipQzELitETA2r2QxMVPfkKLmD2xqzuDUW7+FVM+7B/AV9Co/Dh3/A42E2HXZgTR9+rXsmLtbC+YGEv2c3+AxjwA+4M/tBZy7CLDTkI7kGo/t2ziR0W0h8LzlLecSNTCwf9EPQkYBZITa1vo7HlklA83Bgg3UKXgXy0usJ4vyaXp3IsZDpozWj21kPibmLQGFqS989eMIc7z3JCmyi+8EmU2wNx21B6S3hM1bidTWXrsn0TRaDtpx+fIAZatradRfXfLUmHYOdr4IgYuDq8sx3yoeA88DuMzT9uXOi3IR0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 08:31:31PM +0800, Muchun Song wrote:
> > On Jul 9, 2026, at 18:45, Mike Rapoport <rppt@kernel.org> wrote:
> > On Thu, Jul 02, 2026 at 05:38:08PM +0800, Muchun Song wrote:
> >> memmap_init_range() initializes every struct page in the target range.
> >> For compound pages with vmemmap optimization, the tail struct pages are
> >> backed by a shared vmemmap page.
> >> 
> >> Initializing those tail struct pages would overwrite the shared
> >> vmemmap page contents, so users such as HugeTLB have to open-code
> >> follow-up handling to restore the metadata afterwards.
> >> 
> >> Use the section's compound page order to detect struct pages that fall
> >> into the shared tail vmemmap range and skip their initialization in
> >> memmap_init_range().  Still initialize the pageblock migratetypes for
> >> the skipped range so the surrounding setup remains intact.
> >> 
> >> This is a preparatory change for consolidating handling across users of
> >> vmemmap optimization, and it also avoids redundant initialization of
> >> shared tail vmemmap pages during early boot.
> >> 
> >> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >> ---
> >> include/linux/mmzone.h |  4 ++++
> >> mm/internal.h          | 16 ++++++++++++++++
> >> mm/mm_init.c           | 25 +++++++++++++++++++------
> >> 3 files changed, 39 insertions(+), 6 deletions(-)
> >> 
> >> @@ -673,19 +673,21 @@ static inline void fixup_hashdist(void)
> >> static inline void fixup_hashdist(void) {}
> >> #endif /* CONFIG_NUMA */
> >> 
> >> -#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
> >> static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
> >> - unsigned long nr_pages, int migratetype, bool atomic)
> >> + unsigned long nr_pages, int migratetype, bool isolate, bool atomic)
> > 
> > What is isolate parameter for?
> 
> I've re-examined the code, and you're right that the isolate parameter is technically
> redundant for our current use case, as memmap_init_zone_range() passes false.
> 
> The rationale behind keeping it is future-proofing. The ultimate goal of a generic
> HVO is to support arbitrary huge pages, not just HugeTLB. I decoupled this as a
> parameter to prevent potential regressions down the road; if a developer leverages
> this for other huge page types in the future, they won't inadvertently break
> things by forgetting to update a hardcoded false in init_pageblock_migratetype(),
> especially since memmap_init_range() natively accepts an isolate parameter.
> 
> Of course, we could also just delete this parameter for now and add it back later if
> needed. I think both approaches work.
> 
> Which way are you leaning?

I'd drop it for now and would revisit when there would be a new HVO user. 
Even one boolean means it's hard to tell from a call site what is the
intention of the flag, two make it completely confusing :)
 
> >> {
> >> 	const unsigned long end = pfn + nr_pages;
> >> 
> >> 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
> >> - 		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
> >> + 		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, isolate);
> >> +#ifdef CONFIG_SPARSEMEM
> >> 		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
> >> +#else
> >> + 		if (!atomic && IS_ALIGNED(pfn, MAX_FOLIO_NR_PAGES))
> >> +#endif
> > 
> > Let's trigger cond_resched() on some defined number of iterations or some
> > memory size chunk, e.g PAGES_PER_128M or even PAGES_PER_1G.
> 
> Yes, that's for the best. I was really struggling to choose a suitable macro
> for this earlier, but I realized it's a difficult thing to get right. I'm leaning
> toward selecting PAGES_PER_1G instead.

Yeah, PAGES_PER_1G makes sense to me too.
 
> Muchun,
> Thanks.
> 
> > 
> >> 			cond_resched();

-- 
Sincerely yours,
Mike.

