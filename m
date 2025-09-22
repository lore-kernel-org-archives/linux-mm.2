Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8296FCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 03:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8A08E0002; Sun, 21 Sep 2025 23:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0368E0001; Sun, 21 Sep 2025 23:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC798E0002; Sun, 21 Sep 2025 23:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE6328E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 23:36:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FA1187018
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:36:43 +0000 (UTC)
X-FDA: 83915474286.06.6545C35
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C16B1C0004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:36:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dYeIGHtX;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758512201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/pAYjt1PTM1WTwOEAJ1ryShiXtBMZp1571RlbpsQfQ=;
	b=gcguf24Yzt1TDZSumFeW+h+0U4JxVuZ6lWH3eU10X7XJpWmmExcocmIRem31HE9hVQKSn7
	qMwv2g0fH4lfMMHh8K00yTY3Vk6ctpdfNKRdKEq/n4twYm5ZGbbWwal2yKxI9f9i26Ezov
	IlxVIa4B9EwCaV35ngMWe4W0VieVTcY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758512201; a=rsa-sha256;
	cv=none;
	b=c9o4wRRXSqpeNDiGu6CF1A4EK7q7nOmGy3eYbbhu6APAPAviIvKbRlPJZeb+l6BZ4hZLN7
	glbAEMXEIk1cziTBAhCnXapTPtET+NmwQSy7vdFgXjfN9UAFCWVdWT2upeIsQShNRMIIae
	l7t2UG1VUa23VykI/9YwMvhPfNH9EdM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dYeIGHtX;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e4e82695-c03f-4105-bddd-9778d7e368d4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758512191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9/pAYjt1PTM1WTwOEAJ1ryShiXtBMZp1571RlbpsQfQ=;
	b=dYeIGHtXEhwqRe5dY2kuaOhbMvjIC5LBJnI4MTLAavEHM28MO5fC1RBYYw1JQSenqd1Od+
	ppNvqg9coKtIPXFQHgGtx3lExQK15m1zekX1RHO6FWDHA+ZXFNiB8BTagglJX3zuepxRoC
	P2383CbGkK919uOabMZSgfcRGK4vAQ8=
Date: Mon, 22 Sep 2025 11:36:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 usamaarif642@gmail.com, yuzhao@google.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, voidice@gmail.com, Liam.Howlett@oracle.com,
 catalin.marinas@arm.com, cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
 kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
 roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, hughd@google.com, willy@infradead.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, qun-wei.lin@mediatek.com, Andrew.Yang@mediatek.com,
 casper.li@mediatek.com, chinwen.chang@mediatek.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org, linux-riscv@lists.infradead.org,
 palmer@rivosinc.com, samuel.holland@sifive.com, charlie@rivosinc.com
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <3DD2EF5E-3E6A-40B0-AFCC-8FB38F0763DB@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <3DD2EF5E-3E6A-40B0-AFCC-8FB38F0763DB@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dyz8fbmiydoa7an8kmbqby5nyczbnpwr
X-Rspamd-Queue-Id: 2C16B1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758512200-826840
X-HE-Meta: U2FsdGVkX19056mTsMcAPC2aj1HrYO1Qjw+D/1uY/yQEU2iNsXG5LTi8a5wikLFsHgo8jGbX6akqe+O9TwEwvrAmvf36Y+q7mWIXSB9dkUgUoAKFf/gFB3utJGkugFIr9vdqaQ8sVz4JGU/xCHylzZ7TRqfTvefjNlUWzQOguaH3UI17vKS+1cuacDIr/5+5NeM2c5nLwOwnX4gsAHySP8attmUgOMOCO2wNZrbH/PTWqvgVF4tKipC255w/J4uRCoF+hr5zGZyB0jCn6WZNYY3HBZarXSnFI42xDWDhUp7iOX8RdiFVt2uUvhHLJ/1rVMqpJdqvzz6c36w6fF+wDPadZtYxU2tHruyqYEtLa5BFIDdnE39bbm670pmCL9vbuu/DGuulesyYMN1eWNK//+oMErH39iAziHarjQyLE/TtumPM9rwltkdzMQditd4URj2/ssUodRU8vJk53YqRdu/kA+jAJJxUyvv9GhzgL/oh09zfbShKEnTTWpStef6ryI+fpHqWhOdoIhxbzW/T0TkuTojgHfKYfWgNmqWY5+SnsSfVr0T4rbr49Nh9SzMQdt1lskxrcm9GsktlrFssurHllChILbGr7XDytD81rFxaXK2ald5BaW9aXucfDqrPDR4M0bLXYUmuvSvNKSnAxkt6jqaS04CyfhQAK4zxeJcEy4Ak9bMCMjnZc/U2o4QvK0Sm5P7KcdFr4fuEmNoHCHt8YoO6B+Lq8EBtWlo2IRJkqCkmsFMK0A5b3XBq/Etxw94xkZKH7vE4I+c+uQr1oLZbMFU/OFlX66ID5tF2l+kKbVQ9/VC4q5hM0hOa1IRHAkBoNskIGwl+V9vv/QzVm2xVbgF6f5zzepGZUt+YaBtz/XApEkE1RE7KDh2SGxDMFlM/gQB61HrOD8cSPhml3BzZ6bkMtOznANwheazO6DMtXKDkGVB9YkS6DEpnPRlQeur5eUeMqNcQljBIGO3
 TriUUZMn
 gyx4v0CBGdVFSk2Np3/2KxgSblOeIdXwRteUTEvAH40ZoADPh1Ks35zRxFMIq4BEsZ11X4nSroyUdn/lZ5P7LjzJB9BZRZ+gCBsk5S8HX3Pf01l+vjNMPegGrZSMN8aeIfP/8ZSubwzzNJ6SqNHd8ie0PN1eXFmobdozNPFDGbtyBHLvj04EAZUVC3IkYx1umCiGifPjMbp0GnDHxpPPTMlGJY1DyZ9k7o05+tR1FJiOZ6HfDxD1Y8x/OZmN7uOJaTKFicpqAYJtDnKJT3rQAY9owF+pCul/WP3iI69P80KSeIoO7FEMf6XBPNIoSYxmg8vlQZRWaypqIfTKztcqUmo/xrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc: RISC-V folks

On 2025/9/22 10:36, Zi Yan wrote:
> On 21 Sep 2025, at 22:14, Lance Yang wrote:
> 
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When both THP and MTE are enabled, splitting a THP and replacing its
>> zero-filled subpages with the shared zeropage can cause MTE tag mismatch
>> faults in userspace.
>>
>> Remapping zero-filled subpages to the shared zeropage is unsafe, as the
>> zeropage has a fixed tag of zero, which may not match the tag expected by
>> the userspace pointer.
>>
>> KSM already avoids this problem by using memcmp_pages(), which on arm64
>> intentionally reports MTE-tagged pages as non-identical to prevent unsafe
>> merging.
>>
>> As suggested by David[1], this patch adopts the same pattern, replacing the
>> memchr_inv() byte-level check with a call to pages_identical(). This
>> leverages existing architecture-specific logic to determine if a page is
>> truly identical to the shared zeropage.
>>
>> Having both the THP shrinker and KSM rely on pages_identical() makes the
>> design more future-proof, IMO. Instead of handling quirks in generic code,
>> we just let the architecture decide what makes two pages identical.
>>
>> [1] https://lore.kernel.org/all/ca2106a3-4bb2-4457-81af-301fd99fbef4@redhat.com
>>
>> Cc: <stable@vger.kernel.org>
>> Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
>> Closes: https://lore.kernel.org/all/a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com
>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> Tested on x86_64 and on QEMU for arm64 (with and without MTE support),
>> and the fix works as expected.
> 
>  From [1], I see you mentioned RISC-V also has the address masking feature.
> Is it affected by this? And memcmp_pages() is only implemented by ARM64
> for MTE. Should any arch with address masking always implement it to avoid
> the same issue?

Yeah, I'm new to RISC-V, seems like RISC-V has a similar feature as
described in Documentation/arch/riscv/uabi.rst, which is the Supm
(Supervisor-mode Pointer Masking) extension.

```
Pointer masking
---------------

Support for pointer masking in userspace (the Supm extension) is 
provided via
the ``PR_SET_TAGGED_ADDR_CTRL`` and ``PR_GET_TAGGED_ADDR_CTRL`` ``prctl()``
operations. Pointer masking is disabled by default. To enable it, userspace
must call ``PR_SET_TAGGED_ADDR_CTRL`` with the ``PR_PMLEN`` field set to the
number of mask/tag bits needed by the application. ``PR_PMLEN`` is 
interpreted
as a lower bound; if the kernel is unable to satisfy the request, the
``PR_SET_TAGGED_ADDR_CTRL`` operation will fail. The actual number of 
tag bits
is returned in ``PR_PMLEN`` by the ``PR_GET_TAGGED_ADDR_CTRL`` operation.
```

But, IIUC, Supm by itself only ensures that the upper bits are ignored on
memory access :)

So, RISC-V today would likely not be affected. However, once it implements
full hardware tag checking, it will face the exact same zero-page problem.

Anyway, any architecture with a feature like MTE in the future will need
its own memcmp_pages() to prevent unsafe merges ;)

> 
>>
>>   mm/huge_memory.c | 15 +++------------
>>   mm/migrate.c     |  8 +-------
>>   2 files changed, 4 insertions(+), 19 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 32e0ec2dde36..28d4b02a1aa5 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4104,29 +4104,20 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>   static bool thp_underused(struct folio *folio)
>>   {
>>   	int num_zero_pages = 0, num_filled_pages = 0;
>> -	void *kaddr;
>>   	int i;
>>
>>   	for (i = 0; i < folio_nr_pages(folio); i++) {
>> -		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>> -		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
>> -			num_zero_pages++;
>> -			if (num_zero_pages > khugepaged_max_ptes_none) {
>> -				kunmap_local(kaddr);
>> +		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
>> +			if (++num_zero_pages > khugepaged_max_ptes_none)
>>   				return true;
>> -			}
>>   		} else {
>>   			/*
>>   			 * Another path for early exit once the number
>>   			 * of non-zero filled pages exceeds threshold.
>>   			 */
>> -			num_filled_pages++;
>> -			if (num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none) {
>> -				kunmap_local(kaddr);
>> +			if (++num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none)
>>   				return false;
>> -			}
>>   		}
>> -		kunmap_local(kaddr);
>>   	}
>>   	return false;
>>   }
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index aee61a980374..ce83c2c3c287 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -300,9 +300,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>>   					  unsigned long idx)
>>   {
>>   	struct page *page = folio_page(folio, idx);
>> -	bool contains_data;
>>   	pte_t newpte;
>> -	void *addr;
>>
>>   	if (PageCompound(page))
>>   		return false;
>> @@ -319,11 +317,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>>   	 * this subpage has been non present. If the subpage is only zero-filled
>>   	 * then map it to the shared zeropage.
>>   	 */
>> -	addr = kmap_local_page(page);
>> -	contains_data = memchr_inv(addr, 0, PAGE_SIZE);
>> -	kunmap_local(addr);
>> -
>> -	if (contains_data)
>> +	if (!pages_identical(page, ZERO_PAGE(0)))
>>   		return false;
>>
>>   	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>> -- 
>> 2.49.0
> 
> The changes look good to me. Thanks. Acked-by: Zi Yan <ziy@nvidia.com>

Cheers!


