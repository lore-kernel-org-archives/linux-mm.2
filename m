Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2FEFDEE54
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F50A6B0093; Thu, 23 Apr 2026 17:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009746B0095; Thu, 23 Apr 2026 17:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB33E6B0096; Thu, 23 Apr 2026 17:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B82AA6B0093
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 793501401AB
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:28 +0000 (UTC)
X-FDA: 84691096896.12.24C6006
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id B4487A000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iakZ0hmP;
	spf=pass (imf15.hostedemail.com: domain of 3zY3qaQgKCOgNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3zY3qaQgKCOgNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZmpZCS6mKPYD/A8Ingq/lQA2gApCpbjA3a6IaVe9Pqc=;
	b=mgq9BIa6473n/D40/N3znZBZhzZuK+8YDIwQEMkuIGa/Gvi4RxX0QyO9GHISGVRHGhjg7u
	e0SUeoI+oSBYm3m/onelxqWyQSvkx+Cb3TelndR1nRVO5FwLTR70jO+D1bFkefp1/tlbBG
	6zDRhzbdlJ5j7v6i5nu1vfxEJrozACw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979406; a=rsa-sha256;
	cv=none;
	b=cQIOD/z3skrli+TDMflHe+IwLP/BZS8kjn8Gw/jLj9elxik95+AzXZaNzQ08V0Wqqnr9/2
	bjEDJhXRvKc7sdQxiYePUDn8mxqW/94nZKbwPjvYIXiB9KH28FqCR6cSiF7mGndaG0qASp
	FWNuYz0x19VKngOt77+ii0PHG0fyolQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iakZ0hmP;
	spf=pass (imf15.hostedemail.com: domain of 3zY3qaQgKCOgNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3zY3qaQgKCOgNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c7993b17335so2082720a12.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979405; x=1777584205; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZmpZCS6mKPYD/A8Ingq/lQA2gApCpbjA3a6IaVe9Pqc=;
        b=iakZ0hmPjXFBAIri9hBbn7BnBYo7hbKOeWqb7RmHbiM7kap2Lez3ylKw6Rec63pZih
         tYBZSwT1KpOjHFqGFXoUfcR/YugGQRpb+4KmeBYEDMbP3JX1D6bXxBY/A7Hgzv/cHd6Q
         5N6yUCPWRZ2ccUr/25yqWpwr1gfLk1BM7uCFxe/WxNAJKFgNT1uHTsHsT8qO5SKaFvJe
         u5MAF6CIirOzIVg1YXKLctJvf16JWnxqC63iPZld9BJywpQ+gz87QbXh+/ILSbjs+4zV
         rMqgmnjoNsc5ObxVMO3WgOAcIK9x673cI+pvj2kYtBapwwByZDFWrSWrpFpaGx/keqSf
         Hl3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979405; x=1777584205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZmpZCS6mKPYD/A8Ingq/lQA2gApCpbjA3a6IaVe9Pqc=;
        b=ZnTdTwAlN9AhRLoO9JxLhw5cziL1AFkvzIacJ2DGMzLqvzDiiGsu3VsJH6Z9c3/5QV
         c9FaxvyqnSio7w2uaMxwIrIq8bZ1FE1+WvWSeVanvVMQDa5NVojSqBDP3eX6e13bz+VO
         R6+lFWxF7b3OVPRPn/NgKcOduoIWBcslKzIMQbsW+14nn5ptCCf/6dHK7uqXMnzd6FZd
         sYgyt+lWzV9s64+Kopih6NZQ0aJZF1E1KEgWKviiLfIJ0S1dsmJolO7leQk1PUmtlA2R
         iDEOb2DlhJsu6f88Jzq9eRVWaUneg1wyXpsuQWhLdBXAAqCBtijmhVSCeRBUaQKvVjnu
         P3vw==
X-Forwarded-Encrypted: i=1; AFNElJ+3xPkcMUWkIoBl8ubGYJcpKcWHCuxfRk84Nsch4QJswh7Vizwb6tPzBeJVujBGM7rgybhNKWzavg==@kvack.org
X-Gm-Message-State: AOJu0Yy5ypJwadZPiScOcIGobyWpBlCegjB9IGke1eRS8plx+gZ5V7rA
	ZTtZeG7q3v4sIvwJ2gCnWhrfYRfGun2NbpJRLDmwuquK46+nGYLj3sv/xEroZdewrZQ5J+HiO8d
	gHmLnP7VgCfruXg==
X-Received: from pfav10.prod.google.com ([2002:a05:6a00:ab0a:b0:82f:805:b62a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1993:b0:82c:2241:ab71 with SMTP id d2e1a72fcca58-82f8c9718c5mr31412431b3a.42.1776979405031;
 Thu, 23 Apr 2026 14:23:25 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:23:07 +0000
In-Reply-To: <20260423212316.3431746-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212316.3431746-4-dmatlack@google.com>
Subject: [PATCH v4 03/11] PCI: liveupdate: Track incoming preserved PCI devices
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
X-Stat-Signature: dsngwhekkcse478jszwinm66zoaeh1pg
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B4487A000C
X-Rspam-User: 
X-HE-Tag: 1776979406-677705
X-HE-Meta: U2FsdGVkX1/PciQSKHrPE5ZqDD3MXUeeko8bWb9766KIeqyezQlXHAhHaK36NpChEV0POc1B4M+nVxSBo4qXjpMqDkJLXuCPFshwYCPpuV/ma4nr7WbNb/39Frq4HXRxXUDjYDYO2s7XboH5uo4GXYiTLA6AOOxyeb+yXeqOde836tKcD7Y4ZbyMeJ1m0CM8mSmLp1eXApZ1JbS5T/9DxWGPU7bAYs+HZ08u/4nqQtBU9jneVBd+wBkYzBm0vZCaLjX7rUD7DS5FLNNUcUraO8fpX6ZiLOSohbA301FPu5PEO/rDqgjBiTQmTxejTcU1+XVqcy/Q3VJ2Y/QAaT0qvGIgvGperoX04AsIp0uFdAbYJHxWe0FIt8ZczBw2K4IvO3S0sGrb90pvyu1vqBdx/XvmZFQPKL+oQWDvgeqZZi2YAEdse6IN5jAMRj53CW5mo6ZFfXNMOC7yu4bJ1Wq3iZIineZE/s2+10gBHDEKawTVjp0lhFKhm74oo3gEaM8duSFI4664NIc+k6qBkaNz5RtRsLvOPqpPTzKfNBW/JI1YJ9qiSMhOpKkCdJyAfQ4hQWviv7Z5sfJZJ8EH4J//xzfyghf7X8+yQHQuOMdhm4CH3ln70D+jE5VS7GV+aiwQx4yzZ6Gvmo+yi9e72vOyZK2o5MTJAuwrIlNbmoZ2iqLzf8ajzJd8S2YL2sOT0Iyeh40A6piMA/BU3/jLwsDsG7QJksbGE4DH6ux+I3sv/FH33YbA5HzO9KE+DT5A0eU3O13PYMONwOlhmhiffm0MIxc9x5gUIQTuma6f/T5LZJpgm4ySkG3EvX2CbmAhBYz3tiIMpl/m+tp30FRLMt/nx9IJnj6tmmtbi9/2vbIYAqYNAZzt6aonTWYud70c9DHHjMoZhP5Bxrbv/J8tsGpFuLYdkDeclE5vw7IrO6/ysl52QA+ku47QM/K7bybTzOgLgUcSasQ8cdgHpxh6xP/
 dMIvnTFu
 3A0Np9xrzV8PXyErRvqLyEoyQqwkx3ddqmFkyRYPGgf4KqRNrPcksI4kfm4qTm9NaV9ucAphoAYfGxjocT4yZdF81chEDwdP3rYUpTVC9/t8JrPAU5kM2aM2KBq2hjR8yUeEYt6um7lnV2W+0DIkJhioqoM4uZFfhQOaAGpXN9YsAtu30lbzFzR02PfEdexwvEpgYSSxySa97eE+jy3t7rbKoeKLe1ffbToyTrZS6wl29tekQIbE+W3reRMOe1t6b7ow+prM1rTSEeWrrkgDfrMeLaDIGZChBH7wTF5tPM3uA7CVRDv6sv+43HSYtutuxOtPmWMxYeMKtfWyCwSwMZfVzWale6JqVvuSza+tGIAtBJVnWTpjQs+fVvRizX0VXmcAn/zlklCg6pP1ZnhlrrGfR3gLQMvbI9qPvn0F/ShggxUDOrzKyZEWlkr9koYaaPt7HGAtaqZImMhy0oBurNawknKI/+1qN92exMyblUMoLjMeBhrKgqXeGKefmMdyL3biFaRbGxE4bvze5ry7YWsHkU0ubxBbp1Z32qBHUMEoiA9RV+G1puWsKImOhP/jcrBCg24+Na+FQoZswsLw6nrVLmH+fQn335SPYgfpcNbTkp1aZvoSuI1UfJ7yZaDKoZEQVBbrvWhJ9i08=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During PCI enumeration, the previous kernel might have passed state about
devices that were preserved across kexec. The PCI core needs to fetch
this state to identify which devices are "incoming" and require special
handling.

Add pci_liveupdate_setup_device() which is called during device setup
to fetch the serialized state (struct pci_ser) from the Live Update
Orchestrator. The first time this happens, pci_flb_retrieve() will run
and convert the array of pci_dev_ser structs into an xarray so that it
can be looked up efficiently.

If a device is found in the xarray, the PCI core stores a pointer to its
state in dev->liveupdate_incoming and holds a reference to the incoming
FLB until pci_liveupdate_finish() is called by the driver.

This ensures proper lifecycle management for incoming preserved devices
and allows the PCI core and drivers to apply specific Live Update
logic to them in subsequent commits.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 189 ++++++++++++++++++++++++++++++++++++++-
 drivers/pci/pci.h        |  13 +++
 drivers/pci/probe.c      |   4 +
 include/linux/pci.h      |  16 ++++
 4 files changed, 218 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 2dd8daa2f17c..e616cecc37c8 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -56,6 +56,20 @@
  * This allows the PCI core to keep it's FLB data (struct pci_ser) up to date
  * with the list of **outgoing** preserved devices for the next kernel.
  *
+ * After kexec, whenever a device is enumerated, the PCI core will check if it
+ * is an **incoming** preserved device (i.e. preserved by the previous kernel)
+ * by checking the incoming FLB data (struct pci_ser).
+ *
+ * Drivers must notify the PCI core when an **incoming** device is done
+ * participating in the incoming Live Update with the following API:
+ *
+ *  * ``pci_liveupdate_finish(pci_dev)``
+ *
+ * The PCI core does not enforce any ordering of ``pci_liveupdate_finish()`` and
+ * ``pci_liveupdate_preserve()``. i.e. A PCI device can be **outgoing**
+ * (preserved for next kernel) and **incoming** (preserved by previous kernel)
+ * at the same time.
+ *
  * Restrictions
  * ============
  *
@@ -67,7 +81,6 @@
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
 
-#include <linux/bsearch.h>
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/pci.h>
@@ -75,10 +88,24 @@
 #include <linux/mutex.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
-#include <linux/sort.h>
+
+#include "pci.h"
 
 static DEFINE_MUTEX(pci_flb_outgoing_lock);
 
+struct pci_flb_incoming {
+	/* The pci_ser struct passed by the previous kernel. */
+	struct pci_ser *ser;
+
+	/* xarray used to quickly find a device in ser->devices[] */
+	struct xarray xa;
+};
+
+static unsigned long pci_ser_xa_key(unsigned long domain, unsigned long bdf)
+{
+	return domain << 16 | bdf;
+}
+
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_dev *dev = NULL;
@@ -124,13 +151,44 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
 
 static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 {
-	args->obj = phys_to_virt(args->data);
+	struct pci_flb_incoming *incoming;
+	int i, ret;
+
+	incoming = kmalloc(sizeof(*incoming), GFP_KERNEL);
+	if (!incoming)
+		return -ENOMEM;
+
+	incoming->ser = phys_to_virt(args->data);
+
+	xa_init(&incoming->xa);
+
+	for (i = 0; i < incoming->ser->max_nr_devices; i++) {
+		struct pci_dev_ser *dev_ser = &incoming->ser->devices[i];
+		unsigned long key;
+
+		if (!dev_ser->refcount)
+			continue;
+
+		key = pci_ser_xa_key(dev_ser->domain, dev_ser->bdf);
+		ret = xa_err(xa_store(&incoming->xa, key, dev_ser, GFP_KERNEL));
+		if (ret) {
+			xa_destroy(&incoming->xa);
+			kfree(incoming);
+			return ret;
+		}
+	}
+
+	args->obj = incoming;
 	return 0;
 }
 
 static void pci_flb_finish(struct liveupdate_flb_op_args *args)
 {
-	kho_restore_free(args->obj);
+	struct pci_flb_incoming *incoming = args->obj;
+
+	xa_destroy(&incoming->xa);
+	kho_restore_free(incoming->ser);
+	kfree(incoming);
 }
 
 static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
@@ -225,6 +283,129 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
 
+static struct xarray *pci_liveupdate_flb_get_incoming(void)
+{
+	struct pci_flb_incoming *incoming;
+	int ret;
+
+	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&incoming);
+
+	/* Live Update is not enabled. */
+	if (ret == -EOPNOTSUPP)
+		return NULL;
+
+	/* Live Update is enabled, but there is no incoming FLB data. */
+	if (ret == -ENODATA)
+		return NULL;
+
+	/*
+	 * Live Update is enabled and there is incoming FLB data, but none of it
+	 * matches pci_liveupdate_flb.compatible.
+	 *
+	 * This could mean that no PCI FLB data was passed by the previous
+	 * kernel, but it could also mean the previous kernel used a different
+	 * compatibility string (i.e. a different ABI).
+	 */
+	if (ret == -ENOENT) {
+		pr_info_once("No incoming FLB matched %s\n", pci_liveupdate_flb.compatible);
+		return NULL;
+	}
+
+	/*
+	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
+	 * but it cannot be retrieved.
+	 */
+	if (ret) {
+		WARN_ONCE(ret, "Failed to retrieve incoming FLB data\n");
+		return NULL;
+	}
+
+	return &incoming->xa;
+}
+
+static void pci_liveupdate_flb_put_incoming(void)
+{
+	liveupdate_flb_put_incoming(&pci_liveupdate_flb);
+}
+
+void pci_liveupdate_setup_device(struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser;
+	struct xarray *xa;
+	unsigned long key;
+
+	xa = pci_liveupdate_flb_get_incoming();
+	if (!xa)
+		return;
+
+	key = pci_ser_xa_key(pci_domain_nr(dev->bus), pci_dev_id(dev));
+	dev_ser = xa_load(xa, key);
+
+	/* This device was not preserved across Live Update */
+	if (!dev_ser) {
+		pci_liveupdate_flb_put_incoming();
+		return;
+	}
+
+	/*
+	 * This device was preserved, but has already been probed and gone
+	 * through pci_liveupdate_finish(). This can happen if PCI core probes
+	 * the same device multiple times, e.g. due to hotplug.
+	 */
+	if (!dev_ser->refcount) {
+		pci_liveupdate_flb_put_incoming();
+		return;
+	}
+
+	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
+
+	/*
+	 * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
+	 * that dev_ser does not get freed while it is in use.
+	 */
+	dev->liveupdate_incoming = dev_ser;
+}
+
+void pci_liveupdate_cleanup_device(struct pci_dev *dev)
+{
+	/*
+	 * Drop the FLB reference acquired in pci_liveupdate_setup_device() if
+	 * the device is being cleaned up before pci_liveupdate_finish(), e.g.
+	 * due to allocation failure during setup.
+	 *
+	 * Do not drop dev->liveupdate_incoming->refcount since this device has
+	 * not gone through pci_liveupdate_finish() and thus is still an
+	 * incoming preserved device.
+	 *
+	 * Note: This cannot race with pci_liveupdate_finish() since it is only
+	 * called in cleanup paths when there are no users of the pci_dev.
+	 */
+	if (dev->liveupdate_incoming)
+		pci_liveupdate_flb_put_incoming();
+}
+
+void pci_liveupdate_finish(struct pci_dev *dev)
+{
+	if (!dev->liveupdate_incoming) {
+		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
+		return;
+	}
+
+	pci_info(dev, "Device is finished participating in Live Update\n");
+
+	/*
+	 * Drop the refcount so this device does not get treated as an incoming
+	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
+	 * again becase the device is hot-plugged.
+	 */
+	dev->liveupdate_incoming->refcount = 0;
+	dev->liveupdate_incoming = NULL;
+
+	/* Drop this device's reference on the incoming FLB. */
+	pci_liveupdate_flb_put_incoming();
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
+
 int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
 	pr_debug("Registering file handler \"%s\"\n", fh->compatible);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4a14f88e543a..09bab39738d7 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1439,4 +1439,17 @@ static inline int pci_msix_write_tph_tag(struct pci_dev *pdev, unsigned int inde
 	(PCI_CONF1_ADDRESS(bus, dev, func, reg) | \
 	 PCI_CONF1_EXT_REG(reg))
 
+#ifdef CONFIG_PCI_LIVEUPDATE
+void pci_liveupdate_setup_device(struct pci_dev *dev);
+void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+#else
+static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
+{
+}
+
+static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
+{
+}
+#endif
+
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b63cd0c310bc..938a28e4a7a0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2069,6 +2069,8 @@ int pci_setup_device(struct pci_dev *dev)
 	if (pci_early_dump)
 		early_dump_pci_device(dev);
 
+	pci_liveupdate_setup_device(dev);
+
 	/* Need to have dev->class ready */
 	dev->cfg_size = pci_cfg_space_size(dev);
 
@@ -2192,6 +2194,7 @@ int pci_setup_device(struct pci_dev *dev)
 	default:				    /* unknown header */
 		pci_err(dev, "unknown header type %02x, ignoring device\n",
 			dev->hdr_type);
+		pci_liveupdate_cleanup_device(dev);
 		pci_release_of_node(dev);
 		return -EIO;
 
@@ -2490,6 +2493,7 @@ static void pci_release_dev(struct device *dev)
 
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
+	pci_liveupdate_cleanup_device(pci_dev);
 	pci_release_of_node(pci_dev);
 	pcibios_release_device(pci_dev);
 	pci_bus_put(pci_dev->bus);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index eb94cbd8ab9d..dd6b26ca9462 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -597,6 +597,7 @@ struct pci_dev {
 #endif
 #ifdef CONFIG_PCI_LIVEUPDATE
 	struct pci_dev_ser *liveupdate_outgoing; /* State preserved for next kernel */
+	struct pci_dev_ser *liveupdate_incoming; /* State preserved by previous kernel */
 #endif
 };
 
@@ -2887,11 +2888,17 @@ void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
 
 int pci_liveupdate_preserve(struct pci_dev *dev);
 void pci_liveupdate_unpreserve(struct pci_dev *dev);
+void pci_liveupdate_finish(struct pci_dev *dev);
 
 static inline struct pci_dev_ser *pci_liveupdate_outgoing(struct pci_dev *dev)
 {
 	return dev->liveupdate_outgoing;
 }
+
+static inline struct pci_dev_ser *pci_liveupdate_incoming(struct pci_dev *dev)
+{
+	return dev->liveupdate_incoming;
+}
 #else
 static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
@@ -2911,10 +2918,19 @@ static inline void pci_liveupdate_unpreserve(struct pci_dev *dev)
 {
 }
 
+static inline void pci_liveupdate_finish(struct pci_dev *dev)
+{
+}
+
 static inline struct pci_dev_ser *pci_liveupdate_outgoing(struct pci_dev *dev)
 {
 	return NULL;
 }
+
+static inline struct pci_dev_ser *pci_liveupdate_incoming(struct pci_dev *dev)
+{
+	return NULL;
+}
 #endif
 
 #endif /* LINUX_PCI_H */
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


