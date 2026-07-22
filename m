Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 798CDC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 12:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606E26B007B; Wed, 22 Jul 2026 08:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7E06B0095; Wed, 22 Jul 2026 08:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A9986B0096; Wed, 22 Jul 2026 08:18:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7DD6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:18:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96A2F1A0139
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:18:03 +0000 (UTC)
X-FDA: 85016314446.29.DF81F80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id CC3EA20006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:18:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=llzUFJes;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784722681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=quxgKTCBV0BCb8OJSz8QFDvBn14uAzUBItc9eXawEb8=;
	b=MVWqFW7dIH7CAx7ks28KJnzk79SPy7/71S2N5PfEl0z4kUNwl2Prfnq0/1/BWcIg3XciVx
	vZvGLuGaz6TrnU6OEslMFm1FhbPo3OlfDzi28Yd9U14zA1tk6e/HKEYNNNCYpHYyLNHT4C
	TSXvwffAoF+F+1CMUBtsAHnVhLWpvYc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=llzUFJes;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784722681;
	b=YNWkwiawUGh6qROyU8DZaYBthpZlz2DHoLMgNq6USQz47TGHjkUFop/C0SG5OBPlIbqYZA
	lkxKENwDJwZRDgtCEBzxF5nvvgYPD0npBFQ9MJf7jh+ZnnB5s9MxdXstQusi5C5RUsmHKZ
	nNrIVQnXZIUOaY93BtLGOP0SjRoJ+X8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1F0943EDA;
	Wed, 22 Jul 2026 12:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52A11F000E9;
	Wed, 22 Jul 2026 12:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784722680;
	bh=quxgKTCBV0BCb8OJSz8QFDvBn14uAzUBItc9eXawEb8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=llzUFJesRwmmjClmGbFEABpUrAxWeJ8td+4hi1QIL4JNVvi/XNe8d3RjuNnACVrW/
	 7hle8tPvlOSc+w1wiutgzm18ZZfTO8qvDXB65un7N68GFVCqsCsq66DfkYhq8scZfR
	 6sZDMvuJryibh2cvMZal61Dcu/s5hOtKYL2k2VN4rgYVQga6JTq4NBXkQcasPJzDVB
	 y6YmNHjBBOjH+GFOqdlOIRsaJe+blbSekhtDkT1JtR8e0hHkhM2IZ8ufMfULVN4XU6
	 vxxKuQj2Sr4CHPRvr1AyMWXny34u05KxGegwnmtP66C1iCFPpDWL2CL9Jp1MOFs1oV
	 PU9dr6VTe2bKg==
Message-ID: <15c65a4b-aa53-4218-baa4-7dbab3b9dbab@kernel.org>
Date: Wed, 22 Jul 2026 14:17:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>,
 Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-mm@kvack.org, hch@infradead.org, ritesh.list@gmail.com,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, dgc@kernel.org,
 djwong@kernel.org, brauner@kernel.org, alisaidi@amazon.com,
 blakgeof@amazon.com, abuehaze@amazon.com, dipietro.salvatore@gmail.com,
 stable@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
References: <20260710143437.12379-1-dipiets@amazon.it>
 <alEz4Chf7Ibyg-ZG@casper.infradead.org>
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
In-Reply-To: <alEz4Chf7Ibyg-ZG@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CC3EA20006
X-Stat-Signature: peenmrxdn1j5z4go4u8ky1s9xtuynqg7
X-HE-Tag: 1784722681-491140
X-HE-Meta: U2FsdGVkX18y88p/mDUUlIGqiiC3bVCF/nqKUCu9nCgD2pqwFRMMHrkbZQt/qnK94QCr0QIlwkDrpdGRpOX+FnnbdqnqzkltAE9Gqgh3R/cEK4hayWVHkZLHJF4ExPW/OQ7JECTL1l+c+wDJ2IafRd4fxhJm0SO+VHFk94lYyJ/FH9NsbmIL7DXSbx+A4inqSWBs/gAp88YKtl9XmFxvhYQyXhQvHyF3RGRy/ZSJV97c0NasLgf8t5/K+wqMHvsPJOxgj2AcfANuXuaxgHmUriOk/nWHYAnUxOpEbLxC3pKaMHjOJYAGAJ1+y+aux4db3//DPmsL4nafUZ7qVQC/aIUeWFYyln23BktRaY45L9qf/YLChZkslGw+lOBwQn8jy0LJNuaWYODV+KemeoWl0fo6qmH99CTGopk/gLvTKkQafiBEBDW9CPMPX/zXnxkwhhZLlcnCL7Ohav4/6mibqsvNBCzJcnV0kz/S0z+GELp+aRKrMUrh6Ae1L3vV8+wyEg8DYIS+qyGmSqztH6I1wGd8DDCy9SDZ0T6W/WmHO+24OzKp4uqfqJwh4sZ/TGPAmdM9ifbakakeS3AXZKpFL0Elu5wyqgRHExG/4lYEqEVXp9eEz0mcusN0tw3Q/oClVBWlXCBWJE9D428EYbnSH0+z61kSYYuXzjF4kqtMFXIp1YMGNaIHlcmRz05CEKpcetOSjs/3GWfvl351YTHezPOT0SDXVkyeO3EiwU3DV3Ep9Wbc0Klw8nys56tlS5zVBLLwF6LfBANUrMPnNDs3iQtb5Rj/ZAf9zwqPcYzFs8sF+x0CoLVYgZaDuR6x7/fIV5rSf6bCokP0Wu9MzDxoAiok64Vy1spS6a03QR9fQlUTaZAPnqy4kiYXcjzKbt70xalSZ4YMvbwzwhVeE9rqOraubJMbv30jwlA7Vy2IhC3FxFlqOWQCVRdviomO6ASL+XjStUO5wEr2eTxpqsK
 7zmhoc3z
 4HZQClrX+M1f12i1hsvk1/qFA2j5ob1Vrs9fNRwp4FkDldq9KZiRpTgIyJbITyDm+2b3hEr0xoR+kM/sQ+4cgok9yeU/aklVhaL9AO7MpLjHYiDlr6Zsnyp3U+A3yNkQrfh6V1FHl0Ae8pC6oydMam//XqJlVOSmdmEnXBMidEnlwcbHXsAvboHoDCDUsrmZhSPT6DTXC9808JyfNlWdHoS8hjHHYNwhcqHfN+YSkRV2bD7JFhwpxcNBYHkh6fhHPF70HwbMSpm1al7nKQFXheeYMHFprVKcnuvT/fAUSKI+zYwwYWBDrmrhJu69InUqczVos4FsJQR/iqZxRm1FVy0hMPaISWKjKmpGM9G/ZPhp8bJLMoCwM6PYzbcMTOiGmqd64PG4enCk47r55D4OHElXPMWxpq/CqcBF8c84dqfR9cmNw9xgsedvTXxNLfnFhQYchi3wxGaC9ebB3rTnxXn5W2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 20:03, Matthew Wilcox wrote:
> On Fri, Jul 10, 2026 at 02:34:37PM +0000, Salvatore Dipietro wrote:
>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>> introduced high-order folio allocations in the iomap buffered write
>> path.
> 
> https://lore.kernel.org/linux-mm/aeZzP6iQel-tkZOu@casper.infradead.org/
> 
> I just had a go at implementing what I thought might be the right design
> (having a folio_alloc_orders(min, max, gfp)), but that's not really what
> __filemap_get_folio_mpol() wants because it needs to integrate the actual
> adding of folios to the page cache into the retry loop.
> 
> So instead, let's try this.  The idea is that we want to try direct reclaim
> _twice_.  Once gently (ie with NORETRY specified) when we're trying to
> allocate the maximum order folio.  But now that we've tried that once,
> there's no point trying direct reclaim for other sizes, we just want to
> ask the page allocator if it can give us memory of any subsequent size.
> 
> Until we come to the minimum order.  Then we want to try exactly as hard
> as we were originally asked to try.  So revert to the original gfp flags
> and don't set the NOWARN or NORETRY flags.
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 58eb9d240643..23eecaf9b328 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1983,6 +1983,7 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  	if (!folio && (fgp_flags & FGP_CREAT)) {
>  		unsigned int min_order = mapping_min_folio_order(mapping);
>  		unsigned int order = max(min_order, FGF_GET_ORDER(fgp_flags));
> +		gfp_t alloc_gfp = gfp | __GFP_NORETRY | __GFP_NOWARN;
>  		int err;
>  		index = mapping_align_index(mapping, index);

Note here fgp_flags are checked and may alter gfp towards NOFS or NOWAIT or
add __GFP_WRITE. But alloc_gfp set above will ignore all that for >min_order
attempts, which isn't right. Probably doesn't affect Salvatore's evaluation
though.

> @@ -2004,12 +2005,11 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  			order = __ffs(index);
>  
>  		do {
> -			gfp_t alloc_gfp = gfp;
> -
>  			err = -ENOMEM;
> -			if (order > min_order)
> -				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
> +			if (order == min_order)
> +				alloc_gfp = gfp;
>  			folio = filemap_alloc_folio(alloc_gfp, order, policy);
> +			alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
>  			if (!folio)
>  				continue;
>  


