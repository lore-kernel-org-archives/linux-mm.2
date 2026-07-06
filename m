Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A832CC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5216B00C4; Mon,  6 Jul 2026 14:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976296B00C5; Mon,  6 Jul 2026 14:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867E76B00C6; Mon,  6 Jul 2026 14:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3F76B00C4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:30:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D46F68C26F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:30:37 +0000 (UTC)
X-FDA: 84959192514.13.DD9E0CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0D1044000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:30:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OecW2CfX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783362636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6hq90wtcqxknvGtlImTGIn+jAvaQ7Sq6IZx6conix8=;
	b=tToE+ZN0OWNmlGwjBmAwKAn3Qd1MSTQbq+FYwAmSA9Pgfukcfjf03FTTAH3G7HMXREbtJN
	3iCVFPPXxWG3cFujK6B3Uad4M+h064kwP3KpwWo2UajZzgb7dHIVw+6zOKCZjJDlmet+fM
	/kzEDbLafixpV3DoX8/mlEwSifAWp3g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OecW2CfX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783362636;
	b=x/Tgp1fR2HPoHJj4Jn1ynnNA1mv0RdnWXyzhZtx6ZYEyIY5jaJ3uuivEmBjH8WyXvkUqkc
	UnAiYPXN/HXBoA/VUNFGBQuOguFI+onzoIaEIdD+qIwZDrucmVg2l7lKJGDgCW3mNdc/Ki
	RX5myeuMu+JEWhf5Rq+YIjHoX7a2mdU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0491540109;
	Mon,  6 Jul 2026 18:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA671F000E9;
	Mon,  6 Jul 2026 18:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783362634;
	bh=L6hq90wtcqxknvGtlImTGIn+jAvaQ7Sq6IZx6conix8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OecW2CfXJieTrB7VBUxXkqof4xzWAFg2wN21LWTC1OzemsK6eQ6AAdAZmAT6ldB1L
	 a/M2ao/MHuGQSuiEAOBx7T0JW793vr/a7lQ+IjjJ8ms6iXtgJaX2RqWwS6cKoZpME2
	 sqRoUS+PHlDf1In0q7O9x0LNBlCMNmbULpeFW8hH1b4fj9s+2MRB9hgaxVfq16zkdM
	 FVgBAeioYS3z0aoF+ieDJdsFOUx23RCBfe4jVyCGVtyT2qFmY8TKbOZupgfE++PwA2
	 b+yWg2uCec3N+AAfmlfF87CS+ZpJp0GogKnccW3tGpG2P2cSAIuJ2Y+NwGWDZ1YYhK
	 3dwJedZql+jBQ==
Message-ID: <892b2a73-4dbd-4090-89c5-46929530b855@kernel.org>
Date: Mon, 6 Jul 2026 20:30:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: migrate_device: fix pte_pfn/pte_dirty called on
 non-present PTE
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
References: <20260706111958.3649651-1-wangkefeng.wang@huawei.com>
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
In-Reply-To: <20260706111958.3649651-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0D1044000B
X-Stat-Signature: ko815s4r1ddqtae9x69j15wxqqmax553
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783362635-65330
X-HE-Meta: U2FsdGVkX18UG6FT6KpTktSV+J7RB/2fANXCpTNLKbUoX16RO7OipmU35EliTkw2C1i5OpDk6flnQJ4HNO2pQOyN5sGfbPlpkFkl94u7nsjI+IbLcmq66/reg76pAosGhOKZgxG98/U8srLOhXr98XV8OUp+Nt2Ha0QaJCkoLCTcDPuOEYiZpmBA5gSUqLUYlairLx/V6S8F7TW1l8g1xCR0msTr6Epo/Wp58LMCgWjgrT+7Lx4YQL2MnouYi/+sIuhgA++d/oKKUqiSgJZGAQ6C8aPMj2fAaVfL+806pdzkLplNyAwGssXZ3cTw5ywzdm1yiZAF6th/ifU5wJUnLJtsi8Kbety6yaWzmdZoiud6fTr/GT0i5PBfUF1LPrOvYgH7/isZfLJMH2UhNXTJPa8rv7ba/0I/Pvnn4+xJge59iktvJaoJf82bD2jdCs2Oc+QvVYgwBqmeoh1314Jr30efxlXiujRuUxIR1gj3jpO5ZdXZzbKskP4DwwsdSkCzKsQeePNJn1sl7QCPUcdpfNB/a6e3bwp4dv0PMBbPRxIacUQ4FFgzGi5nb9NjDrTtFtQzl+Jrz8qNJ3idr4kU0hmhhl/yDkEQ4KcdkxaQh4X7iZrbhdI780SsSIzhad6lWw1UzUILklhFOPpegkA4zktKxxs4xcWz65xZCfcuZW/+iDPRd12VVwtwRBvRYuU3UiDWKCRV5qPYC+rRdHuunc1AT1/8q7VSjLQdkQVd87eoGewkQ9J/HEeuNp5XRRwz8k89mCTYTdxNVnixTugmkIEs53wi5bwaOo4pmpfCInUgmAXY1UeUKeTeO7Y5v7h0P+suKWZlJuCO5vX7o4AU985nEIKiue4NfLzVjltsrhkWPAUE+qLgFKt0CkCA9hf0Dz+owmY3X+sF/WJrCnAG/sn4bEUYuTqIE4qgRmDXenTO1tt+oVlT49m5MzzepmXZDqqo7hbdpRZr5BZtS6U
 NW77iCfP
 uRkQWePUdz438FY2VqDWYYJO/g/Tc0jF0AOYn3fjHDKC9e2nwz68PKXNF0f0jklC7vF0NeqsDJEF3rnZxCDYEax2Bqoe4K5c31Cro1Va8KsE6jWYYXTqRDEFZnDkQqOktxw7wOhUSkreVx5t4MBgeazZtNxG43yaui7AprttJo8sU7QzygxKiYPooOJ6QegB9TRpfz2UYf8qXw8QcBr5Q8deJeJ5mEqFaRSyBrmE2Py8KKoMVCAewSXhpR3cTkeSW8kuYoZ5vn+dtEko1s/zXkXlrgldRSZRhsgJzBDd9HNmXlOlmlfOatd776vpGX4Bq/tuDvnQqd+G6hVKIFKyXxpZLywrwRiWBfEQMFHfavc0Io2ZfTxaVDHjV37nqpbBzLh5mE0HMaXT/wUGt0O5iCf42hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 13:19, Kefeng Wang wrote:
> pte_pfn() and pte_dirty() have undefined behaviour when called on a
> non-present PTE. In migrate_vma_collect_pmd(), these functions may be
> invoked on non-present entries (e.g., swap PTEs), leading to potential

Certainly not real swap PTEs, as the previous function handling is

	if (!pte_present(pte)) {
		...
		if (!softleaf_is_device_private(entry))
			goto next;

Only device-private entries?


> crashes from pte_pfn() or incorrect dirty folio accounting from
> pte_dirty(). Fix both by guarding with pte_present() checks.
> 
> Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
> Fixes: a3589e1d5fe3 ("mm/migrate_device.c: add missing flush_cache_page()")

I suspected device-private code, but indeed, these seem to be added afterwards.

But a3589e1d5fe3 only moved the flush_cache_page()? So that one seems wrong.

> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/migrate_device.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 052167f9ad54..6e711381f092 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -411,7 +411,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			bool anon_exclusive;
>  			pte_t swp_pte;
>  
> -			flush_cache_page(vma, addr, pte_pfn(pte));
> +			if (pte_present(pte))
> +				flush_cache_page(vma, addr, pte_pfn(pte));
>  			anon_exclusive = folio_test_anon(folio) &&
>  					  PageAnonExclusive(page);
>  			if (anon_exclusive) {
> @@ -432,7 +433,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			migrate->cpages++;
>  
>  			/* Set the dirty flag on the folio now the pte is gone. */
> -			if (pte_dirty(pte))
> +			if (pte_present(pte) && pte_dirty(pte))
>  				folio_mark_dirty(folio);
>  
>  			/* Setup special migration page table entry */

Changes look good.

-- 
Cheers,

David

