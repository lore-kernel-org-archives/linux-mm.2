Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22355CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 08:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2877A6B0005; Wed, 27 May 2026 04:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239176B008A; Wed, 27 May 2026 04:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1283B6B008C; Wed, 27 May 2026 04:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 005286B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:06:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92CCA120513
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:06:20 +0000 (UTC)
X-FDA: 84812467320.18.9F0BBEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D3CB0120008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:06:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hYPbaeHa;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779869178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjcScadNLsm8B0Y2dlIK5Y/U4/3PKeOfLAFi96a9uPM=;
	b=EETkHBa1ZLe//f6m+F6y0CzIODx1VCCS3vYkCNVSkKWY4FXWnoCd5rCQ8WoDDVAycGVHW4
	tw0LHZBQUmSPMfbuO2LILpor0Xn/tYc3iyopxa9o2rDlcnw0RBUZ7ifEvggCGJNSAWOq5m
	qSr+76eCSBxYVIVobop3VJGzF0JSlPA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hYPbaeHa;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779869178; a=rsa-sha256;
	cv=none;
	b=nUbhqi5qP8nwbCdcaKCwEOIh4MuzVtkdmphTl8QySsFPHwKQJYLby5LGaZbXukIVhn/A2N
	zLq8AhBfKPXwOGtw0HbOAYOrocMw8XM9Ai+m2u13ZcqkvxYOM7iNetiiwP3KqZ9Y4avG8c
	6FHNYR6VxfmpPpo9NBqEFK8TnSyS7OY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 20184600CB;
	Wed, 27 May 2026 08:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FB01F000E9;
	Wed, 27 May 2026 08:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779869177;
	bh=sjcScadNLsm8B0Y2dlIK5Y/U4/3PKeOfLAFi96a9uPM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hYPbaeHaJO2A3w+tgdZxfJ9EFPIUp8WLKx3Z73CD1knxGldp8Rjyr9x8OH+155xeZ
	 wQ6/hLsLViXBiGGaYdxyiPfr2YmS/8dTfILjbGJdXuZiQGx96tx/0dsahjjP8KP+z0
	 zw6e/0bncfIFF0acCLEZl6KJ+E1PPNhxMuwkeQ+xKKi/jk+4XlDHp0TcqqHwvy/6FL
	 RvbPp7luBOHEixReRWkh8oibRxkwSvsazaAg/IS7n53iYHBIicyGaafchlWnnOqJnL
	 UCgzhtb95S2dMNkB5YgKgZJ7eiAUHWHbbr04zwpg2Q8Ped1bGIORxnv8sdGmus9Qsn
	 SSYSU0o9bL21w==
Message-ID: <8c5bf213-399b-4fa1-835a-36d906061e88@kernel.org>
Date: Wed, 27 May 2026 10:06:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/slub: use empty sheaf helpers for oversized sheaves
Content-Language: en-US
To: hu.shengming@zte.com.cn, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260526232429176aHA6oZjTYdhXcZVHc2ZQ-@zte.com.cn>
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
In-Reply-To: <20260526232429176aHA6oZjTYdhXcZVHc2ZQ-@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3CB0120008
X-Stat-Signature: apqzc9f6d4id3396fiubqpyngww1qj9n
X-HE-Tag: 1779869178-326798
X-HE-Meta: U2FsdGVkX1+sL3J0C5j/SZTgfRDTnV+FKM3wDisaEpjkymzkeeDAKoshDhpma2Dx85IGyMrdscc9rqKzotVZUB2S+ToBl44pCaajH05GwohohS+1CLvBjcsOEO6ZNYkF6Bsan1eZk9hFf2GWc9wfYFn52oN1RI7QvdhezltwbL4PU/y+Y2argNhSyLvryAr5DsI3ch8TOUn5SkLgUO1JWsvt5v8msPK1Z+kDhK1JmjMLopZ4F3W43/imoECq/4kKE2gMHhmowZXdbZV6wxFVCucZLr8df+KUO4521uO2I6bfejpRaLXhqJ1qNiuAgu1aza7T6GeEN+6TZHiAVrkHyM1kbE0yLrbbUPf5dLu8JB1nozjFUbGSbibl9hkwgAivWoQ5lX6FhDID5M1E1671Xmo+XVfHD4xyc9t9EPmOIBmWejlinhK06Jlg341e4B1TE8+qMN1mgiUnTgsR1wDmx9NkJgutvjHEi3S66ONocVgLasF0Y+0xX55yzwsX0nECbsvEjjvcgL4rQpv6pl1TpugEuigA9qUK+K7053iaywFgXtM7n+BbwttW9ncx/yMxV/eU3N9qmg9brhZ4Xd0eeL3/Y1p9XPhnpC+adbrC9VDYgKXZm/GUAwzNylVVjdODCekyplvIwRSHd7AdpkMBLnWCiuNXHAmwltDmg0qO4OrhEFm+bexK6Am7cH86rSL4pLKgaUwKIRSU31btiAIDZhCgNK3uug+3MpXmYCEQe/Epc4FK0DKakfoBRoyoCwyRteDcQfYw9Quc1Y9VNmNfbuA8C8K03MEnfxPk4YgtdnNB2KAodnrv/ReRz1bJeNn9oIwIaG8R++Pyp5dpdoxr2onvTw0KTQuwJqa50HSo5TvHJYK6HdRszLmxGxULZYUNjhWDpiPozgtDh0nvwZWe+PPj7IBSPSs+xhV61L5H39aNSkdEe9nTAZjOm5qvsP9J2s39HYM5VVe68x+ctK/
 16cQzp7Q
 NwLFLZnzO+qMsI1ZYcCjs6YSONoP2gqy6i0SqJcyjAh5PSMizTxo+x/WmxwxevAGweJX+HZ2PFAa6AmLcsnLM397nK5rQjSV1zGx+Yh4VUkzGSMaKQUsVyyPudlxCJXQQTIcl39LitzpwjQ0NSowni+duwuWOBdZkCU4m8eEEFvw7VIFGsP6pAc4jCNeyuiJZcMflbtwm5bvIE/h08WfEKUpgu0i1n44mBVCnxAiJU56rx5QcTeJFsf8EVQimIFhk/SYp2HSrokQotmTR721Qy8lnIdC/r7KJDQ48WCqSVASBXPCMmQEdmdWNvYpE0gl5GfqfRJALHmxHzkNUuegxg4amTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 17:24, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Oversized prefilled sheaves are allocated separately, but after they are
> flushed they are empty sheaves as well. Release them through
> free_empty_sheaf() instead of calling kfree() directly.
> 
> Use __alloc_empty_sheaf() for oversized prefilled sheaves as well, so
> that they are allocated through the same helper as regular empty sheaves
> and released through the matching helper.
> 
> Since oversized sheaves are now allocated and freed through the empty
> sheaf helpers, SHEAF_ALLOC and SHEAF_FREE also account for oversized
> sheaves. Update the stat comments accordingly.
> 
> This keeps the oversized and pfmemalloc prefill paths consistent after
> flushing.
> 
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>

Hmm, __alloc_empty_sheaf() does "gfp &= ~OBJCGS_CLEAR_MASK" which includes
__GFP_NOFAIL. A caller of kmem_cache_prefill_sheaf() with __GFP_NOFAIL might
not expect failure. The __GFP_NO_OBJ_EXT handling is also not necessary for
prefilled sheaves.

Well maybe all the gfp handling could be simply moved to
alloc_empty_sheaf()? The other caller of __alloc_empty_sheaf() is
bootstrap_cache_sheaves() and I think it doesn't need it either.

> ---
> Changes in v2:
> - Rework the change as suggested by Harry.
> - Teach __alloc_empty_sheaf() to initialize capacity and pfmemalloc.
> - Allocate oversized prefilled sheaves through __alloc_empty_sheaf().
> - Free flushed oversized and pfmemalloc sheaves through free_empty_sheaf().
> - Link to v1: https://lore.kernel.org/all/20260521195015105Y4zvKHj0TfPZEujixy9Vo@zte.com.cn/
> 
> Changes in v3:
> - Address Hao's comments:
> - Drop the redundant `pfmemalloc` initialization in
>   __alloc_empty_sheaf().
> - Keep initializing `capacity` and `pfmemalloc` in the normal-sized
>   prefill path, since the sheaf may be reused rather than freshly
>   allocated.
> - Link to v2: https://lore.kernel.org/all/20260522145900248m-nBcy07_SCDk2ATDWfmg@zte.com.cn/
> 
> Changes in v4:
> - Address comments from Hao and Harry:
> - Keep capacity initialization in the oversized prefill path.
> - Update SHEAF_ALLOC and SHEAF_FREE comments to mention oversized sheaves.
> - Restore the oversized sheaf pfmemalloc comment.
> - Link to v3: https://lore.kernel.org/all/20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn/
> 
> ---
>  mm/slub.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 04692a6f9128..08812de7a8b5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -362,8 +362,8 @@ enum stat_item {
>  	CMPXCHG_DOUBLE_FAIL,	/* Failures of slab freelist update */
>  	SHEAF_FLUSH,		/* Objects flushed from a sheaf */
>  	SHEAF_REFILL,		/* Objects refilled to a sheaf */
> -	SHEAF_ALLOC,		/* Allocation of an empty sheaf */
> -	SHEAF_FREE,		/* Freeing of an empty sheaf */
> +	SHEAF_ALLOC,		/* Allocation of an empty sheaf including oversized ones */
> +	SHEAF_FREE,		/* Freeing of an empty sheaf including oversized ones */
>  	BARN_GET,		/* Got full sheaf from barn */
>  	BARN_GET_FAIL,		/* Failed to get full sheaf from barn */
>  	BARN_PUT,		/* Put full sheaf to barn */
> @@ -5015,12 +5015,11 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
> 
>  	if (unlikely(size > s->sheaf_capacity)) {
> 
> -		sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
> +		sheaf = __alloc_empty_sheaf(s, gfp, size);
>  		if (!sheaf)
>  			return NULL;
> 
>  		stat(s, SHEAF_PREFILL_OVERSIZE);
> -		sheaf->cache = s;
>  		sheaf->capacity = size;
> 
>  		/*
> @@ -5029,7 +5028,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
>  		 */
>  		if (!__kmem_cache_alloc_bulk(s, gfp, size,
>  					     &sheaf->objects[0])) {
> -			kfree(sheaf);
> +			free_empty_sheaf(s, sheaf);
>  			return NULL;
>  		}
> 
> @@ -5097,7 +5096,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
>  	if (unlikely((sheaf->capacity != s->sheaf_capacity)
>  		     || sheaf->pfmemalloc)) {
>  		sheaf_flush_unused(s, sheaf);
> -		kfree(sheaf);
> +		free_empty_sheaf(s, sheaf);
>  		return;
>  	}
> 


