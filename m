Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B520CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B446B009E; Tue, 13 Oct 2026 12:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419DB6B009F; Tue, 13 Oct 2026 12:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292AF6B00A0; Tue, 13 Oct 2026 12:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2ABC6B009E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64A1880D13
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:48 +0000 (UTC)
X-FDA: 85318129176.23.D825B31
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf06.hostedemail.com (Postfix) with ESMTP id 989FB180003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="bTZXs/SU";
	spf=pass (imf06.hostedemail.com: domain of 3iVvOaggKCNY5E2LD24C8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3iVvOaggKCNY5E2LD24C8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908746;
	b=gVpzA2h73ikAEcxrMmyOD4eNgLURIYuFT/6ClN4PMNSUeMTrlVm+FDa77+pgUQDf0GiZi6
	KjMnwbCzzYNS29uR9ruH0qVy4uqF8PHnMvDzu40MTJV29MYiTRyDAqhRvchNn9zFMlK+va
	bscAoYEpSZP2EdSSlcGN/B+rFDnR7hE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="bTZXs/SU";
	spf=pass (imf06.hostedemail.com: domain of 3iVvOaggKCNY5E2LD24C8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3iVvOaggKCNY5E2LD24C8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMZY6hne5ICVXiyWI18wg5NrB0TiBOxG7wJ7j+K7UmM=;
	b=moZld3+zlSOcVG1ngqJ5FEbWHR4YkV8nQjKZLuaN00kiwaFC8l8ZQ3UXta8yF7DqKqFo4R
	FE0hm89NzqtM/JRcKxoqQg3d95VEJX/KCg5EWJgkX1/52kfIlY8KI513m5weSGC/wb8pfa
	E25qM9saoxty3iF2ZOy3oGbQq/LwIAA=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ccb687f82eso30880035ad.3
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908745; x=1792513545; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nMZY6hne5ICVXiyWI18wg5NrB0TiBOxG7wJ7j+K7UmM=;
        b=bTZXs/SUNaXVqxkvwbGkYBqisRTNSiOPFq2riAlN8pS/4lGKKyZsXwD8G/wzqDZ3sS
         J4qZEnri2Yt97ys0L0O8O/+tM5IW+2b+/c51BRnQ8vcnL52BslIvr/vZBameQcjx8egK
         eF8YjrBRyepNji9wAqwdfpiRj5JoIofBwdDJ2vtrMjUX3vK77xWFMxm1znMoqHAYhKke
         891zrkYUuMaRZSW7vpMQTpaKvX2tZD4NazDI8LCqt52Tdor8TIaEHKZGEIp3T6cPmYSf
         QLXm4M4XJXxJgGW/jIh03YY2Qkuxtf1hgQG2EVHlx+AWVqZsm8FdGoyksgQwfgqePXrm
         +7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908745; x=1792513545;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nMZY6hne5ICVXiyWI18wg5NrB0TiBOxG7wJ7j+K7UmM=;
        b=173zx/GDBJZ4o3oUlfEzEj/kG38G4SO3V9ysor5qMZn3Fp5bxdyJyHFQKft0infVHY
         50N1/SRzv5EHGn8YwZnBLBB2udLnUeObQj+fZRCWT3OlTZ19jm197TOmCamhB9nd68mZ
         59s+aGOnJC0mvkyxOldskTGWwuF5Rq4dELgMckCK98x9gjaybHv0lx/zsHkb58ipvBkn
         9keAJswJlIRvSsqhNBeoGt2FsBWHbITRxXqhy/X/0Hk+lEFdhX3z4Jtfyinl50fKSG8b
         xrMM7NnWNCjU5oerpmSViqS3RHdsNLckY1CYoYYW9X1KHcCvFcIMEIpaK6/A4GtPh4G1
         Ly+w==
X-Forwarded-Encrypted: i=1; AKwUvBxQE8B3d5sF1cHthqel/709LeXSn+kR7Cv29EbZgljnexDxx94Mq4rxzLcx9vxLuIhrjCnggvNtVA==@kvack.org
X-Gm-Message-State: AFq9FYIx2jIIvS6EhopluIVOgFTnxaWusUu+vldUewBnEW5mR7dxZ7uy
	MPRIXqPB1jQUjW51vbdDkx+jxYWwrOcGO/IQwWQLoHvbirCH1/IftVrzHSHZXx6sfC1rxAl8tT2
	Pw0ec9jYuEfQmUQ==
X-Received: from plgt1.prod.google.com ([2002:a17:902:e841:b0:2e4:cc48:2a25])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3550:b0:2e5:cb9d:3207 with SMTP id d9443c01a7336-2e842805bcdmr115538865ad.1.1791908745197;
 Tue, 13 Oct 2026 09:25:45 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:25 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-10-dmatlack@google.com>
Subject: [PATCH v10 09/13] PCI: liveupdate: Adopt ACS controls in incoming
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 989FB180003
X-Rspam-User: 
X-Stat-Signature: dkhjwqsgapthfh3r77z59bsqie6zpedi
X-HE-Tag: 1791908746-746787
X-HE-Meta: U2FsdGVkX19qh/4U6mxn19MHgfH3EmAIZ40X2qYWkJy5EQHfS83lzzKk3Gj82Cc56OSuN5dJVo+1v8mpzCQwXP2xr0GOa40t7ru5w+XK6Ng/i6yemuDy07PUse5zQBSIQcBbL293ZhSv1QG7ThHzqSgjqC02rbWCzi7b4XVM/+h2B5pW7G7aTfXw7GqJq5tn+0CYkG/JRxE3mnmUZwyoThBaZ2aiKv2tfbZIStDR+D8hEhWc7jQZVIun1zS/bLD7GAFaFbqIjYi8IQO1mNgOfxZwFEGfmgw+gvXp3DmlObJDnDaTBaic8gcHft8dGQfGYbnHMCZUiL8qI+keRFKUQ5kV9/eUv+8FHyqrkNPG3nmB43AIHxPpSABoZ9de64pPSOXJRiLs6zQbU+m7SZcWnGD9RXox2si1tCAVfWSeR0xRa4v+7LVf0bj0R27BXoqJvuSO9V3VFEBVKeqkOMCOBAmhSvC/5Gz0s1n5ArJv+jRokyco1hQd8Zg1O8EN0uIlYbrNy93Cr92CbhGlB0hx3P0tjPz4US2vjTZcxeSumMv3jxBUvKLtEtVzP5C6HV5LIgI6FNj9PRlf4Ju7TmHfDZ/mtaz5uM5qk4ppjFOQAA764ORmyfvm/ZlSuHkJvbR/HQR76FdO6cujJNRTmhb1GjThmIWRcxSRVQsCAo6KBMa4WzOK/xKmZwd9T8i/VZamXnpkM/DM4JgDJe1i2e3ricOWFpwE63VPuKPJnNKmp1yRTWf+6Ajnfy9ckbEk7oOJRSZmw45C+hbYdfzvyuVmNe8H0TX3F3UT0AU1A6coHIAfWW3dvqLJlWCydHmsVOMun9xhIsBCuBa83HqxUDgd8HOtHV6qUvDgns7eDzvjSvJLGXj+0ptLXR6W2VlC7ZCKip4R2pKW7G5pSKmYtGgLrPHPZBt2evEnCI0ZsShtT4V3rBE37E9qt3tP1/T/EztTQJq8Il8UHsKsLm0acTk
 6sVs3FNR
 6K7XK3z64ZuUssp6jDIajGZ48fQwbdboLwO5McBxRkw5Zvs+x7lBwdd1jcnFuUdp8pAJLvRSyf8DGuHM42Zx/zOFWVCqz21FXgSujMEDnXduNFrn+ULXQ6VHZMLiIwBOGFitnzJHZwytlqSclhyjWD/4TO5PaSjiL0z9ZG8LcBI1TwuBQ6I6mv/ZuZlNF/VD3SQg+EvPQnczBtX+p4LDQTpcV8llfjFxeZD0U7Z/cziuEi/Hg6DUbVLW/0R4314URBasR8gBNyTJLIDqXbAyI7JJUMJKDBD1/utBerOlBL8jqt9TaKdzxc+LjqRRBgNgrPpib2zTM49YWmFa1belZOFQsyQOcUSCyuSCComse68pRUSWxHrKWA/B0yAhL0+gvbMfsfB7ewp2TIc9wLhNgHZBaN14SYKjA7xIgZdweYMe2nWUHCFcTk0DKZSUea7MNeAs5covuVVC3PTVsjvLjphGV7An7d5WYGOHxGos0wvGeER9RLPXpVmNFOpusPQGtwlv88PEZZoETR/pmubY2MDvoLQymvnnyT5BuG8bW8XlrvX5WtgnKrZfd+pRVlnDj2hq9HVErhOe7C69xRYorrVbZn/FaTdn6WVrmuoXsCdgTtVpIK4/3d2gc0A==
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
index 8d5ad26e948c..1d2324d339da 100644
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
@@ -520,6 +536,16 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
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
@@ -844,6 +870,58 @@ void pci_liveupdate_finish(struct pci_dev *dev)
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
index 944590fdef48..650d7f92f93a 100644
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
@@ -1164,6 +1166,9 @@ void pci_enable_acs(struct pci_dev *dev)
 	bool enable_acs = false;
 	int pos;
 
+	if (!pci_liveupdate_adopt_acs(dev))
+		return;
+
 	/* If an iommu is present we start with kernel default caps */
 	if (pci_acs_enable) {
 		if (pci_dev_specific_enable_acs(dev))
-- 
2.56.0.385.gd3acb90ef8-goog


