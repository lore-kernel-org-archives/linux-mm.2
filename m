Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE821CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171AC8E0023; Mon, 17 Nov 2025 05:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1496B8E0002; Mon, 17 Nov 2025 05:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F6D8E0023; Mon, 17 Nov 2025 05:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4F258E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:49:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8676FC0C5F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:49:40 +0000 (UTC)
X-FDA: 84119778120.27.78862F1
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id AD3C9140006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:49:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763376579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lteemHYfCFRhmg4sD9kv13oYhFVsuanc2EW7Y1QQ3a8=;
	b=4p7zaDFVox74khqXjuMUV2m1VF1w94yekavHJMcMFlNymSE2Hvua5a16F4yVvjeHjdCyFE
	EEJ+I54h+O2nmSaS90RF0dFoEl1I8/5lnpE3qmDT73jFn68ZrXDOroZheSrK5pcMe6MKQa
	0QmsoJ7oEvYWgFQbK07NA/5/SqHtQTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763376579; a=rsa-sha256;
	cv=none;
	b=Qp3D0Hd+QoIQ4aCjgwQ6AGicpvO1dCt4soOFIId0R7VfhU+0Jsx8mYfMo1/oMBmjxEo5cu
	FPsHazkimscvRatZEbKavB2FuGLA6+2PfLQAqDhUyj9QIF3J9skwPToVVUx/TZmGC6mk49
	USBToL14MeiKdzbbjb4hwxLtEuhjHtU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d94HS3V5fzHnH5y;
	Mon, 17 Nov 2025 18:49:08 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 2DD2414011A;
	Mon, 17 Nov 2025 18:49:37 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 17 Nov 2025 10:49:35 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Drew Fustini
	<fustini@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Alexandre
 Belloni <alexandre.belloni@bootlin.com>, Krzysztof Kozlowski
	<krzk@kernel.org>
CC: <james.morse@arm.com>, Will Deacon <will@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v6 3/7] lib: Support ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Date: Mon, 17 Nov 2025 10:47:56 +0000
Message-ID: <20251117104800.2041329-4-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: n3j4a73gtg8jptkgyba7t3k37nq9pw1f
X-Rspam-User: 
X-Rspamd-Queue-Id: AD3C9140006
X-Rspamd-Server: rspam10
X-HE-Tag: 1763376578-130258
X-HE-Meta: U2FsdGVkX1+BO4BlJ3gcgXb84QU52rABgKmAxYKXENxFEDICET60yxAa62gfA72gQLAAGtiViYu9dJT98aVzPixCSUO1KRCicw01KBL85iYWxYvLbxnZnpjiLJLkE1F3GJIV6NU05SKVTavXYw9YTxcjQDdSxGkDFgHCQCRCNC6HrfK3MvAvhVpD9BRwdp9vxeMNsSTSB00ff+THXdRGmZAicoJPk+PBXRZxvRKs/EHenllmvXSG81KYdH6rCTYFy0KxDeaN/Ill0Oc39EoYZPHJQkTOed9pDZX0l150ayMV+zXx/xQf3xnIyyoUxypjrX68hK/ReyhM9G5Tvf33FhuoruztLa0hIIgnG78vBP5D/0dS6bf+52lK3/Olr6SfzDYwEIJf94aGRheefTuT+fW9e4DOPmO/xos1OqdQ8C1D+OYlabjQl34LvJAbNbNOt4YxsT4oySuQx9DXRZkClPwzyInMg91N2VwzDSzjirS9EoQLxmkg5WnsZoaTCedIduHZI7JE13qYXqYOk47+2C1aUbV6PlFJ1Mn9e9G956npmaRhzXmSG2YPJu0BiR0kQvvroUgmKr09u7LEGBsUF3LuDTN12rD9OoBDzsmXNUeLnG2tJSa4fc1muFDr2vlwo36290JHmabg5yQpYBPL46nZVaqOu7JY7AqgqyrGJmAtcOavUVuPUfKn700xQjgJ1luGPUxCxxyZ6L6WuVM2vV4wsHvVP9vLGXzW35iQU4tLppYRHpUlSq0KEHsvOoKticONxnqVyjbdEVNGOY1PY0s0sOVNgiEOFKStSBYoLTafqszG8entnllOywfuCd7qjgVcLMDs2YrKMoNXqxt9p242y8+n8ildWCH0CabkKfZuFAkFFnymMPnf2sA9vOosHwv7/dHMh0UTgPEXXlrAVWty+XndYmhCssHAuCrh10RmsjiHKqhbTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yicong Yang <yangyicong@hisilicon.com>

ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION provides the mechanism for
invalidating certain memory regions in a cache-incoherent manner. Currently
this is used by NVDIMM and CXL memory drivers in cases where it is
necessary to flush all data from caches by physical address range.
The operations in question are effectively memory hotplug, where stale
data might otherwise remain in the caches.

This is separate from the invalidates done to enable use of non-coherent
DMA masters, primarily in terms of when it is needed (not related to DMA
mappings) and how deep the flush must push data. The flushes done for
non-coherent DMA only need to reach the Point of Coherence of a single host
(which is often nearer CPUs and DMA masters than the physical storage).
This operation must push the data out of non architectural caches
(memory-side caches, write buffers etc) and typically all the way to the
memory device.

In some architectures these operations are supported by system components
that may become available only later in boot as they are either present
on a discoverable bus, or via a firmware description of an MMIO interface
(e.g. ACPI DSDT). Provide a framework to handle this case.

Architectures can opt in for this support via
CONFIG_GENERIC_CPU_CACHE_MAINTENANCE

Add a registration framework. Each driver provides an ops structure and
the first op is Write Back and Invalidate by PA Range. The driver may
over invalidate.

For systems that can perform this operation asynchronously an optional
completion check operation is also provided. If present that must be called
to ensure that the action has finished. This provides a considerable
performance advantage if multiple agents are involved in the maintenance
operation.

When multiple agents are present in the system each should register with
this framework and the core code will issue the invalidate to all of them
before checking for completion on each. This is done to avoid need for
filtering in the core code which can become complex when interleave,
potentially across different cache coherency hardware is going on, so it
is easier to tell everyone and let those who don't care do nothing.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>

---
v6: No change.
v5: Picked up ack from Conor. Thanks!
    Add discussion of difference from the existing operations for
    working with non-coherent DMA (Arnd)
    Expand a little on asynchronous nature and why it matters for
    some systems.
---
 include/linux/cache_coherency.h |  61 ++++++++++++++
 lib/Kconfig                     |   4 +
 lib/Makefile                    |   2 +
 lib/cache_maint.c               | 138 ++++++++++++++++++++++++++++++++
 4 files changed, 205 insertions(+)

diff --git a/include/linux/cache_coherency.h b/include/linux/cache_coherency.h
new file mode 100644
index 000000000000..cc81c5733e31
--- /dev/null
+++ b/include/linux/cache_coherency.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Cache coherency maintenance operation device drivers
+ *
+ * Copyright Huawei 2025
+ */
+#ifndef _LINUX_CACHE_COHERENCY_H_
+#define _LINUX_CACHE_COHERENCY_H_
+
+#include <linux/list.h>
+#include <linux/kref.h>
+#include <linux/types.h>
+
+struct cc_inval_params {
+	phys_addr_t addr;
+	size_t size;
+};
+
+struct cache_coherency_ops_inst;
+
+struct cache_coherency_ops {
+	int (*wbinv)(struct cache_coherency_ops_inst *cci,
+		     struct cc_inval_params *invp);
+	int (*done)(struct cache_coherency_ops_inst *cci);
+};
+
+struct cache_coherency_ops_inst {
+	struct kref kref;
+	struct list_head node;
+	const struct cache_coherency_ops *ops;
+};
+
+int cache_coherency_ops_instance_register(struct cache_coherency_ops_inst *cci);
+void cache_coherency_ops_instance_unregister(struct cache_coherency_ops_inst *cci);
+
+struct cache_coherency_ops_inst *
+_cache_coherency_ops_instance_alloc(const struct cache_coherency_ops *ops,
+				    size_t size);
+/**
+ * cache_coherency_ops_instance_alloc - Allocate cache coherency ops instance
+ * @ops: Cache maintenance operations
+ * @drv_struct: structure that contains the struct cache_coherency_ops_inst
+ * @member: Name of the struct cache_coherency_ops_inst member in @drv_struct.
+ *
+ * This allocates a driver specific structure and initializes the
+ * cache_coherency_ops_inst embedded in the drv_struct. Upon success the
+ * pointer must be freed via cache_coherency_ops_instance_put().
+ *
+ * Returns a &drv_struct * on success, %NULL on error.
+ */
+#define cache_coherency_ops_instance_alloc(ops, drv_struct, member)	    \
+	({								    \
+		static_assert(__same_type(struct cache_coherency_ops_inst,  \
+					  ((drv_struct *)NULL)->member));   \
+		static_assert(offsetof(drv_struct, member) == 0);	    \
+		(drv_struct *)_cache_coherency_ops_instance_alloc(ops,	    \
+			sizeof(drv_struct));				    \
+	})
+void cache_coherency_ops_instance_put(struct cache_coherency_ops_inst *cci);
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index e629449dd2a3..e11136d188ae 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -542,6 +542,10 @@ config MEMREGION
 config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
 	bool
 
+config GENERIC_CPU_CACHE_MAINTENANCE
+	bool
+	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
+
 config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
 	bool
 
diff --git a/lib/Makefile b/lib/Makefile
index 1ab2c4be3b66..aaf677cf4527 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -127,6 +127,8 @@ obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 
+obj-$(CONFIG_GENERIC_CPU_CACHE_MAINTENANCE) += cache_maint.o
+
 lib-y += logic_pio.o
 
 lib-$(CONFIG_INDIRECT_IOMEM) += logic_iomem.o
diff --git a/lib/cache_maint.c b/lib/cache_maint.c
new file mode 100644
index 000000000000..9256a9ffc34c
--- /dev/null
+++ b/lib/cache_maint.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generic support for Memory System Cache Maintenance operations.
+ *
+ * Coherency maintenance drivers register with this simple framework that will
+ * iterate over each registered instance to first kick off invalidation and
+ * then to wait until it is complete.
+ *
+ * If no implementations are registered yet cpu_cache_has_invalidate_memregion()
+ * will return false. If this runs concurrently with unregistration then a
+ * race exists but this is no worse than the case where the operations instance
+ * responsible for a given memory region has not yet registered.
+ */
+#include <linux/cache_coherency.h>
+#include <linux/cleanup.h>
+#include <linux/container_of.h>
+#include <linux/export.h>
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/memregion.h>
+#include <linux/module.h>
+#include <linux/rwsem.h>
+#include <linux/slab.h>
+
+static LIST_HEAD(cache_ops_instance_list);
+static DECLARE_RWSEM(cache_ops_instance_list_lock);
+
+static void __cache_coherency_ops_instance_free(struct kref *kref)
+{
+	struct cache_coherency_ops_inst *cci =
+		container_of(kref, struct cache_coherency_ops_inst, kref);
+	kfree(cci);
+}
+
+void cache_coherency_ops_instance_put(struct cache_coherency_ops_inst *cci)
+{
+	kref_put(&cci->kref, __cache_coherency_ops_instance_free);
+}
+EXPORT_SYMBOL_GPL(cache_coherency_ops_instance_put);
+
+static int cache_inval_one(struct cache_coherency_ops_inst *cci, void *data)
+{
+	if (!cci->ops)
+		return -EINVAL;
+
+	return cci->ops->wbinv(cci, data);
+}
+
+static int cache_inval_done_one(struct cache_coherency_ops_inst *cci)
+{
+	if (!cci->ops)
+		return -EINVAL;
+
+	if (!cci->ops->done)
+		return 0;
+
+	return cci->ops->done(cci);
+}
+
+static int cache_invalidate_memregion(phys_addr_t addr, size_t size)
+{
+	int ret;
+	struct cache_coherency_ops_inst *cci;
+	struct cc_inval_params params = {
+		.addr = addr,
+		.size = size,
+	};
+
+	guard(rwsem_read)(&cache_ops_instance_list_lock);
+	list_for_each_entry(cci, &cache_ops_instance_list, node) {
+		ret = cache_inval_one(cci, &params);
+		if (ret)
+			return ret;
+	}
+	list_for_each_entry(cci, &cache_ops_instance_list, node) {
+		ret = cache_inval_done_one(cci);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+struct cache_coherency_ops_inst *
+_cache_coherency_ops_instance_alloc(const struct cache_coherency_ops *ops,
+				    size_t size)
+{
+	struct cache_coherency_ops_inst *cci;
+
+	if (!ops || !ops->wbinv)
+		return NULL;
+
+	cci = kzalloc(size, GFP_KERNEL);
+	if (!cci)
+		return NULL;
+
+	cci->ops = ops;
+	INIT_LIST_HEAD(&cci->node);
+	kref_init(&cci->kref);
+
+	return cci;
+}
+EXPORT_SYMBOL_NS_GPL(_cache_coherency_ops_instance_alloc, "CACHE_COHERENCY");
+
+int cache_coherency_ops_instance_register(struct cache_coherency_ops_inst *cci)
+{
+	guard(rwsem_write)(&cache_ops_instance_list_lock);
+	list_add(&cci->node, &cache_ops_instance_list);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cache_coherency_ops_instance_register, "CACHE_COHERENCY");
+
+void cache_coherency_ops_instance_unregister(struct cache_coherency_ops_inst *cci)
+{
+	guard(rwsem_write)(&cache_ops_instance_list_lock);
+	list_del(&cci->node);
+}
+EXPORT_SYMBOL_NS_GPL(cache_coherency_ops_instance_unregister, "CACHE_COHERENCY");
+
+int cpu_cache_invalidate_memregion(phys_addr_t start, size_t len)
+{
+	return cache_invalidate_memregion(start, len);
+}
+EXPORT_SYMBOL_NS_GPL(cpu_cache_invalidate_memregion, "DEVMEM");
+
+/*
+ * Used for optimization / debug purposes only as removal can race
+ *
+ * Machines that do not support invalidation, e.g. VMs, will not have any
+ * operations instance to register and so this will always return false.
+ */
+bool cpu_cache_has_invalidate_memregion(void)
+{
+	guard(rwsem_read)(&cache_ops_instance_list_lock);
+	return !list_empty(&cache_ops_instance_list);
+}
+EXPORT_SYMBOL_NS_GPL(cpu_cache_has_invalidate_memregion, "DEVMEM");
-- 
2.48.1


