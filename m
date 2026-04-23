Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41AECFDEE51
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346696B0092; Thu, 23 Apr 2026 17:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F226B0093; Thu, 23 Apr 2026 17:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07DF36B0095; Thu, 23 Apr 2026 17:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB0436B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97B4A1A0584
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:26 +0000 (UTC)
X-FDA: 84691096812.18.23C6B82
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6F19A000F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hFhyDfZs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3y43qaQgKCOYLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3y43qaQgKCOYLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LW56WQ/GxI9kfbfGRUP82x0Orz5k50krThArcWSM6yc=;
	b=gnMgt3QkyaLHIh6bK8+0k5CgGmSv3RT9flzyrHBWrjmErYfFXRYKWGUDuf9iIsaPcDl5F9
	tLbSdCJEnE36pZGXsG7w8TkzRG2LbkvsDFLKAB10tN5zzo/42wIBrb0ghi+66ANxAENQTm
	J/yOMDDJPuE964SE3ND76RfAwWE7gj4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hFhyDfZs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3y43qaQgKCOYLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3y43qaQgKCOYLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979404; a=rsa-sha256;
	cv=none;
	b=5NPh51APvLl7jH5f6Yn5xaPPkHMp0QR3vDERvzPHrEoEgEOih9Rv284TIohzxWC+X8F+LX
	/h/thw96fhtiL2hLUGodBRNlzIusUqRjmKb8MXBMFnwh1JYXrc1SnazBW+Qx29a27J1sxW
	lY+RmHs2GdJyuBOUISelEU5TgtdKoDY=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b79f4b35b7so12205575ad.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979403; x=1777584203; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LW56WQ/GxI9kfbfGRUP82x0Orz5k50krThArcWSM6yc=;
        b=hFhyDfZsQDpEL2GdzgjSFb6k6hI4kdDdkF6uhzOO6Jj+FM+/omaUuwGs/r/Y6Bt63/
         uaxyQBd3myWJWvJYUbhZdt4x1I9Koo8lIFQ1BCgxrvkll6tGmIlchx2uMFsKfrFI5LH0
         r3BCeooNyWIaq9QOS62xmxXxZQu5IucSzaqgiWWua2Rn/GbD7qvnyCsrF6wjChbVHBU/
         hklZ9h3w6wGxdDGrlrvCwe7K96tMT+dl6VhHF0sU8c8vmYiLumOimgx326wf9zZqpNHn
         Kjpn1mmpXZhATKfaw1ampNs+J6a+fV6Zd9vhj9ByyghXRO66dRJ2VrvmlWQpQLmuWLIJ
         Hd+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979403; x=1777584203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LW56WQ/GxI9kfbfGRUP82x0Orz5k50krThArcWSM6yc=;
        b=J0DwCkfbtWh4n8yPCnthP9pwt2L/0yejnr5/rAnSWx1/f1/q1D+PA+KMITAvuWw56H
         ZfV61lxQoR8nrVMvrUSV3WpEv0zCnB68+VuqncDQ3+ivp7RJ4ME7attQJ8G7O9/T4Vj5
         N6afJMx0yyDUMUy/b6/GPhuQgcghT218XFCyxmkK2lGg0PWF/lahMCYPMALA89mmriqE
         TVxklN9NRlvP6taBOhSaG4zO73MAnsC2mSbrrpiLuX5NKr2bdUnCP/3l5yrQ3C3ETQsg
         nenD3Q7vvW7rSkkM8ryiB+KcloIc97FxM7yTyybnllmfFOxgA28HxJkpFLecE3lJrCT4
         ocGQ==
X-Forwarded-Encrypted: i=1; AFNElJ8XXMe5B4h+7Wpbkb/SvCoPSHYwDyJESxyKVmPGf6vtT//wzrIz0bMqMCSAGyTR5HO/7FLiV8c4CQ==@kvack.org
X-Gm-Message-State: AOJu0YyKr3KLs7YvQ9lw27J3Qu1E7elNLeKO85v5cWj4Q3ZX0yjEUGyZ
	Ud79o4GfbEHLKOBtlijhm/8ezFXdESbVObxJLaX1FpcirdbgfMtfCiNKbMNtYsx/CSgrvd8WOD4
	jdI98BIvTk3ZOtw==
X-Received: from plai2.prod.google.com ([2002:a17:902:c942:b0:2b3:2649:c9c1])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:930b:b0:2b2:67ca:5fff with SMTP id d9443c01a7336-2b5f9fd24b7mr208541215ad.28.1776979403289;
 Thu, 23 Apr 2026 14:23:23 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:23:06 +0000
In-Reply-To: <20260423212316.3431746-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212316.3431746-3-dmatlack@google.com>
Subject: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI devices
From: David Matlack <dmatlack@google.com>
To: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C6F19A000F
X-Stat-Signature: pextked1t1bfgd7wzzs6wec17tocn6go
X-Rspam-User: 
X-HE-Tag: 1776979404-931144
X-HE-Meta: U2FsdGVkX18fkS1wqEWafC52gbIKDd7oqkSDOBao1LJGwqIbpAFWoIhJT6rd6jhO7OEzEOdZzttRBgKJq4qFfaSYLmKouSRpf0fmoaPMH9lnR6DqcbusrOPyciNtOuepjT7pj/HPBWH1l/3gu7nmcc3+V9SwTWLI/0p8161bCgYEclkk54ScIHxU0s/mSNfe9XzSgVmmaL2+rKfzYfMTfTlo4WFlKaYkrqMGVsjjmeVkruEAjJhkWikZ1onPUy7xM2UNEWodA2XPlrzleAc51D6Gnc19ypL2bg9gh6Mxv5rE6lRyGUiEsvIKzWjFUXoQGItjQ8ai6MdYP9liwgDSMzKi8rFNRf5uHx5EW3d3SS48QhPW+2ENIfGu+zuDRjNj/z4QA8xxPpL0pRp2OqtRellTY6S9FQ8YtzmRwB7wToAsEU39kwziDLG5Qhf4A+ZWd3uHL/W32wiwFBo+FX9Ha5nkeNZMAJLRfK0FP5fySVqZY2T2X+q1ah/czNcUdmh75c1Mz844GOFJZcVQxZJwqoD5yj0BKfiaKlzN/o57ArQ1MSEX+v44BAAq/iIx+U3a7JDlETCA/wHQ9Aq4+kEBi6p5X6pisgWK80LTMMCLxoFxuvYtcJVDBZ9itFMj24Cooh7fM0slpgH5qT7z7bOtjFG/HjfeDlhMCS9+2tU2PcAazhpfOHNeLfFg0WhCvBMBNfEKIYWU4rfZl9YcN8uZExq9w0uMcovVNetGW5GSwWfSAfPmqI8pO/QgoI+nhWhVA7BLeQYdS56ZJ1dO5epOkukiYXhrqyzZYdV70zS0inDpzarVyUIds7Om3XR4Sja/L28gC0q5gtxBqOkw5aTKz2ACOaR+URh94WS8InaFuK6yjrcS8w69qghVoicmuAphfWd0EWU3/aNyrzhvDE0pvpXnMJrVLNLK/2dC3XZ1iVqb+W8hE8pVxESE0GvELIHR8idbKFaDgdAE47qTiUV
 yUXhNUu+
 FyF7v/STDib14r8/mwV1CfnnoEendIhvh70AAhnH6eV7vdGltmrPYqGxE1bidEpTZ4TQrsI21CSxFq5VKDbAJkBWVazolVo8/iGEl5nx1XcCkB40TpQiCIRPBXF+PqkMi0xDveT/ROhm4Dvg8Z7i83Ck0OUeJGZC6H6TXWj+4iDpqvxun2qKc6/1/L9IKCKpWL6h1ng9rDH9r0ak1nbmeL6mSkgm94Rn9OocDvMj95jx77vLpdMalWhJKwf1DdkaCXN2n5SmDSQdAUGfmBEN3FCFcO+aNEqUYj/cqNmKcU6MQrBbjv52hRz6yxuFocvEUHlW/U+D01VZEVydvDqENcOpc1/m3wpO8J3V8eEhUB3MuyJn5mL3hX+oDIzELfkQAWKPF6kwlTOeu328DkNWsVQEuUO4u7PH7zm3V0vmba70WFLP3ZO1gfghQ5nF18ObzcvGM8T6HuLDNhUmgi11zS1lDHjTd6jWGuKbJg/OffnSm/48alAQkWnfrdMfpmQNpTaiM0mgMMBC5k+D9WRoHlg1gE2QTEdkWXIrxAAQLSZAAvBwARRCXEeTaLfkiM7M92pZelnc5QTSQaJD/hpUK3/R6YQvAoM4my+q4G//JYdPZTSJ74oZ7/zInBUWO41C4C1usYMVCCPnOAf1Bg0nv3GR5YPu0dGY5CwZXkMaPY/WauaEZ54dgmrCIM9ExxFNv9wdA9+3puD+Am3U=
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
 drivers/pci/liveupdate.c    | 101 ++++++++++++++++++++++++++++++++++++
 include/linux/kho/abi/pci.h |   7 +--
 include/linux/pci.h         |  26 ++++++++++
 3 files changed, 131 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index d4fa61625d56..2dd8daa2f17c 100644
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
+ * This allows the PCI core to keep it's FLB data (struct pci_ser) up to date
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
@@ -57,6 +77,8 @@
 #include <linux/pci.h>
 #include <linux/sort.h>
 
+static DEFINE_MUTEX(pci_flb_outgoing_lock);
+
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_dev *dev = NULL;
@@ -124,6 +146,85 @@ static struct liveupdate_flb pci_liveupdate_flb = {
 	.compatible = PCI_LUO_FLB_COMPATIBLE,
 };
 
+int pci_liveupdate_preserve(struct pci_dev *dev)
+{
+	struct pci_ser *ser;
+	int i, ret;
+
+	guard(mutex)(&pci_flb_outgoing_lock);
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
+	if (ret)
+		return ret;
+
+	if (!ser)
+		return -ENOENT;
+
+	if (dev->is_virtfn)
+		return -EINVAL;
+
+	if (dev->liveupdate_outgoing)
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
+		dev->liveupdate_outgoing = dev_ser;
+		return 0;
+	}
+
+	return -ENOSPC;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
+
+void pci_liveupdate_unpreserve(struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser;
+	struct pci_ser *ser = NULL;
+	int ret;
+
+	guard(mutex)(&pci_flb_outgoing_lock);
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
+
+	if (ret || !ser) {
+		pci_warn(dev, "Cannot unpreserve device without outgoing Live Update state\n");
+		return;
+
+	}
+
+	dev_ser = dev->liveupdate_outgoing;
+	if (!dev_ser) {
+		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
+		return;
+	}
+
+	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
+	ser->nr_devices--;
+	memset(dev_ser, 0, sizeof(*dev_ser));
+	dev->liveupdate_outgoing = NULL;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
+
 int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
 	pr_debug("Registering file handler \"%s\"\n", fh->compatible);
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index 5c0e92588c00..5b4c8d9e462c 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -23,19 +23,20 @@
  * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
  */
 
-#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
+#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
 
 /**
  * struct pci_dev_ser - Serialized state about a single PCI device.
  *
  * @domain: The device's PCI domain number (segment).
  * @bdf: The device's PCI bus, device, and function number.
- * @reserved: Reserved (to naturally align struct pci_dev_ser).
+ * @refcount: Reference count used by the PCI core to keep track of whether it
+ *            is done using a device's struct pci_dev_ser.
  */
 struct pci_dev_ser {
 	u32 domain;
 	u16 bdf;
-	u16 reserved;
+	u16 refcount;
 } __packed;
 
 /**
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d70080babd52..eb94cbd8ab9d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -41,6 +41,7 @@
 #include <linux/msi_api.h>
 #include <uapi/linux/pci.h>
 #include <linux/liveupdate.h>
+#include <linux/kho/abi/pci.h>
 
 #include <linux/pci_ids.h>
 
@@ -594,6 +595,9 @@ struct pci_dev {
 	u8		tph_mode;	/* TPH mode */
 	u8		tph_req_type;	/* TPH requester type */
 #endif
+#ifdef CONFIG_PCI_LIVEUPDATE
+	struct pci_dev_ser *liveupdate_outgoing; /* State preserved for next kernel */
+#endif
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
@@ -2880,6 +2884,14 @@ void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
 #ifdef CONFIG_PCI_LIVEUPDATE
 int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
 void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
+
+int pci_liveupdate_preserve(struct pci_dev *dev);
+void pci_liveupdate_unpreserve(struct pci_dev *dev);
+
+static inline struct pci_dev_ser *pci_liveupdate_outgoing(struct pci_dev *dev)
+{
+	return dev->liveupdate_outgoing;
+}
 #else
 static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
@@ -2889,6 +2901,20 @@ static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh
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
+
+static inline struct pci_dev_ser *pci_liveupdate_outgoing(struct pci_dev *dev)
+{
+	return NULL;
+}
 #endif
 
 #endif /* LINUX_PCI_H */
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


