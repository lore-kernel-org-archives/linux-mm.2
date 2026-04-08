Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E9410F9961
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85ADA6B0098; Wed,  8 Apr 2026 13:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3086B009B; Wed,  8 Apr 2026 13:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52F6F6B00A0; Wed,  8 Apr 2026 13:29:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 325C46B0098
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:29:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03709B700A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:29:47 +0000 (UTC)
X-FDA: 84636076056.10.A8AEE5F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id EC0F8160008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:29:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775669386; a=rsa-sha256;
	cv=none;
	b=MJXKrRspBG0CG/j1tJa13Cr17xdx1SzY7MpYHbCgUeGvV2GunrRf5UmwRAUQeKJPC8TA9R
	wBKyBk/LFp94WoLKOUjW4sVrf518ZSk2HmGDB+urXBBLdDJqCaADVm6G0DTrAKHNVC9D+f
	VzVFL28fnoSy56DWD6BTjDP23FJejmE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775669386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SMkneeXnhPl4BIu+/DZuqPAkwwSqMhw7idbxo/ascfo=;
	b=gV3rc22N2tGwW1JJ4f4gyZqB8wr6qsPX1fVYEaAfR1cQDt4Q/wa2HKUuPtvBv1uVNUTMLv
	YcdbWYQ8ESV9or37X1hlJ4qQ7ZMbhH+ByYUO5R5bCB+TnfE4BsY6jSGyHsamkO+Kixn084
	90i0EmAZgWGRMlUNZ07eF7l9jRZlk6s=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4frVRW5JDpzJ46cl;
	Thu,  9 Apr 2026 01:29:11 +0800 (CST)
Received: from dubpeml500008.china.huawei.com (unknown [7.214.146.94])
	by mail.maildlp.com (Postfix) with ESMTPS id A2D684056B;
	Thu,  9 Apr 2026 01:29:43 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.126.175.151) by
 dubpeml500008.china.huawei.com (7.214.146.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 8 Apr 2026 18:29:41 +0100
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
	<shiju.jose@huawei.com>, <shijujose2008@gmail.com>
Subject: [PATCH v19 2/2] ras: mem: Add ACPI RAS2 memory driver
Date: Wed, 8 Apr 2026 18:28:49 +0100
Message-ID: <20260408172850.183-3-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <20260408172850.183-1-shiju.jose@huawei.com>
References: <20260408172850.183-1-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.175.151]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml500008.china.huawei.com (7.214.146.94)
X-Stat-Signature: zqodmq3of1scwimkxmz4fr9bsdb835ys
X-Rspamd-Queue-Id: EC0F8160008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775669385-408476
X-HE-Meta: U2FsdGVkX195PKFSCVN5ju+mfrbf1Vo17RNbZhqzYlCtPeVz27fA8bDsLwFmlcBG0CZZE2C6jd8JWS77TTH8mccic9dN5hBVpqO8UqDIEOo2DzLHemf6Pfe/2VNuwCe9BKD9SmyMtQeb0WB7vdQQ/YFeNS9zEeRkuMGZc4jOGIldmsKwsCxbEu8QB4SccuYoR5y8XWLoA2CxjTwdWGKpMIIUOi/+5/FMKc6MiDtas2jl3/VpazCHQDPd1aXmx7MkDbtyj6IIbowydT5HuwGY8hWvPSic84ai5eSUyzNODY20WEw5wd5dBMmNKs/mSn+DN1D7yUkd/oVcU0upQMEy4GOCQ9G3rANPIF7V20+/YE8vD0IkIWfBlszlAWJCzyQzgkHsgR/Y2NdzBI/jb8e9WnNid5eJeOYnx7c46LA5NEDGrgaXPNJ8IE3ZHrT/LUqfI/+FDRx0M0+Nm4rvmVa0o7RHGPx9pBWHzQqPKzoHcdRgNaNdQ2Mzb+/bWxpngXdMaa/GEWUg07goTcgs51OJK/ybi+jdqfyeEmS27jxWCC7s+zy+1Ifnc1FL/tJRLmRZJB2Ra5V3E5FZzgvzBYIa6K3nvECpxwaimcqlcexSCimm++TpMOAHz4YH/uqr6yygm+CItfJtV1jY4vq5/OxG0bX7ynSJmT6rsqtWjGw80dsxGOZQ6SYps/c5zsun92pzDdCMxK04h+sK9/ndQ3wH4sKRR4zDG3OGlAoywumpQ68bgOwIWz7eHFbJXWD1/QMuQGDBbOKVzrYeWPcJ/dgFV8iGXZLiJ8Unjvl8VdtPzgYBY0rmXrxlFq1ypVkRZF3cZR4EAdePuMMYLOc50QSTCGpERgdsmidkgb0Z4HdnHTnBHOPWf6DNl5i6H1V46kO6t0lunvOrvkBvmUAJZzJbow7uOGxMXV3BDg8LXaSpie3lJA8R2OU+1BZIDVgGOUOVNJmoQ7q9i6Zr3KVylcy
 T5D3Ukvm
 lTBQDzf9kFtT4DvoVBMdIGb1Sm2LZmlW9V2xFz3tYo125yipCdLEArpZiZ/oXy48eGLOS5aBxiBqe1N1pg7Sx+aCK/aRjzv30mSC05uHeFi9uyCTzJJyXj+JoNVNCn8KBauTm5Yn0QxXdM6USzAXQr9mE+D4+HJ8Q2ZP7F4sGCiIOjLLUYvvPbV7ghtLohjAFnu0K5zojbaFOjOwZ/1B/rp9neOdZOjfLU3V5OV2laR9kFEGrhBae6pgjDn/0eEGjDgJ9HhFZZHsLMz94UuChrwgUGaVtF05vD8mApblvOGxc9U1fQgyMdU514psvdVecThmaEhIy+B3qZBKJgJ3Y3XyQUPe5wkhZRoxiAh0oPERdvVlEJjkVam8Fyw==
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

Given the address range provided to the userspace may be the lowest scrub
address range in the presence of disjoint address ranges, skipping address
ranges that are from other NUMA nodes but happen to lie within this range.

Driver retrieves the PA range of the NUMA domain and use it as the
'Requested Address Range', when send RAS2 command GET_PATROL_PARAMETERS
to get parameters that apply to all addresses in the NUMA domain.

Device with ACPI RAS2 scrub feature registers with EDAC device driver,
which retrieves the scrub descriptor from EDAC scrub and exposes
the scrub control attributes for RAS2 scrub instance to userspace in
/sys/bus/edac/devices/acpi_ras_memX/scrub0/.

Add 'enable_demand' attribute to the EDAC scrub interface to start/stop
the demand scrub, which is used in the RAS2 demand scrub control.
When a demand scrub is started, any background scrub currently in progress
will be stopped and then automatically restarted at the beginning when the
demand scrub has completed.

Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
---
 Documentation/ABI/testing/sysfs-edac-scrub |  13 +-
 Documentation/edac/scrub.rst               |  70 +++
 drivers/edac/scrub.c                       |  12 +
 drivers/ras/Kconfig                        |  13 +
 drivers/ras/Makefile                       |   1 +
 drivers/ras/acpi_ras2.c                    | 540 +++++++++++++++++++++
 include/acpi/ras2.h                        |  27 ++
 include/linux/edac.h                       |   4 +
 8 files changed, 675 insertions(+), 5 deletions(-)
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
index 2cfa74fa1ffd..562bfd6ff630 100644
--- a/Documentation/edac/scrub.rst
+++ b/Documentation/edac/scrub.rst
@@ -340,3 +340,73 @@ controller or platform when unexpectedly high error rates are detected.
 
 Sysfs files for scrubbing are documented in
 `Documentation/ABI/testing/sysfs-edac-ecs`
+
+3. ACPI RAS2 Hardware-based Memory Scrubbing
+
+3.1. Demand scrubbing for a specific memory region.
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
+3.1.5. Set address range.
+
+Set 'addr' of the memory region to scrub.
+
+# echo 0x80000000 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/addr
+
+Set 'size' of the memory region to scrub.
+
+# echo 0x200000 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/size
+
+3.1.6. Start 'demand scrubbing'.
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
index 000000000000..129503fdd0bb
--- /dev/null
+++ b/drivers/ras/acpi_ras2.c
@@ -0,0 +1,540 @@
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
+	u32 scrub_params_out;
+	int ret;
+
+	ps_sm->common.set_caps[0] = RAS2_SUPPORT_HW_PARTOL_SCRUB;
+	iowrite16(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
+	iowrite64(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
+	iowrite64(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(ras2_ctx->dev, "Failed to read patrol scrub parameters\n");
+		return ret;
+	}
+
+	scrub_params_out = ioread32(&ps_sm->params.scrub_params_out);
+	ras2_ctx->min_scrub_cycle = FIELD_GET(RAS2_PS_MIN_SC_HRS_OUT_MASK,
+					      scrub_params_out);
+	ras2_ctx->max_scrub_cycle = FIELD_GET(RAS2_PS_MAX_SC_HRS_OUT_MASK,
+					      scrub_params_out);
+	ras2_ctx->scrub_cycle_hrs = FIELD_GET(RAS2_PS_SC_HRS_OUT_MASK,
+					      scrub_params_out);
+	if (ras2_ctx->bg_scrub) {
+		ras2_ctx->od_scrub = false;
+		ras2_ctx->base = 0;
+		ras2_ctx->size = 0;
+		return 0;
+	}
+
+	if  (ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING) {
+		ras2_ctx->od_scrub = true;
+		ras2_ctx->base = ioread64(&ps_sm->params.actl_addr_range[0]);
+		ras2_ctx->size = ioread64(&ps_sm->params.actl_addr_range[1]);
+	} else {
+		ras2_ctx->od_scrub = false;
+	}
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
+	iowrite16(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
+	iowrite64(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
+	iowrite64(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
+
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(ras2_ctx->dev, "Failed to read patrol scrub parameters\n");
+		return ret;
+	}
+
+	*running = ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING;
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
+	ras2_ctx->thread = NULL;
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
+	ras2_ctx->set_scrub_cycle = scrub_cycle_hrs;
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
+	guard(mutex)(ras2_ctx->pcc_lock);
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
+	guard(mutex)(ras2_ctx->pcc_lock);
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
+	bool running;
+	int ret;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	if (running)
+		return -EBUSY;
+
+	ras2_ctx->base = base;
+
+	return 0;
+}
+
+static int ras2_hw_scrub_write_size(struct device *dev, void *drv_data, u64 size)
+{
+	struct ras2_mem_ctx *ras2_ctx = drv_data;
+	bool running;
+	int ret;
+
+	if (!size)
+		return -EINVAL;
+
+	guard(mutex)(ras2_ctx->pcc_lock);
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		return ret;
+
+	if (running)
+		return -EBUSY;
+
+	ras2_ctx->size = size;
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
+	u32 scrub_params_in;
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
+		iowrite64(0, &ps_sm->params.req_addr_range[0]);
+		iowrite64(0, &ps_sm->params.req_addr_range[1]);
+		scrub_params_in = ioread32(&ps_sm->params.scrub_params_in);
+		scrub_params_in &= ~RAS2_PS_SC_HRS_IN_MASK;
+		scrub_params_in |= FIELD_PREP(RAS2_PS_SC_HRS_IN_MASK, ras2_ctx->set_scrub_cycle);
+		iowrite32(scrub_params_in, &ps_sm->params.scrub_params_in);
+		iowrite16(RAS2_START_PATROL_SCRUBBER, &ps_sm->params.command);
+	} else {
+		if (!ras2_ctx->bg_scrub)
+			return -EPERM;
+
+		iowrite16(RAS2_STOP_PATROL_SCRUBBER, &ps_sm->params.command);
+	}
+
+	scrub_params_in = ioread32(&ps_sm->params.scrub_params_in);
+	scrub_params_in &= ~RAS2_PS_EN_BACKGROUND;
+	scrub_params_in |= FIELD_PREP(RAS2_PS_EN_BACKGROUND, enable);
+	iowrite32(scrub_params_in, &ps_sm->params.scrub_params_in);
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(dev, "Failed to %s background scrubbing\n",
+			str_enable_disable(enable));
+		return ret;
+	}
+
+	ras2_ctx->bg_scrub = enable;
+	if (enable) {
+		ras2_ctx->reenable_bg_scrub = false;
+		/* Update the cache to account for rounding of supplied parameters and similar */
+		return ras2_update_patrol_scrub_params_cache(ras2_ctx);
+	}
+
+	return 0;
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
+	u32 scrub_params_in;
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
+	}
+
+	mutex_lock(ras2_ctx->pcc_lock);
+	ret = ras2_get_demand_scrub_running(ras2_ctx, &running);
+	if (ret)
+		goto enable_bg_scrub;
+
+	if (running) {
+		ret = -EBUSY;
+		goto enable_bg_scrub;
+	}
+
+	/* May add more validity checks for the address range in the future if necessary */
+	if (!ras2_ctx->size || ras2_ctx->base < ras2_ctx->mem_base) {
+		dev_err(dev, "%s: Invalid address range, base=0x%llx size=0x%llx\n",
+			__func__, ras2_ctx->base, ras2_ctx->size);
+		ret = -ERANGE;
+		goto enable_bg_scrub;
+	}
+
+	ps_sm->common.set_caps[0] = RAS2_SUPPORT_HW_PARTOL_SCRUB;
+	scrub_params_in = ioread32(&ps_sm->params.scrub_params_in);
+	scrub_params_in &= ~RAS2_PS_SC_HRS_IN_MASK;
+	scrub_params_in |= FIELD_PREP(RAS2_PS_SC_HRS_IN_MASK, ras2_ctx->set_scrub_cycle);
+	scrub_params_in &= ~RAS2_PS_EN_BACKGROUND;
+	iowrite32(scrub_params_in, &ps_sm->params.scrub_params_in);
+	iowrite64(ras2_ctx->base, &ps_sm->params.req_addr_range[0]);
+	iowrite64(ras2_ctx->size, &ps_sm->params.req_addr_range[1]);
+	iowrite16(RAS2_START_PATROL_SCRUBBER, &ps_sm->params.command);
+
+	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
+	if (ret) {
+		dev_err(dev, "Failed to start demand scrubbing rc(%d)\n", ret);
+		if (ret != -EBUSY) {
+			iowrite64(0, &ps_sm->params.req_addr_range[0]);
+			iowrite64(0, &ps_sm->params.req_addr_range[1]);
+			ras2_ctx->od_scrub = false;
+			ras2_ctx->base = 0;
+			ras2_ctx->size = 0;
+		}
+		goto enable_bg_scrub;
+	}
+
+	ras2_ctx->od_scrub = enable;
+
+	ret = ras2_update_patrol_scrub_params_cache(ras2_ctx);
+
+	if (ras2_ctx->reenable_bg_scrub && !ras2_ctx->thread) {
+		ras2_ctx->thread = kthread_run(ras2_scrub_monitor_thread, ras2_ctx,
+					       "ras2_scrub_nid%d", ras2_ctx->sys_comp_nid);
+		if (IS_ERR(ras2_ctx->thread)) {
+			ret = PTR_ERR(ras2_ctx->thread);
+			ras2_ctx->thread = NULL;
+			goto enable_bg_scrub;
+		}
+	}
+	mutex_unlock(ras2_ctx->pcc_lock);
+
+	return ret;
+
+enable_bg_scrub:
+	mutex_unlock(ras2_ctx->pcc_lock);
+	if (ras2_ctx->reenable_bg_scrub) {
+		ras2_ctx->reenable_bg_scrub = false;
+		ras2_hw_scrub_set_enabled_bg(dev, drv_data, true);
+	}
+
+	return ret;
+}
+
+static const struct edac_scrub_ops ras2_scrub_ops = {
+	.read_addr = ras2_hw_scrub_read_addr,
+	.read_size = ras2_hw_scrub_read_size,
+	.write_addr = ras2_hw_scrub_write_addr,
+	.write_size = ras2_hw_scrub_write_size,
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
+static void ras2_mem_drv_remove(struct auxiliary_device *auxdev)
+{
+	struct ras2_mem_ctx *ras2_ctx = container_of(auxdev, struct ras2_mem_ctx, adev);
+
+	if (ras2_ctx && ras2_ctx->thread) {
+		kthread_stop(ras2_ctx->thread);
+		ras2_ctx->thread = NULL;
+	}
+}
+
+static int ras2_mem_drv_probe(struct auxiliary_device *auxdev, const struct auxiliary_device_id *id)
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
+	ras2_ctx->mem_base = __pfn_to_phys(start_pfn);
+	ras2_ctx->mem_size = __pfn_to_phys(size_pfn);
+	guard(mutex)(ras2_ctx->pcc_lock);
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
+	.probe = ras2_mem_drv_probe,
+	.remove = ras2_mem_drv_remove,
+	.id_table = ras2_mem_dev_id_table,
+};
+module_auxiliary_driver(ras2_mem_driver);
+
+MODULE_IMPORT_NS("ACPI_RAS2");
+MODULE_DESCRIPTION("ACPI RAS2 memory driver");
+MODULE_LICENSE("GPL");
diff --git a/include/acpi/ras2.h b/include/acpi/ras2.h
index f4574e8e0a12..6b4323b03747 100644
--- a/include/acpi/ras2.h
+++ b/include/acpi/ras2.h
@@ -37,6 +37,21 @@ struct device;
  *			is associated with. See ACPI spec 6.5 Table 5.80: RAS2
  *			Platform Communication Channel Descriptor format,
  *			Field: Instance
+ * @mem_base:		Base of the lowest physical continuous memory range
+ *			of the memory associated with the NUMA domain
+ * @mem_size		Size of the lowest physical continuous memory range
+ *			of the memory associated with the NUMA domain
+ * @base:		Base address of the memory region to scrub
+ * @size:		Size of the memory region to scrub
+ * @scrub_cycle_hrs:	Current scrub rate in hours
+ * @set_scrub_cycle:	Scrub rate to set in hours
+ * @min_scrub_cycle:	Minimum scrub rate supported
+ * @max_scrub_cycle:	Maximum scrub rate supported
+ * @od_scrub:		Status of demand scrubbing (memory region)
+ * @bg_scrub:		Status of background patrol scrubbing
+ * @reenable_bg_scrub:	Flag indicates restart background scrubbing after demand
+ *			scrubbing is finished
+ * @thread:		Demand scrub monitor kthread
  */
 struct ras2_mem_ctx {
 	struct auxiliary_device		adev;
@@ -45,6 +60,18 @@ struct ras2_mem_ctx {
 	void				*sspcc;
 	struct mutex			*pcc_lock;
 	u32				sys_comp_nid;
+	u64				mem_base;
+	u64				mem_size;
+	u64				base;
+	u64				size;
+	u8				scrub_cycle_hrs;
+	u8				set_scrub_cycle;
+	u8				min_scrub_cycle;
+	u8				max_scrub_cycle;
+	bool				od_scrub;
+	bool				bg_scrub;
+	bool				reenable_bg_scrub;
+	struct task_struct		*thread;
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


