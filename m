Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB9AFC54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541136B00A0; Tue, 28 Jul 2026 18:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5173A6B00A1; Tue, 28 Jul 2026 18:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455396B00A2; Tue, 28 Jul 2026 18:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0886E6B00A0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7415E404FE
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:32 +0000 (UTC)
X-FDA: 85039580304.17.374A6B6
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf26.hostedemail.com (Postfix) with ESMTP id B66D5140011
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="N/DzXMW+";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 31ShpaggKCCYFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=31ShpaggKCCYFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5W2sBTENi+WOUrZGfaki9B1D/ksXXAJzGZ/5VFVBZM=;
	b=zCRlQrH8+ZhrRg+gMeozhH2pj04a2OnXJkdmT7XCSjSEQxqkQ1bsFyKbjjJOb4m+mEEEfP
	rTfMYyymAshqOPKzp5PV4GxFEhUF/XjDr6/aXnH/enPPWLFOJRZWRmAExSg2pHgcmni6sq
	36V/oyBW9Kiz1hmlLLUjIbcd3qJ3rnU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="N/DzXMW+";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 31ShpaggKCCYFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=31ShpaggKCCYFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276630;
	b=N6gVBhQu/mlfU20jnWji3LIKwkxXTJ256EwnP6LRNcZxpjk3ZEEG2DUtyzWwPBBu/aCsyd
	zceXVIUjG3bE3hNcWfSRoX6sC54yVoag4NHV4dAMHCLFaJzqm8YGpOIKoXMNo5/Tp9Dd6Q
	paLlUgC9VsOtt3bdmFWciOMullY4DTA=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e1118e4abso543618a91.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276629; x=1785881429; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b5W2sBTENi+WOUrZGfaki9B1D/ksXXAJzGZ/5VFVBZM=;
        b=N/DzXMW+HgcnVOwZfrHzXRALeWsgdUgwtfXMyGiHfiUpOwyY+GoQLX6F8ehABqS8r8
         qzYb/86X1fmTBu9BfPG47E17dAS37Bm6kC5BfHut/JyarCyGVcTLaGtUN0FLjMUvTwIa
         +hIGI/k4X9Rz5D7jh5satya3V5ED4CTI9Dyh1Kp0qJYQghY6Or1YbY3Oau5BegDrsW9O
         ZSG4Ly3vbo8irIJpRGA6Zc7zNRLfaEqsKcFyiE8gD6j9TjlY0l77DkBREqgWrgJbvJla
         qSERC8ZQUIzx0zHJmZxGXUrEJXfYy55uTbuMJHP3NALzypnSj5TdfbpkoV4BUXrCZv/6
         7G7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276629; x=1785881429;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b5W2sBTENi+WOUrZGfaki9B1D/ksXXAJzGZ/5VFVBZM=;
        b=DrL1Iclz3jLR7KQTpExMP7On4Izcjtxhqldwr1IjKqF435r+S/4xvzEiAlqVSaJ+jG
         0rrWePxEIjRbsHVTAdueY+noDHJteqcWsfuRXXgnhxkK/U1kUkUT3HCiecFqDYeo93wL
         8eBo2ko0jg/XuZw1hr8hnlRZAg9PcBkeadI8q+vxDKSKJdg3Mf79092rZ9RmVOlSowYq
         mnv5/qGXr550ZdbPkjtmevLucUvosd3Faeog9Ll0/ArPdrTewt0t+r8g+Uy5v1tYEGA2
         +MFMr9PXZnZOdHq9hZ792jITjkONflfNghxO6A59nDFVQOs22bXPKSj2KaLj68JYO81q
         uUCQ==
X-Forwarded-Encrypted: i=1; AHgh+RqNsaAwzvvqvjXx3ebhIjzPnHwVLQlUJvDbRUU3zEHneh/rEB7OkuPTqqCEo2fFyD9QWB4ttUkPYQ==@kvack.org
X-Gm-Message-State: AOJu0YxUHsnI3NwAyPzU6ui+FO2QIkcSoWLksBOoc76P3mxZKyABRBzH
	8nrpuRzrzA5lOO6E4xVwo0hFfWXg5mTo5k1baq666rI2NkJfLexlNvq3Aq4YKHTM6CQlhvtpLAL
	mdDjdjRt6IN3agA==
X-Received: from pjqx19.prod.google.com ([2002:a17:90a:b013:b0:384:f6e1:ff81])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2f0b:b0:38e:7f34:b23d with SMTP id 98e67ed59e1d1-38f6a54897fmr4380325a91.35.1785276629379;
 Tue, 28 Jul 2026 15:10:29 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:10:04 +0000
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-11-dmatlack@google.com>
Subject: [PATCH v8 10/12] PCI: liveupdate: Freeze preservation status during shutdown
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B66D5140011
X-Rspam-User: 
X-Stat-Signature: oqsxw9nufjoycddubkggrhx3ymeub3k4
X-HE-Tag: 1785276630-195530
X-HE-Meta: U2FsdGVkX180UWSPBaMjiUkTLtwgMvi9SM6UJVKnOyVCUDSOPL2tYxCDC4BuaTjYYRQNVpRT33zmzws8uQLhnYsvthZi4VY6lA9ntwBatL7ubYvX0qRDaU6cC6es/sSX4OJc4JPiN6UcRI+ZkTqz48bIeLuwVqVUUxMwP1smWsV21cQdUpWWCd14WFMqrO9pMOLosPS8J2EOTSeN+IuNxT7Jh4c4zZKBpeilJnvWdwfpARqT9Y8zBs9a0pfKGc/RvZwuRHqBHloW8mtDsl5Jc26MB9BTYAa9op+BkPW9Ar+CEKt+p70pw2bUZLJCQ45vQ26Wtlup5dYuK1woW5GXcsUIJJFJI8pr5uZMSkhaX8zw9ufs/cb/Z73Ao/68GiIbRE1jtXr2UwrOHy8l5WUtpjViPusfefhpnbTuHmTwxjBOmYX09+MnYhthR3xRaTHk+HaUBgmKDjGS2+VPRiuJ8UgrFssLAbfnG544NCfqs/KIIZkwbKaf21X10uq8YM5HJg0WwwInGT6B0JykkNy9z+GGplPfeBZw9xvduA4AGaWzXoDsIQMx8dsjgksJTIGz7dwDLCFaMLphIt5GRM0X6JOGxx94L6nPTSsKCA3o1BaJGanc9AAvILDR35+63+OzOo+IRhj1y6pbCDqsZRWPLJaz1wv3Ny4PgyrVLSBgZwHzbuQ9RXI95by1vgWcXohbOLTQb+GpqzZ0yExLuqXlvPx2vlr/svE1iL7Vn6wrJ4AKjjAjy23ywP3jlFinwZ+4rJUYbwRd+SwTZ1384Na1PrrxnyFxBoFTT2GzI79uZkvWuBIhg3fvE70JanV8/7dlAHLoqo79GCSIJC6euo4yURoUnmy9BYSujJejuTqYU/AxfrNt7vAcyNu7v1pkM83ZDy0EKmzi1njYE3wn0QTsBlfn9AV5Gh2QyvJjGjSTxKdpjk866IcUjG6ndYJ6YhYIRyajkOd5y8FEIeGIB7E
 As67NAxM
 hjQX/isvPRSDlzPU+V6IueK2KWA0dfySlcMBIWtEbMy9AqMBXuJERmgL+sD5g8Ss5b/85NO9+o2kobTl+qixq9z8oG2zyaMsJyl5etDN3EfWUsxxTH6Cx4K470TF7VB83ONwgSO9uYt8Kk7BkffdEgkxVPADVDCE0092hEuunGcfunIlTL9QYoFqju4bgDQucu7s2g5ZcDOEIsHl5i4AGfyylJwARY8Ky+pOkfUPAJ4hMA7isA/pA0hKIvLzfrERxiyNWoE7TAv5Z4NZ8BinMvI7nEih3mzaELSMeHHOK9nCYKBcCDoDlD2IQWJF1UwlUZECXePtcWjQZU0UH+x9lm6FCCv94xRiiV/ij5zQZlrQv4ZsE2UpXD5lyls12bkVDbb3pHMN3Sma2kUZoESmjQLozB0vYXSX2t7UgzJnq6AtkxoAuRFSlS4Cx1p5DjGr1dOQLE38iNRkdDZDtjAkIfalTyqgBXdGcutXhM+HuNmkbQ8CZ0sUzIYhVEejcY8mc83oFlcUUOrICznR4YqIqYv3N6M8a2OVeIaD3We3Ak3Kl03Lvch973/0ugvliC4sl+wHU3fm1kstXVbQ4GCy2wgs+wBBkkLVD78FQSekdMkjXVPJNldqbxNB4dQl1wh8ze84vtyR292+z1Wwm0ZeljMvvvw==
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

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c       | 16 ++++++++++++++++
 drivers/pci/liveupdate.h       |  4 ++++
 drivers/pci/pci-driver.c       |  2 ++
 include/linux/pci_liveupdate.h |  3 +++
 4 files changed, 25 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 744513ee11ed..65bcecb1b64e 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -394,6 +394,11 @@ static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
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
@@ -447,6 +452,11 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 		return -EINVAL;
 	}
 
+	if (dev->liveupdate.frozen) {
+		pci_warn(dev, "Cannot preserve device after it is frozen!\n");
+		return -EINVAL;
+	}
+
 	if (dev->liveupdate.outgoing) {
 		if (!dev->liveupdate.outgoing->refcount) {
 			pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
@@ -718,6 +728,12 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
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
index ccc23031e99d..49d07fd02132 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_PCI_LIVEUPDATE
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+void pci_liveupdate_freeze(struct pci_dev *dev);
 bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus,
 					 struct pci_dev *dev);
 void pci_liveupdate_scan_bridge_end(struct pci_dev *dev);
@@ -28,6 +29,9 @@ static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
 
+static inline void pci_liveupdate_freeze(struct pci_dev *dev)
+{
+}
 static inline bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus,
 						       struct pci_dev *dev)
 {
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f36778e62ac1..51616e4327d3 100644
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
index 04a2b2a3102a..31898685a406 100644
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
 	bool preserve_bus_numbers;
 	bool was_preserved;
+	bool frozen;
 };
 
 struct pci_dev;
-- 
2.55.0.487.gaf234c4eb3-goog


