Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F0D606EE97
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CYJjdJpL
Received: by kanga.kvack.org (Postfix)
	id E64386B05B9; Thu,  5 Nov 2026 19:43:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38C86B05BA; Thu,  5 Nov 2026 19:43:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27A16B05BB; Thu,  5 Nov 2026 19:43:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9FF46B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43A2C160C38
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:04 +0000 (UTC)
X-FDA: 85402844688.14.2858D56
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf31.hostedemail.com (Postfix) with ESMTP id 841DA20006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CYJjdJpL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3lSLtaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3lSLtaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdvOmig1mqmuQ5cGPPo+aA7C4UMwvpl0I/Lv9SSRV3g=;
	b=b0U9UwMoXpTeTi+vSPTQT+zgh8hSxDO+8MBlcHqFCkZbLb1GjDfRWDefIoXHTCkG/H5KiA
	OT3O+s4Q2ve7DYZFH9eKUnKEBN9qcph+eHmnATcyz/1P/rA012i9DRg4j1i9xPFODsQa08
	ek3B+7zJrgfYcXAaoIj89VHtbChLhLY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CYJjdJpL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3lSLtaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3lSLtaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925782;
	b=wCwuTuJkA91dqOTmTil7p4t1p+mmAw2w2r7mHtqmrMYCvXxS5+jC98BaTUdoB8O8a6jesz
	/6VU3ERRLaG/2xmvMVZmeajSzssXVrqi7V/ZJ6f90dnKRtjHH8uqBgnJKQ4ZvyFbWc7stG
	KtTcQctrUrzcaqjoKRZiaOfUn8Q+6MM=
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6f8edf0c859so1693796eaf.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925781; x=1794530581; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fdvOmig1mqmuQ5cGPPo+aA7C4UMwvpl0I/Lv9SSRV3g=;
        b=CYJjdJpLlRZkO5O2nYR6rsZ5kRM39n2i0DlcPpCwNka3Yr2VW2TLVlzo9FEiixRdG5
         CZM7+O+CO2vIHSidkkgUr1y1LlyZJ4PmzdKqcru8elQH+TYykwXcahuLRZJDZyc3ZRCZ
         0NU7xJF9NChpQJrh4UnHi0lqXeKLt10Jph1LpgXgpfimqEYdlzi2rtUlAyMhsPoBc+Gu
         RoNRIT8BfqbmbfquX5ANIm32eMBJiNmc436dW7rUKqR2uJwqugEKXNnx0RpH9wODQKe5
         9HDiyHjlO1t5KDAjlLTNRus7f19bQplwhLFCQG6rDCZ8hAJQRcoR+rDIsnyLbniEDnxy
         CN1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925781; x=1794530581;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fdvOmig1mqmuQ5cGPPo+aA7C4UMwvpl0I/Lv9SSRV3g=;
        b=EdIoPk80fm714ZkaJJvpIXL9QW/l/HVYul+80Zkdqw0O4X3cfAeCxLACmv4SW0BLq7
         2KIBnc5xPRlrddXXh8jDxjjSmAVvkeWNrWAcA8ScFwwAg1GWRC1D9UsoZLXvsYXcLn+1
         pLgoYL2nMjWinGirDzLkYG+e2aUb3DP7NBKePqQCW2U4pEIkVZkHVlwRvTJrsFfnNnRZ
         R7RpT0aIiqVUBwHojhtF/f+W1Fzgb3H75FaiXZn1VJkdi2WzGO+qnuTadcG2sysexaf9
         lz7+OelpQHVkMdDBuLIbyYbhWHvuK5O50eURfcSt0kiyDW7xmZ2TtTuMVb1zgdlvQhx/
         6eXQ==
X-Forwarded-Encrypted: i=1; AKwUvBwx2ckV00NlsXeCwiKKAuoTePjxElIj3Lahvw9Dmg0Hrl0DQD+GtMbqlzIpcyYLRwl6YzqIyDqwSQ==@kvack.org
X-Gm-Message-State: APuU4Z+j9Kevl4+iz8/a7b+3JgRI9Iw8vjwModGmQRNcLCesmO3HNWyU
	B3qr/Zo2CC8xFqQLmUJve/dPz0LqHn0JekXEu9rTf5rCOMMIiVNpa2kZAaQ34TXetvi5LhrElzg
	T16OebmvrTCFP8w==
X-Received: from iobmm28-n2.prod.google.com ([2002:a05:6602:711c:20b0:9e0:ee3f:c3a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:290f:b0:6d3:abd1:9b87 with SMTP id 006d021491bc7-716d221fc2emr2597233eaf.45.1793925781387;
 Thu, 05 Nov 2026 16:43:01 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:05 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-5-dmatlack@google.com>
Subject: [PATCH v2 04/17] PCI: Save PCIe state in the saved capability store
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
X-Rspamd-Queue-Id: 841DA20006
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: eagqqecnhfprgnat76k5bhtmcp9ppxkq
X-HE-Tag: 1793925782-482651
X-HE-Meta: U2FsdGVkX1+Bqq05jLuWJv+/IgW6LHtmVOLDqKuDXcAtC6mVEMnW3MV4w+3f+rSIYE9nMgIeIvMZEzVpR0qiMkJjznmm9bAzlwRdqT1DrpLyYzJHOpG46CZmKSQ77apTX8MbG2kap/KKtaDsRLVRs4A2R4V23l2HoPdfSSNcFe4GE66YmirWj92J24Sf8RQwtuwaIifqJfuxH0Db4fG8y+oPT8IuqiFYxX8Onrmd/9FxZ9GlyAnHHIAIwDEGaBgg8ZXh2Chcc90isIaiLTpBmCJ61SoHcOAS9VcFjwsQGkK9IptqVa8QjyroC8Iu6lRiYh2t8q7ePSXBuQ61aPWQtc7lJzBXlKY5vRx/a3hVQOHr4YdkvHpuZbFW3nwgYZBP9/9tJcZGkdISOgDma83+BWbxrciKn7TxfFO06B92gO8+hdUIE4I9BBSQhQq76dvZ5da/ysV0omiS6hXHboWukfeMAh0k1nIsWneg3dwozE2ungkYSBP3648PW2jfokm6Bp28en3BZlYcOMdFVpvY8TNm3aZbM7kd35YMh7SiE2ypI5zktNJsQof8WFbOIWzoZtawVwuzZbuIyG2ecJ85FIOFUa9xSCFcuEqGBzcL9d6DEtBDyvogGPEQWGMnmdJ+toaJ5gl+o7U4dROsoaiAZKoPiJl7qt4ZibEuac3+QRbh11PgdhW8R0yFcaWMUuAF0rbvwXAWdpzpEKgnM3685VdtY+YsOu3jLM/rWzEis+kAtHzGgXlab75CN77eZjQlgV5PLVTVpd7IYvj5TqdFZZnHoSnhEZD/KZr7/nKi/tJ191Xe8OnHzmmXfU6N/PShQJZUaeY9lqmbGPlMC0ayzLZja0Qy7a2YBlINpWKpSnw5aOA+tcgaxHQFglWKMP+qGMvCyoXavwRSfbppCmk/EzDb4hwYuosjN0T5XNT8mHlzEOlhiN06a7tbZdiqOOs9D4XfWNv+4XV6t+NPcjr
 igyCepCE
 7a+1GwJSbQrI8s8OcTEw/OHy9EBL3c6kOzlJiwacoiv6/w8RUAQByyG6QWaphtknrJDe80IoaNf2Ks2r5XS7NfyANh0Ov1FjfuLCkDdZdWUvsFu4Vsr930BWAvfthimAVWBHUn/bWEJGHKGP7j3A4b1JSgNB2P02wF3/TTBi6IUXZ2Yjd85pmEB1uL/35gRi4tftIqwG4bd5V4TpQ77HlgcbTGdvqvHRRbrrzTkVsa1efDD6Wb5l3pCGdnag0Iavb6XrNsHRgYSTBjNCr+fdWtVv0eOzSrIM1VSCpTFLZN/4e7lXaZn7qAilu6+DYInUx3aRlLspYQaHJE3H29rqAib85EVxwvxsUJuLG5Uj9DMO1zMI3GejCl6D6poe+NodgTx91UE8znaOuNBgez2L1Q8uiZ+FOitBFtW5atnCKM2WaUEVeqViJIo6Ew0uWhE1YjfwyJrNYN2VqT/9HChUMBxC0/y83XZ9COGid4GTL8iXActbU83WZ1gnTS0bwPKL+Msj1tRLI6uBmjyiyQF5aNqcy2XYielQoc8MdYeVTSPA3FQMnUHL/e7qKm/H6Y/SBiXZQ0yXSCJDR95zbrlRXd/3W75J7tlkBhgda
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Save and restore the PCIe capability control registers through the
per-device saved capability store instead of a private pci_cap_saved_state
buffer.

The private buffer is an opaque array of u16s whose layout is a contract
between pci_save_pcie_state() and pci_restore_pcie_state(). Anything else
that needs to touch the saved state has to know that contract, e.g.
pci_update_aspm_saved_state() patches the saved Link Control register with
a comment reminding the reader that cap[1] is LNKCTL. Indexing the saved
state by configuration space offset removes the coupling.

Describe the registers to save in pcie_saved_regs[] and drive the
reservation, save, and restore loops from it so that the three can no
longer disagree about which register is where. Reserve the registers in
pci_reserve_pcie_state(), named to match pci_save_pcie_state() and
pci_restore_pcie_state().

Reserve the registers based on pci_is_pcie() rather than
pci_find_capability(PCI_CAP_ID_EXP), so that a device whose capability
list is broken but whose pcie_cap a quirk has fixed up gets saved state
like any other PCIe device. Drop the save buffer that
quirk_intel_qat_vf_cap() builds by hand, since it is no longer needed.

Keep using pcie_capability_read_word() and pcie_capability_write_word() to
access the hardware so that registers the device does not implement are
skipped. Reserve space for all of the registers regardless; that is
harmless, since an unimplemented register reads back as zero and is
never written.

Make pci_save_pcie_state() void, so pci_save_state() no longer fails with
-ENOMEM when the PCIe save buffer is missing. A failure to allocate the
store is reported once during device setup instead.

No other functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pci.c       | 92 +++++++++++++++++++++++------------------
 drivers/pci/pcie/aspm.c | 16 +++----
 drivers/pci/quirks.c    | 30 +-------------
 3 files changed, 59 insertions(+), 79 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 007f9bb289d5..fde1dcd99e94 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1795,7 +1795,20 @@ int pci_set_power_state_locked(struct pci_dev *dev, pci_power_t state)
 }
 EXPORT_SYMBOL(pci_set_power_state_locked);
 
-#define PCI_EXP_SAVE_REGS	7
+/*
+ * PCIe capability registers saved and restored by the PCI core. Registers a
+ * device does not implement are skipped by the pcie_capability_*() accessors,
+ * so space is reserved for all of them regardless of the device.
+ */
+static const u16 pcie_saved_regs[] = {
+	PCI_EXP_DEVCTL,
+	PCI_EXP_LNKCTL,
+	PCI_EXP_SLTCTL,
+	PCI_EXP_RTCTL,
+	PCI_EXP_DEVCTL2,
+	PCI_EXP_LNKCTL2,
+	PCI_EXP_SLTCTL2,
+};
 
 static struct pci_cap_saved_state *_pci_find_saved_cap(struct pci_dev *pci_dev,
 						       u16 cap, bool extended)
@@ -1819,41 +1832,47 @@ struct pci_cap_saved_state *pci_find_saved_ext_cap(struct pci_dev *dev, u16 cap)
 	return _pci_find_saved_cap(dev, cap, true);
 }
 
-static int pci_save_pcie_state(struct pci_dev *dev)
+static void pci_save_pcie_state(struct pci_dev *dev)
 {
-	int i = 0;
-	struct pci_cap_saved_state *save_state;
-	u16 *cap;
+	unsigned int i;
+	u16 val;
 
 	if (!pci_is_pcie(dev))
-		return 0;
+		return;
 
-	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
-	if (!save_state) {
-		pci_err(dev, "buffer not found in %s\n", __func__);
-		return -ENOMEM;
+	for (i = 0; i < ARRAY_SIZE(pcie_saved_regs); i++) {
+		pcie_capability_read_word(dev, pcie_saved_regs[i], &val);
+		pci_write_saved_cap_word(dev, dev->pcie_cap + pcie_saved_regs[i],
+					 val);
 	}
 
-	cap = (u16 *)&save_state->cap.data[0];
-	pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &cap[i++]);
-	pcie_capability_read_word(dev, PCI_EXP_LNKCTL, &cap[i++]);
-	pcie_capability_read_word(dev, PCI_EXP_SLTCTL, &cap[i++]);
-	pcie_capability_read_word(dev, PCI_EXP_RTCTL,  &cap[i++]);
-	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &cap[i++]);
-	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &cap[i++]);
-	pcie_capability_read_word(dev, PCI_EXP_SLTCTL2, &cap[i++]);
-
 	pci_save_aspm_l1ss_state(dev);
 	pci_save_ltr_state(dev);
+}
 
-	return 0;
+static void pci_reserve_pcie_state(struct pci_dev *dev)
+{
+	unsigned int i;
+	int rc;
+
+	if (!pci_is_pcie(dev))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(pcie_saved_regs); i++) {
+		unsigned int off = dev->pcie_cap + pcie_saved_regs[i];
+
+		rc = pci_reserve_saved_cap(dev, off, sizeof(u16));
+		if (rc) {
+			pci_err(dev, "unable to reserve PCI Express save state (%pe)\n",
+				ERR_PTR(rc));
+			return;
+		}
+	}
 }
 
 static void pci_restore_pcie_state(struct pci_dev *dev)
 {
-	int i = 0;
-	struct pci_cap_saved_state *save_state;
-	u16 *cap;
+	unsigned int i;
 
 	/*
 	 * Restore max latencies (in the LTR capability) before enabling
@@ -1862,8 +1881,7 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
 	pci_restore_ltr_state(dev);
 	pci_restore_aspm_l1ss_state(dev);
 
-	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
-	if (!save_state)
+	if (!pci_is_pcie(dev))
 		return;
 
 	/*
@@ -1873,14 +1891,13 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
 	 */
 	pci_bridge_reconfigure_ltr(dev);
 
-	cap = (u16 *)&save_state->cap.data[0];
-	pcie_capability_write_word(dev, PCI_EXP_DEVCTL, cap[i++]);
-	pcie_capability_write_word(dev, PCI_EXP_LNKCTL, cap[i++]);
-	pcie_capability_write_word(dev, PCI_EXP_SLTCTL, cap[i++]);
-	pcie_capability_write_word(dev, PCI_EXP_RTCTL, cap[i++]);
-	pcie_capability_write_word(dev, PCI_EXP_DEVCTL2, cap[i++]);
-	pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, cap[i++]);
-	pcie_capability_write_word(dev, PCI_EXP_SLTCTL2, cap[i++]);
+	for (i = 0; i < ARRAY_SIZE(pcie_saved_regs); i++) {
+		u16 reg = pcie_saved_regs[i];
+		u16 val;
+
+		if (pci_read_saved_cap_word(dev, dev->pcie_cap + reg, &val))
+			pcie_capability_write_word(dev, reg, val);
+	}
 }
 
 static int pci_save_pcix_state(struct pci_dev *dev)
@@ -1935,9 +1952,7 @@ int pci_save_state(struct pci_dev *dev)
 	}
 	dev->state_saved = true;
 
-	i = pci_save_pcie_state(dev);
-	if (i != 0)
-		return i;
+	pci_save_pcie_state(dev);
 
 	i = pci_save_pcix_state(dev);
 	if (i != 0)
@@ -3733,10 +3748,7 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
 {
 	int error;
 
-	error = pci_add_cap_save_buffer(dev, PCI_CAP_ID_EXP,
-					PCI_EXP_SAVE_REGS * sizeof(u16));
-	if (error)
-		pci_err(dev, "unable to preallocate PCI Express save buffer\n");
+	pci_reserve_pcie_state(dev);
 
 	error = pci_add_cap_save_buffer(dev, PCI_CAP_ID_PCIX, sizeof(u16));
 	if (error)
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 95ac34a34bd5..02922b887ec6 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -324,26 +324,20 @@ static int policy_to_clkpm_state(struct pcie_link_state *link)
 
 static void pci_update_aspm_saved_state(struct pci_dev *dev)
 {
-	struct pci_cap_saved_state *save_state;
-	u16 *cap, lnkctl, aspm_ctl;
-
-	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
-	if (!save_state)
-		return;
+	u16 lnkctl, aspm_ctl;
 
 	pcie_capability_read_word(dev, PCI_EXP_LNKCTL, &lnkctl);
 
 	/*
-	 * Update ASPM and CLKREQ bits of LNKCTL in save_state. We only
+	 * Update ASPM and CLKREQ bits of LNKCTL in the saved state. We only
 	 * write PCI_EXP_LNKCTL_CCC during enumeration, so it shouldn't
-	 * change after being captured in save_state.
+	 * change after being captured in the saved state.
 	 */
 	aspm_ctl = lnkctl & (PCI_EXP_LNKCTL_ASPMC | PCI_EXP_LNKCTL_CLKREQ_EN);
 	lnkctl &= ~(PCI_EXP_LNKCTL_ASPMC | PCI_EXP_LNKCTL_CLKREQ_EN);
 
-	/* Depends on pci_save_pcie_state(): cap[1] is LNKCTL */
-	cap = (u16 *)&save_state->cap.data[0];
-	cap[1] = lnkctl | aspm_ctl;
+	pci_write_saved_cap_word(dev, dev->pcie_cap + PCI_EXP_LNKCTL,
+				 lnkctl | aspm_ctl);
 }
 
 static void pcie_set_clkpm_nocheck(struct pcie_link_state *link, int enable)
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e500c202d2ec..9203ffb2ff72 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5512,10 +5512,9 @@ int pci_dev_specific_disable_acs_redir(struct pci_dev *dev)
  */
 static void quirk_intel_qat_vf_cap(struct pci_dev *pdev)
 {
-	int pos, i = 0, ret;
+	int pos, ret;
 	u8 next_cap;
-	u16 reg16, *cap;
-	struct pci_cap_saved_state *state;
+	u16 reg16;
 
 	/* Bail if the hardware bug is fixed */
 	if (pdev->pcie_cap || pci_find_capability(pdev, PCI_CAP_ID_EXP))
@@ -5546,10 +5545,6 @@ static void quirk_intel_qat_vf_cap(struct pci_dev *pdev)
 	pci_read_config_word(pdev, pos, &reg16);
 	if (reg16 == (0x0000 | PCI_CAP_ID_EXP)) {
 		u32 status;
-#ifndef PCI_EXP_SAVE_REGS
-#define PCI_EXP_SAVE_REGS     7
-#endif
-		int size = PCI_EXP_SAVE_REGS * sizeof(u16);
 
 		pdev->pcie_cap = pos;
 		pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
@@ -5561,27 +5556,6 @@ static void quirk_intel_qat_vf_cap(struct pci_dev *pdev)
 		ret = pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &status);
 		if ((ret != PCIBIOS_SUCCESSFUL) || (PCI_POSSIBLE_ERROR(status)))
 			pdev->cfg_size = PCI_CFG_SPACE_SIZE;
-
-		if (pci_find_saved_cap(pdev, PCI_CAP_ID_EXP))
-			return;
-
-		/* Save PCIe cap */
-		state = kzalloc(sizeof(*state) + size, GFP_KERNEL);
-		if (!state)
-			return;
-
-		state->cap.cap_nr = PCI_CAP_ID_EXP;
-		state->cap.cap_extended = 0;
-		state->cap.size = size;
-		cap = (u16 *)&state->cap.data[0];
-		pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &cap[i++]);
-		pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &cap[i++]);
-		pcie_capability_read_word(pdev, PCI_EXP_SLTCTL, &cap[i++]);
-		pcie_capability_read_word(pdev, PCI_EXP_RTCTL,  &cap[i++]);
-		pcie_capability_read_word(pdev, PCI_EXP_DEVCTL2, &cap[i++]);
-		pcie_capability_read_word(pdev, PCI_EXP_LNKCTL2, &cap[i++]);
-		pcie_capability_read_word(pdev, PCI_EXP_SLTCTL2, &cap[i++]);
-		hlist_add_head(&state->next, &pdev->saved_cap_space);
 	}
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
-- 
2.56.0.455.g6c5a503b38-goog


