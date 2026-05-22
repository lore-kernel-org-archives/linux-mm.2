Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF5DCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73EA6B00A4; Fri, 22 May 2026 16:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990816B00A5; Fri, 22 May 2026 16:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825626B00A6; Fri, 22 May 2026 16:24:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 674FC6B00A4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E6761C061F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:23 +0000 (UTC)
X-FDA: 84796183206.10.F6D4A88
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id 765C440009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nx8p008q;
	spf=pass (imf01.hostedemail.com: domain of 3c7sQaggKCIQlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3c7sQaggKCIQlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07zUHNcjisF6FOuU9N0CtQnOBIzxNou2anoHgJH+mP8=;
	b=P61QmCIXPw3UZSsflubdceGvB9oqWjP7K+0ean6qmMSohCF3bZpdu+exSnLhyLglCu5RwM
	m2AJGzSxNMm7r6bEAUWPkKwgiqUVEZmmtR90ax4NwuR2xYpC/aOa+N8743m9tQ6rnt5O9R
	E7AL0PjHai/Opo4UktcNlmIykMoJ5KE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nx8p008q;
	spf=pass (imf01.hostedemail.com: domain of 3c7sQaggKCIQlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3c7sQaggKCIQlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481461; a=rsa-sha256;
	cv=none;
	b=ynWTVsEA6DVu2dwnVtRy2QqNZfbY/wsjvcfJAmzIiBt6v8aCS8Lc8fnU49I9a8qAfLssHJ
	xZ0twjXPm2R8y24uP/xgNRgvj++c3PQC6XK9nXbSQ2lH4/pcbhV0yiU4IEFFTyZqrv+3NF
	3NLKRp0T+sb7bkQDaISq9LAGdzheGcE=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c8525f0807aso719078a12.3
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481460; x=1780086260; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=07zUHNcjisF6FOuU9N0CtQnOBIzxNou2anoHgJH+mP8=;
        b=nx8p008qdggxuxFTsDAWx2Oevh5lZbbah9MezPE06fD2zS9sh4fovqrQlloVim/+50
         wmTGjzrPpSOslJQnwrCrjO5gnZHis7TSe+Or93KJ9h3EwKQOLm8BRUFFAzYB4i4zLdQZ
         d8iccVszLD2alvaXU8TVw8Kfr1T6S3+BmeX4zDkpnZHZQHYOJ/fchfHh2GFfn8NHROvU
         7JDyAvj4cClKEzasQoAR64OeBNfJC71UxzWC60fTjG8TrmbuPAKlvSL4DiXG9NgBugVE
         95Hco5TrW3RnupUpTb/E1bHpS2CgozVCMUqZoGre82JjkR+0KAjFbAvw8e4zRsi7Oifd
         5ZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481460; x=1780086260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=07zUHNcjisF6FOuU9N0CtQnOBIzxNou2anoHgJH+mP8=;
        b=Cfr40/nAuONtEZs5vXsTp3bGbmgyPdEFRkhgKfsCuvSCUSpzr2wZEIU2S/1Rupsgwu
         1l86P/N758mCNXdXrKFyPo8Is+4UgW+5qnIsq0LaaIpUsV07LdW9ecRddd9lJ9NbY3Ag
         JNBUYnBv7PN219be1rzaEiximXVKvh+a58lAj3cUiy0YtVikg2kI9WImaSgLtoRd580l
         fY4QioDEzb5r7Iek7tf+APY2OFcdsufcAcdzlXd5OZW45a+OJ9FDA/NvRuw3dCAOdBcz
         0CRFQ85Rw/8YdanTJXxfHLpaHR2/kMl+2c3H597xDQEklaaF5zYGdRSeq3Wk/mPJl+mK
         W0rQ==
X-Forwarded-Encrypted: i=1; AFNElJ+LVdNpDPJZA7dBZdl0UgMo4hQry1wx+vnvbAC6MHdEIQYqqTWS4jQpNCKj1BPoM5q46jNi9dHCFQ==@kvack.org
X-Gm-Message-State: AOJu0YygRFo6wPm3sw+YpCrNhasBKeUFPM6MDDttkNjhRGC37eRhZnGH
	w8OeXgjTiI+SUzDHDphPshYkZUohoQUHScPR7KMxdSqUHe9RSxO5MEha6KHBKaQV/DbFZaiYDeT
	QHl0dHKVIvg8cIA==
X-Received: from pgt6.prod.google.com ([2002:a63:1346:0:b0:c82:7a06:d5f5])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:d709:b0:3b3:c28:45b3 with SMTP id adf61e73a8af0-3b328e4f8d7mr5132386637.26.1779481459861;
 Fri, 22 May 2026 13:24:19 -0700 (PDT)
Date: Fri, 22 May 2026 20:24:07 +0000
In-Reply-To: <20260522202410.3104264-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-10-dmatlack@google.com>
Subject: [PATCH v6 09/12] PCI: liveupdate: Inherit ARI Forwarding Enable on
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
X-Rspamd-Queue-Id: 765C440009
X-Stat-Signature: u9nywsph6fjuhya4q8doypizccqpg5kc
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779481461-385930
X-HE-Meta: U2FsdGVkX1972/UCfViHHl0313osyxXszbMuP323oHoXTAUzpQiQJgsTCaRnHrTwbJ85TTW+w6rmEgLnIsTlDghnQ4S10VYJHVrnJPb1CI1UqFnqjrxiDozMqqMFFa6S3rv+0Rf5hOgxJzQAFJmwnTtoMSm5Z9jUa7f6NDvWdRYERKrmgyfJ7HDalMzfXTL8wGtzYyFwU/9HnE39TUXNvM8KAtz/6w2n+g5y0Px3rDKE6WMRF3CUrJnaWahNQ37tnRJmdrk8py7j1EnRGTVokwdTYrJwY7d5P1YuiMEv9KRAcdgSP59yoVazKQnPMCSeWjRUU3+WUaPoAX9jbC0vAZhKRT/MwNvhfs13uKgYUPJK9zetnPhujgQHzGlHTE7O/emQO8D/RNngPrnCE3GC3NtmEiEDDN0hFlQKEAJMvrzrMSnq8DCmkX7uOH+xPXZZ4AIV8UNJFaSHqEpRLtPCtKAKhVBC/a2mtxII31GW71S75++tIY4Z1OPwMMXSafX/ooCKi3kW/bpjuIzgIfvC9fbd9PKehQLlRBichNF6OgZzWlm4Z8R6DOdfEQm7E1VssWU7p2ptXkGbqfGgWox+6rHCofYFwdx97dcV2udD8TRLaW5stlhC2KfXMQv61+/U8pQzK1sWGb1yKpDIXNXhttFeSq/RZYgbfW/r68hAVyfGTbH8jXPqzAjCQNhb3uim6wtOEGpTBzRiUOaPS5mC4B8hFVl6gDwvNsbug43TLRkPnyG6yM2xwHvgqlpf5toi2OFmmBZPyFd3TDJMbplZH++JTomW95MhtK3J2RoYD7U0nZR05odnpVO3k1wUupnNcTvVvLo/QZ4ZaEU5sYe2NcbG/k33sFQVqNLLz17Oy3RDOpkbgXSRT+uyUrW3lRYeipbHgL+rCityE8+76MpvWpuD3lIAavTfJO+c8lRdxHdKeHsIbOv0Z8sl5755uyg0BM1gF09jrNzrxei5+k5
 kbDiP7jO
 wjnk7A6Zf3Yx3h3uGCATWwKA0w11nOoE2yFZjRGlttQPSrl61HtxZ8/X9HOwPCaVqCHbQU1NKAvtvas4+RfpvY+Swi51J7Upd1d16ZoUSApHg6Ax8H/ZFKWQAlw6xLDC5Yqr+pOZ5Ue5MRBBncOiDzSvHm2KSngOa8JsvYlg6CmsymNsd3tJ0RsclFN8WsImcwLE+PtgXn+tlWGHfdjSz113E6Gpuxw35zTK9yJvf/16+PNGOVQ69+Xk98EtRmyNrgfe20kDvUKk9/YyTdZv5VvEPo50EXXI4VJy4c+lSvLa8rPllVCHDtP/aqD3lMCfPnCWATEVh6J01aN79zWc9s/Ij5fBABD9CJ8SQ78wvk3tRiHW77J0oqgoDUhEpRV2K37UAcSwhjr/2LG761N+ZO+eegg/CT4k3AZijzg7UKHG0LiwQ2BRwIX8BbFF/R0v8ql5TwIKF3u9GwCSyI5FSEz4hFIWrq0o5lfySYNUacLCMWSFnWF/vsBV63hKSenNlagaMijpF9ZANNpCxBgTV5w0nmUAGg1fqa1xw82e1FZC/EFfP9Q1AxfP2iw==
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
index a93b7ef065f2..701276ef6cfb 100644
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
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -756,6 +760,20 @@ int pci_liveupdate_enable_acs(struct pci_dev *dev)
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
index 211df4618164..271da55af270 100644
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
2.54.0.746.g67dd491aae-goog


