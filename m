Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E7FD35160
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC70F6B0005; Wed,  1 Apr 2026 05:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78036B0088; Wed,  1 Apr 2026 05:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67226B0089; Wed,  1 Apr 2026 05:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C32C06B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:19:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76C125A795
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:19:38 +0000 (UTC)
X-FDA: 84609439236.07.DBC8F76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A7791180004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:19:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jp3XqGg/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775035176; a=rsa-sha256;
	cv=none;
	b=TojHEvuF1lhCcz8ILA0q7FRmG+Kgk/tUu7oANjpIlBIVLF+bjlsyG1moExqJA25D/9NhtF
	ZEk/1r6IsTD1/G4N6vaJ3EP5p1CBGvVxkZ2sk/10BlvQthCg4zW9JGMoqmXCJ8isqQn8s9
	ooQBRSqW+1Vww29FTOQBGAicmc8cP4Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jp3XqGg/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775035176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZMTgbJN9tgqibcOCuGESgyJ4VCPAkiVtsO9LrIwjHrw=;
	b=3MYBkofRljw0KR0U36IEa2ovr0wesfJgOpW40fY9l3GXZvsEKO+jOSyRF5VoT7Iegb2XX1
	ypH7S07D9e04m41BwqybZ7y81R+wOTy1nSh7kBTJli3b/7idXHLRZLTC9V2dL3srRvrv/v
	iwkLiAK/xGLH7usGm/RUJIO0k7WW5OA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2A5D406F8;
	Wed,  1 Apr 2026 09:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FB2C4CEF7;
	Wed,  1 Apr 2026 09:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775035175;
	bh=jUjFCCnbzFPHXcrJnArw9JouUlj+FBuCgch0ngZXMTw=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Jp3XqGg/uKhu2Pqn6P4Nf7cKFakXRJ1HlZxnet10zStjNd7ZZPhgmZCmpdCnRMnsF
	 zcrke9g3oIIV4+Jto4uhKj1rZ/geQMUFm4dWw1deZ1RwmvGnNmnzhR3KMrNtPdytnt
	 HijuMCb6e0TVopn0OmE2xnqCl+RFgg6Y/spg/GTf/sVJeY3rZ+ERuDCieEQiMNqwAB
	 SpyczBXcMcoD8iCXJe6vVB0sjqwyUzYHSaYzS9WcTvA2WtlRsot4gX9iZ6JJT8FrpJ
	 oVGxNIljsZKpb9lJ0QZxSJ8lFAYlYRo6dmVnXoMlOy2aksvdWEqs1TKkSdw+Xl8vCh
	 BU0ZQJMiNO/NA==
Message-ID: <c52c0500-b255-41ee-a2fd-1caaba5499df@kernel.org>
Date: Wed, 1 Apr 2026 11:19:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] vmalloc: Optimize vfree
Content-Language: en-US
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260331152208.975266-1-usama.anjum@arm.com>
 <20260331152208.975266-3-usama.anjum@arm.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260331152208.975266-3-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A7791180004
X-Stat-Signature: eto68fyf469z6p33gdqwyr1nwz386bzx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775035176-290613
X-HE-Meta: U2FsdGVkX1+RcasvlqRTLL1JVe/66Zj2w6kFB0q+5oJVSZaocgq3ZoMSkGwy2phmkG+WaOLxTnlgt2jHE89wtj+jAYovMcqZjeU1jIGPIYV0wFRIGKHF3/dzukFakAMOfqxXrOc4Z+L7N6GSos9ZGxohtCTuLQ+wqcs4NWfPzhOwK/f+FjZK1pPDRxpnI1rho3eDLPq2gd5a1IqSynCbCeZFcpDGZmGJ6vx0OWyuAXnBpNP5ErukG8rmzHq2uEhrkX8PQ/EN8xz7GBWlEqtO7BMByGUxEpUjz6gJqzvXK9zpFMm9FN6gtPENcylo2ukLj08iyKjonuToN81VX3y1MFDGQhh+It0bRS30Cz7ewpaBu/awphNcXiLJmCEf8x+pTTTI0vscYJMarPMgqD8G87MjyMjK47yBP8s0c2CYiFdK3xaD0q+y/NFyQlvAEcqtjMsQEEWZ1kclH7r8YF2FBTlcHmilAvAHZI1sTINVGXABxBCJiZyRCYuJKCNOBUerYh1YXvw5xaBPIJaL0bTWif0miNxWI6LQ0UwdmMViHIW3FIbAKfGaxf3g/5rorQ/+HaJs46RngaHTf610AuiY9XZI56wuDA9be+zFmLIl/oGeuux1CiqSXkj74h1AlfVeAKGbpaBqwDZpYqJENMa4aIV7lsbx+NsOBG94rkSZEa8yolPou95pu5PCSWUlwAzi5iBQuk09WNlfDBtMK+m7k4FvNB5hX+CVFyA2GE1o5BrFlXN+dO36ihbMZHEqOE9AVhqufSVwW3JCOUOSKiQ8t+Z7jgs8yOI1tQTGHLlUeg4pzoHsWmcCCmMjO73SQAP3XZuBzpY9PmMb4WJw1T8mH+sO6nqXKNPo2S+t57lOE4GI9peGHXWOVdQ6H/fnfBz7p+Zr+SbLMkDdZ3FdsJ9f0G1Cqavr2yGcDT5BCeaabwdi+RRzr1J1TAjqvbZh35XXNw6klA+LnQtK9gxDcSV
 XPjTpak9
 jqMkzigMBY9Agv3Lq2QIZstTnCyESpwUHUhGAZJlt4GvGPHII2ubiRot21dKvfpMawtsUuavVjORlqnISm4HuC6FnPJWmI4NaY/ki/QCTAVU+92Su5Ns3l3wc/OhdzbZECo/OzVoMzPdrlpmXzfEwlhooC+68YhF0p4v/KpbnwrIRXwDH60ZJ6J2qSmaViP09xQ2vWIeZ0Pe7xC3cxLVb7Kq74UTLgF9CJBn+M17rhOt34gfplxisU8E9j+cwScI289pfZpFSw7ml8tjLHxnXm0ynE28bdSv/M9PRMGvwhfXFw6tmyQtyeiezlERNozhrtIZD6OiOZxV05mNT0LEf9kuegLBTIdjYvLiTZFUGD/DLcgfN+GxeQq6XWPC6bcI8QsXBQEnm//lY+sX/Hetfd2IY9S/X0HswVi/6SiQaoYG+YMF4B2hCVqq+qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Nit: the subject could be more specific, e.g. like this?

vmalloc: Optimize vfree with free_pages_bulk()

On 3/31/26 17:22, Muhammad Usama Anjum wrote:
> From: Ryan Roberts <ryan.roberts@arm.com>
> 
> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
> must immediately split_page() to order-0 so that it remains compatible
> with users that want to access the underlying struct page.
> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
> allocator") recently made it much more likely for vmalloc to allocate
> high order pages which are subsequently split to order-0.
> 
> Unfortunately this had the side effect of causing performance
> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
> benchmarks). See Closes: tag. This happens because the high order pages
> must be gotten from the buddy but then because they are split to
> order-0, when they are freed they are freed to the order-0 pcp.
> Previously allocation was for order-0 pages so they were recycled from
> the pcp.
> 
> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
> that it also frees that order-3 page to the order-3 pcp, then the
> regression could be removed.
> 
> So let's do exactly that; update stats separately first as coalescing is
> hard to do correctly without complexity. Use free_pages_bulk() which uses
> the new __free_contig_range() API to batch-free contiguous ranges of pfns.
> This not only removes the regression, but significantly improves
> performance of vfree beyond the baseline.
> 
> A selection of test_vmalloc benchmarks running on arm64 server class
> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
> large order pages from buddy allocator") was added in v6.19-rc1 where we
> see regressions. Then with this change performance is much better. (>0
> is faster, <0 is slower, (R)/(I) = statistically significant
> Regression/Improvement):
> 
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
> +=================+==========================================================+===================+====================+
> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> 
> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
> +{
> +	while (nr_pages) {
> +		unsigned long nr_contig = num_pages_contiguous(page_array, nr_pages);
> +
> +		__free_contig_range(page_to_pfn(*page_array), nr_contig);

I'll note that num_pages_contiguous() already handled crossing the section
boundaries and __free_contig_range() checks them again. But that's fine I
think, we don't have to optimize for !SPARSEMEM_VMEMMAP architectures and on
SPARSEMEM_VMEMMAP the checks should be compiled out, right.
It would complicate the API otherwise.

> +
> +		nr_pages -= nr_contig;
> +		page_array += nr_contig;
> +		cond_resched();
> +	}
> +}
> +
>  /*
>   * This is the 'heart' of the zoned buddy allocator.
>   */

