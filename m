Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC6A606A33C
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 03:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=pTYh9XOh
Received: by kanga.kvack.org (Postfix)
	id 5C8B46B0292; Wed, 21 Oct 2026 23:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A12C6B0295; Wed, 21 Oct 2026 23:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DE036B0296; Wed, 21 Oct 2026 23:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B2B76B0292
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:47:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86FAB1A070F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:47:47 +0000 (UTC)
X-FDA: 85348878174.16.F4F8301
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9505AC0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:47:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=pTYh9XOh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792640865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGcAsm2Fdf4fA3iYp2iJ468MdCKcNJG+g/TQikU8VjE=;
	b=zP8TruL5FzApdmaGCnJnRyXwZDnAyP+WwHAIBU4wF4oasDyQU7tYFEE4p2noWvB0JD3eN2
	j04qIRIDy3JpvNXeeP660EWH742KTY+Yx3cPzWHywuVOBbnS1boVvt4JHQJglRD1JcFRGR
	bwOezo2D10c4edaCSbg+L/qKWTz0hMA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=pTYh9XOh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792640865;
	b=GRCKMFERFYyEOABvBnN9POoiL2YUG2sO3DfQAu4ki7QJ2el7p2e8b7FMqSEdjbyxpcT+UH
	gr1yC4GpyalnjgqZSzAOvIy2S8VL7tF7tQ87g9PsVIcKGE9gao2uZMo17626vs8NhD5zif
	K0InrMdQ9OdQmD2oubKy/npA3kl97q4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792640861; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=WGcAsm2Fdf4fA3iYp2iJ468MdCKcNJG+g/TQikU8VjE=;
 b=pTYh9XOhZvvQm45qVB4SyZQC/Rr5ZBPu6Q37UakLO+g/O9hZZ7G6Kca8Gw+XJb5ujf2TdX
 744RVEZJymB/4lCPnXQPH+e6ZLadmFSKhtZFYG7MjsSsK4h/SpFlRHT2mHpEE/UqUJ0Kf8
 v7Y2cJD1aL6K3lqmLP5RFJncqThy9xYYLOP8lE296EZ2/aPVtTSeCmhnX+O2blsre1dAW4
 +s7vG/fFDZNqg6q+ulNyutNWjrKo+0pCOFGh3JPc3gd6gVjzMp92liMkoMXUXbJ2Holy1g
 FWlzI7RytuWx/UybqSV2azw9OvMpyDg6qy8WGCL8lSFe1i8zc9EFB/KTvOOW1Q==
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v3 3/3] mm/hugetlb: fix mremap deadlock when PMD sharing is possible
X-Lms-Return-Path: <lba+26ad9875b+35bff0+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <peterx@redhat.com>, <rppt@kernel.org>, 
	<azpijr@gmail.com>
Message-Id: <20261022034543.51226-4-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20261022034543.51226-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>, <stable@vger.kernel.org>
References: <20261022034543.51226-1-lizhe.67@bytedance.com>
Date: Thu, 22 Oct 2026 11:45:43 +0800
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9505AC0003
X-Stat-Signature: sbex7pggikxi5ctu551bqke7wjk78mui
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792640865-977520
X-HE-Meta: U2FsdGVkX1+a6HXosbobEmxEcHu7X8+ayKdZvBol3SBh8qLT9dYxKx6/WZ6bxfjhjTGex8YnhMaa3e+sLIdwpCoh/1giKLFiNmanW3qTxDGnYn1TXn778wi8il/0cErAkc+I6IKUDRoLd5eaOsuJw2tvU3PblaxgK4MlRrSvCShnsLrQK9ZSoUMRKWCPZXZVE8uYv4qDB9es//m0PzsrX/pLDRjJyrnbbnyhWILK40G7EBtMvDTc3oEbOuqhl/k5ZadjxKyG5SRBYbefEBMqCs3EdU3hHei832qm+kJqFAWDfDA57OuGXansCYF0emcMvCuyUqx/SCU2ED/3OfN9ia498EyZMe3SDcDa2NarmpLyiBJfJxQEOgRXwtfwMkSOka8xftdDH7NGlcIj7KvnDD4KKF0eK8u4dsOo80ewMwS3eja301hbkIDt+8QpibqAKArw2N1C4Ztz1rYgFapo9D/6/rlPzxnw3Un97l6XeOsJyrVk1YulvJFXZNv4Ir2QqQ/PJZY4yBFGTfgQe5IJoFB9Zm4gkuV/uGQd4oLmxU7vTza2Wkdl9HdRDOIaf/MSee5F4C7gpUrR7D98wNmfepAuf/ZNpNWJaS9+KzTeVxshnPY7Kp0PDIH2w8ytTUfjYB90g7wle15+FP55s678O0bAs1u0NlNw/RLnGGPjiSo2rCSJjCF7SEzw4NrJW6O1+cdOIhhA+nTls/QjcOpSXmVgOQ9U3PFcWGqeB5tjYgVi+NRzzNSp0hcZxGQ0PUPAhWRcP/F1eO6vVV47L7UVqqHddz62dK6SBvzwQSAx1IUH5ydyNUWxAGk2nSr/AEE0HJfgws5ByGtDGkgs0U8+SdU7kroAvNGff4TuZqbl0DwLlVntKyb/344+E8jeSJOtaHyAs6XcdkRRsvE/+rTQwR6KZ8fZYOl37mnGfZrDa/0/s4YTakZvPTyD3VOUDdRRk1hX476PeYuIkdEnJur
 ZRFoKkLt
 GryXoWbsEZC+/8jOmt8KkQUNt+f3fJXJhQ9hdsgwzE8CEmkbLbSDzAK1AtZT56toGAKcdsS8zeCfY77nfY+xmYDC+VlJijPguu/aHAIePFLZgUhtqCjQGxJ/x60Ob4eYSNpO3NvlVvgENtbPtLX+osm6SpM2xfqoL0nFdeC4LUP7Z/GW9X26hGMc4ppfbSkdgqPgpNdzpv3FjthE1bdJFIBIJXEAmkpI2B9y+BnnfM+Dd6/IEVhi3dWQHk6T5ueRYBl1MIqvniWxbTiCR8pgmrUfP1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_hugetlb_page_tables() holds the mapping's i_mmap_rwsem for
write while moving hugetlb PTEs. This prevents races with truncation
and protects huge_pmd_unshare(), but the move loop must not call
helpers that can acquire the same rwsem for read.

huge_pte_alloc() can do that when the destination can use PMD
sharing: it may call huge_pmd_share(), which takes i_mmap_rwsem for
read while searching for a shareable PMD table. Calling it while the
move path already holds i_mmap_rwsem for write can deadlock.

Avoid that path for PMD-sized hugetlb mappings that can use PMD
sharing. Instead of allocating or sharing the destination page table
while moving, zap the source range and let the destination fault path
populate or share the PMD lazily.

Reuse the hugetlb unmap logic for the source-side zap by splitting
the core loop out of __unmap_hugepage_range(). The wrapper keeps the
existing tlb_start_vma(), tlb_end_vma() and huge_pmd_unshare_flush()
behavior, while move_hugetlb_page_tables() can reuse the unmap loop
with its existing mmu_gather.

Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Cc: stable@vger.kernel.org
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 47 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3cc33ac85a15b..dc6fc3fe4d4a3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -124,6 +124,10 @@ static int __huge_pmd_unshare(struct mmu_gather *tlb,
 		bool check_locks);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
+static void hugetlb_unmap_range(struct mmu_gather *tlb,
+				struct vm_area_struct *vma, unsigned long start,
+				unsigned long end, struct folio *folio,
+				zap_flags_t zap_flags);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
@@ -5171,6 +5175,8 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
 		const unsigned long offset_to_last_entry =
 			(old_addr | last_addr_mask) - old_addr;
+		const unsigned long offset_to_last_dst_entry =
+			(new_addr | last_addr_mask) - new_addr;
 
 		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
@@ -5187,6 +5193,24 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 			continue;
 		}
 
+		/*
+		 * Avoid entering the destination PMD sharing path while holding
+		 * i_mmap_rwsem for write. Leave destination page table
+		 * population to the fault path, which can share the PMD lazily.
+		 */
+		if (sz == PMD_SIZE && want_pmd_share(new_vma, new_addr)) {
+			const unsigned long unmap_size =
+				min(old_end - old_addr,
+				    offset_to_last_dst_entry + sz);
+
+			hugetlb_unmap_range(&tlb, vma, old_addr,
+					    old_addr + unmap_size, NULL,
+					    ZAP_FLAG_DROP_MARKER);
+			old_addr += unmap_size - sz;
+			new_addr += unmap_size - sz;
+			continue;
+		}
+
 		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
 		if (!dst_pte)
 			break;
@@ -5206,9 +5230,10 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 	return len + old_addr - old_end;
 }
 
-void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
-			    unsigned long start, unsigned long end,
-			    struct folio *folio, zap_flags_t zap_flags)
+static void hugetlb_unmap_range(struct mmu_gather *tlb,
+				struct vm_area_struct *vma, unsigned long start,
+				unsigned long end, struct folio *folio,
+				zap_flags_t zap_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	const bool folio_provided = !!folio;
@@ -5226,13 +5251,6 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
 
-	/*
-	 * This is a hugetlb vma, all the pte entries should point
-	 * to huge page.
-	 */
-	tlb_change_page_size(tlb, sz);
-	tlb_start_vma(tlb, vma);
-
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
@@ -5361,6 +5379,15 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (folio_provided)
 			break;
 	}
+}
+
+void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+			    unsigned long start, unsigned long end,
+			    struct folio *folio, zap_flags_t zap_flags)
+{
+	tlb_change_page_size(tlb, huge_page_size(hstate_vma(vma)));
+	tlb_start_vma(tlb, vma);
+	hugetlb_unmap_range(tlb, vma, start, end, folio, zap_flags);
 	tlb_end_vma(tlb, vma);
 
 	huge_pmd_unshare_flush(tlb, vma);
-- 
2.20.1

