Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4118CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739E18E0051; Wed, 20 Aug 2025 06:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7117D8E0003; Wed, 20 Aug 2025 06:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628068E0051; Wed, 20 Aug 2025 06:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EDEF8E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:31:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17C46B98A2
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:31:30 +0000 (UTC)
X-FDA: 83796769140.20.0B36BAB
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id 19D69C0005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:31:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755685888; a=rsa-sha256;
	cv=none;
	b=uKVuxs6AGdm6qTWdKr9V6zBMxKHJWLBsDZ/1PleJxmCHLPrVl6+QbMPiIb/M+E6BZwNKBS
	9CfRpUjm+rDRSq4UKNGagTUjlesBR+uUjXG84f3Oefg2InaxofMJ1CV8my/kne19vAVDSj
	ScBMu1/9HnWNy0atBapj2wPjqnuK6cU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755685888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9q6/LEoWM/YwJR5nWzCJnPRIRlqxk7mDdbg8TB800BY=;
	b=nF03fzeB8Tk79EwY9exYvsxWOZ7oRlSEI+OObKh7c9OE+gh7ptpMasjzDXffmrbN9g4f0D
	Vt8bdpIgMsXYA275BL/fToAskruIGWgg4FncErZ3E9mdWfxHqqsLnvkAUIkkQ7Z/OT4F8+
	BEYy1OwEPh+5e1kMjCaR5VVj836j8vE=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c6N3f6h0jz6M4m2;
	Wed, 20 Aug 2025 18:29:18 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 505941402FB;
	Wed, 20 Aug 2025 18:31:26 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 20 Aug 2025 12:31:25 +0200
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>, <james.morse@arm.com>,
	<linux-cxl@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Will Deacon <will@kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
CC: Yicong Yang <yangyicong@huawei.com>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>
Subject: [PATCH v3 3/8] lib: Support ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Date: Wed, 20 Aug 2025 11:29:45 +0100
Message-ID: <20250820102950.175065-4-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 19D69C0005
X-Stat-Signature: bnw4ze81pfc15t3gjay6hs33qpjd61fs
X-HE-Tag: 1755685887-272408
X-HE-Meta: U2FsdGVkX19efkAsgBD+/AWYkrcUFLB6YsRKLIX0i2z6va4wRSn/Wh7wjUy3fSeagWbv2ofrjTpwhlLk9JREdgIKsbfLnXWGMRF1KuiROwSTRDvlM3YMF6tf0x7X6dZDtUYLi9h8tZAzFr1W6uf4j+ixq5tnvqRaOg6OOhnJLOJZD4SxJ2I9z6zrAXAfkIOS++/vCi2rWRwf1WTY+k1d+vP01GnagsYrnm2sW+oEpcmPDXALcQSWUBEleKl0eDBRVpBjBntaI1EYFrEuxi8IVBhPUy0abVpKLeZdB/3aZbYtcPOx24JLB0p5M7kyRk8Ab7e16jaSfqzTEoHacFBFUCWoNRe8izCyX2WXgsff/pn0g6u/Bna/UvZVV5lcM3FLdHbAmHNFjHsWw0h1o8m9UKY0PSBJS1ubaahJuWQOUfSBgMAQgK62KrAQs/1Z3trbENtPzTGElN/X2EvaFpWRVNTR+7auz02ogo2y+bT1HgYBBgpUzliuv34DuickbOxYEVbfs5bYGUT+x+NOOveqcTlDSm5Fe4s4f02l9cOUawf0doyZGqQeJdz8qAEihuzmeDe1iAIj4lDjreIE6RylcYoJ1fsfCmpglIq7OFaLTYpORf68sECr45Ck9fWiLvd3dPseWP7+WX/ialmuMB90Z/+nKr9rhjW8B0ndGCJrGYGazOwn2PCC2aq0K1GS+fTKRbuZ9d+aQKrXmtAMSvKRLoaN3PVMsEDsa57wlP4+JcnzFMNfnrGiWehTD3hMLCuKYT68YLrHslc3o2WnBZqXI6GXNNB830VH17f4ZQ0cGJvhVt7jGLw6HNRx3M/8B2ZvCa2ljpTqFVURnFtQh3JM1oHOz8LcCGPGZ9Y08KE+2zUeGTkb0naspHZdVpjEplg/UO19nHJ7L8YCg69O2dvMute2Jq0EpSTUwjwEAIvKTM4rTwSpnJWjvFMOg7NKV6uq4+r54KZJfjNaW8awBVh
 4pSqQGL5
 HGluKnj08ervWUucyGxESMeADw224y1HlPWc8NFTztkoYXSlZSopL8LxflsLeOqRJlwcdk1Zbi0EalpK8L3TLPrFCp1W7WCBZVQkZlqM5iLqU0IYr2c0PoMIszoaSDiyaW3zJAAv9OHdiv9ZQZaKPlXiq0RkDTK/bnXfVjWCchfxKy6E48jwr6gcxeXjbsfJq4Rp5Tz6auCNZe7lIosmzQSSwJ3gA5GdwbeYJm5m6vj5nyFrvgy9WmQhEHmmfZdHfFVajM53sDBgCOi7RkNqFysiOvhDr0utsSt9E
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

In some architectures these operations are supported by system components
that may become available only later in boot as they are either present
on a discoverable bus, or via a firmware description of an MMIO interface
(e.g. ACPI DSDT). Provide a framework to handle this case.

Architectures can opt in for this support via
CONFIG_GENERIC_CPU_CACHE_MAINTENANCE

Add a registration framework. Each driver provides an ops structure and
the first op is Write Back and Invalidate by PA Range. The driver may
over invalidate.

An optional completion check operation is also provided. If present
that should be called to ensure that the action has finished.

When multiple agents are present in the system each should register with
this framework and the core code will issue the invalidate to all of them
before checking for completion on each. This is done to avoid need for
filtering in the core code which can become complex when interleave,
potentially across different cache coherency hardware is going on, so it
is easier to tell everyone and let those who don't care do nothing.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
v3: Squash all the layering from v2 so that the infrastucture is
    always present.
    Suggestions on naming welcome. Note that the hardware I have
    available supports a much richer set of maintenance operations
    than Write Back and Invalidate, so I'd like a name that
    covers all resonable maintenance operations.
    Use an allocation wrapper macro, based on the fwctl one to
    ensure that the first element of the allocated driver structure
    is a struct cache_coherency_device.
    Thanks to all who provided feedback.
---
 include/linux/cache_coherency.h |  57 ++++++++++++++
 lib/Kconfig                     |   3 +
 lib/Makefile                    |   2 +
 lib/cache_maint.c               | 128 ++++++++++++++++++++++++++++++++
 4 files changed, 190 insertions(+)

diff --git a/include/linux/cache_coherency.h b/include/linux/cache_coherency.h
new file mode 100644
index 000000000000..cb195b17b6e6
--- /dev/null
+++ b/include/linux/cache_coherency.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Cache coherency maintenace operation device drivers
+ *
+ * Copyright Huawei 2025
+ */
+#ifndef _LINUX_CACHE_COHERENCY_H_
+#define _LINUX_CACHE_COHERENCY_H_
+
+#include <linux/list.h>
+#include <linux/types.h>
+
+struct cc_inval_params {
+	phys_addr_t addr;
+	size_t size;
+};
+
+struct cache_coherency_device;
+
+struct coherency_ops {
+	int (*wbinv)(struct cache_coherency_device *ccd, struct cc_inval_params *invp);
+	int (*done)(struct cache_coherency_device *ccd);
+};
+
+struct cache_coherency_device {
+	struct list_head node;
+	const struct coherency_ops *ops;
+};
+
+int cache_coherency_device_register(struct cache_coherency_device *ccd);
+void cache_coherency_device_unregister(struct cache_coherency_device *ccd);
+
+struct cache_coherency_device *
+_cache_coherency_device_alloc(const struct coherency_ops *ops, size_t size);
+/**
+ * cache_coherency_device_alloc - Allocate a cache coherency device
+ * @ops: Cache maintenance operations
+ * @drv_struct: structure that contains the struct cache_coherency_device
+ * @member: Name of the struct cache_coherency_device member in @drv_struct.
+ *
+ * This allocates and initializes the cache_coherency_device embedded in the
+ * drv_struct. Upon success the pointer must be freed via
+ * cache_coherency_device_free().
+ *
+ * Returns a 'drv_struct \*' on success, NULL on error.
+ */
+#define cache_coherency_device_alloc(ops, drv_struct, member)	    \
+	({								    \
+		static_assert(__same_type(struct cache_coherency_device,    \
+					  ((drv_struct *)NULL)->member));   \
+		static_assert(offsetof(drv_struct, member) == 0);	    \
+		(drv_struct *)_cache_coherency_device_alloc(ops,	    \
+			sizeof(drv_struct));				    \
+	})
+void cache_coherency_device_free(struct cache_coherency_device *ccd);
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index c483951b624f..cd8e5844f9bb 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -543,6 +543,9 @@ config MEMREGION
 config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
 	bool
 
+config GENERIC_CPU_CACHE_MAINTENANCE
+	bool
+
 config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
 	bool
 
diff --git a/lib/Makefile b/lib/Makefile
index 392ff808c9b9..eed20c50f358 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -130,6 +130,8 @@ obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 
+obj-$(CONFIG_GENERIC_CPU_CACHE_MAINTENANCE) += cache_maint.o
+
 lib-y += logic_pio.o
 
 lib-$(CONFIG_INDIRECT_IOMEM) += logic_iomem.o
diff --git a/lib/cache_maint.c b/lib/cache_maint.c
new file mode 100644
index 000000000000..05d9c5e99941
--- /dev/null
+++ b/lib/cache_maint.c
@@ -0,0 +1,128 @@
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
+ * race exists but this is no worse than the case where the device responsible
+ * for a given memory region has not yet registered.
+ */
+#include <linux/cache_coherency.h>
+#include <linux/cleanup.h>
+#include <linux/container_of.h>
+#include <linux/export.h>
+#include <linux/list.h>
+#include <linux/memregion.h>
+#include <linux/module.h>
+#include <linux/rwsem.h>
+#include <linux/slab.h>
+
+static LIST_HEAD(cache_device_list);
+static DECLARE_RWSEM(cache_device_list_lock);
+
+void cache_coherency_device_free(struct cache_coherency_device *ccd)
+{
+	kfree(ccd);
+}
+EXPORT_SYMBOL_GPL(cache_coherency_device_free);
+
+static int cache_inval_one(struct cache_coherency_device *ccd, void *data)
+{
+	if (!ccd->ops)
+		return -EINVAL;
+
+	return ccd->ops->wbinv(ccd, data);
+}
+
+static int cache_inval_done_one(struct cache_coherency_device *ccd)
+{
+	if (!ccd->ops)
+		return -EINVAL;
+
+	if (!ccd->ops->done)
+		return 0;
+
+	return ccd->ops->done(ccd);
+}
+
+static int cache_invalidate_memregion(phys_addr_t addr, size_t size)
+{
+	int ret;
+	struct cache_coherency_device *ccd;
+	struct cc_inval_params params = {
+		.addr = addr,
+		.size = size,
+	};
+
+	guard(rwsem_read)(&cache_device_list_lock);
+	list_for_each_entry(ccd, &cache_device_list, node) {
+		ret = cache_inval_one(ccd, &params);
+		if (ret)
+			return ret;
+	}
+	list_for_each_entry(ccd, &cache_device_list, node) {
+		ret = cache_inval_done_one(ccd);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+struct cache_coherency_device *
+_cache_coherency_device_alloc(const struct coherency_ops *ops, size_t size)
+{
+	struct cache_coherency_device *ccd;
+
+	if (!ops || !ops->wbinv)
+		return NULL;
+
+	ccd = kzalloc(size, GFP_KERNEL);
+	if (!ccd)
+		return NULL;
+
+	ccd->ops = ops;
+	INIT_LIST_HEAD(&ccd->node);
+
+	return ccd;
+}
+EXPORT_SYMBOL_NS_GPL(_cache_coherency_device_alloc, "CACHE_COHERENCY");
+
+int cache_coherency_device_register(struct cache_coherency_device *ccd)
+{
+	guard(rwsem_write)(&cache_device_list_lock);
+	list_add(&ccd->node, &cache_device_list);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cache_coherency_device_register, "CACHE_COHERENCY");
+
+void cache_coherency_device_unregister(struct cache_coherency_device *ccd)
+{
+	guard(rwsem_write)(&cache_device_list_lock);
+	list_del(&ccd->node);
+}
+EXPORT_SYMBOL_NS_GPL(cache_coherency_device_unregister, "CACHE_COHERENCY");
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
+ * Machines that do not support invalidation, e.g. VMs, will not
+ * have any devices to register and so this will always return false.
+ */
+bool cpu_cache_has_invalidate_memregion(void)
+{
+	guard(rwsem_read)(&cache_device_list_lock);
+	return !list_empty(&cache_device_list);
+}
+EXPORT_SYMBOL_NS_GPL(cpu_cache_has_invalidate_memregion, "DEVMEM");
-- 
2.48.1


