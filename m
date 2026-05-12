Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B95CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91096B009B; Tue, 12 May 2026 14:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40B56B009D; Tue, 12 May 2026 14:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09366B009F; Tue, 12 May 2026 14:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6EF6B009B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:49:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E908A05A4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:49:01 +0000 (UTC)
X-FDA: 84759654882.13.20E0AF7
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9F30EA0008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gAxXdLLU;
	spf=pass (imf15.hostedemail.com: domain of 3GXYDaggKCGoLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3GXYDaggKCGoLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGo/6CdqO8ibA5eNqLaT5PlJcsuc1WV9zdpDClCuOsU=;
	b=1lcJRY99IrdJkvn2D4Q1o/KebsLSEOGvPRIFxwsKaoqZkRHSAALlihwPk4oEbxkH/q3+gi
	clKT98JJZhmL8V10FGRAH/vgH44dluk9HZEGDUn7cMkKdc+tTHTcSSwipVkW5IO6oJNnXA
	czXIWZ4FvhZoNfjUATfYqk3EeE0K1dU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611738; a=rsa-sha256;
	cv=none;
	b=vmfm+aCHybEEnFxgjFLgS9tOqgGeSW5Xn3YliXaeeHlh5XFsx+y8Oc0wfyGx1/ilgRARr4
	o2eQ3poYNzgJdINsenDqQC/Y5iIBi/oRWza0CfxzH6XKa+qa2QZ3pku13A9u/vldYG2jft
	aLi3fnAkA3nXnEfywbHPr+OBBt5X5vk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gAxXdLLU;
	spf=pass (imf15.hostedemail.com: domain of 3GXYDaggKCGoLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3GXYDaggKCGoLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-36642d2f4deso8325893a91.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611737; x=1779216537; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TGo/6CdqO8ibA5eNqLaT5PlJcsuc1WV9zdpDClCuOsU=;
        b=gAxXdLLURc4Hz0qq783CWJYK6BXe0WSTIdFXC+p6w2TrXN7s+4AksFEHQCtFhfHqv0
         h6V+dI84PrvJ3B/ZE8xD/uqvyxHU1pbFQRVkyFaluXSAwTw/hUZRS4P7nA1Y8zib0a8X
         GmVKC/F6TFELoGajsgTf8+evvdBKeg75coCuY5oJYyWIGaD8bxwDcQ33WfpBR3+84tji
         7uOXP73KC4VUKCP493poJXkWTMMu1eOFusQMfhiREozuQhCBKuiUSuy+NbTyz/sl5nt1
         cqDjBX/4YAtIrvILXXnjvJTm47KKLmqq8YN28DUkB/qUVWNo1YgxIp6xykuIoiiNWSmS
         vQQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611737; x=1779216537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TGo/6CdqO8ibA5eNqLaT5PlJcsuc1WV9zdpDClCuOsU=;
        b=Xzp3BI8hHPM2HUF3DN3rLC1HGvxBVb/V0QVgKOhw8SvgMJzbYze1VR7vkwMbeI/i+z
         HCCwuxUEKqulygvFq3SHh5cQb2HlJkc5HHOFsSvqp9F5YQubuf1+DbPIeQOHdPOU05aA
         mvqq3HDSYmGFKfrR+zTCH5oSlSeaPsYNce5yfUkhUYIAAdEtDfNcV0rEsWO9PAjk19pB
         3B8rLF48ayO/Gz16aeHr1AoA8qGfjZ2JIjVwF4AehDhUs69wfpNIaAKkhmZTa7vMUIBr
         QqULDzsulehlg33klfd6Ntp5DWMENmpvetR3DkHA80/T5g/DPUYmcE7GT/btS/f6+Dvq
         YiHA==
X-Forwarded-Encrypted: i=1; AFNElJ9OB+TvackhwJ/qN2pCace3bYCGVUaMqbaH4HvID50ToUA+emFYiiZu5xToLp7Ig2q0RxWDcdIj1Q==@kvack.org
X-Gm-Message-State: AOJu0YyFzgUpvTRhQqdXAfd0gvtSF2YZkCwxrRghvPPX8yAZ41tcxrmd
	xH6TCuCBTIyGque96AhZEGxGN7DtgvMFxa00j7B7W7GNgmnEmpJ/c7XdKW1SkENYgteRkivyoAY
	TduosSnvHs+gnDA==
X-Received: from pfblu4.prod.google.com ([2002:a05:6a00:7484:b0:82f:7d56:a149])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:9995:b0:3ab:13f4:c71d with SMTP id adf61e73a8af0-3ad991e88d4mr5416489637.33.1778611737089;
 Tue, 12 May 2026 11:48:57 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:42 +0000
In-Reply-To: <20260512184846.119396-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260512184846.119396-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-8-dmatlack@google.com>
Subject: [PATCH v5 07/11] PCI: liveupdate: Inherit ACS flags in incoming
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F30EA0008
X-Rspam-User: 
X-Stat-Signature: r9ku8ayhjyri8549hjeudhm4uh8bneys
X-HE-Tag: 1778611738-192524
X-HE-Meta: U2FsdGVkX18WtPQWZEXiG2TnEj/aR09/kK0tIYJZW1QtXjq7lDrtAAsJ51MyNM6k0EscUOI16lFEmqnF5CIzYSDymAHzmYhNjtHwFyK7UNb0+xTqLgLrdMAYv/d118USTL7bYjhYFuEO119eToac62WKQGZkXkTyzQ38SCrGI/6uJRPnzEuYvPV2GLtcbNJ3vPI0/kdmtqgVsjGV9emE4rbQRE9tR7fQ/NQZVW7EnfmPzLV+MK/whwFIDsWInu6povVqKJebowBwGh6gq6KMplFjOTZHiamGaFp99Kdjj1pgdpRg5rfv7ynaK/lSVRwV5GJJlzTj5e+oKQuDZ7t/zcdCTsAS2mPG3T35W29okqc+aEMpl8TfsyJQA43kGSDytyZ4nXfpLSCVApNTII8RTL1Utn86JQiAfyO5u6ahK5RlW+msQaObk4MbQCIU///F4R+r+axicU2+1fLhGvdLaQGo1Dx+vxdMpRIkMXdr50sSRq9BfRkTM6J61dF0h8ptD261q60DQB2Vl/3eR8wEwrzVQmzo6Tinxjc3d6269WpeiiqLSNAMvCtGoOwRA7heE/NtPh7nMrsnMfvDvn/g7gecgJVpRSANT6GUF5H9akaCD/E4AlF2lfNz/lzRJfoJKoNkGGx3GeSIuKZhJHukTCr5yI8zmaEDTZHw15LL4qF6VsGWtGQgQYsi7j22PzmUfq9DUF3Ckh7TTj2Z2dNZ1s34CtIrL8a0YHBAjqZqKy5kkiydDz9IWkytpgN6uZ4ZfE9lG3l+Zaw5X3heq1UMEXBmFTMLVl2wEiK6frhvxBWVDgmY99Nfzrrk3/1tN6ot8T5I58/g2GCvN0NmbMfXX1MHBNlu25F0zUFON4j7r7wZBSuxOOJmUV+sp6Dak5VkjxywcO0AhQwrB0bXc4t09Mg8NhTSDIvnmxP4Ukf/R8bsMk2dihdidF47CpXOlnRdewLyBgfLBE3m1bLxCW9
 /y62A0Zq
 IDR/o0vbHfwGLXeEoHMX4FaM52vZQj5rVM6mowkr5yDPjYlhptfWGwLH1+1D9T+Z9aD5DwXhRQ4n7kYzYjTyGFJW2z5HPX2f+FiXqBt3m6nDnZPxEFDQ7t5Fv24CJdIO2pMGcFeNEINuAqyXTih6BnP/tZbhzFeRXBJeABXnTYicKO2vEVuNF6T15SswIoAGWmMVWPW7sWgqweOT9WLsqDear369QuzFj3yPp2EqyMpyO6RVL+QJrusinQYx10MTlJMVi0QeagkZ7pNUmhh1iZorxz3xPmFNDBXCUGhwblzIf7I5Z5IL75LEAtGWaO8ZhZeZFAnDqzOG1Or3iU2lrvHMRsWDEZH9F2SpVmsFVKbrUx3LLONxIDVRJqqBQIZgBVKgm2SBwVwdGSkxXR+spB63pnBv5yt33T/SjajmGZI8a2BckUzlRuzFss5OvwfnTQHaURobdkuU6ilqmCudV3w6jdhKX70qddT1VNo1LdvMvdzVN7zMVNLxOQ6p8JHoHIo8Yj93Yh7Ik0wdL0vHIp61fH9k2j2s/z3OQx7OT8vu1mIWS0uwBcRM1C5ndrmKdbOE5iHuAl3JqUEgD0E0vorLK/+XHDMK2/tnrDHX4Z2QzkSaUgz/8Y/ZNQn5BaVx6gR66iMgd809D7+4=
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

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c       | 49 ++++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h       | 11 ++++++++
 drivers/pci/pci.c              |  5 ++++
 include/linux/pci_liveupdate.h |  6 +++++
 4 files changed, 71 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index d8e06afde2c7..e3cd6d76636c 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -120,6 +120,18 @@
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
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -361,6 +373,16 @@ static int pci_liveupdate_preserve_device_new(struct pci_ser *ser, struct pci_de
 {
 	int i;
 
+	/*
+	 * Do not preserve a devices that rely on device-specific ACS
+	 * equivalents (for now) since that would complicate keeping ACS
+	 * flags constant across Live Update.
+	 */
+	if (dev->dev_flags & PCI_DEV_FLAGS_ACS_ENABLED_QUIRK) {
+		pci_warn(dev, "Refusing to preserve device that relies on ACS quirks\n");
+		return -EINVAL;
+	}
+
 	if (ser->nr_devices == ser->max_nr_devices)
 		return -ENOSPC;
 
@@ -571,6 +593,7 @@ void pci_liveupdate_setup_device(struct pci_dev *dev)
 	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
 	guard(write_lock)(&dev->liveupdate.lock);
 	dev->liveupdate.incoming = dev_ser;
+	dev->liveupdate.was_preserved = true;
 
 	/*
 	 * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
@@ -671,6 +694,32 @@ void pci_liveupdate_finish(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
 
+void pci_liveupdate_init_acs(struct pci_dev *dev)
+{
+	guard(read_lock)(&dev->liveupdate.lock);
+
+	if (!dev->acs_cap || !dev->liveupdate.incoming)
+		return;
+
+	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &dev->liveupdate.acs_ctrl);
+}
+
+bool pci_liveupdate_inherit_acs(struct pci_dev *dev)
+{
+	guard(read_lock)(&dev->liveupdate.lock);
+
+	/*
+	 * Use liveupdate.was_preserved instead of liveupdate.incoming since the
+	 * device's ACS controls should not change even after the device is
+	 * finished participating in the Live Update.
+	 */
+	if (!dev->acs_cap || !dev->liveupdate.was_preserved)
+		return false;
+
+	pci_write_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, dev->liveupdate.acs_ctrl);
+	return true;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 0bd3e961d5c5..c0826ca717e3 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -14,6 +14,8 @@
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
 bool pci_liveupdate_inherit_buses(void);
+void pci_liveupdate_init_acs(struct pci_dev *dev);
+bool pci_liveupdate_inherit_acs(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -27,6 +29,15 @@ static inline bool pci_liveupdate_inherit_buses(void)
 {
 	return false;
 }
+
+static inline void pci_liveupdate_init_acs(struct pci_dev *dev)
+{
+}
+
+static inline bool pci_liveupdate_inherit_acs(struct pci_dev *dev)
+{
+	return false;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8f7cfcc00090..cd2c1f2ada92 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -33,6 +33,7 @@
 #include <asm/dma.h>
 #include <linux/aer.h>
 #include <linux/bitfield.h>
+#include "liveupdate.h"
 #include "pci.h"
 
 DEFINE_MUTEX(pci_slot_mutex);
@@ -1017,6 +1018,9 @@ void pci_enable_acs(struct pci_dev *dev)
 	bool enable_acs = false;
 	int pos;
 
+	if (pci_liveupdate_inherit_acs(dev))
+		return;
+
 	/* If an iommu is present we start with kernel default caps */
 	if (pci_acs_enable) {
 		if (pci_dev_specific_enable_acs(dev))
@@ -3657,6 +3661,7 @@ void pci_acs_init(struct pci_dev *dev)
 
 	pci_read_config_word(dev, pos + PCI_ACS_CAP, &dev->acs_capabilities);
 	pci_disable_broken_acs_cap(dev);
+	pci_liveupdate_init_acs(dev);
 }
 
 /**
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 1c2ee32ad058..34f9900c7d29 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -18,11 +18,17 @@
  * @lock: Lock used to protect members of struct pci_liveupdate.
  * @outgoing: State preserved for the next kernel.
  * @incoming: State preserved by the previous kernel.
+ * @acs_ctrl: ACS features established by the previous kernel.
+ * @was_preserved: True if this struct pci_dev was preserved by the previous
+ *                 kernel. Unlike @incoming, this field is not cleared after
+ *                 the device is finished participating in Live Update.
  */
 struct pci_liveupdate {
 	rwlock_t lock;
 	struct pci_dev_ser *outgoing;
 	struct pci_dev_ser *incoming;
+	u16 acs_ctrl;
+	unsigned int was_preserved:1;
 };
 
 struct pci_dev;
-- 
2.54.0.563.g4f69b47b94-goog


