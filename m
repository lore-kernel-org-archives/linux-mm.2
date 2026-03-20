Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E07C1099B2D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9612C6B00A5; Fri, 20 Mar 2026 14:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939606B00A6; Fri, 20 Mar 2026 14:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E4E6B00A8; Fri, 20 Mar 2026 14:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0AE6B00A5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:07:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 067058B10F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:50 +0000 (UTC)
X-FDA: 84567224700.06.D2E0D10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 378B04001B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=awXrgR7a;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQ6Fk7/S3UJwQIznDs2QPShG1yAgIRygegSNwThZBvE=;
	b=6IAPWUR0Z0aub+41XUfr2nR/SkX44TLDELCqSgiMq6++nsMhKvGfhJa68ej9nuDDkuuPa7
	a7TDjlnvhS7JSzbUqkb/iOD2sotFTzyQCxNbVedYS4fgDJjOYWYGTR4UhTVCVzJ1drMSOh
	QVNQIOjI4H+YJm4vBxkPk8uIDZfdDwE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030068; a=rsa-sha256;
	cv=none;
	b=5BEYYAEjfAkm649pBIZcnTMNDuQrzgQYv+pwF55mSfFAjwgVTib5AFWtPGhArNsYfdZTU9
	VosU6vhE/e4h1q2/bD0jhhpBetsYQ5zwPfFuTQw2y1s0p81wl7ejOrdyGH3hm2qkFyHxpc
	6DwOh5JAd8zC7C35aFmszIFS3Jb7YJA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=awXrgR7a;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C1D6445B5;
	Fri, 20 Mar 2026 18:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64E3C2BCAF;
	Fri, 20 Mar 2026 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030067;
	bh=fI1DXKEqfJaz8wCKY4bKhT28MvXJUmPPDBUHofI9UvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awXrgR7a4UDCSAsSaSsKba7axf1o1Sg7jj30LbzIxY72sjLdrgXkGIjnf847MV5Ng
	 zx6ITshDDS5/YBfSTa50y/7DfdmMur1WeCxqDRBNOMvPBJQbUOQZ1qX0pbz9o0CoN0
	 DLiNudkoRFSeIlD0mZikAL64hN3qlZGPcwb/PF4+NcVYh0B88FGJ2QjSPWEljCm6iw
	 e1+l7o4seDZ1x/vF/TSoTDdAop0lSZbyG1U1COgzVLC8hcHsIpnKOkzMid7cp/Hqtm
	 VAAZcdsFcke/J5UKZ8HlgptNQ+Pzqeh1s+1XKiotfNPxFSTP7EM+DMu9i0Fa6c4zEk
	 PxcDkaH/vloyQ==
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
Subject: [PATCH v3 05/13] mm/huge_memory: add a common exit path to zap_huge_pmd()
Date: Fri, 20 Mar 2026 18:07:22 +0000
Message-ID: <6b281d8ed972dff0e89bdcbdd810c96c7ae8c9dc.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m4be3wx8kepsygxtzojpkwbomiqxrpc5
X-Rspamd-Queue-Id: 378B04001B
X-Rspamd-Server: rspam03
X-HE-Tag: 1774030068-734748
X-HE-Meta: U2FsdGVkX1+fB+r74bsPhAtjRSJH+zRRoc2M5xDhzpSLdL4gVy7ugVwAgktwzWRloTyTkEkqJ+1xoSjfXLPKI7+mp4podkGrqNQlaXyl7g2rDcjH2+r4jwnrpre+GVbyF3YMFnedgv1m9bytOZuv33q7lM/IBT0r/tQOJaRL4nFsI7/VgOvT0btt1/GnFZ79XZ/aRVDxbEg1gWU2ET4z5M5UDCsDnLCaWyvNTSl92l32Iqd9eTXTyJx9oz1pWXiX3dZPxNoHNqJUAeChdV/WHo4Pe3MyrHNAu5CBDXhdGLefwRVfzjVoe/651aflj7/ko1ezE9jcF0xiQDBx4bniq42HbTWpPElzXBuHSYE0Ri0GDrDN5uBJi0H32HcKYZky7Qh1eLaay/OKNOIH0PSDMknYn6XNfmH5S01O+hGYBRzX5NzcBN8HagYs/4IYy4P70zkgdAF8tkgSi+k8yzx281glGba4rZ8Dg+Lye+sTKXh+II8vUlmPCbX9XUl/LAZrq+3vlCqc/73ORIGBNH0cHNGnes3c0mn2USCN430CWaw3vJq52MFmGVPZDLh0fCtrPdTJo808e36Mi36BvhvTc28Wwl48JexAbQrxLh9MLdZSiNAKM3hobxDyc/Zki4FHRE2bjROleKd+axNw7OKbulmsU2yoBzDd1tbW/Q4gNW3VJoX/P02tWKJ0XMfysY/LBVcd/0mJGXnMm0R/Fehj+Yajg2LDFaWlXYssFjiA4W6qSvoVLhGUomvsqX4MEKKUBBTZExlXDuY1pag6WC2xYIkP7qi7V1K+vLvb0rsD0BLtbim8z7Swgf8KSJgH18JqDDSIYF3garrhTwV2FimQz6IDB9T+AZ15vo3yB3n6yCQekkMig7uNwCIUQQ7g/nJWwfNu4upWz3Q2k9sBU9vvyTS2ZFaf0utLaDZOCUWuOMuTuE6q5rCm9KsTjDXIHRDZ0LGgHyd+6PgRjg1iag7
 fYqCHo32
 y31TtwNpxjvpXo37XQRRgzPAyGG7I9/9z3qyqas7hutpgJB+rm2l0Ez1XvYa52X/6oD0fP4kaGbdB7JF7H1dlrK2f8DsN1Vxjvr0NPFHpTLZl23UAkwM+5DBGH4GWRiQG/m5PFGDIUtbD2Abgb4clFqDRI8QZINkEnz/7n3y9eW5EEvBUv3iMu/C465dZ8p0+uMpE3fuq0Hnp2QN6bEhFp12+wtyjSRFCx62BTDOs3IjWiVh4+Kk+yV+kjbrOQ9LgwLTwFAFU8yWRgnVHppU04qSrkwouaRl61BwXjgduzS+uMwzGSL9ZXN2w1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Other than when we acquire the PTL, we always need to unlock the PTL, and
optionally need to flush on exit.

The code is currently very duplicated in this respect, so default
flush_needed to false, set it true in the case in which it's required,
then share the same logic for all exit paths.

This also makes flush_needed make more sense as a function-scope value (we
don't need to flush for the PFN map/mixed map, zero huge, error cases for
instance).

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0056ac27ec9a..b9d9acfef147 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2338,7 +2338,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
 	struct folio *folio = NULL;
-	bool flush_needed = true;
+	bool flush_needed = false;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2360,19 +2360,18 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2381,14 +2380,12 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
 		folio = softleaf_to_folio(entry);
-		flush_needed = false;
 
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
 	} else {
 		WARN_ON_ONCE(true);
-		spin_unlock(ptl);
-		return true;
+		goto out;
 	}
 
 	if (folio_test_anon(folio)) {
@@ -2415,10 +2412,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		folio_put(folio);
 	}
 
+out:
 	spin_unlock(ptl);
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
-
 	return true;
 }
 
-- 
2.53.0


