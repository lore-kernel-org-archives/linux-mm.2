Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37E9F364A6
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF74D6B0005; Thu,  9 Apr 2026 14:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA83B6B0089; Thu,  9 Apr 2026 14:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE986B008A; Thu,  9 Apr 2026 14:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC8A06B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:06:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56CB4139059
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:06:18 +0000 (UTC)
X-FDA: 84639796836.05.0468674
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 913494000A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:06:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PbKILrKU;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775757976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NfxUCt49N9N51sdtX7qGacaTiS5FvXvof6n28eKOkMY=;
	b=e/BKSOG8L20x+AbjgHm1G+5M/aU1jD89W824JOVOwdA61zL1KOWJ3buJiI1uwoQpSChb+g
	68kCVak/adJ0Syhp5myvfxP9zNWTcge8aeyBrE7n+375QBlNKCm15xvLfSZFDcG2SykEdW
	aIM+rsbOG4JvIxLQgGNjIzVT9oDScAQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PbKILrKU;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775757976; a=rsa-sha256;
	cv=none;
	b=bvewqOvwhffh3H2xUSFLAJjN5Qe5AOlBGF7lxSzVqVMx4oDSjwMPbS1Y2KScJgRbEoMhbn
	wo5ielm1WEEVSHWA9G9/qkznmz4n+mz4wMsGE42reFBB/OBOSW+LaFw0dk3Q75IaaOFk9X
	viMPJT6h8G8QObwglKe+f7aXb6hCkxg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E1E2A60103;
	Thu,  9 Apr 2026 18:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250F9C4CEF7;
	Thu,  9 Apr 2026 18:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775757975;
	bh=LRJfzSmiQGNsDySIlvIC513MTSAp1qgL1sH0ceLK3sU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PbKILrKUtYeTHPHYiFH7Na561CeOcYXO40jy5rZUX8E5WIt7k9DY0agiTU5dlnX8u
	 lD6nqEz1VJQZlooy5fG3WpjGdKdE4Wyc4C0l/Xz7bWo5+TSgH9jTDDZhbu6zTjbwJG
	 /q6tBlAna9M9Xnc2PPq+kxcvdUt9adTIPuiYakb58ekbB9TnaQu4VwJ5OH8Xol1tD+
	 37GPK64nUrdz1H9kR9pfJoRRhspoBIIGO5OSpdYEveVvP0KB9f1zcsD2fhqG4Wb5rZ
	 BhJc2pBBfvfpV0TkFuopQ4Tyrh+FS2NvXZZDUqeVyb1pnGRIor3sac94pWmlwR9qfR
	 4hIzj/tiZVIfQ==
Date: Thu, 9 Apr 2026 21:06:08 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	Zi Yan <ziy@nvidia.com>, Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Message-ID: <adfqkOWVFgeAkItF@kernel.org>
References: <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
 <76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com>
 <CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
 <0D1F59C7-CA35-49C8-B341-32D8C7F4A345@nvidia.com>
 <CAAi7L5fvUPUqd3A4m6wubeYh90NH+S2KBRE1R8WKerBYhkU8kg@mail.gmail.com>
 <58A8B1B4-A73B-48D2-8492-A58A03634644@nvidia.com>
 <aburnbP64n9axmu_@kernel.org>
 <CAAi7L5evx8ta8BifNiGNfUoTiaBUsv4cgQRbm_15RoAfdKPcMw@mail.gmail.com>
 <acAAp4JaTGn_STBH@kernel.org>
 <2vxzwlyj9d0b.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2vxzwlyj9d0b.fsf@kernel.org>
X-Rspam-User: 
X-Stat-Signature: xxybzmo7b7ux4er7jwcfojzzawh1d536
X-Rspamd-Queue-Id: 913494000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775757976-774877
X-HE-Meta: U2FsdGVkX19o++wSAinfQMeOt5bRqAvz2WqFfHCBscN3V/ryljYRaWnhXpMyY3ve6EmJRG9jCXe64d/NZEA/Rwu4KvkBKC5CBdg6lpMpfCXcPJIx7K5wtgibZxcoikLeUBUz+3X0J3ED4Ew4V1RnkX4p5jIlC0UWJ7xVgzJNXfSTSkQUFQAsQxp+IFjRa+XeM/Yz+OJleFQSgHDp6ibZBTS2hV7IsS/sLMlN/3FN6w3GoqnDG0ZlyxipLwkg2+gR3yK6Dj+/NUT82lhvSPEWrIDFCcy/mPvTHGT4bXMFZJAAIXmeJh8rdTcnbLESAI7XXIzhJcYbMk+ZmiVouvurXxq1NkdDejG4V37iNAdSJayWNe4UE+5pkb92AeUXaC15l4tmKEfVvlF7wPnhOk4KNaSQ+veC6jG8poqDv6Jj4bjhry+NZN6ehtyFfoBJz3CaTpX1JxsqeSNPYuoWjcVrbvX+wjdySyZ5YPIF0aCPMJtVSehrj9s5CVnhzt7TXOgGPnSF77jxE7mhOqS1aEUenpYLxuPaJ8K/TraS0xtow3/CLJzY6Q9IRBLb18c3kpyU5t1VRkAKJQd8D67OgYIAxlfJLWMZfF1qW5XS0lazoVuI0hu1Ova4+IR7P2tHK7z79UHFUayTF8JhmQiGbl66kj1Z6rJD/oOljw9+Qd1lp9I3hTDy69JxjRf8cEz+muOiv7/U44nSTzR+EzGd4kECT6rcnzzn3AY9TEUAOqfGv+w9L8F5ZGc2h9wWMcsoNSr4dyJ4FP+ogmjeL5lyJAOz09dV1e2nBADZXXsPiTB12fijQ3Biks035QmdJbnel/HBqxNFLje//TbBqk+yMHjJmHLKH/u0s1KzJtr7YDXp3ycHsDrCfgxFmq8JkPx0/NorTgzi6I+8NUfLmNNv8arJ/PLMGdtN2NddsC0VpQMTsyed7MrbPniSWqagO1prx7l8WJbsL6sCNKgKqws18bx
 4ZKlHSjR
 5KxV7zjo3xutSIKdY7rlpkTzY0orvsGSqdQWEqosCbxQe9RMSkgDcCHo1RxNLeeepupf/8+zghW1p6SlYBaPgmcbB4EIxEY+gBo7jefizq0BxDxer9+R2OxNSUE6kBs+cV+Ll03Ax7RLGdeP0YtIIb+0GOi4G+tLAszkCffL6vkTok0niwmtubG4CofolR3k4z0d3RSDZyBt2i/lnTOTQKNC2jvLj9a714xYFg3tqb6w0k3q+bh4fPYdSh+lI3n1sw/jBpMnCVi1wzQrDApsp/3drSIHFBysYQReZtfU1+u5XWEX2WQPooBFw0e0il7FPy3L0dA+R/IpMvuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 12:21:56PM +0000, Pratyush Yadav wrote:
> On Sun, Mar 22 2026, Mike Rapoport wrote:
> 
> > On Thu, Mar 19, 2026 at 07:17:48PM +0100, Michał Cłapiński wrote:
> >> On Thu, Mar 19, 2026 at 8:54 AM Mike Rapoport <rppt@kernel.org> wrote:
> [...]
> >> > +__init_memblock struct memblock_region *memblock_region_from_iter(u64 iterator)
> >> > +{
> >> > +       int index = iterator & 0xffffffff;
> >> 
> >> I'm not sure about this. __next_mem_range() has this code:
> >> /*
> >> * The region which ends first is
> >> * advanced for the next iteration.
> >> */
> >> if (m_end <= r_end)
> >>         idx_a++;
> >> else
> >>         idx_b++;
> >> 
> >> Therefore, the index you get from this might be correct or it might
> >> already be incremented.
> >
> > Hmm, right, missed that :/
> >
> > Still, we can check if an address is inside scratch in
> > reserve_bootmem_regions() and in deferred_init_pages() and set migrate type
> > to CMA in that case.
> >
> > I think something like the patch below should work. It might not be the
> > most optimized, but it localizes the changes to mm_init and memblock and
> > does not complicated the code (well, almost).
> >
> > The patch is on top of
> > https://lore.kernel.org/linux-mm/20260322143144.3540679-1-rppt@kernel.org/T/#u
> >
> > and I pushed the entire set here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kho-deferred-init
> >
> > It compiles and passes kho self test with both deferred pages enabled and
> > disabled, but I didn't do further testing yet.
> >
> > From 97aa1ea8e085a128dd5add73f81a5a1e4e0aad5e Mon Sep 17 00:00:00 2001
> > From: Michal Clapinski <mclapinski@google.com>
> > Date: Tue, 17 Mar 2026 15:15:33 +0100
> > Subject: [PATCH] kho: fix deferred initialization of scratch areas
> >
> > Currently, if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled,
> > kho_release_scratch() will initialize the struct pages and set migratetype
> > of KHO scratch. Unless the whole scratch fits below first_deferred_pfn, some
> > of that will be overwritten either by deferred_init_pages() or
> > memmap_init_reserved_range().
> >
> > To fix it, modify kho_release_scratch() to only set the migratetype on
> > already initialized pages and make deferred_init_pages() and
> > memmap_init_reserved_range() recognize KHO scratch regions and set
> > migratetype of pageblocks in that regions to MIGRATE_CMA.
> 
> Hmm, I don't like that how complex this is. It adds another layer of
> complexity to the initialization of the migratetype, and you have to dig
> through all the possible call sites to be sure that we catch all the
> cases. Makes it harder to wrap your head around it. Plus, makes it more
> likely for bugs to slip through if later refactors change some page init
> flow.
> 
> Is the cost to look through the scratch array really that bad? I would
> suspect we'd have at most 4-6 per-node scratches, and one global one
> lowmem. So I'd expect around 10 items to look through, and it will
> probably be in the cache anyway.

The check is most probably cheap enough, but if we stick it into
init_pageblock_migratetype(), we'd check each pageblock even though we have
that information already for much larger chunks. And we should use that
information rather than go back and forth for each pageblock.
 
> Michal, did you ever run any numbers on how much extra time
> init_pageblock_migratetype() takes as a result of your patch?
> 
> Anyway, Mike, if you do want to do it this way, it LGTM for the most
> part, but some comments below.
> 
> > @@ -1466,10 +1465,13 @@ static void __init kho_release_scratch(void)
> >  	 * we can reuse it as scratch memory again later.
> >  	 */
> >  	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
> > -			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
> > +			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
> >  		ulong start_pfn = pageblock_start_pfn(PFN_DOWN(start));
> >  		ulong end_pfn = pageblock_align(PFN_UP(end));
> >  		ulong pfn;
> > +#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
> > +		end_pfn = min(end_pfn, NODE_DATA(nid)->first_deferred_pfn);
> > +#endif
> 
> Can we just get rid of this entirely? And just update
> memmap_init_zone_range() to also look for scratch and set the
> migratetype correctly from the get go? That's more consistent IMO. The
> two main places that initialize the struct page,
> memmap_init_zone_range() and deferred_init_memmap_chunk(), check for
> scratch and set the migratetype correctly.

We could. E.g. let memmap_init() check the memblock flags and pass the
migratetype to memmap_init_zone_range().

I wanted to avoid as much KHO code in mm/ as possible, but if it is must
have in deferred_init_memmap_chunk() we could add some to memmap_init() as
well.
 
> > @@ -2061,12 +2060,15 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
> >  		spfn = max(spfn, start_pfn);
> >  		epfn = min(epfn, end_pfn);
> >  
> > +		if (memblock_is_kho_scratch_memory(PFN_PHYS(spfn)))
> > +			mt = MIGRATE_CMA;
> 
> Would it make sense for for_each_free_mem_range() to also return the
> flags for the region? Then you won't have to do another search. It adds
> yet another parameter to it so no strong opinion, but something to
> consider.

I hesitated a lot about this.
Have you seen memblock::__next_mem_range() signature? ;-)

I decided to start with something correct, but slowish and leave the churn
and speed for later.
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

