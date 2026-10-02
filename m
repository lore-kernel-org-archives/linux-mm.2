Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62EA4CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699F86B00C3; Fri,  2 Oct 2026 05:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6700F6B00C4; Fri,  2 Oct 2026 05:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F036B00C5; Fri,  2 Oct 2026 05:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32BE26B00C3
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE2CF1A0678
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:27 +0000 (UTC)
X-FDA: 85277233734.18.C009C56
Received: from mta1.migadu.com (out-213.mta1.migadu.com [95.215.58.213])
	by imf09.hostedemail.com (Postfix) with ESMTP id BF8C4140003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mCoIEN0G;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+AyCK5IFBE7c8LzfbkdTC6f8fhzxSKjOaNage3zlGI=;
	b=fKF8GuCmzKh7W0qcTJE4O7De5AUaLi/KemJOHNI4ogvMLYfRrRUuih9anqfcpXz1OS70Be
	8OhXE48c9g/rKQSCB6ErJmF8wNDWtxb8QvxjAJ9GBuiA5JDhCHjDmdwODgSjVnzBHXoHxJ
	ceBdToOEaAuDwvywtoRpdrR4Q2HkuGs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mCoIEN0G;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935046;
	b=6hxLsHobe8zI+5cpWzo/Zey7ICsIxlsCzjOdkGxW2MZZKfuMob540TRcfKdmn7GafQCcsF
	pFQm7H0mae+QNyfefVekANKoWj9K6hdXmZZVp/7GP6bnqWBN7gCKvTpcixJld2dbtrjkLb
	6RphH4Bby/1W7/2Fs51LVY3kkz2Ln1Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EyUDdenA2PgGa7+xcdmhQ/lN4jJ+bH9xLwGVwaO34zE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935044; v=1; x=1791539844;
 b=mCoIEN0GqZVlxYU4eLokx8tU0YrtzBroRnQfYVgyrrh/3dJqUMhQBfqj3xBZCONKvDJhdDiG
 yR4oB8RUuHr8bwRewKd5ON24iDGVMvY67NFgTWmMCIHMaaWCJ6kaqr43sMhKeBCAWsgu95QKpEd
 IaKyfFQXvBZ2YnyfYBSapqXo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 8077e17e7794163d;
	Fri, 02 Oct 2026 09:57:24 +0000
X-Mizu-Trace-ID: 8077e17e7794163d
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
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 25/30] mm: handle PMD swap entries in MADV_WILLNEED
Date: Fri,  2 Oct 2026 02:52:39 -0700
Message-ID: <20261002095503.3585565-26-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d7o8i9qei9xdxyi7mazxe6an69tqkb3a
X-Rspamd-Queue-Id: BF8C4140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790935045-24239
X-HE-Meta: U2FsdGVkX19Tru5BKM7almmOg/c6ouiD49p4T56lqQmdZaWqRgMGXDe4BVkD11n4A3sWX5NfUi6ZXxND6jmgpNmZLOdRziouTF2YT2P4OqeRMcdsqLlA9pJuTZEYYDGTjLSnnAh4f+2jvR+0lhNW6B5MlWyxw1rZFukg9QEL6gaRrB/GQ4+D7NNWf/cldTaKJZ89YH6awNwaPfQkbWi2orm0nfmSfDNzg9CTv0bcLixetREX1pM5C+gjtCj48F7t8XmvNbvyJXCLTwU7kqXOsgbrhE8RA5B3fn1Dkd0OPq82gx7Yf7WcVTj7TOGX9OCYLEd0sgTc439cwdRYJ9j2/ORmtAyMR2s/w4qzf7fmAUVU1vZCKovOfGL36jnMWsx35wO+p8fLFzQhqmHbPS/OElCiqrS+cveut+t/3tugyira0IlWTQT9pjmArX7eGLDwVVv/1F+GG1Rf5sSocznVvWHHyv3OQ5ZuA3TAyjeWFJ9ieoR8ihOr7OpPhmiYTyp5skCStVUaazpaKL8fXhr4J4gv7yndu9JETLdkqBiaJnaU87wRpfjYs5MM56qF7biF1QVxmIV8VQAZm123NHyRigwliyD0E1KrKmcUrPVtrF9E97X+2agPhvBkcZwss2U4JDVFqrnlUt5gveodv7Sesd5mN+LktT/zN3WnojJ5HCYjEkWONQZFsflR1JEzrSxUELkk2KK556L+HlaHyCRxSDzeHKnVOd8/grjkvSM+zsLG9knL4G64FMKiWlQ+GvSJUb7wje+yY9mud7/lVYkmtfCmELVEWwu2X3usNY+J8mZb1TaKIQsYLLMgBVtWGJmE9GNtuI6ibyy1Xc7/jjACWDfm5uh2ONIogeWhUy94HwJL5KLpRiEF7F70jlEJN0TpyHa5EnUBnjfHKmhVcFMmxlPVhJZKwTyg8fSkN/BZRjv8d6+mBg6FevM1WP0VIfzZjaXyudxOIo536ITNrCN
 ctwirVjV
 ov64ozUPfqKmOA1CwA+rl5OKLq+tqR2HUB2kxRaP+KLSysT8LoVxV47c1/XwT3a7SvsxqywptxKvj4RlSiZbiyUhDQbyqF9eo3+XMh7uGOjyeUTIvCEOWE6A4+S5YH8SoRAusqq4gIkQjohQsEZPgnKmbMsK8fF20m/5JZuJ9vGTr++Hbmoc665dkcxCqkR8HRf/yS1AD94vuDYLXFzPGKnguH8wajlYdgg09ClfVxtiW+RV774febGpsMH/RXVhFfcK0hDdT6EqI6KRv6EsgnqAeNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swapin_walk_pmd_entry() walks PTEs and cannot descend into a non-present
PMD, so MADV_WILLNEED is a no-op on a PMD swap entry. Reading the slots
back one at a time would not be much better: order-0 readahead populates
per-page swap-cache state, and the fault that follows would then have to
split the entry the prefetch was supposed to help.

Prefetch the whole range as one PMD-order folio instead, leaving the entry
in place so the eventual fault still takes do_huge_pmd_swap_page(). Check
the THP policy first: the range was PMD-mapped when it was swapped out, but
MADV_NOHUGEPAGE or the sysfs knob may have changed since, and reading at
PMD order would then hand do_swap_page() a PMD-sized folio to map with
PTEs.

A split cache, per-page zswap state, or a failed PMD-order read or
allocation falls back to PTEs. Leaving the entry alone would prefetch
nothing at all, while the PTE path can still read the slots at order 0. A
folio that failed to read is dropped from the swap cache first, so the PTE
retry re-reads each slot rather than every later fault returning SIGBUS.

Only split if the PMD still looks like the entry that was observed - the
decision is taken after the PMD lock has been dropped, so a racing fault
may have swapped the range back in as a THP. The test is lockless, so it
narrows that window rather than closing it.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 139 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 64019668d69fb..ec1cb1b71070a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -33,6 +33,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap_ops.h>
+#include <linux/zswap.h>
 
 #include <asm/tlb.h>
 
@@ -194,6 +195,108 @@ static int madvise_update_vma(vm_flags_t new_flags,
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
+	/*
+	 * The range was PMD-mapped when it was swapped out, but the policy may
+	 * have changed since: MADV_NOHUGEPAGE, or the sysfs knob. Reading it
+	 * back at PMD order would then hand do_swap_page() a PMD-sized folio to
+	 * map with PTEs, which is exactly what the policy forbids. Split now
+	 * and let the PTE path prefetch at order 0 - the next fault would split
+	 * the entry anyway, so nothing is lost that the VMA still permits.
+	 */
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_PAGEFAULT,
+				     HPAGE_PMD_ORDER)) {
+		spin_unlock(ptl);
+		return true;
+	}
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
+	if (IS_ERR_OR_NULL(si))
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
+	 * blocks MADV_WILLNEED on in-flight I/O. A read that failed - a
+	 * PMD-order zswap load that found per-page state, or an I/O error -
+	 * leaves the folio clean and not uptodate. Drop it from the swap cache
+	 * so the PTE retry reads each slot again; leaving it there would make
+	 * the next fault return VM_FAULT_SIGBUS. Another thread may have
+	 * removed it already, so revalidate the association first.
+	 */
+	if (!folio_trylock(folio))
+		goto out_put;
+
+	if (!folio_test_uptodate(folio)) {
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
@@ -203,6 +306,41 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 	spinlock_t *ptl;
 	unsigned long addr;
 
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
+		pmd_t pmdval = *pmd;
+
+		if (pmd_is_swap_entry(pmdval)) {
+			/* swapin_pmd_swap_entry() always drops the PMD lock. */
+			if (!swapin_pmd_swap_entry(vma, pmd, start,
+						   softleaf_from_pmd(pmdval),
+						   ptl))
+				goto ret;
+			/*
+			 * Only split if this still looks like the entry we
+			 * observed. The fallback was decided after the PMD lock
+			 * was dropped, so a racing fault may have swapped the
+			 * range back in as a THP, and splitting that would
+			 * demote a perfectly good huge mapping for an advisory
+			 * hint. The test is lockless, so it narrows that window
+			 * rather than closing it.
+			 */
+			if (pmd_same(pmdval, pmdp_get_lockless(pmd))) {
+				__split_huge_pmd(vma, pmd, start);
+				walk->action = ACTION_AGAIN;
+				goto ret;
+			}
+			/*
+			 * Somebody else changed the PMD. Leave it alone and let
+			 * the PTE loop below deal with whatever is there now;
+			 * it simply finds no page table if the range came back
+			 * as a THP.
+			 */
+		} else {
+			spin_unlock(ptl);
+		}
+	}
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		pte_t pte;
 		softleaf_t entry;
@@ -231,6 +369,7 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 	if (ptep)
 		pte_unmap_unlock(ptep, ptl);
 	swap_read_submit(&ctx);
+ret:
 	cond_resched();
 
 	return 0;
-- 
2.53.0-Meta


