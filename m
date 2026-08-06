Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1ABFC5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 23:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93BBC6B008A; Thu,  6 Aug 2026 19:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913876B0092; Thu,  6 Aug 2026 19:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853E16B0093; Thu,  6 Aug 2026 19:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 489136B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:29:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AEF221A065A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:29:48 +0000 (UTC)
X-FDA: 85072439256.16.57780E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0832F1C0002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:29:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPN9I9yD;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786058987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBgeHQZsrsk/VLEduVyme051pQyIT6NonmpdfuoL5k4=;
	b=rbn+IBMP9Px9LWSMm2zWw8k9TTU+3+CUaaWeXPAIQWMLtO1woR3fykzgOO699BBcMCmtr+
	yAodXYlPtkziNVUqdeWFE5ry4R5m11FU9w+E2reQVlGLNBlFsEQQIFqo7KLvkWSavd4EBp
	7+nzyW+TTxg8CXxUs5QmUBbK2QmULdQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPN9I9yD;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786058987;
	b=szr3yAsTRJF0xERN+ycq4wvC6pPDL9qB85UK1ci/+EKtzv/QCUtM7lRTq6LQwXyskQ/QAK
	hy82cj0dMVI1kZ7gkbJHMXWsnnqM/eDqzqSJyBxcunF3mowOkA8fNgeM4WFjsub/HqQCgj
	czNXMtG5kJ/wrR+3iyVmhg/oxXHM8eU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BDF3408CB;
	Thu,  6 Aug 2026 23:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE571F000E9;
	Thu,  6 Aug 2026 23:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786058986;
	bh=sBgeHQZsrsk/VLEduVyme051pQyIT6NonmpdfuoL5k4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PPN9I9yDnuc5twCDP0Mpn4tjKqscTci3jF8EhLm3aIE8z24caOeTF3n8zrAIQbnzo
	 B1ErSDuz7D381vVmvFuZ4FookgNVTB1XClSbQZVLCafTVThJWQKbPvD8PR4rZCuwS0
	 I5WcNm4zngbLyjxZNzVvta2lFJcBx6TxIZkfpdmWF6l7xHqU9Ib+KoR0b2kNZCNO/4
	 23Vl3xxb6tMChvHI107KVfm59WUWPuv9q8ZQwDInbuU2V0tJcKNgXOT0kvp9Tb6clW
	 D8+BwectjK90Q1DeXmWLjgprTOvW1Cc3DcmXZ6lDCe3YGSJISO6hrbbupkdZkt3bk4
	 s1iD+2/7FhWNw==
Date: Thu, 6 Aug 2026 23:29:43 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 24/26] mm/page_alloc: always direct compact for
 unmapped allocs
Message-ID: <anUUA66kHWAnepLt@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-24-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-24-6f5729aa9832@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0832F1C0002
X-Stat-Signature: 6jz1q3rr4nzr5wnrjw37nkf1fokpyewe
X-HE-Tag: 1786058986-678529
X-HE-Meta: U2FsdGVkX1/6LdTqg2Y4ao97o83bpSTNufKAVL/VnkpI/n3wM/IHSkuZhPFlpgQeoup2fhGAQOVpsAMwLzHxJtuG/BbAhzOZORJLIOgv9NSwAlEi9AWZzdLXy8KstRyTscoJ0+jKSqklVRZKAGE056j4h4j2iO+nrVNEG37FdddEp6QQnBeo5XbXe9651PQLOd76QEKj9JClIDnSoLQkU3Eky7J1K1evZljZpdOGH26tfIqcTr3WZRDEb8ZawtNYvbbrRQc3bc6f3bIAscVJW6B3on2LG98RybhSGfNCaxEvEoW4a+4a3/GHdHi8FoCGu4TiRlDeRHWl9OBS1G6bH2aoKRQnYB+64oOkooQ+vjWAn8PoU4+9BMygOLzNWvAVeVDpE3CnvQ/DR1m7cBRgEa44SRCOQ6022jJDSPXbnnFkEqwM1AwPJEtG3Imm2ULVBxDkaJhAyojnsV38mECHtBQBooiKurOKXzLAAH6kg8yIWe2bXLywnZgfNCaQ/fY2JacAjZdX7oTsDmwk3Lb/O/zvP4a07ElpNgBXrvor9rCdv1va09eGOrlKKyplOS6DeX6S8ee0EDraZywKp2aKr7obSQuKVxaVjDQcqBMXixfQXCKi54eKgyf7p4MxBHSRoVlb/6lga9I3UA1q21HSAmNLmt/qip7lc2ytT1cIfQzNH08sivnSZ/TePt8w1wWESIpuDUS98vaa6X0ZMK+iBzAn+ZIHXvg6vmJj8sCnQgHbJjnkgoCpem9wqR21KvZz1T0elFZowaNtGecghTOJkjWeMz8BjpglrFhiYSDNzDIP3UJydVGSk7o1ncxUGXilYOEVNZWX6WA4l295vruUc/VZ5aztXCoYMpwVUMp4BQZOmtsEGUfcsn/l2mu9BhcNHapNRmJtgbLbbZVfwUx6fBhWMSGsH3IqVpPIr4zsxdk7ddHiRdHOQdKxHJGeqsCziau2hN1QgOFRINEHmxC
 cF6Qhx7y
 iJ3hV1+yO6hZM7GI4y0TSDSqtGMEFay/4QEkNfTBmDlDjQ2VLcK1PhuThkBDNETJhmLcbECzffzRzqL3LCagBKUnx7W0Sad0CxRcc77SkBNZYPQtNy5Wf+CjN2wq6qNaitgnRLAUj/f8wojEXGkJUK8iRZ+aYvDo4ke+MXeGzMchlcD7yNB+hAc/nr+1wwAglvCMdyRWbdm6Rb4tDVyI4kcIb4hkKCCK9mWw3/AQQqJDyTnmzc7n4YoXEfa6JMKQAXw6rKg7Y+tbG0CApn47F9Gu4yrKmJcx9gYZqs4ACEiLkc1mf9Wbgt+jMRQmJUZvK+XDckYq1mnS14dAswKljBuamc4C3c9av6kN9jYSZVVi5CF4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:57PM +0000, Brendan Jackman wrote:
> This is the minimal solution for ensuring that compaction can service
> unmapped allocations. Without this, it's possible for compaction to just
> check watermarks and see plenty of free pages, without being aware of
> the direct map state, and thereby cause an ALLOC_UNMAPPED allocation to
> fail unnecessarily.
> 
> Instead, with this change, promote compact_order to pageblock order for
> unmapped allocations, much like defrag_mode. Then, check specifically in
> compaction for the presence of wholly mapped blocks that can be unmapped
> once direct compact is complete.
> 
> This all takes advantage of a major simplification: since unmapped
> blocks are currently always unmovable, this can be asymmetric. There is
> never a need to promote a !ALLOC_UNMAPPED allocation to compacting at
> pageblock_order, because compaction would be trying to generate a
> currently-unmapped block to map; that will always fail because it would
> require migrating unmapped pages, which is not supported at the moment.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/compaction.c | 22 ++++++++++++++++++----
>  mm/page_alloc.c |  9 +++++++++
>  2 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index ed12d2fc6fad3..fe1aaf293bbce 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2531,12 +2531,25 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
>  static enum compact_result
>  compaction_suit_allocation_order(struct zone *zone, unsigned int order,
>  				 int highest_zoneidx, unsigned int alloc_flags,
> -				 bool async, bool kcompactd)
> +				 bool unmapped, bool async, bool kcompactd)
>  {
>  	unsigned long free_pages;
>  	unsigned long watermark;
>  
> -	if (kcompactd && defrag_mode)
> +	/*
> +	 * When trying to generate an unmapped block, check the counter for
> +	 * direct-mapped blocks specifically, since we'll need to unmap the
> +	 * whole block to service the allocation.
> +	 *
> +	 * Why doesn't this apply to the other way around too? (Mightn't we need
> +	 * to _map_ a whole block, to service a !ALLOC_UNMAPPED allocation?) No,
> +	 * because of a likely-temporary simplification: currently, unmapped
> +	 * blocks never contain movable pages, so compaction isn't going to free
> +	 * up one of those.
> +	 */
> +	if (unmapped)
> +		free_pages = zone_page_state(zone, NR_FREE_PAGES_BLOCKS_MAPPED);
> +	else if (kcompactd && defrag_mode)
>  		free_pages = zone_free_pages_blocks(zone);
>  	else
>  		free_pages = zone_page_state(zone, NR_FREE_PAGES);

(Sorry in advance for the wall of text, while trying to understand why
we need this I ended up spending a lot of time staring at the compaction
code and coming up with even more questions)

Hmm why do we need to do this here?

free pages is used in this check below:

        watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
        if (__zone_watermark_ok(zone, order, watermark, highest_zoneidx,
                                alloc_flags, free_pages))
                return COMPACT_SUCCESS;

IIUC, this basically checks if we can skip compaction because we already
have enough free pages, both in terms of zone watermarks as well as the
availability of pages in the right order.

free_pages is used for the watermark checks, so using
NR_FREE_PAGES_BLOCKS_MAPPED will result in __zone_watermark_ok()
returning false if all free memory is above the watermark, but free
mapped memory specifically is above the watermark.

This kinda makes sense, but:
1. Shouldn't we be checking all free page blocks (i.e.
zone_free_pages_blocks() like defrag_mode), as entirely free unmapped
blocks can also serve the allocation?

2. More importantly, I think for this check the more important part is
checking if we have pages from the correct order (i.e. the loop at the
end of __zone_watermark_ok()). Since we promote compaction requests for
unmapped allocations to pageblock_order, this will essentially check if
we have any free pageblocks, which is ultimately what we want.

Checking the watermark against mapped pages only here seems arbitrary
tbh, since all other callers of __zone_watermark_ok() are oblivious to
mapped vs. unmapped, which seems to be a bigger issue.

For example, compaction_suitable(), which IIUC actually checks if we
have enough free memory as scratch space for compaction will check all
free memory against the watermark, even though it cannot use unmapped
memory. Same probably applies for other callers in
allocation/reclaim/compaction paths.

Since the watermark checks are ignorant of unmapped memory, we can end
up serving allocations when the actual free mapped memory we have is
below watermarks, dipping into reserves and causing OOM kills if we run
out of mapped memory.

Other than the watermark checks, the loop at the end of
__zone_watermark_ok() checking for available free pages of the required
order is also oblivious to unmapped memory:

        for (o = order; o < NR_PAGE_ORDERS; o++) {
                struct free_area *area = &z->free_area[o];

                if (!area->nr_free)
                        continue;

                for (int ft_idx = 0; ft_idx < NR_FREETYPE_IDXS; ft_idx++) {
                        freetype_t ft = freetype_from_idx(ft_idx);
                        int mt = free_to_migratetype(ft);

                        if (list_empty(&area->free_list[ft_idx]))
                                continue;

                        if (mt < MIGRATE_PCPTYPES)
                                return true;

			...
                }
        }

AFAICT free_to_migratetype() will return MIRATE_UNMOVABLE for unmapped
pages, so __zone_watermark_ok() will return true for mapped allocations
if there's a free unmapped page of the same order, even though it cannot
actually be used (unless order >= pageblock_order).

So it seems like __zone_watermark_ok() needs to be reworked to account
for unmapped pages, and potentially other watermark checks.

I wonder if this problem can be side-stepped if we allow sharing
pageblocks between mapped and unmapped pages as a fallback (as I
mentioned in another comment). With this, the checks in
__zone_watermark_ok() can probably stay as-is since all free unmapped
memory can be used for all allocations.

Of course, this is not ideal and would cause performance regressions so
we need this to be the last option, probably by generating free
pageblocks more aggressively (like defrag mode). Perhaps we can somehow
detect the presence of unmapped allocations and treat it like defrag
mode?

> @@ -2599,6 +2612,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
>  		ret = compaction_suit_allocation_order(cc->zone, cc->order,
>  						       cc->highest_zoneidx,
>  						       cc->alloc_flags,
> +						       freetype_unmapped(cc->freetype),
>  						       cc->mode == MIGRATE_ASYNC,
>  						       !cc->direct_compaction);
>  		if (ret != COMPACT_CONTINUE)
> @@ -3084,7 +3098,7 @@ static bool kcompactd_node_suitable(pg_data_t *pgdat)
>  		ret = compaction_suit_allocation_order(zone,
>  				pgdat->kcompactd_max_order,
>  				highest_zoneidx, alloc_flags,
> -				false, true);
> +				false, false, true);
>  		if (ret == COMPACT_CONTINUE)
>  			return true;
>  	}
> @@ -3127,7 +3141,7 @@ static void kcompactd_do_work(pg_data_t *pgdat)
>  
>  		ret = compaction_suit_allocation_order(zone,
>  				cc.order, zoneid, cc.alloc_flags,
> -				false, true);
> +				false, false, true);
>  		if (ret != COMPACT_CONTINUE)
>  			continue;
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d12ce84662ab7..5f1dea7eee15b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -827,6 +827,9 @@ compaction_capture(struct capture_control *capc, struct page *page,
>  	    capc_mt != MIGRATE_MOVABLE)
>  		return false;
>  
> +	if (freetype_flags(freetype) != freetype_flags(capc->freetype))
> +		return false;
> +
>  	if (migratetype != capc_mt)
>  		trace_mm_page_alloc_extfrag(page, capc->order, order,
>  					    capc_mt, migratetype);
> @@ -4523,6 +4526,12 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  	if ((alloc_flags & ALLOC_NOFRAGMENT) &&
>  	    free_to_migratetype(ac->freetype) != MIGRATE_MOVABLE)
>  		compact_order = max(order, pageblock_order);
> +	/*
> +	 * Unmapped allocations benefit from compaction even at order 0, because the
> +	 * allocator will actually grab a whole block.
> +	 */
> +	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED)
> +		compact_order = max(order, pageblock_order);
>  
>  	if (!compact_order)
>  		return NULL;
> 
> -- 
> 2.54.0
> 

