Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A6321090223
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1D516B04B2; Thu, 19 Mar 2026 09:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6ED6B04B4; Thu, 19 Mar 2026 09:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0BAD6B04B5; Thu, 19 Mar 2026 09:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFBCE6B04B2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E1B2140579
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:36 +0000 (UTC)
X-FDA: 84562821672.19.0F2B12A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A34C240005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rqco5QSX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfoCsA8jJFbtQfidKWgRKj4ykR47nY9cLr9EWVdCqfk=;
	b=rH8y9SPTy5Y6YulPhQSryHzyarzfxxCh5wxD5Rdp0oPeqylmNdTaLymdWiC80tEWWueJwD
	k/ut5ouNNm9jca8ukh7tVuSR6RSLoVO0mnvHC9OLIPndYPCr0lWsotwmbmeHvDmyugQiqw
	0jLFBcfeblpeObDFxWgQQ3ByOsxdz+c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rqco5QSX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773925234; a=rsa-sha256;
	cv=none;
	b=8p3B4tsBmdPViPv0Lz0qOlwPxW1+1mXxV3tIWqPPRSj0054uzMSdPiZ1d1IqLg1dcZ/F9H
	1lP9dEUt82pR1IG7oA3V7cqSsXHGr0KXzIz1OeQsiqLg+UnFhS62L+FRzJp66H/1QO2JxP
	cOD2txNJeZCx74Lp9NHhLO9yfwgaMZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E70C6012A;
	Thu, 19 Mar 2026 13:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56090C2BC9E;
	Thu, 19 Mar 2026 13:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925233;
	bh=tlTUWhNPK6pHczCJVqf9Z+TZVety3K7Ng+XiEbd0tdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqco5QSXRL2rOThabB6xWRg0bHs54Q2yKy822BvcWtOYk5p4KLkjo1KTTDm84e937
	 GTu9uV+rBEpSv/aBmKfG4ryN+7uqtiNeq/xNEGy6UHBAMvna1UIANatgjZ3MCYaTFE
	 bWYDdUvIXCzJVGFkZdzzPFNxlgDRoCENORV5XCKE9vP+4n8vze4EpyzsJa9/Qb+mZ+
	 LMiCmGVeS6XBuucxH3x2FUFs89GOJlavSVhvSz6fWl2QuYUg6+zPrvI2NsftVgEyUP
	 9ikCm5FdcENujRkOeVQAMlUWUCcZq2xYPXkOLoW5PQIafIOzhROkLm9Kb1wvD3Ky70
	 0+mVSS7sT3Klw==
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
Subject: [PATCH v2 5/9] mm/huge_memory: add a common exit path to zap_huge_pmd()
Date: Thu, 19 Mar 2026 13:00:11 +0000
Message-ID: <f5d3d47da1bc1607fc01604c0e803c3248d8a1fb.1773924928.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773924928.git.ljs@kernel.org>
References: <cover.1773924928.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A34C240005
X-Stat-Signature: egta58ngwkxoaxthdorj8qjeus3quft3
X-Rspam-User: 
X-HE-Tag: 1773925234-780389
X-HE-Meta: U2FsdGVkX1/pm114lEf/B8o+JvgJHddYS71Siaulqa204AnbRlJ0v7ihS4RTiaVmg8I7t9GFTNcXPx3RckWIJJdebCfwwRATT6sHiZHrt7EJIw6RW3F3YAf0JGOebvwDBtSIPlUg0H+A2rIpjIYClbuk2orH88zddLum0AQ3Kqzv0yfBt4tYs4WEksHrKZ4xVrzCYmT065pNomC//PC/owq3Gxv26J5CRhxwImq7Z9Zfs8k61kIZy21L5AR3mGG8rEJrO5JA+erUjLGITJTGuygstbt129GKDudTKFQsJOW0zdwP5PqfDAZJIhZ5uvrLug9bxrYK10qsI21NVpr9NMClnOu3F8zt1zIjXpaNdAuAbTtSoqU+dBGJIYxCxSzfvKkvIxIsxdVMg/qkXcWZRvXEwn/wzYGKUpMadAdPuq3ALM+/aQM4uTKtbfzVOJeody6dZPwjdA/WQwqAdgoFV8R6NOODSyTuJqKdd2lRnTL1oiIweopXcttLJL0Erei0Ji4FFIgn0bGsQ6gd6I4d8iz/bnJguTTyCOhVonNDKJjNi/gU54i+eMjgnphc6Lay1mZeu6wugMD2+w3NhSitDPoYnghK9ngkYZi6/Mt5a923vsHreM0M2mGpRF+nNjmYUXn7NC7ziOFXyqsL1wkINp7agnmtmodPnf7yiNf0+Ukl3TAxz4pzWLoWGuXMEO3pgwadKeRc2/2gvRl5komYomdm0C9yh9qFA2U5YigzB+pKdo6DD8Wvwq/5aHi+Q9KrjaGg6JUxWmrVDLuupC2aOFYxg30u3CVpA9p7RJhkWaBQxLVaPodZwhbgXpBSN27lVs0C8MkYosXW4/mONv7zoBaphistdlnbZHhjsCTjir0WFpafFGRff/rtR3vpOtbQOBheBS0aqHP2EdOLjEDdGwPGObsnN5v9sTrtNknh5TwEBT3YKvDn6WPS4lGWuBnQ64t1e0B+2GHP3SEFjay
 uwieQ+XG
 0rC1WohUoINMgq5mHoraFTPLovW0WzCU1hU4DEWGUqOfKkqXoz6YCWdJ7OUvUGAr5sHpM2s81EWGqyae2Qri7auwx+LQnneqKyV3FCJVhyXT9k0fLh2v2LmN7J0+Qx4SFuFMuY68bKUjpi4ARModo1oSlHlm3YbJBvujKVqkswOrAvrsCrwVuM+wE+wvQLDdaTjC2Sb0hld2/y2Rt547GQhSdW2MEAmqIK9sVKDZh91b2nabvkWah3C95ejdPLBTSJuFk0HUr8VFrqW7CusAAK27plw==
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
 mm/huge_memory.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a2f87315195d..c84b30461cc5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2431,7 +2431,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
 	struct folio *folio = NULL;
-	bool flush_needed = true;
+	bool flush_needed = false;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2453,19 +2453,18 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2474,14 +2473,12 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2508,10 +2505,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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


