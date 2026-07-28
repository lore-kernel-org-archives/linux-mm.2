Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90497C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CADF6B0098; Tue, 28 Jul 2026 18:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C1E6B0099; Tue, 28 Jul 2026 18:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A826B009B; Tue, 28 Jul 2026 18:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7E2C6B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40C311404C9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:28 +0000 (UTC)
X-FDA: 85039580136.02.2A5A9DE
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F5A014000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MMqp7XNK;
	spf=pass (imf23.hostedemail.com: domain of 30ChpaggKCCEAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=30ChpaggKCCEAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ie+eI/koF7po3m7kzWZc+lJwyneNfjZRODTLriXqOwk=;
	b=S4jmgu5Kz0GMJkXpFJa5cgg+gLvo2k8ldb/qMnpuywkFXO2DdSspeSysXTTQo+7/k0NfBd
	WTcyNz1FmbY7GZxsKmOtr4cZGFjdG9rrNqx1PD+xJVXT5PT2fNf4leNlJQLgtuRBNPRYSo
	+rS+pt9D9TuzxqND0gSPdchO96e0zAk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MMqp7XNK;
	spf=pass (imf23.hostedemail.com: domain of 30ChpaggKCCEAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=30ChpaggKCCEAJ7QI79HDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276626;
	b=m2t7cu59LojBQabYDW4ZyJ/2Pxl7B5UY2TeSfCiNAI4hVCpQotsZsm0YbImzw6TYC6wN38
	6xRuDywQDiJThMZT2Xi3nW1vW590aSZkAsiqh2wLHf/0R60P5fn8QTsXWbQLZkau2DfaPy
	c1aqM3VNQ8FBvbk3zzFbADZVlCXMl6o=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3823dcc1647so381589a91.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276625; x=1785881425; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ie+eI/koF7po3m7kzWZc+lJwyneNfjZRODTLriXqOwk=;
        b=MMqp7XNK6prUi+ZQkfdMPVDHAbU8RKqAW805E/HP4kVAFl7UB989fN1VlONCtF+brY
         UU+F07ZrfKeyIhLKDcwOE/oe3epWYz6bdQCZqhnCvTtUHEgeAG25T8rGyDLqwTwEoM7l
         gYwTA7kgwrtPNriKZ+Pe8qF2vowyeOmg9QTagUG64uhTGnCtDGrIsIgrd3kMnluuV2UP
         ecR+twVRuh8m3byhvk+nyDlwwAdztrosoK99QguppA6qsC33ikSQ+/6Mcf8tC4eFQ43i
         6DDqO+3WXCQOD9Mpyo0Vn0/8vVv/BlfRqa+XEe2Hbw07uWIU+yq7lwmAgOvTa+nKKSYp
         2UiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276625; x=1785881425;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ie+eI/koF7po3m7kzWZc+lJwyneNfjZRODTLriXqOwk=;
        b=qMRn22RSZz6ewIgHmu51Y2tw0gR0ibEp/tZqvm26DqWGYVGm+6OX331KCGdksjBpQd
         KhlrQ31/0gTGXf+Tl1kDUXo49xp99x9rNMbqNnUa75CxKtz4ciZe1PiS9hH9MdzQ30UY
         GQfHp+HbBoakBAUjlTSTrppPoRXbrbiyNuhS/Z5dMZkamhDrQ4RBH9Q+o2YHZSrc3t+B
         W5FcP3qAP7VdoDLxAbKK4d43/r9zz+LtRytzxGOVQCkQ/cu8dLuWAmkAAqhtVN7SuNpe
         rbRSEZOMdfVHT/VOi9DJDUABBFYmqTXAuOGsZb+Seqvbi95puzbKrFZCA0r3v5uCoVdD
         uYzw==
X-Forwarded-Encrypted: i=1; AHgh+Ropz0NTwG9Yu+Yj2Dqf+MiFhhnX0YUmgzHSrS7k4H4livq8rMXsuvr9r+2sOoTl/GCEowfC4W7z4A==@kvack.org
X-Gm-Message-State: AOJu0YxCrk5c7PQnFs6in2EtP86MrHcXxDJo6U3XeM17xuNy25+SJ8Zc
	4Yf5f0weOMLL+4NQ6InWeKncWCpxnF/I0h2Y+zPD5UunKF8A+VLfld9wlqQ5e/2+NHN7X2FBq1/
	i22bhk+IPVYhyEQ==
X-Received: from pjqh19.prod.google.com ([2002:a17:90a:a893:b0:38e:ffcd:b70f])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d46:b0:37f:eda5:5169 with SMTP id 98e67ed59e1d1-38f6a44b293mr4069719a91.13.1785276624975;
 Tue, 28 Jul 2026 15:10:24 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:09:59 +0000
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-6-dmatlack@google.com>
Subject: [PATCH v8 05/12] PCI: liveupdate: Preserve bus numbers during Live Update
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F5A014000D
X-Stat-Signature: aye4w47euecdimh18ic6kh9b3mw73x8o
X-HE-Tag: 1785276626-134337
X-HE-Meta: U2FsdGVkX187+fpbRJQPAM/9aV0FJad1gEfCGGrG2JgFgd65D5wzZ+fiziIBulUaEJj3fcYC/sd7fk98g/Dp4jXOHZxK5EKVe88v4Wi6STZP3I3+UTEXEpdF+BdibCnqwXVP5bQL6ukkW21i+amdntrUaVza7k+VYD0b8yZNnzGrTe/dhV/ogEp2zSKayKDDzwwm+zk6iUvSh049sCf3Z2qcCm9CxRa0BfMVrP7ZhlkzZ0BKaXzixUabWcEEhcXiwm9KtMuHKyk83K2CPoEwhxvT03zWFAa1H+W/sTEwrNcrFUu9kvZjWn2klXAsBj0aSz7mQZ0/dHtTkAtpRmXkvvqsfWwu/uBaXfwIH2s5btZ4U0TjWZhrEkizl+WtsUhx3EJb+vxGMAHccvL6Z/UCm5pFOqNGbhNihfsLdtLYIDz76Grj23RvbpkAucGNQSp66JwlTlc5BUtRivRai5tXBxC79Dp65Ba5/XojEnEWQt3zEUlZMHTQPXDDsQxZYusTo+s7pFz9j42uzNNybBZhXh5suC1LUzwabkNuOrDI8NDBd4pxGiKVjx6m6GxlDLFh+EIqaArY1QQN6K/hjBbGJDXZ7j91TTmMh2NdjcJe1R6gRRF3eP6+xN+Lit3c2qqO1eIL3wG8JBc61PDb8ORuoMhIot58fT5nB8OM8ApJr7WF8cBpy39bGw23Kn3J0fyhNGKxplRpqzYEz/yROdZVQOQQ/p2qpRsUlcBzhNqtjFHJc6u6hB8LjRySyBNgmBQpIiuv/1PAYNOdnntsNM3SW4HSTFBX3ouVvcT/vAhpjSBUSX8wDRQEpYaovIF8uo3+2adz0nlQ3McGcmM1FDyKyCZkTLgtYgxK/wPj1guYuoxg8PT1c9vhxQjSwp7SVflTEXBfr8KgAGbwU+XHonWRP/cp0ALsd6DgGRux/uDnLcui8huqgF5+Kw8thDeil9aze6d4XvgQJt/XOWmRccT
 nJF5p/Os
 jk2WbDsZ4ZQyZyuO/iC6lA1QCUGVNBBTIx78LjAXKIHxBy5HJuk9+m106eoGPWrq5ZJ3IZQ4vMTRJ/Idnox3soG+PmrTfogjTD+PiPmKbRdQPZyoAIc5mtSAi35hWvO9M3kcY5l1VKa0Ip3sGfe75hD3/SGS7hTC25UGOrmI6FjQPcKBS963hlaukM5KM4Ofe5elruXHZxooj0hN+K0cABwpva0R6Dj+gyquMsd4JRJoc2lIzZxg9ub8vcNSdnsiVTPAcDP6H/RUIM+ajZgW7FCYocAE9g/zuwQ2OVksZlSnHKVbGxQebtVxUR1+5Ro7TLLPGE+A/lNEArcU7TswwFxwLO3V9lA4+ck1gxcjZemlW3RK4qW5ItywzLk9Lfo8qLY3YX/F3mkwG6ygMqeJpFocz1o8YC9zcX5dP7Ucr688V9YfImmAVxx5wDPReqaseORNrUPqCgxCRXNaVvtOFlXz3NUncGcXi5WoEPIqEwBDTKbGrkiXiAR+Ebps/mAt+xypLXQql/GNC9kYdavGpLjGBIivuTjG/88NllG4sPk004Rk6Yn/fROVkznPZqp4/XyJ5TxEzPQNsVRWzCgFbaCyFi4+7/+1wWVTDvnJvpmQYoKGfG6a/jStpGnOa46Ya9uBEDx08BWiZwwnEtI1QEYJmvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During a Live Update, preserved devices must be allowed to continue
performing memory transactions so the kernel cannot change the fabric
topology, including bus numbers, since that would require disabling and
flushing any memory transactions first.

To keep bus numbers constant, always preserve the secondary and
subordinate bus numbers assigned to bridges during scanning, instead of
assigning new ones, if any PCI devices were preserved. Note that the
kernel preserves bus numbers even on bridges without any downstream
endpoints that were preserved. This avoids accidentally assigning a
bridge a new window that overlaps with a preserved device that is
downstream of a different bridge.

If a bridge is scanned with a broken topology or has no bus numbers set
during a Live Update, refuse to assign it new bus numbers and refuse to
enumerate devices below it until the Live Update is finished. This is a
safety measure to prevent topology conflicts.

Require that CONFIG_CARDBUS is not enabled to enable
CONFIG_PCI_LIVEUPDATE since preserving bus numbers on PCI-to-CardBus
bridges requires additional work but is not a priority at the moment.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  6 +-
 drivers/pci/Kconfig                           |  2 +-
 drivers/pci/liveupdate.c                      | 95 +++++++++++++++++++
 drivers/pci/liveupdate.h                      | 13 +++
 drivers/pci/probe.c                           | 18 +++-
 include/linux/pci_liveupdate.h                |  4 +
 6 files changed, 132 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 4f65b2a37521..c394a0df8e31 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5105,7 +5105,11 @@ Kernel parameters
 				explicitly which ones they are.
 		assign-busses	[X86] Always assign all PCI bus
 				numbers ourselves, overriding
-				whatever the firmware may have done.
+				whatever the firmware may have done. Ignored
+				during a Live Update, where the kernel must
+				preserve the PCI topology (including bus
+				numbers) to avoid interrupting ongoing memory
+				transactions of preserved devices.
 		usepirqmask	[X86] Honor the possible IRQ mask stored
 				in the BIOS $PIR table. This is needed on
 				some systems with broken BIOSes, notably
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 8af20f558086..16fbd4212e0f 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -273,7 +273,7 @@ config VGA_ARB_MAX_GPUS
 
 config PCI_LIVEUPDATE
 	bool "PCI Live Update Support"
-	depends on PCI && LIVEUPDATE && 64BIT
+	depends on PCI && LIVEUPDATE && 64BIT && !CARDBUS
 	help
 	  Enable PCI core support for preserving PCI devices across Live
 	  Update. This, in combination with support in a device's driver,
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 0f7a018ddc66..d312381c9e10 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -87,6 +87,21 @@
  * bound to the correct driver. i.e. The PCI core does not protect against a
  * device getting preserved by driver A in the outgoing kernel and then getting
  * bound to driver B in the incoming kernel. This may change in the future.
+ *
+ * BDF Stability
+ * =============
+ *
+ * The PCI core guarantees that preserved devices can be identified by the same
+ * bus, device, and function numbers for as long as they are preserved
+ * (including across kexec). To accomplish this, the PCI core always preserves
+ * the secondary and subordinate bus numbers assigned to bridges during scanning
+ * if any device is preserved. This is true even on architectures that always
+ * assign new bus numbers during scanning. The kernel assumes the previous
+ * kernel established a sane bus topology across kexec.
+ *
+ * If a misconfigured or unconfigured bridge is encountered during enumeration
+ * while there are preserved devices, its secondary and subordinate bus numbers
+ * will be cleared and devices below it will not be enumerated.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -489,6 +504,86 @@ static void pci_liveupdate_flb_put_incoming(void)
 	liveupdate_flb_put_incoming(&pci_liveupdate_flb);
 }
 
+static bool pci_has_incoming_preserved_devices(void)
+{
+	struct pci_flb_incoming *incoming;
+	u32 nr_devices;
+
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+
+	incoming = pci_liveupdate_flb_get_incoming();
+	if (!incoming)
+		return false;
+
+	nr_devices = incoming->ser->nr_devices;
+	pci_liveupdate_flb_put_incoming();
+
+	return nr_devices > 0;
+}
+
+/**
+ * pci_liveupdate_preserve_bus_numbers() - Determine if the PCI core should
+ *                                         preserve bus numbers when scanning
+ *                                         the provided bridge.
+ * @bus: The parent bus of the bridge.
+ * @dev: The PCI bridge device.
+ *
+ * This function is called by the PCI core when it is scanning a bridge.  It
+ * determines whether the PCI core should preserve the secondary and subordinate
+ * bus numbers assigned to @dev by the previous kernel. This is necessary to
+ * keep RequesterIDs constant for preserved devices issuing memory transactions.
+ *
+ * Return: True if bus numbers should be preserved, false otherwise.
+ */
+bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus, struct pci_dev *dev)
+{
+	struct pci_dev *parent = bus->self;
+
+	if (dev->liveupdate.preserve_bus_numbers)
+		return true;
+
+	if (parent && parent->liveupdate.preserve_bus_numbers) {
+		/*
+		 * Preserve bus numbers if the parent bridge is required to
+		 * preserve bus numbers. Otherwise the PCI core could expand
+		 * this bridge's reservation beyond its parent (which cannot
+		 * expand).
+		 */
+		dev->liveupdate.preserve_bus_numbers = true;
+	} else {
+		/*
+		 * Otherwise preserve bus numbers if there are any incoming
+		 * preserved devices. This ensures that the PCI core does not
+		 * allocate a bus number to a non-preserved device that
+		 * conflicts with the bus number already assigned to a preserved
+		 * device.
+		 *
+		 * This is slightly more restrictive than it needs to be. For
+		 * example, each host bridges have their own range of bus
+		 * numbers that won't conflict with other host bridges. But the
+		 * previous kernel should have assigned a sane bus topology and
+		 * it is simpler to just adopt that entire topology.
+		 */
+		dev->liveupdate.preserve_bus_numbers =
+			pci_has_incoming_preserved_devices();
+	}
+
+	return dev->liveupdate.preserve_bus_numbers;
+}
+
+/**
+ * pci_liveupdate_scan_bridge_end() - Finish scanning a PCI bridge
+ * @dev: The PCI bridge device.
+ *
+ * This function is called by the PCI core when it finishes scanning a bridge.
+ * It clears the bus number preservation status of the bridge so it can be
+ * re-evaluated on future scans.
+ */
+void pci_liveupdate_scan_bridge_end(struct pci_dev *dev)
+{
+	dev->liveupdate.preserve_bus_numbers = false;
+}
+
 void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
 	struct pci_flb_incoming *incoming;
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index eaaa3559fd77..107881183fda 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -13,6 +13,9 @@
 #ifdef CONFIG_PCI_LIVEUPDATE
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus,
+					 struct pci_dev *dev);
+void pci_liveupdate_scan_bridge_end(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -21,6 +24,16 @@ static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
+
+static inline bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus,
+						       struct pci_dev *dev)
+{
+	return false;
+}
+
+static inline void pci_liveupdate_scan_bridge_end(struct pci_dev *dev)
+{
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5dc9d86e3597..5ecb55412854 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1397,6 +1397,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 				  int max, unsigned int available_buses,
 				  int pass)
 {
+	bool preserve_bus_numbers = !pcibios_assign_all_busses();
 	struct pci_bus *child;
 	u32 buses;
 	u16 bctl;
@@ -1406,6 +1407,9 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 	u8 fixed_sec, fixed_sub;
 	int next_busnr;
 
+	if (pci_liveupdate_preserve_bus_numbers(bus, dev))
+		preserve_bus_numbers = true;
+
 	/*
 	 * Make sure the bridge is powered on to be able to access config
 	 * space of devices below it.
@@ -1449,8 +1453,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		goto out;
 	}
 
-	if ((secondary || subordinate) &&
-	    !pcibios_assign_all_busses() && !broken) {
+	if ((secondary || subordinate) && preserve_bus_numbers && !broken) {
 		unsigned int cmax, buses;
 
 		/*
@@ -1492,8 +1495,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		 * do in the second pass.
 		 */
 		if (!pass) {
-			if (pcibios_assign_all_busses() || broken)
-
+			if (!preserve_bus_numbers || broken)
 				/*
 				 * Temporarily disable forwarding of the
 				 * configuration cycles on all bridges in
@@ -1507,6 +1509,11 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 			goto out;
 		}
 
+		if (pci_liveupdate_preserve_bus_numbers(bus, dev)) {
+			pci_err(dev, "Cannot reconfigure bridge during Live Update, skipping\n");
+			goto out;
+		}
+
 		/* Clear errors */
 		pci_write_config_word(dev, PCI_STATUS, 0xffff);
 
@@ -1568,6 +1575,9 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 
 	pm_runtime_put(&dev->dev);
 
+	if (pass)
+		pci_liveupdate_scan_bridge_end(dev);
+
 	return max;
 }
 
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 710026ada2d5..fc1f5640968a 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -17,10 +17,14 @@
  * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
  * @outgoing: State preserved for the next kernel.
  * @incoming: State preserved by the previous kernel.
+ * @preserve_bus_numbers: True if the PCI core should preserve the secondary and
+ *                        subordinate bus numbers assigned to this device due to
+ *                        an ongoing Live Update.
  */
 struct pci_liveupdate {
 	struct pci_dev_ser *outgoing;
 	struct pci_dev_ser *incoming;
+	bool preserve_bus_numbers;
 };
 
 struct pci_dev;
-- 
2.55.0.487.gaf234c4eb3-goog


