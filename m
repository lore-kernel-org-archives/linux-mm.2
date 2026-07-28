Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0833DC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87E66B0092; Tue, 28 Jul 2026 18:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38A26B0095; Tue, 28 Jul 2026 18:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A226B6B0093; Tue, 28 Jul 2026 18:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFC66B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEF9C804DE
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:24 +0000 (UTC)
X-FDA: 85039579968.22.9FD0D04
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0984620004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lQ9w8Ieo;
	spf=pass (imf13.hostedemail.com: domain of 3zShpaggKCB47G4NF46EAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--dmatlack.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3zShpaggKCB47G4NF46EAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276623;
	b=JYvXoqn1yjfm5FciMAknaPL//vwRQOr8g6eknq9gpY2OBNFTn4qZa8jhaGdWfd8xI+jD31
	eNQl/pvTy2oP70RaG7L3mlo33p69UyJM0i9iWLwg4LPqWfuf2HdRYAyY6ydqy4dtK6iHKX
	5UcfCwnR2+9g0fDltApiOp6qzUqP4Zg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lQ9w8Ieo;
	spf=pass (imf13.hostedemail.com: domain of 3zShpaggKCB47G4NF46EAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--dmatlack.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3zShpaggKCB47G4NF46EAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IFZ7hHCmEAhTMpIAgVSf+ohpXdMNRUSFFSOoBn1Gww=;
	b=jJvqctcLAO3nQoFElpMHbCR9H7RaXjiFAtqHtpWb2MW8qVkPZB99NvO+Y6fP9dmDDURxTr
	/qbiDmMD+l7j577EnhJYKtPd2vDbaJhOPha1pp+j9iUSIMV+Tm5+sat+R0lJm5lsfU+CNR
	I8mziF8soxXGBT6jUdRzAMv2rKCtxyg=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-847a00bcbd0so381227b3a.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276622; x=1785881422; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2IFZ7hHCmEAhTMpIAgVSf+ohpXdMNRUSFFSOoBn1Gww=;
        b=lQ9w8IeoW2LJGe4TLKx9Zw2TCngL+U1jB6JItDyZ25lQ+SkfWp3m4PPXDe96yLcS7n
         iXssw9Nmf942z87UzfPc8JLYSa3ffREp8fBnZBEEH9o2hh9B9A7yX/H0pazEs0JzqjhC
         IxqAB7SIYcz9PoGggk6Wao0rFKs/qW251uQoqS8BJVBmBLnluYe77xdXfxXNq28u+tAI
         DkrzQor0ziNn4AmnGjQf0b5dG34FKnnDjvE9NojZYPN76lg7UsVY+dtzO8xWZw7doNvn
         byLJ/gPh2cdMPY4p8q3SloJKQNFKA1JtCzBCabRg/1+VeNdu57Rf47mQfoBtG5wgFudF
         3PKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276622; x=1785881422;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2IFZ7hHCmEAhTMpIAgVSf+ohpXdMNRUSFFSOoBn1Gww=;
        b=B2gLOwSF+ic0pc8Zjyvlbw2QOdNQA6JkH5EEUYz9hFHQpI2tth9uiTeynhlDY0CAs8
         ozYgiIqJMPtBCyXikm6s1STsqn1CSnQyXqUhxbHjEUiQ5fSgctV/egl9WrYUah+V4vRe
         CVnCA9PlAue4Mw8JYstR31BaIFU9nEPSprIZZP/LEs90gA8dOZxdkFQoBw+yCDXp35TJ
         q8Pl0ynLngfns48zM1JjFlBj2MxGajvGZcia6zDwQmAQSaWJvlDpTRhK7uosQaGjmIPE
         NiiESqNj5qnuSItWjaiLyxVAvWD/fg3hP6eltT5fUjo450qAMaS04tQMtXBVA0/A/Cc8
         7sxw==
X-Forwarded-Encrypted: i=1; AHgh+RoKQUVYXpstByDOqeX2opm/jyC9nE1zfAz16ZckIKs2s92zinmDUFZUlPB90IFZSnyLMXbT25h1LA==@kvack.org
X-Gm-Message-State: AOJu0Yy95Z6TEDN+TFlT0Iu/og+gD7OAAlMfb0d+6PUZhMXNfhz3E3rs
	qvnZ96R18pR5qZs/YrXRYawwLQyb14nKKX3FTNaa2KuR2DXi/W2CnSFoM+0mSfnLXV2atCvg/pH
	8+JOsWjedPW5TlA==
X-Received: from pfbfa37.prod.google.com ([2002:a05:6a00:2d25:b0:847:84b8:2dcf])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:234b:b0:845:dffa:3740 with SMTP id d2e1a72fcca58-84e93192aacmr4259869b3a.4.1785276621414;
 Tue, 28 Jul 2026 15:10:21 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:09:55 +0000
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-2-dmatlack@google.com>
Subject: [PATCH v8 01/12] PCI: liveupdate: Set up FLB handler for the PCI core
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hjhos3t9jf4h1xyfns5jf7yzrwmewfgq
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0984620004
X-Rspam-User: 
X-HE-Tag: 1785276622-932867
X-HE-Meta: U2FsdGVkX19L9+mhjZ3zbgy8hCJLrQpqIz0bv1K5xjkhUMtK8gLyPyhL8ZPYQkcF2mCSKktmDdQIPwLj6KDAcpCs5F+HYBG158bRIE2w25Mt8p8dt5Yya9YxU9ZFf0ET9wgxvME4I5Bf6i5BARd63fmic5LbWF6vtUsi5QyUVfNi2VmKaLDjSqWzBnb3kd3TiJkBzMhzwXJNklSoURPNfJ14e8sTYHAYZuzwx4sH1QBjbtvRmM3LS/q1X7DOr0Jca7I6dJUKnilizEo41nhUf7XP7R0CZR43MbL1kZibFwgjMuftNtIUrVRUKYLBU41xE3ESdsTbTnge/44korxgo+hF/T7cK1+p7rzyd+IjFhb7GHIhnfkAS0vwVndL5NiFxLUIByrKl4GKYxrVlxeRU6pC3MhC4hhAxonZDpPqdclAOdCmq7VnrTUhKsq+5QOH8czAYgHXwmF+kOllESuS2pm/ujd7Lyhv4LeVnnLEvnqukpF7RfgRESP4cfmeEvE8tfuIC0hsSSgaulEbDiq3TEx5HZiwRKb4TheRXFLBk6D9CLYb8myc5rBWqS8UFqOlWqDgP32Xl+gU8vsCYu7kxiB88qiEb/vl4MtjHMg8F/6nMtBy9jyfGNZ1N/A05UgPIl+1qUr9PWcRJ2qjHbWHaFVvlIq3bOb7A+uiahkR1mTp5j09PTeNJJi0MHZJiu1/LWaVgXGjZyJhw8uQ+HTxhvI3sCyURwd6ceYecusp0jmZl/IfCksOyvkErreNMgj39Vkqko3IG6xuY51lg93Ww3Ogzh9mF6aJc4rSZl4bwz58J0a1F9HVg3rH3dU96kIb0eQznj5KrZSSSWWjWrkNdr6g8B3E7StCXdDp1+H5lGlcvamX1xay2MjUD2Oqx4l4oFKvHfvFJkuHWneSwZAx0ehSkrdZcphl1MTn958Vqduq2ei39buAapX7U/IWx8qTv79ct/PViLTl1GYGywf
 EY2PU6nQ
 5/LQILdRqW9Up2NK0T1rrCPkv12dfUJwwB023KR2HF+B2FzZimoAH9Bh7Ciy7pjrh3vyXRGdirs4Gi4pZvsAeMhYZ5Jhh46JTnENRWymA2e3LtoxkTkBcVihd8j8aDJE+pVpG1lNbP5g7WDpnZxTv8gd+2gM9U1TvV+35grRGEGChPMTlCliHP4ZxhE6Rol0XDzdU0Ezpm7PY5xbQEyMoJaLKNsaDK60xfwCRx8WHrIvDGrf+NHvxkY1+QWcq2uo0dtDnRWH0460qe23GvgjI6vBvRsXN0zPLY/Ve9uVWS2SQaNKYt1h3B1stVtXvjQ4XYO1XvXgFLe99XYs/K3cXnJd2S2WLFSB5A8Y4H6V+113I2HYmpMz9Dg9gzznbPp6e4PRPkaR8AYd5zpN8NTFlof3Gc1gKfzeP0RmNrz22atVdM/B3mU6cJoaKvz5BEc955PY+HJTzKAjcWQtKcLJHmUKiDzX+CjvWr3x+H9EPlzOkWjBvzqEgyysYePHhiOhnH5ru/vM6KI3dfIWhX5mmQmKBWKMWaZkJYctc0ojFRvK7cOJ0oE38ZD0/YUWBId3u61lW7oVQMAsquDZQiXDXyLLQ3JJRcDmiatWEy1F0XwzRnFPOn1/VLJ9cO/00mvqerukXyIPvHoMO7YwYvfmf3y3w2CXMZoJ2joKMpRfWwkwrgMyvQUIQRU3H0fPQ+N4/YFOO8kl1biJjpCkikSnhIs5X8zgcezvzNE6A1q0VFMrBKqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
it to participate in the preservation of PCI devices across Live Update.
Essentially, this commit enables the PCI core to allocate a struct
(struct pci_ser) and preserve it across a Live Update whenever at least
one device is preserved.

Preserving PCI devices across Live Update is built on top of the Live
Update Orchestrator's (LUO) support for file preservation. Drivers are
expected to expose a file to userspace to represent a single PCI device
and support preservation of that file. This is intended primarily to
support preservation of PCI devices bound to VFIO drivers.

This commit enables drivers to register their liveupdate_file_handler
with the PCI core so that the PCI core can do its own tracking and
enforcement of which devices are preserved.

  pci_liveupdate_register_flb(driver_file_handler);
  pci_liveupdate_unregister_flb(driver_file_handler);

When the first file (with a handler registered with the PCI core) is
preserved, the PCI core will be notified to allocate its tracking struct
(pci_ser). When the last file is unpreserved (i.e. preservation
cancelled) the PCI core will be notified to free struct pci_ser.

This struct is preserved across a Live Update using KHO and can be
fetched by the PCI core during early boot (e.g. during device
enumeration) so that it knows which devices were preserved.

Note: This commit only allocates struct pci_ser and preserves it across
Live Update. A subsequent commit will add an API for drivers to tell the
PCI core exactly which devices are being preserved.

Note: There is no reason to check for kho_is_enabled() since it can be
assumed to return true. If KHO was not enabled then Live Update would
not be enabled and these routines would never run.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/core-api/liveupdate.rst |   4 +
 MAINTAINERS                           |  13 +++
 drivers/pci/Kconfig                   |  15 +++
 drivers/pci/Makefile                  |   1 +
 drivers/pci/liveupdate.c              | 158 ++++++++++++++++++++++++++
 include/linux/kho/abi/pci.h           |  63 ++++++++++
 include/linux/pci.h                   |   1 +
 include/linux/pci_liveupdate.h        |  30 +++++
 8 files changed, 285 insertions(+)
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/pci_liveupdate.h

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 5a292d0f3706..b3c689e633c1 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -1,5 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
+.. _luo:
+
 ========================
 Live Update Orchestrator
 ========================
@@ -18,6 +20,8 @@ LUO Preserving File Descriptors
 .. kernel-doc:: kernel/liveupdate/luo_file.c
    :doc: LUO File Descriptors
 
+.. _flb:
+
 LUO File Lifecycle Bound Global Data
 ====================================
 .. kernel-doc:: kernel/liveupdate/luo_flb.c
diff --git a/MAINTAINERS b/MAINTAINERS
index a3ed337e827d..9cc7b9291ace 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20824,6 +20824,19 @@ L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	Documentation/PCI/pci-error-recovery.rst
 
+PCI LIVE UPDATE
+M:	David Matlack <dmatlack@google.com>
+R:	Pasha Tatashin <pasha.tatashin@soleen.com>
+R:	Mike Rapoport <rppt@kernel.org>
+R:	Pratyush Yadav <pratyush@kernel.org>
+L:	kexec@lists.infradead.org
+L:	linux-pci@vger.kernel.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	drivers/pci/liveupdate.c
+F:	include/linux/kho/abi/pci.h
+F:	include/linux/pci_liveupdate.h
+
 PCI MSI DRIVER FOR ALTERA MSI IP
 L:	linux-pci@vger.kernel.org
 S:	Orphan
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 0c7408509ba2..3781e2b5f095 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -271,6 +271,21 @@ config VGA_ARB_MAX_GPUS
 	  Reserves space in the kernel to maintain resource locking for
 	  multiple GPUS.  The overhead for each GPU is very small.
 
+config PCI_LIVEUPDATE
+	bool "PCI Live Update Support"
+	depends on PCI && LIVEUPDATE
+	help
+	  Enable PCI core support for preserving PCI devices across Live
+	  Update. This, in combination with support in a device's driver,
+	  enables PCI devices to run and perform memory transactions
+	  uninterrupted during a kexec for Live Update.
+
+	  This option should only be enabled by users who plan to use Live
+	  Update for kernel upgrades and require preserving PCI devices during
+	  those upgrades.
+
+	  If unsure, say N.
+
 source "drivers/pci/hotplug/Kconfig"
 source "drivers/pci/controller/Kconfig"
 source "drivers/pci/endpoint/Kconfig"
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 41ebc3b9a518..e8d003cb6757 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_PROC_FS)		+= proc.o
 obj-$(CONFIG_SYSFS)		+= pci-sysfs.o slot.o
 obj-$(CONFIG_ACPI)		+= pci-acpi.o
 obj-$(CONFIG_GENERIC_PCI_IOMAP) += iomap.o
+obj-$(CONFIG_PCI_LIVEUPDATE)	+= liveupdate.o
 endif
 
 obj-$(CONFIG_OF)		+= of.o
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
new file mode 100644
index 000000000000..fffb41a66ca7
--- /dev/null
+++ b/drivers/pci/liveupdate.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * David Matlack <dmatlack@google.com>
+ */
+
+/**
+ * DOC: PCI Live Update
+ *
+ * The PCI subsystem participates in the Live Update process to enable drivers
+ * to preserve their PCI devices across kexec.
+ *
+ * :ref:`FLB <flb>` Data
+ * =====================
+ *
+ * PCI device preservation across Live Update is built on top of the
+ * :ref:`LUO <luo>` support for file preservation across kexec. Drivers are
+ * expected to expose a file to represent a single PCI device and support
+ * preservation of that file with ``ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)``.
+ * This allows userspace to control the preservation of devices and ensure
+ * proper lifecycle management while a device is preserved. The first intended
+ * use-case is preserving vfio-pci device files.
+ *
+ * The PCI core maintains its own state about what devices are being preserved
+ * across Live Update using FLB data in LUO. Essentially, this allows the PCI
+ * core to allocate struct pci_ser when the first device (file) is preserved
+ * and free it when the last device (file) is unpreserved. After kexec, the
+ * PCI core can fetch the struct pci_ser (which was constructed by the previous
+ * kernel) from LUO at any time (e.g. during enumeration) so that it knows
+ * which devices were preserved.
+ *
+ * To enable the PCI core to be notified whenever a file representing a device
+ * is preserved, drivers must register their struct liveupdate_file_handler with
+ * the PCI core by using the following APIs:
+ *
+ *  * ``pci_liveupdate_register_flb(driver_file_handler)``
+ *  * ``pci_liveupdate_unregister_flb(driver_file_handler)``
+ */
+
+#define pr_fmt(fmt) "PCI: liveupdate: " fmt
+
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/pci.h>
+#include <linux/kho_block.h>
+#include <linux/liveupdate.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+
+/**
+ * struct pci_flb_outgoing - Outgoing PCI FLB object
+ * @ser: Pointer to the preserved struct pci_ser.
+ * @block_set: The KHO block set holding the outgoing devices.
+ *
+ * This structure holds the runtime state for the outgoing PCI Live Update
+ * state. It wraps the serialized pci_ser and the block_set used to manage
+ * the serialized entries.
+ */
+struct pci_flb_outgoing {
+	struct pci_ser *ser;
+	struct kho_block_set block_set;
+};
+
+static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
+{
+	struct pci_flb_outgoing *outgoing __free(kfree) = NULL;
+	struct pci_ser *ser;
+
+	outgoing = kzalloc_obj(*outgoing);
+	if (!outgoing)
+		return -ENOMEM;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	ser->version = PCI_LUO_FLB_VERSION;
+	ser->nr_devices = 0;
+	ser->devices = 0;
+
+	outgoing->ser = ser;
+	kho_block_set_init(&outgoing->block_set, sizeof(struct pci_dev_ser));
+
+	args->obj = no_free_ptr(outgoing);
+	args->data = virt_to_phys(ser);
+	pr_debug("Preserved struct pci_ser (0x%llx)\n", args->data);
+	return 0;
+}
+
+static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
+{
+	struct pci_flb_outgoing *outgoing = args->obj;
+
+	pr_debug("Unpreserving struct pci_ser (0x%llx)\n", args->data);
+
+	WARN_ON(outgoing->ser->nr_devices);
+	kho_block_set_destroy(&outgoing->block_set);
+	kho_unpreserve_free(outgoing->ser);
+	kfree(outgoing);
+}
+
+static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
+{
+	pr_debug("Retrieving struct pci_ser (0x%llx)\n", args->data);
+	args->obj = phys_to_virt(args->data);
+	return 0;
+}
+
+static void pci_flb_finish(struct liveupdate_flb_op_args *args)
+{
+	pr_debug("Finished struct pci_ser (0x%llx)\n", args->data);
+	kho_restore_free(args->obj);
+}
+
+static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
+	.preserve = pci_flb_preserve,
+	.unpreserve = pci_flb_unpreserve,
+	.retrieve = pci_flb_retrieve,
+	.finish = pci_flb_finish,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_flb pci_liveupdate_flb = {
+	.ops = &pci_liveupdate_flb_ops,
+	.compatible = PCI_LUO_FLB_COMPATIBLE,
+};
+
+/**
+ * pci_liveupdate_register_flb() - Register a file handler with the PCI core
+ * @fh: The file handler to register.
+ *
+ * Drivers should call pci_liveupdate_register_flb() to register their
+ * struct liveupdate_file_handler with the PCI core. This enables the PCI core
+ * to allocate its outgoing struct pci_ser whenever the first device is
+ * preserved, and free it when the last device is unpreserved.
+ *
+ * Return: 0 on success, <0 on failure.
+ */
+int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
+{
+	pr_debug("Registering file handler \"%s\"\n", fh->compatible);
+	return liveupdate_register_flb(fh, &pci_liveupdate_flb);
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
+
+/**
+ * pci_liveupdate_unregister_flb() - Unregister a file handler with the PCI core
+ * @fh: The file handler to unregister.
+ */
+void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
+{
+	pr_debug("Unregistering file handler \"%s\"\n", fh->compatible);
+	liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
new file mode 100644
index 000000000000..d4881c2d2fc9
--- /dev/null
+++ b/include/linux/kho/abi/pci.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * David Matlack <dmatlack@google.com>
+ */
+
+#ifndef _LINUX_KHO_ABI_PCI_H
+#define _LINUX_KHO_ABI_PCI_H
+
+#include <linux/bug.h>
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/**
+ * DOC: PCI File-Lifecycle Bound (FLB) Live Update ABI
+ *
+ * This header defines the ABI for preserving core PCI state across kexec using
+ * Live Update File-Lifecycle Bound (FLB) data.
+ *
+ * This interface is a contract. Any modification to any of the serialization
+ * structs defined here constitutes a breaking change. Such changes require
+ * incrementing the version number in the PCI_LUO_FLB_VERSION number.
+ */
+
+#define PCI_LUO_FLB_COMPATIBLE "pci"
+#define PCI_LUO_FLB_VERSION 1
+
+/**
+ * struct pci_dev_ser - Serialized state about a single PCI device.
+ *
+ * @domain: The device's PCI domain number (segment).
+ * @bdf: The device's PCI bus, device, and function number.
+ * @refcount: Reference count used by the PCI core to keep track of whether it
+ *            is done using a device's struct pci_dev_ser. The value of the
+ *            refcount is equal to 1 when the struct pci_dev_ser is in use, and
+ *            0 otherwise.
+ */
+struct pci_dev_ser {
+	u32 domain;
+	u16 bdf;
+	u16 refcount;
+} __packed;
+
+/**
+ * struct pci_ser - PCI Subsystem Live Update State
+ *
+ * This struct tracks state about all devices that are being preserved across
+ * a Live Update for the next kernel.
+ *
+ * @version: The version of the "pci" FLB struct. This field must never be
+ *           deleted, moved, or resized, as the kernel depends on always being
+ *           able to check the struct pci_ser version number.
+ * @nr_devices: The number of devices that were preserved.
+ * @devices: Physical address of the first KHO block containing pci_dev_ser.
+ */
+struct pci_ser {
+	u32 version;
+	u32 nr_devices;
+	u64 devices;
+} __packed;
+
+#endif /* _LINUX_KHO_ABI_PCI_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ebb5b9d76360..da58aa101e4c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -43,6 +43,7 @@
 #include <uapi/linux/pci.h>
 
 #include <linux/pci_ids.h>
+#include <linux/pci_liveupdate.h>
 
 #define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY  | \
 			       PCI_STATUS_SIG_SYSTEM_ERROR | \
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
new file mode 100644
index 000000000000..8ec98beefcb4
--- /dev/null
+++ b/include/linux/pci_liveupdate.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * PCI Live Update support (Public/Driver API)
+ *
+ * Copyright (c) 2026, Google LLC.
+ * David Matlack <dmatlack@google.com>
+ */
+#ifndef LINUX_PCI_LIVEUPDATE_H
+#define LINUX_PCI_LIVEUPDATE_H
+
+#include <linux/liveupdate.h>
+#include <linux/types.h>
+
+struct pci_dev;
+
+#ifdef CONFIG_PCI_LIVEUPDATE
+int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
+void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
+#else
+static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
+{
+}
+#endif
+
+#endif /* LINUX_PCI_LIVEUPDATE_H */
-- 
2.55.0.487.gaf234c4eb3-goog


