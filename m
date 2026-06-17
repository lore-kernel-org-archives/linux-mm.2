Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C70CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5110D6B00A2; Wed, 17 Jun 2026 08:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0B86B00A4; Wed, 17 Jun 2026 08:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AFB76B00A5; Wed, 17 Jun 2026 08:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 180616B00A2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:28:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C2781203ED
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:28:49 +0000 (UTC)
X-FDA: 84889333578.01.C923163
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id CDEAB120002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:28:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aPu0lwpL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781699327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLeD86WlaOzT6NMJq1mWVXP+jO3RbCBQR26svGNQO/Y=;
	b=Y1Pg+P1i24DvqsZKGQ5rXm1zu6Vc2BBj+nrnYmlXlB1gFIUGRdS4npTMCes/lIAsSfGif5
	QyJfsBeTB1vJWo+p6HDE3cTRBAWDnK9IdsM/D9nY+uXCN2By17oXNEyhTz81xahlhY9aXs
	vVMRawIr8RmoElJpC5uZxs+nbQeSBww=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aPu0lwpL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781699327;
	b=6xJTTwqOUfi4+YibG4L0sMp6RqG97JTN4Hrp/PdJtPKPDVgm+v77ABxMagWUTLWYry0fYD
	Ny8MwBqgQPs8gGgVP5eKsMotE0ANc+NzRrGm31b11uEAjQMT/Zt3a6Cp4yHy+nj9e0oZjB
	B22ltILHZixq5MDQF3EqtaV1ra6hVXs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 625C360052;
	Wed, 17 Jun 2026 12:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6881F000E9;
	Wed, 17 Jun 2026 12:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781699327;
	bh=mLeD86WlaOzT6NMJq1mWVXP+jO3RbCBQR26svGNQO/Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aPu0lwpLerB36iAslE6t72DuGoUvNHsGDCoXJHzSwA4YW/NjJyaDt+rl84MRMFnul
	 7/WkoIyvV5Edo1017A9I6dxi5XZkKhjLiFeZU67o3pCgjevg3TndZO88HQdMXJsYSd
	 HNjWKm2M/aQX1iAj9MEUo3UIhs44NXDNk51fDK+r8iK6dZn2I3ZjiC4ugHaMH50FZd
	 vojPOYSoL2fULeUgBoqx7STZzdG3MMZOXE2LCDKA/pfqCOCvLvJtq9ncw15r9dlAwr
	 UuOoK0qsRQuu6CCNznHS3y6VMCFaDHC2exTr0U8klHJvN6f5t7ZR4G7P2eQWCTLI+E
	 HsVTLOARVFQKQ==
Message-ID: <72874bf7-d2f7-4bb9-9211-804533bd5c19@kernel.org>
Date: Wed, 17 Jun 2026 14:28:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] mm/vmscan: extract folio unmap logic into
 folio_try_unmap()
To: Zhang Peng <zippermonkey@icloud.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
 Zhang Peng <bruzzhang@tencent.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
 <20260525-batch-tlb-flush-v4-4-83789d6abc00@icloud.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260525-batch-tlb-flush-v4-4-83789d6abc00@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CDEAB120002
X-Rspam-User: 
X-Stat-Signature: hyokh689wn8tko3ppzbst14akfjtunke
X-Rspamd-Server: rspam09
X-HE-Tag: 1781699327-879974
X-HE-Meta: U2FsdGVkX19U9vlRhopX7Mvx6ECKt9MMy547R+yfk/+zBDB8ay3DgB7AyvF+LZf+Tko3NWSnFNTg+nvLDR3SjHK68TjRwVVTR9dfL+UkWdQ7Fgx11HQbp6JNLojDO4q0D9AhWpoQpOdsvFBem7DiBFULFFcS3xKMF0c+QXsDzbiq/N8eSk5YMZ9MalS3mt/ZE7msYsR3SmOFaWf1r7zwOtuiKkCxQvqNF7q24uMgW07e+4lzlWzs0eZ6Gt2Yd3fssjmP+6nSetYwUXWjtlagXWw4KYU36/cf0lgFN6fyTpb4z4pO2L75SH065AYtd2GmEU5N+Ac83E41fz7IvZ0gmNVmRIBoWBBsjaPkAdg69V13vIDjrIiTEAbBFnaEKPPl4rDljOGmszWlVkoiQICeOt8XG5Hk0XEHRLd1uo5SShg8uSWNjTBtxzEhtGR6y1Wl/7VEDKWKzz1lMYrVEDvHo2l4MIm40YK0h8JHqPHsL99KAwUJSgRVj6sd6h97bDhLjjDPZaSyJANDAb+5+yzZC7srXWuwCds5fqtcyTBoEhBBibs+aaHuKQUNZC00E9c2kyKtQhhx2PXID8SSTODVuxzzQXIaTl93M9z9dMDS0fidUaL2VRsy8c6zQF3nGOwdcJb1LCY2QOYsBZSPfaFPkuHzsxpNfPXYMagJV7ksQyZcId/gomp+75upTQWm0ZZnE71KIUgRL3VXK+arBOXxgDENmwBsbS2VN4AKDsUBIJOx7ZtrN3MTMjooq0u/ugNJo+zmvEJy4Fsrn/muskhFGdPCgLhPGt60Lv0oNhfRUt8BhCggUp7ugMfKKTBLFBXJ7ZEH4YVUc8mh2KqMtpTGK5KZLB2kB4x9xZjEDTyi8sS6+PW/cNLwwN0+jySBLQQKxOVZKEAUR3aOrZbzMN+ro4jSN4wkcTWD/syGWGjze84oRzO2MMshPEX0ZUmQ0d6/zVctkarCF50N9QzFbBk
 eDRLB4z7
 x199m1CUECQcoUJ3ZUHMKxHgDLJGre7N5h5HGmZ39Iv5OrzwciQ0jlPuk9sPZsGSLWNfgclC910nO+5XnoCMydeE4bEHxnBv0ztodmNB8sGsiYQExVahZvmZaH4rc2tPlRksHnUg6pqPrytHwvL3dM+Nq15mTI6YDFEhNxe/O/L/Ytmge62Hvm1iK8q4tWjC12PIQc2d+LEtToQXa89dXEsiEI4FaePpX3bl+mHROU3vfNqUvMqNJA2HuJx/adeuuEjHKOoAHnUwAL07nlqfXWFjp/GuxU3WEnYhdBiueMp3GzDqk7FQxn9vQI8R3dGh9iw1lZq5UYd6JpTw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 16:57, Zhang Peng wrote:
> shrink_folio_list() contains a self-contained block that sets up
> TTU flags and calls try_to_unmap(), accounting for failures via
> reclaim_stat. Extract it into folio_try_unmap() to reduce the size
> of shrink_folio_list() and make the unmap step independently readable.
> 
> folio_try_unmap() is only called when the folio is actually mapped;
> the !folio_mapped() check stays in the caller, keeping the function's
> semantics clear: it tries to unmap a mapped folio and returns whether
> the unmap succeeded.
> 
> No functional change.
> 
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---
>  mm/vmscan.c | 68 ++++++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 38 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 456d38eb172c..abf3a2878456 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1221,6 +1221,41 @@ static bool pageout_one(struct folio *folio,
>  	return false;
>  }
>  
> +static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
> +			    unsigned int nr_pages)

Two tabs.

folio_try_unmap() vs. try_to_unmap() Hm.

Again, maybe we should throw in a "for_reclaim" ?

folio_try_unmap_for_reclaim() ?

Not sure.

> +{
> +	enum ttu_flags flags = TTU_BATCH_FLUSH;
> +	bool was_swapbacked;
> +
> +	was_swapbacked = folio_test_swapbacked(folio);


const bool was_swapbacked = folio_test_swapbacked(folio);

> +	if (folio_test_pmd_mappable(folio))
> +		flags |= TTU_SPLIT_HUGE_PMD;
> +	/*
> +	 * Without TTU_SYNC, try_to_unmap will only begin to
> +	 * hold PTL from the first present PTE within a large
> +	 * folio. Some initial PTEs might be skipped due to
> +	 * races with parallel PTE writes in which PTEs can be
> +	 * cleared temporarily before being written new present
> +	 * values. This will lead to a large folio is still
> +	 * mapped while some subpages have been partially
> +	 * unmapped after try_to_unmap; TTU_SYNC helps
> +	 * try_to_unmap acquire PTL from the first PTE,
> +	 * eliminating the influence of temporary PTE values.
> +	 */

Comment can now use less LOC.

> +	if (folio_test_large(folio))
> +		flags |= TTU_SYNC;
> +
> +	try_to_unmap(folio, flags);
> +	if (folio_mapped(folio)) {
> +		stat->nr_unmap_fail += nr_pages;
> +		if (!was_swapbacked &&
> +		    folio_test_swapbacked(folio))

Probably best in a single line.

> +			stat->nr_lazyfree_fail += nr_pages;
> +		return false;
> +	}
> +	return true;
> +}
> +
>  /*
>   * Reclaimed folios are counted in the return value.
>   */
> @@ -1495,36 +1530,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  		 * The folio is mapped into the page tables of one or more
>  		 * processes. Try to unmap it here.
>  		 */
> -		if (folio_mapped(folio)) {
> -			enum ttu_flags flags = TTU_BATCH_FLUSH;
> -			bool was_swapbacked = folio_test_swapbacked(folio);
> -
> -			if (folio_test_pmd_mappable(folio))
> -				flags |= TTU_SPLIT_HUGE_PMD;
> -			/*
> -			 * Without TTU_SYNC, try_to_unmap will only begin to
> -			 * hold PTL from the first present PTE within a large
> -			 * folio. Some initial PTEs might be skipped due to
> -			 * races with parallel PTE writes in which PTEs can be
> -			 * cleared temporarily before being written new present
> -			 * values. This will lead to a large folio is still
> -			 * mapped while some subpages have been partially
> -			 * unmapped after try_to_unmap; TTU_SYNC helps
> -			 * try_to_unmap acquire PTL from the first PTE,
> -			 * eliminating the influence of temporary PTE values.
> -			 */
> -			if (folio_test_large(folio))
> -				flags |= TTU_SYNC;
> -
> -			try_to_unmap(folio, flags);
> -			if (folio_mapped(folio)) {
> -				stat->nr_unmap_fail += nr_pages;
> -				if (!was_swapbacked &&
> -				    folio_test_swapbacked(folio))
> -					stat->nr_lazyfree_fail += nr_pages;
> -				goto activate_locked;
> -			}
> -		}
> +		if (folio_mapped(folio) &&
> +		    !folio_try_unmap(folio, stat, nr_pages))

Probably best in a single line.

> +			goto activate_locked;
>  
>  		/*
>  		 * Folio is unmapped now so it cannot be newly pinned anymore.
> 


-- 
Cheers,

David

