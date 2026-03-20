Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB981093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E225D6B0429; Thu, 19 Mar 2026 22:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3816B042D; Thu, 19 Mar 2026 22:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA986B042E; Thu, 19 Mar 2026 22:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BBA5A6B0429
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:59:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BFCB13BAC0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:59:54 +0000 (UTC)
X-FDA: 84564936708.09.6C49A0F
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf14.hostedemail.com (Postfix) with ESMTP id 83601100002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:59:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qOq85rmZ;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773975592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhUcYGT74pFt2SXoDhdjrHorGD5n36pkyqXtT2iygtA=;
	b=Z3NkfCClWfXqIN2hkPSXpHYnsLszsHFrTJFoOMLA9XTqPIz9oYaaQNPpA3qNctHTA5CHzP
	BCvfHiUGaisusMcICxIiEheGr0CpTEFmIsz5hLUu1NU2opkuyCE+6eUTiQiHrFJGdCpyoI
	K18PpkufDhFfWqw+9J9U/gCLh8qgii0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qOq85rmZ;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773975592; a=rsa-sha256;
	cv=none;
	b=NqKwOuJ+LrLR6jpL6viiJzFxZzHMbmrJdZvmJU2hLVp3ZBt5AVhwBZN4nUyPt7zcQ14vfF
	MxmWGec66EuvhBntwhYkeLUyZCQ/xI24Xiwaj0ZtQ4gOywTgV1yLCpz8D2IROjLyatJwXn
	G6SOt39QT2si1ZqDLMUXMAGTuNRJFpY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773975587; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lhUcYGT74pFt2SXoDhdjrHorGD5n36pkyqXtT2iygtA=;
	b=qOq85rmZwOIVTdVqr6Yak8xSkbjs9YevMrBHIjXyBujf7Ro+f35lSUQ+PPKxWkXtlYqtQyQZ1GBiflFDzM5rt/Vn/vmq7dKYCC+fkM+f7oOIFbtBEQN8SjoTNMWz9k+hxRM9oPHMZ8n7gNoi03VeLFKnWqaw+oyxpUJqH0RkpGI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.KDEFk_1773975585;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.KDEFk_1773975585 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 10:59:46 +0800
Message-ID: <c01087cc-0e81-4284-850a-992c0abd5d32@linux.alibaba.com>
Date: Fri, 20 Mar 2026 10:59:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm: change to return bool for
 ptep_test_and_clear_young()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <3fa94c3c89fd93fe22c8cb59967f064787d686aa.1773890510.git.baolin.wang@linux.alibaba.com>
 <1e664c93-603a-4c16-94f4-595a90744980@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1e664c93-603a-4c16-94f4-595a90744980@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 83601100002
X-Stat-Signature: p5nx6fuqjyzb1zj3gg9hkcj9k9siyr6n
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773975591-902862
X-HE-Meta: U2FsdGVkX18qvOCIZRE8s8YQze18eDPH/+HRxT0NHBy//ieFPlwjFS9ullc37MdLQxTmoHPhYa3qOAH6GpPQYKwweaP8brvwfhXLUrJj80Abgi/uPksLdjMTE7XnRMr2E6WBN0tdYC09PBWMYZXJlUzU9xwkH7BVea3WSBcSCyLs/UuCxhwgfNO8ipwt5qOCALlz+grS42KunQoJU3HFFJs7IphUzQ91Uz5sbB4cSCWeWFkKExLIxXKKiXs3uvrj8oNjhboQbNYYH5CKXmrmwtkLap6ksOd3n2zHMTZ9t9paqqJJApDgbQZBFfolVTbGbk0qlMGL1OrTEjDF3dp4M3cpfzmHmg/mBWea9GgKbz/NZbHXDlwozYrN3ye5pCIyZxZdeTjdngxSRFBINup2k9qCggvl8BSGpVVUJ028WhqWBHKh8GCWe6PCGnVrVezWuTAXUusYEpP8MSSsni9Ndta87jalPg5P0Td+xBSQbBScUaXv+XxDKXTgO+UdGV8Esuj8qVFdOuZgxeDJt32w+AMJXLGqnmDbX2JdUKBBjhU6Q5E6BRzWUKa+Q1LTJRIBmW+5dKa8OrrU4nb4Vfo/b7teJJr8alz2/e7Mr89rrFGiLdpp4Q0CzOsFfhvDVLevTkkETwU2A1K+9MW4yiuj+4s6vuK7Pwf5isUf6lj4L7ZvGDiv1dE9CiY0ZHXgBpdJH4WylZJQv24+HDvm0O75lNU9lZpFI/9hz499rAbKWdRuUVj8tefYNMfRDzRSGI5pb3pCsFKGQ9RRgwIVd5SAFO8bHjCkQoRICNhVwDCwlwsSXBZPJK2XAmdZD/p9wD4U0xNQe7CL8VYC8s5ygiYVg/lcaqO58NP+kd0HNe26aLXcMQOwPBt8OnQHhTvWptcYyxzwiE4i9g9SNn1l8CznnI3CIB9DmDz2N7IXW71lX8Ub1xq78GnbvMB1d5X67V23nKlBnHG1U8Bo5lhXgDc
 5Xs0nU1R
 M55a/2T6JJtO3Vdip21vBa5JxkbhGzPgybYC6seTaiaY28GEOI32yHsKqSanKPWKHyExRTgOV/lJ0uVHFZtoSirR1aj4JBlcHFxNFrEwnM1Gx39e+Q3B65Tymp/UR6vTJ5c8lrwlxadBJSaDu3mFXFcQrwSzqVmWAnI1EEj2eMg+uhTg1+XvIoivXXKVfPzqUcaduNDiYzNL7wulRmlqwNW4mA2CCNFQSs8NpjpZ//zZUjJhGpxJv/X9t8VoPUdeFTXzLO72ALkM+yEMi57knEO0H+9oD1uTodl+zb45oTGXvNLB0nbfvgTowJ/OAiyJaeF3MRcathCd+3dxKa882zTyquNhnl+oC0ydwzpU4D1rq7/ezoqnmN/wOEroBvrz8HV/EagMt/i8hxrDONrQQQkTqdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 7:28 PM, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 11:24:00AM +0800, Baolin Wang wrote:
>> Callers use ptep_test_and_clear_young() to clear the young flag and check
>> whether it was set. Change the return type to bool to make the intention
>> clearer.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Couple nits about dropping externs below but otherwise LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks for reviewing.

>> ---
>>   arch/arm64/include/asm/pgtable.h             |  8 ++++----
>>   arch/arm64/mm/contpte.c                      |  4 ++--
>>   arch/microblaze/include/asm/pgtable.h        |  2 +-
>>   arch/parisc/include/asm/pgtable.h            |  6 +++---
>>   arch/powerpc/include/asm/book3s/32/pgtable.h |  4 ++--
>>   arch/powerpc/include/asm/book3s/64/pgtable.h |  6 +++---
>>   arch/powerpc/include/asm/nohash/pgtable.h    |  4 ++--
>>   arch/riscv/include/asm/pgtable.h             |  4 ++--
>>   arch/riscv/mm/pgtable.c                      |  8 ++++----
>>   arch/s390/include/asm/pgtable.h              |  4 ++--
>>   arch/x86/include/asm/pgtable.h               |  4 ++--
>>   arch/x86/mm/pgtable.c                        |  6 +++---
>>   arch/xtensa/include/asm/pgtable.h            |  6 +++---
>>   include/linux/pgtable.h                      | 16 ++++++++--------
>>   14 files changed, 41 insertions(+), 41 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index ab451d20e4c5..8c651695204c 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1282,7 +1282,7 @@ static inline void __pte_clear(struct mm_struct *mm,
>>   	__set_pte(ptep, __pte(0));
>>   }
>>
>> -static inline int __ptep_test_and_clear_young(struct vm_area_struct *vma,
>> +static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
>>   					      unsigned long address,
>>   					      pte_t *ptep)
>>   {
>> @@ -1646,7 +1646,7 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
>>   extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>   				unsigned long addr, pte_t *ptep,
>>   				unsigned int nr, int full);
>> -int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>> +bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>   				unsigned long addr, pte_t *ptep, unsigned int nr);
>>   int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>>   				unsigned long addr, pte_t *ptep, unsigned int nr);
>> @@ -1813,7 +1813,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>>   }
>>
>>   #define test_and_clear_young_ptes test_and_clear_young_ptes
>> -static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
>> +static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
>>   					    unsigned long addr, pte_t *ptep,
>>   					    unsigned int nr)
>>   {
>> @@ -1824,7 +1824,7 @@ static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
>>   }
>>
>>   #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
>> -static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>> +static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
>>   				unsigned long addr, pte_t *ptep)
>>   {
>>   	return test_and_clear_young_ptes(vma, addr, ptep, 1);
>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>> index 1519d090d5ea..0b88278927a4 100644
>> --- a/arch/arm64/mm/contpte.c
>> +++ b/arch/arm64/mm/contpte.c
>> @@ -508,7 +508,7 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>   }
>>   EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
>>
>> -int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>> +bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>   					unsigned long addr, pte_t *ptep,
>>   					unsigned int nr)
>>   {
>> @@ -525,7 +525,7 @@ int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>   	 */
>>
>>   	unsigned long end = addr + nr * PAGE_SIZE;
>> -	int young = 0;
>> +	bool young = false;
>>
>>   	ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
>>   	for (; addr != end; ptep++, addr += PAGE_SIZE)
>> diff --git a/arch/microblaze/include/asm/pgtable.h b/arch/microblaze/include/asm/pgtable.h
>> index ea72291de553..7678c040a2fd 100644
>> --- a/arch/microblaze/include/asm/pgtable.h
>> +++ b/arch/microblaze/include/asm/pgtable.h
>> @@ -318,7 +318,7 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
>>
>>   #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
>>   struct vm_area_struct;
>> -static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>> +static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
>>   		unsigned long address, pte_t *ptep)
>>   {
>>   	return (pte_update(ptep, _PAGE_ACCESSED, 0) & _PAGE_ACCESSED) != 0;
>> diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
>> index f6fb99cb94d9..d5e39f2eb415 100644
>> --- a/arch/parisc/include/asm/pgtable.h
>> +++ b/arch/parisc/include/asm/pgtable.h
>> @@ -438,16 +438,16 @@ static inline pte_t ptep_get(pte_t *ptep)
>>   }
>>   #define ptep_get ptep_get
>>
>> -static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
>> +static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
>>   {
>>   	pte_t pte;
>>
>>   	pte = ptep_get(ptep);
>>   	if (!pte_young(pte)) {
>> -		return 0;
>> +		return false;
>>   	}
>>   	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
>> -	return 1;
>> +	return true;
>>   }
>>
>>   int ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
>> diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
>> index 001e28f9eabc..2a889e2093e8 100644
>> --- a/arch/powerpc/include/asm/book3s/32/pgtable.h
>> +++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
>> @@ -295,8 +295,8 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
>>    * for our hash-based implementation, we fix that up here.
>>    */
>>   #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
>> -static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
>> -					      unsigned long addr, pte_t *ptep)
>> +static inline bool __ptep_test_and_clear_young(struct mm_struct *mm,
>> +					       unsigned long addr, pte_t *ptep)
>>   {
>>   	unsigned long old;
>>   	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
>> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> index 1a91762b455d..25e3a86943e2 100644
>> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
>> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> @@ -349,13 +349,13 @@ static inline unsigned long pte_update(struct mm_struct *mm, unsigned long addr,
>>    * For radix: H_PAGE_HASHPTE should be zero. Hence we can use the same
>>    * function for both hash and radix.
>>    */
>> -static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
>> -					      unsigned long addr, pte_t *ptep)
>> +static inline bool __ptep_test_and_clear_young(struct mm_struct *mm,
>> +					       unsigned long addr, pte_t *ptep)
>>   {
>>   	unsigned long old;
>>
>>   	if ((pte_raw(*ptep) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
>> -		return 0;
>> +		return false;
>>   	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
>>   	return (old & _PAGE_ACCESSED) != 0;
>>   }
>> diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
>> index e6da5eaccff6..43cf52f0c7d6 100644
>> --- a/arch/powerpc/include/asm/nohash/pgtable.h
>> +++ b/arch/powerpc/include/asm/nohash/pgtable.h
>> @@ -101,8 +101,8 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
>>   }
>>   #endif
>>
>> -static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>> -					    unsigned long addr, pte_t *ptep)
>> +static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
>> +					     unsigned long addr, pte_t *ptep)
>>   {
>>   	unsigned long old;
>>
>> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
>> index ab4ce1cc9d9c..fb010dcdf343 100644
>> --- a/arch/riscv/include/asm/pgtable.h
>> +++ b/arch/riscv/include/asm/pgtable.h
>> @@ -659,8 +659,8 @@ static inline void pte_clear(struct mm_struct *mm,
>>   extern int ptep_set_access_flags(struct vm_area_struct *vma, unsigned long address,
>>   				 pte_t *ptep, pte_t entry, int dirty);
>>   #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG	/* defined in mm/pgtable.c */
>> -extern int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long address,
>> -				     pte_t *ptep);
>> +extern bool ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long address,
>> +				      pte_t *ptep);
> 
> Let's drop the extern.

Yes, I followed the original code style, but dropping the extern looks 
reasonable to me. Will do.

>>   #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
>>   static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>> diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
>> index b1ed2f14dc3a..de24a19e8ebd 100644
>> --- a/arch/riscv/mm/pgtable.c
>> +++ b/arch/riscv/mm/pgtable.c
>> @@ -29,12 +29,12 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
>>   	return true;
>>   }
>>
>> -int ptep_test_and_clear_young(struct vm_area_struct *vma,
>> -			      unsigned long address,
>> -			      pte_t *ptep)
>> +bool ptep_test_and_clear_young(struct vm_area_struct *vma,
>> +			       unsigned long address,
>> +			       pte_t *ptep)
>>   {
>>   	if (!pte_young(ptep_get(ptep)))
>> -		return 0;
>> +		return false;
>>   	return test_and_clear_bit(_PAGE_ACCESSED_OFFSET, &pte_val(*ptep));
>>   }
>>   EXPORT_SYMBOL_GPL(ptep_test_and_clear_young);
>> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
>> index 1c3c3be93be9..da1a7a31fa22 100644
>> --- a/arch/s390/include/asm/pgtable.h
>> +++ b/arch/s390/include/asm/pgtable.h
>> @@ -1164,8 +1164,8 @@ pte_t ptep_xchg_direct(struct mm_struct *, unsigned long, pte_t *, pte_t);
>>   pte_t ptep_xchg_lazy(struct mm_struct *, unsigned long, pte_t *, pte_t);
>>
>>   #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
>> -static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>> -					    unsigned long addr, pte_t *ptep)
>> +static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
>> +					     unsigned long addr, pte_t *ptep)
>>   {
>>   	pte_t pte = *ptep;
>>
>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
>> index 54289f4587a4..563a6289ea44 100644
>> --- a/arch/x86/include/asm/pgtable.h
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -1232,8 +1232,8 @@ extern int ptep_set_access_flags(struct vm_area_struct *vma,
>>   				 pte_t entry, int dirty);
>>
>>   #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
>> -extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
>> -				     unsigned long addr, pte_t *ptep);
>> +extern bool ptep_test_and_clear_young(struct vm_area_struct *vma,
>> +				      unsigned long addr, pte_t *ptep);
> 
> Let's drop the extern.

Ack.

