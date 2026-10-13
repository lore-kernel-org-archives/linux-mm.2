Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF31DCC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCC1C6B008A; Tue, 13 Oct 2026 12:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3FF6B008C; Tue, 13 Oct 2026 12:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93546B0092; Tue, 13 Oct 2026 12:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90CA76B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1975FA8B6D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:40 +0000 (UTC)
X-FDA: 85318128840.16.18AD60A
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf04.hostedemail.com (Postfix) with ESMTP id 585ED40004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b80E6bQq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3f1vOaggKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3f1vOaggKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908738;
	b=aV/WtVi/faZJPtuSSVvFgHctlMfhnaG+CIn8Jpc/KXllsIvOhnoVHJISH3lwGleqhadb10
	qb8uf7MWqCjtvO6Xxmh5xoPRz5vQwHmDWgrpj1UBMwYxgFyX4gojvyjBbuW0RBIPsTdGvx
	hfBjXUD3U+f7S3TgsSQZ6HTwRMRCqTA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b80E6bQq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3f1vOaggKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3f1vOaggKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiMR+2XYaA+j1YeoU8XLMAtKMEvaP9OavYXRRtnEbp0=;
	b=gEALSk2wIc7Z/m6BtQKgMS2NfTgDMdqGtj2XAJxs0cRW6o2wan/8YeK2VmmavJpwxuqSZn
	QU5vXctAaJkLtYwbDremXiRI7VowcDQT3hPTtHwtXOfiltOcRKjh95iQhLkTHrpIsrByBM
	rAeOznwr1K0CgTF8af26ng8UnDe+WLY=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e8ad8c5f80so35952165ad.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908737; x=1792513537; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qiMR+2XYaA+j1YeoU8XLMAtKMEvaP9OavYXRRtnEbp0=;
        b=b80E6bQqDz2ad7rcUFuCpetI5ezQWca9dlW/9znBs2NjNFcUiZcrqFmhECQU/0BhJ7
         uBcSKwRKpHboI/AszU5uEtXiu/h3I3l+GA+Tlor64VmqmBpQE0mzcN1DXLI8TrMCxyqT
         3Hl8K/wqREJ4HuAU3C7alQocR9SwbdaywF2Z3+45DJWv1IxR8PsDJruAZ0YCBkdNxT82
         fRHXtnp5hY5fdzzVFVF/UhPlxnam9TYqSeDR8C4SgxGv7cW2kBZ9Q0QGrlqvUIzTyC53
         uBMaAFrqh7mbVm7gkb5oDcRCN236rapRbxaXIvBvzGNFd3t+Pwvff+NCP8Kh4Tp/FVPE
         7fUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908737; x=1792513537;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qiMR+2XYaA+j1YeoU8XLMAtKMEvaP9OavYXRRtnEbp0=;
        b=hv9wSw5M6UhNHkkSJ3S6jUIawnUTS4gRnsARem0bZvkMLHON1AmvZrImH9a9RVn0vp
         l6Ihqx2oqdYB/yaiW4Lsnsna2ffkUciRPO1Y6+fZ2pFR9mwMiORhJ6P462qQMvnWQJ+d
         XcQq9lkqUTGYnA1n21dtqaMqwg2e4lUNTpmUaqChWp/xR4De9ICDtzooLsQ6R6rviSeV
         t5kbKyGUPk1bhvnMzr4MFLGMfLnrER9gZczRAzX82MRdPNs0hmxsguoE9ukxCOH2iLtb
         NTObChnJOgvfDmpBjaR9AZApx5dGLidXHi8DTKiSlbmfMsuY7T33vmJ0gKe9UwweXY8c
         t7uQ==
X-Forwarded-Encrypted: i=1; AKwUvBzWL9//Y5voYgKBXK9lpbYkhCMtpJOlaR9ga5Md8JpXIFR6fXeszfrBSkOlxXMZgIZC1+PemaOKUg==@kvack.org
X-Gm-Message-State: AFq9FYLVXu+HAKfpYsVB7cugog+rdMZCcYxJu9AKTmr459SQQzy5EXVT
	V/CXC2yLKxtjs0s/ZY1uGl73/CghzSh0sq1bObf6yt4QKjMCS4OIJWIG73ufjDZwTxKeIMaFAtq
	k0xIgQNBex53+CQ==
X-Received: from plqw18.prod.google.com ([2002:a17:902:a712:b0:2e6:5c7:de7d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:cec2:b0:2e6:1715:e48d with SMTP id d9443c01a7336-2e842ac8863mr127612325ad.35.1791908735357;
 Tue, 13 Oct 2026 09:25:35 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:17 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-2-dmatlack@google.com>
Subject: [PATCH v10 01/13] PCI: liveupdate: Set up FLB handler for the PCI core
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
X-Stat-Signature: me5cudjqwjfekemdzs3gwqo7h38kb5ti
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 585ED40004
X-HE-Tag: 1791908738-577047
X-HE-Meta: U2FsdGVkX18+K4bR6yJnHuIRGOer83+0S6CcKGqBOKlmgCObRKDuZcfVzwrBmV/nHVZNyBoTz81hyU4z7jhAll0Q0MrzCmI/3HLvPMhE2+/jgoABIiHOqQbt/u6YeA0QSXN2yu6lIbjPHpRcI7AY1erLj3puD9LgR5W9aiyyo2N5EwLmfS6aYUk9nVfSCvMhcCgs4d32ObYJ+k54xGyHPW+p+Tqma5Pucl9jHdRYRCRkFCwmiyPCdpPMbk5ropLbTCo6EVe4vRvptPYkn0zLSxPXqIL78VHHBli7O0HUpzZ3hy2CpXOWpg1381VXaUbejtQUjkd3NoEzpCJz8X6xOSUh/YQsATs3UXT3iHEs1+gpKO26DMeUpKuaJydtMrD4MJ/g2qJD2sYVM7PO448HBqL2QXNi2B9/nSbyzqg9ZckotRg9igFeqAPeHj6pkTgVkdVVmTMzq36JkqavDVxqpJZjHIcqCjnk9ysmEOyunUloSgkSYuo8fLnPsNBzFJcoUynhnp0kUxIkd5yImdNfCfSI+q4S22NuEUkKuQ41IK8H3qFu0bQase1Jrm+rWvJa+SIevAKAGXNnEO07RTwl3797ogSBbGkV3x9dZVjvFN8iab8goKQqkjsCc8FLy2wW5fW6Lk3v19QNQBufZjJwrWFNKjUm1Di8xX/s9GDroOYaRx0xJxMrmSKGOwFSpqK9rjTz8P15mc1B/wk2hL75/7iHIANxwHN0HwKrgndDAB7WyLZ6unyD20n6E7d1hb+9LurD73ja0C1+4iIV5xPfrtjn64Ql3Z0Xza+i7eZzhXHKBbRlB5JNLZ+ZEgdZxVj5kn8aMRcP5OhG1jSOnwoq5mTI2NET54tI6U6WHl/QY/HNDBGoF6KLUrOvEZJZbFgtbxsBx/60VENBr9BrN8ksFyMYanmCujk1FOWsnK/FJx+x0Y/01ZOfblOjWF6a4TcLOHMbJLRq9RysbTZz+di
 2XYEFTdM
 +gLqrg6JD188Z76bZe7OmuoORd2Watw2lA9rB/zhfcjUViPli0SV05AGPFd+q35u5lil3S2PYTcgtqoyOzQ2meKvCzMPzc423SxBLdV5cToG9tZcPYYqmlm9JIT4Oh8PSnUo8FbHEZjDsqpG6wx9onygSDvAWSeSoP4TE8YxskyZ3zYPCcCqzSteALCTXFyO1ahJztY6v+2oxTAnGxC6V52BW50as+FPJEMoij2Dgp9ekg6LF1SK+xKHsizfARLzzS2qHsDtg+6InT2kb8n1CjXW/otg/+afj2dVGirA0Myr/aI3NscGfiDrOO3q12qnMGDEbWvltbsZ8C5XfM1AhV6iNuMakXxL+TX4B8e1dXADrqDxsgMNnDWkEycTOtHEDD2mUYK9NVczU9dpH1edvqLileyvH9vpfwoYfJFpyf5V5V8LUWtqpp4zKLwv0CzpN1Tj1voJzAFu+NshVjGr+HU9jSJDemPbG1kfaXahye4aRPBJV9rTUcyz9ToUnO/lvYjzKkcYIzxfKZLlAul8eImLBbbeKosU2zbktP9m43+vv3hTkSUeTsRZapWrF6ucTQUifu4IxL5JVwT7pO9LeJYpFOuclZFac/+OwvqdtHNjCcsooKKuRJXn4vIZeWDRf58qSjT/OkWXbqB3rr/Ps+Du3rFiMSlTvpHQEEwMEh09Tvb1gvu89WSJq7Of2WF17zjV7IcMue6uELDDhhh3KrXrZ2BH5HTKbs8lGHYXqIX6Dkf4=
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

LUO then keeps a reference count on the PCI core's FLB for the files
preserved by that handler, and that reference count drives the lifetime
of struct pci_ser:

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
to duplicate LUO's reference counting and unwind logic for preservation
failures, session aborts and fd close, and the incoming side
(retrieve/finish) comes from the same object rather than requiring a
separate KHO FDT entry owned by the PCI core.

struct pci_ser begins with required_flags and optional_flags, rather
than a version number, so that the ABI can be extended without breaking
compatibility between kernels. A kernel that sets a bit in
required_flags requires the next kernel to understand the corresponding
feature, while bits in optional_flags can be safely ignored. The size of
each struct pci_dev_ser is recorded in struct pci_ser as well, so that
new fields can be appended to it.

Note: This commit only allocates struct pci_ser and preserves it across
Live Update. A subsequent commit adds pci_liveupdate_preserve(), the API
drivers call from their fh->ops->preserve() callback to tell the PCI
core exactly which devices are being preserved.

Note: There is no reason to check for kho_is_enabled() since it can be
assumed to return true. If KHO was not enabled then Live Update would
not be enabled and these routines would never run.

Note: PCI_LIVEUPDATE depends on 64BIT so that a device's domain and BDF
always fit in an unsigned long, which a subsequent commit uses as the
key when looking up incoming preserved devices.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/core-api/liveupdate.rst |   4 +
 MAINTAINERS                           |  13 ++
 drivers/pci/Kconfig                   |  15 ++
 drivers/pci/Makefile                  |   1 +
 drivers/pci/liveupdate.c              | 208 ++++++++++++++++++++++++++
 include/linux/kho/abi/pci.h           |  96 ++++++++++++
 include/linux/pci.h                   |   1 +
 include/linux/pci_liveupdate.h        |  30 ++++
 8 files changed, 368 insertions(+)
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
index 0c7408509ba2..8af20f558086 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -271,6 +271,21 @@ config VGA_ARB_MAX_GPUS
 	  Reserves space in the kernel to maintain resource locking for
 	  multiple GPUS.  The overhead for each GPU is very small.
 
+config PCI_LIVEUPDATE
+	bool "PCI Live Update Support"
+	depends on PCI && LIVEUPDATE && 64BIT
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
index 000000000000..5f065dccbd7b
--- /dev/null
+++ b/drivers/pci/liveupdate.c
@@ -0,0 +1,208 @@
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
+ * The rest of this document describes the latter.
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
+ * LUO then keeps a reference count on the PCI core's FLB for the files
+ * preserved by that handler, and that reference count drives the lifetime of
+ * struct pci_ser: pci_flb_preserve() allocates and preserves it when the first
+ * file is preserved, and pci_flb_unpreserve() frees it when the last file is
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
+	ser->required_flags = 0;
+	ser->optional_flags = 0;
+	ser->dev_ser_size = sizeof(struct pci_dev_ser);
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
index 000000000000..c2e3a5949f73
--- /dev/null
+++ b/include/linux/kho/abi/pci.h
@@ -0,0 +1,96 @@
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
+#include <linux/stddef.h>
+#include <linux/types.h>
+
+/**
+ * DOC: PCI File-Lifecycle Bound (FLB) Live Update ABI
+ *
+ * The PCI core preserves its state across kexec as Live Update
+ * File-Lifecycle Bound (FLB) data, identified by the compatible string
+ * ``"pci"`` and laid out as described by the structs below.
+ *
+ * This layout is a contract between kernels. Rather than being versioned, it
+ * is extended according to the following rules:
+ *
+ *  * Existing fields must never be moved, resized, removed, or have their
+ *    meaning changed. New fields may only be appended to the end of a struct.
+ *
+ *  * A bit set in ``pci_ser.required_flags`` marks a feature that the next
+ *    kernel must understand to safely take over the preserved devices. The
+ *    next kernel panics if it finds a bit it does not know how to handle.
+ *
+ *  * A bit set in ``pci_ser.optional_flags`` marks a feature that the next
+ *    kernel can safely ignore if it does not understand it.
+ *
+ *  * Fields appended to struct pci_ser must be accompanied by a flag that
+ *    indicates they are present, since the size of struct pci_ser is not
+ *    recorded.
+ *
+ *  * The size of each struct pci_dev_ser is recorded in
+ *    ``pci_ser.dev_ser_size`` and is never smaller than
+ *    ``PCI_DEV_SER_MIN_SIZE``. The next kernel ignores any fields beyond the
+ *    ones it knows about, and must handle entries that are smaller than its
+ *    own struct pci_dev_ser.
+ */
+
+#define PCI_LUO_FLB_COMPATIBLE "pci"
+
+/**
+ * struct pci_dev_ser - Serialized state about a single PCI device.
+ *
+ * @domain: The device's PCI domain number (segment).
+ * @bdf: The device's PCI bus, device, and function number.
+ * @refcount: Reference count used by the PCI core to keep track of whether it
+ *            is done using a device's struct pci_dev_ser. The value of the
+ *            reference count is equal to the number of preserved devices at or
+ *            below it in the PCI hierarchy when the struct pci_dev_ser is in
+ *            use, and 0 otherwise.
+ */
+struct pci_dev_ser {
+	u32 domain;
+	u16 bdf;
+	u16 refcount;
+} __packed;
+
+/*
+ * The size of struct pci_dev_ser when this ABI was introduced. Since fields
+ * can only be appended, every struct pci_dev_ser is at least this large.
+ */
+#define PCI_DEV_SER_MIN_SIZE offsetofend(struct pci_dev_ser, refcount)
+
+/**
+ * struct pci_ser - PCI Subsystem Live Update State
+ *
+ * This struct tracks state about all devices that are being preserved across
+ * a Live Update for the next kernel. It contains only state owned by the PCI
+ * core; the state a driver needs to resume its device is preserved separately
+ * by that driver.
+ *
+ * @required_flags: Features that the next kernel must support to take over
+ *                  the preserved devices. No flags are currently defined.
+ * @optional_flags: Features that the next kernel may ignore if it does not
+ *                  support them. No flags are currently defined.
+ * @dev_ser_size: The size in bytes of each struct pci_dev_ser in @devices.
+ * @nr_devices: The number of devices that were preserved.
+ * @devices: Physical address of the first KHO block containing pci_dev_ser.
+ */
+struct pci_ser {
+	u64 required_flags;
+	u64 optional_flags;
+	u32 dev_ser_size;
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
2.56.0.385.gd3acb90ef8-goog


