Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA5DCA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9510D900101; Thu, 14 Aug 2025 03:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F6F900088; Thu, 14 Aug 2025 03:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E48900101; Thu, 14 Aug 2025 03:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73B20900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:24:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4F89C05B1
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:24:45 +0000 (UTC)
X-FDA: 83774525730.16.20B3725
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id B5953160010
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:24:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KEFis0+n;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755156283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xsfpUsPt1D9nW7UmCu9D4p6novuR1BE9ar8gV/MHRtA=;
	b=paydgYb9fd2JWjxgqeIRc4as0Bpy029FW+a9DkJSoX5DgjO6mIWl27zq0njJ8Gr8V9vSkl
	61A89EoVDlUuAeczB/FW+ej+1qUIJfipUO1bFdhEmQqlHMiYZmbwaZXHK4Nap2P0ZBkFfH
	XIq//2P5lE7TDMeMXy5pb+3Bosm/kD0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KEFis0+n;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755156283; a=rsa-sha256;
	cv=none;
	b=1xEMDMlSFwb1V3dhFW30MJrRba+i/dH/gm4crE1RHuzFBPDEyFOVEetiCC4LEhgKh/oUcS
	KPcIvgD1AK+mqbXH7E+4+QIcj+dMPfmP7oAxM2bLPRvq8a6mFjlTVTFKpZSCdfvRXt2guW
	SvPC3XD4b0xYosmht9uj47r71VZFsIQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755156283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xsfpUsPt1D9nW7UmCu9D4p6novuR1BE9ar8gV/MHRtA=;
	b=KEFis0+nYcnEnW0187y8nzRkyEeTr2yx8tZ3bFwEw6J6jfKSwGURvZRRsLtrp//awd/Yqt
	D4x8YFJF1gB+D81PRWu7SBDEf8QH9aGGNCKRpbfWxO1vwZwL0NYrFiEgVUHWWaGm1ttbyn
	e3icSf5WMXXMry3WnjVgdaBEEuZABA8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-4B7cpDJ5OlG6zejP3VHCaQ-1; Thu, 14 Aug 2025 03:24:41 -0400
X-MC-Unique: 4B7cpDJ5OlG6zejP3VHCaQ-1
X-Mimecast-MFC-AGG-ID: 4B7cpDJ5OlG6zejP3VHCaQ_1755156280
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-55ce5277880so284495e87.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755156280; x=1755761080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xsfpUsPt1D9nW7UmCu9D4p6novuR1BE9ar8gV/MHRtA=;
        b=WTBTNMDm/OYlkymqRWXNolItxJ///QxX7VyqwaFZ7GzXMXh4jKR4bmN9OI6h2CNcPT
         bWN4SxJwqnkdTlyrGaeUTVQi/HYVgg9RkggNDESB3/e+xLSsbL/tgyW0ZIhLvligDbR9
         s1P+QUt1mcPa3IVQ8nV81G6eY+4A0EuSpu2Q2NivHTj63RMUCebpT3XRR/fwqpHUDNf4
         y6fxQCpluwWjQyf2DrdXzfImU1Gb97490B+Ef33mykvAYkhunRQEo8/xcHpRxu91KcO4
         NyYdw7nGqLldsb3x0iN1BVwZI2ru4b6lQktDyBWkFs2Q8PP+202D1etZiL3+JHciZHk2
         nLMA==
X-Gm-Message-State: AOJu0YyMb8wzuyF1MDC7rCq3SqkDLT/dZGcM0Cj3hAHowOW6mYDeUGpG
	DbRFLUYj4sVgz7VxfEWzU6n7w//By3V03q3YuAer/HdG6xPuIqZCRv0Aiulb6/92nEwcxbYIC+V
	O6HoAaEvOJHYoFZ1wwJe/FmoXHRXAzu5xpM4Fxgvc4WiSZyWtz2AwwnPxEHjHN/3m3LOZf9PR10
	Qoobcz3BAQ9EBYegYuLwzdF1+IEW9Bj8Z6qUs=
X-Gm-Gg: ASbGncsgJa060o97IgY2gSlIF3wixJCQXM2UJP9DYEJfAWw1D9H2Sd6XbxvekRuaPAV
	ccIU1d45EiJNd6GKRP5PRghN2eDJV3hzzEKtziasaaZKwB30kYBu7RRQUyUl66sgJUTVU0xeXQL
	Whm+E4dxP2kncwNHCbuI5SE+T/krk85OGlcAa2HpQBrQmpXIgMRqjZsd2ox0HUpBCt0UL98mzO7
	nKInzveyP0/f6jU+1qqWftD5sFGbevpMBQ+c74bumf4b0i509o5TRyQsoi7BXba+KJ+zzXnUWY6
	wRIrljrZ9ib5byj38rP7a01NdmBU3RH3WZ/KLold3VS+MkBTM8Q3Zsk=
X-Received: by 2002:a05:6512:61c:10b0:55b:9483:81b with SMTP id 2adb3069b0e04-55ce507284fmr454481e87.34.1755156279808;
        Thu, 14 Aug 2025 00:24:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFn8nn/4ZhQUj1K1B8nfz1K5TpdPbaNLcM4Kv2veVg42Ms/oRgm6KLivI0SyHH3p7l2pOodFw==
X-Received: by 2002:a05:6512:61c:10b0:55b:9483:81b with SMTP id 2adb3069b0e04-55ce507284fmr454467e87.34.1755156279245;
        Thu, 14 Aug 2025 00:24:39 -0700 (PDT)
Received: from fedora (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b887f72f4sm5620240e87.0.2025.08.14.00.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 00:24:38 -0700 (PDT)
From: =?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: [RFC PATCH 3/4] mm:/migrate_device.c: remove migrate_vma_collect_*() functions
Date: Thu, 14 Aug 2025 10:19:28 +0300
Message-ID: <20250814072045.3637192-5-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250814072045.3637192-1-mpenttil@redhat.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J3C7YHWGEFg9nVV0l40GuTsKxUV8yj8rYW9H6aWQRVk_1755156280
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ez6t9k4jmuk7pbyz1nwmugejwzj8qzje
X-Rspam-User: 
X-Rspamd-Queue-Id: B5953160010
X-Rspamd-Server: rspam05
X-HE-Tag: 1755156283-520224
X-HE-Meta: U2FsdGVkX19RJp4jt5t0lnjeM+18nn7WuamXWQ8RP8UUKEcLFji7p6W3cKvcHs+7ZxT7NWTfJMQyyOsvizwPuKWYvxNkb4tLa1tOrwhEOY22rS/NkekJ2CjEEeQrNM1gAHTLc6yw4fBqnssLdjUeWjD3bL09IlC5pGNwu06fUpaywJRBqkKrcvNiqxmr2gMcCTBLLw//oFHEaIVEE5XbqrInCGZ48MVa/aS/Bx5MnU5duiShz4FQdnsENeSW0vTIeE2kR7wPRaBxc6qenOvGLe0nX1UNVttBF1Mi5aX5STAcJdrZimYl3EQmfOFYwkD9DpcaMtHyjaBcoCRoqozFS4YxLlJAIII/YyOSXLMRDW3uhQuZ4sTzPXGzs0pf1mp4zNlIAblEJ3wZ/KNsDLS3pnYM+BPhO+In3AGiQGPHuYvM5tv3m3XLxkD/u3Nuk7o2jtaKbeiVd65MQg4+VughjtiwfOkXXbY89/oQXOxmCbI3pcjseXI73J3nZv0GRdGcE8Nt1tUYv8bJS87YRchkXj5G2ioA1H2afL8Qps7iNfrY7cV35++mjSuY+OtRpAoEiIrXGQhQKKLXsAHLtFlu/NWg3t2wLgJ7A3x9xmmx6o/I1/R7H+VPcxO1Z8U09H5dzAIeQK5uqdjhGLT5DpaiAi9N4fFLdPyubsES+F8D6gjvQ3OuDEuvrVNUpX2KNsPHErpbY5qZeCWVDqQH8Bak1ZDosijXZ0O2ZKYZc5jxe2AQTnntzLFLLSHQtjV4MXv2JUQAEy049lrqkGhn6368ByI66X+Kh4sBfLwOPUscIALGXyqYTRbVTOasfDTSqytxpXo1e6nO/DEDDV1S1NNz+0dgm3AnZC5nu0ohNfcRMSqlw1mK3Fqm81SxkZJWe+f8b9Mb045Rbt8RuqOQl/l5hFs84oUPklvUbhhu/FiOVygv88YK9/Kgvzvm0kJFVUBerF3qHBrWiToaSqiR6EP
 4MFVyivv
 XDKyNwLMepwVQcU1QhOKtZxu2VhuA1mcDgpzGpMFeLwuzVGZDmoaFRX941V9xhxde8XXWVz33RRIxlZhJX0txMEfyy2Mw1YJaCHfQCWBNeoIQlwvDuZbDjxrUUdVpJX0HsJK/waLrcrCG1fV1/6qGY+4EaW1LpsFjNmsmSmXDQKl8usP+KDrET0SBkLi5Mc2bmyo+C/h45+NE3jMbPXLiD4IbgYsJWv4dw6YhJcMpXNTzTJAxG5GvIGWkn2QWDwPq304i2bpPHfURPklco6GY7UThKheOCi148KTK+Cp/EtDx7aeo+wVGvEspmfEJes3EK9xlnAjxb/z4uwAxDRG5EZApNOQ2ja2b7W6mUTEjpLdHLjKu1xtIrx2GSdnSa3yiDZVKdefzgjXXF4y506bUsbAloRyzWXItkPLn3TPy2WYCwKwnt4tVkTB6EtI4uqaW0MoLFQ2zHPZ75sf6K1fcryoQOsuggT6jR8hacb5ViPj/GoqjiixYZ7dkGr2RCQny/E/SUG+ShewFaDzhikNOzq5uvkfiquqggBLqC/en1Ael6eJRvj9ux6YeHErMlH9ybWfA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the unified fault handling and migrate path,
the migrate_vma_collect_*() functions are unused,
let's remove them.

Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>

Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 mm/migrate_device.c | 312 +-------------------------------------------
 1 file changed, 1 insertion(+), 311 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 87ddc0353165..0c84dfcd5058 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -15,319 +15,9 @@
 #include <linux/rmap.h>
 #include <linux/swapops.h>
 #include <asm/tlbflush.h>
+#include <linux/hmm.h>
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
-static int migrate_vma_collect_pmd(pmd_t *pmdp,
-				   unsigned long start,
-				   unsigned long end,
-				   struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	struct folio *fault_folio = migrate->fault_page ?
-		page_folio(migrate->fault_page) : NULL;
-	struct vm_area_struct *vma = walk->vma;
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start, unmapped = 0;
-	spinlock_t *ptl;
-	pte_t *ptep;
-
-again:
-	if (pmd_none(*pmdp))
-		return migrate_vma_collect_hole(start, end, -1, walk);
-
-	if (pmd_trans_huge(*pmdp)) {
-		struct folio *folio;
-
-		ptl = pmd_lock(mm, pmdp);
-		if (unlikely(!pmd_trans_huge(*pmdp))) {
-			spin_unlock(ptl);
-			goto again;
-		}
-
-		folio = pmd_folio(*pmdp);
-		if (is_huge_zero_folio(folio)) {
-			spin_unlock(ptl);
-			split_huge_pmd(vma, pmdp, addr);
-		} else {
-			int ret;
-
-			folio_get(folio);
-			spin_unlock(ptl);
-			/* FIXME: we don't expect THP for fault_folio */
-			if (WARN_ON_ONCE(fault_folio == folio))
-				return migrate_vma_collect_skip(start, end,
-								walk);
-			if (unlikely(!folio_trylock(folio)))
-				return migrate_vma_collect_skip(start, end,
-								walk);
-			ret = split_folio(folio);
-			if (fault_folio != folio)
-				folio_unlock(folio);
-			folio_put(folio);
-			if (ret)
-				return migrate_vma_collect_skip(start, end,
-								walk);
-		}
-	}
-
-	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
-	if (!ptep)
-		goto again;
-	arch_enter_lazy_mmu_mode();
-
-	for (; addr < end; addr += PAGE_SIZE, ptep++) {
-		struct dev_pagemap *pgmap;
-		unsigned long mpfn = 0, pfn;
-		struct folio *folio;
-		struct page *page;
-		swp_entry_t entry;
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
-			entry = pte_to_swp_entry(pte);
-			if (!is_device_private_entry(entry))
-				goto next;
-
-			page = pfn_swap_entry_to_page(entry);
-			pgmap = page_pgmap(page);
-			if (!(migrate->flags &
-				MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			    pgmap->owner != migrate->pgmap_owner)
-				goto next;
-
-			mpfn = migrate_pfn(page_to_pfn(page)) |
-					MIGRATE_PFN_MIGRATE;
-			if (is_writable_device_private_entry(entry))
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
-			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
-			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
-		}
-
-		/* FIXME support THP */
-		if (!page || !page->mapping || PageTransCompound(page)) {
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


