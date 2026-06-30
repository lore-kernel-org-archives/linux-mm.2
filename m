Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 705DCC43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 11:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575426B0095; Tue, 30 Jun 2026 07:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D206B009F; Tue, 30 Jun 2026 07:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48AC36B00AE; Tue, 30 Jun 2026 07:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28C3C6B0095
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:35:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F04C8E0D7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:34:59 +0000 (UTC)
X-FDA: 84936372318.01.DD12BA2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 614D54000F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:34:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=c638sO79;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782819297;
	b=I/doCNPjCXJS2EK5FmHGXNQXmPOgKdWPNcnOdN0cp17cBBJu+Kg0kqD4Nj2GZRC+nXziUJ
	LDY13QW3VAv+C8JvZE3aPDCwIISxLKx2ZPy/ks4ZXZcJtEAisLjtK5/efZQgQAgZUttLdK
	L5eWunyyEOpOlp6V4MXflbTHaZVt7/4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782819297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BpA3xni91Plk3YQ2lcE0OfAFTwmeOKPp038yIxg0jMY=;
	b=5emX8pwaxJx+xAes4q4I4nqlriaKQnc8tkR9k9HhkhsuMclxwbsIv6qjCaterKs9XsOXAq
	1geggrAlkir30+fmyPwuji0iHwsAaZ0lOBHILGeJwfeZUr0EWI2KcyVR2YAMf58NrpihkS
	WyXPdMX/DENo/Z8PN+9woc72FvzKy5Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=c638sO79;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D61AE2C1C;
	Tue, 30 Jun 2026 04:34:51 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A140F3F673;
	Tue, 30 Jun 2026 04:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782819296; bh=36e7WO1Yf+y2VcPGOuHpBYDw36f17/2PgIYLivcK1GA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c638sO79AScfINz5lZY6NrPZdHX2ctsv9So73SM3zl35Hsiy/29ZmsbJxrZ30q+le
	 e8zRVT9LylhWv0Ori+TlPSrHZw89TwAHrD9JM74Wu6c/1CyEbgAzceXuUBzpPnNzSf
	 MJzWFP/AotQfgT6G7BDiLWvW1fbUjAPzzb7V+pCE=
Message-ID: <6fdc0cbd-0880-4594-bf33-a2993ac2fe60@arm.com>
Date: Tue, 30 Jun 2026 17:04:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lance Yang <lance.yang@linux.dev>
Cc: linmiaohe@huawei.com, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rcampbell@nvidia.com, apopple@nvidia.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 mel@csn.ul.ie, nao.horiguchi@gmail.com, ak@linux.intel.com,
 j-nomura@ce.jp.nec.com, pfalcato@suse.de, dave.hansen@intel.com,
 tglx@kernel.org, jpoimboe@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <0fabee2a-edb7-41c8-91ec-8cf0646c9e83@kernel.org>
 <20260629074802.42727-1-lance.yang@linux.dev>
 <a1c6c3dd-8db1-4db6-b032-e350bacc4577@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <a1c6c3dd-8db1-4db6-b032-e350bacc4577@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 614D54000F
X-Stat-Signature: pzzchwehjp5ksuruw4eubz86exnatqy3
X-HE-Tag: 1782819297-78475
X-HE-Meta: U2FsdGVkX1/4PgFH4DZeV3CduudSSCmwEeGzLyIQDnQ/bVL+uf6EVV0VXKXme80Z6p6ULkwEw7zjVEMyG02Fpmu4m/6Hh7krN1+eAFl0SCV/QHZGXC9Im0NMlQweiP1DwxBnWTGEVHxkzHaJaJnXP8Xe3Lk/D+bO8egbHIZz/yH+imj0EpZ+uL1AGPmjGND9nMeA9DQ0wvmtiFIMXBGF5YNiR3i9nLMMr2g1++7OXda8gJPmmaea3UiVKXG/uEu5Is5iJr1+yjPGD2TsATl9TrB66Xcz3TdBlrWU+MOwD0mpqzJcb1FKhApzYRndWBtzpGUHbRmupGQNcTGwDNHCgXLldMQlYI3O8C0csRtAa0yxDIaaql0CAHF5AQYpSHB8BKHjCij3fmSoA/ZRT994Ae69ivOhYRmU3XpIcPGulDkbXPXYrSMSy7TCGD6vLMUON+vEjsX41gY6VF0q864bFZ5MqnsGSy+oN7qP85hqAXiALnOQSBkS3aOx3nfqpT5PhbuVMz6xnZYvpMr/xbmwP1YuJTkkhFIhYxaky4MfIwVhMpgWHcAgMQaeLqCxVShMwdxTKFX5VhmC1wRMxQtNHzj2EI7pWpxYvfcqMiWAbAY6TkByM8BAyR7Z4BnwMBFiteKzP6qPm+O7VarzECa6QW6YBbXXFP9mOGzE1FMHFFJmbIekNTaASufgF14PK+O3ymz8Byt41psfCpJPZbEqKNpatK2lDle//L+UB4+3zrBXr0Y8hLwEIL5UTjvyAuoZUJkBjqaJcxusCWokUH19wMWJreAduxvBTJtR51Gkm0Jhxg1SImczCZslojueOMMcZdeUqC5w0Icd49NdqKrrNGn3JEcGCfObMw64K36D/URfIeumdZWxDXu7W5RGRggXh1GdjZtXaK3D2jjRQBjdieEVYSnvlkF6wUTrZLJwvIRYIadWznpB7o04dzOciiAYo5vIqznq7X1a8rovRdU
 nEYxeZJH
 a2FB1uzAJWV85aJmk+AXudDEBN4XisiDQQnGVE7szxRW3FFBT3XTsZiliNXe6Q0FV+GhCRpMqJxhlmfIQLlEwK/K8ECeDxTmMoAjQLZdLrHCVj2U6Xqq9XkwFSRtvjlS8hdQ+K8rf5TA4LHMFOpwmAkyY/z4V5TZwGX+pHOGKAwBqq9G3nret6tC0phlS0YRkekx1CInirSD2Bwl7QOk+QmjE5l8gz1VZu7/bqnljLCo4R4m7+dwfr7a1vjORuYnRN7oiP1qfCfKfkwrmIC8FCV89HFMoQSVyq6bOGXV/k9f/wpAQ02rTCwelNMc2IgXxcWeZ+1qzUN54GudoF766VCsbyjvR7pSRnriGuQZzlZwlXSJD4a3L8qh0TIcNE+aPlPI3GwRLhU4r9EcRoEYLwYRnbZc2AMQIawcpdBHc5/8g3E05PUqg+gNIQDjgWOAgw3MT/gyTG63D/y+Ws+39Iq15PnvdIjFuZbu/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/06/26 1:35 pm, David Hildenbrand (Arm) wrote:
> On 6/29/26 09:48, Lance Yang wrote:
>>
>> On Mon, Jun 29, 2026 at 09:25:48AM +0200, David Hildenbrand (Arm) wrote:
>>> On 6/29/26 08:48, Dev Jain wrote:
>>>>
>>>>
>>>>
>>>> Sashiko notes other places:
>>>>
>>>> https://sashiko.dev/#/patchset/20260625112955.3254283-1-dev.jain%40arm.com
>>>
>>> Yeah, that looks shaky. We do seem to have a bunch of these cases, primarily
>> >from pagewalk code (where some users like pagemap need the actual address).
>>
>> Indeed ...
>>
>>> I think we have two options
>>>
>>> 1) To prevent any (further) issues, make huge_ptep_get() always consume the
>>> hstate, and let the arch code deal with aligning it. Invasive.
>>
>> Kinda lean toward option 1, even if it's more invasive. If we pass the
>> hstate down, each arch can figure out the right addr from there.
>>
>>> 2) Make the arch code handle aligning without the hstate.
>>>
>>> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
>>> index 30772a909aea3..303a1b74796c9 100644
>>> --- a/arch/arm64/mm/hugetlbpage.c
>>> +++ b/arch/arm64/mm/hugetlbpage.c
>>> @@ -126,6 +126,9 @@ pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>>>                return orig_pte;
>>>
>>>        ncontig = find_num_contig(mm, addr, ptep, &pgsize);
>>> +       ptep = PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * ncontig);
>>> +       orig_pte = __ptep_get(ptep);
>>> +
>>>        for (i = 0; i < ncontig; i++, ptep++) {
>>>                pte_t pte = __ptep_get(ptep);
>>>
>>> (nshift/order instead of ncontig might avoid a multiplication, but not sure if that matters in practice)
>>>
>>> IIUC, that's similar to what huge_ptep_get() does on ppc.
>>>
>>>
>>> static inline pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>>> {
>>> 	if (ptep_is_8m_pmdp(mm, addr, ptep))
>>> 		ptep = pte_offset_kernel((pmd_t *)ptep, ALIGN_DOWN(addr, SZ_8M));
>>> 	return ptep_get(ptep);
>>> }
>>>
>>> I'd assume we could do the same on riscv. Besides that, I don't think any arch has cont
>>> entries.
>>
>> AFAICT, for huge_ptep_get() the addr users are arm64 and powerpc, riscv
>> doesn't really care about addr there. Looks mostly arm64-specific ... 
> powerpc handles it correctly in the weird "span two PMD entries" case by
> aligning the PMD down.
> 
> Risc-v copied from arm64, but can simply derive the #entries from the PTE value.
> it doesn't have to re-walk the table using the address.
> 
> But I think the following is required to fix, no?

We don't receive an unaligned ptep in huge_ptep_get, and riscv derives the
number of cont ptes from the pte itself, so why is the below required?


> 
> diff --git a/arch/riscv/mm/hugetlbpage.c b/arch/riscv/mm/hugetlbpage.c
> index a6d217112cf46..7e25cc13b3dba 100644
> --- a/arch/riscv/mm/hugetlbpage.c
> +++ b/arch/riscv/mm/hugetlbpage.c
> @@ -5,6 +5,7 @@
>  #ifdef CONFIG_RISCV_ISA_SVNAPOT
>  pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>  {
> -       unsigned long pte_num;
> +       unsigned long pte_num, pte_order;
>         int i;
>         pte_t orig_pte = ptep_get(ptep);
> @@ -12,7 +13,11 @@ pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
> pte_t *ptep)
>         if (!pte_present(orig_pte) || !pte_napot(orig_pte))
>                 return orig_pte;
> 
> -       pte_num = napot_pte_num(napot_cont_order(orig_pte));
> +       pte_order = napot_cont_order(orig_pte);
> +       pte_num = napot_pte_num(pte_order);
> +
> +       ptep = PTR_ALIGN_DOWN(ptep, sizeof(*ptep) << pte_order);
> +       orig_pte = ptep_get(ptep);
> 
>         for (i = 0; i < pte_num; i++, ptep++) {
>                 pte_t pte = ptep_get(ptep);
> 
> 
> 
> I'd prefer (2) as a simple stable fix first.
> 
> If we do (1) on top, huge_ptep_get() on arm64 could stop walking the page table
> another time.
> 
> If we pass the hstate (or vma) to set_huge_pte_at(), huge_pte_clear(),
> huge_ptep_get_and_clear(), we could likely get rid of the re-walk in
> num_contig_ptes() entirely and possibly just remove it.
> 
> That would probably be cleanest.
> 


