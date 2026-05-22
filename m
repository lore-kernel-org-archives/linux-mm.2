Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304BACD5BB8
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D826B009F; Fri, 22 May 2026 16:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1928A6B00A0; Fri, 22 May 2026 16:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A6F6B00A2; Fri, 22 May 2026 16:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC9036B009F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D9031C0306
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:20 +0000 (UTC)
X-FDA: 84796183080.12.83E691D
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id B8D34100005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vyy6bwaH;
	spf=pass (imf05.hostedemail.com: domain of 3cbsQaggKCIIjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3cbsQaggKCIIjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aa/nUEfOKJ1QR8NF3ghsapnMDPgIBL9du7ZKGarbXoM=;
	b=vDzN2UV45INGlmPkzm29WX9+LwVvAQ4lOm75y5zERsR4tCf9dc3lhG11c0px6kt8dwPvbQ
	RBVHUfjEQ1MKCstJqosefHwbqzY/HMOk0L2WlrIXKzgzQRd8rJJethWQQ0Q4vaNxpcSmPn
	P61lekAUEqngPz5beo5M9EKSAoauJus=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vyy6bwaH;
	spf=pass (imf05.hostedemail.com: domain of 3cbsQaggKCIIjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3cbsQaggKCIIjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481458; a=rsa-sha256;
	cv=none;
	b=BF9isFmrYxy9vK9wnzApnrMhI0qTUfUCHduN7xNOyiQlC77IVUEUOePijtlOtGVmoGKWn9
	GYzoxCSuKbgJT2Tj94Tf/uP54bLMKpQ2Qmq6/fUvHyHrkDJQ6aY/LmpySLpyDpiHr+A8Tz
	N/V8gpWQVb/y5WM1xgnMRCQBTVAn6bU=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ba268cb5e6so81076385ad.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481457; x=1780086257; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aa/nUEfOKJ1QR8NF3ghsapnMDPgIBL9du7ZKGarbXoM=;
        b=Vyy6bwaHVgLVZXq9LfriY0oWd7UGFApKIT2dojIDzdClnwiHLcaH+U+o9vvNqCQrP/
         2atD/jTxbyRD1Ul+637X7i+zBcGovQuMAhhKYeLd7tQ52Uh1roGNbpn9L/NIMCNtcQAS
         wOltIwEST+cfpnFjBw1+3QdYVx67Zm8NFyVk9hpEzR/JqN0SyJ/IhxaFQ6eayhcDSeRV
         iX4yOReEd7EH9IPWNPjbxddKJ40Qhuxhm+ql0rfW3BOsiCgRSnKicIDF4QAOG0KIsS+g
         OIp/PQkRwzNCrqMjPU6pbhTDfVcOcO8eV0zthi7LY1xt36w2aMtFpihBAx/S7/NHDXhy
         liqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481457; x=1780086257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aa/nUEfOKJ1QR8NF3ghsapnMDPgIBL9du7ZKGarbXoM=;
        b=NLKRGrOUx9xRNq6f55TwkaA89/sB5ZcdPatcqiuet8Qe0cLMjq6zCr4rCgzCDzJeol
         JrhsYo2e3kkwZiT+zl2kjOHC94kQEVywpqbZs1Qi4ZNbmjbSpW4TxUnqg69P8OoDFwAj
         Rm7TDRCxSzJYwHIfTQjL2f8atqnKDH485Eaig0sEJOw9Rmh+6M9VAcultvHNun6l3JCa
         K5MK8VrfNNe20Qha4osnL7pzAU51M4ISEamlyT0AhSS0zQxY0sOmGbap8syGtk4OYFDi
         cKmWjZ8tH8+96iMctSorTaHTWIQInX5nqxojmGivObBtCEjS7Ug7/glhM7vVur0ziTM4
         F8vQ==
X-Forwarded-Encrypted: i=1; AFNElJ8SccjvFj61gPI3IGa4u2/fKK7pUyGFd6pSXmD/qbq/NeyWzenJX+Iy8C/f0L2WBVU+MR0SFr8Xcg==@kvack.org
X-Gm-Message-State: AOJu0YwB/FdzJhx7LtxKLlzu9VBxH/7iXouOYeZZ5q2IJpJsa5JlxEic
	sZggrRCZoQPBEKcDTn9dQe4HsgyGGb+WsFFrTTMLVurb61eiUgqVvNarh3gic45KNHkcngBlp14
	2LjjTatd4fq6XLQ==
X-Received: from plfh15.prod.google.com ([2002:a17:902:f54f:b0:2b0:ba5a:1fe])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2381:b0:2bc:7486:21cf with SMTP id d9443c01a7336-2beb06423d4mr52826275ad.36.1779481457319;
 Fri, 22 May 2026 13:24:17 -0700 (PDT)
Date: Fri, 22 May 2026 20:24:04 +0000
In-Reply-To: <20260522202410.3104264-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-7-dmatlack@google.com>
Subject: [PATCH v6 06/12] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
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
X-Rspamd-Queue-Id: B8D34100005
X-Stat-Signature: 1ywxathx6pc6461ueb485uzs95wyh8xc
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779481458-794111
X-HE-Meta: U2FsdGVkX1+DNZvynGTEtL8KMmpjEL8l+17R7pNvrlaBmHH2ESTsTZ22EnD8/j73lj1mx5WiAyoCWkA2hSCfr6FqPKIikaXCOuNw5jWSVxDpC3QK84dZdjHVEypj/eCY8sZUOgfu91RRjOGPDh1dfgCRlrjXS/xkUdRl/nvvDbIRKyG5ACzWk//q1f9K9glXN/O+/EzWkSGhf3lMvzTHVqiU4bqJWFu2OVbb+SnCz9TVBqFVhgW/0PKKWfYmw6HeCSktW71fY52y00mBUmQHil6FgTnh5vXGKPr9ADAxplR9DL+jHgIEpAdT/JRyrzhq1Jpb8z80QeVN6q7akRwMzafBvipwomT+CBH7YQ/MlKoHSvt8/ER+NdW7qxU1j/FEoxP161ibm+eD8N2rWqltVK1j3m9Nt1pRbtcAhITXT9B5Hmq+zQhIRg4wWp2q1C1LRbTzDqmy0qA6D0LlmFJTqQpXJiAbe473OWsmHX7bqocor9+L/Va/7flZyyKN8KYSoUkknHsHKHOP4NE58NJ9Rzs1wVgJhWlywvfcTKx0W/sbMm7I65A8o2CuwdiNAZ1cPZnXMPQ+GC5A1N5nDebw9BwBJ2pufQCoP+1pNBwl8PzIfYOfkXO8PVfnlXwcu2EKJ7C03BrBr8WHtDnkRtKEBvfmCIbQ7X8R8gxO3Ht6Vrb/GLWmTpteK42/hl5v58FoVf/JmAkunRyDSUJmgfIS6waz6i5S5F+RUkRAd/GB19GmYN9cNNI1KF/Ho1pUntpDeRbKLILTLjT5MIN3xO8uME9TeV9Rhwq2FKajw8ONWEoIobOs2bPTRqNIcwUbT7rwaS3vz83KsTgMn637n6bNMCIU+q6EkQlEVYufjtk5myt5x3+IyS68WyU00bXWourNeS+XX2hxEVyRiiEQU+ilQimaBS4LpdqyIN0dz2wmIZ+RhZmAWShaDD+87ldoJiiA1Bidfjskexihf/tIcvA
 N0kiy00Y
 m95KTO29wqxmE12wFjhCA84oXHv/AA4ICFhph6RZGtQg8JBRweyO/Oj6gkSMDGPcVwQKMEYBxR/SIkyXC3E5f8gWNQxw3DvMnZQg/YmRuTrH2D0lv8wGfb7Mc3DXa747AZbFO9qekLQnmVLxJJJ3snpCPL6S+cSz3rO/TAs31gn71i8FN8YDQ0k4UplPdf8fD7rdoQ35IsuBbVtlZQhtetYib7m8rC3sZy2clYshsSO1rTyXrTXSb79fqBUTFM7gVgvzETTfbOpzTbIyjlbeJwTAarny8hCgl6wahi10XwWmUkX3eELIefAgyqTXTP45FAGEsb1cOkAYlOXSu9AA0aTnCaejK285uiCR5pPoVcPf/VSHAe9MBhVKV+gRz4L7ZXapfJadmZ0HuAXVeZvVffYKI84Hi+AeJr68oMPNDgvU3pumgYbyGSUsR6SfYdifHEYnkr6GgvpLY/F/5Eb8tbSx5eMB5PDDhZjAQoRrOwTr7km2QOj0tUCcCXF2ENglI5h3hoOeYEsXDPw/ea6AyE+d/j4DHaDj2bQAoD6MfZZfCpqeAYyRTqg+3AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a PCI device is preserved across a Live Update, all of its upstream
bridges up to the root port must also be preserved. This enables the PCI
core and any drivers bound to the bridges to manage bridges correctly
across a Live Update.

Notably, this will be used in subsequent commits to ensure that
preserved devices can continue performing memory transactions without a
disruption or change in routing.

To preserve bridges, the PCI core tracks the number of downstream
devices preserved under each bridge using a reference count in struct
pci_dev_ser. This allows a bridge to remain preserved until all its
downstream preserved devices are unpreserved or finish their
participation in the Live Update.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c    | 136 +++++++++++++++++++++++++++++++-----
 include/linux/kho/abi/pci.h |   5 +-
 2 files changed, 122 insertions(+), 19 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 2421bc218916..4c79e19b7f98 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -101,6 +101,18 @@
  * If a misconfigured or unconfigured bridge is encountered during enumeration
  * while there are preserved devices, its secondary and subordinate bus numbers
  * will be cleared and devices below it will not be enumerated.
+ *
+ * PCI-to-PCI Bridges
+ * ==================
+ *
+ * Any PCI-to-PCI bridges upstream of a preserved device are automatically
+ * preserved when the device is preserved. The PCI core keeps track of the
+ * number of downstream devices that are preserved under a bridge so that the
+ * bridge is only unpreserved once all downstream devices are unpreserved.
+ *
+ * This enables the PCI core and any drivers bound to the bridge to participate
+ * in the Live Update so that preserved endpoints can continue issuing memory
+ * transactions during the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -261,28 +273,52 @@ static struct pci_ser *pci_liveupdate_flb_get_outgoing(void)
 	return ser;
 }
 
-static void pci_liveupdate_unpreserve_device(struct pci_ser *ser, struct pci_dev *dev)
+static int pci_liveupdate_unpreserve_device(struct pci_ser *ser, struct pci_dev *dev)
 {
 	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
 
 	if (!dev_ser) {
 		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
-		return;
+		return -EINVAL;
+	}
+
+	if (!dev_ser->refcount) {
+		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
+		return -EINVAL;
 	}
 
+	if (--dev_ser->refcount)
+		return 0;
+
 	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
 	ser->nr_devices--;
 	memset(dev_ser, 0, sizeof(*dev_ser));
 	dev->liveupdate.outgoing = NULL;
+	return 0;
 }
 
-static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *dev)
+static int pci_liveupdate_preserve_device_again(struct pci_dev *dev)
 {
-	int i;
+	if (!dev->liveupdate.outgoing->refcount) {
+		pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
+		return -EINVAL;
+	}
 
-	if (dev->liveupdate.outgoing)
+	/*
+	 * Endpoint devices should not be preserved more than once. Bridges are
+	 * preserved once for every downstream device that is preserved.
+	 */
+	if (!dev->subordinate)
 		return -EBUSY;
 
+	dev->liveupdate.outgoing->refcount++;
+	return 0;
+}
+
+static int __pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *dev)
+{
+	int i;
+
 	if (ser->nr_devices == ser->max_nr_devices)
 		return -ENOSPC;
 
@@ -312,6 +348,52 @@ static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *d
 	return -ENOSPC;
 }
 
+static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *dev)
+{
+	if (dev->liveupdate.outgoing)
+		return pci_liveupdate_preserve_device_again(dev);
+
+	return __pci_liveupdate_preserve_device(ser, dev);
+}
+
+#define for_each_pci_dev_in_path(_d, _start, _end) \
+	for ((_d) = (_start); (_d) != (_end); (_d) = (_d)->bus->self)
+
+static void __pci_liveupdate_unpreserve_path(struct pci_ser *ser,
+					     struct pci_dev *start,
+					     struct pci_dev *end)
+{
+	struct pci_dev *dev;
+
+	for_each_pci_dev_in_path(dev, start, end) {
+		if (pci_liveupdate_unpreserve_device(ser, dev))
+			return;
+	}
+}
+
+static void pci_liveupdate_unpreserve_path(struct pci_ser *ser,
+					   struct pci_dev *start)
+{
+	__pci_liveupdate_unpreserve_path(ser, start, /*end=*/NULL);
+}
+
+static int pci_liveupdate_preserve_path(struct pci_ser *ser,
+					struct pci_dev *start)
+{
+	struct pci_dev *dev;
+	int ret;
+
+	for_each_pci_dev_in_path(dev, start, NULL) {
+		ret = pci_liveupdate_preserve_device(ser, dev);
+		if (ret) {
+			__pci_liveupdate_unpreserve_path(ser, start, dev);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * pci_liveupdate_preserve() - Preserve a PCI device across Live Update
  * @dev: The PCI device to preserve.
@@ -321,6 +403,9 @@ static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *d
  * pci_liveupdate_preserve() from their struct liveupdate_file_handler
  * preserve() callback to ensure the outgoing struct pci_ser is already set up.
  *
+ * pci_liveupdate_preserve() automatically preserves all bridges upstream of
+ * @dev.
+ *
  * Returns: 0 on success, <0 on failure.
  */
 int pci_liveupdate_preserve(struct pci_dev *dev)
@@ -336,7 +421,7 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
 	if (IS_ERR(ser))
 		return PTR_ERR(ser);
 
-	return pci_liveupdate_preserve_device(ser, dev);
+	return pci_liveupdate_preserve_path(ser, dev);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
 
@@ -349,6 +434,9 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
  * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
  * unpreserve() callback to ensure the outgoing struct pci_ser is already set
  * up.
+ *
+ * pci_liveupdate_unpreserve() automatically unpreserves all bridges upstream of
+ * @dev.
  */
 void pci_liveupdate_unpreserve(struct pci_dev *dev)
 {
@@ -362,7 +450,7 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
 		return;
 	}
 
-	pci_liveupdate_unpreserve_device(ser, dev);
+	pci_liveupdate_unpreserve_path(ser, dev);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
 
@@ -534,29 +622,41 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 	}
 }
 
-static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
+static int pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
 {
 	if (!dev->liveupdate.incoming) {
 		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
-		return;
+		return -EINVAL;
 	}
 
-	if (dev->liveupdate.incoming->refcount != 1) {
-		pci_WARN(dev, 1, "Preserved device has a corrupted refcount!\n");
-		return;
+	if (!dev->liveupdate.incoming->refcount) {
+		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
+		return -EINVAL;
 	}
 
 	/*
-	 * Drop the refcount so this device does not get treated as an incoming
-	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
-	 * again because the device is hot-plugged.
+	 * Decrement the refcount so this device does not get treated as an
+	 * incoming device again, e.g. in case pci_liveupdate_setup_device()
+	 * gets called again because the device is hot-plugged.
 	 */
-	dev->liveupdate.incoming->refcount = 0;
+	if (--dev->liveupdate.incoming->refcount)
+		return 0;
 
 	pci_info(dev, "Device is finished participating in Live Update\n");
 	dev->liveupdate.incoming = NULL;
 	ser->nr_devices--;
 	pci_liveupdate_flb_put_incoming();
+	return 0;
+}
+
+static void pci_liveupdate_finish_path(struct pci_ser *ser, struct pci_dev *start)
+{
+	struct pci_dev *dev;
+
+	for_each_pci_dev_in_path(dev, start, NULL) {
+		if (pci_liveupdate_finish_device(ser, dev))
+			return;
+	}
 }
 
 /**
@@ -568,6 +668,8 @@ static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *de
  * Update. Drivers must call pci_liveupdate_finish() from their struct
  * liveupdate_file_handler finish() callback to ensure the incoming struct
  * pci_ser is allocated.
+ *
+ * pci_liveupdate_finish() automatically finishes all bridges upstream of @dev.
  */
 void pci_liveupdate_finish(struct pci_dev *dev)
 {
@@ -581,7 +683,7 @@ void pci_liveupdate_finish(struct pci_dev *dev)
 		return;
 	}
 
-	pci_liveupdate_finish_device(incoming->ser, dev);
+	pci_liveupdate_finish_path(incoming->ser, dev);
 	pci_liveupdate_flb_put_incoming();
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index 85def616703d..c86518be4ce7 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -23,7 +23,7 @@
  * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
  */
 
-#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
+#define PCI_LUO_FLB_COMPATIBLE "pci-v3"
 
 /**
  * struct pci_dev_ser - Serialized state about a single PCI device.
@@ -32,7 +32,8 @@
  * @bdf: The device's PCI bus, device, and function number.
  * @refcount: Reference count used by the PCI core to keep track of whether it
  *            is done using a device's struct pci_dev_ser. The value of the
- *            refcount is equal to 1 when the struct pci_dev_ser is in use, and
+ *            refcount is equal to the number of preserved devices at or below
+ *            it in the PCI hierarchy when the struct pci_dev_ser is in use, and
  *            0 otherwise.
  */
 struct pci_dev_ser {
-- 
2.54.0.746.g67dd491aae-goog


