Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C592E606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RFU1M5B6
Received: by kanga.kvack.org (Postfix)
	id C90256B05B0; Thu, 26 Nov 2026 06:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C682E6B05B4; Thu, 26 Nov 2026 06:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55D86B05B5; Thu, 26 Nov 2026 06:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AC2D6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:49:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D68D41603DF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:49:25 +0000 (UTC)
X-FDA: 85477099890.26.5C3654D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1DB85180005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:49:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RFU1M5B6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795693764;
	b=tSqaEgqP1eBW7NxUZjHjyfVMb9WzpkeFhzMOR0AQ/VpGzfJP/rqpNlpVQy0USWn3JxvMDl
	BRg4skUedf4hz2El+CkMpbUiWQVvSCpN9s6vAxSLmvEJlsDr7jV/7EJmrEDso20ocJpeEq
	Cn8lOMwhSqUMGCc8jldTuNJG5tIVi4k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795693764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prqNRuOzfkxOkOHCn9kcZAFGbV2mS40NpocSQiUBUyI=;
	b=hFIkRGRfyjL/rnG2TGDfHwVAdUXFt0TGjhgOrj8JkRVKUzqbgekPYTiAy7SQtX5jWT3b4U
	EG7rwd4iEviN3NAXfTf85QdVzurmZ71XkIRRMYlZ0mfwiSxq5j0aQfq3bqk/z0mMTMJqPb
	8SSgdwkW/Sp/j6nGHiVVZcTSYTyUiMg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RFU1M5B6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E6F361CED;
	Thu, 26 Nov 2026 11:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41411F000C6;
	Thu, 26 Nov 2026 11:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795693763;
	bh=prqNRuOzfkxOkOHCn9kcZAFGbV2mS40NpocSQiUBUyI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RFU1M5B6BK41dK/bGR2LkNJbxHdbBuLZUCk/ymY7pErdz3QvSOBBy+QtVG5wRlkO+
	 bSVhs5Isg3uXpp5WzMEJtDDFJgNJ8MzXwORpByfjTUUyBMFo1cFkQtN+/HTmGEFK6j
	 BAyOp1/bTYxv3tuoHLXuTUAqOYzRLzeea0KHAATaOpX8QGehcAHncRQSJB14KLkfbe
	 ttzWv5cpERp2AltsD3L0LU7ROBTMwf1qrq8USMiraVoBfBoJQsxBQ759ulBOzUbMVo
	 ZOSNniHJah4eE6SRaz3VUD5UcIlTzzLPGlU8SDapv8viYCucJL0xhpkwVtCE1uiSf0
	 CNScoicGhyFEw==
Message-ID: <cbbd77ec-447a-4eec-a45c-c934c0011edb@kernel.org>
Date: Thu, 26 Nov 2026 12:49:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/8] mm: move anon-exclusive batch helper to rmap.h
To: Dev Jain <dev.jain@arm.com>, ljs@kernel.org, akpm@linux-foundation.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20261123053543.295467-1-dev.jain@arm.com>
 <20261123053543.295467-4-dev.jain@arm.com>
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
In-Reply-To: <20261123053543.295467-4-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1DB85180005
X-Stat-Signature: xysr1gjzyhhxuerub1isjgs63bc6rg96
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795693763-701486
X-HE-Meta: U2FsdGVkX1/AWoSeBQeoQawXL+v82ORvz4tgXwWXaSYKz/kd1RCVOk+LA4M5T/i3ENdk81zIcrWjyuVn+3dMhAZuECU7RT9/2F0HDqS10t8FRHfr4Zq7dBva1XOoJob516WoKKujXMM8CLeYfG29oxDYPndh46TRhY4viDF4jAAit7MQ6Z0UZwqWv5yxsGKtIOXAMnp10MFaYNDFVBbIfhcaV4GSS4kXbUfQmeMEafqVL/xQdbjMbaEybwLRcJ7XZuZnO381BNw59o7Gi2Tk1wmzw+SBWxnu5azBhFqVciIGrjSX1Xbq0JpGBIzJCVO2CPUex9BXqPVW0uFVJ1zf7vtAMUCk97sp5rO8aX3Lh1rumpQrQPv73yuCNyVD7xT8NmlX1i4f4cLui6A899sdZbQRFlUbduWqUcXLDIjwjFsuxxvilGcFDypKXylt64ICmpx5MxjVw0sQa1Gz4SyRBfrk2YaIX092zL7HkAAQPugmO3AxDV7j5Ha+4Mbd1iqLxouaYDiCUdwNgPx72XL20O+EbLOoInK8W/AZyc7jhJu2cbybkOC1MrApS/1Ku/Lvq6h9qGVgpaIa+WrVjFBZwad7p8pd7q+98si9Da2S7lUeaV46hcLt1/+UhxYAoXRHpcae3G/bMh5xnxQdFP9YDbSs6KsOtrh26L1wYEImDMNRS3SEd1THUc6lbZ8Hlw+9iObOqxXwcRTLAiztQWB7siqnaGecMiCVJnMg3n0zAPeIKELaOhlMMgDPzeSZx5SHfrpuwVgRFYT7ilQgTi4L2j1zWr5Aarr4veEtK1cKpL3uo9j6RgJ08YzSRVje5zZ6qiF9nYqAvYuZN57Q+ebgFUp0HIAtmH/DLyptvnRnHDRIAlGxe0JxhimMwAY22wNqGhSK1S7XaBAdmLO/AXurg5JtHI9lYOPfNkCzZUe4gk8oy+md5eWQIOUxzLXuUTNkpPSYfBixJ0NHAGHuxpw
 g/MsV1Ez
 F6aVgthGJe559RpIFmPYkK/T9kxOykNayQtHlE6UyqBW6XpJKpu5QcvvY66ZJ+syE7purUG7/zXytSJ0QcrtEtt6xjekojPW1W4SLTKpFDgTIum/MMdNFMEeyM6x3Ow7If+apU9DMHysIa+U3txOs+LEmlhuckkkHPBhtUE3ZCOEkPjgQBjY1jA6zEmEHrTcqkaZnA5FcIVt3/pzT3Ably3TtvB+z2oe1z3UuWAM3JTgNrtfYMkAqQLD2EiEIlYxjreSE3pN+DO2v4ZJTUIA8eiYpCmRZmnsCJBwMlgOAIMNy+Mm6AgacQuUMIoScOZ/1EXnvxtGKWQZwobGxtn1SlNq0f+BtDSljgT5mGSa4ixytMn/TyhTuRZduePCQUTQbOH+jGNbNhZWgBy6ZMe4P+VpGy6yFXoXbVlq/lSocWE/7aDZ+QEHIP9QmjWzOg3Qe+S390HMV6lFp52/BcyC+hKs172G9O9dfsF/Q2e0Aey1CQ1S5b+7CUvYOZ2+V2nflNl6GwkdOn7sHAU1t+HTGzx2g6aXVc5pdxP4JCXOd9sXUaHzkxxjvqpAhZu/HkPu8oupe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 06:35, Dev Jain wrote:
> In preparation for optimizing large folio unmapping, we need to reuse
> the page_anon_exclusive_batch helper in rmap.c and rmap.h and obey the
> existing use in mprotect.c .
> 
> Therefore, move it from mprotect.c to rmap.h.
> 
> While at it, change return type, start_idx and max_len to unsigned long
> type for future proofing against THP support at >= PUD level. Also
> make the helper return the anon-exclusivity state through an output parameter.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/rmap.h | 18 ++++++++++++++++++
>  mm/mprotect.c        | 25 ++++---------------------
>  2 files changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 9f5bfa317a5c..ec1e85855be1 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -106,6 +106,24 @@ enum ttu_flags {
>  
>  #ifdef CONFIG_MMU
>  
> +/*
> + * Get max length of consecutive PTEs pointing to PageAnonExclusive() pages or
> + * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
> + * that the PTEs point to consecutive pages of the same anon large folio.
> + */

Can we just add kerneldoc right away?

> +static __always_inline unsigned long page_anon_exclusive_batch(unsigned long start_idx,
> +		unsigned long max_len, struct page *first_page, bool *exclusive)

s/max_len/nr_pages/

> +{
> +	unsigned long idx;
> +
> +	*exclusive = PageAnonExclusive(first_page + start_idx);
> +	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {

++idx looks odd when not used in a statement.

> +		if (*exclusive != PageAnonExclusive(first_page + idx))
> +			break;
> +	}
> +	return idx - start_idx;
> +}
I'd write this as

const unsigned long end_idx = start_idx + nr_pages;
unsigned long idx = start_idx;

*exclusive = PageAnonExclusive(idx++);
while (idx < end_idx) {
	if (*exclusive != PageAnonExclusive(first_page + idx++))
		break;
}
return idx - start_idx;	

...

>  /*
>   * This function is a result of trying our very best to retain the
>   * "avoid the write-fault handler" optimization. In can_change_pte_writable(),
> @@ -173,16 +157,15 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
>  		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
>  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>  {
> -	bool expected_anon_exclusive;
> +	bool exclusive;
>  	int batch_idx = 0;
>  	int len;
>  
>  	while (nr_ptes) {
> -		expected_anon_exclusive = PageAnonExclusive(first_page + batch_idx);
>  		len = page_anon_exclusive_batch(batch_idx, nr_ptes,
> -					first_page, expected_anon_exclusive);
> +					first_page, &exclusive);

Is that only oddly indented on my screen?

In general, LGTM.

-- 
Cheers,

David

