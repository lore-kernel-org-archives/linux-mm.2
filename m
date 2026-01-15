Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4800D41149
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185EF6B00B5; Thu, 15 Jan 2026 04:22:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130A26B00B7; Thu, 15 Jan 2026 04:22:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025A76B00B8; Thu, 15 Jan 2026 04:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6FE26B00B5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:22:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7BB78A6EA
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:37 +0000 (UTC)
X-FDA: 84333657954.18.E04B5E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 173FAA000F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LRbgYqDO;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFlP4Idd25/PnSKNwRGdtSPLUlKttMeeoMu0ziQTUBg=;
	b=TULCgkjbVQq7kRTxl1g0zQaBSCs7cO2QOo6Xd2zceWJ3dhrPoj+aquTFO7Fh+Tg9GRHJkp
	VL5xdMF1JeYR7Gxnq7WtRT7LvFtOQvFRMxH8P8f3l6k/ZxUcmSl9t1yBVynDf6OHOm8t/2
	vS9A928bh8gaJVFYMPmdYDGejofGqbA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LRbgYqDO;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468956; a=rsa-sha256;
	cv=none;
	b=d0359OEviyzlkugh3h1CWo4D2NreqsEtZZ0oJ/D6WugI8MkgzovHC2WVUn7X6XQLQ//PZo
	RaIgO3X/NZjf9ZKt/nK6CGdC8sDOWVKTBRZAmwbXt+9YOTI3rDVthDyGmjFS0X1UbKJezX
	Jel4qXnALfCOy4gh8QRGrkQLv29Vj70=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B04543431;
	Thu, 15 Jan 2026 09:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDB7C19421;
	Thu, 15 Jan 2026 09:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468955;
	bh=orOF2wsFt94hkjmk1N2Zd+ddx/S2GWQX029b6WMD7uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRbgYqDO+Qlb0LQafvw3c7vh6olSFHEWpoVPHnglqGVWBWAvL6mio/t/6X16ULSXK
	 FSOblh+jDXnKh4C21qvqKUxPVOFHkhrB804ixHZYBEzqqUCCKLU63box7Drii9Un6t
	 jovNzGAFhwi3NhW7Bqk4cxUabQQtqppyf5fuzet0HoMCxuknRd5nLZ5jZ6TbVXXiIi
	 F3EELF8IAdsQvaP/N6b0fH1YwhSMNWwkqztLygRrxQc5vqpkuybT1skrhq8qIocapn
	 56+HuY0+BBbYByKJinvqL6U5mfk1Vmrjy2M+8qE3msi6/8SePi9VT1tL6En/qA+NOz
	 jVAzQzpa5cGGA==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 19/23] mm: rename balloon_compaction.(c|h) to balloon.(c|h)
Date: Thu, 15 Jan 2026 10:20:09 +0100
Message-ID: <20260115092015.3928975-20-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yihguk6d6cddqd7k71utx4s8cwpyfpts
X-Rspam-User: 
X-Rspamd-Queue-Id: 173FAA000F
X-Rspamd-Server: rspam08
X-HE-Tag: 1768468955-130234
X-HE-Meta: U2FsdGVkX18093ntpoBaBy3XC0jzr/UURvIzWt8u1wM4x3USJkdvFMjJ47f5eFZY5WfWmzJ/r+MC8mBL4w5hkNUiCokZc323NMDVcFOHee6Q1eb+kLpwzBuWTg7BHGnMtArS/aYgbjRwbUMzI6ZdBpLY4KVMCrXMrmOaB40cQIraVau4NtzPiBdgdhDYqRISvqqH9hA32z4g/Cdv32tdQqv0IxHgYMmKVl1lFtJ43DBnevXRmasRpOZ8enVkEc7tkCUuGrsluRakptAf3ETauVvPuhTSjdP7Y+6/4UvLpkfBi14OTVrLRuvkogQebj7wJvOTs55Xwdo1tNLtqPAQqswFnd5TjjuUFzubDbXw7T0R5B4afH+L3kAse2181w+54LOAR+BIDyu7mTOPUn/yDLBFLiGmCBOFzp11aOo1M11g/pT1Q1lT8lTOoCN3YNv2tPgNy6e3lGjvGJA1DsedRMMKqtFTr/5GkMcNXl1IaZsfIqpVZYS1bpKCpxkGLasJQj5POXqAvLuwhm2I3IuhskkPIN9/pA1n4TgV5F/2KoL87mVRL/yvc1t5X36yejmvVVg3+Syl3RJbbiCexstzzCywUbS2lWz+X3eAaIAZVsGUcYGTcItAATpZZJEvIblVTeOltMENRVD9wvD2QvTAaeulJkYfzK4V1qcJM+POoAzuMrrCAxZPjU6sL6jc+Mb0axJHO9MWSgW2qmYzQk01Dgwe0ACxl8sZGBtnXq66oaUH0ogadCxmFuMPVWf8ZOJb0X8L2xWbFjyDtmEUmb/RnpDliWVOh7u7VzLRBj3t2H8a9W+hpX42gkEeJwwFieiCJWNAEUZD6Gw9GKEHwoTgOuXPcNJjlo2Ftck5keX6X9KZ3eqJ7d22u9CIGa4Q8J8M5SKOpLWfLl3ACo3POvz+gXh+QrAsvtbTZVJGFxmlupj6t/KW6dApkG/7Dt4X1Lgk0VdPijU0cMxk36Vkxn7
 60bAxl36
 zXc1EUYc+adibO/ZhT8JP7lXTm2JeRrzyqjkvjvDblJdF+oR9tXRTkUjV/r+IpTP2sZ0h2uyR/d2/T/nuIccHFx+39bnojaTmuWVL/8CuNsimM1QDUMPyVc8Nhfx5wTU/QDnTY+htUwk4VdeEtAp71MrPhZIejcFIsP9jms0c58detwoFiZACGL23/GjUjjZV9y6Nqnf+Fm1rHxQjqdm8SgdzUrUFo6EtQKuQs1Joi9l4RiSE4WEuTTVo8nZETmD2P1yDlBhOa9odzvCO4bHA63W4Dnrc62cjV6wSG2az7GN78Uy3NjvhO7WlSqwGno2ZJmXcj5TEkJJhLO6UaC0S1hhZ/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Even without CONFIG_BALLOON_COMPACTION this infrastructure implements
basic list and page management for a memory balloon.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 Documentation/core-api/mm-api.rst                 |  2 +-
 MAINTAINERS                                       |  4 ++--
 arch/powerpc/platforms/pseries/cmm.c              |  2 +-
 drivers/misc/vmw_balloon.c                        |  2 +-
 drivers/virtio/virtio_balloon.c                   |  2 +-
 include/linux/{balloon_compaction.h => balloon.h} | 11 +++++------
 mm/Makefile                                       |  2 +-
 mm/{balloon_compaction.c => balloon.c}            |  7 +++----
 8 files changed, 15 insertions(+), 17 deletions(-)
 rename include/linux/{balloon_compaction.h => balloon.h} (92%)
 rename mm/{balloon_compaction.c => balloon.c} (98%)

diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
index 68193a4cfcf52..aabdd3cba58e8 100644
--- a/Documentation/core-api/mm-api.rst
+++ b/Documentation/core-api/mm-api.rst
@@ -130,5 +130,5 @@ More Memory Management Functions
 .. kernel-doc:: mm/vmscan.c
 .. kernel-doc:: mm/memory_hotplug.c
 .. kernel-doc:: mm/mmu_notifier.c
-.. kernel-doc:: mm/balloon_compaction.c
+.. kernel-doc:: mm/balloon.c
 .. kernel-doc:: mm/huge_memory.c
diff --git a/MAINTAINERS b/MAINTAINERS
index 0d044a58cbfe0..de8f89ca1149f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27536,9 +27536,9 @@ M:	David Hildenbrand <david@kernel.org>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 F:	drivers/virtio/virtio_balloon.c
-F:	include/linux/balloon_compaction.h
+F:	include/linux/balloon.h
 F:	include/uapi/linux/virtio_balloon.h
-F:	mm/balloon_compaction.c
+F:	mm/balloon.c
 
 VIRTIO BLOCK AND SCSI DRIVERS
 M:	"Michael S. Tsirkin" <mst@redhat.com>
diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 7fd8b3d7e7637..7a3c4922685ab 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -19,7 +19,7 @@
 #include <linux/stringify.h>
 #include <linux/swap.h>
 #include <linux/device.h>
-#include <linux/balloon_compaction.h>
+#include <linux/balloon.h>
 #include <asm/firmware.h>
 #include <asm/hvcall.h>
 #include <asm/mmu.h>
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 53e9335b6718c..7fd3f709108c2 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -29,7 +29,7 @@
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/balloon_compaction.h>
+#include <linux/balloon.h>
 #include <linux/vmw_vmci_defs.h>
 #include <linux/vmw_vmci_api.h>
 #include <asm/hypervisor.h>
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 6ae00de78b61b..de8041c3285a1 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -13,7 +13,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/balloon_compaction.h>
+#include <linux/balloon.h>
 #include <linux/oom.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon.h
similarity index 92%
rename from include/linux/balloon_compaction.h
rename to include/linux/balloon.h
index 7757e0e314fdb..82585542300d6 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon.h
@@ -1,8 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * include/linux/balloon_compaction.h
- *
- * Common interface definitions for making balloon pages movable by compaction.
+ * Common interface for implementing a memory balloon, including support
+ * for migration of pages inflated in a memory balloon.
  *
  * Balloon page migration makes use of the general "movable_ops page migration"
  * feature.
@@ -35,8 +34,8 @@
  *
  * Copyright (C) 2012, Red Hat, Inc.  Rafael Aquini <aquini@redhat.com>
  */
-#ifndef _LINUX_BALLOON_COMPACTION_H
-#define _LINUX_BALLOON_COMPACTION_H
+#ifndef _LINUX_BALLOON_H
+#define _LINUX_BALLOON_H
 #include <linux/pagemap.h>
 #include <linux/page-flags.h>
 #include <linux/migrate.h>
@@ -75,4 +74,4 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 	balloon->migratepage = NULL;
 	balloon->adjust_managed_page_count = false;
 }
-#endif /* _LINUX_BALLOON_COMPACTION_H */
+#endif /* _LINUX_BALLOON_H */
diff --git a/mm/Makefile b/mm/Makefile
index 9175f8cc65658..1e31e0a528dc1 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -122,7 +122,7 @@ obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_NUMA_MEMBLKS) += numa_memblks.o
 obj-$(CONFIG_NUMA_EMU) += numa_emulation.o
-obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
+obj-$(CONFIG_MEMORY_BALLOON) += balloon.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
diff --git a/mm/balloon_compaction.c b/mm/balloon.c
similarity index 98%
rename from mm/balloon_compaction.c
rename to mm/balloon.c
index f41e4a179a431..5734dae81e318 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon.c
@@ -1,15 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * mm/balloon_compaction.c
- *
- * Common interface for making balloon pages movable by compaction.
+ * Common interface for implementing a memory balloon, including support
+ * for migration of pages inflated in a memory balloon.
  *
  * Copyright (C) 2012, Red Hat, Inc.  Rafael Aquini <aquini@redhat.com>
  */
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/export.h>
-#include <linux/balloon_compaction.h>
+#include <linux/balloon.h>
 
 /*
  * Lock protecting the balloon_dev_info of all devices. We don't really
-- 
2.52.0


