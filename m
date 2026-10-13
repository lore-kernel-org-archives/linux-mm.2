Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B73E2CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468C86B009B; Tue, 13 Oct 2026 12:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440736B009D; Tue, 13 Oct 2026 12:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356BF6B009E; Tue, 13 Oct 2026 12:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1F06B009B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80D16A8C13
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:47 +0000 (UTC)
X-FDA: 85318129134.09.EE27AF7
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf03.hostedemail.com (Postfix) with ESMTP id BD72920009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=swC8fRks;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3iFvOaggKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3iFvOaggKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIhOQAQQ+VMM6lVadofyWK2MAH+kCcuj1vkGtb5EfAU=;
	b=h4BYj0X4VWWFoKOLFe954D7mSExW15GAa4/rGp3M3SfxG98MCKcLZeinCtFkKsrFzdgEmX
	GFry4oCuLqrzDc/kFWRlDl7JJmpN2dx20eduHguEjJH4NJToK9i7obHwpjNNT0W4Vok2DR
	SeGcnJP0hPdAOv6Y3a93Z5kfZb5s1nU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=swC8fRks;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3iFvOaggKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3iFvOaggKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908745;
	b=KDHmhApmZk2cNiEvtiJa6qXGBIs3qPxSLCiDaH4cYLF1a7YuePRPU1JKlfm8g3/miVMCOj
	3+3Bok3t4zC6UCqpKqSlvO/YeO4EOq9JWU/jxONU6XqpW5bK7xQ64yhhr7YB3YkQaXzGjn
	pnoyL12Vm+GV0nQnLjbEVwTj1GaqaK8=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e827b3a6b4so46955695ad.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908745; x=1792513545; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dIhOQAQQ+VMM6lVadofyWK2MAH+kCcuj1vkGtb5EfAU=;
        b=swC8fRkst9CaDcb+pcu5iJx1SFJQSPp7yTzpK/7jFapyIEw5V/Iew0MzMpZTVfoL3Z
         Xwy1rt7YIC4tZUaZJZErJ6jZwPNtZ4+54AdcNIRWNVFEqc1J/XfWxSIUyWQiSrHzxc+S
         BLU6bOnxlP6JiMy6VrFlkIqDZ3yc+xqjQI/AWXzqyCVCZrx+gQAf2jg4FL8A3sgSqGKo
         jqvKo+q80txOv7yar5IIqg1ON47oMTp5nUiZy8eIQN91cW480ucVsCYhOSbgL5y6fO/U
         C4/JAxO+ydWnVgnG7SNYu0C8XmSmcy4BdqmsdLYF3+6w0f6vGF/bdjhtagSTTgomLrDO
         kKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908745; x=1792513545;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dIhOQAQQ+VMM6lVadofyWK2MAH+kCcuj1vkGtb5EfAU=;
        b=NzqtL4YFq8LoG2QNxVH6gLUHvMJ2ODUMh5kZ5AYWpQN9FrIz+4Ep/V9/JtWd7cRu5y
         p3QQAoSFtEWcSWaJairBwDsB5w+I5emTy0xztUBecbUaC1Qqb1BKD553JMIUjjxeZIrR
         XfFS+7k20JiXxXrygnZuenblEYk6/lfa0cdrN1bkKjtc/LKO98f6t5B7nCUa0dbxv/KF
         9S/jvI2gWZIqeya97mA7u7FVU7NApqQ8Vg63BsQQj3Z4ATHqOS5V6NgUvBpX+oclfueT
         nR7HR++0SFUlMgs2r1SCKrn6RX2G2KrwgklZBMg1SwQvMihCoK7/k/24ua+NCwlmaW4m
         wlXA==
X-Forwarded-Encrypted: i=1; AKwUvBy5F7JBqJk++OzoLkAXmHllCGOcLlgCIlUl0ZjOnXKFJXDEZ1ELnnYT0RhuWe5OeUVTtwAb/BWwYQ==@kvack.org
X-Gm-Message-State: AFq9FYLXShOYdFHQiFtI52LbHu9wjvu6+6aCwDDp2vrsfwhlQz4iapVJ
	pEuQl1mZ8JSztRswxWFz5S/HiL2KZ1Oy0e0qGA/bQHVbRSoN6SS6hW+znhuabKUmB4B5pQUpGla
	IqSKIKj4Nb4Tnxg==
X-Received: from plin4.prod.google.com ([2002:a17:903:3884:b0:2e2:c744:19ed])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:fc8d:b0:2e3:598:75b8 with SMTP id d9443c01a7336-2e842ab03ddmr108269245ad.27.1791908744336;
 Tue, 13 Oct 2026 09:25:44 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:24 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-9-dmatlack@google.com>
Subject: [PATCH v10 08/13] PCI: Save and restore the ACS Control register and
 Egress Control Vector
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
X-Stat-Signature: haohskkdcwobrpdoch74aqo75kcpkof3
X-Rspam-User: 
X-Rspamd-Queue-Id: BD72920009
X-Rspamd-Server: rspam08
X-HE-Tag: 1791908745-451173
X-HE-Meta: U2FsdGVkX18hltteutGJa14Xhm6dDRVEZkSaK3Ii7t0kihuovOK/l91ms0M5YSKB6YsZIeHZNEJAFv58ysci95IhloydCvUUKFjhg5OqYfWlDDxmglNHx5vFJiDnDv1vmI+Le2dLwO8x6VR1l5Ax7TVxGFBPQxTt5wBRyB6bFQHBEOIyNaEt0VSIXIlST7Pyg9NTqhZtKBdEiEvuffXiPJstl6lb8QI57RnZZZfVqoy2qbUMuDJyprpf0otmGU1jJ8hpoInMSx7YkzA4HjUtYWKtkShhN22NsQn1kl4hPi20O+VeNPS7Id15wUGUYZoDMBDtm+PWqRAMilHZoCGRoY1y/SLRocE47Si11EgQpNlQWvO1b1ZUdzclN0Q3kR/PFr58t5/AbK3hNXhdpOCEQ7mRNSfHOPEBp4z7ykucprRyy+1WzVuT1fVR5Qm8t9HRFupvyGxrNWHaPrhbaXF0ZWnZRj3SIPfAN9tgk6tK7X9Q0hTAqRs2wGFq4Qbmok/gw95ZJec2fd/ad4THcoq6MoRg2elxGjXr2+stpi5PP+ADo3AHxSW5/zjvHV2oQAXIL7j2KuMYafqUPQUrD+ts8c6grq2iEhZFERkRVFDq7f1i+wPidLEPpu2pw6Y17TrAfD6eAjTkWhVozZziI9TLJFgLP7h2ITlcgOFzPUw2NUS5L/8mteWWoAILXtovP8tR08u+GaQltUBRHEGy0WyeHYI7KIBItyOsgymK4Wp/93wX5cqJS8y9ZuzlefLvEagIN0QYPcY7iwMa2IJW1XSJkeo5Ju5oZTlHwI0fFwD4O+4gDnY2fxUnbkqM5UY2b3ouYNU9uLxjA2zI3kEG7uV+OBX/gW+9DqY94nbwzcikC/crzjrjxnzW87nYYpCYRMbqm/7O5ho0aayEN0OazfIUn7xbZmiMGkKkRLce83J7l9wCMZHJzV5jXwHrfywkrOhVfoTckpEhbOLewnjxBnW
 KMUb/PTa
 FweHIFkZsOqTqmn7cLpeOs0knG0k9fP5oj+NYuQDvtAotzpVjwxF1ScfIV46TBmRdoKEWlEv7NfT5X3K/O3/e7wTVnKpe6iznuVclEr/DJmDVN8HXE17/ZkX+SSLNXcpX5lJemnZZlS2WeR841zXrkdYxcDV2dniwqrgiNcdJUeuEMN0/CIQwSXpZXLyTqDbQKBKltXFbs6/2rNrP6XwhgQHXWMG45B+o446Kd1Nt1PtxPGUJPpUbyDSVg+/Xb3yUxb961WrGF5e2jNw2E0YKo+/2bryJUZ8Um/kPgzkkEc0T6mRJKgJUeHS2J/SAMHuzjl3aardKrDSR48msV2SzjK1reNdKQsG0iIgPRVzHCZPsMJ8mf86Wr8EIer6Qgqqfv/I8M5ASfZjXqA17Dar/xQ6X9YunySFotkp3lQQqSYlj/U7/u8kFON4pnmVO1qhS0NVutPdfJQK2l0f7yk1fyBvT3SnFQNxv7XLbu1PLVSevpzTmOYvQZ2N5W+0xSP44U81cQHQPFp/TDxd1MlOS0MqLg2RCbLIKQBbKUG57ED9FMfCUyZN0sFuisSdi47VD2KhLdFLXOPM+RPoWlPl2HXFOoa6ZbGCVEFq7HMEeYXloKo1Cgth1GU288jOcrkU8FbYf7mcruDWVkr/lLEmuCJzueNAaj4/JxSVY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Save the ACS Control register and the ACS Egress Control Vector in
pci_save_state() and write them back in pci_restore_state(), instead of
recomputing the ACS controls from scratch with pci_enable_acs().

This makes ACS symmetric with the rest of a device's saved state. Today
pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
the ACS controls from the kernel's current ACS policy. As a result, a
device can come out of a reset with different ACS controls than it went
in with, e.g. any controls programmed outside of pci_enable_acs() are
silently dropped.

Notably, this prepares the kernel to be able to adopt the ACS controls
established by a previous kernel across a Live Update rather than
assigning new ones through pci_enable_acs().

Save and restore the Egress Control Vector as well to keep it in sync
with the now-properly-restored Egress Control Enable bit in the ACS
control register. The kernel never enables Egress Controls or programs
the vector, but the firmware could have and they need to be kept in sync
to avoid changing how P2P traffic is routed.

The Egress Control Vector Size is a HwInit field of the ACS Capability
register, so read it directly from the device to size the save buffer
in pci_allocate_cap_save_buffers(), similar to how the VC capability
relies on its HwInit fields.

pci_enable_acs() runs when a driver binds to a device
(pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
the device's state. Refresh the saved ACS state there as well, otherwise
a subsequent reset would revert ACS back to the configuration left
behind by firmware.

Devices that rely on device-specific quirks to enable an ACS equivalent
keep that configuration outside of the ACS Control register, so keep
configuring ACS from scratch for them. Do the same for devices that have
no saved ACS state at all.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pci.c    | 146 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/pci/pci.h    |   5 ++
 drivers/pci/quirks.c |   7 +++
 3 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b2879a6be5f8..944590fdef48 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1021,6 +1021,139 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
 		caps->ctrl |= (dev->acs_capabilities & PCI_ACS_TB);
 }
 
+/*
+ * Layout of the ACS save buffer. @ecv holds the ACS Egress Control Vector, if
+ * implemented, and is sized by pci_allocate_acs_save_buffer().
+ */
+struct pci_acs_saved_state {
+	u16 ctrl;
+	u32 ecv[];
+};
+
+/*
+ * Return the number of DWORDs in the ACS Egress Control Vector, or 0 if the
+ * device does not implement P2P Egress Control. The Egress Control Vector
+ * Size is HwInit, so it is read directly from the ACS Capability register.
+ */
+static unsigned int pci_acs_ecv_dwords(struct pci_dev *dev, int pos)
+{
+	unsigned int bits;
+	u16 cap;
+	u8 size;
+
+	pci_read_config_word(dev, pos + PCI_ACS_CAP, &cap);
+	if (!(cap & PCI_ACS_EC))
+		return 0;
+
+	/* An Egress Control Vector Size of 0 means 256 bits */
+	pci_read_config_byte(dev, pos + PCI_ACS_EGRESS_BITS, &size);
+	bits = size ?: 256;
+
+	return DIV_ROUND_UP(bits, 32);
+}
+
+/*
+ * Return the number of Egress Control Vector DWORDs held in @save_state, as
+ * sized by pci_allocate_acs_save_buffer().
+ */
+static unsigned int
+pci_acs_saved_ecv_dwords(struct pci_cap_saved_state *save_state)
+{
+	return (save_state->cap.size -
+		offsetof(struct pci_acs_saved_state, ecv)) / sizeof(u32);
+}
+
+static void pci_allocate_acs_save_buffer(struct pci_dev *dev)
+{
+	size_t size;
+	int pos;
+
+	/* dev->acs_cap is not set yet, pci_acs_init() runs later */
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
+	if (!pos)
+		return;
+
+	size = struct_size_t(struct pci_acs_saved_state, ecv,
+			     pci_acs_ecv_dwords(dev, pos));
+	if (pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_ACS, size))
+		pci_err(dev, "unable to allocate suspend buffer for ACS\n");
+}
+
+/**
+ * pci_save_acs_state - save the ACS Control register and Egress Control Vector
+ * @dev: the PCI device
+ *
+ * Record the ACS configuration currently programmed in hardware so that
+ * pci_restore_acs_state() can reapply it after a reset.
+ */
+static void pci_save_acs_state(struct pci_dev *dev)
+{
+	struct pci_cap_saved_state *save_state;
+	struct pci_acs_saved_state *acs;
+	unsigned int i, dwords;
+	int ecv_pos;
+
+	if (!dev->acs_cap)
+		return;
+
+	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
+	if (!save_state)
+		return;
+
+	acs = (struct pci_acs_saved_state *)save_state->cap.data;
+
+	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &acs->ctrl);
+
+	ecv_pos = dev->acs_cap + PCI_ACS_EGRESS_CTL_V;
+	dwords = pci_acs_saved_ecv_dwords(save_state);
+	for (i = 0; i < dwords; i++)
+		pci_read_config_dword(dev, ecv_pos + i * sizeof(u32),
+				      &acs->ecv[i]);
+}
+
+/**
+ * pci_restore_acs_state - restore the ACS Control register and Egress Control
+ *			   Vector
+ * @dev: the PCI device
+ */
+static void pci_restore_acs_state(struct pci_dev *dev)
+{
+	struct pci_cap_saved_state *save_state = NULL;
+	struct pci_acs_saved_state *acs;
+	unsigned int i, dwords;
+	int ecv_pos;
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
+	acs = (struct pci_acs_saved_state *)save_state->cap.data;
+
+	/*
+	 * Restore the Egress Control Vector before the ACS Control register.
+	 * The vector resets to zero, so enabling P2P Egress Control first
+	 * would briefly apply the reset vector instead of the saved one.
+	 */
+	ecv_pos = dev->acs_cap + PCI_ACS_EGRESS_CTL_V;
+	dwords = pci_acs_saved_ecv_dwords(save_state);
+	for (i = 0; i < dwords; i++)
+		pci_write_config_dword(dev, ecv_pos + i * sizeof(u32),
+				       acs->ecv[i]);
+
+	pci_write_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, acs->ctrl);
+}
+
 /**
  * pci_enable_acs - enable ACS if hardware support it
  * @dev: the PCI device
@@ -1057,6 +1190,15 @@ void pci_enable_acs(struct pci_dev *dev)
 	__pci_config_acs(dev, &caps, config_acs_param, 0, 0);
 
 	pci_write_config_word(dev, pos + PCI_ACS_CTRL, caps.ctrl);
+
+	/*
+	 * pci_enable_acs() runs when a driver binds to the device, i.e. after
+	 * pci_bus_add_device() has already saved the device's state. Refresh
+	 * the saved ACS state so that a subsequent reset restores the
+	 * configuration programmed here rather than the one left behind by
+	 * firmware.
+	 */
+	pci_save_acs_state(dev);
 }
 
 /**
@@ -1800,6 +1942,7 @@ int pci_save_state(struct pci_dev *dev)
 	pci_save_aer_state(dev);
 	pci_save_ptm_state(dev);
 	pci_save_tph_state(dev);
+	pci_save_acs_state(dev);
 	return pci_save_vc_state(dev);
 }
 EXPORT_SYMBOL(pci_save_state);
@@ -1877,7 +2020,7 @@ void pci_restore_state(struct pci_dev *dev)
 	pci_restore_msi_state(dev);
 
 	/* Restore ACS and IOV configuration state */
-	pci_enable_acs(dev);
+	pci_restore_acs_state(dev);
 	pci_restore_iov_state(dev);
 
 	dev->state_saved = false;
@@ -3532,6 +3675,7 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
 	if (error)
 		pci_err(dev, "unable to allocate suspend buffer for LTR\n");
 
+	pci_allocate_acs_save_buffer(dev);
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
2.56.0.385.gd3acb90ef8-goog


