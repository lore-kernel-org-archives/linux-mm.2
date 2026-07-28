Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6842C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF3026B0099; Tue, 28 Jul 2026 18:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D286B009B; Tue, 28 Jul 2026 18:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6AC96B009D; Tue, 28 Jul 2026 18:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 871666B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E5184037C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:29 +0000 (UTC)
X-FDA: 85039580178.15.937A202
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C9D6100005
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J44IH5Ki;
	spf=pass (imf14.hostedemail.com: domain of 30ShpaggKCCIBK8RJ8AIEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--dmatlack.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=30ShpaggKCCIBK8RJ8AIEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjiHFRrRxhVwa1Pq0hgmaBBv7pUGh9bn9sVXjLyQZnI=;
	b=g4Ew5wuBQJXgUTKqA2YBgbrQxdKoRJSVmo6eHFCm9tK7wkZe5nvMCsICcc5ErZ/1U6vzmz
	EXj+sicHoWq4MCj3dWF9gYmyzcNezNAa0aMT+Ki9qXkiLHIRT+Z32nzSAynx9F8NFoiwLT
	UmiuW+KfVSz0HBLjjEkCSjyzYimZRUE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J44IH5Ki;
	spf=pass (imf14.hostedemail.com: domain of 30ShpaggKCCIBK8RJ8AIEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--dmatlack.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=30ShpaggKCCIBK8RJ8AIEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276627;
	b=tVVkXAdW3Vtt5oydLKJelzVkLFPnZbSBnJuy7xlRKIKnOYjz1+1rLTIA4tPR4cAs51zMKT
	tFsC6GLD/OF5lFEHbHG8BKk8r3uYKfLnkwtO3ifu0wEkQqgpsKaYaIQWzy75kFNy9sFvKU
	6xNFudqKW8MfLlJBHmtRLugn3FY62mE=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84e048a801dso414428b3a.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276626; x=1785881426; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bjiHFRrRxhVwa1Pq0hgmaBBv7pUGh9bn9sVXjLyQZnI=;
        b=J44IH5KiI0qzRBgaiWAX+lQSh6BK2J6j+EuZKdTn2x7hizSbDUxTZy19YfVJOH+GcW
         ltXQwA57eQvSl4y2yKIQvUcw9WhhjUZ/or+oUDipJ44/zmumoiS0bO713uWThryhRXi9
         mfazvcdj7H/3PStttm4QIklUCp2T9+vAK72syW7xQzc1iqVVq5MJ6D8N1N9R1c3ixn0h
         co0ogjNCjKofnkSEf+ByK3oViP1ZyQ7vUwWc5DZpe3NUHSybj9UrWRP8aPd3rLh7sJV7
         Dh20zoTtzIpV+sC+s3FOCiQmRS0NF82E1RzW4GeVUvayL6rgnsQmn/k6pyua2nDxF0HN
         Q1pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276626; x=1785881426;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bjiHFRrRxhVwa1Pq0hgmaBBv7pUGh9bn9sVXjLyQZnI=;
        b=NCjo4i1yvQoAkp+mrjqr8cQsMmGNmFVAZxZ/FPazxD3KKX4WCr3DnJNPVnXhSplhsT
         sMGLkKNhcLWGkTGg87AK2c9Q9oGj5gYKtsaENc56Q5nJ22cifok21Wx44AoN2LYKXoe6
         fHW53zVQgKPRorsicCkBtYx30KTZdJlzjhltZoiXnmOPC1M1EHzr8UEK5hS20rpJYyl4
         aTzNH8ICenp2QErhoZTMSL98EaX+UTBAVfnkJ8YrhcG0pa0qkWxlFDUHs3floBMKFFew
         FMjB2w82um1NedNzx6y5lvaw/79GyV/F4Xz5VMi1yRGfBm2ooXYNFh88CQkPEuMZX2PQ
         MOVw==
X-Forwarded-Encrypted: i=1; AHgh+Rqlb2CuUDlrWcY1BnzRcUlUd4k4vKh/RWZhzO8QDb4HA/ua5WsEyklt924KuJS3pGx6rfZh7JBl3g==@kvack.org
X-Gm-Message-State: AOJu0YwHPy0lXH2ep5aCEIvtDcvNrF5BhXFpssu94jAgZXVROq9KiwHU
	IV06NIA0LDr0GZrsbsWEYJCl2JsXiRwx+pGCKx3f+Qbcx3abDxgA38Wp8Q+AuoXcFboOn11JD0Z
	FYjk9Bx/y29GwHQ==
X-Received: from pfhx33.prod.google.com ([2002:a05:6a00:18a1:b0:848:4f56:7671])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3a23:b0:84a:2fc1:da38 with SMTP id d2e1a72fcca58-84e933d61dbmr4308330b3a.58.1785276625807;
 Tue, 28 Jul 2026 15:10:25 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:10:00 +0000
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-7-dmatlack@google.com>
Subject: [PATCH v8 06/12] PCI: liveupdate: Auto-preserve upstream bridges
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
X-Rspamd-Queue-Id: 4C9D6100005
X-Rspam-User: 
X-Stat-Signature: mqkguyjcqdbptucp3i4rbb3aqtcp78sp
X-Rspamd-Server: rspam04
X-HE-Tag: 1785276627-247305
X-HE-Meta: U2FsdGVkX18LjIchqgfedvkmkCl3+JYq+fUPsYAmIk9SpdK6FV6/xc6vzcmzzJHTxSzod+qC3fNPHsOM4fOq9CV0nM3IQuR6OzWuwDUNoevIQCax70k88dr/fe7EzMgiCIs1coA4XEQFfy8EDptmSBZcC4kku6HAr5EHoPme4e6KrQS57x8sJCzW/LbUkkVRGHU5hLIOPMDvaPjUWb2wTthqalIBHopPX/Nc8XQSWr4jIn8GgsLzuqDr9D8vHHyC7ibY+HhPChyNC6nJQewZY4Jzn9c+Sf35mIQZFZca4TbdwEtneq4rWuC136B7aK/tTTQsCeCWXmUePd63TEoJPmSORwdFUQeULA/QvBcuPX5/Glxraa1NT8IQrNCHE7Qp117BceBJvTbrtSqvLAIcEGDNIkqvFJxit6aF51Kw8/9E6ACua55WmJFRDy3zVbGNE/VwhiGbK/2bKMFMtsyQQR4SR4YRFGCGrLjaD4553esKgCRuphjGK8YljQ6WK5JNFunxVhMtnrPO5B8vUPBkL1R9BgXROgWILsY2tMfVhBDJqUVFCdgWhSSsEci6RmbuwMQpyRGwax8q8uwGQ+2xubLVl9jUi508OgCw9G9OKKQ0UE1XEwVCkyFt7StjOnjInLhyk0qR71ahbOego2bx4Y5JIgam+O8jm9KfvRYKnfNYQadLJpQ49v9IEUOdHql14VZVoVN96K0dt5oD7BDnadiS9jgsxzzids2GImgwJU+4b0lV2exmKH4Gnrrf3EpKGZnEjMnOowrSp1IEFwkWzUsepMngNoZM7ZuEO6IWLvLKUSIlzrMYiW4FuUa+7NJD5iP5EN3+fohH0ZL2e/fblwq1xOdpCNNjwExGEVPX5M5avtSiDS/mLYHl57nDiwFps3dv9UIZKIrELZGTX9ETAaTgp8UZrWLxUdjKFEBBT5ygXMeqcmk0IOO83AvWGqMAzVDR8MEcH2rzYwewfmM
 a9t27lDY
 6sm7qnwQIjW91ZIwJQzm26lbM80Jj5MJ7Wz0uL9GZybdczHNai3KK31LFPZAL3/7dODxRJ+ltstz2GGbCpgssnBBbN3RAgxwgJuFw6A1/R6ZYUJMHxV/yVOu9XOoSUwFRCPl7OczHCH9MWJKcfMgCcHne81qqtcGmhoTTH4jUFnwZW2nDOQ63EUWzCEyjt4pJC9dDaPwR1dSStksuM9sYJTez1jvj2g2D4XJodnpod68LuIrThX2QNDMUoMyRZEKbSpmzM1pxYPZSB/nnwFTduLr2M/5xw2wsEWX6GPPJX1QEu9IALBSP7sBjkjXsaON9VglM9Ye47i+cHfLLNxzhobOCxBHx8rBTnIcfIWXoWFi0nwoKwdogHY8Xv8JSH18Hp/Na1nj2WHofBgxiT+KK+qEistXFjeyxkXcTivDGnZ07GQ1CTcFY7RRqF8czPNgrItyuT3LjwdnHJd4kwLhOGe6aqr6vDtoJ5Dy+8V73Z2W2NxHesvMsP6J7LXvK8PNdg7dIncUcZGNbAHdffIbM2h0r+Oteuq4mqJkbzucKRPatg4AVueupfO6d2gtBSKYwx735wZyil4O/kETdgug3rFZt8UqiggYYct6bAbWIup7cR5Mtyenw4qANd4FnfmTHBhpl/oFeaBXbknnW1KVdKTot1/Qs0OPDDVCWeH5EAsNbJVLcMmPytky7dQ==
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

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c    | 110 ++++++++++++++++++++++++++++--------
 include/linux/kho/abi/pci.h |   5 +-
 include/linux/pci.h         |   3 +
 3 files changed, 93 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index d312381c9e10..08e5ff8c1fe7 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -70,7 +70,6 @@
  * preserved. These may be relaxed in the future:
  *
  *  * The device cannot be a Virtual Function (VF).
- *  * The device cannot be behind a PCI-to-PCI bridge.
  *
  * Driver Binding
  * ==============
@@ -102,6 +101,18 @@
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
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -358,20 +369,42 @@ static struct pci_dev_ser *pci_flb_alloc_dev_ser(struct pci_flb_outgoing *outgoi
 	return dev_ser;
 }
 
-static void pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
-					     struct pci_dev *dev)
+static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
+					    struct pci_dev *dev)
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
+}
+
+static void pci_liveupdate_unpreserve_path(struct pci_flb_outgoing *outgoing,
+					   struct pci_dev *dev,
+					   struct pci_dev *end)
+{
+	for_each_pci_dev_in_path(dev) {
+		if (dev == end)
+			break;
+
+		if (pci_liveupdate_unpreserve_device(outgoing, dev))
+			return;
+	}
 }
 
 static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
@@ -385,13 +418,23 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 	}
 
 	if (dev->liveupdate.outgoing) {
-		pci_warn(dev, "Device is already preserved\n");
-		return -EBUSY;
-	}
+		if (!dev->liveupdate.outgoing->refcount) {
+			pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
+			return -EINVAL;
+		}
 
-	if (!pci_is_root_bus(dev->bus)) {
-		pci_warn(dev, "Cannot preserve devices behind bridges\n");
-		return -EINVAL;
+		/*
+		 * Endpoint devices should not be preserved more than once.
+		 * Bridges are preserved once for every downstream device that
+		 * is preserved.
+		 */
+		if (!dev->subordinate) {
+			pci_warn(dev, "Device is already preserved\n");
+			return -EBUSY;
+		}
+
+		dev->liveupdate.outgoing->refcount++;
+		return 0;
 	}
 
 	dev_ser = pci_flb_alloc_dev_ser(outgoing);
@@ -419,12 +462,16 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
  * pci_liveupdate_preserve() from their struct liveupdate_file_handler
  * preserve() callback to ensure the outgoing struct pci_ser is already set up.
  *
+ * pci_liveupdate_preserve() automatically preserves all bridges upstream of
+ * @dev.
+ *
  * Returns: 0 on success, <0 on failure.
  */
 int pci_liveupdate_preserve(struct pci_dev *dev)
 {
 	struct pci_flb_outgoing *outgoing = NULL;
-	int ret;
+	struct pci_dev *start = dev;
+	int ret = -ENODEV;
 
 	guard(rwsem_write)(&pci_liveupdate.rwsem);
 
@@ -432,7 +479,13 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
 	if (IS_ERR(outgoing))
 		return PTR_ERR(outgoing);
 
-	ret = pci_liveupdate_preserve_device(outgoing, dev);
+	for_each_pci_dev_in_path(dev) {
+		ret = pci_liveupdate_preserve_device(outgoing, dev);
+		if (ret) {
+			pci_liveupdate_unpreserve_path(outgoing, start, dev);
+			break;
+		}
+	}
 
 	pci_liveupdate_flb_put_outgoing();
 	return ret;
@@ -448,6 +501,9 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
  * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
  * unpreserve() callback to ensure the outgoing struct pci_ser is already set
  * up.
+ *
+ * pci_liveupdate_unpreserve() automatically unpreserves all bridges upstream of
+ * @dev.
  */
 void pci_liveupdate_unpreserve(struct pci_dev *dev)
 {
@@ -461,7 +517,7 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
 		return;
 	}
 
-	pci_liveupdate_unpreserve_device(outgoing, dev);
+	pci_liveupdate_unpreserve_path(outgoing, dev, /*end=*/NULL);
 	pci_liveupdate_flb_put_outgoing();
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
@@ -631,28 +687,30 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
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
+	return 0;
 }
 
 /**
@@ -664,6 +722,8 @@ static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *de
  * Update. Drivers must call pci_liveupdate_finish() from their struct
  * liveupdate_file_handler finish() callback to ensure the incoming struct
  * pci_ser is allocated.
+ *
+ * pci_liveupdate_finish() automatically finishes all bridges upstream of @dev.
  */
 void pci_liveupdate_finish(struct pci_dev *dev)
 {
@@ -677,7 +737,11 @@ void pci_liveupdate_finish(struct pci_dev *dev)
 		return;
 	}
 
-	pci_liveupdate_finish_device(incoming->ser, dev);
+	for_each_pci_dev_in_path(dev) {
+		if (pci_liveupdate_finish_device(incoming->ser, dev))
+			break;
+	}
+
 	pci_liveupdate_flb_put_incoming();
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index d4881c2d2fc9..aecace02d8ac 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -24,7 +24,7 @@
  */
 
 #define PCI_LUO_FLB_COMPATIBLE "pci"
-#define PCI_LUO_FLB_VERSION 1
+#define PCI_LUO_FLB_VERSION 2
 
 /**
  * struct pci_dev_ser - Serialized state about a single PCI device.
@@ -33,7 +33,8 @@
  * @bdf: The device's PCI bus, device, and function number.
  * @refcount: Reference count used by the PCI core to keep track of whether it
  *            is done using a device's struct pci_dev_ser. The value of the
- *            refcount is equal to 1 when the struct pci_dev_ser is in use, and
+ *            refcount is equal to the number of preserved devices at or below
+ *            it in the PCI hierarchy when the struct pci_dev_ser is in use, and
  *            0 otherwise.
  */
 struct pci_dev_ser {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b41dd572a2d6..6267c83813d5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -829,6 +829,9 @@ static inline struct pci_dev *pci_upstream_bridge(struct pci_dev *dev)
 	return dev->bus->self;
 }
 
+#define for_each_pci_dev_in_path(dev) \
+	for (; dev; dev = pci_upstream_bridge(dev))
+
 #ifdef CONFIG_PCI_MSI
 static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev)
 {
-- 
2.55.0.487.gaf234c4eb3-goog


