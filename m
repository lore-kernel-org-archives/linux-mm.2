Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF9BC44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5527E6B00BF; Fri, 10 Jul 2026 17:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9566B00C0; Fri, 10 Jul 2026 17:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306686B00C1; Fri, 10 Jul 2026 17:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D83386B00BF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E2C51C8BBC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:33 +0000 (UTC)
X-FDA: 84974151066.20.CABD29F
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf01.hostedemail.com (Postfix) with ESMTP id A950240008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Njixymhp;
	spf=pass (imf01.hostedemail.com: domain of 3hmNRaggKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3hmNRaggKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nXcm3EXUYcPcGCSx60NMKl0mL3TQCPUFy3rNzpS5dk=;
	b=sNYkZ6ySQQdhkVigqxWsTuThj329EMybqBAS4wFd0asVfoBIB6GWhfsQhjhdef4Jq7ji/Q
	+d1VuwnxYSWYuUDa5Fo62B1dU4hN//3AtIiA1c26mloD/sJEz4cQY87flnm3t/JnWieVqP
	m9oOkQRkzQ1seZeP8rKpXTU4dQMoP0Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Njixymhp;
	spf=pass (imf01.hostedemail.com: domain of 3hmNRaggKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3hmNRaggKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718791;
	b=FQXeAI/1oirM52SbJe7Xvfr8iG09FOeuUZegsZF4RDfFm8CIBaMlSr3W0TKyUK8T6f50/M
	fs3PurMh/chqUwn2KEdNa3SEW5q3Tj9h8LB5Q1ado61wXevZVgzgL+8erAkSVF/Hbyv15p
	3uVp+MHbMR13l/2/K6IV50JMlkBv1qU=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c6bbd0afffso24661215ad.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718791; x=1784323591; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8nXcm3EXUYcPcGCSx60NMKl0mL3TQCPUFy3rNzpS5dk=;
        b=NjixymhpIFnZCrjWlZ16lAVPm6EbGUjDrpwHEDeD9SSCuOmoR+T3n2FYg+K47ycEnL
         WDYjQhmFMMpAooDYmXsHgvlOhjK/2mCg1K8XkYd5jn5UO2PQq8xz/OHBWBIZibjmOMb5
         SFT4KTC9Eom9R2mLj4TQRGY2NDsVFfIHsUWwKUO+ELQhkChQzEaoiGyIjriL3pf7v/T4
         SeR4xh88bA7XNll2qs1Oi/7HIuO2RdOiTDsdHZA0Iuqo1ZI+A1Odz586tlTpTY7YkF36
         OCl1WyaVJbteYxvcn5XmOu1CcvjtOY7znfjeMlFlCzxQn2zoS/lhxXNKRBcsmVT9vTyH
         QbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718791; x=1784323591;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8nXcm3EXUYcPcGCSx60NMKl0mL3TQCPUFy3rNzpS5dk=;
        b=cH5IYWW4kFAV8RBUHsILZSOiPsHQAdZUdGkTCfkOlCbty3gEpWhY+d1KGzHjYTAz5+
         Tb+cTM2ZUNWj0RUS+YbXiiYS0NHtpiY2HbD4kt6OzMoJSh97h5aQQ2Af59vVdpxKmOs3
         UjnCYvtqkJkyFTL6yK87UXtrVzZk4MRIKuwRZW2vpDwXYk6cAPmmB488ng/vhWkiKM3g
         OECS7pOyYOe8V8HCI1k9O+tA4c08eYyhksI4wEs9IDUg0DQ6l6MbF1xsQUNH3xxo1dA2
         9y85Q/uSFx4bCzZg8L2wIbaHA207NdOWem6r5A/yz1NivirL2syHi1wGJa2q23TlL8Nd
         1UhQ==
X-Forwarded-Encrypted: i=1; AHgh+RqU3xxJSgzkBiuGNLV20s+iMN292lkPDYtU+/fINHZ7ik4l+0G0+tLh9ZOm25eWGmJYAg+ofWbVaA==@kvack.org
X-Gm-Message-State: AOJu0Yyn4PZe4k8DLQj1E4vC+J5j9c15Vc6H2BpbDbzCMy3yWuf45UmG
	ngvqNBJ15UkntYqHVpTyUnngg3TJFbnSnof45FX7u2Z+PjSW7N4F9mgfr/7PvAjMNXpWpB3bxHM
	5QDxjHQMyIhaw7w==
X-Received: from plal14.prod.google.com ([2002:a17:903:4e:b0:2cc:da2c:8084])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1c8:b0:2ca:ed41:d33d with SMTP id d9443c01a7336-2ce9f294803mr7037355ad.45.1783718790387;
 Fri, 10 Jul 2026 14:26:30 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:12 +0000
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-10-dmatlack@google.com>
Subject: [PATCH v7 09/12] PCI: liveupdate: Inherit ARI Forwarding Enable on
 preserved bridges
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
X-Stat-Signature: apeanbeqkg66tnypc8trhkc9iknuhqmc
X-Rspamd-Queue-Id: A950240008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783718791-803698
X-HE-Meta: U2FsdGVkX1/7s3EohNwOYrI24LRBbTCQES2c/DCWq4dE1cPWe05OaMea4j7kNmR5TlokYTAKQq8QVoChPLxX7uBFCwghJYWcjSJOKkypTIdcBB5EvKO2gWOYaV4CLRH9Pf54h6H3C/6Kv8r+mzvewbLrGKv078hmc7o4CzI6eKRwRmzkS83+yHZLI8rikiYDCfeSp7PNig1uQRe+RHCa9Fn591IVG9jhENOwYifY3JAX7TadNFr+S4rwSd7IJDLdI1X7xS2K3/CWT+39+ox/FpdPQ4EG2N9TD/zVR7gL64vP8Wi3pp9BsSkKXZ7u5Po1ywlMf4qou2jfcEM4vb+FBiHmPoJGV90G1sYz8S42Rt/96L79Gqy2XhClR0RRGLAx42ms5DQFyYxnEWkNCw3oqrb8RXwxVrIGGuAuUhckxhcFLUQFurQLGkH+HrzJ6kFlNlzBNG9psT6fzwivR10yihX9wvNiKiWicjzDxaD4ZCoO7IKFY+kRjuioR02MtLiJCnkL4B214yIav26FjYJrY7/IU1cnTEH+Sd4/Ivu2xmdoitfXqrYZpA4dUproR1LLkaZSIYaNV7HCHDy4E9RUTnrpE8x7SxmrZ9TDVdHf0pcInPu6jIO7NLw3Qu18dvsSR6XVW8SGTDsieDKd6mlFgVqnOp+i4J6TEGC7pxYa4982AbGLonse0Xhf+rchTdpwo2Bwe5m2qGtHA+ZEU4iUq7zXq8zGJ/F+eWr7uMsKKxdQl0nzLDjXG+nUzgg8zmZ502oSK3CIL/z9iWiMxXTb6qy0ieVdALDEw0+wIUcIDklhI4n9LAY/PE84w/mlKR6f3AoKdg6KpEq60hOvEbgspTreQhNNzIknWT/kvrJ4Rev6+PcBbj4czyvn+zYnkxViY6U3C+CKcZqDfH3kG3k1Oie/xCCx0Y8/0IcQrtIhBGFmou4esEQr+s7wsMPCv2N5MXWPucKkxsn/88ZbnAE
 RsSZaZTo
 V7MBomO7ZS00gtdO3u/PujkB4Z0/A46+aMwTz4xJQV02g5MyV0HSUVuAkFoAhycYgwTXoR3NwR92CQEwfspWdLbeKajN66zzVP/Dak1E6X+lP9TRkBfVrrYTU9X3H71noIua7qmaG1GELXQG0K+jou/mIXSN7AWYiVNt2aE8pxXyFyplwqeZYGbp0eylBDCwD2Zt3HUerm658dI6M5JxZDhHyOv1JixhT2hFKfBh80Yx5fnR5RHa+JeBKnIaPcWBHbssozK09ulLwg1gHqbSyaNJ5yqjBmLUCGUAL1EHoEKD5SpTzYCxlmD8sJ7tLp0+mowm7/LmbhnsNeAPL0lYLdDVEZS45h4fEjH+KRYndZw1vSM8PDSAn8PXc3JEDia6LMNoAz4LbB4vWFd2O4aGbjJ9mPqwuJrHLMF4+M15egZtbNF29sM2bUMdV+Y4pqYlHUOgtngOaMD0mIaPCZ4ql2Ecm3GwaA5MrEMy2CC1S2yQs2iiH4+yX/QDneZoTK5ofO/dlVlA0be+dgBfGR7RWLRdY9wUgY0iIPvBFkrdzmV+qVWl3lIYmPlXg0+gX3xgZTwU/aznYEIS9ipXZ7ijclKy50A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inherit the ARI Forwarding Enable on preserved bridges and update
pci_dev->ari_enabled accordingly during a Live Update. This ensures that
the preserved devices on the bridge's secondary bus can be identified
with the same expanded 8-bit function number after a Live Update.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 18 ++++++++++++++++++
 drivers/pci/liveupdate.h |  6 ++++++
 drivers/pci/pci.c        |  8 +++++++-
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index a95bfe5eff77..74a11e520f0d 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -128,6 +128,10 @@
  *    way after Live Update and ensures that IOMMU groups do not change. Note
  *    that a device will use its inherited ACS flags for the lifetime of its
  *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
+ *
+ *  * The PCI core inherits ARI Forwarding Enable on all bridges with downstream
+ *    preserved devices to ensure that all preserved devices on the bridge's
+ *    secondary bus are addressable after the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
@@ -816,6 +820,20 @@ int pci_liveupdate_enable_acs(struct pci_dev *dev)
 	return 0;
 }
 
+int pci_liveupdate_configure_ari(struct pci_dev *dev)
+{
+	u16 val;
+
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+
+	if (!dev->liveupdate.incoming)
+		return -EINVAL;
+
+	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
+	dev->ari_enabled = !!(val & PCI_EXP_DEVCTL2_ARI);
+	return 0;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 4e8a01bcb4bb..6f21ec50927b 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -18,6 +18,7 @@ bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus, struct pci_dev *dev,
 void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass);
 void pci_liveupdate_init_acs(struct pci_dev *dev);
 int pci_liveupdate_enable_acs(struct pci_dev *dev);
+int pci_liveupdate_configure_ari(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -46,6 +47,11 @@ static inline int pci_liveupdate_enable_acs(struct pci_dev *dev)
 {
 	return -EINVAL;
 }
+
+static inline int pci_liveupdate_configure_ari(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 739ecaab2e76..e0c133b66a35 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3528,7 +3528,7 @@ void pci_configure_ari(struct pci_dev *dev)
 	u32 cap;
 	struct pci_dev *bridge;
 
-	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
+	if (!pci_is_pcie(dev) || dev->devfn)
 		return;
 
 	bridge = dev->bus->self;
@@ -3539,6 +3539,12 @@ void pci_configure_ari(struct pci_dev *dev)
 	if (!(cap & PCI_EXP_DEVCAP2_ARI))
 		return;
 
+	if (!pci_liveupdate_configure_ari(bridge))
+		return;
+
+	if (pcie_ari_disabled)
+		return;
+
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
 		pcie_capability_set_word(bridge, PCI_EXP_DEVCTL2,
 					 PCI_EXP_DEVCTL2_ARI);
-- 
2.55.0.795.g602f6c329a-goog


