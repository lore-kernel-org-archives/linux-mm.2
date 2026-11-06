Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8986A606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iCOFGkZ4
Received: by kanga.kvack.org (Postfix)
	id 1B8506B05C6; Thu,  5 Nov 2026 19:43:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A666B05C7; Thu,  5 Nov 2026 19:43:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F056B05C8; Thu,  5 Nov 2026 19:43:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C15936B05C6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46B101C4411
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:19 +0000 (UTC)
X-FDA: 85402845318.14.BAF6306
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf29.hostedemail.com (Postfix) with ESMTP id 88A25120006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iCOFGkZ4;
	spf=pass (imf29.hostedemail.com: domain of 3pCLtaggKCPsgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3pCLtaggKCPsgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925797;
	b=scIrdoEZ6FezdgvZylKRLiaFvIhDmH0xSCzI5JMwq+DZNxw/QqqKad4zYj+Vc2fDSYR5O9
	6d4eyr/6/HSUC6fSb+61XVM+iwUy0Gt0gBEtFJPYR0gUNppBtfpc0oA1xTFiaNhOZ/FEnp
	8eA4zpVRCbIJgBs7GleFHRkGVPf9Wvk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iCOFGkZ4;
	spf=pass (imf29.hostedemail.com: domain of 3pCLtaggKCPsgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3pCLtaggKCPsgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjSXIgXOyhHFXs7xglb6RCi5mzea7rcfoR/tpBA6uG4=;
	b=JHQ6A66oof7e9NXIhYVKcD8hGP9kiS3Zh12jMfJkSWy1TeocPBpelNFClE2rbfv4/vE+qr
	Fc+T5vHBWnaEPOzaE06I5vX5SsdokmA0DF6Gz3ZDmfcuEy/pSJGkFqMNN1nM+bmxCM349I
	zky+Ja5q1SqnM7UmH1GfGkRQMFjcsQg=
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4c7f887ac6bso83045b6e.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925796; x=1794530596; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jjSXIgXOyhHFXs7xglb6RCi5mzea7rcfoR/tpBA6uG4=;
        b=iCOFGkZ4+QZLnDzAa0MjMsjsgYVhlUsTBmKfU6e+2+SkmaXKggs+9Nb20nR81vfjPG
         oj576/J9Z66JuY82HlmxJ9dZwBIJcN+WEtfsEpOnPRnIGq2f9D0EzwnfiYBj0DlSuNml
         RZvl+A/qqmCixfVVXIAEo3evKTfgeRAAOTQ1hfGnty9hfWrD0XhQD3gmXAdHq+BZrJRj
         SLsOpJZUvPvzE/t7QZo13p6F9IzDXrBA5ObBofTyNlZadsRm6EZDb/Lk2IvqF3bnG9A5
         u2G/xtNB1y0Cqdn+cMOuDONWED3oo/z+y/Sr//Cz4IA0XeMTS7cZmD51KbF/nRbE917w
         VO0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925796; x=1794530596;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jjSXIgXOyhHFXs7xglb6RCi5mzea7rcfoR/tpBA6uG4=;
        b=gjT87bOnE/S9M5KAvM3BnTbk2xutJ8/9fw0oQbiq4lOa8dIfm3PWDvzyQOribwhbiO
         8Z63olssHeoJfy/BPSglU+VQf/Uk4ObucaH3S7JB9GKhPKa3r8T3C3884uDV6hT5jGWE
         HCBIvDEAWIjZOwaeJRA56Q4J2c5PUMVQox6GvMBN6ALl2Qm4vu03jWMLpsxpsV7qSQV5
         pzXtszBHkH3olZ9UZGHvkdYVGbksnTrTu0+NKGH6/CjT8kfC19AqnuOsWee/B0fTJhPS
         QVa8/SSP5KUjCCZA0FpK71dpGwcIyq7Ogb0mf6hif9WjxTF8kDTr6eDiSqxCFZaoxkoM
         psNQ==
X-Forwarded-Encrypted: i=1; AKwUvBwMgRP2W/lTW6XgUK8++nNup8VUbZEPFLyE0bRtkhx3QTAyOf30W9iGm9D/xrGcHhOyWVcACsrBMQ==@kvack.org
X-Gm-Message-State: APuU4Z8X6isw80FuYSvZH+tZM+AkCrr2t2gqgfJ9dTD02eHPp8K7PyJG
	uJtioFY2jDjVhO36rJF8D3qLsZ0Cfo+rM6VeQaCRQ1gCS5g1c/matl1/nmc188ulfVhrcUmqm7b
	5vOj0zYCZBLuAgA==
X-Received: from ioy12.prod.google.com ([2002:a05:6602:a10c:b0:9e0:f441:f5dd])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6f89:b0:4f6:5279:5c89 with SMTP id 5614622812f47-567e15b703bmr658717b6e.47.1793925796333;
 Thu, 05 Nov 2026 16:43:16 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:17 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-17-dmatlack@google.com>
Subject: [PATCH v2 16/17] PCI: Remove the per-capability save buffers
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 88A25120006
X-Stat-Signature: um8bqoc65qrae456dthsc8nmwdmocyxp
X-Rspam-User: 
X-HE-Tag: 1793925797-6928
X-HE-Meta: U2FsdGVkX1+gntByEy2Tovdnp86if7y0l2SONOAU27GWJqOFDtoYcFQdYb3zo6pPGmlSKdBEKsMmD2hq2XsSOU7kALI+mBm9qNP/IHyXITvsKXuI5aGBF9WLkY4nfdrw1aYMsJM1tKKRCB+YM/R7LCQm+RPuGOPSdTey9JwSMXiSlVCGN8VdLkzkke0+IVMLc/b2f+uKj9+EDRC0y+PqDs65bhq4PKIT5LrC17XzfBA3YguO8jXLFQwalSbEeYLng7jmTCIeFDUzu3dmMOsbHON7IQkeqwYN4ylM4I96smTxPjae23LsYt/m/BQn9/6l/VGH75JzSAvX2u+V0wdzyMNh+ay9mGQlNyyB3/ApQ3+PBA3p69PR018kQVv8n+wrtm+vMCZvGtLcx0vdmbC1zlA04MC/YM30+zyKQPr+6NM6+WSkbF6EhCLnzN8ETxPI1sEVKqUZN8CPf5GZHmdSgQbzjQYx737xdaZRE8ONyCMwI/FgwIGn0+jd6mTwMiRXKsjyf9RbqTxsJzJ2oTCncqeyCmC221C6dTf5rtLHXJrK2qygtZ8sXMz4HP2YQ8/IB/MdsfgszK9+Gk4sNBCdHVUtyUVvzN3F82rHnlHD4gxtTW6MHxVxzHePQ908BfMbLRwDWlupRv2ptjLN9bnAPXU1COtVv75h1nyl8MePCLrYMnYVEWCrFTGEa2IvJUXPrBVIGIHFeEYpgFggoqso6T+MyJBkBXpmihwmvb2ftCmMRIqLYFYmt7sUvAOGVPXcL6NXGs1XN8grB47Iz57gvdjbVdqAhf6pKHg52EqEF9/OJYG1JGuCPOVAWRN1qfs0bTs5ZkUNak44mn6alIBObgmos7L9JdsTDVkOGLfMvIVsj4HOri7TP8WLZTQqcjzG9C8BP7qiDDrOJPWMCqV1eRfxexwZjHMEn9543Uqiuhqv/0462oYWopaTc83OVPCZWsnnwpCfY7i1WPplD+8
 YM2zgnKU
 RAM0V5tE1gmHNeKXXIdRlloZGn5CBFkcuf4Ca5xl/SdRC2gKAZXZzJPyeu3OynLFo4O/VHiinfCZFyQVTmuRAA2/GbFKgmiQ4IJpPXnCIjfsENKYSZ9eztkd0MDXyJse0MVMZDtCb6v8/JFKqK/2FzL70mIciLaqvmOpJ1/GV4TVzIC2mw58nxambn2Z0RR4PIB7BHzWXyW4JpniQPINBJSzBKj3kMxDiMzmeBw7RJFnc6gtWfLUno6KExBRHjKCdgv13nrD5dYL77+qiAneONH6e55urjjqzhutezVA3+UxTGDHF58aIbkifmvof65wBeC4po2cXvRc2yIIRqi2d5Mvpjr5h4qg3y0/VXGSlSaul2z5wMGMxBheCNQ1Xa+HH+DuyFeqoYb7x/6Gsmv1bE3KDBcB3mOS2tb5j9KHf6zKTV5lpsETsjZJqJq/59J870LrHRI2OYQi4hbCNdTT7mhsWZyL3fTGT6GRuFHeYVNBI5dg/fqpZnEp6fevmapZOcbM6+VTGQN4DvNjjRDLrCp1k4VOm/Yc4Z6Wm4vnilrg/YBzMuj6tS5Fr2SZ6S5pr61HYgk1COf7b+LUJswWxL6j4gUFvFYQhdQ+8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Delete struct pci_cap_saved_state, struct pci_cap_saved_data,
pci_dev.saved_cap_space and the helpers that managed them. Every capability
now saves its registers in the offset-indexed capability store, so nothing
is left to find, allocate or free.

Drop pci_free_cap_save_buffers() from pci_release_capabilities();
pci_saved_caps_release() already frees the one remaining allocation.

pci_store_saved_state() and pci_load_saved_state() no longer have to append
and consume the records of the capabilities that still had a buffer, so the
blob they exchange is now just the saved DWORDs.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pci.c   | 136 +-------------------------------------------
 drivers/pci/pci.h   |  19 -------
 drivers/pci/probe.c |   1 -
 include/linux/pci.h |   1 -
 4 files changed, 1 insertion(+), 156 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ab1e1d6847fc..d2a9718b6a65 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1802,28 +1802,6 @@ static const u16 pcie_saved_regs[] = {
 	PCI_EXP_SLTCTL2,
 };
 
-static struct pci_cap_saved_state *_pci_find_saved_cap(struct pci_dev *pci_dev,
-						       u16 cap, bool extended)
-{
-	struct pci_cap_saved_state *tmp;
-
-	hlist_for_each_entry(tmp, &pci_dev->saved_cap_space, next) {
-		if (tmp->cap.cap_extended == extended && tmp->cap.cap_nr == cap)
-			return tmp;
-	}
-	return NULL;
-}
-
-struct pci_cap_saved_state *pci_find_saved_cap(struct pci_dev *dev, char cap)
-{
-	return _pci_find_saved_cap(dev, cap, false);
-}
-
-struct pci_cap_saved_state *pci_find_saved_ext_cap(struct pci_dev *dev, u16 cap)
-{
-	return _pci_find_saved_cap(dev, cap, true);
-}
-
 static void pci_reserve_pcie_state(struct pci_dev *dev)
 {
 	unsigned int i;
@@ -2017,32 +1995,12 @@ EXPORT_SYMBOL(pci_restore_state);
  *
  * Laid out so that the position of every value is described by the device's
  * configuration space rather than by the kernel.
- *
- * Capabilities that have not moved to the saved capability store yet keep
- * their own buffer, and their records trail @dword_val until the last of
- * those buffers goes away. Both areas vary in length and only one of them
- * can be a flexible array member, so the records are reached with
- * pci_saved_state_records() rather than declared here.
  */
 struct pci_saved_state {
 	unsigned long	dword_map[BITS_TO_LONGS(PCI_CFG_SPACE_EXP_DWORDS)];
 	u32		dword_val[];
-	/* struct pci_cap_saved_data cap[] follows dword_val */
 };
 
-/*
- * The records that follow the saved DWORDs, one per capability that still has
- * its own save buffer, terminated by an empty record.
- */
-static struct pci_cap_saved_data *
-pci_saved_state_records(struct pci_saved_state *state)
-{
-	unsigned int nr_dwords = bitmap_weight(state->dword_map,
-					       PCI_CFG_SPACE_EXP_DWORDS);
-
-	return (struct pci_cap_saved_data *)&state->dword_val[nr_dwords];
-}
-
 /**
  * pci_store_saved_state - Allocate and return an opaque struct containing
  *			   the device saved state.
@@ -2054,11 +2012,8 @@ struct pci_saved_state *pci_store_saved_state(struct pci_dev *dev)
 {
 	DECLARE_BITMAP(map, PCI_CFG_SPACE_EXP_DWORDS);
 	struct pci_saved_caps *caps = &dev->saved_caps;
-	struct pci_cap_saved_state *tmp;
-	struct pci_cap_saved_data *cap;
 	struct pci_saved_state *state;
 	unsigned int dword, nr_dwords, i = 0;
-	size_t size;
 
 	if (!dev->state_saved)
 		return NULL;
@@ -2070,14 +2025,7 @@ struct pci_saved_state *pci_store_saved_state(struct pci_dev *dev)
 
 	nr_dwords = bitmap_weight(map, PCI_CFG_SPACE_EXP_DWORDS);
 
-	size = struct_size(state, dword_val, nr_dwords);
-
-	/* Room for the buffers that are left, and for the terminator */
-	size += sizeof(struct pci_cap_saved_data);
-	hlist_for_each_entry(tmp, &dev->saved_cap_space, next)
-		size += sizeof(struct pci_cap_saved_data) + tmp->cap.size;
-
-	state = kzalloc(size, GFP_KERNEL);
+	state = kzalloc(struct_size(state, dword_val, nr_dwords), GFP_KERNEL);
 	if (!state)
 		return NULL;
 
@@ -2092,15 +2040,6 @@ struct pci_saved_state *pci_store_saved_state(struct pci_dev *dev)
 			pci_read_saved_cap_dword(dev, dword * sizeof(u32), val);
 	}
 
-	cap = pci_saved_state_records(state);
-	hlist_for_each_entry(tmp, &dev->saved_cap_space, next) {
-		size_t len = sizeof(struct pci_cap_saved_data) + tmp->cap.size;
-
-		memcpy(cap, &tmp->cap, len);
-		cap = (struct pci_cap_saved_data *)((u8 *)cap + len);
-	}
-	/* Empty record terminates the list */
-
 	return state;
 }
 EXPORT_SYMBOL_GPL(pci_store_saved_state);
@@ -2113,7 +2052,6 @@ EXPORT_SYMBOL_GPL(pci_store_saved_state);
 int pci_load_saved_state(struct pci_dev *dev,
 			 struct pci_saved_state *state)
 {
-	struct pci_cap_saved_data *cap;
 	unsigned int dword, i = 0;
 
 	dev->state_saved = false;
@@ -2140,19 +2078,6 @@ int pci_load_saved_state(struct pci_dev *dev,
 		pci_write_saved_cap_dword(dev, off, val);
 	}
 
-	cap = pci_saved_state_records(state);
-	while (cap->size) {
-		struct pci_cap_saved_state *tmp;
-
-		tmp = _pci_find_saved_cap(dev, cap->cap_nr, cap->cap_extended);
-		if (!tmp || tmp->cap.size != cap->size)
-			return -EINVAL;
-
-		memcpy(tmp->cap.data, cap->data, tmp->cap.size);
-		cap = (struct pci_cap_saved_data *)((u8 *)cap +
-		       sizeof(struct pci_cap_saved_data) + cap->size);
-	}
-
 	dev->state_saved = true;
 	return 0;
 }
@@ -3652,56 +3577,6 @@ void pci_ea_init(struct pci_dev *dev)
 		offset = pci_ea_read(dev, offset);
 }
 
-static void pci_add_saved_cap(struct pci_dev *pci_dev,
-	struct pci_cap_saved_state *new_cap)
-{
-	hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
-}
-
-/**
- * _pci_add_cap_save_buffer - allocate buffer for saving given
- *			      capability registers
- * @dev: the PCI device
- * @cap: the capability to allocate the buffer for
- * @extended: Standard or Extended capability ID
- * @size: requested size of the buffer
- */
-static int _pci_add_cap_save_buffer(struct pci_dev *dev, u16 cap,
-				    bool extended, unsigned int size)
-{
-	int pos;
-	struct pci_cap_saved_state *save_state;
-
-	if (extended)
-		pos = pci_find_ext_capability(dev, cap);
-	else
-		pos = pci_find_capability(dev, cap);
-
-	if (!pos)
-		return 0;
-
-	save_state = kzalloc(sizeof(*save_state) + size, GFP_KERNEL);
-	if (!save_state)
-		return -ENOMEM;
-
-	save_state->cap.cap_nr = cap;
-	save_state->cap.cap_extended = extended;
-	save_state->cap.size = size;
-	pci_add_saved_cap(dev, save_state);
-
-	return 0;
-}
-
-int pci_add_cap_save_buffer(struct pci_dev *dev, char cap, unsigned int size)
-{
-	return _pci_add_cap_save_buffer(dev, cap, false, size);
-}
-
-int pci_add_ext_cap_save_buffer(struct pci_dev *dev, u16 cap, unsigned int size)
-{
-	return _pci_add_cap_save_buffer(dev, cap, true, size);
-}
-
 /**
  * pci_reserve_saved_caps - reserve room to save capability registers
  * @dev: the PCI device
@@ -3715,15 +3590,6 @@ void pci_reserve_saved_caps(struct pci_dev *dev)
 	pci_reserve_vc_state(dev);
 }
 
-void pci_free_cap_save_buffers(struct pci_dev *dev)
-{
-	struct pci_cap_saved_state *tmp;
-	struct hlist_node *n;
-
-	hlist_for_each_entry_safe(tmp, n, &dev->saved_cap_space, next)
-		kfree(tmp);
-}
-
 /**
  * pci_configure_ari - enable or disable ARI forwarding
  * @dev: the PCI device
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 5a03561515ee..bc92b037b9d1 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -237,26 +237,7 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
 int pci_bus_error_reset(struct pci_dev *dev);
 int pci_try_reset_bridge(struct pci_dev *bridge);
 
-struct pci_cap_saved_data {
-	u16		cap_nr;
-	bool		cap_extended;
-	unsigned int	size;
-	u32		data[];
-};
-
-struct pci_cap_saved_state {
-	struct hlist_node		next;
-	struct pci_cap_saved_data	cap;
-};
-
 void pci_reserve_saved_caps(struct pci_dev *dev);
-void pci_free_cap_save_buffers(struct pci_dev *dev);
-int pci_add_cap_save_buffer(struct pci_dev *dev, char cap, unsigned int size);
-int pci_add_ext_cap_save_buffer(struct pci_dev *dev,
-				u16 cap, unsigned int size);
-struct pci_cap_saved_state *pci_find_saved_cap(struct pci_dev *dev, char cap);
-struct pci_cap_saved_state *pci_find_saved_ext_cap(struct pci_dev *dev,
-						   u16 cap);
 
 /* DWORDs of the configuration space header, i.e. pci_dev.saved_config_space */
 #define PCI_STD_HEADER_DWORDS	(PCI_STD_HEADER_SIZEOF / sizeof(u32))
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index c04adf606ab9..0a86de920225 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2475,7 +2475,6 @@ static void pci_release_capabilities(struct pci_dev *dev)
 	pci_aer_exit(dev);
 	pci_rcec_exit(dev);
 	pci_iov_release(dev);
-	pci_free_cap_save_buffers(dev);
 	pci_saved_caps_release(dev);
 }
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2c27124c81e5..6ba724e1f04e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -549,7 +549,6 @@ struct pci_dev {
 
 	spinlock_t	pcie_cap_lock;		/* Protects RMW ops in capability accessors */
 	u32		saved_config_space[16]; /* Config space saved at suspend time */
-	struct hlist_head saved_cap_space;
 	struct pci_saved_caps saved_caps; /* Saved capability registers */
 
 #ifdef CONFIG_HOTPLUG_PCI_PCIE
-- 
2.56.0.455.g6c5a503b38-goog


