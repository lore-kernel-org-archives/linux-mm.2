Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21221CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6645D6B009F; Tue, 13 Oct 2026 12:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6155F6B00A0; Tue, 13 Oct 2026 12:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DCD36B00A1; Tue, 13 Oct 2026 12:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 259986B009F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A913BA8905
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:50 +0000 (UTC)
X-FDA: 85318129260.12.712123D
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf28.hostedemail.com (Postfix) with ESMTP id E0F3EC000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="E77dV/Jk";
	spf=pass (imf28.hostedemail.com: domain of 3iVvOaggKCNY5E2LD24C8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--dmatlack.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3iVvOaggKCNY5E2LD24C8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rbdiAFt+Oje3uTZOnPEvaOqLxPnobGariVTCdptn2ik=;
	b=kWAFera+KGtQipJJWS1mGTLabkQpOYboamrVJ1VXklCKXZc9yiXD/ErmyTtRGQgmWVO5qm
	IqWdcAYePVigtLb4ZVR2YVEuyxWxdA7gvl5BXyKb5WIL7OguD82Fokl28Isce+VRIFZU6P
	6XuOkz6CR+wEMENFNh8BK8CqZKzNZ8A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="E77dV/Jk";
	spf=pass (imf28.hostedemail.com: domain of 3iVvOaggKCNY5E2LD24C8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--dmatlack.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3iVvOaggKCNY5E2LD24C8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908748;
	b=I9L4uLT5G+gfqcZP+w9TD+Ofh0YpENU+pLvVrgYIeZWQBp8+891v9VMNtLj9JzHDAVNBj/
	IQ68yz1oNeX75YIkDfwoemTsF9OOaMB+KQC92HBClKxvTgNNmO2Sw6jAu4gmrKqVr2gHmp
	YlgTH6yBhO84NAQQRQCyX1tGbtWraWw=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39b77130a7fso3789033a91.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908748; x=1792513548; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rbdiAFt+Oje3uTZOnPEvaOqLxPnobGariVTCdptn2ik=;
        b=E77dV/JkMQY+1Clm0Lulkb0VF1FOIwx1+6hUN1+rS5l0vusgwoR60Gh/nzqKo7fZHc
         bKahgKEzunGVTRx1pBZMN1yb6YKhEoBoypTXEBiUEtWAYYJlhmwjGwp2WaJauHKkI/GZ
         jh+By0Ddxnr+pmv4DiRZNsg7aZ+2EGaJ0MCs1OKFO4EGbfoqNqgUEztfhhPqKDgg45vp
         G82ITef0w0xipfSuIcZoUpWgrO2/LigqaO4VCT+IyKuJMFMdv91o8WTPIzM8xTRyxzZC
         Z8JkY9uYXB0OWt02a2fPN3gLmwIrIHZ90D8X3lGvsKhomckinqOMhIYg+i9oUv0QD9qZ
         C2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908748; x=1792513548;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rbdiAFt+Oje3uTZOnPEvaOqLxPnobGariVTCdptn2ik=;
        b=mnGkVBuw67tgBHigMGuKrh53hrJdDGfMouA/piWevq6v2VBdG6AD8SCZUv4VwDBu5F
         cmngZ7nWdL3v5FnICrX5sebd4aT9CPKZBLXTXc1P2XzXo0UJFIyB+SP4k4jBtgiz1nxc
         caKbfYRCwIJ3j/f5EFq48nSQdh3mxhjVCn2v53FYuEyMiDmYHb0OjPrr0M0OjCV52Ve9
         z3vzRIyrAINuh4+gxf4JOqwfh4C8gfDKDimA4sts+p3LMUBPhkp2nrNewjFFcWMmIdx8
         mJeu65YagZK3hM0eZQkCb8dX2db3GfWINVtykTMw3A0EFT87rXx9rUO9pTdxRBq1SaYw
         pUdA==
X-Forwarded-Encrypted: i=1; AKwUvByJcwmoJld3MB1QRx04qYMqxyoJdgwaXUSgzHXzYBAYu05weAsFAL/NVEZFY+2NkpxTR3B0LDDuvA==@kvack.org
X-Gm-Message-State: AFq9FYJqlOPSMNBL6xzHktIoTf1pgqd5C4LzrBKAyVHGqhAR8ZjlAaAF
	Hzly6dbzo8+kHaKD85FRI5rNr5CWn1ez33fWTGJEMwhUR8qxddpacmOZgoTV2C8v7dxE4CRIbWG
	OsrSItAzEm7ecKg==
X-Received: from plbl17.prod.google.com ([2002:a17:902:eb11:b0:2e3:1b6e:33bb])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1d4f:b0:3a4:a592:4cfa with SMTP id 98e67ed59e1d1-3ab3a79d9f8mr10690339a91.45.1791908745986;
 Tue, 13 Oct 2026 09:25:45 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:26 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-11-dmatlack@google.com>
Subject: [PATCH v10 10/13] PCI: liveupdate: Adopt ARI Forwarding Enable on
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E0F3EC000A
X-Rspam-User: 
X-Stat-Signature: jr7gdkb9d66z14fxckitwxrrdfdgttek
X-HE-Tag: 1791908748-631964
X-HE-Meta: U2FsdGVkX1/x/ZhXzbGK2mmc25JLsJFsyiRVJVAgNxlZlKMJO36k6pUTkh+TD5x3YShX97wrzi5LoR4ezFHiCDg2zlkbBkLgtQc5vMvexN+OrEOiXlgmiFDB/bA/EnRjYWzGnZr69o0p+zZAFS7czXniStydlWzvZaDNZDJeqYreeHpyBlmews+Zr70EU9Uvv8pSUu3uGcTriD0MqS8KaN2sEDUB/E+pcr6yh0ZE0/dRw/9mGpICdh+BvauqYPPv8jY2se3HkjzCrDyukZrf2xIlfDLk0KOEajkehReHf6EkMCEdHJxBkuI4T7fChUmjwNoCsQiOOiCSpnOQKh0PREJfo69SCU8O6t77A5ZEvst7vK7PfVCCgKl2y9lX1oYiewm2lJc3fE8LRH5qXCadu8Bnt/BrREXTQPkkHburWESiE08hnS5mQJIYe+A1yDg9K1tdF0ZAuEP8CdQ+8wBKAp1VndhjQYUIzL7A+FuwOnpGL7xGsRkMKf/Qy0sw6zuh+cNY+iuu/KdzuI1Bm9b3wqYd/bSQxHVOoxoI2T/9ZmJJaE4OocJ7CW9QUSZdQyfAQXm3COLmBoESeLWhEWaHbLkBPAyl3LfhPIsMkK/jOuGw8Bz3A8pQaTjDWtUqrdhRYv8W8JX5zV0CJQXVre6N3KMADVXE6gy0u+grcKujWG6HoK324NbqPLcjYhw3JUCuVhCxDtyaCon1VyW/MahyS3PI+ZyvsBFpo9TRZYBVoNeYnad5FHhpvKzyy1qCfBjjN69h6amEb0eMYYW0G2kWsRxt4Cr5dtCiY0JL+0SfEnRZ9wJhaK27LWj0+p+fLAJgd/DNZYOoN0YTTzGJpt/7B5Eh0Oq3lW+2acQv/BJi/BVhA9/ZSUj+p/kVmo+7VJ4qicFcsgjKNj9W7h6Fgbl4Xeo4P4qi1YWrD2XiJjEii4OtfdAfWufDORBTy6adcm+Ns2Nt5DkqXvjZ9SUK941
 trFPDGuW
 crRMeKasERYFZ+RBm/90xSV1lYlSY0vPlvp7nxGHD0CPg9xEyeU1cLahcorjMHq5SL+Ffi7UOb8UQZNlbJ5GIe/9dtVWTKvp431ELyeLW/db6gNJHN0qY9z2ijVTYpLWqg+mnY366leq74gb17NQaYSXcDFwvvkbjULzuU0sate1zIjpePOUzx9Hyd+xRswEG8Fo5Mn/u91ODpiLer87Hleg4e54tqmsXEsS8wPehnaZKl6nQLVrxxBBcAXj2NUZlGtKlgRzYLQEV0DoonPHVzOvjrn67WddxHPTdkWPO5mq3GcGDzteeub9Z9VleVsXHAdOmar8zOHxAXYYpzUieFeP2+HSxL8VXZGXEIrz2oM7R1wjm0r/wm0EhkcWZRiGYmAN1NbTqxZRnANvGk2dDAusL4Guchp70xP+ZgYYsJeaUKsOTIMusOBrbBpmcyojvzv9rqDeNRDL3MwVeYIO6L4Yr37prhV4kXZ/51kf+jgK0/j8CdAeP53vP4W5Zk7Hrr8IHakiHcRr2+c/JTgL0EEfioIFDOkNmXEQ8q/wR8supism6I78Pjh+Oazl2w6y/dWwA7be04YfrTiUwJEWP6FFwpMOEqXUK3TEx
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

pci_liveupdate_adopt_ari() updates the bridge's ari_enabled the same way,
and from the same context, as pci_configure_ari() already does when it
enables or disables ARI Forwarding on the bridge.

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 35 +++++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h |  6 ++++++
 drivers/pci/pci.c        |  8 +++++++-
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 1d2324d339da..e640794cc8e6 100644
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
@@ -922,6 +926,37 @@ int pci_liveupdate_adopt_acs(struct pci_dev *dev)
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
+	/*
+	 * Unlike ACS, only adopt ARI while the bridge is incoming-preserved.
+	 * Once all devices below the bridge have finished, recomputing ARI
+	 * Forwarding Enable yields the same result for the same device, and
+	 * must be allowed to change if a different device is hot-plugged.
+	 */
+	if (!dev->liveupdate.incoming)
+		return -EINVAL;
+
+	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
+
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
index 650d7f92f93a..e5b960ca26e6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3705,7 +3705,7 @@ void pci_configure_ari(struct pci_dev *dev)
 	u32 cap;
 	struct pci_dev *bridge;
 
-	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
+	if (!pci_is_pcie(dev) || dev->devfn)
 		return;
 
 	bridge = dev->bus->self;
@@ -3716,6 +3716,12 @@ void pci_configure_ari(struct pci_dev *dev)
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
2.56.0.385.gd3acb90ef8-goog


