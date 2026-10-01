Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2418DCA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 23:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B356B0098; Thu,  1 Oct 2026 19:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB316B0099; Thu,  1 Oct 2026 19:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06776B009B; Thu,  1 Oct 2026 19:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B94626B0098
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:02:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C0211C3494
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:36 +0000 (UTC)
X-FDA: 85275583512.14.6606A85
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5BBEB1A0004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Swn6bw0Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3iOa-agUKCK0ceNNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--praan.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3iOa-agUKCK0ceNNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--praan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790895754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJrWGhIUCMZjcOgrTph+7DK2V9sLKYTEdoJCIvpwPr0=;
	b=bKpHgaJfzbzIxH5GoBo7KO9+pep436z6GST4zhJf9RY0bFCM1hTHnfInh1Ak5gpXkR6ZLR
	LexI9l2q8tIrfAwaG2QCDQ+nvcA0MF53IzzvvbmHw8ThvYDuASkOwA51BddYlj/IPc/wcd
	fpjmt4dFoOsPztiLOAYz17HUtN2WDgQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Swn6bw0Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3iOa-agUKCK0ceNNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--praan.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3iOa-agUKCK0ceNNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--praan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790895754;
	b=lhukcyBafEMscNK8jt7V9Fq1Ud+8UveD4ZNGdIWbkzJqMIOctH947X9Txc+UJWLuI8KLqC
	rx7wYDmN5VaaMbQoa5u/UlL6tkz8epe/BOIa5/OYBCpZ3EgL7N8ZQiTulKM6egHt9g2+Ix
	4poFudxoSv8I5krTg49Fy3rmQjGQKJM=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-ca8aee88725so3889706a12.3
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 16:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790895753; x=1791500553; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CJrWGhIUCMZjcOgrTph+7DK2V9sLKYTEdoJCIvpwPr0=;
        b=Swn6bw0YSo5wuYGYLhN0n2X4X6Gp9WzD7cE7wUg9NdDCoH1mh51i8+kSzeyH49FBA6
         WsqMtM8GdaoyDELFJ4fvUZUp/cM8oxNE+On63Ic39HSPvzFeAxtoe28UuzGfLgrTMJfy
         HEaLQexyJM6Pa7lGdPx9sEU5zHAItkJD7iBhJxrxXLjzznY4avN/KTX11kqaxTrIQULZ
         6X9rzgVaVsPIvLsVfq4n0Wcpq9Oeyxusl2dfRJAd7nACp3DF6JcfiiJoHxkwB/swjkoK
         ZEai27jXXgYP49jdonNL6bEGPzameEYRuACajVAcdFqpt8PVedpVLe9IClvrmB4YfSkp
         9S6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790895753; x=1791500553;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CJrWGhIUCMZjcOgrTph+7DK2V9sLKYTEdoJCIvpwPr0=;
        b=lvPhuqSj36wLzRo2bU2joIdbZPgutWGcHXwCbL3Vr7zr44FoJL2k9P4jkWJIOJ+rOV
         J2B4AO4ZmiWYL+HaeuNorm3TrrXL8U+KGMt0E52hPVF/sFhMQ3EOH/QDiIvTpcWZske3
         +5399Moy1yUsFiGi/+F0tRt2jZVIwnBRzypiGnaE76eqeAa7TuMYhs1ywxnhzKu99weS
         bIsvEmE5/Lj3vJjnljexP1LkIP6ayHEjRWsCluGyauYbNkolboX/L8f9zjKQ6k8TzWtQ
         /4kO652jJY0Di7W+fuxrkJCFAPT2ZuAbhQmES3yrk77rlJcHQCM5aJvYHaapgttfds9u
         zFNg==
X-Forwarded-Encrypted: i=1; AKwUvBxG6AiFjlE/GzKKS74q7UVUgr0mkBsEMr41XWvYpg/ErxbJeyKwe0ZHCCq4SbDwRjjgohW/adbQDA==@kvack.org
X-Gm-Message-State: AFuF++ngb4/PMW2nxDJ3mmuDvWQdSXoFodS3Xc6AvH0Z9T4daGZqiHJ/
	MNKgIfm2wL9f2zPX7WWAoRgZRybNIIQLGI7Xh/aSK2wqfQyFK3NAkO8nFUrcSoEMbYIPr09rRL3
	vsQ==
X-Received: from pgbeu25.prod.google.com ([2002:a05:6a02:4799:b0:cc7:d5c2:b58a])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:938e:b0:3da:421e:40f3
 with SMTP id adf61e73a8af0-3e0bd195e56mr906637637.17.1790895752940; Thu, 01
 Oct 2026 16:02:32 -0700 (PDT)
Date: Thu,  1 Oct 2026 23:02:18 +0000
In-Reply-To: <20261001230219.818128-1-praan@google.com>
Mime-Version: 1.0
References: <20261001230219.818128-1-praan@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001230219.818128-5-praan@google.com>
Subject: [RFC PATCH 4/5] iommupt: Introduce lockless page table shrinker
From: Pranjal Shrivastava <praan@google.com>
To: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>
Cc: Mostafa Saleh <smostafa@google.com>, Daniel Mentz <danielmentz@google.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Logan Odell <loganodell@google.com>, iommu@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: rewpm1iyqzromdgshekay6ktpfnodaqa
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5BBEB1A0004
X-HE-Tag: 1790895754-21632
X-HE-Meta: U2FsdGVkX19rfWcWD/HqPJ8Ej3PJn0mNJHDUlHDCIIJydR1vVoJW3FxNCgsafPpSYOmxDMm5kNp7ruLoFWYw2ffOzOQLA1ftbrzi8DSj9y/8qlHWWAAXsrSEKQqWMqufD1AMexf7EkbQAF/4GcqYI6ToUNLhWBeuSKX9QiDVbCDggrLAdHy/t4iqR4TUQxH9alx/CkKzA2yDd7rO9RMGfZbcTEAAS5ZS6WwfwQFSCFvi4I53OiBDa9wtLq4r0FnR2mELM52KZE5SumEKL/zCly3uVQrxDc6M8NP1cnKSFIfXN0/H/HDjS/L15rNLGmIw/J75rayxlB7XIrg76j61+zf615CzKmMwPUQiGpssMhSaeCmlUoY0+ObMo3GOfofiC6PNO1Zu+YFjORCJ0vxShpeNoeM9BwgtdmZYTRxGhv9M0VP1El6wglCSTFm8nqSdB5zDpsR5l5bsAGkS1x8gyImA7fBi/oW59HCqqTi8k04F9TEYkvn0t3sMy31YFc13sp5Ezu9J++5VbydSWt0UXgRwRBdd/q8pafizQlkSGxtzQp/39bb7xgXmcyA0hd5drG+jwZWRcdHoCuUF+BVlbGnhUS87XzNmNLNHWhblXecG6nYQ4koWGELch9uBmMPGqgeXPeG5i7NCW+l5OW9IfCvIS7BQ9NZi9wvXBpp3qhBmjldQPaE08rIWhdz8wGbASjLRSCEpqy6xujIqL+fQsaJsimqwjh9Unefny0U7+sRYesViXpEVEqTi/NxeG17dPcsseX2vKxeIuFImF1fy2IvLSbaU7W4W5iyLcdqbibVS36pZzAxF8E7nz3SlT8KUEedMTo4vAzRiM83sBnaW6GqGTVLFE84bLmc2sBMICGbvl9Aqq7rr5/xQNpqoUrSDcBXkT3mT9hDW7ox5U52MVaUSINHKWGtGAKjp9ZRXkE0MutdoM4q4SRY0eEnSRgEapJVn1hD+mKTkIyqS/bM
 wsGl1eVD
 Q8EWiGPlknX0dCKXFgD5L+//xvPbw46WbheK+JM0r1LvxTZPM8N6pinZiHvOZV/Z04SZmJUYScbci7MB2o39CRtKRyGDeK8g9jeltgozr7P0PVzL61doYGc5BaTLCiirnRG8mlIBp5+p2dNpB1I/A2SYSZJnCzSD8iZOvnqxMJ8z72/manSiHAn64lVmyXQRCd0OszuLRwqYCBnnPkeAoW41xCrJXXlBXl8AKpYSiOCGR9SyHhLcpUvpKJHl490eNyZbm+pOob0sCXwodPCXRFn11dMVjPebOHpYVgWKQQJyHdm0kuYJC1Acc056uCHVj4pFhditoSEoA1ikj8I+Jd4vps/PQtDmIy04Fy36gwFh3I46uYbRIbyvsctnMhfj4aRtOCSbse6L/j6KgtLPt9q5tBKdnQJaWrukY52x0qSSYyLN1FuOpcaDpZS52yFbytpsPHIflvwEZWutT0R+uVFtCrz3/dGM/kjf31tpHZ60R8hoIDcwNSryOIyJgdJMK0zDc23SCLF3+Ayt+xtsxgtDQxXaez/QDaQwoT+CM8hqFPVprH+r29nf4UqS59Azsdo4wmua8FlhWR5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Under system memory pressure, intermediate IOMMU page table directories
that were left stranded by sparse unmaps consume valuable RAM. Introduce
an IO Page Table Shrinker to reclaim such memory.

The shrinker locklessly harvests empty directories from the per-domain
Xarrays, severs them from the page table tree using the format-agnostic
sever_branch helper. It employs a single, global synchronize_srcu grace
period before freeing the memory to protect against concurrent maps.
SRCU is an appropriate choice because the allocation during map may sleep

After severing, flush the domain's IOTLB so the IOMMU drops any cached
pointers to the severed tables before they are freed.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 drivers/iommu/Makefile              |   2 +-
 drivers/iommu/generic_pt/iommu_pt.h |  16 +++-
 drivers/iommu/generic_pt/shrinker.c | 136 ++++++++++++++++++++++++++++
 include/linux/generic_pt/iommu.h    |  10 ++
 4 files changed, 160 insertions(+), 4 deletions(-)
 create mode 100644 drivers/iommu/generic_pt/shrinker.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 2f05725eaab1..ad30c4b7566e 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -3,7 +3,7 @@ obj-y += arm/ iommufd/
 obj-$(CONFIG_AMD_IOMMU) += amd/
 obj-$(CONFIG_INTEL_IOMMU) += intel/
 obj-$(CONFIG_RISCV_IOMMU) += riscv/
-obj-$(CONFIG_GENERIC_PT) += generic_pt/fmt/
+obj-$(CONFIG_GENERIC_PT) += generic_pt/fmt/ generic_pt/shrinker.o
 obj-$(CONFIG_HYPERV) += hyperv/
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_IOMMU_SUPPORT) += iommu-pages.o
diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 868242eb2d55..e5ee419f2f0b 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -916,7 +916,7 @@ static int check_map_range(struct pt_iommu *iommu_table, struct pt_range *range,
 static int do_map(struct pt_range *range, struct pt_common *common,
 		  bool single_page, struct pt_iommu_map_args *map)
 {
-	int ret;
+	int ret, idx;
 
 	/*
 	 * The __map_single_page() fast path does not support DMA_INCOHERENT
@@ -924,17 +924,21 @@ static int do_map(struct pt_range *range, struct pt_common *common,
 	 */
 	if (single_page && !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
 
+		idx = srcu_read_lock(&generic_pt_srcu);
 		ret = pt_walk_range(range, __map_single_page, map);
+		srcu_read_unlock(&generic_pt_srcu, idx);
 		if (ret != -EAGAIN)
 			return ret;
 		/* EAGAIN falls through to the full path */
 	}
 
 	do {
+		idx = srcu_read_lock(&generic_pt_srcu);
 		if (map->leaf_level == range->top_level)
 			ret = pt_walk_range(range, __map_range_leaf, map);
 		else
 			ret = pt_walk_range(range, __map_range, map);
+		srcu_read_unlock(&generic_pt_srcu, idx);
 	} while (ret == -EAGAIN);
 	return ret;
 }
@@ -1142,13 +1146,15 @@ static size_t NS(unmap_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
 			unmap.pending.free_list),
 	};
 	struct pt_range range;
-	int ret;
+	int ret, idx;
 
 	ret = make_range(common_from_iommu(iommu_table), &range, iova, len);
 	if (ret)
 		return 0;
 
+	idx = srcu_read_lock(&generic_pt_srcu);
 	pt_walk_range(&range, __unmap_range, &unmap);
+	srcu_read_unlock(&generic_pt_srcu, idx);
 
 	gather_range_pending(&unmap.pending, iommu_table, iova, unmap.unmapped);
 
@@ -1170,7 +1176,8 @@ static int __sever_branch(struct pt_range *range, void *arg,
 	case PT_ENTRY_TABLE:
 		if (virt_to_phys(pt_table_ptr(&pts)) == sever->expected_phys) {
 			sever->success = pt_table_install64(&pts, 0x0);
-			return 1; /* Stop walking */
+			/* Stop walking */
+			return 1;
 		}
 		return pt_descend(&pts, arg, __sever_branch);
 	default:
@@ -1231,6 +1238,8 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 			collect.pending.free_list),
 	};
 
+	generic_pt_shrinker_remove(iommu_table);
+
 	iommu_pages_list_add(&collect.pending.free_list, range.top_table);
 	pt_walk_range(&range, __collect_tables, &collect);
 
@@ -1407,6 +1416,7 @@ int pt_iommu_init(struct pt_iommu_table *fmt_table,
 
 	/* Must be last, see pt_iommu_deinit() */
 	iommu_table->ops = &NS(ops);
+	generic_pt_shrinker_add(iommu_table);
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(pt_iommu_init, "GENERIC_PT_IOMMU");
diff --git a/drivers/iommu/generic_pt/shrinker.c b/drivers/iommu/generic_pt/shrinker.c
new file mode 100644
index 000000000000..66169fb5db71
--- /dev/null
+++ b/drivers/iommu/generic_pt/shrinker.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Author: Pranjal Shrivastava <praan@google.com>
+ * IO Page table reclamation (Shrinker) for generic_pt.
+ */
+
+#include <linux/iommu.h>
+#include <linux/shrinker.h>
+#include <linux/srcu.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include "../iommu-pages.h"
+#include <linux/generic_pt/iommu.h>
+
+DEFINE_SRCU(generic_pt_srcu);
+EXPORT_SYMBOL_GPL(generic_pt_srcu);
+
+static LIST_HEAD(generic_pt_domains_list);
+static DEFINE_MUTEX(generic_pt_domains_list_lock);
+
+void generic_pt_shrinker_add(struct pt_iommu *iommu)
+{
+	mutex_lock(&generic_pt_domains_list_lock);
+	list_add_tail(&iommu->shrinker_list, &generic_pt_domains_list);
+	mutex_unlock(&generic_pt_domains_list_lock);
+}
+EXPORT_SYMBOL_GPL(generic_pt_shrinker_add);
+
+void generic_pt_shrinker_remove(struct pt_iommu *iommu)
+{
+	mutex_lock(&generic_pt_domains_list_lock);
+	list_del(&iommu->shrinker_list);
+	mutex_unlock(&generic_pt_domains_list_lock);
+}
+EXPORT_SYMBOL_GPL(generic_pt_shrinker_remove);
+
+static unsigned long generic_pt_shrinker_count(struct shrinker *shrink,
+					       struct shrink_control *sc)
+{
+	struct pt_iommu *iommu;
+	unsigned long count = 0;
+
+	mutex_lock(&generic_pt_domains_list_lock);
+	list_for_each_entry(iommu, &generic_pt_domains_list, shrinker_list) {
+		struct iommu_domain *domain = &iommu->domain;
+
+		/* TODO: Return real nr_pages here! */
+		if (!xa_empty(&domain->reclaim_list))
+			count += 1;
+	}
+	mutex_unlock(&generic_pt_domains_list_lock);
+
+	return count;
+}
+
+static unsigned long generic_pt_shrinker_scan(struct shrinker *shrink,
+					      struct shrink_control *sc)
+{
+	struct iommu_pages_list free_list = IOMMU_PAGES_LIST_INIT(free_list);
+	struct pt_iommu *iommu;
+	struct ioptdesc *ioptdesc;
+	unsigned long iova;
+	unsigned long freed_count = 0;
+
+	mutex_lock(&generic_pt_domains_list_lock);
+	list_for_each_entry(iommu, &generic_pt_domains_list, shrinker_list) {
+		struct iommu_domain *domain = &iommu->domain;
+		unsigned long prev_freed = freed_count;
+
+		xa_for_each(&domain->reclaim_list, iova, ioptdesc) {
+			if (freed_count >= sc->nr_to_scan)
+				break;
+
+			if (atomic_cmpxchg(&ioptdesc->__page_refcount, 1, 0) == 1) {
+				void *virt = folio_address(ioptdesc_folio(ioptdesc));
+
+				if (iommu->ops->sever_branch(iommu, iova, virt_to_phys(virt))) {
+					/* Successfully severed, queue for freeing */
+					xa_erase(&domain->reclaim_list, iova);
+					iommu_pages_list_add(&free_list, virt);
+					freed_count++;
+				} else {
+					/* We raced with map, abort pruning */
+					xa_erase(&domain->reclaim_list, iova);
+				}
+			} else {
+				/* Not empty anymore, remove from list */
+				xa_erase(&domain->reclaim_list, iova);
+			}
+		}
+
+		/*
+		 * The IOMMU may still cache pointers to the severed tables in its
+		 * paging-structure caches, flush them before the tables are freed.
+		 */
+		if (freed_count != prev_freed)
+			iommu_flush_iotlb_all(domain);
+	}
+	mutex_unlock(&generic_pt_domains_list_lock);
+
+	/* If we didn't sever anything, just return */
+	if (list_empty(&free_list.pages))
+		return freed_count;
+
+	/* Wait ONE time for the entire system */
+	synchronize_srcu(&generic_pt_srcu);
+
+	/* Free pages from all domains */
+	struct page *page, *next;
+
+	list_for_each_entry_safe(page, next, &free_list.pages, lru) {
+		/* We must restore the refcount to 1 before freeing */
+		set_page_count(page, 1);
+	}
+
+	iommu_put_pages_list(&free_list);
+
+	return freed_count;
+}
+
+static int __init generic_pt_shrinker_init(void)
+{
+	struct shrinker *shrinker;
+
+	shrinker = shrinker_alloc(0, "iommu-generic-pt");
+	if (!shrinker)
+		return -ENOMEM;
+
+	shrinker->count_objects = generic_pt_shrinker_count;
+	shrinker->scan_objects = generic_pt_shrinker_scan;
+
+	shrinker_register(shrinker);
+	return 0;
+}
+subsys_initcall(generic_pt_shrinker_init);
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index d1ade1767a9a..95bf9d4f0b6e 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -64,8 +64,18 @@ struct pt_iommu {
 	 * page table which must have dma ops that perform cache flushing.
 	 */
 	struct device *iommu_device;
+
+	/**
+	 * @shrinker_list: Node for the generic_pt global shrinker list
+	 */
+	struct list_head shrinker_list;
 };
 
+extern struct srcu_struct generic_pt_srcu;
+
+void generic_pt_shrinker_add(struct pt_iommu *iommu);
+void generic_pt_shrinker_remove(struct pt_iommu *iommu);
+
 static inline struct pt_iommu *iommupt_from_domain(struct iommu_domain *domain)
 {
 	if (!IS_ENABLED(CONFIG_IOMMU_PT) || !domain->is_iommupt)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


