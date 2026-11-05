Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83BB606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=R8+KcAAw
Received: by kanga.kvack.org (Postfix)
	id C4CB06B05C8; Wed,  4 Nov 2026 23:54:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFDB46B05C9; Wed,  4 Nov 2026 23:54:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B149F6B05CA; Wed,  4 Nov 2026 23:54:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2036B05C8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:54:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F23C31208EC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:54:16 +0000 (UTC)
X-FDA: 85399848912.18.D57BD0E
Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 59C00A0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:54:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R8+KcAAw;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOnxtD5kQgW2tF7PVrffOT/lerqKVdwMhcbBwPAH/FM=;
	b=OF3OmLSnYZV+No9Z7xJCPCBUj6veDknKCWzV3KJN476GBT5qZ/FV2NKm7tEAV+XFohMqiE
	BQmGwSOqx3PQNMZ5HOA4HRuAY5kHblP8uFsmal0AFbgiQQHmpS/wM73Aokd4ghunreWB1T
	uDPEbidYiZFIbmHmUJodISt+5LxGBTE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854455;
	b=SgH5kevRkIrWalxR/vLkTQyjS0Z4d6potvIMGBhrR1HpUT8rn4KpoFBl20CwjLGwK3d/Ez
	f5jWiqktz7fn0Ro6m/heXo2+HT3jaEEBsfWIeKX9huahMDW+gkkgY6yJDay4EHfH2hp/7P
	HgihiMhrW2SuCVHmEhGePrgkXXPCWbI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R8+KcAAw;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qIbdiMjLr9Y0SUefhfkdE51Knh5aRfQ/kBIeoszyPGg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793854452; v=1; x=1794459252;
 b=R8+KcAAwP5th3uxXwZF0lIDf5ASxqNS9DWJPnfcXG0mVIzDVJyDNOzlkeiRYDx7qxjDcFf9K
 /Ko7fmQstorud3tguEysoSZ2htTJ+IeZMRmSfmx9JBGDfUo3xxYWjopCwmZqiMtGccOcV4IfTo2
 0MDpnF9TRoQsBPnAp+htccyE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f63fd72cc0f28980;
	Thu, 05 Nov 2026 04:54:11 +0000
X-Mizu-Trace-ID: f63fd72cc0f28980
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	qi.zheng@linux.dev,
	pfalcato@suse.de,
	ayushr@modal.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio sizes
Date: Thu,  5 Nov 2026 12:54:06 +0800
Message-ID: <20261105045406.39871-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: bunqainxb4kftis8xcnwk6y9dy8cpwtk
X-Rspamd-Queue-Id: 59C00A0005
X-Rspam-User: 
X-HE-Tag: 1793854453-180815
X-HE-Meta: U2FsdGVkX18a2S3ILabUJtbpfCX8wrtIx3TXj6KdBIMtXW1IJrXW5DePrvNN+9Yv0VuzifXJH9oDOw5uw+jJ43/ce/i7CgGDj+b/yOgirOHEpuiRBL6jO+EZMiFbOLx+OxzCrkZBr7MSaZb80oVoec9FcOcyT+ZcYiB0VZu2Gl5+oOtLCJBWgp6B9RaixYjASgEFz4dZ1bbcSDBAlLRnn5JAfa/W/2K4RnNNfJgAmHewCAynDA52dFwjGKDDL0Q9ys0ZoDcg/azKzdCbDy64AraRmb2iaNAzt1PX84hdFfkWWomHXDQjHOhFxgTRo5WJWUFbEYCO+lS0VYvVsMaK7yqH7SxtDaujIJIkYyia0kW9J6mD7nwCWXXfYsOjt/qNWAGUaOE0HOKWxz4JqdJOLmXJJiveqHn+XiMKFN+dlqLeyU7lTKeSG74/+WuT5AXphOIkBZ4Tipe81BlA+A2vzkzGCwCoiUWON0iZXyZFOHtUXTOzs/kWxCcWDHiO9AiszhCaMMLDk53YIpO8kZ/mJ8uFgnvTXs3xili7VXWEAv9ztGYRvx1hQ7YPEATGvlFi6KqSwvOuZJCxVvaDi6F6px9fkua5VKJnWvZjUedTPQpTawjprUvSwpxrzAGxn9D230NRFhRO/dZ7MtHHPbjG25wNBKUerlB8Tim5X6mMZ2eo12LC7pbRFzNJrdX3j3FoS2J+pvP5g7FKM5T3R1Hgs68UlDqK1AmWPs8ytD4EdabEn5wArbCA0QoMMdI/A0NQAHxTt1iimos2myDF4fBn0mRu0xeJPsZDuLdm75IrDgFm5tm7iypICsq4Po8cmcp8O0ulaMGLO25xc+iK3h1wwdvO8yiARsXcXk0CXJUqaR5KS4Q2/BBgoL9lFqIJUcx9qLysPYp4vYq3gh/9Pc5ona78/qufVDA7llM5PmRDidk9611T6R5DepkTnGXrlKEAaqdOCXV0hC72Jj3R0Lt
 kL5aDEmO
 icOf4yLujzTL0OJ8ZC72Q6Ny49jHqXpCFjAiDM2xANK3OhrP2n8G0SGbOKZtQps2DrP7Sjl17Vxg9o5TbnT7UAljt49bKDs2wWGnsnUDzAAXh8nuQpzP54RznsDJx0ioMA4eyiyg4cdvuAPOYRCF9lEBB8lBMz/TSwuzvUGNh8VYqGhJ2sOGvV0vDDI71sOQ4VxWfZq12PDlqBUk9FbL3HvXh6RwERrvuSlcceQAR3xzfW60wbrps6+tDjgyxhW4IaERpTIvA90mG5XwptquzYllHcLWsMMb+3QRU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
>Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
>with concurrent page table reclamation via zap_empty_pte_table().

Good catch!

>page_vma_mapped_walk() is used by many functions including try_to_unmap(),
>try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
>page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
>and try_to_migrate(), the other callers do not perform post-walk accounting
>checks, so the race has no observable impact on them.
>
>For migration, the race can cause unnecessary retries. For reclaim via
>try_to_unmap(), the race can cause failure to reclaim a folio that is in
>fact already unmapped (as shown below), which may lead to unexpected OOM
>or increased refaults.
>
>CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
>--------------------------------    --------------------------------
>folio_lock(F)
>try_to_unmap(F, TTU_SYNC)
>                                    zap_pte_range(full PMD range)
>                                      spin_lock(ptl)
>                                      clear PTEs
>                                      zap_empty_pte_table()
>                                        spin_trylock(pml)
>                                        pmd_clear()
>                                        spin_unlock(pml)
>
>  page_vma_mapped_walk()
>    observe !pmd_present(pmde)
>    nr_pages < HPAGE_PMD_NR
>    skip synchronization
>    return false
>
>try_to_unmap() returns
>folio_mapped(F) == true
>nr_unmap_fail += folio_nr_pages(F)
>                                    tlb_flush_mmu_tlbonly()
>                                    tlb_flush_rmaps()
>                                      remove F's rmaps
>                                    spin_unlock(ptl)
>
>Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
>has already moved the PMD clear operation (via zap_empty_pte_table()) to
>after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs to
>use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
>issues on weakly ordered CPUs.
>
>Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
>Cc: stable@vger.kernel.org
>Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>---
> mm/page_vma_mapped.c | 5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index e6b6170c2f4f..8797467b6f0c 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 			spin_unlock(pvmw->ptl);
> 			pvmw->ptl = NULL;
> 		} else if (!pmd_present(pmde)) {
>-			if ((pvmw->flags & PVMW_SYNC) &&
>-			    thp_vma_suitable_order(vma, pvmw->address,
>-						   PMD_ORDER) &&
>-			    (pvmw->nr_pages >= HPAGE_PMD_NR))
>+			if (pvmw->flags & PVMW_SYNC)

Right. Whether the folio can be PMD-mapped doesn't tell us whether its
PTE table can be reclaimed, so those extra checks can skip synchronization
that the caller explicitly asked for ;)

LGTM, thanks!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

> 				sync_with_folio_pmd_zap(mm, pvmw->pmd);
> 
> 			goto next_pmd;
>-- 
>2.47.3
>
>

