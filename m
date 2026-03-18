Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B75D1077612
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC2B6B0324; Wed, 18 Mar 2026 16:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4846B0326; Wed, 18 Mar 2026 16:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CAD16B0327; Wed, 18 Mar 2026 16:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC2D6B0324
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:40:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D688B6329
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:15 +0000 (UTC)
X-FDA: 84560351190.01.25B32F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9B7BDA001D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OdvEiXHC;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773866413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCNvMBzovwEtO+becxY9MB9LknozawOmMQX6QrYsyIM=;
	b=AiIrEDD8a19BvYLalH0fgpNsTCuPIk+7H4ZeyxihdgiO3NNYFdh8yFQ3M3Dz4/5toY4cYF
	2E0eq27qck/+rGhtyBP9q0RBm6owc1dZCN9EgS5Kmu/TdV3Mw9g0xO5kjwFjz4QBO93HLb
	NvWtspNdZVHqBqLv+p84cl0cfetM1Vk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773866413; a=rsa-sha256;
	cv=none;
	b=Wx8RZT1Lw4rQKkC//EVOa4K74oAqHvEmQbyWXkxlrQ8hOHj1eLTOn+QBGTeqwhwzNEEzrZ
	NMd9ki7pCilEIwl1xdtqx78gJ2AaTyQLiFxetG91NiZyRt6JPkF56Eu07sZ5KKSOiGjEeX
	gCdYRDtMRaqDt2N3nP2bqWEXyG9NszE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OdvEiXHC;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B84F61855;
	Wed, 18 Mar 2026 20:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D6DC19424;
	Wed, 18 Mar 2026 20:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773866413;
	bh=PITG7FjF940ShIQWg3bTh2lmckgtj7Y/LuersIz6UxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdvEiXHCpeAbqal9LePZD/KHjW3xBrUm7WV0dIIJQr2KHDb3x/ltFr/AuEnIk2paw
	 wWs3EG2ql2D4SXuru/wxiChjn9zjb15QQsXtyZd5RhebbR0QnuIwxdd+ay4ZeggAOZ
	 Z5Lr15mPo/gj7zSTKc4lfSuIdCLYGFuYJUxAlLGtBxBuO/MVGE1+n7cQDQy2VuqQIL
	 xrUOv5aQRhpvjNwjhLxW2+IagPnKUJAmB70c8wSjPy18bHhvdTWX1N+912BbMXCTie
	 EqXMRYupVviG4B2gFzp8wzi47A1F1WH9UudPsq8jHspuEgLAIfgc6BY5906b+UR5sE
	 aNu/8gElozfFw==
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
Subject: [PATCH 5/8] mm/huge_memory: add a common exit path to zap_huge_pmd()
Date: Wed, 18 Mar 2026 20:39:27 +0000
Message-ID: <3d8ec0634fc3465b200ca678fe097097cf6ad1bc.1773865827.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773865827.git.ljs@kernel.org>
References: <cover.1773865827.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B7BDA001D
X-Stat-Signature: hyfhmbyquj6ro9wi3bio3rxo7pp1ap68
X-HE-Tag: 1773866413-14710
X-HE-Meta: U2FsdGVkX1/87RVd6NyDzlwjqPPms40aVQ17aj/aUU/eUMxE+AFDif1kFOhPYuerie1bYiiyHoZwkzI6WfQ+y4jL8x24nGc/A5NP9ailO5prhBGwOue2JmF0lyccg0zH8mivgtN6D672FFSTWNTqmKftjimnklYSb2tC1yJyhcMBZnbv1u6YABknGUBGPikYI7ciRb9mcRJByOMI49FYR3RLNeusCYVdCjDGiHYgnylgaRShENxTJhHDz3GUAJYJaMW4sRVv6Vd0UYKtTyF2HSNgcyDjq8mHclz3lmrSBAnPSyc9iqjcqRfknfANC2BMOZ9MnAf2qTnYsjLe8TZNW1ofYo4NhjLRlixQ50jkkagxmPINTys1GpUAFpTOJX0C6vH0630SuudT60V+F6mqf5lboPylDHaUs+4zrpqFoRX6A4vQg1rUg3MLm/5AIGhzt+F8kT1nn7/OMUYmMuSYDFCqubSyvzDqCpJiOoDGMXmJXGE2eJzx0BpkAjBY8TmKrwOlRAVoVGgi/7CAuf9lFUNmtWBVMEO01NKYWV5BuG111C8vOSnU78gvnUJVis97L4b2EjUbm0mhyUyEJZWut6M/J94xo9dYyRFd65FoLeFADzdL+2M2+ROOkzKlz/xc8GKiaJ+A2WIuQYfmeyTuwYa2ng8rqyXYua5ORJIaJoNlZAue8WLHftg3jg5dgk4LztKyqyzDVGOoFvxDJOujsB7jP5RuQfWitLBOjQS6ULNhXvm0LGk1R3psYhalhkPi+V2g3+H3tOp5tIxjnhkMLIvMTYevHnYzSCbVWqSiC282Ww7NFH13rl2kmXk1Z/ys+oONHNMASvhYj2rXVz67A6qidc9rjvdp+99M5fs7LLgH5EyM3q2cMcdoxfLkNOtwnBxrTmb7YwfA+Q0MnYMZ3TnDlU4J7snHUwiMjb7O5vdfcshdgXVychy1fVwO6nMRtClaxx8wype68RsuxjA
 lsGwnARv
 2ZIiSSg9GEyLAUWUumRoJpIwWbwR5M2VYNfXHhHCYmQp9woFJpj7tUqCkrRqnMXKYZzKGm/krUU254WQFVtrCWDOhLKOj2zdG1lIJNkVGYDBp0Is1r7ll2gONkPlxpDSpmFR7qft4Ey5AooCa+UBUK9Pzbvl7XVAK0lJau299DfxrR0GNN5tkBdw1GdF/5AjVhbwIeStn8odZEd4WU4bJRD1mWDCcGKBmZH2CFZNsQHPK0Zc+bIUeVDLNTarY+CyN6Aodd17b8wiyMbj5M+MKfAZ2KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Other than when we acquire the PTL, we always need to unlock the PTL, and
optionally need to flush on exit.

The code is currently very duplicated in this respect, so default
flush_needed to false, set it true in the case in which it's required, then
share the same logic for all exit paths.

This also makes flush_needed make more sense as a function-scope value (we
don't need to flush for the PFN map/mixed map, zero huge, error cases for
instance).

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e6b7ba11448..724e1de74367 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2431,7 +2431,8 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
 	struct folio *folio = NULL;
-	bool flush_needed = true;
+	bool flush_needed = false;
+	bool ret = true;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2453,19 +2454,18 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (vma_is_special_huge(vma)) {
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
-		spin_unlock(ptl);
-		return true;
+		goto out;
 	}
 	if (is_huge_zero_pmd(orig_pmd)) {
 		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
-		spin_unlock(ptl);
-		return true;
+		goto out;
 	}
 
 	if (pmd_present(orig_pmd)) {
 		struct page *page = pmd_page(orig_pmd);
 
+		flush_needed = true;
 		folio = page_folio(page);
 		folio_remove_rmap_pmd(folio, page, vma);
 		WARN_ON_ONCE(folio_mapcount(folio) < 0);
@@ -2474,14 +2474,13 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
 		folio = softleaf_to_folio(entry);
-		flush_needed = false;
 
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
 	} else {
 		WARN_ON_ONCE(true);
-		spin_unlock(ptl);
-		return false;
+		ret = false;
+		goto out;
 	}
 
 	if (folio_test_anon(folio)) {
@@ -2508,11 +2507,11 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		folio_put(folio);
 	}
 
+out:
 	spin_unlock(ptl);
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
-
-	return true;
+	return ret;
 }
 
 #ifndef pmd_move_must_withdraw
-- 
2.53.0


