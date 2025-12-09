Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E10BD3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 14:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDCCD6B0008; Tue,  9 Dec 2025 09:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8CE56B000C; Tue,  9 Dec 2025 09:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54F26B000A; Tue,  9 Dec 2025 09:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC7346B0007
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:58:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AFE9C013E
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:58:00 +0000 (UTC)
X-FDA: 84200237520.26.8157288
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6DA622000A
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:57:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765292278; a=rsa-sha256;
	cv=none;
	b=KypzvpyuOsIcbtwV7MvlXPMnGygsJ/RMTLfu++My/M7b/Z5e63qZDZJLAnPJ653BpkV/jG
	Hr2G4LhlzzfBIxxdgg2bC6wxLq3B/VHzWLRBdZLgYW/0wPAQSmAOGGD7//iZ0elwMMCcpf
	h3AGm+Z5C/eiaY0B/i6n0jea5IRBz38=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765292278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1j3gS0H5c2vnD8UdXXo9uEYbMqvGpgLDKHNVmUYjgNY=;
	b=O+ZwWT+upq1PY+1V738etKY2xjJ2T0MKHL1PQddK6UJkuvNOhzrXXebIQwQmQHvwF4M47j
	0xKOXqKlEk2VRMkhw7/65aWJrrzlcCaW0/6qD8wUySjjsDhZyF0Aw3eV88fPG5K/Sg/rLX
	0xdXt1AkHZBbZDkZVrNtY3f14VhNkr8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dQhm309RjzJ467v;
	Tue,  9 Dec 2025 22:57:39 +0800 (CST)
Received: from dubpeml100008.china.huawei.com (unknown [7.214.145.227])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A3204056B;
	Tue,  9 Dec 2025 22:57:55 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.126.172.138) by
 dubpeml100008.china.huawei.com (7.214.145.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 9 Dec 2025 14:57:53 +0000
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
Subject: [PATCH v14 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
Date: Tue, 9 Dec 2025 14:57:40 +0000
Message-ID: <20251209145742.297-2-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <20251209145742.297-1-shiju.jose@huawei.com>
References: <20251209145742.297-1-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.172.138]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100008.china.huawei.com (7.214.145.227)
X-Rspamd-Queue-Id: 6DA622000A
X-Stat-Signature: e8j8bbcrqc3t9fmwkf96d5mu84ic531u
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765292278-139688
X-HE-Meta: U2FsdGVkX18QtncxAk1GUEHinVy3Ttp+/Uh81u/+a37NonJjFtoIK4ihn0Ta8nRhVmKLDhqaIGVDwWC3P60HJVreSs2drDErFiLLOX7FtFAT0NKls/zwP0P4dkF4WPRkve1Ttt99cRhFcwdrmNZwCblzScwGKwMDH3i9r0jDjr0xkCqPTRFJSq9NDugpcLFPIOWPQzXh+TVypZKL/N1zuvVjhSkEDXf1VVK/cJRshMtsqN8ZS9IMUIqqAVAwj+l7uJIJkc8gbDJvazpKIhNF5cGTRcwX3ofcqyDi7VI66OaVX4R4UuGGTnbIhgmyHZoxjfi+FpTUde9lWufffd7R6vXahtf+YaKttifvj96obhxdipjmBCMfpj+Z9PYKwhFokeu7OPYP0iyZywaHodXt9deDc7BOrnPQtC4cR9Fg1nDxV6wDOn6CzrwVqhBa39glL/0eFFwTBg8CnHU7L0G0OXyiqP3hzH/qznqXYviYMyhEYNO6P7kyj/Qu1uGIyjhgEBtpVeKfIeeAdIinfn80GnY44ttX6WFS6tS8lgT4xk2S8ZYRIJiV1+UYw9GmYQUe4Eyjq3Z6e2OGiedNXtFKM91UCdeleAUCVEp6+oL7tVrtCAD+xCqTosXPNmD4SK16gnie3f62rlNJ7gNInArZgMyTHLqzg5CI3HahWMQDbJXlb3ULKXxOozxM61GAAXe7LXjaewuILkJa2nvn5wUaLWMeWGgTMVjpDp4UGGw1SoToC4dabiGlcU7r5IberV7hKMK5zX0W+78M8LoAnHfdri6nKGSNDA3FEdCom+zEj9zmpzEp8tO5su20xmBG+TDKATSER1gO/slcuiABxW4nU6MWUI8D6c6te1wyatYUbjWH2GdS5B83xt9kuoBdJ9aZJyv31bIDOyto/lqSbx6lL85mH+djXThbOy57ATJqsmwPjupQ8ly1OpJyPs8NwZ6X4UqKpH5C6urem2wlUiL
 uhmDMeyO
 NklnVGQP/zdS0h3PPoLBnxxekNijPiiNVfbtgGI8vsBz7m0ot/XAGaCiWmpgILlwr9zVP62Be5iG+Lv7E+JZhLBOkEeeIqlqDMHoFilypa63U5RMnUcSdcTiem7SYCG4S+OPSzlLmtAKTOzhh6qtKcHXcWJZEFqK3eea5S7Bp1fkofSelJXnDbrKPtL10IVmyTpHFiRg/Rn4HcE+NB/WRRBwvB8Vrz31BujMsxRO399f1NbEOcqbq9J9tEjLrC54PYFSsBtmnMElYhxHRCaJI4B9qUbJjjdW0ZgSAcHX0ik63FXzyYxfSdoEL+so2lanyU7cv3ryqtuIVLpnG6L+g3QCMjA==
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
platform RAS features, e.g., for HW-based memory scrubbing, and logical to
PA translation service. RAS2 uses PCC channel subspace for communicating
with the ACPI compliant HW platform.

Co-developed-by: A Somasundaram <somasundaram.a@hpe.com>
Signed-off-by: A Somasundaram <somasundaram.a@hpe.com>
Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
---
 drivers/acpi/Kconfig  |  10 ++
 drivers/acpi/Makefile |   1 +
 drivers/acpi/bus.c    |   3 +
 drivers/acpi/ras2.c   | 409 ++++++++++++++++++++++++++++++++++++++++++
 include/acpi/ras2.h   |  57 ++++++
 5 files changed, 480 insertions(+)
 create mode 100644 drivers/acpi/ras2.c
 create mode 100644 include/acpi/ras2.h

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index ca00a5dbcf75..2322b0470d07 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -293,6 +293,16 @@ config ACPI_CPPC_LIB
 	  If your platform does not support CPPC in firmware,
 	  leave this option disabled.
 
+config ACPI_RAS2
+	bool "ACPI RAS2 driver"
+	depends on AUXILIARY_BUS
+	depends on MAILBOX
+	depends on PCC
+	help
+	  This driver adds support for RAS2 feature table provides interfaces
+	  for platform RAS features, e.g., for HW-based memory scrubbing.
+	  Say 'y/n' to enable/disable ACPI RAS2 support.
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
index 000000000000..627895fee143
--- /dev/null
+++ b/drivers/acpi/ras2.c
@@ -0,0 +1,409 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * ACPI RAS2 feature table driver.
+ *
+ * Copyright (c) 2024-2025 HiSilicon Limited.
+ *
+ * Support for RAS2 table - ACPI 6.5 Specification, section 5.2.21, which
+ * provides interfaces for platform RAS features, e.g., for HW-based memory
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
+#define RAS2_MAX_NUM_PCC_DESCS 100
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
+		pr_warn("Error in executing last command:0x%x for pcc_id=%d\n",
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
+ * @cmd:	RAS2 command to send
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
+	if (!ras2_ctx)
+		return -EINVAL;
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
+		time_delta = ktime_us_delta(ktime_get(), sspcc->last_cmd_cmpl_time);
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
+		if (!sspcc->mpar_count) {
+			time_delta = ktime_ms_delta(ktime_get(), sspcc->last_mpar_reset);
+			if (time_delta < 60 * MSEC_PER_SEC) {
+				dev_dbg(ras2_ctx->dev,
+					"PCC cmd(0x%x) not sent due to MPAR limit", cmd);
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
+	/*
+	 * mbox_send_message() return non-negative integer for successful submission
+	 * and negative value on failure.
+	 */
+	rc = rc < 0 ? rc : 0;
+	if (rc < 0) {
+		dev_warn(ras2_ctx->dev,
+			 "Error in sending PCC mbox message cmd:%d, rc:%d\n", cmd, rc);
+		return rc;
+	}
+
+	sspcc->last_cmd = cmd;
+
+	/*
+	 * If Minimum Request Turnaround Time is non-zero, need to record the
+	 * completion time of both READ and WRITE command for proper handling
+	 * of MRTT, so need to check for pcc_mrtt in addition to PCC_CMD_EXEC_RAS2.
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
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ras2_send_pcc_cmd);
+
+static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int pcc_id)
+{
+	struct pcc_mbox_chan *pcc_chan;
+	struct mbox_client *mbox_cl;
+	struct ras2_sspcc *sspcc;
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
+	struct ras2_mem_ctx *ras2_ctx = container_of(auxdev, struct ras2_mem_ctx, adev);
+	struct ras2_sspcc *sspcc;
+
+	ida_free(&ras2_ida, auxdev->id);
+	sspcc = ras2_ctx->sspcc;
+	pcc_mbox_free_channel(sspcc->pcc_chan);
+	kfree(sspcc);
+	kfree(ras2_ctx);
+}
+
+static struct ras2_mem_ctx *add_aux_device(char *name, int channel, u32 pxm_inst)
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
+	if (ras2_ctx->sys_comp_nid == NUMA_NO_NODE) {
+		pr_debug("Invalid NUMA node, channel=%d pxm_inst=%d\n", channel, pxm_inst);
+		rc = -EINVAL;
+		goto ctx_free;
+	}
+
+	rc = register_pcc_channel(ras2_ctx, channel);
+	if (rc < 0) {
+		pr_debug("Failed to register PCC channel=%d pxm_inst=%d rc=%d\n",
+			 channel, pxm_inst, rc);
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
+static int parse_ras2_table(struct acpi_table_ras2 *ras2_tab)
+{
+	struct acpi_ras2_pcc_desc *pcc_desc_list;
+	struct ras2_mem_ctx **pctx_list;
+	struct ras2_mem_ctx *ras2_ctx;
+	u16 i;
+
+	if (ras2_tab->header.length < sizeof(*ras2_tab)) {
+		pr_warn(FW_WARN "ACPI RAS2 table present but broken (too short, size=%u)\n",
+			ras2_tab->header.length);
+		return -EINVAL;
+	}
+
+	if (!ras2_tab->num_pcc_descs || ras2_tab->num_pcc_descs > RAS2_MAX_NUM_PCC_DESCS) {
+		pr_warn(FW_WARN "No/Invalid number of PCC descs(%d) in ACPI RAS2 table\n",
+			ras2_tab->num_pcc_descs);
+		return -EINVAL;
+	}
+
+	pctx_list = kzalloc(ras2_tab->num_pcc_descs * sizeof(*pctx_list), GFP_KERNEL);
+	if (!pctx_list)
+		return -ENOMEM;
+
+	pcc_desc_list = (struct acpi_ras2_pcc_desc *)(ras2_tab + 1);
+	for (i = 0; i < ras2_tab->num_pcc_descs; i++, pcc_desc_list++) {
+		if (pcc_desc_list->feature_type != RAS2_FEAT_TYPE_MEMORY)
+			continue;
+
+		ras2_ctx = add_aux_device(RAS2_MEM_DEV_ID_NAME, pcc_desc_list->channel_id,
+					  pcc_desc_list->instance);
+		if (IS_ERR(ras2_ctx)) {
+			pr_warn("Failed to add RAS2 auxiliary device rc=%ld\n",
+				PTR_ERR(ras2_ctx));
+			for (; i > 0; i--) {
+				if (pctx_list[i - 1])
+					auxiliary_device_uninit(&pctx_list[i - 1]->adev);
+			}
+			kfree(pctx_list);
+			return PTR_ERR(ras2_ctx);
+		}
+		pctx_list[i] = ras2_ctx;
+	}
+	kfree(pctx_list);
+
+	return 0;
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
+	status = acpi_get_table(ACPI_SIG_RAS2, 0, (struct acpi_table_header **)&ras2_tab);
+	if (ACPI_FAILURE(status)) {
+		pr_debug("Failed to get table, %s\n", acpi_format_exception(status));
+		return;
+	}
+
+	if (parse_ras2_table(ras2_tab))
+		pr_debug("Failed to parse RAS2 table\n");
+
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


