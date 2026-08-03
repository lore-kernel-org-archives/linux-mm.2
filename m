Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEFA5C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3ADB6B00B5; Mon,  3 Aug 2026 09:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4B16B00B6; Mon,  3 Aug 2026 09:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3606B00B7; Mon,  3 Aug 2026 09:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 973F46B00B5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:19:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E1B98062C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:44:36 +0000 (UTC)
X-FDA: 85059473352.15.7191C64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7AB8220003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:44:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xmg9Y3uN;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785750274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOhYheecQUnFVrVpCgpvGP/7g3mj4mAGi+KSC8/ce0M=;
	b=NoDiBjdCt30knf7c6ttPQqiQWfLkhNzX64VfbrmYD/KeneviPXFQmlmAo245jlW29mNNr0
	rfxBr6J44231xpBvZntalp6bbMMatuIf60a+A/833o3hXNuajK2BSOhfv4osdMrx0erQ2w
	J+rwazFlEjTXZu64hZkTMNDj9d9GmwI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785750274;
	b=qfVs/wEF5vrMOVFA9I+s+m4CrR82PINdJ+qIPrBDaLKtqfEDvyr5aBNybrqqC4IxSpOlTc
	kbInhWSG7J1sp9PboCShp359+4gHzQC6hrbxezrNtyrZ3iL8g3+F5WZzVvg3xW96ee2X+e
	i5F8fx+0HAfk/kfYL2CS/WXMmeH/KlE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xmg9Y3uN;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED68A60A61;
	Mon,  3 Aug 2026 09:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEBB1F000E9;
	Mon,  3 Aug 2026 09:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785750273;
	bh=KOhYheecQUnFVrVpCgpvGP/7g3mj4mAGi+KSC8/ce0M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Xmg9Y3uNj++DUWdqH+KDhGc7xKen49AIQbhB3ronbkhIiJp+Bs/hZoOiESkCNpNyq
	 Gtk5MNuz2HtlX5AtMFSCRi+I0h9qN/w2YKel/+db1aVtrzKiO1slVxPfp36R76zLxn
	 h20v/mUzP91kAiXt6wFZUGoKf83EwIT2GX3+iu1afxMwV1BZpbYG4/CtJ/s1luBM0Y
	 cV4sw8c3v7zUlAQX4bALNahjITbS0Vr3/JlBLenrXC0wLa5vsEJ2P7ZT801KSaiZek
	 /ihkTExc92CeJhOEXKZTnG9gJX7BDH59ig1L+FDhpy2K0kPdNWTkrpHpQ6lWb1u1cy
	 hhzMsTTaB6IAg==
Message-ID: <60bd3790-f350-44b4-8066-9e6a7285efff@kernel.org>
Date: Mon, 3 Aug 2026 11:44:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 24/26] mm/page_alloc: always direct compact for
 unmapped allocs
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
 <20260726-page_alloc-unmapped-v3-24-6f5729aa9832@google.com>
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
In-Reply-To: <20260726-page_alloc-unmapped-v3-24-6f5729aa9832@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: df8s8ex6914kimi1rrqw1zrrt6dqg3ci
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7AB8220003
X-HE-Tag: 1785750274-239485
X-HE-Meta: U2FsdGVkX19QG/cmtSBBSkW+II1cYg2YIliPI1Ei2MHJWl1lKyx1npjRuYJ9dN52c5QBShFLLfcZgvbdIaOgD2ngDgrmZnnONZTyf1/yWOpjJi6QhPEXNbRzdumQGGmaz1d3suyfAz2AqC9Bkb+BsTNkytobHS30Nl5lK53nM1F08jbiNd2DapKZfiqv6T3ewjexaMulaAXptQLHARiIwgjWuWqeyE8ZwX+aIxANFQh1z9h9I1OA4ALVrP4o5NUXV19NNJO8rZGPk9oKDxNAF3fguaugZBCjcQhbRIGUE1FpyFf4JcwB3JVqCNnLIqy34c7uHbvIhb2W1ruZyw8uXbZLC6wCxB2cIcJRnijYlzuWDwHcR1yvpFcJ/tpABmKWf/q3wt116LGuYOf9qtL4rokRA/K6gogLfowTEbXdY+ktWiqFe05oSPUMdFxbQH6zgqE5mVJdKb0+9MN8MXJAGpNb/HFj0HyfQeYeVSIu2NbqlGJ6zNrOA+VTuPG8tMC0/2WmhrNFJCmpRYxQepQ9mv9xmki9JOslkXF4W3bSA6SXUcMQqu7znbdGCTFrg7FQmmfg5gEoVctzIC9FEzMr1oO231oDZxG1Ok2ufwljfIaqC3KFLliuYPN7p05jds1ug1f99Nk3cKyLzyQSGMlsGsrxheI9gq3pTJJWVcSeg4qfQAUsDEf0boclhEjwRRKagcLN3OGyhnD2oxpev4tD7DCPyFQKcrVRXwYyoB0naDUResIrctqroRy+d3Oa/nSEShlYdQ2ofwk9Nd7ibWOZwHXe6IpK39pk7U5t+UG/CS0sSv0HICvS0bdJPFC8+3+VBrFqC08WMGSrRaXjVoAgJYhsRbg3Ra54MSOAgCN6BHtdQRWDMVuKmjInI9s5fwC3lhiN9zhI+k1JfIRrg//iUdme2QRFSuaJDGVLwFfOWgA8igJJEyNAsk5M302TCZDDc3JDF97tTF23vdOW7UC
 2h1EyDaA
 dgRy2DflUes8Qtf+DAKG9b5fbGr/EdskNUwmRIyvBNn3nk5J3cBIzlBkZPIPIFpz18hB3Rqb5pqQX0UTck9PYxynk7bQRdV56fCJBFuwhpBCZRJI7tYXgNzdJaEnCxtTItDGDWroYRhUYfeXl9/AbyShnTpF4CzOe4SUtQ5NEtTxawlLBOr0l8eN3SE/iUk7JEryL2kmNVy2AZ9gfi24Y2tw7IQKObJEkPV68GTgSASjKI6gM5WT6AUjUN75BQR9ICCb8Z+0H7XDry3LtGP8tyEQfwfHONguIQa5BDTW+EbWChT7XbgIOojKkvu22OhXLczY/Zc/D3qz8fAyCqToa0OlEbewfCt/ztzWB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 00:22, Brendan Jackman wrote:
> This is the minimal solution for ensuring that compaction can service
> unmapped allocations. Without this, it's possible for compaction to just
> check watermarks and see plenty of free pages, without being aware of
> the direct map state, and thereby cause an ALLOC_UNMAPPED allocation to
> fail unnecessarily.
> 
> Instead, with this change, promote compact_order to pageblock order for
> unmapped allocations, much like defrag_mode. Then, check specifically in
> compaction for the presence of wholly mapped blocks that can be unmapped
> once direct compact is complete.
> 
> This all takes advantage of a major simplification: since unmapped
> blocks are currently always unmovable, this can be asymmetric. There is
> never a need to promote a !ALLOC_UNMAPPED allocation to compacting at
> pageblock_order, because compaction would be trying to generate a
> currently-unmapped block to map; that will always fail because it would
> require migrating unmapped pages, which is not supported at the moment.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nit:

> ---
>  mm/compaction.c | 22 ++++++++++++++++++----
>  mm/page_alloc.c |  9 +++++++++
>  2 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index ed12d2fc6fad3..fe1aaf293bbce 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2531,12 +2531,25 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
>  static enum compact_result
>  compaction_suit_allocation_order(struct zone *zone, unsigned int order,
>  				 int highest_zoneidx, unsigned int alloc_flags,
> -				 bool async, bool kcompactd)
> +				 bool unmapped, bool async, bool kcompactd)

Instead of the new bool parameter, can we check alloc_flags for ALLOC_UNMAPPED?

>  {
>  	unsigned long free_pages;
>  	unsigned long watermark;
>  
> -	if (kcompactd && defrag_mode)
> +	/*
> +	 * When trying to generate an unmapped block, check the counter for
> +	 * direct-mapped blocks specifically, since we'll need to unmap the
> +	 * whole block to service the allocation.
> +	 *
> +	 * Why doesn't this apply to the other way around too? (Mightn't we need
> +	 * to _map_ a whole block, to service a !ALLOC_UNMAPPED allocation?) No,
> +	 * because of a likely-temporary simplification: currently, unmapped
> +	 * blocks never contain movable pages, so compaction isn't going to free
> +	 * up one of those.
> +	 */
> +	if (unmapped)
> +		free_pages = zone_page_state(zone, NR_FREE_PAGES_BLOCKS_MAPPED);
> +	else if (kcompactd && defrag_mode)
>  		free_pages = zone_free_pages_blocks(zone);
>  	else
>  		free_pages = zone_page_state(zone, NR_FREE_PAGES);
> @@ -2599,6 +2612,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
>  		ret = compaction_suit_allocation_order(cc->zone, cc->order,
>  						       cc->highest_zoneidx,
>  						       cc->alloc_flags,
> +						       freetype_unmapped(cc->freetype),
>  						       cc->mode == MIGRATE_ASYNC,
>  						       !cc->direct_compaction);
>  		if (ret != COMPACT_CONTINUE)
> @@ -3084,7 +3098,7 @@ static bool kcompactd_node_suitable(pg_data_t *pgdat)
>  		ret = compaction_suit_allocation_order(zone,
>  				pgdat->kcompactd_max_order,
>  				highest_zoneidx, alloc_flags,
> -				false, true);
> +				false, false, true);
>  		if (ret == COMPACT_CONTINUE)
>  			return true;
>  	}
> @@ -3127,7 +3141,7 @@ static void kcompactd_do_work(pg_data_t *pgdat)
>  
>  		ret = compaction_suit_allocation_order(zone,
>  				cc.order, zoneid, cc.alloc_flags,
> -				false, true);
> +				false, false, true);
>  		if (ret != COMPACT_CONTINUE)
>  			continue;
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d12ce84662ab7..5f1dea7eee15b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -827,6 +827,9 @@ compaction_capture(struct capture_control *capc, struct page *page,
>  	    capc_mt != MIGRATE_MOVABLE)
>  		return false;
>  
> +	if (freetype_flags(freetype) != freetype_flags(capc->freetype))
> +		return false;
> +
>  	if (migratetype != capc_mt)
>  		trace_mm_page_alloc_extfrag(page, capc->order, order,
>  					    capc_mt, migratetype);
> @@ -4523,6 +4526,12 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  	if ((alloc_flags & ALLOC_NOFRAGMENT) &&
>  	    free_to_migratetype(ac->freetype) != MIGRATE_MOVABLE)
>  		compact_order = max(order, pageblock_order);
> +	/*
> +	 * Unmapped allocations benefit from compaction even at order 0, because the
> +	 * allocator will actually grab a whole block.
> +	 */
> +	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED)
> +		compact_order = max(order, pageblock_order);
>  
>  	if (!compact_order)
>  		return NULL;
> 


