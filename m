Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885DFCA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282D08E0054; Wed, 20 Aug 2025 06:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A448E0003; Wed, 20 Aug 2025 06:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170928E0054; Wed, 20 Aug 2025 06:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03C468E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:33:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 740B058FEE
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:33:04 +0000 (UTC)
X-FDA: 83796773088.26.5A63C42
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 672A240013
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:33:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755685982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EmYEa+evJuRQFYIjw7z+PbCV/JlZ0eMfto4oSK+UhFc=;
	b=E94OnkvcbBK7DrDPMBO3hxrr1NRHkb6XWTfjC/vuNq1e19S038fei2P7kaMHu2nOKoYv9H
	dEWsg/ntfFZzqIvMPMZX4Td4VihgCPv1Vo+1JxzOri9WOOfAYPrRmc0DMfyC5alVbsITtc
	vCl1egEgpKhwk8YfwmWVxJzi0Qw0gu0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755685982; a=rsa-sha256;
	cv=none;
	b=DVGu4JbEfGPVwvcqFx0IjfPDPzwWc7Bdr+qReWqoa5vi3e2B2JFYZImxkdebYsV9boUx+I
	34xPrF9zhHv3ZiXXaNyeQ0KIF0LB6pjMN0WlfR//8k+yK9YFwOC0O1IsRnpIYNSrx4HjBD
	yji5lHvdgXb8mWDo+xUIKT0umzUkmv4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c6N4P43shz6L5vt;
	Wed, 20 Aug 2025 18:29:57 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 7CBD51402FB;
	Wed, 20 Aug 2025 18:33:00 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 20 Aug 2025 12:32:59 +0200
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
Subject: [PATCH v3 6/8] cache: Support cache maintenance for HiSilicon SoC Hydra Home Agent
Date: Wed, 20 Aug 2025 11:29:48 +0100
Message-ID: <20250820102950.175065-7-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 672A240013
X-Stat-Signature: bbsb4prsnbb9ogzb9asx19ynj4sjkbu5
X-Rspam-User: 
X-HE-Tag: 1755685982-359853
X-HE-Meta: U2FsdGVkX18hFXng443wD9z3s1Zpzzd7bys9Znqez26X0nOO8qbV3DKMYkhdUzzqM8y3RgD5Lbl6U9GuLRi3S5a9K9YdHly6D177xddhTc5s9p8Qb27zWWYVpGyxyT9y9d3A/AVVFhWLHH/srjEjwKrQ8Go/sdiwOvzJYer7FVJz3qO8yiw+F0ujPMsSN/U7uddqA6Ndr72Flw2MejhPSaI2tAuyxstGLO7tZA//VBfm0bJPTPsTYlXk0s4SjjzXFOPF7OztC4TDBAZI4HytcC61FO/WnmPNS8REhm8Qh2Mjr4cNsu6wIghlGLrNTbyT8IsGMf0Svrt4vAf58JZj+VkiJZfml0tZtS1vTedjV10wsJmFON9pmyBw36hZXCWJgzI/rmkNRJXrGCPc3kfQaY7X+JbOEdxR6fcpn+SegtKqzDFxkcS32z0cbkkP8LDAhZu9BRO05q6EtwBnJtoH8m6AslZsnSa8Cr/93m+DBsam4Bi+HSct17HoVC1YSveHCc5MzrlKvH7Q91TwJ2kvI5lNX1u+869zzrXG1uiFGbPpd89Y1GcUgSZwT8GsosheiqUJ9ItNMFH9TOC2wZg5vtda78pdaC5y3b6TfV3wctjHrT8/6nGx/4GHIYLsiEvjowj8LRjyx/nHxW8ADKUaiylS++ItgzsxHwtVQqUbS6zNdvyMQZlSzykehGU5JafO/j4eK+Mja3jwJsn39m6+KHXko8HlnjkYtKnAK0a0pzXyXUqghVGd1C16bQJNfl8mgI01+bmU2RoFskRs01XwjzC+CSUUPMnE62+k4QXER4TO+Mt8d4d1hoiiDnCTbDiWXDw0S4Y0nv9jclgp+lmz5U4LhpYlp+4c/skZ7u9PfTZhkPY8JKbfnbyybFLVjRJv4E7Vs51cJyP98T5KSg+KH5z0dTK9wfxcmHOnJnYbKRWdgifCwvw651Ens+u6FSAm3iZrK6D0TFqXJLDi0vQ
 0KA7OZuD
 A3CjwuhxNQMGCmPmlFWqZKaKZfFr1SgOYGbWbIVeqerxwjk3tZKfaC34wOfG1gDf1XKf5w5HaWBcqIrmSQ/2UPKQdH1+FR9MydXtRv8hTcWilHPeLsQX2GZRHVFuBpGLreJFDvtQ9vmdRLbrPqxSzvM6el8KSL5n+qeB3utnOI6QfikPrRwE4+oJtO9mAIiSlJ9IlWVs4Wr7V+u5tBab9g6rhn7lDQiASEaM0l9fn7a/t3MphVlRDUcKpnYlz/P5tSh7+q16gox3BGSutBM6YdhZVcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yushan Wang <wangyushan12@huawei.com>

Hydra Home Agent is a device used to maintain cache coherency. Add support
of explicit cache maintenance operations for it.

Memory resource of HHA conflicts with that of HHA PMU. A workaround is
implemented here by replacing devm_ioremap_resource() to devm_ioremap() to
workaround the resource conflict check.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Co-developed-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Yushan Wang <wangyushan12@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/cache/Kconfig        |  15 +++
 drivers/cache/Makefile       |   2 +
 drivers/cache/hisi_soc_hha.c | 187 +++++++++++++++++++++++++++++++++++
 3 files changed, 204 insertions(+)

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
index 000000000000..9a26a562804e
--- /dev/null
+++ b/drivers/cache/hisi_soc_hha.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Driver for HiSilicon Hydra Home Agent (HHA).
+ *
+ * Copyright (c) 2025 HiSilicon Technologies Co., Ltd.
+ * Author: Yicong Yang <yangyicong@hisilicon.com>
+ *         Yushan Wang <wangyushan12@huawei.com>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/cacheflush.h>
+#include <linux/cache_coherency.h>
+#include <linux/device.h>
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
+	struct cache_coherency_device ccd;
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
+static int hisi_soc_hha_wbinv(struct cache_coherency_device *ccd, struct cc_inval_params *invp)
+{
+	struct hisi_soc_hha *soc_hha = container_of(ccd, struct hisi_soc_hha, ccd);
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
+	 * last byte included, and perform maintain in 128 byte granule
+	 * on those cachelines which contain the addresses.
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
+static int hisi_soc_hha_done(struct cache_coherency_device *ccd)
+{
+	struct hisi_soc_hha *soc_hha = container_of(ccd, struct hisi_soc_hha, ccd);
+
+	guard(mutex)(&soc_hha->lock);
+	if (!hisi_hha_cache_maintain_wait_finished(soc_hha))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static const struct coherency_ops hha_ops = {
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
+	soc_hha = cache_coherency_device_alloc(&hha_ops, struct hisi_soc_hha,
+					       ccd);
+	if (!soc_hha)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, soc_hha);
+
+	mutex_init(&soc_hha->lock);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -ENODEV;
+
+	/*
+	 * HHA cache driver share the same register region with HHA uncore PMU
+	 * driver in hardware's perspective, none of them should reserve the
+	 * resource to itself only.  Here exclusive access verification is
+	 * avoided by calling devm_ioremap instead of devm_ioremap_resource to
+	 * allow both drivers to exist at the same time.
+	 */
+	soc_hha->base = ioremap(mem->start, resource_size(mem));
+	if (IS_ERR_OR_NULL(soc_hha->base)) {
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(soc_hha->base),
+				"failed to remap io memory");
+		goto err_free_ccd;
+	}
+
+	ret = cache_coherency_device_register(&soc_hha->ccd);
+	if (ret)
+		goto err_iounmap;
+
+	return 0;
+
+err_iounmap:
+	iounmap(soc_hha->base);
+err_free_ccd:
+	cache_coherency_device_free(&soc_hha->ccd);
+	return ret;
+}
+
+static void hisi_soc_hha_remove(struct platform_device *pdev)
+{
+	struct hisi_soc_hha *soc_hha = platform_get_drvdata(pdev);
+
+	cache_coherency_device_unregister(&soc_hha->ccd);
+	iounmap(soc_hha->base);
+	cache_coherency_device_free(&soc_hha->ccd);
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


