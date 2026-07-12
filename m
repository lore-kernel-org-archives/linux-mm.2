Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 703BEC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 17:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44466B0093; Sun, 12 Jul 2026 13:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C426B0095; Sun, 12 Jul 2026 13:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2B76B0096; Sun, 12 Jul 2026 13:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90E036B0093
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:03:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 309C51C4231
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:43 +0000 (UTC)
X-FDA: 84980746326.30.5DEBF53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9378120005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K3VaMGI4;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783875821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5xW2GMWQ2fJulemhF10bJTV6JcOyhTF3brjsm/0yqc=;
	b=EqxqYkNhqRHodUpspF/dNSKLTkizLYoBt0VGhi9sGy51Jw9RHFBCL6LaMCwedJ68t5YIXC
	/pXxXQASnQxqCqwp2Wyeh8unSzzY1WqYlyc+ozDMHnLH2MsMDeX5319MugdHDSFr3uTfbl
	rHVRzI/4JpLadFEl8UNvYwNXEH38R3Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K3VaMGI4;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783875821;
	b=bSq0/FSf3Lb6q6VfBSCHDYbKxbkSWNWhcoFQ33ABxAqmZ2kHDgjVrxFZLgGL1ghBiiiNMB
	gLBDS/rP9WTJH4Bf4znsPJq88E3VSBDMOTaAbvjerguAqGoDVgwecil29KbzuKOB1897Fr
	Vp9JSIJAcJ7l0y0+Y8bqfhOiBFHu2ZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E98860254;
	Sun, 12 Jul 2026 17:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A9E1F00A3F;
	Sun, 12 Jul 2026 17:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783875820;
	bh=Y5xW2GMWQ2fJulemhF10bJTV6JcOyhTF3brjsm/0yqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3VaMGI4TyeJ5+PzRVirqrge5WUaVVa53j+QN2P8SmdEFEg3xutS40c25/o97BgMc
	 kwp4o55qHO37t7Y/5bbHjb59fckHhRZOeMgJNz5lg/p4g0aLsNCACTXULm30U0Bs0z
	 WCITAbrq1ea8ZvsV3Jy8LmpHm6DLsgcJGcWnGF5aNiOC79Cy9DO/Da78+OW6lDmJtr
	 xhBqrgx4PXiwc+xDv+XVflDcf2xu0epXhNUJUP6FAWJxN/fOIdpanW9LyjcCr3IOL7
	 G8ZNRGVaZVvst5/xV0xuJr+iQ2vtHw+cHldCtB5jaK79QYutZydKFlnudYlwZzBQQ9
	 Uy7UtpgsLq1uw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 3/5] mm/damon/vaddr: drop last same folio access check optimization
Date: Sun, 12 Jul 2026 10:03:25 -0700
Message-ID: <20260712170328.91144-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260712170328.91144-1-sj@kernel.org>
References: <20260712170328.91144-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nkboxn1sszq4b9nrqw8ipq5gd41yc5i3
X-Rspamd-Queue-Id: 9378120005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783875821-418643
X-HE-Meta: U2FsdGVkX1+MTQ8j1MQ+i0LRIgzDRFEfJCpiWJD9QZ23jRG2aj/qNcVgD2EYto4mJEAJvLmuuIKgLDTmXQdpqyR3qKr3Ali04dwGh2SAm1oy6waa7eid0JQpM3kNVqPAUucqzCBW9ACVDnNRZi2c6qIdxpZfJaxUvmN2Srli+Ewl+5k+HaBjPlwxDwbfRlfgps5Kl21lI4cDCFtWoJefm4KEQO0+RM6ggpHvHGU+1XNou4kWxG8kE/KaiC1L2s15++PXp7fe+FqVZc4WuqS/2DYOixh3m9wRGr5uxWnTZzbPPZ+Fd3jTXEOHCwtxNDytmmzlVnVSqE9KwNPI6LFbuOp1dyqB7ZDkR2frOqiVuJlXKPjz31peM31mWmfDEUvWoJ+xbFbKyIrJwdX07InkW+0Yc1oFBXN/mebNIR75dXKx3slPjFFkl9k1zaC7slxfaFtTFyijtNyL7ZwVVW2qoRGwhNKoa/u++iPX8y8CKR/np5tENdSK339cvzV6xWq1DU86N+6Obl22+WFd+/fuuGFTmujm+bggtCvB0a3PqTUKC7W+IDj9pa+Zvel8IGHXwjGhFmcsDfB1cFcUhovHM3YlCIeIhDkbxLItrZoptt/65EKBRzbrDxFDgm2WcTXzPQLcfPuS7FvLzsxz8ku8porm7ZwifkO6BQJ55ZoalYZS5FjuvDu0bNeGt2Mz1JFOAkOYuFW8gWTp6AjdswRBJSzD5VcSkrGfIiA1pNHtA0EZeys9+wyhjJx3df9EdH2TBzvwehfho2AJiIMgSRFne5sFcJ9Ni0ni0yuiwj82/xVDvk4vW55fovXvpscDbN7+z6DngA/K1q+69vSZ7n45XJBlAZb+oVukE6p6qD3oegAajuGl314c6W4q5KzDFsDYNHxu4PhB5Ost1xYxQ86I9KEMUGhTjC9ryyjnrwwklu/XfWCpB66dZK0z7eFJLCzopJvCjxZ3LEeeHKw5kWb
 OP9L7STI
 dFEgzqCGqDn0OYPn8tooxYJwtFfsoN/sHtM9bhkgNrRKQ63uxqT0U67DYj+C6rm53YMKLWN6nueRcbAb7+BT4D1in+s5yU1Ll3vXsvc+kcNXlT3e5LAjE2p/oKRtAezVBCU6tcoJfD12HeCVGdlige8KS6DVjTZMDTo1XjkHp7XCIX6xCCHCDDly1MVgOM4gUy00vvpGBCjOKroBYAK3m5GVi3JHYa7N+K/DZON0zb1QklP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The optimization can race when multiple kdamonds are running.
Meanwhile, the impact of the optimization is quite doubtful.  Just
remove it.

The user impact of the issue should be quite trivial.  After all, the
race can happen only when the user intentionally setup DAMON in the way.
Even if it happens, it would be rare and only degrade the best-effort
monitoring results.  No critical consequences like kernel panic or
memory corruption happen.

The race possibility was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org

Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d10b8042adb5b..16fe210d2042a 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -383,8 +383,6 @@ static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 }
 
 struct damon_young_walk_private {
-	/* size of the folio for the access checked virtual memory address */
-	unsigned long *folio_sz;
 	bool young;
 };
 
@@ -411,7 +409,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 					mmu_notifier_test_young(walk->mm,
 						addr))
 			priv->young = true;
-		*priv->folio_sz = HPAGE_PMD_SIZE;
 huge_out:
 		spin_unlock(ptl);
 		return 0;
@@ -430,7 +427,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 	if (pte_young(ptent) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = folio_size(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
 	return 0;
@@ -458,7 +454,6 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = huge_page_size(h);
 
 	folio_put(folio);
 
@@ -470,11 +465,9 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 #define damon_young_hugetlb_entry NULL
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
-		unsigned long *folio_sz)
+static bool damon_va_young(struct mm_struct *mm, unsigned long addr)
 {
 	struct damon_young_walk_private arg = {
-		.folio_sz = folio_sz,
 		.young = false,
 	};
 
@@ -496,26 +489,15 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
 static void __damon_va_check_access(struct mm_struct *mm,
 				struct damon_region *r, bool same_target)
 {
-	static unsigned long last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
+	bool accessed;
 
 	if (!mm) {
 		damon_update_region_access_rate(r, false);
 		return;
 	}
 
-	/* If the region is in the last checked page, reuse the result */
-	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		damon_update_region_access_rate(r, last_accessed);
-		return;
-	}
-
-	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed);
-
-	last_addr = r->sampling_addr;
+	accessed = damon_va_young(mm, r->sampling_addr);
+	damon_update_region_access_rate(r, accessed);
 }
 
 static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
-- 
2.47.3

