Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C53CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1668E0001; Tue,  2 Sep 2025 13:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF088E0014; Tue,  2 Sep 2025 13:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355B28E0001; Tue,  2 Sep 2025 13:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 232578E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:31:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB03B1D14D7
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:31:02 +0000 (UTC)
X-FDA: 83845000764.10.7869959
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id D58D91C0017
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:31:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756834261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ebEzMRNNfJai3L+nAjKCrTqkYVKtlEtcYAcJMbIE+CQ=;
	b=t5zEp8rThlklb+Jpq42xeez9D0UoYKjbyK6ksCueObOxUomqy2TnDoQlzA8dhaUSFbFcDu
	3fptHiiHppa2kiCAtUOVlrq+AGXmROAQtGi8yjV7yoevR3tRrONDUISrHM3Y8qlol+Oi14
	WDoRR2goWjfpKNxOasiXtqGoLMu7CAU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756834261; a=rsa-sha256;
	cv=none;
	b=sVAO8Xzv13VqrYFa8nW1SbnmaitfMn7wCIUMNrU7zesFWijOfjKtjOMt9rqha+0BuaOAwZ
	KrTaDZl/Xkf+i5cIfYKLVIz/X4kNbS6uIILlQ9FGL5kSxTmB9e452FtmN1HcsPaCmAHM66
	pvdpWNzJzfz+qNJVt53eIQzq8Fd55lA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cGXnC5pnXz6HJgT;
	Wed,  3 Sep 2025 01:30:07 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id 963E91402EC;
	Wed,  3 Sep 2025 01:30:58 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.48.150.145) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 2 Sep 2025 19:30:56 +0200
From: <shiju.jose@huawei.com>
To: <rafael@kernel.org>, <bp@alien8.de>, <akpm@linux-foundation.org>,
	<rppt@kernel.org>, <dferguson@amperecomputing.com>,
	<linux-edac@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, <tony.luck@intel.com>,
	<lenb@kernel.org>, <leo.duran@amd.com>, <Yazen.Ghannam@amd.com>,
	<mchehab@kernel.org>
CC: <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>,
	<rientjes@google.com>, <jiaqiyan@google.com>, <Jon.Grimm@amd.com>,
	<dave.hansen@linux.intel.com>, <naoya.horiguchi@nec.com>,
	<james.morse@arm.com>, <jthoughton@google.com>, <somasundaram.a@hpe.com>,
	<erdemaktas@google.com>, <pgonda@google.com>, <duenwen@google.com>,
	<gthelen@google.com>, <wschwartz@amperecomputing.com>,
	<wbs@os.amperecomputing.com>, <nifan.cxl@gmail.com>, <tanxiaofei@huawei.com>,
	<prime.zeng@hisilicon.com>, <roberto.sassu@huawei.com>,
	<kangkang.shen@futurewei.com>, <wanghuiqiang@huawei.com>,
	<shiju.jose@huawei.com>
Subject: [PATCH v12 2/2] ras: mem: Add memory ACPI RAS2 driver
Date: Tue, 2 Sep 2025 18:30:40 +0100
Message-ID: <20250902173043.1796-3-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <20250902173043.1796-1-shiju.jose@huawei.com>
References: <20250902173043.1796-1-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.48.150.145]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 frapeml500007.china.huawei.com (7.182.85.172)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D58D91C0017
X-Stat-Signature: cce39qypras7ki8uot77ok8jupuupgxa
X-Rspam-User: 
X-HE-Tag: 1756834260-862393
X-HE-Meta: U2FsdGVkX18NMYsvbmAn+Cv+ewcJ7NdKoRri0NKWOoLrFtGvZ7dXrhkkTZ66GLNIT0pfxve5/znNPdtdu4e5DFFtFu98ASt7t/qoRVSS92eI7+2iexEaqc5x1UQrNwfTIAnkaLg7yuANc7kbDCsMEZz0ltVQyL7Rvy4cmdSMHnAGnPaSZP/tz8kk2xHcFcpUKTBf9a1XyakKeh0mP6PDqySrAqgbNN5ryIM82BAaAgEpqsZNiIsfQ44qb9JPP0RaMM2YWoA8A21CQL7RGGdH/YLzHNDwRWPV56/0xTZsrmOxCyMvNVpnou1jZdwjrTYc8w8QTMyVp2+W3abNSDFFWtp4Jpf8maDRUleEAKYg/uQlPpOjFh7vcSstDjEJjiftJca1dPpJZ4dkmIDydkEywEA3mlm+6HoNClj3UctNNR5O7OJ4CModAsDDZJGlcBfClcvuFpVANKpRPnerCcHLAQZHzsdtTcj/D5wf1gnUe/w3+z1zkCwZtuLd+Xwhq7F9H7Xvczo30cknk8Qc+fy4CBotrnC/UIxjAZPjnpRGpH8/k4fa0vHjk1vLHansww5NXoDJBkmLyDS4DV6XtbAS5KSLnL02uxGoTbuZlREKsjgxUXz0EGfkn1CBezAaV5byFA/bjC4Q7S7uLutTNT53T9w3BWlW89rUJSvwQllT6BZo5QJhZ20W7hYpFuEOMD+jGvI6WEv05ern7XkkUg1iBq/kejBS2W7C1envmnqtTfCosNMBTAW9fiLCza08yjf9LTE8abueCeawTM6CJQmCeL3OwkBfI+dN4yn7K4O/+AOWTyglOBiDyacbIiNCV/tCesjG9thUk1l9PQhv08bWs+nDaMEI+kmnehdQiHDTCMp43RR3NMo6NP2dM6rgOVkVaVm/7Qg8eTy9jyfFyowVxV5HAscFSDd1GHkb0cgAneAZIxve0H5R9qkdPy1U8BBte2E4NZwKzO1T899+qf3
 It7cz31R
 NS8Vv1PaDrtELtCjvzKiNsZvHhYbSNqtVCk6cG0BWFlbsxA0VQ4wkDQSGCLde7TtUW+6f6I+LEst9vxppUBvttjoKmpoH7fI0EwaFZwpcLL5XJX5eQ3nFbNGd5j08klT7bTAxSswpqzGB4QzhROzr1pjD9tvdMYrXtIIY7unqpZJ4xpk6YAkLwYPJVkKZsbdNvt2OwzBA+aXR0Sp9q9QcIOphNzJLnskPE9AEQWChEBgy5HinPLrLaAty8QrY7duVKOmadx/bHg899h+e2aZTUyEib+D1jhO5TJjQRaEoQJK3LCg9j9EE7+3+kZk72mEAY0VAdFu/7y6LgtbkhZVZDOjR/VY+GOfiFI3P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shiju Jose <shiju.jose@huawei.com>

Memory ACPI RAS2 auxiliary driver binds to the auxiliary device
add by the ACPI RAS2 table parser.

Driver uses a PCC subspace for communicating with the ACPI compliant
platform.

According to the ACPI specification rev 6.5, section 5.2.21.1.1
RAS2 Platform Communication Channel Descriptor, “RAS2 supports multiple
PCC channels, where a channel is dedicated to a given component
instance.”
Device with ACPI RAS2 scrub feature registers with EDAC device driver,
which retrieves the scrub descriptor from EDAC scrub and exposes
the scrub control attributes for RAS2 scrub instance to userspace in
/sys/bus/edac/devices/acpi_ras_memX/scrub0/.

Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
---
 Documentation/edac/scrub.rst |  73 ++++++
 drivers/ras/Kconfig          |  11 +
 drivers/ras/Makefile         |   1 +
 drivers/ras/acpi_ras2.c      | 424 +++++++++++++++++++++++++++++++++++
 include/acpi/ras2.h          |  14 ++
 5 files changed, 523 insertions(+)
 create mode 100644 drivers/ras/acpi_ras2.c

diff --git a/Documentation/edac/scrub.rst b/Documentation/edac/scrub.rst
index 2cfa74fa1ffd..4c6ee84fb691 100644
--- a/Documentation/edac/scrub.rst
+++ b/Documentation/edac/scrub.rst
@@ -340,3 +340,76 @@ controller or platform when unexpectedly high error rates are detected.
 
 Sysfs files for scrubbing are documented in
 `Documentation/ABI/testing/sysfs-edac-ecs`
+
+3. ACPI RAS2 Hardware-based Memory Scrubbing
+
+3.1. On demand scrubbing for a specific memory region.
+
+3.1.1. Query the status of demand scrubbing
+
+Readback 'addr', non-zero - demand scrub is in progress, zero - scrub is finished.
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/addr
+
+0
+
+3.1.2. Query what is device default/current scrub cycle setting.
+
+       Applicable to both on-demand and background scrubbing.
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/current_cycle_duration
+
+36000
+
+3.1.3. Query the range of device supported scrub cycle for a memory region.
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/min_cycle_duration
+
+3600
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/max_cycle_duration
+
+86400
+
+3.1.4. Program scrubbing for the memory region in RAS2 device to repeat every
+43200 seconds (half a day).
+
+# echo 43200 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/current_cycle_duration
+
+3.1.5. Program address and size of the memory region to scrub
+
+Write 'size' of the memory region to scrub.
+
+# echo 0x300000 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/size
+
+Write 'addr' starts demand scrubbing, please make sure other attributes are
+set prior to that.
+
+# echo 0x200000 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/addr
+
+Readback 'addr', non-zero - demand scrub is in progress, zero - scrub is finished.
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/addr
+
+0x200000
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/addr
+
+0
+
+3.2. Background scrubbing the entire memory
+
+3.2.1. Query the status of background scrubbing.
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_background
+
+0
+
+3.2.2. Program background scrubbing for RAS2 device to repeat in every 21600
+seconds (quarter of a day).
+
+# echo 21600 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/current_cycle_duration
+
+3.2.3. Start 'background scrubbing'.
+
+# echo 1 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_background
diff --git a/drivers/ras/Kconfig b/drivers/ras/Kconfig
index fc4f4bb94a4c..a88002f1f462 100644
--- a/drivers/ras/Kconfig
+++ b/drivers/ras/Kconfig
@@ -46,4 +46,15 @@ config RAS_FMPM
 	  Memory will be retired during boot time and run time depending on
 	  platform-specific policies.
 
+config MEM_ACPI_RAS2
+	tristate "Memory ACPI RAS2 driver"
+	depends on ACPI_RAS2
+	depends on EDAC
+	depends on EDAC_SCRUB
+	help
+	  The driver binds to the platform device added by the ACPI RAS2
+	  table parser. Use a PCC channel subspace for communicating with
+	  the ACPI compliant platform to provide control of memory scrub
+	  parameters to the user via the EDAC scrub.
+
 endif
diff --git a/drivers/ras/Makefile b/drivers/ras/Makefile
index 11f95d59d397..a0e6e903d6b0 100644
--- a/drivers/ras/Makefile
+++ b/drivers/ras/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_RAS)	+= ras.o
 obj-$(CONFIG_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_RAS_CEC)	+= cec.o
+obj-$(CONFIG_MEM_ACPI_RAS2)	+= acpi_ras2.o
 
 obj-$(CONFIG_RAS_FMPM)	+= amd/fmpm.o
 obj-y			+= amd/atl/
diff --git a/drivers/ras/acpi_ras2.c b/drivers/ras/acpi_ras2.c
new file mode 100644
index 000000000000..3971653b477a
--- /dev/null
+++ b/drivers/ras/acpi_ras2.c
@@ -0,0 +1,424 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * ACPI RAS2 memory driver
+ *
+ * Copyright (c) 2024-2025 HiSilicon Limited.
+ *
+ */
+
+#define pr_fmt(fmt)	"ACPI RAS2 MEMORY: " fmt
+
+#include <linux/bitfield.h>
+#include <linux/edac.h>
+#include <linux/platform_device.h>
+#include <acpi/ras2.h>
+
+#define RAS2_SUPPORT_HW_PARTOL_SCRUB BIT(0)
+#define RAS2_TYPE_PATROL_SCRUB 0x0000
+
+#define RAS2_GET_PATROL_PARAMETERS 0x01
+#define RAS2_START_PATROL_SCRUBBER 0x02
+#define RAS2_STOP_PATROL_SCRUBBER 0x03
+
+/*
+ * RAS2 patrol scrub
+ */
+#define RAS2_PS_SC_HRS_IN_MASK GENMASK(15, 8)
+#define RAS2_PS_EN_BACKGROUND BIT(0)
+#define RAS2_PS_SC_HRS_OUT_MASK GENMASK(7, 0)
+#define RAS2_PS_MIN_SC_HRS_OUT_MASK GENMASK(15, 8)
+#define RAS2_PS_MAX_SC_HRS_OUT_MASK GENMASK(23, 16)
+#define RAS2_PS_FLAG_SCRUB_RUNNING BIT(0)
+
+#define RAS2_SCRUB_NAME_LEN 128
+#define RAS2_HOUR_IN_SECS 3600
+
+enum ras2_od_scrub_status {
+	OD_SCRUB_STS_IDLE,
+	OD_SCRUB_STS_INIT,
+	OD_SCRUB_STS_ACTIVE,
+};
+
+struct acpi_ras2_ps_shared_mem {
+	struct acpi_ras2_shmem common;
+	struct acpi_ras2_patrol_scrub_param params;
+};
+
+#define TO_ACPI_RAS2_PS_SHMEM(_addr) \
+	container_of(_addr, struct acpi_ras2_ps_shared_mem, common)
+
+static int ras2_is_patrol_scrub_support(struct ras2_mem_ctx *ras2_ctx)
+{
+	struct acpi_ras2_shmem __iomem *common = (void *)ras2_ctx->comm_addr;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	common->set_caps[0] = 0;
+
+	return common->features[0] & RAS2_SUPPORT_HW_PARTOL_SCRUB;
+}
+
+static int ras2_update_patrol_scrub_params_cache(struct ras2_mem_ctx *ras2_ctx)
+{
+	struct acpi_ras2_ps_shared_mem __iomem *ps_sm =
+		TO_ACPI_RAS2_PS_SHMEM(ras2_ctx->comm_addr);
+	int ret;
+
+	ps_sm->common.set_caps[0] = RAS2_SUPPORT_HW_PARTOL_SCRUB;
+	ps_sm->params.command = RAS2_GET_PATROL_PARAMETERS;
+	ps_sm->params.req_addr_range[0] = ras2_ctx->mem_base_addr;
+	ps_sm->params.req_addr_range[1] = ras2_ctx->mem_size;
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(ras2_ctx->dev, "failed to read parameters\n");
+		return ret;
+	}
+
+	ras2_ctx->min_scrub_cycle = FIELD_GET(RAS2_PS_MIN_SC_HRS_OUT_MASK,
+					      ps_sm->params.scrub_params_out);
+	ras2_ctx->max_scrub_cycle = FIELD_GET(RAS2_PS_MAX_SC_HRS_OUT_MASK,
+					      ps_sm->params.scrub_params_out);
+	ras2_ctx->scrub_cycle_hrs = FIELD_GET(RAS2_PS_SC_HRS_OUT_MASK,
+					      ps_sm->params.scrub_params_out);
+	if (ras2_ctx->bg_scrub) {
+		ras2_ctx->base = 0;
+		ras2_ctx->size = 0;
+		ras2_ctx->od_scrub_sts = OD_SCRUB_STS_IDLE;
+		return 0;
+	}
+
+	if  (ps_sm->params.flags & RAS2_PS_FLAG_SCRUB_RUNNING) {
+		ras2_ctx->base = ps_sm->params.actl_addr_range[0];
+		ras2_ctx->size = ps_sm->params.actl_addr_range[1];
+	} else if (ras2_ctx->od_scrub_sts != OD_SCRUB_STS_INIT) {
+		/*
+		 * When demand scrubbing is finished driver resets actual
+		 * address range to 0 when readback. Otherwise userspace
+		 * assumes demand scrubbing is in progress.
+		 */
+		ras2_ctx->base = 0;
+		ras2_ctx->size = 0;
+		ras2_ctx->od_scrub_sts = OD_SCRUB_STS_IDLE;
+	}
+
+	return 0;
+}
+
+/* Context - PCC lock must be held */
+static int ras2_get_patrol_scrub_running(struct ras2_mem_ctx *ras2_ctx,
+					 bool *running)
+{
+	struct acpi_ras2_ps_shared_mem __iomem *ps_sm =
+		TO_ACPI_RAS2_PS_SHMEM(ras2_ctx->comm_addr);
+	int ret;
+
+	ps_sm->common.set_caps[0] = RAS2_SUPPORT_HW_PARTOL_SCRUB;
+	ps_sm->params.command = RAS2_GET_PATROL_PARAMETERS;
+	ps_sm->params.req_addr_range[0] = ras2_ctx->mem_base_addr;
+	ps_sm->params.req_addr_range[1] = ras2_ctx->mem_size;
+
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(ras2_ctx->dev, "failed to read parameters\n");
+		return ret;
+	}
+
+	*running = ps_sm->params.flags & RAS2_PS_FLAG_SCRUB_RUNNING;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_read_min_scrub_cycle(struct device *dev, void *drv_data,
+					      u32 *min)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	*min = ras2_ctx->min_scrub_cycle * RAS2_HOUR_IN_SECS;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_read_max_scrub_cycle(struct device *dev, void *drv_data,
+					      u32 *max)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	*max = ras2_ctx->max_scrub_cycle * RAS2_HOUR_IN_SECS;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_cycle_read(struct device *dev, void *drv_data,
+				    u32 *scrub_cycle_secs)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	*scrub_cycle_secs = ras2_ctx->scrub_cycle_hrs * RAS2_HOUR_IN_SECS;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_cycle_write(struct device *dev, void *drv_data,
+				     u32 scrub_cycle_secs)
+{
+	u8 scrub_cycle_hrs = scrub_cycle_secs / RAS2_HOUR_IN_SECS;
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	bool running;
+	int ret;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_get_patrol_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	if (running)
+		return -EBUSY;
+
+	if (scrub_cycle_hrs < ras2_ctx->min_scrub_cycle ||
+	    scrub_cycle_hrs > ras2_ctx->max_scrub_cycle)
+		return -EINVAL;
+
+	ras2_ctx->scrub_cycle_hrs = scrub_cycle_hrs;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_read_addr(struct device *dev, void *drv_data, u64 *base)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	int ret;
+
+	/*
+	 * When BG scrubbing is enabled the actual address range is not valid.
+	 * Return -EBUSY now unless find out a method to retrieve actual full PA range.
+	 */
+	if (ras2_ctx->bg_scrub)
+		return -EBUSY;
+
+	ret = ras2_update_patrol_scrub_params_cache(ras2_ctx);
+	if (ret)
+		return ret;
+
+	*base = ras2_ctx->base;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_read_size(struct device *dev, void *drv_data, u64 *size)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	int ret;
+
+	if (ras2_ctx->bg_scrub)
+		return -EBUSY;
+
+	ret = ras2_update_patrol_scrub_params_cache(ras2_ctx);
+	if (ret)
+		return ret;
+
+	*size = ras2_ctx->size;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_write_addr(struct device *dev, void *drv_data, u64 base)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	struct acpi_ras2_ps_shared_mem __iomem *ps_sm =
+		TO_ACPI_RAS2_PS_SHMEM(ras2_ctx->comm_addr);
+	bool running;
+	int ret;
+
+	if (ras2_ctx->bg_scrub)
+		return -EBUSY;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ps_sm->common.set_caps[0] = RAS2_SUPPORT_HW_PARTOL_SCRUB;
+
+	if (!ras2_ctx->size || ras2_ctx->size > ras2_ctx->mem_size ||
+	    base < ras2_ctx->mem_base_addr ||
+	    (base + ras2_ctx->size) >
+		(ras2_ctx->mem_base_addr + ras2_ctx->mem_size)) {
+		dev_warn(dev,
+			 "%s: Invalid address range, base=0x%llx size=0x%llx\n",
+			 __func__, base, ras2_ctx->size);
+		return -ERANGE;
+	}
+
+	ret = ras2_get_patrol_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	if (running)
+		return -EBUSY;
+
+	ras2_ctx->base = base;
+	ps_sm->params.scrub_params_in &= ~RAS2_PS_SC_HRS_IN_MASK;
+	ps_sm->params.scrub_params_in |= FIELD_PREP(RAS2_PS_SC_HRS_IN_MASK,
+						    ras2_ctx->scrub_cycle_hrs);
+	ps_sm->params.req_addr_range[0] = ras2_ctx->base;
+	ps_sm->params.req_addr_range[1] = ras2_ctx->size;
+	ps_sm->params.scrub_params_in &= ~RAS2_PS_EN_BACKGROUND;
+	ps_sm->params.command = RAS2_START_PATROL_SCRUBBER;
+
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(dev, "Failed to start demand scrubbing rc(%d)\n", ret);
+		if (ret != -EBUSY) {
+			ps_sm->params.req_addr_range[0] = 0;
+			ps_sm->params.req_addr_range[1] = 0;
+			ras2_ctx->base = 0;
+			ras2_ctx->size = 0;
+			ras2_ctx->od_scrub_sts = OD_SCRUB_STS_IDLE;
+		}
+		return ret;
+	}
+	ras2_ctx->od_scrub_sts = OD_SCRUB_STS_ACTIVE;
+
+	return ras2_update_patrol_scrub_params_cache(ras2_ctx);
+}
+
+static int ras2_hw_scrub_write_size(struct device *dev, void *drv_data, u64 size)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	bool running;
+	int ret;
+
+	if (!size) {
+		dev_warn(dev, "%s: Invalid address range size=0x%llx\n",
+			 __func__, size);
+		return -EINVAL;
+	}
+
+	if (ras2_ctx->bg_scrub)
+		return -EBUSY;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_get_patrol_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	if (running)
+		return -EBUSY;
+
+	ras2_ctx->size = size;
+	ras2_ctx->od_scrub_sts = OD_SCRUB_STS_INIT;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_set_enabled_bg(struct device *dev, void *drv_data, bool enable)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	struct acpi_ras2_ps_shared_mem __iomem *ps_sm =
+		TO_ACPI_RAS2_PS_SHMEM(ras2_ctx->comm_addr);
+	bool running;
+	int ret;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ps_sm->common.set_caps[0] = RAS2_SUPPORT_HW_PARTOL_SCRUB;
+	ret = ras2_get_patrol_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	if (enable) {
+		if (ras2_ctx->bg_scrub || running)
+			return -EBUSY;
+		ps_sm->params.req_addr_range[0] = 0;
+		ps_sm->params.req_addr_range[1] = 0;
+		ps_sm->params.scrub_params_in &= ~RAS2_PS_SC_HRS_IN_MASK;
+		ps_sm->params.scrub_params_in |= FIELD_PREP(RAS2_PS_SC_HRS_IN_MASK,
+							    ras2_ctx->scrub_cycle_hrs);
+		ps_sm->params.command = RAS2_START_PATROL_SCRUBBER;
+	} else {
+		if (!ras2_ctx->bg_scrub)
+			return -EPERM;
+		ps_sm->params.command = RAS2_STOP_PATROL_SCRUBBER;
+	}
+
+	ps_sm->params.scrub_params_in &= ~RAS2_PS_EN_BACKGROUND;
+	ps_sm->params.scrub_params_in |= FIELD_PREP(RAS2_PS_EN_BACKGROUND,
+						    enable);
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(dev, "Failed to %s background scrubbing\n",
+			str_enable_disable(enable));
+		return ret;
+	}
+
+	if (enable) {
+		ras2_ctx->bg_scrub = true;
+		/* Update the cache to account for rounding of supplied parameters and similar */
+		ret = ras2_update_patrol_scrub_params_cache(ras2_ctx);
+	} else {
+		ret = ras2_update_patrol_scrub_params_cache(ras2_ctx);
+		ras2_ctx->bg_scrub = false;
+	}
+
+	return ret;
+}
+
+static int ras2_hw_scrub_get_enabled_bg(struct device *dev, void *drv_data, bool *enabled)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	*enabled = ras2_ctx->bg_scrub;
+
+	return 0;
+}
+
+static const struct edac_scrub_ops ras2_scrub_ops = {
+	.read_addr = ras2_hw_scrub_read_addr,
+	.read_size = ras2_hw_scrub_read_size,
+	.write_addr = ras2_hw_scrub_write_addr,
+	.write_size = ras2_hw_scrub_write_size,
+	.get_enabled_bg = ras2_hw_scrub_get_enabled_bg,
+	.set_enabled_bg = ras2_hw_scrub_set_enabled_bg,
+	.get_min_cycle = ras2_hw_scrub_read_min_scrub_cycle,
+	.get_max_cycle = ras2_hw_scrub_read_max_scrub_cycle,
+	.get_cycle_duration = ras2_hw_scrub_cycle_read,
+	.set_cycle_duration = ras2_hw_scrub_cycle_write,
+};
+
+static int ras2_probe(struct auxiliary_device *auxdev,
+		      const struct auxiliary_device_id *id)
+{
+	struct ras2_mem_ctx *ras2_ctx = container_of(auxdev, struct ras2_mem_ctx, adev);
+	struct edac_dev_feature ras_features;
+	char scrub_name[RAS2_SCRUB_NAME_LEN];
+	int ret;
+
+	if (!ras2_is_patrol_scrub_support(ras2_ctx))
+		return -EOPNOTSUPP;
+
+	ret = ras2_update_patrol_scrub_params_cache(ras2_ctx);
+	if (ret)
+		return ret;
+
+	sprintf(scrub_name, "acpi_ras_mem%d", auxdev->id);
+
+	ras_features.ft_type	= RAS_FEAT_SCRUB;
+	ras_features.instance	= 0;
+	ras_features.scrub_ops	= &ras2_scrub_ops;
+	ras_features.ctx	= ras2_ctx;
+
+	return edac_dev_register(&auxdev->dev, scrub_name, NULL, 1,
+				 &ras_features);
+}
+
+static const struct auxiliary_device_id ras2_mem_dev_id_table[] = {
+	{ .name = RAS2_AUX_DEV_NAME "." RAS2_MEM_DEV_ID_NAME, },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(auxiliary, ras2_mem_dev_id_table);
+
+static struct auxiliary_driver ras2_mem_driver = {
+	.name = RAS2_MEM_DEV_ID_NAME,
+	.probe = ras2_probe,
+	.id_table = ras2_mem_dev_id_table,
+};
+module_auxiliary_driver(ras2_mem_driver);
+
+MODULE_IMPORT_NS("ACPI_RAS2");
+MODULE_DESCRIPTION("ACPI RAS2 memory driver");
+MODULE_LICENSE("GPL");
diff --git a/include/acpi/ras2.h b/include/acpi/ras2.h
index cb053b5f37e7..fe7b7c454ac8 100644
--- a/include/acpi/ras2.h
+++ b/include/acpi/ras2.h
@@ -41,6 +41,13 @@ struct device;
  *			of the memory associated with the NUMA domain
  * @mem_size		Size of the lowest physical continuous memory range
  *			of the memory associated with the NUMA domain
+ * @base:		Base address of the memory region to scrub
+ * @size:		Size of the memory region to scrub
+ * @scrub_cycle_hrs:	Current scrub rate in hours
+ * @min_scrub_cycle:	Minimum scrub rate supported
+ * @max_scrub_cycle:	Maximum scrub rate supported
+ * @od_scrub_sts:	Status of demand scrubbing (memory region)
+ * @bg_scrub:		Status of background patrol scrubbing
  */
 struct ras2_mem_ctx {
 	struct auxiliary_device		adev;
@@ -51,6 +58,13 @@ struct ras2_mem_ctx {
 	u32				sys_comp_nid;
 	u64				mem_base_addr;
 	u64				mem_size;
+	u64				base;
+	u64				size;
+	u8				scrub_cycle_hrs;
+	u8				min_scrub_cycle;
+	u8				max_scrub_cycle;
+	u8				od_scrub_sts;
+	bool				bg_scrub;
 };
 
 #ifdef CONFIG_ACPI_RAS2
-- 
2.43.0


