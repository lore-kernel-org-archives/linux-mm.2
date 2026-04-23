Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1CC5FDEE4E
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF0C6B009D; Thu, 23 Apr 2026 17:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69D86B009E; Thu, 23 Apr 2026 17:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958FE6B009F; Thu, 23 Apr 2026 17:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 843486B009D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F3CF1204FD
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:37 +0000 (UTC)
X-FDA: 84691097274.25.D5313C9
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6E495A000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WTQsvQYv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 31o3qaQgKCPEWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=31o3qaQgKCPEWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979415; a=rsa-sha256;
	cv=none;
	b=3XHzBXvrDSLCFsf49ehrY0KArmd8eosmwkfUkyTvEcmthGjdPJJL0TJyQHsLWvtqL8R7uj
	jEjqc0h8w2Ol0qOJcEluIwAjljiOzIYNK1tuSOXrk9Ci/xWz8+53+2WHOLNODbJiqtR25B
	vYOLAyszcHgHDePEVfVt3Q8zfSSJELc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WTQsvQYv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 31o3qaQgKCPEWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=31o3qaQgKCPEWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xzr76OgKRSVyLlNPZ4BBmoEisHfu3frnnsSEc+2qgNA=;
	b=0mNp5cN1EY8XnZ7o3ZmEZ116iXz7BS23oanO5XRJT7zELWTWvAxbq4K0KqvX4n3xvtQ+/E
	WFr+1wD6J4yvxN5lsCxv/pNSvYl8R8NLPbgPloPLSFOh/BCSpd3CM9YVlg3skMq2hSE1Mb
	KVbZmV0kQA05nGo+dd/snOvm6GnYL80=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c797efdaa9cso3514354a12.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979414; x=1777584214; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xzr76OgKRSVyLlNPZ4BBmoEisHfu3frnnsSEc+2qgNA=;
        b=WTQsvQYva2iQdCSSpiH3vpL3x4LPlqC4fW8+2aXPaWukL1KrpGJ6/2vmvlkfEgat07
         bdCAfQeW0cuk+lOUoVNPU0MHhSq/9TVKJHTe53snOXoEjkpBqvqPuvOuhttEMSUB0iJg
         WmIaZMCzyRvDrfuTocl+GgExLj3UMx/B1ZychSXuhWy6xTyQ2fG9Om1cPjxA0fxw6G+o
         iytpDEVVhW3FHnbe4sZAAimi/+8a0/Lm/+D/siLkWrWwElVlbF0l4DbSPvR9ibSJRLWw
         imtn2jLkFbaCaeopDZZe31zyrMuyenoVGFKKYseOlqu3FsmSrlf35FO04RkA/lA+uAVW
         BgEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979414; x=1777584214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xzr76OgKRSVyLlNPZ4BBmoEisHfu3frnnsSEc+2qgNA=;
        b=RHEwANwMXcuv5tsV4KizQYXsYXwunYJH9ZIoI+JS1FQHW3OQvbaZVgzXnXC87axfgS
         LDxyOGFZXQBwoS8jOdS90IGF1EynIq0jqFjf0B8AoBrM2fWxTtjVljvb8lmEDuTqYy5L
         CeNz4kDjjR6TDBMu3UzW5PzJvk/LkL2aiGMCKjS+cKBNeeRCEbNnHcYRtFDCy9/qaLbe
         p+kMiWlQmF+zDvylIFc2A0O/hPAPDP1em1svQZzmpb2c8OC3FK2P4XtpE6GwlXp/aB0o
         MtcpJpCI4bt6I8OzFURle6owDhsCm3HjBditpZtCLE3O/dU3jN/ZJaDohTGg/qRlcfGY
         gdTA==
X-Forwarded-Encrypted: i=1; AFNElJ/iZbRfQmoLEOW0Q0fNiGN2E/oXduoFneOuIX8Va94RfT3qhgIz+eB8pqBiQvxdSkzWd85SmP+jDQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/oVs79PIQLyFS0s3OxrA4sB+ZHcG9bIrH3t3aTPfMknjug8+r
	hJO9XQDWj0oslx55tg0gWXYCu97VPV0zAdHPNb8JT1ntUV0ct4PXeoPXRT0GRbLN+jVWq3CmVcl
	PdvsxAcBgKG00xQ==
X-Received: from pgbda7.prod.google.com ([2002:a05:6a02:2387:b0:c79:9058:b77e])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6da2:b0:3a0:b781:4c8b with SMTP id adf61e73a8af0-3a0b78155d5mr25116879637.2.1776979414052;
 Thu, 23 Apr 2026 14:23:34 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:23:12 +0000
In-Reply-To: <20260423212316.3431746-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212316.3431746-9-dmatlack@google.com>
Subject: [PATCH v4 08/11] PCI: liveupdate: Require preserved devices are in
 immutable singleton IOMMU groups
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
X-Rspamd-Queue-Id: 6E495A000A
X-Rspamd-Server: rspam12
X-Stat-Signature: gsojr7ffkoixwi74pwy63ruckiapxmx4
X-Rspam-User: 
X-HE-Tag: 1776979415-845207
X-HE-Meta: U2FsdGVkX18ZoxZxLTHv5oTqvg902nDxfB7bCs7N3c6PWvoFZw2fW//Ei2OyJXwJYL12w+frEaZpLj6I/tS71D+AyFeyiQS2LvVPffjlYT+hFf61neGzaxah4qSTjNkXCLaWisrIDeqfUumV8nZnap7NF1kgLO5jQAkArNciZQug+52ydWJawovgE2oX714vqJVpO+B7BAsY1/f6JtVrzROLWlExiLqNKC5PAmn1lT5BvGOrkBeL2W60x1e1iQHuNflbdfVVikRZiycaa5ggnsccT49SqSqAxNX33HDxn02mZczVccqVGn07hW7aEs3hhzKfN8GOm2qIzyh+zmsHl4oQgKj607yfPsuqWiTTyXtizUojJ8iPA89BNU+dT+GX7hm6va/HDMtCiztozBHKlSVKJWU6gKdPNlqk7PjXO70XSp5+QagUMIZ40VqjOVaGuYm/ama4pXsNiRyKaIgMgCAIyjybzoIpknY7rXfApSRvNIMHNuZVdnn6EFybjhIVYyWqh91J4b+QZR+dXB/WN2E3GtvSTLV0tU3BfEkVwLbE1tdbF17TtIqUwXlNgfkLxQjzRCwevPu1uKx8+jV7pmXHLbDo+c/sKlvN6InzfJZy4NzO85mZRc4+PzOGOyChYauWxwrs1bhhCNyHj8ArTN4m+S8dAzhvJzMovN9X0Qbv+F7aEBpP1ACjIDEzvzf9DeZQwNr9/g7/8LnfdYJLhKehW2n12TjZqzLpMbQ/TiadH3A4tnb7dIhyWuo07xwYw2jkHq+HLClXiKxwiNcyawzl53AKJMovFynN/VukLKmKSODdjSgCbdBQ9+AjcJKhTLAPp9H6su55dnfwyCrcgM2Ps0U6qSmFnDbHS2sYZkjYUEaJX+EizCJGJlAn9DTlwiULxdLqUAI8VYqiV112x1zD81ozivA/yov6jVV2zIEmkQLeQKVebQ5NS2yYfWz4UhnHMgzFcjBwAeaL/Yb
 UMXOdwsu
 ENlQtaC/GJSW3vVrqxtMLUDehdCwsVmBlF/2/m2kZ6GPvQwI03T5juvstJh09/6sKdSOTGBpZoiFjVX6DEJ2XZbPJTYn0fUTX8x16DMJD3uSB0WTpCvb6VIPNxWxnvncxI3X3FS8qT7k3F1EqGBUDvNF+XJ+fsR7E+NV5T04rqK8q1S0fH7ppKWy3gHJMOAP3fLCyYkY802NyvBsoG7K/3mvke9zQS4msSiEQ3uJNUtD/7KQo9gh/p7b02gtJlbzzgK4IXnkcFTIqglKm29s9qwXTM2Iuw8Bvs5gYIXJimFG2kZFvijQCQUMd8XaRVBEL2m/MWi8+lJydPOZr8C40xHsRgBgBdsBBQN5PwbzJNU/pEe9dEdHpHm2bjTxJq8HnAqh7Cxrb8NtAGQQuAG9+jAYNfRiOZs3ArM2a+Db0BhWWY6OFzdMMtgnQBN+tdVkwZ90YXELD5L/p7QhE+ABeth+wP72cdgauDvaz1yB9+AH0bKHB7nCclLwh4SkGHgdR8XHD+FyeOOnyD3K5jGkusYtXEeKY0wMbdO8f+M55+aHhE4NqLoOvblnACIQ4qWCSM7ofccUhiw36ujxxpw/hVrm/ownPi7M5ItdkWcRaKpkgnmEHF2JQSD21QTq0dVGOzkM0vwJ6IrpDOuIuby49dkjhbsm1ltFVkSyUljBZV1bnSj5C/rHnDuxf2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Restrict support for preserving PCI devices across Live Update to
devices in immutable singleton IOMMU groups. A device's group is
considered immutable if all bridges upstream from the device up to the
root port have the required ACS features enabled.

Since ACS flags are inherited across a Live Update for preserved devices
and all the way up to the root port, the preserved device should be in a
singleton IOMMU group after kexec in the new kernel.

This change should still permit all the current use-cases for PCI device
preservation across Live Update, since it is intended to be used in
Cloud enviroments which should have the required ACS features enabled
for virtualization purposes.

If a device is part of a multi-device IOMMU group, preserving it will
now fail with an error. This restriction may be lifted in the future if
support for preserving multi-device groups is desired.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/iommu/iommu.c    | 35 +++++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.c |  6 ++++++
 include/linux/iommu.h    |  7 +++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 61c12ba78206..782e73a9d45f 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1664,6 +1664,41 @@ struct iommu_group *pci_device_group(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(pci_device_group);
 
+bool pci_device_group_immutable_singleton(struct pci_dev *dev)
+{
+	struct iommu_group *group;
+	struct group_device *d;
+	struct pci_bus *bus;
+	int nr_devices = 0;
+
+	group = iommu_group_get(&dev->dev);
+	if (!group)
+		return false;
+
+	mutex_lock(&group->mutex);
+
+	for_each_group_device(group, d)
+		nr_devices++;
+
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+
+	if (nr_devices != 1)
+		return false;
+
+	for (bus = dev->bus; !pci_is_root_bus(bus); bus = bus->parent) {
+		if (!bus->self)
+			continue;
+
+		if (!pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
+			return false;
+
+		break;
+	}
+
+	return true;
+}
+
 /* Get the IOMMU group for device on fsl-mc bus */
 struct iommu_group *fsl_mc_device_group(struct device *dev)
 {
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index a9a89f7bd3e5..54a90ff02bdd 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -133,6 +133,7 @@
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
 
 #include <linux/io.h>
+#include <linux/iommu.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/pci.h>
 #include <linux/liveupdate.h>
@@ -359,6 +360,11 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
 	if (dev->is_virtfn)
 		return -EINVAL;
 
+	if (!pci_device_group_immutable_singleton(dev)) {
+		pci_warn(dev, "Device preservation limited to immutable singleton iommu groups\n");
+		return -EINVAL;
+	}
+
 	if (dev->liveupdate_outgoing)
 		return -EBUSY;
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index e587d4ac4d33..6f5d1dec3f89 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1096,6 +1096,8 @@ extern struct iommu_group *generic_device_group(struct device *dev);
 struct iommu_group *fsl_mc_device_group(struct device *dev);
 extern struct iommu_group *generic_single_device_group(struct device *dev);
 
+bool pci_device_group_immutable_singleton(struct pci_dev *dev);
+
 /**
  * struct iommu_fwspec - per-device IOMMU instance data
  * @iommu_fwnode: firmware handle for this device's IOMMU
@@ -1528,6 +1530,11 @@ static inline int pci_dev_reset_iommu_prepare(struct pci_dev *pdev)
 static inline void pci_dev_reset_iommu_done(struct pci_dev *pdev)
 {
 }
+
+static inline bool pci_device_group_immutable_singleton(struct pci_dev *dev)
+{
+	return false;
+}
 #endif /* CONFIG_IOMMU_API */
 
 #ifdef CONFIG_IRQ_MSI_IOMMU
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


