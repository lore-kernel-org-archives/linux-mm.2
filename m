Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DEE5606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EOyp7y/K
Received: by kanga.kvack.org (Postfix)
	id 491C56B05B9; Thu, 29 Oct 2026 05:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469036B05BB; Thu, 29 Oct 2026 05:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384DF6B05B9; Thu, 29 Oct 2026 05:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16B846B05B9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:51:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAD4D40368
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:51:16 +0000 (UTC)
X-FDA: 85375195752.01.83F7CA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D0375140002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:51:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EOyp7y/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793267474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1D22SNiqa1UrbTEMSaPprbApV03u/ZanKGMk7KtF224=;
	b=BBfGsbpcXzHsVJ+ZRFAiacwiNoopVqe71S5BsRwIc+h3biVjlSJn373OD3AVx2aPaCYaUX
	4LLNmIHehRbRGy4YPkXpCx4fDmaSAe6DgH5Nk/N0btJ05ouMn7W9uPDOWZNZWuqg2+hnke
	W0cGLly77x+wXDwaLsH4evMxJxdt7Lc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EOyp7y/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793267474;
	b=5HkFkJ7n8Zaz39eqrAwv0D1t8D4wLcbEtmMovPzgBk9sNm46dOi/5wwkMNffB1rRlPejbk
	dWUGcXVM5vA+bzuBIL1PYOvJR890SC+VgLwPpznz6osMDmlc5JYsf6X078nQExbRS1c3MF
	03dct/jSX0ZDsvi/cy68Nl94YuSUgN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0441B43460;
	Thu, 29 Oct 2026 09:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B5F1F01825;
	Thu, 29 Oct 2026 09:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793267473;
	bh=1D22SNiqa1UrbTEMSaPprbApV03u/ZanKGMk7KtF224=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EOyp7y/KQ28jNwvMBe17X8JocvZojLzsh4FbzrqXockmjLe7Jme2XXnp3gbWwiWZe
	 laDyyVTBheueGI71ovv2woMgR727qgvuJPLBTtp7uFvu+OH9Uu/sXD7p7JSS/9Xj3x
	 O+z2Dfe166i/lVoLbFMjxdwAahvXk5LL/Fr0Iu+UBtVMm4+l0+p/QVVhKBkD1iRYNp
	 3dyA7B1dRKSiWatmXumWdeYbDmgOTdPAu6KfZjoHITIiDQeopMTbx00Lo8TXw/6kbu
	 ue/fnbOAR+t/BFpeBcs/MblQoGdXM0EUZD6Ik9K0iLtH5mAOIAoSDJ6Gai8efjPWkJ
	 B3zoQo7u53SrA==
Message-ID: <9c35b2f5-ab90-468f-98af-3763b557e439@kernel.org>
Date: Thu, 29 Oct 2026 10:51:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: page_alloc: remove ALLOC_NON_BLOCK from
 ALLOC_RESERVES
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>,
 Salvatore Dipietro <dipiets@amazon.it>, Christoph Hellwig <hch@lst.de>,
 Dave Chinner <dgc@kernel.org>, Matt Fleming <matt@readmodwrite.com>,
 Mel Gorman <mgorman@techsingularity.net>, Michal Hocko <mhocko@suse.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261028171719.2043421-1-hannes@cmpxchg.org>
 <20261028171719.2043421-3-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261028171719.2043421-3-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D0375140002
X-Stat-Signature: 8byz59d41imeapqbcxm3bki5j5gs4m89
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793267474-206077
X-HE-Meta: U2FsdGVkX1810Z4DKin8DKc2xVhJJLC39JlgKTz6eoTuU4zrQ60Jd7ts990IOSlLgUvYlWxxIENiCQe7fm2xMXsf9L3vJkRgJ1q7EBeKl9rybPYxA45QGBrfslkfz7BAYRUCo7qzYe8HpS1z5io7ROiA7Ug5dtw8pXE8JGmMVe1JiL6Ey8XonAgtKu2P07X9KHvzuCclhbckjPRRpwiuHQDIwxnYvshgWaFjKLQAB0U/gaut6lixCSrgoebF8nYiauqKC+EUJKOmOC6k3w2zUj0tJqCnY0JbDMWhG9n94jjE0vnaUA7YuouM7VLG9WUhYIJ0SobGmYU0LBRezzGpqgcbmEHeLBZDk6QWEfVqJAeTUbn4hq88JYKFBgq6L0fsvc49Xb5LCX0QYk2Ttq9EVOsdLVq0ptilvxyytl5qHuvC/56/dzhXPBxEZEsBK0njsuxzn5EGIZ75gpEb8y1NVcQp+uAEuV8JMSIfeemAXHyFEccHdlCupV2adWsu+ynXQvkVvNEGCJUFkR/SJ/zz0PvNJ36gHqRLsNB4RL2sXFXizRtlHy66W4j8A6yIHGiVBX5z0GMm3qDe9vDPI3l0N7N4m1XjfgXWuv7wAt8Q3xPzDP7iJ+M+/kcYKrrOLSy6ZWRBfwafOszLmwE7HrVXtDHoBncZWdDKRIOkBBLPDHeNzOENBEgcgRnjTxwD/rKhmVPxF/5HCRSAUiena4NOfmZnJCBhAAvNtKza96Y3sdOgY3ohnSl+LzXQTuD2eeq4e+U96eN4uESayE76DoW/3pWAFc85/bapSgR9p6WvOKmw899LQd9vacqrOYaffpACgwTvrW1BSE23Kx9r9AjvmS4is4cBZZzZNViVEORFW5OEkAJ8ZzE1oX5PQptAzF0itg07JWVLgf1Oj2Al1qeEhw11ykRDRC7bAYM6isYJ2IBABZyAXyn1ePS/J4qlXXaxl9kQ3IWATa2YN04C+Co
 WPmg1tJG
 LIheNHGzxboiSIvjpdWzeWQ6JwEZY0NlnTu8PDJB9xyYJh3zB21Q4/SoT+EzOABGmDr8rTiECW6sWzqmpUA60E4L+dOMDlRqrCcDpQfCzISXUjpmyjKOtTN3hSxKYGqfhz7HfbSCE+rJRBe2tiT0IlL5cLOexwwOk+g+BW5QLaDLB9gztT1ZtSliT3F1/6NSGmCmjsN8JWqW7+jH2iMWg35M16e0lMFGb89kkwYwqK1z5TndjGuDwx3CHAH0KmCYvsfBwPHAVlZuwuZJVEV1+6V2c0laXazflIMV3J/qkibMVC7qDTU7nAdqJ7nQZTUY2B/479s/s1WbVJybBEgJO9rQsEQS1skT71iT+kMZzkuI0WJMSWMVqAdmV5SEj5mpOMSjdKdJ/kXUC1rI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 18:15, Johannes Weiner wrote:
> 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> non-blocking allocations accesses reserves") stopped handing out
> reserve access for ALLOC_NON_BLOCK on its own: the extra 25% below the
> min watermark is now only granted on top of ALLOC_MIN_RESERVE. But the
> flag was left in ALLOC_RESERVES, which produces something odd:
> 
> With the ALLOC_RESERVES match, __zone_watermark_unusable_free() doesn't
> subtract the free highatomic pages for them. So in the slowpath, they
> get to consume regular blocks below the min watermark by the number of
> free highatomic pages. The highatomic reserve is capped at 1% of the
> zone, which on any decently sized machine is a multiple of the min
> watermark: GFP_NOWAIT can drain regular memory to zero.
> 
> The user-visible result is brutal hiccups during bursts of GFP_NOWAIT
> allocations under memory pressure. This was found in review and
> reproduced with a synthetic burst, not observed in production, but the
> sequence of events is a realistic one: On a 32G box with an anonymous
> working set, swap, and a filled 290M highatomic reserve, a GFP_NOWAIT
> burst drove regular free memory in the 28G Normal zone (min=60M) to
> 28M, 0.8M and 0.6M in three runs. Swapout failed to allocate its swap
> table, reclaim scanned 13M pages to reclaim 200k, page faults stalled
> for tens to hundreds of milliseconds. The machine survives it, but not
> by design: direct reclaimers eventually fail and start unreserving
> highatomic blocks, until the allocation succeeds or the reserve is
> gone and the OOM killer runs. That reserve exists for high-order
> atomic allocations; here it is destroyed to bail out a GFP_NOWAIT
> consumer that was never entitled to the memory.
> 
> Remove ALLOC_NON_BLOCK from ALLOC_RESERVES. With that, the GFP_NOWAIT
> burst is stopped short at the min watermark. No direct reclaim, no
> stalls, no failed allocations, and the highatomic reserve stays intact
> for the requests it exists for.
> 
> __zone_watermark_ok() is unaffected, since everything it keys on
> ALLOC_NON_BLOCK is already nested under ALLOC_MIN_RESERVE. Update the
> flag comments accordingly: ALLOC_NON_BLOCK just means the caller can't
> block; the reserve math belongs with ALLOC_MIN_RESERVE.
> 
> GFP_ATOMIC order-0 requests have a milder version of the same problem.
> Through ALLOC_MIN_RESERVE they also count the free highatomic pages in
> their watermark check, but rmqueue_buddy() serves them regular pages
> first and only falls back to the reserve once those are gone. They can
> still push regular free memory to 37.5% of min minus the free
> highatomic pages before the reserve is touched. Unlike GFP_NOWAIT they
> are entitled to the reserve, so this needs the watermark check and the
> freelist order reworked together, and is left to a separate patch.
> 
> Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.h | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index 9c3c2830acb0..7097ea1805f6 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -32,12 +32,11 @@
>  #define ALLOC_OOM		ALLOC_NO_WATERMARKS
>  #endif
>  
> -#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
> -				       * to 25% of the min watermark or
> -				       * 62.5% if __GFP_HIGH is set.
> -				       */
> +#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. */
>  #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
> -				       * of the min watermark.
> +				       * of the min watermark, or 62.5% if
> +				       * the caller cannot block either
> +				       * (ALLOC_NON_BLOCK).
>  				       */
>  #define ALLOC_CPUSET		 0x40 /* check for correct cpuset */
>  #define ALLOC_CMA		 0x80 /* allow allocations from CMA areas */
> @@ -58,7 +57,7 @@
>  #define ALLOC_NO_CODETAG       0x1000
>  
>  /* Flags that allow allocations below the min watermark. */
> -#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> +#define ALLOC_RESERVES (ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
>  
>  /* Flags that mean GFP_ATOMIC */
>  #define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)


