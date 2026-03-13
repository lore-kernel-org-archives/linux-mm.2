Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF47105F7A6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 13:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7EE46B0088; Fri, 13 Mar 2026 09:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02596B0089; Fri, 13 Mar 2026 09:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E726B008A; Fri, 13 Mar 2026 09:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6B36B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:58:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39AFE139503
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:58:35 +0000 (UTC)
X-FDA: 84541194990.18.5C71249
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A1B40C000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:58:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XX4cQHC3;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773410313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDtcuq+jZAq8nSruY2x07zz92Rm4Lz2QSe0PkkRpDPo=;
	b=z6r+MmuyIEt9EezPFmMnNFf0LO0wBayLyt4leUfl61TQUjGtQ0udU1fyUjeA+KDTwGRQ6S
	O2rASdOi1IGh7A38t/Y9OJeXu3HGY0mhGU2IA9lDdkJJ0bngDJQ4ri6mAcsPLPrSmYJVb4
	ihbKQN84vf51JA2Rcl14t8lDHEv1SPg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XX4cQHC3;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773410313; a=rsa-sha256;
	cv=none;
	b=CTHqW+l2aWd3aPYUiVjV0R906ml2MyKJkoXm25pzZq6XON7AQgzvs1/gD60KXDG6eiq6QZ
	bbo/iDznOVvOKbJFci3Okf/JcxgeBE1VRflMzdFZ7+/QdzhA+6Mtt1sGf88V/jvZ06uxXn
	0okX6yvAaBcvqfWPvYmx4ryy3hhz2+U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED2C361843;
	Fri, 13 Mar 2026 13:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B37AC2BC86;
	Fri, 13 Mar 2026 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773410312;
	bh=kshVJg/rQTERmOD6YiWVGRVHPpNBvBSWyHEFYDvoDCM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XX4cQHC3W+i3JG5+SggGUb4YhfFkxWFUaZMFpdj6PwCYa/AYmIZ7GxWKHVCjC6gke
	 kuo1XcRg4bXFWt0s13h6QCHyHjxocZ/hbBR1qz12U95YZ7bHoaQXHucQ4tRAKnEvNe
	 oTVLM6qH3rzagaV2SYXufW1SWuhUb0pWrakRUanvW/tN9Ef/G4VSd7h8TtIH4Z3QUE
	 uR4UO6yU89zstZ+6O80qPMIakUZzD3XL87KJcZd03qnO3bEeaibxKh9iWblSBiA5Mp
	 I3hgd4NKR3w//f7qsBtszC8GsY8Vsv5dc8tWhCdkJMIQ3K9DwRxQw7zMQvONCl8FMv
	 KmneJRjsK5wmw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Pratyush
 Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,  Samiullah
 Khawaja <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH v6 1/2] kho: fix deferred init of kho scratch
In-Reply-To: <20260311125539.4123672-2-mclapinski@google.com> (Michal
	Clapinski's message of "Wed, 11 Mar 2026 13:55:38 +0100")
References: <20260311125539.4123672-1-mclapinski@google.com>
	<20260311125539.4123672-2-mclapinski@google.com>
Date: Fri, 13 Mar 2026 13:58:28 +0000
Message-ID: <2vxz1phnesqj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: A1B40C000D
X-Rspamd-Server: rspam07
X-Stat-Signature: p83x9ry4w478bdfzng1zgkmshkq4wqwe
X-Rspam-User: 
X-HE-Tag: 1773410313-977396
X-HE-Meta: U2FsdGVkX1+ycKtbwgET+JjrdQt1rssatlInUtF6sFgAAlCTVnxBIu5MjzFyTu9Hhpl0k2qG0+PibBeZ7AQQQlcvt5/WyBgH5aLW76l/nfYa1H17DXbkTDGi2/dutmd42k8X/pe9rsqn89qjLStXVi/cXropOskrHKMUydiS9+ECDN1xNYoxdGU+vkYCN9PbPd6vZ6TTkNaDWVCVutXIn8sN2+hG3i/fCzEMSMBFNx7zwvx/QS/DHND0fqBL/8vJL+cQ1afWUcsjbYKBWVbIqRUAO8crUxx7w8ITrFLs9dqSTRKTqFoVWO1nvYvsZM5bj1S0czm8ZzGCz+eFlbB14V/FLGw3Vz6nbVOG2jMl/sp4O0oXhjAGmvNOgjvZ65JiQUcugeqtZqyANoJsDnuMMC9+wGMW7CmaHd2EI2Z75VLF328ht2vVuy0Mk8Rfy085OYB1VCQZNelujiAQW8EdJom5hvuWZbX3aapVDu2IaJKipPYzKGnxna4h4e5G6v6kzObvAYZxxn/2i1J6CMjS0cdnlGHYlIByHODEyjmd+XD/e5EFux3tDwweqXInwbx/eLgJ9VAaSnXLSstZITKuQSXLC7vlSVWaydu99sHftAuXeqeEor29gfYPprbIjzbwmonDtXKCJvjhS3774WRgPy4S20nux/GaXg1Xe79mWbcD6k91dBUnXGB8uThwDdCoR2V85tGJJt8nMPmLTVUCP32Zu65kJF5TPgSnVDYcKheQJPAwc9Wv25sdWv8arM+vnOZfjixT7RMB71W3+WVBawKiNMuNqmfms5YPtC64tb7Q44t+U/uS5RBkNZOD8+sgYRSagYTfW6tueKhjRA9ligDar6g2zS5dEmaEtHt20s150nBebDE76zdkGx2Yc83r6J7PWmxbg2EhRWVGmnDxxlh4GYb4QKgvwGLXGVVdHL2LSt9lqM9XAWc9nRfVLhU43z81VBUBBCCMWuun+r7
 ff+OuhyN
 3rO5Y0/rFgGld79xML/cgIrOKtQLfuw/tWOKgAt7z1byur3Q9VUasJhTU8VXBVXkIQgmfCPOLQE1WefIFn6U577cirAIxSgxfnGcyRcNQ+E6yhRnt8J6VV5frFDIiaTxXK1JfsN+N1W3WWTllG9oKHl9HpplykBLhnB/5J5THCCiagRQ+PGMDSXLVGCxzjjM0tXVw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On Wed, Mar 11 2026, Michal Clapinski wrote:

> Currently, if DEFERRED is enabled, kho_release_scratch will initialize
> the struct pages and set migratetype of kho scratch. Unless the whole
> scratch fit below first_deferred_pfn, some of that will be overwritten
> either by deferred_init_pages or memmap_init_reserved_pages.
>
> To fix it, I initialize kho scratch early and modify every other
> path to leave the scratch alone.
>
> In detail:
> 1. Modify deferred_init_memmap_chunk to not initialize kho
> scratch, since we already did that. Then, modify deferred_free_pages
> to not set the migratetype. Also modify reserve_bootmem_region to skip
> initializing kho scratch.
>
> 2. Since kho scratch is now not initialized by any other code, we have
> to initialize it ourselves also on cold boot. On cold boot memblock
> doesn't mark scratch as scratch, so we also have to modify the
> initialization function to not use memblock regions.
>
> Signed-off-by: Michal Clapinski <mclapinski@google.com>

I haven't had the time to carefully review this yet, but sharing some
high level thoughts.

IIUC the real problem isn't struct page initialization, but the fact
that if the page is at a pageblock boundary its migrate type is not
correctly set to MIGRATE_CMA. So you fix the problem by making sure no
one else but KHO can initialize the scratch pages.

I think the end result makes the already complicated page initialization
sequence even more complicated. I tried to grok that patch and it makes
my brain hurt.

Can we get away with something simpler? Here's an idea: keep the struct
page init the same as it is now, just modify
init_pageblock_migratetype() to override the migrate type if page lands
in scratch. It already does something similar with MIGRATE_PCPTYPES:

	if (unlikely(page_group_by_mobility_disabled &&
		     migratetype < MIGRATE_PCPTYPES))
		migratetype = MIGRATE_UNMOVABLE;

So we can also add:

	/*
	 * Scratch pages are always MIGRATE_CMA since they can't contain
	 * unmovable allocations.
	 */
	if (unlikely(pfn_is_kho_scratch(page_to_pfn(page))))
		migratetype = MIGRATE_CMA;

Do you think this will work? If yes, then I think it is a lot nicer than
what this patch is doing.

Also, pfn_is_kho_scratch() is pretty much a duplicate of
kho_scratch_overlap(). Please pull kho_scratch_overlap() out of
kexec_handover_debug.c and use that instead.

> ---
> My previous idea of marking scratch as CMA late, after deferred struct
> page init was done, was bad since allocations can be made before that
> and if they land in kho scratch, they become unpreservable.
> Such was the case with iommu page tables.
[...]

-- 
Regards,
Pratyush Yadav

