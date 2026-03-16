Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE153EFCBBD
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555CF6B00B7; Mon, 16 Mar 2026 02:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515506B00B8; Mon, 16 Mar 2026 02:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26FB26B00B9; Mon, 16 Mar 2026 02:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1384A6B00B7
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:24:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C464B8CDF0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:45 +0000 (UTC)
X-FDA: 84550937730.12.20ABE30
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 964D4180004
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iw6U4LD7;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGACvuFJ5UYqfqr90BbtcdzNeAM6aEtmTBdaV9q4LRE=;
	b=fa7Q3+8JpTlbCzRgXieHZlK9OAktGHd+fluleFkiEvgeM/3Em+VkSCEE4e0+/KpzdQcy2M
	qlv/jexNt6k33uJxhS2qB1Xk1eITGXpTUtAjJY01hEZTd1rfmd9KhpusTyMqGFCDc+aQ+o
	jFOS+qf52k4OFcuil66ndvUL13JuU00=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iw6U4LD7;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642283; a=rsa-sha256;
	cv=none;
	b=ohy2Kp7UiMcS9umbgjTPLtWSH3AGjDOVS1ZmPs1HtfkoIHlBFyeRKbjjTxbEBOcyIBxoaU
	JqbWqrVEuWZzLIqs8DFgViBUmwZWKT/yLi0p0ue3Pl63I38OaofJZ+J5Y15O0PUBeK+7BH
	MmeX8MiR9U4yR9YDJbhjzUP0KnAIUoM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773642283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MGACvuFJ5UYqfqr90BbtcdzNeAM6aEtmTBdaV9q4LRE=;
	b=iw6U4LD7rIhXL2ZpqX5GLxJc6FE47rTd1NuLYCLVC59EACS3D+7Tt0amlke8V4d8e+6dlc
	MJBbj8nzlWDDP5mxE1icUpPpxytz8dDNjPnv2Gsm8Hq9vMKdAZkxjOkITL+5wNDL9Gqmx8
	e5iDiKB184vdLHIiwMAak9KAEXYdaW8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-UQCksFw3Mmqc7S0YcrXhmg-1; Mon, 16 Mar 2026 02:24:42 -0400
X-MC-Unique: UQCksFw3Mmqc7S0YcrXhmg-1
X-Mimecast-MFC-AGG-ID: UQCksFw3Mmqc7S0YcrXhmg_1773642280
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a143980c7aso2031801e87.3
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773642280; x=1774247080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MGACvuFJ5UYqfqr90BbtcdzNeAM6aEtmTBdaV9q4LRE=;
        b=bDEkLL0RPBc977B4ooAEgn0KBHdySbLBbehX50szKQYj3ZvL0BPUKLTethiCBIKzy4
         9yLp6SWjgDncTPdI7L/FVTphKm3MdTmKpZK5tdKT8uFsg+npOXIM7b6wTtDFhNASaTwd
         0tUUVWtnaObOk5wzhAK+SfkpWz0d7lyKpl8dbsCLtuLCKkHRU5FeLg9IQD6ORvn/vxcB
         WipE0AuKX4p0ryoL64S68eXBXOhWfPfnxIP1EJx7pk/2terYZjXSMgdIVccU4PDg6fkA
         H8VYRpT7x87ylVah5tG7Yc4AiUKpm8BIsuyZ8ZLN90s65X2wjhzEmbehGgeAiBzbkvri
         i0cg==
X-Gm-Message-State: AOJu0YzuoVOtHnjWgUJZCduQ8A+k5xINsxk7iUxv3oFujFVVDJzbH0Ob
	KSpfMMR+bxmc2xa5C1FrXUj0ClXKI7/a/tyGJcwlBOi6EfDfl2ggK8PkWUxlrSOmx72h69QF6H6
	ePwCgZATpvn+x8HoirQdRbTiLrZJEbCChyLGTY+sDW18d2wnDWEAECKvJag1sisoFkBZV7HD1GP
	h5wQIEoXItKFQ/1N204dmlIDOfu6DGQSzt0RzwJw==
X-Gm-Gg: ATEYQzwXSd8YiDgNSH2XPjATVWmtumD9oAKXgPnmIkA7e0IHep4qWlMFVV1LumNZUhk
	vuW2CxZm1jDYYwJoIuVQf6CU3cyL21cbFEZt5/gZADKEkzPb3E5PSOZ7Ao1ehfGlfSQxLSZozT1
	lR2OtjubjJu74Xv3Knh1FJk417qNl/55ieIzE182znqOZ3OFLrBSHDSnYY7mOLujUQ4cj+eLyvY
	28SiE8zwYqvSXzc4k/vf1JWWqBM1o1p3a9qhw+3kXFBOJCDaFxGTzCEscmDPBUFrUpq3yboUwWn
	9YcYPOUc96tuI02CNpIYbj7ay3WELV2IKawSHjjXizMdE3b4zup70BcqNwgccJgD9otyU0qDt5k
	XPh+0uxPLXO60+4qxFHElNuQqrpjvDezPwv4S
X-Received: by 2002:ac2:5602:0:b0:59e:65ff:e57e with SMTP id 2adb3069b0e04-5a162af6686mr3259823e87.12.1773642279960;
        Sun, 15 Mar 2026 23:24:39 -0700 (PDT)
X-Received: by 2002:ac2:5602:0:b0:59e:65ff:e57e with SMTP id 2adb3069b0e04-5a162af6686mr3259805e87.12.1773642279344;
        Sun, 15 Mar 2026 23:24:39 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15602e692sm3263397e87.30.2026.03.15.23.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 23:24:39 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH v6 6/6] mm:/migrate_device.c: remove migrate_vma_collect_*()
Date: Mon, 16 Mar 2026 08:24:07 +0200
Message-ID: <20260316062407.3354636-7-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260316062407.3354636-1-mpenttil@redhat.com>
References: <20260316062407.3354636-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T43ouQfqbVcAUt1x9mib36ZGWz72ItdV52cYuTkPxZM_1773642280
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 964D4180004
X-Stat-Signature: fz4xkzawsrdkkx5mri8n5w8yckt5yno9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773642283-424452
X-HE-Meta: U2FsdGVkX1/BXE2lkiLDDaLSxu1FrrSIj9KZu6iUZzX17W/1W5/VB/12MnQB2Iqf7otZxD0OoW53HgKJf10PUCJPad23XEHeQ1xMmZdiDz0hYhjIrCKIrztSkHn+/mxGe+xv+Y0cC7pidcq7m/c4CUm368VrR50aWAJ0Va6vwsV4r/JYa8l4cxdpMJ4lw1y/rhwji/SHtN/jzvtl8iAg8GmqJj+x2BtTKgV1FhEewewxVqq5fIBl8ev574y47vtk8foHWSZz8lNYO0hPbwniXTiSPtfrEEwt7USGnZ1r9/L8xj+ZCUfE1ItPQ383rZS7TUyIc0n8IWPu4dkY1FHvBlsrIYh4JL4IDaCE/4d9ZMKkswfq+w5Zo1u3gKjXHTvotVG8v/cbuwuoZLdksIndPRMbSQPAQPa4P58q3urR/qOquUWyCyyE1dI0cD2LZB0TLKSzijwpLwQpH0qy/SsNkCC2oF9MUjZDV5DlbLRGfSQG8pMRt9Qj1ZuVIQH/0ZflwFQcXUVGboeigc2ALH1YEZENnCH8tVXObXwX2NI/Q0gJyzzw+LIFBKnU8vGIsrj1XpNknhcjicMPGVLSDQsyZAedOFoEotHvfKIFQpTmykF7uJokNn4CbPRsTwpT4pUtE/4nd7XbLi0CI7DP26jr1bRMJ155PcnHj1FE7ajLHthbxqTarKHsIWO2IqqxVcr5Osi6a4pKM9eowddT56L23PCjT1yPDEQQJxgCmHHVEeDvhgVE0QhCTCcAvTYOdjVVlBIEKIhshZgpfbC02+YXTycv1hQ7qnrP2Bip6LbTflzT8isaQHm2toNxwbXX53y95uW42+nScIBJNrMjU+PwG0dsqfYxwLUh+mlSz6fibrX474AV8UKqCTTtvNN4cWuDDP/hKZFrzrtmZAabXUXDtgLXsci8whwYaUmVQ53AQPmQbu+/TwyFRQR/RZUPQIeto80bmd+o7+KeeNANqEQ
 CYLUjPnl
 11GjjCvj/P8Gg3ilW1eOoVBOmF/ceNgdqKokmpMZTI+04WlJan3Q+fUS6ev0qtyEj2ycaLUdRWEH5UnyaULvd4Hf1EX6duAUTZsSyn2QncLMFxy+K6uWMwCLNw7d8l0t5vDQZgnity+MnoljccFmuQdRX2owtmI3oHWzwJWiJk8d8FI01UcPxJkNtDhyVUnB6Pq0sMr04Kjk8yA9kv4mJYeSirsfrUSYmatk0rYx4N0FaS/0qhlg+KXBrdPV2Hsv5+VmMS5w4/XG87UP+S9PZTEfn30ZmCxMRv7fYqpL9xsBICaFnvguLfr+o+PVGblVjdrcPTSGGxX2HO94UeQVDkDd+LF9WG7gLD8/yvxjhfda/Wu2VrixC6BVuz0Tky+BVWs4t3KXaQqUlAyAryzQRKzItrM0WVsUajheVVI1JS31PX/e8f0Vt/03GyNHJhEkNoUgaKsMG+TTansz3zfTef6GREg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

With the unified fault handling and migrate path,
the migrate_vma_collect_*() functions are unused,
let's remove them.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 mm/migrate_device.c | 508 --------------------------------------------
 1 file changed, 508 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index cef9b644d31f..c9f23e6c519b 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -18,514 +18,6 @@
 #include <asm/tlbflush.h>
 #include "internal.h"
 
-static int migrate_vma_collect_skip(unsigned long start,
-				    unsigned long end,
-				    struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	unsigned long addr;
-
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->dst[migrate->npages] = 0;
-		migrate->src[migrate->npages++] = 0;
-	}
-
-	return 0;
-}
-
-static int migrate_vma_collect_hole(unsigned long start,
-				    unsigned long end,
-				    __always_unused int depth,
-				    struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	unsigned long addr;
-
-	/* Only allow populating anonymous memory. */
-	if (!vma_is_anonymous(walk->vma))
-		return migrate_vma_collect_skip(start, end, walk);
-
-	if (thp_migration_supported() &&
-		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
-		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
-		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
-		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
-						MIGRATE_PFN_COMPOUND;
-		migrate->dst[migrate->npages] = 0;
-		migrate->npages++;
-		migrate->cpages++;
-
-		/*
-		 * Collect the remaining entries as holes, in case we
-		 * need to split later
-		 */
-		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
-	}
-
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
-		migrate->dst[migrate->npages] = 0;
-		migrate->npages++;
-		migrate->cpages++;
-	}
-
-	return 0;
-}
-
-/**
- * migrate_vma_split_folio() - Helper function to split a THP folio
- * @folio: the folio to split
- * @fault_page: struct page associated with the fault if any
- *
- * Returns 0 on success
- */
-static int migrate_vma_split_folio(struct folio *folio,
-				   struct page *fault_page)
-{
-	int ret;
-	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
-	struct folio *new_fault_folio = NULL;
-
-	if (folio != fault_folio) {
-		folio_get(folio);
-		folio_lock(folio);
-	}
-
-	ret = split_folio(folio);
-	if (ret) {
-		if (folio != fault_folio) {
-			folio_unlock(folio);
-			folio_put(folio);
-		}
-		return ret;
-	}
-
-	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
-
-	/*
-	 * Ensure the lock is held on the correct
-	 * folio after the split
-	 */
-	if (!new_fault_folio) {
-		folio_unlock(folio);
-		folio_put(folio);
-	} else if (folio != new_fault_folio) {
-		if (new_fault_folio != fault_folio) {
-			folio_get(new_fault_folio);
-			folio_lock(new_fault_folio);
-		}
-		folio_unlock(folio);
-		folio_put(folio);
-	}
-
-	return 0;
-}
-
-/** migrate_vma_collect_huge_pmd - collect THP pages without splitting the
- * folio for device private pages.
- * @pmdp: pointer to pmd entry
- * @start: start address of the range for migration
- * @end: end address of the range for migration
- * @walk: mm_walk callback structure
- * @fault_folio: folio associated with the fault if any
- *
- * Collect the huge pmd entry at @pmdp for migration and set the
- * MIGRATE_PFN_COMPOUND flag in the migrate src entry to indicate that
- * migration will occur at HPAGE_PMD granularity
- */
-static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
-					unsigned long end, struct mm_walk *walk,
-					struct folio *fault_folio)
-{
-	struct mm_struct *mm = walk->mm;
-	struct folio *folio;
-	struct migrate_vma *migrate = walk->private;
-	spinlock_t *ptl;
-	int ret;
-	unsigned long write = 0;
-
-	ptl = pmd_lock(mm, pmdp);
-	if (pmd_none(*pmdp)) {
-		spin_unlock(ptl);
-		return migrate_vma_collect_hole(start, end, -1, walk);
-	}
-
-	if (pmd_trans_huge(*pmdp)) {
-		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_skip(start, end, walk);
-		}
-
-		folio = pmd_folio(*pmdp);
-		if (is_huge_zero_folio(folio)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_hole(start, end, -1, walk);
-		}
-		if (pmd_write(*pmdp))
-			write = MIGRATE_PFN_WRITE;
-	} else if (!pmd_present(*pmdp)) {
-		const softleaf_t entry = softleaf_from_pmd(*pmdp);
-
-		folio = softleaf_to_folio(entry);
-
-		if (!softleaf_is_device_private(entry) ||
-			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			(folio->pgmap->owner != migrate->pgmap_owner)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_skip(start, end, walk);
-		}
-
-		if (softleaf_is_migration(entry)) {
-			softleaf_entry_wait_on_locked(entry, ptl);
-			spin_unlock(ptl);
-			return -EAGAIN;
-		}
-
-		if (softleaf_is_device_private_write(entry))
-			write = MIGRATE_PFN_WRITE;
-	} else {
-		spin_unlock(ptl);
-		return -EAGAIN;
-	}
-
-	folio_get(folio);
-	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
-		spin_unlock(ptl);
-		folio_put(folio);
-		return migrate_vma_collect_skip(start, end, walk);
-	}
-
-	if (thp_migration_supported() &&
-		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
-		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
-		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
-
-		struct page_vma_mapped_walk pvmw = {
-			.ptl = ptl,
-			.address = start,
-			.pmd = pmdp,
-			.vma = walk->vma,
-		};
-
-		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
-
-		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
-						| MIGRATE_PFN_MIGRATE
-						| MIGRATE_PFN_COMPOUND;
-		migrate->dst[migrate->npages++] = 0;
-		migrate->cpages++;
-		ret = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
-		if (ret) {
-			migrate->npages--;
-			migrate->cpages--;
-			migrate->src[migrate->npages] = 0;
-			migrate->dst[migrate->npages] = 0;
-			goto fallback;
-		}
-		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
-		spin_unlock(ptl);
-		return 0;
-	}
-
-fallback:
-	spin_unlock(ptl);
-	if (!folio_test_large(folio))
-		goto done;
-	ret = split_folio(folio);
-	if (fault_folio != folio)
-		folio_unlock(folio);
-	folio_put(folio);
-	if (ret)
-		return migrate_vma_collect_skip(start, end, walk);
-	if (pmd_none(pmdp_get_lockless(pmdp)))
-		return migrate_vma_collect_hole(start, end, -1, walk);
-
-done:
-	return -ENOENT;
-}
-
-static int migrate_vma_collect_pmd(pmd_t *pmdp,
-				   unsigned long start,
-				   unsigned long end,
-				   struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start, unmapped = 0;
-	spinlock_t *ptl;
-	struct folio *fault_folio = migrate->fault_page ?
-		page_folio(migrate->fault_page) : NULL;
-	pte_t *ptep;
-
-again:
-	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
-		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
-
-		if (ret == -EAGAIN)
-			goto again;
-		if (ret == 0)
-			return 0;
-	}
-
-	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
-	if (!ptep)
-		goto again;
-	lazy_mmu_mode_enable();
-	ptep += (addr - start) / PAGE_SIZE;
-
-	for (; addr < end; addr += PAGE_SIZE, ptep++) {
-		struct dev_pagemap *pgmap;
-		unsigned long mpfn = 0, pfn;
-		struct folio *folio;
-		struct page *page;
-		softleaf_t entry;
-		pte_t pte;
-
-		pte = ptep_get(ptep);
-
-		if (pte_none(pte)) {
-			if (vma_is_anonymous(vma)) {
-				mpfn = MIGRATE_PFN_MIGRATE;
-				migrate->cpages++;
-			}
-			goto next;
-		}
-
-		if (!pte_present(pte)) {
-			/*
-			 * Only care about unaddressable device page special
-			 * page table entry. Other special swap entries are not
-			 * migratable, and we ignore regular swapped page.
-			 */
-			entry = softleaf_from_pte(pte);
-			if (!softleaf_is_device_private(entry))
-				goto next;
-
-			page = softleaf_to_page(entry);
-			pgmap = page_pgmap(page);
-			if (!(migrate->flags &
-				MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			    pgmap->owner != migrate->pgmap_owner)
-				goto next;
-
-			folio = page_folio(page);
-			if (folio_test_large(folio)) {
-				int ret;
-
-				lazy_mmu_mode_disable();
-				pte_unmap_unlock(ptep, ptl);
-				ret = migrate_vma_split_folio(folio,
-							  migrate->fault_page);
-
-				if (ret) {
-					if (unmapped)
-						flush_tlb_range(walk->vma, start, end);
-
-					return migrate_vma_collect_skip(addr, end, walk);
-				}
-
-				goto again;
-			}
-
-			mpfn = migrate_pfn(page_to_pfn(page)) |
-					MIGRATE_PFN_MIGRATE;
-			if (softleaf_is_device_private_write(entry))
-				mpfn |= MIGRATE_PFN_WRITE;
-		} else {
-			pfn = pte_pfn(pte);
-			if (is_zero_pfn(pfn) &&
-			    (migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-				mpfn = MIGRATE_PFN_MIGRATE;
-				migrate->cpages++;
-				goto next;
-			}
-			page = vm_normal_page(migrate->vma, addr, pte);
-			if (page && !is_zone_device_page(page) &&
-			    !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-				goto next;
-			} else if (page && is_device_coherent_page(page)) {
-				pgmap = page_pgmap(page);
-
-				if (!(migrate->flags &
-					MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
-					pgmap->owner != migrate->pgmap_owner)
-					goto next;
-			}
-			folio = page ? page_folio(page) : NULL;
-			if (folio && folio_test_large(folio)) {
-				int ret;
-
-				lazy_mmu_mode_disable();
-				pte_unmap_unlock(ptep, ptl);
-				ret = migrate_vma_split_folio(folio,
-							  migrate->fault_page);
-
-				if (ret) {
-					if (unmapped)
-						flush_tlb_range(walk->vma, start, end);
-
-					return migrate_vma_collect_skip(addr, end, walk);
-				}
-
-				goto again;
-			}
-			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
-			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
-		}
-
-		if (!page || !page->mapping) {
-			mpfn = 0;
-			goto next;
-		}
-
-		/*
-		 * By getting a reference on the folio we pin it and that blocks
-		 * any kind of migration. Side effect is that it "freezes" the
-		 * pte.
-		 *
-		 * We drop this reference after isolating the folio from the lru
-		 * for non device folio (device folio are not on the lru and thus
-		 * can't be dropped from it).
-		 */
-		folio = page_folio(page);
-		folio_get(folio);
-
-		/*
-		 * We rely on folio_trylock() to avoid deadlock between
-		 * concurrent migrations where each is waiting on the others
-		 * folio lock. If we can't immediately lock the folio we fail this
-		 * migration as it is only best effort anyway.
-		 *
-		 * If we can lock the folio it's safe to set up a migration entry
-		 * now. In the common case where the folio is mapped once in a
-		 * single process setting up the migration entry now is an
-		 * optimisation to avoid walking the rmap later with
-		 * try_to_migrate().
-		 */
-		if (fault_folio == folio || folio_trylock(folio)) {
-			bool anon_exclusive;
-			pte_t swp_pte;
-
-			flush_cache_page(vma, addr, pte_pfn(pte));
-			anon_exclusive = folio_test_anon(folio) &&
-					  PageAnonExclusive(page);
-			if (anon_exclusive) {
-				pte = ptep_clear_flush(vma, addr, ptep);
-
-				if (folio_try_share_anon_rmap_pte(folio, page)) {
-					set_pte_at(mm, addr, ptep, pte);
-					if (fault_folio != folio)
-						folio_unlock(folio);
-					folio_put(folio);
-					mpfn = 0;
-					goto next;
-				}
-			} else {
-				pte = ptep_get_and_clear(mm, addr, ptep);
-			}
-
-			migrate->cpages++;
-
-			/* Set the dirty flag on the folio now the pte is gone. */
-			if (pte_dirty(pte))
-				folio_mark_dirty(folio);
-
-			/* Setup special migration page table entry */
-			if (mpfn & MIGRATE_PFN_WRITE)
-				entry = make_writable_migration_entry(
-							page_to_pfn(page));
-			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page));
-			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(page));
-			if (pte_present(pte)) {
-				if (pte_young(pte))
-					entry = make_migration_entry_young(entry);
-				if (pte_dirty(pte))
-					entry = make_migration_entry_dirty(entry);
-			}
-			swp_pte = swp_entry_to_pte(entry);
-			if (pte_present(pte)) {
-				if (pte_soft_dirty(pte))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd_wp(pte))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pte))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd_wp(pte))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			}
-			set_pte_at(mm, addr, ptep, swp_pte);
-
-			/*
-			 * This is like regular unmap: we remove the rmap and
-			 * drop the folio refcount. The folio won't be freed, as
-			 * we took a reference just above.
-			 */
-			folio_remove_rmap_pte(folio, page, vma);
-			folio_put(folio);
-
-			if (pte_present(pte))
-				unmapped++;
-		} else {
-			folio_put(folio);
-			mpfn = 0;
-		}
-
-next:
-		migrate->dst[migrate->npages] = 0;
-		migrate->src[migrate->npages++] = mpfn;
-	}
-
-	/* Only flush the TLB if we actually modified any entries */
-	if (unmapped)
-		flush_tlb_range(walk->vma, start, end);
-
-	lazy_mmu_mode_disable();
-	pte_unmap_unlock(ptep - 1, ptl);
-
-	return 0;
-}
-
-static const struct mm_walk_ops migrate_vma_walk_ops = {
-	.pmd_entry		= migrate_vma_collect_pmd,
-	.pte_hole		= migrate_vma_collect_hole,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
-/*
- * migrate_vma_collect() - collect pages over a range of virtual addresses
- * @migrate: migrate struct containing all migration information
- *
- * This will walk the CPU page table. For each virtual address backed by a
- * valid page, it updates the src array and takes a reference on the page, in
- * order to pin the page until we lock it and unmap it.
- */
-static void migrate_vma_collect(struct migrate_vma *migrate)
-{
-	struct mmu_notifier_range range;
-
-	/*
-	 * Note that the pgmap_owner is passed to the mmu notifier callback so
-	 * that the registered device driver can skip invalidating device
-	 * private page mappings that won't be migrated.
-	 */
-	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_MIGRATE, 0,
-		migrate->vma->vm_mm, migrate->start, migrate->end,
-		migrate->pgmap_owner);
-	mmu_notifier_invalidate_range_start(&range);
-
-	walk_page_range(migrate->vma->vm_mm, migrate->start, migrate->end,
-			&migrate_vma_walk_ops, migrate);
-
-	mmu_notifier_invalidate_range_end(&range);
-	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
-}
-
 /*
  * migrate_vma_check_page() - check if page is pinned or not
  * @page: struct page to check
-- 
2.50.0


