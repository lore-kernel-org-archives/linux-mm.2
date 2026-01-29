Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC527D73E90
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14556B0093; Thu, 29 Jan 2026 16:25:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFCF46B0095; Thu, 29 Jan 2026 16:25:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9813E6B0096; Thu, 29 Jan 2026 16:25:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D42B6B0093
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DF101B0982
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:47 +0000 (UTC)
X-FDA: 84386283534.28.E5BE974
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id 85D801A0003
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yZQJyqSU;
	spf=pass (imf19.hostedemail.com: domain of 3WNB7aQgKCDsajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3WNB7aQgKCDsajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DumsOMxgbS0OIrY6jatWasSBK4J7y0u52rkK5iohgQ=;
	b=0L4WJ6TKVqsg4gkQg4/MIrdG5fseZC0tnapLybd7wbelfG3ZYeNqvfeY2JsleSla87uMj/
	Qc63xBtJZ2UZ5mNV0GbV1e1g/SfAGJNLmGzsSp2Th+11Ym+XPZAJIfXZBxWdNgfPG6ZjQ/
	cH2uzCFyOzm7GTohEY9Jxr7RjqvoHoQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yZQJyqSU;
	spf=pass (imf19.hostedemail.com: domain of 3WNB7aQgKCDsajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3WNB7aQgKCDsajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721945; a=rsa-sha256;
	cv=none;
	b=7fQfmQstxNMQZa0cRDM25+xCZ7pus6/Z1JJEH/mwKOdBlQdlfqmmOEguJQQUc29+5EJxOI
	/+ZBwspW2abjGyKv6oqxQ0guoqZsF7SwCQsP29lp41A86lMhyMfeOBXSxY1IIaaBUp21lM
	153HMasFg2ZuFbrVQ8Xqc8hWj0Nq3mE=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f1f69eec6so15834555ad.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721944; x=1770326744; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2DumsOMxgbS0OIrY6jatWasSBK4J7y0u52rkK5iohgQ=;
        b=yZQJyqSUU915QNnAQU9zyjRFntkSevLGI90MBnAVite8DSoppvclP+almKsaZlOvd6
         J9ozaJmmmMLLlIPAWn+zfbnexI8pgcm/73yf7SNKcTtFWluDw6z0b8cjAilODjG5oBi7
         u/VxMtP+r5VEd0gZj0IUx42gU4oiKqCJqQMQwZzeg2dmpOi2zHDuXREu57xFM+688ppx
         0bEXQQDWEODO3IV2kJn4hE79063ivJN66Wx9OGbt05gjSLKEFD0cZWjYz2it1PwqYmDz
         vH9y1LliqW2MuXglD6UMqu8Qm6loifPjn2ulq5KkqAPJDzA4AWIO2mqTQ7QbvrlTYXKv
         xy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721944; x=1770326744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2DumsOMxgbS0OIrY6jatWasSBK4J7y0u52rkK5iohgQ=;
        b=LnW2WgRciuK/2/r8gCpw8YWaWBABgUL2AwYLL5/aM083zFwX9oM3z/VCz1x3yO58sA
         bcZ0zO01X1DojZP31p7R0D9/d5ER2rC16vJ4YOmfM1Rq8L3fLUJusWDW9btzn5yrVbRe
         F8A0dWBq2f9jfNDpN2o/nOzSZzKJ3dysjDDgjzsQE+y0I9Ue+5mCu9uNiwiVRRbWLy7c
         On5Nu+f+piXVuaQCdS+bODeUjWWxfczV1dqlqGk4NQkDD4r6uSl8SgUn3hZd3uexyVLS
         JT2Ix8xtYFELjnl1LFEjOxkTpnAlO0uaY8CxClKftaiH7FAz8ATalJTr/TQ34eyox37z
         7Y2g==
X-Forwarded-Encrypted: i=1; AJvYcCVWLpYo1PtlkQMxcH54OmXvZZdr8bqtWvIbIZd6IP7TIMsQhhOpyG/nATWd4ICG9278KPpQSDlTVA==@kvack.org
X-Gm-Message-State: AOJu0YxiKe7fLc0P1fnShpVJSo2kiUKEdLetQAz7NDQvB4iCEJ56NWou
	dcoTniWZbu8c5vejyhwRKj8lusS1r23AvClQhG8blISgtoYem4DctQCfXoMmHFcUB3xzOYPNMwz
	KSew5MtXOh0bXCQ==
X-Received: from plxd5.prod.google.com ([2002:a17:902:ef05:b0:2a7:5199:9c34])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:41c1:b0:2a0:d074:e9f4 with SMTP id d9443c01a7336-2a8d9a55422mr4900435ad.59.1769721944173;
 Thu, 29 Jan 2026 13:25:44 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:51 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-5-dmatlack@google.com>
Subject: [PATCH v2 04/22] vfio/pci: Register a file handler with Live Update Orchestrator
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 85D801A0003
X-Stat-Signature: az3kfkppnwy5xqxzwymsxey6kuxdq3gg
X-Rspam-User: 
X-HE-Tag: 1769721945-447837
X-HE-Meta: U2FsdGVkX1/RH43FxbRrQyTuRqhTsVLJ2jRh8Bb/bY/xI0erFRav0W6SGmP+ZW4XHcmdmYzCaZWgiSswtE3Q7wrIkB+7DjOntD+tcHJ+7Ph7lFymFOYM3bj7ESdZZ5nXffJjglvMX8Elak+om7C2zt9xsmF+OorS40yx2PIM6IMbVQU0wv9mnAQXbxpqqTiLxklrHIqAhcPg/ZugWyiV9KoCmAPuHbIvh8X2ByAhMUENGKXyApUZQzo9kvY/7mPj65YJFKPfz4FqLssjSjM3XEQIEue420j4QCFy7uDgk2o6Y7J+4kaulwyX6Ixx3YONV+4y2UOHluAB3w43GHVC7u38xvx23nDXS+9AcgqbkHeoKMkxvLv83LZl+ef+RFzL2N4qu4UZXrTLgdZcLNj8gCuilbT3GjqitmpDAXNwsShPVfEo/Yv8v45a/Vox4a8R3kSNpdS40VKR5dyqfUJyoMdpYq1gnAEWULUDzNS0dkVjpCBXF6u3drG41BwB0+sUPzY7U0lBcxc3S682/SomLx+e586UmhIlgoRboPU4i9Y9PZQ8yN//Nh+bVTybyGoH2AukNx3LmHTlJzTvE3qqaLReXPmtdVn0GuwNDnczLk7F/pW2MmPyQsLt2Q0lTN4x5XKBwBmDHxXwxmkfp7dvtakNq7GkaEqm1wpLWIWNxzwf2nn2sKSyd6n+9mtl3BKz+m9Am/kEsylJQh7PxP2EfaiG+EHecAh1T/FgFqAFqoNZeFyMPnsBE90B4A0Qr3aspRcUlCk2hU0rLdwoKXpW3BdotZmYI0A5Jlm4qlcN2WiiV6sRGU0QQbKXNfKdSC1G4fGWBDkdAiFm8KyE0IbmEzrmtnSkzxPme15dZTN/flBUjwCs9HGiUYRCPcuwLXBpATi6vrslL6Fa0Xh7FANI8EsqdUqX1QxCdHJIvu2WO7Q6sI88e6DOoIajP4jSVx78fany2bNjuDjdzXok66m
 gck4aZfX
 m6r01pXLY0CApCPYoJqb/E79m/eIQcO+W/h+6j/abuBW6m2UY9zXqqyGw+LI4VwLVilIBdIt3zo9z7QJie7r5ONlYX1xxCmdUwP2du92X1xzb6x7/VQr8dDIPz6Q/KIkun47zdLUO5THLK9gvbCpuYkQG8tS/bO4/g5Dk5PNZLAC6ubxVvdRMCcocAtYElISIK7a6UeiMo5tdg9oGIGV7nnJvMt9/crvwjwyupcH6XHAXO4YjlJKAfISkACJ6hGTXRt5mTGvaxTNr+Gkj0yiBg4RE1dVFOePrkq502hMFZnfjSs3dnJ5RSTjEfPzISMLt/apoaIOqWBq9NnMUE4kzmZ4Oihh2MyCZN1C+A9RTbhYnul2s5kkVt05eFU90jy5MWCcBw5T9x6QYjWkjfSwWsxtbGgzv7UI1QqCpQUywXA0Fd1hZTWRY5y4GU/U2g/PTNcM3t2w4CxODEot1zHdxFZc8fPR5n24Nw6BQQH4E7/MjY87LEhVSyojbQatyR99+a977MppYL8hLSn9KVV2MHX2sodcQf6XPCrycxf7cqO1yZrHDCuV/okbXlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                            |  1 +
 drivers/vfio/pci/Makefile              |  1 +
 drivers/vfio/pci/vfio_pci.c            |  9 +++-
 drivers/vfio/pci/vfio_pci_liveupdate.c | 69 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h       | 14 ++++++
 include/linux/kho/abi/vfio_pci.h       | 28 +++++++++++
 6 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
 create mode 100644 include/linux/kho/abi/vfio_pci.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a671e3d4e8be..7d6cdecedb05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27520,6 +27520,7 @@ F:	Documentation/ABI/testing/debugfs-vfio
 F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
 F:	Documentation/driver-api/vfio.rst
 F:	drivers/vfio/
+F:	include/linux/kho/abi/vfio_pci.h
 F:	include/linux/vfio.h
 F:	include/linux/vfio_pci_core.h
 F:	include/uapi/linux/vfio.h
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index e0a0757dd1d2..23305ebc418b 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 
 vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
+vfio-pci-$(CONFIG_LIVEUPDATE) += vfio_pci_liveupdate.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 0c771064c0b8..19e88322af2c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -258,6 +258,10 @@ static int __init vfio_pci_init(void)
 	int ret;
 	bool is_disable_vga = true;
 
+	ret = vfio_pci_liveupdate_init();
+	if (ret)
+		return ret;
+
 #ifdef CONFIG_VFIO_PCI_VGA
 	is_disable_vga = disable_vga;
 #endif
@@ -266,8 +270,10 @@ static int __init vfio_pci_init(void)
 
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_pci_driver);
-	if (ret)
+	if (ret) {
+		vfio_pci_liveupdate_cleanup();
 		return ret;
+	}
 
 	vfio_pci_fill_ids();
 
@@ -281,6 +287,7 @@ module_init(vfio_pci_init);
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
+	vfio_pci_liveupdate_cleanup();
 }
 module_exit(vfio_pci_cleanup);
 
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
new file mode 100644
index 000000000000..b84e63c0357b
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
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
+	if (!liveupdate_enabled())
+		return 0;
+
+	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
+}
+
+void vfio_pci_liveupdate_cleanup(void)
+{
+	if (!liveupdate_enabled())
+		return;
+
+	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
+}
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 27ac280f00b9..68966ec64e51 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -133,4 +133,18 @@ static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
 }
 #endif
 
+#ifdef CONFIG_LIVEUPDATE
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
+#endif /* CONFIG_LIVEUPDATE */
+
 #endif
diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
new file mode 100644
index 000000000000..37a845eed972
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
+ * This header defines the ABI for preserving the state of a VFIO PCI device
+ * files across a kexec reboot using LUO.
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
2.53.0.rc1.225.gd81095ad13-goog


