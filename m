Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E1E606A331
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=UAlYl0mk
Received: by kanga.kvack.org (Postfix)
	id 1E3346B0390; Mon, 19 Oct 2026 17:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB866B0392; Mon, 19 Oct 2026 17:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0348F6B0393; Mon, 19 Oct 2026 17:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3F706B0390
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:31:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C41F1A0890
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:28 +0000 (UTC)
X-FDA: 85340672256.12.B186820
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4F2EE4000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UAlYl0mk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3LIzWaggKCPsgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3LIzWaggKCPsgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ob0OqST4cKlshaBFbfeFqwou5GMUNnLOz8/rLCUeWMM=;
	b=sHfRdR7MSfCVH8DSXyRP7D39kr8/Cor0AMu51PDZKmMjLauwU6qVDksU4QfUlhUsPEaN6D
	gQ7bk349Il5q9y0TO+tgMxYKV7z7jK0p1cAa5zAecfnbr9UMyAv7CCttPNgc/mDUiocWnM
	CombYn+WMRffkD99yOgJYvF1FVTT7Pk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UAlYl0mk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3LIzWaggKCPsgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3LIzWaggKCPsgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445486;
	b=51sXxKmaMThw3p56Bsh/cYJSpjN93ydQvq0FO7i594W8o4syp2BZQG9de/NDpCUVNUUeFr
	OdZyLa1YYcG0NIoHAI5i9rFb0/bg5YxInB2n8lYdPBtd29Xnj8eFR4M13B+r0Z7Po8TcX/
	ig3uDKPYI7plvGo9ukbqbd/Jrsvzfdg=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39512608fb1so4997512a91.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792445485; x=1793050285; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ob0OqST4cKlshaBFbfeFqwou5GMUNnLOz8/rLCUeWMM=;
        b=UAlYl0mkKsH4Z2QpjLKsMGWnrTLdJybo8IoECkSOygmpuB2QUjZe9mjkjh5IGlCQUm
         4FK+uslLr/vOaZSR/8tUqGGbi8LlhiiwTIWil88vk5G9aZo8NWaw2jbBmSxCTxSWZAaP
         JV2boFxOAavJ9uzD/MJMPKnGFjy/BkJESdbySTF5VjuYFrC7hMOkdz0QK4QyOdMTo2Qb
         kHz1gwBPCeJJ44NUF0aWR8+qJo9k3EjryYn88hzvuQ4KzXJkly/0DdlNi0r86+4AH6o+
         o+4ScsJSIgIpcSq+UtmepzLfMI0WeiXTZBwjfjU19X0Iv+YxDCntXLgJ2lxi6xRb/dum
         FWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445485; x=1793050285;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ob0OqST4cKlshaBFbfeFqwou5GMUNnLOz8/rLCUeWMM=;
        b=gGj7mJpLNP+ybG1gp3PQK8/0yrjJF/fH0iqUWD9Z39uumrpCheC7tA+A2kG7yroKw/
         cx/gQNhdSCclt7xuHNyW8yv5LEEP9dAS0IaHcIws/IxPpQbuf06+ySl/W/2WUaoNkqYF
         Nv3Lbxj8FUBt6GOcye0ntPUGQBjR5AmbIrPbAMEsacoXw+DlZx3z/e7Z4h/k1jUxK03P
         iNi5o+Dm5W8JS/mpcPlEtT8UuNm/pkKFu74XJQKkDVQO8QVMy+P+BZ4LCLbRIvYzjfEf
         QwA84q6BpwzItapJZwZ08JVujVObGgLLnXxN1b3f4IcBE0/OeWFLyhFphY5s1NbCz828
         LRJg==
X-Forwarded-Encrypted: i=1; AKwUvBySdbIJFXcCIKuEue3FcxApOfrh4CfqVCtepP3Oavsw/qjD2yBfXRVakmtSAku+OHR++w3yGoLTyw==@kvack.org
X-Gm-Message-State: AFq9FYJfH+FnCUjRMsIOej+y/HiDhFOhrFIBTlqUbt9WEAm8dzg1JFfJ
	vfy7G9OidmD6JZAe6q9Xs/QTGyV2KoijbD5y/YLIVvdIFeqHcRiKyC9OAlcycPvbX8TclVLkgbL
	XohcESFShLwA/ig==
X-Received: from plxe4.prod.google.com ([2002:a17:902:ef44:b0:2e9:73da:58d6])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2b48:b0:3ac:9f00:3bc7 with SMTP id 98e67ed59e1d1-3acef0c88a8mr8307573a91.33.1792445484749;
 Mon, 19 Oct 2026 14:31:24 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:30:48 +0000
In-Reply-To: <20261019213054.3157159-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261019213054.3157159-5-dmatlack@google.com>
Subject: [PATCH 04/10] PCI: liveupdate: Avoid probing windows of incoming bridges
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
X-Rspamd-Queue-Id: 4F2EE4000A
X-Stat-Signature: wy8xzjpuh5smduez5r4esuq33urtmwxd
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792445486-947108
X-HE-Meta: U2FsdGVkX1/phjHHMeIIJuykfkSgXTVR7FmU6R/ENd+gsPirHwg5YiYQ6n7mABD2eddtjrwhOBGAXZ525oYwcg7DBJXWm0BqMGeVn8QizlSKKoamrXrlp4EWkynlIUvq7uwYY11ip9cW03btbWYrFWHyNg2oNWxYcNRiRNhFfp5mYXtMRV9fkeJ+/Lu93HOuRBmbCAo2Amg32NByQlsESarbgf3RWmGV1aNbIhR810jFLl+6UBwMxViG8iu0f3kPKZNuC33vKuhNe7g7ch+Iru8uNx8RHlWlFbg3b5pxXGqJDJm2ql4YHOzyn1fCZoQM4JOaXjuugGc0EZ1wwLxNvR3x5HRDdH1K8M78mWkJaHBO4Q8N5xmmHEOwRVKNkW22CrO5r0D4Z6fiix2oxBD1qu3/0Cpj6mC8tb73o51orFiql0kKCVdPW/2nCjgopAZ27RTVuu2tMUon7UoRMKXYlu6QHZIlioH7vSZVcDVQ9Z1nSRj8VVrZX48BR3H5B+/xEj2wYXqXvE4q+f/+0EWF+o9ngDQc6GpXjBAt25wHooVxm6rC3MGIxrgpNucculfsXrVERloZwDXgyySlDc3h/sJlENmDz4hyDt0h2QCxdXEbIMEAZWs16adiFuoRQtl18gOnsCDo8lyBU0TJpgBS09Tbe5A+S2h75h9f9IsUwBNaFqupv0MaMZISPNAKeAsKJTiZUpJEMsYyMEbgiBRLnUEaAHzHpj0I6J7bXlbgbbwyCOJnKJUESMd1xP4cbagjx6pK6lWYMhCK47Uc1ovE6SVtvxOQkTUZoLePzP2QeEayrkm3d75ORxbfTqFUCTkpUyApC779EKx5PeKlpiqs672gif97itm4hcIUmsNVKKRbHMHJpZCGg85prW+9FXX1XgkPpNFbGDI7H71R0wdNZYdGUGZhXkq9ENCO6uoqRA8jIl572Q3+wqCJxiFAgD8/BksjdaFsNfaqE9eHveU
 OjE3re7c
 aG/UU3fMiiA4jESKb1/KDRfBuPMfQNT0R4mELuxLKXLXtL9s1UjaEU7/E0bk39847V3OZq8/jx0pEf8LsEq+ANVby58QWZeYNuX4iLGD+mXSzhOSgBhB3xyKnnMfL8QEGpGSiUirV/vSw5boIpFhO387eYjbiI06NsEcqy3CrpW3DLtyadQndfxUuk3QzqsUh15IUdI8MLEpOzLUNXpXvLxLcTmCKkzCoqfZRmnTZhsVG7LnD1xv0ikaZ4g06Xeis538djpllWUcqkagXPEEZXhIOhHKMdLwKid+ah+oBRzugcYhOTeeuTWXoo4EyCc+N2WNNKtW0pSB72GbNdzeT1gp72S6y96YGIFZM2EkgKWqMqTIEt5NwZfp9FpKkQPzh9qbKxKcHTUHiRkOIW8SO0L2MjGoIH5KZvSvimWf6PHohLcoCRNDhl3y47m0w356W5PQLr0dkIR1RYeOtnNpvXyLvRWxEY45BIx2JFx5IQwvD+eByaYYTssxIrE+QpsTNiKUSswTGeIkHE/FLKyDxa4i4p/BVl1pWLq2+kNywSWvSib8xhMrdiO568zYbRGEH39Uz5AL/X7Kcp2pd0YU6jPKbg4CppvMFnEDh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Avoid probing which windows incoming preserved bridges implement during
enumeration. Instead, add a new optional feature for passing the
results of probing in struct pci_dev_ser, and use it to pass which
windows each preserved bridge implements.

pci_probe_bridge_windows() always writes all 1s to the Prefetchable
Base Upper 32 Bits register of bridges with a 64-bit prefetchable
window to check that it is writable. This temporarily disables the
prefetchable window, so the bridge stops forwarding memory transactions
targeting devices below it, such as P2PDMA from other preserved devices,
or MMIO from VMs whose vCPUs keep running during kexec.

The new optional feature, PCI_SER_OPTIONAL_PROBED, appends two bitmasks
to struct pci_dev_ser: @probed holds the results of probing properties
of the device that require temporarily writing to it, one bit per
property (PCI_DEV_SER_PROBED_*), and @probed_supported indicates which
bits of @probed are valid. This allows passing the results of more
probes in the future (e.g. whether INTx masking is broken) without
adding a new feature flag for each one, and lets the next kernel use
the results it understands and probe the rest.

If the previous kernel did not pass which windows a bridge implements,
fall back to probing the windows.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c    | 93 ++++++++++++++++++++++++++++++++++++-
 drivers/pci/liveupdate.h    |  6 +++
 drivers/pci/probe.c         |  9 ++++
 include/linux/kho/abi/pci.h | 24 ++++++++++
 4 files changed, 131 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index f48cab3cc232..72ad4fd00f7b 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -204,6 +204,12 @@
  *    vCPUs keep running during kexec). Instead, the previous kernel passes the
  *    size of each BAR in struct pci_dev_ser. Everything else about the BARs
  *    (e.g. their addresses and types) is read from the device as usual.
+ *
+ *  * The PCI core does not probe properties of incoming preserved devices
+ *    that require temporarily writing to the device (e.g. which windows a
+ *    bridge implements), since that would disrupt memory transactions
+ *    targeting the device or devices below it. Instead, the previous kernel
+ *    passes the results of probing in struct pci_dev_ser.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -282,7 +288,13 @@ struct pci_flb_incoming {
  * Bits in struct pci_ser::optional_flags that this kernel knows how to handle.
  * This kernel also provides all of them to the next kernel.
  */
-#define PCI_SER_OPTIONAL_FLAGS_SUPPORTED	PCI_SER_OPTIONAL_BAR_MASKS
+#define PCI_SER_OPTIONAL_FLAGS_SUPPORTED \
+	(PCI_SER_OPTIONAL_BAR_MASKS | PCI_SER_OPTIONAL_PROBED)
+
+#define PCI_DEV_SER_PROBED_WINDOWS		\
+	(PCI_DEV_SER_PROBED_IO_WINDOW |		\
+	 PCI_DEV_SER_PROBED_PREF_WINDOW |	\
+	 PCI_DEV_SER_PROBED_PREF_64_WINDOW)
 
 /*
  * The minimum size of struct pci_dev_ser given the optional features that are
@@ -295,6 +307,9 @@ static u32 pci_dev_ser_min_size(u64 optional_flags)
 	if (optional_flags & PCI_SER_OPTIONAL_BAR_MASKS)
 		size = max(size, offsetofend(struct pci_dev_ser, rom_mask));
 
+	if (optional_flags & PCI_SER_OPTIONAL_PROBED)
+		size = max(size, offsetofend(struct pci_dev_ser, probed));
+
 	return size;
 }
 
@@ -626,6 +641,28 @@ static void pci_liveupdate_save_bar_masks(struct pci_dev *dev,
 	dev_ser->rom_mask = lower_32_bits(mask);
 }
 
+static void pci_liveupdate_preserve_probed(struct pci_dev *dev,
+					   struct pci_dev_ser *dev_ser)
+{
+	u64 supported = 0, probed = 0;
+
+	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
+		supported |= PCI_DEV_SER_PROBED_WINDOWS;
+
+		if (dev->io_window)
+			probed |= PCI_DEV_SER_PROBED_IO_WINDOW;
+
+		if (dev->pref_window)
+			probed |= PCI_DEV_SER_PROBED_PREF_WINDOW;
+
+		if (dev->pref_64_window)
+			probed |= PCI_DEV_SER_PROBED_PREF_64_WINDOW;
+	}
+
+	dev_ser->probed_supported = supported;
+	dev_ser->probed = probed;
+}
+
 static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 					  struct pci_dev *dev)
 {
@@ -671,6 +708,8 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 		if (IS_ERR(dev_ser))
 			return PTR_ERR(dev_ser);
 
+		pci_liveupdate_preserve_probed(dev, dev_ser);
+
 		pci_info(dev, "Device will be preserved across next Live Update\n");
 		outgoing->ser->nr_devices++;
 		outgoing->ser->devices = kho_block_set_head_pa(&outgoing->block_set);
@@ -1116,6 +1155,58 @@ int pci_liveupdate_read_bar_masks(struct pci_dev *dev, unsigned int nr_bars,
 	return 0;
 }
 
+/*
+ * Get the results of probing @bits on the incoming device @dev, as passed by
+ * the previous kernel. Returns false if the previous kernel did not pass all of
+ * @bits, in which case they must be probed.
+ */
+static bool pci_liveupdate_read_probed(struct pci_dev *dev, u64 bits,
+				       u64 *probed)
+{
+	struct pci_dev_ser *dev_ser = dev->liveupdate.incoming;
+
+	lockdep_assert_held(&pci_liveupdate.rwsem);
+
+	if (!dev_ser)
+		return false;
+
+	if (!(pci_liveupdate.incoming_optional_flags & PCI_SER_OPTIONAL_PROBED))
+		return false;
+
+	if ((dev_ser->probed_supported & bits) != bits)
+		return false;
+
+	*probed = dev_ser->probed & bits;
+	return true;
+}
+
+/**
+ * pci_liveupdate_read_bridge_windows() - Get the windows of an incoming bridge
+ * @bridge: The PCI bridge
+ *
+ * Set which windows @bridge implements (@bridge->io_window, pref_window, and
+ * pref_64_window) as determined by the previous kernel, so that the windows do
+ * not need to be probed.
+ *
+ * Return: 0 on success, or -ENODATA if @bridge is not incoming-preserved or
+ * the previous kernel did not pass which windows @bridge implements.
+ */
+int pci_liveupdate_read_bridge_windows(struct pci_dev *bridge)
+{
+	u64 probed;
+
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+
+	if (!pci_liveupdate_read_probed(bridge, PCI_DEV_SER_PROBED_WINDOWS,
+					&probed))
+		return -ENODATA;
+
+	bridge->io_window = !!(probed & PCI_DEV_SER_PROBED_IO_WINDOW);
+	bridge->pref_window = !!(probed & PCI_DEV_SER_PROBED_PREF_WINDOW);
+	bridge->pref_64_window = !!(probed & PCI_DEV_SER_PROBED_PREF_64_WINDOW);
+	return 0;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 80749f14beea..4c4104025a7e 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -21,6 +21,7 @@ int pci_liveupdate_adopt_ari(struct pci_dev *dev);
 bool pci_liveupdate_is_outgoing(struct pci_dev *dev);
 int pci_liveupdate_read_bar_masks(struct pci_dev *dev, unsigned int nr_bars,
 				  u32 *bar_masks, u32 *rom_mask);
+int pci_liveupdate_read_bridge_windows(struct pci_dev *bridge);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -66,6 +67,11 @@ static inline int pci_liveupdate_read_bar_masks(struct pci_dev *dev,
 {
 	return -EINVAL;
 }
+
+static inline int pci_liveupdate_read_bridge_windows(struct pci_dev *bridge)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 473e4389ffae..184d93aa8522 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -529,6 +529,15 @@ static void pci_probe_bridge_windows(struct pci_dev *bridge)
 	u16 io;
 	u32 pmem, tmp;
 
+	/*
+	 * Writing to the window registers would disrupt memory transactions
+	 * that bridges preserved across Live Update forward to devices below
+	 * them, so use the windows determined by the previous kernel for those
+	 * bridges.
+	 */
+	if (!pci_liveupdate_read_bridge_windows(bridge))
+		return;
+
 	pci_read_config_word(bridge, PCI_IO_BASE, &io);
 	if (!io) {
 		pci_write_config_word(bridge, PCI_IO_BASE, 0xe0f0);
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index 5fa2ecfe5b6d..84a1bf71eeca 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -66,6 +66,13 @@
  *             which requires disabling decoding and would disrupt memory
  *             transactions targeting the device.
  * @rom_mask: Same as @bar_masks, but for the Expansion ROM BAR.
+ * @probed_supported: The ``PCI_DEV_SER_PROBED_*`` bits that are valid in
+ *                    @probed.
+ * @probed: The results of probing properties of the device that require
+ *          temporarily writing to it (``PCI_DEV_SER_PROBED_*``). Used by the
+ *          next kernel instead of probing the device again, which would
+ *          disrupt memory transactions targeting the device or devices below
+ *          it.
  *
  * Each field after @refcount is only present if the ``PCI_SER_OPTIONAL_*``
  * flag that covers it is set in ``pci_ser.optional_flags``.
@@ -76,8 +83,23 @@ struct pci_dev_ser {
 	u16 refcount;
 	u32 bar_masks[PCI_STD_NUM_BARS];
 	u32 rom_mask;
+	u64 probed_supported;
+	u64 probed;
 } __packed;
 
+/*
+ * Bits in struct pci_dev_ser::probed_supported and probed:
+ *
+ *  * PCI_DEV_SER_PROBED_IO_WINDOW: The bridge has an I/O window.
+ *  * PCI_DEV_SER_PROBED_PREF_WINDOW: The bridge has a prefetchable memory
+ *    window.
+ *  * PCI_DEV_SER_PROBED_PREF_64_WINDOW: The bridge's prefetchable memory
+ *    window is 64-bit.
+ */
+#define PCI_DEV_SER_PROBED_IO_WINDOW		BIT_ULL(0)
+#define PCI_DEV_SER_PROBED_PREF_WINDOW		BIT_ULL(1)
+#define PCI_DEV_SER_PROBED_PREF_64_WINDOW	BIT_ULL(2)
+
 /*
  * The size of struct pci_dev_ser when this ABI was introduced. Since fields
  * can only be appended, every struct pci_dev_ser is at least this large.
@@ -113,7 +135,9 @@ struct pci_ser {
  * large enough to contain the fields of struct pci_dev_ser that it covers:
  *
  *  * PCI_SER_OPTIONAL_BAR_MASKS: @bar_masks and @rom_mask
+ *  * PCI_SER_OPTIONAL_PROBED: @probed_supported and @probed
  */
 #define PCI_SER_OPTIONAL_BAR_MASKS	BIT_ULL(0)
+#define PCI_SER_OPTIONAL_PROBED		BIT_ULL(1)
 
 #endif /* _LINUX_KHO_ABI_PCI_H */
-- 
2.56.0.212.g129ede20d9-goog


