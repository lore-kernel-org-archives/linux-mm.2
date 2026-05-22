Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D7CECD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B60F6B00A0; Fri, 22 May 2026 16:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367466B00A2; Fri, 22 May 2026 16:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1936D6B00A3; Fri, 22 May 2026 16:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 089B86B00A0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D3AB407A3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:21 +0000 (UTC)
X-FDA: 84796183122.19.222C4E3
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id A2159140014
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kx44PHGH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3crsQaggKCIMkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3crsQaggKCIMkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMXxmfHGErf7yBzoXqh/yDUR2jlzP0FOZNAJXyHr7Dw=;
	b=VDSZWTmnAfIjebYT1xBrzGKlkHQRAqhv/m/fqJCm0XqAvX8aphItHu2Hh375/Z6N/DifIl
	mr7xdih1Zj9pHqGAvdlEpmF2DwYz7b49Tik1KKX8MuFfE/WLkzeALGfyol/k7nUZR3Rx53
	nhT4UY/SlIniLYYbTuxQjvl+qSyJg48=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kx44PHGH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3crsQaggKCIMkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3crsQaggKCIMkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481459; a=rsa-sha256;
	cv=none;
	b=Ctu/bac4Xyzjk6nC6D9lGnVwlkGjHQKUkRNE8kSLM64glmsuovBmlHLqGX1OaLCNeaOdnE
	iM1/Xgg3q5MRrySSN5TtQiiL5nAQsmnD/ZnFCEFAqJrq3o52sqh+5mYSnHhuJSvnPODuGl
	KrS7t8erhCMzCHw5jOOwGLx6xvymsYQ=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-369ef27fd09so5909832a91.3
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481458; x=1780086258; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dMXxmfHGErf7yBzoXqh/yDUR2jlzP0FOZNAJXyHr7Dw=;
        b=Kx44PHGHr76oMrWE6tmDb43FAWK9p4XLZL/rNWKHJsuYjZSESp3saDKNCRubQBUvrO
         fOfwS+ZQLzDqsAWo+uotb+eMXlNfrwNgiV4QK48/NICDWRaNCzlN282rsPB0k7w22pGj
         s8EDDR2Cpf1MsEfDp+HB/UMd0FGhF8Sremw6PUUggGZ4bfLZ894jPtlKWyLCfKdignwX
         bnNA9iQBeaPpNBP2T0mE07hVnalvqsQBZqoghrdGoMlVGHfuuNTjTkwJvpGG5asUHnA0
         HODUTZ40a3hFaW876pyYAVb6pi/nzv7FhefY7h1z1vjQ0DrQ77sbnKAxTHh7KFT8f6zn
         7l3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481458; x=1780086258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dMXxmfHGErf7yBzoXqh/yDUR2jlzP0FOZNAJXyHr7Dw=;
        b=ROKsVI3lbtFMdfL5ayEwjY0Dnew7RILpVpytMTxMWB5IZQoSQTa6lHimTN2xse9Gjp
         wI0X0VfWxLt5WtMa72JJg5oJ/zAaZq8Cl/eo9vKD+TcpFqRSLVa5Mh5XffUEG/XvSQ0s
         mdUvIUJBY3Xl3uEUD+M7OVc0NqbNJBl7lVJwl0Utev2KK0qcgnTyhcS2Bx55UDPjX0hz
         dywJwEaErzILJ8ZgSYgd7IpONJokGtxs6eeGmxblXqm02YJJOEvgsBWgQh/qLuk3/ATW
         HEHs00hJ8kPTbanyOZX8V5BnvrohXRr1B5jEJiAKS4RF37YA16d/swMM/NFUXTj8bfuo
         WX1Q==
X-Forwarded-Encrypted: i=1; AFNElJ/qAZHI38N/O2dXGz/CkeEtGB47uxNBooqwRjcWcijwADHrBjzz7/2dT3FLpUTWhP3VLoUnki/wnw==@kvack.org
X-Gm-Message-State: AOJu0YwwCYGNQAbXDCR9z3UzEBrV9KyNVUnq45SU6s7zV/lLnwrTzRCt
	brWMa4OHsVi5Nj9rrarnv/9yXcfxQ8fKqlfFBb3kJORbnulvcA8lhXdbVmtmEEuWYao7SWwq3uc
	IN+PR+3nAV/nZAA==
X-Received: from pjbsz6.prod.google.com ([2002:a17:90b:2d46:b0:369:4369:c7f9])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3807:b0:366:10f1:3d91 with SMTP id 98e67ed59e1d1-36a6741dd88mr5140261a91.1.1779481458189;
 Fri, 22 May 2026 13:24:18 -0700 (PDT)
Date: Fri, 22 May 2026 20:24:05 +0000
In-Reply-To: <20260522202410.3104264-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-8-dmatlack@google.com>
Subject: [PATCH v6 07/12] PCI: Refactor matching logic for pci_dev_acs_ops
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A2159140014
X-Stat-Signature: igj4put1tneyp1t41q88zqw7gj96ugdo
X-Rspam-User: 
X-HE-Tag: 1779481459-758403
X-HE-Meta: U2FsdGVkX1+4bZU5pRAyYhdyBKVdSYQuO2bPZlhDj7P6uMldHGM3mhtt54MKtGWrRmf50QXAPaueWPxYQvUfYnrnWSprin1CZypF6ODb0P1rfr+/2Sq9llZj7QOs7ZIT1dlGh2y9yHE9cjw+TzTMODqwmzJvwLuIWmdVgbjlfgiGdKEB4Fqvwq2KPuPRVeqvhlnQp26uhje90Vo5zAyDtcWHY6R0eoLGr7pXfamr6MI9fLRL57pzAHJVzG1ikhOf922DokzNVF2siU+Nc3eyWAB3sh9ahBylLzlg3swCoVUiZyP1i2XsKBdtAF7zRLFBRLhmP+bXZbME9LkgdP6sOonEDpI210Zn8jpSQJbPjYeYAK7n9dcyfe6yCL3FqQJ/uhwADgivLiWULOYoHSo8BXYwJfxB37GdnpPQ9w3iRXaa0jZWXdH0jhqqU8ND+vsAeT53ZQicJLXX2/G5/ck6pCh2dHxcjIBgwE9J7j9vxn0OG1tqNeQco090CBPmJRQDlBICCafQijUiEsk2IMJcvHlFclONwYAUW/WwrqmqQiL9T1o7XbgVfMSy2qtgqZExA1pC7kAd6XapsHFKIgFvRSN0QfByOoJHFP9Eb+npwQXA02FMjmEH5qQRl90Q5LZpa0AbuglUpXszuFtfoQ472bzdujHP2/i/is2kXMiAHS8QY6pKgarHiQwdLz2PA/vxAMOqlVcJKiIfqtOSpBcG4qTZDqvtvCMBtVgcuXx7PAQ2njV3tZVdjSKFwi1lI9femRHRPB+tCxzXp2jxK8i77tCyYZl4u6DjmlIuCQR3dYP+eJ4QeAMy05rTTP/954anj9cFvHJJBzbhykwdq+9zLuaxn88nbA3DPgK1ZfvMwd7JEWTPdzMjbom5ViXrpWjG9qbxUXEHzqnP+AAMxO+rKdDctjsQbbJDP436Ddj00Uey4gX/XLtg2jf6e3/W0vGe+RMbjbpZBuel0Ut15ql
 hWPLEsh4
 TPCknBzD1V1Z2bCfXghLB/hcpwzVjrkBv8rXNFe8pG2EGR/Tk/wjnjTgRL5xN8+erLWGWLs08odFcHlA2VBvQIIK38YLMjC+XE47yXQQ700K+A3tyQkIDRT9qVFAt2AtvnEzOzi+B+OsneW/fq3SE7gqdbx52A8aommMazDD6eP3d6COcljR2eRbzWwObiV6ySF6dnkTBUkas+9ay8m1NkaOhNDxtLB181NAPri28H7YQJi/aiWaVBuHwhTUmepmf1frAmAflEqkK9YmQq5A6Uv1TwQCyQPrWP8MXCzkPlqpj8Oo/ei/4p0s6UWFw9m3RxtxEongLnYav2pWkZDGrXyygZoMQiCLXyCwQEXYHP9NDD4QRKeDxefy0qtgx+UzXBAeWKlr2qP4M0TYVURjZulpSJk5aXXaacWM8fBGLC1V7CJCS9EH/cb1aDMDlyXCV7fh//AbjoBFDlLDmmuTjCnjq9gKY/pPFbIwg0A0remHPZ2K8qULXEhd7yfFcgAwr93kH9HX4fB+hpaERkS5btzlHFoyqbeR9dIUEHvXNIizC1Sb5vUm/R+Te13UiyqjGhxVC/PCJxRdaihFgS+rKpQpKqk3+5hP6XqfhG6CZxypy/5msU5cXzZX1DJYf7hj2jS5o4nbmb5Kf6Lc=
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

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/quirks.c | 50 ++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index caaed1a01dc0..171caec2bc47 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5384,9 +5384,6 @@ static void pci_quirk_enable_intel_rp_mpc_acs(struct pci_dev *dev)
  */
 static int pci_quirk_enable_intel_pch_acs(struct pci_dev *dev)
 {
-	if (!pci_quirk_intel_pch_acs_match(dev))
-		return -ENOTTY;
-
 	if (pci_quirk_enable_intel_lpc_acs(dev)) {
 		pci_warn(dev, "Failed to enable Intel PCH ACS quirk\n");
 		return 0;
@@ -5406,9 +5403,6 @@ static int pci_quirk_enable_intel_spt_pch_acs(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5436,9 +5430,6 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5458,22 +5449,25 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
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
@@ -5481,33 +5475,29 @@ int pci_dev_specific_enable_acs(struct pci_dev *dev)
 		     p->vendor == (u16)PCI_ANY_ID) &&
 		    (p->device == dev->device ||
 		     p->device == (u16)PCI_ANY_ID) &&
-		    p->enable_acs) {
-			ret = p->enable_acs(dev);
-			if (ret >= 0)
-				return ret;
-		}
+		    p->match(dev))
+			return p;
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
2.54.0.746.g67dd491aae-goog


