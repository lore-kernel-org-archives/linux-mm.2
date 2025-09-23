Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FFDDCAC5B1
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665158E0005; Tue, 23 Sep 2025 13:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63CBA8E0001; Tue, 23 Sep 2025 13:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579AF8E0005; Tue, 23 Sep 2025 13:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 431FB8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:20:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06DCB1DED9A
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:20:34 +0000 (UTC)
X-FDA: 83921179188.20.0770CFC
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id DAF7C40015
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:20:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vCnmUEcO;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758648032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhWRSUVB8GF7kCQH4EGUYZkhuU402qmBEblBNgpnv18=;
	b=YqCkmuVBYtBKOEdeKbWGU0fjEYeqZevBlki4LclFhHw1Xw/QsQkPFghnYgp1/8nG3Tj+TM
	9VHAKfDvSUHlx61xop9dgmrRvk3En7hN2/f4PNmbX4GBttc1xffHgGb6O3W8LHpPjaaTBl
	kgQqT8ZG3wbLbmUCOo8Ya7Q7Twhcimk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vCnmUEcO;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758648032; a=rsa-sha256;
	cv=none;
	b=y1z4HCC87KxHhmIdzj4KTTaC/Icl63CA/WIC5p0ieiSHbIVFxhOK/TSqQjgYN9jJ56XWvO
	iubo4zSC7NFKdIu2RRoF/lRuhshcewzh1tik0l1tYx8c8qcytVqFHVIqfqodmxT0MFe8ME
	YDg/w2SZRszzEGOvf9m5ythLEvb4Mpo=
Message-ID: <1a8352a6-e03f-4f3e-a06b-fab757e39eab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758648028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zhWRSUVB8GF7kCQH4EGUYZkhuU402qmBEblBNgpnv18=;
	b=vCnmUEcOJcdG5I4H4EeCK1M+LLbB60ngG817jo83Vo6bdMnlfLHaKSuVzIxH0lInW54Sda
	Kb/hdqVsJnw0cUz93IyL5x7VjXDNCPhZtPTgyDowkkT90DFJN9QxpeBKp4DZvz0YwPUtEL
	MgZYJV8EAvGz9D3+TvAY57J8A4ijaoM=
Date: Wed, 24 Sep 2025 01:20:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
To: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 usamaarif642@gmail.com, yuzhao@google.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, voidice@gmail.com,
 Liam.Howlett@oracle.com, cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
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
 stable@vger.kernel.org
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com> <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com> <8bf8302a-6aba-4f7e-8356-a933bcf9e4a1@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <8bf8302a-6aba-4f7e-8356-a933bcf9e4a1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DAF7C40015
X-Rspamd-Server: rspam05
X-Stat-Signature: 3nsnaq5xju8kfd3n8h3e6hyoskjha6ma
X-Rspam-User: 
X-HE-Tag: 1758648031-29104
X-HE-Meta: U2FsdGVkX1+4hKrL/awA8z/yA1VfTmRLWoxnZAn0LKi//vcOI21ohI5iq7A1+XWnAEsYRu1KuocCrajSavaQiX8/WLyJo36seLv3deqqbwcWkbGUwCJ/2YiIQ+2bwuaqDo2URnuTvSmkVQh83scWUQy1NSauSHfqNaJ6ZGW8knm9lUAUQH3VCkT/WzFuZJ4KSIBpBOSuKxFxtXCTCPE6wcezLiMLD8MpLxilUJPZ7EtbwxrfQLFWIdpkQVdU1TODwxlMsIRBZxQFZkiH590wddkVOwTZDABhl1bMpfteKja3Na3pHsO2vgJVQhd0HUU5RCMg/hFCt8VT7PcebJ8MM6epXIT1rFvis2AsTxv28ZGwT997KNiqoDj+MqwLzIGB87Iypv2wkZCAzURcF1kcXiw5Rj6kOlxCk2sH0poEAzY/wjvQYUWraALfMQ+Ft6Aa+x9fbT5MnolbGGg67i14zJZp9zxK+kXJr+8Z6aEPCcA2bcV5XpwKSFwtJl8baLrAZXdAaEatf8tOPrpYoelb/ZH8BhdtqNYxvD1ciwjo7o8mJCiggMfCmVXjXwOxy1NCsgSS6BHGwGCjN901VoqXur9RIq8UQWVCDiSNQE1uzzWSoLr06V47dqdLwbbpzy6oD0zvPWjK6SwhkW6TGhOhZP1GZRMXODuIohuD6VNmL3NBP41PnId7Kpt8zMTnzww6rusyQ2ruX3gNOlvWKz5lrPGijlnY8QHXUnwRD1YYcDWpvtRDJoxy0HcExqmygj1XeqVM7aOQkPpjVmIsERPfnSCl6eUT1rbqYyV7U1Isw94Q4luHf9kLI+DqWA1MgRkwZul+xiRXLHEzH72doVAbJ7DTqSZlDLfgde7q061P4ldXnvJmiaAHfD0VOYgC+u+JF2Llc3giVWEednkEue+S2IdwZyjrRb8U5PO+iIpTBGU5kvt3720B1B7nMCDgCRRes8CzR/YWwMzvIz9Dh7x
 COS0Nd25
 Upa5ZTldc0IGPdspJISkrWj9W9Hh/O0YGSdQ0BfpXpPPjfYN0BKKYNf3fOO6E/cXiLJgQh6ODwxve4RvaEqBQ+08Y7guWwMAjYq9beeT08Rkbbs4xbYqxARMjGann3dQH6Rtmi/E0/D6lwnvSVmz76daqVUQs3zsapKmsr6LeAmpccrSQsW1fdy12MsnZ73c5zvBBa+XDOVHUZFzPLT9Fm7I/Jh+JTfV2XXtDM9eLZ16eZ+m5tW8dXH2LDsqWGbjK1ZlvDOwybNCB3MTjiaYNZkxEd0XafCUr32BEw+fLJTl8PEJFELJFz/O2gA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/23 20:00, David Hildenbrand wrote:
> On 23.09.25 13:52, Catalin Marinas wrote:
>> On Mon, Sep 22, 2025 at 07:59:00PM +0200, David Hildenbrand wrote:
>>> On 22.09.25 19:24, Catalin Marinas wrote:
>>>> On Mon, Sep 22, 2025 at 10:14:58AM +0800, Lance Yang wrote:
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index 32e0ec2dde36..28d4b02a1aa5 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -4104,29 +4104,20 @@ static unsigned long 
>>>>> deferred_split_count(struct shrinker *shrink,
>>>>>    static bool thp_underused(struct folio *folio)
>>>>>    {
>>>>>        int num_zero_pages = 0, num_filled_pages = 0;
>>>>> -    void *kaddr;
>>>>>        int i;
>>>>>        for (i = 0; i < folio_nr_pages(folio); i++) {
>>>>> -        kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>>>>> -        if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
>>>>> -            num_zero_pages++;
>>>>> -            if (num_zero_pages > khugepaged_max_ptes_none) {
>>>>> -                kunmap_local(kaddr);
>>>>> +        if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
>>>>> +            if (++num_zero_pages > khugepaged_max_ptes_none)
>>>>>                    return true;
>>>>
>>>> I wonder what the overhead of doing a memcmp() vs memchr_inv() is. The
>>>> former will need to read from two places. If it's noticeable, it would
>>>> affect architectures that don't have an MTE equivalent.
>>>>
>>>> Alternatively we could introduce something like folio_has_metadata()
>>>> which on arm64 simply checks PG_mte_tagged.
>>>
>>> We discussed something similar in the other thread (I suggested
>>> page_is_mergable()). I'd prefer to use pages_identical() for now, so 
>>> we have
>>> the same logic here and in ksm code.
>>>
>>> (this patch here almost looks like a cleanup :) )
>>>
>>> If this becomes a problem, what we could do is in pages_identical() 
>>> would be
>>> simply doing the memchr_inv() in case is_zero_pfn(). KSM might 
>>> benefit from
>>> that as well when merging with the shared zeropage through
>>> try_to_merge_with_zero_page().
>>
>> Yes, we can always optimise it later.
>>
>> I just realised that on arm64 with MTE we won't get any merging with the
>> zero page even if the user page isn't mapped with PROT_MTE. In
>> cpu_enable_mte() we zero the tags in the zero page and set
>> PG_mte_tagged. The reason is that we want to use the zero page with
>> PROT_MTE mappings (until tag setting causes CoW). Hmm, the arm64
>> memcmp_pages() messed up KSM merging with the zero page even before this
>> patch.
>>
>> The MTE tag setting evolved a bit over time with some locking using PG_*
>> flags to avoid a set_pte_at() race trying to initialise the tags on the
>> same page. We also moved the swap restoring to arch_swap_restore()
>> rather than the set_pte_at() path. So it is safe now to merge with the
>> zero page if the other page isn't tagged. A subsequent set_pte_at()
>> attempting to clear the tags would notice that the zero page is already
>> tagged.
>>
>> We could go a step further and add tag comparison (I had some code
>> around) but I think the quick fix is to just not treat the zero page as
>> tagged.
> 
> I assume any tag changes would result in CoW.

Right, I did a test and confirmed that any attempt to change
tags on the shared zero page results in a Copy-on-Write, as
expected ;)

> 
> It would be interesting to know if there are use cases with VMs or other 
> workloads where that could be beneficial with KSM.
> 
>> Not fully tested yet:
>>
>> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
>> index e5e773844889..72a1dfc54659 100644
>> --- a/arch/arm64/kernel/mte.c
>> +++ b/arch/arm64/kernel/mte.c
>> @@ -73,6 +73,8 @@ int memcmp_pages(struct page *page1, struct page 
>> *page2)
>>   {
>>       char *addr1, *addr2;
>>       int ret;
>> +    bool page1_tagged = page_mte_tagged(page1) && !is_zero_page(page1);
>> +    bool page2_tagged = page_mte_tagged(page2) && !is_zero_page(page2);
>>       addr1 = page_address(page1);
>>       addr2 = page_address(page2);
>> @@ -83,11 +85,10 @@ int memcmp_pages(struct page *page1, struct page 
>> *page2)
>>       /*
>>        * If the page content is identical but at least one of the 
>> pages is
>> -     * tagged, return non-zero to avoid KSM merging. If only one of the
>> -     * pages is tagged, __set_ptes() may zero or change the tags of the
>> -     * other page via mte_sync_tags().
>> +     * tagged, return non-zero to avoid KSM merging. Ignore the zero 
>> page
>> +     * since it is always tagged with the tags cleared.
>>        */
>> -    if (page_mte_tagged(page1) || page_mte_tagged(page2))
>> +    if (page1_tagged || page2_tagged)
>>           return addr1 != addr2;
> 
> That looks reasonable to me.
> 
> @Lance as you had a test setup, could you give this a try as well with 
> KSM shared zeropage deduplication enabled whether it now works as 
> expected as well?

This works as expected. Both KSM (with use_zero_pages enabled) and
the THP shrinker are now able to successfully merge zero-filled
pages with the shared zero page, as long as those pages are not
mapped with PROT_MTE.

> 
> Then, this should likely be an independent fix.

@Catalin could you send a real patch?


