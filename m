Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98F0BC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7CE66B00AE; Mon, 17 Aug 2026 07:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E2A6B00B1; Mon, 17 Aug 2026 07:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91CE26B00B2; Mon, 17 Aug 2026 07:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3B46B00AE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:16:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7C3040746
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:16:09 +0000 (UTC)
X-FDA: 85110507258.30.6B39528
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 082B714000F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:16:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VUszP7iB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786965368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEiCzvWeUGYIvROwUcLdzkful8DGFhkVU5axYHnXzAU=;
	b=UJtEsw2yDOFnO4nnknI1w2q0hqsTmnZ/8LDGOT2nbwtAugJ6p1IJnPS5qch/uzUTcSjitm
	IHvWwShfVK8lOiFuaxiKyR5w2aH0z2rRR65rf7flYH4XtMVFnQYjr5UB62DCCffg7da7JX
	xbJINobQMGZ2uYzG32xH9/yfZveUtlY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VUszP7iB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786965368;
	b=55zIumGBUfzpCLkekZ5gKYO19n0Jnqbd6/lTHCtAmnnHsA+/lMx3zPwPJokTARFnxP/FDN
	pyMXRUONt8iSdf1+CJbVUOkdnbKAMZxLf9GuxgTR5fv/k1kjF35OIhbJFYNdK34bF4NnRm
	4aaA0BirBmj04Hq50hOrtFAR8qVzzjc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDB6F4005F;
	Mon, 17 Aug 2026 11:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274DB1F000E9;
	Mon, 17 Aug 2026 11:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786965366;
	bh=pEiCzvWeUGYIvROwUcLdzkful8DGFhkVU5axYHnXzAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VUszP7iBiEwWM7jmKtcc8MgMRH4a0eQSsEFEfoa70VpX1A6FvPSIknklIJi4I/AYh
	 yfLB6G7kLoMzpjN3A60NMZNKJe1M+VKut9hayU38wkxmjVO60UTjO/GtNBHjbVjMhE
	 b/MuzWASuTMIMAwN5TSoU3s0cu5U8paStGq5Q+ZtJSrsKAlhq6LWJZIgL/M7EzIgDy
	 +LV01x9H3stNdokj7k88f8IVWJbk9zOcPGBaMocn0QhNSUn74vRB+fzjZ+9WFugzp7
	 smSj05Avv6foZ3ei/8Za9Lld+hAfGQ6O5qvrU3/2FUP+AAr0D/+vtGRuHjNLDtZZsB
	 dfJxAe+dtzX5w==
Date: Mon, 17 Aug 2026 14:15:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
	balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com,
	david@kernel.org, kees@kernel.org, mingo@redhat.com,
	muchun.song@linux.dev, tglx@kernel.org, linux-arch@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v10 2/8] mm: factor zone-device page init helpers out of
 __init_zone_device_page
Message-ID: <aoLtbbv5euE4H1xO@kernel.org>
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
 <20260810122057.30447-3-lizhe.67@bytedance.com>
 <178688187038.2799959.7900723270155108493.b4-review@b4>
 <050c317f-111e-4293-aee5-ac8e154ebc7e@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <050c317f-111e-4293-aee5-ac8e154ebc7e@bytedance.com>
X-Rspam-User: 
X-Stat-Signature: it8s9j5adgp37rjeij73t4djb4ysheej
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 082B714000F
X-HE-Tag: 1786965367-149886
X-HE-Meta: U2FsdGVkX18UofZ00w7+ZUPWFU78SKsoLn+Lo4HZCyxf2vDpe4o9bZf2IFriGZ3ce+k/tRwBI994IYqiXQhpNHvWyqUwuO49JMJZgem7mrdGBYXGz53d/KeGiRLE/tnv35qlMakoyGMsizDX9+tgKwZ41ciRr31hvqu1D4fIVH5ybcfmiMAkeN9SPkf1ipZpkO+1d2fMdagHvOsQAqikUzmbUNa4EBCsfipcC3nNwkn4d/sT88AEoHlg5iDiHJ+56GaE67Apf4qC31nWCGXKErXJHhE+rPabS3/nKekaysk/GZzyQsvM2TE7A5nFQ8p4BWUhdOscDEZBTlTSrtB0ECAQOHSWlrqEflV1WgehXygVaAB1I+qUHdisANlad1623YfqIFW7/VZ8Vshqb/qAy0f2VchFRGWtgfYwOjBP0SQd3d4pHJZn0eLhKjChXLkaLCgtiBFv6QkZx4xwkMUGZ4kVvwYyS4XJQ88dUS83XGTpcgk+c/XXYtU8Ymu6Ac5FsKCp4CMn+CoZ8RgV+lE4V0ZMSjH2IBVFdy/VtzSzSqbVoN664t/Oyc4SN6+F81z7t9c7PUmsZ188PmUH6JhAk2lTCSgFWXwRwA1Iu/XT83rskeS5OxgKlwht5gYlfsb3O6r3pJfR2YXPS3sIikGzTRevaxfi2PSvQwR4UbE9PlAY4HGQzwMhM+z6ljPtIWAf42sVSJyRh69RhvaU/INGuOcOz/pXjYrfv3L/UhuWOGnnyA7Z3gCJuaNNgZ6OE0kycMdpWXleRDm5whVl/04lbni4TX22AGFNedVDL1AFCNgyr0Bl1Oukv6niO0FwPfi7om+nVZ4VHWRUH3/bL2zeGJeuTfchXdLETHfEVdmUWWqsjD438UrIDx8SpA7NcH/Apq7l4I2RlFxcmmV+r25C8F71ehUKeJth6k+14PjeQar3s6oU0mUDx70CAGOe/UVlje0ZQGG1FSe8cIdELrf
 5OE1j/H4
 VBcOOEy8TgTonuuByaawmQkcyz028cXy007w8f92heiQ+6DFKPdiFQRM0V0sTS2RcYFWqaxNGraSC3LG06E1cRWq1Tmd/JwDj9DaggsQni9n6049J723HlU+SJu9XXFUbl4QgXq0b/WcQ9SzK9/+7QZK3Tcgjq/dqa8F6D/7fPbg8+4GcP9fYB9ghuoNeKPXWsr+rXWPaE03b0de5UWv1THH9hHZTPY6MvODAc6sKzImwuvOvFNo790YBOaixxcOS+aiH6zmPivz8GHP6XHTg5fNUlxPtF6o9VPOJvDTbH6GXPCfNbg6/opdJvogHqsCnaH7cUOm08lQMcah3JLd5BDDOkIWfgth7bGQR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 03:11:56PM +0800, Li Zhe wrote:
> On 8/16/26 8:04 PM, Mike Rapoport wrote:
> > Hi,
> >
> >> memmap_init_zone_device() currently mixes refcount policy and core
> >> ZONE_DEVICE page setup in a single helper.
> >>
> >> Factor the refcount-reset predicate into pagemap_requires_refcount_reset(),
> >> move the common page initialization into __zone_device_page_init(), and
> >> wrap the existing slow path in zone_device_page_init_slow().
> >>
> >> This keeps the slow-path behaviour unchanged and gives later patches
> >> reusable helper boundaries.
> >>
> >> No functional change intended.
> >>
> >> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> >> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >>
> >> diff --git a/mm/mm_init.c b/mm/mm_init.c
> >> index 95808ab5cfdb..a70acb7431a6 100644
> >> --- a/mm/mm_init.c
> >> +++ b/mm/mm_init.c
> >> @@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
> >>   }
> >>   
> >>   #ifdef CONFIG_ZONE_DEVICE
> >> -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> >> +/*
> >> + * Return true when memmap_init_zone_device() must initialize the page
> >> + * refcount to 0. MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in
> >> + * the free path, while the remaining ZONE_DEVICE types start from 0 here
> >> + * and raise the count again when the allocator or driver hands the page
> >> + * out.
> >> + */
> >> +static inline bool pagemap_requires_refcount_reset(const struct dev_pagemap *pgmap)
> >> +{
> >> +	/*
> >> +	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
> >> +	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
> >> +	 * the count again when the allocator or driver hands the page out.
> >> +	 */
> >> +	switch (pgmap->type) {
> >> +	case MEMORY_DEVICE_FS_DAX:
> >> +	case MEMORY_DEVICE_PRIVATE:
> >> +	case MEMORY_DEVICE_COHERENT:
> >> +	case MEMORY_DEVICE_PCI_P2PDMA:
> >> +		return true;
> >> +	case MEMORY_DEVICE_GENERIC:
> >> +		return false;
> >> +	}
> >> +
> >> +	return false;
> >> +}
> >> +
> >> +static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
> >>   					  unsigned long zone_idx, int nid,
> >>   					  struct dev_pagemap *pgmap)
> >>   {
> >> -
> >>   	__init_single_page(page, pfn, zone_idx, nid);
> >>   
> >>   	/*
> >> @@ -1028,23 +1054,15 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> >>   	 */
> >>   	page_folio(page)->pgmap = pgmap;
> >>   	page->zone_device_data = NULL;
> >> +}
> >>   
> >> -	/*
> >> -	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
> >> -	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
> >> -	 * the count again when the allocator or driver hands the page out.
> >> -	 */
> >> -	switch (pgmap->type) {
> >> -	case MEMORY_DEVICE_FS_DAX:
> >> -	case MEMORY_DEVICE_PRIVATE:
> >> -	case MEMORY_DEVICE_COHERENT:
> >> -	case MEMORY_DEVICE_PCI_P2PDMA:
> >> +static void __ref zone_device_page_init_slow(struct page *page,
> >> +		unsigned long pfn, unsigned long zone_idx, int nid,
> >> +		struct dev_pagemap *pgmap)
> >> +{
> >> +	__zone_device_page_init(page, pfn, zone_idx, nid, pgmap);
> >> +	if (pagemap_requires_refcount_reset(pgmap))
> >>   		set_page_count(page, 0);
> >> -		break;
> >> -
> >> -	case MEMORY_DEVICE_GENERIC:
> >> -		break;
> >> -	}
> >>   }
> >>   
> >>   /*
> >> @@ -1090,7 +1108,7 @@ static void __ref memmap_init_compound(struct page *head,
> >>   	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
> >>   		struct page *page = pfn_to_page(pfn);
> >>   
> >> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> >> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
> >>   		prep_compound_tail(page, head, order);
> >>   		set_page_count(page, 0);
> >>   	}
> >> @@ -1126,7 +1144,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
> >>   	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
> >>   		struct page *page = pfn_to_page(pfn);
> >>   
> >> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> >> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
> > It looks like all callers of __init_zone_device_page() are now calling
> > zone_device_page_init_slow() that with series evolution became a thin
> > wrapper for __zone_device_page_init().
> >
> > Maybe we can just rename __init_zone_device_page() to
> > __zone_device_page_init() and replace the open coded setting of the page
> > count with the call to pagemap_requires_refcount_reset() an be done
> > here?
> 
> 
> Yes, that would make patch 2 simpler.
> 
> The reason I kept the refcount policy outside __zone_device_page_init()
> is the compound-tail initialization added later in patch 5. Tail pages
> still need the same basic ZONE_DEVICE struct page initialization as head
> pages, including __init_single_page(), PageReserved, pgmap and
> zone_device_data setup. After that, the tail-page path calls
> prep_compound_tail() and sets the tail refcount to 0 unconditionally.
> 
> Folding pagemap_requires_refcount_reset() into __zone_device_page_init()
> would make that helper include the head-page refcount policy even for
> callers that will immediately apply the tail-page refcount rule
> afterwards.

But you still call zone_device_page_init_slow() from
zone_device_tail_page_init() so it's anyway there.

I'd suggest combining this and the next patch into one, keeping
__init_zone_device_page() name without renaming it at all and open-coding
the initialization of the first head and the first tail page to properly
set refcount and call other prep methods.

I'd also pull the initialization of the first page in both cases out of the
loop and make the loop only use the _template version.
 
> That preserves the final state, but I was trying to keep the common
> ZONE_DEVICE page setup separate from the head-page refcount policy for
> this reason.
> 
> Would you still prefer the simpler renamed helper here, or should I keep
> the common ZONE_DEVICE page setup separate from the refcount policy and
> make the naming clearer in v11?
> 
> Thanks,
> Zhe
> 

-- 
Sincerely yours,
Mike.

