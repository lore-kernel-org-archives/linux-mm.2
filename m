Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED031099B2D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198616B0096; Fri, 20 Mar 2026 14:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149556B009D; Fri, 20 Mar 2026 14:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011086B00A0; Fri, 20 Mar 2026 14:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E4B546B0096
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:07:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4223C1895
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:41 +0000 (UTC)
X-FDA: 84567224322.20.347493F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id F3D6140007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dwMPvtMm;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tm/R2V/H8+Oyho6kBy5QIhALI1GDUgVNz7KJPPpShtw=;
	b=M71jASqNCCBQwOROegE8ULLL01WHMO8nUft41qAXoagCrdA31Q6c4Ht2C/yDtKWWDufXHC
	QCcoh6YPinJ7QA76/cOSJyJk1EbcHJH9qCrzmYGmCgIXS8hhjQuim9tNSxqj8AmnQO6/HD
	09DF6QB6HNVDPQw/rrveI5yfZ+5FBDo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dwMPvtMm;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030060; a=rsa-sha256;
	cv=none;
	b=yT1Rx01xSO/vXeskvawsCOgmUS+UZOtJ8Gmk3xSjiQNXpMuIIevjdL7AMYMOsyz0+8yMPf
	5v2bPNREXUD4N57rMf/C8ldhhnz3wleJh5XDQPL9UjlAoE+8PCc27xk8Qkt6lZJ6DuBV3u
	F6rcgBrvu6v6Z3xBU4R1Ph+ykl1Fg/o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 27F2142AE7;
	Fri, 20 Mar 2026 18:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96194C19425;
	Fri, 20 Mar 2026 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030059;
	bh=XUJkWVB3zKGz0f5aKQPRTsHRbbcmexMUG5ohKhs002I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwMPvtMm8PDwhuywgcTI8jcb1ncAxe3d8tmnub93/x4ITsJAKdzpERxWuHLv/R7/N
	 suKI54oXZXQ3U0Nw23+e0BRnDexcTyYcre6ka0k12DZPHN2poqkNcitacbfI4t44He
	 yi2C90e2NLrd96zNnp8mLyMhDn7yiU0Mk1TIA6VG5hRVWPHl9GNAWo4U3VwSpgHXYg
	 VODla42wqhwn5DkPhEKSExIVe+pGRVmrou9CbyTY/NkBXiOMZwT1wOzYzFs26MAKgu
	 KJ3GZdlPcJoYuVZ7wxrfUlThcVWTdiM9TyngF7jnb1pE3RGak+N9GCYy76zCS3C8iQ
	 4kHGHV66ClQMg==
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
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/13] mm/huge: avoid big else branch in zap_huge_pmd()
Date: Fri, 20 Mar 2026 18:07:19 +0000
Message-ID: <6b4d5efdbf5554b8fe788f677d0b50f355eec999.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: es4f9bkc36hfnppff85mbtegsbdmttja
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: F3D6140007
X-HE-Tag: 1774030059-35763
X-HE-Meta: U2FsdGVkX19aXCsJSls9/7UJmvXNJLkvr+wS7t//blXaZVh33owUjDacR33qJxZFj9bSeFSpA+ylEFR15eQ9oLx30iF5gaWscbvggzeamxuh/BY/wwut8i+oZx9ipkcvqOkULNLx1WnPDdZtyvHzMHmEAwUd9RQvk2Sol49r1PoKSOxGCCN8CMDE3IJDdWe1ieH5OPRibmcpSpP+uPkzH4eMXB2Ls9VqxuWsI+yD7qqtPQ5GaWTHRR8uGyomc+vjI+HmpD85ML70k/r20zsNsuTzlqbFoSrdYG14OGJkuTXdh86ouAU72XnT2wo0+PtSoZ6GUs65cBouSzxM6IsW4A1RssU4eigB+RKgXlggatg0eynsMdkuTe2cf8EChT8EVstLH8rd2le+tgLcoS5G2BIBTE8ZuOlg6/Di74ywApBq9+w51LG7ybHQ5ICPSsfMqLhoX2ta//89l6UzvRCbyeF/o2lG71a+YU4etYA4HNYzj5xpDdzyqh5h/PdLb3quI5IOX+D18JovowuMmP3bEwOHD2Jofyl0AsfoeGbAXtOxwaEqCTrTbT0T4YlKdXgfwj8tMD5s8SJ1Ep1c8JEWybGmeWqMHHuokCnaRXI1iEuEUEEyr/btqpADssWvXVLnGbMsz18+ZlFM7lqno1doM7Qt3oZ11sA/WBPNeIs+fe/ZsoA8gbJCw9+d2ccnFOn55yxJxFJstVwULdpbX+eBbrAUFjmE9Gx4gKJqebRiPBXdNRm0XLf5QfehutFhizR766cNGw1nhF1PHQEb3F4WLyJtIG7VxjfaJG1qd3+72Q5Q3/kfi68h/8I2dQPrzcJ+vOUPpPwP/4Db1jWoCtBtjqeGSDen0QmitIZX2LzHAUgk02iPbgGxMNxtxGJJi4xJ9LHT+rcyQju0sMQF+xkRbibEOA+9pmmjT/SPTs7E2rcFlE037PEa7hCQVlhBtBEJA/c/YpF5Ay1ytvHGdOd
 KbbhkT4R
 3G2xUUH+aABUAOV3POdGTRzB3hdUNRNQuoha0/SC3c9yEIGrtZ8uIepsuoRXHznXPtyhjTTlz9ks6f6WEE6JSj+zBe1nI+6320IvckHXy3nZPXN1KwQ/k2xrgvSxQnpwzxpFzQWlkbw2a15/4Ka3plG5f9gdr06UQRaZf1PvQhm0A135OeYVOOvR3J/uZ+6G+cS8X+ZpA0y0gpvo4sR5qq+rd/En81G5OZxJPVRNnfgUZCRHhkRN5ndbtg+2sXeot4Sm11e1vpkwYkcASd8mbA9Yif13Eo2+ieiPe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need to have an extra level of indentation, we can simply exit
early in the first two branches.

No functional change intended.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 87 +++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 42 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2775309b317a..4e8df3a35cab 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2328,8 +2328,10 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
-	pmd_t orig_pmd;
+	struct folio *folio = NULL;
+	int flush_needed = 1;
 	spinlock_t *ptl;
+	pmd_t orig_pmd;
 
 	tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
 
@@ -2350,59 +2352,60 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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


