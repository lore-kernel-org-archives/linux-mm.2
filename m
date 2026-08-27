Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E3B8C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A82E6B0088; Thu, 27 Aug 2026 10:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758C86B008A; Thu, 27 Aug 2026 10:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648226B008C; Thu, 27 Aug 2026 10:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30AE16B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:13:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1615A3C77
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:13:17 +0000 (UTC)
X-FDA: 85147241634.13.881CB8A
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf17.hostedemail.com (Postfix) with ESMTP id B033040002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:13:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="d s09ofY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=dxAIGk0P;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787839995;
	b=6ztFRuaPdLkQV7LaWYxbHEI5HO9ATBlIFXTrytVBjRMHLimhmp0uomzW6UFoNobezT4SEc
	REI+D0iRgy/7jq6fPS6x/h5hsURPu+hQDHwshQ9wZGjsC7jzAZFtBgJHDeK3Yo5tBHwgUU
	Mfae4OFJcEDyuwXBWSMfk91qaVLVUk4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="d s09ofY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=dxAIGk0P;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787839995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+ad3PWrXwgTs5V91pQ1swMOoVBYuDGaQPrZTnXXjJY=;
	b=b78JsqooMjri8CVFLSRkYiITqwtq/MAhWkZx5+NKAIv8cOovcuzrIcD7HC9eCNEGbKTmMx
	+qUu9IPA6vvu6tSyBnMd+1uqjB5Xofh0zt+WSQD5X2I3ODTdPKAYAuPr9vEl4KaKHNrAsk
	fBSCtPlplGy5KQnlKVViHOgpp7/mX88=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id 37EE213801E7;
	Thu, 27 Aug 2026 10:13:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 27 Aug 2026 10:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787839995; x=
	1787847195; bh=a+ad3PWrXwgTs5V91pQ1swMOoVBYuDGaQPrZTnXXjJY=; b=d
	s09ofY7ELOFH7RFgsvJ+emVZ/K8ZKNZ4+19jt40VhFb9thzys/ihqVT53zykCsDL
	BU/CTT+WD8gbFggtD4N1Z/gYmSILTA0nYnczsZ2GrDkBiYGJZhmi1zK3NR7uOFVr
	ZXM/wWj4eH+ZnGJBdN4wu9bCb/Ig5xgZtVgMeh4N+B/UoCwxWELzmQBxLuh9QkaS
	i+tIh4Q4jYNPMEcTPhzfPCbb+XWek7rt+TNBiGoLexkyuAi7NPcNIEFht8ftHs6o
	zLazJuIm0f6z2eOueSppO/vfCbtLd59GRgrjm5ZDX69oaAM61MYIzTbXJWu66Es2
	FxM5JuZSSzZFeX61oDuCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787839995; x=1787847195; bh=a+ad3PWrXwgTs5V91pQ1swMOoVBYuDGaQPr
	ZTnXXjJY=; b=dxAIGk0P0dHb8eQw+3a/USTt2FMJUs9Q32QnFiFe5CwjR4+XMq2
	RbmQUNENpHzo6wnzk9Zkx/k6AlxEKCHCOwlM+VXKhQWXYeBVcSSpOP0yExNM/2kV
	Al52kMEOx3afn6l1P8D9KrEzxD1VYPHHvLhaS7HA8x/awIijyC5JKWLxTmA1jh82
	JN4gx0RR2wYsScEYDKqTktsdoa/z9bVdXxJtyOAgfnrlTIAP2/ZNIR/YQ8xo7nHH
	vkalDXl4BLVvhjsSL+WwXZ9ovDUGsiZqxprylyZnm3YvPBeuEAA26VLP0RyAM4La
	aQOI9v047lx78LTxHRr/GFDfcOCCQCsuXfQ==
X-ME-Sender: <xms:-UWQagu2AJDZRbZ9-eQuu4sa7U66wg7jz1LfQ80-Kz0pEGzxilQYsw>
    <xme:-UWQavfra08ahe8CNDRwGZBZC0A7jsn8z8PTKts8Cv3x5xAY126zStkbDj4M3M9lk
    965MY6TiqwlPA-F2dGm3px7G1-DUnNOtXW3aG1KZ6MdBw4gghcL5hBi>
X-ME-Received: <xmr:-UWQagEX4jKyN3omyOG79EXEVPZc7LGzkFH98japSGv0G1xgNvIGqJXFSQM>
X-ME-Proxy-Cause: dmFkZTF5zwx6+vi1CF17Vvppug3FxN3o2hxSLt1bKKQt8LhiFApBJj51ijsaN2etDF3CDd
    jqq4P8ChL6OV5M81X6rGtEQ9HTYKgxocCr8ggIyBphA45QUrYa1nXXmbgDGuOTRWkx9Xau
    SFmtpywzmW0SYl5OeCOC/4Tdnt0GRfSbJkzrb7eQH2kHukPsFyTbcQ8v+oXGpdakNYvUKI
    9MARg7kD2h5P6L7fS2+NE6AoNGx3NuLZFIWxLV7F8ZfrFis+014diWNTTJu0aAeY7JNZaO
    WUkxfXJAa3o7ME6TrOvHV2hSdgYqeD4MdhHPLdiqonry5W1XSlRC4Ij1WbSW7qYH9Rdqe/
    6L0doc8mwOZYaqctOvFuYBOOY7U0AXBV6NWpi4rJKINiqzbe9xUaPOG8EFoQl8ZPa7hyzJ
    DAkI01TSGQlVZNxTuZLhOxIEgKDLmeajtPS8ayOOyrIpPkAlB/HDVqnJwKr27tzY4QDTME
    SEKW9gLt0Hz1nipQej1ZkfIZaXaXh7Ux/MvHrAf8cQ/FI1UgOcW/pCHmPKcbISFHROPo2e
    6rmR+9wXMqn6BdRsDneHCGxSsNGhgoGJOan045RacdmOwSEa7KHC17RR280qx5T3owUq/l
    HAbYT0q5Il0ICsWu7mhVBzrvwxivyNXjn1sSuVHmoLwK9Gj0fK3o76DGf6fQ
X-ME-Proxy: <xmx:-UWQarbNvv8yjLkZjvIlLbSuqEQxQspE7i9TRInWVNMGTH7ExKguFw>
    <xmx:-UWQaqrPeJPUPtepQDuRNPDf9TbubfzMmDu4-YhZVT6Gj4UlzKxPaw>
    <xmx:-UWQam3a6avKB9D368k3MNYgR3FVZs7A6k_pEoHBBP_1CfecO6gElg>
    <xmx:-UWQaljTuWGMKzF5yXGkQP3rqGh7_Ku4DjVg1Wn_v2K6nh-SQbkqGA>
    <xmx:-0WQapakKIu6QhZD5MNiSIJYREhbFyemwoFhzcIgNCVF-jikbi8l6FHt>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 10:13:12 -0400 (EDT)
Date: Thu, 27 Aug 2026 15:13:11 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 01/18] mm/swap: fix off-by-one in swap cache replace
 sanity check
Message-ID: <apBFoq08OWOOM3yP@thinkstation>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-1-9b43f5163238@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-swap-thp-cleanup-v3-1-9b43f5163238@tencent.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B033040002
X-Stat-Signature: ppptapny9d5wkqp94i1r3c5ao4ird8tx
X-Rspam-User: 
X-HE-Tag: 1787839995-93277
X-HE-Meta: U2FsdGVkX1+uT3fOyKN/lmkYbJajmk3vGCLwvCmueY2mSz18KTJoZfpBkLVqgBsOzUYzGdgM9bHzDxJBLBgpyIldxjnuXVRgBogxjX7jE6bVL/4M8mLosGX7CNF7NddVOQrX1Ap4QhP6rOdaR2U93q6vRCZSQR94UNURUF5sJZwD2cYymKGwR0OnsbVhprD1TWZsDKHuUgEx5cJEWRxNNU8xVo8cOAE72WNT02cAZcD5++etn7eQmA45lHGSNsEyPTin/1t+Kdg05jHIdXgtkA7PKnL8n6HUbd8TyP7yzDFKNGxRzVfCH+kZ7fvLMpn5cGldpPOgHkCivsCNXOjyNtT4SYPjLHTjARt3HCJ5z33E6jivcTc+NHycJDsUJSzRkH52Irg1SVByDFGHOdaMap1szWValEUClktKur91+A9waR6PC0lgIfP+D6eI7WObC0WeaMGTZNlJqBuq82dQBFvK3jDeaBHZnTuAZCOLzkFum/9dsXd7bvJexirm4jV8zzKBCpqTvFtCwqCTYWE2TA3h0LK8z2OSWHfbKbK1LYFZ7F7ur03iWv9U3Zthy1/VfJmnwShwcfLZfJU2U+orw50T4UHZm09PZKdM2VCXq9uPm8fb9HJGReT6DLJQ5mzx4tl+bcEY67fa31zJQme58jwOfzKoIGwcouFsW++v2BC0L6k3k8Bv9iSSoHmjEX9pAulNCqlBgLeI+spf9FcC59ovU/BKw3TjBwb4n/bPceMPGLnHMJ91FMKYow5hG5O8DELX7Ge0IeIENVIUMnA36pHTv/scuLkwFDflJtcmFIAW84U6BM2zfp3L2oV2kgzGE6PIdKQA0uiV9j3OM6iBS1zgE/v2czyzzc+IwhjEqoaFq9Kol1B1LYlYn3eSoyBzBw62Y47b7mf/XNStX3QoZB2G+KnqYqFdCOZVTnVNPcevX635ffOlrd1tJiu6VrjAw8Ui3diwp/1PmWFXgLZ
 +tn4BDKF
 t/7IT868Xcht3CcjBHwFDHFi4MxFH4+RxS9QfCkELsnnYcAJmpWpKN2zfqv27vUnUcusoY00etC1gQNfvzQpTgWl7yqE6iVVx3z0M2wbHxZU9ZI0jqo0NPmB8pRsBIRzBVyUAfn+vprOR6bmdPIsQQnXaUFXhcbcj5sAL36q8tqwwJ2hVI6ddZyh1u1sAt+Ec2Ydv5SItHYqUFgYbqAKotst3OLNXkcNqztIwST90DJmZcKUbWfpGfcWAg4ZZ3brrI8HqtoiC65Lk1ZjlJRs4vVjRst9JgLlB297qF3axM3Mh3WbaS0lSOt3TQHVBTuyzFZzrBaW0CPqiRszgur0mi7qYqRfCVRolJCIQtXhjtBR1CE0T04wYubGEPVrg3hRbXvjzc+05PxnM1yAjOEEHFvGMkssfyv3qpeOqB/xJrB8Z4VStt+94/RqYoRbDvNwR20/d8jpn3Q4AUz7O3kEtiRZxCW/BWVKCEQS9G4aezbQ9DKf/Ky4EhL3d6hoEXFzFG6VGzJbPVkjbAiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 02:55:14AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates
> the old folio's range with "while (ci_off++ < ci_end)", so the loop
> body runs on the already-incremented offset: the first entry is
> skipped and one entry past the range is read.  For a folio split
> that entry belongs to the first after-split folio and was just
> repointed by the replacement loop above, so the check would warn
> spuriously whenever sub-folio orders differ from the head folio's,
> as non-uniform swapcache splits now do.
> 
> Use the same do-while pattern as the replacement loop.
> 
> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

> ---
>  mm/swap_state.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b76eb3d876fd..59a577f685b5 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -389,8 +389,9 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
>  	    folio_order(old) != folio_order(new)) {
>  		ci_off = swp_cluster_offset(old->swap);
>  		ci_end = ci_off + folio_nr_pages(old);
> -		while (ci_off++ < ci_end)
> +		do {
>  			WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
> +		} while (++ci_off < ci_end);

I don't particularly like increment mixed with condition, but it seems
to be consistent with other swap code...

>  	}
>  }
>  
> 
> -- 
> 2.55.0
> 
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

