Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC43FCD5BD2
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47EB46B009D; Mon, 25 May 2026 04:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8A96B009B; Mon, 25 May 2026 04:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE586B009D; Mon, 25 May 2026 04:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBD4F6B0099
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:45:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A485D401E6
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:45:54 +0000 (UTC)
X-FDA: 84805309428.29.96D6A83
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6889740002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:45:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SN3Gwxzz;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779698752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzwbZPn5+wWM+Fm70orxymP7mty0eNsYO1bOXZ54GCU=;
	b=sv7ytN8+P7T8BEGY3psoK8iMZ0pTm4mNfIg/h5KoJl4QvBADifWKBBBz6IXCVJdaSFWsNr
	zRSbp8hlv2rmzxQX6Z4BEB8VzGenic9c7qEv6tmQTun5ZVHq5s/jCfKXkGMSMRDPj+ciHO
	ebg0Fu5bJeDla7+/4xjx31CsDjULc6Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SN3Gwxzz;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779698752; a=rsa-sha256;
	cv=none;
	b=mjtLVFSdzDYMUNAL1aWumRXCfD0qE0JeRKxJiYkUWiOrEVv+r+BCpSBwV5fsinzlokVQMl
	gDyOjsBxmALTRQVuv6AAFKtMV+l6OHjc0RS0fwpJsMxciQuER9/LKc23NIyVzt+3UOxYmj
	VUp3ppTyI5MmQ1Bzy31qe4K6XFASUNI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779698751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RzwbZPn5+wWM+Fm70orxymP7mty0eNsYO1bOXZ54GCU=;
	b=SN3Gwxzzz7sEKCdIa3ebpWYfxpwQorEzjWQqMnoeXQaU2E6NR1WhqOw8ZJjNw4GK8z96MH
	BKVWuMY0lr4wbMI3Y3KOofANLEEY3gfxisbs2KkfyA8MqWJSTf+3+b48BgTDBFxerY/aUx
	VpPkh8t+N+rqxPZc0KXDgmiJjW88DF0=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-G1a134w4MuGXCBOqsGx7_Q-1; Mon, 25 May 2026 04:45:50 -0400
X-MC-Unique: G1a134w4MuGXCBOqsGx7_Q-1
X-Mimecast-MFC-AGG-ID: G1a134w4MuGXCBOqsGx7_Q_1779698749
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a894c2d57cso8374580e87.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 01:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698748; x=1780303548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RzwbZPn5+wWM+Fm70orxymP7mty0eNsYO1bOXZ54GCU=;
        b=lxcit4BYWq8x8y+ir8DlB+b9uxF7sVTPg1sigZAgw6fTycGTqQx0N6z0MWQUm12+IO
         wIAL5D7aHgNFHTiKNs8y77nQW0u+uUi8IgJbdC1G3HpBHSGZ+0BqzCvNQGFn1CapxGPd
         aHWUb1NJAi/Dxgv40wSKQv1IVlnNxjgvkKvpfsn8SI4rC0geVo76yGRSOn4t7Fe6jERY
         JW/Nj0neOU5TAq2UCNPrT0+nFq+4qeZjhzmcXeqbqBaZ0t0tfjpqjH3PByplUYtEDvhe
         C5FaZ/nLwN2kdlOrfHMO2KXYNT3S8RPLksDWY/4xKY+iYMaS/1bKdgNP3LnF2RRo4VZG
         O9pQ==
X-Gm-Message-State: AOJu0Yxbt/vqV2P8nkSjWQ6z0sstYAwE+EXwAN8Peda2Vt1bYKJjh9AD
	3g2I/38C64IvNIbqZjSIYMIi3C5HtfezBoe1y2/NIY4tcZy+jnWR73dRF93Zm6iJA+7Nr/xRNiW
	otXmpYgMgrYAFi2usRMqyYgeRYdhCQtV06VHtoxNxMODruBqoSl48CFbFSAQkSonxPceWt8YXsO
	lsicr+/TRbJAZ18UzTkDw+JQsnFA2XFtj/Tt3xcg==
X-Gm-Gg: Acq92OGC0N3XNu+652zY5xFWn5PtLtbfvc3wt1CFYbVhhwCV7Drkpcte36BnZlAknlB
	euDfuZvZFj0KlS75htH3rfoMpsrlBz4ZD1OzdTBdFWvcUYibhGKGATSGYlqVaKNJ2Z+n4XQCKaK
	HDmNZAvVXNwqwDuqujPjoeDyr3OlmqopwSQ1Si9zRtf+yntf9Pc6/kj0uQ9JI+OzW296bewp4ek
	ONxHgoo6hDUbMa7wDjNppQlmdrDS+uqJr421k4fq7YPkBhLCgKEHYDLaVoKF+TxdWodyMpQZoHx
	8uWwRrC/xlgiRms8O8anI3P6MwTJol3/5IkfGZYxUS3KXn0OmKzHU11jP+LgPiVdBc4xe5cswTq
	ZClbquIK6ha2/Ol6QEV1QtQ2+whHfa4K86DJeL7bL4somxt4=
X-Received: by 2002:a2e:87d9:0:b0:393:f205:eb45 with SMTP id 38308e7fff4ca-395d8d04b14mr29876751fa.24.1779698748366;
        Mon, 25 May 2026 01:45:48 -0700 (PDT)
X-Received: by 2002:a2e:87d9:0:b0:393:f205:eb45 with SMTP id 38308e7fff4ca-395d8d04b14mr29876471fa.24.1779698747746;
        Mon, 25 May 2026 01:45:47 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dca7bcddsm21679061fa.16.2026.05.25.01.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 01:45:47 -0700 (PDT)
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
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v12 3/5] mm/hmm: do the plumbing for HMM to participate in migration
Date: Mon, 25 May 2026 11:45:22 +0300
Message-ID: <20260525084524.139868-4-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260525084524.139868-1-mpenttil@redhat.com>
References: <20260525084524.139868-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UR7__7l5NURQHhBSvTA3Wc0x7clnAnK4i8FgMgy3-2o_1779698749
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6889740002
X-Stat-Signature: qa63boscxcxo9tjciojbw1ju9duca1ud
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779698752-906280
X-HE-Meta: U2FsdGVkX19gbolyC4gtsM1JTM1/SiBVGoQYzFka8aiODjp66CogSSSwTPVVHGWmPt6+ZOgqTQRp0vVTT4dz3ymEF5Sou+/W2Pe68H7ybyhUtZQ1wIWs8gbSKi1YweetqrbJXoLyt8SijvJaI5nRdamhjPtpDBKKs6QY/JYjv051jDr9S437AEoOU1HQfNOXHAAkuoX9VxPsxVX8GTqNyqkJHxTg2oymLDS4wzdZU+zUSIMoApl8TEUHm7J2eSfX2nhaYPJcPLM9GkSz1Y7YflmIuRwNqpizKfu/ywkPKJ8DscHYCdsTqYiZ0joX3t5aqTcxX41178kNTNNMh2C5tj5yu5x1K69a/0XbX+M7pUF00m9qVrzZl6soJg5p42MW9dGmZOY4trdhdxuD3QTN3AtM1lUXLoig/sTi6a8eiTtskPTDg3aOfNAH8L0vTL4NP1Q2mFOKMNKLsoehIkueRvR5n8wjHt2unYmLNrB4xSJg8q2tyxHv+N2W5LYjQqOeusu2N/kTgwaRHMoovXDNmGvA2kro2z7ADsSGWp/39G89y9BQpnDvcupaKwElAnEMO8dtHGmAkSZG2azviUrxRVxBXWyW0CnbzXowZbIkGm+48ZxAWJy1WoC6cPKnFQf8CF9koZU7MpK9A2gzaQrx7y4i1VP1Zp8OpzJ1Y6J4mD2cAbAeZLRiM3kF55gYzHQISy+8LNxU1x0b+lCn8PQBfFa6GwDGbLnwQIFnTs+BwIa1inQsN5EWWdwlIHECQwmeojzMllE1LlhjhSR2EMymmMh9P9e/11EBv83XcIRnI2jDdg79vb5CKWi0OJL9BAoyUWVxk2sNRqOgLzAgC8JAldry8u6KrJBRFZr7D+/k2AgMotmH5fNWKbT0fSJZJy+rNLpZtEPunZ+eD5OYMKGsW0Bck51LsapfXVmRqoPEN2OJL8D9kv0rPl5BhkaOAIjv25jcQtRvzcAzqbmU99E
 T4y8ssaj
 rLmx1cWq+YCPObE1HdXLdAEbk7oUnwfySprJiTKFxFGVQR6tTA7IzT38HsV/YX8+8mloUxNdwqh/l8ahcGDGjHhun3ZHf7b1Bou+ls4uvcIofnnLVdyXC7onRgInRica/HxvApcQGvIEsVcOKNX01AW9+hEb6anuo0ydImsM1OJYORLUxsqBRNrAUy55d5vAe9W7LgbS/sDxkx4D25zds8lV0ixBfZp/mGWMc4Ve4Wjz8amth2xU4HgolfwvTFuddUTPvZgU6+FexES25qenCYnMXBBSUzPf2G/kUy5Z+G1v7W1hKjQUH+bNXsoASPfK8MjDWWD0UC07wE0j6lX5Gqhg7AmdcOGOGg9xNrvd3bAWTPhyTswO/TqnkD34iAmnLtEChX2tCsGYNugk/P6k/uUYqDwWTLkTl2rZCI7B+LGEiT8euMJWxtMVio9fnWdcQl66IMMR/40gB4oM6mwtJ6mlxJmxkGwuPQJ5m2yKaB5Fv1so8ToXYhG3931lMjQ3VUenWVzQutI0tTfqw+JvZmYS8+rWjA8dvVRwWw+v56+/I/u62o8Q3KF+vK0hhO6LN8Gq1
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
 include/linux/migrate.h |  18 +-
 lib/test_hmm.c          |   2 +-
 mm/hmm.c                | 438 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 401 insertions(+), 57 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 425ab5242da0..07429027960a 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -106,6 +106,16 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
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
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -149,7 +159,7 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
 }
 
-enum migrate_vma_direction {
+enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
@@ -191,6 +201,12 @@ struct migrate_vma {
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
index 213504915737..1a3e21325cf2 100644
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
index 5955f2f0c83d..086fdb627cb6 100644
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
@@ -48,14 +79,37 @@ enum {
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
+			cpu_flags |= HMM_PFN_MIGRATE;
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
 
@@ -78,6 +132,7 @@ static int hmm_vma_fault(unsigned long addr, unsigned long end,
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 
 	WARN_ON_ONCE(!required_fault);
+	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
 	hmm_vma_walk->last = addr;
 
 	if (required_fault & HMM_NEED_WRITE_FAULT) {
@@ -171,11 +226,16 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
 	if (!walk->vma) {
 		if (required_fault)
 			return -EFAULT;
-		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
+		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
 	}
-	if (required_fault)
+	if (required_fault) {
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
 		return hmm_vma_fault(addr, end, required_fault, walk);
-	return hmm_pfns_fill(addr, end, range, 0);
+	}
+	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
 }
 
 static inline unsigned long hmm_pfn_flags_order(unsigned long order)
@@ -208,8 +268,13 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
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
@@ -289,14 +354,24 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 			goto fault;
 
 		if (softleaf_is_migration(entry)) {
-			pte_unmap(ptep);
-			hmm_vma_walk->last = addr;
-			migration_entry_wait(walk->mm, pmdp, addr);
-			return -EBUSY;
+			if (!hmm_select_migrate(range)) {
+				HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+				pte_unmap(ptep);
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
 
@@ -313,7 +388,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
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
@@ -322,11 +402,17 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 
 	new_pfn_flags = pte_pfn(pte) | cpu_flags;
 out:
-	*hmm_pfn = (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | new_pfn_flags;
+	if ((*hmm_pfn & (HMM_PFN_MIGRATE | HMM_PFN_VALID)) !=
+	    (HMM_PFN_MIGRATE | HMM_PFN_VALID))
+		*hmm_pfn = (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | new_pfn_flags;
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
@@ -370,13 +456,18 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
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
@@ -384,15 +475,100 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
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
@@ -400,46 +576,133 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
+
+		if ((hmm_pfns[0] & (HMM_PFN_MIGRATE | HMM_PFN_VALID)) !=
+		    (HMM_PFN_MIGRATE | HMM_PFN_VALID))
+			for (i = 0; addr < end; addr += PAGE_SIZE, i++)
+				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
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
@@ -451,22 +714,43 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
 
@@ -600,6 +884,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
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
@@ -622,7 +911,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 				 (end - start) >> PAGE_SHIFT, 0))
 		return -EFAULT;
 
-	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 
 	/* Skip this vma and continue processing the next vma. */
 	return 1;
@@ -652,9 +941,17 @@ static const struct mm_walk_ops hmm_walk_ops = {
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
@@ -662,16 +959,34 @@ int hmm_range_fault(struct hmm_range *range)
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
@@ -681,6 +996,19 @@ int hmm_range_fault(struct hmm_range *range)
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


