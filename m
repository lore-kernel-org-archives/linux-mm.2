Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C076A606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cS26SqxE
Received: by kanga.kvack.org (Postfix)
	id 429536B05BD; Thu,  5 Nov 2026 19:43:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9F36B05BE; Thu,  5 Nov 2026 19:43:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0DA6B05BF; Thu,  5 Nov 2026 19:43:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E978B6B05BD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 79C731A0CAD
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:09 +0000 (UTC)
X-FDA: 85402844898.15.C4B189F
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf01.hostedemail.com (Postfix) with ESMTP id A722140005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cS26SqxE;
	spf=pass (imf01.hostedemail.com: domain of 3miLtaggKCPEWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3miLtaggKCPEWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+Hzdt+LObwzKPIKo4htZh/cma3z4S09Q2AYbp2zhRQ=;
	b=e7UIHi+4sGw3KLye4o5pYpY3P4XcKTGL9JssCKWHm5/Ur3NQCbNytYDEih59gXmzgicaT/
	49BvEKMijYIVSG35fxbW/TeDTrRydmECgH8MrsLk57PUfVJcnONsUJrKAYeOlDv5tsB+O8
	LkDWeM2vm7eNbXF3sCtaFVKkkyOGuWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925787;
	b=Qhb2t1EiXH9dAr9yBmQrsqUd8wcHXYiDbgA5YXioYRef2cfuN6b741Cj9k2Z9k/gdF1t0u
	PeEK3GsyBK4tHVf2lPF1M8eh3/LQk3OvIsLQoMc/d9YZk1gwYgebxIECerAS0WDlaUC99l
	lt2P1WxIfJmreuhoMUkXW7HLL0WOdsk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cS26SqxE;
	spf=pass (imf01.hostedemail.com: domain of 3miLtaggKCPEWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3miLtaggKCPEWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b37620eb73so89877b6e.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925787; x=1794530587; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L+Hzdt+LObwzKPIKo4htZh/cma3z4S09Q2AYbp2zhRQ=;
        b=cS26SqxEo+BmugI26eOaWDaR/nACPyNipBYXAee83qeIj2jfz/MsBm0IqdQwJKFfge
         RjF6ZGgU9CVaQ+dcIoxIjM2HYb34TIBeZSnBNhqjXDL6kZGnq/v2ZTMSUPEyfJuiWw9m
         whTi48RfqaKrdpgaFJc/jzudIVQoH3LQYClXd99GHsEiGYe9WFl2XQFdwYix+9CCIiv2
         QCGPDN15BWDUXOPlDp/3Uwv40Z/4wOtXgIaOt1KDnpiPgtGAeTHalBIP1FsvWo6a3xsq
         JGVP+WZHSbOtEvZMgE/clc26EG5vpwhDHKe4Bf2frdjZoM21/TVQ56J/o0jVBXD5Ieqy
         YUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925787; x=1794530587;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L+Hzdt+LObwzKPIKo4htZh/cma3z4S09Q2AYbp2zhRQ=;
        b=NK72u90frpAcmkAIyBCC0ui71QNOTOfzgI6O2FB99rD9tGXKOlJXjdBSs1hBWCjXzH
         0nr2NHMd+VvqgjsC+EGQkin2iG8c1Ebtr8fuDZY1EpEJqHhwh5/TghLQ9eJMNTOcshha
         heir3SIR7Vl8iCKrFFnhewnenqHmwGXCEmp3X6wNXXiY2jAeVG+HNwcgj3xcLYAwMGeG
         0ylb6wjbRpqymqhr1y6lLz7JZ+1XOy47AcSSQ6+l5e6T6gXz9vJNxSL54EX25TNS49nz
         Bibqh5PumGw000XwYZMa63RSornVTZN0L669EA1beAgZH2Trocktm/4nNsCYJj9EQcQm
         NznQ==
X-Forwarded-Encrypted: i=1; AKwUvBweRcXK9IAaSJrvLB1hG8SstwxoariUjW+Dsgs+OIIKNgS+IEfuebjxnDnBZv2PZEO5yUuI9YJ08A==@kvack.org
X-Gm-Message-State: APuU4Z91mCi3mn8MYt7TYiPh7UogxK0hMIzhRsTQivdMC5y+4CFgNCVG
	6D46AmwJ4ruItISlW74xdrT464ILbK/q4jxh4sc8SASRIhlpFJfI6tRW8iKH8IgU89Zb3qn9jls
	VdubFg+Ul6tpV0g==
X-Received: from iozd24.prod.google.com ([2002:a05:6602:3298:b0:9c7:85f4:7637])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:23cf:b0:532:d9f5:1de6 with SMTP id 5614622812f47-567e182dc9fmr636250b6e.65.1793925786350;
 Thu, 05 Nov 2026 16:43:06 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:09 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-9-dmatlack@google.com>
Subject: [PATCH v2 08/17] PCI/AER: Save AER state in the saved capability store
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
X-Rspamd-Server: rspam06
X-Stat-Signature: yazujsrg4kekazqo3tc83rftd8xexsyx
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A722140005
X-Rspam-User: 
X-HE-Tag: 1793925787-622293
X-HE-Meta: U2FsdGVkX1/XzMo8Xq2UQ3tqj0UcOP8JkhVI+AY/mpr04e/q8Vfo9eaDi/KVD2DGV4vas7Z0QNNVOGhZ9W/16DuN4JUgbnsyQ3OVesW2vJzGR+/2GWZmH0wuZAuQXyEf2iYvbwVixnc0NxSsq8Elru66PIbSUFa7QOud1nVvFXpOTNxXOfHKBwplG4K7vYPriSQsaFSCNLI0lEdSF5notM2u3eABnZpc0u+EV7BFoU391QRfT9MWWlawPmrIrHMlup+HDkHIPQDwWX03umNl6LHECJLzLEFTBhe8mY3ocPMIXo8U+mBPMfDHAWzhwuPunwDI7ve6ubtJOFcY6pedxl02nrh96kcrrckwA6gop1jzH/OeiA+jZSCvVA+2MUh23V19ZennzFvtQSZEx7+eLtfEiITQBqahTs63ysny7L9XIWCdx1fIRRnwBcsFbUnauRezop7G5YbeWcpjF7+M1LSCSCWplU8c7i4YD/KR8htwEn+AQC4zJwE3LhhZynZj2AUzhMu+HQweaYdM33Yx2JxMjAiL+ObSgpi6e2SZk1FWJ2UkCJe7hdVf8P2GGy+i8iXnxxdhRxDfniwZ7yc3ilAhBY6jY0v7ef5v/l0VkXkI/Gw0ntH0CNKqJbzDuGBzOPgaBttjzfF3wG5qaaNoKFPh/ToU0/G3T3wM/Xk1MhTAgusoRcAu8ivg8MUkcNVBFcCf1yC9Td3y+VGPg2QvsB6vLqUdsViRlyyBhBQcW+L8BpUT4NOl7fHWYKGDZIBjGLUfZXRfeHDJvBjmFKUyLTtkk6YaxQptWLtEa8VhQn/s+90JMGtAt+6paewXr+RooyEiFVwDOTSV9xWH+4CCLiTmEVpM6ORz1KXBZHVOZeRTg+bZvPp7/4EcNttLd0lnwTZTCIrqwJk/fXh0sLS8fuiW1uOyklif7IvQzuFUbytAVnmMnAkhi+TFYS+xjDMNIed/mXVaDED4icHiSMd
 LkM3Y/0T
 ohoqdkxqFbIADJDsnLvHuLL+8FShXg80O3fvB6e05B9G5dI7hY6M5pG0yayfSa/7LnQGLYlA2sKBSr1xGqmUBSM+5KAHsIvfpGHmGEYjFbkgOtbV8YcEv5b+n+9kd9ai76FmnnnfghLjBGpAv4h59DVKsYicrSl1OM2of3c51SLjh2g9Ln123w8EvxughkSUSTsLGqqzLCY9sOlT7/HUpfKBqZw6YoTlZ4/KoTHCelgHxYPyWVxc7FMOuzDW0OJhuWvCQNUBgn4LruJQ2UZSQbSKRvcKLG+0yCBLWFUXHeweOORhbm05iocgJZKcv7Gha7x3J2+F5qonc37/SxV2NAngR1RZEKe+RlPfjuVVp3KyKSDEURd+rUBKvR6CSmUrMC3hgH9dbu/fvtOWgZ7P4KgIlqVbgufRAkjcHwnymYnsx4H6GNI7O5X2lBPleCEyGh9rfCPIKXKBM9GAitbhQyX0/SGLTlJp14HwBiw+qDwxGil7lWUdnGJFId+PfYTumKSAom+MO1F55sQ93/yCEVAKrwSWO2o3Nq97S4df/b6aRUFu0NshYdWPoYWsYS9TAX1I7rRk2Mv7M/yyNoDhSYxNc3CQPbjdipCeEGIZwatqU6M2ejGg2OBz2edPO+96P/5P7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Save and restore the AER mask, severity, capability and root command
registers through the per-device saved capability store instead of a
private pci_cap_saved_state buffer.

Describe the registers in aer_saved_regs[] and drive the reservation, save,
and restore loops from it. Previously the three had to be kept in the same
order by hand, and pci_aer_init() encoded the register count as a bare 4 or
5.

Reserve the registers in pci_reserve_aer_state(), called from
pci_aer_init(), and report a refused reservation. pci_aer_init() ignored
the return value of pci_add_ext_cap_save_buffer(), so a failed
allocation left AER state unsaved without any message. An allocation
failure is now reported once by pci_saved_caps_finalize().

No other functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pcie/aer.c | 85 +++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 39 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index d8dcd238fda1..25436bcf9fb9 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -352,54 +352,68 @@ int pci_aer_clear_status(struct pci_dev *dev)
 	return pci_aer_raw_clear_status(dev);
 }
 
-void pci_save_aer_state(struct pci_dev *dev)
+/*
+ * AER registers saved and restored by the PCI core. PCI_ERR_ROOT_COMMAND is
+ * only implemented by Root Ports and Root Complex Event Collectors (PCIe
+ * r6.0, sec 7.8.4.9) and so must come last.
+ */
+static const u16 aer_saved_regs[] = {
+	PCI_ERR_UNCOR_MASK,
+	PCI_ERR_UNCOR_SEVER,
+	PCI_ERR_COR_MASK,
+	PCI_ERR_CAP,
+	PCI_ERR_ROOT_COMMAND,
+};
+
+static unsigned int aer_nr_saved_regs(struct pci_dev *dev)
 {
-	int aer = dev->aer_cap;
-	struct pci_cap_saved_state *save_state;
-	u32 *cap;
+	if (pcie_cap_has_rtctl(dev))
+		return ARRAY_SIZE(aer_saved_regs);
 
-	if (!aer)
-		return;
+	return ARRAY_SIZE(aer_saved_regs) - 1;
+}
 
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ERR);
-	if (!save_state)
+void pci_save_aer_state(struct pci_dev *dev)
+{
+	unsigned int i;
+
+	if (!dev->aer_cap)
 		return;
 
-	cap = &save_state->cap.data[0];
-	pci_read_config_dword(dev, aer + PCI_ERR_UNCOR_MASK, cap++);
-	pci_read_config_dword(dev, aer + PCI_ERR_UNCOR_SEVER, cap++);
-	pci_read_config_dword(dev, aer + PCI_ERR_COR_MASK, cap++);
-	pci_read_config_dword(dev, aer + PCI_ERR_CAP, cap++);
-	if (pcie_cap_has_rtctl(dev))
-		pci_read_config_dword(dev, aer + PCI_ERR_ROOT_COMMAND, cap++);
+	for (i = 0; i < aer_nr_saved_regs(dev); i++)
+		pci_save_cap_dword(dev, dev->aer_cap + aer_saved_regs[i]);
 }
 
 void pci_restore_aer_state(struct pci_dev *dev)
 {
-	int aer = dev->aer_cap;
-	struct pci_cap_saved_state *save_state;
-	u32 *cap;
+	unsigned int i;
 
-	if (!aer)
+	if (!dev->aer_cap)
 		return;
 
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ERR);
-	if (!save_state)
-		return;
+	for (i = 0; i < aer_nr_saved_regs(dev); i++)
+		pci_restore_cap_dword(dev, dev->aer_cap + aer_saved_regs[i]);
+}
 
-	cap = &save_state->cap.data[0];
-	pci_write_config_dword(dev, aer + PCI_ERR_UNCOR_MASK, *cap++);
-	pci_write_config_dword(dev, aer + PCI_ERR_UNCOR_SEVER, *cap++);
-	pci_write_config_dword(dev, aer + PCI_ERR_COR_MASK, *cap++);
-	pci_write_config_dword(dev, aer + PCI_ERR_CAP, *cap++);
-	if (pcie_cap_has_rtctl(dev))
-		pci_write_config_dword(dev, aer + PCI_ERR_ROOT_COMMAND, *cap++);
+static void pci_reserve_aer_state(struct pci_dev *dev)
+{
+	unsigned int i;
+	int rc;
+
+	for (i = 0; i < aer_nr_saved_regs(dev); i++) {
+		unsigned int off = dev->aer_cap + aer_saved_regs[i];
+
+		rc = pci_reserve_saved_cap(dev, off, sizeof(u32));
+		if (rc) {
+			pci_err(dev, "unable to reserve AER save state (%pe)\n",
+				ERR_PTR(rc));
+			return;
+		}
+	}
 }
 
 void pci_aer_init(struct pci_dev *dev)
 {
-	int n;
-
 	dev->aer_cap = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
 	if (!dev->aer_cap)
 		return;
@@ -415,14 +429,7 @@ void pci_aer_init(struct pci_dev *dev)
 	ratelimit_state_init(&dev->aer_info->nonfatal_ratelimit,
 			     DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RATELIMIT_BURST);
 
-	/*
-	 * We save/restore PCI_ERR_UNCOR_MASK, PCI_ERR_UNCOR_SEVER,
-	 * PCI_ERR_COR_MASK, and PCI_ERR_CAP.  Root and Root Complex Event
-	 * Collectors also implement PCI_ERR_ROOT_COMMAND (PCIe r6.0, sec
-	 * 7.8.4.9).
-	 */
-	n = pcie_cap_has_rtctl(dev) ? 5 : 4;
-	pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_ERR, sizeof(u32) * n);
+	pci_reserve_aer_state(dev);
 
 	/*
 	 * Advisory Non-Fatal Errors are masked by default (PCIe r7.0, sec
-- 
2.56.0.455.g6c5a503b38-goog


