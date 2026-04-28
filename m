Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77531FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 19:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B4D6B0005; Tue, 28 Apr 2026 15:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73276B008A; Tue, 28 Apr 2026 15:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988C06B008C; Tue, 28 Apr 2026 15:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87C506B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:37:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49AFA1601B3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:37:09 +0000 (UTC)
X-FDA: 84708972978.02.2BCFF0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 71608100013
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:37:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oAHXisBD;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777405027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QYm9+Ytvf6jMe8JtOxqIDP+QdPMNzfUubkQxlSs1G4=;
	b=3mL8GYKq/3EFeUTz81c49NUu7TTquFq+aTB1GBblFt9v1giBf1o3ybE55V129Q5Uttu97e
	K9B9E7JunPbjBb4a+nwGcGwM4NV6BG/2xtfmoZWrcuib6YhTNketbmnOoESfS/kRp8VQ+c
	wylznUuWhf1dMY09+/8kDPPifwWtTDc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oAHXisBD;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777405027; a=rsa-sha256;
	cv=none;
	b=ZdalYfLUR2E3UuaaR0knFnraywQf6KQikfUqIDPWfrBQMgpQ9DB283+cYXdDrN8h0QDwTg
	sxdiO1/zVHpa5Xw9zqtkoQ10nLDpbCt9xDVVFQOBFYEB80bfB1S+a9J5fWhEIb/Ii8LUat
	UhCvkL+FPleXhqXEgH5VXMBzQraRl9Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43B9640C09;
	Tue, 28 Apr 2026 19:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2A2C2BCAF;
	Tue, 28 Apr 2026 19:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777405026;
	bh=wTu5YsK9WMfcrNfXAKqKVRZWZd07LCagAS8tZcofwKQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oAHXisBDzimhXI17wnijGsm4Kj3KwqSSO3NGUOdLz+1w/SMlJbxfKDEcFUM+LzsFH
	 yXZvH7lyhU+H/wQ7YtPQU6R1mIluNmEQJfGAQhC03AFHfmzoYgeIaRcCv5U+NIU77Y
	 xDivJB30dZqPvS+pEFcaZmZrUhsmIEtM4HoaWdZqXxZoTaVYXBUMhB/U9n4GQarLcq
	 SBzJOAhGGVluqLFboRvbHyctyXlY2waiys128tJ5SLSt+OyOM4Rn6Acxvrqj7z5pvQ
	 VljWqC1Oyjx0aGmqK2NgPK1nwwoZ3j4gsd0WUlN8K1CtgK/AzhuDQu4KN6pq6NFeYs
	 foSUkoiGRL5OQ==
Message-ID: <a0e86e22-5e5e-4000-ac74-a8a1b2f16997@kernel.org>
Date: Tue, 28 Apr 2026 21:36:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: fix freeing of PMD-sized vmemmap pages
To: Lance Yang <lance.yang@linux.dev>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, rppt@kernel.org, jgg@ziepe.ca, baolu.lu@linux.intel.com,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org>
 <20260428132025.86657-1-lance.yang@linux.dev>
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
In-Reply-To: <20260428132025.86657-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 71608100013
X-Rspamd-Server: rspam06
X-Stat-Signature: qqpnayrz835rb3tcgs4z8duhfsmfmbe3
X-HE-Tag: 1777405027-571919
X-HE-Meta: U2FsdGVkX18SdUd/Zdpa2O9gDj3CSW1vuMTmTI9NJSdwqJ1FSn1XdewLCyqpSdOLus5uueF7DlDAfUS2EVL8eW06Xc9gc4cIaMm2Ue0Z/Mm7/RA1dKKCFwDLUA1ZKsVDPpz6D/4a4OPIKZN5FeAe/9Ys1W3CJaT+ib+tKvCmxa3PD4wCZau+f2OjELhiwRRf8T2//HApNju3JmrFoIGTAvKNdNlUONuTDHngH3bKiq6yk4jjVinwbRZi7NzXGVUMU00+Tiz7PSt0BxAqHtM5pNeUcdF+HBH7vgABU7nVnYJIkznzzpNVJqX5xJvFnZ0n0ayw6DOhAsdbp2SCBRkknXHQmlVJtb9uKGCiGrmXFXI/rWvffKl7K/x8FB5KAqqFrJ7gUN8AGQdQ9f7jDfEjeksT9hS+kXwcd/Z5WtzW9HOjISmDlr0oI5kOJcA/FLOvocy7n0ldTNKpKDZHtYh2/al4bCnP6hGKl5kb7KiwQFQU9sjk70FQmjErCFyr82X1XlO6I6C3vT+WmQvFK1orb/B7KBWXTWPgeLxOQgS++E69YsA4ymTziC6HmI1ZAMi7uSO7nlCPDgH6Wo3yHF7eBPKLu8F3XspyyHuz8enVWo97ty6SUGHcOcsBkHyJUuhLd4z+S/cOtrInK6OgqJkRNsGTyxv0qol2ZV/t8jEbOpXiGqNGFR8ULxtGrmcbT3vE2LbWugJ1ksYQJfF/J8T6SwlvNsYAXTuAr0oxi4IZhhCk/KQdhGHB+Zh+lWfCjtRfFEcEb/MplpKC6wkZtAeRVsNPvsokbzyj1TksTXB+iahxlwYRkqwT1fjGDkmgnE2rweKBaW4ZgbTFTC7nXLayQ7hJJvj64wooDAUO1N41JIiSZDY/G1Nlyn4STMPHwNkTbqlcKYOVvt9jXEH8vSbNWeVazq6HGsJSQJI046wbD2BPeq25w/OzHAXYtsKrmCagpyB5fCF6z74t01tOraW
 3KNbPIe1
 aEXhzAaEL/7ZFgh40N1TLv12mJEpNiLxO3CD8ofvM++bOKx1g6zwWNH9+ifIIPCfCXWLyKDdXNBj4ZjerA1RC35TMD9GBLA8HVJ3HZgK3lc1CRCFIm268lbKurJcJKXF/gz6CEucIpHFExyn0nRUoAwX+s1mWA0yHXzPCMvmLW3GBPslPooNabbyRaAubY/i3oP/rExUcFwuWC78zcu+l5pbJmRKrJAUvKsl9bBgrvmf98ZGVrvvQMRR9Hf561pmwlKxzBaQto5yxfRhBJKdFn0zef3BF5E6Je3Ce
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 15:20, Lance Yang wrote:
> 
> On Tue, Apr 28, 2026 at 12:29:36PM +0200, David Hildenbrand (Arm) wrote:
>> In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
>>from freeing non-boot page tables through __free_pages() to
>> pagetable_free().
>>
>> However, the function is also called to free vmemmap pages.
>>
>> Given that vmemmap pages are not page tables, already the page_ptdesc(page)
>> is wrong. But worse, pagetable_free() calls
>>
>> 	__free_pages(page, compound_order(page));
>>
>> As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
>> except for HVO, which doesn't apply here -- we will only free the first
>> page when freeing a PMD-sized vmemmap page, leaking the other ones.
>>
>> Fix it by properly decoupling pagetable and vmemmap freeing.
>> free_pagetable() no longer has to mess with SECTION_INFO, as only the
>> vmemmap is marked like that in register_page_bootmem_memmap().
>>
>> While at it, just wire up the altmap parameter for remove_pte_table().
>> Also, the indentation in remove_pmd_table() is messed up, let's fix that
>> while touching it.
>>
>> Note that we'll try to get rid of that bootmem info handling soon. For
>> now, we'll handle it similar to free_pagetable(), just avoiding the
>> ifdef.
>>
>> Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>> Reproduced and tested with a simple VM with a virtio-mem device,
>> repeatedly adding and removing memory.
>>
>> Found by code inspection while working on bootmem_info removal.
>> ---
> 
> Cool! I just reproduced the leak with QEMU pc-dimm memory hotplug as
> well.
> 
> Without the fix, nr_free_pages kept dropping after the hotplugged memory
> was removed again. With the fix applied, it stays stable over repeated
> add/remove cycles :)
> 
> Tested-by: Lance Yang <lance.yang@linux.dev>

Thanks Lance! I'll wait a bit more for feedback, and then resend v2 with the
"nr_pages" simplification.

-- 
Cheers,

David

