Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B040EC44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8636B00BC; Fri, 10 Jul 2026 17:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0306B00BE; Fri, 10 Jul 2026 17:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F926B00BF; Fri, 10 Jul 2026 17:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 215006B00BC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F1591C8B60
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:32 +0000 (UTC)
X-FDA: 84974151024.03.BD6B433
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf25.hostedemail.com (Postfix) with ESMTP id E76CEA0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FV7BKS3w;
	spf=pass (imf25.hostedemail.com: domain of 3hWNRaggKCOoPYMfXMOWSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3hWNRaggKCOoPYMfXMOWSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyFHddSgtH+5JtZtRXs5kryYSNhZjQ+wgfA9vuynw+w=;
	b=TFRwX9iW8zZ82nRS6HSEwkQBGHNvIOxaz6TLOD3QIOcy+fV2vRhSgSEpTu58PtKVn8YY2W
	rcwVwYPu3DqlZnp7i2GUrUeNJ+tU66sh32oHK6ccsQxo4EJMUBeM80AKe4jUmsELvECDZh
	I2TTjzth476r12Nh58kK3izpyLNB4L8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718790;
	b=nA2Y0m7fn5rURjapLyBrfc1GeygxSpH/4IncgiHmIsHVROIkfRj3olD9Uu50YTPNYfLnmU
	qHs2PEpqNpjZ5xTEiyal72oVG4UMbCguvDFMEnMTsPH63O10YGdvh2/s1DEpWfro3cmnd7
	BXTMPKWiFRuBnzGZ34hwgxW/FvDS66c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FV7BKS3w;
	spf=pass (imf25.hostedemail.com: domain of 3hWNRaggKCOoPYMfXMOWSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3hWNRaggKCOoPYMfXMOWSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2cc88e22f92so25424835ad.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718790; x=1784323590; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vyFHddSgtH+5JtZtRXs5kryYSNhZjQ+wgfA9vuynw+w=;
        b=FV7BKS3wH2tO4HVskBgdzdWUAuP7NEAdKCg2e/Fjs/pCzbhOq7V6g04AuRhyZwLpXX
         PIfPa32/4WU2Ru/ccBTEPyiq3FbVo0WDcImCuz8LEw7JEH+xDbPAskjrCY5cd7Lh02Ee
         uqkO5zOh2Yn4+CHoZfm5l78G7UGpGardREycnvs4HV5wDd5y3tv6j/HJX5f/HLUIjaax
         S4jGb04G3p5w6mR+e0PpiLZmLXgXqtSZvg4cGQRivAHnL8A2O1buYzO1bo9VZ9Yl58K+
         6y1UMJMEZF3LqTmitImugpvsadsViyZwrxfDNyohQCug1/3SLF8+at4uXeGnCjcBbPHn
         XGEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718790; x=1784323590;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vyFHddSgtH+5JtZtRXs5kryYSNhZjQ+wgfA9vuynw+w=;
        b=kC5ACjkDbkMd41jmWkOLola3rwJt2TuIkIjON0DN5kw49+TkZvQPSsQQ8Tfgk7fqmO
         uATSz1nkYOSK5QcCcsLvMy7YKADmoY7Kr5Mrv6Z7oVBLUvgspYSC81lFbZj8Z16nFg9K
         rpclXjnLLOlCXAIEOqB7siFqtKtiObVrQbIZfylKIxqIRVfbAnPjmj/bPbYCJGBQsaiw
         yD00RwwsefrbYdOW6tXtMEmOVIL9fkxrp/zBqWheIOn+lVuJ3ogd4ygDJzl+Y7KNST77
         EiEXXEWyYhKFSH7+ABM14U7XSBlNmyJ5vtcC0B4TBcGvXzi8z1vwD/49Y5ohqXQgYfCX
         WO1A==
X-Forwarded-Encrypted: i=1; AHgh+RqzHpCrZ93qgZ51HiOkpV4hqiBtdMr4ODBzjHrIrFpAuLlrBskWWrEuaaEhmmlngsUs0BY3Teb5kg==@kvack.org
X-Gm-Message-State: AOJu0Yw0ua3XQAZ5z904aWTpNzME6LMdzXUSbZTOLlDLy6dc1We8CgUi
	oOfra56E9AwRU5lZJdTIBT814hraU7x9q49KRq10eeqpG3lCBv/GD9sYqebVNAA8XkGaBACdKcd
	LqqJP0OFLc4inYg==
X-Received: from pldd21.prod.google.com ([2002:a17:902:c195:b0:2c8:4c1:883a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:32ce:b0:2c9:fa31:84f9 with SMTP id d9443c01a7336-2ce9e9a6c80mr7580575ad.5.1783718789594;
 Fri, 10 Jul 2026 14:26:29 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:11 +0000
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-9-dmatlack@google.com>
Subject: [PATCH v7 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E76CEA0009
X-Stat-Signature: yy5mdqdwymg5k9dc9anz44nerb6rs181
X-HE-Tag: 1783718790-823085
X-HE-Meta: U2FsdGVkX1+JFMMKRgpyTy+1yydEG8OWgiI4zu8cw08vFEpexMZiNVn3esnlONXntYXk4u8b9ma0mlAdLZa3dUXAr1mzQHJeya7X2o91pOuKqU0xo3nZDh/U7GrQ0D99nmuzGl9buVEOMtdci159Oy7wl8j3fow8isGpNz8CvrxAVB8ds/AQaJ0f/+YBRFma4tzmCYRrJiheKqeJ/wVdjTQBm9UPU0Ro3ezgDycNAkzJyebff6aPQOP/0Hbg6b8FeW7xveEGQ+77YP+5lgxseSjt7nIGIK/9CLn7H3x6sGLO5ry8b9qwyb7JgSaB6qJ5/Qisscwn5+qXzF/ac0mNmLrzFEZ0RNpOYNEty24cx69wtfM/CEx0pv1PtZncQHZOoSVOb7RwD/HXPLP8/qgF3aQmYowxppT7uGNdmqTyknSuhlkXOjQT7ugmE6kUBAAjUW5paBlxRKZtJAIzf4XNai3RSfb6mk0EiwHoDqK4uHA1r2QQISKCwHXE7NXkweQ2n2kzkABwX1kQC1/Gjzlva5igqvNg3XiPkdjJL8RBduxJ+w2G176PRyj1aQbyXroYS1xNk2PPsMcpFFE6JdLNwzl9tAmi5ZymtSShqHsfVlbLmAVve6KC2VSz+m7iQbyx9RsPBGd1dBCZUyYzVo9KhugIs2xv6c1NdFrfYD7D2ponu1e7JZ4s++HwlyzXCZhn9JH7ahJaCZXgzKc6vbB0mqw5Jri0lqnEYqx2aRroNjKBhMSAeyqfT9TZ9ekGDcr5EoSgULMAvDkvpIyq7ghRGRZRrElnP8hzVu1U6lW4dMmhH6V6dCHm17sW90ZmT9NNPobuAwUsb3dHbA/ABlS253Vp5I684Nld7xic+2REmIRm13oYtinpwXwiD7evdFKtBRo/Zb5ipVcCgrMkvXwdxkYRuQoSVqlvk4F2917qckwzvsCwIp/KB/xnA8r1p6YKZr1zTxfU/FXoJSNpRbl
 5O/WgWE/
 +lQLLZ0aWL+H6SS3qqFJorrjZwXtQzhXAyUp5TIFKsOSxGbV2qoDYMEzBt7OoaEo5VydObYMdtLGRwy1wz56OgCf2SvVpj2LYmfeJenIrqrLVGF3TnI2GvbkaOnGriFdQcKNOG9VCdwmCJUIlBZ54kQhrWkMWDVT68m+3CR6kG3lvgFm37qZjlc9YP6FfxCDo3p1itcgVblPYSg0r6SpJKu+kCzXZoRZxUklfCJYrnVmvuRhReJaFrqFV2fDeqLTFz8ZNkjyumbIxhIwU57X460zVGIC7gX3bO/GwH745morUuHoi3wDLKVCIDo6OAC17Ak0sUHNxa3yCdeoVMyCfC1ol0p3vlqAFPza868Ltok4UfQoCpdpk4bPjT/L3DnHKAlktmQyYq3WS82DUFgvhhw3XXH9641I2zrpYOO/VnSrjz9yt7HSAK4ZpLmuHY5cxOYvJzKisioTcwhPTMiXApvTR7RU4SHj7K1aY8YAi3a9St6QHWTKOCzbnS+bkyfN+siOKyRfaADcpiB1bCVECIwaBHmzszoR2sYQYy7csyRHw8E0uBwUwRCDD77jD5CWDvVxSeoBQMkwFPJEmWalKVHZ6gBsNvq87u2Pk9fPreDYHeFYP13dGnhnuBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inherit Access Control Services (ACS) flags on all incoming preserved
devices (endpoints and upstream bridges) during a Live Update.

Inheriting ACS flags avoids changing routing rules while memory
transactions are in flight from preserved devices. This is also strictly
necessary to ensure that IOMMU group assignments do not change across
a Live Update for preserved devices, as changing ACS configurations can
split or merge IOMMU groups.

Cache the inherited ACS controls established by the previous kernel in
struct pci_dev so that ACS controls do not change after a reset
(pci_restore_state() calls pci_enable_acs()).

To simplify ACS inheritance, reject preserving any devices that require
quirks to enable ACS as those quirks would also have to take Live Update
into account.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c       | 68 ++++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h       | 11 ++++++
 drivers/pci/pci.c              |  6 +++
 drivers/pci/pci.h              |  5 +++
 drivers/pci/quirks.c           |  7 ++++
 include/linux/pci_liveupdate.h |  6 +++
 6 files changed, 103 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 7f7710cb1da0..a95bfe5eff77 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -71,6 +71,9 @@
  *
  *  * The device cannot be a Virtual Function (VF).
  *
+ *  * The device cannot require device-specific quirks to enable Access
+ *    Control Services (ACS).
+ *
  * Driver Binding
  * ==============
  *
@@ -113,6 +116,18 @@
  * This enables the PCI core and any drivers bound to the bridge to participate
  * in the Live Update so that preserved endpoints can continue issuing memory
  * transactions during the Live Update.
+ *
+ * Handling Preserved Devices
+ * ==========================
+ *
+ * The PCI core treats preserved devices differently than non-preserved devices.
+ * This section enumerates those differences.
+ *
+ *  * The PCI core inherits all ACS flags enabled on incoming preserved devices
+ *    rather than assigning new ones. This ensures that TLPs are routed the same
+ *    way after Live Update and ensures that IOMMU groups do not change. Note
+ *    that a device will use its inherited ACS flags for the lifetime of its
+ *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
  */
 
 #define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
@@ -128,6 +143,7 @@
 #include <linux/slab.h>
 
 #include "liveupdate.h"
+#include "pci.h"
 
 /**
  * struct pci_liveupdate_global - Global state for PCI Live Update support
@@ -374,6 +390,16 @@ static int __pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, s
 {
 	struct pci_dev_ser *dev_ser;
 
+	/*
+	 * Do not preserve devices that rely on device-specific ACS equivalents
+	 * (for now) since that would complicate keeping ACS constant across
+	 * Live Update.
+	 */
+	if (pci_need_dev_specific_enable_acs(dev)) {
+		pci_warn(dev, "Refusing to preserve device that relies on ACS quirks\n");
+		return -EINVAL;
+	}
+
 	dev_ser = pci_get_empty_or_append(outgoing);
 	if (IS_ERR(dev_ser))
 		return PTR_ERR(dev_ser);
@@ -655,6 +681,7 @@ void pci_liveupdate_setup_device(struct pci_dev *dev)
 
 	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
 	dev->liveupdate.incoming = dev_ser;
+	dev->liveupdate.was_preserved = true;
 
 	/*
 	 * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
@@ -748,6 +775,47 @@ void pci_liveupdate_finish(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
 
+void pci_liveupdate_init_acs(struct pci_dev *dev)
+{
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+
+	if (!dev->acs_cap || !dev->liveupdate.incoming)
+		return;
+
+	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &dev->liveupdate.acs_ctrl);
+}
+
+int pci_liveupdate_enable_acs(struct pci_dev *dev)
+{
+	u16 acs_ctrl = dev->liveupdate.acs_ctrl;
+	u16 acs_cap = dev->acs_cap;
+
+	/*
+	 * Use liveupdate.was_preserved instead of liveupdate.incoming since the
+	 * device's ACS controls should not change even after the device is
+	 * finished participating in the Live Update.
+	 */
+	if (!dev->liveupdate.was_preserved)
+		return -EINVAL;
+
+	/*
+	 * The previous kernel should not have preserved any devices that
+	 * require device-specific quirks to enable ACS, but if such a device is
+	 * detected (e.g. new device-specific ACS quirk in the current kernel),
+	 * log a big warning and fall back to the normal enable ACS path.
+	 */
+	if (pci_need_dev_specific_enable_acs(dev)) {
+		pci_warn(dev, "Device-specific quirk required to enable ACS!\n");
+		WARN_ON_ONCE(true);
+		return -EINVAL;
+	}
+
+	if (acs_cap)
+		pci_write_config_word(dev, acs_cap + PCI_ACS_CTRL, acs_ctrl);
+
+	return 0;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index c763255a8de4..4e8a01bcb4bb 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -16,6 +16,8 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev);
 bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus, struct pci_dev *dev,
 				      int pass);
 void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass);
+void pci_liveupdate_init_acs(struct pci_dev *dev);
+int pci_liveupdate_enable_acs(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -35,6 +37,15 @@ static inline bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus,
 static inline void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass)
 {
 }
+
+static inline void pci_liveupdate_init_acs(struct pci_dev *dev)
+{
+}
+
+static inline int pci_liveupdate_enable_acs(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 77b17b13ee61..739ecaab2e76 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -34,6 +34,8 @@
 #include <linux/aer.h>
 #include <linux/bitfield.h>
 #include <linux/suspend.h>
+
+#include "liveupdate.h"
 #include "pci.h"
 
 DEFINE_MUTEX(pci_slot_mutex);
@@ -1008,6 +1010,9 @@ void pci_enable_acs(struct pci_dev *dev)
 	bool enable_acs = false;
 	int pos;
 
+	if (!pci_liveupdate_enable_acs(dev))
+		return;
+
 	/* If an iommu is present we start with kernel default caps */
 	if (pci_acs_enable) {
 		if (pci_dev_specific_enable_acs(dev))
@@ -3689,6 +3694,7 @@ void pci_acs_init(struct pci_dev *dev)
 
 	pci_read_config_word(dev, pos + PCI_ACS_CAP, &dev->acs_capabilities);
 	pci_disable_broken_acs_cap(dev);
+	pci_liveupdate_init_acs(dev);
 }
 
 /**
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4469e1a77f3c..988a18b3204a 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1047,6 +1047,7 @@ void pci_acs_init(struct pci_dev *dev);
 void pci_enable_acs(struct pci_dev *dev);
 #ifdef CONFIG_PCI_QUIRKS
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
+bool pci_need_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
 void pci_disable_broken_acs_cap(struct pci_dev *pdev);
@@ -1057,6 +1058,10 @@ static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
 {
 	return -ENOTTY;
 }
+static inline bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	return false;
+}
 static inline int pci_dev_specific_enable_acs(struct pci_dev *dev)
 {
 	return -ENOTTY;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7ac39ec2843e..99b819f38e49 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5473,6 +5473,13 @@ static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
 	return NULL;
 }
 
+bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
+
+	return p && p->enable_acs;
+}
+
 int pci_dev_specific_enable_acs(struct pci_dev *dev)
 {
 	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 2be98819e313..2446c6d237ca 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -17,14 +17,20 @@
  * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
  * @outgoing: State preserved for the next kernel.
  * @incoming: State preserved by the previous kernel.
+ * @acs_ctrl: ACS features established by the previous kernel.
  * @inherit_buses: True if the PCI core should inherit the secondary and
  *                 subordinate bus numbers assigned to this device due to
  *                 an ongoing Live Update.
+ * @was_preserved: True if this struct pci_dev was preserved by the previous
+ *                 kernel. Unlike @incoming, this field is not cleared after
+ *                 the device is finished participating in Live Update.
  */
 struct pci_liveupdate {
 	struct pci_dev_ser *outgoing;
 	struct pci_dev_ser *incoming;
+	u16 acs_ctrl;
 	bool inherit_buses;
+	bool was_preserved;
 };
 
 struct pci_dev;
-- 
2.55.0.795.g602f6c329a-goog


