Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA5DEB3620
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF1D6B0005; Mon,  2 Mar 2026 12:10:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD4D6B0088; Mon,  2 Mar 2026 12:10:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B58F6B0089; Mon,  2 Mar 2026 12:10:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3736A6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:10:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD3CF88A4C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:10:14 +0000 (UTC)
X-FDA: 84501761148.13.CAE6ACA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 279E4A000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:10:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BQpd4BiR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772471413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2u5vPiVzupj+As07YTa9QMwNHr6ufqQDPJnbzG13Vc=;
	b=5e6nQqVplpLuE4hT0j3Vc5p5aae3ysbvEwGz4Qaznj06UplnFOYOdK2O4Uc+d1PV3gRZ/+
	lUHK+i4n6xXtNhCzHkWSWCkUn8QY74k+oY/n1QwBSgxHDAnZRphBOnvO6XbI4fl5fWjMUR
	pRba76iLtX0A1E3XIsVkk3hDoWak8mU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772471413; a=rsa-sha256;
	cv=none;
	b=ZRLaqe4ZV44lbj26pFZyiZs+vjoKlmzXjd8YVM+bWbeqVFPC7uKOcLsYiaNWCrdfeIwNfq
	Q7/StxmZkq1d7l/xtW1Pwfh2EKLmsDcwXXn+n6Dx6HF7cvvx1GD0ZmswYYD7IsfnM4vlWj
	im91eavOqGTlA1dbwcUZr1Ov89PTBN4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BQpd4BiR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E94360097;
	Mon,  2 Mar 2026 17:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AF5C19423;
	Mon,  2 Mar 2026 17:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772471412;
	bh=jujI5PTVZLeukFg1F7/wlVAXbn5NpUo3sZPRb4/bT3w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BQpd4BiRMssnhKfl+1izhdifwWm0vZygYNim97Aj9I2ht5ckQFbx47TrTqL1IGtab
	 6iLtiiKM/fl7dK1ExJeh0nJhN9dnvSgSgGdcKluHnp94O5glAFXItZkfZqLJE58Oe3
	 NF3hjl1pcZ30D6eDNk+hz7oPHthBaiJc9uedYLB4OHlRQhDhcATwiGEjNdliBM+6IZ
	 ZUPhBFMdLFkA3eU19Y5KQkA9Ebu7wBDFRDVB6DZHuvk/gHt8+y7NZkt1ODk5v63nBE
	 JneS/GKyZVGPIGkylLJzyoUtDiEg9uAh0eyRhvhWCNm61I6S96HdYwOkYTXzOzMj2w
	 KsHJOYODCyQ7w==
Message-ID: <901fec30-c5c2-46c5-b48d-f9a8f5e5c928@kernel.org>
Date: Mon, 2 Mar 2026 18:10:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: fix memory corruption on huge
 zero page move
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Chris Down <chris@chrisdown.name>, Suren Baghdasaryan <surenb@google.com>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260302170619.867056-1-lorenzo.stoakes@oracle.com>
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
In-Reply-To: <20260302170619.867056-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 279E4A000E
X-Stat-Signature: inphmk6cr9zimia5488s7xq9bjh8ua37
X-Rspam-User: 
X-HE-Tag: 1772471413-744258
X-HE-Meta: U2FsdGVkX1+lkM4S+rCoPb5Anqp5UaDSUfP9PnfB2ueeS4YFJQt56mpFfAg5kdavS5CIVa8si3NF825sJ1G07Q/fpaXmBX+mdb4uHdR6c4mdyl3HUB6/X0TddkLnmvozofsMKPSw1XxsiH4S2lPuUybx4O9FiElAsoVc2NYP3wbzKAtwKeuFIHw4Gm/L1aSfqBrwbw6aSBvdlVBku32vSqsIfKGZUAN47wOcpytltftduAgQRKO6H9xUDzxc6MIUvmagf7/r6FdPFWNUJwzn+PBylk056gz4an/s0EbTyGMIoVfyJopmYmHv2w8K5OEloxxq/Lhj8zKEAR5mgCXmhmDiIDWBzwYeDMO++pIVCNAOkFGsmm6e3nW82Z5tcdzIKhsBRoAvf65q1SLlgBnTJGXIJYi6WkO73IhbjBR9W8ro9jgfbgqr1aREPvKA+C/CTavGaIS9WsYB4MJ1sR8hmKG5FJimjVk8TnJarj10LMn0UennSA1Iytx0I7+Zeye+gJ6ntrJcatNRP0Qwy5nhKfleC3wBfhperUyYtyKTL41DlH73G1KryT+WxZW65wt7O3tJGDJnGkg8HWBp9ZJLfF+cR1o+Fgb0ZPu/zRG16HQ1w4dP3eNuaYFAYdFknMChdDDXi2rgE/Tl5Buhs2bLxlwOu2Rk+eCG27SfDmQjRPbIIqOEOJONcR32XyXmJnKYXWBaMEr0pRHmG4E4WBNGzkSPsh0NLaPk76GXEFY2K8f7U5TfL2pvWs1BzgPUjCXy6rcHOFvw+MJT84RIKbuHBnJZafBMYpDWhxV0Lq7xJ0aEvw2jDgHp/QT/UuevaMrSxXQMI+0Bz+BkZ5GPJkFB/JUb4MXJAp5FnM10dhGYn3KakqC9cnq0BlSqin5bCGuV8mhJ417oFDYo0hM388BspE0z2PW7Sde/t6bmno/ocUFRHF6CTLfDKOXhPSD/iC1LvxaoLBNwhOikQTyHlQ1
 0dO/ZcbT
 n7AXrkQOb/ka1FmtORThMYll9kJ5v0/KMQzt4a0WK6G8ie66XiVJk9ay0lvpHv0yHCIKa7QHMFJxXUmammZt0o2fdmZCUBPs7V9jTPpLNBRNfBrqvtcuU1u/8xVBokX+DQBZQnSyM4gIbxa2swV//GCD+WgnktPkKfhFpM+rBMlOg7cfMLglnJJL+2/pr34Zhxrzk1nveNJnj2v4G6jrK1EZl3iba084Pbl1H52Wo6avTxAUUNtMEc28CpmDH8Kj1sVJqSbCavGCdN3kh2ALxHS/yKUbZVBVYxebx+k5YRp5I7/1XUmOgBFDTKW11ka9GiwKd1axJHlNm/5gcl8Rv1/3sUMEv8rX3RcNa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 18:06, Lorenzo Stoakes wrote:
> In commit eb1521dad8f3 ("userfaultfd: handle zeropage moves by
> UFFDIO_MOVE"), handling was added to enable the moving of huge zero pages
> in move_pages_huge_pmd().
> 
> This achieves this by setting src_folio to NULL, and adding subsequent
> checks for src_folio being NULL to determine whether to perform the usual
> move operations or to simply establish the huge zero page in the
> destination.
> 
> As part of this change, when installing the destination huge zero page it
> invoked mk_huge_pmd() on src_page, correctly.
> 
> However, commit e3981db444a0 ("mm: add folio_mk_pmd()") updated the code in
> the huge zero page branch from mk_huge_pmd(src_page, ...) to
> folio_mk_pmd(src_folio, ...), where src_folio is guaranteed to be NULL at
> this point.
> 
> This resulted in an invocation of folio_mk_pmd(NULL, ...) in effect, which
> causes an invocation of page_to_pfn(0) and results in the installation of a
> corrupted PMD entry and undefined behaviour.
> 
> This patch fixes the issue by obtaining the zero folio via
> page_folio(src_page) and feeding this into folio_mk_pmd(). This retains the
> use of folio_mk_pmd() whilst avoiding the memory corruption.
> 
> Additionally, this code path was not updated to reflect the changes
> introduced by commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of
> the huge zero folio special"), meaning a zero huge folio was installed but
> not marked special in this case.
> 
> This patch additionally fixes that issue by invoking pmd_mkspecial().
> 
> With thanks to Chris Down who exposed this bug by adding an explicit test
> for UFFDIO_MOVE in commit f07254dce67d ("selftests/mm: add UFFDIO_MOVE huge
> zeropage PMD regression test").
> 
> Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/huge_memory.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c17965f5682f..de2a775590f1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2796,8 +2796,12 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  		/* Follow mremap() behavior and treat the entry dirty after the move */
>  		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
>  	} else {
> +		struct folio *zero_folio = page_folio(src_page);
> +
> +		VM_WARN_ON_ONCE_FOLIO(!is_huge_zero_folio(zero_folio), zero_folio);
>  		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
> -		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
> +		_dst_pmd = folio_mk_pmd(zero_folio, dst_vma->vm_page_prot);
> +		_dst_pmd = pmd_mkspecial(_dst_pmd);
>  	}
>  	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);

There are already patches in flight:

https://lore.kernel.org/r/aaBVaHs8rIkNcwM0@chrisdown.name

:)

-- 
Cheers,

David

