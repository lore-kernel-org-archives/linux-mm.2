Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B369C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8801A6B00A0; Fri, 18 Sep 2026 16:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 857616B00A1; Fri, 18 Sep 2026 16:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76CB46B00A2; Fri, 18 Sep 2026 16:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32A5D6B00A0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:07:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AE691C3120
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:04 +0000 (UTC)
X-FDA: 85227966768.25.B4581D9
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7479B2000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pj9jXCGR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 35ZmtaggKCCwLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=35ZmtaggKCCwLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762022;
	b=WtQh5spVaCYEGOv+cSfWztb2dyApwlrU2xOSrFtst+DaIdxmzOmqKR/UlFRyYzyeqDniPy
	J1Br1qVTdklpV0h+finkBeNpsXjuEl3oesH5DAzfce5UUA+hb1B09erkq6Z0qR9jYp0VoF
	oQyQNT5JiLDK6WOgtyypCx7tAI6rXYc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pj9jXCGR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 35ZmtaggKCCwLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=35ZmtaggKCCwLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZcqrsSF0ioZzw9gFyyhQYx/Js3WyQJlrd8b2TpGaYs=;
	b=Dl9jkHoYDcmrgjhnhATz+t0ae96yl6lWMnPmkrk8b6/f0N105j3Xi4NE53nGi5hBaPP85+
	DsxpnzKfo8HfK+KMDrEyFn4yrGMxcBXulFtpIci20nWTVh6NQKwEpEY4o41UvNkYDhDRtR
	ognOaXDFl9wgpeXsSwjkmU/Viw758kc=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1cade6b71so1140415a12.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762021; x=1790366821; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9ZcqrsSF0ioZzw9gFyyhQYx/Js3WyQJlrd8b2TpGaYs=;
        b=pj9jXCGRC66Gs38vkkLm1FRIwln2vNDwSQauUltha3YZURsCBxLKd98/oarJ6Q7vzX
         RALoJ/UX8uCAKV4ibQz8P3WmVf9aJd49IoMCCsgWqbUHGTehxEyoASLXnc1xYnfB9TZC
         KPs9VX0GRhq2nw6d+xi0r8VuoqK1kAtWmVgOcqr9cL1uxFqDxMRwV7lD6Lp0L3u4wrpM
         VDQmqrOT6MyPK4t3xx6pzFq/vHnA5grmxqVfXgO0ObAWgKqHHZE9RF5Z5aILhE2jDvfj
         Ov8Oq/EIdrtCEwUXNEwl1MRy1X3LKBfQJDsn2gOMJKslICd/PsgynuvNQO3hSRAu23ue
         tUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762021; x=1790366821;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9ZcqrsSF0ioZzw9gFyyhQYx/Js3WyQJlrd8b2TpGaYs=;
        b=dsQBOgBYiwUgibIBt0Ss8irJqtV5eXpKlzHxtJK61/bhuNKdymaIBzFiPMKIRJ1tQX
         bKNAj5G+14jydYvu5ppoN0cdfxAFJXIQ9mHCEW0K3VtqqjLysjXLnG1J5tkDA+t61/Tw
         5Hwu2MzjS0YbEJa6Jk+kGpLtM7SaTLlmKNag322iMylMDDFJyURfsL9d6wuV1ceM4klW
         57iH8hDWLB9AVhkS4IQ6sQiRH1ahtJ96YUJ/5G56Wn81TDop0qGnw+1Dgp0pR2D5Z5eF
         TzCfR41HgT8+LS+jXKpE+8L72lx0dALho++RsvqGFvonEg/xqQnNgvdrcsMK+LbMegI2
         mNyA==
X-Forwarded-Encrypted: i=1; AKwUvBzh+64ox/Y5fEG0dzQ3Jxqh/iqzKmbVLlRdqFB2lqbbUqtHuXkp98d8XUZclBxnPKDnsINtJ0ocsA==@kvack.org
X-Gm-Message-State: AFuF++mLATv5ncTTzxvty4e7CLtGeeS+BQbWZz4KJAOQjY0tmSQKQh9Y
	nEL1iS/d2kO2cEgXhNOBEMqL6ucPoyGurWWZqfaGMf7pMzv9R1KEdT43cK8mR2B1JnQ6SN9eKdd
	cJ56+5ASIA1jPcw==
X-Received: from pgvn14.prod.google.com ([2002:a65:63ce:0:b0:cc1:bda2:d0a3])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:7017:b0:3c8:e304:99d0 with SMTP id adf61e73a8af0-3dd721125e9mr11870192637.0.1789762021113;
 Fri, 18 Sep 2026 13:07:01 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:35 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-10-dmatlack@google.com>
Subject: [PATCH v9 09/13] PCI: liveupdate: Adopt ACS controls in incoming
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
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7479B2000B
X-Stat-Signature: r9yrnfmth93zho4ibfqts1g579zbqsch
X-HE-Tag: 1789762022-174950
X-HE-Meta: U2FsdGVkX1/m7gxjyaX2x3hZPF3UKf2v9AB5/aJFRxX6lvqyjbPigDZtG/LTCSYxK3cX4+xKvI8+FK+wnFKXWUBKqvbhll7mjE8HSlQKJyj+2lvcxIhV/NQ+WwHC6DwOoBD93bcgN8zgeJCfJuYbmPOQuMFkX9EzYXa8GELmlgwa2afT8vYMmBAp3Rtiu1AiDdeBx6ycCAHUkFkxb/7+tH+9KmB+eBDOZxXipH2zM3hYHcuA59X9JXiex+rm1UHjbp+GFgspEH6QdtAtRQu5TXn/FblUt0t3WsFP9BVjjtVvLbWH3egBfvIHDlMqqKBnpcTp43gDAHWlX6M/oPjtSdObGNpwkhO+MB6KEbmy7SBv37U3CmRz3YDmXe/AvAVb4vrNEUV8qR9lo3/UzuHn5t+c2O1B5AwprxnXf3DdFn/nyDBNB6ukOGbI1uoUqaCkBq1FsGG7v1gWlPbs1PZ/vnv9BtGMtvbWXshS5zlzdxmj2HkzDWLRNPsX99zh1BjOck60ZzNqDeoDDXhBwCvpmF+xGbf0BF1UhfzZe9gM6Sebr2FfC5VBs5J8L+uzoDXe3R19xo2BBei5ttJXCFHG8sxldY2WYTC1k2h7estJ+HQ3aIxWre1fAPHNgz4CZ1oYhKCmwRDvun4oI52lyFk/fgcfR4rZMS2Z2S3UBEOX7s1/t3ARx548Ig8FRXiTRL374Ydh5M5kUX++iP4IDPuaiJU7S1K8M4lsBQ8D7gzLYXd1OevIByuWkzgNZF9zxLKJb6rqOofQ4FI2Wbv7SqD0DZU7hCHXKRTP0Pm4LmTEdnKVRX07Mnh3yfYAgQQbca/XAXQlNsxKA2IDov8nCi5Ac3QdhOx8UCJQVQ2RmgjOj13pmLxZcKpBLWFJxWO6a3FrnR2yNijm6gLu5UE3DIf9IR1J13atgBuCj10ishb5tKqj+lDcDjqDZ2yguaKmrm9N1rtcI9nIXUdLmr6fszF
 SjG934l4
 vHyAL1CxH9MPUweWh+kyR9zBtTg5mf6du3CcthSxQ5u1TwrbbpC370B2mWD7lt8TzMPH9o/mqDRvk9+mA1/gJNWCKRfURBT2ha87hFC+JERPV2gOYwso39x51EFWf3WXbd3z1NkwDAPDSPqC4DdZCGcEb/XbTDVx1DEu0P5yEdIoZQ+B5nb/6je+yqS996Dy6ckQ+H3XLt0JV3EfYopEga7ZcEF1+f7lDgzolP7GflpSqIelvip8/ojYeIq+n66zRVOVntZliRFoQs3ApBSwGHLeDmxnpLXzPPtfguUN6MsfyYD20ZkXYt4GaVhh30WiLsAjsvdBlnmORbqouAUOE34D3HauZYC1hkIkMOZQ9/zkD2Bzdtxf+RO//V8hAylMsMSe2178KYa4JuJmkaBXzCL1jopdSdb4YKICPPIQc44/xNZduNO5197Yq5hLuyRop29gV1OcISXoGgn3/qgqUbogD5qLYk8h6shvs3P5kUMmR5Obtvpvww4Hw2Utur4qnzCkz6dw+KQklxeSsXS1C8eklR+C1bii5bY6/Sv01OlAYLch/RUtpt+MjAY8ji3zvfcHTRlhVYhKzMUvfjRfJffDsD5lBk4bpBDCoAFyww0Si6BXnRwlpDbBv2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adopt Access Control Services (ACS) controls on all incoming preserved
devices (endpoints and upstream bridges) during a Live Update.

Inheriting ACS flags avoids changing routing rules while memory
transactions are in flight from preserved devices. This is also strictly
necessary to ensure that IOMMU group assignments do not change during or
after Live Update.

The adopted controls are recorded by the pci_save_state() call in
pci_bus_add_device(), which runs before drivers bind, so they are
automatically reapplied by pci_restore_state() if the device is reset.
If that save buffer could not be allocated there is nowhere to record
the adopted controls, and they would be silently lost by the first
reset. Program ACS from scratch in that case, which is a better outcome
than leaving ACS disabled.

To simplify ACS inheritance, reject preserving any devices that require
quirks to enable ACS as those quirks would also have to take Live Update
into account.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 78 ++++++++++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h |  6 ++++
 drivers/pci/pci.c        |  5 +++
 3 files changed, 89 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 686887a6c8d9..0145399b3834 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -123,6 +123,9 @@
  *
  *  * The device cannot be a Virtual Function (VF).
  *
+ *  * The device cannot require device-specific quirks to enable Access
+ *    Control Services (ACS).
+ *
  * Driver Binding
  * ==============
  *
@@ -174,6 +177,18 @@
  * bus, since the bus numbers of the failed bridge can no longer be read from
  * hardware and handing them to another bridge would let an unrelated device
  * inherit the BDF of a preserved device.
+ *
+ * Handling Preserved Devices
+ * ==========================
+ *
+ * The PCI core treats preserved devices differently than non-preserved devices.
+ * This section enumerates those differences.
+ *
+ *  * The PCI core adopts all ACS controls enabled on incoming preserved devices
+ *    rather than assigning new ones. This ensures that TLPs are routed the same
+ *    way after Live Update and ensures that IOMMU groups do not change. Note
+ *    that a device will use its adopted ACS controls for the lifetime of its
+ *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -189,6 +204,7 @@
 #include <linux/slab.h>
 
 #include "liveupdate.h"
+#include "pci.h"
 
 /**
  * struct pci_liveupdate_global - Global state for PCI Live Update support
@@ -502,6 +518,16 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 		return -EINVAL;
 	}
 
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
 	/*
 	 * Endpoint devices should not be preserved more than once.
 	 * Bridges are preserved once for every downstream device that
@@ -826,6 +852,58 @@ void pci_liveupdate_finish(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
 
+/**
+ * pci_liveupdate_adopt_acs() - Adopt ACS controls
+ * @dev: The PCI device to adopt ACS controls for
+ *
+ * For devices preserved across a Live Update, leave the ACS controls
+ * established by the previous kernel alone instead of programming new ones.
+ * The adopted controls are recorded by the pci_save_state() call in
+ * pci_bus_add_device(), so they are reapplied by pci_restore_state() if the
+ * device is subsequently reset.
+ *
+ * Return: 0 on success, or -EINVAL if the device was not preserved, requires
+ * device-specific quirks, or has nowhere to record the adopted controls.
+ */
+int pci_liveupdate_adopt_acs(struct pci_dev *dev)
+{
+	/*
+	 * Check if the device was preserved over a previous Live Update (even
+	 * if it has already gone through pci_liveupdate_finish()). This ensures
+	 * that the device continues to use the ACS controls established by the
+	 * previous kernel.
+	 */
+	if (!dev->liveupdate.was_incoming)
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
+	/*
+	 * Adopting the previous kernel's controls depends on them being
+	 * captured in the ACS save buffer, so that they are reapplied if the
+	 * device is later reset. Without that buffer, e.g. because it could
+	 * not be allocated under memory pressure, the adopted controls would
+	 * be silently lost by the first reset. Program ACS from scratch
+	 * instead, which is a better outcome than leaving ACS disabled.
+	 */
+	if (dev->acs_cap && !pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS)) {
+		pci_err(dev, "No ACS save buffer, not adopting ACS controls\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index e5d2a19d2ca2..d4721ffcecb2 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -15,6 +15,7 @@ void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
 bool pci_liveupdate_preserve_bus_numbers(void);
 bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
+int pci_liveupdate_adopt_acs(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -34,6 +35,11 @@ static inline bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus,
 {
 	return false;
 }
+
+static inline int pci_liveupdate_adopt_acs(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index dd25c01736b4..47d8229115b8 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -35,6 +35,8 @@
 #include <linux/aer.h>
 #include <linux/bitfield.h>
 #include <linux/suspend.h>
+
+#include "liveupdate.h"
 #include "pci.h"
 
 DEFINE_MUTEX(pci_slot_mutex);
@@ -1080,6 +1082,9 @@ void pci_enable_acs(struct pci_dev *dev)
 	bool enable_acs = false;
 	int pos;
 
+	if (!pci_liveupdate_adopt_acs(dev))
+		return;
+
 	/* If an iommu is present we start with kernel default caps */
 	if (pci_acs_enable) {
 		if (pci_dev_specific_enable_acs(dev))
-- 
2.55.0.1082.g2b9226bbc0-goog


