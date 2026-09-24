Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E071CC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36CE96B00A4; Thu, 24 Sep 2026 02:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E2A6B00A5; Thu, 24 Sep 2026 02:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE5D6B00A6; Thu, 24 Sep 2026 02:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCC486B00A4
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:54:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64E2AA5BC0
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:54:11 +0000 (UTC)
X-FDA: 85247741502.25.FA90238
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2F47920002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:54:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Di75hGSc;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sv/cs7ZJuFY+/3q9oQyGV7uOngHjsWLpUE1ceSZJPbM=;
	b=p3OzKIiH/5I5kx83FK6qwBVWo7b5CX+wB0FeMcTMIzX4Y7eUk0E3wfc9rx8SoggtcCoHkN
	Ausr7MIcOr7eVKU+dRbyywu7sVZsmjgsUz6JMOTZ5wtEdQueO4BcI0Xzu+oltqZlAxGNPR
	+EG58H7GcSV7DVDISqHop53/6omRDWE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Di75hGSc;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232849;
	b=SzFZVhecvyZaF7FoqSH/ZfFL9/F2ODLs2ZGY4dzJY0ALtqW3hAvN1eawW/oAaix6CP+ron
	u7I0mXom+ui/c2JzIpIhHsp2Ldl0srxoCXmPfeiQwTTb0vI0Ct5b92foNAn60Wsi6MITt6
	kBCSnFQj+LDCRkkB3TJUhQlpq++I2AM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sv/cs7ZJuFY+/3q9oQyGV7uOngHjsWLpUE1ceSZJPbM=;
	b=Di75hGSc1NWtDInMTqcTlP7gUVYItKCivW+x+w0ASzb37wPS8nCz8y7+8koKQXT8x29VDD
	1LE4fCCGhjTh8HpBufFK46twYyX5sJVZouscNV+wUq60p8ascJwFv4jtdtn23ub7+tLlCv
	+w5X1IwB2AC2ySgrEYJqHUkwvUK/C2M=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-S6v5rTT0MUWMNUpFPUNG2Q-1; Thu, 24 Sep 2026 02:54:06 -0400
X-MC-Unique: S6v5rTT0MUWMNUpFPUNG2Q-1
X-Mimecast-MFC-AGG-ID: S6v5rTT0MUWMNUpFPUNG2Q_1790232845
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3a3395e2d7cso8399111fa.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:54:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232845; x=1790837645;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sv/cs7ZJuFY+/3q9oQyGV7uOngHjsWLpUE1ceSZJPbM=;
        b=pOW7ONODbacNODuQaJSBgi71e+4ddDOs5xxvfB8zrf//0glAG6ecP7fTKAONnQjO5P
         xGB9qvOtVADqjdOeRfa2dzdhZ2z2zVWIidMq56CEnUhEa5f9EChXcg85OV+xuNDwR2zw
         M82YA11eh5KnqEh4P9Ygw7C7ulQfBwZb0De2Niq9oRHKDyf0QZG19vnG4Nr7oMER1Au+
         aNKOrW/748UXYZKOVf3n3hRwnfXxAUikrgEIdhtUeEY9VAzHZnOUfpFWAoNtu673f7i8
         Gxe8eyJFatb4KKCHf8OWBWe8B2OOfUg45bHKY89xtf/IC/Y4s+H5Z/cbMvuTBdIV9fRO
         xZ5g==
X-Gm-Message-State: AFuF++nECMyvLKXhVd8CqYArWVBqEoookb1vzB/pLqh6IAYQLxU54F1q
	MiQFNCsPMxo2iYsSKcWEkVQfL9CZSrcIoz1GsG1gd7RUT5kHJk5ItLbrzQC2p1+q+DFlHTAA0zO
	3GyYH+1q4ZN6VNjGOmfhkG7gsKKrEOGC1Bop4xZEwD+3hnscRpaGHYxK85vUBk64pW5HWbTUMCB
	M2muyLXZVclKluNtbvl1sUbevVJO/GdmJqCfkAhw==
X-Gm-Gg: AYBFou2vAL0lD8iSwp2HU1tEuN3Ez4VWpF8p5alwR2eEmuyS5PMJi7XD4veW+/5dFyr
	myxxIt6NcISp+u/NSEdZrY7cajiEI/TmXANPv1zdqWHfnIYH1pZbHLjYITrHzMWP+kCV7gGPHmE
	CcEvx7ZBG5/vFLLHOI3ICm7xJ3iPrfHH7Fohat4ULTJgt/FGIehOo3r5DcL60tndSdoyyPK1Cdc
	0LcboR8LtVQyF6CxG1nEWPw9W5hGYz9Vi85mUZ0Y1rXeCwppOon/tu2s6r1lYlQKh5RqYSj4OXe
	X8iF9rUgXmg2YyJlN246gUslbdzFAPTsY3bAn2kp9a7Tm7/NMUt8oYsrl+G682ux+30CHDgy6vP
	w7iEQfyE92OYkmtAAg+QS
X-Received: by 2002:a05:651c:31dc:b0:3a3:7682:49a8 with SMTP id 38308e7fff4ca-3a63c3030camr3549141fa.29.1790232844839;
        Wed, 23 Sep 2026 23:54:04 -0700 (PDT)
X-Received: by 2002:a05:651c:31dc:b0:3a3:7682:49a8 with SMTP id 38308e7fff4ca-3a63c3030camr3548831fa.29.1790232844285;
        Wed, 23 Sep 2026 23:54:04 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf57909sm4803141fa.29.2026.09.23.23.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:54:02 -0700 (PDT)
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
Subject: [PATCH v15 09/11] mm: enable device page migration from HMM pagewalk
Date: Thu, 24 Sep 2026 09:53:11 +0300
Message-ID: <20260924065313.899730-10-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924065313.899730-1-mpenttil@redhat.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: luCtU6Yp6y2uKgfQ74cC_FUoCbHvNvpRV06mplSRWaI_1790232845
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 83en81cpfhmqo1jn6t9os5635ug96j4e
X-Rspamd-Queue-Id: 2F47920002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790232848-588170
X-HE-Meta: U2FsdGVkX18FtiES2nEu6mVPBdm/KlqHcfFK3D1uNg5sHDzmNuHyccWb+xRNfDYHKco83oqt+RkD3KmLmMDypv4XSDf42idpw+nT9QoLo0Axo0L8lj40sxkCN5NB8pEkXHgagW3Vot1PmBnmzvPsJugQwnmk0febzdvuvZdkiLXs3XexPXGUNmfbM3PQqgvPtANX2ou+cOP46CLt/a8zoPgqdmawcsOD8YE0w+qyGdUBRKn1WPT9EFYJpLSWIRv2+xZ+dasPXiSMmO59LTEZwL0e4OMLF+selBsZn1HXxczD064h8KDpltME85D963jxpBoWzCFwMVcmraJxY2XvGnkwCNNNmaDcaTl4wM3c/CWKeQ4GFUvL0CsS12lreDseGG6ZdonlnrQtE1apVGLUFpSeBoj26jL8cIn9BV6L4dsJWcAuCrgPitKfa4c0HFnXUGcEigqlsIoyG8x8B2gGfvcKIfNk/7aF2XWMsHym3YFbymrzy+1h/HMijkDA8/ewtyvPctPXR9VkAp7HbimQn2oMJ91feBCy8g0uJ1U8oYUlJR7DbalQ2J60VAdFngoAnpBMrG8CZjGn46XkRR6yP8D81sKGwZ7eDwSA97xBF7lzw/xYmW6zmUtv8qBeUIJRsj1e0fltH9IPZsZ8ZQQqNKoU3Hk+d+9h9V3nlAWErgT0LAhsPrW/tKWILmtsIxAK5EuFz2YvWXO33Y4bLwNL33w8MWhO/y276yNZ3DQuWGBZ7+JA0Hio1t2Se2pqlqrVxfrx6yyi0pW92iM/bsgPVRUCyp0E26DxJzqt8Ph8C0gtvx+UJewAgJLIklUzPgN3nxv3SRt8yyPhk7OMHKY/b74n2jwzvLkqjvsUzH9C5Vxk6/kcIAhTgPcevo8gsYq669YbQ+EtUl1CMp8iSJjusVYFWVoL9eCl5kaEkhyZWvhj8HKno1t1tfHDOzrK6z9fU5oVrv6T7aBPKv5sTaZ
 JYV4Mc9u
 kWua0LolTswH3lMfg2Kkdu13jNVfQa5tRS2DFd79sp9wCQxtJ9KodU3wd5Eu0GS/bgVFQIH3v9PdCBqFBmY9xwOMHKADflWa4UG4+lKh+VvPSLbWbNZyFAtkRsOorvZ0NY7yxTpGmAr/tv05BjBln7XudwWSe/nGLZqxDbiW+PetsquWmNbnNbNjJBXXGcDJqMvD0HZ6T8A1c0WY6kjyP+mnyngZYMUudxxKSED1ipoNtCFNmZEfWTyudHU0iCn8PMu8HRv/AUS6pH2uzT9JHrod11kvBwOxJ5MRoBO2wggn2xj93iP153G3HqBrJYUjniAmEdZcFjlGJtWUiSSU3MZR36LwODVqz+vK3BSN1LUYgmLTL8i3l4GaN9aBn4bdCp52yvQ/n+d9epAK7ISKak/aS46v8cPjNAUQoXj4SMxnIDNwrTdcrx3d0JGC/tIxEnq3uE25eOEGlQ65fclAd1oRELdst4qn+Sefw8usgEgq2LvhBlS/1lrLqhg==
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
index daf83f809151..556ee63dd6d8 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -1539,14 +1539,43 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
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


