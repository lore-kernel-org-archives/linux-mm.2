Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78BF7C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A066B00A1; Fri, 18 Sep 2026 16:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D117F6B00A2; Fri, 18 Sep 2026 16:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFFF76B00A3; Fri, 18 Sep 2026 16:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BBD66B00A2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:07:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D72D407FD
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:05 +0000 (UTC)
X-FDA: 85227966810.11.70B0971
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf21.hostedemail.com (Postfix) with ESMTP id 46DA01C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zl2coNKG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 35ZmtaggKCCwLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=35ZmtaggKCCwLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zl2coNKG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 35ZmtaggKCCwLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=35ZmtaggKCCwLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762023;
	b=7Ni4aM73Z6CGapz30fWbQQVPhaYQz7cJlqo9haCo151v4jQ9vOCGtq5NPitCSWNugeWvAj
	8Yj37kYu2losRM+S1S3MYzNeLRBvJG7tcQ/XA1PXdGOIlHmwbgbsdaq5ruB89gZ0ibrskM
	O1ATj6la3PmmhY/0HQxmtgu1N5snzIg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9BR71s6OXVqtI8pG8LyTaxh9Qe5FvWSAHHddp0nR9J8=;
	b=NH/XI9YgrnEnUDkjBxzcliZvyYOA79VCEgaiAghO06Utq9oV9xi86SLlfj6uzcJdv2KCbG
	YrvvtJQR3jJqZ+lxNb0+5yc0eX36yBFD7bYXjd35K3KQ2pdoW6M5ZrD2iHeWotM7EPOsgP
	B7zbyjqIqosCQ5PBKAHTJ0X4JOCoHzI=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2dd753a52bbso20145595ad.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762022; x=1790366822; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9BR71s6OXVqtI8pG8LyTaxh9Qe5FvWSAHHddp0nR9J8=;
        b=Zl2coNKGxRm6iV9Ac/rp3WWOk16BLiYb7RkvNh7mlQGWcc6aFqfBBX2r00rfcx/HwX
         IcUReKveHTsKFnDJF/NbvspLKn+nUpz+1RJlJCciGnj8MhMHULtazd1maLb/vHmxHwFp
         aWOiQwchjeRVEMu+j2jEmCc4U3ODgdcFQ2OKyPdghB+08FcSHX3KcwfXBb4EiaSeVQyy
         3HgLPtB/QG6Gw34upJMQb4ideahgDogyEvJp+95y5yNIBegkssQ6TmvakeOZBXx+0Y3/
         RwTTflYgq89cc0PU6zWUpcEKB0Hlm4PfRVM5AdFZO6nyaTCntA+LeBRr3QfnOL3D0omj
         6kFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762022; x=1790366822;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9BR71s6OXVqtI8pG8LyTaxh9Qe5FvWSAHHddp0nR9J8=;
        b=MwtnaFkABdadkUJ4XUGkXXKLzHQ2rex3bgn3czVeEoWuPS/Jg1P2naBoLiv3xMhmV7
         Bg9b6+HJ+imiOhvqIldCcNR8yow/+px4LY5fosCCtGVC4SxrWMxGJIKC5SSS5vGd/FGb
         SX+KZx7qsA7P0SXv+NkBj/cDYXhvaOWU6rHWn61SZZ3zsMW42mgfwggVBQRDKkUt/pfF
         TFSGB59mxMqpcgJKetdbYoW3RuzbSbxmVIF3sHSfos3XXMoT7mOe/mwY1AWgO99LDXc5
         YRflSg6Ro51YCpDhwrjiohWY+LRuKLeHAghCpxerpSxfu7BycuGdqyXH+DJShhWUNrUM
         woIg==
X-Forwarded-Encrypted: i=1; AKwUvBwZmuOQc5BnF1OkTV5hF8M+ihBhPBDX+FTEtR7Q4XW2r3UpaVT3F4HAgAmcs0r88zKsZKXUC8i4Xg==@kvack.org
X-Gm-Message-State: AFuF++lJabcckGwHjRSSDmT8CJzZoFLJttB2I8yRQYZC1IdpKeVvgop9
	d0cyIltFXdkxqG090gU3QXsFqzfEOR3EMutS7PaoGd7F4jqTU+xQlPwQY7bvQ7FMoIf6cexGKPW
	A5tO/WjFiwonvjQ==
X-Received: from pldv5.prod.google.com ([2002:a17:902:ca85:b0:2d9:e5f:1d26])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ab8f:b0:2dd:c100:a5ea with SMTP id d9443c01a7336-2ddc100a6aemr7241285ad.62.1789762021877;
 Fri, 18 Sep 2026 13:07:01 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:36 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-11-dmatlack@google.com>
Subject: [PATCH v9 10/13] PCI: liveupdate: Adopt ARI Forwarding Enable on
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
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 46DA01C0003
X-Stat-Signature: er8fo7h94mkapqhpsb9dpa7xwmcpsdxm
X-Rspamd-Server: rspam01
X-HE-Tag: 1789762023-390006
X-HE-Meta: U2FsdGVkX1+WC1NsMy7PxyqI4IHIKyYLlY27C0DbIucDLwStwV1SCw2xj4aAY8iKdFgVHkKKE33eEbMAKxoEkK8P1jj7KkPMkOlkjY9QkJ47DXxBhqMq3PuaZF0XdAuoD8Ew7MLRWhgdqiqnO0Nh1i6MLyHvwmYW7ps2XpzwoO6SQvz9Hq066f9RxGDIp4N/vyFvO2JPiot1eZVpWDFHGs6jso982xMKiNUHSxnD7IrRcz1Z0kldWqdz5giR8G5i7U85nVbaBNth9PKbYd3Q1yAIUnc70xCqdMqrTMjZxlyrpJ7sdR+mmjoC7ZJ2mkx298c4QYob65FC1UUTmUdyn/QbZaxOVTlJnbr4GFK2azFwFtaH4joorx03Xp5ZeQCtRRCtSYVbltzAW0sI20flgzk4Jp/+wskBZSwccef+EdAjfMJtMYupGqAoKbpzypY4K8of9DLlcrF8nJa3zbqn5lX3a3FHcyGlQ+2aDgcxWHLXKWP2VK9sO+yVaNAcYJ4RimZ9lVfRWOJrjfU2ilIjZYdnKqYxFaknf5tAHw5J3DZDcLUCz8T4niX7vJNxwTyzF68Nflq7y2mAlCLhIPC+DFV7XsZSzlE9kIKeyid6VFs6XGrrZS7hTGoR5DFXXUJAPB0mMCqTkPhVnf0Dy6eui3FdtS2zRf+9GpfoV/eycLWTCk1H3IAaDOX8GJHAy1OSY8Nq13GrlOKB8jbHjhT555fXAwvT0b9PH4cSxdrLNoL/3fIbSLsbllh/xmMfz0+4uNT7/pK1HZPQPardo01hifFWj59ANdiskD7b4jDKknEkKJD94oqs6VauTFQqmaQhAC4kI4B+/Q/NaMNBiUEzQNgM5VVvkpuT5FCPjHR2ylQ5WPQMvYtMn3SrzBmeRYrk+gRXhlCKAMwFZK3XNq2Xe+NGyZ0wKRGSdgdD40H/P74w+WmbbtvTTuyc5o4IGlZ396oJgBbE//mwp1P29dQ
 AyswHary
 D0I+yOxY61nqr6oD2mkYS6/4oreTrIX9zjl0H7yX250fB635RKs2cUbCvCRYlNHcHHaS+BfaG4ClYuqs8WbA9OdmOBVG7cpfyz+S398X6vs90bO8cId51TeP26WRHVnqi4YOofvViPV7EKGx7mpTDoysyDVfzIRu1UB3k05KWlH/OFPOFeZPb0OxvItroxvjhiFiSvDUjLd60Bq3EAZTEezFgViTDQULPacUYssFGPSYxN3tuDylIW0VwDYYE9RZxkUvEKwBpOQy18iBhBhqrp4MTI2OkISdWtlYPJOosZvJ3hnTg/LCeKn2yPoZbfvUAzhVDilwbXNH84RHkc0BI4+0eOQk1hEesoR5pE8FrdnNYCcVbf9t0b+PEOqlvWhCYM8W6vfxr5RHCncDszVRqP0c8S0k2cE1HuLbTgc04gwxy1NuLQj6ug5fGlh2+MyuEZ17LmE2ezooFysFb97kdYus+FmrDDx5rtiy1tU5oPyLfPyUS64STRoxukQ6bsCer5UsgDXnAfhbrfx+njCthF+cFSPFpNJn6LXkv4EavfEZHiN0gFJSNmC+uW3wA9mv4vzOMjuUuzwTfqaBJdNTaL6Ah3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adopt the ARI Forwarding Enable bit on preserved bridges and update
pci_dev->ari_enabled accordingly during a Live Update. This ensures that
the preserved devices on the bridge's secondary bus can be identified
with the same expanded 8-bit function number after a Live Update.

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 30 ++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h |  6 ++++++
 drivers/pci/pci.c        |  8 +++++++-
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 0145399b3834..3c9a10a892fc 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -189,6 +189,10 @@
  *    way after Live Update and ensures that IOMMU groups do not change. Note
  *    that a device will use its adopted ACS controls for the lifetime of its
  *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
+ *
+ *  * The PCI core adopts ARI Forwarding Enable on all bridges with downstream
+ *    preserved devices to ensure that all preserved devices on the bridge's
+ *    secondary bus are addressable after the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -904,6 +908,32 @@ int pci_liveupdate_adopt_acs(struct pci_dev *dev)
 	return 0;
 }
 
+/**
+ * pci_liveupdate_adopt_ari() - Adopt ARI configuration
+ * @dev: The PCI device to adopt ARI configuration for
+ *
+ * For devices preserved across a Live Update, read the ARI state from
+ * hardware and adopt it. This ensures the device continues to use the ARI
+ * configuration established by the previous kernel.
+ *
+ * Return: 0 on success, or -EINVAL if the device was not preserved.
+ */
+int pci_liveupdate_adopt_ari(struct pci_dev *dev)
+{
+	u16 val;
+
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+
+	if (!dev->liveupdate.incoming)
+		return -EINVAL;
+
+	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
+
+	/* Safe to modify dev->ari_enabled bitfield during enumeration. */
+	dev->ari_enabled = !!(val & PCI_EXP_DEVCTL2_ARI);
+	return 0;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index d4721ffcecb2..90b2754ecc0c 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -16,6 +16,7 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev);
 bool pci_liveupdate_preserve_bus_numbers(void);
 bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
 int pci_liveupdate_adopt_acs(struct pci_dev *dev);
+int pci_liveupdate_adopt_ari(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -40,6 +41,11 @@ static inline int pci_liveupdate_adopt_acs(struct pci_dev *dev)
 {
 	return -EINVAL;
 }
+
+static inline int pci_liveupdate_adopt_ari(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 47d8229115b8..0ae405b86b2f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3625,7 +3625,7 @@ void pci_configure_ari(struct pci_dev *dev)
 	u32 cap;
 	struct pci_dev *bridge;
 
-	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
+	if (!pci_is_pcie(dev) || dev->devfn)
 		return;
 
 	bridge = dev->bus->self;
@@ -3636,6 +3636,12 @@ void pci_configure_ari(struct pci_dev *dev)
 	if (!(cap & PCI_EXP_DEVCAP2_ARI))
 		return;
 
+	if (!pci_liveupdate_adopt_ari(bridge))
+		return;
+
+	if (pcie_ari_disabled)
+		return;
+
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
 		pcie_capability_set_word(bridge, PCI_EXP_DEVCTL2,
 					 PCI_EXP_DEVCTL2_ARI);
-- 
2.55.0.1082.g2b9226bbc0-goog


