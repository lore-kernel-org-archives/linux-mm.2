Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CCC606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 09:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WfuzGXD9
Received: by kanga.kvack.org (Postfix)
	id 4B3886B0459; Tue, 20 Oct 2026 05:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464656B045A; Tue, 20 Oct 2026 05:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1696B045B; Tue, 20 Oct 2026 05:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB2C6B0459
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:05:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9BD3EC08DD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:05:51 +0000 (UTC)
X-FDA: 85342422102.19.9E80B43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0D66D1C0004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:05:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WfuzGXD9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792487150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDrKkV/s4DciKEFvrB0xcBPka0pdP+GIzVxIpseur/Y=;
	b=UqoVSKpBowQoToTz1MEGqI0JIA+2SM/QZY7nZCyQow8ITt3+ecCsLEOiZrYbfzYg/CXIVs
	Y8iFQUjPWXytmhDMmj6tpJielf3Soin4NcWlZ0Mvq+Pki53mljYs+plvFSAm21rpFwg8pB
	7M8j1Xmuo8HVVZ3KhEG81vsTz45rpnY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WfuzGXD9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792487150;
	b=lln486PuH2Fw1t+4iLrCou0JhCSEy1gTwXVm6YYpCLSy0Th4E7dlgNm1cAG2X6vNXDTV3m
	o8oDwEN7k9FD4+7ECOsnK7aUMm2jkWacaQsqCTVlt7nm1tfkMTf3Zr1j7GAjBwPCwki7Ii
	EDFyWH40BgBGq9pVU+ybiofao26W05Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78EDB601F9;
	Tue, 20 Oct 2026 09:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5BB1F000C4;
	Tue, 20 Oct 2026 09:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792487149;
	bh=iDrKkV/s4DciKEFvrB0xcBPka0pdP+GIzVxIpseur/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WfuzGXD9qCbdGbBWEhBueD+0MetrF69PROOmshHF/raYsz6zIHf5JpcjgO8BHDPXn
	 VWwrwgig9XfGC0Vx4V14SzRRnkXAduNZ3s8JNixWBEVfWJJM6rz0tMgtl5ntHIPp4w
	 4o++VPQ+bRGrSbtAp8H2o7O9RIXXFdfZViYh0MEDLBdJHY+8ZcXOe9/rZf/RGOtDwF
	 1J2EZsV7oggk1QFSqZj93x+6755aKzOLzD6qTbF+alRFO7kgN9ExX+Wwscz1/m1m/a
	 FrCeYP9Pb5XMFBOvWtcIJ3359dBkCJCU//ZtpPL1EyGAipZXG/aeeGtZyXpIa04/SJ
	 U2vejXCy+WQhQ==
Date: Tue, 20 Oct 2026 10:05:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Liam R. Howlett (Google)" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/testing/shared: catch a failed posix_memalign()
Message-ID: <atcuincrH5DdYB-n@gremlin>
References: <20261020033128.1934349-1-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020033128.1934349-1-liam@infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0D66D1C0004
X-Stat-Signature: jgh77izuy6nm96hxffnhxtfb9ryri9ys
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792487149-67328
X-HE-Meta: U2FsdGVkX18rmx76xtxESbb6zIOp7nkepz+m5a1QnpFcPIpmW6l3OR778KTkqlfqVhglPTIsAMod9vO6dDtLmpc6lKibF7PQ1Hm5TG/FD3hIWxStSqbfqd9HNanqRUlufBw0bqhWThaBCsuBYQFmJO5k9TMpzmEMpOFpGFCaNytqERhdz3Tdq5oY4T1IRS5l4kJTzlGVUPSz0QKOW0FpxVch3X7pwEFg51qQmjR+HeYB/YNz9VQOmLOH7HhkbN3lRBWUpe7ahKtZpxLZZTEkAbuC4SAWHQCixiqjluyyxaNEDHza0A5cNzxuHuy8az5xCyEnrz4FI6AID4c0tBQF4VO5+ixp3q6GgEtj44o5dKVxqjUn9k94lr0+XSWyBEa7zDB3p8rw99DaKCkVwdTx8eKodA+KHkj7mUCkHKoDGdk0SQD4NLLC7lA2homl6NMyJ/2LOTiZBVJDL3PAw/daLZftgL0OVhnjs5YOJj8gJ1F57PoBwAx/O+Qz8AQEJctdSwix+S6339q9VsZ41aSs8Dtf+0KMLmIoC7W5NGgNbVQuTOk8AMJUriXCMJVkMEHQxA2rOQ2m530SmlABeEFhfKdp6TluggXXI/6JJCuOPNUoU8aW9GXcpjTTRc8EgPydh3fb2RcHB8C0Qti37MgSmKXA+xDspcoVJRu79RLynCU6mHrNM2ZFkCPJEOAED3h0mt3go4i29AaqB6GJiAjvR29c8hhW0pdIvkaBnJjrB617gvzwZGp60hIdG4YGiNsWU6takNfVdhDnVh9/+eYx5c2ZgBq7F4vDPomYpmHYyrJxD4vqnDfK+04MJXIlGQKq9LDWL0EEVEBQ1MT6+v7uPrIYLppEgNW6rKoNp03okJxaFN11mwvh30uqmwwg6+PLDKbwXRkF7hEgKpyt87yc5mx93ajgdzH9upl/xnawNF3UaTA36fB4k1YRs7oja/pbSv/d5ICIEhYILBjVGGr
 2b0BMR1b
 mcub19+/Y3r+y/Zm9lbr/S9FxW2JkVeaDxXcnSTkbh/H0AgbumBkJk7sgTzbivvyaSMVmm6871KPsXudyuN4METEzo6xCU8Rmg3qfQdmakU+oRjXZbohhPrZVfD7RTgOFsiM4uiaW/TQPuX1u9ysDGzQZTS6awBNUgpz/bqa5GoJn97A1Xz88jHJO+v0hzCWEuHcTdM5Rci+0Nveswy/fvGnlT+edDGPG0n7Tf/MCPWwx2ZAKMhm18a1+SXjbEl5HdZQC0eLXZ9GAT61EHOlyj070DGIFqqPvi7AuEs6Rx6Y4TiYv8Z6Qakic6shgxgO3KxLg5UIRYd5WCx3X+nFJqGPDJ3HHhwLoHZWNPvaQtu2EJ7FFEwhCa37o5bg3GrsNIDMi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 11:31:28PM -0400, Liam R. Howlett (Google) wrote:
> posix_memalign() returns zero or a positive error number and never sets
> errno, so the checks for a negative return in kmem_cache_alloc_lru() and
> kmem_cache_alloc_bulk() is not possible.  A failed aligned allocation
> carries on with the pointer unset, into the constructor or the memset().
>
> Test for any non-zero return.
>
> Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/shared/linux.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
> index e0a0693df08f5..a37d2f86d3254 100644
> --- a/tools/testing/shared/linux.c
> +++ b/tools/testing/shared/linux.c
> @@ -83,7 +83,7 @@ void *kmem_cache_alloc_lru(struct kmem_cache *cachep, struct list_lru *lru,
>  	} else {
>  		pthread_mutex_unlock(&cachep->lock);
>  		if (cachep->align) {
> -			if (posix_memalign(&p, cachep->align, cachep->size) < 0)
> +			if (posix_memalign(&p, cachep->align, cachep->size))
>  				return NULL;
>  		} else {
>  			p = malloc(cachep->size);
> @@ -191,7 +191,7 @@ bool kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
>
>  			if (cachep->align) {
>  				if (posix_memalign(&p[i], cachep->align,
> -					       cachep->size) < 0)
> +					       cachep->size))
>  					break;
>  			} else {
>  				p[i] = malloc(cachep->size);
> --
> 2.47.3
>

--
Cheers, Lorenzo

