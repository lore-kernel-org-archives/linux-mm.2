Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 683A4C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121F46B0098; Thu, 24 Sep 2026 02:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2AE6B0099; Thu, 24 Sep 2026 02:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41086B009B; Thu, 24 Sep 2026 02:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87EBA6B0098
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:53:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2DC31A0269
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:53:45 +0000 (UTC)
X-FDA: 85247740410.07.F7890EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id B9F9F40005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:53:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gP1yj/f3";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232823;
	b=FP/ritGpa/8m6HX1wa0H7Kq+8f3jXkxeEU1WO+GVjP95JcqATJkIya1tiL4HRuFkEZ2Y1+
	NVcPGReqrTzT6Cpdq6YfUZRed+3ftTVOpAQ9T+TYNNPOuDck2u8NelSYub+uw3i5QA2TKo
	2GHszoSCkCClPV6nWdmLRXFarcyFn8k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gP1yj/f3";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kki3z56ATUJrZFB3MBKMIKwGUeQgKMm6Uy7jrjVIGAU=;
	b=vQRb6lLtJrgYZ5FNKiYsLApvSOrpZxbwyD7391NXhv1ZxasCdyyj8YQkMauwdVF9SbyWE+
	vHt+QL8J5rgRav8d6/BMA+uWE8CkJA98Pz6hT8EH/R86ipuZTe0LQHBVlLcULKjKAWl12N
	Pg/0RtvPpYu+BkRPEkUf0YCuE88v3YY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kki3z56ATUJrZFB3MBKMIKwGUeQgKMm6Uy7jrjVIGAU=;
	b=gP1yj/f3J91tnikd4eM6CPPEGvkR9cKlpN1ynImKjNkE16B1xqEwffhWJOnf4lK2dkgYFh
	Iynrp8AFkEE3+cykThkX3kaP4ZqKQuvijWsvHQCZM3G/5bK6Z+6t8UYFhWbhpmqX84qzqc
	9VfLmJSHA5iCTNIu6N6/asmyuS/aGJM=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-218-Q0BfNaVzPreOakufq8PpQA-1; Thu, 24 Sep 2026 02:53:41 -0400
X-MC-Unique: Q0BfNaVzPreOakufq8PpQA-1
X-Mimecast-MFC-AGG-ID: Q0BfNaVzPreOakufq8PpQA_1790232820
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3a5e8d98c8cso8949871fa.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232819; x=1790837619;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kki3z56ATUJrZFB3MBKMIKwGUeQgKMm6Uy7jrjVIGAU=;
        b=E5jQwp3HsBSzJQz2bgrpxXorNhvz8aJ/PI9Z78D5kwIrveFkcKfbmAXVcuHXkZ3tMj
         k/xAK8MkVMB7N9IFOyXCDpH5H7zIZ6EV9gdx5RQP+MCfSYqFw28seiDk306UDwjJ7Z6d
         CG0OZR8liqJ1BlItXMkcU179xqphV/C4wTpGWlKUJNSUEVWenUPaw6BieAm9NBz5gHbm
         YmBRDndD2S8XXdUo2DfVr1LZuFz4WrvTuHu4jpIT5CMDuCHNfklLqosH1VABJdRozupj
         xshTWTczmfS3vGiMbvhbRtVPoEpCp6FQIxe47QsMxpCoPBNaSqLOXQTLAENBx8r0H6P9
         Kyxw==
X-Gm-Message-State: AFuF++lr/lRiUydZvv2qZSH6gYAQ8C8+oFRR7m7+ewGl49y6AWnz8BSI
	VxH7uVGeLnRa+hvsOnDsQ+1EJQFLsB+ONED5rOocVb3UDa3igOprs6YG0TEvRl9bcm4qRzN80Br
	1BYpX257mo7skmd7Jj9P/MvFzgY3G6/9bC8TKqmFTgEbEJit8yzMC0UCbkmUzy2DWvTZxXep55K
	2eT9JwYK7i61AvoEL5JkUOhXAspvHHjCkI5oeg4A==
X-Gm-Gg: AYBFou2DMRYgQ4ahzqhb4u4OjLSKPJPWB4ggdw2Lmo8gXA5ROChAXn2B2VVKR453jo0
	zAs6zRjWjlAKUtHFvuNyP1NzdVbxMwMmW0f/3gM4M2VdHT9YjCrYKPgmgw7ht8ap8SV/PzqSeR4
	rB8EjeVQ/+4bRFQ9jRn7UZyZrpwQ6aB2EwTrzHZ98M6J3CBZhrx8whjuGCIZOTQKySgwGhrMDo7
	czm8nfcJHY8p5WjU/90mKhIKOVfZ9+L+dp66VvAYXPRx2Bmezf0mYDbq2PG77BzZibj8SKMBgKG
	CLMIJyz1/jV8dnnMFSQjdXGX2SjmG4rEBxbgEuEi8zuX9vrtS3HczOLGGMHcSzDWTRC8i15XRCT
	IWiL+/IqZD2OQEL/qaUdDuZovQCY337o=
X-Received: by 2002:a05:651c:b0a:b0:3a3:749e:319b with SMTP id 38308e7fff4ca-3a63de182e4mr2715211fa.15.1790232819398;
        Wed, 23 Sep 2026 23:53:39 -0700 (PDT)
X-Received: by 2002:a05:651c:b0a:b0:3a3:749e:319b with SMTP id 38308e7fff4ca-3a63de182e4mr2714961fa.15.1790232818795;
        Wed, 23 Sep 2026 23:53:38 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf57909sm4803141fa.29.2026.09.23.23.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:53:36 -0700 (PDT)
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
Subject: [PATCH v15 03/11] mm/hmm: preparations for HMM to participate in migration
Date: Thu, 24 Sep 2026 09:53:05 +0300
Message-ID: <20260924065313.899730-4-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924065313.899730-1-mpenttil@redhat.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8lyJEbNXYz0zOzE4SoWlAyjGeALWFo3gZIX2GeCRA-k_1790232820
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: k3wn4jxawud5ohomz9hio5zd7hw9is96
X-Rspam-User: 
X-Rspamd-Queue-Id: B9F9F40005
X-HE-Tag: 1790232823-91439
X-HE-Meta: U2FsdGVkX19mnKQ6TVu9dsjTxatQ3xok6W5lFYGkBWLAZKk0VMsRQp1kUr4eJ9TSSxmDiCyKocdqahTqyYWBN+1tRgkG8Lrq+QwFIyjXDwQfFp5Zl6ntKCHyk64Umr6svALw7DsUZS5Ptpmq1q/yxwMgHjpdYSmBF43b0GSzJ7vWUPg1W0555HnV9+ibr+aWKuXSBs030O7xQpqVWq2CJ5R/MwHEZwt5HQYvhZGHfHnODYur2FLmk31CQvOb9XkKvVUe6HaB94zQqWjUGpge56al+N/gPPcuYZKjV9/rQihliiTCwh+Wgfmwu9qVrby0S7Pnv8oTFgMKQL4LpwypaNOa0FdoA2xdPbx6msEUgZ3gyDfK/i1et0FG+4YItVMSlQcUtgMRsP4xp5HvrgbuaQjRuVa3e59csD1J/CA7Vu9hI8/1d7Q1xxo+7qWMKF8eiFgsCVoq09uWvZn/ue7/+Jfs3IQ1BbQdocyjmbjm8DBJv3xEVaFMG8yvfB1SBhDpcpYkkBUp+vSbSEvuVMPW6nprd5ilVwIsw2M8HBnAONF6734CG5ZAsTfr2ddqkvflyo1naqwuWTzqKdHdo+mrmg1Cnq+iN/YUG8iXClYB3pZk58I/3gmW/6W0rzs6MxyCVIz3CFF9umjJYntLgx3CIfwrj1iZITV3kINe45JpDoIZMhbILz4rivJ9mIloAkEqFxVz/Ja5/yowIjcb9DyVBm0LGfmd1esT9UbhZUGMeiyeEOVNyz9pLrHjHc9vgoY/FJ6szIlg9GMI8AQ3hnbhWTdBhIv9nRrCiNkEfdCh2R1ESRplPeyIdAZ+/h8yMTU6rKhTZQi6ExUTQHl0fWf0XktZlP0ajodzxDWKAO7h9gKRqwaJtYD3Q78jlxVzleePAS+uj3b5/7VEuF/gwZG0NG9oQjTKqBCSja/O25Ra/w5VW61Ci7wQzn/NWSGQCnfMSXDDTdj+hDGet6ooXup
 RQa24vzG
 e/rBSmOCQS9S5UlOZXkF85w2w8Qi7DIQsAbaIz1Qec4VZGkSRCnqUaBz563SRL5BFOzotAtcfRLWYv7HpY59YtZlRebiXkSLrzQGj6/W8p+5mD0W3YLJSqW90UKQRiiOkbQlwswFNjXuF25ZLPAbjanF6uWxTM2gC2TNZ7g5q4zTIBjWdt2VciJNR8zqc6usnjOOtcFFQ4RbbwK8Z6R+HDq4rBS+5hbe5VgsMKzfpXbRqB+6e5vE8WAXZHsUGVmygoRa/F1yLYb3LNW+uR9YVukRfEKW6d6vt5RCKX4kMxfeZ3Cj0LE7TIP3fAaK6lOsBlbvDBYA1RUIiXFoDrl//zM0ZjPvk72mUVu7WBfV676nz0+HMMuVgbBe3jUcXClIdmnCFHNJvOryuh9D207fY1lUWrAEl3noPPwiE3xbieFVTg19ZBnXovpWqT/JhFYibWUcnnOWdRDYw+lTSv/lxgArmtAAhTMrBB36mFM0woIgtJbpSiMajvTEvhg==
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
In case lock-drop behavior is requested, return an error while
migrating. Also, rename some struct hmm_vma_walk fields to solve
namespace collisions, and we are later introducing more
xxlocked fields so be unambiguous.

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
 include/linux/migrate.h |  49 +++++++++++++++++-
 lib/test_hmm.c          |   2 +-
 mm/hmm.c                | 110 ++++++++++++++++++++++++++++++++++------
 3 files changed, 144 insertions(+), 17 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 280ec9a866c7..01c5f62a56e9 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -5,6 +5,7 @@
 #include <linux/mm.h>
 #include <linux/hmm.h>
 #include <linux/mempolicy.h>
+#include <linux/mmu_notifier.h>
 #include <linux/migrate_mode.h>
 #include <linux/hugetlb.h>
 
@@ -108,6 +109,29 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
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
+#ifdef CONFIG_MMU_NOTIFIER
+static inline struct mm_struct *hmm_range_fault_mm(struct hmm_range *range)
+{
+	return range->notifier->mm;
+}
+#endif
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -151,7 +175,7 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
 }
 
-enum migrate_vma_direction {
+enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
@@ -193,6 +217,29 @@ struct migrate_vma {
 	struct page		*fault_page;
 };
 
+// TODO: enable migration
+static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
+{
+	return 0;
+}
+
+#ifdef CONFIG_MMU_NOTIFIER
+static inline struct mm_struct *hmm_range_fault_mm(struct hmm_range *range)
+{
+	return range->notifier ? range->notifier->mm : range->migrate->vma->vm_mm;
+}
+#endif
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
index 6911daa9f854..cd88e8177d0a 100644
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
index 2f1e98c6b644..4e9542aedc25 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -21,6 +21,7 @@
 #include <linux/pagemap.h>
 #include <linux/leafops.h>
 #include <linux/hugetlb.h>
+#include <linux/migrate.h>
 #include <linux/memremap.h>
 #include <linux/sched/mm.h>
 #include <linux/jump_label.h>
@@ -28,15 +29,23 @@
 #include <linux/pci-p2pdma.h>
 #include <linux/mmu_notifier.h>
 #include <linux/memory_hotplug.h>
+#include <asm/tlbflush.h>
 
 #include "internal.h"
 
 struct hmm_vma_walk {
-	struct hmm_range	*range;
-	bool			*locked;
-	unsigned long		last;
-	unsigned long		end;
-	unsigned int		required_fault;
+	struct mmu_notifier_range	mmu_range;
+	/* Set once mmu_range is armed with mmu_notifier_invalidate_range_start() */
+	bool				mmu_armed;
+	struct vm_area_struct		*vma;
+	struct hmm_range		*range;
+	unsigned long			start;
+	unsigned long			end;
+	unsigned long			last;
+	/* fault and lock drop related fields */
+	bool				*mmlocked;
+	unsigned long			fault_end;
+	unsigned int			required_fault;
 };
 
 /*
@@ -95,7 +104,7 @@ static int hmm_record_fault(unsigned long addr, unsigned long end,
 
 	WARN_ON_ONCE(!required_fault);
 	hmm_vma_walk->last = addr;
-	hmm_vma_walk->end = end;
+	hmm_vma_walk->fault_end = end;
 	hmm_vma_walk->required_fault = required_fault;
 	return HMM_FAULT_PENDING;
 }
@@ -400,6 +409,58 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 }
 #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
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
+
+	if (end - start > range->end - range->start)
+		return -ERANGE;
+
+	if (!hmm_vma_walk->mmu_armed) {
+		hmm_vma_walk->start = start;
+		hmm_vma_walk->end = end;
+		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
+					      walk->vma->vm_mm, start, end,
+					      range->dev_private_owner);
+		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
+		hmm_vma_walk->mmu_armed = true;
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
+	    hmm_vma_walk->mmu_armed) {
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
@@ -594,6 +655,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
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
@@ -646,12 +712,12 @@ static int hmm_do_fault(struct mm_struct *mm,
 			struct hmm_vma_walk *hmm_vma_walk)
 {
 	unsigned long addr = hmm_vma_walk->last;
-	unsigned long end = hmm_vma_walk->end;
+	unsigned long end = hmm_vma_walk->fault_end;
 	unsigned int required_fault = hmm_vma_walk->required_fault;
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 	struct vm_area_struct *vma;
 
-	if (hmm_vma_walk->locked)
+	if (hmm_vma_walk->mmlocked)
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 	vma = vma_lookup(mm, addr);
@@ -670,8 +736,8 @@ static int hmm_do_fault(struct mm_struct *mm,
 		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
 
 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
-			if (hmm_vma_walk->locked)    /* needed by sparse */
-				*hmm_vma_walk->locked = false;
+			if (hmm_vma_walk->mmlocked)    /* needed by sparse */
+				*hmm_vma_walk->mmlocked = false;
 			else
 				WARN_ON_ONCE(1);    /* broken fault handler */
 			return HMM_FAULT_UNLOCKED;
@@ -694,19 +760,31 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
 {
 	struct hmm_vma_walk hmm_vma_walk = {
 		.range = range,
-		.locked = locked,
+		.mmlocked = locked,
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
 
+	/* Migration is incompatible with mmap lock drop */
+	if (locked && hmm_select_migrate(range))
+		return -EINVAL;
+
 	mmap_assert_locked(mm);
 
 	do {
 		/* If range is no longer valid force retry. */
-		if (mmu_interval_check_retry(range->notifier,
-					     range->notifier_seq))
-			return -EBUSY;
+		if (range->notifier && mmu_interval_check_retry(range->notifier,
+								range->notifier_seq)) {
+			ret =  -EBUSY;
+			break;
+		}
 		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
 				      &hmm_walk_ops, &hmm_vma_walk);
 		/*
@@ -732,6 +810,8 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
 		 * output, and all >= are still at their input values.
 		 */
 	} while (ret == -EBUSY);
+
+	hmm_vma_post_range_fault(&hmm_vma_walk);
 	return ret;
 }
 
-- 
2.55.0


