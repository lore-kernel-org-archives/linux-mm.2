Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB4FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03D36B00B5; Fri, 10 Jul 2026 17:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB43B6B00B6; Fri, 10 Jul 2026 17:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7BAB6B00B7; Fri, 10 Jul 2026 17:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83CA96B00B5
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0F958FBD7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:27 +0000 (UTC)
X-FDA: 84974150814.08.FA196CB
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C0711C000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="LV2q/e+m";
	spf=pass (imf18.hostedemail.com: domain of 3gGNRaggKCOUKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3gGNRaggKCOUKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqWNkuvdAaukVWBKpdd7ishFwM9qcIXIJrQ5YQadICw=;
	b=IHOX1svFm5VWTdxwsXuHtin2KaoVKust/zxKA9NXrDJFfcubQ36ZDUkwUmmuPkCS3eJ3hT
	Bhx6IcGEqJO4kYkkdZc64SZYyoOxrtMjrMajVnI2/O0OWCp7OaPG5cMXGTvS8SRWGOMw1R
	tUdrFF5TPo8gmhA+5vSCtT8a6AjKhQM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="LV2q/e+m";
	spf=pass (imf18.hostedemail.com: domain of 3gGNRaggKCOUKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3gGNRaggKCOUKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718786;
	b=nGwCq9Z1nbfnC6rK4cBXEpybRy7XG/xFDxIXbSUbhE6cPdUmNnT77z7tA4VJYzOsefdG+s
	zkdDqRqMcSRbQW4veJZW/T6kTCOlD4bzTYfZYTx45uDkF3XBXajTEJw7GmhS4qEwhlcuMh
	0Ic+sEYlMloIqoGm7P5863Ho4ZHJzfA=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c894c1c4aa9so1753162a12.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718785; x=1784323585; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZqWNkuvdAaukVWBKpdd7ishFwM9qcIXIJrQ5YQadICw=;
        b=LV2q/e+msgmC5BKYGfA62nBu4GBg+ATbkOvol43oCRNWl/BqLKYUEJ7h7m1dyzDQkf
         ixo4aIifIyNE3oCYj8MjeuVJX1b7HvO2mjS8sPqX+kSX+Xejh+y19mBTcl+slnKMr/cx
         6mO9SLIO/OVGJvlfj5ohQgywNWYdkzOhG7X3tit/WdXqd4GP21CwWYxR0RsGWuIYNdy0
         bejFwUmco2y4BvfxoBxs3gLyOssjm/L424kf3YbpEE6Gp6p3w9z4U7CzHCh+3UDA4tvf
         fbmBRHai6iQXIjwHnP+I3SKGSuCBnB6TZRmgZYRTt2v4zL+aY0g58ebu4TR2K5jwQImg
         7cDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718785; x=1784323585;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZqWNkuvdAaukVWBKpdd7ishFwM9qcIXIJrQ5YQadICw=;
        b=VfKaXNIZ8zYhI4gMUzKNeRLWuY32jVjkZkTnQLZ/FPrNuKme2avDQxFUf6aH9mzKFE
         9uGHQHN+dNcVmLMeUCyyqNRct63W0/tHhAnTC5Ht4GDdbxvFE4b4QTuyJC+6PwOMcG/L
         E7vkgBak9UVUZ9E/au7RVXn7ih52zH59zly5IxpaykJnwGQdMO/eRFY1MIQ6c5QEGLm4
         5/6oG6F1IbsFCz3vxFcL4uyK4o5jPfx0QFiIJiZyOJim54mMNTWpVO/Gezm8oDdvMcy+
         FnoWhrZ9ZEemznHwavCcp71WVsfhRvYWadJ1VpjMIynwAbn6irzVYfz2krefeu+3D8/E
         yQEg==
X-Forwarded-Encrypted: i=1; AHgh+RqQYitjtahdBYkVYdLPKsSu1E7moV10i9Ng8vvaWaA2IAixErIrhhtOirkj90OBIT5hMs3ZbKcIgA==@kvack.org
X-Gm-Message-State: AOJu0Yw5iloo4d8yiRrEBKJZrJuvPYARgYu2LQI0dP2YmqCorkJ5LIaT
	8C6rSZjykT1G7UujqWa+1vcGsLmeCnivCNrcEBNyOTk3qBJiUbqD5Rm7/+wN4l+AEHzpDr9v7Qb
	+RSDvS5FdZU7bkQ==
X-Received: from pgeq9.prod.google.com ([2002:a63:bc09:0:b0:ca1:3a05:d935])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:800f:b0:845:4e6a:768e with SMTP id d2e1a72fcca58-8488974b0b9mr573992b3a.35.1783718784876;
 Fri, 10 Jul 2026 14:26:24 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:05 +0000
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-3-dmatlack@google.com>
Subject: [PATCH v7 02/12] PCI: liveupdate: Track outgoing preserved PCI devices
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
X-Stat-Signature: bjxycxocryr47io96k5dyued8en9mnid
X-Rspamd-Queue-Id: 2C0711C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783718786-207061
X-HE-Meta: U2FsdGVkX1+agLPpaKBzttcv0BNGYeo5Rdh5DUvzv+F2+XnyAEbihHa1cjQ8FfCbOOIZKNP9PM5BS4bfdFFZQYopZoql/Svxq2gZ7lCnPm2Ep0cME/l34459UMEAFLph++LaulXlsRxsvwC8ErnzbEgeKuJen0G7avBbaBWdxNwMhEtgC683YHNWSyvcuI7CCM4Y7q9AXv0OcK93tly6PMFv/No3zHSFsnsSbAGenkcKYFgoTfCb/1kOi1Rt4o95ywg5O0ONYu6iXs1rhIsu/5BTjQvSFVB7ichTFM20NN/ox6OEg5ENW+5LqUvfQHp2J/dEMoBVwaa+v8EJONCmmhqaP0wv7gU04C9AoJIcuUKzxE2AcyZQSTvwjK2c/JgagZmBzEqEJr2DDarY+Isa7hwexiY6Uzdifbr8dQQltlROTiUzz4zJv+dWekaGmP0Nw7iN7epwXAbh3uUdiXBOIp6WYtTWD+7lKvTQGFB8aM70nLc8SDeG7d/ogOQWrcX0qckYlyzx/YOifFeCLzf4mr1hZ2yLERO/hEix85yQSUtJh9sagiyTp4IhwgiEFKsgU09eExA6RjYmJ6Dq6hG5GXvu+hwN42xzXI57PnnNs3hDwWe5jkiuosQSqDlw17wbukhxy3qbFka7tAGWmcIZWv7DUyo8DvHZJUfbmtspiOyQGAFxbp73CZMxvnQ26wc0ZbcQ5GrEtOnK293u6iJLWqR7BOsz4XC9Oxrbi3bV8UDicmyBU8C2id+vPbJS/Nb0q3m3MyDH19oCSmSU3/mlkzLS6ePOcTBqfkfkBRnYP7tUVQljaB6B7TZUpXJlqroBKT9QjqnEPorfjFnSYfLai1kgiEWJS3vJGNxej1qTtAc2cMEqhlKt+xSuSGmP5emKTus/yfOc/aKsejKiyVqO5zXWPWuTmmVcRAnTH9pPH8WLj1AIbs/NCL50XPInOf1236g+9iST7oDl5tW2WOU
 4CS+Nb7/
 vQWGKmrH9C93mN8/dcnHPJxH39iDKokbJ4vgI7EK515gYRuKXm4KrSz6wASHZAk+qakaJ8BhbrNNyuPYGw0MORa8IJJI0cGf2Ek07ZRAjYgM4PqAtbDTs36beiRUtdZrGn01hgUAZlNWfI6j4subpbEhWbAtQDyqTkP1xb5OrwB2BuelrlTemZj5hqq88gwBiA5Pdh9oNueUdWgPdHec32O1ENal5eW19UQRp2Fe+p62lrxkflO8oH87Unzq3PHcX44M6Y7np//O+lmMXJwcm+zYxCNZ4aziMBIOmu7yLPVQgmYUZB/QYdCMznojzT7Zs3apkaMPI3kvDqvRMh26AyBPzibUr8mEPEGXuzWHhrAK/fqOaSyPbaDQd3lCogzyClan6HqHuSO5LLXsxIAVKbKNq0Z9R+f54UD9/EcivWJYvlTfaqtojEOFyV8pds8VBFdcg1pElZ9Vso5JDRXGb8AhczCUrWgcwfeXpOfPGeXLc/eEklWXPnmuMWfYhiVQzQNL6nYDA9W0l30sGgZ92C+ZBYbCZdGfzYGLyj3U+qpdpVfjEek18zgAmMVn1oSjVT3wqYi/M3dKQXdncsSbWAnP4NmC73A8OkevxfburwqEOR6EJucBxwuJ4aQ==
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

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c       | 186 +++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h       |  21 ++++
 drivers/pci/probe.c            |   2 +
 include/linux/pci.h            |   3 +
 include/linux/pci_liveupdate.h |  21 ++++
 5 files changed, 233 insertions(+)
 create mode 100644 drivers/pci/liveupdate.h

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 899758883dd5..03075ce06ac9 100644
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
 
 #define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
@@ -50,6 +70,21 @@
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
@@ -125,6 +160,157 @@ static struct liveupdate_flb pci_liveupdate_flb = {
 	.compatible = PCI_LUO_FLB_COMPATIBLE,
 };
 
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
+static struct pci_dev_ser *pci_get_empty_or_append(struct pci_flb_outgoing *outgoing)
+{
+	struct pci_dev_ser *dev_ser, *found = NULL;
+	struct kho_block_set_it it;
+	int err;
+	u32 count = 0;
+
+	kho_block_set_it_init(&it, &outgoing->block_set);
+	while ((dev_ser = kho_block_set_it_read_entry(&it))) {
+		count++;
+		if (dev_ser->refcount == 0 && !found)
+			found = dev_ser;
+	}
+
+	if (found)
+		return found;
+
+	err = kho_block_set_grow(&outgoing->block_set, count + 1);
+	if (err)
+		return ERR_PTR(err);
+
+	if (count == 0)
+		kho_block_set_it_init(&it, &outgoing->block_set);
+
+	dev_ser = kho_block_set_it_reserve_entry(&it);
+	if (!dev_ser)
+		return ERR_PTR(-ENOSPC);
+
+	return dev_ser;
+}
+
+static void pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
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
+static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser;
+
+	if (dev->liveupdate.outgoing)
+		return -EBUSY;
+
+	dev_ser = pci_get_empty_or_append(outgoing);
+	if (IS_ERR(dev_ser))
+		return PTR_ERR(dev_ser);
+
+	pci_info(dev, "Device will be preserved across next Live Update\n");
+	outgoing->ser->nr_devices++;
+	outgoing->ser->devices = kho_block_set_head_pa(&outgoing->block_set);
+
+	dev_ser->domain = pci_domain_nr(dev->bus);
+	dev_ser->bdf = pci_dev_id(dev);
+	dev_ser->refcount = 1;
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
+
+	if (dev->is_virtfn)
+		return -EINVAL;
+
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+
+	outgoing = pci_liveupdate_flb_get_outgoing();
+	if (IS_ERR(outgoing))
+		return PTR_ERR(outgoing);
+
+	return pci_liveupdate_preserve_device(outgoing, dev);
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
index dd0abbc63e18..14b66acbdb15 100644
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
index da58aa101e4c..b41dd572a2d6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -593,6 +593,9 @@ struct pci_dev {
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
2.55.0.795.g602f6c329a-goog


