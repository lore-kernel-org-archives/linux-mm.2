Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35ABE606D804
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X/8LMTQP
Received: by kanga.kvack.org (Postfix)
	id 423F86B05B1; Mon,  9 Nov 2026 07:53:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4A06B05B2; Mon,  9 Nov 2026 07:53:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29EC86B05B3; Mon,  9 Nov 2026 07:53:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 096996B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:53:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99EE7120637
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:53:54 +0000 (UTC)
X-FDA: 85415572788.07.71AAF55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B434540007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:53:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X/8LMTQP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794228832;
	b=a2t05tebCcJ1C0uZjXBEEP+A3CWFIlhwQwMfs7Rk62mOWqjO/ybAqDjr0XMwg+oxGNgz0g
	t2TxBwSW28WOh/LnxUy1WLM/ar8d9Ove1HOPY5XiqfC0BFE6fp2c0Z5K9RQGCvqiuHcaam
	4vCn7m9Clesgu0RHS8i9eQ2U0JqjWek=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794228832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjlQv+Rt9JvejDpQlYsKV4mpra0NOSmViN81+SW+4Cc=;
	b=KwhVqGGzJNUmigJjqk/O3KhfXvMAmrUnIjsg57stE1x2LL8gAeA25KuKjFgpses1igkzFM
	dd2K8AmXPx5CurFPwJ8/RvniBuBJBlJ+2hj3GuVnnWhrJvTcJ7fGS0mlnzJ61iHKE4qN7x
	OboPE9U0pXhxZM0FS9838aYYa0WyVb4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X/8LMTQP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 08D0440DE9;
	Mon,  9 Nov 2026 12:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543AC1F008A2;
	Mon,  9 Nov 2026 12:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794228831;
	bh=FjlQv+Rt9JvejDpQlYsKV4mpra0NOSmViN81+SW+4Cc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X/8LMTQPUOjpKrh0CenW3mCNmqe+hLLccgz0vKCIrWnTOLz0yV81FVyo1gMy7sSkJ
	 qeIUK3J8n2bfwQWZkB1iDHL54NcpMQlaqrZfD+NNsIps8TrihyIkdgleYhtMCDPoTU
	 DvY/BwfwWFeqkq37u14OYgNfrEdW1eY1WztddIAfSRvV2HZmcfCpTtMKmanwGI5KtH
	 S8SaJ35jlN+y1uJa3u58lD6k1eiePGkiV6XuojPUVy19MBu5dQaop7DuYWoKUuXuVz
	 0xU5Ki9ebtL1YiTsZbc5q3MPZZDUCo7+YjOjtFl7pe2NtRhK73X6zmMzME5HTWPkgk
	 waK2LR6WNaAyQ==
Message-ID: <fcef6c87-9767-4732-b959-8065c5b7e1bb@kernel.org>
Date: Mon, 9 Nov 2026 13:53:45 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mprotect: don't skip uffd marker install when racing
 with PTE table reclaim
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
 liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, qi.zheng@linux.dev, tz2294@columbia.edu,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261107-uffd_shmem_marker-v1-1-91fa2d653cfe@kernel.org>
 <20261108084035.85404-1-lance.yang@linux.dev>
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
In-Reply-To: <20261108084035.85404-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B434540007
X-Rspamd-Server: rspam12
X-Stat-Signature: 1axitqzk4ujph675ysmkku6u8hgc79pk
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794228832-441284
X-HE-Meta: U2FsdGVkX186Eg+cJNax8x8q+AGekYWNmmXxpR68VVLYtl0nZ8XCS4DUteKcv9JkonXqYTFd17LeccOzHTDteG80Ja6qkMOLjtoCAwPQ7uv0sYlxjNIrFOTXLHy+AYxrqqRxmXJdvBIzQvBV1heXW1eTVknEuD5Wsh8UbmMc4Q8yHtbfc/wZsZLf1t8rY4g7Cuws2KeVkLu2ly67eyW1Dlx9o0hIhs9gzsPyE8+M8mCUpDuIgmhp/iQv9jhnhd00LKo99jgqQEAGee9KmmzEx3ltmlnO3OvTT++qd8kyO+kX6aSA1uiBOpD5+1AkiXL/CGb4AyuhROz2ILUtTMceSh+9vFXhN+TEDljcx1wv+ZOuixFxzKfkbB2C7omFcx5qWdgTlhwv+tjFL1vMQTZGA9aE/k1jltu3wS+BY/R5Wk1hcihGF1DU5AEiV7YLtz5rEX5kWqPIxB//8tgn27YKa90rO6oSB/G911fYOXkizCVO4cAyUzekDiqKl1Bkp8RFSTs2aPxQo37iAMm19s7NWilFP118c0G07DyvplNXIASDEyPAooBj9pdehzOlwk+hqpXcG9ZKiCv5+tk7h0eRh9t8kN/RYqC+H4+mNq/tnU/5WE8pWEfRMhps9JIxKSJ6tosv1od6OSfkr1B/B+q2JHOnClw8GgITKFHpk7PJ0JafHHFmLvTbXsckOa3s9TVsOP7zoz+UelpjcergHLK8W4D0HFRvSoAJ1FdkEdCCIi6OHzGx7okEnYjOZH24aXAam80vcrX0hkov2QqDj4f/Tl5LWBGFdTvPN3YrPmcDnOnD+25HPehl9uUTQF24Yxlm6pHbc8iPEnixYoax0FKFwZ8lAqQi85eEaAESTvGn3FEqXoVfeazBPrHK7KP4wgmgNDLDrOQj/zC7oSxsagSJE2Woj2ZY7MAfR70qBazhLz/rincV+lD+tcEpqqGDzSL0X1dDdSZ7FFMXOopgtqF
 BrXRrZCc
 8/ycQRDWIsknOaIyYAi7KyFImEA+jf0B8XU+hNUDmpO5V8xBvLH0ArKcuMrHqL46MTgMpxkdXezmytJmXxdKit9mTur8j44TWDDGmT2nxzSVc8VmPB6LI7L2CtsLFVFaPqCIOSSmctwZddHBIxv0jBnCZLU0xwpGTD4Qv/yaGaAhDIztnIrlT4xB0KLsQWC6HCtRzYN2uckKCUibHBUnjqezOM1fWPliuGK4KcaIKdxFgMjn21oLEUq89S0cleR2ecfFqk6XS8jSdWg4XIWl4E5QjY/V9LLYEwN+we/dnassRN5E7z0sY830ZhxMKF8i3UTeFFWZ+DQ7v5Onx23IS/LZInkmjlsrEcgBGfOsq2yp+CZLPGYScyAVFp1fpFHMe3aZxsY8rjaesmmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/8/26 09:40, Lance Yang wrote:
> 
> On Sat, Nov 07, 2026 at 12:28:55AM +0100, David Hildenbrand (Arm) wrote:
>> change_pmd_range() populates PTE tables before installing uffd-wp
>> markers. An empty PTE table can be removed after change_pmd_prepare()
>> returns but before the pmd_none() check.
>>
>> That check then skips the range, allowing UFFDIO_WRITEPROTECT to report
>> success without installing the required markers. Subsequent writes by
>> userspace to these areas will not trigger uffd events.
>>
>> PTE table reclaim during MADV_DONTNEED and page table retraction during
>> khugepaged can trigger this.
>>
>> Retry page-table allocation in that case. Simplify the code, getting
>> rid of change_pmd_prepare() by routing all code through the "again" label.
> 
> Cool, nice work1
> 
>> It's a small race though, so likely this is not very urgent.
>>
>> Fixes: fe2567eb5521 ("mm/shmem: allow uffd wr-protect none pte for file-backed mem")
>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>> I expect Andrew to pick this up.
>> ---
>> mm/mprotect.c | 48 +++++++++++-------------------------------------
>> 1 file changed, 11 insertions(+), 37 deletions(-)
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index e18d4e12fc341..ef4e7188e24da 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -470,25 +470,8 @@ pgtable_populate_needed(struct vm_area_struct *vma, unsigned long cp_flags)
>> }
>>
>> /*
>> - * Populate the pgtable underneath for whatever reason if requested.
>> - * When {pte|pmd|...}_alloc() failed we treat it the same way as pgtable
>> - * allocation failures during page faults by kicking OOM and returning
>> - * error.
>> - */
>> -#define  change_pmd_prepare(vma, pmd, cp_flags)				\
>> -	({								\
>> -		long err = 0;						\
>> -		if (unlikely(pgtable_populate_needed(vma, cp_flags))) {	\
>> -			if (pte_alloc(vma->vm_mm, pmd))			\
>> -				err = -ENOMEM;				\
>> -		}							\
>> -		err;							\
>> -	})
>> -
>> -/*
>> - * This is the general pud/p4d/pgd version of change_pmd_prepare(). We need to
>> - * have separate change_pmd_prepare() because pte_alloc() returns 0 on success,
>> - * while {pmd|pud|p4d}_alloc() returns the valid pointer on success.
>> + * Populate the lower-level page table if marker installation requires it.
>> + * Return -ENOMEM on allocation failure.
>>  */
>> #define  change_prepare(vma, high, low, addr, cp_flags)			\
>> 	  ({								\
>> @@ -517,30 +500,21 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
>> again:
>> 		next = pmd_addr_end(addr, end);
>>
>> -		ret = change_pmd_prepare(vma, pmd, cp_flags);
>> -		if (ret) {
>> -			pages = ret;
>> -			break;
>> -		}
>> -
>> -		if (pmd_none(*pmd))
>> +		if (unlikely(pgtable_populate_needed(vma, cp_flags))) {
>> +			if (pte_alloc(vma->vm_mm, pmd)) {
>> +				pages = -ENOMEM;
>> +				break;
>> +			}
>> +		} else if (pmd_none(*pmd)) {
>> 			goto next;
>> +		}
> 
> Previously, reclaim could clear the PMD after allocation and we'd just
> skip the range without installing the markers ...
> 
> Now it's change_pte_range() -> -EAGAIN -> goto again (retry the same range)
> 
> And yeah, that should do the trick ;)
> 
>>
>> 		_pmd = pmdp_get_lockless(pmd);
>> 		if (pmd_is_huge(_pmd)) {
>> 			if ((next - addr != HPAGE_PMD_SIZE) ||
>> 			    pgtable_split_needed(vma, cp_flags)) {
>> 				__split_huge_pmd(vma, pmd, addr, false);
>> -				/*
>> -				 * For file-backed, the pmd could have been
>> -				 * cleared; make sure pmd populated if
>> -				 * necessary, then fall-through to pte level.
>> -				 */
>> -				ret = change_pmd_prepare(vma, pmd, cp_flags);
>> -				if (ret) {
>> -					pages = ret;
>> -					break;
>> -				}
>> +				goto again;
> 
> And, after the split, we just go back to again -> allocate a PTE table
> if needed -> recheck the PMD.
> 
> So, no need for that second change_pmd_prepare() ANYMORE :D
> 
> LGTM!
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> 
> Cheers, Lance

Thanks for the review! Let's merge this through Andrew's tree :)

-- 
Cheers,

David

