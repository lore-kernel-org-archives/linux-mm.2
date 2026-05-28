Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5663CD5BD0
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465BE6B00A4; Wed, 27 May 2026 20:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1086B00A7; Wed, 27 May 2026 20:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4FC6B00A6; Wed, 27 May 2026 20:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F131B6B00A4
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC3411A06A5
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:35 +0000 (UTC)
X-FDA: 84814977870.21.9DE1D33
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0CB05C000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bf8uJoEP;
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lq4AwKr8R9qQP2NXNrabboMmqmkbQuMYszFqX3guJ70=;
	b=iQKKCGRNDZ0WagGOX44gWDB3hhMhJmMzIRnkuAP2AXkUwME9nGdOIVFEFcZuFaVjaPuW+d
	aoa4JKnhFP5feB/yo8MhVR9jkPHFl/w3UOiT8FEOYFE26do+Akmmws6ngcsrJXHuBtpPS9
	uZ8OW1/2GztAK/iX7MksgR14IeWBnIg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bf8uJoEP;
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928954; a=rsa-sha256;
	cv=none;
	b=QGr9UYqJPSzNqykD6FIb2dktF+queVHhN9a/HUoOwIZw8K+gtMoySzaqIZBm+Wl8tDz3sC
	R17z4W8IsG+UZi43S/wpp7s5FMf12qHdjPXSr6SHrw0qDAxNSbmXzZLvZG0dNmQMC7BW44
	jWQFPgn2QxLUFdL1xMrG/4GaKRwIIMQ=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 2520020B7185; Wed, 27 May 2026 17:42:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2520020B7185
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928943;
	bh=lq4AwKr8R9qQP2NXNrabboMmqmkbQuMYszFqX3guJ70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf8uJoEP1bHEgO11aiEzs2tCt8Rr2DofJbVrUNSAYY3Lh48wtWt3HP7cPpA0OiSEg
	 3tEvTK2F0AGJgaG844BmxZ48X5H84FHFpFWswgwrB6O5tIdqcqaytmu1iJ7nD9tc0t
	 TtXT9wa7PCLQIhvHzpl1EO2Nli5baFu1qRB++naU=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 15/20] mshv: Use page tracker to manage MSHV-owned pages and preserve with KHO
Date: Wed, 27 May 2026 17:41:57 -0700
Message-ID: <20260528004204.1484584-16-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ncqipykopuh4z377gfz638cbn4n76e35
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0CB05C000D
X-HE-Tag: 1779928953-661188
X-HE-Meta: U2FsdGVkX1+NRMtRU1WGLQKgh8CDVkU5T/AOZOW1YZkRT3+ShoKICTvP9I3LZYe/TbCvH3lCIoGe/3VIhSvt++VM1dfXr4/Lp5eMvsiwN8vPd5ROPeNjQEfv+hePRQie/EhVRupHHCOEnk0gD633D0rSmYDgfJn7zpaSzSVOrkbKRDzY685CooW75O0vUph8MeZj8xZwuEwhm1PZsjc1CyGGJB7ztOCQ0llZWQmbnUyX432JyRTBZcKSoYrKfF1D/MrxNQj+VBn6mdOzerNdI+R/q+ojwti8ZuFEFchoVeAp5SEn+h4pILWy+8MtpIFPGlkPXg9K2lJyh7hrSlGtvwro85PEg4AEa2Hocj9x/2hVFkoIiKPTIFIUcJTEuzwrPDhTYoPv5T98YYDL6fdRzWQo5RIIpPs+6KRSFRy8erD6Q50zNU1Tm0uyGPlOmNFrT/9XbGz31wgxZLh48GbwJ+H4UDIxViOjeXvA+zb0xgZpMwmmt63xnYFxzODC3PFaELzS5if4FjRNYfWH+dPuGnlxZg4vBp/JXDuOjYJSQmlus2nV6nMPv/qR2DMRwoV3ucEUnkwxtp0nq7ROdoDQPWO7g55cYlyGOka+SRPpkE3EiqNkqswm7LMt+YcXvQP+D+yQ1Ws4H0je4faVOKKB85w1ilWEsasn1rwnPrStKsB8rKSMFIJZ6WkUIuE7S3LPT2KqrAOmLVMSkUB6L2Rad9q13gD9wggDordGJR06GaHe8sBsTedqXhVI/OS5YAzdCLaGUqk+OJKtBmtRD60TF7Of274/0Md+qA2hFVI08ONT6BgWldAUVV0OAemdz/2rstfO6pbKsER7X4J/eow5kvBGpGCfGA3/VgjSD2/CHrSoXPkAXDu6vyr+KLZyu+fwIVmvgvPiNT8+Xh23trPT7iZpD2sYSPyd5X0Qixv+UemdwLYFF0SXTLUDfy4gpjiXjXr/Cm9HwPmD8M28FLk
 Su/JUbPc
 GzJ36C4ZoN6unToH/XQDD5uYdZZBd4Aho7A5Ttp3sWyE4URETgfJ7+ut9MRuQXt/SOXj3YEQDazE7iOew9shdcMuyg20jX8AUqjDCGaLn8LQe5BosXwv+khSZWq/d9T9oHcGBNZ+CztCAFViBw2mxaUtP0ZQL8wpXd01plzIlyzODONccioyqJ8iTE1kZKBkaxAeSEwdslr/DgfBNCaXhdkKDtWzszdkwxZLeFadEkWUhL4Ry3cS6PrKEJCnZUKGMTPEJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MSHV driver passes pages to MSHV for its exclusive use. A
subsequently kexec'd-to kernel must not use these pages, so
we need to register these pages with KHO.

- adapt hv_call_deposit_pages() and hv_call_withdraw_memory() to
  use tracker
- Use KHO to preserve MSHV-owned pages across kexec

Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 drivers/hv/Kconfig              |   3 +
 drivers/hv/Makefile             |   2 +-
 drivers/hv/hv_common.c          |   3 +
 drivers/hv/hv_proc.c            |  32 ++-
 drivers/hv/mshv_page_preserve.c | 374 ++++++++++++++++++++++++++++++++
 drivers/hv/mshv_page_preserve.h |  15 ++
 drivers/hv/mshv_root.h          |   1 +
 drivers/hv/mshv_root_hv_call.c  |  12 +-
 8 files changed, 434 insertions(+), 8 deletions(-)
 create mode 100644 drivers/hv/mshv_page_preserve.c
 create mode 100644 drivers/hv/mshv_page_preserve.h

diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index 2d0b3fcb0ff8..0c4ffc1c701b 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -74,6 +74,9 @@ config MSHV_ROOT
 	# e.g. When withdrawing memory, the hypervisor gives back 4k pages in
 	# no particular order, making it impossible to reassemble larger pages
 	depends on PAGE_SIZE_4KB
+	# Pages deposited to the hypervisor must be tracked and preserved
+	# across kexec to avoid memory corruption.
+	depends on KEXEC_HANDOVER
 	select EVENTFD
 	select VIRT_XFER_TO_GUEST_WORK
 	select HMM_MIRROR
diff --git a/drivers/hv/Makefile b/drivers/hv/Makefile
index 888a748cc7cb..49526ae704f9 100644
--- a/drivers/hv/Makefile
+++ b/drivers/hv/Makefile
@@ -21,7 +21,7 @@ mshv_vtl-y := mshv_vtl_main.o
 
 # Code that must be built-in
 obj-$(CONFIG_HYPERV) += hv_common.o
-obj-$(subst m,y,$(CONFIG_MSHV_ROOT)) += hv_proc.o
+obj-$(subst m,y,$(CONFIG_MSHV_ROOT)) += hv_proc.o mshv_page_preserve.o
 ifneq ($(CONFIG_MSHV_ROOT)$(CONFIG_MSHV_VTL),)
 	obj-y += mshv_common.o
 endif
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 6b67ac616789..8a593117e9b8 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -30,6 +30,7 @@
 #include <linux/set_memory.h>
 #include <hyperv/hvhdk.h>
 #include <asm/mshyperv.h>
+#include "mshv_root.h"
 
 u64 hv_current_partition_id = HV_PARTITION_ID_SELF;
 EXPORT_SYMBOL_GPL(hv_current_partition_id);
@@ -382,6 +383,8 @@ int __init hv_common_init(void)
 	if (hv_parent_partition()) {
 		hv_synic_eventring_tail = alloc_percpu(u8 *);
 		BUG_ON(!hv_synic_eventring_tail);
+
+		mshv_preserve_init();
 	}
 
 	hv_vp_index = kmalloc_array(nr_cpu_ids, sizeof(*hv_vp_index),
diff --git a/drivers/hv/hv_proc.c b/drivers/hv/hv_proc.c
index 57b2c64197cb..0392ea1f3cc5 100644
--- a/drivers/hv/hv_proc.c
+++ b/drivers/hv/hv_proc.c
@@ -8,6 +8,7 @@
 #include <linux/minmax.h>
 #include <linux/export.h>
 #include <asm/mshyperv.h>
+#include "mshv_root.h"
 
 /*
  * See struct hv_deposit_memory. The first u64 is partition ID, the rest
@@ -22,6 +23,7 @@ int hv_call_deposit_pages(int node, u64 partition_id, u32 num_pages)
 	int *counts;
 	int num_allocations;
 	int i, j, page_count;
+	int reg_i = 0, reg_j = 0;
 	int order;
 	u64 status;
 	int ret;
@@ -72,6 +74,18 @@ int hv_call_deposit_pages(int node, u64 partition_id, u32 num_pages)
 	}
 	num_allocations = i;
 
+	/* Register the pages for preservation across kexec */
+	for (i = 0; i < num_allocations; ++i) {
+		for (j = 0; j < counts[i]; ++j) {
+			ret = mshv_register_preserve_page(pages[i] + j);
+			if (ret) {
+				reg_i = i;
+				reg_j = j;
+				goto err_unregister;
+			}
+		}
+	}
+
 	local_irq_save(flags);
 
 	input_page = *this_cpu_ptr(hyperv_pcpu_input_arg);
@@ -90,19 +104,27 @@ int hv_call_deposit_pages(int node, u64 partition_id, u32 num_pages)
 	if (!hv_result_success(status)) {
 		hv_status_err(status, "\n");
 		ret = hv_result_to_errno(status);
-		goto err_free_allocations;
+		reg_i = num_allocations;
+		goto err_unregister;
 	}
 
 	ret = 0;
 	goto free_buf;
 
-err_free_allocations:
+err_unregister:
 	for (i = 0; i < num_allocations; ++i) {
-		base_pfn = page_to_pfn(pages[i]);
-		for (j = 0; j < counts[i]; ++j)
-			__free_page(pfn_to_page(base_pfn + j));
+		for (j = 0; j < counts[i]; ++j) {
+			if (i == reg_i && j == reg_j)
+				goto err_free_allocations;
+			mshv_unregister_preserve_page(pages[i] + j);
+		}
 	}
 
+err_free_allocations:
+	for (i = 0; i < num_allocations; ++i)
+		for (j = 0; j < counts[i]; ++j)
+			__free_page(pages[i] + j);
+
 free_buf:
 	free_page((unsigned long)pages);
 	kfree(counts);
diff --git a/drivers/hv/mshv_page_preserve.c b/drivers/hv/mshv_page_preserve.c
new file mode 100644
index 000000000000..a79725a74663
--- /dev/null
+++ b/drivers/hv/mshv_page_preserve.c
@@ -0,0 +1,374 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Preserve pages owned by Microsoft Hypervisor
+ *
+ * When handing pages to MSHV and kexec'ing, the next kernel needs to know which
+ * pages not to touch. Handles this preservation here.
+ *
+ * Copyright (C) 2026 Microsoft Corporation, Jork Loeser <jloeser@microsoft.com>
+ */
+
+#define pr_fmt(fmt) "mshv: " fmt
+
+#include <asm/mshyperv.h>
+#include <linux/kexec.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho_radix_tree.h>
+#include <linux/libfdt.h>
+#include <linux/reboot.h>
+#include "mshv_page_preserve.h"
+
+#define FDT_SUBTREE_MSHV "mshv_prsv_pt"
+#define MSHV_KHO_COMPAT_STR "mshv_kho-v1"
+
+static void *fdt_page;
+static struct kho_radix_tree preserved_pages_tree;
+
+/**
+ * mshv_register_preserve_page() - Register a page to be preserved by KHO
+ * @pg: pointer to the page to preserve
+ *
+ * Registers a single page to be preserved by KHO across kexec.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int mshv_register_preserve_page(struct page *pg)
+{
+	return kho_radix_add_key(&preserved_pages_tree, page_to_pfn(pg));
+}
+EXPORT_SYMBOL_GPL(mshv_register_preserve_page);
+
+/**
+ * mshv_unregister_preserve_page() - Unregister a page from KHO preservation
+ * @pg: pointer to the page to unpreserve
+ *
+ * Unregisters a page that was previously registered to be preserved by KHO.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int mshv_unregister_preserve_page(struct page *pg)
+{
+	return kho_radix_del_key(&preserved_pages_tree, page_to_pfn(pg));
+}
+EXPORT_SYMBOL_GPL(mshv_unregister_preserve_page);
+
+/* Preserve a single page identified by its PFN key with KHO */
+static int preserve_key_cb(unsigned long key, void *data)
+{
+	return kho_preserve_pages(pfn_to_page(key), 1);
+}
+
+/* Preserve a radix tree metadata page with KHO */
+static int preserve_table_cb(phys_addr_t phys, void *data)
+{
+	return kho_preserve_pages(phys_to_page(phys), 1);
+}
+
+static int create_fdt(void)
+{
+	int err;
+	void *fdt;
+	phys_addr_t root_table;
+
+	if (!fdt_page)
+		return -EINVAL;
+
+	fdt = fdt_page;
+
+	err = fdt_create(fdt, PAGE_SIZE);
+	if (err)
+		return err;
+	err = fdt_finish_reservemap(fdt);
+	if (err)
+		return err;
+	err = fdt_begin_node(fdt, "");
+	if (err)
+		return err;
+	err = fdt_property(fdt, "compatible", MSHV_KHO_COMPAT_STR,
+			   strlen(MSHV_KHO_COMPAT_STR) + 1);
+	if (err)
+		return err;
+	root_table = virt_to_phys(preserved_pages_tree.root);
+	err = fdt_property(fdt, "root_table", &root_table, sizeof(root_table));
+	if (err)
+		return err;
+	err = fdt_end_node(fdt);
+	if (err)
+		return err;
+	err = fdt_finish(fdt);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/**
+ * preserve_tree() - Preserve pages owned by Microsoft Hypervisor
+ *
+ * This gets called prior to kexec and is our signal to finally preserve the
+ * pages with KHO, and create & register the named FDT. We also need to freeze
+ * the tree, since we cannot communicate any later changes.
+ *
+ * Return: 0 on success, -errno on error.
+ */
+static int preserve_tree(void)
+{
+	const struct kho_radix_walk_cb preserve_cb = {
+		.key = preserve_key_cb,
+		.table = preserve_table_cb,
+	};
+	int err;
+
+	err = kho_radix_tree_freeze(&preserved_pages_tree);
+	if (err) {
+		pr_warn("%s() - kho_radix_tree_freeze() failed: %d\n",
+			__func__, err);
+		return err;
+	}
+
+	/* Populate the pre-allocated FDT page with current tree state */
+	err = create_fdt();
+	if (err) {
+		pr_warn("%s() - create_fdt() failed: %d\n", __func__, err);
+		return err;
+	}
+
+	/* Preserve both data- and meta-pages */
+	err = kho_radix_walk_tree(&preserved_pages_tree, &preserve_cb, NULL);
+	if (err) {
+		/* We could not preserve all pages and cannot kexec. */
+		pr_warn("%s() - kho_radix_walk_tree() failed: %d\n", __func__,
+			err);
+		return err;
+	}
+
+	err = kho_preserve_pages(virt_to_page(fdt_page), 1);
+	if (err) {
+		pr_warn("%s() - kho_preserve_pages(fdt) failed: %d\n", __func__,
+			err);
+		return err;
+	}
+
+	err = kho_add_subtree(FDT_SUBTREE_MSHV, fdt_page, PAGE_SIZE);
+	if (err) {
+		/* KHO will abort and undo all preservations. We cannot kexec. */
+		pr_warn("%s() - kho_add_subtree() failed: %d\n", __func__, err);
+		return err;
+	}
+
+	pr_debug("%s() - success\n", __func__);
+	return 0;
+}
+
+/*
+ * Reboot-callback triggering page preservation prior to kexec. Other reboots
+ * need no KHO preservation.
+ */
+static int reboot_cb(struct notifier_block *nb, unsigned long action,
+		     void *data)
+{
+	/* codes such as SYS_RESTART, SYS_HALT do not convey kexec specifically */
+	if (kexec_in_progress) {
+		int err;
+
+		/* Finalize handover: write KHO descriptors, flush metadata */
+		pr_debug("%s() - KHO-preserving page tree\n", __func__);
+		err = preserve_tree();
+		if (err)
+			panic("preserve_tree() failed - must not kexec: %d\n",
+			      err);
+	}
+	return NOTIFY_OK;
+}
+
+/**
+ * restore_tree() - Restore the page-tree state from KHO.
+ *
+ * Return: 0 on success, -ENOENT if no KHO subtree was found (i.e. this is
+ *         not a KHO boot), -EINVAL if the preserved FDT is malformed or
+ *         incompatible.
+ */
+static int __init restore_tree(void)
+{
+	void *fdt;
+	phys_addr_t fdt_pa;
+	int len;
+	int node;
+	const phys_addr_t *root_table_fdt_ptr;
+	int err;
+
+	err = kho_retrieve_subtree(FDT_SUBTREE_MSHV, &fdt_pa, NULL);
+	if (err)
+		return err;
+
+	fdt = phys_to_virt(fdt_pa);
+	node = fdt_path_offset(fdt, "/");
+	if (node < 0) {
+		pr_err("Could not find root node in KHO-preserved FDT.\n");
+		return -EINVAL;
+	}
+
+	if (fdt_node_check_compatible(fdt, node, MSHV_KHO_COMPAT_STR)) {
+		/*
+		 * This is unfortunate. We kexec'd into a kernel that isn't
+		 * compatible with prior preservations. Pages this kernel
+		 * considers available might actually be held by MSHV. The only
+		 * recourse is to reboot.
+		 */
+		const char *s = fdt_getprop(fdt, node, "compatible", &len);
+
+		if (s && len >= 0)
+			pr_err("Incompatible kernel: Current is %s, preserved is %.*s\n",
+			       MSHV_KHO_COMPAT_STR, len, s);
+		else
+			pr_err("Incompatible kernel: preserved misses 'compatible' mark.\n");
+		return -EINVAL;
+	}
+
+	root_table_fdt_ptr = fdt_getprop(fdt, node, "root_table", &len);
+	if (!root_table_fdt_ptr || len != sizeof(*root_table_fdt_ptr)) {
+		pr_err("Could not obtain root_table property from KHO-preserved FDT.\n");
+		return -EINVAL;
+	}
+
+	/* Restore struct page so it could be freed if needed */
+	if (!kho_restore_pages(fdt_pa, 1))
+		return -EINVAL;
+
+	fdt_page = phys_to_virt(fdt_pa);
+
+	err = kho_radix_init_tree(&preserved_pages_tree,
+				  phys_to_virt(*root_table_fdt_ptr));
+	if (err)
+		return -EINVAL;
+
+	pr_debug("Restored tracking from KHO.\n");
+	return 0;
+}
+
+/*
+ * Restore individual pages using KHO's helper during boot.
+ *
+ * Pages must be restored one at a time because they were deposited to
+ * the hypervisor individually and will be withdrawn individually later.
+ * Restoring them as a higher-order group would create compound pages
+ * that cannot be freed with __free_page().
+ */
+static int __init restore_key_cb(unsigned long key, void *data)
+{
+	if (!kho_restore_pages(PFN_PHYS(key), 1))
+		return -EINVAL;
+	return 0;
+}
+
+static int __init restore_table_cb(phys_addr_t phys, void *data)
+{
+	if (!kho_restore_pages(phys, 1))
+		return -EINVAL;
+	return 0;
+}
+
+/**
+ * restore_page_structs() - Restore page-structs so they can be __free_page()'d
+ *
+ * This is necessary because KHO-preserved pages are in a "weird" state
+ * post-kexec. While doing so here in bulk adds to boot time, there is no vetted
+ * alternative that would allow doing this later, when we cannot say which pages
+ * had been freshly added, and which came into the tree through KHO.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+static int __init restore_page_structs(void)
+{
+	const struct kho_radix_walk_cb cb = {
+		.key = restore_key_cb,
+		.table = restore_table_cb,
+	};
+
+	return kho_radix_walk_tree(&preserved_pages_tree, &cb, NULL);
+}
+
+/**
+ * alloc_tree() - Allocate a fresh page tree and FDT page.
+ *
+ * Called on fresh boot (no KHO data). Allocates an empty radix tree and
+ * the FDT page used to serialize state before kexec.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+static int __init alloc_tree(void)
+{
+	int err;
+
+	fdt_page = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!fdt_page)
+		return -ENOMEM;
+
+	err = kho_radix_init_tree(&preserved_pages_tree, NULL);
+	if (err) {
+		free_page((unsigned long)fdt_page);
+		fdt_page = NULL;
+		return err;
+	}
+
+	return 0;
+}
+
+static struct notifier_block reboot_notifier = {
+	.notifier_call = reboot_cb,
+	.priority = 0,
+};
+
+/**
+ * mshv_preserve_init() - Initialize the page preservation
+ *
+ * Upon return:
+ * - the tracker will be ready for use (restored post-kexec, or empty
+ *   post-reboot),
+ * - restored pages will be in a state that can be __free_page()'d,
+ * - KHO notification for preservation will be registered.
+ *
+ * Return: 0 on success, -errno on error.
+ */
+int __init mshv_preserve_init(void)
+{
+	int err;
+
+	if (!kho_is_enabled()) {
+		pr_err("KHO is disabled; page deposits will fail.\n");
+		return 0;
+	}
+
+	err = restore_tree();
+	if (!err) {
+		/* Restore struct pages so they can be __free_page()'d */
+		if (restore_page_structs())
+			/*
+			 * Unrestored struct pages would BUG when freed
+			 * at withdraw time.
+			 */
+			panic("Failed to restore MSHV page structs\n");
+	} else if (err == -ENOENT) {
+		pr_debug("Nothing to restore from KHO.\n");
+		if (alloc_tree()) {
+			pr_err("Could not allocate page tree; page deposits will fail.\n");
+			return 0;
+		}
+	} else {
+		/*
+		 * Pages from the prior kernel are held by MSHV but we
+		 * lost track of them -- memory corruption is inevitable.
+		 */
+		panic("Could not restore page tree from KHO: %d\n", err);
+	}
+
+	err = register_reboot_notifier(&reboot_notifier);
+	if (err)
+		/*
+		 * Deposits would succeed but pages would not be preserved
+		 * across kexec, causing memory corruption post-kexec.
+		 */
+		panic("Could not register reboot notification: %d\n", err);
+
+	return 0;
+}
diff --git a/drivers/hv/mshv_page_preserve.h b/drivers/hv/mshv_page_preserve.h
new file mode 100644
index 000000000000..0609002e5f1d
--- /dev/null
+++ b/drivers/hv/mshv_page_preserve.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026 Microsoft Corporation, Jork Loeser <jloeser@microsoft.com>
+ */
+
+#ifndef _MSHV_PAGE_PRESERVE_H
+#define _MSHV_PAGE_PRESERVE_H
+
+struct page;
+
+int mshv_preserve_init(void);
+int mshv_register_preserve_page(struct page *pg);
+int mshv_unregister_preserve_page(struct page *pg);
+
+#endif /* _MSHV_PAGE_PRESERVE_H */
diff --git a/drivers/hv/mshv_root.h b/drivers/hv/mshv_root.h
index 1f086dcb7aa1..362768786c17 100644
--- a/drivers/hv/mshv_root.h
+++ b/drivers/hv/mshv_root.h
@@ -18,6 +18,7 @@
 #include <linux/mmu_notifier.h>
 #include <uapi/linux/mshv.h>
 #include "mshv_trace.h"
+#include "mshv_page_preserve.h"
 
 /*
  * Hypervisor must be between these version numbers (inclusive)
diff --git a/drivers/hv/mshv_root_hv_call.c b/drivers/hv/mshv_root_hv_call.c
index cb55d4d4be2e..f5ff03318787 100644
--- a/drivers/hv/mshv_root_hv_call.c
+++ b/drivers/hv/mshv_root_hv_call.c
@@ -69,8 +69,16 @@ int hv_call_withdraw_memory(u64 count, int node, u64 partition_id)
 
 		completed = hv_repcomp(status);
 
-		for (i = 0; i < completed; i++)
-			__free_page(pfn_to_page(output_page->gpa_page_list[i]));
+		for (i = 0; i < completed; i++) {
+			struct page *pg = pfn_to_page(output_page->gpa_page_list[i]);
+			int res = mshv_unregister_preserve_page(pg);
+
+			WARN_ONCE(res, "Failed to unregister PFN %#llx\n",
+				  output_page->gpa_page_list[i]);
+
+			/* Free regardless -- HV has already released the page */
+			__free_page(pg);
+		}
 
 		if (!hv_result_success(status)) {
 			if (hv_result(status) == HV_STATUS_NO_RESOURCES)
-- 
2.43.0


