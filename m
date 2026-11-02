Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FD6606BA4A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oZm5moH3
Received: by kanga.kvack.org (Postfix)
	id 0E8626B0643; Mon,  2 Nov 2026 10:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D896B0644; Mon,  2 Nov 2026 10:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56C66B0645; Mon,  2 Nov 2026 10:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B39916B0643
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4115C1C1E14
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:07 +0000 (UTC)
X-FDA: 85390582494.08.2F8B55F
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9390E100003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oZm5moH3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3IK7oagcKCH0wjqjotihpphmf.dpnmjovy-nnlwbdl.psh@flex--vipinsh.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3IK7oagcKCH0wjqjotihpphmf.dpnmjovy-nnlwbdl.psh@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBehZpEkki34QiJCaFptvQANMlmxsUHjEKEQ/Cb0BiU=;
	b=A5NormwmoiAGvzP2yuf5EjDU8Xy344lgfVmeAUD+pjqHh8T1yXq6hPe3fS55fyZp+Rnbw5
	BD68ssthdHtWHfK2nDG10NutCLpPESzXzjvGNjRZFNogXhmsGsdvl9GxIzVDQBmWSnXmpX
	yLJXeABcwR4sVPhxkYUZsrhMis9X2QE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oZm5moH3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3IK7oagcKCH0wjqjotihpphmf.dpnmjovy-nnlwbdl.psh@flex--vipinsh.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3IK7oagcKCH0wjqjotihpphmf.dpnmjovy-nnlwbdl.psh@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633825;
	b=ISm8JCEVCKEGUSYPBYGIqJV/an3S1e7iObIS7Z/MvBCR0usMJ8aG20QgtWZCr2jVpj8gCn
	idEItW2QbPnysjI9s/tSUfpZ4nBLf/naLkapiYKOP7/pPxhQLnxL9d0Q40WI/Vqq2icBWI
	A7O6XTnj5h5Y7nO7MZToSKj2kUR/LbQ=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3aed1b64104so738763a91.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633824; x=1794238624; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gBehZpEkki34QiJCaFptvQANMlmxsUHjEKEQ/Cb0BiU=;
        b=oZm5moH3wryNpe+S3PTuAYdT4PK8lbCmUf82Wpo9e+mhsBrAjO+8Oon6/rGcshPqLE
         t6K9KDfFs7hVyMAD1NH/Ixn4RKcbIRxfRvJdbnps0IQ+177nudz/ZVOuYpqj71fMODqA
         Cgqh+grOEDjK1jDAYmF596UFBBtEGHiCsH9YsOQVcdfDD+6kDOz6ofTTMOYz8Ya30+y6
         pnwDdiOeKFaIfdArEaB6hikUAbPbIzXNwvO+PVf+UQhsLqBU0b9rYkC1s6xb6hb6g6YM
         w6SyQOoWN0zLVBnFxxvYXJAmS8LlJRPVLPXhfc+gUGw1o83PYoB0XAfHTVCRd5PfbO/J
         adBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633824; x=1794238624;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gBehZpEkki34QiJCaFptvQANMlmxsUHjEKEQ/Cb0BiU=;
        b=RDcJfGJd7aY0G/1bSb+/k7+SZyEk95Q1luOeRobAdu+YN+NHAS6mSFltUq4h8c/Uu8
         b+I+KaEXsZoAwDoIDtKiZYSxAaotCSltY81KhtSjBYJIigNT6TwRw9ca+kRFvSvje7t/
         wVrW/xQ38oaH8brzk/Hq8V7JTF8nnd5w9yCCAlje66mbU4whXGNQyivarSfmjUUa27Vm
         Bxe5Z2do8taNWDKZlkwSdoLAQAx56FlALq3buSaZ3TE4gMBNqo9NU1MMTWYZEuKvekbX
         LUliUhIX+FIEvHUGfCbi9xcUpEAw3t0m+ArySoru/x5hyDQxQVedSAMDklUuJU4Uwwi8
         KvhQ==
X-Forwarded-Encrypted: i=1; AKwUvBxwo6gVjVnmuYCQEx3ZqPalr04kc6MC1cXruedXugo7PbRSWZ71ir2nwNpdT1crznn8oTz/A5MDDQ==@kvack.org
X-Gm-Message-State: APuU4Z8WWc7PRmyu2NEWIwqpIsQQTHCHJ8frNHyyTrTFeu72TmrZqFIn
	SO11Rs8yWAvOrdNJcBLYp0pKGqbKJPrhbF64q4q8ASRdwSc69jQ+0cXkCkKIMGBTH8kdNVve59h
	K47QTIgOIPw==
X-Received: from pjzr10.prod.google.com ([2002:a17:90b:50a:b0:3a8:22c8:d19b])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57c5:b0:3ac:a139:1b14
 with SMTP id 98e67ed59e1d1-3ae8984acc9mr9407724a91.57.1793633824222; Mon, 02
 Nov 2026 07:37:04 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:33 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-5-vipinsh@google.com>
Subject: [PATCH v6 04/27] vfio/pci: Register a file handler with Live Update Orchestrator
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9390E100003
X-Stat-Signature: 9iaok4onh85xnonriaftqy53gj9x8aca
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633825-561518
X-HE-Meta: U2FsdGVkX1+2pnSeH7AHBXPeLHgp32E5xk/G2QLZvJRlyxbqVP16ovN7ThoB2VjKlTSnUBwod+XiJmlrKFH+p58wnXSAEIqLD7fjzEQ5DKI2e0Lkjfhn4T+yg1tTb/+swYS4+OWirR714cXV+64UcJ7pTxfn+kzs8XbrZLkvB1I9TJQeKs5nlQLaKgmMr9E7BLfDuLvr0r/eEpOZ3NtOG/kmiISAsPJ09tf0Bppkntop5pFTHjIvmvBvJRl7BYZ4uNlM0j38titS/4kcXvQ9EfQ1eYYPYg74DA6cWEyTOBzR7bV+gOqTaz7EBSRhjY0dOqpHKFceoW2E4Px+NVBY4xLYEBTY3UX5CRv9bjVDb/j5cEEVo6KH20Nx360YZsTGEhFEWf6iomeL4hCScQfPEZubUooHpyP5FS7RPctiFs38wNh5fcaMRqcnPMsfeYWyyQFRyJvKkkRxg4r7tfAeBzc89e1L0Oj1k2rI//KiF9HUIkU5tEdeaoP8DwTKrqWhKTW9gxkSubtPylPkK9eiw+gZZRPjsUFwpUGnI6a4PeKluI/k9zmDj/nPw6DGUaszV85oq4NX0RXKNJH82dalNeAwGSGcUuXw8DgZUCvLfSc4W+ofL7yodm8YuIqBE+7BXyc5Xne1iSyIiQlFYms0A+u/Ydgo4d9PvYX7a8vYSE74hR9ej7dNYSZJFlMjRTWuvd63E3YW+fFnPdyctzKosJdMMUxQgrfUlImSpVfWPCmI2OO46W95DysuAeN0go4K3+yUY9Abgpkwh4QXC1LU5QWjmlNVew1GYm5AN5lMfJ1Mkrza9KEDILSWkK52EVgYYN3EUgpGV/rJHZzuBBM+Zx8DaUmcFHTor+4OqXK0Z479yf/efToA2l+nF/50jV3Q6+6mmoeVcJ7bg/Q+S2PvVX5jve4HclgLDus1beIxfJ7HJ61UKKTj3tz0s9p5apjVM/mpJrRre3kPNqGkIm9
 0HeA1i6U
 LG2EOyX09BAeBm2Ltm95MkrrNm9iD+McqWJwVD9YaSbYxitvwXaXcJVI0hHjLkSt92lYt5n9LR0syE+L5gwCjCMefuqcO2TPpdIBndOxo2xhSdU62HccizOxhw3Gt4Sf3uHb5CbtEHywvZxenR7fk4vbCUQYEz6vJTfBNdhSXOJmXriZrvSAg9kV7eEOilyWaT2s1v3yHotVN9X3SO4mxJ6GQko/9Zw44yL90e9r3FmURuLSPHom1HxEIzuz5Pko809T7wtk0wKKWwodTXOIftn6CUQk3mTvItnfh8THO9DBdiXVZkI6ELzYksTpbWiMgcAhzkmbmNGGjzWqSJv9qhDD+cy6f3LZonibLklxc4YDMq562lZDn+g62lGU7ygZVM4XSsgjraLX5ZaBFqWpgwF6rmSlgbE6mCINdy8AWTMz0sqH4Z4ICpH6Of06++BAYK9xYJoPQNRj6J0kZCDdmoY9Noqf+8Ng3AXG4y1ZnY6TE+6IHCokTDrr0hKJ4kYs6QWUA6wqzUbrz6WcwnSdWbqAhtuFaztBKpcRuWwXdhfI/BoiLEkDxxhJmkPmEqQj9X+hUf1YfkpZzpz7Q61+mzPhX8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Register a live update file handler for vfio-pci device files. Add stub
implementations of all required callbacks so that registration does not
fail. Register it with both live update framework and PCI subsystem.

This file handler will be extended in subsequent commits to enable a
device bound to vfio-pci to run without interruption while the host is
going through a kexec Live Update.

Put this support behind a new Kconfig VFIO_PCI_LIVEUPDATE. Initial
support is added for no-iommu model vfio-pci devices.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 MAINTAINERS                            |  1 +
 drivers/vfio/pci/Kconfig               | 11 ++++
 drivers/vfio/pci/Makefile              |  1 +
 drivers/vfio/pci/vfio_pci.c            | 11 +++-
 drivers/vfio/pci/vfio_pci_liveupdate.c | 75 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h       | 14 +++++
 include/linux/kho/abi/vfio_pci.h       | 28 ++++++++++
 7 files changed, 140 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
 create mode 100644 include/linux/kho/abi/vfio_pci.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d1b58271989..167aa9d66ce8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28662,6 +28662,7 @@ F:	Documentation/ABI/testing/debugfs-vfio
 F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
 F:	Documentation/driver-api/vfio.rst
 F:	drivers/vfio/
+F:	include/linux/kho/abi/vfio_pci.h
 F:	include/linux/vfio.h
 F:	include/linux/vfio_pci_core.h
 F:	include/uapi/linux/vfio.h
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 296bf01e185e..e8285ad93a69 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -42,6 +42,17 @@ config VFIO_PCI_IGD
 	  and LPC bridge config space.
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
+
+config VFIO_PCI_LIVEUPDATE
+	bool "VFIO PCI support for Live Update in no-iommu mode"
+	depends on PCI_LIVEUPDATE && VFIO_NOIOMMU
+	help
+	  Support for preserving devices bound to vfio-pci in no-iommu mode
+	  across a Live Update. It enables a device to continue working (DMA)
+	  while host kernel is going through a kexec live update.
+
+	  If you don't know what to do here, say N.
+
 endif
 
 config VFIO_PCI_ZDEV_KVM
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 6138f1bf241d..bf296ab1c967 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 
 vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
+vfio-pci-$(CONFIG_VFIO_PCI_LIVEUPDATE) += vfio_pci_liveupdate.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 2ec600768007..9d48b250a5e8 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -278,10 +278,14 @@ static int __init vfio_pci_init(void)
 {
 	int ret;
 
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
 
@@ -289,12 +293,17 @@ static int __init vfio_pci_init(void)
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
index 000000000000..8fd5af4f4b83
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -0,0 +1,75 @@
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
+#include <linux/errno.h>
+#include <linux/kho/abi/vfio_pci.h>
+#include <linux/liveupdate.h>
+#include <linux/module.h>
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
+	if (ret)
+		return ret == -EOPNOTSUPP ? 0 : ret;
+
+	ret = pci_liveupdate_register_flb(&vfio_pci_liveupdate_fh);
+	if (ret)
+		liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
+
+	return ret;
+}
+
+void vfio_pci_liveupdate_cleanup(void)
+{
+	pci_liveupdate_unregister_flb(&vfio_pci_liveupdate_fh);
+	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
+}
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 1634135de3f8..872b01bcb5a3 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -148,4 +148,18 @@ static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
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
index 000000000000..67e8199eec59
--- /dev/null
+++ b/include/linux/kho/abi/vfio_pci.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2026, Google LLC.
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
2.56.0.317.g454f8302e1-goog


