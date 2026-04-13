Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E75FF34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83A216B0099; Mon, 13 Apr 2026 09:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811E66B009B; Mon, 13 Apr 2026 09:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700906B009D; Mon, 13 Apr 2026 09:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0776B0099
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:28:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27D571A0198
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:28:33 +0000 (UTC)
X-FDA: 84653612106.25.2719750
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F00780008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:28:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mQZFa8uj;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776086911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCOqS5Qt7DUErLD1sGM2NitPZa1Tc1bVbjZ/Obd/mdo=;
	b=I6BWV2bdeoZlklkmn1L9BWRacBKjy/psVM0tQCANj7jDqHtjDVCSkqZhc33nWJNBb4d0Mk
	GweOCIKKlL8jCyRymqmALckwo9C6AF7oOq5W0o5/BakGMhOUDrngjo+ecZI4+RZdV4eqOY
	OxzLzmv/MBvfSVSoBHFQYZM9gELdaUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776086911; a=rsa-sha256;
	cv=none;
	b=Moeq6OFoxPhM49ZUX9dunjUFEP9IYqHtyy5j7/wq9G1KKp8yBJnFgW9W3wYE/TRufGQMUe
	AXb4RVjubx5npBSyynsiq+m5onUHgpgojw20WrN4y/1QofHdYO5h+xzhXczKMInCKJqdwS
	L6zY/QfGV7jflb5SWgheqbI8Tm8+35o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mQZFa8uj;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 24FA5435E2;
	Mon, 13 Apr 2026 13:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF49C2BCAF;
	Mon, 13 Apr 2026 13:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776086910;
	bh=7VByJTwrbtmSQuR7FvCes1Iak+N/IKd4uFjkgcO39ug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mQZFa8ujuVe81yE8vcLgLxhVVWJzt+swKGWZ2ofKQXeOaAczk3K7ksXwrVlaJ+hYw
	 yVXg5XiKV2rDDSHGmZ1cHQ+6AGEE+yBrBY8Yi+AJDfc5p1i4llszFa2XXvV01sTTec
	 G5SA0gcFv2AQ1usMg1UopmrqtMVJnc6aLQ9KCriHB4Wjq3rdjlaeimKxzpGP4Tcub0
	 Hpe1GUFInfON7xos/qUF6Ek0JOQtQ+M2Mm8BtjbuE4GPPPko8pTQjSqAPoaHfBPtIj
	 Zk8VEGEOVMkuyQZ4NDKGfZm/7c5eMmPrWTp1byTgwQsPAwlXcKcEJE+KRr1I5UgG+L
	 OZ747izg6AIcw==
Date: Mon, 13 Apr 2026 16:28:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/49] mm/mm_init: fix uninitialized pageblock
 migratetype for ZONE_DEVICE compound pages
Message-ID: <adzvdRPrK55TutT6@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-7-songmuchun@bytedance.com>
 <ady4LBppz-na5lM5@kernel.org>
 <5910791C-9893-4710-9002-76534DBFBFBD@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5910791C-9893-4710-9002-76534DBFBFBD@linux.dev>
X-Rspamd-Server: rspam12
X-Stat-Signature: 8xdopu3aomi938ea68ritb9341gjy1ar
X-Rspamd-Queue-Id: 4F00780008
X-Rspam-User: 
X-HE-Tag: 1776086911-196790
X-HE-Meta: U2FsdGVkX1+mn79YzqdZdmwKK8/6XrMwBZqy6ACU0uj4/4WDT4CDgthj82LDbNPgdISO7Wfrpew8yB9j2hu8iN1na6TGIcdWfxWCQns3J2ufgyv9iw2UvogKgjh9A9+hDKyc+xc4VEau1Dx8Qemja6bYpZ4KxTTxHFiv5K0aD3wU892AhhK/IHPx0HegXJjEHZnOr1AuktrhuzPYpRcoXu5D6ZcgXAoOmX80gSgamwzC1Lle37A37BgdUYt+ONf2jM+Gaky691ipFySTgxzT9YPb0y/s9ezeb/1cTJmkZbNbdw0uRPkoLhZ7NoKyQOw1BGV+nX9MTnXzpghQ3XiSKm9614rmmDkkbD7feEq9UhWTtUUGZOxkW9swA/8Kw0uNEaNtk88IoJesxO23SiQkYOPbhQp/d8PKcf/3BkFaOmiY80f8Lxs4h8pNuJficXQ0ug3lESzB93DqzsGWD0lYSExQXWqcUtimfyVCMOsl0mpaHh9iku6QNIp+s6AHWgPAmtAx+MY6nZW1HRHPlZWLo2y99MQuNm/HuWqESkiQe1niZbzn4TRZU3axN4sOxNaxo4nwTidV9gzttodDz5roa0yqM7jakqcT1eVmDa7PJAp6cImLUZTDDFQszOacjzWBgSufcqsv5PGb8A6FekJOqSf1joJPFFYqg3RTxVQwVlgBl3VdwRVEveDPlShEraHFm5/GoRrdPJHQ5twmVKf/ubSdje1adltqYhXCmtwPRtjZoW83zXUi4xu+ZT8DGJFaIX/rKWnfPghDDFlXMgCgYtjJbJGcEvTZXU8VSqL+/Au686ENvAdiDm8w/52XdXJIQoWX9p8FdcaMMZJwkCG8NtlERSS3wbOlCb5cOsOT2PJV7L0YIAULD9b6EF14hDcilBYuxsGi2z/+8h4ykHfaW24mW9aMplyNH6grJAJ0YMIt1zHv//5nXgtDYHeJTD7J6xMcwtTI+D4QQ0kOn/6
 +BUqc6hr
 9K8L6u4eyedihW83euJlnd5Nn3emKAzUKF0fLJiPsl+3piFYuuF9Y8X3udeMHwkOTe9JTIxA2P8zBXfrkIu8rW/bVU28B9obclhF7IV8tWD5en4dYGhYr32gcksTUEMPPrctlm8tOgKjN3guige+mpBI2xa/aLBG94ogbdqHz/EJgKaA6YLXqDaE+Docxgai1v6ia5IsW/znak7wPRllRsFd3UjSwqV4dN79/Cp9JM4aKR5SZmbWsWPgJnZKJlzVDmUUHQ0fonpdlObcLLdEJJ2Zz/oIFIZPcHHsJKffPQIAuGtEDYQIca9gXpWQuHMkUM86X6D/+NGYcwJk4xnZdnZIpjjaerzhkQIRbH90BhnRqc58Fcl2OXuX8+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:07:44PM +0800, Muchun Song wrote:
> 
> 
> > On Apr 13, 2026, at 17:32, Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > On Sun, Apr 05, 2026 at 08:51:57PM +0800, Muchun Song wrote:
> >> Previously, memmap_init_zone_device() only initialized the migratetype
> >> of the first pageblock of a compound page. If the compound page size
> >> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
> >> subsequent pageblocks in the compound page would remain uninitialized.
> >> 
> >> This patch moves the migratetype initialization out of
> >> __init_zone_device_page() and into a separate function
> >> pageblock_migratetype_init_range(). This function iterates over the
> >> entire PFN range of the memory, ensuring that all pageblocks are correctly
> >> initialized.
> >> 
> >> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
> >> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >> ---
> >> mm/mm_init.c | 41 ++++++++++++++++++++++++++---------------
> >> 1 file changed, 26 insertions(+), 15 deletions(-)
> >> 
> >> diff --git a/mm/mm_init.c b/mm/mm_init.c
> >> index 9a44e8458fed..4936ca78966c 100644
> >> --- a/mm/mm_init.c
> >> +++ b/mm/mm_init.c
> >> @@ -674,6 +674,18 @@ static inline void fixup_hashdist(void)
> >> static inline void fixup_hashdist(void) {}
> >> #endif /* CONFIG_NUMA */
> >> 
> >> +static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
> >> +        unsigned long nr_pages,
> >> +        int migratetype)
> >> +{
> >> + unsigned long end = pfn + nr_pages;
> >> +
> >> + for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
> >> + init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
> >> + cond_resched();
> > 
> > Do we need to call cond_resched() every iteration here?
> 
> Of course not.
> 
> > 
> >> + }
> >> +}
> >> +
> >> /*
> >>  * Initialize a reserved page unconditionally, finding its zone first.
> >>  */
> >> @@ -1011,21 +1023,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> >> page_folio(page)->pgmap = pgmap;
> >> page->zone_device_data = NULL;
> >> 
> >> - /*
> >> -  * Mark the block movable so that blocks are reserved for
> >> -  * movable at startup. This will force kernel allocations
> >> -  * to reserve their blocks rather than leaking throughout
> >> -  * the address space during boot when many long-lived
> >> -  * kernel allocations are made.
> >> -  *
> >> -  * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
> >> -  * because this is done early in section_activate()
> >> -  */
> >> - if (pageblock_aligned(pfn)) {
> >> - init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
> >> - cond_resched();
> >> - }
> >> -
> >> /*
> >>  * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
> >>  * directly to the driver page allocator which will set the page count
> >> @@ -1122,6 +1119,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
> >> 
> >> __init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> >> 
> >> + cond_resched();
> > 
> > Originally we called cond_resched() once per pageblock, now it's called
> > once per page plus for every pageblock in the tight loop that sets the
> > migrate type. Isn't it too much?
> 
> There are indeed many more cond_resched() than before, but I don’t have a
> concise way to write it, so I took the easy way out.
> 
> How about:
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 2d680636b67a..d13a2577c4c3 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -683,7 +683,8 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
> 
>         for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
>                 init_pageblock_migratetype(pfn_to_page(pfn), migratetype, isolate);
> -               cond_resched();
> +               if ((pfn & (pageblock_nr_pages * 512 - 1)) == 0)
> +                       cond_resched();

TBH, I don't know if 512 is the right number :)

pageblock boundary was a convenient point to have cond_resched() along with
setting the migrate type.

Here we might be able to squeeze more iterations between subsequent
cond_resched() calls.

-- 
Sincerely yours,
Mike.

