Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 734721099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4786B00A9; Fri, 20 Mar 2026 14:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5786B00AC; Fri, 20 Mar 2026 14:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBBB46B00AD; Fri, 20 Mar 2026 14:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BCD486B00A9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:07:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E051C1789
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:55 +0000 (UTC)
X-FDA: 84567224910.25.FEE3939
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A986B1C0007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lUFHfM00;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fEQxDxE4m0k6oHzNMM6sR4KVKu/8Zcr90D3hK9fjK9k=;
	b=SFQok4OrkhX0bNxutLeO2QLTb2HZORf4TYrAfb4EtC55jghOqYOWD4Ey4aRuGwdcq6dotp
	PuMiQjLfSVDLWuUq/hvGuumybtwsrD6cBMxby5YXXaJ6r24V6AcOx845m83DcPvVI5qggW
	JP+Z4F4LpZXdkew+uVaOdQHuTLhyMmI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lUFHfM00;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030073; a=rsa-sha256;
	cv=none;
	b=jTxgnJPVcianqWzoNzBIekal/1NiR8NNdiiJjpALmlZONcLJIYhdzkbE9f/Qhg3KpyIVOa
	lUEw3ABrTn3JwaEUP12dDHmGh/TkSpRIvabP7XHH/vLqB/JyR/XMzt4zmvys7CeE9jRMQb
	FG+gLqIXtEHh9pyMti9RU2FH+W6J6k8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1D73445B5;
	Fri, 20 Mar 2026 18:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36810C19425;
	Fri, 20 Mar 2026 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030072;
	bh=Ram9Rs4qqm5tPTEq7peh56y47e5xBm78Wi3l40G/zq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUFHfM00kM5L74fQT1thqwmi1KonthuAYbSBB4Bb9I06HZcQG7K0c/95TZDYsbqOo
	 RPikeYS+Nx2SCSHWU3PsgfHD+ra5ezwC6ymJH7z24ykI2mcIqFuaxYZvYWYr/FivfP
	 hdEW5YFLXastAizTavgbetEeY4qCCohtcxnA0aV1ZYQd5ZDSjDJU+iLUMkzTJcASwd
	 jKYEPyYDJK0weSmU71FqmJoKnN0sh7WVIUrQY7nUfDx6GptHZ44AKs6b1BaQvaB+WN
	 sp8J+c3mFcejdvhFYFPxRp0+AtBDkk9vi4eUzvuJmcKck86FIvUM+8WwkMBlKrhQJO
	 PbbpruhyTOZYQ==
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
Subject: [PATCH v3 07/13] mm/huge_memory: deduplicate zap deposited table call
Date: Fri, 20 Mar 2026 18:07:24 +0000
Message-ID: <71f576a1fbcd27a86322d12caa937bcdacf75407.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A986B1C0007
X-Stat-Signature: 1w55rwbcro3rhaxesdwxoqrdtahqhzmg
X-Rspam-User: 
X-HE-Tag: 1774030073-149731
X-HE-Meta: U2FsdGVkX1/yBwngOHiyS5+akQc/v6Af8NdyzpBAPCvdbPHYc5JmLIEM5MuOS2lxrKupB/OAP6r/foc2XyUF93+8jwr8PrEtjjGQxzC22EH/n6xp+iyz5/C/3kwHfwSL4fBUSoU2KJQxaMcEJLFBiFw3OsayXlKzeU7u0j8XidSq6YV8Q1RgWHrSSOVOaiVuaMiQvXtth5HsAMxqZYtRNNFhUR6k7AQQ17sHvDPBpvDlM09DobG1Ro0BdF1z2zZfNkODOHCOWLgkfIzxooOZ+C40qU5m08mb2/qEfUiL3sueGGPGebG6PSNRni9yGCKlgW+V22RM4TgwlfnyPd/dG1FYzsgJ5F237CvqIcL1RQE/bMkaCVDXnR+Wzlry4edwuvfzzZDYFQo/tqYjnPbDuNC+ZZnvg1TQ8NM7mr34uBx81E/hZn+hNWoFnYeMwoUYZKe4gvKxUaZ4xzRbzKf19eJhLzG0Vshlp59UpcgeD43G1+6CIKyxFrNIMS1/+VMO3Rl2t7QxBm2Wve8kl8gH7h2z9KOJhx2/W5yKC/2+XTcLwJ7j5Bn2ERuCc+1eSPyvmnqg69LQMWla4AYY/J5sjZel+ptSwXWCgwul7KYDUzQY/x23UPt9ELFJI4GlkbkiViasE6vK7YjPjXJ2/LltSAMkVuTv/j/yZEzwerXJRrk6OSTOFfaJBAZdd7etmr/iiQ14Y8psAT7E60LwGuGAa6p0ShcqBUgWQRn4SG/U+SdrkhTZ+of23S+aMittOst10IBT/JGDRdHvlyMXLyg7FX2AY2kFC4o/QMzYCEJ8HUni/7967wpcsJ75mbaweXNVwnvQgEtQ34HvrekdFRAQ6z/cGeS1gQR1t3IS1JrLmltL+DkVmfbRKGufRhAiDqV82n1r5xq8bqzRj0zYv8h+mol65SqBCBS+l1zPMbRIckjg3udLSoaTFaFG3Dnh/QySw395V21PydkEqPot6DF
 xwOZ+z1T
 uHbcpdnerfSyiqEOr+44aPzVyeIkHi0LSTegS98694a50z3fqYPnkTLiSZQtkSBLxEC1tBnKqGX/B5npTXl39zXQVZzXhgcg1ulz+Mwz42AL/7rdFbmlLk2jwFmASa09BR6YSOFJ2JpFvF1zR8hxDCex8Su7nur96yCNyIK574BbHe3C6cbEWzrp24EuDi5Et3im0kNH9mNtIFWKeqyrzGDDeNohwDuehbnjrF53XLEbZlHMaQ4kDJ/mch8BVauMOHeFql/xFiiTFwDtbw7n3RFPyiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than having separate logic for each case determining whether to zap
the deposited table, simply track this via a boolean.

We default this to whether the architecture requires it, and update it as
required elsewhere.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4add863cd18f..fca44aec6022 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2337,6 +2337,7 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
+	bool has_deposit = arch_needs_pgtable_deposit();
 	struct folio *folio = NULL;
 	bool flush_needed = false;
 	spinlock_t *ptl;
@@ -2357,23 +2358,19 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 						tlb->fullmm);
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-	if (vma_is_special_huge(vma)) {
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(tlb->mm, pmd);
+	if (vma_is_special_huge(vma))
 		goto out;
-	}
 	if (is_huge_zero_pmd(orig_pmd)) {
-		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
-			zap_deposited_table(tlb->mm, pmd);
+		if (!vma_is_dax(vma))
+			has_deposit = true;
 		goto out;
 	}
 
 	if (pmd_present(orig_pmd)) {
-		struct page *page = pmd_page(orig_pmd);
+		folio = pmd_folio(orig_pmd);
 
 		flush_needed = true;
-		folio = page_folio(page);
-		folio_remove_rmap_pmd(folio, page, vma);
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
 		WARN_ON_ONCE(folio_mapcount(folio) < 0);
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
@@ -2388,11 +2385,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}
 
 	if (folio_test_anon(folio)) {
-		zap_deposited_table(tlb->mm, pmd);
+		has_deposit = true;
 		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	} else {
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(tlb->mm, pmd);
 		add_mm_counter(tlb->mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
@@ -2412,6 +2407,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}
 
 out:
+	if (has_deposit)
+		zap_deposited_table(tlb->mm, pmd);
+
 	spin_unlock(ptl);
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
-- 
2.53.0


