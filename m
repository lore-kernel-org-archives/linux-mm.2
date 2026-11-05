Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B919606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 03:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jmPuwpy8
Received: by kanga.kvack.org (Postfix)
	id 426556B05B0; Wed,  4 Nov 2026 22:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7206B05B1; Wed,  4 Nov 2026 22:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EDDD6B05B2; Wed,  4 Nov 2026 22:22:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2F66B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:22:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9ED01208D4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:22:41 +0000 (UTC)
X-FDA: 85399618122.05.9326CFA
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	by imf09.hostedemail.com (Postfix) with ESMTP id 86B20140007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:22:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jmPuwpy8;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793848960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UMh9s5ocnokfx+XKoSyLVmwtM+Tp0GJvRtc0t12Crg=;
	b=dNRonbhgz6Qx6JUZ2tNB2AixwtmdP4xYmvqLaL8ZWs2dF3ZgS7/zIw8mq2IC2aN/EYDNMq
	9SwwJMo7CiVarsjFgDur8v7gNa7cwujM3zO5K1Rrsjr/PV7nBy9sobA0twbVb5jNJyuQj2
	z/0IouFi9HXHOoHvlv3dHLfHYb7cv9M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793848960;
	b=MQhHPhfumM2MZ9GZBP4CQhtcPZeufQbh1NLBxFVPSFBGkrI3v6OayMtoiMofaxa5Ln3bXC
	j0idQ2gETB3qUbqMZ4zLT4syTncAdNTsAbknia1e0vJzd2t5mLDccltwQZrBY9k3Bl809+
	rVVE7tdvqX0Oaxl1RaRIKT33dUiFM+w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jmPuwpy8;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NlnsIm6KYbGZ7DOnv+gfpZHXSnV9jFfbjp/BdVMvA44=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793848957; v=1; x=1794453757;
 b=jmPuwpy8Oc7QJQOIBzuesZIf15qtvnUvlz+R2ew2rAiKS0aXgPPL9E4hcKPQL2aPsOMhP3Nn
 iyQMk1/2tGvrJpuoTzXSshEhmHBwGRV1Bd9otVyY3VpM3D56e2qrgEEMMeMLXKKfeeKA2UdyM2d
 Z92QbtrXj9p2rVtKcoGw8g0M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ce5845c80e8565fa;
	Thu, 05 Nov 2026 03:22:37 +0000
X-Mizu-Trace-ID: ce5845c80e8565fa
X-Migadu-Flow: FLOW_OUT
Message-ID: <6f0973cb-a57c-4612-9812-9c31ff620e1d@linux.dev>
Date: Thu, 5 Nov 2026 11:22:30 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev, pfalcato@suse.de,
 ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ujt3xdbfb5hf5t3on5e1f85k7p6imgmg
X-Rspamd-Queue-Id: 86B20140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793848959-874096
X-HE-Meta: U2FsdGVkX18UmugZN9tpvvDqysDL0hW4WO4XcH4gIHpPQxSqwQ5Tc8MxNDQOS1x+5L5VNB0xcaXUoBANpSkeIzHknE8mWpO8CyUw1KVD9jwnKYHNKr2TkHGbXkF9InGumfJRV+xCIoPP5tsGSFRZVVKJkQIYcD+uwYJf53yOaNsKTYbBLtAzilS0I0oVAeWYFh/UjKcdjIrC7YREGRY46pBgkX8JW9XEgsjWk0ZBqoOvnl50yH81iomzaB1JtvLv2QFkAhQel3ZPinu8p5mih58QapwdOm/ZJTvQMMpgR01dind1QwxjTew9rQ/mC+/25Kpn50s1iwvMgtjN6qwFh2J7AY1zORQ5OJYkVnHqcdcTKZcs4SBLXGKdNre7RFwzXIDqhbcDhNG1NokKFWakH+NN21e1RBwmdCvSmuM9JKEsSPj11tCwJ/Ke4zRIvJWJpQ4uyqk+jZcbE8MPqNYTqbu9vo+rzKkJBnZT9l8QId3adQV7cog/KfNYqq14bO+7vNW6tYGSqzTYrKfq3PosouBjx6MPJWlsD/9MkNhYjwELJQg5NSl05htXpQyBOnNihIL9xYE10uENuAqMfc1R5Nnit+1ufZrD7RDNMMSyWl6hYAPIz/z7e+BAHNe8BL5bAaMTUXpKpyLf/Jmj4oRKizwT/ej9foKkWtUdgA8WHabG31Gb/HWM9707hw70SaMANotiyxm1XGyOllrkPRVWWpJ7xoCZATYuS1SEgYOdzstlt0svvADxJg4Lt4tEbbGX6tI9TD7ppRTdQQETxhhDOZgkfux8AmOd3o1Crmstzshc3fgnwBrojxvfxZLq/Ioj81I/M8zVnTCzX6bGJN5mZdhxTMoeUy+uUg4fjUT0m1UCLCGPAEn2FaBCtdD7OWDIu8dcdwQjvZtI97FIWfBxTWEW5HrlAApq+O4WUF+OgJDsVY5vub9jYoT+b1HnmYphrAq4IPQvdj7d/mdSVWA
 XHn1hAR5
 xLJcn9iSd9wXJWQyMUBZpwJopuoow48etOV/yZD9rNWI4foHZ3VanoYlrd3xMlzfODBXVzZ9IiyAq8hyrrKpEvXop2pCxHM/qh+YCveebpwQRufRYdMaOmug2FwPqkC7BGJfi7n3zgjzeDztN9vs7zHLTS5Rfs5pUoDSSUX70idVVYdmRY4cPkLjnXGRi5PSykqSflD7C6vIen7XYpOySSE9GCQsMUU9RPAtf6NhVez2VBrtOr1U7ZpGtGst+PMBSNCDJC2vkjkDNg2tQcerQ1eYTdiKE1P5PBhsWCQhf3C/m6CNt0FeeCvm8iZK6DJxlub1l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/5/26 10:56 AM, Baolin Wang wrote:
> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
> with concurrent page table reclamation via zap_empty_pte_table().
> 
> page_vma_mapped_walk() is used by many functions including try_to_unmap(),
> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
> and try_to_migrate(), the other callers do not perform post-walk accounting
> checks, so the race has no observable impact on them.
> 
> For migration, the race can cause unnecessary retries. For reclaim via
> try_to_unmap(), the race can cause failure to reclaim a folio that is in
> fact already unmapped (as shown below), which may lead to unexpected OOM
> or increased refaults.
> 
> CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
> --------------------------------    --------------------------------
> folio_lock(F)
> try_to_unmap(F, TTU_SYNC)
>                                      zap_pte_range(full PMD range)
>                                        spin_lock(ptl)
>                                        clear PTEs
>                                        zap_empty_pte_table()
>                                          spin_trylock(pml)
>                                          pmd_clear()
>                                          spin_unlock(pml)
> 
>    page_vma_mapped_walk()
>      observe !pmd_present(pmde)
>      nr_pages < HPAGE_PMD_NR
>      skip synchronization
>      return false
> 
> try_to_unmap() returns
> folio_mapped(F) == true
> nr_unmap_fail += folio_nr_pages(F)
>                                      tlb_flush_mmu_tlbonly()
>                                      tlb_flush_rmaps()
>                                        remove F's rmaps
>                                      spin_unlock(ptl)
> 
> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
> has already moved the PMD clear operation (via zap_empty_pte_table()) to
> after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs to
> use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
> issues on weakly ordered CPUs.
> 
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
> Cc: stable@vger.kernel.org
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   mm/page_vma_mapped.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index e6b6170c2f4f..8797467b6f0c 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>   			spin_unlock(pvmw->ptl);
>   			pvmw->ptl = NULL;
>   		} else if (!pmd_present(pmde)) {
> -			if ((pvmw->flags & PVMW_SYNC) &&
> -			    thp_vma_suitable_order(vma, pvmw->address,
> -						   PMD_ORDER) &&
> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
> +			if (pvmw->flags & PVMW_SYNC)
>   				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>   
>   			goto next_pmd;

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi




