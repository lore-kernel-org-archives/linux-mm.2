Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1608CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942A86B00BA; Tue, 19 Aug 2025 06:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3EF6B00BB; Tue, 19 Aug 2025 06:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830866B00BC; Tue, 19 Aug 2025 06:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EC3D6B00BA
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:54:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 212D0595B1
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:54:58 +0000 (UTC)
X-FDA: 83793199476.11.A97CAC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8A357140004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:54:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zta/O5+p";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755600896; a=rsa-sha256;
	cv=none;
	b=0anEr1PSEB5SJbka9OZxKqDvu/yOx9kmzcAFYNETNXv8IRVja1G7qAgdlWig0AWAimHyBR
	WgXGOTLsRZIhIg5zoNUyCaU44MZM/kWWu7ZKxxNxCruxxejileXO9xd4kKf8azpqSDWex7
	xVSQAJ3Dqc3QtQkbmTHz2fXoO3N/51w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zta/O5+p";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755600896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XEqdAgutMOQHU3FAwbFBoOu1vQh5zdxWl/7RXUPvb8I=;
	b=RrhHNQGaNJHlLRfYWS02qO/GyvmkTvl3CamHyMSOXilGxyqPcd8nEec9TnS2r3oVfN9ueP
	SLstdMwM4mbVTIHCT2Wx3EXECcJCKEnkmjXl23mavqbSrMlxrZHy2EGsq4olDC/T8noczS
	Hp5xLe9sq1LCzflsQ1C0mo+hYQC/zWk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CB8F45B3F;
	Tue, 19 Aug 2025 10:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F22C113D0;
	Tue, 19 Aug 2025 10:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755600894;
	bh=ObmAp/lIF5T9u/FjKqRF/LtJfWE6tMEI8MTlJt/e9nk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zta/O5+p9ya6IXOH6Q7+cZxn7RNLi4adAXeXJsIjFJrS4XDeTkRVROzGnykGbj9J2
	 NawVnEa149OU4BcSauE9RmG3C+CsjjIGw1oweDUqwiB2dxsmRyIgiehjb3nfRXZ1Ah
	 VM3Uy4z5JQpl3nONPeMkKwaXkiitTtOTyXHhhGV8TBYtuTatsLx2rO+/S8DI4mwUsU
	 cG2J1m3fnnh8yfygqKj6NZ3KZNe4kBJiQv/d1flLffralOMTvlvoy+fc9T46+MmrsV
	 WkHwsu1lFOfifsozGXTMdonZzMmF52USglfRh7fun0atw7wsUgzQ+/wZctq18qXR3H
	 KS5CRwxz0/85w==
Date: Tue, 19 Aug 2025 13:54:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 1/4] mm/mm_init: use deferred_init_memmap_chunk() in
 deferred_grow_zone()
Message-ID: <aKRX9iIe8h9fFi9v@kernel.org>
References: <20250818064615.505641-1-rppt@kernel.org>
 <20250818064615.505641-2-rppt@kernel.org>
 <20250819095223.ckjdsii4gc6u4nec@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819095223.ckjdsii4gc6u4nec@master>
X-Rspamd-Queue-Id: 8A357140004
X-Stat-Signature: smtzyyiy74y9j565qr39skix3dz6e7mz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755600896-988269
X-HE-Meta: U2FsdGVkX1+Z5HPMBz2wsFQJCGH7ZcoRMuhgLGAvK9LoAanGxp3/u47/4ERNd6yeiaaZ95wQs4zlk0aMma+NPpkQHm2Z9fsNdueEtX49r0G9qxEjkob3UBNFU2A3tSZZGxRb0QLITrzR18H+2sCBKqX0myumJupNz06wXnxTwc7fnzyjqvqUqqTX4MT+IFWishFJ+McUHiID7SoAgeC9dSFabWGPnoZBKjrzcWcY4SFK1CnJwdqc0cFEOuAiO25XqhBksRsOjQK1auTo7gooRr8i+OaRQLTfLLNobJXZknAlEiZUPwwE/sSjBiH532fowNsuTZdZQRj1FdwprIfZmPFxsrL6P8Zf8u9Fvhr/cRkMNUTCFDTUc+uIW4oRghpivA4K8MXZ77Jox2wAiMoTaWFwMyePssPaGTxRHamX6799k4x/AVSX/nq042C4k8YPsOKLMgOfH02oQxv3TiW9UHN0NzJsLUOY6owr3TC4GJGp6Hg5f65WkBqkF3gwwqj58hcWG73AbHnc8bOKhms6U1WZ3k4yh1dlJTWNmcA4Ol7s0v+b0WXecItnBfUHKKurEqPbiqzf1m32jNoOvTPXE/AdcOHMGg0p5QJJF6voOhTvrwI8KhOLJRBey1tvXMILE8x7GMe7/NCMtkLutgXxcxeQBRyafx9gxwNm4RSJdA0B7lGS1ZDgk+M8EuyFT2nH1rpXYTK8CrN4lYcoEY8lhOaKlZRaxX+uFRCXGftTBccKbbOhZni7K+R4IF+PJPQjRPdGbjfUw5oLOpt5Nk9vJyHVMd2a70l82hsYvJJORbBZx6hS28LT5k9qt2z1+I7iY0wycCrYRxctdu78bodqHdTihAFY62TqFz6hA9wMscRA5Le4tBTDu9jx8JOOQW5PhSGBNE6L/RA3keIKxKyu6VKATzM4xQdcZekEdG+NQxOnaJp9oUkDWAfZx2lqku8fDNxD5k6drMlkDoxvUs9
 AR3kH9n/
 V+nI6mhmpZqT/dwSCMp35CZ2SUP2LcbwAP28T8RZbTppbl/YrWxVAPsV0EgTxxqxxbRyRwKuRdeTtCijKQCNOPOD88A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 09:52:23AM +0000, Wei Yang wrote:
> Hi, Mike
> 
> After going through the code again, I have some trivial thoughts to discuss
> with you. If not right, please let me know.
> 
> On Mon, Aug 18, 2025 at 09:46:12AM +0300, Mike Rapoport wrote:
> [...]
> > bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
> > {
> >-	unsigned long nr_pages_needed = ALIGN(1 << order, PAGES_PER_SECTION);
> >+	unsigned long nr_pages_needed = SECTION_ALIGN_UP(1 << order);
> > 	pg_data_t *pgdat = zone->zone_pgdat;
> > 	unsigned long first_deferred_pfn = pgdat->first_deferred_pfn;
> > 	unsigned long spfn, epfn, flags;
> > 	unsigned long nr_pages = 0;
> >-	u64 i = 0;
> > 
> > 	/* Only the last zone may have deferred pages */
> > 	if (zone_end_pfn(zone) != pgdat_end_pfn(pgdat))
> >@@ -2262,37 +2272,26 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
> > 		return true;
> > 	}
> 
> In the file above this line, there is a compare between first_deferred_pfn and
> its original value after grab pgdat_resize_lock.

Do you mean this one:

	if (first_deferred_pfn != pgdat->first_deferred_pfn) {
		pgdat_resize_unlock(pgdat, &flags);
		return true;
	}
 
> I am thinking to compare first_deferred_pfn with ULONG_MAX, as it compared in
> deferred_init_memmap(). This indicate this zone has already been initialized
> totally.

It may be another CPU ran deferred_grow_zone() and won the race for resize
lock. Then pgdat->first_deferred_pfn will be larger than
first_deferred_pfn, but still not entire zone would be initialized.
 
> Current code guard this by spfn < zone_end_pfn(zone). Maybe a check ahead
> would be more clear?

Not sure I follow you here. The check that we don't pass zone_end_pfn is
inside the loop for every section we initialize.
 
> > 
> >-	/* If the zone is empty somebody else may have cleared out the zone */
> >-	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
> >-						 first_deferred_pfn)) {
> >-		pgdat->first_deferred_pfn = ULONG_MAX;
> >-		pgdat_resize_unlock(pgdat, &flags);
> >-		/* Retry only once. */
> >-		return first_deferred_pfn != ULONG_MAX;
> >+	/*
> >+	 * Initialize at least nr_pages_needed in section chunks.
> >+	 * If a section has less free memory than nr_pages_needed, the next
> >+	 * section will be also initalized.
> >+	 * Note, that it still does not guarantee that allocation of order can
> >+	 * be satisfied if the sections are fragmented because of memblock
> >+	 * allocations.
> >+	 */
> >+	for (spfn = first_deferred_pfn, epfn = SECTION_ALIGN_UP(spfn + 1);
> 
> I am expecting first_deferred_pfn is section aligned. So epfn += PAGES_PER_SECTION
> is fine?

It should be, but I'd prefer to be on the safe side and keep it this way.
 
> Maybe I missed something.
> 
> >+	     nr_pages < nr_pages_needed && spfn < zone_end_pfn(zone);
> >+	     spfn = epfn, epfn += PAGES_PER_SECTION) {
> >+		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone);
> > 	}
> > 
> > 	/*
> >-	 * Initialize and free pages in MAX_PAGE_ORDER sized increments so
> >-	 * that we can avoid introducing any issues with the buddy
> >-	 * allocator.
> >+	 * There were no pages to initialize and free which means the zone's
> >+	 * memory map is completely initialized.
> > 	 */
> >-	while (spfn < epfn) {
> >-		/* update our first deferred PFN for this section */
> >-		first_deferred_pfn = spfn;
> >-
> >-		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
> >-		touch_nmi_watchdog();
> >-
> >-		/* We should only stop along section boundaries */
> >-		if ((first_deferred_pfn ^ spfn) < PAGES_PER_SECTION)
> >-			continue;
> >-
> >-		/* If our quota has been met we can stop here */
> >-		if (nr_pages >= nr_pages_needed)
> >-			break;
> >-	}
> >+	pgdat->first_deferred_pfn = nr_pages ? spfn : ULONG_MAX;
> 
> If we come here because spfn >= zone_end_pfn(zone), first_deferred_pfn is left
> a "valid" value and deferred_init_memmap() will try to do its job. But
> actually nothing left to initialize.

We anyway run a thread for each node with memory. In the very unlikely case
we've completely initialized a deferred zone that thread will finish much
faster :)
 
> For this case, I suggest to set it ULONG_MAX too. But this is really corner
> case.

-- 
Sincerely yours,
Mike.

