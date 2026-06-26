Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D55FECD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870436B00D3; Fri, 26 Jun 2026 00:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8483D6B00D4; Fri, 26 Jun 2026 00:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760686B00D5; Fri, 26 Jun 2026 00:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 500EF6B00D3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:09:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDC87C17EB
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:09:07 +0000 (UTC)
X-FDA: 84920733534.04.BA3D9AB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD8B9140003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:09:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BCyLB4Cr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782446946;
	b=gJVhIzqOx+wfx2bKo309tgEgz8VodaipyEK7srzavIk7NdBHw93LWMaeQUhNuT3JU3c5ms
	BgWHfYacVH40KglXX1KEQVSN+XTNzrbONyaHSGwRbFMB66K+LbyTUzK66Xx8iml5vJHCT+
	1A86OD6DDg/IclJF7Lm1F2/q5hiAFys=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782446946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GI7NkIyQUkZ6qXB3etXMXCmYTuCkIx5I93zk5FK2tz4=;
	b=2FBo3Wcxed6MEfrt3+lJviVvTJTtnfDaTlXzEeHQ+vquQRO+ZowYFxyUHrmmFgnWY7qzVM
	ZT0QxeUjEPCo2HG2I1JNj/YmBbOGaQjwd6+sOuuUVop/dNOd2Hjw3RVD1SyoUGYAzjgoXH
	nxoaeDNQU5PhGfkFl6qpTXpizg17GIs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BCyLB4Cr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 768F727B5;
	Thu, 25 Jun 2026 21:09:00 -0700 (PDT)
Received: from [10.164.148.34] (MacBook-Pro.blr.arm.com [10.164.148.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85BA93F905;
	Thu, 25 Jun 2026 21:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782446945; bh=HTppeoW4NUFkZpfSV8jrwpujTK0jbxEnDx0YkxariVc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BCyLB4CrsL2+cJ/CqAZnk5YVodeXEj2yrFVUItVBDQXbvlWz5we0Lahkc57HaKdFW
	 Zm+txWK8ClKRkpS3Io3gCn7upJoo7X89fOszid/dSI78uOEwl0EzJ/f7g7F1ahkane
	 leEH1DS+Aheq/ePrcsecZKe2olK2W65eoghQMYlE=
Message-ID: <c807eac2-7b72-4b16-b4bb-b7241d35a991@arm.com>
Date: Fri, 26 Jun 2026 09:38:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm/mprotect: use huge_ptep_get() for hugetlb
To: Muchun Song <muchun.song@linux.dev>
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, mel@csn.ul.ie, nao.horiguchi@gmail.com,
 ak@linux.intel.com, j-nomura@ce.jp.nec.com, pfalcato@suse.de,
 dave.hansen@intel.com, tglx@kernel.org, jpoimboe@kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, david@kernel.org,
 liam@infradead.org
References: <20260625112955.3254283-1-dev.jain@arm.com>
 <20260625112955.3254283-6-dev.jain@arm.com>
 <28f75d0d-de54-43a1-b46a-fe3dd1188929@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <28f75d0d-de54-43a1-b46a-fe3dd1188929@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD8B9140003
X-Rspam-User: 
X-Stat-Signature: ikwedh7ss69txmmtncoouxmo1w9jahp1
X-HE-Tag: 1782446945-882680
X-HE-Meta: U2FsdGVkX18u0j933VoAwNWECE7D5HCmOB/uZ/TbRPCRcbtserR4EEw+SMMKSCCEHxsLfRuF2NKtphdwAqtjhMjijfIku/HmAk20HcekDOQ71DxR/mEFEnWK6g+j6vZ6+EWO9StvvyxQAJ0H8CG6DoQGTVIeEmzXY+P2SsjySaY9Af7Mw++Kg8xlwfgIFkTKtyRpbDhj+VIb7XUMVimd3hr3QEncMy0fXPTAN3bVK3wsY4JNM4TFwrhdMwYHVlUGhuhK0fQ1bI6Cc3vLUn5UCEJ2thQtu6CRzzsLEXM4G1HGG1Lh4N0ysLvah784X4Rj9WPzy0HsJ4jYmpZALKQMhhQ2xXrkJcLvTzzOvb0UI4jq6iAbYiBYaN/RpjuTRVHkysoLvwygZZ+xRwpyW7+ulAcMjoo/nK0EG9EoCHuMdzgDCMNNOP799kr2KMYvu/05LAXFN6TOMpVHdxENjz7ywcaHam6qTxL953Lhpx6tvVq1AjOyKza77FyCgwqeJ0xc1HlM0n3VfNGs/6A4cDvold4XGRfoPbPM6oVl7Mk2cidI1W5SDwtv19YJ8Y9ovKmQCnd+rrHqjKB068vXGeeG8SU5J1O/dP2qs7Aiy65OMv/x0yAyXkEMQUZ3vzHvcHgK77s6qFwK913/Bek7G3uxFhjhHnM4Mo674uz+YCpiM/rfTs/I8gYpEVir13eNuymxljiySc6AtB+YYDQK50W/kIrYEKz6q2if3AmzVKPxOxXkyC2xQhE5kncwXQ9ESbSpctxeiXXJjqM/2owiYGTWBxCCBbQz4v8CAy22IzCzakAFZGOnTxgrhc7cM3JHfD3zN98CZMre1H+a9lT7c340loOBQcYHyzaOAADqVJt3jwUaFekZP1acbbusXEAZpMXKNuUA+tFB6X0qu2zs3/vMKEuqUuTywUWoH7fBk3yXmiuoXPI6GT8Yi3Jz1uvIaGQTqyyN+Bla0rOjRqVDoA8
 USj5SbzS
 lvp5VNVIWfjNSZVCV6pdIZuoQtEeeR+jYiVnklqtXX0VgBuZkEhAqvRwNxvpn3XvmRuml9GoiZRUvjTMKYUUKpevfOpie4zPIJwCeWKIxrAYZbQNenVVZBDrd+8Ma0whAyi1J3u98r7kVoSTIiFaL1o0/tV/5CrO9+EtA2BAuQfVk3SE0/ghwgnGvhsezn9KnMsWyzuzFXzLkruprynm+X9fozxj6u1fCki/M9ykaKn8xi8IRerjwBtmDfuuBPMj/vMPXYxDoS5jy8Eo0c1+ftMadqYBbdweHCiaHwlhA4MNpYwK5FaOLnV7KIfT9CkJFb7Y9aDzNXRydiFjhHrBsvj7F1kXTiQ3Exu1MWfRr2likuSRcI6P8K3WoBuYexsn1JxQHT3/9gIg/j/ADuBHXLre/aZm82BVJaP8VE0c7VZ3RFr9lg/icGzibqZDfLYdmm+N0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/06/26 9:10 am, Muchun Song wrote:
> 
> 
> On 2026/6/25 19:29, Dev Jain wrote:
>> prot_none_hugetlb_entry() is the hugetlb callback for the early
>> mprotect(PROT_NONE) PFN permission walk on x86.
>>
>> The callback passes the decoded PFN to pfn_modify_allowed(). For a
>> hugetlb callback, the pte pointer refers to a hugetlb entry. On
>> architectures where hugetlb entries need huge_ptep_get(), reading that
>> entry with ptep_get() can make the permission check use the wrong PFN.
>>
>> Use huge_ptep_get() before decoding the hugetlb PFN.
>>
>> Currently there is no path which can trigger a bug: huge_ptep_get() is a
>> simple ptep_get() for x86, and the prot_none walk occurs only for x86.
>> But use the correct helper anyways.
>>
>> Fixes: 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>   mm/mprotect.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 9cbf932b028cf..23779632d18bf 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -699,14 +699,20 @@ static int prot_none_pte_entry(pte_t *pte, unsigned long addr,
>>           0 : -EACCES;
>>   }
>>   +#ifdef CONFIG_HUGETLB_PAGE
>>   static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
>>                      unsigned long addr, unsigned long next,
>>                      struct mm_walk *walk)
>>   {
>> -    return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
>> +    pte_t entry = huge_ptep_get(walk->mm, addr, pte);
>> +
>> +    return pfn_modify_allowed(pte_pfn(entry),
>>                     *(pgprot_t *)(walk->private)) ?
>>           0 : -EACCES;
>>   }
>> +#else
>> +#define prot_none_hugetlb_entry    NULL
> 
> This is very strange, because we defined a stub as NULL for a helper

I was following pattern elsewhere, search for ".hugetlb_entry" in the
codebase and you will find others doing the same.


> function. How about  the following diff?
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9cbf932b028c..4d8c1551fbce 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -716,7 +716,9 @@ static int prot_none_test(unsigned long addr, unsigned long next,
> 
>  static const struct mm_walk_ops prot_none_walk_ops = {
>         .pte_entry              = prot_none_pte_entry,
> +#ifdef CONFIG_HUGETLB_PAGE
>         .hugetlb_entry          = prot_none_hugetlb_entry,
> +#endif
>         .test_walk              = prot_none_test,
>         .walk_lock              = PGWALK_WRLOCK,
>  };
> 
> Thanks,
> Muchun
> 
>> +#endif
>>     static int prot_none_test(unsigned long addr, unsigned long next,
>>                 struct mm_walk *walk)
> 


