Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6131DC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248B26B00A0; Tue, 14 Jul 2026 00:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1946B00A1; Tue, 14 Jul 2026 00:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A296B00A2; Tue, 14 Jul 2026 00:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB09F6B00A0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:35:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A64680237
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:35:01 +0000 (UTC)
X-FDA: 84986117202.22.0D06407
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id E5195C0003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KwUrnLjz;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ae/klHPrw6XikHNA4G0PypNfCBya6aaG0EoWE65OTbs=;
	b=JPMbuBdLQG6BDcXgWQ4misNwXMsJXtR01oHkmEvlA6raRkP8sAqDoCff8ZiWlSObdEOkA3
	ustz9CDirVi2y17To+A2e503lrS5HjVGml+YlPGaEJo6zk8rAVlfYfsfwh7B2Q7P07w3Lo
	IeQEjyevL3W2jMmSS3eeSVKhBJGl3Qo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KwUrnLjz;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003699;
	b=qbdfr4oM13PE1r7loX7nZc+j67u3AB3fTqCh8uQPs9hEhb7oB4ix8BxjkycGq9dn59YWEC
	xp4kksZSWLsG9fQqX9ZInhnI043edBO2JukXTRr2csuOTKG5Pch9xfqD2LMGupPqzo8rkR
	x6VFWi/vOI+OMOPUEGRFwOw0GcSqmCI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82C421570;
	Mon, 13 Jul 2026 21:34:53 -0700 (PDT)
Received: from [10.164.148.52] (unknown [10.164.148.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 91D583F7B4;
	Mon, 13 Jul 2026 21:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784003697; bh=BxkWyC9Bhg38Bdzlxk2i0B0fqTApnC3gzsK70rHjD2M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KwUrnLjzAVWoVjf+esj3MW/phE+xAwE72Ug8zTJ/jqyB6sMXFO9y11RbpKOBGwemy
	 e2us0nCdvNyjzhZPb6pzcu+k41WXpRHoZnHxbjdRcfeXtBzfcMMWgSPzDYpbQfhr+b
	 ybZ0qBZJAfJTQYR1SkfrgB4ot17SfThYt7Oea9PY=
Message-ID: <cec57a2d-c507-4ad1-a598-a0ca7ac8f427@arm.com>
Date: Tue, 14 Jul 2026 10:04:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, catalin.marinas@arm.com,
 linux-mm@kvack.org, will@kernel.org, Xueyuan.chen21@gmail.com,
 ajd@linux.ibm.com, anshuman.khandual@arm.com, david@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com, Wen Jiang <jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709160805.26e63bae89dd03cf2951104e@linux-foundation.org>
 <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
 <54434a84-51b3-4e3f-988b-6bcbac5a2f42@arm.com> <alUgwPT9uh_EWItt@milan>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <alUgwPT9uh_EWItt@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E5195C0003
X-Stat-Signature: trzof8xugnhffnrdzom67r7ebs1myaeq
X-HE-Tag: 1784003698-167816
X-HE-Meta: U2FsdGVkX180FvR5RZUA2tdSZm0kp9KeOuNQlUgwLCzGGhoiTUPlc04AQEAV6g6QpQf1Jlp9GGOw9v4+DRQ/1EINIfZkPhQUaGDq6yHDr87VFuwI8BX28E9GlsIRJvQKZChaM49rRyvfdISf50RLqrGhflov7kXHldMHzqaJpBAy4GJKZz53fatAe7Yusj/LVdNY0/VTQGiyHk6GCJsdCO3HnPChnKBgY/0qqJfwdFtSFSp7RWptE0in/um2RX6lrk9PYrSir75YhHw7UY3caQ0DOiIXP5YDj34bpPLSMSkwMPMG0aNkSvL9nnRY0HavduqMfzT8dm86+4vRg/UUCEBRd4OnxNAXvVYI2mR9IHgG3QOPlaEeoTSmRH7x3Gjo/nA+xO1sEVcQ408OMhY+n+yWyH7lZ7vfACCfzmbApvBkVxlOxkhh2xizY+rdpS5wEsThHCoZMHjn67iYz4C762xji85wXxSVabPl5qd2lm6bcA7MX+msLVxZKBnUG+QFOdaNu06U5vxlhjNyMaJyTiPEvC9kDpPfS5qcWIHmMfIS/URqdEY+HA4nPYXZl5XBoWAMpHyGHUUcfDUPRZa5jnZnG4BaksiAKz/+TI5hDI1jLHicOHEkCj9NMEQueWhmXeLU3WGjcaPvaunsEm6sp2T/DbM4cJ1usemgYNUVfsqrClVEj10hydbPwpFibpNl85q55mYG9xHE0qXQ4V2LNvrmcmIqgDmlcDUmknlm68oilKtgp2QJBEm/fc+yXrIIFKqm/PHhsG9LIk1wyronalV0PZBPBS2QU2pSp28h/aO5h0q+pGhm1Pd5+w7i22cvXKpczSxcqwDPzGNZKnEv1k6r0Q8C6Rk3D1qRmx5iGw/HZF5HbnGfCqxvWlq+bnF5/Mlag78lf/OU4vdWjTuyp/b6ui66H5paiO9cQpgZruAOhTZh5t+EpDsKia0nH/Ry4BGjcB3FK1MAZfU2t3V
 7yUM0f3W
 SQpYj/Dc3sJlxPzd4SZg6krkNBKWzStXpwFtJx7NtVNswYxqmUJ3WX/NfjvONIa7wFNBm67WV3rFWBnCRBTyXIvaCuwpbShlnUB/FP56PTwVEabZ7pYcrRn97MxZAopdl/pGx59qULx/eDnrA5OhM/3gUJPWNrvdDdP/zltA9kVwgMQEChF3RDUCnSGIsJSZLN2KvO+YrO8TnkL9ElyAEbFfRe2aTKvdsZMZRvpjYis3cyY35wzxqD4L8j3WgAo1WZJ/oG4gurNzYpjB+p1xkADqvYpt8h/tIc/fXXHPNOr7LmpF0WaMkEUZC+n0j2zcWm0wN76XEQCMK2xN3JMJOpFJc+FwVNodc2AVZ9O9FtxjIhbW8djoHcd5mpRMNURU3RVbMfgrKuNMiWxF5WYUdABOfP9cyzIclGJuHeSGLiJy3fwi6ESBx4qQk++TxAozv1cWidIFrAIdMfSHbKXFUJHOBoMrphrwPzr+Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/07/26 11:00 pm, Uladzislau Rezki wrote:
> On Mon, Jul 13, 2026 at 08:43:14PM +0530, Dev Jain wrote:
>>
>>
>> On 10/07/26 2:24 pm, Wen Jiang wrote:
>>> On Fri, 10 Jul 2026 at 07:08, Andrew Morton <akpm@linux-foundation.org> wrote:
>>>>
>>>> On Thu,  9 Jul 2026 15:38:17 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>>>>
>>>>> This patchset accelerates ioremap, vmalloc, and vmap when the memory
>>>>> is physically fully or partially contiguous.
>>>>
>>>> Thanks, I added this to mm.git's mm-new branch for wider testing.
>>>>
>>>> AI review asked some questions, and some of them are new since the v5
>>>> series:
>>>>         https://sashiko.dev/#/patchset/20260709073823.6643-1-jiangwen6@xiaomi.com
>>>
>>> Hi Andrew,
>>>
>>> I've gone through the Sashiko findings:
>>>
>>> - Patch 1 (find_num_contig): Over-interpretation. No new hugetlbfs hstate
>>>   is added. The extra sizes are only used by init_mm kernel mappings via.
>>>
>>> - Patch 5/6 (NULL page): Invalid input. vmap() expects a fully populated
>>>     array of valid struct page pointers.
>>
>> Correct, but vmap_pages_pte_range has !page and !pfn_valid checks.
>>
>> I really hate those checks - if those checks have any remote possibility of
>> firing, then we already have a bug at
>>
>> vm_map_ram -> vmap_pages_range -> vmap_pages_range_noflush -> kmsan_vmap_pages_range_noflush
>>
>> because the last function dereferences the struct page pointers.
>>
>> It is painful to do the page array sanity check deep into vmap - it implies
>> we simply cannot play with the page array before that.
>>
>> But since vmap is an exported function, doing a sanity check for the page array
>> in the vmap code makes sense.
>>
>> So how about the following:
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index afaa14ebf17bb..0c44bb7a45b5d 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -566,14 +566,6 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>>  			err = -EBUSY;
>>  			break;
>>  		}
>> -		if (WARN_ON(!page)) {
>> -			err = -ENOMEM;
>> -			break;
>> -		}
>> -		if (WARN_ON(!pfn_valid(page_to_pfn(page)))) {
>> -			err = -EINVAL;
>> -			break;
>> -		}
>>
>>  		pfn = page_to_pfn(page);
>>  		size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
>> @@ -603,11 +595,6 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>>  			struct page *page = pages[*nr];
>>  			phys_addr_t phys_addr;
>>
>> -			if (WARN_ON(!page))
>> -				return -ENOMEM;
>> -			if (WARN_ON(!pfn_valid(page_to_pfn(page))))
>> -				return -EINVAL;
>> -
>>  			phys_addr = page_to_phys(page);
>>
>>  			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
>> @@ -3663,6 +3650,19 @@ static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
>>  	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
>>  }
>>
>> +static inline bool vmap_page_sanity_checks(struct page **pages, unsigned int count)
>> +{
>> +	for (int i = 0; i < count; ++i) {
>> +		if (WARN_ON(!pages[i]))
>> +			return true;
>> +
>> +		if (WARN_ON(!pfn_valid(page_to_pfn(pages[i]))))
>> +			return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>  /**
>>   * vmap - map an array of pages into virtually contiguous space
>>   * @pages: array of page pointers
>> @@ -3706,6 +3706,9 @@ void *vmap(struct page **pages, unsigned int count,
>>  	if (!area)
>>  		return NULL;
>>
>> +	if (unlikely(vmap_page_sanity_checks(pages, count)))
>> +		return NULL;
>> +
>>  	addr = (unsigned long)area->addr;
>>  	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot),
>>  				pages) < 0) {
>>
>>
>>
>> Reasoning for calling vmap_page_sanity_checks() before vmap_pages_range_batched,
>> and not at the start of vmap: I am worried that since vmap() is already very
>> fast, we may cause a regression:
>>
>> vmap() -> scan page array with linear map pointers -> vmap_get_aligned_vm_area (does
>> memory allocation, throwing out the linear map VAs from cache and TLB) -> walk
>> the pgtables and again access cold page array.
>>
>> Perhaps I am being very pedantic here. What do you think?
>>
> Sanity check adds extra CPU cycles and it adds overhead. The concern about cache
> to be cold on second iteration looks valid. You can get some perf figures to see
> the cost.
> 
> I would just keep the original approach. But no strong opinion here.

Given you don't have a strong opinion here, I would also prefer keeping the original
approach. This feels more like a code structure problem than a correctness problem,
*and* given that with kmsan builds we have this problem for years now in the kernel.

So perhaps we can look at how to solve this later.


> 
> --
> Uladzislau Rezki


