Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13D4C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 21:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D916B008A; Thu,  9 Jul 2026 17:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35726B008C; Thu,  9 Jul 2026 17:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811876B0092; Thu,  9 Jul 2026 17:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52D416B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:08:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7E711C1E58
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:08:09 +0000 (UTC)
X-FDA: 84970475898.26.2A2D0F1
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id EF53C18000B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:08:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Eh1yPWmA;
	spf=pass (imf16.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783631288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tF+KVVD2d9bPRESI8PHf0Vxc58BusieFP6eXZGrjmXE=;
	b=weyahXg4tTpMOT2IVzVB7/zrRqbbMZpJ74RUVoIwxl609afsUqSsgRbe4ytBpji54NsbvF
	zgWKT6kRkiJB5ZRYt2UGpizqTm5hKbDVWHp78g3XDdYp+PvOUTbevAQlqAAnQa6+J7hkn5
	/GCna7kHKdPCiWaoPn2dxrZrMZ5+Tvg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Eh1yPWmA;
	spf=pass (imf16.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783631288;
	b=yjeuhO3t4ffIjxTvPRLkBaD06vXDhor/dMTnA8LnXuFj7LL9c2zlerUfdKLeeYEJbpqD8n
	i1Tbg6doltrj2Uln1AIeIQL4pclRPEvnb+fkFLsV/ieNOkmGPieWrVLrTKA+mOurETLoyt
	ylNy2wSdwhxSpnwf7S0eDDYIRI8Lptc=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493e8d4f4dcso2113635e9.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 14:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783631286; x=1784236086; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tF+KVVD2d9bPRESI8PHf0Vxc58BusieFP6eXZGrjmXE=;
        b=Eh1yPWmAdJktUCii8R/IPK6dUyLNGfBLpgSA5a9jgD3M4fk/fBL/hVg7cA5FY5AIyo
         RxxxfQrrxrH6H0tgBNboQFmoRrw6tK0cKyK7/0ye3Sdp1dqH0EJWYrtB4SncA+3MM9CB
         Zft3D3fMtg2ZoZ+CKYP4JZJAQlUJCw30H3CAj1ydFLoVOoxK5G+IwHQU3BOAmRJ/PU0y
         npLEQShsRTpytXWA16HTxhvd2+5mCBFNzKlzZJXJVpamr4Ff6P07MRyEZdeGE3Mnefab
         o6lj9+7qIT66/30a8KtK9JQ62D6Jfc9i1noNtB2GxvEbuNn7MalwWCtVXdZ3qp4Vavtd
         rgzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783631286; x=1784236086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tF+KVVD2d9bPRESI8PHf0Vxc58BusieFP6eXZGrjmXE=;
        b=dlRudOkXnUXa1KafPSJ6TmjN3bYFXs3rbpQE4BetwwDwuNx8x5IkevJgiHF4zYgcCc
         B+r95QBYnO2J1AXz8CirFZfUST6rJjBjmmXeodR+pVVGaKKBtO8e7yPFcm1JG8nLpQiw
         pC56tpkmKDyB5/EIz6bjVUcmGTJNdPWb7XcP23CE5QR5qVI/MZfoUDhkulNODEChN30U
         u5yObj9k4XeaYrMYFRfF7OFFRtdcvJkzj8T2yM5ALsrujwlXiB7JMd049+u6AFR23k0T
         L62PAcI63rkIkuYZ1HJTvEJGPmGniZPxaiCrO/XiH+u11aOOFIgtW0fhqL5OpAYXq1kn
         bwVg==
X-Forwarded-Encrypted: i=1; AHgh+Rr3BkpI0ZfKqVaka0zrNJi5Cari/s6wByOQbCL/FW+oZDZtSrJujofrE+yEaOPVeTkZCp+hLUNA7Q==@kvack.org
X-Gm-Message-State: AOJu0YzzmwMWkvE2CofOOsep0tpnxl5BOX583njSlaNDf8prLlGPeccc
	GTK9g+Ek7awozAPTIOinu9iCJxIETnxXI/NMH912d2dbysjIWgDD0pR8
X-Gm-Gg: AfdE7cn6PJ0d6x9GEJxC0XnNCi9HouyNRXUjNa9Z80v5JJrpAzXuGU0p17l1UeY+2nj
	VP11tBf+ND8Ln0glk7TafbCkdfQ172+MlymS8Oupi9NVkkR+HRCggJVJBhcKiMnKC1dEdzUk+ks
	s3+L71IrS29KaMY87kHgzCKbS/Ig/s4TCqRV55wc10yHUQb2HKA9pzI5PImZ4EhwGAymiK/GB8V
	jogf9qoAezhgwoTFJVqN+vHf2g/GoDM0wPKkXiVeuh3vYYeO5iGj6ww8jYsFnW2AckrxyKHdiUp
	FPowk7Msg4idgKD1/ktTbnOOCgqtzfxzD/mjUi9pBRHNb1sxHxR8AFDoUHFwrq73na64bjmlPFR
	4OI4HE3Z/TBnIWHsJafES6r6d4+TjmME8WE1hg7O6aXdtlI0u7tg45dhAdQyPjl82le+oxf4WYq
	KbTD8aSPUtS2w1LqJKXJfPu8k3ubi3ZRZlIS4E8lFkeCVYvTcSsEbwJXQyui6qMC8iaxiY5H2v3
	hehYUUE6vvi0NxAco44/g==
X-Received: by 2002:a05:600c:e548:10b0:493:bb45:d54d with SMTP id 5b1f17b1804b1-493e68a48d7mr61697975e9.37.1783631286107;
        Thu, 09 Jul 2026 14:08:06 -0700 (PDT)
Received: from localhost.localdomain (stev-08-b2-v4wan-169520-cust2225.vm32.cable.virginm.net. [81.98.232.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d8410sm55607342f8f.15.2026.07.09.14.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 14:08:05 -0700 (PDT)
From: shijujose2008@gmail.com
To: rafael@kernel.org,
	bp@alien8.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	dferguson@amperecomputing.com,
	linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	tony.luck@intel.com,
	lenb@kernel.org,
	Yazen.Ghannam@amd.com,
	mchehab@kernel.org,
	ashok.raj@oss.qualcomm.com
Cc: jic23@kernel.org,
	linuxarm@huawei.com,
	rientjes@google.com,
	jiaqiyan@google.com,
	Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com,
	naoya.horiguchi@nec.com,
	james.morse@arm.com,
	jthoughton@google.com,
	somasundaram.a@hpe.com,
	erdemaktas@google.com,
	pgonda@google.com,
	duenwen@google.com,
	gthelen@google.com,
	wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com,
	nifan.cxl@gmail.com,
	tanxiaofei@huawei.com,
	prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com,
	kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com,
	shijujose2008@gmail.com
Subject: [PATCH v22 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
Date: Thu,  9 Jul 2026 22:07:49 +0100
Message-Id: <20260709210750.424659-2-shijujose2008@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260709210750.424659-1-shijujose2008@gmail.com>
References: <20260709210750.424659-1-shijujose2008@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EF53C18000B
X-Stat-Signature: n7r4mr74x1sxhmcwnt5oup9kggujmmur
X-HE-Tag: 1783631287-276733
X-HE-Meta: U2FsdGVkX1/v+gZXHzr1zILP5kiD+BJXci/X4TvT+oxvFOrfmeia+vzYOzvLpCGBmpxVvAmVWrK/2kPVwyd3JLhnE5KoGoCd+9e47hSZgHBouuHdjhbo4Haxbefka7X6WLcwu2YaZPUrtgXai04M9c9Sdf5twktMIuG77R3WS/w73c6c4t4vXTdrAamBfhPY9xLENGs/lum0NCR3zsmi5Gz4ej2HKPebxqIE3X8bXcKQ00hpdEuvcCvWxuqQye9OQ8Mx7v9xOdAq2GMIk/1t3JgSaqPef5qhdnZcgN30IsocG4kuzRGrDrUGHOxM6AnK65s1HtqpVAmvIfImxsKihYp2vHrEA9WTmbdxziyCndGITfaXNb1xGt2IPhIZAfCcfSua5ZDb5coOcxQUNZIKVWKKGeGa0LtF9leg02W3RuyubqGm/2RhV/L4aoJMCeljWkuIJBE7QpLLms9eCbPO8ebzWwECxA7u/NZzD4MIVtte2KqBxvcDiAAUxX2km/vV86VtpgWmGpqxSlWQwDQlHWy3GDi5WYjJsLAcFbwMO8xBEPtNu1UFBDAjnfWwQ+W9MPO+4imDnKrDZmMYNaVPRl7szP+lZCEvrRqXFvLdAJYwwiLJ3ZpJ5mQyjwYg2xjROcI6OpW0rTx4gwOP3JJI8I4Rt9jK5xv8sYJxXiW49iDMlwwEeP0FOtND1hEhMtBkRUmVjVNOTTE/K5kNdoAaRn393zghuYFkOQ3e13bCsB1+IqyMmQMog1djfaQq70czfoEk7rVPyLC08sLEAoYDFs8sHBIiS+2T+hRYUCyaOpyBxYCA38Y4rC1eye4X5e5PHt+pEVlkRMk8/Sf8pOIZFXo+9CFgXS1K80gWJAhLu8iQ0bEtZBWs3rurCQUQzDJQuqmB9yEbBWlWQYbx5f+fgxZ01W1CrAUxnXLAwr9gGTdafBsKuEDZCSR6mHt3Yh8YJIkso7mO4T7amwuTrjH
 alAaCqxI
 Wm4kNM7MMjXcqywO/hDMNTGVaDFdt5csUfFwaknIlcgrmtAUNy2Y7fOZ+9hKCg8Uhn5wdseK9xSG6EdPPjaIVZfjqSKkfgNWX0H7CMJYBhJ4nFkXB4B2zVZDt/FFgJyC/xrh6ba70MwjbnAJFeU5H/ZAG6v3LHLCof0LErAeB3naszEkAhF2F/BqHSsT7SSj5OsReGjXJt2otCKzCGtkUO0mxM5knsA5ncbfMv+iBGjrTxHLFUykw3wpLts3IniSdK1G8YbMmjiuUU36RhQe2+gy5murevfdiT6vijrirY6axo+uvuRqV8qPltHdgg/r6fADS+oLOgk0lZcSTBYnjSquAAvtO5x1uLkwYpqz/D0vDKZb98oBee7mDfJnr1I0E9PtOM8obInOEmAD7SWG/7NIIhT7bqFZ7N8MpNzHiTDFsWB1/gABj3oslL0M34mQlndkJRz8lCy4cWvxu29N4seDM3RnuAzZycCHfzmPjVowplEhSzDffYCYF5mLGAH/ZqDO8PNO/oh5gbqEOzEcP8mzvizaKJdjCnNplN1woYQMxB3VSHDIraA0UjxJcEAcb/mNz7tnsDV6pIHy/Z/SzcSfHx+sIqdTDxSjwf3LW+Duggo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shiju Jose <shijujose2008@gmail.com>

ACPI 6.5 Specification, section 5.2.21, defined RAS2 feature table (RAS2).
Driver adds support for RAS2 feature table, which provides interfaces for
platform RAS features, e.g., for HW-based memory scrubbing, and logical to
PA translation service. RAS2 uses PCC channel subspace for communicating
with the ACPI compliant HW platform.

Co-developed-by: A Somasundaram <somasundaram.a@hpe.com>
Signed-off-by: A Somasundaram <somasundaram.a@hpe.com>
Co-developed-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
Reviewed-by: Ashok Raj <ashok.raj@oss.qualcomm.com>
Signed-off-by: Shiju Jose <shijujose2008@gmail.com>
---
 drivers/acpi/Kconfig  |  11 +
 drivers/acpi/Makefile |   1 +
 drivers/acpi/bus.c    |   3 +
 drivers/acpi/ras2.c   | 502 ++++++++++++++++++++++++++++++++++++++++++
 include/acpi/ras2.h   |  57 +++++
 5 files changed, 574 insertions(+)
 create mode 100644 drivers/acpi/ras2.c
 create mode 100644 include/acpi/ras2.h

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index f165d14cf61a..539ff143ccc5 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -294,6 +294,17 @@ config ACPI_CPPC_LIB
 	  If your platform does not support CPPC in firmware,
 	  leave this option disabled.
 
+config ACPI_RAS2
+	bool "ACPI RAS2 driver"
+	select AUXILIARY_BUS
+	depends on MAILBOX
+	depends on PCC
+	help
+	  Add support for the RAS2 feature table and provide interfaces for
+	  platform RAS features, such as hardware-based memory scrubbing.
+
+	  If unsure, select N.
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
index a30a904f6535..8d6a0b773bc5 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -31,6 +31,7 @@
 #include <acpi/apei.h>
 #include <linux/suspend.h>
 #include <linux/prmt.h>
+#include <acpi/ras2.h>
 
 #include "internal.h"
 
@@ -1610,6 +1611,8 @@ static int __init acpi_init(void)
 	acpi_debugger_init();
 	acpi_setup_sb_notify_handler();
 	acpi_viot_init();
+	acpi_ras2_init();
+
 	return 0;
 }
 
diff --git a/drivers/acpi/ras2.c b/drivers/acpi/ras2.c
new file mode 100644
index 000000000000..b66700e0e7d3
--- /dev/null
+++ b/drivers/acpi/ras2.c
@@ -0,0 +1,502 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * ACPI RAS2 feature table driver.
+ *
+ * Copyright (c) 2024-2026 HiSilicon Limited.
+ *
+ * Support for RAS2 table - ACPI 6.5 Specification, section 5.2.21, which
+ * provides interfaces for platform RAS features, e.g., for HW-based memory
+ * scrubbing, and logical to physical address translation service. RAS2 uses
+ * PCC channel subspace for communicating with the ACPI compliant HW platform.
+ */
+
+#undef pr_fmt
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
+ * @deadline_us:	Poll PCC status register timeout in microsecs
+ *			for PCC command completion
+ * @pcc_mpar:		Maximum Periodic Access Rate (MPAR) for PCC channel
+ * @pcc_mrtt:		Minimum Request Turnaround Time (MRTT) in microsecs
+ *			OS must wait after completion of a PCC command before
+ *			issuing next command
+ * @last_cmd_cmpl_time: Completion time of last PCC command
+ * @last_mpar_reset:	Time of last MPAR count reset
+ * @mpar_count:		MPAR count
+ * @pcc_id:		Identifier of the RAS2 platform communication channel
+ * @last_cmd:		Last PCC command
+ * @kref:		kref object
+ */
+struct ras2_sspcc {
+	struct mbox_client		mbox_client;
+	struct pcc_mbox_chan		*pcc_chan;
+	struct acpi_ras2_shmem __iomem	*comm_addr;
+	struct list_head		elem;
+	struct mutex			pcc_lock;
+	u64				deadline_us;
+	unsigned int			pcc_mpar;
+	unsigned int			pcc_mrtt;
+	ktime_t				last_cmd_cmpl_time;
+	ktime_t				last_mpar_reset;
+	int				mpar_count;
+	int				pcc_id;
+	u16				last_cmd;
+	struct kref			kref;
+};
+
+/*
+ * Arbitrary retries for PCC commands because the remote processor could be
+ * much slower to reply. Keep it high enough to cover emulators where the
+ * processors run painfully slow.
+ */
+#define PCC_NUM_RETRIES 600ULL
+#define PCC_CHNL_DEFAULT_LATENCY 1000
+#define PCC_MIN_POLL_USECS 3
+
+#define RAS2_MAX_NUM_PCC_DESCS 100
+#define RAS2_FEAT_TYPE_MEMORY 0x00
+
+/* Static variables for the RAS2 PCC subspaces */
+static DEFINE_MUTEX(ras2_pcc_list_lock);
+static LIST_HEAD(ras2_sspcc);
+
+static int check_pcc_chan(struct ras2_sspcc *sspcc)
+{
+	struct acpi_ras2_shmem __iomem *gen_comm_base = sspcc->comm_addr;
+	u32 cap_status;
+	u16 status;
+	int rc;
+
+	/*
+	 * As per ACPI spec, the PCC space will be initialized by the
+	 * platform and should have set the command completion bit when
+	 * PCC can be used by OSPM.
+	 *
+	 * Poll PCC status register every PCC_MIN_POLL_USECS for maximum of
+	 * PCC_NUM_RETRIES * PCC channel latency until PCC command complete
+	 * bit is set.
+	 */
+	rc = readw_relaxed_poll_timeout(&gen_comm_base->status, status,
+					status & PCC_STATUS_CMD_COMPLETE,
+					PCC_MIN_POLL_USECS, sspcc->deadline_us);
+	if (rc) {
+		pr_warn("PCC ID: 0x%x: PCC check channel timeout for last command: 0x%x rc=%d\n",
+			sspcc->pcc_id, sspcc->last_cmd, rc);
+
+		return rc;
+	}
+
+	if (status & PCC_STATUS_ERROR) {
+		pr_warn("PCC ID: 0x%x: Error in executing last command: 0x%x\n",
+			sspcc->pcc_id, sspcc->last_cmd);
+		status &= ~PCC_STATUS_ERROR;
+		iowrite16(status, &gen_comm_base->status);
+		iowrite32(0x0, &gen_comm_base->set_caps_status);
+		return -EIO;
+	}
+
+	/* Ensure get updated PCC status */
+	rmb();
+	cap_status = ioread32(&gen_comm_base->set_caps_status);
+	switch (cap_status) {
+	case ACPI_RAS2_NOT_VALID:
+	case ACPI_RAS2_NOT_SUPPORTED:
+		rc = -EPERM;
+		break;
+	case ACPI_RAS2_BUSY:
+		rc = -EBUSY;
+		break;
+	case ACPI_RAS2_FAILED:
+	case ACPI_RAS2_ABORTED:
+	case ACPI_RAS2_INVALID_DATA:
+		rc = -EINVAL;
+		break;
+	default:
+		rc = 0;
+	}
+
+	iowrite32(0x0, &gen_comm_base->set_caps_status);
+
+	return rc;
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
+	struct acpi_ras2_shmem __iomem *gen_comm_base;
+	struct mbox_chan *pcc_channel;
+	struct ras2_sspcc *sspcc;
+	s64 time_delta;
+	u16 val;
+	int rc;
+
+	if (!ras2_ctx)
+		return -EINVAL;
+
+	lockdep_assert_held(ras2_ctx->pcc_lock);
+	sspcc = ras2_ctx->sspcc;
+	gen_comm_base = sspcc->comm_addr;
+
+	rc = check_pcc_chan(sspcc);
+	if (rc < 0)
+		return rc;
+
+	pcc_channel = sspcc->pcc_chan->mchan;
+
+	/*
+	 * Handle the Minimum Request Turnaround Time (MRTT): the minimum
+	 * amount of time that OSPM must wait after the completion of
+	 * a command before issuing the next command, in microseconds.
+	 */
+	if (sspcc->pcc_mrtt) {
+		time_delta = ktime_us_delta(ktime_get(), sspcc->last_cmd_cmpl_time);
+		if (sspcc->pcc_mrtt > time_delta)
+			fsleep(sspcc->pcc_mrtt - time_delta);
+	}
+
+	/*
+	 * Handle the non-zero Maximum Periodic Access Rate (MPAR): the
+	 * maximum number of periodic requests that the subspace channel can
+	 * support, reported in commands per minute. 0 indicates no
+	 * limitation.
+	 *
+	 * This parameter should be ideally zero or large enough so that it
+	 * can handle maximum number of requests that all the cores in the
+	 * system can collectively generate. If it is not, follow the spec and
+	 * just not send the request to the platform after hitting the MPAR
+	 * limit in any 60s window.
+	 */
+	if (sspcc->pcc_mpar) {
+		if (!sspcc->mpar_count) {
+			time_delta = ktime_ms_delta(ktime_get(), sspcc->last_mpar_reset);
+			if ((time_delta < 60 * MSEC_PER_SEC) && sspcc->last_mpar_reset) {
+				dev_dbg(ras2_ctx->dev,
+					"PCC command 0x%x not sent due to MPAR limit", cmd);
+				return -EIO;
+			}
+			sspcc->last_mpar_reset = ktime_get();
+			sspcc->mpar_count = sspcc->pcc_mpar;
+		}
+		sspcc->mpar_count--;
+	}
+
+	/* Write to the shared comm region */
+	iowrite16(cmd, &gen_comm_base->command);
+
+	/* Flip CMD COMPLETE bit */
+	iowrite16(0, &gen_comm_base->status);
+
+	/* Ring doorbell */
+	rc = mbox_send_message(pcc_channel, &cmd);
+	/*
+	 * mbox_send_message() returns a non-negative integer for successful submission
+	 * and a negative value on failure.
+	 */
+	if (rc < 0) {
+		dev_warn(ras2_ctx->dev,
+			 "Error sending PCC mbox message command: 0x%x, rc:%d\n", cmd, rc);
+		/* Restore CMD COMPLETE bit on error */
+		val = ioread16(&gen_comm_base->status);
+		val |= PCC_STATUS_CMD_COMPLETE;
+		iowrite16(val, &gen_comm_base->status);
+		return rc;
+	} else {
+		rc = 0;
+	}
+
+	sspcc->last_cmd = cmd;
+
+	/*
+	 * If Minimum Request Turnaround Time is non-zero, need to record the
+	 * completion time of both READ and WRITE commands for proper handling
+	 * of MRTT, so need to check for pcc_mrtt in addition to PCC_CMD_EXEC_RAS2.
+	 */
+	if (cmd == PCC_CMD_EXEC_RAS2 || sspcc->pcc_mrtt) {
+		rc = check_pcc_chan(sspcc);
+		if (sspcc->pcc_mrtt)
+			sspcc->last_cmd_cmpl_time = ktime_get();
+	}
+
+	if (!pcc_channel->mbox->txdone_irq)
+		mbox_client_txdone(pcc_channel, rc);
+
+	return rc;
+}
+EXPORT_SYMBOL_FOR_MODULES(ras2_send_pcc_cmd, "acpi_ras2");
+
+static void ras2_list_pcc_release(struct kref *kref)
+{
+	struct ras2_sspcc *sspcc =
+		container_of(kref, struct ras2_sspcc, kref);
+
+	guard(mutex)(&ras2_pcc_list_lock);
+	list_del(&sspcc->elem);
+	pcc_mbox_free_channel(sspcc->pcc_chan);
+	kfree(sspcc);
+}
+
+static void ras2_sspcc_put(struct ras2_sspcc *sspcc)
+{
+	kref_put(&sspcc->kref,  &ras2_list_pcc_release);
+}
+
+static struct ras2_sspcc *ras2_sspcc_get(int pcc_id)
+{
+	struct ras2_sspcc *sspcc;
+
+	guard(mutex)(&ras2_pcc_list_lock);
+	list_for_each_entry(sspcc, &ras2_sspcc, elem) {
+		if (sspcc->pcc_id != pcc_id)
+			continue;
+
+		if (!kref_get_unless_zero(&sspcc->kref))
+			break;
+
+		return sspcc;
+	}
+
+	return NULL;
+}
+
+static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int pcc_id)
+{
+	struct pcc_mbox_chan *pcc_chan;
+	struct ras2_sspcc *sspcc;
+
+	if (pcc_id < 0)
+		return -EINVAL;
+
+	sspcc = ras2_sspcc_get(pcc_id);
+	if (sspcc) {
+		ras2_ctx->sspcc		= sspcc;
+		ras2_ctx->comm_addr	= sspcc->comm_addr;
+		ras2_ctx->dev		=
+			sspcc->pcc_chan->mchan->mbox->dev;
+		ras2_ctx->pcc_lock	= &sspcc->pcc_lock;
+		return 0;
+	}
+
+	sspcc = kzalloc(sizeof(*sspcc), GFP_KERNEL);
+	if (!sspcc)
+		return -ENOMEM;
+
+	pcc_chan = pcc_mbox_request_channel(&sspcc->mbox_client, pcc_id);
+	if (IS_ERR(pcc_chan)) {
+		kfree(sspcc);
+		return PTR_ERR(pcc_chan);
+	}
+
+	if (!pcc_chan->shmem) {
+		pcc_mbox_free_channel(pcc_chan);
+		kfree(sspcc);
+		return -EINVAL;
+	}
+
+	sspcc->pcc_id		= pcc_id;
+	sspcc->pcc_chan		= pcc_chan;
+	sspcc->comm_addr	= pcc_chan->shmem;
+	if (pcc_chan->latency)
+		sspcc->deadline_us = PCC_NUM_RETRIES * pcc_chan->latency;
+	else
+		sspcc->deadline_us = PCC_NUM_RETRIES * PCC_CHNL_DEFAULT_LATENCY;
+	sspcc->pcc_mrtt		= pcc_chan->min_turnaround_time;
+	sspcc->pcc_mpar		= pcc_chan->max_access_rate;
+	sspcc->mbox_client.knows_txdone	= true;
+
+	mutex_init(&sspcc->pcc_lock);
+	kref_init(&sspcc->kref);
+
+	mutex_lock(&ras2_pcc_list_lock);
+	list_add(&sspcc->elem, &ras2_sspcc);
+	mutex_unlock(&ras2_pcc_list_lock);
+
+	ras2_ctx->sspcc		= sspcc;
+	ras2_ctx->comm_addr	= sspcc->comm_addr;
+	ras2_ctx->dev		= pcc_chan->mchan->mbox->dev;
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
+
+	ida_free(&ras2_ida, auxdev->id);
+	ras2_sspcc_put(ras2_ctx->sspcc);
+	kfree(ras2_ctx);
+}
+
+static struct ras2_mem_ctx *add_aux_device(char *name, int channel, u32 pxm_inst)
+{
+	struct ras2_mem_ctx *ras2_ctx;
+	u32 comp_nid;
+	int id, rc;
+
+	comp_nid = pxm_to_node(pxm_inst);
+	if (comp_nid == NUMA_NO_NODE) {
+		pr_debug("Invalid NUMA node, channel=%d pxm_inst=%d\n", channel, pxm_inst);
+		return ERR_PTR(-ENXIO);
+	}
+
+	ras2_ctx = kzalloc(sizeof(*ras2_ctx), GFP_KERNEL);
+	if (!ras2_ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ras2_ctx->sys_comp_nid = comp_nid;
+
+	rc = register_pcc_channel(ras2_ctx, channel);
+	if (rc < 0) {
+		pr_debug("Failed to register PCC channel=%d pxm_inst=%d rc=%d\n", channel,
+			 pxm_inst, rc);
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
+	ras2_ctx->adev.name		= name;
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
+	ras2_sspcc_put(ras2_ctx->sspcc);
+ctx_free:
+	kfree(ras2_ctx);
+
+	return ERR_PTR(rc);
+}
+
+static void remove_aux_device(struct ras2_mem_ctx *ras2_ctx)
+{
+	if (!ras2_ctx)
+		return;
+
+	auxiliary_device_delete(&ras2_ctx->adev);
+	auxiliary_device_uninit(&ras2_ctx->adev);
+}
+
+static int parse_ras2_table(struct acpi_table_ras2 *ras2_tab)
+{
+	struct acpi_ras2_pcc_desc *pcc_desc_list;
+	struct ras2_mem_ctx **pctx_list;
+	struct ras2_mem_ctx *ras2_ctx;
+	u16 tot_tbl_len;
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
+	tot_tbl_len = sizeof(*ras2_tab) + ras2_tab->num_pcc_descs * sizeof(*pcc_desc_list);
+	if (ras2_tab->header.length < tot_tbl_len) {
+		pr_warn(FW_WARN "RAS2 table is not large enough to contain PCC descs=%d size=%u)\n",
+			ras2_tab->num_pcc_descs, ras2_tab->header.length);
+		return -EINVAL;
+	}
+
+	pctx_list = kcalloc(ras2_tab->num_pcc_descs, sizeof(*pctx_list), GFP_KERNEL);
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
+		/* Invalid NUMA node, continue parsing next node */
+		if (PTR_ERR(ras2_ctx) == -ENXIO)
+			continue;
+
+		if (IS_ERR(ras2_ctx)) {
+			pr_warn("Failed to add RAS2 auxiliary device rc=%ld\n", PTR_ERR(ras2_ctx));
+			for (; i > 0; i--) {
+				if (pctx_list[i - 1])
+					remove_aux_device(pctx_list[i - 1]);
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
index 000000000000..f4574e8e0a12
--- /dev/null
+++ b/include/acpi/ras2.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * ACPI RAS2 (RAS Feature Table) methods.
+ *
+ * Copyright (c) 2024-2026 HiSilicon Limited
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
2.25.1


