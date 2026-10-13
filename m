Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7233BCC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7735A6B0096; Tue, 13 Oct 2026 12:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF596B0099; Tue, 13 Oct 2026 12:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578A36B0098; Tue, 13 Oct 2026 12:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 257036B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2C851C47EB
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:43 +0000 (UTC)
X-FDA: 85318128966.29.276A98E
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf04.hostedemail.com (Postfix) with ESMTP id E8C0540007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dSQ6nZR4;
	spf=pass (imf04.hostedemail.com: domain of 3hFvOaggKCNE09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3hFvOaggKCNE09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908741;
	b=iUYS/f0PlYwquvXcHoOhcxybo2YJCbrxpP+5ToEXd5KwsDPWESSJc4lEeUYVGZpECnBq40
	k1n4DDWIBaGhBZNzWjzlRYV2dN/GVwtq2BRzXxvG/GdfXQqPOFCCA0k8Pr8/RmTYr8xDV5
	tbISbxxCf1aV4kh7EsvQFl4VQ8jYG80=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dSQ6nZR4;
	spf=pass (imf04.hostedemail.com: domain of 3hFvOaggKCNE09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3hFvOaggKCNE09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMN9BXHRpANo2zxDuLk7kDAodrYyScziqIAQD0PyUrY=;
	b=w4jVZZtAw+1dnfO5kPuy35kdCHPhKzRoVnEFkLXrsP1ZTGhnQwEIxY/PNoPNVjpKnJ3Y+g
	8alipN90ym3Cq36xKIVvBAsSr8Aeyorj/rYEZrjo9IeVcNMdbwjgSzkIOu+j+pKucKb3Gd
	nntqAszsN/Vs3WLpwbavyWJqrR3FAuc=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e8e16d22d8so1032945ad.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908741; x=1792513541; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yMN9BXHRpANo2zxDuLk7kDAodrYyScziqIAQD0PyUrY=;
        b=dSQ6nZR4v19GAYzrREMOReW1BDLYD8gwdHyzPV9RWvx4C/Nx1aOrLyxDQXW0w8/hPs
         vWv4SvIc4Nl5mLP3BWK78tIrxZlNuudaN+cnoUKVa8T5/H4iDXjCgL/K6DqY9c+DBOV/
         /VjPWvNlHSn5eyG0VYEalJBzC1VAKK1vF4xPU/Xovw1XfspsL2g68zTc9BseiKWf7QWA
         mxWd0L4F7aLp+a6SHr+cpxg6SY2nbnFbaDZxOyv93oIRBKF2khMPIct9Zg4HxGSDgckk
         84FcIVsQukLdMIO79DkYNQGEjIKsZIMcPBj+AvdSWD04ZOZb0UFxzl4n1ZoZsy16YVnk
         3L1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908741; x=1792513541;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yMN9BXHRpANo2zxDuLk7kDAodrYyScziqIAQD0PyUrY=;
        b=sPfWPUpTPU+lSVy6QKk6UTleCLtvI8RihLiRHip4woFrLb1Yh6OC0rpfabeNf0rLBH
         ujYrghrZQbz43seV4C/nVN4vEuYNdkjIGQqQ65EjLZKRhV5D6bMkPxoDiE8Aoj7y2Rsc
         c9VqcXW5RhbhYaMALvOrqhDtS1cZnCZAo+AJZtWNuyOYeE5KUadL7x8SbJo8Emak1xG+
         SRDtk/lsLW8jDi5xBSPELIyAVzoK0LrgHBReVSY4ASfZl16kpSTsU4UAU+/LbsegrdAL
         T0wm1TnOuCsqURskoofXxbXuz+HizJrFVkZp1YwLQf0XeDACfcBuIldeSxVY76ok0NUM
         ZmLw==
X-Forwarded-Encrypted: i=1; AKwUvBziVZyBod3TQuZbN1+7IZaAgi5h8kfFngUp9y61mFUD7I2chlh9rQTP/mI2/dBTzmnhD9HZyIrBoQ==@kvack.org
X-Gm-Message-State: AFq9FYL0Hf1mA/vaBD0Bda0s51i6Fll4baivzzc0DVVN9Yy7LT5ZteqL
	M7utodOjTf0iAUW4ftsL6HATQxi5Sk8HjwX+SjDGAiMha8b8KoH8WGhULokTe805VIoVEa9vRDR
	N6Xrgk8nk1uQsLg==
X-Received: from plda4.prod.google.com ([2002:a17:902:ee84:b0:2e8:5201:ef23])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2305:b0:2e1:35f0:6822 with SMTP id d9443c01a7336-2e842820d14mr124713435ad.2.1791908740352;
 Tue, 13 Oct 2026 09:25:40 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:21 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-6-dmatlack@google.com>
Subject: [PATCH v10 05/13] PCI: liveupdate: Auto-preserve upstream bridges
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
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: c3d4rqyakhpwn1oq9k78htqe9usmbi6i
X-Rspamd-Queue-Id: E8C0540007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791908741-414693
X-HE-Meta: U2FsdGVkX19XvGSG76SDLvS1R1AMZJUqE4j+slFgfFJfqp8BMfTn4A81ZVhTlkSqHxoX4JAwTop/Lbsyjh5cfy9MNDtSlJyorfH/xOFJ55fXCWEjAPzGg4Di1YyVUEWWRyOcVspVOpqQFhi6lyPO0O8AIaiYAM6oHpu8ujzb+TgVkx9Ss3B9rwRzV6xX8nK5M+5r9tIR6WleTC8uWOFckedcycJSKXP4qwXQ2K5SnuU1VZD2uZNXFv7q38adOWcDbjw0aINAay6MsdJZp4DxMtJJ3aH4RkGVvzsJgl5MAIripn/E3FPKbzV4bwvmpDKyku4PrhpCfmjcRoxt/gPdhwuAlqJye0hj9b3NSo+V0bi6fMhresuMJLPSREix6P14ZtmEvZ8XhDa/D0B4hOCCY/qEllKgvIT7dh+guwUDBj0kogY+rIJlrKm+4Q+eRT/nCOEVo86yKYvb7zvoiaBWR3k5SSRWemLBxD7fIevalBMTmLE3+8egldKfqPgHm4BTYz4rYXHyM8RfsJo5IF6QQFtx3E2RBkWgqXRfqf0WieQp8P13hM7QxpsaDmv4fIGbRYdb4UqQUlVzVPmfyGgeyOTkGRAQns/I+Z2ewFhF0IeR4Ziywi6R3Ybc403wgr48tiCTD6DpnwMU892P6QtrAFOabsSo4vZ7LL23V+vxJDkubCxIgBV4c6bo6H1LhUcK7AGMImJGYpyPWqziFu4XXMX4WVpF71UOdbPjubTV1g/vUbBXE1j0XrrjnSE4d5/4k2GgV0y17fjwFPbh4XrlNtCvYfhvNQ85T9hUv5C1e0kS0t8KwbaVgOJvj9f9iGeCGK+4Nx+1JuwNFvU4799qg+mK3DFI16iWV2e4VpLa+ot1TUvmS0HHTrChjIQwSzolVcjTC//S3hOU85TzNt5D0FoZNLMkHgvLBKZPmXohmYjsKNN6RRIIxjNRCdq50AI0rbqOHyEl17V+mkecptm
 kU2Fi6hh
 wGm1JOfdrdU/D5BrjgHwBjPJACUN9+N3sHV3UBOYhtx90LlbrfJrJb0AkokPPXVFwvlM+pfXfo4pmNV5EVRtjLLjbtgrxkGOj4cPAN2W09H9RPrqqG6c5uhcSEcZEchLpQm5mxt7vkIhSgyMm/vsLZtdnY6Ph3zvIHDXdrR/4PTxC/yI81wjZATihyPs61ORWtHS5vSwg7cqGj7F72RapbpXvzyKI0mqU3blZpQHWGHklN5oo4ZWZPreQkJIwE/hROBG+xIiEel2hGHV/+KrHCXiHJ7XPflx/ROcqLWKKxD9w2kPm/mZ10SzISxH/bPIYDCzvAzHjwkZ9yg3XAGfMHMyzUNeK2G7MWKpqwS0E0pg8JPxIENuKr33/dslIb4nGqCDMf3fTaAF3wS3FHJu99mYfkCSychd9o7bXjcZWs70jowL3uONVFSA9Vmh9h8JMB4OcZagr9j7Lawsy//wTwKiJ7UnSBgzaaF4xp4p0UXcBdXBWKvAeALG0eJpQn34qfHztSBS5MI2U4wIIHXrhTYIA6SO9wkzrkgI0Tp1DpzTBxVGHv844iqfDC6OiZbHIOkLeQdM8zHjrwRz37sd7K5aut65vcd+rlCIpv2jx6RKAsNQsuyvmchdaAiPmrg44QcGcNXPhsXbpAdC+egD2aNpJS914DDTrGLltJWE21fVoPu2r6pM1ZwGSbw==
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
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 125 +++++++++++++++++++++++++++++----------
 include/linux/pci.h      |   3 +
 2 files changed, 96 insertions(+), 32 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index d6b659b346bb..bffb3e1d8b2d 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -122,7 +122,6 @@
  * preserved. These may be relaxed in the future:
  *
  *  * The device cannot be a Virtual Function (VF).
- *  * The device cannot be behind a PCI-to-PCI bridge.
  *
  * Driver Binding
  * ==============
@@ -137,6 +136,18 @@
  * bound to the correct driver. The PCI core does not protect against a device
  * getting preserved by driver A in the outgoing kernel and then getting bound
  * to driver B in the incoming kernel.
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
@@ -425,55 +436,84 @@ static struct pci_dev_ser *pci_flb_alloc_dev_ser(struct pci_flb_outgoing *outgoi
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
 	}
 
+	if (!dev_ser->refcount) {
+		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
+		return -EINVAL;
+	}
+
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
 					  struct pci_dev *dev)
 {
-	struct pci_dev_ser *dev_ser;
-
 	if (dev->is_virtfn) {
 		pci_warn(dev, "Cannot preserve Virtual Functions\n");
 		return -EINVAL;
 	}
 
-	if (dev->liveupdate.outgoing) {
+	/*
+	 * Endpoint devices should not be preserved more than once.
+	 * Bridges are preserved once for every downstream device that
+	 * is preserved.
+	 */
+	if (dev->liveupdate.outgoing && !dev->subordinate) {
 		pci_warn(dev, "Device is already preserved\n");
 		return -EBUSY;
 	}
 
-	if (!pci_is_root_bus(dev->bus)) {
-		pci_warn(dev, "Cannot preserve devices behind bridges\n");
+	if (dev->liveupdate.outgoing && !dev->liveupdate.outgoing->refcount) {
+		pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
 		return -EINVAL;
 	}
 
-	dev_ser = pci_flb_alloc_dev_ser(outgoing);
-	if (IS_ERR(dev_ser))
-		return PTR_ERR(dev_ser);
+	if (!dev->liveupdate.outgoing) {
+		struct pci_dev_ser *dev_ser;
 
-	pci_info(dev, "Device will be preserved across next Live Update\n");
-	outgoing->ser->nr_devices++;
-	outgoing->ser->devices = kho_block_set_head_pa(&outgoing->block_set);
+		dev_ser = pci_flb_alloc_dev_ser(outgoing);
+		if (IS_ERR(dev_ser))
+			return PTR_ERR(dev_ser);
 
-	dev_ser->domain = pci_domain_nr(dev->bus);
-	dev_ser->bdf = pci_dev_id(dev);
-	dev_ser->refcount++;
+		pci_info(dev, "Device will be preserved across next Live Update\n");
+		outgoing->ser->nr_devices++;
+		outgoing->ser->devices = kho_block_set_head_pa(&outgoing->block_set);
+
+		dev_ser->domain = pci_domain_nr(dev->bus);
+		dev_ser->bdf = pci_dev_id(dev);
+		dev->liveupdate.outgoing = dev_ser;
+	}
 
-	dev->liveupdate.outgoing = dev_ser;
+	dev->liveupdate.outgoing->refcount++;
 	return 0;
 }
 
@@ -486,12 +526,16 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
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
 
@@ -499,7 +543,13 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
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
@@ -515,6 +565,9 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
  * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
  * unpreserve() callback to ensure the outgoing struct pci_ser is already set
  * up.
+ *
+ * pci_liveupdate_unpreserve() automatically unpreserves all bridges upstream of
+ * @dev.
  */
 void pci_liveupdate_unpreserve(struct pci_dev *dev)
 {
@@ -528,7 +581,7 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
 		return;
 	}
 
-	pci_liveupdate_unpreserve_device(outgoing, dev);
+	pci_liveupdate_unpreserve_path(outgoing, dev, /*end=*/NULL);
 	pci_liveupdate_flb_put_outgoing();
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
@@ -618,28 +671,30 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
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
@@ -651,6 +706,8 @@ static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *de
  * Update. Drivers must call pci_liveupdate_finish() from their struct
  * liveupdate_file_handler finish() callback to ensure the incoming struct
  * pci_ser is allocated.
+ *
+ * pci_liveupdate_finish() automatically finishes all bridges upstream of @dev.
  */
 void pci_liveupdate_finish(struct pci_dev *dev)
 {
@@ -664,7 +721,11 @@ void pci_liveupdate_finish(struct pci_dev *dev)
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
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 76abe884e3dc..b35ac263c451 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -836,6 +836,9 @@ static inline struct pci_dev *pci_upstream_bridge(struct pci_dev *dev)
 	return dev->bus->self;
 }
 
+#define for_each_pci_dev_in_path(dev) \
+	for (; dev; dev = pci_upstream_bridge(dev))
+
 #ifdef CONFIG_PCI_MSI
 static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev)
 {
-- 
2.56.0.385.gd3acb90ef8-goog


