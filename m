Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B41CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512436B00BB; Fri,  2 Oct 2026 05:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEEB6B00BC; Fri,  2 Oct 2026 05:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251696B00BD; Fri,  2 Oct 2026 05:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF8FA6B00BB
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7349BA7621
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:11 +0000 (UTC)
X-FDA: 85277233062.22.22368A6
Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7EC5540006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ms8P+k99;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NFkW5dOQcEeTJGS++Of1CLQBM6Bnsfu1mLweZISnZg=;
	b=4maPnl8vqa3S2JQWI4zVOWqhVf6JasvxDz9WzlQNfDEBpxxXtTfhCpNQkJPjhIw3NguKu1
	yAWzOgXBdGNyuEvp8cdMOs9Gd+wlRIlx/PtdzOWqLkQLFrkZSzOFDTfKYpRZAntCuf+uFh
	FXK1EDjXfC4NJFY6uJnN09urZ2WDCdI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935029;
	b=4EW/AgquAVsQaV63NqkgCBc7+rkM+h5e426PDqTOZxnIoi1keaZ4t4tf4tVCjyWl2P8zL7
	HVC6yKRsdtBPXmBP7wqXB1W9QfuFmhNVtgz3IYCdRDLs2j7g2CWr9FstaZtJREvVvXzkL7
	5m12Q2cous2isZUGOVG4xWGJL7mw5RY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ms8P+k99;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7cWRiY61ttsBLvX5i9ElmLypjZl7WDBKL9U4yzhj3UM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935028; v=1; x=1791539828;
 b=ms8P+k99mL4Xm5d2JSr4KWzr5ADzTLyRHvqnZWLFRi+qbq6LtHEHQzT30/NQsWLysPHSlu2J
 7rcgonHAR8/J27x64Ew1vIUJNQp8XDZttQUq9e0f6Ux4y+Y7Za8D2se7xP2CaKxwaC/wKlt6K7R
 ulCXxjMu8RGSQts99+zniTlA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 0f29b55ffbe886d7;
	Fri, 02 Oct 2026 09:57:08 +0000
X-Mizu-Trace-ID: 0f29b55ffbe886d7
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
Subject: [PATCH v8 20/30] mm/madvise: free PMD swap entries with MADV_FREE
Date: Fri,  2 Oct 2026 02:52:34 -0700
Message-ID: <20261002095503.3585565-21-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7EC5540006
X-Stat-Signature: kmbw3mhgbrxjnw4w9udb5xuiosxxh1zt
X-Rspam-User: 
X-HE-Tag: 1790935029-320353
X-HE-Meta: U2FsdGVkX192H/qwTqFB82REGcVz12SqmAKLrV8tOyJpD/JjmRtBjKaOmBOG9vX8Jw7LuqJWA75OJwFSiIiwBmCjLt4QEVjP/V+107kBlj6ck2jGLF/PYolhHCPzW9WJQfAYRF7xSNQM1yVA8fYTXV7nIweCmHrB2kOKpWsnuicKsBJlfjjxsLml68T6w5+NfZPTdL65hBGglMHfyoiiiUWJ6ho0V9z2ds/kWUlabgSqwWmVdtZQMNiYpLfhavKMZbDeBRyju2QqksTmmezKs2qLdnjZudU9OWj1dXmj0/V6AbdRFNJlKUqW5FXriwqjv5VPPTdw7pWw+mb9sgaEispFK6Z9ReQ8qn9UdtgAMQ+4uoIabchxz3CiYv1rp70RuwAGhGY0Ux0NPHdgSklyhNsELPkA3AMaFTi7k8XxIebmuWaPmE3Cftwy7fe6eJsMELwIxYcWa1aRVo9sntte95LMEAWWtRzTz6Fs64hiAmnTY8HDju3rtpuy+dRpo5PULRlaIMZoT3YafdNFePuN/i0G2P+W+cb8smoz+LejBZuJ0fJVGX8uQXqEgQP9AbaOVvAk9SKebG6ak7GBwZyJCpDmb7/0xsezN55WBN9IJYt6qDoW6iSDCNmCb1NXRHhb14Y9lscff8ylpa2Nvf+5AgJD/TFx9360IZlnjkMl02Hgt2KxGooCf6rqwVBIuCuOF+eZdnFcJyar2hXUSc4s+Q+l8M2ydptsfoOOY+fCjQ0yTRpRht8bh++Tiqd6ADmbATYncQrADMZeYAvIHkG6jfPJ3AeMvLWCaEL8JvXLAU8nJ/AeG6bwvzLWaCmxIKayOnVAjA3IqA0CqA3ywEgr/td3K5CiCOP6BZccmLMfXGlx+QtuoORfhFUv4vOY+cI6OhH7JVYaMxgnIJhf0ZiGeQ6bwauQSAgRYz/z/rpbydr/NCriM2FJb92GYqlScCa/UZkQGdErgM0ibA9dgws
 ZFrI/ATn
 9EVOTbrbP/8T69Ltpk5iFvXIYY08obXVyqd2F/tPAfcUcy14rr4ttTpoEZ/79LMtmwqPCKLaTQZh/VGSwBErRAmD6Pi/i0dCRlmSjjrsi05yO9iRgQC3ds5CIi8ROQ+jFKJ0IS1/lHTf/fAehlmSM3ZiklR3Xev9981NUl4fSKJSuRhJMxjNAV9h9GZpaEv7d5y2UQ+xEhEt9r0EhILRjcNIj5TspbhlYlWWtEI0cBqG0TM9/JoMWcFjAhxDwVqwNwGFYZwZs6y8FM5Uttedv9XcrwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_free_pte_range() only calls madvise_free_huge_pmd() for a present
THP, and its PTE loop cannot descend into a non-present PMD, so MADV_FREE
over a swapped-out THP silently does nothing. Over the same range as PTE
swap entries it frees every slot, which is what userspace gets today.

Free it at PMD granularity when the advice covers the whole PMD, and split
and let the PTE path handle the subrange when it does not.

zap_deposited_table() moves above its new caller; it is otherwise
unchanged.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 34 +++++++++++++++++++++++++---------
 mm/madvise.c     |  2 +-
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9cf7c4747cac9..c3d37dd84f523 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2424,6 +2424,15 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	return 0;
 }
 
+static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
+{
+	pgtable_t pgtable;
+
+	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	pte_free_defer(mm, pgtable);
+	mm_dec_nr_ptes(mm);
+}
+
 /*
  * Return true if we do MADV_FREE successfully on entire pmd page.
  * Otherwise, return false.
@@ -2448,6 +2457,22 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		goto out;
 
 	if (unlikely(!pmd_present(orig_pmd))) {
+		if (pmd_is_swap_entry(orig_pmd)) {
+			softleaf_t entry = softleaf_from_pmd(orig_pmd);
+
+			if (next - addr != HPAGE_PMD_SIZE) {
+				spin_unlock(ptl);
+				__split_huge_pmd(vma, pmd, addr);
+				goto out_unlocked;
+			}
+
+			pmdp_huge_get_and_clear(mm, addr, pmd);
+			zap_deposited_table(mm, pmd);
+			spin_unlock(ptl);
+			swap_put_entries_direct(entry, HPAGE_PMD_NR);
+			add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
+			return true;
+		}
 		VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
 				!pmd_is_device_private_entry(orig_pmd));
 		goto out;
@@ -2502,15 +2527,6 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	return ret;
 }
 
-static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
-{
-	pgtable_t pgtable;
-
-	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
-	pte_free_defer(mm, pgtable);
-	mm_dec_nr_ptes(mm);
-}
-
 static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		pmd_t pmdval, struct folio *folio, bool is_present)
 {
diff --git a/mm/madvise.c b/mm/madvise.c
index fbb72ab49aa64..70acb39b8b3dd 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -678,7 +678,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	int nr, max_nr;
 
 	next = pmd_addr_end(addr, end);
-	if (pmd_trans_huge(*pmd))
+	if (pmd_trans_huge(*pmd) || pmd_is_swap_entry(*pmd))
 		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next))
 			return 0;
 
-- 
2.53.0-Meta


