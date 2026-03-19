Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D6471090220
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013EC6B04B6; Thu, 19 Mar 2026 09:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07DE6B04B8; Thu, 19 Mar 2026 09:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43C96B04B9; Thu, 19 Mar 2026 09:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3E5D6B04B6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 898FD58FB9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:42 +0000 (UTC)
X-FDA: 84562821924.13.21E9527
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E5DB5C001B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dxiad9S3;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+LVsA3VrDXS6HeMzlLuEDsft9bGx73OXsRJw2p7quw=;
	b=cTqVuwKqJ8ypxbmzk6YED9TOyhfAVVucl9nVQ7vHaOgsJ3K+GwdO47NN2KJCXRzsUIcq9x
	X44g5jnwQZ1c3bRsfi/fDWy2FP9nP9N5j26vIpNY1BECDbqf280U406VLWmXK2uo8eaNYa
	XhwAJvPvjtlhAUuc5fSE71JAxQ97UdA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773925241; a=rsa-sha256;
	cv=none;
	b=mE139HorX8Ajzu9SyVOutqhsUrU6f33Ri490vd7nJrHGAKVE/soy352SS9ZYeD3gCVih0H
	OdPlng3fJ4Vxs2W3JaZlD6rYNuxRjPZZJhRTAoxRbMx4h4bP7QwNic6fLnwk7g5P6ByXC3
	7gByYdzXgGBFKVIm+KAvtpJLK25OY+c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dxiad9S3;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C84E443F4;
	Thu, 19 Mar 2026 13:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CF5C2BCAF;
	Thu, 19 Mar 2026 13:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925240;
	bh=o+lpylSbdML8A401ScmIug87esbYv315lcenpqyFup4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dxiad9S3H0CJ/OOlBfydIz2ItScNVD7AEOxS3SlYNwW60Uk/Z+vxaOyBwqCkUD2n0
	 GnnEjEwxc65D7gnXBahnHYzCkUdopJ3LqJSQPawb0m0fn65GS/dNeOuCEt/1HmBmPN
	 eS8gjkoANr/PtXnPb5I3bdwKXXr3plFPhtJ+IrtlX8LkJDxPp05uBpRqrlyXUGzO//
	 5z/nbjuZfWoPvaiVW4oIDndmEvIKCDCb1aG5dbLgufq24cDCgT9hD4s733AwYKsE5C
	 sGTxypHdf7hEN72j4kvD8Am5VZG+CVOsm1vOVF7hlyrQQgIXU4MwQCzhmzF7l3xImm
	 JAf/psSuUgplw==
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
Subject: [PATCH v2 7/9] mm/huge_memory: deduplicate zap deposited table call
Date: Thu, 19 Mar 2026 13:00:13 +0000
Message-ID: <29fa4129cd560681c67433b4c344b2c9a027d1b4.1773924928.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773924928.git.ljs@kernel.org>
References: <cover.1773924928.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E5DB5C001B
X-Stat-Signature: 3t4nihb6m1eoxm3zrqaoknbfrfhtfsng
X-Rspam-User: 
X-HE-Tag: 1773925240-363435
X-HE-Meta: U2FsdGVkX1/nPBXTIe45p8KW0D/XduVZAGwlbq3y5IdWyjPqBnWjrBSHp0Pz+6b90o60BsshP5cxR4A52N66NuDNeR/MyPJ9tSVFD2B3nIzJtW4NZZIJOw6qeNE6eZpP8l4heGA3OORWNiyFI/LxuIsTw+rv6tpxAMET2QyZE3qo6mj4nWiDH8P5I2nEeCoDlkaGOgvgcYXXmvD4+2vTcd59unYevIQR/aSXq2xVwKr8tthnirEJV1PmGwVr9fmOYiQWz/O9NLtA3UJff8sSTZvWfBsyp4TYWWezuPbC+4FymyHKY7p1Zy6MTYcZNKiUVzN9TxRdIwcvzsRCf7pvq7mcyDCUrj6bbCvzsGqTAc5pvRKru8IwL3yESh3xxct/sqVWZ+rqYwoTc+rnt0nAe9Mmc6KFdyx/vyYJu/Sq+SK7jmkZB2FTIVRli7WqmTp/R0KWO3R7O20bc2kV1IxsPwxX/E1azLA8Ou4Eg+XuhrfOsHgNwF4KjP3KniXBc225c5qgUL5F3otrcfZaLE4U/BiO1kmlDPA8EzUewqblByER1CRbQHmkUPc7oXoq9Ci19yNXeKvF5C2xbqlhBbDynkRJtn8EZGGA1UxnBBAx0R0N0mED8G4YPD+BGg8S/Ec7Je6UfI5WsJqNPzg3xySAVhgdjqGfx3IVL5eO6qBJxOnyS8aGe29uAt0+NxHhv4nbby0pe4bfYnL9GTnhpEzF7SE7vJ6srDQybEXo6n8lPaKUEbrsvyDsnyu9s6xMnH3I9C/ESwGDSzvzTmgtDmi2oP06sXcOIh9OoxHA0AKfAdmaQxde5OXIEMlF1FkjtdAAENHdDz32v089hlhZ6LEjO+QOo688WbJZfgBzySzf7olcyJBChNdufY1ngHAWMbsHU2UW9zCKYSPWi2GYZUGZ/145TR8E+mHIMIqZPUUokjTuYGQ7hPk8/xQUCm1wGT9r5XYN7T/Qq60J3E7i3Nj
 QyhEDNA2
 NvFaVEUwn+uWwaW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than having separate logic for each case determining whether to zap
the deposited table, simply track this via a boolean.

We check separately if the architecture requires it.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 499c31bf8f83..c4e00c645e58 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2431,6 +2431,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
 	struct folio *folio = NULL;
+	bool needs_deposit = false;
 	bool flush_needed = false;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
@@ -2450,23 +2451,18 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
+		needs_deposit = !vma_is_dax(vma);
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
@@ -2481,11 +2477,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}
 
 	if (folio_test_anon(folio)) {
-		zap_deposited_table(tlb->mm, pmd);
+		needs_deposit = true;
 		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	} else {
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(tlb->mm, pmd);
 		add_mm_counter(tlb->mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
@@ -2505,6 +2499,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}
 
 out:
+	if (arch_needs_pgtable_deposit() || needs_deposit)
+		zap_deposited_table(tlb->mm, pmd);
+
 	spin_unlock(ptl);
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
-- 
2.53.0


