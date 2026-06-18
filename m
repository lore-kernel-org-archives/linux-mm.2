Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12C45CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5176B0092; Thu, 18 Jun 2026 08:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8DCE6B0096; Thu, 18 Jun 2026 08:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7BC16B0098; Thu, 18 Jun 2026 08:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 988726B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:11:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 285498FBFE
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:34:15 +0000 (UTC)
X-FDA: 84892824870.01.1E5BB54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3162C160017
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:34:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7ZeQ7Zx;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781782453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJP5stBXmI47T4n4rhdVRcMm5LTdBA01OaSiZ1A+ccc=;
	b=pGlI7u9c8dJ762HX/TwqWXNIILyMWHOzbsA42BdM4VLB8JzOe3CzOPNsAZqP/+tzrgmjbl
	YGt8kszMJLbBVGVJ47ec3Qzxl8MFM3sNDXx3Ou4aN7TxU9Zo262A5ZlsRoo3Zb6Ju8yPDd
	QTOJkPvF8EZwoVkJFzHqhDwRz+dJ35E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781782453;
	b=JGcS+P+Ey05pQZg0sjP7aTEEQIqtwcGuMXsrjWMbEvPJN5sKTiyvUuu7+O0wy1o5WxCOut
	ANv9PX5N1ZiuAdGu4RbTY3can9Vk+PXMot6JD+gZlD498zFgR7IQh5x7CQ8me9pFZSEqh9
	WgAfUBPmvYKDiPwMqep0mDAVsxWuFm8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7ZeQ7Zx;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2392743513;
	Thu, 18 Jun 2026 11:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041641F000E9;
	Thu, 18 Jun 2026 11:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781782452;
	bh=AJP5stBXmI47T4n4rhdVRcMm5LTdBA01OaSiZ1A+ccc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E7ZeQ7ZxOSMM+2iKLXZcuvlbM5m67VF6yZvoRUl+8E+fPkYvgIeHj4PneYrV94nqM
	 ofW6C/PcX9XYj3GQkepcADUw9Fd0Xinbt/ln7qyLN4biTir6ONEolMsUey0PNSJLVr
	 +7ANAovP5PkzSVZYIom0cdsAROKfUlaaZBzKqPfeGTKOdM0xC91h4XdPEbO+e5rO/1
	 fvaupQPaJsuw2mLK/bqLkZzdCsA7adg+9aG/XjxbwwDuOCZUs9B16/XhBe5Jpubo2b
	 OyRXO7MC7wecrEauTbOLjhelvMJcz36lzrgPRm3Lcbt3vIAVLryeK8v/v4wdIt/Br/
	 Xdyt8Oa3GpekQ==
Message-ID: <0e619d71-1c3d-4534-8376-2982c7348c31@kernel.org>
Date: Thu, 18 Jun 2026 13:34:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: mincore: use walk_page_range_vma() in
 do_mincore()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
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
In-Reply-To: <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3162C160017
X-Rspam-User: 
X-Stat-Signature: gqfpnzxhjb3odgs8cfrroeduni765jdc
X-Rspamd-Server: rspam08
X-HE-Tag: 1781782453-83805
X-HE-Meta: U2FsdGVkX1/SG4OuYf0ogOV2hnyTCSY54y6IYoOaGTJ/48ZMW/Eh7jVc7Q0dOLp5p7dNuL3PpRcAVttkOL5JZp9o+ko4TI0iUoOUOB2kW8oeFmAytBb92jR4pBi5prlzL382hVxJ8qZMWT+meZSs1511fRfhtYWJJ96xGmcNhjm0GlHodQ0J8pm9kj6C7F4s89OPbVYoIsaG3Ieo0FFCoMpKCCUXVD6XtJ/ZDo8M9/u/oxhb4OokNTKU/hl3luFGZUL0HztOA2k1mapWre0rVBBlmUtK81pvL22sKFVzzKkJVF8ApU8AP6iSNm/bqMv1PtVk7Ni9YtbbzFqFdY0nKKX5rZlsop/56QhrVLUjZ7H6V6afnHKIvf+CDq0TKKl821Z5KTkEJZVv/Z/wUKewCrafosYkrlo7+yrL+NDdjqyL+DsgPamg3UJl3P0X2DmJKxnUl2u8OzycL8Pp7ULlSEjA4jqm5NdkDvMY1aHLNZhbb88cJfSgIT0jsjGZLFbJ/OoVs2vq5AoGkpWomnZ2viSYkkIdbBxIZCM8RvwN3SA9GeV6ATdIr05Ge01wapvMHho0jFxFrGHLGNQ/G9bqGcjqoNhmBcpJXiZz2IISdCIMiYeUCeM66jtxN6o6JWrFkFEenkm+t1/8Lci3FELsYiUT7PtkTRIP9vXoaUtUaYLtnaNptp3NAKzMTxBxN4RtXNj0NpYDHl6LMgX1gr6MbT3Ve8ufA3IOMezp4TDYrBxrY/AGjaxNwHmxlRzjhx3H0T5YAXLFBMLBqafaRuzwrHdtNIiC95J+kDHEo8XAq3YTwCrQtonM9hn3dnOOIccoslQ+yCAlMw2dUfkHkPJjKHHHTacXFVMnH8lHrCjgfWJviCyPbh//g4Yf9P9wr3H3vR47p43maogV/1Btl+6uvY6jlwgiLJAwHB0SHe8cO9faX9EY0Y+La8HO5p/fNTZvEykAABGyyfSdxwc43jg
 I3k2EOHu
 4bdgYhJh7HtUeqnI5hpRKrYCupkkXtGLdGIq1GgN4+QGM7VVhtgSMzjlpCTkKXOTiL9sTasAx88EP0SHs4xpOfFTo66txDAX7wf3y7G2Ag8zE5b8GN77cZlGJgbCs+VcZ2r55aaF355yDlPzBBI4utagUX/m1X0K+lnqhfdykESuUKChNDE5GPlmIok7RLW7fdb671+XOdSdYbELzPzpbTOaQe19CspUv3zep5ucZ9Ht7Gp6QnHiYA1MmowiCH09cefd5h6RJnOthet2ZFIoP2RaY8vpjUJOtyfaS1SmaECuzRIbBeTLcKh+qBHUsj7SU84IdBTDi1HQysjyI9g3MAh8BQCa0k1KJbIiSO75iV6XyQoohq650V7vOvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 11:28, Kefeng Wang wrote:
> The do_mincore() uses walk_page_range() to walk the page table.
> Fortunately, the caller always passes start/end that falls within
> a single VMA, so it's safe to use the walk_page_range_vma() in
> do_mincore() to eliminate an unnecessary find_vma() lookup.
> 
> Unlike walk_page_range(), walk_page_range_vma() does not call
> walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
> to skip the page table walk. Without this check, PFNMAP PTEs
> would be treated as present by mincore_pte_range(), changing
> the returned residency status. Handle VM_PFNMAP explicitly in
> do_mincore() to preserve the original behavior.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mincore.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 296f2e3922b5..0c6731ae6c4d 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -259,7 +259,21 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
>  		memset(vec, 1, pages);
>  		return pages;
>  	}
> -	err = walk_page_range(vma->vm_mm, addr, end, &mincore_walk_ops, vec);
> +
> +	/*
> +	 * walk_page_range_vma() does not call walk_page_test(), which
> +	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
> +	 * page table walk. Without this check, PFNMAP PTEs would be
> +	 * treated as present by mincore_pte_range(), changing the returned
> +	 * residency status from the historical "not resident" to "resident".
> +	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
> +	 */
> +	if (vma->vm_flags & VM_PFNMAP) {
> +		__mincore_unmapped_range(addr, end, vma, vec);
> +		return (end - addr) >> PAGE_SHIFT;
> +	}

This is fine to leave behavior unchanged for now.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

We could consider removing the special handling in a separate
patch, though. Would just do the right thing IMHO, and it's hard to believe that
someone depends on pages in VM_PFNMAP to *not* be present.

(could even contain anonymous memory!)

So I would suggest to ahve a follow-up patch where we remove that special
handling and see if anyone screams (nobody will).

-- 
Cheers,

David

