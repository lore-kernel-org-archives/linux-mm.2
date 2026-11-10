Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4A7606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WN1k3Ow4
Received: by kanga.kvack.org (Postfix)
	id 5113B6B05D3; Tue, 10 Nov 2026 06:49:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2136B05D4; Tue, 10 Nov 2026 06:49:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7DE6B05D5; Tue, 10 Nov 2026 06:49:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0106B05D3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:49:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B00614058B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:49:09 +0000 (UTC)
X-FDA: 85419038418.07.9A0108B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AFDB2C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:49:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WN1k3Ow4;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794311347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Veaud87PgGav6Dm/ZehzoxEyJEm7aqdfBG/9vXiIT6c=;
	b=BDtsFybrJEymYZVb89/kVYrDTj7R29M/5G2TSFuna7ugaoZRYh3EZWw0zBwbtu0kBpafwa
	p2fHfyERMbMIO7nYCQ7cXkt+aovNqEp8kei1uWuRbrhy4XeMNox4E7MMF1BFR1vLqLMKIk
	EbrdppIwfFpphJrRuGN+ONdyCMLPZTo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794311347;
	b=iim3bE2vWpBH012/6eOa+EeuomYKGwEkRFRwj/J6cgeUZ7DylTvof0iU+PYECSFwQDsHjj
	gwDf3qClfagwrH19gZOD8hbu2ffEkrhPvJj6jxmCK+OwZrOO/vZ3BWpgG1rB+zHtwhhlH8
	bq+j1FeMuiJk50lPl5NMrLTFm8a/L0g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WN1k3Ow4;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CB26633D9;
	Tue, 10 Nov 2026 11:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241F71F008A1;
	Tue, 10 Nov 2026 11:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311346;
	bh=Veaud87PgGav6Dm/ZehzoxEyJEm7aqdfBG/9vXiIT6c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WN1k3Ow4AgxbFM2D2OwqJzAYmAlXtQ8GKPlaUUSURQqgBWJvSfPUCNvN5+SSuO8kG
	 Vx36OHk/YxMwZ/ElTFwBJhh2sPp56OMWCyvrf25JamYDNWAOn67Xo9BQHabP8yNPL0
	 aV3oXT33W6Rqf2pcqQoFpFggA8YVFjc79MdP7E9du2AoHOOfyxIH7GkS2jtjNe+lgO
	 2slQq3bWPJXWn+3P0s0AnecHI6F6i6OX0G6aetGr3DKN3t2WJTboGGrTDYG3fCy03Q
	 R2qNjvPOcWwV4Gbw6lIp7B2d9CdzkfgbkPMVhh1g0H/1y9Iv9pe29gPEsee9iHNHfc
	 XOYtsGYTUqv7g==
Message-ID: <07a8ffc3-1f71-4e41-aa83-424e267ee48f@kernel.org>
Date: Tue, 10 Nov 2026 12:48:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/rmap: fix migration entries being treated as
 partial unmaps
To: Joanne Koong <joannelkoong@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Zi Yan <ziy@nvidia.com>,
 SJ Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>
References: <20261109220958.2071687-1-joannelkoong@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261109220958.2071687-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 9rrthb97ihn8e1yj9r1ge1wc9sgcfric
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: AFDB2C0004
X-Rspam-User: 
X-HE-Tag: 1794311347-205927
X-HE-Meta: U2FsdGVkX1/ZZiyF9h5avKoy/poG4PIG0A1evOqBbd3b1oDp3Y/w+RD+c6Uk5NR7VqX8vxga7fsETALGjmhMV877iINkwYAFgmVyKh6qFnzzYO2kbMZoByw6soa8Nyj4Fzuk6W43I2B83HgtO7a1fG1cMtiGatYkfwzTT7LMSUpZZyZcJgwbg/qZVbuxQ2TIB6w/U4hkKefofCkMqyCSGxUk0K5U0ds8i3rpwg/3mDgfef/TcYiO2Lo8uESzHrVgSDz779TnT1v431no1opkRKpJi/C5sKo5O9dXIpw6CDURICDO6EQhjhJbJcDowKEet7WhTLqvmBJIAd4FZD0grld1Br5sVH5tZXdv8Za/8bApH0edAq9jYpbEQIt6/xo9bXO/jbMXoG3JVmu5JebJUzUIDn83Y+5y8cMlm/cYNREfP+1ooBXK9oFJ2Anwb7TAn0MMRW8AU1yZZ4h3t8PBTkZFiMVFKKP8ln8ddFWbENu4cLfvs7WOn6/CedyPpF69BzL0XMvLcIqizexhq2J65n39xyq/JMYU9JaydwiPifz1iZqYaYvQUgDSqJDx9vxu6iDEhUjqv3qmwekSg3ETzpYjHcp9pOzZJ6ucN2gQ+1H6GvpYiK5A32tgeKqxf3VS5ZuxHxDvtVEjewMgSXc9ElJXldkNfMOzmjk0lJX2nGbBkafFEJeFw6iOULd0wwefEXVAbEfYA7zbfeE5c6XKHa3RjsgcR35Lv+r3AUOREWVjU7MrpqUdp459Yx5aYDdEDZXiX8CG0qS+XS8omCVWtFdzuJ9BQOQ2EikUhuSsbqbCWb990pnmNZqo8CzyHx9jH4knKsHhAp3o2Y5Zv0nn9wrR2t3cBj5D5yxpPwitnPiHZTkBkgMxTSSROdAk+Fi0G3T//jyekJnTYLJ5VurZitwU3kOu6FhUFWZYvUQq5waGkNvIeJNAWa9E9nGPN1q0OUsW+Sj8EYXSNJsTtJB
 KvvEcQjp
 myT++rH7eGCsk6iUpBms3RKVEZq7vnCXECUbT2PDUR30pzMUyvMTeXSqd8Siqc2ar2/A6umTSBqg0HOskhqU0iM2jc0Je2Jqfe8qnteqweZYhmTFb8cVkLR+STGOqg5/ZzecgPPRzDojkCBefswJM6pNBH+BPEA4SpvINoTHLDjTG4z0No6xQK+gP3f7+hyRFO7b5njhmJpLkJ3+b4ngp+ZxkSoI6z50Snj+FrdtHrK9KmbwoevfPiKzVnTVo/Q5g5HtkFx4JMVnDo27ouKlOdgSCWl413ZxkyUUkPc4ZZD63lqvj4TlLFJgbLLj0bMpF5sA5fGDMZRsZxceimR0w1+PeFDUeCCGJjlQhkWDHoepfb5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 23:09, Joanne Koong wrote:
> When try_to_migrate_one() unmaps a large anonymous folio that is mapped by
> PTEs, it replaces the PTEs with migration entries one at a time and drops
> the rmap for each page with folio_remove_rmap_pte(). After the first PTE
> is replaced, __folio_remove_rmap() sees a folio that is no longer fully
> mapped but still has pages mapped, and calls
> deferred_split_folio(folio, true). That marks the folio
> PG_partially_mapped, bumps split_deferred and nr_anon_partially_mapped,
> and puts it on the deferred split queue, even though nothing was actually
> unmapped. The migration entries are turned back into mappings once the
> split or migration is done.
> 
> This happens whenever a fully mapped, PTE-mapped anon large folio is
> migrated or split. Its effects:
> 
>  - Migrated folios can later be split for no reason. migrate_folio_move()
>    copies the source folio's deferred split state to the destination, but
>    reads it after the unmap, when PG_partially_mapped has already been
>    wrongly set. So a fully mapped mTHP ends up queued as partially mapped
>    after migration, and the shrinker can later split it without checking
>    whether it is underused.
> 
>  - split_deferred is overcounted. Every such split increments it, so the
>    stat counts folios that were never partially mapped.
> 
>  - A folio whose split fails can later be split for no reason. If the
>    split fails at folio_ref_freeze(), the folio is remapped but stays on
>    the deferred split queue marked partially mapped. The deferred split
>    shrinker then splits it without checking whether it is underused,
>    breaking up a folio that is fully mapped and possibly fully in use.

This is a similar problem I raised in last year's LSF/MM:

https://share.daveh.de/s/bQsDpD7xigJ6wD8/download?path=&files=LSF_MM%2726_+Deferred_folio_splitting.pdf

"
2. THPs erroneously detected as partially-mapped
 * Failing migration/split/eviction after stepwise unmap
 * Remapping the folio will not fix this up
"

The news here is that we now copy the state to the new folio and can
consequently split the new folio.


> 
> Mappings replaced by migration entries are not really unmapped, so don't
> queue the folio for deferred split when try_to_migrate_one() installs a
> migration entry. Pass a flag down to __folio_remove_rmap() and have
> try_to_migrate_one() clear it for those PTEs only. PTEs that it replaces
> with a hwpoison entry or discards because they are unused are really
> unmapped and keep the current behaviour, as do all other callers.
> 
> One consequence is that if part of the folio is really unmapped while the
> migration entries are in place, zapping the migration entries does not go
> through the rmap, so the folio is not marked partially mapped afterwards.
> For a split this does not matter, as the folio is split anyway. For a
> migrated folio it means the destination is not queued until a later unmap
> notices it, which seems preferable to queueing every migrated folio.
> 
> Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
> Fixes: a2e0c0668a34 ("mm: migrate: requeue destination folio on deferred split queue")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/sashiko-outbox-198104@kernel.org/
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
> This bug was found by Sashiko in its review of the mTHP shrinker series
> (https://lore.kernel.org/linux-mm/sashiko-outbox-198104@kernel.org/). The
> migration / rmap code is still new to me. This patch is a fix with the help of
> AI, so I'd appreciate a careful look from people who know this code better.

Don't we have the same problem for try_to_unmap() in some remaining cases?

See below.

> 
> This was tested in an x86 QEMU guest with 64K mTHP. Splitting 64 fully mapped
> folios through the split_huge_pages debugfs file no longer increases
> split_deferred (was +64), and migrating 64 to another node no longer leaves
> nr_anon_partially_mapped up (was +64). split_huge_page_test, migration, and
> khugepaged selftests pass.
> 
>  mm/rmap.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index fa34e1ccbd8f..e5d17481c0c0 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1799,7 +1799,7 @@ void folio_add_file_rmap_pud(struct folio *folio, struct page *page,
>  
>  static __always_inline void __folio_remove_rmap(struct folio *folio,
>  		struct page *page, int nr_pages, struct vm_area_struct *vma,
> -		enum pgtable_level level)
> +		enum pgtable_level level, bool may_defer_split)
>  {
>  	atomic_t *mapped = &folio->_nr_pages_mapped;
>  	int last = 0, nr = 0, nr_pmdmapped = 0;
> @@ -1888,8 +1888,13 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
>  	 *
>  	 * Device private folios do not support deferred splitting and
>  	 * shrinker based scanning of the folios to free.
> +	 *
> +	 * Skip this if the caller is only replacing the mappings with
> +	 * migration entries. The folio is not really becoming partially
> +	 * mapped. Once the split or migration finishes, every migration
> +	 * entry becomes a mapping again.
>  	 */
> -	if (partially_mapped && folio_test_anon(folio) &&
> +	if (may_defer_split && partially_mapped && folio_test_anon(folio) &&
>  	    !folio_test_partially_mapped(folio) &&
>  	    !folio_is_device_private(folio))
>  		deferred_split_folio(folio, true);
> @@ -1921,7 +1926,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
>  void folio_remove_rmap_ptes(struct folio *folio, struct page *page,
>  		int nr_pages, struct vm_area_struct *vma)
>  {
> -	__folio_remove_rmap(folio, page, nr_pages, vma, PGTABLE_LEVEL_PTE);
> +	__folio_remove_rmap(folio, page, nr_pages, vma, PGTABLE_LEVEL_PTE, true);
>  }
>  
>  /**
> @@ -1938,7 +1943,8 @@ void folio_remove_rmap_pmd(struct folio *folio, struct page *page,
>  		struct vm_area_struct *vma)
>  {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	__folio_remove_rmap(folio, page, HPAGE_PMD_NR, vma, PGTABLE_LEVEL_PMD);
> +	__folio_remove_rmap(folio, page, HPAGE_PMD_NR, vma, PGTABLE_LEVEL_PMD,
> +			    true);
>  #else
>  	WARN_ON_ONCE(true);
>  #endif
> @@ -1959,7 +1965,8 @@ void folio_remove_rmap_pud(struct folio *folio, struct page *page,
>  {
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
>  	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> -	__folio_remove_rmap(folio, page, HPAGE_PUD_NR, vma, PGTABLE_LEVEL_PUD);
> +	__folio_remove_rmap(folio, page, HPAGE_PUD_NR, vma, PGTABLE_LEVEL_PUD,
> +			    true);
>  #else
>  	WARN_ON_ONCE(true);
>  #endif
> @@ -2516,6 +2523,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  	mmu_notifier_invalidate_range_start(&range);
>  
>  	while (page_vma_mapped_walk(&pvmw)) {
> +		bool may_defer_split = true;
> +
>  		/* PMD-mapped THP migration entry */
>  		if (!pvmw.pte) {
>  			__maybe_unused unsigned long pfn;
> @@ -2772,12 +2781,20 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  			 * No need to invalidate here it will synchronize on
>  			 * against the special swap migration pte.
>  			 */
> +
> +			/*
> +			 * The folio only looks partially unmapped while this PTE
> +			 * holds a migration entry, which is later turned back
> +			 * into a mapping. Don't queue it for deferred split.
> +			 */
> +			may_defer_split = false;
>  		}
>  
>  		if (unlikely(folio_test_hugetlb(folio)))
>  			hugetlb_remove_rmap(folio);
>  		else
> -			folio_remove_rmap_pte(folio, subpage, vma);
> +			__folio_remove_rmap(folio, subpage, 1, vma,
> +					    PGTABLE_LEVEL_PTE, may_defer_split);
We will not add such magical boolean parameters. I have a patch to just pass the
rmap flags for a different purpose.

But the whole thing is rather ugly ...


You should probably look at

commit 354dffd29575cdf13154e8fb787322354aa9efc4
Author: Barry Song <baohua@kernel.org>
Date:   Fri Feb 14 22:30:14 2025 +1300

    mm: support batched unmap for lazyfree large folios during reclamation

    Currently, the PTEs and rmap of a large folio are removed one at a time.
    This is not only slow but also causes the large folio to be unnecessarily
    added to deferred_split, which can lead to races between the
    deferred_split shrinker callback and memory reclamation.  This patch
    releases all PTEs and rmap entries in a batch.  Currently, it only handles
    lazyfree large folios.

Batching resolves the problem in the common case. For the remaining parts, we
should likely just check in the deferred split handler whether actually
partially mapped to then clear the flag if not.

-- 
Cheers,

David

