Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF43F327BE
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 08:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4FC6B0088; Tue, 21 Apr 2026 04:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C8D6B0089; Tue, 21 Apr 2026 04:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2EE6B008A; Tue, 21 Apr 2026 04:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B83E6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:07:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA5D65AEFB
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:07:05 +0000 (UTC)
X-FDA: 84681832410.28.BE35C51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0B2BE40010
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:07:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fkHP9WZM;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776758824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWchIXmrM2+1+LrH9qs/skp8BqIZAna6j7MV5rZtOPE=;
	b=enUxNQf0V/4sgRluQa3CuJSvrU6sEZ4bby8d4Bk2AZAZxJ1XGFgfWbJfc/JmlblrExAWgn
	0ZkfFJiImOcBcBXxyQyOREBXBX5zOzuD8e1Y1VHbuiwoq+1e2OQQP2e8I/tA5Iz3wfrLDC
	7jhUSZlIIk3VW2aJvOgznR6Blw6sS+I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fkHP9WZM;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776758824; a=rsa-sha256;
	cv=none;
	b=rpwLX9nAyHhDrrzzzEQFtHaNawwQmILTw7Us8rBNgWgwdtQ6A/soq83QVNvcua2JdditpY
	7MIY7KtFPRq45ZfW2kqVTyYO7Lp3C/0K/0IskFzra5cimW9AWuYJqRb8/m7+a5k78GtKuT
	VFDZdNff6z22Go0MSBMWBpoFHpYJOCs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3CDC4090B;
	Tue, 21 Apr 2026 08:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577C1C2BCB0;
	Tue, 21 Apr 2026 08:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776758822;
	bh=fdxo8CBTBMGIc3yr4yHUHEx/bRkybwgOmKvLGUkEwuM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fkHP9WZMtMW5sgVsB+YoXCot12XyGdRt1TFMtbL56ucDBBK+s8jiqOmho52rufvSB
	 QHc7oSIGFJkqtFHvqanqKiqBoXAVB7roFy73N4XUBGkhynYpWpVGSSIXzWLklX1Ck8
	 C68pQfk8ae+SKy/vW6MW9gnQqedUeMGWSXi/TlcXtegwXiRhD4rDXqq9n6jHESxGX5
	 2h4i9L6h4Xgj2r/4lQpSd0L/lvHQKrlsS6uP+Un1aTnzD2h+A1h/tGwsWWRNcS2OPT
	 ZYl9QIQVE79v68IRj4cs6nHO9a2vHJeyZOwqncIPqxi/Qc5abvxPa4luVIuREwD0XT
	 6IehlROdf+4Og==
Message-ID: <94fdc376-9c43-4334-b293-20a54acbdc3a@kernel.org>
Date: Tue, 21 Apr 2026 10:06:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: fix initialization of tags of the huge
 zero folio with init_on_free
To: Dev Jain <dev.jain@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lance Yang <lance.yang@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260420-zerotags-v1-1-3edc93e95bb4@kernel.org>
 <5463cf34-bd8c-4ecb-b93a-fd8b2bd2976d@arm.com>
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
In-Reply-To: <5463cf34-bd8c-4ecb-b93a-fd8b2bd2976d@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hure155gp95z7ag3rd7zpi514y4jqws6
X-Rspamd-Queue-Id: 0B2BE40010
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776758823-335813
X-HE-Meta: U2FsdGVkX19STHiRyXanl1E9A6qRXVYTXjVTl9tfnlZONffGwB6ecuJvk//uLuqFvPnQadlIWXZszrbIiuGv3407rMdY/bCwuQMxnDkDcZS7Ho9TL0uCN3/gg9ThLkKRQQEeAS3GHJNk04H8DknCcDX2PwmPyVy4xxShQTrXAgL75Og4ShBOsyQJxaHZgFMfNJrU4cCqSIFC4BOFgHMBSbAgjOIbc040/nBLOT4+mE7WEPK6GY/7pJIJCDEwqZpb2CANQt3dmzDvKQy7oGraZ4dxllYaK4DrrDNzCrQKrRLEJI0EXaqf7W8BXpN2hZt+/lt3r/mdH4NX1UJcWOcGOBvkxaer0jIz9KloOXUPGdze9JCo8g+r0hsvjERZbSPif3i3+ON5et3nUXNqANNzlICAmkkRWxplcr5npz0nGweRyoeOWWbuvKhh+Xj8lY9yl8p2rVhKafImBQO6pyW1LyJFCrSRfoOEbV8/BxLjcNY+TOddjpF0kXfa9ZJOA7dZIkY2sxUdSCrdYr1pCJohZfNM971HLNNYTt2lpfZaB8c2dwROreM7jqLl4GEn87BO14FRyo3NBZrGVbwiL6mYfEBfGBXa0dN0qaKD6VeAES82GjL08M/GEeIau4/6sVS2bRCXMCm4tGCZIr07Vm9pktmEUgwfgzvhUq2CcGeYiCX3kJid2l14FqgfvhoM8WPyWhV/PPBmfHDVoOzNhAsrRcwR9MEWCCbPQIaJXlBBwBcL+noF0p5j12TbNGyutG4I4IEAXX1yUdU27OcUS+UnNrZjnhvZVD0WiCytsCbZsxPWY8lZsA55LuHpKjihoyLBoHFI5c3HCGd7MDbfMAZbPN5fhH5D0hHOD8nwVSgBAc1l0siU7lVMayViewuiH0zKK1ClIhLcTvuG9c9gtw7GBy6fW8FlnLQQ7uv4b/qhLScRwVVMJJablVUMpQ8QSex+nEuZgBDxhE3rQDp9VSW
 98kNXtjs
 FsIwBg0t51JjSDqIlESsbOa2wOfx8Kx9UQ9TVsQPk+wXAA+W2Iyol3Svo5m5jQw6eYLZFDB97yWx2uEN/7TPfZYV5K7vTdpA/Y9f/sEJYvdRKrTkh5Y0lQ67W7Bfhgin4erjwdbb16noDT25D276GX2KaWOwcdKMJNAPNbw0e7m0Cegqroi9BFgxd1m5z5+QpJT3aM09ol3cMO3fzFRrS8C/DMqnuqJ3F6FfUIft8WBc1lWtyRu/7jex0F9idpb/gtofJtQgc2PLz/7UVITP60tt1wxOa8c4Us7L0ClJH/IIG8A8ptJ/uYT+Y+BTDfqUi69MCd2wTMIOPa5vzNPnh7v6mvoO3jF6+PuLHgxdzX9kpcRc2IjzLGj83chwX5c10h7jwP97Lxck7DgE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 09:06, Dev Jain wrote:
> 
> 
> On 21/04/26 2:46 am, David Hildenbrand (Arm) wrote:
>> __GFP_ZEROTAGS semantics are currently a bit weird, but effectively this
>> flag is only ever set alongside __GFP_ZERO and __GFP_SKIP_KASAN.
>>
>> If we run with init_on_free, we will zero out pages during
>> __free_pages_prepare(), to skip zeroing on the allocation path.
>>
>> However, when allocating with __GFP_ZEROTAG set, post_alloc_hook() will
>> consequently not only skip clearing page content, but also skip
>> clearing tag memory.
>>
>> Not clearing tags through __GFP_ZEROTAGS is irrelevant for most pages that
>> will get mapped to user space through set_pte_at() later: set_pte_at() and
>> friends will detect that the tags have not been initialized yet
>> (PG_mte_tagged not set), and initialize them.
>>
>> However, for the huge zero folio, which will be mapped through a PMD
>> marked as special, this initialization will not be performed, ending up
>> exposing whatever tags were still set for the pages.
>>
>> The docs (Documentation/arch/arm64/memory-tagging-extension.rst) state
>> that allocation tags are set to 0 when a page is first mapped to user
>> space. That no longer holds with the huge zero folio when init_on_free
>> is enabled.
>>
>> Fix it by decoupling __GFP_ZEROTAGS from __GFP_ZERO, passing to
>> tag_clear_highpages() whether we want to also clear page content.
>>
>> As we are touching the interface either way, just clean it up by
>> only calling it when HW tags are enabled, dropping the return value, and
>> dropping the common code stub.
>>
>> Reproduced with the huge zero folio by modifying the check_buffer_fill
>> arm64/mte selftest to use a 2 MiB area, after making sure that pages have
>> a non-0 tag set when freeing (note that, during boot, we will not
>> actually initialize tags, but only set KASAN_TAG_KERNEL in the page
>> flags).
>>
>> 	$ ./check_buffer_fill
>> 	1..20
>> 	...
>> 	not ok 17 Check initial tags with private mapping, sync error mode and mmap memory
>> 	not ok 18 Check initial tags with private mapping, sync error mode and mmap/mprotect memory
>> 	...
>>
>> This code needs more cleanups; we'll tackle that next, like
>> decoupling __GFP_ZEROTAGS from __GFP_SKIP_KASAN, moving all the
>> KASAN magic into a separate helper, and consolidating HW-tag handling.
>>
>> Fixes: adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  arch/arm64/include/asm/page.h |  3 ---
>>  arch/arm64/mm/fault.c         | 16 +++++-----------
>>  include/linux/gfp_types.h     | 10 +++++-----
>>  include/linux/highmem.h       | 10 +---------
>>  mm/page_alloc.c               | 12 +++++++-----
>>  5 files changed, 18 insertions(+), 33 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
>> index e25d0d18f6d7..5c6cbfbbd34c 100644
>> --- a/arch/arm64/include/asm/page.h
>> +++ b/arch/arm64/include/asm/page.h
>> @@ -33,9 +33,6 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>>  						unsigned long vaddr);
>>  #define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
>>  
>> -bool tag_clear_highpages(struct page *to, int numpages);
>> -#define __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
>> -
>>  #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
>>  
>>  typedef struct page *pgtable_t;
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 0f3c5c7ca054..32a3723f2d34 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -1018,21 +1018,15 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>>  	return vma_alloc_folio(flags, 0, vma, vaddr);
>>  }
>>  
>> -bool tag_clear_highpages(struct page *page, int numpages)
>> +void tag_clear_highpages(struct page *page, int numpages, bool clear_pages)
>>  {
>> -	/*
>> -	 * Check if MTE is supported and fall back to clear_highpage().
>> -	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
>> -	 * post_alloc_hook() will invoke tag_clear_highpages().
>> -	 */
>> -	if (!system_supports_mte())
>> -		return false;
>> -
>>  	/* Newly allocated pages, shouldn't have been tagged yet */
>>  	for (int i = 0; i < numpages; i++, page++) {
>>  		WARN_ON_ONCE(!try_page_mte_tagging(page));
>> -		mte_zero_clear_page_tags(page_address(page));
>> +		if (clear_pages)
>> +			mte_zero_clear_page_tags(page_address(page));
>> +		else
>> +			mte_clear_page_tags(page_address(page));
>>  		set_page_mte_tagged(page);
>>  	}
>> -	return true;
>>  }
>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>> index 6c75df30a281..fd53a6fba33f 100644
>> --- a/include/linux/gfp_types.h
>> +++ b/include/linux/gfp_types.h
>> @@ -273,11 +273,11 @@ enum {
>>   *
>>   * %__GFP_ZERO returns a zeroed page on success.
>>   *
>> - * %__GFP_ZEROTAGS zeroes memory tags at allocation time if the memory itself
>> - * is being zeroed (either via __GFP_ZERO or via init_on_alloc, provided that
>> - * __GFP_SKIP_ZERO is not set). This flag is intended for optimization: setting
>> - * memory tags at the same time as zeroing memory has minimal additional
>> - * performance impact.
>> + * %__GFP_ZEROTAGS zeroes memory tags at allocation time. This flag is intended
>> + * for optimization: setting memory tags at the same time as zeroing memory
>> + * (e.g., with __GPF_ZERO) has minimal additional performance impact. However,
>> + * __GFP_ZEROTAGS also zeroes the tags even if memory is not getting zeroed at
>> + * allocation time (e.g., with init_on_free).
>>   *
>>   * %__GFP_SKIP_KASAN makes KASAN skip unpoisoning on page allocation.
>>   * Used for userspace and vmalloc pages; the latter are unpoisoned by
>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> index af03db851a1d..62f589baa343 100644
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -345,15 +345,7 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
>>  	kunmap_local(kaddr);
>>  }
>>  
>> -#ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
>> -
>> -/* Return false to let people know we did not initialize the pages */
>> -static inline bool tag_clear_highpages(struct page *page, int numpages)
>> -{
>> -	return false;
>> -}
>> -
>> -#endif
>> +void tag_clear_highpages(struct page *to, int numpages, bool clear_pages);
>>  
>>  /*
>>   * If we pass in a base or tail page, we can zero up to PAGE_SIZE.
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 65e205111553..8c6821d25a00 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1808,9 +1808,9 @@ static inline bool should_skip_init(gfp_t flags)
>>  inline void post_alloc_hook(struct page *page, unsigned int order,
>>  				gfp_t gfp_flags)
>>  {
>> +	const bool zero_tags = kasan_hw_tags_enabled() && (gfp_flags & __GFP_ZEROTAGS);
> 
> Sashiko:
> 
> https://sashiko.dev/#/patchset/20260420-zerotags-v1-1-3edc93e95bb4%40kernel.org
> 
> PROT_MTE works without KASAN_HW_TAGS, so probably just retain the
> system_supports_mte() check in tag_clear_highpages(), and document
> that GFP_ZEROTAGS is only for MTE?

Right, we have to clear tags here even without kasan. God, what an ugly
mess people created here with these GFP flags.

Let me think about how to do that in the least ugly way.

-- 
Cheers,

David

