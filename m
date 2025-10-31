Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 510C2CCF9FA
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5F58E015A; Fri, 31 Oct 2025 07:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6318E0042; Fri, 31 Oct 2025 07:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E2F8E015A; Fri, 31 Oct 2025 07:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FBB48E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:18:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27FC2C049F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:18:56 +0000 (UTC)
X-FDA: 84058162272.24.22F5795
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 200E320003
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:18:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761909534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3HIaeOZeB5kJfN/Us9x14z8CBgP00B4j08XkK3zS3r8=;
	b=TEE/c+BIkEqSnTAnt7dsBCkzmLALYWEJ5nxCDyg0me/d02NKk7vKzXAPAFOlde6uv96066
	v4hKz7rNnUHD4T4W3/6QOdDaKfqZSeGcR5L4Mo2L9CqJ2wxnLoLEXSZkxrkoT1Z0zSi/MI
	XTHEWddM6KircrkmRpitgJOJdmIjgU4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761909534; a=rsa-sha256;
	cv=none;
	b=OLfKfehHnRhYJL+Y2VSqSXe3D+E00KF9njMLBouQxxPOhdCQKKEW4kGHw+AJilbHt5GIQQ
	5Dmx+virm3FpRbcLpt+f66TKJECTZFqfgLDVqGwbgwQIX9f/UCzeNzPPrAqNqsw0ugI3xC
	OjUMIwEbxgjwhlzrLBC7Vrwr31MiOOk=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cydgQ0B5Xz6L52N;
	Fri, 31 Oct 2025 19:15:14 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 2877114038F;
	Fri, 31 Oct 2025 19:18:51 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 31 Oct 2025 11:18:47 +0000
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
Subject: [PATCH v5 3/6] lib: Support ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Date: Fri, 31 Oct 2025 11:17:06 +0000
Message-ID: <20251031111709.1783347-4-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
References: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: 5g7nmu91qxwjgx4nqqmengh586ibhdi5
X-Rspamd-Queue-Id: 200E320003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761909533-433239
X-HE-Meta: U2FsdGVkX1+rEyxiV8cdUcvire6HY4RQ6k72c26ygMFpip8U4gEc6RZG+z0yNevAybdjSDBhLmkRDWJymoH6Sqyd44exsmbL8AUE0ZJOXUuvXQeOB91xoyzm65lzegUKjg8dkomr3wZgGGi5xyRYCHlOM+LiIotZ5gOxwQElVlW8XWHvN8BV92Iako0Gx9rdMY+yGtKkdcNbG3/snXtr4lm7cfvjusCH6wqc7jWZKAyKvwdlp3v09xcrRr9558Y9FjXCIjPzoZ2LMBCsMXtfPT8ITile7KwYk50Gz05TQAIYwM+1wvRKhJeWKapzdmlvmezu1NI0ZXVfwyEOIBXQCz2Q+pG8KwHZL1RmmI9YiktDb+kLokQsVwtnfRZ+zzC09SjjBgq40EnWfFBj/UyDD4CxLbtLdMkDWBTg6/C7TmRJ6KusSzmyEJy3nWt935Dfvep1EpnmmYeoTcVJbDAO3VXUYdK08KJsCD19GVvT1mF295hbgE0kRNwJGnRk9Mbor699b35AUrcLYImB5YNrsoRS6J+VlRFSB2g3qXExO/NGik7T6OzjgPApN88cSA7T2pYvFbQ+dFFI6CcrZgJYcAQ//vobEBL36EMh+ld8CBAKKQC5yiR6bf1ubOWj5+fBY2HBYflRJwz50FB9bXvgcKqFRDG569N8lzZ+iPL1WQwKB3263mURUWpHhJ8zeZ1IVU9P6AE0RnS/9mB0fQ8usyHulVfuNqbyC3z/YAwans8d23fQXbU6fKy9Kex0SeMKQMYRKXcRz/GlYw2FQg/F7in3Asz2HJdLWBgpc1ZcMAlsnfBZJDVs41IcRf6+SdYHddhDiqBLuPdGemW4zoOx2zcqOZfkPKZkb+4hoTg+PEIjCXA7Bw5tgYk2y6/4xf0UzT2jcJ2fHkyMVqbhy/2J0JXKJuB08fGJenaH4rTgeMCCfRjghyVWHIm2Shs9RduGnClrf7ishVFSvBvpwrb
 L7yzdAGc
 IaNq6ylXpE2u+2JogynzdlA6g3Wm1wrpgGV1z1skBnevugvmaPn5tAkuGFRq3Vz3TFSaiegtbbexxrdsXwB0R8l7/CKlK4brDZhHj6BZMoVCA+ynDTPqCaWdNpdw9FZ+Rf0La4+PbOz/6b6gY8KHBpSQFgqsreSqORjPzOv0+aQz1uxko0PwvJ8WbNcOzMW/iRCQj5ApLZk74jeLDrg/oVebCfcmMChvnDXUFFfTHyHXob5vxkqa/BoNoe7UG8P1NM1uMsodS4tTdriZ0yh15i4jCI9t6eM2MIV/EBwYxi9f6X84LxnDl781sM94LH7ydfo70P6YVCFn/WXA4b8m83RLHSk5uv6/cD9lG
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


