Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11768CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB748E015D; Fri, 31 Oct 2025 07:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B9E8E0042; Fri, 31 Oct 2025 07:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A5D8E015D; Fri, 31 Oct 2025 07:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 434B98E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:20:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3C3B58EDF
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:20:36 +0000 (UTC)
X-FDA: 84058166472.18.DAEE078
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1497620007
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:20:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761909635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uPtpQHwVeHzkFNQkHHhfTApiREp8kyVU3F4MoxoYqZw=;
	b=H6lg2OE/fqhmtKrSt4o8BD/dToPVXwzJSmUqmV++aiAyjkRF5V1n2kXrtvcmLeEIQUwPaB
	4MryFiKHjP9m5jS1HpnxvRqpddwKv9lmQ3jn96qKeZHHArtKxY9EaUW3ugRMkTC7aLwOP/
	6nkbvPmCI2dyHKe0lhlCYbppUdtenaw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761909635; a=rsa-sha256;
	cv=none;
	b=FlutEA6Yc6E7vibP/ufrTJW5agVCJeOTHv/+ZLu6dJvyeNFSmNG7k3gRTwCJxihZHBLzt2
	84DTYHqJeWfAKyAoE4awDyvgE2Rsj6QA9lQWMv3nUnci/Xc2nb0dZYAwRKUpBv0Uf6PNKd
	djFng2Wkn1kHGEjLUDPtYZg5TgANKjw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cydlN4qSQz67Pyr;
	Fri, 31 Oct 2025 19:18:40 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 0CA5C140427;
	Fri, 31 Oct 2025 19:20:33 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 31 Oct 2025 11:20:31 +0000
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
Subject: [PATCH v5 6/6] cache: Support cache maintenance for HiSilicon SoC Hydra Home Agent
Date: Fri, 31 Oct 2025 11:17:09 +0000
Message-ID: <20251031111709.1783347-7-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
References: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Rspamd-Queue-Id: 1497620007
X-Rspamd-Server: rspam02
X-Stat-Signature: mqq96apfqnntkkgxxk9ku5duacoidmsh
X-HE-Tag: 1761909634-612887
X-HE-Meta: U2FsdGVkX188KxyA9PN2xVqDNKQF2ECw6a1nblr+aXNTnr2+H4uWVl59qFYESHga38tJAAUHvG6f9X9jq60Yc2HHT6wuJLvYgYg5UxKzo3vdSROQPoK+r0TYjhxFvdXhQJWDSK9RnDHZ51AAT8N1Mdu2pABc7U1gug9t61PQYWRezhOVvswKbfEJpKZ6XiNMGBaPyYk+bhvsGpZghxesiqApXKUiDN9cWYtggvAT1Qu99v9ycrwmGXyNa1VyEa2hg769lYFpCC1j/FO754TO+KmuaCF3wzs8fwnd+OxkQY0y5HWt4vaPjx2IOTV0VHG4fZcXuVHLG1GX27+y6NUao302arIqxjM4oAJrLHY4tMMJlF/e25vDN8snnphGJdcwtRelNjW6cSSpEiT1LK9jOaTBTp8W/RuhZZmF/bvZztVBYij8O1V74NKj+sHfPrDbmhYWR3PqqMnTuDEAHNWFhIGECjjBYYm3W/a/ryKpnlhcL3ktovzRs24fLqka891dzHWdrQ0P3N/J5Q9HoxlfW+GVZswAZkeVSqGN9jGgL7Xuv3r9hWsm2iLi9TTUf4QztI+lb3xx+nJwPVZweBdr4PMu34CLdnVa3u2YTbTXSqLD7gwuk+PILpJeKQzMxKRHWi3fIHRtLP37EeN47SrsIh+K0L/W9bMo+v08oEyUVLmdKiPqapL399oj7M9a3F1/Z2LwxR25oico0H5wDvKIxs3BReQza7s+mKnMtRfo95naWgcd2iItlPHKqXkGKTswq+koy4mczoxomAfdBaskSP1Ji4MKzgnXxKlLukoRiS7MaUmJKaNCzoDLDbJ/sNOqBUYxapIwofSmq6w1E86YB4JVx2ZzFrQsRB7QVkAfP2tRWgWECzq6iuueLFsp6QRVZXErrTLsOIpy7NEefgiuR0AWQKG1AHui5JCd/WX1MzQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yushan Wang <wangyushan12@huawei.com>

Hydra Home Agent is a device used to maintain cache coherency. Add support
for explicit cache maintenance operations using it. A system has multiple
of these agents. Whilst only one agent is responsible for a given cache
line, interleave means that for a range operation, responsibility for the
cache lines making up the range will typically be spread across multiple
instances.

Co-developed-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Yushan Wang <wangyushan12@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
v5: Drop stale comment on devm_ioremap_resource() as it is no longer used.
    Also drop mention from patch description (Conor)

    Add some overview comments to top of driver and improve comment on
    searching for a cacheline to be explicit about what happens if it is
    not found (as not in scope for device, or happens not to be in any
    caches). (Conor)
    Also update the commit message to make it clear there are always
    multiple instances of this unit in a system (Conor)

v4: Update for naming changes around device / instance.
    Switch to kref put based freeing via helper.
---
 drivers/cache/Kconfig        |  15 +++
 drivers/cache/Makefile       |   2 +
 drivers/cache/hisi_soc_hha.c | 194 +++++++++++++++++++++++++++++++++++
 3 files changed, 211 insertions(+)

diff --git a/drivers/cache/Kconfig b/drivers/cache/Kconfig
index db51386c663a..4551b28e14dd 100644
--- a/drivers/cache/Kconfig
+++ b/drivers/cache/Kconfig
@@ -1,6 +1,21 @@
 # SPDX-License-Identifier: GPL-2.0
 menu "Cache Drivers"
 
+if GENERIC_CPU_CACHE_MAINTENANCE
+
+config HISI_SOC_HHA
+	tristate "HiSilicon Hydra Home Agent (HHA) device driver"
+	depends on (ARM64 && ACPI) || COMPILE_TEST
+	help
+	  The Hydra Home Agent (HHA) is responsible for cache coherency
+	  on the SoC. This drivers enables the cache maintenance functions of
+	  the HHA.
+
+	  This driver can be built as a module. If so, the module will be
+	  called hisi_soc_hha.
+
+endif
+
 config AX45MP_L2_CACHE
 	bool "Andes Technology AX45MP L2 Cache controller"
 	depends on RISCV
diff --git a/drivers/cache/Makefile b/drivers/cache/Makefile
index 55c5e851034d..b3362b15d6c1 100644
--- a/drivers/cache/Makefile
+++ b/drivers/cache/Makefile
@@ -3,3 +3,5 @@
 obj-$(CONFIG_AX45MP_L2_CACHE)		+= ax45mp_cache.o
 obj-$(CONFIG_SIFIVE_CCACHE)		+= sifive_ccache.o
 obj-$(CONFIG_STARFIVE_STARLINK_CACHE)	+= starfive_starlink_cache.o
+
+obj-$(CONFIG_HISI_SOC_HHA)		+= hisi_soc_hha.o
diff --git a/drivers/cache/hisi_soc_hha.c b/drivers/cache/hisi_soc_hha.c
new file mode 100644
index 000000000000..25ff0f5ae79b
--- /dev/null
+++ b/drivers/cache/hisi_soc_hha.c
@@ -0,0 +1,194 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Driver for HiSilicon Hydra Home Agent (HHA).
+ *
+ * Copyright (c) 2025 HiSilicon Technologies Co., Ltd.
+ * Author: Yicong Yang <yangyicong@hisilicon.com>
+ *         Yushan Wang <wangyushan12@huawei.com>
+ *
+ * A system typically contains multiple HHAs. Each is responsible for a subset
+ * of the physical addresses in the system, but interleave can make the mapping
+ * from a particular cache line to a responsible HHA complex. As such no
+ * filtering is done in the driver, with the hardware being responsible for
+ * responding with success for even if it was not responsible for any addresses
+ * in the range on which the operation was requested.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/cache_coherency.h>
+#include <linux/dev_printk.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/memregion.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+
+#define HISI_HHA_CTRL		0x5004
+#define   HISI_HHA_CTRL_EN	BIT(0)
+#define   HISI_HHA_CTRL_RANGE	BIT(1)
+#define   HISI_HHA_CTRL_TYPE	GENMASK(3, 2)
+#define HISI_HHA_START_L	0x5008
+#define HISI_HHA_START_H	0x500c
+#define HISI_HHA_LEN_L		0x5010
+#define HISI_HHA_LEN_H		0x5014
+
+/* The maintain operation performs in a 128 Byte granularity */
+#define HISI_HHA_MAINT_ALIGN	128
+
+#define HISI_HHA_POLL_GAP_US		10
+#define HISI_HHA_POLL_TIMEOUT_US	50000
+
+struct hisi_soc_hha {
+	/* Must be first element */
+	struct cache_coherency_ops_inst cci;
+	/* Locks HHA instance to forbid overlapping access. */
+	struct mutex lock;
+	void __iomem *base;
+};
+
+static bool hisi_hha_cache_maintain_wait_finished(struct hisi_soc_hha *soc_hha)
+{
+	u32 val;
+
+	return !readl_poll_timeout_atomic(soc_hha->base + HISI_HHA_CTRL, val,
+					  !(val & HISI_HHA_CTRL_EN),
+					  HISI_HHA_POLL_GAP_US,
+					  HISI_HHA_POLL_TIMEOUT_US);
+}
+
+static int hisi_soc_hha_wbinv(struct cache_coherency_ops_inst *cci,
+			struct cc_inval_params *invp)
+{
+	struct hisi_soc_hha *soc_hha =
+		container_of(cci, struct hisi_soc_hha, cci);
+	phys_addr_t top, addr = invp->addr;
+	size_t size = invp->size;
+	u32 reg;
+
+	if (!size)
+		return -EINVAL;
+
+	addr = ALIGN_DOWN(addr, HISI_HHA_MAINT_ALIGN);
+	top = ALIGN(addr + size, HISI_HHA_MAINT_ALIGN);
+	size = top - addr;
+
+	guard(mutex)(&soc_hha->lock);
+
+	if (!hisi_hha_cache_maintain_wait_finished(soc_hha))
+		return -EBUSY;
+
+	/*
+	 * Hardware will search for addresses ranging [addr, addr + size - 1],
+	 * last byte included, and perform maintenance in 128 byte granules
+	 * on those cachelines which contain the addresses. If a given instance
+	 * is either not responsible for a cacheline or that cacheline is not
+	 * currently present then the search will fail, no operation will be
+	 * necessary and the device will report success.
+	 */
+	size -= 1;
+
+	writel(lower_32_bits(addr), soc_hha->base + HISI_HHA_START_L);
+	writel(upper_32_bits(addr), soc_hha->base + HISI_HHA_START_H);
+	writel(lower_32_bits(size), soc_hha->base + HISI_HHA_LEN_L);
+	writel(upper_32_bits(size), soc_hha->base + HISI_HHA_LEN_H);
+
+	reg = FIELD_PREP(HISI_HHA_CTRL_TYPE, 1); /* Clean Invalid */
+	reg |= HISI_HHA_CTRL_RANGE | HISI_HHA_CTRL_EN;
+	writel(reg, soc_hha->base + HISI_HHA_CTRL);
+
+	return 0;
+}
+
+static int hisi_soc_hha_done(struct cache_coherency_ops_inst *cci)
+{
+	struct hisi_soc_hha *soc_hha =
+		container_of(cci, struct hisi_soc_hha, cci);
+
+	guard(mutex)(&soc_hha->lock);
+	if (!hisi_hha_cache_maintain_wait_finished(soc_hha))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static const struct cache_coherency_ops hha_ops = {
+	.wbinv = hisi_soc_hha_wbinv,
+	.done = hisi_soc_hha_done,
+};
+
+static int hisi_soc_hha_probe(struct platform_device *pdev)
+{
+	struct hisi_soc_hha *soc_hha;
+	struct resource *mem;
+	int ret;
+
+	soc_hha = cache_coherency_ops_instance_alloc(&hha_ops,
+						     struct hisi_soc_hha, cci);
+	if (!soc_hha)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, soc_hha);
+
+	mutex_init(&soc_hha->lock);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		ret = -ENOMEM;
+		goto err_free_cci;
+	}
+
+	soc_hha->base = ioremap(mem->start, resource_size(mem));
+	if (!soc_hha->base) {
+		ret = dev_err_probe(&pdev->dev, -ENOMEM,
+				    "failed to remap io memory");
+		goto err_free_cci;
+	}
+
+	ret = cache_coherency_ops_instance_register(&soc_hha->cci);
+	if (ret)
+		goto err_iounmap;
+
+	return 0;
+
+err_iounmap:
+	iounmap(soc_hha->base);
+err_free_cci:
+	cache_coherency_ops_instance_put(&soc_hha->cci);
+	return ret;
+}
+
+static void hisi_soc_hha_remove(struct platform_device *pdev)
+{
+	struct hisi_soc_hha *soc_hha = platform_get_drvdata(pdev);
+
+	cache_coherency_ops_instance_unregister(&soc_hha->cci);
+	iounmap(soc_hha->base);
+	cache_coherency_ops_instance_put(&soc_hha->cci);
+}
+
+static const struct acpi_device_id hisi_soc_hha_ids[] = {
+	{ "HISI0511", },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, hisi_soc_hha_ids);
+
+static struct platform_driver hisi_soc_hha_driver = {
+	.driver = {
+		.name = "hisi_soc_hha",
+		.acpi_match_table = hisi_soc_hha_ids,
+	},
+	.probe = hisi_soc_hha_probe,
+	.remove = hisi_soc_hha_remove,
+};
+
+module_platform_driver(hisi_soc_hha_driver);
+
+MODULE_IMPORT_NS("CACHE_COHERENCY");
+MODULE_DESCRIPTION("HiSilicon Hydra Home Agent driver supporting cache maintenance");
+MODULE_AUTHOR("Yicong Yang <yangyicong@hisilicon.com>");
+MODULE_AUTHOR("Yushan Wang <wangyushan12@huawei.com>");
+MODULE_LICENSE("GPL");
-- 
2.48.1


