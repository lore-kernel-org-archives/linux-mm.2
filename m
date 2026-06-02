Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81799CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 19:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9659E6B0088; Tue,  2 Jun 2026 15:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916796B008A; Tue,  2 Jun 2026 15:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AAE6B008C; Tue,  2 Jun 2026 15:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC816B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:05:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0869C8D7DF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:05:27 +0000 (UTC)
X-FDA: 84835901094.02.AA8981C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3AEF61C000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:05:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0mNp4fi;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780427125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4ZyRdhtCO1dv7T3Lj/KxS0Pm19iL4/0dY7jaN49Kns=;
	b=V3zTLQNJUsTf4xIjQTJ4UxQPdJwrs/F0NF418HnFMZrjEx+mzM/5jyUczp47T6H1HqKDws
	t7t6ne1u8r4+blqITkzTKu/BCE5UwaL0SLkRH4gZZsxjFQvUWlUbSojNucwQ0GcGdise5t
	JzG9YaQPIUTZVDOW1CrzeP5ESxLSwYY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0mNp4fi;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780427125;
	b=4hvkK0t39o3f9vn+UASZfmVaMCsIB02E7J13jM1M30oqItPmm+6d/CDZrj539QiG0sH4D3
	cx4S6tBve7bRLdC+pP6OHsqyqVtg9IVclBsPvMmy2/FJtgp26fKiISZ4DLXpiWuAmMWsf9
	J/erRihHSubs2dJlmNL4EJbl6xiQjRY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3957A437AA;
	Tue,  2 Jun 2026 19:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07161F00893;
	Tue,  2 Jun 2026 19:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780427124;
	bh=f4ZyRdhtCO1dv7T3Lj/KxS0Pm19iL4/0dY7jaN49Kns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I0mNp4fipHMFLsjeiHarIAc/AwZDY9TKHt5YzeQ0/nt867h0ePIjiGzboazBeD7E/
	 qf3KhcpySwgWtRMQNm5/JpW03pqS6I+yw+4ZiNSlB2tv1R4Ah6SIhNWfWudHg5Fpwo
	 mLJpvrfaDRa+5Obu3VMjc2xdccC3NcKIRkV2x4Yz3S3ZzOakmyhrqVeobC2Cx1C6l+
	 6e1zs74Jdov87CNBJlD5NVUBetgD9peYD7SvmH7NEZC7FjaDhNxjCRE76Ru85t7FZd
	 FTcNqVIh2orMCl4iF75xI6ioixzwDNuOfKsDa6RIhPOA56Cf7MeW0O2gxEBuHWjbCq
	 +hwjmm5JiVU+A==
Message-ID: <7d199cfd-cf45-4545-b9fd-19b9dbee4b6e@kernel.org>
Date: Tue, 2 Jun 2026 21:05:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: page_isolation: avoid unsafe folio reads while
 scanning compound pages
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: Liu Shixin <liushixin2@huawei.com>, Oscar Salvador <osalvador@suse.de>,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260602130755.38794-1-kaitao.cheng@linux.dev>
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
In-Reply-To: <20260602130755.38794-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3AEF61C000A
X-Stat-Signature: t1zpaze9feozymuehma8ftgxrjeuefek
X-Rspam-User: 
X-HE-Tag: 1780427125-63687
X-HE-Meta: U2FsdGVkX19dZPptD1p0UJahypWsI4yqdQ/WDHj2g6vLYYveSZOZFHyBS9CpIEH/+pW1TW+ljX0/AgVN66KNOszzKpeQjy0rqsW622CVhRFOIxh6pAsoaWz/mP+behG6rM73qKXfeX1WyoTtreb2cr448F9QrCspQPoIs/Wqf+iQYXIhrv/myvw/3e+nQjllLk4t77Bvc8A+6oWixWnpqDw1OhJFmti5ZwAt4MopRP9QLMc/2n1kz7Qdau3gh3TYDSRMki5I1hPB8uGuPIyzeog4picrYVRqsefnZQaMFz8/HaGL75/ARCcLfpEH5jd8Uf54Ivkrobr07kNOZ6PyDAXanqT08/sl1Mac1lqVq1lcNqypfIk76rG7J2PtIxyLfHSjWUhWtIOdG+6NB3KdezW1zGJUpABx8fVulGm24aOaQm5M2L5JMoiLZW43ceiUhi5tztvhE6Lwf0yOSc4cENxGarxOINhoMWi4ZMF0jrOZmQk6TW1ZOAEoaM9dU0+bMnBnrZX7Jc2mr/Fqu8x/VdEgUwjuspESv03mtKdaw268UMjO1yg/ULCbfENEJlTaB7N7XEnp1wt5TpD9f+KFeL3L8J2+McxqDqV9lT73/hwE7412cfvHKN9pI8aFYW6N2KBYrA2vyIOAhTjx/7KTowKqFF5a4SDGLUQOFRn0NY7/57SZ0RMDoUlyZ0nV/QlrtKbspbzKUCVo7adKnlT8ETJ3OHc4kiaOrcg1JYhfjxVoKmRkLBMWi6PGJ7EqZY0dTjaSReIx7EASFKeeihlcRoAAhjhQb0lAj6LQLxxRk2m7bqJreSlf22pwH5HAZSXqcvUtjzZgRKbcOpQWBsHW8XeGsP46m4nksmA5xQOEveGucU1pDmwpza9DI8L7Q3dVSm9zNj946tDzfnO9dsxlBk0uxTRJ9d4P5/WYwDR1pstsNlMPtDTfD2KF672F3IykATKx2s3klC7+6SO8AWH
 yXhRvwt0
 9/EZvHX+3/VidpgJUwbz+u164CoIDKXUow4SzlOeVDohCj8k22FeEEG7MB38jJgrk6RElC3GrMwf8giMK2+F2Y8UsQm+ObgDNECnOwIeeKezoyF+cwlolyg3ZQp8EI5nfNX/OPaHY/gvowooXIARPZe/fpQD+c3kvb2k/MlVmsBpv6/KJP+2qKxD7Ysj8zE16sgpgIUsjIPtlhG3+DTr0tVEnH/4rSLZPqn9u+zbsgINeGU2QHotEh39IR32FApLY3qGpjRPUDaBLN9x6C97qDwO37vTyB1MEKczyLpnOx3fYyj33YxjlbS9dFUDmC2XhgIhSO/JLdKrhcr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 15:07, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> page_is_unmovable() can inspect compound pages without holding a folio
> reference or any lock. The folio can therefore be freed, split or reused
> while the scanner is still looking at it.
> 
> The existing HugeTLB handling already avoids folio_hstate() for this
> reason, but it still derives the hstate from folio_size() and later
> derives the scan step from folio_nr_pages() and folio_page_idx().
> These helpers rely on the folio still being a valid folio head. If
> the folio changed concurrently, the scanner can read inconsistent folio
> metadata and compute a wrong step. In the worst case, folio_nr_pages()
> can return 1 for what used to be a tail page and the subtraction from
> folio_page_idx() can underflow.
> 
> There is a similar issue for non-Hugetlb compound pages: folio_test_lru()
> expects a valid folio. If the previously observed head page has been
> reused as a tail page of another compound page, the folio flag checks
> can trigger VM_BUG_ON_PGFLAGS().
> 
> Read the compound order once with compound_order(), reject obviously
> bogus orders, and derive the hstate and scan step from that order
> instead of querying folio size information again. Also use PageLRU(page),
> which is safe for the page being scanned, instead of folio_test_lru()
> on a potentially stale folio pointer.
> 
> Treat an unknown HugeTLB hstate as unmovable so the scanner does not try
> to skip over an unstable HugeTLB folio.
> 
> Fixes: a0a9f2180b90 ("mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
> Changes in v2:
> - Avoid unsafe folio metadata reads in the unlocked scanner by deriving
>   the hstate and scan step from compound_order(). (David Hildenbrand,
>   Andrew Morton)
> - Treat invalid compound orders or unknown HugeTLB hstates as unmovable.
> - Use PageLRU(page) instead of folio_test_lru(folio) to avoid folio flag
>   checks on a stale folio pointer. ()
> - Update the commit log (David Hildenbrand)
> 
> Link to v1:
> https://lore.kernel.org/all/20260519121646.40833-1-kaitao.cheng@linux.dev/
> 
> ---
>  mm/page_isolation.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index 7a9d631945a3..32ce8a7d9df3 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -41,8 +41,14 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>  	 * We need not scan over tail pages because we don't
>  	 * handle each tail page individually in migration.
>  	 */
> -	if (PageHuge(page) || PageCompound(page)) {
> +	if (PageCompound(page)) {

Nit: you're not spelling that change out in the patch description, but it's alright.

>  		struct folio *folio = page_folio(page);
> +		unsigned long nr_pages, pfn;
> +		unsigned int order;
> +
> +		order = compound_order(&folio->page);
> +		if (order > MAX_FOLIO_ORDER)
> +			return true;
>  
>  		if (folio_test_hugetlb(folio)) {
>  			struct hstate *h;
> @@ -54,15 +60,16 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>  			 * The huge page may be freed so can not
>  			 * use folio_hstate() directly.
>  			 */
> -			h = size_to_hstate(folio_size(folio));
> -			if (h && !hugepage_migration_supported(h))
> +			h = size_to_hstate(PAGE_SIZE << order);
> +			if (!h || !hugepage_migration_supported(h))

This change might have been better in a separate patch, but it should also be
alright (and never really trigger, ever ...).

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

