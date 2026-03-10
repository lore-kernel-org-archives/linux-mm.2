Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C939FCC9D4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3266B0093; Tue, 10 Mar 2026 03:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99AD36B0095; Tue, 10 Mar 2026 03:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3AF6B0096; Tue, 10 Mar 2026 03:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2996B0093
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:31:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 477FBB9B49
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:17 +0000 (UTC)
X-FDA: 84529332594.12.CA248A9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8821820006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773127875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=drKr3tzXnm53ueWc82790kKb129KGUY4/JHoVPoSdHs=;
	b=xamaJMhtQJ03PYEC+yjmPX6nzc5a3ZAUgi+K+WKjsZb6DhBcqDLSYXSL3BE4XaaweLXi+X
	C5LSeWiHoZYUG1I6bHerUMCngdPj/SZyb5V+/GIlFzE873PV8OWRYLWBxkD1dVS+UlzzP2
	k2Ct3ykkedFXCmgxcGSuctijf9wsNWc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773127875; a=rsa-sha256;
	cv=none;
	b=nEIZeSApmipIQDcsVl6dPrFvqXkUpkGD6g4PVtYQTl4/nLmSQ2z+p+9ZxsoGwFBbSPhSIK
	3HXDA8cnV4igq2V7dkmQk5vFLMka1qYTYZ0z4x/bBW8eozCXETjLmhITgWEop8KhzFnaHq
	mCIMZGya9rpU9PhSROVhf6tIzSiCFKw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4534216A3;
	Tue, 10 Mar 2026 00:31:08 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8EA0F3F73B;
	Tue, 10 Mar 2026 00:31:05 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: weixugc@google.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	ziy@nvidia.com,
	kas@kernel.org,
	willy@infradead.org,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 3/9] mm/rmap: refactor lazyfree unmap commit path to commit_ttu_lazyfree_folio()
Date: Tue, 10 Mar 2026 13:00:07 +0530
Message-Id: <20260310073013.4069309-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310073013.4069309-1-dev.jain@arm.com>
References: <20260310073013.4069309-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8821820006
X-Stat-Signature: 3wtaswz9w5pdsh5f48km7d85qgbx5jek
X-Rspam-User: 
X-HE-Tag: 1773127875-568371
X-HE-Meta: U2FsdGVkX1+5wtDpYlpgQHs5H8+gQ4YCoVBV8BR7piHbaJUgpXQ7AbrtToRwh4Wwmi8QMop9XUo8gKLr7SOB9/z7GA/rZuIUIHT9fsxcKSBrumhBqKXnFHiyDBwJBM0Bdk6lYNW78zJioomIXGVXuo7CEdycH2k+VyiwvmSnAIFP550tQLouIV47qjWLDefOSL32BkQXXJHUXHPGaBz/DlcgTyRV2xy+5fRbuu6Xp05DKLUkcpL3nSD1Q4C2GukeWBe4ZcbO+EAELytZqa8sys4vD+BBLjqbY2XDvJCJjtD9LpbTC1glOSWa/ERorLn40BcFcOM2IZ5K1moKxHWkMGazAfwStTstlZn4rpTLulhoEiQCJa9Z+RaiI2Y0/znZSIWfJOwseC4d+ZIaoviblIBIIZdSYFydvMg9DuB+pRs1tLBTFS/iXLXp2aSUjGsnY2Zido/6qBeqAQkSdADVcnOwSjQ4ILIg2PsKkgCwpAvGRfzRKmRukDmpySVj5Y1CZCaOToweoZpeWY1Uwh7+prWYqMtTnt9QyBXrRLfgSYyhdVcC50YFQy2tt0NLXUC0IE4OmJZou4g7uLUrMXpdm++p5Ilde7QPdkLiWuoqo42EE55Hpiwthr1DSb0swsreU1T57tzMVKkWZ1dBuYJgSDogNi/xNyNedVC43H2PLDBWGd3niIuINCbSWrKXjeaiD9fUJ1ickKCQNjDc2fHbNDoiCHcw+xAiPtkYwt8xo/4njihgjRgbXMC5uVqNF+SCA1z8mOQWkMQb9Em84LTEwWShkJ2IDA8EccFfuFeCvvbK3AbvBSKnDArDDf1dC6tDkBKcAmUd7OLudqMwVfkjGve0WStLVKM86ZB07nbJ2+6PJ/U7XGELxDZmsDzoHbBlBDlFW02/ockm5XvXSiZp5/bsybjNaaYPrXUhGRUuW9NoJp9EEynlI1Co1uYhIv9z9hM8If6vTYPKrP+PMbT
 BuNvgrWV
 JiPTSIoOac1Xo1JE1Rgr6rPsy6AEeMWknQDKr1r3ViI5UGA388aWjPyZqmg8K0977BmJAKlPwN68skjFz24p4IOQGL9IB2SAYx2jNeyWt1ZzOrassqAzPU4dyVHJYfpPXbxw8KbqXLsrkYOnhP4lhfOvQTDIf5qKJpR1mYmvVHXwgY3mLXhtxA+H3SF0L1qq8ZgL/KyLWXKCNfetKRALT35r8qWfbY68Z7BSb0s9zCn1P+3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clean up the code by refactoring the post-pte-clearing path of lazyfree
folio unmapping, into commit_ttu_lazyfree_folio().

No functional change is intended.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 93 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 54 insertions(+), 39 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1fa020edd954a..a61978141ee3f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1966,6 +1966,57 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+static inline int commit_ttu_lazyfree_folio(struct vm_area_struct *vma,
+		struct folio *folio, unsigned long address, pte_t *ptep,
+		pte_t pteval, long nr_pages)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int ref_count, map_count;
+
+	/*
+	 * Synchronize with gup_pte_range():
+	 * - clear PTE; barrier; read refcount
+	 * - inc refcount; barrier; read PTE
+	 */
+	smp_mb();
+
+	ref_count = folio_ref_count(folio);
+	map_count = folio_mapcount(folio);
+
+	/*
+	 * Order reads for page refcount and dirty flag
+	 * (see comments in __remove_mapping()).
+	 */
+	smp_rmb();
+
+	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+		/*
+		 * redirtied either using the page table or a previously
+		 * obtained GUP reference.
+		 */
+		set_ptes(mm, address, ptep, pteval, nr_pages);
+		folio_set_swapbacked(folio);
+		return 1;
+	}
+
+	if (ref_count != 1 + map_count) {
+		/*
+		 * Additional reference. Could be a GUP reference or any
+		 * speculative reference. GUP users must mark the folio
+		 * dirty if there was a modification. This folio cannot be
+		 * reclaimed right now either way, so act just like nothing
+		 * happened.
+		 * We'll come back here later and detect if the folio was
+		 * dirtied when the additional reference is gone.
+		 */
+		set_ptes(mm, address, ptep, pteval, nr_pages);
+		return 1;
+	}
+
+	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
+	return 0;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2227,46 +2278,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 			/* MADV_FREE page check */
 			if (!folio_test_swapbacked(folio)) {
-				int ref_count, map_count;
-
-				/*
-				 * Synchronize with gup_pte_range():
-				 * - clear PTE; barrier; read refcount
-				 * - inc refcount; barrier; read PTE
-				 */
-				smp_mb();
-
-				ref_count = folio_ref_count(folio);
-				map_count = folio_mapcount(folio);
-
-				/*
-				 * Order reads for page refcount and dirty flag
-				 * (see comments in __remove_mapping()).
-				 */
-				smp_rmb();
-
-				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
-					/*
-					 * redirtied either using the page table or a previously
-					 * obtained GUP reference.
-					 */
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					folio_set_swapbacked(folio);
+				if (commit_ttu_lazyfree_folio(vma, folio, address,
+							      pvmw.pte, pteval,
+							      nr_pages))
 					goto walk_abort;
-				} else if (ref_count != 1 + map_count) {
-					/*
-					 * Additional reference. Could be a GUP reference or any
-					 * speculative reference. GUP users must mark the folio
-					 * dirty if there was a modification. This folio cannot be
-					 * reclaimed right now either way, so act just like nothing
-					 * happened.
-					 * We'll come back here later and detect if the folio was
-					 * dirtied when the additional reference is gone.
-					 */
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					goto walk_abort;
-				}
-				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
 				goto discard;
 			}
 
-- 
2.34.1


