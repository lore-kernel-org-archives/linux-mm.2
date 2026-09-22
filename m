Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F4FC98304
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F15C6B00B0; Tue, 22 Sep 2026 01:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2666B00B1; Tue, 22 Sep 2026 01:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343CA6B00B2; Tue, 22 Sep 2026 01:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F09406B00B0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:35:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85792120387
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:17 +0000 (UTC)
X-FDA: 85240285074.11.6E867C1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 554DD1C0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L+lGlOhW;
	spf=pass (imf18.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055315;
	b=Zr2edEAx6CP4KM+oI2lZnwxl+7WMxY6E183SnYQsg7sD3mQdxFJ9H5SPZhmfNI5EsuHgBv
	Z1aZd88ceTp+CbKDpRNd2lW8gswBelyS//fwg4PsQpYUJfln3yvNx8Apg6Jcx834AnWcoQ
	5qyxzbZjSmzTHRpyezpdULHGQjshzp4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L+lGlOhW;
	spf=pass (imf18.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKL+vFX2Cnp1o1+u97ic85G8uQdKpjbv7FGhiJsOCec=;
	b=qPm7Df+so6tQifJfB37zBtCmUQdYjcb4RKOXYCqv/H7pCJNQ3QiDyI2LhhH6kcywDsWmsh
	ohxteAuxffa9P4Di4i75itATfhZkyvhOt6ZUrstsLFzAAueXsVM1HyYndFLlsHUNpR3Tqz
	yBG7aQBIBg4d7FWQphALkivhk9gHc70=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKL+vFX2Cnp1o1+u97ic85G8uQdKpjbv7FGhiJsOCec=;
	b=L+lGlOhWLxBcXxsD6IFrRY/F9JkzAiUCeg/RybUfgHh6HlX9aZnmvkfG4g9zZCkLk0CYys
	SkkTQLeWqqfTwDOj0pu34YOHtzdu1D52p5x8Sv9VlANI9sDAdTdgw00klr1eMv+WbUWNFM
	p6blxq8IPAwQnGAI0EOuNe79YBm0Xts=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-pKFQre9FPuWpJryHx_f6Yg-1; Tue, 22 Sep 2026 01:35:13 -0400
X-MC-Unique: pKFQre9FPuWpJryHx_f6Yg-1
X-Mimecast-MFC-AGG-ID: pKFQre9FPuWpJryHx_f6Yg_1790055311
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5b8c58cd8c6so1666196e87.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:35:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055311; x=1790660111;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UKL+vFX2Cnp1o1+u97ic85G8uQdKpjbv7FGhiJsOCec=;
        b=boz7GT2cNN5X0iS0IgOkMPUqrkWKUIO4LQWBNSqt+2pbVlWowHWZpb+PK/mWgW/rMs
         QE7Lc4ZXcG3F2wKhciZ0onU6LuB6DosHV447yMg9RCmekZgRKdy6HoMGLhgMuTlauWbm
         Asy+QQ3xKkgsLxV7pXNCqyZnuc0aA2ZjHSD9FGMNAonf5p2Wn572jPZ+b28U5++PGJi3
         FSiuMZxlxLtG8yrckG/s+H9v2yz5nQKZZf3iNv4SSVmcOE0LFBSwB+5VlTxV/3RIjbwv
         gPPFjP14+Vq2+I0FuQ0MYlFVjjviMgObkZ8LHYX6yM28Vn+nA7JsVOV39AljnOXHQBKY
         ogrQ==
X-Gm-Message-State: AFuF++mUcBgL8TkqUM9a0lG+0bm3BPqUQfkdp3c2ZuJbL8UrhEN8DM/v
	eJdn2p4rv12p/weeje5Kme+FbWyTgd51g5PkOby3L5/PiSse0duGmVM3XBBsvruebKar+tzb4b5
	MXWgXA0TykhMtNE0qWy5YN4jhHu7Ca9WMTIWPoyOexkFzFJ6j/SUM/am5GcDUx/WTuXem+C0Dep
	75fbT7CcooyNOJ04MAfLpLP2aVOVoof+94GYb5HA==
X-Gm-Gg: AYBFou3UlB5pgdoahIuxvvdPRbATrnZXIgGx86+P1uM1bqbBcG36JXfbHNixHaMH9f5
	IRym/KT2L6+0Pkp40QrLWb/PgjfyKF66VF9zxJ4P2iZCPMQRHRlQvkVSACh0q424Pc/P9ZJgr8A
	1csheVtbBIv4YR8VOWKLB46/tcSibQ/cVcp5z6q8zXJbzyYWjMtmveTIveQ/XbqoxjSxr+txNoL
	IB/UDrTx7l8Ie4wXp1VZ26knf1dsV97W4xYxSuFtTryuLuxI4OVdh2gielF1zMKxiyhiV9LFICK
	YqZq0DWb8aL0Kf1libR3z55NdHJc3datvy61+wWbu+7l6ZYdtp/Gxp4RgRREDcglsxpt0sqTwSj
	J3v/VOGF4E78I55hmsA/T
X-Received: by 2002:a05:6512:23a2:b0:5b6:6b8:1fc5 with SMTP id 2adb3069b0e04-5b8c18226eamr4272922e87.17.1790055311180;
        Mon, 21 Sep 2026 22:35:11 -0700 (PDT)
X-Received: by 2002:a05:6512:23a2:b0:5b6:6b8:1fc5 with SMTP id 2adb3069b0e04-5b8c18226eamr4272895e87.17.1790055310478;
        Mon, 21 Sep 2026 22:35:10 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:35:09 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v14 10/12] mm: enable device page migration from HMM pagewalk
Date: Tue, 22 Sep 2026 08:34:19 +0300
Message-ID: <20260922053421.4092027-11-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F40g2y_RK9mAuhqdbnSgUcI_axZ9j3tD8-FE-o17_p4_1790055311
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 554DD1C0002
X-Stat-Signature: w744te4ss5amkss9peeipogfnkem8h11
X-HE-Tag: 1790055315-632226
X-HE-Meta: U2FsdGVkX1+7TJDVY4R6oYbbkHFXYrnyZt5LvYHPQaaTVl6UJqZ81E41BM/yfP/uPprMwi6uoBD5jA7EEJ3XUiqn/8VZ4grz25e/kh8cirI3BrlGvK5TTeWsqKMtuhxZcRvOnh2cNde2TkbSO2LhFPUZ4o/LfDLuTraotrwb69H9a9ZI8vSnTe5FQLTe9w5ZfJJ8kSJPLDjYwnLcuL9lALYMlcwBUSJYyLiE0h5imA8EsJdMIqKVkV6OpXmsszcnrUj4RnrdP+5Slk22MynYNaZPcGIEsFOI30fXLBVMdIxRXWUt1W8ba9rROiwciGR+P8jBPopii4cdjtVaVxU4FpJwmq8J07GE87HPODml4DCInGi606nJaoquv0lBty2J0MlxRauFZ3HiNBwx5mQchB3aTVmECckn6GxIcIm7pw26EQZfsBDxuW3YFrhdE7pwcoYAzhjPU2TfMCps4nrk5nbeUQgw26zVimklZ+bMDG+ITcyYmCMZanAiH098AomoCQpMGXY8zP+luUKa6v5UWxhLtHPBdDRohcg3219yD7hg+ozq5IYhkhMUsanyoQc9KPYdM4eqzdP0G/F5Ut9MqMblXMErl5dD57Lkb2bJLLvqkFNkveB+2/sOgnI7MLuoBSu3yT4wXleEI13uMmYWOoueq3uhUyRg1FoWv8Kfs+4k9aPXU+c3O+ZcUVZk+JPGg8SRFdMNDrejGph8mp058J8mEIisUckdGBi+CHhbsxGQ+Vwhh3GBfH/kKYhwdjjEDFRPjAGsqNKYYti/hEyOv9HT+d1awK8YRUEFnNBFM75VuDcJMlQVznrJSNCEPBspiSJT3Mz/Lyz22IyP6iglbLYk+GkLT8//sFCK5aschgde47wkMtMqEp/TC3jSrdHadp/1QgplNJ78iA9MA0VKqinqYjMSLUBTEBi1a2Rn1+ZBF3nm2Q8WQFuH6stqwBhvPieV679opDQjNFOWTJI
 rhG6T2t2
 FKCTLX7nXCsc35N+kpZTIYeOoa0jNkr6DsiNPW/3Csz0FI9KvMw+bA4QyNrpx5gGRFH7MqxPa8vD0OPtgeBoDwqnXkC2w8BaUKm2bvt7/oSZDjbTfwqvZVU4UmOlx+gAhIIX+MvNdKymk1o6ZYD6ux8i9EPOhn5mT5LZtgCE/rra4Bh1cfOZ/uxNkqi3b2bwPrlqNyO/Y5OiHrd8T0qM9I0qT6vT2+WC3iOIzz+bDuoOigTMZPrI8c+wV2NbzZ4ScvXAfnQCv4hc68m2To2a+1rzVdV6nDfKZoAJpCVALFL+qVMqP4N88bdJBSi0ZcTzWPiB0fOXl6Isa6PD0zSLcod2wH1JdtZXttthDYAih+CO+JHm+XvkmC/2ubORefGTGFnwQ7WHbDoEcH+hBvRjHKz/1BhhZ/ZQrbCH5/W9ZPtGt4ycoNnCQonk0tciNDsR0+q1vYvN3ti2DUEvtSxZ6ZXddCNT9orQkylP/xyOUrIOWxkWmJTbW8y/U1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

HMM pagewalk has now the machinery to do the first phase of
device page migration, collecting the pfns and installing
migration ptes.

Enable migration in hmm_range_fault(), and change migrate_vma_setup()
to use HMM pagewalk path. Two new flags, MIGRATE_VMA_FAULT and
MIGRATE_VMA_WRITE are introduced for migrate_vma_setup(),
to request for faulting missing pages, and requesting write
access.

Also, the migrate_vma_collect*() based paths are now unused,
so delete them.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 include/linux/migrate.h |  10 +-
 mm/hmm.c                |  33 ++-
 mm/migrate_device.c     | 562 ++++------------------------------------
 3 files changed, 83 insertions(+), 522 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 01c5f62a56e9..c73e41625ac2 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -180,6 +180,8 @@ enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
 	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
+	MIGRATE_VMA_FAULT = 1 << 4,
+	MIGRATE_VMA_WRITE = 1 << 5,
 };
 
 struct migrate_vma {
@@ -217,10 +219,14 @@ struct migrate_vma {
 	struct page		*fault_page;
 };
 
-// TODO: enable migration
 static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
 {
-	return 0;
+	enum migrate_vma_info minfo;
+
+	minfo = (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
+		range->migrate->flags : 0;
+
+	return minfo;
 }
 
 #ifdef CONFIG_MMU_NOTIFIER
diff --git a/mm/hmm.c b/mm/hmm.c
index e64444cbc62a..87ebd2500df6 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -1562,14 +1562,43 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
  *		the invalidation to finish.
  * -EFAULT:     A page was requested to be valid and could not be made valid
  *              ie it has no backing VMA or it is illegal to access
+ * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
+ *              is too low.
  *
  * This is similar to get_user_pages(), except that it can read the page tables
  * without mutating them (ie causing faults).
  *
  * The mmap lock must be held by the caller and will remain held on return.
  * New users should prefer hmm_range_fault_unlocked_timeout() unless they
- * specifically need to keep the mmap lock held across the call. This helper
- * cannot support VMAs whose fault handlers need to drop the mmap lock.
+ * specifically need to keep the mmap lock held across the call like while
+ * migrating. This helper cannot support VMAs whose fault handlers need to
+ * drop the mmap lock.
+ *
+ * If want to do migration after faulting, call hmm_range_fault() with
+ * range.default_flags of HMM_PFN_REQ_MIGRATE, and optionally
+ * HMM_PFN_REQ_FAULT|HMM_PFN_REQ_WRITE, and initialize range->migrate field.
+ * range->migrate->vma will be populated during the call,
+ * and must be stable across the whole migrate process, which is
+ * why mmap_lock must be held around this call.
+ *
+ * When HMM_PFN_REQ_MIGRATE is set, migration collection may be partial on
+ * return and the caller takes responsibility for completing or aborting it.
+ *
+ * On success, the caller must call migrate_hmm_range_setup() and may then
+ * proceed with the normal migrate_vma sequence: prepare destination pages,
+ * call migrate_vma_pages(), update device mappings as needed, and finally
+ * call migrate_vma_finalize().
+ *
+ * On -EBUSY, the caller may retry hmm_range_fault() using the same range and
+ * PFN array without undoing entries collected by the previous attempt. If
+ * the caller stops retrying, it must abort the partial migration.
+ *
+ * On any other error, or when abandoning a retry, the caller must call
+ * migrate_hmm_range_setup(), migrate_vma_pages() with no valid destination
+ * entries, and migrate_vma_finalize() to abort the partial migration.
+ *
+ * The mmap read lock must remain held until the migration has either been
+ * completed or aborted.
  */
 int hmm_range_fault(struct hmm_range *range)
 {
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 43e571e82cca..1e1a592e1267 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -18,519 +18,6 @@
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
- * If @folio is not the folio containing @fault_page, the caller must hold a
- * reference on @folio. The helper consumes that reference.
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
-	if (folio != fault_folio)
-		folio_lock(folio);
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
-		if (!softleaf_is_device_private(entry) ||
-		    !(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_skip(start, end, walk);
-		}
-
-		folio = softleaf_to_folio(entry);
-		if (folio->pgmap->owner != migrate->pgmap_owner) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_skip(start, end, walk);
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
-				/* migrate_vma_split_folio() consumes this reference */
-				if (folio != fault_folio)
-					folio_get(folio);
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
-				/* migrate_vma_split_folio() consumes this reference */
-				if (folio != fault_folio)
-					folio_get(folio);
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
-			if (pte_present(pte))
-				flush_cache_page(vma, addr, pte_pfn(pte));
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
-			if (pte_present(pte) && pte_dirty(pte))
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
-				if (pte_uffd(pte))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pte))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd(pte))
-					swp_pte = pte_swp_mkuffd(swp_pte);
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
-	walk_page_range_vma(migrate->vma, migrate->start, migrate->end,
-			&migrate_vma_walk_ops, migrate);
-
-	mmu_notifier_invalidate_range_end(&range);
-	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
-}
-
 /*
  * migrate_vma_check_page() - check if page is pinned or not
  * @page: struct page to check
@@ -677,8 +164,9 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  * migrate_vma_setup() - prepare to migrate a range of memory
  * @args: contains the vma, start, and pfns arrays for the migration
  *
- * Returns: negative errno on failures, 0 when 0 or more pages were migrated
- * without an error.
+ * Returns: -EINVAL on invalid arguments, 0 otherwise. A 0 return does not
+ * imply anything was collected; on return @args->cpages holds the number of
+ * pages prepared for migration (possibly 0). See the note on faulting below.
  *
  * Prepare to migrate a range of memory virtual address range by collecting all
  * the pages backing each virtual address in the range, saving them inside the
@@ -688,6 +176,20 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  * corresponding src array entry.  Then restores any pages that are pinned, by
  * remapping and unlocking those pages.
  *
+ * By default migrate_vma_setup() is best-effort: virtual addresses that cannot
+ * be collected are left with an empty src[] entry and the rest of the range
+ * still proceeds.
+ *
+ * The optional flags MIGRATE_VMA_FAULT and MIGRATE_VMA_WRITE in @args->flags
+ * additionally fault in missing pages before collecting them, for read and for
+ * write respectively. Unlike the best-effort default, if such a fault cannot be
+ * satisfied the whole range is aborted: the partial collection is rolled back,
+ * @args->src is cleared, @args->cpages and @args->npages are reset to 0,
+ * and migrate_vma_setup() still returns 0. The fault error is therefore not
+ * observable through this interface. Callers that need to act on fault failures
+ * should instead drive the migration directly via hmm_range_fault() followed by
+ * migrate_hmm_range_setup(), which preserves the error code.
+ *
  * The caller should then allocate destination memory and copy source memory to
  * it for all those entries (ie with MIGRATE_PFN_VALID and MIGRATE_PFN_MIGRATE
  * flag set).  Once these are allocated and copied, the caller must update each
@@ -739,10 +241,20 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	int ret;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
+	struct hmm_range range = {
+		.notifier = NULL,
+		.hmm_pfns = args->src,
+		.dev_private_owner = args->pgmap_owner,
+		.migrate = args,
+		.default_flags = HMM_PFN_REQ_MIGRATE
+	};
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
+	range.start = args->start;
+	range.end = args->end;
 	if (!args->vma || is_vm_hugetlb_page(args->vma) ||
 	    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
 		return -EINVAL;
@@ -764,10 +276,24 @@ int migrate_vma_setup(struct migrate_vma *args)
 	args->cpages = 0;
 	args->npages = 0;
 
-	migrate_vma_collect(args);
+	if (args->flags & MIGRATE_VMA_FAULT)
+		range.default_flags |= HMM_PFN_REQ_FAULT;
 
-	if (args->cpages)
-		migrate_vma_unmap(args);
+	if (args->flags & MIGRATE_VMA_WRITE)
+		range.default_flags |= HMM_PFN_REQ_FAULT | HMM_PFN_REQ_WRITE;
+
+	ret = hmm_range_fault(&range);
+
+	migrate_hmm_range_setup(&range);
+
+	/* Remove migration PTEs */
+	if (ret) {
+		migrate_vma_pages(args);
+		migrate_vma_finalize(args);
+		memset(args->src, 0, sizeof(*args->src) * nr_pages);
+		args->cpages = 0;
+		args->npages = 0;
+	}
 
 	/*
 	 * At this point pages are locked and unmapped, and thus they have
-- 
2.55.0


