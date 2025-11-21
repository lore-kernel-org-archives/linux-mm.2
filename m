Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96481CFC296
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11426B0088; Fri, 21 Nov 2025 13:28:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0E46B0032; Fri, 21 Nov 2025 13:28:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989056B008A; Fri, 21 Nov 2025 13:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0F76B0032
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:28:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3934BBAB23
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:28:43 +0000 (UTC)
X-FDA: 84135450126.27.19083ED
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id 062C4140004
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:28:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763749721; a=rsa-sha256;
	cv=none;
	b=woSZir9AYi+RXVDc3wQClvU9mLAoExzBp1C7vPfZWtBSBAYaWrAddUmJAUxZIvCQQlyOWG
	aYQMgj0RAaD42RdJRei2eXQ9h4WTs4KF2sU9TG8mk8+iDaeJE/A9DIn3x8ojBc/zXqK6nP
	8r1A9T8woQgFAf19VyjfALw7pvSWEuQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763749721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40Acc0zxMz4ONy8OIqQ24KS45efb7brbH13T2gX1bcY=;
	b=zzPSseN4NzHe9/E3F9vXgqvqd3n10JfwomGYZwclMjuVtHrZRgFKovnrH4g1935RWY1z8S
	ooY/GjeJc2HY65NlUV4hKEWmZK2I1nGFAYxvEE526pnxpmmcyQZZ3YXkSijtabwMKMjW08
	TwClYZBeQZqfwsK9dk9d83rp+3CM8ak=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dCkGv49LbzJ46BB;
	Sat, 22 Nov 2025 02:27:51 +0800 (CST)
Received: from dubpeml100008.china.huawei.com (unknown [7.214.145.227])
	by mail.maildlp.com (Postfix) with ESMTPS id 16D261402EF;
	Sat, 22 Nov 2025 02:28:39 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.195.246.188) by
 dubpeml100008.china.huawei.com (7.214.145.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 21 Nov 2025 18:28:37 +0000
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
Subject: [PATCH v13 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
Date: Fri, 21 Nov 2025 18:28:20 +0000
Message-ID: <20251121182825.237-2-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <20251121182825.237-1-shiju.jose@huawei.com>
References: <20251121182825.237-1-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.195.246.188]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100008.china.huawei.com (7.214.145.227)
X-Rspamd-Queue-Id: 062C4140004
X-Rspamd-Server: rspam07
X-Stat-Signature: qdzhbffrnqs8mopncum5erai3rbthoos
X-Rspam-User: 
X-HE-Tag: 1763749720-472179
X-HE-Meta: U2FsdGVkX19vMc0uJt4pSvj73Atwr/SQmvEsQMEe4EitnVokme0uEwVZW+3AInPK7b8hq2G5D6NPofhL/qRLLiTaodChN1+Wc2eAcwcD03/nJSrRFUIa4o9ptSocHGUUUr32r2Ovcjb1lnNV6pk/En+ZmUMvEeTOO/QjeJOVdp2ghx+U2mpR5ji25lVRoKOXgmKerSAJKERzvvurYz6oKi+c2mAQ9/5+gSzSN3EFO5Mi21+vn1MrmKuZOOKZy2svJdj5iSwqImXmKvnIXf6VZ9jZ/4nJfS7VBIppogt6RAaWfDdfCeP1Gm81tEJvL/DYLPZ0uLzbf/1B3wTAeqo7YQzlPKHDQDzhyed/DePeFkZKw6FCf5EBbBEDhqeeJO/5kWWiGWHFREsoJmTpnonvgVQ4qv892yIaIHODyQNdi2mst7FJ+hAoykrkcRCLUjuVdu8D3R3BCZ8AErYtpJawMv6fmn9v+MNaBfOGahlT7DLLXtCWFKWkRtYO9nPLFdsoQr0dfWiVHBMsN+LgF3d/2//Ma1lDtBdc+4oOwbUlTdfoNqSXOzQlAdabtFLm+vfavACgulkIlfu+Hb8E1mjaoUDeJcUfe10r190BXF0RsnqG7XZdJstDuknqNIS03kSUib300p4Z8NlJNGTZCTn6rWNbc3q5mw6f4EF3IX0o0fakCTXIUvM4dWhbhRBhMYWvZ4O6EuHv+O3crkqgdma9H2YunxvgaYU7ByffBUiSOXXbANkiuwQ+oNiy6YE4g6f0o52/qtiUZLLK++MV1LaJe3DBQUWLfPiAertvyy9JepBICYoFIB5ASu/rOorDfA3q1buuZ+ED7bmFJsvKB0sw5uEGfERjR/4mw1ayeXWSQ+eLlJ1rhz9DsGVyafK8Iyca9QzocXU9NO/xXXAmRCS2L2X8kWzycaRec0XVHYrTaTx6j9d680ZEQEJyXGhFrujyF/URw9zvgrMvoz1es7z
 YDndsFU2
 ywHuGMvDgMhqF1w3JMG7ZMhnHn4M6Q1AS4WZVEESmGkp5XjEhI4kVVbv0uPNeulzfKFkawLv7qGZ9NBnv498WBboDj12CBboZV+6QKbzyfpXxr9I744+91J6TXsRPXYLb6Fc9wF4weKCyCzPPkuB+noC0c0OgZA7Lmg7LiOCxRu8JJwSj7Ms98VZGwa5Qfdcy1k/6g00MDpVpzNgjfYRiMSbAUok1mFiAAF8VoDwoSY1n+mX92TJlLJTy82fghG0USHtaOsFJEz57tgZVwJKrtg9IcZxDUuUazzTMafX6yQ6BGTbRJUBdw+0dNNMZ/Qye1A5S38gYsF5DYS90/2WZxOTKeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shiju Jose <shiju.jose@huawei.com>

ACPI 6.5 Specification, section 5.2.21, defined RAS2 feature table (RAS2).
Driver adds support for RAS2 feature table, which provides interfaces for
platform RAS features, for eg. HW-based memory scrubbing, and logical to
PA translation service. RAS2 uses PCC channel subspace for communicating
with the ACPI compliant HW platform.

Co-developed-by: A Somasundaram <somasundaram.a@hpe.com>
Signed-off-by: A Somasundaram <somasundaram.a@hpe.com>
Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
---
 drivers/acpi/Kconfig  |  12 ++
 drivers/acpi/Makefile |   1 +
 drivers/acpi/bus.c    |   3 +
 drivers/acpi/ras2.c   | 398 ++++++++++++++++++++++++++++++++++++++++++
 include/acpi/ras2.h   |  57 ++++++
 5 files changed, 471 insertions(+)
 create mode 100644 drivers/acpi/ras2.c
 create mode 100644 include/acpi/ras2.h

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index ca00a5dbcf75..bfa9f3f4def5 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -293,6 +293,18 @@ config ACPI_CPPC_LIB
 	  If your platform does not support CPPC in firmware,
 	  leave this option disabled.
 
+config ACPI_RAS2
+	bool "ACPI RAS2 driver"
+	select AUXILIARY_BUS
+	select MAILBOX
+	select PCC
+	depends on NUMA_KEEP_MEMINFO
+	help
+	  This driver adds support for RAS2 feature table provides interfaces
+	  for platform RAS features, for eg. HW-based memory scrubbing.
+	  If your platform does not support RAS2 in firmware, leave this
+	  option disabled.
+
 config ACPI_PROCESSOR
 	tristate "Processor"
 	depends on X86 || ARM64 || LOONGARCH || RISCV
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index d1b0affb844f..abfec6745724 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -105,6 +105,7 @@ obj-$(CONFIG_ACPI_EC_DEBUGFS)	+= ec_sys.o
 obj-$(CONFIG_ACPI_BGRT)		+= bgrt.o
 obj-$(CONFIG_ACPI_CPPC_LIB)	+= cppc_acpi.o
 obj-$(CONFIG_ACPI_SPCR_TABLE)	+= spcr.o
+obj-$(CONFIG_ACPI_RAS2)		+= ras2.o
 obj-$(CONFIG_ACPI_DEBUGGER_USER) += acpi_dbg.o
 obj-$(CONFIG_ACPI_PPTT) 	+= pptt.o
 obj-$(CONFIG_ACPI_PFRUT)	+= pfr_update.o pfr_telemetry.o
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index a984ccd4a2a0..b02ceb2837c6 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -31,6 +31,7 @@
 #include <acpi/apei.h>
 #include <linux/suspend.h>
 #include <linux/prmt.h>
+#include <acpi/ras2.h>
 
 #include "internal.h"
 
@@ -1474,6 +1475,8 @@ static int __init acpi_init(void)
 	acpi_debugger_init();
 	acpi_setup_sb_notify_handler();
 	acpi_viot_init();
+	acpi_ras2_init();
+
 	return 0;
 }
 
diff --git a/drivers/acpi/ras2.c b/drivers/acpi/ras2.c
new file mode 100644
index 000000000000..9df94d8c953c
--- /dev/null
+++ b/drivers/acpi/ras2.c
@@ -0,0 +1,398 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * ACPI RAS2 feature table driver.
+ *
+ * Copyright (c) 2024-2025 HiSilicon Limited.
+ *
+ * Support for RAS2 table - ACPI 6.5 Specification, section 5.2.21, which
+ * provides interfaces for platform RAS features, for eg. HW-based memory
+ * scrubbing, and logical to PA translation service. RAS2 uses PCC channel
+ * subspace for communicating with the ACPI compliant HW platform.
+ */
+
+#define pr_fmt(fmt) "ACPI RAS2: " fmt
+
+#include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/iopoll.h>
+#include <linux/ktime.h>
+#include <acpi/pcc.h>
+#include <acpi/ras2.h>
+
+/**
+ * struct ras2_sspcc - Data structure for PCC communication
+ * @mbox_client:	struct mbox_client object
+ * @pcc_chan:		Pointer to struct pcc_mbox_chan
+ * @comm_addr:		Pointer to RAS2 PCC shared memory region
+ * @elem:		List for registered RAS2 PCC channel subspaces
+ * @pcc_lock:		PCC lock to provide mutually exclusive access
+ *			to PCC channel subspace
+ * @deadline_us:	Poll PCC status register timeout in micro secs
+ *			for PCC command complete
+ * @pcc_mpar:		Maximum Periodic Access Rate (MPAR) for PCC channel
+ * @pcc_mrtt:		Minimum Request Turnaround Time (MRTT) in micro secs
+ *			OS must wait after completion of a PCC command before
+ *			issue next command
+ * @last_cmd_cmpl_time:	completion time of last PCC command
+ * @last_mpar_reset:	Time of last MPAR count reset
+ * @mpar_count:		MPAR count
+ * @pcc_id:		Identifier of the RAS2 platform communication channel
+ * @last_cmd:		Last PCC command
+ * @pcc_chnl_acq:	Status of PCC channel acquired
+ */
+struct ras2_sspcc {
+	struct mbox_client		mbox_client;
+	struct pcc_mbox_chan		*pcc_chan;
+	struct acpi_ras2_shmem __iomem	*comm_addr;
+	struct list_head		elem;
+	struct mutex			pcc_lock;
+	unsigned int			deadline_us;
+	unsigned int			pcc_mpar;
+	unsigned int			pcc_mrtt;
+	ktime_t				last_cmd_cmpl_time;
+	ktime_t				last_mpar_reset;
+	int				mpar_count;
+	int				pcc_id;
+	u16				last_cmd;
+	bool				pcc_chnl_acq;
+};
+
+/*
+ * Arbitrary retries for PCC commands because the remote processor
+ * could be much slower to reply. Keeping it high enough to cover
+ * emulators where the processors run painfully slow.
+ */
+#define PCC_NUM_RETRIES 600ULL
+
+#define RAS2_FEAT_TYPE_MEMORY 0x00
+
+static int decode_cap_error(u32 cap_status)
+{
+	switch (cap_status) {
+	case ACPI_RAS2_NOT_VALID:
+	case ACPI_RAS2_NOT_SUPPORTED:
+		return -EPERM;
+	case ACPI_RAS2_BUSY:
+		return -EBUSY;
+	case ACPI_RAS2_FAILED:
+	case ACPI_RAS2_ABORTED:
+	case ACPI_RAS2_INVALID_DATA:
+		return -EINVAL;
+	default:
+		return 0;
+	}
+}
+
+static int check_pcc_chan(struct ras2_sspcc *sspcc)
+{
+	struct acpi_ras2_shmem __iomem *gen_comm_base = sspcc->comm_addr;
+	u32 cap_status;
+	u16 status;
+	int rc;
+
+	/*
+	 * As per ACPI spec, the PCC space will be initialized by
+	 * platform and should have set the command completion bit when
+	 * PCC can be used by OSPM.
+	 *
+	 * Poll PCC status register every 3us for maximum of 600ULL * PCC
+	 * channel latency until PCC command complete bit is set.
+	 */
+	rc = readw_relaxed_poll_timeout(&gen_comm_base->status, status,
+					status & PCC_STATUS_CMD_COMPLETE, 3,
+					sspcc->deadline_us);
+	if (rc) {
+		pr_warn("PCC check channel timeout for pcc_id=%d rc=%d\n",
+			sspcc->pcc_id, rc);
+		return rc;
+	}
+
+	if (status & PCC_STATUS_ERROR) {
+		pr_warn("Error in executing last command=%d for pcc_id=%d\n",
+			sspcc->last_cmd, sspcc->pcc_id);
+		status &= ~PCC_STATUS_ERROR;
+		writew_relaxed(status, &gen_comm_base->status);
+		return -EIO;
+	}
+
+	cap_status = readw_relaxed(&gen_comm_base->set_caps_status);
+	writew_relaxed(0x0, &gen_comm_base->set_caps_status);
+	return decode_cap_error(cap_status);
+}
+
+/**
+ * ras2_send_pcc_cmd() - Send RAS2 command via PCC channel
+ * @ras2_ctx:	pointer to the RAS2 context structure
+ * @cmd:	command to send
+ *
+ * Returns: 0 on success, an error otherwise
+ */
+int ras2_send_pcc_cmd(struct ras2_mem_ctx *ras2_ctx, u16 cmd)
+{
+	struct ras2_sspcc *sspcc = ras2_ctx->sspcc;
+	struct acpi_ras2_shmem __iomem *gen_comm_base = sspcc->comm_addr;
+	struct mbox_chan *pcc_channel;
+	unsigned int time_delta;
+	int rc;
+
+	rc = check_pcc_chan(sspcc);
+	if (rc < 0)
+		return rc;
+
+	pcc_channel = sspcc->pcc_chan->mchan;
+
+	/*
+	 * Handle the Minimum Request Turnaround Time (MRTT).
+	 * "The minimum amount of time that OSPM must wait after the completion
+	 * of a command before issuing the next command, in microseconds."
+	 */
+	if (sspcc->pcc_mrtt) {
+		time_delta = ktime_us_delta(ktime_get(),
+					    sspcc->last_cmd_cmpl_time);
+		if (sspcc->pcc_mrtt > time_delta)
+			udelay(sspcc->pcc_mrtt - time_delta);
+	}
+
+	/*
+	 * Handle the non-zero Maximum Periodic Access Rate (MPAR).
+	 * "The maximum number of periodic requests that the subspace channel can
+	 * support, reported in commands per minute. 0 indicates no limitation."
+	 *
+	 * This parameter should be ideally zero or large enough so that it can
+	 * handle maximum number of requests that all the cores in the system can
+	 * collectively generate. If it is not, follow the spec and just not
+	 * send the request to the platform after hitting the MPAR limit in
+	 * any 60s window.
+	 */
+	if (sspcc->pcc_mpar) {
+		if (sspcc->mpar_count == 0) {
+			time_delta = ktime_ms_delta(ktime_get(),
+						    sspcc->last_mpar_reset);
+			if (time_delta < 60 * MSEC_PER_SEC) {
+				dev_dbg(ras2_ctx->dev,
+					"PCC cmd(%u) not sent due to MPAR limit",
+					cmd);
+				return -EIO;
+			}
+			sspcc->last_mpar_reset = ktime_get();
+			sspcc->mpar_count = sspcc->pcc_mpar;
+		}
+		sspcc->mpar_count--;
+	}
+
+	/* Write to the shared comm region */
+	writew_relaxed(cmd, &gen_comm_base->command);
+
+	/* Flip CMD COMPLETE bit */
+	writew_relaxed(0, &gen_comm_base->status);
+
+	/* Ring doorbell */
+	rc = mbox_send_message(pcc_channel, &cmd);
+	if (rc < 0) {
+		dev_warn(ras2_ctx->dev,
+			 "Err sending PCC mbox message. cmd:%d, rc:%d\n",
+			 cmd, rc);
+		return rc;
+	}
+
+	sspcc->last_cmd = cmd;
+
+	/*
+	 * If Minimum Request Turnaround Time is non-zero, need
+	 * to record the completion time of both READ and WRITE
+	 * command for proper handling of MRTT, so need to check
+	 * for pcc_mrtt in addition to PCC_CMD_EXEC_RAS2.
+	 */
+	if (cmd == PCC_CMD_EXEC_RAS2 || sspcc->pcc_mrtt) {
+		rc = check_pcc_chan(sspcc);
+		if (sspcc->pcc_mrtt)
+			sspcc->last_cmd_cmpl_time = ktime_get();
+	}
+
+	if (pcc_channel->mbox->txdone_irq)
+		mbox_chan_txdone(pcc_channel, rc);
+	else
+		mbox_client_txdone(pcc_channel, rc);
+
+	return rc < 0 ? rc : 0;
+}
+EXPORT_SYMBOL_GPL(ras2_send_pcc_cmd);
+
+static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int pcc_id)
+{
+	struct ras2_sspcc *sspcc;
+	struct pcc_mbox_chan *pcc_chan;
+	struct mbox_client *mbox_cl;
+
+	if (pcc_id < 0)
+		return -EINVAL;
+
+	sspcc = kzalloc(sizeof(*sspcc), GFP_KERNEL);
+	if (!sspcc)
+		return -ENOMEM;
+
+	mbox_cl			= &sspcc->mbox_client;
+	mbox_cl->knows_txdone	= true;
+
+	pcc_chan = pcc_mbox_request_channel(mbox_cl, pcc_id);
+	if (IS_ERR(pcc_chan)) {
+		kfree(sspcc);
+		return PTR_ERR(pcc_chan);
+	}
+
+	sspcc->pcc_id		= pcc_id;
+	sspcc->pcc_chan		= pcc_chan;
+	sspcc->comm_addr	= pcc_chan->shmem;
+	sspcc->deadline_us	= PCC_NUM_RETRIES * pcc_chan->latency;
+	sspcc->pcc_mrtt		= pcc_chan->min_turnaround_time;
+	sspcc->pcc_mpar		= pcc_chan->max_access_rate;
+	sspcc->mbox_client.knows_txdone	= true;
+	sspcc->pcc_chnl_acq	= true;
+
+	ras2_ctx->sspcc		= sspcc;
+	ras2_ctx->comm_addr	= sspcc->comm_addr;
+	ras2_ctx->dev		= pcc_chan->mchan->mbox->dev;
+
+	mutex_init(&sspcc->pcc_lock);
+	ras2_ctx->pcc_lock	= &sspcc->pcc_lock;
+
+	return 0;
+}
+
+static DEFINE_IDA(ras2_ida);
+static void ras2_release(struct device *device)
+{
+	struct auxiliary_device *auxdev = to_auxiliary_dev(device);
+	struct ras2_sspcc *sspcc;
+	struct ras2_mem_ctx *ras2_ctx =
+		container_of(auxdev, struct ras2_mem_ctx, adev);
+
+	ida_free(&ras2_ida, auxdev->id);
+	sspcc = ras2_ctx->sspcc;
+	pcc_mbox_free_channel(sspcc->pcc_chan);
+	kfree(sspcc);
+	kfree(ras2_ctx);
+}
+
+static struct ras2_mem_ctx *
+add_aux_device(char *name, int channel, u32 pxm_inst)
+{
+	struct ras2_mem_ctx *ras2_ctx;
+	struct ras2_sspcc *sspcc;
+	int id, rc;
+
+	ras2_ctx = kzalloc(sizeof(*ras2_ctx), GFP_KERNEL);
+	if (!ras2_ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ras2_ctx->sys_comp_nid = pxm_to_node(pxm_inst);
+
+	rc = register_pcc_channel(ras2_ctx, channel);
+	if (rc < 0) {
+		pr_debug("Failed to register pcc channel rc=%d\n", rc);
+		goto ctx_free;
+	}
+
+	id = ida_alloc(&ras2_ida, GFP_KERNEL);
+	if (id < 0) {
+		rc = id;
+		goto pcc_free;
+	}
+
+	ras2_ctx->adev.id		= id;
+	ras2_ctx->adev.name		= RAS2_MEM_DEV_ID_NAME;
+	ras2_ctx->adev.dev.release	= ras2_release;
+	ras2_ctx->adev.dev.parent	= ras2_ctx->dev;
+
+	rc = auxiliary_device_init(&ras2_ctx->adev);
+	if (rc)
+		goto ida_free;
+
+	rc = auxiliary_device_add(&ras2_ctx->adev);
+	if (rc) {
+		auxiliary_device_uninit(&ras2_ctx->adev);
+		return ERR_PTR(rc);
+	}
+
+	return ras2_ctx;
+
+ida_free:
+	ida_free(&ras2_ida, id);
+pcc_free:
+	sspcc = ras2_ctx->sspcc;
+	pcc_mbox_free_channel(sspcc->pcc_chan);
+	kfree(sspcc);
+ctx_free:
+	kfree(ras2_ctx);
+
+	return ERR_PTR(rc);
+}
+
+static void acpi_ras2_parse(struct acpi_table_ras2 *ras2_tab)
+{
+	struct acpi_ras2_pcc_desc *pcc_desc_list;
+	struct ras2_mem_ctx *ras2_ctx;
+	u16 i, count;
+
+	if (ras2_tab->header.length < sizeof(*ras2_tab)) {
+		pr_warn(FW_WARN "ACPI RAS2 table present but broken (too short, size=%u)\n",
+			ras2_tab->header.length);
+		return;
+	}
+
+	if (!ras2_tab->num_pcc_descs) {
+		pr_warn(FW_WARN "No PCC descs in ACPI RAS2 table\n");
+		return;
+	}
+
+	struct ras2_mem_ctx **pctx_list __free(kfree) =
+		kzalloc(ras2_tab->num_pcc_descs * sizeof(*pctx_list),
+			GFP_KERNEL);
+	if (!pctx_list)
+		return;
+
+	count = 0;
+	pcc_desc_list = (struct acpi_ras2_pcc_desc *)(ras2_tab + 1);
+	for (i = 0; i < ras2_tab->num_pcc_descs; i++, pcc_desc_list++) {
+		if (pcc_desc_list->feature_type != RAS2_FEAT_TYPE_MEMORY)
+			continue;
+
+		ras2_ctx = add_aux_device(RAS2_MEM_DEV_ID_NAME,
+					  pcc_desc_list->channel_id,
+					  pcc_desc_list->instance);
+		if (IS_ERR(ras2_ctx)) {
+			pr_warn("Failed to add RAS2 auxiliary device rc=%ld\n",
+				PTR_ERR(ras2_ctx));
+			for (i = count; i > 0; i--)
+				auxiliary_device_uninit(&pctx_list[i - 1]->adev);
+			return;
+		}
+		pctx_list[count++] = ras2_ctx;
+	}
+}
+
+/**
+ * acpi_ras2_init - RAS2 driver initialization function.
+ *
+ * Extracts the ACPI RAS2 table and retrieves ID for the PCC channel subspace
+ * for communicating with the ACPI compliant HW platform. Driver adds an
+ * auxiliary device, which binds to the memory ACPI RAS2 driver, for each RAS2
+ * memory feature.
+ *
+ * Returns: none.
+ */
+void __init acpi_ras2_init(void)
+{
+	struct acpi_table_ras2 *ras2_tab;
+	acpi_status status;
+
+	status = acpi_get_table(ACPI_SIG_RAS2, 0,
+				(struct acpi_table_header **)&ras2_tab);
+	if (ACPI_FAILURE(status)) {
+		pr_err("Failed to get table, %s\n", acpi_format_exception(status));
+		return;
+	}
+
+	acpi_ras2_parse(ras2_tab);
+	acpi_put_table((struct acpi_table_header *)ras2_tab);
+}
diff --git a/include/acpi/ras2.h b/include/acpi/ras2.h
new file mode 100644
index 000000000000..10deab0b5541
--- /dev/null
+++ b/include/acpi/ras2.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * ACPI RAS2 (RAS Feature Table) methods.
+ *
+ * Copyright (c) 2024-2025 HiSilicon Limited
+ */
+
+#ifndef _ACPI_RAS2_H
+#define _ACPI_RAS2_H
+
+#include <linux/acpi.h>
+#include <linux/auxiliary_bus.h>
+#include <linux/mailbox_client.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+
+struct device;
+
+/*
+ * ACPI spec 6.5 Table 5.82: PCC command codes used by
+ * RAS2 platform communication channel.
+ */
+#define PCC_CMD_EXEC_RAS2 0x01
+
+#define RAS2_AUX_DEV_NAME "ras2"
+#define RAS2_MEM_DEV_ID_NAME "acpi_ras2_mem"
+
+/**
+ * struct ras2_mem_ctx - Context for RAS2 memory features
+ * @adev:		Auxiliary device object
+ * @comm_addr:		Pointer to RAS2 PCC shared memory region
+ * @dev:		Pointer to device backing struct mbox_controller for PCC
+ * @sspcc:		Pointer to local data structure for PCC communication
+ * @pcc_lock:		Pointer to PCC lock to provide mutually exclusive access
+ *			to PCC channel subspace
+ * @sys_comp_nid:	Node ID of the system component that the RAS feature
+ *			is associated with. See ACPI spec 6.5 Table 5.80: RAS2
+ *			Platform Communication Channel Descriptor format,
+ *			Field: Instance
+ */
+struct ras2_mem_ctx {
+	struct auxiliary_device		adev;
+	struct acpi_ras2_shmem __iomem	*comm_addr;
+	struct device			*dev;
+	void				*sspcc;
+	struct mutex			*pcc_lock;
+	u32				sys_comp_nid;
+};
+
+#ifdef CONFIG_ACPI_RAS2
+void __init acpi_ras2_init(void);
+int ras2_send_pcc_cmd(struct ras2_mem_ctx *ras2_ctx, u16 cmd);
+#else
+static inline void acpi_ras2_init(void) { }
+#endif
+
+#endif /* _ACPI_RAS2_H */
-- 
2.43.0


