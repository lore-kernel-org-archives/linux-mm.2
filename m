Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F36606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 22:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lR3MVu/k
Received: by kanga.kvack.org (Postfix)
	id 47F746B05B3; Tue, 17 Nov 2026 17:12:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FCA6B05B4; Tue, 17 Nov 2026 17:12:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EA76B05B5; Tue, 17 Nov 2026 17:12:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFDA26B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:12:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3536C1C32CE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:12:23 +0000 (UTC)
X-FDA: 85446010566.01.DD22F2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5208C1C0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:12:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lR3MVu/k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794953541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZLccKoHtb+ZmNy3BeJ06NkHam5um1C3cVzdSpAG6II=;
	b=m+5kdZXTDa0ves72DINUw3K0WNqDE9pUxAJkVglCamw++soNECBdP9VTFe7vAv+Rh9VV/N
	MzJ7KCI+9RTM+vUcq43CDq5pF/tSlQReRve4o8yg124+EZOFh9/HYY3X7yhvMm5YXKGTXR
	WWkqPohpSlQbIxDwnDz+xy7Y89RZ1nE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794953541;
	b=NWE+sgvyhAk0wU9x9UBXIlwbXcJE4aqzK25ZyiELs5DYkOjz1YiT7lG5qeHMLhLRFc+5R/
	nZWuDMKwd9lLbhyZL9+pmG+WuYzvtCqucPxuOG8xPwv8JvrzatuhRBIMATDesZGAaicRN/
	X9lJS9OwGDDr61WyX5HTKkBtcSF0gn8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lR3MVu/k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA3BB4368E;
	Tue, 17 Nov 2026 22:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1431F000C4;
	Tue, 17 Nov 2026 22:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794953539;
	bh=tZLccKoHtb+ZmNy3BeJ06NkHam5um1C3cVzdSpAG6II=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lR3MVu/kTbFX4bLl0D2sDfHm2Z0o9DlnIQExpQwjndq3JhEouU53z2FHMhNNoooi4
	 l0MvdJFGc+gYUmgbyb1YoP5wABG5NNcpNnfu4YNK64DzVQTTaXTD10vIwTNTuE7ngv
	 5D9x0rEUJiFrNSN8viKGBJmaFiVzSKp0OID5Kk0Xoclo/nw2VomKcuOCnq81II4hec
	 dXWPkrQWTun/krky4VhkU2B7RSKfeFlAURbawZzCIZLk4Tt9vfkaifk2vL4UTQmf0P
	 K7c5N+nlZkL5bWGND6tryG3/OePRTpHITJr5IYiq58xg/+CgYmzDvAsPbeOX15wsBi
	 uFh4Jx7v3kRIg==
Message-ID: <1ef43070-e7b8-431f-8195-0c0f01ce25bf@kernel.org>
Date: Tue, 17 Nov 2026 23:12:10 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm/huge_memory: scale thp_underused() to the folio
 size
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org,
 kas@kernel.org, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-2-joannelkoong@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261103212004.1356327-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5208C1C0008
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: uihx55wty4knburyr7xqfk6in6tdxir4
X-Rspam-User: 
X-HE-Tag: 1794953541-18355
X-HE-Meta: U2FsdGVkX19mZ+Bp5h3LULMZvpU4XcJ2AZAHZwuGi6F8LYoGoXO769WzTgG/tC3vlklBVqzMspWO1py8aTim3FzNG42WglrGAxJ2rh18BGsmDAVI/kowqFg4Vxi8KaKpY+B2NOyyE1cpZNfW4KifvGESCchrirO+ta1Z9FgedoLJ4djSSyqnsX1uIXibAGracDdvQu63OLWi6tJyQW8pTaokiS6a7NR+jG9LZS234batDjuRx22DuE02ItMDjvCuzmuwcvR51X+bTd7nJeQAJ4+GQsBLdvmeKJCuDjZPXex2lCTNmVkGj3A1oSzSptneHiMeat/FVAOTvYY6nwiGA7xRkjK0ETf4TLPA7ReacaF5fEYMNrCSPSjavyfZ6xKfaUNWkK0OjOCBRVH0tRrLiHDmUZ3cbXXQlfsX03DWPde3ZT7D6pPo5lb3mHY5tAUM8hsdtpsBgaDSuml+m1sxq9cNlp22U0iqjbPmzLFq5AuzQ/2Ii8BbgtxSL5IZ8pMmfpW9lc8J0tJfqzUmco/LSNS0IZX7XWPWrgysZ648Q/EtqJtcVZBK+EFG9YYtgNN2fekNQKVaWuzq1Vj/F6e7qWOkpxrEftOKeb8PrVm0POw4MuMbq8NNY+7ygAiHgYGpoULyWm+3EPBEac2pYjkCGZSPu5AgIgjU9drRkRskkFJ3fsyzyDjcdC4ArKCRGU9VXbxQ4YO31G5gSczqp8Xan1FzrrFdd2dxGESZ1IUOV4B3lfDZDew5QAhksTdwmL4R/zFP8K4BjKhrv4XcAdRfpcQB1Ib4dtQMpL4YK0xgn5JVISsxcP/KjetKWyQIUapu0kANvz45l31pHw/P2T27+8k2RMX2hF0yVzYIC7stvq05Jp1X+TxsJG2RSh86yxqH2OmucIE4b33NaCkwxXmXrYEEpwnS/rTw/8OM2pLxOgpgY9CxQxyNw9eBL23dkJ2hDm9M1mI2BPlAiZ5U/M1
 w9nSmN9b
 VtocqPtMjG5+UVL0xeZE5NkNZVyy0m7MPU07HiqNk9qyAAbhfvcHuUnfOQVPQzqMRkDsLr4pOuofb11/yUFo24BXIeWejUsut4wydg1U3YUOZzg+CtbSIEv2gyOArz5NSOmXngM+T8tYLNKzyKxIJSdpGCmllT/L7Lu8CvychkXBJcZHEAW2oa6rdL+OUyTOUG86Uioqw8MV00sMho7rmsJjIGN5DJkS6ksuV7xQfr4vGwGeVGQOIwSPnl2OwMcrQNXJ75DrPxegv8RZ8IRy5IjppOOQt4oQNH1j1zQdw9HmfKOur+VPk4hloztcS7IOKTrIW8c3L+iZ8dV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 22:20, Joanne Koong wrote:
> thp_underused() decides whether a large folio on the deferred split list
> is underused and should be split so that its zero-filled subpages can be
> reclaimed.
> 
> Today it only ever runs on PMD-sized folios, so it assumes that the
> folio has HPAGE_PMD_NR pages and compares the zero-filled page count
> directly against khugepaged_max_ptes_none. A later patch will queue
> anonymous mTHP folios onto the deferred split list as well, at which
> point that assumption will no longer hold.
> 
> Make thp_underused() folio-size-aware, and scale
> khugepaged_max_ptes_none proportionally to the number of pages in the
> folio (eg every folio tolerates the same fraction of zero-filled pages
> the user configured for a PMD-sized folio).
> 
> khugepaged deliberately doesn't scale intermediate values when
> collapsing to mTHP orders (to avoid the memory footprint creeping up
> through repeated collapses), but if/when collapse later gains support
> for intermediate values, a folio that khugepaged collapses won't then be
> split right back by the shrinker (and vice versa) since both collapse
> and split would use the same threshold for a given folio size.
> 
> There is no functional change for PMD-sized folios, as for those,
> nr_pages is HPAGE_PMD_NR.
> 
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  mm/huge_memory.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 14599d0fff01..3720c12bdb0d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4625,25 +4625,33 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>  
>  static bool thp_underused(struct folio *folio)
>  {
> -	int num_zero_pages = 0, num_filled_pages = 0;
> -	int i;
> +	const unsigned long nr_pages = folio_nr_pages(folio);
> +	unsigned long num_zero_pages = 0, num_filled_pages = 0;
> +	unsigned long max_ptes_none = khugepaged_max_ptes_none;
> +	unsigned long i;
>  
> -	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
> +	if (max_ptes_none == HPAGE_PMD_NR - 1)
>  		return false;
>  
>  	if (folio_contain_hwpoisoned_page(folio))
>  		return false;
>  
> -	for (i = 0; i < folio_nr_pages(folio); i++) {
> +	/*
> +	 * khugepaged_max_ptes_none is a number of pages out of HPAGE_PMD_NR.
> +	 * Scale it to this folio's size.
> +	 */
> +	max_ptes_none = max_ptes_none * nr_pages / HPAGE_PMD_NR;
> +

Can we have a helper for that right away?

In khugepaged.c we have a collapse_max_ptes_none(). I assume at some point we want to revisit mthp collapse there.

So maybe just have a

	khugepaged_scaled_max_ptes_none()

Placed either in mm/khugepaged.c (making khugepaged_max_ptes_none static), or into include/linux/khugepaged.h.

... and use that at the top

	const unsigned long max_ptes_none = khugepaged_scaled_max_ptes_none(nr_-pages);

Then we don't need any code comments here.

Let it return some "nr_pages - 1" (or another value of your chosing), return false.

Apart from that LGTM.

-- 
Cheers,

David

