Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 555061090220
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4DAA6B04AC; Thu, 19 Mar 2026 09:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24A86B04AE; Thu, 19 Mar 2026 09:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B016B04AF; Thu, 19 Mar 2026 09:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83A576B04AC
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28D971DBAD
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:28 +0000 (UTC)
X-FDA: 84562821336.20.E750AF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4D9DA1A0023
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H6ekloSc;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6P7KYmk1RZi32xAF9mG7Xc6qamTYhnsbtSTZmP7hgbw=;
	b=LiOYL1JxCoaDlqDI+dknCoU/XcmSDK2GDmpZVDT9OuqV8Nuj+OZjtyud0UAJhxRCmPE8Xs
	rTYy1fuSBO+i2s3X/MmmMhnOWY3OTJgKf/4ZouyvhpkupOYhGP0FsRy7e/lPDb3ndBts6S
	mQ3bAzAoFpTuDhpFDZ5D2DBGHFcSraY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773925226; a=rsa-sha256;
	cv=none;
	b=ShGpdjeZlocQKyEm+429DzgKQJXw7LxC5U++aFVdwIpgU253hmIJxvrsjoyfQ2bYXIuW7U
	QknXZ7bMU0Towy1MMmzhdTdI8lHMpHNW+JwzKanc/3nxpvytA7MQN3umERPJbPI2A6UFap
	8lO1I5yiCF8u/LMuxWE4XMLqvrANNJM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H6ekloSc;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69EA540820;
	Thu, 19 Mar 2026 13:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E231BC19424;
	Thu, 19 Mar 2026 13:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925225;
	bh=4y+/KaN7o4uNUZ28b17IguSawucIT3PNfW8u1Hj6ja4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6ekloScPfjc7+S4h2C/Kfoe9ISQzCEiRPG+d3JF+FigoXlec6Fd81nEe8bjTT/rJ
	 1as6udnZgmK9AqAEYiBm7LjG+KbLDyaHxQVYPO10SGCDBhbsT3l6VGDwzz/P5LxFbT
	 z+TzYOBq+QXc/tV/9vpw4hpjuIeSha/bnlsRzx3plJ5p8eXdQqA1KIyEaQv5OwREuk
	 OQXPUkO411kSJJgJ7FFy6AYN6L0AU+KvqLX/TUkJomPje6/q/ab8gDsH/gJD3KY/8j
	 kP+YZzOYTX3CL1O99luF5/DYAwEY9Cyfzj8kQe1gbLH07tECWfD0aTZTSTak0BQVMq
	 PhWCdNo7IUg8g==
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
Subject: [PATCH v2 2/9] mm/huge: avoid big else branch in zap_huge_pmd()
Date: Thu, 19 Mar 2026 13:00:08 +0000
Message-ID: <f641f0c9256d54b2266b60caa0538799ea881144.1773924928.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773924928.git.ljs@kernel.org>
References: <cover.1773924928.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D9DA1A0023
X-Stat-Signature: afxqy1pbp5h6cgd347cx5i6fpsoyedfj
X-Rspam-User: 
X-HE-Tag: 1773925226-991968
X-HE-Meta: U2FsdGVkX19wufdDVqpNxNAFPMlgAdUmRpLSXxnl3WRX4WEjkRJ/Ve1ndkcZK+j77HeUUGcKtChDmUxAjot7amYKbt7TIwny0U3oJbbMYyrgxDopt42tIsqOZsX2ZW2CANylxWoSZfibFsu/DLACRERccuPPu9cwmFXQE08Y9lMufl/j/VOHb3vNJjMhgWwXKOYc0NjoZnV4d3q6iDX6FZauJ5gNgnj3oVTSlbTw7jsLLdZctSGKpafwuhtM2O0vFgAbuwbhl5+DqJNVm9Ci1pRC8p1Pwnq5zNQLHiDX3ZsEmZ6anH/zDSWsS0PYHjDhSLCDzB6wQ6RGljv3ZWPSmRwsumKB+thZnkLpgpeUCntclC+dh2++0y+L01jfNDR97uvHyK0KlzE83lhbhhLu95NORt8kpzkyk67V7gYA19QzyEuUjhE2svfxFsxaPSrh1xCYvmeS8EMkyIHGzyaY+XXibPe1wdJ+7XlQz4qVACT68R1X9Z2fqg+qH+t8NEqKZa2jt2+OnWZGscULtesc2vwqu85UrrFfMXNAzeeNfeWVwmX5AWfk9doWc6+X+yDePPWqboyh/soS1HaCNPln2TGCG/5EMDN4aXXZQs6VVqeb+nB0jtNZbLNWS07LALMjr3VM9qHWg44LKCpAPRXN2mZlZvaXO37Ml4+F+/IOkSTzNUSCQmobl1alRdNcGrHXQlqelGmE17+1GeoCovD++ncjEivFh27rfPGhPYRSWt/xpzPvm6TGK5fbGVLvP3B0LS5zwkfNwCYhDcxk0Onh+zbKFFQ88wDYtuOtJI3OifeG5qU4uEvm2kjCJYxFvIk3I8tsy+99FOYG1UV+UKnwcmfn3sefkguIZznJknXhihj3DNdDzSUdvWt7nnSE7nNHowKntiieWiR2u4todAXi2HrvbeQL3yX+lxOpEAa0/nNzPZwBw6lGrOThC8owFK0vccXZuOtCkYABKkiFXDl
 aMyNRPaq
 HmhoYfcwfxUpF3xeFzE8VKvVD4X/5IO2NSmfIUy8Iyr6deEP3rAT7Mg1VQqOuLm4eJBfPUzyywCQhEF/O1gYyuP+htWQGHlH1oPcWGkIEDB+hFyji/ANAvHtjNj15KRjuoEvfgLQCqfVbWj9XUPQ2zpfIupWFR8dco8A541D1/fQRVaiEUekvB6oQT8eEjf0TxLx1kMPyBdE+RavOb/iIoNzwSME+9e5zUcRDjTPEWABX312/X92Ur+9nP1v2dHkQOzSndKaJgaRgyK0tqTRsuxJozdy8ZkC5mdfzZurIXK+UhGIob3BB+KC8IW0Uc0jPFYfFvbs4+mqB5nI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need to have an extra level of indentation, we can simply exit
early in the first two branches.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
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


