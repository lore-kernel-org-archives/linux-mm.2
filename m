Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4B1E99076
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F006B0092; Fri, 10 Apr 2026 06:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F4B6B0093; Fri, 10 Apr 2026 06:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11EDD6B0095; Fri, 10 Apr 2026 06:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 01C656B0092
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:32:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D821B99F1
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:32:49 +0000 (UTC)
X-FDA: 84642282858.25.CAA5F96
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id E9DE11A000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:32:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=chmVQdNF;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=chmVQdNF;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817168; a=rsa-sha256;
	cv=none;
	b=puhPn5yeiKEc+Ch6J6t+UJb0eEC39R6wkgcUs4WyVw8TtaGxfzhF1ySiVB/f/e9S0JG8oQ
	bl8YkDHBEuk5DrIdw+E7MfyEpabX7kqTH8ivv3sUF/1D7H1RweA8NOJBDFQ0xNhGqbORgJ
	aIGpeioFaw1TfOxMijYkm1eBUJZ+990=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqdhqUkUnKS4gV7PxlGeeVJLVgaKEdcSEKasWKiDQIo=;
	b=ktfeX85I0vKESow9nE8hk6pfAZdYdCa4cFEq+VRo2fnpyJpN0yWrXdB1syOcAiYS+G9jbB
	KcKjRcJkjHtsd4qhrFDAmL/G7jClR7ibbPia0FllsjjoOuVdepVi5RYAyAA4I6DZ+Jtubv
	iodTy/QeXVKr1qKT+1g1ByiCNkhetD0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EA5F2681;
	Fri, 10 Apr 2026 03:32:41 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D22F33FAF5;
	Fri, 10 Apr 2026 03:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775817167; bh=X7DlvXowYL6w+6n3AW64YW79PXkvSOgsC12lJIyy+DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chmVQdNFRnxFZW1c2PeiQ45e2n4251vCjuRZc+/Ml+7/MHJC7bt7lwbm7ixvDeX+C
	 0gfeMHhQQxxQnRTUjY3X6UgbYTRXDReYyHWTuq1h9hyGe4I4EgCriYLjWt5vcyDVcq
	 RJ5e1f2yFbEjw2vL/ZLDYEMQLNaWmCAoSBeZklIM=
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
Subject: [PATCH v2 3/9] mm/rmap: refactor some code around lazyfree folio unmapping
Date: Fri, 10 Apr 2026 16:01:58 +0530
Message-Id: <20260410103204.120409-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260410103204.120409-1-dev.jain@arm.com>
References: <20260410103204.120409-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E9DE11A000A
X-Stat-Signature: yh5mrmbem3q3a9napdc75z5c98g5chpz
X-Rspam-User: 
X-HE-Tag: 1775817167-172084
X-HE-Meta: U2FsdGVkX1/ssavFlOox+4jpgee6lQNvh02OY+u4g96wa4pLEUyPAt2Ta8Ig69y3LVAS/2sa3xGJCvslVf7hCV0y4x8fA2qxpJ8qtjsLFxTDSfFVOORgDJoYduuWN1mFVTYNxuH8o+6FAozox17lQFiCXQpOArBhzK0nyIquVvds0xv4hNIUr+WVQby+fTg0Z8ijeey8ytA/yXt1faC/Qrb0+qED4WCX3OHRIgLfqr346+inmv7031EkWvwanr7nGRMqvJPnQFXqbATSZAEpxn9hBKLrx9EmxLpMHT/4OioA4WeEJUxw6lo3s5frvtPlQq3YBQD+CQ/GTEYpFKm3ArlUT+p6j4ZaTg5ncOgUsYC6uZvVm98GoMqnQo8tMEtBGeeDLgeToBBLGBnVTuBLZgr+n1TNzGFiroFidHj5ODvUxarDHiaOq0nzEltlEXCNU8K5m7BRcp1EwQ5sMQ4KtrQsWtinFY2OmOcxQyIjjO3eia54Fcq/oT6qh5zV9D6idnRvos8JKtNgTrQ6yQ91SMmwH5/HPaf5QiDmrUALGwD86tl6mef9Ip7zt+G840+92+X+vLFNSd9jY/LIc2PCvIP4Qssji+Ymp7uv4WCfdVV1BW5jLtS5DdYfj7xBzRJ5/Ylk83lSlHYlGECC6qz6SxdYOZlJZ80HzI+Ua708+qxIQxIaeF77jmW233oBS6rfu9/vrnk1nutPjJn2vTrqUJs/9ECPAgr4Po/A0yaar1z96s4ZV8b4qjCBPahnaC/SOruLcmZMz/ar00aZW/U4bSykRNdhy7a+R1rk/gI4Ri4B01TfPeDWFr30BeBjiwAdrT56cmG+zZMl39fSd3EZujQ2QM9rGIhPMYShY/wH9z9sl5MN0+SJ7BxaQQqwitmyNh5yuzyLqmH7hnrxV23m85fue//E3UjL5M30osPb0ISv5EwKOixSKPaukKhXo176p6TK6DL04dbAPLuosIz
 jO4YBqYp
 f3N28j31Ul33qFkEGd0g4kEwZoiiJUpQok1THCcPIqvxH61VEDT8yNCJUJtsyI6Wuio8dqYP8v+9veY8cOKVZF+6D8nnqBHNt5xOpFqTk+vrmBR7PjZihUu5c0IwtnPoN04UMqabNW1fJTHIzb4cGz3Q4JYfEYrc1M69dDFRchuQ6WBLAWuay+7zt52dgNE3eOzSnNNXXbQIKGSXFeHELq+XOiksiZ31P/kKLXMSudn19GmfNy4KBqDt+GDz3xoxqWdgJh3ygOdMpYekEFrmRhCTyqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For lazyfree folio unmapping, after clearing the ptes we must abort the
operation if the folio got dirtied or it has unexpected references.

Refactor this logic into a function which will return whether we need
to abort or not.

If we abort, we restore the ptes and bail out of try_to_unmap_one.
Otherwise adjust the rss stats of the mm and jump to a label.

Also rename that label from "discard" to "finish_unmap"; the former
is appropriate in the lazyfree context, but the code following the label
is executed for other successful unmap code paths too, so 'discard' does
not sound correct for them.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 95 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 40 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index a9c43e2f6e695..fa5d6599dedf0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1978,6 +1978,56 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+static inline bool can_unmap_lazyfree_folio_range(struct vm_area_struct *vma,
+		struct folio *folio, unsigned long address, pte_t *ptep,
+		pte_t pteval, unsigned long nr_pages)
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
+		return false;
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
+		return false;
+	}
+
+	return true;
+}
+
 static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,
 		struct folio *folio, struct page_vma_mapped_walk *pvmw,
 		struct page *page, enum ttu_flags flags, pte_t *pteval,
@@ -2256,47 +2306,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
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
+				if (!can_unmap_lazyfree_folio_range(vma, folio, address,
+				    pvmw.pte, pteval, nr_pages))
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
+
 				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
-				goto discard;
+				goto finish_unmap;
 			}
 
 			if (folio_dup_swap(folio, subpage) < 0) {
@@ -2359,7 +2374,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
-discard:
+finish_unmap:
 		if (unlikely(folio_test_hugetlb(folio))) {
 			hugetlb_remove_rmap(folio);
 		} else {
-- 
2.34.1


