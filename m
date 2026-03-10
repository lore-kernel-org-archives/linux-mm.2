Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2753FCC9D1
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D4B6B0098; Tue, 10 Mar 2026 03:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7BC6B0099; Tue, 10 Mar 2026 03:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC9C6B009B; Tue, 10 Mar 2026 03:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BEA26B0098
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:31:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2DDA58F70
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:35 +0000 (UTC)
X-FDA: 84529333350.03.1B287ED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 218541A000B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773127894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lHJjAEdT/n93ANJLiM9nOWfZtUvuSgcq16dxWjv/hY4=;
	b=GIoL7oFIHhfMXwWqWj6WtMgTT5rOCXRe49SxzFaRj5PRePAAEHdWU836B7POptku1g+2Lz
	HUoSWzCBtZPP8pyNo4DjlVgzPs6eoo+2O+2yCqvOnz5tqXqDr9Q806wzHwtT4Xjt45InDg
	MKOrZ12XQ/1H1BfSJVeCG+ib5qNo0g8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773127894; a=rsa-sha256;
	cv=none;
	b=AYXHu8aMduSaM043LKg6/e2DaJZysjgGZeHEA5IHiYpO5VyOu/rcAAX+Q/lF62hRjyUEAH
	vsjVKQIrvVXPcyPgTJUFWR6Wbs2mdZ/W+TgsUq7sZWFCgJ9g6rbgFMfHXYJycZoDfzNCGG
	XSR+q+xoGLl9uZ1v0mnggUevFHBCAc8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B2CF1756;
	Tue, 10 Mar 2026 00:31:27 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6151A3F73B;
	Tue, 10 Mar 2026 00:31:24 -0700 (PDT)
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
Subject: [PATCH 5/9] mm/rmap: batch unmap folios belonging to uffd-wp VMAs
Date: Tue, 10 Mar 2026 13:00:09 +0530
Message-Id: <20260310073013.4069309-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310073013.4069309-1-dev.jain@arm.com>
References: <20260310073013.4069309-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 218541A000B
X-Rspamd-Server: rspam08
X-Stat-Signature: k3a78qcfptt7dqn8t8w3ucr1azyzmpgd
X-HE-Tag: 1773127893-527291
X-HE-Meta: U2FsdGVkX19RAA86zQql8FD1KLBbvD5FiRcAOQC7DXC8CU+sHDiCMewlLN7/1ZFJLVt56IRhaNyZ8o4dHbGWWsS3vG3In999lQhlNnNBb8ebVBS9imgC0jSqiV1xj61QPVoD/SokV4DKnSLP+xwBlmU4MTMX9KPGR9cvbtC+E5C6Sw97lYiNv+LMAjrTMUuok+A4FWMMPl5ozoK6gY94tNnOayqjjqmA7QrzhL4vIXUSUljXSx1t78paAZJDyVu+vjfHgBtVUvknmwQ8iI8Y0+fjM6QGRMTvkx1J2l2C6zwB+uwIvXqSwiA2Pl5xrsDiOBbT+cC0gjlJEV7pDEiw/lVtEPudN8hevTWfJqk8jIvNv8mwkgwoovXxw97ahJ7TW/mwWCX5c3Uw4qwJ7b4KOd9QeX3B+46b7yz3F0jhcgHZ9egUah7M8diQAqhjcVfR1oBjjoTdOoRQDEMs9+m4WTzNMbwTj5keXOLINAyBR5SIoBgjjk3DvTMg33jbvjP8wzQK7Zp+6uHG266FZ85XhLMLsbx7/GFzotaYVv6yqBUzo/JdtKoMZv+3cgGEGd0JBYk1trw/HWPfgyj8u2d9bVuKDzT/uJbiymJVqUWcBBRL5bKA15uz3RxcBE6eVikydDEXmpm26HliLoUEo9wnZ7nf8qU0JjmViqm6+rn1SKC3a4flltWAlKeqUXitG1hSMR0Z8G0GHx2LqAPCDgRmav3flsCt5q0AbN6pKjfC+PI/Vrb+W+O3MQt8mxm3VHgqcXHn5Xw77r1KY7JIprPhJFOzyu++Vu5w/AQ6Wvl+3BHhYIFDkcGQKGlp9hzCycf98PQy3/O+rLVMBzWKORiHhlKyn21Hd0cV6CgUi81uStImnhWpZ86oZb2MuVKcDIp2UvgmEmsnbLnK3CD96/a31pHYc215fCD6d0zAfJjVuN5/xc63LYIuR7G2tWBoJqOdkk+OZLYhDFkM4PAn7eH
 lUHXvLIR
 hytnJDI6nS1xRD99+DmmqRbFE81foz76SvNetWutK8QGmln4+UAwkEkuFYt2cBZu6xNrq4etaazU5B7Zxd/E7FLVTp7CPZblPj/PylrPiBItNM40X40nlKRufYxKQnlNyg5btBQw3mPoUJPaR+ToW/VahZRNmby8f1de8fSQam8eu5w+cCYtIC9iFQMzqrTcKGLO0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ptes are all the same w.r.t belonging to the same type of VMA, and
being marked with uffd-wp or all being not marked. Therefore we can batch
set uffd-wp markers through install_uffd_wp_ptes_if_needed, and enable
batched unmapping of folios belonging to uffd-wp VMAs by dropping that
condition from folio_unmap_pte_batch.

It may happen that we don't batch over the entire folio in one go, in which
case, we must skip over the current batch. Add a helper to do that -
page_vma_mapped_walk_jump() will increment the relevant fields of pvmw
by nr pages.

I think that we can get away with just incrementing pvmw->pte
and pvmw->address, since looking at the code in page_vma_mapped.c,
pvmw->pfn and pvmw->nr_pages are used in conjunction, and pvmw->pgoff
and pvmw->nr_pages (in vma_address_end()) are used in conjunction,
cancelling out the increment and decrement in the respective fields. But
let us not rely on the pvmw implementation and keep this simple.

Export this function to rmap.h to enable future reuse.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/rmap.h | 10 ++++++++++
 mm/rmap.c            |  8 +++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f001..1b7720c66ac87 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -892,6 +892,16 @@ static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
 		spin_unlock(pvmw->ptl);
 }
 
+static inline void page_vma_mapped_walk_jump(struct page_vma_mapped_walk *pvmw,
+		unsigned int nr)
+{
+	pvmw->pfn += nr;
+	pvmw->nr_pages -= nr;
+	pvmw->pgoff += nr;
+	pvmw->pte += nr;
+	pvmw->address += nr * PAGE_SIZE;
+}
+
 /**
  * page_vma_mapped_walk_restart - Restart the page table walk.
  * @pvmw: Pointer to struct page_vma_mapped_walk.
diff --git a/mm/rmap.c b/mm/rmap.c
index a7570cd037344..dd638429c963e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1953,9 +1953,6 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	if (pte_unused(pte))
 		return 1;
 
-	if (userfaultfd_wp(vma))
-		return 1;
-
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
 	 * upgrading write permissions for ptes that were not originally
@@ -2235,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
+		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, nr_pages);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
@@ -2359,8 +2356,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * If we are sure that we batched the entire folio and cleared
 		 * all PTEs, we can just optimize and stop right here.
 		 */
-		if (nr_pages == folio_nr_pages(folio))
+		if (likely(nr_pages == folio_nr_pages(folio)))
 			goto walk_done;
+		page_vma_mapped_walk_jump(&pvmw, nr_pages - 1);
 		continue;
 walk_abort:
 		ret = false;
-- 
2.34.1


