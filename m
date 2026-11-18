Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7F3606B633
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gAZ9KNFd
Received: by kanga.kvack.org (Postfix)
	id A2B776B0617; Wed, 18 Nov 2026 17:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC896B0619; Wed, 18 Nov 2026 17:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F3A6B0618; Wed, 18 Nov 2026 17:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4C66B0616
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:37:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1A0B1C4327
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:22 +0000 (UTC)
X-FDA: 85449702324.25.0C67F1B
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0CBAA40002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=gAZ9KNFd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3nyj-aggKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3nyj-aggKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041441;
	b=CVsPYWc2FU0Z7jYMrfrayJ+4JjUYlC6m2xUCBMVyxlXb4/OUi6cBN/cUR6a27Wr4OYf+yC
	HnbWw41hR34IY3VndIxHio0+1j8kkO0viOlBkZrwBVWWXjRZRzAsFSw3wP8uZPfFOWpddM
	KXsngYBX+cj1+6hcuZndbLapkFxEXSI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKsd+4T8Z5gmC4mac6DyE/MToWM5vKEbChkw2+nF2a0=;
	b=RJSkhEX6n+kr5zL6OL2N0IkW+4YeIqCcanxywKs7YMF+I4FP/eQt1aPRJ4BguywBtf1jKd
	/tN8oSNZhFsko+e1x7lBU8hCh/+Au8g7x+u9RKB79amutddIai4cSpzUeNTdMw2qW34xK6
	L/3uNMKgt90gUPe6cDUImgwnNZtoifE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=gAZ9KNFd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3nyj-aggKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3nyj-aggKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b37620eb73so2010391b6e.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795041440; x=1795646240; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xKsd+4T8Z5gmC4mac6DyE/MToWM5vKEbChkw2+nF2a0=;
        b=gAZ9KNFdCSR9ancJgukBff/uGMI5LpPi5ebrUra3O+DobGNngD1sdyattnV1cWi09+
         UZ++lgfhySmcMfMbsYoH9YJOktomE6Mc52j6Z+QCa4dSFCdh4AuBfZhojAlt5Q23LQjr
         g0wlwOxJhE/HHYdOuEjWqFfi16ICe1AGNl6r5pX2rdT0n2TqAWcKAI3mdDDxUJF0GUeC
         HYjyVizC43t4SahzCE88sEouv26aD7v9vsCSWWkkafMihhiFc+07kRnhXkEsraoKb/09
         UNXiRDC4Q8y7zf2hHT4oL1fzCyuKrR23xGD25/M71CYoZKnSnnuZX2u8mpvoryDebETV
         7Ixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041440; x=1795646240;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xKsd+4T8Z5gmC4mac6DyE/MToWM5vKEbChkw2+nF2a0=;
        b=aZ79YUrmCyLWFjnn444m1WSaKRMVWllQ1uoPdD1nY+fe3djxGt2XJVeiUHcrqu0+6n
         wP9Ai6UYUOXAZmF3HSTBg/9U+cV4EDO/dns7tBjNSEcSCqU26XEJZOsIc9K93mkx+h4y
         kGQAqYa4+T9ukrpxdXP+vGwpSw/x1SXCySilYVX2bhbyFabbBJoPOh87/joq/5qGKz4c
         n+CC739MMv8r7rqSCAIA6gstNCo4M/b8oBSPbRC/5wSTW+ofX886rud+CnxVavU2Gl0s
         wxysuPf9s2549iSQUrYLvp6bNj9bavSbQYpIuctKeHAAF4geUnkjdW/QDIJ9qlqk+HtD
         5g5A==
X-Forwarded-Encrypted: i=1; AL+hErGhTqk5ogtvYWl+iH6Gc0DFXK28ObHhik92Wq00TFiyb6+gl5bXJ4kDdttuxLo/TuUdHXmqQG3JJA==@kvack.org
X-Gm-Message-State: APuU4Z+I4BNI6RnaBJPR/yL3cy3eqZ07LwKqyxVraXkCRklho91bHqXo
	yrGvzx8nQTo0vKoSk3uVnkbIPHjs3CFCOH3E9II9HttgFqNL7uUsycsejdgTuLjckY1IePrzVi6
	e5Sxt7qK3uWr+7g==
X-Received: from jaac16-n1.prod.google.com ([2002:a05:6638:c750:10b0:61b:3a7f:4e5e])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6f81:b0:577:2888:47b3 with SMTP id 5614622812f47-57742e34681mr4186856b6e.44.1795041439732;
 Wed, 18 Nov 2026 14:37:19 -0800 (PST)
Date: Wed, 18 Nov 2026 22:37:01 +0000
In-Reply-To: <20261118223704.3286085-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118223704.3286085-11-dmatlack@google.com>
Subject: [PATCH v11 10/13] PCI: liveupdate: Adopt ARI Forwarding Enable on
 preserved bridges
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>, 
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
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0CBAA40002
X-Stat-Signature: 338dkzzdhf97i36xa5bmm36efmrkqm38
X-HE-Tag: 1795041440-175577
X-HE-Meta: U2FsdGVkX1/9R9gYJl0H25/aILC3PlukOKQIiBmc5DZ3G7Av9icVDKW4d+EupMtOuJQyb7QpGEOEGM9JSBVmMUvYx4VgxvIG15fgwGBoK2399Zq1nf1OeO7/YIAwIe20Y/eOqTv64B2O9De4X2z+CiD1lsYZLa9BH1z2cQSOspRxz0cqkHcb3trHwgMoI+5ROkXkeSEShNzRPs0AXCfCb9N8CmQYlQ+RYbrtJDnBCbx6ttdVGbpWC9Jb0E54NKIjWnqxdrtW1q8Lm9mJ4zn9yuhXaaS6aPivhUeALtlObJ7IyZTYDUhKZi7o1iS06m19V5sb6LhzSfzUJj0uumKVZEubxPK5bcDsVuIcQu844PNZ6VvOd7uq4kEvdkvbxegz3Y6qxG57ExEIwgXkI6qs6k7ScHFgyyqETMw3Z1LNKS/MO1ZiQ7jVv1LSSvJ87ep59quz9P6ZcjJu2MANObiuyJGqFFZIMEMpv7rY0tTaMj4YNx3ccnXPjNChQf9IsWkh2LalDkqLXa6PjPz43N3eXiCi4tYOfD6xWlwFJT6uvEIKRhHgC0wAmp0z5UcmDpfgMCpKQM+u2s+iZW70byzy5H60+q7cGXfG1KACNji48/1CxuyjE0zA/gc5nSmL1mh8O+Z14yXhUpBQVzXNiVGrgwK3kwyZRZW4fpptJUt2yVMOOlizxT6XQm1an7TVOXkYT2NVFamr7qwTCoCC6ti6Fb4JfdIVgacCcJm3PtWqP1y6DinOL3AdLUxZNGvvuoLp5Ohns3waaP2yTW5o8AAKULkjbCtPHjJ1KyIvIJhSXiH3nCM/C+eKwlQP2LTAjzzrKzebN8wBayF9JOfjNJ/MnZ5EnVQRKTIqzfiulOQkPMCwtXCirD2+BC0HZkPEn1cBB03ugSfgEBPTCfSMqyDnEc8NnTYTgzICuh/AnYCtKMw/Ce6XIizey+KYqSWMtxEJf8UFyl24gfV3vEo0ULT
 wJRkXXim
 LTSP6xCEeKQUt4ue/e2YjqHbTyOaQW7TDiBC411wZK2koHDuCNFMJ1msZsO4UQMc+LYgR1PnNRcivOuV8R0RdXPr0rdKa7nrOmeMPNdhcpMv9a+++MVULWgGR+sYyDGSEABICbpNrkGhA3e2hq2rlmafII0nJaYpmdgtSovJdzJ8zBf6VQTPbwu81oKVc/mpKm6aR8193s76W7XtOOqKuF4r8fb149OTlnCHPuUI8kJDZupHWRaAxKDyybd7GK6xCa/mv6tLSlV/IllqvQc1c9lLdB71oj8dQIE+PLot0eYW80mFV4jenLE9o4/mx7Nf7o2fJc/LzrpD4Vx1iaZVtpiz7maCNysMqdiUl0DxcMD6JTbIiciA+ezLKH4EUqlJ4y9NNIjR0AyRLGtubIDPUZfR/N3Te6zHRQaI7wxFLWLb7fuiOm9F4ZLyA2oh0ReWtw6591JcZzSS9YCbajln1LgUr56Xxlnsu3oKOZznOB6Wb14BywyPZtcM8bO1k89z41YLlth3N1GnJLq9b6MXl0bfGPrfv5FdaOfpdAbN7SRzlThMDW1V41tRr6uobzjBRRny0B0yILbp6YbBfvzs4m9f8XRCDG4ezlvzzfrQNOA4nZtaayueFyKXDLTMVZOsr+Dj2q+jj/w9H9UGrbEmar0rTLS8dOXsBUSO/OVlUf5WrmWWAoeW31gHGgFw+qI8ee4+/v965otEEkf1fjTkdRdR/UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Adopt the ARI Forwarding Enable bit on preserved bridges and update
pci_dev->ari_enabled accordingly during a Live Update. This ensures that
the preserved devices on the bridge's secondary bus can be identified
with the same expanded 8-bit function number after a Live Update.

Adopt the bit even if pci=noari is passed, and document this in
kernel-parameters.txt. The previous kernel may have enabled ARI
Forwarding, and the preserved devices below the bridge rely on it.

pci_liveupdate_adopt_ari() updates the bridge's ari_enabled the same way,
and from the same context, as pci_configure_ari() already does when it
enables or disables ARI Forwarding on the bridge.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  5 ++-
 drivers/pci/liveupdate.c                      | 36 +++++++++++++++++++
 drivers/pci/liveupdate.h                      |  6 ++++
 drivers/pci/pci.c                             |  8 ++++-
 4 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index d1ef1c93ec96..cfa5f18a6fb5 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5239,7 +5239,10 @@ Kernel parameters
 				off: Turn realloc off
 				on: Turn realloc on
 		realloc		same as realloc=on
-		noari		do not use PCIe ARI.
+		noari		do not use PCIe ARI. Bridges above devices
+				preserved across a Live Update keep the ARI
+				Forwarding Enable setting from the previous
+				kernel.
 		noats		[PCIE, Intel-IOMMU, AMD-IOMMU]
 				do not use PCIe ATS (and IOMMU device IOTLB).
 		pcie_scan_all	Scan all possible PCIe devices.  Otherwise we
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index b99a88c2c199..a45ad86370d5 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -188,6 +188,11 @@
  *    same after Live Update. Note that a device will use its adopted ACS
  *    controls for the lifetime of its struct pci_dev (i.e. even after
  *    pci_liveupdate_finish()).
+ *
+ *  * The PCI core adopts ARI Forwarding Enable on bridges above incoming
+ *    preserved devices, even with pci=noari, until all preserved devices below
+ *    the bridge have finished. This keeps the preserved devices on the bridge's
+ *    secondary bus addressable with the same function numbers.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -891,6 +896,37 @@ int pci_liveupdate_adopt_acs(struct pci_dev *dev)
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
index c643f2664296..e1c1d2fa00e4 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -16,6 +16,7 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev);
 bool pci_liveupdate_preserve_bus_numbers(void);
 bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
 int pci_liveupdate_adopt_acs(struct pci_dev *dev);
+int pci_liveupdate_adopt_ari(struct pci_dev *dev);
 
 static inline bool pci_liveupdate_was_incoming(struct pci_dev *dev)
 {
@@ -46,6 +47,11 @@ static inline int pci_liveupdate_adopt_acs(struct pci_dev *dev)
 	return -EINVAL;
 }
 
+static inline int pci_liveupdate_adopt_ari(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+
 static inline bool pci_liveupdate_was_incoming(struct pci_dev *dev)
 {
 	return false;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ebc565b4780a..b5b578355a1b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3748,7 +3748,7 @@ void pci_configure_ari(struct pci_dev *dev)
 	u32 cap;
 	struct pci_dev *bridge;
 
-	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
+	if (!pci_is_pcie(dev) || dev->devfn)
 		return;
 
 	bridge = dev->bus->self;
@@ -3759,6 +3759,12 @@ void pci_configure_ari(struct pci_dev *dev)
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
2.56.1.703.gf848ed807c-goog


