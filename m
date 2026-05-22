Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E126CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983816B00A5; Fri, 22 May 2026 16:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898536B00A6; Fri, 22 May 2026 16:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738126B00A7; Fri, 22 May 2026 16:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62F2F6B00A5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3072490CEC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:24 +0000 (UTC)
X-FDA: 84796183248.25.33B67F7
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 685604000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Y0P6jx/v";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3dLsQaggKCIUmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3dLsQaggKCIUmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5gRktteoUb/1GJUOFc5t/RbM6I0eXe+lj3sebUBczU=;
	b=0msQURwokOJzPGC23qdzEsEX20N4effelaNJ6/M6SBjK2g3E6KXjwfahfybnCu0oX2ydpy
	EeuO+xYCWZTt1xyJOAP63df7GcvqwWWVMDqoHm8+isf9+Yn8z/ZtQt1U53LgLTXe+YCMh9
	7G4lax1iAhvQlyO4v0Wyzl4Cbwf65Qc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Y0P6jx/v";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3dLsQaggKCIUmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3dLsQaggKCIUmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481462; a=rsa-sha256;
	cv=none;
	b=vzAswSK4F6SoniYa366BLVMl8CQeHYkLfRO/2YP8FKKOXES+XSJzKA1v/ExRFGBr7XzFs8
	JNW4KqA14+NbEcv4z36WA1Zl8SJ5SaRjxZQwHEZk6XaYzeZVCdf5oHQDac/HvV9bgOFrD4
	hEvAvWzvanatoscL9RX9dzgyY0Fyp1s=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-368b15eeb3bso15349813a91.2
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481461; x=1780086261; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n5gRktteoUb/1GJUOFc5t/RbM6I0eXe+lj3sebUBczU=;
        b=Y0P6jx/vzBTnWG1thFwIRgG5o/uYm24MS1Qqv5dSXsNXyGKbsS35mqhZnnsbBd/60W
         VJzNzh3AReKXRdBaLhWuWdNLal2/ixMHAr02ExDDgsT+/xe3HycBGeQQgbMYLh/IzPSP
         k8J2UU+JTVgzDfYMkuVDQKbNy9tuX5qoIcDX83XMjX796F2cuNG0XqtBIbIsqu5J069S
         MmF/Hdfhi7kt41AwzdK8mmNbHMtFbya92eH21aCwdE7WBf3KahK9xofteu51ubWnhRWy
         qbkHHcnc9TsCT7KxwXSIjW+ijsmci9Ua/xKP06yc+uvE4fIJ6oPGPnxpR8Is/oHk0HnY
         hRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481461; x=1780086261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n5gRktteoUb/1GJUOFc5t/RbM6I0eXe+lj3sebUBczU=;
        b=X44Ec+rFSKhWPBII+YJ9QKm3LY+V0RPDplJSwbGBEE5XJ48DqnaEs6DQFQ5In676td
         8UqC7uI98LpW7CLL9f70nNYMgMW4O6qBCOfXaoGsA4FC4RI7/6ugbP6K4/fMxtUtWFvG
         tdvUoRgK7yIpslkMjMwDItaIjA3jrPE0dU+pYOx0I1aARCt8LtswYz2n4+Ly0wjEaT8r
         X75PTlszh+aHZF2n/x0xgkNiaZyd6hclBbIuR/EXc3wkmeI81mahzz7I2nupYgY0QunA
         arpQk49aH3RsEdu9Xw/UqdOMLr3XCkTgs1AkIiglxEZntFSUeDKV4wlg3IF16T4CVgGX
         +U2Q==
X-Forwarded-Encrypted: i=1; AFNElJ/utM73ArUzuna7fTOtxc/PNtfLh6lu7CINxtsHn1fsTFC70tBq/JToJuyw8c98QIwV23O1wYOhew==@kvack.org
X-Gm-Message-State: AOJu0YxDTB011Ey8pSO8UScnFio8g6VOmZpOUgsdBRrg9NRryyWR9/at
	e8djo0TuVsXrcktcC9pqGEk0aLOP1OV1mC5bwdWT3HEyL+nGlmOPGDqQiyhxRIqncMdjf/ZshJn
	GxHen/0nua/jQoQ==
X-Received: from pjbtc4.prod.google.com ([2002:a17:90b:5404:b0:36a:81c9:4523])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ecc:b0:369:d7c6:450a with SMTP id 98e67ed59e1d1-36a671e974emr5405438a91.0.1779481460825;
 Fri, 22 May 2026 13:24:20 -0700 (PDT)
Date: Fri, 22 May 2026 20:24:08 +0000
In-Reply-To: <20260522202410.3104264-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-11-dmatlack@google.com>
Subject: [PATCH v6 10/12] PCI: liveupdate: Freeze preservation status during shutdown
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
X-Rspamd-Queue-Id: 685604000E
X-Stat-Signature: u18bke7ddcqcapt5g6kq9ozfotkgw71e
X-Rspam-User: 
X-HE-Tag: 1779481462-651883
X-HE-Meta: U2FsdGVkX1/PfEusWpitpnMD+xUb/yPKJBXDZ19O23zG2fLo+LE8jNbYMg6/3MGGBpMz7jt6XrYzklG43yIFIhkRCRzwnh3+A+wY6E4Lh+XxEkKPHtJV/+Gi0texqfrpKljI4z7yh93vWYEHiPoxRax1vVEHuUHsmFbSm7LWPPjwUxg1ZbHVhKFm33qZait5Dop7OuV4mrrUAlPGQkk9P7F0G1lFHNyhJ6sBokCpj93TiOMFLiIVuDIjNSyssPy+tk6/Jt8tZonzJWDGQ0FEqss8V8WCDSgrt9tiEPVSlHhD2GaW0RM1fh0wJBjsf4JYu/+K3lLIfLiNubWm96XGXmqbhThUbQ2rX+PL0ZRzEA6DexRnfXiqcnxhsy6YvhqJUMarkBAh9mPT9o/6zOCnZsEKLkC3/QkTDnLoZnL/fpDUE5dBTD4fWzCwiQcxYz1lhtxx6i5kGBhXPC9A81AUWNTwnvLnjF+vFWoFCAMRllpRxzM+R7eNtf2lIeATXWpcY6ZPGZQz+7Ow0TIOsawxWJNNMy5E2IRoO+MJzQ4b98SiLCGzFpE/mwXGOKgXdweDIcGCtQHlzcb6nrn6IBCJxALZrq2DMafXbNfdiclP5vZso9FTJCkU3/yqcAnlt7CtQoMeUiG27DegWBgHg/ZNO8N+X03dUYQBO4PQZUeJoiKoBX4mHZMgYL80i4L7b+QJwEtzV98cXJfzlvbdXQieJKYUGlaCPc+ceySv0D2QrKhlui62C/hHMreJXBrNPhSuxW1A+JHvvDbJxTWIqXpae7KGseQJrpfxQ4in4Dl+F1odAgJSySxSdS0PHc9V5kC5nm/1DpSrHtg6tvDgK6IcmvIPixM6qNZN5qpaChOXKLNMmzT78ahtLX+2JqD99va3yPWwti+1FCMoiBd/6h6pcCRxByXYpRFVhGlvdXf6wZbHqz1fe8YZ0/dplCsU6zpCofGdVRYLcXczLuHZPgM
 ykkZk94Z
 9vHZvPY+nDiC5JLl0TnDDNtSHH6WmSmJODd+RSANVqf2JoKzdBwICYl4GRQUmK/8PCcaC0A0Od0pmL7J8A1+AV8b5Q3k3M2FYXSa3eNZqTICmtw0S749zJgd5SR3uyKuPXPD16YjemROxI1PAbQNvHCGvXohNCQ0T9+y6yUS/HUI/Zt5/yMIINQ5+ISYbnLohS42gPyDuZcG90DmHwovS91tDbzxzM7iVkHbYB6BpHwVC94ZNvSuikny+uvcyp5xtaD6Y1orByYZRzW4yqC5/COuuwcEVYaKhUG6vknIVR5shJQwVLAx7zKHZRlK21oFl1e0Q32fSIrbkOohcOWhgFtOIsTuuEeuik/HkpoCpOfGzmjA4m21YKx3NYgWWTjjDaal0FhZYBbCweozxasFSNH7waOc52vCshM7XsrAzavXYwkyMsptFCt3JCYgdhVMrrcdKzL0Yi9b+9v4L462Qex9LmNYaSgnkPdBshFWwBQfuMSr9UUUpTQ2GJ8d0Lrhlxv6m50R68c0LyDd6wknkHD3tTcu85YqwVHX7XRHYBifEoXSZdbtGSeKQNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Freeze a device's outgoing preservation status (preserved or not
preserved) during shutdown. This enables the PCI core and drivers to
safely make decisions based on the device's preservation status during
shutdown.

Note that pci_liveupdate_freeze() is triggered by the PCI core rather
than from drivers participating in Live Update so that all devices can
have their status frozen (i.e. prevent non-preserved devices from
getting preserved late).

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c       | 16 ++++++++++++++++
 drivers/pci/liveupdate.h       |  5 +++++
 drivers/pci/pci-driver.c       |  2 ++
 include/linux/pci_liveupdate.h |  3 +++
 4 files changed, 26 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 701276ef6cfb..d404e64a4e55 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -297,6 +297,11 @@ static int pci_liveupdate_unpreserve_device(struct pci_ser *ser, struct pci_dev
 {
 	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
 
+	if (dev->liveupdate.frozen) {
+		pci_warn(dev, "Cannot unpreserve device after it is frozen!\n");
+		return -EINVAL;
+	}
+
 	if (!dev_ser) {
 		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
 		return -EINVAL;
@@ -380,6 +385,11 @@ static int __pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev
 
 static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *dev)
 {
+	if (dev->liveupdate.frozen) {
+		pci_warn(dev, "Cannot preserve device after it is frozen!\n");
+		return -EINVAL;
+	}
+
 	if (dev->liveupdate.outgoing)
 		return pci_liveupdate_preserve_device_again(dev);
 
@@ -653,6 +663,12 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 	}
 }
 
+void pci_liveupdate_freeze(struct pci_dev *dev)
+{
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+	dev->liveupdate.frozen = 1;
+}
+
 static int pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
 {
 	if (!dev->liveupdate.incoming) {
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 6f21ec50927b..bcb0bc73d684 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_PCI_LIVEUPDATE
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+void pci_liveupdate_freeze(struct pci_dev *dev);
 bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus, struct pci_dev *dev,
 				      int pass);
 void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass);
@@ -28,6 +29,10 @@ static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
 
+static inline void pci_liveupdate_freeze(struct pci_dev *dev)
+{
+}
+
 static inline bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus,
 						    struct pci_dev *dev,
 						    int pass)
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index d10ece0889f0..f7a5e65a7c75 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -21,6 +21,7 @@
 #include <linux/acpi.h>
 #include <linux/dma-map-ops.h>
 #include <linux/iommu.h>
+#include "liveupdate.h"
 #include "pci.h"
 #include "pcie/portdrv.h"
 
@@ -536,6 +537,7 @@ static void pci_device_shutdown(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
 
+	pci_liveupdate_freeze(pci_dev);
 	pm_runtime_resume(dev);
 
 	if (drv && drv->shutdown)
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 2446c6d237ca..150993405754 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -24,6 +24,8 @@
  * @was_preserved: True if this struct pci_dev was preserved by the previous
  *                 kernel. Unlike @incoming, this field is not cleared after
  *                 the device is finished participating in Live Update.
+ * @frozen: True if the outgoing preservation status of this device is frozen
+ *          and thus cannot be changed.
  */
 struct pci_liveupdate {
 	struct pci_dev_ser *outgoing;
@@ -31,6 +33,7 @@ struct pci_liveupdate {
 	u16 acs_ctrl;
 	bool inherit_buses;
 	bool was_preserved;
+	bool frozen;
 };
 
 struct pci_dev;
-- 
2.54.0.746.g67dd491aae-goog


