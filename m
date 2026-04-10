Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CD07E9907D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95DB76B009B; Fri, 10 Apr 2026 06:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E7B6B009D; Fri, 10 Apr 2026 06:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED8A6B009E; Fri, 10 Apr 2026 06:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AEEC6B009B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:33:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34A3AC1CF6
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:33:33 +0000 (UTC)
X-FDA: 84642284706.10.F9CCE9A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 832DD40013
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:33:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B8Zxi1oo;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxIWKvE7iIhDWFTbVq51kkvy55OBODeC9Ae4CjC3w1k=;
	b=nAyERYls/p/4RZzIlHZhf3cd+M3Z6764AhnTN10yzud+5BT6kJpa/WGX22NOfmLGWqkbM2
	G/Cc81jSQJJJabzjPoL6oMFXB0jUY27Bd+SIPMuuIPRS5Hc7LLiCugfK/Bw4qGZFoRvWDg
	/hHmyktn+GOsNCfDB0/uThHm/H3EnHM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B8Zxi1oo;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817211; a=rsa-sha256;
	cv=none;
	b=rF8gIBQBBvCyy88aiaYBGaPfRYF3SlK+mTACbwvFmSAuNsot3YI6Vi4AHkLA6YpecrJFHn
	EiPoJzlMjidQZYix+Of3LuA5DaylbW2pEctvfQyR/BaRZ/3OlQ3Cew+DaPpID+1Y5P/Z3f
	e/UU133hfD/UC/kSd60R1ZBTmpyrtkg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B6944529;
	Fri, 10 Apr 2026 03:33:25 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8A01F3FAF5;
	Fri, 10 Apr 2026 03:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775817210; bh=tF3VW2lbJuABvGu5WBZjmvW3rTKVGcTyExhhZXtmOk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8Zxi1oowJQksrIiPBubX8jrt3yniQITzN3UZ8rLvHMLHv/Ien8ryoISTvpCoiy6I
	 qWpA8/CW72pBeVLfZYBV9iNeewvz+tzYciTIn+MDm3gV85bUmGJExuFSPQIKV6ow5V
	 7Q80cSOMa3itWQ//epcQbaltosKJVSg8wXCNYYK4=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 8/9] mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
Date: Fri, 10 Apr 2026 16:02:03 +0530
Message-Id: <20260410103204.120409-9-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260410103204.120409-1-dev.jain@arm.com>
References: <20260410103204.120409-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 832DD40013
X-Stat-Signature: 1dtiao7dhui8k5gm96u1hhyx67qpemw9
X-Rspamd-Server: rspam06
X-HE-Tag: 1775817211-224553
X-HE-Meta: U2FsdGVkX1+DArfekCLzvcdHDmnJ0+TbrX5DqRaLzPppCXSQQUJV+anksYyfSRI8mP71kfvuGuNrh/Zk8sdDdQKkrg2qJs7Hfu880aY7OWkXp6gF2jPvMW1Go0UZ0XODUezGKhH2j6Hmh0n7erxq1i/DaDnZGQGjxHt4gWibsW2Cb1yWq91zgcQwWW0MxHKmFBClIBUqCtm8kPmEp/CJSJ5HKvxcdJT5uwiIe0JeES6BsKa7xFAoW4BNWtLerD8otZW4GIV0NXVd5Hd47DZ0248ut8VBGRQH+a2SabpXzeqMshSb9f33Q9LIOG8JGtPFo1aZASzjaNO7P/oOFaSlgsDk76KwIgKTaV5j2LmDmDH5sV+mt2+yuPUSRXJBRrpZP/8XM5Y6nsq719CW1n9AowAJtIvHD2ZRurDJA7mx8n+8XM3OPrqgGze/4UBekJY11MwgrnBvH+cLUG9tUApk+tVJYuFNiDDYM24ydBcVNdMO6W44cqcdEKOxk6RwZtj7CKC2idVDXDeqOH0LhtJE4L64o6Vwk8aLCGdqEmRBupTK8Z1UT3NE4tBGDKsFOigU3mNw49Lo6aeeHEpSbqt/w1gnbmlNetWgspLZxaY2ZQFYci5B+T0ZfL/cgse1Q92CgZSSAbPQhaLFRJdMFn7X7HgNvZ0BpaUc74lx06c7bTN+zpM852ES+uiq4rDLdkKklT7f/J8+p6gU5lDV07J922Q7QdBQ5J6iCxjAyq1IuieKsD4vAuzzRE2UnlciI9deGu6+JMaCHEHgikrGxcYfZ7uJIyiMyUbZuLP+gueCIR4WSM/VZ0uV7UgUydvJYoVPeWVSMwoGR7PVmsGWs/XXoXDLSkk7WmnXwiGmyHG2Bb3BduA5jgHDOrxg5RzkYxGYFPDLykUMN7FDDVpAlLp18IWkRe9Rw2WjyTfZ320u+KdEin5L/tD0poHFuUzmU34U+W1vNSLZOZ21ZGChFpx
 Yx8w4NVm
 XjqWryHAuVVv/qdgsFetDT7lhFBa0C6P3rs3rEn5Q1H3XoPvPODeEte3dFEHOrdwCPi8P5I+y5dMxaeWmlrpnPBFNH66ipcIozJWUb/1QRmEvdL41ePaiktnx1qQhYUGuMv3ppf1bf/2EEDQJuOoFxHCOnG1j828Gcdmk1i259g+/O0qgYeQKNZY8SqvDDeanz2dA4A44eMfsWe+McXNlaSzogV4onacXbhA/PiPFjfYK8Bh2y6Vok8/L+iDt9bFD+nft9K6/oKClHqAkJqXo3qtAN8XQxdVa7ozy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To enabe batched unmapping of anonymous folios, we need to handle the
sharing of exclusive pages. Hence, a batched version of
folio_try_share_anon_rmap_pte is required.

Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
to do some rmap sanity checks. Add helpers to set and clear the
PageAnonExclusive bit on a batch of nr_pages. Note that
__folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR from the
PMD path, but currently we only clear the bit on the head page. Retain
this behaviour by setting nr_pages = 1 in case the caller is
folio_try_share_anon_rmap_pmd.

While at it, convert nr_pages to unsigned long to future-proof from
overflow in case P4D-huge mappings etc get supported down the road.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/mm.h   | 11 +++++++++++
 include/linux/rmap.h | 27 ++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 633bbf9a184a6..2d20954da652a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -243,6 +243,17 @@ static inline unsigned long folio_page_idx(const struct folio *folio,
 	return page - &folio->page;
 }
 
+static __always_inline void folio_clear_pages_anon_exclusive(struct page *page,
+		unsigned long nr_pages)
+{
+	for (;;) {
+		ClearPageAnonExclusive(page);
+		if (--nr_pages == 0)
+			break;
+		++page;
+	}
+}
+
 static inline struct folio *lru_to_folio(struct list_head *head)
 {
 	return list_entry((head)->prev, struct folio, lru);
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f001..f3b3ee3955afc 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -706,15 +706,19 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
 }
 
 static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum pgtable_level level)
+		struct page *page, unsigned long nr_pages, enum pgtable_level level)
 {
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
+	/* We only clear anon-exclusive from head page of PMD folio */
+	if (level == PGTABLE_LEVEL_PMD)
+		nr_pages = 1;
+
 	/* device private folios cannot get pinned via GUP. */
 	if (unlikely(folio_is_device_private(folio))) {
-		ClearPageAnonExclusive(page);
+		folio_clear_pages_anon_exclusive(page, nr_pages);
 		return 0;
 	}
 
@@ -766,7 +770,7 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 
 	if (unlikely(folio_maybe_dma_pinned(folio)))
 		return -EBUSY;
-	ClearPageAnonExclusive(page);
+	folio_clear_pages_anon_exclusive(page, nr_pages);
 
 	/*
 	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
@@ -778,11 +782,12 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 }
 
 /**
- * folio_try_share_anon_rmap_pte - try marking an exclusive anonymous page
- *				   mapped by a PTE possibly shared to prepare
+ * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
+ *				   mapped by PTEs possibly shared to prepare
  *				   for KSM or temporary unmapping
  * @folio:	The folio to share a mapping of
- * @page:	The mapped exclusive page
+ * @page:	The first mapped exclusive page of the batch in the folio
+ * @nr_pages:	The number of pages to share in the folio (batch size)
  *
  * The caller needs to hold the page table lock and has to have the page table
  * entries cleared/invalidated.
@@ -797,11 +802,19 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
  *
  * Returns 0 if marking the mapped page possibly shared succeeded. Returns
  * -EBUSY otherwise.
+ *
+ * The caller needs to hold the page table lock.
  */
+static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
+		struct page *page, unsigned long nr_pages)
+{
+	return __folio_try_share_anon_rmap(folio, page, nr_pages, PGTABLE_LEVEL_PTE);
+}
+
 static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
 		struct page *page)
 {
-	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
+	return folio_try_share_anon_rmap_ptes(folio, page, 1);
 }
 
 /**
-- 
2.34.1


