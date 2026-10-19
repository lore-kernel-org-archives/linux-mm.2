Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3F4606A329
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=QClAln6V
Received: by kanga.kvack.org (Postfix)
	id A208D6B039D; Mon, 19 Oct 2026 17:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F97A6B039E; Mon, 19 Oct 2026 17:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E626B039F; Mon, 19 Oct 2026 17:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 603976B039D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:31:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8FA480578
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:32 +0000 (UTC)
X-FDA: 85340672424.18.0D029CF
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 22AC340008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QClAln6V;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3MYzWaggKCAIfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3MYzWaggKCAIfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27szfxESPIZuT7PVf91SFMXZ+5PrRuOJzgCi66FtF/Q=;
	b=cRz30TKYPA5E5F4yOn0SK0JxCUeeSAtzBzZz2B7zEewEOyakhzP3U47YRGkGgAvPbomLBi
	1dYSkU7QLF1AsL0F2YDhflQ3kr9nao1y78Ja/LsDRKqBQsU/ZVt4iCdm21r4nId7yO1Jez
	yu3vtILc5PIFhTD94jEDDIC7ll3ItCs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QClAln6V;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3MYzWaggKCAIfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3MYzWaggKCAIfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445491;
	b=im1dzmUQPh99Mr1N+7dDu3XI4/GbJKG53IWDxtbeBhTF8uFURUYy4n4rfO7JoELyPs9u9y
	fGxfO/jrms60HtE+EEIUmE09cV32DFqUpCO4KelDyXKeWu3TiTiXL33iCQTRGmADbA98yZ
	ctrfG2lx8jWZ2VhoIMN7Nfq/RUljOwc=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3aaf955db5fso4206996a91.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792445490; x=1793050290; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=27szfxESPIZuT7PVf91SFMXZ+5PrRuOJzgCi66FtF/Q=;
        b=QClAln6VZccY/MZFYyVA/8SLMHpCnL/2d8vnGUmtSyfYSej2i13BltP8cJHhu0UFWy
         SQnZjOo+aippJKuHcYiEvetVAjRFXERZTqOauSsOZ6DM3xo2tN6MkBMrikkAGGN0bRjn
         odlSS34/BauasZ4vfLWqNN8GESoO15LaPIYVGTTxWS9ECwDN2YoiBJ3My04c1Dx0id82
         3ZHJv+knTTEb7s/pe07a/GrMhEZr4L397zbHNVCsPs+vheiuI5hVoHo3j1dwoaAMHRIv
         ZuVTWjTKO4gVaL5xXBQ02xBxglZIbQaDbFTVmk3iaJxpCVs6pyeyE3cBRnvzBpE3wCKG
         73pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445490; x=1793050290;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=27szfxESPIZuT7PVf91SFMXZ+5PrRuOJzgCi66FtF/Q=;
        b=wYfkZWTmDRq8Sa9pdJTHG5cLXFUBpWgcezcxYPg53xOvSm+BBKTbwsfKSnxGHHDoN2
         Aie60U3kqSjBq9rTi5rH4+3QOOdBIrDizDpxaKSwAGLSMZRShI3gu+Yv2nwO72sYo/eO
         nVZCfaEt1exHFMAoSAie6+JdgEN/f1miPmeeMrUcg1oa+2qNs1B4PQ2dp5id9qXIIjYa
         xESRw+cUGpl5T6qlS/RQY02SKx8TvCbBZiKRZHgnU+ANwtVO7kW/iSIJWvN5n3U7pVMS
         Ru3lDAksjHB+y/bDUpbMH3mvBikTZ9ilTvbK+PgRRGpTPsxmVSjNnh7JvMHeTd3qihKD
         Vjig==
X-Forwarded-Encrypted: i=1; AKwUvBzG3DQA9amCwulZ4ccUoIY8sTZ3SF6vUs4qC0tArzFrUIkozHnXMwdntvq40yGkVCYR9QlZ/X/52w==@kvack.org
X-Gm-Message-State: AFq9FYJp5qghDPD2x5YDfJHyREkJQxGJPvRZeP7CssnRkuth2UdWJet8
	Miu1BLXouomTXnFA1EMB6Jq4ZZYTW3DqXfxsGNCMd4eaF4kpMznG/CduvwLFCRzrhAsjkF6dV14
	dXneagSDpme0hPQ==
X-Received: from pgbm24-n2.prod.google.com ([2002:a05:6a02:6198:20b0:cc7:c2bc:cc73])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d06:b0:3a6:e159:a233 with SMTP id 98e67ed59e1d1-3aceefae03fmr7921990a91.43.1792445489657;
 Mon, 19 Oct 2026 14:31:29 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:30:54 +0000
In-Reply-To: <20261019213054.3157159-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261019213054.3157159-11-dmatlack@google.com>
Subject: [PATCH 10/10] PCI: liveupdate: Avoid enabling INTx on incoming devices
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	David Matlack <dmatlack@google.com>, 
	"=?UTF-8?q?Ilpo=20J=C3=A4rvinen?=" <ilpo.jarvinen@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 22AC340008
X-Stat-Signature: rfewz4poq95i4gc3ymp1m9j6to34uks3
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792445490-116431
X-HE-Meta: U2FsdGVkX1+F/bJRYPc+LL0Jrnftv1rm4QoQpmoYix1Mnnz5IPUAQReEyT+/zgPpAEvEsCOoFKNTO8fHMQ0R3QgH3ZNuFrZdeB4MwsnkrEhyFOVWtmot/NEPYkZzlCTOXB+qFCfxAOzS5SiV2C5/won1AymeqLW4L+Q4kK8O44Z08trEhrwc4DGTJUTGe1TZ2vfSys6gyQfx67KBA0irwVQuX+g0m8FkKFzn6Yvr3GtWGnXg2rqaECMQhlgbB/YExX8BrjYw37m7J2aea1DZ6/Q0uG1pOWn1AH5csJjNLBySq/YHB7kAUqaZ8ZJJE+jbk+YSIlLyqcbFDzMtvuNdogIC9VbNf2ymtpLOckrWX2U229lxq5Lx6igvYXYgnWa8xd/Ep3IZhO9bcwPZPU0hDblNrQbHRdfGUUidB187cwDgsEhs9JAiGp0NdlMGF5OATocE8Xbh3nSuFFoX3oIwByJrgqwLxUK0H7BjNiZ5G0eU5hLf24v570Mze+F4f1cRa1plgFvC26TkHoeevSB3rE+djupDpGHvVyot75vE08ht0DxM0jPLOmiucQxY31i7f1UMOefFeuOqLcDnpGEozyhRVhr/eVp4URsNsynUUjw65sO0qrYcUhHJwW8nDKH0pSL6ksR4zAPE8KVxRvMyLud35XrSKEwRUyD87JEAGR7yKWLn9NNr4NG84zFqb1Oog03cZQ57t9xuxx57W4q2A4k2x7g5oCyKjWecjZTGOAPq5bKcJjgMQuJNVXvStE0mrIsOEMpMOeeuNJnQFUqH+i1C2HE8NMU4P6c+P5e+bw+q6mYIpOHpNLEaEXqE7mlcEHONFEYEIgdRFFDuMcLFZ7gE7kYTCCziL5EgHw4MirEwVTsztZ67OdkXb86pdO8P8ySJPGQgaLKey3ms45Alq5UNPRBjTizlW7Nfw4yrWY0MkALYmivwHOa1LmUDM4rWGORcsey/wc1zao9B59U
 M2k/N3St
 ci9kojbsKvwoEWPS/jrrxhRJP3ZTMk2Qj7lKOVxere885GDghjQUPrmazXhb8LptXua90kQBOMHJfQUp1XCqgz00PJEHDUoXEDlJDiiNYBZHYJc6s86hIBwWk4CR9fqvO+Sdt4WMx2T9Ef6izf1QCrJF/ClkTEBHGbzaWNQXZZkDnr4+lvyuk+/aZh8skmYIbRmDLANERKclxf+qcltes1NiHC7N+PUqZgfEG1B1gOxGJ3coq3sZIYPVJxQxkBfjRa2AIuWDzp5YYP0VSBBCy90TpEGpUowuJyaoNZD75MiOtt4EL3odta8Y/vCzoa7imATvaBS+Nnf6jxHiQsAti1M4tLjm/lA6R6RxOc3qRTPHwjMsBt1caHcW0SaMoGvobpeEZRxbNsvxHrRKzOBIJSFgM3CVqGSsKbLD7CNzLjLgHpjLZqyCFLl1WgDKQnhDL9Eo3GkD3ZpNpS9Fe7deiBepI5vLb2cNbZ0Sohna3Jv4/0DiZu0vRDmAarGNAEnJelYyuxf/7IxuTuyzZj92fAbcv4Qd6gdas+z4n9D5KErKCSmzIQ5HaKutb/xUim6RIvFmGbBKPiKsQToPjR1KtkkvrpZu9DhhoP5UW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Avoid clearing PCI_COMMAND_INTX_DISABLE on incoming preserved devices.
Pass whether INTx masking is broken on each preserved device to the
next kernel instead of probing it, and skip clearing
PCI_COMMAND_INTX_DISABLE in do_pci_enable_device() for incoming
devices.

Clearing PCI_COMMAND_INTX_DISABLE enables INTx on the device, even if
only temporarily. pci_intx_mask_broken() probes whether INTx masking
works by toggling PCI_COMMAND_INTX_DISABLE during enumeration, and
do_pci_enable_device() clears it when a device that is not using MSI or
MSI-X is enabled. A preserved device may assert INTx at any point
during the Live Update, before its driver in the next kernel has set up
interrupt handling, so enabling INTx could result in interrupts that
no handler claims, on a line that may be shared with other devices.

Pass the result of probing as a new bit in the probed results in
struct pci_dev_ser, PCI_DEV_SER_PROBED_BROKEN_INTX_MASKING, which
reflects struct pci_dev::broken_intx_masking. If the previous kernel
did not pass it, fall back to probing INTx masking.

Drivers bound to incoming devices are responsible for enabling INTx once
they are ready to handle it. pci_alloc_irq_vectors() already does so
with pci_intx() when it falls back to INTx, and vfio-pci clears
PCI_COMMAND_INTX_DISABLE itself in vfio_pci_core_enable().

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c    | 37 ++++++++++++++++++++++++++++++++++++-
 drivers/pci/liveupdate.h    |  6 ++++++
 drivers/pci/pci.c           |  8 ++++++++
 drivers/pci/probe.c         | 10 ++++++++++
 include/linux/kho/abi/pci.h |  3 +++
 5 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index ac4525568818..8a74762c3f7d 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -216,6 +216,11 @@
  *    bridge implements), since that would disrupt memory transactions
  *    targeting the device or devices below it. Instead, the previous kernel
  *    passes the results of probing in struct pci_dev_ser.
+ *
+ *  * The PCI core does not enable INTx (i.e. clear PCI_COMMAND_INTX_DISABLE)
+ *    on incoming preserved devices, neither while probing whether INTx masking
+ *    works nor when the device is enabled, since the device could then raise
+ *    interrupts before its driver is ready to handle them.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -650,7 +655,11 @@ static void pci_liveupdate_save_bar_masks(struct pci_dev *dev,
 static void pci_liveupdate_preserve_probed(struct pci_dev *dev,
 					   struct pci_dev_ser *dev_ser)
 {
-	u64 supported = 0, probed = 0;
+	u64 supported = PCI_DEV_SER_PROBED_BROKEN_INTX_MASKING;
+	u64 probed = 0;
+
+	if (dev->broken_intx_masking)
+		probed |= PCI_DEV_SER_PROBED_BROKEN_INTX_MASKING;
 
 	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
 		supported |= PCI_DEV_SER_PROBED_WINDOWS;
@@ -1213,6 +1222,32 @@ int pci_liveupdate_read_bridge_windows(struct pci_dev *bridge)
 	return 0;
 }
 
+/**
+ * pci_liveupdate_intx_mask_broken() - Get whether INTx masking is broken on an
+ *                                     incoming device
+ * @dev: The PCI device
+ *
+ * Get whether INTx masking is broken on @dev as determined by the previous
+ * kernel, so that INTx masking does not need to be probed.
+ *
+ * Return: 1 if INTx masking is broken, 0 if it is not, or -ENODATA if @dev is
+ * not incoming-preserved or the previous kernel did not pass whether INTx
+ * masking is broken on @dev.
+ */
+int pci_liveupdate_intx_mask_broken(struct pci_dev *dev)
+{
+	u64 probed;
+
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+
+	if (!pci_liveupdate_read_probed(dev,
+					PCI_DEV_SER_PROBED_BROKEN_INTX_MASKING,
+					&probed))
+		return -ENODATA;
+
+	return !!probed;
+}
+
 /*
  * Check if the windows of @bridge have been read from hardware. Outside of x86
  * that does not happen during scanning.
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 98d23e217308..7f86cc85deee 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -22,6 +22,7 @@ bool pci_liveupdate_is_outgoing(struct pci_dev *dev);
 int pci_liveupdate_read_bar_masks(struct pci_dev *dev, unsigned int nr_bars,
 				  u32 *bar_masks, u32 *rom_mask);
 int pci_liveupdate_read_bridge_windows(struct pci_dev *bridge);
+int pci_liveupdate_intx_mask_broken(struct pci_dev *dev);
 void pci_liveupdate_claim_bus_resources(struct pci_bus *bus);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
@@ -74,6 +75,11 @@ static inline int pci_liveupdate_read_bridge_windows(struct pci_dev *bridge)
 	return -EINVAL;
 }
 
+static inline int pci_liveupdate_intx_mask_broken(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+
 static inline void pci_liveupdate_claim_bus_resources(struct pci_bus *bus)
 {
 }
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 853c84a2c782..43af72d1e5c9 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2184,6 +2184,14 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 	if (dev->msi_enabled || dev->msix_enabled)
 		return 0;
 
+	/*
+	 * Leave INTx disabled on devices preserved across Live Update, since
+	 * the device could raise interrupts before its driver is ready. It is
+	 * up to the driver to enable INTx once it is ready.
+	 */
+	if (pci_liveupdate_is_incoming(dev))
+		return 0;
+
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (pin) {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a53d0077a08b..badce31b34f8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1976,6 +1976,16 @@ static u8 pci_hdr_type(struct pci_dev *dev)
 static int pci_intx_mask_broken(struct pci_dev *dev)
 {
 	u16 orig, toggle, new;
+	int ret;
+
+	/*
+	 * Toggling PCI_COMMAND_INTX_DISABLE could let a device preserved across
+	 * Live Update raise interrupts before its driver is ready, so use the
+	 * result determined by the previous kernel for those devices.
+	 */
+	ret = pci_liveupdate_intx_mask_broken(dev);
+	if (ret >= 0)
+		return ret;
 
 	pci_read_config_word(dev, PCI_COMMAND, &orig);
 	toggle = orig ^ PCI_COMMAND_INTX_DISABLE;
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index 84a1bf71eeca..badcf2f01be7 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -95,10 +95,13 @@ struct pci_dev_ser {
  *    window.
  *  * PCI_DEV_SER_PROBED_PREF_64_WINDOW: The bridge's prefetchable memory
  *    window is 64-bit.
+ *  * PCI_DEV_SER_PROBED_BROKEN_INTX_MASKING: INTx masking cannot be used on
+ *    the device, i.e. struct pci_dev::broken_intx_masking is set.
  */
 #define PCI_DEV_SER_PROBED_IO_WINDOW		BIT_ULL(0)
 #define PCI_DEV_SER_PROBED_PREF_WINDOW		BIT_ULL(1)
 #define PCI_DEV_SER_PROBED_PREF_64_WINDOW	BIT_ULL(2)
+#define PCI_DEV_SER_PROBED_BROKEN_INTX_MASKING	BIT_ULL(3)
 
 /*
  * The size of struct pci_dev_ser when this ABI was introduced. Since fields
-- 
2.56.0.212.g129ede20d9-goog


