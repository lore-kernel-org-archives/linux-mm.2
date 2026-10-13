Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F8ADCC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCE16B009D; Tue, 13 Oct 2026 12:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFDE6B009E; Tue, 13 Oct 2026 12:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BF6F6B009F; Tue, 13 Oct 2026 12:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68FD26B009D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DA0C120D26
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:46 +0000 (UTC)
X-FDA: 85318129092.11.3576F82
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDDA5140002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nDtQiRso;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3h1vOaggKCNQ3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3h1vOaggKCNQ3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xeOaWY8G0RyJWpiIZt4rGXklqrMOz8YRWSRZ+Jyg5IA=;
	b=znzcf5/KAmYiN/Mf1dtk46iYGRDD7zBelCjzfJh933YGHlkU+ql2jStMC30Xqqg0uCeZoT
	O5woihgFQ+XUwBCnptotZ5W3359PsfQeh5ydUt0k/bO/7tK/RAfFl557CnpLfW1pI6Gm75
	Do0AUWMltrwKM3FlxgrQt+LXukqstHE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nDtQiRso;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3h1vOaggKCNQ3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3h1vOaggKCNQ3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908744;
	b=MZA6oqVjlueD+UFsHG72M+HIUC9RR1CoEWNwITRzt8qxhhgk2lm2KTiHJpekbSvY9shhnN
	SoaI633/RF2pkDfAgCRB1Fjw4VQeeF6oVBU9TrvoyQ3XwytIivyAyo0ys5en/aM+nONGBK
	yJXW7m5AZ9OHQ/6JkBSF2jzQw8OA/8Y=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e8dd9b9743so20122665ad.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908744; x=1792513544; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xeOaWY8G0RyJWpiIZt4rGXklqrMOz8YRWSRZ+Jyg5IA=;
        b=nDtQiRsoUVXEQn4fpKAQMMaL1JeFoL3tq+LOpuKtf1KXEo/e+Yn+Iz0Fdku+yVByur
         JDedlmFisxft1PlpG0Jt1ZIt0O6HWTkX7Hq+IaV1xHuAVIatQ9ERMO3iWRUxTM7WwfZF
         bZmt83mD77YBMWhe7KyRjWhoH8MTrAA5hwcgeswibXEatGwyMhXVGn4UqAa/3O2Ykqkn
         azBUf94AYkZ9nq3K5ioJyzIx+CBxu+UxM7toQSaBSmyZFnaQk9D9wbkaGYKLdgq7ZjV7
         YLw8NW5umnDxDcXpBH0tlqcZpEc4Snm9Wsaw+zvi6EU3aX3KugvGT8Iaqfd/QODfHXDj
         NNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908744; x=1792513544;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xeOaWY8G0RyJWpiIZt4rGXklqrMOz8YRWSRZ+Jyg5IA=;
        b=sUfxX6qxzCc7HC6BD10PRGeV8RoLznk3fTfS5x/Q6OpwKcRop4zvMNyvnfbMOhcJOf
         Q0afPoeYouPgFLPyDFyeHkJsyjXvF7Co7o2C/EllH766Y1vWJDnJGyhSeV/bmQoMPxig
         jJaGjiU3hk0oRVKqvW4TqC4NMK2Mr7cVdMfefHkJmParDXt/3P2A4jrwL9e2Z5dzJflP
         kt3qO1K7dbIrhTVWW8d7rIq87Fe5dcmYi0uX6M47aKULmyIFnqwXL+hNrvEhuinD5LPm
         r2oDDGDeDUN7VXhBQeKuY0R/b9uEokaz72KvXIzDT2nDGvTVyNYm53DnUFYhlhHzdMAt
         qlnw==
X-Forwarded-Encrypted: i=1; AKwUvByK7qxwwnKbH2TtH9cJK8ajslAhOmW13JeoPb7CNAuJ97qbEnDUtOcKumk2mx1qoDPlMwxTdNzHFw==@kvack.org
X-Gm-Message-State: AFq9FYLb3/6Pt85iLZmzR3uTbFXyjIis9oHGd+wOVWSJ6eBuC0SkZM6y
	xTsNy053coR2/1OckbYtoViFwh+emz3os+gA5ZR/ChBPiftV/hTIEiuTGjK8BoajGHEGT2KcF2/
	7T+7pvpI+dSSfRg==
X-Received: from pllt11.prod.google.com ([2002:a17:902:dccb:b0:2e5:b835:73c5])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:41d2:b0:2e4:cc75:2707 with SMTP id d9443c01a7336-2e84280e7a2mr118758025ad.7.1791908743529;
 Tue, 13 Oct 2026 09:25:43 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:23 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-8-dmatlack@google.com>
Subject: [PATCH v10 07/13] PCI: Refactor matching logic for pci_dev_acs_ops
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
X-Stat-Signature: 1e5n4wmt83oca68tff9n1yaya9cyjjms
X-Rspam-User: 
X-Rspamd-Queue-Id: DDDA5140002
X-Rspamd-Server: rspam08
X-HE-Tag: 1791908744-220351
X-HE-Meta: U2FsdGVkX1/pB/ujbrfTr/Oob+WbKAiVXpLc7Ox1l9Je5EMP4Tn9WEUnuoScbFYdGWrDF0nFKBR0uzv3dgrhokAjoGYT479i382jphM8nYDZl7IzTJJTUqE93j45Hn4zKVOJpr48fqrYEoDppxkWeBQSxCptRld18dhIXorZ33M92Iu9HdDXr+8p3lNdqgRRNm/txmC5y/xrv54YY9PYLxwM9a5w22wNOhmXrRAEo5IYlnPf0bvh4d2Kb5+JlTeTJFtFUixC2WJz3NPXzsvHE8JlrBZpZizJKMp9CpP8uZxKA4J8ikZmyuEHu+oPhD3Xb+jAE0nonevMSgFOnEahQVvxY4MWw9W7vteVfixxRAl6pIRy94GKN+BnBsPFTEmAUFXMC88uIXZZRBgwzhEU8kEIASALsvMlHhVIZ2b/TUO3Jf8afy/BgEF0RnoUa8SJqdn/jFKx3HI8AuApiFbMIiUmt0vXX1GF3xPe19v6EnmS1DXnC+gYWEjxBxF/JeJA+O+qsxBA51QyjDU9U1Od2iEJiNPpOEEkv2XNdWqlNMfRXjdfMZLbVfjmCkxty6cqFkVpLZC+emSE9mtXHNUfVAvgNr/7hlU09Oox7kP+dkFL+O+PL2YN2oEFLjureX5y0oQKUrBmlHbVPbRQJSn5lnAitFRpK3g63b8f0aBAr16XkoXISh86QP96ZaNdNKkyCJ8jipxqFDQ6787NktbDYiURN4Yw2tEEpgVnlhqAAVS5Gb8qS+WNCjRCMzfeZ2vBGVbvHEKGt0j5HgSvKWNTA7KUJYe13NIm78+VDX3NdufI5zG60iafb5RfO/BdLe7wfE/YaGUCWC+u2m96qYM6fNLX9JFE9Eo9QrbZNyLDmB7bBtM7v+a8yAnwlicsgOSKdUhRvkCunbbJwuyxkkXTuH/ygSYEOZT3H+yWYG+V4m5yxkydfVgvE00p3HfwqZogIW0+C9sf+cZX/RIi5Ld
 BFyIw8yv
 2bqFsBEDMfEtO554TMPV1tTNcuJc4bfvtsfCIbKRCHUPoF6KCfuFKWa/nDtsgUtSTw7gJw8PcpuwFQ7Etg+cQvZeF3vPKwzDfdGMazMKl/rIsUreoEt0yJWD/40uTGrbjP8ixRnSQZ9MgKV8D4nX3/2PxKmq+qOJlySx/gX4uREwAe/dBDW2MT9Nz5u3M4xFEFLXoygXu3Bo/1uQAUqGbEfBs2+YPobIC5dNMsdHDtMoEVzr8ln+2YfhwGWC6eQDwwOGoQy6GZDZXdXTDBUa+9HkH40arpBDeNtwFSwKAA5N8LzOpsYUm69EomR4LL2FDNyTDvVJEd7t3E8vfOhEpwXfubItsskL7oqzumR/sGGvdx1k+fk5k8WhDMQJmslTc4qPNbC9ozZrA2znY05ogheggdmtNj2NljST6dz7JAasj0Gfu9u2lHb6aA9oVqTbHBPcc6TJOpOa36NZS768Sqd9e9kwo2rk87nQx8wd3VEwKfUcLXw+ImzE5jznQml0HNYbuSTjjkJy5VQ1wSolfR1YJno9Ycn+OF25kSj80Xb1Rr84Pug/mRql46M/ycOkQVQyN0fC6/nPOjYOwyD46a6V6YfFDZizFyW6w5E//ZqvQv1jsh9PZsF/YzUp3KAPaQQTyAPyhba2P2iXozOnOpXoiBoOMT3sbpW5OPDiz6rnD5ihVF3R9CMQxXhf7GumVfFVU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor the logic to match devices to pci_dev_acs_ops by factoring out
the device matching loop into its own routine, pci_dev_acs_ops_get().
This eliminates duplicate code between pci_dev_specific_enable_acs() and
pci_dev_specific_disable_acs_redir(), and will also be used in a
subsequent commit to check if a device requires device-specific
enable_acs() during a Live Update.

No functional change intended.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/quirks.c | 51 ++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index de9bbccda21f..7aee30734303 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5377,9 +5377,6 @@ static void pci_quirk_enable_intel_rp_mpc_acs(struct pci_dev *dev)
  */
 static int pci_quirk_enable_intel_pch_acs(struct pci_dev *dev)
 {
-	if (!pci_quirk_intel_pch_acs_match(dev))
-		return -ENOTTY;
-
 	if (pci_quirk_enable_intel_lpc_acs(dev)) {
 		pci_warn(dev, "Failed to enable Intel PCH ACS quirk\n");
 		return 0;
@@ -5399,9 +5396,6 @@ static int pci_quirk_enable_intel_spt_pch_acs(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5429,9 +5423,6 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5451,56 +5442,56 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
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
2.56.0.385.gd3acb90ef8-goog


