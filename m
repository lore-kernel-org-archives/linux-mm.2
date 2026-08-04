Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C23C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A3F6B009D; Tue,  4 Aug 2026 00:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B720D6B00A0; Tue,  4 Aug 2026 00:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60376B00A3; Tue,  4 Aug 2026 00:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 739126B009D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:27:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E11941408EB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:09 +0000 (UTC)
X-FDA: 85062302178.27.17A1F29
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id A6B531C000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WIa9IyqH;
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bp/HOa9o+BFxZP9Tl5+LymilN/hYIUdOgGYp2AmAGQw=;
	b=Clc3clzOutsi0gJPR+32vwgaoS74FcadZTWhk9H01CwoS55MZSPFNzYZ1T0emcjH2S+IsW
	IMmrLPSsGcu3cBJerhZwpNuOXCOdFqU8JsMaVWPZub74LdIKztSkpnLsOav16wE/joiYkP
	Utsk6/uQkSX5Bof8DnbgSECH6QpUrmk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WIa9IyqH;
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817627;
	b=FA5yktHo3H16pa7FbhCWWYSgHosduMLGZxKg80c5kmHVLoNjVlz7TkHGdlfipjKmQjo/KD
	JgEJXaW//+jeBpqMMQ5+7wopL4xME996lpY5wgotiDc2EFuIKeLPPNIIlI3KihNDFt6tmM
	59zwuX3Xvmp8JwFAW9om517XSV862BA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bp/HOa9o+BFxZP9Tl5+LymilN/hYIUdOgGYp2AmAGQw=;
	b=WIa9IyqHnitOSikrNKlgrQ06Ws4jvoYl7IAXA+L4vLVf6YjU67CIANS69VoXo2XnAudcIW
	1oY2c2U2NZKPea6HbgZ2JiF6c0pKNin5Ect+MX5tbjGfvfDuNGM6hwBGO0MqasaKQyYEyk
	xgI5BpiadK0zQjHE/9/xDNWHDW33NaQ=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-gUO93EFMMNChw_fHhap-jw-1; Tue, 04 Aug 2026 00:27:06 -0400
X-MC-Unique: gUO93EFMMNChw_fHhap-jw-1
X-Mimecast-MFC-AGG-ID: gUO93EFMMNChw_fHhap-jw_1785817624
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5aec6240ddbso2424967e87.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817624; x=1786422424;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bp/HOa9o+BFxZP9Tl5+LymilN/hYIUdOgGYp2AmAGQw=;
        b=B6HnHb6Z6cCkbjPx+ENjtd8o/A5x8LEXNLp+VcNIdbXo2ElLzNmdeOBPrhv7OcMQ92
         u+wdzEmwpF4BZvN8ixW9aHQzSne62IzJWTsoARLQK6oRT8ce91hJBV+EKtqQ/RuLQrtW
         3thSKssVEvjiRSSB832KuBGHJVHkcwA5Ey+2GE0+QCUcVzKz1nZ8vwai+EfPPtxBNCma
         nMkIhKTpHQyNTbTxjCteZVTwrxgaRdKN/sccezUCdIA9T/WrJ+NYI7PsjgL5QmVctGHD
         gaX+pgTML1Tk8X0mf735gPtZUZYKDjFWJ/TBLKYNDlBvw5n8cj1T9F4fKiJ53SomxOdE
         1jVA==
X-Gm-Message-State: AOJu0YzUd0DFzKg2HLod6DAIzgAGjk7Ndn+09RZJSJitaaxKrxFBimXj
	vFii7uGPbHnQ92EidE+XlrlFvP3D/hQnAsi++Xrtg90cZGaueeCuivf0Tvp9X1yb8MLs+WzE5Ve
	FZCuSiLpAYyTD/yChLwXeSswS0LvmZcNaD6arlnXehjIJ0TO+rG9C8RT7aGzCIwo+EG88CXkVE0
	ib/Q6GOHb7ZHu+8pnfrXZbra/Z6gM4jYOT/6nqLQ==
X-Gm-Gg: AR+sD10/ohUfnxs2KiFdswuv5DjbXcEodrjUSMWZVKTrEWFcL6jR8YD2U7W83ZKpinN
	MMQublw8oDVxrIjJie83Jcx6jyF2UdehBnbcChN+qVRaxKxrLpNMbZfpRcXLQGCyd8n1AqwRjyU
	QhEh6lRnBE69PpJeWcHBL4NcEtJ8KCayRGACZgmTIE+4v8Dvky4gJnCdfODYeCDtluGvp/NZ9fn
	CyRylBLETqhpwqSsxWcioP8BPL2Fp3Dpg07W8l+ECFI6sOJEaKD6zDwN/tD45+quzgcYasV9z7J
	TKGWg2BaH1KxMHTcyBT49Q007CpEuTOsEsPM3/O1MGzcUJWOHVfzXjFtC9EN1Lb72XHc0BEbIl8
	m75G9afgpq3AkeqTD
X-Received: by 2002:a05:6512:63cb:b0:5b2:b85d:4802 with SMTP id 2adb3069b0e04-5b2e4f19bb8mr1748258e87.4.1785817624440;
        Mon, 03 Aug 2026 21:27:04 -0700 (PDT)
X-Received: by 2002:a05:6512:63cb:b0:5b2:b85d:4802 with SMTP id 2adb3069b0e04-5b2e4f19bb8mr1748235e87.4.1785817623922;
        Mon, 03 Aug 2026 21:27:03 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:27:00 -0700 (PDT)
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
Subject: [PATCH v13 03/11] mm/hmm: preparations for HMM to participate in migration
Date: Tue,  4 Aug 2026 07:26:23 +0300
Message-ID: <20260804042631.2175585-4-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804042631.2175585-1-mpenttil@redhat.com>
References: <20260804042631.2175585-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o_R_JBoIgy1nkf9TkvWaUWILe2RnXjPV_6hy5xPjgow_1785817624
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A6B531C000E
X-Stat-Signature: jks4hhoatehspxqi67r37fe46brugdnx
X-HE-Tag: 1785817627-28726
X-HE-Meta: U2FsdGVkX1+m+COT58YGfv2nhSLa98P6lq4uAmVuAHITjq/2UZtgLevCZRzoU2gueOEyIs0heXk/cw34iapnZrSmQpFtW5/uSdxCe54leP3gpyGv3dLMZ2mmGD1+aZUnFN6mVC9IDlMor+Qy2GGiB7Q4VS47OgJ/WzON6PUyhUjk229etaW6YaNkinuIJBoHbkiLQjBPpZzNZQlm066jBPDC63bA+dBz4pUz/Os7usZwU3cd79Iymb2SxqIUoE+59IVFVZbT7JqlDLPEomsWda2WYvo8ktDCJlZ6BubwAVkOPZYNxu+uQflmvKyX+EujT1rIB34mypJHQZDJanlnT/U+P7fd1k38K/W4RQhRZRX0WB3JnZ2e3a4hlYsJYZb49OHxQhGitiEUGBO8iHyG0BPLRZj2XDTQ9i/XntFxKdSJGrW02GmhuLvE9SKWhkUWQBz7RI6fhvChe3h36nmMUQ1CwIX07N5IVQpTvpWFA4XKGtT/NMOFL0ZIvAtqIaHrbwG8RHA5fX46kC/nKqzQ7Jz/8RYmOvUwy3GnPhgOCJsI3pghHBYjz7U/z/KMrL3PTBVRQzuWkeb5B5aDc9dm/ueB8URtDmDNvTWOEq3Q80Ua6ByX3dcg0NnoUFQyDwxx+73DkzP8ddN+m1loZvYMPjk1pROlynyyq8BUMq+C0NnBLCHNRaY9QRwvB5nNUILljUBybLuBaMayvgaaRtFG4bfO+ms/Qpupu9gWRirHjNTCgPjsbaL63Y2cbBsfpSPMV8gYGq+u1CRialpRdlORYgK35faitUHTPBxs21sz3CX6LZRVNvb62gCE7BvD/WQnyEoapGffhfPhn4TIDTBSPGcymdq7ZzfWbVAd5zI/f0YGwiMnCsO48x17szUx0bZY4u7w9TFOpcx6Vu7rGfcvSx9Vusq0STkQfTB+fQwlMmqgN9a+V5Rx+YmP/a3ZjT47QeYu+MnRFqCIYnYdzog
 kjHWEc2b
 2G2vWV7xpp0KeOdbrbA8mWhqNJNYaKTPZ1C4t+P9gLmwhe3i5bUdUw7QTAiZOYVnrQPUsfR9QI2fqv84S6jwH6jC8cn9gvldZxN76YR8324zBoDap6mQGk3Chf2uRzHH+Yh8zDqkAz5fJmzWb0lwIzND7mrnIPXF6pnO1wd8BhsIGBb4BiNm4VdqV+qJXsI6EhNopWmPY+Is5sLOhu0iaG4osmS3Gsq7CYkPdo1Zj8AP0hi/NZFupwGTPoXcef7DBax7rVyYdGxKlttKbDXatgEH5/Hs9e+9H46WtYwOfvS3oRcG+lK45Obgy61pdrToN1D3Hb7Wx9/51z0TW4e0qPZtf3K89Ctlv1MRsl/+Kctg501hOcjPmkRhSNsJRzkPeY+4uQNoyepEwUFinCZgK94GMkfmY5+y+v4xGs6+hwbneyXd1bFDjRUuzA3Oiil1wwkHJ6fTfJBFO6NRgfBQcT3DVPhLbMo+KjtocDj3pXqX2GvHcxqLGGUlu1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

For migration to happen after hmm_range_fault(), the vma has to
retrieved. Luckily, pagewalk already resolves that for us, so
just have to save it for further use. For migration, mmap_lock
has to be hold for the whole operation, so vma stays stable.

Take care also of firing the mmu_notifier when migrating.

Also, prepare for differencies of how mm_struct * is retrieved
in fault and migrate_vma paths.

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
 include/linux/migrate.h | 45 ++++++++++++++++++++-
 lib/test_hmm.c          |  2 +-
 mm/hmm.c                | 86 ++++++++++++++++++++++++++++++++++++++---
 3 files changed, 125 insertions(+), 8 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 425ab5242da0..7380a89756ee 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -106,6 +106,28 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
 	spin_unlock(ptl);
 }
 
+enum migrate_vma_info {
+	MIGRATE_VMA_SELECT_NONE = 0,
+	MIGRATE_VMA_SELECT_COMPOUND = MIGRATE_VMA_SELECT_NONE,
+};
+
+static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
+{
+	return MIGRATE_VMA_SELECT_NONE;
+}
+
+static inline void hmm_fill_migrate_vma(struct hmm_range *range,
+					struct vm_area_struct *vma,
+					unsigned long start,
+					unsigned long end)
+{
+}
+
+static inline struct mm_struct *hmm_range_fault_mm(struct hmm_range *range)
+{
+	return range->notifier->mm;
+}
+
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -149,7 +171,7 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
 }
 
-enum migrate_vma_direction {
+enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
@@ -191,6 +213,27 @@ struct migrate_vma {
 	struct page		*fault_page;
 };
 
+// TODO: enable migration
+static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
+{
+	return 0;
+}
+
+static inline struct mm_struct *hmm_range_fault_mm(struct hmm_range *range)
+{
+	return range->notifier ? range->notifier->mm : range->migrate->vma->vm_mm;
+}
+
+static inline void hmm_fill_migrate_vma(struct hmm_range *range,
+					struct vm_area_struct *vma,
+					unsigned long start,
+					unsigned long end)
+{
+	range->migrate->vma   = vma;
+	range->migrate->start = start;
+	range->migrate->end   = end;
+}
+
 int migrate_vma_setup(struct migrate_vma *args);
 void migrate_vma_pages(struct migrate_vma *migrate);
 void migrate_vma_finalize(struct migrate_vma *migrate);
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index c4adbf98fac7..79cb7487d211 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -145,7 +145,7 @@ static bool dmirror_is_private_zone(struct dmirror_device *mdevice)
 		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE);
 }
 
-static enum migrate_vma_direction
+static enum migrate_vma_info
 dmirror_select_device(struct dmirror *dmirror)
 {
 	return (dmirror->mdevice->zone_device_type ==
diff --git a/mm/hmm.c b/mm/hmm.c
index c72c9ddfdb2f..637c00188b3e 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -20,6 +20,7 @@
 #include <linux/pagemap.h>
 #include <linux/leafops.h>
 #include <linux/hugetlb.h>
+#include <linux/migrate.h>
 #include <linux/memremap.h>
 #include <linux/sched/mm.h>
 #include <linux/jump_label.h>
@@ -27,12 +28,17 @@
 #include <linux/pci-p2pdma.h>
 #include <linux/mmu_notifier.h>
 #include <linux/memory_hotplug.h>
+#include <asm/tlbflush.h>
 
 #include "internal.h"
 
 struct hmm_vma_walk {
-	struct hmm_range	*range;
-	unsigned long		last;
+	struct mmu_notifier_range	mmu_range;
+	struct vm_area_struct		*vma;
+	struct hmm_range		*range;
+	unsigned long			start;
+	unsigned long			end;
+	unsigned long			last;
 };
 
 enum {
@@ -393,6 +399,57 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 }
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
+static int hmm_vma_capture_migrate_range(unsigned long start,
+					 unsigned long end,
+					 struct mm_walk *walk)
+{
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+
+	if (!hmm_select_migrate(range))
+		return 0;
+
+	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
+		return -ERANGE;
+
+	hmm_vma_walk->vma = walk->vma;
+	hmm_vma_walk->start = start;
+	hmm_vma_walk->end = end;
+
+	if (end - start > range->end - range->start)
+		return -ERANGE;
+
+	if (!hmm_vma_walk->mmu_range.owner) {
+		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
+					      walk->vma->vm_mm, start, end,
+					      range->dev_private_owner);
+		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
+	}
+
+	return 0;
+}
+
+static void hmm_vma_post_range_fault(struct hmm_vma_walk *hmm_vma_walk)
+{
+
+	struct hmm_range *range = hmm_vma_walk->range;
+
+	if (hmm_select_migrate(range) &&
+	    hmm_vma_walk->mmu_range.owner) {
+		/*
+		 *  The migrate_vma path has the following initialized,
+		 *  so take care of fault path below.
+		 */
+		if (range->notifier) {
+			hmm_fill_migrate_vma(range,
+					     hmm_vma_walk->vma,
+					     hmm_vma_walk->start,
+					     hmm_vma_walk->end);
+		}
+		mmu_notifier_invalidate_range_end(&hmm_vma_walk->mmu_range);
+	}
+}
+
 static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			    unsigned long start,
 			    unsigned long end,
@@ -600,6 +657,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
+	int r;
+
+	r = hmm_vma_capture_migrate_range(start, end, walk);
+	if (r)
+		return r;
 
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
 	    vma->vm_flags & VM_READ)
@@ -662,16 +724,25 @@ int hmm_range_fault(struct hmm_range *range)
 		.range = range,
 		.last = range->start,
 	};
-	struct mm_struct *mm = range->notifier->mm;
+	/*
+	 *  Could be serving a device fault or come from migrate
+	 *  entry point. For the former we have not resolved the vma
+	 *  yet, and the latter we don't have a notifier (but have a vma).
+	 *
+	 */
+	struct mm_struct *mm = hmm_range_fault_mm(range);
 	int ret;
 
 	mmap_assert_locked(mm);
 
 	do {
 		/* If range is no longer valid force retry. */
-		if (mmu_interval_check_retry(range->notifier,
-					     range->notifier_seq))
-			return -EBUSY;
+		if (range->notifier && mmu_interval_check_retry(range->notifier,
+								range->notifier_seq)) {
+			ret = -EBUSY;
+			break;
+		}
+
 		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
 				      &hmm_walk_ops, &hmm_vma_walk);
 		/*
@@ -681,6 +752,9 @@ int hmm_range_fault(struct hmm_range *range)
 		 * output, and all >= are still at their input values.
 		 */
 	} while (ret == -EBUSY);
+
+	hmm_vma_post_range_fault(&hmm_vma_walk);
+
 	return ret;
 }
 EXPORT_SYMBOL(hmm_range_fault);
-- 
2.55.0


