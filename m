Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 016C2FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 19:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FF616B0092; Tue, 28 Apr 2026 15:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFD36B0093; Tue, 28 Apr 2026 15:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578296B0095; Tue, 28 Apr 2026 15:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 472056B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:46:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C8051603EC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:46:08 +0000 (UTC)
X-FDA: 84708995616.11.C5724EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3100D40006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:46:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ik8AqnBV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777405566; a=rsa-sha256;
	cv=none;
	b=ryIExJIsPhTvoactfPfTfaHQLkZmc2E33TqTW3PPjfzflA5P0aqROp1AfIoIFjI/UDMtVZ
	gFTOZWaiH1ZmAqEdPIRVdLNGOMntuzph4mjxeAuk/brx/RFKrL77G5r6biairQiieX+e1k
	hKjYtyHIl5lRmmufxuzc+OgwdAF44+o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ik8AqnBV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777405566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcmGTlHTFKCdrFxrhE+m2ydPFAjMTxdTQd5mmv5nnhM=;
	b=RX0xjvP8xZS61yh/olalqPKAiMLLGNeikqBwwfKBWtYNQhLDkaab8JDDLRi9VeYpy2DcD1
	Lsle69FaocRx/mkMbH09RGBDDhTwTtyXWptHvlmJajWRTCyHh7E4rqJj0Z4JNR3Pg2TmRD
	j2Nk4kiv3S2JidBfK+QKbjr+IxnD7/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 287AB41A5D;
	Tue, 28 Apr 2026 19:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6B5C2BCAF;
	Tue, 28 Apr 2026 19:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777405565;
	bh=yvm5AAW8pWe+hcrCUl/s0FLrh+xzKGKcVtjKj0e9BOU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ik8AqnBVEniWxz4gB+Db0JUp63he0UIJizJ+2MIrottcKhFRnNIhICcF7fZYkOTLT
	 CkghgSUxL+v5S8q7MdGMtKP0YjSBbTlje+3MaZgwaqY3sxmf8BcLxNtIyUngHjf5wU
	 p6rZEuKr0hDBjEwMBgrw6ZsZWJFxgvVv5i9eh+tY07iXVNWMNUdWfXx3dZvxGp/JLv
	 XplyZYFhpqE3ivl15eC9v4gizmathKxxt7/qBOUJ2juHfIxO8X7BJEUQ62YoqM1N6o
	 OxAy1fbz4I1nFX0IaT3Q9vG5/iRxE8/kKgem3VJbjxNSBSfVvzP84rS411M9fDIKwC
	 U80q4+bXXrHzw==
Message-ID: <5f45cc59-d71f-409c-8cfb-6eba23b0a447@kernel.org>
Date: Tue, 28 Apr 2026 21:45:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/gup: cleanup pgtable entry accessors
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>
References: <20260421051754.1691221-1-agordeev@linux.ibm.com>
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
In-Reply-To: <20260421051754.1691221-1-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b6dnjotxt7txtuirwcea3y3qksa9yn98
X-Rspam-User: 
X-Rspamd-Queue-Id: 3100D40006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777405565-520759
X-HE-Meta: U2FsdGVkX1/mLv58aBDXu6nEtiOMBFuQfA4jCOEy0Wgs8T0KEU6x0RQqWPQmLWH40ZeHlvXzV3ONgBLZ7VVZ+6w+FgnN5MO6Vtk5ZrpaCvJwRq/gz1nlEKChEuzsDO5NfiMdlUTNlvnJAbjV3AigV9G7dVX7yqoRGL+jF1FFF9YN2lMmd8xFQl51fiB1PVROOd6v0C0jZnIXDX81IgCA5sIFtFU34qKKRGeaHjziX/5VFKfMP6k9hvnJk969pSLuN1KuRq4jm9XAFMFHQw1MgiuY1Ib+9RZSS9cc78nJbZAmnMvXhomTageauZXrdxRUxv4Hu3PdfYDJXEWvLswzBnPBCIjNLQ9m6jJcF6mR/XEs0vtRj0QUmmIy3ZC4reTnz53TL6CNbr6DbnaKKyrF+gezT2/Dz+tep7mB7vNGivt+Sz7yYSCd3L5I8xJ/ip29DqyW1M121/UIYYt7MvaSWctZGaqoFlc+E6rjzUM5aAvlW4p9KX9AEoW5HgdWCdhrOqM+8qRQ/ub8BmaTghRFwTXu8iAcDtSdptjzLbH437HtvG/ifnYzoKGhpq9QATOWcX1B+0lbkAdZJR4Hk9brjXyC1J/cZqFxxMcVAbOZ37jgsNN4DIxMFTSNAjeEsNUWHR93THULwDZPgSSYUEPpq14JTMEKAH8Wsalacqb4zW6Nq4/FxYBgo0aJGEWq4mMAPrlTclZV10CuIVGzUJ8Dfm8V4MRr63FeT5HzB7UDJuovQQw9AWEipI0Vqq8n4lBJ+9a82M24YBgXmsbKhMQi8AiAR9iIsGJvtduwErWt/IrB6m8HN/wISCX7bExlVyJvq6x5Yj5dcuYFIkimlKlt+b5xbUbT19JYwQzeIR+kVMtmHbvYvv1qUFWLSI9FT+D0Z+yLukHTVOhf0RHPMRlnWju2ySBaVcBL/IOV/dvBBK+ox3gv5TLHuPDivWW1fFZn8ijJX7pXNfWOMM00GgD
 MESd2Cph
 SQ+337Zc6xUujDxlO+N0dyw6MqNtwbF0f7samkraKrnvrDasVdd4qZz8h6QvQvuKTel/tr+z99tI48/RPzPx+ucseRwDKJtTqa3XivS7Jj4SJUqu9++42h1LivDod5fYfhhFX2kuCTSHgBW8rsgxmWGGBcajSWvf4TxLJjTOLhjuJDQUVyk3ynvGdmr0Y6QC7eQgNyXQhS6k2ZvzPXGe3iNbbhzcnn+95rR8gzObp3lpSf8WDD/9y9gMaw0qSvxV8+cytauXby7cKlrMhGB6bGIX32g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 07:17, Alexander Gordeev wrote:
> PMD and PUD entries revalidation has the same semantics as PTE entry
> revalidation. Convert the remaining direct entry dereferences to the
> corresponding accessors.
> 
> The PTE validation in gup_fast_pte_range() is inconsistent with the
> prior value acquisition in the sense that it drops the lockless
> access semantics.
> 
> Use the lockless accessor not only for the PTE, but also for the PMD
> validation, which is likewise inconsistent with the prior value
> acquisition in gup_fast_pmd_range().
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  mm/gup.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 8e7dc2c6ee73..236450feea9a 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2865,8 +2865,8 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  		if (!folio)
>  			goto pte_unmap;
>  
> -		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
> -		    unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
> +		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
> +		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
>  			gup_put_folio(folio, 1, flags);
>  			goto pte_unmap;
>  		}
> @@ -2942,7 +2942,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>  	if (!folio)
>  		return 0;
>  
> -	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
> +	if (unlikely(pmd_val(orig) != pmd_val(pmdp_get_lockless(pmdp)))) {
>  		gup_put_folio(folio, refs, flags);
>  		return 0;
>  	}
> @@ -2985,7 +2985,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>  	if (!folio)
>  		return 0;
>  
> -	if (unlikely(pud_val(orig) != pud_val(*pudp))) {
> +	if (unlikely(pud_val(orig) != pud_val(pudp_get(pudp)))) {
>  		gup_put_folio(folio, refs, flags);
>  		return 0;
>  	}

In general, LGTM.

I do wonder, though, if we want to switch to pte_same/pmd_same/pud_same while at it?

-- 
Cheers,

David

