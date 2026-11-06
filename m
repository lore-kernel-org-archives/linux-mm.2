Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728CF6082BE1
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ha7Er2DA
Received: by kanga.kvack.org (Postfix)
	id 9CF856B05BA; Thu,  5 Nov 2026 19:43:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E7F6B05BB; Thu,  5 Nov 2026 19:43:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BDCE6B05BC; Thu,  5 Nov 2026 19:43:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8726B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D50AE140C4C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:05 +0000 (UTC)
X-FDA: 85402844730.04.77998FB
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2136140007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ha7Er2DA;
	spf=pass (imf12.hostedemail.com: domain of 3liLtaggKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3liLtaggKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925784;
	b=4P84SEsYXikdC35SctN6HQhSGU+G71lrSIE9KHnFa023uI95T/ujwEkWWd+S/3MbRguDDY
	DoojJWTsMqeOXN+ofzkId1H/Wu3hR7u3xnMCpFdSam+BpH8K0scHaaliMuUOeSHnbuWNNf
	KOgNdWbw6iVzPBQ2OzOW3YzgLTLBlKI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ha7Er2DA;
	spf=pass (imf12.hostedemail.com: domain of 3liLtaggKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3liLtaggKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clDl87D5pggy1VDwhZUzZxM8yGbSHZ+6BQixZZJAVUs=;
	b=vfdl2YouXSWuf92sjIy6LbYCrXyU6gHPAjEe5lPCISQj33uyRKzz5Dr9gwYcjqWpOlg7Y/
	PPlMhHp/AIEyHCO9wrZU+GJhfsLXqG9Tin4IKbJYJetNLs3ht3pdIt/ezRFdfp2FbuSH5D
	TYpv2/vYKAYB82ZEKDDDcn/S03CVZ/U=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4cc89e86e9eso85633b6e.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925783; x=1794530583; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=clDl87D5pggy1VDwhZUzZxM8yGbSHZ+6BQixZZJAVUs=;
        b=Ha7Er2DAdh/bWcH+uOmZH3rer56KVw1pSoYbQ2G5uqJg00eSYnZsVdWRK2ju/2KSIn
         hDtvTPmsmRDKYYb8hxFts0FSyyZEr11uYc94xH3GZzHYllZrwUwxWY2nA3qc3sBSHuqg
         YNzwFMUeswLGwlQlXZ1MLSxxZKi5moHRNGaTfW0NzaRAR5HQnB2TgAF8+ZmnaRdtryrH
         uM7WuGNm6ogpQEVSGCB/eEmAub+k+t7VoDKuyIKupactIDTQyf2yxPRKHUcx33KpaEAg
         7J6yUL0z0X9YcuKcDTUIsSjwhCs8FZElSh3L3oxw99SVcmk6jWUWSome4H1vvP5s/ZTt
         5gUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925783; x=1794530583;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=clDl87D5pggy1VDwhZUzZxM8yGbSHZ+6BQixZZJAVUs=;
        b=T+ZY2iHAx7Dbi4dbJlRRGKVOBRwZIvRU+5m+yAhCo2OPHD3SCsYjUHPJLu1hmKtgwF
         /qSgga+ff0txzsMEKeuWvRAxZTO3aLI717Iek5LoxYs1dujR9C6IWfXSQTMt1Gd3yh+u
         1KqqGY8Tv+/AUptSgS34WISkfIczS3p2sM5XNsq3NIB2ioWj7WrByTiy23Kjqi6qTf+d
         +8e5Q70VSvc2uIXJ9Qeb2EpS116KVlGz9vE9cJMs9E0pfF3m2vrWhp8kK3f4/YEOseco
         hZNq0oI4g1ydTo4Un3B/bZ9AN0Jo4tfjn2J4qx02TO2JR6U1Sd6g5chNJH391U07OWkM
         Dzqw==
X-Forwarded-Encrypted: i=1; AKwUvBxA4jJEbLqUkzGAVtqN6xLYP5FEwTmV/u6aVFsHP4BBh6jW/XZcozqRKQzjiqH325/GCfu/tzfnAg==@kvack.org
X-Gm-Message-State: APuU4Z98UBZTY6DIEarmj2I2H2NwYm5joCG1833rkLuHaCWc4OQU8X3D
	pFqeGJBsFiENOfr6jGXudWfawZCDVVm23DCjZNdqcUBRLOkTmwcW4k07r7OQDn+JgBdimtlBuDw
	5LKSQYW861UZXZg==
X-Received: from iofl4-n1.prod.google.com ([2002:a05:6602:8384:10b0:9e3:4909:2e0c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3197:b0:564:4f93:707f with SMTP id 5614622812f47-567e1038170mr654365b6e.24.1793925782556;
 Thu, 05 Nov 2026 16:43:02 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:06 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-6-dmatlack@google.com>
Subject: [PATCH v2 05/17] PCI: Save PCI-X state in the saved capability store
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
X-Stat-Signature: 9pege7cedd65oiyq7kch4nyqno9hnsct
X-Rspamd-Queue-Id: 2136140007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793925783-748962
X-HE-Meta: U2FsdGVkX18Ox9t7yYwEm64S5k/BPZ70JJXwqTcD8BS147sYoZH3LBnvlYdFHbdYcbiJYPL/+WXSmpSlLXU2g3EpXLTu6ZJh4xpbG3bcwx+EOoppjvjP48aUUXNlAtN3y8nK1lG0wNSXP5KMa6rlicql/Hdz4MVY1dO2Veg5q9lJr3TSL5EouF+fEZUcxAwR4RrkI5y4i6eMuQw9v4wUuPoUSH8bZslyU6iK3WhpY2zHygrN9gpIo+HbbicPmnP0VtNpW17E0oQvMiSmc2xaOH9Ar3FsbPHVXDRMksJEWgv66Ydx54CkrA4+ossLHjEq0FB219a7+yyaxdeKSoJTlV+Sue6XpJhhbDvuKCVyaaKQ6BxyWe6OP/k9WoRQaceXI/WyjOrBoJnOAqjJ0Nogd88O7xrLaE3Uqfwbf7WaLuJPMcV5r+rxg84loeqlQwJix01EyQkBgb78ohOnOcW9adQYej6SaGGISgSNcFfOFXbe65c1XYq2/6ftTL1xPsaVkD5XNYc2AU3ZjxRi+BgnKANTEqWe5QcRMkgRJZlMSu5u7zrsDH2ra/7JTf0ad63RMETGDpbFE360ygs6u7EBdupcH6wqYvEgvfdmNBSq0HUeIqy9NT6A9gXoLsRnmIaXXoxpRStKHkJCvkInIlRc6dTVeeU1UrzcLd+x0LNmSkkfyHK5MyiyWRiTzHHpn9JNp0eePf/fAsNo9VfQE0aKqlvdrYkLWFfKL572LKLFcagRcr1C/AvoZEh5secKboYQpZQpWnE184AIPa3m5wb2jocd4rEHtp4LsODCjVZXyjKUTnRgZGKJjsUwoRO7x2sZnM8FdejS8GZeMYm2Fs+qQKuTdBPHGSz6HiVNq7fw8OqT9k1ihCBcfu02LnpijVcpSwRPbl0X5fJGzRFGUs1P24wNtR+9HRtURUbLolEox0YvBRybsgxTB7cM/fdD4RC2UVg0ebICNe39J1FpUJX
 UXpSusXa
 5UhZ+0gBRXps/XkFKI8OzC3TlerXaC86F1G+F5Ct6mx/da8yNpd5PkScjhawM1IWFOiBaOCbqs9OU89bka/K9sxXrMJA22LxHON8dAsrg+iQLOoESPtFPeufRZ7tF2GQbv3ODC/HcROz8xQloAo09r8c8qP0Uc4+9/v51QZl59FHL4hngmGGORgWABdI2znzrdqpWPuu0tC011jTg/fRQWHhx0lhVkRC3c5LwY1Ip2Swz0duhuf6h9pmNe5Ji2jjIV14ZVar+EBZil51Wp+A0qLKgZ3E40TBXj0BVwZActsywkVDsIRauIbXAn/zXd3xyTKVV2qlMFU6EKc1/C9HgPD+beRkiL8k7wkjbbxTb0A5pj6E6is2Oh5SSTIR6YzY1urAf06m+EU6iRZ0Uesdzf/t1B7hFiMP25BAcZldDJ+H7vdU8WYLt9CnmktNqRvST5neAH4v1G1cz0gwIFWL9QVg5orZVAcjnaSQ6NwdrySI56joKGYdwAoRLPA/t8+ZUlmVyr2WYrvJcaF/EVDzwpe10al4Ahd1P0tcLRyk6+ZgN2C5ehA0AT4dc4wAzna1MkbfwSQB2BJLTBanE3VHS+LrqHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Save and restore the PCI-X Command register through the per-device saved
capability store instead of a private pci_cap_saved_state buffer.

Reserve the register by its configuration space offset during device
setup, in pci_reserve_pcix_state(), so that the save and restore paths
no longer have to locate a buffer.

Make pci_save_pcix_state() void, so pci_save_state() no longer fails with
-ENOMEM when the PCI-X save buffer is missing. A failure to allocate the
store is reported once during device setup instead.

No other functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pci.c | 47 ++++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index fde1dcd99e94..6cf4a64cb7e6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1900,40 +1900,40 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
 	}
 }
 
-static int pci_save_pcix_state(struct pci_dev *dev)
+static void pci_save_pcix_state(struct pci_dev *dev)
 {
 	int pos;
-	struct pci_cap_saved_state *save_state;
 
 	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
 	if (!pos)
-		return 0;
+		return;
 
-	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
-	if (!save_state) {
-		pci_err(dev, "buffer not found in %s\n", __func__);
-		return -ENOMEM;
-	}
+	pci_save_cap_word(dev, pos + PCI_X_CMD);
+}
 
-	pci_read_config_word(dev, pos + PCI_X_CMD,
-			     (u16 *)save_state->cap.data);
+static void pci_reserve_pcix_state(struct pci_dev *dev)
+{
+	int pos, rc;
 
-	return 0;
+	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
+	if (!pos)
+		return;
+
+	rc = pci_reserve_saved_cap(dev, pos + PCI_X_CMD, sizeof(u16));
+	if (rc)
+		pci_err(dev, "unable to reserve PCI-X save state (%pe)\n",
+			ERR_PTR(rc));
 }
 
 static void pci_restore_pcix_state(struct pci_dev *dev)
 {
-	int i = 0, pos;
-	struct pci_cap_saved_state *save_state;
-	u16 *cap;
+	int pos;
 
-	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
 	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
-	if (!save_state || !pos)
+	if (!pos)
 		return;
-	cap = (u16 *)&save_state->cap.data[0];
 
-	pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
+	pci_restore_cap_word(dev, pos + PCI_X_CMD);
 }
 
 /**
@@ -1953,11 +1953,7 @@ int pci_save_state(struct pci_dev *dev)
 	dev->state_saved = true;
 
 	pci_save_pcie_state(dev);
-
-	i = pci_save_pcix_state(dev);
-	if (i != 0)
-		return i;
-
+	pci_save_pcix_state(dev);
 	pci_save_dpc_state(dev);
 	pci_save_aer_state(dev);
 	pci_save_ptm_state(dev);
@@ -3749,10 +3745,7 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
 	int error;
 
 	pci_reserve_pcie_state(dev);
-
-	error = pci_add_cap_save_buffer(dev, PCI_CAP_ID_PCIX, sizeof(u16));
-	if (error)
-		pci_err(dev, "unable to preallocate PCI-X save buffer\n");
+	pci_reserve_pcix_state(dev);
 
 	error = pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_LTR,
 					    2 * sizeof(u16));
-- 
2.56.0.455.g6c5a503b38-goog


