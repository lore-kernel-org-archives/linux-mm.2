Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99373F532C0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BFF46B0096; Mon, 23 Mar 2026 19:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772EB6B0099; Mon, 23 Mar 2026 19:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A576B009B; Mon, 23 Mar 2026 19:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A39C6B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:58:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F32675CEB8
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:43 +0000 (UTC)
X-FDA: 84578995326.18.478831A
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2D6F0100003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p4jegmEs;
	spf=pass (imf14.hostedemail.com: domain of 3sNPBaQgKCLMWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3sNPBaQgKCLMWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXuqbjp18TTblR4dtTQV0wcbuwX6U0fGWW/v6G8ddek=;
	b=RbO2VTTgA32w/0vdpBb2Xs97+nFlZmBV4XViJkkKpL6T2Aq4/e4q6HHmNfzpSqn4HaJc/N
	rOi6nhFfMOrByklE/ZYQWTl75LcR3Ro94DACvRTR9d9BbeH69vfOYmOjKRHhO+g98r6sNA
	xfyDoBmnwBzx/vdq+a+TwwAoyD6v5Yk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p4jegmEs;
	spf=pass (imf14.hostedemail.com: domain of 3sNPBaQgKCLMWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3sNPBaQgKCLMWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310322; a=rsa-sha256;
	cv=none;
	b=imGNKJBMSDN+yxX+szESqaa7dPxYRhVkgwoyIQxFDw4NTEi3zHjIVXlWn+Y3a7B4A6pp1p
	SmBQU9IPK3rIaF/5Dfu8bGQUOExFcXJUxXJiCh5hOtUW7/q3AhgJ8fczOErGZKC24cZKjY
	8OjhIa+fso99zO+FYLKxi4EqD9qA7IY=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b060c14ccbso100054465ad.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310321; x=1774915121; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uXuqbjp18TTblR4dtTQV0wcbuwX6U0fGWW/v6G8ddek=;
        b=p4jegmEsuzhTiidhlLGZ4XTooyGxn/Q8L3ZogXoJ4gaKVfUE2UUQFC1JhuDyd+Fvs1
         +PdnOoPE4uCmPPWAbgv15mCB2glCpAVK7L4KFNxoZ5+OYn6uZB8W4wsZ/Ze/fyGb2ctq
         LHia2DFHGPA9YHHoLxaC/8nzwSchgBa2gxH9TTrWApyCjE3b6mgRgZGLLPftCD0udY/r
         2Bt/bHHueZa1i2qBVEFwMPUwluSJj10zPrOLEyAqA7dVL3lvmE3mKsH07T1CSZLbfls5
         pYXNEsiop4hr02U1qdITImqurGbRuLUL3AKF1UBHdwt/Pbh/R3CmcGwLMA1E8qoUtJN9
         Rb4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310321; x=1774915121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uXuqbjp18TTblR4dtTQV0wcbuwX6U0fGWW/v6G8ddek=;
        b=WrwGOUilGcaG8vPRuuI0c7y+4qRcBxcT05uiTEM2Ds3xSvRzO0CHBQsLK/U6Mu/0Rf
         E4bTYrWWCTCtvjLLzv+IW6zpNoPZo1PY4tfz4tIz3+3d5/WjMWqJr75R3heQo4t0lem9
         Nfy+uGCbav2U70MbBVGSbh5FYq5XHpIRLs0YoQsGGtxe9Yc2I/CEZ3SuYgkHC3q89rKa
         5sHwHO2jjJHL3tMK7AFVG66nlYLmFUXJKIks4f8sNF5JCn1cT2j6R2tjwvzblM1viNwu
         U25GJZpsEOTLIjo0fYxfX/V8tfkA7zsRJYdxyD6ggHZKveM5feNe4JRvunAMJq7wjZgM
         /8MQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3s1VU2DfSjUqWDo8q38CaWZQWXCQpOCgkgURzZw75GG/Sboxmc7FNvKyM6rX9/rN0zKIIyJ3GzA==@kvack.org
X-Gm-Message-State: AOJu0YzY1nQ7+4Qvc4sAU3kOjszkQphXVwCCmTyXBRT4GFR2VTSMS0Eo
	ljJS574HOX5HLaZOwRHuQz9gRF9Y1hZWlHQcwu5y3jrwXNKdXua+M5VG9qmWvlwqTcWqQH9s8jT
	1tcIz1GpSvCz/4w==
X-Received: from pleo1.prod.google.com ([2002:a17:903:2101:b0:2b0:5a4b:5d45])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3890:b0:2b0:6638:b357 with SMTP id d9443c01a7336-2b0826c751dmr140143485ad.11.1774310320820;
 Mon, 23 Mar 2026 16:58:40 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:57:54 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-3-dmatlack@google.com>
Subject: [PATCH v3 02/24] PCI: Add API to track PCI devices preserved across
 Live Update
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
X-Rspamd-Queue-Id: 2D6F0100003
X-Stat-Signature: 7grf3nyjuboxau7sf85ngepe54ghy3hj
X-Rspamd-Server: rspam06
X-HE-Tag: 1774310321-463592
X-HE-Meta: U2FsdGVkX188g9dAiirJ6iO0Ou3KOwheJzaUKscSDZzlWkbBudlLHtrB9d6IH2a7GMrD5WLuj+5zG+cc2s4czDNAqG8JQXWpq6kItotbxWbnhhzdKIBj2Z845/D9KhjOabwsg/x3P98D6A8u1a03tI6spTyHllh+zIH81W48q1HLBmsOhXJj8TjsyvoDAPRantxdsOMHENykzrcEugjjt/P4kBoH9wNmHUHqk4RcuSiNePiTBTt4XfgAJOBxeb5KK3LbMgYUaPfY1uEmUJWWBDMfe+j9SvKPOShI5w2G5+RdzGr2owd4kSty1AOiSkQPPBL0lNyvFxNKikELbjpYON+CgKOAOnCbUOLt08uo1L4mhsdiTTBfr+XP4km82WwLVVorg5//UyB8/ovQzjVl4tAdXPhcfklr7whCysf0hIQNhUY2oL0e0wTkG7yG5x0SDFkYUsrTg5L2SOYd2fNFWm7XmZVp/Fml3aS59+9FDNDYzDSymmPY+xGLjOMFLjmXYKcbQgeof93gTmTnJ4RbkfR1PRcJpSYzOWHlIJg55X6wdsvNAvdzM8PCKnqDilZHcldYY50DcuY6dD0My0KLsDQpYyXelWS/non8o5uCgLDWoCuFS1gMEVQWw5tzOXQsmNuKg8S0v/xSFbKigjAoDlHmAZn6syg8fp90N0+OjWdbKQMYEUdhSRFyO1aPa0lUh5wo3Qa29J/OcBE3QbAEXbs6z10NYO4pRDmmPL7lpfMDncdR9Nr+ots76ZUHQzJB8kcnp+TBXIG/C0PhY7MAYeCy7OPiOksBeXllyumkD9cFJYAIL9Qxd45INxIfLunxtzBU0pXr+gjHrl676MvZUq836hjjtPZzT5PxnDEstUxv0XpQz7MpmUj4mBxDI4hJ7kLGA+1dAe/L8Hw9VAIFlcL3KzxeoZY55BzGlqbJiCaiNNgRgdUca1TD1Sbx87eikUU50rsxevv8LbNv31h
 iH/6Jpyd
 xrXTkeYJkQREyrbLOP1eQxHHghKpSSMUcUSNCjSgnG2FWr2c61whBeD8IKYYiJzSUlpsm6yCnHguC6AVLIp2yNw4qNijhOv9v/d1tJ8PJQ+ywEw6NygRrsAKQWqqfBZ48ACj4PFs/6AsGDVm1VSdCb6uBRsPUX3x5Eu0ecV1xHA1n/MeSiAsMJQFIDOTMCbwX5e9R4ZWpUehe6isPyMK4V5P213jGoFlXYYOfqoETUyx37Ou49GuR/tNpnGoPnmZKu7aVPyZvWSa+yQBv5NkKzd2MVVsPD7Bf/CtAg0QJfit5EBdldcYjKfPGMK8Tbk1Vg4TNv7YcABiStIBB7Qr+KpUufDNokkxcYtc5NS82FoItx0UJp6BOD4fyKU9gMILdjJ6y6VWFtneiCP86bYDm8lPqFe25QjzaxKztMIU3THenaglE3cF6pfFBGyhm26Pep0Q1A008b/Dv5Wa0kOhY8+dGVzedd+jTowPxflRPLcSqr2jpj9DJqE1DrjPHVDiDoGigTJLJMJyO22cioAHKqJ51q7yGf1UteiL2ML7uMAf1cP48lhDV71IAYx6SZKPYEMQNO2S7Q0gxkTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an API to enable the PCI subsystem to participate in a Live Update
and track all devices that are being preserved by drivers. Since this
support is still under development, hide it behind a new Kconfig
PCI_LIVEUPDATE that is marked experimental.

This API will be used in subsequent commits by the vfio-pci driver to
preserve VFIO devices across Live Update.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/Kconfig         |  11 ++
 drivers/pci/Makefile        |   1 +
 drivers/pci/liveupdate.c    | 380 ++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h           |  14 ++
 drivers/pci/probe.c         |   2 +
 include/linux/kho/abi/pci.h |  62 ++++++
 include/linux/pci.h         |  41 ++++
 7 files changed, 511 insertions(+)
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 include/linux/kho/abi/pci.h

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index e3f848ffb52a..05307d89c3f4 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -334,6 +334,17 @@ config VGA_ARB_MAX_GPUS
 	  Reserves space in the kernel to maintain resource locking for
 	  multiple GPUS.  The overhead for each GPU is very small.
 
+config PCI_LIVEUPDATE
+	bool "PCI Live Update Support (EXPERIMENTAL)"
+	depends on PCI && LIVEUPDATE
+	help
+	  Support for preserving PCI devices across a Live Update. This option
+	  should only be enabled by developers working on implementing this
+	  support. Once enough support as landed in the kernel, this option
+	  will no longer be marked EXPERIMENTAL.
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
index 000000000000..bec7b3500057
--- /dev/null
+++ b/drivers/pci/liveupdate.c
@@ -0,0 +1,380 @@
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
+ * Device preservation across Live Update is built on top of the Live Update
+ * Orchestrator (LUO) support for file preservation across kexec. Userspace
+ * indicates that a device should be preserved by preserving the file associated
+ * with the device with ``ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)``.
+ *
+ * .. note::
+ *    The support for preserving PCI devices across Live Update is currently
+ *    *partial* and should be considered *experimental*. It should only be
+ *    used by developers working on the implementation for the time being.
+ *
+ *    To enable the support, enable ``CONFIG_PCI_LIVEUPDATE``.
+ *
+ * Driver API
+ * ==========
+ *
+ * Drivers that support file-based device preservation must register their
+ * ``liveupdate_file_handler`` with the PCI subsystem by calling
+ * ``pci_liveupdate_register_flb()``. This ensures the PCI subsystem will be
+ * notified whenever a device file is preserved so that ``struct pci_ser``
+ * can be allocated to track all preserved devices. This struct is an ABI
+ * and is eventually handed off to the next kernel via Kexec-Handover (KHO).
+ *
+ * In the "outgoing" kernel (before kexec), drivers should then notify the PCI
+ * subsystem directly whenever the preservation status for a device changes:
+ *
+ *  * ``pci_liveupdate_preserve(pci_dev)``: The device is being preserved.
+ *
+ *  * ``pci_liveupdate_unpreserve(pci_dev)``: The device is no longer being
+ *    preserved (preservation is cancelled).
+ *
+ * In the "incoming" kernel (after kexec), drivers should notify the PCI
+ * subsystem with the following calls:
+ *
+ *  * ``pci_liveupdate_retrieve(pci_dev)``: The device file is being retrieved
+ *    by userspace.
+ *
+ *  * ``pci_liveupdate_finish(pci_dev)``: The device is done participating in
+ *    Live Update. After this point the device may no longer be even associated
+ *    with the same driver.
+ *
+ * Incoming/Outgoing
+ * =================
+ *
+ * The state of each device's participation in Live Update is stored in
+ * ``struct pci_dev``:
+ *
+ *  * ``liveupdate_outgoing``: True if the device is being preserved in the
+ *    outgoing kernel. Set in ``pci_liveupdate_preserve()`` and cleared in
+ *    ``pci_liveupdate_unpreserve()``.
+ *
+ *  * ``liveupdate_incoming``: True if the device is preserved in the incoming
+ *    kernel. Set during probing when the device is first created and cleared
+ *    in ``pci_liveupdate_finish()``.
+ *
+ * Restrictions
+ * ============
+ *
+ * Preserved devices currently have the following restrictions. Each of these
+ * may be relaxed in the future.
+ *
+ *  * The device must not be a Virtual Function (VF).
+ *
+ *  * The device must not be a Physical Function (PF).
+ *
+ * Preservation Behavior
+ * =====================
+ *
+ * The kernel preserves the following state for devices preserved across a Live
+ * Update:
+ *
+ *  * The PCI Segment, Bus, Device, and Function numbers assigned to the device
+ *    are guaranteed to remain the same across Live Update.
+ *
+ * This list will be extended in the future as new support is added.
+ *
+ * Driver Binding
+ * ==============
+ *
+ * It is the driver's responsibility for ensuring that preserved devices are not
+ * released or bound to a different driver for as long as they are preserved. In
+ * practice, this is enforced by LUO taking an extra referenced to the preserved
+ * device file for as long as it is preserved.
+ *
+ * However, there is a window of time in the incoming kernel when a device is
+ * first probed and when userspace retrieves the device file with
+ * ``LIVEUPDATE_SESSION_RETRIEVE_FD`` when the device could be bound to any
+ * driver.
+ *
+ * It is currently userspace's responsibility to ensure that the device is bound
+ * to the correct driver in this window.
+ */
+
+#include <linux/bsearch.h>
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/pci.h>
+#include <linux/liveupdate.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/pci.h>
+#include <linux/sort.h>
+
+#include "pci.h"
+
+static DEFINE_MUTEX(pci_flb_outgoing_lock);
+
+static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
+{
+	struct pci_dev *dev = NULL;
+	int max_nr_devices = 0;
+	struct pci_ser *ser;
+	unsigned long size;
+
+	/*
+	 * Don't both accounting for VFs that could be created after this
+	 * since preserving VFs is not supported yet. Also don't account
+	 * for devices that could be hot-plugged after this since preserving
+	 * hot-plugged devices across Live Update is not yet an expected
+	 * use-case.
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
+	ser->max_nr_devices = max_nr_devices;
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
+#define INIT_PCI_DEV_SER(_dev) {		\
+	.domain = pci_domain_nr((_dev)->bus),	\
+	.bdf = pci_dev_id(_dev),		\
+}
+
+static int pci_dev_ser_cmp(const void *__a, const void *__b)
+{
+	const struct pci_dev_ser *a = __a, *b = __b;
+
+	return cmp_int((u64)a->domain << 16 | a->bdf,
+		       (u64)b->domain << 16 | b->bdf);
+}
+
+static struct pci_dev_ser *pci_ser_find(struct pci_ser *ser,
+					struct pci_dev *dev)
+{
+	const struct pci_dev_ser key = INIT_PCI_DEV_SER(dev);
+
+	return bsearch(&key, ser->devices, ser->nr_devices,
+		       sizeof(key), pci_dev_ser_cmp);
+}
+
+static void pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser;
+	int i;
+
+	dev_ser = pci_ser_find(ser, dev);
+
+	/*
+	 * This should never happen unless there is a kernel bug or
+	 * corruption that causes the state in struct pci_ser to get
+	 * out of sync with struct pci_dev.
+	 */
+	if (pci_WARN_ONCE(dev, !dev_ser, "Cannot find preserved device!"))
+		return;
+
+	for (i = dev_ser - ser->devices; i < ser->nr_devices - 1; i++)
+		ser->devices[i] = ser->devices[i + 1];
+
+	ser->nr_devices--;
+}
+
+int pci_liveupdate_preserve(struct pci_dev *dev)
+{
+	struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
+	struct pci_ser *ser;
+	int i, ret;
+
+	/* SR-IOV is not supported yet. */
+	if (dev->is_virtfn || dev->is_physfn)
+		return -EINVAL;
+
+	guard(mutex)(&pci_flb_outgoing_lock);
+
+	if (dev->liveupdate_outgoing)
+		return -EBUSY;
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
+	if (ret)
+		return ret;
+
+	if (ser->nr_devices == ser->max_nr_devices)
+		return -E2BIG;
+
+	for (i = ser->nr_devices; i > 0; i--) {
+		struct pci_dev_ser *prev = &ser->devices[i - 1];
+		int cmp = pci_dev_ser_cmp(&new, prev);
+
+		/*
+		 * This should never happen unless there is a kernel bug or
+		 * corruption that causes the state in struct pci_ser to get out
+		 * of sync with struct pci_dev.
+		 */
+		if (WARN_ON_ONCE(!cmp))
+			return -EBUSY;
+
+		if (cmp > 0)
+			break;
+
+		ser->devices[i] = *prev;
+	}
+
+	ser->devices[i] = new;
+	ser->nr_devices++;
+	dev->liveupdate_outgoing = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
+
+void pci_liveupdate_unpreserve(struct pci_dev *dev)
+{
+	struct pci_ser *ser;
+	int ret;
+
+	/* This should never happen unless the caller (driver) is buggy */
+	if (WARN_ON_ONCE(!dev->liveupdate_outgoing))
+		return;
+
+	guard(mutex)(&pci_flb_outgoing_lock);
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
+
+	/* This should never happen unless there is a bug in LUO */
+	if (WARN_ON_ONCE(ret))
+		return;
+
+	pci_ser_delete(ser, dev);
+	dev->liveupdate_outgoing = false;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
+
+static int pci_liveupdate_flb_get_incoming(struct pci_ser **serp)
+{
+	int ret;
+
+	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)serp);
+
+	/* Live Update is not enabled. */
+	if (ret == -EOPNOTSUPP)
+		return ret;
+
+	/* Live Update is enabled, but there is no incoming FLB data. */
+	if (ret == -ENODATA)
+		return ret;
+
+	/*
+	 * Live Update is enabled and there is incoming FLB data, but none of it
+	 * matches pci_liveupdate_flb.compatible.
+	 *
+	 * This could mean that no PCI FLB data was passed by the previous
+	 * kernel, but it could also mean the previous kernel used a different
+	 * compatibility string (i.e.a different ABI). The latter deserves at
+	 * least a WARN_ON_ONCE() but it cannot be distinguished from the
+	 * former.
+	 */
+	if (ret == -ENOENT) {
+		pr_info_once("PCI: No incoming FLB data detected during Live Update");
+		return ret;
+	}
+
+	/*
+	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
+	 * but it cannot be retrieved. Proceed with standard initialization as
+	 * if there was not incoming PCI FLB data.
+	 */
+	WARN_ONCE(ret, "PCI: Failed to retrieve incoming FLB data during Live Update");
+	return ret;
+}
+
+u32 pci_liveupdate_incoming_nr_devices(void)
+{
+	struct pci_ser *ser;
+
+	if (pci_liveupdate_flb_get_incoming(&ser))
+		return 0;
+
+	return ser->nr_devices;
+}
+
+void pci_liveupdate_setup_device(struct pci_dev *dev)
+{
+	struct pci_ser *ser;
+
+	if (pci_liveupdate_flb_get_incoming(&ser))
+		return;
+
+	if (!pci_ser_find(ser, dev))
+		return;
+
+	dev->liveupdate_incoming = true;
+}
+
+int pci_liveupdate_retrieve(struct pci_dev *dev)
+{
+	if (!dev->liveupdate_incoming)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_retrieve);
+
+void pci_liveupdate_finish(struct pci_dev *dev)
+{
+	dev->liveupdate_incoming = false;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
+
+int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
+{
+	return liveupdate_register_flb(fh, &pci_liveupdate_flb);
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
+
+void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
+{
+	liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 13d998fbacce..979cb9921340 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1434,4 +1434,18 @@ static inline int pci_msix_write_tph_tag(struct pci_dev *pdev, unsigned int inde
 	(PCI_CONF1_ADDRESS(bus, dev, func, reg) | \
 	 PCI_CONF1_EXT_REG(reg))
 
+#ifdef CONFIG_PCI_LIVEUPDATE
+void pci_liveupdate_setup_device(struct pci_dev *dev);
+u32 pci_liveupdate_incoming_nr_devices(void);
+#else
+static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
+{
+}
+
+static inline u32 pci_liveupdate_incoming_nr_devices(void)
+{
+	return 0;
+}
+#endif
+
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index bccc7a4bdd79..c60222d45659 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2064,6 +2064,8 @@ int pci_setup_device(struct pci_dev *dev)
 	if (pci_early_dump)
 		early_dump_pci_device(dev);
 
+	pci_liveupdate_setup_device(dev);
+
 	/* Need to have dev->class ready */
 	dev->cfg_size = pci_cfg_space_size(dev);
 
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
new file mode 100644
index 000000000000..7764795f6818
--- /dev/null
+++ b/include/linux/kho/abi/pci.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
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
+ * @reserved: Reserved (to naturally align struct pci_dev_ser).
+ */
+struct pci_dev_ser {
+	u32 domain;
+	u16 bdf;
+	u16 reserved;
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
+ * @devices: Flexible array of pci_dev_ser structs for each device. Guaranteed
+ *           to be sorted ascending by domain and bdf.
+ */
+struct pci_ser {
+	u64 max_nr_devices;
+	u64 nr_devices;
+	struct pci_dev_ser devices[];
+} __packed;
+
+/* Ensure all elements of devices[] are naturally aligned. */
+static_assert(offsetof(struct pci_ser, devices) % sizeof(unsigned long) == 0);
+static_assert(sizeof(struct pci_dev_ser) % sizeof(unsigned long) == 0);
+
+#endif /* _LINUX_KHO_ABI_PCI_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1c270f1d5123..27ee9846a2fd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -40,6 +40,7 @@
 #include <linux/resource_ext.h>
 #include <linux/msi_api.h>
 #include <uapi/linux/pci.h>
+#include <linux/liveupdate.h>
 
 #include <linux/pci_ids.h>
 
@@ -591,6 +592,10 @@ struct pci_dev {
 	u8		tph_mode;	/* TPH mode */
 	u8		tph_req_type;	/* TPH requester type */
 #endif
+#ifdef CONFIG_PCI_LIVEUPDATE
+	unsigned int	liveupdate_incoming:1;	/* Preserved by previous kernel */
+	unsigned int	liveupdate_outgoing:1;	/* Preserved for next kernel */
+#endif
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
@@ -2871,4 +2876,40 @@ void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
 	WARN_ONCE(condition, "%s %s: " fmt, \
 		  dev_driver_string(&(pdev)->dev), pci_name(pdev), ##arg)
 
+#ifdef CONFIG_PCI_LIVEUPDATE
+int pci_liveupdate_preserve(struct pci_dev *dev);
+void pci_liveupdate_unpreserve(struct pci_dev *dev);
+int pci_liveupdate_retrieve(struct pci_dev *dev);
+void pci_liveupdate_finish(struct pci_dev *dev);
+int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
+void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
+#else
+static inline int pci_liveupdate_preserve(struct pci_dev *dev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void pci_liveupdate_unpreserve(struct pci_dev *dev)
+{
+}
+
+static inline int pci_liveupdate_retrieve(struct pci_dev *dev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void pci_liveupdate_finish(struct pci_dev *dev)
+{
+}
+
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
 #endif /* LINUX_PCI_H */
-- 
2.53.0.983.g0bb29b3bc5-goog


