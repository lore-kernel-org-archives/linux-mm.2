Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1256DCD5BB9
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453D06B009E; Fri, 22 May 2026 16:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E266B009F; Fri, 22 May 2026 16:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0906B00A0; Fri, 22 May 2026 16:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0026B009E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAB64120759
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:19 +0000 (UTC)
X-FDA: 84796183038.27.FBB7B3D
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 16E2F4000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uBiastW5;
	spf=pass (imf04.hostedemail.com: domain of 3cLsQaggKCIEirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3cLsQaggKCIEirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35prD7a6muthxJ5uOKWSGr8dWxpX6CiZ2+eQPVuLFrU=;
	b=IC+1K0jlwVNjreMorjQR8ukajrNiQ2uZNN/P9sljJVavt7diQ8y2FBmBHEiuJQK7LUEUMd
	h62AXIHyWtmaI+8hqKzy6aAGifmeatNt0Xn1BBKb/9DfKAkp3pfNjvels+FvvL5TgiYq3X
	29IaYodJORjFkaDlDNzuKds2w0sSykA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uBiastW5;
	spf=pass (imf04.hostedemail.com: domain of 3cLsQaggKCIEirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3cLsQaggKCIEirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481458; a=rsa-sha256;
	cv=none;
	b=gghYVjq3DX7ko7xM3bnrDYLp0mf28KRK5/ipAzHJUK/nBPBuqv4GDXIw9FIC+uVTobDA25
	d3B3zxfJ6em+QR4IwRXGNwfoNZMy+AtBfLxtwEl1t6BG+uuJRa4j55kElMIBrm9DtPhj//
	XYUGQzpwnz3hJ0TJ0N21r0t3YFxZQNI=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-368b15eeb3bso15349741a91.2
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481457; x=1780086257; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=35prD7a6muthxJ5uOKWSGr8dWxpX6CiZ2+eQPVuLFrU=;
        b=uBiastW51Gn0Y2nyz01h5nBWQAoWvm+chQ9bB+HV6ZwFr+ZYwamTDI0RD7AOJojuwg
         JOifvJVQA7WF8oDW1cpEH7selpp9AcV1HPwY335t9TCLIwgcbgc4b3c5HTVyZ51Xo/OP
         PJMOwyKBpVgNFqLhwD8X1s+qWAvxoeo8g50sT4Gi4vlKie9EUGgpU8HwQ9s/SiMEQfYj
         4GdoDiq6/AyW0ZeL7+Hr0VxOUR8eEN0NFQD0rXT5TOke5iYy4cprl2w8Qx131Yzv6KoW
         4D2GCNNA1ykZitNm5X1lQvYp4/tbGavlbQPsDxZe7SZ2IyzgY+wsbOXbg+QOQ7/pLdVb
         VrnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481457; x=1780086257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=35prD7a6muthxJ5uOKWSGr8dWxpX6CiZ2+eQPVuLFrU=;
        b=nufZLNq6SzwLTn58vHf4Anj8eBc78lBnO05rTc3Gr4sfHxuGMxtfA9wGGCs/jmNfO1
         KWxk7sOwtVnXREtH7T//StZQl3dBWsqhm6dW5bfWd2+Q1dO1SwA7uZTBn3tjYpkKbCeZ
         y313aK/sfDxb/nVJPSJiAZgytsdmY1FG78LnAn/YYjPnVIAvYkP1/sOq/hPjzOOsZeaC
         peXxzYO/jU5hQAzokIroffy/4i4/eMj8ckmXrBXiori8EVWxyvUqgfW5PEx2LUxIvSrZ
         plRG2pE2A4c1Hds2MX9PAkQqabJdZa5rlxTDN0aqA8f6bt0GZ9f6qUUvMfVnxNjcpGKt
         GdEA==
X-Forwarded-Encrypted: i=1; AFNElJ/h2HfFUwoYmZpsSZ1vIRxBuhn5grkvRYmfYuoIfL0FGYTky0f/esUcyEjlSd+H8CKpBXnPInzrOA==@kvack.org
X-Gm-Message-State: AOJu0YwcZQ70Kn5qa9dThY/XuVQJEbFEgti8HKpkZt6JCm32mdFatU3l
	Wz/FC3R5wrtK8M8Lp9lbU0Ls6C3BrB7zyVeYzOL12Npz3gr8R/KJlPeU6WLVKs4+OyQ49smHSpQ
	yrE4PWmjDuBtSsA==
X-Received: from pgbcb21.prod.google.com ([2002:a05:6a02:715:b0:c81:2646:5294])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5746:b0:364:78a5:8d40 with SMTP id 98e67ed59e1d1-36a67639d6dmr5223710a91.20.1779481456386;
 Fri, 22 May 2026 13:24:16 -0700 (PDT)
Date: Fri, 22 May 2026 20:24:03 +0000
In-Reply-To: <20260522202410.3104264-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-6-dmatlack@google.com>
Subject: [PATCH v6 05/12] PCI: liveupdate: Keep bus numbers constant during
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
X-Rspamd-Queue-Id: 16E2F4000E
X-Stat-Signature: eurx8eashik9kw39i8a59y5pf8m7bxmq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779481457-232962
X-HE-Meta: U2FsdGVkX19oYOs3ztzkAiQW9DJ+hNrLTAv+BtbKLb/nZZ5dZTdUYmWKarEQRKwJAmnGeIrE1dPjAYtjtqtRl3xaO7pX/BChE2e/zR9RlUm4kPew/gHT9857DsLseUyz6sWMfTwGKTGARhbe+MRY5aWKRzS14ZN3T6neoZaoW5EVQ/Fhza8OR0cFlv2qXdg6xFPSS0+2vchWOLMP2L/7fBDbX1sS9rQhAzxamRTHbULLsvqVNelqJvNHh2EXq8kiLLESX8k9JLthwtJngOolZX2AA+Q9KL9BRvdZB+9mJNXAqOs4uSZ75259nRlPjobFWGRRDz4JP9rtsU1rcsvxOpefUR4dXk0MIOxpsr2Fix7LMqbXdHuoiuW0g1nu6PBeyUkHEB3yvk8fyf1xoDjFW1o/iP+XehEbANl7lDNxHMXlf9oxCkxhw74rtViHrVq+/5OjwGu0OvIGgOU/ThnyfIcF/kMgWxA4n8XYsLAKsYyrWv8gOm5nwv6IHE0m9qZJNa5i23/gl7umje83bXYfcqFoFvvoVLwC4ql3wVyInuhopcjWcJQftULG6Ad6JjVI+Q7a9du+pKC3Lx2zx48sfMULyotgTQcRhdaR/TUmzgAd1grg3e3Ula+4jdfEf5i4Um4YN7p+3PeK8q38JG75KWmZnjKDxynU2k+wc4TOc5mzQvLYAb2jdv2NaZ4vCpWlbxEvrgbDPZiN3Y26ZdaGzE/TsfAtCUaBnGHuqB8GDp5KXsjlBA3bd8Yt+AZAVXztLLFpSkSpsYCJMF+FOX2ij5C0jd+y0x80hsYvF9A3UeG3QI7A/gq2uDurnrPvzmzmRCdPMZJFCm4xZ8Ho0fJ+qQfRKxKzwixtlkBtSMifTmoKBH+Qu4ypDlWixJ35hA8OXFKl+CLHaDegZoi1+pH+skpHwNBT/JLjevJIzll80iYGIq4gf9gZCILgxqU+p27GerSdb4IYYVNqm2NkMBt
 2CuVi/uR
 SFNSaKVPvZUwTYjCMR0XmN63A1deKBU04s1iaUN0whTqkFJ+nrvjSbcWGn0l+iYIJkyTLsdFOWk+a9KtfdYtI9sfvWxqtAKdQpnefTe++JdSWiQBnzuhZTwlR++OHesMe3QeVHb4M9+HxnZcpdXNBJD7wFYtO7Y6tWYa0u/Yuu9/Ss3jTYEVH+MCrrdLJ6PfAOl9x4ivJVvAbLv06OSNne5QXLvIfL/iY4T4ngNd7Q7Q+fuH7Owv/lcXEQD4lAYFun6NQla8nsq0vLmWRNViqO4Fm/zcs+cAevX2wQilYQiAE36qWyvzsni2pq1y2C0W1TZ4pLzS4ydFFFkT+2Y0R1vJIaYZoEx3aJeQrBY5YouI92BE/T60o/Gh3mAtfeVu1S6MVMM2wLUk8PdpOTrg1YP6b4MSTO8vV1wSWm3GNzkbbfs2W4V1JC3Hu3x5cK/Xf+zGmvbe5dt5jpAd5Ga2o/o3w1A8R/HR0kN9Ep+HSAL1+76CYtxaq+4UpTYtKRiOvhUTfo03quCe0DwuqpXu+ouU7CZ2ut0GG2VVwUBs+7Bb++5DTVzwdosGoDQ==
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
to enumerate devices below it until the Live Update is finished. This is
a safety measure to prevent topology conflicts.

Require that CONFIG_CARDBUS is not enabled to enable
CONFIG_PCI_LIVEUPDATE since inheriting bus numbers on PCI-to-CardBus
bridges requires additional work but is not a priority at the moment.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  6 +-
 drivers/pci/Kconfig                           |  2 +-
 drivers/pci/liveupdate.c                      | 83 ++++++++++++++++++-
 drivers/pci/liveupdate.h                      | 14 ++++
 drivers/pci/probe.c                           | 17 +++-
 include/linux/pci_liveupdate.h                |  4 +
 6 files changed, 119 insertions(+), 7 deletions(-)

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
index e68ae5c172d4..a597fede1b3b 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -330,7 +330,7 @@ config VGA_ARB_MAX_GPUS
 
 config PCI_LIVEUPDATE
 	bool "PCI Live Update Support"
-	depends on PCI && LIVEUPDATE && 64BIT
+	depends on PCI && LIVEUPDATE && 64BIT && !CARDBUS
 	help
 	  Enable PCI core support for preserving PCI devices across Live
 	  Update. This, in combination with support in a device's driver,
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 4f2ec6ffdd16..2421bc218916 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -86,6 +86,21 @@
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
+ * while there are preserved devices, its secondary and subordinate bus numbers
+ * will be cleared and devices below it will not be enumerated.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -103,7 +118,7 @@
 /**
  * struct pci_liveupdate_global - Global state for PCI Live Update support
  * @rwsem: Reader/writer semaphore used to protect the incoming and outgoing
- *         FLBs, and the references to them in struct pci_dev.
+ *         FLBs and references to them in struct pci_dev.
  */
 struct pci_liveupdate_global {
 	struct rw_semaphore rwsem;
@@ -396,6 +411,72 @@ static void pci_liveupdate_flb_put_incoming(void)
 	liveupdate_flb_put_incoming(&pci_liveupdate_flb);
 }
 
+bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus, struct pci_dev *dev,
+				      int pass)
+{
+	struct pci_dev *parent = bus->self;
+
+	/*
+	 * On the second pass, reuse the value that was set on the first pass
+	 * so that the passes are consistent with one another.
+	 */
+	if (pass)
+		return dev->liveupdate.inherit_buses;
+
+	/*
+	 * If the parent bridge is being forced to inherit its bus numbers
+	 * during this scan then this bridge must as well, otherwise the PCI
+	 * core could expand this bridge's reservation beyond its parent (which
+	 * cannot expand).
+	 */
+	if (parent && parent->liveupdate.inherit_buses) {
+		dev->liveupdate.inherit_buses = true;
+		goto out;
+	}
+
+	/*
+	 * Otherwise, if there are any incoming preserved devices, force the
+	 * bus numbers to be inherited to avoid changing the bus numbers
+	 * assigned to those devices during enumeration.
+	 *
+	 * To keep things simple, inherit bus numbers on all bridges if any PCI
+	 * devices are incoming, to ensure that no bridge's reservation is
+	 * expanded to overlap with a preserved device downstream of a different
+	 * bridge.
+	 */
+	scoped_guard(rwsem_read, &pci_liveupdate.rwsem) {
+		struct pci_flb_incoming *incoming;
+
+		incoming = pci_liveupdate_flb_get_incoming();
+		if (!incoming) {
+			dev->liveupdate.inherit_buses = false;
+			goto out;
+		}
+
+		/*
+		 * It is safe to sample incoming->ser->nr_devices and then
+		 * drop the rwsem since nr_devices will only decrease. Thus the
+		 * only "race" is that the current scan will be overly
+		 * conservative and force bus inheritance.
+		 */
+		dev->liveupdate.inherit_buses = incoming->ser->nr_devices;
+		pci_liveupdate_flb_put_incoming();
+	}
+
+out:
+	return dev->liveupdate.inherit_buses;
+}
+
+void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass)
+{
+	/*
+	 * Clear inherit_buses after the second pass so it can be re-evaluated
+	 * on future scans.
+	 */
+	if (pass)
+		dev->liveupdate.inherit_buses = false;
+}
+
 void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
 	struct pci_flb_incoming *incoming;
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index eaaa3559fd77..c763255a8de4 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -13,6 +13,9 @@
 #ifdef CONFIG_PCI_LIVEUPDATE
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus, struct pci_dev *dev,
+				      int pass);
+void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -21,6 +24,17 @@ static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
+
+static inline bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus,
+						    struct pci_dev *dev,
+						    int pass)
+{
+	return false;
+}
+
+static inline void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass)
+{
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2e2be8af6976..19965bfd347d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1402,6 +1402,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 				  int max, unsigned int available_buses,
 				  int pass)
 {
+	bool liveupdate, assign_new_buses = pcibios_assign_all_busses();
 	struct pci_bus *child;
 	u32 buses;
 	u16 bctl;
@@ -1411,6 +1412,10 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 	u8 fixed_sec, fixed_sub;
 	int next_busnr;
 
+	liveupdate = pci_liveupdate_scan_bridge_begin(bus, dev, pass);
+	if (liveupdate)
+		assign_new_buses = false;
+
 	/*
 	 * Make sure the bridge is powered on to be able to access config
 	 * space of devices below it.
@@ -1454,8 +1459,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		goto out;
 	}
 
-	if ((secondary || subordinate) &&
-	    !pcibios_assign_all_busses() && !broken) {
+	if ((secondary || subordinate) && !assign_new_buses && !broken) {
 		unsigned int cmax, buses;
 
 		/*
@@ -1497,8 +1501,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		 * do in the second pass.
 		 */
 		if (!pass) {
-			if (pcibios_assign_all_busses() || broken)
-
+			if (assign_new_buses || broken)
 				/*
 				 * Temporarily disable forwarding of the
 				 * configuration cycles on all bridges in
@@ -1512,6 +1515,11 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 			goto out;
 		}
 
+		if (liveupdate) {
+			pci_err(dev, "Cannot reconfigure bridge during Live Update, skipping\n");
+			goto out;
+		}
+
 		/* Clear errors */
 		pci_write_config_word(dev, PCI_STATUS, 0xffff);
 
@@ -1572,6 +1580,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, bctl);
 
 	pm_runtime_put(&dev->dev);
+	pci_liveupdate_scan_bridge_end(dev, pass);
 
 	return max;
 }
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index cfdc3d62ec02..2be98819e313 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -17,10 +17,14 @@
  * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
  * @outgoing: State preserved for the next kernel.
  * @incoming: State preserved by the previous kernel.
+ * @inherit_buses: True if the PCI core should inherit the secondary and
+ *                 subordinate bus numbers assigned to this device due to
+ *                 an ongoing Live Update.
  */
 struct pci_liveupdate {
 	struct pci_dev_ser *outgoing;
 	struct pci_dev_ser *incoming;
+	bool inherit_buses;
 };
 
 struct pci_dev;
-- 
2.54.0.746.g67dd491aae-goog


