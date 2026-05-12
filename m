Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F85CD4F39
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A426B0095; Tue, 12 May 2026 14:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40F66B0098; Tue, 12 May 2026 14:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D3C6B0096; Tue, 12 May 2026 14:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80A666B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:48:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFCAA8BFD6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:56 +0000 (UTC)
X-FDA: 84759654672.23.7F02C17
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf26.hostedemail.com (Postfix) with ESMTP id F2A2E14000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PsMDp9wP;
	spf=pass (imf26.hostedemail.com: domain of 3FXYDaggKCGYHQEXPEGOKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3FXYDaggKCGYHQEXPEGOKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRPMEjK5N2pbYThoIfW7Ke0tk0ug6zfSh2dkLV6x6RU=;
	b=feXQ2LOd94YKdBCeqwd5f6dgqdGJxWAhVczNM9eHLq3IXpBa8QWxIxcxJxZOygtUUV0LnH
	YuT1M//SKlsZyJXs2PUUzaslazDH8Un6sHt2S4ve9cCdSUdozM1jVAEadKUBgeDezZdhDe
	rwDWTfpAl+XYlkcMiOkJBqsdVRTvHgc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611735; a=rsa-sha256;
	cv=none;
	b=tf3gzv/v1epk4rrvaTKCnV0Zm3ZtE2/4sTvXGKx1ZuAdncdDJAe9PEjtnyWTAjUPohmYOH
	Vik3CmdigRMUyQRLh2Rjz2ufecA844FwRYDUTK5ClZeKR5PivXn84170RjP/cJuqx+3C5j
	vr9sSObLwUUPZkTlXlCzuX+Rr51UOiU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PsMDp9wP;
	spf=pass (imf26.hostedemail.com: domain of 3FXYDaggKCGYHQEXPEGOKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3FXYDaggKCGYHQEXPEGOKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82fa7c6699fso7458027b3a.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611734; x=1779216534; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hRPMEjK5N2pbYThoIfW7Ke0tk0ug6zfSh2dkLV6x6RU=;
        b=PsMDp9wPBkOTEWz4p6kJkeWi6Z+htzWZsVMEZvNsD3Yr1C+4g+y0vKdPHNIhDfFvRY
         55cB3SJEkNZIaZLsHVpb9V7LLj0ln9iXvjKa/3R/P0MOgXkQ47pNv/aXT1sD+VSvEnNG
         NKUntX+/HSJuG1Ah61zFELZGi4Z3SFB06B6Ll9RM4Tf3neoUIzoXQDv9/NvRHwoxi7P+
         /26KZh+sGc44oMpes0KwB5bJHGtfEVk9Dz8q1QZrMtgSPF38oJtvy6UAgmH3kxWcOINu
         8Cle9U5123beQwCOX1n3lpZNGIanTo/3MgIssdJjrsMaxiryGoeRCOypIpvTN7zmlSF5
         oWeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611734; x=1779216534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hRPMEjK5N2pbYThoIfW7Ke0tk0ug6zfSh2dkLV6x6RU=;
        b=U/owM5fY/6nTvO8hdPdWuMz05gnU3GQBHrKh2/jhxA+Itj1czqXyvLIcFgPw4XqyvH
         idCtgnoYL8o9pwugDlujN4PFCTrK03ZHN5cmBb7q9ujlTLAE2s7/2M9SKwBgvTu0AEoC
         F5A1gm9AxYZhVEfxevIKJoaIWFDDk0InDCb5Jl3B2GHbUxZDKKhzKWGDDYkygcnwizgG
         e/O/r4OiCtoShrfg5oBMZPY3w+hEY6fU6oD+kywHXo/GKCtB//Dh3VGsKBoBCE5eK1bL
         dfTuWFE8sYq/ciPrl2d+QUYd6bHXLUkzPxL3GAqYBcoNlS4SeJS1y83GXK9piuimWjhj
         DQBw==
X-Forwarded-Encrypted: i=1; AFNElJ/ENdh03tpSUo+pshJifgGajDGZIgXbMxXadLe6kTGj6Kav0YH1Y9LvDdwDljF8xQXmzWBmdnvLnA==@kvack.org
X-Gm-Message-State: AOJu0YyoUlRbVFU5BfQLB+x6tGPI8Kp4VeOTQxMysLt3Uvv/aNJcXmyJ
	lJRtYID8NHYcxbP7MnOAH7rBKEqjifUkcWuESV7iQtpr0GrAIdnB4pbHs/aiXP6mCXHYa0+99Xb
	UxKfQ/We0KyupNA==
X-Received: from pfblh16.prod.google.com ([2002:a05:6a00:7110:b0:82f:805:b62a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:929d:b0:82f:1b42:11d0 with SMTP id d2e1a72fcca58-83e39948512mr15528636b3a.15.1778611733501;
 Tue, 12 May 2026 11:48:53 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:38 +0000
In-Reply-To: <20260512184846.119396-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260512184846.119396-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-4-dmatlack@google.com>
Subject: [PATCH v5 03/11] PCI: liveupdate: Track incoming preserved PCI devices
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2A2E14000E
X-Rspam-User: 
X-Stat-Signature: mwaen6pwuofxmmsb3tesjkhiastyishr
X-HE-Tag: 1778611734-498948
X-HE-Meta: U2FsdGVkX1+pwBdTeoVdTWxOV14MtbK7wcBLj50vraNJzJVmbuMtR6i8spcGgWBJYBzS2mZ+8uK5AxQ9htBLbiLB8teMnyi48CkILF4MpbcuNzlA10i00o7RMDUQvb/QEenQQKXnTpRqptE3A54rwU7fSe3/Esj+5HHhqyzre0E0EhEhyp3ezyQuBv2W8O7zCKZ36O0W0Q624EphXfwa4P1cxyJH6g9bWgqJ6KQXbpdgp4KiE7kbACA8bcZbAOUwjUp/4UiUu+8PmnAijCs7ihqN72DrmbEFi8aMlfV/OPeHvX+vwHCXW1tcxEytX6Uiy511TzkKtwC1MYDqpekCtITJ+TcHIBI8qLYl3n+jdVAO21gtTXOnyHnWgUWHFXO24+nxd1yxgDxwuRW0H9owghl95fZsxLBHMAvLm+rF2TKfxbYj1NiVVkQPkM9PVRgttX9ds/Bm/VJUmPnEmlHabWdMGlzEdX8VpQmAiOOZch78vEf1VZtUDrtt0Hr7Cq8lA09C64ApS16uhDHh1bwGoYGJUOim00B4pRWzEprDJK58lWWk+Pi0lPUhn0KGmLg070VtFaqdweZfElk2UIw9okJulFmPyWfxfYsDSGVQRfDRxC89u2MgBRCbyjvQn9tb3YZqwJ6XLJ43K6JeLGVDdmd6ULbxDqh01hOE0c0Ohw3ECyNCkQnReb1oWsH6jUOmu7BVB8Ym5DE9UvpwBksjqTqVIaQ61/ZNgN7XwV9eIyL46AIB2ox90zqs9fZj52xs5u4ERcCGkMX6kXufye7zcVb1/GFUg0b24Ni7lJgVfopqf3UAVkzE0E1VGj1wPwu8hs+zDRCQ0aSEp/BNy7sw9hjzsbdJnapO3ViNSC9xVyQnEU4pX/51ebtvaUgkdm94usFK30vUbSpdmQdINryHZl1jKYIHt/oqb3g6CCRBHti+8yDwyJGNbsPveUReG+meHrgATuf34JC8LgERcAN
 wlPcrRLR
 OooIhFJ56n8gUv7cmSsh8BiPrhE03ebsgjMtNIwvTygYodBF4Vy5MbFp+ztZNYhTYLq+8cSASqjMUFLu+LGt2YtNB18t4FA9wt9dL//wTtA73/84ylooIPSl1J8qqu2ZaO2Ftuu8/xAE+HsRn5RR0O7/efE1Xgw9l2oyYHAZL0PcTiDA1dxGlc4fSVfl02+CPbtZelCPeoMjshsxPmVl/xD5vNWP2qGoU3+LU3JUCc326IG8CueG+8d8zP64jNoOFiE2IFAcq3fVCw8SuG/XmTJNZ1uyHmRGt+E8JNuRcpC9sp+TmRjp6ro8Vaf4NZJ9SZKLn1Fq8hBfEhoNrJOLs4/O23dMU+mVnMG4wudLaJoynwALnOCqZTPWvrgvpAu+yumSgAYQ+pud3CAa4vrNs+ZIV+yIqnURED4RtGUJcDP00GzYhG7x/QV6DQXWa1ApRXXoH4LNF1euc4JBVW7A3aS3/htE00mYwvFZoopFfbHvcMHsfpGjmRNQg8yFNWY9IFAo6B/uZdFERrcOBofEaigL2B/hovhKI6U9omF2wBNT3RrJT8qY1B0dR2BylCj69N8mNSWKShDDniNI=
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

Drivers can check if a device is an incoming preserved device (e.g.
during probe) by calling pci_liveupdate_is_incoming().

CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that the
domain and bdf can be guaranteed to fit in an unsigned long and be used
as the xarray key.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                    |   1 +
 drivers/pci/Kconfig            |   2 +-
 drivers/pci/liveupdate.c       | 223 ++++++++++++++++++++++++++++++++-
 drivers/pci/liveupdate.h       |  26 ++++
 drivers/pci/probe.c            |   5 +
 include/linux/pci_liveupdate.h |  13 ++
 6 files changed, 267 insertions(+), 3 deletions(-)
 create mode 100644 drivers/pci/liveupdate.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6c618830cf61..0e262c0ceb43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20537,6 +20537,7 @@ L:	linux-pci@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	drivers/pci/liveupdate.c
+F:	drivers/pci/liveupdate.h
 F:	include/linux/kho/abi/pci.h
 F:	include/linux/pci_liveupdate.h
 
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 08398cbe970c..eea0a6cd388a 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -330,7 +330,7 @@ config VGA_ARB_MAX_GPUS
 
 config PCI_LIVEUPDATE
 	bool "PCI Live Update Support (EXPERIMENTAL)"
-	depends on PCI && LIVEUPDATE
+	depends on PCI && LIVEUPDATE && 64BIT
 	help
 	  Enable PCI core support for preserving PCI devices across Live
 	  Update. This, in combination with support in a device's driver,
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 9c4582ecd55c..f14396dd1477 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -56,6 +56,20 @@
  * This allows the PCI core to keep its FLB data (struct pci_ser) up to date
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
@@ -75,6 +89,8 @@
 #include <linux/mm.h>
 #include <linux/pci.h>
 
+#include "liveupdate.h"
+
 /**
  * struct pci_flb_outgoing - Outgoing PCI FLB object
  * @ser: The outgoing struct pci_ser for the next kernel.
@@ -85,6 +101,21 @@ struct pci_flb_outgoing {
 	struct mutex lock;
 };
 
+/**
+ * struct pci_flb_incoming - Incoming PCI FLB object
+ * @ser: The incoming struct pci_ser from the previous kernel.
+ * @xa: Xarray used to quickly lookup devices in @ser.
+ */
+struct pci_flb_incoming {
+	struct pci_ser *ser;
+	struct xarray xa;
+};
+
+static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
+{
+	return domain << 16 | bdf;
+}
+
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_outgoing *outgoing;
@@ -140,13 +171,44 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
 
 static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 {
-	args->obj = phys_to_virt(args->data);
+	struct pci_flb_incoming *incoming;
+	int i, ret;
+
+	incoming = kmalloc_obj(*incoming);
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
@@ -268,6 +330,163 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
 
+static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
+{
+	struct pci_flb_incoming *incoming = NULL;
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
+	return incoming;
+}
+
+static void pci_liveupdate_flb_put_incoming(void)
+{
+	liveupdate_flb_put_incoming(&pci_liveupdate_flb);
+}
+
+void pci_liveupdate_setup_device(struct pci_dev *dev)
+{
+	struct pci_flb_incoming *incoming;
+	struct pci_dev_ser *dev_ser;
+	unsigned long key;
+
+	incoming = pci_liveupdate_flb_get_incoming();
+	if (!incoming)
+		return;
+
+	key = pci_ser_xa_key(pci_domain_nr(dev->bus), pci_dev_id(dev));
+	dev_ser = xa_load(&incoming->xa, key);
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
+	guard(write_lock)(&dev->liveupdate.lock);
+	dev->liveupdate.incoming = dev_ser;
+
+	/*
+	 * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
+	 * that dev->liveupdate.incoming does not get freed while it is in use.
+	 */
+}
+
+void pci_liveupdate_cleanup_device(struct pci_dev *dev)
+{
+	bool incoming;
+
+	scoped_guard(write_lock, &dev->liveupdate.lock)
+		incoming = !!xchg(&dev->liveupdate.incoming, NULL);
+
+	/*
+	 * Drop the FLB reference acquired in pci_liveupdate_setup_device() if
+	 * the device is being cleaned up before pci_liveupdate_finish(), e.g.
+	 * due to allocation failure during setup.
+	 *
+	 * Do not drop dev->liveupdate.incoming->refcount since this device has
+	 * not gone through pci_liveupdate_finish() and thus is still an
+	 * incoming preserved device.
+	 */
+	if (incoming)
+		pci_liveupdate_flb_put_incoming();
+}
+
+/**
+ * pci_liveupdate_finish() - Finish the preservation of a PCI device across Live Update
+ * @dev: The PCI device
+ *
+ * pci_liveupdate_finish() notifies the PCI core that a PCI device that was
+ * preserved across the previous Live Update has finished participating in Live
+ * Update. Drivers must call pci_liveupdate_finish() from their struct
+ * liveupdate_file_handler finish() callback to ensure the incoming struct
+ * pci_ser is allocated.
+ */
+void pci_liveupdate_finish(struct pci_dev *dev)
+{
+	guard(write_lock)(&dev->liveupdate.lock);
+
+	if (!dev->liveupdate.incoming) {
+		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
+		return;
+	}
+
+	pci_info(dev, "Device is finished participating in Live Update\n");
+
+	/*
+	 * Drop the refcount so this device does not get treated as an incoming
+	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
+	 * again because the device is hot-plugged.
+	 */
+	dev->liveupdate.incoming->refcount = 0;
+	dev->liveupdate.incoming = NULL;
+
+	/* Drop this device's reference on the incoming FLB. */
+	pci_liveupdate_flb_put_incoming();
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
+
+/**
+ * pci_liveupdate_is_incoming() - Check if a device is incoming preserved
+ * @dev: The PCI device to check
+ *
+ * Check if a device was preserved across Live Update by the previous kernel,
+ * i.e. the device is incoming preserved. Note that a device is only considered
+ * incoming preserved prior to pci_liveupdate_finish(). It is up to drivers to
+ * synchronize usage of pci_liveupdate_is_incoming() with their own call to
+ * pci_liveupdate_finish() to avoid acting on stale data.
+ *
+ * Returns: True if the device is incoming preserved, false otherwise.
+ */
+bool pci_liveupdate_is_incoming(struct pci_dev *dev)
+{
+	guard(read_lock)(&dev->liveupdate.lock);
+	return dev->liveupdate.incoming;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_is_incoming);
+
 /**
  * pci_liveupdate_register_flb() - Register a file handler with the PCI core
  * @fh: The file handler to register.
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
new file mode 100644
index 000000000000..eaaa3559fd77
--- /dev/null
+++ b/drivers/pci/liveupdate.h
@@ -0,0 +1,26 @@
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
+#endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 54ae32cb0000..b5fdc5017f92 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -24,6 +24,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/bitfield.h>
 #include <trace/events/pci.h>
+#include "liveupdate.h"
 #include "pci.h"
 
 static struct resource busn_resource = {
@@ -2069,6 +2070,8 @@ int pci_setup_device(struct pci_dev *dev)
 	if (pci_early_dump)
 		early_dump_pci_device(dev);
 
+	pci_liveupdate_setup_device(dev);
+
 	/* Need to have dev->class ready */
 	dev->cfg_size = pci_cfg_space_size(dev);
 
@@ -2192,6 +2195,7 @@ int pci_setup_device(struct pci_dev *dev)
 	default:				    /* unknown header */
 		pci_err(dev, "unknown header type %02x, ignoring device\n",
 			dev->hdr_type);
+		pci_liveupdate_cleanup_device(dev);
 		pci_release_of_node(dev);
 		return -EIO;
 
@@ -2490,6 +2494,7 @@ static void pci_release_dev(struct device *dev)
 
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
+	pci_liveupdate_cleanup_device(pci_dev);
 	pci_release_of_node(pci_dev);
 	pcibios_release_device(pci_dev);
 	pci_bus_put(pci_dev->bus);
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 0803d44becd5..1c2ee32ad058 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -17,10 +17,12 @@
  * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
  * @lock: Lock used to protect members of struct pci_liveupdate.
  * @outgoing: State preserved for the next kernel.
+ * @incoming: State preserved by the previous kernel.
  */
 struct pci_liveupdate {
 	rwlock_t lock;
 	struct pci_dev_ser *outgoing;
+	struct pci_dev_ser *incoming;
 };
 
 struct pci_dev;
@@ -30,6 +32,8 @@ int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
 void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
 int pci_liveupdate_preserve(struct pci_dev *dev);
 void pci_liveupdate_unpreserve(struct pci_dev *dev);
+void pci_liveupdate_finish(struct pci_dev *dev);
+bool pci_liveupdate_is_incoming(struct pci_dev *dev);
 #else
 static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
@@ -48,6 +52,15 @@ static inline int pci_liveupdate_preserve(struct pci_dev *dev)
 static inline void pci_liveupdate_unpreserve(struct pci_dev *dev)
 {
 }
+
+static inline void pci_liveupdate_finish(struct pci_dev *dev)
+{
+}
+
+static inline bool pci_liveupdate_is_incoming(struct pci_dev *dev)
+{
+	return false;
+}
 #endif
 
 #endif /* LINUX_PCI_LIVEUPDATE_H */
-- 
2.54.0.563.g4f69b47b94-goog


