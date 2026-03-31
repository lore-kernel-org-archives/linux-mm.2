Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AFD1FF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42696B00AA; Tue, 31 Mar 2026 06:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF35C6B00AC; Tue, 31 Mar 2026 06:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30656B00AE; Tue, 31 Mar 2026 06:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4A266B00AA
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:08:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 722185C93E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:08:36 +0000 (UTC)
X-FDA: 84605933832.04.C62D9C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 852AC4000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:08:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A0bVWovP;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A0bVWovP;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951714; a=rsa-sha256;
	cv=none;
	b=OL56j0ZMZcjJQpoYrufyUtcuj6+gBGMxR6mNELS1FiEM0e9hXO+jKb3FGSPpvfZyVs4WOP
	SsbIL8e7Jz+daYQv/bXUoDMmoXx+bc52KIiOA8lBDiECa68/BdbISnwdT05eZ2j9gkczwb
	qSGaE0oN3K1suMlJRVeKDboAyasOL4w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1W3YsZz1TGjtPkhA19vIoqTU9/McuMsdlCfnuxnlv0=;
	b=2rlJO+M/RfMlvhcmvyDKLfF2Ycs8LYjaVEt365j14XBg3Ca/Ij4fwW9WusiLwpNArKf0Ub
	yC496cmCUoUY18/bZpwGXGR1YGnTp53Yl3xKANmputBCuCH4JeWXes2fQL5I0xX88RLR0a
	rXSkPq++Cqn0SCzxKNbj/wHJxSIqv5E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F873402B1;
	Tue, 31 Mar 2026 10:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D1FC2BCB0;
	Tue, 31 Mar 2026 10:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951713;
	bh=KeW6+KSmsFuP31VKS323ds73C2gVkWBlh6+eIeZz1zU=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=A0bVWovPflIepW+0gqqv+pevlEcjTX8exWUX7OJtpeXYN7hKcnTOsturfBwnG4Shu
	 4Mo0kgre4iAH5f+RiSzNG4VJEz4zwhwtHq1HrbiY3yqjmptDmOvzxAi7IUWaAOzeHe
	 Qqc093uFr4IySwX2AqS2L5pulK3rwgdCdVjGFmYvj7EmWQaWOuIJAnzPnQz4WK4dhQ
	 39ALj0ACw0v3mv63+3mxf9DhaZ2AFWoTmXiCy+Qcrnk2sfrp57op5guSbjrSKHWqBp
	 9koxfcTi2G1VrrLL1Nxp0OySOl4MyI76HACT9moLK+65VeenrX7/etdpMbKrK67MWk
	 vu4QcRTxwYX2A==
Message-ID: <b73a8340-2e20-44ee-a374-307ff6a5ea30@kernel.org>
Date: Tue, 31 Mar 2026 12:08:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] vmalloc: Optimize vfree
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-3-usama.anjum@arm.com>
 <82e4055c-2343-49ee-b772-d3f4d134f8d0@kernel.org>
 <7eb26b81-ec64-470c-9fd2-52f9b9692b48@arm.com>
From: David Hildenbrand <david@kernel.org>
Content-Language: en-US
In-Reply-To: <7eb26b81-ec64-470c-9fd2-52f9b9692b48@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 852AC4000D
X-Stat-Signature: j963kgrokfckirgtthwkfdgox4i9wk69
X-Rspam-User: 
X-HE-Tag: 1774951714-660558
X-HE-Meta: U2FsdGVkX19qEvIOOBCNzsyurbpmX1Az7eykF2RXrMXuQnhIgQCqMR8N+ugDM+gbP1PDawSV0XPWse9LVXiltwv1sPJ/PR4D3w1KuMLj/zPLX9SOVm5gGfUgNpbxgsrLN++Hf9H8zvTSCPwYGApmw2fhSbv94GtjygcVaESbFjF79hwaJlkQ17DMKGhCIgVIbaON3ANLyh3GFl7G5mpY4lqEoC+T6tfl5Y02kPnekSQ47OxuaQChRl/RUx27j8H2SaVa6av+p4q+MLoSizXvOXSAkc8VnVjaa08PNwcdjHW+6WnTdGAUJJ6ojoc1HcaKNq2vNl6/qjxAqzjEoeaz8TiLzizsvrcElB7jXBX5bSTx4dxD2Bs/PAaS16ZaMAiOk2rGXjIbGaUrm9z+7a38gsDavQmF6OkdIfy8qDKh/z7iPQdSKoLtDrPbkhcPffgBpJpWHqK5yk7VT7CXpaT3I2iuF0gm7M7Pjg3IkrtroyfRQOsGxZj0feOhGVTpZeXq8EseeyoGQFLILVmMnWyFmI/yKBkbTaLL+9bYQBHodbV6P2CT1KEMhOnBAnTDTlA6gQM9XBmrWDh60sEOju7kqrTw18jwfGA7Oh4rAodPgbCrwgY1Qz3B/N+m7Qtbu5k3kym0grZjww1r9yybHQc6yjoOlMzeljZmf1LqC9UUZRor1zqw1jnLOUo8T6xyfEA1iavMaImXuI9Ozw6O2aqxKg0kQ/mqeQLlAwEy5ByjrEzYcDz9McXiCqUrY6JMiNmRrP8PeO23hmyn3UMh2KigPMrKdobV8LM+ZMAadGw7urH7sFrk5UTC5jEFCbNqpb/VIj4gxSBUdUuRZ3sxp8WaIL0b925z3227XfIE41znefOIclatAEjbdiq50KpV20Zb9tfnPkP/UBWXEIgYYKokhtmt5m1rFHyfJ253A8xi41Kbq1322m4W5Awet0T7wYONZ3n52Zde+n/7LbrO/h9
 9k6MkTB4
 oiCar22QbGPwoHlmSoBt1jLDCJX4hlmPUXbwctnY1FDe5qCNWCNJijSGfK0IBBWZYc0wpR44FWKSy7tQarnbFBqlUQzsx1EHJvWHWapaD00q3zMmMOxY1B0liu5bEZzAxjic2R2X7MG7OnPDg4leXEFX8lN4GfPaJSfBxPtXE2UaaLMVlrZtNLYs175nLOjYG6uMeLVCovN4Pc7ar/8OhCRirQXKJtA2j9lOoYHUb78j2h/oaxTMkbQg39+lmQG7XE23PbU5tLEhqpSYkcDJSb9UETa3+KJsi9QgfLJ5+3jFjJazi5usJnuY2NUGBEGkB72xV1M47lw/DfNZw6BwJD4EDUWm2p6Os89jZrxqrFdEe+OVoyzEQQkBgoyNQOf94PEWrxI7ME7BETp5iOtaakVd3HQbWn6zSnZWfryEVunrMJsORcUTajSDq7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 18:15, Muhammad Usama Anjum wrote:
> On 30/03/2026 3:38 pm, David Hildenbrand (Arm) wrote:
>> On 3/27/26 13:57, Muhammad Usama Anjum wrote:
>>> From: Ryan Roberts <ryan.roberts@arm.com>
>>>
>>> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
>>> must immediately split_page() to order-0 so that it remains compatible
>>> with users that want to access the underlying struct page.
>>> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
>>> allocator") recently made it much more likely for vmalloc to allocate
>>> high order pages which are subsequently split to order-0.
>>>
>>> Unfortunately this had the side effect of causing performance
>>> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
>>> benchmarks). See Closes: tag. This happens because the high order pages
>>> must be gotten from the buddy but then because they are split to
>>> order-0, when they are freed they are freed to the order-0 pcp.
>>> Previously allocation was for order-0 pages so they were recycled from
>>> the pcp.
>>>
>>> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
>>> that it also frees that order-3 page to the order-3 pcp, then the
>>> regression could be removed.
>>>
>>> So let's do exactly that; update stats separately first as coalescing is
>>> hard to do correctly without complexity. Use free_pages_bulk() which uses
>>> the new __free_contig_range() API to batch-free contiguous ranges of pfns.
>>> This not only removes the regression, but significantly improves
>>> performance of vfree beyond the baseline.
>>>
>>> A selection of test_vmalloc benchmarks running on arm64 server class
>>> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
>>> large order pages from buddy allocator") was added in v6.19-rc1 where we
>>> see regressions. Then with this change performance is much better. (>0
>>> is faster, <0 is slower, (R)/(I) = statistically significant
>>> Regression/Improvement):
>>>
>>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
>>> +=================+==========================================================+===================+====================+
>>> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
>>> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
>>> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
>>> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
>>> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
>>> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
>>> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
>>> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
>>> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
>>> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
>>> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
>>> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
>>> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
>>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
>>> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
>>> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
>>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
>>> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
>>> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
>>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>>
>>> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
>>> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> ---
>>> Changes since v3:
>>> - Add kerneldoc comment and update description
>>> - Add tag
>>>
>>> Changes since v2:
>>> - Remove BUG_ON in favour of simple implementation as this has never
>>>   been seen to output any bug in the past as well
>>> - Move the free loop to separate function, free_pages_bulk()
>>> - Update stats, lruvec_stat in separate loop
>>>
>>> Changes since v1:
>>> - Rebase on mm-new
>>> - Rerun benchmarks
>>> ---
>>>  include/linux/gfp.h |  2 ++
>>>  mm/page_alloc.c     | 38 ++++++++++++++++++++++++++++++++++++++
>>>  mm/vmalloc.c        | 16 +++++-----------
>>>  3 files changed, 45 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>> index 7c1f9da7c8e56..71f9097ab99a0 100644
>>> --- a/include/linux/gfp.h
>>> +++ b/include/linux/gfp.h
>>> @@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>>  				struct page **page_array);
>>>  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
>>>  
>>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
>>> +
>>>  unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>>>  				unsigned long nr_pages,
>>>  				struct page **page_array);
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 18a96b51aa0be..64be8a9019dca 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -5175,6 +5175,44 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>>  }
>>>  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
>>>  
>>> +/*
>>> + * free_pages_bulk - Free an array of order-0 pages
>>> + * @page_array: Array of pages to free
>>> + * @nr_pages: The number of pages in the array
>>> + *
>>> + * Free the order-0 pages. Adjacent entries whose PFNs form a contiguous
>>> + * run are released with a single __free_contig_range() call.
>>> + *
>>> + * This assumes page_array is sorted in ascending PFN order. Without that,
>>> + * the function still frees all pages, but contiguous runs may not be
>>> + * detected and the freeing pattern can degrade to freeing one page at a
>>> + * time.
>>> + *
>>> + * Context: Sleepable process context only; calls cond_resched()
>>> + */
>>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>>> +{
>>> +	unsigned long start_pfn = 0, pfn;
>>> +	unsigned long i, nr_contig = 0;
>>> +
>>> +	for (i = 0; i < nr_pages; i++) {
>>> +		pfn = page_to_pfn(page_array[i]);
>>> +		if (!nr_contig) {
>>> +			start_pfn = pfn;
>>> +			nr_contig = 1;
>>> +		} else if (start_pfn + nr_contig != pfn) {
>>> +			__free_contig_range(start_pfn, nr_contig);
>>> +			start_pfn = pfn;
>>> +			nr_contig = 1;
>>> +			cond_resched();
>>> +		} else {
>>> +			nr_contig++;
>>> +		}
>>> +	}
>>
>> What happened to the idea of using num_pages_contiguous()? I think that
>> should generate more efficient code (all we're doing is comparing
>> pointers really on SPARSEMEM_VMEMMAP) and the end result looks more
>> readable?
> Sorry, I misunderstood you in the light of duplicate usage of
> num_pages_contiguous(). I'll update the implementation.


A note that it should even speedup SPARSEMEM && !SPARSEMEM_VMEMMAP,
where a page_to_pfn() is expensive and best minimized/avoided :)

-- 
Cheers,

David


