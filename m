Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE71CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0872A8E0017; Wed, 12 Nov 2025 10:42:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E888E0002; Wed, 12 Nov 2025 10:42:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6A48E0017; Wed, 12 Nov 2025 10:42:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA1048E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88DA2C053C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:33 +0000 (UTC)
X-FDA: 84102372186.15.C5B9B3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C7DE64000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uWKbwFmZ;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p5nIHaDf2YlzTQy0nfD/a4dkczJpGE1v8c81FrMitYk=;
	b=xYooOAEhNBmAyq1JXeABPuQabEdPaTpDRBV97F0XOuA6SWS2Cj7+KGIb5k5chcLLVXFIEj
	6zzoG1LV/hoIzE/0yBSdPy40vFUZaP142oyc73AWHrIuj4BoKDbS/kIyGFvuTSWNIUqMG1
	bJduAScYhWXrGkG74bBmvheWT0RV1EI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uWKbwFmZ;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962152; a=rsa-sha256;
	cv=none;
	b=CpQc7ylIUKTVYTL0t0flhQr4ZIU3rygGhq+aINQtTI3y2tzCYWouK4hV4HNZjGi9+6Q4bH
	wxX97Dog/4bCFVs23ssC0p0zMsMpmUdO9HJg/SmTg//2XhyyiEOQtCTN86rOAED74YYnGQ
	hn/B6mucG6ndDSrBbcY0KR2hZONA8tI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E944643C3C;
	Wed, 12 Nov 2025 15:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DCEC4CEF8;
	Wed, 12 Nov 2025 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762962150;
	bh=oV9KpZkPcPBVuXqYBkV9kaSGZ1/EOa6v/e8B2pFRGFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWKbwFmZmbqtbdTh322aK72q/tDo78ckesGHoFb9PYCGYvrGLRtAd5Az9X4HS373a
	 GAdfpe+jcawZ78w7TlE8qpfEqZr9g/lqyVEONHn6SkUnAbSCZlcerqNSYMe+zixwSg
	 8zACGTEcu8xIYXj6kzCNxaJIrnPHPe6w9ZgzGscoJHlmjXfRelvA5SimG+/3PNI9hj
	 C4LTWi2mlE0qsAZGTTGeC1sk5LVXHaAtax17Z9DxukagyT9NEcB/wNmPUQ3wyDoI59
	 4DJ0HX2Syt6kAsGAZbtwJC7pwahLw75Bc3MKf/wnqALNCc6Rn5YQuozQ+ATbZ2Qup0
	 Z97FMaJjH7ecg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH 4/9] mm/damon/vaddr: use vm_normal_folio{,_pmd}() instead of damon_get_folio()
Date: Wed, 12 Nov 2025 07:41:07 -0800
Message-ID: <20251112154114.66053-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112154114.66053-1-sj@kernel.org>
References: <20251112154114.66053-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C7DE64000C
X-Stat-Signature: hxb5kt4dn7wamtgise1aqmrctpreoxgo
X-Rspam-User: 
X-HE-Tag: 1762962151-743016
X-HE-Meta: U2FsdGVkX19Y0hI1XBjdb14/MtBRmQP1sjNgHMagezoeoNQTzWV21g0lWedMZLGaz96/34qLolkzEovdxPQuGpaTgDLjTQTfUcw3MUV68wVr2rPVTz6OomMLe72Jctq9okYwE6oYj/wiegnWsekaBiw6Z3tTFev36qcwnUQ8Ywne6xGrKOZI5Cz6EKt6+bCC7COlqfeBNlV5vRN9QyJ0JEniYynmZScQeP9d/KKYjVb0c+0tVrY9VsmdW9x00XsXXHLWzPcS5oVle4zwcLs+FZywPc/jLT7yjZnAF1sWIMAx4LwS7S3AUzmSYVGoFQvH7tBls4pKL1lG/HrjbeYcn+krSOjA3nwTTwTLF3pSoJwo9TZQnRCwgqvF9QewtdgAIQ3hXEFxt8NwiJNw3yTduJjGz0ht2Hv3cmEAfwqgFXcIK/wdiqxD5O3SFFut0sQ8BkGYxIotZcbmgRArTMPgGe7jCd6vyrQN8t+M5jFjvqUV9oJH/PGvKqkqDiF0cX/M19dzAFqpG4yDSDIXKaiYUkbfSg0nw4PxLCL23xD15ByJZO83rQhxb/Gt0Lk+CnrIHPhsDAnslOAVAgqGad+bPz68Au/dz6Q3c7jesDjFa9crE+Ph8AgKxHKDJQZS0Y+MJoW70tkkemMwfN+0QO+JOHoi+lXc+M6shzlbLhJ8qmavJCttxi/PJa9pfLbGNvY2WR/CSo8GWEYYUg5Yim3dVbt59vDc0PzTAXf7F6O82uJw/Rn0ny5ZEHAZ+wHCACk4XuBuqG6FEwqNMZ7j7R1okxnJnAQUQlbrcoHXBebGJ/ktKoBTwPw9PqxHncpYt3ZKMhpPaFOC291JTe8FVCswkNM/ONK1lelilk4JzphLcPOzdwpRA8x19IaqHlYsYNmUgWNUsDzm8Yqn36NuzUQLxkFsd7vVAsiBCByfE8xMBLTLzX9+6UsUJ1YW+CBKzgWrxjC4iVfWaBrmqPLsSXK
 mkBmQpAA
 S+AiUSGbV6L1/d/6KNkDxFEnYB4X0jLiA/Y2uCezrOxZXl1UT4pTZcedf7fCrbnR4pZ6hKir4z/SXhu/mbZxplijEvoz9mA7ugHXaE9lrRa+mBxIyc2KIcXjqhbnd9blO1B4pWJD06+5axfSPCeeA7zqY8T0R49FNbDM0qBjpPbCprNMj8ETQ+1ttsif3Jhdko5GGWZ1uMtOESAeAXbDzaiqOZfFJN8kbzQ0ghAJzS9YUxFZJZoZoA1spiJQEcn90ZG+85IGTibBmxXYBi9WTMBkHt9WQf5HIZ3l84TRnQcxbDKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A few page table walk entry callback functions in vaddr.c uses
damon_get_folio() with p{te,md}_pfn() to get the folio, and then
put_folio().  Simplify and drop unnecessary folio get/put by using
vm_normal_folio() and its friends instead.

Note that this cleanup was suggested by David Hildenbrand during a
review of another patch series [1] and the patch was updated following
the suggestion.  This patch further applies the cleanup to DAMON code
that merged before the patch.

[1] https://lore.kernel.org/0cb3d5a5-683b-4dba-90a8-b45ab83eec53@redhat.com

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 0ad1ce120aa1..9c06cfe4526f 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -442,7 +442,7 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 
 		if (!pmd_present(pmde))
 			goto huge_out;
-		folio = damon_get_folio(pmd_pfn(pmde));
+		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
 		if (!folio)
 			goto huge_out;
 		if (pmd_young(pmde) || !folio_test_idle(folio) ||
@@ -450,7 +450,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 						addr))
 			priv->young = true;
 		*priv->folio_sz = HPAGE_PMD_SIZE;
-		folio_put(folio);
 huge_out:
 		spin_unlock(ptl);
 		return 0;
@@ -463,14 +462,13 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 	ptent = ptep_get(pte);
 	if (!pte_present(ptent))
 		goto out;
-	folio = damon_get_folio(pte_pfn(ptent));
+	folio = vm_normal_folio(walk->vma, addr, ptent);
 	if (!folio)
 		goto out;
 	if (pte_young(ptent) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
 	*priv->folio_sz = folio_size(folio);
-	folio_put(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
 	return 0;
@@ -718,18 +716,16 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 	/* Tell page walk code to not split the PMD */
 	walk->action = ACTION_CONTINUE;
 
-	folio = damon_get_folio(pmd_pfn(pmde));
+	folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
 	if (!folio)
 		goto unlock;
 
 	if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
-		goto put_folio;
+		goto unlock;
 
 	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 		migration_lists);
 
-put_folio:
-	folio_put(folio);
 unlock:
 	spin_unlock(ptl);
 	return 0;
@@ -752,18 +748,15 @@ static int damos_va_migrate_pte_entry(pte_t *pte, unsigned long addr,
 	if (pte_none(ptent) || !pte_present(ptent))
 		return 0;
 
-	folio = damon_get_folio(pte_pfn(ptent));
+	folio = vm_normal_folio(walk->vma, addr, ptent);
 	if (!folio)
 		return 0;
 
 	if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
-		goto put_folio;
+		return 0;
 
 	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 		migration_lists);
-
-put_folio:
-	folio_put(folio);
 	return 0;
 }
 
-- 
2.47.3

