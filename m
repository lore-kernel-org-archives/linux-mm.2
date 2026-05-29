Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C29CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379E26B0092; Fri, 29 May 2026 08:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A206B0095; Fri, 29 May 2026 08:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B396B0096; Fri, 29 May 2026 08:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7076B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:19:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB25A163439
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:27 +0000 (UTC)
X-FDA: 84820362774.21.7EA7E25
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id BEE631C000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fsyMd7lc;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780057166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JUtOsCPfuOe2T57OFW29f3zVWa3oduKvxfNw4LBbDU=;
	b=Nu9nfGCKzO9w8tMiI5arQTLEn8/lgFS1rOANoDuAOrQMym0fLnANy+nTzg4uNuQBzb58dm
	yMIvEZXzZ4DtnljaxyP0OpUHdUqpWOsY0042j7aPCOQvslo5jO84apIZ/lip2jrPk3DYne
	7TwgbM51P3wUGoHkBUzbABl/LqZPWmM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780057166; a=rsa-sha256;
	cv=none;
	b=rcjRDKh6qOV02tizis6ejF2Ef4/2PYccCrVSluVaScnA5wY4++AbpvsXXU/iJFn6621CfS
	ibOH7NQw2AxGjXesQxeM7WyThkWVY+TqYsB9x/Whfm4ugDOBISucpPldm2uYeHxeaMaYrS
	o/0hHDi8VsfsGPWoWp/s16FqN/giSBU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fsyMd7lc;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <cc9a1cf7-7b96-439a-b0be-ecdcf27b5da5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780057163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9JUtOsCPfuOe2T57OFW29f3zVWa3oduKvxfNw4LBbDU=;
	b=fsyMd7lc9DQWXIHngNY5FbL4hfa4iXeIt4xrx/a8WeY77abOL0ewWlYq5i/6PQo64jta31
	njPwicrvQwHTWf78VemGoFKHoY5hfsw8kO1Y2PGbihOQfAlDz/yqSGHvh1U/xBAkCMNMhj
	VEkYggS/8GX7N7hbpteEHqhIOIGciSc=
Date: Fri, 29 May 2026 13:19:03 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc,
 jack@suse.cz, Andrew Donnellan <andrew+kernel@donnellan.id.au>,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com,
 kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev,
 "Liam R. Howlett" <liam@infradead.org>,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@pedro-suse.lan,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260528165635.2068012-1-usama.arif@linux.dev>
 <20260528165635.2068012-3-usama.arif@linux.dev>
 <ahlh2vdHEGo6ZSot@pedro-suse.lan>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ahlh2vdHEGo6ZSot@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: BEE631C000A
X-Stat-Signature: d1eipjgmitauf1opz6omapr6f8ybt49b
X-Rspamd-Server: rspam06
X-HE-Tag: 1780057165-885611
X-HE-Meta: U2FsdGVkX187riBClkk3bZsMrGB5Zo+uYYw/wGWQxuOvPEChGDiW04E6HxM4hOG0re1d6/6RUF4EA9VbWLgOiYJMTyTtz2yT2iJITG/3A98OVf0RiPFpCA+x2qBLVSqvMSy7Qm9uHzaSQfwB5Lxlu0Mu3cGv4Almei0k9rc/LtOYSYI0LFshK1rqaejl1j7X9rWmnV8rAfu/9ZbZVBS1nN00VDI95bhyYqeAqdcLA8mfF87s1dsD9pYSqO3eWmxSMDD7QhOs+ktiofhfJrCIY+Uoh2ZCDWFLPEqRiwPwnPVxJ/4P13SrRTnmeoqVN+Z/iQGp8NiiJTFRYUCz4x74QB2z0BO1Y5aqhO92SycCserEsl1p9TQFAmtD8lVENCfOwenTXZdUPGAP3WdvjkE0g8NwOXCAI47DE2pZOKZ5ZsVWpZEa6GAy7PxM/PheG9iZLChD0hozcQtQs6yjVMIjB1FGdJgHCpQTVhxov5TbIc1aJVKcCWJyEsjixHHF6LsXMtXLo/tqBDJ/y6ykzVFUbu18AGUIBJmLlfcPRis1G22AkG2XzHLYPNsMYYXFEuEiH4Db6ikpe29OcZwMtHX01Khd8XUAYAwPI9npc11n8BJLSg9ftNO3pCxk3KJZaylWq9Fyks3lJDDNygCXTiaHklfb0c/IkkRMRKZrMMyNRKnBvNEMOCL06cDDF3R5I3soyncziMhMqwbIDsigUIBtsQrEbioSD1hugHIoNGMnij7d2HePmY5wGNeyLRxB2cL3FbPK2JQM46YjxY3bZTN7hnwoykzrjv5Zzzh0ZnsHhokh+BcuhXr8/mYEUewsP5OyxyV2swwuEdB1ViBWppNnGzY2nG5LA63yOFayYLFmAu+UVv92sQJpii7auBsUTkU/GPcysvw+E5cmA1/aTPjARDwxyO7DK3P4YmzdP4iAyOwZBkcY2//hbGGLFNBI23fpSw3dI7/Dkcfx3ky4rqV
 ZCpOKn4k
 lyOzRl95lRa6+BqOuK6bjLHS9+pdbpHxTWW726SNBlK3iu3AMnrHg53wQgPMUF7pATmvKrMEPU5+8DbsrnFKhgJ1IxIJREEypCYbdh3wHxBEKEP9+6gjyjzrdgPVnv3Gu7vPnw4Kn+348IYgA3OyoRTexVzDt/wW122iU4c04ljlRTkNXI/fn+tqDtjFVUomM9a7/n7dAGWwaeHmzxeCBdMlImneyMj59XRW/q2Hc5VvTkn7p9UnYKeU5MEzwIT6LIqhjlaIc7jwxsasDkhpPEG2KyouPRUSTy2UnoxLtjENO1VV/h7RXPDURsbkcXvue1VCFyMJorG5HnUQuSoCSMK/9sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/05/2026 11:01, Pedro Falcato wrote:
> On Thu, May 28, 2026 at 09:55:20AM -0700, Usama Arif wrote:
>> The force_thp_readahead path in do_sync_mmap_readahead() is gated on
>> HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always requests
>> HPAGE_PMD_ORDER / HPAGE_PMD_NR. On configurations where HPAGE_PMD_ORDER
>> exceeds MAX_PAGECACHE_ORDER, notably arm64 with a 64K base page size,
>> VM_HUGEPAGE mappings cannot use this path and fall back to the non-forced
>> mmap readahead path even when the mapping supports useful large folios.
>>
>> Keep the existing PMD-sized behavior when HPAGE_PMD_ORDER fits in the
>> page cache. When it does not, enable forced readahead for mappings that
>> support large folios and request an order capped by both
>> mapping_max_folio_order(mapping) and 2MB.
>>
>> 2MB is chosen as the cap because it matches the PMD size on x86_64
>> and on arm64 with 4K or 16K base pages, so the size/memory-pressure
> 
> 16K base page size's PMDs should be 32M, no? Am I misunderstanding what
> you mean here?
> 

Yes, should have just said 4K. Messed up when rewriting the commit
message. Andrew Thanks for merging in mm-new, would it be possible
to remove "or 16K" from the commit message. I can send a new revision
as well if that is easier and preferred.

>> tradeoff for folios of that size is already well understood. On arm64
>> with a 64K base page size, 2MB is also the contiguous-PTE (contpte)
>> block size, so the resulting folios coalesce into a single TLB entry
>> and reduce TLB pressure on the readahead path.
>>
>> The final allocation order may still be clamped by page_cache_ra_order()
>> to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
>> on such configurations a large-folio readahead request instead of
>> dropping back to base-page readahead.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/filemap.c | 27 +++++++++++++++++++--------
>>  1 file changed, 19 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index a16b33e0fc71..bfb891d9da1f 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -3312,14 +3312,23 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>>  	struct file *fpin = NULL;
>>  	vm_flags_t vm_flags = vmf->vma->vm_flags;
>>  	bool force_thp_readahead = false;
>> +	unsigned int thp_order = 0;
>>  	unsigned short mmap_miss;
>>  
>>  	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
>>  
>>  	/* Use the readahead code, even if readahead is disabled */
>> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>> -	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
>> -		force_thp_readahead = true;
>> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
>> +		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
>> +			force_thp_readahead = true;
>> +			thp_order = HPAGE_PMD_ORDER;
>> +		} else if (mapping_large_folio_support(mapping)) {
>> +			force_thp_readahead = true;
>> +			thp_order = min_t(unsigned int,
>> +					  mapping_max_folio_order(mapping),
>> +					  get_order(SZ_2M));
> 
> This looks somewhat arbitrary to me (as does the old logic). It seems more
> natural (correct?) to do this:
> 
> 	if (THP_ENABLED && (vm_flags & VM_HUGEPAGE)) {
> 		if (mapping_large_folio_support(mapping)) {
> 			force_thp_readahead = true;
> 			/*
> 			 * Cap THP readahead to either the max folio order the
> 			 * mapping supports, or the max order the page cache
> 			 * supports (useless to try more), or the hugepage PMD
> 			 * order (CPU can't benefit from larger).
> 			 */
> 			thp_order = min3(mapping_max_folio_order(mapping),
> 					MAX_PAGECACHE_ORDER, HPAGE_PMD_ORDER);
> 		}
> 	}
> 

So this can result in extreme memory pressure. For example, on 64K base page size,
with HPAGE_PMD_ORDER = 13 (512M) and MAX_PAGECACHE_ORDER = 11 (128M), this will evaluate
THP order to 128M. I think Jan mentioned in previous versions that there are already
reports of high memory pressure due to large file folios, and we are seeing this
in our fleet as well with xfs.

I chose 2M cap as that is what most (not all) architectures which currently support this
hugepage code flow are currently used to, and on archs + base page size combination which
just evaluate this code to base page, for example 64K base page size, it will provide a
performance uplift without causing excessive memory pressure.

In pagemap.h, we have

#define PREFERRED_MAX_PAGECACHE_ORDER	HPAGE_PMD_ORDER
#define MAX_PAGECACHE_ORDER	min(MAX_XAS_ORDER, PREFERRED_MAX_PAGECACHE_ORDER)

So MAX_PAGECACHE_ORDER <= HPAGE_PMD_ORDER is always true.

At filesystem/inode setup: mapping_set_folio_order_range() 

	if (max > MAX_PAGECACHE_ORDER)
		max = MAX_PAGECACHE_ORDER;

so mapping_max_folio_order() <= MAX_PAGECACHE_ORDER is also always true.

which means mapping_max_folio_order(mapping) <= MAX_PAGECACHE_ORDER <= HPAGE_PMD_ORDER is always
true, and you dont need the min3(..) in your diff.

Now the question is if then why not just do:

	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
		if (mapping_large_folio_support(mapping)) {
			force_thp_readahead = true;
			thp_order = min_t(unsigned int,
					  mapping_max_folio_order(mapping),
					  get_order(SZ_2M));
		}
	}


This is because this will regress the 16K ARM case where we already got 32M
folios. Someone might upgrade the kernel and start getting 2M folios now.

So IMHO the current code is correct, both in maintaining what the
existing behaviour has been, but also trying to provide large folios to
architectures that currently dont get them but in a controlled way.

Later on, when we think or evaluate that 2M was too small a cap, it can
be raised. I think its very easy to raise a cap, but much more difficult
to make the cap smaller, as we might get reports on kernel upgrades that
someone was getting a certain size of folio but now its much smaller.

As a summary, what my code in this current form gives is:
1) 4K x86/ARM (HPAGE_PMD_ORDER=9 <= 9): first branch -> 2M unchanged behaviour
2) 16K ARM (HPAGE_PMD_ORDER=11 <= 11): first branch -> 32M unchanged behaviour
3) 64K ARM (HPAGE_PMD_ORDER=13 <= 11): new else-if -> 2M new capability, conservative
behaviour, which can be increased later if needed.
I know that 64K base page size having 2M large folios while 16K base page size
having 32M sounds counterintuitive, but I think 32M on 16K was a mistake and
we shouldnt repeat that mistake for 64K.

What your change with min3(mapping_max_folio_order(mapping), MAX_PAGECACHE_ORDER, HPAGE_PMD_ORDER)
will give
3) 64K ARM -> 128M folios, extremely high memory pressure.

What only having min(mapping_max_folio_order, get_order(SZ_2M)) will give:
2) 16K ARM -> 2M folios, (regression since we always had 32M on 16K ARM).



>> +		}
>> +	}
>>  
>>  	if (!force_thp_readahead) {
>>  		/*
>> @@ -3354,17 +3363,19 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>>  	}
>>  
>>  	if (force_thp_readahead) {
>> +		unsigned long folio_nr_pages = 1UL << thp_order;
>> +
>>  		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
>> -		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
>> -		ra->size = HPAGE_PMD_NR;
>> +		ractl._index &= ~(folio_nr_pages - 1);
>> +		ra->size = folio_nr_pages;
>>  		/*
>> -		 * Fetch two PMD folios, so we get the chance to actually
>> +		 * Fetch two folios so we get the chance to actually
> 			  ^^ large folios?
>>  		 * readahead, unless we've been told not to.
>>  		 */
>>  		if (!(vm_flags & VM_RAND_READ))
>>  			ra->size *= 2;
>> -		ra->async_size = HPAGE_PMD_NR;
>> -		ra->order = HPAGE_PMD_ORDER;
>> +		ra->async_size = folio_nr_pages;
>> +		ra->order = thp_order;
> 
> This part LGTM.
> 


