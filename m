Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C7460A2617
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=JHRIjlYz
Received: by kanga.kvack.org (Postfix)
	id B58DF6B038E; Mon, 19 Oct 2026 17:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31366B0390; Mon, 19 Oct 2026 17:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A477D6B0391; Mon, 19 Oct 2026 17:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7001E6B038E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:31:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E220E1C41D3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:26 +0000 (UTC)
X-FDA: 85340672172.26.923FDCE
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf16.hostedemail.com (Postfix) with ESMTP id 20A88180002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JHRIjlYz;
	spf=pass (imf16.hostedemail.com: domain of 3K4zWaggKCPofocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3K4zWaggKCPofocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445485;
	b=x5cPc+FvuAEykziZHQobfp4I564mUBDVay6fxUwTAkAttApmW4Ng+0lO/YUsFKzZptYdS2
	Bsmn8NxXQz86oH2P3aZgD98cx6MukzR+ckCyESITJDfwSqAm4fv3/RKLVMnsDoRXpwnqHe
	2Ifz8DytG9/ADXlH14AF0TgWcpKMHak=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JHRIjlYz;
	spf=pass (imf16.hostedemail.com: domain of 3K4zWaggKCPofocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3K4zWaggKCPofocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OlOiZMSQAlq56d5O025wMJ9SWaeJFCSne26CemMgHno=;
	b=Y42nn3GN360n3mxdp16Dyw+ET6WJhb5nmIgXUtmfC6UzK6cHny1HrVCu/FEVN1ORsJvSvI
	JOtzm2VfFk+dVWfrbItY2Yw53ias6FqqtM28bnbVDEepQYMDqztcoa2DFt2T/JgUWClfJM
	hfbdbIO7BBEH6B8FUUAEaM6KsFzWJt0=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e954d87b48so37640595ad.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792445484; x=1793050284; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OlOiZMSQAlq56d5O025wMJ9SWaeJFCSne26CemMgHno=;
        b=JHRIjlYzl8XXBjsQBj5+lVfSWN/spZ/by+pOEDCWoi14vGejLFXydUjXiEfPV3Npkv
         qfFoU59IReF33JOirAQhm8QozmDtbSQUkxVbfSM7jxeEKsEFD2RIDAKpadwYj0Lipd/R
         xZtyeicix/NBxjK7id84NIRz3gvl2xi98dcb/LFUc4xzpIy3sVveybYsUJ95EndGUG6H
         Y4U2fhgER7QMsGTf6BjlCvbh/o70jR0JNWLZP15etfSaD+xPa5EIvpr1/BZ3bbqdvIcR
         O6vwS4IrJJw21N3omxVBOvcWx5FAwICtPT7uyYE/ysnMEjQsCwSIfJiGJQ9B7KNmYlU9
         kRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445484; x=1793050284;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OlOiZMSQAlq56d5O025wMJ9SWaeJFCSne26CemMgHno=;
        b=NxAgobJLvLDsiNa2mBNRy8xWzjsOOQLE3g7K1wXV/UBhE7jWoFYw4mYS++vuYyJv4P
         SUMV4nFum9DgR9gzxVyetCarOHJfDBtGl6ILeRRwsCQYwONLx18itaL5jaswdiGaYUMB
         3oQ4jvj+DzCWx7fUWXvMYOVTRqp4lWZDpHlJXCTMyo7RihSAIHsHa8NbDrA8mpMYkksU
         xRha7KIH5Cuz9faWwTDJ6SpucUq2WQwWbgG5PrkxSNDZm013Dd4cw8c1YlTZo0yU1Y+3
         j5634ytGnyfgZRntp+iyQ6GhnE2V2babbT8apAwkMhNGH73ZKHGwzx1rDZRI86rRDIcU
         qnQA==
X-Forwarded-Encrypted: i=1; AKwUvBxbHEhpawp5a7s6BEZ/YxZN9+zS4EhZgrvgopmwpoWEExjqcgVGA86IJ02E8ILTOQ5u9a5qiKEH+A==@kvack.org
X-Gm-Message-State: AFq9FYJjXljAGJ9uScnkBXvZ7mmGH/0RVamX4xTZ9e6Qpsr9eAqoN01H
	5ePXVAmbu7lNE1V8165Q/ljKOVdML9CJ2BufmKiCd4G+ZgHW01t3ulom4yPybncgeo+LeH0KtYq
	hft3aNg9VyCcdjQ==
X-Received: from pllx8.prod.google.com ([2002:a17:902:7c08:b0:2e8:31af:11b0])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f607:b0:2e9:8505:5471 with SMTP id d9443c01a7336-2e9a68343d5mr79186475ad.7.1792445483766;
 Mon, 19 Oct 2026 14:31:23 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:30:47 +0000
In-Reply-To: <20261019213054.3157159-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261019213054.3157159-4-dmatlack@google.com>
Subject: [PATCH 03/10] PCI: Factor out bridge window probing from pci_read_bridge_windows()
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	David Matlack <dmatlack@google.com>, 
	"=?UTF-8?q?Ilpo=20J=C3=A4rvinen?=" <ilpo.jarvinen@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 966dssr7kycsdxby15e13amtiyk3rikn
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20A88180002
X-Rspam-User: 
X-HE-Tag: 1792445484-635251
X-HE-Meta: U2FsdGVkX18STj5kt+jvOhETvYBwSNtFZzUP9U0FEh5KmnOm/1zqBg825t16Zl+G+Pmn1pn6CSfZieeqXNezp+UY2jSVFbYC2GNCb1QGlM6hoNKmFbT2rdp4CrJPdNqFQ6tlIk+uzLoel+IqrDYAxjq2ynrc00JSZn+6OKKj7Qswu2kxvgfK60zjkcwgNWPgCN90Zqdwpd0eg0wnADEx+TrG+RO8r4Ln8mr36JYUaKdGzB2f7O0N6giNgZIoL5HSjK0NGvXFXBtHAGVbp+PBNzaEppKALrEf7TTUo98IHgEeKh/mHJ8eTVCN897rmnqEvYXfE93DuvMpYwE+V6vT/ATkOAno3IeeVHZxjxedDCUpRRLzo1pOR8uuDBvU1SVe72K/34WW64m2nddTJ1IAKShoEhXG9I7ZN4CKw/SysKf8PrmuT2CCcIHfH3k30if/x7mIpYlXXcnSO+cDCX6/7BxjooL+t1ES+mbleaU+YPon6cW+3Hw6KkRJ+lZQL0ftdpCeE9WD2TX8m1ybKbOc/zS/tnhdYmCityB3v/gVrBwL0wK22ZxUn50eENlRjgJl3Zunc9l8k6Jp/J0gyxbRadpMosGbOnAZY+EhQK3/BXzwPLgNjDhoRjga/+1h2x9FsQl0OKaIoJGPlDJSGUwtAoj9A1yeQovEMGJI9KlQAKGi1s+Dfkt82rsW32GzZzv9qXY/DAYrl0qtdGHbCeU6xmtAyCz4IY51jy40Vgn2RF8VE2FBqp6p4o8AdufwcrlcEdRmd2qsK86qLhJu+NdaVdjVIZTsVnBigy7Ra+QohK82gxmE2TG3WgdHWnRERT4AgCbior5WKAxfyZRINTE5Q/L7kcFihG0NpK64KEe9VOkltoMcqGgeUESZpTAMyuFNP2l+fIB5DURoR3jWofHw8ACc88dY1Is2NdCk97ODmgVT14lqeXyM3B0vTYGgsYAlOG3xn5NArNbSw84SNUi
 L3CfU7Gs
 WMtGWGRFtuV+RksbAcaANast7AdUYHCbgi84MIoVZ4DgFVUwKfkl09orCAvQv6cvJMphoMlcyrKFjamPP6JZ4THvo1MLdHCyJOnmjHIGmJ0RZhXjVtWzNZaUg6Uyqe/pHhXPkAMJ4VKDUfzapHYpSyNQb+1nrUPkqP8dpxjxV7jmpqp50qvmx8s7HWNB6BNRjPtclzkI2bx5E2uiZCtjuWwCVUVvcDmxBcvBfAhpNQYNeBm78lhlkGnW0fXwM1PMFi8UDqcMOQ6orhjKTxitQlr60Jd8I487c4AM/rlmrYTAo9ZOcQ3ryW9hkjYyLe3NskTvgh6lCmRkxds0Q7OIDBoIbzfJcbQrvhkZ+iOjFSXyaBklVIdZCfz/588txmRk+UJFjbGrUzXcBWh4oQGrs9gE7nXnOa/EC/h04kL98W6WdLB3//GhaaGgXfwuSOSpfHFcwBDbsCiLCAyIP1a6R2Kt6lqAtPyi7/DdPS5IoBhu28VGB8zHxUMo5U3TJXoRs1en8gqOKOKGGkQ7lgxiGVnjVidTjynieEZIpUbsEn+TiHSW+4HmZ+gGFm48u6UMrsI2eGO8zd8Vuj3GW7BVzvyZSErd9RiIx23oo9TkrGRDDqnvSFLXLYVfYg7U/bBbMIwsUwfKIWeLLUdc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move the code that determines which windows a bridge implements, which
requires temporarily writing to the window registers, out of
pci_read_bridge_windows() and into a new helper,
pci_probe_bridge_windows(). Probe all windows before reading any of
them.

A subsequent commit will obtain which windows are implemented by bridges
preserved across Live Update from the previous kernel instead of probing
them, since probing can temporarily disable windows.

No functional change intended.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/probe.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 3cb2e481eddf..473e4389ffae 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -520,19 +520,14 @@ static void pci_read_bridge_mmio_pref(struct pci_dev *dev, struct resource *res,
 	}
 }
 
-static void pci_read_bridge_windows(struct pci_dev *bridge)
+/*
+ * Determine which windows @bridge implements. This requires temporarily
+ * writing to the window registers of windows that read as zero.
+ */
+static void pci_probe_bridge_windows(struct pci_dev *bridge)
 {
-	u32 buses;
 	u16 io;
 	u32 pmem, tmp;
-	struct resource res;
-
-	pci_read_config_dword(bridge, PCI_PRIMARY_BUS, &buses);
-	res.flags = IORESOURCE_BUS;
-	res.start = FIELD_GET(PCI_SECONDARY_BUS_MASK, buses);
-	res.end = FIELD_GET(PCI_SUBORDINATE_BUS_MASK, buses);
-	pci_info(bridge, "PCI bridge to %pR%s\n", &res,
-		 bridge->transparent ? " (subtractive decode)" : "");
 
 	pci_read_config_word(bridge, PCI_IO_BASE, &io);
 	if (!io) {
@@ -540,12 +535,8 @@ static void pci_read_bridge_windows(struct pci_dev *bridge)
 		pci_read_config_word(bridge, PCI_IO_BASE, &io);
 		pci_write_config_word(bridge, PCI_IO_BASE, 0x0);
 	}
-	if (io) {
+	if (io)
 		bridge->io_window = 1;
-		pci_read_bridge_io(bridge, &res, true);
-	}
-
-	pci_read_bridge_mmio(bridge, &res, true);
 
 	/*
 	 * DECchip 21050 pass 2 errata: the bridge may miss an address
@@ -582,8 +573,29 @@ static void pci_read_bridge_windows(struct pci_dev *bridge)
 		if (tmp)
 			bridge->pref_64_window = 1;
 	}
+}
+
+static void pci_read_bridge_windows(struct pci_dev *bridge)
+{
+	u32 buses;
+	struct resource res;
+
+	pci_read_config_dword(bridge, PCI_PRIMARY_BUS, &buses);
+	res.flags = IORESOURCE_BUS;
+	res.start = FIELD_GET(PCI_SECONDARY_BUS_MASK, buses);
+	res.end = FIELD_GET(PCI_SUBORDINATE_BUS_MASK, buses);
+	pci_info(bridge, "PCI bridge to %pR%s\n", &res,
+		 bridge->transparent ? " (subtractive decode)" : "");
+
+	pci_probe_bridge_windows(bridge);
+
+	if (bridge->io_window)
+		pci_read_bridge_io(bridge, &res, true);
+
+	pci_read_bridge_mmio(bridge, &res, true);
 
-	pci_read_bridge_mmio_pref(bridge, &res, true);
+	if (bridge->pref_window)
+		pci_read_bridge_mmio_pref(bridge, &res, true);
 }
 
 void pci_read_bridge_bases(struct pci_bus *child)
-- 
2.56.0.212.g129ede20d9-goog


