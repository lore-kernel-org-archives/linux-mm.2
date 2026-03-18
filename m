Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED95E1077618
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0DB6B032A; Wed, 18 Mar 2026 16:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8E76B032C; Wed, 18 Mar 2026 16:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF9A6B032D; Wed, 18 Mar 2026 16:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D10F6B032A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:40:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 065A81401C9
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:24 +0000 (UTC)
X-FDA: 84560351568.15.107BF61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3698440011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DxUHWIwf;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773866422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uWfA2yeQCZXPwtzZgZ4kRaUb1Zk1EWg0ep0RttLwi2k=;
	b=rZnrvjFmMLP+M/QLiQNWyo4E5ZxpuhcejRwl35SNaSrHBZFNkikRxnRe9v7YjSqeqJ3ptQ
	5E6N8t4/GcxONcaeaCH7/Wnd2YE1iR5ZJCp1sEEBQ0FGGh2d2G8BCWCNmzlAp/fysw1ALv
	VTjuRpXTlsSzbwOAYYgFiyIX8UsfOoQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773866422; a=rsa-sha256;
	cv=none;
	b=Hs8cz12W0XHu1RyO4vyOkEOaoNQseRsKS3rs5a9BvElX09Lh0pEwR7xOfi6gH5kgSdjFBD
	hOF/MmfLEO7Ml0EHcPPqjPAgscbAc0uQ5TGHFqhFO2Lv33I0wqjpRmouGIoreE09/a04BK
	plCe4PavPJL50FxQqv+bZkP3YG3pj14=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DxUHWIwf;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40FDB432D2;
	Wed, 18 Mar 2026 20:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C76C19421;
	Wed, 18 Mar 2026 20:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773866421;
	bh=tBNKEPKePH5rEEJcTRad3eBiHZXAi6VWZ/qpvNX9iPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxUHWIwfNCja3hhGITdGYGgMfnGvvhVMGmciAOR/AP3E9eTKa/Jt1sibs6P5qkpJu
	 nae2V11wRFGLg5fWk8LVf5OcEWRVgWQb1TmrTqePSLHh521a//R5Pm7VmDlCcerWKF
	 r+sfCgei15flhHfFC5LdWpzEesuiI8YdeFyNwiwQp9/XXHPL63LuTzEUpsbhEOOn14
	 YXQEnqQpHxge/smqA6tixVDENxuecMZ7dQ10HOi56YxLT1a5N2LpsEz3qjXsHS/gwh
	 Bh/DiQp58C7YWKmdEp1s9NjA6L+7A1CLV2vko/qFGtqFUUpx+JyjzYuZoWquy4jacF
	 +FVuOlQqP6rUg==
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
Subject: [PATCH 8/8] mm/huge_memory: deduplicate zap_huge_pmd() further by tracking state
Date: Wed, 18 Mar 2026 20:39:30 +0000
Message-ID: <102016790a04d115dff734765caa25be25771405.1773865827.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773865827.git.ljs@kernel.org>
References: <cover.1773865827.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3698440011
X-Stat-Signature: 57natu1dkz8tg1tykaqkdinjjgets85q
X-HE-Tag: 1773866421-325596
X-HE-Meta: U2FsdGVkX19CdUy+7Y5n4r3Aa0krBr2aI11TIsZWc2TWeFDrjcsmez+uEUQ7LOUTCjOpN0PEZhAsXxbS9G2nPHgZ1/3PYQ7F49TCgFDs0TSOCdMTk6bslMNA8I96hmSfVc6DDC7xUMhMI9HmbgKqmbpRKw/Tniu9JDcRCsGxCT/gvBgQG2Cp/f93NBZBw1MMU8OO/KUxQScp2VkmRBbAfaD7aBeFOJyAR6X6jvUAlzvuXIxkTf8EppzeMj8re6D7n6rsI9IrZibOpUJziFRMptiN7S3AF2ewdS6qLCdsdcP0Gmw4Mj0fcY+uTA5Rexp7SNdqgZgwCsnbQfLggf2KjgIMiWZQnC7HXZ9aJfUc9RPdq54379lrWAfkjmfuU7d5Op1ibEScPnNoM2LR+XpyrX8pM8Xcj74gfxjfgna1aKLDMk239Z/uZGrMfw7PKWvf/ZwjB5UWN7ft+kjkLhxX7v8ayFXBSlvegIgbbDbCGuNUavpIrFBcnII/+aVs+kmNAeIG+FCXULC0HWPlIvjPzDu+7LVbVc4/Rxlem/8v9tEQv0FWph5qrROLjFF8Sx6ojHG4MW/7eXHjQtvhHiNvbC5FDe6PHHIWjP6ORFUSkm26KfYdx4qcyze7zifxx5uQb6Jf+QpMgddTrvR5oZMZxqxLyM4kmjp9B6S5JbOkoz0Wje3HhHflqQyGBIGZ8QaR2LAz9VMVvRHyBWK7JJAKVTJEeJXmnDjw5DEmFiPpK3SjhzzvddVCdX+ioUtI7Xh/1Nbz01Iw9wuPHDDPZftvPXBzk6VvIrayIwOhogZg7wlzHzyA1Resfg577ne5K15mAb6yKB+56OiEzqh82iXMvUyUM+Jg8l2+QZW5PxJvyLx2mFUb5fQhs2CZMN1ZSOCURMaKxydjQH/BlkJa8vEveO7b8PSTDuE2t//hBOBjq0BtW7g0OCqO/QMCgV4FzibKLcR295pwg6bmVFThNbn
 Don1+zmZ
 WRtHKLQuhipAZy7xrtiA2BZRG4Ja9p7z/Cg9nNkgH28J3NXkLCjgjvqqxrcVPCFmbD376LIebJO5W54A/JhwYtTko/ulVQ7zhxgx8RnRoFltxKmf2baWTDwKDphIqVBg7LdgmTn14BjlVxCgSq2GXhzSB2LFrfhVdvV94N378ndbHlTgY1haw/ADGcxO1w/Pn015DIieqaWgQOUmCUR9gSU/Won8HZXV68dAjjsyfYY167162MTTWvKA53Yix4xnf8NKP1VSu4pJ8Z71vk6de6n3SkZsgTUCBnL0GI9EmQBhFp4phdPF60tpH43DdC0otB75C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The flush_needed boolean is really tracking whether a PMD entry is present,
so use it that way directly and rename it to is_present.

Deduplicate the folio_remove_rmap_pmd() and folio map count warning between
present and device private by tracking where we need to remove the rmap.

We can also remove the comment about using flush_needed to track whether a
PMD entry is present as it's now irrelevant.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bcc74b0172fa..f6caa6d35659 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2430,9 +2430,10 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
+	bool needs_remove_rmap = false;
 	struct folio *folio = NULL;
-	bool flush_needed = false;
 	bool needs_deposit = false;
+	bool is_present = false;
 	bool ret = true;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
@@ -2450,6 +2451,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	 */
 	orig_pmd = pmdp_huge_get_and_clear_full(vma, addr, pmd,
 						tlb->fullmm);
+
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 	if (vma_is_special_huge(vma))
@@ -2459,17 +2461,15 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		goto out;
 	}
 
-	if (pmd_present(orig_pmd)) {
+	is_present = pmd_present(orig_pmd);
+	if (is_present) {
 		folio = pmd_folio(orig_pmd);
-
-		flush_needed = true;
-		folio_remove_rmap_pmd(folio, &folio->page, vma);
-		WARN_ON_ONCE(folio_mapcount(folio) < 0);
+		needs_remove_rmap = true;
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
 		folio = softleaf_to_folio(entry);
-
+		needs_remove_rmap = folio_is_device_private(folio);
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
 	} else {
@@ -2485,27 +2485,25 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		add_mm_counter(tlb->mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
-		/*
-		 * Use flush_needed to indicate whether the PMD entry
-		 * is present, instead of checking pmd_present() again.
-		 */
-		if (flush_needed && pmd_young(orig_pmd) &&
+		if (is_present && pmd_young(orig_pmd) &&
 		    likely(vma_has_recency(vma)))
 			folio_mark_accessed(folio);
 	}
 
-	if (folio_is_device_private(folio)) {
+	if (needs_remove_rmap) {
 		folio_remove_rmap_pmd(folio, &folio->page, vma);
 		WARN_ON_ONCE(folio_mapcount(folio) < 0);
-		folio_put(folio);
 	}
 
 out:
 	if (arch_needs_pgtable_deposit() || needs_deposit)
 		zap_deposited_table(tlb->mm, pmd);
 
+	if (needs_remove_rmap && !is_present)
+		folio_put(folio);
+
 	spin_unlock(ptl);
-	if (flush_needed)
+	if (is_present)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 	return ret;
 }
-- 
2.53.0


