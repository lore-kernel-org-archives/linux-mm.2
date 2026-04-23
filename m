Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA3EF589AE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDE06B0096; Thu, 23 Apr 2026 08:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9489E6B009F; Thu, 23 Apr 2026 08:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F606B00A1; Thu, 23 Apr 2026 08:36:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D35E6B0096
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:36:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 127DE1B5594
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:36:13 +0000 (UTC)
X-FDA: 84689768226.27.655244D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3AC36C000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:36:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R5wK9Id+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWbOOG94bSm6PfjwNYtn0fv+fPHn/FMDOPzsnE0MpbA=;
	b=I1O6lumwL8nv9/Bvc5tLjU9ueRNju3I63XqlW47Tay1MZWP3zrVGHerd5XpVHZSvSiFRG2
	lPG6OEij184f+GEJRRzqhLXZdHxZlrmJUg9uxwX8zP9Jv15QcKGNJbuRYQ0BjLqYy3fMtq
	JyWG0g88HOD444HfgSZc56m5Ju5LFtg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R5wK9Id+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947771; a=rsa-sha256;
	cv=none;
	b=zsW3lrfiSKtJfTNbFMpkHPiSOyu+ZMhGamnz5MoSZc4TZajECjpM3M9jFfpMFa5lozZkvA
	MNC9xa6oKP6mHJtJSpcUM+svuv/02QuqsKGww7xEh+7jOwxw+BJZ2Jg0Mgbk6pnVmUNNtv
	ADRGGNe1gJoKPEwAzauWHJprywO2IV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43D9843DB1;
	Thu, 23 Apr 2026 12:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC69C2BCAF;
	Thu, 23 Apr 2026 12:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776947770;
	bh=OMxJH055Lz+LqfFlBtaPx5FufFhxqSqQSeuDAzc+ZE4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R5wK9Id+5Inzuq9D1x+fywpT22r/yATwvy8TxjdmrEeNqwpOmgRnqLpcHwy2eGmQQ
	 qS/7rEHqyo0C97AmFyB1grfTLM53WeAJD9/G2Qx05diwIYJFT3a23r8IeZ39fBNO7p
	 NvvSOAv2kyyA3wS8UawHmcbDRamVSRLs+Dy72a7eY9G0BrpK6g2WqRdcpyt7mSn3LK
	 wPgvWDiOVJ2gku89TX798Qo8ef+XrlCNF7uFS3FIxx4OdVFtRQA9vh42WtT4HYlQv2
	 J31qKd0iwgVU5OUdLFwVohh7c2JZ9pranHCQpUxiu2meeVTFuNfIF3ulovEFzxSJmS
	 5aCuQPPEiUvkw==
Message-ID: <ec08f25f-1049-4fbd-8a87-0df135a867be@kernel.org>
Date: Thu, 23 Apr 2026 14:36:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: Fix outdated comment about freeing
 subpages in __folio_split
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Youngjun Park <youngjun.park@lge.com>
References: <20260423034917.8234-1-baohua@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260423034917.8234-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3AC36C000C
X-Stat-Signature: y1znxkaagtfd7puizmwoxfos8ffcfa1q
X-Rspam-User: 
X-HE-Tag: 1776947770-710865
X-HE-Meta: U2FsdGVkX19G94FFtB4Rx4XJPNw7pCFFGGeH/nKKEQYrSP7dNW6KaAyOYwCBkjmBg3gVRvGDEsbFOO8diYcnkOKmgfNN92WJ4an2DQOQYzoOBRTKrGoA8JliYtIXhri4mo5NtJyGOdtx5iRhN66K2mVWB3eYhvsDvOBULj79QBSpc7OB3HjyCuVy65gDOt1CT+5tMA7AM69p+cQBaSp+57KAJBlWQT7LxaTThCGcdLdyv6D8nELemuBiAzOy7TbzMA/NePTdtLPei7HOcgxd7G6YkeDmA4L5ycdBHBGBw1DwbWwdq0k/PJWH6gLS1QJ2CgHKZ5Nf+xyT+xqzbjOdDMl17Q3XOL/83sqR+w+t83OJ0wxtmkO61Mavy2HE0M5grvfQi5Teh2fouwzFKQlks4G5dOJHPv3RXoiF9OoOestlBBF9moqyg24XPXiQUeU5AcY6xUbmsUkcQt2mWNIg10O5XomBG0T37SZT4M/M4541gHmH6ntzqw1y2qJqag60cR1txeb9qfqkOHwaiolAESJzixCD/q/rLTXy4ehprMOK8xApablol+Ab70i0d1gB1phMifC3lU+/nKSICKJIJA2+z3a+Pi+bY6Q4AURJ7BkBQVHvEr0XV0MLLRudSH4p5atGbArh3bIlRskYa+yib7+ZlwMlvYpu+KCutyXT3D/QZyJRxl4P0u08EEgkvXhKZQsOfmBk0tWndzTO+yRxV+vUprcBHAtN8XAWyev8AXwt4XojdQ3OINLuP/RyICsQ8ZV8qgtmyRSbB+XVbw6Hhfbl7c3JlZ+HLgnraA/oOnkc4PVwzqLmJqCZWTksXJUfXBeb52fR3rF8NkKGFLmrc1KXqRMr1QFuKCTrK6yeBhc23IKNhmrkViF6NbYGBOLbjfCNeGhXB2mH8egJ90ZbunNsVCM/iO5I19Ek5k56FKP6HHjGXDJNrJUX0DB5aZI98LuW4iKx1uitj6i1Hj5
 tWTyI/7p
 IlGByXjzJ1YTjY516XzTfXHZ6F2VFPD+JxTQ1ucODx+5UshRGfoJTox66BphQwMyLfB322kqviP8fs+r4Z7u8t74I+8Rjp7j99asz0MHr2+rh4Xz+RzaRUmiA1733VZEQQYtZYfe/2jfBNXFaoYx8uNivzd+ZXsmVzngLdta8IzHZfBF3J1FC9NkKAXg30ef3t1VBZ4biHJyXGNR6C2gwOYj7+CWWhG5DrwiRarTBDvv1epSfrfMUDLRoPyN35+ZQLsmPrrcxrngzgh1cB84RPiCasIQkzrbZ3SGLLp5LRojk63hlo9qT3dEnOOVFFL6USAZUvRJT0DeROa3kgG1d9ZfOfvuNDH/nWMsEz0UYP9EesJuBNCPnW/wzm/L2G2veAhK9yn8EHgSWQvkq3Gf9Qs4Kju1wzrxRlY4Jokm8rDeyfUXnkufuI/jpWIwTzXDzRsXE9ARgBwyZs+qraN7fRItEKlSSebrn5swtGXaB5hUWS1TGSlwV7Ul4cVDaESVbeTEqZkuC3QWYuCX8+a/xfAtNMsnHNf/E8WUBolcah4K11G7krzgCUNk5NxRI6txmBDN0FH0ZVB/kTfG7udMIxaOZVSMeLhqA7DYG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 05:49, Barry Song (Xiaomi) wrote:
> The comment appears to be outdated. First, add_to_swap() no longer
> exists after Kairui’s commit b487a2da3575 ("mm, swap: simplify folio
> swap allocation"). Second, partially zapped folios are now always
> split before folio_alloc_swap() to avoid extra I/O, following Ryan’s
> commit 5ed890ce5147 ("mm: vmscan: avoid split during
> shrink_folio_list()").

Not necessarily. We have some scenarios where we have partially-mapped folios
not detected as such as of today (with CONFIG_NO_PAGE_MAPCOUNT).

> Fix this by making the description more generic.
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Youngjun Park <youngjun.park@lge.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/huge_memory.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..4586f3ccb133 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4190,11 +4190,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  
>  		folio_unlock(new_folio);
>  		/*
> -		 * Subpages may be freed if there wasn't any mapping
> -		 * like if add_to_swap() is running on a lru page that
> -		 * had its mapping zapped. And freeing these pages
> -		 * requires taking the lru_lock so we do the put_page
> -		 * of the tail pages after the split is complete.
> +		 * Subpages whose mapping has been zapped may be freed
> +		 * earlier, but freeing them requires taking the
> +		 * lru_lock, so we defer put_page() on tail pages until
> +		 * after the split completes.
>  		 */
>  		free_folio_and_swap_cache(new_folio);
>  	}

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

