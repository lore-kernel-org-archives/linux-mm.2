Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F353FC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 02:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C8E6B008C; Tue,  1 Sep 2026 22:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344E16B0092; Tue,  1 Sep 2026 22:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B606B0095; Tue,  1 Sep 2026 22:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D55CE6B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:57:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B2BDA465C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:57:08 +0000 (UTC)
X-FDA: 85167310536.11.0D157A2
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6C04540005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:57:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=NunT2goU;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai;
	spf=pass (imf01.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.182 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788317826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AfIUElBfsBuc32fcVrUuC+qxuGAKqGDmpiNow6bdW8=;
	b=H3dnj61OsCXBiGb6Kq0UAkl9J8/I1n6HciRMGo9M9Llf8SqM5X4oce2WzhFeGKSP+tW5cW
	9W1UMO/fUaCg50wFHuDmmWybbGIVsRwSaPUmd5rsrMXfk9vYmOYzgdiXcAQjD9FiCJ5sdQ
	MXB5SaAuj4TBM6SqghxNWoI3+R1e0Yg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=NunT2goU;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai;
	spf=pass (imf01.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.182 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788317826;
	b=3kd1m1suXQHkBGKMJP3j52Ltu2gDw1hIURQ3mkMP06kb0skkIUrR0WrwBID/26aO+E/Jks
	dW/lWk9HcO2VKHoq7PUoxMj6NQ/KRoBIaC0U12SQ4SCJMqLoPGbKSqEUUU5PZnYot9/vvw
	yiiKY5zvJ8C+f24f+eneqP43KCQ7xE8=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d91ded8174so4115425ad.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 19:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1788317825; x=1788922625; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1AfIUElBfsBuc32fcVrUuC+qxuGAKqGDmpiNow6bdW8=;
        b=NunT2goUG5kjtAQzWuXNOTfPBnYg0XH2/E2EAwHLfI5mP+ekhd7boxl2uPoiMQGR9q
         rIsVJKbNIXu6H8C+MSmToBhvzJD6liBROR2rWvZjDXx0z560seEq/l9mPj1yb6qnEBiN
         94BuWHKsbi0cdMGMupxzvmW9wpyTEYU7ZxzNpiJhBvcZ7uOlz2LPl1KRn/xK55J1IoZf
         yBmQjM667cI/HNpC/KLGLeBkunZVB3WGuRvBUvtbI8HpviUIMpNJkMsh7beaHjnJ5Dyz
         5b1DbM/UHHE9zdllTssW6Xf4ibG7hrd4tSeoSgH5UqYiSIxSTW78GHbDMujpynDwgH4D
         FfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788317825; x=1788922625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1AfIUElBfsBuc32fcVrUuC+qxuGAKqGDmpiNow6bdW8=;
        b=rn8dWvSlrKYsc0x59ekRcblicNmqF1Z0EkDVL0ErCCtjqXykGmxArcbRSHjiP4MXV5
         nqtH/itqZBB3rO88uiSysejQUpPmo2mjPRb6Nq5H/XattRAHCowwaI89gZiPp9/XX9Vo
         plkXPwTCzdQOxRQjY0zDLMHjv7l/u8lwT9MJvi1WhQBhu/jvoM9PDMxSwHpFUtXeTDRw
         6fTheh0GhGxBvzzk2pO0RGNrGa4AKL8Mt4LCOFJuSvr6zkxs+gwgzt0dc2QnghU+YQKk
         TN+qh3ohyMsz/Ypt974cTbbvmtZPk3z0v5ciM3eBVCuN8QjBEK9TG/Msw2r8pb3OTh7B
         Kh+Q==
X-Forwarded-Encrypted: i=1; AKwUvBwi92uk5uLVPcB/MF0LuyjLjzyJsDNJi1BKJRFx0THDTLFOTT3as1kCvLopb8by0tvCONdr+1bo6Q==@kvack.org
X-Gm-Message-State: AFuF++kCAx6DrLPXFlj1t9APVLB+0gmsArjzJm3Dgw0x+GV9JkNCE3zw
	qDL0b/hTL0W7O3Pxe+RsIAA99fZ7N6wjnE4FkwTkBWNRTqliNgJ8TYy/EELm6oQhkQ4=
X-Gm-Gg: AYBFou113kDm0PNupT6XkqpVDpvosSRAKyQ+zolgLjTLchX6dJs2rgHwYuQOyjHao5N
	1uchIsVTo0HvEuJI3YCH3koGUOpmcyfUzdQ3ewX/ewAx0v38Z0V+MFcaOljVQZOGknOB41RF5D8
	jACIsxuKn8H2r4IktafB6DqYAbQyTelIN8BrVOVs6Zbp89kz0+ylM15bt5SASV0cqyCnlV2qMqL
	/NIkF1oNMf+PZ6WFXRs35n2A6VFpCI2cX7EoN4pYmp2nhVrjW8BCMQkFinMfKcZhGjWwGRBfL+I
	SHEjcbPfIVQeTLk2ay6anHv1GiB0/f01ykSDVo7AjF3XAym7uSz6ZppNjkfDL8Ta5jnkv4JrJRi
	dBxMXtOZ/LJoAR2z+iVSMUawUyikPTCSvWQxVdhPtW7fssK3Ab73MgLOPMoFzVFljYkAJmYYq93
	ZD7M69PdeyVHPIYWwEbAJORqrNwCuhhWYsELb2iC3EM7q1k5zVgTKaE6ec0r+H8nzxt74r+gONT
	mcpnMRP3/awq1HBZUmUKb0C0qbOJs7T7374
X-Received: by 2002:a17:902:d491:b0:2d9:3636:d01a with SMTP id d9443c01a7336-2daec74e5e3mr22490315ad.15.1788317825337;
        Tue, 01 Sep 2026 19:57:05 -0700 (PDT)
Received: from MBP-Krishna-Iyer.civet-hops.ts.net ([2601:645:c68a:b830:a1c2:77c:7ab7:f9a0])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f07bde5bfsm2066469eec.27.2026.09.01.19.57.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Sep 2026 19:57:05 -0700 (PDT)
From: Krishna Iyer <kiyer@crusoe.ai>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap walkers
Date: Tue,  1 Sep 2026 19:56:59 -0700
Message-ID: <20260902025700.17975-3-kiyer@crusoe.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260902025700.17975-1-kiyer@crusoe.ai>
References: <20260902025700.17975-1-kiyer@crusoe.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6C04540005
X-Stat-Signature: 3xbehwo6wbisbkj8zgesicpidx11b3ss
X-Rspam-User: 
X-HE-Tag: 1788317826-529408
X-HE-Meta: U2FsdGVkX18Io6w+ptN8QvaEHT2FlpwEzvCXQQABzax1TOzcvL5sIdLuiqHwNYkCeCpXednK3dQmBYN/bA2LYj0bEsdeBG0i/KYlrqlCGn+E2uFj4nY84YM4YWWC6iw9LI4GwaQKn3rRvgkQKPeCNwSiDb3giPEairQI1v5bBfrk7+bPSiFj9Z4EcXXTojoOvKvh93JvfbN2r1pFyMqqBXS0TE9DoICgsUi7a+fec6bjxwEitTJAZs0Do1b3O62ur7ZpYNuJCr9IjRl9JP5A50gHOmz6nG9LDCQkEJm00KtMkl9w/Y7rrusBDHt4wmrhDRCewhE2DJf0gDbuditZXYt2L2pe1oatkWqGwqWrhj3fDV+ELnPR6AMCRTqn9hopcMNuBtnEE8pIJxIneeg5ldZp8NRqstecFBpLSKpLL/MU/J4idLgX2WT9tsjSu6OkaOwYtxgmd5PP2Lf1p87idqtH2Ul5WSGDrJpU0KsCKi0dy/2zbl3l1R//4WQhyEpaGEwWUAjftYNkSY+VGlXCNlxwbaYgHdWQV371BXkE+vRxGn3GUgTlXCNrWK5lwkYV84UprzFtftx9SfM4ZmWY6eoGZ+x9ggwbsPWiZ24UN96VOYeWZp3wqvta+ity/GLc3d7k+SSl6tIVy30Zos2giaQbB6Z/q6oAPMfP7cqIsOEdaslzL7heE9bqo+eymOQtTjiWVutwVbbw5PRwpdNKZl1DAwWoifOwYBSwnNURph2w/Jj2ftowFQt7Exmjk3jVlr9tktu58g46HPP0aLdRuIEPSnWr2bB0yMtRMEL7NfEj8YCqj+59ZT/3+qtab/G+6eoiRKsKhoEvT71K2tax74NGC+Pe+ttHiql6CLNGT7oBucxSPotPPN/8LrnS7ePZAo0k6akM19TgF8+vhIl3gHJkhlMBePTGGp2fym3kLl+6iZ8XzkwjG+k6ubpf7WIAXUdBY9HliRvK3zR/4ra
 hCHUXi0c
 myPEMfzS7X2sV2ll+4dbnGmzOma7V/amXFL6276C806mNOx8S/8bV0ZRBGx0Ak6D2dDamuUMv4wysqdS5ASo676zv6An6BpldDL0VpPjHM4VArVhfud7dMYICzlwOJUdEaZqL7G9o2IyZMAtqzzpmyPaEuOFCR/6keUbUW46QIDci4IkatS7VJqqwgtYywMbW4PEH+fED+pm1K33kHRlS3TGIE777BwU5H7/xnrNhkQS8a5TtTQZbBz0e1yNoJeJPdqdqUGNMuKo3yqVkRuDj0KIuSwHXuFh8UQvi8P/oZPogo2EH18Sjs1vhwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_folio_mkold_one() and damon_folio_young_one() assume the folios
they walk are mapped by normal PTEs or THP PMDs.  When the folio is a
hugetlb folio, page_vma_mapped_walk() returns the huge PTE in pvmw.pte
with its page table lock held, but the walkers treat it as a normal
PTE: they read and age it with PAGE_SIZE-granularity helpers, which is
wrong for huge PTEs (up to PUD level), and notify secondary MMUs for
only PAGE_SIZE of the mapping.

Add hugetlb branches to both walkers.  The mkold walker reuses
damon_hugetlb_mkold(), which the virtual address space operations set
has been using for hugetlb aging: it clears the young bit of the huge
PTE via set_huge_pte_at() and calls mmu_notifier_clear_young() spanning
the whole huge page size.  The young walker gets an equivalent new
helper, damon_hugetlb_young(), which reads the huge PTE with
huge_ptep_get() and consults the page idle flag and
mmu_notifier_test_young() like the existing PTE branch.

Locking mirrors what page_vma_mapped_walk() provides: the huge PTE's
page table lock is held inside the walk, and for shared hugetlb
mappings (the only ones subject to huge PMD sharing), rmap_walk_file()
already holds i_mmap_rwsem, satisfying hugetlb_walk()'s locking
requirements.

This is currently dead code: both rmap walkers are only reachable
through damon_get_folio(), which rejects hugetlb folios since they are
not on the LRU lists.  A following commit will let the physical address
space monitoring primitives opt in to hugetlb folios.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
---
 mm/damon/ops-common.c | 61 +++++++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 14 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index f5fe92b825bb..373b25db5950 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -193,10 +193,15 @@ static bool damon_folio_mkold_one(struct folio *folio,
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
-		if (pvmw.pte)
-			damon_ptep_mkold(pvmw.pte, vma, addr);
-		else
+		if (pvmw.pte) {
+			if (folio_test_hugetlb(folio))
+				damon_hugetlb_mkold(pvmw.pte, vma->vm_mm, vma,
+						addr);
+			else
+				damon_ptep_mkold(pvmw.pte, vma, addr);
+		} else {
 			damon_pmdp_mkold(pvmw.pmd, vma, addr);
+		}
 	}
 	return true;
 }
@@ -221,27 +226,55 @@ void damon_folio_mkold(struct folio *folio)
 
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static bool damon_hugetlb_young(pte_t *pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio *folio)
+{
+	pte_t entry = huge_ptep_get(vma->vm_mm, addr, pte);
+
+	return (pte_present(entry) && pte_young(entry)) ||
+		!folio_test_idle(folio) ||
+		mmu_notifier_test_young(vma->vm_mm, addr);
+}
+#else
+static bool damon_hugetlb_young(pte_t *pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio *folio)
+{
+	return false;
+}
+#endif	/* CONFIG_HUGETLB_PAGE */
+
+static bool damon_pte_young(pte_t *pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio *folio)
+{
+	pte_t entry = ptep_get(pte);
+
+	/*
+	 * PFN swap PTEs, such as device-exclusive ones, that actually map
+	 * pages are "old" from a CPU perspective. The MMU notifier takes care
+	 * of any device aspects.
+	 */
+	return (pte_present(entry) && pte_young(entry)) ||
+		!folio_test_idle(folio) ||
+		mmu_notifier_test_young(vma->vm_mm, addr);
+}
+
 static bool damon_folio_young_one(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, void *arg)
 {
 	bool *accessed = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
-	pte_t pte;
 
 	*accessed = false;
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
 		if (pvmw.pte) {
-			pte = ptep_get(pvmw.pte);
-
-			/*
-			 * PFN swap PTEs, such as device-exclusive ones, that
-			 * actually map pages are "old" from a CPU perspective.
-			 * The MMU notifier takes care of any device aspects.
-			 */
-			*accessed = (pte_present(pte) && pte_young(pte)) ||
-				!folio_test_idle(folio) ||
-				mmu_notifier_test_young(vma->vm_mm, addr);
+			if (folio_test_hugetlb(folio))
+				*accessed = damon_hugetlb_young(pvmw.pte, vma,
+						addr, folio);
+			else
+				*accessed = damon_pte_young(pvmw.pte, vma,
+						addr, folio);
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			pmd_t pmd = pmdp_get(pvmw.pmd);
-- 
2.54.0


