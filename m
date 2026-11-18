Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021D7606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AONlAC63
Received: by kanga.kvack.org (Postfix)
	id 2685B6B05B0; Wed, 18 Nov 2026 09:48:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FA06B05B9; Wed, 18 Nov 2026 09:48:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156096B05BA; Wed, 18 Nov 2026 09:48:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E63026B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:48:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 795441A07A8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:48:06 +0000 (UTC)
X-FDA: 85448519772.09.705D60E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 99D7E4000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:48:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AONlAC63;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013284;
	b=ZRLhTlNbdhHS/8bbclmzHzI9wzzs+YqU4o5Yk2aSYuH54a1sTGfREgdm7/PRiZU/56G3E/
	yz/75Pqv7a+5GMbRH5+r9yw3ZQAbeL4O0qPNEiarByWxbCUSNQZxjfC4lZEy0C9GNjlm4C
	MZN4CQ9ATEJQEGtb9hGTqNcFvOt0CJk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgIk0c6UNS62mWYSKVJA5NNvjxDOsVkTrIzwZXXROI0=;
	b=PYr1flPpYxyRvhIIgzMi0JrXr0uvEmh+RAc44rJD06XUrzhrqaIVeRFxuCXEpETFYv5C0t
	tc4EMumLcgWmWaQJ9sKulrRRBU2azEpOmr9MEhLLKk5vVjy0E4Ht3QR1vjKEk6g0JEe/cg
	XYVM7ySDJr3gI5IvgKZ7YGT8AAO2rZM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AONlAC63;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B83884053E;
	Wed, 18 Nov 2026 14:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BAF1F000C4;
	Wed, 18 Nov 2026 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013283;
	bh=dgIk0c6UNS62mWYSKVJA5NNvjxDOsVkTrIzwZXXROI0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AONlAC63rN6sslNW3flaTilNQZcValUiEiEcrea9nIx6rCmjZQjcKw76isozjWcxX
	 Fg9tlu2BTWxcI1fyVWKg1Z9g2ZgzgRsqPvHSCW0LBu4XD6BRuQJf1Rtk5o2T4PpD+1
	 LHViGyl4FS4ZHLksKNRTxLIzXAz+NJJYlvpF6cokCL5E0neMnbskv1sja+jSLGFmSf
	 aXaRVUQXitaqehwlNAOAMdnLk9UbL0V6sADNKslipxzZOV61QjaLSSHuq1YDk19Fh+
	 PXVWCWpF0RTKKZGDB2EWUdHFVFasZl/X83Pk6bXgarRHUfSYTweUwQ8qJpeHLLxSWr
	 mlxD+NfnAcdRQ==
Message-ID: <0da29b65-fd6e-4b5d-92eb-0a8f0c25999e@kernel.org>
Date: Wed, 18 Nov 2026 15:47:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/memory: don't upgrade non-present PTEs in
 insert_page_into_pte_locked()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
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
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 99D7E4000B
X-Rspam-User:
X-Stat-Signature: n4fg8qa6m914bcp7yteuezun4xu853j1
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795013284-411244
X-HE-Meta: U2FsdGVkX18aejnOFDFNq8kKQOCnW54hlmtBATKAalBd7SA7GbZTGDkDKGnc7JfiUFEFUj6SqFP7KHqXxEDzmGgkXPPnAjcV2uoVvsge5v81yX8tFz5od/8/+xV5nC3qnminWOXXzsdbSesalpuZyNKBC5iu09GT/MgCCUtL+Zh/EezCy4LQfNp6PXdOi0uexCfTBLHIp6D3eai4ccUu7JD2tTFolLYVEQ+1Y6dMF0KJckhpE6d2QX5fjzNcwXN87ithgkk4ijYKhn2+66XeazT4KyIeN7SlxQVN8tysPUbwncSTYtds8eS1gFAfqLOhX6m4mrvV1giSy82l2jqZxMnCsqV1KzXIfHxGIcLVjUevwrnFdTS93iJzIdQyzu9CYJ5Axs0t8ApHb/K5GS900E+IUYVLQPbQT5fezmGkouLTM3eM3KLmy9ssuwVyX0vChDsBYed5EueZ8phShuuVdI5oxzMXa+RIeDJbHNWC7LKD41NuWQ5po6gbN5IOxqyAw2+iw4Fwwn97JjrY6AVHV0Mu/4YClwON7EnAR1DVzWcoexjnkXdJMn7cwaLbn2K9Yf0VfPUUjrVncYv2YZGDvjCgOuYR1FWIVAOt+r/KRKdUUpr3leSor1sjQt2Reo0+a7H4kQ749/zNJGEGIMpbpilaO4ByfY1/s+zih0bKR3qLu5XsJM6xQ2C975T3pH/WM7aRNLoEiNlj+BQGNwN92/tc+v3cupJtZpoeF7ZErAapoJPxj068uOVGvIxSBAqzNejutB0UuiFfyA22S4j3rJZALNhy9BexRDK1i+zTJizMXQS8+1n2Rc2TIMg9Wtj2lKYQinI/IHtsq2uMg9bkospdvt2v3gwXA+FPBbHq5Jsky6GMbuWit86+vLF+XpbHxMSiqfVQDApq0aAGi3x9xyVuQVv+8eKS+5VqCxVomd9DH7TuL62S4soBXFxPaQgtOmgkCWymz4+m8Xi3VG3
 EirzSUQN
 Q0sm2FOaZjbucvhxzLmHUDrxS/GzdJG7R37NuqqyJv7B2ciXvyagiBm+liZJfv4NNh4WjuBh4d3P7BWwYAGR/AnAqAL9te6kUC5WXgvRU7eTX/7i49o6kXSWrMpG+BZJHrQSLJQ/JVCxvIQr0MsfMCLkMN9xFp7pm4tG33s4JHlIPCSLjdppCrMXRy1xrfnWNQx3jGZX3J9OZ/xDmJhH6FEFuTJIeEGiqfk0uVHvSqLGApAIUj27TzLdoZkL1+jKjKCfVfjfC5/Q3EwSb5YX2OYwnl9rv+pq7yT85mMEz/w6q4Fj5QWtsPBmJpCkn5aEveVDr53C6faTtk5bkS2uEFzlgwBidjJfzXpYV1a0les+4lkpYaPjMVDXo6ML+wiLpHDMa19oj6vg9PuG/ZTDI8QY6u4zPU+op/qHGlt+a3MC1KEybsL/EEGm9UvxdYuSF1RV/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 16:58, Mike Rapoport (Microsoft) wrote:
> On a write fault insert_page_into_pte_locked() assumes that a non-empty PTE
> maps a page, compares its PFN with the page being inserted and upgrades
> the PTE to writable.
> 
> Since guard regions are allowed in file-backed mappings,
> MADV_GUARD_INSTALL can put a guard marker into a PTE of a DAX mapping
> after the DAX fault handler found that PTE empty and before it inserts
> the page.
> 
> vmf_insert_page_mkwrite() then extracts a PFN from the marker, hits the
> WARN_ON_ONCE() and fails the fault with SIGBUS instead of the SIGSEGV
> expected on access to a guard region:
> 
>   WARNING: mm/memory.c:2489 at insert_page_into_pte_locked+0x47e/0x490, CPU#3: guard-race/157
>   RIP: 0010:insert_page_into_pte_locked+0x47e/0x490
>   Call Trace:
>    <TASK>
>    insert_page+0x6f/0xc0
>    vmf_insert_page_mkwrite+0x31/0x60
>    dax_fault_iter+0x3be/0x5f0
>    dax_iomap_pte_fault+0x1b8/0x390
>    ext4_dax_huge_fault+0x1a4/0x2f0
>    __do_fault+0x34/0xc0
>    do_fault+0x179/0x610
>    __handle_mm_fault+0x8ca/0x1250
>    handle_mm_fault+0xb4/0x290
>    do_user_addr_fault+0x15f/0x730
>    exc_page_fault+0x83/0x190
>    asm_exc_page_fault+0x26/0x30
> 
> Return -EBUSY for non-present PTEs on write faults like it's done for read
> faults, so that the fault is retried and handle_pte_marker() deals with
> the marker.
> 
> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 66ad58429967..a80925c61706 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2474,7 +2474,7 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
>  		return 0;
>  	}
>  
> -	if (!mkwrite)
> +	if (!mkwrite || !pte_present(pteval))
>  		return -EBUSY;
>  
>  	/*
> 

Ugh, so this depends on some changes in Andrew's tree that should not be there ...

Let me figure this out.

-- 
Cheers,

David

