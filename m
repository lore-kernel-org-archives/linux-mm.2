Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04906C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774E46B00EB; Tue, 14 Jul 2026 11:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C846B00E9; Tue, 14 Jul 2026 11:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA4B6B00E9; Tue, 14 Jul 2026 11:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF1A6B00E9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D91C1403DA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:18 +0000 (UTC)
X-FDA: 84987730716.28.3132058
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3EF9CC000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=crYBVSx7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3glJWagcKCNkQDKDINCBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--vipinsh.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3glJWagcKCNkQDKDINCBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbe+Pbv5TCQdXk1eG0Iq+EuxqrVwsKywg3T3pq48EEY=;
	b=6YUTDas+43tJY9hBh8D00a2+1uVchWi29A4nhMCPKt8owr2Rk71F1/iWK3gaC2UOvVMpHj
	dNqaaxwjgBhG9ZcAoM7Lo6U8OXHcdz+2uLHWQQMHEctnRa9NIGdzBwIOjS1S2Pn+vrG2hi
	edoVqntRu3vQhuufQq1l5p5DHFTU0Y0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=crYBVSx7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3glJWagcKCNkQDKDINCBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--vipinsh.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3glJWagcKCNkQDKDINCBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042116;
	b=ANyocVoCrE+5HwyW7mIQrKWPJb5VfRXW3d2T0dqGVj2RU7MmdOLi6XgzzdoISVHuBSSADl
	jNiEzc7sQeF08SrvI94oWAftOcoKCyMLUtaa8z1rCDG5StKq78OwgNZ5GPvSqmADGUpE27
	4oJdHakld8/lj5AmsbRmNz0aGEnd3uY=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c88da04b719so1061911a12.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042115; x=1784646915; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cbe+Pbv5TCQdXk1eG0Iq+EuxqrVwsKywg3T3pq48EEY=;
        b=crYBVSx72W6YSX4JfgEWkZzn+dnRV9kUKOC6q+x5Ay6IVUy6//dJnr7yp7S2gLAA1p
         HXmHL7NjbfS28onCBOhmabFsQAIDyB4v8M6bTdfDdEq1Vcl9EJ4G1whMIKHt8YqBSAp2
         sMAsH+cTwFYjEMUhPvtEXEGcJk9eHJgrOWF5uUvd74AeWEfIzEr7J1pwNF4thZoaD5jn
         X6/ejL25NNOyMiKyTL5kQ7w4k+34oGRyMHUGR6o3jmK5TkRLajRC9AvvxCLJ/9pJrWbh
         RFJGPqywbgp/6KWZ2EGA1biENGYLIt/JJd0fg16y6YNxuX5tgNpxurTxlMToDEVKuss2
         rl9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042115; x=1784646915;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cbe+Pbv5TCQdXk1eG0Iq+EuxqrVwsKywg3T3pq48EEY=;
        b=s5Jjz7RG2SaKzidTNMorFrpnuWHi6IeighLlLuqCWeTIYDglzlibPqTyjNJ5bLUcrT
         RqykJkVNPZqNT7SR5Tlt7oeURgEkPCDr97wt4dOtphuGb4/UvIrnF7PsUTqQmc0RK9Pd
         Od72olbU8CwNn1hpbuNdP9aWRemYZFykfAZgkp6DPNQQAAkdQ45MuwYSjh5SyuEBGQm3
         EXnPSlxz+URAYRXUlypnRulUr4XLGuHwxacI/l8UsoJmBdwHXAtrWMW3X0hh5RZiCQ5R
         IUcbrcwBJbFViURYMFO+cSQiTW3rDeFAyHQ5F3gmEKwBTeAbCLx0liof9tbyqIzj6d1d
         1Qvw==
X-Forwarded-Encrypted: i=1; AHgh+RqM7myw7DlZYYdPM6gTy3VUnElm18oYg8gAoe7jLaTcZ+ZNSpgrYZE5k9p8hgKXBvDq1o6M5R9rGg==@kvack.org
X-Gm-Message-State: AOJu0Yy/PWDAUA580/YGvczJM8zPgv/2a2eTovOthiSKorMq8JT6MCHn
	nsZC8t0/kaIthbVjofMsHB5za208cwry8C++GETW+RpCiYu/LGIj+CIitoY1Wj2p6C5XnU8dPIS
	kxVS44AEZyw==
X-Received: from pgj187.prod.google.com ([2002:a63:9c4:0:b0:c92:460e:4f54])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:728c:b0:39f:a8fb:3354
 with SMTP id adf61e73a8af0-3c1108b5a4bmr12826055637.17.1784042114667; Tue, 14
 Jul 2026 08:15:14 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:50 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-6-vipinsh@google.com>
Subject: [PATCH v5 05/20] vfio/pci: Register a file handler with Live Update Orchestrator
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3EF9CC000F
X-Stat-Signature: hfgq8pf8iq9xs3jixm3me31ckj4jsfnn
X-HE-Tag: 1784042116-945873
X-HE-Meta: U2FsdGVkX181Nt6zzD3fy88qGj+ARMD8hYCCnJIWklZlsqeRovhKszGgMF5uViBXgjLyI1s957ow0XrF2235u4j4KWjBPMCeel21LmuriOKxDh0vs6gabqwP8J3SvYfwvyoZ+jStEoPIkEUTlbAC/68QxY4H35R6+iE5+S+qZNAcmEnq99xVpYpCRpxwUDGTeCqHgsSOoCfoNqEdjMXW2Tple+x4CjyJas24Fj3GHrmJ70s6IVUc3PJIMx5TxEpkqi795tfvgvOyBEerb0GxpDhbkp+F7yNHZ/1GwidqH6i6QadoOQWV7S/Lg8PksVzWxy0zsXDaVMTBa7msDKDS/nQ75B0VigWKMPbnv9/k75EWCGWi+Q0rfHiRKkGvOq71u6WUBQYuIpuw+amuZ+Cr2iW+E04HlFWkw/5u2MoDg//AkqOL9zspkBpEbsApYV7fFa1NqWajedXtZmmcjUhpHaxaXx9sXW2P4pnPWlMazV9jnfWLuSyZNnz2e4ZcVrd42XDLPn8iJukGWOg7nTzVwU0+pOK/3szHSFSsAv+qsRVjuHe5GjVxqnEpI0f2TrNreBXdH8U0ExWrrwF4JAPRKVDGRYbZn8JBN60mMztUZyiNjtZFLrP4e3G/Hb7cGcoTzZZYaoTYpSB+EF7aDBMzXC2x/LhieGzkmKoigPvO6Ps/TZiukUgIJI0l5PdECHUG1P5xSWO0Zmz90wLr/IgMgDwLlzEJQcZ5EJUJzW15etZuwaqADXqxhO+L58+wNK57ZXsexh+vGYZqxg0u+I5JaInkxAEky6fYGqWxclarrWi2W89Imi16EoAAMDyAlUSrOiwaySJdElkqvLiUjeemvUVZfpnV7x7TRTiITi/LyD/IB7+yvx1AfI6lD+OSwg/KPswfrRvsRsJqzRWiyf0Y0zMFzVjo3mIf3foAGGiCttCJX3TYHfW4XpA/xeOxetvvnUoKdyS+SDTJf4owlwE
 HEK0KfNG
 k0lge/cNjec3ulj5u8ZTo7ZrzLBSFoB/T5XwvsWQF6WqYPjchjsoyH7tVVlGCc18ObEDKSpL81YSjv6P3+41/O9ShYdWIwQxZh9hBVXYfTidle9KecTNOK1m8uldr6pP6d/2E3xp9XEBPbDvzditPmrzxjP8aSl7r9cRSJypE9phmds/0aAlBmpYQumKRyRboRgEx2A/amQVcfWBUbbgqdSS2EPEAgo+h5Swo/wcvgnLbULQJWwLulnocfq6u30/nuWbmVyV6QhDui6JN6seXfMuvA2W7938pKeOsW1a8nPtQtj/8zPc5gPCSmriTu46KOgLlqZEMgvV370lAgf8MGg8ODhMHBg4v5vrJb3/4ZUut7XxoNbAsZsZOjp5K/V+T10Zqboqxf4R09q2ZG9ekOUENDE2tPiDMlWfE6oxNPSmgBDKj782Vd6npfosa96ZkhkR5/eUFBbozjX29iCyceEWLpRNN+lJLZwGrjCxWkpTGjSxA8GyMmsb1qzqtL5NR3qvh6C3vscIBP3E3nJXWW6LA8JbakWhop+LPbiE3E8J0OA+GHJtAScOUNfanzyFmq5oPFSSJ2X8UQHNEEQlJ853Huw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register a live update file handler for vfio-pci device files. Add stub
implementations of all required callbacks so that registration does not
fail (i.e. to avoid breaking git-bisect). Register it with both live
update framework and PCI subsystem.

This file handler will be extended in subsequent commits to enable a
device bound to vfio-pci to run without interruption while the host is
going through a kexec Live Update.

Put this support behind a new Kconfig VFIO_PCI_LIVEUPDATE that is marked
experimental and default-disabled until more of the device preservation
support has landed in the kernel.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 MAINTAINERS                            |  1 +
 drivers/vfio/pci/Kconfig               | 12 ++++
 drivers/vfio/pci/Makefile              |  1 +
 drivers/vfio/pci/vfio_pci.c            | 11 +++-
 drivers/vfio/pci/vfio_pci_liveupdate.c | 80 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h       | 14 +++++
 include/linux/kho/abi/vfio_pci.h       | 28 +++++++++
 7 files changed, 146 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
 create mode 100644 include/linux/kho/abi/vfio_pci.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 347c435ca404..77a35742de0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28329,6 +28329,7 @@ F:	Documentation/ABI/testing/debugfs-vfio
 F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
 F:	Documentation/driver-api/vfio.rst
 F:	drivers/vfio/
+F:	include/linux/kho/abi/vfio_pci.h
 F:	include/linux/vfio.h
 F:	include/linux/vfio_pci_core.h
 F:	include/uapi/linux/vfio.h
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 296bf01e185e..c12d614fc6c4 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -42,6 +42,18 @@ config VFIO_PCI_IGD
 	  and LPC bridge config space.
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
+
+config VFIO_PCI_LIVEUPDATE
+	bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
+	depends on PCI_LIVEUPDATE
+	help
+	  Support for preserving devices bound to vfio-pci across a Live
+	  Update. This option should only be enabled by developers working on
+	  implementing this support. Once enough support has landed in the
+	  kernel, this option will no longer be marked EXPERIMENTAL.
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
index 1fb4b276afe7..439d14d79d8f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -264,10 +264,14 @@ static int __init vfio_pci_init(void)
 
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
 
@@ -275,12 +279,17 @@ static int __init vfio_pci_init(void)
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
index 000000000000..803528c9f1b2
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -0,0 +1,80 @@
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
+		goto err_return;
+
+	ret = pci_liveupdate_register_flb(&vfio_pci_liveupdate_fh);
+	if (ret)
+		goto err_unregister;
+
+	return 0;
+
+err_unregister:
+	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
+err_return:
+	return (ret == -EOPNOTSUPP) ? 0 : ret;
+}
+
+void vfio_pci_liveupdate_cleanup(void)
+{
+	pci_liveupdate_unregister_flb(&vfio_pci_liveupdate_fh);
+	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
+}
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 85bc1666cb0e..5d2ad128523d 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -142,4 +142,18 @@ static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
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
2.55.0.795.g602f6c329a-goog


