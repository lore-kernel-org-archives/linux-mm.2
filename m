Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76EE1CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D30E28E001A; Wed, 12 Nov 2025 10:42:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0DB8E0002; Wed, 12 Nov 2025 10:42:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0298E001A; Wed, 12 Nov 2025 10:42:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7ADB8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75BE7597AC
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:42 +0000 (UTC)
X-FDA: 84102372564.01.5F8E2D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C4497120010
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YJPkMLOQ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LxJbN1DY0YwnOXjWOCxFlR4LfgpZ3g9jcwOJjrcOL+w=;
	b=tFNimk95E8Sxo+lIETwppW0ZUPCF7iTx5YW325jNRgvPuteY6xkUtByTpV+AdSzalH3jHX
	M2wOS7kn0mbY9tOxmWlwZuKHmVPGP9NYY+ywvCwaWWUxyCww9yWotvwz6CC/+DdsGChM3s
	Ypy0jKXf2+XxE5hkk3KnzIkTzm+i748=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YJPkMLOQ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962160; a=rsa-sha256;
	cv=none;
	b=kFzJyhdMUyO1HXWNu1qYXKHOkc1FuTYPKNqiCoNxq5eFmAqcErVIm99KZnThzvyq+VoBtP
	aVwleF1hr1CbTyA1vEfb6XmkvtJr9QXaT1TdjQB5bmxrzMyBcMFEB8F85N9nKKJgU7vxHD
	j/eIBBcHQtFVZCt1LA7pFZ+xvsnTiXs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E783D435F4;
	Wed, 12 Nov 2025 15:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA50C16AAE;
	Wed, 12 Nov 2025 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762962159;
	bh=fyGxdylWBgAVN1pPbqolUxiQxMykoRKgirgaM7k7Lm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJPkMLOQM8CjnT+976he2HZY6GupzdlSz309HLegPA5L06cVXuJWLwg0Fk/XXWNUC
	 j5lpRzEVSqTzbY0SvInaI3YLw989pC2Uql8SIqSHl+s2X//n71ukEeDUvwdr/C3l9u
	 tnajO7HxephoCH2YXNUkNhmnf8mp0j1Kg/hAEoDU3WRGDWgmx4wZ2aCZYp3Es4Kg43
	 MfyX6StfLBBwvBNihzy510M8FL/APG2NE+kgce6za0HjGVbSqw7+breLPufbdI0BRI
	 7Zt4esOBgnllnoTXCVrCU4x0wCh3RrhlYZ7Mkk8RAto4djZmBTE/sJJ9/ukI39X7YD
	 UZ5CR54rRz3HA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH 5/9] mm/damon/vaddr: consistently use only pmd_entry for damos_migrate
Date: Wed, 12 Nov 2025 07:41:08 -0800
Message-ID: <20251112154114.66053-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112154114.66053-1-sj@kernel.org>
References: <20251112154114.66053-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C4497120010
X-Stat-Signature: zccu4tabhf8ywqrz73gqcqdch5zubnc5
X-Rspam-User: 
X-HE-Tag: 1762962160-39635
X-HE-Meta: U2FsdGVkX1/bI8V6Y4nczaiSwxeFnuLwOZMiUhnI3rKahTsIIbS3Fzjx9amIoBnANuPAg7+eAU5ncsax1Kx5gmC2tK4ZZanSbDF9IncjrzrhjPnsZlC0wsBlSJN+GILRo5eQkQO40q78Qps1o4UKBYlaFirY0Qucb5NBSUwj5Uf25KLmjzRzeJfc83CxPJVKKSTZWoijQboH4DkEsc+PdE1f7l67/9+l4Js6c1jfZaPODUrO69+YU/QDMoCOO9ccVBjg2YnhLbDH/VmtFjh8SF0GNYr9s5cYKND5VENbI6AlcKSQDA+MP5qoF99bo4Yl4iwjUQD+o48Dx8xOndplpPKgh2HEavUlYgy2avKpHJ1JTis3ULojOR6Su9OLNvFS0cp3sjWeQZUNzAy3xhTGyFsvjFUFye6kYFqHdZUMwEDpCdxEt3klkrM82ydFTjhejU3i9jXURYk4B+i11plM8pzh/soN1oDmwdxgwSDOxIHrs2846YhCmhpMP5Ldvzgit4zpqLRx2D8/a3Q4DsRepPzLEduQz+HvXo+nNT3egpd87kx0qRU0YWMC+fLk5vyIvV0fQEOGqQ29olhtNivfFjVTDPRoL67N5cI17q/M6CTzPcEafDgHiPMaWD85lwkSflwTBOnelbFeIWpcGbaweWPOJKaShxrF/wAFeTdvZLr4W0IfCPVMlu7uAO1rGlrSYFyot06CcRKJ9BDAYQ3RUuLgs/ET3t58v2NvFLfc7CTdc3rffozexIEE3W0L1AoZjjSPB6rBnBa9oVJ7Ca3E/KHqkfyasXPuk9TO7bzfDXXc1dn97SIBEes95PYvFw3H+uvIgSILuzQ+Incftasqp4DfI1W5NYI7g1PET7phv+BCiq2fP1y89KgF3+PDqmE7mYMiDpR//vodqYx/HtVQmr9qY6NGs3BKMjtJIdGAJRG7U2v9bVtnA/2Kyrc5Lm91url5zi4sCBIoKa20DSl
 0eT32KlW
 Y1k/2uAe6gvwmfYwP2wNGVeXT3S/msKq6dMzeAdvyhYT0/LA5MFmCszdsZSEzFp+ggil2iuf56FooykUPqdGJrT9jSHY37SnTWCSmO3SBQuC4hIsY/g7RGFVcgR81AT1ZGtVBBalXlRusUjlWQxrmfaGw3sKDYWlP4qrJyft41on4a0pIetNRN/c/x2Nmrzb/PwulDWteCl4Y99JieBzdLk2sS+2d31Dx+PTqdST9RvKKO6qzkWihPmsg+riMpKTDE3H2d8T6xHpfitp/WdHM6NLcxUNXjVyD7OdtR2cQEnzPb8R0OG057uwBWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For page table walks, it is usual [1] to have only one pmd entry
function.  The vaddr.c code for DAMOS_MIGRATE_{HOT,COLD} is not
following the pattern.  Instead, it uses both pmd and pte entry
functions without a special reason.  Refactor it to use only the pmd
entry function, to make the code under mm/ more consistent.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 84 +++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 47 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 9c06cfe4526f..ef57e95eb422 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -695,7 +695,6 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 	list_add(&folio->lru, &migration_lists[i]);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
@@ -705,58 +704,49 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct folio *folio;
 	spinlock_t *ptl;
-	pmd_t pmde;
-
-	ptl = pmd_lock(walk->mm, pmd);
-	pmde = pmdp_get(pmd);
-
-	if (!pmd_present(pmde) || !pmd_trans_huge(pmde))
-		goto unlock;
-
-	/* Tell page walk code to not split the PMD */
-	walk->action = ACTION_CONTINUE;
-
-	folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
-	if (!folio)
-		goto unlock;
-
-	if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
-		goto unlock;
-
-	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
-		migration_lists);
-
-unlock:
-	spin_unlock(ptl);
-	return 0;
-}
-#else
-#define damos_va_migrate_pmd_entry NULL
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+	pte_t *start_pte, *pte, ptent;
+	int nr;
 
-static int damos_va_migrate_pte_entry(pte_t *pte, unsigned long addr,
-		unsigned long next, struct mm_walk *walk)
-{
-	struct damos_va_migrate_private *priv = walk->private;
-	struct list_head *migration_lists = priv->migration_lists;
-	struct damos *s = priv->scheme;
-	struct damos_migrate_dests *dests = &s->migrate_dests;
-	struct folio *folio;
-	pte_t ptent;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		pmd_t pmde = pmdp_get(pmd);
 
-	ptent = ptep_get(pte);
-	if (pte_none(ptent) || !pte_present(ptent))
+		if (!pmd_present(pmde))
+			goto huge_out;
+		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
+		if (!folio)
+			goto huge_out;
+		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
+			goto huge_out;
+		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
+				migration_lists);
+huge_out:
+		spin_unlock(ptl);
 		return 0;
+	}
+#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
-	folio = vm_normal_folio(walk->vma, addr, ptent);
-	if (!folio)
+	start_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte)
 		return 0;
 
-	if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
-		return 0;
+	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		nr = 1;
+		ptent = ptep_get(pte);
 
-	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
-		migration_lists);
+		if (pte_none(ptent) || !pte_present(ptent))
+			continue;
+		folio = vm_normal_folio(walk->vma, addr, ptent);
+		if (!folio)
+			continue;
+		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
+			return 0;
+		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
+				migration_lists);
+		nr = folio_nr_pages(folio);
+	}
+	pte_unmap_unlock(start_pte, ptl);
 	return 0;
 }
 
@@ -822,7 +812,7 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct mm_walk_ops walk_ops = {
 		.pmd_entry = damos_va_migrate_pmd_entry,
-		.pte_entry = damos_va_migrate_pte_entry,
+		.pte_entry = NULL,
 		.walk_lock = PGWALK_RDLOCK,
 	};
 
-- 
2.47.3

