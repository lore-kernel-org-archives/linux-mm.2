Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F2E606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 21:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fd3tB4uC
Received: by kanga.kvack.org (Postfix)
	id 9357D6B00A9; Fri, 23 Oct 2026 17:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7586B0AEA; Fri, 23 Oct 2026 17:16:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FC726B0BF3; Fri, 23 Oct 2026 17:16:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5934E6B00A9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:16:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E52D81C277D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:16:37 +0000 (UTC)
X-FDA: 85355150034.04.54CF2D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3211840006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:16:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fd3tB4uC;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792790196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36nMoEV+qY4+3B7iVAc/58NBcD9zvoRthSyLFKDtn4o=;
	b=F5FUhIOQS0nQLT7EE9ivWQuSimEXgErK4bZPKUbuiBYspKwpBnskKKwr/YLL6AmmES73GP
	LF62P/bwdn/rT1zTAZH8vKABEXo55sOq3T4l8yiB78/xS7CS52kuQRM+OLy1W9flsr3QEs
	mTfnq2PbQz6EBqZGVwNenS6QuaPjUCI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fd3tB4uC;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792790196;
	b=Fc8vvklpJC6CAAjwP74f51b8UfKhqHT1SQw1oBcUKhb/Kfofrf+4/u3rMZgmiWEYfmuIdb
	a7nPi3l/UhhJN+APD4B/oFH/sgw9sRwpopJnFmcl3YHigUBLHFL6WK0TUzAuFWqsAUjzhQ
	sh+3SKzrTUX8QPeZ9AB1xk0mUtNS6xQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2532D41978;
	Fri, 23 Oct 2026 21:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300251F01825;
	Fri, 23 Oct 2026 21:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792790195;
	bh=36nMoEV+qY4+3B7iVAc/58NBcD9zvoRthSyLFKDtn4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fd3tB4uCO60tET4XImwHa4+MaXLEDTZZCaJGy2bgMSl6JOEFQ4p926Ok3uvaLHIpm
	 1u+IdHQt3isnyBlrO+1WKhiOq7jJ0nOXAGPE/i7UO3IqlV4SlwRj5m6dFnmQQ9tmBF
	 m4m2uav2TjWbJ7YVv/w6GaStCvxIfkM7FyQpMvbUekWyjkxX5yp2pbcFiWEFlgxoky
	 vkLYATFiZsJA8XsyTT2tM8OI13v3xvJS+QfoEeP0tfeMr9fe8C1IWzm/9GfNxcJeMk
	 y3M7oB6K9iURQvaVe8NQoHaoT38rZdHjHAS9uMiuQBQARm8dytnjJjFyhMLDBUGOye
	 eNBtZozugJQSg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: alex@ghiti.fr
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	baoquan.he@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	nphamcs@gmail.com,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	yosry@kernel.org,
	youngjun.park@lge.com
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
Date: Sat, 24 Oct 2026 05:16:29 +0800
Message-Id: <20261023211629.16227-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261007153915.53429-1-alex@ghiti.fr>
References: <20261007153915.53429-1-alex@ghiti.fr>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3211840006
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: s7buiackyq7josqowojxwaodd9q9t4z5
X-HE-Tag: 1792790196-55674
X-HE-Meta: U2FsdGVkX1/kN3ysr5YEMt0g/qEclL7sk7E4erXIuwd7jbxjnFJPjjPx5x/3HrKDZecIbap6FEbOm2+qlfPlMeBj1zbrXk+ITxcofNURl/cNDh7PXnDhYAAIoqYfwu/B3K61vDs4dQRLWOEDB8UshlccjE0/cfBYGNbFeqEei97YRT3eJHRrXfFQdD4+s99hTdIUzOCbj2fc+EolnYvRF4VE/vdhZFfZvmnpVU0U9zbzXUUlbc6hYWSYbfkBTeETkNvCHuIj46OqjG6DaFfg9bw9Dzf8/ivZ5YKaakIPzq8XhDyhxljycpI1OEXNl0+D23xiPYp1glAP94Og8V85PEpDx37bsZohXzb4+gumMFa0tNlaonqrWm/x5z+AlIsnmoB9BysGlt8JLRhUlLjU+CmGhhrbVaUCpkuT/hLDvz8/RYN3ZY5RaS7F/5LHI8eZAsDUuRVTAcG27U3GfHazSQ11zKoKuwz3ah68LdLjTjf5T9PRD0N1S9xywEJem+qVyB89IVFsyMNPAVlEQxjapm0wlUFGwbPJj2NfVZIAW/nSjuhxCwdj5x+KzJmrAOKrlnacXYB/MDKH+Ap2aEA12IeLTR8hNYgSrYYbW2ixcKCO1EoMAndJcV/LltxVytAQBkwCmz38GY2zDnnbS53vuHNYjJlS0EmHtGz3zvYBQ8THlO75Es5rcUUc2JXDyhRs472jwiX/d2VPDh4jlPMIX6ODDZfRa/4iqX2CaTdq6NZc21uXcz+VIurgj32ZzP3NuiEF71g6LXI0pjIC1OT2Vy1EuQn0PRElsEGM53mqryi/1bSgDHYg4fhAtuOklqDKf1M+bOOxE5856t+SIgYUiqkJa2I8mr3uLV/qFEn8PmaoXx6a7oieV69gLfOmnjqycQUchvJiS35o4PAQs5Ph8CVeQ28a7dlBm1JMO2rmD+pCrFgEGOu9BSz7/eftCWSJBRei4JB2+WvLTP4sXE2
 3962bGY8
 UV9WAYG5d5LG2FaLXiadO6xBc5xIaJVyFcKtBajPCwpRTiBNAiHHTX8YvJqZunKj8tCG/DyAT3D3T4zkKCslDBnzdwEHEBed/qhcZ5sgL4yk1xtyJHcz9AWpticfPVzKTxdzC5iUeKtDXhWuo7GTWzNxbfHE0hVU9PReH4/09trSoW4fxt2XwHUhTwgoMxDd9abcWcdpSii4N1Zue+8cDJskoODFYQn6GbiHf6OOzfqFKWjlZWIXLGdGVvqVVZ2NJSvOvs21uwweJO7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 7, 2026 at 11:39 PM Alexandre Ghiti <alex@ghiti.fr> wrote:
>
> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>
> zswap is the same kind of in-memory, synchronous backend as zram, not a
> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> swapin_readahead().
>
> Here are the results from bypassing readahead for zswap too: it was
> measured with a kernel build (make -j16) in a memcg, zswap=zstd, shrinker
> off, on Sapphire Rapids and 3 iterations.
>
>   768M memcg (sustained swap thrash):
>     metric                 mm-new    + bypass    delta
>     build time (s)          405.0       341.7    -15.6%
>     zswap-in (GB)            79.5        53.0     -33%
>     zswap-out (GB)          144.8       115.6     -20%
>     swap readahead (pages)  6.79M       0.45M     -93%
>     swap_ra hit (%)          72.1        89.9     +18pp
>
>   1G memcg (light pressure, build not memory-bound):
>     metric                 mm-new    + bypass    delta
>     build time (s)          177.7       176.0    ~same (no regression)
>     zswap-in (GB)            10.2         7.5     -26%
>     zswap-out (GB)           27.7        25.1      -9%
>     swap readahead (pages)  1.07M       0.08M     -93%
>     swap_ra hit (%)          68.6        87.2     +19pp
>
> Similar gains were observed on an AMD EPYC 7D13 host.
>
> The gain is from no longer prefetching pages that are pointless for an
> in-memory backend: readahead inflates anon residency and thrashes the
> page cache (file pages get evicted and re-read), lengthens each fault by
> synchronously (de)compressing a cluster of neighbours, and adds
> compression traffic when those extra pages are reclaimed.
>
> Bypassing swap readahead for zswap therefore makes sense.
>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---

Hi Alexandre,

One thing on my mind is that for synchronous devices, we always free
the swapcache during swap-in, thus releasing the compressed copy and
metadata as well. We could do something similar when a zswap entry
is found.

I wonder if we should do that as well. I don't have time to
investigate this further myself, but I wonder if you'd be interested
in looking into it.

    mm: free swapcache on zswap hits in do_swap_page()
    
    We already do this for zram and other synchronous devices. The same
    should apply to zswap hits. Freeing the swapcache will allow the
    compressed copy and metadata to be released earlier.
    
    Suggested-by: Barry Song (Xiaomi) <baohua@kernel.org>

diff --git a/mm/memory.c b/mm/memory.c
index 55b5a84d1016..d22c779fda93 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4711,17 +4711,18 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 					   struct folio *folio,
 					   struct vm_area_struct *vma,
 					   bool exclusive,
-					   unsigned int fault_flags)
+					   unsigned int fault_flags,
+					   bool sync_swap)
 {
 	if (!folio_test_swapcache(folio))
 		return false;
 	/*
-	 * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. Swap
+	 * Always try to free swap cache for synchronize swap entries. Swap
 	 * cache can help save some IO or memory overhead, but these devices
 	 * are fast, and meanwhile, swap cache pinning the slot deferring the
 	 * release of metadata or fragmentation is a more critical issue.
 	 */
-	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+	if (sync_swap)
 		return true;
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
@@ -4977,6 +4978,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	rmap_t rmap_flags = RMAP_NONE;
 	bool exclusive = false;
 	bool rwp_restore = false;
+	bool sync_swap = false;
 	softleaf_t entry;
 	pte_t pte;
 	vm_fault_t ret = 0;
@@ -5059,7 +5061,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		swap_update_readahead(folio, vma, vmf->address);
 	if (!folio) {
 		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices and zswap */
-		if (swap_entry_synchronous(si, entry))
+		sync_swap = swap_entry_synchronous(si, entry);
+		if (sync_swap)
 			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
 					    thp_swapin_suitable_orders(vmf) | BIT(0),
 					    vmf, NULL, 0);
@@ -5325,7 +5328,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 * Do it after mapping, so raced page faults will likely see the folio
 	 * in swap cache and wait on the folio lock.
 	 */
-	if (should_try_to_free_swap(si, folio, vma, exclusive, vmf->flags))
+	if (should_try_to_free_swap(si, folio, vma, exclusive, vmf->flags, sync_swap))
 		folio_free_swap(folio);
 
 	folio_unlock(folio);

