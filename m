Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70712F3028C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932386B00B1; Mon, 16 Mar 2026 02:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3456B00B4; Mon, 16 Mar 2026 02:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC776B00B5; Mon, 16 Mar 2026 02:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 571DA6B00B1
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:24:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27BE51A0CBD
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:40 +0000 (UTC)
X-FDA: 84550937520.13.E3C3007
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id E5EEF14000D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I7KhofaW;
	spf=pass (imf23.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jNgZiFL/8z6mVypv1MVTrHmDX0tNmtlCQ+pCeQcJaY=;
	b=HvuqNOTthg1H0b4IpVXoMpQKzt3L4NuCgZ4D/7cmRF3AjPMg2twgR0drJmEqPChwZAgl7r
	TwWxOuTXeHFZCK3NtKAt/5+NK40Q3hE4uRqaJfSpRjWmq967tgcY8AYZcW34awzQUpckaQ
	FmUXmXixMK9T10qGc8vhQsMSU3qIagk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I7KhofaW;
	spf=pass (imf23.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642278; a=rsa-sha256;
	cv=none;
	b=5pY/RQ1AtnNjR+UxGKVMCf9FTFPE5khQfvBnOD+VMyUoyjgcWgObg0d22184BNGSgrowps
	dxArStzKI3jUQmZF1npgujA8eXAnCZHsWh0T0W8jODjdoXOfi1GFnVff/ntUUXYb35uyx5
	+qpvTIgW9mFDSESg9JYDbxtbqc1HNUA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773642277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8jNgZiFL/8z6mVypv1MVTrHmDX0tNmtlCQ+pCeQcJaY=;
	b=I7KhofaW7HDRWf3yiSpnYtEVfCizu3HpWzGpbz3LvKqXTvVi0nOCqvLWeItxY0hY1/fuMP
	UyK4BbnsMhW+OFAeA+OuIsuuqztobO0JpADWeuJMqgDZ+YQYYSYs678vRTBo0lENITTsId
	4zuRr8a6+HMoMlTPeqmW2wlXfPO6RHA=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-Mp42xeVFNQerYVHdVOI9ag-1; Mon, 16 Mar 2026 02:24:35 -0400
X-MC-Unique: Mp42xeVFNQerYVHdVOI9ag-1
X-Mimecast-MFC-AGG-ID: Mp42xeVFNQerYVHdVOI9ag_1773642274
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a143864ad3so2783746e87.1
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773642274; x=1774247074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8jNgZiFL/8z6mVypv1MVTrHmDX0tNmtlCQ+pCeQcJaY=;
        b=E8WMmEmODHUACGNgUk81UT5RPcFb82LyiZnEQDPC3X5ZyzsLJ9yknTjsHUOoKSxttO
         86ItpTIu/25xfVS0iCIVTVjTaChk7s1hH4Ua2DwtxMGC9t5xTZco89G5Za80UhgQdNd0
         1XLt1uejKPE6XAFQ9pOAtWN/pgB6nkt/KZpIlQTKN3XHAtkcjKPmzBt1nWdGfzMVq0+1
         eDOhMm21cqlNikMKC/VFYpU8/U7t+lmGLDSPj9mk1jwYGdGVArf6Rc88kQ+Vl0l0nY9O
         iJDxfdyoJPYYIz4/oHiBbWKlabnEwnBq8iUDKU+Xk4uj3EKAR2pNEQPLwTxiv4vGw34p
         +xDA==
X-Gm-Message-State: AOJu0Yxs1aikaoO3bw9FdTTYgAKbIgTfnpP0xLMsLQH7Mcs/djmG8dl8
	fmqE+dsQCixV+/GDhu9JRjzm2tHR/zr9OXpy7sNsEv9Ox93ahCbDxE6o0T4GjyBp2s7lI3LspR/
	TXkTguyfElsx8Hp3/S4kXJWqp/4kpM2UYkDNsUj25tf1K0gkUCJyxVQetOcIDtaY0xxF8XbmJAS
	TWmQXePawx6dky7F6poyKx9vpiMg58bbSYxIMRng==
X-Gm-Gg: ATEYQzx1MVdp4TvINNb07hju5HRtpJqxh3cMAOCZe9dsFVv8fYVBIlQfN6jLxaKYhzu
	G0pd02xd8WwC9m97ThRQgvusMhmeSBPZEugfYuQxbmbLK3p+S4o94BwXjXoovAU9ejHMQ/SAT+D
	E7e8mvueD6uvvgzch7rOvQhhmpJ8A3dLqVTniOBJN7fkvte6a4tJ5xsjOPgzeWqBmnZK0c985+/
	1q5tJvBa/RYxKlc/bcOMmsckKIpXbbufAXlD+a1cmCWELQof/koOgxvC948hMxe2E8n3DMzmgIr
	inYLShyqQGYSwtK6DCHMEYoOYaxneBKEw0/mDPU21pQYu0LsBEv+lKpe/gbo7j6Kn91qnpXumJT
	LYWS4b8BJ273cO1niD6rJRwBqarBQebg1duBV
X-Received: by 2002:a05:6512:63d2:20b0:5a1:3d7f:8fbb with SMTP id 2adb3069b0e04-5a1627039e1mr2723921e87.2.1773642273824;
        Sun, 15 Mar 2026 23:24:33 -0700 (PDT)
X-Received: by 2002:a05:6512:63d2:20b0:5a1:3d7f:8fbb with SMTP id 2adb3069b0e04-5a1627039e1mr2723903e87.2.1773642273220;
        Sun, 15 Mar 2026 23:24:33 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15602e692sm3263397e87.30.2026.03.15.23.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 23:24:32 -0700 (PDT)
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
Subject: [PATCH v6 3/6] mm/hmm: do the plumbing for HMM to participate in migration
Date: Mon, 16 Mar 2026 08:24:04 +0200
Message-ID: <20260316062407.3354636-4-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260316062407.3354636-1-mpenttil@redhat.com>
References: <20260316062407.3354636-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WBE4Po24yA7VMaRtHm3H5l9h0Uh2AGR4NOwKfLMkjn4_1773642274
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E5EEF14000D
X-Rspamd-Server: rspam07
X-Stat-Signature: naa1t57bm33mi3xq9jemzcmi6tibupri
X-Rspam-User: 
X-HE-Tag: 1773642277-881986
X-HE-Meta: U2FsdGVkX1+fKt+vpXI9u5cX6kYH4ZG/JhVHp/QBbvtjq7n91XgZ8KjJ/hnKQokfzA5Zb4JW58YsSd2zUI4Ee70Auk5w7gAwpuJWhSfv6X4rN1zwRF9PumOt9XKuN3fOxkzaif4IhDX98lVY8TKS70qnoxmpKGwIg8nlmno0BVqVljJM1LPrWC1aDFKIo7cOPDEVxH13lfp98QC78cwhIWlZXN9MqEbvJbrVVDCRPU0/IjCeolzhPFWBHr/AZEBze+4D0yL1P1fmhCgwoACJtk96VNDClv+io45jT+zZcklD/5od+0/mC/45s2JdPoE9YpL2+X6jvERde1nauYlnoMf9NCi2k/xYed9Kv0XxecV2UtMaJU7aOysBjxXfZEFtXsU3yAAtpK6DEvDFE4tZLGKgd1WT+7uDm1eSK3jWb4LcUNJ3IqZFYyqVNW9IuD06MNS9uWqWiJvazRom5w9+ue+3AFgHZkv1PjvZaWZ4pZAGrr/5aHQJyDD23BscEeWGIcFF0BmnT6fPKUOwNuT7S/U/jo1R6K9b59J9XX7HMQoX0LuuohzNSRHctNRNXYNWCdswBqn86aN5oEqrjJSh0oJd/XhSyt6z99DWbsBR9X2Vq7XS89QzY1rZZe6YlyIYwB/SmQwSoef7Pk7i5urORD+bvFWnB1zzNmgMYzaJlEmrZ5ZShd50ulmfFl2ghemzf6TC3ZBvLbWL4RwDMGD+cwqscwBrPpeFDbXDIhquNL2x5AVvBNAaEenH0iDzUqoXyy99LPm2uvOmMZVJF/NmorJdxBwCrgrQKyY5rr8T0QJKfO3VGnGzP/7L4rRyhDxdONkt55gF46SZJ5EoQHZltlzLG2Deke9KQ7BWbnQLQY+39b+y6mlOKNPbFlseXP4jkdu3fkcwd1vuVW3hKnvZqznrbr42FU+D4S/6rLvhkDb/pfmjmrn8yCiLC7zgcej2o64NWn9mzMjyx2zLE+y
 cf0pvzPh
 2+2EO6pFkoLZ5SvH0cpm2N0Ek8feK6CkfkS4e36pQibprzheYcilhuLT97blvVKHe2bnqiCGaleGZrLpZ1oFEchW7n1Xo4fiY45IdXv26Y3bWH3F1RocJ6YL0l6SWg7Y4/DQpPzqn1ElyGkO65X2L7dyxx2oO3++F2VYNKMC1o87AYes/s8XAtjTO1X67UmBek7J7+0gzRTTXcWH70NNPYDkIbDTRu/WG+T+oxtIYMi22jZIKlOA+bwkrKvgRYKsKGMUONPgFtyha2PABm1qX1LiJLv/uC0Ya5sb4tkPOlEN+V3G2n0qixRAUVvrSeOXRi8wJQJnml3oSf8fn9Cq+T6J6yRetscsPeargXFyrRoLSJZWN4sGQciKIlQWPeHpSAjNF4mNQOPczCihOeChoD4PtfI/VbsnCTesh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Do the preparations in hmm_range_fault() and pagewalk callbacks to
do the "collecting" part of migration, needed for migration
on fault.

These steps include locking for pmd/pte if migrating, capturing
the vma for further migrate actions, and calling the
still dummy hmm_vma_handle_migrate_prepare_pmd() and
hmm_vma_handle_migrate_prepare()  functions in the pagewalk.

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
 include/linux/migrate.h |  17 +-
 lib/test_hmm.c          |   2 +-
 mm/hmm.c                | 423 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 387 insertions(+), 55 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 425ab5242da0..037e7430edb9 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -104,6 +104,15 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
 	WARN_ON_ONCE(1);
 
 	spin_unlock(ptl);
+
+enum migrate_vma_info {
+	MIGRATE_VMA_SELECT_NONE = 0,
+	MIGRATE_VMA_SELECT_COMPOUND = MIGRATE_VMA_SELECT_NONE,
+};
+
+static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
+{
+	return MIGRATE_VMA_SELECT_NONE;
 }
 
 #endif /* CONFIG_MIGRATION */
@@ -149,7 +158,7 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
 }
 
-enum migrate_vma_direction {
+enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
@@ -191,6 +200,12 @@ struct migrate_vma {
 	struct page		*fault_page;
 };
 
+// TODO: enable migration
+static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
+{
+	return 0;
+}
+
 int migrate_vma_setup(struct migrate_vma *args);
 void migrate_vma_pages(struct migrate_vma *migrate);
 void migrate_vma_finalize(struct migrate_vma *migrate);
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 0964d53365e6..01aa0b60df2f 100644
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
index 44699e28c551..c302de5b67d9 100644
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
@@ -27,14 +28,44 @@
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
+	/*
+	 * For migration we need pte/pmd
+	 * locked for the handle_* and
+	 * prepare_* regions. While faulting
+	 * we have to drop the locks and
+	 * start again.
+	 * ptelocked and pmdlocked
+	 * hold the state and tells if need
+	 * to drop locks before faulting.
+	 * ptl is the lock held for pte or pmd.
+	 *
+	 */
+	bool				ptelocked;
+	bool				pmdlocked;
+	spinlock_t			*ptl;
 };
 
+#define HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, locked)		\
+		WARN_ON_ONCE(hmm_vma_walk->ptelocked != locked)
+
+#define HMM_ASSERT_PMD_LOCKED(hmm_vma_walk, locked)		\
+		WARN_ON_ONCE(hmm_vma_walk->pmdlocked != locked)
+
+#define HMM_ASSERT_UNLOCKED(hmm_vma_walk)		\
+		WARN_ON_ONCE(hmm_vma_walk->ptelocked ||	\
+			     hmm_vma_walk->pmdlocked)
+
 enum {
 	HMM_NEED_FAULT = 1 << 0,
 	HMM_NEED_WRITE_FAULT = 1 << 1,
@@ -42,14 +73,37 @@ enum {
 };
 
 static int hmm_pfns_fill(unsigned long addr, unsigned long end,
-			 struct hmm_range *range, unsigned long cpu_flags)
+			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
 {
+	struct hmm_range *range = hmm_vma_walk->range;
 	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
+	enum migrate_vma_info minfo;
+	bool migrate = false;
+
+	minfo = hmm_select_migrate(range);
+	if (cpu_flags != HMM_PFN_ERROR) {
+		if (minfo && (vma_is_anonymous(hmm_vma_walk->vma))) {
+			cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
+			migrate = true;
+		}
+	}
+
+	if (migrate && thp_migration_supported() &&
+	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
+	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
+	    IS_ALIGNED(end, HPAGE_PMD_SIZE)) {
+		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
+		range->hmm_pfns[i] |= cpu_flags | HMM_PFN_COMPOUND;
+		addr += PAGE_SIZE;
+		i++;
+		cpu_flags = 0;
+	}
 
 	for (; addr < end; addr += PAGE_SIZE, i++) {
 		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
 		range->hmm_pfns[i] |= cpu_flags;
 	}
+
 	return 0;
 }
 
@@ -72,6 +126,7 @@ static int hmm_vma_fault(unsigned long addr, unsigned long end,
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 
 	WARN_ON_ONCE(!required_fault);
+	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
 	hmm_vma_walk->last = addr;
 
 	if (required_fault & HMM_NEED_WRITE_FAULT) {
@@ -165,11 +220,11 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
 	if (!walk->vma) {
 		if (required_fault)
 			return -EFAULT;
-		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
+		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
 	}
 	if (required_fault)
 		return hmm_vma_fault(addr, end, required_fault, walk);
-	return hmm_pfns_fill(addr, end, range, 0);
+	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
 }
 
 static inline unsigned long hmm_pfn_flags_order(unsigned long order)
@@ -202,8 +257,13 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 	cpu_flags = pmd_to_hmm_pfn_flags(range, pmd);
 	required_fault =
 		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
-	if (required_fault)
+	if (required_fault) {
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
 		return hmm_vma_fault(addr, end, required_fault, walk);
+	}
 
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
@@ -283,14 +343,23 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 			goto fault;
 
 		if (softleaf_is_migration(entry)) {
-			pte_unmap(ptep);
-			hmm_vma_walk->last = addr;
-			migration_entry_wait(walk->mm, pmdp, addr);
-			return -EBUSY;
+			if (!hmm_select_migrate(range)) {
+				HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+				hmm_vma_walk->last = addr;
+				migration_entry_wait(walk->mm, pmdp, addr);
+				return -EBUSY;
+			} else
+				goto out;
 		}
 
 		/* Report error for everything else */
-		pte_unmap(ptep);
+
+		if (hmm_vma_walk->ptelocked) {
+			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+			hmm_vma_walk->ptelocked = false;
+		} else
+			pte_unmap(ptep);
+
 		return -EFAULT;
 	}
 
@@ -307,7 +376,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	if (!vm_normal_page(walk->vma, addr, pte) &&
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
-			pte_unmap(ptep);
+			if (hmm_vma_walk->ptelocked) {
+				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+				hmm_vma_walk->ptelocked = false;
+			} else
+				pte_unmap(ptep);
+
 			return -EFAULT;
 		}
 		new_pfn_flags = HMM_PFN_ERROR;
@@ -320,7 +394,11 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	return 0;
 
 fault:
-	pte_unmap(ptep);
+	if (hmm_vma_walk->ptelocked) {
+		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+		hmm_vma_walk->ptelocked = false;
+	} else
+		pte_unmap(ptep);
 	/* Fault any virtual address we were asked to fault */
 	return hmm_vma_fault(addr, end, required_fault, walk);
 }
@@ -364,13 +442,18 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
 					      npages, 0);
 	if (required_fault) {
-		if (softleaf_is_device_private(entry))
+		if (softleaf_is_device_private(entry)) {
+			if (hmm_vma_walk->pmdlocked) {
+				spin_unlock(hmm_vma_walk->ptl);
+				hmm_vma_walk->pmdlocked = false;
+			}
 			return hmm_vma_fault(addr, end, required_fault, walk);
+		}
 		else
 			return -EFAULT;
 	}
 
-	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 }
 #else
 static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
@@ -378,15 +461,100 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 				     pmd_t pmd)
 {
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
-	struct hmm_range *range = hmm_vma_walk->range;
 	unsigned long npages = (end - start) >> PAGE_SHIFT;
 
 	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
 		return -EFAULT;
-	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 }
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
+#ifdef CONFIG_DEVICE_MIGRATION
+static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
+					      pmd_t *pmdp,
+					      unsigned long start,
+					      unsigned long end,
+					      unsigned long *hmm_pfn)
+{
+	// TODO: implement migration entry insertion
+	return 0;
+}
+
+static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
+					  pmd_t *pmdp,
+					  pte_t *pte,
+					  unsigned long addr,
+					  unsigned long *hmm_pfn)
+{
+	// TODO: implement migration entry insertion
+	return 0;
+}
+
+static int hmm_vma_walk_split(pmd_t *pmdp,
+			      unsigned long addr,
+			      struct mm_walk *walk)
+{
+	// TODO : implement split
+	return 0;
+}
+
+#else
+static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
+					      pmd_t *pmdp,
+					      unsigned long start,
+					      unsigned long end,
+					      unsigned long *hmm_pfn)
+{
+	return 0;
+}
+
+static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
+					  pmd_t *pmdp,
+					  pte_t *pte,
+					  unsigned long addr,
+					  unsigned long *hmm_pfn)
+{
+	return 0;
+}
+
+static int hmm_vma_walk_split(pmd_t *pmdp,
+			      unsigned long addr,
+			      struct mm_walk *walk)
+{
+	return 0;
+}
+#endif
+
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
 static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			    unsigned long start,
 			    unsigned long end,
@@ -394,46 +562,130 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 {
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
 	struct hmm_range *range = hmm_vma_walk->range;
-	unsigned long *hmm_pfns =
-		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
 	unsigned long npages = (end - start) >> PAGE_SHIFT;
+	struct mm_struct *mm = walk->vma->vm_mm;
+	enum migrate_vma_info minfo;
 	unsigned long addr = start;
+	unsigned long *hmm_pfns;
+	unsigned long i;
 	pte_t *ptep;
 	pmd_t pmd;
+	int r = 0;
+
+	minfo = hmm_select_migrate(range);
 
 again:
-	pmd = pmdp_get_lockless(pmdp);
-	if (pmd_none(pmd))
-		return hmm_vma_walk_hole(start, end, -1, walk);
+	hmm_pfns = &range->hmm_pfns[(addr - range->start) >> PAGE_SHIFT];
+	hmm_vma_walk->ptelocked = false;
+	hmm_vma_walk->pmdlocked = false;
+
+	if (minfo) {
+		hmm_vma_walk->ptl = pmd_lock(mm, pmdp);
+		hmm_vma_walk->pmdlocked = true;
+		pmd = pmdp_get(pmdp);
+	} else
+		pmd = pmdp_get_lockless(pmdp);
+
+	if (pmd_none(pmd)) {
+		r = hmm_vma_walk_hole(start, end, -1, walk);
+
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
+		return r;
+	}
 
 	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
-		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
+		if (!minfo) {
+			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
+				hmm_vma_walk->last = addr;
+				pmd_migration_entry_wait(walk->mm, pmdp);
+				return -EBUSY;
+			}
+		}
+		for (i = 0; addr < end; addr += PAGE_SIZE, i++)
+			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
+
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
+
+		return 0;
+	}
+
+	if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
+
+		if (!pmd_present(pmd)) {
+			r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
+						      pmd);
+			// If not migrating we are done
+			if (r || !minfo) {
+				if (hmm_vma_walk->pmdlocked) {
+					spin_unlock(hmm_vma_walk->ptl);
+					hmm_vma_walk->pmdlocked = false;
+				}
+				return r;
+			}
+		}
+
+		if (pmd_trans_huge(pmd)) {
+
+			/*
+			 * No need to take pmd_lock here if not migrating,
+			 * even if some other thread is splitting the huge
+			 * pmd we will get that event through mmu_notifier callback.
+			 *
+			 * So just read pmd value and check again it's a transparent
+			 * huge or device mapping one and compute corresponding pfn
+			 * values.
+			 */
+
+			if (!minfo) {
+				pmd = pmdp_get_lockless(pmdp);
+				if (!pmd_trans_huge(pmd))
+					goto again;
+			}
+
+			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
+
+			// If not migrating we are done
+			if (r || !minfo) {
+				if (hmm_vma_walk->pmdlocked) {
+					spin_unlock(hmm_vma_walk->ptl);
+					hmm_vma_walk->pmdlocked = false;
+				}
+				return r;
+			}
+		}
+
+		r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns);
+
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
+
+		if (r == -ENOENT) {
+			r = hmm_vma_walk_split(pmdp, addr, walk);
+			if (r) {
+				/* Split not successful, skip */
+				return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
+			}
+
+			/* Split successful, reloop */
 			hmm_vma_walk->last = addr;
-			pmd_migration_entry_wait(walk->mm, pmdp);
 			return -EBUSY;
 		}
-		return hmm_pfns_fill(start, end, range, 0);
-	}
 
-	if (!pmd_present(pmd))
-		return hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
-						 pmd);
+		return r;
 
-	if (pmd_trans_huge(pmd)) {
-		/*
-		 * No need to take pmd_lock here, even if some other thread
-		 * is splitting the huge pmd we will get that event through
-		 * mmu_notifier callback.
-		 *
-		 * So just read pmd value and check again it's a transparent
-		 * huge or device mapping one and compute corresponding pfn
-		 * values.
-		 */
-		pmd = pmdp_get_lockless(pmdp);
-		if (!pmd_trans_huge(pmd))
-			goto again;
+	}
 
-		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
+	if (hmm_vma_walk->pmdlocked) {
+		spin_unlock(hmm_vma_walk->ptl);
+		hmm_vma_walk->pmdlocked = false;
 	}
 
 	/*
@@ -445,22 +697,43 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 	if (pmd_bad(pmd)) {
 		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
 			return -EFAULT;
-		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 	}
 
-	ptep = pte_offset_map(pmdp, addr);
+	if (minfo) {
+		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
+		if (ptep)
+			hmm_vma_walk->ptelocked = true;
+	} else
+		ptep = pte_offset_map(pmdp, addr);
 	if (!ptep)
 		goto again;
+
 	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
-		int r;
 
 		r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
 		if (r) {
-			/* hmm_vma_handle_pte() did pte_unmap() */
+			/* hmm_vma_handle_pte() did pte_unmap() / pte_unmap_unlock */
 			return r;
 		}
+
+		r = hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns);
+		if (r == -EAGAIN) {
+			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+			goto again;
+		}
+		if (r) {
+			hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
+			break;
+		}
 	}
-	pte_unmap(ptep - 1);
+
+	if (hmm_vma_walk->ptelocked) {
+		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
+		hmm_vma_walk->ptelocked = false;
+	} else
+		pte_unmap(ptep - 1);
+
 	return 0;
 }
 
@@ -594,6 +867,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
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
@@ -616,7 +894,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 				 (end - start) >> PAGE_SHIFT, 0))
 		return -EFAULT;
 
-	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 
 	/* Skip this vma and continue processing the next vma. */
 	return 1;
@@ -646,9 +924,17 @@ static const struct mm_walk_ops hmm_walk_ops = {
  *		the invalidation to finish.
  * -EFAULT:     A page was requested to be valid and could not be made valid
  *              ie it has no backing VMA or it is illegal to access
+ * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
+ *              is too low.
  *
  * This is similar to get_user_pages(), except that it can read the page tables
  * without mutating them (ie causing faults).
+ *
+ * If want to do migrate after faulting, call hmm_range_fault() with
+ * HMM_PFN_REQ_MIGRATE and initialize range.migrate field.
+ * After hmm_range_fault() call migrate_hmm_range_setup() instead of
+ * migrate_vma_setup() and after that follow normal migrate calls path.
+ *
  */
 int hmm_range_fault(struct hmm_range *range)
 {
@@ -656,16 +942,34 @@ int hmm_range_fault(struct hmm_range *range)
 		.range = range,
 		.last = range->start,
 	};
-	struct mm_struct *mm = range->notifier->mm;
+	struct mm_struct *mm;
+	bool is_fault_path;
 	int ret;
 
+	/*
+	 *
+	 *  Could be serving a device fault or come from migrate
+	 *  entry point. For the former we have not resolved the vma
+	 *  yet, and the latter we don't have a notifier (but have a vma).
+	 *
+	 */
+#ifdef CONFIG_DEVICE_MIGRATION
+	is_fault_path = !!range->notifier;
+	mm = is_fault_path ? range->notifier->mm : range->migrate->vma->vm_mm;
+#else
+	is_fault_path = true;
+	mm = range->notifier->mm;
+#endif
 	mmap_assert_locked(mm);
 
 	do {
 		/* If range is no longer valid force retry. */
-		if (mmu_interval_check_retry(range->notifier,
-					     range->notifier_seq))
-			return -EBUSY;
+		if (is_fault_path && mmu_interval_check_retry(range->notifier,
+					     range->notifier_seq)) {
+			ret = -EBUSY;
+			break;
+		}
+
 		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
 				      &hmm_walk_ops, &hmm_vma_walk);
 		/*
@@ -675,6 +979,19 @@ int hmm_range_fault(struct hmm_range *range)
 		 * output, and all >= are still at their input values.
 		 */
 	} while (ret == -EBUSY);
+
+#ifdef CONFIG_DEVICE_MIGRATION
+	if (hmm_select_migrate(range) && range->migrate &&
+	    hmm_vma_walk.mmu_range.owner) {
+		// The migrate_vma path has the following initialized
+		if (is_fault_path) {
+			range->migrate->vma   = hmm_vma_walk.vma;
+			range->migrate->start = range->start;
+			range->migrate->end   = hmm_vma_walk.end;
+		}
+		mmu_notifier_invalidate_range_end(&hmm_vma_walk.mmu_range);
+	}
+#endif
 	return ret;
 }
 EXPORT_SYMBOL(hmm_range_fault);
-- 
2.50.0


