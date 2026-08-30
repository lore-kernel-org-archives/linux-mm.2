Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E63C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 05:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7976B008A; Sun, 30 Aug 2026 01:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2969A6B008C; Sun, 30 Aug 2026 01:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1864F6B0092; Sun, 30 Aug 2026 01:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8A276B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:14:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F61C40272
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:13 +0000 (UTC)
X-FDA: 85156769586.03.B0AF5E1
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8285320007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=CbsPubQY;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai;
	spf=pass (imf03.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.215.175 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788066851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJRx0Jd1M2+awD7NVhe4CKIIkdBtWXqqpTIhZLTtZn4=;
	b=qqQ/Z/los+yivyP0wgr2VL2G7RJQH60AxwXaY41aZb9g2mzTfkGIJe08cXNsh4VdWlEYkm
	xiybSDRSf/jmOjQvdAQKHDm7hYq1JxwDINVlUXe9YILX7j5vnusrOANj5VDLX2Lx2Ris4V
	nEUJF4mQKyVNI1H8997fX8BCazTVKWk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=CbsPubQY;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai;
	spf=pass (imf03.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.215.175 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788066851;
	b=2Z4p2Io3bQz2hvFK6z2B+ZvH6yLVvU0hAveTpdsA64EoFAoc6CorOpkwQJXWkOqJ5uCCCj
	s7Yn54JEYyBf8osu1qs0cp1gmpEPVxHhcbLF4NynXyaIeSwswyAvnzXbc6hE6HpqZ60z7J
	CqWmF2ZEQuzlHRzPCDFhCNmj76yVjGk=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cc1a4c62804so1929190a12.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 22:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1788066850; x=1788671650; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lJRx0Jd1M2+awD7NVhe4CKIIkdBtWXqqpTIhZLTtZn4=;
        b=CbsPubQYeQDt/MHZkDaAlW5i8/P6QByhgHuneHqh0X4k8KZ1XOUtSySLhnTkpZ6wvy
         Nk/GKMWsK6YO7omuZGrrQ5D3bGVFDYE30b8IEdQaQO8eXlQih90/6T2tXKrfhS6xPtW/
         Je+ApcC86tT221BWhOZsNd1ue1SUiLYJPFJCRcgDidyQAI6URBq9z271TBbMNLJ/UELn
         vx1WHcGOYdd4+TOxyfCbPDMhpL1aIa+0hWi6Gi9TQRMA1wnR+yYb6JQ8yCgZ3vHYTZZh
         aBCpFognhlpRJDYDSfeSNy61UBs52++cWg/lEUr2nDDM72fFrNk44DdQgieMt+GpBmZr
         KePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788066850; x=1788671650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lJRx0Jd1M2+awD7NVhe4CKIIkdBtWXqqpTIhZLTtZn4=;
        b=YO69DjJAdRsS/No1S5dpGd9kqkUmB72qZOD8WkYAyg5G4V1QH/g7I1SxDD/Qeipap8
         /RfWYENWh8c8DBCaxfWvg+4XrTFuC2LABjjSZVuJSYMt75Q1wFt67RuQDoaZKXpLMrlG
         HcfxGb1z8hyIFv3Msdu4q0swTdOX2/pOkNO82qkwA2SSeBFpJ73pghjZW6cai42+NnbQ
         2DMBmyUiSAJDatU35PuNyKMwwXyXQCrjxzvzz44EvAy7mZYweARVrT0WUWxRJp0k3DOf
         WdDpaBwGnaTjS67rbnFRo3WHL45CiczvXBsdxcSa1I1dia1wbkXsbDCRjkCf6NQ+Z2V0
         Pe2w==
X-Forwarded-Encrypted: i=1; AHgh+Rpowc3r/P1SdmJlGQsXJdujq8YFaYSs7to461Z+6mODlNANoh7WusY5sDGjAcht0TPg7vXfZX7qPQ==@kvack.org
X-Gm-Message-State: AFuF++nyJB3fJg5TPB+nNDThFCc5CjNLbdOExTo6ZX8I2/5UDF2l4o1c
	igE2wTsm+KfaPmt9DCgN6QiMSww4oUZVtMk5+Ll8wIPynj3WJQVFZvR6oKMQdt8IXfI=
X-Gm-Gg: AR+sD119+96Xo8vSrb7sxw9OykBjJjiXgWPUJLcitFX/W3RB//yqygRmkNsQGV0+imd
	RBEZK4QNRwrXSIHXF/ft5jm64I566treSmahDLXSWs+K2w5URlPLL7ev1JvLLUPXNVzBHJSD2l7
	zqsVFnOqA5wWsho2L8RfU7cqAA1Coee7WBe2LBPimFIT1z3Piwnj3zbdzX2824yu9h0eTHDWij6
	wcFZA+9nRaKrZZeG3b4S6UFcD0ERWKznaYqJc7u0sGegYMzRNtfEsxwJW5RnmaQnvj39psHwW1Q
	A6jgIfixZdZXVDF9zSLfKlh8GDk7dd/My/qqMbtDeVwHjcemGrOdFX98q5ptC1Yq5THethCPm4x
	21/Ef5hdFpteYWRmoQTz1AjJMOFj33lFrc8BzRAI8SZaUi2ll5PCoulraP2udg3e59ahpJMaLNd
	T8lyU9LJBBXGUBVdZAUmeL1iBegDY9qsuDJT3x8o2cjYEaGv4ynOKdQxHa+7VJvOSG7kz42no87
	u7qv4+4TDp9YZjsrcEQPuloW9SoPt/NF6k=
X-Received: by 2002:a05:6a21:328b:b0:3c3:7a0a:18a6 with SMTP id adf61e73a8af0-3d2688b71f4mr29680395637.18.1788066850343;
        Sat, 29 Aug 2026 22:14:10 -0700 (PDT)
Received: from MBP-Krishna-Iyer.civet-hops.ts.net ([2601:645:c68a:b830:d101:1d:112c:715e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286fa37fa5sm22595810eec.29.2026.08.29.22.14.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 22:14:10 -0700 (PDT)
From: Krishna Iyer <kiyer@crusoe.ai>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Krishna Iyer <kiyer@crusoe.ai>
Subject: [PATCH 1/6] mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
Date: Sat, 29 Aug 2026 22:14:02 -0700
Message-ID: <20260830051407.50008-2-kiyer@crusoe.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830051407.50008-1-kiyer@crusoe.ai>
References: <20260830051407.50008-1-kiyer@crusoe.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 35j9mkjn1176yxkcgguo8foenzf5dnyy
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8285320007
X-Rspam-User: 
X-HE-Tag: 1788066851-245318
X-HE-Meta: U2FsdGVkX18rCmef4x8lt/FZODQwEAnMuZDnufXreCGFJXf385Hyc/A8WHJNYq6E2qr3tMoilFO52oQGDxGK3I7lsTjZAlUYb3ogCWPa9PkVpPRSnkNOMReJY4ziX+dHXI+ab6o7OMxDGOsin1nR8sa5YMEOVqpAFCRL8j0DPv98KkRyGR02S/YnWW08NBgwEGle9H5jXkBJeEYHhsjwkSzuu7bIQnUrjuX1T6BhXs6VOayw6tNunPgnn7Qbcfthh6QUvvqGDYe92bZap0h8mrxIwGQBV3pzwLcAboBUukrTs6Z3eAVygCQXQRJWSJrvTFp8zsvZScbEaVkDFcXFvvO1hxyzckrS5t8Uozq7Zg20mVdelbkBacqPGgi9TshYzmiNlX3d76/xouHIpR1pVwqPg63ggBfaBjhXzUaxmdIzYly00mNG44LNvbox7XtPyuXAYBdGhBJqLtzfquEHdPfStQVkHGtgvESpy+ZIeEhSaWPrKXXAesJmiCigrTyDZ3WVUgR7MUX7E5guCGhSWhOjy0IkqmZvhDuroTqcBJKPgNJZVSIJjDdbpgRmsNFxKCDY4CahEii8vpqwOO87jY/Ob/ua6IiHgDbu70DMuH8J2JL8DXniALg0IuqTop1yKT1wWcnHGq4TGCHYBoNHShuY9v5WAG3EjjXFXg9mAOOxcJtb1n496mq5okirebu7tgzbhvK5anacgh5IdpYX9nd+AtOJpROQ+lxmSC3Y8mDS1Ky6TUmULlcN6js+oX4NQYISMrdrra5L4kbqC7qFEEHg4B5K4Vpnv76N+xGm6YwdSDpYk0J417efPxpE3z1e3nESccc9fvkJTv1DIcu5X3hoYWYEf069TThnSJhjZKYgfgmdQtAdxpHJq493W/dxBKbcVtYog4e7p2jj8EL5LUm0KMdrfl3vs3mFHaryPg/xWvh3OsC7ogzmd6Q32tmZIr7P0PjBDJBoO0c1ntA
 vUkDgGzt
 JEA3iPrxUa8GIu87xCxXH4aQ/q8oNVi6+xlwSzf3QPck73PbG1dngic/FZbTh6VTlKFLrZNLJMtuilIrUPZf4sEMAkqjhZF0eOgzDbtxR2x/7H4FgdXujq6WyVZd1atTQ9QME5O5IiZBv14eoDTD5jR8e7omoMDZiiQTyW3tEen+T9gQYEmGOomrT4Pr57vTwYz5dIyUHvDyjoMsHNxi9Rhj7I3Nsw2kCTGAawEZQvJKxw2H+fC0WOpuyZpnwg3cv3bFChxt+MAIfpY3fXS3CStpcv+jmIyvHPX0nOgVsrkirLbF+udX2QqBZrqgxUC16oSiSDr08S7o8gYufeHP5MqYXuUDAQg+kWN0bkikG9ElFqFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_hugetlb_mkold() clears the accessed bit of a hugetlb-mapping huge
PTE and propagates the aging to secondary MMUs via
mmu_notifier_clear_young(), spanning the whole huge page size.  It
currently lives in vaddr.c, and is thus usable only by the virtual
address space monitoring operations set.

The physical address space monitoring operations set will need the same
logic, to support access monitoring of hugetlb-backed memory.  Move the
function to ops-common as-is, with no behavioral change.  A follow-up
change will use it from the folio-granular rmap walkers.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
---
 mm/damon/ops-common.c | 30 ++++++++++++++++++++++++++++++
 mm/damon/ops-common.h |  9 +++++++++
 mm/damon/vaddr.c      | 27 ---------------------------
 3 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index fbda70d8ea4d..f5fe92b825bb 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -3,6 +3,7 @@
  * Common Code for Data Access Monitoring
  */
 
+#include <linux/hugetlb.h>
 #include <linux/migrate.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
@@ -98,6 +99,35 @@ void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	bool referenced = false;
+	pte_t entry = huge_ptep_get(mm, addr, pte);
+	struct folio *folio = pfn_folio(pte_pfn(entry));
+	unsigned long psize = huge_page_size(hstate_vma(vma));
+
+	folio_get(folio);
+
+	if (pte_young(entry)) {
+		referenced = true;
+		entry = pte_mkold(entry);
+		set_huge_pte_at(mm, addr, pte, entry, psize);
+	}
+
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
index 38d295488fa1..f7811c9c7a02 100644
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
index 0648400b2d65..15379d984689 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -293,33 +293,6 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
-				struct vm_area_struct *vma, unsigned long addr)
-{
-	bool referenced = false;
-	pte_t entry = huge_ptep_get(mm, addr, pte);
-	struct folio *folio = pfn_folio(pte_pfn(entry));
-	unsigned long psize = huge_page_size(hstate_vma(vma));
-
-	folio_get(folio);
-
-	if (pte_young(entry)) {
-		referenced = true;
-		entry = pte_mkold(entry);
-		set_huge_pte_at(mm, addr, pte, entry, psize);
-	}
-
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
2.54.0


