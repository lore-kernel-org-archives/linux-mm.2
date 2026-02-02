Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7823EE7315A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1F06B009F; Mon,  2 Feb 2026 06:27:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D855E6B00A0; Mon,  2 Feb 2026 06:27:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3CA46B00A1; Mon,  2 Feb 2026 06:27:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B138A6B009F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:27:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B16A160369
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:27:01 +0000 (UTC)
X-FDA: 84399289842.20.E264FFC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 562D140007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:26:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SWDUBh9b;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770031619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIWs13uPtbBYR5vhSSUBlncr2KRdF3LUR9HD+nqyOvQ=;
	b=BVFcCRbA+JveQSvWUgKVz14jMma2uyMO5eo+GVQ3DUAaU/OWzOEpkLS6N6HsAxTdo6vBf0
	6whEPoVlpCwiKtX3zoHCgzUo9hrKquqjHsIcs0u5H+sPUZ+lgCuPn7v5jE1AJqoM/XAqnQ
	S96ZgjmANr6XfkvBq88zxUTFMuVhVNI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770031619; a=rsa-sha256;
	cv=none;
	b=36Xw5zfikgX8KPjTs1qUlKBZeng8vb4dB587lP8kskivj/wNHILD3aG/4Z1eNKl5Xkt6hj
	uHRuysIPXb0ACU/pp2D34/Tvdkm2+Gng+AHjFJb7R+HHCbXFhQ/KYMQ1D2r7TqppAlDGB7
	WRmtOFEVe4wHRg+ybvGnSyeoe2VegXo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SWDUBh9b;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770031618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIWs13uPtbBYR5vhSSUBlncr2KRdF3LUR9HD+nqyOvQ=;
	b=SWDUBh9bCHzu9DAXlmJ5dF9Tl/+Wcj3mGIN0fZVc4V4hkDtw5l1wnAl5Kdxy93TnWPfX0u
	PFqncRDhH5ZDphW9yopvmNGADsOlo9nKriED5mvNYv0k0BX45osT8Wjv+xa+zJdAElmqe1
	Itld6OtVsuBev0zNfEYc6gyVW+cDYEg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-FqDDmvhXOuKbnJuQi0jzZQ-1; Mon, 02 Feb 2026 06:26:57 -0500
X-MC-Unique: FqDDmvhXOuKbnJuQi0jzZQ-1
X-Mimecast-MFC-AGG-ID: FqDDmvhXOuKbnJuQi0jzZQ_1770031616
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59e14ac0ed7so1937892e87.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 03:26:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770031615; x=1770636415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MIWs13uPtbBYR5vhSSUBlncr2KRdF3LUR9HD+nqyOvQ=;
        b=jscb7cCoCEb6xRg15t0wiSGS3X7iUnDfARksLz7nKCX08oRaYcebpOzyRCdd7Wae4c
         q5JeaNZGQLmkCJaMDcMc9U1XzHUHzUIZCwERD379DNvOcz7Q+HJyWMwRnoQm8XHiwKDn
         Olcu5UpM+UOxGSYwu6EnjMM0TfKs1WecpRvpE1/iIrhCOJkNkXrkEQkx6YTi8cK6I0Tm
         qMtmT7t8zyxsS5bRpF1EuxqJoSxvcVHIliKx0WZuHGJL5CkD1B9eyoZu9V3nGCmXM7CF
         vOItgDZT0S1sX/sin7XJogRrOOI9aMsV3Hsn6H2SeiC0nXeNSb4LhURv+rveqFojwOv9
         X7qA==
X-Gm-Message-State: AOJu0YyCi5OGpsSFP9dEtlqpgxHhWKW7qZzNxVArZbDcVSG1Uqv4fR/S
	PLuZvyPvW/KGr0wzG6Offk8x2jwW/YN5yjeLIZcoka+uCDwEijTMMRIWi9wS9LeKvSJqaROFIOa
	O03fGBOG5dAhWdqwCmcSbkN0JRsC1mcRKA0YlHOUsGHu25E2XrNKiqSwq+rYZS/BP/ViYvdXtOr
	nihug/aflC73er8hNYO0mcphzS058R4xsA8f8=
X-Gm-Gg: AZuq6aJPUCy9Mna7iYKYn2e95K9VLfw2iSQqPpffcXOdSnMHzLgpGNVjfB1COOlBlGj
	H82n4vtCxFwVHJdLp7EoOGwx0t/KgPIwxN2pfo3MgBJSxUxfkJgLVvO5ZTCmQMxwkjUAlgVkPar
	PP0pzM4ziBgDpIgJ4yNOZ4x+zzg4G9Bvy0Vg2i/0Lrww4BuXS0Gche+HLAXaz3A0kDBgM2zKivc
	HPs9+S8Gh54y8OrX2UtBO+2wKw3V4YqV/wAdFzxj/CdIVn9PhIcXxeALEzoh7SJQvluy3B2QL6J
	erL2HYrER/Wu87+OMUYwdgOSv+C9u4FRLn5Yb0QvdN3b3bOcC4NV1Ro7NHDN2cJfnfLd5YqdSJg
	kKesdHRpru8D4m74PEoUiL93M
X-Received: by 2002:a05:6512:1385:b0:59d:f3a6:c2dc with SMTP id 2adb3069b0e04-59e164056d1mr4430230e87.16.1770031615473;
        Mon, 02 Feb 2026 03:26:55 -0800 (PST)
X-Received: by 2002:a05:6512:1385:b0:59d:f3a6:c2dc with SMTP id 2adb3069b0e04-59e164056d1mr4430213e87.16.1770031614934;
        Mon, 02 Feb 2026 03:26:54 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e0a43e8ebsm3221336e87.55.2026.02.02.03.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 03:26:54 -0800 (PST)
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
Subject: [PATCH v4 3/3] mm:/migrate_device.c: remove migrate_vma_collect_*() functions
Date: Mon,  2 Feb 2026 13:26:22 +0200
Message-ID: <20260202112622.2104213-4-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260202112622.2104213-1-mpenttil@redhat.com>
References: <20260202112622.2104213-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1uQqDzspOijTfsmxea9tr1cXzK5IzIuZi6YRBFeZOWU_1770031616
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 562D140007
X-Stat-Signature: f5d3petp8mn7orniconaxh1hydwxmmy5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770031619-745530
X-HE-Meta: U2FsdGVkX18S6dAFmO5hPh6xPUA4XKV79KidRjpTcUB4oC5T2E07ZtCh1N8rKlZl+gKJxAt1E1AswGYvIwmdtrnqbKge1syIWO8b6a9IPN4cpOo0hdIVE/Mup6LYEgYuKsr+8cfEKldZxiJ2Y5Uq5KY6w7oV2Z2RA2QfLMtKzFo1RC9Yeh1v5FDPpxZrr/dY2k76ytUwI0mKUM/Txbh9QIfDF1VYEvqb/FYugmQ9vY45PsxLuCE7JdQm/AEqTAHj0kHx7KYUH/hjWz5r2yBuMYGKFgrKDDtOHkbpygXaW4vLBYBHEpbRyk7L/x47JoeKmjGwh2MrJ4U67It086jhhtLQmkBalUIgqkfpuXWkJHZtm9+4M3uYudhEQfDDeisA0qAzae3DFKSb6/tyRsAuve1+uGrsPKeWzePz94u1kKMuM7KDkXMQiFQJMNXUr1NHU+gzdXCRShY8nHb+Yhp5mEPKmeyujj4iAozQCba8vs+1EriLHfWvFzd9Akxm01bwitdCR27PQs6OHGvIhaIE7ZxPtJb/zKhfxBcNCYtWsNvwQatkFYLK4Wy50MNGuwxicxkAo9Ube09SkI5ta6TBdn1zyfM+A2s1IoqGazDho+jVxNbSw+7ybsy7yQ64Hw7hvNzMurfRGxBAnz858TX2y4INeHiwhiK+pyvgrWhuQo/xX/VpIpiKMvqjDiUtgWEIbho+4G0J4TmKEflg5+VtFyah0Sp/GjeHYOzmUchuPyCZShLsniLOH4KjyXqEqOfarkRJKFqBqXtA40G4sY7iBGcTvPkpncPatafDrxVAIZ5gNB9e2FSNhQ/KAU2+MY3aliDypZDkYWU5/ei/YIrB6KAMYdVGgqgiuxWKle/aml50zRJM81km/CPYlclRVm4ZdD+VvmP6ZymJGub2xCEaLHjxua0qVUZZ/PH2RZYlSrzTzs1zbw5M48SY4jsFUCRjwjbCDGIKhnqsFSSFfbv
 voOAhrOs
 Xz5PAB4dF/TwArHUCJRVHymJF3bZOcmy5MVL4urBRQ9rMv9o=
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


