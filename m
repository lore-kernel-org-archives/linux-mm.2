Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65818606D83A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lQR2/QvD
Received: by kanga.kvack.org (Postfix)
	id 512F66B05BE; Thu,  5 Nov 2026 19:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4676B05BF; Thu,  5 Nov 2026 19:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33E336B05C0; Thu,  5 Nov 2026 19:43:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00B906B05BE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8884A80398
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:10 +0000 (UTC)
X-FDA: 85402844940.29.2EEF3C0
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id CC560100007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="lQR2/QvD";
	spf=pass (imf05.hostedemail.com: domain of 3myLtaggKCPIXgUnfUWeaiiafY.Wigfchor-ggepUWe.ila@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3myLtaggKCPIXgUnfUWeaiiafY.Wigfchor-ggepUWe.ila@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHjhOa1kArquGp6NzqJKIMKukUgu91Ev2XX32EWf/dM=;
	b=eclm6Hb0sRSv+X5SNIzwDbK2fWr53zyC/wk7zl79YVkVjtFl4BV1U7Kuh63tmI5xfr9R94
	jfObmPOPpeT2OfKwT/fbCbDBQ7aiZRnH7XfngOAhZtvLWOucoVL/tg3OsxFv7uKsIyAKrK
	jg4nfusnfaYZ/4ZarsXRs9Kmxr2g4qo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925788;
	b=LYwxwMS5mD3Z84XCMKZzOsV1z6qrVSYtgyeryIshqYLCuiO7idTLtGauAd4BZeG0FJ6r2N
	Vxoaih0Pko4eSUqH7ZyqrRj1rIP4mIljZTTanIN58OePWg1LZTUXhWnkHutc3beqxFme5u
	A5pRwc1YnosSLPz/kGadgwWxjFxgmPM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="lQR2/QvD";
	spf=pass (imf05.hostedemail.com: domain of 3myLtaggKCPIXgUnfUWeaiiafY.Wigfchor-ggepUWe.ila@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3myLtaggKCPIXgUnfUWeaiiafY.Wigfchor-ggepUWe.ila@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b37620eb73so89897b6e.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925788; x=1794530588; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iHjhOa1kArquGp6NzqJKIMKukUgu91Ev2XX32EWf/dM=;
        b=lQR2/QvDgbLHyZimN0A6B7JWQGHAx1zZkitwhcFgD+8KNS5za0atbWsDRgdQ9QSYbK
         8bqj3YisZNG3lcbg+pXil1W+y/Bmo9Sx3dIBNo2ukHvUIsD5akeM2tfwpTYGnFhWLgYA
         xVaZ9SxVgw8pg3vvtbtG/hPyBgNXzzdLgMqCq2r1MgK7knTb1ey8w2QCXZ+bXmd36gGI
         ugL4S+BNXNhOyPO2o3IajY2mXNOoY8M+aHJ0NOTztX00hFTnVUXBMj2YmeJ3wmhnMTQL
         0VfGOR+JSPIPRL1KA5tG7SP7bGaepqPec2lYFO2hbt7t7F8Ecc/cXpbNOVKvuDOakCVl
         cnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925788; x=1794530588;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iHjhOa1kArquGp6NzqJKIMKukUgu91Ev2XX32EWf/dM=;
        b=NolqT9M10rZfg8yjJ1aSz2dZHx6TbGNVgCFmfa+VNViBzF0Lb0EPl1v+wr/kxJeKNQ
         Ehy0UxnRc8+7K/SmAT3WazcHuwMvv8iCrX9lHxUJsaJ18EWsVq042rNtG9lcpgHUHbV+
         faYKzGVlV8x3uuPwQ9co9hgwNjVl1gPPeY9YE5BL8cwLD4Q6kiqBHdnpkfAfgdkFfa8Y
         YhOx3PHwHiWn70pXvLNXgPVPYNogaRn59OQZsxsJvfKdszWnr3kfLA1cIvgF6LuBiqq7
         EXhBEe7NNNIurf1U/hbG3AyYtXkNhKgj9ovn1E7mK0iW0iP73j0NMHrnZhF9vFDA1dgJ
         SByA==
X-Forwarded-Encrypted: i=1; AKwUvBznlrpSmHOXxNUHWnBV338J9h1wvR4eU5XgSR7k8foV6+aWIUKK16B/aOmhu123jGGT2X0dZAQ3vg==@kvack.org
X-Gm-Message-State: APuU4Z853dG4F7a5FYiKgDlk5oT9ImEmtMIP/JzE1gg2P+ybFmPxxzny
	81gTg5zQMiKHvZBzv17cDT78thACfENQgWa0ZUim2r7xZI2rk6FDcsAMoBpBkf568Xl2m6BgR8t
	K4FBrjOAD/C/Qrw==
X-Received: from jabfi10.prod.google.com ([2002:a05:6638:630a:b0:61a:c6d0:4104])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4f66:b0:4b2:8d7b:41b8 with SMTP id 5614622812f47-567e1440ea0mr750093b6e.18.1793925787537;
 Thu, 05 Nov 2026 16:43:07 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:10 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-10-dmatlack@google.com>
Subject: [PATCH v2 09/17] PCI/PTM: Save PTM state in the saved capability store
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
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: kzreeh9z1t66kboapqixb7uszje64bx9
X-Rspamd-Queue-Id: CC560100007
X-Rspam-User: 
X-HE-Tag: 1793925788-110778
X-HE-Meta: U2FsdGVkX18fWAMEms9xSWrzNgcR9xonwO8CY52B68h+uZrnuLOADSfvLgxpJYcTqw7+5pkjHSEC01HSUPBaDh3P00xlizKnn6SA9wywS8xH2EMFfyTuul3zAs4u86kys2LwzZEjsM2AQeGqiA7IArsSBbrGVww4m+fOc68qmeP0fUIglsD+fHD0z8n0eGtzVM7EhzgCuU31s5k7dRxSUnEN2vHUMAM9hi5WB3Rc12EkKaP/Gi4/WG4Vk6Aj9Ya1QJ3bGn32apwT9zFiRA4GNRkpP0TKhe+akvLF5sKqfT0hvjbGkqAV00ow0YfwByUQelaS1QgLksAMTH2XBLLnqNJyX/Hh6fokp5mYmeDIw+XxZOm3G5ApvrhBW3cgHOOiiGQEW7gq1IANk3F8gvTyarPZIvYjIC+atqvNkG4DxaLFPaR+D9m15X01SlTR51zcIrR79wNO9Cp3kkh+atV7A0R8v04O/mmdsjBfLhIlwPjzL1S7PLV4a2clGwk5ox9B+DE8dNq6p3KxJ5MudfvcnOrJFCNEfAz244wNL7vDMp4a6WFOXF0t9Ts0jV7q1edNVXDuW2A6YJibgEDczH9JoEg+D+JOA6AjBsuA6hqEm6odtfXAkkJNLqvSpt8NWbedPZPFiJpRIQutOBsOOCyyHF/7ZBckjtEw2lYDZIXEn/2IbbOY+Ru0hK7EvAansmDWjCvUoO+gpiJudWFkmyepLxxECIHlQK3m/KI6969MJ35XmNz8xzBEkh+S2J2u9vtQiJuDbNntMEs7j54EGKy+SdjSp8ULIPTiz1IPxx4Eiv3SDGTdfivC5jY0jUL9gKFWMYwqZvM7Nii2JWBYA0hSNzPfNLHkj3L2ZqtEqtLyxEBNmG54c9mtlRpl+2bzVjNiulnAMmmoM2kj18ObZ+jo94Bu+tR/eXpePgCJA9gn9P8y8x4zGoL8sZqNDVGhctNXzOLNX5X9HzGyfuwmNbk
 fcPCv0zv
 kxyeet3MUJaj4JFgC1ivG2D7+K0Dx87k7+wuRLCzDu51YNJT2UfUk4VmDAq4RBd6d0mvM762+6uEnAd3OtGJBStAAIHbHcB6QBxb4Je1CVLrdSNVwoksFghALov+UQw2rmiEYBywbEf2dT+alNZwMvxgcgq/9cduhuz6uAeZgJWryDMZmokY5hAXhlpFvVm/FhPfLPoxM6EijCWZzqOLoR7OWbwwDdgFujie3UbATDVM/vA0rKm9zO2vuSELJYEoS6CnTJIz5h2eEMc8RyVnroBg3K/BFTyDLEocxR8QS19S5XFFluH7Rdvx1spW7xvM2rK3X2PXFT12w9Y6PMlPJQZQ3IOKsKxxVvAcVgJZFSx77J/9fZlcWwObKHX3TV2k28QjfnnGHpnq3Em6NaW/JbV7pE7wAmhxHkSA9/LWaehmEskOCMdF7p22nJTOzzUkxe3U/JDyJ+/oBEy4r+z0T5hYsNvhzLMJEyZWL7jqpXCsI2u26MNgFmmPlHsdBrkQA/YT4KUKZT78zLLXwCZZgoL9bMhZ2eJVmbNdi03hl3OlSmI/vnj3S2VZGBfT5ZNNRMlMtwS3zfskp76+UmggWR5/79g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Save and restore the PTM Control register through the per-device saved
capability store instead of a private pci_cap_saved_state buffer.

Reserve the register in pci_reserve_ptm_state(), called from
pci_ptm_init(), and report a refused reservation. pci_ptm_init() ignored
the return value of pci_add_ext_cap_save_buffer(), so a failed
allocation left PTM state unsaved without any message. An allocation
failure is now reported once by pci_saved_caps_finalize().

No other functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pcie/ptm.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/pcie/ptm.c b/drivers/pci/pcie/ptm.c
index bd3bd39f6372..fc653d2d1ec5 100644
--- a/drivers/pci/pcie/ptm.c
+++ b/drivers/pci/pcie/ptm.c
@@ -34,6 +34,16 @@ static struct pci_dev *pci_upstream_ptm(struct pci_dev *dev)
 	return NULL;
 }
 
+static void pci_reserve_ptm_state(struct pci_dev *dev)
+{
+	int rc;
+
+	rc = pci_reserve_saved_cap(dev, dev->ptm_cap + PCI_PTM_CTRL, sizeof(u32));
+	if (rc)
+		pci_err(dev, "unable to reserve PTM save state (%pe)\n",
+			ERR_PTR(rc));
+}
+
 /*
  * Find the PTM Capability (if present) and extract the information we need
  * to use it.
@@ -53,7 +63,7 @@ void pci_ptm_init(struct pci_dev *dev)
 
 	dev->ptm_cap = ptm;
 	atomic_set(&dev->ptm_enable_cnt, 0);
-	pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_PTM, sizeof(u32));
+	pci_reserve_ptm_state(dev);
 
 	pci_read_config_dword(dev, ptm + PCI_PTM_CAP, &cap);
 	dev->ptm_granularity = FIELD_GET(PCI_PTM_GRANULARITY_MASK, cap);
@@ -90,36 +100,18 @@ void pci_ptm_init(struct pci_dev *dev)
 
 void pci_save_ptm_state(struct pci_dev *dev)
 {
-	u16 ptm = dev->ptm_cap;
-	struct pci_cap_saved_state *save_state;
-	u32 *cap;
-
-	if (!ptm)
+	if (!dev->ptm_cap)
 		return;
 
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_PTM);
-	if (!save_state)
-		return;
-
-	cap = (u32 *)&save_state->cap.data[0];
-	pci_read_config_dword(dev, ptm + PCI_PTM_CTRL, cap);
+	pci_save_cap_dword(dev, dev->ptm_cap + PCI_PTM_CTRL);
 }
 
 void pci_restore_ptm_state(struct pci_dev *dev)
 {
-	u16 ptm = dev->ptm_cap;
-	struct pci_cap_saved_state *save_state;
-	u32 *cap;
-
-	if (!ptm)
-		return;
-
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_PTM);
-	if (!save_state)
+	if (!dev->ptm_cap)
 		return;
 
-	cap = (u32 *)&save_state->cap.data[0];
-	pci_write_config_dword(dev, ptm + PCI_PTM_CTRL, *cap);
+	pci_restore_cap_dword(dev, dev->ptm_cap + PCI_PTM_CTRL);
 }
 
 /* Enable PTM in the Control register if possible */
-- 
2.56.0.455.g6c5a503b38-goog


