Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D66C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 15:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3EDA6B0099; Sat, 25 Jul 2026 11:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17146B009B; Sat, 25 Jul 2026 11:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F086B009D; Sat, 25 Jul 2026 11:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A49216B0099
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:56:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2477EA0370
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:56:15 +0000 (UTC)
X-FDA: 85027750710.14.1E5B26C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A5B8120007
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:56:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kr4+GvU9;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784994973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fI8EblvjWzjGCZk7JcnyrfLB78roRKFER5ZnFfas16U=;
	b=rhz56I6E3FBz8TOkoLrmps3DfUWx0QHjuAiTK3m6lzwJWq8LU8YdCSf6Nxp6zwtrsCkLpK
	4m4rNPyYumXdcpRRsltoODKqt6fYo30wohOl8mwaK/q+/Fe2LTTMSZL6Sd32vjx1BZ6+t9
	e3geVT+AJSkuvWxOMchFI20E0yPCdR4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kr4+GvU9;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784994973;
	b=WNZzvIDf7VL0ubOg0tGd2kjWs8zW5ivKKTk+G3W+Q0UH45dWvrwtteCrvPahDo7uVvveUI
	055yUqwbmsvQqtzMFHwxMaL9+zkjGI8d6C/rTfqv+qWf/ER3SjXfGjcdN9dRkBEGRMDmXH
	sZnAEUYh9bpoOAhdLkiBXFX4Q/jNi1o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57739413C5;
	Sat, 25 Jul 2026 15:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDF01F000E9;
	Sat, 25 Jul 2026 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784994972;
	bh=fI8EblvjWzjGCZk7JcnyrfLB78roRKFER5ZnFfas16U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kr4+GvU9/gKyPFM6yyLN+aKhTi7LD5HoR5e8OS2lwtoltA0FEPaMWfd5J4bKjkClc
	 IphZ1GcZ9QAt60rtotgq75gmGmCcTnKeHrz9aF+P5LLZgk4R8OZXMPGxunOyZd81Zt
	 UGUAZ5kORt54bbc8Jhr+kbJnMh1ENd0Ii6WCgkfiE7b/+EZy6qjKQ94YQh4BISGbBx
	 VR/nBed0i/FrUTEMDe/f5sYx+H0/n/NACV4olQaJQ62cFlx5a9lNzHqJYxmW4+wukk
	 q+mE7hgf1Xj0RajHCrKvMWgbGSyMD4vHzE99kKTR/S6I7rZyLFU/CQ6p4HcqEStaNE
	 +wpjJZZt/qsig==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,  Jork
 Loeser <jloeser@linux.microsoft.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 17/21] mm/mm_init: don't rely on memblock to get KHO
 scratch migratetype
In-Reply-To: <178410811939.820181.7932476003120213021.b4-review@b4> (Mike
	Rapoport's message of "Wed, 15 Jul 2026 12:35:19 +0300")
References: <20260709173821.429921-1-pratyush@kernel.org>
	<20260709173821.429921-18-pratyush@kernel.org>
	<178410811939.820181.7932476003120213021.b4-review@b4>
Date: Sat, 25 Jul 2026 17:56:08 +0200
Message-ID: <2vxzfr17gj1j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A5B8120007
X-Rspamd-Server: rspam01
X-Stat-Signature: sbmrmtifbcbxbhx8mkmiykyked5mzx3e
X-HE-Tag: 1784994973-965850
X-HE-Meta: U2FsdGVkX19oIi7QSv2rBW+EM5YWXdZ9gW/DZJd5YTwl31gXgW0YB6lBh585odcqDgX5p7LBRpCL2oiZ8TIAyQV4ti+TKOMGQ5owfwgHUvsvmnqf33Y3mwI0J8EnFQwICkBoqRdXDQn2Rca4XBiOxoGLBAwcjmLM6wI8YuIvaqsq3CFUcULq2w2ChIt5Hnc5LKUscqoLi8wW2WlV4XXI8QXt1lygeCqCE6uSucL3hSWFwnZsmsq2fL4bze01gcgiUn3pQKokBI0SG4d5Oi+6KnvFqbWRdL2tRYXW/OPsSpUXiTHlJY4lGx65lcYemcuWXXy8Hbw26jg2B+viNr80vCk7J2xgfEZFdB7bgyoxhwJQ9IWCS3oiHHsVAkQEgX97v7vl8D+A0umEy9QJCwpfA5IQswd8UFPEMcGQJhQF0LAFcgPUAklgOgUJEbgINHVpz7bb1rgD9DR2lgll+zr/r9upSVa7ai3s5DEBWzOX/stKkOpfA9NGmQu/rlvrqyC8+8fNH/XSPYwtO5/JobOPwkNFK7w2rZ2iE/0s3wcK9uIctTRPKjCVcG1q/2tMqDXk+0bHFPq1oPMxO1C5pXAU4w4tQudV+z+I35ZXIiKaZSJthFFmEswi46mlSGZhLhgFEMmigzLt9FRS0YtywjyyXLEQVVcmZNhoYdng5XNg1jImzHc4G/g/FOQAaPXX8sm4P570bMaEGTfMiLkS0QnYCDkb3DOlPPNA+bzU8RtfK02UcPXnPUNWIhTEBAvsBB8EKrJzMMh/WCzV5+vNNSf/hCnhaqYERnYP+rEijpshV96yU4LwvGfxu2Wd7eeJCpzRM5XYUzq2E1UDq3I+uHcFxjV7T6+T7Di7LJjY8FOGWz9vFBvETRKFPIff3PEH8McYLwHR8HQf0ghj75Dxp38FKuc4CWQtbvr+niBIAAqM2fjiIFNLQLUGzD0N5Z5MQ/a9dxyxXTL3Q8K53beMohO
 1V/06kk+
 vmXHkDD3QBlp+0XiqVnnPdHzfapmERIKma7DcEJeCp22vFXplZfqos4drctKWoV8qM0ta9PfalogfUwfqpYBXyK2bswjHjJwZZFWpF/OpbG8qVjbh0oJEhbc8wzKawwmu2B5Mr7Av7l7rK9MpjKvgUbaruVH2v76W4nzgFk0Lvqat9nfBs8HEmWIPsnf2/idaZgRNEW6al+OFPkdVzhmukRVa6JME58fkmZm0hWg9W39gtYwkURLyPlFeYc0kV+wM222Eh4WCstbGzYsttnNRxKxoO2+it/B4hnM2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15 2026, Mike Rapoport wrote:

>> Currently struct page init via memmap_init() or deferred_init_memmap()
>> only queries the migrate type from KHO for each discrete memory range.
>> That works currently since KHO scratch memory has a different memory
>> type so it is always it its own region.
>> 
>> An upcoming patch will add support for discovering blocks of memory with
>> no preservations and it will mark it as MEMBLOCK_KHO_SCRATCH to allow
>> allocations from them. This can lead to the bootmem KHO scratch areas to
>> be merged into larger free ranges. This merging breaks the selection of
>> migrate type.
>> 
>> Get rid of kho_scratch_migratetype(). Instead, let the struct page init
>> logic set the migratetype to MIGRATE_MOVABLE for all pages, and then
>> give KHO a chance to update the migrate type of its bootmem scratch
>> areas to MIGRATE_CMA. Since scratch areas should be a few order of
>> magnitues smaller than the total system memory, doing it this way is
>> more efficient than searching the kho_scratch array for every pageblock.
>
> It's true for non-deferred case, but with deferred initialization of
> struct pages the static part is small and deferred chunks are small, so
> we are going to update the migratetype nearly as much as we would check
> it with kho_scratch_migratetype().
>
> For simplicity of this patchset I'd keep kho_scratch_migratetype(), just
> move it over to kexec_handover.h and make it rely on kho_scratch_overlap().
>
> The bulk optimization can be a separate patch on top.

Sure, will do.

>
>> Since kho_scratch_migratetype() no longer exists, drop the migratetype
>> argument to memmap_init_zone_range() and deferred_init_pages().
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>>
[...]
>> +/*
>> + * Mark all KHO scratch pageblocks between start_pfn and end_pfn as
>> + * MIGRATE_CMA.
>> + */
>> +void kho_init_scratch_migratetype(unsigned long start_pfn, unsigned long end_pfn)
>> +{
>> +	for (unsigned int i = 0; i < kho_scratch_cnt; i++) {
>> +		unsigned long scratch_start, scratch_end, pfn;
>> +
>> +		scratch_start = PHYS_PFN(kho_scratch[i].addr);
>> +		scratch_end = PHYS_PFN(kho_scratch[i].addr + kho_scratch[i].size);
>> +
>> +		/* Target range doesn't overlap with scratch. */
>> +		if (start_pfn >= scratch_end || end_pfn <= scratch_start)
>> +			continue;
>> +
>> +		pfn = max_t(unsigned long, start_pfn, scratch_start);
>> +		pfn = pageblock_start_pfn(pfn);
>> +
>> +		while (pfn < end_pfn && pfn < scratch_end) {
>> +			init_pageblock_migratetype(pfn_to_page(pfn),
>> +						   MIGRATE_CMA, false);
>> +			pfn += pageblock_nr_pages;
>> +		}
>> +	}
>> +}
>
> static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
> 						       enum migratetype mt)
> {
> 	if (kho_scratch_overlap(PFN_PHYS(pfn)), PAGE_SIZE)
> 		return MIGRATE_CMA;
> 	return mt;
> }
>
> Is way easier to parse and reason about ;-)
>
>> +
>>  /**
>>   * kho_reserve_scratch - Reserve a contiguous chunk of memory for kexec
>>   *
[...]
>> @@ -2012,8 +2021,7 @@ static inline void __init pgdat_init_report_one_done(void)
>>   * Return number of pages initialized.
>>   */
>>  static unsigned long __init deferred_init_pages(struct zone *zone,
>> -		unsigned long start_pfn, unsigned long end_pfn,
>> -		enum migratetype mt)
>> +		unsigned long start_pfn, unsigned long end_pfn)
>>  {
>>  	int nid = zone_to_nid(zone);
>>  	unsigned long nr_pages = end_pfn - start_pfn, pfn = start_pfn;
>> @@ -2027,7 +2035,14 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
>>  	pfn = pageblock_align(start_pfn);
>>  	page = pfn_to_page(pfn);
>>  	for (; pfn < end_pfn; pfn += pageblock_nr_pages, page += pageblock_nr_pages)
>> -		init_pageblock_migratetype(page, mt, false);
>> +		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
>> +
>> +	/*
>> +	 * Update the migrate type for any pageblocks that fall in a KHO scratch
>> +	 * area. Since most pageblocks will not be KHO scratch, do it outside
>> +	 * the loop to only do the search once.
>> +	 */
>> +	kho_init_scratch_migratetype(start_pfn, end_pfn);
>
> And here the chunks are at most MAX_ORDER_NR_PAGES, so bulk init also
> wouldn't save much.

Hmm, right. I didn't think of that. On my system pageblock order is 9
and max page order is 10, so it does halve the amount of work done, but
still, I see your point. It took me a couple of tries to get
kho_init_scratch_migratetype() right, and kho_scratch_overlap() is
certainly easier to reason about.

Oh well, I suppose this gets added to the list of performance
improvements we do at some point down the line

-- 
Regards,
Pratyush Yadav

