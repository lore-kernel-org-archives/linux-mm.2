Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 884F3CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C446B0099; Fri, 22 May 2026 16:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD156B009B; Fri, 22 May 2026 16:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822246B009D; Fri, 22 May 2026 16:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 701E76B0099
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32AAF1C0178
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:17 +0000 (UTC)
X-FDA: 84796182954.03.B331802
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id 67C2A80005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JOPKcndx;
	spf=pass (imf02.hostedemail.com: domain of 3bbsQaggKCH4focvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3bbsQaggKCH4focvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5BsKApi6L+qeqFEzWFS09/i8PEXb73/HfwpwzmTZ0gY=;
	b=SGdKUvRoS3P6AElxek0ifno1dXQnNLMmeXgRFptD7kfA9/B49TT7FOaMgytRWkCedBppqv
	iYx9UxaK8+agFp/oiSwinkvc6yVstRPq5Lwl2TKMWyZBEx9OYInPRpaCVzMIFO00dwAMcl
	LgPyP7kfeGTGY3HLID/hrU6hmkUgudM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JOPKcndx;
	spf=pass (imf02.hostedemail.com: domain of 3bbsQaggKCH4focvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3bbsQaggKCH4focvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481455; a=rsa-sha256;
	cv=none;
	b=E/OC1e6viw+1jxMv21mRI0rJuDR1G7p9Bhiw7Wct3dx57cQ8eHQn6nchbXwx4hIQkG7LVu
	YI7Mqj0s0OopaXLOH+uI32DKRoqEbEPz3YP31g8caAXAB6OhYGi4uNCEnl7FLXS053biGa
	aDrVgBZarPlwL9jV+8XIu8ibordSPJQ=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82fa2165c3eso4872098b3a.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481454; x=1780086254; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5BsKApi6L+qeqFEzWFS09/i8PEXb73/HfwpwzmTZ0gY=;
        b=JOPKcndx/98zeU36KWjFHjlOeDPKpemCybvEEUn8Zq+r3ybLu0cTHZpmsn2ngGxkoa
         +3g8L+Rvn7rM94Fi8C2h5ugihk9hwoaZP7aiNDf8XszMaekdkFQMgbaQhun/9UXcZpXi
         PsUE76JDhE/MpjrBWixIOhviVgHe1cz+VSG8BZGY2I7Aclje3vCsC6xN0nFwcHgaueDL
         VYApV+fmU3kY/1yjc8N/SRSaaT8kLWqZN/UaFTlp5R0Fjsy2rpSwvT1Yh1EHNsohSHwu
         VMJwX709OJODHwNZ6MuJJP1EmOpC89XzhE9E96C+lDslsSRLvKQGmBegax3EzKiwkYPp
         lRUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481454; x=1780086254;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5BsKApi6L+qeqFEzWFS09/i8PEXb73/HfwpwzmTZ0gY=;
        b=VUjCOTJm/hc7pmmiZj+LiuiTuajLw8wpf3bpCDEPVSlYaa6YXkE6WxSNeb/ay929fV
         nWtc6QP6+eI0MR1GNJeYwz1acSr8+WZTTw/PaIORwHh7WtMZ7Xr62FpLbWnupYNTsebh
         XRcxZzqU+bOa75xUOs6ZjdB66dZyEQ9+di+I4z+zr3BSd1g8GFnfPIJKwwo3DcnoXlKy
         uydv/pWrwEopnBQHnd9qB6IASEXLiI1CsCNw6WdZefJA7lSxaOKmC/IV+0VWGDDETlmJ
         sCabnp+7Cx2FwAYhFarPDzF+ql6iREiKrYtiaDGVE1rDZUijTN3lnn8ujkYlu66aKsOI
         DEpA==
X-Forwarded-Encrypted: i=1; AFNElJ8kEufX7k2TWEW5QQOfBXGxK/esAUiD1ym8RjcfA5r2NL875J0w0m2DSOTRryt0cEGWK1YjVAzVrA==@kvack.org
X-Gm-Message-State: AOJu0Yx4J0+gpy7IKmo+G20HFLIkVEQzu6SP59RU4hFTDBa4l94RpSZO
	ih9kACa49i79vA6iaX6wrs/BhBkLYPVSc+RJP15MQ7DJqo+PATCJB2ZgVKTmunr7v8oFRGxP2/P
	zZfxj0Ck3E43Www==
X-Received: from pfbbk29.prod.google.com ([2002:aa7:831d:0:b0:83d:3c25:eb8b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:44c7:b0:837:7e7d:3d9 with SMTP id d2e1a72fcca58-8415f3a3d22mr5271624b3a.44.1779481453749;
 Fri, 22 May 2026 13:24:13 -0700 (PDT)
Date: Fri, 22 May 2026 20:24:00 +0000
In-Reply-To: <20260522202410.3104264-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-3-dmatlack@google.com>
Subject: [PATCH v6 02/12] PCI: liveupdate: Track outgoing preserved PCI devices
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 67C2A80005
X-Stat-Signature: x88nd7kxpr5mh1tciecf6ps4oierdbt3
X-HE-Tag: 1779481455-148245
X-HE-Meta: U2FsdGVkX19POvtDztIbW/cFZ9YSDsj4R2IG+Gagxumt4HyHAXXTSSiBIKQOSEj/8xFYlWHsNtZNkuEDbnWWI9DX9Gtx49JTc9JEI178QiGENPLBaNc+5ENtWNW2BHFwUcjw4OKTziEU9m3+JFVhBhdmgz0+2jU2C8qlSamifr9iEUHrvElZgz4O4gq+gNH59VxkQWb8P57y6pVUrJvaB9eqAMjJEpzIVK0KKmKaBrjewmQfpOR+SjNgNH5lU1ia94k4OcHhAj1FyOsxVapm7xQw1lRPlyBqtxBYPaLQU33vhwpmqocsiCc2VKQk93e2Vn3VZ7eYj9vpsjrI890SsWZtZ8oVEoh6A+4/inck4WQW9cR5IQiPlLa016oKZJQWO1wMXpgitjLUOSF2ylmz53jp6OVe0BkRNfUNDfCRbL8vRdxWwRuwILiOG6MGMeC1gLhIJfE0kf2c1VXcMfX8pk2rAQXmU50/4Ta5dfGFNCtY0EZmN0dOmI9MapyjelrykpDdE4PEnxtb1GvNWE7nGBUmS30MROm6S8p3v6CNUpTQxsBKlhI0H/wrsvSduiKSanVrqosEjX4ueRD1YGpMEHyyIUAcPWv20UwYOZkC02oAMzzgZ68eW1+kCFP1eypi2tWvT17eUeaywBrRcSF1Me/yqgVmyvTSOYmaw7CqrYu15Y/TF0/IpTw4Z7h15cxC91fxbYaQiyLMnSiTQW+vzF6V+qw1vXgTZZbLS/yr+AxXXvR1xbL1+WOrAWrx/eB40Wg8QUd8fW7O7ZK8kcyX1O2FSIN1i8rjywin0tgoDE8Zpt8gPNGgRTlSOpTwwnCFbb+S2bNCRDsTS+dQ9NX9adBoW3qxjoBmXpDHa/SGI6g8b52GrAWIjb133kMRcfwBmQ6DMAHyurtst/vkdEfbp/YnptXMSJ61SlZCzMYa18EnYSVBv2FsPD9/lKa+kyCu/YbZ7pKSgBL5uAoI877
 mXRgxYKa
 bJs2ZlUD33stIqtAMsbXq9X8pl5nUC4cQMGTnur0gUFc5ej2QL7NF+vIyZowvqPMSJFIKcTAKZw0uPlb0nMwC8CQ5B4BZBb+0QhJGjkyj4nBjJtUIWAqcCQ73jEVGd88MvLAGs2J3hpGYvXA4n2JmzQOeOgWatZG4zK+Q3fLy8vwuqJvl0fbxBN2MO+Ai4xWbLrwugYGoQYRtuNVVpa9Z3Xm77a/l07jwr3mo+tbLX9gkn2V9M+udjFjNcNex3OJM+AETG8rE+JUwKJ+szd28RcJ5wqdbm/8ssZ4otl4ZoGG4gqiyz+aVec0O4jW2qp7TJOiyz3T3cAQoQCsCrgkngrCw/OTkoR0lAtYjO9uysM9TTRK9gaTXoDNu2cj8ZjwF8qjpuQ3WRTaMCH1F7gxK5OOQcX7MSIxf2GUUALEZy1QyFapTxi2xT63K3xFtkRv/0B9U/jMtQcKqx5bgFqKtuFzFFxOJDdvU6YUciJ0k4qMYd66zAM2zh6+poIu7HOqagv009WyAgklTjBTmrHReoYdK8fbRN3ThfyF+N9qpZFrjzW6Tl+US2E/6ilzDGKEZsxGLYrBIcqqwEuBlI/DN2cA6DdMs7/MVve6yX3FpFMKqeVpGkSDzvO5hO5NR85V2bcHh
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
 drivers/pci/liveupdate.c       | 167 +++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h       |  21 +++++
 drivers/pci/probe.c            |   2 +
 include/linux/kho/abi/pci.h    |   9 +-
 include/linux/pci.h            |   3 +
 include/linux/pci_liveupdate.h |  21 +++++
 6 files changed, 220 insertions(+), 3 deletions(-)
 create mode 100644 drivers/pci/liveupdate.h

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 737e7b9366db..065d5af822f7 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -36,6 +36,26 @@
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
@@ -48,6 +68,21 @@
 #include <linux/mm.h>
 #include <linux/pci.h>
 
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
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_dev *dev = NULL;
@@ -115,6 +150,138 @@ static struct liveupdate_flb pci_liveupdate_flb = {
 	.compatible = PCI_LUO_FLB_COMPATIBLE,
 };
 
+static struct pci_ser *pci_liveupdate_flb_get_outgoing(void)
+{
+	struct pci_ser *ser = NULL;
+	int ret;
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (!ser)
+		return ERR_PTR(-ENOENT);
+
+	return ser;
+}
+
+static void pci_liveupdate_unpreserve_device(struct pci_ser *ser, struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
+
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
+
+static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *dev)
+{
+	int i;
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
+	struct pci_ser *ser = NULL;
+
+	if (dev->is_virtfn)
+		return -EINVAL;
+
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+
+	ser = pci_liveupdate_flb_get_outgoing();
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	return pci_liveupdate_preserve_device(ser, dev);
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
+	struct pci_ser *ser = NULL;
+
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+
+	ser = pci_liveupdate_flb_get_outgoing();
+	if (IS_ERR(ser)) {
+		pci_warn(dev, "Cannot unpreserve device without outgoing Live Update state\n");
+		return;
+	}
+
+	pci_liveupdate_unpreserve_device(ser, dev);
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
+
+void pci_liveupdate_cleanup_device(struct pci_dev *dev)
+{
+	/*
+	 * It should be safe to READ_ONCE() outside of the rwsem during cleanup
+	 * since there should no longer be any references to @dev on the system.
+	 */
+	if (READ_ONCE(dev->liveupdate.outgoing)) {
+		pci_WARN(dev, 1, "Destroying outgoing-preserved device!\n");
+		pci_liveupdate_unpreserve(dev);
+	}
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
index b63cd0c310bc..b88109a8dfe4 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -24,6 +24,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/bitfield.h>
 #include <trace/events/pci.h>
+#include "liveupdate.h"
 #include "pci.h"
 
 static struct resource busn_resource = {
@@ -2490,6 +2491,7 @@ static void pci_release_dev(struct device *dev)
 
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
+	pci_liveupdate_cleanup_device(pci_dev);
 	pci_release_of_node(pci_dev);
 	pcibios_release_device(pci_dev);
 	pci_bus_put(pci_dev->bus);
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index 6ebcf817fff4..85def616703d 100644
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
+ *            refcount is equal to 1 when the struct pci_dev_ser is in use, and
+ *            0 otherwise.
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
index 8ec98beefcb4..cfcfbfa73af7 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -8,14 +8,26 @@
 #ifndef LINUX_PCI_LIVEUPDATE_H
 #define LINUX_PCI_LIVEUPDATE_H
 
+#include <linux/kho/abi/pci.h>
 #include <linux/liveupdate.h>
 #include <linux/types.h>
+#include <linux/spinlock_types.h>
+
+/**
+ * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
+ * @outgoing: State preserved for the next kernel.
+ */
+struct pci_liveupdate {
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
2.54.0.746.g67dd491aae-goog


