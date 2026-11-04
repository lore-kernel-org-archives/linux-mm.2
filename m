Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33326606D819
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=f0ip4PZz
Received: by kanga.kvack.org (Postfix)
	id 3432C6B05B9; Wed,  4 Nov 2026 14:11:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31AB16B05BA; Wed,  4 Nov 2026 14:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 258886B05BB; Wed,  4 Nov 2026 14:11:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF45F6B05B9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:11:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7FE874082F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:11:57 +0000 (UTC)
X-FDA: 85398381474.12.99B2681
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6995340005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:11:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=f0ip4PZz;
	spf=pass (imf07.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQCDgLQog4AfZ803aJDiF06q9I2NpsVkPXVUjCXTu2c=;
	b=eckgHe6Wa6Ww3E65qabfsYAm6fCUqi9I1dwj2HzO4kZikYqf8v6rSqtG2c2/sneAMOpknl
	czhf7SZDn4KCqr9papxutlwStRDBi5yE6NbcV4veBzHKAdD/1SwLG7xCn9d048raLZ0Gqa
	jlBX7U7lCKRJKj9Kq/hudXeyM2SZYD0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=f0ip4PZz;
	spf=pass (imf07.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819516;
	b=6NrWQy8NiuhDwTLrG8qnm7L2s9t1jZaYdtBZM33vvzOweGerGrSGlRjs9igvVhfTTv2gT7
	0BKvzy9sksw7hi+U4EMnNM5TGudMXgJss1633c8tzSiNlqv3G1YOySugFPQ4VJgT7x7v06
	fHIPd48i5XR0Akh0HbiXo7Yy9pwzz64=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	From:Reply-To; bh=kQCDgLQog4AfZ803aJDiF06q9I2NpsVkPXVUjCXTu2c=; t=1793819515;
	x=2109179515; b=f0ip4PZzY1jDljzHaXcRYIIqvPC5QCp2YEPVc/W1E0WMEg0qddDIBGJBP4gn+
	TiojGWFUE4aiGXhJEezqKetv9K+n4Pj4rHbhW+m8NuB29YxoxB1s2tokgvcU9tbtfVdhxRBOtAuMZ
	WMN4Hvt1WnCGqUrhyNOT5/h4SVgdxryB75aP7Ourp/D+n+EXRGqBbVws0c5P8wEPam7V/kZUplEyh
	N/skpp0lV6A0ACHPqzlMJIuCPadW16AdnZh+1TboOwu5cWyCsGNVWglAmA5/Gzmykv1nwU7gnd6ox
	B9v5a43P/Pq6Pvm7iXABfUdui6QSvgIJJWgb4t4XKaEorRby2A==;
Received: from 179-125-72-1-dinamico.pombonet.net.br ([179.125.72.1] helo=quatroqueijos.cascardo.eti.br)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xOgOV-002Zhk-QV; Wed, 04 Nov 2026 20:11:36 +0100
Date: Wed, 4 Nov 2026 16:11:24 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, hannes@cmpxchg.org, jackmanb@google.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, willy@infradead.org, ziy@nvidia.com,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Dmitry Ilvokhin <d@ilvokhin.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH v6] mm/page_alloc: avoid direct reclaim and compaction
 for costly __GFP_NORETRY allocations
Message-ID: <auuDXDglZ-Z1LZhA@quatroqueijos.cascardo.eti.br>
References: <20261001082152.2879289-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001082152.2879289-1-dipiets@amazon.it>
X-Stat-Signature: pmskc6ri9hyacu7gpe1e9ikjthtsud95
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6995340005
X-HE-Tag: 1793819515-611190
X-HE-Meta: U2FsdGVkX1+CfsoQ+zKyBba/p8SpMRprGe3GnZhg1+Xr9DSa33uiIUsirNxkGDU3vAJJApF/qQwmQbv3JZGiXi1qJuThlLHrKx1QRUpEleiEt+FZyVI8mA6pIHXLqUc5WSBOVeKkrSHyMJbQrLQw4sh3HHnUAMPIyO+r5rlkDYfWrZ5yYmFtBeYT6RnnqvBVGXr8e4horw5LDY2aw5JbYkqLedrBzoSoXZtYPmGKszFEEnAm+piHj9SY2m0fW6Mibau8hmkNOR8R9JDCTS5fSgJdXnDKSH6PtNJPcIDgvJ6V0t9xOLzIPwsuG7t2wG+7BdW1pyaQ+xKF7qjqlViDlJtke3s7DFRvD5kkDVK6HppThi7Q+PUoKm8M4MDldKetQmhBZQP7myWTj2BLJJnN5LNoIzMMPnAo0cVjUPRkweNt4glGGLu2uF3KEevy0s/ojWKRb/7KPvG0xTaeG2Z2qRMlBjAoInw/cx/grZVFrYVK+TityaehYBcCn4uIGM1vk+czDOpDAuPSakx7mQBeDFBc+wbEgJL/8kIRHN4BUOgAEdk8IiDkh0NaVW5FdsgjPCnyR/D18w2o0a1tWf7KjpfJKxq9wYaqxZMQ4PXReJcDKUm6BufHfBiZveDsDTNuIsDhwYc+fIh0DRMOVSpIt8nl6qT6jxw2iTudFu7gugxzLvtgrHEejkz9AzG0H4IPd+fPIt8okhgwVqkIjE/A6YcSJZ4qyRdcKZNtFauBcYstY2jHQXQwgIwBNN3EXNxEizamLcet48YOaxsximyEDO8O3rRMQAMpPn3KG4yYVK0xFrxZ9vxQ2uh/uKx4zs0NLC3fO0Hit3fA0nsAxiRGX4SwoqjG7jtdjf0R1CmRqiFXiS948D+CSIynRyrCR/eZ2kfCKRD/UPSDTl8iH9ArocuPjgAsKAoUGCHb3QsFGWkkfbV2m+o5Q8QCCyhubZtP0FaKYAGcPhcPh2NSvst
 5RqxKtKi
 GdEGuaqkQ3NQWsqmeuhfU+LdvNss77jC1uiOytQXDmcMNnA0QVZ0u6kgMaBfd3EEKX/mGl8+fyOnkhH4au+GnTMxQX7qSblgnpDHi7l+9NpRzr6y6sF2jRJzypCbah+o08C+d40ONRcChGOHzeCJyfrSRxbdS+f/ZiXfph41ul5vLTcw1ALUxQO+1nmDAL9DxEW/LFeA+fBsrAZSvmmiVMf1Tm+OjypStWdAoAissgxblTxnrQCTGkNVXVvr3dcT4nPii1swxVPrmybZdwothd4DGNH0toN4rLmn5Bl6S55k+6qLDYGhx6+NPjYbJLaurQZImeVZ6GwUIrm5IJzxsmiuHnB/yF3FGGegqD1IVUhCABHvfnjx6X1POOldRfUBy50XVqbuc/zaXM21t/EWnvsZ3HDbzocmE4M7V/BY1ikXxY7l1BpAXPH5KXeniL36NpDpLaSk6VaAgZVZ33c5+v3jJz0Sm89przrGcphBFpT2fmsE2NAvl+ManyICcQRjYk668k6gzqaO0knRal4OagJ1+WqWdVqBNN+1TwqDFABm2CBILRWHFV7L74DfA43oz+IBvCdHtNS1z4X9GxSeBEsEl20LIBD/IM2d1cXbVv9vQSRmfqMks9g0QiknJOzlHTi4rI9MeyZrRSkup6/nA1Emy3iFB0ZVCZ/1nUWWO/uhyWrKtON3Rbc2MdBUbnvy6rqLbvEdMSW2UH7qeiJm8V+5xWrRfAYwIHz8ROn4nl9gp6lcqWiwiCDysSymfeuaZYgjgENVpeE9Fq9l6Br8ijW8hTVEGp+vCbQLD2y8JwErbYCOA19kG/H3u/bQ4v5wQnbWvPspEmBLGMF7aSCNYim/aJqgR10Ir9VNU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 01, 2026 at 08:21:51AM +0000, Salvatore Dipietro wrote:
> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct reclaim, direct
> compaction and drain_all_pages(), causing a 0.38x throughput drop on
> PostgreSQL pgbench (simple-update) with 1024 clients on a 96-vCPU arm64
> system.
> 
> The root issue is that direct reclaim and direct compaction are too
> expensive for hot allocation paths that have fallbacks to smaller
> allocations.  __filemap_get_folio_mpol() already marks higher-order
> allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the
> caller can handle failure.  However, the page allocator still enters the
> full blocking slowpath for costly orders with __GFP_NORETRY, which is
> unnecessarily aggressive when the caller will simply retry at a lower
> order.
> 
> For costly-order allocations with __GFP_NORETRY, clear
> __GFP_DIRECT_RECLAIM at the very start of the slowpath, before
> can_direct_reclaim, can_compact and the nofail checks are evaluated.
> This makes the entire slowpath treat the request as non-blocking: no
> direct reclaim, no direct compaction and no drain_all_pages() IPI
> across every CPU.  Reclaim and compaction move to the background
> instead: kswapd is still woken for reclaim, and it wakes kcompactd for
> defragmentation.  The system keeps its long-term health while the
> latency-critical direct allocation path no longer stalls.
> 
> Allocations that also request __GFP_THISNODE are exempted.  That flag
> pairing identifies the local-node-first THP attempt issued by
> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> form transparent huge pages.
> 
> Clearing __GFP_DIRECT_RECLAIM makes these allocations reach the
> !can_direct_reclaim bailout, which since commit 4c0ed883e051
> ("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") drops
> ALLOC_NOFRAGMENT and retries instead of failing when defrag_mode is on.
> With vm.defrag_mode=1 a __GFP_NORETRY allocation could therefore succeed
> by fragmenting another migratetype's pageblock.  That is the wrong trade
> for a caller that has already communicated it can handle failure and has
> a cheap lower-order fallback, so exclude __GFP_NORETRY from the
> relaxation.  The exclusion is not restricted to costly orders: any
> __GFP_NORETRY caller has said it can cope with failure, so failing is
> preferable to fragmenting for all of them.
> 
> Test environment:
>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>              12x 1TB IO2 32000 IOPS RAID0 XFS
>   OS:        AL2023
>   Kernel:    v7.3-rc1
>   Database:  PostgreSQL 18.4
>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
> 
> Results (average of 3 runs, TPS):
> 
>   Config                                       Avg TPS   % vs baseline
>   v7.3-rc1 baseline (vm.defrag_mode=0)          58,602               -
>   v7.3-rc1 + this patch (vm.defrag_mode=0)     157,246         +168.3%
>   v7.3-rc1 baseline (vm.defrag_mode=1)         109,012               -
>   v7.3-rc1 + this patch (vm.defrag_mode=1)     157,778          +44.7%
> 
> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
> Link: https://lore.kernel.org/all/20260911142102.2294202-1-dipiets@amazon.it/T/#u [v5]
> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> Cc: stable@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <dgc@kernel.org>
> Cc: Ritesh Harjani <ritesh.list@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Dmitry Ilvokhin <d@ilvokhin.com>
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
> ---
>  mm/page_alloc.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..64d09964ca77 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4784,10 +4784,10 @@ static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
>  {
> -	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
> -	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
> -	bool nofail = gfp_mask & __GFP_NOFAIL;
>  	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
> +	bool can_direct_reclaim;
> +	bool can_compact;
> +	bool nofail;
>  	struct page *page = NULL;
>  	unsigned int alloc_flags;
>  	unsigned long did_some_progress;
> @@ -4802,6 +4802,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	bool can_retry_reserves = true;
>  	unsigned long alloc_start_time = jiffies;
>  
> +	/*
> +	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
> +	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
> +	 */
> +	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
> +	    !(gfp_mask & __GFP_THISNODE))
> +		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
> +
> +	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
> +	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
> +	nofail = gfp_mask & __GFP_NOFAIL;
> +
>  	if (unlikely(nofail)) {
>  		/*
>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,

This would trigger a warning if __GFP_NOFAIL and __GFP_NORETRY were ever
used together, though that does not make sense and I haven't found a case
where it is used in practice.

Aside from either warning for the specific case of these flags being used
together or adding a comment right here to that effect, I don't think any
other change is needed, though.

Another comment about the general approach: TTM pool page allocator does
use __GFP_NORETRY and __GFP_DIRECT_RECLAIM for high orders and when we
previously suggested to drop __GFP_DIRECT_RECLAIM to avoid compaction, it
was frowned upon. In the end, a lot of other changes were made and for the
relevant cases, this does not seem to change its current behavior, amongst
other things, because it uses __GFP_THISNODE.

I did run some TTM GTT allocations with some fragmentation workload and I
haven't seen much change in the latency for these high order allocations,
so:

Tested-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

> @@ -4918,8 +4930,11 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  		 * Reclaim/compaction cannot run, so defrag_mode's strategy
>  		 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
>  		 * fallbacks rather than failing the allocation outright.
> +		 * Not for __GFP_NORETRY: those have a cheap lower order
> +		 * fallback, so failing beats fragmenting.
>  		 */
>  		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
> +		    !(gfp_mask & __GFP_NORETRY) &&
>  		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
>  			alloc_flags &= ~ALLOC_NOFRAGMENT;
>  			goto retry;
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> -- 
> 2.50.1
> 
> 
> 
> 
> AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico
> 
> 
> 

