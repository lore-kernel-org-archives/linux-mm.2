Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C4DFCCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 02:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98CE88E000C; Mon, 20 Oct 2025 22:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9646B8E0002; Mon, 20 Oct 2025 22:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C86C8E000C; Mon, 20 Oct 2025 22:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F32E8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 22:56:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1550F58935
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:56:47 +0000 (UTC)
X-FDA: 84020608854.28.F50BF12
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E375100002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:56:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761015405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=yOM1PN5czx7scwUKwUhx6A2SYy7dvS5ZXaKI/E17uTQ=;
	b=PpJ3KPf0J41DMbo6HrmSLgDLybhxNqoSypJ2pL1vkdhx3JxgbcRgLREZ/k+PVkeZOtfq5q
	osgF4soCZKag9QMNYO3RVECwsGQjUezrk36mNe+F2WcLwaZ913N9U5vMTr0q9LUEN5r5it
	A5db1tdB1w44ukVll8ieD4oAeDBTXoc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761015405; a=rsa-sha256;
	cv=none;
	b=130FDzIrN5XZohQU/TPmUzMuy+Ynw1ozoPHa42IQUxNFUSKz4brj8lj1TY7y9bVInBM9FL
	5uTHDiYi3kAzqY/v2f+2hyFPM+CAhY8j2HBBiDEjIGImkJw1nUSUMiL+z+hddVbbMbWgCa
	HdullIhVZW3XgwTjqpfZtvnIjgOpU/w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D39371063;
	Mon, 20 Oct 2025 19:56:36 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 852D03F59E;
	Mon, 20 Oct 2025 19:56:43 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	virtualization@lists.linux.dev
Subject: [PATCH] mm: Make INVALID_PHYS_ADDR a generic macro
Date: Tue, 21 Oct 2025 03:56:38 +0100
Message-Id: <20251021025638.2420216-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jgyngj3fxx3fcjmc4uwx3m9yho6ngynx
X-Rspamd-Queue-Id: 9E375100002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761015405-982432
X-HE-Meta: U2FsdGVkX18J63xz7SyZMxpTUSUVzmMa1tw056jNzo5FqEvvhUf0tCV1VrQH1w6+2myGU3lYjmeI5+OaRFC9J/GpmBZ/8/SrA1E3f9NguoqsWkrCttPXlpZyDsWU4Aqa6q4tyVeSAKvBNemUc7ck/l6yab2qXa5J2uVH/dh0/2vl4+RlHVIKHslEqddqAD+m8FHSJWSnWU7PHNiAZNj5ivaFe5RWriBnkwi8KKR8TnfXxAXcNF5LRYvSWWRFgmz6OZqLsnF6OPYGwI20HkbDBeM9MJJk2lgM4KsalTNI/AuRi7q8bW23TsOq8AaY7YBXoE1F8TiwGSbMrEN4mDT9YoY+0O+qRniKwBXgnLak7VE1nVlmvySV7Wzs/cmPrWaQ7VWuB84dJJzSKFyFOPsrSnSm58F3qaRiypMOaKspIgrcG+1AirqlIwcR85BAcm8iYdJy3gVsksVRqxI3nLm4KvqqBLG+s+3nkC6w5B+XwspGz+EhmYlODyh7Vjdr93mRHs4v0/xOncF1lex7ODT7Nu5sHzwviQnKWVFA/WgGXvn/A1mFze1i8gCaoVr5J+TfJxCqFLy7VmdhGNJWvE+6auRqMzT3tbddYfMGm+JB/edPLnORYZGu6jptigk7UnxBEXxlptGoXvPYRj44jBN+OooSP7JqIz0zQR5cIMEHaAD+G1+qE9uViw46PdNiMZhE0KezKpAWwmRnTYvnYhkyLB/CYSRH1VXoXoD7zNOdwleutwbAHPedmodRb3Y7CfrXQZQAyE1lI2Up8Vuk6uvl2ndmXp4y1gZ1jCPmTvS1p2Ss+ztcocH8UJS9mMkgjFe8ypETA9IQGf61QDWVml4fEzDMNtol9y6rwLaePuTZmsp/C7g9UuM2dlIW1HI4ZPZealTGCwfvgl97GaPoX662lOlWDyxxwU+TetcitKDGucM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

INVALID_PHYS_ADDR has very similar definitions across the code base. Hence
just move that inside header <liux/mm.h> for more generic usage. Also drop
the now redundant ones which are no longer required.

Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: iommu@lists.linux.dev
Cc: linux-s390@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: virtualization@lists.linux.dev
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/mm/mmu.c                  | 2 --
 arch/s390/boot/vmem.c                | 1 -
 drivers/vdpa/vdpa_user/iova_domain.h | 2 --
 include/linux/mm.h                   | 2 ++
 kernel/dma/swiotlb.c                 | 2 --
 5 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e80bb623ef53..1da02d908c30 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -470,8 +470,6 @@ static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 	mutex_unlock(&fixmap_lock);
 }
 
-#define INVALID_PHYS_ADDR	(-1ULL)
-
 static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm, gfp_t gfp,
 				       enum pgtable_type pgtable_type)
 {
diff --git a/arch/s390/boot/vmem.c b/arch/s390/boot/vmem.c
index cea3de4dce8c..fbe64ffdfb96 100644
--- a/arch/s390/boot/vmem.c
+++ b/arch/s390/boot/vmem.c
@@ -16,7 +16,6 @@
 #include "decompressor.h"
 #include "boot.h"
 
-#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
 struct ctlreg __bootdata_preserved(s390_invalid_asce);
 
 #ifdef CONFIG_PROC_FS
diff --git a/drivers/vdpa/vdpa_user/iova_domain.h b/drivers/vdpa/vdpa_user/iova_domain.h
index 775cad5238f3..a923971a64f5 100644
--- a/drivers/vdpa/vdpa_user/iova_domain.h
+++ b/drivers/vdpa/vdpa_user/iova_domain.h
@@ -17,8 +17,6 @@
 
 #define IOVA_START_PFN 1
 
-#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
-
 #define BOUNCE_MAP_SHIFT	12
 #define BOUNCE_MAP_SIZE	(1 << BOUNCE_MAP_SHIFT)
 #define BOUNCE_MAP_MASK	(~(BOUNCE_MAP_SIZE - 1))
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..543a5f780874 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -105,6 +105,8 @@ extern int mmap_rnd_compat_bits __read_mostly;
 # endif
 #endif
 
+#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
+
 #include <asm/page.h>
 #include <asm/processor.h>
 
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 0d37da3d95b6..a547c7693135 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -61,8 +61,6 @@
  */
 #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
 
-#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
-
 /**
  * struct io_tlb_slot - IO TLB slot descriptor
  * @orig_addr:	The original address corresponding to a mapped entry.
-- 
2.30.2


