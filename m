Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE12C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01556B009D; Fri, 18 Sep 2026 16:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1CE6B009E; Fri, 18 Sep 2026 16:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACD8C6B009F; Fri, 18 Sep 2026 16:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 240E46B009D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:07:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DC2E407F7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:01 +0000 (UTC)
X-FDA: 85227966642.23.0541366
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf24.hostedemail.com (Postfix) with ESMTP id 857F0180005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:06:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h6adBFOO;
	spf=pass (imf24.hostedemail.com: domain of 34pmtaggKCCkIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=34pmtaggKCCkIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762019;
	b=dBqm6t5WKgXvJ9JVCtChyk+NWSfOe14DiUzdAX0/6hQbdiUo00R6gKk5KIUm6ajX+JPf51
	y2285YrrmFEhZhh3HL3yHZPzVw/DAApk/bHy4evN8daGwjZqdLxcAEZKfbrt0qEQHbyR/A
	nSs3RDhMsxmOUnjGAylq5xHcmx0G6Pw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h6adBFOO;
	spf=pass (imf24.hostedemail.com: domain of 34pmtaggKCCkIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=34pmtaggKCCkIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSbW92ll6VraodQnupXl7opG78OubPyViHFwv8TLCbk=;
	b=8d0xXEplEbQ2U+lhIcmOWG9KbQ3GSiGcEN2g9pCzo0SCr6zu1r8rLe7kYHPRO421oM5LfF
	BGRbfoheKpkqqd1lEEo1QAOlErkCdkqwvmWOHvilvv9J/SxNeiBZ+5/DLqlhDMhy29EkyN
	8aPA4dxYQzBDJjviEIo2ZH9qIKYyVMk=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d7443e0f0bso21110805ad.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762018; x=1790366818; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YSbW92ll6VraodQnupXl7opG78OubPyViHFwv8TLCbk=;
        b=h6adBFOOZDbZkFmVSvAqU0BIRyVJZHvDKlWIL2MNl63vAWP+zaeM+a4XSsjR4Itc+S
         u5h9ZN1AAWLwN0srZ9rV3XZDVkZxbFVq6Bfgyf5CT6+dRFGY2YjJP883FGfDsqJIGfAV
         ngslDakWMHGp7WbdTRC7TYwWz7oNgbhRFfJh7yT7Rqk7VqjqSmKZ99GNxo+/UC2Og2N8
         wNsf3fuk/ZH+fWRcwbxqQbi6ue1CGkl336R8B4Bvkny6FaszAvyDXKvx99s1qfATit3e
         XBUeCB9/t3Cul5euekZnrCi+nLQwzFNpmdtcFpT1ez7Ds2CXBPMHP/UJHKhyus40yCw7
         FPyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762018; x=1790366818;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YSbW92ll6VraodQnupXl7opG78OubPyViHFwv8TLCbk=;
        b=dQl+2yChEp450qXR34hHWLco7iXskosrdkZRecvjjvuFnd3iGH6U5nTdGAyQJI4LzJ
         wI1w0ceE9Mt/YOy+TRSWaFiKxpgvtO9AlSgsCSFWcl4VkBerCon5OeL3W8Eh75Jud6++
         kX8dkCoIkEhAaX07ON6oc78iMv1Rie0oZ6qXImgGGFt1wtjc7ipFT4BTFyzBREiwG3vw
         KdYVLoyrONA2p2Kaiqvsk0EeEPVGe6gLIZBW8nxtxuEsivbklpsyhw9zuxAlnCMWCmXW
         liUlveCp9wuX7P/5lxtQtSgf2Bl5fyl4V5EDbJdNt7HJ2gS1ZgXkIRAccv+0c43OXOfO
         +ReA==
X-Forwarded-Encrypted: i=1; AKwUvBzoxLhmHFTdYvmQf0nMHHvDyNrx2IdJAOET/qk5P7vKvJu/DJXtwvyQ4HuFKzQOQYDKqJbquASVyA==@kvack.org
X-Gm-Message-State: AFuF++kppFxNC38/VHNpF/OHaJdLVy5txZH0+7EKnP4Nw1SgACHOHBMx
	VVgZkfAdUDppOOu7bGOtjVoKZWr3aOnZXhHnk+LSYB03TXsAVZMZqYFNHDRc0oPv4ZDSZldb0e7
	RuNm5DOeqeozcJQ==
X-Received: from pgbcn9.prod.google.com ([2002:a05:6a02:a89:b0:cc1:be9e:35ef])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4b28:b0:2dd:c100:a5e7 with SMTP id d9443c01a7336-2ddc100a6e5mr8872815ad.59.1789762018048;
 Fri, 18 Sep 2026 13:06:58 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:31 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-6-dmatlack@google.com>
Subject: [PATCH v9 05/13] PCI: liveupdate: Auto-preserve upstream bridges
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 857F0180005
X-Rspam-User: 
X-Stat-Signature: 1ebety89ikm35nyymmo7r9rqbeghaw4h
X-HE-Tag: 1789762019-372249
X-HE-Meta: U2FsdGVkX1/j9eNiy+mC1Yqo0urdZHrMRSmCaB1+ttOAmavdwTRmOvWl5B0A5gqN4N+fsQrtqlnJNrSXbd3YF7ajTJ7xNPkW9ny65EWvo7eZFfDgTYPXmvmK+nCLctK+GydGW/tnQruHxIo1SKNOT4WdT5pzGBc6GEIjSl+6din/rWH5OR0EO0IIn/JPRrwcdbaRTK80CFabyk+vuHT4L6QPwI6R9mJqaTbf0YGoev3qcIUosfhnYXLGOUaDDRS01apFXUd/eDnQEOw73opaXo1EtKwVDmymXH3/aqEWAbkKWcxHs05xDmrjOqNQELhvcYoshGk0w6y4a6avsP7LzS0iCKYrwlp0Tz2rXYpqC9fiSYDJCgp/XzlAiLZtrLK7U8x9N/fD5+1bHE6SNdeIeQUZiR3kkp5MtFY9XTFPb08Hf/tpm4q1UuLRo1VVbn9NiU6L+/1yxY4Elze3RquIs+dr2nJaM//0R8CBtGlM84UEoijm5hBAD9ZSHTFrFH8lWpLNwTP7CP3YVRHiJpiO0WpFxxpMLh4n79SvArGE90ANDxvr31YJKgKgMS+CjRpxO546R9UjaG79+uea9zgOYe6zKhcDtpmIqrHPSKlJCxdAa31nKZCd6Fb1XBr+8MomVcTp0GcJ04pf6gXL8228QWrOShELzyKWrO78cjjX32RjIdmKtimQBgq87Dty12jhRuxtAK5VnavU5UeFypzB0QahUdTm3fP6MIgFSTEjF8Ft3FWaoYJluZyfqY1lserkNX4dC9lxe6uMa0t9qrMw2F0mJU6zfLQVidCmH1sOJ0crYia7oNECPMNzYX7+g/lW6oKT0N9wSWpvL9pifLZkobK8SAJFKoGttqu4lgzWGSmBN0XjA/oC3NtUTOZxRb0P9SuuyGP+dY+FWpuTkR3avtj3y15cGPfYftPWO5Bm5rO/0Gmc7ZmRQJne0ExaE90mWBPO+VGMWD0HOBGMxTM
 YeyLAqZv
 KjT5ac6ucITNRKKFc4K0tbH5dFAZK7/lFmautm8vdQzTjXYUUW8OascVPoIgHjwtF1Y2kHEW5HiXSeMYZs7acvyLXtkkMkz5Q7KKnIssgfyqA4KYqngit7zZfwi/7Jl+gsmaciFwzkUTxeLxifvrC7UrAiMtS2/7RkbbmHHu9cSbXsNv+ivxPPtDgRJ5b53Dg6hDkJCujAQs4IDm7U4OEvXeBd4DKlb+J4BOdS7vx5rgj1Yr2Zb1gnmjkDKubcmN4/TDJmvuNSqgZnWvIODHa1FxC3pweWh8P+sFJsHKPzBbJfg3HkMOnclwAdDT03cP++RUIChOcsimAWwWci9qfNnG9Azkqh9a1P8jMCLTTiS07/d6SQaHejKZHwCycQDaUXw8/F6spTRVII9EujFR61o06iGNN12ss8vHwPXWgv1vD6zB1u4qcpue6mHNqXuUOCrxwiuzLKmiv5Z0PSxnRGoQ7hD1JiYwcUylj5WgvxaKZLbpkdMmtALJT5Y+ahfDNJFAEWAYvKqF1sOeff6Q+61oufzRlznkCpX53Nes3gFdzSMy/VKPBKllLHn1j1Bf8f8GBQLrsPaYcp+3QwXhc+8pz3jdKVQoKyU6GhAbGSzW1+hxUAFM7PRMzuC2QdZxr0n6Brq9GDBU3fWsa3/nhhYC8ha76N6Q+4nGYD0i83tUVwNZzMbL0XEYDVw==
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
 drivers/pci/liveupdate.c    | 125 +++++++++++++++++++++++++++---------
 include/linux/kho/abi/pci.h |   5 +-
 include/linux/pci.h         |   3 +
 3 files changed, 99 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index ec8db86ed66d..825df024eec4 100644
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
@@ -407,55 +418,84 @@ static struct pci_dev_ser *pci_flb_alloc_dev_ser(struct pci_flb_outgoing *outgoi
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
 
@@ -468,12 +508,16 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
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
 
@@ -481,7 +525,13 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
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
@@ -497,6 +547,9 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
  * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
  * unpreserve() callback to ensure the outgoing struct pci_ser is already set
  * up.
+ *
+ * pci_liveupdate_unpreserve() automatically unpreserves all bridges upstream of
+ * @dev.
  */
 void pci_liveupdate_unpreserve(struct pci_dev *dev)
 {
@@ -510,7 +563,7 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
 		return;
 	}
 
-	pci_liveupdate_unpreserve_device(outgoing, dev);
+	pci_liveupdate_unpreserve_path(outgoing, dev, /*end=*/NULL);
 	pci_liveupdate_flb_put_outgoing();
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
@@ -600,28 +653,30 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
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
@@ -633,6 +688,8 @@ static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *de
  * Update. Drivers must call pci_liveupdate_finish() from their struct
  * liveupdate_file_handler finish() callback to ensure the incoming struct
  * pci_ser is allocated.
+ *
+ * pci_liveupdate_finish() automatically finishes all bridges upstream of @dev.
  */
 void pci_liveupdate_finish(struct pci_dev *dev)
 {
@@ -646,7 +703,11 @@ void pci_liveupdate_finish(struct pci_dev *dev)
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
index 4096e3cd3324..9485ed73c351 100644
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
2.55.0.1082.g2b9226bbc0-goog


