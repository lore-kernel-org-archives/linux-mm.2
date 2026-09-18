Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD419C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60FE16B009E; Fri, 18 Sep 2026 16:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECDB6B00A0; Fri, 18 Sep 2026 16:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 412046B00A1; Fri, 18 Sep 2026 16:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF49D6B009E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:07:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 648B3407FC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:03 +0000 (UTC)
X-FDA: 85227966726.23.33F87C4
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf25.hostedemail.com (Postfix) with ESMTP id AAC37A0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QE5gy24k;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 35JmtaggKCCsKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=35JmtaggKCCsKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QE5gy24k;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 35JmtaggKCCsKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=35JmtaggKCCsKTHaSHJRNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762021;
	b=iQVEubI3ZC6buvEEvBt4OghZUX9j9UaZ4xFmwp+HYSPfkb5/HH/8/eoekTMd0BQoyCYPL+
	pVcH63x8iC+qxL8jiYq6G1nLtYSilYCAUiiUXQFNyQTspPcBWJnqPZyC5A4hyX5b6C9PCL
	1r8HqSivDO9DWj15rWWv3LpUbsmUGBE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZYph3SzF8DNc3MuGEDpVyyWuyM4ge/DoPLpl5bxHLs=;
	b=PEoeAyI6EM9f/ukvymVm95Cs/I9+RPp8ACcV7ufbCiscZCnzwLnObZmT6H+sGG901kzI/I
	frob+aVDGzUG+xFKM7BnGXdRBkXpFCntsIxLRueHJQ7OBXJwhTxJyJ6L+8Y6FaWsXSK9XC
	Kvt31DzOyY1dg9DUVmKNEM5J6frUg+E=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d94a158dc8so20609805ad.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762020; x=1790366820; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8ZYph3SzF8DNc3MuGEDpVyyWuyM4ge/DoPLpl5bxHLs=;
        b=QE5gy24kE3c3upvM1+XTzTip7K7YPrPl48y3HAnqZKuwWeQIka1wpiCdbRX9wJt0qO
         amAyYrrOqWtZUWGAw6ciXLO9xdStMVLVyHMWnqwcQieuZYFUHiQV8gjs4Jypk3PxT4Zk
         oux1Qf0K14s8ZV8nWbPBJkr0GXWQSd4QG53AkcQnZ2RkPBUj2oBXEvu0DVBa1uUymXKN
         hf6A8vJqI1y3FHIEmFWC+loL86ej+TBakV6gd9m6pCHRsaiyuSQTtzdd365JhXiGYDcN
         ntD5Vcb7TtnZn71iKBH7CEoFYbRwOJs+qvQ4KI/Jaa8UXXDHsvuneP7Ye62Xj2fUgJwf
         DXVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762020; x=1790366820;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8ZYph3SzF8DNc3MuGEDpVyyWuyM4ge/DoPLpl5bxHLs=;
        b=jUMaUd1ECzK6dKE60AS7nkHn38ydSVveqPlbxMNv0nhcP32YoGZU+3dBtzr2uMxoz3
         BDP00zA+WF5+OhZKmIrbq3Pq3dJKtfeVXNZjvo8FRDmL+cnis1MOqgUOQYohTYiPrm2w
         PORqhd/vY7beKfE29DZXJB0rtt+dRPPdNDlp2mKZjK/6L/DrW/RVDSorMCKdwWcx3wGX
         YD2fodf07gwK6OYwMIA801/aRuA0/RXQIGLoE39i5qFF5tJ3v7kGJ/cTkoASJ3HaPBG3
         7n7y5A/KGUQkq75EeLaj0sPk+HuC9AsnnCsXzptadoMM7+/J4SGoWc9dLVe7Si7eyJjL
         XBFw==
X-Forwarded-Encrypted: i=1; AKwUvBz3L0dFXljreN6gJGFcli3y/T3t4AgPvBq77FlYr9hmxeoU08H3mDXamwwUppY8uK5yN2d3zKj73Q==@kvack.org
X-Gm-Message-State: AFuF++no+ajazG5IuNhPp857A4IXsJtnRL8OMAhu4vyyqCIqrmBLQ3B/
	X1psG/lRYDdGRaTl2yJCzgjwiIxw7Wb3npo8YeTiCMpsBWVweuCASTtE1DR3EwAmtfnUKUSFkUo
	uSUk4rZ0xELMDQQ==
X-Received: from plld5.prod.google.com ([2002:a17:902:7285:b0:2dd:4e69:703b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2ecb:b0:2dd:c100:9439 with SMTP id d9443c01a7336-2ddc1009c48mr9484545ad.55.1789762020378;
 Fri, 18 Sep 2026 13:07:00 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:34 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-9-dmatlack@google.com>
Subject: [PATCH v9 08/13] PCI: Save and restore the ACS Control register
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
X-Rspamd-Queue-Id: AAC37A0005
X-Stat-Signature: mm6afx1ppd7p9ecw31acm6qpf17g8wnx
X-Rspamd-Server: rspam01
X-HE-Tag: 1789762021-870696
X-HE-Meta: U2FsdGVkX18Ubmp4SKZYmwKbVHFB19PHlCrNTV1iSXxnxsarfz1GFt6c9XOp2jn562IjsvUtDv9G5zSyTb0Q11hCk/mSpbrDrO22zxce9O/RPnvtxX5iToOiMxiqSnKtZcT7Ky1MARYU7X13m5YH6nWzDRtbPGTyPna9Ffvhz0GLvIhsoQCy5RB8PeYWHhZyIv7j0C9B2T8SPH4wTBsDlPfgu7HNQscFHehtbME09zyPeTa0lVjNDwf5YUxt1+Ghk2IddJYGhVe8xPOoO5pi0MBH5a0YwsD/kJhoDd7PggwBldt+nLVpDOiAutCpjHOMoC/7iYAXDdIK3zMob8IfMkwYXi9ZZFFBunQXbD+KRRmcpZxTSYLEmoSTRijoKmsohxV7+u9eBfUfia8G68goTw0aEpL1hvfFyOe+hKodSWGwAT0au71VGqzPvEyhhLce5HCIkZlBkBEEheX2FlIGg5xuAeg5YHy4H5tABsjyNmPOzi2l8Ydnzeg25ZZavpRec0AWGC/2wpfpXhitVWQ16toE4wO/xDJcwY0Py3Q4hL9HrPGqvfZQonm0r872iFmv9Xo6dGp0mgF+C14Gm8C8WJ+in8qzGQ/lUDl/CGIFzLKmUaLsY4gVPqgJ1o83ka4g98k7Kc9B1v8lFEPFKKUdo/IzTOg3DrOcPOA4ENPrIn0z7bCaL/Jw8RVsDCIO8f60L1CSPQimz/DNBtgBvW439y+ee4ZlWNhJqKx8tEdCuxmO96ymla3sGU5/cA6b/cTta9ypLanaiGA8WiL1oHC36i7++bE3URbbmDZBvfYnHXmaNbkhtAIbUZHoLNkv4fWMvXsdxJlNoMBjUiqR7/Nl+s63spY8ZheeCOrvy33pYXrYPMkg/iWqv01y9DL+vNkhRqoBjw1eloTjldFIIIj49dqaCCQHajtWBSkH9CXHjog+hUnbTiUzz3N0jq+ejs7c5oHjjftgUCYJj5sHSwl
 p7HxjbN8
 9SpYyOltPZcnqVyaMT6OIEk9StiHqEFwxoSwSPBwY6j6r7iRPBXdn/ymzvyhiNpLivJOJMcVZAdiXse7Vjt9fEZ6nfg8R/pj/xAQaAisNqqfXv9LjaFTdG/nPbj7bI8Aa7xHVRmt9vkrt3qZ12QdXOSgAsjKqF1qsxsTjKwtS2pXz1CDIMubKFBes0GKbKpzAnvswnNGWxYpgbG4gIBiqPi7QDP/R7wqCl45Ggl6LDMSTsyk0pjJg3G8A0L04nlu9rZ6xqmEuum3yNdbFZenFxtoUx5xGASk+AMY6nzrngag5GE3xstSxync9YsaMq1Cp7ycvCqwizKSHq3rD3DDM3tn0UojMe3huPgTYCYfUzZvN3tCzHXewA4KYfIzZrjEuwla6E1D31+DaBoEClBoQoFaeLke7inVZmFDHdYbS+4X7B2Hn3voUJ2L0CyEIeIwA14Z0FKKe0RFGmv5qXsD8wOZSzEAuk3RZH2dcuDBDT3sYnElfpD6JsZx9syCbtpjDrFjifpMyc6rEGVx65wLqzqMBxtM91nPDKnXRfl32NcP+HGcTdtirKZjRnU8oUk9rETzr7n05ju9QWGnZeT/2CJp069lCTNgvvTgE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Save the ACS Control register in pci_save_state() and write it back
in pci_restore_state(), instead of recomputing the ACS controls from
scratch with pci_enable_acs().

This makes ACS symmetric with the rest of a device's saved state. Today
pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
the ACS controls from the kernel's current ACS policy. As a result, a
device can come out of a reset with different ACS controls than it went
in with, e.g. any controls programmed outside of pci_enable_acs() are
silently dropped.

pci_enable_acs() runs when a driver binds to a device
(pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
the device's state. Refresh the saved ACS Control register there as
well, otherwise a subsequent reset would revert ACS back to the
configuration left behind by firmware.

Devices that rely on device-specific quirks to enable an ACS equivalent
keep that configuration outside of the ACS Control register, so keep
configuring ACS from scratch for them. Do the same for devices that have
no saved ACS state at all.

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pci.c    | 66 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/pci/pci.h    |  5 ++++
 drivers/pci/quirks.c |  7 +++++
 3 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b2879a6be5f8..dd25c01736b4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1021,6 +1021,55 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
 		caps->ctrl |= (dev->acs_capabilities & PCI_ACS_TB);
 }
 
+/**
+ * pci_save_acs_state - save the ACS Control register
+ * @dev: the PCI device
+ *
+ * Record the ACS controls currently programmed in hardware so that
+ * pci_restore_acs_state() can reapply them after a reset.
+ */
+static void pci_save_acs_state(struct pci_dev *dev)
+{
+	struct pci_cap_saved_state *save_state;
+
+	if (!dev->acs_cap)
+		return;
+
+	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
+	if (!save_state)
+		return;
+
+	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL,
+			     (u16 *)&save_state->cap.data[0]);
+}
+
+/**
+ * pci_restore_acs_state - restore the ACS Control register
+ * @dev: the PCI device
+ */
+static void pci_restore_acs_state(struct pci_dev *dev)
+{
+	struct pci_cap_saved_state *save_state = NULL;
+
+	if (dev->acs_cap && !pci_need_dev_specific_enable_acs(dev))
+		save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
+
+	/*
+	 * Devices that rely on device-specific quirks to enable an ACS
+	 * equivalent keep that configuration outside of the ACS Control
+	 * register, so there is nothing useful to restore for them. Configure
+	 * ACS from scratch instead, which also covers devices that have no
+	 * saved ACS state at all.
+	 */
+	if (!save_state) {
+		pci_enable_acs(dev);
+		return;
+	}
+
+	pci_write_config_word(dev, dev->acs_cap + PCI_ACS_CTRL,
+			      *(u16 *)&save_state->cap.data[0]);
+}
+
 /**
  * pci_enable_acs - enable ACS if hardware support it
  * @dev: the PCI device
@@ -1057,6 +1106,15 @@ void pci_enable_acs(struct pci_dev *dev)
 	__pci_config_acs(dev, &caps, config_acs_param, 0, 0);
 
 	pci_write_config_word(dev, pos + PCI_ACS_CTRL, caps.ctrl);
+
+	/*
+	 * pci_enable_acs() runs when a driver binds to the device, i.e. after
+	 * pci_bus_add_device() has already saved the device's state. Refresh
+	 * the saved ACS Control register so that a subsequent reset restores
+	 * the controls programmed here rather than the ones left behind by
+	 * firmware.
+	 */
+	pci_save_acs_state(dev);
 }
 
 /**
@@ -1800,6 +1858,7 @@ int pci_save_state(struct pci_dev *dev)
 	pci_save_aer_state(dev);
 	pci_save_ptm_state(dev);
 	pci_save_tph_state(dev);
+	pci_save_acs_state(dev);
 	return pci_save_vc_state(dev);
 }
 EXPORT_SYMBOL(pci_save_state);
@@ -1877,7 +1936,7 @@ void pci_restore_state(struct pci_dev *dev)
 	pci_restore_msi_state(dev);
 
 	/* Restore ACS and IOV configuration state */
-	pci_enable_acs(dev);
+	pci_restore_acs_state(dev);
 	pci_restore_iov_state(dev);
 
 	dev->state_saved = false;
@@ -3532,6 +3591,11 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
 	if (error)
 		pci_err(dev, "unable to allocate suspend buffer for LTR\n");
 
+	error = pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_ACS,
+					    sizeof(u16));
+	if (error)
+		pci_err(dev, "unable to allocate suspend buffer for ACS\n");
+
 	pci_allocate_vc_save_buffers(dev);
 }
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index ba3c3fddddc2..037c1674f164 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1095,6 +1095,7 @@ void pci_acs_init(struct pci_dev *dev);
 void pci_enable_acs(struct pci_dev *dev);
 #ifdef CONFIG_PCI_QUIRKS
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
+bool pci_need_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
 void pci_disable_broken_acs_cap(struct pci_dev *pdev);
@@ -1105,6 +1106,10 @@ static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
 {
 	return -ENOTTY;
 }
+static inline bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	return false;
+}
 static inline int pci_dev_specific_enable_acs(struct pci_dev *dev)
 {
 	return -ENOTTY;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7aee30734303..e500c202d2ec 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5476,6 +5476,13 @@ static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
 	return NULL;
 }
 
+bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
+
+	return p && p->enable_acs;
+}
+
 int pci_dev_specific_enable_acs(struct pci_dev *dev)
 {
 	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
-- 
2.55.0.1082.g2b9226bbc0-goog


