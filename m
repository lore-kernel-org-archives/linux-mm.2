Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7AD4C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95EA66B0093; Fri, 10 Jul 2026 08:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9367C6B0095; Fri, 10 Jul 2026 08:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C306B0096; Fri, 10 Jul 2026 08:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6AF6B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:17:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB4C61A0420
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:17:49 +0000 (UTC)
X-FDA: 84972768258.27.02A4743
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2C8FC40006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:17:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O7BFBD1s;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783685868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/74MYJMm/MRBKxJMVuPx+ufZtVV5GSCzWi8mlBN+PAQ=;
	b=rhEKse2w8nLUSqe5wQd+Uo0wBg4mKROlZWw8Q/PADsYI8uAnJ7GMFdMAgkXCdfC0giNMOg
	PHfJkZlsZfNGPb7EYJDwTSR6AWKKvlLmamvIeFAiBd4HE0w7HVC6FXt8s0EamtjAj0E29U
	0+f6OVyaYUcaTpXU3+992oRgTAbmWOA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O7BFBD1s;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783685868;
	b=CAOhB1TG4If5YdyxCwwr+6AlzYBOtQfZq76nbex8jnOyJX8/SZkwzFFrw8N0aasTLlRjm6
	TWMWYlZml9mna3JtK+adXbMEZGC0Ru/SgeVsgm/XHFlYNcW9+JwEQDyIe7i3A4TXQC8doc
	Tdu1PX+BNB0mOuLCL1Fkv4t9RTEUXRM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FA6D60EEF;
	Fri, 10 Jul 2026 12:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3748B1F00A3A;
	Fri, 10 Jul 2026 12:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783685867;
	bh=/74MYJMm/MRBKxJMVuPx+ufZtVV5GSCzWi8mlBN+PAQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O7BFBD1srVaoSWuyf7FiyZWvcB13a9uCZBUEhy9/0s1dOgBqolhjMDOEGdlKtdYKR
	 CIhB0eZVR2HGJ8GViurFgigNBxdf7YYbnqvahO+H48DWeI/lCClUmWg01G5f6FWSKT
	 96ddhzwha3JcYMJA2CRveiDLlOWIY2vRdPCvnD9+Djs2ZT5A5/B+VNGb6aGTB2UIKr
	 Kk93rW8kzC/FP4DrZ/hIz9sn+QivG7ycNinx6mxB73k5PuwatbYHQL9L2Nv6IuLTwV
	 EElzwbaUHCoJZKIydsqffNNsxypHk9oXXgIUBouOR6aFw+JuP1IRed+GVgtY/H545a
	 nmCs629ULEmBw==
Message-ID: <8992ac30-340d-42c7-8799-2d797b92b59c@kernel.org>
Date: Fri, 10 Jul 2026 14:17:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] mm: mincore: improve mincore_hugetlb()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Liam R . Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
 <20260710120052.103886-5-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260710120052.103886-5-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C8FC40006
X-Stat-Signature: ud3hryi6ynynec4rp14jh4xwbtn4jbrw
X-HE-Tag: 1783685868-954691
X-HE-Meta: U2FsdGVkX195Hm2fJZY/YABrfRuF5Tri+OTpGKXls9iSmysEI/cxPHIEPbRs5cwdzjuSqn+YP+Sf8viUH8qPvEXRhYiW1gnwpIB7x/xMbmFha+D2q0AImUuKjamBmc8MTlRyeh6PyE+jGVsP+zbIVFDqTjKkJOY34trA5YxwI3NJhfNz3ntr7/DVVugPdI5KCBzY7Cx7mgkjpj3ylzpU5fx1wxIcMQY4D4SBGRNxzX1wa2nF4vDAHapk+OiYRkWr+JOzNtBAAutnAcK5arQkWGZ5oV7OZu1Az3QYymmRMsqnjxS1RSK9EFW+2ylQ97Ap+KL9cd4+NDIV9PCAHqkNqvjk+r9jlGby3OfXx1R54TCtEB6x3WlkIU+euzbKOiCdU9VnWUPxu0ed8luIaLnip4XsETXRvk4RNu3BKHXV7BESRucrnoFcYsYFO3qBYKkIi7KQQB4vnF0DQ8gikqADbnpemX2PVDsS4IcQiuUHMNK6uPEX6/cgAlocn4UCXR5Oex0Gwx5f4+nppLPBddcT0kQvnXeZi+xBroQjx+9YZnrJJwReP0+0ed8YeRN5/MylEk3o/31hLigseBo4ycYXC5nePne6xTAm+r+ER/KCusUap9Ry2rJN84gsktmTBAYRW6iH6/uCeqcjYWHS3PeZiaXe/3lX6AiYqQfZFF6ZeC0Tz5JrmnjsbHo/noSWZCHE1bYw3a3JiKfGnxagnQ/LBJyonza0B4BwNJueQ8iJB3zhefTpj+BvZ7lgvN0WrI7lyKGyg3gz8DJjXTKeu282Xd0ktzMT4TOHAdLJ5ixGMxB9HhVv2Nw4EdF3Y0iFzjPCk+D3/2UVCC6R9TLuX9xUeF0m/aEOnrGiZLV/64UijEFBNhZ3coG/eSXj/X9eMwRIOa4lc1Y4XqimBhodTvuiydHUHyMlzd/jkExypDg7LdxqiCF9E9xgVHxufdsWx2r2q/5PFgq/0q/jhIYa8CA
 lWll2FnI
 MWcn2j8zuifWNLjJwDq5KaW+otaOyRehYoSP0IcBdkGorLu6JKQad/aD8U3RjnELFhUEBAyhcW7JIB2Fhc72lzB2FhXKq2GY1A9uOzH8taNMW6n8ZSppAZrIwRNQBGGHCgVtmSthvJrdD3DH51ZtdcyTpb8dgK8N99MHYEFHI4FIJbTcb6VJbTymGd4taozOGRQ8zuddQq9nI4ZT5ZtmcRYYS2ZkG/NoZgLXO2bHdFQyfaShr52/iFSba31tWZSD0bKX5/HtR6Xz2X+eQzYrSlgpAJkZdIJt7VaZyz/IYQeBEG/s9TBngMoguy63R60OuMx3lK2Ob7ACmJWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 14:00, Kefeng Wang wrote:
> The walk_hugetlb_range() always passes a non-NULL pte, so remove the
> dead NULL check. Replace the per-page iteration loop with memset()
> for better performance.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mincore.c | 27 +++++++--------------------
>  1 file changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 8b5e6afefb91..9952bc3edf76 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -28,30 +28,17 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
>  			unsigned long end, struct mm_walk *walk)
>  {
>  #ifdef CONFIG_HUGETLB_PAGE
> -	unsigned char present;
> +	unsigned long nr = (end - addr) >> PAGE_SHIFT;
>  	unsigned char *vec = walk->private;
> +	unsigned char present;
>  	spinlock_t *ptl;
> +	pte_t ptep;
>  
>  	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
> -
> -	/*
> -	 * Hugepages under user process are always in RAM and never
> -	 * swapped out, but theoretically it needs to be checked.
> -	 */
> -	if (!pte) {
> -		present = 0;
> -	} else {
> -		const pte_t ptep = huge_ptep_get(walk->mm, addr, pte);
> -
> -		if (huge_pte_none(ptep) || pte_is_marker(ptep))
> -			present = 0;
> -		else
> -			present = 1;
> -	}
> -
> -	for (; addr != end; vec++, addr += PAGE_SIZE)
> -		*vec = present;
> -	walk->private = vec;
> +	ptep = huge_ptep_get(walk->mm, addr, pte);
> +	present = !(huge_pte_none(ptep) || pte_is_marker(ptep));

Easier to read as

	present = !huge_pte_none(ptep) && !pte_is_marker(ptep);

But now I wonder "why not pte_present()".

Calling this "present" is misleading. It's maybe "resident"?

I guess we want to indicate migration entries and hwpoison entries as "1".

-- 
Cheers,

David

