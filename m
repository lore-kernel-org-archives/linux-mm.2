Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16236C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195146B01A4; Tue, 18 Aug 2026 09:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD0E6B01A5; Tue, 18 Aug 2026 09:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2A36B01A6; Tue, 18 Aug 2026 09:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0B396B01A4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24A2E1C0066
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:46 +0000 (UTC)
X-FDA: 85114429932.06.F8A77B8
Received: from mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	by imf04.hostedemail.com (Postfix) with ESMTP id 41D2640007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qCrOxkVA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwAfCr1zutdbc2UgD5mcBpyGZqobukp4d6MGD70osrg=;
	b=pLTuBNHJxdGeHeBnTOMcMQgj8HujRsuXrBDRwzta9dtfiJHkwMx5UpZJWkWFzo6wwjRHvi
	CK6o1R6RJ/VqnlDb1gHrWt4LmEmiZYyuLKL4R5niQbX6ZILlJE9BFphG3shjY01W0q1sVt
	1Rsw4KHSmxgTYTaUqjRjOmhm77+yEV0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qCrOxkVA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058764;
	b=RpP4HC63h9r31bUOlWwXKPQgaOPJQ9en/SDQUA6f4TFAmQ1pc1UbhvkEOZnYjtOVW9lwdG
	MynedgwzyfWHBCcYS6GC9MrFruXuUpCU4oJiE8pkyhrmUsR1hcs42++r79ZC4OHkB7lmCI
	Df/IHdh7OR7sUNdndogOds53xR+SyO0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aLAdrmSbqCsLxg33maT0h/TBnMjvDOsyYsDfAadsCew=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058763; v=1; x=1787663563;
 b=qCrOxkVAt/HY/nGLXJPlGWqdDAfBrskbY8w3O2kCahluie7bg+PPTXJjc5KX36n5I7yK43Q5
 q81Ur+GVM0h0Sha1oG/+iQtYgkle6h1gWQ33ehf/rxmZ9gmN13hdfk4LCDqJIXPN9SGTR/EotjN
 ZGdecgCNrQDF8vMv7yjN1YXc=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:44::)
	by mta11.migadu.com with ESMTPS id 3c6aca1e0754bc79;
	Tue, 18 Aug 2026 13:12:43 +0000
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 08/12] mm: handle PMD swap entries in MADV_WILLNEED
Date: Tue, 18 Aug 2026 06:09:49 -0700
Message-ID: <20260818131202.494754-9-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 41D2640007
X-Rspamd-Server: rspam07
X-Stat-Signature: 53qst3bwms64myqg6auxq9qs886n367h
X-HE-Tag: 1787058764-892539
X-HE-Meta: U2FsdGVkX19Zwhts9qqCA8OKs2iLMAdQ8p0GYLPs7VYWTmvUuWkAtd99eTjYK/WfyIXG30NofcwZ3xBAO10+PQWycxP+Vy87sli7uC3exgrnIguaLKPrnTOeCpd5kXulxGzjXQ5VgxFNYOcpmTPXmujQZRSTLBaIBOdsDvUit5vQVkohmqdBFpQIi9P54OjaAttbVR5wGAtirJxhQ3ap5qzkJbzGVVdsK2APhVXNsDkDlfeZoskTB/9wET5tR5G9QXqOXKIBBiaqRVlCrXje+JOY6cpTAYLjU3ZXl9duBH9pVluVyi+VQNoiw+2cLF0v5mEtZfmkrBa6dzZP/wRzojy8f60BMsk/zoy+7EuQCogMnwVkbiE1x/DciANoEtq/aJWWG1dH67XeMakuXXlVNVOhoZ0vAyPezE17P4Q5WlfjlLgOCYXVGZpoRHZa3LghbMeLez0kmqR52jYpONFijslDnwxCUwIi96Ipik1Bn+GQZ2Qxij5JcujyKWxtZ9ZoaSSmksF2nc4paOf+q/RN3o7joxluhfd+eEpd7hNNJ+tUsOROfvmhD3VMY1UHpojTU8AvEunXKJYrPj8jImZhyT+as6xGtM/izJFyPc62gfSck4/TPuSDiD2HLprkYNErbkZaXg+q4fF1lOMrtBT2IpPV8j/6VW+NaQlVO8tKQlpzG7DqhRtXGbzehLsXcOgUDuLxwZLDIFPAKD8WC7iwbu5df+pf+2g/LgeSt7tiAAwNXgZ2S8H5rADOdezrRCtGw3MbwzsokGK+Hwode88Uq169uzWGhHsUxibxje1Tp9wD6StE+QGES8IRuuDkFm1ROhRB61i1YTYjoLHLzYIO9lUU3RfZ9oiuJAM5wwuWtMyWXZnwAT30zc1GNoeyf3c06belgbdD2iksPJVNpkdLzXTUo3bZQvRK98Ysd44h05/BsWW6ae2YV8vH2kvLNYJ/knXWayfOfNo1p3r/mht
 W0FpC3SO
 BmwTshskSQ2zvj1NljCpWark9MlG7bJA4k/QCFeZFhi8ztq0opMRgBBWPBuSCSNuu+tcDj8tx+a4vPENAVoDv9/IJ1rVLsIN3YTb3PwxHB5Rmwy0Xn0YNye5MZQtP6LCTO6AR50z48lSQA6lN3wB2yFb/Dqz0b/rpQV5a+faqRGrvCg2uzFY3rGuDxzdKtBfH5GUnoZAHu/JZfg03pHarr+7Nrw27+wIuoNFa8GRcamZ3IJh5JyDWJBByuPXxih62VN7L+8WnY1Szopbqx6sy8dJXzskCGqiVWNiI92Pxs90fIPe5t5Z+VS6Mawl781nwladK4p/L3x1KE+1cd/evX+SUeurXNhC2a9SlvQRyQPiq7epVhDXhaekmPTm8U3CCVWja9ScRU2i3v8V7agWZg2BOnoqaVjWSBSVC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swapin_walk_pmd_entry() walks PTEs and skips non-present PMDs, so
MADV_WILLNEED is a no-op on a PMD swap entry.

Handle PMD swap entries under pmd_trans_huge_lock(). If the covered
swap-cache range already has a PMD-sized folio, there is nothing left
to prefetch. If the range has split cache state, or any covered slot
currently has a zswap entry, split the PMD swap entry and ask the
walker to retry so the PTE path can handle the individual slots.

Otherwise pin the swap device and read the folio in at PMD order via
swapin_sync(BIT(HPAGE_PMD_ORDER)). This keeps the subsequent fault on
the do_huge_pmd_swap_page() path and avoids order-0 readahead
needlessly splitting the PMD swap entry.

Any failure of the PMD-order swapin splits the entry and retries
through the PTE path. That covers losing a race with per-slot
swap-cache population (-EBUSY) after dropping the PMD lock, but also
the -ENOMEM that a PMD-order allocation can easily hit: leaving the
entry alone would make MADV_WILLNEED prefetch nothing at all for the
range, while the PTE path can still read the 512 slots at order 0.

If per-page zswap state reappears during the read, remove the failed
clean PMD-sized folio from swap cache before splitting so the PTE path
can load each slot. This uses folio_trylock(): the lock is only free
once the read has completed, so MADV_WILLNEED never blocks on in-flight
I/O, and unlike testing folio_test_locked() directly it cannot race
with an unrelated lock holder.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 16b39a06b038f..3ef1af1e76daa 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -33,6 +33,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap_ops.h>
+#include <linux/zswap.h>
 
 #include <asm/tlb.h>
 
@@ -185,6 +186,93 @@ static int madvise_update_vma(vm_flags_t new_flags,
 }
 
 #ifdef CONFIG_SWAP
+/*
+ * Prefetch a whole PMD swap entry as one PMD-order folio.
+ *
+ * Called with the PMD lock held; always drops it. Returns true when the
+ * caller should ask the walker to retry so the PTE path can handle the
+ * covered slots individually.
+ */
+static bool swapin_pmd_swap_entry(struct vm_area_struct *vma, pmd_t *pmd,
+				  unsigned long addr, softleaf_t entry,
+				  spinlock_t *ptl)
+{
+	struct vm_fault vmf = {
+		.vma = vma,
+		.address = addr,
+		.real_address = addr,
+		.pmd = pmd,
+	};
+	enum swap_pmd_cache cache_state;
+	struct swap_info_struct *si;
+	struct folio *folio;
+	bool split = false;
+
+	cache_state = swap_pmd_cache_lookup(entry, &folio);
+	if (cache_state == SWAP_PMD_CACHE_HUGE) {
+		/* Already cached as one PMD-sized folio, nothing to do. */
+		folio_put(folio);
+		spin_unlock(ptl);
+		return false;
+	}
+	if (cache_state == SWAP_PMD_CACHE_SPLIT ||
+	    zswap_is_present(entry, HPAGE_PMD_NR)) {
+		spin_unlock(ptl);
+		return true;
+	}
+
+	/*
+	 * Pin the swap device under the PMD lock so the PMD-swap-entry
+	 * observation keeps the entry valid for swapin_sync().
+	 */
+	si = get_swap_device(entry);
+	spin_unlock(ptl);
+	if (!si)
+		return false;
+
+	folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE, BIT(HPAGE_PMD_ORDER),
+			    &vmf, NULL, 0);
+
+	/*
+	 * Fall back to PTE-order swapin: a PMD-order failure does not mean
+	 * that individual slots cannot be read.
+	 */
+	if (IS_ERR_OR_NULL(folio)) {
+		split = true;
+		goto out;
+	}
+
+	if (folio_nr_pages(folio) != HPAGE_PMD_NR) {
+		split = true;
+		goto out_put;
+	}
+
+	/*
+	 * A trylock only succeeds once the read has completed, so this never
+	 * blocks MADV_WILLNEED on in-flight I/O. A failed PMD-order zswap load
+	 * leaves the folio clean and not uptodate; drop it from the swap cache
+	 * so the PTE retry can load the per-page state. Another thread may
+	 * have removed it already, so revalidate the association first.
+	 */
+	if (!folio_trylock(folio))
+		goto out_put;
+
+	if (!folio_test_uptodate(folio) &&
+	    zswap_is_present(entry, HPAGE_PMD_NR)) {
+		if (folio_matches_swap_entry(folio, entry))
+			swap_cache_del_folio(folio);
+		split = true;
+	}
+	folio_unlock(folio);
+
+out_put:
+	folio_put(folio);
+out:
+	/* Keep the device pinned until the last use of @entry. */
+	put_swap_device(si);
+	return split;
+}
+
 static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 		unsigned long end, struct mm_walk *walk)
 {
@@ -194,6 +282,23 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 	spinlock_t *ptl;
 	unsigned long addr;
 
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
+		pmd_t pmdval = *pmd;
+
+		if (pmd_is_swap_entry(pmdval)) {
+			/* swapin_pmd_swap_entry() always drops the PMD lock. */
+			if (swapin_pmd_swap_entry(vma, pmd, start,
+						  softleaf_from_pmd(pmdval),
+						  ptl)) {
+				__split_huge_pmd(vma, pmd, start, false);
+				walk->action = ACTION_AGAIN;
+			}
+			goto ret;
+		}
+		spin_unlock(ptl);
+	}
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		pte_t pte;
 		softleaf_t entry;
@@ -222,6 +327,7 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 	if (ptep)
 		pte_unmap_unlock(ptep, ptl);
 	swap_read_submit(&ctx);
+ret:
 	cond_resched();
 
 	return 0;
-- 
2.53.0-Meta


