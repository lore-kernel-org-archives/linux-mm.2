Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6611FC4450A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551A36B00B4; Fri, 10 Jul 2026 17:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529B46B00B5; Fri, 10 Jul 2026 17:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CABF6B00B6; Fri, 10 Jul 2026 17:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E753B6B00B4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 448C71C8B4E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:27 +0000 (UTC)
X-FDA: 84974150814.24.E9946CA
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8B55C14000C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=THoh8r56;
	spf=pass (imf09.hostedemail.com: domain of 3f2NRaggKCOQJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3f2NRaggKCOQJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718785;
	b=zHPBJA+9ePZnIjGCC7zcftY6k4WmUpgHsrs0ehY6ub9ikkJSccpQ9NAO1v7foNB0K2A9WR
	uEWtZ8Qof4xzuTf7H6iUwjQPOSc+AZFpDrFkrQd+6Wv+fsIH88EFx3yw+o0Zd3k59JtJxk
	7pRrVwgBN1uvbjhaOaZu3LwIJUZrKCo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=THoh8r56;
	spf=pass (imf09.hostedemail.com: domain of 3f2NRaggKCOQJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3f2NRaggKCOQJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJNVxjvVmYROzvILHkxiv/3zu6J6S8o6lQRGVaWTNbg=;
	b=RnyaHrDTy/o37s0CHSMun1L2pniAFG81jhocJcmNWz+sfsbmLyk4EXzZbz7T7xeam+kTHO
	xSp3ltXoCDrvugmHzHeeI2ys0FGRPAe2KBOryQ7IQ9XCUD4hfXd96Uovf2Kll82uQXWJ5n
	IIVKbQhhaJFcgOGWo8ehnolDMHRq7kg=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c88aab7c1fcso2551742a12.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718784; x=1784323584; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nJNVxjvVmYROzvILHkxiv/3zu6J6S8o6lQRGVaWTNbg=;
        b=THoh8r56fntktC52goA7reTFt9QN6HciA3St0u4q95LA/vRGN704fTnWHjBzU4TcwH
         VdLeHpJZwR0ijQ228nf5fu6p6fPtQ8GGdlvt+4Fwy/5DVgIq8x8PkarJSFQD2fwV4rR3
         bkmq+RhNOMxAWCHKqDFNuiCHP77IRRCY2BWzsSvGSt6ko7z+w85AudtHkYZysEwP7W0x
         lP1wTGhDt0WV1QFKEPbv5HkKWjQL7poCnnd/qUDV9pOTTLPKHY5U7C/9ShyvNXLQ0zNg
         1+5sWmxqwCbzNSBBLiBORH+zoexOdlV7ilA1Bt7BmyrEzRlQQ7SgvflWgRTdl55tq6oT
         idhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718784; x=1784323584;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nJNVxjvVmYROzvILHkxiv/3zu6J6S8o6lQRGVaWTNbg=;
        b=kwZm0ffu37d0kxRRbh7Crf5TTuFHRNUofnkKyAFpnVMORxsw+2jAMlToBp4SHwEqHH
         K5LOyOOfc5ibN74vqkMkEXJmdhf62w7GrjN3vaSJ14tuWsAEqWv18UY+E151d5l3mls2
         Jz+taqrwREmsRqxZEZxeNBxsTZLlSK3+ITIb3jXrU1dAGFVawUuyFrbZc1J+CD0N25f0
         IehL/dIpCPr4brTEf5qJfiWH68zMg1QaBSleo1iXcFku7O1oZC3oYNEaqDRFcRd5DMQP
         aPP2SAXSVnsAWPr1/1EAR1KcMo1k8q013nKN2k7kOYLJYxqikOZDZ4CHo9KBDd7UNfUq
         1sQg==
X-Forwarded-Encrypted: i=1; AHgh+RpLnlsFUIjrC8b4rJDVH4+Jfdq9ZMWS4qI91QcAgYJ2Hjmeovfbmr4DWJqzqJzz4sDzWhuiu1+E0g==@kvack.org
X-Gm-Message-State: AOJu0YzeqWF+iBXsQ/4IAy+ZaB1V39Nybd2s2NIy4nDJn9gWF/eA8yhS
	KNoWXN0aQdDgxhzw3WYoYS3XCstP+rHXj5Xu5R5YOxB3/Mhoj7B2r60oYF3qhVwxBx48gmBEot2
	12HeTbPP0DphnrQ==
X-Received: from pfbln8.prod.google.com ([2002:a05:6a00:3cc8:b0:848:48a0:41e6])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:179b:b0:848:30fe:da34 with SMTP id d2e1a72fcca58-8488974b074mr589334b3a.45.1783718783985;
 Fri, 10 Jul 2026 14:26:23 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:04 +0000
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-2-dmatlack@google.com>
Subject: [PATCH v7 01/12] PCI: liveupdate: Set up FLB handler for the PCI core
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8B55C14000C
X-Stat-Signature: c7fgg6jb9j5ssndz4o1qg35m58qe7ut6
X-HE-Tag: 1783718785-640633
X-HE-Meta: U2FsdGVkX18zCX1Z7y246sk5/1ro+VIUPLYCbJcHIhCthNus+Sorsc/Z1s8K7ls5kTBHlRdLPRS+VgB/4Z7L5VQ7rNZ357iXoUYYbgx3rtAYDMW66B6M/R/+m2jK/DdUmb2L+Phf830+peVwbMQWeKIxBwwDz+/28IldyhJxnK+T8YXfnsT/umIhfsIYEK7y4Jpw+0f7F+hLPJqxKcht4TYh1GOP7PQnUNarnLP9kGoWQQp6sSPG9cguo5BdpNGe1fuPi3LO0tPXvw5SWssE26/mUrQuNPuUZgMchm9E4aIWnhSC4eLk+7XloOBVUs7q8aYNjLKAaCaCXyrM5zoM+CiN4w6xr/FZw/1tre9rvILEA/qy/atN/PyyewXs9wzvR9sVW+I4yS2P0fuR246lAEIrzyFBChTBOaF33QenwYOXXu7fl04YSTdpc2c7pwclRFpdQ3iQ3XLHZ+CYyFSNr8LFBWWjOhTcy99NzrjDismLS8FrmwWArL7gIX5GVY0qye1EMUb/K6fnmRBfsQmmGyKzKoe39a1FJ+SbbAQ8sIRrh7NuAQa6ybim1pMxIGHcVDnxwFQwqixPPX0iL25wDcGkQ+vG6NxIBmBkuBujH+cHeLqgAusVTurx3ohoMwcMgZNLflD/XrZPBZeYQ57krybzr+sn0XwPdytI5Pxa+wlJq5IlXqn67zquBHHokdMu5QmVxH/BM2jZjUlj7G7GBk89C4YFPoPL9aiHfdMozfNlGNPzXQeXWTaPKk316VATSse7Ak6vMm6DgY7xF9wIuG5qmMBFjoGT8icb8x2yIklouqTqECoQQbD3VEubAta4i/XFhLniVF/3pFTQj6qPE4rjtTX++LobBbCtKHAHLUbmJURv6YjRY9H8v6hfQi0dXg7mVgJykNmkUM5EWlioSl9hKXGhjP1z2bhwEl0EFwuErOLyysTF5WcF1/3CxWXlUvrlQLySv5qmExvuuON
 VLi2geRD
 DdUB5h7FpZp/347zbQzkuzVQPJp88Fj9vDnsVkgubW31S4OhN9FFVVhZ5iUbIwFYtWgyfrDipiYgaFleRQMo98ejhEN1ltPPaEdA31ZZXiFJz2M0yh4RURL0PXojaU6BTe2vt7CzDPXiiiTp1mdPKUsn6H7Lw90S2nJRbxAT/6JXDtcTcRZPbTRKvLDJtYvjJ81qeOgt3bnwNBICjaaYRvbjTz9WvQffG8BPnjFTyGsXzzuE1bKuzmKc+3eHckzPc5y4GHYHTgqbqp5kXCiN9uw3Q3z6/BCDZDOk5szQQ1cePeFuQqH21kKGf8054oyi4UojipKMyPkWL4ZnY47pc0A470iw6pgDaCl0Sbcu7Yf+bZmpvmRj9zIRBvQXK4OwJcQH/3GNe0e0YOcd4hyAyvh8URyeYGvEuCERfHJ5DBy1rxleCk5MVX7Ppmotus0Dyui5JiEyFfFYbl4aFfmvEdWpkg4ce41LZjFtsURFO+YzmRcDNLv+1gA8fK5rdWfliO0yNcfPMwRkLZvx9u7thO9ZVeyTHLk3FZTxU6O2FKbXEhPxH30hqsTHXLNoDBOY+eoH0W+EEUru+9+qq9evNM3FgG3+84ygbqtSspIpY0QbkZ0pKXcyzWVsBx8t5F05Z2nGr2Jg7IB80fADZbwIHelCOW3P4BlLFgThOHU8MYfwO/xd4Zn41Te32XfImDcw2laupo9I73IWYO+jFW8hPbRT828DKHAjKzhWWjFMq2sdaUxI=
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
 drivers/pci/liveupdate.c              | 155 ++++++++++++++++++++++++++
 include/linux/kho/abi/pci.h           |  58 ++++++++++
 include/linux/pci.h                   |   1 +
 include/linux/pci_liveupdate.h        |  30 +++++
 8 files changed, 277 insertions(+)
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
index 000000000000..899758883dd5
--- /dev/null
+++ b/drivers/pci/liveupdate.c
@@ -0,0 +1,155 @@
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
+#define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
+
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/pci.h>
+#include <linux/liveupdate.h>
+#include <linux/mm.h>
+#include <linux/kho_block.h>
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
+	struct pci_flb_outgoing *outgoing;
+	struct pci_ser *ser;
+
+	outgoing = kzalloc_obj(*outgoing);
+	if (!outgoing)
+		return -ENOMEM;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser)) {
+		kfree(outgoing);
+		return PTR_ERR(ser);
+	}
+
+	ser->nr_devices = 0;
+	ser->devices = 0;
+
+	outgoing->ser = ser;
+	kho_block_set_init(&outgoing->block_set, sizeof(struct pci_dev_ser));
+
+	args->obj = outgoing;
+	args->data = virt_to_phys(ser);
+	return 0;
+}
+
+static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
+{
+	struct pci_flb_outgoing *outgoing = args->obj;
+
+	WARN_ON(outgoing->ser->nr_devices);
+	kho_block_set_destroy(&outgoing->block_set);
+	kho_unpreserve_free(outgoing->ser);
+	kfree(outgoing);
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
index 000000000000..de549016807a
--- /dev/null
+++ b/include/linux/kho/abi/pci.h
@@ -0,0 +1,58 @@
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
+ * @nr_devices: The number of devices that were preserved.
+ * @devices: Physical address of the first KHO block containing pci_dev_ser.
+ */
+struct pci_ser {
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
2.55.0.795.g602f6c329a-goog


