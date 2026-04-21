Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9112DF89256
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2A0E6B008A; Tue, 21 Apr 2026 06:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01CE6B008C; Tue, 21 Apr 2026 06:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18126B0092; Tue, 21 Apr 2026 06:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1BA66B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:58:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A3D3E5D3C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:58:19 +0000 (UTC)
X-FDA: 84682263918.05.639A848
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E15BE1A000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:58:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GfPX7xO7;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776769097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zEyZM8/rbDUleahj5R0RBPr/fsqgnIZU7DeBLPbpmwI=;
	b=Y+ORd6xxXdhaFafvdox+c1fPQYIBGKzD1YNTpTvUUieB0xVKZJ8103Qe1EdE6RqgCOzglI
	YP4oxHPM5Y4bEQv3+gOA4mNlq23WRapDhFnyKl2XPGYsbEhoSr/u/DWVCZWrDklzanMPeX
	lL6LqDoLGNUWKRkqIJ+tekrivHz/SX4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GfPX7xO7;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776769097; a=rsa-sha256;
	cv=none;
	b=kW3oklPcTNYcbll1UxzE/sqJEASfvz5u0PkSrdc5p4AEEvnB9Msb1Wceopm+gWQUQrwobU
	NzPT7NBXf+zLJ6CIng2LUjrz+15BoxSfMvbdfKtKsvBi6efaOcHLMdE8fMSN68YrAhw/WR
	/GLQsVUxOHa4kQ807EJnsobbcnqf33o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E6A160125;
	Tue, 21 Apr 2026 10:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1815AC2BCB0;
	Tue, 21 Apr 2026 10:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776769096;
	bh=t8tGhKLq59XKo8MiSyis/w2Xu/nbZ8LJlkNLeDD7oDc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GfPX7xO7qWEA3W1FaagrkCuVWqO23hvMOk/g5VXvc3tyPCglgVtA2SVovEMpppYO1
	 jlNzP7iEpJBeMl0CDcK4ofJcqaATpxK037YKBke/Sv37LACFY+KZYnJjsatfUO/WgI
	 8IdCDbg/RNL5BSkkhpmqwFKf3TU8UuYSXiICT0AwHy0H9xYorZctt0/kruvi0DbFjv
	 3Hn/IpIz1463zxI/Gm2gffBNZa18PvqdMZ1Ey5AtjQeTp9wAI2d9cfIo+OqCTuZJ5A
	 CbOwayf52P5Kc6tGuN5OzyiHF1/9mTITm7P21YNJy7dYgRgn0YjOkFg9+zXYIjUQcH
	 MSGcwB3DC1LSQ==
Message-ID: <b7fc296b-06bc-4d52-b607-2da94c123fa4@kernel.org>
Date: Tue, 21 Apr 2026 12:58:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 11/18] mm: skip zeroing in
 vma_alloc_zeroed_movable_folio for pre-zeroed pages
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>
References: <cover.1776689093.git.mst@redhat.com>
 <39c3c8e647fc4c8e3dcb5c9d12f2e29b5404e8f2.1776689093.git.mst@redhat.com>
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
In-Reply-To: <39c3c8e647fc4c8e3dcb5c9d12f2e29b5404e8f2.1776689093.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tkojpxzg7ugww1pwb7r5yna7zxokgdo3
X-Rspamd-Queue-Id: E15BE1A000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776769097-670370
X-HE-Meta: U2FsdGVkX1+YAh8FQyYg/+MmSjHe5zodTJgsEG3NrbU6xc2rfKEA4F8XV+ztdsAxunviX6KomVEjqb6dMXdrJ6nPRZCjfpOV4MRhTd0UUtZdklXQCeK/5tazFlBZxlu8bCKdTewC0lO0Z/Giu++mWBXec2cisszozGMKYMzi7z0xQp8fdm/48eQQN4divu6hsuAONp9IitIXSGnZVv7PZPINCsNCw5fQkjFINJTbcNzajj5uObbkaiwkMpGrVAM2Fx6hcp4bcZV5+RpXjMzun6cECCn3zl+xphfozx49SGhvhD3n7USQSIXQ2TPXz5yeZBdHLuIu7yWiRPeRDbC5ZYL6bReQ/CWPtEYWt0ybwI4b8PudK2FVMki2rh+Wle31wu4HuwJTUM4xgPLcNBQQQCf7eoq8NBSxZztM1CRXL/zFUQv6kF4LqPiT2QUl9wiR7hxWrTDWBbbC6APe/Xl7lY+XQ4GPCBzOOINEjizWu4D1Gk0dhm1YkmjXPKTMUXEJuWPTtLMPoS5DesOR86f7+Bf6iLJj5mSBu8rvFCcH8i/zKPuUk4ANTI+XbTah/T4psluVB/WnNIG6P0Rw76gbdET+uVPxiLVMgtRxWHh2xlvFtGACeVcoBICqBdy98IK/uqHLvgBrRLyqM+0gghRfBF5OUxQYJZbzT2RzhvKDTlUJGEIXS+57xQLQbnbFuIY7i1kGspOwhxLfvJdyfeR2Z7xtGVx/fpuy63Cz96fEd4UYpHH4IsTRjfGJtd/AIMN+ZgT+ZojAjFsS6LH/VszM0bpQ3LJuTK+SZYFa2eG3ZFasakTaJ4AeRsMfJxtgxeGYatTgojaRBh+y3T0Be9jBnn8gzrQa0W3paMMwELtbIOpKU/5OeSuO9K3e5M4ntLj9C8yFgI6ZRSg4Dz+wP6e0nu2c6Q3QTvINfUPQ5dUEd+YBXxBFFNYXDwqpx8opYvhFgco2As1iYkaGdgyfv0T
 +/CuAUZt
 hMYLj9xIPJpzqSSUm0SoIbZ2ibfp/ustLMjewWhGkGglKcNiC+KAcWlrKQtIJ0g8c/7JwIigGwR1xMomLj7SjEkJKd3CBGjjdJ36QraZrWeUKsrfFFreqOpsn3A3qgZzT1j1nX2d8mmNb+S5XGe4MSt98CVtSCk58N5opeecflFRG+aOs4Q/KzZAOVjN2GbG4kT4yGaHf8ZLMw85bPT24KGy8Ihz5+fM14szwY+xFI/Ka2iceXfrfmGSlO2gNZecAFiq7n3WEcAqjU+4eDYmopim+bJnwDjWYaExYxF5AAoM5Ptnm/AFNCTZvQq84y9VI1EWnsbw0kqkU3BrIhz8Lj3x5Ao7o57Qe4j3ZBdV7Qr4zwL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 14:50, Michael S. Tsirkin wrote:
> Use vma_alloc_folio_hints() and check PGHINT_ZEROED to skip
> clear_user_highpage() when the page is already zeroed.
> 
> On x86, vma_alloc_zeroed_movable_folio is overridden by a macro
> that uses __GFP_ZERO directly, so this change has no effect there.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh
> ---
>  include/linux/highmem.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index af03db851a1d..8bb67772c1cb 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -321,9 +321,11 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>  				   unsigned long vaddr)
>  {
>  	struct folio *folio;
> +	pghint_t hints;
>  
> -	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
> -	if (folio && user_alloc_needs_zeroing())
> +	folio = vma_alloc_folio_hints(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr,
> +				      &hints);
> +	if (folio && user_alloc_needs_zeroing() && !(hints & PGHINT_ZEROED))
>  		clear_user_highpage(&folio->page, vaddr);
>  
>  	return folio;


For others reading along, the variant on your other branch:

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d9..ffa683f64f1d1 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -320,13 +320,8 @@ static inline
 struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	struct folio *folio;
-
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
-	if (folio && user_alloc_needs_zeroing())
-		clear_user_highpage(&folio->page, vaddr);
-
-	return folio;
+	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
+			      0, vma, vaddr);
 }
 #endif

Looks like an extremely clean interface.

-- 
Cheers,

David

