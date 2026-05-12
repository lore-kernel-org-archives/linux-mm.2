Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6547CCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6125A6B009D; Tue, 12 May 2026 14:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574866B009E; Tue, 12 May 2026 14:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE336B009F; Tue, 12 May 2026 14:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 31D616B009D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:49:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE5D51A059F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:49:01 +0000 (UTC)
X-FDA: 84759654882.08.B6DC793
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 21FCD12000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KSzEbCdM;
	spf=pass (imf29.hostedemail.com: domain of 3GnYDaggKCGsMVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3GnYDaggKCGsMVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+T00aeBm2op37uqoieTnlwhq01i0C6V7dLZN2p+Z22k=;
	b=dOu6jc7lI7WoZxmoOzvkoMg8SUWnLgTKhbGlODpAULh+0WWXqZoXAvDMWDTO41DTmf5jnE
	/Dxxoazk2zzup3aXhCE5dn9DUGPcJXzc+ZIWWzHbymgFpClRMk3NPoqIW2wjerVJiZ6/0F
	bETsyzFWUSX38RmGYIXq7X3lXix0jJ0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KSzEbCdM;
	spf=pass (imf29.hostedemail.com: domain of 3GnYDaggKCGsMVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3GnYDaggKCGsMVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611740; a=rsa-sha256;
	cv=none;
	b=rBdYEwYSRLUl2eG4ZUFBfPLrD5dCFV6E7u/qIs/wcDXrHNaH22cXc8O93Aeg0lwKhlTWj5
	2mDWmBLDzOPvqaedliSBceWd5ELm+UEPnFbUhm7Fky+NSXZ1XIu10Z0fS/eOfUqw9cqT+0
	cu0eQ+2NT/hgwJE2Ig+pmQhVQmPs/+M=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c8271fb4407so3665487a12.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611739; x=1779216539; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+T00aeBm2op37uqoieTnlwhq01i0C6V7dLZN2p+Z22k=;
        b=KSzEbCdMSBSzzOdfpLr+Bn701pUSzCHJiK8lNHZdnlaEAPEtsPAKb0v+gcvmQ8FUyn
         EWCH1OgtLbmxNvs8UucyuQB/PkMZNOp0DaTrLG+T2w8GQA2D3D6cKIWufBOD/bGp+JeR
         9iWtU/Z1i6j1Z5rEgMRfMxBF6/P9r8hADOvtLXIqaa0j5yTDqWwFE+W9Q1BGzSVxwUq7
         DkvlgYJuMDWFIrgM4Z4EDZN+GDpYyZXjhOsTfxbyr/oEDIATRrJVdTaFkunC8n0E2ZMl
         Ne68FnJtQ87ZSqed8Z2zrpe+14E+m622zfS0Zuk0lt5CoK2s11cSleGWW3NKzl3O/E/e
         mYXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611739; x=1779216539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+T00aeBm2op37uqoieTnlwhq01i0C6V7dLZN2p+Z22k=;
        b=fobLOP5tGc9ZJlJN/0BGsV4hP1it8a5/Q3yuRuh+rBb07CspgVTMS4eBueL/1656oZ
         am8HUsLGVGJq+qROSx6Gn4xao/+VyIOS9uSQUHhsdApZrympg7G3yax40Vr3lelLL7Ef
         y1xp8mDu2pPRmUnGAIAX+YfblVx9Bv2xCh+P/DMRE6irYWiKBDCK/OCPcvS7O1lL3h78
         uE+hHgwcZtovKfBNuuY2cyk0Reolcfy7fDRlBMQnv4onMDvF3zn8Xp92319e7IHaJZmM
         5EsxIFC4gc1ksKFXgSdQhelIcbI1F0boDxG+04zLGSkhpoSaPupOAarQIXJiQ41glLQe
         OIrQ==
X-Forwarded-Encrypted: i=1; AFNElJ+5+nX5xM8xIokmS5LonrvfOYCMhxwTCOjQqwZItPclkEqV3VA9rllDwWW4BnoeBB9ayBOf4oB9VQ==@kvack.org
X-Gm-Message-State: AOJu0YzX9xHaLXWf5GU1eWmMAV6ExUiBZ6eDZH8Vkos8tk2FTeHBjPOT
	x4+p3fN1cyA3qqKUaJwsMAi2x81lgtV34zNNnHuV9C7jH+xo205j7cHnmv/244OLEgkig6PJW1x
	yII5Hz9xE9zsBhg==
X-Received: from pfnc7.prod.google.com ([2002:aa7:81c7:0:b0:83e:d99d:7c4b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:94c7:b0:3a2:d68d:9e6f with SMTP id adf61e73a8af0-3aad44508e5mr15994706637.33.1778611738764;
 Tue, 12 May 2026 11:48:58 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:44 +0000
In-Reply-To: <20260512184846.119396-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260512184846.119396-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-10-dmatlack@google.com>
Subject: [PATCH v5 09/11] PCI: liveupdate: Freeze preservation status during shutdown
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
X-Stat-Signature: kbqj7wjw1p398bm5ibd9gfuh9hun1mhr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 21FCD12000F
X-Rspam-User: 
X-HE-Tag: 1778611739-634793
X-HE-Meta: U2FsdGVkX19xEuCRAYQbW8y8Db3DG1nIkCZkO/bGjEKQOwL+ZCqnfKhLUXlyUIffl8KQOzy8JF18VmIalW6aGsDafd6VTjljbco3cIKdYyDfy3TRxWsfeXvqpo+hF2mKeHf6SH9BCJlrKKW26+ZXHu0s9N28jg17E4SR2/exN5fB3KuGJLmGzCfjUb6BlA+QX9oO3SH+XmrMP3skz7IMyBzBxZ2v9qiRU1KmAriS7v+DxLn+aZP3lZihC7xJHZFs4dBUD1JSHI3U9a6hgTYxfch2moIk06fSc+oztjckoghgnlr5PwmzljjEmbf/odnqtqquxLVyA08fXScCsAnNq4DWn8Uf++ExmIzxs6m8hHPd3V64GF7Q5o4eAWkVtCXT/HiwwubFoL3DXN75rtFeShObe4uDR9DoQwJK7bcblyxTgapwqufCYvvex3ENgMgUTquGacPuVM3+t2r6gl8Lq7l0/djOiLfyrrJ2bW6rLPNSMTPXb7VKmjF9ru3gWO3fnkBlXLxJmGC4wy4/Ymh/ZPUnPcFdI7oQiV9xjTqNuViGNuxATl16qkWTcGaH/NbtmidwowEj/1a5iPDsDI3kDpFzMmWJ7BNSIU7xgL/gl6xecmBwEWb4BqnA5F7JLkY+Mi+RVmN5PKK0/1pYms1Z4Q6XxU6Die/i19Jl8jmr5QkPXL0vXW57bO9hnr6luKFst3oANos099vej1led1DM7zNb1zNeyqD9+BdaRFeoQfpdFdi1tY5YR0q6DsmMc7KHP6BQ4iey7maM1Z3Gddch9nOUfpurMZZsia+Pgr7FxviMe5edPxq7Lr7wTW89I99wUEj7gzjmWftPJXIukzCWHrV1vJxeW9uqgAFK1+S4s3dq/IIQYC9Ni/FTdETqCiVC4TvJoXIoJ769CLTuL3o0zakxObboFtLgA4pkl96/VRA5IfiJKdLsiPjgmV4U8HwM2sy4+lnRiVKEHtSIcOU
 4YJTnxbW
 eJrFvKZXAKogbH+Uox/EaLlzpZ50wN+HxqkhexlYvilCyeoGwGIJPXEVuKYjv/Jy/Rk14+VcFPbj4dt36S2O8aUQbqVtIYvw5eKUxNXWeeHdX1igHlM0Yo2bZ1K7LRwRI2mKyD41tXcnfGAATBEIyXZ3RdWKeAKlySl5f3RiHL0z/Mju87LwgKzxxruL5lPD/dHHi5DO2i3BTnfeb4zJuYPXEbnT6Vcd9yF5Dvmlrwqu154gPLnMyVJeUw02sWzS228CNf3EpcEu6IRjCETYO4kareP/Aig3nreFKlkDg5XZmK7u/oYvQETSJJybzWxO0DC7EcY6Shuag2wtIbnDc80VG8q/I1f3sr2qok0NBGutAq3DVrNj4tLIWbFNfFCCBPGaVk2A+P+gbFONUIGhFF3N92XCOUVN4Lhp9IW2HZZuEJ47fLwJpG8j/jjw85EbZgNCTcVzDEDWNVuhUb8otPD3D9Ay+OYn421291CannfWdtLkyZZCM7i/OK0mMvjfqjkzbDkTCyKlf/S5/oEIxJPCohPeJFU1EL/wd5L8dpGS/c6SLWWQhaOrC7w==
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
index 6ab03bd548b3..825166a57913 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -334,6 +334,11 @@ static int pci_liveupdate_unpreserve_device(struct pci_ser *ser, struct pci_dev
 
 	guard(write_lock)(&dev->liveupdate.lock);
 
+	if (dev->liveupdate.frozen) {
+		pci_WARN(dev, 1, "Cannot unpreserve device after it is frozen!\n");
+		return -EINVAL;
+	}
+
 	dev_ser = dev->liveupdate.outgoing;
 	if (!dev_ser) {
 		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
@@ -420,6 +425,11 @@ static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *d
 {
 	guard(write_lock)(&dev->liveupdate.lock);
 
+	if (dev->liveupdate.frozen) {
+		pci_WARN(dev, 1, "Cannot preserve device after it is frozen!\n");
+		return -EINVAL;
+	}
+
 	if (dev->liveupdate.outgoing)
 		return pci_liveupdate_preserve_device_existing(dev);
 	else
@@ -625,6 +635,12 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 		pci_liveupdate_flb_put_incoming();
 }
 
+void pci_liveupdate_freeze(struct pci_dev *dev)
+{
+	guard(write_lock)(&dev->liveupdate.lock);
+	dev->liveupdate.frozen = 1;
+}
+
 static int __pci_liveupdate_finish_device(struct pci_dev *dev)
 {
 	guard(write_lock)(&dev->liveupdate.lock);
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index fd7693c7ddd2..30deaa673efe 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_PCI_LIVEUPDATE
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+void pci_liveupdate_freeze(struct pci_dev *dev);
 bool pci_liveupdate_inherit_buses(void);
 void pci_liveupdate_init_acs(struct pci_dev *dev);
 bool pci_liveupdate_inherit_acs(struct pci_dev *dev);
@@ -26,6 +27,10 @@ static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
 
+static inline void pci_liveupdate_freeze(struct pci_dev *dev);
+{
+}
+
 static inline bool pci_liveupdate_inherit_buses(void)
 {
 	return false;
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
index 34f9900c7d29..7e4ac7a0f4fc 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -22,6 +22,8 @@
  * @was_preserved: True if this struct pci_dev was preserved by the previous
  *                 kernel. Unlike @incoming, this field is not cleared after
  *                 the device is finished participating in Live Update.
+ * @frozen: True if the outgoing preservation status of this device is frozen
+ *          and thus cannot be changed.
  */
 struct pci_liveupdate {
 	rwlock_t lock;
@@ -29,6 +31,7 @@ struct pci_liveupdate {
 	struct pci_dev_ser *incoming;
 	u16 acs_ctrl;
 	unsigned int was_preserved:1;
+	unsigned int frozen:1;
 };
 
 struct pci_dev;
-- 
2.54.0.563.g4f69b47b94-goog


