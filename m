Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D914F34C43
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 11:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D026B008A; Mon, 13 Apr 2026 07:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8A96B0092; Mon, 13 Apr 2026 07:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5325C6B0093; Mon, 13 Apr 2026 07:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 449A06B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:48:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB69B878BB
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:48:58 +0000 (UTC)
X-FDA: 84653361156.11.DE22FBD
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id D3B461C0005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:48:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uNsNyeBw;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776080937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IjyGsFE0RAc+jCgnm01ouXsvsI/sEbPMxALfKo5KqA=;
	b=si6I3gBFokUuWe30Z7ycEffTCE+zfFL8c3WZC2xFlr83DahrWZdcZv4qe4IJC/v4xP63XE
	h8sRd7bDEVt5N9o1TcxNg4wctmPj6LG9cOImmCopPS5CafGLctNwk6tT3G62fJ9hXPa57F
	xTR5VKJ9Wc9WCp3pVKmRPFGuOQFUGh8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uNsNyeBw;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776080937; a=rsa-sha256;
	cv=none;
	b=ag1FZfWPbkSrPAJwfP+2v/8KQtcK5Y/rtOI+SVN03KT5gYfHFigyFWMnuXTsj/3LQm/gp5
	l7j3ua5dMOFAM2IG2PxM2wGPMffvsC9tcKHn+9IHARlY98hI5sP2r0zYpl8aJHo0qV5Gs5
	uGPlr0sZKLg0D0T7io4sr0S2sSzUaFA=
Message-ID: <a598cd04-9db6-43bf-a3d5-9320bdf395bd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776080934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4IjyGsFE0RAc+jCgnm01ouXsvsI/sEbPMxALfKo5KqA=;
	b=uNsNyeBwjHPn6FGcHCAZ0gkvp9Rf069Jfz4KJaa1ShSN3nv64PsSgYgIJx+mLck2JyaZ7B
	MAnIwjK2Ll9hNcQ/2scX+lSDzwcjnW3/I3ypkn5N0btau4+Yxsd+IHFbQzENNKzjkapYMI
	oyZa1Dsf9k0v5bGaLhFv4bO5NHcIOVY=
Date: Mon, 13 Apr 2026 12:48:42 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/4] mm: use tiered folio allocation for VM_EXEC
 readahead
Content-Language: en-GB
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org,
	r@hev.cc, ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@quack3.kvack.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	leitao@debian.org, kernel-team@meta.com
References: <20260402181326.3107102-1-usama.arif@linux.dev>
 <20260402181326.3107102-3-usama.arif@linux.dev>
 <aji7zs42th272khtxesk6dfcrgf7ddr5r5n62wgzeqooyexgxf@5ns3i47f5nlg>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <aji7zs42th272khtxesk6dfcrgf7ddr5r5n62wgzeqooyexgxf@5ns3i47f5nlg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: D3B461C0005
X-Stat-Signature: 6xhs6er83sgsrzaq333xejoi3ky6hwkk
X-Rspamd-Server: rspam06
X-HE-Tag: 1776080936-857303
X-HE-Meta: U2FsdGVkX1+E2PVeEM+02MHaFszSn9O0uhiYFqfSGEccoSfONqAIKjEfxuWF8/+9gStZyXyP7nWiaR0zhtoo70SCSwH9+Bws58d+O5Z6gBoGQJFo4Irh7TFewhR8C7Jf5vhZBw2h9xjtZLBwIkpHs9jTxp+2ckx0yoQxjxIF2hxpcWbc/stWZtrvafjzsO31hYzgs3FVyvNxTkI1HSYW/+0kgi6mR1Ml7+xKk8NMUQGE3EObOksBGfgdvMVzU+6a6q35vtdbj8IN9LdA7l7s3cyVrSOhDrc65stCpqcgJHcdUIukTTKwuGVeHj0UaArVAvVn5VDaqlieibRK6OeZp6EpfQHMuNw7aP+ISdb3fluMMFm3ty9e8UnxbAGZR5S3nFfcw5kGafuelxWNvFI8p9f7DQsQ9DUfHtvyvMIWZwIF5q/ZH7GJVDonB/IL3tl+V+TNWuM0v0pHHAyVtEuWsJrT65jRT4AcaIE4h49sW+1QwK7lF5HfEJd10vfdtrGBrQAGmzZVlmGzOHPVf+4HRxbuHCdMRbW3EMhEUs1f5r2vcGmFxnm5r8e0dzjki7YWqKa7wTBJGyDmzKQ0w1EWFT2uNe6mLMK0hLf1PIFytJ7aGBJJAhYlJsJsQ8lgXu3RVdKsw9oPVDCbL8eEZWlRGkKLzjpxTFVUj4HHoHcJThzG8F6xCCoGZAJ96fuqthklJruR9Z/gCAOqWTX8Hs3yo1PEGzpZzMy0OGpGkT/Zhysb0SxTMKm5W2QixsczgMXzQ5uksZLCyBcjl6BS0/rtOZfT9J7jp1Tz8SudkpxvmUNtP99DLAmOVUcqCmm14LGrIsvLJK30dpf+GWxr5G6GGLxvC64K4fZ6CDoDOtrtPQ5EnJ7IofNS8gBflcuQdpLieuCgLFMOn71tm9ZdNGgOcqSWoqCu5IDhENiA3Tq3x9brNUGTZeQuOcFLTtiuDu5sTAjDDtu5uYaAy23XXWy
 AgBJYlKk
 VogCZ7h14YAXddQGrBfDcaPJmqt3ptWR49dJavCeFlnQUrZeLkQUq/rWFpkWR6Oi2JS2AkLlRGhBMNc755fToXlIRvW+CjNaeR+jWHqddiF9JlSWmRD645GWvDWe6G214uKui+YUFjUfJLp5FPMRrXpsUP+NVZUK3IpBpan8pldsk+lanoOPcASLd63aA1Xs5SYSNN2+I94UaRU/KZJJg193QmW1kzHnaJ/Uar9B81tjNp/gO6ATfYdaWbG6zCR+Zy60sSS0iMn+aoBXvjQLzFB2/doGf9FLG7Q2UBbspHLMkwUZFY8vigN4KcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/04/2026 12:03, Jan Kara wrote:
> On Thu 02-04-26 11:08:23, Usama Arif wrote:
>> When executable pages are faulted via do_sync_mmap_readahead(), request
>> a folio order that enables the best hardware TLB coalescing available:
>>
>> - If the VMA is large enough to contain a full PMD, request
>>   HPAGE_PMD_ORDER so the folio can be PMD-mapped. This benefits
>>   architectures where PMD_SIZE is reasonable (e.g. 2M on x86-64
>>   and arm64 with 4K pages). VM_EXEC VMAs are very unlikely to be
>>   large enough for 512M pages on ARM to take into affect.
> 
> I'm not sure relying on PMD_SIZE will be too much for a VMA is a great
> strategy. With 16k PAGE_SIZE the PMD would be 32MB large which would fit in
> the .text size but already looks a bit too much? Mapping with PMD sized
> folios brings some benefits but at the same time it costs because now parts
> of VMA that would be never paged in are pulled into memory and also LRU
> tracking now happens with this very large granularity making it fairly
> inefficient (big folios have much higher chances of getting accessed
> similarly often making LRU order mostly random). We are already getting
> reports of people with small machines (phones etc.) where the memory
> overhead of large folios (in the page cache) is simply too much. So I'd
> have a bigger peace of mind if we capped folio size at 2MB for now until we
> come with a more sophisticated heuristic of picking sensible folio order
> given the machine size. Now I'm not really an MM person so my feeling here
> may be just wrong but I wanted to voice this concern from what I can see...
> 
> 								Honza
> 
> 

Thanks for the feedback! I agree, it makes sense. I did that in the previous
revision [1]. I will reinistante that in the next one.

[1] https://lore.kernel.org/all/20260320140315.979307-3-usama.arif@linux.dev/

>> - Otherwise, fall back to exec_folio_order(), which returns the
>>   minimum order for hardware PTE coalescing for arm64:
>>   - arm64 4K:  order 4 (64K) for contpte (16 PTEs → 1 iTLB entry)
>>   - arm64 16K: order 2 (64K) for HPA (4 pages → 1 TLB entry)
>>   - arm64 64K: order 5 (2M) for contpte (32 PTEs → 1 iTLB entry)
>>   - generic:   order 0 (no coalescing)
>>
>> Update the arm64 exec_folio_order() to return ilog2(SZ_2M >>
>> PAGE_SHIFT) on 64K page configurations, where the previous SZ_64K
>> value collapsed to order 0 (a single page) and provided no coalescing
>> benefit.
>>
>> Use ~__GFP_RECLAIM so the allocation is opportunistic: if a large
>> folio is readily available, use it, otherwise fall back to smaller
>> folios without stalling on reclaim or compaction. The existing fallback
>> in page_cache_ra_order() handles this naturally.
>>
>> The readahead window is already clamped to the VMA boundaries, so
>> ra->size naturally caps the folio order via ilog2(ra->size) in
>> page_cache_ra_order().
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  arch/arm64/include/asm/pgtable.h | 16 +++++++++----
>>  mm/filemap.c                     | 40 +++++++++++++++++++++++---------
>>  mm/internal.h                    |  3 ++-
>>  mm/readahead.c                   |  7 +++---
>>  4 files changed, 45 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 52bafe79c10a..9ce9f73a6f35 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1591,12 +1591,18 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
>>  #define arch_wants_old_prefaulted_pte	cpu_has_hw_af
>>  
>>  /*
>> - * Request exec memory is read into pagecache in at least 64K folios. This size
>> - * can be contpte-mapped when 4K base pages are in use (16 pages into 1 iTLB
>> - * entry), and HPA can coalesce it (4 pages into 1 TLB entry) when 16K base
>> - * pages are in use.
>> + * Request exec memory is read into pagecache in folios large enough for
>> + * hardware TLB coalescing. On 4K and 16K page configs this is 64K, which
>> + * enables contpte mapping (16 × 4K) and HPA coalescing (4 × 16K). On
>> + * 64K page configs, contpte requires 2M (32 × 64K).
>>   */
>> -#define exec_folio_order() ilog2(SZ_64K >> PAGE_SHIFT)
>> +#define exec_folio_order exec_folio_order
>> +static inline unsigned int exec_folio_order(void)
>> +{
>> +	if (PAGE_SIZE == SZ_64K)
>> +		return ilog2(SZ_2M >> PAGE_SHIFT);
>> +	return ilog2(SZ_64K >> PAGE_SHIFT);
>> +}
>>  
>>  static inline bool pud_sect_supported(void)
>>  {
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index a4ea869b2ca1..7ffea986b3b4 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -3311,6 +3311,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>>  	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
>>  	struct file *fpin = NULL;
>>  	vm_flags_t vm_flags = vmf->vma->vm_flags;
>> +	gfp_t gfp = readahead_gfp_mask(mapping);
>>  	bool force_thp_readahead = false;
>>  	unsigned short mmap_miss;
>>  
>> @@ -3363,28 +3364,45 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>>  			ra->size *= 2;
>>  		ra->async_size = HPAGE_PMD_NR;
>>  		ra->order = HPAGE_PMD_ORDER;
>> -		page_cache_ra_order(&ractl, ra);
>> +		page_cache_ra_order(&ractl, ra, gfp);
>>  		return fpin;
>>  	}
>>  
>>  	if (vm_flags & VM_EXEC) {
>>  		/*
>> -		 * Allow arch to request a preferred minimum folio order for
>> -		 * executable memory. This can often be beneficial to
>> -		 * performance if (e.g.) arm64 can contpte-map the folio.
>> -		 * Executable memory rarely benefits from readahead, due to its
>> -		 * random access nature, so set async_size to 0.
>> +		 * Request large folios for executable memory to enable
>> +		 * hardware PTE coalescing and PMD mappings:
>>  		 *
>> -		 * Limit to the boundaries of the VMA to avoid reading in any
>> -		 * pad that might exist between sections, which would be a waste
>> -		 * of memory.
>> +		 *  - If the VMA is large enough for a PMD, request
>> +		 *    HPAGE_PMD_ORDER so the folio can be PMD-mapped.
>> +		 *  - Otherwise, use exec_folio_order() which returns
>> +		 *    the minimum order for hardware TLB coalescing
>> +		 *    (e.g. arm64 contpte/HPA).
>> +		 *
>> +		 * Use ~__GFP_RECLAIM so large folio allocation is
>> +		 * opportunistic — if memory isn't readily available,
>> +		 * fall back to smaller folios rather than stalling on
>> +		 * reclaim or compaction.
>> +		 *
>> +		 * Executable memory rarely benefits from speculative
>> +		 * readahead due to its random access nature, so set
>> +		 * async_size to 0.
>> +		 *
>> +		 * Limit to the boundaries of the VMA to avoid reading
>> +		 * in any pad that might exist between sections, which
>> +		 * would be a waste of memory.
>>  		 */
>> +		gfp &= ~__GFP_RECLAIM;
>>  		struct vm_area_struct *vma = vmf->vma;
>>  		unsigned long start = vma->vm_pgoff;
>>  		unsigned long end = start + vma_pages(vma);
>>  		unsigned long ra_end;
>>  
>> -		ra->order = exec_folio_order();
>> +		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>> +		    vma_pages(vma) >= HPAGE_PMD_NR)
>> +			ra->order = HPAGE_PMD_ORDER;
>> +		else
>> +			ra->order = exec_folio_order();
>>  		ra->start = round_down(vmf->pgoff, 1UL << ra->order);
>>  		ra->start = max(ra->start, start);
>>  		ra_end = round_up(ra->start + ra->ra_pages, 1UL << ra->order);
>> @@ -3403,7 +3421,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>>  
>>  	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
>>  	ractl._index = ra->start;
>> -	page_cache_ra_order(&ractl, ra);
>> +	page_cache_ra_order(&ractl, ra, gfp);
>>  	return fpin;
>>  }
>>  
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 475bd281a10d..e624cb619057 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -545,7 +545,8 @@ int zap_vma_for_reaping(struct vm_area_struct *vma);
>>  int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
>>  			   gfp_t gfp);
>>  
>> -void page_cache_ra_order(struct readahead_control *, struct file_ra_state *);
>> +void page_cache_ra_order(struct readahead_control *, struct file_ra_state *,
>> +			 gfp_t gfp);
>>  void force_page_cache_ra(struct readahead_control *, unsigned long nr);
>>  static inline void force_page_cache_readahead(struct address_space *mapping,
>>  		struct file *file, pgoff_t index, unsigned long nr_to_read)
>> diff --git a/mm/readahead.c b/mm/readahead.c
>> index 7b05082c89ea..b3dc08cf180c 100644
>> --- a/mm/readahead.c
>> +++ b/mm/readahead.c
>> @@ -465,7 +465,7 @@ static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
>>  }
>>  
>>  void page_cache_ra_order(struct readahead_control *ractl,
>> -		struct file_ra_state *ra)
>> +		struct file_ra_state *ra, gfp_t gfp)
>>  {
>>  	struct address_space *mapping = ractl->mapping;
>>  	pgoff_t start = readahead_index(ractl);
>> @@ -475,7 +475,6 @@ void page_cache_ra_order(struct readahead_control *ractl,
>>  	pgoff_t mark = index + ra->size - ra->async_size;
>>  	unsigned int nofs;
>>  	int err = 0;
>> -	gfp_t gfp = readahead_gfp_mask(mapping);
>>  	unsigned int new_order = ra->order;
>>  
>>  	trace_page_cache_ra_order(mapping->host, start, ra);
>> @@ -626,7 +625,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
>>  readit:
>>  	ra->order = 0;
>>  	ractl->_index = ra->start;
>> -	page_cache_ra_order(ractl, ra);
>> +	page_cache_ra_order(ractl, ra, readahead_gfp_mask(ractl->mapping));
>>  }
>>  EXPORT_SYMBOL_GPL(page_cache_sync_ra);
>>  
>> @@ -697,7 +696,7 @@ void page_cache_async_ra(struct readahead_control *ractl,
>>  		ra->size -= end - aligned_end;
>>  	ra->async_size = ra->size;
>>  	ractl->_index = ra->start;
>> -	page_cache_ra_order(ractl, ra);
>> +	page_cache_ra_order(ractl, ra, readahead_gfp_mask(ractl->mapping));
>>  }
>>  EXPORT_SYMBOL_GPL(page_cache_async_ra);
>>  
>> -- 
>> 2.52.0
>>


