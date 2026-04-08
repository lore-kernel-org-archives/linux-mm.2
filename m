Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C9511073C8F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 10:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF56F6B0088; Wed,  8 Apr 2026 06:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F1C6B0089; Wed,  8 Apr 2026 06:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946BE6B008A; Wed,  8 Apr 2026 06:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD0E6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:34:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AB95140A84
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:34:34 +0000 (UTC)
X-FDA: 84635029668.30.7B994F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3D3C44000B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:34:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XEzgMdUl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775644472; a=rsa-sha256;
	cv=none;
	b=xkQ2xeFU09uYJoFiXItZU0HlrDqCkrLrcpQXnb3cx4d7B1OtiZEnwpi8PTFcTOzFunQklk
	gNuKKly2xtmwiMhDvAfdIlAC3jJ4TpIXcDRz3o1N7b3vdyEHI453CGnm+wgSyCbdJNEU2A
	vhpX5STzFibNYXnzCejN0ZApZj14ldY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XEzgMdUl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775644472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dzQnhV7GtbsFY+r1Ti8PmOtkogWGf8CZU3+G6Y9p8W0=;
	b=k+x5DT9k1sjbCaeUmQquQ7H3KlunVbgcIaRVd95jnYK0kyKcFz6D+ojXlKStJoClA9v+Pp
	NRewU6pAggJVeuAtp8vKHzm30lvRolo56WiZ/5mTgCdw7+RL8HwHg9JmACOhCqfEOiu+qe
	PFtqFyC9F11H75jEcietaC/3Xh4XLTQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19B1D437FF;
	Wed,  8 Apr 2026 10:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57428C19421;
	Wed,  8 Apr 2026 10:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775644471;
	bh=ai9QfuV35IL9Xu+x6DAYuUhTQo8Du03Ovi0qKxAZBeA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XEzgMdUl1Rq+kjbRjjvhg+0Gutorz09KkitcRW5V+MZD9hiw/XiVSzyUUIA76jknm
	 HZATVuw2zDfsKpj7IkGqF3RfTG+P+3Ug97N6v48KjWUPRz34bpek9yvIwzx96CH1uF
	 FLQql47DhU5d89KoZ60LBu8r6WPukPsBwl4Stj/qS5ZNNsK3l0lNBYZ+OyeFw3rMBp
	 wspo93AVf6Otvo0uYAPZsAFNF/A8bxM0Kn/YBMHfK+7GDpiw6wYNYJfRJiHSuuIHzg
	 WVfVRLtQs2jAMtaGDW33/SmBHBvnhHZn5GZng6cgOZnBq44v0pwKrbmdPiQLSWcwGB
	 gbmq1QEFd6acw==
Message-ID: <f92c31e8-0a1e-43e5-8d41-18a1b17f4e27@kernel.org>
Date: Wed, 8 Apr 2026 12:34:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: use round_{up,down}() for PMD alignment in
 madvise_collapse()
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260408093534.2373007-1-ye.liu@linux.dev>
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
In-Reply-To: <20260408093534.2373007-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: auafwpf8jat938k79ux1s6eigusck7ys
X-Rspamd-Queue-Id: 3D3C44000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775644472-88681
X-HE-Meta: U2FsdGVkX1/GXgGWUa96WV2v5K5MNR0EOcy7f+ml1mdquMMuFfct5Jpc4gWzlbkV8ytxkJWmD8uxGUf3Q4wd2ICkAqyztzGCAyHx5kuaBKca6M2oZQnWYXp8OneI0Nk4T4mCve9z6JffMOtv+KeQ+NdQ5O8wUtmtCj1ismIVWfRxVfXUzjJFzKgoaOWVO9KaZ80WcUrxZ2Ao9nJC0Ju3NE5ywSbEPtV+JUjveHRUo17EuLQrEJsZ7xHPsCUSfuug6gbX3In2JySLD6mH0JA7hXkNEUAg14VKJvrY1DRKCSKb9NGkNaBK9TU1gU+QPNAcjAOWSlR4gbAzAcViJjMdQ2D3YYP1x6sMfcsdo1fNfYrdxbsjtMh7YGqTY7G/H2Yu6a7rzCwcr2+d8Koy3Qb/GAJLL5Yu7Do54pYxPYkxXboBpTbFIl2tpLX5tLNz30dJQEA9QrMhEnm9dzhX3M/BatkxRLEtu0US0pX1YcJVsKYsLLjfaX+30/T2wRmM6+N1vi9GKTp97u9rFSEool6iZYtzE5UB1ZS8W3q7B4cpEQa1dlE+J0fU3iYmd15BDwaOLrDKEW0LU0Da7p73TXe5SGVFXtpaSmOghYutFtGQGtkSfbLVzN8PgHhknM03dD4wQJwI+M90zdAnE2axqRs9rto5KJA/a4BGJ7f5faJd8sp+LN3r/OPyOJzrV7vo+aPaH8yPdRlZcdrw4I5+UwzTlcbNk0eZzeeqxAqcHwz1NJsQ5gHuJc+jAVgHZ6VdPBEsufOvSFhiTxH7AT0UhO/I9GjLgaG2DZFXOhQGIfsGdougls0bCvNiMTofhLPKJTv7R0vGgrs+84FfoeYQ7atst63fkbubr4TFH7UPqrXNy9813Digw1T5h6SzP9DNAQLuaYlc7l8/knNnxQ9Cy6nkDjEydZU487yYV8CDqgb8fgiQw7UjbB66z4+4/klk5bpkTtIFjrCh7F+FFhKSRei
 UNRloXL1
 HHf7t5mAw8M6XnIH1I91fcMnW3+DtLwE/j4Wv/zMD7WIBScW0bfA2E5zYmxpI6+clVLHI4l/31lxPABMOu5P3QkF/6WOgJDzqio4+rmVSWgimAW5lhmk1FgwdNBG1PVinv7H52StV9rNIp/m7ZbOvMmMLXUzKO1v2GdZl0l0+LHNAjvMBA1GXd2BMD7F49aAQU+W1GFPSZpfV04bD88385Ch5SYcc8WgHHPMWbcXgJ8YFeU4Bfx/AYflk02D6bwRnDzIfX6jkj6ATg0+TKdFT9WgxRiWX4hSEQ3GeTppwFKTc+0xUy+XZ2Dsw5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 11:35, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The PMD alignment in madvise_collapse() is currently implemented
> using open-coded bitmask operations:
> 
>     (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK
>     end & HPAGE_PMD_MASK
> 
> Replace them with round_up() and round_down(), which express the
> same alignment semantics more directly and match other PMD-alignment
> code paths in khugepaged.
> 
> No functional change intended.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/khugepaged.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1e2bff40d014..80d0b7136b58 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2835,8 +2835,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	mmgrab(mm);
>  	lru_add_drain_all();
>  
> -	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
> -	hend = end & HPAGE_PMD_MASK;
> +	hstart = round_up(start, HPAGE_PMD_SIZE);
> +	hend = round_down(end, HPAGE_PMD_SIZE);
>  
>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>  		enum scan_result result = SCAN_FAIL;

I tend to prefer ALIGN / ALIGN_DOWN when dealing with sizes + addresses.

-- 
Cheers,

David

