Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E0D0CCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0FA8E0008; Thu, 16 Oct 2025 02:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861FF8E0002; Thu, 16 Oct 2025 02:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777748E0008; Thu, 16 Oct 2025 02:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66AB78E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:27:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B81D5722B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:27:04 +0000 (UTC)
X-FDA: 84002994768.28.DA19E24
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 146C7100003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:27:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YqhTURIH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760596022; a=rsa-sha256;
	cv=none;
	b=X5twcrUM8U+jvFNq7ZuKRVyUXHC3Bd9SPbym9oRFSKsnlVzqhEoUiZ8iX2XQXUGppfKjN9
	J2XRNhD9a1GV5pqFToUkQ4+c9re4BU35OsC6v9PEOKEVFSkWr9ZQV4fWd5Gy7MIJM1cG3F
	ZWuJ2xaLUeRgON5bkm6WMFfClva3XU4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YqhTURIH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760596022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNG5Ju61aC+No7m/Kz/oSUIjtFO+hsFQlNAY/X9LidA=;
	b=aQWRRWB5zJqUfZI/XkCbpArV13ECld3Qb+F1KZNbr6piuMoyttcNR6m8I40Voacdd0mqZX
	xHo7v1Ec0G7ri6qh8mPFHyzBMMi8glHsiUJivGtp0u5xQWqEksmhERNDtI6wAoarSlA1D7
	ROJW7Dw2QRZi8j/3xGte1Iy0TTq45iY=
Message-ID: <8d88fb47-5318-433c-bb07-aeea4a025db8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760596019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNG5Ju61aC+No7m/Kz/oSUIjtFO+hsFQlNAY/X9LidA=;
	b=YqhTURIHrRbmBDr00b7O/r+QOfL1IC659ssjuugIVUHtGQNorJNmYWoZgzwPIOMeG0K9QQ
	Ev8Lylb2963TmGHQU9HxEsU8r2RZxDkZFM1xjN+0D81fkx9o+1DIUImQ/m9U3L8aBanIXG
	r40hajjDxdeZgFEQ33VXvxFbWIbWz/c=
Date: Thu, 16 Oct 2025 14:26:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, david@redhat.com
References: <20251016033643.10848-1-lance.yang@linux.dev>
 <17c4c5f9-6ac8-4914-838f-f511dfbf948f@arm.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <17c4c5f9-6ac8-4914-838f-f511dfbf948f@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 146C7100003
X-Stat-Signature: uwzihszjehs46e9ydse86kc4c8grgsa3
X-HE-Tag: 1760596021-282478
X-HE-Meta: U2FsdGVkX1+exS3HdOiMHdDyGxRtn289j6MJoBmMUjtifIAEOpg2EOWI+AVHGaKrippTXMR36mHX6oUjNqDBjmjROUZ3p+Gcxo3fpLoxnWsMUUoBq0WnMtzYwdhyk7xJw9Mpkq8NJKnwa8Eq5y1QxVraVxbpsTdtDG8jPLF+TeJiLdu+vPSxQALQGhyqhCeqWJZgQHMGtL/fAknUmdDBEODJZRZ30HF/YLJKfLx5QOwRJA2GO3xxjZvYxi0I8xIeJDhDJ0e0kVVQQsUIFxbblTz4wBjStrA3DMi8d1KF206m90/295A46PThMvp0Hmlo4xMC+4x5XxxW4EyYRM6pGSHFaxDaiazvJnc74eBY77lqDFP2xdAfzGx6O9DfcoSiyY7bCTH5aUy2xQEjZSu6RicxKmOlZDUCgSLPaI5gBsg7NUIx44STo3uDGG5eaqR18NB0w8u9dS88db2D+owBeVqQqD/kFVjNvUGQlZUg/HmtGCkFbm2/DdVwph055KEuChGqXQ7MyNQRU6NgmjjaziZ1X6UAvl/glmCRkcW88sxfZnZCDJiSVuNg+VH7bshai1kKdQ1M59fOc8AyEgJ1ULbPxAb0pYiLAewHt/lkUxnJJ7qjn/LqZJq9RFACqelhzDGudY+i/fFqtdM9lgJCo8R+6IBnKIyoFJ5q5Qab75+/UwloNTpoVLgYZaHSpokfGJyvYJzIwIzyh1cL0+342NNHulvqmQ9H0ddOl1vLktRYZAhuJ0FyRoySh7NfH63PKVPq7TELhX5HEaGYVoGjt3e2aClsWuvtxiWEOingWSHlllMrq7lgthcS2kQR+Hhnf3RIQRRXdjTjYnocowfGqKDSAZw2L8rjFq83LbRGDdzxv+nQ44eVPB754RMUlnYigi+3IdbGSVunDdjSft0rlUJ3seTDDxAJC7I2eg7mS7lTcAATnf59dP7OI+KGlCoGIG7kge2PReu/1RQ61p5
 L1c6iGLL
 0nY0PdgpaEjWJkPxYrY4+zi2lqnrCRWXreHx4kG7ltrld3RyRw9FwfuqCKz6JNJaBnb3g12MuqW+dK0tdUKBM06sHJhKQPKNhVYifnRA9YKR/dt+W9gcfkMp/ZDBKozYqNIMEbimBTM2FmK7L2A7kHbwwgYBCOfDpTOUSv2FwyBXBsY6lMo0nou87c+jWq8QoaHf4yhKCPyyHdMC9auF0EyD5i3BvmAic1ymxI02vexd8bBYw+snEBXn696nm7XFGBYos7ZFXWY4sCzF6gqTd/CDDoF9oqgw8Q8MvOAGahtlDLgKoeND7XaJwI85RW1QSOW+ahMON5VXnyCQF7dnkhrz20ckco4Ohdp4BtPKK55/kqu0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/16 14:17, Dev Jain wrote:
> 
> On 16/10/25 9:06 am, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> A non-present entry, like a swap PTE, contains completely different data
>> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>> non-present entry, it will spit out a junk PFN.
>>
>> What if that junk PFN happens to match the zeropage's PFN by sheer
>> chance? While really unlikely, this would be really bad if it did.
>>
>> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>> in khugepaged.c are properly guarded by a pte_present() check.
>>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/khugepaged.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d635d821f611..0341c3d13e9e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t 
>> *_pte,
>>           pte_t pteval = ptep_get(_pte);
>>           unsigned long pfn;
>> -        if (pte_none(pteval))
>> +        if (!pte_present(pteval))
>>               continue;
>>           pfn = pte_pfn(pteval);
>>           if (is_zero_pfn(pfn))
>> @@ -690,9 +690,10 @@ static void 
>> __collapse_huge_page_copy_succeeded(pte_t *pte,
>>            address += nr_ptes * PAGE_SIZE) {
>>           nr_ptes = 1;
>>           pteval = ptep_get(_pte);
>> -        if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +        if (pte_none(pteval) ||
>> +            (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>               add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>> -            if (is_zero_pfn(pte_pfn(pteval))) {
>> +            if (!pte_none(pteval)) {
> 
> Could save a level of indentation by saying
> if (pte_none(pteval))
>      continue;
> 
> That would make it crystal clear that we do nothing when pte is none,
> and we do something when pte is pointing to zero pfn.

Yes! That does look clearer ;)

I'll pick that up in the next spin, if one is needed.

> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>

Cheers!

> 
>>                   /*
>>                    * ptl mostly unnecessary.
>>                    */
>> @@ -794,7 +795,8 @@ static int __collapse_huge_page_copy(pte_t *pte, 
>> struct folio *folio,
>>           unsigned long src_addr = address + i * PAGE_SIZE;
>>           struct page *src_page;
>> -        if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +        if (pte_none(pteval) ||
>> +            (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>               clear_user_highpage(page, src_addr);
>>               continue;
>>           }
>> @@ -1294,7 +1296,8 @@ static int hpage_collapse_scan_pmd(struct 
>> mm_struct *mm,
>>                   goto out_unmap;
>>               }
>>           }
>> -        if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +        if (pte_none(pteval) ||
>> +            (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>               ++none_or_zero;
>>               if (!userfaultfd_armed(vma) &&
>>                   (!cc->is_khugepaged ||


