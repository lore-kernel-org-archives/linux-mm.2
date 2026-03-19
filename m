Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B8C1090223
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9163F6B04B8; Thu, 19 Mar 2026 09:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED4E6B04BA; Thu, 19 Mar 2026 09:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829DD6B04BB; Thu, 19 Mar 2026 09:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 70EBE6B04B8
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5C771405A0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:45 +0000 (UTC)
X-FDA: 84562822050.30.B0AF229
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CEA4210001A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nkialUqi;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVFsMpOYfCeLiOKZHgwfOO7Q6on97T0ELZB7Ic+zPTM=;
	b=twokjgbrbqFz+nDVBa/SjXyNlkOW8x0DR52MsmpOqPurbAsvm1c+XSV8Vmn55TVrDRcbDi
	u4lC8jyS5ZlyBdzVMLmXGlAfS+mma5Egc0bKqo31UhOKPFkq5cEC+uFm2ClFS6k9QQTUco
	wWt5XfcA9MvL9lLOiIIRSpAOAH18uxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773925244; a=rsa-sha256;
	cv=none;
	b=cVbErgkmuTFyQ9vR7FoTLnelKASrfI4OnMBds15F0BL313zvfgwfzL3yclodA4ktk1NWXo
	N7O2txt6VlFnIYEKowsVzKFiJDf/Ri+KXBD2+3mAdo6/dnF/QhuTKrzOYLU5DAkEX6MH7D
	RpLwpPowk2zk7kgONS2vfZwiPQb9CQg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nkialUqi;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 012FF43C59;
	Thu, 19 Mar 2026 13:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E223C2BCAF;
	Thu, 19 Mar 2026 13:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925242;
	bh=jwAcjIvj94lIaFqSDU5rGJUwe2UvHWTByimGr9pyvys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkialUqirVob79VJcXVODpVto2tm0ZpXaRVx2iJtHiGVZ9MOVVMaxvmeFqBDxo7a5
	 FvQmMrYASCI/q9JwLy2KsJH+UDaCTyu2OO/wy5a0Ouy9ZPD0F5+GF9LybkX3ifvCjf
	 k5swhZPcrmvw9Q7rdVgFgdVjv0pZUMnX96G96lj9+hd3xUZjictASE6ENJbrMJ/mwC
	 qy5/5wGs5oVqpLx/U1YUiige/3UllKiHQRvOGACxLyT1bfLhzKKWAwkiScuqJWmFzd
	 G2t1N0wO17Paz8QplizaFaZox+jE2IXxkKsCzgEPW/ZbBlrsmkUzh7rjsEOE7N6vMZ
	 gcVUBIOFrTwJA==
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
Subject: [PATCH v2 8/9] mm/huge_memory: deduplicate zap_huge_pmd() further by tracking state
Date: Thu, 19 Mar 2026 13:00:14 +0000
Message-ID: <440f68edcb597c28918d89b0be279d498561c89a.1773924928.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773924928.git.ljs@kernel.org>
References: <cover.1773924928.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CEA4210001A
X-Stat-Signature: jdtsi8m4m3q4uuokzy1cmt1dqkauexe1
X-Rspam-User: 
X-HE-Tag: 1773925243-182171
X-HE-Meta: U2FsdGVkX189/7a4lxFzGirWnGnXJkHZyvDERz7MazFBt1OsUuMtqfE2jAykTdy8IeXfQHCNlcE6I/GrdByDMzeZ3GdaXwgYc8S50ydPuF+v9hqOKxP7Zh6brxxHa8FPLIHabJd8swzihH3F43J7+mh9BuLjkwGiQYzxH/kTzixWeC34d4VJ7uw7T2goinntkKBCTs/3VzOcipf+0dgsaXOSv0V+ign8oVtDfXYhTwY5HgHs3iADXlSeMsRB/yUf0wwtLf9w5ydUU3tNUIBPFdX/Q2fSzMjuZLFvVwehBY3UYZEyMPSTK0Ovy/jBNnfohCDgiZzGYMU2RHBV8oq0TzxkczOE9RZfDYDEWAzzHDZi2k2nsRdSLvTOf9pP9Br0Os+3QfLFKSDfialO759K3bRR4TwPq+vdsPs/jcLfju36lTQA7Y5kTErBuviqz4qcRVnGR3ATvy/Hq9z9UWJNE2CZXqyewbEl98/9kSvy9w2JTpdU6++6w9gmCThjB5n7yWlh3kY5oqV5XxitDsUseAWMphY9dx/pYqNrEM2AGK/HkS/o3poBJVd5z4G9O422Ie+Bc+793ALAXRwe6LYdyEErfQ4/50Fc+ezZe30Vuv5TH2LVdigaa7HX9tY1vs9kG+933m2X3QRdKso4GsGp7ybFsxZdfKyLB0BQrBY0BmlGy/i77h0TfUEm+oXk0WwURUdklyZrLofsv6aUxqlfL0VUZL8Jg4eY7VSfYPVxfjLSewhzBDI9S00wm7HRaNsOK29FBK1ykqJBxJZRjKzLqN2AteROl6uJNiAUXrIjiKAN5lybhXOq5NomxL+i48ubKaV86waaOvhrMffxeLEK2ua5PPMgUi09/b6Bs0h/uYVkVtUIr8inlRzNDjR25u9YXeMV/d+DAiMtWyAYzE/l3Xt3wITcrWl9JmhgQvlcNC8U9IgAIWJi5ZlsFWXp5TCkibpoXytFWmn9YkynLyj
 sCrWEj0z
 nYs2wpW/Znu28OwO4/AJl58kGJhTkwWlnj5GAk3G2zjrWSBDT6UrCG1cpShmJ1MmDIr+CkBO/6TpkBIWvCopDxUnh4yeskYSAauWstc3K1KF5UEIMca3156yDZbK8psilI7zQ0pEj93GqgLcql73IpIiwqA2NwsboHnYAw94ld9kePn7U1Qi7U+AVCFPLDOA0oqeLuUoCOAM0mGJjF3EercA+zw8Y5CD9uPuJKRlWHoVm0M6/qdjV8UXTpQ==
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
index c4e00c645e58..22715027e56c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2430,9 +2430,10 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
+	bool needs_remove_rmap = false;
 	struct folio *folio = NULL;
 	bool needs_deposit = false;
-	bool flush_needed = false;
+	bool is_present = false;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2449,6 +2450,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	 */
 	orig_pmd = pmdp_huge_get_and_clear_full(vma, addr, pmd,
 						tlb->fullmm);
+
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 	if (vma_is_special_huge(vma))
@@ -2458,17 +2460,15 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2483,27 +2483,25 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
 	return true;
 }
-- 
2.53.0


