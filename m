Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9699ACDC165
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05A0C6B00A2; Tue,  6 Jan 2026 06:52:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0378D6B00A3; Tue,  6 Jan 2026 06:52:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C9F6B00A4; Tue,  6 Jan 2026 06:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D438B6B00A2
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:52:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2CEA13B1A3
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:52:01 +0000 (UTC)
X-FDA: 84301375242.17.310737A
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id E6915140012
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:51:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RJK4rD9u;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767700320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ASH9sKA9CqH12pO8t+a39xF1o8l7wjDesRLJzYo7jDg=;
	b=6sWELMX4PtvEnSHaLXDvJhaJ85rvm+7Q4ZtS/OrdaozuirHFUs627UFkuLr3b8N0SnXq0M
	kz0Ptp6/d4SQ3japLEY+EgzgZw5xff4iqjS3T9i+NQApUPBUbgwidaiQRg9bcx5eGBsNN2
	hCBaZ/M3ojrvSsPwrfRCnWL4tXXjiS4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RJK4rD9u;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767700320; a=rsa-sha256;
	cv=none;
	b=shvMxXxRAvZvRT2C3RrIg8NbUeNbz+1QRKCXIkHYuT/x8pS8d5e487l702pc7NyqtAjDxM
	qOt6ba05c5ouq4uLRA85cCAZ0l4aH/HGvDyEvPIupDF2v+7fxHPId43EaV7wGX12QNb82l
	1CEqkpCLwRJaj9DlVX+AeCiCv7/xVuA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767700318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASH9sKA9CqH12pO8t+a39xF1o8l7wjDesRLJzYo7jDg=;
	b=RJK4rD9unB904yjqG7YtH7GMUxlSQosNsESRT1mysjrtG6iWRY3XfoCtx7wfDR1mUmSENh
	K+7ytPQIYIEbfTgBvfJkgXXfFELO3BA5ZjkqVX7i7ZOvSqJwQPquL2YZYJTGL8V/otYdqC
	m1zIidafAOa/1RV1YpAD9A5g+Pv1s04=
From: lance.yang@linux.dev
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 2/2] mm: introduce pmdp_collapse_flush_sync() to skip redundant IPI
Date: Tue,  6 Jan 2026 19:50:53 +0800
Message-ID: <20260106115053.32328-3-lance.yang@linux.dev>
In-Reply-To: <20260106115053.32328-1-lance.yang@linux.dev>
References: <20260106115053.32328-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: utqs3sf5coj557bj933rub7q6a715jqm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E6915140012
X-HE-Tag: 1767700319-448253
X-HE-Meta: U2FsdGVkX19uh7uOZydhq2CIPqOg+Kgu4rPM0UsjJTuDCnbHloXbqdCPAS2kczlWN4jmyKZ0SzCEoF4OXPY0czlzervsAT19jcjKIFsReRr5rpJC03mJ7iYB+M6EcZjTosh3DPeFMg1Gz9L0zLMqj6zNJSbB2er4R71sLn7IG3BZFIweDkR5DjWz4fPbe6eOyiilXIowAOfHbtED7JEmBZED4whimzdQ8c+dSzGQXjGIGUhWy2lXQphQ0xeloBzU4kG7sI06Z/41oNrp+F1O/Q4XsTpIJqnbquy5paxuwlFwsIITqfa719IMguKM022sYYu1mANJFQQMOUxqxA12OFqtURkrI/wWZXAyu5ti9WpYAbaLPpoDmoH3xu+Y4cJoD9inC7pLGkQ3SyFupvXodOraDu+gYaaNIuYkJ+sLee3HdadVb+MyY7R08dd7Ucko1vS0e396aCsFi81UYmJgSYQyA6Q+PfuNQS1W/GPgs80ci4uBtoRxg2IT1NDNjSIS1FZz9uJ1lyii8tA/tNlcA+wSd5hHTNUqztWWuK4npSkFW32dmzjBojDxZIC8ClITNYeQqZnDk7+yDUe7yFNsIP9WJULfjLP7LkpAPFe62DKbfMRxJK6GDuGx6SP0GAH6SoWMiv/nU6wG35fdeadLP+GmOSFRaGcC11l3iPrqfSHtu7HSfEJ5domXcB61RvePvQezF6ojw+ubkGVg9d1xlmTRxEdzKCFDq3tzJRMjG7rLrXj6nMm7n/kmO99M3PA+699Mbz8LHYmFtFkh6NgqYF5TEMt3zXQDtHmV3+G1DQiureAnj8QMOZIsigFfTye0I4trM1kopOctqtSCZoNDRNzKBBvOSfd8w/LAVVUlOeGvp+gAGk5QQ1dp97LySlgzaVV0fK3lrOyfhmCbmFoaWyT4yj/7bxHtSxXlsNHEeiVlCCZc5S9x250pF2Foz1rjEuMrkHG6hjfGvPEksjP
 f0gtVB9f
 g6axwu3EQHZUloAZECa9xMsJ9Y2xpDAuLaVXuGpm7did3BiWa5s3Cy+vh3WmYmUTelzFtUdZSgpXFB7DoKrN9dvZntKHGMlWDF5AjhwBDozoMomzhh25p8sl/Go1G5EoBDsHaxLyrA3jxx16nXYqxUp5VdVPLajGSHFc+YwCuTZKupe2Un63zvuYjzzSEd23K91mexIyMXa8OS/bNHm+Mhlo00kD/rLhPL6F8zzCrlv0lQkv+KiuPV2ZjV4bqc2tcXNPsnftCAYqAMPqDQHHfgLjO4oEBHS+z/7e/sbd10glKFpA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

pmdp_collapse_flush() may already send IPIs to flush TLBs, and then
callers send another IPI via tlb_remove_table_sync_one() or
pmdp_get_lockless_sync() to synchronize with concurrent GUP-fast walkers.

However, since GUP-fast runs with IRQs disabled, the TLB flush IPI already
provides the necessary synchronization. We can avoid the redundant second
IPI.

Introduce pmdp_collapse_flush_sync() which combines flush and sync:

- For architectures using the generic pmdp_collapse_flush() implementation
  (e.g., x86): Use mmu_gather to track IPI sends. If the TLB flush sent
  an IPI, tlb_gather_remove_table_sync_one() will skip the redundant one.

- For architectures with custom pmdp_collapse_flush() (s390, riscv,
  powerpc): Fall back to calling pmdp_collapse_flush() followed by
  tlb_remove_table_sync_one(). No behavior change.

Update khugepaged to use pmdp_collapse_flush_sync() instead of separate
flush and sync calls. Remove the now-unused pmdp_get_lockless_sync() macro.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/linux/pgtable.h | 13 +++++++++----
 mm/khugepaged.c         |  9 +++------
 mm/pgtable-generic.c    | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index eb8aacba3698..69e290dab450 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -755,7 +755,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
 	return pmd;
 }
 #define pmdp_get_lockless pmdp_get_lockless
-#define pmdp_get_lockless_sync() tlb_remove_table_sync_one()
 #endif /* CONFIG_PGTABLE_LEVELS > 2 */
 #endif /* CONFIG_GUP_GET_PXX_LOW_HIGH */
 
@@ -774,9 +773,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
 {
 	return pmdp_get(pmdp);
 }
-static inline void pmdp_get_lockless_sync(void)
-{
-}
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -1174,6 +1170,8 @@ static inline void pudp_set_wrprotect(struct mm_struct *mm,
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp);
+extern pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma,
+				 unsigned long address, pmd_t *pmdp);
 #else
 static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 					unsigned long address,
@@ -1182,6 +1180,13 @@ static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 	BUILD_BUG();
 	return *pmdp;
 }
+static inline pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma,
+					unsigned long address,
+					pmd_t *pmdp)
+{
+	BUILD_BUG();
+	return *pmdp;
+}
 #define pmdp_collapse_flush pmdp_collapse_flush
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f790ec34400..0a98afc85c50 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1177,10 +1177,9 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * Parallel GUP-fast is fine since GUP-fast will back off when
 	 * it detects PMD is changed.
 	 */
-	_pmd = pmdp_collapse_flush(vma, address, pmd);
+	_pmd = pmdp_collapse_flush_sync(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
-	tlb_remove_table_sync_one();
 
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
@@ -1663,8 +1662,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 			}
 		}
 	}
-	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
-	pmdp_get_lockless_sync();
+	pgt_pmd = pmdp_collapse_flush_sync(vma, haddr, pmd);
 	pte_unmap_unlock(start_pte, ptl);
 	if (ptl != pml)
 		spin_unlock(pml);
@@ -1817,8 +1815,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 * races against the prior checks.
 		 */
 		if (likely(file_backed_vma_is_retractable(vma))) {
-			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
-			pmdp_get_lockless_sync();
+			pgt_pmd = pmdp_collapse_flush_sync(vma, addr, pmd);
 			success = true;
 		}
 
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index d3aec7a9926a..be2ee82e6fc4 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -233,6 +233,40 @@ pmd_t pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long address,
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
 }
+
+pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma, unsigned long address,
+			       pmd_t *pmdp)
+{
+	struct mmu_gather tlb;
+	pmd_t pmd;
+
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	VM_BUG_ON(pmd_trans_huge(*pmdp));
+
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
+
+	flush_tlb_mm_range(vma->vm_mm, address, address + HPAGE_PMD_SIZE,
+			   PAGE_SHIFT, true, &tlb);
+
+	/*
+	 * Synchronize with GUP-fast. If the flush sent IPIs, skip the
+	 * redundant sync IPI.
+	 */
+	tlb_gather_remove_table_sync_one(&tlb);
+	tlb_finish_mmu(&tlb);
+	return pmd;
+}
+#else
+pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma, unsigned long address,
+			       pmd_t *pmdp)
+{
+	pmd_t pmd;
+
+	pmd = pmdp_collapse_flush(vma, address, pmdp);
+	tlb_remove_table_sync_one();
+	return pmd;
+}
 #endif
 
 /* arch define pte_free_defer in asm/pgalloc.h for its own implementation */
-- 
2.49.0


