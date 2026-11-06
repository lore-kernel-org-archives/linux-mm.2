Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30896608361A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BRqiDwJC
Received: by kanga.kvack.org (Postfix)
	id C673F6B05BB; Thu,  5 Nov 2026 19:43:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3DF76B05BD; Thu,  5 Nov 2026 19:43:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54C86B05BE; Thu,  5 Nov 2026 19:43:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86DE96B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11526C0781
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:08 +0000 (UTC)
X-FDA: 85402844856.18.4AA3B96
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4EA1D40008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BRqiDwJC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3mSLtaggKCPAVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3mSLtaggKCPAVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ddBqCr/aEaadxkJlxFoZmLz139RBeJBOYwKmQVBOEIY=;
	b=QyCthl9jYPTdyMghhNfwPFxtTvkZ9k970WI1oM76NMVniLXxlD2socjxfrXa7JJtcLdiPF
	LWS4rof10PofgU5km/IryCYAoAEPxs4pSqHAbXopGGJa00XN0n7Vap5LxsefPCBudZGldw
	EQGgvGziqQRJx1xTavW7GbN275BclgE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BRqiDwJC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3mSLtaggKCPAVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3mSLtaggKCPAVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925786;
	b=dMynQsDLle4nxL4Vg9Oz2sFhwwVj7D7gTKUrXK5WAWutRZ80qcY1JfWRjhsN63NcjlojR5
	47mOyVzDargseLC6dgRrbKeRObcqzbtIEga8Jh7hwhS785WqzwGh73Ae+sA2kksdbqslr5
	RO/vXpz/xSsNio/8oKSyi1bHnsJNJdU=
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-851f7cdfaefso153946a34.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925785; x=1794530585; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ddBqCr/aEaadxkJlxFoZmLz139RBeJBOYwKmQVBOEIY=;
        b=BRqiDwJCMWsPKYP95Vpybspbdy9DgN3cRYEjaFtjQecufBUwcu5W+elhUuqTVcq78F
         qZ7EAjMeb1DdbdmZV6kSc9rPrSKjypOEtjstf6bKgQA1+ktN3XSiEhgGkIXRo01t+WCh
         42eM4wHn00HHKgMspFUggpJgoI++Z7PgwvpS1q3TcnepUX1/o3OGJn9Mr5AQrSL6sTvl
         jAHByoC5JdP3wVJZ45z/fN+SiteiM8WPYASpFx2/9AhOXCIdZu0pkp0mwxXrj1lDUaGa
         i6q00yUI8cXMz0AfMGSi+DC/EVs/UevjD9NnA/9aowvcloi61nEyQOcxdnpXzC/NR4kc
         g/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925785; x=1794530585;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ddBqCr/aEaadxkJlxFoZmLz139RBeJBOYwKmQVBOEIY=;
        b=qjtp32kRM4TQQ+RKV2Fl0DouCcoAM2/I95cSkRH0XFdab85qGXiwwgffhbBCaHKVi9
         0EhMF7pL69XAhha722Jp6TgKfwFWS0kI+ezbLI7azQY1xJ5IDpeIfjqnLge9CcfyzCNN
         a3/2rqGahdVwRYSPfI4aGp1xYvRV2FIyiVBjdMjYTQhi1b4gd1JQe2LFl2IDlpr2Z0yp
         YQXd1yjt0D3a1pki3Tdz+rytidX9kLLDvboFBdz8aB1qEoTbhDjfchi2qBVzsut0Ccn4
         PPw29ElTkyN30Dd+KALgOCUx+enWq7/WIQEztIoAKiqiZRXs3CHBM5zkXSsFwYtiw3Ti
         I/SA==
X-Forwarded-Encrypted: i=1; AKwUvByWfO2BCPWqFWobuJxPOAog2k6x2cGMtnVqBzxB+DQLsKrnzp3imOfVxwk1hqvo3mUb6pY07ytrBQ==@kvack.org
X-Gm-Message-State: APuU4Z8fIHC3AK1KwinP8hsXlL9FcKZRzFzgqUJuDn7iA6Vjd0TKlcn3
	mQO1+zXDOaJoCQ7gDcojyqLaOMa/H9XnIyTG9jMrCwMMD9j8AtzPJz1SGY7NylqTonI3R2DEsWE
	0DMzQZIAivz3dUg==
X-Received: from iobmm23-n1.prod.google.com ([2002:a05:6602:7117:10b0:9ca:dec8:c75d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1987:b0:4f3:68d6:f131 with SMTP id 5614622812f47-567e099488cmr858385b6e.2.1793925785214;
 Thu, 05 Nov 2026 16:43:05 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:08 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-8-dmatlack@google.com>
Subject: [PATCH v2 07/17] PCI/ASPM: Save L1SS state in the saved capability store
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
X-Rspamd-Queue-Id: 4EA1D40008
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: q1ann999x6gdbei4x37wptysqkzu15yu
X-HE-Tag: 1793925786-589009
X-HE-Meta: U2FsdGVkX1+TblhxYmL6gNCQ3jJxXvrUthXNRe/ll+b1cQzXgtO7c/eDtiXGQ9Uf4YjOq7kdbpc+F++Dxw47ToMaFxAKMEFLLOUUhXJtdXzhIWRLnJrGzrcthIjF/9Smz6jC/L/VJZoErllj87Pr9UUsjD98BsVeVeJcU6xZDbQ4RJ1VO/ewcDYE+uUfaqsKXq/2BaG2dCSnuOsZrJBKI09grlyEAk7dosNHQPliPa9bqXKlFSe6H9yjvgS2DWtALvsLH3FEhE/W+qg+9Orf2zqkwbTu56bW+9BUBNMC96GpM4R3JP7wR+cZZ8NmLeZpBlVna4HpdtK00zyuk+feuWrvxOKDxuOFvvRTsL5AcMFTadD3ObKWnOCK7moOYZ08L3ssAZlHF5iBvcj5rW4GnyVLeejAnXfWewwYNww5RG1SHh2aL0ccvBsR5sg86SfCDhGChz0zX7c1DJEeeJrhklpyaGYcgmymfmlLiX75xU6/1VAM55KBQNCSlaAGWGzz5ii7np73HzhPFv2+i+6X+5HO+f4/9rNpPGJ5mXPCLnO8V3aFM74ysYPsFIPpab8u5rv4og30gZ7XJEhRvNdgzXPMnrGIi8s1Q1i8hcsRVNlocVu6W6K4laOCe8+vsncd35EOaUEzLotXoTJFwMrz7ADRXsa7EsFZoz9Hb+3ISoEZlTYZIvkEJD3F11RSMve1ngGzXLaE0OzfmSUlqyxdGtqV9lB/UOPBMsUPtKgma2x8Sop7AAq6rxnhJn3SY7iQQVB7u+iziSqE34LNmx0bvXs4EZrZ2gOkN8nDUK+T1wl2GjrSc3OHZgAKF8gRix5IA/tq0Ei9ikzJboUj5AgBSYcvZo7obBlfM39vI3OprHXUsEFzRraVROGyQWsg86Nx7r+VhDUJTGmkyseBsGHfEp+D26r/nch8p8lCVQ/mysM5KQY/LjyCTD4KKIHhwUnS2j6Q7Ic0HIuySQ5l1jB
 LCYo1F1H
 K4rllWYM2idXyKTGbw1CBhIllFBjOBQl8VgNHQAbQycH+A62D7CUMSVKDIc2P+jK3wEv50lcSV7KT23XeCcfD9ntfZJRqEIHoblOH6i7Z5nNaXVxoBLudzBldPJKIfvlknfzLEZlhAaGKbsBO8Vyo/xrTwxf2tkKm+m0QXU+A30U5DdPVhUmqE2XmPbbdEYexpK99XrSJUzrxhXXZxOO4tlqDIsIv9S+eEgsB3bt+/l7Eg42h7FAn62cp+KgAp5HT0y8YrcI7a4iJWMP5dcRExm6VlyRpa9lHXE4Xv0Jgliic11OG+D/hdG/eyvSQ2Ln+hg9jlcSjpZZDwbnabg42i1+dA8tBF9wMyrR9vk8HWa24v/LW77rokN890gR9XgXnhTon0MVx3lBsWI3uBjI7seEoA78JPptlhJP9nFuDEohjqirI557fMizbAoD3c42O5HUPmf5hNe23uCrvcJ5mnLs7xaRSSqhZk4GOwywWL4dFQNeA0uFLL9vGFUj+OGQcLn4NPwshtSpBM0iP4j+3UgekCJn1nSNUJONQ9Rlq5+hK+mBPGOJyIoq4HlWToEX+3rwRROTdX8zMUOvwKp9s/U+77Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Save and restore the L1 PM Substates control registers through the
per-device saved capability store instead of a private pci_cap_saved_state
buffer.

pci_restore_aspm_l1ss_state() needs both the Upstream and Downstream
Port's saved L1SS configuration, and had to fetch two buffers and decode
each by index. Read the saved values by configuration space offset
instead, which names the register at every use. Add
pci_read_saved_l1ss_ctl() to read one device's pair, so that the Port
and the device below it are read the same way.

Reserve PCI_L1SS_CTL1 and PCI_L1SS_CTL2 with a single request in
pci_reserve_aspm_l1ss_state(), since they are adjacent DWORDs. Skip the
reservation when the device has no L1SS capability, which
pci_add_ext_cap_save_buffer() did implicitly.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pcie/aspm.c | 63 ++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 39adf2cad331..2978fde87af6 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -68,24 +68,29 @@ void pci_restore_ltr_state(struct pci_dev *dev)
 	pci_restore_cap_dword(dev, ltr + PCI_LTR_MAX_SNOOP_LAT);
 }
 
-void pci_configure_aspm_l1ss(struct pci_dev *pdev)
+static void pci_reserve_aspm_l1ss_state(struct pci_dev *pdev)
 {
 	int rc;
 
-	pdev->l1ss = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_L1SS);
-
-	rc = pci_add_ext_cap_save_buffer(pdev, PCI_EXT_CAP_ID_L1SS,
-					 2 * sizeof(u32));
+	/* PCI_L1SS_CTL1 and PCI_L1SS_CTL2 are adjacent DWORDs */
+	rc = pci_reserve_saved_cap(pdev, pdev->l1ss + PCI_L1SS_CTL1, 2 * sizeof(u32));
 	if (rc)
-		pci_err(pdev, "unable to allocate ASPM L1SS save buffer (%pe)\n",
+		pci_err(pdev, "unable to reserve ASPM L1SS save state (%pe)\n",
 			ERR_PTR(rc));
 }
 
+void pci_configure_aspm_l1ss(struct pci_dev *pdev)
+{
+	pdev->l1ss = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_L1SS);
+	if (!pdev->l1ss)
+		return;
+
+	pci_reserve_aspm_l1ss_state(pdev);
+}
+
 void pci_save_aspm_l1ss_state(struct pci_dev *pdev)
 {
 	struct pci_dev *parent = pdev->bus->self;
-	struct pci_cap_saved_state *save_state;
-	u32 *cap;
 
 	/*
 	 * If this is a Downstream Port, we never restore the L1SS state
@@ -102,32 +107,32 @@ void pci_save_aspm_l1ss_state(struct pci_dev *pdev)
 	 * Save L1 substate configuration. The ASPM L0s/L1 configuration
 	 * in PCI_EXP_LNKCTL_ASPMC is saved by pci_save_pcie_state().
 	 */
-	save_state = pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_L1SS);
-	if (!save_state)
-		return;
-
-	cap = &save_state->cap.data[0];
-	pci_read_config_dword(pdev, pdev->l1ss + PCI_L1SS_CTL2, cap++);
-	pci_read_config_dword(pdev, pdev->l1ss + PCI_L1SS_CTL1, cap++);
+	pci_save_cap_dword(pdev, pdev->l1ss + PCI_L1SS_CTL2);
+	pci_save_cap_dword(pdev, pdev->l1ss + PCI_L1SS_CTL1);
 
 	/*
 	 * Save parent's L1 substate configuration so we have it for
 	 * pci_restore_aspm_l1ss_state(pdev) to restore.
 	 */
-	save_state = pci_find_saved_ext_cap(parent, PCI_EXT_CAP_ID_L1SS);
-	if (!save_state)
-		return;
+	pci_save_cap_dword(parent, parent->l1ss + PCI_L1SS_CTL2);
+	pci_save_cap_dword(parent, parent->l1ss + PCI_L1SS_CTL1);
+}
 
-	cap = &save_state->cap.data[0];
-	pci_read_config_dword(parent, parent->l1ss + PCI_L1SS_CTL2, cap++);
-	pci_read_config_dword(parent, parent->l1ss + PCI_L1SS_CTL1, cap++);
+/*
+ * Read a device's saved L1 substate configuration.
+ *
+ * Return: true if both registers had a saved value, false otherwise.
+ */
+static bool pci_read_saved_l1ss_ctl(struct pci_dev *dev, u32 *ctl1, u32 *ctl2)
+{
+	return pci_read_saved_cap_dword(dev, dev->l1ss + PCI_L1SS_CTL1, ctl1) &&
+	       pci_read_saved_cap_dword(dev, dev->l1ss + PCI_L1SS_CTL2, ctl2);
 }
 
 void pci_restore_aspm_l1ss_state(struct pci_dev *pdev)
 {
-	struct pci_cap_saved_state *pl_save_state, *cl_save_state;
 	struct pci_dev *parent = pdev->bus->self;
-	u32 *cap, pl_ctl1, pl_ctl2, pl_l1_2_enable;
+	u32 pl_ctl1, pl_ctl2, pl_l1_2_enable;
 	u32 cl_ctl1, cl_ctl2, cl_l1_2_enable;
 	u16 clnkctl, plnkctl;
 
@@ -142,18 +147,10 @@ void pci_restore_aspm_l1ss_state(struct pci_dev *pdev)
 	if (!pdev->l1ss || !parent->l1ss)
 		return;
 
-	cl_save_state = pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_L1SS);
-	pl_save_state = pci_find_saved_ext_cap(parent, PCI_EXT_CAP_ID_L1SS);
-	if (!cl_save_state || !pl_save_state)
+	if (!pci_read_saved_l1ss_ctl(pdev, &cl_ctl1, &cl_ctl2) ||
+	    !pci_read_saved_l1ss_ctl(parent, &pl_ctl1, &pl_ctl2))
 		return;
 
-	cap = &cl_save_state->cap.data[0];
-	cl_ctl2 = *cap++;
-	cl_ctl1 = *cap;
-	cap = &pl_save_state->cap.data[0];
-	pl_ctl2 = *cap++;
-	pl_ctl1 = *cap;
-
 	/* Make sure L0s/L1 are disabled before updating L1SS config */
 	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &clnkctl);
 	pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &plnkctl);
-- 
2.56.0.455.g6c5a503b38-goog


