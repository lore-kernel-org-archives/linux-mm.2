Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DDD0C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393B46B008C; Mon, 24 Aug 2026 07:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36AE46B0092; Mon, 24 Aug 2026 07:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280CA6B0095; Mon, 24 Aug 2026 07:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0A306B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:18:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20123A0500
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:18:53 +0000 (UTC)
X-FDA: 85135915746.11.3742B72
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	by imf28.hostedemail.com (Postfix) with ESMTP id 67BE0C000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:18:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GoJC1by9;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787570331;
	b=4/C+llrlJgohouG2UM4VS6W+feIjMo5T3Ye5hZK9bxV5RdxEpTA1twhNo1NXFfbgg6crTw
	wAoT88MS0k2cBXeZ/C4/mlk5IWnaAWXd48cTs0ZeqJqxui2q27O2+d4tKtOrAtUK5L9X87
	IaJ3AipNxUcCJ/3ap//hUUg2s9ia7Gs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GoJC1by9;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787570331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+f7RHO8n9X9Z3Jua2985//05pIscHzIEy+D7mW+vd/M=;
	b=hGBI4HHaDoaLIs2j9Eo+DtC/l6oC3tM13iNoefDhsVRO/A/W7wwRLKmvOjEAI+9OL6olCZ
	MIxfbCeMr8hfwI3CiEVIbeHVlC+LAvhlicOir8IWk+PtiTzVrR+NMkzYCrD98voUqKsmL7
	jHMwi/RmLHXF+EVRANuhVCaAlmO1tmc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=32itMfmpMIT+qkqntr949fZUt3gdG2/oFwkIwIa+FkI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787570326; v=1; x=1788175126;
 b=GoJC1by9GxLQ910MDvdF1Cr8YH/Gh1/AKhTNFnn6Ldo3blWD0YZQDs22W5gc08Mh/030dLYh
 sxTNa2gDBv5sud6PAoeim5ilnVj22wpGK7olGAd4N1EyjPg5LbeQkvZXcs/AA/MPQGs3kgMD2U0
 0TIKDqqypQQgqImrQCpC7LhA=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.67.158.60] (114.251.196.104)
	by smtp.migadu.com with ESMTPS id 0250bd41515bb170;
	Mon, 24 Aug 2026 11:18:46 +0000
X-Mizu-Trace-ID: 0250bd41515bb170
X-Migadu-Flow: FLOW_OUT
Message-ID: <42b6e1b4-96ed-4364-a502-369b4a96705b@linux.dev>
Date: Mon, 24 Aug 2026 19:18:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
 <20260819095140.17252-4-songmuchun@bytedance.com>
 <178756196748.3606540.14377746709923091802.b4-review@b4>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <178756196748.3606540.14377746709923091802.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 67BE0C000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: cm6e4wm4knezcodu98q9on7q8mk4or7j
X-HE-Tag: 1787570329-485577
X-HE-Meta: U2FsdGVkX1+iAnz5yn+olKa0upmisg3fnS3UYHPXegy5yF/pL4GIxYogXNzHiJhRTmG5TAt18UTPOG+tvtOgNiAJzk2QY4R5XCOBRpmp0ghZWDWcI5tqa3EsENDn/50aD+H9VbSH5lcptPA0o/r2Fck1DtqriJOkQHo2e9pd1xMbJs2iF5er5TJ6qF1LZLjv3dsJga5ZsGDS4/o5xRqwzg1GxK4byJd0urpJ9/BKjk1kgCp+vtGAoqAOQLToc9ZFEQE8TewZbP8nf5pWI29Z2GrRXhHu56BsfONE/PTqDvCjtBqp+b7+Eyx6/IrAOurrEqKkYZbe5vzBahYLyb3s3oqAzVBit3oUmwJcUNfninHS//s5aTREFDvmEIH+9gAI0uvOh3lh0RLEtyen0y01OiQcno3S8VThcVHASpkj1BGRg8+BqSbDvFr9i4Quiqtov8PZ5tdQd2uDjZCdq4VjKzCOZT3e9HEI0j5WO5SgDmQq9JKYNyZS9MPynrGNSCLQjx3o0P+V9CbTNZmnm2A5PRCXwFjyaZTu1co8oMTLwYd+vHCkM15CidL1YxO4BrRx9Hq3UhdfVJYMUKh8rhUOkJ09lx4GaFpfkfghCbXfQsbStMvbU580Y/lnN+7OdR3itBS980z356bhl/r3xiH678mDxhZW+ITwDsnWLkJRZca1hULQqJaKh++bUtLUAe/ZcCikgYWmeWOdoMs2j+95Jl0dXpDcFW7suBXljDbl4ieafcci7G23M0p6xJrd6JmLcBpv5Uz1D6Ly89b0SNQgWOsHKYQ/d3vYRtxubR7hjoCeEPlt+SzYSLeCkfpfUmcg9WSxO9WWaf/cjwJxBi8keTvwEUycIFJhiGLwxNWz9Ni3nbnk2aOAVlTRDppph2qmZwlykiD33QgxAzmW2oiZY4sBc6jzo6GvOxk9dJtVu/vEiFIXqnuWQwGbG7Z2AY7fANQR0gaATnO9eLcml6L
 lsFwORrc
 SbJbgHSlIYkhYiLkFXrTRb/Q8xlLWIYm6Fy4osvi9R6Jf7B0Eui1Fs2PMwJbSLORxhzTjUiglEnirmEuSCdH7bZyxbERSk4Z0Vf/dhJqyrxVu1bEGrwlBJVZQNStVPmolBhJSUOL4wCLZsOB99dCok6zzs0x4EqN72MHNdViGt+f/XOWkc+Q+VEO87P9xhbt5sGBWOdXfurkBiXgga4vY5VpQO6LAXe2pBiVHtxETfFmZMKBbsW85NlDzlJNKZ3OyN+cj2jI323YDWTKLF/x4ZrOcoTTrpHeO3Msqqe8rk7J87zdQMIxYfYL2NNU8mr6vBp1j5QuwiiI5T4W3/rAEdds5Rrp8/RGSxKrl/pwPYeHCM6+eXo4+EOwURIwoaiCe15Q3sY0MFbCoHGm18PLxpuWRhJyNyNZoTLSobqgsu0byd1+vHlue7C5/IFYY3wILPZQdoN9M0CZXx7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/24 16:59, Mike Rapoport wrote:
>> memmap_init_range() initializes every struct page in the target range.
>> For compound pages with vmemmap optimization, the tail struct pages are
>> backed by a shared vmemmap page.
>>
>> Initializing those tail struct pages would overwrite the shared
>> vmemmap page contents, requiring users such as HugeTLB to restore the
>> metadata afterwards.
>>
>> Track the compound order for HVO-backed sections and use that metadata
>> to detect struct pages that fall into the shared tail vmemmap range.
>> Skip those shared tail pages in memmap_init_range(), then initialize
>> pageblock migratetypes for the processed range with a helper after the
>> per-page initialization loop.
>>
>> Keep direct mem_section access inside sparse helpers by exposing
>> pfn_to_section_order() to users that only need the order associated with
>> a PFN. This lets memmap_init_range() skip shared tail vmemmap pages
>> without exposing __pfn_to_section() to !SPARSEMEM builds.
>>
>> This is a preparatory change for consolidating handling across users of
>> vmemmap optimization, and it also avoids redundant initialization of
>> shared tail vmemmap pages during early boot.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 5fb9b37819d5..df31cac12311 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -2022,6 +2022,14 @@ struct mem_section {
>>   	unsigned long section_mem_map;
>>   
>>   	struct mem_section_usage *usage;
>> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> +	/*
>> +	 * Normally, sections hold regular (order-0) pages. However, for
>> +	 * sections with HVO enabled, this tracks the compound page order
>> +	 * to enable deduplication of redundant vmemmap pages.
>> +	 */
>> +	unsigned int order;
>> +#endif
>>   #ifdef CONFIG_PAGE_EXTENSION
>>   	/*
>>   	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 1533aebafb68..05c09e755e0b 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -29,6 +29,7 @@
>>   #include <linux/cma.h>
>>   #include <linux/crash_dump.h>
>>   #include <linux/execmem.h>
>> +#include <linux/sizes.h>
>>   #include <linux/vmstat.h>
>>   #include <linux/kexec_handover.h>
>>   #include <linux/hugetlb.h>
>> @@ -677,21 +678,19 @@ static inline void fixup_hashdist(void)
>>   static inline void fixup_hashdist(void) {}
>>   #endif /* CONFIG_NUMA */
>>   
>> -#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
>>   static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
>> -		unsigned long nr_pages, int migratetype, bool atomic)
>> +		unsigned long nr_pages, int migratetype, bool isolate, bool atomic)
> Growing boolean flags makes the callsites harder to read.
> One way to deal with it is to add comments to the callers saying what
> each true and false mean.

Make sense.

>
>>   {
>>   	const unsigned long end = pfn + nr_pages;
>>   
>>   	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
>>   		enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
>>   
>> -		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
>> -		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
>> +		init_pageblock_migratetype(pfn_to_page(pfn), mt, isolate);
>> +		if (!atomic && IS_ALIGNED(pfn, PFN_DOWN(SZ_1G)))
>>   			cond_resched();
>>   	}
>>   }
>> -#endif
>>   
>>   #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
>>   static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
>> @@ -886,6 +885,13 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
>>   			}
>>   		}
>>   
>> +		if (vmemmap_optimizable_pfn(pfn)) {
> A short comment above would be nice :)

No problem. Thanks for your review.

Muchun,
Thanks.

