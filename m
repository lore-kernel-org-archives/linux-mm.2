Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDF391077618
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0536B031E; Wed, 18 Mar 2026 16:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B82A6B0320; Wed, 18 Mar 2026 16:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CDFB6B0321; Wed, 18 Mar 2026 16:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7386B031E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:40:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D6E6F888FB
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:06 +0000 (UTC)
X-FDA: 84560350812.24.8D12F59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4B907A000D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dNk7YNpO;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773866405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qPd4o8ysIHljpg6kxsadbRQQbgTxMxAfwyGxuGa+Q8=;
	b=1Kudsvbv/VL1Zp2eB8QwJ9Fl8LKiSxCYvGUEq19qDd8Q/+6pWYPhAjnXg1PSqJTXlZ4H0K
	LLFFwuPtBK2/oHRczKDyH2aiFjLbwpSVXrgDWebMP4pGw7UDLq/9wWqKpRsVoPfGDapYvD
	910LpebyJAWn5yYWUEyc5Ykipj/of2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773866405; a=rsa-sha256;
	cv=none;
	b=tFn3kztwmlz3GheQHhSsTDQqF9Ky0vWvo67KbREbbJiPa0Wo4PO2EPyVh8D75N4n/PYJfq
	01S1Zn31Otsg9fVZLzfhLTgFpMy5wsoPQclDzgdkc3r/ae2ldcTx8kD67ffcDCKwJZgoU7
	tTfA6PzG0957Fcv8Xaj6jN83tIYgT2M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dNk7YNpO;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD7D661855;
	Wed, 18 Mar 2026 20:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F280C19424;
	Wed, 18 Mar 2026 20:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773866404;
	bh=/BZKRHWTrmwni6hMvARLgtvWyItsLi87T5oiCEhDDRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNk7YNpOW+pv4P+2l27X2/icD0/NxcJ921AC8DS6z39Slv9DqzhAXbWgPIsSWn6r/
	 rJ3jqrKwviThEq8g/mo6h4ZQj4EnZW4ZjFiI15vHcV1toqvYQLm8wLNCcysSQ7wZiB
	 qzfvjqTE5Wg6x98z2qpWrza6Gsxl7/5tCtEXHBi6PRh6hPsiXtma64fkrZt7yVMqqw
	 j4prB1i7ERZQEfXi/rk3utBZImLtREU1BAO9h4J0gSCnduQ2jcycSHDf1Q4y3B4MyR
	 h6vLN2Wq94SBl4FMFR3yLVwdyhEllyNz/u9oXvphiLnEG9T72IWycl2YWIKzg2/oxs
	 ltlXs/ZDvoeVw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] mm/huge: avoid big else branch in zap_huge_pmd()
Date: Wed, 18 Mar 2026 20:39:24 +0000
Message-ID: <10be43ead023e9f65333bcaf4064d9d197111405.1773865827.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773865827.git.ljs@kernel.org>
References: <cover.1773865827.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B907A000D
X-Stat-Signature: 6tt78y3srbaz4s4wsmcokwbgosyrjy6u
X-Rspam-User: 
X-HE-Tag: 1773866405-345883
X-HE-Meta: U2FsdGVkX18z8ca5dmEInmmx4S2bx0BAhhJRVW/k2NqyWBF05WxRsmdaQQYgcj7g9HqesnMPzSmGq1+txGhWAC/11DbMKInaKj91YISnMDXlAAcyJg8SmKEkB6I/LZrSQ7SBD5KezhyrpWnqGnRp26ZgBK3wgbMyfhViaYhdM9kueKq0IbarLCkip0b/paxTM8wOGax9odvYCNFN0sZESi99zLjK7P5QKAdj3lwYRXLEwFMTOqKoLQQ33keVWMrjzfmkN1h9s6b2+lqWgxN8tgQZ09CzVvBILwmujeM8T7YCFe3FPkTUYGaifRDNbAmUsSFSHjz4kb45jV942PlV0g6pr/JnyDZrg5yO7EbbUkuf+ncnlGClyxc4iiO8BAofEQdxYt14aQT//WyKApxACU1lDclpYo7nRtaKGldx+ZjzJD+kx4UpTZn9uLE68FBXvBb1MyU38Ys+hvIfqgmqaWvtXEmwOYx3gKFG5rsjmbKO2lvnK62lGGGTn/zteOlpzbU3YTKxmXdBxaYAPrgu2PdegdqndeL9dtOk6RkTjBHNKirRLV4VzoB+WZlwKKImQTob5qEn7EiPicVqbcyt8YNaqotxhCdAz84knq+W/DuaOEmwGOVqEfytvdY8YNJO4uXmEJt67E/NScjYjCWVRsEpiMFc7AI6dgW3E5pg1XlsKTsK22KFohaCSlgQPk/mhHZ+r9lPPn2/4YFc3NLDKWcE6nNla5hb6O4fkUw7CSeBSwB/6zahNaE2HVPIC1jIDp+eYQtpmy2SUeSnY1WO4Qxpj4thUDsADBnZgba5+lfZmhwdqGdqzsB4WXSAXUGorJWAbIupCiCA6ge/jbZdIJ5vnrpgPwAuxcmfaQX+izYDUsDdfJcInJeS8NkUYI2Dgq6pNvxYNQinGgbHYfifb2vr+bJfGZaUtOBBm1LDjDquZnAJypU1NEhPkOhoENxTyf9xEX1MU/EKFI48h4T
 pFOrFrzw
 /6bmCakN8ph+OYjNuHzCxl+aDoZzKLW5TBigfJ/1TcGKs4ST3uFvpV4sMtyrN+PInqaSUwoirhY0amTkEoRcLxk8G+JSx/VOJpdy/FsDokFUSJaIh+LAk1zWq7aYGAu5Qz7fZEFqaM78DQ+R+exuuMpmdVYRMRFyqQpw3jOMt9X5PFx7VqXzIMQfiF63ughk7sbBly0SZbh9DanF3/+GiKfk5Z+iw5TTrhdcTGDEr12BCrTcCPQU5gNeHYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need to have an extra level of indentation, we can simply exit
early in the first two branches.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 87 +++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 42 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f76edfa91e96..4ebe1f19341e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2421,8 +2421,10 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
-	pmd_t orig_pmd;
+	struct folio *folio = NULL;
+	int flush_needed = 1;
 	spinlock_t *ptl;
+	pmd_t orig_pmd;
 
 	tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
 
@@ -2443,59 +2445,60 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-	} else if (is_huge_zero_pmd(orig_pmd)) {
+		return 1;
+	}
+	if (is_huge_zero_pmd(orig_pmd)) {
 		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-	} else {
-		struct folio *folio = NULL;
-		int flush_needed = 1;
+		return 1;
+	}
 
-		if (pmd_present(orig_pmd)) {
-			struct page *page = pmd_page(orig_pmd);
+	if (pmd_present(orig_pmd)) {
+		struct page *page = pmd_page(orig_pmd);
 
-			folio = page_folio(page);
-			folio_remove_rmap_pmd(folio, page, vma);
-			WARN_ON_ONCE(folio_mapcount(folio) < 0);
-			VM_BUG_ON_PAGE(!PageHead(page), page);
-		} else if (pmd_is_valid_softleaf(orig_pmd)) {
-			const softleaf_t entry = softleaf_from_pmd(orig_pmd);
+		folio = page_folio(page);
+		folio_remove_rmap_pmd(folio, page, vma);
+		WARN_ON_ONCE(folio_mapcount(folio) < 0);
+		VM_BUG_ON_PAGE(!PageHead(page), page);
+	} else if (pmd_is_valid_softleaf(orig_pmd)) {
+		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
-			folio = softleaf_to_folio(entry);
-			flush_needed = 0;
+		folio = softleaf_to_folio(entry);
+		flush_needed = 0;
 
-			if (!thp_migration_supported())
-				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
-		}
+		if (!thp_migration_supported())
+			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+	}
 
-		if (folio_test_anon(folio)) {
+	if (folio_test_anon(folio)) {
+		zap_deposited_table(tlb->mm, pmd);
+		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+	} else {
+		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
-			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-		} else {
-			if (arch_needs_pgtable_deposit())
-				zap_deposited_table(tlb->mm, pmd);
-			add_mm_counter(tlb->mm, mm_counter_file(folio),
-				       -HPAGE_PMD_NR);
-
-			/*
-			 * Use flush_needed to indicate whether the PMD entry
-			 * is present, instead of checking pmd_present() again.
-			 */
-			if (flush_needed && pmd_young(orig_pmd) &&
-			    likely(vma_has_recency(vma)))
-				folio_mark_accessed(folio);
-		}
+		add_mm_counter(tlb->mm, mm_counter_file(folio),
+			       -HPAGE_PMD_NR);
 
-		if (folio_is_device_private(folio)) {
-			folio_remove_rmap_pmd(folio, &folio->page, vma);
-			WARN_ON_ONCE(folio_mapcount(folio) < 0);
-			folio_put(folio);
-		}
+		/*
+		 * Use flush_needed to indicate whether the PMD entry
+		 * is present, instead of checking pmd_present() again.
+		 */
+		if (flush_needed && pmd_young(orig_pmd) &&
+		    likely(vma_has_recency(vma)))
+			folio_mark_accessed(folio);
+	}
 
-		spin_unlock(ptl);
-		if (flush_needed)
-			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
+	if (folio_is_device_private(folio)) {
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
+		WARN_ON_ONCE(folio_mapcount(folio) < 0);
+		folio_put(folio);
 	}
+
+	spin_unlock(ptl);
+	if (flush_needed)
+		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
+
 	return 1;
 }
 
-- 
2.53.0


