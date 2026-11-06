Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00187606D82E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CSLgtMAX
Received: by kanga.kvack.org (Postfix)
	id 476516B05B7; Thu,  5 Nov 2026 19:43:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A496B05B9; Thu,  5 Nov 2026 19:43:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D0B6B05BA; Thu,  5 Nov 2026 19:43:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A27E6B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86A2EC0C06
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:03 +0000 (UTC)
X-FDA: 85402844646.11.6DB75FC
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf27.hostedemail.com (Postfix) with ESMTP id CB3AF40003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CSLgtMAX;
	spf=pass (imf27.hostedemail.com: domain of 3kSLtaggKCOgNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3kSLtaggKCOgNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925781;
	b=pNUoMatWi3r1AQrNrHe5MEtpsBgSjpSDFI9ZBLl0EtCjTlhkHyJ0ZraEDNBivAUm51v9Zc
	+U3VSyGGmR3FRxNaClS66ZDiWFMDpAQ8l7vZ1WpwAcj+ZeHu07+TFfOeKgZ3xaLsObHgZ5
	9HXwouVEwPPGTWmbeIxb8LnN0NS4YBw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CSLgtMAX;
	spf=pass (imf27.hostedemail.com: domain of 3kSLtaggKCOgNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3kSLtaggKCOgNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPfp4nLyt9FVdmFE1yKT2sRgCODHAPIFVB7rkcjEfkI=;
	b=fPfvSCUf9CHc9lsD2y8CDrEj2tJ/3yT0l28ZF3KAiroiMNjJ+eAzQTtx0NeoEZYrQmj8is
	N/nnb9lnoOwmE78OC3pRwZNaJiN2mpxSaR7pc98SQEyeRu9KBK9kW9+2+ggVNcOV4E3JlF
	IMGfbHrHJUSs7mmkuDc5Qt3NjEFOb6E=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b37620eb73so89753b6e.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925778; x=1794530578; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BPfp4nLyt9FVdmFE1yKT2sRgCODHAPIFVB7rkcjEfkI=;
        b=CSLgtMAX/rh8sEdGMOKVTpIc2H4IEVu1oiTz+BFN1DsjhBXWcdDoCi+R5z4u4r2qTM
         tDp2m/z3nQBAqlbT/Z+X4TdA56tJbvsLGSedrxj48pj47RUdPv2OcS+LDCe6pT9YEhK+
         3Kef0YDYdesY4jUhRAQJov+dGih67LYvrBpZLrGq53lDcjSgCHvUDPW5z0Al1G9+m+jR
         R9KbO9re8GfYxreFwITa0ZkTKf22V8Po4oXildehJl7XdWriAmV4HoLY6WyrpVGrU/2+
         yo/dpd+jWFJxzOQTI5cug0tOE3K2rUlYRA8fK2LBI55INazh2WuU/ExrvE8EtF1JjuUj
         fwhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925778; x=1794530578;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BPfp4nLyt9FVdmFE1yKT2sRgCODHAPIFVB7rkcjEfkI=;
        b=UnkhLdN1RC5kJRuxrbW0wEnokTecqVYKXNXLlZfTqn1T+uFInz0K6ySLS6SL6pbiVR
         H8pxSAJu0MlkQeryHo7LEi/U06rMZ9NkxEEtIbDMvzdijG2xikGD6asmBEBTLw1ISyUx
         qYhHcU2LJSM0CFSWW4XjO4ZOUDBKdmKF4OCm/bkUw/xNnywu45cxndS2kebVOa8/vrw1
         Z4CSERq9Nf+VRHhtYognMlGDa+mnPeNbiGmLpURajVEzvqGAKBGKqymBjm5CEHsNMF6x
         zanJzQD9DyOUoFP1k7HnGxL69kLTjoBCLf/nCEcNGpDED22L49eOV1XK89Z6uzR9yt1+
         KgNg==
X-Forwarded-Encrypted: i=1; AKwUvBxFlhJLezVWvRbj0vrUAHg1ngTmgdvq6L9WZ6ZCU52hWLk5XPttcyY4LdM0TeNAq2BYBG/YnADvqg==@kvack.org
X-Gm-Message-State: APuU4Z+712JBXAjfcyCxJXPAmIgy6yJM9t+cTQBe1LGdr4Fnj5c4RsQG
	ECDyb0TikcC8ws02kgAbd4cEnQIYCr5dTIW/dfT506cThAo1dETdna62tnTKd3fmOqSE1VYVemI
	a24cSDvtKx31oOg==
X-Received: from jahl14-n2.prod.google.com ([2002:a05:6638:8c0e:20b0:620:17bd:8c69])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2216:b0:4d6:9355:7547 with SMTP id 5614622812f47-567e1840a0cmr681897b6e.66.1793925777406;
 Thu, 05 Nov 2026 16:42:57 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:02 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-2-dmatlack@google.com>
Subject: [PATCH v2 01/17] PCI/DPC: Allocate the DPC save buffer during device setup
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
X-Rspamd-Queue-Id: CB3AF40003
X-Stat-Signature: 8cu8idz9thrguct6az8rt3e1rzhg97fx
X-Rspam-User: 
X-HE-Tag: 1793925781-472464
X-HE-Meta: U2FsdGVkX18Bhn+aTGB2FSLFhB/dXjEpC7lBwL90iFd8TOuFhN5RbyjDUKgJ9strqCWR0yXpn6jF8afkqpbrxvNbgGVpxeozljeTXI21zEhOfF2PRmGhPqQv45JFhGdifGZ1i27f464h5wTkuH8KpYiSdNcuVxqh0fWO0krjd59hCBQXpF1MY+BEyT/VNvjdIyRDFhq8fOCOsEDRFclEaAKMQsuSOlGJ5vvKeNJcDsHogb7dcE6hseYSo/1H9xqduZCwYmDAMzYlovuotqZojI7SA77iWPJjilQ4vwTazycamzCL54/ozAW3kDk1ynyACNMMbKtcOfKze2Yax79cgN26KK0ahuSK4ZVJOJMT5v/OIdc/Yn+DgY0EhkyvxQjZd5PA5GLUQP6uKAGv3d75dODI2F0TCI/gSJgS6JImOC06+mvm/MMavb+EAQBN2CFSlCmWIc+fp05CORMfYqfcJtSLcTQhhU+gjHQPFprzKuGXhJ/S4L8qO4fpUtVC0Qb5DZdeiKj6P1m1E40qECR0i2lsqYTAgmLRi/tpqTTMYOUSZvePXmkPo/Whaq1XFG+jzLGUqdOQVTUbTNc8+wb6RcgPUE5dSXa0EizinlylgmfecXUnIY8oFrYzISnkaYq1m0FwAC/9P3v1OgjBDu/KGUBjcPWsx4w2wMsFxVa11vKbQ3VbkuH8/s3gcAl7IR1yrXV4BzmJpQ/bm15EXtpBFfYk8ObFXJF98rWNJLX6P7GycgXOCYFOVtzNLZ24UidW/3CdzkwPP8RZ/2SOrq3RyUbCJqxgJgxX6iavUp9wrfHXz/c1184EHqNLDRej+c9IK+HeCz/otfmBiHGD82PVv6O0auAveBXioXFZVJbYOy+DfFyLvFqfTyZBSL2XYG+BtN9lxzJU7zQi/5tBiyYWXVg8ea73a8nxJc1PFvEYQhDYn/nkzV21avY+DXDQQcXoLbLFujOHPLgw+Dss1hw
 TltsRHL8
 3fyPjI8xoG3SO4fuHQUMfPwvO4uP07rUoTwSsX1NQLSa5BDvzWC890NlMlSBVqF6cOq3kg3JIeLsUDwbiBgOQlhHdubfThzQdoSVaKTBgPvcjREidHu8DW6fdvZZEy3LcBfVa+0j2rwU+MWWeNwbGtwYNyYtBTCCxtGhrzCo4XR+IrruEtp5I4zcpyo5gTVKSlueuABaXTgBy5cOOobEAlaDb6ScQik4SbLP2/+yQffpm8PEqn2Z2bFUZg/zckbueGdRZwonuQ8TxQGQEyBdCC+SV2eHD1J9InBNEsCHusOn/0Gu1TFhRdS/7WAOgI2C2t3q6bJ+3ZYi+lQcByWk7hlRAdRkUfsDRJT64rzBxRAFk7K3wRTTDYzz3KaZyjqNCSBTuc/+vBZRLEmPth5p5X7UszGmNUVxf0fFT0hngTJD6uKjcM6OmSTN6zEiAIbe9sAikb80dl7qYIl5YfMIXlNR1uqdmjFs1CihJMmDPEnEcR+EvXJbKEeoaKcWkI4q60HPhE9t7sASxUdCMYZRsXsz6zJHPDiLNSOe9BSHStsVHcPKh5LH2RWGt2fR7bOK9akQ3qjibzpg5XLnSZ5l7VrgAzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allocate the DPC capability's save buffer in pci_dpc_init() rather than
in dpc_probe(), and report an allocation failure, which dpc_probe()
ignored.

dpc_probe() runs when the portdrv DPC service binds to a port, which is
long after the device has been added, and does not happen at all if the
service is not enabled. Until then pci_save_dpc_state() silently saves
nothing, so a reset in that window loses the DPC Control register.

Allocating during device setup makes buffer existence depend only on the
capability being present, which is what the save and restore paths
already assume. It also puts every capability save buffer in one phase
of a device's life, which a later patch relies on.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pcie/dpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index 2b779bd1d861..b7f79266f66d 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -408,6 +408,9 @@ void pci_dpc_init(struct pci_dev *pdev)
 	if (!pdev->dpc_cap)
 		return;
 
+	if (pci_add_ext_cap_save_buffer(pdev, PCI_EXT_CAP_ID_DPC, sizeof(u16)))
+		pci_err(pdev, "unable to allocate suspend buffer for DPC\n");
+
 	pci_read_config_word(pdev, pdev->dpc_cap + PCI_EXP_DPC_CAP, &cap);
 	if (!(cap & PCI_EXP_DPC_CAP_RP_EXT))
 		return;
@@ -499,7 +502,6 @@ static int dpc_probe(struct pcie_device *dev)
 		 FLAG(cap, PCI_EXP_DPC_CAP_SW_TRIGGER), pdev->dpc_rp_log_size,
 		 FLAG(cap, PCI_EXP_DPC_CAP_DL_ACTIVE));
 
-	pci_add_ext_cap_save_buffer(pdev, PCI_EXT_CAP_ID_DPC, sizeof(u16));
 	return status;
 }
 
-- 
2.56.0.455.g6c5a503b38-goog


