Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C844CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 686C16B008C; Tue, 12 May 2026 14:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6358F6B0092; Tue, 12 May 2026 14:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527AC6B0093; Tue, 12 May 2026 14:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6286B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:48:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E30FA1405C6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:55 +0000 (UTC)
X-FDA: 84759654630.05.8CA3B3A
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1855B10000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cXALS38F;
	spf=pass (imf05.hostedemail.com: domain of 3FHYDaggKCGUGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3FHYDaggKCGUGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T4K+3x46P5Tng2/W1DPr8N223Eo9F5ffuPNYieXQuRE=;
	b=JTpJ/qx4O46bJrATqnPWX3OOugMTiJG4lgMM6EJOGYaU+2vIa/t+bUjlXLlIzlW7krn+AH
	A8ipLbLkw9GD6jNYbhXGRVKyBDEV9rv6uyvCJTy80tr9OpQa7gIeF2RSn4RbeL52b9zIM0
	appZ3b8VvrTdGG/GFc59y7m9k73FJDU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611734; a=rsa-sha256;
	cv=none;
	b=cZ8eXUm25hClLfEgNf/bWzGEAIHSimQMEGiL+Gmn0QoUg2VO7uaJv1m718bPSIlaNNW2u/
	b3W97kaRlslf52amnPi82l2YQWTqVJ5Y1yXIFEzFLXGe0lGY4E8se7LtQubcIPyruSlpsA
	W+KziRq0xnxGGmWMd9eMypMZLvjkrDw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cXALS38F;
	spf=pass (imf05.hostedemail.com: domain of 3FHYDaggKCGUGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3FHYDaggKCGUGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2baf7378ad0so46362345ad.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611733; x=1779216533; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T4K+3x46P5Tng2/W1DPr8N223Eo9F5ffuPNYieXQuRE=;
        b=cXALS38FnrIPBff/itAJXHYrUefkeT8TT61y/LTLMi2gdVTvPb2v4BBoahBHV+Q7qy
         DqrfuqHgaRFSs7f8kXoDuhbPFYzJjo4XIWaajOSezD1ra69DyO5DizLcBPolPLsSYTcz
         6aSqMZw/213v7wf8MndH7SoFRgl/EfFyyotBG4vko4wT6GyVSkFqSsL+KHAwY1SNeCGr
         wyr9yEO+Bai1cKUMNLFX+rxP1h0/oqoe7h/2wsNo+3ARPvkgRxwJrv7iPBNub2TAdJVz
         Mb8I5eUSDM9xu/T5MW8sO7FVYVeF57OhQp7YZc0Z3Tw8OaUcrMFLpx3RVOd8++3jHXSm
         GXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611733; x=1779216533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T4K+3x46P5Tng2/W1DPr8N223Eo9F5ffuPNYieXQuRE=;
        b=aVtMm7QWWsExnbUf6HCJt1kz6UsXEf8MEwkkK9XbPfLwwfivDCaG33YJgN0CFCu7x/
         64AARNwqP6UAdXm2JLBaywero6pLhnekkmvwcdzoP24Z6Tjru/YYckZdtWcpPIqHo1Sf
         f83MjyFBTGKLnUupJV/2rqEQr3+3E7ChAm3x7aTsmKBgkekoqGqljLB/cHxGyET9b8pd
         z9tm35BN3fWbdOAJAONAezzmUpKXBMn4N2Z4OAIpMJr2NSXD4Gwvfj0+fRx0pQu5b4eo
         6nEWV6BA/LPyPwymgFJ7jhePk5l/9z5eOWpqxYYq6fBE2cKaQ2NxVNCG1BOb4uyQG0Y1
         KWNg==
X-Forwarded-Encrypted: i=1; AFNElJ/JNrdS3wF3tpIYBJJwPLsRvaWaXgzJCoAXzZqVoqbzahgcA1Z6QK4XauDVGaJ2d5eIkj7fAOO49Q==@kvack.org
X-Gm-Message-State: AOJu0YxP2iBtR2fPrr0aq+GwTE0Ctvv0cB8wQ1q0rGSSfXrapowwTL3C
	1amEShhDBvn0qvNErf4Kwg6v7CzV1snRUOnK2GLDo3Q3vcrAtYQOR9OcExOhy3GWc0N+oUXCKlv
	Occ7xJx89EABbfw==
X-Received: from plbkf6.prod.google.com ([2002:a17:903:5c6:b0:2b9:53bb:4a09])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ed04:b0:2bc:78ec:54c0 with SMTP id d9443c01a7336-2bd27291c8emr1934145ad.31.1778611732668;
 Tue, 12 May 2026 11:48:52 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:37 +0000
In-Reply-To: <20260512184846.119396-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260512184846.119396-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-3-dmatlack@google.com>
Subject: [PATCH v5 02/11] PCI: liveupdate: Track outgoing preserved PCI devices
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1855B10000D
X-Stat-Signature: 56quxcg4ahp6phbb6adih893zon8fsnc
X-Rspam-User: 
X-HE-Tag: 1778611733-823969
X-HE-Meta: U2FsdGVkX18nOV49pqa6XLr8qewPa1U6qUVdjDR5EgigBm1BZHO2jY5HO2oi9WIVUp1UPY5u9vUlSSgxKxUh7jMp/YoD+H3NfBeyKe58wfPQip37GZtPOlV/pbnfe/K+NJR7+gYL7S+D41zMCgNxIT3PHo43HHitFUTdKnY9P+vKDf9ydgoiMmlvZPMiJyc2iaztEGHeeML6ggkz/b3v42nVw08IrJqpsdbrg1nRGhnM5WuApr/wSIJpOhIMae4ycM9b6WKuyVxsFNZdj91hf0Z+evxgLmLg5bgs2LjD1SOlJg8PG6rc6vu4LPcDtbThJ/WuqMlegRBjrPtpMEYJ5OfeltPWFQPqamK/fhpr1jOHtL0tQebm4nuP2QLvDbvhgNQPF56IPF67MZARKTbJJbmcjsnuiE02aG4h0AW2K9GSssdVeJ4oK/+yC9irRBnwsScLCWIwfkwIwc2BUn4Y7RxXRt997vPydP5k7X5l+QR0iFKWZpZk1vlm+SUyBzRn0brZUxAQ/NCqWFQ9rgHPQIQP5VXszOUur0zRA4HgKFHNAaWjkz6ApNNjNFnraYyoFe8G+DaEXP1EuI3DsqHUJ+af2kzvE+d6KWHj1O5ezmnvbo9Kx2OpZEYcoaDxcQs/UA6X6uCC/Bc28+avm9tV8RZe0drICf/AXMeLooqmKiK2FEB9BFm6l4bPMpKJeefAyYD0rhP6VCJdQ3M2RB9B1TfBYaJKAyW9Dco6hnCseYQ7qSQDJEnlkey/xFP+YOz62RtVwueffS4xkk/iXH7bsE//fE+7Jb0taGbj3wbb9o50h+VH+Tm2nOfNMMpo1hnUGkFrwl6ztFrWjVnMjQ6TxDv+ukuOouCWSH7FlN6Sismdmf3Qdma8WVJXxk85qEouVKXRir6nVESNi5C8DNZpWORgHYS44tSi4od8fDsUAigK2YBLlApV6I22/VnjSoFQ+tGPm+Wlq1JOql1XkvZ
 EcwPkO+9
 PijM/8uGKJmzktmyFlcWsIlTzgbCk44cYFdHQVwY+Xi8qgSUTdpqQ60FkFtSvotv8LITACM44wDLTF8rRXGjbW5dWZTDwYiJWoU2OiGP13rnZMRicu/cPJKaSqV2XQ62ZG3KPxwlWTbS6dn4XumJJzSQOx8uYPDJQJ2/exDW1zpCj6DJL8TVE8UPdpT8NFBdAzThjSArgp+HbPIcMfm2CTNtehSKgBQ64/YKzzNlYC+3H9mrXAkwTqiBgB5VAium7tZn7sFGkeavIK/VdBDFQkR35e8F8Qnw/LunkVuBYFfTBfA9IaQO+oFZ+UfD3jG+GPc+hHWv249qOd8+5rz6rXVAT58W0FTMqDxo57JZ0EcmHnFf8UkyrYLaO9XUGBiUy3xIkBJAwYW1rSiRFe4YU/OlCGjT88h9KlOAgDEaAF/pi95RxqjtoSSWuw8LhgfAuIN124kSyH9nZoO5z+Y2Q9xesbNaEqHlFxwYxbUuXvmpMJxuAPgSXLmowb2rp58p3y7NcfxYu+GKNHsMa73gZLTwyo+VoNrpCc3XPl70O70eBZ0jw+RVSRN8ZDqU50M0oB87+XFkerYnZQjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add APIs to allow drivers to notify the PCI core of which devices are
being preserved across a Live Update for the next kernel, i.e.
"outgoing" devices.

Drivers must notify the PCI core when devices are preserved so that the
PCI core can update its FLB data (struct pci_ser) and track the list of
outgoing devices. pci_liveupdate_preserve() notifies the PCI core that a
device must be preserved across Live Update. pci_liveupdate_unpreserve()
reverses this (cancels the preservation of the device).

This tracking ensures the PCI core is fully aware of which devices may
need special handling during shutdown and kexec, and so that it can be
handed off to the next kernel.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c       | 167 ++++++++++++++++++++++++++++++---
 drivers/pci/probe.c            |   3 +
 include/linux/kho/abi/pci.h    |   9 +-
 include/linux/pci.h            |   3 +
 include/linux/pci_liveupdate.h |  23 +++++
 5 files changed, 191 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index dd2449e12b6d..9c4582ecd55c 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -43,6 +43,26 @@
  *
  *  * ``pci_liveupdate_register_flb(driver_file_handler)``
  *  * ``pci_liveupdate_unregister_flb(driver_file_handler)``
+ *
+ * Device Tracking
+ * ===============
+ *
+ * Drivers must notify the PCI core when specific devices are preserved or
+ * unpreserved with the following APIs:
+ *
+ *  * ``pci_liveupdate_preserve(pci_dev)``
+ *  * ``pci_liveupdate_unpreserve(pci_dev)``
+ *
+ * This allows the PCI core to keep its FLB data (struct pci_ser) up to date
+ * with the list of **outgoing** preserved devices for the next kernel.
+ *
+ * Restrictions
+ * ============
+ *
+ * The PCI core enforces the following restrictions on which devices can be
+ * preserved. These may be relaxed in the future:
+ *
+ *  * The device cannot be a Virtual Function (VF).
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -55,13 +75,29 @@
 #include <linux/mm.h>
 #include <linux/pci.h>
 
+/**
+ * struct pci_flb_outgoing - Outgoing PCI FLB object
+ * @ser: The outgoing struct pci_ser for the next kernel.
+ * @lock: Lock used to protect against changes to @ser.
+ */
+struct pci_flb_outgoing {
+	struct pci_ser *ser;
+	struct mutex lock;
+};
+
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
+	struct pci_flb_outgoing *outgoing;
 	struct pci_dev *dev = NULL;
 	u32 max_nr_devices = 0;
-	struct pci_ser *ser;
 	unsigned long size;
 
+	outgoing = kmalloc_obj(*outgoing);
+	if (!outgoing)
+		return -ENOMEM;
+
+	mutex_init(&outgoing->lock);
+
 	/*
 	 * Allocate enough space to preserve all of the devices that are
 	 * currently present on the system. Extra padding can be added to this
@@ -74,27 +110,30 @@ static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 
 	size = struct_size_t(struct pci_ser, devices, max_nr_devices);
 
-	ser = kho_alloc_preserve(size);
-	if (IS_ERR(ser))
-		return PTR_ERR(ser);
+	outgoing->ser = kho_alloc_preserve(size);
+	if (IS_ERR(outgoing->ser)) {
+		kfree(outgoing);
+		return PTR_ERR(outgoing->ser);
+	}
 
 	pr_debug("Preserved struct pci_ser with room for %u devices\n",
 		 max_nr_devices);
 
-	ser->max_nr_devices = max_nr_devices;
-	ser->nr_devices = 0;
+	outgoing->ser->max_nr_devices = max_nr_devices;
+	outgoing->ser->nr_devices = 0;
 
-	args->obj = ser;
-	args->data = virt_to_phys(ser);
+	args->obj = outgoing;
+	args->data = virt_to_phys(outgoing->ser);
 	return 0;
 }
 
 static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
 {
-	struct pci_ser *ser = args->obj;
+	struct pci_flb_outgoing *outgoing = args->obj;
 
-	WARN_ON_ONCE(ser->nr_devices);
-	kho_unpreserve_free(ser);
+	WARN_ON_ONCE(outgoing->ser->nr_devices);
+	kho_unpreserve_free(outgoing->ser);
+	kfree(outgoing);
 
 	pr_debug("Unpreserved struct pci_ser\n");
 }
@@ -123,6 +162,112 @@ static struct liveupdate_flb pci_liveupdate_flb = {
 	.compatible = PCI_LUO_FLB_COMPATIBLE,
 };
 
+/**
+ * pci_liveupdate_preserve() - Preserve a PCI device across Live Update
+ * @dev: The PCI device to preserve.
+ *
+ * pci_liveupdate_preserve() notifies the PCI core that a PCI device should be
+ * preserved across the next Live Update. Drivers must call
+ * pci_liveupdate_preserve() from their struct liveupdate_file_handler
+ * preserve() callback to ensure the outgoing struct pci_ser is allocated.
+ *
+ * Returns: 0 on success, <0 on failure.
+ */
+int pci_liveupdate_preserve(struct pci_dev *dev)
+{
+	struct pci_flb_outgoing *outgoing = NULL;
+	struct pci_ser *ser;
+	int i, ret;
+
+	if (dev->is_virtfn)
+		return -EINVAL;
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&outgoing);
+	if (ret)
+		return ret;
+
+	if (!outgoing)
+		return -ENOENT;
+
+	guard(mutex)(&outgoing->lock);
+	ser = outgoing->ser;
+
+	guard(write_lock)(&dev->liveupdate.lock);
+
+	if (dev->liveupdate.outgoing)
+		return -EBUSY;
+
+	if (ser->nr_devices == ser->max_nr_devices)
+		return -ENOSPC;
+
+	for (i = 0; i < ser->max_nr_devices; i++) {
+		/*
+		 * Start searching at index ser->nr_devices. This should result
+		 * in a constant time search under expected conditions (devices
+		 * are not getting unpreserved).
+		 */
+		int index = (ser->nr_devices + i) % ser->max_nr_devices;
+		struct pci_dev_ser *dev_ser = &ser->devices[index];
+
+		if (dev_ser->refcount)
+			continue;
+
+		pci_info(dev, "Device will be preserved across next Live Update\n");
+		ser->nr_devices++;
+
+		dev_ser->domain = pci_domain_nr(dev->bus);
+		dev_ser->bdf = pci_dev_id(dev);
+		dev_ser->refcount = 1;
+
+		dev->liveupdate.outgoing = dev_ser;
+		return 0;
+	}
+
+	return -ENOSPC;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
+
+/**
+ * pci_liveupdate_unpreserve() - Cancel preservation of a PCI device
+ * @dev: The PCI device to preserve.
+ *
+ * pci_liveupdate_unpreserve() notifies the PCI core that a PCI device should no
+ * longer be preserved across the next Live Update. Drivers must call
+ * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
+ * unpreserve() callback to ensure the outgoing struct pci_ser is allocated.
+ */
+void pci_liveupdate_unpreserve(struct pci_dev *dev)
+{
+	struct pci_flb_outgoing *outgoing = NULL;
+	struct pci_dev_ser *dev_ser;
+	struct pci_ser *ser;
+	int ret;
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&outgoing);
+
+	if (ret || !outgoing) {
+		pci_warn(dev, "Cannot unpreserve device without outgoing Live Update state\n");
+		return;
+	}
+
+	guard(mutex)(&outgoing->lock);
+	ser = outgoing->ser;
+
+	guard(write_lock)(&dev->liveupdate.lock);
+
+	dev_ser = dev->liveupdate.outgoing;
+	if (!dev_ser) {
+		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
+		return;
+	}
+
+	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
+	ser->nr_devices--;
+	memset(dev_ser, 0, sizeof(*dev_ser));
+	dev->liveupdate.outgoing = NULL;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
+
 /**
  * pci_liveupdate_register_flb() - Register a file handler with the PCI core
  * @fh: The file handler to register.
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b63cd0c310bc..54ae32cb0000 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2522,6 +2522,9 @@ struct pci_dev *pci_alloc_dev(struct pci_bus *bus)
 	spin_lock_init(&dev->pcie_cap_lock);
 #ifdef CONFIG_PCI_MSI
 	raw_spin_lock_init(&dev->msi_lock);
+#endif
+#ifdef CONFIG_PCI_LIVEUPDATE
+	rwlock_init(&dev->liveupdate.lock);
 #endif
 	return dev;
 }
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index 6ebcf817fff4..807fe0e6538f 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -23,19 +23,22 @@
  * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
  */
 
-#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
+#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
 
 /**
  * struct pci_dev_ser - Serialized state about a single PCI device.
  *
  * @domain: The device's PCI domain number (segment).
  * @bdf: The device's PCI bus, device, and function number.
- * @padding: Padding to naturally align struct pci_dev_ser.
+ * @refcount: Reference count used by the PCI core to keep track of whether it
+ *            is done using a device's struct pci_dev_ser. The value of the
+ *            refcount is equal to the number of devices preserved at or below
+ *            this device in the PCI hierarchy.
  */
 struct pci_dev_ser {
 	u32 domain;
 	u16 bdf;
-	u16 padding;
+	u16 refcount;
 } __packed;
 
 /**
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8cadeeab86fd..a7c3722b1e77 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -594,6 +594,9 @@ struct pci_dev {
 	u8		tph_mode;	/* TPH mode */
 	u8		tph_req_type;	/* TPH requester type */
 #endif
+#ifdef CONFIG_PCI_LIVEUPDATE
+	struct pci_liveupdate liveupdate;
+#endif
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 8ec98beefcb4..0803d44becd5 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -8,14 +8,28 @@
 #ifndef LINUX_PCI_LIVEUPDATE_H
 #define LINUX_PCI_LIVEUPDATE_H
 
+#include <linux/kho/abi/pci.h>
 #include <linux/liveupdate.h>
 #include <linux/types.h>
+#include <linux/spinlock_types.h>
+
+/**
+ * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
+ * @lock: Lock used to protect members of struct pci_liveupdate.
+ * @outgoing: State preserved for the next kernel.
+ */
+struct pci_liveupdate {
+	rwlock_t lock;
+	struct pci_dev_ser *outgoing;
+};
 
 struct pci_dev;
 
 #ifdef CONFIG_PCI_LIVEUPDATE
 int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
 void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
+int pci_liveupdate_preserve(struct pci_dev *dev);
+void pci_liveupdate_unpreserve(struct pci_dev *dev);
 #else
 static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
@@ -25,6 +39,15 @@ static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh
 static inline void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
 {
 }
+
+static inline int pci_liveupdate_preserve(struct pci_dev *dev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void pci_liveupdate_unpreserve(struct pci_dev *dev)
+{
+}
 #endif
 
 #endif /* LINUX_PCI_LIVEUPDATE_H */
-- 
2.54.0.563.g4f69b47b94-goog


