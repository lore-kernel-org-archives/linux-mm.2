Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B33DFC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 14:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66EFC6B0088; Fri, 31 Jul 2026 10:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647496B008A; Fri, 31 Jul 2026 10:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D666B008C; Fri, 31 Jul 2026 10:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBA56B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:53:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADE3B80449
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:53:09 +0000 (UTC)
X-FDA: 85049364498.11.BB7157D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id CDCF0C0013
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:53:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eFQls6H2;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785509588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4x1SK6FQB1gXywldBKYo1o1Hv9krTkpeuwuugXVkblg=;
	b=UQn7It3rjrB8FI3BMUXkh08dD9ymZMgubokpZWLYkqcZ8qEGy6rHul+01x/KNzgemrAi8B
	WazpA3zUQDD8ECfJtTX9WZnp8m4hmk5i9Vd+WmSq/h0p/Rc1womwqQHyv0RIBlFIfJrmgb
	DYkAq6U+INj8FcJ9/XDKT7dDmFOCnpY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eFQls6H2;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785509588;
	b=O9SX66Gis0kQ1vzPHtG/qQGoyWx1ACuTtop29z35At71uIm1u66hCPEr12xYG5+oEYi54Q
	CaEsrWeaL6v5dJzVnAJz03FAi80jtf1PSGhCLkvqqm4zcyjVLbUWR6PRU5BukXTesELAtz
	C/iGCM8D2m5EPRDgsxTjTYpDaRbwEPY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1AF24137E;
	Fri, 31 Jul 2026 14:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDC01F000E9;
	Fri, 31 Jul 2026 14:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785509586;
	bh=4x1SK6FQB1gXywldBKYo1o1Hv9krTkpeuwuugXVkblg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eFQls6H27sn4CofrScIUPfBadO+TKU2V5axepFAdJ80Gzjvm3C9T1JDus1G4zUBRu
	 DxUkDf1LMbllvkJHHQ5IBaITKDeWKnsryUKlrmdtZ8CO2NFK+uYtx6yKFQAZ7Bj1hp
	 /CzwRcPIMpVFozsFAxuTpOCbBpGBDl5NpgS24uT9dCuDrGAnrYyhzI46OZkH+b8uQ6
	 IAkTr63W9fzOEXhr/smBXxRz0ZZ1LVjyc3NkKCS5sDTPa0XelVZDrGUJLQLNUfOe4D
	 LV7S+/zc6IP0kOZvBjuNNQ7ChYxbof6mIWb6VY4pKdLLxrwnreBbaqktfIG0gMvv3A
	 fTddIO4KLZq/Q==
Message-ID: <ee8df643-91dc-4a38-a676-486a0d52c919@kernel.org>
Date: Fri, 31 Jul 2026 16:52:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/26] mm/page_alloc: rename ALLOC_NON_BLOCK back to
 _HARDER
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
 Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>,
 Sean Christopherson <seanjc@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-19-6f5729aa9832@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260726-page_alloc-unmapped-v3-19-6f5729aa9832@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CDCF0C0013
X-Stat-Signature: efeujo39rqykpfnomnyfmspt1q944suj
X-HE-Tag: 1785509587-700672
X-HE-Meta: U2FsdGVkX18aIhPO6zB1cmVuJ85r6y8jG95CyhecgWYmD00OZLixTudHyZFMj/Fz2ouR0ClfC4QbHm1p7XgFDP4HAycAeQXUr4u0Sm7O94mC0V3zBBqPMHHy/WtL1NVWaWqcokl3+PlCg8SGEzUlDn3RuMITjvtwKx8pJ2gH8XWc7EOdxyD8DAL4zDOa6Gn1oFqGMcBsGq+HnOIBQBrnC0H8KuHVHkoEDuIOAcH5Wz8KviPko27IX1J/KoxLHSZGZpm5aa2jT54cSbqjApjBr12yiPKPOgWN3i+7Cc0xyipf6ZsD2NEZ/7uddCFFZF/SsQmglNLc8ZIph5zajnRx8ccdPQSa+yS59QMM/TLx1QAUWRHctBWAqxSJo4yKSaj7+/ZETqdonBdJgzsKxw2kXadgMKO2z2XJ6KTtMV/JygYI7uKG2bz8QaytHyOFOmDgJCDKZNdO+PTrLB6k+UmqZAI0Jurpnz91hG6tkHaHOzmGB6jVF+zyC/JH9loNAmcye+5+0Sgr5wXOshsOh1kWh9kPdkM+oWMPRxCf9+JvVf+mmTC1Izd+iVhbV2ylUwjTtkUBUsP1VE0taSvbESsTxSqD84Hw/d/wVwZFFF4BesfKtmtKYUK0OCOZTNsZa/L7A0WSpRpGglS1Z7N1DBb8+Io4F1NJyeln1k1sgPkkW837iNyAga0zPfAJkxUyhabIDyFyqRFbXiGMY+BOcQqu1XlGMOA3D4nAc6uOucHyCRWhrp8f4UZC0PUE7UWMNrsylrY36HTghjLt7WaEgD4kidrR8jdEOfVrXpcbbE9LdcjgLMtCMvROzm5umAfVJTKwXIZUkWAWugKKFhMTVd7/1lOR06PSdyiBPM4XILGKtb7pcYH1BEbUjr2NualqgEKKU44ZGkHwab5v6L7b0v+qK4sj+gH5ZnCuVWWVdTHjoeOjBJbvazwooEdEEzz2IOw/RjTCbnED4//tefO75QE
 jyGDejxL
 vQVD0dW8jRopZqDpcyJFwG0z1VMEFK8zMKHNaoyEYEaQeOJsQyRKdEbjMUxRecZqXn8DFNaCJ4hCQ/lGfCcwL+8uTQgqUuvXaNGoGHKKK3wEcR10fzwp945OJ2wT7vXhGETkqol5jGYFNnHl8bpX8ITM6PXrJG3kmCTSRg8j+Oumm503yEYGhh2iVhN/CGUcj6lMnHofKCySCUa3ihaWNK//uRgnMsLcvNffRn/oIkO5v0NUuXld2ZzLbTTeUoET0AYIZc5Wi9PXLuUgwr7tDqHKHiiTFR/sPLuqxYueS+k2u4Ubb4jrsvL+Fk/PfWF7bpfytcKnEC4TV8Q4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 00:22, Brendan Jackman wrote:
> Commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> non-blocking allocations accesses reserves") renamed ALLOC_HARDER to
> ALLOC_NON_BLOCK because the former is "a vague description".
> 
> However, vagueness is accurate here, this is a vague flag. It is not set
> for __GFP_NOMEMALLOC. It doesn't really mean "allocate without blocking"
> but rather "allow dipping into atomic reserves, _because_ of the need
> not to block".
> 
> A later commit will need an alloc flag that really means "don't block
> here", so go back to the flag's old name and update the commentary
> to try and give it a slightly clearer meaning.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

I wonder if we need to do this, and instead we could repurpose
ALLOC_NON_BLOCK directly. AFAIU it's about removing the side-effect of
gfp_allowed_mask in the next patch. But what would happen if we did that
using the existing ALLOC_NON_BLOCK (or maybe just renamed to ALLOC_NOBLOCK?).

- in __zone_watermark_ok(), ALLOC_NON_BLOCK could now be *not* set in
situations where previously it was set due to gfp_allowed_mask masking out
__GFP_DIRECT_RECLAIM. But it only has an effect on top of __GFP_HIGH (thus
ALLOC_MIN_RESERVE... which seems contradicting the ALLOC_NON_BLOCK
description comment btw). Also __GFP_DIRECT_RECLAIM is only masked out by
GFP_BOOT_MASK when all memory is free, so it's kinda moot?

- in rmqueue_buddy() we allow access to highatomic reserves since
281dd25c1a018. That commit describes GFP_ATOMIC so we could have been
checking ALLOC_MIN_RESERVE. But we can also leave this alone because it
doesn't actually matter when GFP_BOOT_MASK is set, as above.

> ---
>  mm/page_alloc.c | 8 ++++----
>  mm/page_alloc.h | 9 +++++----
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 30ba61c20209c..fb522a09f2e60 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3431,7 +3431,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			 * reserves as failing now is worse than failing a
>  			 * high-order atomic allocation in the future.
>  			 */
> -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
> +			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
>  				page = __rmqueue_smallest(zone, order, ft_high);
>  
>  			if (!page) {
> @@ -3811,7 +3811,7 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
>  			 * or (GFP_KERNEL & ~__GFP_DIRECT_RECLAIM) do not get
>  			 * access to the min reserve.
>  			 */
> -			if (alloc_flags & ALLOC_NON_BLOCK)
> +			if (alloc_flags & ALLOC_HARDER)
>  				min -= min / 4;
>  		}
>  
> @@ -4733,7 +4733,7 @@ alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
>  	if (gfp_mask & __GFP_NOMEMALLOC)
>  		return 0;
>  
> -	alloc_flags |= ALLOC_NON_BLOCK;
> +	alloc_flags |= ALLOC_HARDER;
>  
>  	if (order > 0 && (gfp_mask & __GFP_HIGH))
>  		alloc_flags |= ALLOC_HIGHATOMIC;
> @@ -4750,7 +4750,7 @@ alloc_flags_slowpath(gfp_t gfp_mask, unsigned int order)
>  	 * The caller may dip into page reserves a bit more if the caller
>  	 * cannot run direct reclaim, or if the caller has realtime scheduling
>  	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
> -	 * set both ALLOC_NON_BLOCK and ALLOC_MIN_RESERVE(__GFP_HIGH).
> +	 * set both ALLOC_HARDER and ALLOC_MIN_RESERVE(__GFP_HIGH).
>  	 */
>  	if (gfp_mask & __GFP_HIGH)
>  		alloc_flags |= ALLOC_MIN_RESERVE;
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index fac8e5304bb03..2307b173a459f 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -32,9 +32,10 @@
>  #define ALLOC_OOM		ALLOC_NO_WATERMARKS
>  #endif
>  
> -#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
> -				       * to 25% of the min watermark or
> -				       * 62.5% if __GFP_HIGH is set.
> +#define ALLOC_HARDER		 0x10 /* Because the caller cannot block,
> +				       * allow access to 25% of the min
> +				       * watermark or 62.5% if __GFP_HIGH is
> +				       * set.
>  				       */
>  #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
>  				       * of the min watermark.
> @@ -76,7 +77,7 @@
>  #endif
>  
>  /* Flags that allow allocations below the min watermark. */
> -#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> +#define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
>  
>  /*
>   * Structure for holding the mostly immutable allocation parameters passed
> 


