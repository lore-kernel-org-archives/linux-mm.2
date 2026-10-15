Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 348BCCCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 19:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C8646B008C; Thu, 15 Oct 2026 15:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F426B0096; Thu, 15 Oct 2026 15:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B64A6B0098; Thu, 15 Oct 2026 15:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0E166B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:00:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5870516024D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:00:39 +0000 (UTC)
X-FDA: 85325776998.27.40AA6D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 189F410000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:00:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxfnhKaJ;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792090837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJ/G9yyXD4qyUPrTP1b85QhiMx6Sqjd/0iLMmnkucLE=;
	b=g1Tk6POLHg/QlzqERwUEcHZmiEBI704HfEh0eHV9PeMUV5Hoyrin/i7AoGG7IneJHHQGhM
	/1N0RsqUwNqOEqm6bZRXVygTSFdav7yM7Vr17PloO4f2/JUL1fMeWONQ8h5pN5QjL4ydn4
	KoqYKAb9fkKS7atRZVbP0fjKrVbM39c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792090837;
	b=HZb9hlU7vfx2kiDTTHd42lUE+tHzQkjXTaJnhabmmcVc8kStTqrP1VIXjSPE6Qd+6SR9dD
	Rve5CVi/MiDCuT697rP/jCbuAIxYEg3Jv+MtBdQ24hNIrVRDrSEIgGSfjSiCjoarhx/ITm
	hrSVkasOarjVp4RSCUc7qNo7eElTi3E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxfnhKaJ;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27C7B60A5F;
	Thu, 15 Oct 2026 19:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D451F000C5;
	Thu, 15 Oct 2026 19:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792090835;
	bh=uJ/G9yyXD4qyUPrTP1b85QhiMx6Sqjd/0iLMmnkucLE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jxfnhKaJN88Ifi5mS18bnuyd4Z77T+cmmVs9M0jHfYRGlIiWSuVEih3mUUp6Thtn3
	 eNXVirQLiGONqNEymMftbPUH9Z6FSGUwC1T7RTlCgwUxPjQyx0RPYuEKHNG99PP/oG
	 1xtPVuGad8RK4Y2qSKNSFkURp7OmdXcUBnqd5pwcAMqFRNCz3BSTb8qc3K66cG+vik
	 h39qpHBXvN7EH1Es1wJNGHPq9jTKWZVDNlOfMjvA63ZRbtBobpqggfrfq4+XmnU4PN
	 m+n5rZZGOcoWPmf4Uo8p2PoB8arS4mkJ+tTz5qND8MIgI0BvaE5B9ahcs5UOxk9CNh
	 YKnNZ3SVjyb7w==
Message-ID: <f7735584-e020-4ee1-8afb-2b5d580cfa49@kernel.org>
Date: Thu, 15 Oct 2026 21:00:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: memory: fix truncation removing mapped folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
 <8245424a-f068-4be5-9e58-713cbff1f8ae@kernel.org>
 <405811f5-ee36-4b3c-80d0-7dc6827ab5d4@linux.alibaba.com>
 <6660d3bb-3485-4c34-8734-3ea99df920f1@kernel.org>
 <02c9a968-92e2-49e2-bffc-74d264a5c911@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <02c9a968-92e2-49e2-bffc-74d264a5c911@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 189F410000C
X-Stat-Signature: hqhrfo84kqi7by58dgmses37samuozb7
X-HE-Tag: 1792090836-319577
X-HE-Meta: U2FsdGVkX1/5WAWq9L3a3xVtAQtAY1+vZDEPwieDyvWYgnZhP02URqXC9pSS8RKR15i92KWRIST25fmwP9WDZGYhzDs75cachGX0oKIwakHgbn8DDqz8GqZ9fA+xo1VimN3rSVBiNkM2yDqbEwd/Bb+VKP4N1K5DYo5VE8OcD4FS+wE5ffk2J/FFgvBcWWtb9ZAyn/TcXMh8UvVufxDTkojjSiYEOPQxOpNfm2I848CxZ43xnoDsdAx5tMU0K4KZ8/gBF3Ic0N13qSDSbrH7qk4Dt0X8AXyGDfBniiRp2ZbOCr2c6Bw56AVK+f4etP6oTjn8Xn1WI/8lMbcn8pcVi7oLfC7SC4LWCv+RBEHPb89dcZY/MHWmdxKvchxCwxNt4OYT5sbxCo4BBNzEQCQlJsNRarOtxhEmttduze3K48O7Wh+5+rhAHBgnD77x+WZXn+oUTjuYfp2CR6jKmfDKJeZRLSkaEsQxS4DVQflUaLMA9x7hHWqIn+GlXEHZ5ge2r3NdZWz8aq5vdRdeeNpE14Otv1R3z0xL2cO3RGtKHGwW/c8zBS0To6R6D7Ggur3D5G+tKxeaWMQ6fH5LBn+FHJeqshUka+Kk9w1Ho6nnHs7FjJMK9dI6S0uXwldT5/iocENwPDe3jZY63SqtdZOuxyuaLoXUvO7+83YKR/f/4ZLe5NloWb4JurtAm4AINIsUbQzXjKX1BLmSR1avds+j+qsOxx8eUmpRGIddHo1nwKAZPrvoTFynCYERUYGMKCCWP2IBclBzmDHFr8+lmjodrTu4czs/a2JVwV4ev3oMS1x4t8i1iLq74FiJ/hHsC9FTZ/kkGiSTWOvwGZbsrTQOmZWCGnNL52gbroTHIpTzZzdk03cjIWXK8zTomjCn5abbKc072gTB5J97VBj4zkpuX451fQGDPAh/HXR/LUKxtWnpi7XYH8zg629u6Z+BU9c3wJsm+ZvvtBg3q5VdanL
 C5H5///M
 8Iqd1Oc2HDJsXXAXF7LWGUydNSyFsTFxf23OXDPJNDnZpODWSyf0MMmtLJGQv8QReQ9/czAaukMKVEy5RpaPFkY9Y+vKNvjKjXyiJvw5sUZktosOGm2AGVFMvuO4XGq7kk/ZD0IbIZaWounYHpRon9HAN8pIF8R06iHP83fjN9nW3kBE7UW+6X+E4QlHq4klSaa2MVvausyAn11reORiTZ828LU10f/MDKfuOk1TqKJANj8yHewP32SoqLUqobHGUxxe2edWbjLpn4MKPAY+mA7YwiZtJZgxyjI+e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/26 08:41, Baolin Wang wrote:
> 
> 
> On 10/14/26 9:25 PM, David Hildenbrand (Arm) wrote:
>> On 10/13/26 11:36, Baolin Wang wrote:
>>>
>>>
>>>
>>> I had considered this approach before, but it is not feasible. IIUC, the
>>> sync_with_folio_pmd_zap() is used to address the race with zap_huge_pmd(), and
>>> both the PMD clear and the folio mapcount decrement are performed under the PMD
>>> lock in zap_huge_pmd().
>>
>> Just to be clear, I am thinking about something like the following on the
>> zap_pmd_range() side:
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 38b1165212c94..a8820ad7e2f21 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -584,14 +584,15 @@ void free_pgtables(struct mmu_gather *tlb, struct
>> unmap_desc *desc);
>>   void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>
>>   /**
>> - * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
>> + * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>>    * @mm: The mm_struct.
>>    * @pmdp: Pointer to the pmd that was found to be pmd_none().
>>    *
>>    * When we find a pmd_none() while unmapping a folio without holding the PTL,
>> - * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
>> - * indicate that it's unmapped. Skipping the PMD without synchronization could
>> - * make folio unmapping code assume that unmapping failed.
>> + * zap_huge_pmd() or zap_empty_pte_table() may have cleared the PMD but not
>> + * yet modified the mapped folios to indicate they are unmapped. Skipping the
>> + * PMD without synchronization could make folio unmapping code assume that
>> + * unmapping failed.
>>    *
>>    * Wait for concurrent zapping to complete by grabbing the PTL.
>>    */
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 8b0c2c735d3de..c585f5eb255c9 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -2139,9 +2139,7 @@ static inline unsigned long zap_pmd_range(struct
>> mmu_gather *tlb,
>>                                  continue;
>>                          }
>>                          /* fall through */
>> -               } else if (details && details->single_folio &&
>> -                          folio_test_pmd_mappable(details->single_folio) &&
>> -                          next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
>> +               } else if (details && details->single_folio && pmd_none(*pmd)) {
>>                          sync_with_folio_pmd_zap(tlb->mm, pmd);
>>                  }
>>                  if (pmd_none(*pmd)) {
>>
> 
> Yes, I've considered that. However, implicit memory barriers give me a headache,
> so I ended up going with explicit memory barriers (suggested by Pedro).
> 
> If you don't like memory barriers, let me re-check whether the implicit memory
> barriers here can ensure race safety with sync_with_folio_pmd_zap(). A
> simplified logic is as follows:
> 
> CPU 0 (truncation)                        CPU 1 (zapping)
> down_read() ->Acquire A1.                pte spin_lock() ->Acquire A4
>                                          clear mapcount
> 
>                                          pmd spin_lock() ->Acquire A5
>                                          clear pmd
>                                          pmd spin_unlock() ->Release R5
> 
> if (pmd_none()) { //read pmd
>                                          pte spin_unlock() ->Release R4
>     pmd spin_lock() ->Acquire A2
>     pmd spin_unlock() ->Release R2
> }
> up_read() -> Release R1
> 
> spin_lock(y) ->Acquire A3
> folio_mapped() // read mapcount
> spin_unlock(y) ->Release R3
> 
> CPU 0 constraints:
> 1. R2 is a release, so "read pmd" completes before R2.
> 2. A2 completes before A3 (ACQUIRE vs ACQUIRE).
> 3. "read mapcount" completes after A3, hence after A2.
> 
> CPU 1 constraints:
> 1. R5 is a release. Both "clear mapcount" and "clear pmd" complete before R5.
> 
> According to above constraints, if CPU0 sees pmd_none() caused by CPU1's clear
> pmd, and CPU0 then acquires the same pmd lock released by CPU1 at R5, then
> CPU1's clear mapcount happens before CPU0's later folio_mapped().
> 
> Therefore folio_mapped() is guaranteed not to read the old mapcount in this
> case. So I think sync_with_folio_pmd_zap() can work, but needs a small change to
> avoid the double pmd_none() check.


I'd be okay with some (follow-up?) memory barrier handling inside
sync_with_folio_pmd_zap(), for example, based on the folio size and with proper
documentation why we need the PT lock in one case and why the memory barrier is
ok in the other case.

> 
> David, does the following diff look good to you?

I think we should extend the sync_with_folio_pmd_zap() doc as suggested.

> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 6a8e7772b8d6..c0aadab1b59e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>                 }
>         } while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
> 
> +       add_mm_rss_vec(mm, rss);
> +       lazy_mmu_mode_disable();
> +
> +       /* Do the actual TLB flush before dropping ptl */
> +       if (force_flush) {
> +               tlb_flush_mmu_tlbonly(tlb);
> +               tlb_flush_rmaps(tlb, vma);
> +       }
> +
>         /*
>          * Fast path: try to hold the pmd lock and unmap the PTE page.
>          *
> @@ -2044,16 +2053,8 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>          * to ensure they are still none, thereby preventing the pte entries
>          * from being repopulated by another thread.
>          */
> -       if (can_reclaim_pt && direct_reclaim && addr == end)
> +       if (can_reclaim_pt && direct_reclaim && addr == end) {
>                 direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
> -
> -       add_mm_rss_vec(mm, rss);
> -       lazy_mmu_mode_disable();
> -
> -       /* Do the actual TLB flush before dropping ptl */
> -       if (force_flush) {
> -               tlb_flush_mmu_tlbonly(tlb);
> -               tlb_flush_rmaps(tlb, vma);
>         }
>         pte_unmap_unlock(start_pte, ptl);
> 
> @@ -2102,12 +2103,11 @@ static inline unsigned long zap_pmd_range(struct
> mmu_gather *tlb,
>                                 continue;
>                         }
>                         /* fall through */
> -               } else if (details && details->single_folio &&
> -                          folio_test_pmd_mappable(details->single_folio) &&
> -                          next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
> -                       sync_with_folio_pmd_zap(tlb->mm, pmd);
>                 }
> +
>                 if (pmd_none(*pmd)) {
> +                       if (details && details->single_folio)
> +                               sync_with_folio_pmd_zap(tlb->mm, pmd);
>                         addr = next;
>                         continue;
>                 }

We do have another sync_with_folio_pmd_zap() user in page_vma_mapped_walk(),
does that one need care as well?

Not sure if removing the thp_vma_suitable_order + pvmw->nr_pages negatively
affect performance, I suspect not but we better double check.

-- 
Cheers,

David

