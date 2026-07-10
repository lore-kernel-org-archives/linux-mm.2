Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D479C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB296B00BB; Fri, 10 Jul 2026 17:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB996B00BC; Fri, 10 Jul 2026 17:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772A36B00BE; Fri, 10 Jul 2026 17:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43E0A6B00BB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CB01140598
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:31 +0000 (UTC)
X-FDA: 84974150982.01.4DF7ED3
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id EF4181C0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QoNu0zgt;
	spf=pass (imf21.hostedemail.com: domain of 3hGNRaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3hGNRaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92/0TGptvABo802k4Z/+83heETiRRWcuAF49mOH2xHs=;
	b=mLHo02V+APWF+L6jBrz8cJf6d8H/Od8NKlSQ+ExXB7hL5niyyHgr1a37G4qTCYDE+O3ukk
	r7LCdQr+BF1YY44sRuWLIoKzZHu/PK4QwXJR5/55swBA+y2IbBemkEHA0wcnlV88LAjrc9
	SlGmk8RLOeL8LvKup6G5WQyNW4OOSYU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QoNu0zgt;
	spf=pass (imf21.hostedemail.com: domain of 3hGNRaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3hGNRaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718789;
	b=jm2M5odthLolNWOikvlsdEbrq7fNSY7DJpX/ivVcVzgL1W7zC5FrY1JXlpcODW/zoyBajU
	19dM/HRBGrUQm9/N0QRtDiEfZ3d9CHYvEUGLa/iHYulXpjmFtr+uFGuRJatVcxeYVTNHF8
	goRRfBZLuDqRPdhcYQVPZ0qVVEX0EpA=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-845317fa7e6so2160216b3a.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718789; x=1784323589; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=92/0TGptvABo802k4Z/+83heETiRRWcuAF49mOH2xHs=;
        b=QoNu0zgt2yKmftgaIgGxP29yYIhZz7tnRePhtLGcwbfYNfkmIs5GfnCdrmeYMV8D60
         9ng0RxdfuEdBYSNg/b0T6xa17KXx7SyVc5wEd3tedBittYXqHlAIkKcZHdjUUPK0S2IP
         hSGHEEXY0v9rHlru++fiOhliJ++MfnzqeRi9qCYXdTFFgD/tD9wVKNRP4mzcnULnfAvH
         eRyGksWKAr/y+PdeO1uqLKl01+qc/lv85IIQFzs8NVeT47gz+dtU9tanJ0eKyZdBmX9Q
         D7O3h7WhqgR2B2rmnMp2N8FQfQ/ga/8yr4JtO/SyDS2WRoJtPF8RmRMHiFmvVunJWjTD
         psTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718789; x=1784323589;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=92/0TGptvABo802k4Z/+83heETiRRWcuAF49mOH2xHs=;
        b=avYkYxLIJcPK6H4Iu/xvxYejRKmINRYkbCncZlEq+g0JXCP8rUqqGfy6H6dCcK6b8E
         Olfl+h1Pal4G/1VdICO1Ufw7IpPcs/18v8MwbSreTn3byXSFVGHD7h5HbQpvo+BBRUys
         NbyzmmLdj3t/CMLdmHT1Opup31M0fX1Ujdm/ltg0BoKWosUcPI479Ulnq6yG4Pkm1+N7
         YK7QK24aHqH+pczJNAMblsKbsiN+mV18DNmDUZSmzDDmgthe9ctm+si39z4H5rUmUCz+
         FP8rubGT6tuy1kUtYH3b8T0ABzlxS+fwVGIepswl1vfq2qYBIC+qEeI/NKZWroxqzsAt
         s93Q==
X-Forwarded-Encrypted: i=1; AHgh+RrwV8JL3deyfGDFXN8wzIrYpYTz8YYogECwWsKWMORYSEP2xbf5yNpS1HHusYCeBmE+eR2ay7xwKQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7ITmWphXFmStB7EMI1tOwq7VwhjQYE4VqrMjUCRacwFtEWKLk
	VIBgJpX2C7p1ZUwtsGuh2nShRhPQ3nhxUaW92ijaWtYldH80wUxA1U3Gr43rApSirf5B6ef7Q9F
	4w3OrRcAkBA19gw==
X-Received: from pfn17.prod.google.com ([2002:a05:6a00:a211:b0:848:7bbd:284b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ab88:b0:848:2f84:f429 with SMTP id d2e1a72fcca58-8488976cfd4mr571193b3a.66.1783718788869;
 Fri, 10 Jul 2026 14:26:28 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:10 +0000
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-8-dmatlack@google.com>
Subject: [PATCH v7 07/12] PCI: Refactor matching logic for pci_dev_acs_ops
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EF4181C0002
X-Stat-Signature: d4zm7efczyptjiqqqmn9m6o14dosg9zp
X-HE-Tag: 1783718789-753393
X-HE-Meta: U2FsdGVkX1/XiuZeVtL90YUC+xZrg/FE/F9zRH4zuNtBEHt3n9h2HLG0UUtK41pt7jbfkFj4//m4Ec3yNSJL3XwMS6HeZW/Uq1CJ92i7rJ1yNSGsb8i5XqFt8MKRA9kDUB2nPCLCXRgXfy3b3VOphl/s+yC4W2Cr68FZ9IGRgk8yCA1apP76HOqXsobf1XXNQofkMJLfNrG69uoilfdiWU/vhQdO4+LnerbTGOaSuVFPjdYaj+6TqszGPU+HdiGGX512EI0kBmUbSz4CLfTQWSVqc7KUCyRT15RwMwrkLuSpmdBPZzN0DhZJa6yeQKWloxd0b0FztZwAwFMHMj9RcN8PpYAyS5rgQXcfWF1xTLQylWF1PnjH2KSfXC5PKM+LzHV1X7FyDdHiGmgiZEjfnmegEJ8nnBEupPBsNz6j0eW93xjof58Ejk/m2RZU2vv/hk6o7UWLyJV+RaDtl/fCfGGp57oaGsC7vdD3NJgvLQSXpoH+cMN2dYEO7NNV08vvh7bH1kxEyEyvaKkOqktBddeg95/38ZBYhh9XxmgxIFTInWVLO8iM9JIpUjdNXTkcmvNOO5pttPC7CElm1HEXyzJk815OYz99bvXQUpf0K3AEjEG3etzLWIY0iZuI+2i3kRJxivypNmpNoPPP0rUn0yoX0437wHvd9kTxABVxdmflfuAelwhN8rywz4zTRtH53V/dyQd0m4yowWVqIJq+1G2WDTTvIGWLLiD4GLVdZPCYGsx1jP6jQ2eDAfNQDLX+K61kz96svpyP9FWLvqAHfPK0lkN+N9B8bb43bJr03ONZ7Gcfyz6vi75alZuZ3fQKO6ROk+n7pmqE/K4MnsemudHE3XZTYCI2cWjCWOhbJdYyr32nAEZSUfuv+dAqI9jzvxCn0oDhY0DBW0197d7m32ElxnoXAWRobotJRc5ONNYCibnTC4OuqBtsvCvkbcPpq6bNhOH8L8D44lPk4bg
 DDi+z+FT
 2xYCuDsLs/iZmRs/u5VuKAa/tmUPpqni2R9LMSRy7s40IU8FDYY9UCNd66blM/oHq6coubCcj+69ZOgmSpRmXavTvrQHApvpGkwv+4ohRyXF/85aBZzI/g25isxNQbMznEVSfSbNIQumlgNv7R9wElrx2apyi4MYOZuuEyoGiMfgwvjr+Xk3lB2SKrYnEQBguXFK7q+nD3yekXy4e89H3PvTgVLpvMcLf8KCVb6k1Tx8R4P+l/xPJ56ywqQG+SsyU2lWZrfdHFljwdjZvssTM+sET7fhB7R897B97c0wms+rrOYSPJ5QOrC4fh/7EbNQ+NcogdrCZak+eiYQdYWngMAWcOLMKWHaV6JElYNOmQAl5h8xO+zDj+Q5sr6LzrUEIGHMOubbjQLITwhcYigwm6Dut00ZFydhm7n0Jptlo3Rmb2xLzFwbCYHc1A8xHWdT3rI66v9lIysSSERo4wuQIkZQAvSXSL5nUX5x9cvCbZ/qBkAhlLg3T1LrEdvo79lO/2C/cfR7ov6PstNQV2ULO152rMrcbjXEYibsgSCs0f7OYmeeRc892RWOPDPLVPZ9DXYPImSsE9FkjfBnB6HIJY7y6AObmlNMoWiwzRvGFv1M1+UhGUQ6YQhDWT/nLygJnaJAMAeBjRLDgdZajeSGBnmRYYXLFt33K7Drjv1qYY7CYXBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor the logic to match devices to pci_dev_acs_ops by factoring out
the loop and device matching into its own routine. This eliminates some
duplicate code between pci_dev_specific_enable_acs() and
pci_dev_specific_disable_acs_redir(), and will also be used in a
subsequent commit to check if a device requires device-specific
enable_acs() during a Live Update.

No functional change intended.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/quirks.c | 51 ++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index b09f27f7846f..7ac39ec2843e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5374,9 +5374,6 @@ static void pci_quirk_enable_intel_rp_mpc_acs(struct pci_dev *dev)
  */
 static int pci_quirk_enable_intel_pch_acs(struct pci_dev *dev)
 {
-	if (!pci_quirk_intel_pch_acs_match(dev))
-		return -ENOTTY;
-
 	if (pci_quirk_enable_intel_lpc_acs(dev)) {
 		pci_warn(dev, "Failed to enable Intel PCH ACS quirk\n");
 		return 0;
@@ -5396,9 +5393,6 @@ static int pci_quirk_enable_intel_spt_pch_acs(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5426,9 +5420,6 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5448,56 +5439,56 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
 static const struct pci_dev_acs_ops {
 	u16 vendor;
 	u16 device;
+	bool (*match)(struct pci_dev *dev);
 	int (*enable_acs)(struct pci_dev *dev);
 	int (*disable_acs_redir)(struct pci_dev *dev);
 } pci_dev_acs_ops[] = {
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+	    .match = pci_quirk_intel_pch_acs_match,
 	    .enable_acs = pci_quirk_enable_intel_pch_acs,
 	},
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+	    .match = pci_quirk_intel_spt_pch_acs_match,
 	    .enable_acs = pci_quirk_enable_intel_spt_pch_acs,
 	    .disable_acs_redir = pci_quirk_disable_intel_spt_pch_acs_redir,
 	},
 };
 
-int pci_dev_specific_enable_acs(struct pci_dev *dev)
+static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
 {
 	const struct pci_dev_acs_ops *p;
-	int i, ret;
+	int i;
 
 	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
 		p = &pci_dev_acs_ops[i];
 		if ((p->vendor == dev->vendor ||
 		     p->vendor == (u16)PCI_ANY_ID) &&
 		    (p->device == dev->device ||
-		     p->device == (u16)PCI_ANY_ID) &&
-		    p->enable_acs) {
-			ret = p->enable_acs(dev);
-			if (ret >= 0)
-				return ret;
+		     p->device == (u16)PCI_ANY_ID)) {
+			if (!p->match || p->match(dev))
+				return p;
 		}
 	}
 
+	return NULL;
+}
+
+int pci_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
+
+	if (p && p->enable_acs)
+		return p->enable_acs(dev);
+
 	return -ENOTTY;
 }
 
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev)
 {
-	const struct pci_dev_acs_ops *p;
-	int i, ret;
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
 
-	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
-		p = &pci_dev_acs_ops[i];
-		if ((p->vendor == dev->vendor ||
-		     p->vendor == (u16)PCI_ANY_ID) &&
-		    (p->device == dev->device ||
-		     p->device == (u16)PCI_ANY_ID) &&
-		    p->disable_acs_redir) {
-			ret = p->disable_acs_redir(dev);
-			if (ret >= 0)
-				return ret;
-		}
-	}
+	if (p && p->disable_acs_redir)
+		return p->disable_acs_redir(dev);
 
 	return -ENOTTY;
 }
-- 
2.55.0.795.g602f6c329a-goog


