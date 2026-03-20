Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A771099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590F16B00BB; Fri, 20 Mar 2026 14:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568E66B00BD; Fri, 20 Mar 2026 14:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480926B00BB; Fri, 20 Mar 2026 14:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 359586B00BB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:08:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08ADF1B7513
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:08:03 +0000 (UTC)
X-FDA: 84567225246.15.526D461
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 70EC2C000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:08:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OBaSXJ+l;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m7QWpkByVBegHNHBYfaRPZcA98OTFd4U0ZVL+bC7S+g=;
	b=1hdObb4xTodnuKixm9XfHQ9WOnO2nPBud0hMZF/APOyWTrnCltkmV8ha/w7lWlFyTCqHvD
	0fYO3oK6aEXXCmhqc0QxA7W+1HBnoDr7BgKiWEhtHbqeJRn5h3Laqq0ElZJNkPQuAQkspu
	wsawbLCIamnA572Bke6KkpnawsdDIEk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OBaSXJ+l;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030081; a=rsa-sha256;
	cv=none;
	b=yDf0HPOm6mdiKUn9LNDRf4S/dRDX+opm8tkyr5/GJ43w0hBhh/ZL7yFs+AdUoUbxJYnD+h
	Pqm+3+M25bDNJ6jFdcIm8LiY082CthFOO8+pAbqGbNyOmzKZrOpaDUfkl+jupnaRJAqCjm
	2JJ6EGpOANS0cmof09M6fp4xsBS/1Cc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ECBD160141;
	Fri, 20 Mar 2026 18:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442A2C4CEF7;
	Fri, 20 Mar 2026 18:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030080;
	bh=tXuLxXbV6sBaJ9fh/guXYRO+hrWj8nkDANbCEmM4U+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBaSXJ+lJmXJ2EJ0++u5PATPuo9ha9Q1I7CKvIXwGZiX4vqIqCAyPCTt0oDVQGKPf
	 Qbh9z6yJo6V7Wf/VaoawJTTmioIRd4Pc81c613eqpP+NYqpL64ucKucKPjXXSe1XyD
	 WdNP0NTcuAwlAYPUS2xZfzE5SZcd1cwvBr1EIVrAYMQedcz+aV3QQK0qs1OekIdkeC
	 5ewxNG1LsWXiU8cQuuoOInQKyGUO3Gm4c/4Thi4qfWL89xW/1tw9OL0z0WaqSlg5ih
	 8K7SSuu7kjt69FpMVRDik/KC+MmMgXvHaizS+TRZ9eiKtvcCvtauTV1RctFfq9wuMT
	 juI+UuXSImyBg==
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
Subject: [PATCH v3 10/13] mm/huge_memory: separate out the folio part of zap_huge_pmd()
Date: Fri, 20 Mar 2026 18:07:27 +0000
Message-ID: <6c4db67952f5529da4db102a6149b9050b5dda4e.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 70EC2C000A
X-Stat-Signature: txdtt5k7t3ddbh8xmpfyptfr8tceyat5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774030081-520264
X-HE-Meta: U2FsdGVkX1/Vukzgw1a1/qCmgtQ66APnJXzFOPmyvKL8qGO6L6MfUhT5BfAPAeX4D+9qmdZgKV2tMppUjjVM9bthK2ax/9mfGUNCbCVFsYXdWk3JF5TvCMaXQxqymCThVQc//owWTVm/xVeMALBTwoK2Ayt3KlWm1DGxRTKHvXoHHZmJEgKODzJlL7QVgLgOBQh6WxSKoZlM6Mh5k1BVcstPK172qrmLoarZvd/JcUKhURGmOiFo003SPdCTOTAzp83ghbe/KCU5QlcQWrYSUmcc22BhOSGuqrV2aBjqK7Dbag8T/IGtdqDmy55f3nQyH/89E2fRqla6ON4IDV5ImSo3JGfLTVOp02J0Rr2HrYPTsYQB5vKjI4ch25O145t9gdA31WGC6fnZOSnWLSrPLkPYaW23dRDoosuwSRbI+jseXJCv7Co/sButoFKthAo/N6Rq/6Y+qwOYc5TEDe2ks/1X/yeYaVpphqFNZIW/LK2+wkttx8EZvaLgmAvELUc3f/QeTELs0HLPk5dPYQq+KzJzy3ekTvxvGD+aErZF4rLgMgmbEDhIkefp8YodkYLZKEVGSMHZXx5732a2Dt5OsCGlzK1tFVXrfXX8iRZcQRHLkcIh9muiLhZHg/HldnP5AzFzaSOV1TgGF613sicqVVwieYIccC+gOTTFGgj8CHCpkg+VA/r83GxpjBvjRLpmf550FGVPSksQ9YD5YvH+FcKCo4mkrta4RSi5XG/hSfg05fS7wNI4tNR/WqrU/x/LBX4NocqK90nvFdpz+fTdbZIoJ/9stpeWkqddIFkgc4pPVuPVE7D968Tl7PaZBRZjI3jomRtndNE7U+2M4FuUyY0akkght5gY074a5RwqpP/pwizi4NPApYNujqcGLjx3fSfBDN4a6vD5Z5CRXcoSQB8Dq6bUhSEz5MD6+Jo2kiO/pTYu5irW7hw1t+ThWxBUIS4Znckg6JCvYUG3z0Z
 4NcGBo+P
 ubdNyLdGiOfVINFPsnVQyBFLfYPcRRZ1/aajG8T02328hJcAPuF4V9xzHsU1zdCNkXNf+9Ax+0cX6QC1E8U9dtMLzduH3sbB6St4knHseGk4X+C4KavqjMYFUd6OkeuWtrVsoyAeLQzEaDFWI4R6tYg7jYcLI6rgJhCOMO+3aUhSgdpdKqoxpqdJnV6GhIqCKuWcMoYolIxWLcrbBFjLvfpsOCFgGRRoZRopRQ8R+cCxXGM5RCTsK3Qd3ju6b4JpTt2fmMHeGqKP6QWO/w33GnUzgqAiFB49ANWcdzfpdCfQQdckQjNpVvoFA+d9Qyo9jZSoH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Place the part of the logic that manipulates counters and possibly updates
the accessed bit of the folio into its own function to make zap_huge_pmd()
more readable.

Also rename flush_needed to is_present as we only require a flush for
present entries.

Additionally add comments as to why we're doing what we're doing with
respect to softleaf entries.

This also lays the ground for further refactoring.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 61 +++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 673d0c4734ad..9ddf38d68406 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2325,6 +2325,37 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 	mm_dec_nr_ptes(mm);
 }
 
+static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
+		pmd_t pmdval, struct folio *folio, bool is_present,
+		bool *has_deposit)
+{
+	const bool is_device_private = folio_is_device_private(folio);
+
+	/* Present and device private folios are rmappable. */
+	if (is_present || is_device_private)
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
+
+	if (folio_test_anon(folio)) {
+		*has_deposit = true;
+		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+	} else {
+		add_mm_counter(mm, mm_counter_file(folio),
+			       -HPAGE_PMD_NR);
+
+		/*
+		 * Use flush_needed to indicate whether the PMD entry
+		 * is present, instead of checking pmd_present() again.
+		 */
+		if (is_present && pmd_young(pmdval) &&
+		    likely(vma_has_recency(vma)))
+			folio_mark_accessed(folio);
+	}
+
+	/* Device private folios are pinned. */
+	if (is_device_private)
+		folio_put(folio);
+}
+
 /**
  * zap_huge_pmd - Zap a huge THP which is of PMD size.
  * @tlb: The MMU gather TLB state associated with the operation.
@@ -2340,7 +2371,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	bool has_deposit = arch_needs_pgtable_deposit();
 	struct mm_struct *mm = tlb->mm;
 	struct folio *folio = NULL;
-	bool flush_needed = false;
+	bool is_present = false;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2369,14 +2400,11 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	if (pmd_present(orig_pmd)) {
 		folio = pmd_folio(orig_pmd);
-
-		flush_needed = true;
-		folio_remove_rmap_pmd(folio, &folio->page, vma);
+		is_present = true;
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
 		folio = softleaf_to_folio(entry);
-
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
 	} else {
@@ -2384,33 +2412,14 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		goto out;
 	}
 
-	if (folio_test_anon(folio)) {
-		has_deposit = true;
-		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-	} else {
-		add_mm_counter(mm, mm_counter_file(folio),
-			       -HPAGE_PMD_NR);
-
-		/*
-		 * Use flush_needed to indicate whether the PMD entry
-		 * is present, instead of checking pmd_present() again.
-		 */
-		if (flush_needed && pmd_young(orig_pmd) &&
-		    likely(vma_has_recency(vma)))
-			folio_mark_accessed(folio);
-	}
-
-	if (folio_is_device_private(folio)) {
-		folio_remove_rmap_pmd(folio, &folio->page, vma);
-		folio_put(folio);
-	}
+	zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present, &has_deposit);
 
 out:
 	if (has_deposit)
 		zap_deposited_table(mm, pmd);
 
 	spin_unlock(ptl);
-	if (flush_needed)
+	if (is_present)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 	return true;
 }
-- 
2.53.0


