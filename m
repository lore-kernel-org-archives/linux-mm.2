Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68726C624D5
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9696B00A1; Wed,  2 Sep 2026 06:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDC76B00A2; Wed,  2 Sep 2026 06:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DD66B00A3; Wed,  2 Sep 2026 06:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCD3F6B00A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:51:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7031DA01A9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:20 +0000 (UTC)
X-FDA: 85168505520.03.C65B795
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf27.hostedemail.com (Postfix) with ESMTP id BCC0E40006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ej739BOf;
	spf=pass (imf27.hostedemail.com: domain of 3pf-XagoKCGATBMLLCDMPREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3pf-XagoKCGATBMLLCDMPREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnnAKTx0rWFGRttv0vRYvbBX3qhJSeyXfYhwCY9t/xQ=;
	b=5G3ZmaWVypBT1nCJ6tDxKIXlca7NQp9kdMWewg6K4Wn5rlQ+s7zf0GDT4Is4qR07XxdqPH
	znsdQ7/H9upuVfSi6kE0Tv2xh6pyqpI1gkI2DqYuUT2+uyiqJHVyRR/Qr/Nf5RnN54WkQQ
	WO6L/oJJlTOdyPuw0IKVx3JbQI/em1o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346278;
	b=b8Yu4gjbKvP4FeA8cA5Pa6MU7UYT+ssGYoL+oyJV00GBDcnjYQvZVwam7cdVfuQN0oiEgi
	P9D1z4f47PY9NSxuhrJon4+ilRlzNb12ynw56OINEc6UbJpf7hB6OuqU2vXabmMxKWIAnO
	w9KkuCtE5NfrTngehj2bwy5ZdIEcBlU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ej739BOf;
	spf=pass (imf27.hostedemail.com: domain of 3pf-XagoKCGATBMLLCDMPREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3pf-XagoKCGATBMLLCDMPREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495529a93f9so8306095e9.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 03:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788346277; x=1788951077; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xnnAKTx0rWFGRttv0vRYvbBX3qhJSeyXfYhwCY9t/xQ=;
        b=ej739BOfkRbLrmW6intCOhWmmEp7rBj/Rts7VSF+IqMkiwME/Sg+k+ZlIQNbCUlqSJ
         ZaZx/13boaYb7iFOIouBqw6QbkEouj82wXC4QNYh/Jy8DywoBrIM1D2Q9t0t9BVtNCaz
         ew5EhXE604sEIDjQ7H9d65Qc9vnv29sYmHsvRcNIWXM0bRBwQ7LTfQClaOVrt0pTkJrd
         iE/O5cm6mf33t2gMX0gWduwQGwHLNClSb0PaA3tmDQ+kNU1K8+uIf+w6rn6+YDzc6t6+
         GmrxBkRxwItdKl4dc74JnOKp40YLfHJtyc6p/otbhMvnVbaeN6gXrnzYX/8qTZ/X2/lR
         RYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346277; x=1788951077;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xnnAKTx0rWFGRttv0vRYvbBX3qhJSeyXfYhwCY9t/xQ=;
        b=JZ60rfmewdUxYtPC0FJCPM+LpO69qWlVwiTtXR7Euvz7I3MluQxcA7IwozxBE+zq22
         u8iJgrX4Q52jS89tos6Vg1/WIjN0i/VhGPd1LzerKW01HxVFKOvfBO0K+VFOqhNrwS6J
         r/0FMDH+fnlEurokawR+qiU8tG7qgLK9sRnPbs4eRbnpE05u38nnKpFe4g0nriN18X2a
         Ale5neurtUpXU+Gtvt9aBs91+xuet3g5YY5fI8yQ16J7E25qNQgjGqtRfKbYeLaHMBBi
         xDrVblyUbx2AsIfaUr9G/G1wKD4/5vve4w1CFzrD2SOPbVGuVhSMz+79lDMD4rG6bpHX
         Fabw==
X-Forwarded-Encrypted: i=1; AHgh+RpcfTLI98NmsPZlvpGETKDtvAF9Kt3RpgSMMVCiHAa9VnndG5L1XK5FeMcSp6EhQwVS8scfMve9dw==@kvack.org
X-Gm-Message-State: AFuF++la+vnK7Pc8NWCVEq3cbvXxcRssmiQaR2qh18uiWiQd0BNzQ2FM
	iR83eLAkBxD1mp7Uj/qOg0XLBeoQB0qQd6b5+CuaVbxC/cFd0GfLoOPB98TgxJtZpE3tHPqAIKE
	0yuQL5ev6YeSm1cSFghPsBg==
X-Received: from wmqh12.prod.google.com ([2002:a05:600c:350c:b0:496:c04d:501e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:310f:b0:49b:c8e:a211 with SMTP id 5b1f17b1804b1-49ce57f27e8mr57275175e9.5.1788346277042;
 Wed, 02 Sep 2026 03:51:17 -0700 (PDT)
Date: Wed,  2 Sep 2026 11:47:11 +0100
In-Reply-To: <20260902104712.2399797-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260902104712.2399797-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902104712.2399797-10-vdonnefort@google.com>
Subject: [PATCH v9 09/10] firmware: arm_ffa: Introduce ffa-lend-pool
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BCC0E40006
X-Stat-Signature: gkmuhdfybmmc15ybtco37h1imm9da398
X-HE-Tag: 1788346278-597993
X-HE-Meta: U2FsdGVkX1/XIY+QmRPQgRy+/9iWhEV5JwsBS7mdJKWqCVGKy+IDFHl2xsCvoUL72PQwDKHnvQmNMCqgNkz/uyWi692pcmMgxhE3Bxq2sriTSn2JOlw5Z6StXsQe8aQV6yXzgCDWBm0tDR1xcIF7N8n1rCPI6355s/+wid73t6sFrWlYfKsNQOHkg1UMFGEgIYPHxadUCTW1bTmEcwTNuPLH8ukyAlKp8S3PiNZrWPd0NrcpMC9Yb6XpXE5fq7qFrmHhdsJue+mTZDDpxID06g65cRB2sst0+1x/InOWg9dC8dNS8/ViWGYsUNIMTgCwKvrP8d2KR4pwWc6ojhNHeFv0jpnxUnvD9ETvaAttOaAxgM2FO7PJFAtp43HcQklvvXtf5Xw8dMc6T83bzstcAhg8UQ+egLyqJtlMIlkFAI2x1EcoyqOSrOl1QQ5X23TTapoVhWvGouWEmcbr4MQKLWe38pluUNmKD1Ji3FXWUMIVYOEBhJpTfe7CZ/m4RWhP2fjhyAI3CtXVVUXoAOpm2exRfI5y6KKNM8mV4gcPbGFP30vhs6Hg6g4bO7MRNN0EvvUxX2MSCK7dnKrGDdgOFyrQLLkgulkmQRRjIYfvHtyBmKfwuB9ecwZ2/N05zrMSm9jVR1FcvL2j8eaneAX5dY2dBFOCQMEubTkAKa0qoTyNXuCaQ1FthOL0S8iZA6WsMlYMVE5QSs0PAPFSUlQhfDRubxoucUyfAcYDPCOD1er3TQ876VYW8vBEdU/GE/bHNKb8TQFrPLE4FTTd2M9pFAHq5VPFBk+cXtm+HVhHM/XxWdd8EhbwS7Wv4GNTzg4G780+SSy4cJ43LvlbL45NIaSFap+n3LRYZt/d5xPCLtPhaLrOb2/kAtdBeA4/c8NYFsbVu4T2Ws6NosvVUspJzXygE2lpuq/pEgWn7+LGZKhF1n2ZswWMyQtOfXb8YSlZw4DszAHmz/kokNDR65v
 lgQF1QDH
 kBkEh1QFQyb/T/SucUaVGO1dg/OCxZFSuLFzIQfaMaKSeAGuuOsEyzzlTi+qjzpi8t6uLiHVaiGR4S4TVBoFqkOvUYPPQy3A9zYQfgDxWVGIqf9Tk322+j17jS2jVM1ZfUhao/ZTtALHRQGFVPkS1PsVUEDQs/x4WZlE51Ud+KjqoNvBCxY0V1+l0MQa9QzGdoPGGNBaac2Rm7jLSij2EQwiJZBmohxq2Ja2POMdgipzA7MmNpATJKEt1vRv+y+sgSccCxkTLGsSP0LWpF8TfZQ2Ufb/vXOjyByhKy4sa2FxAxULC43LubnmYIuq/vYZ5WOZPJEq2AbNnoRuIupFVsmh6ZqSpn5va87aAhUSTdK9ZMgVPJt8vJZm4uW48M4RtGsbqPtuBlA0JgHegEihHpjfND18135KJpyS+S9M1q3Kr7Z0ewpYqgEcwgZTCrNRWtlKeuhrBsDSzAGHLbOGWssQLHFWyD8qEHaflvD1Xr45zkphLaJpk+EtD6BXpBBiNqgeVAGuTXSqd3IBIEotaccQgJeP5FTSFtfSmCp0u0+cjrvNO5PSBtfKLBfzgNXC2YvlgsmxFi3ffki/LnIbxCkdZhRfwZ+3c0mepQ5Q3F5oaKJUmgCMviKmq3/SKbQjGuxcHIOcqIb4xl8bUNjA0q134Zr6mtG9GdBfi
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
          ll-map;
          size = <0x0 0x4000000>;
      };
  };

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

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
index 000000000000..67a36f5d5aa6
--- /dev/null
+++ b/drivers/firmware/arm_ffa/lend_pool.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Arm FF-A Reserved Memory CMA driver for Memory Lending
+ *
+ * Prevents CPU speculative reads to secure memory by unmapping it from the
+ * kernel direct map. This only works if the reserved-memory is mapped at the
+ * last-level ("ll-map;" or "rodata=full") or if all CPUs in the system support
+ * BBML3.
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
+#include <linux/mm.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/rcupdate.h>
+#include <linux/set_memory.h>
+#include <linux/xarray.h>
+
+static DEFINE_XARRAY(ffa_lend_devices);
+
+static bool ffa_lend_pool_contains(struct device *dev, phys_addr_t addr, size_t size)
+{
+	phys_addr_t base, end;
+
+	if (!dev)
+		return false;
+
+	guard(rcu)();
+
+	if (xa_load(&ffa_lend_devices, (unsigned long)dev) != dev)
+		return false;
+
+	if (WARN_ON_ONCE(!dev->cma_area))
+		return false;
+
+	base = cma_get_base(dev->cma_area);
+	end = base + cma_get_size(dev->cma_area);
+
+	return addr >= base && (addr + size) <= end;
+}
+
+/**
+ * ffa_prepare_lend() - Prepare a memory region to be lent in FF-A
+ * @dev:	Device attached to the lend pool
+ * @addr:	Physical start address of the memory region
+ * @size:	Size in bytes
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
+int ffa_prepare_lend(struct device *dev, phys_addr_t addr, size_t size)
+{
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	struct page *page;
+	unsigned long i;
+	int ret;
+
+	if (!ffa_lend_pool_contains(dev, addr, size))
+		return -ENODEV;
+
+	page = pfn_to_page(PHYS_PFN(addr));
+	for (i = 0; i < nr_pages; i++) {
+		ret = __set_direct_map_invalid_noflush(page + i);
+
+		if (ret) {
+			while (i--)
+				__set_direct_map_default_noflush(page + i);
+
+			return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ffa_prepare_lend);
+
+/**
+ * ffa_lend_reclaimed() - Restore a reclaimed FF-A memory region
+ * @dev:	Device attached to the lend pool
+ * @addr:	Physical start address of the memory region
+ * @size:	Size in bytes
+ *
+ * Restores a memory range into the kernel's direct mapping. It must be called
+ * after a successful FF-A memory reclaim invocation.
+ */
+void ffa_lend_reclaimed(struct device *dev, phys_addr_t addr, size_t size)
+{
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	struct page *page;
+	unsigned long i;
+
+	if (!ffa_lend_pool_contains(dev, addr, size))
+		return;
+
+	page = pfn_to_page(PHYS_PFN(addr));
+	for (i = 0; i < nr_pages; i++)
+		__set_direct_map_default_noflush(page + i);
+}
+EXPORT_SYMBOL_GPL(ffa_lend_reclaimed);
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
+	struct device_node *np;
+	struct reserved_mem *rmem;
+
+	np = of_find_compatible_node(NULL, NULL, "arm,ffa-lend-pool");
+	if (!np)
+		return -ENODEV;
+
+	rmem = of_reserved_mem_lookup(np);
+	of_node_put(np);
+	if (!rmem || !rmem->ops || !rmem->ops->device_init)
+		return -EINVAL;
+
+	return rmem->ops->device_init(rmem, dev);
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
+	struct device_node *np;
+	struct reserved_mem *rmem;
+
+	np = of_find_compatible_node(NULL, NULL, "arm,ffa-lend-pool");
+	if (!np)
+		return;
+
+	rmem = of_reserved_mem_lookup(np);
+	of_node_put(np);
+
+	if (rmem && rmem->ops && rmem->ops->device_release)
+		rmem->ops->device_release(rmem, dev);
+}
+EXPORT_SYMBOL_GPL(ffa_lend_pool_detach);
+
+static int __init ffa_lend_pool_setup(unsigned long node, struct reserved_mem *rmem)
+{
+	struct cma *cma;
+	int ret;
+
+	if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
+	    of_get_flat_dt_prop(node, "no-map", NULL)) {
+		pr_err("FF-A lend pool: node must be 'reusable' and not 'no-map'\n");
+		return -EINVAL;
+	}
+
+	if (!IS_ALIGNED(rmem->base | rmem->size, CMA_MIN_ALIGNMENT_BYTES)) {
+		pr_err("FF-A lend pool: incorrect alignment of CMA region\n");
+		return -EINVAL;
+	}
+
+	ret = cma_init_reserved_mem(rmem->base, rmem->size, 0, rmem->name, &cma);
+	if (ret) {
+		pr_err("FF-A lend pool: unable to setup CMA region (%d)\n", ret);
+		return ret;
+	}
+
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
+	ret = xa_err(xa_store(&ffa_lend_devices, (unsigned long)dev, dev, GFP_KERNEL));
+	if (ret)
+		dev->cma_area = NULL;
+
+	return ret;
+}
+
+static void ffa_lend_pool_device_release(struct reserved_mem *rmem, struct device *dev)
+{
+	xa_erase(&ffa_lend_devices, (unsigned long)dev);
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
index e71d83ee0aef..fa3570f85ff7 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -519,4 +519,25 @@ struct ffa_ops {
 	const struct ffa_notifier_ops *notifier_ops;
 };
 
+#if IS_ENABLED(CONFIG_ARM_FFA_LEND_POOL)
+int ffa_lend_pool_attach(struct device *dev);
+void ffa_lend_pool_detach(struct device *dev);
+int ffa_prepare_lend(struct device *dev, phys_addr_t paddr, size_t size);
+void ffa_lend_reclaimed(struct device *dev, phys_addr_t paddr, size_t size);
+#else
+static inline int ffa_lend_pool_attach(struct device *dev)
+{
+	return -ENODEV;
+}
+static inline void ffa_lend_pool_detach(struct device *dev)
+{
+}
+static inline int ffa_prepare_lend(struct device *dev, phys_addr_t paddr, size_t size)
+{
+	return -ENODEV;
+}
+static inline void ffa_lend_reclaimed(struct device *dev, phys_addr_t paddr, size_t size)
+{
+}
+#endif
 #endif /* _LINUX_ARM_FFA_H */
-- 
2.55.0.970.g62bdec98f9-goog


