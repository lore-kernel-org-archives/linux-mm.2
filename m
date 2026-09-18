Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1B6FC982E0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4124A6B0098; Fri, 18 Sep 2026 16:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9CA6B0099; Fri, 18 Sep 2026 16:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F47C6B009B; Fri, 18 Sep 2026 16:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C06516B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:06:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF4B71207DC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:06:57 +0000 (UTC)
X-FDA: 85227966474.27.9B03B70
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf30.hostedemail.com (Postfix) with ESMTP id 278838000D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:06:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="X/ozWTJp";
	spf=pass (imf30.hostedemail.com: domain of 33pmtaggKCCUENBUMBDLHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=33pmtaggKCCUENBUMBDLHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vMZxoJzxf5EwoOEJT6PgaqZk5axcphqe1c88PqDiOfI=;
	b=kZ4KHQQhbIQvBEt2vFOs//30XzxEAevxcvHW/Y1/twzCS5VcHB+C289uNLuN9vLSVNrQWg
	Xs8tv6+t7MjnxL8d0Mfq/Jnp8cxZN5Hw6HqUG8+YcE4rlbAONHQk5c0izkwL53b/g9MATf
	TNWLa0LLVdEXU0nD08SjQMdgtZ1R1k0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="X/ozWTJp";
	spf=pass (imf30.hostedemail.com: domain of 33pmtaggKCCUENBUMBDLHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=33pmtaggKCCUENBUMBDLHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762016;
	b=BybAE40AigJHe6cYj44t4HCsGyCvRI93qpm7bdVXVowowi/PuOJkhT06g5hj1W3WpXCWsm
	pP40FLPeF3H8AYXXa5kN47gEwt/aT99mNn8m2S4D2ssf/eVxAbk7VXSnpJMifzUkpjoYXB
	07Y0lFsYqsgSd80YTT8uIvyXmgF1qDo=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce7dfd33ffso14183105ad.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762015; x=1790366815; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vMZxoJzxf5EwoOEJT6PgaqZk5axcphqe1c88PqDiOfI=;
        b=X/ozWTJpMIqhY2gMosvMu0vBJk2fZBUXzYvNC/l/YpA/n7AyJAO8ZYT1hEStCXuVZT
         kZyqylWxxjUo8XSzxekt/djt3vr9D1BYgHlb4K/o3IBZ0uMifgq7X8hYSbylBSJz+mPa
         hMmcfybTNsoLDhUsKnX7BVVVHoOpiQ8mZ0btX09tYZkj8IKPvxSC1dgbqShpi/PCUSvh
         iiw2fcPOYvX2cIYPhbhjVyzeHlQEvZ9lYPfgUyzC/YBWXZeumNsUf2yTOQKykyl1tfRm
         g89XKUX0l+jx8c1LS1eqJungaY/AA8qFcjzu4eBxE3ImxTUMuRSXRHOSDWAsRVmYG1ff
         Puhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762015; x=1790366815;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vMZxoJzxf5EwoOEJT6PgaqZk5axcphqe1c88PqDiOfI=;
        b=wkP9SmGQgC7JRJFVgHupdzNRQ6pdb/bDtUeeafJVmu5/0G+wlAJ1XGk2x01KD4+EwJ
         U+kuKWAwKSNomN2O9qhfhYQEVVVYsta4C+22gLliTVUv+VC4Aq1EHVq9k/NNIUYU06i1
         nwb92OIleuM03ap4hfof0F4Z6l0eMLaQvnuhDsjFPdC1lVDTkrIhj8c1o89qqxMelz+W
         WBYddyy1oi9xuCw0jB4KmMlWe7N6QV9brosB1r98frClz6vVsq9QGusZgtC2YEF6WYVf
         H1PI2U1FArry9PmFLlNAUVQazErpcJwgr3u5n/UwzFllF4bkntw4iH/ZMJM1XGi610+S
         HV8w==
X-Forwarded-Encrypted: i=1; AKwUvBysP6f5dqPKL/yJiheML4yTKmPusSaC5y5jNBZlo7pF2HGi86J5QUe5GCDM6XsbplyWKhyZjyIvcA==@kvack.org
X-Gm-Message-State: AFuF++n3mKTlc6baWo4LsbD0QdqvVQvLwXGBz9RxHatICzfw7JCftMkA
	7WnUFerua7byeIw28VSoGJlo6neDDgMLIJAUddnxYAqAuuSvGsGhMzLsGEIt1DzgPMdP2z2QYaK
	9fQIypRCS0D2nrA==
X-Received: from plad17.prod.google.com ([2002:a17:902:e151:b0:2db:79ec:b693])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:98b:b0:2dd:c100:7cb7 with SMTP id d9443c01a7336-2ddc1007d77mr8305955ad.51.1789762014774;
 Fri, 18 Sep 2026 13:06:54 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:27 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-2-dmatlack@google.com>
Subject: [PATCH v9 01/13] PCI: liveupdate: Set up FLB handler for the PCI core
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
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 278838000D
X-Stat-Signature: fjstp1gr53s78ejd9of83mynkqksy66h
X-Rspam-User: 
X-HE-Tag: 1789762016-216937
X-HE-Meta: U2FsdGVkX18Aes/AmQv72SLgoJ/gVLC4rVz8oXHrHAZ6BcQVv4Gb0zJrYAdbYR4SbwueoDnZoOIb29Npw6V1aUApM3YJVxSjvo1uXMzmpXx7RynZimXMYwNu57kKoUrEJWvmd2+9nhmteXY/+QtKx0RNXdnj+BPmB2VzBTnMMElyFPrPRVVgslqUqEdgbAQPBHnm9XD0UTVKGo/tz5RdTJx1nWw5H6hIBr7WYycS0Sz3XkiFgyjbkl1/CWMD94jOZtu5fwF02qRGCndTpRCF5YuYoBbBuLK4AWASGeMhoec9Qyr8LoY7LAQ1+pzbr5wZ2xJERcUIvnLX8TXEaJtUCB4iYn0Ti4yEpiNcROjM149iDw6DKPisIJ9f56ZPRIwhWgE5o7TAQWO62GEnWsr2sY5FET8sxINyBdldrKRjj1mrK0vsj7oj7GKWu0r7smUs31o+wx++NGDZSK2EZ3dFRSjdtKwn+aHMPYTsXH2RPId7/0NRemG1vvywTAiHCpF6vSJm62EHeZAqmyn3mp7K+eSAe97uiydKXkL9jH9pa9qAmzuZErM8mF7J9H87mNeKLybYdTu/0rJMzV0P2/IGPzrBVCCiKcXmDBphb0zkfdykBVGJl99BG4zM/TK17EpOvK2/6HHlUioSt3JWm/nglCto6t1XQpF4Bd+oZh6kD7UJvf6WtgNxLX/yrYVWMpK+c+eKNaLTyeEEs5rVZ+5c7IyiUa2MbVi/+ZoPbDMqGoqhouDj7PzP8T6S6AcvnZV4OPcFlyoLDx4Kb3X0rkMpXuBuUywGCOCXTuvlyFVQymzOuJVVpIuC68M7CMIfGtFOYOdu/zJoi1Wi+LuBqd9Ifv8VFGvievG7NRdCIsXxBJIfpIAtKtm18J4w/xrYnIIx/7Vtq+gqG5B7C1Gcxs41a3Y+cECYvCKnJjc+pwXUuJelMeKJaV8gNhM8drFeV0hszeCv66KaL3ULaueGxt9
 q/d0BnKg
 zHw0f4pMHyYcfHRUcJNiQUFN7Q6KUpcF3xG0bL6WdXSyVpbRtdnQ6pvbWJekL3CHucYd5fC6js5f2gbqsI72ppmqCss4LAojBaqQAIqeA1gD6DakjsNa9WsKL6Coeb8p6Az9Ipnh6kSEh8nxl4drdFPM64Mx3EB08mc3RI2HSkjDEWkaSF5QxiNcjgPzTrG45/D2wEqMWNLvYk+AXeKEkYG8vulYikUvw+V380MeYzrGkXJ2Nz4zFTrXje/cnCIw5GSRvydycH1OhLqVPKIZ/pzm7I9sWWh35XF8+tY8lZOZtL+IjrYf0Gp0U8CvxzpCY0Z/sNV2/an9xEzRa0Ng9nGGdv5SPAEWgIYDLBfGSdkgb0x+R3cDU6sLACpu7pMOosVs0ExJ6h5GTWnk5eQfCIcTxNk3hQez/rkNRZCdaKO9JKlRIEXgaKu9wPy0lzXMEh/SOHhiwKY9toLgs1uLkHYyuKbWlw2VaCcf6IRDIWLAifjUtY7g5vcZO27K0tyZSCCRZ6MwmcoHWRr2HONgvVdHl+W2Vd6hIE7nbKzVQ0eFXHxG2BpPiYFLMJMjUSG5LgsO+WUyQx0YGIKzs5fctoYvQyJ8PiHN+S4nq8F5USpKwH8I+n3QIGxkXXaOv8Y94TLDASjXQLugPckyCq3U37RUSgzznCLYJU77W7aczIOj4CoalOIUfmwLhbwpsEhbBWK/xIcM7Am03P+dE+qrGv4e18Bl3fKKBSBs9NsZS+CEueKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set up a File-Lifecycle-Bound (FLB) handler so that the PCI core can
preserve its own state across a Live Update kexec.

Preserving a PCI device across kexec requires preserving two independent
sets of state:

 - Driver state, e.g. everything vfio-pci needs so that userspace can
   keep using the device in the new kernel. The driver preserves this
   itself and the PCI core is not involved.

 - PCI core state, e.g. which devices are preserved, so that the new
   kernel knows not to disturb them while they are still running and
   doing DMA. That is what this commit adds, serialized into struct
   pci_ser.

Userspace, not the kernel, decides which devices are preserved, and it
does so through the Live Update Orchestrator's (LUO) support for file
preservation: a driver exposes a file that represents a single PCI
device, and userspace preserves that device with
ioctl(LIVEUPDATE_SESSION_PRESERVE_FD) on that file. Binding preservation
to a file gives it proper lifecycle management, e.g. the preservation is
undone if userspace cancels it or goes away. How a driver exposes that
file is up to the driver and invisible to the PCI core (vfio-pci variant
drivers, the first intended use-case, use their per-device cdev).

LUO only knows that a file was preserved; it does not know that it
represents a PCI device, or which one. Bridging that gap, drivers
register their liveupdate_file_handler with the PCI core:

  pci_liveupdate_register_flb(driver_file_handler);
  pci_liveupdate_unregister_flb(driver_file_handler);

LUO then refcounts the PCI core's FLB against the files preserved by
that handler, and that refcount drives the lifetime of struct pci_ser:

 - On the first preserved file, luo_flb_file_preserve_one() calls
   pci_flb_preserve(), which allocates struct pci_ser and preserves it
   with KHO.

 - On the last unpreserved file (i.e. preservation cancelled),
   liveupdate_flb_put_outgoing() calls pci_flb_unpreserve(), which
   unpreserves and frees struct pci_ser.

 - In the next kernel, pci_flb_retrieve() hands the PCI core the struct
   pci_ser built by the previous kernel, whenever the PCI core asks for
   it (e.g. during enumeration), and pci_flb_finish() frees it once the
   PCI core is done with it.

So the flow for preserving a device, once a driver has registered, looks
like this:

  ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)
    luo_session_preserve_fd()
      luo_preserve_file()
        luo_flb_file_preserve()
          luo_flb_file_preserve_one()  # only on the first preserved file
            pci_flb_preserve()         # alloc + KHO-preserve pci_ser
        fh->ops->preserve()            # driver callback, e.g. vfio-pci

Note that struct pci_ser is deliberately not allocated when a driver
calls pci_liveupdate_register_flb(). A driver can be loaded for the
lifetime of the machine without ever preserving a device, and there is
no reason to allocate memory and hand it to the next kernel in that
case. Letting LUO own the lifetime also means the PCI core does not have
to duplicate LUO's refcounting and unwind logic for preservation
failures, session aborts and fd close, and the incoming side
(retrieve/finish) comes from the same object rather than requiring a
separate KHO FDT entry owned by the PCI core.

Note: This commit only allocates struct pci_ser and preserves it across
Live Update. A subsequent commit adds pci_liveupdate_preserve(), the API
drivers call from their fh->ops->preserve() callback to tell the PCI
core exactly which devices are being preserved.

Note: There is no reason to check for kho_is_enabled() since it can be
assumed to return true. If KHO was not enabled then Live Update would
not be enabled and these routines would never run.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/core-api/liveupdate.rst |   4 +
 MAINTAINERS                           |  13 ++
 drivers/pci/Kconfig                   |  15 ++
 drivers/pci/Makefile                  |   1 +
 drivers/pci/liveupdate.c              | 206 ++++++++++++++++++++++++++
 include/linux/kho/abi/pci.h           |  65 ++++++++
 include/linux/pci.h                   |   1 +
 include/linux/pci_liveupdate.h        |  30 ++++
 8 files changed, 335 insertions(+)
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
index 3a19da74d00c..bb9ef5460b5c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21046,6 +21046,19 @@ L:	linux-pci@vger.kernel.org
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
index 000000000000..66dbee0bd3cf
--- /dev/null
+++ b/drivers/pci/liveupdate.c
@@ -0,0 +1,206 @@
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
+ * Preserving a device requires preserving two independent sets of state: the
+ * driver's own state, which the driver preserves with no involvement from the
+ * PCI core, and the PCI core's state about the device, which the next kernel
+ * needs so that enumeration does not disturb a device that is still running.
+ * This file implements the latter.
+ *
+ * :ref:`FLB <flb>` Data
+ * =====================
+ *
+ * Userspace decides which devices are preserved, using :ref:`LUO <luo>` file
+ * preservation: a driver exposes a file that represents a single PCI device,
+ * and userspace preserves the device with
+ * ``ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)`` on that file. Binding preservation
+ * to a file gives it proper lifecycle management, e.g. the preservation is
+ * undone if userspace cancels it or goes away. How a driver exposes that file
+ * is up to the driver and invisible to the PCI core (vfio-pci variant drivers,
+ * the first intended use-case, use their per-device cdev).
+ *
+ * LUO only knows that a file was preserved; it does not know that the file
+ * represents a PCI device. Drivers therefore register their
+ * struct liveupdate_file_handler with the PCI core:
+ *
+ *  * ``pci_liveupdate_register_flb(driver_file_handler)``
+ *  * ``pci_liveupdate_unregister_flb(driver_file_handler)``
+ *
+ * LUO then refcounts the PCI core's FLB against the files preserved by that
+ * handler, and that refcount drives the lifetime of struct pci_ser:
+ * pci_flb_preserve() allocates and preserves it when the first file is
+ * preserved, and pci_flb_unpreserve() frees it when the last file is
+ * unpreserved. In the next kernel, pci_flb_retrieve() hands the PCI core the
+ * struct pci_ser built by the previous kernel, whenever the PCI core asks for
+ * it (e.g. during enumeration), and pci_flb_finish() frees it once the PCI
+ * core is done with it.
+ *
+ * Call Flow
+ * ---------
+ *
+ * ::
+ *
+ *   # Driver initialization
+ *   pci_liveupdate_register_flb(fh)
+ *
+ *   # Userspace: ioctl(LIVEUPDATE_SESSION_PRESERVE_FD, devfd)
+ *   luo_preserve_file()
+ *     luo_flb_file_preserve()
+ *       luo_flb_file_preserve_one()      # first preserved file only
+ *         pci_flb_preserve()             # alloc and preserve struct pci_ser
+ *     fh->ops->preserve()                # driver callback
+ *
+ *   # Userspace: preservation cancelled or session torn down
+ *   luo_file_unpreserve_files()
+ *     luo_flb_file_unpreserve()
+ *       liveupdate_flb_put_outgoing()    # last unpreserved file only
+ *         pci_flb_unpreserve()           # free struct pci_ser
+ *
+ *   # ---------------- kexec ----------------
+ *
+ *   # New kernel: the PCI core asks for the previous kernel's state
+ *   liveupdate_flb_get_incoming()
+ *     luo_flb_retrieve_one()             # first request only
+ *       pci_flb_retrieve()               # previous kernel's struct pci_ser
+ *
+ *   # Userspace: ioctl(LIVEUPDATE_SESSION_FINISH)
+ *   luo_file_finish_one()
+ *     fh->ops->finish()                  # driver callback
+ *     luo_flb_file_finish()
+ *       liveupdate_flb_put_incoming()    # last incoming file only
+ *         pci_flb_finish()               # free struct pci_ser
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
+ * Drivers that support preserving PCI devices across Live Update must call
+ * pci_liveupdate_register_flb() to register their
+ * struct liveupdate_file_handler with the PCI core, typically at module init,
+ * and always before any file managed by @fh can be preserved.
+ *
+ * Registering links the PCI core's FLB to @fh, so that LUO allocates the PCI
+ * core's outgoing struct pci_ser (via pci_flb_preserve()) when the first file
+ * managed by any registered handler is preserved, and frees it (via
+ * pci_flb_unpreserve()) when the last such file is unpreserved.
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
index 000000000000..4096e3cd3324
--- /dev/null
+++ b/include/linux/kho/abi/pci.h
@@ -0,0 +1,65 @@
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
+ * a Live Update for the next kernel. It contains only state owned by the PCI
+ * core; the state a driver needs to resume its device is preserved separately
+ * by that driver.
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
index d31a8d107b1e..95b723aecb08 100644
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
2.55.0.1082.g2b9226bbc0-goog


