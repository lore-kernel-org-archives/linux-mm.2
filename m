Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE2BC88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B876B00B8; Mon, 14 Sep 2026 08:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3969C6B00BA; Mon, 14 Sep 2026 08:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286416B00BB; Mon, 14 Sep 2026 08:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 023DE6B00B8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:32:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A39D403E7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:08 +0000 (UTC)
X-FDA: 85212305136.20.5C5528A
Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA65A20006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o+PtNzf2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o+PtNzf2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389126;
	b=oVbVnd91TNukQQ4NYXowDAKVr4gDRP9YD/Wr/V9J8VhUexIkDh05O28trFj9vuHp8NjxyK
	4MjRsDvgwDk7hj3MSPNpSAJ94hw1pX5C2mDS/3toyS3u1tEng3dAvPQnbH1Hx4MewE9DK5
	T+z/Ioaph4TNlz/IXe/zmNqHTwTkJBk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+AyCK5IFBE7c8LzfbkdTC6f8fhzxSKjOaNage3zlGI=;
	b=4z6+3suespWx0VQr5rsd7HSDMC6ROhqbxInrxsdO7Tuv8aTbVnNreqRqWKXOngbfqkKs52
	9AroslwvbcKWVz0K6jcEBHMW6M6l+C6WyoOsWOmw/e6AVzo3tac1QoWYfwFPirmX+pmOIN
	B/I+VJ59/GXd5IjFlNQRqsBVY0ZHHng=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EyUDdenA2PgGa7+xcdmhQ/lN4jJ+bH9xLwGVwaO34zE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389125; v=1; x=1789993925;
 b=o+PtNzf27GE/b+iZOhJuMYSGaw+SoU61D9gUGwQcvTVIZWrSjtJuBRiCJ2PAOJC+2VWCyTlv
 cNAL0LaLQGg/xTldtn+p2raeydbzDlhqaguUwgQhM7V4QlBHQu7cs8BlLnavWU1GBPfH8p23rAs
 UxVA9wNFUUVGZCM+AiIGH4iY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id c218f079dab4b45a;
	Mon, 14 Sep 2026 12:32:05 +0000
X-Mizu-Trace-ID: c218f079dab4b45a
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
Subject: [RESEND v7 24/29] mm: handle PMD swap entries in MADV_WILLNEED
Date: Mon, 14 Sep 2026 05:28:14 -0700
Message-ID: <20260914122950.3283997-25-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AA65A20006
X-Stat-Signature: 6595xfm6ac4imyw1niqcjt7cpmne8jke
X-Rspamd-Server: rspam01
X-HE-Tag: 1789389126-774456
X-HE-Meta: U2FsdGVkX1/38LuKfb6zttKWce7wE2ybFDBRvVKceiHzNtOHzOPKWAt2cB9ASfwSFhpjsaiJKBmxvwGS8s304cvEQ97qLnwbOXYNqbYVPSA86/iiAwNqJLdf7EUiQF+iWRzFyyTgmPsY8EXkypRG2VKe1NFUCJElKlsotI1nD+N/3wGJNxKDhLRi7sMixGW5KvDvoncaXmiLU8lI0B8Q5kkU39UKMDNJhqzpKTMSCNhEk5BD7sPg0WghHJo6GepkeZAwqtEP5e/6JaiZKrZs2KSZjJR5C+3hXzp4d4qYNvfjxK3QWGjiiq/Y7Mhnhj5YL9BkwUCeHTzWHHNGkKYfXjn++t7mgUii9bZEyT0zrgypv187JxtSWSZQshp18cOp5628b4nWZnB2GnhMJjIvTMtzxMaEypDO0Ftk17SLtud0SNCrxMSa0vvUocqctaenYFIr4IrBYwhEssZo2zzmRK8J9nS3g1j7dWcKFoo1ZWTFnt6PXpIfbaOI1KRxUbmeHGjZRw0hd7gOrEDdLNVrrmVsK+2cPiqlKfLrhC9crHnSoo3W2DW5ndnDaUZ5OjZWszCHL1rtgqnMINKSVL9g1NZ/o6mkrLbQ+yN99PueC5rfw8hTySkWSpwKckkOCzmU5vYXXiOlXDs6wY61tDIbldiJJEfPG7Vg/Z0suEUx7qKv8QhbqEr7KshjxyWpMtsTaAwP4hPq4uBPCDZZv7Wwv6bxxeCc5JVdL/0ASIbueoIguJmS+b6HTjMTMuUJ0HWDtS8G2eUMytCeX1ObZo60T3jzNkeraez46FmRwZJ7i5eYRRFOMm8G4ndFyyrR8tiAoY8u2jPWa514HTGVpCEob2R87RjPZN2PPyBMvH7Zu0o6TssMtaQlx5jlZ1Hw1dm4Hh9plOpu8b0lSy7JsqhJNa8C2EI3p/35AZ2Sh4IDXIQ2M+WCUmklPSS2inS1XZzCgbtfby5E3iUKEDfxT2m
 oOyj0XxH
 JrJqB8QsyB1y93zjjnvrFAhpgbz6OPtgYU7xVCXZY5jVbD6Z/cEuqNCfkFgKN/lkmw4FiT+oRGSGNJQuOH7CrFRCQI59TUXR6leZlFmyu4P+8/w0Qn4Z92lOM1BTKyV4Mw7AZ86pFIhGOLnfilso8pNT23lX/yKcy5PHNWwySVZKLctULgD3KGgNApgUH+/SHK6je2l9G/BeTwSMc81oA+/AjzbVoVHfBOeX3hgtvrJlGYTGx9DQTcr4FT3sskKCLWpCcR7siu3siloxSleNkB3c9QQ==
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


