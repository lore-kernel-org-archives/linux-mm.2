Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A0C3CCF2EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 11:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3686B0190; Mon, 19 Jan 2026 06:28:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218366B0192; Mon, 19 Jan 2026 06:28:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092286B0193; Mon, 19 Jan 2026 06:28:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E2ACF6B0190
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:28:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D7CC1A0734
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:28:07 +0000 (UTC)
X-FDA: 84348489414.27.1B23753
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 56A11180005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:28:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MOlOdHSm;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768822085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIWs13uPtbBYR5vhSSUBlncr2KRdF3LUR9HD+nqyOvQ=;
	b=3NI+NyxPWV8BML4eMX1Fnb1QoEK87hUct832rxgodmHLwUXKjRVe7dIrCwn8uOnBdRFAsi
	fywC4vfl52Yu8Cjf7bKFMgX3tSbPBhK57a7BNjBBVxi61nT1x7GaA2E7zhrewx2gd+s/Gg
	GmR0z1BJwhmxn+MlOL3/LsJxsNJgTmM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MOlOdHSm;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768822085; a=rsa-sha256;
	cv=none;
	b=MLVVVvz9y0vKofqiYr0pXEcDGU1hL+ToruM+uvaOy5179EFGUkwJjbt1DLU3TRD5o8zXYN
	dYLD4zfx5h+Ha/5IZdEYcyiokCv16J1SrB6pxLZNnArx7rgx0IAY9zt0u2Ii3WxszlqHRd
	mErM7lMZDapsOwXF6qsKYMnLve6mtzY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768822084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIWs13uPtbBYR5vhSSUBlncr2KRdF3LUR9HD+nqyOvQ=;
	b=MOlOdHSmMWmfAkfRFCJXQicR8Wc7CPhFI8ZepCNQKjfakS/iZb8sndYvJB8leBEHgc0BQN
	u4tsnbMKkvj1b1ZWyEyYHNLuk5z4JgeHU9/wMdDIgaURMozu72kuum2OJHsOJ7PzeKxBgz
	Oqy53E2m3vX4Cq1FckT+GviQQAZsBeo=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-3xoDpihKOFOIKude21E8RQ-1; Mon, 19 Jan 2026 06:28:03 -0500
X-MC-Unique: 3xoDpihKOFOIKude21E8RQ-1
X-Mimecast-MFC-AGG-ID: 3xoDpihKOFOIKude21E8RQ_1768822082
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3831427aeceso34766071fa.3
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:28:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768822082; x=1769426882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MIWs13uPtbBYR5vhSSUBlncr2KRdF3LUR9HD+nqyOvQ=;
        b=oGwgcOmjGyRugJvANH+aoUt8Ac1W0cTLxtTTat9GCxDTsNYZSkJjDSwWmGUU2Mcal0
         lmmt17fdRMsl2pLmZq0f7mR8qhOXlICIV2fL1wb9ghV6SB5HGo078lp7wlSkBXCykU1i
         3W/wsulDgS6VI/GIdzmjAJHQ2GmZYR9xr/MR20IASvUoUPS9Sju5GuX8mPg7M+1h4KXr
         uGe+C2j2v+TdhAtBJ26GQaJ2dH2/m4FfJMQADBL8UU6HSBv3VzalP+OfgzWI6jx0taho
         s2Lp3wdccREqc6B/8ixOPLlwyXm5Lcuhl/G+hCyUqlPv9e/x5bVyXpVAn2YkEJg+aGRQ
         +sCg==
X-Gm-Message-State: AOJu0YxJtNaZuYTtUNJo6tD8POxa3wUPeeF+l26iJbxzUBCX6glxAHgE
	5v0jU5raWN0THSIw0Ye1dDUtxB/jy6W+2ReXO6lOQjd5VUjY6kiAGG3Zl84WlHVb2UoDmb2ZGB9
	Se0MC1UErsXFv+q3KA5/qGl81juSktSN7Rn2gUDJJTIyQK0N/Mfcdisf12ckiGjLzBDDPhb+tFt
	rRXwqXMCc3lkCcYQwzo8sePVDNXcH9dc85VdM=
X-Gm-Gg: AY/fxX5aF12JFlJ5Y/4Q4/Q8s+MI0M2i7ztSvvuCYxrI/zf1a/C0tX1i/YwWq+LVJiM
	0cdfVAyvVfxgkvPz7ZudOubPcZHqPMZHGL4yEmwfFNobJ/8r797VbtwOwDfeVZfCIIl2YnU0Soq
	Ex6LdKBhebRkQbkms1KSf4pjyYHtHMBS2dgo1Syb9QZomJMCWqdAUGFIeg7WAESrjkLA6TduYQK
	yRY1SDUYoWZiN+zYd4TF3NZwKQ4CmkoNNAdRfHaejyOGYoW9toHf+dzEztRr4zTBivzdvmawenA
	ustomqJ5+bAEkrLyulyYNHz6bxg73Z1H8gYAECYZ693UVMb9FDULjr4jO/TFpFrSuWlyy8NNAtd
	Mu/GbQo2XN8Zo0oGgBeh/7OvB
X-Received: by 2002:a2e:bc24:0:b0:383:250a:850e with SMTP id 38308e7fff4ca-3838417cc48mr38376951fa.10.1768822081561;
        Mon, 19 Jan 2026 03:28:01 -0800 (PST)
X-Received: by 2002:a2e:bc24:0:b0:383:250a:850e with SMTP id 38308e7fff4ca-3838417cc48mr38376731fa.10.1768822080976;
        Mon, 19 Jan 2026 03:28:00 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38384f8a1efsm31226411fa.39.2026.01.19.03.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 03:28:00 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH v2 3/3] mm:/migrate_device.c: remove migrate_vma_collect_*() functions
Date: Mon, 19 Jan 2026 13:25:02 +0200
Message-ID: <20260119112502.645059-4-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260119112502.645059-1-mpenttil@redhat.com>
References: <20260119112502.645059-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -QRYzgw3BdqbKPqUMcndoy_iFFGV5vDaBjOMg3GiRw0_1768822082
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 56A11180005
X-Stat-Signature: n1wts1as3t3xqj594bxw9d4d4k8t9xpx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768822085-218354
X-HE-Meta: U2FsdGVkX19+WsYGhFdPGEFAElNV6D/MvWg/AMcsP5fyO2HfofD9edBOUUXxRiAaOXgJO0Fh/04YV6gKzGanLQpB66USeTopFo8DhQRzBvX6zg+3BQhkKgCBsD5BDbafIQXQiKcTNQ5i82ffIN12lqWTJPf0fmohi0154DFuD6ZEo8WEPo2Ty3fYbhyTYY5E/OgbXe4Lh30x/We2pZ1iDfxXnSlFoBU08Y6f7OWObipMzrnUVyyEfGxsxM9zhL2ix7ZolXAVGwcCxja+y9f9+bGMZLuBkPiiU3lkLYw4W7mFZnf8PtO1yJM0hxKr1hsnsD4PgQQcX4c0fjzM369a47lpQDfpW+SvCyZ24IqWJtPUqwh4G6UH4gBb+alE3/CfuQ1MglEVdYQ4dKgjXNYx4+8tB3tHy4D+571mMbsz2XigsSipujE//2q9OoapKcRaUVCR81y8DBL++qbKOL45CdJNikWBk3vdrSf9UWyCfx+DBOBSDwli9RcwfJz0inihSkPbF+CiS4LNJjtcZPfhh7Zqeeyh/6b3A9ZuutQfAO1S5h2zd7sXn7TFnOF3ssip82bi/tdMIvPPc85/zb/lYCQXwFsj5l4E7ECl4SDoEwkDpoVJCmDiP/PUiq6lav6pI0AS9cnnmRRvXhUqKsWRsBok4eRoQqLtX2OGziGHzVZHoYUNcgQHjVHlXOYaOdNT6SeHtY6zKXTt3KlI0SSGiyrXf6ZcUJGMotwM67Rf+98hZc/ZTDfKWToNaWCBaZcITptj6YpNIQK+25OnvBq7HDqxMPvOjywySncdEpC7ScIBEFU+UJdcpsVvQwXTZhRi42BDdDDzA0TEgBmeZKMMirxGWSe8SZxxtGv48DHiw0hBFn9T8wdXHnz/5A3owwxeVj6RYcJhVOu29SlJxjzjR5Tob/+Kk18bwD5EPLs9pMJ2HDqsTybFHEZjmfRUqbX5AYj1BGZIIPJO5F+/Pv7
 RLV+Z4DG
 9aeewcPfBtiBhCJpld8APgHrbG3YF45giqK24dujv5FmSmkAcyI8QShap3PZwmDMv9+JycFgNWMipKypYMQJOl9y0G/HCz/cxUMYf+7WBkgyQfJm+3qQZh3PBijd5t+O4AGvV9rhIlq+0+9/ZfPmT1OMhqgEzKmnqT3baynPMCbPVnbdCkNFk3NTOvs5hqxfYE6Slu/wu4IpxLzZrqhfF/NNiCz04NGCAZ/LE1ayV3f0SwJ31M/X1rOnoAHbWRIsr1feUdvXdVe/lQ+MizZ1vNYkma++0aHnUGRxw9qLprv52gm1VU7355WguuwYftwDcSZyq2+s9zVabEL1bVKZydFThyVeXCoJrmYmYx6n1lASwqrCehuq+f4gNfdyz3Oppt20aaWJ6vBkNZ4LZkcNntrNTUTp2UCc4mB6UiG8qtB4jxsgXkc8X2eMqMg==
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

Cc: David Hildenbrand <david@redhat.com>
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
index bda6320f6242..c896a4d8bca2 100644
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


