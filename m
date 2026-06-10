Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD791CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 07:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39806B0005; Wed, 10 Jun 2026 03:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11636B0088; Wed, 10 Jun 2026 03:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E1A6B008A; Wed, 10 Jun 2026 03:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8AF86B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:02:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78F601208DF
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:02:49 +0000 (UTC)
X-FDA: 84863110458.06.54B79EF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 506C9100009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:02:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XxFrg+Dh;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781074967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUV2dBdfz9pEk99+BFlDqBJiEcmOKYxgOiM10ewEsLg=;
	b=BoawRzvqv4mFWiivOn7KOAm7iJapaSPzzs/fG6oc+2BHHPJRyLUAYgMD3Q0zdL146DsiWV
	6ZEEX/jz/78d7Wykt98NZvFw9Oju88sxBbUCJwYydRinnw+HTkKyQjVvUbFd3ecnGWRcWy
	WWQsf2x296As06YUonzxgDqZR79w/os=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XxFrg+Dh;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781074967;
	b=Q/5xmxbla2ji39SzJGLDBNddveGqZ5PBwKpePWv6mDV2Gb0i9yYOmlw/Qu0Rye/Mp86ej4
	mfH/JzmYFt3oDPoN1d1HHfRfIChdMoS4G9Oo2HGjrFuMR3YKlIdwaLCFBUztE8LEj92Prl
	M9Xxc73jmLIV0gSLrQdIMkiN3wMssz8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22FFB1570;
	Wed, 10 Jun 2026 00:02:41 -0700 (PDT)
Received: from [10.164.148.46] (MacBook-Pro.blr.arm.com [10.164.148.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BDAAC3FD88;
	Wed, 10 Jun 2026 00:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781074965; bh=mjeJyLvpHgCIWn39mq3WZXEt/2CgxvbNKK+rP/DAWSI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XxFrg+Dh0yhaVjDbomgvIHuvRQUN8RCxS2FR3mVktSR6DHlCOYKWQWc4TngGprxJ1
	 F1eg35vzTb+d4Y/H3rQIDxzazn8ZcU9uDB3+Rzquh5+wmYfEI+vmTXZV5vfnXcm4Go
	 pMXy1nFEn+SGarHixrLYWiolF8MNe3dKBvAueeJQ=
Message-ID: <acb66e5d-188c-4239-95f8-172bbbb7f114@arm.com>
Date: Wed, 10 Jun 2026 12:32:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/12] mm/rmap: convert page -> folio for hwpoison
 checks
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, chrisl@kernel.org, kasong@tencent.com, hughd@google.com,
 liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-2-dev.jain@arm.com>
 <f487d61c-844d-46b6-8522-375549d49346@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <f487d61c-844d-46b6-8522-375549d49346@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 506C9100009
X-Stat-Signature: i5kke6f9k7855ds566miwc68zjm5n96y
X-Rspam-User: 
X-HE-Tag: 1781074967-799718
X-HE-Meta: U2FsdGVkX1+jlb6q+QWL+/QSUTdBQftWRDKCpgodg09vL0N7BYfSMLRfbK3kd7UKk5k1miv9LYtc3vFoGtabHhqZ5WkhJRuC6aHgoldrR0PWIDrCvBlsAGV3c1Cb+AUPTnbKO9ffalnngMA8brh6uuuVgqy2YIQchFIhb7OI8+U55Gw9Xt08g/+gBAZUyXRaSZBav/b1N/xbN4KeeMStPJ/d2X6g+D9/FpkdFhspseAblxnm8Sdo6PC9DdynW9JangsEVJJlviO4W1W89ob3oM4kkUBBdsLzoH4MmwAIv6LbfvswCwMeSp12WHoHNI6o25lojWjsagr1oRPEbg1Xqfg+Uq+9blT5DVtAyws+XTLR+5icNuubCV1uUkTKJ37YNXkbPZyTy61oA4JrquTb2a1q/EVDys2kwIyay6uKszJU+7RBwoI9R+fTL6GifvrGQ8g9W+cR7racKcI5k47aBC1R9kccK4dsv5hwtXrJ0mVHEWG+m9Z6fYwAr3jCIouXQ5/M1RawIAm59jC9SkkJbkV8hMisbHJEXeaJnf2zB4rUduKr3dhBHX85MBSXSW5wgT2a8ljU5JRsMRtyKTn098fg/N5MSGhGwgmnrGRv18E5FhUJaa7SckYSU3PNk6sgxUjdqBJDsrKGSZbv2O6TVD30D8syGO4qI3z5b62lg+xxTca/l8fG4rb21YuHbRAbE1XFCtUgNty/obt/9z9/sjlrlkoaCHLN/ilcxLP5yAcGAdNTMlaFzjRQ8vo3whSV7G4/nFehovszUUXkMarsLIorukbfSCAEQGI5ovCL1xbmAUHB2PAR30w4hWfvsgCZ+5n8QWWDJgJ0F0eZtQ/BWbPlaN6HfyjrccpzFHece1cqgDiSRmoEyavjO5Lh5scDqRE7/GfkNSej2X+U3koxpWa/DlpYGCiLq55li91blT6GEJLBQueMxO4Q0oLfVAfhrdnrCEYyqzfzVGbDEWY
 zEc/Oxku
 sEp7dYp7e/3eN1eqKMInEL2FKFYlrzng6OZIncAFhYd9VK/coMudJcY0rwJIRC4anAzcoT0XyV92KL2+KjFpYdtqa/arTTpOfvIx1gAx5JfU2Qv1hciEojMW3O5J5Vis5RI399JwBzeFQBsrYalavW5zM37+tjaW2I9lkylrqMJi1IImTYpkDBqE/HTKoOCzMvpC+Zom0Bfun0Y3+83dc8vSz4jl9bKEhM6Qbd0Yvj0z4S5QAA1KpSM/elBbgyLTFpdxq75IU0cIbF9EyQIahM0c0x/J420rY4LOl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/06/26 7:14 pm, David Hildenbrand (Arm) wrote:
> On 5/26/26 08:36, Dev Jain wrote:
>> If any page of a folio is poisoned, try_to_unmap() is called with the
>> intent to remove any mappings pointing to any part of the folio.
>>
>> Therefore, an hwpoison check on a single page does not make sense
>> (although everything works out because the memory-failure path sets
>> hwpoison on the head page too). Convert these checks to check whether
>> the folio has at least one hwpoisoned page.
> 
> I think the reasoning is different and should better be described:
> 
> 1) For hugetlb, we will always get subpage == head page (single PTE -> first PFN).
> 
> try_memory_failure_hugetlb()->try_memory_failure_hugetlb()->hugetlb_update_hwpoison()
> will do the folio_test_set_hwpoison().
> 
> folio_test_set_hwpoison() is the same as setting it on the head page.
> 
> For hugetlb, subpage==headpage
> 
> That's why PageHWPoison(subpage) used to work.
> 
> 
> 2) try_to_unmap() cannot handle large folios (besides hugetlb folios).
> 
> unmap_poisoned_folio() spells that out. That's why subpage==headpage right now.

Should have mentioned: subpage != headpage for contpte mapped hugetlb folios
on arm64.

But I think even in that case, hwpoison is not set on the specific pfn, it is
set only on the head page. So I think folio_test_hwpoison() would suffice.

> 
> 
> That's why PageHWPoison(subpage) used to work.
> 
>>
>> While at it, convert VM_BUG_* to VM_WARN_*.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index fb3c351f8c458..430c91c8fe2ae 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2116,10 +2116,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  			bool anon = folio_test_anon(folio);
>>  
>>  			/*
>> -			 * The try_to_unmap() is only passed a hugetlb page
>> -			 * in the case where the hugetlb page is poisoned.
>> +			 * The try_to_unmap() is only passed a hugetlb folio
>> +			 * in the case where the hugetlb folio contains a
>> +			 * poisoned page.
>>  			 */
>> -			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
>> +			VM_WARN_ON_FOLIO(!folio_contain_hwpoisoned_page(folio), folio);
> 
> I think we could also just use folio_test_hwpoison() here.
> 
>>  			/*
>>  			 * huge_pmd_unshare may unmap an entire PMD page.
>>  			 * There is no way of knowing exactly which PMDs may
>> @@ -2198,7 +2199,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  		/* Update high watermark before we lower rss */
>>  		update_hiwater_rss(mm);
>>  
>> -		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
>> +		if (folio_contain_hwpoisoned_page(folio) && (flags & TTU_HWPOISON)) {
>>  			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>>  			if (folio_test_hugetlb(folio)) {
>>  				hugetlb_count_sub(folio_nr_pages(folio), mm);
> 
> And here. Which might be cleaner, because folio_contain_hwpoisoned_page() is so
> far never called on hugetlb folios.
> 
> Because folio_set_has_hwpoisoned() is only ever used on THPs, not hugetlb. It
> would currently work, but the expectation so far is that these primitives are
> for small folios+thp, not hugetlb.
> 
> You could add a comment here, that with TTU_HWPOISON, we only ever expect small
> folios or hugetlb folios for now.
> 


