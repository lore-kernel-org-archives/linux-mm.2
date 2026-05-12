Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8336CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3196B0096; Tue, 12 May 2026 14:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3966B0098; Tue, 12 May 2026 14:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0F46B0099; Tue, 12 May 2026 14:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF4BD6B0096
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:48:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B67FB16059C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:58 +0000 (UTC)
X-FDA: 84759654756.28.750B977
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id D56AC40009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZdFhNzvU;
	spf=pass (imf27.hostedemail.com: domain of 3F3YDaggKCGgJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3F3YDaggKCGgJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mf7tBxAoZfUaNtQaP4XWMUKhokf1zfg+pw28xJapIfc=;
	b=1V10thIgj7n9qlzKapJIvFzYiogrso12Gs9iWF/v4XeINwEMQEpf22kelp35jBDThtPUe+
	XDlM388CPGDfuMBijFkCkIxLQgUZMChT6RE8bii5srAu9m6pVYysXsiqJQRPPOnGHsHXV4
	QQTOfecDYvxxWgD9akJlPDQezORwo2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611736; a=rsa-sha256;
	cv=none;
	b=In0yf0OS56RB2UBqduEktPNbNAJyeItub/hmKJV3coRwGys1njYNZEKyNPv6O0VMlXPDRF
	t3+TG9q0bm7iUxfnlmsXB7rNMw5a7awLsfandm35rBnYwHF/FFGEEvZSNAx9BZYNK+xj8v
	qB+ESn/hDtnUuXPVPsIvjA9hyepPN4k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZdFhNzvU;
	spf=pass (imf27.hostedemail.com: domain of 3F3YDaggKCGgJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3F3YDaggKCGgJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c8294d8c48eso1487728a12.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611736; x=1779216536; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mf7tBxAoZfUaNtQaP4XWMUKhokf1zfg+pw28xJapIfc=;
        b=ZdFhNzvUjX0JuJjFQdhUVTynnuu3xbkzuHfDf737KAZ1rSRm3isRpwb+vT99Sp/ZGl
         dkcB70ADqori5tn2yRCipB8wzAWtJDISJ+2IbrtRdjmiu9rcfz1lpasPT+QSsoVIXGzM
         fiJP4NuJoqCcVoF8NPD/kkx8hVMsBH+lwMTdVcHJGvm0UfnVniLL7HVcnubaDlY3Fve6
         yqSzoADg0usjY8svSj4AC4ZqgANbTTCOwzKucMruZgKx2hc1sljrVghq5PumhgI6Vp51
         ckwepvP77eIskhJUmwljZxCYFtVrsT5dDWFx3AwFRoUO4pJt6m5KBr4QJBV0XKzUUA5r
         zI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611736; x=1779216536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mf7tBxAoZfUaNtQaP4XWMUKhokf1zfg+pw28xJapIfc=;
        b=VpySZELMSvjzaQy6MquFM7uXBAIyz0xG/yFZcODYPxrlDnkxqNQjCbiYS5KtSRrO4b
         eZTXBm7MXellf8VCdXw30JH3S6QdB/rCbwtRxpT8K+OQF903XtZJi89BatRyKs1tvtBQ
         sJOZz6I1cDlIkHyq7zzT733kWQroq7/poYosiYEFACl7UzHOeOlhdsldG/3W5j6Wa+hj
         NxdDFRqUI1c8Tbl/eTU+gbkO28iNk0omH4JihQ9wGp1qLDYir2OskfICHtyYbMBWjAv1
         icihlQU4hiVVUGHn5swGd/fNn54mT4Q099ahVmiJtLgu5E9poalJEYBWBgejn6wG6QGR
         GRDQ==
X-Forwarded-Encrypted: i=1; AFNElJ+cgV9qk5FbwTlNwaLuArj2E64LBqNxs1yTT5mnhN2pB+M3xiHLhoEWZNFsWbg6AWttplL1l5ABtQ==@kvack.org
X-Gm-Message-State: AOJu0Yzv/3WZrvt2Njubr/nKIFfs2KT6e/sRrZn/ZFch95ctLutKsN6m
	waYoxrWrxwXY1x8BoVD1YkWH35nTsjhKxvIMe8jqvOzYOzJs10d3gHYNaUfobj3Ah9IShr0NdSf
	vKXlytGPnGViRzw==
X-Received: from pfbem38.prod.google.com ([2002:a05:6a00:3766:b0:835:38e9:3254])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3386:b0:395:ce56:4448 with SMTP id adf61e73a8af0-3ad975a01camr4741664637.25.1778611735458;
 Tue, 12 May 2026 11:48:55 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:40 +0000
In-Reply-To: <20260512184846.119396-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260512184846.119396-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-6-dmatlack@google.com>
Subject: [PATCH v5 05/11] PCI: liveupdate: Keep bus numbers constant during
 Live Update
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
X-Rspamd-Queue-Id: D56AC40009
X-Rspam-User: 
X-Stat-Signature: wp7kb7irb9fkqtqarct5wqcxy7jramfz
X-HE-Tag: 1778611736-437464
X-HE-Meta: U2FsdGVkX1/xaRTDWB8pdG6k+HPVTfwkCCrpqk48fmmg+rW2xw+I90vB7R4NQ5zttE1x23voDchPpglgi3spkp+pBZEwSknFOnMf1AkBUaqiqbldnQ6j2zHNSlWWnRWrjchKWC1oby/rfooOtK5FlYX/DwUZdRTA0eyaC3iNauxrYzk+mvxSZPKv/ykSsvLFqy4FhirmpqlMuRWeHOFkaYnpEmxqKJrndtPrR+4V0RVYvtK+0JvZygqen0ISjw7K0B8P7KdhAomD3e2XoOo5Qmc3yGTGczrj0ghEQD7mIpAVcRp4LDiiHJWadIsz6JmYrZswHiSwCpDUFP75TtXpcLV3K5hyJ6wCs4sfeen6XCAJqRJS23ahbNUckq85WKkcWogQcgM+OEJnAiiYdHux5iUXmmxxzmgiM0jDWADK/XswntPm5mTVJc4zYGY+hYz4Nh9oAyBtgKgOfuUlWrwRojnQNlg/ntrY8mxZKftBRoRDaDako8UQVRMfkTRcEjDnTTd2aWawPecA9IHdRvRBtnoJv/BKypCTPXFFoDYJ54pqDozRt9rEDRL6IGP2EEGsjVUiBZamcMnAmLLUvaAKVL3X2iqPT8Sh4W8CuxhC2Ywv8vOZ2S3dOpHmLin/A67Tk4SblGfGV3eUsjBwlD3K58/YCh1lmL0f1A35O/niqFNFi54dga/NDZB5msQiDL8UCCjeHex/prs2PY7rTIOTTNYgTk7vc8fbc/e8xoUs1IvFTXD2qY63mAYCpEOUwmtmvyWn9ZjmdRm7ac0c1OhKY+qloTOJ1FEohctIoxJ3t6Q4kIydC3kUgmMuAcWrOJ6Z7lZj5eI0W2da0DE6iC+TvN/US2yyIiUdFg8mX5rG42BtFGEUOdXk8dYJMqmMYQC06/MxuOhPwmN+KsLCrt0t4PlwmUucRKQRso9RAYvuHN9LFPtDH1BV/F/lC5CnF/HU6gQqRjyeF/lZ+7e7Wbn
 9aPCYjeM
 2R/tqPQ6nEds5X42dJp+RmccqeNjbHy8ngpnDOQXIZnXh6fNpCc+D5JJZbL39IGxdQT4dolYnGOjhXNqmpgcBOx+0Kp/EA6Y34vT2EEAT7RvNSefM63WXFODZm4xzUoo4YM2lLKSn4YOydz0Xw0tovmnbSpNlOrw9ZDOHky+bhKrDcyp9+uSAWlY9xw4jvTUGxmLsukfBTM3mkkPedw16z185PFCAlp75droSK4r8uWpfLzrMGCBESEFjD2QPTsfSxTBx1FzFap0g7KiS73XjLJTetRpZvRSz4vyLmq32c4P9IUk9gshloVWb0tGTINWXJk07luFGI3j2h8eB4h8nKo/giySVS/fxB7whO1PyER7Hmja/BUhK6ayTYWkX5lYNufgzpLY6wiLrvGqiANAr160H52Zk6e4/ShoGkk/dSZ5FxfT1jHZUsLaG6+1GtePGbUdn35y/wZg70aXZ6JYcUSc3zNo8LKu+cTSTLv6CYV6TJ3inldqyrAJB5kMnhqqBYCLixWp1J3qoCLOiFraF0k2dq81ogCBLeb7hjf1xJLKujNn8eBrIUC+m+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During a Live Update, preserved devices must be allowed to continue
performing memory transactions so the kernel cannot change the fabric
topology, including bus numbers, since that would require disabling
and flushing any memory transactions first.

To keep bus numbers constant, always inherit the secondary and
subordinate bus numbers assigned to bridges during scanning, instead of
assigning new ones, if any PCI devices are being preserved. Note that
the kernel inherits bus numbers even on bridges without any downstream
endpoints that were preserved. This avoids accidentally assigning a
bridge a new window that overlaps with a preserved device that is
downstream of a different bridge.

If a bridge is scanned with a broken topology or has no bus numbers
set during a Live Update, refuse to assign it new bus numbers and refuse
to enumerate devices below it. This is a safety measure to prevent
topology conflicts.

Require that CONFIG_CARDBUS is not enabled to enable
CONFIG_PCI_LIVEUPDATE since inheriting bus numbers on PCI-to-CardBus
bridges requires additional work but is not a priority at the moment.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  6 +-
 drivers/pci/Kconfig                           |  2 +-
 drivers/pci/liveupdate.c                      | 60 +++++++++++++++++++
 drivers/pci/liveupdate.h                      |  6 ++
 drivers/pci/probe.c                           | 21 +++++--
 5 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 4d0f545fb3ec..a64af71c2705 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5138,7 +5138,11 @@ Kernel parameters
 				explicitly which ones they are.
 		assign-busses	[X86] Always assign all PCI bus
 				numbers ourselves, overriding
-				whatever the firmware may have done.
+				whatever the firmware may have done. Ignored
+				during a Live Update, where the kernel must
+				inherit the PCI topology (including bus numbers)
+				to avoid interrupting ongoing memory
+				transactions of preserved devices.
 		usepirqmask	[X86] Honor the possible IRQ mask stored
 				in the BIOS $PIR table. This is needed on
 				some systems with broken BIOSes, notably
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index eea0a6cd388a..aa665231921c 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -330,7 +330,7 @@ config VGA_ARB_MAX_GPUS
 
 config PCI_LIVEUPDATE
 	bool "PCI Live Update Support (EXPERIMENTAL)"
-	depends on PCI && LIVEUPDATE && 64BIT
+	depends on PCI && LIVEUPDATE && 64BIT && !CARDBUS
 	help
 	  Enable PCI core support for preserving PCI devices across Live
 	  Update. This, in combination with support in a device's driver,
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index d77e64906a25..558fbaec8ddd 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -93,6 +93,21 @@
  * bound to the correct driver. i.e. The PCI core does not protect against a
  * device getting preserved by driver A in the outgoing kernel and then getting
  * bound to driver B in the incoming kernel.
+ *
+ * BDF Stability
+ * =============
+ *
+ * The PCI core guarantees that preserved devices can be identified by the same
+ * bus, device, and function numbers for as long as they are preserved
+ * (including across kexec). To accomplish this, the PCI core always inherits
+ * the secondary and subordinate bus numbers assigned to bridges during scanning
+ * if any device is preserved. This is true even on architectures that always
+ * assign new bus numbers during scanning. The kernel assumes the previous
+ * kernel established a sane bus topology across kexec.
+ *
+ * If a misconfigured or unconfigured bridge is encountered during enumeration
+ * while there are preserved devices, itss secondary and subordinate bus numbers
+ * will be cleared and devices below it will not be enumerated.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -107,6 +122,20 @@
 
 #include "liveupdate.h"
 
+/*
+ * During a Live Update, preserved devices are allowed to continue performing
+ * memory transactions. The kernel must not change the fabric topology,
+ * including bus numbers, since that would require disabling and flushing any
+ * memory transactions first.
+ *
+ * To keep things simple, inherit the secondary and subordinate bus numbers on
+ * _all_ bridges if _any_ PCI devices are preserved (i.e.  even bridges without
+ * any downstream endpoints that were preserved).  This avoids accidentally
+ * assigning a bridge a new window that overlaps with a preserved device that is
+ * downstream of a different bridge.
+ */
+static atomic_t inherit_buses;
+
 /**
  * struct pci_flb_outgoing - Outgoing PCI FLB object
  * @ser: The outgoing struct pci_ser for the next kernel.
@@ -132,6 +161,29 @@ static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
 	return domain << 16 | bdf;
 }
 
+bool pci_liveupdate_inherit_buses(void)
+{
+	return atomic_read(&inherit_buses);
+}
+
+static void pci_set_liveupdate_inherit_buses(bool enable)
+{
+	/* Ensure updates to inherit_buses do not race with rescans */
+	pci_lock_rescan_remove();
+
+	/*
+	 * Increment/decrement instead of setting directly to true/false so that
+	 * pci_liveupdate_inherit_buses() returns true if any device is outgoing
+	 * preserved or incoming preserved.
+	 */
+	if (enable)
+		atomic_inc(&inherit_buses);
+	else
+		atomic_dec(&inherit_buses);
+
+	pci_unlock_rescan_remove();
+}
+
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_outgoing *outgoing;
@@ -171,6 +223,8 @@ static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 
 	args->obj = outgoing;
 	args->data = virt_to_phys(outgoing->ser);
+
+	pci_set_liveupdate_inherit_buses(true);
 	return 0;
 }
 
@@ -178,6 +232,8 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_outgoing *outgoing = args->obj;
 
+	pci_set_liveupdate_inherit_buses(false);
+
 	WARN_ON_ONCE(outgoing->ser->nr_devices);
 	kho_unpreserve_free(outgoing->ser);
 	kfree(outgoing);
@@ -215,6 +271,8 @@ static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 	}
 
 	args->obj = incoming;
+
+	pci_set_liveupdate_inherit_buses(true);
 	return 0;
 }
 
@@ -222,6 +280,8 @@ static void pci_flb_finish(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_incoming *incoming = args->obj;
 
+	pci_set_liveupdate_inherit_buses(false);
+
 	xa_destroy(&incoming->xa);
 	kho_restore_free(incoming->ser);
 	kfree(incoming);
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index eaaa3559fd77..0bd3e961d5c5 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_PCI_LIVEUPDATE
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+bool pci_liveupdate_inherit_buses(void);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -21,6 +22,11 @@ static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
+
+static inline bool pci_liveupdate_inherit_buses(void)
+{
+	return false;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b5fdc5017f92..08ea9324647b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1375,6 +1375,14 @@ bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
 	return true;
 }
 
+static bool pci_should_assign_new_buses(void)
+{
+	if (pci_liveupdate_inherit_buses())
+		return false;
+
+	return pcibios_assign_all_busses();
+}
+
 /*
  * pci_scan_bridge_extend() - Scan buses behind a bridge
  * @bus: Parent bus the bridge is on
@@ -1402,6 +1410,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 				  int max, unsigned int available_buses,
 				  int pass)
 {
+	const bool assign_new_buses = pci_should_assign_new_buses();
 	struct pci_bus *child;
 	u32 buses;
 	u16 bctl;
@@ -1454,8 +1463,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		goto out;
 	}
 
-	if ((secondary || subordinate) &&
-	    !pcibios_assign_all_busses() && !broken) {
+	if ((secondary || subordinate) && !assign_new_buses && !broken) {
 		unsigned int cmax, buses;
 
 		/*
@@ -1497,8 +1505,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		 * do in the second pass.
 		 */
 		if (!pass) {
-			if (pcibios_assign_all_busses() || broken)
-
+			if (assign_new_buses || broken)
 				/*
 				 * Temporarily disable forwarding of the
 				 * configuration cycles on all bridges in
@@ -1512,6 +1519,12 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 			goto out;
 		}
 
+		if (pci_liveupdate_inherit_buses()) {
+			pci_err(dev, "Cannot reconfigure bridge during Live Update!\n");
+			pci_err(dev, "Downstream devices will not be enumerated!\n");
+			goto out;
+		}
+
 		/* Clear errors */
 		pci_write_config_word(dev, PCI_STATUS, 0xffff);
 
-- 
2.54.0.563.g4f69b47b94-goog


