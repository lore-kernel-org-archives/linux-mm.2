Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E407D68BCB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6FE16B008C; Thu, 18 Dec 2025 02:15:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02486B0092; Thu, 18 Dec 2025 02:15:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959786B0093; Thu, 18 Dec 2025 02:15:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 863346B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:15:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5AEB9137575
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:15:24 +0000 (UTC)
X-FDA: 84231730968.22.4EA69F7
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2D0E81C000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:15:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="j8wliFt/";
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766042122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uauTuHRqpfPJlC4EeGuuyBYgKP0qHs1Wgk0vfO6QTvs=;
	b=TK2qoqOqPay8h6cPvInbxSQKup0ANMZzxbqqqkg0v2dXMc4/hO6z5jkF1tLyIcG5cbachV
	qX5cXkdhQsroDMYgpf3hG3rOSmiNUqwVLOXFk7lJNnU8E1xBghejUwwUz0v0hCU3HkBaY+
	HPKV09zG0ZevdBtsmPT9piOCsYOesGM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="j8wliFt/";
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766042122; a=rsa-sha256;
	cv=none;
	b=uPHWmBfmSexVK9miwPdIF6aTKoL47PDIs5RBk7YWtIhXGGacSldqZfp0JkKmDIHuvgZewU
	rRZPXR5pH+wd4gOp6irN6dLSW+qdPP+RCBWmbldhCJVM32P4m+wu9AOQdLNyCmOttD45sX
	KgeXSTS4FBUf6SA7higqMhf2a+H2mng=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766042118; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uauTuHRqpfPJlC4EeGuuyBYgKP0qHs1Wgk0vfO6QTvs=;
	b=j8wliFt/RDLD/6uZ0ks42IvRzsIBbj7t0wGRM7ogC3qpzrZ74zNFj1YqP9y0lwYBzuOfSCun2nbCNWQlQQqwUBEid7PucY5LmdMfMyrVG0kWRh6chfKW9lde4uStbbLxxRMfBTOjgm2y593alrWudh0TTwaMi1XWmVw1XvsH3gA=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wv7ehcK_1766042116 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Dec 2025 15:15:17 +0800
Message-ID: <96c0adcc-abfd-4a44-be93-1c6bd7942d6d@linux.alibaba.com>
Date: Thu, 18 Dec 2025 15:15:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] arm64: mm: support batch clearing of the young
 flag for large folios
To: Ryan Roberts <ryan.roberts@arm.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
 <1beaa7de-4b31-4f19-abee-83872f868e28@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1beaa7de-4b31-4f19-abee-83872f868e28@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D0E81C000E
X-Stat-Signature: 717rfg7drrcxsabrca8n9nh7z9c9oxfh
X-HE-Tag: 1766042120-987956
X-HE-Meta: U2FsdGVkX1/wUx5dKId+/LnQFeBuFdc8ry/Dh84Ttew9e9YzwovDvpZFz9b7SIcgD+4jWBRlhpDcAglxYmIDYpY7Qqut9exA7EEaP5Pw8kXsy8agev5qF+lgs+cYfFPwxhW6ETQD9dkRjkypFIoCT0Ryc0Kj2y7yDzA90jPh3sfNWaO/4Ak4TlzrYpdMmiQC84FhYmDqr0cH/enL/JafySbL8sJI6qsxVOIEt/2/HpJaRirjO3NoErEDv85JE8waTw+Ry9LqTCHyTvG3SpeTDaFZsK04RdHVdbVmYoVNFjP/6alk8+rVryT1mEBvlqwK7qEf6LW84vAyCL8kaDtflK175tc8iGSgjuODhWbXnGqd9PBpjqsoVyLzVqQZZ075n4FlVjkb9T6A+i95t0DqEE7P2mKy1dBlNN1PK6SRUqUHBYrR4CwxOnOcJuOw3OOuBwt2eSUfkQZZJeQYhjDF09nZxMFs19X+LQxthcZxqjjTRuZA84n/pzUs7hHc99zN/gQFWOYMynBFGHanW+WrkjQ7QnzVgu16j1nfMJtdgZn+MAotMhuzWFwr71Bv8drQeiJWnC6/RP+vHcHq4uwcN46hsIyuH+EI0lfWlNVCRMQIBkCkTbK9v6KDhfkzTwOwcljADQTlFzyJvHye95IyKyH3fQRYKy+guTtjoxTzcfI6dCTrAgjNwyfZYZmeDAti2pumWy9gTC0iRmyqLB9rGzZrLuZfMREIobTWOdxxe1g008muBOaa94JFRV78kFFJc6vO+JDixcZrHXUKefHV+W9uCk0gHQb+dCAe9jKqinAhk1DMmgJSK4h3HhOMWW8y1IGCIoB3VJiE/jqh0N6jDQgu+//Votyk22TQ0td+soo4HJthLBbR1W2Kt3q4gi49n5saimUu8pnApOeA3nhibZpUBsdPvjyB6hM360yIQK/h+8+CRua450fuHxsIoSydqsdpCWQiEmkHtRxPw8I
 r0TgcbW7
 14UlXFn+PE06WGG7dRGjzXxfbRuveu8+/pcVASWoPCvkeAuq7R+Y8hu+hmDFWnKtgJI3RNbzV3zv7OQX6zvJba+pGlGkLt3XDwt1/0ByovA4N4oebfe36Md6Kf/sEbab07jrfaNbhZwc1JpY0Dx1JJEtmc5PspZ5vjp6G1rPutV6QRZNQeSD+eQdczhfd8GVSEmEx2A2ycfl3fem5mWUw2M4uwJAGDoISZDPbAyzyArJ3A1EsDUMMAm2R0vhY5OVdZcyITnvSszdC3DzVcd2XU8yUt1/w3MHvE+Uawwkj5rMELZk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 23:43, Ryan Roberts wrote:
> Sorry I'm a bit late to the party...

Never mind. It's not late and comments are always welcome :)

> On 11/12/2025 08:16, Baolin Wang wrote:
>> Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
>> only clear the young flag and flush TLBs for PTEs within the contiguous range.
>> To support batch PTE operations for other sized large folios in the following
>> patches, adding a new parameter to specify the number of PTEs.
>>
>> While we are at it, rename the functions to maintain consistency with other
>> contpte_*() functions.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h | 12 ++++-----
>>   arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
>>   2 files changed, 37 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 0944e296dd4a..e03034683156 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1679,10 +1679,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
>>   extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>   				unsigned long addr, pte_t *ptep,
>>   				unsigned int nr, int full);
>> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>> -				unsigned long addr, pte_t *ptep);
>> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>> -				unsigned long addr, pte_t *ptep);
>> +extern int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>> +				unsigned long addr, pte_t *ptep, unsigned int nr);
>> +extern int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>> +				unsigned long addr, pte_t *ptep, unsigned int nr);
> 
> The "contpte_" functions are intended to be private to the arm64 arch and should
> be exposed via the generic APIs. But I don't see any generic batched API for
> this, so you're only actually able to pass CONT_PTES as nr. Perhaps you're
> planning to define "test_and_clear_young_ptes()" and "clear_flush_young_ptes()"
> in later patches?

Right. This is a preparation patch, and will be used in patch 2.

>>   extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>   				pte_t *ptep, unsigned int nr);
>>   extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>> @@ -1854,7 +1854,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>>   	if (likely(!pte_valid_cont(orig_pte)))
>>   		return __ptep_test_and_clear_young(vma, addr, ptep);
>>   
>> -	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
>> +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
>>   }
>>   
>>   #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
>> @@ -1866,7 +1866,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>>   	if (likely(!pte_valid_cont(orig_pte)))
>>   		return __ptep_clear_flush_young(vma, addr, ptep);
>>   
>> -	return contpte_ptep_clear_flush_young(vma, addr, ptep);
>> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>>   }
>>   
>>   #define wrprotect_ptes wrprotect_ptes
>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>> index c0557945939c..19b122441be3 100644
>> --- a/arch/arm64/mm/contpte.c
>> +++ b/arch/arm64/mm/contpte.c
>> @@ -488,8 +488,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>   }
>>   EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
>>   
>> -int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>> -					unsigned long addr, pte_t *ptep)
>> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>> +					unsigned long addr, pte_t *ptep,
>> +					unsigned int nr)
>>   {
>>   	/*
>>   	 * ptep_clear_flush_young() technically requires us to clear the access
>> @@ -500,39 +501,56 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>   	 * having to unfold.
>>   	 */
>>   
>> +	unsigned long start = addr;
> 
> Personally I wouldn't bother defining start - just reuse addr. You're
> incrementing start in the below loop, so it's more appropriate to call it addr
> anyway.

OK.

>> +	unsigned long end = start + nr * PAGE_SIZE;
>>   	int young = 0;
>>   	int i;
>>   
>> -	ptep = contpte_align_down(ptep);
>> -	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>> +	if (pte_cont(__ptep_get(ptep + nr - 1)))
>> +		end = ALIGN(end, CONT_PTE_SIZE);
>>   
>> -	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
>> -		young |= __ptep_test_and_clear_young(vma, addr, ptep);
>> +	if (pte_cont(__ptep_get(ptep))) {
>> +		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
>> +		ptep = contpte_align_down(ptep);
>> +	}
>> +
>> +	nr = (end - start) / PAGE_SIZE;
>> +	for (i = 0; i < nr; i++, ptep++, start += PAGE_SIZE)
> 
> Given you're now defining end, perhaps we don't need nr?
> 
> 	for (; addr != end; ptep++, addr += PAGE_SIZE)
> 		young |= __ptep_test_and_clear_young(vma, addr, ptep);

Yes, good point.

>> +		young |= __ptep_test_and_clear_young(vma, start, ptep);
>>   
>>   	return young;
>>   }
>> -EXPORT_SYMBOL_GPL(contpte_ptep_test_and_clear_young);
>> +EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
>>   
>> -int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>> -					unsigned long addr, pte_t *ptep)
>> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>> +				unsigned long addr, pte_t *ptep,
>> +				unsigned int nr)
>>   {
>>   	int young;
>>   
>> -	young = contpte_ptep_test_and_clear_young(vma, addr, ptep);
>> +	young = contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
>>   
>>   	if (young) {
>> +		unsigned long start = addr;
>> +		unsigned long end = start + nr * PAGE_SIZE;
>> +
>> +		if (pte_cont(__ptep_get(ptep + nr - 1)))
>> +			end = ALIGN(end, CONT_PTE_SIZE);
>> +
>> +		if (pte_cont(__ptep_get(ptep)))
>> +			start = ALIGN_DOWN(start, CONT_PTE_SIZE);
>> +
> 
> We now have this pattern of expanding contpte blocks up and down in 3 places.
> Perhaps create a helper?

Sounds reasonable. How about the following helper?

static pte_t *contpte_align_addr_ptep(unsigned long *start, unsigned 
long *end,
                                         pte_t *ptep, unsigned int nr)
{
         unsigned long end_addr = *start + nr * PAGE_SIZE;

         if (pte_cont(__ptep_get(ptep + nr - 1)))
                 *end = ALIGN(end_addr, CONT_PTE_SIZE);

         if (pte_cont(__ptep_get(ptep))) {
                 *start = ALIGN_DOWN(*start, CONT_PTE_SIZE);
                 ptep = contpte_align_down(ptep);
         }

         return ptep;
}

