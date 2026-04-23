Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79E7FDEE51
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70F186B009E; Thu, 23 Apr 2026 17:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6995A6B009F; Thu, 23 Apr 2026 17:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560926B00A0; Thu, 23 Apr 2026 17:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 401046B009E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C46521A055E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:38 +0000 (UTC)
X-FDA: 84691097316.25.BFC6453
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id 04F99140010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AONKtFkk;
	spf=pass (imf26.hostedemail.com: domain of 3143qaQgKCPIXgUnfUWeaiiafY.Wigfchor-ggepUWe.ila@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3143qaQgKCPIXgUnfUWeaiiafY.Wigfchor-ggepUWe.ila@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/PZfm0ILlaeTWExhdrHJ+nS/9VkLe0d8hpRsDexX1A=;
	b=brU8xg7wlpZa1gCs80fXcRetp/RqCkVfz4NjWgmoNR80yoCtjs/ovMKPSXtWwlfc7AlYEd
	3o+rhi3vwlmqtv0Ef9f0LFUiKscS5mrJeXu2Dhpn0cmJgjWD4DaQLD5lylhPAIpCoq9J7d
	VPqSPaLDlEXM+1IlErp3rK2jq//lDR8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AONKtFkk;
	spf=pass (imf26.hostedemail.com: domain of 3143qaQgKCPIXgUnfUWeaiiafY.Wigfchor-ggepUWe.ila@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3143qaQgKCPIXgUnfUWeaiiafY.Wigfchor-ggepUWe.ila@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979417; a=rsa-sha256;
	cv=none;
	b=S8mU2/z5kR8LztzsXMvpy6Mk0aBK6q9ZIr6n5wmFIKp3fLAJ/nmmmFMQ8NdDTiplfsmn9O
	8ljV4jRjFza9DE635mm6EKWnV2Q1zGvuqQcTQbGCBaldYR5xnJhgiD/5u1Tvb4wvU06YAo
	42jnWPWRb1/4ousu3gk77KoVg7ydkM0=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b2eba42b8dso63916335ad.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979416; x=1777584216; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E/PZfm0ILlaeTWExhdrHJ+nS/9VkLe0d8hpRsDexX1A=;
        b=AONKtFkk2/mZC6T/LLeYLd4/Q+cNrk23HhIkfmn1pExj6P13w+0Iwj7c36/YO1qiYq
         jK71aSpVzmsgoycAJ4zFNiRdfHEPxqXzW+GAfIoKfJFi7pwv7m4XKpi4tgLn3aRSdMMW
         if3oWIok3b6VuWX5Y8/1Iw8+q5ubA6quqOK+71eal2t/9aQnraAPuVKGyUDKiImlhysn
         CkI5JRIgZtgz3oITVxq04w1O7pn+qSxjENBAOrTNUogWusUT2tvZuqcdl7Sjxie2Qfnk
         jGEdDhrIcmV5eKw3NMLnGPmsNs6bC7CouoXs7iH2LGd5I6+EvdJlSn/95YfUeBMLw1f9
         lJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979416; x=1777584216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E/PZfm0ILlaeTWExhdrHJ+nS/9VkLe0d8hpRsDexX1A=;
        b=ojCw7yXUTbJh9A0r50rRjPkRAi6giEjvIC7SWcTMNptmOu8Z6LpPhu7jrbc2O1zdYx
         Pu9l0lpyohtOxUb0BzSdVNt1Y37yCq24j4a5Pczp+h0xUuouB0RbU2K6BI1cXeI9FkO+
         F4f1yfdPt3sVxsqpoZEErtqhUtGcCfmTQS8anyiNHQc/gWky47jgSdiWCSAr2UEH2eR4
         O8FE6A+kd+CGvWDsq1BvKt7J4Fp+GjGieSNnZxbLntGlibHZndfMce7CaoX5q2z/FXE9
         Q2T3myvL/t/t3DjWAnw1H4PPsuJHOEPso1d3/MWSSF3Ex/DkCQchTW5JqH8F799uFYuH
         E2Kg==
X-Forwarded-Encrypted: i=1; AFNElJ9ZyoR6zjNFlnO1Bum+8yrVLiIZCSnbtqtY9oq82gtlKBOLSsLIFd7+fBzeFeFxVovEYi5O6RMsag==@kvack.org
X-Gm-Message-State: AOJu0YykJRjPMdLMYy6mqkqWwxv7dup9rLbVhohaIFKNwzCzpxSlzhaX
	YQ+yzyaFqwRFZv39sPvGxfccaxb9wKVVSx/GGlrcSaSJdPVZj8VWvVSL2uXsaQqkOutr66tIWhz
	kuje8LlLpBgpn1A==
X-Received: from plav22.prod.google.com ([2002:a17:902:f0d6:b0:2b0:5380:49f1])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1a88:b0:2b2:5ec6:dcf6 with SMTP id d9443c01a7336-2b5f9e85f20mr294713095ad.8.1776979415642;
 Thu, 23 Apr 2026 14:23:35 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:23:13 +0000
In-Reply-To: <20260423212316.3431746-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212316.3431746-10-dmatlack@google.com>
Subject: [PATCH v4 09/11] PCI: liveupdate: Inherit ARI Forwarding Enable on
 preserved bridges
From: David Matlack <dmatlack@google.com>
To: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ibsybikeiwifyk54yfa698hyxefw4azr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 04F99140010
X-HE-Tag: 1776979416-2852
X-HE-Meta: U2FsdGVkX19js5AC6gs2u2AFF1MT4KS7sFdE4+GDKWfzPLQhV4mWasYii2d2WPbDAHwxzsl4LA3of6brTLZQiMvG598GecEMNaEeF1qJU00fgP0yw9yOEGgzjFBmSN79ybu25QgkzaTy4iINXzT6t4LXjSx4k7MNgyWosn22CWXhQ7w6PDkdmqdH7ed3DKOAKMmHnsk7/heY3BEz2nP+eOlIxm7C4RDAPnzSZG5jItETBqWFRoYqR2UMznvbJ8B2oq0pq1g9LATi7z//UNsEoM0uuprE/bbxIs2DV48siaK3aV2+UnLGphFT+GCJZDVPw7IUDM+d5btSdDUoOvYM72F097P4xSPwerei2eFlAmrR83sXnZ3FdKjJNVG2VEDMFo3IObLgZHaoN+SafKyRm04KfA33kNQ5i0plA9laeFqeVKRJ+0AUbJqmM3mBcGtyIViu3/ANHjDiKaqVV70M6cnQnw9T2Br/M+HWQF1S41LfrKW0SEQHaHC+3NlXcRb6kxJxhqvviWj02gwaFz0C03sz9zRvC/oUt+ivz0fvWrMHsLqobcLQDFJzWhdC8/8aM5nIspQ8+4nR3iOqoqXZexf7faw8RVghCTVvzoSUOhigIBixHQ34Fy2RPFtDa4ZgYvET504YTIJKc4FXQY3FmSBb53U2KFA7AsPOzApp912IwicMc+OURmYJDhMxOfsugIcUK6fJed5dJpMYNMZ/FcupLOIMBWiWjzQNhGo2T1QY4ledtKUflDMHsXm2h9LYfoD0DLYj6aAsfIEU3NyT9O3vbhgB1xEXtx5zRgoPW7abvSTmJkLUErkO+8cZQJ+KuhqJMuyZWSK04EnFgMg7KA6lgNXLkD4xCGN+/iJkq3p/zJ4eOIrq68WjZcRI1DSRYLpct622a6zSkomexIF3s0GENhCBizTneO2hYDChhQbDVqtQZdJlWj9lIMUeNtRo2ymMs2g9mQrGLAQeR4F
 c5+IGq69
 Wz8E6tkkspIsu0aRKGInxPl8k9Hn3P6XObI0M8ASVOMAwhei/XYVSaw+B59vWq4QU9y4ivcRX5jM29HRsSugE8Ga6dpu9yyCQMIPG9X76xZ/1oyFXgsHgrLFhppRTkGHxLeH17i5pamvNKVUqPqATapwm00OvjXDcq53jh+NqdT5aE/uPOL0DO7U/9ovN+o6V8PyikqA3FvsC0BVfqTzbwpPltzAKBs/DItRxwF7ETu3dudlZegjWUViR3MLduntDVtOAyBgZIOO1fipO4lMjA5MIg+UmmCSginQ2r6AMrqH1BRUCG5+y3CfHiGU4+uXTCS0oUkmSW8t70iPD/1Q8PHyDEPTJOjUoGd941TlVTz2QjkPn8tCgti3Q5+UDEHIfeClr1/F4UkTbn1cCC9+mC77PKXBKrFEOJ/Oy9S2cJtS2/xejTkESD8gQUlC7qdGm+tch/vFK+7peLcfPfjj/Ee3q3nqmCPAH0OcX6fVN61D29TkvvJVw43C36W+lX1ym4ofTwn+wAsQmV2UmfL1sOlDgPLrpsNUqC19SythNwUed/U0si6iGHCqSQIIqNlI2X3JxP1lSQ9b2s1XRnHOjphCt9Z6yHxUYPE9oVFR/gmGRutNIoOjOFJlRcIDc2ZX338B2Xd3QrphQsyk=
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
 drivers/pci/liveupdate.c |  4 ++++
 drivers/pci/pci.c        | 12 +++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 54a90ff02bdd..25c86cd4c173 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -128,6 +128,10 @@
  *  * The PCI core inherits all ACS flags enabled on incoming preserved devices
  *    rather than assigning new ones. This ensures that TLPs are routed the same
  *    way after Live Update and ensures that IOMMU groups do not change.
+ *
+ *  * The PCI core inherits ARI Forwarding Enable on all bridges with downstream
+ *    preserved devices to ensure that all preserved devices on the bridge's
+ *    secondary bus are addressable after the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e615b7c3e430..b45539c55c7d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3498,8 +3498,9 @@ void pci_configure_ari(struct pci_dev *dev)
 {
 	u32 cap;
 	struct pci_dev *bridge;
+	u16 val = 0;
 
-	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
+	if (!pci_is_pcie(dev) || dev->devfn)
 		return;
 
 	bridge = dev->bus->self;
@@ -3510,6 +3511,15 @@ void pci_configure_ari(struct pci_dev *dev)
 	if (!(cap & PCI_EXP_DEVCAP2_ARI))
 		return;
 
+	if (pci_liveupdate_incoming(bridge)) {
+		pcie_capability_read_word(bridge, PCI_EXP_DEVCTL2, &val);
+		bridge->ari_enabled = !!(val & PCI_EXP_DEVCTL2_ARI);
+		return;
+	}
+
+	if (pcie_ari_disabled)
+		return;
+
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
 		pcie_capability_set_word(bridge, PCI_EXP_DEVCTL2,
 					 PCI_EXP_DEVCTL2_ARI);
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


