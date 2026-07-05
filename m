Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359B5C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 08:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DECB06B00A2; Sun,  5 Jul 2026 04:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9D886B00A4; Sun,  5 Jul 2026 04:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8BDF6B00A5; Sun,  5 Jul 2026 04:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DAFB6B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:47:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13D5B9050E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:47:57 +0000 (UTC)
X-FDA: 84954095394.04.FBAE67B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3C47B1C0002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:47:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iS9CEnHS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783241275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzujVr18fVNG1CGW2r+8XijcSr52A2RjAyJBa5BWDew=;
	b=jhidvMUioZ4jIofzEigNCz3L2I0MQcvq+h4HmkWQcobovxfN08MwI4+6gPMFUU84QVkIAK
	P0SHq9yhu67JidcKrLZGutLGEL4WXzafnQl1suAdj/jXyUW/SHmn2PleD9FBNy1Y+bGhyt
	W+0Y4T25aU1gJzxRvELzkxAmKwuAsXI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iS9CEnHS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783241275;
	b=tCbaUrYGkpbDq34BmJTvYs2Yx3jzHW/JWtfqxVfx2atIcdQ5PdUz9jkwV2KK0hfU10XoU4
	fL5fL7tEy99W8rha+ZKoEyzBONzMMUJGDfnBSSs5UROjSdFnGI8r72JXLTsGi/7ZPEDKZo
	0sRIO8OR4rrPu/3DhrulCawbFzwv8sM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D28A61BC0;
	Sun,  5 Jul 2026 01:47:49 -0700 (PDT)
Received: from [10.57.73.18] (unknown [10.57.73.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B2283F905;
	Sun,  5 Jul 2026 01:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783241274; bh=JsVD3xgu8GOXprojLDEYGOUJZZvxJv3jyyYwMODAXWw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iS9CEnHSna+motWt1dFRve7lVcWw4D/qHVvqh/moS5wd0vM7yPfDA+kl9rn6sVGFU
	 H+hSdKJhV/DbM0rzW+yGzlZalReY3W32e5l6Dq5j2Qfbhz2RzJgZkt7Jk1cj9hsAfQ
	 dx0nYjG6ApWeQU85l/W+hKapct41k6XhsIkYVXVA=
Message-ID: <e4513917-e02a-4e60-9df5-f90085d6193d@arm.com>
Date: Sun, 5 Jul 2026 14:17:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] mm/mprotect: use huge_ptep_get() for hugetlb
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
 david@kernel.org, liam@infradead.org, riel@surriel.com, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, apopple@nvidia.com,
 rcampbell@nvidia.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, ak@linux.intel.com,
 nao.horiguchi@gmail.com, mel@csn.ul.ie, j-nomura@ce.jp.nec.com,
 pfalcato@suse.de, tglx@kernel.org, dave.hansen@intel.com,
 jpoimboe@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-7-dev.jain@arm.com>
 <20260705013337.2bbc075b508b5db36b954051@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260705013337.2bbc075b508b5db36b954051@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6oa7dhopfq6qnqh7tawejtkskobamtsu
X-Rspamd-Queue-Id: 3C47B1C0002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783241275-898834
X-HE-Meta: U2FsdGVkX18woeyBBELeSvPLiExE5dDNjI+u0XEgQauw+Vl9Rvl0AQdJ0x/1pNn0HQ3ItxprvBUumJP2vleimWR3vo+mkvFyCasOw3K+P+s/J34YbVNvBjEYfUJ0Y6DOkxTA4MFeM2LPKI1pa0pXEKna9ji6/VT9/abF0onQte7pobta4DLGQzboLfEufIc31c6RQ3oSvcfWYzJA0//+iaLMF6MDQpbkklXCrYlBa+VZ+ZPW3haDKJ5EBJeFFxNMzYM4uo8IpYRDF8+SlvsAmPc8uqI5mOpzJ1PQ4DJEfsVMyeHtJilsLTI44KQoXZ4vbGV9sPlRJ2QKeVbC3T3TiL8MgnHTBW+A0T2b7HO6jXFSwnSAy7IY1Vh3bseSZI/Yb9p2bSLN2MdqFMnHb2kGr5kFbLSKLwg00OFjdd0K4Ik4hr8h8wQt1WeNhJtkfi484BLYSJNfHqqoVj3kMnihODu8/2vB90nfCma9Du+7w4AGlVDkaYkkua5o7WeOznQAzsEEzEV8i5FY4cOexdQIdxhp9l7RlZvyvbLRFUC9d/fyD4CXSpIwwQSOklYYm+Ssh6uSxgVSu2TqcbDQMrY6y+GlsCrUhVnZyPEjxOJDXhEpq9TjvfvFqzbgh3GDkpsiCNZpM2giSAedbPTN1MG3Va+bE+qU8L28MUa3/2yXo/axpU0ePXyKtyScukyxDLkX0JessJAjkKmrzwYwxd//ebkPLXyxFF+wOzuUND+xXsuvQ9vSjUDwY2ibSSWpD7cOnzgWQH/MxUMwK3U7SPwVOGEenVmr7Ddg2odI9usRquxmOyh+E53UDnhFBKtR5R9+1TkpHMysbnRqJ6LpVzuJCspLFK/5Eq3RUiJMCDrK9/xhM7sKLrxQCbHRt0+xHpjEt7kajAieagBRI0ehAIPOdX9cTVbyKwmqpkFSBSSAbxQ/vXgIfQoxuXq4sSlHoqRqoodH7tPahzSQVPcyY2I
 PwKp8rko
 k9MJgyj+X2STOxllJ79qEqpoU6iVSSHPvvT9EIO2XY1zXw+AzRcB1sT+hdH1/NWHu4sZjzx+hFxPzNdeNx3YvkBLp5mscAytcPlA5CJbC5FE6g5Bk3hL1lMhabRDqobXD2lcrYtysrBtvSjr7aXbYEk12r6edmVzqRT6grF5xHetobr1/U5KzWxkXaXpsrftJa4vX/TXCfs0D/rAP7Txw8idYZoHM/+to7/ENETspLDkHgxBaFSOQZFITR2D/Te7e+BYmz5opjO6DfPawab+9g5ECyjfDoO5xN0cjVD3QcZk7HYp6OEbHV0nLoxnShU3eJrucVX3NNE7iSmpNUWxChp7hdaUv8fcIFEJq9BIEk3JDLOvCqWWU08I6DgAvhiKAx+IQnJMRkmZs2YXdtLoGByRHJxAMPd50UVCY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/07/26 2:03 pm, Andrew Morton wrote:
> On Fri,  3 Jul 2026 11:41:59 +0000 Dev Jain <dev.jain@arm.com> wrote:
> 
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
>>
>> So no need to backport - use the correct helper anyways.
>>
>> ...
>>
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -699,14 +699,20 @@ static int prot_none_pte_entry(pte_t *pte, unsigned long addr,
>>  		0 : -EACCES;
>>  }
>>  
>> +#ifdef CONFIG_HUGETLB_PAGE
>>  static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
>>  				   unsigned long addr, unsigned long next,
>>  				   struct mm_walk *walk)
>>  {
>> -	return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
>> -				  *(pgprot_t *)(walk->private)) ?
>> -		0 : -EACCES;
>> +	const pte_t entry = huge_ptep_get(walk->mm, addr, pte);
>> +
>> +	if (pfn_modify_allowed(pte_pfn(entry), *(pgprot_t *)(walk->private)))
>> +		return 0;
>> +	return -EACCESS;
> 
> "EACCES".
> 
>>  }
>> +#else
>> +#define prot_none_hugetlb_entry	NULL
>> +#endif
> 
> Presumably your .config resulted in this change not being tested...

Thanks for folding in the fix!

On arm64, this entire path does not exist. The prot none pagewalk is
only done on x86. Also before sending patches I do an LLM review and
very surprisingly the "language" model did not catch a language issue ...

On the other thing by Sashiko, that looks wrong. There are existing
huge_ptep_get callers not taking the lock. And, there won't be a torn
read because we are using __ptep_get() instead of *ptep.



