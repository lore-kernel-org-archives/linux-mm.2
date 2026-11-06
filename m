Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88742606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CWpSzrR4
Received: by kanga.kvack.org (Postfix)
	id 53A7A6B05C2; Thu,  5 Nov 2026 19:43:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5137B6B05C3; Thu,  5 Nov 2026 19:43:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401AC6B05C4; Thu,  5 Nov 2026 19:43:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 085546B05C2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:14 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EA381A0C7D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:14 +0000 (UTC)
X-FDA: 85402845108.01.D11539D
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf30.hostedemail.com (Postfix) with ESMTP id D33AE80004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CWpSzrR4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3nyLtaggKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3nyLtaggKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFWOpusTgBwcgTKpEgyRpVaqUUx06BhmoFjl8K/HM58=;
	b=IjmPo9sG83T/aKZ6dcI8nIwshQdUrkciMyIMp4hmnqnZgfbr1yV/HCnKXOT1cCRFEqTO85
	5tfdNjUCVK2hwG0lWoqRyGezWkgusB1YoWvMEtBdl9xn2P7lMGWAMwtc0M2wWvsxEllzRq
	68xatXCcfOKyRvrbvAhYlao67rmljXw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CWpSzrR4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3nyLtaggKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3nyLtaggKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925792;
	b=gYZvqsuqt4InqKVg0anFOarKbXBM6iC+Wsgu7Fd1xAi4C5tCWbDj2eUH0YqeRMhsCWC6/3
	V9nNZ9loPAIuZ2GBzQehDuMmw0Z2++opuDukQxGLRsetIZwNd5fZFeWBpNISvtSTyKKnry
	XZlAA3hCh3Kq1rTciHORecpOWaF7FxE=
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4f4612a1a5cso1451062b6e.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925792; x=1794530592; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mFWOpusTgBwcgTKpEgyRpVaqUUx06BhmoFjl8K/HM58=;
        b=CWpSzrR4EMIrfST/MJPwRuVp08uqZsph+ydj6OtBGGuAPRUkTpXC51Ezx4virkGs6j
         Yh5jqiqvUtxA4xrageamZfYaRen2+SXFgN6TF4Y5Dy5ORiZ7if/huVrHzOHVXy6BeqQg
         2U5D82f6BlmCu5b+8hKPW+211nz1mCB+OGyC6WvbNI4ZLxw4iULOGvk8/0N01QrC3BWR
         NhjEW2HI7KfTW4sr+EisgyJr1IIPgLxfteV72PJd3+k6NqsV6Cci7kakVDDVP59JCgDh
         ZY+RV07mfwWJaJDksBTvyym4V5ILvY+MeYHC1W9PzmAJGGdAe8WZPBKTYSz2UFq+h+bY
         ORYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925792; x=1794530592;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mFWOpusTgBwcgTKpEgyRpVaqUUx06BhmoFjl8K/HM58=;
        b=x1dgsvYjR85chSDFEGN7WSzEWKKWx8+MAzLYuyr53EN4V0/NhC2UGTMpuR8arDWxBT
         q+DyjtSqw3vgEDBS0MW2GeYb6vPCQ3o4IwhKipiOOTLIqAYcQRTlkClrmMPUbi16K/8C
         q34G5wc/FO23jBNn7M5JVP2spvqCX/MU+cNk/R6UEz2oMzdZ2x1lBcsHSykTEQWSQ2Ho
         XufQxNBOyR5N8vHNANN5Xqzdg/nzm/kIcFG3bUpN8L8CzG7tQ9k8oE4331aQ+0jRbEX9
         S79QqbHJNn0Imo0l4aTcKkSGIky9Ou7g/fTGYTZyRaZRK7onpYTGjm5iOMByMLcBAzAJ
         9HrA==
X-Forwarded-Encrypted: i=1; AKwUvBz7LVrz023iEBxfd5zfdo3YSL+GVbUyCSVCgxGipnNfv1enq0D67T+ClqidvWoSQKBHU+wwrlxh5A==@kvack.org
X-Gm-Message-State: APuU4Z/6auDQh2AQfGJxR4kmLSBsqxw45mzlUQJkMibF6NR+/ZzVuabX
	7yAkxwHARn7QzTwFhtfANn+adOTdglAG3jEj6fIUFT+5xYgWVK1asi8E+w/zekOZQJNwy+eMyAe
	bUwcLQVkFEy/9Qw==
X-Received: from ilbeb27.prod.google.com ([2002:a05:6e02:461b:b0:520:6d86:da98])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1686:b0:546:306d:45eb with SMTP id 5614622812f47-567be662ce8mr2365687b6e.35.1793925791448;
 Thu, 05 Nov 2026 16:43:11 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:13 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-13-dmatlack@google.com>
Subject: [PATCH v2 12/17] PCI: Save ACS state in the saved capability store
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org
Cc: Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, David Matlack <dmatlack@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Lukas Wunner <lukas@wunner.de>, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, 
	"Oliver O'Halloran" <oohall@gmail.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D33AE80004
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: ei1xn1wga7e5nxo9tx3whr183a4xd8rb
X-HE-Tag: 1793925792-447815
X-HE-Meta: U2FsdGVkX1+xIPj87nY9j4QcnYOrce/yYESuWj4gKZIpz0cgQCLlAFVzZUk2iot7kIf2/my3CeJU2OXrVPh9IiI8JGPW1GAHzXOFFqJ/oHFtAr+/65881Qt1Jwybf0XxRN1Zq1KhOZz429L+4kV8+Jkos0QbOT6FEnSSPHHfvTphaB1a8hdy9DuKhSZcjoBEB2daCtuU/GRkzQCgwRZht/E9/DS5sAmWPCHB+6yrym2V7C75V3up09NQ0/jDkUXrS9IgMcl3nKVVSgszA6Pt9XAAmz9E4UDBt1QBH3CcYbtzP5+K6oao6ju2iKnexIRkeG8dZF+O/QsX95xUMe8vc/0oVCEYXEcOskHj8+9IKj07KknTDEeoySvyOYSvlXmhLvZSBRlyUYaXYAwoHir1ps/6Btfg+CXIZQuJ/iIT6GFBig/USCc+3XNo5EppCxbRzVp3TK2cmBGpnnnMfHojGlTHNJqxXfQhO0BTbFZtF8L6vKek0Lvcfou29PVnrK8Mh6ZxBcZs8dFy9NkbGPzIqQIANfL7AGhB3HChxfuLApwPwFI1ijn9W0Us+pNj1REzmKCSHLOCtCHsuMmZSRiuLP1NCBcWE8Y5BLmftIXWxjjzRxQO5OhY1vRo3tt2KpGR0WzAgkSReh3XIEV8AL90+iiR0ha3MU79lRcVgij/IhEddSXZHasQ18hKp9XTWmwYM1SSIQJBrvMpNer53td1/uIsbskRGMuS9FIa93rwhq4EoefXRbKQAB20/3nTqwUe4pWyftGkPCWPGxSpDj7VdTrkUuqIwsd786Uz5tfKJZxtRnV8cNBkFclmle6MDjq5rPKooGs+EyR1EQ5F/ujeoPUueDEEHdpFJG9U/i1VTjuwsuKZUXnUgkw2KIeZECbIcZv7TDQplW//DO9gNcFLpb5r6cP3cUXuln9wjbKDggXcQKMWwmiOrWc5bexfq/0HAvIVuaucM6py3ICBX6Z
 v0VVaEaN
 LyzKo0acvHyBm5+k+9BXSUuS5JF73Hu7Zxivg5G3KW5wf+uqTZd4qQq9W5jdJPIMFtUTQ3jLYnloWtS/2Hdv8FOYrksUDKQqsPEuAPEP0/dvR9ctOH9gu5Uym9iZexe3Unx47GIEBlOGcTaT0plKndSY1Qm8sm819VWaGHUk+awLc8aaR8tzwIRiL2jhWfaHTNDQf9SFColBfq0wTfWfHWWmmZZwIAJiXOoDMjCtk15XnzpOPuTfnUiN+fzwZjrh2iRBQw7zz17MjzTL2D6TFUzt+7Kk+8o/uzj0qHB2n5IzxiTDCBEaRM5QfiUt+pXXrI7RKm0VPWeufCZmXDWva0iogtg/9MTV9OayWdnNo2DZoMC9HQI2ba8YgwNvGI4tD/j8Yqp8Ed0A9fFnEWkn6mHAG2X/c5KcvsS29Cd8He+jV/CYXuZNF4+iGXkc+ckjh5L2uo+En0rNtE5NWt0hbVEpnm07J3OuBdi85SL37mofb4YFn+Biqe6+DjFvd7CoVIEW/JM69QoVQOD0am9GRmfi81CH7FAhBtf0HR9c+FvdTvHktibVrxk6gnucW/vM6al4iM1VFe/YKVs7tASmvF1614EYLSLGL2Shk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Save and restore the ACS Control register and the ACS Egress Control
Vector through the per-device saved capability store instead of a
private pci_cap_saved_state buffer.

Rename pci_allocate_acs_save_buffer() to pci_reserve_acs_state(), to
match pci_save_acs_state() and pci_restore_acs_state().

Reserve the Egress Control Vector using the size the device reports in
its HwInit ACS Capability register during setup, as the save buffer was
sized before. Save or restore the vector only if all of it is reserved,
since its size is read from the device again each time.

pci_liveupdate_adopt_acs() checked for the ACS save buffer to make sure
adopted controls would survive a later reset. Check that the ACS
Control register has room in the store instead, which also fails if the
store could not be allocated.

No functional change intended for devices whose Egress Control Vector
size does not change after setup.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 15 +++----
 drivers/pci/pci.c        | 87 ++++++++++++++++++----------------------
 2 files changed, 46 insertions(+), 56 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 6f92d4ddca2b..8334e6fdd3ec 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -932,14 +932,15 @@ int pci_liveupdate_adopt_acs(struct pci_dev *dev)
 
 	/*
 	 * Adopting the previous kernel's controls depends on them being
-	 * captured in the ACS save buffer, so that they are reapplied if the
-	 * device is later reset. Without that buffer, e.g. because it could
-	 * not be allocated under memory pressure, the adopted controls would
-	 * be silently lost by the first reset. Program ACS from scratch
-	 * instead, which is a better outcome than leaving ACS disabled.
+	 * captured in the saved capability store, so that they are reapplied
+	 * if the device is later reset. Without room in the store, e.g.
+	 * because it could not be allocated under memory pressure, the adopted
+	 * controls would be silently lost by the first reset. Program ACS from
+	 * scratch instead, which is a better outcome than leaving ACS disabled.
 	 */
-	if (dev->acs_cap && !pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS)) {
-		pci_err(dev, "No ACS save buffer, not adopting ACS controls\n");
+	if (dev->acs_cap &&
+	    !pci_saved_cap_reserved(dev, dev->acs_cap + PCI_ACS_CTRL)) {
+		pci_err(dev, "No ACS save state, not adopting ACS controls\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 29d9474db1ae..977b7dbd19ce 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1023,15 +1023,6 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
 		caps->ctrl |= (dev->acs_capabilities & PCI_ACS_TB);
 }
 
-/*
- * Layout of the ACS save buffer. @ecv holds the ACS Egress Control Vector, if
- * implemented, and is sized by pci_allocate_acs_save_buffer().
- */
-struct pci_acs_saved_state {
-	u16 ctrl;
-	u32 ecv[];
-};
-
 /*
  * Return the number of DWORDs in the ACS Egress Control Vector, or 0 if the
  * device does not implement P2P Egress Control. The Egress Control Vector
@@ -1055,30 +1046,44 @@ static unsigned int pci_acs_ecv_dwords(struct pci_dev *dev, int pos)
 }
 
 /*
- * Return the number of Egress Control Vector DWORDs held in @save_state, as
- * sized by pci_allocate_acs_save_buffer().
+ * Return the number of Egress Control Vector DWORDs that are reserved in the
+ * saved capability store, or 0 if the device does not implement P2P Egress
+ * Control or the vector was not reserved in full, e.g. because the device
+ * reports a different size than it did during setup.
  */
-static unsigned int
-pci_acs_saved_ecv_dwords(struct pci_cap_saved_state *save_state)
+static unsigned int pci_acs_saved_ecv_dwords(struct pci_dev *dev)
 {
-	return (save_state->cap.size -
-		offsetof(struct pci_acs_saved_state, ecv)) / sizeof(u32);
+	int pos = dev->acs_cap + PCI_ACS_EGRESS_CTL_V;
+	unsigned int i, dwords;
+
+	dwords = pci_acs_ecv_dwords(dev, dev->acs_cap);
+	for (i = 0; i < dwords; i++) {
+		if (!pci_saved_cap_reserved(dev, pos + i * sizeof(u32)))
+			return 0;
+	}
+
+	return dwords;
 }
 
-static void pci_allocate_acs_save_buffer(struct pci_dev *dev)
+static void pci_reserve_acs_state(struct pci_dev *dev)
 {
-	size_t size;
-	int pos;
+	unsigned int dwords;
+	int pos, rc;
 
 	/* dev->acs_cap is not set yet, pci_acs_init() runs later */
 	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
 	if (!pos)
 		return;
 
-	size = struct_size_t(struct pci_acs_saved_state, ecv,
-			     pci_acs_ecv_dwords(dev, pos));
-	if (pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_ACS, size))
-		pci_err(dev, "unable to allocate suspend buffer for ACS\n");
+	rc = pci_reserve_saved_cap(dev, pos + PCI_ACS_CTRL, sizeof(u16));
+
+	dwords = pci_acs_ecv_dwords(dev, pos);
+	if (!rc && dwords)
+		rc = pci_reserve_saved_cap(dev, pos + PCI_ACS_EGRESS_CTL_V,
+					   dwords * sizeof(u32));
+	if (rc)
+		pci_err(dev, "unable to reserve ACS save state (%pe)\n",
+			ERR_PTR(rc));
 }
 
 /**
@@ -1090,27 +1095,19 @@ static void pci_allocate_acs_save_buffer(struct pci_dev *dev)
  */
 static void pci_save_acs_state(struct pci_dev *dev)
 {
-	struct pci_cap_saved_state *save_state;
-	struct pci_acs_saved_state *acs;
 	unsigned int i, dwords;
 	int ecv_pos;
 
-	if (!dev->acs_cap)
-		return;
-
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
-	if (!save_state)
+	if (!dev->acs_cap ||
+	    !pci_saved_cap_reserved(dev, dev->acs_cap + PCI_ACS_CTRL))
 		return;
 
-	acs = (struct pci_acs_saved_state *)save_state->cap.data;
-
-	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &acs->ctrl);
+	pci_save_cap_word(dev, dev->acs_cap + PCI_ACS_CTRL);
 
 	ecv_pos = dev->acs_cap + PCI_ACS_EGRESS_CTL_V;
-	dwords = pci_acs_saved_ecv_dwords(save_state);
+	dwords = pci_acs_saved_ecv_dwords(dev);
 	for (i = 0; i < dwords; i++)
-		pci_read_config_dword(dev, ecv_pos + i * sizeof(u32),
-				      &acs->ecv[i]);
+		pci_save_cap_dword(dev, ecv_pos + i * sizeof(u32));
 }
 
 /**
@@ -1120,14 +1117,9 @@ static void pci_save_acs_state(struct pci_dev *dev)
  */
 static void pci_restore_acs_state(struct pci_dev *dev)
 {
-	struct pci_cap_saved_state *save_state = NULL;
-	struct pci_acs_saved_state *acs;
 	unsigned int i, dwords;
 	int ecv_pos;
 
-	if (dev->acs_cap && !pci_need_dev_specific_enable_acs(dev))
-		save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
-
 	/*
 	 * Devices that rely on device-specific quirks to enable an ACS
 	 * equivalent keep that configuration outside of the ACS Control
@@ -1135,25 +1127,23 @@ static void pci_restore_acs_state(struct pci_dev *dev)
 	 * ACS from scratch instead, which also covers devices that have no
 	 * saved ACS state at all.
 	 */
-	if (!save_state) {
+	if (!dev->acs_cap || pci_need_dev_specific_enable_acs(dev) ||
+	    !pci_saved_cap_reserved(dev, dev->acs_cap + PCI_ACS_CTRL)) {
 		pci_enable_acs(dev);
 		return;
 	}
 
-	acs = (struct pci_acs_saved_state *)save_state->cap.data;
-
 	/*
 	 * Restore the Egress Control Vector before the ACS Control register.
 	 * The vector resets to zero, so enabling P2P Egress Control first
 	 * would briefly apply the reset vector instead of the saved one.
 	 */
 	ecv_pos = dev->acs_cap + PCI_ACS_EGRESS_CTL_V;
-	dwords = pci_acs_saved_ecv_dwords(save_state);
+	dwords = pci_acs_saved_ecv_dwords(dev);
 	for (i = 0; i < dwords; i++)
-		pci_write_config_dword(dev, ecv_pos + i * sizeof(u32),
-				       acs->ecv[i]);
+		pci_restore_cap_dword(dev, ecv_pos + i * sizeof(u32));
 
-	pci_write_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, acs->ctrl);
+	pci_restore_cap_word(dev, dev->acs_cap + PCI_ACS_CTRL);
 }
 
 /**
@@ -3745,8 +3735,7 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
 	pci_reserve_pcie_state(dev);
 	pci_reserve_pcix_state(dev);
 	pci_reserve_ltr_state(dev);
-
-	pci_allocate_acs_save_buffer(dev);
+	pci_reserve_acs_state(dev);
 	pci_allocate_vc_save_buffers(dev);
 }
 
-- 
2.56.0.455.g6c5a503b38-goog


