Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC9B8F532C3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7BB6B009F; Mon, 23 Mar 2026 19:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689606B00A1; Mon, 23 Mar 2026 19:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550956B00A2; Mon, 23 Mar 2026 19:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 342F66B009F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:58:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D92E713C290
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:50 +0000 (UTC)
X-FDA: 84578995620.11.CEB6159
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 16AD8C0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N+7K7ojS;
	spf=pass (imf28.hostedemail.com: domain of 3t9PBaQgKCLoirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3t9PBaQgKCLoirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310329; a=rsa-sha256;
	cv=none;
	b=cYnQA4JYQChLpaQ3zv0JSf60sTFOT/obOpA6kPL6Mvo76PxIp8n8cF3wxeoE0YZFgdD6yz
	o8w2RXwuSazzUAMvOTgtL+rf9EXN4OenktG46eHTz8E7Nor7tMnj8q56KU8840NIe7uMKt
	eigMKrCdS0mXv9OCHzo4XXLhZoFVnbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCGcH5x5HW+NRzEKEkZIp2gqKlZo/LGIoKmQ3sM/JLo=;
	b=geAGMWjrWwIZfchHOCb/4PGHVVVEu0XsqS4VZhmdMqvOZ8mxBh0eqoaxM+8/HQSLGnbBOg
	tliPpiBkdnKZXQWauz3r90fsvcnd1XlGz3BI7TpUZih8WpDj3ye4o+RfWoJH74PIJold8K
	vQ0esKM2S74nHwzeWvR9adc8zB8qek8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N+7K7ojS;
	spf=pass (imf28.hostedemail.com: domain of 3t9PBaQgKCLoirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3t9PBaQgKCLoirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35b901d542bso265188a91.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310328; x=1774915128; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YCGcH5x5HW+NRzEKEkZIp2gqKlZo/LGIoKmQ3sM/JLo=;
        b=N+7K7ojSJxDv6TfW/thxyS5gjL93bE0/gX1WtEUq3nQLiUVdkdSLRcczW1bfE8OTLj
         3TSLaXlZzXGi30mj+zLe203k9fmuZmA8I9odJupreOkA+hpkj6faxIF/6x5mlNOB/4kn
         DI4dfyyggxnfb10/yM2xJNwmzDBFClulbTLcWtxkOfwCPI8sYV93ItIHNpbqSSIXk83l
         z0A1gL6BrbOn8tIqxV3o4UGly4/zo/OuWn75mTiwaLWK4ZFfi59ORYlCtmtVHWp2VAbK
         UooYUrMgwBdxI9jXwN2Ng87YgvhxjvgEhUT9mU1Qur098qy9TtxrMhJqw+vzgcVp7y5S
         6jhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310328; x=1774915128;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YCGcH5x5HW+NRzEKEkZIp2gqKlZo/LGIoKmQ3sM/JLo=;
        b=VrsGzbjVozP5uHmzDIC1hcqFfeKd3pGh9LTAr4XpkR4e3fHBp5K9SUWsObQ1Fiblgg
         43P3zPZxZiET9Z6BMNqTQ4JL16EemBMZghncXStuYNGPWHbF/qAx0Va1q3aRSg3coo6+
         Q9N0XyT/ICIShKnW7GyUVR749z+kLrzAzL69jOvo3A0wQ2JnWbg7SqMugcjBue3HVcGB
         7yG2oJrNtV0lItNPfUJPwFNozB+mw/xin6T/Z/BScoPBAygMzgVEeMQvd9gQYZ6kcKw4
         bsBTMkXdkGdlAzJ2votBIcML0OyvFflWhxUQrn8dmPB0vLhD0bd0vRePI1pscWI/YFmE
         rrxw==
X-Forwarded-Encrypted: i=1; AJvYcCV67gvwshneULqWa+iJNSpYBLAPMvaOOfOXbXBgchF08c6I9F8IvHia1ZG2O3U436+2wapUllNpqQ==@kvack.org
X-Gm-Message-State: AOJu0YwPQP2qoopsv+mlLm/XyN0JHn5b/fyWMDIYN5JgAhAtrLUQycS2
	0cKeW2a8dSLEa0qgZzSKyRCf4Lcc8nvNJmskzvoTpm28O65fYr+kMp37CzVBXpZMJltZJl3KYrb
	RH2r3NnAY42XHrg==
X-Received: from pjvp18.prod.google.com ([2002:a17:90a:df92:b0:35b:9822:9f79])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1a8a:b0:359:f43d:4a6e with SMTP id 98e67ed59e1d1-35bd2996301mr12903584a91.0.1774310327594;
 Mon, 23 Mar 2026 16:58:47 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:57:58 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-7-dmatlack@google.com>
Subject: [PATCH v3 06/24] vfio/pci: Register a file handler with Live Update Orchestrator
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 16AD8C0005
X-Stat-Signature: rqkhbhdgupsgp1qeahh7i5uqugs7rj75
X-HE-Tag: 1774310328-111318
X-HE-Meta: U2FsdGVkX1/BVEvrnXh0w9Wi8AxV0stJpDjQmYkz8ngw+yVLb8HyOyvn7tVWIkJkc7sfqZ2h7LsglniHGuchcvnMuEt9OytqsYy9iQYs1LiXoxROYMUrNFbFesIi3mUjMgYxujgE0ife8tA1kW8iLQPcg5+AsuO+Y77FStZY6E95S/4sgvrxG0qDao4Qnob6ua69JfcvmL0zfOwAIBF9Lq6RZLS/x2FQtO8ximwv8QG507liH4Ox/gCrql/TNgxSq8kOKSYUiOXWBevH0H5CpEuFnkDOJJOZPXtoQJElb1NXsWhOe/ZAJE/8GHRIYR+LFfhlIgeyONKPTtZGJPwGO8Vt/7VnqgP8MtZE6DwMn/e2TuwhpOYHshSqRY67bcTuYjddPCezrMJ/zCs30775lU4VTF8G9qbRv1gayqiX/L5gINtiavYL9oX/vu7IGL0qLIgKJf2YTpm9M1YeP6AmUaYyyAswhJPXsRmwAXXfcStq/jhXARcH/FatK4S1t+hgfm3KrC9psXxgBndgYC2Uan3mwI1lq4KphvCPGR9DOdD9pR7cu4cxZvnsbk5XaqaYFmmJt0DFO00E7f43JUYCVQTh3lq1xA1uRMb1MT5vQu5b/sZM3X2vvwNKIJb3wlBb+zM6iiK0S43FrhKAbm36HvFgumNTiymeEXpO83ti9nainnfhvVsJtE5N32GLFlByxwuv0FSCPeUHSRgkzY2Te5Lxx8Awhlo8FYMCqDbs+z2raQ4iaqHL+vqmyP+/Guk2fsUyaup4/+xkHNNr0VuOUXVcgrCgNamWpfGgAHXooIocQ/QLqodhaHAi+1Ok0ZsrvE9l3y83/A3BjXfwx2gWeMus7ahHFRHeQ9LKPH4Ara1yguXFcZKYN2ozseCVzzUAJaX46acMrE31c9DtQcEX+cEtmVeqso4AUCay/LAYiUCEAzd5n3/bsNe9nY0ZgBS7IkcECssv1z5ufjJD0F1
 nfgDZoOR
 D3TcMpCwVuY3rXoc2U+YokfpB7FI6Y7ApimJAeE3jZADRH7Io/M87wGKTTgNTUdlFG+Cv/R9U51gtcXKBxz2y6bdMHzX6lf7I8UWemy9gr7dz67tHmIE5t0k+T457WzlVT6G/F7icp0MD9lBwceowSKYojjeXAek4fUwCXWqMwlB15YAoqiRysWNtumrLNyQr2LLtAL4vM0hHJSTtuPQj7KI3PfW76DowosfLQFSUylznWDFQlD5S5VDOLAhl+/AUJycxMQkAf+YAMlgwlQbfxxFK3XqYs9mwFKOCLVeIbe1Zq08Usqy1Zjtb2viketZZSC075/noOy3W8GSmHIHN83x0MsS9Wby6FlHjnfcEOxIUkz3gY1PGBV2+rp/l/BkXt77XXqm4wiRVZG9q/ioWwjZt8ceftRi5mtIUEb4OTbnOBfjfljE8NthhO7Zea//ub2TtF88H72brfhmXZZn6O/Z+YIb8OtNviW4OzjAIywWeDNFEH2/6KMDqYaqmilZsqyZCBe7oRNSb/AAlcMP9MmjdDza1K3kySGGUxPX/Aj7IBIR+Ll0ETSZn07Ggta5YSEGkmch0zV44+wFmXojCpHy6NILbhQOPvsmRSwEo2EeZI2lKTNAnZ+IAT43fH3Am/mR1anuFSaXVJUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

Register a live update file handler for vfio-pci device files. Add stub
implementations of all required callbacks so that registration does not
fail (i.e. to avoid breaking git-bisect).

This file handler will be extended in subsequent commits to enable a
device bound to vfio-pci to run without interruption while the host is
going through a kexec Live Update.

Put this support behind a new Kconfig VFIO_PCI_LIVEUPDATE that is marked
experimental and default-disabled until more of the device preservation
support has landed in the kernel.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                            |  1 +
 drivers/vfio/pci/Kconfig               | 11 ++++
 drivers/vfio/pci/Makefile              |  1 +
 drivers/vfio/pci/vfio_pci.c            | 12 ++++-
 drivers/vfio/pci/vfio_pci_liveupdate.c | 69 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h       | 14 ++++++
 include/linux/kho/abi/vfio_pci.h       | 28 +++++++++++
 7 files changed, 135 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
 create mode 100644 include/linux/kho/abi/vfio_pci.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 96ea84948d76..a16a7ecc67a4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27685,6 +27685,7 @@ F:	Documentation/ABI/testing/debugfs-vfio
 F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
 F:	Documentation/driver-api/vfio.rst
 F:	drivers/vfio/
+F:	include/linux/kho/abi/vfio_pci.h
 F:	include/linux/vfio.h
 F:	include/linux/vfio_pci_core.h
 F:	include/uapi/linux/vfio.h
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 1e82b44bda1a..8f087f7b58c3 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -58,6 +58,17 @@ config VFIO_PCI_ZDEV_KVM
 config VFIO_PCI_DMABUF
 	def_bool y if VFIO_PCI_CORE && PCI_P2PDMA && DMA_SHARED_BUFFER
 
+config VFIO_PCI_LIVEUPDATE
+	bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
+	depends on VFIO_PCI && PCI_LIVEUPDATE
+	help
+	  Support for preserving devices bound to vfio-pci across a Live
+	  Update. This option should only be enabled by developers working on
+	  implementing this support. Once enough support has landed in the
+	  kernel, this option will no longer be marked EXPERIMENTAL.
+
+	  If you don't know what to do here, say N.
+
 source "drivers/vfio/pci/mlx5/Kconfig"
 
 source "drivers/vfio/pci/hisilicon/Kconfig"
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index e0a0757dd1d2..f462df61edb9 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 
 vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
+vfio-pci-$(CONFIG_VFIO_PCI_LIVEUPDATE) += vfio_pci_liveupdate.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 0c771064c0b8..41dcbe4ace67 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -170,6 +170,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = vfio_pci_core_register_device(vdev);
 	if (ret)
 		goto out_put_vdev;
+
 	return 0;
 
 out_put_vdev:
@@ -264,10 +265,14 @@ static int __init vfio_pci_init(void)
 
 	vfio_pci_core_set_params(nointxmask, is_disable_vga, disable_idle_d3);
 
+	ret = vfio_pci_liveupdate_init();
+	if (ret)
+		return ret;
+
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_pci_driver);
 	if (ret)
-		return ret;
+		goto err_liveupdate_cleanup;
 
 	vfio_pci_fill_ids();
 
@@ -275,12 +280,17 @@ static int __init vfio_pci_init(void)
 		pr_warn("device denylist disabled.\n");
 
 	return 0;
+
+err_liveupdate_cleanup:
+	vfio_pci_liveupdate_cleanup();
+	return ret;
 }
 module_init(vfio_pci_init);
 
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
+	vfio_pci_liveupdate_cleanup();
 }
 module_exit(vfio_pci_cleanup);
 
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
new file mode 100644
index 000000000000..5ea5af46b159
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Vipin Sharma <vipinsh@google.com>
+ * David Matlack <dmatlack@google.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kho/abi/vfio_pci.h>
+#include <linux/liveupdate.h>
+#include <linux/errno.h>
+
+#include "vfio_pci_priv.h"
+
+static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
+					     struct file *file)
+{
+	return false;
+}
+
+static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
+{
+	return -EOPNOTSUPP;
+}
+
+static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
+{
+}
+
+static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
+{
+	return -EOPNOTSUPP;
+}
+
+static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
+{
+}
+
+static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
+	.can_preserve = vfio_pci_liveupdate_can_preserve,
+	.preserve = vfio_pci_liveupdate_preserve,
+	.unpreserve = vfio_pci_liveupdate_unpreserve,
+	.retrieve = vfio_pci_liveupdate_retrieve,
+	.finish = vfio_pci_liveupdate_finish,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
+	.ops = &vfio_pci_liveupdate_file_ops,
+	.compatible = VFIO_PCI_LUO_FH_COMPATIBLE,
+};
+
+int __init vfio_pci_liveupdate_init(void)
+{
+	int ret;
+
+	ret = liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+
+	return 0;
+}
+
+void vfio_pci_liveupdate_cleanup(void)
+{
+       liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
+}
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 27ac280f00b9..cbf46e09da30 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -133,4 +133,18 @@ static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
 }
 #endif
 
+#ifdef CONFIG_VFIO_PCI_LIVEUPDATE
+int __init vfio_pci_liveupdate_init(void);
+void vfio_pci_liveupdate_cleanup(void);
+#else
+static inline int vfio_pci_liveupdate_init(void)
+{
+	return 0;
+}
+
+static inline void vfio_pci_liveupdate_cleanup(void)
+{
+}
+#endif /* CONFIG_VFIO_PCI_LIVEUPDATE */
+
 #endif
diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
new file mode 100644
index 000000000000..e2412b455e61
--- /dev/null
+++ b/include/linux/kho/abi/vfio_pci.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Vipin Sharma <vipinsh@google.com>
+ * David Matlack <dmatlack@google.com>
+ */
+
+#ifndef _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
+#define _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
+
+/**
+ * DOC: VFIO PCI Live Update ABI
+ *
+ * VFIO uses the ABI defined below for preserving device files across a kexec
+ * reboot using LUO.
+ *
+ * Device metadata is serialized into memory which is then handed to the next
+ * kernel via KHO.
+ *
+ * This interface is a contract. Any modification to any of the serialization
+ * structs defined here constitutes a breaking change. Such changes require
+ * incrementing the version number in the VFIO_PCI_LUO_FH_COMPATIBLE string.
+ */
+
+#define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
+
+#endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
-- 
2.53.0.983.g0bb29b3bc5-goog


