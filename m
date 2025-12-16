Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26BC2D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 03:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724246B0005; Mon, 15 Dec 2025 22:33:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1DE6B0089; Mon, 15 Dec 2025 22:33:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1B86B008A; Mon, 15 Dec 2025 22:33:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44EEB6B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:33:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E23E213AF24
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:33:07 +0000 (UTC)
X-FDA: 84223913214.25.BCA6CC0
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6903C2000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:33:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eUBB4XPE;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765855986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UC+roNBiQGAi6eoketJwuLzcModJsVZ/qwQfTda8Tc=;
	b=iDIir8AIgjkkpFrL5OXAL7SYYwoLFQ1REIgy5MTrBEVzy6FvWsg3NY74shlzFgDlMA8KBT
	+Wz/hZBn/f++k3WzEFyb+saBpEGYW2WJ6PiRUIIlWPSPh/koY/43NplIzOrkhfWBH8hTRG
	SE46rKgx4uuUb0wFcpjbjzjgQcByIfs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765855986; a=rsa-sha256;
	cv=none;
	b=EOeJUY5kKieVR5A3Avkb0p5aix8UDISEkXEaLAvcoyNzluJQs3QIntYxmgfCYfyeeJz6Zw
	NGfcNmZOlOfl4rLm1bvS/C9oF7IxEECdFtV4sZ3hAaI/nxidXXIv/GdIUqayx6j70rhxn3
	GqKgeIbxAq+e+X98Vzf2QOoHGtORsNo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eUBB4XPE;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765855981; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1UC+roNBiQGAi6eoketJwuLzcModJsVZ/qwQfTda8Tc=;
	b=eUBB4XPE/Y72ClpbapTojLZebjPgkj2FKJ5/G8uTgQ9jcytPHLUsplKWWrLYFNL/zP8iRzP2eAeyWfJltApaAlWqlLTr7DIdFsJUwfUdzSWPeYbefQ0SUKKtkNCn0WIA2JUluV/M360iBDEiViUvDc06FxLAJHG9QdeEqJqQ4LQ=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WuxNpfx_1765855978 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Dec 2025 11:32:59 +0800
Message-ID: <1a0001cd-c38d-403b-b3ef-d19e85acd772@linux.alibaba.com>
Date: Tue, 16 Dec 2025 11:32:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] arm64: mm: support batch clearing of the young
 flag for large folios
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
 <5039c6a2-09b6-4c9b-accb-26583ba120db@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <5039c6a2-09b6-4c9b-accb-26583ba120db@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5bm3xk1cy9x3ot6k3gj9wrrrdbg7a9q6
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6903C2000B
X-Rspam-User: 
X-HE-Tag: 1765855984-726829
X-HE-Meta: U2FsdGVkX1/6P0Jv18jzEj1ZDEY5uKT9pwx/BLVc0tL9yt6tDjIg7YwbD+3OFXmc5dyF7prVHvd0IXgAdLEs6mueMIlpnfTCAXT4IK6Uvn2CsLurRFdbzf21CUHjw/CRd726NWciVPBW0tHaMP0R8/et34yipEma5b6II+plZFCPwezCHnc2x3DfFLoANPV4GItczVyi2ZiNXuZdP8ahtb44Q/SlFUZqXT+QqKYIB51jmtNooA39ZBzgBkwcdVa6zuZvO2gB0ky++Q9Pzediw1PdV80ofG4R9LaLtH+4YTP3nUy7iGd6szVaUC4TAnEs3y9sAezjNkKT26nvi7L/zjde3cNznRFsGPNVAXpqv+ylS8XUae2MA0haDyjDpxv0+75ViLEC01UoK7odKuKZDm0YiUt83XyxPx3o5YN1eNDKxgQYAAWHBKdOBo6yIUWCxe9zeJu1zFJTD2GzJBXaBhd4luv6SFGF10RRf88HO8KXtqH1477IjAoCMCapy30o1y/8EomKK+2as/JfdMYbVxcmSklfAGhQbYEDMVBkrz+1/Htuk8Qgopzrfj3Xc+P456V+VwJLj8VV1BIlBQDUwqatProZW98iZzFlE+kSxJwFrodPtDUwJ8eZgmYLWa6TXv3BYpIZihTYuGwmXFvN6PQPXMV2aV2+usnXL7dls0/zsR2+sqg54AwQ7XzxayWWE2Mjuaqqvr2MO+WUvG+qsR1FoCIM1r5uuWPq0ICEyNxPF25iMQnqSBgf/q2crvGregsxFxFLYYu5bpObW3infoacStdZJ9MJLwV9Sdheo5AVd62BhFxZipyvyF+xTSFcC/RBIvSluTFtQ59i//PxWC6epIP7j7XwvVNIvRGjwuazWTpytsaY3Y6AxQsqfGdgr5YQKSpMnPCBcbxXBMLwSdZ+QoS/Vt/kaDBmsDz1wX9MBnSCLSViSElYpctZ/vTI5jUpHKZmuNIHssRQS3q
 wmOdhj76
 RzT4SAxpSVcey/FHtJhSRvD2nnD920h6GO9W/7Cz3+/XkmAviVOcroc2pTPGjbXA4xOewSigJZqMRjcBs5Uy2OsEcy5Re8+4SAaCzUFp30/3sRreNLcAIr8L39IR7nMQf4RoJd9xePXMYd+KJFp/tqQrClRmd0TD+TIk6GoSdkONVuyR9Dw1o8wTToeob0okLXSB7ZDKVBgZU4nVHWmAKDjXGTc7q3pz/q5//XFuPU+2wenkccdBUiUGdVcXoiDNcKAoAcUeJ4Bcx6SydPgx/w7LIuqRsGTDPBJBwa5Qn+7ZVcuw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/15 19:36, Lorenzo Stoakes wrote:
> On Thu, Dec 11, 2025 at 04:16:54PM +0800, Baolin Wang wrote:
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
> In core mm at least, as a convention, we strip 'extern' from header declarations
> as we go as they're not necessary.

Sure. I can remove the 'extern'.

> I wonder about this naming convention also. The contpte_xxx_() prefix
> obviously implies we are operating upon PTEs in the contiguous range, now
> we are doing something... different and 'nr' is a bit vague.
> 
> Is it the nr of contiguous ranges? Well in reality it's nr_pages right? But

Yes, 'nr' here means nr_pages, which follows the convention of the 
parameters in contpte_xxx_() functions.

> now we're not saying they're necessarily contiguous in the sense of contpte...
> 
> I wonder whether we'd be better off introducing a new function that
> explicitly has 'batch' or 'batched' in the name, and have the usual
> contpte_***() stuff and callers that need batching using a new underlying helper?

OK. I get your point. However, this is outside the scope of my patchset.

Perhaps we can clean up all the contpte_xxx_() functions if everyone 
agrees that this is confusing.

> Obviously I defer to Ryan on all this, just my thoughts...
> 
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
> 
> Hmm shouldn't you need to update this comment now 'nr' is a thing? E.g.:
> 
> "And since we only create a contig range when the range is covered by a single
> folio, we can get away with clearing young for the whole contig range here, so
> we avoid having to unfold."

I think the original comments are still clear:
"
/*
  * ptep_clear_flush_young() technically requires us to clear the access
  * flag for a _single_ pte. However, the core-mm code actually tracks
  * access/dirty per folio, not per page. And since we only create a
  * contig range when the range is covered by a single folio, we can get
  * away with clearing young for the whole contig range here, so we avoid
  * having to unfold.
  */
"

> However now you're allowing for large folios that are not contpte?
> 
> Overall feeling pretty iffy about implementing this this way.

Please see the above comments, which explain why we should do that.

>> +	unsigned long start = addr;
>> +	unsigned long end = start + nr * PAGE_SIZE;
> 
> So now [addr, addr + nr * PAGE_SIZE) must for sure be within a single PTE
> table?

Caller has made sure that (see folio_referenced_one()).

>>   	int young = 0;
>>   	int i;
>>
>> -	ptep = contpte_align_down(ptep);
>> -	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>> +	if (pte_cont(__ptep_get(ptep + nr - 1)))
>> +		end = ALIGN(end, CONT_PTE_SIZE);
> 
> OK so I guess for PTE_CONT to be set, it must be aligned to CONT_PTE_SIZE,
> with other PTE entries present there not having PTE_CONT set (Ryan - do
> correct me if I'm wrong!)
> 
> I guess then no worry about running off the end of the PTE table here.
> 
> I wonder about using pte_cont_addr_end() here, but I guess you are not
> intending to limit to a range here but rather capture the entire contpte
> range of the end.

Right.

> I don't love that now a function prefixed with contpte_... can have a
> condition where part of the input range is _not_ a contpte entry, or is
> specified partially...

Like I said above, this is outside the scope of my patchset. If Ryan 
also thinks we need to do some cleanups for all the contpte_xxx() 
functions in the contpte.c file, we can send a follow-up patchset to 
rename all the contpte_xxx() functions to make it clear.

>> -	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
>> -		young |= __ptep_test_and_clear_young(vma, addr, ptep);
>> +	if (pte_cont(__ptep_get(ptep))) {
>> +		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
>> +		ptep = contpte_align_down(ptep);
>> +	}
>> +
>> +	nr = (end - start) / PAGE_SIZE;
> 
> Hm don't love this reuse of input param.

OK. Will use another local variable instead.

> 
>> +	for (i = 0; i < nr; i++, ptep++, start += PAGE_SIZE)
>> +		young |= __ptep_test_and_clear_young(vma, start, ptep);
> 
> Again, overall find it a bit iffy that we are essentially overloading the
> code with non-contpte behaviour.

Let me clarify further: this is the handling logic of the contpte_xxx() 
functions in the contpte.c file. For example, the function 
contpte_set_ptes() has a parameter 'nr', which may be greater than 
CONT_PTES, meaning that it can handle multiple CONT_PTES range sizes of 
a large folio.

It might be a bit confusing, and I understand this is why you want to 
change the 'contpte_' prefix to the 'batch_' prefix. Of course, we can 
hope Ryan can provide some input on this.

Thanks for reviewing.

