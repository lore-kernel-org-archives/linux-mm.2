Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87531C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C8C6B0099; Fri, 18 Sep 2026 16:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4006B009B; Fri, 18 Sep 2026 16:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87DF76B009D; Fri, 18 Sep 2026 16:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB7C6B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:06:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3AD3407FE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:06:58 +0000 (UTC)
X-FDA: 85227966516.03.325AA56
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf19.hostedemail.com (Postfix) with ESMTP id EC3F61A0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:06:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qaHz3egm;
	spf=pass (imf19.hostedemail.com: domain of 335mtaggKCCYFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=335mtaggKCCYFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ct2oZmMMqiZqS2gqo7YSORMBPVLQ4WC/tqkRDMbJuzU=;
	b=EIy/S+nXbFja8rMoZZGfIffNjSssaAhO7Fdr8G7p5/HJwzF+Bvhf9XWEX2U/6dcYNGsnUS
	rlQOPwXqv5BV1xLSmu/vVFDeAwUfTOzrI4GZn3xE2ZnZ6NF4JETWhogNuuaBf5TygPMR89
	jvsTX0y4mlbRF9YioN47AdHfk0ojF24=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qaHz3egm;
	spf=pass (imf19.hostedemail.com: domain of 335mtaggKCCYFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=335mtaggKCCYFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762016;
	b=5LuoBQBugUUzue4YiIIwkdbEFgJOLUjARIp4TmmPwCfNIwHqvAH07mCnXxskK6V64TfPY8
	x8QoAdOKkrYiTEbGLkuAF0iRkVxT1BLr1NZoOjR9p4VDfplDJVTl/BCnvAlOxvtqO6fVX5
	HJ92NQhwo8zR35Qz5LQK9hJa5ZLIZ14=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2dd188e16a2so13424835ad.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762016; x=1790366816; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ct2oZmMMqiZqS2gqo7YSORMBPVLQ4WC/tqkRDMbJuzU=;
        b=qaHz3egm4VfourwnbMXbst5frcURtxv/OQ7+GMjHXpRbD92Y/il8rBy5TqXTLyGjya
         O4Y1wdvBkyAcuF8DeaW/Ti0XZdg5/lsTMX32SenaQiiBxiewQwsjW7ZtGZ4pi/bIJvKq
         oaNg4IZY/2TfX8f4eqP2aL/oWggaeG0kT4SD1txXOd5rw62bHcmn/oGa25EMnYJUBFJh
         TFGnO92Osg0daCIDBf6F0jeZK4G0wN14fdols8LUM9IMztYAHtf2cJbW5YZMYh2ZqscP
         i7mRpGbru0BKebidpwQpYtVKSj29F/IwHudMiYPZ0+jRJ/GXgYkjUXRlfCvrFTF3q3Xs
         PUxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762016; x=1790366816;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ct2oZmMMqiZqS2gqo7YSORMBPVLQ4WC/tqkRDMbJuzU=;
        b=GWPHs8Qu/EP9mcbGNGcblbW5wT8fdo0msNQAx0K7s4eByKZTvvkVSi7L8YMr36gstg
         s1ss4MkkaPr7I79sQAyBdPU9X2ir9vYSMFq4T/oi9/SHShh//IvuxtMhfkivsvUvTOLn
         yavJqZ79ObKpRmzEes5rLUGo19f3rY0sRXPPKaWSGvEWDEoPv2/byIWnpcdp45/VM7wb
         5psrnjns0O5i4nr1RYhtFdWE/NUg1/4ahPJ3NvQGAqU3zY9WmTKbvXsEuOX1zlNxVgZz
         qxkCHBGLczdPurxfhcYl+kZJCcbkWnSGJZtROAANk49MaIUWZyiWVw1mNRHXh/4NlJ3C
         7QZA==
X-Forwarded-Encrypted: i=1; AKwUvBwuvlgna+7oBlgEZ7wReuI0tsQpdtmAOv4fZ6h3CCWYoab0mqaPOhn1yIg/pF/xqk3Ecr9q4c3g/w==@kvack.org
X-Gm-Message-State: AFuF++mbiR5kIyCcBisijNZsJL5VljgiFMWmHrzgs1kIkJuk4zNrvjGn
	s0erI9X/pRTB+g5y1XmKYZyU1qIlZgU7fYnQJ0BdzEhJs8KWtwZH5HPEkhpEJVhAVn8tbkJKJ42
	4FbZgVLKeu32I+Q==
X-Received: from plat5.prod.google.com ([2002:a17:902:e1c5:b0:2dd:388a:cfae])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1a8c:b0:2dd:c100:4b7c with SMTP id d9443c01a7336-2ddc1005f28mr9783735ad.51.1789762015597;
 Fri, 18 Sep 2026 13:06:55 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:28 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-3-dmatlack@google.com>
Subject: [PATCH v9 02/13] PCI: liveupdate: Track outgoing preserved PCI devices
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
X-Rspamd-Queue-Id: EC3F61A0003
X-Stat-Signature: wdj7x19ooozk8sda8ku4q3o98s88zeei
X-Rspam-User: 
X-HE-Tag: 1789762016-612757
X-HE-Meta: U2FsdGVkX1/qvGxk3LifpkGGkdTUCPduumoOv/ETHMsnMqF/Gr6Ms+h6ILV1aus4OleOryC5NhYu0kYMthUPkI8Ebsc1LYZnrtVWRjOIsP/hwP/xjbD0/aASJXhLhKxuRFh1aB2wXZv5vnEFldoHS8Ly8Auppr5GDfS7Y0z8yKdlFdpxtwB5dwmICD0K4HhBSuVLk9nq8dtj0y90dm2AcMIGqxSFab/FFdSF/mYIjl5EEfl3lGaeJBBGL6+j2k5cyyEhxpH7HSnwfha9p3RQ0uMMpJUoRB5iCNhMORgICwvxc6BL2t/aMIXze49W18fXMBlTHkK+dLWrLx3o/fByletHR1yqQrs4yGWi68w3CYxdqvOiq+5hMs6d3aFheMs5rvN2kKAznmu+8GNXJovT0pN3/N9ztwz7LdSnwNz3PtU+52ztXK7u2dqmTUNfOEftYOkxxWm973Y60RQxsZrKIe5AgpRADcZP2gMSmy6c2jEhpYKB/5nyNpL+X2v/z2NhKNfziQSNLptEL15OtGq51/RS3Z5gFcLnFVIVFLH4Ib7IHUfmt0OEbcBSMNwnAlseiMu/rwOXSYeocS47737zxTG9U2D80gA35I4Ui60a5BLKw9Pe/tdd2CkFR5I5lFDBG7GhSU2VbTJXT3Yq+ZNmSlujIccrloZJcJh9hpRXnku4ov/Z8Wn9O2zmRXJK3+VlzOTXSVHzUYEIdDRsY66lGwBGLLjoBovMAdXjiPFmotu2hoifbvdryujCFhJQdjcmphxgGGcloKbDQiJKfSjeoZdo1PgL+L79gITXHD8Qbcyb4NRQZt0V88G4dAexAOkjh9kGZXZam4OPIrMF8N6rsuLMaWMtvFi8jbscT07aw9y3VQTnOVLahakcduZ98gFW3H9vQoBq+dS10oLnRC2xn+1ulmebiQXyS2NeIeg5j3L6IvqWmk96XnhEJ1qWzQDkTTVy3AudwCXAsZfr3Qt
 StIaYSlr
 GcIKmtmbX/RKX/qZTbYW7GGhqFMrKA+c3vBvhBQsN5pAdiSLPqt5aIuWdnUsgTbhuOWB9w6qo6clcvQJxnRRsejVjNZJ53HeochFNZqHJSRKP41Ag3QRBQdxVtHr22ngHlCJfjlXEzNC4ii6mtHX9cxxM+iXi5+9Hhd7klbeRt9MtQ502LFLLx28owotJ9LYEZhxyhjMPYmeDifwGEesBXQp7p647Z++eIabUZSPnZGvRZ7YrUfiXwp/Cjr5ZGatzixPg0XBa3XRf0QDCoGu/4uEfGkXeJzGVsYG81kWO+M6HDMul7Rr7c86jO4MyDrmQhdEYFNZGD2ZeEHSdd97QlJwrKKlrO+lRaAcsfvCKdyCe3kPP8mn2w67d7oOP0MUEaU77zMtcF73zfA3wIpH6OabkhwmJ4+pEMeXWv9IdY7Um+K7ohO81QzCW0RgC4sec+pyCZ1kbG4bcSmg+LsI7AIz2PZ2ucXphIASOsf0ztkTPQ+878yDwO+xgA1reqGUFvAlNmBw6pll5cY/uOWEm2m+/tqPQfaZD7VvI/YhlTUSTKL1ARPU+CvxOTgq15lt9NG5csRIG0O7xJWkNrRQqkovqSlBF02dPuZbdFJ0tXS9KWAo1xPkOfvDibK4PYr/C9+4YfhDt1SkUAMFFF1VVfRoknane0kNI4LAIRflI3mhAveMa/J0FuoLQWg==
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
need special handling during shutdown and kexec, and so the list of
preserved devices can be handed off to the next kernel.

For now, the API only supports preserving non-VF devices on a root bus
(not behind an PCI-to-PCI bridges).

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c       | 211 +++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h       |  21 ++++
 drivers/pci/probe.c            |   2 +
 include/linux/pci.h            |   3 +
 include/linux/pci_liveupdate.h |  21 ++++
 5 files changed, 258 insertions(+)
 create mode 100644 drivers/pci/liveupdate.h

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 66dbee0bd3cf..e0ca537d0cb3 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -59,6 +59,7 @@
  *       luo_flb_file_preserve_one()      # first preserved file only
  *         pci_flb_preserve()             # alloc and preserve struct pci_ser
  *     fh->ops->preserve()                # driver callback
+ *       pci_liveupdate_preserve(dev)     # record this device in struct pci_ser
  *
  *   # Userspace: preservation cancelled or session torn down
  *   luo_file_unpreserve_files()
@@ -79,6 +80,27 @@
  *     luo_flb_file_finish()
  *       liveupdate_flb_put_incoming()    # last incoming file only
  *         pci_flb_finish()               # free struct pci_ser
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
+ *  * The device cannot be behind a PCI-to-PCI bridge.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -93,6 +115,21 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 
+#include "liveupdate.h"
+
+/**
+ * struct pci_liveupdate_global - Global state for PCI Live Update support
+ * @rwsem: Reader/writer semaphore used to protect the incoming and outgoing
+ *         FLBs, and the references to them in struct pci_dev.
+ */
+struct pci_liveupdate_global {
+	struct rw_semaphore rwsem;
+};
+
+static struct pci_liveupdate_global pci_liveupdate = {
+	.rwsem = __RWSEM_INITIALIZER(pci_liveupdate.rwsem),
+};
+
 /**
  * struct pci_flb_outgoing - Outgoing PCI FLB object
  * @ser: Pointer to the preserved struct pci_ser.
@@ -171,6 +208,180 @@ static struct liveupdate_flb pci_liveupdate_flb = {
 	.compatible = PCI_LUO_FLB_COMPATIBLE,
 };
 
+static void pci_liveupdate_flb_put_outgoing(void)
+{
+	liveupdate_flb_put_outgoing(&pci_liveupdate_flb);
+}
+
+static struct pci_flb_outgoing *pci_liveupdate_flb_get_outgoing(void)
+{
+	struct pci_flb_outgoing *outgoing = NULL;
+	int ret;
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&outgoing);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (!outgoing)
+		return ERR_PTR(-ENOENT);
+
+	return outgoing;
+}
+
+static struct pci_dev_ser *pci_flb_alloc_dev_ser(struct pci_flb_outgoing *outgoing)
+{
+	struct pci_dev_ser *dev_ser;
+	struct kho_block_set_it it;
+	u64 count = 0;
+	int err;
+
+	kho_block_set_it_init(&it, &outgoing->block_set);
+
+	/* Try to find an existing, previously unpreserved, entry. */
+	while ((dev_ser = kho_block_set_it_read_entry(&it))) {
+		if (!dev_ser->refcount)
+			return dev_ser;
+
+		count++;
+	}
+
+	/* Otherwise grow the block set and reserve a new entry. */
+	err = kho_block_set_grow(&outgoing->block_set, count + 1);
+	if (err)
+		return ERR_PTR(err);
+
+	if (!count)
+		kho_block_set_it_init(&it, &outgoing->block_set);
+
+	/* This should always succeed since kho_block_set_grow() succeeded. */
+	dev_ser = kho_block_set_it_reserve_entry(&it);
+	if (WARN_ON_ONCE(!dev_ser))
+		return ERR_PTR(-ENOSPC);
+
+	return dev_ser;
+}
+
+static void pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
+					     struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
+
+	if (!dev_ser) {
+		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
+		return;
+	}
+
+	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
+	outgoing->ser->nr_devices--;
+	memset(dev_ser, 0, sizeof(*dev_ser));
+	dev->liveupdate.outgoing = NULL;
+}
+
+static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
+					  struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser;
+
+	if (dev->is_virtfn) {
+		pci_warn(dev, "Cannot preserve Virtual Functions\n");
+		return -EINVAL;
+	}
+
+	if (dev->liveupdate.outgoing) {
+		pci_warn(dev, "Device is already preserved\n");
+		return -EBUSY;
+	}
+
+	if (!pci_is_root_bus(dev->bus)) {
+		pci_warn(dev, "Cannot preserve devices behind bridges\n");
+		return -EINVAL;
+	}
+
+	dev_ser = pci_flb_alloc_dev_ser(outgoing);
+	if (IS_ERR(dev_ser))
+		return PTR_ERR(dev_ser);
+
+	pci_info(dev, "Device will be preserved across next Live Update\n");
+	outgoing->ser->nr_devices++;
+	outgoing->ser->devices = kho_block_set_head_pa(&outgoing->block_set);
+
+	dev_ser->domain = pci_domain_nr(dev->bus);
+	dev_ser->bdf = pci_dev_id(dev);
+	dev_ser->refcount++;
+
+	dev->liveupdate.outgoing = dev_ser;
+	return 0;
+}
+
+/**
+ * pci_liveupdate_preserve() - Preserve a PCI device across Live Update
+ * @dev: The PCI device to preserve.
+ *
+ * pci_liveupdate_preserve() notifies the PCI core that a PCI device should be
+ * preserved across the next Live Update. Drivers are expected to call
+ * pci_liveupdate_preserve() from their struct liveupdate_file_handler
+ * preserve() callback to ensure the outgoing struct pci_ser is already set up.
+ *
+ * Returns: 0 on success, <0 on failure.
+ */
+int pci_liveupdate_preserve(struct pci_dev *dev)
+{
+	struct pci_flb_outgoing *outgoing = NULL;
+	int ret;
+
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+
+	outgoing = pci_liveupdate_flb_get_outgoing();
+	if (IS_ERR(outgoing))
+		return PTR_ERR(outgoing);
+
+	ret = pci_liveupdate_preserve_device(outgoing, dev);
+
+	pci_liveupdate_flb_put_outgoing();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
+
+/**
+ * pci_liveupdate_unpreserve() - Cancel preservation of a PCI device
+ * @dev: The PCI device to unpreserve.
+ *
+ * pci_liveupdate_unpreserve() notifies the PCI core that a PCI device should no
+ * longer be preserved across the next Live Update. Drivers are expected to call
+ * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
+ * unpreserve() callback to ensure the outgoing struct pci_ser is already set
+ * up.
+ */
+void pci_liveupdate_unpreserve(struct pci_dev *dev)
+{
+	struct pci_flb_outgoing *outgoing = NULL;
+
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+
+	outgoing = pci_liveupdate_flb_get_outgoing();
+	if (IS_ERR(outgoing)) {
+		pci_warn(dev, "Cannot unpreserve device without outgoing Live Update state\n");
+		return;
+	}
+
+	pci_liveupdate_unpreserve_device(outgoing, dev);
+	pci_liveupdate_flb_put_outgoing();
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
+
+void pci_liveupdate_cleanup_device(struct pci_dev *dev)
+{
+	/*
+	 * It should be safe to READ_ONCE() outside of the rwsem during cleanup
+	 * since there should no longer be any references to @dev on the system.
+	 *
+	 * This should never happen in practice. Drivers should block removal
+	 * while a device is preserved.
+	 */
+	if (READ_ONCE(dev->liveupdate.outgoing))
+		pci_WARN(dev, 1, "Destroying outgoing-preserved device!\n");
+}
+
 /**
  * pci_liveupdate_register_flb() - Register a file handler with the PCI core
  * @fh: The file handler to register.
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
new file mode 100644
index 000000000000..b2335581f8d0
--- /dev/null
+++ b/drivers/pci/liveupdate.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * PCI Live Update support (core API)
+ *
+ * Copyright (c) 2026, Google LLC.
+ * David Matlack <dmatlack@google.com>
+ */
+#ifndef DRIVERS_PCI_LIVEUPDATE_H
+#define DRIVERS_PCI_LIVEUPDATE_H
+
+#include <linux/pci.h>
+
+#ifdef CONFIG_PCI_LIVEUPDATE
+void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+#else
+static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
+{
+}
+#endif
+
+#endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 27008e2ea5af..2a37e5d3e8e3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -24,6 +24,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/bitfield.h>
 #include <trace/events/pci.h>
+#include "liveupdate.h"
 #include "pci.h"
 
 static struct resource busn_resource = {
@@ -2485,6 +2486,7 @@ static void pci_release_dev(struct device *dev)
 
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
+	pci_liveupdate_cleanup_device(pci_dev);
 	pci_release_of_node(pci_dev);
 	pcibios_release_device(pci_dev);
 	pci_bus_put(pci_dev->bus);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 95b723aecb08..76abe884e3dc 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -599,6 +599,9 @@ struct pci_dev {
 	u8		tph_mode;	/* TPH mode */
 	u8		tph_req_type;	/* TPH requester type */
 #endif
+#ifdef CONFIG_PCI_LIVEUPDATE
+	struct pci_liveupdate liveupdate;
+#endif
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 8ec98beefcb4..894052ad6961 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -8,14 +8,26 @@
 #ifndef LINUX_PCI_LIVEUPDATE_H
 #define LINUX_PCI_LIVEUPDATE_H
 
+#include <linux/kho/abi/pci.h>
 #include <linux/liveupdate.h>
+#include <linux/spinlock_types.h>
 #include <linux/types.h>
 
+/**
+ * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
+ * @outgoing: State preserved for the next kernel.
+ */
+struct pci_liveupdate {
+	struct pci_dev_ser *outgoing;
+};
+
 struct pci_dev;
 
 #ifdef CONFIG_PCI_LIVEUPDATE
 int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
 void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
+int pci_liveupdate_preserve(struct pci_dev *dev);
+void pci_liveupdate_unpreserve(struct pci_dev *dev);
 #else
 static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
@@ -25,6 +37,15 @@ static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh
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
2.55.0.1082.g2b9226bbc0-goog


