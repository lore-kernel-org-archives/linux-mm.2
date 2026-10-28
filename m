Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 637D4606A327
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=R2HrQyuQ
Received: by kanga.kvack.org (Postfix)
	id 84AA06B05B4; Wed, 28 Oct 2026 05:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FBAB6B05B5; Wed, 28 Oct 2026 05:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738226B05B6; Wed, 28 Oct 2026 05:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D22A6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:15:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C09F11A0166
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:15:35 +0000 (UTC)
X-FDA: 85371477030.17.04CE2AA
Received: from mta1.migadu.com (out-119.mta1.migadu.com [95.215.58.119])
	by imf04.hostedemail.com (Postfix) with ESMTP id 15B9740004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:15:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R2HrQyuQ;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.119 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793178934;
	b=Aa6z0qb6Ets1icHIkb5F4i37OhO0ofwOiIxkeWlmx8qr/mhdlmOWqOFjtqzF/uyp8esxoW
	0lK0cD/S4WitBpNG8/+g20gyeXpTb1elc7FvHdMLNv/XLAmWeMZVSaeznA9DSQ/+nJRWA/
	uPcBVPUU7ZEkIdEb/JrFw8F4BfPe58w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R2HrQyuQ;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.119 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793178934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I1C7i6DuYb7E6K3Eqi0DOqtEEo5Hk8J4ZA/IyWGExvo=;
	b=XeJ0EI0bv5DPTQx90KMMNxLnBsAmjJdbLzKpETT19TUyo4vXCGrget79QUi7p5vHXdDeSL
	b9a9cKMAxO0N3n2qWt7VJBzSSkv9bZ7UdL/NPOxq/TshQTQMRaBNgMU6HGht1zHT6YCdK4
	lDOVjf0hU4ohLn7dSUXqTVIssI2KZFw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m2ZmEY3hXzZpQIXkrfFsWiW7gYoWc6I8jskd+uCIP7Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793178930; v=1; x=1793783730;
 b=R2HrQyuQ7WK4bLDemN35rGYLkaWsSppH5QZp+CBOzVSjNVwt2152QYOWJ1TkBP55tVckQYk4
 tnqm7C5MJ6PUrt3KzsJeM2o1MWdJjLOHpasXLPaQBc9YV9kw5PDECQMyFYhNvJDapPALrvRs3gZ
 8EvTUwFYG6pqfgVxxGVKJUDI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f93630efbef79496;
	Wed, 28 Oct 2026 09:15:19 +0000
X-Mizu-Trace-ID: f93630efbef79496
X-Migadu-Flow: FLOW_OUT
Message-ID: <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev>
Date: Wed, 28 Oct 2026 17:15:11 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
To: Yilei Zheng <trilith.zheng@gmail.com>,
 Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams
 <djbw@kernel.org>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Pankaj Gupta <pankaj.gupta@amd.com>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Ira Weiny <iweiny@kernel.org>,
 Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
 <20261027065723.66564-1-trilith.zheng@gmail.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261027065723.66564-1-trilith.zheng@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 15B9740004
X-Stat-Signature: 8jw457qdo9a9mmxrmxw3chaf585ybbz5
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793178931-574798
X-HE-Meta: U2FsdGVkX18e3yBevQDmuv5c/0imd1oLelsicU+PQ1ARwV1BIgfu4VuZx3Fv2NDTDRv68+T3OhMyh5tTdQ7H0V0p1f9JdFmRE2FBAL8M5BiKklyc+LhecnRuB49AdbGtgfGcAvlCU3fPXOzq2KUSMiLyz2Ff3q6jrkTvJyi34YakDq+pNeGcdj2YV+LA6QYBhv3H6OG4Dk9/BZIFK5H2+1NF7laoHYeP5WsidYtCm8W4HW3/TIuu7jldReZs7mw5LWNOvpIi6+A0i4ZvzJWFWRcLF5nmTXUt6dARVVDm1BjhEVFRzebAUue/HBMfjECmrMCm8WQslgI7pNAAZV595lvzUu1fCW1uzYr3gHFifOg0ozxDefLNNantcZPVQjajbLYNPHpG9eH3XX5Z3vqtwxLMLZSVn9RDsz2A/ivF2szX7KV73ljGO0r+eaVOUnkXTDYty8OgWdzi8SIGnrMCba1O3ZwE8drbVoxk/DX80ziJF9l/ErZ6mGrA84fcguRaH/Lm3T+obGdXpWfGqzPj2q4iPBtgdcInofcmgS/3lHzu/o4yVHLG7vlUfcnzswFpeT3thobvm+vKusv2BhRl7RTvy/ZjHhkC+XVGGBXX5wnMKqZyG+LgWpR565xXvUZLkOyuXn6FVlSTBOZj8XiCk00QXqlGlp1RILiMvQlryeRsqpu1x1iqkCWXn4DgAckv4rNwX78vWJdtilIs3NVl6KzbyEs96XpGLm2TOZ2G+HDK8PRvYAzKkkZdlUFyyVbBaVTl1BGY3mc6+60m7paPaep6r7NVwAAzM1bSlLBaToPWhQBk0+3w+ZZgI4fLGec/ujry6QNIdsMXpEwPZPpjRq3KDoYszQUD3crFizRyENpPJ8ExztRGty3E+qttI9lULVfWGJUMNtbHgWpW9AveIL1dc7VUOyZ6zB8gkVDwo6IWLRz2INNvESuuU6N5uU5EKK/xvKAzvfas8ev0GrC
 ttQoZe9Y
 tBxxWpdbaBMzHw9GuezoQNROkNLA9t95o9G5BtdOda9pXOUYRUxBA0oia2itqRlegOgDVlEBhxpgSJNpnaZK2M9aDuUPT7hCycXeN3oJ3UBbkkXPvss2fy25sBq0o3NuWqbDONKgLLv4Z40CvYCe8roabwmmYkkcG02nWfkf0uemPJQm9B8+A1IRu+AkNX+CvyPd3A1J9QWWm1D+Jc2QSMLyQ/oDq8DI2azmAzoofBrzHXkDeGpFH5mYtYCTrDEI9rqIdIYcTyGItrqfgkE14G+6+DpsieNxUH2GzAv6wyJk7FTgIHPDlRlte2mqTmlvlw4XowdFnlyXJOogmrQ0KwtQ4ERX6mXWFFpDPKoDdn/gv9Q7PCM4z2biOKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/27 14:57, Yilei Zheng wrote:
> Hi Muchun,

Hi,

>
> I have been testing this series for microVMs that mount a read-only
> rootfs over virtio-pmem with FS-DAX. In this setup, most file data is
> accessed through read/write rather than mmap, so most PFNs never need
> private writable metadata. This optimization is very useful for
> reducing guest memory overhead and running more VMs on a host.

Thank you very much for the test, so in your scenario, this is also
the behavior of your real workload (mainly read/write-based, rather
than mmap), right?

>
> While testing, I ran into two issues, both in patch 3, including a
> crash when initializing the shared template page during probe, and the
> 128 MiB alignment check preventing our 2 MiB-aligned rootfs images from
> using the optimization, even though the check can be relaxed without
> changing the registration or teardown paths. I have included a patch
> for both at the end of this email.
>
>
> First, regarding the shared template initialization in
> memmap_init_zone_device():
>
>> @@ -1133,6 +1134,15 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>   	if (!nr_pages)
>>   		return;
>>   
>> +	if (pgmap_vmemmap_optimizable(pgmap)) {
>> +		struct page *page = page_address(pgmap->vmemmap_shared_page);
>> +
>> +		for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
>> +			__init_zone_device_page(page + i, start_pfn + i,
>> +						ZONE_DEVICE, nid, pgmap);
>> +		goto pageblock_init;
>> +	}
> pgmap->vmemmap_shared_page is allocated from normal kernel memory
> (direct map). It is just a template buffer, not a real struct page
> inside the vmemmap space, so passing it to __init_zone_device_page()
> causes page_to_pfn(page) to compute an invalid, out-of-bounds PFN.

Yes, when I first wrote this code, I felt it wasn't very elegant.
But I wanted to share my ideas as early as possible.

>
> I first hit this when backporting the series to a 6.6.117 guest kernel,
> where set_pageblock_migratetype() uses that invalid PFN and crashes
> during device probe.
>
> On your base commit (next-20260902), a normal boot does not crash
> because pageblock init was moved to the end of the function. However,
> set_page_count() still calls page_to_pfn(page) inside the page_ref_set
> tracepoint. Booting with CONFIG_DEBUG_PAGE_REF=y and
> trace_event=page_ref:page_ref_set triggers the same NULL pointer
> dereference during probe:
>
>    BUG: kernel NULL pointer dereference, address: 0000000000000008
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    Call Trace:
>     trace_event_raw_event_page_ref_set+0x4e/0xa0
>     __init_zone_device_page+0x98/0xd0
>     memmap_init_zone_device+0x1c3/0x2e0

Very detailed analysis. I hadn't considered the potential issues
with set_page_count() before.

>
> To fix this, I added init_fsdax_page_template() to initialize the
> template fields (ZONE_DEVICE links, Reserved flag, pgmap, and refcount/
> mapcount via atomic_set()) directly without calling page_to_pfn(). It
> also preserves the WANT_PAGE_VIRTUAL handling from __init_single_page(),
> since patch 1 enables this optimization on LoongArch where KFENCE
> selects WANT_PAGE_VIRTUAL. I only have x86-64 to test on, so please let
> me know if that part looks right to you.

To be fair, it does fix the issue, but it's not very clean.
I might do some code cleanup first to solve this more gracefully.
I want to move the initialization to where the template page is
allocated, similar to what section-based vmemmap optimization
does.

>
>
> Second, regarding the alignment check in
> pgmap_vmemmap_shared_page_alloc():
>
>> The initial implementation is deliberately limited to a single
>> memory-block-aligned range. That is not a fundamental requirement, but keeps
>> the registration and teardown paths simple; support for multiple ranges or
>> less strict alignment can be added later.
> ...
>> +	if (pgmap->nr_range != 1 ||
>> +	    !IS_ALIGNED(range->start | range_len(range), MIN_MEMORY_BLOCK_SIZE))
>> +		return 0;
> After fixing the crash above, the optimization still did not take
> effect for my 130 MiB test rootfs image. Because MIN_MEMORY_BLOCK_SIZE
> is 128 MiB on x86-64, the 130 MiB device failed this check and fell
> back to allocating all 520 vmemmap pages.

Right. It is a deliberate decision in v1. It can be improved.

>
> In our microVM setup, rootfs images are sized to fit the filesystem and
> aligned to 2 MiB rather than 128 MiB. In fact, 2 MiB (SUBSECTION_SIZE)
> is already the native alignment for FS-DAX (via memremap_compat_align())
> and for ZONE_DEVICE vmemmap population and teardown. To keep those paths
> simple, we only need to make sure a shared vmemmap page never crosses a
> pgmap boundary, which 2 MiB alignment already guarantees on 4K-page
> kernels.
>
> So I relaxed the check from MIN_MEMORY_BLOCK_SIZE to SUBSECTION_SIZE.
> I also added an alignment check on (PAGE_SIZE / sizeof(struct page))
> PFNs, so the same boundary guarantee holds on large page kernels,
> where one vmemmap page covers more than 2 MiB of device memory (such
> as 16K/64K pages on LoongArch).
>
>
> With both changes applied on next-20260902 (QEMU x86-64), probing with
> CONFIG_DEBUG_PAGE_REF=y and trace_event=page_ref:page_ref_set works
> cleanly. The 130 MiB test device now uses one shared vmemmap backing
> page instead of 520 private pages, and DAX faults materialize private
> metadata on demand as expected. Mounting two 2 MiB-aligned virtio-pmem
> devices side by side also works properly, and unbinding/rebinding either
> device does not affect the other.
>
> If these changes look good to you, could you fold them into patch 3 for
> v2? (Note that the patch is against v1 and still uses the
> PGMAP_VMEMMAP_OPTIMIZATION flag.)

Thanks for the analysis and suggestions. However, the reason I
haven't sent out v2 yet is that I've been trying to refactor the
vmemmap optimization logic to make FS_DAX support cleaner. I think
I'll probably do some code refactoring first.

>
> I also noticed that next-20261023 has refactored
> memmap_init_zone_device() to use zone_device_page_init_from_template().

Yeah, this is another case that makes page initialization look less
elegant.

> The mm/mm_init.c change will need to be adapted when rebasing the
> series, while the mm/memremap.c change should remain applicable. I am
> happy to help retest v2.

I'cc you next time if you'd like to help me test.

Thanks,
Muchun

>
> Signed-off-by: Yilei Zheng <trilith.zheng@gmail.com>
> ---
>   mm/memremap.c |   10 +++++++++-
>   mm/mm_init.c  |   29 +++++++++++++++++++++++++++--
>   2 files changed, 36 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memremap.c b/mm/memremap.c
> index a53d09b..34d8d89 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -93,8 +93,16 @@ static int pgmap_vmemmap_shared_page_alloc(struct dev_pagemap *pgmap, int nid)
>   	    !(pgmap->flags & PGMAP_VMEMMAP_OPTIMIZATION))
>   		return 0;
>   
> +	/*
> +	 * Subsections can be populated and removed independently, but a
> +	 * shared vmemmap page must never span across different pgmaps
> +	 * (which can exceed a subsection on large-page kernels). Check
> +	 * both boundaries instead of requiring a full memory block.
> +	 */
>   	if (pgmap->nr_range != 1 ||
> -	    !IS_ALIGNED(range->start | range_len(range), MIN_MEMORY_BLOCK_SIZE))
> +	    !IS_ALIGNED(range->start | range_len(range), SUBSECTION_SIZE) ||
> +	    !IS_ALIGNED(PHYS_PFN(range->start | range_len(range)),
> +			PAGE_SIZE / sizeof(struct page)))
>   		return 0;
>   
>   	pgmap->vmemmap_shared_page = alloc_pages_node(nid, GFP_KERNEL, 0);
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 7dd03b8..1c3e269 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1030,6 +1030,31 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>   	}
>   }
>   
> +/*
> + * Initialize struct page slots in the shared backing page. Because this
> + * page is a direct-map template buffer rather than a real vmemmap entry,
> + * set_page_count() must not be used here as its tracepoint calls
> + * page_to_pfn(). Keep the initialized state in sync with
> + * __init_single_page() and __init_zone_device_page().
> + */
> +static void __ref init_fsdax_page_template(struct page *page,
> +					   unsigned long pfn, int nid,
> +					   struct dev_pagemap *pgmap)
> +{
> +	mm_zero_struct_page(page);
> +	set_page_links(page, ZONE_DEVICE, nid, pfn);
> +#ifdef WANT_PAGE_VIRTUAL
> +	if (!is_highmem_idx(ZONE_DEVICE))
> +		set_page_address(page, __va(pfn << PAGE_SHIFT));
> +#endif
> +	atomic_set(&page->_refcount, 0);
> +	atomic_set(&page->_mapcount, -1);
> +	page_cpupid_reset_last(page);
> +	page_kasan_tag_reset(page);
> +	__SetPageReserved(page);
> +	page_folio(page)->pgmap = pgmap;
> +}
> +
>   static void zone_device_page_init_from_template(struct page *page,
>   		unsigned long pfn, struct page *template)
>   {
> @@ -1138,7 +1163,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>   		struct page *page = page_address(pgmap->vmemmap_shared_page);
>   
>   		for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> -			__init_zone_device_page(page + i, start_pfn + i,
> -						ZONE_DEVICE, nid, pgmap);
> +			init_fsdax_page_template(page + i, start_pfn + i,
> +						 nid, pgmap);
>   		goto pageblock_init;
>   	}


