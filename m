Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B11DAC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DA86B010A; Mon, 21 Sep 2026 07:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF9B6B010C; Mon, 21 Sep 2026 07:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814346B010D; Mon, 21 Sep 2026 07:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6F36B010A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF9588014C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:05 +0000 (UTC)
X-FDA: 85237477290.06.A8511E1
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf02.hostedemail.com (Postfix) with ESMTP id 18FFC80009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TLLnNNxI;
	spf=pass (imf02.hostedemail.com: domain of 3bg6xagoKCKsgOZYYPQZceRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--vdonnefort.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3bg6xagoKCKsgOZYYPQZceRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mS8QTe3O0YSNViqoUNLsYRtEn1B1+bnqRzNqyeLclGU=;
	b=YTwnsmiJNbpu9FqLeYmVCfRzyKvo5a4m8o1iCpgtS646g0mz1C5BHM9xTKLsLh/IxuUJUo
	7RVIdVv1ZV5aIrIXLHMXDeJqEXi860biyKMRs4S3qOrHDIE4JIjIK446oem3YTS8Ytrze+
	bDLsgWapBTuUapIG6fp9tv4rrlE8Lvg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TLLnNNxI;
	spf=pass (imf02.hostedemail.com: domain of 3bg6xagoKCKsgOZYYPQZceRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--vdonnefort.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3bg6xagoKCKsgOZYYPQZceRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988464;
	b=kxZEJPfoUZzLdoiX+2c8l2jFDZlelxl6bZ/XbhNIb0pR17TYG1osg6UCJmq5AXSS+WVdA3
	gl8oSYlAgQELNJLWdg5bF5VTlnohMf0ebHPFRIgE0W4/Ty0y2ItXqzCXCNspbmMlBWdc9p
	XQVGROn6Y1IRSkY9Zu7tCo+fTGnFG6M=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c29452ecadeso327897866b.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789988463; x=1790593263; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mS8QTe3O0YSNViqoUNLsYRtEn1B1+bnqRzNqyeLclGU=;
        b=TLLnNNxItq4lauiK9S3OovXaBq1WqJadRx/Fb5yI2K9i1qiIczMA2bnTdBk6vEpkVh
         E5wf8RbS4gVYfphV4jT/PQwFvIwvOdRH9tU6+pYxumk97eNonzpScSCZFsuErjaCILpg
         xHErAt8mJx6s7R4Ngbono1a8PCd63cu6hNgzCf8H5QoIZ29ymTmEtMlE3K193iJ3mH8u
         lMwtOemLRdUGjAP07a5FdT9Jhv9ah0vKQt0ezogGYc7Xh7CiDHN5i68/uZv1mrWWAcNp
         pbiYQQ/d84k/M24clBVs7iMqlXQR5YPL+3jwvcrM0Toi0+Ry7dsay6S8AXd6qAfJAgaR
         HPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789988463; x=1790593263;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mS8QTe3O0YSNViqoUNLsYRtEn1B1+bnqRzNqyeLclGU=;
        b=BimfrOUhzS2tGKEN9eVDrQOF8JFbHNl2wQ0GupylZLXSBrQJNkVFTnEW9U++MUCLVk
         7FxPFUE7TIcRnSiKX0wB+WDGzko8OIYzpdb2Ke4L5fd5w1T3eKSgJziX45gdjxJkp0Gm
         9bF20Tx2k5jRl7yhpR2V1fh6U5DJxHRMZGmm8ApTeVJ6quMZoBK+Xa53HOmrcklYXIZf
         EXm1OpamJHnhY7MI9vay/KMnDmRbmcjq2UiSLOtcZW/Z1/CSxWQCwuGL8b3iyddvOgDB
         XW4bakduMfwvcK/OfEj0vsLpPHXe2srKOMlZrsqcKpIDfk9GPjYY4YBX0KXaA3T1tJV7
         vnSg==
X-Forwarded-Encrypted: i=1; AKwUvBwasaq98RTvpUxdRtXjrwyTNIe3GgzDIwozBSysJS/z3BBXwHB5VGrrvTVCPYtDWwAnj2pKTpnFVg==@kvack.org
X-Gm-Message-State: AFuF++kcAsbIe0wmC90eWxkUDPiYjh7/tQ4jcqOc7HHl21RcN1uCa1VW
	Dj9KwyEDJUSItO1ay4ip5j9Uf2bIURnnqf41L4HAQKzfXUx7X9OYdzyWBiufOCxECTru7n5r1YQ
	poVgJn0eIA7joIzqVHzV3vw==
X-Received: from ejbmb16.prod.google.com ([2002:a17:906:eb10:b0:c25:46b8:4594])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:94cd:b0:c29:3ea4:a219 with SMTP id a640c23a62f3a-c2a15eb3513mr916572766b.44.1789988462315;
 Mon, 21 Sep 2026 04:01:02 -0700 (PDT)
Date: Mon, 21 Sep 2026 12:00:47 +0100
In-Reply-To: <20260921110050.3977591-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260921110050.3977591-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921110050.3977591-6-vdonnefort@google.com>
Subject: [PATCH v2 5/8] firmware: arm_ffa: Introduce ffa-lend-pool
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 18FFC80009
X-Stat-Signature: my55yoxge3m17a6shjansmb45dwendi7
X-Rspam-User: 
X-HE-Tag: 1789988463-193350
X-HE-Meta: U2FsdGVkX190KK3OAk19eWqrK6GVJdYuZizisrjCGl9OPK6TmRU292NExY8xMqWhnrZxIKEEBkBDn3kwsynjvfq5Po0lE7OY8vHVNAc6WsXpU2lL5FPsmVSq94XH3PYSsKdkcXdxZuBIV1iHd68+tPgLkAzv5lcgqCJYxRpa4YX03+04UV8Hko5S79cmgz2vd95SWhO+ZTkHSsrA0gBqaSDRBnoBmEvdJPPWdJ1u98qOUWGH5x2b40o26W+kQ3q8WC5XuGiN4EpRVLPOk6QfRlmbQGLZ20ofRfWZVL/VWZybSOwuaD96X8dKepN6zhRZsEb00h8f7P0zo6WavnbfrBnLgGmeEI1C0bZShQI6xcn2qbRnFGJko0aUPr/d+/QY1doOfQtAHjv1iZnEARo8j2zBWe29wn2PlBRT36Nf42eowsr7QFekCFrwEoPlydgrYfObXyXCNHfJd4ij5wCL70mbXlV5i1SbrpSB1l9HPeCo5u0H0jaMRE8GoOojhZaE6mph/5eHfZW2LmGaycxax76dVxgTDh2/p6agazidGJBnD2NOLTzpa1kMuy9/CBK8+niWjyN1jWlgZw8XFsYf5HGomo4p90oQ+iu1f8DWvLcxSCRUAJAW3K7NvbE+F3Gdrux1koDwXMcgFeKkkfzP3ZQ5Qdtly/R7cg6K3xJbat9iqvid/TJPKINgpq2xqZHyg7KNjyGSSl1PoM9CvKBX7XJsgN/0O8GiXjAYq30y7xWFeSPXreb8dauifr6TnH6rz9mKCveb/8dB6EBZ0D4QpmlSnqggoMQws/XTLCjQz1Quz2m5K/KoFCZam5xmAtK3Ttq5xJ66JbDB1OsiNkjtyhalWrQsgltkWqx9hCjU1dqqxoGel+pngeUQQvSzn4PaphVTXLlhsBdAV232h2iiGYWm5EaJztwuWnNBjBsb1uKptCxovzu7Cs24nCgdBdqH1Xt8ez243b+/ebkqwMU
 YXSffN+7
 2ACBGYOYQ9hBxqcor1ylismMp6XPgYdTJ+tMKNVbW53NBAbpAMCw30mnjjr2BwDQck0qH3LWo1uxjTkgPDSHHNriGCBpKBX00elVETax9+kMabncZEdt9uGleE68Sxyt4lJ3eikbdSAdVwpC7KKwuU9NzCZwdrqQc7jmKs0vmBot4suTK7fejBpAKPglH/lNns34HdSGzhdL22SLx8Qav5bu9b9KTR+vJF2eaU3irwEPv7Anz6lOlKpxbDmLfL8O/IfMqtkzwey7SbNcLech1SKg25Zx4dGML/H4wFVh4WiqiCTSVqvjLh4rS89h3vtfSUaEvu4oTX3DAboGucJh8Sw1Eyl9GhlsVpPr26+SX6TydyYZIeKzksVuiTTb+dTolAgRaXegrlai2nAikBj8nqbVO7aqwVqrhDJFR88QhGf5n3uBsqQAXhlY+Br0pWf1rApeANgLZuxS/ySFn/oaDtRhC8/BTCf6OE8KK9P8tm96pE3X4Ou9xyw/mCW5CQ7AFzu51zgQSumwl8lpzvFkCyYc4v12wywHKHvinD0tuxWuDEXxaQ4f1EIC6NhtoFlBp2P2NmJGLu8/66tJCRHk3FbKEJZd+fTG3hFU3EJOu80SYhrfhjxEJfo7jeNcx/sgqGtDS3FjlfrCbI+Gl4EcA704b92UqUU2GPE4f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory is lent to the Secure world via FF-A, fatal CPU speculative
reads from Non-Secure can still occur as long as it retains a cacheable
mapping to that memory. Introduce the "arm,ffa-lend-pool"
reserved-memory CMA driver to unmap pages before lending
(ffa_prepare_lend()) and restore them upon reclaim
(ffa_lend_reclaimed()). Devices bind to the pool via the "memory-region"
DT property or via ffa_lend_pool_attach().

  reserved-memory {
      #address-cells = <0x2>;
      #size-cells = <0x2>;
      ranges;

      ffa_lend: ffa-lend-pool {
          compatible = "arm,ffa-lend-pool";
          reusable;
          size = <0x0 0x4000000>;
      };
  };

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 drivers/firmware/arm_ffa/Kconfig     |   5 +
 drivers/firmware/arm_ffa/Makefile    |   1 +
 drivers/firmware/arm_ffa/lend_pool.c | 261 +++++++++++++++++++++++++++
 include/linux/arm_ffa.h              |  23 +++
 4 files changed, 290 insertions(+)
 create mode 100644 drivers/firmware/arm_ffa/lend_pool.c

diff --git a/drivers/firmware/arm_ffa/Kconfig b/drivers/firmware/arm_ffa/Kconfig
index 5e3ae5cf82e8..66dbf74c37c3 100644
--- a/drivers/firmware/arm_ffa/Kconfig
+++ b/drivers/firmware/arm_ffa/Kconfig
@@ -19,3 +19,8 @@ config ARM_FFA_SMCCC
 	bool
 	default ARM_FFA_TRANSPORT
 	depends on ARM64 && HAVE_ARM_SMCCC_DISCOVERY
+
+config ARM_FFA_LEND_POOL
+	bool
+	default y
+	depends on ARM_FFA_TRANSPORT && CMA && OF_RESERVED_MEM
diff --git a/drivers/firmware/arm_ffa/Makefile b/drivers/firmware/arm_ffa/Makefile
index 168990a7e792..5ea3019c407b 100644
--- a/drivers/firmware/arm_ffa/Makefile
+++ b/drivers/firmware/arm_ffa/Makefile
@@ -6,3 +6,4 @@ ffa-core-objs := $(ffa-bus-y)
 ffa-module-objs := $(ffa-driver-y) $(ffa-transport-y)
 obj-$(CONFIG_ARM_FFA_TRANSPORT)  = ffa-core.o
 obj-$(CONFIG_ARM_FFA_TRANSPORT) += ffa-module.o
+obj-$(CONFIG_ARM_FFA_LEND_POOL) += lend_pool.o
diff --git a/drivers/firmware/arm_ffa/lend_pool.c b/drivers/firmware/arm_ffa/lend_pool.c
new file mode 100644
index 000000000000..e4348f5c618b
--- /dev/null
+++ b/drivers/firmware/arm_ffa/lend_pool.c
@@ -0,0 +1,261 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Arm FF-A Reserved Memory CMA driver for Memory Lending
+ *
+ * Prevents CPU speculative reads to secure memory by unmapping it from the
+ * kernel direct map. This works if rodata=full or if all CPUs in the system
+ * support BBML3 or if a reserved-memory is declared for this driver
+ * "arm,ffa_lend_pool".
+ *
+ * Copyright (C) 2026 Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <linux/arm_ffa.h>
+#include <linux/cleanup.h>
+#include <linux/cma.h>
+#include <linux/dma-map-ops.h>
+#include <linux/init.h>
+#include <linux/memblock.h>
+#include <linux/mm.h>
+#include <linux/of.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/rcupdate.h>
+#include <linux/suspend.h>
+#include <linux/set_memory.h>
+#include <linux/xarray.h>
+
+#include <linux/cacheflush.h>
+#include <asm/tlbflush.h>
+
+static DEFINE_XARRAY(ffa_lend_pool_devices);
+static atomic_t ffa_lend_pool_active;
+
+#define FFA_LEND_POOL_DISABLED	-1
+
+static bool ffa_lend_pool_can_set_direct_map(struct device *dev, struct page *page, u64 nr_pages)
+{
+	phys_addr_t addr, base, end;
+	size_t size;
+
+	if (can_set_direct_map())
+		return true;
+
+	if (!dev)
+		return false;
+
+	guard(rcu)();
+
+	if (xa_load(&ffa_lend_pool_devices, (unsigned long)dev) != dev)
+		return false;
+
+	if (WARN_ON_ONCE(!dev->cma_area))
+		return false;
+
+	addr = page_to_phys(page);
+	size = nr_pages << PAGE_SHIFT;
+	base = cma_get_base(dev->cma_area);
+	end = base + cma_get_size(dev->cma_area);
+
+	return addr >= base && (addr + size) <= end;
+}
+
+/**
+ * ffa_prepare_lend() - Prepare a memory region to be lent in FF-A
+ * @dev:	Device attached to the lend pool
+ * @page:	First page of the memory region
+ * @nr_pages:	Number of pages
+ *
+ * When memory is lent via FF-A, TrustZone transitions it to the secure state.
+ * As long as Arm CPUs retain a valid mapping to that now-secure memory, they
+ * can speculatively read it, which is fatal on some systems.
+ *
+ * ffa_prepare_lend() prevents this by unmapping the memory range from the
+ * kernel's direct map.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int ffa_prepare_lend(struct device *dev, struct page *page, u64 nr_pages)
+{
+	struct page *p, *end;
+	unsigned long addr;
+	int ret;
+
+	if (!ffa_lend_pool_can_set_direct_map(dev, page, nr_pages))
+		return -ENODEV;
+
+	/* provides full ordering */
+	if (!atomic_add_unless(&ffa_lend_pool_active, 1, FFA_LEND_POOL_DISABLED))
+		return -EBUSY;
+
+	end = page + nr_pages;
+	for (p = page; p < end; p++)
+		flush_dcache_page(p);
+
+	ret = __set_direct_map_invalid_noflush(page, nr_pages);
+	if (ret) {
+		atomic_dec(&ffa_lend_pool_active);
+		return ret;
+	}
+
+	addr = (unsigned long)page_address(page);
+	flush_tlb_kernel_range(addr, addr + (nr_pages << PAGE_SHIFT));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ffa_prepare_lend);
+
+/**
+ * ffa_lend_reclaimed() - Restore a reclaimed FF-A memory region
+ * @dev:	Device attached to the lend pool
+ * @page:	First page of the memory region
+ * @nr_pages:	Number of pages
+ *
+ * Restores a memory range into the kernel's direct mapping. It must be called
+ * after a successful FF-A memory reclaim invocation.
+ */
+void ffa_lend_reclaimed(struct device *dev, struct page *page, u64 nr_pages)
+{
+	if (!ffa_lend_pool_can_set_direct_map(dev, page, nr_pages))
+		return;
+
+	__set_direct_map_default_noflush(page, nr_pages);
+
+	atomic_dec_return_release(&ffa_lend_pool_active);
+}
+EXPORT_SYMBOL_GPL(ffa_lend_reclaimed);
+
+static int ffa_lend_pool_pm_notify(struct notifier_block *nb, unsigned long mode, void *data)
+{
+	/* Prevent hibernation which would try to access lent memory */
+	switch (mode) {
+	case PM_HIBERNATION_PREPARE:
+		if (atomic_cmpxchg_acquire(&ffa_lend_pool_active, 0, FFA_LEND_POOL_DISABLED))
+			return notifier_from_errno(-EBUSY);
+		break;
+	case PM_POST_HIBERNATION:
+		atomic_set(&ffa_lend_pool_active, 0);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block ffa_lend_pool_pm_nb = {
+	.notifier_call	= ffa_lend_pool_pm_notify,
+};
+
+static const struct reserved_mem_ops ffa_lend_pool_ops;
+
+static struct reserved_mem *ffa_lend_pool_get_rmem(void)
+{
+	struct reserved_mem *rmem;
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "arm,ffa-lend-pool");
+	if (!np)
+		return NULL;
+
+	rmem = of_reserved_mem_lookup(np);
+	of_node_put(np);
+
+	if (WARN_ON_ONCE(rmem && rmem->ops != &ffa_lend_pool_ops))
+		return NULL;
+
+	return rmem;
+}
+
+/**
+ * ffa_lend_pool_attach() - Attach a device to the FF-A lend pool
+ * @dev:	Device to attach
+ *
+ * FF-A devices are dynamically discovered and might not have an associated
+ * device tree node with a "memory-region" phandle. In that case, drivers must
+ * use this function to attach to the "arm,ffa-lend-pool" reserved memory
+ * region.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int ffa_lend_pool_attach(struct device *dev)
+{
+	struct reserved_mem *rmem = ffa_lend_pool_get_rmem();
+
+	return rmem ? rmem->ops->device_init(rmem, dev) : -ENODEV;
+}
+EXPORT_SYMBOL_GPL(ffa_lend_pool_attach);
+
+/**
+ * ffa_lend_pool_detach() - Detach a device from the FF-A lend pool
+ * @dev:	Device to detach
+ *
+ * Releases the device from the "arm,ffa-lend-pool" reserved memory region.
+ */
+void ffa_lend_pool_detach(struct device *dev)
+{
+	struct reserved_mem *rmem = ffa_lend_pool_get_rmem();
+
+	if (rmem)
+		rmem->ops->device_release(rmem, dev);
+}
+EXPORT_SYMBOL_GPL(ffa_lend_pool_detach);
+
+static int __init ffa_lend_pool_setup(unsigned long node, struct reserved_mem *rmem)
+{
+	struct cma *cma;
+	int ret;
+
+	/* Limited by ffa_lend_pool_active */
+	if (rmem->size / PAGE_SIZE > INT_MAX)
+		return -E2BIG;
+
+	if (!IS_ALIGNED(rmem->base | rmem->size, CMA_MIN_ALIGNMENT_BYTES)) {
+		pr_err("FF-A lend pool: incorrect alignment of CMA region\n");
+		return -EINVAL;
+	}
+
+	ret = memblock_mark_ptemap(rmem->base, rmem->size);
+	if (ret)
+		return ret;
+
+	ret = cma_init_reserved_mem(rmem->base, rmem->size, 0, rmem->name, &cma);
+	if (ret) {
+		pr_err("FF-A lend pool: unable to setup CMA region (%d)\n", ret);
+		memblock_clear_ptemap(rmem->base, rmem->size);
+		return ret;
+	}
+
+	register_pm_notifier(&ffa_lend_pool_pm_nb);
+	rmem->priv = cma;
+
+	return 0;
+}
+
+static int ffa_lend_pool_device_init(struct reserved_mem *rmem, struct device *dev)
+{
+	int ret;
+
+	if (!can_set_direct_map_range(pfn_to_page(PHYS_PFN(rmem->base)), rmem->size / PAGE_SIZE)) {
+		pr_err("FF-A lend pool: reserved memory cannot be unmapped in direct map\n");
+		return -EINVAL;
+	}
+
+	dev->cma_area = rmem->priv;
+
+	ret = xa_err(xa_store(&ffa_lend_pool_devices, (unsigned long)dev, dev, GFP_KERNEL));
+	if (ret)
+		dev->cma_area = NULL;
+
+	return ret;
+}
+
+static void ffa_lend_pool_device_release(struct reserved_mem *rmem, struct device *dev)
+{
+	xa_erase(&ffa_lend_pool_devices, (unsigned long)dev);
+	dev->cma_area = NULL;
+}
+
+static const struct reserved_mem_ops ffa_lend_pool_ops = {
+	.node_init	= ffa_lend_pool_setup,
+	.device_init	= ffa_lend_pool_device_init,
+	.device_release = ffa_lend_pool_device_release,
+};
+RESERVEDMEM_OF_DECLARE(ffa_lend_pool, "arm,ffa-lend-pool", &ffa_lend_pool_ops);
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index e71d83ee0aef..8608847931cc 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -519,4 +519,27 @@ struct ffa_ops {
 	const struct ffa_notifier_ops *notifier_ops;
 };
 
+struct page;
+
+#if IS_ENABLED(CONFIG_ARM_FFA_LEND_POOL)
+int ffa_lend_pool_attach(struct device *dev);
+void ffa_lend_pool_detach(struct device *dev);
+int ffa_prepare_lend(struct device *dev, struct page *page, u64 nr_pages);
+void ffa_lend_reclaimed(struct device *dev, struct page *page, u64 nr_pages);
+#else
+static inline int ffa_lend_pool_attach(struct device *dev)
+{
+	return -ENODEV;
+}
+static inline void ffa_lend_pool_detach(struct device *dev)
+{
+}
+static inline int ffa_prepare_lend(struct device *dev, struct page *page, u64 nr_pages)
+{
+	return -ENODEV;
+}
+static inline void ffa_lend_reclaimed(struct device *dev, struct page *page, u64 nr_pages)
+{
+}
+#endif
 #endif /* _LINUX_ARM_FFA_H */
-- 
2.55.0.1082.g2b9226bbc0-goog


