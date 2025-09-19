Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D40CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 05:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BD1F28003D; Fri, 19 Sep 2025 01:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D7D28000F; Fri, 19 Sep 2025 01:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CEF28003D; Fri, 19 Sep 2025 01:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5299228000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:43:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AC781DE351
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:43:22 +0000 (UTC)
X-FDA: 83904907044.18.0E2D984
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf01.hostedemail.com (Postfix) with ESMTP id E317540003
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:43:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dKdfl6jY;
	spf=none (imf01.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758260600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kbgXYzfUuNKBsxElYRtKxBILmfS5QCZpDn2L+rYHxPU=;
	b=PTFG0kOMq/Cp/Y21MtHyvR9qjitY6l1yqaR4ftTwdaqbC9W3l9EVRh0cC28DMHkbwOMD16
	j31qS7cmaK8tw9KneNJMk+B2wz9axMaNikjC+DwiE+YopVTQgh3J8A3rAMgZYapdlPxjrM
	PZJWa4iD7SaC8TQjXSvlcqYlIq0lavo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dKdfl6jY;
	spf=none (imf01.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758260600; a=rsa-sha256;
	cv=none;
	b=aaf92vi0SY+c9px5IvbyjF0/pxUpyfOEiGyER0Zttk7UNoRbvE0mIxU9t1ARnz0EkJbCQ7
	iU0AFC9Hb3k1xd8Cc5RDEJhR11rsZ+Y+2QitUyJg7swd0APUwe2DfedJaMbJIbJ/Xm4Eaf
	+sgIwvZQ65Cnh6VGUvFc8UKYkKuMVLo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758260600; x=1789796600;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+8njrf145jINfn00inC0gZtB0ssqDzEJPA2lNTd2qt0=;
  b=dKdfl6jYoyUBA00lOuUz7i3asGxy074ETW47QzUa51xPMz2dyfI6838m
   GPG5LkBzR9/IjPVK4r3nCSldmX4pKHjPpdSgF5MHtK8lKco7qWRa7td3+
   zxykQRRLDYNWlTq5qgRznhCvuMlVzH7GOyQTJ0391wt0iUX15U9VSDURD
   WiUtDtuR+oI1h56eeaFNVkr+g19LTG4+g9NvlWRxxW3nRvz/ze5tpjVen
   6uac0b+xJsSf9LMwk1OGgXogx3c+s0m5Msf1tXvPsHDzE2q9VTemGiWOz
   sD6m2tAWl10Ml2YpqRAZqeg1wTMIBDwHcImRFwyahUQH3YFjtXxBhiYy7
   g==;
X-CSE-ConnectionGUID: XjBJj8q0RGyGRBDI19HCGw==
X-CSE-MsgGUID: CXVewZuNQaeGYvwX8uMp6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="63235868"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="63235868"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:43:19 -0700
X-CSE-ConnectionGUID: +6W7M8nUTJCbR5cI6gK3tQ==
X-CSE-MsgGUID: QXAdZle/R3eTi2kaVM+C2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="180858904"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by orviesa005.jf.intel.com with ESMTP; 18 Sep 2025 22:43:12 -0700
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>,
	Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	stable@vger.kernel.org
Subject: [PATCH v5 8/8] iommu/sva: Invalidate stale IOTLB entries for kernel address space
Date: Fri, 19 Sep 2025 13:40:06 +0800
Message-ID: <20250919054007.472493-9-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250919054007.472493-1-baolu.lu@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E317540003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8hreaxrmrw3zwm8ows9hq3qpx8e13drc
X-HE-Tag: 1758260599-117972
X-HE-Meta: U2FsdGVkX1/VuKhaeWMHAeq2jFbjaYZUvlHi9GqkMIKxmhULzU431nK4E4N1w9QQNoW6uJm0TYw9bu5rsCQZRsWXWfRdK5FSbSK4Qkh+zM400oio6v0OEimUC3atgKwxCDAbx5rn702h25mGqb3Qs+fwI2oW7l9LveuiiDxgEzVWUbwwYTgX+IkLaqnH5sQadAouDAnolWt9A8c2X6hXosACmoF5Dr1uFxKJwIoQCFg1p5zVMpsI7P2f7m9Flvnu/YA429LAjBimn2coTzl3gAYmNfaNWqvxw/IT243zE23Lot8Kj8w4b71kI+Bqb6O90DsSqLcYrZvDXA9EHPT0w+uNYjYM76QIwiutjPssghpU2MDQGIJiagdmS18ofanJipJVwtJpmP/s3yDGxOmStoIp0Bpe4FEt5YHBvDIm7M1QjEUf4c+NvwkVmEs71+E4gLlcphb/hblLzjuYuQ6/n6vYzj3Q6coRUThKmZuU0my8spRMiNoExrJOYjLf7v0O/CyhBE0NJyZjI7onjDWo+Z8viZUFJpV8lOz6Ybsi4rCr+re2k9KdZT9CrBEkKkDd8lzeapASiwZmtnpS6M0qHO7hX5N7+1TSB32q+CDMsjPxAticS6DmHTxOkNvlaQ+C32eEONU0O+g89V9essHJ9bBg4xrdb0GXl03zSZ6+tcRldDG0d6ke1T7uAbU/NkAotDS+DfRAFmv8H9g0D92X2CWNldsUgThVWZjohvG6A8NvLECB2QziX3sPm2VSwxQzGEDn4bUQ+Z4oapYEu54jpC6rHs//4ijP4iHfFbj3WyS1B0s9jt+hY/7HCCe7IBGbh9GaaZWnnPshCUdHYVM5v1hV6ga1Vd2GQuMHo0hCuPTAmOIgiYp/7TFNKM+9EaFnZJDBA3VhmE0zSYdvEDsPoVJgBDQBdgzsHBD+4I8aBTFt3rar0JnwboTXs7znxxIVi9M2sJ9uC06awlOfQAq
 5ueKmulE
 NjIKlcHhzBd2lfdmeNHkdltSQutxeluUIPcv9CXqx+y2Vbgt2KQuN+QsAgkaHaEkC+2JYy0as23VMoKrGBav7BKOzere0Hwk0+usDoS8UmpbhBiKdLRU90/vfYMWfQeODohNN535XSqABXzwzD15y0uBl1s+tKIRXyr4NDuCmW0gUc74RykPrZ/VsNi3d1T9lUX0EhdhZQJ2SlFRmZz7Apqgd2taB3EgPGimWyiYuojlBmvYWuKaNc2ZoYBdLxC3cxUTRKmrWA07h1VmsUYncOoF1MxUHzjk8FQKQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the IOMMU Shared Virtual Addressing (SVA) context, the IOMMU hardware
shares and walks the CPU's page tables. The x86 architecture maps the
kernel's virtual address space into the upper portion of every process's
page table. Consequently, in an SVA context, the IOMMU hardware can walk
and cache kernel page table entries.

The Linux kernel currently lacks a notification mechanism for kernel page
table changes, specifically when page table pages are freed and reused.
The IOMMU driver is only notified of changes to user virtual address
mappings. This can cause the IOMMU's internal caches to retain stale
entries for kernel VA.

A Use-After-Free (UAF) and Write-After-Free (WAF) condition arises when
kernel page table pages are freed and later reallocated. The IOMMU could
misinterpret the new data as valid page table entries. The IOMMU might
then walk into attacker-controlled memory, leading to arbitrary physical
memory DMA access or privilege escalation. This is also a Write-After-Free
issue, as the IOMMU will potentially continue to write Accessed and Dirty
bits to the freed memory while attempting to walk the stale page tables.

Currently, SVA contexts are unprivileged and cannot access kernel
mappings. However, the IOMMU will still walk kernel-only page tables
all the way down to the leaf entries, where it realizes the mapping
is for the kernel and errors out. This means the IOMMU still caches
these intermediate page table entries, making the described vulnerability
a real concern.

To mitigate this, a new IOMMU interface is introduced to flush IOTLB
entries for the kernel address space. This interface is invoked from the
x86 architecture code that manages combined user and kernel page tables,
specifically before any kernel page table page is freed and reused.

This addresses the main issue with vfree() which is a common occurrence
and can be triggered by unprivileged users. While this resolves the
primary problem, it doesn't address some extremely rare case related to
memory unplug of memory that was present as reserved memory at boot,
which cannot be triggered by unprivileged users. The discussion can be
found at the link below.

Fixes: 26b25a2b98e4 ("iommu: Bind process address spaces to devices")
Cc: stable@vger.kernel.org
Suggested-by: Jann Horn <jannh@google.com>
Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/linux-iommu/04983c62-3b1d-40d4-93ae-34ca04b827e5@intel.com/
---
 drivers/iommu/iommu-sva.c | 29 ++++++++++++++++++++++++++++-
 include/linux/iommu.h     |  4 ++++
 mm/pgtable-generic.c      |  2 ++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 1a51cfd82808..d236aef80a8d 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -10,6 +10,8 @@
 #include "iommu-priv.h"
 
 static DEFINE_MUTEX(iommu_sva_lock);
+static bool iommu_sva_present;
+static LIST_HEAD(iommu_sva_mms);
 static struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 						   struct mm_struct *mm);
 
@@ -42,6 +44,7 @@ static struct iommu_mm_data *iommu_alloc_mm_data(struct mm_struct *mm, struct de
 		return ERR_PTR(-ENOSPC);
 	}
 	iommu_mm->pasid = pasid;
+	iommu_mm->mm = mm;
 	INIT_LIST_HEAD(&iommu_mm->sva_domains);
 	/*
 	 * Make sure the write to mm->iommu_mm is not reordered in front of
@@ -132,8 +135,13 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev, struct mm_struct *mm
 	if (ret)
 		goto out_free_domain;
 	domain->users = 1;
-	list_add(&domain->next, &mm->iommu_mm->sva_domains);
 
+	if (list_empty(&iommu_mm->sva_domains)) {
+		if (list_empty(&iommu_sva_mms))
+			iommu_sva_present = true;
+		list_add(&iommu_mm->mm_list_elm, &iommu_sva_mms);
+	}
+	list_add(&domain->next, &iommu_mm->sva_domains);
 out:
 	refcount_set(&handle->users, 1);
 	mutex_unlock(&iommu_sva_lock);
@@ -175,6 +183,13 @@ void iommu_sva_unbind_device(struct iommu_sva *handle)
 		list_del(&domain->next);
 		iommu_domain_free(domain);
 	}
+
+	if (list_empty(&iommu_mm->sva_domains)) {
+		list_del(&iommu_mm->mm_list_elm);
+		if (list_empty(&iommu_sva_mms))
+			iommu_sva_present = false;
+	}
+
 	mutex_unlock(&iommu_sva_lock);
 	kfree(handle);
 }
@@ -312,3 +327,15 @@ static struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 
 	return domain;
 }
+
+void iommu_sva_invalidate_kva_range(unsigned long start, unsigned long end)
+{
+	struct iommu_mm_data *iommu_mm;
+
+	guard(mutex)(&iommu_sva_lock);
+	if (!iommu_sva_present)
+		return;
+
+	list_for_each_entry(iommu_mm, &iommu_sva_mms, mm_list_elm)
+		mmu_notifier_arch_invalidate_secondary_tlbs(iommu_mm->mm, start, end);
+}
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index c30d12e16473..66e4abb2df0d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1134,7 +1134,9 @@ struct iommu_sva {
 
 struct iommu_mm_data {
 	u32			pasid;
+	struct mm_struct	*mm;
 	struct list_head	sva_domains;
+	struct list_head	mm_list_elm;
 };
 
 int iommu_fwspec_init(struct device *dev, struct fwnode_handle *iommu_fwnode);
@@ -1615,6 +1617,7 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 					struct mm_struct *mm);
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
+void iommu_sva_invalidate_kva_range(unsigned long start, unsigned long end);
 #else
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm)
@@ -1639,6 +1642,7 @@ static inline u32 mm_get_enqcmd_pasid(struct mm_struct *mm)
 }
 
 static inline void mm_pasid_drop(struct mm_struct *mm) {}
+static inline void iommu_sva_invalidate_kva_range(unsigned long start, unsigned long end) {}
 #endif /* CONFIG_IOMMU_SVA */
 
 #ifdef CONFIG_IOMMU_IOPF
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 0279399d4910..2717dc9afff0 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -13,6 +13,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/mm_inline.h>
+#include <linux/iommu.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
 
@@ -430,6 +431,7 @@ static void kernel_pgtable_work_func(struct work_struct *work)
 	list_splice_tail_init(&kernel_pgtable_work.list, &page_list);
 	spin_unlock(&kernel_pgtable_work.lock);
 
+	iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
 	list_for_each_entry_safe(pt, next, &page_list, pt_list)
 		__pagetable_free(pt);
 }
-- 
2.43.0


