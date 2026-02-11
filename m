Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2125FEB5979
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 08:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01A16B0095; Wed, 11 Feb 2026 03:13:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4366B0096; Wed, 11 Feb 2026 03:13:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5446B0098; Wed, 11 Feb 2026 03:13:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 906A46B0095
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:13:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32BCB8AE4B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:48 +0000 (UTC)
X-FDA: 84431462136.13.5D43680
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0CC31180009
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cMMvvI6q;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770797626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9a7Ah8KhQUYqdzePV22BgRQqWm8tswB+g3476B/ANtM=;
	b=HJyIFLmQfGNL1YR9jwzNTXtofIhMvUenfOUivVZswsg5c67EUlbRVIYk7FAtdWy1ySYItd
	T6n9Wz1RPcYhgdxyrnLjKNPkQLiVVSEsLNQgTPfwS0xWkQ8JUzODxnzTsuO3zFIfy/0Gdw
	qkWYJtCUK6Y8makrM7skI0R1lf6nyQc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cMMvvI6q;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770797626; a=rsa-sha256;
	cv=none;
	b=TIRPCPjVVr9P0lPew8Fjbd/EjNbgd7ZP5mjNATJqclb+ySVuSXBgJfHAq9MpbNr9gHEVnV
	3fZl4NsdrZ6S7y3WeGLAN/o6My11GBffP3+I/zghLk1WPtpa+CdJ2RRVgnjAtUiECs5Btq
	U10CicmH9popQlWVrV506u14+fE7DuA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770797625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9a7Ah8KhQUYqdzePV22BgRQqWm8tswB+g3476B/ANtM=;
	b=cMMvvI6qDIxMf1EIvCyDCimy5fonnwHRkuGIAaRGU+vrXa8n2flKthfSz5gyileORfakbc
	8EqG4yUUBAkvPaK7kC8FimnilH0yfUom/pOBSOffGiRz7vOrIVte80zzSC9HKhCsgHS9tT
	cHthHRC/MW4LTfspOXk4ck4qIv+qppI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-oByFNV2vMIG7Lx8j83Qw1g-1; Wed, 11 Feb 2026 03:13:44 -0500
X-MC-Unique: oByFNV2vMIG7Lx8j83Qw1g-1
X-Mimecast-MFC-AGG-ID: oByFNV2vMIG7Lx8j83Qw1g_1770797623
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-59e53ea9a0bso893195e87.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:13:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770797622; x=1771402422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9a7Ah8KhQUYqdzePV22BgRQqWm8tswB+g3476B/ANtM=;
        b=rkgdhKcvfcGOvS5rKWt0ygi+vOEBH6extDS1SKWkH6pQ3Yhk10uXfnO7Ba89iz+6SU
         GkzR5Ba6JrBVzgU2+iRaciMd55wLvUAgmCNKri52IWelwD2goroJkgnbRrNxg9R0W1bx
         ePKDbPbfVfS/kflSL3qq705AmI+M3jaQ/dfDt/YwnfJ7H2n7hxa1sKAwATuSL6D2H+iP
         CTGE9drQNtdP4lYZldOu/pNcuJ+KVct0ZZEEuqDiA2ciNI+twGjAbicoOj/GMPCAoIg1
         2u1wycJet+htORoLYUXEqsmTvrIij/5ByW4VQFU1miy5Opy3LgPH1ymfyqqSHyNP02wf
         foOg==
X-Gm-Message-State: AOJu0YwC0eZwysOD0ax65de2s7M8gKsazXCFw3lYcCVmfLnIxAVv3DYT
	klJw+0TEAPX6CeFaq6MHYA4G6KcTf+469ntBuDehYt6RDX+NW+ILgsa/XcD7/xIlSnZwf4sAqns
	y1jBVssFTmmvYz0PokGRzV5dJduIh1lwLiZfXiFWVDXAZGGdkYBM6trradaIsmKSgowBE1JrtlT
	cZb9qNKm+v9n2pBvZLNRL1Ggbm/3Lk93dvpGU=
X-Gm-Gg: AZuq6aK7F3ZtH5mHj4zc6IWPOr38tiqkNdXi4hqjU2xMkc5r4koXPe44Ax0VRwpV6rA
	5398rdLOnTxT1mr+bTRtpZrSP1s+SDCZo1FyEjGbminCA7Q1bEdVZx0b/c3jMOvfk9Y9VnzLXK6
	6IKqf08EfuoPAYNk2ST//zTWeem6dk/BUkJssy7Dx3/dJVL6b+qD0S6JTA0jmjZP9IEUiOXHgN2
	8mG018Ve/hhdZybWIk0oUnoLj03zislVUx8jfkWHQ08dIX8Psp2PMsRvNik3dNycZXODNeV2djn
	SaY7ame0OpU9sRq72qcVu8mX6+vL1agcKsyW/oyNFogRGVVz95p/0cNLOFy3oBbWTNsK7JeUsMZ
	UpuiisDQNExbTtP6ZP6MeaHoJ0UOKDfcA5ZXS
X-Received: by 2002:a05:6512:12cc:b0:59e:16c1:a988 with SMTP id 2adb3069b0e04-59e45171382mr5457577e87.47.1770797622234;
        Wed, 11 Feb 2026 00:13:42 -0800 (PST)
X-Received: by 2002:a05:6512:12cc:b0:59e:16c1:a988 with SMTP id 2adb3069b0e04-59e45171382mr5457558e87.47.1770797621657;
        Wed, 11 Feb 2026 00:13:41 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f568737sm188515e87.21.2026.02.11.00.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 00:13:41 -0800 (PST)
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
Subject: [PATCH v5 6/6] mm:/migrate_device.c: remove migrate_vma_collect_*()
Date: Wed, 11 Feb 2026 10:13:01 +0200
Message-ID: <20260211081301.2940672-7-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260211081301.2940672-1-mpenttil@redhat.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6fb9-ncp1FZaHgaxFyrYQ5RbBPfyKd4lRs3GX9zdhmA_1770797623
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0CC31180009
X-Stat-Signature: 6a5c1suxdyxeqd4omesnx38nborxcxmq
X-Rspam-User: 
X-HE-Tag: 1770797625-843199
X-HE-Meta: U2FsdGVkX1/Ut/pW6Aw72LIaWW9zyY6qJkmkNN/XdNJTiKUaYnMWeFcDiuoeBNbWjob9ZpMzUrjhTuo5AcEdH+9ufCyKdD1Is0oSApt63iM+EIyKTn/UjmqJCoUeYttMeatVNSD1TOUfC/1JgPQfKyF30f0LN7DEYdkuVtM+7hri13B3aSU+mp73uwWk5p/zvAgX/ihA1o6ch3fe6vdQEf5t2tTdejHFZc6Tu222vaLIquel2s1hsUo1ik8oiOcG0dknV/OHyuK8BNDOW2qxq4KlZP08XgcsHtW09weXIIYISsvmxzKFXwZOX8X8W/I4tA3wOyoPIHaXBNm3jSj8wTBn4K7oSaK7tgWgFJRW3QWkd4nyVnAcOS7fLjZgVvYsl0aAW+BQXVUilEBzSkJifCWmoaRAzizVrDPlP8Gb28nExC8GRdVr3p9iw8jCP4l2Wp5pHiUHFaCEl2JFOzy5cG82cTKr4URz7IJ2ta/L49PB4RkScLMT5MjOn7pjE8CO26HOfd+xviCtxgJrVTHfoDgd87+GEfYeyw6xGmUPlFWbjpOpR25FmiF5fiwGxfg7zoWRoI3lNjLZHEZYePFSZny8gBCcJJl6ZbNcuadtJjb+pG7pHqOBtYnzTQhwlr1mbtcKPU7Dx2plKNnF/MZaslwD1qXeb8xgI9k8b4gN/l5w3nbxOT3ZU4+amenTyrL2A49Oa5K+KuGSfdsMfs41Fa/jNG9msh5llqRlxYA4Nsle3tTmZEL3X/bBueRrV9Cq5/USUvf6mCmqTxyfTkWyV4/MQxLrZuV8WWOBn+JWmDxVZvoWLhmMy/u4IyUX888zCGeAdEmBo+A9azwRtRKQ/SY18HkcQEfPNn7w8sf5yG44lp18Q/3zcXM+Z2/FsNDdRGYFBVlvqZdJ4DRPUkqhUbFo/PAdiZxiA5Jact6y7+dU1p1uIFizzMZv7hQ2HpBz5fA2rNyM4WlJMdOLbJ3
 dX6yrb+D
 ipA8Bce/a+aCi5v50OHKm8OyREziLlGvsxmGFeRbpbXuWSHjY8xE53vnPhgf/oTPjeex2v7U9qzMnv3NNq7qvVsK7mTtZ4hcBBbVu3F88WrDi2OhE31+BCUfnx/fSdsWrT9tMEZ5w8dg2N+hWTcJh/GYMK+Dn5IcK6vE/9knDFD0qsQhdC8G0S7VwPKpTjduBAV0f11uAPeQ7KHJ9YzD8JOf05s8Udjnp5AUvq0JE5btxwWiCPr5J1smrYeif6wHEe2fSv5fPT1emd6DMCaX/2WaIb85zdL70kzyGNXuXMm3blzpruGSzD40acf6zxRY/njuKfbKsycuVH+4Or7h/16uaz2xkSAXpeaWZ6F3MYzb1CWXZKAIR40GN8WI47U4cciHh3H3pwReFPzKduwWhNR+sGQv9T4/MztdkKmFmv1ZrB5z8kyGYgQ79IU2Mx/b8OGvCyty1AodP4MFb6KIl4HjVtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 222cce2e934d..f130ddbdd12c 100644
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
-			migration_entry_wait_on_locked(entry, ptl);
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
-	arch_enter_lazy_mmu_mode();
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
-				arch_leave_lazy_mmu_mode();
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
-				arch_leave_lazy_mmu_mode();
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
-	arch_leave_lazy_mmu_mode();
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


