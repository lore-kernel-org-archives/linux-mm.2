Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CFDBCC6B1E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0718C6B008C; Tue, 13 Oct 2026 12:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048CF6B0092; Tue, 13 Oct 2026 12:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2B6E6B0095; Tue, 13 Oct 2026 12:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAD036B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2B6740945
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:39 +0000 (UTC)
X-FDA: 85318128798.13.5E5E44A
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id 154E21A0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D62rD6Qa;
	spf=pass (imf19.hostedemail.com: domain of 3gFvOaggKCM0w5tC4tv3z77z4x.v75416DG-553Etv3.7Az@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3gFvOaggKCM0w5tC4tv3z77z4x.v75416DG-553Etv3.7Az@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908738;
	b=wJnFBNwD5Z9ql9lLDCjW7sJm7kbVT+4PaDKrmTTeJVcsZ1nlH9SKqsK0Do4tAzIDT9FmQm
	Sm3DcJdnSuCfKM2gPmWPZFCL6rxo//5vX0RuPuZvIirjOiYclAQ4KApc2rwbLlMZ2ZtBbM
	mXlMXEeqMXI0io9QtwJBK4lHR0tDHy4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D62rD6Qa;
	spf=pass (imf19.hostedemail.com: domain of 3gFvOaggKCM0w5tC4tv3z77z4x.v75416DG-553Etv3.7Az@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3gFvOaggKCM0w5tC4tv3z77z4x.v75416DG-553Etv3.7Az@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNADI9rSGSIXIntWZRaMsSHiModR/dpkujIQp/j5Buc=;
	b=yDRDzXHD6O7Wel5h5IpuyC85NpxhrJl78PnysmA81BloCmOn+/SjCvK/rmjA8pUSCHZufW
	y0m3HOUaDe+QifESNwUzlB95Sm/yBxHKhwfQEdqUW6ODSMQcGsTh/MSDcn4+0W2JzFXFSP
	1adzM+p52WQOu+hwe792H8+8u6E7vew=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e60770381cso27620165ad.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908737; x=1792513537; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fNADI9rSGSIXIntWZRaMsSHiModR/dpkujIQp/j5Buc=;
        b=D62rD6QaFi+QDKESiF9W8hJMwJ76pPbAFJme96j3kvD/mPC8mwIAClMpqnH0g3vUJf
         qn35MXI2o2ggvG1XyQO6neG7yUmSW++wbMLKOjMBtzSMj+GouDjv557xOUUU2JAsRaaY
         rTNHu8W+LzsH0mKqWGsvCwbOMyvCMlZGimxvNL2ydzw+/2oWyzoHWsaJWxepVYbN2Mlp
         4NNYG1EQc2neHwe1Nx88MzK+KqA/I2FWKhXkEQoYchJ91GjSdbWuxxdHvq2W9HA1hSF0
         DW2dG7NZKVKMpBgeXrEMfGfkCDmRwLPFSm104v9D09MY7kG04Rwt4wHIlllpvFwcI1mc
         3DzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908737; x=1792513537;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fNADI9rSGSIXIntWZRaMsSHiModR/dpkujIQp/j5Buc=;
        b=Dx0Ck0Syi6Rf+mscy21xW+qRmldSEltUd1o2Vawa+6m+zpyxCpWRTxV8GJGga+XNAE
         hT54kAmtXO/uixNxWN8WnCgCsBhQa71KqlrtFZptxbj8B7WCtL6wB1K59JcMg0DJHggY
         ZI1x/HSKSyBcN/lFhYPRrZyuKcaYta99/D3JTPYD3CCG6C7zrLZJbNHcQrdvnzEmMMbh
         OpZcrrn/3Y8lKpI1JumPkUKcZeQcYUGb2hzZ7KW8PdQVQDK0RjbIOuHOTOGJXWaNGpwt
         CVBBBGiKNvou8zVKoonjF4ezPy9JJFTBhnpfF9WEYJPqKVfgph3X9kzIo1wCDtuDt3Xr
         Uuww==
X-Forwarded-Encrypted: i=1; AKwUvBxUYVyaFQ/LPtsQd2GXDLza10c5fay5t60ANtLaSBDf4jnEelOeQHoW44+cIjp5SbHVr2OZV/wSDw==@kvack.org
X-Gm-Message-State: AFq9FYICuaNF+LT/y1ZiweatjwDhlqlBMiRI4RyVtw+si9eDBQv5FI4n
	/fHXDLoEaEM3t5IBdL1Vw4RZS24J3q9dQFWBAyv2ii5RT4q7vAUuXDHsGyh7f372C8Xz6g+Pn1/
	/4AmxNTFb9DS0hg==
X-Received: from pgbbq21.prod.google.com ([2002:a05:6a02:455:b0:cc7:d0a5:4738])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e54a:b0:2e6:dbf:c4a8 with SMTP id d9443c01a7336-2e842ab60d3mr118783575ad.12.1791908736252;
 Tue, 13 Oct 2026 09:25:36 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:18 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-3-dmatlack@google.com>
Subject: [PATCH v10 02/13] PCI: liveupdate: Track outgoing preserved PCI devices
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
X-Stat-Signature: 7xiowo8j7ghowotrsudhb3z6bw7abky1
X-Rspamd-Queue-Id: 154E21A0004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791908737-733096
X-HE-Meta: U2FsdGVkX1+JS5/MENmvMDZDrbz/Z3kwKKm/gjCsq9obxXwvbQ2yjqTiuiA1MNj2j+NXw3tBCgcG00EvqGF3h+No25GstIdkxWzHXiy3nnITb19GnTLtZxdzrq5GvmhRcrhe3b0ZrLpQVissuurZNcvYuR8BUYtJsbQheHZP7UjMW3d1Y/vYtFCHeok0jR7ahUZAo7jGYT+IecKW5+1flURQ+1N1KGUmo3XGgO+/hfobunxy2qqWMx5sv6oAuqIe0VMetgIXKAiIvshkMgZkSka3pJXPUFkBMuBtHwHFlV/EOwxaNJZixQq2qKZnuyeVDV/emX4Btu850zgK+aRZy1PrcfIwqUJTZQ5k+a0ii9TOr+0arOWBLLkH238+XR40ssV105E33ttyIRfxSLHZ3gyqMbKFG5KH+yLGHpmeLkUFhbzkxJjuHkWOX22N8B2O7NyCyLKnEm39eqU9J7GmY9HEUDvKnSiF6o9rOWg1dr6rreZeHHIt7uHb+848scMv/sDIN2IszDWPh3O2L5mr/gzV+qr+7PsuxNoddmsYT7az3Z+a8OTkN2yNTxH51XWaPRitPpXjhSC08ShT9u99psdB33nyMREYXiI1S6xhxqVrSsggbnZFJoxyB8e8zgqbVNEymHdiBruB9yVlp3oimEFE85FPMq42TfoTvmq4s/4FMLQZmkfo72RZOIy/MEUeyocWjP4mCgZqhTxF19CzF9+ppYj+iRdnRNNoTgOZsw/ola60esTU3CBagFwGq0a2GBDLBv+6diHQ16PYnQXCOVplvxYEowKzhNxveU+dPnLxqnDBShVpluEnwjsK+4xUVCj7Rn5et/EQeQghQOwYszg7z5AQQ0ZEMHVtgvjChfK+nQ34qb1NiEEPBw3+0mC532IFBeeXImu0I8osaP6w8czhqSOVoyB4W8uRBz6j1pHP0J7qVYhHuq1a5MK7Ec6k2xV1mJkT+aMBpJvEhAc
 ITZomyOX
 9mThRBFCnJXKOjkWwdM/Hb8pimxHhJIjDNz7m4N2UWZtIItjVzYEfhJHzgT7nOaQfPaGHh2JpPH40gpkLy+dXoFMEbeBe4nimRS6uJG4bz76eHxw5E6moI/wRZ9tehHwNBbBqO3B5AEMRelvSEBbtZEIbeco0HZrQvgF3IF+rUL+Grjir6HgqbWbWoZot/nUSrvizqnpJzMR2dKjToP8XA2N6USuGhNhzhz0poLCgLVtfGD5rJaPFr5+4JhL4an28uNoz7SCApNpsVNPUvBo9XV5enCDe66IvCrMrD7JWgMK0jGCjZkh1wVhxj1FVDHHwfr63kOffBW+cJ+0e07RRhWv/8DGw6R4mhCb02xY7Bt/tocB2Q05ZXyYgepm5C17Ulrh26QdzNnUaMz5ZILQeXz8P8uHGIOfWLvjbwGcJpiSVrVO5EDT24CDzpp++ayNuRONOlGaoFgANePqO2VD82gX4pz82cTS1mvE2z+WfNikP2JXV3AZJEkK2sm1/Ub5py/JaEDYXVdPJYgB6qf/CUlEXACAa5svVvS9cuDAf9vskK9hBZb8wEfnejlcrIWpr/+z8ykgLc++2FccvWbZ+feS8W/75+pM/6K/32AiACIpMORU4boBSM+XIJXvyY+5ZbnWSRh8SnKNjZm18XEGerbDJacVz1ad2RZtWhhbo6rXrfnHDRspostW7NQ==
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
index 5f065dccbd7b..22d5d177e104 100644
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
@@ -173,6 +210,180 @@ static struct liveupdate_flb pci_liveupdate_flb = {
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
2.56.0.385.gd3acb90ef8-goog


