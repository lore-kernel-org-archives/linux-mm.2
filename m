Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE0AC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E73A6B00D4; Tue,  4 Aug 2026 00:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61B6E6B00D5; Tue,  4 Aug 2026 00:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC506B00D6; Tue,  4 Aug 2026 00:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16FD36B00D4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:27:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86364408CB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:44 +0000 (UTC)
X-FDA: 85062303648.13.786766E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4E20740004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g+bvtfnr;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817662;
	b=Gl8PyzXVL39dFoIynfducM0WqC8QWJkQZuAudG11zSHXjTLtAIFrEzDekoFtCCg3R9cn86
	NspC810hBcVE4LN7uz2vN1o2jZL6A9ZHscKBwQGTMBDeDpaGo9vPOuage+VhXLbc0298B6
	2u7oIJzLR+FXCx1wRDM/dLW6cMS859U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g+bvtfnr;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpEIqxoBbLX0SvQdg20oXD/NXhm9ONjr2trVRywE48w=;
	b=INjb2VyL+TcQaR8JtektWI7HZ5zUKt0g+Hl5MEfK85K3giw1UeIY01HZbfj8OcbRlbv7yy
	IqR57JmZnW8o6gqNuA0cpTkSLTXNyyZ46QhpowEMRa7iMT1IyySNXRoka44v3mB+L9+IwH
	ojxkI+y+9h4MTsDWkSX8sGv5EXwOwwM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tpEIqxoBbLX0SvQdg20oXD/NXhm9ONjr2trVRywE48w=;
	b=g+bvtfnrnu2MdCpM/WtizehZ1s8LvBjolPYXaQj2Oj9kWs9MpbFZde8gpyDl3YNLMDEGCo
	4mwS/NNxLeo6dez+YaI/8DlZ5QClrG6dJjj9rswAieG2AdoPtpytZ3uj47uWW64szswq0J
	T2kKUdDDyneZQV0HII+TndlSJ0MMw4c=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-Vy1UxGfTOvWn_PT_qnCnXQ-1; Tue, 04 Aug 2026 00:27:40 -0400
X-MC-Unique: Vy1UxGfTOvWn_PT_qnCnXQ-1
X-Mimecast-MFC-AGG-ID: Vy1UxGfTOvWn_PT_qnCnXQ_1785817659
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5aeb55ce6adso2442647e87.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817659; x=1786422459;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tpEIqxoBbLX0SvQdg20oXD/NXhm9ONjr2trVRywE48w=;
        b=I+XmYdK0qBL586VMaecrm0K6suMcwg/2dvax4VWr+JI7UsKpUGVR4nOIuHHGnbYcr+
         aPEXHNbzqELStHXgaf3dquQ/p6CkxfTWkVRJIo2nkJntHOq/lNgXcdD3gxBRCWhvprzn
         yRZNPs+Q9299D7yn88r65me87KJdwn8Scj4GB6Q/9qFlAhTeEka15LgCXo6c3K9slIOo
         V2tSgrTlFV4gyVpQeRS06JNsvPSfQOdAn2/14dGgBAaZ1hrkHrQEAGv/5Tn4aq903iQW
         1eZAcWjJeVShFop3DdOHoJA0xBvMC1Avsj9+Es3V+usRFREKCYEeM9mtP0v6IRDJVyYA
         au/w==
X-Gm-Message-State: AOJu0Yw/f7E3nXBnK95X5iVSkgDcVR5NCoaPSPsSmeTRpaiYGsdzzuam
	Nv5VP0Kf55SvYmFZfrMZ3yMTFBGt7bYE8mIDmK+6ioWtoKi1gSz5iNLNedZobfP61g5b0Qat5k2
	vs+NOjsOU2rpGx6kYasCC9CsGswC6ilN2Rs1K3T7Muzr1nfzNMd/J55yzoQtbIAYfezZzeJwA6M
	hilzdK66KaYZNocpXj0a9Td+8Z55qrM83OPOuesQ==
X-Gm-Gg: AR+sD11Cb6bc1BF0kucWzkQMGQgWY7DCsEdXvMSQZd5JQlTaUg2I1mYg5JnqdCucw+d
	X21umK3RXXno+/vxUdQYT3eHoRxBegjp+9vzN3vvqoRKyGxKQsuyyz04M6z8m5be8Y1jpmM9k4i
	0RIO9uS1xrA28HoUDKTn9ZNfooQ1r6WJJ4KOXashX3N9L7Lz95eUSSpZ1BKbKf75xqkXmO0uCgL
	cNKzWRe/ehlvOYRBSH5L5sOjT3KaBAo1FcIAR8xTsI7MrkVkcKObKVL9oPcynVYNNXsFq43ouMB
	/9VlbVj+B48b+Z/9CyZiDv6LJIpcOfU0nurDpuubUX0IKp/FbBIXpr3EujYipJSA7OFbW4GtqWe
	JNgYtnDG/BiBG7OyJ
X-Received: by 2002:a05:6512:6694:20b0:5b2:a6eb:ff2f with SMTP id 2adb3069b0e04-5b2e4f7bdf2mr1488650e87.43.1785817658651;
        Mon, 03 Aug 2026 21:27:38 -0700 (PDT)
X-Received: by 2002:a05:6512:6694:20b0:5b2:a6eb:ff2f with SMTP id 2adb3069b0e04-5b2e4f7bdf2mr1488627e87.43.1785817657987;
        Mon, 03 Aug 2026 21:27:37 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:27:33 -0700 (PDT)
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
Subject: [PATCH v13 10/11] mm: enable device page migration from HMM pagewalk
Date: Tue,  4 Aug 2026 07:26:30 +0300
Message-ID: <20260804042631.2175585-11-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804042631.2175585-1-mpenttil@redhat.com>
References: <20260804042631.2175585-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zRyNE3ASN1Rf6DCJrGgtAn14Eh-p_bfpMr1_EZAtCUA_1785817659
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 47tumf7ntu1ah1w8zujfdwdbet1jg3zq
X-Rspamd-Queue-Id: 4E20740004
X-Rspamd-Server: rspam08
X-HE-Tag: 1785817662-81728
X-HE-Meta: U2FsdGVkX190gyB4rvfJQyyFWtbKhTXVfUy7hrSkQd86T8t8xNwK5PEZiS1/gTafRky8cD6eNvnv4xgFocc0kjcfxOU7ADYAh8HkBtB9IoW7q/NHqueYcM0jhDY2ZRRvMgTuabJhyNm2y9Uo+bL9uYsJADK3ST04jBksA9t/4MYwNx8yG3tIN/3pNpRfsmieb14qW0E7eLpCe1ffCwPUYbqRpUSbaYA0K/+eQ54mkezjokAvG6kOm4CrxqutPsI/b6yHh5npPaAVqZRORNh+KUJL4v230g6gCSC35bvN6jPrdWeqi11RX4XYkXtsm1P8roHeLnix6TonzG52Ku5cbDOrchfQ/F8pg6hkJ2yZQyNDy35fThQHyZBcxZ+6MG+R5CItJdH8udm4tuK6lecG57axkfxYcfvy0+Pv/LBQvEl8Fno04xa9jjMKCbOwwcogaj0tBLQYTXcMcLlAknhlpARoCC2jEsF/Z3glAkvE9DRd8niCwpNp/bGRBCbcto/oXM7rj6P9FSVmfkyOp7CAgWI4/ZOuNo3yMFBzY5jFFITNM3i0cTBfMPOubirmrr7AxUj+XeRl6pj9jKnMTGQEY/U7iiSR4+nnJfzsN0oDPRh6xIR+I+ZfmdgyFDCnzP1L9umpBhgbBUMJ7aBuci6s3B6WfcdPlZnwOAONFchXrPGew/ieuJV0K69btfZkxPgXzo+mSZFWvtrXZ9CzI5ImZlqlelkP+8sCx2n0Mtj77/w15grf4iVPhsfSvth0we6S+BD/0LuRED9CQDOZaVQyRALMeVQu8SLn+d2tL/1thy1ZT6mpMWqV5h6XS1OS6KHF/KGdx5M0JlbNSRNkea0rok6YDVzIp0AdzvIOSNHUM4TrMZgi0n1F7aiBaXGKhL8065fDWTkXQFZXNSTGzLbaWMrcE4MBfCAOu4uHqgLXI82H8nsCEpewEgl28lIYBh3Bbviez/ZutGBc4+mC4qB
 XJdhZxB9
 8yQMwfNSdu7xWo9HUuaXi3Mw5P2YPng/c9bFPB28bs4CDz8zv3qU4S3t4IL0KNXSA7+/uuylcdSDcjlYboG9A9nh+7Yt1aC+598rwMO2YKcbYMYX6gFOaxAiPBTo08LifP2S9WG95pbHbdFLmF3CRYltemCZX17zuLUtS33r5e75Etmdh1WSZM2TObTb57EEUS+2Siv+XFwhBWovDEIHm3K0A4WeZClYu9Dd4a0G53f7bTBVpIsZNmlAXQs6soupl31ES4eyfmZN2khpPvIpMxO20WHiLMsBS4vLs7GGyRFzf7r5f60gtJNSGc0I8V35l+UiUfztn30Y7I/vykTyKEmcK8kNOAQUFIhq/8HEiprMQTpLxRHFsWiejHIoURtpAEe4jCUIpfmNmM8Y2eCCCpMs0r2aqJybJ/Fr0N7xegr81vp8Xhd5GI0BZX5eH1r981al6nHOox3ulos4nQIp47KuiyP9U5n9Yt7gCjCOPoI30iM4MigK0NHTWRw==
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
 mm/hmm.c                |  28 +++
 mm/migrate_device.c     | 533 ++--------------------------------------
 3 files changed, 63 insertions(+), 508 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 7380a89756ee..2b137e6a56d0 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -176,6 +176,8 @@ enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
 	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
+	MIGRATE_VMA_FAULT = 1 << 4,
+	MIGRATE_VMA_WRITE = 1 << 5,
 };
 
 struct migrate_vma {
@@ -213,10 +215,14 @@ struct migrate_vma {
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
 
 static inline struct mm_struct *hmm_range_fault_mm(struct hmm_range *range)
diff --git a/mm/hmm.c b/mm/hmm.c
index 03622455302a..53df67bbd87e 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -1448,9 +1448,37 @@ static const struct mm_walk_ops hmm_walk_ops = {
  *		the invalidation to finish.
  * -EFAULT:     A page was requested to be valid and could not be made valid
  *              ie it has no backing VMA or it is illegal to access
+ * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
+ *              is too low.
  *
  * This is similar to get_user_pages(), except that it can read the page tables
  * without mutating them (ie causing faults).
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
index a6df6566f89e..3d021b2e81f0 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -18,509 +18,6 @@
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
@@ -729,10 +226,20 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
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
@@ -754,10 +261,24 @@ int migrate_vma_setup(struct migrate_vma *args)
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


