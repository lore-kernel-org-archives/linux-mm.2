Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DA9FFD3762
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 15:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395D76B0005; Wed, 25 Feb 2026 10:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3438F6B0088; Wed, 25 Feb 2026 10:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225ED6B0089; Wed, 25 Feb 2026 10:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0686B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:23:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1C2D16064E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:23:35 +0000 (UTC)
X-FDA: 84483348390.18.2AA903C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 058A1140002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:23:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dg1fRSCg;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772033014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fquia8ffAjoSo6XjCsD+vfVACIhYb2w1Ss+o3Xbehcg=;
	b=obHNajbm7okTVoYCkXfstmsQPB8yjOQTgaN6Ee7S8rdelBr4kaHByhcZAtQvWL0aGPKXb0
	btArM6RGCNqusadqXVlOJ4t97uNEVUFiWT2UJPAJKCpbaquZuP7TBr79w4E3eCMbz4pw2p
	txuu6saikKFD+pOT6aCGGAYHOlB0hbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772033014; a=rsa-sha256;
	cv=none;
	b=W3k/8jULJm7d4nahvxwsxscpnGmGKArYvWts/nCIwlvIcIgvBv27Vk9jXFc1b9U+VoY3xf
	XNiSpVX16uuBZftvDdMgxhUEAwNR49aa8myUdk+PTj/8MYaKvwpOL8Noi/cjRMGYEV8+pr
	3G2A5EQJ6fpcNxc6XroVsQGtn3jdZRk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dg1fRSCg;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E3E0600AE;
	Wed, 25 Feb 2026 15:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43831C116D0;
	Wed, 25 Feb 2026 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772033013;
	bh=gS5Yk7wYTW6W1m8o50Cew7D6B1+VreaVyadftIITtbc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Dg1fRSCg7k3Q2cK9Sat615Pj7Jh0PALjT32x9LczwQkRJEkfcOlRGlQvCq/OfhtyQ
	 SU+aTqkoeOQMHGt6s/Oc6VC6xrwccygDUgzu9ii4MyuDMtNBqzDgwChPufMaqkCzgW
	 uLHQuo0VgJ3QxnXTbIKkqcDWrcpBEy9VrmC46MD+elXPqK08UWyEego0mwNh+rYb/U
	 S+LE3hsOmSqxwHWQdTfhsAZKOCUtomSxdHJr83Lo6JxATY49GUAn2ORLbpCLhZgnQh
	 TkKAV3TTOwTwKGZmUrAHcmNEPdLEWUEV4ebP7hEtgoRnhX2bnpA2vQ14qhuC2nWPu2
	 EjcdY+vRMEt9w==
Message-ID: <7da49940-e1a4-4018-9db1-208411598e77@kernel.org>
Date: Wed, 25 Feb 2026 16:23:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: Fix use of NULL folio in
 move_pages_huge_pmd()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Chris Down <chris@chrisdown.name>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <aZU1vSmn5aF8xvJj@chrisdown.name>
 <0b653dcd-842b-4360-bc1c-8fe779efbc23@kernel.org>
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
In-Reply-To: <0b653dcd-842b-4360-bc1c-8fe779efbc23@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: w7ckknamjqhg9whh9q1pj9aaa5h7cm6p
X-Rspamd-Queue-Id: 058A1140002
X-Rspam-User: 
X-HE-Tag: 1772033013-701056
X-HE-Meta: U2FsdGVkX1+bA52Gy3CLeL3IlTV4agWmgBSsW0Xx2gaLuUi+ZAtrR+qAOafENGrqgCM1WAW8A2xZgaEmQBM9oN/7O+CFi4AJdsVbh5o74v1TAeE3/+rw/BRuieaLableYYDmuKDcsBcqeR4juvhACGxWmAZc3KaEjSLhov9C8j4/92zqV0m/+W86Edg2Y6wuAZXym4bki4bpAO0ktjYJpqptNkGmLC36fl2WWQnoyLkgrrmJhoAIbZ3H6Yz8UG4n8d39Nl8du8BbSAMzJs+UDfJIWvJ0DJo20DH/8uq0czCO+7myP+MAt1fMxp8xDI3HKFRQb9v3EJmbnFTY3+JUSAaeNuswTNv3RGuyjN07/jFN0sQyLICSr9VEHWKvXm+DO0hFlYUz4EQ9YQx1HmpXYG7vQhu3uU8BfhjUXCFuflya44JwEbSCD4BY5QZKffhhWfUykAuW3Waib0ov2TEME+s1KPMefQpPJiRHVLlkAHL65L5FWE/jOl2dAHvnsoCIP3jHDoAjMx75Dg0TtuTh3vU9m6gbc/KgtghTGPslv9CMys1CzxE7hsftF2aF0SiWnOc+hvZtX5dUtgmjTPm9ps6ELtr7gZjdHjQ39qhWxD+fdvKQWx/cGrZbKS1iaJ8IQdPSuESOggXEjdI0zra3efsu3kaZ7xWMn53QcF7BJbUVNnXoTfENlvAf5Cpjj96r8qCnSx/VfHeFK1xWesdxAtOuBSgrDc0TYw+m4zT234vjHqi1aUJYiFZYGLH1LwauyVv4KLdzJIW/uJt9WudSog75dpcot4kb72NCW9YMW585Yj6OTskq8jICTrYGigT1q+TUfbNYVTiqdMyLVLzqBeMPiHY+pXb5SDQUK1ZvgPxpix/TmHdcTRJynzq37hVbAm51G1WB4drwYxhnQRiwnhbgeG6bzi4Ja3+5HKCFkd2h+RV2Dumi3Jrc0nvtDYa4mvxRfo6DHMOn9KRrV5z
 dGOXna/q
 J6fGoPbNyBt/NHw7BLS88+08O5heFTSro4JBEUuL6wube7CqLPNDqcyx25p775oNKHiP1VPHnMbAlIi1o1hMXIZlCMiorVQ7fr2jb0TVv7JKPggs9JlCXF2CIMZJ/3xTyOs7Lbue/4HANMib84Su+nayqvt9bHKApWxnvHtKf8RzYaBf4WkcqYqdx3WyOnU6qUxwRj2fio1eikEKcduYNxHWm7bI4kraPGdYWi+Wxx3qqQTKTb7VrAM5xeb6aiAOIaSCJ+/0FzPKDFSRa9dwbsKmTmEd4vtUU4+zw8MAFIbLwtgjVWV+XX7+tnT/PPxP0N8Po7vjBcJH3AJkcGSNAUkiBtWz9vn8FwZ8F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 08:52, David Hildenbrand (Arm) wrote:
> On 2/18/26 04:45, Chris Down wrote:
>> move_pages_huge_pmd() handles UFFDIO_MOVE for both normal THPs and huge
>> zero pages. For the huge zero page path, src_folio is explicitly set to
>> NULL (used as a sentinel to skip folio operations like lock and rmap).
>>
>> In the huge zero page branch, src_folio is NULL, so folio_mk_pmd(NULL,
>> pgprot) passes NULL through folio_pfn() and page_to_pfn(). With
>> SPARSEMEM_VMEMMAP this silently produces a bogus PFN, installing a PMD
>> pointing to non-existent physical memory. On other memory models it
>> is a NULL dereference.
>>
>> Use page_folio(src_page) to obtain the valid huge zero folio from the
>> page, which was obtained from pmd_page() and remains valid throughout.
>>
>> Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Chris Down <chris@chrisdown.name>
>> ---
>>   mm/huge_memory.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 44ff8a648afd..fed57951a7cd 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2794,7 +2794,7 @@ int move_pages_huge_pmd(struct mm_struct *mm,
>> pmd_t *dst_pmd, pmd_t *src_pmd, pm
>>           _dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
>>       } else {
>>           src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
>> -        _dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
>> +        _dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma-
>> >vm_page_prot);
>>       }
>>       set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
>>   
> 
> God this code is horrible.
> 
> Why can't we simply move the PMD like move_huge_pmd() would do and make
> this code less error prone?
> 
>     _dst_pmd = src_pmdval;
> 
> According to validate_move_areas(), the permissions of both VMAs are equal.
> 
> 
> We might have to handle it just like move_huge_pmd():
> 
>     _dst_pmd = move_soft_dirty_pmd(src_pmdval);
> 
> To also set the softdirty bit.
> 
> Then, we would want to just clear uffd.
> 
>     _dst_pmd = move_soft_dirty_pmd(src_pmdval);
>     _dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
> 

Chris, do you have time to follow up, or should I look into it? The
issue looks quite bad, so we should tackle it ASAP.

-- 
Cheers,

David

