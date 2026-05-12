Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD760CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 920406B008A; Tue, 12 May 2026 14:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B366B008C; Tue, 12 May 2026 14:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771F96B0092; Tue, 12 May 2026 14:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 598606B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:48:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 045488D0DA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:54 +0000 (UTC)
X-FDA: 84759654630.25.16181AA
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3ABA540005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iihbI9nk;
	spf=pass (imf12.hostedemail.com: domain of 3E3YDaggKCGQFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3E3YDaggKCGQFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dy/EdvVTTBqiefKlS8WatpbG3+QoYAqM6EFKsrFApM0=;
	b=FbdwN6b8wZllz8Q5rjHvl3s9vcod4zxC6e1lsZQVm2F5Tf3PcR7T6vAO0d43rLb/HdnkKb
	1GEUbHisIjHxXU9IPYU/HK5l4hF4iv8QKFIbd8pDEROlC2yl9aL4m7re2C7WgCUFvjVi6O
	dSgq06LdFQzGC9Wzd8bCz6s0nQfdeMs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iihbI9nk;
	spf=pass (imf12.hostedemail.com: domain of 3E3YDaggKCGQFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3E3YDaggKCGQFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611733; a=rsa-sha256;
	cv=none;
	b=xrTNpOkqIYqWoJ817/zzy675qeARgfIZ7hxQPT3iCQB43n5AWKUL8IrbQTfovxzZssBxZ8
	lAv2lIlR8C7Z+vRp/qyu2ikgQPMH6nyxU8zENgJinlOhe6kPCc75mVXm69PClXWm3h9G+I
	MsIGdDpYCRQ2HOtBpYV60/vTsfomG38=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82f6a5b4f88so7387735b3a.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611732; x=1779216532; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dy/EdvVTTBqiefKlS8WatpbG3+QoYAqM6EFKsrFApM0=;
        b=iihbI9nkVcOF/uxgFiODfISUPxfNoCg8BNd6lsLepSmCz3ICTKGAV9EojSh72GsNmv
         5a42uFtme3Vbgok7DpJm2yY5K1zyG0eix3QqQH4kLGwTwZAKqK/Yhdlz7X2Y9YXNRfb/
         LRV6ICte9c5uho72uMeF2bnHa5ZGIcXH+kdCJKKX0XW2N+qDVgCwbBhgV1ZwQac+x03o
         lMFvjlq51J59/VVK0Vp7tHZH1S7E+2JlqEgppUOXma/qpqcVO4c3L6t9DMqNXlYl/x8c
         Sa9EZn42KROopX82LFas7JYUfKGCiFopTI6mCIWn3X9+ySc/y36urKhzy7+aDhqDHolp
         wn4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611732; x=1779216532;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dy/EdvVTTBqiefKlS8WatpbG3+QoYAqM6EFKsrFApM0=;
        b=XG4nsPYBNDVKDb0Jb/0z6sScJdvGx80V/2/28WqfR72IzQGvphZFDS461BXsiZ0cRC
         CRUJAgQskJ9Jhxy0VJ8S727FyolfPag7je7R6/nwP40i+QzwVvSGIeoIgrsVhMAJJg44
         g1B5rUTPMsr7aeWOe2k/wf2XqKyEdt/b7+Id4Yn58b+PzLUoRjLfo9Fcq+8vkE9P4ses
         gikSQEWRmWVmoMyJz8Cbt2kRm0vdNKecNrjr8uSXGfF6uvBPy9A/1X8m0auVUNDW5nk/
         bX5PCOk5NkPuAEfy6SFDLn6ZG5PY+ZoRFXRCksIMzjZsHzM0RwZGqW/vrtp7qasU3wG3
         ixJw==
X-Forwarded-Encrypted: i=1; AFNElJ/tGDLmy81ep40WILJr0AScAFuWgvl8YjkKhcif33rXacoRbxPjuM90XjiF0ecOgSFd0GLkbXpBCg==@kvack.org
X-Gm-Message-State: AOJu0Yx4EwyggngXHFgHwzDyFO+O71e/XJ78Tw524ecITSQisGRfF5SW
	Id3GGxprCT4PZ0h6bCUndsVhpnEK2BdyonSfN/h5nZcas5+ueMoBx8HP4jc51qayE9JCsamFJwG
	iQqCdHp2eR6AyHg==
X-Received: from pfblr27.prod.google.com ([2002:a05:6a00:739b:b0:82f:7220:86e7])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3689:b0:82a:6ef8:cb43 with SMTP id d2e1a72fcca58-83eebb5ee0cmr4631546b3a.19.1778611731916;
 Tue, 12 May 2026 11:48:51 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:36 +0000
In-Reply-To: <20260512184846.119396-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260512184846.119396-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-2-dmatlack@google.com>
Subject: [PATCH v5 01/11] PCI: liveupdate: Set up FLB handler for the PCI core
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3ABA540005
X-Stat-Signature: oywdzznx3uzix71eizoiyt9fntke965q
X-HE-Tag: 1778611733-865162
X-HE-Meta: U2FsdGVkX18XqukFT8MqkeLOnsnhp5EXFTn1uoSjLMRsaPKqQLPDjXoE8OaXctyiFyjo2Gx4ahvnxnA0RqSjTKBJhE5DidcE+PczK5uQrclynvzkTz8kv064Om7n3n3eE44guy+nhwAYFSE9wsS4LoHGEErBhhAcWAyIDglDDSSLqFcdEFRMyb+1DIkKta0D9t8xIjwaAqseH3gO/KiuU8Bikh4uTjnqfK6sxwRO729QTKpm09tQytq0DW2mxW9/SGHitXog+pMOwpKGRsgJAvGgZLDWvmxrrjFoeKrNuUIFJSB8uSDyWxFXlRxvpaXdIe2eajaKkXsI0bqelzWHI6yC49RJPgpchgaC0rZh9UnOtckfJz5oEJTAQRbhLmMiuzpyT2IxolTIRTGdAfX7JbPdirhVFK49zbls936+3OwjhsW1cpXWHNfPrg+2f8g9iJihlQnB1q7TzW9Cj2kPY99V1J8Ob+YQeEgEtPCaWx6vfQRZ6l8tXBxWtLYT2QmB1WbDFIoMl0eGA7mS3jBgT93j6SHRpBKxeCqtAB4kOFcR6JMhV/8xGjGt45WsYYsb0ReKL3LMgqByunZlNH8I6Dkh02cbO0jzbGusaA3zDL5jQLPdqG+uOhiHff7U0ZGrHns+yTrz9U7lx7PuBYdEpG9ch3vj16Q1/JoUu3uXcRfHyHaet149eJKWieJzh4lj87tzECNxmcV7X1FgJjqleNd9Q6h91Si9/RRB8gZmrAK791zHJiZzXvw7SAJzop34noM987VqUoBPxp+cPkGPnaE9wu/BcGmNyyf1H+Y4bZ3albNzew1dt/MaYrYYj7nHUW3YtLMHeHNxsjzY10Ku3iEn8aQfxS7OB3irw35uUXDl9q7wZyQDbZYGXNlpwBdionUWPnVERz1EjzIymJTDXZOf/a1BUzItjh+nA3DctS2a9BU1TtblS/Tqu7COq4TqutdQ5x8vmo/a8ys71So
 wMQNj+Re
 tlt27IDu7rYjM13m70zGQuFbUyasNf4oqVUCHPAgIW3mzizZtkfNDXVQ3SCTZPzIWD/vKWSgIW53FYo+nIT7FOy68rqo6BPpBnEr+CLz8Lbi0VYVER86ifwCAUiMRSwfheMUrQxgYGhzveALuwKZuhu/gJDEh77V47+ccEU0QOsNuAodzwzAaD95Xr8GKHS0h9ER7iY43YN5rVx6bsYRJOZcQr/pa3EEZloRZEFec7hwqKAXulaeUU1IH/K49X9XrnqdamisgKN7zuBPvQpl8nmwmYsoApfM8OaVvWAfmE6FSgIU7yaP5LXVtL0NqVglwrH8GL47cvPArhpybfeIbsmc6r7W9ptYttw3herQj3tgH2VQBYMd4BeX8pHG5CmeuSUmmN3bh5GIxC023LuszRHjRq7zRji3QjPQB7BU8XiH2Wqd66evusxNKX0L25ESYJ3mXunLU+0rA0c2v/31Fk23NrqRj6p7QmmpI9zaXEcF4LdBpuI8U0xchNi0RfC1nkrf7YfSVqAqDQNk82R/Hlr4aSW0H2T8X6X4W6cw6dxIKYehKZUqbG/7DgUTHpZdJtgSKsQQxgS1BfEGrTYNoMxY+Whdgnz2Kn21UoV2LD6unzjhaWSe8mYEP9aEt07e5UtuT2aGes0pNv7g=
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

Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                    |  10 +++
 drivers/pci/Kconfig            |  14 +++
 drivers/pci/Makefile           |   1 +
 drivers/pci/liveupdate.c       | 153 +++++++++++++++++++++++++++++++++
 include/linux/kho/abi/pci.h    |  61 +++++++++++++
 include/linux/pci.h            |   1 +
 include/linux/pci_liveupdate.h |  30 +++++++
 7 files changed, 270 insertions(+)
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/pci_liveupdate.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 2fb1c75afd16..6c618830cf61 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20530,6 +20530,16 @@ L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	Documentation/PCI/pci-error-recovery.rst
 
+PCI LIVE UPDATE
+M:	David Matlack <dmatlack@google.com>
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
index 33c88432b728..08398cbe970c 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -328,6 +328,20 @@ config VGA_ARB_MAX_GPUS
 	  Reserves space in the kernel to maintain resource locking for
 	  multiple GPUS.  The overhead for each GPU is very small.
 
+config PCI_LIVEUPDATE
+	bool "PCI Live Update Support (EXPERIMENTAL)"
+	depends on PCI && LIVEUPDATE
+	help
+	  Enable PCI core support for preserving PCI devices across Live
+	  Update. This, in combination with support in a device's driver,
+	  enables PCI devices to run and perform memory transactions
+	  uninterrupted during a kexec for Live Update.
+
+	  This option should only be enabled by developers working on
+	  implementing this support.
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
index 000000000000..dd2449e12b6d
--- /dev/null
+++ b/drivers/pci/liveupdate.c
@@ -0,0 +1,153 @@
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
+ * .. note::
+ *    The support for preserving PCI devices across Live Update is currently
+ *    *partial* and should be considered *experimental*. It should only be
+ *    used by developers working on the implementation for the time being.
+ *
+ *    To enable the support, enable ``CONFIG_PCI_LIVEUPDATE``.
+ *
+ * File-Lifecycle-Bound (FLB) Data
+ * ===============================
+ *
+ * PCI device preservation across Live Update is built on top of the Live Update
+ * Orchestrator's (LUO) support for file preservation across kexec. Drivers
+ * are expected to expose a file to represent a single PCI device and support
+ * preservation of that file with ``ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)``.
+ * This allows userspace to control the preservation of devices and ensure
+ * proper lifecycle management while a device is preserved. The first intended
+ * use-case is preserving vfio-pci device files.
+ *
+ * The PCI core maintains its own state about what devices are being preserved
+ * across Live Update using a feature called File-Lifecycle-Bound (FLB) data in
+ * LUO.  Essentially, this allows the PCI core to allocate struct pci_ser when
+ * the first device (file) is preserved and free it when the last device (file)
+ * is unpreserved. After kexec, the PCI core can fetch the struct pci_ser (which
+ * was constructed by the previous kernel) from LUO at any time (e.g. during
+ * enumeration) so that it knows which devices were preserved.
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
+#include <linux/liveupdate.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/pci.h>
+
+static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
+{
+	struct pci_dev *dev = NULL;
+	u32 max_nr_devices = 0;
+	struct pci_ser *ser;
+	unsigned long size;
+
+	/*
+	 * Allocate enough space to preserve all of the devices that are
+	 * currently present on the system. Extra padding can be added to this
+	 * in the future to increase the chances that there is enough room to
+	 * preserve devices that are not yet present on the system (e.g. VFs,
+	 * hot-plugged devices).
+	 */
+	for_each_pci_dev(dev)
+		max_nr_devices++;
+
+	size = struct_size_t(struct pci_ser, devices, max_nr_devices);
+
+	ser = kho_alloc_preserve(size);
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	pr_debug("Preserved struct pci_ser with room for %u devices\n",
+		 max_nr_devices);
+
+	ser->max_nr_devices = max_nr_devices;
+	ser->nr_devices = 0;
+
+	args->obj = ser;
+	args->data = virt_to_phys(ser);
+	return 0;
+}
+
+static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
+{
+	struct pci_ser *ser = args->obj;
+
+	WARN_ON_ONCE(ser->nr_devices);
+	kho_unpreserve_free(ser);
+
+	pr_debug("Unpreserved struct pci_ser\n");
+}
+
+static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
+{
+	args->obj = phys_to_virt(args->data);
+	return 0;
+}
+
+static void pci_flb_finish(struct liveupdate_flb_op_args *args)
+{
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
index 000000000000..6ebcf817fff4
--- /dev/null
+++ b/include/linux/kho/abi/pci.h
@@ -0,0 +1,61 @@
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
+ * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
+ */
+
+#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
+
+/**
+ * struct pci_dev_ser - Serialized state about a single PCI device.
+ *
+ * @domain: The device's PCI domain number (segment).
+ * @bdf: The device's PCI bus, device, and function number.
+ * @padding: Padding to naturally align struct pci_dev_ser.
+ */
+struct pci_dev_ser {
+	u32 domain;
+	u16 bdf;
+	u16 padding;
+} __packed;
+
+/**
+ * struct pci_ser - PCI Subsystem Live Update State
+ *
+ * This struct tracks state about all devices that are being preserved across
+ * a Live Update for the next kernel.
+ *
+ * @max_nr_devices: The length of the devices[] flexible array.
+ * @nr_devices: The number of devices that were preserved.
+ * @devices: Flexible array of pci_dev_ser structs for each device.
+ */
+struct pci_ser {
+	u32 max_nr_devices;
+	u32 nr_devices;
+	struct pci_dev_ser devices[];
+} __packed;
+
+/* Ensure all elements of devices[] are naturally aligned. */
+static_assert(offsetof(struct pci_ser, devices) % sizeof(unsigned long) == 0);
+static_assert(sizeof(struct pci_dev_ser) % sizeof(unsigned long) == 0);
+
+#endif /* _LINUX_KHO_ABI_PCI_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2c4454583c11..8cadeeab86fd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -42,6 +42,7 @@
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
2.54.0.563.g4f69b47b94-goog


