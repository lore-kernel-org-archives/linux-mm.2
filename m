Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCCF3C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3C466B00B9; Fri, 10 Jul 2026 17:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5DE6B00BB; Fri, 10 Jul 2026 17:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D180F6B00BC; Fri, 10 Jul 2026 17:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2266B00B9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21035A055E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:31 +0000 (UTC)
X-FDA: 84974150982.02.5E69542
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6637E4000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X5tDcwU9;
	spf=pass (imf17.hostedemail.com: domain of 3hGNRaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3hGNRaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57QfbJnRLtEgyk7xuyEyKOzrYVcCZwar9BStEh/xugM=;
	b=dpo1cJ7VSRpyJRYVcaKo/vBAZtK1wPvmCio2NIWJ5GNEBHUPxdTJKY6NoURDcv9fUEi0i2
	hmBFwqRo3W5uTdDC7YqESRUg+c3kixY4ZynPkEHKpfJ8/2JP91T5Dw563rDJRKAR1mc4kr
	c2oAhXURQrM40NKGIsp9XdqchPcfwug=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X5tDcwU9;
	spf=pass (imf17.hostedemail.com: domain of 3hGNRaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3hGNRaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718789;
	b=SZiNbFFOHd4qDh2kc9fXmNrS90o1i+uBf+MwQKBSAaO5ccVsGdviHpEaVf+8/wHlmhYbEN
	Y6rOk1bK377hvjwAcu4w0ktxMOyrBSk5RsXqSXaN6Pfk37a/9Ja9Pc9l9+dbTuKYfBqpwS
	Y/8KM0Z2C4S9C4Ofgy4Jh9QgUVXevtI=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-84865f326efso1439934b3a.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718788; x=1784323588; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=57QfbJnRLtEgyk7xuyEyKOzrYVcCZwar9BStEh/xugM=;
        b=X5tDcwU9d8WNDzbnkG/3T1CWL+rPSL40eyJw0m2TPvtcf1ge97tleYoG/5uUApPE0t
         e4o+Rf2GfFIQI82xP2w+s9INg2d5Wq1FyCmvdsAX2ywtVMTNyqKV/L9abZ/jM3vP0q2S
         dPLskOwQ9l/6Y6BQskpAOfI0Jmxsgb/oSygAke8MmNq8bZyJXsqVxgHXtMqByjk5nY7W
         zWp2JYtaj5/b831QbuK8oM/mSIXLe2cPgDW687b2Pk+BcjwP2m4D3BHzlt4KiSwnoLA0
         bBYKjWA5LUPvBV5QTGlacQQeny8DPaiA3gdCusEKGftfk2tPjZkawTulfkO8VX0GZFLh
         b4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718788; x=1784323588;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=57QfbJnRLtEgyk7xuyEyKOzrYVcCZwar9BStEh/xugM=;
        b=TmM4lGWEetnzjcUt/vRno2FBBMdya7MjzCXbTR4oWBR9SI4vGoXXAglK8DrKsqLMYW
         vIQFQ3vQR5bb3m8VaB/dpGwwjo5CSqnzg74KbxQBIcDRUAcfFQQSwyPGH4H9Mp7VBSxn
         J1kV1eJ4rGbwgRZ1ibzbpasjvZC8HF/hLJr13MY/UYkPi7In7glvvzsEip9hkcEqS8uT
         lLw4ejQndxVP0yFCIjPX/8HQf50Cf3HhHcVvBa6OjP810OMvvCLANaalf0vlkNOPFUOI
         nE4xD/DgRyYuiWbQjNvjIezGDJsHHB2EdnRNuYLGW6uIJfMPqJguWpRQjNpBkelqyZYL
         tWjQ==
X-Forwarded-Encrypted: i=1; AHgh+RoD4fI8xESVGRZ7qUY7A1YPf85cMzcUx6l9mYJGyiHP5kHhhVbZjAdWqeW/ZYkBfP92DOnv1khODA==@kvack.org
X-Gm-Message-State: AOJu0YzGrjtMoXp4dc8rMttRX3osHFtocqRQSjcl/rTZnZQOxwaDnttJ
	F1Vt9MlZlu8U+iXWPiFXVWrcsSkPbHIUBsqcrcTI0aPDfSbMLoashqVUVYz08lt/kZm+YNqYpfI
	Jbu5GUAgD3IbH8Q==
X-Received: from pfbhm2.prod.google.com ([2002:a05:6a00:6702:b0:847:9cc9:a40d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:450f:b0:848:2f71:b65b with SMTP id d2e1a72fcca58-848897d5cc1mr570948b3a.70.1783718788088;
 Fri, 10 Jul 2026 14:26:28 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:09 +0000
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-7-dmatlack@google.com>
Subject: [PATCH v7 06/12] PCI: liveupdate: Auto-preserve upstream bridges
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6637E4000D
X-Stat-Signature: yijduc9ej9zqu31ffxb48hjutoio6fhx
X-HE-Tag: 1783718789-927227
X-HE-Meta: U2FsdGVkX18xlcjvwnjUQvfkGtnrA+89BdMSzQnKbaYmyeE0eYM7yHBPoXB/V2uVrCYBqtNT/RTRkCj8u4sWy/Ry27Rx70f1VSOuh9fH741ESvyNOZ+tODxZAmR3PFJYVeHpIk25N5lm4fcn7cITLILn1Xr0j5v8PMaiE/z2zrVpLJPbytA7A9u7dVDT3nkdIsdZSLMAeL6C2ITC8T2Lw0RkkZN7Iw9kODnYgCfkuqCOFYWstFfjzR5+uXGgDQ/5D/nIK9RhO4bujsZjw0Bv7n1bjLXJe4drZSQxFzieFGaUncN7bU7f6/oSUMhtPsKlWXilAoc/qfUgMKaVzo3gH95gMW2UPlU9ei9L4ksLTxx6jFMC2tIRFn2rQEdjHv1+zOcFow8++Zfw29Po/9LrURHPx6pT6HEzGpBl2H/cd9fY1D0V2/5fubh0nvSD7z85mQCyqCP6URvKxa1+lusp++gFqocwS0cBhpVijgB4h3kQSvVdrLPdaZaV1KixVGYiMN6jHPwV9HYTqyVLU8c+RMJqIwtR7Z96F8ui64DAAq+b/ww1Ynp2Z7hM95O+ZxuGoBxEdczxdwo35qonO9mPXBE//2DV5z00oXPZei51Z4vDw0TMhlXxpfrkXVDBz8L+1LNadQLHG4Bdp4wQlFz08LjU74P7hXQHaI2pvxekXVYrtpQdkjC8bjb3C0CI83dwDLUJEWm5UXQ4M9ELWd+/wktVPpHv+m+NihEZgxPf4QweJjC0QXi/fretnb6G5n6Vh2rbgA+RpdPs3yViN7JBR4BG+yhFmhgrBGot6kieHAmXQY3L/9DCgJDlZnBcs87sm0Q4aZQnvi1oIV+AR4Nmj+CU/Bm6BXy4tFBNI30hQpIh5tcOBcDfK/BZOqf2CfGGViIvnxQNFJhztvQUa8ILEAErpVFj/KM+f8D9fw7whyfAvun3o+O10WjXekLL41ghNNFF3ucMbeZFc7jcOiv
 nwE7AKUW
 TlP3w1hKm+Tftt3Lj0ILVyCMVGdmAomm3+CFNZBYzlOlqC9QaWeI58UD47tWs/86irObY9c6ZtBP1QYjLVQS/wz5kil1Rsv1hBSnL8xHT6VclFaA7CpazeDZsvbg0BttQU+hHmbIVqOG9gGV/o/c1F5OJIg6PHOxX2Vtd2GGkMMD79Rl19dQc7ht6N0n3todfwL6rPzQuJRtN3GQoVtWSavW3A+o8F+nRsZqh4gYL0TKJEz/IviLeHYVGbCjGgYXBW4sNnbX9CzA81oR795uxN8HxuBaDbmXwf4W1f8ARyBtwOf9wI+B8fqcKu6jRkQvoyNLjKUIyQWDP6RmySivhmOsTRopcVyycn6cKspdqjehmXq6La8QlmW2PCm/CltU7hccXgIU9ZCjJ991Uff0lnCxJeoIHRfQ+6Pm/eAOGKS4fo8fbclrSmjQHZRWo9Jl9ATQFm4fit5p0clJE+GpxRXcCsfIjwqW5XOMoNwoluoY+0aPrAefzi7qrDxSCwoDreccwOljnFCUJ2bpLWqGeD1pfBQArtugZCxxjZhqJo4+34gatf/QXChqN1puzyea9rNVqv2Yn1PfVR7ktV4MPSfpZ1oUSyqV0xcJi
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
 drivers/pci/liveupdate.c    | 136 +++++++++++++++++++++++++++++++-----
 include/linux/kho/abi/pci.h |   5 +-
 2 files changed, 122 insertions(+), 19 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index b2b950d71657..7f7710cb1da0 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -101,6 +101,18 @@
  * If a misconfigured or unconfigured bridge is encountered during enumeration
  * while there are preserved devices, its secondary and subordinate bus numbers
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
 
 #define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
@@ -316,28 +328,52 @@ static struct pci_dev_ser *pci_get_empty_or_append(struct pci_flb_outgoing *outg
 	return dev_ser;
 }
 
-static void pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
+static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
 {
 	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
 
 	if (!dev_ser) {
 		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
-		return;
+		return -EINVAL;
+	}
+
+	if (!dev_ser->refcount) {
+		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
+		return -EINVAL;
 	}
 
+	if (--dev_ser->refcount)
+		return 0;
+
 	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
 	outgoing->ser->nr_devices--;
 	memset(dev_ser, 0, sizeof(*dev_ser));
 	dev->liveupdate.outgoing = NULL;
+	return 0;
 }
 
-static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
+static int pci_liveupdate_preserve_device_again(struct pci_dev *dev)
 {
-	struct pci_dev_ser *dev_ser;
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
+static int __pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser;
+
 	dev_ser = pci_get_empty_or_append(outgoing);
 	if (IS_ERR(dev_ser))
 		return PTR_ERR(dev_ser);
@@ -354,6 +390,52 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, str
 	return 0;
 }
 
+static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
+{
+	if (dev->liveupdate.outgoing)
+		return pci_liveupdate_preserve_device_again(dev);
+
+	return __pci_liveupdate_preserve_device(outgoing, dev);
+}
+
+#define for_each_pci_dev_in_path(_d, _start, _end) \
+	for ((_d) = (_start); (_d) != (_end); (_d) = (_d)->bus->self)
+
+static void __pci_liveupdate_unpreserve_path(struct pci_flb_outgoing *outgoing,
+					     struct pci_dev *start,
+					     struct pci_dev *end)
+{
+	struct pci_dev *dev;
+
+	for_each_pci_dev_in_path(dev, start, end) {
+		if (pci_liveupdate_unpreserve_device(outgoing, dev))
+			return;
+	}
+}
+
+static void pci_liveupdate_unpreserve_path(struct pci_flb_outgoing *outgoing,
+					   struct pci_dev *start)
+{
+	__pci_liveupdate_unpreserve_path(outgoing, start, /*end=*/NULL);
+}
+
+static int pci_liveupdate_preserve_path(struct pci_flb_outgoing *outgoing,
+					struct pci_dev *start)
+{
+	struct pci_dev *dev;
+	int ret;
+
+	for_each_pci_dev_in_path(dev, start, NULL) {
+		ret = pci_liveupdate_preserve_device(outgoing, dev);
+		if (ret) {
+			__pci_liveupdate_unpreserve_path(outgoing, start, dev);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * pci_liveupdate_preserve() - Preserve a PCI device across Live Update
  * @dev: The PCI device to preserve.
@@ -363,6 +445,9 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, str
  * pci_liveupdate_preserve() from their struct liveupdate_file_handler
  * preserve() callback to ensure the outgoing struct pci_ser is already set up.
  *
+ * pci_liveupdate_preserve() automatically preserves all bridges upstream of
+ * @dev.
+ *
  * Returns: 0 on success, <0 on failure.
  */
 int pci_liveupdate_preserve(struct pci_dev *dev)
@@ -378,7 +463,7 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
 	if (IS_ERR(outgoing))
 		return PTR_ERR(outgoing);
 
-	return pci_liveupdate_preserve_device(outgoing, dev);
+	return pci_liveupdate_preserve_path(outgoing, dev);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
 
@@ -391,6 +476,9 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
  * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
  * unpreserve() callback to ensure the outgoing struct pci_ser is already set
  * up.
+ *
+ * pci_liveupdate_unpreserve() automatically unpreserves all bridges upstream of
+ * @dev.
  */
 void pci_liveupdate_unpreserve(struct pci_dev *dev)
 {
@@ -404,7 +492,7 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
 		return;
 	}
 
-	pci_liveupdate_unpreserve_device(outgoing, dev);
+	pci_liveupdate_unpreserve_path(outgoing, dev);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
 
@@ -594,29 +682,41 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 	}
 }
 
-static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
+static int pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
 {
 	if (!dev->liveupdate.incoming) {
 		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
-		return;
+		return -EINVAL;
 	}
 
-	if (dev->liveupdate.incoming->refcount != 1) {
-		pci_WARN(dev, 1, "Preserved device has a corrupted refcount!\n");
-		return;
+	if (!dev->liveupdate.incoming->refcount) {
+		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
+		return -EINVAL;
 	}
 
 	/*
-	 * Drop the refcount so this device does not get treated as an incoming
-	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
-	 * again because the device is hot-plugged.
+	 * Decrement the refcount so this device does not get treated as an
+	 * incoming device again, e.g. in case pci_liveupdate_setup_device()
+	 * gets called again because the device is hot-plugged.
 	 */
-	dev->liveupdate.incoming->refcount = 0;
+	if (--dev->liveupdate.incoming->refcount)
+		return 0;
 
 	pci_info(dev, "Device is finished participating in Live Update\n");
 	dev->liveupdate.incoming = NULL;
 	ser->nr_devices--;
 	pci_liveupdate_flb_put_incoming();
+	return 0;
+}
+
+static void pci_liveupdate_finish_path(struct pci_ser *ser, struct pci_dev *start)
+{
+	struct pci_dev *dev;
+
+	for_each_pci_dev_in_path(dev, start, NULL) {
+		if (pci_liveupdate_finish_device(ser, dev))
+			return;
+	}
 }
 
 /**
@@ -628,6 +728,8 @@ static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *de
  * Update. Drivers must call pci_liveupdate_finish() from their struct
  * liveupdate_file_handler finish() callback to ensure the incoming struct
  * pci_ser is allocated.
+ *
+ * pci_liveupdate_finish() automatically finishes all bridges upstream of @dev.
  */
 void pci_liveupdate_finish(struct pci_dev *dev)
 {
@@ -641,7 +743,7 @@ void pci_liveupdate_finish(struct pci_dev *dev)
 		return;
 	}
 
-	pci_liveupdate_finish_device(incoming->ser, dev);
+	pci_liveupdate_finish_path(incoming->ser, dev);
 	pci_liveupdate_flb_put_incoming();
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index de549016807a..acf1b38dff02 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -23,7 +23,7 @@
  * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
  */
 
-#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
+#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
 
 /**
  * struct pci_dev_ser - Serialized state about a single PCI device.
@@ -32,7 +32,8 @@
  * @bdf: The device's PCI bus, device, and function number.
  * @refcount: Reference count used by the PCI core to keep track of whether it
  *            is done using a device's struct pci_dev_ser. The value of the
- *            refcount is equal to 1 when the struct pci_dev_ser is in use, and
+ *            refcount is equal to the number of preserved devices at or below
+ *            it in the PCI hierarchy when the struct pci_dev_ser is in use, and
  *            0 otherwise.
  */
 struct pci_dev_ser {
-- 
2.55.0.795.g602f6c329a-goog


