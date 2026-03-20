Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42E75109318B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 08:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B5A6B0367; Fri, 20 Mar 2026 04:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5066B0368; Fri, 20 Mar 2026 04:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745D46B0369; Fri, 20 Mar 2026 04:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FFB66B0367
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:39:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 02DAB1E150
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:39:58 +0000 (UTC)
X-FDA: 84565793718.11.6BB458D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 306E91C0010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:39:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FJxTn6zS;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773995997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGD6JtXT+omz/QMcFcONkstheNgxBjnUPTqaMZc/V/s=;
	b=5A6hovgnvc8LugNth8UyUgfnsg60Ah/3Enf20YSSMyIOntP3YQ+0dU5KYNbloYXwUQr4fY
	nOFCsgkg2l52Xw8TMFDhF+fiVwWgP1mXI9CYU/jW+sSv2rSH311q9WpSjKOpYESPcbKdIC
	+s6aeXtRN1wLyc+SHxigOmd6ohgbdrE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773995997; a=rsa-sha256;
	cv=none;
	b=0t/azcoL5R25XoV69gur7AcNTEoVHnDg8c14lGnOE+uyKj5GalC+KIli1z5TJca5b9dfb1
	EagOgqotbjNApZVtNrAAPeWBp5jbt5WwE5r7rFE2T/RM1Y3HUGDjsBVes3yyMhVKKttLz9
	PQuiveuwwusU2vxThnE0h8ih3tiOLYw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FJxTn6zS;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40D9044296;
	Fri, 20 Mar 2026 08:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6403AC4CEF7;
	Fri, 20 Mar 2026 08:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773995996;
	bh=dpiUkOjr5sqNyRGJepwowr5KdgHmx35gBDJu9PI+O2g=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=FJxTn6zS+2yrWebrDGULdt/62qRH+rE+1KG2DUj7cSrU08NxwcTXH1Yl8nSO55zV6
	 f/wSGxgapmNbAOjstoE4hJ4ptnO7PGfPTXkxFmfmq7g2CvPB92DJLuVUHBn5kF7Q4t
	 z8a1iXLZv0BwTaell+wgvVZeJ1IJTYeC3feBB6zkAWlaOZeogxNagI+Kf1daSeKLzn
	 K6gbFrEF6VSz6sWYfsHmSjJy6TX0Epi0mixvq0gw8QZQomnVLCLNjMw5vEEUa8KAYB
	 fgNg3xZ/x/ENpLz0Uv9oRlIJ1+kmYc86b0DobP/nXzdmuJOHI/DFUM5vdet3oQ5vw6
	 JlgLwPP6PsBzw==
Message-ID: <b7959d34-6e7d-45c2-a674-f32afd057068@kernel.org>
Date: Fri, 20 Mar 2026 09:39:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] vmalloc: Optimize vfree
To: Vlastimil Babka <vbabka@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-3-usama.anjum@arm.com>
 <e59ab258-7331-412c-b490-657e32ec1fe0@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e59ab258-7331-412c-b490-657e32ec1fe0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 306E91C0010
X-Stat-Signature: e3yh8ah1cp6wtqtia4t9wisqge9umd5m
X-Rspam-User: 
X-HE-Tag: 1773995997-42889
X-HE-Meta: U2FsdGVkX19RZvcBh73yfKsHqXrL6d7IUXmJMxqD407XasfZYCqhIlc+y8MM48WFwExmbyexd5vkc89dwQ9XdxrtII9soBJ2gBwS8FAthlbJSpp+NUqRic/kAYpG8vqZsro1Gmf/e1z9N3Ykuz1HOPZs3VMuoECjW/zExxXyiIjik4RxicJONTQieXrJy86hWGIbSBLHLkabuIrg+VyrydY9c6K4HGZ734cfIIZ5ZSo8u+fUfbxzjnEJmjmWSPHguXQo2bhOD3+Ml4SiABoJYyNREeCBwXWAi1HdHallEvqpMKAbYpnMpVYS418qqKpAiIFOodX/tfG7qwuSla9j7saQ4Sj5QsMMNRY8HvBgxIrP9qh2WLw5Xfdl+Xu+rOlCYzb2MEMQAtxKLCmpiV64dMQ7iwcTiVWSS5xPcSpAJ6L1QLGpQ453mrdy3mZbyXvdQhV5EctPWtnayAD/06n/BTnC5O2qA9zi9buMwirgDfN5ZyiBJQGWQJo9D5MStzXo+mDZ7FQPwJ3iZZ+43nsMQS5hHy1bqUanHK4ZYm6ybPlFsnFAPsPqWwX5g8XeqrTE+mDFJ2jkefzjr+LkDa1vPnTDuw2DJT9sIyIgSx6QaNGSm1v9Hv8MGz0M5MiNd1tLtj4mwa9RAs8gEZmd/4hxGqJJt+vpZ7O7Q+RvwhGo0t6vkEB5bwq5VjbWqiQsTmN6Zfe6H/9s/fZMehiDePE64pNDMZhHJAfWxq48LyjatYxw2Q+zytfICCdrePEGzVr+GhNZIPDZxhjXGoZmDObAQgrqX3A45IOnpvFCeYWfaSwY1h+b873lA407IyfrYFM0L830BdGvei8bRemSeM2GdfG7ohE9TXRjzCk6g4GVzH25sSWY5gK+yEvsvRx5xyYFMDgF3qQ++BjGqHKkyqftsGi14FYVcLYPlcbYoV27yB0vJCEZZYBTo8IK4rKYrmcdsYQVQh5KqQ2+tAISVsj
 49nFBH0+
 hrWqMOrzydCnHl0KKsRcQdx3FXbRTzLRj8BB9PWBLm+SebpIMP03U8LaNjWHS9hqHUHBwm4eq/oSQCD1BFgzUTu5kTnj3pDnQ5Mhhj+h5ZkJpDtMQ5HNm7qgvLSnfLolTNkq2web67Yv76GAPqm1ZqMZJ9WQZFSXHPbU8Ime+aQvsBDWif5vHWSO9Agg2LbMfjO4i4Q0a7CbcwiKhDlBgIPugngdteoJXg2waawjszcsxVv/NOrMSVpiiw0ihJXsrko2sdCM4EoGtu/xxDG3SxZLwmpWDH/GgamTALYn4nrT5kFwvfX5+cvwCtSn8VEV9pT+x7rn8Hs+xNFcteb06No4rEv9X7KbV0Kae7LVWTup+sR3+evJJ3dJxWOabpqLr/fwTyGXWcs0Y0DBb/umVsbuaXuy6AZ5CAPyo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 16:49, Vlastimil Babka wrote:
> On 3/16/26 12:31, Muhammad Usama Anjum wrote:
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
>> So let's do exactly that; use the new __free_contig_range() API to
>> batch-free contiguous ranges of pfns. This not only removes the
>> regression, but significantly improves performance of vfree beyond the
>> baseline.
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
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v1:
>> - Rebase on mm-new
>> - Rerun benchmarks
>> ---
>>  mm/vmalloc.c | 34 +++++++++++++++++++++++++---------
>>  1 file changed, 25 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index c607307c657a6..8b935395fb068 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3459,18 +3459,34 @@ void vfree(const void *addr)
>>  
>>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>>  		vm_reset_perms(vm);
>> -	for (i = 0; i < vm->nr_pages; i++) {
>> -		struct page *page = vm->pages[i];
>> +
>> +	if (vm->nr_pages) {
>> +		bool account = !(vm->flags & VM_MAP_PUT_PAGES);
>> +		unsigned long start_pfn, pfn;
>> +		struct page *page = vm->pages[0];
>> +		int nr = 1;
>>  
>>  		BUG_ON(!page);
>> -		/*
>> -		 * High-order allocs for huge vmallocs are split, so
>> -		 * can be freed as an array of order-0 allocations
>> -		 */
>> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
>> +		start_pfn = page_to_pfn(page);
>> +		if (account)
>>  			mod_lruvec_page_state(page, NR_VMALLOC, -1);
>> -		__free_page(page);
>> -		cond_resched();
>> +
>> +		for (i = 1; i < vm->nr_pages; i++) {
>> +			page = vm->pages[i];
>> +			BUG_ON(!page);
> 
> We shouldn't be adding BUG_ON()'s. Rather demote also the pre-existing one
> to VM_WARN_ON_ONCE() and skip gracefully.
> 
>> +			if (account)
>> +				mod_lruvec_page_state(page, NR_VMALLOC, -1);
> 
> I think we should be able to batch this too to use "nr"?

Are we sure that pages cannot cross nodes etc? It could happen that we
have a contig range that spans zones/nodes/etc ...

Anyhow, should we try to decouple both things, providing a
core-mm function to do the page freeing?

We do have something similar, optimized unpinning of large folios,
in unpin_user_pages_dirty_lock(). This here is a bit different.


So what I am thinking about for this code here to do:

	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
		for (i = 0; i < vm->nr_pages; i++)
			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
	}
	free_pages_bulk(vm->pages, vm->nr_pages);


We could optimize the first loop to do batching where possible as well.


free_pages_bulk() would match alloc_pages_bulk()

	void free_pages_bulk(struct page **page_array, unsigned long nr_pages)

Internally we'd do the contig handling.

Was that already discussed?

-- 
Cheers,

David

