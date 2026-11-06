Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9F56082BF7
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GIOx8tmr
Received: by kanga.kvack.org (Postfix)
	id 95A356B05BC; Thu,  5 Nov 2026 19:43:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909756B05BE; Thu,  5 Nov 2026 19:43:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FA36B05BD; Thu,  5 Nov 2026 19:43:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 55F966B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A02B120C45
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:07 +0000 (UTC)
X-FDA: 85402844814.06.8321BC5
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6DFB3C0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=GIOx8tmr;
	spf=pass (imf10.hostedemail.com: domain of 3lyLtaggKCO4TcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3lyLtaggKCO4TcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925785;
	b=7oRHaIa9dEIPGohAnYlwSNEFFxg1LsJ+/Oi9ipkya3d+STHLg+UAs+fzsWeAKnnqOz1PLm
	sq6SZiK9YqIrOpdwGmjY+LKnsQgwvUEpiljv9wLKnUmqAxc7Mb1888rn6dETmmDSi30U9m
	il9g1mObceAmbqk4dk18RnR2NJ7/ITs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=GIOx8tmr;
	spf=pass (imf10.hostedemail.com: domain of 3lyLtaggKCO4TcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3lyLtaggKCO4TcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqwfwAiEqbASiUZ5fLcpwdF4bH2r5Wh+f0RbnIc3OoY=;
	b=wRSJrUIsK4cx0bl6LhAD530Yqx2pkHHO8hjFPbFWNGB8oLfx80KSstrvO5lfmn7D4XuiR1
	rydq2cinGlBisDq/xoCUQ2rh9eouStAY769QBhF3qt9eOmxPAcAhKACISPOvXHkp/X9oF6
	rtuxxZk+CIkthLt6cQs6pvk49I7gV2A=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4ab4f652f9bso50405b6e.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925784; x=1794530584; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SqwfwAiEqbASiUZ5fLcpwdF4bH2r5Wh+f0RbnIc3OoY=;
        b=GIOx8tmru5tlHKiT348mBnLYrOqp6ogalX+1+i7xsuNG/3MIFLbT9MQB/hmfEYI9Hr
         VY4vp42OSq+sSnbuzh1YXRQ4vNQMuT4m7zwbPhQVqQyKEuoDcJEgb7ivag4V6Pp5SHcz
         vESeMC4VDk1UVb+rWa+9i1WQPavIM71dy8QO9fJHt8pRigWkhcCnG+ddvNu6QODmigi0
         x9LlAXsFTRKAjZSNAxG/xLBneSq+o5cVEJXtrQwXGJR7IiQn8cVJoKXfZ9jieDtYH5JF
         aLtaUuOteKc0aacsObM0qAMZ9ceLEehVfbFhiqEmxrQHsZzyvmVrrxz303qf4e28KEnp
         mtVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925784; x=1794530584;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SqwfwAiEqbASiUZ5fLcpwdF4bH2r5Wh+f0RbnIc3OoY=;
        b=Tue9jNaKKX1uAMeeayJo/2cWotpqFkBUV50e/Esy7Tcptiwtu2FnOFyypNhBwlDxv0
         EgwsPM7nLe6EYxz79cLKLIQl8t0m0czzipf8mS9x8bIxl/Wk5w6iqwqS/0bi6sm8Un7T
         6mBO6Up3R8sstVrY9uhCOA0QGPMGwW4pDsJQIpHPF6Qy9l8VGkf02UrNVUbwcXlVMoZl
         34kqs8pycG6CGT1Z6nRpbX9BJh2xqyJLMXGcDR1BJIQ/SAyxcgBYznIp9dcO0FsDxhy5
         PtNwGg2EB9Yz8WEaP2Stfbwov3QyNl+ypPOSCLzshec1HATNlBMGwgfcm5yJhYBz2XWV
         ryYA==
X-Forwarded-Encrypted: i=1; AKwUvBxYBhCza8Cc0lQiMsF8WIWQjhl8EvL78sAKmfMlyO4QGxOJkd7UirJYZgTtayImtD8AI5gReGkoLg==@kvack.org
X-Gm-Message-State: APuU4Z8HFoMc0odqd6c3y3eK39ft5ZopRMdNJHKcmGBqsngscHSiS2UP
	mOhc2zuoP/TjjGtaDU/6fQJW28HiQXWG7ISF6dN0ca3Pkc/5KeqIuf48g6QYGlJYpNpdEIXLf6I
	XI0qD23LA6dJDow==
X-Received: from ilbec12.prod.google.com ([2002:a05:6e02:470c:b0:53b:d168:b69])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2218:b0:50a:7162:87df with SMTP id 5614622812f47-567e098e3f0mr811203b6e.2.1793925783998;
 Thu, 05 Nov 2026 16:43:03 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:07 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-7-dmatlack@google.com>
Subject: [PATCH v2 06/17] PCI/ASPM: Save LTR state in the saved capability store
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
X-Stat-Signature: 8bgpmn7z46gj4jq18e37fai3149i43hs
X-Rspamd-Queue-Id: 6DFB3C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793925785-478270
X-HE-Meta: U2FsdGVkX1+p2EipePDC905vm8Ff8muE3AGsOBgJRqlrOzxYO3FJa5CxmgkNXQdHj7ruYV8dX0MO3qoNimCZNrOEEcRF9c5grm5FSChjRV/0DR22lNzLtY0ler+69XNjJiRg18QyxHj50bTJjX3oGTESY189He9N6YYtIWSKuUjINxF5qOLrVmEGo0Oa1Btc5LU+Tr2Cl8PCO6D/ZmVwfc4OqDXSf3vOHSyFaXbza7RUiHCppfSg/ZKSJaSx533w4cJI4IkKBw3MyntnF6J2lt3Jp/XkRWbLmhJkZDoJYALOU6F4RC5Glt7KzVELzmPJcLkpE9puqRl4YzIl4WK5O+n/qOGURy0DgoRj6O+mjKVoQQor9vPiocOn7D1C3F61qXX90N201X9Jm5TkTVv7EzqJ1Ad/zY9wXaJQg3hnSXZ1PTseuUR1Zekm3PFASsOLYj04x3+rgaHXrlltdEhB07vBBtpE92/hzlK8eHGcogobIc2sDB6dZ/2KrNb7VuxcIMlY8bCplA8+JFTDbcP34ZDECrBc1NUafT62s0brVan1ZKH/wowyQm+NdzVsGx7cLCn4XTNadSRFzLOSG05mPEuUB6NqZ/LPKKBt4wr0yFnD/QSGr7FG7iT2pPNwQ6224VJAr8Ai5SwU0ucHS1BZGs1h4gv6d+E9EYp6wJjiQpRH4O/T+HBHhzRYrMh4f8tHRk7n1fmOP1N5FvgiE8CyFs7mMcPhgSJch+Bt0Wyb2YFlu27cPUeMs/zRLOZC56uFolQebPUwOLtRVdUrYmPh1CRf2VQ94fGTClbTj7+i+E3pdW7db/BOKyHa9fdStTAwurhlRqwFtu6eFwnZxdgQtfpYi5GCmDxul/3vrjGPT5qoMuCfHrwG5P7Eq1/CbFeU1ow8hygU8dpbr5AWuJ9zQPBloOGLHF8kqaXFwzqeXs1udm+a5fTKDVCpNTBMYaIp+9b3dkKpg5lttiLWDSI
 xEZY9NQu
 HrWPy4qIPqc5RWYSs78oK2a5IuPiKUkHaH9MfxsXWp7kygu46FNpSbS2y3q8mRyGz1yrOUhScBnd8xLDcqTEaNhMOrk6Az8RpnMtd7GC1wSuJx/YeHtUjCL0eD85aDPLoDVILDwhy86nWz2BLpYZQCLm/w048hnPvTKhniSiAP9wB30xf+f530pccGdxsy1Invj2gkxIOwWHu9xUT85SwKyEshkvB77JEzOEKzywz11ri9EcI9NrZOKx61m0OoQMgSuY8a5s0REbQayA3k9O/BrzG8t6sDjgXvXwNkvy36LILyf1Mhii4yGDu/ju6bi2Z/nmzWtRWSiUqImn4+fSP4EIw/CTI/3H+LusWWo2lVv7eqsN76NT1pllgrBETKdBBeHNwgyNCVfwApR58ZtnNcyUswWPHwAYH2EJr9DSP0Kqio4yN4RXC7pEgNGANrRcK+jn0ty9NgUpi+K1gfHbW9d0WwJJdejKXq5CpsuzkOzd4gJf81AZoFHoUVL+6aQ5Q1o87mKriqtCuS6dm2QWWc0wt/FXp1xhbhG6JhfGFIJZF1wXM0pbKuK78q4C0l5j+IuLn8JxfmoX3P3/subSfCbymAmHpHQW0rW4O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Save and restore the LTR maximum latency registers through the per-device
saved capability store instead of a private pci_cap_saved_state buffer.

Reserve the DWORD by its configuration space offset during device setup,
in pci_reserve_ltr_state(), and keep accessing the registers a DWORD at
a time because some devices only support DWORD access to them.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pci.c       |  8 +-------
 drivers/pci/pci.h       |  1 +
 drivers/pci/pcie/aspm.c | 31 ++++++++++++++++---------------
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6cf4a64cb7e6..29d9474db1ae 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3742,15 +3742,9 @@ int pci_add_ext_cap_save_buffer(struct pci_dev *dev, u16 cap, unsigned int size)
  */
 void pci_allocate_cap_save_buffers(struct pci_dev *dev)
 {
-	int error;
-
 	pci_reserve_pcie_state(dev);
 	pci_reserve_pcix_state(dev);
-
-	error = pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_LTR,
-					    2 * sizeof(u16));
-	if (error)
-		pci_err(dev, "unable to allocate suspend buffer for LTR\n");
+	pci_reserve_ltr_state(dev);
 
 	pci_allocate_acs_save_buffer(dev);
 	pci_allocate_vc_save_buffers(dev);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 206e0d04e06e..0daa2439db5e 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1151,6 +1151,7 @@ int pcie_retrain_link(struct pci_dev *pdev, bool use_lt);
 
 /* ASPM-related functionality we need even without CONFIG_PCIEASPM */
 void pci_save_ltr_state(struct pci_dev *dev);
+void pci_reserve_ltr_state(struct pci_dev *dev);
 void pci_restore_ltr_state(struct pci_dev *dev);
 void pci_configure_aspm_l1ss(struct pci_dev *dev);
 void pci_save_aspm_l1ss_state(struct pci_dev *dev);
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 02922b887ec6..39adf2cad331 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -30,8 +30,6 @@
 void pci_save_ltr_state(struct pci_dev *dev)
 {
 	int ltr;
-	struct pci_cap_saved_state *save_state;
-	u32 *cap;
 
 	if (!pci_is_pcie(dev))
 		return;
@@ -40,31 +38,34 @@ void pci_save_ltr_state(struct pci_dev *dev)
 	if (!ltr)
 		return;
 
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_LTR);
-	if (!save_state) {
-		pci_err(dev, "no suspend buffer for LTR; ASPM issues possible after resume\n");
+	/* Some broken devices only support dword access to LTR */
+	pci_save_cap_dword(dev, ltr + PCI_LTR_MAX_SNOOP_LAT);
+}
+
+void pci_reserve_ltr_state(struct pci_dev *dev)
+{
+	int ltr, rc;
+
+	ltr = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_LTR);
+	if (!ltr)
 		return;
-	}
 
-	/* Some broken devices only support dword access to LTR */
-	cap = &save_state->cap.data[0];
-	pci_read_config_dword(dev, ltr + PCI_LTR_MAX_SNOOP_LAT, cap);
+	rc = pci_reserve_saved_cap(dev, ltr + PCI_LTR_MAX_SNOOP_LAT, sizeof(u32));
+	if (rc)
+		pci_err(dev, "unable to reserve LTR save state (%pe)\n",
+			ERR_PTR(rc));
 }
 
 void pci_restore_ltr_state(struct pci_dev *dev)
 {
-	struct pci_cap_saved_state *save_state;
 	int ltr;
-	u32 *cap;
 
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_LTR);
 	ltr = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_LTR);
-	if (!save_state || !ltr)
+	if (!ltr)
 		return;
 
 	/* Some broken devices only support dword access to LTR */
-	cap = &save_state->cap.data[0];
-	pci_write_config_dword(dev, ltr + PCI_LTR_MAX_SNOOP_LAT, *cap);
+	pci_restore_cap_dword(dev, ltr + PCI_LTR_MAX_SNOOP_LAT);
 }
 
 void pci_configure_aspm_l1ss(struct pci_dev *pdev)
-- 
2.56.0.455.g6c5a503b38-goog


