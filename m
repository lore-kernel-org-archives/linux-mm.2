Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A19C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6DC6B00C0; Wed, 22 Jul 2026 11:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49E786B00C2; Wed, 22 Jul 2026 11:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E506B00C3; Wed, 22 Jul 2026 11:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED2D6B00C0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:22:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 940FE1C01CE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:22 +0000 (UTC)
X-FDA: 85016778924.08.F7161FA
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id E5276180002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K+9ewz8I;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJyGxOkNDorXjAH0XOOahAgzY2eO5p0zRfJGy6LO4qg=;
	b=ghRzhaX++X63lWun6Oc9+IQg4E6JprRixrOLvYGyKsEZ10PBccccoZe9yF17XxyLjAsHQu
	+tKTQVpdfXKvHdPtD7RGYETKua8RHApm/uebdJMrRi64sovKvti1yseexRV7ARsV0CwZBt
	TRk+X7bZWCgzfCCyqRwruBGLj5C772g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733741;
	b=ioDaKDnRZE/Za8dRqUraHZEznyLTE7F67VBL3IOn7KZq/XJSOQbyeb8VmDHuphTIIvow53
	np+WFKK7YVsPFHw8CsDR3mOENVHwVVhox0LWxw8opWud4KrXyUZ3myv/fCTbOQtAQz+w7z
	5BG9T/iozL/62m1SgUp37mnf1Fiugcs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K+9ewz8I;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJyGxOkNDorXjAH0XOOahAgzY2eO5p0zRfJGy6LO4qg=;
	b=K+9ewz8IKoFjnuzUA45sDYVWWpjLp2t4ZQwUEjtcMC9py8yly1xikJwHxGKWKvuFVsUKjD
	hYwl8wvWHF7eg729d26HrVVTJOihOb3Sv4Zb4iEVQMNJQmqR1cWqaB9ZQ8tax/V3dsFQ3w
	it7T76wZM+4mziB7wVK1j+FxsRg2hpc=
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
Subject: [PATCH v5 07/11] mm: handle PMD swap entries in MADV_WILLNEED
Date: Wed, 22 Jul 2026 08:19:38 -0700
Message-ID: <20260722152043.2273289-8-usama.arif@linux.dev>
In-Reply-To: <20260722152043.2273289-1-usama.arif@linux.dev>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E5276180002
X-Stat-Signature: gnguwr1ckw4z6zr94dshz5fofxbcnz75
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784733740-924974
X-HE-Meta: U2FsdGVkX1/SYgo/+vpCXx8YTx/SMhJbdB5tXWDqmJaY7VtU8R4EBdbI1mGS11EoWd0w9SIcy4mu8y5m3Jfb8WPW/q9s3zjcsIcIXwcysEtWb3fytYlDFlAdm9BjpYRjXN1wySl/9Sj7w5zcd9Sb8qa4NPgL3br8PU1YjsOcNF/jUQr/yQ6PnoHIW0vwGuh9/D9dEzRlfZN/jAMdRnzG1zqS+NuH/jvXrlKbkpa+/EkQAUzb4C1dytJSYqKuFQ3BpNF4/2mg8xZHBNSGg2XTXdbjlRE5RmmFfNcvrexvG379n08io7ksYMVMderSGX3qlfsQufniVbxnGJvBYrSDHqaWLRMl601sHmic3qOX0JnjKJSuiAvuofWC77tQhYDut+1fVR7uJ5+qIEASZJyfdUgOA1/5XLYztpSqWu1BNWnUJERyFv9qsZ1Anyh8aFPeYQ+O/aZj8st6WyEp/zVBoQy1AcYMRyVztF+8PJJ5igI6iCB6Kx1FUilcDjn5uLTNEzoJPsn1TYYoglJcmc1HsrtbNT6WpQUMO8EGHE5b4jq375vHv3g5k0Y+wMWu/DbH4GICxf9EXG/gwO5icm0oISzH8b+UyjZUV0+pthJv4dGHB+gDItlSUszLDLeMuY43Sp371J5b1gEqHdbMNymWOt9zq5ckBjoJAMjXpAR3PPj+c74brxXje/ErQWf1KF1YbbH9/jrJSkcJfuhsTCVmK1ALiV4jyheHowwAbpDUF0jPLfRBbxx2Vc3JQ0TPbC8T7fXQHvoJfAXvVs2z1jPhQ8ko7UiiQ19dH5pDcQ4jPgrIZI4q36Hwd4SYt0tjggP1mtwBtEw7GZemynmHR0+sEW49HIaoUYw1nA7sppZDxcdkztLFkdVY5GAynsDYhwfuv/9ikjwtG8D3B9utM7OIpWZ8ZuxDyN/U+2f2vlezW6qpMTGsaIZIzEy0k/mCoZOHubQasUADwwBv8zM2IEH
 8CnOfm1v
 mBgfnA4x515b/x6RxJety0MctjGbQXOH+M3hu+OG4QXpINQ9ChSwkgg5a2dUC/Kd4s6sVsNN3MZkRiT16DWhQWYDI/yYSJ6o0fzll+qHmL1RdIoS8UnpuACehmEd/SFh6fnelkBOua4u9D3MzktljvJKm06V0/BH/P8ooo64jTnv6WC6KD2XNvuMrQCOQFruDyDGV7ukQvSVVtx9aYhgs0WeRJHaeBMFAyxCetEVjj+gWYXBgGjuPW3n+hg==
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
needlessly splitting the PMD swap entry. If PMD-order swapin races
with per-slot swap-cache population after dropping the PMD lock, split
and retry through the PTE path instead. If per-page zswap state
reappears during the read, remove the failed clean PMD-sized folio
from swap cache before splitting so the PTE path can load each slot.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 81ccdd6a5140..1d5154b10dfc 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -32,6 +32,7 @@
 #include <linux/leafops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
+#include <linux/zswap.h>
 
 #include <asm/tlb.h>
 
@@ -193,6 +194,91 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 	spinlock_t *ptl;
 	unsigned long addr;
 
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
+		pmd_t pmdval = *pmd;
+
+		if (pmd_is_swap_entry(pmdval)) {
+			softleaf_t entry = softleaf_from_pmd(pmdval);
+			struct vm_fault vmf = {
+				.vma = vma,
+				.address = start,
+				.real_address = start,
+				.pmd = pmd,
+			};
+			struct swap_info_struct *si;
+			struct folio *folio;
+			enum swap_pmd_cache cache_state;
+			bool split = false;
+
+			cache_state = swap_pmd_cache_lookup(entry, &folio);
+			if (cache_state == SWAP_PMD_CACHE_HUGE) {
+				folio_put(folio);
+				spin_unlock(ptl);
+				goto ret;
+			}
+			if (cache_state == SWAP_PMD_CACHE_SPLIT ||
+			    zswap_is_present(entry, HPAGE_PMD_NR)) {
+				spin_unlock(ptl);
+				__split_huge_pmd(vma, pmd, start, false);
+				walk->action = ACTION_AGAIN;
+				goto ret;
+			}
+
+			/*
+			 * Pin the swap device under the PMD lock so the
+			 * PMD-swap-entry observation keeps the entry valid for
+			 * swapin_sync().
+			 */
+			si = get_swap_device(entry);
+			spin_unlock(ptl);
+			if (!si)
+				goto ret;
+
+			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
+					    BIT(HPAGE_PMD_ORDER), &vmf,
+					    NULL, 0);
+			/*
+			 * The empty-cache observation was made under the PMD
+			 * lock, but swap cache can change after dropping it. If
+			 * PMD-order swapin lost a race to per-slot cache state,
+			 * retry through the PTE path.
+			 */
+			if (IS_ERR(folio)) {
+				if (PTR_ERR(folio) == -EBUSY)
+					split = true;
+			} else if (folio) {
+				if (folio_nr_pages(folio) != HPAGE_PMD_NR) {
+					split = true;
+				} else if (!folio_test_locked(folio) &&
+					 !folio_test_uptodate(folio) &&
+					 zswap_is_present(entry, HPAGE_PMD_NR)) {
+					folio_lock(folio);
+					/*
+					 * A failed PMD-order zswap load leaves the
+					 * folio clean and not uptodate, but another
+					 * thread can remove it from swap cache before
+					 * we acquire the lock. Revalidate the
+					 * association before deleting it so the PTE
+					 * retry can load the per-page state.
+					 */
+					if (folio_matches_swap_entry(folio, entry))
+						swap_cache_del_folio(folio);
+					folio_unlock(folio);
+					split = true;
+				}
+				folio_put(folio);
+			}
+			put_swap_device(si);
+			if (split) {
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
@@ -221,6 +307,7 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 	if (ptep)
 		pte_unmap_unlock(ptep, ptl);
 	swap_read_submit(&ctx);
+ret:
 	cond_resched();
 
 	return 0;
-- 
2.53.0-Meta


