Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0CB8C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3911B6B009B; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3507E6B00A0; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2647F6B009B; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0036C6B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:52:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FD94A0714
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:52:06 +0000 (UTC)
X-FDA: 85190733852.20.C150551
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DC3F9A0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:52:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdfYkuV6;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kczmrPAUogSYXZZ+xxo8bL8jMA/tFmXj3bQ+IC2xRQ=;
	b=dX+gmfzGAGDRD2j2Ab31fCIvQBa0Q5XOuBDvhlriP/24/F83yB/MzqkzLrkScEdZqy1k+4
	1HXjrbQfik/14o8tX+tI/b2SlsDFZtzhtRXoBQaW4aTtpwsDKvdTGNXOdOt9uFlx7F68XA
	GFb4HwuumD4ixvM/Vk4GiVQDwY9+rXk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdfYkuV6;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875525;
	b=TrjrnciZ8/PzP8ZBX/EY+Nao6PiC60vmWqRU6W7iEjdSQtAKPqIiWBN029/aAUqOcof1iJ
	D3icu5nHQjt/doq9FJj8+1eeeN9Pp54wmiXwahwNmhpXpyXw71XPdWX4gf5Q741YwsJWw6
	3w7gEACDQ/1fS+daDGyUjO/5kf59uTk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40B66437E8;
	Tue,  8 Sep 2026 13:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC24B1F00A3E;
	Tue,  8 Sep 2026 13:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788875524;
	bh=6kczmrPAUogSYXZZ+xxo8bL8jMA/tFmXj3bQ+IC2xRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdfYkuV6xeUH2S6Q+QtzgR+3pVWXzHTRUCvHcyhdEZt8PVcgIXAC002vdQo9mo8Rn
	 YHOYP5gHWieUOEJwHEqM8ENToViQzIareRHLM8Ha8X5aVR82QP0fU2IewbK/3bqP5v
	 xL4h+XtBdkoQFonQesAT+1hjqUQ0wDcXasz59emqgCP80Mf4vnQEOj40ulgIcFvQ/V
	 AmROXWB5pqz2v2yvd6yfl0C+XB3iccrOUEvg+DFM4vp4hggxnH4kqbOFjDB9ki0iR/
	 +sn7i3tFBS4RO61PrkgZJTG1SKKbFdybDvj3Pq9yX2NcC237Yuw/cxdc9+Dm1QPTlU
	 SWEo19qZcOdaA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Krishna Iyer <kiyer@crusoe.ai>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/3] mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
Date: Tue,  8 Sep 2026 06:51:53 -0700
Message-ID: <20260908135156.97481-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908135156.97481-1-sj@kernel.org>
References: <20260908135156.97481-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DC3F9A0004
X-Stat-Signature: 4id8k94rcezz7afumuic38ei9fbm8b6f
X-Rspam-User: 
X-HE-Tag: 1788875524-581238
X-HE-Meta: U2FsdGVkX18nLPNdwwK2YbumxhgtHB1GSRe2xJxpsEnBpEs2wrve/aZeJaIOd4LAuhCN1A9Pm4RbLoU6grdXBWmwL/0cljB1bJfo7Am5XI4vATtpW4P6avlrXprE00vnL704tiT4BgFmbns58NYQZ9QlH+KJfyGlW6c2r+4kscjI/776b6ofs7QAaN0N28WLx7ZKoFFT6C9Ohr2WzpGYnvZNAmZGJdBznmkhYLFYgciu7X4wtXT9DU/+ooORt57AfEFUmGH9Ok+BMxaxII3gMbbCnPxKgTn+Osl5t+cN4ugjDvcGGGo1vTgLB+SdoVUArnxujPJjyZT1+BLLFLfZLXQKV7JThDNkTXiKzp9+GqZam4hHcsEdUuX6qYYkxEavZ4QBxzB6INrUQ7l58w1q8ekj1uD8VtMrY3tA3gdu3zMAFgmQdZjuvwJFcEaqJ1kZlc6ma5Ajx+NaCgAVZEnlj8DVBQ+oZCeytgwowHoHvi0AwZA5a+eAEvdgilEGEVhYmvCXI/Z2nTizAQvLwnQTsg8XxV0+EEMDvcSMpCALggPgFWVbI8btF3SmpL1nSsiXJym7uHzkOzWoSlqFHE6YvuNg6s/TxKupVEG3L0UHwM/izS4aKdZdmfmmAeTdaDbAuMjmkxD9rlePGdkv6hFCg+LxQj9ONTDSHsQF9P39OL1fuP4lH5KP7v1hz5r1C99Dvc5Y7kJepA6oltQfKP8XAYMtk6Dcetw5o8hf5/pRxSvLtVU0bZdx+gbqiXca7/KF9PCGn71C/zYiyK5yZrTjpsoItUiz9Hr1zOHarYdXNIkEL5GlR8P1PXgmtt/48FvKingFqEoTS846cXGAUVNWFq+sDWhp6r+7Y6jPG6DpVjqxMWbOuYhatUh+B7FDQa1m2Tvr8KvAbRlDhb7efEsz4nn5WXe/BGPSCvDXe3/At/St9LoKjEPdm2p74d/9n0J+vwtsvZUNAej3a74YTAl
 9/6ZWAXU
 WhxIYHQs7D1RqY5W7kAWh606VOecyktTxvbMc40oiR5etXs0EFassJeUC4oNIPBx2ATP1QPtKsRVfK0OReUJFR9eWmm15Tmb/xR5rgey9OTN2fmXOPfp/mAhrFmin6wXekVy/85iJGp1n4XrvyWi20t02saVU5xVLUduXTr/AYmfcpKaHItZ17NHLB9uHYScu6gSQWT0pK8KGyViSS9VOn/UpxKz0jLOj4ZmSqoOKi8WRapGWancTWN2EHQe4JwGE0ZdVuzyYGm6wLksD2wfNwhKAJNqcedRap/kpEZd9bxe+orYAy/ZoBqlTgoQi+CTlP68JfaFg/a/ZEmoveiNgI5dNyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Krishna Iyer <kiyer@crusoe.ai>

damon_hugetlb_mkold() clears the accessed bit of a hugetlb-mapping huge
PTE and propagates the aging to secondary MMUs via
mmu_notifier_clear_young(), spanning the whole huge page size.  It
currently lives in vaddr.c, and is thus usable only by the virtual
address space monitoring operations set.

The physical address space monitoring operations set will need the same
logic, to support access monitoring of hugetlb-backed memory.  Move the
function to ops-common as-is, with no behavioral change.  A follow-up
change will use it from the folio-granular rmap walkers.

Link: https://lore.kernel.org/20260902025700.17975-2-kiyer@crusoe.ai
Cc: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 37 +++++++++++++++++++++++++++++++++++++
 mm/damon/ops-common.h |  9 +++++++++
 mm/damon/vaddr.c      | 34 ----------------------------------
 3 files changed, 46 insertions(+), 34 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 7219c608b1952..995cc1f3b9f32 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -3,6 +3,7 @@
  * Common Code for Data Access Monitoring
  */
 
+#include <linux/hugetlb.h>
 #include <linux/migrate.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
@@ -103,6 +104,42 @@ void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static bool damon_hugetlb_ptep_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *entry)
+{
+	unsigned long psize = huge_page_size(hstate_vma(vma));
+
+	if (!pte_young(*entry))
+		return false;
+	*entry = huge_ptep_get_and_clear(mm, addr, pte, psize);
+	*entry = pte_mkold(*entry);
+	set_huge_pte_at(mm, addr, pte, *entry, psize);
+	return true;
+}
+
+void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	bool referenced = false;
+	pte_t entry = huge_ptep_get(mm, addr, pte);
+	struct folio *folio = pfn_folio(pte_pfn(entry));
+
+	folio_get(folio);
+
+	referenced = damon_hugetlb_ptep_mkold(pte, mm, vma, addr, &entry);
+	if (mmu_notifier_clear_young(mm, addr,
+				     addr + huge_page_size(hstate_vma(vma))))
+		referenced = true;
+
+	if (referenced)
+		folio_set_young(folio);
+
+	folio_set_idle(folio);
+	folio_put(folio);
+}
+#endif	/* CONFIG_HUGETLB_PAGE */
+
 #define DAMON_MAX_SUBSCORE	(100)
 #define DAMON_MAX_AGE_IN_LOG	(32)
 
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 38d295488fa18..f7811c9c7a024 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -9,6 +9,15 @@ struct folio *damon_get_folio(unsigned long pfn);
 
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr);
+#ifdef CONFIG_HUGETLB_PAGE
+void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr);
+#else
+static inline void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+}
+#endif	/* CONFIG_HUGETLB_PAGE */
 void damon_folio_mkold(struct folio *folio);
 bool damon_folio_young(struct folio *folio);
 
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 91a0d441c1f94..af9e1b82454cc 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -283,40 +283,6 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static bool damon_hugetlb_ptep_mkold(pte_t *pte, struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long addr, pte_t *entry)
-{
-	unsigned long psize = huge_page_size(hstate_vma(vma));
-
-	if (!pte_young(*entry))
-		return false;
-	*entry = huge_ptep_get_and_clear(mm, addr, pte, psize);
-	*entry = pte_mkold(*entry);
-	set_huge_pte_at(mm, addr, pte, *entry, psize);
-	return true;
-}
-
-static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
-				struct vm_area_struct *vma, unsigned long addr)
-{
-	bool referenced = false;
-	pte_t entry = huge_ptep_get(mm, addr, pte);
-	struct folio *folio = pfn_folio(pte_pfn(entry));
-
-	folio_get(folio);
-
-	referenced = damon_hugetlb_ptep_mkold(pte, mm, vma, addr, &entry);
-	if (mmu_notifier_clear_young(mm, addr,
-				     addr + huge_page_size(hstate_vma(vma))))
-		referenced = true;
-
-	if (referenced)
-		folio_set_young(folio);
-
-	folio_set_idle(folio);
-	folio_put(folio);
-}
-
 static int damon_mkold_hugetlb_entry(pte_t *pte, unsigned long hmask,
 				     unsigned long addr, unsigned long end,
 				     struct mm_walk *walk)
-- 
2.47.3

