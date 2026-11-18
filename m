Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3686560A3830
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gFtPYqqn
Received: by kanga.kvack.org (Postfix)
	id 56FC76B0613; Wed, 18 Nov 2026 17:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA266B0615; Wed, 18 Nov 2026 17:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370626B0613; Wed, 18 Nov 2026 17:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC1216B0613
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:37:20 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55AE440894
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:20 +0000 (UTC)
X-FDA: 85449702240.16.0B80F75
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80582C0003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=gFtPYqqn;
	spf=pass (imf10.hostedemail.com: domain of 3nSj-aggKCEYlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3nSj-aggKCEYlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041438;
	b=64s0B8omsDYecbi6WQ15ZexS3iKo9/oRUNOkD5A73z/s1BVCugjf8T2qtg7VuW7K3jZwJS
	BcLD5UGSPbXmXSSRyD+AW1u34Z+qPp+1V8ACw1YJPg83W7oYHvQv+3lC9mWoNv2ftGkILb
	fu7vF/X/n7L0BU5LwHkylzSf2YmyO7k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wAMMri541KJubVOMQzqlC8m9FrHJPC8q4xU1ogcuUXg=;
	b=Uc/tOorFJXzEpoSZccBh5bXsf2s1IDWfYRT6Avx9I/A/nddg6xvS4JDWtSbY9aU1TZPRqL
	RnyhoMj5sBGBvuAmvFuG7xGz8Y//YilRrs0hnoqch4cYoC2PdBRTKXklMYlqtNbyRpYy8V
	9mdKxqTnEMzK3cPiToyDKSpqQAsZv5Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=gFtPYqqn;
	spf=pass (imf10.hostedemail.com: domain of 3nSj-aggKCEYlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3nSj-aggKCEYlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4cc89e86e4dso1677314b6e.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795041437; x=1795646237; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wAMMri541KJubVOMQzqlC8m9FrHJPC8q4xU1ogcuUXg=;
        b=gFtPYqqnAPkeOADcSWC2GFJCFtsO/aAG/sAFvOoAqJHe6nlrkAt0KdvH96iMt05kyC
         5sF/fY1U1h+3SciYZZekJxWDX5Fy+Jw7Jfur9Fuc6ryb55iW1jN//wCqjBlX5vACRloL
         ycKRyM3gVVeSL313Hzb5z5B/0SfG3+SLM0Y8cjkynXHEu4IXRNp/W3Sh03qcA4Wdh3yN
         kpi4va8n+Pe3BL/iUNQE0Cll18JA9pyEIhNHMiIZ2SatbGx56SXcbLxcr3tcSj7Up7JY
         x9Bm7flN//oaHwkRtSQugcwuwXa/zFED3yXP7SxOt1qJu0VtBdY8PCU2pKZKfHkW4F1K
         eobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041437; x=1795646237;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wAMMri541KJubVOMQzqlC8m9FrHJPC8q4xU1ogcuUXg=;
        b=Q3J1Ru6AEfOQLpvze1JILqMCgbY9GMOKPgoYusE5Hx8j/oAUcJRZHFCl8QZdEDCPa5
         d3StW6ysItZ1j+Xen8R/ECw932rTpYUQ4VqDRpUBLKD2xTJN9sg+l1kb+hqzDenLSjFK
         rn2gxL2RrimppLyrbu1bk6uHkX9FCaJj5nh7LqQiKx+UQdd9i9Ei0x4BoSn2A9iVaaAc
         ZXQU4JJoO4WUBCeS/pSM468h0snVFZy7PZDBoHxe7Vns/7E8yYI1zNnFwF6L7KfHcP/z
         oLTWGekZZZ+Gl78YAcKq1ZGNDC97yopYCAjFYH7f958u3VeAsFsC3O6O/jpQDBAFDTET
         n6vw==
X-Forwarded-Encrypted: i=1; AL+hErFlRA5RBNMnfaLCCZzVM08eryIkg1w474hp/36v8RmjasyLdHnNZe2MvGXremxOiN4n+EVBAiQmWA==@kvack.org
X-Gm-Message-State: APuU4Z9rFsHWpNrfTnkWTRADami+WpXta+S/zqTEST4/qwtjPhuv2vVn
	Sj3nQV52e9p8NNpU9wH6jFCzKTL36Uf1famvJRuaarPvUKzo5hPTushyZDhVlD0/isG6TlIZwqE
	Ul3EaFX7RnZBIdQ==
X-Received: from japs5.prod.google.com ([2002:a02:cc85:0:b0:5fe:dbaf:f909])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1524:b0:4c3:6c2:4f29 with SMTP id 5614622812f47-57741d176e1mr4378785b6e.16.1795041437234;
 Wed, 18 Nov 2026 14:37:17 -0800 (PST)
Date: Wed, 18 Nov 2026 22:36:59 +0000
In-Reply-To: <20261118223704.3286085-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118223704.3286085-9-dmatlack@google.com>
Subject: [PATCH v11 08/13] PCI: Save and restore the ACS Control register and
 Egress Control Vector
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>, 
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 80582C0003
X-Rspam-User:
X-Stat-Signature: dgef81qupx9f1dszf7szk6gjmae7t8h1
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795041438-863725
X-HE-Meta: U2FsdGVkX1+2GXfBDjuewN0Z17GvpTjjh1T2zFluehRXX99xH8yLL/AoozK7kkO6iIqgRIbNVRuo8gUHQ6cPHdO4eXKLbuw681EkNz4PXAKJJ3/FXh/rpknlI3wNLzxTU+GBWtBMoxvgExC1cJsKUnB5gICNobilNK88KATd8xNGdaa9VrNUkSGG4N2NZq4WGs6BiCskAnlybOmbZ/5EQ7AdoAivO9Psg267xVtyTkkJA+lu6qivaj/+eD0Rk3l8G/48zKI7gJT4VoAZoklIRZWaU9awjMVVkhZtFCbfaxAES39c88jLeNIXiIM2xGvU739tATtfCmRE/5hv7kCofx7FrmIC5s1kBxjECE4/Q7sHslAtcEDnzV0ZuZJhy9zf7i34rKdZTDPWJ4/tJ+meFeb38cqR3AHXYYw4BmPKiYkL/O7J634lsa8N9RVEF1MxvIjvyREWnjCDcxIl6LVyrWk8Sv9RIUxTqhrQjgbFxhwRxOkoj2nuViNqSDKWY8QPemATWQK6DVm/EoCyWJCQlHHxcf37Te/T9Nsh+BZxNSR2IHGlkWwIoppawZtZ5OZ7wdHT55HzqLKVh1QT9FDSICQp6rz0+p1DV1DdIY3KtKF8Iopfl7C9r4ha55uzJDNdO/LFgzXdxzKUXGOk3BrpPQ0XDsllYHdZiujvkugpVFGmCXIHUltLwbbKEt81NlSjNA1uVm1xYUQJ45yfyEE7JBLdwXLulwmEJVlgylTADjYtb1yeUyhQ++LnacrEtdmGHLUX6JEZ/yi2Ptp1ZtWcL4JCMma3wrQL7Y3+elKBr2dASRC24iOew1DoxOnhbYBltiCV2HqJx+y3Tins5cWlP5+gZu0Q5L1BlzCY2UqFEUNAKjh6n8O+rA9/sM4SqcmICtF0bkPHwV7CXkGhc5EE9vZ8xMdoTXzLcTOVRkB4OCiyNgQUawZ3LDEWDiCuS3EuHBuU3XgDfYv1PxaIHkl
 x8ymfb9O
 G4YslAevEnS8sHTf+ACYXaMc/qRjEe4Au7w9HdfM0vt5+ri/LkdPHv3rm8P2edwyo1YQdffs2ykzWVbc3Lcu57g49yP8uzjhpVeBrhrZswsVIsH03KzAddNE6PiHwCqXkGNpLt1XT3hlEjeO/AxqtvHE3ekZ0xf62qxmxq8EigoDhE+acuh2z/cbSDiI22OdGxDM7HuT2yfqvNul6xds94wbejF95bHQOMKqNneuuR8M6pj/i/CIkSyYm/Cpb9UIjslkGdgpJLiQwn1QDMDhyILbRIO7rL7VCZ3wUnmnaWyUjq7dOPHGuWRwFOPPlvm/iBVEV3GlVSYm31Y1WSk2uGU3Qq3AJ/2oa8UgzVmrAas6AZRbCWJ02lcb284IHLoonWISMdIogCI4zdWbxMVbs5vu+vpdcgrNuPH0PvzZ0qrTuh1F7xMFlFMktWQgephXUIo2DeJGEA0/cwZyKfvYr5CzyFBgNJpLqTjbbd3JKmiwQkKEF31E2Z3fn9f/rKueSwNTTntYaiwwCZ5vIboeucY9fQCPpOTI2JGXKc0O/OW+C+jgKOYDHDWu+ekaQ9DtXE+nEjK79XtMZ5WpS87Sbd5ubsXz14l0CY0wG2XVu9rONdg182BbiYFW4X0ZSUxu+MYLzHm3gYBOvuFUP752vz13M3zBIasZQExk1KN/B+dHFrTBbxhED6TChG9GnBUxLDumwrZviQvSYWn3g9YwiStx2FKy5cmhBaPV3cfQOOnY08wVwsr8Pnn07Fg2PULZqSV4fnpQW9JgXLNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Save the ACS Control register and the ACS Egress Control Vector in
pci_save_state() and write them back in pci_restore_state(), instead of
recomputing the ACS controls from scratch with pci_enable_acs().

This makes ACS symmetric with the rest of a device's saved state. Today
pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
the ACS controls from the kernel's current ACS policy. As a result, a
device can come out of a reset with different ACS controls than it went
in with, e.g. any controls programmed outside of pci_enable_acs() are
silently dropped.

This also lets a later patch adopt the ACS controls established by a
previous kernel across a Live Update rather than assigning new ones
through pci_enable_acs().

Save and restore the Egress Control Vector as well to keep it in sync
with the Egress Control Enable bit in the ACS Control register, which is
now restored from saved state. The kernel never enables Egress Controls
or programs the vector, but the firmware could have and they need to be
kept in sync to avoid changing how P2P traffic is routed.

The Egress Control Vector Size is a HwInit field of the ACS Capability
register (PCIe r7.1, sec 7.7.12.2), so read it directly from the device
to size the save buffer in pci_allocate_cap_save_buffers(), similar to
how the VC capability relies on its HwInit fields.

pci_enable_acs() runs when a driver binds to a device
(pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
the device's state. Refresh the saved ACS state there as well, otherwise
a subsequent reset would revert ACS back to the configuration left
behind by firmware.

Devices that rely on device-specific quirks to enable an ACS equivalent
keep that configuration outside of the ACS Control register, so don't
allocate an ACS save buffer for them. Keep configuring ACS from scratch
on restore for any device that has no saved ACS state.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Alex Williamson <alex.williamson@nvidia.com>
---
 drivers/pci/pci.c    | 152 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/pci/pci.h    |   5 ++
 drivers/pci/quirks.c |   7 ++
 3 files changed, 163 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7c6f2aba8144..fc4307a2327d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1021,6 +1021,145 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
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
+	/*
+	 * Devices that rely on device-specific quirks to enable an ACS
+	 * equivalent keep that configuration outside of the ACS Control
+	 * register, so they are configured from scratch on restore.
+	 */
+	if (pci_need_dev_specific_enable_acs(dev))
+		return;
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
+	if (dev->acs_cap)
+		save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
+
+	/*
+	 * Configure ACS from scratch for devices that have no saved ACS state,
+	 * e.g. devices that rely on device-specific quirks to enable an ACS
+	 * equivalent (see pci_allocate_acs_save_buffer()).
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
@@ -1057,6 +1196,15 @@ void pci_enable_acs(struct pci_dev *dev)
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
@@ -1825,6 +1973,7 @@ int pci_save_state(struct pci_dev *dev)
 	pci_save_aer_state(dev);
 	pci_save_ptm_state(dev);
 	pci_save_tph_state(dev);
+	pci_save_acs_state(dev);
 	return pci_save_vc_state(dev);
 }
 EXPORT_SYMBOL(pci_save_state);
@@ -1902,7 +2051,7 @@ void pci_restore_state(struct pci_dev *dev)
 	pci_restore_msi_state(dev);
 
 	/* Restore ACS and IOV configuration state */
-	pci_enable_acs(dev);
+	pci_restore_acs_state(dev);
 	pci_restore_iov_state(dev);
 
 	dev->state_saved = false;
@@ -3565,6 +3714,7 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
 	if (error)
 		pci_err(dev, "unable to allocate suspend buffer for LTR\n");
 
+	pci_allocate_acs_save_buffer(dev);
 	pci_allocate_vc_save_buffers(dev);
 }
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 77efa4c5c960..8fc4b18738bf 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1101,6 +1101,7 @@ void pci_acs_init(struct pci_dev *dev);
 void pci_enable_acs(struct pci_dev *dev);
 #ifdef CONFIG_PCI_QUIRKS
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
+bool pci_need_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
 void pci_disable_broken_acs_cap(struct pci_dev *pdev);
@@ -1111,6 +1112,10 @@ static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
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
index 0978be9c17db..7572b358b50f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5629,6 +5629,13 @@ static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
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
2.56.1.703.gf848ed807c-goog


