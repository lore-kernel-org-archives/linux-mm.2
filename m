Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 577A4CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06A56B0098; Tue, 12 May 2026 14:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF0A6B0099; Tue, 12 May 2026 14:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2BC6B009B; Tue, 12 May 2026 14:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97EA46B0098
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:48:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6511E1A059C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:59 +0000 (UTC)
X-FDA: 84759654798.28.9E86A7D
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E8E84000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wisIIjT1;
	spf=pass (imf07.hostedemail.com: domain of 3GHYDaggKCGkKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3GHYDaggKCGkKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/ffX7NZKMXtWZsAVnQEQAODhtui4k/+NBvalJZrS3c=;
	b=VZJXPFyRPLOZyVVSscbYA7V6YYWNSOsxscNvrLl87zKPuZrSWBatvIGcRM+jYBsWdmqgHJ
	AKgwcTpnqREGqqxGgQX+ldo4YhhlsUirh3MgrdW2029b0zkPTy8kL8u4oP8/vF8xUxrw6z
	82A2C/wy2pGS/gH9XNEhxWSRAyPIBgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611737; a=rsa-sha256;
	cv=none;
	b=OwdIGSw0qqqd/bG9eaAg/8AFEPuDsQMeGU+v6MYW6jovHtTHSBxhqY8fQqDrHhBMVR0viW
	rTyd9Mpsv/cPmcjgH1rYnPQmHoBEo2jSGQiYTJi7OQl4tqXgwx0GcXkMsNRpewl4K5wtBF
	LYZzwIfrFcrzjjhk9NOfQcuuuZ/cfUg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wisIIjT1;
	spf=pass (imf07.hostedemail.com: domain of 3GHYDaggKCGkKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3GHYDaggKCGkKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c82ac893940so173872a12.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611736; x=1779216536; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f/ffX7NZKMXtWZsAVnQEQAODhtui4k/+NBvalJZrS3c=;
        b=wisIIjT14w6ZgOntH195CuSyWmB8FGvKneK/3ze4TS1suszWvhQOgeKhco9N+SeX8t
         fmKf7DrbVsCm+YzeZKCQkyM82SDufJlVJZhbP37jv2ae2DB9H6J5LWI5hQ6T2QYiqj29
         VAJbFgYffZ+dFMYntcM5VoP4e+pEchKjpSW2bZK7gPB6sOdNa1tb4Y42/M0NIH+cd1/p
         UVxqLtqg+Y+G21x8jMeKwyr/PFaUUaWYfeJ2dOrHDh+u3ejyKtW43uMo9epj/M3xsVip
         PuH6cC8tHfx61HN31j0SvNV6DGwH7mQS8CKncYpnUccJHbAOT1Pdtc5G5/YZX2FJ2GLK
         T0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611736; x=1779216536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f/ffX7NZKMXtWZsAVnQEQAODhtui4k/+NBvalJZrS3c=;
        b=gEdiMO3GWD+aScshTPl1/RkmsVAVfC4nEwH/i1cLWJW+HbHwmVDxg5AHh81YNb6/47
         vVRzNX7v6DbeLCFHGo9XLp7cXJESg9O0uWAu47s6NI+X4By72Y4Ah/3eIWfyw+gNPt9x
         N1va4MljcX5r1dSl0BD8g5gCSTrhT5/m3k6qRaZQbTM6fPGbwSXulCR2gC/o5yzP33pI
         RUqRsY35Y4n4QtoOkUcmRvopEuYcZidHQvCtrVA+g+o1urtYC1s4QGT60y3eT0iTKHaF
         5NCQq+udhRrmxC5lZjXRSfmc1edgjl76ls1vqUR9u91BFolT28PQGNhUPCYF+HTzbGEC
         HAqw==
X-Forwarded-Encrypted: i=1; AFNElJ8ve5Fc1mcnd5aEDXdiFZLDdVeFD0+tQktBHFZZliheOZBr2fARow9yqr+wbT5fY8eYQKqqzPvKzQ==@kvack.org
X-Gm-Message-State: AOJu0YymlvtYg/GBqVXteUZweDTpdA1WFmrR7jlX0jAnS88qzKwt97Po
	wJ07BY/C6PHTV1D00IytgEGUE6EiAnlCXJ+cWpnIvPsFiyIGAMgUxZcZAWbC2tzSyJSF90r0p2e
	RHFVaF373ucta0w==
X-Received: from pfoi19.prod.google.com ([2002:aa7:87d3:0:b0:838:1ece:7e7e])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:549d:b0:3a3:5726:7e39 with SMTP id adf61e73a8af0-3aa5a8e8078mr31185030637.23.1778611736203;
 Tue, 12 May 2026 11:48:56 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:41 +0000
In-Reply-To: <20260512184846.119396-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260512184846.119396-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-7-dmatlack@google.com>
Subject: [PATCH v5 06/11] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
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
X-Rspamd-Queue-Id: 9E8E84000C
X-Rspam-User: 
X-Stat-Signature: 9ayh5zrmjf53nhcigyjqq9msir9grjgd
X-HE-Tag: 1778611737-386538
X-HE-Meta: U2FsdGVkX18KsWqmWMPZIcLQActT+Sr+KhMMVT9rHacPqfwV6QsAI2aJirGGg9xBT0ZDekp/jEKlwFzfR1UDEauXhi2R3fLLto5so02KMhF4IID9fwRvoxThu3qz04siHsIjL/2dXrcooaK9PQHu9DpU2bHt5OBLVtNcZPNJLtIstKEwWiPs14zd+SaMu5d60JeTnmMm0+I0c5oTbd6z4GonGf26Qa67DEhSYCDooyq0R4MCZdSIYHTTSoLaIF/vhDX0ZwYCsXA0xczTWvthWdzsbxXyVxCm4NH1r/7lPvBEvCQJOP8SCGUZYL8zhs1OSc4DZFyZF+TN1bVQ3Pe9MQWs1ey438Adbpa7t+Nmhet/5ts8sK+AkQy0dIEYA8zlWfnhzLTnGe9b2wugJfpZKpt86yM49BKNgT2ntfkTw5kxAfD5fSDBZ84RRnL8VeOuNeKbhvPbFV+lRXx1ICSYD3MpBWi/h+XBarIUkXygOM0c7PFwtT2YfZpyznF7BAa+CIpECy1U+wknhyGYCqW2T6sEWUweg86Qhl/R2DtVzT4V7CB3su4qVlwMrwMFUYacl3pVblQ86adyS3hzN9MlviUhBMao0UzEW+tLdlJoXOF3Rmou2CHZAF27fe1+QBMKEpfDKRAM4EcK2c3MSHJdH7dW3orbDXhMZSeax+/szYdC+Xu9s+U5z6K9nXMRbIK1YM1BK9zqTSUUC/hItwsjgAAeYzYgQjovFGb1rcEwA17nOtVAxSNRcv3Y6cpuNQNZhlnp3CVaO7KS46seRAe2lKnllZl2i0lsNFNn/ETz2liPp1LWiMWq/ilwbrPMk6YcUvuIEfV5W5FieViTVuXpPWZNXR1lHvUlVqY32lP5JL9ib1XhFUv5KictkqEeSHprwzN46laU64lDCzPGH573ART1+bhWJKL8QdvMS2QglZy3mBPVqeUsZLglS2KhmvCHdwg6hV4yNLFu2b32aca
 Bl0WRztS
 LxR47mLHPmKd0dQ94u2W4+NbLkFCja40k6e5e9rmmJ8spJSos+wN8vg961sEMIf8YJ2ztybJfRguvOBMgbGLUUNYrokNAqkOVB+MKNcKAb/2WJi23q/QVulsQQBZGT9+tNhx3hCzUE49DO4+eiujLDJqPL2aBD6wVElCwAnINMoIPze8YaTwpk5h75yZ30ksk+ZFgxyqceMNTiEuvDYSBcFLrFeEXsPgwIXs4wv4UPzxk91g13Cy4ejf38qLvrKvYbiq9wiV9TNxlPbzIXLrjvfYfBVqL48vdKI2ZgeWNLSie7zHiMuj1h+CZ2U+mh5pBg/e3QEtcdofU6W70q5j31xJ5Lpbvw2zb9jkFu71YqHEQYAivSr7petnxzDtxwtSabzTnCrFC2SIyjrfJuDYIAbdcOid4lRMq10Xss/nE8xsadZJa+/EoOpmF4yYBiFn0Qakol457IfPEzsifBQ2oGmy0xPl98XME5V84ZQtXgMuegTagbgrdIlwkjMwv041Lz7+4NpCp8HDtc2mIAgBPmEKXPuhJmij82/K7ormg/yBEoo3tJ20exT+o0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a PCI device is preserved across a Live Update, all of its upstream
bridges up to the root port must also be preserved. This enables the PCI
core and any drivers bound to the bridges to manage bridges correctly
across a Live Update.

Notably, this will be used in subsequent commits to ensure that
preserved devices can continue performing memory transactions without a
disruption or change in routing.

To preserve bridges, the PCI core tracks the number of downstream
devices preserved under each bridge using a reference count in struct
pci_dev_ser. This allows a bridge to remain preserved until all its
downstream preserved devices are unpreserved or finish their
participation in the Live Update.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 241 ++++++++++++++++++++++++++++++---------
 1 file changed, 184 insertions(+), 57 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 558fbaec8ddd..d8e06afde2c7 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -108,6 +108,18 @@
  * If a misconfigured or unconfigured bridge is encountered during enumeration
  * while there are preserved devices, itss secondary and subordinate bus numbers
  * will be cleared and devices below it will not be enumerated.
+ *
+ * PCI-to-PCI Bridges
+ * ==================
+ *
+ * Any PCI-to-PCI bridges upstream of a preserved device are automatically
+ * preserved when the device is preserved. The PCI core keeps track of the
+ * number of downstream devices that are preserved under a bridge so that the
+ * bridge is only unpreserved once all downstream devices are unpreserved.
+ *
+ * This enables the PCI core and any drivers bound to the bridge to participate
+ * in the Live Update so that preserved endpoints can continue issuing memory
+ * transactions during the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -300,41 +312,55 @@ static struct liveupdate_flb pci_liveupdate_flb = {
 	.compatible = PCI_LUO_FLB_COMPATIBLE,
 };
 
-/**
- * pci_liveupdate_preserve() - Preserve a PCI device across Live Update
- * @dev: The PCI device to preserve.
- *
- * pci_liveupdate_preserve() notifies the PCI core that a PCI device should be
- * preserved across the next Live Update. Drivers must call
- * pci_liveupdate_preserve() from their struct liveupdate_file_handler
- * preserve() callback to ensure the outgoing struct pci_ser is allocated.
- *
- * Returns: 0 on success, <0 on failure.
- */
-int pci_liveupdate_preserve(struct pci_dev *dev)
+static int pci_liveupdate_unpreserve_device(struct pci_ser *ser, struct pci_dev *dev)
 {
-	struct pci_flb_outgoing *outgoing = NULL;
-	struct pci_ser *ser;
-	int i, ret;
+	struct pci_dev_ser *dev_ser;
 
-	if (dev->is_virtfn)
+	guard(write_lock)(&dev->liveupdate.lock);
+
+	dev_ser = dev->liveupdate.outgoing;
+	if (!dev_ser) {
+		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
 		return -EINVAL;
+	}
 
-	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&outgoing);
-	if (ret)
-		return ret;
+	if (!dev_ser->refcount) {
+		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
+		return -EINVAL;
+	}
 
-	if (!outgoing)
-		return -ENOENT;
+	if (--dev_ser->refcount)
+		return 0;
 
-	guard(mutex)(&outgoing->lock);
-	ser = outgoing->ser;
+	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
+	ser->nr_devices--;
+	memset(dev_ser, 0, sizeof(*dev_ser));
+	dev->liveupdate.outgoing = NULL;
+	return 0;
+}
 
-	guard(write_lock)(&dev->liveupdate.lock);
+static int pci_liveupdate_preserve_device_existing(struct pci_dev *dev)
+{
+	if (!dev->liveupdate.outgoing->refcount) {
+		pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
+		return -EINVAL;
+	}
 
-	if (dev->liveupdate.outgoing)
+	/*
+	 * Endpoint devices should not be preserved more than once. Bridges are
+	 * preserved once for every downstream device that is preserved.
+	 */
+	if (!dev->subordinate)
 		return -EBUSY;
 
+	dev->liveupdate.outgoing->refcount++;
+	return 0;
+}
+
+static int pci_liveupdate_preserve_device_new(struct pci_ser *ser, struct pci_dev *dev)
+{
+	int i;
+
 	if (ser->nr_devices == ser->max_nr_devices)
 		return -ENOSPC;
 
@@ -363,8 +389,82 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
 
 	return -ENOSPC;
 }
+
+static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *dev)
+{
+	guard(write_lock)(&dev->liveupdate.lock);
+
+	if (dev->liveupdate.outgoing)
+		return pci_liveupdate_preserve_device_existing(dev);
+	else
+		return pci_liveupdate_preserve_device_new(ser, dev);
+}
+
+static int pci_liveupdate_preserve_path(struct pci_ser *ser, struct pci_dev *dev)
+{
+	int ret;
+
+	if (!dev)
+		return 0;
+
+	ret = pci_liveupdate_preserve_device(ser, dev);
+	if (ret)
+		return ret;
+
+	ret = pci_liveupdate_preserve_path(ser, dev->bus->self);
+	if (ret) {
+		pci_liveupdate_unpreserve_device(ser, dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * pci_liveupdate_preserve() - Preserve a PCI device across Live Update
+ * @dev: The PCI device to preserve.
+ *
+ * pci_liveupdate_preserve() notifies the PCI core that a PCI device should be
+ * preserved across the next Live Update. Drivers must call
+ * pci_liveupdate_preserve() from their struct liveupdate_file_handler
+ * preserve() callback to ensure the outgoing struct pci_ser is allocated.
+ *
+ * pci_liveupdate_preserve() automatically preserves all bridges upstream of
+ * @dev.
+ *
+ * Returns: 0 on success, <0 on failure.
+ */
+int pci_liveupdate_preserve(struct pci_dev *dev)
+{
+	struct pci_flb_outgoing *outgoing = NULL;
+	int ret;
+
+	if (dev->is_virtfn)
+		return -EINVAL;
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&outgoing);
+	if (ret)
+		return ret;
+
+	if (!outgoing)
+		return -ENOENT;
+
+	guard(mutex)(&outgoing->lock);
+	return pci_liveupdate_preserve_path(outgoing->ser, dev);
+}
 EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
 
+static void pci_liveupdate_unpreserve_path(struct pci_ser *ser, struct pci_dev *dev)
+{
+	if (!dev)
+		return;
+
+	if (pci_liveupdate_unpreserve_device(ser, dev))
+		return;
+
+	pci_liveupdate_unpreserve_path(ser, dev->bus->self);
+}
+
 /**
  * pci_liveupdate_unpreserve() - Cancel preservation of a PCI device
  * @dev: The PCI device to preserve.
@@ -373,12 +473,13 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
  * longer be preserved across the next Live Update. Drivers must call
  * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
  * unpreserve() callback to ensure the outgoing struct pci_ser is allocated.
+ *
+ * pci_liveupdate_unpreserve() automatically unpreserves all bridges upstream of
+ * @dev.
  */
 void pci_liveupdate_unpreserve(struct pci_dev *dev)
 {
 	struct pci_flb_outgoing *outgoing = NULL;
-	struct pci_dev_ser *dev_ser;
-	struct pci_ser *ser;
 	int ret;
 
 	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&outgoing);
@@ -389,20 +490,7 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
 	}
 
 	guard(mutex)(&outgoing->lock);
-	ser = outgoing->ser;
-
-	guard(write_lock)(&dev->liveupdate.lock);
-
-	dev_ser = dev->liveupdate.outgoing;
-	if (!dev_ser) {
-		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
-		return;
-	}
-
-	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
-	ser->nr_devices--;
-	memset(dev_ser, 0, sizeof(*dev_ser));
-	dev->liveupdate.outgoing = NULL;
+	pci_liveupdate_unpreserve_path(outgoing->ser, dev);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
 
@@ -510,6 +598,55 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 		pci_liveupdate_flb_put_incoming();
 }
 
+static int __pci_liveupdate_finish_device(struct pci_dev *dev)
+{
+	guard(write_lock)(&dev->liveupdate.lock);
+
+	if (!dev->liveupdate.incoming) {
+		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
+		return -EINVAL;
+	}
+
+	if (!dev->liveupdate.incoming->refcount) {
+		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Decrement the refcount so this device does not get treated as an
+	 * incoming device again, e.g. in case pci_liveupdate_setup_device()
+	 * gets called again because the device is hot-plugged.
+	 */
+	if (--dev->liveupdate.incoming->refcount)
+		return -EBUSY;
+
+	pci_info(dev, "Device is finished participating in Live Update\n");
+	dev->liveupdate.incoming = NULL;
+	return 0;
+}
+
+static int pci_liveupdate_finish_device(struct pci_dev *dev)
+{
+	int ret;
+
+	/*
+	 * If ret == -EBUSY the device is still preserved due to remaining
+	 * references. Return 0 up to the caller to indicate it should proceed
+	 * to finish preserving upstream devices but do not drop the device's
+	 * reference on the incoming FLB below.
+	 */
+	ret = __pci_liveupdate_finish_device(dev);
+	if (ret)
+		return ret == -EBUSY ? 0 : ret;
+
+	/*
+	 * Once the device's refcount reaches zero drop the device's reference
+	 * on the incoming FLB so it can be freed.
+	 */
+	pci_liveupdate_flb_put_incoming();
+	return 0;
+}
+
 /**
  * pci_liveupdate_finish() - Finish the preservation of a PCI device across Live Update
  * @dev: The PCI device
@@ -519,28 +656,18 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
  * Update. Drivers must call pci_liveupdate_finish() from their struct
  * liveupdate_file_handler finish() callback to ensure the incoming struct
  * pci_ser is allocated.
+ *
+ * pci_liveupdate_finish() automatically finishes all bridges upstream of @dev.
  */
 void pci_liveupdate_finish(struct pci_dev *dev)
 {
-	guard(write_lock)(&dev->liveupdate.lock);
-
-	if (!dev->liveupdate.incoming) {
-		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
+	if (!dev)
 		return;
-	}
-
-	pci_info(dev, "Device is finished participating in Live Update\n");
 
-	/*
-	 * Drop the refcount so this device does not get treated as an incoming
-	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
-	 * again because the device is hot-plugged.
-	 */
-	dev->liveupdate.incoming->refcount = 0;
-	dev->liveupdate.incoming = NULL;
+	if (pci_liveupdate_finish_device(dev))
+		return;
 
-	/* Drop this device's reference on the incoming FLB. */
-	pci_liveupdate_flb_put_incoming();
+	pci_liveupdate_finish(dev->bus->self);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
 
-- 
2.54.0.563.g4f69b47b94-goog


