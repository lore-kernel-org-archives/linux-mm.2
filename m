Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B48EDCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDB96B0099; Tue, 12 May 2026 14:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944EC6B009E; Tue, 12 May 2026 14:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858C16B0099; Tue, 12 May 2026 14:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68CBA6B0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:49:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08F10C1614
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:49:01 +0000 (UTC)
X-FDA: 84759654882.15.79AA9F3
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4823BA0009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ICr+ZwCc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3GXYDaggKCGoLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3GXYDaggKCGoLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=suL1O4sFcS7rc/4d5OPs7kFFwy+U1yVMYGR9ND8RmlQ=;
	b=X4eXwDmlsIKKXJJ8UmIcWdH86zsNHguDEs4fKFepurmtkzjMhnMqqh0zPHE8Az9yggP7a1
	BuXZumAt87P9L4VSoJ6UAo1Cvtv5LCsNTBYMrp7qqbdHBhXh6qb4m7i2mqVdIFByGl6Ntf
	piO90kJDdqoPJGhZvZtDWWmd6MOAM7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611739; a=rsa-sha256;
	cv=none;
	b=Ip2gLOfbCbRMnF1M1gW8/nNQWHYAcp3tQLTPp0d2W02+6LNY+SJxtcy/knXvm8/zA+g2Qu
	ylGCi8AGQLbEx+DYNsU4FYG+4YNiTPCctWHOXkO+6BHX9KJo7b0hlpdmhsF69ECg59tNLI
	jIWHElVmMN4LKFAyBAIWxqoEstICla8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ICr+ZwCc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3GXYDaggKCGoLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3GXYDaggKCGoLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f85179263so6805578b3a.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611738; x=1779216538; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=suL1O4sFcS7rc/4d5OPs7kFFwy+U1yVMYGR9ND8RmlQ=;
        b=ICr+ZwCcBcwco+VJq2RrimsIsEDmbDSBosAF98kf8ptysUgzFf1DwN+I5SNP8w4Fj6
         NfuduAvRlJo4ShMTwJrE8ugJbb+IynmjkocLspauue24j0K2+hGs4dBTOmKAcqhh4Rs0
         FiK8CzRMXc1RXCsAb0iner2m/x/XqM77m48IDiPpvMQChj6xaVmG9yBfxtyQQXJ778P0
         U3QGAhmKc+AFA45sQIHQZOfgYJmFz1LMcqaTGsAaIitklRBjt/sifxqUVIyNMez9Kpsd
         fyeN5kP944ouZqMAMcrwXk12CvXq5yU5s15yz/0+5SixEXiuHz+CQGlT+mw11VBmwmpn
         OJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611738; x=1779216538;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=suL1O4sFcS7rc/4d5OPs7kFFwy+U1yVMYGR9ND8RmlQ=;
        b=eZo1CJ76ycpXbWXQusC39LIkR8QVmj08FyQ9laruPrQLY7rUDULCzztVnRoNllBth4
         OZfGJ3MzwPjNe1kGBGVwXGVvD2Z5J+eVR8XwlWXIriYMx0XE8/puNGEo6z8HOzNtUrHF
         ZCQ/6zHklgmNaUap8KNk6JRkgGziR77jyDvRv7hW+si9cN0SGRA3Kwxvfrbq46SOm6Ti
         bsVxM8Su3NNmWM7I07lt06BqYM0OORxnxEt+DKB8Ate3P6euD7rQXpwUANYrdpOgD0EC
         EonoT3jOwX7GxC+49naYy03jEw2uMAx/38HiCcvAPk4tr97sKyK9KP/TXzv9+vv+3rvX
         QBlA==
X-Forwarded-Encrypted: i=1; AFNElJ8lo1vRYo9M5r6BY9cp3w3Rah6DIHy9ZKI9BhBMNsCBe341T9ifLTBSVKzlBslD/uqpSnLLLWzz7Q==@kvack.org
X-Gm-Message-State: AOJu0YzSJnxIr1zTaSFEUcLBEmHT5s2SCwpx5lWPZX78MkJ3A3pLatYI
	4Myy9lfbI7nsfAXae7sxetqzzqibFgo93IibmZH1iobFzXrijX8vUwrAS179DFgNTJunSchmeg1
	AUYTZWUkiTkZAJg==
X-Received: from pfbdu1.prod.google.com ([2002:a05:6a00:2b41:b0:82f:5b50:db30])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:8012:b0:82c:d986:e917 with SMTP id d2e1a72fcca58-83eebbaf559mr4596279b3a.22.1778611737978;
 Tue, 12 May 2026 11:48:57 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:43 +0000
In-Reply-To: <20260512184846.119396-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260512184846.119396-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-9-dmatlack@google.com>
Subject: [PATCH v5 08/11] PCI: liveupdate: Inherit ARI Forwarding Enable on
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4823BA0009
X-Stat-Signature: g7wp4i997qiy6m7qpantmxpyqxssmoba
X-Rspam-User: 
X-HE-Tag: 1778611739-247056
X-HE-Meta: U2FsdGVkX1+CfkLnRUO0yzk1raT6b2DSeVUCNsesC9L/pVGgVQPjyT1OI28pm2oYjNnX4zzDA3YRO5gQjvgy3WEes8giw2EzrZjosgI+zmpgkfpXgqy+ReykzMqHApSmGRTHukwhrE6f+meQyOSRRjE+afj89bcJG+kmzzKaPZuucVq1UmB4+gkEoUjJ7Ppem6Vega7FjCNSICv1Qn6jVgtWHpUs1M/YWRZKASik0RhEVJmWGquBFTnoULLr86BfjsRUBtgS2slhT+zlT9AY0Qv9wnElXs14naidVu3Pklc30L5sD8JCihIIXk8zjE9UkunWXgC3JezChgt0yVNO72CcYcXI9baN8muVdjh7f37TbIbjAr1L4XzbSRH2VQyTEUpER3hRYNgAhdFrl/jYFEZOS7PvRCdCYW381S9lJrje4h90p38/8iaJEkUz+Lgiu3SuvE+Pt3DwAAvzlAVU+0ZfakQRsVtXXOn7Iyx5rBEHFOgWXXGH56X9Wr+N57TZ6cvPfZPN+sTsrps8vsp2W81lf4PV1Z0EGCLaJlfBDdh7J2XyeOe3R2tOVkz08ez5SvHXFoDl/fMNG8KnUGn7zHx/4KydrGBfz9aMbSDNGnCbX6rZmoWjD3L/GeAGJfSZxW29KGIroH7MQ+vCSVaHcUTbJ8jWyth93oydSKx0EWGkff+Rs1DnGqQOV5/KfVxtUKFZ8+SNu+ijEP5i9aLgLprFdBvjV3zbsocMqg7UtiaHvjM56ZhWQWjgsFLLN4aweHKS89Jz+bKji29cbWZYLwqL0P/KteLWcfa7jpwV0AIJNNn5rtTvynAUhfr6zw0Zqgl6NN2Qe2x+br55y/YRbT+tS9QQfLFIDzoKeJ1ZJmfAJKbpM/y4oBXJRNsgoMoYDJ4DB45tZ4m6omkegl17Ul9X2IkDnV2KHt1tl5sH0cpGqyVXdy0uhzqbetzCocvscSGm8oIUy2ZX+jLwvPV
 z0b49HAp
 STNVPPu/kt0aI23sRysl4f5p8tbQYG74beQIKt87DH7onpZYyrSqMkbtlTaaAWX8Vt6M5S9CY9UimQcKBQ+qkQqYytR/pjRBN0PVXQbS3cRQqp2GW1fzQljaEC6TItd4u/9QuvFGm1+1NuQQh7uz/SC2xR7i3r5cPHPgyrS8ztwMoRLWTt1P238qWIm8+Ptf66ZY+raxrwGg3iiUiK/cBFDAbzlcTxp/Ov4C7HIpwq2imbhuf888P3Lu+U8wA80lPdREa8YSKUrQCBCqZMtxq0q0OBxwAxutvwmhK8y2tTSCFC56harAZv8jksoXbCEe/JFtzdChGkcYKagS9bivsv3TKByssz/p58MeB6BXUVdGiBdyBfEE9JNGfL4PI8+Q7920EJvzj2z2sk8Jn+Y6oMHsBF+u8SH/VPJ7t6nrWT+xoq/8qrh5sZ6ww9VxsDzRTLatWI+MT32cZscHroLrvH50SfpubiCTCzeUzbBIZufkhD0vMpKbCxwEcZgSeumZYJYi/3UanWwVZ3sN3JLPgt1CObX/KIQ16QswUvkT6OcLFqXOqj8Kx4/Tc0Q==
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
index e3cd6d76636c..6ab03bd548b3 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -132,6 +132,10 @@
  *    way after Live Update and ensures that IOMMU groups do not change. Note
  *    that a device will use its inherited ACS flags for the lifetime of its
  *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
+ *
+ *  * The PCI core inherits ARI Forwarding Enable on all bridges with downstream
+ *    preserved devices to ensure that all preserved devices on the bridge's
+ *    secondary bus are addressable after the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -720,6 +724,20 @@ bool pci_liveupdate_inherit_acs(struct pci_dev *dev)
 	return true;
 }
 
+bool pci_liveupdate_inherit_ari(struct pci_dev *dev)
+{
+	u16 val;
+
+	guard(read_lock)(&dev->liveupdate.lock);
+
+	if (!dev->liveupdate.incoming)
+		return false;
+
+	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
+	dev->ari_enabled = !!(val & PCI_EXP_DEVCTL2_ARI);
+	return true;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index c0826ca717e3..fd7693c7ddd2 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -16,6 +16,7 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev);
 bool pci_liveupdate_inherit_buses(void);
 void pci_liveupdate_init_acs(struct pci_dev *dev);
 bool pci_liveupdate_inherit_acs(struct pci_dev *dev);
+bool pci_liveupdate_inherit_ari(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -38,6 +39,11 @@ static inline bool pci_liveupdate_inherit_acs(struct pci_dev *dev)
 {
 	return false;
 }
+
+static inline bool pci_liveupdate_inherit_ari(struct pci_dev *dev)
+{
+	return false;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index cd2c1f2ada92..7e9768dfe092 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3495,7 +3495,7 @@ void pci_configure_ari(struct pci_dev *dev)
 	u32 cap;
 	struct pci_dev *bridge;
 
-	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
+	if (!pci_is_pcie(dev) || dev->devfn)
 		return;
 
 	bridge = dev->bus->self;
@@ -3506,6 +3506,12 @@ void pci_configure_ari(struct pci_dev *dev)
 	if (!(cap & PCI_EXP_DEVCAP2_ARI))
 		return;
 
+	if (pci_liveupdate_inherit_ari(bridge))
+		return;
+
+	if (pcie_ari_disabled)
+		return;
+
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
 		pcie_capability_set_word(bridge, PCI_EXP_DEVCTL2,
 					 PCI_EXP_DEVCTL2_ARI);
-- 
2.54.0.563.g4f69b47b94-goog


