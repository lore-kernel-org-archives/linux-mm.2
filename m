Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F7E01125850
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 15:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3886B008A; Wed, 11 Mar 2026 11:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16D546B008C; Wed, 11 Mar 2026 11:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088D46B0092; Wed, 11 Mar 2026 11:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD3186B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:55:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53E81C13F3
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:55:47 +0000 (UTC)
X-FDA: 84534232734.24.83ABD4B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4010F14001A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:55:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773244545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B08/QrIxYzvxkhELXtc4dQgqSYmBP2yskH6jh9aQpTY=;
	b=ofa65/FNQH55XI48c61rxtxtMcXGqJ+iX0+YZH3kCRNbQFt7LfzW1G5hi4wKRH48IuAvBr
	4uA9i4yyZUdhPQSMPBmUDmhKjxc3LB6QjLVf7yfazrQ2vi0FKNL8O8Uok7Ts7hl3kUz1KG
	HxbOiKvdiGbiRXO1Mh1HuaPmR/qu0jg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773244545; a=rsa-sha256;
	cv=none;
	b=FY7X7wOl3ClyliacTqMoKUomjodWz+7idfzjQiWEuIvdjOMm9+UOcEIAALrCOh0z65UiIr
	lrW311ktdwNhqMNQ5DN/q6mXvhI1K9P9y7HDs/KSr0FMufcNH/MLl4yYO1pGN8Ny4oqkpq
	91jTTk1w9wlP8B44l6Y7cTxziZf0BtM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fWFgj0HqJzJ46hv;
	Wed, 11 Mar 2026 23:54:57 +0800 (CST)
Received: from dubpeml500008.china.huawei.com (unknown [7.214.146.94])
	by mail.maildlp.com (Postfix) with ESMTPS id 6CCC54056A;
	Wed, 11 Mar 2026 23:55:43 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.48.149.67) by
 dubpeml500008.china.huawei.com (7.214.146.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 11 Mar 2026 15:55:41 +0000
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
Subject: [PATCH v17 2/2] ras: mem: Add ACPI RAS2 memory driver
Date: Wed, 11 Mar 2026 15:55:17 +0000
Message-ID: <20260311155518.1000-3-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <20260311155518.1000-1-shiju.jose@huawei.com>
References: <20260311155518.1000-1-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.48.149.67]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500008.china.huawei.com (7.214.146.94)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4010F14001A
X-Stat-Signature: sdeohwukxjs9eusuxe6md6pfqttr9gzx
X-HE-Tag: 1773244545-847743
X-HE-Meta: U2FsdGVkX1/I3SQVe8sTEXZznE4lOQWQTAquXEUXNMie3+nJ9xr5pMW+ky+K8FMv/huYeNgBI2n+B0bkkr6/7wMaSM6wbvuaYcemxh4F9wV26tPR89xLf0yOMT95SQ+4yEBTi9yxFu24ysxF7XHXD/jvOiDJ8cT1hDyDwBbWDiumEq402ngTqZYX3luKicT2MHaERl4Ra0jkNfJG2NCaBsG3PjkkV9hjLYfI/6l/iaGGXL2QB0vjxWXKECpbSxhPuo2tIV1JwkQeEY7+3m9YQ/041XS1HdcuErelSZBVD9EJIqCySLLi+lIvRCV3HPxzntBNXoxlPZ3vOOo0iamd1dB9d+ttPbKtxw0DPrGEReFt7lCwgdyGE6av1tHzCsTpXN+s2hp1BIC/o7rXN362xRyYC97Hh90k1uMMxsOpmZuEftwUIElHzjUKnXLNgTD9F7xFjDUkI/1VZ6n1t7cQz8OAZYsNYjjpeYnuWSsRgdAHpzQpqGISd2+QqKXpLCMMi3MTSZDwDOEOtmNg4ax7/1d6UqyKlCnN7xSN4staC6grOQWDjnW+r6uuxUs9mGS1Of18tDrLd3s2FNBaH8KLKVSOgNP+Vyu9gtea+1/ceFjV0UJLshH+ESyByh/wFbAcdvUSlP/jwSxvaCDKT7fdTCAVybAAMdj8qqaaiL33X0erIGjR7T9Djw7GvRNGm5vq324ev+7OC3pah92KYnlak8GikA/iWQwW0NU+hjYUD68whYmkKmeFbMqAcsotG5WbXbGwwHXLjvuwNhAoX2G7SVRmiZyYfWbsT5fpZMzAp4kNZB7c3xze1R3I+cJwCNf8RpyLtPNprzenIMplBnomvXbnrdjLLiquXKRLa7gYUTcPJ0eSskTpS98qKYKyxWgQJ6UDx7GPc/rVoHKNdO7dlvfPt9McDyZKA5TBly3QSNTTOk9+r56AuhzxcE216ET4O9V8eyRmwZKzFXyRBXb
 4t5WwjOU
 H9WbJ0tFEj3ccUf+WjbPRijOLOvzTmtOZdA+fQevjNG7SsCOYhdAlZ9ndYv6Vedm2E9J/yKt9BvM1jzJdsyMBSXiLMfqQK9REo6jpI/jC3iteuIJak0XHeDnxrzQtyGx3PisqDHMAtUGCzJLR5LlvqqcS3uLUH/oSA4LKf9p7qnjbUEMSUA80LM6VPVKL6WI28EPU2faJVXiYJnlN99j883mGWw6VYweLbVedlD3FpDkjkqDauQWGIKHGiNBJ+j3Qy8SkSGBNv4RIfscYajnGT5q00cfhm+VWfmDDCZrbglTPhz26+ImBNzaDPrV5XHSmNgZQSS3ifSDAoMunclnOGPRsawKVgLK2wN9N99IK4f5929PqolJslfSRoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shiju Jose <shiju.jose@huawei.com>

ACPI 6.5 Specification, section 5.2.21, defined RAS2 feature table (RAS2).
Driver adds support for RAS2 feature table, which provides interfaces for
platform RAS features, e.g., for HW-based memory scrubbing, and logical to
PA translation service. RAS2 uses PCC channel subspace for communicating
with the ACPI compliant HW platform.

ACPI RAS2 auxiliary driver for the memory features binds to the auxiliary
device, which is added by the RAS2 table parser in the ACPI RAS2 driver.

Given the address range is not provided to userspace (and hence no
chance of exposing misleading values), even in the presence
of disjoint address ranges, use the start to end of the NUMA node
with the expectation that a firmware will allow that to indicate that
the full node will be scrubbed, skipping address ranges that are from
other NUMA nodes but happen to lie within this range.

Driver retrieves the PA range of the NUMA domain and use it as the
'Requested Address Range', when send RAS2 command GET_PATROL_PARAMETERS
to get parameters that apply to all addresses in the NUMA domain as well
as when send command START_PATROL_SCRUBBER to start the demand scrubbing.

Device with ACPI RAS2 scrub feature registers with EDAC device driver,
which retrieves the scrub descriptor from EDAC scrub and exposes
the scrub control attributes for RAS2 scrub instance to userspace in
/sys/bus/edac/devices/acpi_ras_memX/scrub0/.

Add 'enable_demand' attribute to the EDAC scrub interface to start/stop
the demand scrub, which is used in the RAS2 demand scrub control.
When a demand scrub is started, any background scrub currently in progress
will be stopped and then automatically restarted at the beginning when the
demand scrub has completed.

In the future, RAS2 driver may add support for the ‘addr’ and ‘size’ EDAC
scrub-control attributes, to enable the user to set address range of the
memory region to scrub.

Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
---
 Documentation/ABI/testing/sysfs-edac-scrub |  13 +-
 Documentation/edac/scrub.rst               |  60 +++
 drivers/edac/scrub.c                       |  12 +
 drivers/ras/Kconfig                        |  13 +
 drivers/ras/Makefile                       |   1 +
 drivers/ras/acpi_ras2.c                    | 403 +++++++++++++++++++++
 include/acpi/ras2.h                        |  17 +
 include/linux/edac.h                       |   4 +
 8 files changed, 518 insertions(+), 5 deletions(-)
 create mode 100644 drivers/ras/acpi_ras2.c

diff --git a/Documentation/ABI/testing/sysfs-edac-scrub b/Documentation/ABI/testing/sysfs-edac-scrub
index ab6014743da5..3f68f63556f4 100644
--- a/Documentation/ABI/testing/sysfs-edac-scrub
+++ b/Documentation/ABI/testing/sysfs-edac-scrub
@@ -20,11 +20,7 @@ KernelVersion:	6.15
 Contact:	linux-edac@vger.kernel.org
 Description:
 		(RW) The base address of the memory region to be scrubbed
-		for on-demand scrubbing. Setting address starts scrubbing.
-		The size must be set before that.
-
-		The readback addr value is non-zero if the requested
-		on-demand scrubbing is in progress, zero otherwise.
+		for demand scrubbing.
 
 What:		/sys/bus/edac/devices/<dev-name>/scrubX/size
 Date:		March 2025
@@ -34,6 +30,13 @@ Description:
 		(RW) The size of the memory region to be scrubbed
 		(on-demand scrubbing).
 
+What:		/sys/bus/edac/devices/<dev-name>/scrubX/enable_demand
+Date:		Jan 2026
+KernelVersion:	6.19
+Contact:	linux-edac@vger.kernel.org
+Description:
+		(RW) Start/Stop demand scrubbing if supported.
+
 What:		/sys/bus/edac/devices/<dev-name>/scrubX/enable_background
 Date:		March 2025
 KernelVersion:	6.15
diff --git a/Documentation/edac/scrub.rst b/Documentation/edac/scrub.rst
index 2cfa74fa1ffd..deefc45116ab 100644
--- a/Documentation/edac/scrub.rst
+++ b/Documentation/edac/scrub.rst
@@ -340,3 +340,63 @@ controller or platform when unexpectedly high error rates are detected.
 
 Sysfs files for scrubbing are documented in
 `Documentation/ABI/testing/sysfs-edac-ecs`
+
+3. ACPI RAS2 Hardware-based Memory Scrubbing
+
+3.1. On demand scrubbing for a specific memory region.
+
+3.1.1. Query the status of demand scrubbing
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_demand
+
+0
+
+3.1.2. Query what is device default/current scrub cycle setting.
+
+Applicable to both demand and background scrubbing. The unit of the
+scrub cycle is seconds.
+
+# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/current_cycle_duration
+
+36000
+
+3.1.3. Query the range of device supported scrub cycle for a memory region.
+The unit of the scrub cycle range is seconds.
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
+3.1.5. Start 'demand scrubbing'.
+
+When a demand scrub is started, any background scrub currently in progress
+will be stopped and then automatically restarted at the beginning when the
+demand scrub has completed.
+
+# echo 1 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_demand
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
diff --git a/drivers/edac/scrub.c b/drivers/edac/scrub.c
index f9d02af2fc3a..f3b9a2f04950 100644
--- a/drivers/edac/scrub.c
+++ b/drivers/edac/scrub.c
@@ -14,6 +14,7 @@ enum edac_scrub_attributes {
 	SCRUB_ADDRESS,
 	SCRUB_SIZE,
 	SCRUB_ENABLE_BACKGROUND,
+	SCRUB_ENABLE_DEMAND,
 	SCRUB_MIN_CYCLE_DURATION,
 	SCRUB_MAX_CYCLE_DURATION,
 	SCRUB_CUR_CYCLE_DURATION,
@@ -55,6 +56,7 @@ static ssize_t attrib##_show(struct device *ras_feat_dev,			\
 EDAC_SCRUB_ATTR_SHOW(addr, read_addr, u64, "0x%llx\n")
 EDAC_SCRUB_ATTR_SHOW(size, read_size, u64, "0x%llx\n")
 EDAC_SCRUB_ATTR_SHOW(enable_background, get_enabled_bg, bool, "%u\n")
+EDAC_SCRUB_ATTR_SHOW(enable_demand, get_enabled_od, bool, "%u\n")
 EDAC_SCRUB_ATTR_SHOW(min_cycle_duration, get_min_cycle, u32, "%u\n")
 EDAC_SCRUB_ATTR_SHOW(max_cycle_duration, get_max_cycle, u32, "%u\n")
 EDAC_SCRUB_ATTR_SHOW(current_cycle_duration, get_cycle_duration, u32, "%u\n")
@@ -84,6 +86,7 @@ static ssize_t attrib##_store(struct device *ras_feat_dev,			\
 EDAC_SCRUB_ATTR_STORE(addr, write_addr, u64, kstrtou64)
 EDAC_SCRUB_ATTR_STORE(size, write_size, u64, kstrtou64)
 EDAC_SCRUB_ATTR_STORE(enable_background, set_enabled_bg, unsigned long, kstrtoul)
+EDAC_SCRUB_ATTR_STORE(enable_demand, set_enabled_od, unsigned long, kstrtoul)
 EDAC_SCRUB_ATTR_STORE(current_cycle_duration, set_cycle_duration, unsigned long, kstrtoul)
 
 static umode_t scrub_attr_visible(struct kobject *kobj, struct attribute *a, int attr_id)
@@ -119,6 +122,14 @@ static umode_t scrub_attr_visible(struct kobject *kobj, struct attribute *a, int
 				return 0444;
 		}
 		break;
+	case SCRUB_ENABLE_DEMAND:
+		if (ops->get_enabled_od) {
+			if (ops->set_enabled_od)
+				return a->mode;
+			else
+				return 0444;
+		}
+		break;
 	case SCRUB_MIN_CYCLE_DURATION:
 		if (ops->get_min_cycle)
 			return a->mode;
@@ -164,6 +175,7 @@ static int scrub_create_desc(struct device *scrub_dev,
 		[SCRUB_ADDRESS] = EDAC_SCRUB_ATTR_RW(addr, instance),
 		[SCRUB_SIZE] = EDAC_SCRUB_ATTR_RW(size, instance),
 		[SCRUB_ENABLE_BACKGROUND] = EDAC_SCRUB_ATTR_RW(enable_background, instance),
+		[SCRUB_ENABLE_DEMAND] = EDAC_SCRUB_ATTR_RW(enable_demand, instance),
 		[SCRUB_MIN_CYCLE_DURATION] = EDAC_SCRUB_ATTR_RO(min_cycle_duration, instance),
 		[SCRUB_MAX_CYCLE_DURATION] = EDAC_SCRUB_ATTR_RO(max_cycle_duration, instance),
 		[SCRUB_CUR_CYCLE_DURATION] = EDAC_SCRUB_ATTR_RW(current_cycle_duration, instance)
diff --git a/drivers/ras/Kconfig b/drivers/ras/Kconfig
index fc4f4bb94a4c..a1e6aed8bcc8 100644
--- a/drivers/ras/Kconfig
+++ b/drivers/ras/Kconfig
@@ -46,4 +46,17 @@ config RAS_FMPM
 	  Memory will be retired during boot time and run time depending on
 	  platform-specific policies.
 
+config MEM_ACPI_RAS2
+	tristate "Memory ACPI RAS2 driver"
+	depends on ACPI_RAS2
+	depends on EDAC
+	depends on EDAC_SCRUB
+	select NUMA_KEEP_MEMINFO
+	help
+	  The driver binds to the auxiliary device added by the ACPI RAS2
+	  feature table parser. The driver uses a PCC channel subspace to
+	  communicate with the ACPI-compliant platform and provides
+	  control of the HW-based memory scrubber parameters to the user
+	  through the EDAC scrub interface.
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
index 000000000000..ca71507e5eda
--- /dev/null
+++ b/drivers/ras/acpi_ras2.c
@@ -0,0 +1,403 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * ACPI RAS2 memory driver
+ *
+ * Copyright (c) 2024-2026 HiSilicon Limited.
+ *
+ */
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"ACPI RAS2 MEMORY: " fmt
+
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/edac.h>
+#include <linux/kthread.h>
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
+struct acpi_ras2_ps_shared_mem {
+	struct acpi_ras2_shmem common;
+	struct acpi_ras2_patrol_scrub_param params;
+};
+
+#define TO_ACPI_RAS2_PS_SHMEM(_addr) \
+	container_of(_addr, struct acpi_ras2_ps_shared_mem, common)
+
+static int ras2_hw_scrub_set_enabled_bg(struct device *dev, void *drv_data, bool enable);
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
+	ps_sm->params.req_addr_range[0] = ras2_ctx->base;
+	ps_sm->params.req_addr_range[1] = ras2_ctx->size;
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(ras2_ctx->dev, "Failed to read patrol scrub parameters\n");
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
+		ras2_ctx->od_scrub = false;
+		return 0;
+	}
+
+	if  (ps_sm->params.flags & RAS2_PS_FLAG_SCRUB_RUNNING)
+		ras2_ctx->od_scrub = true;
+	else
+		ras2_ctx->od_scrub = false;
+
+	return 0;
+}
+
+/* Context - PCC lock must be held */
+static int ras2_get_demand_scrub_running(struct ras2_mem_ctx *ras2_ctx, bool *running)
+{
+	struct acpi_ras2_ps_shared_mem __iomem *ps_sm =
+		TO_ACPI_RAS2_PS_SHMEM(ras2_ctx->comm_addr);
+	int ret;
+
+	if (!ras2_ctx->od_scrub) {
+		*running = false;
+		return 0;
+	}
+
+	ps_sm->common.set_caps[0] = RAS2_SUPPORT_HW_PARTOL_SCRUB;
+	ps_sm->params.command = RAS2_GET_PATROL_PARAMETERS;
+	ps_sm->params.req_addr_range[0] = ras2_ctx->base;
+	ps_sm->params.req_addr_range[1] = ras2_ctx->size;
+
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(ras2_ctx->dev, "Failed to read patrol scrub parameters\n");
+		return ret;
+	}
+
+	*running = ps_sm->params.flags & RAS2_PS_FLAG_SCRUB_RUNNING;
+	if (!(*running))
+		ras2_ctx->od_scrub = false;
+
+	return 0;
+}
+
+static int ras2_scrub_monitor_thread(void *p)
+{
+	struct ras2_mem_ctx *ras2_ctx = (struct ras2_mem_ctx *)p;
+	bool running;
+	int ret;
+
+	while (!kthread_should_stop()) {
+		if (!ras2_ctx->reenable_bg_scrub)
+			return 0;
+
+		mutex_lock(ras2_ctx->pcc_lock);
+		ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+		mutex_unlock(ras2_ctx->pcc_lock);
+		if (ret)
+			return ret;
+
+		if (!running)
+			return ras2_hw_scrub_set_enabled_bg(ras2_ctx->dev, ras2_ctx, true);
+
+		msleep(1000);
+	}
+
+	return 0;
+}
+
+static int ras2_hw_scrub_read_min_scrub_cycle(struct device *dev, void *drv_data, u32 *min)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	*min = ras2_ctx->min_scrub_cycle * RAS2_HOUR_IN_SECS;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_read_max_scrub_cycle(struct device *dev, void *drv_data, u32 *max)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	*max = ras2_ctx->max_scrub_cycle * RAS2_HOUR_IN_SECS;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_cycle_read(struct device *dev, void *drv_data, u32 *scrub_cycle_secs)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	*scrub_cycle_secs = ras2_ctx->scrub_cycle_hrs * RAS2_HOUR_IN_SECS;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_cycle_write(struct device *dev, void *drv_data, u32 scrub_cycle_secs)
+{
+	u32 scrub_cycle_hrs = scrub_cycle_secs / RAS2_HOUR_IN_SECS;
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	bool running;
+	int ret;
+
+	if (ras2_ctx->bg_scrub)
+		return -EBUSY;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
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
+static int ras2_hw_scrub_get_enabled_bg(struct device *dev, void *drv_data, bool *enabled)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+
+	*enabled = ras2_ctx->bg_scrub;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_set_enabled_bg(struct device *dev, void *drv_data, bool enable)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	struct acpi_ras2_ps_shared_mem __iomem *ps_sm = TO_ACPI_RAS2_PS_SHMEM(ras2_ctx->comm_addr);
+	bool running;
+	int ret;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	ps_sm->common.set_caps[0] = RAS2_SUPPORT_HW_PARTOL_SCRUB;
+	if (enable) {
+		if (ras2_ctx->bg_scrub || running)
+			return -EBUSY;
+
+		ps_sm->params.req_addr_range[0] = 0;
+		ps_sm->params.req_addr_range[1] = 0;
+		ps_sm->params.scrub_params_in &= ~RAS2_PS_SC_HRS_IN_MASK;
+		ps_sm->params.scrub_params_in |= FIELD_PREP(RAS2_PS_SC_HRS_IN_MASK,
+							    ras2_ctx->scrub_cycle_hrs);
+		ps_sm->params.command = RAS2_START_PATROL_SCRUBBER;
+	} else {
+		if (!ras2_ctx->bg_scrub)
+			return -EPERM;
+
+		ps_sm->params.command = RAS2_STOP_PATROL_SCRUBBER;
+	}
+
+	ps_sm->params.scrub_params_in &= ~RAS2_PS_EN_BACKGROUND;
+	ps_sm->params.scrub_params_in |= FIELD_PREP(RAS2_PS_EN_BACKGROUND, enable);
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(dev, "Failed to %s background scrubbing\n",
+			str_enable_disable(enable));
+		return ret;
+	}
+
+	ras2_ctx->bg_scrub = enable;
+	if (enable)
+		ras2_ctx->reenable_bg_scrub = false;
+
+	/* Update the cache to account for rounding of supplied parameters and similar */
+	return ras2_update_patrol_scrub_params_cache(ras2_ctx);
+}
+
+static int ras2_hw_scrub_get_enabled_od(struct device *dev, void *drv_data, bool *enabled)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	bool running;
+	int ret;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	*enabled = running;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_set_enabled_od(struct device *dev, void *drv_data, bool enable)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	struct acpi_ras2_ps_shared_mem __iomem *ps_sm = TO_ACPI_RAS2_PS_SHMEM(ras2_ctx->comm_addr);
+	struct task_struct *thrd;
+	bool running;
+	int ret;
+
+	if (!enable)
+		return -EOPNOTSUPP;
+
+	/* Stop any background scrub currently in progress */
+	if (ras2_ctx->bg_scrub) {
+		ret = ras2_hw_scrub_set_enabled_bg(dev, drv_data, false);
+		if (ret)
+			return ret;
+
+		ras2_ctx->reenable_bg_scrub = true;
+		thrd = kthread_run(ras2_scrub_monitor_thread, ras2_ctx,
+				   "ras2_scrub_nid%d", ras2_ctx->sys_comp_nid);
+		if (IS_ERR(thrd)) {
+			ras2_ctx->reenable_bg_scrub = false;
+			ras2_hw_scrub_set_enabled_bg(dev, drv_data, true);
+			return PTR_ERR(thrd);
+		}
+	}
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	if (running)
+		return -EBUSY;
+
+	ps_sm->common.set_caps[0] = RAS2_SUPPORT_HW_PARTOL_SCRUB;
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
+			ras2_ctx->od_scrub = false;
+		}
+		return ret;
+	}
+
+	ras2_ctx->od_scrub = enable;
+
+	return ras2_update_patrol_scrub_params_cache(ras2_ctx);
+}
+
+static const struct edac_scrub_ops ras2_scrub_ops = {
+	.get_enabled_bg = ras2_hw_scrub_get_enabled_bg,
+	.set_enabled_bg = ras2_hw_scrub_set_enabled_bg,
+	.get_enabled_od = ras2_hw_scrub_get_enabled_od,
+	.set_enabled_od = ras2_hw_scrub_set_enabled_od,
+	.get_min_cycle = ras2_hw_scrub_read_min_scrub_cycle,
+	.get_max_cycle = ras2_hw_scrub_read_max_scrub_cycle,
+	.get_cycle_duration = ras2_hw_scrub_cycle_read,
+	.set_cycle_duration = ras2_hw_scrub_cycle_write,
+};
+
+static int ras2_probe(struct auxiliary_device *auxdev, const struct auxiliary_device_id *id)
+{
+	struct ras2_mem_ctx *ras2_ctx = container_of(auxdev, struct ras2_mem_ctx, adev);
+	struct edac_dev_feature ras_features;
+	char scrub_name[RAS2_SCRUB_NAME_LEN];
+	unsigned long start_pfn, size_pfn;
+	int ret;
+
+	if (!ras2_is_patrol_scrub_support(ras2_ctx))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Retrieve the PA range of the NUMA domain and use it as the
+	 * 'Requested Address Range', when send RAS2 command
+	 * GET_PATROL_PARAMETERS to get parameters that apply to all addresses
+	 * in the NUMA domain as well as when send command START_PATROL_SCRUBBER
+	 * to start the demand scrubbing.
+	 */
+	start_pfn = node_start_pfn(ras2_ctx->sys_comp_nid);
+	size_pfn = node_spanned_pages(ras2_ctx->sys_comp_nid);
+	if (!size_pfn) {
+		pr_debug("Failed to find PA range of NUMA node(%u)\n", ras2_ctx->sys_comp_nid);
+		return -EPERM;
+	}
+
+	ras2_ctx->base = __pfn_to_phys(start_pfn);
+	ras2_ctx->size = __pfn_to_phys(size_pfn);
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
+	return edac_dev_register(&auxdev->dev, scrub_name, NULL, 1, &ras_features);
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
index f4574e8e0a12..1329eb8b7423 100644
--- a/include/acpi/ras2.h
+++ b/include/acpi/ras2.h
@@ -37,6 +37,15 @@ struct device;
  *			is associated with. See ACPI spec 6.5 Table 5.80: RAS2
  *			Platform Communication Channel Descriptor format,
  *			Field: Instance
+ * @base:		Base address of the memory region to scrub
+ * @size:		Size of the memory region to scrub
+ * @scrub_cycle_hrs:	Current scrub rate in hours
+ * @min_scrub_cycle:	Minimum scrub rate supported
+ * @max_scrub_cycle:	Maximum scrub rate supported
+ * @od_scrub:		Status of demand scrubbing (memory region)
+ * @bg_scrub:		Status of background patrol scrubbing
+ * @reenable_bg_scrub:	Flag indicates restart background scrubbing after demand
+ *			scrubbing is finished
  */
 struct ras2_mem_ctx {
 	struct auxiliary_device		adev;
@@ -45,6 +54,14 @@ struct ras2_mem_ctx {
 	void				*sspcc;
 	struct mutex			*pcc_lock;
 	u32				sys_comp_nid;
+	u64				base;
+	u64				size;
+	u8				scrub_cycle_hrs;
+	u8				min_scrub_cycle;
+	u8				max_scrub_cycle;
+	bool				od_scrub;
+	bool				bg_scrub;
+	bool				reenable_bg_scrub;
 };
 
 #ifdef CONFIG_ACPI_RAS2
diff --git a/include/linux/edac.h b/include/linux/edac.h
index fa32f2aca22f..2342ff38e9d5 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -680,6 +680,8 @@ enum edac_dev_feat {
  * @write_size: set offset of the scrubbing range.
  * @get_enabled_bg: check if currently performing background scrub.
  * @set_enabled_bg: start or stop a bg-scrub.
+ * @get_enabled_od: check if currently performing demand scrub.
+ * @set_enabled_od: start or stop a demand-scrub.
  * @get_min_cycle: get minimum supported scrub cycle duration in seconds.
  * @get_max_cycle: get maximum supported scrub cycle duration in seconds.
  * @get_cycle_duration: get current scrub cycle duration in seconds.
@@ -692,6 +694,8 @@ struct edac_scrub_ops {
 	int (*write_size)(struct device *dev, void *drv_data, u64 size);
 	int (*get_enabled_bg)(struct device *dev, void *drv_data, bool *enable);
 	int (*set_enabled_bg)(struct device *dev, void *drv_data, bool enable);
+	int (*get_enabled_od)(struct device *dev, void *drv_data, bool *enable);
+	int (*set_enabled_od)(struct device *dev, void *drv_data, bool enable);
 	int (*get_min_cycle)(struct device *dev, void *drv_data,  u32 *min);
 	int (*get_max_cycle)(struct device *dev, void *drv_data,  u32 *max);
 	int (*get_cycle_duration)(struct device *dev, void *drv_data, u32 *cycle);
-- 
2.43.0


