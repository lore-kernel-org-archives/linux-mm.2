Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39A1CC6B1F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57FA6B0095; Wed, 14 Oct 2026 05:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31D16B0096; Wed, 14 Oct 2026 05:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46376B0098; Wed, 14 Oct 2026 05:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 833F96B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:25:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE73EA048D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:25:27 +0000 (UTC)
X-FDA: 85320698694.05.14178D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 217D8180007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:25:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jO5b6GV/";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791969926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmX2eNFe+FELApsNl9w69BnQeqx//n+AuznHDFMkOG8=;
	b=TucmCHBOv0h+jsMBD5NhNnt3Ch3pp5K76e7Pv+9UpVV7me/OncNmX2MBbwLOtReaMat9FG
	W+f9jLssohGsDkwUSq/8VXMLFuLjx2sWM56eF4a/YP08U/AdBVU3rOAPoRzi/wlRRHE45d
	BHvW+ZuTegcipcb0h3/aUlqiWihfSe4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jO5b6GV/";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791969926;
	b=KpHUgXvp+tRfjFD8682n/o3Zs1mtYIrmLI8EIzDIxez6TXIyqNlHLduTdXIU/G7ra3FdVo
	mw8uiOacRsF3axwNFlBlFYmW+Oc7i2mRRPLNlqUm0Awbs6FI9X0/fXfNLagAbps1J5C1tJ
	8ZAvfCxwxlbtKeBrEffZpR0gvkNAUn0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC52A43378;
	Wed, 14 Oct 2026 09:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0744B1F000FF;
	Wed, 14 Oct 2026 09:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791969924;
	bh=YmX2eNFe+FELApsNl9w69BnQeqx//n+AuznHDFMkOG8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jO5b6GV/KYqQ7oqIp7paAGm+LoOkutQPFYBgrE51ZQVTT6zBBkawBB0SLo+eAJPx4
	 VmmtydqIT7Itxb+b+vKFq/O5uCqfeumNnryIn5xE9K9v5NmIvLjyPFNyvcvj2Ys5Zm
	 9m/Gbb2reBNLzZnFZQlGkSDzJop65XJsQ3BrDMfwyFILa0UlsSlNjeaCZak6vtRbl3
	 79vHpC+8T7Kyv8fuOVom/jk9P53ogPcgqOCvGsjCJoccr6CipcmqFcgtXyvHB+Q33t
	 H+DU4kO8Jo4kE/KiFivqBaKz3gXj9qwRLwM002ihN3n/2XBXJGYe+lki7YKomxq8PR
	 oZpqeMgjTSKBA==
Message-ID: <9f4c7a96-7cbe-431e-afcc-8bf7224e1dfd@kernel.org>
Date: Wed, 14 Oct 2026 11:25:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: atomically clear the young bit on THP
 MADV_COLD
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Minchan Kim <minchan@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 stable@vger.kernel.org, Samarth Narang <samarth.colleges@gmail.com>
References: <20261013191719.95502-1-pfalcato@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261013191719.95502-1-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 217D8180007
X-Stat-Signature: ggfq7j1abno5w31m7hewdqstngk48ceb
X-HE-Tag: 1791969925-368124
X-HE-Meta: U2FsdGVkX1/q7Pw/2NGtwu4VghQhDTLwH/Xt/V/f7WP1g8obNWWcfJJtS/VviVvyr2GSH8x4PWTBL2Ewh+1PmefskQFlSW0GHCWWkY1jWzwhjRomklH5b8UvjGESWgNYRMVm650xqKDnhg2wYGMLEQ0nrIonY4uv9s2KPYmhbBY/qus83yo69TBLA9MygoB5kk2NdJCGNvOHJTIGP8tQQavdvVtiV3pr6moXGUglxcHE3421dpjD12DLKr4jsfypZkemjSJdKxQQ4XQQV/UcxwaLOLERDqIllwBmCs1V7+hITrrie7JNhTfTIYGEKlm0uKnMo06vF3U87InZHWGk/pLZIorXIV4advP+kG7S1Uurd70WtVW+ZQCeSkIKh/Ht3y12S7zOyOk7ODfqZeQBA00MeWyAY6lUROVU+NEGu8Xy0qKbxihp25OqIAE/UhGwj3RUXqw4K/Zl5uz4vpD6Yb4M72Z6o0SHuMcy01YO8Kbr+bOli37M7Auj3bNs9XPyJOVZvLSwP/swj720XTqii26YBJTsTJHzWJAryn2V6v+1vuBJuiwQoo/qjfozTNYTHBbnJpHFpCnW+sNIgap9kQyVOgs1VbsDxgDKlnxIK7GtqLPBQiVs72sgDGJ8L/R1rBxlmqF0UpYBWPWw9FhmBAsywvns00nFCd8dQiwZA6OyEZJjOWiFSjSUq34nNfL1++clNxay8Ntmi56yEDhSk6r6HJkUQ59ecdnv0IdFt5OpnsalyGtZqvZElRnAH5Os+OC+AbhmqYP46wXD/l7vRE5a8pU2HVIdIivaVB/1TfhpQ4gaqgLY//Jq8a2tC2ALEWXG9aeu5g1N3Hd3RPoSHoNkeiyzLNOavhYxa/tHStscCxGYNezfEkdfzv1K/L8DXIArDxF1FfVI+x0pW1iiIz369sXnTu1wzbPescvir8gvE90psZt/jy+LFBHKHCyowuOMSGEaESHVi5ImLc5
 1elaW/Ub
 B5GycTyi0KlF5A15cb0fdCvUufXKLh6C/h1oV6AaM40A1WzSOeDAl04HyYW2CpsZ8V9jC7mryQ94Vn3hGGw8rWkZsrdGUzPsS/NlCdVkxiKklLnU6N03H8MmSZZseyCwHo7nh5ama3GXz56fJBMQGcwJmL4GxiguwOn5/8nl5lHn5tLPYRR0vJ2P0NXwT4gK1k4fSvFlgUaJOomnRbJ/GS/NRhUvf02rktFjPxTCRjVLlhzl17oKwz/8YLmk/c8/qldaygP7UMFKSMXRN1WdLY/gNNfMd/aLyDG2UoLiqD48bWtxsn75h8HWnKciQeL5xnoz4baSP/+zgfIi9DiviORobQNtP2Js8NpJJuIzjS5ugprT6tY4ZQoY4v9uvuEwu8XPzIkxzjAvmDhUb4yZUMMdhQcmM5hxsYkoNecclOa4xmcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 21:17, Pedro Falcato wrote:
> As-is, madvise_cold_or_pageout_pte_range() discards the hardware young
> bit by invalidating the PMD, doing pmd_mkold() and subsequently writing
> to the pmd again. However, it does so in a racy manner, looking at a
> possibly-stale snapshot. It's entirely possible that a write elsewhere
> set the hardware D bit, which this logic now loses.
> 
> Fix it by using pmdp_test_and_clear_young(). This is an atomic
> modification of the PMD entry, and thus safe against any possible racing
> writes. As a (nice) side-effect, this elides one non-required TLB flush
> in pmdp_invalidate().
> 
> This bug can interact with the swapping system in complicated ways, leading
> to data loss. For instance, if a folio is marked lazyfree, but was later
> read from, and then MADV_COLD'd while racing a write to that same THP,
> dropping the dirty bit may lead to data loss as reclaim/MADV_PAGEOUT drops
> the "clean" anon folio:
> 
> T0                                T1
> ================================================================
> MADV_FREE(thp)			|
>   folio marked lazyfree		|
> read(thp)			|
>   PMD marked young by hardware	|
> 				| MADV_COLD(thp)
> write(thp)			|   if (pmd_young(pmd)) {
>   PMD marked dirty by hardware	|     set(pmdp, pmd_mkold(pmd));
> MADV_PAGEOUT/reclaim		|
>   dirty bit may or may not be   |
>   set				|
>     reclaim/pageout may drop    |
>     the folio			|
> 
> Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
> Cc: stable@vger.kernel.org
> Reported-by: Samarth Narang <samarth.colleges@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20261011132227.413217-1-samarth.colleges@gmail.com/
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  mm/madvise.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 85ab9bc76e06..19cd3bb4d1b9 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -431,10 +431,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  		}
>  
>  		if (!pageout && pmd_young(orig_pmd)) {
> -			pmdp_invalidate(vma, addr, pmd);
> -			orig_pmd = pmd_mkold(orig_pmd);
> -
> -			set_pmd_at(mm, addr, pmd, orig_pmd);
> +			pmdp_test_and_clear_young(vma, addr, pmd);
>  			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
Ah, we even already have that arch helper, nice. Let's hope all relevant
architectures implement a proper variant :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

