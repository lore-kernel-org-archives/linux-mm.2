Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD78F30275
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017426B039F; Mon, 16 Mar 2026 17:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06816B03A0; Mon, 16 Mar 2026 17:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12D26B03A1; Mon, 16 Mar 2026 17:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D01986B039F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:23:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8304013B4DA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:23:39 +0000 (UTC)
X-FDA: 84553202958.12.7995E5F
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1CB2C80003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:23:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=iqgxQ4TG;
	spf=pass (imf02.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773696217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TaTXamH82wNtPbnE4Y0r1rCak2LNn+wkCcOyc2y+caM=;
	b=FohHaUhigc53NnyF1RMJ4IDfI0orsr8xAzTb+E1u8GPWOR8ytdgwZAmr+zwriu+/rLnINM
	osNrvw987msy4kxVpaWhoM/kTTkYVdYwp9wvSgzmdxwaoyHwh4Ts9aF+v5cLx5GKozeE/N
	rmuXwABBEcOFy6iwCWlA7YCmsU/DGn8=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=iqgxQ4TG;
	spf=pass (imf02.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773696217; a=rsa-sha256;
	cv=pass;
	b=sK1l4Qr7WajhMpHuiXauO+CzVIiVevJywDfI5r8vn2TXi8Vqnjk29Q9cSi205x1QGfzUI0
	cerH8id3O+oV0DySucy5zsRDwIpiONCNyNNdNHajfnIaL2E+fk90Bjo0Gd34rev5Rswehc
	kzT5cnH9KsKwAK0mbH/T3OeBiTo8urU=
ARC-Seal: i=1; a=rsa-sha256; t=1773696194; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=SrTw2t/38uiYFwkg0UaoT0RqLTDbtH6TANLwIR1ENkBqQ95mOMHvvdd2HdkBB5LQ9UsTwSPrJxx4q6rl9Xu3RyHknEGHCHxbuOZ6IR5d0VF8vJHV+1y3ErmZCZKaJ89ycy+lJCYGjxFmbbbdYepNPK8gqL1Ba5F6zGNbBM/JtRs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1773696194; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=TaTXamH82wNtPbnE4Y0r1rCak2LNn+wkCcOyc2y+caM=; 
	b=NCnBOl3KLFCOxLQvs71q8b+rW4+it4dkBgNb+0AkjuBx9Am11tTugQrDKxSudEL0PsjUuoTCVr4GYUlme1y+tv5wcMC6WtJpalkV7mE2KxwN3/Wfjr6FYKC/P5H+rzU2kYi6eoVBJUVhymBpUR5y7+gM0HTSw8DXraYjObsvI2g=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773696194;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=TaTXamH82wNtPbnE4Y0r1rCak2LNn+wkCcOyc2y+caM=;
	b=iqgxQ4TGktB7Jbftl/HERs4e1aJqsDOsHcmRm8tXQ+ehIAo9bA3LMoL4gPkhrarO
	EzcSEagG4tlq7avtukVVD8OHT27cCeu2bgAmrvnNBwf2GfSvn6S/qjLyUd4XO+Ioiuh
	ZkJe9XQlU2aWcDQR5dMWv0+xnqXf43/lK62KJS1U=
Received: by mx.zoho.in with SMTPS id 17736961930961022.9153830214105;
	Tue, 17 Mar 2026 02:53:13 +0530 (IST)
Message-ID: <19a1f1e5-76b4-4c0a-bebc-2eb048ad2fe2@zohomail.in>
Date: Tue, 17 Mar 2026 02:53:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] mm/vmalloc: free unused pages on vrealloc() shrink
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in>
 <20260314-vmalloc-shrink-v4-2-c1e2e0bb5455@zohomail.in>
 <abg6BG0MT6sKy-FT@milan>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <abg6BG0MT6sKy-FT@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 1CB2C80003
X-Rspamd-Server: rspam08
X-Stat-Signature: xnkkm7r8yzjtjd61nt64mwnu9k44fixj
X-HE-Tag: 1773696216-811449
X-HE-Meta: U2FsdGVkX183EndyYAv3ZBO2j8FQ97DgVAJWCXE/p/Jar8CinMlUOs9HyLnIkXtdBZLJpTe6UqX6+aU4AyOQPO5ZapAT9liB4SRmW5wSGSBone4a3U12GzlDpgGPcPV3erTc55LZ8WcV7VgPV/RdGmxPV673wUypcRavSDSDaRWuDXAzktvrNNtjnUO5RTWDJse8q7ZVRNsLqHNPeD3P1jVboXWf0wVA5Q9t9H3LbJ5ebXfYPaQVM0VJ0GFrg/5LZ891gRXVUciLi5PA78Bl9aVz/QmxVWjGv9uUFgaLnIMHpN2tlPwJ7ukpuwJ6fvGSpPA/tCIUJRsXKVIBfoR0CRom8vYOFC/iESz5DgEEQID5FtLkKCz3HM6R9hEfpuf1LNIkMSrXs1/Pn70PruvQ7iWVzpBDVSH4c/IfQAmkCaDvvKfn62fHi4yG86mfaDRvQQM62WUHSb59xc7Hb1cEAXReVGrha3M11MMGcvu0hSVKEd9ovLEJHRt88w0yngJPEpbzrdVMEFSy6Sipcq2yWX/5du1k+Xw0oTmM6PFWbPl2GYMFQqOQjvvYzHb5LhLKTR+CZ5tt1QAljX2CV8qZaWhJzMAjyGaDNqG8VCkNL0R/YdSQ0+w08+6AeVO1cSNkSisvui6yAJxGHU+htStNTDh/EityhpeC/eapMlgzZ0fnzcrjPbW0bAnzFqkbzX/MBEVmRlPwZeP/IC4tNo+bGE3qLb4snMxL5ZFBkf3QvK61nGTHTmY4syOCfYVMuLvaqLekVZJjpfQeqonN2V4tIFHfHvWPXlQH/Nv4RkKdxvxra3QEYiEclpPcR7hQTjRphrYcKxwTY7en/233ddv6uQ51zaLNC3LACS20Tq8YonCcjAnohGYVS7P6/ACIakwEih8gauE3qRxKMP+8oewB1RwBZx6cGrA1SojmSgTg17NDiV+ApI0/rphG3WEhiLiPOuC48a5XROdDkeRdfKC
 9yKX8M2F
 vGXLwsNLmMSAmZpZBY5Wp0XMnd0kih0uCIQVzC38W/BWPc2H0w4bhg8LUgxQkjnYA1Q5MRyILZbB9NGPBM9vJukhteyqdSXRzqVK6HPDihuGY023b0UYzu8BmbTclBpYwO5NShmv/xhC9aqdeVK5R/dwV7qE3DgpdVEqyi8KMA8hWPXQFFwXys2DFtNHSCaZU0ktGQNhtA//M6x0g7JfvEu4Nxcy5kPGhRzno+c4iJwfgQ/qWhl4b+lMBlaD9odtCG60EREfftbVsk+cAkUyrzqIjrP9QbluFzA27weNstBgh+LM2oqNklLL5BlZnbQP0y2v8jdQFlTR5UxzrkKPRVm/jZHU2zK/WLrRcLNQIvQt0DCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/03/26 22:42, Uladzislau Rezki wrote:
> On Sat, Mar 14, 2026 at 02:34:14PM +0530, Shivam Kalra via B4 Relay wrote:
>> From: Shivam Kalra <shivamkalra98@zohomail.in>
>>
>> When vrealloc() shrinks an allocation and the new size crosses a page
>> boundary, unmap and free the tail pages that are no longer needed. This
>> reclaims physical memory that was previously wasted for the lifetime
>> of the allocation.
>>
>> The heuristic is simple: always free when at least one full page becomes
>> unused. Huge page allocations (page_order > 0) are skipped, as partial
>> freeing would require splitting.
>>
>> The virtual address reservation (vm->size / vmap_area) is intentionally
>> kept unchanged, preserving the address for potential future grow-in-place
>> support.
>>
>> Fix the grow-in-place check to compare against vm->nr_pages rather than
>> get_vm_area_size(), since the latter reflects the virtual reservation
>> which does not shrink. Without this fix, a grow after shrink would
>> access freed pages.
>>
>> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
>> ---
>>  mm/vmalloc.c | 19 ++++++++++++++-----
>>  1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index b29bf58c0e3f..2c455f2038f6 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -4345,14 +4345,23 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>>  			goto need_realloc;
>>  	}
>>  
>> -	/*
>> -	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
>> -	 * would be a good heuristic for when to shrink the vm_area?
>> -	 */
>>  	if (size <= old_size) {
>> +		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
>> +
>>  		/* Zero out "freed" memory, potentially for future realloc. */
>>  		if (want_init_on_free() || want_init_on_alloc(flags))
>>  			memset((void *)p + size, 0, old_size - size);
>> +
>> +		/* Free tail pages when shrink crosses a page boundary. */
>> +		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm)) {
>> +			unsigned long addr = (unsigned long)p;
>> +
>> +			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
>> +				     addr + (vm->nr_pages << PAGE_SHIFT));
>> +
>> +			vm_area_free_pages(vm, new_nr_pages, vm->nr_pages);
>> +			vm->nr_pages = new_nr_pages;
>> +		}
>>  		vm->requested_size = size;
>>  		kasan_vrealloc(p, old_size, size);
>>  		return (void *)p;
>> @@ -4361,7 +4370,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>>  	/*
>>  	 * We already have the bytes available in the allocation; use them.
>>  	 */
>> -	if (size <= alloced_size) {
>> +	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
>>  		/*
>>  		 * No need to zero memory here, as unused memory will have
>>  		 * already been zeroed at initial allocation time or during
>>
>> -- 
>> 2.43.0
>>
>>
> Do we perform vm_reset_perms(vm) for tail pages? As i see you update the
> vm->nr_pages when shrinking. Then on vfree() we have:
> 
> <snip>
> /*
>  * Flush the vm mapping and reset the direct map.
>  */
> static void vm_reset_perms(struct vm_struct *area)
> {
> 	unsigned long start = ULONG_MAX, end = 0;
> 	unsigned int page_order = vm_area_page_order(area);
> 	int flush_dmap = 0;
> 	int i;
> 
> 	/*
> 	 * Find the start and end range of the direct mappings to make sure that
> 	 * the vm_unmap_aliases() flush includes the direct map.
> 	 */
> 	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
> ...
> <snip>
> 
> i.e. tail pages go back to the page allocator without resetting permission.
> 
> --
> Uladzslau Rezki
Hi Uladzislau,

Good catch, thank you for spotting this. You are absolutely right-we are
currently returning the tail pages to the page allocator without
resetting their direct-map permissions if VM_FLUSH_RESET_PERMS was set.

While my specific use case doesn't utilize VM_FLUSH_RESET_PERMS,
vrealloc needs to safely handle all vmalloc flags as a generic API.

I will fix this in the next version (v5). I plan to add a helper
function to perform the permission reset specifically for the range of
tail pages being freed during the shrink.

Thanks,
Shivam

