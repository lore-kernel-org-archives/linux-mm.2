Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE474606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EDQhmOef
Received: by kanga.kvack.org (Postfix)
	id 11C8A6B05C1; Thu,  5 Nov 2026 19:43:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CDE86B05C2; Thu,  5 Nov 2026 19:43:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8E76B05C3; Thu,  5 Nov 2026 19:43:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A88A96B05C1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DA55C0781
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:13 +0000 (UTC)
X-FDA: 85402845066.07.130B576
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf03.hostedemail.com (Postfix) with ESMTP id 742EF2000A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EDQhmOef;
	spf=pass (imf03.hostedemail.com: domain of 3niLtaggKCPUajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3niLtaggKCPUajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925791;
	b=neF5Xeo1arFiomLDMv8MnNj8kJ+lkhfnA0hUwmByAYZeFIeDZPqRNHxl2hVXE/PSwSwsaJ
	in81YxgMfFlNK/7LkqEf+OF4hckhlv50UHKkg1U5vNW1XoTXMgBYPta97Kc4TeNhfFmq28
	t6XEr5eh4labx4kS3ywstQh1n5bh7L0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EDQhmOef;
	spf=pass (imf03.hostedemail.com: domain of 3niLtaggKCPUajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3niLtaggKCPUajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VfIh1JSY3MeIq0CEtKa0epmsvwLqQj8oYtgMnnQZzbo=;
	b=JbxJObyMxke5nZI7JioQ3kSFyiSRDeC8Ly5ZPG3Lfm/tzG/oEJRYYMSh+Cc2MjZK8FcR87
	DdEJPB6ABnRXa2wAI2QGIl18c4KQO63++LGKGBha9iIIIuqDI438pdtZF+3wEB3cd+NuvD
	Xyhu3UDFBG/sWKmaauGKOj5LLoYI3Z0=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-85d502ea62cso237748a34.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925790; x=1794530590; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VfIh1JSY3MeIq0CEtKa0epmsvwLqQj8oYtgMnnQZzbo=;
        b=EDQhmOefmVgbR+hH395MNgeJg5Kwhz15959uwASNbV6owdj3Y/XQ51vdQgBlk7exyH
         C1BzdAvweX4lONPQhO/mVm1BOayO8ldUTkW9JwKfydbVW3p7Lj2hrq/qm0zY8ZgldeLv
         RZd1V2icbWBF+8/Yh3m5PGQCsBcUGxFVDpP4fvdKg90wmbegJdgaq+5+1KOfafbAkhRA
         9ZTsNkF2j5ZF1DqkgBDM7d4+03iwU9eBeUILYWszFq7/yCzBnqKsEyPIduFLeNqEpEji
         g3RVQ0ZzojMzgwb/lo0AVaUCZ5i0mjjgyFlxykswSL5Wa6r7c5RgoMf+3qpKLJX/DS3y
         IWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925790; x=1794530590;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VfIh1JSY3MeIq0CEtKa0epmsvwLqQj8oYtgMnnQZzbo=;
        b=aqXdh3Ll6N/PnqZWSRU3BNklH6k88vjK/2OLpmkTLVAjuk5z4YE0rvbryStDbmVRZo
         /lcPf9mwEipawk4wYDjpOlIM5HB6VyBMaAFQCo7nEsxIhi+zSVvCOn56KMDLlEVbSjmJ
         H9nfJ+pOVNAX//SCKQBfOuBMdJPF5KEpzqGiaHPwACKw7GUGDZ2SOxb76Ao13m0PxEQG
         nId9/zL1uCRF171BUrtqxq7W5QkOY69Ey6sx5KzLHtoTVKmvGAlXsioS99tmnsLDwn8W
         kSmdLAUeVUVGJEMkFm2O/dqt9luZmS/XrfjIuUikafmojvrfM+8RmxgWAJfKn9UfcZpi
         PzMQ==
X-Forwarded-Encrypted: i=1; AKwUvBzxvHHLZpd6JEbEBjB8S+IQ9CothphvSu1gQQTP0NpHYHcXt6hvkFNTh8LZN/sGtmIOYiC9t+F0iQ==@kvack.org
X-Gm-Message-State: APuU4Z9LDqPtJH7wF2zc9685bZWpfUxZi6ddC6yue9d32BrvbRmbxpJx
	Y5QZiXQQ8bUZDoj/GwH5oIQg9bnkgSuyirxaoDDK+zt3KOh9Ya2hT7oavAMDMQ5wHRqt0jZmK/N
	cBp/l7xVBRa0wSA==
X-Received: from ioo11-n1.prod.google.com ([2002:a05:6602:864b:10b0:9e2:221a:fd83])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1a21:b0:561:fa43:1b2f with SMTP id 5614622812f47-567e0fc17c3mr657310b6e.20.1793925790093;
 Thu, 05 Nov 2026 16:43:10 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:12 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-12-dmatlack@google.com>
Subject: [PATCH v2 11/17] PCI/DPC: Save DPC state in the saved capability store
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
X-Stat-Signature: je3sd53g14k3twukuhha7qxhpiwkuh53
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 742EF2000A
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793925791-473374
X-HE-Meta: U2FsdGVkX19sydONAvjjqZLj3nHHnNTVEn4uqZ0D+mWUQHwl9P5ahEL8oJokjarfox95LKveP+iE24AUOY2a4oUhtLjjPUoyboaWobaHMzx+sTlNgZLka5/9Lo0fK5pP20YrI1SWtt9b3wn+qGOaCpSjuHyuykDYfmdZySHiwSzIk1gbfhCS/kh2KHQZvv0RwtGI3J/ZLmVCiMDF/QPtVuGwO39EolUPeS8CEG5ViaDEfSGI1WYrLqcWq26ZtFdtV37yAmLoUrQNfe6wQZNYWPQoNBaz52I4A9iv7pkWjWn5s354MTxhn5GkfaZDs5oMq0BViJNwpkxlxbh5e83LVn+FpjgoX7/P1nZV+9vy72Y1bbDIX37BgVWnf3+qIvRMINve7nCmJbWfEv0N5K3fYooFfTO8wumcCO9xh4bv361CxLTgWcn+S19rLq0vVEkZzG1pZ2PUPo8f4P3Uzg3yUuem91AAlMa6WbeMdp0wGCBf4JU1VK5cHmXFUm/vcvv6s9L8ORCe2jHvwmUnKrf5giq82M9MW5xNp7HXAb0pMDV3ivlPYdjugE8aeHvgLa5D09Q8ks30of7N3Vzw2CMkzbRD7G15wIJAW20B31W7xIM0gT39riDQZxzzipMkyLPFYGSWT8oIPOyeDJ8CEdT7CLFTrbv9GhOhXBjX9MRL0OPfoN/uec1lvyOnafwlsuly/ekhVCinMk0TEBvmYBVTxpkDdR6v6lXsZ2sgP4mwOdRY+oJhO/lJ4ScWCYd/6kWQouYHmm+JNiaFollHVPnrzfzDZyOmndoH6czpWdTrlm45Lg7OoCPwPwe93Zi58SlvRBl2UfI6s6JWW42mdtfWOO+ed8dcPAbGp6JZNVF6g0r+VHhxVCNvZQeJiH64UGKS8vz7iwmn0Fdt2MLXipTKAqyG8gxC7Qw7CVOLdltUAm0U6u6eakLaKxMJsnVC29kz6PBj3Flo956Q70KibAZ
 OpuL10bw
 d+22L+hlh4o5kLHUazyG0SfZwgDvvcApCCip7FacJNmOlhGdH0aVlSd25w6WPqW8j5OXfl3QzS/tfm2rCM3Pw1a+ftxQbQl3VzWEKVIwsE6zPx2G+RnJz+KvUv8Vz0IOaRlMo319NI3LZJvHCWG33GB87FrX25VPzZ1cMtpWg1USR48MX9QcP3eu+3FjgLZxkV+8H7fiMziH4krdK3HH36Dd0KSjKyd0L69rslVJ0y/WbZhpqBRfYkD+O9zsV2PiEj/j8hC2ScNUJvm4yZwkabVSNBDa4IDH24EtWHmvVEPs62u8a+brhZpdk1h6s/5Ig8zx84JVFph1oVWF43rWHacqoPO7jRV7lm2qwuVdqOKKZlF4Q4pDUjxr645FO9Qi7P1edf4QUhiAtTQfUrJqTWJKk0rHgC/BFgDFG//j86TzOyXHDomSk1BHQOd4SmBdkf6JpnAJwINlVM8taDGlfEH50Z5N+4/KvEeTdBvF15Ka0ywcp89PYJIwZ7ZlLt+T6oAH1zf4wzfD1R4QTwUAEaquGIj0+rZ+Zm3IcOzF650k4mwZrn8tilWYhTuCl00hEkev2+0PdHBxa/eur5DG8CjXh6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Save and restore the DPC Control register through the per-device saved
capability store instead of a private pci_cap_saved_state buffer.

Key the save and restore paths off pdev->dpc_cap rather than
pci_is_pcie(). The old code relied on the save buffer existing only when
the capability did, and the store has no per-capability entry to check.

Reserve the register in pci_reserve_dpc_state(), called from
pci_dpc_init().

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pcie/dpc.c | 37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index b7f79266f66d..16203e9ef240 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -45,34 +45,18 @@ static const char * const rp_pio_error_string[] = {
 
 void pci_save_dpc_state(struct pci_dev *dev)
 {
-	struct pci_cap_saved_state *save_state;
-	u16 *cap;
-
-	if (!pci_is_pcie(dev))
-		return;
-
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_DPC);
-	if (!save_state)
+	if (!dev->dpc_cap)
 		return;
 
-	cap = (u16 *)&save_state->cap.data[0];
-	pci_read_config_word(dev, dev->dpc_cap + PCI_EXP_DPC_CTL, cap);
+	pci_save_cap_word(dev, dev->dpc_cap + PCI_EXP_DPC_CTL);
 }
 
 void pci_restore_dpc_state(struct pci_dev *dev)
 {
-	struct pci_cap_saved_state *save_state;
-	u16 *cap;
-
-	if (!pci_is_pcie(dev))
-		return;
-
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_DPC);
-	if (!save_state)
+	if (!dev->dpc_cap)
 		return;
 
-	cap = (u16 *)&save_state->cap.data[0];
-	pci_write_config_word(dev, dev->dpc_cap + PCI_EXP_DPC_CTL, *cap);
+	pci_restore_cap_word(dev, dev->dpc_cap + PCI_EXP_DPC_CTL);
 }
 
 static DECLARE_WAIT_QUEUE_HEAD(dpc_completed_waitqueue);
@@ -400,6 +384,16 @@ static irqreturn_t dpc_irq(int irq, void *context)
 	return IRQ_HANDLED;
 }
 
+static void pci_reserve_dpc_state(struct pci_dev *pdev)
+{
+	int rc;
+
+	rc = pci_reserve_saved_cap(pdev, pdev->dpc_cap + PCI_EXP_DPC_CTL, sizeof(u16));
+	if (rc)
+		pci_err(pdev, "unable to reserve DPC save state (%pe)\n",
+			ERR_PTR(rc));
+}
+
 void pci_dpc_init(struct pci_dev *pdev)
 {
 	u16 cap;
@@ -408,8 +402,7 @@ void pci_dpc_init(struct pci_dev *pdev)
 	if (!pdev->dpc_cap)
 		return;
 
-	if (pci_add_ext_cap_save_buffer(pdev, PCI_EXT_CAP_ID_DPC, sizeof(u16)))
-		pci_err(pdev, "unable to allocate suspend buffer for DPC\n");
+	pci_reserve_dpc_state(pdev);
 
 	pci_read_config_word(pdev, pdev->dpc_cap + PCI_EXP_DPC_CAP, &cap);
 	if (!(cap & PCI_EXP_DPC_CAP_RP_EXT))
-- 
2.56.0.455.g6c5a503b38-goog


