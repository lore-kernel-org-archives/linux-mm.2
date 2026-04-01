Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28D04D35163
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3496B008A; Wed,  1 Apr 2026 05:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66CE96B0092; Wed,  1 Apr 2026 05:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534B96B0093; Wed,  1 Apr 2026 05:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1A16B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:53:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD1D3B86B5
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:53:11 +0000 (UTC)
X-FDA: 84609523782.14.654EA1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0A67F100007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:53:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=piDryReG;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=piDryReG;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775037190; a=rsa-sha256;
	cv=none;
	b=lshORkmQDQ8YYfLjBledyOG8hrUlXb+VQgv5H1xV89OZPm/g3zDzPZotgDliCDLuI3dJzf
	3VK+jkVeIGMI0NgJ6cLX55ILWJ3uoO8YhPjvUnESuPQDphJrSsKNYsvKbOQlLVS+IKyoaj
	tmYTTSaTDznAkmpmyx4/VFYr7yfTc5Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775037190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41zTYC9DqtFIj4u6ayT2Kt/xFNOE3tfPtMknuJfcKrY=;
	b=CzbgfRGhSOHWqn9ATHUA2Ptp0ocaOdgX/DdoUr1aKrGOuCzO/X56OVtlJxP7p8fvDQi3ze
	7cAy3lsOqdmAJ0IgHQQ6d7Zia3H0XWXc9TE303jPS11KJ+OycHNyFD51kUkiBDlSVfL8bB
	RGAnFfCsY74dbTouRiPr9p84RMnuHdI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3C94406E1;
	Wed,  1 Apr 2026 09:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80299C4CEF7;
	Wed,  1 Apr 2026 09:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775037188;
	bh=WFHYDh2U7HFPigQp04LXq0XBtJrUxfoKQkJAsyQrpFs=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=piDryReGF6P4KDpus41igVza7yiAw9WVtchLK+C0ibsvJZn2k97a1AqUVSN2ZFUi7
	 WlsJ45S39aVfZg6DXRwGPPPuvON33H5bJRV8SfT0O7G+aOBbzmeazKQrAByN8eDMhp
	 kOs8Q9415siUdz0PT+BMvSUMe4eGkz4n20+svF4iIZWDEFls367ChF4X/Mm5OHoI/g
	 s5wdglo+gh9oO5u0khstCMi86A4FvrzBQU3LI9tW4w628P6rytplRHlJs+Ll3mq2MF
	 3707TO8gxFhYXfHN4/HqYtxfRKjsY8SuuKoKoW+Z4/xxjTmkaVkKXIKiMYVPc/4LbF
	 RPyB0plxDRy8A==
Message-ID: <3c80a6f0-8626-4663-85d2-888572dce900@kernel.org>
Date: Wed, 1 Apr 2026 11:53:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] vmalloc: Optimize vfree
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
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
 <c52c0500-b255-41ee-a2fd-1caaba5499df@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c52c0500-b255-41ee-a2fd-1caaba5499df@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0A67F100007
X-Stat-Signature: nnk13qs4nj4efszeyu99o511mkw3z35g
X-Rspam-User: 
X-HE-Tag: 1775037189-709461
X-HE-Meta: U2FsdGVkX1+E5e9MlnWsiI4Ub3zZEfu5cUwEYMsPrKO1ShH23Z04evK6vm1gDobihS79+JwCSSzxtZydn2QVH8cRXX5x5786HYW2qDuCRQ5m3lWnHkWUyUdlqXtluzTF/7R8Ca4n17yoia3lThyONuZW0noBwo2ZsIfWcF6lTQ60J3mLNuNNuDJGogbg7VqVIs4S/kPaHJXL0qepAWWaKdndnaljjyLdHu1mtfx7R6Yc+EAGYuZafyKw2NQN7sL//bjg30fCxv48z/6vYqVgLbwk1rnvnF6G61reYYiZDRoXtJl7FhSyypVJNjwzVb9UPKePuddJFEPO/agbIXw4tDLR5Exgec2e6fRKM/zMV5zv0Qx0tKHfvJ0FSTn46YNl4pj9qIj47PzavZnb2clHDY9bxbrW5DhYGvRaVvr9SQt9r61foeBThkt16gT0JoBBLoBdTL82Q+/43MfFTzf+vHigsUPaTLWTHzlSvg7WW9Qjx8NFxGWUIKECgeDqWZdLe+l5bgqvy1mzs4LCFzvBtXcxapC1zSfktw5uBwtYAoeqKEXIBJq4RVpZwzNAMK6oOT0O+x+aQVzhv2Ghf8x51fTEW84giFwy4sMxlKA4oICVOS41Umzf484wnpgTfsZ6yrZGiPDcsNfAHzDviqdmZd78Gurt9kiSeny8tNhOOunZGL7pvela/pkOLJPa49puLWSXI8dRQyqGSQWldNjqkLYNhHwJUNm4KRNqzKvnQsuy+ED+iNTUjubXpPaSsHOgYXNha08+mqK11i0CjXpN6cTiIpjpx80HYxri/fv1V6jQXo5FximRTqTY+UMrjg6Pm9lAiU+4Di924EbBzK1pzQLNMbjmKUPPN/Mc1Hm2o5AsB/B3xqfmgFv1/+hI45bJOVsN01q1d+n0eAWNb4qAkDSiUoZYtxUU/zGzScv2sKxEFqkfXQXayuCAbIQgk5y9p1+NXF7kEcHADX3TcI/
 BZY18E0i
 dBmK5wiEUA2olip/7Zt74DPiNesOQg/ou0FNjSdYqJoW+FQpw+oF5AAPazyDu8z6fURKiRm2bvIuKOtnMBtNtQET2QADfKP2NtnP5JFIEzuhcGuzTBofzsIGnhhFskHQVoYmTi0dgW1vMnIT9FlrjIkPYO8gTWRduasel6lpY7jUbf+89FAI5DPnGSa7Ru/kuAQRCCabALGi5bV/ud2+Lm6jtzwrksLdb/SalM/2FxM91CaT1iu7vxQJFJ2QNTd5Uo0bGtFbsunCUooog51+2O3DcWiMW98GpGrCZ8GPAXluzbe67IuOoELZN06/U4RGZahXBmWuicm2vra8kDvE89gO6p8O183g9nmVkz472VgmPBkh4Bp5jzfmqc39v1geej03WF8DSHp+8xguJjsLHMeEgixZjrHRQzPbSKv57dZjK9iVmNahzjnCYlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 11:19, Vlastimil Babka (SUSE) wrote:
> 
> Nit: the subject could be more specific, e.g. like this?
> 
> vmalloc: Optimize vfree with free_pages_bulk()
> 
> On 3/31/26 17:22, Muhammad Usama Anjum wrote:
>> From: Ryan Roberts <ryan.roberts@arm.com>
>>
>> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
>> must immediately split_page() to order-0 so that it remains compatible
>> with users that want to access the underlying struct page.
>> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
>> allocator") recently made it much more likely for vmalloc to allocate
>> high order pages which are subsequently split to order-0.
>>
>> Unfortunately this had the side effect of causing performance
>> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
>> benchmarks). See Closes: tag. This happens because the high order pages
>> must be gotten from the buddy but then because they are split to
>> order-0, when they are freed they are freed to the order-0 pcp.
>> Previously allocation was for order-0 pages so they were recycled from
>> the pcp.
>>
>> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
>> that it also frees that order-3 page to the order-3 pcp, then the
>> regression could be removed.
>>
>> So let's do exactly that; update stats separately first as coalescing is
>> hard to do correctly without complexity. Use free_pages_bulk() which uses
>> the new __free_contig_range() API to batch-free contiguous ranges of pfns.
>> This not only removes the regression, but significantly improves
>> performance of vfree beyond the baseline.
>>
>> A selection of test_vmalloc benchmarks running on arm64 server class
>> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
>> large order pages from buddy allocator") was added in v6.19-rc1 where we
>> see regressions. Then with this change performance is much better. (>0
>> is faster, <0 is slower, (R)/(I) = statistically significant
>> Regression/Improvement):
>>
>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
>> +=================+==========================================================+===================+====================+
>> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
>> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
>> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
>> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
>> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
>> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
>> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
>> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
>> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
>> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
>> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
>> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
>> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
>> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
>> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
>> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
>> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>
>> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
>> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>> +{
>> +	while (nr_pages) {
>> +		unsigned long nr_contig = num_pages_contiguous(page_array, nr_pages);
>> +
>> +		__free_contig_range(page_to_pfn(*page_array), nr_contig);
> 
> I'll note that num_pages_contiguous() already handled crossing the section
> boundaries and __free_contig_range() checks them again. But that's fine I
> think, we don't have to optimize for !SPARSEMEM_VMEMMAP architectures and on
> SPARSEMEM_VMEMMAP the checks should be compiled out, right.

Yes, that was my reasoning.

Note that we could have

(a) Contiguous PFN ranges with a non-contiguous memmap

(b) Contiguous memmap with non-contiguous PFN range


So for an external interface that consumes pfns (free_contig_range()) we
must check (a), for an external interface that consumes pages
(free_pages_bulk()) we must check (b).

As free_pages_bulk() uses the same internal as free_contig_range(), it
will not only check (b), but also (a).

So we cannot just optimize out either but would need a separate function
for free_pages_bulk() to call.

Not worth it :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

