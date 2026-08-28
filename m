Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54414C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54EA6B009F; Fri, 28 Aug 2026 14:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD6B6B00A0; Fri, 28 Aug 2026 14:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5B96B00A1; Fri, 28 Aug 2026 14:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1E9C6B009F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:37:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3314CA054C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:06 +0000 (UTC)
X-FDA: 85151535252.07.7D1CE28
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6906A4000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s2dPowcz;
	spf=pass (imf11.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7mVEURHMP319Byv9p6qmQOcjq3woNvQVkr+r4ShGABI=;
	b=XnPCZXuF417IWV4wWnWjeCLCaHmbmuo/iE7q0W6cLaVNzsGw1/0eN7u6/vodmRjSE/nQ6J
	6M1ZbkzO2J/GnUZAYDrbrOpRd6XMhr5i7qKGnSb9iL06epgzacPXbsgZZjYvxqrL0t2kNE
	2mDwR6QUMahiMeTMV8NpMyE3r5DVVss=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s2dPowcz;
	spf=pass (imf11.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942224;
	b=FVQdE6uq2NqiWaZWn/u8xwY1GKNjUDvzOUfpgUAEEVI8PogK6FXWP4IFhY7np21l5QdRc6
	ANd3T9nkP6U1TcjqiRRb/xzdcWTS4IUeY5s/PiUCIAq5W3tZIjxCEB6J+g/d8SyS0LlOYf
	NklPjOiwdTeGtzrDhaYKlQR8b3fh5eI=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso1072063b3a.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787942223; x=1788547023; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7mVEURHMP319Byv9p6qmQOcjq3woNvQVkr+r4ShGABI=;
        b=s2dPowczT0F6hghlsl03bB1AF+WRXbA0oT9L0+yWKSwFSGx5idEXXu1l6KqqRfmuvk
         FyV9ED7topmOHwDN2HmVcrKwqCvyfEoxVHlODRrhYbiqunJDd9f76o8a2y9xKc36hhAb
         etvT4PQAkazR5Tm1R0Pa+IhgrZa5LOcdhKIXR+b1l/J9gX9el80KCN0uDstq503M6wfv
         KKSun1ko3Lm14NNrvXxN8b6qll+SM8e0kzy3d5uroNduaTDteYVBAp61qBwduCcGl3CM
         EpcF37NLAxBtKj+5FhRn+7V0b40j3c6D9Mw2991CMqbL6oNtR+++ADuKRM34GBvKzaXk
         anrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787942223; x=1788547023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7mVEURHMP319Byv9p6qmQOcjq3woNvQVkr+r4ShGABI=;
        b=pWVcgexSqYG95WpZUDJICsL/bzQyW9mIE8OXyhdprJnZDTJSHGUbOZDVwKthVW+t9r
         SFqryhi60/rr4DWliYuqW8IfoBNqP+mSCD3Yx2sJ2A9GN+3IJyibivrm+mp9UvhdVuyY
         4O4rSmKe+/gzlqZWsO/0SqdOM3YMuQBnEyKHAIdImPaoUU14vA8dSTDyBraNyiKW3uvG
         5+ePviRAszSyEsJmz42reS//3MW4DU3VcLWpQuHyfieNqnAFSEqvQ5XlXdDCQhMw5eRS
         f/FtnoPMigPeRkWcmgubIB9DPazMm6MWqlmcw2hY00orcHYTqIW0RKLKbnFGfPlkKS0q
         22ZQ==
X-Forwarded-Encrypted: i=1; AHgh+RrBK9/AE++KqjIZuHrxqGULKs7Olp53phHlMHM1NnuMqRKQQf0oiJIQpsK/GcNRWwubpVv+hsYqeg==@kvack.org
X-Gm-Message-State: AFuF++kKUAW3du7awbMdX4F/OSl7Tt8u/Opd02ZJh50YflqmNPNs5/Ho
	XH4r1avCcEcnbWXmg6LF1YMNaxGdSOsHDuh4Y93IgXxl1xFL9XO7CqQY
X-Gm-Gg: AR+sD11bWLKEs/+Fgru13YkiBLu0diOacAIX065hhfxLY9hijKXAVtJ/WzBUJOJ9KjU
	8weZW2teFnlZ7mGZ6eJxz4P5Bj/VBqw3e0LfFPP/WoNyDSaAwpUuLgyXWVP/LpBz1lYWVdFtkkP
	pqqDSP24urhep/5VssSPTaaC4deQK82Lrs7AzQLeobNwuOf3mptvaQfFT6753hKU/8gxGVcX9WD
	f5f+6aLjwMVPy1ZMum8Q4HDA8G6IvkbZII6UAinCkLl8QIXGOgY+z9jWGBC2LRay5MQ4gmcwEDS
	IxEkhB7ISoj9sFP56KFE3wyAf04sCiR32SUlkG45jTfiqJnxRvJJVa95mhQRuHuK/aJQl3u0zu4
	1SsenA6b1vXxTOkYNKjAx7Q4a2aEwOEb5LZe6A2UsnfJrU2XX8P5IZfW63Kmh395xqKGYg9X8aP
	TDN9YQ9FSN5nX9Ov5ZPm+O11hdfSvUzCzzz513XEHPNkZAq3M5Bl8KGqlhvoNiUHEw544FAzwFl
	UnkB181LEtXSCwy7BCTeO4Bjpme
X-Received: by 2002:a05:6a00:2309:b0:857:7384:b5fc with SMTP id d2e1a72fcca58-8577384c2c3mr2082303b3a.24.1787942223100;
        Fri, 28 Aug 2026 11:37:03 -0700 (PDT)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea6fa3sm844230b3a.37.2026.08.28.11.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 11:37:02 -0700 (PDT)
From: Yin Tirui <yintirui@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-kernel@vger.kernel.org,
	Yin Tirui <yintirui@gmail.com>
Subject: [PATCH RFC 1/9] mm/huge_memory: read the huge PMD entry once when splitting it
Date: Sat, 29 Aug 2026 02:33:11 +0800
Message-Id: <1b11fdaa4f5819959505ad72e3d70bad5fc1d343.1787941780.git.yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1787941780.git.yintirui@gmail.com>
References: <cover.1787941780.git.yintirui@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nf6egfyw9ng5f71bddkg9sdu48brze6m
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6906A4000A
X-Rspam-User: 
X-HE-Tag: 1787942224-493170
X-HE-Meta: U2FsdGVkX18bOWrMEj9FnH5mLSiCDMcA6ISr0XtTK76M2eZ8DiCerAn9Zf8OwTEsiWgW6f3dLqCflG1Freh/VgkNKKHcPFojRYo41gTcfrMwLHgCIdtIgE1bh1aIcC5pAiNeTSLqlLzHWhKWsf3oSju1+bZmb46ecVJbGLQcMYsFpSRMf34VOVOqs38hV7Ujspq7ppS0SyThbcgdamqYdW2Xg08zNyi8oKHu31bxRD8HW6PKDYBuBnoVIccTI6PASSX2QfxzRu8Ean565tR74rh7HhPTb+T5P0nF/2XegpcV6janyIFreDxERArFmH0IiIs1mYfCG+rMf+j3ZNpaH19V3qzn3K1mxWSdBBKDNCJRwpmPl2L6cYCLCxfa+uZf6JXBbjGiGDbDyndwU9hLEJnS9uHcIbKfOTLYcf+WqwmtQbDa1Bbd1GT8rLxot1UiMc6LXGfj0s4pVIzSilqSdbLeou3f5EBuJTOpMNKoYXTbh0hiEsbgp2+IS9NcLekJYzXzbgdROG2v5DRq6C1gV6lO3ZD02N/gMZMbF3RnUhPh9uB0rn+intvYIH3lwUx5M/hKZhbTVJ2vYEcayIIcDjz94MOeY+0sgpqcnXqxNfScI0q/aSCTBvNMftyhZ3+qn4YKC0o7DuhXT7MOiS5W57/tsoqptmwUWCNS6etsqYiIMYhpcjQ9qVhO3z0JqCZbOtzqbYZLyAnbHdZj+bL6gn143ME9xAj17w10QvtDHZHkUSO/+FrmO5vvdklwD7I8Pj9U29wmrqnGucb61am/pS2SUvX/QjIT1czTK+MXM8tvJSqqF6GQSV+Hg2GJTqPV55LAiqhJIKg5E+4xObtPXRIWe2LFFBA9XFdMLZmivU0+67tAVDGQHprg6+IhoFG4qZOAuzaEfF0D0SzCEzYwD3TX15AsfCjF7wfjheA5taU9y0C5YH3c1M6a9w/B0pQDRJrow3FtQbtwAO3Qdx0
 xlXOK0VY
 0nhMahEZ8Af5omUh5Ma5XY2fvRtj0ZdczTBwrLvKs2HKymUNyVmwc23ik4KTvQ1x8/5y2qtiWWfS5pLoc6kPhfJRVXC2mOWpLFI/k87ptfgIwFoF1rVTGhs/gjuyTOMwpdgPozwydC+GVNIbLaC5Do1S9Kx1tkGZpY17RqT7PwptzjzaYU8y6tb3mM17KV7bb1ySiBtbF1HMc6UL7UZz+W/ccPscXoglYILQxq3DVV7OQG3CWv4Ozz5Nc0UU1HEcu9hdTVcJv98aW7rY/qe5l+77DFEO857h+CIo8V7RTQWku8DGFBTTRmVzPey4RWG9GoQCLHMv+RFOYjyKViDZbGpE6kCHIViLWeQrdGjUuvTi+PB9rPkSobJvK96ipZa2S8+Vc6sy97laStH87m5ZikuqjyE/iPWkL5IliKjLBhhtVKwxQqTtKfL1GosWg1K7XlEL7wNvrOX+iPtE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__split_huge_pmd_locked() re-reads *pmd several times to classify the same
entry. The PMD page table lock is held throughout, so read it once into
old_pmd and classify from that.

No functional change intended.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index afbb5974bd22..8feabdcf6307 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3143,10 +3143,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	pmd_t old_pmd = *pmd;
 	struct folio *folio;
 	struct page *page;
 	pgtable_t pgtable;
-	pmd_t old_pmd, _pmd;
+	pmd_t _pmd;
 	bool soft_dirty, uffd_wp = false, young = false, write = false;
 	bool anon_exclusive = false, dirty = false;
 	unsigned long addr;
@@ -3157,7 +3158,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
 
-	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(*pmd) && !pmd_trans_huge(*pmd));
+	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(old_pmd) &&
+			!pmd_trans_huge(old_pmd));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -3193,7 +3195,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return;
 	}
 
-	if (is_huge_zero_pmd(*pmd)) {
+	if (is_huge_zero_pmd(old_pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_arch_invalidate_secondary_tlbs() see comments below
@@ -3206,10 +3208,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
-	if (pmd_is_migration_entry(*pmd)) {
+	if (pmd_is_migration_entry(old_pmd)) {
 		softleaf_t entry;
 
-		old_pmd = *pmd;
 		entry = softleaf_from_pmd(old_pmd);
 		page = softleaf_to_page(entry);
 		folio = page_folio(page);
@@ -3222,10 +3223,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			anon_exclusive = softleaf_is_migration_read_exclusive(entry);
 		young = softleaf_is_migration_young(entry);
 		dirty = softleaf_is_migration_dirty(entry);
-	} else if (pmd_is_device_private_entry(*pmd)) {
+	} else if (pmd_is_device_private_entry(old_pmd)) {
 		softleaf_t entry;
 
-		old_pmd = *pmd;
 		entry = softleaf_from_pmd(old_pmd);
 		page = softleaf_to_page(entry);
 		folio = page_folio(page);
@@ -3417,7 +3417,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_is_migration_entry(*pmd))
+	if (!pmd_is_migration_entry(old_pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (freeze)
 		put_page(page);
-- 
2.34.1


