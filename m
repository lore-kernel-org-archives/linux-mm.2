Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4C3DCCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9C68E0002; Wed, 22 Oct 2025 07:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D16C8E0017; Wed, 22 Oct 2025 07:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013DA8E0002; Wed, 22 Oct 2025 07:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E62E48E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:35:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE12B1607ED
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:35:29 +0000 (UTC)
X-FDA: 84025544778.09.35501E4
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id C19EE180007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:35:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761132928; a=rsa-sha256;
	cv=none;
	b=xMntmn1jofLQpHUbKikWHZNZ/lOuDIoFTbpg2AQga2tzhknMXSPY0/nWJK4ZSITcylw+JH
	svPLh3D0+M958Twsrc7PaSO4Mx0GU54ZlEbOqH88i07GEgZ06kUjh4ic3utgwjgU9Z7XwX
	oNAlON8lft3EB9Gf0mJs7AYFQFcvQCM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761132928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0hUeueAKdE34Qo3VZOJ6aJ5ZxPyGds2vlszfFVEg4FM=;
	b=HTFcIGWuX+bxvmIAysu+qHl4H4avoagSO2CFkoZxhoWTbb7Tq+nfUMp6w8d5/CcuVifH/Z
	vjovCr161CMYNcZDKjnhxququlKO1mek+ahV4ZZeLHCC8O2PURTKPEIVYHCJx5dVAqQ/Nd
	GSYJXOaVMfbtNjMF38QvY1EgQWxcsJs=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cs6T958zHz6GDK0;
	Wed, 22 Oct 2025 19:32:13 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 33BCC1402F7;
	Wed, 22 Oct 2025 19:35:26 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 12:35:25 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <james.morse@arm.com>, Will Deacon <will@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v4 3/6] lib: Support ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Date: Wed, 22 Oct 2025 12:33:46 +0100
Message-ID: <20251022113349.1711388-4-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Stat-Signature: 8erwygoxmcn3y6okb3hpfjazrb1qqcdp
X-Rspamd-Queue-Id: C19EE180007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761132927-857543
X-HE-Meta: U2FsdGVkX19kok20JB9j34iXiNPRMpJUc97pwDEDSiYAm6ToaOkzUoNW628o6IhV3o/DqWMYdcFv/x4qsTt1B02Srq/knf7URRDDF7U1jy3cXZIuwlVdt5ODm6pSqJM4vc8qAbpwEKgkP3jcXk0pdekJTyb27IQjepu430BlUrHPHeq0Nw8HGKY0T6tZobSXF5FiHah1lTXs5aE9K0EzFIR71AlIJ0attlaTmewIKmJwYKAKY+QrOsRAsr/TiteeWE2K4NZlgdngsC9S5V7S9zZllW60OvZYojKgWtg+uewWPEDYgmznpIsCh2vPlVQHcqmo/HVXEALoF3YYje5TGVQMQ8iSrhwHQx0DbPWuvGyA+tUNa81rfIgbBm6UO1BGz/+58N+Cnng/v/w6usMtPdh1o8goNm+EnPmkBPieb+VwdaG6fl611mERXiLrlb47FgVjwt9IBTv7mULcE52froOsZkmZhr5AHE6Hq8mU0YbE38rvlOTBy3ZSKpIMdh1h4OKVT/uPT+18qP0axODA8gG1SIwQbP4w8lwx2iZ0lXsjcW79h6g2DQ9pUyYF/Ndvl1Zk9uZXb760GKmnV9qKwHMWuADQMGXrc/RA0e81qmSXk8A8nd591uVpKtNAQNG8AkBSyNmROtvQpdafvQwBTk2YRpyt4pT+BQozlOSHkS9Rqgt9GqjPY04XHpkPRM9JEvpRQqsVnAG27v4c01wqBFFMJiadwu29VNY1AFdG0aQuyRIIlF3xizvMoST8h8DS9aOp7ZPTOmD3dPNS9GOOlYZYcCJl94VALmc6Kx5PXtfH0Yr8WQql5F2l17T92iJbu6jJhv1FhQRiVFvMD1j3tqGKn/5JCbHr5c3XObwR0fwLXW77UVhfP/ea7wxNfW1zWpWTTbUaD+YFY/nIBXvAjVDHGU4HCmgUgYdALC3vU130s8cJez5VoTVfiHTGYad//iZpxDx8Nq4Iim4zStR
 9qX3a/Mz
 o6dCL1VRaV7FeIAJQV/MzGSyF1Rpd0mo8zz5J6iY5JuYyloxsCF0LfklMyYg0y8QtEV5RaSYIq6C/LinPUkkfOZrRKLzVRYUFXSeUyfRbdcdlZuqwPO3zcAtqJwr8De402eDoh19kOFVqgo/WgpEnMs1msR1nbnyKSxBpsb3JK78exGAb7QOB022aBUAdmRm1petOYCF4cXKTyopvVuOmyFYLX/Qcg2ry5rNK6Uhqwvod3rPNY3pnjRWv0ge9KAx2XIeTVz06Gp3UheVl1z4K2urrJ/qoW99x491v
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
v4:
 - Improve formatting of Returns documentation.  (Randy Dunlap)
 - select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION as this is providing the
   implementation if this selected by an architecture (Catalin Marinas)
 - Avoid use of device in naming as no struct device involved any more.
   Instead use cache_coherency_ops for the callback structure and
   cache_coherency_ops_inst for a single register instance.
   Rename the allocation and registration functions to reflect this
   (based on feedback from Dan Williams)
 - Use a kref to avoid the oddity of calling free on an embedded structure.
   (Dan Williams)
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


