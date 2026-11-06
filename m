Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810BF606A33F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PzJGA6r6
Received: by kanga.kvack.org (Postfix)
	id BCAB06B05C0; Thu,  5 Nov 2026 19:43:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B538A6B05C1; Thu,  5 Nov 2026 19:43:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91396B05C2; Thu,  5 Nov 2026 19:43:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB7C6B05C0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9ADD160C5C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:11 +0000 (UTC)
X-FDA: 85402844982.26.9498F13
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2C80A180002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PzJGA6r6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3nCLtaggKCPMYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3nCLtaggKCPMYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmLjI9XOjWedNu4ucOWy6yZB8cv6/+TL9ec51bNxWwI=;
	b=UPkcjpvU7ua+3RxqSwVNVZUpbQOqbJxo9+IKzXvRtHb4+is46rBEuJioePCoXnIJTLp3h7
	ClsTGmLNlK7MCHyVvhq9/lJIwKReItR22Kk7/PSCMvNfvnU8tw8IPs92bckjRZtHfelVp2
	PR9lHeQ/9RxZV6bMweBENUs69KzFC1M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925790;
	b=oKAxqIWy35aVfvJO/vSmEG+2hcvYfbHjVD8v5gspPgBxFMgfeB1RxUFeFdIHrqe5RrKd5G
	8DyRBNKZyfD6dgTjWkZKnM9m1BnKixcX4uRf0GOvd+5HcZRVWq1p0VKs667/XKNqmueWuc
	/zZA/T3OzGaiyL7/O+SC5+mq68waxV4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PzJGA6r6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3nCLtaggKCPMYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3nCLtaggKCPMYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4cbf700ddccso53349b6e.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925789; x=1794530589; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jmLjI9XOjWedNu4ucOWy6yZB8cv6/+TL9ec51bNxWwI=;
        b=PzJGA6r6F8NjS4FzLeYr8B6kCxH4fpSyJxsyVJJpVMJcJrwhepVY706EX6pWbodPtS
         cXY7MwLLMCybGiGaq/tQXwliOEXjLikmXveN6+ABul/zUa45Y0qsFJswrb4Rvuij6rPP
         JMfBBgl9SKkdIuFm0fFDpdv4Pb8JNibfr9aYkG7rudUINz9FqX/4wddK/FDbg5RFlaxJ
         DUZHaE+Ld78oAcapJEynP4DQaI1iJQE7Db8EmFbSXfEQavSPE45Ux7TkMkXBEw/vxYnb
         ffeaseTvjqSxxy6HFGZ3R72neRNAAEPdI6mKstxMjNoA2Wdl5TTV85KnEvOROg0B+cil
         IJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925789; x=1794530589;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jmLjI9XOjWedNu4ucOWy6yZB8cv6/+TL9ec51bNxWwI=;
        b=GgmccGWZwBP2LNVqXcvuAvyfF1KVARM1qDt5eEd7JQ+lWECJ+kH34GXm4a2SyGC5wc
         uVy39I0k4nPh5f5+AfmDvYAa2GhuWjp3flNaAYCcawT8emJm702sejy4b5WeWJtQC4wJ
         J8oGevwA5umGFfdf714o8CJZVpmNvqj4djyffnjrTvvFF1IWP4wajOX2mRJpXmKSWEQ9
         nHJEXkIH92k0Yh4/JBb4Y40Qca+KH8PVokducgKZHQsDytxpCdKB3sPAn0NxAtlBbRm9
         DEpVquLnHFv9By6cpVE6KQG2KqZOWda+eqcQGrNKtKgB1C5/dCAsjyO0YtNG9cPkZU9Q
         iF8w==
X-Forwarded-Encrypted: i=1; AKwUvByoRsUGFJewn4a+GlYz3zVuTS5/zedAi//7Q7gn/4TPoB0rXmJv7Ygc26IOXqdxvkFySSlpnLQFuQ==@kvack.org
X-Gm-Message-State: APuU4Z+p4BpwqZKV7Uopz1BzyEkyWFAxmnLwx7GcOvkuURv8IktBEgwQ
	HiOwcEL9PBd/4a5t6Y6EymTWsdEPMS2RTEoTvVF50RycJ8ez2zZ3ZBKaeLAVyeOaQDMH9FU4C4r
	vqI8p5c8ob17DYw==
X-Received: from iofl4-n1.prod.google.com ([2002:a05:6602:8384:10b0:9e3:4909:2e0c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:5394:b0:4d6:92b3:5c85 with SMTP id 5614622812f47-567e18964a2mr623375b6e.66.1793925788751;
 Thu, 05 Nov 2026 16:43:08 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:11 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-11-dmatlack@google.com>
Subject: [PATCH v2 10/17] PCI/TPH: Save TPH state in the saved capability store
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
X-Stat-Signature: hgimud5q385den116iyg7a1eiupowksx
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C80A180002
X-HE-Tag: 1793925790-751984
X-HE-Meta: U2FsdGVkX1+J7D7hVhsD11TNKuBJ3ug67JaTyi2cfrTeA3u5LLGEMMytk1txJUO3VTKH3D0mtOVtbivddKVxo8z0FvbyuEswj6Ih8ciVCSeRqDnpTIUHC7lwR0kmBjJ2xOwBdOiqSBUHwBfcmpMKPEA5l8GIQaek8tg1eM1uIxVE7F2w+fFXwGBv1y/6JfM1/GOzyLSIQj1+lqANBix6psCpn91vQ3Q9qAwU6STTiDy++M/zG2MWBaCUgPZ3hfDENWeljSrUtdGwE136FwN7uFf9FFOzfVjoZIcxceuuy6/WpXromhyZKRE0ulaYL4/YxpQdLIwHnSRDI6+GbE9/qOv+hnsOV0lndtsIjOEmeCHAXPsxjGr0ywj4YJ+rze6TxF+iNxdhIkGKLiy2AaY6/3vcqv+Hp8uQEwzQQbIItZrsyMAKUm7kzW7ZAUEtz49R68vj/2cIqa6a3oGB6T3zrInP2IeDYpklnMNmc8OxPeJAiqUQ2qFhMIE72ufF2CWJSuvRS0kjENCh+NFgGaBZM5VZbDdRYRUeRTPqCGOXnZfhzQGcAKyGQ18JMQ46xRImJlJ1t+VH8vSBxdCmdX6EwXO9zy6koNL/W5cv3g33jvvCIKTfMHEkumaUvUAPrgHbyrYQLugChnhD5RiUXMQJPCG0qo6flcHZ0Wk3KrkB4J5IVIuxcHKb1iaOU7vwE9ZsneCLbf/ZwsKi9WybSexnIoULTd3b18Y2N02cwpaEly3hrDInONAn5l6/KSwWcjhFdGiW6sX/5jAI0hq8mNUWMN7aBkWTffZkO3D1zp0qYDNc1/buAeWeSGRLTGpsDVnWSjghDAB4GV6cTKsq9vGnp2wMUDka7dYXJQ6xBFORPWsNfOfDNfKxDhbsyTAPPQjwpxQEa+/scObfGRVC4jrtgbWhjLFUUTUwW6TH54xUdCobKf5yPJIzya7wYfoyY573tymaINTR7M5x/GoVZTR
 r2eUQhQ/
 vFB37lUXpA/NfaWgxz8H467J3OXIogxc16O5z1Zhb9YSWOEUHGZL4JlVeLvxwccLThdVm5OMPhH/Aaxt8dhUV3toI2wC1CAWXkpa9HP6Qnml7OR2/1/Gry5HO399jWUHiHos7uYv7tqDoEu4/wddJZWLpiVl2ducVzdAcyfOf+gPOW2ORNb+aKJrmNXIkk1hWKIXfcyPEImwngI9m6T8kVvt8wUHdwqe2tzJLue51wdstZcAvd/0RlUNm6yn/qCZUxpSF8qXBdX+6LEPh9dipROmzQ7ZWQsRbyqnIroNxxhtd8X9dcv8VfujILNeb8wnUZD5ZYFyxdqEGXsMGN6Kp135NFzfCqDD/5CAagVNWfvs2DkfdreyUVSPYbdA05eQ/XZx+MMKIke16WFzpw5/ti8mOhTxrGDXraBdhEgx8fI/bgAYK+ZhYUeURMk4XqPrvSzRUQ1FO5HcLSHdJmxoKYpYl9ODc9+TRDz3GymvaC2AxfXYTByX2lGFOOVn11YUIFIRKrQ6c7SIu9TzYgbGdqqgBp1mv3PHqZjA/8bk0nTaDbuAxqnuU6lCfB4SfpZF31XJNdnRcpQIX4C9v8Fa03JEk0o5wuLGgvMdp5mI9gXD72o9p+4ulLVI0o/lAngdePlEj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Save and restore the TPH Control register and Steering Tag table through
the per-device saved capability store instead of a private
pci_cap_saved_state buffer.

The Steering Tag table is variable length, so pci_tph_init() had to compute
a buffer size and both the save and restore loops had to walk that buffer
in step with configuration space. Reserve the table by offset instead so
that the loops can address the entries directly.

Reserve the registers in pci_reserve_tph_state(), called from
pci_tph_init(), and report a refused reservation. pci_tph_init() ignored
the return value of pci_add_ext_cap_save_buffer(), so a failed
allocation left TPH state unsaved without any message. An allocation
failure is now reported once by pci_saved_caps_finalize().

No other functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/tph.c | 54 +++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
index 655ffd60e62f..3ab8d5b2ab10 100644
--- a/drivers/pci/tph.c
+++ b/drivers/pci/tph.c
@@ -439,10 +439,7 @@ EXPORT_SYMBOL(pcie_enable_tph);
 
 void pci_restore_tph_state(struct pci_dev *pdev)
 {
-	struct pci_cap_saved_state *save_state;
 	int num_entries, i, offset;
-	u16 *st_entry;
-	u32 *cap;
 
 	if (!pdev->tph_cap)
 		return;
@@ -450,29 +447,19 @@ void pci_restore_tph_state(struct pci_dev *pdev)
 	if (!pdev->tph_enabled)
 		return;
 
-	save_state = pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_TPH);
-	if (!save_state)
-		return;
-
 	/* Restore control register and all ST entries */
-	cap = &save_state->cap.data[0];
-	pci_write_config_dword(pdev, pdev->tph_cap + PCI_TPH_CTRL, *cap++);
-	st_entry = (u16 *)cap;
+	pci_restore_cap_dword(pdev, pdev->tph_cap + PCI_TPH_CTRL);
 	offset = PCI_TPH_BASE_SIZEOF;
 	num_entries = pcie_tph_get_st_table_size(pdev);
 	for (i = 0; i < num_entries; i++) {
-		pci_write_config_word(pdev, pdev->tph_cap + offset,
-				      *st_entry++);
+		pci_restore_cap_word(pdev, pdev->tph_cap + offset);
 		offset += sizeof(u16);
 	}
 }
 
 void pci_save_tph_state(struct pci_dev *pdev)
 {
-	struct pci_cap_saved_state *save_state;
 	int num_entries, i, offset;
-	u16 *st_entry;
-	u32 *cap;
 
 	if (!pdev->tph_cap)
 		return;
@@ -480,21 +467,14 @@ void pci_save_tph_state(struct pci_dev *pdev)
 	if (!pdev->tph_enabled)
 		return;
 
-	save_state = pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_TPH);
-	if (!save_state)
-		return;
-
 	/* Save control register */
-	cap = &save_state->cap.data[0];
-	pci_read_config_dword(pdev, pdev->tph_cap + PCI_TPH_CTRL, cap++);
+	pci_save_cap_dword(pdev, pdev->tph_cap + PCI_TPH_CTRL);
 
 	/* Save all ST entries in extended capability structure */
-	st_entry = (u16 *)cap;
 	offset = PCI_TPH_BASE_SIZEOF;
 	num_entries = pcie_tph_get_st_table_size(pdev);
 	for (i = 0; i < num_entries; i++) {
-		pci_read_config_word(pdev, pdev->tph_cap + offset,
-				     st_entry++);
+		pci_save_cap_word(pdev, pdev->tph_cap + offset);
 		offset += sizeof(u16);
 	}
 }
@@ -506,16 +486,30 @@ void pci_no_tph(void)
 	pr_info("PCIe TPH is disabled\n");
 }
 
-void pci_tph_init(struct pci_dev *pdev)
+static void pci_reserve_tph_state(struct pci_dev *pdev)
 {
-	int num_entries;
-	u32 save_size;
+	unsigned int off, len;
+	int num_entries, rc;
+
+	off = pdev->tph_cap + PCI_TPH_CTRL;
+	rc = pci_reserve_saved_cap(pdev, off, sizeof(u32));
 
+	num_entries = pcie_tph_get_st_table_size(pdev);
+	if (!rc && num_entries) {
+		off = pdev->tph_cap + PCI_TPH_BASE_SIZEOF;
+		len = num_entries * sizeof(u16);
+		rc = pci_reserve_saved_cap(pdev, off, len);
+	}
+	if (rc)
+		pci_err(pdev, "unable to reserve TPH save state (%pe)\n",
+			ERR_PTR(rc));
+}
+
+void pci_tph_init(struct pci_dev *pdev)
+{
 	pdev->tph_cap = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_TPH);
 	if (!pdev->tph_cap)
 		return;
 
-	num_entries = pcie_tph_get_st_table_size(pdev);
-	save_size = sizeof(u32) + num_entries * sizeof(u16);
-	pci_add_ext_cap_save_buffer(pdev, PCI_EXT_CAP_ID_TPH, save_size);
+	pci_reserve_tph_state(pdev);
 }
-- 
2.56.0.455.g6c5a503b38-goog


